#include "types.h"
#include "stat.h"
#include "user.h"

int
main()
{
  int a = 20;
  int b = 10;
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
