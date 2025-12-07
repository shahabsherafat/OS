#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int n = 20;

  start_throughput();
  
  for(int i = 0; i < n; i++){
    int pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(pid == 0){
      volatile int j;

      for(j = 0; j < 100000000; j++)
        ;
      exit();
    }
  }

  while(wait() > 0)
    ;

  int th = end_throughput();

  printf(1, "user: throughput return value = %d\n", th);

  exit();
}
