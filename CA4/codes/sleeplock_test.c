#include "types.h"
#include "user.h"

int
main(void)
{
  printf(1, "locktest: calling sleeplock_test(); should panic if child tries to release\n");
  sleeplock_test();

  // If you ever see this line, panic didn't happen (meaning bug in protection).
  printf(1, "locktest: ERROR: returned from sleeplock_test (expected panic)\n");
  exit();
}
