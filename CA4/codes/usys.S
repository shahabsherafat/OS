#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(make_duplicate_file)
SYSCALL(show_process_family)
SYSCALL(simple_arithmetic_syscall)
SYSCALL(grep_syscall)
SYSCALL(set_priority_syscall)
SYSCALL(sleeplock_hold)
SYSCALL(sleeplock_drop)
SYSCALL(rwlock_rlock)
SYSCALL(rwlock_runlock)
SYSCALL(rwlock_wlock)
SYSCALL(rwlock_wunlock)
SYSCALL(acquire_plock_sys)
SYSCALL(release_plock_sys)

SYSCALL(getlockstat)



