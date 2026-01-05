#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSZ 4096

#define CPT_FIFO   0
#define CPT_LRU    1
#define CPT_LFU    2
#define CPT_CLOCK  3

static char*
pname(int pol)
{
  if(pol == CPT_FIFO)  return "FIFO";
  if(pol == CPT_LRU)   return "LRU";
  if(pol == CPT_LFU)   return "LFU";
  return "CLOCK";
}

static void
workload(char *base)
{
  int i;
  // warm up: fill first 4 pages
  for(i = 0; i < 4; i++){
    int *p = (int*)(base + i*PGSZ);
    vwrite(p, 100 + i);
  }

  // main loop
  for(i = 1; i <= 2000; i++){
    // hot set: 0..3
    vread((int*)(base + 0*PGSZ));
    vread((int*)(base + 1*PGSZ));
    vread((int*)(base + 2*PGSZ));
    vread((int*)(base + 3*PGSZ));

    // make page0 more frequent
    vread((int*)(base + 0*PGSZ));

    // occasional cold pages => force replacement
    if(i % 10 == 0)
      vread((int*)(base + 4*PGSZ));
    if(i % 25 == 0)
      vread((int*)(base + 5*PGSZ));
  }
}

static void
run_one(int pol)
{
  struct cpt_stats st;
  char *base = (char*)malloc(6 * PGSZ);
  int t0, t1;

  if(base == 0){
    printf(1, "malloc failed\n");
    exit();
  }

  cptsetpolicy(pol);
  cptresetstats();

  t0 = uptime();
  workload(base);
  t1 = uptime();

  cptgetstats(&st);

  // hit ratio as percent
  int ratio = 0;
  if(st.accesses > 0)
    ratio = (st.hits * 100) / st.accesses;

  printf(1, "%s: accesses=%d hits=%d miss=%d evict=%d hit_ratio=%d%% time=%d ticks\n",
         pname(pol),
         st.accesses, st.hits, st.misses, st.evictions, ratio, (t1 - t0));
}

int
main(void)
{
  printf(1, "\nCPT benchmark (hit count / hit ratio / time)\n");
  run_one(CPT_FIFO);
  run_one(CPT_LRU);
  run_one(CPT_LFU);
  run_one(CPT_CLOCK);
  printf(1, "done\n");
  exit();
}
