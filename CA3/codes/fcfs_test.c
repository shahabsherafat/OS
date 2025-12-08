#include "types.h"
#include "stat.h"
#include "user.h"

#define NCHILD 3
#define WORK   70000000

void cpu_job(int id)
{
  volatile int i;

  printf(1, "Child %d START\n", id);
  print_process_info();

  for(i = 0; i < WORK; i++){
    if(i % 15000000 == 0){
      print_process_info();
    }
  }

  printf(1, "Child %d DONE\n", id);
}

int main(void)
{
  int i, pid;

  printf(1, "FCFS test starting on P-core...\n");
  start_throughput();

  for(i = 0; i < NCHILD; i++){
    pid = fork();
    if(pid == 0){
      cpu_job(i);
      exit();
    }
  }

  while(wait() > 0)
    ;

  int th = end_throughput();
  printf(1, "\nThroughput = %d\n", th);

  exit();
}
