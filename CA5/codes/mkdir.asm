
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	bf 01 00 00 00       	mov    $0x1,%edi
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  1c:	8b 31                	mov    (%ecx),%esi
  1e:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
  21:	83 fe 01             	cmp    $0x1,%esi
  24:	7f 14                	jg     3a <main+0x3a>
  26:	eb 3a                	jmp    62 <main+0x62>
  28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  2f:	00 
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  30:	83 c7 01             	add    $0x1,%edi
  33:	83 c3 04             	add    $0x4,%ebx
  36:	39 fe                	cmp    %edi,%esi
  38:	74 23                	je     5d <main+0x5d>
    if(mkdir(argv[i]) < 0){
  3a:	83 ec 0c             	sub    $0xc,%esp
  3d:	ff 33                	push   (%ebx)
  3f:	e8 f7 02 00 00       	call   33b <mkdir>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	79 e5                	jns    30 <main+0x30>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  4b:	50                   	push   %eax
  4c:	ff 33                	push   (%ebx)
  4e:	68 cf 07 00 00       	push   $0x7cf
  53:	6a 02                	push   $0x2
  55:	e8 56 04 00 00       	call   4b0 <printf>
      break;
  5a:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  5d:	e8 71 02 00 00       	call   2d3 <exit>
    printf(2, "Usage: mkdir files...\n");
  62:	52                   	push   %edx
  63:	52                   	push   %edx
  64:	68 b8 07 00 00       	push   $0x7b8
  69:	6a 02                	push   $0x2
  6b:	e8 40 04 00 00       	call   4b0 <printf>
    exit();
  70:	e8 5e 02 00 00       	call   2d3 <exit>
  75:	66 90                	xchg   %ax,%ax
  77:	66 90                	xchg   %ax,%ax
  79:	66 90                	xchg   %ax,%ax
  7b:	66 90                	xchg   %ax,%ax
  7d:	66 90                	xchg   %ax,%ax
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  80:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  81:	31 c0                	xor    %eax,%eax
{
  83:	89 e5                	mov    %esp,%ebp
  85:	53                   	push   %ebx
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  97:	83 c0 01             	add    $0x1,%eax
  9a:	84 d2                	test   %dl,%dl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a1:	89 c8                	mov    %ecx,%eax
  a3:	c9                   	leave
  a4:	c3                   	ret
  a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ac:	00 
  ad:	8d 76 00             	lea    0x0(%esi),%esi

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ba:	0f b6 02             	movzbl (%edx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 17                	jne    d8 <strcmp+0x28>
  c1:	eb 3a                	jmp    fd <strcmp+0x4d>
  c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  cc:	83 c2 01             	add    $0x1,%edx
  cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  d2:	84 c0                	test   %al,%al
  d4:	74 1a                	je     f0 <strcmp+0x40>
  d6:	89 d9                	mov    %ebx,%ecx
  d8:	0f b6 19             	movzbl (%ecx),%ebx
  db:	38 c3                	cmp    %al,%bl
  dd:	74 e9                	je     c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  df:	29 d8                	sub    %ebx,%eax
}
  e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  e4:	c9                   	leave
  e5:	c3                   	ret
  e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ed:	00 
  ee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  f4:	31 c0                	xor    %eax,%eax
  f6:	29 d8                	sub    %ebx,%eax
}
  f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  fb:	c9                   	leave
  fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  fd:	0f b6 19             	movzbl (%ecx),%ebx
 100:	31 c0                	xor    %eax,%eax
 102:	eb db                	jmp    df <strcmp+0x2f>
 104:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 10b:	00 
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 3a 00             	cmpb   $0x0,(%edx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 c0                	xor    %eax,%eax
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c0 01             	add    $0x1,%eax
 123:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 127:	89 c1                	mov    %eax,%ecx
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	89 c8                	mov    %ecx,%eax
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret
 12f:	90                   	nop
  for(n = 0; s[n]; n++)
 130:	31 c9                	xor    %ecx,%ecx
}
 132:	5d                   	pop    %ebp
 133:	89 c8                	mov    %ecx,%eax
 135:	c3                   	ret
 136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13d:	00 
 13e:	66 90                	xchg   %ax,%ax

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	8b 7d fc             	mov    -0x4(%ebp),%edi
 155:	89 d0                	mov    %edx,%eax
 157:	c9                   	leave
 158:	c3                   	ret
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	75 12                	jne    183 <strchr+0x23>
 171:	eb 1d                	jmp    190 <strchr+0x30>
 173:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	84 d2                	test   %dl,%dl
 181:	74 0d                	je     190 <strchr+0x30>
    if(*s == c)
 183:	38 d1                	cmp    %dl,%cl
 185:	75 f1                	jne    178 <strchr+0x18>
      return (char*)s;
  return 0;
}
 187:	5d                   	pop    %ebp
 188:	c3                   	ret
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret
 194:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 19b:	00 
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1a9:	31 db                	xor    %ebx,%ebx
 1ab:	8d 73 01             	lea    0x1(%ebx),%esi
{
 1ae:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1b1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1b4:	7d 3b                	jge    1f1 <gets+0x51>
 1b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bd:	00 
 1be:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	6a 01                	push   $0x1
 1c5:	57                   	push   %edi
 1c6:	6a 00                	push   $0x0
 1c8:	e8 1e 01 00 00       	call   2eb <read>
    if(cc < 1)
 1cd:	83 c4 10             	add    $0x10,%esp
 1d0:	85 c0                	test   %eax,%eax
 1d2:	7e 1d                	jle    1f1 <gets+0x51>
      break;
      
    buf[i++] = c;
 1d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d8:	8b 55 08             	mov    0x8(%ebp),%edx
 1db:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	7f 25                	jg     208 <gets+0x68>
 1e3:	3c 08                	cmp    $0x8,%al
 1e5:	7f 0c                	jg     1f3 <gets+0x53>
{
 1e7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 1e9:	8d 73 01             	lea    0x1(%ebx),%esi
 1ec:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1ef:	7c cf                	jl     1c0 <gets+0x20>
 1f1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5f                   	pop    %edi
 200:	5d                   	pop    %ebp
 201:	c3                   	ret
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 208:	3c 0d                	cmp    $0xd,%al
 20a:	74 e7                	je     1f3 <gets+0x53>
{
 20c:	89 f3                	mov    %esi,%ebx
 20e:	eb d9                	jmp    1e9 <gets+0x49>

00000210 <stat>:

int
stat(const char *n, struct stat *st)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 215:	83 ec 08             	sub    $0x8,%esp
 218:	6a 00                	push   $0x0
 21a:	ff 75 08             	push   0x8(%ebp)
 21d:	e8 f1 00 00 00       	call   313 <open>
  if(fd < 0)
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 c0                	test   %eax,%eax
 227:	78 27                	js     250 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	ff 75 0c             	push   0xc(%ebp)
 22f:	89 c3                	mov    %eax,%ebx
 231:	50                   	push   %eax
 232:	e8 f4 00 00 00       	call   32b <fstat>
  close(fd);
 237:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 23a:	89 c6                	mov    %eax,%esi
  close(fd);
 23c:	e8 ba 00 00 00       	call   2fb <close>
  return r;
 241:	83 c4 10             	add    $0x10,%esp
}
 244:	8d 65 f8             	lea    -0x8(%ebp),%esp
 247:	89 f0                	mov    %esi,%eax
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret
 24d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 250:	be ff ff ff ff       	mov    $0xffffffff,%esi
 255:	eb ed                	jmp    244 <stat+0x34>
 257:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25e:	00 
 25f:	90                   	nop

00000260 <atoi>:

int
atoi(const char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 267:	0f be 02             	movsbl (%edx),%eax
 26a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 26d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 270:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 275:	77 1e                	ja     295 <atoi+0x35>
 277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27e:	00 
 27f:	90                   	nop
    n = n*10 + *s++ - '0';
 280:	83 c2 01             	add    $0x1,%edx
 283:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 286:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 28a:	0f be 02             	movsbl (%edx),%eax
 28d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x20>
  return n;
}
 295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 298:	89 c8                	mov    %ecx,%eax
 29a:	c9                   	leave
 29b:	c3                   	ret
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 45 10             	mov    0x10(%ebp),%eax
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
 2aa:	56                   	push   %esi
 2ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	85 c0                	test   %eax,%eax
 2b0:	7e 13                	jle    2c5 <memmove+0x25>
 2b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2b4:	89 d7                	mov    %edx,%edi
 2b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bd:	00 
 2be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2c1:	39 f8                	cmp    %edi,%eax
 2c3:	75 fb                	jne    2c0 <memmove+0x20>
  return vdst;
}
 2c5:	5e                   	pop    %esi
 2c6:	89 d0                	mov    %edx,%eax
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 373:	b8 17 00 00 00       	mov    $0x17,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <show_process_family>:
SYSCALL(show_process_family)
 37b:	b8 18 00 00 00       	mov    $0x18,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 383:	b8 16 00 00 00       	mov    $0x16,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <grep_syscall>:
SYSCALL(grep_syscall)
 38b:	b8 19 00 00 00       	mov    $0x19,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 393:	b8 1a 00 00 00       	mov    $0x1a,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 39b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 3a3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 3ab:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 3b3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 3bb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 3c3:	b8 20 00 00 00       	mov    $0x20,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 3cb:	b8 21 00 00 00       	mov    $0x21,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 3d3:	b8 22 00 00 00       	mov    $0x22,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <getlockstat>:

SYSCALL(getlockstat)
 3db:	b8 23 00 00 00       	mov    $0x23,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <vread>:

SYSCALL(vread)
 3e3:	b8 24 00 00 00       	mov    $0x24,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <vwrite>:
SYSCALL(vwrite)
 3eb:	b8 25 00 00 00       	mov    $0x25,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 3f3:	b8 26 00 00 00       	mov    $0x26,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <cptresetstats>:
SYSCALL(cptresetstats)
 3fb:	b8 27 00 00 00       	mov    $0x27,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <cptgetstats>:
SYSCALL(cptgetstats)
 403:	b8 28 00 00 00       	mov    $0x28,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret
 40b:	66 90                	xchg   %ax,%ax
 40d:	66 90                	xchg   %ax,%ax
 40f:	90                   	nop

00000410 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	56                   	push   %esi
 415:	53                   	push   %ebx
 416:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 418:	89 d1                	mov    %edx,%ecx
{
 41a:	83 ec 3c             	sub    $0x3c,%esp
 41d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 420:	85 d2                	test   %edx,%edx
 422:	0f 89 80 00 00 00    	jns    4a8 <printint+0x98>
 428:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 42c:	74 7a                	je     4a8 <printint+0x98>
    x = -xx;
 42e:	f7 d9                	neg    %ecx
    neg = 1;
 430:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 435:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 438:	31 f6                	xor    %esi,%esi
 43a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 440:	89 c8                	mov    %ecx,%eax
 442:	31 d2                	xor    %edx,%edx
 444:	89 f7                	mov    %esi,%edi
 446:	f7 f3                	div    %ebx
 448:	8d 76 01             	lea    0x1(%esi),%esi
 44b:	0f b6 92 4c 08 00 00 	movzbl 0x84c(%edx),%edx
 452:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 456:	89 ca                	mov    %ecx,%edx
 458:	89 c1                	mov    %eax,%ecx
 45a:	39 da                	cmp    %ebx,%edx
 45c:	73 e2                	jae    440 <printint+0x30>
  if(neg)
 45e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 461:	85 c0                	test   %eax,%eax
 463:	74 07                	je     46c <printint+0x5c>
    buf[i++] = '-';
 465:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 46a:	89 f7                	mov    %esi,%edi
 46c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 46f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 472:	01 df                	add    %ebx,%edi
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 478:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 47b:	83 ec 04             	sub    $0x4,%esp
 47e:	88 45 d7             	mov    %al,-0x29(%ebp)
 481:	8d 45 d7             	lea    -0x29(%ebp),%eax
 484:	6a 01                	push   $0x1
 486:	50                   	push   %eax
 487:	56                   	push   %esi
 488:	e8 66 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 48d:	89 f8                	mov    %edi,%eax
 48f:	83 c4 10             	add    $0x10,%esp
 492:	83 ef 01             	sub    $0x1,%edi
 495:	39 c3                	cmp    %eax,%ebx
 497:	75 df                	jne    478 <printint+0x68>
}
 499:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49c:	5b                   	pop    %ebx
 49d:	5e                   	pop    %esi
 49e:	5f                   	pop    %edi
 49f:	5d                   	pop    %ebp
 4a0:	c3                   	ret
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4a8:	31 c0                	xor    %eax,%eax
 4aa:	eb 89                	jmp    435 <printint+0x25>
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 4bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 4bf:	0f b6 1e             	movzbl (%esi),%ebx
 4c2:	83 c6 01             	add    $0x1,%esi
 4c5:	84 db                	test   %bl,%bl
 4c7:	74 67                	je     530 <printf+0x80>
 4c9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 4cc:	31 d2                	xor    %edx,%edx
 4ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 4d1:	eb 34                	jmp    507 <printf+0x57>
 4d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 4d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4db:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4e0:	83 f8 25             	cmp    $0x25,%eax
 4e3:	74 18                	je     4fd <printf+0x4d>
  write(fd, &c, 1);
 4e5:	83 ec 04             	sub    $0x4,%esp
 4e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4eb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ee:	6a 01                	push   $0x1
 4f0:	50                   	push   %eax
 4f1:	57                   	push   %edi
 4f2:	e8 fc fd ff ff       	call   2f3 <write>
 4f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4fd:	0f b6 1e             	movzbl (%esi),%ebx
 500:	83 c6 01             	add    $0x1,%esi
 503:	84 db                	test   %bl,%bl
 505:	74 29                	je     530 <printf+0x80>
    c = fmt[i] & 0xff;
 507:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 50a:	85 d2                	test   %edx,%edx
 50c:	74 ca                	je     4d8 <printf+0x28>
      }
    } else if(state == '%'){
 50e:	83 fa 25             	cmp    $0x25,%edx
 511:	75 ea                	jne    4fd <printf+0x4d>
      if(c == 'd'){
 513:	83 f8 25             	cmp    $0x25,%eax
 516:	0f 84 04 01 00 00    	je     620 <printf+0x170>
 51c:	83 e8 63             	sub    $0x63,%eax
 51f:	83 f8 15             	cmp    $0x15,%eax
 522:	77 1c                	ja     540 <printf+0x90>
 524:	ff 24 85 f4 07 00 00 	jmp    *0x7f4(,%eax,4)
 52b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 530:	8d 65 f4             	lea    -0xc(%ebp),%esp
 533:	5b                   	pop    %ebx
 534:	5e                   	pop    %esi
 535:	5f                   	pop    %edi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret
 538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 53f:	00 
  write(fd, &c, 1);
 540:	83 ec 04             	sub    $0x4,%esp
 543:	8d 55 e7             	lea    -0x19(%ebp),%edx
 546:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 54a:	6a 01                	push   $0x1
 54c:	52                   	push   %edx
 54d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 550:	57                   	push   %edi
 551:	e8 9d fd ff ff       	call   2f3 <write>
 556:	83 c4 0c             	add    $0xc,%esp
 559:	88 5d e7             	mov    %bl,-0x19(%ebp)
 55c:	6a 01                	push   $0x1
 55e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 561:	52                   	push   %edx
 562:	57                   	push   %edi
 563:	e8 8b fd ff ff       	call   2f3 <write>
        putc(fd, c);
 568:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56b:	31 d2                	xor    %edx,%edx
 56d:	eb 8e                	jmp    4fd <printf+0x4d>
 56f:	90                   	nop
        printint(fd, *ap, 16, 0);
 570:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 573:	83 ec 0c             	sub    $0xc,%esp
 576:	b9 10 00 00 00       	mov    $0x10,%ecx
 57b:	8b 13                	mov    (%ebx),%edx
 57d:	6a 00                	push   $0x0
 57f:	89 f8                	mov    %edi,%eax
        ap++;
 581:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 584:	e8 87 fe ff ff       	call   410 <printint>
        ap++;
 589:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 58c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58f:	31 d2                	xor    %edx,%edx
 591:	e9 67 ff ff ff       	jmp    4fd <printf+0x4d>
        s = (char*)*ap;
 596:	8b 45 d0             	mov    -0x30(%ebp),%eax
 599:	8b 18                	mov    (%eax),%ebx
        ap++;
 59b:	83 c0 04             	add    $0x4,%eax
 59e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5a1:	85 db                	test   %ebx,%ebx
 5a3:	0f 84 87 00 00 00    	je     630 <printf+0x180>
        while(*s != 0){
 5a9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5ac:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5ae:	84 c0                	test   %al,%al
 5b0:	0f 84 47 ff ff ff    	je     4fd <printf+0x4d>
 5b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5b9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 5bc:	89 de                	mov    %ebx,%esi
 5be:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 5c6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5c9:	6a 01                	push   $0x1
 5cb:	53                   	push   %ebx
 5cc:	57                   	push   %edi
 5cd:	e8 21 fd ff ff       	call   2f3 <write>
        while(*s != 0){
 5d2:	0f b6 06             	movzbl (%esi),%eax
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	84 c0                	test   %al,%al
 5da:	75 e4                	jne    5c0 <printf+0x110>
      state = 0;
 5dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 5df:	31 d2                	xor    %edx,%edx
 5e1:	e9 17 ff ff ff       	jmp    4fd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 5e6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5e9:	83 ec 0c             	sub    $0xc,%esp
 5ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f1:	8b 13                	mov    (%ebx),%edx
 5f3:	6a 01                	push   $0x1
 5f5:	eb 88                	jmp    57f <printf+0xcf>
        putc(fd, *ap);
 5f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5fa:	83 ec 04             	sub    $0x4,%esp
 5fd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 600:	8b 03                	mov    (%ebx),%eax
        ap++;
 602:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 605:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 608:	6a 01                	push   $0x1
 60a:	52                   	push   %edx
 60b:	57                   	push   %edi
 60c:	e8 e2 fc ff ff       	call   2f3 <write>
        ap++;
 611:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 614:	83 c4 10             	add    $0x10,%esp
      state = 0;
 617:	31 d2                	xor    %edx,%edx
 619:	e9 df fe ff ff       	jmp    4fd <printf+0x4d>
 61e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 5d e7             	mov    %bl,-0x19(%ebp)
 626:	8d 55 e7             	lea    -0x19(%ebp),%edx
 629:	6a 01                	push   $0x1
 62b:	e9 31 ff ff ff       	jmp    561 <printf+0xb1>
 630:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 635:	bb eb 07 00 00       	mov    $0x7eb,%ebx
 63a:	e9 77 ff ff ff       	jmp    5b6 <printf+0x106>
 63f:	90                   	nop

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 f8 0a 00 00       	mov    0xaf8,%eax
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 658:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	39 c8                	cmp    %ecx,%eax
 65c:	73 32                	jae    690 <free+0x50>
 65e:	39 d1                	cmp    %edx,%ecx
 660:	72 04                	jb     666 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 662:	39 d0                	cmp    %edx,%eax
 664:	72 32                	jb     698 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 666:	8b 73 fc             	mov    -0x4(%ebx),%esi
 669:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66c:	39 fa                	cmp    %edi,%edx
 66e:	74 30                	je     6a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 670:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 673:	8b 50 04             	mov    0x4(%eax),%edx
 676:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 679:	39 f1                	cmp    %esi,%ecx
 67b:	74 3a                	je     6b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 67d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 67f:	5b                   	pop    %ebx
  freep = p;
 680:	a3 f8 0a 00 00       	mov    %eax,0xaf8
}
 685:	5e                   	pop    %esi
 686:	5f                   	pop    %edi
 687:	5d                   	pop    %ebp
 688:	c3                   	ret
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	39 d0                	cmp    %edx,%eax
 692:	72 04                	jb     698 <free+0x58>
 694:	39 d1                	cmp    %edx,%ecx
 696:	72 ce                	jb     666 <free+0x26>
{
 698:	89 d0                	mov    %edx,%eax
 69a:	eb bc                	jmp    658 <free+0x18>
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6a0:	03 72 04             	add    0x4(%edx),%esi
 6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 12                	mov    (%edx),%edx
 6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b3:	39 f1                	cmp    %esi,%ecx
 6b5:	75 c6                	jne    67d <free+0x3d>
    p->s.size += bp->s.size;
 6b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ba:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    p->s.size += bp->s.size;
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6c5:	89 08                	mov    %ecx,(%eax)
}
 6c7:	5b                   	pop    %ebx
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 15 f8 0a 00 00    	mov    0xaf8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 78 07             	lea    0x7(%eax),%edi
 6e5:	c1 ef 03             	shr    $0x3,%edi
 6e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6eb:	85 d2                	test   %edx,%edx
 6ed:	0f 84 8d 00 00 00    	je     780 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
 6f8:	39 f9                	cmp    %edi,%ecx
 6fa:	73 64                	jae    760 <malloc+0x90>
  if(nu < 4096)
 6fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 701:	39 df                	cmp    %ebx,%edi
 703:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 706:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 70d:	eb 0a                	jmp    719 <malloc+0x49>
 70f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 710:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 712:	8b 48 04             	mov    0x4(%eax),%ecx
 715:	39 f9                	cmp    %edi,%ecx
 717:	73 47                	jae    760 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 719:	89 c2                	mov    %eax,%edx
 71b:	3b 05 f8 0a 00 00    	cmp    0xaf8,%eax
 721:	75 ed                	jne    710 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 723:	83 ec 0c             	sub    $0xc,%esp
 726:	56                   	push   %esi
 727:	e8 2f fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 72c:	83 c4 10             	add    $0x10,%esp
 72f:	83 f8 ff             	cmp    $0xffffffff,%eax
 732:	74 1c                	je     750 <malloc+0x80>
  hp->s.size = nu;
 734:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 737:	83 ec 0c             	sub    $0xc,%esp
 73a:	83 c0 08             	add    $0x8,%eax
 73d:	50                   	push   %eax
 73e:	e8 fd fe ff ff       	call   640 <free>
  return freep;
 743:	8b 15 f8 0a 00 00    	mov    0xaf8,%edx
      if((p = morecore(nunits)) == 0)
 749:	83 c4 10             	add    $0x10,%esp
 74c:	85 d2                	test   %edx,%edx
 74e:	75 c0                	jne    710 <malloc+0x40>
        return 0;
  }
}
 750:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 753:	31 c0                	xor    %eax,%eax
}
 755:	5b                   	pop    %ebx
 756:	5e                   	pop    %esi
 757:	5f                   	pop    %edi
 758:	5d                   	pop    %ebp
 759:	c3                   	ret
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 760:	39 cf                	cmp    %ecx,%edi
 762:	74 4c                	je     7b0 <malloc+0xe0>
        p->s.size -= nunits;
 764:	29 f9                	sub    %edi,%ecx
 766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 76c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 76f:	89 15 f8 0a 00 00    	mov    %edx,0xaf8
}
 775:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 778:	83 c0 08             	add    $0x8,%eax
}
 77b:	5b                   	pop    %ebx
 77c:	5e                   	pop    %esi
 77d:	5f                   	pop    %edi
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 780:	c7 05 f8 0a 00 00 fc 	movl   $0xafc,0xaf8
 787:	0a 00 00 
    base.s.size = 0;
 78a:	b8 fc 0a 00 00       	mov    $0xafc,%eax
    base.s.ptr = freep = prevp = &base;
 78f:	c7 05 fc 0a 00 00 fc 	movl   $0xafc,0xafc
 796:	0a 00 00 
    base.s.size = 0;
 799:	c7 05 00 0b 00 00 00 	movl   $0x0,0xb00
 7a0:	00 00 00 
    if(p->s.size >= nunits){
 7a3:	e9 54 ff ff ff       	jmp    6fc <malloc+0x2c>
 7a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7af:	00 
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 08                	mov    (%eax),%ecx
 7b2:	89 0a                	mov    %ecx,(%edx)
 7b4:	eb b9                	jmp    76f <malloc+0x9f>
