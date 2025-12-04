
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int a = 5;
  int b = 3;
  int res;


  asm volatile(
    "movl %0, %%ebx\n"
    "movl %1, %%ecx\n"
    :
    : "r"(a), "r"(b)
    : "%ebx", "%ecx"
  );

  res = simple_arithmetic_syscall(a, b);

  exit();
}
