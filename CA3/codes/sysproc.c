#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

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
sys_start_throughput(void)
{
  acquire(&tickslock);
  throughput_start_tick = ticks;
  release(&tickslock);

  throughput_finished_procs = 0;
  is_measuring_throughput = 1;

  return 0;
}

int
sys_end_throughput(void)
{
  uint start, end, diff;
  int procs;

  acquire(&tickslock);
  start = throughput_start_tick;
  end   = ticks;
  release(&tickslock);

  is_measuring_throughput = 0;

  diff  = end - start;

  if(diff == 0)
    diff = 1;

  int th_per_tick = throughput_finished_procs * 1000 / diff;

  // cprintf("Throughput: %d procs in %d ticks (~%d procs/tick)\n",
  //         throughput_finished_procs, diff, th_per_tick);

  return th_per_tick;
}


