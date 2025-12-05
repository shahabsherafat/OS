#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

// تابعی برای شبیه‌سازی بار کاری سنگین روی CPU
void cpu_bound_task(int id) {
    volatile double x = 0;
    int start_time = uptime();
    
    // یک حلقه طولانی برای مصرف CPU. 
    // این عدد ممکن است نیاز به تنظیم داشته باشد (مثلاً برای qemu سریعتر)
    // اگر پروسه‌ها خیلی سریع تمام می‌شوند، این عدد را زیاد کنید.
    for (double i = 0; i < 600000; i += 1) {
        x = x + 3.14 * 89.64; 
    }
    
    int end_time = uptime();
    
    printf(1, "Child %d (PID: %d) Finished. Start: %d, End: %d, Duration: %d ticks.\n", 
           id, getpid(), start_time, end_time, end_time - start_time);
    
    exit();
}

int main(int argc, char *argv[]) {
    int n = 8; // تعداد پروسه‌های فرزند
    int pid;

    printf(1, "Starting Scheduling Test with %d processes (Must run with 'qemu CPUS=2').\n", n);
    printf(1, "------------------------------------------------------------------------\n");
    printf(1, "Order of creation:\n");
    
    for (int i = 1; i <= n; i++) {
        pid = fork();
        
        if (pid < 0) {
            printf(1, "Fork failed\n");
            break;
        }
        
        if (pid == 0) {
            // کد فرزند
            // شروع کار سنگین
            cpu_bound_task(i);
        } else {
            // کد والد
            printf(1, " -> Created Child %d (PID: %d) at tick %d\n", i, pid, uptime());
            // ایجاد یک وقفه کوچک (10 تیک) تا creation_time هر پروسه از بعدی مجزا شود.
            sleep(10); 
        }
    }

    printf(1, "------------------------------------------------------------------------\n");
    printf(1, "Order of completion:\n");

    // والد منتظر می‌ماند تا همه فرزندان تمام شوند
    for (int i = 0; i < n; i++) {
        wait();
    }

    printf(1, "------------------------------------------------------------------------\n");
    printf(1, "All children finished. Test done.\n");
    exit();
}