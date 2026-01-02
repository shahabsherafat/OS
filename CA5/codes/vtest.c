#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  char *base = (char*)malloc(4 * 4096);
  if(base == 0){
    printf(1, "malloc failed\n");
    exit();
  }

  int i;
  for(i = 0; i < 4; i++){
    int *p = (int*)(base + i*4096);   // first int of each page
    if(vwrite(p, 1000 + i) < 0){
      printf(1, "vwrite failed at page %d\n", i);
      exit();
    }
  }

  for(i = 0; i < 4; i++){
    int *p = (int*)(base + i*4096);
    int x = vread(p);
    printf(1, "page %d -> %d (expect %d)\n", i, x, 1000+i);
  }

  exit();
}
