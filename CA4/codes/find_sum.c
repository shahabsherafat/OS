#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

static int is_digit(int c){
  return c >= '0' && c <= '9';
}

static int ustrlen(const char *s){
  int n=0;
  while(s[n])
    n++;

  return n;
}

static int sum_in_str(const char *s){
  int sum = 0, cur = 0, in = 0;
  for(int i=0; s[i]; i++){
    if(is_digit(s[i])){
      in = 1;
      cur = cur*10 + (s[i]-'0');  // Multiple digit number
    }
    
    else{
      if(in){
        sum += cur;
        cur = 0;
        in = 0;
      }
    }
  }

  if(in)
    sum += cur;

  return sum;
}

static void convert_int_to_str(int x, char *buf){
  char tmp[32];
  int n = 0, p = 0, neg = 0;

  if(x==0){
    buf[0] = '0';
    buf[1] = '\n';
    buf[2] = 0; 
    return;
  }

  if(x<0){
    neg = 1;
    x = -x;
  }

  while(x){
    tmp[n++] = '0' + (x%10); x/=10;
  }

  if(neg)
    buf[p++] = '-';

  while(n--)
    buf[p++] = tmp[n];
    
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
    char buf[512];
    int m = read(0, buf, sizeof(buf)-1);

    if(m > 0){
      buf[m] = 0;
      total += sum_in_str(buf);
    }
  }

  unlink("result.txt");
  int fd = open("result.txt", O_CREATE | O_WRONLY);

  if(fd < 0){
    exit();
  }

  char out[64];
  convert_int_to_str(total, out);
  write(fd, out, ustrlen(out));
  close(fd);

  exit();
}
