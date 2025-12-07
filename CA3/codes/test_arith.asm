
_test_arith:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
  int a = 20;
  int b = 10;
  int res;

  asm volatile(
   7:	b8 14 00 00 00       	mov    $0x14,%eax
   c:	ba 0a 00 00 00       	mov    $0xa,%edx
{
  11:	ff 71 fc             	push   -0x4(%ecx)
  14:	55                   	push   %ebp
  15:	89 e5                	mov    %esp,%ebp
  17:	53                   	push   %ebx
  18:	51                   	push   %ecx
  asm volatile(
  19:	89 c3                	mov    %eax,%ebx
  1b:	89 d1                	mov    %edx,%ecx
    :
    : "r"(a), "r"(b)
    : "%ebx", "%ecx"
  );
  
  res = simple_arithmetic_syscall(a, b);
  1d:	83 ec 08             	sub    $0x8,%esp
  20:	6a 0a                	push   $0xa
  22:	6a 14                	push   $0x14
  24:	e8 0a 03 00 00       	call   333 <simple_arithmetic_syscall>

  exit();
  29:	e8 55 02 00 00       	call   283 <exit>
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  30:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  31:	31 c0                	xor    %eax,%eax
{
  33:	89 e5                	mov    %esp,%ebp
  35:	53                   	push   %ebx
  36:	8b 4d 08             	mov    0x8(%ebp),%ecx
  39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  47:	83 c0 01             	add    $0x1,%eax
  4a:	84 d2                	test   %dl,%dl
  4c:	75 f2                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  51:	89 c8                	mov    %ecx,%eax
  53:	c9                   	leave
  54:	c3                   	ret
  55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  5c:	00 
  5d:	8d 76 00             	lea    0x0(%esi),%esi

00000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	84 c0                	test   %al,%al
  6f:	75 17                	jne    88 <strcmp+0x28>
  71:	eb 3a                	jmp    ad <strcmp+0x4d>
  73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  78:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  7c:	83 c2 01             	add    $0x1,%edx
  7f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  82:	84 c0                	test   %al,%al
  84:	74 1a                	je     a0 <strcmp+0x40>
  86:	89 d9                	mov    %ebx,%ecx
  88:	0f b6 19             	movzbl (%ecx),%ebx
  8b:	38 c3                	cmp    %al,%bl
  8d:	74 e9                	je     78 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  8f:	29 d8                	sub    %ebx,%eax
}
  91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  94:	c9                   	leave
  95:	c3                   	ret
  96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9d:	00 
  9e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  a4:	31 c0                	xor    %eax,%eax
  a6:	29 d8                	sub    %ebx,%eax
}
  a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ab:	c9                   	leave
  ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	31 c0                	xor    %eax,%eax
  b2:	eb db                	jmp    8f <strcmp+0x2f>
  b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  bb:	00 
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c6:	80 3a 00             	cmpb   $0x0,(%edx)
  c9:	74 15                	je     e0 <strlen+0x20>
  cb:	31 c0                	xor    %eax,%eax
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	83 c0 01             	add    $0x1,%eax
  d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d7:	89 c1                	mov    %eax,%ecx
  d9:	75 f5                	jne    d0 <strlen+0x10>
    ;
  return n;
}
  db:	89 c8                	mov    %ecx,%eax
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret
  df:	90                   	nop
  for(n = 0; s[n]; n++)
  e0:	31 c9                	xor    %ecx,%ecx
}
  e2:	5d                   	pop    %ebp
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	89 d7                	mov    %edx,%edi
  ff:	fc                   	cld
 100:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 102:	8b 7d fc             	mov    -0x4(%ebp),%edi
 105:	89 d0                	mov    %edx,%eax
 107:	c9                   	leave
 108:	c3                   	ret
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	75 12                	jne    133 <strchr+0x23>
 121:	eb 1d                	jmp    140 <strchr+0x30>
 123:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 128:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 12c:	83 c0 01             	add    $0x1,%eax
 12f:	84 d2                	test   %dl,%dl
 131:	74 0d                	je     140 <strchr+0x30>
    if(*s == c)
 133:	38 d1                	cmp    %dl,%cl
 135:	75 f1                	jne    128 <strchr+0x18>
      return (char*)s;
  return 0;
}
 137:	5d                   	pop    %ebp
 138:	c3                   	ret
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 140:	31 c0                	xor    %eax,%eax
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret
 144:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 14b:	00 
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 155:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 158:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 159:	31 db                	xor    %ebx,%ebx
 15b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 15e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 161:	3b 75 0c             	cmp    0xc(%ebp),%esi
 164:	7d 3b                	jge    1a1 <gets+0x51>
 166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 16d:	00 
 16e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	6a 01                	push   $0x1
 175:	57                   	push   %edi
 176:	6a 00                	push   $0x0
 178:	e8 1e 01 00 00       	call   29b <read>
    if(cc < 1)
 17d:	83 c4 10             	add    $0x10,%esp
 180:	85 c0                	test   %eax,%eax
 182:	7e 1d                	jle    1a1 <gets+0x51>
      break;
      
    buf[i++] = c;
 184:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 188:	8b 55 08             	mov    0x8(%ebp),%edx
 18b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 18f:	3c 0a                	cmp    $0xa,%al
 191:	7f 25                	jg     1b8 <gets+0x68>
 193:	3c 08                	cmp    $0x8,%al
 195:	7f 0c                	jg     1a3 <gets+0x53>
{
 197:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 199:	8d 73 01             	lea    0x1(%ebx),%esi
 19c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 19f:	7c cf                	jl     170 <gets+0x20>
 1a1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ad:	5b                   	pop    %ebx
 1ae:	5e                   	pop    %esi
 1af:	5f                   	pop    %edi
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret
 1b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b8:	3c 0d                	cmp    $0xd,%al
 1ba:	74 e7                	je     1a3 <gets+0x53>
{
 1bc:	89 f3                	mov    %esi,%ebx
 1be:	eb d9                	jmp    199 <gets+0x49>

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	push   0x8(%ebp)
 1cd:	e8 f1 00 00 00       	call   2c3 <open>
  if(fd < 0)
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	78 27                	js     200 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	push   0xc(%ebp)
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	50                   	push   %eax
 1e2:	e8 f4 00 00 00       	call   2db <fstat>
  close(fd);
 1e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ea:	89 c6                	mov    %eax,%esi
  close(fd);
 1ec:	e8 ba 00 00 00       	call   2ab <close>
  return r;
 1f1:	83 c4 10             	add    $0x10,%esp
}
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	89 f0                	mov    %esi,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 200:	be ff ff ff ff       	mov    $0xffffffff,%esi
 205:	eb ed                	jmp    1f4 <stat+0x34>
 207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20e:	00 
 20f:	90                   	nop

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	0f be 02             	movsbl (%edx),%eax
 21a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 21d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 220:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 225:	77 1e                	ja     245 <atoi+0x35>
 227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22e:	00 
 22f:	90                   	nop
    n = n*10 + *s++ - '0';
 230:	83 c2 01             	add    $0x1,%edx
 233:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 236:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 23a:	0f be 02             	movsbl (%edx),%eax
 23d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x20>
  return n;
}
 245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 248:	89 c8                	mov    %ecx,%eax
 24a:	c9                   	leave
 24b:	c3                   	ret
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 45 10             	mov    0x10(%ebp),%eax
 257:	8b 55 08             	mov    0x8(%ebp),%edx
 25a:	56                   	push   %esi
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 c0                	test   %eax,%eax
 260:	7e 13                	jle    275 <memmove+0x25>
 262:	01 d0                	add    %edx,%eax
  dst = vdst;
 264:	89 d7                	mov    %edx,%edi
 266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26d:	00 
 26e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 270:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 271:	39 f8                	cmp    %edi,%eax
 273:	75 fb                	jne    270 <memmove+0x20>
  return vdst;
}
 275:	5e                   	pop    %esi
 276:	89 d0                	mov    %edx,%eax
 278:	5f                   	pop    %edi
 279:	5d                   	pop    %ebp
 27a:	c3                   	ret

0000027b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 27b:	b8 01 00 00 00       	mov    $0x1,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <exit>:
SYSCALL(exit)
 283:	b8 02 00 00 00       	mov    $0x2,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <wait>:
SYSCALL(wait)
 28b:	b8 03 00 00 00       	mov    $0x3,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <pipe>:
SYSCALL(pipe)
 293:	b8 04 00 00 00       	mov    $0x4,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <read>:
SYSCALL(read)
 29b:	b8 05 00 00 00       	mov    $0x5,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <write>:
SYSCALL(write)
 2a3:	b8 10 00 00 00       	mov    $0x10,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <close>:
SYSCALL(close)
 2ab:	b8 15 00 00 00       	mov    $0x15,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <kill>:
SYSCALL(kill)
 2b3:	b8 06 00 00 00       	mov    $0x6,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <exec>:
SYSCALL(exec)
 2bb:	b8 07 00 00 00       	mov    $0x7,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <open>:
SYSCALL(open)
 2c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <mknod>:
SYSCALL(mknod)
 2cb:	b8 11 00 00 00       	mov    $0x11,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <unlink>:
SYSCALL(unlink)
 2d3:	b8 12 00 00 00       	mov    $0x12,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <fstat>:
SYSCALL(fstat)
 2db:	b8 08 00 00 00       	mov    $0x8,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <link>:
SYSCALL(link)
 2e3:	b8 13 00 00 00       	mov    $0x13,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <mkdir>:
SYSCALL(mkdir)
 2eb:	b8 14 00 00 00       	mov    $0x14,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <chdir>:
SYSCALL(chdir)
 2f3:	b8 09 00 00 00       	mov    $0x9,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <dup>:
SYSCALL(dup)
 2fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <getpid>:
SYSCALL(getpid)
 303:	b8 0b 00 00 00       	mov    $0xb,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <sbrk>:
SYSCALL(sbrk)
 30b:	b8 0c 00 00 00       	mov    $0xc,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <sleep>:
SYSCALL(sleep)
 313:	b8 0d 00 00 00       	mov    $0xd,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <uptime>:
SYSCALL(uptime)
 31b:	b8 0e 00 00 00       	mov    $0xe,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 323:	b8 17 00 00 00       	mov    $0x17,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <show_process_family>:
SYSCALL(show_process_family)
 32b:	b8 18 00 00 00       	mov    $0x18,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <grep_syscall>:
SYSCALL(grep_syscall)
 33b:	b8 19 00 00 00       	mov    $0x19,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 343:	b8 1a 00 00 00       	mov    $0x1a,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <start_throughput>:
SYSCALL(start_throughput)
 34b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <end_throughput>:
 353:	b8 1c 00 00 00       	mov    $0x1c,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret
 35b:	66 90                	xchg   %ax,%ax
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 368:	89 d1                	mov    %edx,%ecx
{
 36a:	83 ec 3c             	sub    $0x3c,%esp
 36d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 370:	85 d2                	test   %edx,%edx
 372:	0f 89 80 00 00 00    	jns    3f8 <printint+0x98>
 378:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 37c:	74 7a                	je     3f8 <printint+0x98>
    x = -xx;
 37e:	f7 d9                	neg    %ecx
    neg = 1;
 380:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 385:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 388:	31 f6                	xor    %esi,%esi
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 c8                	mov    %ecx,%eax
 392:	31 d2                	xor    %edx,%edx
 394:	89 f7                	mov    %esi,%edi
 396:	f7 f3                	div    %ebx
 398:	8d 76 01             	lea    0x1(%esi),%esi
 39b:	0f b6 92 68 07 00 00 	movzbl 0x768(%edx),%edx
 3a2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 3a6:	89 ca                	mov    %ecx,%edx
 3a8:	89 c1                	mov    %eax,%ecx
 3aa:	39 da                	cmp    %ebx,%edx
 3ac:	73 e2                	jae    390 <printint+0x30>
  if(neg)
 3ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b1:	85 c0                	test   %eax,%eax
 3b3:	74 07                	je     3bc <printint+0x5c>
    buf[i++] = '-';
 3b5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3ba:	89 f7                	mov    %esi,%edi
 3bc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3bf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3c2:	01 df                	add    %ebx,%edi
 3c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3cb:	83 ec 04             	sub    $0x4,%esp
 3ce:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3d4:	6a 01                	push   $0x1
 3d6:	50                   	push   %eax
 3d7:	56                   	push   %esi
 3d8:	e8 c6 fe ff ff       	call   2a3 <write>
  while(--i >= 0)
 3dd:	89 f8                	mov    %edi,%eax
 3df:	83 c4 10             	add    $0x10,%esp
 3e2:	83 ef 01             	sub    $0x1,%edi
 3e5:	39 c3                	cmp    %eax,%ebx
 3e7:	75 df                	jne    3c8 <printint+0x68>
}
 3e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret
 3f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3f8:	31 c0                	xor    %eax,%eax
 3fa:	eb 89                	jmp    385 <printint+0x25>
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 40c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 40f:	0f b6 1e             	movzbl (%esi),%ebx
 412:	83 c6 01             	add    $0x1,%esi
 415:	84 db                	test   %bl,%bl
 417:	74 67                	je     480 <printf+0x80>
 419:	8d 4d 10             	lea    0x10(%ebp),%ecx
 41c:	31 d2                	xor    %edx,%edx
 41e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 421:	eb 34                	jmp    457 <printf+0x57>
 423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 428:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 42b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 430:	83 f8 25             	cmp    $0x25,%eax
 433:	74 18                	je     44d <printf+0x4d>
  write(fd, &c, 1);
 435:	83 ec 04             	sub    $0x4,%esp
 438:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 43e:	6a 01                	push   $0x1
 440:	50                   	push   %eax
 441:	57                   	push   %edi
 442:	e8 5c fe ff ff       	call   2a3 <write>
 447:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 44a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 44d:	0f b6 1e             	movzbl (%esi),%ebx
 450:	83 c6 01             	add    $0x1,%esi
 453:	84 db                	test   %bl,%bl
 455:	74 29                	je     480 <printf+0x80>
    c = fmt[i] & 0xff;
 457:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45a:	85 d2                	test   %edx,%edx
 45c:	74 ca                	je     428 <printf+0x28>
      }
    } else if(state == '%'){
 45e:	83 fa 25             	cmp    $0x25,%edx
 461:	75 ea                	jne    44d <printf+0x4d>
      if(c == 'd'){
 463:	83 f8 25             	cmp    $0x25,%eax
 466:	0f 84 04 01 00 00    	je     570 <printf+0x170>
 46c:	83 e8 63             	sub    $0x63,%eax
 46f:	83 f8 15             	cmp    $0x15,%eax
 472:	77 1c                	ja     490 <printf+0x90>
 474:	ff 24 85 10 07 00 00 	jmp    *0x710(,%eax,4)
 47b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 480:	8d 65 f4             	lea    -0xc(%ebp),%esp
 483:	5b                   	pop    %ebx
 484:	5e                   	pop    %esi
 485:	5f                   	pop    %edi
 486:	5d                   	pop    %ebp
 487:	c3                   	ret
 488:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48f:	00 
  write(fd, &c, 1);
 490:	83 ec 04             	sub    $0x4,%esp
 493:	8d 55 e7             	lea    -0x19(%ebp),%edx
 496:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 49a:	6a 01                	push   $0x1
 49c:	52                   	push   %edx
 49d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4a0:	57                   	push   %edi
 4a1:	e8 fd fd ff ff       	call   2a3 <write>
 4a6:	83 c4 0c             	add    $0xc,%esp
 4a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ac:	6a 01                	push   $0x1
 4ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4b1:	52                   	push   %edx
 4b2:	57                   	push   %edi
 4b3:	e8 eb fd ff ff       	call   2a3 <write>
        putc(fd, c);
 4b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4bb:	31 d2                	xor    %edx,%edx
 4bd:	eb 8e                	jmp    44d <printf+0x4d>
 4bf:	90                   	nop
        printint(fd, *ap, 16, 0);
 4c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4c3:	83 ec 0c             	sub    $0xc,%esp
 4c6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4cb:	8b 13                	mov    (%ebx),%edx
 4cd:	6a 00                	push   $0x0
 4cf:	89 f8                	mov    %edi,%eax
        ap++;
 4d1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4d4:	e8 87 fe ff ff       	call   360 <printint>
        ap++;
 4d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4df:	31 d2                	xor    %edx,%edx
 4e1:	e9 67 ff ff ff       	jmp    44d <printf+0x4d>
        s = (char*)*ap;
 4e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4e9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4eb:	83 c0 04             	add    $0x4,%eax
 4ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4f1:	85 db                	test   %ebx,%ebx
 4f3:	0f 84 87 00 00 00    	je     580 <printf+0x180>
        while(*s != 0){
 4f9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4fc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4fe:	84 c0                	test   %al,%al
 500:	0f 84 47 ff ff ff    	je     44d <printf+0x4d>
 506:	8d 55 e7             	lea    -0x19(%ebp),%edx
 509:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 50c:	89 de                	mov    %ebx,%esi
 50e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 516:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 519:	6a 01                	push   $0x1
 51b:	53                   	push   %ebx
 51c:	57                   	push   %edi
 51d:	e8 81 fd ff ff       	call   2a3 <write>
        while(*s != 0){
 522:	0f b6 06             	movzbl (%esi),%eax
 525:	83 c4 10             	add    $0x10,%esp
 528:	84 c0                	test   %al,%al
 52a:	75 e4                	jne    510 <printf+0x110>
      state = 0;
 52c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 52f:	31 d2                	xor    %edx,%edx
 531:	e9 17 ff ff ff       	jmp    44d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 536:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 539:	83 ec 0c             	sub    $0xc,%esp
 53c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 541:	8b 13                	mov    (%ebx),%edx
 543:	6a 01                	push   $0x1
 545:	eb 88                	jmp    4cf <printf+0xcf>
        putc(fd, *ap);
 547:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 550:	8b 03                	mov    (%ebx),%eax
        ap++;
 552:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 555:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 558:	6a 01                	push   $0x1
 55a:	52                   	push   %edx
 55b:	57                   	push   %edi
 55c:	e8 42 fd ff ff       	call   2a3 <write>
        ap++;
 561:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 564:	83 c4 10             	add    $0x10,%esp
      state = 0;
 567:	31 d2                	xor    %edx,%edx
 569:	e9 df fe ff ff       	jmp    44d <printf+0x4d>
 56e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	88 5d e7             	mov    %bl,-0x19(%ebp)
 576:	8d 55 e7             	lea    -0x19(%ebp),%edx
 579:	6a 01                	push   $0x1
 57b:	e9 31 ff ff ff       	jmp    4b1 <printf+0xb1>
 580:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 585:	bb 08 07 00 00       	mov    $0x708,%ebx
 58a:	e9 77 ff ff ff       	jmp    506 <printf+0x106>
 58f:	90                   	nop

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	a1 08 0a 00 00       	mov    0xa08,%eax
{
 596:	89 e5                	mov    %esp,%ebp
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	53                   	push   %ebx
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 59e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5aa:	39 c8                	cmp    %ecx,%eax
 5ac:	73 32                	jae    5e0 <free+0x50>
 5ae:	39 d1                	cmp    %edx,%ecx
 5b0:	72 04                	jb     5b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b2:	39 d0                	cmp    %edx,%eax
 5b4:	72 32                	jb     5e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5bc:	39 fa                	cmp    %edi,%edx
 5be:	74 30                	je     5f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5c3:	8b 50 04             	mov    0x4(%eax),%edx
 5c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c9:	39 f1                	cmp    %esi,%ecx
 5cb:	74 3a                	je     607 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5cd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5cf:	5b                   	pop    %ebx
  freep = p;
 5d0:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 5d5:	5e                   	pop    %esi
 5d6:	5f                   	pop    %edi
 5d7:	5d                   	pop    %ebp
 5d8:	c3                   	ret
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	39 d0                	cmp    %edx,%eax
 5e2:	72 04                	jb     5e8 <free+0x58>
 5e4:	39 d1                	cmp    %edx,%ecx
 5e6:	72 ce                	jb     5b6 <free+0x26>
{
 5e8:	89 d0                	mov    %edx,%eax
 5ea:	eb bc                	jmp    5a8 <free+0x18>
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 5f0:	03 72 04             	add    0x4(%edx),%esi
 5f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5f6:	8b 10                	mov    (%eax),%edx
 5f8:	8b 12                	mov    (%edx),%edx
 5fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5fd:	8b 50 04             	mov    0x4(%eax),%edx
 600:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 603:	39 f1                	cmp    %esi,%ecx
 605:	75 c6                	jne    5cd <free+0x3d>
    p->s.size += bp->s.size;
 607:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 60a:	a3 08 0a 00 00       	mov    %eax,0xa08
    p->s.size += bp->s.size;
 60f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 612:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 615:	89 08                	mov    %ecx,(%eax)
}
 617:	5b                   	pop    %ebx
 618:	5e                   	pop    %esi
 619:	5f                   	pop    %edi
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 62c:	8b 15 08 0a 00 00    	mov    0xa08,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 632:	8d 78 07             	lea    0x7(%eax),%edi
 635:	c1 ef 03             	shr    $0x3,%edi
 638:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 63b:	85 d2                	test   %edx,%edx
 63d:	0f 84 8d 00 00 00    	je     6d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 643:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 645:	8b 48 04             	mov    0x4(%eax),%ecx
 648:	39 f9                	cmp    %edi,%ecx
 64a:	73 64                	jae    6b0 <malloc+0x90>
  if(nu < 4096)
 64c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 651:	39 df                	cmp    %ebx,%edi
 653:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 656:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 65d:	eb 0a                	jmp    669 <malloc+0x49>
 65f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 660:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 662:	8b 48 04             	mov    0x4(%eax),%ecx
 665:	39 f9                	cmp    %edi,%ecx
 667:	73 47                	jae    6b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 669:	89 c2                	mov    %eax,%edx
 66b:	3b 05 08 0a 00 00    	cmp    0xa08,%eax
 671:	75 ed                	jne    660 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 673:	83 ec 0c             	sub    $0xc,%esp
 676:	56                   	push   %esi
 677:	e8 8f fc ff ff       	call   30b <sbrk>
  if(p == (char*)-1)
 67c:	83 c4 10             	add    $0x10,%esp
 67f:	83 f8 ff             	cmp    $0xffffffff,%eax
 682:	74 1c                	je     6a0 <malloc+0x80>
  hp->s.size = nu;
 684:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 687:	83 ec 0c             	sub    $0xc,%esp
 68a:	83 c0 08             	add    $0x8,%eax
 68d:	50                   	push   %eax
 68e:	e8 fd fe ff ff       	call   590 <free>
  return freep;
 693:	8b 15 08 0a 00 00    	mov    0xa08,%edx
      if((p = morecore(nunits)) == 0)
 699:	83 c4 10             	add    $0x10,%esp
 69c:	85 d2                	test   %edx,%edx
 69e:	75 c0                	jne    660 <malloc+0x40>
        return 0;
  }
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6a3:	31 c0                	xor    %eax,%eax
}
 6a5:	5b                   	pop    %ebx
 6a6:	5e                   	pop    %esi
 6a7:	5f                   	pop    %edi
 6a8:	5d                   	pop    %ebp
 6a9:	c3                   	ret
 6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6b0:	39 cf                	cmp    %ecx,%edi
 6b2:	74 4c                	je     700 <malloc+0xe0>
        p->s.size -= nunits;
 6b4:	29 f9                	sub    %edi,%ecx
 6b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6bf:	89 15 08 0a 00 00    	mov    %edx,0xa08
}
 6c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6c8:	83 c0 08             	add    $0x8,%eax
}
 6cb:	5b                   	pop    %ebx
 6cc:	5e                   	pop    %esi
 6cd:	5f                   	pop    %edi
 6ce:	5d                   	pop    %ebp
 6cf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6d0:	c7 05 08 0a 00 00 0c 	movl   $0xa0c,0xa08
 6d7:	0a 00 00 
    base.s.size = 0;
 6da:	b8 0c 0a 00 00       	mov    $0xa0c,%eax
    base.s.ptr = freep = prevp = &base;
 6df:	c7 05 0c 0a 00 00 0c 	movl   $0xa0c,0xa0c
 6e6:	0a 00 00 
    base.s.size = 0;
 6e9:	c7 05 10 0a 00 00 00 	movl   $0x0,0xa10
 6f0:	00 00 00 
    if(p->s.size >= nunits){
 6f3:	e9 54 ff ff ff       	jmp    64c <malloc+0x2c>
 6f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ff:	00 
        prevp->s.ptr = p->s.ptr;
 700:	8b 08                	mov    (%eax),%ecx
 702:	89 0a                	mov    %ecx,(%edx)
 704:	eb b9                	jmp    6bf <malloc+0x9f>
