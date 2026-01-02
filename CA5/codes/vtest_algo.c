#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSZ 4096

int
main(void)
{
  char *base = (char*)malloc(6 * PGSZ);
  int i;

  if(base == 0){
    printf(1, "malloc failed\n");
    exit();
  }

  printf(1, "\nSTEP 1) write first 4 pages (fills CPT)\n");
  for(i = 0; i < 4; i++){
    int *p = (int*)(base + i*PGSZ);
    int r = vwrite(p, 100 + i);
    printf(1, "write page %d -> %d\n", i, r);
  }

  printf(1, "\nEXTRA) make page 0 very frequent\n");
for(i = 0; i < 20; i++){
  int *p0 = (int*)(base + 0*PGSZ);
  vread(p0);
}


  printf(1, "\nSTEP 2) write page 4 (should cause 1 eviction)\n");
  {
    int *p4 = (int*)(base + 4*PGSZ);
    int r = vwrite(p4, 104);
    printf(1, "write page 4 -> %d\n", r);
  }

  printf(1, "\nSTEP 3) write page 5 (should cause another eviction)\n");
  {
    int *p5 = (int*)(base + 5*PGSZ);
    int r = vwrite(p5, 105);
    printf(1, "write page 5 -> %d\n", r);
  }

  printf(1, "\nSTEP 4) read ALL pages back (must be correct)\n");
  for(i = 0; i < 6; i++){
    int *p = (int*)(base + i*PGSZ);
    int x = vread(p);
    printf(1, "read page %d -> %d (expect %d)\n", i, x, 100+i);
  }

  printf(1, "\nDONE\n");
  exit();
}
