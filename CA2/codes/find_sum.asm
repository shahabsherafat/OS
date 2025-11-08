
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
  b2:	68 28 09 00 00       	push   $0x928
  b7:	e8 57 04 00 00       	call   513 <unlink>
  int fd = open("result.txt", O_CREATE | O_WRONLY);
  bc:	59                   	pop    %ecx
  bd:	5b                   	pop    %ebx
  be:	68 01 02 00 00       	push   $0x201
  c3:	68 28 09 00 00       	push   $0x928
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
 56b:	b8 18 00 00 00       	mov    $0x18,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret
 573:	66 90                	xchg   %ax,%ax
 575:	66 90                	xchg   %ax,%ax
 577:	66 90                	xchg   %ax,%ax
 579:	66 90                	xchg   %ax,%ax
 57b:	66 90                	xchg   %ax,%ax
 57d:	66 90                	xchg   %ax,%ax
 57f:	90                   	nop

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 588:	89 d1                	mov    %edx,%ecx
{
 58a:	83 ec 3c             	sub    $0x3c,%esp
 58d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 590:	85 d2                	test   %edx,%edx
 592:	0f 89 80 00 00 00    	jns    618 <printint+0x98>
 598:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 59c:	74 7a                	je     618 <printint+0x98>
    x = -xx;
 59e:	f7 d9                	neg    %ecx
    neg = 1;
 5a0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5a8:	31 f6                	xor    %esi,%esi
 5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5b0:	89 c8                	mov    %ecx,%eax
 5b2:	31 d2                	xor    %edx,%edx
 5b4:	89 f7                	mov    %esi,%edi
 5b6:	f7 f3                	div    %ebx
 5b8:	8d 76 01             	lea    0x1(%esi),%esi
 5bb:	0f b6 92 94 09 00 00 	movzbl 0x994(%edx),%edx
 5c2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 5c6:	89 ca                	mov    %ecx,%edx
 5c8:	89 c1                	mov    %eax,%ecx
 5ca:	39 da                	cmp    %ebx,%edx
 5cc:	73 e2                	jae    5b0 <printint+0x30>
  if(neg)
 5ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5d1:	85 c0                	test   %eax,%eax
 5d3:	74 07                	je     5dc <printint+0x5c>
    buf[i++] = '-';
 5d5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 5da:	89 f7                	mov    %esi,%edi
 5dc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 5df:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5e2:	01 df                	add    %ebx,%edi
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 5e8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 5eb:	83 ec 04             	sub    $0x4,%esp
 5ee:	88 45 d7             	mov    %al,-0x29(%ebp)
 5f1:	8d 45 d7             	lea    -0x29(%ebp),%eax
 5f4:	6a 01                	push   $0x1
 5f6:	50                   	push   %eax
 5f7:	56                   	push   %esi
 5f8:	e8 e6 fe ff ff       	call   4e3 <write>
  while(--i >= 0)
 5fd:	89 f8                	mov    %edi,%eax
 5ff:	83 c4 10             	add    $0x10,%esp
 602:	83 ef 01             	sub    $0x1,%edi
 605:	39 c3                	cmp    %eax,%ebx
 607:	75 df                	jne    5e8 <printint+0x68>
}
 609:	8d 65 f4             	lea    -0xc(%ebp),%esp
 60c:	5b                   	pop    %ebx
 60d:	5e                   	pop    %esi
 60e:	5f                   	pop    %edi
 60f:	5d                   	pop    %ebp
 610:	c3                   	ret
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 618:	31 c0                	xor    %eax,%eax
 61a:	eb 89                	jmp    5a5 <printint+0x25>
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 629:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 62c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 62f:	0f b6 1e             	movzbl (%esi),%ebx
 632:	83 c6 01             	add    $0x1,%esi
 635:	84 db                	test   %bl,%bl
 637:	74 67                	je     6a0 <printf+0x80>
 639:	8d 4d 10             	lea    0x10(%ebp),%ecx
 63c:	31 d2                	xor    %edx,%edx
 63e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 641:	eb 34                	jmp    677 <printf+0x57>
 643:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 648:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 64b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 650:	83 f8 25             	cmp    $0x25,%eax
 653:	74 18                	je     66d <printf+0x4d>
  write(fd, &c, 1);
 655:	83 ec 04             	sub    $0x4,%esp
 658:	8d 45 e7             	lea    -0x19(%ebp),%eax
 65b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 65e:	6a 01                	push   $0x1
 660:	50                   	push   %eax
 661:	57                   	push   %edi
 662:	e8 7c fe ff ff       	call   4e3 <write>
 667:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 66a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 66d:	0f b6 1e             	movzbl (%esi),%ebx
 670:	83 c6 01             	add    $0x1,%esi
 673:	84 db                	test   %bl,%bl
 675:	74 29                	je     6a0 <printf+0x80>
    c = fmt[i] & 0xff;
 677:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 67a:	85 d2                	test   %edx,%edx
 67c:	74 ca                	je     648 <printf+0x28>
      }
    } else if(state == '%'){
 67e:	83 fa 25             	cmp    $0x25,%edx
 681:	75 ea                	jne    66d <printf+0x4d>
      if(c == 'd'){
 683:	83 f8 25             	cmp    $0x25,%eax
 686:	0f 84 04 01 00 00    	je     790 <printf+0x170>
 68c:	83 e8 63             	sub    $0x63,%eax
 68f:	83 f8 15             	cmp    $0x15,%eax
 692:	77 1c                	ja     6b0 <printf+0x90>
 694:	ff 24 85 3c 09 00 00 	jmp    *0x93c(,%eax,4)
 69b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a3:	5b                   	pop    %ebx
 6a4:	5e                   	pop    %esi
 6a5:	5f                   	pop    %edi
 6a6:	5d                   	pop    %ebp
 6a7:	c3                   	ret
 6a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6af:	00 
  write(fd, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6b6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ba:	6a 01                	push   $0x1
 6bc:	52                   	push   %edx
 6bd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6c0:	57                   	push   %edi
 6c1:	e8 1d fe ff ff       	call   4e3 <write>
 6c6:	83 c4 0c             	add    $0xc,%esp
 6c9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6cc:	6a 01                	push   $0x1
 6ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6d1:	52                   	push   %edx
 6d2:	57                   	push   %edi
 6d3:	e8 0b fe ff ff       	call   4e3 <write>
        putc(fd, c);
 6d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6db:	31 d2                	xor    %edx,%edx
 6dd:	eb 8e                	jmp    66d <printf+0x4d>
 6df:	90                   	nop
        printint(fd, *ap, 16, 0);
 6e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6e3:	83 ec 0c             	sub    $0xc,%esp
 6e6:	b9 10 00 00 00       	mov    $0x10,%ecx
 6eb:	8b 13                	mov    (%ebx),%edx
 6ed:	6a 00                	push   $0x0
 6ef:	89 f8                	mov    %edi,%eax
        ap++;
 6f1:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 6f4:	e8 87 fe ff ff       	call   580 <printint>
        ap++;
 6f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ff:	31 d2                	xor    %edx,%edx
 701:	e9 67 ff ff ff       	jmp    66d <printf+0x4d>
        s = (char*)*ap;
 706:	8b 45 d0             	mov    -0x30(%ebp),%eax
 709:	8b 18                	mov    (%eax),%ebx
        ap++;
 70b:	83 c0 04             	add    $0x4,%eax
 70e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 711:	85 db                	test   %ebx,%ebx
 713:	0f 84 87 00 00 00    	je     7a0 <printf+0x180>
        while(*s != 0){
 719:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 71c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 71e:	84 c0                	test   %al,%al
 720:	0f 84 47 ff ff ff    	je     66d <printf+0x4d>
 726:	8d 55 e7             	lea    -0x19(%ebp),%edx
 729:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 72c:	89 de                	mov    %ebx,%esi
 72e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
 733:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 736:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 739:	6a 01                	push   $0x1
 73b:	53                   	push   %ebx
 73c:	57                   	push   %edi
 73d:	e8 a1 fd ff ff       	call   4e3 <write>
        while(*s != 0){
 742:	0f b6 06             	movzbl (%esi),%eax
 745:	83 c4 10             	add    $0x10,%esp
 748:	84 c0                	test   %al,%al
 74a:	75 e4                	jne    730 <printf+0x110>
      state = 0;
 74c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 17 ff ff ff       	jmp    66d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 756:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 759:	83 ec 0c             	sub    $0xc,%esp
 75c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 761:	8b 13                	mov    (%ebx),%edx
 763:	6a 01                	push   $0x1
 765:	eb 88                	jmp    6ef <printf+0xcf>
        putc(fd, *ap);
 767:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 76a:	83 ec 04             	sub    $0x4,%esp
 76d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 770:	8b 03                	mov    (%ebx),%eax
        ap++;
 772:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 775:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 778:	6a 01                	push   $0x1
 77a:	52                   	push   %edx
 77b:	57                   	push   %edi
 77c:	e8 62 fd ff ff       	call   4e3 <write>
        ap++;
 781:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 784:	83 c4 10             	add    $0x10,%esp
      state = 0;
 787:	31 d2                	xor    %edx,%edx
 789:	e9 df fe ff ff       	jmp    66d <printf+0x4d>
 78e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
 793:	88 5d e7             	mov    %bl,-0x19(%ebp)
 796:	8d 55 e7             	lea    -0x19(%ebp),%edx
 799:	6a 01                	push   $0x1
 79b:	e9 31 ff ff ff       	jmp    6d1 <printf+0xb1>
 7a0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7a5:	bb 33 09 00 00       	mov    $0x933,%ebx
 7aa:	e9 77 ff ff ff       	jmp    726 <printf+0x106>
 7af:	90                   	nop

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b1:	a1 3c 0c 00 00       	mov    0xc3c,%eax
{
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	39 c8                	cmp    %ecx,%eax
 7cc:	73 32                	jae    800 <free+0x50>
 7ce:	39 d1                	cmp    %edx,%ecx
 7d0:	72 04                	jb     7d6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d2:	39 d0                	cmp    %edx,%eax
 7d4:	72 32                	jb     808 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7d9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7dc:	39 fa                	cmp    %edi,%edx
 7de:	74 30                	je     810 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7e3:	8b 50 04             	mov    0x4(%eax),%edx
 7e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e9:	39 f1                	cmp    %esi,%ecx
 7eb:	74 3a                	je     827 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ed:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7ef:	5b                   	pop    %ebx
  freep = p;
 7f0:	a3 3c 0c 00 00       	mov    %eax,0xc3c
}
 7f5:	5e                   	pop    %esi
 7f6:	5f                   	pop    %edi
 7f7:	5d                   	pop    %ebp
 7f8:	c3                   	ret
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	39 d0                	cmp    %edx,%eax
 802:	72 04                	jb     808 <free+0x58>
 804:	39 d1                	cmp    %edx,%ecx
 806:	72 ce                	jb     7d6 <free+0x26>
{
 808:	89 d0                	mov    %edx,%eax
 80a:	eb bc                	jmp    7c8 <free+0x18>
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 810:	03 72 04             	add    0x4(%edx),%esi
 813:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 12                	mov    (%edx),%edx
 81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 823:	39 f1                	cmp    %esi,%ecx
 825:	75 c6                	jne    7ed <free+0x3d>
    p->s.size += bp->s.size;
 827:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 82a:	a3 3c 0c 00 00       	mov    %eax,0xc3c
    p->s.size += bp->s.size;
 82f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 832:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 835:	89 08                	mov    %ecx,(%eax)
}
 837:	5b                   	pop    %ebx
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 84c:	8b 15 3c 0c 00 00    	mov    0xc3c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	8d 78 07             	lea    0x7(%eax),%edi
 855:	c1 ef 03             	shr    $0x3,%edi
 858:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 85b:	85 d2                	test   %edx,%edx
 85d:	0f 84 8d 00 00 00    	je     8f0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 863:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 865:	8b 48 04             	mov    0x4(%eax),%ecx
 868:	39 f9                	cmp    %edi,%ecx
 86a:	73 64                	jae    8d0 <malloc+0x90>
  if(nu < 4096)
 86c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 871:	39 df                	cmp    %ebx,%edi
 873:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 876:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 87d:	eb 0a                	jmp    889 <malloc+0x49>
 87f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 882:	8b 48 04             	mov    0x4(%eax),%ecx
 885:	39 f9                	cmp    %edi,%ecx
 887:	73 47                	jae    8d0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 889:	89 c2                	mov    %eax,%edx
 88b:	3b 05 3c 0c 00 00    	cmp    0xc3c,%eax
 891:	75 ed                	jne    880 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 893:	83 ec 0c             	sub    $0xc,%esp
 896:	56                   	push   %esi
 897:	e8 af fc ff ff       	call   54b <sbrk>
  if(p == (char*)-1)
 89c:	83 c4 10             	add    $0x10,%esp
 89f:	83 f8 ff             	cmp    $0xffffffff,%eax
 8a2:	74 1c                	je     8c0 <malloc+0x80>
  hp->s.size = nu;
 8a4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8a7:	83 ec 0c             	sub    $0xc,%esp
 8aa:	83 c0 08             	add    $0x8,%eax
 8ad:	50                   	push   %eax
 8ae:	e8 fd fe ff ff       	call   7b0 <free>
  return freep;
 8b3:	8b 15 3c 0c 00 00    	mov    0xc3c,%edx
      if((p = morecore(nunits)) == 0)
 8b9:	83 c4 10             	add    $0x10,%esp
 8bc:	85 d2                	test   %edx,%edx
 8be:	75 c0                	jne    880 <malloc+0x40>
        return 0;
  }
}
 8c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8c3:	31 c0                	xor    %eax,%eax
}
 8c5:	5b                   	pop    %ebx
 8c6:	5e                   	pop    %esi
 8c7:	5f                   	pop    %edi
 8c8:	5d                   	pop    %ebp
 8c9:	c3                   	ret
 8ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8d0:	39 cf                	cmp    %ecx,%edi
 8d2:	74 4c                	je     920 <malloc+0xe0>
        p->s.size -= nunits;
 8d4:	29 f9                	sub    %edi,%ecx
 8d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8dc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8df:	89 15 3c 0c 00 00    	mov    %edx,0xc3c
}
 8e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8e8:	83 c0 08             	add    $0x8,%eax
}
 8eb:	5b                   	pop    %ebx
 8ec:	5e                   	pop    %esi
 8ed:	5f                   	pop    %edi
 8ee:	5d                   	pop    %ebp
 8ef:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 3c 0c 00 00 40 	movl   $0xc40,0xc3c
 8f7:	0c 00 00 
    base.s.size = 0;
 8fa:	b8 40 0c 00 00       	mov    $0xc40,%eax
    base.s.ptr = freep = prevp = &base;
 8ff:	c7 05 40 0c 00 00 40 	movl   $0xc40,0xc40
 906:	0c 00 00 
    base.s.size = 0;
 909:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 910:	00 00 00 
    if(p->s.size >= nunits){
 913:	e9 54 ff ff ff       	jmp    86c <malloc+0x2c>
 918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 91f:	00 
        prevp->s.ptr = p->s.ptr;
 920:	8b 08                	mov    (%eax),%ecx
 922:	89 0a                	mov    %ecx,(%edx)
 924:	eb b9                	jmp    8df <malloc+0x9f>
