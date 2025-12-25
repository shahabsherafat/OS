#ifndef _RWLOCK_H_
#define _RWLOCK_H_

#include "spinlock.h"

struct rwlock {
  struct spinlock lk;     // protects internal fields below
  int num_of_readers;            // number of active readers
  int writer;             // 1 if a writer holds the lock, else 0
  int num_of_waiting_writers;    // number of writers waiting (for fairness / writer preference)

  char *name;
  int wpid;               // pid of writer holding lock (0 if none)
};

void rwlock_init(struct rwlock *rw, char *name);
void rwlock_acquire_read(struct rwlock *rw);
void rwlock_release_read(struct rwlock *rw);
void rwlock_acquire_write(struct rwlock *rw);
void rwlock_release_write(struct rwlock *rw);

#endif
