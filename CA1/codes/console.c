#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

#define KEY_LF 0xE4
#define KEY_RT 0xE5

static void consputc(int, int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i], 0);
}

void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c, 0);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s, 0);
      break;
    case '%':
      consputc('%', 0);
      break;
    default:
      consputc('%', 0);
      consputc(c, 0);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1;
  for(;;)
    ;
}

#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);

static void
cgaputc(int c, int k)
{
  int pos;

  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n'){
    pos += 80 - pos%80;
  } 
  
  else if(c == BACKSPACE){
    if(pos > 0){
      --pos;
      crt[pos] = ' ' | 0x0700;
    }
  } 
  
  else if(c == KEY_LF){
    if(pos > 0)
      --pos;
  } 
  
  else if(c == KEY_RT){
    if(pos % 80 < 79){
      crt[pos++] = (k&0xff) | 0x0700;
    }
  } 
  
  else {
    crt[pos++] = (c&0xff) | 0x0700;
    crt[pos]   = ' ' | 0x0700;
  }

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
}

void
consputc(int c, int k)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } 
  
  else if(c == KEY_LF){
    uartputc('\b');
  } 
  
  else if(c == KEY_RT){
    uartputc(k);
  } 
  
  else {
    uartputc(c);
  }

  cgaputc(c, k);
}

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;
  uint w;
  uint e;
  uint real_end;
} input;

#define C(x)  ((x)-'@')

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):
      doprocdump = 1;
      break;

    case C('U'):
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE, 0);
      }
      input.real_end = input.e;
      break;

    case C('H'):
    case '\x7f':
      if (input.e != input.w) {
        if (input.e == input.real_end) {
          input.e--;
          input.real_end--;
          consputc(BACKSPACE, 0);
        } 
        
        else {
          input.e--;

          for (uint i = input.e; i < input.real_end - 1; i++)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];

          input.real_end--;

          consputc(KEY_LF, 0);

          for (uint i = input.e; i < input.real_end; i++)
            consputc(input.buf[i % INPUT_BUF], 0);

          consputc(' ', 0);
          
          for (uint k = input.e; k <= input.real_end; k++)
            consputc(KEY_LF, 0);
        }
      }
      break;


    case KEY_LF:
      if (input.e > input.w){
        input.e--;
        consputc(KEY_LF, 0);
      }
      break;

    case KEY_RT:
      if (input.e < input.real_end){
        char ch = input.buf[input.e % INPUT_BUF];
        consputc(KEY_RT, ch);
        input.e++;
      }
      break;

    default:
      if(input.e < input.real_end){
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
          if(c != '\n' && c != C('D')){
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];

            input.buf[input.e] = c;
            
            input.real_end++;

            consputc(c, 0);
            input.e++;

            for (uint i = input.e; i < input.real_end; i++)
              consputc(input.buf[i % INPUT_BUF], 0);
            
            for (uint k = input.e; k < input.real_end; k++)
              consputc(KEY_LF, 0);
          }

          if(c == '\n' || c == C('D') || input.real_end == input.r+INPUT_BUF){
            input.e = input.real_end;
            if (c == '\n') {
              input.buf[input.e++ % INPUT_BUF] = '\n';
              input.real_end = input.e;
              consputc('\n', 0);
            } else if (c == C('D')) {
              input.buf[input.e++ % INPUT_BUF] = C('D');
              input.real_end = input.e;
            }
            input.w = input.e;
            wakeup(&input.r);
          }

        }
      }

      else{
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
          c = (c == '\r') ? '\n' : c;
          input.buf[input.e++ % INPUT_BUF] = c;
          
          if (input.e > input.real_end) input.real_end = input.e;

          consputc(c, 0);

          if(c == '\n' || c == C('D') || input.real_end == input.r+INPUT_BUF){
            input.w = input.e;
            input.real_end = input.e;
            wakeup(&input.r);
          }
        }
      }
      
    break;
    }
  }
  
  release(&cons.lock);
  if(doprocdump) {
    procdump();
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){
      if(n < target){
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff, 0);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}
