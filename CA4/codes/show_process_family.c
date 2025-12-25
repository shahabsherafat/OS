#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if (argc != 2) {
    printf(1, "usage: showfam <pid>\n");
    exit();
  }
  int pid = atoi(argv[1]);
  int r = show_process_family(pid);
  if (r < 0)
    printf(1, "pid %d not found\n", pid);
  exit();
}
