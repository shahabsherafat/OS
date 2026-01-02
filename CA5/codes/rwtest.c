#include "types.h"
#include "user.h"

static void
reader(int id)
{
  rwlock_rlock();
  printf(1, "READER %d (pid=%d): entered critical section\n", id, getpid());
  sleep(80);  // hold lock long enough so concurrency is visible
  printf(1, "READER %d (pid=%d): leaving critical section\n", id, getpid());
  rwlock_runlock();
  exit();
}

static void
writer(int id)
{
  rwlock_wlock();
  printf(1, "WRITER %d (pid=%d): entered critical section (exclusive)\n", id, getpid());
  sleep(120);
  printf(1, "WRITER %d (pid=%d): leaving critical section\n", id, getpid());
  rwlock_wunlock();
  exit();
}

int
main(void)
{
  int i;
  int pid;

  // Spawn multiple readers first (they should overlap).
  for(i = 0; i < 4; i++){
    pid = fork();
    if(pid == 0)
      reader(i);
  }

  // Spawn writers (they should enter only when no readers/writers are inside).
  for(i = 0; i < 2; i++){
    pid = fork();
    if(pid == 0)
      writer(i);
  }

  // Wait all
  for(i = 0; i < 6; i++)
    wait();

  exit();
}
