
_family_process_demo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
static void wait_token(int rfd)  { char x; read(rfd, &x, 1); }
static void send_token(int wfd)  { char x = 'X'; write(wfd, &x, 1); }

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
  11:	83 ec 38             	sub    $0x38,%esp
  int me = getpid();
  14:	e8 5a 04 00 00       	call   473 <getpid>
  printf(1, "\n[famdemo] parent PID = %d\n", me);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	50                   	push   %eax
  int me = getpid();
  1d:	89 c3                	mov    %eax,%ebx
  printf(1, "\n[famdemo] parent PID = %d\n", me);
  1f:	68 a8 08 00 00       	push   $0x8a8
  24:	6a 01                	push   $0x1
  26:	e8 75 05 00 00       	call   5a0 <printf>

  int p1[2], p2[2];
  pipe(p1);
  2b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 cd 03 00 00       	call   403 <pipe>
  pipe(p2);
  36:	8d 45 e0             	lea    -0x20(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 c2 03 00 00       	call   403 <pipe>

  int c1 = fork();
  41:	e8 a5 03 00 00       	call   3eb <fork>
  if (c1 == 0) {
  46:	83 c4 10             	add    $0x10,%esp
  49:	85 c0                	test   %eax,%eax
  4b:	0f 84 be 00 00 00    	je     10f <main+0x10f>
    wait();
    wait();
    exit();
  }

  if (c1 > 0) {
  51:	0f 8e a4 00 00 00    	jle    fb <main+0xfb>
  57:	89 c6                	mov    %eax,%esi
    int c2 = fork();
  59:	e8 8d 03 00 00       	call   3eb <fork>
  5e:	89 c7                	mov    %eax,%edi
    if (c2 == 0) { sleep(80); exit(); }
  60:	85 c0                	test   %eax,%eax
  62:	0f 84 98 00 00 00    	je     100 <main+0x100>
    int c3 = fork();
  68:	e8 7e 03 00 00       	call   3eb <fork>
    if (c3 == 0) { sleep(80); exit(); }
  6d:	85 c0                	test   %eax,%eax
  6f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  72:	0f 84 88 00 00 00    	je     100 <main+0x100>

    close(p1[0]);
  78:	83 ec 0c             	sub    $0xc,%esp
  7b:	ff 75 d8             	push   -0x28(%ebp)
  7e:	e8 98 03 00 00       	call   41b <close>
    close(p2[1]);
  83:	58                   	pop    %eax
  84:	ff 75 e4             	push   -0x1c(%ebp)
  87:	e8 8f 03 00 00       	call   41b <close>

    sleep(10);
  8c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  93:	e8 eb 03 00 00       	call   483 <sleep>

    printf(1, "\n[famdemo] parent (PID %d), children: c1=%d c2=%d c3=%d\n",me, c1, c2, c3);
  98:	5a                   	pop    %edx
  99:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  9c:	59                   	pop    %ecx
  9d:	52                   	push   %edx
  9e:	57                   	push   %edi
  9f:	56                   	push   %esi
  a0:	53                   	push   %ebx
  a1:	68 fc 08 00 00       	push   $0x8fc
  a6:	6a 01                	push   $0x1
  a8:	e8 f3 04 00 00       	call   5a0 <printf>

    show_process_family(me);
  ad:	83 c4 14             	add    $0x14,%esp
  b0:	53                   	push   %ebx
static void send_token(int wfd)  { char x = 'X'; write(wfd, &x, 1); }
  b1:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    show_process_family(me);
  b4:	e8 e2 03 00 00       	call   49b <show_process_family>
static void send_token(int wfd)  { char x = 'X'; write(wfd, &x, 1); }
  b9:	83 c4 0c             	add    $0xc,%esp
  bc:	c6 45 d7 58          	movb   $0x58,-0x29(%ebp)
  c0:	6a 01                	push   $0x1
  c2:	53                   	push   %ebx
  c3:	ff 75 dc             	push   -0x24(%ebp)
  c6:	e8 48 03 00 00       	call   413 <write>
static void wait_token(int rfd)  { char x; read(rfd, &x, 1); }
  cb:	83 c4 0c             	add    $0xc,%esp
  ce:	6a 01                	push   $0x1
  d0:	53                   	push   %ebx
  d1:	ff 75 e0             	push   -0x20(%ebp)
  d4:	e8 32 03 00 00       	call   40b <read>

    send_token(p1[1]);

    wait_token(p2[0]);

    wait();
  d9:	e8 1d 03 00 00       	call   3fb <wait>
    wait();
  de:	e8 18 03 00 00       	call   3fb <wait>
    wait();
  e3:	e8 13 03 00 00       	call   3fb <wait>
    printf(1, "\n[famdemo] done.\n");
  e8:	5b                   	pop    %ebx
  e9:	5e                   	pop    %esi
  ea:	68 e1 08 00 00       	push   $0x8e1
  ef:	6a 01                	push   $0x1
  f1:	e8 aa 04 00 00       	call   5a0 <printf>
    exit();
  f6:	e8 f8 02 00 00       	call   3f3 <exit>
  }
  exit();
  fb:	e8 f3 02 00 00       	call   3f3 <exit>
    if (c2 == 0) { sleep(80); exit(); }
 100:	83 ec 0c             	sub    $0xc,%esp
 103:	6a 50                	push   $0x50
 105:	e8 79 03 00 00       	call   483 <sleep>
 10a:	e8 e4 02 00 00       	call   3f3 <exit>
    close(p1[1]);
 10f:	83 ec 0c             	sub    $0xc,%esp
 112:	ff 75 dc             	push   -0x24(%ebp)
 115:	e8 01 03 00 00       	call   41b <close>
    close(p2[0]);
 11a:	58                   	pop    %eax
 11b:	ff 75 e0             	push   -0x20(%ebp)
 11e:	e8 f8 02 00 00       	call   41b <close>
    int gc1 = fork();
 123:	e8 c3 02 00 00       	call   3eb <fork>
    if (gc1 == 0) { sleep(50); exit(); }
 128:	83 c4 10             	add    $0x10,%esp
 12b:	85 c0                	test   %eax,%eax
 12d:	74 5b                	je     18a <main+0x18a>
    int gc2 = fork();
 12f:	e8 b7 02 00 00       	call   3eb <fork>
    if (gc2 == 0) { sleep(50); exit(); }
 134:	85 c0                	test   %eax,%eax
 136:	74 52                	je     18a <main+0x18a>
static void wait_token(int rfd)  { char x; read(rfd, &x, 1); }
 138:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 13b:	57                   	push   %edi
 13c:	6a 01                	push   $0x1
 13e:	53                   	push   %ebx
 13f:	ff 75 d8             	push   -0x28(%ebp)
 142:	e8 c4 02 00 00       	call   40b <read>
    printf(1, "\n[famdemo] child1 (PID %d):\n", getpid());
 147:	e8 27 03 00 00       	call   473 <getpid>
 14c:	83 c4 0c             	add    $0xc,%esp
 14f:	50                   	push   %eax
 150:	68 c4 08 00 00       	push   $0x8c4
 155:	6a 01                	push   $0x1
 157:	e8 44 04 00 00       	call   5a0 <printf>
    show_process_family(getpid());   
 15c:	e8 12 03 00 00       	call   473 <getpid>
 161:	89 04 24             	mov    %eax,(%esp)
 164:	e8 32 03 00 00       	call   49b <show_process_family>
static void send_token(int wfd)  { char x = 'X'; write(wfd, &x, 1); }
 169:	83 c4 0c             	add    $0xc,%esp
 16c:	c6 45 d7 58          	movb   $0x58,-0x29(%ebp)
 170:	6a 01                	push   $0x1
 172:	53                   	push   %ebx
 173:	ff 75 e4             	push   -0x1c(%ebp)
 176:	e8 98 02 00 00       	call   413 <write>
    wait();
 17b:	e8 7b 02 00 00       	call   3fb <wait>
    wait();
 180:	e8 76 02 00 00       	call   3fb <wait>
    exit();
 185:	e8 69 02 00 00       	call   3f3 <exit>
    if (gc1 == 0) { sleep(50); exit(); }
 18a:	83 ec 0c             	sub    $0xc,%esp
 18d:	6a 32                	push   $0x32
 18f:	e8 ef 02 00 00       	call   483 <sleep>
 194:	e8 5a 02 00 00       	call   3f3 <exit>
 199:	66 90                	xchg   %ax,%ax
 19b:	66 90                	xchg   %ax,%ax
 19d:	66 90                	xchg   %ax,%ax
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a1:	31 c0                	xor    %eax,%eax
{
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	53                   	push   %ebx
 1a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1b7:	83 c0 01             	add    $0x1,%eax
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1c1:	89 c8                	mov    %ecx,%eax
 1c3:	c9                   	leave
 1c4:	c3                   	ret
 1c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1cc:	00 
 1cd:	8d 76 00             	lea    0x0(%esi),%esi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	75 17                	jne    1f8 <strcmp+0x28>
 1e1:	eb 3a                	jmp    21d <strcmp+0x4d>
 1e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1ec:	83 c2 01             	add    $0x1,%edx
 1ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1f2:	84 c0                	test   %al,%al
 1f4:	74 1a                	je     210 <strcmp+0x40>
 1f6:	89 d9                	mov    %ebx,%ecx
 1f8:	0f b6 19             	movzbl (%ecx),%ebx
 1fb:	38 c3                	cmp    %al,%bl
 1fd:	74 e9                	je     1e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1ff:	29 d8                	sub    %ebx,%eax
}
 201:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 204:	c9                   	leave
 205:	c3                   	ret
 206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20d:	00 
 20e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 210:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 214:	31 c0                	xor    %eax,%eax
 216:	29 d8                	sub    %ebx,%eax
}
 218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 21b:	c9                   	leave
 21c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 21d:	0f b6 19             	movzbl (%ecx),%ebx
 220:	31 c0                	xor    %eax,%eax
 222:	eb db                	jmp    1ff <strcmp+0x2f>
 224:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22b:	00 
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 3a 00             	cmpb   $0x0,(%edx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 c0                	xor    %eax,%eax
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c0 01             	add    $0x1,%eax
 243:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 247:	89 c1                	mov    %eax,%ecx
 249:	75 f5                	jne    240 <strlen+0x10>
    ;
  return n;
}
 24b:	89 c8                	mov    %ecx,%eax
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret
 24f:	90                   	nop
  for(n = 0; s[n]; n++)
 250:	31 c9                	xor    %ecx,%ecx
}
 252:	5d                   	pop    %ebp
 253:	89 c8                	mov    %ecx,%eax
 255:	c3                   	ret
 256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25d:	00 
 25e:	66 90                	xchg   %ax,%ax

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld
 270:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 272:	8b 7d fc             	mov    -0x4(%ebp),%edi
 275:	89 d0                	mov    %edx,%eax
 277:	c9                   	leave
 278:	c3                   	ret
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 28a:	0f b6 10             	movzbl (%eax),%edx
 28d:	84 d2                	test   %dl,%dl
 28f:	75 12                	jne    2a3 <strchr+0x23>
 291:	eb 1d                	jmp    2b0 <strchr+0x30>
 293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 298:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 29c:	83 c0 01             	add    $0x1,%eax
 29f:	84 d2                	test   %dl,%dl
 2a1:	74 0d                	je     2b0 <strchr+0x30>
    if(*s == c)
 2a3:	38 d1                	cmp    %dl,%cl
 2a5:	75 f1                	jne    298 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2b0:	31 c0                	xor    %eax,%eax
}
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret
 2b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bb:	00 
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2c9:	31 db                	xor    %ebx,%ebx
 2cb:	8d 73 01             	lea    0x1(%ebx),%esi
{
 2ce:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2d1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2d4:	7d 3b                	jge    311 <gets+0x51>
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 2e0:	83 ec 04             	sub    $0x4,%esp
 2e3:	6a 01                	push   $0x1
 2e5:	57                   	push   %edi
 2e6:	6a 00                	push   $0x0
 2e8:	e8 1e 01 00 00       	call   40b <read>
    if(cc < 1)
 2ed:	83 c4 10             	add    $0x10,%esp
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7e 1d                	jle    311 <gets+0x51>
      break;
      
    buf[i++] = c;
 2f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2f8:	8b 55 08             	mov    0x8(%ebp),%edx
 2fb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 2ff:	3c 0a                	cmp    $0xa,%al
 301:	7f 25                	jg     328 <gets+0x68>
 303:	3c 08                	cmp    $0x8,%al
 305:	7f 0c                	jg     313 <gets+0x53>
{
 307:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 309:	8d 73 01             	lea    0x1(%ebx),%esi
 30c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 30f:	7c cf                	jl     2e0 <gets+0x20>
 311:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 31a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31d:	5b                   	pop    %ebx
 31e:	5e                   	pop    %esi
 31f:	5f                   	pop    %edi
 320:	5d                   	pop    %ebp
 321:	c3                   	ret
 322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 328:	3c 0d                	cmp    $0xd,%al
 32a:	74 e7                	je     313 <gets+0x53>
{
 32c:	89 f3                	mov    %esi,%ebx
 32e:	eb d9                	jmp    309 <gets+0x49>

00000330 <stat>:

int
stat(const char *n, struct stat *st)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 335:	83 ec 08             	sub    $0x8,%esp
 338:	6a 00                	push   $0x0
 33a:	ff 75 08             	push   0x8(%ebp)
 33d:	e8 f1 00 00 00       	call   433 <open>
  if(fd < 0)
 342:	83 c4 10             	add    $0x10,%esp
 345:	85 c0                	test   %eax,%eax
 347:	78 27                	js     370 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	ff 75 0c             	push   0xc(%ebp)
 34f:	89 c3                	mov    %eax,%ebx
 351:	50                   	push   %eax
 352:	e8 f4 00 00 00       	call   44b <fstat>
  close(fd);
 357:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 35a:	89 c6                	mov    %eax,%esi
  close(fd);
 35c:	e8 ba 00 00 00       	call   41b <close>
  return r;
 361:	83 c4 10             	add    $0x10,%esp
}
 364:	8d 65 f8             	lea    -0x8(%ebp),%esp
 367:	89 f0                	mov    %esi,%eax
 369:	5b                   	pop    %ebx
 36a:	5e                   	pop    %esi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 370:	be ff ff ff ff       	mov    $0xffffffff,%esi
 375:	eb ed                	jmp    364 <stat+0x34>
 377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37e:	00 
 37f:	90                   	nop

00000380 <atoi>:

int
atoi(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 387:	0f be 02             	movsbl (%edx),%eax
 38a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 38d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 390:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 395:	77 1e                	ja     3b5 <atoi+0x35>
 397:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 39e:	00 
 39f:	90                   	nop
    n = n*10 + *s++ - '0';
 3a0:	83 c2 01             	add    $0x1,%edx
 3a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3aa:	0f be 02             	movsbl (%edx),%eax
 3ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3b0:	80 fb 09             	cmp    $0x9,%bl
 3b3:	76 eb                	jbe    3a0 <atoi+0x20>
  return n;
}
 3b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3b8:	89 c8                	mov    %ecx,%eax
 3ba:	c9                   	leave
 3bb:	c3                   	ret
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	8b 45 10             	mov    0x10(%ebp),%eax
 3c7:	8b 55 08             	mov    0x8(%ebp),%edx
 3ca:	56                   	push   %esi
 3cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ce:	85 c0                	test   %eax,%eax
 3d0:	7e 13                	jle    3e5 <memmove+0x25>
 3d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3d4:	89 d7                	mov    %edx,%edi
 3d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3dd:	00 
 3de:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3e1:	39 f8                	cmp    %edi,%eax
 3e3:	75 fb                	jne    3e0 <memmove+0x20>
  return vdst;
}
 3e5:	5e                   	pop    %esi
 3e6:	89 d0                	mov    %edx,%eax
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret

000003eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3eb:	b8 01 00 00 00       	mov    $0x1,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <exit>:
SYSCALL(exit)
 3f3:	b8 02 00 00 00       	mov    $0x2,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <wait>:
SYSCALL(wait)
 3fb:	b8 03 00 00 00       	mov    $0x3,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <pipe>:
SYSCALL(pipe)
 403:	b8 04 00 00 00       	mov    $0x4,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <read>:
SYSCALL(read)
 40b:	b8 05 00 00 00       	mov    $0x5,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <write>:
SYSCALL(write)
 413:	b8 10 00 00 00       	mov    $0x10,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <close>:
SYSCALL(close)
 41b:	b8 15 00 00 00       	mov    $0x15,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <kill>:
SYSCALL(kill)
 423:	b8 06 00 00 00       	mov    $0x6,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <exec>:
SYSCALL(exec)
 42b:	b8 07 00 00 00       	mov    $0x7,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <open>:
SYSCALL(open)
 433:	b8 0f 00 00 00       	mov    $0xf,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <mknod>:
SYSCALL(mknod)
 43b:	b8 11 00 00 00       	mov    $0x11,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <unlink>:
SYSCALL(unlink)
 443:	b8 12 00 00 00       	mov    $0x12,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <fstat>:
SYSCALL(fstat)
 44b:	b8 08 00 00 00       	mov    $0x8,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <link>:
SYSCALL(link)
 453:	b8 13 00 00 00       	mov    $0x13,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <mkdir>:
SYSCALL(mkdir)
 45b:	b8 14 00 00 00       	mov    $0x14,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <chdir>:
SYSCALL(chdir)
 463:	b8 09 00 00 00       	mov    $0x9,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <dup>:
SYSCALL(dup)
 46b:	b8 0a 00 00 00       	mov    $0xa,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <getpid>:
SYSCALL(getpid)
 473:	b8 0b 00 00 00       	mov    $0xb,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <sbrk>:
SYSCALL(sbrk)
 47b:	b8 0c 00 00 00       	mov    $0xc,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <sleep>:
SYSCALL(sleep)
 483:	b8 0d 00 00 00       	mov    $0xd,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <uptime>:
SYSCALL(uptime)
 48b:	b8 0e 00 00 00       	mov    $0xe,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 493:	b8 17 00 00 00       	mov    $0x17,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <show_process_family>:
SYSCALL(show_process_family)
 49b:	b8 18 00 00 00       	mov    $0x18,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 4a3:	b8 16 00 00 00       	mov    $0x16,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <grep_syscall>:
SYSCALL(grep_syscall)
 4ab:	b8 19 00 00 00       	mov    $0x19,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 4b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 4bb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 4c3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 4cb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 4d3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 4db:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 4e3:	b8 20 00 00 00       	mov    $0x20,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 4eb:	b8 21 00 00 00       	mov    $0x21,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 4f3:	b8 22 00 00 00       	mov    $0x22,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 508:	89 d1                	mov    %edx,%ecx
{
 50a:	83 ec 3c             	sub    $0x3c,%esp
 50d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 510:	85 d2                	test   %edx,%edx
 512:	0f 89 80 00 00 00    	jns    598 <printint+0x98>
 518:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 51c:	74 7a                	je     598 <printint+0x98>
    x = -xx;
 51e:	f7 d9                	neg    %ecx
    neg = 1;
 520:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 525:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 528:	31 f6                	xor    %esi,%esi
 52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 530:	89 c8                	mov    %ecx,%eax
 532:	31 d2                	xor    %edx,%edx
 534:	89 f7                	mov    %esi,%edi
 536:	f7 f3                	div    %ebx
 538:	8d 76 01             	lea    0x1(%esi),%esi
 53b:	0f b6 92 90 09 00 00 	movzbl 0x990(%edx),%edx
 542:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 546:	89 ca                	mov    %ecx,%edx
 548:	89 c1                	mov    %eax,%ecx
 54a:	39 da                	cmp    %ebx,%edx
 54c:	73 e2                	jae    530 <printint+0x30>
  if(neg)
 54e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 551:	85 c0                	test   %eax,%eax
 553:	74 07                	je     55c <printint+0x5c>
    buf[i++] = '-';
 555:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 55a:	89 f7                	mov    %esi,%edi
 55c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 55f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 562:	01 df                	add    %ebx,%edi
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 568:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 56b:	83 ec 04             	sub    $0x4,%esp
 56e:	88 45 d7             	mov    %al,-0x29(%ebp)
 571:	8d 45 d7             	lea    -0x29(%ebp),%eax
 574:	6a 01                	push   $0x1
 576:	50                   	push   %eax
 577:	56                   	push   %esi
 578:	e8 96 fe ff ff       	call   413 <write>
  while(--i >= 0)
 57d:	89 f8                	mov    %edi,%eax
 57f:	83 c4 10             	add    $0x10,%esp
 582:	83 ef 01             	sub    $0x1,%edi
 585:	39 c3                	cmp    %eax,%ebx
 587:	75 df                	jne    568 <printint+0x68>
}
 589:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58c:	5b                   	pop    %ebx
 58d:	5e                   	pop    %esi
 58e:	5f                   	pop    %edi
 58f:	5d                   	pop    %ebp
 590:	c3                   	ret
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 598:	31 c0                	xor    %eax,%eax
 59a:	eb 89                	jmp    525 <printint+0x25>
 59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 5ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 5af:	0f b6 1e             	movzbl (%esi),%ebx
 5b2:	83 c6 01             	add    $0x1,%esi
 5b5:	84 db                	test   %bl,%bl
 5b7:	74 67                	je     620 <printf+0x80>
 5b9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5bc:	31 d2                	xor    %edx,%edx
 5be:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5c1:	eb 34                	jmp    5f7 <printf+0x57>
 5c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5cb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5d0:	83 f8 25             	cmp    $0x25,%eax
 5d3:	74 18                	je     5ed <printf+0x4d>
  write(fd, &c, 1);
 5d5:	83 ec 04             	sub    $0x4,%esp
 5d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5db:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5de:	6a 01                	push   $0x1
 5e0:	50                   	push   %eax
 5e1:	57                   	push   %edi
 5e2:	e8 2c fe ff ff       	call   413 <write>
 5e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5ed:	0f b6 1e             	movzbl (%esi),%ebx
 5f0:	83 c6 01             	add    $0x1,%esi
 5f3:	84 db                	test   %bl,%bl
 5f5:	74 29                	je     620 <printf+0x80>
    c = fmt[i] & 0xff;
 5f7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5fa:	85 d2                	test   %edx,%edx
 5fc:	74 ca                	je     5c8 <printf+0x28>
      }
    } else if(state == '%'){
 5fe:	83 fa 25             	cmp    $0x25,%edx
 601:	75 ea                	jne    5ed <printf+0x4d>
      if(c == 'd'){
 603:	83 f8 25             	cmp    $0x25,%eax
 606:	0f 84 04 01 00 00    	je     710 <printf+0x170>
 60c:	83 e8 63             	sub    $0x63,%eax
 60f:	83 f8 15             	cmp    $0x15,%eax
 612:	77 1c                	ja     630 <printf+0x90>
 614:	ff 24 85 38 09 00 00 	jmp    *0x938(,%eax,4)
 61b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 620:	8d 65 f4             	lea    -0xc(%ebp),%esp
 623:	5b                   	pop    %ebx
 624:	5e                   	pop    %esi
 625:	5f                   	pop    %edi
 626:	5d                   	pop    %ebp
 627:	c3                   	ret
 628:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 62f:	00 
  write(fd, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
 633:	8d 55 e7             	lea    -0x19(%ebp),%edx
 636:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 63a:	6a 01                	push   $0x1
 63c:	52                   	push   %edx
 63d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 640:	57                   	push   %edi
 641:	e8 cd fd ff ff       	call   413 <write>
 646:	83 c4 0c             	add    $0xc,%esp
 649:	88 5d e7             	mov    %bl,-0x19(%ebp)
 64c:	6a 01                	push   $0x1
 64e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 651:	52                   	push   %edx
 652:	57                   	push   %edi
 653:	e8 bb fd ff ff       	call   413 <write>
        putc(fd, c);
 658:	83 c4 10             	add    $0x10,%esp
      state = 0;
 65b:	31 d2                	xor    %edx,%edx
 65d:	eb 8e                	jmp    5ed <printf+0x4d>
 65f:	90                   	nop
        printint(fd, *ap, 16, 0);
 660:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	b9 10 00 00 00       	mov    $0x10,%ecx
 66b:	8b 13                	mov    (%ebx),%edx
 66d:	6a 00                	push   $0x0
 66f:	89 f8                	mov    %edi,%eax
        ap++;
 671:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 674:	e8 87 fe ff ff       	call   500 <printint>
        ap++;
 679:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 67c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67f:	31 d2                	xor    %edx,%edx
 681:	e9 67 ff ff ff       	jmp    5ed <printf+0x4d>
        s = (char*)*ap;
 686:	8b 45 d0             	mov    -0x30(%ebp),%eax
 689:	8b 18                	mov    (%eax),%ebx
        ap++;
 68b:	83 c0 04             	add    $0x4,%eax
 68e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 691:	85 db                	test   %ebx,%ebx
 693:	0f 84 87 00 00 00    	je     720 <printf+0x180>
        while(*s != 0){
 699:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 69c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 69e:	84 c0                	test   %al,%al
 6a0:	0f 84 47 ff ff ff    	je     5ed <printf+0x4d>
 6a6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6a9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6ac:	89 de                	mov    %ebx,%esi
 6ae:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6b6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6b9:	6a 01                	push   $0x1
 6bb:	53                   	push   %ebx
 6bc:	57                   	push   %edi
 6bd:	e8 51 fd ff ff       	call   413 <write>
        while(*s != 0){
 6c2:	0f b6 06             	movzbl (%esi),%eax
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	84 c0                	test   %al,%al
 6ca:	75 e4                	jne    6b0 <printf+0x110>
      state = 0;
 6cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6cf:	31 d2                	xor    %edx,%edx
 6d1:	e9 17 ff ff ff       	jmp    5ed <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6d6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6d9:	83 ec 0c             	sub    $0xc,%esp
 6dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6e1:	8b 13                	mov    (%ebx),%edx
 6e3:	6a 01                	push   $0x1
 6e5:	eb 88                	jmp    66f <printf+0xcf>
        putc(fd, *ap);
 6e7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6ea:	83 ec 04             	sub    $0x4,%esp
 6ed:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6f0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6f2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6f5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f8:	6a 01                	push   $0x1
 6fa:	52                   	push   %edx
 6fb:	57                   	push   %edi
 6fc:	e8 12 fd ff ff       	call   413 <write>
        ap++;
 701:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 704:	83 c4 10             	add    $0x10,%esp
      state = 0;
 707:	31 d2                	xor    %edx,%edx
 709:	e9 df fe ff ff       	jmp    5ed <printf+0x4d>
 70e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	88 5d e7             	mov    %bl,-0x19(%ebp)
 716:	8d 55 e7             	lea    -0x19(%ebp),%edx
 719:	6a 01                	push   $0x1
 71b:	e9 31 ff ff ff       	jmp    651 <printf+0xb1>
 720:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 725:	bb f3 08 00 00       	mov    $0x8f3,%ebx
 72a:	e9 77 ff ff ff       	jmp    6a6 <printf+0x106>
 72f:	90                   	nop

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 38 0c 00 00       	mov    0xc38,%eax
{
 736:	89 e5                	mov    %esp,%ebp
 738:	57                   	push   %edi
 739:	56                   	push   %esi
 73a:	53                   	push   %ebx
 73b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 73e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	39 c8                	cmp    %ecx,%eax
 74c:	73 32                	jae    780 <free+0x50>
 74e:	39 d1                	cmp    %edx,%ecx
 750:	72 04                	jb     756 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	39 d0                	cmp    %edx,%eax
 754:	72 32                	jb     788 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 756:	8b 73 fc             	mov    -0x4(%ebx),%esi
 759:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75c:	39 fa                	cmp    %edi,%edx
 75e:	74 30                	je     790 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 763:	8b 50 04             	mov    0x4(%eax),%edx
 766:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 769:	39 f1                	cmp    %esi,%ecx
 76b:	74 3a                	je     7a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 76d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 76f:	5b                   	pop    %ebx
  freep = p;
 770:	a3 38 0c 00 00       	mov    %eax,0xc38
}
 775:	5e                   	pop    %esi
 776:	5f                   	pop    %edi
 777:	5d                   	pop    %ebp
 778:	c3                   	ret
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	39 d0                	cmp    %edx,%eax
 782:	72 04                	jb     788 <free+0x58>
 784:	39 d1                	cmp    %edx,%ecx
 786:	72 ce                	jb     756 <free+0x26>
{
 788:	89 d0                	mov    %edx,%eax
 78a:	eb bc                	jmp    748 <free+0x18>
 78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 790:	03 72 04             	add    0x4(%edx),%esi
 793:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 12                	mov    (%edx),%edx
 79a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a3:	39 f1                	cmp    %esi,%ecx
 7a5:	75 c6                	jne    76d <free+0x3d>
    p->s.size += bp->s.size;
 7a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7aa:	a3 38 0c 00 00       	mov    %eax,0xc38
    p->s.size += bp->s.size;
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7b5:	89 08                	mov    %ecx,(%eax)
}
 7b7:	5b                   	pop    %ebx
 7b8:	5e                   	pop    %esi
 7b9:	5f                   	pop    %edi
 7ba:	5d                   	pop    %ebp
 7bb:	c3                   	ret
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7cc:	8b 15 38 0c 00 00    	mov    0xc38,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8d 78 07             	lea    0x7(%eax),%edi
 7d5:	c1 ef 03             	shr    $0x3,%edi
 7d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7db:	85 d2                	test   %edx,%edx
 7dd:	0f 84 8d 00 00 00    	je     870 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7e5:	8b 48 04             	mov    0x4(%eax),%ecx
 7e8:	39 f9                	cmp    %edi,%ecx
 7ea:	73 64                	jae    850 <malloc+0x90>
  if(nu < 4096)
 7ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7f1:	39 df                	cmp    %ebx,%edi
 7f3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7f6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7fd:	eb 0a                	jmp    809 <malloc+0x49>
 7ff:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 802:	8b 48 04             	mov    0x4(%eax),%ecx
 805:	39 f9                	cmp    %edi,%ecx
 807:	73 47                	jae    850 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 809:	89 c2                	mov    %eax,%edx
 80b:	3b 05 38 0c 00 00    	cmp    0xc38,%eax
 811:	75 ed                	jne    800 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 813:	83 ec 0c             	sub    $0xc,%esp
 816:	56                   	push   %esi
 817:	e8 5f fc ff ff       	call   47b <sbrk>
  if(p == (char*)-1)
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	83 f8 ff             	cmp    $0xffffffff,%eax
 822:	74 1c                	je     840 <malloc+0x80>
  hp->s.size = nu;
 824:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 827:	83 ec 0c             	sub    $0xc,%esp
 82a:	83 c0 08             	add    $0x8,%eax
 82d:	50                   	push   %eax
 82e:	e8 fd fe ff ff       	call   730 <free>
  return freep;
 833:	8b 15 38 0c 00 00    	mov    0xc38,%edx
      if((p = morecore(nunits)) == 0)
 839:	83 c4 10             	add    $0x10,%esp
 83c:	85 d2                	test   %edx,%edx
 83e:	75 c0                	jne    800 <malloc+0x40>
        return 0;
  }
}
 840:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 843:	31 c0                	xor    %eax,%eax
}
 845:	5b                   	pop    %ebx
 846:	5e                   	pop    %esi
 847:	5f                   	pop    %edi
 848:	5d                   	pop    %ebp
 849:	c3                   	ret
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 850:	39 cf                	cmp    %ecx,%edi
 852:	74 4c                	je     8a0 <malloc+0xe0>
        p->s.size -= nunits;
 854:	29 f9                	sub    %edi,%ecx
 856:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 859:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 85c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 85f:	89 15 38 0c 00 00    	mov    %edx,0xc38
}
 865:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 868:	83 c0 08             	add    $0x8,%eax
}
 86b:	5b                   	pop    %ebx
 86c:	5e                   	pop    %esi
 86d:	5f                   	pop    %edi
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 870:	c7 05 38 0c 00 00 3c 	movl   $0xc3c,0xc38
 877:	0c 00 00 
    base.s.size = 0;
 87a:	b8 3c 0c 00 00       	mov    $0xc3c,%eax
    base.s.ptr = freep = prevp = &base;
 87f:	c7 05 3c 0c 00 00 3c 	movl   $0xc3c,0xc3c
 886:	0c 00 00 
    base.s.size = 0;
 889:	c7 05 40 0c 00 00 00 	movl   $0x0,0xc40
 890:	00 00 00 
    if(p->s.size >= nunits){
 893:	e9 54 ff ff ff       	jmp    7ec <malloc+0x2c>
 898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 89f:	00 
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb b9                	jmp    85f <malloc+0x9f>
