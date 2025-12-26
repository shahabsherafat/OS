
_find_sum:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  buf[p] = 0;
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
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	81 ec 38 02 00 00    	sub    $0x238,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 51 04             	mov    0x4(%ecx),%edx
  int total = 0;

  if(argc > 1){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	0f 8e bd 01 00 00    	jle    1e2 <main+0x1e2>
  25:	8d 04 82             	lea    (%edx,%eax,4),%eax
  int total = 0;
  28:	31 ff                	xor    %edi,%edi
  2a:	8d 72 04             	lea    0x4(%edx),%esi
  2d:	89 85 c0 fd ff ff    	mov    %eax,-0x240(%ebp)
  33:	89 bd c4 fd ff ff    	mov    %edi,-0x23c(%ebp)
  39:	89 f7                	mov    %esi,%edi
  3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    for(int i=1; i<argc; i++)
      total += sum_in_str(argv[i]);
  40:	8b 17                	mov    (%edi),%edx
  for(int i=0; s[i]; i++){
  42:	0f be 02             	movsbl (%edx),%eax
  45:	84 c0                	test   %al,%al
  47:	0f 84 3d 01 00 00    	je     18a <main+0x18a>
  4d:	83 c2 01             	add    $0x1,%edx
  int sum = 0, cur = 0, in = 0;
  50:	31 f6                	xor    %esi,%esi
  52:	31 db                	xor    %ebx,%ebx
  54:	31 c9                	xor    %ecx,%ecx
  56:	eb 1d                	jmp    75 <main+0x75>
  58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  5f:	00 
      cur = cur*10 + (s[i]-'0');  // Multiple digit number
  60:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
      in = 1;
  63:	bb 01 00 00 00       	mov    $0x1,%ebx
      cur = cur*10 + (s[i]-'0');  // Multiple digit number
  68:	8d 0c 48             	lea    (%eax,%ecx,2),%ecx
  for(int i=0; s[i]; i++){
  6b:	0f be 02             	movsbl (%edx),%eax
  6e:	83 c2 01             	add    $0x1,%edx
  71:	84 c0                	test   %al,%al
  73:	74 1c                	je     91 <main+0x91>
  return c >= '0' && c <= '9';
  75:	83 e8 30             	sub    $0x30,%eax
    if(is_digit(s[i])){
  78:	83 f8 09             	cmp    $0x9,%eax
  7b:	76 e3                	jbe    60 <main+0x60>
      if(in){
  7d:	85 db                	test   %ebx,%ebx
  7f:	74 ea                	je     6b <main+0x6b>
  for(int i=0; s[i]; i++){
  81:	0f be 02             	movsbl (%edx),%eax
        sum += cur;
  84:	01 ce                	add    %ecx,%esi
  for(int i=0; s[i]; i++){
  86:	83 c2 01             	add    $0x1,%edx
        in = 0;
  89:	31 db                	xor    %ebx,%ebx
        cur = 0;
  8b:	31 c9                	xor    %ecx,%ecx
  for(int i=0; s[i]; i++){
  8d:	84 c0                	test   %al,%al
  8f:	75 e4                	jne    75 <main+0x75>
    sum += cur;
  91:	01 f1                	add    %esi,%ecx
  93:	85 db                	test   %ebx,%ebx
  95:	0f 45 f1             	cmovne %ecx,%esi
      total += sum_in_str(argv[i]);
  98:	01 b5 c4 fd ff ff    	add    %esi,-0x23c(%ebp)
    for(int i=1; i<argc; i++)
  9e:	83 c7 04             	add    $0x4,%edi
  a1:	39 bd c0 fd ff ff    	cmp    %edi,-0x240(%ebp)
  a7:	75 97                	jne    40 <main+0x40>
  a9:	8b bd c4 fd ff ff    	mov    -0x23c(%ebp),%edi
      buf[m] = 0;
      total += sum_in_str(buf);
    }
  }

  unlink("result.txt");
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	68 78 09 00 00       	push   $0x978
  b7:	e8 57 04 00 00       	call   513 <unlink>
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  bc:	59                   	pop    %ecx
  bd:	5b                   	pop    %ebx
  be:	68 01 02 00 00       	push   $0x201
  c3:	68 78 09 00 00       	push   $0x978
  c8:	e8 36 04 00 00       	call   503 <open>

  if(fd < 0){
  cd:	83 c4 10             	add    $0x10,%esp
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  d0:	89 85 c0 fd ff ff    	mov    %eax,-0x240(%ebp)
  if(fd < 0){
  d6:	85 c0                	test   %eax,%eax
  d8:	0f 88 ff 00 00 00    	js     1dd <main+0x1dd>
  if(x==0){
  de:	85 ff                	test   %edi,%edi
  e0:	0f 84 ab 00 00 00    	je     191 <main+0x191>
  int n = 0, p = 0, neg = 0;
  e6:	c7 85 c4 fd ff ff 00 	movl   $0x0,-0x23c(%ebp)
  ed:	00 00 00 
  if(x<0){
  f0:	79 0c                	jns    fe <main+0xfe>
    neg = 1;
  f2:	c7 85 c4 fd ff ff 01 	movl   $0x1,-0x23c(%ebp)
  f9:	00 00 00 
    x = -x;
  fc:	f7 df                	neg    %edi
  int total = 0;
  fe:	31 c9                	xor    %ecx,%ecx
    tmp[n++] = '0' + (x%10); x/=10;
 100:	bb 67 66 66 66       	mov    $0x66666667,%ebx
 105:	8d 76 00             	lea    0x0(%esi),%esi
 108:	89 f8                	mov    %edi,%eax
 10a:	89 ce                	mov    %ecx,%esi
 10c:	8d 49 01             	lea    0x1(%ecx),%ecx
 10f:	f7 eb                	imul   %ebx
 111:	89 f8                	mov    %edi,%eax
 113:	c1 f8 1f             	sar    $0x1f,%eax
 116:	c1 fa 02             	sar    $0x2,%edx
 119:	29 c2                	sub    %eax,%edx
 11b:	8d 04 92             	lea    (%edx,%edx,4),%eax
 11e:	01 c0                	add    %eax,%eax
 120:	29 c7                	sub    %eax,%edi
 122:	8d 47 30             	lea    0x30(%edi),%eax
 125:	89 d7                	mov    %edx,%edi
 127:	88 84 0d c7 fd ff ff 	mov    %al,-0x239(%ebp,%ecx,1)
  while(x){
 12e:	85 d2                	test   %edx,%edx
 130:	75 d6                	jne    108 <main+0x108>
  if(neg)
 132:	83 bd c4 fd ff ff 00 	cmpl   $0x0,-0x23c(%ebp)
 139:	0f 85 07 01 00 00    	jne    246 <main+0x246>
  while(n--)
 13f:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 145:	8d bd c8 fd ff ff    	lea    -0x238(%ebp),%edi
 14b:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 151:	8d 04 37             	lea    (%edi,%esi,1),%eax
 154:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
 157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 15e:	00 
 15f:	90                   	nop
    buf[p++] = tmp[n];
 160:	0f b6 18             	movzbl (%eax),%ebx
  while(n--)
 163:	83 c2 01             	add    $0x1,%edx
    buf[p++] = tmp[n];
 166:	88 5a ff             	mov    %bl,-0x1(%edx)
  while(n--)
 169:	89 c3                	mov    %eax,%ebx
 16b:	83 e8 01             	sub    $0x1,%eax
 16e:	39 fb                	cmp    %edi,%ebx
 170:	75 ee                	jne    160 <main+0x160>
  buf[p++] = '\n';
 172:	8d 46 e8             	lea    -0x18(%esi),%eax
 175:	8d 34 28             	lea    (%eax,%ebp,1),%esi
 178:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
 17e:	66 c7 84 30 01 fe ff 	movw   $0xa,-0x1ff(%eax,%esi,1)
 185:	ff 0a 00 
 188:	eb 1d                	jmp    1a7 <main+0x1a7>
  int sum = 0, cur = 0, in = 0;
 18a:	31 f6                	xor    %esi,%esi
 18c:	e9 07 ff ff ff       	jmp    98 <main+0x98>
    buf[0] = '0';
 191:	66 c7 85 e8 fd ff ff 	movw   $0xa30,-0x218(%ebp)
 198:	30 0a 
    buf[2] = 0; 
 19a:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1a0:	c6 85 ea fd ff ff 00 	movb   $0x0,-0x216(%ebp)
  int n=0;
 1a7:	31 c0                	xor    %eax,%eax
  while(s[n])
 1a9:	80 bd e8 fd ff ff 00 	cmpb   $0x0,-0x218(%ebp)
 1b0:	74 0f                	je     1c1 <main+0x1c1>
 1b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    n++;
 1b8:	83 c0 01             	add    $0x1,%eax
  while(s[n])
 1bb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1bf:	75 f7                	jne    1b8 <main+0x1b8>
    exit();
  }

  char out[64];
  convert_int_to_str(total, out);
  write(fd, out, ustrlen(out));
 1c1:	8b b5 c0 fd ff ff    	mov    -0x240(%ebp),%esi
 1c7:	52                   	push   %edx
 1c8:	50                   	push   %eax
 1c9:	51                   	push   %ecx
 1ca:	56                   	push   %esi
 1cb:	e8 13 03 00 00       	call   4e3 <write>
  close(fd);
 1d0:	89 34 24             	mov    %esi,(%esp)
 1d3:	e8 13 03 00 00       	call   4eb <close>

  exit();
 1d8:	e8 e6 02 00 00       	call   4c3 <exit>
    exit();
 1dd:	e8 e1 02 00 00       	call   4c3 <exit>
    int m = read(0, buf, sizeof(buf)-1);
 1e2:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 1e8:	56                   	push   %esi
 1e9:	68 ff 01 00 00       	push   $0x1ff
 1ee:	51                   	push   %ecx
 1ef:	6a 00                	push   $0x0
 1f1:	e8 e5 02 00 00       	call   4db <read>
    if(m > 0){
 1f6:	83 c4 10             	add    $0x10,%esp
 1f9:	85 c0                	test   %eax,%eax
 1fb:	7e 55                	jle    252 <main+0x252>
      buf[m] = 0;
 1fd:	c6 84 05 e8 fd ff ff 	movb   $0x0,-0x218(%ebp,%eax,1)
 204:	00 
  for(int i=0; s[i]; i++){
 205:	0f be 85 e8 fd ff ff 	movsbl -0x218(%ebp),%eax
 20c:	84 c0                	test   %al,%al
 20e:	74 42                	je     252 <main+0x252>
 210:	8d 95 e9 fd ff ff    	lea    -0x217(%ebp),%edx
  int sum = 0, cur = 0, in = 0;
 216:	31 ff                	xor    %edi,%edi
 218:	31 db                	xor    %ebx,%ebx
 21a:	31 c9                	xor    %ecx,%ecx
 21c:	eb 14                	jmp    232 <main+0x232>
      cur = cur*10 + (s[i]-'0');  // Multiple digit number
 21e:	6b c9 0a             	imul   $0xa,%ecx,%ecx
      in = 1;
 221:	bb 01 00 00 00       	mov    $0x1,%ebx
      cur = cur*10 + (s[i]-'0');  // Multiple digit number
 226:	01 c1                	add    %eax,%ecx
  for(int i=0; s[i]; i++){
 228:	0f be 02             	movsbl (%edx),%eax
 22b:	83 c2 01             	add    $0x1,%edx
 22e:	84 c0                	test   %al,%al
 230:	74 27                	je     259 <main+0x259>
  return c >= '0' && c <= '9';
 232:	83 e8 30             	sub    $0x30,%eax
    if(is_digit(s[i])){
 235:	83 f8 09             	cmp    $0x9,%eax
 238:	76 e4                	jbe    21e <main+0x21e>
      if(in){
 23a:	85 db                	test   %ebx,%ebx
 23c:	74 ea                	je     228 <main+0x228>
        sum += cur;
 23e:	01 cf                	add    %ecx,%edi
        in = 0;
 240:	31 db                	xor    %ebx,%ebx
        cur = 0;
 242:	31 c9                	xor    %ecx,%ecx
 244:	eb e2                	jmp    228 <main+0x228>
    buf[p++] = '-';
 246:	c6 85 e8 fd ff ff 2d 	movb   $0x2d,-0x218(%ebp)
 24d:	e9 ed fe ff ff       	jmp    13f <main+0x13f>
  int total = 0;
 252:	31 ff                	xor    %edi,%edi
 254:	e9 56 fe ff ff       	jmp    af <main+0xaf>
  if(in)
 259:	85 db                	test   %ebx,%ebx
 25b:	0f 84 4e fe ff ff    	je     af <main+0xaf>
    sum += cur;
 261:	01 cf                	add    %ecx,%edi
 263:	e9 47 fe ff ff       	jmp    af <main+0xaf>
 268:	66 90                	xchg   %ax,%ax
 26a:	66 90                	xchg   %ax,%ax
 26c:	66 90                	xchg   %ax,%ax
 26e:	66 90                	xchg   %ax,%ax

00000270 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 270:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 271:	31 c0                	xor    %eax,%eax
{
 273:	89 e5                	mov    %esp,%ebp
 275:	53                   	push   %ebx
 276:	8b 4d 08             	mov    0x8(%ebp),%ecx
 279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 280:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 284:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 287:	83 c0 01             	add    $0x1,%eax
 28a:	84 d2                	test   %dl,%dl
 28c:	75 f2                	jne    280 <strcpy+0x10>
    ;
  return os;
}
 28e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 291:	89 c8                	mov    %ecx,%eax
 293:	c9                   	leave
 294:	c3                   	ret
 295:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29c:	00 
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2aa:	0f b6 02             	movzbl (%edx),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	75 17                	jne    2c8 <strcmp+0x28>
 2b1:	eb 3a                	jmp    2ed <strcmp+0x4d>
 2b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 2bc:	83 c2 01             	add    $0x1,%edx
 2bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 2c2:	84 c0                	test   %al,%al
 2c4:	74 1a                	je     2e0 <strcmp+0x40>
 2c6:	89 d9                	mov    %ebx,%ecx
 2c8:	0f b6 19             	movzbl (%ecx),%ebx
 2cb:	38 c3                	cmp    %al,%bl
 2cd:	74 e9                	je     2b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 2cf:	29 d8                	sub    %ebx,%eax
}
 2d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d4:	c9                   	leave
 2d5:	c3                   	ret
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2e4:	31 c0                	xor    %eax,%eax
 2e6:	29 d8                	sub    %ebx,%eax
}
 2e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2eb:	c9                   	leave
 2ec:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2ed:	0f b6 19             	movzbl (%ecx),%ebx
 2f0:	31 c0                	xor    %eax,%eax
 2f2:	eb db                	jmp    2cf <strcmp+0x2f>
 2f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fb:	00 
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <strlen>:

uint
strlen(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 306:	80 3a 00             	cmpb   $0x0,(%edx)
 309:	74 15                	je     320 <strlen+0x20>
 30b:	31 c0                	xor    %eax,%eax
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	83 c0 01             	add    $0x1,%eax
 313:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 317:	89 c1                	mov    %eax,%ecx
 319:	75 f5                	jne    310 <strlen+0x10>
    ;
  return n;
}
 31b:	89 c8                	mov    %ecx,%eax
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret
 31f:	90                   	nop
  for(n = 0; s[n]; n++)
 320:	31 c9                	xor    %ecx,%ecx
}
 322:	5d                   	pop    %ebp
 323:	89 c8                	mov    %ecx,%eax
 325:	c3                   	ret
 326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32d:	00 
 32e:	66 90                	xchg   %ax,%ax

00000330 <memset>:

void*
memset(void *dst, int c, uint n)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 337:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 d7                	mov    %edx,%edi
 33f:	fc                   	cld
 340:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 342:	8b 7d fc             	mov    -0x4(%ebp),%edi
 345:	89 d0                	mov    %edx,%eax
 347:	c9                   	leave
 348:	c3                   	ret
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000350 <strchr>:

char*
strchr(const char *s, char c)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 35a:	0f b6 10             	movzbl (%eax),%edx
 35d:	84 d2                	test   %dl,%dl
 35f:	75 12                	jne    373 <strchr+0x23>
 361:	eb 1d                	jmp    380 <strchr+0x30>
 363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 36c:	83 c0 01             	add    $0x1,%eax
 36f:	84 d2                	test   %dl,%dl
 371:	74 0d                	je     380 <strchr+0x30>
    if(*s == c)
 373:	38 d1                	cmp    %dl,%cl
 375:	75 f1                	jne    368 <strchr+0x18>
      return (char*)s;
  return 0;
}
 377:	5d                   	pop    %ebp
 378:	c3                   	ret
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 380:	31 c0                	xor    %eax,%eax
}
 382:	5d                   	pop    %ebp
 383:	c3                   	ret
 384:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38b:	00 
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 395:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 398:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 399:	31 db                	xor    %ebx,%ebx
 39b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 39e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3a1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 3a4:	7d 3b                	jge    3e1 <gets+0x51>
 3a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ad:	00 
 3ae:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	6a 01                	push   $0x1
 3b5:	57                   	push   %edi
 3b6:	6a 00                	push   $0x0
 3b8:	e8 1e 01 00 00       	call   4db <read>
    if(cc < 1)
 3bd:	83 c4 10             	add    $0x10,%esp
 3c0:	85 c0                	test   %eax,%eax
 3c2:	7e 1d                	jle    3e1 <gets+0x51>
      break;
      
    buf[i++] = c;
 3c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
 3cb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 3cf:	3c 0a                	cmp    $0xa,%al
 3d1:	7f 25                	jg     3f8 <gets+0x68>
 3d3:	3c 08                	cmp    $0x8,%al
 3d5:	7f 0c                	jg     3e3 <gets+0x53>
{
 3d7:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 3d9:	8d 73 01             	lea    0x1(%ebx),%esi
 3dc:	3b 75 0c             	cmp    0xc(%ebp),%esi
 3df:	7c cf                	jl     3b0 <gets+0x20>
 3e1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ed:	5b                   	pop    %ebx
 3ee:	5e                   	pop    %esi
 3ef:	5f                   	pop    %edi
 3f0:	5d                   	pop    %ebp
 3f1:	c3                   	ret
 3f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3f8:	3c 0d                	cmp    $0xd,%al
 3fa:	74 e7                	je     3e3 <gets+0x53>
{
 3fc:	89 f3                	mov    %esi,%ebx
 3fe:	eb d9                	jmp    3d9 <gets+0x49>

00000400 <stat>:

int
stat(const char *n, struct stat *st)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 405:	83 ec 08             	sub    $0x8,%esp
 408:	6a 00                	push   $0x0
 40a:	ff 75 08             	push   0x8(%ebp)
 40d:	e8 f1 00 00 00       	call   503 <open>
  if(fd < 0)
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	78 27                	js     440 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 419:	83 ec 08             	sub    $0x8,%esp
 41c:	ff 75 0c             	push   0xc(%ebp)
 41f:	89 c3                	mov    %eax,%ebx
 421:	50                   	push   %eax
 422:	e8 f4 00 00 00       	call   51b <fstat>
  close(fd);
 427:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	e8 ba 00 00 00       	call   4eb <close>
  return r;
 431:	83 c4 10             	add    $0x10,%esp
}
 434:	8d 65 f8             	lea    -0x8(%ebp),%esp
 437:	89 f0                	mov    %esi,%eax
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret
 43d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 440:	be ff ff ff ff       	mov    $0xffffffff,%esi
 445:	eb ed                	jmp    434 <stat+0x34>
 447:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 44e:	00 
 44f:	90                   	nop

00000450 <atoi>:

int
atoi(const char *s)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	53                   	push   %ebx
 454:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 457:	0f be 02             	movsbl (%edx),%eax
 45a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 45d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 460:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 465:	77 1e                	ja     485 <atoi+0x35>
 467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46e:	00 
 46f:	90                   	nop
    n = n*10 + *s++ - '0';
 470:	83 c2 01             	add    $0x1,%edx
 473:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 476:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 47a:	0f be 02             	movsbl (%edx),%eax
 47d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 480:	80 fb 09             	cmp    $0x9,%bl
 483:	76 eb                	jbe    470 <atoi+0x20>
  return n;
}
 485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 488:	89 c8                	mov    %ecx,%eax
 48a:	c9                   	leave
 48b:	c3                   	ret
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000490 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	8b 45 10             	mov    0x10(%ebp),%eax
 497:	8b 55 08             	mov    0x8(%ebp),%edx
 49a:	56                   	push   %esi
 49b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49e:	85 c0                	test   %eax,%eax
 4a0:	7e 13                	jle    4b5 <memmove+0x25>
 4a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4a4:	89 d7                	mov    %edx,%edi
 4a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4ad:	00 
 4ae:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b1:	39 f8                	cmp    %edi,%eax
 4b3:	75 fb                	jne    4b0 <memmove+0x20>
  return vdst;
}
 4b5:	5e                   	pop    %esi
 4b6:	89 d0                	mov    %edx,%eax
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret

000004bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4bb:	b8 01 00 00 00       	mov    $0x1,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <exit>:
SYSCALL(exit)
 4c3:	b8 02 00 00 00       	mov    $0x2,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <wait>:
SYSCALL(wait)
 4cb:	b8 03 00 00 00       	mov    $0x3,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <pipe>:
SYSCALL(pipe)
 4d3:	b8 04 00 00 00       	mov    $0x4,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <read>:
SYSCALL(read)
 4db:	b8 05 00 00 00       	mov    $0x5,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <write>:
SYSCALL(write)
 4e3:	b8 10 00 00 00       	mov    $0x10,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <close>:
SYSCALL(close)
 4eb:	b8 15 00 00 00       	mov    $0x15,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <kill>:
SYSCALL(kill)
 4f3:	b8 06 00 00 00       	mov    $0x6,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <exec>:
SYSCALL(exec)
 4fb:	b8 07 00 00 00       	mov    $0x7,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <open>:
SYSCALL(open)
 503:	b8 0f 00 00 00       	mov    $0xf,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <mknod>:
SYSCALL(mknod)
 50b:	b8 11 00 00 00       	mov    $0x11,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <unlink>:
SYSCALL(unlink)
 513:	b8 12 00 00 00       	mov    $0x12,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <fstat>:
SYSCALL(fstat)
 51b:	b8 08 00 00 00       	mov    $0x8,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <link>:
SYSCALL(link)
 523:	b8 13 00 00 00       	mov    $0x13,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <mkdir>:
SYSCALL(mkdir)
 52b:	b8 14 00 00 00       	mov    $0x14,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <chdir>:
SYSCALL(chdir)
 533:	b8 09 00 00 00       	mov    $0x9,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <dup>:
SYSCALL(dup)
 53b:	b8 0a 00 00 00       	mov    $0xa,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <getpid>:
SYSCALL(getpid)
 543:	b8 0b 00 00 00       	mov    $0xb,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <sbrk>:
SYSCALL(sbrk)
 54b:	b8 0c 00 00 00       	mov    $0xc,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <sleep>:
SYSCALL(sleep)
 553:	b8 0d 00 00 00       	mov    $0xd,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <uptime>:
SYSCALL(uptime)
 55b:	b8 0e 00 00 00       	mov    $0xe,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 563:	b8 17 00 00 00       	mov    $0x17,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <show_process_family>:
SYSCALL(show_process_family)
 56b:	b8 18 00 00 00       	mov    $0x18,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 573:	b8 16 00 00 00       	mov    $0x16,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <grep_syscall>:
SYSCALL(grep_syscall)
 57b:	b8 19 00 00 00       	mov    $0x19,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 583:	b8 1a 00 00 00       	mov    $0x1a,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 58b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 593:	b8 1c 00 00 00       	mov    $0x1c,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 59b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 5a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 5ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 5b3:	b8 20 00 00 00       	mov    $0x20,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 5bb:	b8 21 00 00 00       	mov    $0x21,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 5c3:	b8 22 00 00 00       	mov    $0x22,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5d8:	89 d1                	mov    %edx,%ecx
{
 5da:	83 ec 3c             	sub    $0x3c,%esp
 5dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5e0:	85 d2                	test   %edx,%edx
 5e2:	0f 89 80 00 00 00    	jns    668 <printint+0x98>
 5e8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ec:	74 7a                	je     668 <printint+0x98>
    x = -xx;
 5ee:	f7 d9                	neg    %ecx
    neg = 1;
 5f0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5f8:	31 f6                	xor    %esi,%esi
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 600:	89 c8                	mov    %ecx,%eax
 602:	31 d2                	xor    %edx,%edx
 604:	89 f7                	mov    %esi,%edi
 606:	f7 f3                	div    %ebx
 608:	8d 76 01             	lea    0x1(%esi),%esi
 60b:	0f b6 92 e4 09 00 00 	movzbl 0x9e4(%edx),%edx
 612:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 616:	89 ca                	mov    %ecx,%edx
 618:	89 c1                	mov    %eax,%ecx
 61a:	39 da                	cmp    %ebx,%edx
 61c:	73 e2                	jae    600 <printint+0x30>
  if(neg)
 61e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 621:	85 c0                	test   %eax,%eax
 623:	74 07                	je     62c <printint+0x5c>
    buf[i++] = '-';
 625:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 62a:	89 f7                	mov    %esi,%edi
 62c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 62f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 632:	01 df                	add    %ebx,%edi
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 638:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 63b:	83 ec 04             	sub    $0x4,%esp
 63e:	88 45 d7             	mov    %al,-0x29(%ebp)
 641:	8d 45 d7             	lea    -0x29(%ebp),%eax
 644:	6a 01                	push   $0x1
 646:	50                   	push   %eax
 647:	56                   	push   %esi
 648:	e8 96 fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 64d:	89 f8                	mov    %edi,%eax
 64f:	83 c4 10             	add    $0x10,%esp
 652:	83 ef 01             	sub    $0x1,%edi
 655:	39 c3                	cmp    %eax,%ebx
 657:	75 df                	jne    638 <printint+0x68>
}
 659:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65c:	5b                   	pop    %ebx
 65d:	5e                   	pop    %esi
 65e:	5f                   	pop    %edi
 65f:	5d                   	pop    %ebp
 660:	c3                   	ret
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 668:	31 c0                	xor    %eax,%eax
 66a:	eb 89                	jmp    5f5 <printint+0x25>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 67c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 1e             	movzbl (%esi),%ebx
 682:	83 c6 01             	add    $0x1,%esi
 685:	84 db                	test   %bl,%bl
 687:	74 67                	je     6f0 <printf+0x80>
 689:	8d 4d 10             	lea    0x10(%ebp),%ecx
 68c:	31 d2                	xor    %edx,%edx
 68e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 691:	eb 34                	jmp    6c7 <printf+0x57>
 693:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 698:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 69b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6a0:	83 f8 25             	cmp    $0x25,%eax
 6a3:	74 18                	je     6bd <printf+0x4d>
  write(fd, &c, 1);
 6a5:	83 ec 04             	sub    $0x4,%esp
 6a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6ab:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6ae:	6a 01                	push   $0x1
 6b0:	50                   	push   %eax
 6b1:	57                   	push   %edi
 6b2:	e8 2c fe ff ff       	call   4e3 <write>
 6b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6ba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6bd:	0f b6 1e             	movzbl (%esi),%ebx
 6c0:	83 c6 01             	add    $0x1,%esi
 6c3:	84 db                	test   %bl,%bl
 6c5:	74 29                	je     6f0 <printf+0x80>
    c = fmt[i] & 0xff;
 6c7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6ca:	85 d2                	test   %edx,%edx
 6cc:	74 ca                	je     698 <printf+0x28>
      }
    } else if(state == '%'){
 6ce:	83 fa 25             	cmp    $0x25,%edx
 6d1:	75 ea                	jne    6bd <printf+0x4d>
      if(c == 'd'){
 6d3:	83 f8 25             	cmp    $0x25,%eax
 6d6:	0f 84 04 01 00 00    	je     7e0 <printf+0x170>
 6dc:	83 e8 63             	sub    $0x63,%eax
 6df:	83 f8 15             	cmp    $0x15,%eax
 6e2:	77 1c                	ja     700 <printf+0x90>
 6e4:	ff 24 85 8c 09 00 00 	jmp    *0x98c(,%eax,4)
 6eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret
 6f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ff:	00 
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	8d 55 e7             	lea    -0x19(%ebp),%edx
 706:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 70a:	6a 01                	push   $0x1
 70c:	52                   	push   %edx
 70d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 710:	57                   	push   %edi
 711:	e8 cd fd ff ff       	call   4e3 <write>
 716:	83 c4 0c             	add    $0xc,%esp
 719:	88 5d e7             	mov    %bl,-0x19(%ebp)
 71c:	6a 01                	push   $0x1
 71e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 721:	52                   	push   %edx
 722:	57                   	push   %edi
 723:	e8 bb fd ff ff       	call   4e3 <write>
        putc(fd, c);
 728:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72b:	31 d2                	xor    %edx,%edx
 72d:	eb 8e                	jmp    6bd <printf+0x4d>
 72f:	90                   	nop
        printint(fd, *ap, 16, 0);
 730:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	b9 10 00 00 00       	mov    $0x10,%ecx
 73b:	8b 13                	mov    (%ebx),%edx
 73d:	6a 00                	push   $0x0
 73f:	89 f8                	mov    %edi,%eax
        ap++;
 741:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 744:	e8 87 fe ff ff       	call   5d0 <printint>
        ap++;
 749:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 74c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 67 ff ff ff       	jmp    6bd <printf+0x4d>
        s = (char*)*ap;
 756:	8b 45 d0             	mov    -0x30(%ebp),%eax
 759:	8b 18                	mov    (%eax),%ebx
        ap++;
 75b:	83 c0 04             	add    $0x4,%eax
 75e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 761:	85 db                	test   %ebx,%ebx
 763:	0f 84 87 00 00 00    	je     7f0 <printf+0x180>
        while(*s != 0){
 769:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 76c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 76e:	84 c0                	test   %al,%al
 770:	0f 84 47 ff ff ff    	je     6bd <printf+0x4d>
 776:	8d 55 e7             	lea    -0x19(%ebp),%edx
 779:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 77c:	89 de                	mov    %ebx,%esi
 77e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
 783:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 786:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	53                   	push   %ebx
 78c:	57                   	push   %edi
 78d:	e8 51 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 792:	0f b6 06             	movzbl (%esi),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x110>
      state = 0;
 79c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 79f:	31 d2                	xor    %edx,%edx
 7a1:	e9 17 ff ff ff       	jmp    6bd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 7a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7a9:	83 ec 0c             	sub    $0xc,%esp
 7ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b1:	8b 13                	mov    (%ebx),%edx
 7b3:	6a 01                	push   $0x1
 7b5:	eb 88                	jmp    73f <printf+0xcf>
        putc(fd, *ap);
 7b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7ba:	83 ec 04             	sub    $0x4,%esp
 7bd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7c0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7c2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
 7ca:	52                   	push   %edx
 7cb:	57                   	push   %edi
 7cc:	e8 12 fd ff ff       	call   4e3 <write>
        ap++;
 7d1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7d7:	31 d2                	xor    %edx,%edx
 7d9:	e9 df fe ff ff       	jmp    6bd <printf+0x4d>
 7de:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
 7e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7e6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7e9:	6a 01                	push   $0x1
 7eb:	e9 31 ff ff ff       	jmp    721 <printf+0xb1>
 7f0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7f5:	bb 83 09 00 00       	mov    $0x983,%ebx
 7fa:	e9 77 ff ff ff       	jmp    776 <printf+0x106>
 7ff:	90                   	nop

00000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	a1 8c 0c 00 00       	mov    0xc8c,%eax
{
 806:	89 e5                	mov    %esp,%ebp
 808:	57                   	push   %edi
 809:	56                   	push   %esi
 80a:	53                   	push   %ebx
 80b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 80e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	39 c8                	cmp    %ecx,%eax
 81c:	73 32                	jae    850 <free+0x50>
 81e:	39 d1                	cmp    %edx,%ecx
 820:	72 04                	jb     826 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	39 d0                	cmp    %edx,%eax
 824:	72 32                	jb     858 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 826:	8b 73 fc             	mov    -0x4(%ebx),%esi
 829:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 82c:	39 fa                	cmp    %edi,%edx
 82e:	74 30                	je     860 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 833:	8b 50 04             	mov    0x4(%eax),%edx
 836:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 839:	39 f1                	cmp    %esi,%ecx
 83b:	74 3a                	je     877 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 83d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 83f:	5b                   	pop    %ebx
  freep = p;
 840:	a3 8c 0c 00 00       	mov    %eax,0xc8c
}
 845:	5e                   	pop    %esi
 846:	5f                   	pop    %edi
 847:	5d                   	pop    %ebp
 848:	c3                   	ret
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	39 d0                	cmp    %edx,%eax
 852:	72 04                	jb     858 <free+0x58>
 854:	39 d1                	cmp    %edx,%ecx
 856:	72 ce                	jb     826 <free+0x26>
{
 858:	89 d0                	mov    %edx,%eax
 85a:	eb bc                	jmp    818 <free+0x18>
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 860:	03 72 04             	add    0x4(%edx),%esi
 863:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	8b 10                	mov    (%eax),%edx
 868:	8b 12                	mov    (%edx),%edx
 86a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 873:	39 f1                	cmp    %esi,%ecx
 875:	75 c6                	jne    83d <free+0x3d>
    p->s.size += bp->s.size;
 877:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 87a:	a3 8c 0c 00 00       	mov    %eax,0xc8c
    p->s.size += bp->s.size;
 87f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 882:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 885:	89 08                	mov    %ecx,(%eax)
}
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000890 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
 894:	56                   	push   %esi
 895:	53                   	push   %ebx
 896:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 89c:	8b 15 8c 0c 00 00    	mov    0xc8c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	8d 78 07             	lea    0x7(%eax),%edi
 8a5:	c1 ef 03             	shr    $0x3,%edi
 8a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8ab:	85 d2                	test   %edx,%edx
 8ad:	0f 84 8d 00 00 00    	je     940 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b5:	8b 48 04             	mov    0x4(%eax),%ecx
 8b8:	39 f9                	cmp    %edi,%ecx
 8ba:	73 64                	jae    920 <malloc+0x90>
  if(nu < 4096)
 8bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8c1:	39 df                	cmp    %ebx,%edi
 8c3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8c6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8cd:	eb 0a                	jmp    8d9 <malloc+0x49>
 8cf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8d2:	8b 48 04             	mov    0x4(%eax),%ecx
 8d5:	39 f9                	cmp    %edi,%ecx
 8d7:	73 47                	jae    920 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d9:	89 c2                	mov    %eax,%edx
 8db:	3b 05 8c 0c 00 00    	cmp    0xc8c,%eax
 8e1:	75 ed                	jne    8d0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8e3:	83 ec 0c             	sub    $0xc,%esp
 8e6:	56                   	push   %esi
 8e7:	e8 5f fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 8ec:	83 c4 10             	add    $0x10,%esp
 8ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 8f2:	74 1c                	je     910 <malloc+0x80>
  hp->s.size = nu;
 8f4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8f7:	83 ec 0c             	sub    $0xc,%esp
 8fa:	83 c0 08             	add    $0x8,%eax
 8fd:	50                   	push   %eax
 8fe:	e8 fd fe ff ff       	call   800 <free>
  return freep;
 903:	8b 15 8c 0c 00 00    	mov    0xc8c,%edx
      if((p = morecore(nunits)) == 0)
 909:	83 c4 10             	add    $0x10,%esp
 90c:	85 d2                	test   %edx,%edx
 90e:	75 c0                	jne    8d0 <malloc+0x40>
        return 0;
  }
}
 910:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 913:	31 c0                	xor    %eax,%eax
}
 915:	5b                   	pop    %ebx
 916:	5e                   	pop    %esi
 917:	5f                   	pop    %edi
 918:	5d                   	pop    %ebp
 919:	c3                   	ret
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 920:	39 cf                	cmp    %ecx,%edi
 922:	74 4c                	je     970 <malloc+0xe0>
        p->s.size -= nunits;
 924:	29 f9                	sub    %edi,%ecx
 926:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 929:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 92c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 92f:	89 15 8c 0c 00 00    	mov    %edx,0xc8c
}
 935:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 938:	83 c0 08             	add    $0x8,%eax
}
 93b:	5b                   	pop    %ebx
 93c:	5e                   	pop    %esi
 93d:	5f                   	pop    %edi
 93e:	5d                   	pop    %ebp
 93f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 8c 0c 00 00 90 	movl   $0xc90,0xc8c
 947:	0c 00 00 
    base.s.size = 0;
 94a:	b8 90 0c 00 00       	mov    $0xc90,%eax
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 90 0c 00 00 90 	movl   $0xc90,0xc90
 956:	0c 00 00 
    base.s.size = 0;
 959:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 960:	00 00 00 
    if(p->s.size >= nunits){
 963:	e9 54 ff ff ff       	jmp    8bc <malloc+0x2c>
 968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 96f:	00 
        prevp->s.ptr = p->s.ptr;
 970:	8b 08                	mov    (%eax),%ecx
 972:	89 0a                	mov    %ecx,(%edx)
 974:	eb b9                	jmp    92f <malloc+0x9f>
