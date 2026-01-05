
_test_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

  run_one("anything", "no_such_file.txt");
}

int main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  if(argc == 3){
   f:	83 39 03             	cmpl   $0x3,(%ecx)
{
  12:	8b 41 04             	mov    0x4(%ecx),%eax
  if(argc == 3){
  15:	74 7e                	je     95 <main+0x95>
  int fd = open(fname, O_CREATE | O_WRONLY);
  17:	53                   	push   %ebx
  18:	53                   	push   %ebx
  19:	68 01 02 00 00       	push   $0x201
  1e:	68 9e 08 00 00       	push   $0x89e
  23:	e8 bb 03 00 00       	call   3e3 <open>
  if(fd < 0){
  28:	83 c4 10             	add    $0x10,%esp
  int fd = open(fname, O_CREATE | O_WRONLY);
  2b:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
  2d:	85 c0                	test   %eax,%eax
  2f:	78 74                	js     a5 <main+0xa5>
  write(fd, body, strlen(body));
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	68 4c 09 00 00       	push   $0x94c
  39:	e8 a2 01 00 00       	call   1e0 <strlen>
  3e:	83 c4 0c             	add    $0xc,%esp
  41:	50                   	push   %eax
  42:	68 4c 09 00 00       	push   $0x94c
  47:	53                   	push   %ebx
  48:	e8 76 03 00 00       	call   3c3 <write>
  close(fd);
  4d:	89 1c 24             	mov    %ebx,(%esp)
  50:	e8 76 03 00 00       	call   3cb <close>
  printf(1, "== self-tests ==\n");
  55:	58                   	pop    %eax
  56:	5a                   	pop    %edx
  57:	68 b7 08 00 00       	push   $0x8b7
  5c:	6a 01                	push   $0x1
  5e:	e8 1d 05 00 00       	call   580 <printf>
  run_one("KEYWORD", fname);
  63:	ba 9e 08 00 00       	mov    $0x89e,%edx
  68:	b8 c9 08 00 00       	mov    $0x8c9,%eax
  6d:	e8 4e 00 00 00       	call   c0 <run_one>
  run_one("NOPE", fname);
  72:	ba 9e 08 00 00       	mov    $0x89e,%edx
  77:	b8 d1 08 00 00       	mov    $0x8d1,%eax
  7c:	e8 3f 00 00 00       	call   c0 <run_one>
  run_one("anything", "no_such_file.txt");
  81:	ba d6 08 00 00       	mov    $0x8d6,%edx
  86:	b8 e7 08 00 00       	mov    $0x8e7,%eax
  8b:	e8 30 00 00 00       	call   c0 <run_one>
    run_one(argv[1], argv[2]);
    exit();
  }

  self_tests();
  exit();
  90:	e8 0e 03 00 00       	call   3a3 <exit>
    run_one(argv[1], argv[2]);
  95:	8b 50 08             	mov    0x8(%eax),%edx
  98:	8b 40 04             	mov    0x4(%eax),%eax
  9b:	e8 20 00 00 00       	call   c0 <run_one>
    exit();
  a0:	e8 fe 02 00 00       	call   3a3 <exit>
    printf(2, "cannot create %s\n", fname);
  a5:	51                   	push   %ecx
  a6:	68 9e 08 00 00       	push   $0x89e
  ab:	68 a5 08 00 00       	push   $0x8a5
  b0:	6a 02                	push   $0x2
  b2:	e8 c9 04 00 00       	call   580 <printf>
    exit();
  b7:	e8 e7 02 00 00       	call   3a3 <exit>
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <run_one>:
static void run_one(const char *key, const char *path){
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	89 d7                	mov    %edx,%edi
  c6:	56                   	push   %esi
  int ret = grep_syscall(key, path, out, sizeof(out));
  c7:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
static void run_one(const char *key, const char *path){
  cd:	53                   	push   %ebx
  ce:	89 c3                	mov    %eax,%ebx
  d0:	81 ec 0c 02 00 00    	sub    $0x20c,%esp
  int ret = grep_syscall(key, path, out, sizeof(out));
  d6:	68 00 02 00 00       	push   $0x200
  db:	56                   	push   %esi
  dc:	52                   	push   %edx
  dd:	50                   	push   %eax
  de:	e8 78 03 00 00       	call   45b <grep_syscall>
  if(ret < 0){
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	85 c0                	test   %eax,%eax
  e8:	78 40                	js     12a <run_one+0x6a>
    printf(1, "grep(\"%s\", \"%s\"): match len=%d%s\n", key, path, ret, truncated ? " (truncated)" : "");
  ea:	3d 00 02 00 00       	cmp    $0x200,%eax
  ef:	b9 88 08 00 00       	mov    $0x888,%ecx
  f4:	ba 9d 08 00 00       	mov    $0x89d,%edx
  f9:	0f 4d d1             	cmovge %ecx,%edx
  fc:	83 ec 08             	sub    $0x8,%esp
  ff:	52                   	push   %edx
 100:	50                   	push   %eax
 101:	57                   	push   %edi
 102:	53                   	push   %ebx
 103:	68 28 09 00 00       	push   $0x928
 108:	6a 01                	push   $0x1
 10a:	e8 71 04 00 00       	call   580 <printf>
    printf(1, "=> \"%s\"\n", out);
 10f:	83 c4 1c             	add    $0x1c,%esp
 112:	56                   	push   %esi
 113:	68 95 08 00 00       	push   $0x895
 118:	6a 01                	push   $0x1
 11a:	e8 61 04 00 00       	call   580 <printf>
 11f:	83 c4 10             	add    $0x10,%esp
}
 122:	8d 65 f4             	lea    -0xc(%ebp),%esp
 125:	5b                   	pop    %ebx
 126:	5e                   	pop    %esi
 127:	5f                   	pop    %edi
 128:	5d                   	pop    %ebp
 129:	c3                   	ret
    printf(1, "grep(\"%s\", \"%s\"): not found or error (ret=%d)\n", key, path, ret);
 12a:	83 ec 0c             	sub    $0xc,%esp
 12d:	50                   	push   %eax
 12e:	57                   	push   %edi
 12f:	53                   	push   %ebx
 130:	68 f8 08 00 00       	push   $0x8f8
 135:	6a 01                	push   $0x1
 137:	e8 44 04 00 00       	call   580 <printf>
 13c:	83 c4 20             	add    $0x20,%esp
 13f:	eb e1                	jmp    122 <run_one+0x62>
 141:	66 90                	xchg   %ax,%ax
 143:	66 90                	xchg   %ax,%ax
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 150:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 151:	31 c0                	xor    %eax,%eax
{
 153:	89 e5                	mov    %esp,%ebp
 155:	53                   	push   %ebx
 156:	8b 4d 08             	mov    0x8(%ebp),%ecx
 159:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 160:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 164:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 167:	83 c0 01             	add    $0x1,%eax
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strcpy+0x10>
    ;
  return os;
}
 16e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 171:	89 c8                	mov    %ecx,%eax
 173:	c9                   	leave
 174:	c3                   	ret
 175:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 17c:	00 
 17d:	8d 76 00             	lea    0x0(%esi),%esi

00000180 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	8b 55 08             	mov    0x8(%ebp),%edx
 187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 18a:	0f b6 02             	movzbl (%edx),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 17                	jne    1a8 <strcmp+0x28>
 191:	eb 3a                	jmp    1cd <strcmp+0x4d>
 193:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 198:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 19c:	83 c2 01             	add    $0x1,%edx
 19f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1a2:	84 c0                	test   %al,%al
 1a4:	74 1a                	je     1c0 <strcmp+0x40>
 1a6:	89 d9                	mov    %ebx,%ecx
 1a8:	0f b6 19             	movzbl (%ecx),%ebx
 1ab:	38 c3                	cmp    %al,%bl
 1ad:	74 e9                	je     198 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1af:	29 d8                	sub    %ebx,%eax
}
 1b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b4:	c9                   	leave
 1b5:	c3                   	ret
 1b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bd:	00 
 1be:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 1c0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1c4:	31 c0                	xor    %eax,%eax
 1c6:	29 d8                	sub    %ebx,%eax
}
 1c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1cb:	c9                   	leave
 1cc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1cd:	0f b6 19             	movzbl (%ecx),%ebx
 1d0:	31 c0                	xor    %eax,%eax
 1d2:	eb db                	jmp    1af <strcmp+0x2f>
 1d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1db:	00 
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001e0 <strlen>:

uint
strlen(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 3a 00             	cmpb   $0x0,(%edx)
 1e9:	74 15                	je     200 <strlen+0x20>
 1eb:	31 c0                	xor    %eax,%eax
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c0 01             	add    $0x1,%eax
 1f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1f7:	89 c1                	mov    %eax,%ecx
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	89 c8                	mov    %ecx,%eax
 1fd:	5d                   	pop    %ebp
 1fe:	c3                   	ret
 1ff:	90                   	nop
  for(n = 0; s[n]; n++)
 200:	31 c9                	xor    %ecx,%ecx
}
 202:	5d                   	pop    %ebp
 203:	89 c8                	mov    %ecx,%eax
 205:	c3                   	ret
 206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20d:	00 
 20e:	66 90                	xchg   %ax,%ax

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	8b 7d fc             	mov    -0x4(%ebp),%edi
 225:	89 d0                	mov    %edx,%eax
 227:	c9                   	leave
 228:	c3                   	ret
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 23a:	0f b6 10             	movzbl (%eax),%edx
 23d:	84 d2                	test   %dl,%dl
 23f:	75 12                	jne    253 <strchr+0x23>
 241:	eb 1d                	jmp    260 <strchr+0x30>
 243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 248:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 24c:	83 c0 01             	add    $0x1,%eax
 24f:	84 d2                	test   %dl,%dl
 251:	74 0d                	je     260 <strchr+0x30>
    if(*s == c)
 253:	38 d1                	cmp    %dl,%cl
 255:	75 f1                	jne    248 <strchr+0x18>
      return (char*)s;
  return 0;
}
 257:	5d                   	pop    %ebp
 258:	c3                   	ret
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 260:	31 c0                	xor    %eax,%eax
}
 262:	5d                   	pop    %ebp
 263:	c3                   	ret
 264:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 26b:	00 
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 275:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 278:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 279:	31 db                	xor    %ebx,%ebx
 27b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 27e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 281:	3b 75 0c             	cmp    0xc(%ebp),%esi
 284:	7d 3b                	jge    2c1 <gets+0x51>
 286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 28d:	00 
 28e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 290:	83 ec 04             	sub    $0x4,%esp
 293:	6a 01                	push   $0x1
 295:	57                   	push   %edi
 296:	6a 00                	push   $0x0
 298:	e8 1e 01 00 00       	call   3bb <read>
    if(cc < 1)
 29d:	83 c4 10             	add    $0x10,%esp
 2a0:	85 c0                	test   %eax,%eax
 2a2:	7e 1d                	jle    2c1 <gets+0x51>
      break;
      
    buf[i++] = c;
 2a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
 2ab:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 2af:	3c 0a                	cmp    $0xa,%al
 2b1:	7f 25                	jg     2d8 <gets+0x68>
 2b3:	3c 08                	cmp    $0x8,%al
 2b5:	7f 0c                	jg     2c3 <gets+0x53>
{
 2b7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 2b9:	8d 73 01             	lea    0x1(%ebx),%esi
 2bc:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2bf:	7c cf                	jl     290 <gets+0x20>
 2c1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2cd:	5b                   	pop    %ebx
 2ce:	5e                   	pop    %esi
 2cf:	5f                   	pop    %edi
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret
 2d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2d8:	3c 0d                	cmp    $0xd,%al
 2da:	74 e7                	je     2c3 <gets+0x53>
{
 2dc:	89 f3                	mov    %esi,%ebx
 2de:	eb d9                	jmp    2b9 <gets+0x49>

000002e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	6a 00                	push   $0x0
 2ea:	ff 75 08             	push   0x8(%ebp)
 2ed:	e8 f1 00 00 00       	call   3e3 <open>
  if(fd < 0)
 2f2:	83 c4 10             	add    $0x10,%esp
 2f5:	85 c0                	test   %eax,%eax
 2f7:	78 27                	js     320 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2f9:	83 ec 08             	sub    $0x8,%esp
 2fc:	ff 75 0c             	push   0xc(%ebp)
 2ff:	89 c3                	mov    %eax,%ebx
 301:	50                   	push   %eax
 302:	e8 f4 00 00 00       	call   3fb <fstat>
  close(fd);
 307:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 30a:	89 c6                	mov    %eax,%esi
  close(fd);
 30c:	e8 ba 00 00 00       	call   3cb <close>
  return r;
 311:	83 c4 10             	add    $0x10,%esp
}
 314:	8d 65 f8             	lea    -0x8(%ebp),%esp
 317:	89 f0                	mov    %esi,%eax
 319:	5b                   	pop    %ebx
 31a:	5e                   	pop    %esi
 31b:	5d                   	pop    %ebp
 31c:	c3                   	ret
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 320:	be ff ff ff ff       	mov    $0xffffffff,%esi
 325:	eb ed                	jmp    314 <stat+0x34>
 327:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32e:	00 
 32f:	90                   	nop

00000330 <atoi>:

int
atoi(const char *s)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 337:	0f be 02             	movsbl (%edx),%eax
 33a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 33d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 340:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 345:	77 1e                	ja     365 <atoi+0x35>
 347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 34e:	00 
 34f:	90                   	nop
    n = n*10 + *s++ - '0';
 350:	83 c2 01             	add    $0x1,%edx
 353:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 356:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 35a:	0f be 02             	movsbl (%edx),%eax
 35d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 360:	80 fb 09             	cmp    $0x9,%bl
 363:	76 eb                	jbe    350 <atoi+0x20>
  return n;
}
 365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 368:	89 c8                	mov    %ecx,%eax
 36a:	c9                   	leave
 36b:	c3                   	ret
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000370 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	8b 45 10             	mov    0x10(%ebp),%eax
 377:	8b 55 08             	mov    0x8(%ebp),%edx
 37a:	56                   	push   %esi
 37b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37e:	85 c0                	test   %eax,%eax
 380:	7e 13                	jle    395 <memmove+0x25>
 382:	01 d0                	add    %edx,%eax
  dst = vdst;
 384:	89 d7                	mov    %edx,%edi
 386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38d:	00 
 38e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 390:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 391:	39 f8                	cmp    %edi,%eax
 393:	75 fb                	jne    390 <memmove+0x20>
  return vdst;
}
 395:	5e                   	pop    %esi
 396:	89 d0                	mov    %edx,%eax
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 443:	b8 17 00 00 00       	mov    $0x17,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <show_process_family>:
SYSCALL(show_process_family)
 44b:	b8 18 00 00 00       	mov    $0x18,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 453:	b8 16 00 00 00       	mov    $0x16,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <grep_syscall>:
SYSCALL(grep_syscall)
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 463:	b8 1a 00 00 00       	mov    $0x1a,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 46b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 473:	b8 1c 00 00 00       	mov    $0x1c,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 47b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 483:	b8 1e 00 00 00       	mov    $0x1e,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 48b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 493:	b8 20 00 00 00       	mov    $0x20,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 49b:	b8 21 00 00 00       	mov    $0x21,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 4a3:	b8 22 00 00 00       	mov    $0x22,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <getlockstat>:

SYSCALL(getlockstat)
 4ab:	b8 23 00 00 00       	mov    $0x23,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <vread>:

SYSCALL(vread)
 4b3:	b8 24 00 00 00       	mov    $0x24,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <vwrite>:
SYSCALL(vwrite)
 4bb:	b8 25 00 00 00       	mov    $0x25,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 4c3:	b8 26 00 00 00       	mov    $0x26,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <cptresetstats>:
SYSCALL(cptresetstats)
 4cb:	b8 27 00 00 00       	mov    $0x27,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <cptgetstats>:
SYSCALL(cptgetstats)
 4d3:	b8 28 00 00 00       	mov    $0x28,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret
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
 51b:	0f b6 92 ec 09 00 00 	movzbl 0x9ec(%edx),%edx
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
 558:	e8 66 fe ff ff       	call   3c3 <write>
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
 5c2:	e8 fc fd ff ff       	call   3c3 <write>
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
 5f4:	ff 24 85 94 09 00 00 	jmp    *0x994(,%eax,4)
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
 621:	e8 9d fd ff ff       	call   3c3 <write>
 626:	83 c4 0c             	add    $0xc,%esp
 629:	88 5d e7             	mov    %bl,-0x19(%ebp)
 62c:	6a 01                	push   $0x1
 62e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 631:	52                   	push   %edx
 632:	57                   	push   %edi
 633:	e8 8b fd ff ff       	call   3c3 <write>
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
 69d:	e8 21 fd ff ff       	call   3c3 <write>
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
 6dc:	e8 e2 fc ff ff       	call   3c3 <write>
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
 705:	bb f0 08 00 00       	mov    $0x8f0,%ebx
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
 711:	a1 c0 0c 00 00       	mov    0xcc0,%eax
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
 750:	a3 c0 0c 00 00       	mov    %eax,0xcc0
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
 78a:	a3 c0 0c 00 00       	mov    %eax,0xcc0
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
 7ac:	8b 15 c0 0c 00 00    	mov    0xcc0,%edx
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
 7eb:	3b 05 c0 0c 00 00    	cmp    0xcc0,%eax
 7f1:	75 ed                	jne    7e0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	56                   	push   %esi
 7f7:	e8 2f fc ff ff       	call   42b <sbrk>
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
 813:	8b 15 c0 0c 00 00    	mov    0xcc0,%edx
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
 83f:	89 15 c0 0c 00 00    	mov    %edx,0xcc0
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
 850:	c7 05 c0 0c 00 00 c4 	movl   $0xcc4,0xcc0
 857:	0c 00 00 
    base.s.size = 0;
 85a:	b8 c4 0c 00 00       	mov    $0xcc4,%eax
    base.s.ptr = freep = prevp = &base;
 85f:	c7 05 c4 0c 00 00 c4 	movl   $0xcc4,0xcc4
 866:	0c 00 00 
    base.s.size = 0;
 869:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
 870:	00 00 00 
    if(p->s.size >= nunits){
 873:	e9 54 ff ff ff       	jmp    7cc <malloc+0x2c>
 878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 87f:	00 
        prevp->s.ptr = p->s.ptr;
 880:	8b 08                	mov    (%eax),%ecx
 882:	89 0a                	mov    %ecx,(%edx)
 884:	eb b9                	jmp    83f <malloc+0x9f>
