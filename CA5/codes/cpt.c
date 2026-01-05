#include "types.h"
#include "param.h"
#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "cpt.h"

#define CPT_FIFO 0
#define CPT_LRU 1
#define CPT_LFU 2
#define CPT_CLOCK 3

static struct cpt_stats g_stats;
static int stats_pid = -1;

static int cpt_policy = CPT_LFU;
static uint cpt_stamp = 1; // logical time for LRU/FIFO timestamps

// Global central page table.
static struct cpt g_cpt;
static void cpt_touch_slot_nolock(int idx);
static void cpt_init_slot_meta_nolock(int idx);
static int cpt_pick_victim_nolock(void);

extern char *uva2ka(pde_t *pgdir, char *uva);

static void
entry_reset(struct cpt_entry *ent)
{
  ent->valid = 0;
  ent->pid = -1;
  ent->vpn = 0;
  // Keep ent->frame as-is (allocated once at boot).
  ent->last_used = 0;
  ent->freq = 0;
  ent->refbit = 0;
  ent->fifo_age = 0;
}

void cpt_init(void)
{
  int i;
  initlock(&g_cpt.lock, "cpt");
  g_cpt.clock_hand = 0;

  for (i = 0; i < CPT_SIZE; i++)
  {
    g_cpt.e[i].frame = kalloc();
    if (g_cpt.e[i].frame == 0)
      panic("cpt_init: kalloc failed");

    // Optional: start with a clean page for easier debugging.
    memset(g_cpt.e[i].frame, 0, PGSIZE);

    entry_reset(&g_cpt.e[i]);
  }
}

int cpt_lookup(int pid, uint vpn)
{
  int i;
  int idx = -1;

  acquire(&g_cpt.lock);
  for (i = 0; i < CPT_SIZE; i++)
  {
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
    {
      idx = i;
      break;
    }
  }
  release(&g_cpt.lock);
  return idx;
}

int cpt_find_free(void)
{
  int i;
  int idx = -1;

  acquire(&g_cpt.lock);
  for (i = 0; i < CPT_SIZE; i++)
  {
    if (g_cpt.e[i].valid == 0)
    {
      idx = i;
      break;
    }
  }
  release(&g_cpt.lock);
  return idx;
}

void cpt_invalidate_pid(int pid)
{
  int i;
  acquire(&g_cpt.lock);
  for (i = 0; i < CPT_SIZE; i++)
  {
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid)
    {
      entry_reset(&g_cpt.e[i]);
    }
  }
  release(&g_cpt.lock);
}

void cpt_dump(void)
{
  int i;
  acquire(&g_cpt.lock);
  cprintf("[cpt] dump:\n");
  for (i = 0; i < CPT_SIZE; i++)
  {
    cprintf("  slot %d: valid=%d pid=%d vpn=%d frame=%p\n", i, g_cpt.e[i].valid, g_cpt.e[i].pid, g_cpt.e[i].vpn, g_cpt.e[i].frame);
  }
  release(&g_cpt.lock);
}

static int
cpt_lookup_nolock(int pid, uint vpn)
{
  int i;
  for (i = 0; i < CPT_SIZE; i++)
  {
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
      return i;
  }
  return -1;
}

static int
cpt_find_free_nolock(void)
{
  int i;
  for (i = 0; i < CPT_SIZE; i++)
  {
    if (g_cpt.e[i].valid == 0)
      return i;
  }
  return -1;
}

static char *
user_va_page_to_kva(struct proc *p, uint user_va_page)
{
  return uva2ka(p->pgdir, (char *)user_va_page);
}

static int
cpt_get_slot_for_page(struct proc *p, uint vpn)
{
  uint user_va_page = vpn * PGSIZE;
  char *kpage = user_va_page_to_kva(p, user_va_page);
  int slot;

  if(kpage == 0)
    return -1;

  acquire(&g_cpt.lock);

  if(p->pid == stats_pid)
    g_stats.accesses++;

  // HIT?
  slot = cpt_lookup_nolock(p->pid, vpn);
  if(slot >= 0){
    if(p->pid == stats_pid)
      g_stats.hits++;
    cpt_touch_slot_nolock(slot);
    release(&g_cpt.lock);
    return slot;
  }

  // MISS
  if(p->pid == stats_pid)
    g_stats.misses++;

  slot = cpt_find_free_nolock();

  if(slot < 0){
    // FULL => eviction
    if(p->pid == stats_pid)
      g_stats.evictions++;

    slot = cpt_pick_victim_nolock();
  }

  memmove(g_cpt.e[slot].frame, kpage, PGSIZE);
  g_cpt.e[slot].valid = 1;
  g_cpt.e[slot].pid   = p->pid;
  g_cpt.e[slot].vpn   = vpn;

  cpt_init_slot_meta_nolock(slot);

  release(&g_cpt.lock);
  return slot;
}


int cpt_read_int(struct proc *p, uint user_va, int *out)
{
  uint vpn, off;
  int slot;

  if (p == 0 || out == 0)
    return -1;
  if (user_va + 4 > p->sz)
    return -1;

  vpn = user_va / PGSIZE;
  off = user_va % PGSIZE;

  if (off + 4 > PGSIZE)
    return -1;

  slot = cpt_get_slot_for_page(p, vpn);
  if (slot < 0)
    return -1;

  acquire(&g_cpt.lock);
  memmove(out, g_cpt.e[slot].frame + off, 4);
  release(&g_cpt.lock);

  return 0;
}

int cpt_write_int(struct proc *p, uint user_va, int value)
{
  uint vpn, off;
  int slot;
  char *kpage;

  if (p == 0)
    return -1;
  if (user_va + 4 > p->sz)
    return -1;

  vpn = user_va / PGSIZE;
  off = user_va % PGSIZE;

  if (off + 4 > PGSIZE)
    return -1;

  slot = cpt_get_slot_for_page(p, vpn);
  if (slot < 0)
    return -1;

  // write CPT copy
  acquire(&g_cpt.lock);
  memmove(g_cpt.e[slot].frame + off, &value, 4);
  release(&g_cpt.lock);

  // write-through to real user page (Part 2 simplicity)
  kpage = user_va_page_to_kva(p, vpn * PGSIZE);
  if (kpage == 0)
    return -1;
  memmove(kpage + off, &value, 4);

  return 0;
}

static void
cpt_touch_slot_nolock(int idx)
{
  // for LRU
  g_cpt.e[idx].last_used = cpt_stamp++;

  // for LFU
  g_cpt.e[idx].freq++;

  // for CLOCK
  g_cpt.e[idx].refbit = 1;
}

static void
cpt_init_slot_meta_nolock(int idx)
{
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
  g_cpt.e[idx].last_used = cpt_stamp++; // LRU start time
  g_cpt.e[idx].freq = 1;                // LFU initial
  g_cpt.e[idx].refbit = 1;              // CLOCK: recently used
}

static int
cpt_pick_victim_nolock(void)
{
  int i, victim = 0;

  if (cpt_policy == CPT_FIFO)
  {
    uint best = g_cpt.e[0].fifo_age;
    for (i = 1; i < CPT_SIZE; i++)
    {
      if (g_cpt.e[i].fifo_age < best)
      {
        best = g_cpt.e[i].fifo_age;
        victim = i;
      }
    }
    return victim;
  }

  if (cpt_policy == CPT_LRU)
  {
    uint best = g_cpt.e[0].last_used;
    for (i = 1; i < CPT_SIZE; i++)
    {
      if (g_cpt.e[i].last_used < best)
      {
        best = g_cpt.e[i].last_used;
        victim = i;
      }
    }
    return victim;
  }

  if (cpt_policy == CPT_LFU)
  {
    uint bestf = g_cpt.e[0].freq;
    uint bestt = g_cpt.e[0].last_used; // tie-breaker with older last_used
    for (i = 1; i < CPT_SIZE; i++)
    {
      if (g_cpt.e[i].freq < bestf ||
          (g_cpt.e[i].freq == bestf && g_cpt.e[i].last_used < bestt))
      {
        bestf = g_cpt.e[i].freq;
        bestt = g_cpt.e[i].last_used;
        victim = i;
      }
    }
    return victim;
  }

  // CPT_CLOCK
  for (;;)
  {
    int h = g_cpt.clock_hand;
    if (g_cpt.e[h].refbit == 0)
    {
      victim = h;
      g_cpt.clock_hand = (h + 1) % CPT_SIZE;
      return victim;
    }
    g_cpt.e[h].refbit = 0;
    g_cpt.clock_hand = (h + 1) % CPT_SIZE;
  }
}

void
cpt_set_policy(int policy)
{
  acquire(&g_cpt.lock);
  cpt_policy = policy;
  release(&g_cpt.lock);
}

void
cpt_reset_stats(int pid)
{
  acquire(&g_cpt.lock);

  // flush CPT entries for this pid for fair benchmarking
  int i;
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid && g_cpt.e[i].pid == pid){
      entry_reset(&g_cpt.e[i]);
    }
  }

  // reset meta
  g_cpt.clock_hand = 0;
  cpt_stamp = 1;

  // reset stats
  stats_pid = pid;
  g_stats.accesses = 0;
  g_stats.hits = 0;
  g_stats.misses = 0;
  g_stats.evictions = 0;
  g_stats.policy = cpt_policy;

  release(&g_cpt.lock);
}


void
cpt_get_stats(struct cpt_stats *out)
{
  acquire(&g_cpt.lock);
  g_stats.policy = cpt_policy;
  *out = g_stats;
  release(&g_cpt.lock);
}

