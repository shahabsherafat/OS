
_cpttest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
         st.accesses, st.hits, st.misses, st.evictions, ratio, (t1 - t0));
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "\nCPT benchmark (hit count / hit ratio / time)\n");
  11:	68 e0 09 00 00       	push   $0x9e0
  16:	6a 01                	push   $0x1
  18:	e8 43 06 00 00       	call   660 <printf>
  run_one(CPT_FIFO);
  1d:	31 c0                	xor    %eax,%eax
  1f:	e8 3c 00 00 00       	call   60 <run_one>
  run_one(CPT_LRU);
  24:	b8 01 00 00 00       	mov    $0x1,%eax
  29:	e8 32 00 00 00       	call   60 <run_one>
  run_one(CPT_LFU);
  2e:	b8 02 00 00 00       	mov    $0x2,%eax
  33:	e8 28 00 00 00       	call   60 <run_one>
  run_one(CPT_CLOCK);
  38:	b8 03 00 00 00       	mov    $0x3,%eax
  3d:	e8 1e 00 00 00       	call   60 <run_one>
  printf(1, "done\n");
  42:	58                   	pop    %eax
  43:	5a                   	pop    %edx
  44:	68 8a 09 00 00       	push   $0x98a
  49:	6a 01                	push   $0x1
  4b:	e8 10 06 00 00       	call   660 <printf>
  exit();
  50:	e8 2e 04 00 00       	call   483 <exit>
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <run_one>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	57                   	push   %edi
  64:	56                   	push   %esi
  65:	53                   	push   %ebx
  66:	83 ec 58             	sub    $0x58,%esp
  69:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  char *base = (char*)malloc(6 * PGSZ);
  6c:	68 00 60 00 00       	push   $0x6000
  71:	e8 0a 08 00 00       	call   880 <malloc>
  if(base == 0){
  76:	83 c4 10             	add    $0x10,%esp
  79:	85 c0                	test   %eax,%eax
  7b:	0f 84 93 01 00 00    	je     214 <run_one+0x1b4>
  cptsetpolicy(pol);
  81:	83 ec 0c             	sub    $0xc,%esp
  84:	ff 75 b4             	push   -0x4c(%ebp)
  87:	89 c3                	mov    %eax,%ebx
  89:	e8 15 05 00 00       	call   5a3 <cptsetpolicy>
  cptresetstats();
  8e:	e8 18 05 00 00       	call   5ab <cptresetstats>
  t0 = uptime();
  93:	e8 83 04 00 00       	call   51b <uptime>
  98:	89 45 b0             	mov    %eax,-0x50(%ebp)
    vwrite(p, 100 + i);
  9b:	5e                   	pop    %esi
  9c:	5f                   	pop    %edi
  9d:	6a 64                	push   $0x64
    int *p = (int*)(base + i*PGSZ);
  9f:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
    vwrite(p, 100 + i);
  a5:	53                   	push   %ebx
  a6:	e8 f0 04 00 00       	call   59b <vwrite>
  ab:	58                   	pop    %eax
  ac:	5a                   	pop    %edx
  ad:	6a 65                	push   $0x65
  af:	57                   	push   %edi
  b0:	e8 e6 04 00 00       	call   59b <vwrite>
    int *p = (int*)(base + i*PGSZ);
  b5:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
  bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    vwrite(p, 100 + i);
  be:	59                   	pop    %ecx
  bf:	5e                   	pop    %esi
  c0:	6a 66                	push   $0x66
  for(i = 1; i <= 2000; i++){
  c2:	be 01 00 00 00       	mov    $0x1,%esi
    vwrite(p, 100 + i);
  c7:	50                   	push   %eax
  c8:	e8 ce 04 00 00       	call   59b <vwrite>
    int *p = (int*)(base + i*PGSZ);
  cd:	8d 83 00 30 00 00    	lea    0x3000(%ebx),%eax
  d3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    vwrite(p, 100 + i);
  d6:	5a                   	pop    %edx
  d7:	59                   	pop    %ecx
  d8:	6a 67                	push   $0x67
  da:	50                   	push   %eax
  db:	e8 bb 04 00 00       	call   59b <vwrite>
      vread((int*)(base + 4*PGSZ));
  e0:	8d 83 00 40 00 00    	lea    0x4000(%ebx),%eax
    vwrite(p, 100 + i);
  e6:	83 c4 10             	add    $0x10,%esp
      vread((int*)(base + 4*PGSZ));
  e9:	89 45 bc             	mov    %eax,-0x44(%ebp)
      vread((int*)(base + 5*PGSZ));
  ec:	8d 83 00 50 00 00    	lea    0x5000(%ebx),%eax
  f2:	89 45 b8             	mov    %eax,-0x48(%ebp)
  f5:	eb 14                	jmp    10b <run_one+0xab>
  f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  fe:	00 
  ff:	90                   	nop
  for(i = 1; i <= 2000; i++){
 100:	83 c6 01             	add    $0x1,%esi
 103:	81 fe d1 07 00 00    	cmp    $0x7d1,%esi
 109:	74 67                	je     172 <run_one+0x112>
    vread((int*)(base + 0*PGSZ));
 10b:	83 ec 0c             	sub    $0xc,%esp
 10e:	53                   	push   %ebx
 10f:	e8 7f 04 00 00       	call   593 <vread>
    vread((int*)(base + 1*PGSZ));
 114:	89 3c 24             	mov    %edi,(%esp)
 117:	e8 77 04 00 00       	call   593 <vread>
    vread((int*)(base + 2*PGSZ));
 11c:	5a                   	pop    %edx
 11d:	ff 75 c0             	push   -0x40(%ebp)
 120:	e8 6e 04 00 00       	call   593 <vread>
    vread((int*)(base + 3*PGSZ));
 125:	59                   	pop    %ecx
 126:	ff 75 c4             	push   -0x3c(%ebp)
 129:	e8 65 04 00 00       	call   593 <vread>
    vread((int*)(base + 0*PGSZ));
 12e:	89 1c 24             	mov    %ebx,(%esp)
 131:	e8 5d 04 00 00       	call   593 <vread>
 136:	69 c6 cd cc cc cc    	imul   $0xcccccccd,%esi,%eax
 13c:	83 c4 10             	add    $0x10,%esp
 13f:	d1 c8                	ror    $1,%eax
    if(i % 10 == 0)
 141:	3d 99 99 99 19       	cmp    $0x19999999,%eax
 146:	0f 86 a4 00 00 00    	jbe    1f0 <run_one+0x190>
      vread((int*)(base + 4*PGSZ));
 14c:	69 c6 29 5c 8f c2    	imul   $0xc28f5c29,%esi,%eax
    if(i % 25 == 0)
 152:	3d a3 70 3d 0a       	cmp    $0xa3d70a3,%eax
 157:	77 a7                	ja     100 <run_one+0xa0>
      vread((int*)(base + 5*PGSZ));
 159:	83 ec 0c             	sub    $0xc,%esp
 15c:	ff 75 b8             	push   -0x48(%ebp)
  for(i = 1; i <= 2000; i++){
 15f:	83 c6 01             	add    $0x1,%esi
      vread((int*)(base + 5*PGSZ));
 162:	e8 2c 04 00 00       	call   593 <vread>
 167:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i <= 2000; i++){
 16a:	81 fe d1 07 00 00    	cmp    $0x7d1,%esi
 170:	75 99                	jne    10b <run_one+0xab>
  t1 = uptime();
 172:	e8 a4 03 00 00       	call   51b <uptime>
  cptgetstats(&st);
 177:	83 ec 0c             	sub    $0xc,%esp
  t1 = uptime();
 17a:	89 c3                	mov    %eax,%ebx
  cptgetstats(&st);
 17c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
 17f:	50                   	push   %eax
 180:	e8 2e 04 00 00       	call   5b3 <cptgetstats>
  if(st.accesses > 0)
 185:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 188:	83 c4 10             	add    $0x10,%esp
 18b:	85 c9                	test   %ecx,%ecx
 18d:	7e 74                	jle    203 <run_one+0x1a3>
    ratio = (st.hits * 100) / st.accesses;
 18f:	8b 75 d8             	mov    -0x28(%ebp),%esi
 192:	6b c6 64             	imul   $0x64,%esi,%eax
 195:	99                   	cltd
 196:	f7 f9                	idiv   %ecx
 198:	89 45 c0             	mov    %eax,-0x40(%ebp)
  printf(1, "%s: accesses=%d hits=%d miss=%d evict=%d hit_ratio=%d%% time=%d ticks\n",
 19b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  if(pol == CPT_FIFO)  return "FIFO";
 19e:	8b 7d b4             	mov    -0x4c(%ebp),%edi
  printf(1, "%s: accesses=%d hits=%d miss=%d evict=%d hit_ratio=%d%% time=%d ticks\n",
 1a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
 1a4:	29 c3                	sub    %eax,%ebx
 1a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if(pol == CPT_FIFO)  return "FIFO";
 1ac:	b8 68 09 00 00       	mov    $0x968,%eax
 1b1:	85 ff                	test   %edi,%edi
 1b3:	74 15                	je     1ca <run_one+0x16a>
  if(pol == CPT_LRU)   return "LRU";
 1b5:	83 ff 01             	cmp    $0x1,%edi
 1b8:	74 53                	je     20d <run_one+0x1ad>
  return "CLOCK";
 1ba:	83 ff 02             	cmp    $0x2,%edi
 1bd:	b8 77 09 00 00       	mov    $0x977,%eax
 1c2:	bf 71 09 00 00       	mov    $0x971,%edi
 1c7:	0f 45 c7             	cmovne %edi,%eax
  printf(1, "%s: accesses=%d hits=%d miss=%d evict=%d hit_ratio=%d%% time=%d ticks\n",
 1ca:	83 ec 0c             	sub    $0xc,%esp
 1cd:	53                   	push   %ebx
 1ce:	ff 75 c0             	push   -0x40(%ebp)
 1d1:	ff 75 c4             	push   -0x3c(%ebp)
 1d4:	52                   	push   %edx
 1d5:	56                   	push   %esi
 1d6:	51                   	push   %ecx
 1d7:	50                   	push   %eax
 1d8:	68 98 09 00 00       	push   $0x998
 1dd:	6a 01                	push   $0x1
 1df:	e8 7c 04 00 00       	call   660 <printf>
}
 1e4:	83 c4 30             	add    $0x30,%esp
 1e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ea:	5b                   	pop    %ebx
 1eb:	5e                   	pop    %esi
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret
 1ef:	90                   	nop
      vread((int*)(base + 4*PGSZ));
 1f0:	83 ec 0c             	sub    $0xc,%esp
 1f3:	ff 75 bc             	push   -0x44(%ebp)
 1f6:	e8 98 03 00 00       	call   593 <vread>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	e9 49 ff ff ff       	jmp    14c <run_one+0xec>
  int ratio = 0;
 203:	31 c0                	xor    %eax,%eax
 205:	8b 75 d8             	mov    -0x28(%ebp),%esi
 208:	89 45 c0             	mov    %eax,-0x40(%ebp)
 20b:	eb 8e                	jmp    19b <run_one+0x13b>
  if(pol == CPT_LRU)   return "LRU";
 20d:	b8 6d 09 00 00       	mov    $0x96d,%eax
 212:	eb b6                	jmp    1ca <run_one+0x16a>
    printf(1, "malloc failed\n");
 214:	53                   	push   %ebx
 215:	53                   	push   %ebx
 216:	68 7b 09 00 00       	push   $0x97b
 21b:	6a 01                	push   $0x1
 21d:	e8 3e 04 00 00       	call   660 <printf>
    exit();
 222:	e8 5c 02 00 00       	call   483 <exit>
 227:	66 90                	xchg   %ax,%ax
 229:	66 90                	xchg   %ax,%ax
 22b:	66 90                	xchg   %ax,%ax
 22d:	66 90                	xchg   %ax,%ax
 22f:	90                   	nop

00000230 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 230:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 231:	31 c0                	xor    %eax,%eax
{
 233:	89 e5                	mov    %esp,%ebp
 235:	53                   	push   %ebx
 236:	8b 4d 08             	mov    0x8(%ebp),%ecx
 239:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 240:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 244:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 247:	83 c0 01             	add    $0x1,%eax
 24a:	84 d2                	test   %dl,%dl
 24c:	75 f2                	jne    240 <strcpy+0x10>
    ;
  return os;
}
 24e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 251:	89 c8                	mov    %ecx,%eax
 253:	c9                   	leave
 254:	c3                   	ret
 255:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 25c:	00 
 25d:	8d 76 00             	lea    0x0(%esi),%esi

00000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 55 08             	mov    0x8(%ebp),%edx
 267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 26a:	0f b6 02             	movzbl (%edx),%eax
 26d:	84 c0                	test   %al,%al
 26f:	75 17                	jne    288 <strcmp+0x28>
 271:	eb 3a                	jmp    2ad <strcmp+0x4d>
 273:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 278:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 27c:	83 c2 01             	add    $0x1,%edx
 27f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 282:	84 c0                	test   %al,%al
 284:	74 1a                	je     2a0 <strcmp+0x40>
 286:	89 d9                	mov    %ebx,%ecx
 288:	0f b6 19             	movzbl (%ecx),%ebx
 28b:	38 c3                	cmp    %al,%bl
 28d:	74 e9                	je     278 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 28f:	29 d8                	sub    %ebx,%eax
}
 291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 294:	c9                   	leave
 295:	c3                   	ret
 296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 29d:	00 
 29e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 2a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2a4:	31 c0                	xor    %eax,%eax
 2a6:	29 d8                	sub    %ebx,%eax
}
 2a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ab:	c9                   	leave
 2ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 2ad:	0f b6 19             	movzbl (%ecx),%ebx
 2b0:	31 c0                	xor    %eax,%eax
 2b2:	eb db                	jmp    28f <strcmp+0x2f>
 2b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bb:	00 
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002c0 <strlen>:

uint
strlen(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2c6:	80 3a 00             	cmpb   $0x0,(%edx)
 2c9:	74 15                	je     2e0 <strlen+0x20>
 2cb:	31 c0                	xor    %eax,%eax
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2d7:	89 c1                	mov    %eax,%ecx
 2d9:	75 f5                	jne    2d0 <strlen+0x10>
    ;
  return n;
}
 2db:	89 c8                	mov    %ecx,%eax
 2dd:	5d                   	pop    %ebp
 2de:	c3                   	ret
 2df:	90                   	nop
  for(n = 0; s[n]; n++)
 2e0:	31 c9                	xor    %ecx,%ecx
}
 2e2:	5d                   	pop    %ebp
 2e3:	89 c8                	mov    %ecx,%eax
 2e5:	c3                   	ret
 2e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ed:	00 
 2ee:	66 90                	xchg   %ax,%ax

000002f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fd:	89 d7                	mov    %edx,%edi
 2ff:	fc                   	cld
 300:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 302:	8b 7d fc             	mov    -0x4(%ebp),%edi
 305:	89 d0                	mov    %edx,%eax
 307:	c9                   	leave
 308:	c3                   	ret
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <strchr>:

char*
strchr(const char *s, char c)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 31a:	0f b6 10             	movzbl (%eax),%edx
 31d:	84 d2                	test   %dl,%dl
 31f:	75 12                	jne    333 <strchr+0x23>
 321:	eb 1d                	jmp    340 <strchr+0x30>
 323:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 328:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 32c:	83 c0 01             	add    $0x1,%eax
 32f:	84 d2                	test   %dl,%dl
 331:	74 0d                	je     340 <strchr+0x30>
    if(*s == c)
 333:	38 d1                	cmp    %dl,%cl
 335:	75 f1                	jne    328 <strchr+0x18>
      return (char*)s;
  return 0;
}
 337:	5d                   	pop    %ebp
 338:	c3                   	ret
 339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 340:	31 c0                	xor    %eax,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret
 344:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 34b:	00 
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <gets>:

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 355:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 358:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 359:	31 db                	xor    %ebx,%ebx
 35b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 35e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 361:	3b 75 0c             	cmp    0xc(%ebp),%esi
 364:	7d 3b                	jge    3a1 <gets+0x51>
 366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 36d:	00 
 36e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 370:	83 ec 04             	sub    $0x4,%esp
 373:	6a 01                	push   $0x1
 375:	57                   	push   %edi
 376:	6a 00                	push   $0x0
 378:	e8 1e 01 00 00       	call   49b <read>
    if(cc < 1)
 37d:	83 c4 10             	add    $0x10,%esp
 380:	85 c0                	test   %eax,%eax
 382:	7e 1d                	jle    3a1 <gets+0x51>
      break;
      
    buf[i++] = c;
 384:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 388:	8b 55 08             	mov    0x8(%ebp),%edx
 38b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 38f:	3c 0a                	cmp    $0xa,%al
 391:	7f 25                	jg     3b8 <gets+0x68>
 393:	3c 08                	cmp    $0x8,%al
 395:	7f 0c                	jg     3a3 <gets+0x53>
{
 397:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 399:	8d 73 01             	lea    0x1(%ebx),%esi
 39c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 39f:	7c cf                	jl     370 <gets+0x20>
 3a1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5f                   	pop    %edi
 3b0:	5d                   	pop    %ebp
 3b1:	c3                   	ret
 3b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3b8:	3c 0d                	cmp    $0xd,%al
 3ba:	74 e7                	je     3a3 <gets+0x53>
{
 3bc:	89 f3                	mov    %esi,%ebx
 3be:	eb d9                	jmp    399 <gets+0x49>

000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c5:	83 ec 08             	sub    $0x8,%esp
 3c8:	6a 00                	push   $0x0
 3ca:	ff 75 08             	push   0x8(%ebp)
 3cd:	e8 f1 00 00 00       	call   4c3 <open>
  if(fd < 0)
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 27                	js     400 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3d9:	83 ec 08             	sub    $0x8,%esp
 3dc:	ff 75 0c             	push   0xc(%ebp)
 3df:	89 c3                	mov    %eax,%ebx
 3e1:	50                   	push   %eax
 3e2:	e8 f4 00 00 00       	call   4db <fstat>
  close(fd);
 3e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ea:	89 c6                	mov    %eax,%esi
  close(fd);
 3ec:	e8 ba 00 00 00       	call   4ab <close>
  return r;
 3f1:	83 c4 10             	add    $0x10,%esp
}
 3f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f7:	89 f0                	mov    %esi,%eax
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 400:	be ff ff ff ff       	mov    $0xffffffff,%esi
 405:	eb ed                	jmp    3f4 <stat+0x34>
 407:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40e:	00 
 40f:	90                   	nop

00000410 <atoi>:

int
atoi(const char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 417:	0f be 02             	movsbl (%edx),%eax
 41a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 41d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 420:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 425:	77 1e                	ja     445 <atoi+0x35>
 427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42e:	00 
 42f:	90                   	nop
    n = n*10 + *s++ - '0';
 430:	83 c2 01             	add    $0x1,%edx
 433:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 436:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 43a:	0f be 02             	movsbl (%edx),%eax
 43d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 440:	80 fb 09             	cmp    $0x9,%bl
 443:	76 eb                	jbe    430 <atoi+0x20>
  return n;
}
 445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 448:	89 c8                	mov    %ecx,%eax
 44a:	c9                   	leave
 44b:	c3                   	ret
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	8b 45 10             	mov    0x10(%ebp),%eax
 457:	8b 55 08             	mov    0x8(%ebp),%edx
 45a:	56                   	push   %esi
 45b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 45e:	85 c0                	test   %eax,%eax
 460:	7e 13                	jle    475 <memmove+0x25>
 462:	01 d0                	add    %edx,%eax
  dst = vdst;
 464:	89 d7                	mov    %edx,%edi
 466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46d:	00 
 46e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 470:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 471:	39 f8                	cmp    %edi,%eax
 473:	75 fb                	jne    470 <memmove+0x20>
  return vdst;
}
 475:	5e                   	pop    %esi
 476:	89 d0                	mov    %edx,%eax
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret

0000047b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47b:	b8 01 00 00 00       	mov    $0x1,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <exit>:
SYSCALL(exit)
 483:	b8 02 00 00 00       	mov    $0x2,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <wait>:
SYSCALL(wait)
 48b:	b8 03 00 00 00       	mov    $0x3,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <pipe>:
SYSCALL(pipe)
 493:	b8 04 00 00 00       	mov    $0x4,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <read>:
SYSCALL(read)
 49b:	b8 05 00 00 00       	mov    $0x5,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret

000004a3 <write>:
SYSCALL(write)
 4a3:	b8 10 00 00 00       	mov    $0x10,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret

000004ab <close>:
SYSCALL(close)
 4ab:	b8 15 00 00 00       	mov    $0x15,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret

000004b3 <kill>:
SYSCALL(kill)
 4b3:	b8 06 00 00 00       	mov    $0x6,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret

000004bb <exec>:
SYSCALL(exec)
 4bb:	b8 07 00 00 00       	mov    $0x7,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret

000004c3 <open>:
SYSCALL(open)
 4c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret

000004cb <mknod>:
SYSCALL(mknod)
 4cb:	b8 11 00 00 00       	mov    $0x11,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret

000004d3 <unlink>:
SYSCALL(unlink)
 4d3:	b8 12 00 00 00       	mov    $0x12,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret

000004db <fstat>:
SYSCALL(fstat)
 4db:	b8 08 00 00 00       	mov    $0x8,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret

000004e3 <link>:
SYSCALL(link)
 4e3:	b8 13 00 00 00       	mov    $0x13,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret

000004eb <mkdir>:
SYSCALL(mkdir)
 4eb:	b8 14 00 00 00       	mov    $0x14,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret

000004f3 <chdir>:
SYSCALL(chdir)
 4f3:	b8 09 00 00 00       	mov    $0x9,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret

000004fb <dup>:
SYSCALL(dup)
 4fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret

00000503 <getpid>:
SYSCALL(getpid)
 503:	b8 0b 00 00 00       	mov    $0xb,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret

0000050b <sbrk>:
SYSCALL(sbrk)
 50b:	b8 0c 00 00 00       	mov    $0xc,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <sleep>:
SYSCALL(sleep)
 513:	b8 0d 00 00 00       	mov    $0xd,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <uptime>:
SYSCALL(uptime)
 51b:	b8 0e 00 00 00       	mov    $0xe,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 523:	b8 17 00 00 00       	mov    $0x17,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <show_process_family>:
SYSCALL(show_process_family)
 52b:	b8 18 00 00 00       	mov    $0x18,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 533:	b8 16 00 00 00       	mov    $0x16,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <grep_syscall>:
SYSCALL(grep_syscall)
 53b:	b8 19 00 00 00       	mov    $0x19,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 543:	b8 1a 00 00 00       	mov    $0x1a,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 54b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 553:	b8 1c 00 00 00       	mov    $0x1c,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 55b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 563:	b8 1e 00 00 00       	mov    $0x1e,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 56b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 573:	b8 20 00 00 00       	mov    $0x20,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 57b:	b8 21 00 00 00       	mov    $0x21,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <release_plock_sys>:
SYSCALL(release_plock_sys)
 583:	b8 22 00 00 00       	mov    $0x22,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <getlockstat>:

SYSCALL(getlockstat)
 58b:	b8 23 00 00 00       	mov    $0x23,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <vread>:

SYSCALL(vread)
 593:	b8 24 00 00 00       	mov    $0x24,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <vwrite>:
SYSCALL(vwrite)
 59b:	b8 25 00 00 00       	mov    $0x25,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <cptsetpolicy>:
SYSCALL(cptsetpolicy)
 5a3:	b8 26 00 00 00       	mov    $0x26,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <cptresetstats>:
SYSCALL(cptresetstats)
 5ab:	b8 27 00 00 00       	mov    $0x27,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <cptgetstats>:
SYSCALL(cptgetstats)
 5b3:	b8 28 00 00 00       	mov    $0x28,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret
 5bb:	66 90                	xchg   %ax,%ax
 5bd:	66 90                	xchg   %ax,%ax
 5bf:	90                   	nop

000005c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5c8:	89 d1                	mov    %edx,%ecx
{
 5ca:	83 ec 3c             	sub    $0x3c,%esp
 5cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5d0:	85 d2                	test   %edx,%edx
 5d2:	0f 89 80 00 00 00    	jns    658 <printint+0x98>
 5d8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5dc:	74 7a                	je     658 <printint+0x98>
    x = -xx;
 5de:	f7 d9                	neg    %ecx
    neg = 1;
 5e0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5e8:	31 f6                	xor    %esi,%esi
 5ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5f0:	89 c8                	mov    %ecx,%eax
 5f2:	31 d2                	xor    %edx,%edx
 5f4:	89 f7                	mov    %esi,%edi
 5f6:	f7 f3                	div    %ebx
 5f8:	8d 76 01             	lea    0x1(%esi),%esi
 5fb:	0f b6 92 68 0a 00 00 	movzbl 0xa68(%edx),%edx
 602:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 606:	89 ca                	mov    %ecx,%edx
 608:	89 c1                	mov    %eax,%ecx
 60a:	39 da                	cmp    %ebx,%edx
 60c:	73 e2                	jae    5f0 <printint+0x30>
  if(neg)
 60e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 611:	85 c0                	test   %eax,%eax
 613:	74 07                	je     61c <printint+0x5c>
    buf[i++] = '-';
 615:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 61a:	89 f7                	mov    %esi,%edi
 61c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 61f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 622:	01 df                	add    %ebx,%edi
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 628:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 62b:	83 ec 04             	sub    $0x4,%esp
 62e:	88 45 d7             	mov    %al,-0x29(%ebp)
 631:	8d 45 d7             	lea    -0x29(%ebp),%eax
 634:	6a 01                	push   $0x1
 636:	50                   	push   %eax
 637:	56                   	push   %esi
 638:	e8 66 fe ff ff       	call   4a3 <write>
  while(--i >= 0)
 63d:	89 f8                	mov    %edi,%eax
 63f:	83 c4 10             	add    $0x10,%esp
 642:	83 ef 01             	sub    $0x1,%edi
 645:	39 c3                	cmp    %eax,%ebx
 647:	75 df                	jne    628 <printint+0x68>
}
 649:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64c:	5b                   	pop    %ebx
 64d:	5e                   	pop    %esi
 64e:	5f                   	pop    %edi
 64f:	5d                   	pop    %ebp
 650:	c3                   	ret
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 658:	31 c0                	xor    %eax,%eax
 65a:	eb 89                	jmp    5e5 <printint+0x25>
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 669:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 66c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 66f:	0f b6 1e             	movzbl (%esi),%ebx
 672:	83 c6 01             	add    $0x1,%esi
 675:	84 db                	test   %bl,%bl
 677:	74 67                	je     6e0 <printf+0x80>
 679:	8d 4d 10             	lea    0x10(%ebp),%ecx
 67c:	31 d2                	xor    %edx,%edx
 67e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 681:	eb 34                	jmp    6b7 <printf+0x57>
 683:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 688:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 68b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 690:	83 f8 25             	cmp    $0x25,%eax
 693:	74 18                	je     6ad <printf+0x4d>
  write(fd, &c, 1);
 695:	83 ec 04             	sub    $0x4,%esp
 698:	8d 45 e7             	lea    -0x19(%ebp),%eax
 69b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 69e:	6a 01                	push   $0x1
 6a0:	50                   	push   %eax
 6a1:	57                   	push   %edi
 6a2:	e8 fc fd ff ff       	call   4a3 <write>
 6a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6aa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6ad:	0f b6 1e             	movzbl (%esi),%ebx
 6b0:	83 c6 01             	add    $0x1,%esi
 6b3:	84 db                	test   %bl,%bl
 6b5:	74 29                	je     6e0 <printf+0x80>
    c = fmt[i] & 0xff;
 6b7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6ba:	85 d2                	test   %edx,%edx
 6bc:	74 ca                	je     688 <printf+0x28>
      }
    } else if(state == '%'){
 6be:	83 fa 25             	cmp    $0x25,%edx
 6c1:	75 ea                	jne    6ad <printf+0x4d>
      if(c == 'd'){
 6c3:	83 f8 25             	cmp    $0x25,%eax
 6c6:	0f 84 04 01 00 00    	je     7d0 <printf+0x170>
 6cc:	83 e8 63             	sub    $0x63,%eax
 6cf:	83 f8 15             	cmp    $0x15,%eax
 6d2:	77 1c                	ja     6f0 <printf+0x90>
 6d4:	ff 24 85 10 0a 00 00 	jmp    *0xa10(,%eax,4)
 6db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e3:	5b                   	pop    %ebx
 6e4:	5e                   	pop    %esi
 6e5:	5f                   	pop    %edi
 6e6:	5d                   	pop    %ebp
 6e7:	c3                   	ret
 6e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ef:	00 
  write(fd, &c, 1);
 6f0:	83 ec 04             	sub    $0x4,%esp
 6f3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6f6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6fa:	6a 01                	push   $0x1
 6fc:	52                   	push   %edx
 6fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 700:	57                   	push   %edi
 701:	e8 9d fd ff ff       	call   4a3 <write>
 706:	83 c4 0c             	add    $0xc,%esp
 709:	88 5d e7             	mov    %bl,-0x19(%ebp)
 70c:	6a 01                	push   $0x1
 70e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 711:	52                   	push   %edx
 712:	57                   	push   %edi
 713:	e8 8b fd ff ff       	call   4a3 <write>
        putc(fd, c);
 718:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71b:	31 d2                	xor    %edx,%edx
 71d:	eb 8e                	jmp    6ad <printf+0x4d>
 71f:	90                   	nop
        printint(fd, *ap, 16, 0);
 720:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 723:	83 ec 0c             	sub    $0xc,%esp
 726:	b9 10 00 00 00       	mov    $0x10,%ecx
 72b:	8b 13                	mov    (%ebx),%edx
 72d:	6a 00                	push   $0x0
 72f:	89 f8                	mov    %edi,%eax
        ap++;
 731:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 734:	e8 87 fe ff ff       	call   5c0 <printint>
        ap++;
 739:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 73c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73f:	31 d2                	xor    %edx,%edx
 741:	e9 67 ff ff ff       	jmp    6ad <printf+0x4d>
        s = (char*)*ap;
 746:	8b 45 d0             	mov    -0x30(%ebp),%eax
 749:	8b 18                	mov    (%eax),%ebx
        ap++;
 74b:	83 c0 04             	add    $0x4,%eax
 74e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 751:	85 db                	test   %ebx,%ebx
 753:	0f 84 87 00 00 00    	je     7e0 <printf+0x180>
        while(*s != 0){
 759:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 75c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 75e:	84 c0                	test   %al,%al
 760:	0f 84 47 ff ff ff    	je     6ad <printf+0x4d>
 766:	8d 55 e7             	lea    -0x19(%ebp),%edx
 769:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 76c:	89 de                	mov    %ebx,%esi
 76e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 770:	83 ec 04             	sub    $0x4,%esp
 773:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 776:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 779:	6a 01                	push   $0x1
 77b:	53                   	push   %ebx
 77c:	57                   	push   %edi
 77d:	e8 21 fd ff ff       	call   4a3 <write>
        while(*s != 0){
 782:	0f b6 06             	movzbl (%esi),%eax
 785:	83 c4 10             	add    $0x10,%esp
 788:	84 c0                	test   %al,%al
 78a:	75 e4                	jne    770 <printf+0x110>
      state = 0;
 78c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 78f:	31 d2                	xor    %edx,%edx
 791:	e9 17 ff ff ff       	jmp    6ad <printf+0x4d>
        printint(fd, *ap, 10, 1);
 796:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 799:	83 ec 0c             	sub    $0xc,%esp
 79c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7a1:	8b 13                	mov    (%ebx),%edx
 7a3:	6a 01                	push   $0x1
 7a5:	eb 88                	jmp    72f <printf+0xcf>
        putc(fd, *ap);
 7a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7aa:	83 ec 04             	sub    $0x4,%esp
 7ad:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7b0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7b2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b8:	6a 01                	push   $0x1
 7ba:	52                   	push   %edx
 7bb:	57                   	push   %edi
 7bc:	e8 e2 fc ff ff       	call   4a3 <write>
        ap++;
 7c1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c7:	31 d2                	xor    %edx,%edx
 7c9:	e9 df fe ff ff       	jmp    6ad <printf+0x4d>
 7ce:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
 7d3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7d6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7d9:	6a 01                	push   $0x1
 7db:	e9 31 ff ff ff       	jmp    711 <printf+0xb1>
 7e0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7e5:	bb 90 09 00 00       	mov    $0x990,%ebx
 7ea:	e9 77 ff ff ff       	jmp    766 <printf+0x106>
 7ef:	90                   	nop

000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	a1 34 0d 00 00       	mov    0xd34,%eax
{
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	57                   	push   %edi
 7f9:	56                   	push   %esi
 7fa:	53                   	push   %ebx
 7fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	39 c8                	cmp    %ecx,%eax
 80c:	73 32                	jae    840 <free+0x50>
 80e:	39 d1                	cmp    %edx,%ecx
 810:	72 04                	jb     816 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	39 d0                	cmp    %edx,%eax
 814:	72 32                	jb     848 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 816:	8b 73 fc             	mov    -0x4(%ebx),%esi
 819:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81c:	39 fa                	cmp    %edi,%edx
 81e:	74 30                	je     850 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 823:	8b 50 04             	mov    0x4(%eax),%edx
 826:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 829:	39 f1                	cmp    %esi,%ecx
 82b:	74 3a                	je     867 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 82d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 82f:	5b                   	pop    %ebx
  freep = p;
 830:	a3 34 0d 00 00       	mov    %eax,0xd34
}
 835:	5e                   	pop    %esi
 836:	5f                   	pop    %edi
 837:	5d                   	pop    %ebp
 838:	c3                   	ret
 839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	39 d0                	cmp    %edx,%eax
 842:	72 04                	jb     848 <free+0x58>
 844:	39 d1                	cmp    %edx,%ecx
 846:	72 ce                	jb     816 <free+0x26>
{
 848:	89 d0                	mov    %edx,%eax
 84a:	eb bc                	jmp    808 <free+0x18>
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 850:	03 72 04             	add    0x4(%edx),%esi
 853:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	8b 10                	mov    (%eax),%edx
 858:	8b 12                	mov    (%edx),%edx
 85a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 85d:	8b 50 04             	mov    0x4(%eax),%edx
 860:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 863:	39 f1                	cmp    %esi,%ecx
 865:	75 c6                	jne    82d <free+0x3d>
    p->s.size += bp->s.size;
 867:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 86a:	a3 34 0d 00 00       	mov    %eax,0xd34
    p->s.size += bp->s.size;
 86f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 872:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 875:	89 08                	mov    %ecx,(%eax)
}
 877:	5b                   	pop    %ebx
 878:	5e                   	pop    %esi
 879:	5f                   	pop    %edi
 87a:	5d                   	pop    %ebp
 87b:	c3                   	ret
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000880 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	57                   	push   %edi
 884:	56                   	push   %esi
 885:	53                   	push   %ebx
 886:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 889:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 88c:	8b 15 34 0d 00 00    	mov    0xd34,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	8d 78 07             	lea    0x7(%eax),%edi
 895:	c1 ef 03             	shr    $0x3,%edi
 898:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 89b:	85 d2                	test   %edx,%edx
 89d:	0f 84 8d 00 00 00    	je     930 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8a5:	8b 48 04             	mov    0x4(%eax),%ecx
 8a8:	39 f9                	cmp    %edi,%ecx
 8aa:	73 64                	jae    910 <malloc+0x90>
  if(nu < 4096)
 8ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8b1:	39 df                	cmp    %ebx,%edi
 8b3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8b6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8bd:	eb 0a                	jmp    8c9 <malloc+0x49>
 8bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c2:	8b 48 04             	mov    0x4(%eax),%ecx
 8c5:	39 f9                	cmp    %edi,%ecx
 8c7:	73 47                	jae    910 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c9:	89 c2                	mov    %eax,%edx
 8cb:	3b 05 34 0d 00 00    	cmp    0xd34,%eax
 8d1:	75 ed                	jne    8c0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8d3:	83 ec 0c             	sub    $0xc,%esp
 8d6:	56                   	push   %esi
 8d7:	e8 2f fc ff ff       	call   50b <sbrk>
  if(p == (char*)-1)
 8dc:	83 c4 10             	add    $0x10,%esp
 8df:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e2:	74 1c                	je     900 <malloc+0x80>
  hp->s.size = nu;
 8e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8e7:	83 ec 0c             	sub    $0xc,%esp
 8ea:	83 c0 08             	add    $0x8,%eax
 8ed:	50                   	push   %eax
 8ee:	e8 fd fe ff ff       	call   7f0 <free>
  return freep;
 8f3:	8b 15 34 0d 00 00    	mov    0xd34,%edx
      if((p = morecore(nunits)) == 0)
 8f9:	83 c4 10             	add    $0x10,%esp
 8fc:	85 d2                	test   %edx,%edx
 8fe:	75 c0                	jne    8c0 <malloc+0x40>
        return 0;
  }
}
 900:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 903:	31 c0                	xor    %eax,%eax
}
 905:	5b                   	pop    %ebx
 906:	5e                   	pop    %esi
 907:	5f                   	pop    %edi
 908:	5d                   	pop    %ebp
 909:	c3                   	ret
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 910:	39 cf                	cmp    %ecx,%edi
 912:	74 4c                	je     960 <malloc+0xe0>
        p->s.size -= nunits;
 914:	29 f9                	sub    %edi,%ecx
 916:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 919:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 91c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 91f:	89 15 34 0d 00 00    	mov    %edx,0xd34
}
 925:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 928:	83 c0 08             	add    $0x8,%eax
}
 92b:	5b                   	pop    %ebx
 92c:	5e                   	pop    %esi
 92d:	5f                   	pop    %edi
 92e:	5d                   	pop    %ebp
 92f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 930:	c7 05 34 0d 00 00 38 	movl   $0xd38,0xd34
 937:	0d 00 00 
    base.s.size = 0;
 93a:	b8 38 0d 00 00       	mov    $0xd38,%eax
    base.s.ptr = freep = prevp = &base;
 93f:	c7 05 38 0d 00 00 38 	movl   $0xd38,0xd38
 946:	0d 00 00 
    base.s.size = 0;
 949:	c7 05 3c 0d 00 00 00 	movl   $0x0,0xd3c
 950:	00 00 00 
    if(p->s.size >= nunits){
 953:	e9 54 ff ff ff       	jmp    8ac <malloc+0x2c>
 958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 95f:	00 
        prevp->s.ptr = p->s.ptr;
 960:	8b 08                	mov    (%eax),%ecx
 962:	89 0a                	mov    %ecx,(%edx)
 964:	eb b9                	jmp    91f <malloc+0x9f>
