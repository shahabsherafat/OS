
_rwtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  exit();
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
  int i;
  int pid;

  // Spawn multiple readers first (they should overlap).
  for(i = 0; i < 4; i++){
   e:	31 db                	xor    %ebx,%ebx
{
  10:	51                   	push   %ecx
    pid = fork();
  11:	e8 25 03 00 00       	call   33b <fork>
    if(pid == 0)
  16:	85 c0                	test   %eax,%eax
  18:	74 3f                	je     59 <main+0x59>
  for(i = 0; i < 4; i++){
  1a:	83 c3 01             	add    $0x1,%ebx
  1d:	83 fb 04             	cmp    $0x4,%ebx
  20:	75 ef                	jne    11 <main+0x11>
      reader(i);
  }

  // Spawn writers (they should enter only when no readers/writers are inside).
  for(i = 0; i < 2; i++){
    pid = fork();
  22:	e8 14 03 00 00       	call   33b <fork>
  27:	89 c3                	mov    %eax,%ebx
    if(pid == 0)
  29:	85 c0                	test   %eax,%eax
  2b:	74 75                	je     a2 <main+0xa2>
    pid = fork();
  2d:	e8 09 03 00 00       	call   33b <fork>
    if(pid == 0)
  32:	85 c0                	test   %eax,%eax
  34:	74 67                	je     9d <main+0x9d>
      writer(i);
  }

  // Wait all
  for(i = 0; i < 6; i++)
    wait();
  36:	e8 10 03 00 00       	call   34b <wait>
  3b:	e8 0b 03 00 00       	call   34b <wait>
  40:	e8 06 03 00 00       	call   34b <wait>
  45:	e8 01 03 00 00       	call   34b <wait>
  4a:	e8 fc 02 00 00       	call   34b <wait>
  4f:	e8 f7 02 00 00       	call   34b <wait>

  exit();
  54:	e8 ea 02 00 00       	call   343 <exit>
  rwlock_rlock();
  59:	e8 bd 03 00 00       	call   41b <rwlock_rlock>
  printf(1, "READER %d (pid=%d): entered critical section\n", id, getpid());
  5e:	e8 60 03 00 00       	call   3c3 <getpid>
  63:	50                   	push   %eax
  64:	53                   	push   %ebx
  65:	68 08 08 00 00       	push   $0x808
  6a:	6a 01                	push   $0x1
  6c:	e8 8f 04 00 00       	call   500 <printf>
  sleep(80);  // hold lock long enough so concurrency is visible
  71:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  78:	e8 56 03 00 00       	call   3d3 <sleep>
  printf(1, "READER %d (pid=%d): leaving critical section\n", id, getpid());
  7d:	e8 41 03 00 00       	call   3c3 <getpid>
  82:	50                   	push   %eax
  83:	53                   	push   %ebx
  84:	68 38 08 00 00       	push   $0x838
  89:	6a 01                	push   $0x1
  8b:	e8 70 04 00 00       	call   500 <printf>
  rwlock_runlock();
  90:	83 c4 20             	add    $0x20,%esp
  93:	e8 8b 03 00 00       	call   423 <rwlock_runlock>
  exit();
  98:	e8 a6 02 00 00       	call   343 <exit>
  for(i = 0; i < 2; i++){
  9d:	bb 01 00 00 00       	mov    $0x1,%ebx
  rwlock_wlock();
  a2:	e8 84 03 00 00       	call   42b <rwlock_wlock>
  printf(1, "WRITER %d (pid=%d): entered critical section (exclusive)\n", id, getpid());
  a7:	e8 17 03 00 00       	call   3c3 <getpid>
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 68 08 00 00       	push   $0x868
  b3:	6a 01                	push   $0x1
  b5:	e8 46 04 00 00       	call   500 <printf>
  sleep(120);
  ba:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  c1:	e8 0d 03 00 00       	call   3d3 <sleep>
  printf(1, "WRITER %d (pid=%d): leaving critical section\n", id, getpid());
  c6:	e8 f8 02 00 00       	call   3c3 <getpid>
  cb:	50                   	push   %eax
  cc:	53                   	push   %ebx
  cd:	68 a4 08 00 00       	push   $0x8a4
  d2:	6a 01                	push   $0x1
  d4:	e8 27 04 00 00       	call   500 <printf>
  rwlock_wunlock();
  d9:	83 c4 20             	add    $0x20,%esp
  dc:	e8 52 03 00 00       	call   433 <rwlock_wunlock>
  exit();
  e1:	e8 5d 02 00 00       	call   343 <exit>
  e6:	66 90                	xchg   %ax,%ax
  e8:	66 90                	xchg   %ax,%ax
  ea:	66 90                	xchg   %ax,%ax
  ec:	66 90                	xchg   %ax,%ax
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f1:	31 c0                	xor    %eax,%eax
{
  f3:	89 e5                	mov    %esp,%ebp
  f5:	53                   	push   %ebx
  f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 100:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 104:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 107:	83 c0 01             	add    $0x1,%eax
 10a:	84 d2                	test   %dl,%dl
 10c:	75 f2                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 10e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 111:	89 c8                	mov    %ecx,%eax
 113:	c9                   	leave
 114:	c3                   	ret
 115:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11c:	00 
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	84 c0                	test   %al,%al
 12f:	75 17                	jne    148 <strcmp+0x28>
 131:	eb 3a                	jmp    16d <strcmp+0x4d>
 133:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 138:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 13c:	83 c2 01             	add    $0x1,%edx
 13f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 142:	84 c0                	test   %al,%al
 144:	74 1a                	je     160 <strcmp+0x40>
 146:	89 d9                	mov    %ebx,%ecx
 148:	0f b6 19             	movzbl (%ecx),%ebx
 14b:	38 c3                	cmp    %al,%bl
 14d:	74 e9                	je     138 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 14f:	29 d8                	sub    %ebx,%eax
}
 151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 154:	c9                   	leave
 155:	c3                   	ret
 156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 15d:	00 
 15e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 160:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 164:	31 c0                	xor    %eax,%eax
 166:	29 d8                	sub    %ebx,%eax
}
 168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 16b:	c9                   	leave
 16c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 16d:	0f b6 19             	movzbl (%ecx),%ebx
 170:	31 c0                	xor    %eax,%eax
 172:	eb db                	jmp    14f <strcmp+0x2f>
 174:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 17b:	00 
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000180 <strlen>:

uint
strlen(const char *s)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 186:	80 3a 00             	cmpb   $0x0,(%edx)
 189:	74 15                	je     1a0 <strlen+0x20>
 18b:	31 c0                	xor    %eax,%eax
 18d:	8d 76 00             	lea    0x0(%esi),%esi
 190:	83 c0 01             	add    $0x1,%eax
 193:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 197:	89 c1                	mov    %eax,%ecx
 199:	75 f5                	jne    190 <strlen+0x10>
    ;
  return n;
}
 19b:	89 c8                	mov    %ecx,%eax
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret
 19f:	90                   	nop
  for(n = 0; s[n]; n++)
 1a0:	31 c9                	xor    %ecx,%ecx
}
 1a2:	5d                   	pop    %ebp
 1a3:	89 c8                	mov    %ecx,%eax
 1a5:	c3                   	ret
 1a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ad:	00 
 1ae:	66 90                	xchg   %ax,%ax

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1c5:	89 d0                	mov    %edx,%eax
 1c7:	c9                   	leave
 1c8:	c3                   	ret
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 12                	jne    1f3 <strchr+0x23>
 1e1:	eb 1d                	jmp    200 <strchr+0x30>
 1e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	84 d2                	test   %dl,%dl
 1f1:	74 0d                	je     200 <strchr+0x30>
    if(*s == c)
 1f3:	38 d1                	cmp    %dl,%cl
 1f5:	75 f1                	jne    1e8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 200:	31 c0                	xor    %eax,%eax
}
 202:	5d                   	pop    %ebp
 203:	c3                   	ret
 204:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20b:	00 
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 215:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 218:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 219:	31 db                	xor    %ebx,%ebx
 21b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 21e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 221:	3b 75 0c             	cmp    0xc(%ebp),%esi
 224:	7d 3b                	jge    261 <gets+0x51>
 226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22d:	00 
 22e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 230:	83 ec 04             	sub    $0x4,%esp
 233:	6a 01                	push   $0x1
 235:	57                   	push   %edi
 236:	6a 00                	push   $0x0
 238:	e8 1e 01 00 00       	call   35b <read>
    if(cc < 1)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	7e 1d                	jle    261 <gets+0x51>
      break;
      
    buf[i++] = c;
 244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 24f:	3c 0a                	cmp    $0xa,%al
 251:	7f 25                	jg     278 <gets+0x68>
 253:	3c 08                	cmp    $0x8,%al
 255:	7f 0c                	jg     263 <gets+0x53>
{
 257:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 259:	8d 73 01             	lea    0x1(%ebx),%esi
 25c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 25f:	7c cf                	jl     230 <gets+0x20>
 261:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 26a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26d:	5b                   	pop    %ebx
 26e:	5e                   	pop    %esi
 26f:	5f                   	pop    %edi
 270:	5d                   	pop    %ebp
 271:	c3                   	ret
 272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 e7                	je     263 <gets+0x53>
{
 27c:	89 f3                	mov    %esi,%ebx
 27e:	eb d9                	jmp    259 <gets+0x49>

00000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	push   0x8(%ebp)
 28d:	e8 f1 00 00 00       	call   383 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	push   0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f4 00 00 00       	call   39b <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 ba 00 00 00       	call   36b <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ce:	00 
 2cf:	90                   	nop

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 02             	movsbl (%edx),%eax
 2da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2e5:	77 1e                	ja     305 <atoi+0x35>
 2e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ee:	00 
 2ef:	90                   	nop
    n = n*10 + *s++ - '0';
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2fa:	0f be 02             	movsbl (%edx),%eax
 2fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 308:	89 c8                	mov    %ecx,%eax
 30a:	c9                   	leave
 30b:	c3                   	ret
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	8b 45 10             	mov    0x10(%ebp),%eax
 317:	8b 55 08             	mov    0x8(%ebp),%edx
 31a:	56                   	push   %esi
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 c0                	test   %eax,%eax
 320:	7e 13                	jle    335 <memmove+0x25>
 322:	01 d0                	add    %edx,%eax
  dst = vdst;
 324:	89 d7                	mov    %edx,%edi
 326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32d:	00 
 32e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 330:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 331:	39 f8                	cmp    %edi,%eax
 333:	75 fb                	jne    330 <memmove+0x20>
  return vdst;
}
 335:	5e                   	pop    %esi
 336:	89 d0                	mov    %edx,%eax
 338:	5f                   	pop    %edi
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret

0000033b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33b:	b8 01 00 00 00       	mov    $0x1,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret

00000343 <exit>:
SYSCALL(exit)
 343:	b8 02 00 00 00       	mov    $0x2,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret

0000034b <wait>:
SYSCALL(wait)
 34b:	b8 03 00 00 00       	mov    $0x3,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <pipe>:
SYSCALL(pipe)
 353:	b8 04 00 00 00       	mov    $0x4,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <read>:
SYSCALL(read)
 35b:	b8 05 00 00 00       	mov    $0x5,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <write>:
SYSCALL(write)
 363:	b8 10 00 00 00       	mov    $0x10,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <close>:
SYSCALL(close)
 36b:	b8 15 00 00 00       	mov    $0x15,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <kill>:
SYSCALL(kill)
 373:	b8 06 00 00 00       	mov    $0x6,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <exec>:
SYSCALL(exec)
 37b:	b8 07 00 00 00       	mov    $0x7,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <open>:
SYSCALL(open)
 383:	b8 0f 00 00 00       	mov    $0xf,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <mknod>:
SYSCALL(mknod)
 38b:	b8 11 00 00 00       	mov    $0x11,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <unlink>:
SYSCALL(unlink)
 393:	b8 12 00 00 00       	mov    $0x12,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <fstat>:
SYSCALL(fstat)
 39b:	b8 08 00 00 00       	mov    $0x8,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <link>:
SYSCALL(link)
 3a3:	b8 13 00 00 00       	mov    $0x13,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <mkdir>:
SYSCALL(mkdir)
 3ab:	b8 14 00 00 00       	mov    $0x14,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <chdir>:
SYSCALL(chdir)
 3b3:	b8 09 00 00 00       	mov    $0x9,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <dup>:
SYSCALL(dup)
 3bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <getpid>:
SYSCALL(getpid)
 3c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <sbrk>:
SYSCALL(sbrk)
 3cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <sleep>:
SYSCALL(sleep)
 3d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <uptime>:
SYSCALL(uptime)
 3db:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 3e3:	b8 17 00 00 00       	mov    $0x17,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <show_process_family>:
SYSCALL(show_process_family)
 3eb:	b8 18 00 00 00       	mov    $0x18,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 3f3:	b8 16 00 00 00       	mov    $0x16,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <grep_syscall>:
SYSCALL(grep_syscall)
 3fb:	b8 19 00 00 00       	mov    $0x19,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 403:	b8 1a 00 00 00       	mov    $0x1a,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 40b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 413:	b8 1c 00 00 00       	mov    $0x1c,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 41b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 423:	b8 1e 00 00 00       	mov    $0x1e,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 42b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 433:	b8 20 00 00 00       	mov    $0x20,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 43b:	b8 21 00 00 00       	mov    $0x21,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <release_plock_sys>:
SYSCALL(release_plock_sys)
 443:	b8 22 00 00 00       	mov    $0x22,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <getlockstat>:

SYSCALL(getlockstat)
 44b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret
 453:	66 90                	xchg   %ax,%ax
 455:	66 90                	xchg   %ax,%ax
 457:	66 90                	xchg   %ax,%ax
 459:	66 90                	xchg   %ax,%ax
 45b:	66 90                	xchg   %ax,%ax
 45d:	66 90                	xchg   %ax,%ax
 45f:	90                   	nop

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 468:	89 d1                	mov    %edx,%ecx
{
 46a:	83 ec 3c             	sub    $0x3c,%esp
 46d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 470:	85 d2                	test   %edx,%edx
 472:	0f 89 80 00 00 00    	jns    4f8 <printint+0x98>
 478:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 47c:	74 7a                	je     4f8 <printint+0x98>
    x = -xx;
 47e:	f7 d9                	neg    %ecx
    neg = 1;
 480:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 485:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 488:	31 f6                	xor    %esi,%esi
 48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 490:	89 c8                	mov    %ecx,%eax
 492:	31 d2                	xor    %edx,%edx
 494:	89 f7                	mov    %esi,%edi
 496:	f7 f3                	div    %ebx
 498:	8d 76 01             	lea    0x1(%esi),%esi
 49b:	0f b6 92 34 09 00 00 	movzbl 0x934(%edx),%edx
 4a2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4a6:	89 ca                	mov    %ecx,%edx
 4a8:	89 c1                	mov    %eax,%ecx
 4aa:	39 da                	cmp    %ebx,%edx
 4ac:	73 e2                	jae    490 <printint+0x30>
  if(neg)
 4ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4b1:	85 c0                	test   %eax,%eax
 4b3:	74 07                	je     4bc <printint+0x5c>
    buf[i++] = '-';
 4b5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 4ba:	89 f7                	mov    %esi,%edi
 4bc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 4bf:	8b 75 c0             	mov    -0x40(%ebp),%esi
 4c2:	01 df                	add    %ebx,%edi
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 4c8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	88 45 d7             	mov    %al,-0x29(%ebp)
 4d1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 4d4:	6a 01                	push   $0x1
 4d6:	50                   	push   %eax
 4d7:	56                   	push   %esi
 4d8:	e8 86 fe ff ff       	call   363 <write>
  while(--i >= 0)
 4dd:	89 f8                	mov    %edi,%eax
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	83 ef 01             	sub    $0x1,%edi
 4e5:	39 c3                	cmp    %eax,%ebx
 4e7:	75 df                	jne    4c8 <printint+0x68>
}
 4e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ec:	5b                   	pop    %ebx
 4ed:	5e                   	pop    %esi
 4ee:	5f                   	pop    %edi
 4ef:	5d                   	pop    %ebp
 4f0:	c3                   	ret
 4f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4f8:	31 c0                	xor    %eax,%eax
 4fa:	eb 89                	jmp    485 <printint+0x25>
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 509:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 50c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 50f:	0f b6 1e             	movzbl (%esi),%ebx
 512:	83 c6 01             	add    $0x1,%esi
 515:	84 db                	test   %bl,%bl
 517:	74 67                	je     580 <printf+0x80>
 519:	8d 4d 10             	lea    0x10(%ebp),%ecx
 51c:	31 d2                	xor    %edx,%edx
 51e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 521:	eb 34                	jmp    557 <printf+0x57>
 523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 528:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 52b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 530:	83 f8 25             	cmp    $0x25,%eax
 533:	74 18                	je     54d <printf+0x4d>
  write(fd, &c, 1);
 535:	83 ec 04             	sub    $0x4,%esp
 538:	8d 45 e7             	lea    -0x19(%ebp),%eax
 53b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 53e:	6a 01                	push   $0x1
 540:	50                   	push   %eax
 541:	57                   	push   %edi
 542:	e8 1c fe ff ff       	call   363 <write>
 547:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 54a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 54d:	0f b6 1e             	movzbl (%esi),%ebx
 550:	83 c6 01             	add    $0x1,%esi
 553:	84 db                	test   %bl,%bl
 555:	74 29                	je     580 <printf+0x80>
    c = fmt[i] & 0xff;
 557:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 55a:	85 d2                	test   %edx,%edx
 55c:	74 ca                	je     528 <printf+0x28>
      }
    } else if(state == '%'){
 55e:	83 fa 25             	cmp    $0x25,%edx
 561:	75 ea                	jne    54d <printf+0x4d>
      if(c == 'd'){
 563:	83 f8 25             	cmp    $0x25,%eax
 566:	0f 84 04 01 00 00    	je     670 <printf+0x170>
 56c:	83 e8 63             	sub    $0x63,%eax
 56f:	83 f8 15             	cmp    $0x15,%eax
 572:	77 1c                	ja     590 <printf+0x90>
 574:	ff 24 85 dc 08 00 00 	jmp    *0x8dc(,%eax,4)
 57b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 580:	8d 65 f4             	lea    -0xc(%ebp),%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret
 588:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 58f:	00 
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	8d 55 e7             	lea    -0x19(%ebp),%edx
 596:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 59a:	6a 01                	push   $0x1
 59c:	52                   	push   %edx
 59d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5a0:	57                   	push   %edi
 5a1:	e8 bd fd ff ff       	call   363 <write>
 5a6:	83 c4 0c             	add    $0xc,%esp
 5a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ac:	6a 01                	push   $0x1
 5ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5b1:	52                   	push   %edx
 5b2:	57                   	push   %edi
 5b3:	e8 ab fd ff ff       	call   363 <write>
        putc(fd, c);
 5b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bb:	31 d2                	xor    %edx,%edx
 5bd:	eb 8e                	jmp    54d <printf+0x4d>
 5bf:	90                   	nop
        printint(fd, *ap, 16, 0);
 5c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5c3:	83 ec 0c             	sub    $0xc,%esp
 5c6:	b9 10 00 00 00       	mov    $0x10,%ecx
 5cb:	8b 13                	mov    (%ebx),%edx
 5cd:	6a 00                	push   $0x0
 5cf:	89 f8                	mov    %edi,%eax
        ap++;
 5d1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 5d4:	e8 87 fe ff ff       	call   460 <printint>
        ap++;
 5d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5df:	31 d2                	xor    %edx,%edx
 5e1:	e9 67 ff ff ff       	jmp    54d <printf+0x4d>
        s = (char*)*ap;
 5e6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5e9:	8b 18                	mov    (%eax),%ebx
        ap++;
 5eb:	83 c0 04             	add    $0x4,%eax
 5ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5f1:	85 db                	test   %ebx,%ebx
 5f3:	0f 84 87 00 00 00    	je     680 <printf+0x180>
        while(*s != 0){
 5f9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 5fc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 5fe:	84 c0                	test   %al,%al
 600:	0f 84 47 ff ff ff    	je     54d <printf+0x4d>
 606:	8d 55 e7             	lea    -0x19(%ebp),%edx
 609:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 60c:	89 de                	mov    %ebx,%esi
 60e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 616:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 619:	6a 01                	push   $0x1
 61b:	53                   	push   %ebx
 61c:	57                   	push   %edi
 61d:	e8 41 fd ff ff       	call   363 <write>
        while(*s != 0){
 622:	0f b6 06             	movzbl (%esi),%eax
 625:	83 c4 10             	add    $0x10,%esp
 628:	84 c0                	test   %al,%al
 62a:	75 e4                	jne    610 <printf+0x110>
      state = 0;
 62c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 17 ff ff ff       	jmp    54d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 636:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 639:	83 ec 0c             	sub    $0xc,%esp
 63c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 641:	8b 13                	mov    (%ebx),%edx
 643:	6a 01                	push   $0x1
 645:	eb 88                	jmp    5cf <printf+0xcf>
        putc(fd, *ap);
 647:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 64a:	83 ec 04             	sub    $0x4,%esp
 64d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 650:	8b 03                	mov    (%ebx),%eax
        ap++;
 652:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 655:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 658:	6a 01                	push   $0x1
 65a:	52                   	push   %edx
 65b:	57                   	push   %edi
 65c:	e8 02 fd ff ff       	call   363 <write>
        ap++;
 661:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 664:	83 c4 10             	add    $0x10,%esp
      state = 0;
 667:	31 d2                	xor    %edx,%edx
 669:	e9 df fe ff ff       	jmp    54d <printf+0x4d>
 66e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
 673:	88 5d e7             	mov    %bl,-0x19(%ebp)
 676:	8d 55 e7             	lea    -0x19(%ebp),%edx
 679:	6a 01                	push   $0x1
 67b:	e9 31 ff ff ff       	jmp    5b1 <printf+0xb1>
 680:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 685:	bb d2 08 00 00       	mov    $0x8d2,%ebx
 68a:	e9 77 ff ff ff       	jmp    606 <printf+0x106>
 68f:	90                   	nop

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	a1 d4 0b 00 00       	mov    0xbd4,%eax
{
 696:	89 e5                	mov    %esp,%ebp
 698:	57                   	push   %edi
 699:	56                   	push   %esi
 69a:	53                   	push   %ebx
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 69e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6aa:	39 c8                	cmp    %ecx,%eax
 6ac:	73 32                	jae    6e0 <free+0x50>
 6ae:	39 d1                	cmp    %edx,%ecx
 6b0:	72 04                	jb     6b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	39 d0                	cmp    %edx,%eax
 6b4:	72 32                	jb     6e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6bc:	39 fa                	cmp    %edi,%edx
 6be:	74 30                	je     6f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c3:	8b 50 04             	mov    0x4(%eax),%edx
 6c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6c9:	39 f1                	cmp    %esi,%ecx
 6cb:	74 3a                	je     707 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6cd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6cf:	5b                   	pop    %ebx
  freep = p;
 6d0:	a3 d4 0b 00 00       	mov    %eax,0xbd4
}
 6d5:	5e                   	pop    %esi
 6d6:	5f                   	pop    %edi
 6d7:	5d                   	pop    %ebp
 6d8:	c3                   	ret
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	39 d0                	cmp    %edx,%eax
 6e2:	72 04                	jb     6e8 <free+0x58>
 6e4:	39 d1                	cmp    %edx,%ecx
 6e6:	72 ce                	jb     6b6 <free+0x26>
{
 6e8:	89 d0                	mov    %edx,%eax
 6ea:	eb bc                	jmp    6a8 <free+0x18>
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6f0:	03 72 04             	add    0x4(%edx),%esi
 6f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	8b 10                	mov    (%eax),%edx
 6f8:	8b 12                	mov    (%edx),%edx
 6fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6fd:	8b 50 04             	mov    0x4(%eax),%edx
 700:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 703:	39 f1                	cmp    %esi,%ecx
 705:	75 c6                	jne    6cd <free+0x3d>
    p->s.size += bp->s.size;
 707:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 70a:	a3 d4 0b 00 00       	mov    %eax,0xbd4
    p->s.size += bp->s.size;
 70f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 712:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 715:	89 08                	mov    %ecx,(%eax)
}
 717:	5b                   	pop    %ebx
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret
 71c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 72c:	8b 15 d4 0b 00 00    	mov    0xbd4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	8d 78 07             	lea    0x7(%eax),%edi
 735:	c1 ef 03             	shr    $0x3,%edi
 738:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 73b:	85 d2                	test   %edx,%edx
 73d:	0f 84 8d 00 00 00    	je     7d0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 743:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 745:	8b 48 04             	mov    0x4(%eax),%ecx
 748:	39 f9                	cmp    %edi,%ecx
 74a:	73 64                	jae    7b0 <malloc+0x90>
  if(nu < 4096)
 74c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 751:	39 df                	cmp    %ebx,%edi
 753:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 756:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 75d:	eb 0a                	jmp    769 <malloc+0x49>
 75f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 762:	8b 48 04             	mov    0x4(%eax),%ecx
 765:	39 f9                	cmp    %edi,%ecx
 767:	73 47                	jae    7b0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 769:	89 c2                	mov    %eax,%edx
 76b:	3b 05 d4 0b 00 00    	cmp    0xbd4,%eax
 771:	75 ed                	jne    760 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	56                   	push   %esi
 777:	e8 4f fc ff ff       	call   3cb <sbrk>
  if(p == (char*)-1)
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	83 f8 ff             	cmp    $0xffffffff,%eax
 782:	74 1c                	je     7a0 <malloc+0x80>
  hp->s.size = nu;
 784:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	50                   	push   %eax
 78e:	e8 fd fe ff ff       	call   690 <free>
  return freep;
 793:	8b 15 d4 0b 00 00    	mov    0xbd4,%edx
      if((p = morecore(nunits)) == 0)
 799:	83 c4 10             	add    $0x10,%esp
 79c:	85 d2                	test   %edx,%edx
 79e:	75 c0                	jne    760 <malloc+0x40>
        return 0;
  }
}
 7a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7a3:	31 c0                	xor    %eax,%eax
}
 7a5:	5b                   	pop    %ebx
 7a6:	5e                   	pop    %esi
 7a7:	5f                   	pop    %edi
 7a8:	5d                   	pop    %ebp
 7a9:	c3                   	ret
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7b0:	39 cf                	cmp    %ecx,%edi
 7b2:	74 4c                	je     800 <malloc+0xe0>
        p->s.size -= nunits;
 7b4:	29 f9                	sub    %edi,%ecx
 7b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7bc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7bf:	89 15 d4 0b 00 00    	mov    %edx,0xbd4
}
 7c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7c8:	83 c0 08             	add    $0x8,%eax
}
 7cb:	5b                   	pop    %ebx
 7cc:	5e                   	pop    %esi
 7cd:	5f                   	pop    %edi
 7ce:	5d                   	pop    %ebp
 7cf:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 05 d4 0b 00 00 d8 	movl   $0xbd8,0xbd4
 7d7:	0b 00 00 
    base.s.size = 0;
 7da:	b8 d8 0b 00 00       	mov    $0xbd8,%eax
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 d8 0b 00 00 d8 	movl   $0xbd8,0xbd8
 7e6:	0b 00 00 
    base.s.size = 0;
 7e9:	c7 05 dc 0b 00 00 00 	movl   $0x0,0xbdc
 7f0:	00 00 00 
    if(p->s.size >= nunits){
 7f3:	e9 54 ff ff ff       	jmp    74c <malloc+0x2c>
 7f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7ff:	00 
        prevp->s.ptr = p->s.ptr;
 800:	8b 08                	mov    (%eax),%ecx
 802:	89 0a                	mov    %ecx,(%edx)
 804:	eb b9                	jmp    7bf <malloc+0x9f>
