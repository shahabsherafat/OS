
_mygetpid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  int pid = getpid();
   6:	e8 d8 02 00 00       	call   2e3 <getpid>
  exit();
   b:	e8 53 02 00 00       	call   263 <exit>

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  10:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  11:	31 c0                	xor    %eax,%eax
{
  13:	89 e5                	mov    %esp,%ebp
  15:	53                   	push   %ebx
  16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  19:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  27:	83 c0 01             	add    $0x1,%eax
  2a:	84 d2                	test   %dl,%dl
  2c:	75 f2                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  31:	89 c8                	mov    %ecx,%eax
  33:	c9                   	leave
  34:	c3                   	ret
  35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  3c:	00 
  3d:	8d 76 00             	lea    0x0(%esi),%esi

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
  44:	8b 55 08             	mov    0x8(%ebp),%edx
  47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  4a:	0f b6 02             	movzbl (%edx),%eax
  4d:	84 c0                	test   %al,%al
  4f:	75 17                	jne    68 <strcmp+0x28>
  51:	eb 3a                	jmp    8d <strcmp+0x4d>
  53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  58:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  5c:	83 c2 01             	add    $0x1,%edx
  5f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  62:	84 c0                	test   %al,%al
  64:	74 1a                	je     80 <strcmp+0x40>
  66:	89 d9                	mov    %ebx,%ecx
  68:	0f b6 19             	movzbl (%ecx),%ebx
  6b:	38 c3                	cmp    %al,%bl
  6d:	74 e9                	je     58 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  6f:	29 d8                	sub    %ebx,%eax
}
  71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  74:	c9                   	leave
  75:	c3                   	ret
  76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  7d:	00 
  7e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  80:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  84:	31 c0                	xor    %eax,%eax
  86:	29 d8                	sub    %ebx,%eax
}
  88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8b:	c9                   	leave
  8c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  8d:	0f b6 19             	movzbl (%ecx),%ebx
  90:	31 c0                	xor    %eax,%eax
  92:	eb db                	jmp    6f <strcmp+0x2f>
  94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9b:	00 
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000a0 <strlen>:

uint
strlen(const char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  a6:	80 3a 00             	cmpb   $0x0,(%edx)
  a9:	74 15                	je     c0 <strlen+0x20>
  ab:	31 c0                	xor    %eax,%eax
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  b0:	83 c0 01             	add    $0x1,%eax
  b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  b7:	89 c1                	mov    %eax,%ecx
  b9:	75 f5                	jne    b0 <strlen+0x10>
    ;
  return n;
}
  bb:	89 c8                	mov    %ecx,%eax
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret
  bf:	90                   	nop
  for(n = 0; s[n]; n++)
  c0:	31 c9                	xor    %ecx,%ecx
}
  c2:	5d                   	pop    %ebp
  c3:	89 c8                	mov    %ecx,%eax
  c5:	c3                   	ret
  c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  cd:	00 
  ce:	66 90                	xchg   %ax,%ax

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	57                   	push   %edi
  d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	89 d7                	mov    %edx,%edi
  df:	fc                   	cld
  e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  e5:	89 d0                	mov    %edx,%eax
  e7:	c9                   	leave
  e8:	c3                   	ret
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  fa:	0f b6 10             	movzbl (%eax),%edx
  fd:	84 d2                	test   %dl,%dl
  ff:	75 12                	jne    113 <strchr+0x23>
 101:	eb 1d                	jmp    120 <strchr+0x30>
 103:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 108:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 10c:	83 c0 01             	add    $0x1,%eax
 10f:	84 d2                	test   %dl,%dl
 111:	74 0d                	je     120 <strchr+0x30>
    if(*s == c)
 113:	38 d1                	cmp    %dl,%cl
 115:	75 f1                	jne    108 <strchr+0x18>
      return (char*)s;
  return 0;
}
 117:	5d                   	pop    %ebp
 118:	c3                   	ret
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 120:	31 c0                	xor    %eax,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret
 124:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12b:	00 
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 135:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 138:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 139:	31 db                	xor    %ebx,%ebx
 13b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 13e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 141:	3b 75 0c             	cmp    0xc(%ebp),%esi
 144:	7d 3b                	jge    181 <gets+0x51>
 146:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 14d:	00 
 14e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	6a 01                	push   $0x1
 155:	57                   	push   %edi
 156:	6a 00                	push   $0x0
 158:	e8 1e 01 00 00       	call   27b <read>
    if(cc < 1)
 15d:	83 c4 10             	add    $0x10,%esp
 160:	85 c0                	test   %eax,%eax
 162:	7e 1d                	jle    181 <gets+0x51>
      break;
      
    buf[i++] = c;
 164:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 168:	8b 55 08             	mov    0x8(%ebp),%edx
 16b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 16f:	3c 0a                	cmp    $0xa,%al
 171:	7f 25                	jg     198 <gets+0x68>
 173:	3c 08                	cmp    $0x8,%al
 175:	7f 0c                	jg     183 <gets+0x53>
{
 177:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 179:	8d 73 01             	lea    0x1(%ebx),%esi
 17c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 17f:	7c cf                	jl     150 <gets+0x20>
 181:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 18a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18d:	5b                   	pop    %ebx
 18e:	5e                   	pop    %esi
 18f:	5f                   	pop    %edi
 190:	5d                   	pop    %ebp
 191:	c3                   	ret
 192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 198:	3c 0d                	cmp    $0xd,%al
 19a:	74 e7                	je     183 <gets+0x53>
{
 19c:	89 f3                	mov    %esi,%ebx
 19e:	eb d9                	jmp    179 <gets+0x49>

000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	6a 00                	push   $0x0
 1aa:	ff 75 08             	push   0x8(%ebp)
 1ad:	e8 f1 00 00 00       	call   2a3 <open>
  if(fd < 0)
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	78 27                	js     1e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	ff 75 0c             	push   0xc(%ebp)
 1bf:	89 c3                	mov    %eax,%ebx
 1c1:	50                   	push   %eax
 1c2:	e8 f4 00 00 00       	call   2bb <fstat>
  close(fd);
 1c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1ca:	89 c6                	mov    %eax,%esi
  close(fd);
 1cc:	e8 ba 00 00 00       	call   28b <close>
  return r;
 1d1:	83 c4 10             	add    $0x10,%esp
}
 1d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d7:	89 f0                	mov    %esi,%eax
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1e5:	eb ed                	jmp    1d4 <stat+0x34>
 1e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ee:	00 
 1ef:	90                   	nop

000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f7:	0f be 02             	movsbl (%edx),%eax
 1fa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 1fd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 200:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 205:	77 1e                	ja     225 <atoi+0x35>
 207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20e:	00 
 20f:	90                   	nop
    n = n*10 + *s++ - '0';
 210:	83 c2 01             	add    $0x1,%edx
 213:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 216:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 21a:	0f be 02             	movsbl (%edx),%eax
 21d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 220:	80 fb 09             	cmp    $0x9,%bl
 223:	76 eb                	jbe    210 <atoi+0x20>
  return n;
}
 225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 228:	89 c8                	mov    %ecx,%eax
 22a:	c9                   	leave
 22b:	c3                   	ret
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	8b 45 10             	mov    0x10(%ebp),%eax
 237:	8b 55 08             	mov    0x8(%ebp),%edx
 23a:	56                   	push   %esi
 23b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	85 c0                	test   %eax,%eax
 240:	7e 13                	jle    255 <memmove+0x25>
 242:	01 d0                	add    %edx,%eax
  dst = vdst;
 244:	89 d7                	mov    %edx,%edi
 246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24d:	00 
 24e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 250:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 251:	39 f8                	cmp    %edi,%eax
 253:	75 fb                	jne    250 <memmove+0x20>
  return vdst;
}
 255:	5e                   	pop    %esi
 256:	89 d0                	mov    %edx,%eax
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret

0000025b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 25b:	b8 01 00 00 00       	mov    $0x1,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret

00000263 <exit>:
SYSCALL(exit)
 263:	b8 02 00 00 00       	mov    $0x2,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret

0000026b <wait>:
SYSCALL(wait)
 26b:	b8 03 00 00 00       	mov    $0x3,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret

00000273 <pipe>:
SYSCALL(pipe)
 273:	b8 04 00 00 00       	mov    $0x4,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret

0000027b <read>:
SYSCALL(read)
 27b:	b8 05 00 00 00       	mov    $0x5,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret

00000283 <write>:
SYSCALL(write)
 283:	b8 10 00 00 00       	mov    $0x10,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret

0000028b <close>:
SYSCALL(close)
 28b:	b8 15 00 00 00       	mov    $0x15,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret

00000293 <kill>:
SYSCALL(kill)
 293:	b8 06 00 00 00       	mov    $0x6,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret

0000029b <exec>:
SYSCALL(exec)
 29b:	b8 07 00 00 00       	mov    $0x7,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret

000002a3 <open>:
SYSCALL(open)
 2a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret

000002ab <mknod>:
SYSCALL(mknod)
 2ab:	b8 11 00 00 00       	mov    $0x11,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret

000002b3 <unlink>:
SYSCALL(unlink)
 2b3:	b8 12 00 00 00       	mov    $0x12,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret

000002bb <fstat>:
SYSCALL(fstat)
 2bb:	b8 08 00 00 00       	mov    $0x8,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <link>:
SYSCALL(link)
 2c3:	b8 13 00 00 00       	mov    $0x13,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <mkdir>:
SYSCALL(mkdir)
 2cb:	b8 14 00 00 00       	mov    $0x14,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <chdir>:
SYSCALL(chdir)
 2d3:	b8 09 00 00 00       	mov    $0x9,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <dup>:
SYSCALL(dup)
 2db:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <getpid>:
SYSCALL(getpid)
 2e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <sbrk>:
SYSCALL(sbrk)
 2eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <sleep>:
SYSCALL(sleep)
 2f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <uptime>:
SYSCALL(uptime)
 2fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 303:	b8 17 00 00 00       	mov    $0x17,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <show_process_family>:
SYSCALL(show_process_family)
 30b:	b8 18 00 00 00       	mov    $0x18,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 313:	b8 16 00 00 00       	mov    $0x16,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <grep_syscall>:
SYSCALL(grep_syscall)
 31b:	b8 19 00 00 00       	mov    $0x19,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 323:	b8 1a 00 00 00       	mov    $0x1a,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <start_throughput>:
SYSCALL(start_throughput)
 32b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <end_throughput>:
SYSCALL(end_throughput)
 333:	b8 1c 00 00 00       	mov    $0x1c,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <print_process_info>:
 33b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret
 343:	66 90                	xchg   %ax,%ax
 345:	66 90                	xchg   %ax,%ax
 347:	66 90                	xchg   %ax,%ax
 349:	66 90                	xchg   %ax,%ax
 34b:	66 90                	xchg   %ax,%ax
 34d:	66 90                	xchg   %ax,%ax
 34f:	90                   	nop

00000350 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 358:	89 d1                	mov    %edx,%ecx
{
 35a:	83 ec 3c             	sub    $0x3c,%esp
 35d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 360:	85 d2                	test   %edx,%edx
 362:	0f 89 80 00 00 00    	jns    3e8 <printint+0x98>
 368:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 36c:	74 7a                	je     3e8 <printint+0x98>
    x = -xx;
 36e:	f7 d9                	neg    %ecx
    neg = 1;
 370:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 375:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 378:	31 f6                	xor    %esi,%esi
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 380:	89 c8                	mov    %ecx,%eax
 382:	31 d2                	xor    %edx,%edx
 384:	89 f7                	mov    %esi,%edi
 386:	f7 f3                	div    %ebx
 388:	8d 76 01             	lea    0x1(%esi),%esi
 38b:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 392:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 396:	89 ca                	mov    %ecx,%edx
 398:	89 c1                	mov    %eax,%ecx
 39a:	39 da                	cmp    %ebx,%edx
 39c:	73 e2                	jae    380 <printint+0x30>
  if(neg)
 39e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a1:	85 c0                	test   %eax,%eax
 3a3:	74 07                	je     3ac <printint+0x5c>
    buf[i++] = '-';
 3a5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 3aa:	89 f7                	mov    %esi,%edi
 3ac:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 3af:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3b2:	01 df                	add    %ebx,%edi
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 3b8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	88 45 d7             	mov    %al,-0x29(%ebp)
 3c1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3c4:	6a 01                	push   $0x1
 3c6:	50                   	push   %eax
 3c7:	56                   	push   %esi
 3c8:	e8 b6 fe ff ff       	call   283 <write>
  while(--i >= 0)
 3cd:	89 f8                	mov    %edi,%eax
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	83 ef 01             	sub    $0x1,%edi
 3d5:	39 c3                	cmp    %eax,%ebx
 3d7:	75 df                	jne    3b8 <printint+0x68>
}
 3d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3dc:	5b                   	pop    %ebx
 3dd:	5e                   	pop    %esi
 3de:	5f                   	pop    %edi
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3e8:	31 c0                	xor    %eax,%eax
 3ea:	eb 89                	jmp    375 <printint+0x25>
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 3fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 3ff:	0f b6 1e             	movzbl (%esi),%ebx
 402:	83 c6 01             	add    $0x1,%esi
 405:	84 db                	test   %bl,%bl
 407:	74 67                	je     470 <printf+0x80>
 409:	8d 4d 10             	lea    0x10(%ebp),%ecx
 40c:	31 d2                	xor    %edx,%edx
 40e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 411:	eb 34                	jmp    447 <printf+0x57>
 413:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 418:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 41b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 420:	83 f8 25             	cmp    $0x25,%eax
 423:	74 18                	je     43d <printf+0x4d>
  write(fd, &c, 1);
 425:	83 ec 04             	sub    $0x4,%esp
 428:	8d 45 e7             	lea    -0x19(%ebp),%eax
 42b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 42e:	6a 01                	push   $0x1
 430:	50                   	push   %eax
 431:	57                   	push   %edi
 432:	e8 4c fe ff ff       	call   283 <write>
 437:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 43a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 43d:	0f b6 1e             	movzbl (%esi),%ebx
 440:	83 c6 01             	add    $0x1,%esi
 443:	84 db                	test   %bl,%bl
 445:	74 29                	je     470 <printf+0x80>
    c = fmt[i] & 0xff;
 447:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44a:	85 d2                	test   %edx,%edx
 44c:	74 ca                	je     418 <printf+0x28>
      }
    } else if(state == '%'){
 44e:	83 fa 25             	cmp    $0x25,%edx
 451:	75 ea                	jne    43d <printf+0x4d>
      if(c == 'd'){
 453:	83 f8 25             	cmp    $0x25,%eax
 456:	0f 84 04 01 00 00    	je     560 <printf+0x170>
 45c:	83 e8 63             	sub    $0x63,%eax
 45f:	83 f8 15             	cmp    $0x15,%eax
 462:	77 1c                	ja     480 <printf+0x90>
 464:	ff 24 85 00 07 00 00 	jmp    *0x700(,%eax,4)
 46b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 470:	8d 65 f4             	lea    -0xc(%ebp),%esp
 473:	5b                   	pop    %ebx
 474:	5e                   	pop    %esi
 475:	5f                   	pop    %edi
 476:	5d                   	pop    %ebp
 477:	c3                   	ret
 478:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 47f:	00 
  write(fd, &c, 1);
 480:	83 ec 04             	sub    $0x4,%esp
 483:	8d 55 e7             	lea    -0x19(%ebp),%edx
 486:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 48a:	6a 01                	push   $0x1
 48c:	52                   	push   %edx
 48d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 490:	57                   	push   %edi
 491:	e8 ed fd ff ff       	call   283 <write>
 496:	83 c4 0c             	add    $0xc,%esp
 499:	88 5d e7             	mov    %bl,-0x19(%ebp)
 49c:	6a 01                	push   $0x1
 49e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4a1:	52                   	push   %edx
 4a2:	57                   	push   %edi
 4a3:	e8 db fd ff ff       	call   283 <write>
        putc(fd, c);
 4a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ab:	31 d2                	xor    %edx,%edx
 4ad:	eb 8e                	jmp    43d <printf+0x4d>
 4af:	90                   	nop
        printint(fd, *ap, 16, 0);
 4b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4b3:	83 ec 0c             	sub    $0xc,%esp
 4b6:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bb:	8b 13                	mov    (%ebx),%edx
 4bd:	6a 00                	push   $0x0
 4bf:	89 f8                	mov    %edi,%eax
        ap++;
 4c1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 4c4:	e8 87 fe ff ff       	call   350 <printint>
        ap++;
 4c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 4cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cf:	31 d2                	xor    %edx,%edx
 4d1:	e9 67 ff ff ff       	jmp    43d <printf+0x4d>
        s = (char*)*ap;
 4d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4d9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4db:	83 c0 04             	add    $0x4,%eax
 4de:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4e1:	85 db                	test   %ebx,%ebx
 4e3:	0f 84 87 00 00 00    	je     570 <printf+0x180>
        while(*s != 0){
 4e9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 4ec:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 4ee:	84 c0                	test   %al,%al
 4f0:	0f 84 47 ff ff ff    	je     43d <printf+0x4d>
 4f6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 4f9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 4fc:	89 de                	mov    %ebx,%esi
 4fe:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 500:	83 ec 04             	sub    $0x4,%esp
 503:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 506:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 509:	6a 01                	push   $0x1
 50b:	53                   	push   %ebx
 50c:	57                   	push   %edi
 50d:	e8 71 fd ff ff       	call   283 <write>
        while(*s != 0){
 512:	0f b6 06             	movzbl (%esi),%eax
 515:	83 c4 10             	add    $0x10,%esp
 518:	84 c0                	test   %al,%al
 51a:	75 e4                	jne    500 <printf+0x110>
      state = 0;
 51c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 17 ff ff ff       	jmp    43d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 526:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 529:	83 ec 0c             	sub    $0xc,%esp
 52c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 531:	8b 13                	mov    (%ebx),%edx
 533:	6a 01                	push   $0x1
 535:	eb 88                	jmp    4bf <printf+0xcf>
        putc(fd, *ap);
 537:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 53a:	83 ec 04             	sub    $0x4,%esp
 53d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 540:	8b 03                	mov    (%ebx),%eax
        ap++;
 542:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 545:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 548:	6a 01                	push   $0x1
 54a:	52                   	push   %edx
 54b:	57                   	push   %edi
 54c:	e8 32 fd ff ff       	call   283 <write>
        ap++;
 551:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 554:	83 c4 10             	add    $0x10,%esp
      state = 0;
 557:	31 d2                	xor    %edx,%edx
 559:	e9 df fe ff ff       	jmp    43d <printf+0x4d>
 55e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 5d e7             	mov    %bl,-0x19(%ebp)
 566:	8d 55 e7             	lea    -0x19(%ebp),%edx
 569:	6a 01                	push   $0x1
 56b:	e9 31 ff ff ff       	jmp    4a1 <printf+0xb1>
 570:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 575:	bb f8 06 00 00       	mov    $0x6f8,%ebx
 57a:	e9 77 ff ff ff       	jmp    4f6 <printf+0x106>
 57f:	90                   	nop

00000580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 581:	a1 ec 09 00 00       	mov    0x9ec,%eax
{
 586:	89 e5                	mov    %esp,%ebp
 588:	57                   	push   %edi
 589:	56                   	push   %esi
 58a:	53                   	push   %ebx
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 58e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 598:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59a:	39 c8                	cmp    %ecx,%eax
 59c:	73 32                	jae    5d0 <free+0x50>
 59e:	39 d1                	cmp    %edx,%ecx
 5a0:	72 04                	jb     5a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a2:	39 d0                	cmp    %edx,%eax
 5a4:	72 32                	jb     5d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ac:	39 fa                	cmp    %edi,%edx
 5ae:	74 30                	je     5e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 5b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5b3:	8b 50 04             	mov    0x4(%eax),%edx
 5b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5b9:	39 f1                	cmp    %esi,%ecx
 5bb:	74 3a                	je     5f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 5bd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 5bf:	5b                   	pop    %ebx
  freep = p;
 5c0:	a3 ec 09 00 00       	mov    %eax,0x9ec
}
 5c5:	5e                   	pop    %esi
 5c6:	5f                   	pop    %edi
 5c7:	5d                   	pop    %ebp
 5c8:	c3                   	ret
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 d0                	cmp    %edx,%eax
 5d2:	72 04                	jb     5d8 <free+0x58>
 5d4:	39 d1                	cmp    %edx,%ecx
 5d6:	72 ce                	jb     5a6 <free+0x26>
{
 5d8:	89 d0                	mov    %edx,%eax
 5da:	eb bc                	jmp    598 <free+0x18>
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 5e0:	03 72 04             	add    0x4(%edx),%esi
 5e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	8b 12                	mov    (%edx),%edx
 5ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 50 04             	mov    0x4(%eax),%edx
 5f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f3:	39 f1                	cmp    %esi,%ecx
 5f5:	75 c6                	jne    5bd <free+0x3d>
    p->s.size += bp->s.size;
 5f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 5fa:	a3 ec 09 00 00       	mov    %eax,0x9ec
    p->s.size += bp->s.size;
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 602:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 605:	89 08                	mov    %ecx,(%eax)
}
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 61c:	8b 15 ec 09 00 00    	mov    0x9ec,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 622:	8d 78 07             	lea    0x7(%eax),%edi
 625:	c1 ef 03             	shr    $0x3,%edi
 628:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 62b:	85 d2                	test   %edx,%edx
 62d:	0f 84 8d 00 00 00    	je     6c0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 633:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 635:	8b 48 04             	mov    0x4(%eax),%ecx
 638:	39 f9                	cmp    %edi,%ecx
 63a:	73 64                	jae    6a0 <malloc+0x90>
  if(nu < 4096)
 63c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 641:	39 df                	cmp    %ebx,%edi
 643:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 646:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 64d:	eb 0a                	jmp    659 <malloc+0x49>
 64f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 652:	8b 48 04             	mov    0x4(%eax),%ecx
 655:	39 f9                	cmp    %edi,%ecx
 657:	73 47                	jae    6a0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 659:	89 c2                	mov    %eax,%edx
 65b:	3b 05 ec 09 00 00    	cmp    0x9ec,%eax
 661:	75 ed                	jne    650 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 663:	83 ec 0c             	sub    $0xc,%esp
 666:	56                   	push   %esi
 667:	e8 7f fc ff ff       	call   2eb <sbrk>
  if(p == (char*)-1)
 66c:	83 c4 10             	add    $0x10,%esp
 66f:	83 f8 ff             	cmp    $0xffffffff,%eax
 672:	74 1c                	je     690 <malloc+0x80>
  hp->s.size = nu;
 674:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 677:	83 ec 0c             	sub    $0xc,%esp
 67a:	83 c0 08             	add    $0x8,%eax
 67d:	50                   	push   %eax
 67e:	e8 fd fe ff ff       	call   580 <free>
  return freep;
 683:	8b 15 ec 09 00 00    	mov    0x9ec,%edx
      if((p = morecore(nunits)) == 0)
 689:	83 c4 10             	add    $0x10,%esp
 68c:	85 d2                	test   %edx,%edx
 68e:	75 c0                	jne    650 <malloc+0x40>
        return 0;
  }
}
 690:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 693:	31 c0                	xor    %eax,%eax
}
 695:	5b                   	pop    %ebx
 696:	5e                   	pop    %esi
 697:	5f                   	pop    %edi
 698:	5d                   	pop    %ebp
 699:	c3                   	ret
 69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6a0:	39 cf                	cmp    %ecx,%edi
 6a2:	74 4c                	je     6f0 <malloc+0xe0>
        p->s.size -= nunits;
 6a4:	29 f9                	sub    %edi,%ecx
 6a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6ac:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6af:	89 15 ec 09 00 00    	mov    %edx,0x9ec
}
 6b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 6b8:	83 c0 08             	add    $0x8,%eax
}
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 6c0:	c7 05 ec 09 00 00 f0 	movl   $0x9f0,0x9ec
 6c7:	09 00 00 
    base.s.size = 0;
 6ca:	b8 f0 09 00 00       	mov    $0x9f0,%eax
    base.s.ptr = freep = prevp = &base;
 6cf:	c7 05 f0 09 00 00 f0 	movl   $0x9f0,0x9f0
 6d6:	09 00 00 
    base.s.size = 0;
 6d9:	c7 05 f4 09 00 00 00 	movl   $0x0,0x9f4
 6e0:	00 00 00 
    if(p->s.size >= nunits){
 6e3:	e9 54 ff ff ff       	jmp    63c <malloc+0x2c>
 6e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ef:	00 
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb b9                	jmp    6af <malloc+0x9f>
