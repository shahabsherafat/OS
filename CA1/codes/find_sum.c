// find_sum.c
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

static int isdigit(int c){ return c >= '0' && c <= '9'; }
static int ustrlen(const char *s){ int n=0; while(s[n]) n++; return n; }

static int sum_in_str(const char *s){
  int sum = 0, cur = 0, in = 0;
  for(int i=0; s[i]; i++){
    if(isdigit(s[i])){
      in = 1;
      cur = cur*10 + (s[i]-'0');  // عدد چندرقمی
    }
    
    else{
      if(in){ sum += cur; cur = 0; in = 0; }
    }
  }
  if(in) sum += cur;              // آخر رشته اگر عدد بود
  return sum;
}

static void itoa_nl(int x, char *buf){
  char tmp[32]; int n=0, p=0, neg=0;
  if(x==0){ buf[0]='0'; buf[1]='\n'; buf[2]=0; return; }
  if(x<0){ neg=1; x=-x; }
  while(x){ tmp[n++] = '0' + (x%10); x/=10; }
  if(neg) buf[p++]='-';
  while(n--) buf[p++] = tmp[n];
  buf[p++] = '\n';
  buf[p] = 0;
}

int
main(int argc, char *argv[])
{
  int total = 0;

  if(argc > 1){
    for(int i=1; i<argc; i++)
      total += sum_in_str(argv[i]);
  }
  
  else{
    // (اختیاری) اگر آرگومان نبود، از stdin بخوان تا هم از read استفاده کرده باشیم
    char buf[512]; int m = read(0, buf, sizeof(buf)-1);
    if(m > 0){ buf[m] = 0; total += sum_in_str(buf); }
  }

  unlink("result.txt");                               // مطمئن شو فایل قدیمی حذف شود
  int fd = open("result.txt", O_CREATE | O_WRONLY);   // ایجاد/نوشتن
  if(fd < 0){
    // خطای ساده، بدون printf هم می‌شود فقط exit کرد
    exit();
  }

  char out[64];
  itoa_nl(total, out);
  write(fd, out, ustrlen(out));   // «حتماً» با write بنویس
  close(fd);

  exit();
}
