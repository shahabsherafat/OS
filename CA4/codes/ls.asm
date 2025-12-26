
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  10:	bb 01 00 00 00       	mov    $0x1,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	push   (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
  exit();
  3d:	e8 41 05 00 00       	call   583 <exit>
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 80 0a 00 00       	push   $0xa80
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 2f 05 00 00       	call   583 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	56                   	push   %esi
  6c:	e8 4f 03 00 00       	call   3c0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 f0                	add    %esi,%eax
  76:	89 c3                	mov    %eax,%ebx
  78:	73 0f                	jae    89 <fmtname+0x29>
  7a:	eb 12                	jmp    8e <fmtname+0x2e>
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  83:	39 f0                	cmp    %esi,%eax
  85:	72 0a                	jb     91 <fmtname+0x31>
  87:	89 c3                	mov    %eax,%ebx
  89:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8c:	75 f2                	jne    80 <fmtname+0x20>
  p++;
  8e:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	53                   	push   %ebx
  95:	e8 26 03 00 00       	call   3c0 <strlen>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	83 f8 0d             	cmp    $0xd,%eax
  a0:	77 4a                	ja     ec <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  a2:	83 ec 0c             	sub    $0xc,%esp
  a5:	53                   	push   %ebx
  a6:	e8 15 03 00 00       	call   3c0 <strlen>
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	50                   	push   %eax
  af:	53                   	push   %ebx
  b0:	68 08 0e 00 00       	push   $0xe08
  b5:	e8 96 04 00 00       	call   550 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 fe 02 00 00       	call   3c0 <strlen>
  c2:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  c5:	bb 08 0e 00 00       	mov    $0xe08,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	89 c6                	mov    %eax,%esi
  cc:	e8 ef 02 00 00       	call   3c0 <strlen>
  d1:	ba 0e 00 00 00       	mov    $0xe,%edx
  d6:	83 c4 0c             	add    $0xc,%esp
  d9:	29 f2                	sub    %esi,%edx
  db:	05 08 0e 00 00       	add    $0xe08,%eax
  e0:	52                   	push   %edx
  e1:	6a 20                	push   $0x20
  e3:	50                   	push   %eax
  e4:	e8 07 03 00 00       	call   3f0 <memset>
  return buf;
  e9:	83 c4 10             	add    $0x10,%esp
}
  ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ef:	89 d8                	mov    %ebx,%eax
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret
  f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  fc:	00 
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 ac 04 00 00       	call   5c3 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 8e 01 00 00    	js     2b0 <ls+0x1b0>
  if(fstat(fd, &st) < 0){
 122:	83 ec 08             	sub    $0x8,%esp
 125:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 a7 04 00 00       	call   5db <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 b1 01 00 00    	js     2f0 <ls+0x1f0>
  switch(st.type){
 13f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	74 54                	je     1a0 <ls+0xa0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	75 37                	jne    189 <ls+0x89>
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 158:	83 ec 0c             	sub    $0xc,%esp
 15b:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 161:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 167:	57                   	push   %edi
 168:	e8 f3 fe ff ff       	call   60 <fmtname>
 16d:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 173:	59                   	pop    %ecx
 174:	5f                   	pop    %edi
 175:	52                   	push   %edx
 176:	56                   	push   %esi
 177:	6a 02                	push   $0x2
 179:	50                   	push   %eax
 17a:	68 60 0a 00 00       	push   $0xa60
 17f:	6a 01                	push   $0x1
 181:	e8 aa 05 00 00       	call   730 <printf>
    break;
 186:	83 c4 20             	add    $0x20,%esp
  close(fd);
 189:	83 ec 0c             	sub    $0xc,%esp
 18c:	53                   	push   %ebx
 18d:	e8 19 04 00 00       	call   5ab <close>
 192:	83 c4 10             	add    $0x10,%esp
}
 195:	8d 65 f4             	lea    -0xc(%ebp),%esp
 198:	5b                   	pop    %ebx
 199:	5e                   	pop    %esi
 19a:	5f                   	pop    %edi
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret
 19d:	8d 76 00             	lea    0x0(%esi),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a0:	83 ec 0c             	sub    $0xc,%esp
 1a3:	57                   	push   %edi
 1a4:	e8 17 02 00 00       	call   3c0 <strlen>
 1a9:	83 c4 10             	add    $0x10,%esp
 1ac:	83 c0 10             	add    $0x10,%eax
 1af:	3d 00 02 00 00       	cmp    $0x200,%eax
 1b4:	0f 87 16 01 00 00    	ja     2d0 <ls+0x1d0>
    strcpy(buf, path);
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	57                   	push   %edi
 1be:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1c4:	57                   	push   %edi
 1c5:	e8 66 01 00 00       	call   330 <strcpy>
    p = buf+strlen(buf);
 1ca:	89 3c 24             	mov    %edi,(%esp)
 1cd:	e8 ee 01 00 00       	call   3c0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1d2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1d7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1da:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 1e0:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 1e6:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f0:	83 ec 04             	sub    $0x4,%esp
 1f3:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1f9:	6a 10                	push   $0x10
 1fb:	50                   	push   %eax
 1fc:	53                   	push   %ebx
 1fd:	e8 99 03 00 00       	call   59b <read>
 202:	83 c4 10             	add    $0x10,%esp
 205:	83 f8 10             	cmp    $0x10,%eax
 208:	0f 85 7b ff ff ff    	jne    189 <ls+0x89>
      if(de.inum == 0)
 20e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 215:	00 
 216:	74 d8                	je     1f0 <ls+0xf0>
      memmove(p, de.name, DIRSIZ);
 218:	83 ec 04             	sub    $0x4,%esp
 21b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 221:	6a 0e                	push   $0xe
 223:	50                   	push   %eax
 224:	ff b5 a4 fd ff ff    	push   -0x25c(%ebp)
 22a:	e8 21 03 00 00       	call   550 <memmove>
      p[DIRSIZ] = 0;
 22f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 235:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 239:	58                   	pop    %eax
 23a:	5a                   	pop    %edx
 23b:	56                   	push   %esi
 23c:	57                   	push   %edi
 23d:	e8 7e 02 00 00       	call   4c0 <stat>
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	0f 88 cb 00 00 00    	js     318 <ls+0x218>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24d:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 253:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 259:	83 ec 0c             	sub    $0xc,%esp
 25c:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 263:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 269:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 26f:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 275:	57                   	push   %edi
 276:	e8 e5 fd ff ff       	call   60 <fmtname>
 27b:	5a                   	pop    %edx
 27c:	59                   	pop    %ecx
 27d:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 283:	51                   	push   %ecx
 284:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 28a:	52                   	push   %edx
 28b:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 291:	50                   	push   %eax
 292:	68 60 0a 00 00       	push   $0xa60
 297:	6a 01                	push   $0x1
 299:	e8 92 04 00 00       	call   730 <printf>
 29e:	83 c4 20             	add    $0x20,%esp
 2a1:	e9 4a ff ff ff       	jmp    1f0 <ls+0xf0>
 2a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ad:	00 
 2ae:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	57                   	push   %edi
 2b4:	68 38 0a 00 00       	push   $0xa38
 2b9:	6a 02                	push   $0x2
 2bb:	e8 70 04 00 00       	call   730 <printf>
    return;
 2c0:	83 c4 10             	add    $0x10,%esp
}
 2c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5f                   	pop    %edi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret
 2cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      printf(1, "ls: path too long\n");
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	68 6d 0a 00 00       	push   $0xa6d
 2d8:	6a 01                	push   $0x1
 2da:	e8 51 04 00 00       	call   730 <printf>
      break;
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	e9 a2 fe ff ff       	jmp    189 <ls+0x89>
 2e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2ee:	00 
 2ef:	90                   	nop
    printf(2, "ls: cannot stat %s\n", path);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	57                   	push   %edi
 2f4:	68 4c 0a 00 00       	push   $0xa4c
 2f9:	6a 02                	push   $0x2
 2fb:	e8 30 04 00 00       	call   730 <printf>
    close(fd);
 300:	89 1c 24             	mov    %ebx,(%esp)
 303:	e8 a3 02 00 00       	call   5ab <close>
    return;
 308:	83 c4 10             	add    $0x10,%esp
}
 30b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30e:	5b                   	pop    %ebx
 30f:	5e                   	pop    %esi
 310:	5f                   	pop    %edi
 311:	5d                   	pop    %ebp
 312:	c3                   	ret
 313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 318:	83 ec 04             	sub    $0x4,%esp
 31b:	57                   	push   %edi
 31c:	68 4c 0a 00 00       	push   $0xa4c
 321:	6a 01                	push   $0x1
 323:	e8 08 04 00 00       	call   730 <printf>
        continue;
 328:	83 c4 10             	add    $0x10,%esp
 32b:	e9 c0 fe ff ff       	jmp    1f0 <ls+0xf0>

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 330:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 331:	31 c0                	xor    %eax,%eax
{
 333:	89 e5                	mov    %esp,%ebp
 335:	53                   	push   %ebx
 336:	8b 4d 08             	mov    0x8(%ebp),%ecx
 339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 340:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 344:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 347:	83 c0 01             	add    $0x1,%eax
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 34e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 351:	89 c8                	mov    %ecx,%eax
 353:	c9                   	leave
 354:	c3                   	ret
 355:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35c:	00 
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 36a:	0f b6 02             	movzbl (%edx),%eax
 36d:	84 c0                	test   %al,%al
 36f:	75 17                	jne    388 <strcmp+0x28>
 371:	eb 3a                	jmp    3ad <strcmp+0x4d>
 373:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 378:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 37c:	83 c2 01             	add    $0x1,%edx
 37f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 382:	84 c0                	test   %al,%al
 384:	74 1a                	je     3a0 <strcmp+0x40>
 386:	89 d9                	mov    %ebx,%ecx
 388:	0f b6 19             	movzbl (%ecx),%ebx
 38b:	38 c3                	cmp    %al,%bl
 38d:	74 e9                	je     378 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 38f:	29 d8                	sub    %ebx,%eax
}
 391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 394:	c9                   	leave
 395:	c3                   	ret
 396:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 39d:	00 
 39e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 3a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3a4:	31 c0                	xor    %eax,%eax
 3a6:	29 d8                	sub    %ebx,%eax
}
 3a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3ab:	c9                   	leave
 3ac:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 3ad:	0f b6 19             	movzbl (%ecx),%ebx
 3b0:	31 c0                	xor    %eax,%eax
 3b2:	eb db                	jmp    38f <strcmp+0x2f>
 3b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bb:	00 
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <strlen>:

uint
strlen(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3c6:	80 3a 00             	cmpb   $0x0,(%edx)
 3c9:	74 15                	je     3e0 <strlen+0x20>
 3cb:	31 c0                	xor    %eax,%eax
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	83 c0 01             	add    $0x1,%eax
 3d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3d7:	89 c1                	mov    %eax,%ecx
 3d9:	75 f5                	jne    3d0 <strlen+0x10>
    ;
  return n;
}
 3db:	89 c8                	mov    %ecx,%eax
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret
 3df:	90                   	nop
  for(n = 0; s[n]; n++)
 3e0:	31 c9                	xor    %ecx,%ecx
}
 3e2:	5d                   	pop    %ebp
 3e3:	89 c8                	mov    %ecx,%eax
 3e5:	c3                   	ret
 3e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ed:	00 
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 d7                	mov    %edx,%edi
 3ff:	fc                   	cld
 400:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 402:	8b 7d fc             	mov    -0x4(%ebp),%edi
 405:	89 d0                	mov    %edx,%eax
 407:	c9                   	leave
 408:	c3                   	ret
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000410 <strchr>:

char*
strchr(const char *s, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 41a:	0f b6 10             	movzbl (%eax),%edx
 41d:	84 d2                	test   %dl,%dl
 41f:	75 12                	jne    433 <strchr+0x23>
 421:	eb 1d                	jmp    440 <strchr+0x30>
 423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 428:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 42c:	83 c0 01             	add    $0x1,%eax
 42f:	84 d2                	test   %dl,%dl
 431:	74 0d                	je     440 <strchr+0x30>
    if(*s == c)
 433:	38 d1                	cmp    %dl,%cl
 435:	75 f1                	jne    428 <strchr+0x18>
      return (char*)s;
  return 0;
}
 437:	5d                   	pop    %ebp
 438:	c3                   	ret
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 440:	31 c0                	xor    %eax,%eax
}
 442:	5d                   	pop    %ebp
 443:	c3                   	ret
 444:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 44b:	00 
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <gets>:

char*
gets(char *buf, int max)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 455:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 458:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 459:	31 db                	xor    %ebx,%ebx
 45b:	8d 73 01             	lea    0x1(%ebx),%esi
{
 45e:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 461:	3b 75 0c             	cmp    0xc(%ebp),%esi
 464:	7d 3b                	jge    4a1 <gets+0x51>
 466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 46d:	00 
 46e:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	6a 00                	push   $0x0
 478:	e8 1e 01 00 00       	call   59b <read>
    if(cc < 1)
 47d:	83 c4 10             	add    $0x10,%esp
 480:	85 c0                	test   %eax,%eax
 482:	7e 1d                	jle    4a1 <gets+0x51>
      break;
      
    buf[i++] = c;
 484:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 488:	8b 55 08             	mov    0x8(%ebp),%edx
 48b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 48f:	3c 0a                	cmp    $0xa,%al
 491:	7f 25                	jg     4b8 <gets+0x68>
 493:	3c 08                	cmp    $0x8,%al
 495:	7f 0c                	jg     4a3 <gets+0x53>
{
 497:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 499:	8d 73 01             	lea    0x1(%ebx),%esi
 49c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 49f:	7c cf                	jl     470 <gets+0x20>
 4a1:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ad:	5b                   	pop    %ebx
 4ae:	5e                   	pop    %esi
 4af:	5f                   	pop    %edi
 4b0:	5d                   	pop    %ebp
 4b1:	c3                   	ret
 4b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4b8:	3c 0d                	cmp    $0xd,%al
 4ba:	74 e7                	je     4a3 <gets+0x53>
{
 4bc:	89 f3                	mov    %esi,%ebx
 4be:	eb d9                	jmp    499 <gets+0x49>

000004c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	6a 00                	push   $0x0
 4ca:	ff 75 08             	push   0x8(%ebp)
 4cd:	e8 f1 00 00 00       	call   5c3 <open>
  if(fd < 0)
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	85 c0                	test   %eax,%eax
 4d7:	78 27                	js     500 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	ff 75 0c             	push   0xc(%ebp)
 4df:	89 c3                	mov    %eax,%ebx
 4e1:	50                   	push   %eax
 4e2:	e8 f4 00 00 00       	call   5db <fstat>
  close(fd);
 4e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ea:	89 c6                	mov    %eax,%esi
  close(fd);
 4ec:	e8 ba 00 00 00       	call   5ab <close>
  return r;
 4f1:	83 c4 10             	add    $0x10,%esp
}
 4f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 500:	be ff ff ff ff       	mov    $0xffffffff,%esi
 505:	eb ed                	jmp    4f4 <stat+0x34>
 507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 50e:	00 
 50f:	90                   	nop

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 517:	0f be 02             	movsbl (%edx),%eax
 51a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 51d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 520:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 525:	77 1e                	ja     545 <atoi+0x35>
 527:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 52e:	00 
 52f:	90                   	nop
    n = n*10 + *s++ - '0';
 530:	83 c2 01             	add    $0x1,%edx
 533:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 536:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 53a:	0f be 02             	movsbl (%edx),%eax
 53d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
  return n;
}
 545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 548:	89 c8                	mov    %ecx,%eax
 54a:	c9                   	leave
 54b:	c3                   	ret
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	8b 45 10             	mov    0x10(%ebp),%eax
 557:	8b 55 08             	mov    0x8(%ebp),%edx
 55a:	56                   	push   %esi
 55b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	85 c0                	test   %eax,%eax
 560:	7e 13                	jle    575 <memmove+0x25>
 562:	01 d0                	add    %edx,%eax
  dst = vdst;
 564:	89 d7                	mov    %edx,%edi
 566:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 56d:	00 
 56e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 570:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 571:	39 f8                	cmp    %edi,%eax
 573:	75 fb                	jne    570 <memmove+0x20>
  return vdst;
}
 575:	5e                   	pop    %esi
 576:	89 d0                	mov    %edx,%eax
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret

0000057b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57b:	b8 01 00 00 00       	mov    $0x1,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <exit>:
SYSCALL(exit)
 583:	b8 02 00 00 00       	mov    $0x2,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <wait>:
SYSCALL(wait)
 58b:	b8 03 00 00 00       	mov    $0x3,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <pipe>:
SYSCALL(pipe)
 593:	b8 04 00 00 00       	mov    $0x4,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <read>:
SYSCALL(read)
 59b:	b8 05 00 00 00       	mov    $0x5,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <write>:
SYSCALL(write)
 5a3:	b8 10 00 00 00       	mov    $0x10,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <close>:
SYSCALL(close)
 5ab:	b8 15 00 00 00       	mov    $0x15,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <kill>:
SYSCALL(kill)
 5b3:	b8 06 00 00 00       	mov    $0x6,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <exec>:
SYSCALL(exec)
 5bb:	b8 07 00 00 00       	mov    $0x7,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <open>:
SYSCALL(open)
 5c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <mknod>:
SYSCALL(mknod)
 5cb:	b8 11 00 00 00       	mov    $0x11,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <unlink>:
SYSCALL(unlink)
 5d3:	b8 12 00 00 00       	mov    $0x12,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <fstat>:
SYSCALL(fstat)
 5db:	b8 08 00 00 00       	mov    $0x8,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <link>:
SYSCALL(link)
 5e3:	b8 13 00 00 00       	mov    $0x13,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <mkdir>:
SYSCALL(mkdir)
 5eb:	b8 14 00 00 00       	mov    $0x14,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <chdir>:
SYSCALL(chdir)
 5f3:	b8 09 00 00 00       	mov    $0x9,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <dup>:
SYSCALL(dup)
 5fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <getpid>:
SYSCALL(getpid)
 603:	b8 0b 00 00 00       	mov    $0xb,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <sbrk>:
SYSCALL(sbrk)
 60b:	b8 0c 00 00 00       	mov    $0xc,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret

00000613 <sleep>:
SYSCALL(sleep)
 613:	b8 0d 00 00 00       	mov    $0xd,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret

0000061b <uptime>:
SYSCALL(uptime)
 61b:	b8 0e 00 00 00       	mov    $0xe,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret

00000623 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 623:	b8 17 00 00 00       	mov    $0x17,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret

0000062b <show_process_family>:
SYSCALL(show_process_family)
 62b:	b8 18 00 00 00       	mov    $0x18,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret

00000633 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 633:	b8 16 00 00 00       	mov    $0x16,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret

0000063b <grep_syscall>:
SYSCALL(grep_syscall)
 63b:	b8 19 00 00 00       	mov    $0x19,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret

00000643 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 643:	b8 1a 00 00 00       	mov    $0x1a,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret

0000064b <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 64b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret

00000653 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 653:	b8 1c 00 00 00       	mov    $0x1c,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret

0000065b <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 65b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret

00000663 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 663:	b8 1e 00 00 00       	mov    $0x1e,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret

0000066b <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 66b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret

00000673 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 673:	b8 20 00 00 00       	mov    $0x20,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret

0000067b <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 67b:	b8 21 00 00 00       	mov    $0x21,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret

00000683 <release_plock_sys>:
SYSCALL(release_plock_sys)
 683:	b8 22 00 00 00       	mov    $0x22,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret
 68b:	66 90                	xchg   %ax,%ax
 68d:	66 90                	xchg   %ax,%ax
 68f:	90                   	nop

00000690 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 698:	89 d1                	mov    %edx,%ecx
{
 69a:	83 ec 3c             	sub    $0x3c,%esp
 69d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 6a0:	85 d2                	test   %edx,%edx
 6a2:	0f 89 80 00 00 00    	jns    728 <printint+0x98>
 6a8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6ac:	74 7a                	je     728 <printint+0x98>
    x = -xx;
 6ae:	f7 d9                	neg    %ecx
    neg = 1;
 6b0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 6b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 6b8:	31 f6                	xor    %esi,%esi
 6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6c0:	89 c8                	mov    %ecx,%eax
 6c2:	31 d2                	xor    %edx,%edx
 6c4:	89 f7                	mov    %esi,%edi
 6c6:	f7 f3                	div    %ebx
 6c8:	8d 76 01             	lea    0x1(%esi),%esi
 6cb:	0f b6 92 e4 0a 00 00 	movzbl 0xae4(%edx),%edx
 6d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 6d6:	89 ca                	mov    %ecx,%edx
 6d8:	89 c1                	mov    %eax,%ecx
 6da:	39 da                	cmp    %ebx,%edx
 6dc:	73 e2                	jae    6c0 <printint+0x30>
  if(neg)
 6de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6e1:	85 c0                	test   %eax,%eax
 6e3:	74 07                	je     6ec <printint+0x5c>
    buf[i++] = '-';
 6e5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 6ea:	89 f7                	mov    %esi,%edi
 6ec:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 6ef:	8b 75 c0             	mov    -0x40(%ebp),%esi
 6f2:	01 df                	add    %ebx,%edi
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6f8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	88 45 d7             	mov    %al,-0x29(%ebp)
 701:	8d 45 d7             	lea    -0x29(%ebp),%eax
 704:	6a 01                	push   $0x1
 706:	50                   	push   %eax
 707:	56                   	push   %esi
 708:	e8 96 fe ff ff       	call   5a3 <write>
  while(--i >= 0)
 70d:	89 f8                	mov    %edi,%eax
 70f:	83 c4 10             	add    $0x10,%esp
 712:	83 ef 01             	sub    $0x1,%edi
 715:	39 c3                	cmp    %eax,%ebx
 717:	75 df                	jne    6f8 <printint+0x68>
}
 719:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71c:	5b                   	pop    %ebx
 71d:	5e                   	pop    %esi
 71e:	5f                   	pop    %edi
 71f:	5d                   	pop    %ebp
 720:	c3                   	ret
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 728:	31 c0                	xor    %eax,%eax
 72a:	eb 89                	jmp    6b5 <printint+0x25>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000730 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 739:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 73c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 73f:	0f b6 1e             	movzbl (%esi),%ebx
 742:	83 c6 01             	add    $0x1,%esi
 745:	84 db                	test   %bl,%bl
 747:	74 67                	je     7b0 <printf+0x80>
 749:	8d 4d 10             	lea    0x10(%ebp),%ecx
 74c:	31 d2                	xor    %edx,%edx
 74e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 751:	eb 34                	jmp    787 <printf+0x57>
 753:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 758:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 75b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 760:	83 f8 25             	cmp    $0x25,%eax
 763:	74 18                	je     77d <printf+0x4d>
  write(fd, &c, 1);
 765:	83 ec 04             	sub    $0x4,%esp
 768:	8d 45 e7             	lea    -0x19(%ebp),%eax
 76b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 76e:	6a 01                	push   $0x1
 770:	50                   	push   %eax
 771:	57                   	push   %edi
 772:	e8 2c fe ff ff       	call   5a3 <write>
 777:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 77a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 77d:	0f b6 1e             	movzbl (%esi),%ebx
 780:	83 c6 01             	add    $0x1,%esi
 783:	84 db                	test   %bl,%bl
 785:	74 29                	je     7b0 <printf+0x80>
    c = fmt[i] & 0xff;
 787:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 78a:	85 d2                	test   %edx,%edx
 78c:	74 ca                	je     758 <printf+0x28>
      }
    } else if(state == '%'){
 78e:	83 fa 25             	cmp    $0x25,%edx
 791:	75 ea                	jne    77d <printf+0x4d>
      if(c == 'd'){
 793:	83 f8 25             	cmp    $0x25,%eax
 796:	0f 84 04 01 00 00    	je     8a0 <printf+0x170>
 79c:	83 e8 63             	sub    $0x63,%eax
 79f:	83 f8 15             	cmp    $0x15,%eax
 7a2:	77 1c                	ja     7c0 <printf+0x90>
 7a4:	ff 24 85 8c 0a 00 00 	jmp    *0xa8c(,%eax,4)
 7ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret
 7b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7bf:	00 
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7c6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ca:	6a 01                	push   $0x1
 7cc:	52                   	push   %edx
 7cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 7d0:	57                   	push   %edi
 7d1:	e8 cd fd ff ff       	call   5a3 <write>
 7d6:	83 c4 0c             	add    $0xc,%esp
 7d9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7dc:	6a 01                	push   $0x1
 7de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 7e1:	52                   	push   %edx
 7e2:	57                   	push   %edi
 7e3:	e8 bb fd ff ff       	call   5a3 <write>
        putc(fd, c);
 7e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7eb:	31 d2                	xor    %edx,%edx
 7ed:	eb 8e                	jmp    77d <printf+0x4d>
 7ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 7f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	b9 10 00 00 00       	mov    $0x10,%ecx
 7fb:	8b 13                	mov    (%ebx),%edx
 7fd:	6a 00                	push   $0x0
 7ff:	89 f8                	mov    %edi,%eax
        ap++;
 801:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 804:	e8 87 fe ff ff       	call   690 <printint>
        ap++;
 809:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 80c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 80f:	31 d2                	xor    %edx,%edx
 811:	e9 67 ff ff ff       	jmp    77d <printf+0x4d>
        s = (char*)*ap;
 816:	8b 45 d0             	mov    -0x30(%ebp),%eax
 819:	8b 18                	mov    (%eax),%ebx
        ap++;
 81b:	83 c0 04             	add    $0x4,%eax
 81e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 821:	85 db                	test   %ebx,%ebx
 823:	0f 84 87 00 00 00    	je     8b0 <printf+0x180>
        while(*s != 0){
 829:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 82c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 82e:	84 c0                	test   %al,%al
 830:	0f 84 47 ff ff ff    	je     77d <printf+0x4d>
 836:	8d 55 e7             	lea    -0x19(%ebp),%edx
 839:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 83c:	89 de                	mov    %ebx,%esi
 83e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
 843:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 846:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 849:	6a 01                	push   $0x1
 84b:	53                   	push   %ebx
 84c:	57                   	push   %edi
 84d:	e8 51 fd ff ff       	call   5a3 <write>
        while(*s != 0){
 852:	0f b6 06             	movzbl (%esi),%eax
 855:	83 c4 10             	add    $0x10,%esp
 858:	84 c0                	test   %al,%al
 85a:	75 e4                	jne    840 <printf+0x110>
      state = 0;
 85c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 85f:	31 d2                	xor    %edx,%edx
 861:	e9 17 ff ff ff       	jmp    77d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 866:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 869:	83 ec 0c             	sub    $0xc,%esp
 86c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 871:	8b 13                	mov    (%ebx),%edx
 873:	6a 01                	push   $0x1
 875:	eb 88                	jmp    7ff <printf+0xcf>
        putc(fd, *ap);
 877:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 87a:	83 ec 04             	sub    $0x4,%esp
 87d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 880:	8b 03                	mov    (%ebx),%eax
        ap++;
 882:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 885:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 888:	6a 01                	push   $0x1
 88a:	52                   	push   %edx
 88b:	57                   	push   %edi
 88c:	e8 12 fd ff ff       	call   5a3 <write>
        ap++;
 891:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 894:	83 c4 10             	add    $0x10,%esp
      state = 0;
 897:	31 d2                	xor    %edx,%edx
 899:	e9 df fe ff ff       	jmp    77d <printf+0x4d>
 89e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 8a0:	83 ec 04             	sub    $0x4,%esp
 8a3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 8a6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8a9:	6a 01                	push   $0x1
 8ab:	e9 31 ff ff ff       	jmp    7e1 <printf+0xb1>
 8b0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 8b5:	bb 82 0a 00 00       	mov    $0xa82,%ebx
 8ba:	e9 77 ff ff ff       	jmp    836 <printf+0x106>
 8bf:	90                   	nop

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 18 0e 00 00       	mov    0xe18,%eax
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	39 c8                	cmp    %ecx,%eax
 8dc:	73 32                	jae    910 <free+0x50>
 8de:	39 d1                	cmp    %edx,%ecx
 8e0:	72 04                	jb     8e6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e2:	39 d0                	cmp    %edx,%eax
 8e4:	72 32                	jb     918 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ec:	39 fa                	cmp    %edi,%edx
 8ee:	74 30                	je     920 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8f3:	8b 50 04             	mov    0x4(%eax),%edx
 8f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8f9:	39 f1                	cmp    %esi,%ecx
 8fb:	74 3a                	je     937 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8fd:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8ff:	5b                   	pop    %ebx
  freep = p;
 900:	a3 18 0e 00 00       	mov    %eax,0xe18
}
 905:	5e                   	pop    %esi
 906:	5f                   	pop    %edi
 907:	5d                   	pop    %ebp
 908:	c3                   	ret
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	39 d0                	cmp    %edx,%eax
 912:	72 04                	jb     918 <free+0x58>
 914:	39 d1                	cmp    %edx,%ecx
 916:	72 ce                	jb     8e6 <free+0x26>
{
 918:	89 d0                	mov    %edx,%eax
 91a:	eb bc                	jmp    8d8 <free+0x18>
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 920:	03 72 04             	add    0x4(%edx),%esi
 923:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 12                	mov    (%edx),%edx
 92a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 92d:	8b 50 04             	mov    0x4(%eax),%edx
 930:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 933:	39 f1                	cmp    %esi,%ecx
 935:	75 c6                	jne    8fd <free+0x3d>
    p->s.size += bp->s.size;
 937:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 93a:	a3 18 0e 00 00       	mov    %eax,0xe18
    p->s.size += bp->s.size;
 93f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 942:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 945:	89 08                	mov    %ecx,(%eax)
}
 947:	5b                   	pop    %ebx
 948:	5e                   	pop    %esi
 949:	5f                   	pop    %edi
 94a:	5d                   	pop    %ebp
 94b:	c3                   	ret
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 959:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 95c:	8b 15 18 0e 00 00    	mov    0xe18,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	8d 78 07             	lea    0x7(%eax),%edi
 965:	c1 ef 03             	shr    $0x3,%edi
 968:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 96b:	85 d2                	test   %edx,%edx
 96d:	0f 84 8d 00 00 00    	je     a00 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 973:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 975:	8b 48 04             	mov    0x4(%eax),%ecx
 978:	39 f9                	cmp    %edi,%ecx
 97a:	73 64                	jae    9e0 <malloc+0x90>
  if(nu < 4096)
 97c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 981:	39 df                	cmp    %ebx,%edi
 983:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 986:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 98d:	eb 0a                	jmp    999 <malloc+0x49>
 98f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 992:	8b 48 04             	mov    0x4(%eax),%ecx
 995:	39 f9                	cmp    %edi,%ecx
 997:	73 47                	jae    9e0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 999:	89 c2                	mov    %eax,%edx
 99b:	3b 05 18 0e 00 00    	cmp    0xe18,%eax
 9a1:	75 ed                	jne    990 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 9a3:	83 ec 0c             	sub    $0xc,%esp
 9a6:	56                   	push   %esi
 9a7:	e8 5f fc ff ff       	call   60b <sbrk>
  if(p == (char*)-1)
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	83 f8 ff             	cmp    $0xffffffff,%eax
 9b2:	74 1c                	je     9d0 <malloc+0x80>
  hp->s.size = nu;
 9b4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9b7:	83 ec 0c             	sub    $0xc,%esp
 9ba:	83 c0 08             	add    $0x8,%eax
 9bd:	50                   	push   %eax
 9be:	e8 fd fe ff ff       	call   8c0 <free>
  return freep;
 9c3:	8b 15 18 0e 00 00    	mov    0xe18,%edx
      if((p = morecore(nunits)) == 0)
 9c9:	83 c4 10             	add    $0x10,%esp
 9cc:	85 d2                	test   %edx,%edx
 9ce:	75 c0                	jne    990 <malloc+0x40>
        return 0;
  }
}
 9d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9d3:	31 c0                	xor    %eax,%eax
}
 9d5:	5b                   	pop    %ebx
 9d6:	5e                   	pop    %esi
 9d7:	5f                   	pop    %edi
 9d8:	5d                   	pop    %ebp
 9d9:	c3                   	ret
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9e0:	39 cf                	cmp    %ecx,%edi
 9e2:	74 4c                	je     a30 <malloc+0xe0>
        p->s.size -= nunits;
 9e4:	29 f9                	sub    %edi,%ecx
 9e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ec:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9ef:	89 15 18 0e 00 00    	mov    %edx,0xe18
}
 9f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9f8:	83 c0 08             	add    $0x8,%eax
}
 9fb:	5b                   	pop    %ebx
 9fc:	5e                   	pop    %esi
 9fd:	5f                   	pop    %edi
 9fe:	5d                   	pop    %ebp
 9ff:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 a00:	c7 05 18 0e 00 00 1c 	movl   $0xe1c,0xe18
 a07:	0e 00 00 
    base.s.size = 0;
 a0a:	b8 1c 0e 00 00       	mov    $0xe1c,%eax
    base.s.ptr = freep = prevp = &base;
 a0f:	c7 05 1c 0e 00 00 1c 	movl   $0xe1c,0xe1c
 a16:	0e 00 00 
    base.s.size = 0;
 a19:	c7 05 20 0e 00 00 00 	movl   $0x0,0xe20
 a20:	00 00 00 
    if(p->s.size >= nunits){
 a23:	e9 54 ff ff ff       	jmp    97c <malloc+0x2c>
 a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a2f:	00 
        prevp->s.ptr = p->s.ptr;
 a30:	8b 08                	mov    (%eax),%ecx
 a32:	89 0a                	mov    %ecx,(%edx)
 a34:	eb b9                	jmp    9ef <malloc+0x9f>
