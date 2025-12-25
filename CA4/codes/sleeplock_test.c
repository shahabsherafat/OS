#include "types.h"
#include "user.h"

int
main(void)
{
  int pid;

  // Parent acquires the sleeplock in the kernel
  printf(1, "locktest: parent holds sleeplock\n");
  sleeplock_hold();

  // Create child process
  pid = fork();
  if(pid < 0){
    printf(1, "locktest: fork failed\n");
    exit();
  }

  if(pid == 0){
    // Child tries to release a lock it does NOT own.
    // This should trigger a kernel panic.
    printf(1, "locktest: child tries to drop (should panic)\n");
    sleeplock_drop();

    // If execution reaches here, the lock ownership check failed.
    printf(1, "locktest: ERROR: child returned (panic expected)\n");
    exit();
  }

  // If the kernel panics, execution will never reach here.
  // This wait is only relevant if the policy is non-fatal.
  wait();

  // If the kernel did not panic, the parent releases the lock.
  sleeplock_drop();

  exit();
}
