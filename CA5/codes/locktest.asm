
_locktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  uint scores[NCPU];
  
  printf(1, "Initial Stats:\n");
  getlockstat(scores);
   f:	8d 5d d8             	lea    -0x28(%ebp),%ebx
int main() {
  12:	83 ec 48             	sub    $0x48,%esp
  printf(1, "Initial Stats:\n");
  15:	68 88 08 00 00       	push   $0x888
  1a:	6a 01                	push   $0x1
  1c:	e8 5f 05 00 00       	call   580 <printf>
  getlockstat(scores);
  21:	89 1c 24             	mov    %ebx,(%esp)
  24:	e8 a2 04 00 00       	call   4cb <getlockstat>

  for(volatile int i=0; i<NCPU; i++) 
  29:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  30:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  33:	83 c4 10             	add    $0x10,%esp
  36:	83 f8 07             	cmp    $0x7,%eax
  39:	7f 30                	jg     6b <main+0x6b>
  3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    printf(1, "CPU %d: %d\n", i, scores[i]);
  40:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  46:	ff 74 95 d8          	push   -0x28(%ebp,%edx,4)
  4a:	50                   	push   %eax
  4b:	68 98 08 00 00       	push   $0x898
  50:	6a 01                	push   $0x1
  52:	e8 29 05 00 00       	call   580 <printf>
  for(volatile int i=0; i<NCPU; i++) 
  57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	83 c0 01             	add    $0x1,%eax
  60:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  66:	83 f8 07             	cmp    $0x7,%eax
  69:	7e d5                	jle    40 <main+0x40>

  for(volatile i=0; i<4; i++) {
  6b:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  72:	8b 45 c8             	mov    -0x38(%ebp),%eax
  75:	83 f8 03             	cmp    $0x3,%eax
  78:	7e 17                	jle    91 <main+0x91>
  7a:	eb 76                	jmp    f2 <main+0xf2>
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	8b 45 c8             	mov    -0x38(%ebp),%eax
  83:	83 c0 01             	add    $0x1,%eax
  86:	89 45 c8             	mov    %eax,-0x38(%ebp)
  89:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8c:	83 f8 03             	cmp    $0x3,%eax
  8f:	7f 61                	jg     f2 <main+0xf2>
    if(fork() == 0) {
  91:	e8 25 03 00 00       	call   3bb <fork>
  96:	85 c0                	test   %eax,%eax
  98:	75 e6                	jne    80 <main+0x80>

      for(volatile int j=0; j<1000; j++) {
  9a:	31 db                	xor    %ebx,%ebx
  9c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  9f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  a2:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  a7:	7e 1e                	jle    c7 <main+0xc7>
  a9:	e9 bd 00 00 00       	jmp    16b <main+0x16b>
  ae:	66 90                	xchg   %ax,%ax
  b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  b3:	83 c0 01             	add    $0x1,%eax
  b6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  bc:	3d e7 03 00 00       	cmp    $0x3e7,%eax
  c1:	0f 8f a4 00 00 00    	jg     16b <main+0x16b>

          uptime();
  c7:	e8 8f 03 00 00       	call   45b <uptime>
          if(j%10==0)
  cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  cf:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  d5:	05 98 99 99 19       	add    $0x19999998,%eax
  da:	d1 c8                	ror    $1,%eax
  dc:	3d 98 99 99 19       	cmp    $0x19999998,%eax
  e1:	77 cd                	ja     b0 <main+0xb0>
            sleep(1); 
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	6a 01                	push   $0x1
  e8:	e8 66 03 00 00       	call   453 <sleep>
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	eb be                	jmp    b0 <main+0xb0>
      }
      exit();
    }
  }

  for(volatile int i=0; i<4; i++) 
  f2:	31 c9                	xor    %ecx,%ecx
  f4:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  fa:	83 f8 03             	cmp    $0x3,%eax
  fd:	7f 17                	jg     116 <main+0x116>
  ff:	90                   	nop
    wait();
 100:	e8 c6 02 00 00       	call   3cb <wait>
  for(volatile int i=0; i<4; i++) 
 105:	8b 45 d0             	mov    -0x30(%ebp),%eax
 108:	83 c0 01             	add    $0x1,%eax
 10b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 10e:	8b 45 d0             	mov    -0x30(%ebp),%eax
 111:	83 f8 03             	cmp    $0x3,%eax
 114:	7e ea                	jle    100 <main+0x100>

  printf(1, "\nFinal Stats after load:\n");
 116:	50                   	push   %eax
 117:	50                   	push   %eax
 118:	68 a4 08 00 00       	push   $0x8a4
 11d:	6a 01                	push   $0x1
 11f:	e8 5c 04 00 00       	call   580 <printf>

  getlockstat(scores);
 124:	89 1c 24             	mov    %ebx,(%esp)
 127:	e8 9f 03 00 00       	call   4cb <getlockstat>

  for(volatile i=0; i<NCPU; i++) 
 12c:	31 d2                	xor    %edx,%edx
 12e:	83 c4 10             	add    $0x10,%esp
 131:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 134:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 137:	83 f8 07             	cmp    $0x7,%eax
 13a:	7f 2f                	jg     16b <main+0x16b>
 13c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "CPU %d: %d\n", i, scores[i]);
 140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 143:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 146:	ff 74 95 d8          	push   -0x28(%ebp,%edx,4)
 14a:	50                   	push   %eax
 14b:	68 98 08 00 00       	push   $0x898
 150:	6a 01                	push   $0x1
 152:	e8 29 04 00 00       	call   580 <printf>
  for(volatile i=0; i<NCPU; i++) 
 157:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 c0 01             	add    $0x1,%eax
 160:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 163:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 166:	83 f8 07             	cmp    $0x7,%eax
 169:	7e d5                	jle    140 <main+0x140>
      exit();
 16b:	e8 53 02 00 00       	call   3c3 <exit>

00000170 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 170:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 171:	31 c0                	xor    %eax,%eax
{
 173:	89 e5                	mov    %esp,%ebp
 175:	53                   	push   %ebx
 176:	8b 4d 08             	mov    0x8(%ebp),%ecx
 179:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 180:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 184:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 187:	83 c0 01             	add    $0x1,%eax
 18a:	84 d2                	test   %dl,%dl
 18c:	75 f2                	jne    180 <strcpy+0x10>
    ;
  return os;
}
 18e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 191:	89 c8                	mov    %ecx,%eax
 193:	c9                   	leave
 194:	c3                   	ret
 195:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 19c:	00 
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
 1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1aa:	0f b6 02             	movzbl (%edx),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 17                	jne    1c8 <strcmp+0x28>
 1b1:	eb 3a                	jmp    1ed <strcmp+0x4d>
 1b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1bc:	83 c2 01             	add    $0x1,%edx
 1bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1c2:	84 c0                	test   %al,%al
 1c4:	74 1a                	je     1e0 <strcmp+0x40>
 1c6:	89 d9                	mov    %ebx,%ecx
 1c8:	0f b6 19             	movzbl (%ecx),%ebx
 1cb:	38 c3                	cmp    %al,%bl
 1cd:	74 e9                	je     1b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1cf:	29 d8                	sub    %ebx,%eax
}
 1d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1d4:	c9                   	leave
 1d5:	c3                   	ret
 1d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1dd:	00 
 1de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 1e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1e4:	31 c0                	xor    %eax,%eax
 1e6:	29 d8                	sub    %ebx,%eax
}
 1e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1eb:	c9                   	leave
 1ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1ed:	0f b6 19             	movzbl (%ecx),%ebx
 1f0:	31 c0                	xor    %eax,%eax
 1f2:	eb db                	jmp    1cf <strcmp+0x2f>
 1f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1fb:	00 
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000200 <strlen>:

uint
strlen(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 206:	80 3a 00             	cmpb   $0x0,(%edx)
 209:	74 15                	je     220 <strlen+0x20>
 20b:	31 c0                	xor    %eax,%eax
 20d:	8d 76 00             	lea    0x0(%esi),%esi
 210:	83 c0 01             	add    $0x1,%eax
 213:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 217:	89 c1                	mov    %eax,%ecx
 219:	75 f5                	jne    210 <strlen+0x10>
    ;
  return n;
}
 21b:	89 c8                	mov    %ecx,%eax
 21d:	5d                   	pop    %ebp
 21e:	c3                   	ret
 21f:	90                   	nop
  for(n = 0; s[n]; n++)
 220:	31 c9                	xor    %ecx,%ecx
}
 222:	5d                   	pop    %ebp
 223:	89 c8                	mov    %ecx,%eax
 225:	c3                   	ret
 226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22d:	00 
 22e:	66 90                	xchg   %ax,%ax

00000230 <memset>:

void*
memset(void *dst, int c, uint n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 237:	8b 4d 10             	mov    0x10(%ebp),%ecx
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 d7                	mov    %edx,%edi
 23f:	fc                   	cld
 240:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 242:	8b 7d fc             	mov    -0x4(%ebp),%edi
 245:	89 d0                	mov    %edx,%eax
 247:	c9                   	leave
 248:	c3                   	ret
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <strchr>:

char*
strchr(const char *s, char c)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 25a:	0f b6 10             	movzbl (%eax),%edx
 25d:	84 d2                	test   %dl,%dl
 25f:	75 12                	jne    273 <strchr+0x23>
 261:	eb 1d                	jmp    280 <strchr+0x30>
 263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 268:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	84 d2                	test   %dl,%dl
 271:	74 0d                	je     280 <strchr+0x30>
    if(*s == c)
 273:	38 d1                	cmp    %dl,%cl
 275:	75 f1                	jne    268 <strchr+0x18>
      return (char*)s;
  return 0;
}
 277:	5d                   	pop    %ebp
 278:	c3                   	ret
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 280:	31 c0                	xor    %eax,%eax
}
 282:	5d                   	pop    %ebp
 283:	c3                   	ret
 284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28b:	00 
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <gets>:

char*
gets(char *buf, int max)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 295:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 298:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 299:	31 db                	xor    %ebx,%ebx
 29b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 29e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2a1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2a4:	7d 3b                	jge    2e1 <gets+0x51>
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	6a 01                	push   $0x1
 2b5:	57                   	push   %edi
 2b6:	6a 00                	push   $0x0
 2b8:	e8 1e 01 00 00       	call   3db <read>
    if(cc < 1)
 2bd:	83 c4 10             	add    $0x10,%esp
 2c0:	85 c0                	test   %eax,%eax
 2c2:	7e 1d                	jle    2e1 <gets+0x51>
      break;
      
    buf[i++] = c;
 2c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
 2cb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 2cf:	3c 0a                	cmp    $0xa,%al
 2d1:	7f 25                	jg     2f8 <gets+0x68>
 2d3:	3c 08                	cmp    $0x8,%al
 2d5:	7f 0c                	jg     2e3 <gets+0x53>
{
 2d7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 2d9:	8d 73 01             	lea    0x1(%ebx),%esi
 2dc:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2df:	7c cf                	jl     2b0 <gets+0x20>
 2e1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ed:	5b                   	pop    %ebx
 2ee:	5e                   	pop    %esi
 2ef:	5f                   	pop    %edi
 2f0:	5d                   	pop    %ebp
 2f1:	c3                   	ret
 2f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f8:	3c 0d                	cmp    $0xd,%al
 2fa:	74 e7                	je     2e3 <gets+0x53>
{
 2fc:	89 f3                	mov    %esi,%ebx
 2fe:	eb d9                	jmp    2d9 <gets+0x49>

00000300 <stat>:

int
stat(const char *n, struct stat *st)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 305:	83 ec 08             	sub    $0x8,%esp
 308:	6a 00                	push   $0x0
 30a:	ff 75 08             	push   0x8(%ebp)
 30d:	e8 f1 00 00 00       	call   403 <open>
  if(fd < 0)
 312:	83 c4 10             	add    $0x10,%esp
 315:	85 c0                	test   %eax,%eax
 317:	78 27                	js     340 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 319:	83 ec 08             	sub    $0x8,%esp
 31c:	ff 75 0c             	push   0xc(%ebp)
 31f:	89 c3                	mov    %eax,%ebx
 321:	50                   	push   %eax
 322:	e8 f4 00 00 00       	call   41b <fstat>
  close(fd);
 327:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 32a:	89 c6                	mov    %eax,%esi
  close(fd);
 32c:	e8 ba 00 00 00       	call   3eb <close>
  return r;
 331:	83 c4 10             	add    $0x10,%esp
}
 334:	8d 65 f8             	lea    -0x8(%ebp),%esp
 337:	89 f0                	mov    %esi,%eax
 339:	5b                   	pop    %ebx
 33a:	5e                   	pop    %esi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 340:	be ff ff ff ff       	mov    $0xffffffff,%esi
 345:	eb ed                	jmp    334 <stat+0x34>
 347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 34e:	00 
 34f:	90                   	nop

00000350 <atoi>:

int
atoi(const char *s)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 357:	0f be 02             	movsbl (%edx),%eax
 35a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 35d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 360:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 365:	77 1e                	ja     385 <atoi+0x35>
 367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 36e:	00 
 36f:	90                   	nop
    n = n*10 + *s++ - '0';
 370:	83 c2 01             	add    $0x1,%edx
 373:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 376:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 37a:	0f be 02             	movsbl (%edx),%eax
 37d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 380:	80 fb 09             	cmp    $0x9,%bl
 383:	76 eb                	jbe    370 <atoi+0x20>
  return n;
}
 385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 388:	89 c8                	mov    %ecx,%eax
 38a:	c9                   	leave
 38b:	c3                   	ret
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	8b 45 10             	mov    0x10(%ebp),%eax
 397:	8b 55 08             	mov    0x8(%ebp),%edx
 39a:	56                   	push   %esi
 39b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39e:	85 c0                	test   %eax,%eax
 3a0:	7e 13                	jle    3b5 <memmove+0x25>
 3a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3a4:	89 d7                	mov    %edx,%edi
 3a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ad:	00 
 3ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3b1:	39 f8                	cmp    %edi,%eax
 3b3:	75 fb                	jne    3b0 <memmove+0x20>
  return vdst;
}
 3b5:	5e                   	pop    %esi
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret

000003bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bb:	b8 01 00 00 00       	mov    $0x1,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <exit>:
SYSCALL(exit)
 3c3:	b8 02 00 00 00       	mov    $0x2,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <wait>:
SYSCALL(wait)
 3cb:	b8 03 00 00 00       	mov    $0x3,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <pipe>:
SYSCALL(pipe)
 3d3:	b8 04 00 00 00       	mov    $0x4,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <read>:
SYSCALL(read)
 3db:	b8 05 00 00 00       	mov    $0x5,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <write>:
SYSCALL(write)
 3e3:	b8 10 00 00 00       	mov    $0x10,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <close>:
SYSCALL(close)
 3eb:	b8 15 00 00 00       	mov    $0x15,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <kill>:
SYSCALL(kill)
 3f3:	b8 06 00 00 00       	mov    $0x6,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <exec>:
SYSCALL(exec)
 3fb:	b8 07 00 00 00       	mov    $0x7,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <open>:
SYSCALL(open)
 403:	b8 0f 00 00 00       	mov    $0xf,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <mknod>:
SYSCALL(mknod)
 40b:	b8 11 00 00 00       	mov    $0x11,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <unlink>:
SYSCALL(unlink)
 413:	b8 12 00 00 00       	mov    $0x12,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <fstat>:
SYSCALL(fstat)
 41b:	b8 08 00 00 00       	mov    $0x8,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <link>:
SYSCALL(link)
 423:	b8 13 00 00 00       	mov    $0x13,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <mkdir>:
SYSCALL(mkdir)
 42b:	b8 14 00 00 00       	mov    $0x14,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <chdir>:
SYSCALL(chdir)
 433:	b8 09 00 00 00       	mov    $0x9,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <dup>:
SYSCALL(dup)
 43b:	b8 0a 00 00 00       	mov    $0xa,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <getpid>:
SYSCALL(getpid)
 443:	b8 0b 00 00 00       	mov    $0xb,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <sbrk>:
SYSCALL(sbrk)
 44b:	b8 0c 00 00 00       	mov    $0xc,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <sleep>:
SYSCALL(sleep)
 453:	b8 0d 00 00 00       	mov    $0xd,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <uptime>:
SYSCALL(uptime)
 45b:	b8 0e 00 00 00       	mov    $0xe,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 463:	b8 17 00 00 00       	mov    $0x17,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <show_process_family>:
SYSCALL(show_process_family)
 46b:	b8 18 00 00 00       	mov    $0x18,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 473:	b8 16 00 00 00       	mov    $0x16,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <grep_syscall>:
SYSCALL(grep_syscall)
 47b:	b8 19 00 00 00       	mov    $0x19,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 483:	b8 1a 00 00 00       	mov    $0x1a,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 48b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 493:	b8 1c 00 00 00       	mov    $0x1c,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 49b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 4a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 4ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 4b3:	b8 20 00 00 00       	mov    $0x20,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 4bb:	b8 21 00 00 00       	mov    $0x21,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 4c3:	b8 22 00 00 00       	mov    $0x22,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <getlockstat>:

SYSCALL(getlockstat)
 4cb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret
 4d3:	66 90                	xchg   %ax,%ax
 4d5:	66 90                	xchg   %ax,%ax
 4d7:	66 90                	xchg   %ax,%ax
 4d9:	66 90                	xchg   %ax,%ax
 4db:	66 90                	xchg   %ax,%ax
 4dd:	66 90                	xchg   %ax,%ax
 4df:	90                   	nop

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4e8:	89 d1                	mov    %edx,%ecx
{
 4ea:	83 ec 3c             	sub    $0x3c,%esp
 4ed:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4f0:	85 d2                	test   %edx,%edx
 4f2:	0f 89 80 00 00 00    	jns    578 <printint+0x98>
 4f8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4fc:	74 7a                	je     578 <printint+0x98>
    x = -xx;
 4fe:	f7 d9                	neg    %ecx
    neg = 1;
 500:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 505:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 508:	31 f6                	xor    %esi,%esi
 50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 510:	89 c8                	mov    %ecx,%eax
 512:	31 d2                	xor    %edx,%edx
 514:	89 f7                	mov    %esi,%edi
 516:	f7 f3                	div    %ebx
 518:	8d 76 01             	lea    0x1(%esi),%esi
 51b:	0f b6 92 20 09 00 00 	movzbl 0x920(%edx),%edx
 522:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 526:	89 ca                	mov    %ecx,%edx
 528:	89 c1                	mov    %eax,%ecx
 52a:	39 da                	cmp    %ebx,%edx
 52c:	73 e2                	jae    510 <printint+0x30>
  if(neg)
 52e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 531:	85 c0                	test   %eax,%eax
 533:	74 07                	je     53c <printint+0x5c>
    buf[i++] = '-';
 535:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 53a:	89 f7                	mov    %esi,%edi
 53c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 53f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 542:	01 df                	add    %ebx,%edi
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 548:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 54b:	83 ec 04             	sub    $0x4,%esp
 54e:	88 45 d7             	mov    %al,-0x29(%ebp)
 551:	8d 45 d7             	lea    -0x29(%ebp),%eax
 554:	6a 01                	push   $0x1
 556:	50                   	push   %eax
 557:	56                   	push   %esi
 558:	e8 86 fe ff ff       	call   3e3 <write>
  while(--i >= 0)
 55d:	89 f8                	mov    %edi,%eax
 55f:	83 c4 10             	add    $0x10,%esp
 562:	83 ef 01             	sub    $0x1,%edi
 565:	39 c3                	cmp    %eax,%ebx
 567:	75 df                	jne    548 <printint+0x68>
}
 569:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56c:	5b                   	pop    %ebx
 56d:	5e                   	pop    %esi
 56e:	5f                   	pop    %edi
 56f:	5d                   	pop    %ebp
 570:	c3                   	ret
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 578:	31 c0                	xor    %eax,%eax
 57a:	eb 89                	jmp    505 <printint+0x25>
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 589:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 58c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 58f:	0f b6 1e             	movzbl (%esi),%ebx
 592:	83 c6 01             	add    $0x1,%esi
 595:	84 db                	test   %bl,%bl
 597:	74 67                	je     600 <printf+0x80>
 599:	8d 4d 10             	lea    0x10(%ebp),%ecx
 59c:	31 d2                	xor    %edx,%edx
 59e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5a1:	eb 34                	jmp    5d7 <printf+0x57>
 5a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5a8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5ab:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5b0:	83 f8 25             	cmp    $0x25,%eax
 5b3:	74 18                	je     5cd <printf+0x4d>
  write(fd, &c, 1);
 5b5:	83 ec 04             	sub    $0x4,%esp
 5b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5bb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5be:	6a 01                	push   $0x1
 5c0:	50                   	push   %eax
 5c1:	57                   	push   %edi
 5c2:	e8 1c fe ff ff       	call   3e3 <write>
 5c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5ca:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5cd:	0f b6 1e             	movzbl (%esi),%ebx
 5d0:	83 c6 01             	add    $0x1,%esi
 5d3:	84 db                	test   %bl,%bl
 5d5:	74 29                	je     600 <printf+0x80>
    c = fmt[i] & 0xff;
 5d7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5da:	85 d2                	test   %edx,%edx
 5dc:	74 ca                	je     5a8 <printf+0x28>
      }
    } else if(state == '%'){
 5de:	83 fa 25             	cmp    $0x25,%edx
 5e1:	75 ea                	jne    5cd <printf+0x4d>
      if(c == 'd'){
 5e3:	83 f8 25             	cmp    $0x25,%eax
 5e6:	0f 84 04 01 00 00    	je     6f0 <printf+0x170>
 5ec:	83 e8 63             	sub    $0x63,%eax
 5ef:	83 f8 15             	cmp    $0x15,%eax
 5f2:	77 1c                	ja     610 <printf+0x90>
 5f4:	ff 24 85 c8 08 00 00 	jmp    *0x8c8(,%eax,4)
 5fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 600:	8d 65 f4             	lea    -0xc(%ebp),%esp
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret
 608:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 60f:	00 
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	8d 55 e7             	lea    -0x19(%ebp),%edx
 616:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61a:	6a 01                	push   $0x1
 61c:	52                   	push   %edx
 61d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 620:	57                   	push   %edi
 621:	e8 bd fd ff ff       	call   3e3 <write>
 626:	83 c4 0c             	add    $0xc,%esp
 629:	88 5d e7             	mov    %bl,-0x19(%ebp)
 62c:	6a 01                	push   $0x1
 62e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 631:	52                   	push   %edx
 632:	57                   	push   %edi
 633:	e8 ab fd ff ff       	call   3e3 <write>
        putc(fd, c);
 638:	83 c4 10             	add    $0x10,%esp
      state = 0;
 63b:	31 d2                	xor    %edx,%edx
 63d:	eb 8e                	jmp    5cd <printf+0x4d>
 63f:	90                   	nop
        printint(fd, *ap, 16, 0);
 640:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 643:	83 ec 0c             	sub    $0xc,%esp
 646:	b9 10 00 00 00       	mov    $0x10,%ecx
 64b:	8b 13                	mov    (%ebx),%edx
 64d:	6a 00                	push   $0x0
 64f:	89 f8                	mov    %edi,%eax
        ap++;
 651:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 654:	e8 87 fe ff ff       	call   4e0 <printint>
        ap++;
 659:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 65c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65f:	31 d2                	xor    %edx,%edx
 661:	e9 67 ff ff ff       	jmp    5cd <printf+0x4d>
        s = (char*)*ap;
 666:	8b 45 d0             	mov    -0x30(%ebp),%eax
 669:	8b 18                	mov    (%eax),%ebx
        ap++;
 66b:	83 c0 04             	add    $0x4,%eax
 66e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 671:	85 db                	test   %ebx,%ebx
 673:	0f 84 87 00 00 00    	je     700 <printf+0x180>
        while(*s != 0){
 679:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 67c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 67e:	84 c0                	test   %al,%al
 680:	0f 84 47 ff ff ff    	je     5cd <printf+0x4d>
 686:	8d 55 e7             	lea    -0x19(%ebp),%edx
 689:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 68c:	89 de                	mov    %ebx,%esi
 68e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
 693:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 696:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 699:	6a 01                	push   $0x1
 69b:	53                   	push   %ebx
 69c:	57                   	push   %edi
 69d:	e8 41 fd ff ff       	call   3e3 <write>
        while(*s != 0){
 6a2:	0f b6 06             	movzbl (%esi),%eax
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	84 c0                	test   %al,%al
 6aa:	75 e4                	jne    690 <printf+0x110>
      state = 0;
 6ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6af:	31 d2                	xor    %edx,%edx
 6b1:	e9 17 ff ff ff       	jmp    5cd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6b9:	83 ec 0c             	sub    $0xc,%esp
 6bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c1:	8b 13                	mov    (%ebx),%edx
 6c3:	6a 01                	push   $0x1
 6c5:	eb 88                	jmp    64f <printf+0xcf>
        putc(fd, *ap);
 6c7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6ca:	83 ec 04             	sub    $0x4,%esp
 6cd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6d0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6d2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6d5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
 6da:	52                   	push   %edx
 6db:	57                   	push   %edi
 6dc:	e8 02 fd ff ff       	call   3e3 <write>
        ap++;
 6e1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6e4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6e7:	31 d2                	xor    %edx,%edx
 6e9:	e9 df fe ff ff       	jmp    5cd <printf+0x4d>
 6ee:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6f9:	6a 01                	push   $0x1
 6fb:	e9 31 ff ff ff       	jmp    631 <printf+0xb1>
 700:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 705:	bb be 08 00 00       	mov    $0x8be,%ebx
 70a:	e9 77 ff ff ff       	jmp    686 <printf+0x106>
 70f:	90                   	nop

00000710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 710:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	a1 c0 0b 00 00       	mov    0xbc0,%eax
{
 716:	89 e5                	mov    %esp,%ebp
 718:	57                   	push   %edi
 719:	56                   	push   %esi
 71a:	53                   	push   %ebx
 71b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 71e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	39 c8                	cmp    %ecx,%eax
 72c:	73 32                	jae    760 <free+0x50>
 72e:	39 d1                	cmp    %edx,%ecx
 730:	72 04                	jb     736 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 732:	39 d0                	cmp    %edx,%eax
 734:	72 32                	jb     768 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 736:	8b 73 fc             	mov    -0x4(%ebx),%esi
 739:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73c:	39 fa                	cmp    %edi,%edx
 73e:	74 30                	je     770 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 749:	39 f1                	cmp    %esi,%ecx
 74b:	74 3a                	je     787 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 74d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 74f:	5b                   	pop    %ebx
  freep = p;
 750:	a3 c0 0b 00 00       	mov    %eax,0xbc0
}
 755:	5e                   	pop    %esi
 756:	5f                   	pop    %edi
 757:	5d                   	pop    %ebp
 758:	c3                   	ret
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 760:	39 d0                	cmp    %edx,%eax
 762:	72 04                	jb     768 <free+0x58>
 764:	39 d1                	cmp    %edx,%ecx
 766:	72 ce                	jb     736 <free+0x26>
{
 768:	89 d0                	mov    %edx,%eax
 76a:	eb bc                	jmp    728 <free+0x18>
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 770:	03 72 04             	add    0x4(%edx),%esi
 773:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 12                	mov    (%edx),%edx
 77a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 77d:	8b 50 04             	mov    0x4(%eax),%edx
 780:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 783:	39 f1                	cmp    %esi,%ecx
 785:	75 c6                	jne    74d <free+0x3d>
    p->s.size += bp->s.size;
 787:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 78a:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    p->s.size += bp->s.size;
 78f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 792:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 795:	89 08                	mov    %ecx,(%eax)
}
 797:	5b                   	pop    %ebx
 798:	5e                   	pop    %esi
 799:	5f                   	pop    %edi
 79a:	5d                   	pop    %ebp
 79b:	c3                   	ret
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ac:	8b 15 c0 0b 00 00    	mov    0xbc0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	8d 78 07             	lea    0x7(%eax),%edi
 7b5:	c1 ef 03             	shr    $0x3,%edi
 7b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7bb:	85 d2                	test   %edx,%edx
 7bd:	0f 84 8d 00 00 00    	je     850 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7c5:	8b 48 04             	mov    0x4(%eax),%ecx
 7c8:	39 f9                	cmp    %edi,%ecx
 7ca:	73 64                	jae    830 <malloc+0x90>
  if(nu < 4096)
 7cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7d1:	39 df                	cmp    %ebx,%edi
 7d3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7d6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7dd:	eb 0a                	jmp    7e9 <malloc+0x49>
 7df:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7e2:	8b 48 04             	mov    0x4(%eax),%ecx
 7e5:	39 f9                	cmp    %edi,%ecx
 7e7:	73 47                	jae    830 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e9:	89 c2                	mov    %eax,%edx
 7eb:	3b 05 c0 0b 00 00    	cmp    0xbc0,%eax
 7f1:	75 ed                	jne    7e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	56                   	push   %esi
 7f7:	e8 4f fc ff ff       	call   44b <sbrk>
  if(p == (char*)-1)
 7fc:	83 c4 10             	add    $0x10,%esp
 7ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 802:	74 1c                	je     820 <malloc+0x80>
  hp->s.size = nu;
 804:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 807:	83 ec 0c             	sub    $0xc,%esp
 80a:	83 c0 08             	add    $0x8,%eax
 80d:	50                   	push   %eax
 80e:	e8 fd fe ff ff       	call   710 <free>
  return freep;
 813:	8b 15 c0 0b 00 00    	mov    0xbc0,%edx
      if((p = morecore(nunits)) == 0)
 819:	83 c4 10             	add    $0x10,%esp
 81c:	85 d2                	test   %edx,%edx
 81e:	75 c0                	jne    7e0 <malloc+0x40>
        return 0;
  }
}
 820:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 823:	31 c0                	xor    %eax,%eax
}
 825:	5b                   	pop    %ebx
 826:	5e                   	pop    %esi
 827:	5f                   	pop    %edi
 828:	5d                   	pop    %ebp
 829:	c3                   	ret
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 830:	39 cf                	cmp    %ecx,%edi
 832:	74 4c                	je     880 <malloc+0xe0>
        p->s.size -= nunits;
 834:	29 f9                	sub    %edi,%ecx
 836:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 839:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 83c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 83f:	89 15 c0 0b 00 00    	mov    %edx,0xbc0
}
 845:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 848:	83 c0 08             	add    $0x8,%eax
}
 84b:	5b                   	pop    %ebx
 84c:	5e                   	pop    %esi
 84d:	5f                   	pop    %edi
 84e:	5d                   	pop    %ebp
 84f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 850:	c7 05 c0 0b 00 00 c4 	movl   $0xbc4,0xbc0
 857:	0b 00 00 
    base.s.size = 0;
 85a:	b8 c4 0b 00 00       	mov    $0xbc4,%eax
    base.s.ptr = freep = prevp = &base;
 85f:	c7 05 c4 0b 00 00 c4 	movl   $0xbc4,0xbc4
 866:	0b 00 00 
    base.s.size = 0;
 869:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 870:	00 00 00 
    if(p->s.size >= nunits){
 873:	e9 54 ff ff ff       	jmp    7cc <malloc+0x2c>
 878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 87f:	00 
        prevp->s.ptr = p->s.ptr;
 880:	8b 08                	mov    (%eax),%ecx
 882:	89 0a                	mov    %ecx,(%edx)
 884:	eb b9                	jmp    83f <malloc+0x9f>
