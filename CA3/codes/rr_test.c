#include "types.h"
#include "stat.h"
#include "user.h"

#define NCHILD  3
#define WORK    50000000

void busy(char tag)
{
  volatile int i;
  for(i = 0; i < WORK; i++){
    if(i % 8000000 == 0){
      print_process_info();  
      printf(1, "%c ", tag);
    }
  }
}

int main(void)
{
  int i, pid;

  printf(1, "RR test starting on E-core...\n");
  start_throughput();

  for(i = 0; i < NCHILD; i++){
    pid = fork();
    if(pid == 0){
      busy('A' + i);
      exit();
    }
  }

  while(wait() > 0)
    ;

  int th = end_throughput();
  printf(1, "\nThroughput = %d\n", th);

  exit();
}
