#include "types.h"
#include "user.h"

#define PGSIZE 4096

void run_workload(int policy)
{
  cptsetpolicy(policy);
  cptresetstats();

  char *hot  = sbrk(3 * PGSIZE);
  char *cold = sbrk(5 * PGSIZE);
  if(hot == (char*)-1 || cold == (char*)-1)
    exit();

  for(int i = 0; i < 3; i++)
    vwrite((int*)(hot + i*PGSIZE), i);

  for(int j = 0; j < 5; j++)
    vwrite((int*)(cold + j*PGSIZE), j);

  for(int r = 0; r < 50; r++)
    for(int i = 0; i < 100; i++){
      vread((int*)(hot + 0*PGSIZE));
      vread((int*)(hot + 1*PGSIZE));
      vread((int*)(hot + 2*PGSIZE));
      for(int j = 0; j < 5; j++)
        vread((int*)(cold + j*PGSIZE));
    }

  struct cpt_stats st;
  cptgetstats(&st);

  int hit_rate = 0;
  if(st.accesses > 0) {
    hit_rate = (st.hits * 100) / st.accesses;
  }

  unsigned int total_access_time = (st.hits * 1) + (st.misses * 100);

  printf(1, "[P3] pid=%d policy=%d | HitRate=%d%% | TotalTime=%d\n",
         getpid(), st.policy, hit_rate, total_access_time);
  printf(1, "     Details: (acc=%d hit=%d miss=%d evict=%d)\n",
         st.accesses, st.hits, st.misses, st.evictions);
}

int main(void)
{
  for(int p = 0; p < 4; p++){
    printf(1, "\n>>> Testing Policy %d <<<\n", p);
    for(int i = 0; i < 3; i++){
      int pid = fork();
      if(pid < 0) exit();
      
      if(pid == 0){
        run_workload(p);
        exit();
      }
      sleep(5);
    }
    for(int i = 0; i < 3; i++) wait();
  }
  exit();
}