#include "types.h"
#include "stat.h"
#include "user.h"

void consume_cpu_ticks(int loops) {
    int i, j;
    volatile int temp = 0; 
    
    for(i = 0; i < loops; i++) {
        for(j = 0; j < 10000; j++) {
            temp += 1;
            temp -= 1;
        }
    }
}

int main(int argc, char *argv[]) {
    int n_proc = 5; 
    int pid;
    int i;


    for(i = 0; i < n_proc; i++) {
        pid = fork();
        
        if(pid < 0) {
            printf(1, "Fork failed!\n");
            exit();
        }
        
        if(pid == 0) {
            int child_pid = getpid();
            
            consume_cpu_ticks(500);
            
            exit();
        }
    }

    for(i = 0; i < n_proc; i++) {
        wait();
    }

    exit();
}