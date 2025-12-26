
_test_duplicate:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    if (argc < 2) {
  11:	83 39 01             	cmpl   $0x1,(%ecx)
int main(int argc, char *argv[]) {
  14:	8b 41 04             	mov    0x4(%ecx),%eax
    if (argc < 2) {
  17:	7e 3b                	jle    54 <main+0x54>
        printf(1, "usage: test_duplicate <filename>\n");
        exit();
    }


    if (make_duplicate_file(argv[1]) < 0) {
  19:	83 ec 0c             	sub    $0xc,%esp
  1c:	ff 70 04             	push   0x4(%eax)
  1f:	e8 3f 03 00 00       	call   363 <make_duplicate_file>
  24:	83 c4 10             	add    $0x10,%esp
  27:	85 c0                	test   %eax,%eax
  29:	78 16                	js     41 <main+0x41>
        printf(1, "Error duplicating file\n");
    } else {
        printf(1, "File duplicated successfully\n");
  2b:	50                   	push   %eax
  2c:	50                   	push   %eax
  2d:	68 b2 07 00 00       	push   $0x7b2
  32:	6a 01                	push   $0x1
  34:	e8 37 04 00 00       	call   470 <printf>
  39:	83 c4 10             	add    $0x10,%esp
    }

    exit();
  3c:	e8 82 02 00 00       	call   2c3 <exit>
        printf(1, "Error duplicating file\n");
  41:	52                   	push   %edx
  42:	52                   	push   %edx
  43:	68 9a 07 00 00       	push   $0x79a
  48:	6a 01                	push   $0x1
  4a:	e8 21 04 00 00       	call   470 <printf>
  4f:	83 c4 10             	add    $0x10,%esp
  52:	eb e8                	jmp    3c <main+0x3c>
        printf(1, "usage: test_duplicate <filename>\n");
  54:	51                   	push   %ecx
  55:	51                   	push   %ecx
  56:	68 78 07 00 00       	push   $0x778
  5b:	6a 01                	push   $0x1
  5d:	e8 0e 04 00 00       	call   470 <printf>
        exit();
  62:	e8 5c 02 00 00       	call   2c3 <exit>
  67:	66 90                	xchg   %ax,%ax
  69:	66 90                	xchg   %ax,%ax
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	31 c0                	xor    %eax,%eax
{
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  87:	83 c0 01             	add    $0x1,%eax
  8a:	84 d2                	test   %dl,%dl
  8c:	75 f2                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  91:	89 c8                	mov    %ecx,%eax
  93:	c9                   	leave
  94:	c3                   	ret
  95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  9c:	00 
  9d:	8d 76 00             	lea    0x0(%esi),%esi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	75 17                	jne    c8 <strcmp+0x28>
  b1:	eb 3a                	jmp    ed <strcmp+0x4d>
  b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  c2:	84 c0                	test   %al,%al
  c4:	74 1a                	je     e0 <strcmp+0x40>
  c6:	89 d9                	mov    %ebx,%ecx
  c8:	0f b6 19             	movzbl (%ecx),%ebx
  cb:	38 c3                	cmp    %al,%bl
  cd:	74 e9                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  cf:	29 d8                	sub    %ebx,%eax
}
  d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d4:	c9                   	leave
  d5:	c3                   	ret
  d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  dd:	00 
  de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
  e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  e4:	31 c0                	xor    %eax,%eax
  e6:	29 d8                	sub    %ebx,%eax
}
  e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  eb:	c9                   	leave
  ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	31 c0                	xor    %eax,%eax
  f2:	eb db                	jmp    cf <strcmp+0x2f>
  f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  fb:	00 
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 3a 00             	cmpb   $0x0,(%edx)
 109:	74 15                	je     120 <strlen+0x20>
 10b:	31 c0                	xor    %eax,%eax
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 117:	89 c1                	mov    %eax,%ecx
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	89 c8                	mov    %ecx,%eax
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret
 11f:	90                   	nop
  for(n = 0; s[n]; n++)
 120:	31 c9                	xor    %ecx,%ecx
}
 122:	5d                   	pop    %ebp
 123:	89 c8                	mov    %ecx,%eax
 125:	c3                   	ret
 126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12d:	00 
 12e:	66 90                	xchg   %ax,%ax

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	8b 7d fc             	mov    -0x4(%ebp),%edi
 145:	89 d0                	mov    %edx,%eax
 147:	c9                   	leave
 148:	c3                   	ret
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 12                	jne    173 <strchr+0x23>
 161:	eb 1d                	jmp    180 <strchr+0x30>
 163:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 16c:	83 c0 01             	add    $0x1,%eax
 16f:	84 d2                	test   %dl,%dl
 171:	74 0d                	je     180 <strchr+0x30>
    if(*s == c)
 173:	38 d1                	cmp    %dl,%cl
 175:	75 f1                	jne    168 <strchr+0x18>
      return (char*)s;
  return 0;
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret
 184:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18b:	00 
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 195:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 198:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 199:	31 db                	xor    %ebx,%ebx
 19b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 19e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1a1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1a4:	7d 3b                	jge    1e1 <gets+0x51>
 1a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ad:	00 
 1ae:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	57                   	push   %edi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 1e 01 00 00       	call   2db <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 1d                	jle    1e1 <gets+0x51>
      break;
      
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 1cf:	3c 0a                	cmp    $0xa,%al
 1d1:	7f 25                	jg     1f8 <gets+0x68>
 1d3:	3c 08                	cmp    $0x8,%al
 1d5:	7f 0c                	jg     1e3 <gets+0x53>
{
 1d7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 1d9:	8d 73 01             	lea    0x1(%ebx),%esi
 1dc:	3b 75 0c             	cmp    0xc(%ebp),%esi
 1df:	7c cf                	jl     1b0 <gets+0x20>
 1e1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5f                   	pop    %edi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret
 1f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	74 e7                	je     1e3 <gets+0x53>
{
 1fc:	89 f3                	mov    %esi,%ebx
 1fe:	eb d9                	jmp    1d9 <gets+0x49>

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 f1 00 00 00       	call   303 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	push   0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f4 00 00 00       	call   31b <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 ba 00 00 00       	call   2eb <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24e:	00 
 24f:	90                   	nop

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 260:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 265:	77 1e                	ja     285 <atoi+0x35>
 267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26e:	00 
 26f:	90                   	nop
    n = n*10 + *s++ - '0';
 270:	83 c2 01             	add    $0x1,%edx
 273:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 276:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 27a:	0f be 02             	movsbl (%edx),%eax
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 288:	89 c8                	mov    %ecx,%eax
 28a:	c9                   	leave
 28b:	c3                   	ret
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	8b 55 08             	mov    0x8(%ebp),%edx
 29a:	56                   	push   %esi
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 363:	b8 17 00 00 00       	mov    $0x17,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <show_process_family>:
SYSCALL(show_process_family)
 36b:	b8 18 00 00 00       	mov    $0x18,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <grep_syscall>:
SYSCALL(grep_syscall)
 37b:	b8 19 00 00 00       	mov    $0x19,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 383:	b8 1a 00 00 00       	mov    $0x1a,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 38b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 393:	b8 1c 00 00 00       	mov    $0x1c,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 39b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 3a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 3ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 3b3:	b8 20 00 00 00       	mov    $0x20,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 3bb:	b8 21 00 00 00       	mov    $0x21,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 3c3:	b8 22 00 00 00       	mov    $0x22,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3d8:	89 d1                	mov    %edx,%ecx
{
 3da:	83 ec 3c             	sub    $0x3c,%esp
 3dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 3e0:	85 d2                	test   %edx,%edx
 3e2:	0f 89 80 00 00 00    	jns    468 <printint+0x98>
 3e8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ec:	74 7a                	je     468 <printint+0x98>
    x = -xx;
 3ee:	f7 d9                	neg    %ecx
    neg = 1;
 3f0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 3f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 3f8:	31 f6                	xor    %esi,%esi
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 400:	89 c8                	mov    %ecx,%eax
 402:	31 d2                	xor    %edx,%edx
 404:	89 f7                	mov    %esi,%edi
 406:	f7 f3                	div    %ebx
 408:	8d 76 01             	lea    0x1(%esi),%esi
 40b:	0f b6 92 30 08 00 00 	movzbl 0x830(%edx),%edx
 412:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 416:	89 ca                	mov    %ecx,%edx
 418:	89 c1                	mov    %eax,%ecx
 41a:	39 da                	cmp    %ebx,%edx
 41c:	73 e2                	jae    400 <printint+0x30>
  if(neg)
 41e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 421:	85 c0                	test   %eax,%eax
 423:	74 07                	je     42c <printint+0x5c>
    buf[i++] = '-';
 425:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 42a:	89 f7                	mov    %esi,%edi
 42c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 42f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 432:	01 df                	add    %ebx,%edi
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 438:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	88 45 d7             	mov    %al,-0x29(%ebp)
 441:	8d 45 d7             	lea    -0x29(%ebp),%eax
 444:	6a 01                	push   $0x1
 446:	50                   	push   %eax
 447:	56                   	push   %esi
 448:	e8 96 fe ff ff       	call   2e3 <write>
  while(--i >= 0)
 44d:	89 f8                	mov    %edi,%eax
 44f:	83 c4 10             	add    $0x10,%esp
 452:	83 ef 01             	sub    $0x1,%edi
 455:	39 c3                	cmp    %eax,%ebx
 457:	75 df                	jne    438 <printint+0x68>
}
 459:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45c:	5b                   	pop    %ebx
 45d:	5e                   	pop    %esi
 45e:	5f                   	pop    %edi
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 468:	31 c0                	xor    %eax,%eax
 46a:	eb 89                	jmp    3f5 <printint+0x25>
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 479:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 47c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 47f:	0f b6 1e             	movzbl (%esi),%ebx
 482:	83 c6 01             	add    $0x1,%esi
 485:	84 db                	test   %bl,%bl
 487:	74 67                	je     4f0 <printf+0x80>
 489:	8d 4d 10             	lea    0x10(%ebp),%ecx
 48c:	31 d2                	xor    %edx,%edx
 48e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 491:	eb 34                	jmp    4c7 <printf+0x57>
 493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 498:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 49b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4a0:	83 f8 25             	cmp    $0x25,%eax
 4a3:	74 18                	je     4bd <printf+0x4d>
  write(fd, &c, 1);
 4a5:	83 ec 04             	sub    $0x4,%esp
 4a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ab:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4ae:	6a 01                	push   $0x1
 4b0:	50                   	push   %eax
 4b1:	57                   	push   %edi
 4b2:	e8 2c fe ff ff       	call   2e3 <write>
 4b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 4ba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4bd:	0f b6 1e             	movzbl (%esi),%ebx
 4c0:	83 c6 01             	add    $0x1,%esi
 4c3:	84 db                	test   %bl,%bl
 4c5:	74 29                	je     4f0 <printf+0x80>
    c = fmt[i] & 0xff;
 4c7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4ca:	85 d2                	test   %edx,%edx
 4cc:	74 ca                	je     498 <printf+0x28>
      }
    } else if(state == '%'){
 4ce:	83 fa 25             	cmp    $0x25,%edx
 4d1:	75 ea                	jne    4bd <printf+0x4d>
      if(c == 'd'){
 4d3:	83 f8 25             	cmp    $0x25,%eax
 4d6:	0f 84 04 01 00 00    	je     5e0 <printf+0x170>
 4dc:	83 e8 63             	sub    $0x63,%eax
 4df:	83 f8 15             	cmp    $0x15,%eax
 4e2:	77 1c                	ja     500 <printf+0x90>
 4e4:	ff 24 85 d8 07 00 00 	jmp    *0x7d8(,%eax,4)
 4eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret
 4f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4ff:	00 
  write(fd, &c, 1);
 500:	83 ec 04             	sub    $0x4,%esp
 503:	8d 55 e7             	lea    -0x19(%ebp),%edx
 506:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 50a:	6a 01                	push   $0x1
 50c:	52                   	push   %edx
 50d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 510:	57                   	push   %edi
 511:	e8 cd fd ff ff       	call   2e3 <write>
 516:	83 c4 0c             	add    $0xc,%esp
 519:	88 5d e7             	mov    %bl,-0x19(%ebp)
 51c:	6a 01                	push   $0x1
 51e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 521:	52                   	push   %edx
 522:	57                   	push   %edi
 523:	e8 bb fd ff ff       	call   2e3 <write>
        putc(fd, c);
 528:	83 c4 10             	add    $0x10,%esp
      state = 0;
 52b:	31 d2                	xor    %edx,%edx
 52d:	eb 8e                	jmp    4bd <printf+0x4d>
 52f:	90                   	nop
        printint(fd, *ap, 16, 0);
 530:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 533:	83 ec 0c             	sub    $0xc,%esp
 536:	b9 10 00 00 00       	mov    $0x10,%ecx
 53b:	8b 13                	mov    (%ebx),%edx
 53d:	6a 00                	push   $0x0
 53f:	89 f8                	mov    %edi,%eax
        ap++;
 541:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 544:	e8 87 fe ff ff       	call   3d0 <printint>
        ap++;
 549:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 54c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54f:	31 d2                	xor    %edx,%edx
 551:	e9 67 ff ff ff       	jmp    4bd <printf+0x4d>
        s = (char*)*ap;
 556:	8b 45 d0             	mov    -0x30(%ebp),%eax
 559:	8b 18                	mov    (%eax),%ebx
        ap++;
 55b:	83 c0 04             	add    $0x4,%eax
 55e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 561:	85 db                	test   %ebx,%ebx
 563:	0f 84 87 00 00 00    	je     5f0 <printf+0x180>
        while(*s != 0){
 569:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 56c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 56e:	84 c0                	test   %al,%al
 570:	0f 84 47 ff ff ff    	je     4bd <printf+0x4d>
 576:	8d 55 e7             	lea    -0x19(%ebp),%edx
 579:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 57c:	89 de                	mov    %ebx,%esi
 57e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 580:	83 ec 04             	sub    $0x4,%esp
 583:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 586:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 589:	6a 01                	push   $0x1
 58b:	53                   	push   %ebx
 58c:	57                   	push   %edi
 58d:	e8 51 fd ff ff       	call   2e3 <write>
        while(*s != 0){
 592:	0f b6 06             	movzbl (%esi),%eax
 595:	83 c4 10             	add    $0x10,%esp
 598:	84 c0                	test   %al,%al
 59a:	75 e4                	jne    580 <printf+0x110>
      state = 0;
 59c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 59f:	31 d2                	xor    %edx,%edx
 5a1:	e9 17 ff ff ff       	jmp    4bd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 5a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5a9:	83 ec 0c             	sub    $0xc,%esp
 5ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5b1:	8b 13                	mov    (%ebx),%edx
 5b3:	6a 01                	push   $0x1
 5b5:	eb 88                	jmp    53f <printf+0xcf>
        putc(fd, *ap);
 5b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 5c0:	8b 03                	mov    (%ebx),%eax
        ap++;
 5c2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 5c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5c8:	6a 01                	push   $0x1
 5ca:	52                   	push   %edx
 5cb:	57                   	push   %edi
 5cc:	e8 12 fd ff ff       	call   2e3 <write>
        ap++;
 5d1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d7:	31 d2                	xor    %edx,%edx
 5d9:	e9 df fe ff ff       	jmp    4bd <printf+0x4d>
 5de:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5e6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5e9:	6a 01                	push   $0x1
 5eb:	e9 31 ff ff ff       	jmp    521 <printf+0xb1>
 5f0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 5f5:	bb d0 07 00 00       	mov    $0x7d0,%ebx
 5fa:	e9 77 ff ff ff       	jmp    576 <printf+0x106>
 5ff:	90                   	nop

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 cc 0a 00 00       	mov    0xacc,%eax
{
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 618:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	39 c8                	cmp    %ecx,%eax
 61c:	73 32                	jae    650 <free+0x50>
 61e:	39 d1                	cmp    %edx,%ecx
 620:	72 04                	jb     626 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 622:	39 d0                	cmp    %edx,%eax
 624:	72 32                	jb     658 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 626:	8b 73 fc             	mov    -0x4(%ebx),%esi
 629:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62c:	39 fa                	cmp    %edi,%edx
 62e:	74 30                	je     660 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 630:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 633:	8b 50 04             	mov    0x4(%eax),%edx
 636:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 639:	39 f1                	cmp    %esi,%ecx
 63b:	74 3a                	je     677 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 63d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 63f:	5b                   	pop    %ebx
  freep = p;
 640:	a3 cc 0a 00 00       	mov    %eax,0xacc
}
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 04                	jb     658 <free+0x58>
 654:	39 d1                	cmp    %edx,%ecx
 656:	72 ce                	jb     626 <free+0x26>
{
 658:	89 d0                	mov    %edx,%eax
 65a:	eb bc                	jmp    618 <free+0x18>
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 660:	03 72 04             	add    0x4(%edx),%esi
 663:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 12                	mov    (%edx),%edx
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 f1                	cmp    %esi,%ecx
 675:	75 c6                	jne    63d <free+0x3d>
    p->s.size += bp->s.size;
 677:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 67a:	a3 cc 0a 00 00       	mov    %eax,0xacc
    p->s.size += bp->s.size;
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 685:	89 08                	mov    %ecx,(%eax)
}
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 69c:	8b 15 cc 0a 00 00    	mov    0xacc,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6ab:	85 d2                	test   %edx,%edx
 6ad:	0f 84 8d 00 00 00    	je     740 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
 6b8:	39 f9                	cmp    %edi,%ecx
 6ba:	73 64                	jae    720 <malloc+0x90>
  if(nu < 4096)
 6bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c1:	39 df                	cmp    %ebx,%edi
 6c3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6c6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6cd:	eb 0a                	jmp    6d9 <malloc+0x49>
 6cf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d2:	8b 48 04             	mov    0x4(%eax),%ecx
 6d5:	39 f9                	cmp    %edi,%ecx
 6d7:	73 47                	jae    720 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d9:	89 c2                	mov    %eax,%edx
 6db:	3b 05 cc 0a 00 00    	cmp    0xacc,%eax
 6e1:	75 ed                	jne    6d0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 6e3:	83 ec 0c             	sub    $0xc,%esp
 6e6:	56                   	push   %esi
 6e7:	e8 5f fc ff ff       	call   34b <sbrk>
  if(p == (char*)-1)
 6ec:	83 c4 10             	add    $0x10,%esp
 6ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f2:	74 1c                	je     710 <malloc+0x80>
  hp->s.size = nu;
 6f4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6f7:	83 ec 0c             	sub    $0xc,%esp
 6fa:	83 c0 08             	add    $0x8,%eax
 6fd:	50                   	push   %eax
 6fe:	e8 fd fe ff ff       	call   600 <free>
  return freep;
 703:	8b 15 cc 0a 00 00    	mov    0xacc,%edx
      if((p = morecore(nunits)) == 0)
 709:	83 c4 10             	add    $0x10,%esp
 70c:	85 d2                	test   %edx,%edx
 70e:	75 c0                	jne    6d0 <malloc+0x40>
        return 0;
  }
}
 710:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 713:	31 c0                	xor    %eax,%eax
}
 715:	5b                   	pop    %ebx
 716:	5e                   	pop    %esi
 717:	5f                   	pop    %edi
 718:	5d                   	pop    %ebp
 719:	c3                   	ret
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 720:	39 cf                	cmp    %ecx,%edi
 722:	74 4c                	je     770 <malloc+0xe0>
        p->s.size -= nunits;
 724:	29 f9                	sub    %edi,%ecx
 726:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 729:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 72c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 72f:	89 15 cc 0a 00 00    	mov    %edx,0xacc
}
 735:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 738:	83 c0 08             	add    $0x8,%eax
}
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 740:	c7 05 cc 0a 00 00 d0 	movl   $0xad0,0xacc
 747:	0a 00 00 
    base.s.size = 0;
 74a:	b8 d0 0a 00 00       	mov    $0xad0,%eax
    base.s.ptr = freep = prevp = &base;
 74f:	c7 05 d0 0a 00 00 d0 	movl   $0xad0,0xad0
 756:	0a 00 00 
    base.s.size = 0;
 759:	c7 05 d4 0a 00 00 00 	movl   $0x0,0xad4
 760:	00 00 00 
    if(p->s.size >= nunits){
 763:	e9 54 ff ff ff       	jmp    6bc <malloc+0x2c>
 768:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 76f:	00 
        prevp->s.ptr = p->s.ptr;
 770:	8b 08                	mov    (%eax),%ecx
 772:	89 0a                	mov    %ecx,(%edx)
 774:	eb b9                	jmp    72f <malloc+0x9f>
