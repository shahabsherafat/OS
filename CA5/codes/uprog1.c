#include "types.h"
#include "user.h"

#define PGSIZE 4096
#define PAGES 10

void run_workload(int policy)
{
  cptsetpolicy(policy);
  cptresetstats();

  char *mem = sbrk(PAGES * PGSIZE);
  if(mem == (char*)-1)
    exit();

  for(int i = 0; i < PAGES; i++){
    vwrite((int*)(mem + i*PGSIZE), i);
  }

  for(int i = 0; i < PAGES; i++)
    vread((int*)(mem + i*PGSIZE));

  struct cpt_stats st;
  cptgetstats(&st);

  int hit_rate = 0;
  if(st.accesses > 0) {
    hit_rate = (st.hits * 100) / st.accesses;
  }

  int total_access_time = (st.hits * 1) + (st.misses * 100);

  printf(1, "[P1] pid=%d policy=%d hit=%d%% time=%d (acc=%d hit=%d miss=%d evict=%d)\n",
         getpid(), st.policy, hit_rate, total_access_time, st.accesses, st.hits, st.misses, st.evictions);
}

int main(void)
{
  for(int p = 0; p < 4; p++){
    printf(1, "--- Testing Policy %d ---\n", p);
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
  }
  exit();
}