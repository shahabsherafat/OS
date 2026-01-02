#ifndef _SPINLOCK_H_
#define _SPINLOCK_H_

// Mutual exclusion lock.
struct spinlock {
  uint locked;       // Is the lock held?

  // For debugging:
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
  uint pcs[10];      // The call stack (an array of program counters)
                     // that locked the lock.
  
  uint count_acq[NCPU];    
  uint spins_total[NCPU];  

};

#endif