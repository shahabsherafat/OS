
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
  40:	68 e8 08 00 00       	push   $0x8e8
  45:	6a 01                	push   $0x1
  47:	e8 94 05 00 00       	call   5e0 <printf>

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
  bb:	68 40 0a 00 00       	push   $0xa40
  c0:	6a 01                	push   $0x1
  c2:	e8 19 05 00 00       	call   5e0 <printf>
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
  de:	68 0c 09 00 00       	push   $0x90c
  e3:	6a 01                	push   $0x1
  e5:	e8 f6 04 00 00       	call   5e0 <printf>
    sleep(200);
  ea:	83 c4 14             	add    $0x14,%esp
  ed:	68 c8 00 00 00       	push   $0xc8
  f2:	e8 9c 03 00 00       	call   493 <sleep>
    printf(1, "[plock_demo] HOLDER releasing lock | pid=%d pr=%d\n", getpid(), holder_pr);
  f7:	e8 87 03 00 00       	call   483 <getpid>
  fc:	6a 01                	push   $0x1
  fe:	50                   	push   %eax
  ff:	68 40 09 00 00       	push   $0x940
 104:	6a 01                	push   $0x1
 106:	e8 d5 04 00 00       	call   5e0 <printf>
    release_plock_sys();
 10b:	83 c4 20             	add    $0x20,%esp
 10e:	e8 f0 03 00 00       	call   503 <release_plock_sys>
    exit();
 113:	e8 eb 02 00 00       	call   403 <exit>
    printf(1, "[plock_demo] fork failed\n");
 118:	53                   	push   %ebx
 119:	53                   	push   %ebx
 11a:	68 26 0a 00 00       	push   $0xa26
 11f:	6a 01                	push   $0x1
 121:	e8 ba 04 00 00       	call   5e0 <printf>
    exit();
 126:	e8 d8 02 00 00       	call   403 <exit>
      printf(1, "[plock_demo] fork failed at i=%d\n", i);
 12b:	51                   	push   %ecx
 12c:	56                   	push   %esi
 12d:	68 74 09 00 00       	push   $0x974
 132:	6a 01                	push   $0x1
 134:	e8 a7 04 00 00       	call   5e0 <printf>
      continue;
 139:	83 c4 10             	add    $0x10,%esp
 13c:	e9 52 ff ff ff       	jmp    93 <main+0x93>
      printf(1, "[plock_demo] waiter started | pid=%d pr=%d\n", getpid(), pr);
 141:	e8 3d 03 00 00       	call   483 <getpid>
 146:	57                   	push   %edi
 147:	50                   	push   %eax
 148:	68 98 09 00 00       	push   $0x998
 14d:	6a 01                	push   $0x1
 14f:	e8 8c 04 00 00       	call   5e0 <printf>
      acquire_plock_sys(pr);
 154:	89 3c 24             	mov    %edi,(%esp)
 157:	e8 9f 03 00 00       	call   4fb <acquire_plock_sys>
      printf(1, "[plock_demo] >>> waiter ACQUIRED | pid=%d pr=%d\n", getpid(), pr);
 15c:	e8 22 03 00 00       	call   483 <getpid>
 161:	57                   	push   %edi
 162:	50                   	push   %eax
 163:	68 c4 09 00 00       	push   $0x9c4
 168:	6a 01                	push   $0x1
 16a:	e8 71 04 00 00       	call   5e0 <printf>
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
 191:	68 f8 09 00 00       	push   $0x9f8
 196:	6a 01                	push   $0x1
 198:	e8 43 04 00 00       	call   5e0 <printf>
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

0000050b <getlockstat>:

SYSCALL(getlockstat)
 50b:	b8 23 00 00 00       	mov    $0x23,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <vread>:

SYSCALL(vread)
 513:	b8 24 00 00 00       	mov    $0x24,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <vwrite>:
SYSCALL(vwrite)
 51b:	b8 25 00 00 00       	mov    $0x25,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 523:	b8 26 00 00 00       	mov    $0x26,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <cptresetstats>:
SYSCALL(cptresetstats)
 52b:	b8 27 00 00 00       	mov    $0x27,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <cptgetstats>:
SYSCALL(cptgetstats)
 533:	b8 28 00 00 00       	mov    $0x28,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret
 53b:	66 90                	xchg   %ax,%ax
 53d:	66 90                	xchg   %ax,%ax
 53f:	90                   	nop

00000540 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 548:	89 d1                	mov    %edx,%ecx
{
 54a:	83 ec 3c             	sub    $0x3c,%esp
 54d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 550:	85 d2                	test   %edx,%edx
 552:	0f 89 80 00 00 00    	jns    5d8 <printint+0x98>
 558:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 55c:	74 7a                	je     5d8 <printint+0x98>
    x = -xx;
 55e:	f7 d9                	neg    %ecx
    neg = 1;
 560:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 565:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 568:	31 f6                	xor    %esi,%esi
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 570:	89 c8                	mov    %ecx,%eax
 572:	31 d2                	xor    %edx,%edx
 574:	89 f7                	mov    %esi,%edi
 576:	f7 f3                	div    %ebx
 578:	8d 76 01             	lea    0x1(%esi),%esi
 57b:	0f b6 92 b4 0a 00 00 	movzbl 0xab4(%edx),%edx
 582:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 586:	89 ca                	mov    %ecx,%edx
 588:	89 c1                	mov    %eax,%ecx
 58a:	39 da                	cmp    %ebx,%edx
 58c:	73 e2                	jae    570 <printint+0x30>
  if(neg)
 58e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 591:	85 c0                	test   %eax,%eax
 593:	74 07                	je     59c <printint+0x5c>
    buf[i++] = '-';
 595:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 59a:	89 f7                	mov    %esi,%edi
 59c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 59f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5a2:	01 df                	add    %ebx,%edi
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 5a8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 5ab:	83 ec 04             	sub    $0x4,%esp
 5ae:	88 45 d7             	mov    %al,-0x29(%ebp)
 5b1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 5b4:	6a 01                	push   $0x1
 5b6:	50                   	push   %eax
 5b7:	56                   	push   %esi
 5b8:	e8 66 fe ff ff       	call   423 <write>
  while(--i >= 0)
 5bd:	89 f8                	mov    %edi,%eax
 5bf:	83 c4 10             	add    $0x10,%esp
 5c2:	83 ef 01             	sub    $0x1,%edi
 5c5:	39 c3                	cmp    %eax,%ebx
 5c7:	75 df                	jne    5a8 <printint+0x68>
}
 5c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cc:	5b                   	pop    %ebx
 5cd:	5e                   	pop    %esi
 5ce:	5f                   	pop    %edi
 5cf:	5d                   	pop    %ebp
 5d0:	c3                   	ret
 5d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5d8:	31 c0                	xor    %eax,%eax
 5da:	eb 89                	jmp    565 <printint+0x25>
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	56                   	push   %esi
 5e5:	53                   	push   %ebx
 5e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 5ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 5ef:	0f b6 1e             	movzbl (%esi),%ebx
 5f2:	83 c6 01             	add    $0x1,%esi
 5f5:	84 db                	test   %bl,%bl
 5f7:	74 67                	je     660 <printf+0x80>
 5f9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5fc:	31 d2                	xor    %edx,%edx
 5fe:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 601:	eb 34                	jmp    637 <printf+0x57>
 603:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 608:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 60b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 610:	83 f8 25             	cmp    $0x25,%eax
 613:	74 18                	je     62d <printf+0x4d>
  write(fd, &c, 1);
 615:	83 ec 04             	sub    $0x4,%esp
 618:	8d 45 e7             	lea    -0x19(%ebp),%eax
 61b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 61e:	6a 01                	push   $0x1
 620:	50                   	push   %eax
 621:	57                   	push   %edi
 622:	e8 fc fd ff ff       	call   423 <write>
 627:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 62a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 62d:	0f b6 1e             	movzbl (%esi),%ebx
 630:	83 c6 01             	add    $0x1,%esi
 633:	84 db                	test   %bl,%bl
 635:	74 29                	je     660 <printf+0x80>
    c = fmt[i] & 0xff;
 637:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 63a:	85 d2                	test   %edx,%edx
 63c:	74 ca                	je     608 <printf+0x28>
      }
    } else if(state == '%'){
 63e:	83 fa 25             	cmp    $0x25,%edx
 641:	75 ea                	jne    62d <printf+0x4d>
      if(c == 'd'){
 643:	83 f8 25             	cmp    $0x25,%eax
 646:	0f 84 04 01 00 00    	je     750 <printf+0x170>
 64c:	83 e8 63             	sub    $0x63,%eax
 64f:	83 f8 15             	cmp    $0x15,%eax
 652:	77 1c                	ja     670 <printf+0x90>
 654:	ff 24 85 5c 0a 00 00 	jmp    *0xa5c(,%eax,4)
 65b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 660:	8d 65 f4             	lea    -0xc(%ebp),%esp
 663:	5b                   	pop    %ebx
 664:	5e                   	pop    %esi
 665:	5f                   	pop    %edi
 666:	5d                   	pop    %ebp
 667:	c3                   	ret
 668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 66f:	00 
  write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
 673:	8d 55 e7             	lea    -0x19(%ebp),%edx
 676:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 67a:	6a 01                	push   $0x1
 67c:	52                   	push   %edx
 67d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 680:	57                   	push   %edi
 681:	e8 9d fd ff ff       	call   423 <write>
 686:	83 c4 0c             	add    $0xc,%esp
 689:	88 5d e7             	mov    %bl,-0x19(%ebp)
 68c:	6a 01                	push   $0x1
 68e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 691:	52                   	push   %edx
 692:	57                   	push   %edi
 693:	e8 8b fd ff ff       	call   423 <write>
        putc(fd, c);
 698:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69b:	31 d2                	xor    %edx,%edx
 69d:	eb 8e                	jmp    62d <printf+0x4d>
 69f:	90                   	nop
        printint(fd, *ap, 16, 0);
 6a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6a3:	83 ec 0c             	sub    $0xc,%esp
 6a6:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ab:	8b 13                	mov    (%ebx),%edx
 6ad:	6a 00                	push   $0x0
 6af:	89 f8                	mov    %edi,%eax
        ap++;
 6b1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 6b4:	e8 87 fe ff ff       	call   540 <printint>
        ap++;
 6b9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6bc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bf:	31 d2                	xor    %edx,%edx
 6c1:	e9 67 ff ff ff       	jmp    62d <printf+0x4d>
        s = (char*)*ap;
 6c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6c9:	8b 18                	mov    (%eax),%ebx
        ap++;
 6cb:	83 c0 04             	add    $0x4,%eax
 6ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6d1:	85 db                	test   %ebx,%ebx
 6d3:	0f 84 87 00 00 00    	je     760 <printf+0x180>
        while(*s != 0){
 6d9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6dc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6de:	84 c0                	test   %al,%al
 6e0:	0f 84 47 ff ff ff    	je     62d <printf+0x4d>
 6e6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6e9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ec:	89 de                	mov    %ebx,%esi
 6ee:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6f6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6f9:	6a 01                	push   $0x1
 6fb:	53                   	push   %ebx
 6fc:	57                   	push   %edi
 6fd:	e8 21 fd ff ff       	call   423 <write>
        while(*s != 0){
 702:	0f b6 06             	movzbl (%esi),%eax
 705:	83 c4 10             	add    $0x10,%esp
 708:	84 c0                	test   %al,%al
 70a:	75 e4                	jne    6f0 <printf+0x110>
      state = 0;
 70c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 70f:	31 d2                	xor    %edx,%edx
 711:	e9 17 ff ff ff       	jmp    62d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 716:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 719:	83 ec 0c             	sub    $0xc,%esp
 71c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 721:	8b 13                	mov    (%ebx),%edx
 723:	6a 01                	push   $0x1
 725:	eb 88                	jmp    6af <printf+0xcf>
        putc(fd, *ap);
 727:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 72a:	83 ec 04             	sub    $0x4,%esp
 72d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 730:	8b 03                	mov    (%ebx),%eax
        ap++;
 732:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 735:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 738:	6a 01                	push   $0x1
 73a:	52                   	push   %edx
 73b:	57                   	push   %edi
 73c:	e8 e2 fc ff ff       	call   423 <write>
        ap++;
 741:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 744:	83 c4 10             	add    $0x10,%esp
      state = 0;
 747:	31 d2                	xor    %edx,%edx
 749:	e9 df fe ff ff       	jmp    62d <printf+0x4d>
 74e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e7             	mov    %bl,-0x19(%ebp)
 756:	8d 55 e7             	lea    -0x19(%ebp),%edx
 759:	6a 01                	push   $0x1
 75b:	e9 31 ff ff ff       	jmp    691 <printf+0xb1>
 760:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 765:	bb 55 0a 00 00       	mov    $0xa55,%ebx
 76a:	e9 77 ff ff ff       	jmp    6e6 <printf+0x106>
 76f:	90                   	nop

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 5c 0d 00 00       	mov    0xd5c,%eax
{
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 77e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	39 c8                	cmp    %ecx,%eax
 78c:	73 32                	jae    7c0 <free+0x50>
 78e:	39 d1                	cmp    %edx,%ecx
 790:	72 04                	jb     796 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	39 d0                	cmp    %edx,%eax
 794:	72 32                	jb     7c8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 796:	8b 73 fc             	mov    -0x4(%ebx),%esi
 799:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 79c:	39 fa                	cmp    %edi,%edx
 79e:	74 30                	je     7d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a3:	8b 50 04             	mov    0x4(%eax),%edx
 7a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a9:	39 f1                	cmp    %esi,%ecx
 7ab:	74 3a                	je     7e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ad:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7af:	5b                   	pop    %ebx
  freep = p;
 7b0:	a3 5c 0d 00 00       	mov    %eax,0xd5c
}
 7b5:	5e                   	pop    %esi
 7b6:	5f                   	pop    %edi
 7b7:	5d                   	pop    %ebp
 7b8:	c3                   	ret
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	39 d0                	cmp    %edx,%eax
 7c2:	72 04                	jb     7c8 <free+0x58>
 7c4:	39 d1                	cmp    %edx,%ecx
 7c6:	72 ce                	jb     796 <free+0x26>
{
 7c8:	89 d0                	mov    %edx,%eax
 7ca:	eb bc                	jmp    788 <free+0x18>
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7d0:	03 72 04             	add    0x4(%edx),%esi
 7d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 12                	mov    (%edx),%edx
 7da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e3:	39 f1                	cmp    %esi,%ecx
 7e5:	75 c6                	jne    7ad <free+0x3d>
    p->s.size += bp->s.size;
 7e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ea:	a3 5c 0d 00 00       	mov    %eax,0xd5c
    p->s.size += bp->s.size;
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7f5:	89 08                	mov    %ecx,(%eax)
}
 7f7:	5b                   	pop    %ebx
 7f8:	5e                   	pop    %esi
 7f9:	5f                   	pop    %edi
 7fa:	5d                   	pop    %ebp
 7fb:	c3                   	ret
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 80c:	8b 15 5c 0d 00 00    	mov    0xd5c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8d 78 07             	lea    0x7(%eax),%edi
 815:	c1 ef 03             	shr    $0x3,%edi
 818:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 81b:	85 d2                	test   %edx,%edx
 81d:	0f 84 8d 00 00 00    	je     8b0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 825:	8b 48 04             	mov    0x4(%eax),%ecx
 828:	39 f9                	cmp    %edi,%ecx
 82a:	73 64                	jae    890 <malloc+0x90>
  if(nu < 4096)
 82c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 831:	39 df                	cmp    %ebx,%edi
 833:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 836:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 83d:	eb 0a                	jmp    849 <malloc+0x49>
 83f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 842:	8b 48 04             	mov    0x4(%eax),%ecx
 845:	39 f9                	cmp    %edi,%ecx
 847:	73 47                	jae    890 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 849:	89 c2                	mov    %eax,%edx
 84b:	3b 05 5c 0d 00 00    	cmp    0xd5c,%eax
 851:	75 ed                	jne    840 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 853:	83 ec 0c             	sub    $0xc,%esp
 856:	56                   	push   %esi
 857:	e8 2f fc ff ff       	call   48b <sbrk>
  if(p == (char*)-1)
 85c:	83 c4 10             	add    $0x10,%esp
 85f:	83 f8 ff             	cmp    $0xffffffff,%eax
 862:	74 1c                	je     880 <malloc+0x80>
  hp->s.size = nu;
 864:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 867:	83 ec 0c             	sub    $0xc,%esp
 86a:	83 c0 08             	add    $0x8,%eax
 86d:	50                   	push   %eax
 86e:	e8 fd fe ff ff       	call   770 <free>
  return freep;
 873:	8b 15 5c 0d 00 00    	mov    0xd5c,%edx
      if((p = morecore(nunits)) == 0)
 879:	83 c4 10             	add    $0x10,%esp
 87c:	85 d2                	test   %edx,%edx
 87e:	75 c0                	jne    840 <malloc+0x40>
        return 0;
  }
}
 880:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 883:	31 c0                	xor    %eax,%eax
}
 885:	5b                   	pop    %ebx
 886:	5e                   	pop    %esi
 887:	5f                   	pop    %edi
 888:	5d                   	pop    %ebp
 889:	c3                   	ret
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 890:	39 cf                	cmp    %ecx,%edi
 892:	74 4c                	je     8e0 <malloc+0xe0>
        p->s.size -= nunits;
 894:	29 f9                	sub    %edi,%ecx
 896:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 899:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 89c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 89f:	89 15 5c 0d 00 00    	mov    %edx,0xd5c
}
 8a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8a8:	83 c0 08             	add    $0x8,%eax
}
 8ab:	5b                   	pop    %ebx
 8ac:	5e                   	pop    %esi
 8ad:	5f                   	pop    %edi
 8ae:	5d                   	pop    %ebp
 8af:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 8b0:	c7 05 5c 0d 00 00 60 	movl   $0xd60,0xd5c
 8b7:	0d 00 00 
    base.s.size = 0;
 8ba:	b8 60 0d 00 00       	mov    $0xd60,%eax
    base.s.ptr = freep = prevp = &base;
 8bf:	c7 05 60 0d 00 00 60 	movl   $0xd60,0xd60
 8c6:	0d 00 00 
    base.s.size = 0;
 8c9:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
 8d0:	00 00 00 
    if(p->s.size >= nunits){
 8d3:	e9 54 ff ff ff       	jmp    82c <malloc+0x2c>
 8d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8df:	00 
        prevp->s.ptr = p->s.ptr;
 8e0:	8b 08                	mov    (%eax),%ecx
 8e2:	89 0a                	mov    %ecx,(%edx)
 8e4:	eb b9                	jmp    89f <malloc+0x9f>
