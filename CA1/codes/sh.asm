
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
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
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;
  int completion_flag;

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (fd >= 3) {
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f c4 00 00 00    	jg     e5 <main+0xe5>
  while ((fd = open("console", O_RDWR)) >= 0) {
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 14 18 00 00       	push   $0x1814
      2b:	e8 23 13 00 00       	call   1353 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
      3e:	00 
      3f:	90                   	nop
      break;
    }
  }

  // Read and run input commands.
  while ((completion_flag = getcmd(buf, sizeof(buf))) >= 0) {
      40:	83 ec 08             	sub    $0x8,%esp
      43:	6a 64                	push   $0x64
      45:	68 80 1f 00 00       	push   $0x1f80
      4a:	e8 f1 03 00 00       	call   440 <getcmd>
      4f:	83 c4 10             	add    $0x10,%esp
      52:	85 c0                	test   %eax,%eax
      54:	0f 88 86 00 00 00    	js     e0 <main+0xe0>
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      5a:	80 3d 80 1f 00 00 63 	cmpb   $0x63,0x1f80
      61:	74 25                	je     88 <main+0x88>
      buf[strlen(buf) - 1] = 0; // chop \n
      if (chdir(buf + 3) < 0)
        printf(2, "cannot cd %s\n", buf + 3);
      continue;
    }
    if (completion_flag == 3) {
      63:	83 f8 03             	cmp    $0x3,%eax
      66:	74 d8                	je     40 <main+0x40>
}

int
fork1(void)
{
  int pid = fork();
      68:	e8 9e 12 00 00       	call   130b <fork>
  if (pid == -1)
      6d:	83 f8 ff             	cmp    $0xffffffff,%eax
      70:	0f 84 95 00 00 00    	je     10b <main+0x10b>
      if (fork1() == 0)
      76:	85 c0                	test   %eax,%eax
      78:	74 7c                	je     f6 <main+0xf6>
      wait();
      7a:	e8 9c 12 00 00       	call   131b <wait>
      7f:	eb bf                	jmp    40 <main+0x40>
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      88:	80 3d 81 1f 00 00 64 	cmpb   $0x64,0x1f81
      8f:	75 d2                	jne    63 <main+0x63>
      91:	80 3d 82 1f 00 00 20 	cmpb   $0x20,0x1f82
      98:	75 c9                	jne    63 <main+0x63>
      buf[strlen(buf) - 1] = 0; // chop \n
      9a:	83 ec 0c             	sub    $0xc,%esp
      9d:	68 80 1f 00 00       	push   $0x1f80
      a2:	e8 a9 10 00 00       	call   1150 <strlen>
      if (chdir(buf + 3) < 0)
      a7:	c7 04 24 83 1f 00 00 	movl   $0x1f83,(%esp)
      buf[strlen(buf) - 1] = 0; // chop \n
      ae:	c6 80 7f 1f 00 00 00 	movb   $0x0,0x1f7f(%eax)
      if (chdir(buf + 3) < 0)
      b5:	e8 c9 12 00 00       	call   1383 <chdir>
      ba:	83 c4 10             	add    $0x10,%esp
      bd:	85 c0                	test   %eax,%eax
      bf:	0f 89 7b ff ff ff    	jns    40 <main+0x40>
        printf(2, "cannot cd %s\n", buf + 3);
      c5:	50                   	push   %eax
      c6:	68 83 1f 00 00       	push   $0x1f83
      cb:	68 1c 18 00 00       	push   $0x181c
      d0:	6a 02                	push   $0x2
      d2:	e8 89 13 00 00       	call   1460 <printf>
      d7:	83 c4 10             	add    $0x10,%esp
      da:	e9 61 ff ff ff       	jmp    40 <main+0x40>
      df:	90                   	nop
  exit();
      e0:	e8 2e 12 00 00       	call   1313 <exit>
      close(fd);
      e5:	83 ec 0c             	sub    $0xc,%esp
      e8:	50                   	push   %eax
      e9:	e8 4d 12 00 00       	call   133b <close>
      break;
      ee:	83 c4 10             	add    $0x10,%esp
      f1:	e9 4a ff ff ff       	jmp    40 <main+0x40>
        runcmd(parsecmd(buf));
      f6:	83 ec 0c             	sub    $0xc,%esp
      f9:	68 80 1f 00 00       	push   $0x1f80
      fe:	e8 4d 0f 00 00       	call   1050 <parsecmd>
     103:	89 04 24             	mov    %eax,(%esp)
     106:	e8 95 05 00 00       	call   6a0 <runcmd>
    panic("fork");
     10b:	83 ec 0c             	sub    $0xc,%esp
     10e:	68 76 17 00 00       	push   $0x1776
     113:	e8 48 05 00 00       	call   660 <panic>
     118:	66 90                	xchg   %ax,%ax
     11a:	66 90                	xchg   %ax,%ax
     11c:	66 90                	xchg   %ax,%ax
     11e:	66 90                	xchg   %ax,%ax

00000120 <auto_complete>:
{
     120:	55                   	push   %ebp
     121:	89 e5                	mov    %esp,%ebp
     123:	57                   	push   %edi
     124:	56                   	push   %esi
     125:	53                   	push   %ebx
     126:	83 ec 18             	sub    $0x18,%esp
     129:	8b 75 0c             	mov    0xc(%ebp),%esi
     12c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int buf_len   = strlen(buf);
     12f:	56                   	push   %esi
     130:	e8 1b 10 00 00       	call   1150 <strlen>
  int instr_len = strlen(instruction);
     135:	89 1c 24             	mov    %ebx,(%esp)
  int buf_len   = strlen(buf);
     138:	89 c7                	mov    %eax,%edi
  int instr_len = strlen(instruction);
     13a:	e8 11 10 00 00       	call   1150 <strlen>
  for (int i = buf_len; i <= instr_len; i++)
     13f:	83 c4 10             	add    $0x10,%esp
     142:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
     145:	39 c7                	cmp    %eax,%edi
     147:	7f 27                	jg     170 <auto_complete+0x50>
     149:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
     14c:	89 c2                	mov    %eax,%edx
     14e:	01 f7                	add    %esi,%edi
     150:	89 c8                	mov    %ecx,%eax
     152:	8d 5c 13 01          	lea    0x1(%ebx,%edx,1),%ebx
     156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     15d:	00 
     15e:	66 90                	xchg   %ax,%ax
    buf[i] = instruction[i];
     160:	0f b6 10             	movzbl (%eax),%edx
  for (int i = buf_len; i <= instr_len; i++)
     163:	83 c0 01             	add    $0x1,%eax
     166:	83 c7 01             	add    $0x1,%edi
    buf[i] = instruction[i];
     169:	88 57 ff             	mov    %dl,-0x1(%edi)
  for (int i = buf_len; i <= instr_len; i++)
     16c:	39 d8                	cmp    %ebx,%eax
     16e:	75 f0                	jne    160 <auto_complete+0x40>
  printf(2, "%s\t", instruction + buf_len);
     170:	83 ec 04             	sub    $0x4,%esp
     173:	51                   	push   %ecx
     174:	68 68 17 00 00       	push   $0x1768
     179:	6a 02                	push   $0x2
     17b:	e8 e0 12 00 00       	call   1460 <printf>
}
     180:	83 c4 10             	add    $0x10,%esp
     183:	8d 65 f4             	lea    -0xc(%ebp),%esp
     186:	5b                   	pop    %ebx
     187:	5e                   	pop    %esi
     188:	5f                   	pop    %edi
     189:	5d                   	pop    %ebp
     18a:	c3                   	ret
     18b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000190 <print_instructions>:
{
     190:	55                   	push   %ebp
     191:	89 e5                	mov    %esp,%ebp
     193:	57                   	push   %edi
     194:	56                   	push   %esi
     195:	53                   	push   %ebx
     196:	83 ec 24             	sub    $0x24,%esp
     199:	8b 45 10             	mov    0x10(%ebp),%eax
     19c:	8b 75 08             	mov    0x8(%ebp),%esi
     19f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     1a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf(2, "\n");
     1a5:	68 90 17 00 00       	push   $0x1790
     1aa:	6a 02                	push   $0x2
     1ac:	e8 af 12 00 00       	call   1460 <printf>
  for (int i = 0; i < count; i++) {
     1b1:	83 c4 10             	add    $0x10,%esp
     1b4:	85 db                	test   %ebx,%ebx
     1b6:	7e 29                	jle    1e1 <print_instructions+0x51>
     1b8:	31 ff                	xor    %edi,%edi
     1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (instructions[i])
     1c0:	8b 14 be             	mov    (%esi,%edi,4),%edx
     1c3:	85 d2                	test   %edx,%edx
     1c5:	74 13                	je     1da <print_instructions+0x4a>
      printf(2, "%s\n", instructions[i]);
     1c7:	83 ec 04             	sub    $0x4,%esp
     1ca:	52                   	push   %edx
     1cb:	68 10 18 00 00       	push   $0x1810
     1d0:	6a 02                	push   $0x2
     1d2:	e8 89 12 00 00       	call   1460 <printf>
     1d7:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < count; i++) {
     1da:	83 c7 01             	add    $0x1,%edi
     1dd:	39 fb                	cmp    %edi,%ebx
     1df:	75 df                	jne    1c0 <print_instructions+0x30>
  printf(2, "\t");
     1e1:	83 ec 08             	sub    $0x8,%esp
     1e4:	68 6a 17 00 00       	push   $0x176a
     1e9:	6a 02                	push   $0x2
     1eb:	e8 70 12 00 00       	call   1460 <printf>
  printf(2, "$ %s", prefix);
     1f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f3:	83 c4 10             	add    $0x10,%esp
     1f6:	c7 45 0c 6c 17 00 00 	movl   $0x176c,0xc(%ebp)
     1fd:	c7 45 08 02 00 00 00 	movl   $0x2,0x8(%ebp)
     204:	89 45 10             	mov    %eax,0x10(%ebp)
}
     207:	8d 65 f4             	lea    -0xc(%ebp),%esp
     20a:	5b                   	pop    %ebx
     20b:	5e                   	pop    %esi
     20c:	5f                   	pop    %edi
     20d:	5d                   	pop    %ebp
  printf(2, "$ %s", prefix);
     20e:	e9 4d 12 00 00       	jmp    1460 <printf>
     213:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     21a:	00 
     21b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000220 <scratchـstrncpy>:
{
     220:	55                   	push   %ebp
     221:	31 c0                	xor    %eax,%eax
     223:	89 e5                	mov    %esp,%ebp
     225:	56                   	push   %esi
     226:	8b 4d 10             	mov    0x10(%ebp),%ecx
     229:	8b 75 0c             	mov    0xc(%ebp),%esi
     22c:	53                   	push   %ebx
     22d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for (i = 0; i < n && src[i]; i++)
     230:	85 c9                	test   %ecx,%ecx
     232:	7f 16                	jg     24a <scratchـstrncpy+0x2a>
     234:	eb 48                	jmp    27e <scratchـstrncpy+0x5e>
     236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     23d:	00 
     23e:	66 90                	xchg   %ax,%ax
    dst[i] = src[i];
     240:	88 14 03             	mov    %dl,(%ebx,%eax,1)
  for (i = 0; i < n && src[i]; i++)
     243:	83 c0 01             	add    $0x1,%eax
     246:	39 c1                	cmp    %eax,%ecx
     248:	74 34                	je     27e <scratchـstrncpy+0x5e>
     24a:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
     24e:	84 d2                	test   %dl,%dl
     250:	75 ee                	jne    240 <scratchـstrncpy+0x20>
  for (; i < n; i++)
     252:	39 c1                	cmp    %eax,%ecx
     254:	7e 28                	jle    27e <scratchـstrncpy+0x5e>
     256:	01 d9                	add    %ebx,%ecx
     258:	01 d8                	add    %ebx,%eax
     25a:	89 ca                	mov    %ecx,%edx
     25c:	29 c2                	sub    %eax,%edx
     25e:	83 e2 01             	and    $0x1,%edx
     261:	74 0d                	je     270 <scratchـstrncpy+0x50>
    dst[i] = 0;
     263:	c6 00 00             	movb   $0x0,(%eax)
  for (; i < n; i++)
     266:	83 c0 01             	add    $0x1,%eax
     269:	39 c8                	cmp    %ecx,%eax
     26b:	74 11                	je     27e <scratchـstrncpy+0x5e>
     26d:	8d 76 00             	lea    0x0(%esi),%esi
    dst[i] = 0;
     270:	c6 00 00             	movb   $0x0,(%eax)
  for (; i < n; i++)
     273:	83 c0 02             	add    $0x2,%eax
    dst[i] = 0;
     276:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  for (; i < n; i++)
     27a:	39 c8                	cmp    %ecx,%eax
     27c:	75 f2                	jne    270 <scratchـstrncpy+0x50>
}
     27e:	89 d8                	mov    %ebx,%eax
     280:	5b                   	pop    %ebx
     281:	5e                   	pop    %esi
     282:	5d                   	pop    %ebp
     283:	c3                   	ret
     284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     28b:	00 
     28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <get_matching_instructions>:
{
     290:	55                   	push   %ebp
     291:	89 e5                	mov    %esp,%ebp
     293:	57                   	push   %edi
     294:	56                   	push   %esi
     295:	53                   	push   %ebx
     296:	83 ec 34             	sub    $0x34,%esp
     299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  fd = open(path, 0);
     29c:	6a 00                	push   $0x0
     29e:	68 71 17 00 00       	push   $0x1771
     2a3:	e8 ab 10 00 00       	call   1353 <open>
     2a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  char **instructions = malloc(sizeof(char *) * 16);
     2ab:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
     2b2:	e8 c9 13 00 00       	call   1680 <malloc>
     2b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  int prefix_len = strlen(prefix);
     2ba:	89 1c 24             	mov    %ebx,(%esp)
     2bd:	e8 8e 0e 00 00       	call   1150 <strlen>
  for (int i = 0; i < prefix_len; i++) {
     2c2:	83 c4 10             	add    $0x10,%esp
  int prefix_len = strlen(prefix);
     2c5:	89 c7                	mov    %eax,%edi
  for (int i = 0; i < prefix_len; i++) {
     2c7:	85 c0                	test   %eax,%eax
     2c9:	0f 8e 2c 01 00 00    	jle    3fb <get_matching_instructions+0x16b>
    if (prefix[i] != 'c' && i == 0) { match_cd = 0; break; }
     2cf:	0f b6 03             	movzbl (%ebx),%eax
     2d2:	3c 63                	cmp    $0x63,%al
     2d4:	0f 84 06 01 00 00    	je     3e0 <get_matching_instructions+0x150>
     2da:	31 c9                	xor    %ecx,%ecx
    if (i == 1 && prefix[i] != 'd') { match_cd = 0; break; }
     2dc:	83 f9 01             	cmp    $0x1,%ecx
     2df:	0f 84 eb 00 00 00    	je     3d0 <get_matching_instructions+0x140>
  int counter = 0;
     2e5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
     2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
     2f0:	83 ec 04             	sub    $0x4,%esp
     2f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
     2f6:	6a 10                	push   $0x10
     2f8:	50                   	push   %eax
     2f9:	ff 75 d4             	push   -0x2c(%ebp)
     2fc:	e8 2a 10 00 00       	call   132b <read>
     301:	83 c4 10             	add    $0x10,%esp
     304:	83 f8 10             	cmp    $0x10,%eax
     307:	0f 85 a3 00 00 00    	jne    3b0 <get_matching_instructions+0x120>
    if (de.inum == 0)
     30d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
     312:	74 dc                	je     2f0 <get_matching_instructions+0x60>
    for (int i = 0; i < prefix_len; i++) {
     314:	8d 75 da             	lea    -0x26(%ebp),%esi
     317:	85 ff                	test   %edi,%edi
     319:	7e 16                	jle    331 <get_matching_instructions+0xa1>
     31b:	31 c0                	xor    %eax,%eax
     31d:	8d 75 da             	lea    -0x26(%ebp),%esi
      if (prefix[i] != de.name[i]) {
     320:	0f b6 4c 05 da       	movzbl -0x26(%ebp,%eax,1),%ecx
     325:	38 0c 03             	cmp    %cl,(%ebx,%eax,1)
     328:	75 c6                	jne    2f0 <get_matching_instructions+0x60>
    for (int i = 0; i < prefix_len; i++) {
     32a:	83 c0 01             	add    $0x1,%eax
     32d:	39 c7                	cmp    %eax,%edi
     32f:	75 ef                	jne    320 <get_matching_instructions+0x90>
      instructions[counter] = malloc(DIRSIZ + 1);
     331:	8b 45 c8             	mov    -0x38(%ebp),%eax
     334:	8b 55 d0             	mov    -0x30(%ebp),%edx
     337:	83 ec 0c             	sub    $0xc,%esp
     33a:	8d 04 90             	lea    (%eax,%edx,4),%eax
     33d:	89 45 cc             	mov    %eax,-0x34(%ebp)
     340:	6a 0f                	push   $0xf
     342:	e8 39 13 00 00       	call   1680 <malloc>
     347:	83 c4 10             	add    $0x10,%esp
     34a:	89 c1                	mov    %eax,%ecx
     34c:	8b 45 cc             	mov    -0x34(%ebp),%eax
     34f:	89 08                	mov    %ecx,(%eax)
  for (i = 0; i < n && src[i]; i++)
     351:	31 c0                	xor    %eax,%eax
     353:	eb 0e                	jmp    363 <get_matching_instructions+0xd3>
     355:	8d 76 00             	lea    0x0(%esi),%esi
    dst[i] = src[i];
     358:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  for (i = 0; i < n && src[i]; i++)
     35b:	83 c0 01             	add    $0x1,%eax
     35e:	83 f8 0e             	cmp    $0xe,%eax
     361:	74 33                	je     396 <get_matching_instructions+0x106>
     363:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
     367:	84 d2                	test   %dl,%dl
     369:	75 ed                	jne    358 <get_matching_instructions+0xc8>
  for (; i < n; i++)
     36b:	01 c8                	add    %ecx,%eax
     36d:	83 c1 0e             	add    $0xe,%ecx
     370:	89 ca                	mov    %ecx,%edx
     372:	29 c2                	sub    %eax,%edx
     374:	83 e2 01             	and    $0x1,%edx
     377:	74 0f                	je     388 <get_matching_instructions+0xf8>
    dst[i] = 0;
     379:	c6 00 00             	movb   $0x0,(%eax)
  for (; i < n; i++)
     37c:	83 c0 01             	add    $0x1,%eax
     37f:	39 c8                	cmp    %ecx,%eax
     381:	74 13                	je     396 <get_matching_instructions+0x106>
     383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    dst[i] = 0;
     388:	c6 00 00             	movb   $0x0,(%eax)
  for (; i < n; i++)
     38b:	83 c0 02             	add    $0x2,%eax
    dst[i] = 0;
     38e:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  for (; i < n; i++)
     392:	39 c8                	cmp    %ecx,%eax
     394:	75 f2                	jne    388 <get_matching_instructions+0xf8>
      instructions[counter][DIRSIZ] = 0;
     396:	8b 45 cc             	mov    -0x34(%ebp),%eax
      counter++;
     399:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
      *num_of_instructions = counter;
     39d:	8b 75 0c             	mov    0xc(%ebp),%esi
      instructions[counter][DIRSIZ] = 0;
     3a0:	8b 00                	mov    (%eax),%eax
     3a2:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      counter++;
     3a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
      *num_of_instructions = counter;
     3a9:	89 06                	mov    %eax,(%esi)
     3ab:	e9 40 ff ff ff       	jmp    2f0 <get_matching_instructions+0x60>
  close(fd);
     3b0:	83 ec 0c             	sub    $0xc,%esp
     3b3:	ff 75 d4             	push   -0x2c(%ebp)
     3b6:	e8 80 0f 00 00       	call   133b <close>
}
     3bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
     3be:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3c1:	5b                   	pop    %ebx
     3c2:	5e                   	pop    %esi
     3c3:	5f                   	pop    %edi
     3c4:	5d                   	pop    %ebp
     3c5:	c3                   	ret
     3c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     3cd:	00 
     3ce:	66 90                	xchg   %ax,%ax
    if (i == 1 && prefix[i] != 'd') { match_cd = 0; break; }
     3d0:	3c 64                	cmp    $0x64,%al
     3d2:	0f 85 0d ff ff ff    	jne    2e5 <get_matching_instructions+0x55>
     3d8:	b8 01 00 00 00       	mov    $0x1,%eax
     3dd:	eb 03                	jmp    3e2 <get_matching_instructions+0x152>
     3df:	90                   	nop
     3e0:	31 c0                	xor    %eax,%eax
  for (int i = 0; i < prefix_len; i++) {
     3e2:	8d 48 01             	lea    0x1(%eax),%ecx
     3e5:	39 cf                	cmp    %ecx,%edi
     3e7:	74 12                	je     3fb <get_matching_instructions+0x16b>
    if (prefix[i] != 'c' && i == 0) { match_cd = 0; break; }
     3e9:	0f b6 44 03 01       	movzbl 0x1(%ebx,%eax,1),%eax
     3ee:	3c 63                	cmp    $0x63,%al
     3f0:	0f 85 e6 fe ff ff    	jne    2dc <get_matching_instructions+0x4c>
     3f6:	e9 ea fe ff ff       	jmp    2e5 <get_matching_instructions+0x55>
    instructions[counter] = malloc(3);
     3fb:	83 ec 0c             	sub    $0xc,%esp
     3fe:	6a 03                	push   $0x3
     400:	e8 7b 12 00 00       	call   1680 <malloc>
     405:	8b 75 c8             	mov    -0x38(%ebp),%esi
    dst[i] = src[i];
     408:	ba 63 64 00 00       	mov    $0x6463,%edx
    *num_of_instructions = counter;
     40d:	83 c4 10             	add    $0x10,%esp
    counter++;
     410:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    instructions[counter] = malloc(3);
     417:	89 06                	mov    %eax,(%esi)
    dst[i] = 0;
     419:	c6 40 02 00          	movb   $0x0,0x2(%eax)
    dst[i] = src[i];
     41d:	66 89 10             	mov    %dx,(%eax)
    instructions[counter][2] = 0;
     420:	8b 06                	mov    (%esi),%eax
     422:	c6 40 02 00          	movb   $0x0,0x2(%eax)
    *num_of_instructions = counter;
     426:	8b 45 0c             	mov    0xc(%ebp),%eax
     429:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
     42f:	e9 bc fe ff ff       	jmp    2f0 <get_matching_instructions+0x60>
     434:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     43b:	00 
     43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <getcmd>:
{
     440:	55                   	push   %ebp
     441:	89 e5                	mov    %esp,%ebp
     443:	56                   	push   %esi
     444:	53                   	push   %ebx
     445:	83 ec 10             	sub    $0x10,%esp
  if (!temp_buf) {
     448:	a1 60 1f 00 00       	mov    0x1f60,%eax
{
     44d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     450:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (!temp_buf) {
     453:	85 c0                	test   %eax,%eax
     455:	0f 84 3d 01 00 00    	je     598 <getcmd+0x158>
  if ((!TAPPRESS && !has_multiple_choice)) {
     45b:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
     460:	0b 05 68 1f 00 00    	or     0x1f68,%eax
     466:	0f 84 5c 01 00 00    	je     5c8 <getcmd+0x188>
  gets(buf, nbuf);
     46c:	83 ec 08             	sub    $0x8,%esp
     46f:	56                   	push   %esi
     470:	53                   	push   %ebx
     471:	e8 6a 0d 00 00       	call   11e0 <gets>
  int len = strlen(buf);
     476:	89 1c 24             	mov    %ebx,(%esp)
     479:	e8 d2 0c 00 00       	call   1150 <strlen>
  if (len > 0 && buf[len - 1] == '\t') {
     47e:	83 c4 10             	add    $0x10,%esp
     481:	85 c0                	test   %eax,%eax
     483:	7e 09                	jle    48e <getcmd+0x4e>
     485:	8d 44 03 ff          	lea    -0x1(%ebx,%eax,1),%eax
     489:	80 38 09             	cmpb   $0x9,(%eax)
     48c:	74 5a                	je     4e8 <getcmd+0xa8>
  if (temp_buf && strcmp(buf, temp_buf) != 0) {
     48e:	a1 60 1f 00 00       	mov    0x1f60,%eax
     493:	85 c0                	test   %eax,%eax
     495:	74 0d                	je     4a4 <getcmd+0x64>
     497:	83 ec 08             	sub    $0x8,%esp
     49a:	50                   	push   %eax
     49b:	53                   	push   %ebx
     49c:	e8 4f 0c 00 00       	call   10f0 <strcmp>
     4a1:	83 c4 10             	add    $0x10,%esp
    TAPPRESS = 0;
     4a4:	c7 05 6c 1f 00 00 00 	movl   $0x0,0x1f6c
     4ab:	00 00 00 
    has_multiple_choice = 0;
     4ae:	c7 05 68 1f 00 00 00 	movl   $0x0,0x1f68
     4b5:	00 00 00 
  if (buf[0] == 0)
     4b8:	80 3b 00             	cmpb   $0x0,(%ebx)
     4bb:	0f 84 89 01 00 00    	je     64a <getcmd+0x20a>
  if (temp_buf)
     4c1:	a1 60 1f 00 00       	mov    0x1f60,%eax
     4c6:	85 c0                	test   %eax,%eax
     4c8:	74 0e                	je     4d8 <getcmd+0x98>
    memmove(temp_buf, buf, nbuf); // snapshot current prefix
     4ca:	83 ec 04             	sub    $0x4,%esp
     4cd:	56                   	push   %esi
     4ce:	53                   	push   %ebx
     4cf:	50                   	push   %eax
     4d0:	e8 0b 0e 00 00       	call   12e0 <memmove>
     4d5:	83 c4 10             	add    $0x10,%esp
  return 0;
     4d8:	31 c0                	xor    %eax,%eax
}
     4da:	8d 65 f8             	lea    -0x8(%ebp),%esp
     4dd:	5b                   	pop    %ebx
     4de:	5e                   	pop    %esi
     4df:	5d                   	pop    %ebp
     4e0:	c3                   	ret
     4e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buf[len - 1] = 0; // strip the tab for prefix logic
     4e8:	c6 00 00             	movb   $0x0,(%eax)
  if (temp_buf && strcmp(buf, temp_buf) != 0) {
     4eb:	a1 60 1f 00 00       	mov    0x1f60,%eax
     4f0:	85 c0                	test   %eax,%eax
     4f2:	74 25                	je     519 <getcmd+0xd9>
     4f4:	83 ec 08             	sub    $0x8,%esp
     4f7:	50                   	push   %eax
     4f8:	53                   	push   %ebx
     4f9:	e8 f2 0b 00 00       	call   10f0 <strcmp>
     4fe:	83 c4 10             	add    $0x10,%esp
     501:	85 c0                	test   %eax,%eax
     503:	74 14                	je     519 <getcmd+0xd9>
    has_multiple_choice = 0;
     505:	c7 05 68 1f 00 00 00 	movl   $0x0,0x1f68
     50c:	00 00 00 
    TAPPRESS = 0;
     50f:	c7 05 6c 1f 00 00 00 	movl   $0x0,0x1f6c
     516:	00 00 00 
    char **instructions = get_matching_instructions(buf, &instruction_num);
     519:	83 ec 08             	sub    $0x8,%esp
     51c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    int instruction_num = 0;
     51f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char **instructions = get_matching_instructions(buf, &instruction_num);
     526:	50                   	push   %eax
     527:	53                   	push   %ebx
     528:	e8 63 fd ff ff       	call   290 <get_matching_instructions>
    if (instruction_num == 0) {
     52d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     530:	83 c4 10             	add    $0x10,%esp
     533:	85 d2                	test   %edx,%edx
     535:	74 49                	je     580 <getcmd+0x140>
    else if (instruction_num == 1) {
     537:	83 fa 01             	cmp    $0x1,%edx
     53a:	0f 84 e0 00 00 00    	je     620 <getcmd+0x1e0>
      if (has_multiple_choice) {
     540:	8b 0d 68 1f 00 00    	mov    0x1f68,%ecx
     546:	85 c9                	test   %ecx,%ecx
     548:	0f 85 a2 00 00 00    	jne    5f0 <getcmd+0x1b0>
        if (temp_buf)
     54e:	a1 60 1f 00 00       	mov    0x1f60,%eax
        has_multiple_choice = 1; 
     553:	c7 05 68 1f 00 00 01 	movl   $0x1,0x1f68
     55a:	00 00 00 
        if (temp_buf)
     55d:	85 c0                	test   %eax,%eax
     55f:	74 0e                	je     56f <getcmd+0x12f>
          memmove(temp_buf, buf, nbuf);
     561:	83 ec 04             	sub    $0x4,%esp
     564:	56                   	push   %esi
     565:	53                   	push   %ebx
     566:	50                   	push   %eax
     567:	e8 74 0d 00 00       	call   12e0 <memmove>
     56c:	83 c4 10             	add    $0x10,%esp
}
     56f:	8d 65 f8             	lea    -0x8(%ebp),%esp
     572:	b8 03 00 00 00       	mov    $0x3,%eax
     577:	5b                   	pop    %ebx
     578:	5e                   	pop    %esi
     579:	5d                   	pop    %ebp
     57a:	c3                   	ret
     57b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (temp_buf)
     580:	a1 60 1f 00 00       	mov    0x1f60,%eax
      TAPPRESS = 1;
     585:	c7 05 6c 1f 00 00 01 	movl   $0x1,0x1f6c
     58c:	00 00 00 
      if (temp_buf)
     58f:	85 c0                	test   %eax,%eax
     591:	75 ce                	jne    561 <getcmd+0x121>
     593:	eb da                	jmp    56f <getcmd+0x12f>
     595:	8d 76 00             	lea    0x0(%esi),%esi
    temp_buf = malloc(nbuf);
     598:	83 ec 0c             	sub    $0xc,%esp
     59b:	56                   	push   %esi
     59c:	e8 df 10 00 00       	call   1680 <malloc>
    if (temp_buf)
     5a1:	83 c4 10             	add    $0x10,%esp
    temp_buf = malloc(nbuf);
     5a4:	a3 60 1f 00 00       	mov    %eax,0x1f60
    if (temp_buf)
     5a9:	85 c0                	test   %eax,%eax
     5ab:	0f 84 aa fe ff ff    	je     45b <getcmd+0x1b>
      temp_buf[0] = 0;
     5b1:	c6 00 00             	movb   $0x0,(%eax)
  if ((!TAPPRESS && !has_multiple_choice)) {
     5b4:	a1 6c 1f 00 00       	mov    0x1f6c,%eax
     5b9:	0b 05 68 1f 00 00    	or     0x1f68,%eax
     5bf:	0f 85 a7 fe ff ff    	jne    46c <getcmd+0x2c>
     5c5:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "$ ");
     5c8:	83 ec 08             	sub    $0x8,%esp
     5cb:	68 73 17 00 00       	push   $0x1773
     5d0:	6a 02                	push   $0x2
     5d2:	e8 89 0e 00 00       	call   1460 <printf>
    memset(buf, 0, nbuf);
     5d7:	83 c4 0c             	add    $0xc,%esp
     5da:	56                   	push   %esi
     5db:	6a 00                	push   $0x0
     5dd:	53                   	push   %ebx
     5de:	e8 9d 0b 00 00       	call   1180 <memset>
     5e3:	83 c4 10             	add    $0x10,%esp
     5e6:	e9 81 fe ff ff       	jmp    46c <getcmd+0x2c>
     5eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        print_instructions(instructions, instruction_num, buf);
     5f0:	83 ec 04             	sub    $0x4,%esp
     5f3:	53                   	push   %ebx
     5f4:	52                   	push   %edx
     5f5:	50                   	push   %eax
     5f6:	e8 95 fb ff ff       	call   190 <print_instructions>
        if (temp_buf)
     5fb:	a1 60 1f 00 00       	mov    0x1f60,%eax
     600:	83 c4 10             	add    $0x10,%esp
        done_printing = 1;
     603:	c7 05 64 1f 00 00 01 	movl   $0x1,0x1f64
     60a:	00 00 00 
        if (temp_buf)
     60d:	85 c0                	test   %eax,%eax
     60f:	0f 85 4c ff ff ff    	jne    561 <getcmd+0x121>
     615:	e9 55 ff ff ff       	jmp    56f <getcmd+0x12f>
     61a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      auto_complete(instructions[0], buf);
     620:	83 ec 08             	sub    $0x8,%esp
     623:	53                   	push   %ebx
     624:	ff 30                	push   (%eax)
     626:	e8 f5 fa ff ff       	call   120 <auto_complete>
      if (temp_buf)
     62b:	a1 60 1f 00 00       	mov    0x1f60,%eax
     630:	83 c4 10             	add    $0x10,%esp
      TAPPRESS = 1;
     633:	c7 05 6c 1f 00 00 01 	movl   $0x1,0x1f6c
     63a:	00 00 00 
      if (temp_buf)
     63d:	85 c0                	test   %eax,%eax
     63f:	0f 85 1c ff ff ff    	jne    561 <getcmd+0x121>
     645:	e9 25 ff ff ff       	jmp    56f <getcmd+0x12f>
    return -1; // EOF
     64a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     64f:	e9 86 fe ff ff       	jmp    4da <getcmd+0x9a>
     654:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     65b:	00 
     65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <panic>:
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     666:	ff 75 08             	push   0x8(%ebp)
     669:	68 10 18 00 00       	push   $0x1810
     66e:	6a 02                	push   $0x2
     670:	e8 eb 0d 00 00       	call   1460 <printf>
  exit();
     675:	e8 99 0c 00 00       	call   1313 <exit>
     67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000680 <fork1>:
{
     680:	55                   	push   %ebp
     681:	89 e5                	mov    %esp,%ebp
     683:	83 ec 08             	sub    $0x8,%esp
  int pid = fork();
     686:	e8 80 0c 00 00       	call   130b <fork>
  if (pid == -1)
     68b:	83 f8 ff             	cmp    $0xffffffff,%eax
     68e:	74 02                	je     692 <fork1+0x12>
  return pid;
}
     690:	c9                   	leave
     691:	c3                   	ret
    panic("fork");
     692:	83 ec 0c             	sub    $0xc,%esp
     695:	68 76 17 00 00       	push   $0x1776
     69a:	e8 c1 ff ff ff       	call   660 <panic>
     69f:	90                   	nop

000006a0 <runcmd>:
{
     6a0:	55                   	push   %ebp
     6a1:	89 e5                	mov    %esp,%ebp
     6a3:	53                   	push   %ebx
     6a4:	83 ec 14             	sub    $0x14,%esp
     6a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (cmd == 0)
     6aa:	85 db                	test   %ebx,%ebx
     6ac:	74 42                	je     6f0 <runcmd+0x50>
  switch (cmd->type) {
     6ae:	83 3b 05             	cmpl   $0x5,(%ebx)
     6b1:	0f 87 e3 00 00 00    	ja     79a <runcmd+0xfa>
     6b7:	8b 03                	mov    (%ebx),%eax
     6b9:	ff 24 85 34 18 00 00 	jmp    *0x1834(,%eax,4)
    if (ecmd->argv[0] == 0)
     6c0:	8b 43 04             	mov    0x4(%ebx),%eax
     6c3:	85 c0                	test   %eax,%eax
     6c5:	74 29                	je     6f0 <runcmd+0x50>
    exec(ecmd->argv[0], ecmd->argv);
     6c7:	8d 53 04             	lea    0x4(%ebx),%edx
     6ca:	51                   	push   %ecx
     6cb:	51                   	push   %ecx
     6cc:	52                   	push   %edx
     6cd:	50                   	push   %eax
     6ce:	e8 78 0c 00 00       	call   134b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     6d3:	83 c4 0c             	add    $0xc,%esp
     6d6:	ff 73 04             	push   0x4(%ebx)
     6d9:	68 82 17 00 00       	push   $0x1782
     6de:	6a 02                	push   $0x2
     6e0:	e8 7b 0d 00 00       	call   1460 <printf>
    break;
     6e5:	83 c4 10             	add    $0x10,%esp
     6e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     6ef:	00 
    exit();
     6f0:	e8 1e 0c 00 00       	call   1313 <exit>
    if (fork1() == 0)
     6f5:	e8 86 ff ff ff       	call   680 <fork1>
     6fa:	85 c0                	test   %eax,%eax
     6fc:	75 f2                	jne    6f0 <runcmd+0x50>
     6fe:	e9 8c 00 00 00       	jmp    78f <runcmd+0xef>
    if (pipe(p) < 0)
     703:	83 ec 0c             	sub    $0xc,%esp
     706:	8d 45 f0             	lea    -0x10(%ebp),%eax
     709:	50                   	push   %eax
     70a:	e8 14 0c 00 00       	call   1323 <pipe>
     70f:	83 c4 10             	add    $0x10,%esp
     712:	85 c0                	test   %eax,%eax
     714:	0f 88 a2 00 00 00    	js     7bc <runcmd+0x11c>
    if (fork1() == 0) {
     71a:	e8 61 ff ff ff       	call   680 <fork1>
     71f:	85 c0                	test   %eax,%eax
     721:	0f 84 a2 00 00 00    	je     7c9 <runcmd+0x129>
    if (fork1() == 0) {
     727:	e8 54 ff ff ff       	call   680 <fork1>
     72c:	85 c0                	test   %eax,%eax
     72e:	0f 84 c3 00 00 00    	je     7f7 <runcmd+0x157>
    close(p[0]);
     734:	83 ec 0c             	sub    $0xc,%esp
     737:	ff 75 f0             	push   -0x10(%ebp)
     73a:	e8 fc 0b 00 00       	call   133b <close>
    close(p[1]);
     73f:	58                   	pop    %eax
     740:	ff 75 f4             	push   -0xc(%ebp)
     743:	e8 f3 0b 00 00       	call   133b <close>
    wait();
     748:	e8 ce 0b 00 00       	call   131b <wait>
    wait();
     74d:	e8 c9 0b 00 00       	call   131b <wait>
    break;
     752:	83 c4 10             	add    $0x10,%esp
     755:	eb 99                	jmp    6f0 <runcmd+0x50>
    if (fork1() == 0)
     757:	e8 24 ff ff ff       	call   680 <fork1>
     75c:	85 c0                	test   %eax,%eax
     75e:	74 2f                	je     78f <runcmd+0xef>
    wait();
     760:	e8 b6 0b 00 00       	call   131b <wait>
    runcmd(lcmd->right);
     765:	83 ec 0c             	sub    $0xc,%esp
     768:	ff 73 08             	push   0x8(%ebx)
     76b:	e8 30 ff ff ff       	call   6a0 <runcmd>
    close(rcmd->fd);
     770:	83 ec 0c             	sub    $0xc,%esp
     773:	ff 73 14             	push   0x14(%ebx)
     776:	e8 c0 0b 00 00       	call   133b <close>
    if (open(rcmd->file, rcmd->mode) < 0) {
     77b:	58                   	pop    %eax
     77c:	5a                   	pop    %edx
     77d:	ff 73 10             	push   0x10(%ebx)
     780:	ff 73 08             	push   0x8(%ebx)
     783:	e8 cb 0b 00 00       	call   1353 <open>
     788:	83 c4 10             	add    $0x10,%esp
     78b:	85 c0                	test   %eax,%eax
     78d:	78 18                	js     7a7 <runcmd+0x107>
      runcmd(bcmd->cmd);
     78f:	83 ec 0c             	sub    $0xc,%esp
     792:	ff 73 04             	push   0x4(%ebx)
     795:	e8 06 ff ff ff       	call   6a0 <runcmd>
    panic("runcmd");
     79a:	83 ec 0c             	sub    $0xc,%esp
     79d:	68 7b 17 00 00       	push   $0x177b
     7a2:	e8 b9 fe ff ff       	call   660 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     7a7:	51                   	push   %ecx
     7a8:	ff 73 08             	push   0x8(%ebx)
     7ab:	68 92 17 00 00       	push   $0x1792
     7b0:	6a 02                	push   $0x2
     7b2:	e8 a9 0c 00 00       	call   1460 <printf>
      exit();
     7b7:	e8 57 0b 00 00       	call   1313 <exit>
      panic("pipe");
     7bc:	83 ec 0c             	sub    $0xc,%esp
     7bf:	68 a2 17 00 00       	push   $0x17a2
     7c4:	e8 97 fe ff ff       	call   660 <panic>
      close(1);
     7c9:	83 ec 0c             	sub    $0xc,%esp
     7cc:	6a 01                	push   $0x1
     7ce:	e8 68 0b 00 00       	call   133b <close>
      dup(p[1]);
     7d3:	58                   	pop    %eax
     7d4:	ff 75 f4             	push   -0xc(%ebp)
     7d7:	e8 af 0b 00 00       	call   138b <dup>
      close(p[0]);
     7dc:	58                   	pop    %eax
     7dd:	ff 75 f0             	push   -0x10(%ebp)
     7e0:	e8 56 0b 00 00       	call   133b <close>
      close(p[1]);
     7e5:	58                   	pop    %eax
     7e6:	ff 75 f4             	push   -0xc(%ebp)
     7e9:	e8 4d 0b 00 00       	call   133b <close>
      runcmd(pcmd->left);
     7ee:	5a                   	pop    %edx
     7ef:	ff 73 04             	push   0x4(%ebx)
     7f2:	e8 a9 fe ff ff       	call   6a0 <runcmd>
      close(0);
     7f7:	83 ec 0c             	sub    $0xc,%esp
     7fa:	6a 00                	push   $0x0
     7fc:	e8 3a 0b 00 00       	call   133b <close>
      dup(p[0]);
     801:	5a                   	pop    %edx
     802:	ff 75 f0             	push   -0x10(%ebp)
     805:	e8 81 0b 00 00       	call   138b <dup>
      close(p[0]);
     80a:	59                   	pop    %ecx
     80b:	ff 75 f0             	push   -0x10(%ebp)
     80e:	e8 28 0b 00 00       	call   133b <close>
      close(p[1]);
     813:	58                   	pop    %eax
     814:	ff 75 f4             	push   -0xc(%ebp)
     817:	e8 1f 0b 00 00       	call   133b <close>
      runcmd(pcmd->right);
     81c:	58                   	pop    %eax
     81d:	ff 73 08             	push   0x8(%ebx)
     820:	e8 7b fe ff ff       	call   6a0 <runcmd>
     825:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     82c:	00 
     82d:	8d 76 00             	lea    0x0(%esi),%esi

00000830 <execcmd>:
// PAGEBREAK!
// Constructors

struct cmd *
execcmd(void)
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	53                   	push   %ebx
     834:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;
  cmd = malloc(sizeof(*cmd));
     837:	6a 54                	push   $0x54
     839:	e8 42 0e 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     83e:	83 c4 0c             	add    $0xc,%esp
     841:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     843:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     845:	6a 00                	push   $0x0
     847:	50                   	push   %eax
     848:	e8 33 09 00 00       	call   1180 <memset>
  cmd->type = EXEC;
     84d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd *)cmd;
}
     853:	89 d8                	mov    %ebx,%eax
     855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     858:	c9                   	leave
     859:	c3                   	ret
     85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000860 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	53                   	push   %ebx
     864:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;
  cmd = malloc(sizeof(*cmd));
     867:	6a 18                	push   $0x18
     869:	e8 12 0e 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     86e:	83 c4 0c             	add    $0xc,%esp
     871:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     873:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     875:	6a 00                	push   $0x0
     877:	50                   	push   %eax
     878:	e8 03 09 00 00       	call   1180 <memset>
  cmd->type = REDIR;
  cmd->cmd  = subcmd;
     87d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     880:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd  = subcmd;
     886:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     889:	8b 45 0c             	mov    0xc(%ebp),%eax
     88c:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     88f:	8b 45 10             	mov    0x10(%ebp),%eax
     892:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     895:	8b 45 14             	mov    0x14(%ebp),%eax
     898:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd   = fd;
     89b:	8b 45 18             	mov    0x18(%ebp),%eax
     89e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd *)cmd;
}
     8a1:	89 d8                	mov    %ebx,%eax
     8a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8a6:	c9                   	leave
     8a7:	c3                   	ret
     8a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8af:	00 

000008b0 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     8b0:	55                   	push   %ebp
     8b1:	89 e5                	mov    %esp,%ebp
     8b3:	53                   	push   %ebx
     8b4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;
  cmd = malloc(sizeof(*cmd));
     8b7:	6a 0c                	push   $0xc
     8b9:	e8 c2 0d 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     8be:	83 c4 0c             	add    $0xc,%esp
     8c1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     8c3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     8c5:	6a 00                	push   $0x0
     8c7:	50                   	push   %eax
     8c8:	e8 b3 08 00 00       	call   1180 <memset>
  cmd->type  = PIPE;
  cmd->left  = left;
     8cd:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type  = PIPE;
     8d0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left  = left;
     8d6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     8d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     8dc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     8df:	89 d8                	mov    %ebx,%eax
     8e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8e4:	c9                   	leave
     8e5:	c3                   	ret
     8e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     8ed:	00 
     8ee:	66 90                	xchg   %ax,%ax

000008f0 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     8f0:	55                   	push   %ebp
     8f1:	89 e5                	mov    %esp,%ebp
     8f3:	53                   	push   %ebx
     8f4:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;
  cmd = malloc(sizeof(*cmd));
     8f7:	6a 0c                	push   $0xc
     8f9:	e8 82 0d 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     8fe:	83 c4 0c             	add    $0xc,%esp
     901:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     903:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     905:	6a 00                	push   $0x0
     907:	50                   	push   %eax
     908:	e8 73 08 00 00       	call   1180 <memset>
  cmd->type  = LIST;
  cmd->left  = left;
     90d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type  = LIST;
     910:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left  = left;
     916:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     919:	8b 45 0c             	mov    0xc(%ebp),%eax
     91c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd *)cmd;
}
     91f:	89 d8                	mov    %ebx,%eax
     921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     924:	c9                   	leave
     925:	c3                   	ret
     926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     92d:	00 
     92e:	66 90                	xchg   %ax,%ax

00000930 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     930:	55                   	push   %ebp
     931:	89 e5                	mov    %esp,%ebp
     933:	53                   	push   %ebx
     934:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;
  cmd = malloc(sizeof(*cmd));
     937:	6a 08                	push   $0x8
     939:	e8 42 0d 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     93e:	83 c4 0c             	add    $0xc,%esp
     941:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     943:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     945:	6a 00                	push   $0x0
     947:	50                   	push   %eax
     948:	e8 33 08 00 00       	call   1180 <memset>
  cmd->type = BACK;
  cmd->cmd  = subcmd;
     94d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     950:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd  = subcmd;
     956:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd *)cmd;
}
     959:	89 d8                	mov    %ebx,%eax
     95b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     95e:	c9                   	leave
     95f:	c3                   	ret

00000960 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[]    = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	57                   	push   %edi
     964:	56                   	push   %esi
     965:	53                   	push   %ebx
     966:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     969:	8b 45 08             	mov    0x8(%ebp),%eax
{
     96c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     96f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     972:	8b 38                	mov    (%eax),%edi
  while (s < es && strchr(whitespace, *s))
     974:	39 df                	cmp    %ebx,%edi
     976:	72 0f                	jb     987 <gettoken+0x27>
     978:	eb 25                	jmp    99f <gettoken+0x3f>
     97a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     980:	83 c7 01             	add    $0x1,%edi
  while (s < es && strchr(whitespace, *s))
     983:	39 fb                	cmp    %edi,%ebx
     985:	74 18                	je     99f <gettoken+0x3f>
     987:	0f be 07             	movsbl (%edi),%eax
     98a:	83 ec 08             	sub    $0x8,%esp
     98d:	50                   	push   %eax
     98e:	68 50 1f 00 00       	push   $0x1f50
     993:	e8 08 08 00 00       	call   11a0 <strchr>
     998:	83 c4 10             	add    $0x10,%esp
     99b:	85 c0                	test   %eax,%eax
     99d:	75 e1                	jne    980 <gettoken+0x20>
  if (q)
     99f:	85 f6                	test   %esi,%esi
     9a1:	74 02                	je     9a5 <gettoken+0x45>
    *q = s;
     9a3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     9a5:	0f b6 07             	movzbl (%edi),%eax
  switch (*s) {
     9a8:	3c 3c                	cmp    $0x3c,%al
     9aa:	0f 8f c8 00 00 00    	jg     a78 <gettoken+0x118>
     9b0:	3c 3a                	cmp    $0x3a,%al
     9b2:	7f 5a                	jg     a0e <gettoken+0xae>
     9b4:	84 c0                	test   %al,%al
     9b6:	75 48                	jne    a00 <gettoken+0xa0>
     9b8:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     9ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
     9bd:	85 c9                	test   %ecx,%ecx
     9bf:	74 05                	je     9c6 <gettoken+0x66>
    *eq = s;
     9c1:	8b 45 14             	mov    0x14(%ebp),%eax
     9c4:	89 38                	mov    %edi,(%eax)

  while (s < es && strchr(whitespace, *s))
     9c6:	39 df                	cmp    %ebx,%edi
     9c8:	72 0d                	jb     9d7 <gettoken+0x77>
     9ca:	eb 23                	jmp    9ef <gettoken+0x8f>
     9cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s++;
     9d0:	83 c7 01             	add    $0x1,%edi
  while (s < es && strchr(whitespace, *s))
     9d3:	39 fb                	cmp    %edi,%ebx
     9d5:	74 18                	je     9ef <gettoken+0x8f>
     9d7:	0f be 07             	movsbl (%edi),%eax
     9da:	83 ec 08             	sub    $0x8,%esp
     9dd:	50                   	push   %eax
     9de:	68 50 1f 00 00       	push   $0x1f50
     9e3:	e8 b8 07 00 00       	call   11a0 <strchr>
     9e8:	83 c4 10             	add    $0x10,%esp
     9eb:	85 c0                	test   %eax,%eax
     9ed:	75 e1                	jne    9d0 <gettoken+0x70>
  *ps = s;
     9ef:	8b 45 08             	mov    0x8(%ebp),%eax
     9f2:	89 38                	mov    %edi,(%eax)
  return ret;
}
     9f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9f7:	89 f0                	mov    %esi,%eax
     9f9:	5b                   	pop    %ebx
     9fa:	5e                   	pop    %esi
     9fb:	5f                   	pop    %edi
     9fc:	5d                   	pop    %ebp
     9fd:	c3                   	ret
     9fe:	66 90                	xchg   %ax,%ax
  switch (*s) {
     a00:	78 22                	js     a24 <gettoken+0xc4>
     a02:	3c 26                	cmp    $0x26,%al
     a04:	74 08                	je     a0e <gettoken+0xae>
     a06:	8d 48 d8             	lea    -0x28(%eax),%ecx
     a09:	80 f9 01             	cmp    $0x1,%cl
     a0c:	77 16                	ja     a24 <gettoken+0xc4>
  ret = *s;
     a0e:	0f be f0             	movsbl %al,%esi
    s++;
     a11:	83 c7 01             	add    $0x1,%edi
    break;
     a14:	eb a4                	jmp    9ba <gettoken+0x5a>
     a16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     a1d:	00 
     a1e:	66 90                	xchg   %ax,%ax
  switch (*s) {
     a20:	3c 7c                	cmp    $0x7c,%al
     a22:	74 ea                	je     a0e <gettoken+0xae>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     a24:	39 df                	cmp    %ebx,%edi
     a26:	72 27                	jb     a4f <gettoken+0xef>
     a28:	e9 87 00 00 00       	jmp    ab4 <gettoken+0x154>
     a2d:	8d 76 00             	lea    0x0(%esi),%esi
     a30:	0f be 07             	movsbl (%edi),%eax
     a33:	83 ec 08             	sub    $0x8,%esp
     a36:	50                   	push   %eax
     a37:	68 48 1f 00 00       	push   $0x1f48
     a3c:	e8 5f 07 00 00       	call   11a0 <strchr>
     a41:	83 c4 10             	add    $0x10,%esp
     a44:	85 c0                	test   %eax,%eax
     a46:	75 1f                	jne    a67 <gettoken+0x107>
      s++;
     a48:	83 c7 01             	add    $0x1,%edi
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     a4b:	39 fb                	cmp    %edi,%ebx
     a4d:	74 4d                	je     a9c <gettoken+0x13c>
     a4f:	0f be 07             	movsbl (%edi),%eax
     a52:	83 ec 08             	sub    $0x8,%esp
     a55:	50                   	push   %eax
     a56:	68 50 1f 00 00       	push   $0x1f50
     a5b:	e8 40 07 00 00       	call   11a0 <strchr>
     a60:	83 c4 10             	add    $0x10,%esp
     a63:	85 c0                	test   %eax,%eax
     a65:	74 c9                	je     a30 <gettoken+0xd0>
    ret = 'a';
     a67:	be 61 00 00 00       	mov    $0x61,%esi
     a6c:	e9 49 ff ff ff       	jmp    9ba <gettoken+0x5a>
     a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch (*s) {
     a78:	3c 3e                	cmp    $0x3e,%al
     a7a:	75 a4                	jne    a20 <gettoken+0xc0>
    if (*s == '>') {
     a7c:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
     a80:	74 0d                	je     a8f <gettoken+0x12f>
    s++;
     a82:	83 c7 01             	add    $0x1,%edi
  ret = *s;
     a85:	be 3e 00 00 00       	mov    $0x3e,%esi
     a8a:	e9 2b ff ff ff       	jmp    9ba <gettoken+0x5a>
      s++;
     a8f:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     a92:	be 2b 00 00 00       	mov    $0x2b,%esi
     a97:	e9 1e ff ff ff       	jmp    9ba <gettoken+0x5a>
  if (eq)
     a9c:	8b 45 14             	mov    0x14(%ebp),%eax
     a9f:	85 c0                	test   %eax,%eax
     aa1:	74 05                	je     aa8 <gettoken+0x148>
    *eq = s;
     aa3:	8b 45 14             	mov    0x14(%ebp),%eax
     aa6:	89 18                	mov    %ebx,(%eax)
  while (s < es && strchr(whitespace, *s))
     aa8:	89 df                	mov    %ebx,%edi
    ret = 'a';
     aaa:	be 61 00 00 00       	mov    $0x61,%esi
     aaf:	e9 3b ff ff ff       	jmp    9ef <gettoken+0x8f>
  if (eq)
     ab4:	8b 55 14             	mov    0x14(%ebp),%edx
     ab7:	85 d2                	test   %edx,%edx
     ab9:	74 ef                	je     aaa <gettoken+0x14a>
    *eq = s;
     abb:	8b 45 14             	mov    0x14(%ebp),%eax
     abe:	89 38                	mov    %edi,(%eax)
  while (s < es && strchr(whitespace, *s))
     ac0:	eb e8                	jmp    aaa <gettoken+0x14a>
     ac2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     ac9:	00 
     aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ad0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     ad0:	55                   	push   %ebp
     ad1:	89 e5                	mov    %esp,%ebp
     ad3:	57                   	push   %edi
     ad4:	56                   	push   %esi
     ad5:	53                   	push   %ebx
     ad6:	83 ec 0c             	sub    $0xc,%esp
     ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
     adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     adf:	8b 1f                	mov    (%edi),%ebx
  while (s < es && strchr(whitespace, *s))
     ae1:	39 f3                	cmp    %esi,%ebx
     ae3:	72 12                	jb     af7 <peek+0x27>
     ae5:	eb 28                	jmp    b0f <peek+0x3f>
     ae7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     aee:	00 
     aef:	90                   	nop
    s++;
     af0:	83 c3 01             	add    $0x1,%ebx
  while (s < es && strchr(whitespace, *s))
     af3:	39 de                	cmp    %ebx,%esi
     af5:	74 18                	je     b0f <peek+0x3f>
     af7:	0f be 03             	movsbl (%ebx),%eax
     afa:	83 ec 08             	sub    $0x8,%esp
     afd:	50                   	push   %eax
     afe:	68 50 1f 00 00       	push   $0x1f50
     b03:	e8 98 06 00 00       	call   11a0 <strchr>
     b08:	83 c4 10             	add    $0x10,%esp
     b0b:	85 c0                	test   %eax,%eax
     b0d:	75 e1                	jne    af0 <peek+0x20>
  *ps = s;
     b0f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     b11:	0f be 03             	movsbl (%ebx),%eax
     b14:	31 d2                	xor    %edx,%edx
     b16:	84 c0                	test   %al,%al
     b18:	75 0e                	jne    b28 <peek+0x58>
}
     b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b1d:	89 d0                	mov    %edx,%eax
     b1f:	5b                   	pop    %ebx
     b20:	5e                   	pop    %esi
     b21:	5f                   	pop    %edi
     b22:	5d                   	pop    %ebp
     b23:	c3                   	ret
     b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     b28:	83 ec 08             	sub    $0x8,%esp
     b2b:	50                   	push   %eax
     b2c:	ff 75 10             	push   0x10(%ebp)
     b2f:	e8 6c 06 00 00       	call   11a0 <strchr>
     b34:	83 c4 10             	add    $0x10,%esp
     b37:	31 d2                	xor    %edx,%edx
     b39:	85 c0                	test   %eax,%eax
     b3b:	0f 95 c2             	setne  %dl
}
     b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b41:	5b                   	pop    %ebx
     b42:	89 d0                	mov    %edx,%eax
     b44:	5e                   	pop    %esi
     b45:	5f                   	pop    %edi
     b46:	5d                   	pop    %ebp
     b47:	c3                   	ret
     b48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     b4f:	00 

00000b50 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	57                   	push   %edi
     b54:	56                   	push   %esi
     b55:	53                   	push   %ebx
     b56:	83 ec 2c             	sub    $0x2c,%esp
     b59:	8b 75 0c             	mov    0xc(%ebp),%esi
     b5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>")) {
     b5f:	90                   	nop
     b60:	83 ec 04             	sub    $0x4,%esp
     b63:	68 c4 17 00 00       	push   $0x17c4
     b68:	53                   	push   %ebx
     b69:	56                   	push   %esi
     b6a:	e8 61 ff ff ff       	call   ad0 <peek>
     b6f:	83 c4 10             	add    $0x10,%esp
     b72:	85 c0                	test   %eax,%eax
     b74:	0f 84 f6 00 00 00    	je     c70 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     b7a:	6a 00                	push   $0x0
     b7c:	6a 00                	push   $0x0
     b7e:	53                   	push   %ebx
     b7f:	56                   	push   %esi
     b80:	e8 db fd ff ff       	call   960 <gettoken>
     b85:	89 c7                	mov    %eax,%edi
    if (gettoken(ps, es, &q, &eq) != 'a')
     b87:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b8a:	50                   	push   %eax
     b8b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b8e:	50                   	push   %eax
     b8f:	53                   	push   %ebx
     b90:	56                   	push   %esi
     b91:	e8 ca fd ff ff       	call   960 <gettoken>
     b96:	83 c4 20             	add    $0x20,%esp
     b99:	83 f8 61             	cmp    $0x61,%eax
     b9c:	0f 85 d9 00 00 00    	jne    c7b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch (tok) {
     ba2:	83 ff 3c             	cmp    $0x3c,%edi
     ba5:	74 69                	je     c10 <parseredirs+0xc0>
     ba7:	83 ff 3e             	cmp    $0x3e,%edi
     baa:	74 05                	je     bb1 <parseredirs+0x61>
     bac:	83 ff 2b             	cmp    $0x2b,%edi
     baf:	75 af                	jne    b60 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     bb4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     bb7:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     bba:	89 55 d0             	mov    %edx,-0x30(%ebp)
     bbd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     bc0:	6a 18                	push   $0x18
     bc2:	e8 b9 0a 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     bc7:	83 c4 0c             	add    $0xc,%esp
     bca:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     bcc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     bce:	6a 00                	push   $0x0
     bd0:	50                   	push   %eax
     bd1:	e8 aa 05 00 00       	call   1180 <memset>
  cmd->type = REDIR;
     bd6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd  = subcmd;
     bdc:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     bdf:	83 c4 10             	add    $0x10,%esp
  cmd->cmd  = subcmd;
     be2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     be5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     be8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     beb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     bee:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     bf5:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd   = fd;
     bf8:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     bff:	89 7d 08             	mov    %edi,0x8(%ebp)
      break;
     c02:	e9 59 ff ff ff       	jmp    b60 <parseredirs+0x10>
     c07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c0e:	00 
     c0f:	90                   	nop
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     c13:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     c16:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c19:	89 55 d0             	mov    %edx,-0x30(%ebp)
     c1c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     c1f:	6a 18                	push   $0x18
     c21:	e8 5a 0a 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c26:	83 c4 0c             	add    $0xc,%esp
     c29:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     c2b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     c2d:	6a 00                	push   $0x0
     c2f:	50                   	push   %eax
     c30:	e8 4b 05 00 00       	call   1180 <memset>
  cmd->cmd  = subcmd;
     c35:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     c38:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     c3b:	83 c4 10             	add    $0x10,%esp
  cmd->efile = efile;
     c3e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     c41:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd  = subcmd;
     c47:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     c4a:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     c4d:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     c50:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd   = fd;
     c57:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c5e:	89 7d 08             	mov    %edi,0x8(%ebp)
      break;
     c61:	e9 fa fe ff ff       	jmp    b60 <parseredirs+0x10>
     c66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c6d:	00 
     c6e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     c70:	8b 45 08             	mov    0x8(%ebp),%eax
     c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c76:	5b                   	pop    %ebx
     c77:	5e                   	pop    %esi
     c78:	5f                   	pop    %edi
     c79:	5d                   	pop    %ebp
     c7a:	c3                   	ret
      panic("missing file for redirection");
     c7b:	83 ec 0c             	sub    $0xc,%esp
     c7e:	68 a7 17 00 00       	push   $0x17a7
     c83:	e8 d8 f9 ff ff       	call   660 <panic>
     c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     c8f:	00 

00000c90 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     c90:	55                   	push   %ebp
     c91:	89 e5                	mov    %esp,%ebp
     c93:	57                   	push   %edi
     c94:	56                   	push   %esi
     c95:	53                   	push   %ebx
     c96:	83 ec 30             	sub    $0x30,%esp
     c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     c9f:	68 c7 17 00 00       	push   $0x17c7
     ca4:	56                   	push   %esi
     ca5:	53                   	push   %ebx
     ca6:	e8 25 fe ff ff       	call   ad0 <peek>
     cab:	83 c4 10             	add    $0x10,%esp
     cae:	85 c0                	test   %eax,%eax
     cb0:	0f 85 aa 00 00 00    	jne    d60 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     cb6:	83 ec 0c             	sub    $0xc,%esp
     cb9:	89 c7                	mov    %eax,%edi
     cbb:	6a 54                	push   $0x54
     cbd:	e8 be 09 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     cc2:	83 c4 0c             	add    $0xc,%esp
     cc5:	6a 54                	push   $0x54
     cc7:	6a 00                	push   $0x0
     cc9:	89 45 d0             	mov    %eax,-0x30(%ebp)
     ccc:	50                   	push   %eax
     ccd:	e8 ae 04 00 00       	call   1180 <memset>
  cmd->type = EXEC;
     cd2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     cd5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     cd8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     cde:	56                   	push   %esi
     cdf:	53                   	push   %ebx
     ce0:	50                   	push   %eax
     ce1:	e8 6a fe ff ff       	call   b50 <parseredirs>
  while (!peek(ps, es, "|)&;")) {
     ce6:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     ce9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while (!peek(ps, es, "|)&;")) {
     cec:	eb 15                	jmp    d03 <parseexec+0x73>
     cee:	66 90                	xchg   %ax,%ax
    cmd->argv[argc]  = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     cf0:	83 ec 04             	sub    $0x4,%esp
     cf3:	56                   	push   %esi
     cf4:	53                   	push   %ebx
     cf5:	ff 75 d4             	push   -0x2c(%ebp)
     cf8:	e8 53 fe ff ff       	call   b50 <parseredirs>
     cfd:	83 c4 10             	add    $0x10,%esp
     d00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while (!peek(ps, es, "|)&;")) {
     d03:	83 ec 04             	sub    $0x4,%esp
     d06:	68 de 17 00 00       	push   $0x17de
     d0b:	56                   	push   %esi
     d0c:	53                   	push   %ebx
     d0d:	e8 be fd ff ff       	call   ad0 <peek>
     d12:	83 c4 10             	add    $0x10,%esp
     d15:	85 c0                	test   %eax,%eax
     d17:	75 5f                	jne    d78 <parseexec+0xe8>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     d19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     d1c:	50                   	push   %eax
     d1d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     d20:	50                   	push   %eax
     d21:	56                   	push   %esi
     d22:	53                   	push   %ebx
     d23:	e8 38 fc ff ff       	call   960 <gettoken>
     d28:	83 c4 10             	add    $0x10,%esp
     d2b:	85 c0                	test   %eax,%eax
     d2d:	74 49                	je     d78 <parseexec+0xe8>
    if (tok != 'a')
     d2f:	83 f8 61             	cmp    $0x61,%eax
     d32:	75 62                	jne    d96 <parseexec+0x106>
    cmd->argv[argc]  = q;
     d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d37:	8b 55 d0             	mov    -0x30(%ebp),%edx
     d3a:	89 44 ba 04          	mov    %eax,0x4(%edx,%edi,4)
    cmd->eargv[argc] = eq;
     d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d41:	89 44 ba 2c          	mov    %eax,0x2c(%edx,%edi,4)
    argc++;
     d45:	83 c7 01             	add    $0x1,%edi
    if (argc >= MAXARGS)
     d48:	83 ff 0a             	cmp    $0xa,%edi
     d4b:	75 a3                	jne    cf0 <parseexec+0x60>
      panic("too many args");
     d4d:	83 ec 0c             	sub    $0xc,%esp
     d50:	68 d0 17 00 00       	push   $0x17d0
     d55:	e8 06 f9 ff ff       	call   660 <panic>
     d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     d60:	89 75 0c             	mov    %esi,0xc(%ebp)
     d63:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
  cmd->argv[argc]  = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d69:	5b                   	pop    %ebx
     d6a:	5e                   	pop    %esi
     d6b:	5f                   	pop    %edi
     d6c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     d6d:	e9 ae 01 00 00       	jmp    f20 <parseblock>
     d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc]  = 0;
     d78:	8b 45 d0             	mov    -0x30(%ebp),%eax
     d7b:	c7 44 b8 04 00 00 00 	movl   $0x0,0x4(%eax,%edi,4)
     d82:	00 
  cmd->eargv[argc] = 0;
     d83:	c7 44 b8 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edi,4)
     d8a:	00 
}
     d8b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d91:	5b                   	pop    %ebx
     d92:	5e                   	pop    %esi
     d93:	5f                   	pop    %edi
     d94:	5d                   	pop    %ebp
     d95:	c3                   	ret
      panic("syntax");
     d96:	83 ec 0c             	sub    $0xc,%esp
     d99:	68 c9 17 00 00       	push   $0x17c9
     d9e:	e8 bd f8 ff ff       	call   660 <panic>
     da3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     daa:	00 
     dab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000db0 <parsepipe>:
{
     db0:	55                   	push   %ebp
     db1:	89 e5                	mov    %esp,%ebp
     db3:	57                   	push   %edi
     db4:	56                   	push   %esi
     db5:	53                   	push   %ebx
     db6:	83 ec 14             	sub    $0x14,%esp
     db9:	8b 75 08             	mov    0x8(%ebp),%esi
     dbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     dbf:	57                   	push   %edi
     dc0:	56                   	push   %esi
     dc1:	e8 ca fe ff ff       	call   c90 <parseexec>
  if (peek(ps, es, "|")) {
     dc6:	83 c4 0c             	add    $0xc,%esp
     dc9:	68 e3 17 00 00       	push   $0x17e3
  cmd = parseexec(ps, es);
     dce:	89 c3                	mov    %eax,%ebx
  if (peek(ps, es, "|")) {
     dd0:	57                   	push   %edi
     dd1:	56                   	push   %esi
     dd2:	e8 f9 fc ff ff       	call   ad0 <peek>
     dd7:	83 c4 10             	add    $0x10,%esp
     dda:	85 c0                	test   %eax,%eax
     ddc:	75 12                	jne    df0 <parsepipe+0x40>
}
     dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
     de1:	89 d8                	mov    %ebx,%eax
     de3:	5b                   	pop    %ebx
     de4:	5e                   	pop    %esi
     de5:	5f                   	pop    %edi
     de6:	5d                   	pop    %ebp
     de7:	c3                   	ret
     de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     def:	00 
    gettoken(ps, es, 0, 0);
     df0:	6a 00                	push   $0x0
     df2:	6a 00                	push   $0x0
     df4:	57                   	push   %edi
     df5:	56                   	push   %esi
     df6:	e8 65 fb ff ff       	call   960 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     dfb:	58                   	pop    %eax
     dfc:	5a                   	pop    %edx
     dfd:	57                   	push   %edi
     dfe:	56                   	push   %esi
     dff:	e8 ac ff ff ff       	call   db0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     e04:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     e0b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     e0d:	e8 6e 08 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     e12:	83 c4 0c             	add    $0xc,%esp
     e15:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     e17:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     e19:	6a 00                	push   $0x0
     e1b:	50                   	push   %eax
     e1c:	e8 5f 03 00 00       	call   1180 <memset>
  cmd->left  = left;
     e21:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     e24:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     e27:	89 f3                	mov    %esi,%ebx
  cmd->type  = PIPE;
     e29:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     e2f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     e31:	89 7e 08             	mov    %edi,0x8(%esi)
}
     e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e37:	5b                   	pop    %ebx
     e38:	5e                   	pop    %esi
     e39:	5f                   	pop    %edi
     e3a:	5d                   	pop    %ebp
     e3b:	c3                   	ret
     e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e40 <parseline>:
{
     e40:	55                   	push   %ebp
     e41:	89 e5                	mov    %esp,%ebp
     e43:	57                   	push   %edi
     e44:	56                   	push   %esi
     e45:	53                   	push   %ebx
     e46:	83 ec 24             	sub    $0x24,%esp
     e49:	8b 75 08             	mov    0x8(%ebp),%esi
     e4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     e4f:	57                   	push   %edi
     e50:	56                   	push   %esi
     e51:	e8 5a ff ff ff       	call   db0 <parsepipe>
  while (peek(ps, es, "&")) {
     e56:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     e59:	89 c3                	mov    %eax,%ebx
  while (peek(ps, es, "&")) {
     e5b:	eb 3b                	jmp    e98 <parseline+0x58>
     e5d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     e60:	6a 00                	push   $0x0
     e62:	6a 00                	push   $0x0
     e64:	57                   	push   %edi
     e65:	56                   	push   %esi
     e66:	e8 f5 fa ff ff       	call   960 <gettoken>
  cmd = malloc(sizeof(*cmd));
     e6b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     e72:	e8 09 08 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     e77:	83 c4 0c             	add    $0xc,%esp
     e7a:	6a 08                	push   $0x8
     e7c:	6a 00                	push   $0x0
     e7e:	50                   	push   %eax
     e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     e82:	e8 f9 02 00 00       	call   1180 <memset>
  cmd->type = BACK;
     e87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd  = subcmd;
     e8a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     e8d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd  = subcmd;
     e93:	89 5a 04             	mov    %ebx,0x4(%edx)
    cmd = backcmd(cmd);
     e96:	89 d3                	mov    %edx,%ebx
  while (peek(ps, es, "&")) {
     e98:	83 ec 04             	sub    $0x4,%esp
     e9b:	68 e5 17 00 00       	push   $0x17e5
     ea0:	57                   	push   %edi
     ea1:	56                   	push   %esi
     ea2:	e8 29 fc ff ff       	call   ad0 <peek>
     ea7:	83 c4 10             	add    $0x10,%esp
     eaa:	85 c0                	test   %eax,%eax
     eac:	75 b2                	jne    e60 <parseline+0x20>
  if (peek(ps, es, ";")) {
     eae:	83 ec 04             	sub    $0x4,%esp
     eb1:	68 e1 17 00 00       	push   $0x17e1
     eb6:	57                   	push   %edi
     eb7:	56                   	push   %esi
     eb8:	e8 13 fc ff ff       	call   ad0 <peek>
     ebd:	83 c4 10             	add    $0x10,%esp
     ec0:	85 c0                	test   %eax,%eax
     ec2:	75 0c                	jne    ed0 <parseline+0x90>
}
     ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ec7:	89 d8                	mov    %ebx,%eax
     ec9:	5b                   	pop    %ebx
     eca:	5e                   	pop    %esi
     ecb:	5f                   	pop    %edi
     ecc:	5d                   	pop    %ebp
     ecd:	c3                   	ret
     ece:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     ed0:	6a 00                	push   $0x0
     ed2:	6a 00                	push   $0x0
     ed4:	57                   	push   %edi
     ed5:	56                   	push   %esi
     ed6:	e8 85 fa ff ff       	call   960 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     edb:	58                   	pop    %eax
     edc:	5a                   	pop    %edx
     edd:	57                   	push   %edi
     ede:	56                   	push   %esi
     edf:	e8 5c ff ff ff       	call   e40 <parseline>
  cmd = malloc(sizeof(*cmd));
     ee4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     eeb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     eed:	e8 8e 07 00 00       	call   1680 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     ef2:	83 c4 0c             	add    $0xc,%esp
     ef5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     ef7:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     ef9:	6a 00                	push   $0x0
     efb:	50                   	push   %eax
     efc:	e8 7f 02 00 00       	call   1180 <memset>
  cmd->left  = left;
     f01:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     f04:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     f07:	89 f3                	mov    %esi,%ebx
  cmd->type  = LIST;
     f09:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     f0f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     f11:	89 7e 08             	mov    %edi,0x8(%esi)
}
     f14:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f17:	5b                   	pop    %ebx
     f18:	5e                   	pop    %esi
     f19:	5f                   	pop    %edi
     f1a:	5d                   	pop    %ebp
     f1b:	c3                   	ret
     f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f20 <parseblock>:
{
     f20:	55                   	push   %ebp
     f21:	89 e5                	mov    %esp,%ebp
     f23:	57                   	push   %edi
     f24:	56                   	push   %esi
     f25:	53                   	push   %ebx
     f26:	83 ec 10             	sub    $0x10,%esp
     f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
     f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (!peek(ps, es, "("))
     f2f:	68 c7 17 00 00       	push   $0x17c7
     f34:	56                   	push   %esi
     f35:	53                   	push   %ebx
     f36:	e8 95 fb ff ff       	call   ad0 <peek>
     f3b:	83 c4 10             	add    $0x10,%esp
     f3e:	85 c0                	test   %eax,%eax
     f40:	74 4a                	je     f8c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     f42:	6a 00                	push   $0x0
     f44:	6a 00                	push   $0x0
     f46:	56                   	push   %esi
     f47:	53                   	push   %ebx
     f48:	e8 13 fa ff ff       	call   960 <gettoken>
  cmd = parseline(ps, es);
     f4d:	58                   	pop    %eax
     f4e:	5a                   	pop    %edx
     f4f:	56                   	push   %esi
     f50:	53                   	push   %ebx
     f51:	e8 ea fe ff ff       	call   e40 <parseline>
  if (!peek(ps, es, ")"))
     f56:	83 c4 0c             	add    $0xc,%esp
     f59:	68 03 18 00 00       	push   $0x1803
  cmd = parseline(ps, es);
     f5e:	89 c7                	mov    %eax,%edi
  if (!peek(ps, es, ")"))
     f60:	56                   	push   %esi
     f61:	53                   	push   %ebx
     f62:	e8 69 fb ff ff       	call   ad0 <peek>
     f67:	83 c4 10             	add    $0x10,%esp
     f6a:	85 c0                	test   %eax,%eax
     f6c:	74 2b                	je     f99 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     f6e:	6a 00                	push   $0x0
     f70:	6a 00                	push   $0x0
     f72:	56                   	push   %esi
     f73:	53                   	push   %ebx
     f74:	e8 e7 f9 ff ff       	call   960 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     f79:	83 c4 0c             	add    $0xc,%esp
     f7c:	56                   	push   %esi
     f7d:	53                   	push   %ebx
     f7e:	57                   	push   %edi
     f7f:	e8 cc fb ff ff       	call   b50 <parseredirs>
}
     f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f87:	5b                   	pop    %ebx
     f88:	5e                   	pop    %esi
     f89:	5f                   	pop    %edi
     f8a:	5d                   	pop    %ebp
     f8b:	c3                   	ret
    panic("parseblock");
     f8c:	83 ec 0c             	sub    $0xc,%esp
     f8f:	68 e7 17 00 00       	push   $0x17e7
     f94:	e8 c7 f6 ff ff       	call   660 <panic>
    panic("syntax - missing )");
     f99:	83 ec 0c             	sub    $0xc,%esp
     f9c:	68 f2 17 00 00       	push   $0x17f2
     fa1:	e8 ba f6 ff ff       	call   660 <panic>
     fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
     fad:	00 
     fae:	66 90                	xchg   %ax,%ax

00000fb0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     fb0:	55                   	push   %ebp
     fb1:	89 e5                	mov    %esp,%ebp
     fb3:	53                   	push   %ebx
     fb4:	83 ec 04             	sub    $0x4,%esp
     fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     fba:	85 db                	test   %ebx,%ebx
     fbc:	74 29                	je     fe7 <nulterminate+0x37>
    return 0;

  switch (cmd->type) {
     fbe:	83 3b 05             	cmpl   $0x5,(%ebx)
     fc1:	77 24                	ja     fe7 <nulterminate+0x37>
     fc3:	8b 03                	mov    (%ebx),%eax
     fc5:	ff 24 85 4c 18 00 00 	jmp    *0x184c(,%eax,4)
     fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd *)cmd;
    nulterminate(lcmd->left);
     fd0:	83 ec 0c             	sub    $0xc,%esp
     fd3:	ff 73 04             	push   0x4(%ebx)
     fd6:	e8 d5 ff ff ff       	call   fb0 <nulterminate>
    nulterminate(lcmd->right);
     fdb:	58                   	pop    %eax
     fdc:	ff 73 08             	push   0x8(%ebx)
     fdf:	e8 cc ff ff ff       	call   fb0 <nulterminate>
    break;
     fe4:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     fe7:	89 d8                	mov    %ebx,%eax
     fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     fec:	c9                   	leave
     fed:	c3                   	ret
     fee:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     ff0:	83 ec 0c             	sub    $0xc,%esp
     ff3:	ff 73 04             	push   0x4(%ebx)
     ff6:	e8 b5 ff ff ff       	call   fb0 <nulterminate>
}
     ffb:	89 d8                	mov    %ebx,%eax
    break;
     ffd:	83 c4 10             	add    $0x10,%esp
}
    1000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1003:	c9                   	leave
    1004:	c3                   	ret
    1005:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; ecmd->argv[i]; i++)
    1008:	8b 4b 04             	mov    0x4(%ebx),%ecx
    100b:	85 c9                	test   %ecx,%ecx
    100d:	74 d8                	je     fe7 <nulterminate+0x37>
    100f:	8d 43 08             	lea    0x8(%ebx),%eax
    1012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
    1018:	8b 50 24             	mov    0x24(%eax),%edx
    for (i = 0; ecmd->argv[i]; i++)
    101b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
    101e:	c6 02 00             	movb   $0x0,(%edx)
    for (i = 0; ecmd->argv[i]; i++)
    1021:	8b 50 fc             	mov    -0x4(%eax),%edx
    1024:	85 d2                	test   %edx,%edx
    1026:	75 f0                	jne    1018 <nulterminate+0x68>
}
    1028:	89 d8                	mov    %ebx,%eax
    102a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    102d:	c9                   	leave
    102e:	c3                   	ret
    102f:	90                   	nop
    nulterminate(rcmd->cmd);
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	ff 73 04             	push   0x4(%ebx)
    1036:	e8 75 ff ff ff       	call   fb0 <nulterminate>
    *rcmd->efile = 0;
    103b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
    103e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
    1041:	c6 00 00             	movb   $0x0,(%eax)
}
    1044:	89 d8                	mov    %ebx,%eax
    1046:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1049:	c9                   	leave
    104a:	c3                   	ret
    104b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00001050 <parsecmd>:
{
    1050:	55                   	push   %ebp
    1051:	89 e5                	mov    %esp,%ebp
    1053:	57                   	push   %edi
    1054:	56                   	push   %esi
  cmd = parseline(&s, es);
    1055:	8d 7d 08             	lea    0x8(%ebp),%edi
{
    1058:	53                   	push   %ebx
    1059:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
    105c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    105f:	53                   	push   %ebx
    1060:	e8 eb 00 00 00       	call   1150 <strlen>
  cmd = parseline(&s, es);
    1065:	59                   	pop    %ecx
    1066:	5e                   	pop    %esi
  es = s + strlen(s);
    1067:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
    1069:	53                   	push   %ebx
    106a:	57                   	push   %edi
    106b:	e8 d0 fd ff ff       	call   e40 <parseline>
  peek(&s, es, "");
    1070:	83 c4 0c             	add    $0xc,%esp
    1073:	68 6b 17 00 00       	push   $0x176b
  cmd = parseline(&s, es);
    1078:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
    107a:	53                   	push   %ebx
    107b:	57                   	push   %edi
    107c:	e8 4f fa ff ff       	call   ad0 <peek>
  if (s != es) {
    1081:	8b 45 08             	mov    0x8(%ebp),%eax
    1084:	83 c4 10             	add    $0x10,%esp
    1087:	39 d8                	cmp    %ebx,%eax
    1089:	75 13                	jne    109e <parsecmd+0x4e>
  nulterminate(cmd);
    108b:	83 ec 0c             	sub    $0xc,%esp
    108e:	56                   	push   %esi
    108f:	e8 1c ff ff ff       	call   fb0 <nulterminate>
}
    1094:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1097:	89 f0                	mov    %esi,%eax
    1099:	5b                   	pop    %ebx
    109a:	5e                   	pop    %esi
    109b:	5f                   	pop    %edi
    109c:	5d                   	pop    %ebp
    109d:	c3                   	ret
    printf(2, "leftovers: %s\n", s);
    109e:	52                   	push   %edx
    109f:	50                   	push   %eax
    10a0:	68 05 18 00 00       	push   $0x1805
    10a5:	6a 02                	push   $0x2
    10a7:	e8 b4 03 00 00       	call   1460 <printf>
    panic("syntax");
    10ac:	c7 04 24 c9 17 00 00 	movl   $0x17c9,(%esp)
    10b3:	e8 a8 f5 ff ff       	call   660 <panic>
    10b8:	66 90                	xchg   %ax,%ax
    10ba:	66 90                	xchg   %ax,%ax
    10bc:	66 90                	xchg   %ax,%ax
    10be:	66 90                	xchg   %ax,%ax

000010c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    10c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10c1:	31 c0                	xor    %eax,%eax
{
    10c3:	89 e5                	mov    %esp,%ebp
    10c5:	53                   	push   %ebx
    10c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    10cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    10d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    10d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    10d7:	83 c0 01             	add    $0x1,%eax
    10da:	84 d2                	test   %dl,%dl
    10dc:	75 f2                	jne    10d0 <strcpy+0x10>
    ;
  return os;
}
    10de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10e1:	89 c8                	mov    %ecx,%eax
    10e3:	c9                   	leave
    10e4:	c3                   	ret
    10e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    10ec:	00 
    10ed:	8d 76 00             	lea    0x0(%esi),%esi

000010f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10f0:	55                   	push   %ebp
    10f1:	89 e5                	mov    %esp,%ebp
    10f3:	53                   	push   %ebx
    10f4:	8b 55 08             	mov    0x8(%ebp),%edx
    10f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    10fa:	0f b6 02             	movzbl (%edx),%eax
    10fd:	84 c0                	test   %al,%al
    10ff:	75 17                	jne    1118 <strcmp+0x28>
    1101:	eb 3a                	jmp    113d <strcmp+0x4d>
    1103:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1108:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    110c:	83 c2 01             	add    $0x1,%edx
    110f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1112:	84 c0                	test   %al,%al
    1114:	74 1a                	je     1130 <strcmp+0x40>
    1116:	89 d9                	mov    %ebx,%ecx
    1118:	0f b6 19             	movzbl (%ecx),%ebx
    111b:	38 c3                	cmp    %al,%bl
    111d:	74 e9                	je     1108 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    111f:	29 d8                	sub    %ebx,%eax
}
    1121:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1124:	c9                   	leave
    1125:	c3                   	ret
    1126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    112d:	00 
    112e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
    1130:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1134:	31 c0                	xor    %eax,%eax
    1136:	29 d8                	sub    %ebx,%eax
}
    1138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    113b:	c9                   	leave
    113c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
    113d:	0f b6 19             	movzbl (%ecx),%ebx
    1140:	31 c0                	xor    %eax,%eax
    1142:	eb db                	jmp    111f <strcmp+0x2f>
    1144:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    114b:	00 
    114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001150 <strlen>:

uint
strlen(const char *s)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1156:	80 3a 00             	cmpb   $0x0,(%edx)
    1159:	74 15                	je     1170 <strlen+0x20>
    115b:	31 c0                	xor    %eax,%eax
    115d:	8d 76 00             	lea    0x0(%esi),%esi
    1160:	83 c0 01             	add    $0x1,%eax
    1163:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    1167:	89 c1                	mov    %eax,%ecx
    1169:	75 f5                	jne    1160 <strlen+0x10>
    ;
  return n;
}
    116b:	89 c8                	mov    %ecx,%eax
    116d:	5d                   	pop    %ebp
    116e:	c3                   	ret
    116f:	90                   	nop
  for(n = 0; s[n]; n++)
    1170:	31 c9                	xor    %ecx,%ecx
}
    1172:	5d                   	pop    %ebp
    1173:	89 c8                	mov    %ecx,%eax
    1175:	c3                   	ret
    1176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    117d:	00 
    117e:	66 90                	xchg   %ax,%ax

00001180 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	57                   	push   %edi
    1184:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1187:	8b 4d 10             	mov    0x10(%ebp),%ecx
    118a:	8b 45 0c             	mov    0xc(%ebp),%eax
    118d:	89 d7                	mov    %edx,%edi
    118f:	fc                   	cld
    1190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1192:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1195:	89 d0                	mov    %edx,%eax
    1197:	c9                   	leave
    1198:	c3                   	ret
    1199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000011a0 <strchr>:

char*
strchr(const char *s, char c)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	8b 45 08             	mov    0x8(%ebp),%eax
    11a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    11aa:	0f b6 10             	movzbl (%eax),%edx
    11ad:	84 d2                	test   %dl,%dl
    11af:	75 12                	jne    11c3 <strchr+0x23>
    11b1:	eb 1d                	jmp    11d0 <strchr+0x30>
    11b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    11b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    11bc:	83 c0 01             	add    $0x1,%eax
    11bf:	84 d2                	test   %dl,%dl
    11c1:	74 0d                	je     11d0 <strchr+0x30>
    if(*s == c)
    11c3:	38 d1                	cmp    %dl,%cl
    11c5:	75 f1                	jne    11b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
    11c7:	5d                   	pop    %ebp
    11c8:	c3                   	ret
    11c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    11d0:	31 c0                	xor    %eax,%eax
}
    11d2:	5d                   	pop    %ebp
    11d3:	c3                   	ret
    11d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    11db:	00 
    11dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011e0 <gets>:

char*
gets(char *buf, int max)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	57                   	push   %edi
    11e4:	56                   	push   %esi
  int i, cc;
  char c;
  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    11e5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    11e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    11e9:	31 db                	xor    %ebx,%ebx
    11eb:	8d 73 01             	lea    0x1(%ebx),%esi
{
    11ee:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    11f1:	3b 75 0c             	cmp    0xc(%ebp),%esi
    11f4:	7d 3b                	jge    1231 <gets+0x51>
    11f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    11fd:	00 
    11fe:	66 90                	xchg   %ax,%ax
    cc = read(0, &c, 1);
    1200:	83 ec 04             	sub    $0x4,%esp
    1203:	6a 01                	push   $0x1
    1205:	57                   	push   %edi
    1206:	6a 00                	push   $0x0
    1208:	e8 1e 01 00 00       	call   132b <read>
    if(cc < 1)
    120d:	83 c4 10             	add    $0x10,%esp
    1210:	85 c0                	test   %eax,%eax
    1212:	7e 1d                	jle    1231 <gets+0x51>
      break;
    buf[i++] = c;
    1214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1218:	8b 55 08             	mov    0x8(%ebp),%edx
    121b:	88 44 32 ff          	mov    %al,-0x1(%edx,%esi,1)
    if(c == '\n' || c == '\r' || c=='\t')
    121f:	3c 0a                	cmp    $0xa,%al
    1221:	7f 25                	jg     1248 <gets+0x68>
    1223:	3c 08                	cmp    $0x8,%al
    1225:	7f 0c                	jg     1233 <gets+0x53>
{
    1227:	89 f3                	mov    %esi,%ebx
  for(i=0; i+1 < max; ){
    1229:	8d 73 01             	lea    0x1(%ebx),%esi
    122c:	3b 75 0c             	cmp    0xc(%ebp),%esi
    122f:	7c cf                	jl     1200 <gets+0x20>
    1231:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    123d:	5b                   	pop    %ebx
    123e:	5e                   	pop    %esi
    123f:	5f                   	pop    %edi
    1240:	5d                   	pop    %ebp
    1241:	c3                   	ret
    1242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1248:	3c 0d                	cmp    $0xd,%al
    124a:	74 e7                	je     1233 <gets+0x53>
{
    124c:	89 f3                	mov    %esi,%ebx
    124e:	eb d9                	jmp    1229 <gets+0x49>

00001250 <stat>:

int
stat(const char *n, struct stat *st)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	56                   	push   %esi
    1254:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1255:	83 ec 08             	sub    $0x8,%esp
    1258:	6a 00                	push   $0x0
    125a:	ff 75 08             	push   0x8(%ebp)
    125d:	e8 f1 00 00 00       	call   1353 <open>
  if(fd < 0)
    1262:	83 c4 10             	add    $0x10,%esp
    1265:	85 c0                	test   %eax,%eax
    1267:	78 27                	js     1290 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1269:	83 ec 08             	sub    $0x8,%esp
    126c:	ff 75 0c             	push   0xc(%ebp)
    126f:	89 c3                	mov    %eax,%ebx
    1271:	50                   	push   %eax
    1272:	e8 f4 00 00 00       	call   136b <fstat>
  close(fd);
    1277:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    127a:	89 c6                	mov    %eax,%esi
  close(fd);
    127c:	e8 ba 00 00 00       	call   133b <close>
  return r;
    1281:	83 c4 10             	add    $0x10,%esp
}
    1284:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1287:	89 f0                	mov    %esi,%eax
    1289:	5b                   	pop    %ebx
    128a:	5e                   	pop    %esi
    128b:	5d                   	pop    %ebp
    128c:	c3                   	ret
    128d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1290:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1295:	eb ed                	jmp    1284 <stat+0x34>
    1297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    129e:	00 
    129f:	90                   	nop

000012a0 <atoi>:

int
atoi(const char *s)
{
    12a0:	55                   	push   %ebp
    12a1:	89 e5                	mov    %esp,%ebp
    12a3:	53                   	push   %ebx
    12a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12a7:	0f be 02             	movsbl (%edx),%eax
    12aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
    12ad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    12b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    12b5:	77 1e                	ja     12d5 <atoi+0x35>
    12b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    12be:	00 
    12bf:	90                   	nop
    n = n*10 + *s++ - '0';
    12c0:	83 c2 01             	add    $0x1,%edx
    12c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    12c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    12ca:	0f be 02             	movsbl (%edx),%eax
    12cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
    12d0:	80 fb 09             	cmp    $0x9,%bl
    12d3:	76 eb                	jbe    12c0 <atoi+0x20>
  return n;
}
    12d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    12d8:	89 c8                	mov    %ecx,%eax
    12da:	c9                   	leave
    12db:	c3                   	ret
    12dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000012e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12e0:	55                   	push   %ebp
    12e1:	89 e5                	mov    %esp,%ebp
    12e3:	57                   	push   %edi
    12e4:	8b 45 10             	mov    0x10(%ebp),%eax
    12e7:	8b 55 08             	mov    0x8(%ebp),%edx
    12ea:	56                   	push   %esi
    12eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12ee:	85 c0                	test   %eax,%eax
    12f0:	7e 13                	jle    1305 <memmove+0x25>
    12f2:	01 d0                	add    %edx,%eax
  dst = vdst;
    12f4:	89 d7                	mov    %edx,%edi
    12f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    12fd:	00 
    12fe:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
    1300:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1301:	39 f8                	cmp    %edi,%eax
    1303:	75 fb                	jne    1300 <memmove+0x20>
  return vdst;
}
    1305:	5e                   	pop    %esi
    1306:	89 d0                	mov    %edx,%eax
    1308:	5f                   	pop    %edi
    1309:	5d                   	pop    %ebp
    130a:	c3                   	ret

0000130b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    130b:	b8 01 00 00 00       	mov    $0x1,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret

00001313 <exit>:
SYSCALL(exit)
    1313:	b8 02 00 00 00       	mov    $0x2,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret

0000131b <wait>:
SYSCALL(wait)
    131b:	b8 03 00 00 00       	mov    $0x3,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret

00001323 <pipe>:
SYSCALL(pipe)
    1323:	b8 04 00 00 00       	mov    $0x4,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret

0000132b <read>:
SYSCALL(read)
    132b:	b8 05 00 00 00       	mov    $0x5,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret

00001333 <write>:
SYSCALL(write)
    1333:	b8 10 00 00 00       	mov    $0x10,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret

0000133b <close>:
SYSCALL(close)
    133b:	b8 15 00 00 00       	mov    $0x15,%eax
    1340:	cd 40                	int    $0x40
    1342:	c3                   	ret

00001343 <kill>:
SYSCALL(kill)
    1343:	b8 06 00 00 00       	mov    $0x6,%eax
    1348:	cd 40                	int    $0x40
    134a:	c3                   	ret

0000134b <exec>:
SYSCALL(exec)
    134b:	b8 07 00 00 00       	mov    $0x7,%eax
    1350:	cd 40                	int    $0x40
    1352:	c3                   	ret

00001353 <open>:
SYSCALL(open)
    1353:	b8 0f 00 00 00       	mov    $0xf,%eax
    1358:	cd 40                	int    $0x40
    135a:	c3                   	ret

0000135b <mknod>:
SYSCALL(mknod)
    135b:	b8 11 00 00 00       	mov    $0x11,%eax
    1360:	cd 40                	int    $0x40
    1362:	c3                   	ret

00001363 <unlink>:
SYSCALL(unlink)
    1363:	b8 12 00 00 00       	mov    $0x12,%eax
    1368:	cd 40                	int    $0x40
    136a:	c3                   	ret

0000136b <fstat>:
SYSCALL(fstat)
    136b:	b8 08 00 00 00       	mov    $0x8,%eax
    1370:	cd 40                	int    $0x40
    1372:	c3                   	ret

00001373 <link>:
SYSCALL(link)
    1373:	b8 13 00 00 00       	mov    $0x13,%eax
    1378:	cd 40                	int    $0x40
    137a:	c3                   	ret

0000137b <mkdir>:
SYSCALL(mkdir)
    137b:	b8 14 00 00 00       	mov    $0x14,%eax
    1380:	cd 40                	int    $0x40
    1382:	c3                   	ret

00001383 <chdir>:
SYSCALL(chdir)
    1383:	b8 09 00 00 00       	mov    $0x9,%eax
    1388:	cd 40                	int    $0x40
    138a:	c3                   	ret

0000138b <dup>:
SYSCALL(dup)
    138b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1390:	cd 40                	int    $0x40
    1392:	c3                   	ret

00001393 <getpid>:
SYSCALL(getpid)
    1393:	b8 0b 00 00 00       	mov    $0xb,%eax
    1398:	cd 40                	int    $0x40
    139a:	c3                   	ret

0000139b <sbrk>:
SYSCALL(sbrk)
    139b:	b8 0c 00 00 00       	mov    $0xc,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret

000013a3 <sleep>:
SYSCALL(sleep)
    13a3:	b8 0d 00 00 00       	mov    $0xd,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret

000013ab <uptime>:
SYSCALL(uptime)
    13ab:	b8 0e 00 00 00       	mov    $0xe,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret
    13b3:	66 90                	xchg   %ax,%ax
    13b5:	66 90                	xchg   %ax,%ax
    13b7:	66 90                	xchg   %ax,%ax
    13b9:	66 90                	xchg   %ax,%ax
    13bb:	66 90                	xchg   %ax,%ax
    13bd:	66 90                	xchg   %ax,%ax
    13bf:	90                   	nop

000013c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    13c0:	55                   	push   %ebp
    13c1:	89 e5                	mov    %esp,%ebp
    13c3:	57                   	push   %edi
    13c4:	56                   	push   %esi
    13c5:	53                   	push   %ebx
    13c6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    13c8:	89 d1                	mov    %edx,%ecx
{
    13ca:	83 ec 3c             	sub    $0x3c,%esp
    13cd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
    13d0:	85 d2                	test   %edx,%edx
    13d2:	0f 89 80 00 00 00    	jns    1458 <printint+0x98>
    13d8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    13dc:	74 7a                	je     1458 <printint+0x98>
    x = -xx;
    13de:	f7 d9                	neg    %ecx
    neg = 1;
    13e0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
    13e5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    13e8:	31 f6                	xor    %esi,%esi
    13ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    13f0:	89 c8                	mov    %ecx,%eax
    13f2:	31 d2                	xor    %edx,%edx
    13f4:	89 f7                	mov    %esi,%edi
    13f6:	f7 f3                	div    %ebx
    13f8:	8d 76 01             	lea    0x1(%esi),%esi
    13fb:	0f b6 92 bc 18 00 00 	movzbl 0x18bc(%edx),%edx
    1402:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
    1406:	89 ca                	mov    %ecx,%edx
    1408:	89 c1                	mov    %eax,%ecx
    140a:	39 da                	cmp    %ebx,%edx
    140c:	73 e2                	jae    13f0 <printint+0x30>
  if(neg)
    140e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    1411:	85 c0                	test   %eax,%eax
    1413:	74 07                	je     141c <printint+0x5c>
    buf[i++] = '-';
    1415:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
    141a:	89 f7                	mov    %esi,%edi
    141c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
    141f:	8b 75 c0             	mov    -0x40(%ebp),%esi
    1422:	01 df                	add    %ebx,%edi
    1424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
    1428:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
    142b:	83 ec 04             	sub    $0x4,%esp
    142e:	88 45 d7             	mov    %al,-0x29(%ebp)
    1431:	8d 45 d7             	lea    -0x29(%ebp),%eax
    1434:	6a 01                	push   $0x1
    1436:	50                   	push   %eax
    1437:	56                   	push   %esi
    1438:	e8 f6 fe ff ff       	call   1333 <write>
  while(--i >= 0)
    143d:	89 f8                	mov    %edi,%eax
    143f:	83 c4 10             	add    $0x10,%esp
    1442:	83 ef 01             	sub    $0x1,%edi
    1445:	39 c3                	cmp    %eax,%ebx
    1447:	75 df                	jne    1428 <printint+0x68>
}
    1449:	8d 65 f4             	lea    -0xc(%ebp),%esp
    144c:	5b                   	pop    %ebx
    144d:	5e                   	pop    %esi
    144e:	5f                   	pop    %edi
    144f:	5d                   	pop    %ebp
    1450:	c3                   	ret
    1451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1458:	31 c0                	xor    %eax,%eax
    145a:	eb 89                	jmp    13e5 <printint+0x25>
    145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001460 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1460:	55                   	push   %ebp
    1461:	89 e5                	mov    %esp,%ebp
    1463:	57                   	push   %edi
    1464:	56                   	push   %esi
    1465:	53                   	push   %ebx
    1466:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1469:	8b 75 0c             	mov    0xc(%ebp),%esi
{
    146c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
    146f:	0f b6 1e             	movzbl (%esi),%ebx
    1472:	83 c6 01             	add    $0x1,%esi
    1475:	84 db                	test   %bl,%bl
    1477:	74 67                	je     14e0 <printf+0x80>
    1479:	8d 4d 10             	lea    0x10(%ebp),%ecx
    147c:	31 d2                	xor    %edx,%edx
    147e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    1481:	eb 34                	jmp    14b7 <printf+0x57>
    1483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    1488:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    148b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1490:	83 f8 25             	cmp    $0x25,%eax
    1493:	74 18                	je     14ad <printf+0x4d>
  write(fd, &c, 1);
    1495:	83 ec 04             	sub    $0x4,%esp
    1498:	8d 45 e7             	lea    -0x19(%ebp),%eax
    149b:	88 5d e7             	mov    %bl,-0x19(%ebp)
    149e:	6a 01                	push   $0x1
    14a0:	50                   	push   %eax
    14a1:	57                   	push   %edi
    14a2:	e8 8c fe ff ff       	call   1333 <write>
    14a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    14aa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    14ad:	0f b6 1e             	movzbl (%esi),%ebx
    14b0:	83 c6 01             	add    $0x1,%esi
    14b3:	84 db                	test   %bl,%bl
    14b5:	74 29                	je     14e0 <printf+0x80>
    c = fmt[i] & 0xff;
    14b7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    14ba:	85 d2                	test   %edx,%edx
    14bc:	74 ca                	je     1488 <printf+0x28>
      }
    } else if(state == '%'){
    14be:	83 fa 25             	cmp    $0x25,%edx
    14c1:	75 ea                	jne    14ad <printf+0x4d>
      if(c == 'd'){
    14c3:	83 f8 25             	cmp    $0x25,%eax
    14c6:	0f 84 04 01 00 00    	je     15d0 <printf+0x170>
    14cc:	83 e8 63             	sub    $0x63,%eax
    14cf:	83 f8 15             	cmp    $0x15,%eax
    14d2:	77 1c                	ja     14f0 <printf+0x90>
    14d4:	ff 24 85 64 18 00 00 	jmp    *0x1864(,%eax,4)
    14db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    14e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14e3:	5b                   	pop    %ebx
    14e4:	5e                   	pop    %esi
    14e5:	5f                   	pop    %edi
    14e6:	5d                   	pop    %ebp
    14e7:	c3                   	ret
    14e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    14ef:	00 
  write(fd, &c, 1);
    14f0:	83 ec 04             	sub    $0x4,%esp
    14f3:	8d 55 e7             	lea    -0x19(%ebp),%edx
    14f6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    14fa:	6a 01                	push   $0x1
    14fc:	52                   	push   %edx
    14fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1500:	57                   	push   %edi
    1501:	e8 2d fe ff ff       	call   1333 <write>
    1506:	83 c4 0c             	add    $0xc,%esp
    1509:	88 5d e7             	mov    %bl,-0x19(%ebp)
    150c:	6a 01                	push   $0x1
    150e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    1511:	52                   	push   %edx
    1512:	57                   	push   %edi
    1513:	e8 1b fe ff ff       	call   1333 <write>
        putc(fd, c);
    1518:	83 c4 10             	add    $0x10,%esp
      state = 0;
    151b:	31 d2                	xor    %edx,%edx
    151d:	eb 8e                	jmp    14ad <printf+0x4d>
    151f:	90                   	nop
        printint(fd, *ap, 16, 0);
    1520:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1523:	83 ec 0c             	sub    $0xc,%esp
    1526:	b9 10 00 00 00       	mov    $0x10,%ecx
    152b:	8b 13                	mov    (%ebx),%edx
    152d:	6a 00                	push   $0x0
    152f:	89 f8                	mov    %edi,%eax
        ap++;
    1531:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
    1534:	e8 87 fe ff ff       	call   13c0 <printint>
        ap++;
    1539:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    153c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    153f:	31 d2                	xor    %edx,%edx
    1541:	e9 67 ff ff ff       	jmp    14ad <printf+0x4d>
        s = (char*)*ap;
    1546:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1549:	8b 18                	mov    (%eax),%ebx
        ap++;
    154b:	83 c0 04             	add    $0x4,%eax
    154e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1551:	85 db                	test   %ebx,%ebx
    1553:	0f 84 87 00 00 00    	je     15e0 <printf+0x180>
        while(*s != 0){
    1559:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    155c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    155e:	84 c0                	test   %al,%al
    1560:	0f 84 47 ff ff ff    	je     14ad <printf+0x4d>
    1566:	8d 55 e7             	lea    -0x19(%ebp),%edx
    1569:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    156c:	89 de                	mov    %ebx,%esi
    156e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
    1570:	83 ec 04             	sub    $0x4,%esp
    1573:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
    1576:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1579:	6a 01                	push   $0x1
    157b:	53                   	push   %ebx
    157c:	57                   	push   %edi
    157d:	e8 b1 fd ff ff       	call   1333 <write>
        while(*s != 0){
    1582:	0f b6 06             	movzbl (%esi),%eax
    1585:	83 c4 10             	add    $0x10,%esp
    1588:	84 c0                	test   %al,%al
    158a:	75 e4                	jne    1570 <printf+0x110>
      state = 0;
    158c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    158f:	31 d2                	xor    %edx,%edx
    1591:	e9 17 ff ff ff       	jmp    14ad <printf+0x4d>
        printint(fd, *ap, 10, 1);
    1596:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1599:	83 ec 0c             	sub    $0xc,%esp
    159c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    15a1:	8b 13                	mov    (%ebx),%edx
    15a3:	6a 01                	push   $0x1
    15a5:	eb 88                	jmp    152f <printf+0xcf>
        putc(fd, *ap);
    15a7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    15aa:	83 ec 04             	sub    $0x4,%esp
    15ad:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
    15b0:	8b 03                	mov    (%ebx),%eax
        ap++;
    15b2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
    15b5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    15b8:	6a 01                	push   $0x1
    15ba:	52                   	push   %edx
    15bb:	57                   	push   %edi
    15bc:	e8 72 fd ff ff       	call   1333 <write>
        ap++;
    15c1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    15c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
    15c7:	31 d2                	xor    %edx,%edx
    15c9:	e9 df fe ff ff       	jmp    14ad <printf+0x4d>
    15ce:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
    15d0:	83 ec 04             	sub    $0x4,%esp
    15d3:	88 5d e7             	mov    %bl,-0x19(%ebp)
    15d6:	8d 55 e7             	lea    -0x19(%ebp),%edx
    15d9:	6a 01                	push   $0x1
    15db:	e9 31 ff ff ff       	jmp    1511 <printf+0xb1>
    15e0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
    15e5:	bb 2a 18 00 00       	mov    $0x182a,%ebx
    15ea:	e9 77 ff ff ff       	jmp    1566 <printf+0x106>
    15ef:	90                   	nop

000015f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15f1:	a1 e4 1f 00 00       	mov    0x1fe4,%eax
{
    15f6:	89 e5                	mov    %esp,%ebp
    15f8:	57                   	push   %edi
    15f9:	56                   	push   %esi
    15fa:	53                   	push   %ebx
    15fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    15fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1608:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    160a:	39 c8                	cmp    %ecx,%eax
    160c:	73 32                	jae    1640 <free+0x50>
    160e:	39 d1                	cmp    %edx,%ecx
    1610:	72 04                	jb     1616 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1612:	39 d0                	cmp    %edx,%eax
    1614:	72 32                	jb     1648 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1616:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1619:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    161c:	39 fa                	cmp    %edi,%edx
    161e:	74 30                	je     1650 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1620:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1623:	8b 50 04             	mov    0x4(%eax),%edx
    1626:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1629:	39 f1                	cmp    %esi,%ecx
    162b:	74 3a                	je     1667 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    162d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    162f:	5b                   	pop    %ebx
  freep = p;
    1630:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
}
    1635:	5e                   	pop    %esi
    1636:	5f                   	pop    %edi
    1637:	5d                   	pop    %ebp
    1638:	c3                   	ret
    1639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1640:	39 d0                	cmp    %edx,%eax
    1642:	72 04                	jb     1648 <free+0x58>
    1644:	39 d1                	cmp    %edx,%ecx
    1646:	72 ce                	jb     1616 <free+0x26>
{
    1648:	89 d0                	mov    %edx,%eax
    164a:	eb bc                	jmp    1608 <free+0x18>
    164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1650:	03 72 04             	add    0x4(%edx),%esi
    1653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1656:	8b 10                	mov    (%eax),%edx
    1658:	8b 12                	mov    (%edx),%edx
    165a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    165d:	8b 50 04             	mov    0x4(%eax),%edx
    1660:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1663:	39 f1                	cmp    %esi,%ecx
    1665:	75 c6                	jne    162d <free+0x3d>
    p->s.size += bp->s.size;
    1667:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    166a:	a3 e4 1f 00 00       	mov    %eax,0x1fe4
    p->s.size += bp->s.size;
    166f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1672:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1675:	89 08                	mov    %ecx,(%eax)
}
    1677:	5b                   	pop    %ebx
    1678:	5e                   	pop    %esi
    1679:	5f                   	pop    %edi
    167a:	5d                   	pop    %ebp
    167b:	c3                   	ret
    167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1680:	55                   	push   %ebp
    1681:	89 e5                	mov    %esp,%ebp
    1683:	57                   	push   %edi
    1684:	56                   	push   %esi
    1685:	53                   	push   %ebx
    1686:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    168c:	8b 15 e4 1f 00 00    	mov    0x1fe4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1692:	8d 78 07             	lea    0x7(%eax),%edi
    1695:	c1 ef 03             	shr    $0x3,%edi
    1698:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    169b:	85 d2                	test   %edx,%edx
    169d:	0f 84 8d 00 00 00    	je     1730 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16a3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16a5:	8b 48 04             	mov    0x4(%eax),%ecx
    16a8:	39 f9                	cmp    %edi,%ecx
    16aa:	73 64                	jae    1710 <malloc+0x90>
  if(nu < 4096)
    16ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
    16b1:	39 df                	cmp    %ebx,%edi
    16b3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    16b6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    16bd:	eb 0a                	jmp    16c9 <malloc+0x49>
    16bf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16c2:	8b 48 04             	mov    0x4(%eax),%ecx
    16c5:	39 f9                	cmp    %edi,%ecx
    16c7:	73 47                	jae    1710 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16c9:	89 c2                	mov    %eax,%edx
    16cb:	3b 05 e4 1f 00 00    	cmp    0x1fe4,%eax
    16d1:	75 ed                	jne    16c0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
    16d3:	83 ec 0c             	sub    $0xc,%esp
    16d6:	56                   	push   %esi
    16d7:	e8 bf fc ff ff       	call   139b <sbrk>
  if(p == (char*)-1)
    16dc:	83 c4 10             	add    $0x10,%esp
    16df:	83 f8 ff             	cmp    $0xffffffff,%eax
    16e2:	74 1c                	je     1700 <malloc+0x80>
  hp->s.size = nu;
    16e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    16e7:	83 ec 0c             	sub    $0xc,%esp
    16ea:	83 c0 08             	add    $0x8,%eax
    16ed:	50                   	push   %eax
    16ee:	e8 fd fe ff ff       	call   15f0 <free>
  return freep;
    16f3:	8b 15 e4 1f 00 00    	mov    0x1fe4,%edx
      if((p = morecore(nunits)) == 0)
    16f9:	83 c4 10             	add    $0x10,%esp
    16fc:	85 d2                	test   %edx,%edx
    16fe:	75 c0                	jne    16c0 <malloc+0x40>
        return 0;
  }
}
    1700:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1703:	31 c0                	xor    %eax,%eax
}
    1705:	5b                   	pop    %ebx
    1706:	5e                   	pop    %esi
    1707:	5f                   	pop    %edi
    1708:	5d                   	pop    %ebp
    1709:	c3                   	ret
    170a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1710:	39 cf                	cmp    %ecx,%edi
    1712:	74 4c                	je     1760 <malloc+0xe0>
        p->s.size -= nunits;
    1714:	29 f9                	sub    %edi,%ecx
    1716:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1719:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    171c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    171f:	89 15 e4 1f 00 00    	mov    %edx,0x1fe4
}
    1725:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1728:	83 c0 08             	add    $0x8,%eax
}
    172b:	5b                   	pop    %ebx
    172c:	5e                   	pop    %esi
    172d:	5f                   	pop    %edi
    172e:	5d                   	pop    %ebp
    172f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
    1730:	c7 05 e4 1f 00 00 e8 	movl   $0x1fe8,0x1fe4
    1737:	1f 00 00 
    base.s.size = 0;
    173a:	b8 e8 1f 00 00       	mov    $0x1fe8,%eax
    base.s.ptr = freep = prevp = &base;
    173f:	c7 05 e8 1f 00 00 e8 	movl   $0x1fe8,0x1fe8
    1746:	1f 00 00 
    base.s.size = 0;
    1749:	c7 05 ec 1f 00 00 00 	movl   $0x0,0x1fec
    1750:	00 00 00 
    if(p->s.size >= nunits){
    1753:	e9 54 ff ff ff       	jmp    16ac <malloc+0x2c>
    1758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
    175f:	00 
        prevp->s.ptr = p->s.ptr;
    1760:	8b 08                	mov    (%eax),%ecx
    1762:	89 0a                	mov    %ecx,(%edx)
    1764:	eb b9                	jmp    171f <malloc+0x9f>
