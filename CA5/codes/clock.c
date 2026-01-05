#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSZ 4096
#define CPT_CLOCK 3

int
main(void)
{
  char *base = (char*)malloc(5 * PGSZ);
  int x;

  if(base == 0){
    printf(1, "malloc failed\n");
    exit();
  }

  cptsetpolicy(CPT_CLOCK);
  cptresetstats();

  printf(1, "\nSTEP 1) Fill CPT with pages 0..3 using writes\n");
  vwrite((int*)(base + 0*PGSZ), 100);
  vwrite((int*)(base + 1*PGSZ), 101);
  vwrite((int*)(base + 2*PGSZ), 102);
  vwrite((int*)(base + 3*PGSZ), 103);

  printf(1, "\nSTEP 2) Touch page0 and page1 (set refbit=1 for them)\n");
  x = vread((int*)(base + 0*PGSZ));
  x = vread((int*)(base + 1*PGSZ));
  printf(1, "touched p0=%d p1=%d\n", vread((int*)(base + 0*PGSZ)), vread((int*)(base + 1*PGSZ)));

  printf(1, "\nSTEP 3) Access page4 -> should cause eviction\n");
  x = vread((int*)(base + 4*PGSZ));
  printf(1, "read page4 = %d (expect 0 unless you wrote it)\n", x);

  printf(1, "\nSTEP 4) Check pages 0..3 values still readable (write-through keeps correctness)\n");
  printf(1, "p0=%d (expect 100)\n", vread((int*)(base + 0*PGSZ)));
  printf(1, "p1=%d (expect 101)\n", vread((int*)(base + 1*PGSZ)));
  printf(1, "p2=%d (expect 102)\n", vread((int*)(base + 2*PGSZ)));
  printf(1, "p3=%d (expect 103)\n", vread((int*)(base + 3*PGSZ)));

  printf(1, "\nDONE\n");
  exit();
}
