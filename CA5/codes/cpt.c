#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "cpt.h"

// Global central page table.
static struct cpt g_cpt;

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

