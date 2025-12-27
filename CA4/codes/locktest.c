#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"

int main() {
  uint scores[NCPU];
  
  printf(1, "Initial Stats:\n");
  getlockstat(scores);

  for(volatile int i=0; i<NCPU; i++) 
    printf(1, "CPU %d: %d\n", i, scores[i]);

  for(volatile i=0; i<4; i++) {
    if(fork() == 0) {

      for(volatile int j=0; j<1000; j++) {

          uptime();
          if(j%10==0)
            sleep(1); 
      }
      exit();
    }
  }

  for(volatile int i=0; i<4; i++) 
    wait();

  printf(1, "\nFinal Stats after load:\n");

  getlockstat(scores);

  for(volatile i=0; i<NCPU; i++) 
    printf(1, "CPU %d: %d\n", i, scores[i]);

  exit();
}

