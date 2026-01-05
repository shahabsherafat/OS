
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	be 01 00 00 00       	mov    $0x1,%esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  21:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  24:	83 f8 01             	cmp    $0x1,%eax
  27:	7f 28                	jg     51 <main+0x51>
  29:	eb 54                	jmp    7f <main+0x7f>
  2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  30:	83 ec 08             	sub    $0x8,%esp
  33:	ff 33                	push   (%ebx)
  for(i = 1; i < argc; i++){
  35:	83 c6 01             	add    $0x1,%esi
  38:	83 c3 04             	add    $0x4,%ebx
    wc(fd, argv[i]);
  3b:	50                   	push   %eax
  3c:	e8 5f 00 00 00       	call   a0 <wc>
    close(fd);
  41:	89 3c 24             	mov    %edi,(%esp)
  44:	e8 b2 03 00 00       	call   3fb <close>
  for(i = 1; i < argc; i++){
  49:	83 c4 10             	add    $0x10,%esp
  4c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  4f:	74 29                	je     7a <main+0x7a>
    if((fd = open(argv[i], 0)) < 0){
  51:	83 ec 08             	sub    $0x8,%esp
  54:	6a 00                	push   $0x0
  56:	ff 33                	push   (%ebx)
  58:	e8 b6 03 00 00       	call   413 <open>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	89 c7                	mov    %eax,%edi
  62:	85 c0                	test   %eax,%eax
  64:	79 ca                	jns    30 <main+0x30>
      printf(1, "wc: cannot open %s\n", argv[i]);
  66:	50                   	push   %eax
  67:	ff 33                	push   (%ebx)
  69:	68 db 08 00 00       	push   $0x8db
  6e:	6a 01                	push   $0x1
  70:	e8 3b 05 00 00       	call   5b0 <printf>
      exit();
  75:	e8 59 03 00 00       	call   3d3 <exit>
  }
  exit();
  7a:	e8 54 03 00 00       	call   3d3 <exit>
    wc(0, "");
  7f:	52                   	push   %edx
  80:	52                   	push   %edx
  81:	68 cd 08 00 00       	push   $0x8cd
  86:	6a 00                	push   $0x0
  88:	e8 13 00 00 00       	call   a0 <wc>
    exit();
  8d:	e8 41 03 00 00       	call   3d3 <exit>
  92:	66 90                	xchg   %ax,%ax
  94:	66 90                	xchg   %ax,%ax
  96:	66 90                	xchg   %ax,%ax
  98:	66 90                	xchg   %ax,%ax
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <wc>:
{
  a0:	55                   	push   %ebp
  l = w = c = 0;
  a1:	31 d2                	xor    %edx,%edx
{
  a3:	89 e5                	mov    %esp,%ebp
  a5:	57                   	push   %edi
  a6:	56                   	push   %esi
  inword = 0;
  a7:	31 f6                	xor    %esi,%esi
{
  a9:	53                   	push   %ebx
  l = w = c = 0;
  aa:	31 db                	xor    %ebx,%ebx
{
  ac:	83 ec 1c             	sub    $0x1c,%esp
  l = w = c = 0;
  af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	68 00 02 00 00       	push   $0x200
  c8:	68 40 0c 00 00       	push   $0xc40
  cd:	ff 75 08             	push   0x8(%ebp)
  d0:	e8 16 03 00 00       	call   3eb <read>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	89 c1                	mov    %eax,%ecx
  da:	85 c0                	test   %eax,%eax
  dc:	7e 62                	jle    140 <wc+0xa0>
    for(i=0; i<n; i++){
  de:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  e1:	31 ff                	xor    %edi,%edi
  e3:	eb 0d                	jmp    f2 <wc+0x52>
  e5:	8d 76 00             	lea    0x0(%esi),%esi
        inword = 0;
  e8:	31 f6                	xor    %esi,%esi
    for(i=0; i<n; i++){
  ea:	83 c7 01             	add    $0x1,%edi
  ed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  f0:	74 3e                	je     130 <wc+0x90>
      if(buf[i] == '\n')
  f2:	0f be 87 40 0c 00 00 	movsbl 0xc40(%edi),%eax
        l++;
  f9:	31 c9                	xor    %ecx,%ecx
  fb:	3c 0a                	cmp    $0xa,%al
  fd:	0f 94 c1             	sete   %cl
      if(strchr(" \r\t\n\v", buf[i]))
 100:	83 ec 08             	sub    $0x8,%esp
 103:	50                   	push   %eax
        l++;
 104:	01 cb                	add    %ecx,%ebx
      if(strchr(" \r\t\n\v", buf[i]))
 106:	68 b8 08 00 00       	push   $0x8b8
 10b:	e8 50 01 00 00       	call   260 <strchr>
 110:	83 c4 10             	add    $0x10,%esp
 113:	85 c0                	test   %eax,%eax
 115:	75 d1                	jne    e8 <wc+0x48>
      else if(!inword){
 117:	85 f6                	test   %esi,%esi
 119:	75 cf                	jne    ea <wc+0x4a>
        w++;
 11b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
 11f:	be 01 00 00 00       	mov    $0x1,%esi
    for(i=0; i<n; i++){
 124:	83 c7 01             	add    $0x1,%edi
 127:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 12a:	75 c6                	jne    f2 <wc+0x52>
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 130:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 133:	01 4d dc             	add    %ecx,-0x24(%ebp)
 136:	eb 88                	jmp    c0 <wc+0x20>
 138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13f:	00 
  if(n < 0){
 140:	8b 55 dc             	mov    -0x24(%ebp),%edx
 143:	75 22                	jne    167 <wc+0xc7>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 145:	83 ec 08             	sub    $0x8,%esp
 148:	ff 75 0c             	push   0xc(%ebp)
 14b:	52                   	push   %edx
 14c:	ff 75 e0             	push   -0x20(%ebp)
 14f:	53                   	push   %ebx
 150:	68 ce 08 00 00       	push   $0x8ce
 155:	6a 01                	push   $0x1
 157:	e8 54 04 00 00       	call   5b0 <printf>
}
 15c:	83 c4 20             	add    $0x20,%esp
 15f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 162:	5b                   	pop    %ebx
 163:	5e                   	pop    %esi
 164:	5f                   	pop    %edi
 165:	5d                   	pop    %ebp
 166:	c3                   	ret
    printf(1, "wc: read error\n");
 167:	50                   	push   %eax
 168:	50                   	push   %eax
 169:	68 be 08 00 00       	push   $0x8be
 16e:	6a 01                	push   $0x1
 170:	e8 3b 04 00 00       	call   5b0 <printf>
    exit();
 175:	e8 59 02 00 00       	call   3d3 <exit>
 17a:	66 90                	xchg   %ax,%ax
 17c:	66 90                	xchg   %ax,%ax
 17e:	66 90                	xchg   %ax,%ax

00000180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 180:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 181:	31 c0                	xor    %eax,%eax
{
 183:	89 e5                	mov    %esp,%ebp
 185:	53                   	push   %ebx
 186:	8b 4d 08             	mov    0x8(%ebp),%ecx
 189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 190:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 194:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 197:	83 c0 01             	add    $0x1,%eax
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strcpy+0x10>
    ;
  return os;
}
 19e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a1:	89 c8                	mov    %ecx,%eax
 1a3:	c9                   	leave
 1a4:	c3                   	ret
 1a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ac:	00 
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ba:	0f b6 02             	movzbl (%edx),%eax
 1bd:	84 c0                	test   %al,%al
 1bf:	75 17                	jne    1d8 <strcmp+0x28>
 1c1:	eb 3a                	jmp    1fd <strcmp+0x4d>
 1c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 1c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1cc:	83 c2 01             	add    $0x1,%edx
 1cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1d2:	84 c0                	test   %al,%al
 1d4:	74 1a                	je     1f0 <strcmp+0x40>
 1d6:	89 d9                	mov    %ebx,%ecx
 1d8:	0f b6 19             	movzbl (%ecx),%ebx
 1db:	38 c3                	cmp    %al,%bl
 1dd:	74 e9                	je     1c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1df:	29 d8                	sub    %ebx,%eax
}
 1e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e4:	c9                   	leave
 1e5:	c3                   	ret
 1e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ed:	00 
 1ee:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 1f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1f4:	31 c0                	xor    %eax,%eax
 1f6:	29 d8                	sub    %ebx,%eax
}
 1f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1fb:	c9                   	leave
 1fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 1fd:	0f b6 19             	movzbl (%ecx),%ebx
 200:	31 c0                	xor    %eax,%eax
 202:	eb db                	jmp    1df <strcmp+0x2f>
 204:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20b:	00 
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <strlen>:

uint
strlen(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 216:	80 3a 00             	cmpb   $0x0,(%edx)
 219:	74 15                	je     230 <strlen+0x20>
 21b:	31 c0                	xor    %eax,%eax
 21d:	8d 76 00             	lea    0x0(%esi),%esi
 220:	83 c0 01             	add    $0x1,%eax
 223:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 227:	89 c1                	mov    %eax,%ecx
 229:	75 f5                	jne    220 <strlen+0x10>
    ;
  return n;
}
 22b:	89 c8                	mov    %ecx,%eax
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret
 22f:	90                   	nop
  for(n = 0; s[n]; n++)
 230:	31 c9                	xor    %ecx,%ecx
}
 232:	5d                   	pop    %ebp
 233:	89 c8                	mov    %ecx,%eax
 235:	c3                   	ret
 236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 23d:	00 
 23e:	66 90                	xchg   %ax,%ax

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 247:	8b 4d 10             	mov    0x10(%ebp),%ecx
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 d7                	mov    %edx,%edi
 24f:	fc                   	cld
 250:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 252:	8b 7d fc             	mov    -0x4(%ebp),%edi
 255:	89 d0                	mov    %edx,%eax
 257:	c9                   	leave
 258:	c3                   	ret
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 26a:	0f b6 10             	movzbl (%eax),%edx
 26d:	84 d2                	test   %dl,%dl
 26f:	75 12                	jne    283 <strchr+0x23>
 271:	eb 1d                	jmp    290 <strchr+0x30>
 273:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 278:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 27c:	83 c0 01             	add    $0x1,%eax
 27f:	84 d2                	test   %dl,%dl
 281:	74 0d                	je     290 <strchr+0x30>
    if(*s == c)
 283:	38 d1                	cmp    %dl,%cl
 285:	75 f1                	jne    278 <strchr+0x18>
      return (char*)s;
  return 0;
}
 287:	5d                   	pop    %ebp
 288:	c3                   	ret
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 290:	31 c0                	xor    %eax,%eax
}
 292:	5d                   	pop    %ebp
 293:	c3                   	ret
 294:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29b:	00 
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <gets>:

char*
gets(char *buf, int max)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2a9:	31 db                	xor    %ebx,%ebx
 2ab:	8d 73 01             	lea    0x1(%ebx),%esi
{
 2ae:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2b1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2b4:	7d 3b                	jge    2f1 <gets+0x51>
 2b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bd:	00 
 2be:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	6a 01                	push   $0x1
 2c5:	57                   	push   %edi
 2c6:	6a 00                	push   $0x0
 2c8:	e8 1e 01 00 00       	call   3eb <read>
    if(cc < 1)
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	85 c0                	test   %eax,%eax
 2d2:	7e 1d                	jle    2f1 <gets+0x51>
      break;
      
    buf[i++] = c;
 2d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2d8:	8b 55 08             	mov    0x8(%ebp),%edx
 2db:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 2df:	3c 0a                	cmp    $0xa,%al
 2e1:	7f 25                	jg     308 <gets+0x68>
 2e3:	3c 08                	cmp    $0x8,%al
 2e5:	7f 0c                	jg     2f3 <gets+0x53>
{
 2e7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 2e9:	8d 73 01             	lea    0x1(%ebx),%esi
 2ec:	3b 75 0c             	cmp    0xc(%ebp),%esi
 2ef:	7c cf                	jl     2c0 <gets+0x20>
 2f1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret
 302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 308:	3c 0d                	cmp    $0xd,%al
 30a:	74 e7                	je     2f3 <gets+0x53>
{
 30c:	89 f3                	mov    %esi,%ebx
 30e:	eb d9                	jmp    2e9 <gets+0x49>

00000310 <stat>:

int
stat(const char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 315:	83 ec 08             	sub    $0x8,%esp
 318:	6a 00                	push   $0x0
 31a:	ff 75 08             	push   0x8(%ebp)
 31d:	e8 f1 00 00 00       	call   413 <open>
  if(fd < 0)
 322:	83 c4 10             	add    $0x10,%esp
 325:	85 c0                	test   %eax,%eax
 327:	78 27                	js     350 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	ff 75 0c             	push   0xc(%ebp)
 32f:	89 c3                	mov    %eax,%ebx
 331:	50                   	push   %eax
 332:	e8 f4 00 00 00       	call   42b <fstat>
  close(fd);
 337:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 33a:	89 c6                	mov    %eax,%esi
  close(fd);
 33c:	e8 ba 00 00 00       	call   3fb <close>
  return r;
 341:	83 c4 10             	add    $0x10,%esp
}
 344:	8d 65 f8             	lea    -0x8(%ebp),%esp
 347:	89 f0                	mov    %esi,%eax
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret
 34d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 350:	be ff ff ff ff       	mov    $0xffffffff,%esi
 355:	eb ed                	jmp    344 <stat+0x34>
 357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35e:	00 
 35f:	90                   	nop

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 367:	0f be 02             	movsbl (%edx),%eax
 36a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 36d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 370:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 375:	77 1e                	ja     395 <atoi+0x35>
 377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37e:	00 
 37f:	90                   	nop
    n = n*10 + *s++ - '0';
 380:	83 c2 01             	add    $0x1,%edx
 383:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 386:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 38a:	0f be 02             	movsbl (%edx),%eax
 38d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 390:	80 fb 09             	cmp    $0x9,%bl
 393:	76 eb                	jbe    380 <atoi+0x20>
  return n;
}
 395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 398:	89 c8                	mov    %ecx,%eax
 39a:	c9                   	leave
 39b:	c3                   	ret
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 45 10             	mov    0x10(%ebp),%eax
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
 3aa:	56                   	push   %esi
 3ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ae:	85 c0                	test   %eax,%eax
 3b0:	7e 13                	jle    3c5 <memmove+0x25>
 3b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3b4:	89 d7                	mov    %edx,%edi
 3b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bd:	00 
 3be:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3c1:	39 f8                	cmp    %edi,%eax
 3c3:	75 fb                	jne    3c0 <memmove+0x20>
  return vdst;
}
 3c5:	5e                   	pop    %esi
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret

000003cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3cb:	b8 01 00 00 00       	mov    $0x1,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret

000003d3 <exit>:
SYSCALL(exit)
 3d3:	b8 02 00 00 00       	mov    $0x2,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret

000003db <wait>:
SYSCALL(wait)
 3db:	b8 03 00 00 00       	mov    $0x3,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret

000003e3 <pipe>:
SYSCALL(pipe)
 3e3:	b8 04 00 00 00       	mov    $0x4,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret

000003eb <read>:
SYSCALL(read)
 3eb:	b8 05 00 00 00       	mov    $0x5,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret

000003f3 <write>:
SYSCALL(write)
 3f3:	b8 10 00 00 00       	mov    $0x10,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret

000003fb <close>:
SYSCALL(close)
 3fb:	b8 15 00 00 00       	mov    $0x15,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <kill>:
SYSCALL(kill)
 403:	b8 06 00 00 00       	mov    $0x6,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <exec>:
SYSCALL(exec)
 40b:	b8 07 00 00 00       	mov    $0x7,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <open>:
SYSCALL(open)
 413:	b8 0f 00 00 00       	mov    $0xf,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <mknod>:
SYSCALL(mknod)
 41b:	b8 11 00 00 00       	mov    $0x11,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <unlink>:
SYSCALL(unlink)
 423:	b8 12 00 00 00       	mov    $0x12,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <fstat>:
SYSCALL(fstat)
 42b:	b8 08 00 00 00       	mov    $0x8,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <link>:
SYSCALL(link)
 433:	b8 13 00 00 00       	mov    $0x13,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <mkdir>:
SYSCALL(mkdir)
 43b:	b8 14 00 00 00       	mov    $0x14,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <chdir>:
SYSCALL(chdir)
 443:	b8 09 00 00 00       	mov    $0x9,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <dup>:
SYSCALL(dup)
 44b:	b8 0a 00 00 00       	mov    $0xa,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <getpid>:
SYSCALL(getpid)
 453:	b8 0b 00 00 00       	mov    $0xb,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <sbrk>:
SYSCALL(sbrk)
 45b:	b8 0c 00 00 00       	mov    $0xc,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <sleep>:
SYSCALL(sleep)
 463:	b8 0d 00 00 00       	mov    $0xd,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <uptime>:
SYSCALL(uptime)
 46b:	b8 0e 00 00 00       	mov    $0xe,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 473:	b8 17 00 00 00       	mov    $0x17,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <show_process_family>:
SYSCALL(show_process_family)
 47b:	b8 18 00 00 00       	mov    $0x18,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 483:	b8 16 00 00 00       	mov    $0x16,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <grep_syscall>:
SYSCALL(grep_syscall)
 48b:	b8 19 00 00 00       	mov    $0x19,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 493:	b8 1a 00 00 00       	mov    $0x1a,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 49b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 4a3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 4ab:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 4b3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 4bb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 4c3:	b8 20 00 00 00       	mov    $0x20,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 4cb:	b8 21 00 00 00       	mov    $0x21,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 4d3:	b8 22 00 00 00       	mov    $0x22,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <getlockstat>:

SYSCALL(getlockstat)
 4db:	b8 23 00 00 00       	mov    $0x23,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <vread>:

SYSCALL(vread)
 4e3:	b8 24 00 00 00       	mov    $0x24,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <vwrite>:
SYSCALL(vwrite)
 4eb:	b8 25 00 00 00       	mov    $0x25,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 4f3:	b8 26 00 00 00       	mov    $0x26,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <cptresetstats>:
SYSCALL(cptresetstats)
 4fb:	b8 27 00 00 00       	mov    $0x27,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <cptgetstats>:
SYSCALL(cptgetstats)
 503:	b8 28 00 00 00       	mov    $0x28,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 518:	89 d1                	mov    %edx,%ecx
{
 51a:	83 ec 3c             	sub    $0x3c,%esp
 51d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 520:	85 d2                	test   %edx,%edx
 522:	0f 89 80 00 00 00    	jns    5a8 <printint+0x98>
 528:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 52c:	74 7a                	je     5a8 <printint+0x98>
    x = -xx;
 52e:	f7 d9                	neg    %ecx
    neg = 1;
 530:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 535:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 538:	31 f6                	xor    %esi,%esi
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 540:	89 c8                	mov    %ecx,%eax
 542:	31 d2                	xor    %edx,%edx
 544:	89 f7                	mov    %esi,%edi
 546:	f7 f3                	div    %ebx
 548:	8d 76 01             	lea    0x1(%esi),%esi
 54b:	0f b6 92 50 09 00 00 	movzbl 0x950(%edx),%edx
 552:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 556:	89 ca                	mov    %ecx,%edx
 558:	89 c1                	mov    %eax,%ecx
 55a:	39 da                	cmp    %ebx,%edx
 55c:	73 e2                	jae    540 <printint+0x30>
  if(neg)
 55e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 561:	85 c0                	test   %eax,%eax
 563:	74 07                	je     56c <printint+0x5c>
    buf[i++] = '-';
 565:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 56a:	89 f7                	mov    %esi,%edi
 56c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 56f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 572:	01 df                	add    %ebx,%edi
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 578:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 57b:	83 ec 04             	sub    $0x4,%esp
 57e:	88 45 d7             	mov    %al,-0x29(%ebp)
 581:	8d 45 d7             	lea    -0x29(%ebp),%eax
 584:	6a 01                	push   $0x1
 586:	50                   	push   %eax
 587:	56                   	push   %esi
 588:	e8 66 fe ff ff       	call   3f3 <write>
  while(--i >= 0)
 58d:	89 f8                	mov    %edi,%eax
 58f:	83 c4 10             	add    $0x10,%esp
 592:	83 ef 01             	sub    $0x1,%edi
 595:	39 c3                	cmp    %eax,%ebx
 597:	75 df                	jne    578 <printint+0x68>
}
 599:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59c:	5b                   	pop    %ebx
 59d:	5e                   	pop    %esi
 59e:	5f                   	pop    %edi
 59f:	5d                   	pop    %ebp
 5a0:	c3                   	ret
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	31 c0                	xor    %eax,%eax
 5aa:	eb 89                	jmp    535 <printint+0x25>
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 5bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 5bf:	0f b6 1e             	movzbl (%esi),%ebx
 5c2:	83 c6 01             	add    $0x1,%esi
 5c5:	84 db                	test   %bl,%bl
 5c7:	74 67                	je     630 <printf+0x80>
 5c9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5cc:	31 d2                	xor    %edx,%edx
 5ce:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 5d1:	eb 34                	jmp    607 <printf+0x57>
 5d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5db:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5e0:	83 f8 25             	cmp    $0x25,%eax
 5e3:	74 18                	je     5fd <printf+0x4d>
  write(fd, &c, 1);
 5e5:	83 ec 04             	sub    $0x4,%esp
 5e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5eb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5ee:	6a 01                	push   $0x1
 5f0:	50                   	push   %eax
 5f1:	57                   	push   %edi
 5f2:	e8 fc fd ff ff       	call   3f3 <write>
 5f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5fd:	0f b6 1e             	movzbl (%esi),%ebx
 600:	83 c6 01             	add    $0x1,%esi
 603:	84 db                	test   %bl,%bl
 605:	74 29                	je     630 <printf+0x80>
    c = fmt[i] & 0xff;
 607:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 60a:	85 d2                	test   %edx,%edx
 60c:	74 ca                	je     5d8 <printf+0x28>
      }
    } else if(state == '%'){
 60e:	83 fa 25             	cmp    $0x25,%edx
 611:	75 ea                	jne    5fd <printf+0x4d>
      if(c == 'd'){
 613:	83 f8 25             	cmp    $0x25,%eax
 616:	0f 84 04 01 00 00    	je     720 <printf+0x170>
 61c:	83 e8 63             	sub    $0x63,%eax
 61f:	83 f8 15             	cmp    $0x15,%eax
 622:	77 1c                	ja     640 <printf+0x90>
 624:	ff 24 85 f8 08 00 00 	jmp    *0x8f8(,%eax,4)
 62b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 630:	8d 65 f4             	lea    -0xc(%ebp),%esp
 633:	5b                   	pop    %ebx
 634:	5e                   	pop    %esi
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret
 638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 63f:	00 
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	8d 55 e7             	lea    -0x19(%ebp),%edx
 646:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64a:	6a 01                	push   $0x1
 64c:	52                   	push   %edx
 64d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 650:	57                   	push   %edi
 651:	e8 9d fd ff ff       	call   3f3 <write>
 656:	83 c4 0c             	add    $0xc,%esp
 659:	88 5d e7             	mov    %bl,-0x19(%ebp)
 65c:	6a 01                	push   $0x1
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 661:	52                   	push   %edx
 662:	57                   	push   %edi
 663:	e8 8b fd ff ff       	call   3f3 <write>
        putc(fd, c);
 668:	83 c4 10             	add    $0x10,%esp
      state = 0;
 66b:	31 d2                	xor    %edx,%edx
 66d:	eb 8e                	jmp    5fd <printf+0x4d>
 66f:	90                   	nop
        printint(fd, *ap, 16, 0);
 670:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 673:	83 ec 0c             	sub    $0xc,%esp
 676:	b9 10 00 00 00       	mov    $0x10,%ecx
 67b:	8b 13                	mov    (%ebx),%edx
 67d:	6a 00                	push   $0x0
 67f:	89 f8                	mov    %edi,%eax
        ap++;
 681:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 684:	e8 87 fe ff ff       	call   510 <printint>
        ap++;
 689:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 68c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68f:	31 d2                	xor    %edx,%edx
 691:	e9 67 ff ff ff       	jmp    5fd <printf+0x4d>
        s = (char*)*ap;
 696:	8b 45 d0             	mov    -0x30(%ebp),%eax
 699:	8b 18                	mov    (%eax),%ebx
        ap++;
 69b:	83 c0 04             	add    $0x4,%eax
 69e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6a1:	85 db                	test   %ebx,%ebx
 6a3:	0f 84 87 00 00 00    	je     730 <printf+0x180>
        while(*s != 0){
 6a9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 6ac:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 6ae:	84 c0                	test   %al,%al
 6b0:	0f 84 47 ff ff ff    	je     5fd <printf+0x4d>
 6b6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6b9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 6bc:	89 de                	mov    %ebx,%esi
 6be:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 6c6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6c9:	6a 01                	push   $0x1
 6cb:	53                   	push   %ebx
 6cc:	57                   	push   %edi
 6cd:	e8 21 fd ff ff       	call   3f3 <write>
        while(*s != 0){
 6d2:	0f b6 06             	movzbl (%esi),%eax
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	84 c0                	test   %al,%al
 6da:	75 e4                	jne    6c0 <printf+0x110>
      state = 0;
 6dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 17 ff ff ff       	jmp    5fd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 6e6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6e9:	83 ec 0c             	sub    $0xc,%esp
 6ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f1:	8b 13                	mov    (%ebx),%edx
 6f3:	6a 01                	push   $0x1
 6f5:	eb 88                	jmp    67f <printf+0xcf>
        putc(fd, *ap);
 6f7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6fa:	83 ec 04             	sub    $0x4,%esp
 6fd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 700:	8b 03                	mov    (%ebx),%eax
        ap++;
 702:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 705:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
 70a:	52                   	push   %edx
 70b:	57                   	push   %edi
 70c:	e8 e2 fc ff ff       	call   3f3 <write>
        ap++;
 711:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 714:	83 c4 10             	add    $0x10,%esp
      state = 0;
 717:	31 d2                	xor    %edx,%edx
 719:	e9 df fe ff ff       	jmp    5fd <printf+0x4d>
 71e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
 723:	88 5d e7             	mov    %bl,-0x19(%ebp)
 726:	8d 55 e7             	lea    -0x19(%ebp),%edx
 729:	6a 01                	push   $0x1
 72b:	e9 31 ff ff ff       	jmp    661 <printf+0xb1>
 730:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 735:	bb ef 08 00 00       	mov    $0x8ef,%ebx
 73a:	e9 77 ff ff ff       	jmp    6b6 <printf+0x106>
 73f:	90                   	nop

00000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 40 0e 00 00       	mov    0xe40,%eax
{
 746:	89 e5                	mov    %esp,%ebp
 748:	57                   	push   %edi
 749:	56                   	push   %esi
 74a:	53                   	push   %ebx
 74b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 74e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 758:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	39 c8                	cmp    %ecx,%eax
 75c:	73 32                	jae    790 <free+0x50>
 75e:	39 d1                	cmp    %edx,%ecx
 760:	72 04                	jb     766 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	39 d0                	cmp    %edx,%eax
 764:	72 32                	jb     798 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 766:	8b 73 fc             	mov    -0x4(%ebx),%esi
 769:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 76c:	39 fa                	cmp    %edi,%edx
 76e:	74 30                	je     7a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 773:	8b 50 04             	mov    0x4(%eax),%edx
 776:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 779:	39 f1                	cmp    %esi,%ecx
 77b:	74 3a                	je     7b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 77d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 77f:	5b                   	pop    %ebx
  freep = p;
 780:	a3 40 0e 00 00       	mov    %eax,0xe40
}
 785:	5e                   	pop    %esi
 786:	5f                   	pop    %edi
 787:	5d                   	pop    %ebp
 788:	c3                   	ret
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 d0                	cmp    %edx,%eax
 792:	72 04                	jb     798 <free+0x58>
 794:	39 d1                	cmp    %edx,%ecx
 796:	72 ce                	jb     766 <free+0x26>
{
 798:	89 d0                	mov    %edx,%eax
 79a:	eb bc                	jmp    758 <free+0x18>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 7a0:	03 72 04             	add    0x4(%edx),%esi
 7a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	8b 10                	mov    (%eax),%edx
 7a8:	8b 12                	mov    (%edx),%edx
 7aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b3:	39 f1                	cmp    %esi,%ecx
 7b5:	75 c6                	jne    77d <free+0x3d>
    p->s.size += bp->s.size;
 7b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ba:	a3 40 0e 00 00       	mov    %eax,0xe40
    p->s.size += bp->s.size;
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7c5:	89 08                	mov    %ecx,(%eax)
}
 7c7:	5b                   	pop    %ebx
 7c8:	5e                   	pop    %esi
 7c9:	5f                   	pop    %edi
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7dc:	8b 15 40 0e 00 00    	mov    0xe40,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8d 78 07             	lea    0x7(%eax),%edi
 7e5:	c1 ef 03             	shr    $0x3,%edi
 7e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7eb:	85 d2                	test   %edx,%edx
 7ed:	0f 84 8d 00 00 00    	je     880 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7f5:	8b 48 04             	mov    0x4(%eax),%ecx
 7f8:	39 f9                	cmp    %edi,%ecx
 7fa:	73 64                	jae    860 <malloc+0x90>
  if(nu < 4096)
 7fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 801:	39 df                	cmp    %ebx,%edi
 803:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 806:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 80d:	eb 0a                	jmp    819 <malloc+0x49>
 80f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 812:	8b 48 04             	mov    0x4(%eax),%ecx
 815:	39 f9                	cmp    %edi,%ecx
 817:	73 47                	jae    860 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 819:	89 c2                	mov    %eax,%edx
 81b:	3b 05 40 0e 00 00    	cmp    0xe40,%eax
 821:	75 ed                	jne    810 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 823:	83 ec 0c             	sub    $0xc,%esp
 826:	56                   	push   %esi
 827:	e8 2f fc ff ff       	call   45b <sbrk>
  if(p == (char*)-1)
 82c:	83 c4 10             	add    $0x10,%esp
 82f:	83 f8 ff             	cmp    $0xffffffff,%eax
 832:	74 1c                	je     850 <malloc+0x80>
  hp->s.size = nu;
 834:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 837:	83 ec 0c             	sub    $0xc,%esp
 83a:	83 c0 08             	add    $0x8,%eax
 83d:	50                   	push   %eax
 83e:	e8 fd fe ff ff       	call   740 <free>
  return freep;
 843:	8b 15 40 0e 00 00    	mov    0xe40,%edx
      if((p = morecore(nunits)) == 0)
 849:	83 c4 10             	add    $0x10,%esp
 84c:	85 d2                	test   %edx,%edx
 84e:	75 c0                	jne    810 <malloc+0x40>
        return 0;
  }
}
 850:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 853:	31 c0                	xor    %eax,%eax
}
 855:	5b                   	pop    %ebx
 856:	5e                   	pop    %esi
 857:	5f                   	pop    %edi
 858:	5d                   	pop    %ebp
 859:	c3                   	ret
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 860:	39 cf                	cmp    %ecx,%edi
 862:	74 4c                	je     8b0 <malloc+0xe0>
        p->s.size -= nunits;
 864:	29 f9                	sub    %edi,%ecx
 866:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 869:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 86c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 86f:	89 15 40 0e 00 00    	mov    %edx,0xe40
}
 875:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 878:	83 c0 08             	add    $0x8,%eax
}
 87b:	5b                   	pop    %ebx
 87c:	5e                   	pop    %esi
 87d:	5f                   	pop    %edi
 87e:	5d                   	pop    %ebp
 87f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 880:	c7 05 40 0e 00 00 44 	movl   $0xe44,0xe40
 887:	0e 00 00 
    base.s.size = 0;
 88a:	b8 44 0e 00 00       	mov    $0xe44,%eax
    base.s.ptr = freep = prevp = &base;
 88f:	c7 05 44 0e 00 00 44 	movl   $0xe44,0xe44
 896:	0e 00 00 
    base.s.size = 0;
 899:	c7 05 48 0e 00 00 00 	movl   $0x0,0xe48
 8a0:	00 00 00 
    if(p->s.size >= nunits){
 8a3:	e9 54 ff ff ff       	jmp    7fc <malloc+0x2c>
 8a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8af:	00 
        prevp->s.ptr = p->s.ptr;
 8b0:	8b 08                	mov    (%eax),%ecx
 8b2:	89 0a                	mov    %ecx,(%edx)
 8b4:	eb b9                	jmp    86f <malloc+0x9f>
