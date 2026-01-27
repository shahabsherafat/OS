#include "types.h"
#include "user.h"

#define PGSIZE 4096

void run_workload(int policy)
{
  cptsetpolicy(policy);
  cptresetstats();

  char *mem = sbrk(5 * PGSIZE);
  if(mem == (char*)-1)
    exit();

  for(int r = 0; r < 100; r++){
    vread((int*)(mem + 0*PGSIZE));
    vread((int*)(mem + 1*PGSIZE));
    vread((int*)(mem + 2*PGSIZE));
    vread((int*)(mem + 3*PGSIZE));
    vread((int*)(mem + 0*PGSIZE));
    vread((int*)(mem + 1*PGSIZE));
    vread((int*)(mem + 4*PGSIZE));
  }

  struct cpt_stats st;
  cptgetstats(&st);

  int hit_rate = 0;
  if(st.accesses > 0) {
    hit_rate = (st.hits * 100) / st.accesses;
  }

  unsigned int total_access_time = (st.hits * 1) + (st.misses * 100);

  printf(1, "[P4] pid=%d policy=%d hit_rate=%d%% total_time=%d acc=%d hit=%d miss=%d evict=%d\n",
         getpid(), st.policy, hit_rate, total_access_time, st.accesses, st.hits, st.misses, st.evictions);
}

int main(void)
{
  for(int p = 0; p < 4; p++){
    for(int i = 0; i < 3; i++){
      int pid = fork();
      if(pid < 0) exit();
      
      if(pid == 0){
        run_workload(p);
        exit();
      }
      sleep(10);
    }
    for(int i = 0; i < 3; i++) wait();
    
    printf(1, "--------------------------------------------------\n");
  }
  exit();
}