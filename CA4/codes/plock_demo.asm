
_plock_demo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  int holder_pr = 1;
  int prios[] = { 40, 10, 50, 20, 30 };
  14:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
  1b:	c7 45 d8 0a 00 00 00 	movl   $0xa,-0x28(%ebp)
  22:	c7 45 dc 32 00 00 00 	movl   $0x32,-0x24(%ebp)
  29:	c7 45 e0 14 00 00 00 	movl   $0x14,-0x20(%ebp)
  30:	c7 45 e4 1e 00 00 00 	movl   $0x1e,-0x1c(%ebp)
  int n = sizeof(prios) / sizeof(prios[0]);

  printf(1, "\n[plock_demo] Starting (PID %d)\n", getpid());
  37:	e8 47 04 00 00       	call   483 <getpid>
  3c:	83 ec 04             	sub    $0x4,%esp
  3f:	50                   	push   %eax
  40:	68 b8 08 00 00       	push   $0x8b8
  45:	6a 01                	push   $0x1
  47:	e8 64 05 00 00       	call   5b0 <printf>

  int holder = fork();
  4c:	e8 aa 03 00 00       	call   3fb <fork>
  if(holder < 0){
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	0f 88 bc 00 00 00    	js     118 <main+0x118>
    printf(1, "[plock_demo] fork failed\n");
    exit();
  }

  if(holder == 0){
  5c:	74 6e                	je     cc <main+0xcc>
    release_plock_sys();

    exit();
  }

  sleep(50);
  5e:	83 ec 0c             	sub    $0xc,%esp

  for(int i = 0; i < n; i++){
  61:	31 f6                	xor    %esi,%esi
  sleep(50);
  63:	6a 32                	push   $0x32
  65:	e8 29 04 00 00       	call   493 <sleep>
  6a:	83 c4 10             	add    $0x10,%esp
    int pr = prios[i];
  6d:	8b 7c b5 d4          	mov    -0x2c(%ebp,%esi,4),%edi
    int pid = fork();
  71:	e8 85 03 00 00       	call   3fb <fork>
  76:	89 c3                	mov    %eax,%ebx

    if(pid < 0){
  78:	85 c0                	test   %eax,%eax
  7a:	0f 88 ab 00 00 00    	js     12b <main+0x12b>
      printf(1, "[plock_demo] fork failed at i=%d\n", i);
      continue;
    }

    if(pid == 0){
  80:	0f 84 bb 00 00 00    	je     141 <main+0x141>
      release_plock_sys();

      exit();
    }

    sleep(10);
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	6a 0a                	push   $0xa
  8b:	e8 03 04 00 00       	call   493 <sleep>
  90:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < n; i++){
  93:	83 c6 01             	add    $0x1,%esi
  96:	83 fe 05             	cmp    $0x5,%esi
  99:	75 d2                	jne    6d <main+0x6d>
  }

  for(int i = 0; i < n + 1; i++){
    wait();
  9b:	e8 6b 03 00 00       	call   40b <wait>
  a0:	e8 66 03 00 00       	call   40b <wait>
  a5:	e8 61 03 00 00       	call   40b <wait>
  aa:	e8 5c 03 00 00       	call   40b <wait>
  af:	e8 57 03 00 00       	call   40b <wait>
  b4:	e8 52 03 00 00       	call   40b <wait>
  }

  printf(1, "[plock_demo] Done.\n\n");
  b9:	50                   	push   %eax
  ba:	50                   	push   %eax
  bb:	68 10 0a 00 00       	push   $0xa10
  c0:	6a 01                	push   $0x1
  c2:	e8 e9 04 00 00       	call   5b0 <printf>
  exit();
  c7:	e8 37 03 00 00       	call   403 <exit>
    acquire_plock_sys(holder_pr);
  cc:	83 ec 0c             	sub    $0xc,%esp
  cf:	6a 01                	push   $0x1
  d1:	e8 25 04 00 00       	call   4fb <acquire_plock_sys>
    printf(1, "[plock_demo] HOLDER acquired lock | pid=%d pr=%d\n", getpid(), holder_pr);
  d6:	e8 a8 03 00 00       	call   483 <getpid>
  db:	6a 01                	push   $0x1
  dd:	50                   	push   %eax
  de:	68 dc 08 00 00       	push   $0x8dc
  e3:	6a 01                	push   $0x1
  e5:	e8 c6 04 00 00       	call   5b0 <printf>
    sleep(200);
  ea:	83 c4 14             	add    $0x14,%esp
  ed:	68 c8 00 00 00       	push   $0xc8
  f2:	e8 9c 03 00 00       	call   493 <sleep>
    printf(1, "[plock_demo] HOLDER releasing lock | pid=%d pr=%d\n", getpid(), holder_pr);
  f7:	e8 87 03 00 00       	call   483 <getpid>
  fc:	6a 01                	push   $0x1
  fe:	50                   	push   %eax
  ff:	68 10 09 00 00       	push   $0x910
 104:	6a 01                	push   $0x1
 106:	e8 a5 04 00 00       	call   5b0 <printf>
    release_plock_sys();
 10b:	83 c4 20             	add    $0x20,%esp
 10e:	e8 f0 03 00 00       	call   503 <release_plock_sys>
    exit();
 113:	e8 eb 02 00 00       	call   403 <exit>
    printf(1, "[plock_demo] fork failed\n");
 118:	53                   	push   %ebx
 119:	53                   	push   %ebx
 11a:	68 f6 09 00 00       	push   $0x9f6
 11f:	6a 01                	push   $0x1
 121:	e8 8a 04 00 00       	call   5b0 <printf>
    exit();
 126:	e8 d8 02 00 00       	call   403 <exit>
      printf(1, "[plock_demo] fork failed at i=%d\n", i);
 12b:	51                   	push   %ecx
 12c:	56                   	push   %esi
 12d:	68 44 09 00 00       	push   $0x944
 132:	6a 01                	push   $0x1
 134:	e8 77 04 00 00       	call   5b0 <printf>
      continue;
 139:	83 c4 10             	add    $0x10,%esp
 13c:	e9 52 ff ff ff       	jmp    93 <main+0x93>
      printf(1, "[plock_demo] waiter started | pid=%d pr=%d\n", getpid(), pr);
 141:	e8 3d 03 00 00       	call   483 <getpid>
 146:	57                   	push   %edi
 147:	50                   	push   %eax
 148:	68 68 09 00 00       	push   $0x968
 14d:	6a 01                	push   $0x1
 14f:	e8 5c 04 00 00       	call   5b0 <printf>
      acquire_plock_sys(pr);
 154:	89 3c 24             	mov    %edi,(%esp)
 157:	e8 9f 03 00 00       	call   4fb <acquire_plock_sys>
      printf(1, "[plock_demo] >>> waiter ACQUIRED | pid=%d pr=%d\n", getpid(), pr);
 15c:	e8 22 03 00 00       	call   483 <getpid>
 161:	57                   	push   %edi
 162:	50                   	push   %eax
 163:	68 94 09 00 00       	push   $0x994
 168:	6a 01                	push   $0x1
 16a:	e8 41 04 00 00       	call   5b0 <printf>
  volatile int x = 0;
 16f:	31 d2                	xor    %edx,%edx
 171:	83 c4 20             	add    $0x20,%esp
 174:	89 55 d0             	mov    %edx,-0x30(%ebp)
    x += i;
 177:	8b 45 d0             	mov    -0x30(%ebp),%eax
 17a:	01 d8                	add    %ebx,%eax
  for(int i = 0; i < loops; i++){
 17c:	83 c3 01             	add    $0x1,%ebx
    x += i;
 17f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  for(int i = 0; i < loops; i++){
 182:	81 fb 80 84 1e 00    	cmp    $0x1e8480,%ebx
 188:	75 ed                	jne    177 <main+0x177>
      printf(1, "[plock_demo] waiter releasing | pid=%d pr=%d\n", getpid(), pr);
 18a:	e8 f4 02 00 00       	call   483 <getpid>
 18f:	57                   	push   %edi
 190:	50                   	push   %eax
 191:	68 c8 09 00 00       	push   $0x9c8
 196:	6a 01                	push   $0x1
 198:	e8 13 04 00 00       	call   5b0 <printf>
      release_plock_sys();
 19d:	e8 61 03 00 00       	call   503 <release_plock_sys>
      exit();
 1a2:	e8 5c 02 00 00       	call   403 <exit>
 1a7:	66 90                	xchg   %ax,%ax
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b1:	31 c0                	xor    %eax,%eax
{
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	53                   	push   %ebx
 1b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1c7:	83 c0 01             	add    $0x1,%eax
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1d1:	89 c8                	mov    %ecx,%eax
 1d3:	c9                   	leave
 1d4:	c3                   	ret
 1d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1dc:	00 
 1dd:	8d 76 00             	lea    0x0(%esi),%esi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ea:	0f b6 02             	movzbl (%edx),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	75 17                	jne    208 <strcmp+0x28>
 1f1:	eb 3a                	jmp    22d <strcmp+0x4d>
 1f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1fc:	83 c2 01             	add    $0x1,%edx
 1ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 202:	84 c0                	test   %al,%al
 204:	74 1a                	je     220 <strcmp+0x40>
 206:	89 d9                	mov    %ebx,%ecx
 208:	0f b6 19             	movzbl (%ecx),%ebx
 20b:	38 c3                	cmp    %al,%bl
 20d:	74 e9                	je     1f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 20f:	29 d8                	sub    %ebx,%eax
}
 211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 214:	c9                   	leave
 215:	c3                   	ret
 216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21d:	00 
 21e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 220:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 224:	31 c0                	xor    %eax,%eax
 226:	29 d8                	sub    %ebx,%eax
}
 228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 22b:	c9                   	leave
 22c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 22d:	0f b6 19             	movzbl (%ecx),%ebx
 230:	31 c0                	xor    %eax,%eax
 232:	eb db                	jmp    20f <strcmp+0x2f>
 234:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 23b:	00 
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <strlen>:

uint
strlen(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 246:	80 3a 00             	cmpb   $0x0,(%edx)
 249:	74 15                	je     260 <strlen+0x20>
 24b:	31 c0                	xor    %eax,%eax
 24d:	8d 76 00             	lea    0x0(%esi),%esi
 250:	83 c0 01             	add    $0x1,%eax
 253:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 257:	89 c1                	mov    %eax,%ecx
 259:	75 f5                	jne    250 <strlen+0x10>
    ;
  return n;
}
 25b:	89 c8                	mov    %ecx,%eax
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret
 25f:	90                   	nop
  for(n = 0; s[n]; n++)
 260:	31 c9                	xor    %ecx,%ecx
}
 262:	5d                   	pop    %ebp
 263:	89 c8                	mov    %ecx,%eax
 265:	c3                   	ret
 266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26d:	00 
 26e:	66 90                	xchg   %ax,%ax

00000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 277:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 d7                	mov    %edx,%edi
 27f:	fc                   	cld
 280:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 282:	8b 7d fc             	mov    -0x4(%ebp),%edi
 285:	89 d0                	mov    %edx,%eax
 287:	c9                   	leave
 288:	c3                   	ret
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 29a:	0f b6 10             	movzbl (%eax),%edx
 29d:	84 d2                	test   %dl,%dl
 29f:	75 12                	jne    2b3 <strchr+0x23>
 2a1:	eb 1d                	jmp    2c0 <strchr+0x30>
 2a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2ac:	83 c0 01             	add    $0x1,%eax
 2af:	84 d2                	test   %dl,%dl
 2b1:	74 0d                	je     2c0 <strchr+0x30>
    if(*s == c)
 2b3:	38 d1                	cmp    %dl,%cl
 2b5:	75 f1                	jne    2a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2c0:	31 c0                	xor    %eax,%eax
}
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret
 2c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cb:	00 
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <gets>:

char*
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2d9:	31 db                	xor    %ebx,%ebx
 2db:	8d 73 01             	lea    0x1(%ebx),%esi
{
 2de:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2e1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2e4:	7d 3b                	jge    321 <gets+0x51>
 2e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ed:	00 
 2ee:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	6a 01                	push   $0x1
 2f5:	57                   	push   %edi
 2f6:	6a 00                	push   $0x0
 2f8:	e8 1e 01 00 00       	call   41b <read>
    if(cc < 1)
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	7e 1d                	jle    321 <gets+0x51>
      break;
      
    buf[i++] = c;
 304:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 308:	8b 55 08             	mov    0x8(%ebp),%edx
 30b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 30f:	3c 0a                	cmp    $0xa,%al
 311:	7f 25                	jg     338 <gets+0x68>
 313:	3c 08                	cmp    $0x8,%al
 315:	7f 0c                	jg     323 <gets+0x53>
{
 317:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 319:	8d 73 01             	lea    0x1(%ebx),%esi
 31c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 31f:	7c cf                	jl     2f0 <gets+0x20>
 321:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 32a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32d:	5b                   	pop    %ebx
 32e:	5e                   	pop    %esi
 32f:	5f                   	pop    %edi
 330:	5d                   	pop    %ebp
 331:	c3                   	ret
 332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 338:	3c 0d                	cmp    $0xd,%al
 33a:	74 e7                	je     323 <gets+0x53>
{
 33c:	89 f3                	mov    %esi,%ebx
 33e:	eb d9                	jmp    319 <gets+0x49>

00000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	push   0x8(%ebp)
 34d:	e8 f1 00 00 00       	call   443 <open>
  if(fd < 0)
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	push   0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f4 00 00 00       	call   45b <fstat>
  close(fd);
 367:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 36a:	89 c6                	mov    %eax,%esi
  close(fd);
 36c:	e8 ba 00 00 00       	call   42b <close>
  return r;
 371:	83 c4 10             	add    $0x10,%esp
}
 374:	8d 65 f8             	lea    -0x8(%ebp),%esp
 377:	89 f0                	mov    %esi,%eax
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret
 37d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 380:	be ff ff ff ff       	mov    $0xffffffff,%esi
 385:	eb ed                	jmp    374 <stat+0x34>
 387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38e:	00 
 38f:	90                   	nop

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 397:	0f be 02             	movsbl (%edx),%eax
 39a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 39d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3a5:	77 1e                	ja     3c5 <atoi+0x35>
 3a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ae:	00 
 3af:	90                   	nop
    n = n*10 + *s++ - '0';
 3b0:	83 c2 01             	add    $0x1,%edx
 3b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ba:	0f be 02             	movsbl (%edx),%eax
 3bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
  return n;
}
 3c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c8:	89 c8                	mov    %ecx,%eax
 3ca:	c9                   	leave
 3cb:	c3                   	ret
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 45 10             	mov    0x10(%ebp),%eax
 3d7:	8b 55 08             	mov    0x8(%ebp),%edx
 3da:	56                   	push   %esi
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 13                	jle    3f5 <memmove+0x25>
 3e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3e4:	89 d7                	mov    %edx,%edi
 3e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ed:	00 
 3ee:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3f1:	39 f8                	cmp    %edi,%eax
 3f3:	75 fb                	jne    3f0 <memmove+0x20>
  return vdst;
}
 3f5:	5e                   	pop    %esi
 3f6:	89 d0                	mov    %edx,%eax
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret

000003fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fb:	b8 01 00 00 00       	mov    $0x1,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <exit>:
SYSCALL(exit)
 403:	b8 02 00 00 00       	mov    $0x2,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <wait>:
SYSCALL(wait)
 40b:	b8 03 00 00 00       	mov    $0x3,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <pipe>:
SYSCALL(pipe)
 413:	b8 04 00 00 00       	mov    $0x4,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <read>:
SYSCALL(read)
 41b:	b8 05 00 00 00       	mov    $0x5,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <write>:
SYSCALL(write)
 423:	b8 10 00 00 00       	mov    $0x10,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <close>:
SYSCALL(close)
 42b:	b8 15 00 00 00       	mov    $0x15,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <kill>:
SYSCALL(kill)
 433:	b8 06 00 00 00       	mov    $0x6,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <exec>:
SYSCALL(exec)
 43b:	b8 07 00 00 00       	mov    $0x7,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <open>:
SYSCALL(open)
 443:	b8 0f 00 00 00       	mov    $0xf,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <mknod>:
SYSCALL(mknod)
 44b:	b8 11 00 00 00       	mov    $0x11,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <unlink>:
SYSCALL(unlink)
 453:	b8 12 00 00 00       	mov    $0x12,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <fstat>:
SYSCALL(fstat)
 45b:	b8 08 00 00 00       	mov    $0x8,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <link>:
SYSCALL(link)
 463:	b8 13 00 00 00       	mov    $0x13,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <mkdir>:
SYSCALL(mkdir)
 46b:	b8 14 00 00 00       	mov    $0x14,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <chdir>:
SYSCALL(chdir)
 473:	b8 09 00 00 00       	mov    $0x9,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <dup>:
SYSCALL(dup)
 47b:	b8 0a 00 00 00       	mov    $0xa,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <getpid>:
SYSCALL(getpid)
 483:	b8 0b 00 00 00       	mov    $0xb,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <sbrk>:
SYSCALL(sbrk)
 48b:	b8 0c 00 00 00       	mov    $0xc,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <sleep>:
SYSCALL(sleep)
 493:	b8 0d 00 00 00       	mov    $0xd,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <uptime>:
SYSCALL(uptime)
 49b:	b8 0e 00 00 00       	mov    $0xe,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 4a3:	b8 17 00 00 00       	mov    $0x17,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <show_process_family>:
SYSCALL(show_process_family)
 4ab:	b8 18 00 00 00       	mov    $0x18,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 4b3:	b8 16 00 00 00       	mov    $0x16,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <grep_syscall>:
SYSCALL(grep_syscall)
 4bb:	b8 19 00 00 00       	mov    $0x19,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 4c3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 4cb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 4d3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 4db:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 4e3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 4eb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 4f3:	b8 20 00 00 00       	mov    $0x20,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 4fb:	b8 21 00 00 00       	mov    $0x21,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <release_plock_sys>:
SYSCALL(release_plock_sys)
 503:	b8 22 00 00 00       	mov    $0x22,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 518:	89 d1                	mov    %edx,%ecx
{
 51a:	83 ec 3c             	sub    $0x3c,%esp
 51d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 520:	85 d2                	test   %edx,%edx
 522:	0f 89 80 00 00 00    	jns    5a8 <printint+0x98>
 528:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 52c:	74 7a                	je     5a8 <printint+0x98>
    x = -xx;
 52e:	f7 d9                	neg    %ecx
    neg = 1;
 530:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 535:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 538:	31 f6                	xor    %esi,%esi
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 540:	89 c8                	mov    %ecx,%eax
 542:	31 d2                	xor    %edx,%edx
 544:	89 f7                	mov    %esi,%edi
 546:	f7 f3                	div    %ebx
 548:	8d 76 01             	lea    0x1(%esi),%esi
 54b:	0f b6 92 84 0a 00 00 	movzbl 0xa84(%edx),%edx
 552:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 556:	89 ca                	mov    %ecx,%edx
 558:	89 c1                	mov    %eax,%ecx
 55a:	39 da                	cmp    %ebx,%edx
 55c:	73 e2                	jae    540 <printint+0x30>
  if(neg)
 55e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 561:	85 c0                	test   %eax,%eax
 563:	74 07                	je     56c <printint+0x5c>
    buf[i++] = '-';
 565:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 56a:	89 f7                	mov    %esi,%edi
 56c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 56f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 572:	01 df                	add    %ebx,%edi
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 578:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	88 45 d7             	mov    %al,-0x29(%ebp)
 581:	8d 45 d7             	lea    -0x29(%ebp),%eax
 584:	6a 01                	push   $0x1
 586:	50                   	push   %eax
 587:	56                   	push   %esi
 588:	e8 96 fe ff ff       	call   423 <write>
  while(--i >= 0)
 58d:	89 f8                	mov    %edi,%eax
 58f:	83 c4 10             	add    $0x10,%esp
 592:	83 ef 01             	sub    $0x1,%edi
 595:	39 c3                	cmp    %eax,%ebx
 597:	75 df                	jne    578 <printint+0x68>
}
 599:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59c:	5b                   	pop    %ebx
 59d:	5e                   	pop    %esi
 59e:	5f                   	pop    %edi
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	31 c0                	xor    %eax,%eax
 5aa:	eb 89                	jmp    535 <printint+0x25>
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 5bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 5bf:	0f b6 1e             	movzbl (%esi),%ebx
 5c2:	83 c6 01             	add    $0x1,%esi
 5c5:	84 db                	test   %bl,%bl
 5c7:	74 67                	je     630 <printf+0x80>
 5c9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5cc:	31 d2                	xor    %edx,%edx
 5ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5d1:	eb 34                	jmp    607 <printf+0x57>
 5d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5db:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5e0:	83 f8 25             	cmp    $0x25,%eax
 5e3:	74 18                	je     5fd <printf+0x4d>
  write(fd, &c, 1);
 5e5:	83 ec 04             	sub    $0x4,%esp
 5e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5eb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ee:	6a 01                	push   $0x1
 5f0:	50                   	push   %eax
 5f1:	57                   	push   %edi
 5f2:	e8 2c fe ff ff       	call   423 <write>
 5f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5fd:	0f b6 1e             	movzbl (%esi),%ebx
 600:	83 c6 01             	add    $0x1,%esi
 603:	84 db                	test   %bl,%bl
 605:	74 29                	je     630 <printf+0x80>
    c = fmt[i] & 0xff;
 607:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 60a:	85 d2                	test   %edx,%edx
 60c:	74 ca                	je     5d8 <printf+0x28>
      }
    } else if(state == '%'){
 60e:	83 fa 25             	cmp    $0x25,%edx
 611:	75 ea                	jne    5fd <printf+0x4d>
      if(c == 'd'){
 613:	83 f8 25             	cmp    $0x25,%eax
 616:	0f 84 04 01 00 00    	je     720 <printf+0x170>
 61c:	83 e8 63             	sub    $0x63,%eax
 61f:	83 f8 15             	cmp    $0x15,%eax
 622:	77 1c                	ja     640 <printf+0x90>
 624:	ff 24 85 2c 0a 00 00 	jmp    *0xa2c(,%eax,4)
 62b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 630:	8d 65 f4             	lea    -0xc(%ebp),%esp
 633:	5b                   	pop    %ebx
 634:	5e                   	pop    %esi
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret
 638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 63f:	00 
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	8d 55 e7             	lea    -0x19(%ebp),%edx
 646:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	52                   	push   %edx
 64d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 650:	57                   	push   %edi
 651:	e8 cd fd ff ff       	call   423 <write>
 656:	83 c4 0c             	add    $0xc,%esp
 659:	88 5d e7             	mov    %bl,-0x19(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 661:	52                   	push   %edx
 662:	57                   	push   %edi
 663:	e8 bb fd ff ff       	call   423 <write>
        putc(fd, c);
 668:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66b:	31 d2                	xor    %edx,%edx
 66d:	eb 8e                	jmp    5fd <printf+0x4d>
 66f:	90                   	nop
        printint(fd, *ap, 16, 0);
 670:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 673:	83 ec 0c             	sub    $0xc,%esp
 676:	b9 10 00 00 00       	mov    $0x10,%ecx
 67b:	8b 13                	mov    (%ebx),%edx
 67d:	6a 00                	push   $0x0
 67f:	89 f8                	mov    %edi,%eax
        ap++;
 681:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 684:	e8 87 fe ff ff       	call   510 <printint>
        ap++;
 689:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 68c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 67 ff ff ff       	jmp    5fd <printf+0x4d>
        s = (char*)*ap;
 696:	8b 45 d0             	mov    -0x30(%ebp),%eax
 699:	8b 18                	mov    (%eax),%ebx
        ap++;
 69b:	83 c0 04             	add    $0x4,%eax
 69e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6a1:	85 db                	test   %ebx,%ebx
 6a3:	0f 84 87 00 00 00    	je     730 <printf+0x180>
        while(*s != 0){
 6a9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6ac:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6ae:	84 c0                	test   %al,%al
 6b0:	0f 84 47 ff ff ff    	je     5fd <printf+0x4d>
 6b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6b9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6bc:	89 de                	mov    %ebx,%esi
 6be:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6c6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6c9:	6a 01                	push   $0x1
 6cb:	53                   	push   %ebx
 6cc:	57                   	push   %edi
 6cd:	e8 51 fd ff ff       	call   423 <write>
        while(*s != 0){
 6d2:	0f b6 06             	movzbl (%esi),%eax
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	84 c0                	test   %al,%al
 6da:	75 e4                	jne    6c0 <printf+0x110>
      state = 0;
 6dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 17 ff ff ff       	jmp    5fd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6e6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f1:	8b 13                	mov    (%ebx),%edx
 6f3:	6a 01                	push   $0x1
 6f5:	eb 88                	jmp    67f <printf+0xcf>
        putc(fd, *ap);
 6f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6fa:	83 ec 04             	sub    $0x4,%esp
 6fd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 700:	8b 03                	mov    (%ebx),%eax
        ap++;
 702:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 705:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
 70a:	52                   	push   %edx
 70b:	57                   	push   %edi
 70c:	e8 12 fd ff ff       	call   423 <write>
        ap++;
 711:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 714:	83 c4 10             	add    $0x10,%esp
      state = 0;
 717:	31 d2                	xor    %edx,%edx
 719:	e9 df fe ff ff       	jmp    5fd <printf+0x4d>
 71e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
 723:	88 5d e7             	mov    %bl,-0x19(%ebp)
 726:	8d 55 e7             	lea    -0x19(%ebp),%edx
 729:	6a 01                	push   $0x1
 72b:	e9 31 ff ff ff       	jmp    661 <printf+0xb1>
 730:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 735:	bb 25 0a 00 00       	mov    $0xa25,%ebx
 73a:	e9 77 ff ff ff       	jmp    6b6 <printf+0x106>
 73f:	90                   	nop

00000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 2c 0d 00 00       	mov    0xd2c,%eax
{
 746:	89 e5                	mov    %esp,%ebp
 748:	57                   	push   %edi
 749:	56                   	push   %esi
 74a:	53                   	push   %ebx
 74b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 74e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	39 c8                	cmp    %ecx,%eax
 75c:	73 32                	jae    790 <free+0x50>
 75e:	39 d1                	cmp    %edx,%ecx
 760:	72 04                	jb     766 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	39 d0                	cmp    %edx,%eax
 764:	72 32                	jb     798 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 766:	8b 73 fc             	mov    -0x4(%ebx),%esi
 769:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 76c:	39 fa                	cmp    %edi,%edx
 76e:	74 30                	je     7a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 773:	8b 50 04             	mov    0x4(%eax),%edx
 776:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 779:	39 f1                	cmp    %esi,%ecx
 77b:	74 3a                	je     7b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 77d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 77f:	5b                   	pop    %ebx
  freep = p;
 780:	a3 2c 0d 00 00       	mov    %eax,0xd2c
}
 785:	5e                   	pop    %esi
 786:	5f                   	pop    %edi
 787:	5d                   	pop    %ebp
 788:	c3                   	ret
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 d0                	cmp    %edx,%eax
 792:	72 04                	jb     798 <free+0x58>
 794:	39 d1                	cmp    %edx,%ecx
 796:	72 ce                	jb     766 <free+0x26>
{
 798:	89 d0                	mov    %edx,%eax
 79a:	eb bc                	jmp    758 <free+0x18>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7a0:	03 72 04             	add    0x4(%edx),%esi
 7a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 12                	mov    (%edx),%edx
 7aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b3:	39 f1                	cmp    %esi,%ecx
 7b5:	75 c6                	jne    77d <free+0x3d>
    p->s.size += bp->s.size;
 7b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ba:	a3 2c 0d 00 00       	mov    %eax,0xd2c
    p->s.size += bp->s.size;
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7c5:	89 08                	mov    %ecx,(%eax)
}
 7c7:	5b                   	pop    %ebx
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7dc:	8b 15 2c 0d 00 00    	mov    0xd2c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8d 78 07             	lea    0x7(%eax),%edi
 7e5:	c1 ef 03             	shr    $0x3,%edi
 7e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7eb:	85 d2                	test   %edx,%edx
 7ed:	0f 84 8d 00 00 00    	je     880 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f5:	8b 48 04             	mov    0x4(%eax),%ecx
 7f8:	39 f9                	cmp    %edi,%ecx
 7fa:	73 64                	jae    860 <malloc+0x90>
  if(nu < 4096)
 7fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 801:	39 df                	cmp    %ebx,%edi
 803:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 806:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 80d:	eb 0a                	jmp    819 <malloc+0x49>
 80f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 812:	8b 48 04             	mov    0x4(%eax),%ecx
 815:	39 f9                	cmp    %edi,%ecx
 817:	73 47                	jae    860 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 819:	89 c2                	mov    %eax,%edx
 81b:	3b 05 2c 0d 00 00    	cmp    0xd2c,%eax
 821:	75 ed                	jne    810 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	56                   	push   %esi
 827:	e8 5f fc ff ff       	call   48b <sbrk>
  if(p == (char*)-1)
 82c:	83 c4 10             	add    $0x10,%esp
 82f:	83 f8 ff             	cmp    $0xffffffff,%eax
 832:	74 1c                	je     850 <malloc+0x80>
  hp->s.size = nu;
 834:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 837:	83 ec 0c             	sub    $0xc,%esp
 83a:	83 c0 08             	add    $0x8,%eax
 83d:	50                   	push   %eax
 83e:	e8 fd fe ff ff       	call   740 <free>
  return freep;
 843:	8b 15 2c 0d 00 00    	mov    0xd2c,%edx
      if((p = morecore(nunits)) == 0)
 849:	83 c4 10             	add    $0x10,%esp
 84c:	85 d2                	test   %edx,%edx
 84e:	75 c0                	jne    810 <malloc+0x40>
        return 0;
  }
}
 850:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 853:	31 c0                	xor    %eax,%eax
}
 855:	5b                   	pop    %ebx
 856:	5e                   	pop    %esi
 857:	5f                   	pop    %edi
 858:	5d                   	pop    %ebp
 859:	c3                   	ret
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 860:	39 cf                	cmp    %ecx,%edi
 862:	74 4c                	je     8b0 <malloc+0xe0>
        p->s.size -= nunits;
 864:	29 f9                	sub    %edi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 86f:	89 15 2c 0d 00 00    	mov    %edx,0xd2c
}
 875:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 878:	83 c0 08             	add    $0x8,%eax
}
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 2c 0d 00 00 30 	movl   $0xd30,0xd2c
 887:	0d 00 00 
    base.s.size = 0;
 88a:	b8 30 0d 00 00       	mov    $0xd30,%eax
    base.s.ptr = freep = prevp = &base;
 88f:	c7 05 30 0d 00 00 30 	movl   $0xd30,0xd30
 896:	0d 00 00 
    base.s.size = 0;
 899:	c7 05 34 0d 00 00 00 	movl   $0x0,0xd34
 8a0:	00 00 00 
    if(p->s.size >= nunits){
 8a3:	e9 54 ff ff ff       	jmp    7fc <malloc+0x2c>
 8a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8af:	00 
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0x9f>
