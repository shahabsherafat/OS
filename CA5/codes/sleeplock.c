// Sleeping locks

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);

  if(lk->locked == 0)
    panic("releasesleep: lock is not held");

  if(lk->pid != myproc()->pid)
    panic("releasesleep: not owner");

  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);

  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  release(&lk->lk);
  return r;
}

static struct sleeplock testlk;
static int testlk_inited = 0;

int
sys_sleeplock_hold(void)
{
  if(!testlk_inited){
    initsleeplock(&testlk, "testlk");
    testlk_inited = 1;
  }
  acquiresleep(&testlk);
  return 0;
}

int
sys_sleeplock_drop(void)
{
  if(!testlk_inited){
    initsleeplock(&testlk, "testlk");
    testlk_inited = 1;
  }
  releasesleep(&testlk);
  return 0;
}
