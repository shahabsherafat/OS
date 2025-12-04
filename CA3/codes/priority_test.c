#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

static void cpu_intensive(const char *tag){
  volatile uint x = 0;

  for (uint i = 0; i < 300000000; i++)
    x += i;

  printf(1, "%s: done (pid=%d)\n", tag, getpid());
}

int
main(int argc, char **argv)
{
  int p1 = fork();
  if(p1 == 0){
    cpu_intensive("LOW");
    exit();
  }

  int p2 = fork();
  if(p2 == 0){
    cpu_intensive("HIGH");
    exit();
  }

  sleep(10);
  int old1 = set_priority_syscall(p1, 2); // LOW
  int old2 = set_priority_syscall(p2, 0); // HIGH
  printf(1, "set priority: pid=%d old=%d new=%d | pid=%d old=%d new=%d\n",
         p1, old1, 2, p2, old2, 0);

  wait(); wait();
  exit();
}
