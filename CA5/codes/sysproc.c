#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "plock.h"
#include "cpt.h"


int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_show_process_family(void)
{
  int pid;
  if (argint(0, &pid) < 0) 
    {
      return -1;
    }
  return process_family(pid);
}

int
sys_simple_arithmetic(void)
{
  struct proc *p = myproc();
  int a = p->tf->ebx; 
  int b = p->tf->ecx;

  int sum = a + b;
  int diff = a - b;
  int res = sum * diff;

  cprintf("simple_arith: a=%d b=%d -> (%d+%d)*(%d-%d) = %d\n",a, b, a, b, a, b, res);

  return res;
}

int
sys_set_priority_syscall(void)
{
  int pid, prio;
  if(argint(0, &pid)  < 0) return -1;
  if(argint(1, &prio) < 0) return -1;
  return set_priority(pid, prio);
}

int
sys_acquire_plock_sys(void)
{
  int pr;
  if(argint(0, &pr) < 0)
    return -1;
  plock_acquire(&plock_global, pr);
  return 0;
}

int
sys_release_plock_sys(void)
{
  release_plock(&plock_global);
  return 0;
}


extern struct spinlock tickslock;

int
sys_getlockstat(void)
{
  uint *score_ptr;
  if(argptr(0, (char**)&score_ptr, NCPU * sizeof(uint)) < 0)
    return -1;

  for(int i = 0; i < NCPU; i++){
    if(tickslock.count_acq[i] == 0)
      score_ptr[i] = 0;
    else

      score_ptr[i] = tickslock.spins_total[i] / tickslock.count_acq[i];
  }
  return 0;
}

int
sys_vread(void)
{
  int addr, value;
  if(argint(0, &addr) < 0)
    return -1;
  if(cpt_read_int(myproc(), (uint)addr, &value) < 0)
    return -1;
  return value;
}

int
sys_vwrite(void)
{
  int addr, value;
  if(argint(0, &addr) < 0) return -1;
  if(argint(1, &value) < 0) return -1;
  if(cpt_write_int(myproc(), (uint)addr, value) < 0)
    return -1;
  return 0;
}

int
sys_cptsetpolicy(void)
{
  int pol;
  if(argint(0, &pol) < 0)
    return -1;
  cpt_set_policy(pol);
  return 0;
}

int
sys_cptresetstats(void)
{
  struct proc *p = myproc();
  cpt_reset_stats(p->pid);
  return 0;
}

int
sys_cptgetstats(void)
{
  struct cpt_stats *u;
  if(argptr(0, (void*)&u, sizeof(*u)) < 0)
    return -1;

  struct cpt_stats ks;
  cpt_get_stats(&ks);
  if(copyout(myproc()->pgdir, (uint)u, (char*)&ks, sizeof(ks)) < 0)
    return -1;

  return 0;
}