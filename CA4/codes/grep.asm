
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 6f                	jle    90 <main+0x90>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
  27:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  pattern = argv[1];
  30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(argc <= 2){
  33:	75 2d                	jne    62 <main+0x62>
  35:	eb 6c                	jmp    a3 <main+0xa3>
  37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  3e:	00 
  3f:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  40:	83 ec 08             	sub    $0x8,%esp
  for(i = 2; i < argc; i++){
  43:	83 c6 01             	add    $0x1,%esi
  46:	83 c3 04             	add    $0x4,%ebx
    grep(pattern, fd);
  49:	50                   	push   %eax
  4a:	ff 75 e0             	push   -0x20(%ebp)
  4d:	e8 9e 01 00 00       	call   1f0 <grep>
    close(fd);
  52:	89 3c 24             	mov    %edi,(%esp)
  55:	e8 c1 05 00 00       	call   61b <close>
  for(i = 2; i < argc; i++){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  60:	7e 29                	jle    8b <main+0x8b>
    if((fd = open(argv[i], 0)) < 0){
  62:	83 ec 08             	sub    $0x8,%esp
  65:	6a 00                	push   $0x0
  67:	ff 33                	push   (%ebx)
  69:	e8 c5 05 00 00       	call   633 <open>
  6e:	83 c4 10             	add    $0x10,%esp
  71:	89 c7                	mov    %eax,%edi
  73:	85 c0                	test   %eax,%eax
  75:	79 c9                	jns    40 <main+0x40>
      printf(1, "grep: cannot open %s\n", argv[i]);
  77:	50                   	push   %eax
  78:	ff 33                	push   (%ebx)
  7a:	68 c8 0a 00 00       	push   $0xac8
  7f:	6a 01                	push   $0x1
  81:	e8 1a 07 00 00       	call   7a0 <printf>
      exit();
  86:	e8 68 05 00 00       	call   5f3 <exit>
  }
  exit();
  8b:	e8 63 05 00 00       	call   5f3 <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  90:	51                   	push   %ecx
  91:	51                   	push   %ecx
  92:	68 a8 0a 00 00       	push   $0xaa8
  97:	6a 02                	push   $0x2
  99:	e8 02 07 00 00       	call   7a0 <printf>
    exit();
  9e:	e8 50 05 00 00       	call   5f3 <exit>
    grep(pattern, 0);
  a3:	52                   	push   %edx
  a4:	52                   	push   %edx
  a5:	6a 00                	push   $0x0
  a7:	50                   	push   %eax
  a8:	e8 43 01 00 00       	call   1f0 <grep>
    exit();
  ad:	e8 41 05 00 00       	call   5f3 <exit>
  b2:	66 90                	xchg   %ax,%ax
  b4:	66 90                	xchg   %ax,%ax
  b6:	66 90                	xchg   %ax,%ax
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  c6:	83 ec 0c             	sub    $0xc,%esp
  c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '\0')
  cf:	0f b6 0f             	movzbl (%edi),%ecx
  d2:	84 c9                	test   %cl,%cl
  d4:	0f 84 96 00 00 00    	je     170 <matchhere+0xb0>
    return 1;
  if(re[1] == '*')
  da:	0f b6 47 01          	movzbl 0x1(%edi),%eax
  de:	3c 2a                	cmp    $0x2a,%al
  e0:	74 2d                	je     10f <matchhere+0x4f>
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  e8:	0f b6 33             	movzbl (%ebx),%esi
  if(re[0] == '$' && re[1] == '\0')
  eb:	80 f9 24             	cmp    $0x24,%cl
  ee:	74 50                	je     140 <matchhere+0x80>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  f0:	89 f2                	mov    %esi,%edx
  f2:	84 d2                	test   %dl,%dl
  f4:	74 6e                	je     164 <matchhere+0xa4>
  f6:	80 f9 2e             	cmp    $0x2e,%cl
  f9:	75 65                	jne    160 <matchhere+0xa0>
    return matchhere(re+1, text+1);
  fb:	83 c3 01             	add    $0x1,%ebx
  fe:	83 c7 01             	add    $0x1,%edi
  if(re[0] == '\0')
 101:	84 c0                	test   %al,%al
 103:	74 6b                	je     170 <matchhere+0xb0>
{
 105:	89 c1                	mov    %eax,%ecx
  if(re[1] == '*')
 107:	0f b6 47 01          	movzbl 0x1(%edi),%eax
 10b:	3c 2a                	cmp    $0x2a,%al
 10d:	75 d9                	jne    e8 <matchhere+0x28>
    return matchstar(re[0], re+2, text);
 10f:	8d 77 02             	lea    0x2(%edi),%esi
 112:	0f be f9             	movsbl %cl,%edi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
 115:	8d 76 00             	lea    0x0(%esi),%esi
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 118:	83 ec 08             	sub    $0x8,%esp
 11b:	53                   	push   %ebx
 11c:	56                   	push   %esi
 11d:	e8 9e ff ff ff       	call   c0 <matchhere>
 122:	83 c4 10             	add    $0x10,%esp
 125:	85 c0                	test   %eax,%eax
 127:	75 47                	jne    170 <matchhere+0xb0>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
 129:	0f be 13             	movsbl (%ebx),%edx
 12c:	84 d2                	test   %dl,%dl
 12e:	74 45                	je     175 <matchhere+0xb5>
 130:	83 c3 01             	add    $0x1,%ebx
 133:	39 fa                	cmp    %edi,%edx
 135:	74 e1                	je     118 <matchhere+0x58>
 137:	83 ff 2e             	cmp    $0x2e,%edi
 13a:	74 dc                	je     118 <matchhere+0x58>
 13c:	eb 37                	jmp    175 <matchhere+0xb5>
 13e:	66 90                	xchg   %ax,%ax
  if(re[0] == '$' && re[1] == '\0')
 140:	84 c0                	test   %al,%al
 142:	74 39                	je     17d <matchhere+0xbd>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 144:	89 f2                	mov    %esi,%edx
 146:	84 d2                	test   %dl,%dl
 148:	74 1a                	je     164 <matchhere+0xa4>
 14a:	80 fa 24             	cmp    $0x24,%dl
 14d:	75 15                	jne    164 <matchhere+0xa4>
    return matchhere(re+1, text+1);
 14f:	83 c3 01             	add    $0x1,%ebx
 152:	83 c7 01             	add    $0x1,%edi
{
 155:	89 c1                	mov    %eax,%ecx
 157:	eb ae                	jmp    107 <matchhere+0x47>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 160:	38 ca                	cmp    %cl,%dl
 162:	74 97                	je     fb <matchhere+0x3b>
}
 164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
 167:	31 c0                	xor    %eax,%eax
}
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5f                   	pop    %edi
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret
 16e:	66 90                	xchg   %ax,%ax
    return 1;
 170:	b8 01 00 00 00       	mov    $0x1,%eax
}
 175:	8d 65 f4             	lea    -0xc(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5f                   	pop    %edi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret
    return *text == '\0';
 17d:	89 f0                	mov    %esi,%eax
 17f:	84 c0                	test   %al,%al
 181:	0f 94 c0             	sete   %al
 184:	0f b6 c0             	movzbl %al,%eax
 187:	eb ec                	jmp    175 <matchhere+0xb5>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <match>:
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	8b 5d 08             	mov    0x8(%ebp),%ebx
 198:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 19b:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 19e:	75 11                	jne    1b1 <match+0x21>
 1a0:	eb 2e                	jmp    1d0 <match+0x40>
 1a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
 1a8:	83 c6 01             	add    $0x1,%esi
 1ab:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 1af:	74 16                	je     1c7 <match+0x37>
    if(matchhere(re, text))
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	e8 05 ff ff ff       	call   c0 <matchhere>
 1bb:	83 c4 10             	add    $0x10,%esp
 1be:	85 c0                	test   %eax,%eax
 1c0:	74 e6                	je     1a8 <match+0x18>
      return 1;
 1c2:	b8 01 00 00 00       	mov    $0x1,%eax
}
 1c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ca:	5b                   	pop    %ebx
 1cb:	5e                   	pop    %esi
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret
 1ce:	66 90                	xchg   %ax,%ax
    return matchhere(re+1, text);
 1d0:	83 c3 01             	add    $0x1,%ebx
 1d3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 1d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1d9:	5b                   	pop    %ebx
 1da:	5e                   	pop    %esi
 1db:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 1dc:	e9 df fe ff ff       	jmp    c0 <matchhere>
 1e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1e8:	00 
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <grep>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
  m = 0;
 1f4:	31 ff                	xor    %edi,%edi
{
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	83 ec 1c             	sub    $0x1c,%esp
 1fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 1fe:	89 7d e0             	mov    %edi,-0x20(%ebp)
    return matchhere(re+1, text);
 201:	8d 43 01             	lea    0x1(%ebx),%eax
 204:	89 45 dc             	mov    %eax,-0x24(%ebp)
 207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 20e:	00 
 20f:	90                   	nop
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 210:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 213:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 218:	83 ec 04             	sub    $0x4,%esp
 21b:	29 c8                	sub    %ecx,%eax
 21d:	50                   	push   %eax
 21e:	8d 81 e0 0e 00 00    	lea    0xee0(%ecx),%eax
 224:	50                   	push   %eax
 225:	ff 75 0c             	push   0xc(%ebp)
 228:	e8 de 03 00 00       	call   60b <read>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	85 c0                	test   %eax,%eax
 232:	0f 8e fd 00 00 00    	jle    335 <grep+0x145>
    m += n;
 238:	01 45 e0             	add    %eax,-0x20(%ebp)
 23b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    buf[m] = '\0';
 23e:	bf e0 0e 00 00       	mov    $0xee0,%edi
 243:	89 de                	mov    %ebx,%esi
 245:	c6 81 e0 0e 00 00 00 	movb   $0x0,0xee0(%ecx)
    while((q = strchr(p, '\n')) != 0){
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 250:	83 ec 08             	sub    $0x8,%esp
 253:	6a 0a                	push   $0xa
 255:	57                   	push   %edi
 256:	e8 25 02 00 00       	call   480 <strchr>
 25b:	83 c4 10             	add    $0x10,%esp
 25e:	89 c2                	mov    %eax,%edx
 260:	85 c0                	test   %eax,%eax
 262:	0f 84 88 00 00 00    	je     2f0 <grep+0x100>
      *q = 0;
 268:	c6 02 00             	movb   $0x0,(%edx)
  if(re[0] == '^')
 26b:	80 3e 5e             	cmpb   $0x5e,(%esi)
 26e:	74 58                	je     2c8 <grep+0xd8>
 270:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 273:	89 d3                	mov    %edx,%ebx
 275:	eb 12                	jmp    289 <grep+0x99>
 277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27e:	00 
 27f:	90                   	nop
  }while(*text++ != '\0');
 280:	83 c7 01             	add    $0x1,%edi
 283:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
 287:	74 37                	je     2c0 <grep+0xd0>
    if(matchhere(re, text))
 289:	83 ec 08             	sub    $0x8,%esp
 28c:	57                   	push   %edi
 28d:	56                   	push   %esi
 28e:	e8 2d fe ff ff       	call   c0 <matchhere>
 293:	83 c4 10             	add    $0x10,%esp
 296:	85 c0                	test   %eax,%eax
 298:	74 e6                	je     280 <grep+0x90>
        write(1, p, q+1 - p);
 29a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 29d:	89 da                	mov    %ebx,%edx
 29f:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a2:	89 d8                	mov    %ebx,%eax
 2a4:	83 ec 04             	sub    $0x4,%esp
        *q = '\n';
 2a7:	c6 02 0a             	movb   $0xa,(%edx)
        write(1, p, q+1 - p);
 2aa:	29 f8                	sub    %edi,%eax
 2ac:	50                   	push   %eax
 2ad:	57                   	push   %edi
 2ae:	89 df                	mov    %ebx,%edi
 2b0:	6a 01                	push   $0x1
 2b2:	e8 5c 03 00 00       	call   613 <write>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	eb 94                	jmp    250 <grep+0x60>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c0:	8d 7b 01             	lea    0x1(%ebx),%edi
      p = q+1;
 2c3:	eb 8b                	jmp    250 <grep+0x60>
 2c5:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 2ce:	57                   	push   %edi
 2cf:	ff 75 dc             	push   -0x24(%ebp)
 2d2:	e8 e9 fd ff ff       	call   c0 <matchhere>
        write(1, p, q+1 - p);
 2d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return matchhere(re+1, text);
 2da:	83 c4 10             	add    $0x10,%esp
        write(1, p, q+1 - p);
 2dd:	8d 5a 01             	lea    0x1(%edx),%ebx
      if(match(pattern, p)){
 2e0:	85 c0                	test   %eax,%eax
 2e2:	75 be                	jne    2a2 <grep+0xb2>
        write(1, p, q+1 - p);
 2e4:	89 df                	mov    %ebx,%edi
 2e6:	e9 65 ff ff ff       	jmp    250 <grep+0x60>
 2eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p == buf)
 2f0:	89 f3                	mov    %esi,%ebx
 2f2:	81 ff e0 0e 00 00    	cmp    $0xee0,%edi
 2f8:	74 2f                	je     329 <grep+0x139>
    if(m > 0){
 2fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2fd:	85 c0                	test   %eax,%eax
 2ff:	0f 8e 0b ff ff ff    	jle    210 <grep+0x20>
      m -= p - buf;
 305:	89 f8                	mov    %edi,%eax
      memmove(buf, p, m);
 307:	83 ec 04             	sub    $0x4,%esp
      m -= p - buf;
 30a:	2d e0 0e 00 00       	sub    $0xee0,%eax
 30f:	29 45 e0             	sub    %eax,-0x20(%ebp)
 312:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      memmove(buf, p, m);
 315:	51                   	push   %ecx
 316:	57                   	push   %edi
 317:	68 e0 0e 00 00       	push   $0xee0
 31c:	e8 9f 02 00 00       	call   5c0 <memmove>
 321:	83 c4 10             	add    $0x10,%esp
 324:	e9 e7 fe ff ff       	jmp    210 <grep+0x20>
      m = 0;
 329:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 330:	e9 db fe ff ff       	jmp    210 <grep+0x20>
}
 335:	8d 65 f4             	lea    -0xc(%ebp),%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <matchstar>:
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
 346:	83 ec 0c             	sub    $0xc,%esp
 349:	8b 5d 08             	mov    0x8(%ebp),%ebx
 34c:	8b 75 0c             	mov    0xc(%ebp),%esi
 34f:	8b 7d 10             	mov    0x10(%ebp),%edi
 352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(matchhere(re, text))
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	e8 5e fd ff ff       	call   c0 <matchhere>
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	75 1f                	jne    388 <matchstar+0x48>
  }while(*text!='\0' && (*text++==c || c=='.'));
 369:	0f be 17             	movsbl (%edi),%edx
 36c:	84 d2                	test   %dl,%dl
 36e:	74 0c                	je     37c <matchstar+0x3c>
 370:	83 c7 01             	add    $0x1,%edi
 373:	83 fb 2e             	cmp    $0x2e,%ebx
 376:	74 e0                	je     358 <matchstar+0x18>
 378:	39 da                	cmp    %ebx,%edx
 37a:	74 dc                	je     358 <matchstar+0x18>
}
 37c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37f:	5b                   	pop    %ebx
 380:	5e                   	pop    %esi
 381:	5f                   	pop    %edi
 382:	5d                   	pop    %ebp
 383:	c3                   	ret
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 388:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 1;
 38b:	b8 01 00 00 00       	mov    $0x1,%eax
}
 390:	5b                   	pop    %ebx
 391:	5e                   	pop    %esi
 392:	5f                   	pop    %edi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret
 395:	66 90                	xchg   %ax,%ax
 397:	66 90                	xchg   %ax,%ax
 399:	66 90                	xchg   %ax,%ax
 39b:	66 90                	xchg   %ax,%ax
 39d:	66 90                	xchg   %ax,%ax
 39f:	90                   	nop

000003a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 3a0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3a1:	31 c0                	xor    %eax,%eax
{
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	53                   	push   %ebx
 3a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 3b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3b7:	83 c0 01             	add    $0x1,%eax
 3ba:	84 d2                	test   %dl,%dl
 3bc:	75 f2                	jne    3b0 <strcpy+0x10>
    ;
  return os;
}
 3be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c1:	89 c8                	mov    %ecx,%eax
 3c3:	c9                   	leave
 3c4:	c3                   	ret
 3c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cc:	00 
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	53                   	push   %ebx
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
 3d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3da:	0f b6 02             	movzbl (%edx),%eax
 3dd:	84 c0                	test   %al,%al
 3df:	75 17                	jne    3f8 <strcmp+0x28>
 3e1:	eb 3a                	jmp    41d <strcmp+0x4d>
 3e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 3ec:	83 c2 01             	add    $0x1,%edx
 3ef:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 3f2:	84 c0                	test   %al,%al
 3f4:	74 1a                	je     410 <strcmp+0x40>
 3f6:	89 d9                	mov    %ebx,%ecx
 3f8:	0f b6 19             	movzbl (%ecx),%ebx
 3fb:	38 c3                	cmp    %al,%bl
 3fd:	74 e9                	je     3e8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 3ff:	29 d8                	sub    %ebx,%eax
}
 401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 404:	c9                   	leave
 405:	c3                   	ret
 406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40d:	00 
 40e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 410:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 414:	31 c0                	xor    %eax,%eax
 416:	29 d8                	sub    %ebx,%eax
}
 418:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 41b:	c9                   	leave
 41c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 41d:	0f b6 19             	movzbl (%ecx),%ebx
 420:	31 c0                	xor    %eax,%eax
 422:	eb db                	jmp    3ff <strcmp+0x2f>
 424:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42b:	00 
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <strlen>:

uint
strlen(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 436:	80 3a 00             	cmpb   $0x0,(%edx)
 439:	74 15                	je     450 <strlen+0x20>
 43b:	31 c0                	xor    %eax,%eax
 43d:	8d 76 00             	lea    0x0(%esi),%esi
 440:	83 c0 01             	add    $0x1,%eax
 443:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 447:	89 c1                	mov    %eax,%ecx
 449:	75 f5                	jne    440 <strlen+0x10>
    ;
  return n;
}
 44b:	89 c8                	mov    %ecx,%eax
 44d:	5d                   	pop    %ebp
 44e:	c3                   	ret
 44f:	90                   	nop
  for(n = 0; s[n]; n++)
 450:	31 c9                	xor    %ecx,%ecx
}
 452:	5d                   	pop    %ebp
 453:	89 c8                	mov    %ecx,%eax
 455:	c3                   	ret
 456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 45d:	00 
 45e:	66 90                	xchg   %ax,%ax

00000460 <memset>:

void*
memset(void *dst, int c, uint n)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 467:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 d7                	mov    %edx,%edi
 46f:	fc                   	cld
 470:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 472:	8b 7d fc             	mov    -0x4(%ebp),%edi
 475:	89 d0                	mov    %edx,%eax
 477:	c9                   	leave
 478:	c3                   	ret
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000480 <strchr>:

char*
strchr(const char *s, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 48a:	0f b6 10             	movzbl (%eax),%edx
 48d:	84 d2                	test   %dl,%dl
 48f:	75 12                	jne    4a3 <strchr+0x23>
 491:	eb 1d                	jmp    4b0 <strchr+0x30>
 493:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 498:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 49c:	83 c0 01             	add    $0x1,%eax
 49f:	84 d2                	test   %dl,%dl
 4a1:	74 0d                	je     4b0 <strchr+0x30>
    if(*s == c)
 4a3:	38 d1                	cmp    %dl,%cl
 4a5:	75 f1                	jne    498 <strchr+0x18>
      return (char*)s;
  return 0;
}
 4a7:	5d                   	pop    %ebp
 4a8:	c3                   	ret
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4b0:	31 c0                	xor    %eax,%eax
}
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret
 4b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4bb:	00 
 4bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004c0 <gets>:

char*
gets(char *buf, int max)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 4c5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 4c8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 4c9:	31 db                	xor    %ebx,%ebx
 4cb:	8d 73 01             	lea    0x1(%ebx),%esi
{
 4ce:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 4d1:	3b 75 0c             	cmp    0xc(%ebp),%esi
 4d4:	7d 3b                	jge    511 <gets+0x51>
 4d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4dd:	00 
 4de:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	6a 01                	push   $0x1
 4e5:	57                   	push   %edi
 4e6:	6a 00                	push   $0x0
 4e8:	e8 1e 01 00 00       	call   60b <read>
    if(cc < 1)
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	85 c0                	test   %eax,%eax
 4f2:	7e 1d                	jle    511 <gets+0x51>
      break;
      
    buf[i++] = c;
 4f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4f8:	8b 55 08             	mov    0x8(%ebp),%edx
 4fb:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
 4ff:	3c 0a                	cmp    $0xa,%al
 501:	7f 25                	jg     528 <gets+0x68>
 503:	3c 08                	cmp    $0x8,%al
 505:	7f 0c                	jg     513 <gets+0x53>
{
 507:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
 509:	8d 73 01             	lea    0x1(%ebx),%esi
 50c:	3b 75 0c             	cmp    0xc(%ebp),%esi
 50f:	7c cf                	jl     4e0 <gets+0x20>
 511:	89 de                	mov    %ebx,%esi
      break;
  }

  buf[i] = '\0';
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 51a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 51d:	5b                   	pop    %ebx
 51e:	5e                   	pop    %esi
 51f:	5f                   	pop    %edi
 520:	5d                   	pop    %ebp
 521:	c3                   	ret
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 528:	3c 0d                	cmp    $0xd,%al
 52a:	74 e7                	je     513 <gets+0x53>
{
 52c:	89 f3                	mov    %esi,%ebx
 52e:	eb d9                	jmp    509 <gets+0x49>

00000530 <stat>:

int
stat(const char *n, struct stat *st)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 535:	83 ec 08             	sub    $0x8,%esp
 538:	6a 00                	push   $0x0
 53a:	ff 75 08             	push   0x8(%ebp)
 53d:	e8 f1 00 00 00       	call   633 <open>
  if(fd < 0)
 542:	83 c4 10             	add    $0x10,%esp
 545:	85 c0                	test   %eax,%eax
 547:	78 27                	js     570 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 549:	83 ec 08             	sub    $0x8,%esp
 54c:	ff 75 0c             	push   0xc(%ebp)
 54f:	89 c3                	mov    %eax,%ebx
 551:	50                   	push   %eax
 552:	e8 f4 00 00 00       	call   64b <fstat>
  close(fd);
 557:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 55a:	89 c6                	mov    %eax,%esi
  close(fd);
 55c:	e8 ba 00 00 00       	call   61b <close>
  return r;
 561:	83 c4 10             	add    $0x10,%esp
}
 564:	8d 65 f8             	lea    -0x8(%ebp),%esp
 567:	89 f0                	mov    %esi,%eax
 569:	5b                   	pop    %ebx
 56a:	5e                   	pop    %esi
 56b:	5d                   	pop    %ebp
 56c:	c3                   	ret
 56d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 570:	be ff ff ff ff       	mov    $0xffffffff,%esi
 575:	eb ed                	jmp    564 <stat+0x34>
 577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 57e:	00 
 57f:	90                   	nop

00000580 <atoi>:

int
atoi(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	53                   	push   %ebx
 584:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 587:	0f be 02             	movsbl (%edx),%eax
 58a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 58d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 590:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 595:	77 1e                	ja     5b5 <atoi+0x35>
 597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 59e:	00 
 59f:	90                   	nop
    n = n*10 + *s++ - '0';
 5a0:	83 c2 01             	add    $0x1,%edx
 5a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 5a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 5aa:	0f be 02             	movsbl (%edx),%eax
 5ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5b0:	80 fb 09             	cmp    $0x9,%bl
 5b3:	76 eb                	jbe    5a0 <atoi+0x20>
  return n;
}
 5b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b8:	89 c8                	mov    %ecx,%eax
 5ba:	c9                   	leave
 5bb:	c3                   	ret
 5bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	8b 45 10             	mov    0x10(%ebp),%eax
 5c7:	8b 55 08             	mov    0x8(%ebp),%edx
 5ca:	56                   	push   %esi
 5cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ce:	85 c0                	test   %eax,%eax
 5d0:	7e 13                	jle    5e5 <memmove+0x25>
 5d2:	01 d0                	add    %edx,%eax
  dst = vdst;
 5d4:	89 d7                	mov    %edx,%edi
 5d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5dd:	00 
 5de:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 5e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5e1:	39 f8                	cmp    %edi,%eax
 5e3:	75 fb                	jne    5e0 <memmove+0x20>
  return vdst;
}
 5e5:	5e                   	pop    %esi
 5e6:	89 d0                	mov    %edx,%eax
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret

000005eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5eb:	b8 01 00 00 00       	mov    $0x1,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <exit>:
SYSCALL(exit)
 5f3:	b8 02 00 00 00       	mov    $0x2,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <wait>:
SYSCALL(wait)
 5fb:	b8 03 00 00 00       	mov    $0x3,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <pipe>:
SYSCALL(pipe)
 603:	b8 04 00 00 00       	mov    $0x4,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret

0000060b <read>:
SYSCALL(read)
 60b:	b8 05 00 00 00       	mov    $0x5,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret

00000613 <write>:
SYSCALL(write)
 613:	b8 10 00 00 00       	mov    $0x10,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret

0000061b <close>:
SYSCALL(close)
 61b:	b8 15 00 00 00       	mov    $0x15,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret

00000623 <kill>:
SYSCALL(kill)
 623:	b8 06 00 00 00       	mov    $0x6,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret

0000062b <exec>:
SYSCALL(exec)
 62b:	b8 07 00 00 00       	mov    $0x7,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret

00000633 <open>:
SYSCALL(open)
 633:	b8 0f 00 00 00       	mov    $0xf,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret

0000063b <mknod>:
SYSCALL(mknod)
 63b:	b8 11 00 00 00       	mov    $0x11,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret

00000643 <unlink>:
SYSCALL(unlink)
 643:	b8 12 00 00 00       	mov    $0x12,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret

0000064b <fstat>:
SYSCALL(fstat)
 64b:	b8 08 00 00 00       	mov    $0x8,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret

00000653 <link>:
SYSCALL(link)
 653:	b8 13 00 00 00       	mov    $0x13,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret

0000065b <mkdir>:
SYSCALL(mkdir)
 65b:	b8 14 00 00 00       	mov    $0x14,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret

00000663 <chdir>:
SYSCALL(chdir)
 663:	b8 09 00 00 00       	mov    $0x9,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret

0000066b <dup>:
SYSCALL(dup)
 66b:	b8 0a 00 00 00       	mov    $0xa,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret

00000673 <getpid>:
SYSCALL(getpid)
 673:	b8 0b 00 00 00       	mov    $0xb,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret

0000067b <sbrk>:
SYSCALL(sbrk)
 67b:	b8 0c 00 00 00       	mov    $0xc,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret

00000683 <sleep>:
SYSCALL(sleep)
 683:	b8 0d 00 00 00       	mov    $0xd,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret

0000068b <uptime>:
SYSCALL(uptime)
 68b:	b8 0e 00 00 00       	mov    $0xe,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret

00000693 <make_duplicate_file>:
SYSCALL(make_duplicate_file)
 693:	b8 17 00 00 00       	mov    $0x17,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret

0000069b <show_process_family>:
SYSCALL(show_process_family)
 69b:	b8 18 00 00 00       	mov    $0x18,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret

000006a3 <simple_arithmetic_syscall>:
SYSCALL(simple_arithmetic_syscall)
 6a3:	b8 16 00 00 00       	mov    $0x16,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret

000006ab <grep_syscall>:
SYSCALL(grep_syscall)
 6ab:	b8 19 00 00 00       	mov    $0x19,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret

000006b3 <set_priority_syscall>:
SYSCALL(set_priority_syscall)
 6b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret

000006bb <sleeplock_hold>:
SYSCALL(sleeplock_hold)
 6bb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret

000006c3 <sleeplock_drop>:
SYSCALL(sleeplock_drop)
 6c3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret

000006cb <rwlock_rlock>:
SYSCALL(rwlock_rlock)
 6cb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret

000006d3 <rwlock_runlock>:
SYSCALL(rwlock_runlock)
 6d3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret

000006db <rwlock_wlock>:
SYSCALL(rwlock_wlock)
 6db:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret

000006e3 <rwlock_wunlock>:
SYSCALL(rwlock_wunlock)
 6e3:	b8 20 00 00 00       	mov    $0x20,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret

000006eb <acquire_plock_sys>:
SYSCALL(acquire_plock_sys)
 6eb:	b8 21 00 00 00       	mov    $0x21,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret

000006f3 <release_plock_sys>:
SYSCALL(release_plock_sys)
 6f3:	b8 22 00 00 00       	mov    $0x22,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret
 6fb:	66 90                	xchg   %ax,%ax
 6fd:	66 90                	xchg   %ax,%ax
 6ff:	90                   	nop

00000700 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 708:	89 d1                	mov    %edx,%ecx
{
 70a:	83 ec 3c             	sub    $0x3c,%esp
 70d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 710:	85 d2                	test   %edx,%edx
 712:	0f 89 80 00 00 00    	jns    798 <printint+0x98>
 718:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 71c:	74 7a                	je     798 <printint+0x98>
    x = -xx;
 71e:	f7 d9                	neg    %ecx
    neg = 1;
 720:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 725:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 728:	31 f6                	xor    %esi,%esi
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 730:	89 c8                	mov    %ecx,%eax
 732:	31 d2                	xor    %edx,%edx
 734:	89 f7                	mov    %esi,%edi
 736:	f7 f3                	div    %ebx
 738:	8d 76 01             	lea    0x1(%esi),%esi
 73b:	0f b6 92 40 0b 00 00 	movzbl 0xb40(%edx),%edx
 742:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 746:	89 ca                	mov    %ecx,%edx
 748:	89 c1                	mov    %eax,%ecx
 74a:	39 da                	cmp    %ebx,%edx
 74c:	73 e2                	jae    730 <printint+0x30>
  if(neg)
 74e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 751:	85 c0                	test   %eax,%eax
 753:	74 07                	je     75c <printint+0x5c>
    buf[i++] = '-';
 755:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 75a:	89 f7                	mov    %esi,%edi
 75c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 75f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 762:	01 df                	add    %ebx,%edi
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 768:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 76b:	83 ec 04             	sub    $0x4,%esp
 76e:	88 45 d7             	mov    %al,-0x29(%ebp)
 771:	8d 45 d7             	lea    -0x29(%ebp),%eax
 774:	6a 01                	push   $0x1
 776:	50                   	push   %eax
 777:	56                   	push   %esi
 778:	e8 96 fe ff ff       	call   613 <write>
  while(--i >= 0)
 77d:	89 f8                	mov    %edi,%eax
 77f:	83 c4 10             	add    $0x10,%esp
 782:	83 ef 01             	sub    $0x1,%edi
 785:	39 c3                	cmp    %eax,%ebx
 787:	75 df                	jne    768 <printint+0x68>
}
 789:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78c:	5b                   	pop    %ebx
 78d:	5e                   	pop    %esi
 78e:	5f                   	pop    %edi
 78f:	5d                   	pop    %ebp
 790:	c3                   	ret
 791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 798:	31 c0                	xor    %eax,%eax
 79a:	eb 89                	jmp    725 <printint+0x25>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	57                   	push   %edi
 7a4:	56                   	push   %esi
 7a5:	53                   	push   %ebx
 7a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 7ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 7af:	0f b6 1e             	movzbl (%esi),%ebx
 7b2:	83 c6 01             	add    $0x1,%esi
 7b5:	84 db                	test   %bl,%bl
 7b7:	74 67                	je     820 <printf+0x80>
 7b9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 7bc:	31 d2                	xor    %edx,%edx
 7be:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 7c1:	eb 34                	jmp    7f7 <printf+0x57>
 7c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 7c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7cb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 7d0:	83 f8 25             	cmp    $0x25,%eax
 7d3:	74 18                	je     7ed <printf+0x4d>
  write(fd, &c, 1);
 7d5:	83 ec 04             	sub    $0x4,%esp
 7d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7db:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7de:	6a 01                	push   $0x1
 7e0:	50                   	push   %eax
 7e1:	57                   	push   %edi
 7e2:	e8 2c fe ff ff       	call   613 <write>
 7e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7ed:	0f b6 1e             	movzbl (%esi),%ebx
 7f0:	83 c6 01             	add    $0x1,%esi
 7f3:	84 db                	test   %bl,%bl
 7f5:	74 29                	je     820 <printf+0x80>
    c = fmt[i] & 0xff;
 7f7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7fa:	85 d2                	test   %edx,%edx
 7fc:	74 ca                	je     7c8 <printf+0x28>
      }
    } else if(state == '%'){
 7fe:	83 fa 25             	cmp    $0x25,%edx
 801:	75 ea                	jne    7ed <printf+0x4d>
      if(c == 'd'){
 803:	83 f8 25             	cmp    $0x25,%eax
 806:	0f 84 04 01 00 00    	je     910 <printf+0x170>
 80c:	83 e8 63             	sub    $0x63,%eax
 80f:	83 f8 15             	cmp    $0x15,%eax
 812:	77 1c                	ja     830 <printf+0x90>
 814:	ff 24 85 e8 0a 00 00 	jmp    *0xae8(,%eax,4)
 81b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 820:	8d 65 f4             	lea    -0xc(%ebp),%esp
 823:	5b                   	pop    %ebx
 824:	5e                   	pop    %esi
 825:	5f                   	pop    %edi
 826:	5d                   	pop    %ebp
 827:	c3                   	ret
 828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 82f:	00 
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
 833:	8d 55 e7             	lea    -0x19(%ebp),%edx
 836:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 83a:	6a 01                	push   $0x1
 83c:	52                   	push   %edx
 83d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 840:	57                   	push   %edi
 841:	e8 cd fd ff ff       	call   613 <write>
 846:	83 c4 0c             	add    $0xc,%esp
 849:	88 5d e7             	mov    %bl,-0x19(%ebp)
 84c:	6a 01                	push   $0x1
 84e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 851:	52                   	push   %edx
 852:	57                   	push   %edi
 853:	e8 bb fd ff ff       	call   613 <write>
        putc(fd, c);
 858:	83 c4 10             	add    $0x10,%esp
      state = 0;
 85b:	31 d2                	xor    %edx,%edx
 85d:	eb 8e                	jmp    7ed <printf+0x4d>
 85f:	90                   	nop
        printint(fd, *ap, 16, 0);
 860:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	b9 10 00 00 00       	mov    $0x10,%ecx
 86b:	8b 13                	mov    (%ebx),%edx
 86d:	6a 00                	push   $0x0
 86f:	89 f8                	mov    %edi,%eax
        ap++;
 871:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 874:	e8 87 fe ff ff       	call   700 <printint>
        ap++;
 879:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 87c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 87f:	31 d2                	xor    %edx,%edx
 881:	e9 67 ff ff ff       	jmp    7ed <printf+0x4d>
        s = (char*)*ap;
 886:	8b 45 d0             	mov    -0x30(%ebp),%eax
 889:	8b 18                	mov    (%eax),%ebx
        ap++;
 88b:	83 c0 04             	add    $0x4,%eax
 88e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 891:	85 db                	test   %ebx,%ebx
 893:	0f 84 87 00 00 00    	je     920 <printf+0x180>
        while(*s != 0){
 899:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 89c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 89e:	84 c0                	test   %al,%al
 8a0:	0f 84 47 ff ff ff    	je     7ed <printf+0x4d>
 8a6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8a9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8ac:	89 de                	mov    %ebx,%esi
 8ae:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 8b0:	83 ec 04             	sub    $0x4,%esp
 8b3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 8b6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 8b9:	6a 01                	push   $0x1
 8bb:	53                   	push   %ebx
 8bc:	57                   	push   %edi
 8bd:	e8 51 fd ff ff       	call   613 <write>
        while(*s != 0){
 8c2:	0f b6 06             	movzbl (%esi),%eax
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	84 c0                	test   %al,%al
 8ca:	75 e4                	jne    8b0 <printf+0x110>
      state = 0;
 8cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 8cf:	31 d2                	xor    %edx,%edx
 8d1:	e9 17 ff ff ff       	jmp    7ed <printf+0x4d>
        printint(fd, *ap, 10, 1);
 8d6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 8d9:	83 ec 0c             	sub    $0xc,%esp
 8dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8e1:	8b 13                	mov    (%ebx),%edx
 8e3:	6a 01                	push   $0x1
 8e5:	eb 88                	jmp    86f <printf+0xcf>
        putc(fd, *ap);
 8e7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 8ea:	83 ec 04             	sub    $0x4,%esp
 8ed:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 8f0:	8b 03                	mov    (%ebx),%eax
        ap++;
 8f2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 8f5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8f8:	6a 01                	push   $0x1
 8fa:	52                   	push   %edx
 8fb:	57                   	push   %edi
 8fc:	e8 12 fd ff ff       	call   613 <write>
        ap++;
 901:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 904:	83 c4 10             	add    $0x10,%esp
      state = 0;
 907:	31 d2                	xor    %edx,%edx
 909:	e9 df fe ff ff       	jmp    7ed <printf+0x4d>
 90e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 910:	83 ec 04             	sub    $0x4,%esp
 913:	88 5d e7             	mov    %bl,-0x19(%ebp)
 916:	8d 55 e7             	lea    -0x19(%ebp),%edx
 919:	6a 01                	push   $0x1
 91b:	e9 31 ff ff ff       	jmp    851 <printf+0xb1>
 920:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 925:	bb de 0a 00 00       	mov    $0xade,%ebx
 92a:	e9 77 ff ff ff       	jmp    8a6 <printf+0x106>
 92f:	90                   	nop

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	a1 e0 12 00 00       	mov    0x12e0,%eax
{
 936:	89 e5                	mov    %esp,%ebp
 938:	57                   	push   %edi
 939:	56                   	push   %esi
 93a:	53                   	push   %ebx
 93b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 93e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 948:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94a:	39 c8                	cmp    %ecx,%eax
 94c:	73 32                	jae    980 <free+0x50>
 94e:	39 d1                	cmp    %edx,%ecx
 950:	72 04                	jb     956 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	39 d0                	cmp    %edx,%eax
 954:	72 32                	jb     988 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 956:	8b 73 fc             	mov    -0x4(%ebx),%esi
 959:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 95c:	39 fa                	cmp    %edi,%edx
 95e:	74 30                	je     990 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 963:	8b 50 04             	mov    0x4(%eax),%edx
 966:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 969:	39 f1                	cmp    %esi,%ecx
 96b:	74 3a                	je     9a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 96d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 96f:	5b                   	pop    %ebx
  freep = p;
 970:	a3 e0 12 00 00       	mov    %eax,0x12e0
}
 975:	5e                   	pop    %esi
 976:	5f                   	pop    %edi
 977:	5d                   	pop    %ebp
 978:	c3                   	ret
 979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	39 d0                	cmp    %edx,%eax
 982:	72 04                	jb     988 <free+0x58>
 984:	39 d1                	cmp    %edx,%ecx
 986:	72 ce                	jb     956 <free+0x26>
{
 988:	89 d0                	mov    %edx,%eax
 98a:	eb bc                	jmp    948 <free+0x18>
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 990:	03 72 04             	add    0x4(%edx),%esi
 993:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 12                	mov    (%edx),%edx
 99a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 99d:	8b 50 04             	mov    0x4(%eax),%edx
 9a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9a3:	39 f1                	cmp    %esi,%ecx
 9a5:	75 c6                	jne    96d <free+0x3d>
    p->s.size += bp->s.size;
 9a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9aa:	a3 e0 12 00 00       	mov    %eax,0x12e0
    p->s.size += bp->s.size;
 9af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 9b5:	89 08                	mov    %ecx,(%eax)
}
 9b7:	5b                   	pop    %ebx
 9b8:	5e                   	pop    %esi
 9b9:	5f                   	pop    %edi
 9ba:	5d                   	pop    %ebp
 9bb:	c3                   	ret
 9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9cc:	8b 15 e0 12 00 00    	mov    0x12e0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8d 78 07             	lea    0x7(%eax),%edi
 9d5:	c1 ef 03             	shr    $0x3,%edi
 9d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9db:	85 d2                	test   %edx,%edx
 9dd:	0f 84 8d 00 00 00    	je     a70 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9e5:	8b 48 04             	mov    0x4(%eax),%ecx
 9e8:	39 f9                	cmp    %edi,%ecx
 9ea:	73 64                	jae    a50 <malloc+0x90>
  if(nu < 4096)
 9ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9f1:	39 df                	cmp    %ebx,%edi
 9f3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9f6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9fd:	eb 0a                	jmp    a09 <malloc+0x49>
 9ff:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a02:	8b 48 04             	mov    0x4(%eax),%ecx
 a05:	39 f9                	cmp    %edi,%ecx
 a07:	73 47                	jae    a50 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a09:	89 c2                	mov    %eax,%edx
 a0b:	3b 05 e0 12 00 00    	cmp    0x12e0,%eax
 a11:	75 ed                	jne    a00 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 a13:	83 ec 0c             	sub    $0xc,%esp
 a16:	56                   	push   %esi
 a17:	e8 5f fc ff ff       	call   67b <sbrk>
  if(p == (char*)-1)
 a1c:	83 c4 10             	add    $0x10,%esp
 a1f:	83 f8 ff             	cmp    $0xffffffff,%eax
 a22:	74 1c                	je     a40 <malloc+0x80>
  hp->s.size = nu;
 a24:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a27:	83 ec 0c             	sub    $0xc,%esp
 a2a:	83 c0 08             	add    $0x8,%eax
 a2d:	50                   	push   %eax
 a2e:	e8 fd fe ff ff       	call   930 <free>
  return freep;
 a33:	8b 15 e0 12 00 00    	mov    0x12e0,%edx
      if((p = morecore(nunits)) == 0)
 a39:	83 c4 10             	add    $0x10,%esp
 a3c:	85 d2                	test   %edx,%edx
 a3e:	75 c0                	jne    a00 <malloc+0x40>
        return 0;
  }
}
 a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a43:	31 c0                	xor    %eax,%eax
}
 a45:	5b                   	pop    %ebx
 a46:	5e                   	pop    %esi
 a47:	5f                   	pop    %edi
 a48:	5d                   	pop    %ebp
 a49:	c3                   	ret
 a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a50:	39 cf                	cmp    %ecx,%edi
 a52:	74 4c                	je     aa0 <malloc+0xe0>
        p->s.size -= nunits;
 a54:	29 f9                	sub    %edi,%ecx
 a56:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a59:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a5c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a5f:	89 15 e0 12 00 00    	mov    %edx,0x12e0
}
 a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a68:	83 c0 08             	add    $0x8,%eax
}
 a6b:	5b                   	pop    %ebx
 a6c:	5e                   	pop    %esi
 a6d:	5f                   	pop    %edi
 a6e:	5d                   	pop    %ebp
 a6f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 a70:	c7 05 e0 12 00 00 e4 	movl   $0x12e4,0x12e0
 a77:	12 00 00 
    base.s.size = 0;
 a7a:	b8 e4 12 00 00       	mov    $0x12e4,%eax
    base.s.ptr = freep = prevp = &base;
 a7f:	c7 05 e4 12 00 00 e4 	movl   $0x12e4,0x12e4
 a86:	12 00 00 
    base.s.size = 0;
 a89:	c7 05 e8 12 00 00 00 	movl   $0x0,0x12e8
 a90:	00 00 00 
    if(p->s.size >= nunits){
 a93:	e9 54 ff ff ff       	jmp    9ec <malloc+0x2c>
 a98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a9f:	00 
        prevp->s.ptr = p->s.ptr;
 aa0:	8b 08                	mov    (%eax),%ecx
 aa2:	89 0a                	mov    %ecx,(%edx)
 aa4:	eb b9                	jmp    a5f <malloc+0x9f>
