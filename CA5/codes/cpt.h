#ifndef XV6_CPT_H
#define XV6_CPT_H

// Central Page Table (CPT): a tiny, global 4-frame cache of pages.

#include "types.h"
#include "spinlock.h"

#define CPT_SIZE 4

struct proc;

struct cpt_entry {
  int   valid;   // 0 = empty, 1 = contains a (pid,vpn) page
  int   pid;     // owner process id
  uint  vpn;     // virtual page number
  char *frame;   // pointer to the physical page (kalloc'd once at boot)

  // replacement algorithms).
  uint  last_used;
  uint  freq;
  uint  refbit;
  uint  fifo_age;
};

struct cpt {
  struct spinlock lock;
  struct cpt_entry e[CPT_SIZE];
  int clock_hand; // used later by the CLOCK algorithm
};

void cpt_init(void);
int  cpt_lookup(int pid, uint vpn);
int  cpt_find_free(void);
void cpt_invalidate_pid(int pid);
// This is added for debugging
void cpt_dump(void);

int cpt_vread(struct proc *p, uint va, int *out);
int cpt_vwrite(struct proc *p, uint va, int value);

#endif
