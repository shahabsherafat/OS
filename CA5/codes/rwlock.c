#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "rwlock.h"


void
rwlock_init(struct rwlock *rw, char *name)
{
  initlock(&rw->lk, "rwlock");
  rw->num_of_readers = 0;
  rw->writer = 0;
  rw->num_of_waiting_writers = 0;
  rw->name = name;
  rw->wpid = 0;
}

void
rwlock_acquire_read(struct rwlock *rw)
{
  acquire(&rw->lk);

  // If a writer is active OR writers are waiting (writer preference),
  // num_of_readers must sleep.
  while(rw->writer || rw->num_of_waiting_writers > 0){
    sleep(rw, &rw->lk);
  }

  rw->num_of_readers++;
  release(&rw->lk);
}

void
rwlock_release_read(struct rwlock *rw)
{
  acquire(&rw->lk);

  if(rw->num_of_readers < 1)
    panic("rwlock_release_read: num_of_readers underflow");

  rw->num_of_readers--;

  // If this was the last reader, wake up waiting writer.
  if(rw->num_of_readers == 0)
    wakeup(rw);

  release(&rw->lk);
}

void
rwlock_acquire_write(struct rwlock *rw)
{
  acquire(&rw->lk);

  rw->num_of_waiting_writers++;

  // Writer needs exclusive access: no writer and no num_of_readers.
  while(rw->writer || rw->num_of_readers > 0){
    sleep(rw, &rw->lk);
  }

  rw->num_of_waiting_writers--;
  rw->writer = 1;
  rw->wpid = myproc()->pid;

  release(&rw->lk);
}

void
rwlock_release_write(struct rwlock *rw)
{
  acquire(&rw->lk);

  if(rw->writer == 0)
    panic("rwlock_release_write: no writer");

  if(rw->wpid != myproc()->pid)
    panic("rwlock_release_write: not owner");

  rw->writer = 0;
  rw->wpid = 0;

  // Wake everyone; num_of_readers/writers will re-check conditions.
  wakeup(rw);

  release(&rw->lk);
}


static struct rwlock u_rw;
static int u_rw_inited = 0;

static void
rw_init_once(void)
{
  if(!u_rw_inited){
    rwlock_init(&u_rw, "user_rwlock");
    u_rw_inited = 1;
  }
}

int
sys_rwlock_rlock(void)
{
  rw_init_once();
  rwlock_acquire_read(&u_rw);
  return 0;
}

int
sys_rwlock_runlock(void)
{
  rw_init_once();
  rwlock_release_read(&u_rw);
  return 0;
}

int
sys_rwlock_wlock(void)
{
  rw_init_once();
  rwlock_acquire_write(&u_rw);
  return 0;
}

int
sys_rwlock_wunlock(void)
{
  rw_init_once();
  rwlock_release_write(&u_rw);
  return 0;
}
