// plock_demo.c
#include "types.h"
#include "stat.h"
#include "user.h"

static void
busy_wait(int loops)
{
  volatile int x = 0;
  for(int i = 0; i < loops; i++){
    x += i;
  }
}

int
main(void)
{
  int holder_pr = 1;
  int prios[] = { 40, 10, 50, 20, 30 };
  int n = sizeof(prios) / sizeof(prios[0]);

  printf(1, "\n[plock_demo] Starting (PID %d)\n", getpid());

  int holder = fork();
  if(holder < 0){
    printf(1, "[plock_demo] fork failed\n");
    exit();
  }

  if(holder == 0){
    acquire_plock_sys(holder_pr);
    printf(1, "[plock_demo] HOLDER acquired lock | pid=%d pr=%d\n", getpid(), holder_pr);

    sleep(200);

    printf(1, "[plock_demo] HOLDER releasing lock | pid=%d pr=%d\n", getpid(), holder_pr);
    release_plock_sys();

    exit();
  }

  sleep(50);

  for(int i = 0; i < n; i++){
    int pr = prios[i];
    int pid = fork();

    if(pid < 0){
      printf(1, "[plock_demo] fork failed at i=%d\n", i);
      continue;
    }

    if(pid == 0){
      printf(1, "[plock_demo] waiter started | pid=%d pr=%d\n", getpid(), pr);

      acquire_plock_sys(pr);
      printf(1, "[plock_demo] >>> waiter ACQUIRED | pid=%d pr=%d\n", getpid(), pr);

      busy_wait(2000000);

      printf(1, "[plock_demo] waiter releasing | pid=%d pr=%d\n", getpid(), pr);
      release_plock_sys();

      exit();
    }

    sleep(10);
  }

  for(int i = 0; i < n + 1; i++){
    wait();
  }

  printf(1, "[plock_demo] Done.\n\n");
  exit();
}
