// test_pfcfs.c  - تست FCFS بر اساس زمان ایجاد روی P-core (cpuid فرد)
// این برنامه فرض می‌کند سیستم با "qemu CPUS=2" اجرا شده است.

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int fds[2];   // pipe برای بخش B

// حلقه‌ی سنگین برای مصرف CPU
void
heavy_spin(int rounds)
{
  volatile int x = 0;
  int i, j;
  for(i = 0; i < rounds; i++){
    for(j = 0; j < 100000; j++){
      x += (i ^ j);
    }
  }
}

// ===================== بخش A: ترتیب پایان روی P-core =====================

void
test_simple_pcore_fcfs(void)
{
  int n = 8;           // تعداد بچه‌ها
  int created_pids[8]; // pidهایی که روی P-core هستند (pid%2==1)
  int created_idx = 0;
  int i;

  printf(1, "=== [A] Simple P-core FCFS test (no sleep) ===\n");

  for(i = 0; i < n; i++){
    int pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
      // کد فرزند
      int mypid = getpid();
      int start = uptime();

      // فقط پردازه‌هایی که pid فرد دارند روی P-core می‌افتند
      if(mypid % 2 == 1){
        printf(1, "[P-core child] created (PID=%d), start=%d\n", mypid, start);
        heavy_spin(200);  // کار سنگین مساوی برای همه‌ی بچه‌ها
        printf(1, "[P-core child] PID=%d finished at %d\n", mypid, uptime());
      } else {
        // بچه‌های E-core برای این تست مهم نیستند، یک کار خیلی کوچک می‌کنند
        heavy_spin(20);
      }
      exit();
    } else {
      // والد: فقط pidهای فرد (P-core) را در لیست creation نگه می‌دارد
      if(pid % 2 == 1 && created_idx < 8){
        created_pids[created_idx++] = pid;
      }
    }
  }

  // والد: جمع‌آوری همه‌ی بچه‌ها
  for(i = 0; i < n; i++)
    wait();

  // چاپ ترتیب ایجاد بچه‌های P-core که really ساختیم
  printf(1, "--- P-core children creation order (pid %% 2 == 1) ---\n");
  for(i = 0; i < created_idx; i++){
    printf(1, " #%d => PID %d\n", i, created_pids[i]);
  }

  printf(1, "=== [A] Simple P-core FCFS test done ===\n\n");
}

// ===================== بخش B: تست پیش‌گیرانه با pipe =====================
// نسخه‌ی سبک‌تر B – فقط دو بچه روی P-core، کار خیلی کم

void
old_pcore_proc_light(void)
{
  int mypid = getpid();
  char ch;
  int i;

  printf(1, "[OLD %d] (P-core) created FIRST, waiting on pipe...\n", mypid);

  if(read(fds[0], &ch, 1) != 1){
    printf(1, "[OLD %d] read failed\n", mypid);
    exit();
  }

  printf(1, "[OLD %d] WOKE UP, starting light work\n", mypid);

  for(i = 0; i < 3; i++){
    printf(1, "[OLD %d] working step %d\n", mypid, i);
    heavy_spin(20);   // خیلی سبک
  }

  printf(1, "[OLD %d] finished work\n", mypid);
  exit();
}

void
new_pcore_proc_light(void)
{
  int mypid = getpid();
  int i;

  printf(1, "[NEW %d] (P-core) created SECOND, starting light work\n", mypid);

  for(i = 0; i < 5; i++){
    printf(1, "[NEW %d] working step %d\n", mypid, i);
    heavy_spin(15);   // سبک
  }

  printf(1, "[NEW %d] finished work\n", mypid);
  exit();
}

void
test_preemptive_pcore_fcfs(void)
{
  int old_pid = -1, new_pid = -1;
  int pid;

  printf(1, "=== [B] Preemptive P-core FCFS PIPE test (light) ===\n");

  if(pipe(fds) < 0){
    printf(1, "pipe failed\n");
    exit();
  }

  // ۱) پیدا کردن اولین بچه روی P-core برای OLD
  while(old_pid < 0){
    pid = fork();
    if(pid < 0){
      printf(1, "fork for OLD failed\n");
      exit();
    }
    if(pid == 0){
      int mypid = getpid();
      if(mypid % 2 == 1){
        old_pcore_proc_light();
      } else {
        exit();
      }
    } else {
      if(pid % 2 == 1){
        old_pid = pid;
        printf(1, "[PARENT] OLD child on P-core has PID=%d\n", pid);
      }
    }
  }

  // کمی کار خیلی سبک
  heavy_spin(50);

  // ۲) پیدا کردن دومین بچه روی P-core برای NEW
  while(new_pid < 0){
    pid = fork();
    if(pid < 0){
      printf(1, "fork for NEW failed\n");
      exit();
    }
    if(pid == 0){
      int mypid = getpid();
      if(mypid % 2 == 1){
        new_pcore_proc_light();
      } else {
        exit();
      }
    } else {
      if(pid % 2 == 1){
        new_pid = pid;
        printf(1, "[PARENT] NEW child on P-core has PID=%d\n", pid);
      }
    }
  }

  // اجازه بده NEW چند step کار کند
  heavy_spin(200);

  // ۳) بیدار کردن OLD
  printf(1, "[PARENT] Waking up OLD (PID=%d) by writing to pipe\n", old_pid);
  write(fds[1], "X", 1);

  close(fds[0]);
  close(fds[1]);

  while(wait() > 0)
    ;

  printf(1, "=== [B] Preemptive P-core FCFS PIPE test (light) done ===\n\n");
}


int
main(int argc, char *argv[])
{
  printf(1, "===== P-core FCFS validation program =====\n\n");

  test_simple_pcore_fcfs();
  test_preemptive_pcore_fcfs();

  printf(1, "===== All tests finished. =====\n");
  exit();
}
