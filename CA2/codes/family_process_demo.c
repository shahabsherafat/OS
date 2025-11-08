#include "types.h"
#include "stat.h"
#include "user.h"

// Helper: sleep a little so the procs are alive when we inspect them
static void pause_a_bit(void) { sleep(20); }

int
main(void)
{
  int me = getpid();
  printf(1, "\n[famdemo] parent PID = %d\n", me);

  // create 3 children
  int c1 = fork();
  if (c1 == 0) {
    // child1: create 2 grandchildren
    int gc1 = fork();
    if (gc1 == 0) { pause_a_bit(); exit(); }

    int gc2 = fork();
    if (gc2 == 0) { pause_a_bit(); exit(); }

    // give the grandkids time to exist, then show child1's family
    pause_a_bit();
    printf(1, "\n[famdemo] in child1 (PID %d):\n", getpid());
    show_process_family(getpid());   // should list gc1 & gc2 as children
    // keep child1 around until parent is done
    pause_a_bit();
    // reap grandkids
    wait();
    wait();
    exit();
  }

  if (c1 > 0) {
    int c2 = fork();
    if (c2 == 0) {
      pause_a_bit();
      exit();
    }
    int c3 = fork();
    if (c3 == 0) {
      pause_a_bit();
      exit();
    }

    // give everyone time to spawn
    pause_a_bit();

    printf(1, "\n[famdemo] in parent (PID %d):\n", me);
    printf(1, "[famdemo] children: c1=%d c2=%d c3=%d\n", c1, c2, c3);

    // Show the parent's family (should show c1,c2,c3 as children)
    show_process_family(me);

    // Also inspect child1 from the parent’s view (should list the two grandkids)
    show_process_family(c1);

    // Optional: press Ctrl+P after this to see the full table
    printf(1, "\n[famdemo] tip: press Ctrl+P now to dump the process table\n");

    // Clean up: wait for c1,c2,c3
    wait();
    wait();
    wait();
    printf(1, "\n[famdemo] done.\n");
    exit();
  }

  // Shouldn’t reach here
  exit();
}
