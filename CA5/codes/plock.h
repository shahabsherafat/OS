// plock.h
#ifndef XV6_PLOCK_H
#define XV6_PLOCK_H

#include "spinlock.h"

struct proc;  

// Each waiting process is represented as one node in the wait-list.
struct plock_node {
  struct proc *p;          
  int priority;            
  struct plock_node *next; // next node in wait-list
};

// Priority lock structure.
struct plock {
  struct spinlock lk;      
  int locked;              // 0 = free, 1 = held
  struct proc *owner;      // (handoff safety)
  struct plock_node *head;
};

extern struct plock plock_global;

void init_plock(struct plock *pl);
void plock_acquire(struct plock *pl, int priority);
void release_plock(struct plock *pl);

#endif
