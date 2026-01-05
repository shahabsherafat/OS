
_clock:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define PGSZ 4096
#define CPT_CLOCK 3

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
  11:	83 ec 24             	sub    $0x24,%esp
  char *base = (char*)malloc(5 * PGSZ);
  14:	68 00 50 00 00       	push   $0x5000
  19:	e8 c2 07 00 00       	call   7e0 <malloc>
  int x;

  if(base == 0){
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 84 51 01 00 00    	je     17a <main+0x17a>
    printf(1, "malloc failed\n");
    exit();
  }

  cptsetpolicy(CPT_CLOCK);
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	89 c3                	mov    %eax,%ebx
  2e:	6a 03                	push   $0x3
  30:	e8 ce 04 00 00       	call   503 <cptsetpolicy>
  cptresetstats();
  35:	e8 d1 04 00 00       	call   50b <cptresetstats>

  printf(1, "\nSTEP 1) Fill CPT with pages 0..3 using writes\n");
  3a:	58                   	pop    %eax
  3b:	5a                   	pop    %edx
  3c:	68 4c 09 00 00       	push   $0x94c
  41:	6a 01                	push   $0x1
  43:	e8 78 05 00 00       	call   5c0 <printf>
  vwrite((int*)(base + 0*PGSZ), 100);
  48:	59                   	pop    %ecx
  49:	5e                   	pop    %esi
  4a:	6a 64                	push   $0x64
  4c:	53                   	push   %ebx
  vwrite((int*)(base + 1*PGSZ), 101);
  4d:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  vwrite((int*)(base + 0*PGSZ), 100);
  53:	e8 a3 04 00 00       	call   4fb <vwrite>
  vwrite((int*)(base + 1*PGSZ), 101);
  58:	5f                   	pop    %edi
  59:	58                   	pop    %eax
  5a:	6a 65                	push   $0x65
  5c:	56                   	push   %esi
  5d:	e8 99 04 00 00       	call   4fb <vwrite>
  vwrite((int*)(base + 2*PGSZ), 102);
  62:	8d 8b 00 20 00 00    	lea    0x2000(%ebx),%ecx
  68:	58                   	pop    %eax
  69:	5a                   	pop    %edx
  6a:	6a 66                	push   $0x66
  6c:	51                   	push   %ecx
  6d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  70:	e8 86 04 00 00       	call   4fb <vwrite>
  vwrite((int*)(base + 3*PGSZ), 103);
  75:	8d 93 00 30 00 00    	lea    0x3000(%ebx),%edx
  7b:	59                   	pop    %ecx
  7c:	5f                   	pop    %edi
  7d:	6a 67                	push   $0x67
  7f:	52                   	push   %edx
  80:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  83:	e8 73 04 00 00       	call   4fb <vwrite>

  printf(1, "\nSTEP 2) Touch page0 and page1 (set refbit=1 for them)\n");
  88:	58                   	pop    %eax
  89:	5a                   	pop    %edx
  8a:	68 7c 09 00 00       	push   $0x97c
  8f:	6a 01                	push   $0x1
  91:	e8 2a 05 00 00       	call   5c0 <printf>
  x = vread((int*)(base + 0*PGSZ));
  96:	89 1c 24             	mov    %ebx,(%esp)
  99:	e8 55 04 00 00       	call   4f3 <vread>
  x = vread((int*)(base + 1*PGSZ));
  9e:	89 34 24             	mov    %esi,(%esp)
  a1:	e8 4d 04 00 00       	call   4f3 <vread>
  printf(1, "touched p0=%d p1=%d\n", vread((int*)(base + 0*PGSZ)), vread((int*)(base + 1*PGSZ)));
  a6:	89 34 24             	mov    %esi,(%esp)
  a9:	e8 45 04 00 00       	call   4f3 <vread>
  ae:	89 1c 24             	mov    %ebx,(%esp)
  b1:	89 c7                	mov    %eax,%edi
  b3:	e8 3b 04 00 00       	call   4f3 <vread>
  b8:	57                   	push   %edi
  b9:	50                   	push   %eax
  ba:	68 d7 08 00 00       	push   $0x8d7
  bf:	6a 01                	push   $0x1
  c1:	e8 fa 04 00 00       	call   5c0 <printf>

  printf(1, "\nSTEP 3) Access page4 -> should cause eviction\n");
  c6:	83 c4 18             	add    $0x18,%esp
  c9:	68 b4 09 00 00       	push   $0x9b4
  ce:	6a 01                	push   $0x1
  d0:	e8 eb 04 00 00       	call   5c0 <printf>
  x = vread((int*)(base + 4*PGSZ));
  d5:	8d 83 00 40 00 00    	lea    0x4000(%ebx),%eax
  db:	89 04 24             	mov    %eax,(%esp)
  de:	e8 10 04 00 00       	call   4f3 <vread>
  printf(1, "read page4 = %d (expect 0 unless you wrote it)\n", x);
  e3:	83 c4 0c             	add    $0xc,%esp
  e6:	50                   	push   %eax
  e7:	68 e4 09 00 00       	push   $0x9e4
  ec:	6a 01                	push   $0x1
  ee:	e8 cd 04 00 00       	call   5c0 <printf>

  printf(1, "\nSTEP 4) Check pages 0..3 values still readable (write-through keeps correctness)\n");
  f3:	59                   	pop    %ecx
  f4:	5f                   	pop    %edi
  f5:	68 14 0a 00 00       	push   $0xa14
  fa:	6a 01                	push   $0x1
  fc:	e8 bf 04 00 00       	call   5c0 <printf>
  printf(1, "p0=%d (expect 100)\n", vread((int*)(base + 0*PGSZ)));
 101:	89 1c 24             	mov    %ebx,(%esp)
 104:	e8 ea 03 00 00       	call   4f3 <vread>
 109:	83 c4 0c             	add    $0xc,%esp
 10c:	50                   	push   %eax
 10d:	68 ec 08 00 00       	push   $0x8ec
 112:	6a 01                	push   $0x1
 114:	e8 a7 04 00 00       	call   5c0 <printf>
  printf(1, "p1=%d (expect 101)\n", vread((int*)(base + 1*PGSZ)));
 119:	89 34 24             	mov    %esi,(%esp)
 11c:	e8 d2 03 00 00       	call   4f3 <vread>
 121:	83 c4 0c             	add    $0xc,%esp
 124:	50                   	push   %eax
 125:	68 00 09 00 00       	push   $0x900
 12a:	6a 01                	push   $0x1
 12c:	e8 8f 04 00 00       	call   5c0 <printf>
  printf(1, "p2=%d (expect 102)\n", vread((int*)(base + 2*PGSZ)));
 131:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 134:	89 0c 24             	mov    %ecx,(%esp)
 137:	e8 b7 03 00 00       	call   4f3 <vread>
 13c:	83 c4 0c             	add    $0xc,%esp
 13f:	50                   	push   %eax
 140:	68 14 09 00 00       	push   $0x914
 145:	6a 01                	push   $0x1
 147:	e8 74 04 00 00       	call   5c0 <printf>
  printf(1, "p3=%d (expect 103)\n", vread((int*)(base + 3*PGSZ)));
 14c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 14f:	89 14 24             	mov    %edx,(%esp)
 152:	e8 9c 03 00 00       	call   4f3 <vread>
 157:	83 c4 0c             	add    $0xc,%esp
 15a:	50                   	push   %eax
 15b:	68 28 09 00 00       	push   $0x928
 160:	6a 01                	push   $0x1
 162:	e8 59 04 00 00       	call   5c0 <printf>

  printf(1, "\nDONE\n");
 167:	58                   	pop    %eax
 168:	5a                   	pop    %edx
 169:	68 3c 09 00 00       	push   $0x93c
 16e:	6a 01                	push   $0x1
 170:	e8 4b 04 00 00       	call   5c0 <printf>
  exit();
 175:	e8 69 02 00 00       	call   3e3 <exit>
    printf(1, "malloc failed\n");
 17a:	51                   	push   %ecx
 17b:	51                   	push   %ecx
 17c:	68 c8 08 00 00       	push   $0x8c8
 181:	6a 01                	push   $0x1
 183:	e8 38 04 00 00       	call   5c0 <printf>
    exit();
 188:	e8 56 02 00 00       	call   3e3 <exit>
 18d:	66 90                	xchg   %ax,%ax
 18f:	90                   	nop

00000190 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 190:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 191:	31 c0                	xor    %eax,%eax
{
 193:	89 e5                	mov    %esp,%ebp
 195:	53                   	push   %ebx
 196:	8b 4d 08             	mov    0x8(%ebp),%ecx
 199:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1a7:	83 c0 01             	add    $0x1,%eax
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strcpy+0x10>
    ;
  return os;
}
 1ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b1:	89 c8                	mov    %ecx,%eax
 1b3:	c9                   	leave
 1b4:	c3                   	ret
 1b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bc:	00 
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
 1c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ca:	0f b6 02             	movzbl (%edx),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 17                	jne    1e8 <strcmp+0x28>
 1d1:	eb 3a                	jmp    20d <strcmp+0x4d>
 1d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1dc:	83 c2 01             	add    $0x1,%edx
 1df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1e2:	84 c0                	test   %al,%al
 1e4:	74 1a                	je     200 <strcmp+0x40>
 1e6:	89 d9                	mov    %ebx,%ecx
 1e8:	0f b6 19             	movzbl (%ecx),%ebx
 1eb:	38 c3                	cmp    %al,%bl
 1ed:	74 e9                	je     1d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1ef:	29 d8                	sub    %ebx,%eax
}
 1f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1f4:	c9                   	leave
 1f5:	c3                   	ret
 1f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1fd:	00 
 1fe:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 200:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 204:	31 c0                	xor    %eax,%eax
 206:	29 d8                	sub    %ebx,%eax
}
 208:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 20b:	c9                   	leave
 20c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 20d:	0f b6 19             	movzbl (%ecx),%ebx
 210:	31 c0                	xor    %eax,%eax
 212:	eb db                	jmp    1ef <strcmp+0x2f>
 214:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 21b:	00 
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <strlen>:

uint
strlen(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 3a 00             	cmpb   $0x0,(%edx)
 229:	74 15                	je     240 <strlen+0x20>
 22b:	31 c0                	xor    %eax,%eax
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c0 01             	add    $0x1,%eax
 233:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 237:	89 c1                	mov    %eax,%ecx
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	89 c8                	mov    %ecx,%eax
 23d:	5d                   	pop    %ebp
 23e:	c3                   	ret
 23f:	90                   	nop
  for(n = 0; s[n]; n++)
 240:	31 c9                	xor    %ecx,%ecx
}
 242:	5d                   	pop    %ebp
 243:	89 c8                	mov    %ecx,%eax
 245:	c3                   	ret
 246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24d:	00 
 24e:	66 90                	xchg   %ax,%ax

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	8b 7d fc             	mov    -0x4(%ebp),%edi
 265:	89 d0                	mov    %edx,%eax
 267:	c9                   	leave
 268:	c3                   	ret
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	75 12                	jne    293 <strchr+0x23>
 281:	eb 1d                	jmp    2a0 <strchr+0x30>
 283:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 288:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 28c:	83 c0 01             	add    $0x1,%eax
 28f:	84 d2                	test   %dl,%dl
 291:	74 0d                	je     2a0 <strchr+0x30>
    if(*s == c)
 293:	38 d1                	cmp    %dl,%cl
 295:	75 f1                	jne    288 <strchr+0x18>
      return (char*)s;
  return 0;
}
 297:	5d                   	pop    %ebp
 298:	c3                   	ret
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2a0:	31 c0                	xor    %eax,%eax
}
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret
 2a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ab:	00 
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2b5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2b9:	31 db                	xor    %ebx,%ebx
 2bb:	8d 73 01             	lea    0x1(%ebx),%esi
{
 2be:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2c1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2c4:	7d 3b                	jge    301 <gets+0x51>
 2c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2cd:	00 
 2ce:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	6a 01                	push   $0x1
 2d5:	57                   	push   %edi
 2d6:	6a 00                	push   $0x0
 2d8:	e8 1e 01 00 00       	call   3fb <read>
    if(cc < 1)
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7e 1d                	jle    301 <gets+0x51>
      break;
      
    buf[i++] = c;
 2e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
 2eb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 2ef:	3c 0a                	cmp    $0xa,%al
 2f1:	7f 25                	jg     318 <gets+0x68>
 2f3:	3c 08                	cmp    $0x8,%al
 2f5:	7f 0c                	jg     303 <gets+0x53>
{
 2f7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 2f9:	8d 73 01             	lea    0x1(%ebx),%esi
 2fc:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2ff:	7c cf                	jl     2d0 <gets+0x20>
 301:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 30a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret
 312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 318:	3c 0d                	cmp    $0xd,%al
 31a:	74 e7                	je     303 <gets+0x53>
{
 31c:	89 f3                	mov    %esi,%ebx
 31e:	eb d9                	jmp    2f9 <gets+0x49>

00000320 <stat>:

int
stat(const char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 325:	83 ec 08             	sub    $0x8,%esp
 328:	6a 00                	push   $0x0
 32a:	ff 75 08             	push   0x8(%ebp)
 32d:	e8 f1 00 00 00       	call   423 <open>
  if(fd < 0)
 332:	83 c4 10             	add    $0x10,%esp
 335:	85 c0                	test   %eax,%eax
 337:	78 27                	js     360 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 339:	83 ec 08             	sub    $0x8,%esp
 33c:	ff 75 0c             	push   0xc(%ebp)
 33f:	89 c3                	mov    %eax,%ebx
 341:	50                   	push   %eax
 342:	e8 f4 00 00 00       	call   43b <fstat>
  close(fd);
 347:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 34a:	89 c6                	mov    %eax,%esi
  close(fd);
 34c:	e8 ba 00 00 00       	call   40b <close>
  return r;
 351:	83 c4 10             	add    $0x10,%esp
}
 354:	8d 65 f8             	lea    -0x8(%ebp),%esp
 357:	89 f0                	mov    %esi,%eax
 359:	5b                   	pop    %ebx
 35a:	5e                   	pop    %esi
 35b:	5d                   	pop    %ebp
 35c:	c3                   	ret
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 360:	be ff ff ff ff       	mov    $0xffffffff,%esi
 365:	eb ed                	jmp    354 <stat+0x34>
 367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 36e:	00 
 36f:	90                   	nop

00000370 <atoi>:

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 02             	movsbl (%edx),%eax
 37a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 37d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 380:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 385:	77 1e                	ja     3a5 <atoi+0x35>
 387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38e:	00 
 38f:	90                   	nop
    n = n*10 + *s++ - '0';
 390:	83 c2 01             	add    $0x1,%edx
 393:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 396:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 39a:	0f be 02             	movsbl (%edx),%eax
 39d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3a0:	80 fb 09             	cmp    $0x9,%bl
 3a3:	76 eb                	jbe    390 <atoi+0x20>
  return n;
}
 3a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a8:	89 c8                	mov    %ecx,%eax
 3aa:	c9                   	leave
 3ab:	c3                   	ret
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	8b 45 10             	mov    0x10(%ebp),%eax
 3b7:	8b 55 08             	mov    0x8(%ebp),%edx
 3ba:	56                   	push   %esi
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3be:	85 c0                	test   %eax,%eax
 3c0:	7e 13                	jle    3d5 <memmove+0x25>
 3c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3c4:	89 d7                	mov    %edx,%edi
 3c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cd:	00 
 3ce:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3d1:	39 f8                	cmp    %edi,%eax
 3d3:	75 fb                	jne    3d0 <memmove+0x20>
  return vdst;
}
 3d5:	5e                   	pop    %esi
 3d6:	89 d0                	mov    %edx,%eax
 3d8:	5f                   	pop    %edi
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret

000003db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3db:	b8 01 00 00 00       	mov    $0x1,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <exit>:
SYSCALL(exit)
 3e3:	b8 02 00 00 00       	mov    $0x2,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <wait>:
SYSCALL(wait)
 3eb:	b8 03 00 00 00       	mov    $0x3,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <pipe>:
SYSCALL(pipe)
 3f3:	b8 04 00 00 00       	mov    $0x4,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <read>:
SYSCALL(read)
 3fb:	b8 05 00 00 00       	mov    $0x5,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <write>:
SYSCALL(write)
 403:	b8 10 00 00 00       	mov    $0x10,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <close>:
SYSCALL(close)
 40b:	b8 15 00 00 00       	mov    $0x15,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <kill>:
SYSCALL(kill)
 413:	b8 06 00 00 00       	mov    $0x6,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <exec>:
SYSCALL(exec)
 41b:	b8 07 00 00 00       	mov    $0x7,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <open>:
SYSCALL(open)
 423:	b8 0f 00 00 00       	mov    $0xf,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <mknod>:
SYSCALL(mknod)
 42b:	b8 11 00 00 00       	mov    $0x11,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <unlink>:
SYSCALL(unlink)
 433:	b8 12 00 00 00       	mov    $0x12,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <fstat>:
SYSCALL(fstat)
 43b:	b8 08 00 00 00       	mov    $0x8,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <link>:
SYSCALL(link)
 443:	b8 13 00 00 00       	mov    $0x13,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <mkdir>:
SYSCALL(mkdir)
 44b:	b8 14 00 00 00       	mov    $0x14,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <chdir>:
SYSCALL(chdir)
 453:	b8 09 00 00 00       	mov    $0x9,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <dup>:
SYSCALL(dup)
 45b:	b8 0a 00 00 00       	mov    $0xa,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <getpid>:
SYSCALL(getpid)
 463:	b8 0b 00 00 00       	mov    $0xb,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <sbrk>:
SYSCALL(sbrk)
 46b:	b8 0c 00 00 00       	mov    $0xc,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <sleep>:
SYSCALL(sleep)
 473:	b8 0d 00 00 00       	mov    $0xd,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <uptime>:
SYSCALL(uptime)
 47b:	b8 0e 00 00 00       	mov    $0xe,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 483:	b8 17 00 00 00       	mov    $0x17,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <show_process_family>:
SYSCALL(show_process_family)
 48b:	b8 18 00 00 00       	mov    $0x18,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 493:	b8 16 00 00 00       	mov    $0x16,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <grep_syscall>:
SYSCALL(grep_syscall)
 49b:	b8 19 00 00 00       	mov    $0x19,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 4a3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 4ab:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 4b3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 4bb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 4c3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 4cb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 4d3:	b8 20 00 00 00       	mov    $0x20,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 4db:	b8 21 00 00 00       	mov    $0x21,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 4e3:	b8 22 00 00 00       	mov    $0x22,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <getlockstat>:

SYSCALL(getlockstat)
 4eb:	b8 23 00 00 00       	mov    $0x23,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <vread>:

SYSCALL(vread)
 4f3:	b8 24 00 00 00       	mov    $0x24,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <vwrite>:
SYSCALL(vwrite)
 4fb:	b8 25 00 00 00       	mov    $0x25,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 503:	b8 26 00 00 00       	mov    $0x26,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <cptresetstats>:
SYSCALL(cptresetstats)
 50b:	b8 27 00 00 00       	mov    $0x27,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <cptgetstats>:
SYSCALL(cptgetstats)
 513:	b8 28 00 00 00       	mov    $0x28,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret
 51b:	66 90                	xchg   %ax,%ax
 51d:	66 90                	xchg   %ax,%ax
 51f:	90                   	nop

00000520 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 528:	89 d1                	mov    %edx,%ecx
{
 52a:	83 ec 3c             	sub    $0x3c,%esp
 52d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 530:	85 d2                	test   %edx,%edx
 532:	0f 89 80 00 00 00    	jns    5b8 <printint+0x98>
 538:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 53c:	74 7a                	je     5b8 <printint+0x98>
    x = -xx;
 53e:	f7 d9                	neg    %ecx
    neg = 1;
 540:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 545:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 548:	31 f6                	xor    %esi,%esi
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 550:	89 c8                	mov    %ecx,%eax
 552:	31 d2                	xor    %edx,%edx
 554:	89 f7                	mov    %esi,%edi
 556:	f7 f3                	div    %ebx
 558:	8d 76 01             	lea    0x1(%esi),%esi
 55b:	0f b6 92 c0 0a 00 00 	movzbl 0xac0(%edx),%edx
 562:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 566:	89 ca                	mov    %ecx,%edx
 568:	89 c1                	mov    %eax,%ecx
 56a:	39 da                	cmp    %ebx,%edx
 56c:	73 e2                	jae    550 <printint+0x30>
  if(neg)
 56e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 571:	85 c0                	test   %eax,%eax
 573:	74 07                	je     57c <printint+0x5c>
    buf[i++] = '-';
 575:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 57a:	89 f7                	mov    %esi,%edi
 57c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 57f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 582:	01 df                	add    %ebx,%edi
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 588:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 58b:	83 ec 04             	sub    $0x4,%esp
 58e:	88 45 d7             	mov    %al,-0x29(%ebp)
 591:	8d 45 d7             	lea    -0x29(%ebp),%eax
 594:	6a 01                	push   $0x1
 596:	50                   	push   %eax
 597:	56                   	push   %esi
 598:	e8 66 fe ff ff       	call   403 <write>
  while(--i >= 0)
 59d:	89 f8                	mov    %edi,%eax
 59f:	83 c4 10             	add    $0x10,%esp
 5a2:	83 ef 01             	sub    $0x1,%edi
 5a5:	39 c3                	cmp    %eax,%ebx
 5a7:	75 df                	jne    588 <printint+0x68>
}
 5a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ac:	5b                   	pop    %ebx
 5ad:	5e                   	pop    %esi
 5ae:	5f                   	pop    %edi
 5af:	5d                   	pop    %ebp
 5b0:	c3                   	ret
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5b8:	31 c0                	xor    %eax,%eax
 5ba:	eb 89                	jmp    545 <printint+0x25>
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 5cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 5cf:	0f b6 1e             	movzbl (%esi),%ebx
 5d2:	83 c6 01             	add    $0x1,%esi
 5d5:	84 db                	test   %bl,%bl
 5d7:	74 67                	je     640 <printf+0x80>
 5d9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5dc:	31 d2                	xor    %edx,%edx
 5de:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5e1:	eb 34                	jmp    617 <printf+0x57>
 5e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5eb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5f0:	83 f8 25             	cmp    $0x25,%eax
 5f3:	74 18                	je     60d <printf+0x4d>
  write(fd, &c, 1);
 5f5:	83 ec 04             	sub    $0x4,%esp
 5f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5fb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5fe:	6a 01                	push   $0x1
 600:	50                   	push   %eax
 601:	57                   	push   %edi
 602:	e8 fc fd ff ff       	call   403 <write>
 607:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 60a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 60d:	0f b6 1e             	movzbl (%esi),%ebx
 610:	83 c6 01             	add    $0x1,%esi
 613:	84 db                	test   %bl,%bl
 615:	74 29                	je     640 <printf+0x80>
    c = fmt[i] & 0xff;
 617:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 61a:	85 d2                	test   %edx,%edx
 61c:	74 ca                	je     5e8 <printf+0x28>
      }
    } else if(state == '%'){
 61e:	83 fa 25             	cmp    $0x25,%edx
 621:	75 ea                	jne    60d <printf+0x4d>
      if(c == 'd'){
 623:	83 f8 25             	cmp    $0x25,%eax
 626:	0f 84 04 01 00 00    	je     730 <printf+0x170>
 62c:	83 e8 63             	sub    $0x63,%eax
 62f:	83 f8 15             	cmp    $0x15,%eax
 632:	77 1c                	ja     650 <printf+0x90>
 634:	ff 24 85 68 0a 00 00 	jmp    *0xa68(,%eax,4)
 63b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 640:	8d 65 f4             	lea    -0xc(%ebp),%esp
 643:	5b                   	pop    %ebx
 644:	5e                   	pop    %esi
 645:	5f                   	pop    %edi
 646:	5d                   	pop    %ebp
 647:	c3                   	ret
 648:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 64f:	00 
  write(fd, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
 653:	8d 55 e7             	lea    -0x19(%ebp),%edx
 656:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 65a:	6a 01                	push   $0x1
 65c:	52                   	push   %edx
 65d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 660:	57                   	push   %edi
 661:	e8 9d fd ff ff       	call   403 <write>
 666:	83 c4 0c             	add    $0xc,%esp
 669:	88 5d e7             	mov    %bl,-0x19(%ebp)
 66c:	6a 01                	push   $0x1
 66e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 671:	52                   	push   %edx
 672:	57                   	push   %edi
 673:	e8 8b fd ff ff       	call   403 <write>
        putc(fd, c);
 678:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67b:	31 d2                	xor    %edx,%edx
 67d:	eb 8e                	jmp    60d <printf+0x4d>
 67f:	90                   	nop
        printint(fd, *ap, 16, 0);
 680:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 683:	83 ec 0c             	sub    $0xc,%esp
 686:	b9 10 00 00 00       	mov    $0x10,%ecx
 68b:	8b 13                	mov    (%ebx),%edx
 68d:	6a 00                	push   $0x0
 68f:	89 f8                	mov    %edi,%eax
        ap++;
 691:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 694:	e8 87 fe ff ff       	call   520 <printint>
        ap++;
 699:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 69c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69f:	31 d2                	xor    %edx,%edx
 6a1:	e9 67 ff ff ff       	jmp    60d <printf+0x4d>
        s = (char*)*ap;
 6a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6a9:	8b 18                	mov    (%eax),%ebx
        ap++;
 6ab:	83 c0 04             	add    $0x4,%eax
 6ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6b1:	85 db                	test   %ebx,%ebx
 6b3:	0f 84 87 00 00 00    	je     740 <printf+0x180>
        while(*s != 0){
 6b9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6bc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6be:	84 c0                	test   %al,%al
 6c0:	0f 84 47 ff ff ff    	je     60d <printf+0x4d>
 6c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6c9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6cc:	89 de                	mov    %ebx,%esi
 6ce:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6d6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6d9:	6a 01                	push   $0x1
 6db:	53                   	push   %ebx
 6dc:	57                   	push   %edi
 6dd:	e8 21 fd ff ff       	call   403 <write>
        while(*s != 0){
 6e2:	0f b6 06             	movzbl (%esi),%eax
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	84 c0                	test   %al,%al
 6ea:	75 e4                	jne    6d0 <printf+0x110>
      state = 0;
 6ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	e9 17 ff ff ff       	jmp    60d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6f6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6f9:	83 ec 0c             	sub    $0xc,%esp
 6fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 701:	8b 13                	mov    (%ebx),%edx
 703:	6a 01                	push   $0x1
 705:	eb 88                	jmp    68f <printf+0xcf>
        putc(fd, *ap);
 707:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 70a:	83 ec 04             	sub    $0x4,%esp
 70d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 710:	8b 03                	mov    (%ebx),%eax
        ap++;
 712:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 715:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 718:	6a 01                	push   $0x1
 71a:	52                   	push   %edx
 71b:	57                   	push   %edi
 71c:	e8 e2 fc ff ff       	call   403 <write>
        ap++;
 721:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 724:	83 c4 10             	add    $0x10,%esp
      state = 0;
 727:	31 d2                	xor    %edx,%edx
 729:	e9 df fe ff ff       	jmp    60d <printf+0x4d>
 72e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
 733:	88 5d e7             	mov    %bl,-0x19(%ebp)
 736:	8d 55 e7             	lea    -0x19(%ebp),%edx
 739:	6a 01                	push   $0x1
 73b:	e9 31 ff ff ff       	jmp    671 <printf+0xb1>
 740:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 745:	bb 43 09 00 00       	mov    $0x943,%ebx
 74a:	e9 77 ff ff ff       	jmp    6c6 <printf+0x106>
 74f:	90                   	nop

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 68 0d 00 00       	mov    0xd68,%eax
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 75e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	39 c8                	cmp    %ecx,%eax
 76c:	73 32                	jae    7a0 <free+0x50>
 76e:	39 d1                	cmp    %edx,%ecx
 770:	72 04                	jb     776 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	39 d0                	cmp    %edx,%eax
 774:	72 32                	jb     7a8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 776:	8b 73 fc             	mov    -0x4(%ebx),%esi
 779:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77c:	39 fa                	cmp    %edi,%edx
 77e:	74 30                	je     7b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 783:	8b 50 04             	mov    0x4(%eax),%edx
 786:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 789:	39 f1                	cmp    %esi,%ecx
 78b:	74 3a                	je     7c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 78d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 78f:	5b                   	pop    %ebx
  freep = p;
 790:	a3 68 0d 00 00       	mov    %eax,0xd68
}
 795:	5e                   	pop    %esi
 796:	5f                   	pop    %edi
 797:	5d                   	pop    %ebp
 798:	c3                   	ret
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 d0                	cmp    %edx,%eax
 7a2:	72 04                	jb     7a8 <free+0x58>
 7a4:	39 d1                	cmp    %edx,%ecx
 7a6:	72 ce                	jb     776 <free+0x26>
{
 7a8:	89 d0                	mov    %edx,%eax
 7aa:	eb bc                	jmp    768 <free+0x18>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7b0:	03 72 04             	add    0x4(%edx),%esi
 7b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	8b 12                	mov    (%edx),%edx
 7ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	75 c6                	jne    78d <free+0x3d>
    p->s.size += bp->s.size;
 7c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ca:	a3 68 0d 00 00       	mov    %eax,0xd68
    p->s.size += bp->s.size;
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7d5:	89 08                	mov    %ecx,(%eax)
}
 7d7:	5b                   	pop    %ebx
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 15 68 0d 00 00    	mov    0xd68,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 78 07             	lea    0x7(%eax),%edi
 7f5:	c1 ef 03             	shr    $0x3,%edi
 7f8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7fb:	85 d2                	test   %edx,%edx
 7fd:	0f 84 8d 00 00 00    	je     890 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 803:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 805:	8b 48 04             	mov    0x4(%eax),%ecx
 808:	39 f9                	cmp    %edi,%ecx
 80a:	73 64                	jae    870 <malloc+0x90>
  if(nu < 4096)
 80c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 811:	39 df                	cmp    %ebx,%edi
 813:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 816:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 81d:	eb 0a                	jmp    829 <malloc+0x49>
 81f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 822:	8b 48 04             	mov    0x4(%eax),%ecx
 825:	39 f9                	cmp    %edi,%ecx
 827:	73 47                	jae    870 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 829:	89 c2                	mov    %eax,%edx
 82b:	3b 05 68 0d 00 00    	cmp    0xd68,%eax
 831:	75 ed                	jne    820 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	56                   	push   %esi
 837:	e8 2f fc ff ff       	call   46b <sbrk>
  if(p == (char*)-1)
 83c:	83 c4 10             	add    $0x10,%esp
 83f:	83 f8 ff             	cmp    $0xffffffff,%eax
 842:	74 1c                	je     860 <malloc+0x80>
  hp->s.size = nu;
 844:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 847:	83 ec 0c             	sub    $0xc,%esp
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	50                   	push   %eax
 84e:	e8 fd fe ff ff       	call   750 <free>
  return freep;
 853:	8b 15 68 0d 00 00    	mov    0xd68,%edx
      if((p = morecore(nunits)) == 0)
 859:	83 c4 10             	add    $0x10,%esp
 85c:	85 d2                	test   %edx,%edx
 85e:	75 c0                	jne    820 <malloc+0x40>
        return 0;
  }
}
 860:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 863:	31 c0                	xor    %eax,%eax
}
 865:	5b                   	pop    %ebx
 866:	5e                   	pop    %esi
 867:	5f                   	pop    %edi
 868:	5d                   	pop    %ebp
 869:	c3                   	ret
 86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 870:	39 cf                	cmp    %ecx,%edi
 872:	74 4c                	je     8c0 <malloc+0xe0>
        p->s.size -= nunits;
 874:	29 f9                	sub    %edi,%ecx
 876:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 879:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 87c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 87f:	89 15 68 0d 00 00    	mov    %edx,0xd68
}
 885:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 888:	83 c0 08             	add    $0x8,%eax
}
 88b:	5b                   	pop    %ebx
 88c:	5e                   	pop    %esi
 88d:	5f                   	pop    %edi
 88e:	5d                   	pop    %ebp
 88f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 890:	c7 05 68 0d 00 00 6c 	movl   $0xd6c,0xd68
 897:	0d 00 00 
    base.s.size = 0;
 89a:	b8 6c 0d 00 00       	mov    $0xd6c,%eax
    base.s.ptr = freep = prevp = &base;
 89f:	c7 05 6c 0d 00 00 6c 	movl   $0xd6c,0xd6c
 8a6:	0d 00 00 
    base.s.size = 0;
 8a9:	c7 05 70 0d 00 00 00 	movl   $0x0,0xd70
 8b0:	00 00 00 
    if(p->s.size >= nunits){
 8b3:	e9 54 ff ff ff       	jmp    80c <malloc+0x2c>
 8b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8bf:	00 
        prevp->s.ptr = p->s.ptr;
 8c0:	8b 08                	mov    (%eax),%ecx
 8c2:	89 0a                	mov    %ecx,(%edx)
 8c4:	eb b9                	jmp    87f <malloc+0x9f>
