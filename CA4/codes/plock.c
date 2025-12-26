// plock.c
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "plock.h"


// One global lock instance (lab says one global lock is enough).
struct plock plock_global;

void
init_plock(struct plock *pl)
{
  initlock(&pl->lk, "plock");
  pl->locked = 0;
  pl->owner = 0;
  pl->head = 0;
}

// Acquire with a given priority.
// If busy, enqueue current process + sleep.
// When it wakes, it must already "own" the lock (handoff).
void
plock_acquire(struct plock *pl, int priority)
{
  struct proc *cur = myproc();

  acquire(&pl->lk);

  // If free, take it immediately.
  if(pl->locked == 0){
    pl->locked = 1;
    pl->owner = cur;
    release(&pl->lk);
    return;
  }

  // Lock is busy => create a wait-node for this process.
  struct plock_node *n = (struct plock_node*)kalloc();
  if(n == 0){
    // Out of memory; simplest policy: release and panic.
    release(&pl->lk);
    panic("plock_acquire: kalloc failed");
  }

  n->p = cur;
  n->priority = priority;
  n->next = pl->head;
  pl->head = n;

  // Sleep on a unique channel (the proc pointer).
  // sleep(chan, &pl->lk) will:
  //  - atomically release pl->lk
  //  - put process to sleep
  //  - re-acquire pl->lk when it wakes
  for(;;){
    sleep(cur, &pl->lk);

    // We only proceed when lock has been handed off to us.
    if(pl->owner == cur)
      break;
  }

  // At this point, we own the lock (handoff complete).
  release(&pl->lk);
}

void
release_plock(struct plock *pl)
{
  acquire(&pl->lk);

  // If no one is waiting, unlock fully.
  if(pl->head == 0){
    pl->locked = 0;
    pl->owner = 0;
    release(&pl->lk);
    return;
  }

  // Find the node with maximum priority (queue doesn't need to be sorted).
  struct plock_node *best = pl->head;
  struct plock_node *best_prev = 0;

  struct plock_node *prev = 0;
  struct plock_node *cur = pl->head;

  while(cur != 0){
    if(cur->priority > best->priority){
      best = cur;
      best_prev = prev;
    }
    prev = cur;
    cur = cur->next;
  }

  // Remove best from the list.
  if(best_prev == 0){
    // best is head
    pl->head = best->next;
  } else {
    best_prev->next = best->next;
  }

  // Direct handoff: keep locked=1, just change owner to selected process.
  pl->locked = 1;
  pl->owner = best->p;

  // Wake only the selected process (not everyone).
  wakeup(best->p);

  // Free the node memory (no longer needed).
  kfree((char*)best);

  release(&pl->lk);
}
