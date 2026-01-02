#include "types.h"
#include "stat.h"
#include "user.h"

static void wait_token(int rfd)  { char x; read(rfd, &x, 1); }
static void send_token(int wfd)  { char x = 'X'; write(wfd, &x, 1); }

int
main(void)
{
  int me = getpid();
  printf(1, "\n[famdemo] parent PID = %d\n", me);

  int p1[2], p2[2];
  pipe(p1);
  pipe(p2);

  int c1 = fork();
  if (c1 == 0) {
    close(p1[1]);
    close(p2[0]);

    int gc1 = fork();
    if (gc1 == 0) { sleep(50); exit(); }

    int gc2 = fork();
    if (gc2 == 0) { sleep(50); exit(); }

    wait_token(p1[0]);

    printf(1, "\n[famdemo] child1 (PID %d):\n", getpid());
    show_process_family(getpid());   
    send_token(p2[1]);

    wait();
    wait();
    exit();
  }

  if (c1 > 0) {
    int c2 = fork();
    if (c2 == 0) { sleep(80); exit(); }
    int c3 = fork();
    if (c3 == 0) { sleep(80); exit(); }

    close(p1[0]);
    close(p2[1]);

    sleep(10);

    printf(1, "\n[famdemo] parent (PID %d), children: c1=%d c2=%d c3=%d\n",me, c1, c2, c3);

    show_process_family(me);

    send_token(p1[1]);

    wait_token(p2[0]);

    wait();
    wait();
    wait();
    printf(1, "\n[famdemo] done.\n");
    exit();
  }
  exit();
}
