#include "types.h"
#include "param.h"     
#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "cpt.h"


// Global central page table.
static struct cpt g_cpt;

extern char* uva2ka(pde_t *pgdir, char *uva);


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

void
cpt_init(void)
{
  int i;
  initlock(&g_cpt.lock, "cpt");
  g_cpt.clock_hand = 0;

  for(i = 0; i < CPT_SIZE; i++){
    g_cpt.e[i].frame = kalloc();
    if(g_cpt.e[i].frame == 0)
      panic("cpt_init: kalloc failed");

    // Optional: start with a clean page for easier debugging.
    memset(g_cpt.e[i].frame, 0, PGSIZE);

    entry_reset(&g_cpt.e[i]);
  }
}

int
cpt_lookup(int pid, uint vpn)
{
  int i;
  int idx = -1;

  acquire(&g_cpt.lock);
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn){
      idx = i;
      break;
    }
  }
  release(&g_cpt.lock);
  return idx;
}

int
cpt_find_free(void)
{
  int i;
  int idx = -1;

  acquire(&g_cpt.lock);
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid == 0){
      idx = i;
      break;
    }
  }
  release(&g_cpt.lock);
  return idx;
}

void
cpt_invalidate_pid(int pid)
{
  int i;
  acquire(&g_cpt.lock);
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid && g_cpt.e[i].pid == pid){
      entry_reset(&g_cpt.e[i]);
    }
  }
  release(&g_cpt.lock);
}

void
cpt_dump(void)
{
  int i;
  acquire(&g_cpt.lock);
  cprintf("[cpt] dump:\n");
  for(i = 0; i < CPT_SIZE; i++){
    cprintf("  slot %d: valid=%d pid=%d vpn=%d frame=%p\n",i,g_cpt.e[i].valid,g_cpt.e[i].pid,g_cpt.e[i].vpn,g_cpt.e[i].frame);
  }
  release(&g_cpt.lock);
}

static int
cpt_lookup_nolock(int pid, uint vpn)
{
  int i;
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
      return i;
  }
  return -1;
}

static int
cpt_find_free_nolock(void)
{
  int i;
  for(i = 0; i < CPT_SIZE; i++){
    if(g_cpt.e[i].valid == 0)
      return i;
  }
  return -1;
}


static char*
user_va_page_to_kva(struct proc *p, uint user_va_page)
{
  return uva2ka(p->pgdir, (char*)user_va_page);
}


static void
cpt_load_page_into_slot(struct proc *p, uint vpn, int slot_index)
{
  uint user_va_page = vpn * PGSIZE;
  char *kpage = user_va_page_to_kva(p, user_va_page);

  // Assume caller already checked kpage != 0 and holds g_cpt.lock
  memmove(g_cpt.e[slot_index].frame, kpage, PGSIZE);

  g_cpt.e[slot_index].valid = 1;
  g_cpt.e[slot_index].pid   = p->pid;
  g_cpt.e[slot_index].vpn   = vpn;

  // metadata reset (for Part 3)
  g_cpt.e[slot_index].last_used = 0;
  g_cpt.e[slot_index].freq      = 0;
  g_cpt.e[slot_index].refbit    = 0;
  g_cpt.e[slot_index].fifo_age  = 0;
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

  slot = cpt_lookup_nolock(p->pid, vpn);
  if(slot >= 0){
    release(&g_cpt.lock);
    return slot;
  }

  slot = cpt_find_free_nolock();
  if(slot < 0){
    release(&g_cpt.lock);
    return -1;
  }

  cpt_load_page_into_slot(p, vpn, slot);

  release(&g_cpt.lock);
  return slot;
}

int
cpt_read_int(struct proc *p, uint user_va, int *out)
{
  uint vpn, off;
  int slot;

  if(p == 0 || out == 0)
    return -1;
  if(user_va + 4 > p->sz)
    return -1;

  vpn = user_va / PGSIZE;
  off = user_va % PGSIZE;

  if(off + 4 > PGSIZE)
    return -1;

  slot = cpt_get_slot_for_page(p, vpn);
  if(slot < 0)
    return -1;

  acquire(&g_cpt.lock);
  memmove(out, g_cpt.e[slot].frame + off, 4);
  release(&g_cpt.lock);

  return 0;
}

int
cpt_write_int(struct proc *p, uint user_va, int value)
{
  uint vpn, off;
  int slot;
  char *kpage;

  if(p == 0)
    return -1;
  if(user_va + 4 > p->sz)
    return -1;

  vpn = user_va / PGSIZE;
  off = user_va % PGSIZE;

  if(off + 4 > PGSIZE)
    return -1;

  slot = cpt_get_slot_for_page(p, vpn);
  if(slot < 0)
    return -1;

  // write CPT copy
  acquire(&g_cpt.lock);
  memmove(g_cpt.e[slot].frame + off, &value, 4);
  release(&g_cpt.lock);

  // write-through to real user page (Part 2 simplicity)
  kpage = user_va_page_to_kva(p, vpn * PGSIZE);
  if(kpage == 0)
    return -1;
  memmove(kpage + off, &value, 4);

  return 0;
}
