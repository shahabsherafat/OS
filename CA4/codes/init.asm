
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 08 08 00 00       	push   $0x808
  19:	e8 75 03 00 00       	call   393 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 a7 00 00 00    	js     d0 <main+0xd0>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 98 03 00 00       	call   3cb <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 8c 03 00 00       	call   3cb <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 10 08 00 00       	push   $0x810
  50:	6a 01                	push   $0x1
  52:	e8 a9 04 00 00       	call   500 <printf>
    printf(1,"Group members:\nMatin Nourian\nYasaman Amou Jafary\nMohammad Shahab Sherafat\n");
  57:	58                   	pop    %eax
  58:	5a                   	pop    %edx
  59:	68 60 08 00 00       	push   $0x860
  5e:	6a 01                	push   $0x1
  60:	e8 9b 04 00 00       	call   500 <printf>
    pid = fork();
  65:	e8 e1 02 00 00       	call   34b <fork>
    if(pid < 0){
  6a:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  6d:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  6f:	85 c0                	test   %eax,%eax
  71:	78 26                	js     99 <main+0x99>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  73:	74 37                	je     ac <main+0xac>
  75:	8d 76 00             	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  78:	e8 de 02 00 00       	call   35b <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	78 c7                	js     48 <main+0x48>
  81:	39 c3                	cmp    %eax,%ebx
  83:	74 c3                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  85:	83 ec 08             	sub    $0x8,%esp
  88:	68 4f 08 00 00       	push   $0x84f
  8d:	6a 01                	push   $0x1
  8f:	e8 6c 04 00 00       	call   500 <printf>
  94:	83 c4 10             	add    $0x10,%esp
  97:	eb df                	jmp    78 <main+0x78>
      printf(1, "init: fork failed\n");
  99:	53                   	push   %ebx
  9a:	53                   	push   %ebx
  9b:	68 23 08 00 00       	push   $0x823
  a0:	6a 01                	push   $0x1
  a2:	e8 59 04 00 00       	call   500 <printf>
      exit();
  a7:	e8 a7 02 00 00       	call   353 <exit>
      exec("sh", argv);
  ac:	50                   	push   %eax
  ad:	50                   	push   %eax
  ae:	68 a4 0b 00 00       	push   $0xba4
  b3:	68 36 08 00 00       	push   $0x836
  b8:	e8 ce 02 00 00       	call   38b <exec>
      printf(1, "init: exec sh failed\n");
  bd:	5a                   	pop    %edx
  be:	59                   	pop    %ecx
  bf:	68 39 08 00 00       	push   $0x839
  c4:	6a 01                	push   $0x1
  c6:	e8 35 04 00 00       	call   500 <printf>
      exit();
  cb:	e8 83 02 00 00       	call   353 <exit>
    mknod("console", 1, 1);
  d0:	51                   	push   %ecx
  d1:	6a 01                	push   $0x1
  d3:	6a 01                	push   $0x1
  d5:	68 08 08 00 00       	push   $0x808
  da:	e8 bc 02 00 00       	call   39b <mknod>
    open("console", O_RDWR);
  df:	5b                   	pop    %ebx
  e0:	58                   	pop    %eax
  e1:	6a 02                	push   $0x2
  e3:	68 08 08 00 00       	push   $0x808
  e8:	e8 a6 02 00 00       	call   393 <open>
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	e9 34 ff ff ff       	jmp    29 <main+0x29>
  f5:	66 90                	xchg   %ax,%ax
  f7:	66 90                	xchg   %ax,%ax
  f9:	66 90                	xchg   %ax,%ax
  fb:	66 90                	xchg   %ax,%ax
  fd:	66 90                	xchg   %ax,%ax
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 101:	31 c0                	xor    %eax,%eax
{
 103:	89 e5                	mov    %esp,%ebp
 105:	53                   	push   %ebx
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 110:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 114:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strcpy+0x10>
    ;
  return os;
}
 11e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 121:	89 c8                	mov    %ecx,%eax
 123:	c9                   	leave
 124:	c3                   	ret
 125:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 12c:	00 
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 55 08             	mov    0x8(%ebp),%edx
 137:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 13a:	0f b6 02             	movzbl (%edx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 17                	jne    158 <strcmp+0x28>
 141:	eb 3a                	jmp    17d <strcmp+0x4d>
 143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 148:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 14c:	83 c2 01             	add    $0x1,%edx
 14f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 152:	84 c0                	test   %al,%al
 154:	74 1a                	je     170 <strcmp+0x40>
 156:	89 d9                	mov    %ebx,%ecx
 158:	0f b6 19             	movzbl (%ecx),%ebx
 15b:	38 c3                	cmp    %al,%bl
 15d:	74 e9                	je     148 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 15f:	29 d8                	sub    %ebx,%eax
}
 161:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 164:	c9                   	leave
 165:	c3                   	ret
 166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 16d:	00 
 16e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 170:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 174:	31 c0                	xor    %eax,%eax
 176:	29 d8                	sub    %ebx,%eax
}
 178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 17b:	c9                   	leave
 17c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 17d:	0f b6 19             	movzbl (%ecx),%ebx
 180:	31 c0                	xor    %eax,%eax
 182:	eb db                	jmp    15f <strcmp+0x2f>
 184:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 18b:	00 
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000190 <strlen>:

uint
strlen(const char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 3a 00             	cmpb   $0x0,(%edx)
 199:	74 15                	je     1b0 <strlen+0x20>
 19b:	31 c0                	xor    %eax,%eax
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c0 01             	add    $0x1,%eax
 1a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1a7:	89 c1                	mov    %eax,%ecx
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	89 c8                	mov    %ecx,%eax
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret
 1af:	90                   	nop
  for(n = 0; s[n]; n++)
 1b0:	31 c9                	xor    %ecx,%ecx
}
 1b2:	5d                   	pop    %ebp
 1b3:	89 c8                	mov    %ecx,%eax
 1b5:	c3                   	ret
 1b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bd:	00 
 1be:	66 90                	xchg   %ax,%ax

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	c9                   	leave
 1d8:	c3                   	ret
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 12                	jne    203 <strchr+0x23>
 1f1:	eb 1d                	jmp    210 <strchr+0x30>
 1f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1fc:	83 c0 01             	add    $0x1,%eax
 1ff:	84 d2                	test   %dl,%dl
 201:	74 0d                	je     210 <strchr+0x30>
    if(*s == c)
 203:	38 d1                	cmp    %dl,%cl
 205:	75 f1                	jne    1f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 207:	5d                   	pop    %ebp
 208:	c3                   	ret
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 210:	31 c0                	xor    %eax,%eax
}
 212:	5d                   	pop    %ebp
 213:	c3                   	ret
 214:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21b:	00 
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 225:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 228:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 229:	31 db                	xor    %ebx,%ebx
 22b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 22e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 231:	3b 75 0c             	cmp    0xc(%ebp),%esi
 234:	7d 3b                	jge    271 <gets+0x51>
 236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 23d:	00 
 23e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 240:	83 ec 04             	sub    $0x4,%esp
 243:	6a 01                	push   $0x1
 245:	57                   	push   %edi
 246:	6a 00                	push   $0x0
 248:	e8 1e 01 00 00       	call   36b <read>
    if(cc < 1)
 24d:	83 c4 10             	add    $0x10,%esp
 250:	85 c0                	test   %eax,%eax
 252:	7e 1d                	jle    271 <gets+0x51>
      break;
      
    buf[i++] = c;
 254:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 258:	8b 55 08             	mov    0x8(%ebp),%edx
 25b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 25f:	3c 0a                	cmp    $0xa,%al
 261:	7f 25                	jg     288 <gets+0x68>
 263:	3c 08                	cmp    $0x8,%al
 265:	7f 0c                	jg     273 <gets+0x53>
{
 267:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 269:	8d 73 01             	lea    0x1(%ebx),%esi
 26c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 26f:	7c cf                	jl     240 <gets+0x20>
 271:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 27a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27d:	5b                   	pop    %ebx
 27e:	5e                   	pop    %esi
 27f:	5f                   	pop    %edi
 280:	5d                   	pop    %ebp
 281:	c3                   	ret
 282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 288:	3c 0d                	cmp    $0xd,%al
 28a:	74 e7                	je     273 <gets+0x53>
{
 28c:	89 f3                	mov    %esi,%ebx
 28e:	eb d9                	jmp    269 <gets+0x49>

00000290 <stat>:

int
stat(const char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	6a 00                	push   $0x0
 29a:	ff 75 08             	push   0x8(%ebp)
 29d:	e8 f1 00 00 00       	call   393 <open>
  if(fd < 0)
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	78 27                	js     2d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	ff 75 0c             	push   0xc(%ebp)
 2af:	89 c3                	mov    %eax,%ebx
 2b1:	50                   	push   %eax
 2b2:	e8 f4 00 00 00       	call   3ab <fstat>
  close(fd);
 2b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2ba:	89 c6                	mov    %eax,%esi
  close(fd);
 2bc:	e8 ba 00 00 00       	call   37b <close>
  return r;
 2c1:	83 c4 10             	add    $0x10,%esp
}
 2c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2c7:	89 f0                	mov    %esi,%eax
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2d5:	eb ed                	jmp    2c4 <stat+0x34>
 2d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2de:	00 
 2df:	90                   	nop

000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	0f be 02             	movsbl (%edx),%eax
 2ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
 2ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2f5:	77 1e                	ja     315 <atoi+0x35>
 2f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fe:	00 
 2ff:	90                   	nop
    n = n*10 + *s++ - '0';
 300:	83 c2 01             	add    $0x1,%edx
 303:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 306:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 30a:	0f be 02             	movsbl (%edx),%eax
 30d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 310:	80 fb 09             	cmp    $0x9,%bl
 313:	76 eb                	jbe    300 <atoi+0x20>
  return n;
}
 315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 318:	89 c8                	mov    %ecx,%eax
 31a:	c9                   	leave
 31b:	c3                   	ret
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	8b 45 10             	mov    0x10(%ebp),%eax
 327:	8b 55 08             	mov    0x8(%ebp),%edx
 32a:	56                   	push   %esi
 32b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 c0                	test   %eax,%eax
 330:	7e 13                	jle    345 <memmove+0x25>
 332:	01 d0                	add    %edx,%eax
  dst = vdst;
 334:	89 d7                	mov    %edx,%edi
 336:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 33d:	00 
 33e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 340:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 341:	39 f8                	cmp    %edi,%eax
 343:	75 fb                	jne    340 <memmove+0x20>
  return vdst;
}
 345:	5e                   	pop    %esi
 346:	89 d0                	mov    %edx,%eax
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret

0000034b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34b:	b8 01 00 00 00       	mov    $0x1,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret

00000353 <exit>:
SYSCALL(exit)
 353:	b8 02 00 00 00       	mov    $0x2,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret

0000035b <wait>:
SYSCALL(wait)
 35b:	b8 03 00 00 00       	mov    $0x3,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret

00000363 <pipe>:
SYSCALL(pipe)
 363:	b8 04 00 00 00       	mov    $0x4,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret

0000036b <read>:
SYSCALL(read)
 36b:	b8 05 00 00 00       	mov    $0x5,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret

00000373 <write>:
SYSCALL(write)
 373:	b8 10 00 00 00       	mov    $0x10,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret

0000037b <close>:
SYSCALL(close)
 37b:	b8 15 00 00 00       	mov    $0x15,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret

00000383 <kill>:
SYSCALL(kill)
 383:	b8 06 00 00 00       	mov    $0x6,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret

0000038b <exec>:
SYSCALL(exec)
 38b:	b8 07 00 00 00       	mov    $0x7,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret

00000393 <open>:
SYSCALL(open)
 393:	b8 0f 00 00 00       	mov    $0xf,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret

0000039b <mknod>:
SYSCALL(mknod)
 39b:	b8 11 00 00 00       	mov    $0x11,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <unlink>:
SYSCALL(unlink)
 3a3:	b8 12 00 00 00       	mov    $0x12,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <fstat>:
SYSCALL(fstat)
 3ab:	b8 08 00 00 00       	mov    $0x8,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <link>:
SYSCALL(link)
 3b3:	b8 13 00 00 00       	mov    $0x13,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <mkdir>:
SYSCALL(mkdir)
 3bb:	b8 14 00 00 00       	mov    $0x14,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <chdir>:
SYSCALL(chdir)
 3c3:	b8 09 00 00 00       	mov    $0x9,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <dup>:
SYSCALL(dup)
 3cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <getpid>:
SYSCALL(getpid)
 3d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <sbrk>:
SYSCALL(sbrk)
 3db:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <sleep>:
SYSCALL(sleep)
 3e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <uptime>:
SYSCALL(uptime)
 3eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 3f3:	b8 17 00 00 00       	mov    $0x17,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <show_process_family>:
SYSCALL(show_process_family)
 3fb:	b8 18 00 00 00       	mov    $0x18,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 403:	b8 16 00 00 00       	mov    $0x16,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <grep_syscall>:
SYSCALL(grep_syscall)
 40b:	b8 19 00 00 00       	mov    $0x19,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 413:	b8 1a 00 00 00       	mov    $0x1a,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 41b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 423:	b8 1c 00 00 00       	mov    $0x1c,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 42b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 433:	b8 1e 00 00 00       	mov    $0x1e,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 43b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 443:	b8 20 00 00 00       	mov    $0x20,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 44b:	b8 21 00 00 00       	mov    $0x21,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <release_plock_sys>:
SYSCALL(release_plock_sys)
 453:	b8 22 00 00 00       	mov    $0x22,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret
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
 49b:	0f b6 92 04 09 00 00 	movzbl 0x904(%edx),%edx
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
 4d8:	e8 96 fe ff ff       	call   373 <write>
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
 542:	e8 2c fe ff ff       	call   373 <write>
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
 574:	ff 24 85 ac 08 00 00 	jmp    *0x8ac(,%eax,4)
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
 5a1:	e8 cd fd ff ff       	call   373 <write>
 5a6:	83 c4 0c             	add    $0xc,%esp
 5a9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ac:	6a 01                	push   $0x1
 5ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5b1:	52                   	push   %edx
 5b2:	57                   	push   %edi
 5b3:	e8 bb fd ff ff       	call   373 <write>
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
 61d:	e8 51 fd ff ff       	call   373 <write>
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
 65c:	e8 12 fd ff ff       	call   373 <write>
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
 685:	bb 58 08 00 00       	mov    $0x858,%ebx
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
 691:	a1 ac 0b 00 00       	mov    0xbac,%eax
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
 6d0:	a3 ac 0b 00 00       	mov    %eax,0xbac
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
 70a:	a3 ac 0b 00 00       	mov    %eax,0xbac
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
 72c:	8b 15 ac 0b 00 00    	mov    0xbac,%edx
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
 76b:	3b 05 ac 0b 00 00    	cmp    0xbac,%eax
 771:	75 ed                	jne    760 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	56                   	push   %esi
 777:	e8 5f fc ff ff       	call   3db <sbrk>
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
 793:	8b 15 ac 0b 00 00    	mov    0xbac,%edx
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
 7bf:	89 15 ac 0b 00 00    	mov    %edx,0xbac
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
 7d0:	c7 05 ac 0b 00 00 b0 	movl   $0xbb0,0xbac
 7d7:	0b 00 00 
    base.s.size = 0;
 7da:	b8 b0 0b 00 00       	mov    $0xbb0,%eax
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 b0 0b 00 00 b0 	movl   $0xbb0,0xbb0
 7e6:	0b 00 00 
    base.s.size = 0;
 7e9:	c7 05 b4 0b 00 00 00 	movl   $0x0,0xbb4
 7f0:	00 00 00 
    if(p->s.size >= nunits){
 7f3:	e9 54 ff ff ff       	jmp    74c <malloc+0x2c>
 7f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7ff:	00 
        prevp->s.ptr = p->s.ptr;
 800:	8b 08                	mov    (%eax),%ecx
 802:	89 0a                	mov    %ecx,(%edx)
 804:	eb b9                	jmp    7bf <malloc+0x9f>
