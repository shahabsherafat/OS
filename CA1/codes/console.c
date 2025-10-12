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

static ushort cg_attr = 0x0700;


static void consputc(int, int);

static int panicked = 0;

static struct {
  struct spinlock lock;
  int locking;
} cons;

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;
  uint w;
  uint e;
  uint real_end;
  int insert_order[INPUT_BUF];
  int current_time;
  int sel_a;   // نقطه‌ی اول (anchor) یا -1
  int sel_b;   // نقطه‌ی دوم (active end) یا -1
  // کلیپ‌بورد
  char clip[INPUT_BUF];
  int  clip_len;
} input;

static inline int has_selection(void) {
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
}
static inline void clear_selection(void) {
  input.sel_a = input.sel_b = -1;
}
static inline void sel_bounds(int *lo, int *hi) {
  int a = input.sel_a, b = input.sel_b;
  if (a > b) { int t=a; a=b; b=t; }
  *lo = a; *hi = b;
}


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
cgaputc(int c)
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
  else if (c == KEY_RT) {
    if (pos < 25*80 - 1)
      ++pos;       
  }
  else {
    crt[pos++] = (c & 0xff) | cg_attr;
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

  cgaputc(c);
}

#define C(x)  ((x)-'@')

static int
min_int(int a, int b) { return a < b ? a : b; }

static void delete_range(int lo, int hi){
  if (hi <= lo) return;
  int deln = hi - lo;
  for (int i = hi; i < (int)input.real_end; i++){
    input.buf[(i - deln) % INPUT_BUF]          = input.buf[i % INPUT_BUF];
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
  }
  input.real_end -= deln;
  if (input.e > hi)       input.e -= deln;
  else if (input.e > lo)  input.e  = lo;
  if (input.e < input.w)  input.e  = input.w;
}

static int insert_at(int pos, const char *src, int n){
  if (n <= 0) return 0;
  int inuse = (int)input.real_end - (int)input.r;
  int free  = INPUT_BUF - inuse;
  if (free <= 0) return 0;
  if (n > free) n = free;

  for (int i = (int)input.real_end - 1; i >= pos; --i){
    input.buf[(i + n) % INPUT_BUF]          = input.buf[i % INPUT_BUF];
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
  }
  int wrote = 0;
  for (; wrote < n; ++wrote){
    char ch = src[wrote];
    if (ch == '\n') break; // اجازه‌ی newline نده
    input.buf[(pos + wrote) % INPUT_BUF]          = ch;
    input.insert_order[(pos + wrote) % INPUT_BUF] = ++input.current_time;
  }
  input.real_end += wrote;
  input.e = pos + wrote;
  return wrote;
}




static void redraw_edit_with_selection(void) {
  int old_e = (int)input.e;
  int len   = (int)input.real_end - (int)input.w;
  if (len < 0) len = 0;

  int off_from_start = old_e - (int)input.w;
  if (off_from_start < 0) off_from_start = 0;
  for (int i = 0; i < off_from_start; i++)
    consputc(KEY_LF, 0);

  int lo = -1, hi = -1;
  int sel = 0;
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b) {
    lo = input.sel_a; hi = input.sel_b;
    if (lo > hi) { int t = lo; lo = hi; hi = t; }
    sel = 1;
  }

  for (int i = 0; i < len; i++) {
    int idx = (int)input.w + i;
    int in_sel = sel && idx >= lo && idx < hi;
    ushort prev = cg_attr;
    cg_attr = in_sel ? 0x7000 : 0x0700;
    consputc(input.buf[idx % INPUT_BUF], 0);
    cg_attr = prev;
  }

  int back = len - off_from_start;
  for (int i = 0; i < back; i++)
    consputc(KEY_LF, 0);
}


static void full_redraw_after_edit(uint old_e){
  int old_len = (int)input.real_end - (int)input.w;
  if (old_len < 0) old_len = 0;

  int old_cursor_off = (int)old_e - (int)input.w;
  if (old_cursor_off < 0) old_cursor_off = 0;

  // 1) go to start of editable region from old cursor
  for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);

  // 2) wipe previous visual content (cap to 80 to avoid scroll)
  for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
  for (int i = 0; i < min_int(old_len, 80); i++) consputc(KEY_LF, 0);

  // 3) print fresh content (no selection highlighting)
  for (int i = 0; i < old_len; i++)
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);

  // 4) move caret to input.e
  int new_cursor_off = (int)input.e - (int)input.w;
  int moves_left = old_len - new_cursor_off;
  for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
}

// static void deselect_and_full_redraw(void){
//   uint old_e = input.e;
//   clear_selection();
//   full_redraw_after_edit(old_e);
// }

static inline void deselect_and_redraw_if_any(void){
  if (has_selection()){
    uint old_e = input.e;
    clear_selection();
    full_redraw_after_edit(old_e);
  }
}

static void replace_selection_with(const char *src, int n){
  int lo, hi; sel_bounds(&lo, &hi);
  uint old_e = input.e;
  delete_range(lo, hi);
  insert_at(lo, src, n);
  clear_selection();
  full_redraw_after_edit(old_e);
}

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){

    // Jump right by word
    case C('D'):
      deselect_and_redraw_if_any();
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
        char ch = input.buf[input.e % INPUT_BUF];
        consputc(KEY_RT, ch);
        input.e++;
      }
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
        char ch = input.buf[input.e % INPUT_BUF];
        consputc(KEY_RT, ch);
        input.e++;
      }
      break;

    // Jump left by word
    case C('A'):
      deselect_and_redraw_if_any();
      if(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] == ' '){
        consputc(KEY_LF,0);
        input.e--;
      }
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
        consputc(KEY_LF,0);
        input.e--;
      }
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
        consputc(KEY_LF,0);
        input.e--;
      }
      break;

    case C('P'):
    deselect_and_redraw_if_any();
      doprocdump = 1;
      break;

    // Clear line
    case C('U'): {

      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE, 0);
      }
      input.real_end = input.e;
      input.current_time = 0;
      break;
    }

    // Backspace
    case C('H'):
    
    case '\x7f': {
        if (has_selection()){
          uint old_e = input.e;
          int lo, hi; sel_bounds(&lo, &hi);
          delete_range(lo, hi);  
          clear_selection();            
          full_redraw_after_edit(old_e); 
          break;
        }
      if (input.e != input.w) {
        if (input.e == input.real_end) {
          // simple case: at end, just backspace normally
          input.e--;
          input.real_end--;
          consputc(BACKSPACE, 0);
        } else {
          // deletion in the middle -> update buffer & timestamps, then robust redraw
          int old_e = (int)input.e;
          int old_real_end = (int)input.real_end;
          int old_len = old_real_end - (int)input.w;
          if (old_len < 0) old_len = 0;

          // remove character just before cursor
          input.e--; // move edit pointer left (we delete char at this position)
          // shift left starting from input.e to real_end-1
          for (uint i = input.e; i < input.real_end - 1; i++) {
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
          }
          input.real_end--;
          if (input.e > input.real_end) input.e = input.real_end;

          // now redraw entire editable region cleanly
          int new_len = (int)input.real_end - (int)input.w;
          if (new_len < 0) new_len = 0;
          int old_cursor_off = old_e - (int)input.w;
          if (old_cursor_off < 0) old_cursor_off = 0;
          int new_cursor_off = (int)input.e - (int)input.w;
          if (new_cursor_off < 0) new_cursor_off = 0;

          // 1) move to start of editable region
          for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);

          // 2) erase old content by overwriting with spaces (limit to 80 to avoid scrolling)
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);

          // 3) move back to start
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(KEY_LF, 0);

          // 4) print new content
          for (int i = 0; i < new_len; i++)
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);

          // 5) move cursor to new_cursor_off
          int moves_left = new_len - new_cursor_off;
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
        }
      }
      break;
    }

    // Move left
    case KEY_LF:
    deselect_and_redraw_if_any();
      if (input.e > input.w){
        input.e--;
        consputc(KEY_LF, 0);
      }
      break;

    // Move right
    case KEY_RT:
    deselect_and_redraw_if_any();
      if (input.e < input.real_end){
        char ch = input.buf[input.e % INPUT_BUF];
        consputc(KEY_RT, ch);
        input.e++;
      }
      break;
    case C('C'): { // Copy
      if (has_selection()){
        int lo, hi; sel_bounds(&lo, &hi);
        int n = hi - lo;
        if (n > INPUT_BUF) n = INPUT_BUF;
        for (int i = 0; i < n; ++i)
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
        input.clip_len = n;
        // طبق مشخصات: انتخاب باید باقی بماند؛ نیازی به redraw نیست
      }
      break;
    }

    case C('V'): {  // Paste
    if (input.clip_len <= 0) break;      // nothing to paste

    if (has_selection()){
      replace_selection_with(input.clip, input.clip_len);
    } else {
      uint old_e = input.e;
      int was_end = (input.e == input.real_end);
      int wrote = insert_at((int)input.e, input.clip, input.clip_len);
      clear_selection();                  // spec: return to normal mode

      if (wrote <= 0) break;
      if (!was_end) {
        full_redraw_after_edit(old_e);    // content after caret shifted
      } else {
        // Fast path: appended at end → just print what was added
        for (int i = 0; i < wrote; ++i)
          consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
      }
    }
    break;
  }


    // === Ctrl+Z: delete last inserted char (time-based) ===
    case C('Z'): {
      deselect_and_redraw_if_any();
      if (input.real_end > input.w) {
        int max_t = -1, idx = -1;
        // find index of last inserted char
        for (uint i = input.w; i < input.real_end; i++) {
          int t = input.insert_order[i % INPUT_BUF];
          if (t > max_t) {
            max_t = t;
            idx = (int)i;
          }
        }
        if (idx >= 0) {
          int old_e = (int)input.e;
          int old_real_end = (int)input.real_end;
          int old_len = old_real_end - (int)input.w;
          if (old_len < 0) old_len = 0;

          // shift buffer & timestamps left from idx
          for (int i = idx; i < old_real_end - 1; i++) {
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
          }
          input.real_end--;
          // adjust edit pointer if it was after the deleted char
          if ((int)input.e > idx) 
              input.e--;

          if (input.e < input.w) 
              input.e = input.w;

          if (input.e > input.real_end) 
              input.e = input.real_end;

          // new length and offsets
          int new_len = (int)input.real_end - (int)input.w;

          if (new_len < 0) 
              new_len = 0;

          int old_cursor_off = old_e - (int)input.w;

          if (old_cursor_off < 0) 
              old_cursor_off = 0;

          int new_cursor_off = (int)input.e - (int)input.w;

          if (new_cursor_off < 0) 
              new_cursor_off = 0;

          // 1) move to start of editable region (from old cursor)
          for (int i = 0; i < old_cursor_off; i++) 
              consputc(KEY_LF, 0);

          // 2) erase old content by overwriting with spaces (cap to 80)
          for (int i = 0; i < min_int(old_len, 80); i++) 
              consputc(' ', 0);

          // 3) move back to start
          for (int i = 0; i < min_int(old_len, 80); i++) 
              consputc(KEY_LF, 0);

          // 4) print new content
          for (int i = 0; i < new_len; i++)
              consputc(input.buf[(input.w + i) % INPUT_BUF], 0);

          // 5) move cursor to new_cursor_off
          int moves_left = new_len - new_cursor_off;

          for (int i = 0; i < moves_left; i++) 
              consputc(KEY_LF, 0);
        }
      }
      break;
    }

    case C('S'): {
      // If a selection exists, Ctrl+S toggles it OFF.
      if (has_selection()){
        uint old_e = input.e;
        clear_selection();
        full_redraw_after_edit(old_e);   // remove highlight
        break;
      }

      // No selection yet:
      if (input.sel_a < 0) {             // 1st Ctrl+S → set anchor
        input.sel_a = (int)input.e;
        break;
      }

      // Anchor exists but no active end:
      input.sel_b = (int)input.e;         // 2nd Ctrl+S → set active end
      if (input.sel_b == input.sel_a) {
        clear_selection();                // zero-length → no selection
      } else {
        redraw_edit_with_selection();     // show highlight
      }
      break;
    }





    default:
      if(input.e < input.real_end){
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
          if(c != '\n'){
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
            }
            input.buf[input.e % INPUT_BUF] = c;
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
            input.real_end++;
            consputc(c, 0);
            input.e++;
            for (uint i = input.e; i < input.real_end; i++)
              consputc(input.buf[i % INPUT_BUF], 0);
            for (uint k = input.e; k < input.real_end; k++)
              consputc(KEY_LF, 0);
          }
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
            input.e = input.real_end;
            if (c == '\n') {
              input.buf[input.e++ % INPUT_BUF] = '\n';
              input.real_end = input.e;
              consputc('\n', 0);
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
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
          if (input.e > input.real_end) input.real_end = input.e;
          consputc(c, 0);
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
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
  if(doprocdump)
    procdump();
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
  input.sel_a = input.sel_b = -1;
  input.clip_len = 0;
}
