
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 64 11 80       	mov    $0x801164d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 35 10 80       	mov    $0x80103520,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 76 10 80       	push   $0x80107660
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 45 48 00 00       	call   801048a0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 76 10 80       	push   $0x80107667
80100097:	50                   	push   %eax
80100098:	e8 d3 46 00 00       	call   80104770 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 a7 49 00 00       	call   80104a90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 c9 48 00 00       	call   80104a30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 46 00 00       	call   801047b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 2f 26 00 00       	call   801027c0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 76 10 80       	push   $0x8010766e
801001a6:	e8 c5 01 00 00       	call   80100370 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 8d 46 00 00       	call   80104850 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 e7 25 00 00       	jmp    801027c0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 76 10 80       	push   $0x8010767f
801001e1:	e8 8a 01 00 00       	call   80100370 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 46 00 00       	call   80104850 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 45 00 00       	call   80104810 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 48 00 00       	call   80104a90 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 c2 47 00 00       	jmp    80104a30 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 76 10 80       	push   $0x80107686
80100276:	e8 f5 00 00 00       	call   80100370 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 7d 08             	mov    0x8(%ebp),%edi
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	57                   	push   %edi
80100290:	e8 db 1a 00 00       	call   80101d70 <iunlock>
  target = n;
  acquire(&cons.lock);
80100295:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010029c:	e8 ef 47 00 00       	call   80104a90 <acquire>
  while(n > 0){
801002a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a4:	83 c4 10             	add    $0x10,%esp
801002a7:	85 db                	test   %ebx,%ebx
801002a9:	0f 8e 8d 00 00 00    	jle    8010033c <consoleread+0xbc>
    while(input.r == input.w){
801002af:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b4:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002ba:	74 26                	je     801002e2 <consoleread+0x62>
801002bc:	eb 5a                	jmp    80100318 <consoleread+0x98>
801002be:	66 90                	xchg   %ax,%ax
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 3e 42 00 00       	call   80104510 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 69 3b 00 00       	call   80103e50 <myproc>
801002e7:	8b 40 24             	mov    0x24(%eax),%eax
801002ea:	85 c0                	test   %eax,%eax
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 47 00 00       	call   80104a30 <release>
        ilock(ip);
801002fb:	89 3c 24             	mov    %edi,(%esp)
801002fe:	e8 8d 19 00 00       	call   80101c90 <ilock>
        return -1;
80100303:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100306:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030e:	5b                   	pop    %ebx
8010030f:	5e                   	pop    %esi
80100310:	5f                   	pop    %edi
80100311:	5d                   	pop    %ebp
80100312:	c3                   	ret
80100313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	83 e0 7f             	and    $0x7f,%eax
    *dst++ = c;
8010031e:	83 c6 01             	add    $0x1,%esi
    --n;
80100321:	83 eb 01             	sub    $0x1,%ebx
    c = input.buf[input.r++ % INPUT_BUF];
80100324:	0f b6 80 80 fe 10 80 	movzbl -0x7fef0180(%eax),%eax
8010032b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
    *dst++ = c;
80100331:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100334:	3c 0a                	cmp    $0xa,%al
80100336:	0f 85 6b ff ff ff    	jne    801002a7 <consoleread+0x27>
  release(&cons.lock);
8010033c:	83 ec 0c             	sub    $0xc,%esp
8010033f:	68 20 ff 10 80       	push   $0x8010ff20
80100344:	e8 e7 46 00 00       	call   80104a30 <release>
  ilock(ip);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 3f 19 00 00       	call   80101c90 <ilock>
  return target - n;
80100351:	8b 45 10             	mov    0x10(%ebp),%eax
80100354:	83 c4 10             	add    $0x10,%esp
}
80100357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010035a:	29 d8                	sub    %ebx,%eax
}
8010035c:	5b                   	pop    %ebx
8010035d:	5e                   	pop    %esi
8010035e:	5f                   	pop    %edi
8010035f:	5d                   	pop    %ebp
80100360:	c3                   	ret
80100361:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100368:	00 
80100369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli
  cons.locking = 0;
80100379:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100380:	00 00 00 
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 32 2a 00 00       	call   80102dc0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 76 10 80       	push   $0x8010768d
80100397:	e8 c4 03 00 00       	call   80100760 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	push   0x8(%ebp)
801003a0:	e8 bb 03 00 00       	call   80100760 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 0f 7b 10 80 	movl   $0x80107b0f,(%esp)
801003ac:	e8 af 03 00 00       	call   80100760 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	8d 45 08             	lea    0x8(%ebp),%eax
801003b4:	5a                   	pop    %edx
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 03 45 00 00       	call   801048c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003c8:	68 a1 76 10 80       	push   $0x801076a1
801003cd:	e8 8e 03 00 00       	call   80100760 <cprintf>
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
  panicked = 1;
801003d9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003e0:	00 00 00 
  for(;;)
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003ec:	00 
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc.part.0>:
consputc(int c, int k)
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
801003f9:	3d 00 01 00 00       	cmp    $0x100,%eax
801003fe:	0f 84 64 01 00 00    	je     80100568 <consputc.part.0+0x178>
80100404:	89 c6                	mov    %eax,%esi
  else if(c == KEY_LF){
80100406:	3d e4 00 00 00       	cmp    $0xe4,%eax
8010040b:	0f 84 ff 01 00 00    	je     80100610 <consputc.part.0+0x220>
  else if(c == KEY_RT){
80100411:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100416:	0f 84 a4 00 00 00    	je     801004c0 <consputc.part.0+0xd0>
    uartputc(c);
8010041c:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041f:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100424:	50                   	push   %eax
80100425:	e8 76 5d 00 00       	call   801061a0 <uartputc>
8010042a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042f:	89 fa                	mov    %edi,%edx
80100431:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100432:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100437:	89 da                	mov    %ebx,%edx
80100439:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010043a:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043d:	89 fa                	mov    %edi,%edx
8010043f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100444:	c1 e1 08             	shl    $0x8,%ecx
80100447:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100448:	89 da                	mov    %ebx,%edx
8010044a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010044b:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n'){
8010044e:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
80100451:	09 c8                	or     %ecx,%eax
  if(c == '\n'){
80100453:	83 fe 0a             	cmp    $0xa,%esi
80100456:	0f 85 84 01 00 00    	jne    801005e0 <consputc.part.0+0x1f0>
    pos += 80 - pos%80;
8010045c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100461:	f7 e2                	mul    %edx
80100463:	c1 ea 06             	shr    $0x6,%edx
80100466:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100469:	c1 e0 04             	shl    $0x4,%eax
8010046c:	8d 58 50             	lea    0x50(%eax),%ebx
  if(pos < 0 || pos > 25*80)
8010046f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100475:	0f 8f 90 00 00 00    	jg     8010050b <consputc.part.0+0x11b>
  outb(CRTPORT+1, pos>>8);
8010047b:	0f b6 f7             	movzbl %bh,%esi
  if((pos/80) >= 24){
8010047e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100484:	0f 8f 96 00 00 00    	jg     80100520 <consputc.part.0+0x130>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048a:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010048f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100494:	89 fa                	mov    %edi,%edx
80100496:	ee                   	out    %al,(%dx)
80100497:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049c:	89 f0                	mov    %esi,%eax
8010049e:	89 ca                	mov    %ecx,%edx
801004a0:	ee                   	out    %al,(%dx)
801004a1:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a6:	89 fa                	mov    %edi,%edx
801004a8:	ee                   	out    %al,(%dx)
801004a9:	89 d8                	mov    %ebx,%eax
801004ab:	89 ca                	mov    %ecx,%edx
801004ad:	ee                   	out    %al,(%dx)
}
801004ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b1:	5b                   	pop    %ebx
801004b2:	5e                   	pop    %esi
801004b3:	5f                   	pop    %edi
801004b4:	5d                   	pop    %ebp
801004b5:	c3                   	ret
801004b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801004bd:	00 
801004be:	66 90                	xchg   %ax,%ax
    uartputc(k);
801004c0:	83 ec 0c             	sub    $0xc,%esp
801004c3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004c8:	52                   	push   %edx
801004c9:	e8 d2 5c 00 00       	call   801061a0 <uartputc>
801004ce:	b8 0e 00 00 00       	mov    $0xe,%eax
801004d3:	89 f2                	mov    %esi,%edx
801004d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004d6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801004db:	89 da                	mov    %ebx,%edx
801004dd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801004de:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004e1:	89 f2                	mov    %esi,%edx
801004e3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e8:	c1 e1 08             	shl    $0x8,%ecx
801004eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801004ec:	89 da                	mov    %ebx,%edx
801004ee:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801004ef:	0f b6 d8             	movzbl %al,%ebx
    if (pos < 25*80 - 1)
801004f2:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
801004f5:	09 cb                	or     %ecx,%ebx
    if (pos < 25*80 - 1)
801004f7:	81 fb ce 07 00 00    	cmp    $0x7ce,%ebx
801004fd:	0f 8e 55 01 00 00    	jle    80100658 <consputc.part.0+0x268>
  if(pos < 0 || pos > 25*80)
80100503:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100509:	7e 15                	jle    80100520 <consputc.part.0+0x130>
    panic("pos under/overflow");
8010050b:	83 ec 0c             	sub    $0xc,%esp
8010050e:	68 a5 76 10 80       	push   $0x801076a5
80100513:	e8 58 fe ff ff       	call   80100370 <panic>
80100518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010051f:	00 
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100520:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100523:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT+1, pos);
80100526:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010052b:	68 60 0e 00 00       	push   $0xe60
80100530:	68 a0 80 0b 80       	push   $0x800b80a0
80100535:	68 00 80 0b 80       	push   $0x800b8000
8010053a:	e8 e1 46 00 00       	call   80104c20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010053f:	b8 80 07 00 00       	mov    $0x780,%eax
80100544:	83 c4 0c             	add    $0xc,%esp
80100547:	29 d8                	sub    %ebx,%eax
80100549:	01 c0                	add    %eax,%eax
8010054b:	50                   	push   %eax
8010054c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100553:	6a 00                	push   $0x0
80100555:	50                   	push   %eax
80100556:	e8 35 46 00 00       	call   80104b90 <memset>
  outb(CRTPORT+1, pos);
8010055b:	83 c4 10             	add    $0x10,%esp
8010055e:	e9 27 ff ff ff       	jmp    8010048a <consputc.part.0+0x9a>
80100563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100568:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100570:	6a 08                	push   $0x8
80100572:	e8 29 5c 00 00       	call   801061a0 <uartputc>
80100577:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010057e:	e8 1d 5c 00 00       	call   801061a0 <uartputc>
80100583:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010058a:	e8 11 5c 00 00       	call   801061a0 <uartputc>
8010058f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100594:	89 f2                	mov    %esi,%edx
80100596:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100597:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010059c:	89 da                	mov    %ebx,%edx
8010059e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010059f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005a2:	89 f2                	mov    %esi,%edx
801005a4:	b8 0f 00 00 00       	mov    $0xf,%eax
801005a9:	c1 e1 08             	shl    $0x8,%ecx
801005ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801005ad:	89 da                	mov    %ebx,%edx
801005af:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801005b0:	0f b6 d8             	movzbl %al,%ebx
    if(pos > 0){
801005b3:	83 c4 10             	add    $0x10,%esp
801005b6:	09 cb                	or     %ecx,%ebx
801005b8:	74 16                	je     801005d0 <consputc.part.0+0x1e0>
      --pos;
801005ba:	83 eb 01             	sub    $0x1,%ebx
      crt[pos] = ' ' | 0x0700;
801005bd:	b9 20 07 00 00       	mov    $0x720,%ecx
801005c2:	66 89 8c 1b 00 80 0b 	mov    %cx,-0x7ff48000(%ebx,%ebx,1)
801005c9:	80 
801005ca:	e9 a0 fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
801005cf:	90                   	nop
  outb(CRTPORT+1, pos);
801005d0:	31 db                	xor    %ebx,%ebx
801005d2:	31 f6                	xor    %esi,%esi
801005d4:	e9 b1 fe ff ff       	jmp    8010048a <consputc.part.0+0x9a>
801005d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c&0xff) | 0x0700;
801005e0:	89 f1                	mov    %esi,%ecx
801005e2:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos]   = ' ' | 0x0700;
801005e5:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c&0xff) | 0x0700;
801005ea:	01 c0                	add    %eax,%eax
801005ec:	0f b6 f1             	movzbl %cl,%esi
    crt[pos]   = ' ' | 0x0700;
801005ef:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c&0xff) | 0x0700;
801005f6:	66 81 ce 00 07       	or     $0x700,%si
801005fb:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos]   = ' ' | 0x0700;
80100602:	e9 68 fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
80100607:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010060e:	00 
8010060f:	90                   	nop
    uartputc('\b');
80100610:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100613:	be d4 03 00 00       	mov    $0x3d4,%esi
80100618:	6a 08                	push   $0x8
8010061a:	e8 81 5b 00 00       	call   801061a0 <uartputc>
8010061f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100624:	89 f2                	mov    %esi,%edx
80100626:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100627:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010062c:	89 da                	mov    %ebx,%edx
8010062e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010062f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100632:	89 f2                	mov    %esi,%edx
80100634:	b8 0f 00 00 00       	mov    $0xf,%eax
80100639:	c1 e1 08             	shl    $0x8,%ecx
8010063c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010063d:	89 da                	mov    %ebx,%edx
8010063f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100640:	0f b6 d8             	movzbl %al,%ebx
    if(pos > 0)
80100643:	83 c4 10             	add    $0x10,%esp
80100646:	09 cb                	or     %ecx,%ebx
80100648:	74 86                	je     801005d0 <consputc.part.0+0x1e0>
      --pos;
8010064a:	83 eb 01             	sub    $0x1,%ebx
8010064d:	e9 1d fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
80100652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ++pos;       
80100658:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
8010065b:	e9 1b fe ff ff       	jmp    8010047b <consputc.part.0+0x8b>

80100660 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 18             	sub    $0x18,%esp
80100669:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010066c:	ff 75 08             	push   0x8(%ebp)
8010066f:	e8 fc 16 00 00       	call   80101d70 <iunlock>
  acquire(&cons.lock);
80100674:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010067b:	e8 10 44 00 00       	call   80104a90 <acquire>
  for(i = 0; i < n; i++)
80100680:	83 c4 10             	add    $0x10,%esp
80100683:	85 f6                	test   %esi,%esi
80100685:	7e 27                	jle    801006ae <consolewrite+0x4e>
80100687:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010068a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010068d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff, 0);
80100693:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100696:	85 d2                	test   %edx,%edx
80100698:	74 06                	je     801006a0 <consolewrite+0x40>
  asm volatile("cli");
8010069a:	fa                   	cli
    for(;;)
8010069b:	eb fe                	jmp    8010069b <consolewrite+0x3b>
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	31 d2                	xor    %edx,%edx
  for(i = 0; i < n; i++)
801006a2:	83 c3 01             	add    $0x1,%ebx
801006a5:	e8 46 fd ff ff       	call   801003f0 <consputc.part.0>
801006aa:	39 fb                	cmp    %edi,%ebx
801006ac:	75 df                	jne    8010068d <consolewrite+0x2d>
  release(&cons.lock);
801006ae:	83 ec 0c             	sub    $0xc,%esp
801006b1:	68 20 ff 10 80       	push   $0x8010ff20
801006b6:	e8 75 43 00 00       	call   80104a30 <release>
  ilock(ip);
801006bb:	58                   	pop    %eax
801006bc:	ff 75 08             	push   0x8(%ebp)
801006bf:	e8 cc 15 00 00       	call   80101c90 <ilock>

  return n;
}
801006c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006c7:	89 f0                	mov    %esi,%eax
801006c9:	5b                   	pop    %ebx
801006ca:	5e                   	pop    %esi
801006cb:	5f                   	pop    %edi
801006cc:	5d                   	pop    %ebp
801006cd:	c3                   	ret
801006ce:	66 90                	xchg   %ax,%ax

801006d0 <printint>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	89 d3                	mov    %edx,%ebx
801006d8:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
801006db:	85 c0                	test   %eax,%eax
801006dd:	79 05                	jns    801006e4 <printint+0x14>
801006df:	83 e1 01             	and    $0x1,%ecx
801006e2:	75 66                	jne    8010074a <printint+0x7a>
    x = xx;
801006e4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801006eb:	89 c1                	mov    %eax,%ecx
  i = 0;
801006ed:	31 f6                	xor    %esi,%esi
801006ef:	90                   	nop
    buf[i++] = digits[x % base];
801006f0:	89 c8                	mov    %ecx,%eax
801006f2:	31 d2                	xor    %edx,%edx
801006f4:	89 f7                	mov    %esi,%edi
801006f6:	f7 f3                	div    %ebx
801006f8:	8d 76 01             	lea    0x1(%esi),%esi
801006fb:	0f b6 92 b8 7b 10 80 	movzbl -0x7fef8448(%edx),%edx
80100702:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100706:	89 ca                	mov    %ecx,%edx
80100708:	89 c1                	mov    %eax,%ecx
8010070a:	39 da                	cmp    %ebx,%edx
8010070c:	73 e2                	jae    801006f0 <printint+0x20>
  if(sign)
8010070e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100711:	85 c9                	test   %ecx,%ecx
80100713:	74 07                	je     8010071c <printint+0x4c>
    buf[i++] = '-';
80100715:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010071a:	89 f7                	mov    %esi,%edi
8010071c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010071f:	01 df                	add    %ebx,%edi
  if(panicked){
80100721:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i], 0);
80100727:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010072a:	85 d2                	test   %edx,%edx
8010072c:	74 0a                	je     80100738 <printint+0x68>
8010072e:	fa                   	cli
    for(;;)
8010072f:	eb fe                	jmp    8010072f <printint+0x5f>
80100731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100738:	31 d2                	xor    %edx,%edx
8010073a:	e8 b1 fc ff ff       	call   801003f0 <consputc.part.0>
  while(--i >= 0)
8010073f:	8d 47 ff             	lea    -0x1(%edi),%eax
80100742:	39 df                	cmp    %ebx,%edi
80100744:	74 11                	je     80100757 <printint+0x87>
80100746:	89 c7                	mov    %eax,%edi
80100748:	eb d7                	jmp    80100721 <printint+0x51>
    x = -xx;
8010074a:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010074c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80100753:	89 c1                	mov    %eax,%ecx
80100755:	eb 96                	jmp    801006ed <printint+0x1d>
}
80100757:	83 c4 2c             	add    $0x2c,%esp
8010075a:	5b                   	pop    %ebx
8010075b:	5e                   	pop    %esi
8010075c:	5f                   	pop    %edi
8010075d:	5d                   	pop    %ebp
8010075e:	c3                   	ret
8010075f:	90                   	nop

80100760 <cprintf>:
{
80100760:	55                   	push   %ebp
80100761:	89 e5                	mov    %esp,%ebp
80100763:	57                   	push   %edi
80100764:	56                   	push   %esi
80100765:	53                   	push   %ebx
80100766:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100769:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
8010076f:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
80100772:	85 ff                	test   %edi,%edi
80100774:	0f 85 06 01 00 00    	jne    80100880 <cprintf+0x120>
  if (fmt == 0)
8010077a:	85 f6                	test   %esi,%esi
8010077c:	0f 84 e0 01 00 00    	je     80100962 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100782:	0f b6 06             	movzbl (%esi),%eax
80100785:	85 c0                	test   %eax,%eax
80100787:	74 59                	je     801007e2 <cprintf+0x82>
80100789:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
8010078c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010078f:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
80100791:	83 f8 25             	cmp    $0x25,%eax
80100794:	75 5a                	jne    801007f0 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100796:	83 c3 01             	add    $0x1,%ebx
80100799:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if(c == 0)
8010079d:	85 ff                	test   %edi,%edi
8010079f:	74 36                	je     801007d7 <cprintf+0x77>
    switch(c){
801007a1:	83 ff 70             	cmp    $0x70,%edi
801007a4:	0f 84 b6 00 00 00    	je     80100860 <cprintf+0x100>
801007aa:	7f 74                	jg     80100820 <cprintf+0xc0>
801007ac:	83 ff 25             	cmp    $0x25,%edi
801007af:	74 5e                	je     8010080f <cprintf+0xaf>
801007b1:	83 ff 64             	cmp    $0x64,%edi
801007b4:	75 78                	jne    8010082e <cprintf+0xce>
      printint(*argp++, 10, 1);
801007b6:	8b 01                	mov    (%ecx),%eax
801007b8:	8d 79 04             	lea    0x4(%ecx),%edi
801007bb:	ba 0a 00 00 00       	mov    $0xa,%edx
801007c0:	b9 01 00 00 00       	mov    $0x1,%ecx
801007c5:	e8 06 ff ff ff       	call   801006d0 <printint>
801007ca:	89 f9                	mov    %edi,%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cc:	83 c3 01             	add    $0x1,%ebx
801007cf:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d3:	85 c0                	test   %eax,%eax
801007d5:	75 ba                	jne    80100791 <cprintf+0x31>
801007d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
801007da:	85 ff                	test   %edi,%edi
801007dc:	0f 85 c1 00 00 00    	jne    801008a3 <cprintf+0x143>
}
801007e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007e5:	5b                   	pop    %ebx
801007e6:	5e                   	pop    %esi
801007e7:	5f                   	pop    %edi
801007e8:	5d                   	pop    %ebp
801007e9:	c3                   	ret
801007ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(panicked){
801007f0:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
801007f6:	85 ff                	test   %edi,%edi
801007f8:	74 06                	je     80100800 <cprintf+0xa0>
801007fa:	fa                   	cli
    for(;;)
801007fb:	eb fe                	jmp    801007fb <cprintf+0x9b>
801007fd:	8d 76 00             	lea    0x0(%esi),%esi
80100800:	31 d2                	xor    %edx,%edx
80100802:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100805:	e8 e6 fb ff ff       	call   801003f0 <consputc.part.0>
      continue;
8010080a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010080d:	eb bd                	jmp    801007cc <cprintf+0x6c>
  if(panicked){
8010080f:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
80100815:	85 ff                	test   %edi,%edi
80100817:	0f 84 13 01 00 00    	je     80100930 <cprintf+0x1d0>
8010081d:	fa                   	cli
    for(;;)
8010081e:	eb fe                	jmp    8010081e <cprintf+0xbe>
    switch(c){
80100820:	83 ff 73             	cmp    $0x73,%edi
80100823:	0f 84 8f 00 00 00    	je     801008b8 <cprintf+0x158>
80100829:	83 ff 78             	cmp    $0x78,%edi
8010082c:	74 32                	je     80100860 <cprintf+0x100>
  if(panicked){
8010082e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100834:	85 d2                	test   %edx,%edx
80100836:	0f 85 e8 00 00 00    	jne    80100924 <cprintf+0x1c4>
8010083c:	31 d2                	xor    %edx,%edx
8010083e:	b8 25 00 00 00       	mov    $0x25,%eax
80100843:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100846:	e8 a5 fb ff ff       	call   801003f0 <consputc.part.0>
8010084b:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100850:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100853:	85 c0                	test   %eax,%eax
80100855:	0f 84 ec 00 00 00    	je     80100947 <cprintf+0x1e7>
8010085b:	fa                   	cli
    for(;;)
8010085c:	eb fe                	jmp    8010085c <cprintf+0xfc>
8010085e:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
80100860:	8b 01                	mov    (%ecx),%eax
80100862:	8d 79 04             	lea    0x4(%ecx),%edi
80100865:	ba 10 00 00 00       	mov    $0x10,%edx
8010086a:	31 c9                	xor    %ecx,%ecx
8010086c:	e8 5f fe ff ff       	call   801006d0 <printint>
80100871:	89 f9                	mov    %edi,%ecx
      break;
80100873:	e9 54 ff ff ff       	jmp    801007cc <cprintf+0x6c>
80100878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010087f:	00 
    acquire(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 ff 10 80       	push   $0x8010ff20
80100888:	e8 03 42 00 00       	call   80104a90 <acquire>
  if (fmt == 0)
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 84 ca 00 00 00    	je     80100962 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100898:	0f b6 06             	movzbl (%esi),%eax
8010089b:	85 c0                	test   %eax,%eax
8010089d:	0f 85 e6 fe ff ff    	jne    80100789 <cprintf+0x29>
    release(&cons.lock);
801008a3:	83 ec 0c             	sub    $0xc,%esp
801008a6:	68 20 ff 10 80       	push   $0x8010ff20
801008ab:	e8 80 41 00 00       	call   80104a30 <release>
801008b0:	83 c4 10             	add    $0x10,%esp
801008b3:	e9 2a ff ff ff       	jmp    801007e2 <cprintf+0x82>
      if((s = (char*)*argp++) == 0)
801008b8:	8b 39                	mov    (%ecx),%edi
801008ba:	8d 51 04             	lea    0x4(%ecx),%edx
801008bd:	85 ff                	test   %edi,%edi
801008bf:	74 27                	je     801008e8 <cprintf+0x188>
      for(; *s; s++)
801008c1:	0f be 07             	movsbl (%edi),%eax
801008c4:	84 c0                	test   %al,%al
801008c6:	0f 84 8f 00 00 00    	je     8010095b <cprintf+0x1fb>
801008cc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008cf:	89 fb                	mov    %edi,%ebx
801008d1:	89 f7                	mov    %esi,%edi
801008d3:	89 d6                	mov    %edx,%esi
  if(panicked){
801008d5:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801008db:	85 d2                	test   %edx,%edx
801008dd:	74 26                	je     80100905 <cprintf+0x1a5>
801008df:	fa                   	cli
    for(;;)
801008e0:	eb fe                	jmp    801008e0 <cprintf+0x180>
801008e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
801008e8:	bf b8 76 10 80       	mov    $0x801076b8,%edi
801008ed:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008f0:	b8 28 00 00 00       	mov    $0x28,%eax
801008f5:	89 fb                	mov    %edi,%ebx
801008f7:	89 f7                	mov    %esi,%edi
801008f9:	89 d6                	mov    %edx,%esi
  if(panicked){
801008fb:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100901:	85 d2                	test   %edx,%edx
80100903:	75 da                	jne    801008df <cprintf+0x17f>
80100905:	31 d2                	xor    %edx,%edx
      for(; *s; s++)
80100907:	83 c3 01             	add    $0x1,%ebx
8010090a:	e8 e1 fa ff ff       	call   801003f0 <consputc.part.0>
8010090f:	0f be 03             	movsbl (%ebx),%eax
80100912:	84 c0                	test   %al,%al
80100914:	75 bf                	jne    801008d5 <cprintf+0x175>
      if((s = (char*)*argp++) == 0)
80100916:	89 f2                	mov    %esi,%edx
80100918:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010091b:	89 fe                	mov    %edi,%esi
8010091d:	89 d1                	mov    %edx,%ecx
8010091f:	e9 a8 fe ff ff       	jmp    801007cc <cprintf+0x6c>
80100924:	fa                   	cli
    for(;;)
80100925:	eb fe                	jmp    80100925 <cprintf+0x1c5>
80100927:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010092e:	00 
8010092f:	90                   	nop
80100930:	31 d2                	xor    %edx,%edx
80100932:	b8 25 00 00 00       	mov    $0x25,%eax
80100937:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010093a:	e8 b1 fa ff ff       	call   801003f0 <consputc.part.0>
      break;
8010093f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100942:	e9 85 fe ff ff       	jmp    801007cc <cprintf+0x6c>
80100947:	31 d2                	xor    %edx,%edx
80100949:	89 f8                	mov    %edi,%eax
8010094b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010094e:	e8 9d fa ff ff       	call   801003f0 <consputc.part.0>
      break;
80100953:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100956:	e9 71 fe ff ff       	jmp    801007cc <cprintf+0x6c>
      if((s = (char*)*argp++) == 0)
8010095b:	89 d1                	mov    %edx,%ecx
8010095d:	e9 6a fe ff ff       	jmp    801007cc <cprintf+0x6c>
    panic("null fmt");
80100962:	83 ec 0c             	sub    $0xc,%esp
80100965:	68 bf 76 10 80       	push   $0x801076bf
8010096a:	e8 01 fa ff ff       	call   80100370 <panic>
8010096f:	90                   	nop

80100970 <consoleintr>:
{
80100970:	55                   	push   %ebp
80100971:	89 e5                	mov    %esp,%ebp
80100973:	57                   	push   %edi
  int c, doprocdump = 0;
80100974:	31 ff                	xor    %edi,%edi
{
80100976:	56                   	push   %esi
80100977:	53                   	push   %ebx
80100978:	83 ec 38             	sub    $0x38,%esp
8010097b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
8010097e:	68 20 ff 10 80       	push   $0x8010ff20
80100983:	e8 08 41 00 00       	call   80104a90 <acquire>
  while((c = getc()) >= 0){
80100988:	83 c4 10             	add    $0x10,%esp
8010098b:	ff d6                	call   *%esi
8010098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100990:	85 c0                	test   %eax,%eax
80100992:	0f 88 00 02 00 00    	js     80100b98 <consoleintr+0x228>
    switch(c){
80100998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010099b:	83 f8 15             	cmp    $0x15,%eax
8010099e:	7f 58                	jg     801009f8 <consoleintr+0x88>
801009a0:	85 c0                	test   %eax,%eax
801009a2:	74 e7                	je     8010098b <consoleintr+0x1b>
801009a4:	83 f8 15             	cmp    $0x15,%eax
801009a7:	77 77                	ja     80100a20 <consoleintr+0xb0>
801009a9:	ff 24 85 60 7b 10 80 	jmp    *-0x7fef84a0(,%eax,4)
801009b0:	31 d2                	xor    %edx,%edx
801009b2:	b8 00 01 00 00       	mov    $0x100,%eax
801009b7:	e8 34 fa ff ff       	call   801003f0 <consputc.part.0>
      while(input.e != input.w &&
801009bc:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009c1:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009c7:	0f 84 31 02 00 00    	je     80100bfe <consoleintr+0x28e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009cd:	8d 50 ff             	lea    -0x1(%eax),%edx
801009d0:	89 d1                	mov    %edx,%ecx
801009d2:	83 e1 7f             	and    $0x7f,%ecx
      while(input.e != input.w &&
801009d5:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
801009dc:	0f 84 1c 02 00 00    	je     80100bfe <consoleintr+0x28e>
  if(panicked){
801009e2:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
        input.e--;
801009e7:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if(panicked){
801009ed:	85 c0                	test   %eax,%eax
801009ef:	74 bf                	je     801009b0 <consoleintr+0x40>
801009f1:	fa                   	cli
    for(;;)
801009f2:	eb fe                	jmp    801009f2 <consoleintr+0x82>
801009f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801009f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009fb:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100a00:	0f 84 62 01 00 00    	je     80100b68 <consoleintr+0x1f8>
80100a06:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100a0b:	74 73                	je     80100a80 <consoleintr+0x110>
80100a0d:	83 f8 7f             	cmp    $0x7f,%eax
80100a10:	0f 84 9a 00 00 00    	je     80100ab0 <consoleintr+0x140>
80100a16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a1d:	00 
80100a1e:	66 90                	xchg   %ax,%ax
      if(input.e < input.real_end){
80100a20:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100a25:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100a2b:	89 c2                	mov    %eax,%edx
80100a2d:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
      if(input.e < input.real_end){
80100a33:	39 c1                	cmp    %eax,%ecx
80100a35:	0f 83 e5 01 00 00    	jae    80100c20 <consoleintr+0x2b0>
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100a3b:	83 fa 7f             	cmp    $0x7f,%edx
80100a3e:	0f 87 47 ff ff ff    	ja     8010098b <consoleintr+0x1b>
  if(panicked){
80100a44:	8b 1d 58 ff 10 80    	mov    0x8010ff58,%ebx
          if(c != '\n'){
80100a4a:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%ebp)
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a4e:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a51:	89 5d e0             	mov    %ebx,-0x20(%ebp)
          if(c != '\n'){
80100a54:	0f 85 58 03 00 00    	jne    80100db2 <consoleintr+0x442>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a5a:	83 e0 7f             	and    $0x7f,%eax
80100a5d:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a63:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
80100a6a:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100a70:	85 db                	test   %ebx,%ebx
80100a72:	0f 84 74 04 00 00    	je     80100eec <consoleintr+0x57c>
80100a78:	fa                   	cli
    for(;;)
80100a79:	eb fe                	jmp    80100a79 <consoleintr+0x109>
80100a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e < input.real_end){
80100a80:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a85:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100a8b:	0f 83 fa fe ff ff    	jae    8010098b <consoleintr+0x1b>
        char ch = input.buf[input.e % INPUT_BUF];
80100a91:	83 e0 7f             	and    $0x7f,%eax
80100a94:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if(panicked){
80100a9b:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100aa0:	85 c0                	test   %eax,%eax
80100aa2:	0f 84 69 02 00 00    	je     80100d11 <consoleintr+0x3a1>
80100aa8:	fa                   	cli
    for(;;)
80100aa9:	eb fe                	jmp    80100aa9 <consoleintr+0x139>
80100aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e != input.w) {
80100ab0:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100ab6:	3b 15 04 ff 10 80    	cmp    0x8010ff04,%edx
80100abc:	0f 84 c9 fe ff ff    	je     8010098b <consoleintr+0x1b>
          input.real_end--;
80100ac2:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
  if(panicked){
80100ac7:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        if (input.e == input.real_end) {
80100acd:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
          input.real_end--;
80100ad3:	8d 58 ff             	lea    -0x1(%eax),%ebx
          input.e--;
80100ad6:	8d 42 ff             	lea    -0x1(%edx),%eax
  if(panicked){
80100ad9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
          input.e--;
80100adc:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
        if (input.e == input.real_end) {
80100ae1:	0f 84 21 01 00 00    	je     80100c08 <consoleintr+0x298>
          for (uint i = input.e; i < input.real_end - 1; i++)
80100ae7:	39 d8                	cmp    %ebx,%eax
80100ae9:	73 23                	jae    80100b0e <consoleintr+0x19e>
80100aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100af0:	89 c2                	mov    %eax,%edx
80100af2:	83 c0 01             	add    $0x1,%eax
80100af5:	89 c1                	mov    %eax,%ecx
80100af7:	83 e2 7f             	and    $0x7f,%edx
80100afa:	83 e1 7f             	and    $0x7f,%ecx
80100afd:	0f b6 89 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ecx
80100b04:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
          for (uint i = input.e; i < input.real_end - 1; i++)
80100b0a:	39 d8                	cmp    %ebx,%eax
80100b0c:	75 e2                	jne    80100af0 <consoleintr+0x180>
          input.real_end--;
80100b0e:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100b14:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100b17:	85 db                	test   %ebx,%ebx
80100b19:	0f 84 51 01 00 00    	je     80100c70 <consoleintr+0x300>
80100b1f:	fa                   	cli
    for(;;)
80100b20:	eb fe                	jmp    80100b20 <consoleintr+0x1b0>
80100b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100b28:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100b2e:	89 d0                	mov    %edx,%eax
80100b30:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100b36:	0f 83 4f fe ff ff    	jae    8010098b <consoleintr+0x1b>
80100b3c:	83 e0 7f             	and    $0x7f,%eax
80100b3f:	0f b6 80 80 fe 10 80 	movzbl -0x7fef0180(%eax),%eax
80100b46:	3c 20                	cmp    $0x20,%al
80100b48:	0f 84 82 01 00 00    	je     80100cd0 <consoleintr+0x360>
80100b4e:	3c 0a                	cmp    $0xa,%al
80100b50:	0f 84 7a 01 00 00    	je     80100cd0 <consoleintr+0x360>
  if(panicked){
80100b56:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100b5c:	85 d2                	test   %edx,%edx
80100b5e:	74 54                	je     80100bb4 <consoleintr+0x244>
80100b60:	fa                   	cli
    for(;;)
80100b61:	eb fe                	jmp    80100b61 <consoleintr+0x1f1>
80100b63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e > input.w){
80100b68:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b6d:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100b73:	0f 83 12 fe ff ff    	jae    8010098b <consoleintr+0x1b>
        input.e--;
80100b79:	83 e8 01             	sub    $0x1,%eax
80100b7c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100b81:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100b86:	85 c0                	test   %eax,%eax
80100b88:	0f 84 72 01 00 00    	je     80100d00 <consoleintr+0x390>
80100b8e:	fa                   	cli
    for(;;)
80100b8f:	eb fe                	jmp    80100b8f <consoleintr+0x21f>
80100b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100b98:	83 ec 0c             	sub    $0xc,%esp
80100b9b:	68 20 ff 10 80       	push   $0x8010ff20
80100ba0:	e8 8b 3e 00 00       	call   80104a30 <release>
  if(doprocdump) {
80100ba5:	83 c4 10             	add    $0x10,%esp
80100ba8:	85 ff                	test   %edi,%edi
80100baa:	75 46                	jne    80100bf2 <consoleintr+0x282>
}
80100bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100baf:	5b                   	pop    %ebx
80100bb0:	5e                   	pop    %esi
80100bb1:	5f                   	pop    %edi
80100bb2:	5d                   	pop    %ebp
80100bb3:	c3                   	ret
        consputc(KEY_RT, ch);
80100bb4:	0f be d0             	movsbl %al,%edx
80100bb7:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100bbc:	e8 2f f8 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100bc1:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100bc7:	8d 42 01             	lea    0x1(%edx),%eax
80100bca:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80100bcf:	89 c2                	mov    %eax,%edx
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100bd1:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100bd7:	0f 82 5f ff ff ff    	jb     80100b3c <consoleintr+0x1cc>
80100bdd:	e9 a9 fd ff ff       	jmp    8010098b <consoleintr+0x1b>
80100be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100be8:	bf 01 00 00 00       	mov    $0x1,%edi
80100bed:	e9 99 fd ff ff       	jmp    8010098b <consoleintr+0x1b>
}
80100bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100bf5:	5b                   	pop    %ebx
80100bf6:	5e                   	pop    %esi
80100bf7:	5f                   	pop    %edi
80100bf8:	5d                   	pop    %ebp
    procdump();
80100bf9:	e9 b2 3a 00 00       	jmp    801046b0 <procdump>
      input.real_end = input.e;
80100bfe:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      break;
80100c03:	e9 83 fd ff ff       	jmp    8010098b <consoleintr+0x1b>
          input.real_end--;
80100c08:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100c0e:	85 c9                	test   %ecx,%ecx
80100c10:	0f 84 42 01 00 00    	je     80100d58 <consoleintr+0x3e8>
80100c16:	fa                   	cli
    for(;;)
80100c17:	eb fe                	jmp    80100c17 <consoleintr+0x2a7>
80100c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100c20:	83 fa 7f             	cmp    $0x7f,%edx
80100c23:	0f 87 62 fd ff ff    	ja     8010098b <consoleintr+0x1b>
          c = (c == '\r') ? '\n' : c;
80100c29:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100c2c:	83 fb 0d             	cmp    $0xd,%ebx
80100c2f:	75 0c                	jne    80100c3d <consoleintr+0x2cd>
80100c31:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
80100c38:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100c3d:	8d 51 01             	lea    0x1(%ecx),%edx
80100c40:	83 e1 7f             	and    $0x7f,%ecx
80100c43:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100c49:	88 99 80 fe 10 80    	mov    %bl,-0x7fef0180(%ecx)
          if (input.e > input.real_end) input.real_end = input.e;
80100c4f:	39 d0                	cmp    %edx,%eax
80100c51:	73 06                	jae    80100c59 <consoleintr+0x2e9>
80100c53:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100c59:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100c5e:	85 c0                	test   %eax,%eax
80100c60:	0f 84 03 01 00 00    	je     80100d69 <consoleintr+0x3f9>
80100c66:	fa                   	cli
    for(;;)
80100c67:	eb fe                	jmp    80100c67 <consoleintr+0x2f7>
80100c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c70:	31 d2                	xor    %edx,%edx
80100c72:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100c77:	e8 74 f7 ff ff       	call   801003f0 <consputc.part.0>
          for (uint i = input.e; i < input.real_end; i++)
80100c7c:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100c82:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100c88:	73 2c                	jae    80100cb6 <consoleintr+0x346>
            consputc(input.buf[i % INPUT_BUF], 0);
80100c8a:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100c8c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
            consputc(input.buf[i % INPUT_BUF], 0);
80100c92:	83 e0 7f             	and    $0x7f,%eax
80100c95:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100c9c:	85 d2                	test   %edx,%edx
80100c9e:	0f 85 ac 00 00 00    	jne    80100d50 <consoleintr+0x3e0>
80100ca4:	31 d2                	xor    %edx,%edx
          for (uint i = input.e; i < input.real_end; i++)
80100ca6:	83 c3 01             	add    $0x1,%ebx
80100ca9:	e8 42 f7 ff ff       	call   801003f0 <consputc.part.0>
80100cae:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100cb4:	72 d4                	jb     80100c8a <consoleintr+0x31a>
  if(panicked){
80100cb6:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100cbc:	85 c9                	test   %ecx,%ecx
80100cbe:	0f 84 dc 01 00 00    	je     80100ea0 <consoleintr+0x530>
80100cc4:	fa                   	cli
    for(;;)
80100cc5:	eb fe                	jmp    80100cc5 <consoleintr+0x355>
80100cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100cce:	00 
80100ccf:	90                   	nop
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100cd0:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100cd6:	0f 83 af fc ff ff    	jae    8010098b <consoleintr+0x1b>
80100cdc:	89 d0                	mov    %edx,%eax
80100cde:	83 e0 7f             	and    $0x7f,%eax
80100ce1:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100ce8:	0f 85 9d fc ff ff    	jne    8010098b <consoleintr+0x1b>
  if(panicked){
80100cee:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100cf3:	85 c0                	test   %eax,%eax
80100cf5:	74 30                	je     80100d27 <consoleintr+0x3b7>
80100cf7:	fa                   	cli
    for(;;)
80100cf8:	eb fe                	jmp    80100cf8 <consoleintr+0x388>
80100cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d00:	31 d2                	xor    %edx,%edx
80100d02:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100d07:	e8 e4 f6 ff ff       	call   801003f0 <consputc.part.0>
80100d0c:	e9 7a fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d11:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d16:	e8 d5 f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d1b:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
80100d22:	e9 64 fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d27:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d2c:	ba 20 00 00 00       	mov    $0x20,%edx
80100d31:	e8 ba f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d36:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d3b:	83 c0 01             	add    $0x1,%eax
80100d3e:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100d43:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100d49:	72 93                	jb     80100cde <consoleintr+0x36e>
80100d4b:	e9 3b fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d50:	fa                   	cli
    for(;;)
80100d51:	eb fe                	jmp    80100d51 <consoleintr+0x3e1>
80100d53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d58:	31 d2                	xor    %edx,%edx
80100d5a:	b8 00 01 00 00       	mov    $0x100,%eax
80100d5f:	e8 8c f6 ff ff       	call   801003f0 <consputc.part.0>
80100d64:	e9 22 fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d69:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100d6c:	31 d2                	xor    %edx,%edx
80100d6e:	89 d8                	mov    %ebx,%eax
80100d70:	e8 7b f6 ff ff       	call   801003f0 <consputc.part.0>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100d75:	83 fb 0a             	cmp    $0xa,%ebx
80100d78:	74 14                	je     80100d8e <consoleintr+0x41e>
80100d7a:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100d7f:	83 e8 80             	sub    $0xffffff80,%eax
80100d82:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
80100d88:	0f 85 fd fb ff ff    	jne    8010098b <consoleintr+0x1b>
            input.w = input.e;
80100d8e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100d93:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100d96:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
80100d9b:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
80100da0:	68 00 ff 10 80       	push   $0x8010ff00
80100da5:	e8 26 38 00 00       	call   801045d0 <wakeup>
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	e9 d9 fb ff ff       	jmp    8010098b <consoleintr+0x1b>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100db2:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100db5:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100db8:	39 cb                	cmp    %ecx,%ebx
80100dba:	7c 4e                	jl     80100e0a <consoleintr+0x49a>
80100dbc:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80100dbf:	89 7d dc             	mov    %edi,-0x24(%ebp)
80100dc2:	89 d7                	mov    %edx,%edi
80100dc4:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80100dc7:	89 c6                	mov    %eax,%esi
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100dc9:	89 da                	mov    %ebx,%edx
80100dcb:	c1 fa 1f             	sar    $0x1f,%edx
80100dce:	c1 ea 19             	shr    $0x19,%edx
80100dd1:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80100dd4:	83 e0 7f             	and    $0x7f,%eax
80100dd7:	29 d0                	sub    %edx,%eax
80100dd9:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
80100de0:	8d 43 01             	lea    0x1(%ebx),%eax
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100de3:	83 eb 01             	sub    $0x1,%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100de6:	89 c1                	mov    %eax,%ecx
80100de8:	c1 f9 1f             	sar    $0x1f,%ecx
80100deb:	c1 e9 19             	shr    $0x19,%ecx
80100dee:	01 c8                	add    %ecx,%eax
80100df0:	83 e0 7f             	and    $0x7f,%eax
80100df3:	29 c8                	sub    %ecx,%eax
80100df5:	88 90 80 fe 10 80    	mov    %dl,-0x7fef0180(%eax)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100dfb:	39 f3                	cmp    %esi,%ebx
80100dfd:	75 ca                	jne    80100dc9 <consoleintr+0x459>
80100dff:	89 fa                	mov    %edi,%edx
80100e01:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80100e04:	8b 7d dc             	mov    -0x24(%ebp),%edi
80100e07:	8b 75 d4             	mov    -0x2c(%ebp),%esi
            input.buf[input.e] = c;
80100e0a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  if(panicked){
80100e0e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
            input.real_end++;
80100e11:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
            input.buf[input.e] = c;
80100e17:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked){
80100e1d:	85 db                	test   %ebx,%ebx
80100e1f:	74 07                	je     80100e28 <consoleintr+0x4b8>
80100e21:	fa                   	cli
    for(;;)
80100e22:	eb fe                	jmp    80100e22 <consoleintr+0x4b2>
80100e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2b:	31 d2                	xor    %edx,%edx
80100e2d:	e8 be f5 ff ff       	call   801003f0 <consputc.part.0>
            input.e++;
80100e32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e37:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
80100e3a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
80100e3f:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
80100e45:	39 c3                	cmp    %eax,%ebx
80100e47:	0f 83 e6 00 00 00    	jae    80100f33 <consoleintr+0x5c3>
              consputc(input.buf[i % INPUT_BUF], 0);
80100e4d:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100e4f:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
              consputc(input.buf[i % INPUT_BUF], 0);
80100e55:	83 e0 7f             	and    $0x7f,%eax
80100e58:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100e5f:	85 c9                	test   %ecx,%ecx
80100e61:	74 0d                	je     80100e70 <consoleintr+0x500>
80100e63:	fa                   	cli
    for(;;)
80100e64:	eb fe                	jmp    80100e64 <consoleintr+0x4f4>
80100e66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e6d:	00 
80100e6e:	66 90                	xchg   %ax,%ax
80100e70:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80100e72:	83 c3 01             	add    $0x1,%ebx
80100e75:	e8 76 f5 ff ff       	call   801003f0 <consputc.part.0>
80100e7a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100e7f:	39 c3                	cmp    %eax,%ebx
80100e81:	72 ca                	jb     80100e4d <consoleintr+0x4dd>
            for (uint k = input.e; k < input.real_end; k++)
80100e83:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100e89:	39 c3                	cmp    %eax,%ebx
80100e8b:	0f 83 a2 00 00 00    	jae    80100f33 <consoleintr+0x5c3>
  if(panicked){
80100e91:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100e97:	85 d2                	test   %edx,%edx
80100e99:	74 7c                	je     80100f17 <consoleintr+0x5a7>
80100e9b:	fa                   	cli
    for(;;)
80100e9c:	eb fe                	jmp    80100e9c <consoleintr+0x52c>
80100e9e:	66 90                	xchg   %ax,%ax
80100ea0:	31 d2                	xor    %edx,%edx
80100ea2:	b8 20 00 00 00       	mov    $0x20,%eax
80100ea7:	e8 44 f5 ff ff       	call   801003f0 <consputc.part.0>
          for (uint k = input.e; k <= input.real_end; k++)
80100eac:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100eb2:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100eb8:	0f 82 cd fa ff ff    	jb     8010098b <consoleintr+0x1b>
  if(panicked){
80100ebe:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100ec3:	85 c0                	test   %eax,%eax
80100ec5:	74 09                	je     80100ed0 <consoleintr+0x560>
80100ec7:	fa                   	cli
    for(;;)
80100ec8:	eb fe                	jmp    80100ec8 <consoleintr+0x558>
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ed0:	31 d2                	xor    %edx,%edx
80100ed2:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (uint k = input.e; k <= input.real_end; k++)
80100ed7:	83 c3 01             	add    $0x1,%ebx
80100eda:	e8 11 f5 ff ff       	call   801003f0 <consputc.part.0>
80100edf:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100ee5:	73 d7                	jae    80100ebe <consoleintr+0x54e>
80100ee7:	e9 9f fa ff ff       	jmp    8010098b <consoleintr+0x1b>
80100eec:	31 d2                	xor    %edx,%edx
80100eee:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ef3:	e8 f8 f4 ff ff       	call   801003f0 <consputc.part.0>
            input.w = input.e;
80100ef8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100efd:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100f00:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
80100f05:	68 00 ff 10 80       	push   $0x8010ff00
80100f0a:	e8 c1 36 00 00       	call   801045d0 <wakeup>
80100f0f:	83 c4 10             	add    $0x10,%esp
80100f12:	e9 74 fa ff ff       	jmp    8010098b <consoleintr+0x1b>
80100f17:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100f1c:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80100f1e:	83 c3 01             	add    $0x1,%ebx
80100f21:	e8 ca f4 ff ff       	call   801003f0 <consputc.part.0>
80100f26:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100f2b:	39 c3                	cmp    %eax,%ebx
80100f2d:	0f 82 5e ff ff ff    	jb     80100e91 <consoleintr+0x521>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100f33:	8b 1d 00 ff 10 80    	mov    0x8010ff00,%ebx
80100f39:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80100f3f:	39 c2                	cmp    %eax,%edx
80100f41:	0f 85 44 fa ff ff    	jne    8010098b <consoleintr+0x1b>
            input.e = input.real_end;
80100f47:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            if (c == '\n') {
80100f4c:	eb aa                	jmp    80100ef8 <consoleintr+0x588>
80100f4e:	66 90                	xchg   %ax,%ax

80100f50 <consoleinit>:

void
consoleinit(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f56:	68 c8 76 10 80       	push   $0x801076c8
80100f5b:	68 20 ff 10 80       	push   $0x8010ff20
80100f60:	e8 3b 39 00 00       	call   801048a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f65:	58                   	pop    %eax
80100f66:	5a                   	pop    %edx
80100f67:	6a 00                	push   $0x0
80100f69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f6b:	c7 05 0c 09 11 80 60 	movl   $0x80100660,0x8011090c
80100f72:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100f75:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100f7c:	02 10 80 
  cons.locking = 1;
80100f7f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100f86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f89:	e8 c2 19 00 00       	call   80102950 <ioapicenable>
}
80100f8e:	83 c4 10             	add    $0x10,%esp
80100f91:	c9                   	leave
80100f92:	c3                   	ret
80100f93:	66 90                	xchg   %ax,%ax
80100f95:	66 90                	xchg   %ax,%ax
80100f97:	66 90                	xchg   %ax,%ax
80100f99:	66 90                	xchg   %ax,%ax
80100f9b:	66 90                	xchg   %ax,%ax
80100f9d:	66 90                	xchg   %ax,%ax
80100f9f:	90                   	nop

80100fa0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100fac:	e8 9f 2e 00 00       	call   80103e50 <myproc>
80100fb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100fb7:	e8 74 22 00 00       	call   80103230 <begin_op>

  if((ip = namei(path)) == 0){
80100fbc:	83 ec 0c             	sub    $0xc,%esp
80100fbf:	ff 75 08             	push   0x8(%ebp)
80100fc2:	e8 a9 15 00 00       	call   80102570 <namei>
80100fc7:	83 c4 10             	add    $0x10,%esp
80100fca:	85 c0                	test   %eax,%eax
80100fcc:	0f 84 30 03 00 00    	je     80101302 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fd2:	83 ec 0c             	sub    $0xc,%esp
80100fd5:	89 c7                	mov    %eax,%edi
80100fd7:	50                   	push   %eax
80100fd8:	e8 b3 0c 00 00       	call   80101c90 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fdd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fe3:	6a 34                	push   $0x34
80100fe5:	6a 00                	push   $0x0
80100fe7:	50                   	push   %eax
80100fe8:	57                   	push   %edi
80100fe9:	e8 b2 0f 00 00       	call   80101fa0 <readi>
80100fee:	83 c4 20             	add    $0x20,%esp
80100ff1:	83 f8 34             	cmp    $0x34,%eax
80100ff4:	0f 85 01 01 00 00    	jne    801010fb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100ffa:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101001:	45 4c 46 
80101004:	0f 85 f1 00 00 00    	jne    801010fb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
8010100a:	e8 01 63 00 00       	call   80107310 <setupkvm>
8010100f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101015:	85 c0                	test   %eax,%eax
80101017:	0f 84 de 00 00 00    	je     801010fb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010101d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101024:	00 
80101025:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010102b:	0f 84 a1 02 00 00    	je     801012d2 <exec+0x332>
  sz = 0;
80101031:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101038:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010103b:	31 db                	xor    %ebx,%ebx
8010103d:	e9 8c 00 00 00       	jmp    801010ce <exec+0x12e>
80101042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101048:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010104f:	75 6c                	jne    801010bd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101051:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101057:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010105d:	0f 82 87 00 00 00    	jb     801010ea <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101063:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101069:	72 7f                	jb     801010ea <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010106b:	83 ec 04             	sub    $0x4,%esp
8010106e:	50                   	push   %eax
8010106f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101075:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010107b:	e8 c0 60 00 00       	call   80107140 <allocuvm>
80101080:	83 c4 10             	add    $0x10,%esp
80101083:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101089:	85 c0                	test   %eax,%eax
8010108b:	74 5d                	je     801010ea <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010108d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101093:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101098:	75 50                	jne    801010ea <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010109a:	83 ec 0c             	sub    $0xc,%esp
8010109d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801010a3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801010a9:	57                   	push   %edi
801010aa:	50                   	push   %eax
801010ab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010b1:	e8 ba 5f 00 00       	call   80107070 <loaduvm>
801010b6:	83 c4 20             	add    $0x20,%esp
801010b9:	85 c0                	test   %eax,%eax
801010bb:	78 2d                	js     801010ea <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010bd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010c4:	83 c3 01             	add    $0x1,%ebx
801010c7:	83 c6 20             	add    $0x20,%esi
801010ca:	39 d8                	cmp    %ebx,%eax
801010cc:	7e 52                	jle    80101120 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010ce:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010d4:	6a 20                	push   $0x20
801010d6:	56                   	push   %esi
801010d7:	50                   	push   %eax
801010d8:	57                   	push   %edi
801010d9:	e8 c2 0e 00 00       	call   80101fa0 <readi>
801010de:	83 c4 10             	add    $0x10,%esp
801010e1:	83 f8 20             	cmp    $0x20,%eax
801010e4:	0f 84 5e ff ff ff    	je     80101048 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801010ea:	83 ec 0c             	sub    $0xc,%esp
801010ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010f3:	e8 98 61 00 00       	call   80107290 <freevm>
  if(ip){
801010f8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	57                   	push   %edi
801010ff:	e8 1c 0e 00 00       	call   80101f20 <iunlockput>
    end_op();
80101104:	e8 97 21 00 00       	call   801032a0 <end_op>
80101109:	83 c4 10             	add    $0x10,%esp
    return -1;
8010110c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80101111:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101114:	5b                   	pop    %ebx
80101115:	5e                   	pop    %esi
80101116:	5f                   	pop    %edi
80101117:	5d                   	pop    %ebp
80101118:	c3                   	ret
80101119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101120:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101126:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010112c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101132:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101138:	83 ec 0c             	sub    $0xc,%esp
8010113b:	57                   	push   %edi
8010113c:	e8 df 0d 00 00       	call   80101f20 <iunlockput>
  end_op();
80101141:	e8 5a 21 00 00       	call   801032a0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101146:	83 c4 0c             	add    $0xc,%esp
80101149:	53                   	push   %ebx
8010114a:	56                   	push   %esi
8010114b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101151:	56                   	push   %esi
80101152:	e8 e9 5f 00 00       	call   80107140 <allocuvm>
80101157:	83 c4 10             	add    $0x10,%esp
8010115a:	89 c7                	mov    %eax,%edi
8010115c:	85 c0                	test   %eax,%eax
8010115e:	0f 84 86 00 00 00    	je     801011ea <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101164:	83 ec 08             	sub    $0x8,%esp
80101167:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010116d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010116f:	50                   	push   %eax
80101170:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101171:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101173:	e8 38 62 00 00       	call   801073b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101178:	8b 45 0c             	mov    0xc(%ebp),%eax
8010117b:	83 c4 10             	add    $0x10,%esp
8010117e:	8b 10                	mov    (%eax),%edx
80101180:	85 d2                	test   %edx,%edx
80101182:	0f 84 56 01 00 00    	je     801012de <exec+0x33e>
80101188:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010118e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101191:	eb 23                	jmp    801011b6 <exec+0x216>
80101193:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101198:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010119b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
801011a2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
801011a8:	8b 14 87             	mov    (%edi,%eax,4),%edx
801011ab:	85 d2                	test   %edx,%edx
801011ad:	74 51                	je     80101200 <exec+0x260>
    if(argc >= MAXARG)
801011af:	83 f8 20             	cmp    $0x20,%eax
801011b2:	74 36                	je     801011ea <exec+0x24a>
801011b4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011b6:	83 ec 0c             	sub    $0xc,%esp
801011b9:	52                   	push   %edx
801011ba:	e8 c1 3b 00 00       	call   80104d80 <strlen>
801011bf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011c1:	58                   	pop    %eax
801011c2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011c5:	83 eb 01             	sub    $0x1,%ebx
801011c8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011cb:	e8 b0 3b 00 00       	call   80104d80 <strlen>
801011d0:	83 c0 01             	add    $0x1,%eax
801011d3:	50                   	push   %eax
801011d4:	ff 34 b7             	push   (%edi,%esi,4)
801011d7:	53                   	push   %ebx
801011d8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011de:	e8 9d 63 00 00       	call   80107580 <copyout>
801011e3:	83 c4 20             	add    $0x20,%esp
801011e6:	85 c0                	test   %eax,%eax
801011e8:	79 ae                	jns    80101198 <exec+0x1f8>
    freevm(pgdir);
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011f3:	e8 98 60 00 00       	call   80107290 <freevm>
801011f8:	83 c4 10             	add    $0x10,%esp
801011fb:	e9 0c ff ff ff       	jmp    8010110c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101200:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80101207:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
8010120d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101213:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80101216:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80101219:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101220:	00 00 00 00 
  ustack[1] = argc;
80101224:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010122a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101231:	ff ff ff 
  ustack[1] = argc;
80101234:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010123a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010123c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010123e:	29 d0                	sub    %edx,%eax
80101240:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101246:	56                   	push   %esi
80101247:	51                   	push   %ecx
80101248:	53                   	push   %ebx
80101249:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010124f:	e8 2c 63 00 00       	call   80107580 <copyout>
80101254:	83 c4 10             	add    $0x10,%esp
80101257:	85 c0                	test   %eax,%eax
80101259:	78 8f                	js     801011ea <exec+0x24a>
  for(last=s=path; *s; s++)
8010125b:	8b 45 08             	mov    0x8(%ebp),%eax
8010125e:	8b 55 08             	mov    0x8(%ebp),%edx
80101261:	0f b6 00             	movzbl (%eax),%eax
80101264:	84 c0                	test   %al,%al
80101266:	74 17                	je     8010127f <exec+0x2df>
80101268:	89 d1                	mov    %edx,%ecx
8010126a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101270:	83 c1 01             	add    $0x1,%ecx
80101273:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101275:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101278:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010127b:	84 c0                	test   %al,%al
8010127d:	75 f1                	jne    80101270 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010127f:	83 ec 04             	sub    $0x4,%esp
80101282:	6a 10                	push   $0x10
80101284:	52                   	push   %edx
80101285:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010128b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010128e:	50                   	push   %eax
8010128f:	e8 ac 3a 00 00       	call   80104d40 <safestrcpy>
  curproc->pgdir = pgdir;
80101294:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010129a:	89 f0                	mov    %esi,%eax
8010129c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010129f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
801012a1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801012a4:	89 c1                	mov    %eax,%ecx
801012a6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801012ac:	8b 40 18             	mov    0x18(%eax),%eax
801012af:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801012b2:	8b 41 18             	mov    0x18(%ecx),%eax
801012b5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801012b8:	89 0c 24             	mov    %ecx,(%esp)
801012bb:	e8 20 5c 00 00       	call   80106ee0 <switchuvm>
  freevm(oldpgdir);
801012c0:	89 34 24             	mov    %esi,(%esp)
801012c3:	e8 c8 5f 00 00       	call   80107290 <freevm>
  return 0;
801012c8:	83 c4 10             	add    $0x10,%esp
801012cb:	31 c0                	xor    %eax,%eax
801012cd:	e9 3f fe ff ff       	jmp    80101111 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012d2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801012d7:	31 f6                	xor    %esi,%esi
801012d9:	e9 5a fe ff ff       	jmp    80101138 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801012de:	be 10 00 00 00       	mov    $0x10,%esi
801012e3:	ba 04 00 00 00       	mov    $0x4,%edx
801012e8:	b8 03 00 00 00       	mov    $0x3,%eax
801012ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801012f4:	00 00 00 
801012f7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801012fd:	e9 17 ff ff ff       	jmp    80101219 <exec+0x279>
    end_op();
80101302:	e8 99 1f 00 00       	call   801032a0 <end_op>
    cprintf("exec: fail\n");
80101307:	83 ec 0c             	sub    $0xc,%esp
8010130a:	68 d0 76 10 80       	push   $0x801076d0
8010130f:	e8 4c f4 ff ff       	call   80100760 <cprintf>
    return -1;
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	e9 f0 fd ff ff       	jmp    8010110c <exec+0x16c>
8010131c:	66 90                	xchg   %ax,%ax
8010131e:	66 90                	xchg   %ax,%ax

80101320 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101326:	68 dc 76 10 80       	push   $0x801076dc
8010132b:	68 60 ff 10 80       	push   $0x8010ff60
80101330:	e8 6b 35 00 00       	call   801048a0 <initlock>
}
80101335:	83 c4 10             	add    $0x10,%esp
80101338:	c9                   	leave
80101339:	c3                   	ret
8010133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101340 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101344:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80101349:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010134c:	68 60 ff 10 80       	push   $0x8010ff60
80101351:	e8 3a 37 00 00       	call   80104a90 <acquire>
80101356:	83 c4 10             	add    $0x10,%esp
80101359:	eb 10                	jmp    8010136b <filealloc+0x2b>
8010135b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101360:	83 c3 18             	add    $0x18,%ebx
80101363:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80101369:	74 25                	je     80101390 <filealloc+0x50>
    if(f->ref == 0){
8010136b:	8b 43 04             	mov    0x4(%ebx),%eax
8010136e:	85 c0                	test   %eax,%eax
80101370:	75 ee                	jne    80101360 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101372:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101375:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010137c:	68 60 ff 10 80       	push   $0x8010ff60
80101381:	e8 aa 36 00 00       	call   80104a30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101386:	89 d8                	mov    %ebx,%eax
      return f;
80101388:	83 c4 10             	add    $0x10,%esp
}
8010138b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010138e:	c9                   	leave
8010138f:	c3                   	ret
  release(&ftable.lock);
80101390:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101393:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101395:	68 60 ff 10 80       	push   $0x8010ff60
8010139a:	e8 91 36 00 00       	call   80104a30 <release>
}
8010139f:	89 d8                	mov    %ebx,%eax
  return 0;
801013a1:	83 c4 10             	add    $0x10,%esp
}
801013a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013a7:	c9                   	leave
801013a8:	c3                   	ret
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	53                   	push   %ebx
801013b4:	83 ec 10             	sub    $0x10,%esp
801013b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801013ba:	68 60 ff 10 80       	push   $0x8010ff60
801013bf:	e8 cc 36 00 00       	call   80104a90 <acquire>
  if(f->ref < 1)
801013c4:	8b 43 04             	mov    0x4(%ebx),%eax
801013c7:	83 c4 10             	add    $0x10,%esp
801013ca:	85 c0                	test   %eax,%eax
801013cc:	7e 1a                	jle    801013e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801013ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801013d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801013d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801013d7:	68 60 ff 10 80       	push   $0x8010ff60
801013dc:	e8 4f 36 00 00       	call   80104a30 <release>
  return f;
}
801013e1:	89 d8                	mov    %ebx,%eax
801013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013e6:	c9                   	leave
801013e7:	c3                   	ret
    panic("filedup");
801013e8:	83 ec 0c             	sub    $0xc,%esp
801013eb:	68 e3 76 10 80       	push   $0x801076e3
801013f0:	e8 7b ef ff ff       	call   80100370 <panic>
801013f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013fc:	00 
801013fd:	8d 76 00             	lea    0x0(%esi),%esi

80101400 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	53                   	push   %ebx
80101406:	83 ec 28             	sub    $0x28,%esp
80101409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010140c:	68 60 ff 10 80       	push   $0x8010ff60
80101411:	e8 7a 36 00 00       	call   80104a90 <acquire>
  if(f->ref < 1)
80101416:	8b 53 04             	mov    0x4(%ebx),%edx
80101419:	83 c4 10             	add    $0x10,%esp
8010141c:	85 d2                	test   %edx,%edx
8010141e:	0f 8e a5 00 00 00    	jle    801014c9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101424:	83 ea 01             	sub    $0x1,%edx
80101427:	89 53 04             	mov    %edx,0x4(%ebx)
8010142a:	75 44                	jne    80101470 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010142c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101430:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101433:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101435:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010143b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010143e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101441:	8b 43 10             	mov    0x10(%ebx),%eax
80101444:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101447:	68 60 ff 10 80       	push   $0x8010ff60
8010144c:	e8 df 35 00 00       	call   80104a30 <release>

  if(ff.type == FD_PIPE)
80101451:	83 c4 10             	add    $0x10,%esp
80101454:	83 ff 01             	cmp    $0x1,%edi
80101457:	74 57                	je     801014b0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101459:	83 ff 02             	cmp    $0x2,%edi
8010145c:	74 2a                	je     80101488 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010145e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101461:	5b                   	pop    %ebx
80101462:	5e                   	pop    %esi
80101463:	5f                   	pop    %edi
80101464:	5d                   	pop    %ebp
80101465:	c3                   	ret
80101466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010146d:	00 
8010146e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101470:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147a:	5b                   	pop    %ebx
8010147b:	5e                   	pop    %esi
8010147c:	5f                   	pop    %edi
8010147d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010147e:	e9 ad 35 00 00       	jmp    80104a30 <release>
80101483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101488:	e8 a3 1d 00 00       	call   80103230 <begin_op>
    iput(ff.ip);
8010148d:	83 ec 0c             	sub    $0xc,%esp
80101490:	ff 75 e0             	push   -0x20(%ebp)
80101493:	e8 28 09 00 00       	call   80101dc0 <iput>
    end_op();
80101498:	83 c4 10             	add    $0x10,%esp
}
8010149b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149e:	5b                   	pop    %ebx
8010149f:	5e                   	pop    %esi
801014a0:	5f                   	pop    %edi
801014a1:	5d                   	pop    %ebp
    end_op();
801014a2:	e9 f9 1d 00 00       	jmp    801032a0 <end_op>
801014a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014ae:	00 
801014af:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
801014b0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014b4:	83 ec 08             	sub    $0x8,%esp
801014b7:	53                   	push   %ebx
801014b8:	56                   	push   %esi
801014b9:	e8 32 25 00 00       	call   801039f0 <pipeclose>
801014be:	83 c4 10             	add    $0x10,%esp
}
801014c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c4:	5b                   	pop    %ebx
801014c5:	5e                   	pop    %esi
801014c6:	5f                   	pop    %edi
801014c7:	5d                   	pop    %ebp
801014c8:	c3                   	ret
    panic("fileclose");
801014c9:	83 ec 0c             	sub    $0xc,%esp
801014cc:	68 eb 76 10 80       	push   $0x801076eb
801014d1:	e8 9a ee ff ff       	call   80100370 <panic>
801014d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014dd:	00 
801014de:	66 90                	xchg   %ax,%ax

801014e0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	53                   	push   %ebx
801014e4:	83 ec 04             	sub    $0x4,%esp
801014e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801014ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801014ed:	75 31                	jne    80101520 <filestat+0x40>
    ilock(f->ip);
801014ef:	83 ec 0c             	sub    $0xc,%esp
801014f2:	ff 73 10             	push   0x10(%ebx)
801014f5:	e8 96 07 00 00       	call   80101c90 <ilock>
    stati(f->ip, st);
801014fa:	58                   	pop    %eax
801014fb:	5a                   	pop    %edx
801014fc:	ff 75 0c             	push   0xc(%ebp)
801014ff:	ff 73 10             	push   0x10(%ebx)
80101502:	e8 69 0a 00 00       	call   80101f70 <stati>
    iunlock(f->ip);
80101507:	59                   	pop    %ecx
80101508:	ff 73 10             	push   0x10(%ebx)
8010150b:	e8 60 08 00 00       	call   80101d70 <iunlock>
    return 0;
  }
  return -1;
}
80101510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101513:	83 c4 10             	add    $0x10,%esp
80101516:	31 c0                	xor    %eax,%eax
}
80101518:	c9                   	leave
80101519:	c3                   	ret
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101528:	c9                   	leave
80101529:	c3                   	ret
8010152a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101530 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 0c             	sub    $0xc,%esp
80101539:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010153c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010153f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101542:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101546:	74 60                	je     801015a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101548:	8b 03                	mov    (%ebx),%eax
8010154a:	83 f8 01             	cmp    $0x1,%eax
8010154d:	74 41                	je     80101590 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010154f:	83 f8 02             	cmp    $0x2,%eax
80101552:	75 5b                	jne    801015af <fileread+0x7f>
    ilock(f->ip);
80101554:	83 ec 0c             	sub    $0xc,%esp
80101557:	ff 73 10             	push   0x10(%ebx)
8010155a:	e8 31 07 00 00       	call   80101c90 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010155f:	57                   	push   %edi
80101560:	ff 73 14             	push   0x14(%ebx)
80101563:	56                   	push   %esi
80101564:	ff 73 10             	push   0x10(%ebx)
80101567:	e8 34 0a 00 00       	call   80101fa0 <readi>
8010156c:	83 c4 20             	add    $0x20,%esp
8010156f:	89 c6                	mov    %eax,%esi
80101571:	85 c0                	test   %eax,%eax
80101573:	7e 03                	jle    80101578 <fileread+0x48>
      f->off += r;
80101575:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101578:	83 ec 0c             	sub    $0xc,%esp
8010157b:	ff 73 10             	push   0x10(%ebx)
8010157e:	e8 ed 07 00 00       	call   80101d70 <iunlock>
    return r;
80101583:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101589:	89 f0                	mov    %esi,%eax
8010158b:	5b                   	pop    %ebx
8010158c:	5e                   	pop    %esi
8010158d:	5f                   	pop    %edi
8010158e:	5d                   	pop    %ebp
8010158f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101590:	8b 43 0c             	mov    0xc(%ebx),%eax
80101593:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101599:	5b                   	pop    %ebx
8010159a:	5e                   	pop    %esi
8010159b:	5f                   	pop    %edi
8010159c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010159d:	e9 0e 26 00 00       	jmp    80103bb0 <piperead>
801015a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801015a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801015ad:	eb d7                	jmp    80101586 <fileread+0x56>
  panic("fileread");
801015af:	83 ec 0c             	sub    $0xc,%esp
801015b2:	68 f5 76 10 80       	push   $0x801076f5
801015b7:	e8 b4 ed ff ff       	call   80100370 <panic>
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 1c             	sub    $0x1c,%esp
801015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801015cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801015d2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801015d5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801015d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801015dc:	0f 84 bb 00 00 00    	je     8010169d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801015e2:	8b 03                	mov    (%ebx),%eax
801015e4:	83 f8 01             	cmp    $0x1,%eax
801015e7:	0f 84 bf 00 00 00    	je     801016ac <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015ed:	83 f8 02             	cmp    $0x2,%eax
801015f0:	0f 85 c8 00 00 00    	jne    801016be <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015f9:	31 f6                	xor    %esi,%esi
    while(i < n){
801015fb:	85 c0                	test   %eax,%eax
801015fd:	7f 30                	jg     8010162f <filewrite+0x6f>
801015ff:	e9 94 00 00 00       	jmp    80101698 <filewrite+0xd8>
80101604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101608:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010160b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010160e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101611:	ff 73 10             	push   0x10(%ebx)
80101614:	e8 57 07 00 00       	call   80101d70 <iunlock>
      end_op();
80101619:	e8 82 1c 00 00       	call   801032a0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010161e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101621:	83 c4 10             	add    $0x10,%esp
80101624:	39 c7                	cmp    %eax,%edi
80101626:	75 5c                	jne    80101684 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101628:	01 fe                	add    %edi,%esi
    while(i < n){
8010162a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010162d:	7e 69                	jle    80101698 <filewrite+0xd8>
      int n1 = n - i;
8010162f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101632:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101637:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101639:	39 c7                	cmp    %eax,%edi
8010163b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010163e:	e8 ed 1b 00 00       	call   80103230 <begin_op>
      ilock(f->ip);
80101643:	83 ec 0c             	sub    $0xc,%esp
80101646:	ff 73 10             	push   0x10(%ebx)
80101649:	e8 42 06 00 00       	call   80101c90 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010164e:	57                   	push   %edi
8010164f:	ff 73 14             	push   0x14(%ebx)
80101652:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101655:	01 f0                	add    %esi,%eax
80101657:	50                   	push   %eax
80101658:	ff 73 10             	push   0x10(%ebx)
8010165b:	e8 40 0a 00 00       	call   801020a0 <writei>
80101660:	83 c4 20             	add    $0x20,%esp
80101663:	85 c0                	test   %eax,%eax
80101665:	7f a1                	jg     80101608 <filewrite+0x48>
80101667:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010166a:	83 ec 0c             	sub    $0xc,%esp
8010166d:	ff 73 10             	push   0x10(%ebx)
80101670:	e8 fb 06 00 00       	call   80101d70 <iunlock>
      end_op();
80101675:	e8 26 1c 00 00       	call   801032a0 <end_op>
      if(r < 0)
8010167a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010167d:	83 c4 10             	add    $0x10,%esp
80101680:	85 c0                	test   %eax,%eax
80101682:	75 14                	jne    80101698 <filewrite+0xd8>
        panic("short filewrite");
80101684:	83 ec 0c             	sub    $0xc,%esp
80101687:	68 fe 76 10 80       	push   $0x801076fe
8010168c:	e8 df ec ff ff       	call   80100370 <panic>
80101691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101698:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010169b:	74 05                	je     801016a2 <filewrite+0xe2>
8010169d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801016a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a5:	89 f0                	mov    %esi,%eax
801016a7:	5b                   	pop    %ebx
801016a8:	5e                   	pop    %esi
801016a9:	5f                   	pop    %edi
801016aa:	5d                   	pop    %ebp
801016ab:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801016ac:	8b 43 0c             	mov    0xc(%ebx),%eax
801016af:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016b5:	5b                   	pop    %ebx
801016b6:	5e                   	pop    %esi
801016b7:	5f                   	pop    %edi
801016b8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801016b9:	e9 d2 23 00 00       	jmp    80103a90 <pipewrite>
  panic("filewrite");
801016be:	83 ec 0c             	sub    $0xc,%esp
801016c1:	68 04 77 10 80       	push   $0x80107704
801016c6:	e8 a5 ec ff ff       	call   80100370 <panic>
801016cb:	66 90                	xchg   %ax,%ax
801016cd:	66 90                	xchg   %ax,%ax
801016cf:	90                   	nop

801016d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	57                   	push   %edi
801016d4:	56                   	push   %esi
801016d5:	53                   	push   %ebx
801016d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016d9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801016df:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016e2:	85 c9                	test   %ecx,%ecx
801016e4:	0f 84 8c 00 00 00    	je     80101776 <balloc+0xa6>
801016ea:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801016ec:	89 f8                	mov    %edi,%eax
801016ee:	83 ec 08             	sub    $0x8,%esp
801016f1:	89 fe                	mov    %edi,%esi
801016f3:	c1 f8 0c             	sar    $0xc,%eax
801016f6:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801016fc:	50                   	push   %eax
801016fd:	ff 75 dc             	push   -0x24(%ebp)
80101700:	e8 cb e9 ff ff       	call   801000d0 <bread>
80101705:	83 c4 10             	add    $0x10,%esp
80101708:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010170b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010170e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101713:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101716:	31 c0                	xor    %eax,%eax
80101718:	eb 32                	jmp    8010174c <balloc+0x7c>
8010171a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101720:	89 c1                	mov    %eax,%ecx
80101722:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101727:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010172a:	83 e1 07             	and    $0x7,%ecx
8010172d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010172f:	89 c1                	mov    %eax,%ecx
80101731:	c1 f9 03             	sar    $0x3,%ecx
80101734:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101739:	89 fa                	mov    %edi,%edx
8010173b:	85 df                	test   %ebx,%edi
8010173d:	74 49                	je     80101788 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010173f:	83 c0 01             	add    $0x1,%eax
80101742:	83 c6 01             	add    $0x1,%esi
80101745:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010174a:	74 07                	je     80101753 <balloc+0x83>
8010174c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010174f:	39 d6                	cmp    %edx,%esi
80101751:	72 cd                	jb     80101720 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101753:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101756:	83 ec 0c             	sub    $0xc,%esp
80101759:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010175c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101762:	e8 89 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101767:	83 c4 10             	add    $0x10,%esp
8010176a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101770:	0f 82 76 ff ff ff    	jb     801016ec <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101776:	83 ec 0c             	sub    $0xc,%esp
80101779:	68 0e 77 10 80       	push   $0x8010770e
8010177e:	e8 ed eb ff ff       	call   80100370 <panic>
80101783:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101788:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010178b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010178e:	09 da                	or     %ebx,%edx
80101790:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101794:	57                   	push   %edi
80101795:	e8 76 1c 00 00       	call   80103410 <log_write>
        brelse(bp);
8010179a:	89 3c 24             	mov    %edi,(%esp)
8010179d:	e8 4e ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017a2:	58                   	pop    %eax
801017a3:	5a                   	pop    %edx
801017a4:	56                   	push   %esi
801017a5:	ff 75 dc             	push   -0x24(%ebp)
801017a8:	e8 23 e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017ad:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017b0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017b2:	8d 40 5c             	lea    0x5c(%eax),%eax
801017b5:	68 00 02 00 00       	push   $0x200
801017ba:	6a 00                	push   $0x0
801017bc:	50                   	push   %eax
801017bd:	e8 ce 33 00 00       	call   80104b90 <memset>
  log_write(bp);
801017c2:	89 1c 24             	mov    %ebx,(%esp)
801017c5:	e8 46 1c 00 00       	call   80103410 <log_write>
  brelse(bp);
801017ca:	89 1c 24             	mov    %ebx,(%esp)
801017cd:	e8 1e ea ff ff       	call   801001f0 <brelse>
}
801017d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017d5:	89 f0                	mov    %esi,%eax
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5f                   	pop    %edi
801017da:	5d                   	pop    %ebp
801017db:	c3                   	ret
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801017e4:	31 ff                	xor    %edi,%edi
{
801017e6:	56                   	push   %esi
801017e7:	89 c6                	mov    %eax,%esi
801017e9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ea:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801017ef:	83 ec 28             	sub    $0x28,%esp
801017f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801017f5:	68 60 09 11 80       	push   $0x80110960
801017fa:	e8 91 32 00 00       	call   80104a90 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101802:	83 c4 10             	add    $0x10,%esp
80101805:	eb 1b                	jmp    80101822 <iget+0x42>
80101807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010180e:	00 
8010180f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101810:	39 33                	cmp    %esi,(%ebx)
80101812:	74 6c                	je     80101880 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101814:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010181a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101820:	74 26                	je     80101848 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101822:	8b 43 08             	mov    0x8(%ebx),%eax
80101825:	85 c0                	test   %eax,%eax
80101827:	7f e7                	jg     80101810 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101829:	85 ff                	test   %edi,%edi
8010182b:	75 e7                	jne    80101814 <iget+0x34>
8010182d:	85 c0                	test   %eax,%eax
8010182f:	75 76                	jne    801018a7 <iget+0xc7>
      empty = ip;
80101831:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101833:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101839:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010183f:	75 e1                	jne    80101822 <iget+0x42>
80101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101848:	85 ff                	test   %edi,%edi
8010184a:	74 79                	je     801018c5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010184c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010184f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101851:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101854:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010185b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101862:	68 60 09 11 80       	push   $0x80110960
80101867:	e8 c4 31 00 00       	call   80104a30 <release>

  return ip;
8010186c:	83 c4 10             	add    $0x10,%esp
}
8010186f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101872:	89 f8                	mov    %edi,%eax
80101874:	5b                   	pop    %ebx
80101875:	5e                   	pop    %esi
80101876:	5f                   	pop    %edi
80101877:	5d                   	pop    %ebp
80101878:	c3                   	ret
80101879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101880:	39 53 04             	cmp    %edx,0x4(%ebx)
80101883:	75 8f                	jne    80101814 <iget+0x34>
      ip->ref++;
80101885:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101888:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010188b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010188d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101890:	68 60 09 11 80       	push   $0x80110960
80101895:	e8 96 31 00 00       	call   80104a30 <release>
      return ip;
8010189a:	83 c4 10             	add    $0x10,%esp
}
8010189d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a0:	89 f8                	mov    %edi,%eax
801018a2:	5b                   	pop    %ebx
801018a3:	5e                   	pop    %esi
801018a4:	5f                   	pop    %edi
801018a5:	5d                   	pop    %ebp
801018a6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018a7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ad:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801018b3:	74 10                	je     801018c5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018b5:	8b 43 08             	mov    0x8(%ebx),%eax
801018b8:	85 c0                	test   %eax,%eax
801018ba:	0f 8f 50 ff ff ff    	jg     80101810 <iget+0x30>
801018c0:	e9 68 ff ff ff       	jmp    8010182d <iget+0x4d>
    panic("iget: no inodes");
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	68 24 77 10 80       	push   $0x80107724
801018cd:	e8 9e ea ff ff       	call   80100370 <panic>
801018d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018d9:	00 
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018e0 <bfree>:
{
801018e0:	55                   	push   %ebp
801018e1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801018e3:	89 d0                	mov    %edx,%eax
801018e5:	c1 e8 0c             	shr    $0xc,%eax
{
801018e8:	89 e5                	mov    %esp,%ebp
801018ea:	56                   	push   %esi
801018eb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801018ec:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801018f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801018f4:	83 ec 08             	sub    $0x8,%esp
801018f7:	50                   	push   %eax
801018f8:	51                   	push   %ecx
801018f9:	e8 d2 e7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801018fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101900:	c1 fb 03             	sar    $0x3,%ebx
80101903:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101906:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101908:	83 e1 07             	and    $0x7,%ecx
8010190b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101910:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101916:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101918:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010191d:	85 c1                	test   %eax,%ecx
8010191f:	74 23                	je     80101944 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101921:	f7 d0                	not    %eax
  log_write(bp);
80101923:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101926:	21 c8                	and    %ecx,%eax
80101928:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010192c:	56                   	push   %esi
8010192d:	e8 de 1a 00 00       	call   80103410 <log_write>
  brelse(bp);
80101932:	89 34 24             	mov    %esi,(%esp)
80101935:	e8 b6 e8 ff ff       	call   801001f0 <brelse>
}
8010193a:	83 c4 10             	add    $0x10,%esp
8010193d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101940:	5b                   	pop    %ebx
80101941:	5e                   	pop    %esi
80101942:	5d                   	pop    %ebp
80101943:	c3                   	ret
    panic("freeing free block");
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	68 34 77 10 80       	push   $0x80107734
8010194c:	e8 1f ea ff ff       	call   80100370 <panic>
80101951:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101958:	00 
80101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101960 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	89 c6                	mov    %eax,%esi
80101967:	53                   	push   %ebx
80101968:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010196b:	83 fa 0b             	cmp    $0xb,%edx
8010196e:	0f 86 8c 00 00 00    	jbe    80101a00 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101974:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101977:	83 fb 7f             	cmp    $0x7f,%ebx
8010197a:	0f 87 a2 00 00 00    	ja     80101a22 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101980:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101986:	85 c0                	test   %eax,%eax
80101988:	74 5e                	je     801019e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010198a:	83 ec 08             	sub    $0x8,%esp
8010198d:	50                   	push   %eax
8010198e:	ff 36                	push   (%esi)
80101990:	e8 3b e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101995:	83 c4 10             	add    $0x10,%esp
80101998:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010199c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010199e:	8b 3b                	mov    (%ebx),%edi
801019a0:	85 ff                	test   %edi,%edi
801019a2:	74 1c                	je     801019c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	52                   	push   %edx
801019a8:	e8 43 e8 ff ff       	call   801001f0 <brelse>
801019ad:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801019b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b3:	89 f8                	mov    %edi,%eax
801019b5:	5b                   	pop    %ebx
801019b6:	5e                   	pop    %esi
801019b7:	5f                   	pop    %edi
801019b8:	5d                   	pop    %ebp
801019b9:	c3                   	ret
801019ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801019c3:	8b 06                	mov    (%esi),%eax
801019c5:	e8 06 fd ff ff       	call   801016d0 <balloc>
      log_write(bp);
801019ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801019d0:	89 03                	mov    %eax,(%ebx)
801019d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801019d4:	52                   	push   %edx
801019d5:	e8 36 1a 00 00       	call   80103410 <log_write>
801019da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019dd:	83 c4 10             	add    $0x10,%esp
801019e0:	eb c2                	jmp    801019a4 <bmap+0x44>
801019e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801019e8:	8b 06                	mov    (%esi),%eax
801019ea:	e8 e1 fc ff ff       	call   801016d0 <balloc>
801019ef:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801019f5:	eb 93                	jmp    8010198a <bmap+0x2a>
801019f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019fe:	00 
801019ff:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101a00:	8d 5a 14             	lea    0x14(%edx),%ebx
80101a03:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101a07:	85 ff                	test   %edi,%edi
80101a09:	75 a5                	jne    801019b0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a0b:	8b 00                	mov    (%eax),%eax
80101a0d:	e8 be fc ff ff       	call   801016d0 <balloc>
80101a12:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101a16:	89 c7                	mov    %eax,%edi
}
80101a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1b:	5b                   	pop    %ebx
80101a1c:	89 f8                	mov    %edi,%eax
80101a1e:	5e                   	pop    %esi
80101a1f:	5f                   	pop    %edi
80101a20:	5d                   	pop    %ebp
80101a21:	c3                   	ret
  panic("bmap: out of range");
80101a22:	83 ec 0c             	sub    $0xc,%esp
80101a25:	68 47 77 10 80       	push   $0x80107747
80101a2a:	e8 41 e9 ff ff       	call   80100370 <panic>
80101a2f:	90                   	nop

80101a30 <readsb>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a38:	83 ec 08             	sub    $0x8,%esp
80101a3b:	6a 01                	push   $0x1
80101a3d:	ff 75 08             	push   0x8(%ebp)
80101a40:	e8 8b e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a45:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a48:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a4a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a4d:	6a 1c                	push   $0x1c
80101a4f:	50                   	push   %eax
80101a50:	56                   	push   %esi
80101a51:	e8 ca 31 00 00       	call   80104c20 <memmove>
  brelse(bp);
80101a56:	83 c4 10             	add    $0x10,%esp
80101a59:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a5f:	5b                   	pop    %ebx
80101a60:	5e                   	pop    %esi
80101a61:	5d                   	pop    %ebp
  brelse(bp);
80101a62:	e9 89 e7 ff ff       	jmp    801001f0 <brelse>
80101a67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a6e:	00 
80101a6f:	90                   	nop

80101a70 <iinit>:
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	53                   	push   %ebx
80101a74:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101a79:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a7c:	68 5a 77 10 80       	push   $0x8010775a
80101a81:	68 60 09 11 80       	push   $0x80110960
80101a86:	e8 15 2e 00 00       	call   801048a0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a8b:	83 c4 10             	add    $0x10,%esp
80101a8e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a90:	83 ec 08             	sub    $0x8,%esp
80101a93:	68 61 77 10 80       	push   $0x80107761
80101a98:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a99:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a9f:	e8 cc 2c 00 00       	call   80104770 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101aa4:	83 c4 10             	add    $0x10,%esp
80101aa7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
80101aad:	75 e1                	jne    80101a90 <iinit+0x20>
  bp = bread(dev, 1);
80101aaf:	83 ec 08             	sub    $0x8,%esp
80101ab2:	6a 01                	push   $0x1
80101ab4:	ff 75 08             	push   0x8(%ebp)
80101ab7:	e8 14 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101abc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101abf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101ac1:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ac4:	6a 1c                	push   $0x1c
80101ac6:	50                   	push   %eax
80101ac7:	68 b4 25 11 80       	push   $0x801125b4
80101acc:	e8 4f 31 00 00       	call   80104c20 <memmove>
  brelse(bp);
80101ad1:	89 1c 24             	mov    %ebx,(%esp)
80101ad4:	e8 17 e7 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ad9:	ff 35 cc 25 11 80    	push   0x801125cc
80101adf:	ff 35 c8 25 11 80    	push   0x801125c8
80101ae5:	ff 35 c4 25 11 80    	push   0x801125c4
80101aeb:	ff 35 c0 25 11 80    	push   0x801125c0
80101af1:	ff 35 bc 25 11 80    	push   0x801125bc
80101af7:	ff 35 b8 25 11 80    	push   0x801125b8
80101afd:	ff 35 b4 25 11 80    	push   0x801125b4
80101b03:	68 cc 7b 10 80       	push   $0x80107bcc
80101b08:	e8 53 ec ff ff       	call   80100760 <cprintf>
}
80101b0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b10:	83 c4 30             	add    $0x30,%esp
80101b13:	c9                   	leave
80101b14:	c3                   	ret
80101b15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b1c:	00 
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi

80101b20 <ialloc>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101b2c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101b33:	8b 75 08             	mov    0x8(%ebp),%esi
80101b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b39:	0f 86 91 00 00 00    	jbe    80101bd0 <ialloc+0xb0>
80101b3f:	bf 01 00 00 00       	mov    $0x1,%edi
80101b44:	eb 21                	jmp    80101b67 <ialloc+0x47>
80101b46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b4d:	00 
80101b4e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101b50:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b53:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b56:	53                   	push   %ebx
80101b57:	e8 94 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b5c:	83 c4 10             	add    $0x10,%esp
80101b5f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101b65:	73 69                	jae    80101bd0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b67:	89 f8                	mov    %edi,%eax
80101b69:	83 ec 08             	sub    $0x8,%esp
80101b6c:	c1 e8 03             	shr    $0x3,%eax
80101b6f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101b75:	50                   	push   %eax
80101b76:	56                   	push   %esi
80101b77:	e8 54 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b7c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b7f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b81:	89 f8                	mov    %edi,%eax
80101b83:	83 e0 07             	and    $0x7,%eax
80101b86:	c1 e0 06             	shl    $0x6,%eax
80101b89:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b8d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b91:	75 bd                	jne    80101b50 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b93:	83 ec 04             	sub    $0x4,%esp
80101b96:	6a 40                	push   $0x40
80101b98:	6a 00                	push   $0x0
80101b9a:	51                   	push   %ecx
80101b9b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b9e:	e8 ed 2f 00 00       	call   80104b90 <memset>
      dip->type = type;
80101ba3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ba7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101baa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101bad:	89 1c 24             	mov    %ebx,(%esp)
80101bb0:	e8 5b 18 00 00       	call   80103410 <log_write>
      brelse(bp);
80101bb5:	89 1c 24             	mov    %ebx,(%esp)
80101bb8:	e8 33 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101bbd:	83 c4 10             	add    $0x10,%esp
}
80101bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101bc3:	89 fa                	mov    %edi,%edx
}
80101bc5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101bc6:	89 f0                	mov    %esi,%eax
}
80101bc8:	5e                   	pop    %esi
80101bc9:	5f                   	pop    %edi
80101bca:	5d                   	pop    %ebp
      return iget(dev, inum);
80101bcb:	e9 10 fc ff ff       	jmp    801017e0 <iget>
  panic("ialloc: no inodes");
80101bd0:	83 ec 0c             	sub    $0xc,%esp
80101bd3:	68 67 77 10 80       	push   $0x80107767
80101bd8:	e8 93 e7 ff ff       	call   80100370 <panic>
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi

80101be0 <iupdate>:
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	56                   	push   %esi
80101be4:	53                   	push   %ebx
80101be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101be8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101beb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bee:	83 ec 08             	sub    $0x8,%esp
80101bf1:	c1 e8 03             	shr    $0x3,%eax
80101bf4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101bfa:	50                   	push   %eax
80101bfb:	ff 73 a4             	push   -0x5c(%ebx)
80101bfe:	e8 cd e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101c03:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c07:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c0a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c0c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101c0f:	83 e0 07             	and    $0x7,%eax
80101c12:	c1 e0 06             	shl    $0x6,%eax
80101c15:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101c19:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c1c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c20:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c23:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c27:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c2b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c2f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c33:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c37:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c3a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c3d:	6a 34                	push   $0x34
80101c3f:	53                   	push   %ebx
80101c40:	50                   	push   %eax
80101c41:	e8 da 2f 00 00       	call   80104c20 <memmove>
  log_write(bp);
80101c46:	89 34 24             	mov    %esi,(%esp)
80101c49:	e8 c2 17 00 00       	call   80103410 <log_write>
  brelse(bp);
80101c4e:	83 c4 10             	add    $0x10,%esp
80101c51:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c57:	5b                   	pop    %ebx
80101c58:	5e                   	pop    %esi
80101c59:	5d                   	pop    %ebp
  brelse(bp);
80101c5a:	e9 91 e5 ff ff       	jmp    801001f0 <brelse>
80101c5f:	90                   	nop

80101c60 <idup>:
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	53                   	push   %ebx
80101c64:	83 ec 10             	sub    $0x10,%esp
80101c67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c6a:	68 60 09 11 80       	push   $0x80110960
80101c6f:	e8 1c 2e 00 00       	call   80104a90 <acquire>
  ip->ref++;
80101c74:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c78:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101c7f:	e8 ac 2d 00 00       	call   80104a30 <release>
}
80101c84:	89 d8                	mov    %ebx,%eax
80101c86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c89:	c9                   	leave
80101c8a:	c3                   	ret
80101c8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101c90 <ilock>:
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	56                   	push   %esi
80101c94:	53                   	push   %ebx
80101c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c98:	85 db                	test   %ebx,%ebx
80101c9a:	0f 84 b7 00 00 00    	je     80101d57 <ilock+0xc7>
80101ca0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ca3:	85 d2                	test   %edx,%edx
80101ca5:	0f 8e ac 00 00 00    	jle    80101d57 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	8d 43 0c             	lea    0xc(%ebx),%eax
80101cb1:	50                   	push   %eax
80101cb2:	e8 f9 2a 00 00       	call   801047b0 <acquiresleep>
  if(ip->valid == 0){
80101cb7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101cba:	83 c4 10             	add    $0x10,%esp
80101cbd:	85 c0                	test   %eax,%eax
80101cbf:	74 0f                	je     80101cd0 <ilock+0x40>
}
80101cc1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cc4:	5b                   	pop    %ebx
80101cc5:	5e                   	pop    %esi
80101cc6:	5d                   	pop    %ebp
80101cc7:	c3                   	ret
80101cc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ccf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cd0:	8b 43 04             	mov    0x4(%ebx),%eax
80101cd3:	83 ec 08             	sub    $0x8,%esp
80101cd6:	c1 e8 03             	shr    $0x3,%eax
80101cd9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101cdf:	50                   	push   %eax
80101ce0:	ff 33                	push   (%ebx)
80101ce2:	e8 e9 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ce7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cec:	8b 43 04             	mov    0x4(%ebx),%eax
80101cef:	83 e0 07             	and    $0x7,%eax
80101cf2:	c1 e0 06             	shl    $0x6,%eax
80101cf5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101cf9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cfc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101cff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101d03:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101d07:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101d0b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101d0f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d13:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d17:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d1b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d1e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d21:	6a 34                	push   $0x34
80101d23:	50                   	push   %eax
80101d24:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d27:	50                   	push   %eax
80101d28:	e8 f3 2e 00 00       	call   80104c20 <memmove>
    brelse(bp);
80101d2d:	89 34 24             	mov    %esi,(%esp)
80101d30:	e8 bb e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101d35:	83 c4 10             	add    $0x10,%esp
80101d38:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d3d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d44:	0f 85 77 ff ff ff    	jne    80101cc1 <ilock+0x31>
      panic("ilock: no type");
80101d4a:	83 ec 0c             	sub    $0xc,%esp
80101d4d:	68 7f 77 10 80       	push   $0x8010777f
80101d52:	e8 19 e6 ff ff       	call   80100370 <panic>
    panic("ilock");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 79 77 10 80       	push   $0x80107779
80101d5f:	e8 0c e6 ff ff       	call   80100370 <panic>
80101d64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d6b:	00 
80101d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d70 <iunlock>:
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	56                   	push   %esi
80101d74:	53                   	push   %ebx
80101d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d78:	85 db                	test   %ebx,%ebx
80101d7a:	74 28                	je     80101da4 <iunlock+0x34>
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d82:	56                   	push   %esi
80101d83:	e8 c8 2a 00 00       	call   80104850 <holdingsleep>
80101d88:	83 c4 10             	add    $0x10,%esp
80101d8b:	85 c0                	test   %eax,%eax
80101d8d:	74 15                	je     80101da4 <iunlock+0x34>
80101d8f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d92:	85 c0                	test   %eax,%eax
80101d94:	7e 0e                	jle    80101da4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101d96:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d9c:	5b                   	pop    %ebx
80101d9d:	5e                   	pop    %esi
80101d9e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d9f:	e9 6c 2a 00 00       	jmp    80104810 <releasesleep>
    panic("iunlock");
80101da4:	83 ec 0c             	sub    $0xc,%esp
80101da7:	68 8e 77 10 80       	push   $0x8010778e
80101dac:	e8 bf e5 ff ff       	call   80100370 <panic>
80101db1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101db8:	00 
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <iput>:
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 28             	sub    $0x28,%esp
80101dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101dcc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101dcf:	57                   	push   %edi
80101dd0:	e8 db 29 00 00       	call   801047b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101dd5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101dd8:	83 c4 10             	add    $0x10,%esp
80101ddb:	85 d2                	test   %edx,%edx
80101ddd:	74 07                	je     80101de6 <iput+0x26>
80101ddf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101de4:	74 32                	je     80101e18 <iput+0x58>
  releasesleep(&ip->lock);
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	57                   	push   %edi
80101dea:	e8 21 2a 00 00       	call   80104810 <releasesleep>
  acquire(&icache.lock);
80101def:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101df6:	e8 95 2c 00 00       	call   80104a90 <acquire>
  ip->ref--;
80101dfb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e0c:	5b                   	pop    %ebx
80101e0d:	5e                   	pop    %esi
80101e0e:	5f                   	pop    %edi
80101e0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101e10:	e9 1b 2c 00 00       	jmp    80104a30 <release>
80101e15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101e18:	83 ec 0c             	sub    $0xc,%esp
80101e1b:	68 60 09 11 80       	push   $0x80110960
80101e20:	e8 6b 2c 00 00       	call   80104a90 <acquire>
    int r = ip->ref;
80101e25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e2f:	e8 fc 2b 00 00       	call   80104a30 <release>
    if(r == 1){
80101e34:	83 c4 10             	add    $0x10,%esp
80101e37:	83 fe 01             	cmp    $0x1,%esi
80101e3a:	75 aa                	jne    80101de6 <iput+0x26>
80101e3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e48:	89 df                	mov    %ebx,%edi
80101e4a:	89 cb                	mov    %ecx,%ebx
80101e4c:	eb 09                	jmp    80101e57 <iput+0x97>
80101e4e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e50:	83 c6 04             	add    $0x4,%esi
80101e53:	39 de                	cmp    %ebx,%esi
80101e55:	74 19                	je     80101e70 <iput+0xb0>
    if(ip->addrs[i]){
80101e57:	8b 16                	mov    (%esi),%edx
80101e59:	85 d2                	test   %edx,%edx
80101e5b:	74 f3                	je     80101e50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101e5d:	8b 07                	mov    (%edi),%eax
80101e5f:	e8 7c fa ff ff       	call   801018e0 <bfree>
      ip->addrs[i] = 0;
80101e64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e6a:	eb e4                	jmp    80101e50 <iput+0x90>
80101e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e70:	89 fb                	mov    %edi,%ebx
80101e72:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e75:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e7b:	85 c0                	test   %eax,%eax
80101e7d:	75 2d                	jne    80101eac <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e7f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e82:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e89:	53                   	push   %ebx
80101e8a:	e8 51 fd ff ff       	call   80101be0 <iupdate>
      ip->type = 0;
80101e8f:	31 c0                	xor    %eax,%eax
80101e91:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e95:	89 1c 24             	mov    %ebx,(%esp)
80101e98:	e8 43 fd ff ff       	call   80101be0 <iupdate>
      ip->valid = 0;
80101e9d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ea4:	83 c4 10             	add    $0x10,%esp
80101ea7:	e9 3a ff ff ff       	jmp    80101de6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101eac:	83 ec 08             	sub    $0x8,%esp
80101eaf:	50                   	push   %eax
80101eb0:	ff 33                	push   (%ebx)
80101eb2:	e8 19 e2 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ebd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ec3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ec6:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ec9:	89 cf                	mov    %ecx,%edi
80101ecb:	eb 0a                	jmp    80101ed7 <iput+0x117>
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
80101ed0:	83 c6 04             	add    $0x4,%esi
80101ed3:	39 fe                	cmp    %edi,%esi
80101ed5:	74 0f                	je     80101ee6 <iput+0x126>
      if(a[j])
80101ed7:	8b 16                	mov    (%esi),%edx
80101ed9:	85 d2                	test   %edx,%edx
80101edb:	74 f3                	je     80101ed0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101edd:	8b 03                	mov    (%ebx),%eax
80101edf:	e8 fc f9 ff ff       	call   801018e0 <bfree>
80101ee4:	eb ea                	jmp    80101ed0 <iput+0x110>
    brelse(bp);
80101ee6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ee9:	83 ec 0c             	sub    $0xc,%esp
80101eec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101eef:	50                   	push   %eax
80101ef0:	e8 fb e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ef5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101efb:	8b 03                	mov    (%ebx),%eax
80101efd:	e8 de f9 ff ff       	call   801018e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101f0c:	00 00 00 
80101f0f:	e9 6b ff ff ff       	jmp    80101e7f <iput+0xbf>
80101f14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f1b:	00 
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f20 <iunlockput>:
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	53                   	push   %ebx
80101f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f28:	85 db                	test   %ebx,%ebx
80101f2a:	74 34                	je     80101f60 <iunlockput+0x40>
80101f2c:	83 ec 0c             	sub    $0xc,%esp
80101f2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101f32:	56                   	push   %esi
80101f33:	e8 18 29 00 00       	call   80104850 <holdingsleep>
80101f38:	83 c4 10             	add    $0x10,%esp
80101f3b:	85 c0                	test   %eax,%eax
80101f3d:	74 21                	je     80101f60 <iunlockput+0x40>
80101f3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101f42:	85 c0                	test   %eax,%eax
80101f44:	7e 1a                	jle    80101f60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	56                   	push   %esi
80101f4a:	e8 c1 28 00 00       	call   80104810 <releasesleep>
  iput(ip);
80101f4f:	83 c4 10             	add    $0x10,%esp
80101f52:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f58:	5b                   	pop    %ebx
80101f59:	5e                   	pop    %esi
80101f5a:	5d                   	pop    %ebp
  iput(ip);
80101f5b:	e9 60 fe ff ff       	jmp    80101dc0 <iput>
    panic("iunlock");
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	68 8e 77 10 80       	push   $0x8010778e
80101f68:	e8 03 e4 ff ff       	call   80100370 <panic>
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi

80101f70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	8b 55 08             	mov    0x8(%ebp),%edx
80101f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f79:	8b 0a                	mov    (%edx),%ecx
80101f7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f93:	8b 52 58             	mov    0x58(%edx),%edx
80101f96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f99:	5d                   	pop    %ebp
80101f9a:	c3                   	ret
80101f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fa0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	83 ec 1c             	sub    $0x1c,%esp
80101fa9:	8b 75 08             	mov    0x8(%ebp),%esi
80101fac:	8b 45 0c             	mov    0xc(%ebp),%eax
80101faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fb2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101fb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101fba:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101fbd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101fc0:	0f 84 aa 00 00 00    	je     80102070 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fc6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101fc9:	8b 56 58             	mov    0x58(%esi),%edx
80101fcc:	39 fa                	cmp    %edi,%edx
80101fce:	0f 82 bd 00 00 00    	jb     80102091 <readi+0xf1>
80101fd4:	89 f9                	mov    %edi,%ecx
80101fd6:	31 db                	xor    %ebx,%ebx
80101fd8:	01 c1                	add    %eax,%ecx
80101fda:	0f 92 c3             	setb   %bl
80101fdd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101fe0:	0f 82 ab 00 00 00    	jb     80102091 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fe6:	89 d3                	mov    %edx,%ebx
80101fe8:	29 fb                	sub    %edi,%ebx
80101fea:	39 ca                	cmp    %ecx,%edx
80101fec:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fef:	85 c0                	test   %eax,%eax
80101ff1:	74 73                	je     80102066 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ff3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102000:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102003:	89 fa                	mov    %edi,%edx
80102005:	c1 ea 09             	shr    $0x9,%edx
80102008:	89 d8                	mov    %ebx,%eax
8010200a:	e8 51 f9 ff ff       	call   80101960 <bmap>
8010200f:	83 ec 08             	sub    $0x8,%esp
80102012:	50                   	push   %eax
80102013:	ff 33                	push   (%ebx)
80102015:	e8 b6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010201a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010201d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102022:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102024:	89 f8                	mov    %edi,%eax
80102026:	25 ff 01 00 00       	and    $0x1ff,%eax
8010202b:	29 f3                	sub    %esi,%ebx
8010202d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
8010202f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102033:	39 d9                	cmp    %ebx,%ecx
80102035:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102038:	83 c4 0c             	add    $0xc,%esp
8010203b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010203c:	01 de                	add    %ebx,%esi
8010203e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102040:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102043:	50                   	push   %eax
80102044:	ff 75 e0             	push   -0x20(%ebp)
80102047:	e8 d4 2b 00 00       	call   80104c20 <memmove>
    brelse(bp);
8010204c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010204f:	89 14 24             	mov    %edx,(%esp)
80102052:	e8 99 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102057:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010205a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010205d:	83 c4 10             	add    $0x10,%esp
80102060:	39 de                	cmp    %ebx,%esi
80102062:	72 9c                	jb     80102000 <readi+0x60>
80102064:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102069:	5b                   	pop    %ebx
8010206a:	5e                   	pop    %esi
8010206b:	5f                   	pop    %edi
8010206c:	5d                   	pop    %ebp
8010206d:	c3                   	ret
8010206e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102070:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102074:	66 83 fa 09          	cmp    $0x9,%dx
80102078:	77 17                	ja     80102091 <readi+0xf1>
8010207a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80102081:	85 d2                	test   %edx,%edx
80102083:	74 0c                	je     80102091 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102085:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208b:	5b                   	pop    %ebx
8010208c:	5e                   	pop    %esi
8010208d:	5f                   	pop    %edi
8010208e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010208f:	ff e2                	jmp    *%edx
      return -1;
80102091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102096:	eb ce                	jmp    80102066 <readi+0xc6>
80102098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209f:	00 

801020a0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 1c             	sub    $0x1c,%esp
801020a9:	8b 45 08             	mov    0x8(%ebp),%eax
801020ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
801020af:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020b7:	89 7d dc             	mov    %edi,-0x24(%ebp)
801020ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
801020bd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801020c0:	0f 84 ba 00 00 00    	je     80102180 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020c6:	39 78 58             	cmp    %edi,0x58(%eax)
801020c9:	0f 82 ea 00 00 00    	jb     801021b9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020cf:	8b 75 e0             	mov    -0x20(%ebp),%esi
801020d2:	89 f2                	mov    %esi,%edx
801020d4:	01 fa                	add    %edi,%edx
801020d6:	0f 82 dd 00 00 00    	jb     801021b9 <writei+0x119>
801020dc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801020e2:	0f 87 d1 00 00 00    	ja     801021b9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e8:	85 f6                	test   %esi,%esi
801020ea:	0f 84 85 00 00 00    	je     80102175 <writei+0xd5>
801020f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801020f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102100:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102103:	89 fa                	mov    %edi,%edx
80102105:	c1 ea 09             	shr    $0x9,%edx
80102108:	89 f0                	mov    %esi,%eax
8010210a:	e8 51 f8 ff ff       	call   80101960 <bmap>
8010210f:	83 ec 08             	sub    $0x8,%esp
80102112:	50                   	push   %eax
80102113:	ff 36                	push   (%esi)
80102115:	e8 b6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010211a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010211d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102120:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102125:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102127:	89 f8                	mov    %edi,%eax
80102129:	25 ff 01 00 00       	and    $0x1ff,%eax
8010212e:	29 d3                	sub    %edx,%ebx
80102130:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102132:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102136:	39 d9                	cmp    %ebx,%ecx
80102138:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010213b:	83 c4 0c             	add    $0xc,%esp
8010213e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010213f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102141:	ff 75 dc             	push   -0x24(%ebp)
80102144:	50                   	push   %eax
80102145:	e8 d6 2a 00 00       	call   80104c20 <memmove>
    log_write(bp);
8010214a:	89 34 24             	mov    %esi,(%esp)
8010214d:	e8 be 12 00 00       	call   80103410 <log_write>
    brelse(bp);
80102152:	89 34 24             	mov    %esi,(%esp)
80102155:	e8 96 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010215a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010215d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102169:	39 d8                	cmp    %ebx,%eax
8010216b:	72 93                	jb     80102100 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010216d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102170:	39 78 58             	cmp    %edi,0x58(%eax)
80102173:	72 33                	jb     801021a8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102175:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217b:	5b                   	pop    %ebx
8010217c:	5e                   	pop    %esi
8010217d:	5f                   	pop    %edi
8010217e:	5d                   	pop    %ebp
8010217f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102180:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102184:	66 83 f8 09          	cmp    $0x9,%ax
80102188:	77 2f                	ja     801021b9 <writei+0x119>
8010218a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80102191:	85 c0                	test   %eax,%eax
80102193:	74 24                	je     801021b9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102195:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010219b:	5b                   	pop    %ebx
8010219c:	5e                   	pop    %esi
8010219d:	5f                   	pop    %edi
8010219e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010219f:	ff e0                	jmp    *%eax
801021a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
801021a8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801021ab:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801021ae:	50                   	push   %eax
801021af:	e8 2c fa ff ff       	call   80101be0 <iupdate>
801021b4:	83 c4 10             	add    $0x10,%esp
801021b7:	eb bc                	jmp    80102175 <writei+0xd5>
      return -1;
801021b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021be:	eb b8                	jmp    80102178 <writei+0xd8>

801021c0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021c6:	6a 0e                	push   $0xe
801021c8:	ff 75 0c             	push   0xc(%ebp)
801021cb:	ff 75 08             	push   0x8(%ebp)
801021ce:	e8 bd 2a 00 00       	call   80104c90 <strncmp>
}
801021d3:	c9                   	leave
801021d4:	c3                   	ret
801021d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021dc:	00 
801021dd:	8d 76 00             	lea    0x0(%esi),%esi

801021e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 1c             	sub    $0x1c,%esp
801021e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021f1:	0f 85 85 00 00 00    	jne    8010227c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021f7:	8b 53 58             	mov    0x58(%ebx),%edx
801021fa:	31 ff                	xor    %edi,%edi
801021fc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ff:	85 d2                	test   %edx,%edx
80102201:	74 3e                	je     80102241 <dirlookup+0x61>
80102203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	6a 10                	push   $0x10
8010220a:	57                   	push   %edi
8010220b:	56                   	push   %esi
8010220c:	53                   	push   %ebx
8010220d:	e8 8e fd ff ff       	call   80101fa0 <readi>
80102212:	83 c4 10             	add    $0x10,%esp
80102215:	83 f8 10             	cmp    $0x10,%eax
80102218:	75 55                	jne    8010226f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010221a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010221f:	74 18                	je     80102239 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102221:	83 ec 04             	sub    $0x4,%esp
80102224:	8d 45 da             	lea    -0x26(%ebp),%eax
80102227:	6a 0e                	push   $0xe
80102229:	50                   	push   %eax
8010222a:	ff 75 0c             	push   0xc(%ebp)
8010222d:	e8 5e 2a 00 00       	call   80104c90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102232:	83 c4 10             	add    $0x10,%esp
80102235:	85 c0                	test   %eax,%eax
80102237:	74 17                	je     80102250 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102239:	83 c7 10             	add    $0x10,%edi
8010223c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010223f:	72 c7                	jb     80102208 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102241:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102244:	31 c0                	xor    %eax,%eax
}
80102246:	5b                   	pop    %ebx
80102247:	5e                   	pop    %esi
80102248:	5f                   	pop    %edi
80102249:	5d                   	pop    %ebp
8010224a:	c3                   	ret
8010224b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80102250:	8b 45 10             	mov    0x10(%ebp),%eax
80102253:	85 c0                	test   %eax,%eax
80102255:	74 05                	je     8010225c <dirlookup+0x7c>
        *poff = off;
80102257:	8b 45 10             	mov    0x10(%ebp),%eax
8010225a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010225c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102260:	8b 03                	mov    (%ebx),%eax
80102262:	e8 79 f5 ff ff       	call   801017e0 <iget>
}
80102267:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010226a:	5b                   	pop    %ebx
8010226b:	5e                   	pop    %esi
8010226c:	5f                   	pop    %edi
8010226d:	5d                   	pop    %ebp
8010226e:	c3                   	ret
      panic("dirlookup read");
8010226f:	83 ec 0c             	sub    $0xc,%esp
80102272:	68 a8 77 10 80       	push   $0x801077a8
80102277:	e8 f4 e0 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	68 96 77 10 80       	push   $0x80107796
80102284:	e8 e7 e0 ff ff       	call   80100370 <panic>
80102289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102290 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	89 c3                	mov    %eax,%ebx
80102298:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010229b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010229e:	89 55 dc             	mov    %edx,-0x24(%ebp)
801022a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801022a4:	0f 84 9e 01 00 00    	je     80102448 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022aa:	e8 a1 1b 00 00       	call   80103e50 <myproc>
  acquire(&icache.lock);
801022af:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801022b2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022b5:	68 60 09 11 80       	push   $0x80110960
801022ba:	e8 d1 27 00 00       	call   80104a90 <acquire>
  ip->ref++;
801022bf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022c3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801022ca:	e8 61 27 00 00       	call   80104a30 <release>
801022cf:	83 c4 10             	add    $0x10,%esp
801022d2:	eb 07                	jmp    801022db <namex+0x4b>
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022db:	0f b6 03             	movzbl (%ebx),%eax
801022de:	3c 2f                	cmp    $0x2f,%al
801022e0:	74 f6                	je     801022d8 <namex+0x48>
  if(*path == 0)
801022e2:	84 c0                	test   %al,%al
801022e4:	0f 84 06 01 00 00    	je     801023f0 <namex+0x160>
  while(*path != '/' && *path != 0)
801022ea:	0f b6 03             	movzbl (%ebx),%eax
801022ed:	84 c0                	test   %al,%al
801022ef:	0f 84 10 01 00 00    	je     80102405 <namex+0x175>
801022f5:	89 df                	mov    %ebx,%edi
801022f7:	3c 2f                	cmp    $0x2f,%al
801022f9:	0f 84 06 01 00 00    	je     80102405 <namex+0x175>
801022ff:	90                   	nop
80102300:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102304:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102307:	3c 2f                	cmp    $0x2f,%al
80102309:	74 04                	je     8010230f <namex+0x7f>
8010230b:	84 c0                	test   %al,%al
8010230d:	75 f1                	jne    80102300 <namex+0x70>
  len = path - s;
8010230f:	89 f8                	mov    %edi,%eax
80102311:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102313:	83 f8 0d             	cmp    $0xd,%eax
80102316:	0f 8e ac 00 00 00    	jle    801023c8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010231c:	83 ec 04             	sub    $0x4,%esp
8010231f:	6a 0e                	push   $0xe
80102321:	53                   	push   %ebx
80102322:	89 fb                	mov    %edi,%ebx
80102324:	ff 75 e4             	push   -0x1c(%ebp)
80102327:	e8 f4 28 00 00       	call   80104c20 <memmove>
8010232c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010232f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102332:	75 0c                	jne    80102340 <namex+0xb0>
80102334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102338:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010233b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010233e:	74 f8                	je     80102338 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	56                   	push   %esi
80102344:	e8 47 f9 ff ff       	call   80101c90 <ilock>
    if(ip->type != T_DIR){
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102351:	0f 85 b7 00 00 00    	jne    8010240e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102357:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010235a:	85 c0                	test   %eax,%eax
8010235c:	74 09                	je     80102367 <namex+0xd7>
8010235e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102361:	0f 84 f7 00 00 00    	je     8010245e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102367:	83 ec 04             	sub    $0x4,%esp
8010236a:	6a 00                	push   $0x0
8010236c:	ff 75 e4             	push   -0x1c(%ebp)
8010236f:	56                   	push   %esi
80102370:	e8 6b fe ff ff       	call   801021e0 <dirlookup>
80102375:	83 c4 10             	add    $0x10,%esp
80102378:	89 c7                	mov    %eax,%edi
8010237a:	85 c0                	test   %eax,%eax
8010237c:	0f 84 8c 00 00 00    	je     8010240e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102382:	83 ec 0c             	sub    $0xc,%esp
80102385:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102388:	51                   	push   %ecx
80102389:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010238c:	e8 bf 24 00 00       	call   80104850 <holdingsleep>
80102391:	83 c4 10             	add    $0x10,%esp
80102394:	85 c0                	test   %eax,%eax
80102396:	0f 84 02 01 00 00    	je     8010249e <namex+0x20e>
8010239c:	8b 56 08             	mov    0x8(%esi),%edx
8010239f:	85 d2                	test   %edx,%edx
801023a1:	0f 8e f7 00 00 00    	jle    8010249e <namex+0x20e>
  releasesleep(&ip->lock);
801023a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801023aa:	83 ec 0c             	sub    $0xc,%esp
801023ad:	51                   	push   %ecx
801023ae:	e8 5d 24 00 00       	call   80104810 <releasesleep>
  iput(ip);
801023b3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
801023b6:	89 fe                	mov    %edi,%esi
  iput(ip);
801023b8:	e8 03 fa ff ff       	call   80101dc0 <iput>
801023bd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801023c0:	e9 16 ff ff ff       	jmp    801022db <namex+0x4b>
801023c5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801023c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023cb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
801023ce:	83 ec 04             	sub    $0x4,%esp
801023d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801023d4:	50                   	push   %eax
801023d5:	53                   	push   %ebx
    name[len] = 0;
801023d6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801023d8:	ff 75 e4             	push   -0x1c(%ebp)
801023db:	e8 40 28 00 00       	call   80104c20 <memmove>
    name[len] = 0;
801023e0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	c6 01 00             	movb   $0x0,(%ecx)
801023e9:	e9 41 ff ff ff       	jmp    8010232f <namex+0x9f>
801023ee:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801023f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023f3:	85 c0                	test   %eax,%eax
801023f5:	0f 85 93 00 00 00    	jne    8010248e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801023fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023fe:	89 f0                	mov    %esi,%eax
80102400:	5b                   	pop    %ebx
80102401:	5e                   	pop    %esi
80102402:	5f                   	pop    %edi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret
  while(*path != '/' && *path != 0)
80102405:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102408:	89 df                	mov    %ebx,%edi
8010240a:	31 c0                	xor    %eax,%eax
8010240c:	eb c0                	jmp    801023ce <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010240e:	83 ec 0c             	sub    $0xc,%esp
80102411:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102414:	53                   	push   %ebx
80102415:	e8 36 24 00 00       	call   80104850 <holdingsleep>
8010241a:	83 c4 10             	add    $0x10,%esp
8010241d:	85 c0                	test   %eax,%eax
8010241f:	74 7d                	je     8010249e <namex+0x20e>
80102421:	8b 4e 08             	mov    0x8(%esi),%ecx
80102424:	85 c9                	test   %ecx,%ecx
80102426:	7e 76                	jle    8010249e <namex+0x20e>
  releasesleep(&ip->lock);
80102428:	83 ec 0c             	sub    $0xc,%esp
8010242b:	53                   	push   %ebx
8010242c:	e8 df 23 00 00       	call   80104810 <releasesleep>
  iput(ip);
80102431:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102434:	31 f6                	xor    %esi,%esi
  iput(ip);
80102436:	e8 85 f9 ff ff       	call   80101dc0 <iput>
      return 0;
8010243b:	83 c4 10             	add    $0x10,%esp
}
8010243e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102441:	89 f0                	mov    %esi,%eax
80102443:	5b                   	pop    %ebx
80102444:	5e                   	pop    %esi
80102445:	5f                   	pop    %edi
80102446:	5d                   	pop    %ebp
80102447:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102448:	ba 01 00 00 00       	mov    $0x1,%edx
8010244d:	b8 01 00 00 00       	mov    $0x1,%eax
80102452:	e8 89 f3 ff ff       	call   801017e0 <iget>
80102457:	89 c6                	mov    %eax,%esi
80102459:	e9 7d fe ff ff       	jmp    801022db <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010245e:	83 ec 0c             	sub    $0xc,%esp
80102461:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102464:	53                   	push   %ebx
80102465:	e8 e6 23 00 00       	call   80104850 <holdingsleep>
8010246a:	83 c4 10             	add    $0x10,%esp
8010246d:	85 c0                	test   %eax,%eax
8010246f:	74 2d                	je     8010249e <namex+0x20e>
80102471:	8b 7e 08             	mov    0x8(%esi),%edi
80102474:	85 ff                	test   %edi,%edi
80102476:	7e 26                	jle    8010249e <namex+0x20e>
  releasesleep(&ip->lock);
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	53                   	push   %ebx
8010247c:	e8 8f 23 00 00       	call   80104810 <releasesleep>
}
80102481:	83 c4 10             	add    $0x10,%esp
}
80102484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102487:	89 f0                	mov    %esi,%eax
80102489:	5b                   	pop    %ebx
8010248a:	5e                   	pop    %esi
8010248b:	5f                   	pop    %edi
8010248c:	5d                   	pop    %ebp
8010248d:	c3                   	ret
    iput(ip);
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	56                   	push   %esi
      return 0;
80102492:	31 f6                	xor    %esi,%esi
    iput(ip);
80102494:	e8 27 f9 ff ff       	call   80101dc0 <iput>
    return 0;
80102499:	83 c4 10             	add    $0x10,%esp
8010249c:	eb a0                	jmp    8010243e <namex+0x1ae>
    panic("iunlock");
8010249e:	83 ec 0c             	sub    $0xc,%esp
801024a1:	68 8e 77 10 80       	push   $0x8010778e
801024a6:	e8 c5 de ff ff       	call   80100370 <panic>
801024ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801024b0 <dirlink>:
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 20             	sub    $0x20,%esp
801024b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024bc:	6a 00                	push   $0x0
801024be:	ff 75 0c             	push   0xc(%ebp)
801024c1:	53                   	push   %ebx
801024c2:	e8 19 fd ff ff       	call   801021e0 <dirlookup>
801024c7:	83 c4 10             	add    $0x10,%esp
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 67                	jne    80102535 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024ce:	8b 7b 58             	mov    0x58(%ebx),%edi
801024d1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024d4:	85 ff                	test   %edi,%edi
801024d6:	74 29                	je     80102501 <dirlink+0x51>
801024d8:	31 ff                	xor    %edi,%edi
801024da:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024dd:	eb 09                	jmp    801024e8 <dirlink+0x38>
801024df:	90                   	nop
801024e0:	83 c7 10             	add    $0x10,%edi
801024e3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024e6:	73 19                	jae    80102501 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024e8:	6a 10                	push   $0x10
801024ea:	57                   	push   %edi
801024eb:	56                   	push   %esi
801024ec:	53                   	push   %ebx
801024ed:	e8 ae fa ff ff       	call   80101fa0 <readi>
801024f2:	83 c4 10             	add    $0x10,%esp
801024f5:	83 f8 10             	cmp    $0x10,%eax
801024f8:	75 4e                	jne    80102548 <dirlink+0x98>
    if(de.inum == 0)
801024fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024ff:	75 df                	jne    801024e0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102501:	83 ec 04             	sub    $0x4,%esp
80102504:	8d 45 da             	lea    -0x26(%ebp),%eax
80102507:	6a 0e                	push   $0xe
80102509:	ff 75 0c             	push   0xc(%ebp)
8010250c:	50                   	push   %eax
8010250d:	e8 ce 27 00 00       	call   80104ce0 <strncpy>
  de.inum = inum;
80102512:	8b 45 10             	mov    0x10(%ebp),%eax
80102515:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102519:	6a 10                	push   $0x10
8010251b:	57                   	push   %edi
8010251c:	56                   	push   %esi
8010251d:	53                   	push   %ebx
8010251e:	e8 7d fb ff ff       	call   801020a0 <writei>
80102523:	83 c4 20             	add    $0x20,%esp
80102526:	83 f8 10             	cmp    $0x10,%eax
80102529:	75 2a                	jne    80102555 <dirlink+0xa5>
  return 0;
8010252b:	31 c0                	xor    %eax,%eax
}
8010252d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102530:	5b                   	pop    %ebx
80102531:	5e                   	pop    %esi
80102532:	5f                   	pop    %edi
80102533:	5d                   	pop    %ebp
80102534:	c3                   	ret
    iput(ip);
80102535:	83 ec 0c             	sub    $0xc,%esp
80102538:	50                   	push   %eax
80102539:	e8 82 f8 ff ff       	call   80101dc0 <iput>
    return -1;
8010253e:	83 c4 10             	add    $0x10,%esp
80102541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102546:	eb e5                	jmp    8010252d <dirlink+0x7d>
      panic("dirlink read");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 b7 77 10 80       	push   $0x801077b7
80102550:	e8 1b de ff ff       	call   80100370 <panic>
    panic("dirlink");
80102555:	83 ec 0c             	sub    $0xc,%esp
80102558:	68 13 7a 10 80       	push   $0x80107a13
8010255d:	e8 0e de ff ff       	call   80100370 <panic>
80102562:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102569:	00 
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102570 <namei>:

struct inode*
namei(char *path)
{
80102570:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102571:	31 d2                	xor    %edx,%edx
{
80102573:	89 e5                	mov    %esp,%ebp
80102575:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102578:	8b 45 08             	mov    0x8(%ebp),%eax
8010257b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010257e:	e8 0d fd ff ff       	call   80102290 <namex>
}
80102583:	c9                   	leave
80102584:	c3                   	ret
80102585:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010258c:	00 
8010258d:	8d 76 00             	lea    0x0(%esi),%esi

80102590 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102590:	55                   	push   %ebp
  return namex(path, 1, name);
80102591:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102596:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102598:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010259b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010259e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010259f:	e9 ec fc ff ff       	jmp    80102290 <namex>
801025a4:	66 90                	xchg   %ax,%ax
801025a6:	66 90                	xchg   %ax,%ax
801025a8:	66 90                	xchg   %ax,%ax
801025aa:	66 90                	xchg   %ax,%ax
801025ac:	66 90                	xchg   %ax,%ax
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	57                   	push   %edi
801025b4:	56                   	push   %esi
801025b5:	53                   	push   %ebx
801025b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801025b9:	85 c0                	test   %eax,%eax
801025bb:	0f 84 b4 00 00 00    	je     80102675 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025c1:	8b 70 08             	mov    0x8(%eax),%esi
801025c4:	89 c3                	mov    %eax,%ebx
801025c6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025cc:	0f 87 96 00 00 00    	ja     80102668 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025de:	00 
801025df:	90                   	nop
801025e0:	89 ca                	mov    %ecx,%edx
801025e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025e3:	83 e0 c0             	and    $0xffffffc0,%eax
801025e6:	3c 40                	cmp    $0x40,%al
801025e8:	75 f6                	jne    801025e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ea:	31 ff                	xor    %edi,%edi
801025ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025f1:	89 f8                	mov    %edi,%eax
801025f3:	ee                   	out    %al,(%dx)
801025f4:	b8 01 00 00 00       	mov    $0x1,%eax
801025f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025fe:	ee                   	out    %al,(%dx)
801025ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102604:	89 f0                	mov    %esi,%eax
80102606:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102607:	89 f0                	mov    %esi,%eax
80102609:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010260e:	c1 f8 08             	sar    $0x8,%eax
80102611:	ee                   	out    %al,(%dx)
80102612:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102617:	89 f8                	mov    %edi,%eax
80102619:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010261a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010261e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102623:	c1 e0 04             	shl    $0x4,%eax
80102626:	83 e0 10             	and    $0x10,%eax
80102629:	83 c8 e0             	or     $0xffffffe0,%eax
8010262c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010262d:	f6 03 04             	testb  $0x4,(%ebx)
80102630:	75 16                	jne    80102648 <idestart+0x98>
80102632:	b8 20 00 00 00       	mov    $0x20,%eax
80102637:	89 ca                	mov    %ecx,%edx
80102639:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010263a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010263d:	5b                   	pop    %ebx
8010263e:	5e                   	pop    %esi
8010263f:	5f                   	pop    %edi
80102640:	5d                   	pop    %ebp
80102641:	c3                   	ret
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102648:	b8 30 00 00 00       	mov    $0x30,%eax
8010264d:	89 ca                	mov    %ecx,%edx
8010264f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102650:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102655:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102658:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010265d:	fc                   	cld
8010265e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102663:	5b                   	pop    %ebx
80102664:	5e                   	pop    %esi
80102665:	5f                   	pop    %edi
80102666:	5d                   	pop    %ebp
80102667:	c3                   	ret
    panic("incorrect blockno");
80102668:	83 ec 0c             	sub    $0xc,%esp
8010266b:	68 cd 77 10 80       	push   $0x801077cd
80102670:	e8 fb dc ff ff       	call   80100370 <panic>
    panic("idestart");
80102675:	83 ec 0c             	sub    $0xc,%esp
80102678:	68 c4 77 10 80       	push   $0x801077c4
8010267d:	e8 ee dc ff ff       	call   80100370 <panic>
80102682:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102689:	00 
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102690 <ideinit>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102696:	68 df 77 10 80       	push   $0x801077df
8010269b:	68 00 26 11 80       	push   $0x80112600
801026a0:	e8 fb 21 00 00       	call   801048a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801026a5:	58                   	pop    %eax
801026a6:	a1 84 27 11 80       	mov    0x80112784,%eax
801026ab:	5a                   	pop    %edx
801026ac:	83 e8 01             	sub    $0x1,%eax
801026af:	50                   	push   %eax
801026b0:	6a 0e                	push   $0xe
801026b2:	e8 99 02 00 00       	call   80102950 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026b7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026ba:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801026bf:	90                   	nop
801026c0:	89 ca                	mov    %ecx,%edx
801026c2:	ec                   	in     (%dx),%al
801026c3:	83 e0 c0             	and    $0xffffffc0,%eax
801026c6:	3c 40                	cmp    $0x40,%al
801026c8:	75 f6                	jne    801026c0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026cf:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d5:	89 ca                	mov    %ecx,%edx
801026d7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026d8:	84 c0                	test   %al,%al
801026da:	75 1e                	jne    801026fa <ideinit+0x6a>
801026dc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801026e1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ed:	00 
801026ee:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801026f0:	83 e9 01             	sub    $0x1,%ecx
801026f3:	74 0f                	je     80102704 <ideinit+0x74>
801026f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026f6:	84 c0                	test   %al,%al
801026f8:	74 f6                	je     801026f0 <ideinit+0x60>
      havedisk1 = 1;
801026fa:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102701:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102704:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102709:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010270e:	ee                   	out    %al,(%dx)
}
8010270f:	c9                   	leave
80102710:	c3                   	ret
80102711:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102718:	00 
80102719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102720 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	57                   	push   %edi
80102724:	56                   	push   %esi
80102725:	53                   	push   %ebx
80102726:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102729:	68 00 26 11 80       	push   $0x80112600
8010272e:	e8 5d 23 00 00       	call   80104a90 <acquire>

  if((b = idequeue) == 0){
80102733:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102739:	83 c4 10             	add    $0x10,%esp
8010273c:	85 db                	test   %ebx,%ebx
8010273e:	74 63                	je     801027a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102740:	8b 43 58             	mov    0x58(%ebx),%eax
80102743:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102748:	8b 33                	mov    (%ebx),%esi
8010274a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102750:	75 2f                	jne    80102781 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102752:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102757:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275e:	00 
8010275f:	90                   	nop
80102760:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102761:	89 c1                	mov    %eax,%ecx
80102763:	83 e1 c0             	and    $0xffffffc0,%ecx
80102766:	80 f9 40             	cmp    $0x40,%cl
80102769:	75 f5                	jne    80102760 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010276b:	a8 21                	test   $0x21,%al
8010276d:	75 12                	jne    80102781 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010276f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102772:	b9 80 00 00 00       	mov    $0x80,%ecx
80102777:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010277c:	fc                   	cld
8010277d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010277f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102781:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102784:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102787:	83 ce 02             	or     $0x2,%esi
8010278a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010278c:	53                   	push   %ebx
8010278d:	e8 3e 1e 00 00       	call   801045d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102792:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102797:	83 c4 10             	add    $0x10,%esp
8010279a:	85 c0                	test   %eax,%eax
8010279c:	74 05                	je     801027a3 <ideintr+0x83>
    idestart(idequeue);
8010279e:	e8 0d fe ff ff       	call   801025b0 <idestart>
    release(&idelock);
801027a3:	83 ec 0c             	sub    $0xc,%esp
801027a6:	68 00 26 11 80       	push   $0x80112600
801027ab:	e8 80 22 00 00       	call   80104a30 <release>

  release(&idelock);
}
801027b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027b3:	5b                   	pop    %ebx
801027b4:	5e                   	pop    %esi
801027b5:	5f                   	pop    %edi
801027b6:	5d                   	pop    %ebp
801027b7:	c3                   	ret
801027b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bf:	00 

801027c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	53                   	push   %ebx
801027c4:	83 ec 10             	sub    $0x10,%esp
801027c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801027cd:	50                   	push   %eax
801027ce:	e8 7d 20 00 00       	call   80104850 <holdingsleep>
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	0f 84 c3 00 00 00    	je     801028a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027de:	8b 03                	mov    (%ebx),%eax
801027e0:	83 e0 06             	and    $0x6,%eax
801027e3:	83 f8 02             	cmp    $0x2,%eax
801027e6:	0f 84 a8 00 00 00    	je     80102894 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027ec:	8b 53 04             	mov    0x4(%ebx),%edx
801027ef:	85 d2                	test   %edx,%edx
801027f1:	74 0d                	je     80102800 <iderw+0x40>
801027f3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801027f8:	85 c0                	test   %eax,%eax
801027fa:	0f 84 87 00 00 00    	je     80102887 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102800:	83 ec 0c             	sub    $0xc,%esp
80102803:	68 00 26 11 80       	push   $0x80112600
80102808:	e8 83 22 00 00       	call   80104a90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010280d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102812:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102819:	83 c4 10             	add    $0x10,%esp
8010281c:	85 c0                	test   %eax,%eax
8010281e:	74 60                	je     80102880 <iderw+0xc0>
80102820:	89 c2                	mov    %eax,%edx
80102822:	8b 40 58             	mov    0x58(%eax),%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	75 f7                	jne    80102820 <iderw+0x60>
80102829:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010282c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010282e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102834:	74 3a                	je     80102870 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102836:	8b 03                	mov    (%ebx),%eax
80102838:	83 e0 06             	and    $0x6,%eax
8010283b:	83 f8 02             	cmp    $0x2,%eax
8010283e:	74 1b                	je     8010285b <iderw+0x9b>
    sleep(b, &idelock);
80102840:	83 ec 08             	sub    $0x8,%esp
80102843:	68 00 26 11 80       	push   $0x80112600
80102848:	53                   	push   %ebx
80102849:	e8 c2 1c 00 00       	call   80104510 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010284e:	8b 03                	mov    (%ebx),%eax
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	83 e0 06             	and    $0x6,%eax
80102856:	83 f8 02             	cmp    $0x2,%eax
80102859:	75 e5                	jne    80102840 <iderw+0x80>
  }


  release(&idelock);
8010285b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102865:	c9                   	leave
  release(&idelock);
80102866:	e9 c5 21 00 00       	jmp    80104a30 <release>
8010286b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102870:	89 d8                	mov    %ebx,%eax
80102872:	e8 39 fd ff ff       	call   801025b0 <idestart>
80102877:	eb bd                	jmp    80102836 <iderw+0x76>
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102880:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102885:	eb a5                	jmp    8010282c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102887:	83 ec 0c             	sub    $0xc,%esp
8010288a:	68 0e 78 10 80       	push   $0x8010780e
8010288f:	e8 dc da ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	68 f9 77 10 80       	push   $0x801077f9
8010289c:	e8 cf da ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
801028a1:	83 ec 0c             	sub    $0xc,%esp
801028a4:	68 e3 77 10 80       	push   $0x801077e3
801028a9:	e8 c2 da ff ff       	call   80100370 <panic>
801028ae:	66 90                	xchg   %ax,%ax

801028b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028b5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801028bc:	00 c0 fe 
  ioapic->reg = reg;
801028bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028c6:	00 00 00 
  return ioapic->data;
801028c9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801028cf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801028d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801028d8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028de:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028e5:	c1 ee 10             	shr    $0x10,%esi
801028e8:	89 f0                	mov    %esi,%eax
801028ea:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028ed:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801028f0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028f3:	39 c2                	cmp    %eax,%edx
801028f5:	74 16                	je     8010290d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028f7:	83 ec 0c             	sub    $0xc,%esp
801028fa:	68 20 7c 10 80       	push   $0x80107c20
801028ff:	e8 5c de ff ff       	call   80100760 <cprintf>
  ioapic->reg = reg;
80102904:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010290a:	83 c4 10             	add    $0x10,%esp
{
8010290d:	ba 10 00 00 00       	mov    $0x10,%edx
80102912:	31 c0                	xor    %eax,%eax
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102918:	89 13                	mov    %edx,(%ebx)
8010291a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010291d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102923:	83 c0 01             	add    $0x1,%eax
80102926:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010292c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010292f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102932:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102935:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102937:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010293d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102944:	39 c6                	cmp    %eax,%esi
80102946:	7d d0                	jge    80102918 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102948:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010294b:	5b                   	pop    %ebx
8010294c:	5e                   	pop    %esi
8010294d:	5d                   	pop    %ebp
8010294e:	c3                   	ret
8010294f:	90                   	nop

80102950 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102950:	55                   	push   %ebp
  ioapic->reg = reg;
80102951:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102957:	89 e5                	mov    %esp,%ebp
80102959:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010295c:	8d 50 20             	lea    0x20(%eax),%edx
8010295f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102963:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102965:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010296e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102971:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102974:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102976:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010297b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010297e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102981:	5d                   	pop    %ebp
80102982:	c3                   	ret
80102983:	66 90                	xchg   %ax,%ax
80102985:	66 90                	xchg   %ax,%ax
80102987:	66 90                	xchg   %ax,%ax
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	53                   	push   %ebx
80102994:	83 ec 04             	sub    $0x4,%esp
80102997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010299a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029a0:	75 76                	jne    80102a18 <kfree+0x88>
801029a2:	81 fb d0 64 11 80    	cmp    $0x801164d0,%ebx
801029a8:	72 6e                	jb     80102a18 <kfree+0x88>
801029aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029b5:	77 61                	ja     80102a18 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029b7:	83 ec 04             	sub    $0x4,%esp
801029ba:	68 00 10 00 00       	push   $0x1000
801029bf:	6a 01                	push   $0x1
801029c1:	53                   	push   %ebx
801029c2:	e8 c9 21 00 00       	call   80104b90 <memset>

  if(kmem.use_lock)
801029c7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	85 d2                	test   %edx,%edx
801029d2:	75 1c                	jne    801029f0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029d4:	a1 78 26 11 80       	mov    0x80112678,%eax
801029d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029db:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801029e0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801029e6:	85 c0                	test   %eax,%eax
801029e8:	75 1e                	jne    80102a08 <kfree+0x78>
    release(&kmem.lock);
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave
801029ee:	c3                   	ret
801029ef:	90                   	nop
    acquire(&kmem.lock);
801029f0:	83 ec 0c             	sub    $0xc,%esp
801029f3:	68 40 26 11 80       	push   $0x80112640
801029f8:	e8 93 20 00 00       	call   80104a90 <acquire>
801029fd:	83 c4 10             	add    $0x10,%esp
80102a00:	eb d2                	jmp    801029d4 <kfree+0x44>
80102a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102a08:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102a0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a12:	c9                   	leave
    release(&kmem.lock);
80102a13:	e9 18 20 00 00       	jmp    80104a30 <release>
    panic("kfree");
80102a18:	83 ec 0c             	sub    $0xc,%esp
80102a1b:	68 2c 78 10 80       	push   $0x8010782c
80102a20:	e8 4b d9 ff ff       	call   80100370 <panic>
80102a25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a2c:	00 
80102a2d:	8d 76 00             	lea    0x0(%esi),%esi

80102a30 <freerange>:
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	56                   	push   %esi
80102a34:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a35:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a38:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a3b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a41:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a4d:	39 de                	cmp    %ebx,%esi
80102a4f:	72 23                	jb     80102a74 <freerange+0x44>
80102a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a58:	83 ec 0c             	sub    $0xc,%esp
80102a5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a67:	50                   	push   %eax
80102a68:	e8 23 ff ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6d:	83 c4 10             	add    $0x10,%esp
80102a70:	39 de                	cmp    %ebx,%esi
80102a72:	73 e4                	jae    80102a58 <freerange+0x28>
}
80102a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a77:	5b                   	pop    %ebx
80102a78:	5e                   	pop    %esi
80102a79:	5d                   	pop    %ebp
80102a7a:	c3                   	ret
80102a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a80 <kinit2>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a85:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a88:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a8b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a91:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a97:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a9d:	39 de                	cmp    %ebx,%esi
80102a9f:	72 23                	jb     80102ac4 <kinit2+0x44>
80102aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ab7:	50                   	push   %eax
80102ab8:	e8 d3 fe ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	39 de                	cmp    %ebx,%esi
80102ac2:	73 e4                	jae    80102aa8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ac4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102acb:	00 00 00 
}
80102ace:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ad1:	5b                   	pop    %ebx
80102ad2:	5e                   	pop    %esi
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret
80102ad5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102adc:	00 
80102add:	8d 76 00             	lea    0x0(%esi),%esi

80102ae0 <kinit1>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102ae8:	83 ec 08             	sub    $0x8,%esp
80102aeb:	68 32 78 10 80       	push   $0x80107832
80102af0:	68 40 26 11 80       	push   $0x80112640
80102af5:	e8 a6 1d 00 00       	call   801048a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102afa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b00:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102b07:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102b0a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b10:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b16:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b1c:	39 de                	cmp    %ebx,%esi
80102b1e:	72 1c                	jb     80102b3c <kinit1+0x5c>
    kfree(p);
80102b20:	83 ec 0c             	sub    $0xc,%esp
80102b23:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b29:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b2f:	50                   	push   %eax
80102b30:	e8 5b fe ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b35:	83 c4 10             	add    $0x10,%esp
80102b38:	39 de                	cmp    %ebx,%esi
80102b3a:	73 e4                	jae    80102b20 <kinit1+0x40>
}
80102b3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b3f:	5b                   	pop    %ebx
80102b40:	5e                   	pop    %esi
80102b41:	5d                   	pop    %ebp
80102b42:	c3                   	ret
80102b43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b4a:	00 
80102b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102b50 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	53                   	push   %ebx
80102b54:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102b57:	a1 74 26 11 80       	mov    0x80112674,%eax
80102b5c:	85 c0                	test   %eax,%eax
80102b5e:	75 20                	jne    80102b80 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b60:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102b66:	85 db                	test   %ebx,%ebx
80102b68:	74 07                	je     80102b71 <kalloc+0x21>
    kmem.freelist = r->next;
80102b6a:	8b 03                	mov    (%ebx),%eax
80102b6c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b71:	89 d8                	mov    %ebx,%eax
80102b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b76:	c9                   	leave
80102b77:	c3                   	ret
80102b78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b7f:	00 
    acquire(&kmem.lock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 40 26 11 80       	push   $0x80112640
80102b88:	e8 03 1f 00 00       	call   80104a90 <acquire>
  r = kmem.freelist;
80102b8d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102b93:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102b98:	83 c4 10             	add    $0x10,%esp
80102b9b:	85 db                	test   %ebx,%ebx
80102b9d:	74 08                	je     80102ba7 <kalloc+0x57>
    kmem.freelist = r->next;
80102b9f:	8b 13                	mov    (%ebx),%edx
80102ba1:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102ba7:	85 c0                	test   %eax,%eax
80102ba9:	74 c6                	je     80102b71 <kalloc+0x21>
    release(&kmem.lock);
80102bab:	83 ec 0c             	sub    $0xc,%esp
80102bae:	68 40 26 11 80       	push   $0x80112640
80102bb3:	e8 78 1e 00 00       	call   80104a30 <release>
}
80102bb8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102bba:	83 c4 10             	add    $0x10,%esp
}
80102bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc0:	c9                   	leave
80102bc1:	c3                   	ret
80102bc2:	66 90                	xchg   %ax,%ax
80102bc4:	66 90                	xchg   %ax,%ax
80102bc6:	66 90                	xchg   %ax,%ax
80102bc8:	66 90                	xchg   %ax,%ax
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd0:	ba 64 00 00 00       	mov    $0x64,%edx
80102bd5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102bd6:	a8 01                	test   $0x1,%al
80102bd8:	0f 84 c2 00 00 00    	je     80102ca0 <kbdgetc+0xd0>
{
80102bde:	55                   	push   %ebp
80102bdf:	ba 60 00 00 00       	mov    $0x60,%edx
80102be4:	89 e5                	mov    %esp,%ebp
80102be6:	53                   	push   %ebx
80102be7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102be8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
80102bee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102bf1:	3c e0                	cmp    $0xe0,%al
80102bf3:	74 5b                	je     80102c50 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bf5:	89 da                	mov    %ebx,%edx
80102bf7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102bfa:	84 c0                	test   %al,%al
80102bfc:	78 62                	js     80102c60 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bfe:	85 d2                	test   %edx,%edx
80102c00:	74 09                	je     80102c0b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c02:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102c05:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102c08:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102c0b:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
  shift ^= togglecode[data];
80102c12:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
  shift |= shiftcode[data];
80102c19:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102c1b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c1d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102c1f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c25:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c28:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c2b:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
80102c32:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102c36:	74 0b                	je     80102c43 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102c38:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c3b:	83 fa 19             	cmp    $0x19,%edx
80102c3e:	77 48                	ja     80102c88 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c40:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c46:	c9                   	leave
80102c47:	c3                   	ret
80102c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c4f:	00 
    shift |= E0ESC;
80102c50:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c53:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c55:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
80102c5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c5e:	c9                   	leave
80102c5f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102c60:	83 e0 7f             	and    $0x7f,%eax
80102c63:	85 d2                	test   %edx,%edx
80102c65:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102c68:	0f b6 81 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%eax
80102c6f:	83 c8 40             	or     $0x40,%eax
80102c72:	0f b6 c0             	movzbl %al,%eax
80102c75:	f7 d0                	not    %eax
80102c77:	21 d8                	and    %ebx,%eax
80102c79:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102c7e:	31 c0                	xor    %eax,%eax
80102c80:	eb d9                	jmp    80102c5b <kbdgetc+0x8b>
80102c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102c88:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c8b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c91:	c9                   	leave
      c += 'a' - 'A';
80102c92:	83 f9 1a             	cmp    $0x1a,%ecx
80102c95:	0f 42 c2             	cmovb  %edx,%eax
}
80102c98:	c3                   	ret
80102c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ca5:	c3                   	ret
80102ca6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cad:	00 
80102cae:	66 90                	xchg   %ax,%ax

80102cb0 <kbdintr>:

void
kbdintr(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102cb6:	68 d0 2b 10 80       	push   $0x80102bd0
80102cbb:	e8 b0 dc ff ff       	call   80100970 <consoleintr>
}
80102cc0:	83 c4 10             	add    $0x10,%esp
80102cc3:	c9                   	leave
80102cc4:	c3                   	ret
80102cc5:	66 90                	xchg   %ax,%ax
80102cc7:	66 90                	xchg   %ax,%ax
80102cc9:	66 90                	xchg   %ax,%ax
80102ccb:	66 90                	xchg   %ax,%ax
80102ccd:	66 90                	xchg   %ax,%ax
80102ccf:	90                   	nop

80102cd0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102cd0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	0f 84 c3 00 00 00    	je     80102da0 <lapicinit+0xd0>
  lapic[index] = value;
80102cdd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ce4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102cf1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cfe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102d01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d04:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d0b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d11:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d1e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d25:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d28:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d2b:	8b 50 30             	mov    0x30(%eax),%edx
80102d2e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102d34:	75 72                	jne    80102da8 <lapicinit+0xd8>
  lapic[index] = value;
80102d36:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d3d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d40:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d43:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d4a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d50:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d57:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d5a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d5d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d67:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d6a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d71:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d74:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d77:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d7e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d81:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d88:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d8e:	80 e6 10             	and    $0x10,%dh
80102d91:	75 f5                	jne    80102d88 <lapicinit+0xb8>
  lapic[index] = value;
80102d93:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d9a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d9d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102da0:	c3                   	ret
80102da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102da8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102daf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102db2:	8b 50 20             	mov    0x20(%eax),%edx
}
80102db5:	e9 7c ff ff ff       	jmp    80102d36 <lapicinit+0x66>
80102dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102dc0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102dc0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102dc5:	85 c0                	test   %eax,%eax
80102dc7:	74 07                	je     80102dd0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102dc9:	8b 40 20             	mov    0x20(%eax),%eax
80102dcc:	c1 e8 18             	shr    $0x18,%eax
80102dcf:	c3                   	ret
    return 0;
80102dd0:	31 c0                	xor    %eax,%eax
}
80102dd2:	c3                   	ret
80102dd3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dda:	00 
80102ddb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102de0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102de0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102de5:	85 c0                	test   %eax,%eax
80102de7:	74 0d                	je     80102df6 <lapiceoi+0x16>
  lapic[index] = value;
80102de9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102df0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102df3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102df6:	c3                   	ret
80102df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dfe:	00 
80102dff:	90                   	nop

80102e00 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102e00:	c3                   	ret
80102e01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e08:	00 
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e11:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e16:	ba 70 00 00 00       	mov    $0x70,%edx
80102e1b:	89 e5                	mov    %esp,%ebp
80102e1d:	53                   	push   %ebx
80102e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e24:	ee                   	out    %al,(%dx)
80102e25:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e2a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e2f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e30:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102e32:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e35:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e3b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e3d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102e40:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e42:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e45:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e48:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e4e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102e53:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e5c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e63:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e66:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e69:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e70:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e73:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e76:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e7c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e7f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e85:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e88:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e91:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e97:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e9d:	c9                   	leave
80102e9e:	c3                   	ret
80102e9f:	90                   	nop

80102ea0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ea0:	55                   	push   %ebp
80102ea1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ea6:	ba 70 00 00 00       	mov    $0x70,%edx
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	57                   	push   %edi
80102eae:	56                   	push   %esi
80102eaf:	53                   	push   %ebx
80102eb0:	83 ec 4c             	sub    $0x4c,%esp
80102eb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb4:	ba 71 00 00 00       	mov    $0x71,%edx
80102eb9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102eba:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebd:	bf 70 00 00 00       	mov    $0x70,%edi
80102ec2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
80102ec8:	31 c0                	xor    %eax,%eax
80102eca:	89 fa                	mov    %edi,%edx
80102ecc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ecd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ed2:	89 ca                	mov    %ecx,%edx
80102ed4:	ec                   	in     (%dx),%al
80102ed5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed8:	89 fa                	mov    %edi,%edx
80102eda:	b8 02 00 00 00       	mov    $0x2,%eax
80102edf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee0:	89 ca                	mov    %ecx,%edx
80102ee2:	ec                   	in     (%dx),%al
80102ee3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee6:	89 fa                	mov    %edi,%edx
80102ee8:	b8 04 00 00 00       	mov    $0x4,%eax
80102eed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eee:	89 ca                	mov    %ecx,%edx
80102ef0:	ec                   	in     (%dx),%al
80102ef1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef4:	89 fa                	mov    %edi,%edx
80102ef6:	b8 07 00 00 00       	mov    $0x7,%eax
80102efb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efc:	89 ca                	mov    %ecx,%edx
80102efe:	ec                   	in     (%dx),%al
80102eff:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f02:	89 fa                	mov    %edi,%edx
80102f04:	b8 08 00 00 00       	mov    $0x8,%eax
80102f09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0a:	89 ca                	mov    %ecx,%edx
80102f0c:	ec                   	in     (%dx),%al
80102f0d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0f:	89 fa                	mov    %edi,%edx
80102f11:	b8 09 00 00 00       	mov    $0x9,%eax
80102f16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f17:	89 ca                	mov    %ecx,%edx
80102f19:	ec                   	in     (%dx),%al
80102f1a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f1d:	89 fa                	mov    %edi,%edx
80102f1f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f25:	89 ca                	mov    %ecx,%edx
80102f27:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f28:	84 c0                	test   %al,%al
80102f2a:	78 9c                	js     80102ec8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102f2c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f30:	89 f2                	mov    %esi,%edx
80102f32:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102f35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f38:	89 fa                	mov    %edi,%edx
80102f3a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f3d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f41:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102f44:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f47:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f4e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f55:	31 c0                	xor    %eax,%eax
80102f57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f58:	89 ca                	mov    %ecx,%edx
80102f5a:	ec                   	in     (%dx),%al
80102f5b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5e:	89 fa                	mov    %edi,%edx
80102f60:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f63:	b8 02 00 00 00       	mov    $0x2,%eax
80102f68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f69:	89 ca                	mov    %ecx,%edx
80102f6b:	ec                   	in     (%dx),%al
80102f6c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6f:	89 fa                	mov    %edi,%edx
80102f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f74:	b8 04 00 00 00       	mov    $0x4,%eax
80102f79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f7a:	89 ca                	mov    %ecx,%edx
80102f7c:	ec                   	in     (%dx),%al
80102f7d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f80:	89 fa                	mov    %edi,%edx
80102f82:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f85:	b8 07 00 00 00       	mov    $0x7,%eax
80102f8a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f8b:	89 ca                	mov    %ecx,%edx
80102f8d:	ec                   	in     (%dx),%al
80102f8e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f91:	89 fa                	mov    %edi,%edx
80102f93:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f96:	b8 08 00 00 00       	mov    $0x8,%eax
80102f9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f9c:	89 ca                	mov    %ecx,%edx
80102f9e:	ec                   	in     (%dx),%al
80102f9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fa2:	89 fa                	mov    %edi,%edx
80102fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102fa7:	b8 09 00 00 00       	mov    $0x9,%eax
80102fac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fad:	89 ca                	mov    %ecx,%edx
80102faf:	ec                   	in     (%dx),%al
80102fb0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fb3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102fb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fb9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102fbc:	6a 18                	push   $0x18
80102fbe:	50                   	push   %eax
80102fbf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102fc2:	50                   	push   %eax
80102fc3:	e8 08 1c 00 00       	call   80104bd0 <memcmp>
80102fc8:	83 c4 10             	add    $0x10,%esp
80102fcb:	85 c0                	test   %eax,%eax
80102fcd:	0f 85 f5 fe ff ff    	jne    80102ec8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102fd3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fda:	89 f0                	mov    %esi,%eax
80102fdc:	84 c0                	test   %al,%al
80102fde:	75 78                	jne    80103058 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fe0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fe3:	89 c2                	mov    %eax,%edx
80102fe5:	83 e0 0f             	and    $0xf,%eax
80102fe8:	c1 ea 04             	shr    $0x4,%edx
80102feb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fee:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ff4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ff7:	89 c2                	mov    %eax,%edx
80102ff9:	83 e0 0f             	and    $0xf,%eax
80102ffc:	c1 ea 04             	shr    $0x4,%edx
80102fff:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103002:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103005:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103008:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010300b:	89 c2                	mov    %eax,%edx
8010300d:	83 e0 0f             	and    $0xf,%eax
80103010:	c1 ea 04             	shr    $0x4,%edx
80103013:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103016:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103019:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010301c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010301f:	89 c2                	mov    %eax,%edx
80103021:	83 e0 0f             	and    $0xf,%eax
80103024:	c1 ea 04             	shr    $0x4,%edx
80103027:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010302d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103030:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103033:	89 c2                	mov    %eax,%edx
80103035:	83 e0 0f             	and    $0xf,%eax
80103038:	c1 ea 04             	shr    $0x4,%edx
8010303b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010303e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103041:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103044:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103047:	89 c2                	mov    %eax,%edx
80103049:	83 e0 0f             	and    $0xf,%eax
8010304c:	c1 ea 04             	shr    $0x4,%edx
8010304f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103052:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103055:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103058:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010305b:	89 03                	mov    %eax,(%ebx)
8010305d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103060:	89 43 04             	mov    %eax,0x4(%ebx)
80103063:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103066:	89 43 08             	mov    %eax,0x8(%ebx)
80103069:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010306c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010306f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103072:	89 43 10             	mov    %eax,0x10(%ebx)
80103075:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103078:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010307b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103082:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103085:	5b                   	pop    %ebx
80103086:	5e                   	pop    %esi
80103087:	5f                   	pop    %edi
80103088:	5d                   	pop    %ebp
80103089:	c3                   	ret
8010308a:	66 90                	xchg   %ax,%ax
8010308c:	66 90                	xchg   %ax,%ax
8010308e:	66 90                	xchg   %ax,%ax

80103090 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103090:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103096:	85 c9                	test   %ecx,%ecx
80103098:	0f 8e 8a 00 00 00    	jle    80103128 <install_trans+0x98>
{
8010309e:	55                   	push   %ebp
8010309f:	89 e5                	mov    %esp,%ebp
801030a1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801030a2:	31 ff                	xor    %edi,%edi
{
801030a4:	56                   	push   %esi
801030a5:	53                   	push   %ebx
801030a6:	83 ec 0c             	sub    $0xc,%esp
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030b0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801030b5:	83 ec 08             	sub    $0x8,%esp
801030b8:	01 f8                	add    %edi,%eax
801030ba:	83 c0 01             	add    $0x1,%eax
801030bd:	50                   	push   %eax
801030be:	ff 35 e4 26 11 80    	push   0x801126e4
801030c4:	e8 07 d0 ff ff       	call   801000d0 <bread>
801030c9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030cb:	58                   	pop    %eax
801030cc:	5a                   	pop    %edx
801030cd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
801030d4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030da:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030dd:	e8 ee cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030e5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030e7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030ea:	68 00 02 00 00       	push   $0x200
801030ef:	50                   	push   %eax
801030f0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030f3:	50                   	push   %eax
801030f4:	e8 27 1b 00 00       	call   80104c20 <memmove>
    bwrite(dbuf);  // write dst to disk
801030f9:	89 1c 24             	mov    %ebx,(%esp)
801030fc:	e8 af d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103101:	89 34 24             	mov    %esi,(%esp)
80103104:	e8 e7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103109:	89 1c 24             	mov    %ebx,(%esp)
8010310c:	e8 df d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103111:	83 c4 10             	add    $0x10,%esp
80103114:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
8010311a:	7f 94                	jg     801030b0 <install_trans+0x20>
  }
}
8010311c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010311f:	5b                   	pop    %ebx
80103120:	5e                   	pop    %esi
80103121:	5f                   	pop    %edi
80103122:	5d                   	pop    %ebp
80103123:	c3                   	ret
80103124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103128:	c3                   	ret
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103130 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103137:	ff 35 d4 26 11 80    	push   0x801126d4
8010313d:	ff 35 e4 26 11 80    	push   0x801126e4
80103143:	e8 88 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103148:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010314b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010314d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80103152:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103155:	85 c0                	test   %eax,%eax
80103157:	7e 19                	jle    80103172 <write_head+0x42>
80103159:	31 d2                	xor    %edx,%edx
8010315b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103160:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80103167:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010316b:	83 c2 01             	add    $0x1,%edx
8010316e:	39 d0                	cmp    %edx,%eax
80103170:	75 ee                	jne    80103160 <write_head+0x30>
  }
  bwrite(buf);
80103172:	83 ec 0c             	sub    $0xc,%esp
80103175:	53                   	push   %ebx
80103176:	e8 35 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010317b:	89 1c 24             	mov    %ebx,(%esp)
8010317e:	e8 6d d0 ff ff       	call   801001f0 <brelse>
}
80103183:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	c9                   	leave
8010318a:	c3                   	ret
8010318b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103190 <initlog>:
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 2c             	sub    $0x2c,%esp
80103197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010319a:	68 37 78 10 80       	push   $0x80107837
8010319f:	68 a0 26 11 80       	push   $0x801126a0
801031a4:	e8 f7 16 00 00       	call   801048a0 <initlock>
  readsb(dev, &sb);
801031a9:	58                   	pop    %eax
801031aa:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031ad:	5a                   	pop    %edx
801031ae:	50                   	push   %eax
801031af:	53                   	push   %ebx
801031b0:	e8 7b e8 ff ff       	call   80101a30 <readsb>
  log.start = sb.logstart;
801031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031b8:	59                   	pop    %ecx
  log.dev = dev;
801031b9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
801031bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031c2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
801031c7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
801031cd:	5a                   	pop    %edx
801031ce:	50                   	push   %eax
801031cf:	53                   	push   %ebx
801031d0:	e8 fb ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031d5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031d8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801031db:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
801031e1:	85 db                	test   %ebx,%ebx
801031e3:	7e 1d                	jle    80103202 <initlog+0x72>
801031e5:	31 d2                	xor    %edx,%edx
801031e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ee:	00 
801031ef:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031f0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801031f4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031fb:	83 c2 01             	add    $0x1,%edx
801031fe:	39 d3                	cmp    %edx,%ebx
80103200:	75 ee                	jne    801031f0 <initlog+0x60>
  brelse(buf);
80103202:	83 ec 0c             	sub    $0xc,%esp
80103205:	50                   	push   %eax
80103206:	e8 e5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010320b:	e8 80 fe ff ff       	call   80103090 <install_trans>
  log.lh.n = 0;
80103210:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80103217:	00 00 00 
  write_head(); // clear the log
8010321a:	e8 11 ff ff ff       	call   80103130 <write_head>
}
8010321f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103222:	83 c4 10             	add    $0x10,%esp
80103225:	c9                   	leave
80103226:	c3                   	ret
80103227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010322e:	00 
8010322f:	90                   	nop

80103230 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103236:	68 a0 26 11 80       	push   $0x801126a0
8010323b:	e8 50 18 00 00       	call   80104a90 <acquire>
80103240:	83 c4 10             	add    $0x10,%esp
80103243:	eb 18                	jmp    8010325d <begin_op+0x2d>
80103245:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103248:	83 ec 08             	sub    $0x8,%esp
8010324b:	68 a0 26 11 80       	push   $0x801126a0
80103250:	68 a0 26 11 80       	push   $0x801126a0
80103255:	e8 b6 12 00 00       	call   80104510 <sleep>
8010325a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010325d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80103262:	85 c0                	test   %eax,%eax
80103264:	75 e2                	jne    80103248 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103266:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010326b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103271:	83 c0 01             	add    $0x1,%eax
80103274:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103277:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010327a:	83 fa 1e             	cmp    $0x1e,%edx
8010327d:	7f c9                	jg     80103248 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010327f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103282:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80103287:	68 a0 26 11 80       	push   $0x801126a0
8010328c:	e8 9f 17 00 00       	call   80104a30 <release>
      break;
    }
  }
}
80103291:	83 c4 10             	add    $0x10,%esp
80103294:	c9                   	leave
80103295:	c3                   	ret
80103296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010329d:	00 
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801032a9:	68 a0 26 11 80       	push   $0x801126a0
801032ae:	e8 dd 17 00 00       	call   80104a90 <acquire>
  log.outstanding -= 1;
801032b3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
801032b8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
801032be:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032c1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032c4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
801032ca:	85 f6                	test   %esi,%esi
801032cc:	0f 85 22 01 00 00    	jne    801033f4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032d2:	85 db                	test   %ebx,%ebx
801032d4:	0f 85 f6 00 00 00    	jne    801033d0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032da:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
801032e1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032e4:	83 ec 0c             	sub    $0xc,%esp
801032e7:	68 a0 26 11 80       	push   $0x801126a0
801032ec:	e8 3f 17 00 00       	call   80104a30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032f1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801032f7:	83 c4 10             	add    $0x10,%esp
801032fa:	85 c9                	test   %ecx,%ecx
801032fc:	7f 42                	jg     80103340 <end_op+0xa0>
    acquire(&log.lock);
801032fe:	83 ec 0c             	sub    $0xc,%esp
80103301:	68 a0 26 11 80       	push   $0x801126a0
80103306:	e8 85 17 00 00       	call   80104a90 <acquire>
    log.committing = 0;
8010330b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80103312:	00 00 00 
    wakeup(&log);
80103315:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010331c:	e8 af 12 00 00       	call   801045d0 <wakeup>
    release(&log.lock);
80103321:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103328:	e8 03 17 00 00       	call   80104a30 <release>
8010332d:	83 c4 10             	add    $0x10,%esp
}
80103330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103333:	5b                   	pop    %ebx
80103334:	5e                   	pop    %esi
80103335:	5f                   	pop    %edi
80103336:	5d                   	pop    %ebp
80103337:	c3                   	ret
80103338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103340:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103345:	83 ec 08             	sub    $0x8,%esp
80103348:	01 d8                	add    %ebx,%eax
8010334a:	83 c0 01             	add    $0x1,%eax
8010334d:	50                   	push   %eax
8010334e:	ff 35 e4 26 11 80    	push   0x801126e4
80103354:	e8 77 cd ff ff       	call   801000d0 <bread>
80103359:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010335b:	58                   	pop    %eax
8010335c:	5a                   	pop    %edx
8010335d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103364:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010336a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010336d:	e8 5e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103372:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103375:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103377:	8d 40 5c             	lea    0x5c(%eax),%eax
8010337a:	68 00 02 00 00       	push   $0x200
8010337f:	50                   	push   %eax
80103380:	8d 46 5c             	lea    0x5c(%esi),%eax
80103383:	50                   	push   %eax
80103384:	e8 97 18 00 00       	call   80104c20 <memmove>
    bwrite(to);  // write the log
80103389:	89 34 24             	mov    %esi,(%esp)
8010338c:	e8 1f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103391:	89 3c 24             	mov    %edi,(%esp)
80103394:	e8 57 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103399:	89 34 24             	mov    %esi,(%esp)
8010339c:	e8 4f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033a1:	83 c4 10             	add    $0x10,%esp
801033a4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
801033aa:	7c 94                	jl     80103340 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801033ac:	e8 7f fd ff ff       	call   80103130 <write_head>
    install_trans(); // Now install writes to home locations
801033b1:	e8 da fc ff ff       	call   80103090 <install_trans>
    log.lh.n = 0;
801033b6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801033bd:	00 00 00 
    write_head();    // Erase the transaction from the log
801033c0:	e8 6b fd ff ff       	call   80103130 <write_head>
801033c5:	e9 34 ff ff ff       	jmp    801032fe <end_op+0x5e>
801033ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	68 a0 26 11 80       	push   $0x801126a0
801033d8:	e8 f3 11 00 00       	call   801045d0 <wakeup>
  release(&log.lock);
801033dd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033e4:	e8 47 16 00 00       	call   80104a30 <release>
801033e9:	83 c4 10             	add    $0x10,%esp
}
801033ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ef:	5b                   	pop    %ebx
801033f0:	5e                   	pop    %esi
801033f1:	5f                   	pop    %edi
801033f2:	5d                   	pop    %ebp
801033f3:	c3                   	ret
    panic("log.committing");
801033f4:	83 ec 0c             	sub    $0xc,%esp
801033f7:	68 3b 78 10 80       	push   $0x8010783b
801033fc:	e8 6f cf ff ff       	call   80100370 <panic>
80103401:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103408:	00 
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103410 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	53                   	push   %ebx
80103414:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103417:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010341d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103420:	83 fa 1d             	cmp    $0x1d,%edx
80103423:	7f 7d                	jg     801034a2 <log_write+0x92>
80103425:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010342a:	83 e8 01             	sub    $0x1,%eax
8010342d:	39 c2                	cmp    %eax,%edx
8010342f:	7d 71                	jge    801034a2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103431:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80103436:	85 c0                	test   %eax,%eax
80103438:	7e 75                	jle    801034af <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010343a:	83 ec 0c             	sub    $0xc,%esp
8010343d:	68 a0 26 11 80       	push   $0x801126a0
80103442:	e8 49 16 00 00       	call   80104a90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103447:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010344a:	83 c4 10             	add    $0x10,%esp
8010344d:	31 c0                	xor    %eax,%eax
8010344f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103455:	85 d2                	test   %edx,%edx
80103457:	7f 0e                	jg     80103467 <log_write+0x57>
80103459:	eb 15                	jmp    80103470 <log_write+0x60>
8010345b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103460:	83 c0 01             	add    $0x1,%eax
80103463:	39 c2                	cmp    %eax,%edx
80103465:	74 29                	je     80103490 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103467:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010346e:	75 f0                	jne    80103460 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103470:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103477:	39 c2                	cmp    %eax,%edx
80103479:	74 1c                	je     80103497 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010347b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010347e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103481:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103488:	c9                   	leave
  release(&log.lock);
80103489:	e9 a2 15 00 00       	jmp    80104a30 <release>
8010348e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103490:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103497:	83 c2 01             	add    $0x1,%edx
8010349a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801034a0:	eb d9                	jmp    8010347b <log_write+0x6b>
    panic("too big a transaction");
801034a2:	83 ec 0c             	sub    $0xc,%esp
801034a5:	68 4a 78 10 80       	push   $0x8010784a
801034aa:	e8 c1 ce ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
801034af:	83 ec 0c             	sub    $0xc,%esp
801034b2:	68 60 78 10 80       	push   $0x80107860
801034b7:	e8 b4 ce ff ff       	call   80100370 <panic>
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034c7:	e8 64 09 00 00       	call   80103e30 <cpuid>
801034cc:	89 c3                	mov    %eax,%ebx
801034ce:	e8 5d 09 00 00       	call   80103e30 <cpuid>
801034d3:	83 ec 04             	sub    $0x4,%esp
801034d6:	53                   	push   %ebx
801034d7:	50                   	push   %eax
801034d8:	68 7b 78 10 80       	push   $0x8010787b
801034dd:	e8 7e d2 ff ff       	call   80100760 <cprintf>
  idtinit();       // load idt register
801034e2:	e8 e9 28 00 00       	call   80105dd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034e7:	e8 e4 08 00 00       	call   80103dd0 <mycpu>
801034ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ee:	b8 01 00 00 00       	mov    $0x1,%eax
801034f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034fa:	e8 01 0c 00 00       	call   80104100 <scheduler>
801034ff:	90                   	nop

80103500 <mpenter>:
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103506:	e8 c5 39 00 00       	call   80106ed0 <switchkvm>
  seginit();
8010350b:	e8 30 39 00 00       	call   80106e40 <seginit>
  lapicinit();
80103510:	e8 bb f7 ff ff       	call   80102cd0 <lapicinit>
  mpmain();
80103515:	e8 a6 ff ff ff       	call   801034c0 <mpmain>
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <main>:
{
80103520:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103524:	83 e4 f0             	and    $0xfffffff0,%esp
80103527:	ff 71 fc             	push   -0x4(%ecx)
8010352a:	55                   	push   %ebp
8010352b:	89 e5                	mov    %esp,%ebp
8010352d:	53                   	push   %ebx
8010352e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010352f:	83 ec 08             	sub    $0x8,%esp
80103532:	68 00 00 40 80       	push   $0x80400000
80103537:	68 d0 64 11 80       	push   $0x801164d0
8010353c:	e8 9f f5 ff ff       	call   80102ae0 <kinit1>
  kvmalloc();      // kernel page table
80103541:	e8 4a 3e 00 00       	call   80107390 <kvmalloc>
  mpinit();        // detect other processors
80103546:	e8 85 01 00 00       	call   801036d0 <mpinit>
  lapicinit();     // interrupt controller
8010354b:	e8 80 f7 ff ff       	call   80102cd0 <lapicinit>
  seginit();       // segment descriptors
80103550:	e8 eb 38 00 00       	call   80106e40 <seginit>
  picinit();       // disable pic
80103555:	e8 86 03 00 00       	call   801038e0 <picinit>
  ioapicinit();    // another interrupt controller
8010355a:	e8 51 f3 ff ff       	call   801028b0 <ioapicinit>
  consoleinit();   // console hardware
8010355f:	e8 ec d9 ff ff       	call   80100f50 <consoleinit>
  uartinit();      // serial port
80103564:	e8 47 2b 00 00       	call   801060b0 <uartinit>
  pinit();         // process table
80103569:	e8 42 08 00 00       	call   80103db0 <pinit>
  tvinit();        // trap vectors
8010356e:	e8 dd 27 00 00       	call   80105d50 <tvinit>
  binit();         // buffer cache
80103573:	e8 c8 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103578:	e8 a3 dd ff ff       	call   80101320 <fileinit>
  ideinit();       // disk 
8010357d:	e8 0e f1 ff ff       	call   80102690 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103582:	83 c4 0c             	add    $0xc,%esp
80103585:	68 8a 00 00 00       	push   $0x8a
8010358a:	68 8c b4 10 80       	push   $0x8010b48c
8010358f:	68 00 70 00 80       	push   $0x80007000
80103594:	e8 87 16 00 00       	call   80104c20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801035a3:	00 00 00 
801035a6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801035ab:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801035b0:	76 7e                	jbe    80103630 <main+0x110>
801035b2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801035b7:	eb 20                	jmp    801035d9 <main+0xb9>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035c0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801035c7:	00 00 00 
801035ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035d0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801035d5:	39 c3                	cmp    %eax,%ebx
801035d7:	73 57                	jae    80103630 <main+0x110>
    if(c == mycpu())  // We've started already.
801035d9:	e8 f2 07 00 00       	call   80103dd0 <mycpu>
801035de:	39 c3                	cmp    %eax,%ebx
801035e0:	74 de                	je     801035c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035e2:	e8 69 f5 ff ff       	call   80102b50 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103500,0x80006ff8
801035f1:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035f4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035fb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035fe:	05 00 10 00 00       	add    $0x1000,%eax
80103603:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103608:	0f b6 03             	movzbl (%ebx),%eax
8010360b:	68 00 70 00 00       	push   $0x7000
80103610:	50                   	push   %eax
80103611:	e8 fa f7 ff ff       	call   80102e10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103626:	85 c0                	test   %eax,%eax
80103628:	74 f6                	je     80103620 <main+0x100>
8010362a:	eb 94                	jmp    801035c0 <main+0xa0>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	68 00 00 00 8e       	push   $0x8e000000
80103638:	68 00 00 40 80       	push   $0x80400000
8010363d:	e8 3e f4 ff ff       	call   80102a80 <kinit2>
  userinit();      // first user process
80103642:	e8 39 08 00 00       	call   80103e80 <userinit>
  mpmain();        // finish this processor's setup
80103647:	e8 74 fe ff ff       	call   801034c0 <mpmain>
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103655:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010365b:	53                   	push   %ebx
  e = addr+len;
8010365c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010365f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103662:	39 de                	cmp    %ebx,%esi
80103664:	72 10                	jb     80103676 <mpsearch1+0x26>
80103666:	eb 50                	jmp    801036b8 <mpsearch1+0x68>
80103668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010366f:	00 
80103670:	89 fe                	mov    %edi,%esi
80103672:	39 df                	cmp    %ebx,%edi
80103674:	73 42                	jae    801036b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103676:	83 ec 04             	sub    $0x4,%esp
80103679:	8d 7e 10             	lea    0x10(%esi),%edi
8010367c:	6a 04                	push   $0x4
8010367e:	68 8f 78 10 80       	push   $0x8010788f
80103683:	56                   	push   %esi
80103684:	e8 47 15 00 00       	call   80104bd0 <memcmp>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	85 c0                	test   %eax,%eax
8010368e:	75 e0                	jne    80103670 <mpsearch1+0x20>
80103690:	89 f2                	mov    %esi,%edx
80103692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103698:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010369b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010369e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036a0:	39 fa                	cmp    %edi,%edx
801036a2:	75 f4                	jne    80103698 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036a4:	84 c0                	test   %al,%al
801036a6:	75 c8                	jne    80103670 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ab:	89 f0                	mov    %esi,%eax
801036ad:	5b                   	pop    %ebx
801036ae:	5e                   	pop    %esi
801036af:	5f                   	pop    %edi
801036b0:	5d                   	pop    %ebp
801036b1:	c3                   	ret
801036b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036bb:	31 f6                	xor    %esi,%esi
}
801036bd:	5b                   	pop    %ebx
801036be:	89 f0                	mov    %esi,%eax
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret
801036c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036cb:	00 
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036e7:	c1 e0 08             	shl    $0x8,%eax
801036ea:	09 d0                	or     %edx,%eax
801036ec:	c1 e0 04             	shl    $0x4,%eax
801036ef:	75 1b                	jne    8010370c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036ff:	c1 e0 08             	shl    $0x8,%eax
80103702:	09 d0                	or     %edx,%eax
80103704:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103707:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010370c:	ba 00 04 00 00       	mov    $0x400,%edx
80103711:	e8 3a ff ff ff       	call   80103650 <mpsearch1>
80103716:	89 c3                	mov    %eax,%ebx
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 84 58 01 00 00    	je     80103878 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103720:	8b 73 04             	mov    0x4(%ebx),%esi
80103723:	85 f6                	test   %esi,%esi
80103725:	0f 84 3d 01 00 00    	je     80103868 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010372b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010372e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103737:	6a 04                	push   $0x4
80103739:	68 94 78 10 80       	push   $0x80107894
8010373e:	50                   	push   %eax
8010373f:	e8 8c 14 00 00       	call   80104bd0 <memcmp>
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 c0                	test   %eax,%eax
80103749:	0f 85 19 01 00 00    	jne    80103868 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010374f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103756:	3c 01                	cmp    $0x1,%al
80103758:	74 08                	je     80103762 <mpinit+0x92>
8010375a:	3c 04                	cmp    $0x4,%al
8010375c:	0f 85 06 01 00 00    	jne    80103868 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103762:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103769:	66 85 d2             	test   %dx,%dx
8010376c:	74 22                	je     80103790 <mpinit+0xc0>
8010376e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103771:	89 f0                	mov    %esi,%eax
  sum = 0;
80103773:	31 d2                	xor    %edx,%edx
80103775:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103778:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010377f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103782:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103784:	39 f8                	cmp    %edi,%eax
80103786:	75 f0                	jne    80103778 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103788:	84 d2                	test   %dl,%dl
8010378a:	0f 85 d8 00 00 00    	jne    80103868 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103790:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103796:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103799:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010379c:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801037a8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801037ae:	01 d7                	add    %edx,%edi
801037b0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801037b2:	bf 01 00 00 00       	mov    $0x1,%edi
801037b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037be:	00 
801037bf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037c0:	39 d0                	cmp    %edx,%eax
801037c2:	73 19                	jae    801037dd <mpinit+0x10d>
    switch(*p){
801037c4:	0f b6 08             	movzbl (%eax),%ecx
801037c7:	80 f9 02             	cmp    $0x2,%cl
801037ca:	0f 84 80 00 00 00    	je     80103850 <mpinit+0x180>
801037d0:	77 6e                	ja     80103840 <mpinit+0x170>
801037d2:	84 c9                	test   %cl,%cl
801037d4:	74 3a                	je     80103810 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037d6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037d9:	39 d0                	cmp    %edx,%eax
801037db:	72 e7                	jb     801037c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801037e0:	85 ff                	test   %edi,%edi
801037e2:	0f 84 dd 00 00 00    	je     801038c5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037e8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801037ec:	74 15                	je     80103803 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ee:	b8 70 00 00 00       	mov    $0x70,%eax
801037f3:	ba 22 00 00 00       	mov    $0x22,%edx
801037f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037f9:	ba 23 00 00 00       	mov    $0x23,%edx
801037fe:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037ff:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103802:	ee                   	out    %al,(%dx)
  }
}
80103803:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret
8010380b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103810:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103816:	83 f9 07             	cmp    $0x7,%ecx
80103819:	7f 19                	jg     80103834 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010381b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103821:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103825:	83 c1 01             	add    $0x1,%ecx
80103828:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010382e:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
80103834:	83 c0 14             	add    $0x14,%eax
      continue;
80103837:	eb 87                	jmp    801037c0 <mpinit+0xf0>
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103840:	83 e9 03             	sub    $0x3,%ecx
80103843:	80 f9 01             	cmp    $0x1,%cl
80103846:	76 8e                	jbe    801037d6 <mpinit+0x106>
80103848:	31 ff                	xor    %edi,%edi
8010384a:	e9 71 ff ff ff       	jmp    801037c0 <mpinit+0xf0>
8010384f:	90                   	nop
      ioapicid = ioapic->apicno;
80103850:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103854:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103857:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010385d:	e9 5e ff ff ff       	jmp    801037c0 <mpinit+0xf0>
80103862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	68 99 78 10 80       	push   $0x80107899
80103870:	e8 fb ca ff ff       	call   80100370 <panic>
80103875:	8d 76 00             	lea    0x0(%esi),%esi
{
80103878:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010387d:	eb 0b                	jmp    8010388a <mpinit+0x1ba>
8010387f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103880:	89 f3                	mov    %esi,%ebx
80103882:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103888:	74 de                	je     80103868 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010388a:	83 ec 04             	sub    $0x4,%esp
8010388d:	8d 73 10             	lea    0x10(%ebx),%esi
80103890:	6a 04                	push   $0x4
80103892:	68 8f 78 10 80       	push   $0x8010788f
80103897:	53                   	push   %ebx
80103898:	e8 33 13 00 00       	call   80104bd0 <memcmp>
8010389d:	83 c4 10             	add    $0x10,%esp
801038a0:	85 c0                	test   %eax,%eax
801038a2:	75 dc                	jne    80103880 <mpinit+0x1b0>
801038a4:	89 da                	mov    %ebx,%edx
801038a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038ad:	00 
801038ae:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801038b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801038b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801038b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801038b8:	39 d6                	cmp    %edx,%esi
801038ba:	75 f4                	jne    801038b0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038bc:	84 c0                	test   %al,%al
801038be:	75 c0                	jne    80103880 <mpinit+0x1b0>
801038c0:	e9 5b fe ff ff       	jmp    80103720 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801038c5:	83 ec 0c             	sub    $0xc,%esp
801038c8:	68 54 7c 10 80       	push   $0x80107c54
801038cd:	e8 9e ca ff ff       	call   80100370 <panic>
801038d2:	66 90                	xchg   %ax,%ax
801038d4:	66 90                	xchg   %ax,%ax
801038d6:	66 90                	xchg   %ax,%ax
801038d8:	66 90                	xchg   %ax,%ax
801038da:	66 90                	xchg   %ax,%ax
801038dc:	66 90                	xchg   %ax,%ax
801038de:	66 90                	xchg   %ax,%ax

801038e0 <picinit>:
801038e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038e5:	ba 21 00 00 00       	mov    $0x21,%edx
801038ea:	ee                   	out    %al,(%dx)
801038eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801038f0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038f1:	c3                   	ret
801038f2:	66 90                	xchg   %ax,%ax
801038f4:	66 90                	xchg   %ax,%ax
801038f6:	66 90                	xchg   %ax,%ax
801038f8:	66 90                	xchg   %ax,%ax
801038fa:	66 90                	xchg   %ax,%ax
801038fc:	66 90                	xchg   %ax,%ax
801038fe:	66 90                	xchg   %ax,%ax

80103900 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 0c             	sub    $0xc,%esp
80103909:	8b 75 08             	mov    0x8(%ebp),%esi
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010390f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103915:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010391b:	e8 20 da ff ff       	call   80101340 <filealloc>
80103920:	89 06                	mov    %eax,(%esi)
80103922:	85 c0                	test   %eax,%eax
80103924:	0f 84 a5 00 00 00    	je     801039cf <pipealloc+0xcf>
8010392a:	e8 11 da ff ff       	call   80101340 <filealloc>
8010392f:	89 07                	mov    %eax,(%edi)
80103931:	85 c0                	test   %eax,%eax
80103933:	0f 84 84 00 00 00    	je     801039bd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103939:	e8 12 f2 ff ff       	call   80102b50 <kalloc>
8010393e:	89 c3                	mov    %eax,%ebx
80103940:	85 c0                	test   %eax,%eax
80103942:	0f 84 a0 00 00 00    	je     801039e8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103948:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010394f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103952:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103955:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010395c:	00 00 00 
  p->nwrite = 0;
8010395f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103966:	00 00 00 
  p->nread = 0;
80103969:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103970:	00 00 00 
  initlock(&p->lock, "pipe");
80103973:	68 b1 78 10 80       	push   $0x801078b1
80103978:	50                   	push   %eax
80103979:	e8 22 0f 00 00       	call   801048a0 <initlock>
  (*f0)->type = FD_PIPE;
8010397e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103980:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103983:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103989:	8b 06                	mov    (%esi),%eax
8010398b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010398f:	8b 06                	mov    (%esi),%eax
80103991:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103995:	8b 06                	mov    (%esi),%eax
80103997:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010399a:	8b 07                	mov    (%edi),%eax
8010399c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801039a2:	8b 07                	mov    (%edi),%eax
801039a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801039a8:	8b 07                	mov    (%edi),%eax
801039aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801039ae:	8b 07                	mov    (%edi),%eax
801039b0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801039b3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801039b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039b8:	5b                   	pop    %ebx
801039b9:	5e                   	pop    %esi
801039ba:	5f                   	pop    %edi
801039bb:	5d                   	pop    %ebp
801039bc:	c3                   	ret
  if(*f0)
801039bd:	8b 06                	mov    (%esi),%eax
801039bf:	85 c0                	test   %eax,%eax
801039c1:	74 1e                	je     801039e1 <pipealloc+0xe1>
    fileclose(*f0);
801039c3:	83 ec 0c             	sub    $0xc,%esp
801039c6:	50                   	push   %eax
801039c7:	e8 34 da ff ff       	call   80101400 <fileclose>
801039cc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039cf:	8b 07                	mov    (%edi),%eax
801039d1:	85 c0                	test   %eax,%eax
801039d3:	74 0c                	je     801039e1 <pipealloc+0xe1>
    fileclose(*f1);
801039d5:	83 ec 0c             	sub    $0xc,%esp
801039d8:	50                   	push   %eax
801039d9:	e8 22 da ff ff       	call   80101400 <fileclose>
801039de:	83 c4 10             	add    $0x10,%esp
  return -1;
801039e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039e6:	eb cd                	jmp    801039b5 <pipealloc+0xb5>
  if(*f0)
801039e8:	8b 06                	mov    (%esi),%eax
801039ea:	85 c0                	test   %eax,%eax
801039ec:	75 d5                	jne    801039c3 <pipealloc+0xc3>
801039ee:	eb df                	jmp    801039cf <pipealloc+0xcf>

801039f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039fb:	83 ec 0c             	sub    $0xc,%esp
801039fe:	53                   	push   %ebx
801039ff:	e8 8c 10 00 00       	call   80104a90 <acquire>
  if(writable){
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	85 f6                	test   %esi,%esi
80103a09:	74 65                	je     80103a70 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a0b:	83 ec 0c             	sub    $0xc,%esp
80103a0e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a14:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a1b:	00 00 00 
    wakeup(&p->nread);
80103a1e:	50                   	push   %eax
80103a1f:	e8 ac 0b 00 00       	call   801045d0 <wakeup>
80103a24:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a27:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a2d:	85 d2                	test   %edx,%edx
80103a2f:	75 0a                	jne    80103a3b <pipeclose+0x4b>
80103a31:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a37:	85 c0                	test   %eax,%eax
80103a39:	74 15                	je     80103a50 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a41:	5b                   	pop    %ebx
80103a42:	5e                   	pop    %esi
80103a43:	5d                   	pop    %ebp
    release(&p->lock);
80103a44:	e9 e7 0f 00 00       	jmp    80104a30 <release>
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 d7 0f 00 00       	call   80104a30 <release>
    kfree((char*)p);
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a62:	5b                   	pop    %ebx
80103a63:	5e                   	pop    %esi
80103a64:	5d                   	pop    %ebp
    kfree((char*)p);
80103a65:	e9 26 ef ff ff       	jmp    80102990 <kfree>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a79:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a80:	00 00 00 
    wakeup(&p->nwrite);
80103a83:	50                   	push   %eax
80103a84:	e8 47 0b 00 00       	call   801045d0 <wakeup>
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	eb 99                	jmp    80103a27 <pipeclose+0x37>
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 28             	sub    $0x28,%esp
80103a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a9c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a9f:	53                   	push   %ebx
80103aa0:	e8 eb 0f 00 00       	call   80104a90 <acquire>
  for(i = 0; i < n; i++){
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	85 ff                	test   %edi,%edi
80103aaa:	0f 8e ce 00 00 00    	jle    80103b7e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ab9:	89 7d 10             	mov    %edi,0x10(%ebp)
80103abc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103abf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103ac2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ac5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103acb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ad1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ad7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103add:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103ae0:	0f 85 b6 00 00 00    	jne    80103b9c <pipewrite+0x10c>
80103ae6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103ae9:	eb 3b                	jmp    80103b26 <pipewrite+0x96>
80103aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103af0:	e8 5b 03 00 00       	call   80103e50 <myproc>
80103af5:	8b 48 24             	mov    0x24(%eax),%ecx
80103af8:	85 c9                	test   %ecx,%ecx
80103afa:	75 34                	jne    80103b30 <pipewrite+0xa0>
      wakeup(&p->nread);
80103afc:	83 ec 0c             	sub    $0xc,%esp
80103aff:	56                   	push   %esi
80103b00:	e8 cb 0a 00 00       	call   801045d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b05:	58                   	pop    %eax
80103b06:	5a                   	pop    %edx
80103b07:	53                   	push   %ebx
80103b08:	57                   	push   %edi
80103b09:	e8 02 0a 00 00       	call   80104510 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b0e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b14:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b1a:	83 c4 10             	add    $0x10,%esp
80103b1d:	05 00 02 00 00       	add    $0x200,%eax
80103b22:	39 c2                	cmp    %eax,%edx
80103b24:	75 2a                	jne    80103b50 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103b26:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b2c:	85 c0                	test   %eax,%eax
80103b2e:	75 c0                	jne    80103af0 <pipewrite+0x60>
        release(&p->lock);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	53                   	push   %ebx
80103b34:	e8 f7 0e 00 00       	call   80104a30 <release>
        return -1;
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b44:	5b                   	pop    %ebx
80103b45:	5e                   	pop    %esi
80103b46:	5f                   	pop    %edi
80103b47:	5d                   	pop    %ebp
80103b48:	c3                   	ret
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b53:	8d 42 01             	lea    0x1(%edx),%eax
80103b56:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80103b5c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b5f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b68:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80103b6c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103b73:	39 c1                	cmp    %eax,%ecx
80103b75:	0f 85 50 ff ff ff    	jne    80103acb <pipewrite+0x3b>
80103b7b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b7e:	83 ec 0c             	sub    $0xc,%esp
80103b81:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b87:	50                   	push   %eax
80103b88:	e8 43 0a 00 00       	call   801045d0 <wakeup>
  release(&p->lock);
80103b8d:	89 1c 24             	mov    %ebx,(%esp)
80103b90:	e8 9b 0e 00 00       	call   80104a30 <release>
  return n;
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	89 f8                	mov    %edi,%eax
80103b9a:	eb a5                	jmp    80103b41 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b9f:	eb b2                	jmp    80103b53 <pipewrite+0xc3>
80103ba1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ba8:	00 
80103ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	57                   	push   %edi
80103bb4:	56                   	push   %esi
80103bb5:	53                   	push   %ebx
80103bb6:	83 ec 18             	sub    $0x18,%esp
80103bb9:	8b 75 08             	mov    0x8(%ebp),%esi
80103bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103bbf:	56                   	push   %esi
80103bc0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103bc6:	e8 c5 0e 00 00       	call   80104a90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bcb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bd1:	83 c4 10             	add    $0x10,%esp
80103bd4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103bda:	74 2f                	je     80103c0b <piperead+0x5b>
80103bdc:	eb 37                	jmp    80103c15 <piperead+0x65>
80103bde:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103be0:	e8 6b 02 00 00       	call   80103e50 <myproc>
80103be5:	8b 40 24             	mov    0x24(%eax),%eax
80103be8:	85 c0                	test   %eax,%eax
80103bea:	0f 85 80 00 00 00    	jne    80103c70 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bf0:	83 ec 08             	sub    $0x8,%esp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
80103bf5:	e8 16 09 00 00       	call   80104510 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bfa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c09:	75 0a                	jne    80103c15 <piperead+0x65>
80103c0b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103c11:	85 d2                	test   %edx,%edx
80103c13:	75 cb                	jne    80103be0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103c18:	31 db                	xor    %ebx,%ebx
80103c1a:	85 c9                	test   %ecx,%ecx
80103c1c:	7f 26                	jg     80103c44 <piperead+0x94>
80103c1e:	eb 2c                	jmp    80103c4c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c20:	8d 48 01             	lea    0x1(%eax),%ecx
80103c23:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c28:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c2e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c33:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c36:	83 c3 01             	add    $0x1,%ebx
80103c39:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c3c:	74 0e                	je     80103c4c <piperead+0x9c>
80103c3e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103c44:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c4a:	75 d4                	jne    80103c20 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c4c:	83 ec 0c             	sub    $0xc,%esp
80103c4f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c55:	50                   	push   %eax
80103c56:	e8 75 09 00 00       	call   801045d0 <wakeup>
  release(&p->lock);
80103c5b:	89 34 24             	mov    %esi,(%esp)
80103c5e:	e8 cd 0d 00 00       	call   80104a30 <release>
  return i;
80103c63:	83 c4 10             	add    $0x10,%esp
}
80103c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c69:	89 d8                	mov    %ebx,%eax
80103c6b:	5b                   	pop    %ebx
80103c6c:	5e                   	pop    %esi
80103c6d:	5f                   	pop    %edi
80103c6e:	5d                   	pop    %ebp
80103c6f:	c3                   	ret
      release(&p->lock);
80103c70:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c78:	56                   	push   %esi
80103c79:	e8 b2 0d 00 00       	call   80104a30 <release>
      return -1;
80103c7e:	83 c4 10             	add    $0x10,%esp
}
80103c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c84:	89 d8                	mov    %ebx,%eax
80103c86:	5b                   	pop    %ebx
80103c87:	5e                   	pop    %esi
80103c88:	5f                   	pop    %edi
80103c89:	5d                   	pop    %ebp
80103c8a:	c3                   	ret
80103c8b:	66 90                	xchg   %ax,%ax
80103c8d:	66 90                	xchg   %ax,%ax
80103c8f:	90                   	nop

80103c90 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c94:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103c99:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c9c:	68 20 2d 11 80       	push   $0x80112d20
80103ca1:	e8 ea 0d 00 00       	call   80104a90 <acquire>
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	eb 10                	jmp    80103cbb <allocproc+0x2b>
80103cab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb0:	83 c3 7c             	add    $0x7c,%ebx
80103cb3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103cb9:	74 75                	je     80103d30 <allocproc+0xa0>
    if(p->state == UNUSED)
80103cbb:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cbe:	85 c0                	test   %eax,%eax
80103cc0:	75 ee                	jne    80103cb0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103cc2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103cc7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103cca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cd1:	89 43 10             	mov    %eax,0x10(%ebx)
80103cd4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cd7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103cdc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ce2:	e8 49 0d 00 00       	call   80104a30 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ce7:	e8 64 ee ff ff       	call   80102b50 <kalloc>
80103cec:	83 c4 10             	add    $0x10,%esp
80103cef:	89 43 08             	mov    %eax,0x8(%ebx)
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	74 53                	je     80103d49 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cf6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cfc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d04:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d07:	c7 40 14 42 5d 10 80 	movl   $0x80105d42,0x14(%eax)
  p->context = (struct context*)sp;
80103d0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d11:	6a 14                	push   $0x14
80103d13:	6a 00                	push   $0x0
80103d15:	50                   	push   %eax
80103d16:	e8 75 0e 00 00       	call   80104b90 <memset>
  p->context->eip = (uint)forkret;
80103d1b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103d1e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d21:	c7 40 10 60 3d 10 80 	movl   $0x80103d60,0x10(%eax)
}
80103d28:	89 d8                	mov    %ebx,%eax
80103d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d2d:	c9                   	leave
80103d2e:	c3                   	ret
80103d2f:	90                   	nop
  release(&ptable.lock);
80103d30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d35:	68 20 2d 11 80       	push   $0x80112d20
80103d3a:	e8 f1 0c 00 00       	call   80104a30 <release>
  return 0;
80103d3f:	83 c4 10             	add    $0x10,%esp
}
80103d42:	89 d8                	mov    %ebx,%eax
80103d44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d47:	c9                   	leave
80103d48:	c3                   	ret
    p->state = UNUSED;
80103d49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103d50:	31 db                	xor    %ebx,%ebx
80103d52:	eb ee                	jmp    80103d42 <allocproc+0xb2>
80103d54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d5b:	00 
80103d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d66:	68 20 2d 11 80       	push   $0x80112d20
80103d6b:	e8 c0 0c 00 00       	call   80104a30 <release>

  if (first) {
80103d70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	85 c0                	test   %eax,%eax
80103d7a:	75 04                	jne    80103d80 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d7c:	c9                   	leave
80103d7d:	c3                   	ret
80103d7e:	66 90                	xchg   %ax,%ax
    first = 0;
80103d80:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d87:	00 00 00 
    iinit(ROOTDEV);
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	6a 01                	push   $0x1
80103d8f:	e8 dc dc ff ff       	call   80101a70 <iinit>
    initlog(ROOTDEV);
80103d94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d9b:	e8 f0 f3 ff ff       	call   80103190 <initlog>
}
80103da0:	83 c4 10             	add    $0x10,%esp
80103da3:	c9                   	leave
80103da4:	c3                   	ret
80103da5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dac:	00 
80103dad:	8d 76 00             	lea    0x0(%esi),%esi

80103db0 <pinit>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103db6:	68 b6 78 10 80       	push   $0x801078b6
80103dbb:	68 20 2d 11 80       	push   $0x80112d20
80103dc0:	e8 db 0a 00 00       	call   801048a0 <initlock>
}
80103dc5:	83 c4 10             	add    $0x10,%esp
80103dc8:	c9                   	leave
80103dc9:	c3                   	ret
80103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dd0 <mycpu>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd5:	9c                   	pushf
80103dd6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dd7:	f6 c4 02             	test   $0x2,%ah
80103dda:	75 46                	jne    80103e22 <mycpu+0x52>
  apicid = lapicid();
80103ddc:	e8 df ef ff ff       	call   80102dc0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103de1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103de7:	85 f6                	test   %esi,%esi
80103de9:	7e 2a                	jle    80103e15 <mycpu+0x45>
80103deb:	31 d2                	xor    %edx,%edx
80103ded:	eb 08                	jmp    80103df7 <mycpu+0x27>
80103def:	90                   	nop
80103df0:	83 c2 01             	add    $0x1,%edx
80103df3:	39 f2                	cmp    %esi,%edx
80103df5:	74 1e                	je     80103e15 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103df7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103dfd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103e04:	39 c3                	cmp    %eax,%ebx
80103e06:	75 e8                	jne    80103df0 <mycpu+0x20>
}
80103e08:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103e0b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103e11:	5b                   	pop    %ebx
80103e12:	5e                   	pop    %esi
80103e13:	5d                   	pop    %ebp
80103e14:	c3                   	ret
  panic("unknown apicid\n");
80103e15:	83 ec 0c             	sub    $0xc,%esp
80103e18:	68 bd 78 10 80       	push   $0x801078bd
80103e1d:	e8 4e c5 ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e22:	83 ec 0c             	sub    $0xc,%esp
80103e25:	68 74 7c 10 80       	push   $0x80107c74
80103e2a:	e8 41 c5 ff ff       	call   80100370 <panic>
80103e2f:	90                   	nop

80103e30 <cpuid>:
cpuid() {
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e36:	e8 95 ff ff ff       	call   80103dd0 <mycpu>
}
80103e3b:	c9                   	leave
  return mycpu()-cpus;
80103e3c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103e41:	c1 f8 04             	sar    $0x4,%eax
80103e44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e4a:	c3                   	ret
80103e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e50 <myproc>:
myproc(void) {
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e57:	e8 e4 0a 00 00       	call   80104940 <pushcli>
  c = mycpu();
80103e5c:	e8 6f ff ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
80103e61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e67:	e8 24 0b 00 00       	call   80104990 <popcli>
}
80103e6c:	89 d8                	mov    %ebx,%eax
80103e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e71:	c9                   	leave
80103e72:	c3                   	ret
80103e73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e7a:	00 
80103e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e80 <userinit>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	53                   	push   %ebx
80103e84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e87:	e8 04 fe ff ff       	call   80103c90 <allocproc>
80103e8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e8e:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  if((p->pgdir = setupkvm()) == 0)
80103e93:	e8 78 34 00 00       	call   80107310 <setupkvm>
80103e98:	89 43 04             	mov    %eax,0x4(%ebx)
80103e9b:	85 c0                	test   %eax,%eax
80103e9d:	0f 84 bd 00 00 00    	je     80103f60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ea3:	83 ec 04             	sub    $0x4,%esp
80103ea6:	68 2c 00 00 00       	push   $0x2c
80103eab:	68 60 b4 10 80       	push   $0x8010b460
80103eb0:	50                   	push   %eax
80103eb1:	e8 3a 31 00 00       	call   80106ff0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103eb6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103eb9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ebf:	6a 4c                	push   $0x4c
80103ec1:	6a 00                	push   $0x0
80103ec3:	ff 73 18             	push   0x18(%ebx)
80103ec6:	e8 c5 0c 00 00       	call   80104b90 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ecb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ece:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ed3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ed6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103edb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103edf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ee6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103eed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ef1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ef8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103efc:	8b 43 18             	mov    0x18(%ebx),%eax
80103eff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f06:	8b 43 18             	mov    0x18(%ebx),%eax
80103f09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f10:	8b 43 18             	mov    0x18(%ebx),%eax
80103f13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f1d:	6a 10                	push   $0x10
80103f1f:	68 e6 78 10 80       	push   $0x801078e6
80103f24:	50                   	push   %eax
80103f25:	e8 16 0e 00 00       	call   80104d40 <safestrcpy>
  p->cwd = namei("/");
80103f2a:	c7 04 24 ef 78 10 80 	movl   $0x801078ef,(%esp)
80103f31:	e8 3a e6 ff ff       	call   80102570 <namei>
80103f36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f39:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f40:	e8 4b 0b 00 00       	call   80104a90 <acquire>
  p->state = RUNNABLE;
80103f45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f53:	e8 d8 0a 00 00       	call   80104a30 <release>
}
80103f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f5b:	83 c4 10             	add    $0x10,%esp
80103f5e:	c9                   	leave
80103f5f:	c3                   	ret
    panic("userinit: out of memory?");
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	68 cd 78 10 80       	push   $0x801078cd
80103f68:	e8 03 c4 ff ff       	call   80100370 <panic>
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi

80103f70 <growproc>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	56                   	push   %esi
80103f74:	53                   	push   %ebx
80103f75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f78:	e8 c3 09 00 00       	call   80104940 <pushcli>
  c = mycpu();
80103f7d:	e8 4e fe ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
80103f82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f88:	e8 03 0a 00 00       	call   80104990 <popcli>
  sz = curproc->sz;
80103f8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f8f:	85 f6                	test   %esi,%esi
80103f91:	7f 1d                	jg     80103fb0 <growproc+0x40>
  } else if(n < 0){
80103f93:	75 3b                	jne    80103fd0 <growproc+0x60>
  switchuvm(curproc);
80103f95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f9a:	53                   	push   %ebx
80103f9b:	e8 40 2f 00 00       	call   80106ee0 <switchuvm>
  return 0;
80103fa0:	83 c4 10             	add    $0x10,%esp
80103fa3:	31 c0                	xor    %eax,%eax
}
80103fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fa8:	5b                   	pop    %ebx
80103fa9:	5e                   	pop    %esi
80103faa:	5d                   	pop    %ebp
80103fab:	c3                   	ret
80103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 c6                	add    %eax,%esi
80103fb5:	56                   	push   %esi
80103fb6:	50                   	push   %eax
80103fb7:	ff 73 04             	push   0x4(%ebx)
80103fba:	e8 81 31 00 00       	call   80107140 <allocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 cf                	jne    80103f95 <growproc+0x25>
      return -1;
80103fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fcb:	eb d8                	jmp    80103fa5 <growproc+0x35>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fd0:	83 ec 04             	sub    $0x4,%esp
80103fd3:	01 c6                	add    %eax,%esi
80103fd5:	56                   	push   %esi
80103fd6:	50                   	push   %eax
80103fd7:	ff 73 04             	push   0x4(%ebx)
80103fda:	e8 81 32 00 00       	call   80107260 <deallocuvm>
80103fdf:	83 c4 10             	add    $0x10,%esp
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	75 af                	jne    80103f95 <growproc+0x25>
80103fe6:	eb de                	jmp    80103fc6 <growproc+0x56>
80103fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fef:	00 

80103ff0 <fork>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ff9:	e8 42 09 00 00       	call   80104940 <pushcli>
  c = mycpu();
80103ffe:	e8 cd fd ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
80104003:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104009:	e8 82 09 00 00       	call   80104990 <popcli>
  if((np = allocproc()) == 0){
8010400e:	e8 7d fc ff ff       	call   80103c90 <allocproc>
80104013:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104016:	85 c0                	test   %eax,%eax
80104018:	0f 84 d6 00 00 00    	je     801040f4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010401e:	83 ec 08             	sub    $0x8,%esp
80104021:	ff 33                	push   (%ebx)
80104023:	89 c7                	mov    %eax,%edi
80104025:	ff 73 04             	push   0x4(%ebx)
80104028:	e8 d3 33 00 00       	call   80107400 <copyuvm>
8010402d:	83 c4 10             	add    $0x10,%esp
80104030:	89 47 04             	mov    %eax,0x4(%edi)
80104033:	85 c0                	test   %eax,%eax
80104035:	0f 84 9a 00 00 00    	je     801040d5 <fork+0xe5>
  np->sz = curproc->sz;
8010403b:	8b 03                	mov    (%ebx),%eax
8010403d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104040:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104042:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104045:	89 c8                	mov    %ecx,%eax
80104047:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010404a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010404f:	8b 73 18             	mov    0x18(%ebx),%esi
80104052:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104054:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104056:	8b 40 18             	mov    0x18(%eax),%eax
80104059:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104060:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104064:	85 c0                	test   %eax,%eax
80104066:	74 13                	je     8010407b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	50                   	push   %eax
8010406c:	e8 3f d3 ff ff       	call   801013b0 <filedup>
80104071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104074:	83 c4 10             	add    $0x10,%esp
80104077:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010407b:	83 c6 01             	add    $0x1,%esi
8010407e:	83 fe 10             	cmp    $0x10,%esi
80104081:	75 dd                	jne    80104060 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104083:	83 ec 0c             	sub    $0xc,%esp
80104086:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104089:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010408c:	e8 cf db ff ff       	call   80101c60 <idup>
80104091:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104094:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104097:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010409a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010409d:	6a 10                	push   $0x10
8010409f:	53                   	push   %ebx
801040a0:	50                   	push   %eax
801040a1:	e8 9a 0c 00 00       	call   80104d40 <safestrcpy>
  pid = np->pid;
801040a6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801040a9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040b0:	e8 db 09 00 00       	call   80104a90 <acquire>
  np->state = RUNNABLE;
801040b5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801040bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040c3:	e8 68 09 00 00       	call   80104a30 <release>
  return pid;
801040c8:	83 c4 10             	add    $0x10,%esp
}
801040cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ce:	89 d8                	mov    %ebx,%eax
801040d0:	5b                   	pop    %ebx
801040d1:	5e                   	pop    %esi
801040d2:	5f                   	pop    %edi
801040d3:	5d                   	pop    %ebp
801040d4:	c3                   	ret
    kfree(np->kstack);
801040d5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	ff 73 08             	push   0x8(%ebx)
801040de:	e8 ad e8 ff ff       	call   80102990 <kfree>
    np->kstack = 0;
801040e3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040ea:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040ed:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040f4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040f9:	eb d0                	jmp    801040cb <fork+0xdb>
801040fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104100 <scheduler>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104109:	e8 c2 fc ff ff       	call   80103dd0 <mycpu>
  c->proc = 0;
8010410e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104115:	00 00 00 
  struct cpu *c = mycpu();
80104118:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010411a:	8d 78 04             	lea    0x4(%eax),%edi
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104120:	fb                   	sti
    acquire(&ptable.lock);
80104121:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104124:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80104129:	68 20 2d 11 80       	push   $0x80112d20
8010412e:	e8 5d 09 00 00       	call   80104a90 <acquire>
80104133:	83 c4 10             	add    $0x10,%esp
80104136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010413d:	00 
8010413e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104140:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104144:	75 33                	jne    80104179 <scheduler+0x79>
      switchuvm(p);
80104146:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104149:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010414f:	53                   	push   %ebx
80104150:	e8 8b 2d 00 00       	call   80106ee0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104155:	58                   	pop    %eax
80104156:	5a                   	pop    %edx
80104157:	ff 73 1c             	push   0x1c(%ebx)
8010415a:	57                   	push   %edi
      p->state = RUNNING;
8010415b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104162:	e8 34 0c 00 00       	call   80104d9b <swtch>
      switchkvm();
80104167:	e8 64 2d 00 00       	call   80106ed0 <switchkvm>
      c->proc = 0;
8010416c:	83 c4 10             	add    $0x10,%esp
8010416f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104176:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104179:	83 c3 7c             	add    $0x7c,%ebx
8010417c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104182:	75 bc                	jne    80104140 <scheduler+0x40>
    release(&ptable.lock);
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	68 20 2d 11 80       	push   $0x80112d20
8010418c:	e8 9f 08 00 00       	call   80104a30 <release>
    sti();
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	eb 8a                	jmp    80104120 <scheduler+0x20>
80104196:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010419d:	00 
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <sched>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
  pushcli();
801041a5:	e8 96 07 00 00       	call   80104940 <pushcli>
  c = mycpu();
801041aa:	e8 21 fc ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
801041af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b5:	e8 d6 07 00 00       	call   80104990 <popcli>
  if(!holding(&ptable.lock))
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	68 20 2d 11 80       	push   $0x80112d20
801041c2:	e8 29 08 00 00       	call   801049f0 <holding>
801041c7:	83 c4 10             	add    $0x10,%esp
801041ca:	85 c0                	test   %eax,%eax
801041cc:	74 4f                	je     8010421d <sched+0x7d>
  if(mycpu()->ncli != 1)
801041ce:	e8 fd fb ff ff       	call   80103dd0 <mycpu>
801041d3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041da:	75 68                	jne    80104244 <sched+0xa4>
  if(p->state == RUNNING)
801041dc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041e0:	74 55                	je     80104237 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e2:	9c                   	pushf
801041e3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e4:	f6 c4 02             	test   $0x2,%ah
801041e7:	75 41                	jne    8010422a <sched+0x8a>
  intena = mycpu()->intena;
801041e9:	e8 e2 fb ff ff       	call   80103dd0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041ee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041f1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041f7:	e8 d4 fb ff ff       	call   80103dd0 <mycpu>
801041fc:	83 ec 08             	sub    $0x8,%esp
801041ff:	ff 70 04             	push   0x4(%eax)
80104202:	53                   	push   %ebx
80104203:	e8 93 0b 00 00       	call   80104d9b <swtch>
  mycpu()->intena = intena;
80104208:	e8 c3 fb ff ff       	call   80103dd0 <mycpu>
}
8010420d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104210:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104216:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104219:	5b                   	pop    %ebx
8010421a:	5e                   	pop    %esi
8010421b:	5d                   	pop    %ebp
8010421c:	c3                   	ret
    panic("sched ptable.lock");
8010421d:	83 ec 0c             	sub    $0xc,%esp
80104220:	68 f1 78 10 80       	push   $0x801078f1
80104225:	e8 46 c1 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
8010422a:	83 ec 0c             	sub    $0xc,%esp
8010422d:	68 1d 79 10 80       	push   $0x8010791d
80104232:	e8 39 c1 ff ff       	call   80100370 <panic>
    panic("sched running");
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	68 0f 79 10 80       	push   $0x8010790f
8010423f:	e8 2c c1 ff ff       	call   80100370 <panic>
    panic("sched locks");
80104244:	83 ec 0c             	sub    $0xc,%esp
80104247:	68 03 79 10 80       	push   $0x80107903
8010424c:	e8 1f c1 ff ff       	call   80100370 <panic>
80104251:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104258:	00 
80104259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104260 <exit>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104269:	e8 e2 fb ff ff       	call   80103e50 <myproc>
  if(curproc == initproc)
8010426e:	39 05 54 4c 11 80    	cmp    %eax,0x80114c54
80104274:	0f 84 fd 00 00 00    	je     80104377 <exit+0x117>
8010427a:	89 c3                	mov    %eax,%ebx
8010427c:	8d 70 28             	lea    0x28(%eax),%esi
8010427f:	8d 78 68             	lea    0x68(%eax),%edi
80104282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104288:	8b 06                	mov    (%esi),%eax
8010428a:	85 c0                	test   %eax,%eax
8010428c:	74 12                	je     801042a0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010428e:	83 ec 0c             	sub    $0xc,%esp
80104291:	50                   	push   %eax
80104292:	e8 69 d1 ff ff       	call   80101400 <fileclose>
      curproc->ofile[fd] = 0;
80104297:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010429d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801042a0:	83 c6 04             	add    $0x4,%esi
801042a3:	39 f7                	cmp    %esi,%edi
801042a5:	75 e1                	jne    80104288 <exit+0x28>
  begin_op();
801042a7:	e8 84 ef ff ff       	call   80103230 <begin_op>
  iput(curproc->cwd);
801042ac:	83 ec 0c             	sub    $0xc,%esp
801042af:	ff 73 68             	push   0x68(%ebx)
801042b2:	e8 09 db ff ff       	call   80101dc0 <iput>
  end_op();
801042b7:	e8 e4 ef ff ff       	call   801032a0 <end_op>
  curproc->cwd = 0;
801042bc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801042c3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042ca:	e8 c1 07 00 00       	call   80104a90 <acquire>
  wakeup1(curproc->parent);
801042cf:	8b 53 14             	mov    0x14(%ebx),%edx
801042d2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042d5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042da:	eb 0e                	jmp    801042ea <exit+0x8a>
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e0:	83 c0 7c             	add    $0x7c,%eax
801042e3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801042e8:	74 1c                	je     80104306 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801042ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042ee:	75 f0                	jne    801042e0 <exit+0x80>
801042f0:	3b 50 20             	cmp    0x20(%eax),%edx
801042f3:	75 eb                	jne    801042e0 <exit+0x80>
      p->state = RUNNABLE;
801042f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042fc:	83 c0 7c             	add    $0x7c,%eax
801042ff:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104304:	75 e4                	jne    801042ea <exit+0x8a>
      p->parent = initproc;
80104306:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010430c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104311:	eb 10                	jmp    80104323 <exit+0xc3>
80104313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104318:	83 c2 7c             	add    $0x7c,%edx
8010431b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80104321:	74 3b                	je     8010435e <exit+0xfe>
    if(p->parent == curproc){
80104323:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104326:	75 f0                	jne    80104318 <exit+0xb8>
      if(p->state == ZOMBIE)
80104328:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010432c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010432f:	75 e7                	jne    80104318 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104331:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104336:	eb 12                	jmp    8010434a <exit+0xea>
80104338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010433f:	00 
80104340:	83 c0 7c             	add    $0x7c,%eax
80104343:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104348:	74 ce                	je     80104318 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010434a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010434e:	75 f0                	jne    80104340 <exit+0xe0>
80104350:	3b 48 20             	cmp    0x20(%eax),%ecx
80104353:	75 eb                	jne    80104340 <exit+0xe0>
      p->state = RUNNABLE;
80104355:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010435c:	eb e2                	jmp    80104340 <exit+0xe0>
  curproc->state = ZOMBIE;
8010435e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104365:	e8 36 fe ff ff       	call   801041a0 <sched>
  panic("zombie exit");
8010436a:	83 ec 0c             	sub    $0xc,%esp
8010436d:	68 3e 79 10 80       	push   $0x8010793e
80104372:	e8 f9 bf ff ff       	call   80100370 <panic>
    panic("init exiting");
80104377:	83 ec 0c             	sub    $0xc,%esp
8010437a:	68 31 79 10 80       	push   $0x80107931
8010437f:	e8 ec bf ff ff       	call   80100370 <panic>
80104384:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010438b:	00 
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104390 <wait>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
  pushcli();
80104395:	e8 a6 05 00 00       	call   80104940 <pushcli>
  c = mycpu();
8010439a:	e8 31 fa ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
8010439f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043a5:	e8 e6 05 00 00       	call   80104990 <popcli>
  acquire(&ptable.lock);
801043aa:	83 ec 0c             	sub    $0xc,%esp
801043ad:	68 20 2d 11 80       	push   $0x80112d20
801043b2:	e8 d9 06 00 00       	call   80104a90 <acquire>
801043b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043bc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801043c1:	eb 10                	jmp    801043d3 <wait+0x43>
801043c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801043c8:	83 c3 7c             	add    $0x7c,%ebx
801043cb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801043d1:	74 1b                	je     801043ee <wait+0x5e>
      if(p->parent != curproc)
801043d3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043d6:	75 f0                	jne    801043c8 <wait+0x38>
      if(p->state == ZOMBIE){
801043d8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043dc:	74 62                	je     80104440 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043de:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043e1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801043ec:	75 e5                	jne    801043d3 <wait+0x43>
    if(!havekids || curproc->killed){
801043ee:	85 c0                	test   %eax,%eax
801043f0:	0f 84 a0 00 00 00    	je     80104496 <wait+0x106>
801043f6:	8b 46 24             	mov    0x24(%esi),%eax
801043f9:	85 c0                	test   %eax,%eax
801043fb:	0f 85 95 00 00 00    	jne    80104496 <wait+0x106>
  pushcli();
80104401:	e8 3a 05 00 00       	call   80104940 <pushcli>
  c = mycpu();
80104406:	e8 c5 f9 ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
8010440b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104411:	e8 7a 05 00 00       	call   80104990 <popcli>
  if(p == 0)
80104416:	85 db                	test   %ebx,%ebx
80104418:	0f 84 8f 00 00 00    	je     801044ad <wait+0x11d>
  p->chan = chan;
8010441e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104421:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104428:	e8 73 fd ff ff       	call   801041a0 <sched>
  p->chan = 0;
8010442d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104434:	eb 84                	jmp    801043ba <wait+0x2a>
80104436:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010443d:	00 
8010443e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104440:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104443:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104446:	ff 73 08             	push   0x8(%ebx)
80104449:	e8 42 e5 ff ff       	call   80102990 <kfree>
        p->kstack = 0;
8010444e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104455:	5a                   	pop    %edx
80104456:	ff 73 04             	push   0x4(%ebx)
80104459:	e8 32 2e 00 00       	call   80107290 <freevm>
        p->pid = 0;
8010445e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104465:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010446c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104470:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104477:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010447e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104485:	e8 a6 05 00 00       	call   80104a30 <release>
        return pid;
8010448a:	83 c4 10             	add    $0x10,%esp
}
8010448d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104490:	89 f0                	mov    %esi,%eax
80104492:	5b                   	pop    %ebx
80104493:	5e                   	pop    %esi
80104494:	5d                   	pop    %ebp
80104495:	c3                   	ret
      release(&ptable.lock);
80104496:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104499:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010449e:	68 20 2d 11 80       	push   $0x80112d20
801044a3:	e8 88 05 00 00       	call   80104a30 <release>
      return -1;
801044a8:	83 c4 10             	add    $0x10,%esp
801044ab:	eb e0                	jmp    8010448d <wait+0xfd>
    panic("sleep");
801044ad:	83 ec 0c             	sub    $0xc,%esp
801044b0:	68 4a 79 10 80       	push   $0x8010794a
801044b5:	e8 b6 be ff ff       	call   80100370 <panic>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <yield>:
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044c7:	68 20 2d 11 80       	push   $0x80112d20
801044cc:	e8 bf 05 00 00       	call   80104a90 <acquire>
  pushcli();
801044d1:	e8 6a 04 00 00       	call   80104940 <pushcli>
  c = mycpu();
801044d6:	e8 f5 f8 ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
801044db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044e1:	e8 aa 04 00 00       	call   80104990 <popcli>
  myproc()->state = RUNNABLE;
801044e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044ed:	e8 ae fc ff ff       	call   801041a0 <sched>
  release(&ptable.lock);
801044f2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801044f9:	e8 32 05 00 00       	call   80104a30 <release>
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	83 c4 10             	add    $0x10,%esp
80104504:	c9                   	leave
80104505:	c3                   	ret
80104506:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010450d:	00 
8010450e:	66 90                	xchg   %ax,%ax

80104510 <sleep>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	8b 7d 08             	mov    0x8(%ebp),%edi
8010451c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010451f:	e8 1c 04 00 00       	call   80104940 <pushcli>
  c = mycpu();
80104524:	e8 a7 f8 ff ff       	call   80103dd0 <mycpu>
  p = c->proc;
80104529:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010452f:	e8 5c 04 00 00       	call   80104990 <popcli>
  if(p == 0)
80104534:	85 db                	test   %ebx,%ebx
80104536:	0f 84 87 00 00 00    	je     801045c3 <sleep+0xb3>
  if(lk == 0)
8010453c:	85 f6                	test   %esi,%esi
8010453e:	74 76                	je     801045b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104540:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104546:	74 50                	je     80104598 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	68 20 2d 11 80       	push   $0x80112d20
80104550:	e8 3b 05 00 00       	call   80104a90 <acquire>
    release(lk);
80104555:	89 34 24             	mov    %esi,(%esp)
80104558:	e8 d3 04 00 00       	call   80104a30 <release>
  p->chan = chan;
8010455d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104560:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104567:	e8 34 fc ff ff       	call   801041a0 <sched>
  p->chan = 0;
8010456c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104573:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010457a:	e8 b1 04 00 00       	call   80104a30 <release>
    acquire(lk);
8010457f:	83 c4 10             	add    $0x10,%esp
80104582:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104585:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5f                   	pop    %edi
8010458b:	5d                   	pop    %ebp
    acquire(lk);
8010458c:	e9 ff 04 00 00       	jmp    80104a90 <acquire>
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104598:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010459b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045a2:	e8 f9 fb ff ff       	call   801041a0 <sched>
  p->chan = 0;
801045a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801045ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b1:	5b                   	pop    %ebx
801045b2:	5e                   	pop    %esi
801045b3:	5f                   	pop    %edi
801045b4:	5d                   	pop    %ebp
801045b5:	c3                   	ret
    panic("sleep without lk");
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	68 50 79 10 80       	push   $0x80107950
801045be:	e8 ad bd ff ff       	call   80100370 <panic>
    panic("sleep");
801045c3:	83 ec 0c             	sub    $0xc,%esp
801045c6:	68 4a 79 10 80       	push   $0x8010794a
801045cb:	e8 a0 bd ff ff       	call   80100370 <panic>

801045d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 10             	sub    $0x10,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045da:	68 20 2d 11 80       	push   $0x80112d20
801045df:	e8 ac 04 00 00       	call   80104a90 <acquire>
801045e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045ec:	eb 0c                	jmp    801045fa <wakeup+0x2a>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	83 c0 7c             	add    $0x7c,%eax
801045f3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801045f8:	74 1c                	je     80104616 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801045fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045fe:	75 f0                	jne    801045f0 <wakeup+0x20>
80104600:	3b 58 20             	cmp    0x20(%eax),%ebx
80104603:	75 eb                	jne    801045f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104605:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010460c:	83 c0 7c             	add    $0x7c,%eax
8010460f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104614:	75 e4                	jne    801045fa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104616:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010461d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104620:	c9                   	leave
  release(&ptable.lock);
80104621:	e9 0a 04 00 00       	jmp    80104a30 <release>
80104626:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010462d:	00 
8010462e:	66 90                	xchg   %ax,%ax

80104630 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 10             	sub    $0x10,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010463a:	68 20 2d 11 80       	push   $0x80112d20
8010463f:	e8 4c 04 00 00       	call   80104a90 <acquire>
80104644:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104647:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010464c:	eb 0c                	jmp    8010465a <kill+0x2a>
8010464e:	66 90                	xchg   %ax,%ax
80104650:	83 c0 7c             	add    $0x7c,%eax
80104653:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104658:	74 36                	je     80104690 <kill+0x60>
    if(p->pid == pid){
8010465a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010465d:	75 f1                	jne    80104650 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010465f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104663:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010466a:	75 07                	jne    80104673 <kill+0x43>
        p->state = RUNNABLE;
8010466c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104673:	83 ec 0c             	sub    $0xc,%esp
80104676:	68 20 2d 11 80       	push   $0x80112d20
8010467b:	e8 b0 03 00 00       	call   80104a30 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104683:	83 c4 10             	add    $0x10,%esp
80104686:	31 c0                	xor    %eax,%eax
}
80104688:	c9                   	leave
80104689:	c3                   	ret
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	68 20 2d 11 80       	push   $0x80112d20
80104698:	e8 93 03 00 00       	call   80104a30 <release>
}
8010469d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801046a0:	83 c4 10             	add    $0x10,%esp
801046a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046a8:	c9                   	leave
801046a9:	c3                   	ret
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046b8:	53                   	push   %ebx
801046b9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801046be:	83 ec 3c             	sub    $0x3c,%esp
801046c1:	eb 24                	jmp    801046e7 <procdump+0x37>
801046c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046c8:	83 ec 0c             	sub    $0xc,%esp
801046cb:	68 0f 7b 10 80       	push   $0x80107b0f
801046d0:	e8 8b c0 ff ff       	call   80100760 <cprintf>
801046d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d8:	83 c3 7c             	add    $0x7c,%ebx
801046db:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
801046e1:	0f 84 81 00 00 00    	je     80104768 <procdump+0xb8>
    if(p->state == UNUSED)
801046e7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046ea:	85 c0                	test   %eax,%eax
801046ec:	74 ea                	je     801046d8 <procdump+0x28>
      state = "???";
801046ee:	ba 61 79 10 80       	mov    $0x80107961,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046f3:	83 f8 05             	cmp    $0x5,%eax
801046f6:	77 11                	ja     80104709 <procdump+0x59>
801046f8:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
      state = "???";
801046ff:	b8 61 79 10 80       	mov    $0x80107961,%eax
80104704:	85 d2                	test   %edx,%edx
80104706:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104709:	53                   	push   %ebx
8010470a:	52                   	push   %edx
8010470b:	ff 73 a4             	push   -0x5c(%ebx)
8010470e:	68 65 79 10 80       	push   $0x80107965
80104713:	e8 48 c0 ff ff       	call   80100760 <cprintf>
    if(p->state == SLEEPING){
80104718:	83 c4 10             	add    $0x10,%esp
8010471b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010471f:	75 a7                	jne    801046c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104721:	83 ec 08             	sub    $0x8,%esp
80104724:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104727:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010472a:	50                   	push   %eax
8010472b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010472e:	8b 40 0c             	mov    0xc(%eax),%eax
80104731:	83 c0 08             	add    $0x8,%eax
80104734:	50                   	push   %eax
80104735:	e8 86 01 00 00       	call   801048c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010473a:	83 c4 10             	add    $0x10,%esp
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
80104740:	8b 17                	mov    (%edi),%edx
80104742:	85 d2                	test   %edx,%edx
80104744:	74 82                	je     801046c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104746:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104749:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010474c:	52                   	push   %edx
8010474d:	68 a1 76 10 80       	push   $0x801076a1
80104752:	e8 09 c0 ff ff       	call   80100760 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104757:	83 c4 10             	add    $0x10,%esp
8010475a:	39 f7                	cmp    %esi,%edi
8010475c:	75 e2                	jne    80104740 <procdump+0x90>
8010475e:	e9 65 ff ff ff       	jmp    801046c8 <procdump+0x18>
80104763:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104768:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010476b:	5b                   	pop    %ebx
8010476c:	5e                   	pop    %esi
8010476d:	5f                   	pop    %edi
8010476e:	5d                   	pop    %ebp
8010476f:	c3                   	ret

80104770 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 0c             	sub    $0xc,%esp
80104777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010477a:	68 98 79 10 80       	push   $0x80107998
8010477f:	8d 43 04             	lea    0x4(%ebx),%eax
80104782:	50                   	push   %eax
80104783:	e8 18 01 00 00       	call   801048a0 <initlock>
  lk->name = name;
80104788:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010478b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104791:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104794:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010479b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010479e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a1:	c9                   	leave
801047a2:	c3                   	ret
801047a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047aa:	00 
801047ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047b8:	8d 73 04             	lea    0x4(%ebx),%esi
801047bb:	83 ec 0c             	sub    $0xc,%esp
801047be:	56                   	push   %esi
801047bf:	e8 cc 02 00 00       	call   80104a90 <acquire>
  while (lk->locked) {
801047c4:	8b 13                	mov    (%ebx),%edx
801047c6:	83 c4 10             	add    $0x10,%esp
801047c9:	85 d2                	test   %edx,%edx
801047cb:	74 16                	je     801047e3 <acquiresleep+0x33>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047d0:	83 ec 08             	sub    $0x8,%esp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	e8 36 fd ff ff       	call   80104510 <sleep>
  while (lk->locked) {
801047da:	8b 03                	mov    (%ebx),%eax
801047dc:	83 c4 10             	add    $0x10,%esp
801047df:	85 c0                	test   %eax,%eax
801047e1:	75 ed                	jne    801047d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047e9:	e8 62 f6 ff ff       	call   80103e50 <myproc>
801047ee:	8b 40 10             	mov    0x10(%eax),%eax
801047f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047fa:	5b                   	pop    %ebx
801047fb:	5e                   	pop    %esi
801047fc:	5d                   	pop    %ebp
  release(&lk->lk);
801047fd:	e9 2e 02 00 00       	jmp    80104a30 <release>
80104802:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104809:	00 
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104818:	8d 73 04             	lea    0x4(%ebx),%esi
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	56                   	push   %esi
8010481f:	e8 6c 02 00 00       	call   80104a90 <acquire>
  lk->locked = 0;
80104824:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010482a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104831:	89 1c 24             	mov    %ebx,(%esp)
80104834:	e8 97 fd ff ff       	call   801045d0 <wakeup>
  release(&lk->lk);
80104839:	83 c4 10             	add    $0x10,%esp
8010483c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010483f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104842:	5b                   	pop    %ebx
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
  release(&lk->lk);
80104845:	e9 e6 01 00 00       	jmp    80104a30 <release>
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	31 ff                	xor    %edi,%edi
80104856:	56                   	push   %esi
80104857:	53                   	push   %ebx
80104858:	83 ec 18             	sub    $0x18,%esp
8010485b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010485e:	8d 73 04             	lea    0x4(%ebx),%esi
80104861:	56                   	push   %esi
80104862:	e8 29 02 00 00       	call   80104a90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104867:	8b 03                	mov    (%ebx),%eax
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	85 c0                	test   %eax,%eax
8010486e:	75 18                	jne    80104888 <holdingsleep+0x38>
  release(&lk->lk);
80104870:	83 ec 0c             	sub    $0xc,%esp
80104873:	56                   	push   %esi
80104874:	e8 b7 01 00 00       	call   80104a30 <release>
  return r;
}
80104879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010487c:	89 f8                	mov    %edi,%eax
8010487e:	5b                   	pop    %ebx
8010487f:	5e                   	pop    %esi
80104880:	5f                   	pop    %edi
80104881:	5d                   	pop    %ebp
80104882:	c3                   	ret
80104883:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104888:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010488b:	e8 c0 f5 ff ff       	call   80103e50 <myproc>
80104890:	39 58 10             	cmp    %ebx,0x10(%eax)
80104893:	0f 94 c0             	sete   %al
80104896:	0f b6 c0             	movzbl %al,%eax
80104899:	89 c7                	mov    %eax,%edi
8010489b:	eb d3                	jmp    80104870 <holdingsleep+0x20>
8010489d:	66 90                	xchg   %ax,%ax
8010489f:	90                   	nop

801048a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801048af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801048b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret
801048bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	8b 45 08             	mov    0x8(%ebp),%eax
801048c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048cd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801048d2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801048d7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048dc:	76 10                	jbe    801048ee <getcallerpcs+0x2e>
801048de:	eb 28                	jmp    80104908 <getcallerpcs+0x48>
801048e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ec:	77 1a                	ja     80104908 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801048f1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048f4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048f7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048f9:	83 f8 0a             	cmp    $0xa,%eax
801048fc:	75 e2                	jne    801048e0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104901:	c9                   	leave
80104902:	c3                   	ret
80104903:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104908:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010490b:	83 c1 28             	add    $0x28,%ecx
8010490e:	89 ca                	mov    %ecx,%edx
80104910:	29 c2                	sub    %eax,%edx
80104912:	83 e2 04             	and    $0x4,%edx
80104915:	74 11                	je     80104928 <getcallerpcs+0x68>
    pcs[i] = 0;
80104917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010491d:	83 c0 04             	add    $0x4,%eax
80104920:	39 c1                	cmp    %eax,%ecx
80104922:	74 da                	je     801048fe <getcallerpcs+0x3e>
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104928:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010492e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104931:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104938:	39 c1                	cmp    %eax,%ecx
8010493a:	75 ec                	jne    80104928 <getcallerpcs+0x68>
8010493c:	eb c0                	jmp    801048fe <getcallerpcs+0x3e>
8010493e:	66 90                	xchg   %ax,%ax

80104940 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
80104947:	9c                   	pushf
80104948:	5b                   	pop    %ebx
  asm volatile("cli");
80104949:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010494a:	e8 81 f4 ff ff       	call   80103dd0 <mycpu>
8010494f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104955:	85 c0                	test   %eax,%eax
80104957:	74 17                	je     80104970 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104959:	e8 72 f4 ff ff       	call   80103dd0 <mycpu>
8010495e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104965:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104968:	c9                   	leave
80104969:	c3                   	ret
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104970:	e8 5b f4 ff ff       	call   80103dd0 <mycpu>
80104975:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010497b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104981:	eb d6                	jmp    80104959 <pushcli+0x19>
80104983:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010498a:	00 
8010498b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104990 <popcli>:

void
popcli(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104996:	9c                   	pushf
80104997:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104998:	f6 c4 02             	test   $0x2,%ah
8010499b:	75 35                	jne    801049d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010499d:	e8 2e f4 ff ff       	call   80103dd0 <mycpu>
801049a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049a9:	78 34                	js     801049df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049ab:	e8 20 f4 ff ff       	call   80103dd0 <mycpu>
801049b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049b6:	85 d2                	test   %edx,%edx
801049b8:	74 06                	je     801049c0 <popcli+0x30>
    sti();
}
801049ba:	c9                   	leave
801049bb:	c3                   	ret
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049c0:	e8 0b f4 ff ff       	call   80103dd0 <mycpu>
801049c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049cb:	85 c0                	test   %eax,%eax
801049cd:	74 eb                	je     801049ba <popcli+0x2a>
  asm volatile("sti");
801049cf:	fb                   	sti
}
801049d0:	c9                   	leave
801049d1:	c3                   	ret
    panic("popcli - interruptible");
801049d2:	83 ec 0c             	sub    $0xc,%esp
801049d5:	68 a3 79 10 80       	push   $0x801079a3
801049da:	e8 91 b9 ff ff       	call   80100370 <panic>
    panic("popcli");
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	68 ba 79 10 80       	push   $0x801079ba
801049e7:	e8 84 b9 ff ff       	call   80100370 <panic>
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <holding>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 75 08             	mov    0x8(%ebp),%esi
801049f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801049fa:	e8 41 ff ff ff       	call   80104940 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049ff:	8b 06                	mov    (%esi),%eax
80104a01:	85 c0                	test   %eax,%eax
80104a03:	75 0b                	jne    80104a10 <holding+0x20>
  popcli();
80104a05:	e8 86 ff ff ff       	call   80104990 <popcli>
}
80104a0a:	89 d8                	mov    %ebx,%eax
80104a0c:	5b                   	pop    %ebx
80104a0d:	5e                   	pop    %esi
80104a0e:	5d                   	pop    %ebp
80104a0f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104a10:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a13:	e8 b8 f3 ff ff       	call   80103dd0 <mycpu>
80104a18:	39 c3                	cmp    %eax,%ebx
80104a1a:	0f 94 c3             	sete   %bl
  popcli();
80104a1d:	e8 6e ff ff ff       	call   80104990 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a22:	0f b6 db             	movzbl %bl,%ebx
}
80104a25:	89 d8                	mov    %ebx,%eax
80104a27:	5b                   	pop    %ebx
80104a28:	5e                   	pop    %esi
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret
80104a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a30 <release>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a38:	e8 03 ff ff ff       	call   80104940 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a3d:	8b 03                	mov    (%ebx),%eax
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	75 15                	jne    80104a58 <release+0x28>
  popcli();
80104a43:	e8 48 ff ff ff       	call   80104990 <popcli>
    panic("release");
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	68 c1 79 10 80       	push   $0x801079c1
80104a50:	e8 1b b9 ff ff       	call   80100370 <panic>
80104a55:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a58:	8b 73 08             	mov    0x8(%ebx),%esi
80104a5b:	e8 70 f3 ff ff       	call   80103dd0 <mycpu>
80104a60:	39 c6                	cmp    %eax,%esi
80104a62:	75 df                	jne    80104a43 <release+0x13>
  popcli();
80104a64:	e8 27 ff ff ff       	call   80104990 <popcli>
  lk->pcs[0] = 0;
80104a69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a70:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a77:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
  popcli();
80104a88:	e9 03 ff ff ff       	jmp    80104990 <popcli>
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi

80104a90 <acquire>:
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a97:	e8 a4 fe ff ff       	call   80104940 <pushcli>
  if(holding(lk))
80104a9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a9f:	e8 9c fe ff ff       	call   80104940 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aa4:	8b 03                	mov    (%ebx),%eax
80104aa6:	85 c0                	test   %eax,%eax
80104aa8:	0f 85 b2 00 00 00    	jne    80104b60 <acquire+0xd0>
  popcli();
80104aae:	e8 dd fe ff ff       	call   80104990 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104ab3:	b9 01 00 00 00       	mov    $0x1,%ecx
80104ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104abf:	00 
  while(xchg(&lk->locked, 1) != 0)
80104ac0:	8b 55 08             	mov    0x8(%ebp),%edx
80104ac3:	89 c8                	mov    %ecx,%eax
80104ac5:	f0 87 02             	lock xchg %eax,(%edx)
80104ac8:	85 c0                	test   %eax,%eax
80104aca:	75 f4                	jne    80104ac0 <acquire+0x30>
  __sync_synchronize();
80104acc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ad1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ad4:	e8 f7 f2 ff ff       	call   80103dd0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104adc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104ade:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ae1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104ae7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104aec:	77 32                	ja     80104b20 <acquire+0x90>
  ebp = (uint*)v - 2;
80104aee:	89 e8                	mov    %ebp,%eax
80104af0:	eb 14                	jmp    80104b06 <acquire+0x76>
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104afe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b04:	77 1a                	ja     80104b20 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104b06:	8b 58 04             	mov    0x4(%eax),%ebx
80104b09:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b0d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b10:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b12:	83 fa 0a             	cmp    $0xa,%edx
80104b15:	75 e1                	jne    80104af8 <acquire+0x68>
}
80104b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b1a:	c9                   	leave
80104b1b:	c3                   	ret
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b20:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104b24:	83 c1 34             	add    $0x34,%ecx
80104b27:	89 ca                	mov    %ecx,%edx
80104b29:	29 c2                	sub    %eax,%edx
80104b2b:	83 e2 04             	and    $0x4,%edx
80104b2e:	74 10                	je     80104b40 <acquire+0xb0>
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b36:	83 c0 04             	add    $0x4,%eax
80104b39:	39 c1                	cmp    %eax,%ecx
80104b3b:	74 da                	je     80104b17 <acquire+0x87>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b46:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104b49:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104b50:	39 c1                	cmp    %eax,%ecx
80104b52:	75 ec                	jne    80104b40 <acquire+0xb0>
80104b54:	eb c1                	jmp    80104b17 <acquire+0x87>
80104b56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5d:	00 
80104b5e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104b60:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b63:	e8 68 f2 ff ff       	call   80103dd0 <mycpu>
80104b68:	39 c3                	cmp    %eax,%ebx
80104b6a:	0f 85 3e ff ff ff    	jne    80104aae <acquire+0x1e>
  popcli();
80104b70:	e8 1b fe ff ff       	call   80104990 <popcli>
    panic("acquire");
80104b75:	83 ec 0c             	sub    $0xc,%esp
80104b78:	68 c9 79 10 80       	push   $0x801079c9
80104b7d:	e8 ee b7 ff ff       	call   80100370 <panic>
80104b82:	66 90                	xchg   %ax,%ax
80104b84:	66 90                	xchg   %ax,%ax
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	8b 55 08             	mov    0x8(%ebp),%edx
80104b97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b9a:	89 d0                	mov    %edx,%eax
80104b9c:	09 c8                	or     %ecx,%eax
80104b9e:	a8 03                	test   $0x3,%al
80104ba0:	75 1e                	jne    80104bc0 <memset+0x30>
    c &= 0xFF;
80104ba2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ba6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104ba9:	89 d7                	mov    %edx,%edi
80104bab:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104bb1:	fc                   	cld
80104bb2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104bb4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104bb7:	89 d0                	mov    %edx,%eax
80104bb9:	c9                   	leave
80104bba:	c3                   	ret
80104bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc3:	89 d7                	mov    %edx,%edi
80104bc5:	fc                   	cld
80104bc6:	f3 aa                	rep stos %al,%es:(%edi)
80104bc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104bcb:	89 d0                	mov    %edx,%eax
80104bcd:	c9                   	leave
80104bce:	c3                   	ret
80104bcf:	90                   	nop

80104bd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	8b 75 10             	mov    0x10(%ebp),%esi
80104bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104bda:	53                   	push   %ebx
80104bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bde:	85 f6                	test   %esi,%esi
80104be0:	74 2e                	je     80104c10 <memcmp+0x40>
80104be2:	01 c6                	add    %eax,%esi
80104be4:	eb 14                	jmp    80104bfa <memcmp+0x2a>
80104be6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bed:	00 
80104bee:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104bf0:	83 c0 01             	add    $0x1,%eax
80104bf3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104bf6:	39 f0                	cmp    %esi,%eax
80104bf8:	74 16                	je     80104c10 <memcmp+0x40>
    if(*s1 != *s2)
80104bfa:	0f b6 08             	movzbl (%eax),%ecx
80104bfd:	0f b6 1a             	movzbl (%edx),%ebx
80104c00:	38 d9                	cmp    %bl,%cl
80104c02:	74 ec                	je     80104bf0 <memcmp+0x20>
      return *s1 - *s2;
80104c04:	0f b6 c1             	movzbl %cl,%eax
80104c07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c09:	5b                   	pop    %ebx
80104c0a:	5e                   	pop    %esi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	5b                   	pop    %ebx
  return 0;
80104c11:	31 c0                	xor    %eax,%eax
}
80104c13:	5e                   	pop    %esi
80104c14:	5d                   	pop    %ebp
80104c15:	c3                   	ret
80104c16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c1d:	00 
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	8b 55 08             	mov    0x8(%ebp),%edx
80104c27:	8b 45 10             	mov    0x10(%ebp),%eax
80104c2a:	56                   	push   %esi
80104c2b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c2e:	39 d6                	cmp    %edx,%esi
80104c30:	73 26                	jae    80104c58 <memmove+0x38>
80104c32:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c35:	39 ca                	cmp    %ecx,%edx
80104c37:	73 1f                	jae    80104c58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c39:	85 c0                	test   %eax,%eax
80104c3b:	74 0f                	je     80104c4c <memmove+0x2c>
80104c3d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104c40:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c44:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c47:	83 e8 01             	sub    $0x1,%eax
80104c4a:	73 f4                	jae    80104c40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c4c:	5e                   	pop    %esi
80104c4d:	89 d0                	mov    %edx,%eax
80104c4f:	5f                   	pop    %edi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c58:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c5b:	89 d7                	mov    %edx,%edi
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	74 eb                	je     80104c4c <memmove+0x2c>
80104c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c68:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c69:	39 ce                	cmp    %ecx,%esi
80104c6b:	75 fb                	jne    80104c68 <memmove+0x48>
}
80104c6d:	5e                   	pop    %esi
80104c6e:	89 d0                	mov    %edx,%eax
80104c70:	5f                   	pop    %edi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret
80104c73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c7a:	00 
80104c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104c80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c80:	eb 9e                	jmp    80104c20 <memmove>
80104c82:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c89:	00 
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	8b 55 10             	mov    0x10(%ebp),%edx
80104c97:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c9d:	85 d2                	test   %edx,%edx
80104c9f:	75 16                	jne    80104cb7 <strncmp+0x27>
80104ca1:	eb 2d                	jmp    80104cd0 <strncmp+0x40>
80104ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ca8:	3a 19                	cmp    (%ecx),%bl
80104caa:	75 12                	jne    80104cbe <strncmp+0x2e>
    n--, p++, q++;
80104cac:	83 c0 01             	add    $0x1,%eax
80104caf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cb2:	83 ea 01             	sub    $0x1,%edx
80104cb5:	74 19                	je     80104cd0 <strncmp+0x40>
80104cb7:	0f b6 18             	movzbl (%eax),%ebx
80104cba:	84 db                	test   %bl,%bl
80104cbc:	75 ea                	jne    80104ca8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104cbe:	0f b6 00             	movzbl (%eax),%eax
80104cc1:	0f b6 11             	movzbl (%ecx),%edx
}
80104cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104cc8:	29 d0                	sub    %edx,%eax
}
80104cca:	c3                   	ret
80104ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cd0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104cd3:	31 c0                	xor    %eax,%eax
}
80104cd5:	c9                   	leave
80104cd6:	c3                   	ret
80104cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cde:	00 
80104cdf:	90                   	nop

80104ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ce8:	53                   	push   %ebx
80104ce9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cec:	89 f0                	mov    %esi,%eax
80104cee:	eb 15                	jmp    80104d05 <strncpy+0x25>
80104cf0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104cf4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104cf7:	83 c0 01             	add    $0x1,%eax
80104cfa:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104cfe:	88 48 ff             	mov    %cl,-0x1(%eax)
80104d01:	84 c9                	test   %cl,%cl
80104d03:	74 13                	je     80104d18 <strncpy+0x38>
80104d05:	89 d3                	mov    %edx,%ebx
80104d07:	83 ea 01             	sub    $0x1,%edx
80104d0a:	85 db                	test   %ebx,%ebx
80104d0c:	7f e2                	jg     80104cf0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104d0e:	5b                   	pop    %ebx
80104d0f:	89 f0                	mov    %esi,%eax
80104d11:	5e                   	pop    %esi
80104d12:	5f                   	pop    %edi
80104d13:	5d                   	pop    %ebp
80104d14:	c3                   	ret
80104d15:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104d18:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104d1b:	83 e9 01             	sub    $0x1,%ecx
80104d1e:	85 d2                	test   %edx,%edx
80104d20:	74 ec                	je     80104d0e <strncpy+0x2e>
80104d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104d28:	83 c0 01             	add    $0x1,%eax
80104d2b:	89 ca                	mov    %ecx,%edx
80104d2d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104d31:	29 c2                	sub    %eax,%edx
80104d33:	85 d2                	test   %edx,%edx
80104d35:	7f f1                	jg     80104d28 <strncpy+0x48>
}
80104d37:	5b                   	pop    %ebx
80104d38:	89 f0                	mov    %esi,%eax
80104d3a:	5e                   	pop    %esi
80104d3b:	5f                   	pop    %edi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	8b 55 10             	mov    0x10(%ebp),%edx
80104d47:	8b 75 08             	mov    0x8(%ebp),%esi
80104d4a:	53                   	push   %ebx
80104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d4e:	85 d2                	test   %edx,%edx
80104d50:	7e 25                	jle    80104d77 <safestrcpy+0x37>
80104d52:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d56:	89 f2                	mov    %esi,%edx
80104d58:	eb 16                	jmp    80104d70 <safestrcpy+0x30>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d60:	0f b6 08             	movzbl (%eax),%ecx
80104d63:	83 c0 01             	add    $0x1,%eax
80104d66:	83 c2 01             	add    $0x1,%edx
80104d69:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d6c:	84 c9                	test   %cl,%cl
80104d6e:	74 04                	je     80104d74 <safestrcpy+0x34>
80104d70:	39 d8                	cmp    %ebx,%eax
80104d72:	75 ec                	jne    80104d60 <safestrcpy+0x20>
    ;
  *s = 0;
80104d74:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d77:	89 f0                	mov    %esi,%eax
80104d79:	5b                   	pop    %ebx
80104d7a:	5e                   	pop    %esi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi

80104d80 <strlen>:

int
strlen(const char *s)
{
80104d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d81:	31 c0                	xor    %eax,%eax
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d88:	80 3a 00             	cmpb   $0x0,(%edx)
80104d8b:	74 0c                	je     80104d99 <strlen+0x19>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d97:	75 f7                	jne    80104d90 <strlen+0x10>
    ;
  return n;
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret

80104d9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104da3:	55                   	push   %ebp
  pushl %ebx
80104da4:	53                   	push   %ebx
  pushl %esi
80104da5:	56                   	push   %esi
  pushl %edi
80104da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104da9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104dab:	5f                   	pop    %edi
  popl %esi
80104dac:	5e                   	pop    %esi
  popl %ebx
80104dad:	5b                   	pop    %ebx
  popl %ebp
80104dae:	5d                   	pop    %ebp
  ret
80104daf:	c3                   	ret

80104db0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dba:	e8 91 f0 ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbf:	8b 00                	mov    (%eax),%eax
80104dc1:	39 c3                	cmp    %eax,%ebx
80104dc3:	73 1b                	jae    80104de0 <fetchint+0x30>
80104dc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dc8:	39 d0                	cmp    %edx,%eax
80104dca:	72 14                	jb     80104de0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 13                	mov    (%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dd8:	c9                   	leave
80104dd9:	c3                   	ret
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <fetchint+0x25>
80104de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dee:	00 
80104def:	90                   	nop

80104df0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dfa:	e8 51 f0 ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz)
80104dff:	3b 18                	cmp    (%eax),%ebx
80104e01:	73 2d                	jae    80104e30 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104e03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e06:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e08:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e0a:	39 d3                	cmp    %edx,%ebx
80104e0c:	73 22                	jae    80104e30 <fetchstr+0x40>
80104e0e:	89 d8                	mov    %ebx,%eax
80104e10:	eb 0d                	jmp    80104e1f <fetchstr+0x2f>
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e18:	83 c0 01             	add    $0x1,%eax
80104e1b:	39 d0                	cmp    %edx,%eax
80104e1d:	73 11                	jae    80104e30 <fetchstr+0x40>
    if(*s == 0)
80104e1f:	80 38 00             	cmpb   $0x0,(%eax)
80104e22:	75 f4                	jne    80104e18 <fetchstr+0x28>
      return s - *pp;
80104e24:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e29:	c9                   	leave
80104e2a:	c3                   	ret
80104e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e38:	c9                   	leave
80104e39:	c3                   	ret
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e45:	e8 06 f0 ff ff       	call   80103e50 <myproc>
80104e4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e4d:	8b 40 18             	mov    0x18(%eax),%eax
80104e50:	8b 40 44             	mov    0x44(%eax),%eax
80104e53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e56:	e8 f5 ef ff ff       	call   80103e50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e5e:	8b 00                	mov    (%eax),%eax
80104e60:	39 c6                	cmp    %eax,%esi
80104e62:	73 1c                	jae    80104e80 <argint+0x40>
80104e64:	8d 53 08             	lea    0x8(%ebx),%edx
80104e67:	39 d0                	cmp    %edx,%eax
80104e69:	72 15                	jb     80104e80 <argint+0x40>
  *ip = *(int*)(addr);
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e71:	89 10                	mov    %edx,(%eax)
  return 0;
80104e73:	31 c0                	xor    %eax,%eax
}
80104e75:	5b                   	pop    %ebx
80104e76:	5e                   	pop    %esi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e85:	eb ee                	jmp    80104e75 <argint+0x35>
80104e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e8e:	00 
80104e8f:	90                   	nop

80104e90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	56                   	push   %esi
80104e95:	53                   	push   %ebx
80104e96:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e99:	e8 b2 ef ff ff       	call   80103e50 <myproc>
80104e9e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ea0:	e8 ab ef ff ff       	call   80103e50 <myproc>
80104ea5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea8:	8b 40 18             	mov    0x18(%eax),%eax
80104eab:	8b 40 44             	mov    0x44(%eax),%eax
80104eae:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eb1:	e8 9a ef ff ff       	call   80103e50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eb6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eb9:	8b 00                	mov    (%eax),%eax
80104ebb:	39 c7                	cmp    %eax,%edi
80104ebd:	73 31                	jae    80104ef0 <argptr+0x60>
80104ebf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ec2:	39 c8                	cmp    %ecx,%eax
80104ec4:	72 2a                	jb     80104ef0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ec6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ec9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ecc:	85 d2                	test   %edx,%edx
80104ece:	78 20                	js     80104ef0 <argptr+0x60>
80104ed0:	8b 16                	mov    (%esi),%edx
80104ed2:	39 d0                	cmp    %edx,%eax
80104ed4:	73 1a                	jae    80104ef0 <argptr+0x60>
80104ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ed9:	01 c3                	add    %eax,%ebx
80104edb:	39 da                	cmp    %ebx,%edx
80104edd:	72 11                	jb     80104ef0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104edf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ee2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee4:	31 c0                	xor    %eax,%eax
}
80104ee6:	83 c4 0c             	add    $0xc,%esp
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5f                   	pop    %edi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret
80104eee:	66 90                	xchg   %ax,%ax
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb ef                	jmp    80104ee6 <argptr+0x56>
80104ef7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104efe:	00 
80104eff:	90                   	nop

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f05:	e8 46 ef ff ff       	call   80103e50 <myproc>
80104f0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104f0d:	8b 40 18             	mov    0x18(%eax),%eax
80104f10:	8b 40 44             	mov    0x44(%eax),%eax
80104f13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f16:	e8 35 ef ff ff       	call   80103e50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f1e:	8b 00                	mov    (%eax),%eax
80104f20:	39 c6                	cmp    %eax,%esi
80104f22:	73 44                	jae    80104f68 <argstr+0x68>
80104f24:	8d 53 08             	lea    0x8(%ebx),%edx
80104f27:	39 d0                	cmp    %edx,%eax
80104f29:	72 3d                	jb     80104f68 <argstr+0x68>
  *ip = *(int*)(addr);
80104f2b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f2e:	e8 1d ef ff ff       	call   80103e50 <myproc>
  if(addr >= curproc->sz)
80104f33:	3b 18                	cmp    (%eax),%ebx
80104f35:	73 31                	jae    80104f68 <argstr+0x68>
  *pp = (char*)addr;
80104f37:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f3a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f3c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f3e:	39 d3                	cmp    %edx,%ebx
80104f40:	73 26                	jae    80104f68 <argstr+0x68>
80104f42:	89 d8                	mov    %ebx,%eax
80104f44:	eb 11                	jmp    80104f57 <argstr+0x57>
80104f46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f4d:	00 
80104f4e:	66 90                	xchg   %ax,%ax
80104f50:	83 c0 01             	add    $0x1,%eax
80104f53:	39 d0                	cmp    %edx,%eax
80104f55:	73 11                	jae    80104f68 <argstr+0x68>
    if(*s == 0)
80104f57:	80 38 00             	cmpb   $0x0,(%eax)
80104f5a:	75 f4                	jne    80104f50 <argstr+0x50>
      return s - *pp;
80104f5c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104f5e:	5b                   	pop    %ebx
80104f5f:	5e                   	pop    %esi
80104f60:	5d                   	pop    %ebp
80104f61:	c3                   	ret
80104f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f68:	5b                   	pop    %ebx
    return -1;
80104f69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f6e:	5e                   	pop    %esi
80104f6f:	5d                   	pop    %ebp
80104f70:	c3                   	ret
80104f71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f78:	00 
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f80 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	53                   	push   %ebx
80104f84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f87:	e8 c4 ee ff ff       	call   80103e50 <myproc>
80104f8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f8e:	8b 40 18             	mov    0x18(%eax),%eax
80104f91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f97:	83 fa 14             	cmp    $0x14,%edx
80104f9a:	77 24                	ja     80104fc0 <syscall+0x40>
80104f9c:	8b 14 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%edx
80104fa3:	85 d2                	test   %edx,%edx
80104fa5:	74 19                	je     80104fc0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104fa7:	ff d2                	call   *%edx
80104fa9:	89 c2                	mov    %eax,%edx
80104fab:	8b 43 18             	mov    0x18(%ebx),%eax
80104fae:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb4:	c9                   	leave
80104fb5:	c3                   	ret
80104fb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fbd:	00 
80104fbe:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104fc0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fc1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fc4:	50                   	push   %eax
80104fc5:	ff 73 10             	push   0x10(%ebx)
80104fc8:	68 d1 79 10 80       	push   $0x801079d1
80104fcd:	e8 8e b7 ff ff       	call   80100760 <cprintf>
    curproc->tf->eax = -1;
80104fd2:	8b 43 18             	mov    0x18(%ebx),%eax
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe2:	c9                   	leave
80104fe3:	c3                   	ret
80104fe4:	66 90                	xchg   %ax,%ax
80104fe6:	66 90                	xchg   %ax,%ax
80104fe8:	66 90                	xchg   %ax,%ax
80104fea:	66 90                	xchg   %ax,%ax
80104fec:	66 90                	xchg   %ax,%ax
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ff5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ff8:	53                   	push   %ebx
80104ff9:	83 ec 34             	sub    $0x34,%esp
80104ffc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105002:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105005:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105008:	57                   	push   %edi
80105009:	50                   	push   %eax
8010500a:	e8 81 d5 ff ff       	call   80102590 <nameiparent>
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	85 c0                	test   %eax,%eax
80105014:	74 5e                	je     80105074 <create+0x84>
    return 0;
  ilock(dp);
80105016:	83 ec 0c             	sub    $0xc,%esp
80105019:	89 c3                	mov    %eax,%ebx
8010501b:	50                   	push   %eax
8010501c:	e8 6f cc ff ff       	call   80101c90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105021:	83 c4 0c             	add    $0xc,%esp
80105024:	6a 00                	push   $0x0
80105026:	57                   	push   %edi
80105027:	53                   	push   %ebx
80105028:	e8 b3 d1 ff ff       	call   801021e0 <dirlookup>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	89 c6                	mov    %eax,%esi
80105032:	85 c0                	test   %eax,%eax
80105034:	74 4a                	je     80105080 <create+0x90>
    iunlockput(dp);
80105036:	83 ec 0c             	sub    $0xc,%esp
80105039:	53                   	push   %ebx
8010503a:	e8 e1 ce ff ff       	call   80101f20 <iunlockput>
    ilock(ip);
8010503f:	89 34 24             	mov    %esi,(%esp)
80105042:	e8 49 cc ff ff       	call   80101c90 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105047:	83 c4 10             	add    $0x10,%esp
8010504a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010504f:	75 17                	jne    80105068 <create+0x78>
80105051:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105056:	75 10                	jne    80105068 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010505b:	89 f0                	mov    %esi,%eax
8010505d:	5b                   	pop    %ebx
8010505e:	5e                   	pop    %esi
8010505f:	5f                   	pop    %edi
80105060:	5d                   	pop    %ebp
80105061:	c3                   	ret
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105068:	83 ec 0c             	sub    $0xc,%esp
8010506b:	56                   	push   %esi
8010506c:	e8 af ce ff ff       	call   80101f20 <iunlockput>
    return 0;
80105071:	83 c4 10             	add    $0x10,%esp
}
80105074:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105077:	31 f6                	xor    %esi,%esi
}
80105079:	5b                   	pop    %ebx
8010507a:	89 f0                	mov    %esi,%eax
8010507c:	5e                   	pop    %esi
8010507d:	5f                   	pop    %edi
8010507e:	5d                   	pop    %ebp
8010507f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105080:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105084:	83 ec 08             	sub    $0x8,%esp
80105087:	50                   	push   %eax
80105088:	ff 33                	push   (%ebx)
8010508a:	e8 91 ca ff ff       	call   80101b20 <ialloc>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	89 c6                	mov    %eax,%esi
80105094:	85 c0                	test   %eax,%eax
80105096:	0f 84 bc 00 00 00    	je     80105158 <create+0x168>
  ilock(ip);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	50                   	push   %eax
801050a0:	e8 eb cb ff ff       	call   80101c90 <ilock>
  ip->major = major;
801050a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801050a9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801050ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801050b1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801050b5:	b8 01 00 00 00       	mov    $0x1,%eax
801050ba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801050be:	89 34 24             	mov    %esi,(%esp)
801050c1:	e8 1a cb ff ff       	call   80101be0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050c6:	83 c4 10             	add    $0x10,%esp
801050c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050ce:	74 30                	je     80105100 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801050d0:	83 ec 04             	sub    $0x4,%esp
801050d3:	ff 76 04             	push   0x4(%esi)
801050d6:	57                   	push   %edi
801050d7:	53                   	push   %ebx
801050d8:	e8 d3 d3 ff ff       	call   801024b0 <dirlink>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 67                	js     8010514b <create+0x15b>
  iunlockput(dp);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	53                   	push   %ebx
801050e8:	e8 33 ce ff ff       	call   80101f20 <iunlockput>
  return ip;
801050ed:	83 c4 10             	add    $0x10,%esp
}
801050f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f3:	89 f0                	mov    %esi,%eax
801050f5:	5b                   	pop    %ebx
801050f6:	5e                   	pop    %esi
801050f7:	5f                   	pop    %edi
801050f8:	5d                   	pop    %ebp
801050f9:	c3                   	ret
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105100:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105103:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105108:	53                   	push   %ebx
80105109:	e8 d2 ca ff ff       	call   80101be0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010510e:	83 c4 0c             	add    $0xc,%esp
80105111:	ff 76 04             	push   0x4(%esi)
80105114:	68 09 7a 10 80       	push   $0x80107a09
80105119:	56                   	push   %esi
8010511a:	e8 91 d3 ff ff       	call   801024b0 <dirlink>
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	85 c0                	test   %eax,%eax
80105124:	78 18                	js     8010513e <create+0x14e>
80105126:	83 ec 04             	sub    $0x4,%esp
80105129:	ff 73 04             	push   0x4(%ebx)
8010512c:	68 08 7a 10 80       	push   $0x80107a08
80105131:	56                   	push   %esi
80105132:	e8 79 d3 ff ff       	call   801024b0 <dirlink>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	85 c0                	test   %eax,%eax
8010513c:	79 92                	jns    801050d0 <create+0xe0>
      panic("create dots");
8010513e:	83 ec 0c             	sub    $0xc,%esp
80105141:	68 fc 79 10 80       	push   $0x801079fc
80105146:	e8 25 b2 ff ff       	call   80100370 <panic>
    panic("create: dirlink");
8010514b:	83 ec 0c             	sub    $0xc,%esp
8010514e:	68 0b 7a 10 80       	push   $0x80107a0b
80105153:	e8 18 b2 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	68 ed 79 10 80       	push   $0x801079ed
80105160:	e8 0b b2 ff ff       	call   80100370 <panic>
80105165:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010516c:	00 
8010516d:	8d 76 00             	lea    0x0(%esi),%esi

80105170 <sys_dup>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105175:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105178:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010517b:	50                   	push   %eax
8010517c:	6a 00                	push   $0x0
8010517e:	e8 bd fc ff ff       	call   80104e40 <argint>
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 36                	js     801051c0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010518a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010518e:	77 30                	ja     801051c0 <sys_dup+0x50>
80105190:	e8 bb ec ff ff       	call   80103e50 <myproc>
80105195:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105198:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010519c:	85 f6                	test   %esi,%esi
8010519e:	74 20                	je     801051c0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801051a0:	e8 ab ec ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051a5:	31 db                	xor    %ebx,%ebx
801051a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051ae:	00 
801051af:	90                   	nop
    if(curproc->ofile[fd] == 0){
801051b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051b4:	85 d2                	test   %edx,%edx
801051b6:	74 18                	je     801051d0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801051b8:	83 c3 01             	add    $0x1,%ebx
801051bb:	83 fb 10             	cmp    $0x10,%ebx
801051be:	75 f0                	jne    801051b0 <sys_dup+0x40>
}
801051c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051c8:	89 d8                	mov    %ebx,%eax
801051ca:	5b                   	pop    %ebx
801051cb:	5e                   	pop    %esi
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret
801051ce:	66 90                	xchg   %ax,%ax
  filedup(f);
801051d0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051d3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051d7:	56                   	push   %esi
801051d8:	e8 d3 c1 ff ff       	call   801013b0 <filedup>
  return fd;
801051dd:	83 c4 10             	add    $0x10,%esp
}
801051e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051e3:	89 d8                	mov    %ebx,%eax
801051e5:	5b                   	pop    %ebx
801051e6:	5e                   	pop    %esi
801051e7:	5d                   	pop    %ebp
801051e8:	c3                   	ret
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_read>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051fb:	53                   	push   %ebx
801051fc:	6a 00                	push   $0x0
801051fe:	e8 3d fc ff ff       	call   80104e40 <argint>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	78 5e                	js     80105268 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010520a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010520e:	77 58                	ja     80105268 <sys_read+0x78>
80105210:	e8 3b ec ff ff       	call   80103e50 <myproc>
80105215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105218:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010521c:	85 f6                	test   %esi,%esi
8010521e:	74 48                	je     80105268 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105220:	83 ec 08             	sub    $0x8,%esp
80105223:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105226:	50                   	push   %eax
80105227:	6a 02                	push   $0x2
80105229:	e8 12 fc ff ff       	call   80104e40 <argint>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	85 c0                	test   %eax,%eax
80105233:	78 33                	js     80105268 <sys_read+0x78>
80105235:	83 ec 04             	sub    $0x4,%esp
80105238:	ff 75 f0             	push   -0x10(%ebp)
8010523b:	53                   	push   %ebx
8010523c:	6a 01                	push   $0x1
8010523e:	e8 4d fc ff ff       	call   80104e90 <argptr>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	78 1e                	js     80105268 <sys_read+0x78>
  return fileread(f, p, n);
8010524a:	83 ec 04             	sub    $0x4,%esp
8010524d:	ff 75 f0             	push   -0x10(%ebp)
80105250:	ff 75 f4             	push   -0xc(%ebp)
80105253:	56                   	push   %esi
80105254:	e8 d7 c2 ff ff       	call   80101530 <fileread>
80105259:	83 c4 10             	add    $0x10,%esp
}
8010525c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010525f:	5b                   	pop    %ebx
80105260:	5e                   	pop    %esi
80105261:	5d                   	pop    %ebp
80105262:	c3                   	ret
80105263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526d:	eb ed                	jmp    8010525c <sys_read+0x6c>
8010526f:	90                   	nop

80105270 <sys_write>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105275:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105278:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010527b:	53                   	push   %ebx
8010527c:	6a 00                	push   $0x0
8010527e:	e8 bd fb ff ff       	call   80104e40 <argint>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 5e                	js     801052e8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010528a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010528e:	77 58                	ja     801052e8 <sys_write+0x78>
80105290:	e8 bb eb ff ff       	call   80103e50 <myproc>
80105295:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105298:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010529c:	85 f6                	test   %esi,%esi
8010529e:	74 48                	je     801052e8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052a0:	83 ec 08             	sub    $0x8,%esp
801052a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a6:	50                   	push   %eax
801052a7:	6a 02                	push   $0x2
801052a9:	e8 92 fb ff ff       	call   80104e40 <argint>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	85 c0                	test   %eax,%eax
801052b3:	78 33                	js     801052e8 <sys_write+0x78>
801052b5:	83 ec 04             	sub    $0x4,%esp
801052b8:	ff 75 f0             	push   -0x10(%ebp)
801052bb:	53                   	push   %ebx
801052bc:	6a 01                	push   $0x1
801052be:	e8 cd fb ff ff       	call   80104e90 <argptr>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	78 1e                	js     801052e8 <sys_write+0x78>
  return filewrite(f, p, n);
801052ca:	83 ec 04             	sub    $0x4,%esp
801052cd:	ff 75 f0             	push   -0x10(%ebp)
801052d0:	ff 75 f4             	push   -0xc(%ebp)
801052d3:	56                   	push   %esi
801052d4:	e8 e7 c2 ff ff       	call   801015c0 <filewrite>
801052d9:	83 c4 10             	add    $0x10,%esp
}
801052dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052df:	5b                   	pop    %ebx
801052e0:	5e                   	pop    %esi
801052e1:	5d                   	pop    %ebp
801052e2:	c3                   	ret
801052e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801052e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ed:	eb ed                	jmp    801052dc <sys_write+0x6c>
801052ef:	90                   	nop

801052f0 <sys_close>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801052f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052fb:	50                   	push   %eax
801052fc:	6a 00                	push   $0x0
801052fe:	e8 3d fb ff ff       	call   80104e40 <argint>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	78 3e                	js     80105348 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010530a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010530e:	77 38                	ja     80105348 <sys_close+0x58>
80105310:	e8 3b eb ff ff       	call   80103e50 <myproc>
80105315:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105318:	8d 5a 08             	lea    0x8(%edx),%ebx
8010531b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010531f:	85 f6                	test   %esi,%esi
80105321:	74 25                	je     80105348 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105323:	e8 28 eb ff ff       	call   80103e50 <myproc>
  fileclose(f);
80105328:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010532b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105332:	00 
  fileclose(f);
80105333:	56                   	push   %esi
80105334:	e8 c7 c0 ff ff       	call   80101400 <fileclose>
  return 0;
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	31 c0                	xor    %eax,%eax
}
8010533e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105341:	5b                   	pop    %ebx
80105342:	5e                   	pop    %esi
80105343:	5d                   	pop    %ebp
80105344:	c3                   	ret
80105345:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534d:	eb ef                	jmp    8010533e <sys_close+0x4e>
8010534f:	90                   	nop

80105350 <sys_fstat>:
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105355:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105358:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010535b:	53                   	push   %ebx
8010535c:	6a 00                	push   $0x0
8010535e:	e8 dd fa ff ff       	call   80104e40 <argint>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	78 46                	js     801053b0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010536a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010536e:	77 40                	ja     801053b0 <sys_fstat+0x60>
80105370:	e8 db ea ff ff       	call   80103e50 <myproc>
80105375:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105378:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010537c:	85 f6                	test   %esi,%esi
8010537e:	74 30                	je     801053b0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105380:	83 ec 04             	sub    $0x4,%esp
80105383:	6a 14                	push   $0x14
80105385:	53                   	push   %ebx
80105386:	6a 01                	push   $0x1
80105388:	e8 03 fb ff ff       	call   80104e90 <argptr>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	78 1c                	js     801053b0 <sys_fstat+0x60>
  return filestat(f, st);
80105394:	83 ec 08             	sub    $0x8,%esp
80105397:	ff 75 f4             	push   -0xc(%ebp)
8010539a:	56                   	push   %esi
8010539b:	e8 40 c1 ff ff       	call   801014e0 <filestat>
801053a0:	83 c4 10             	add    $0x10,%esp
}
801053a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053a6:	5b                   	pop    %ebx
801053a7:	5e                   	pop    %esi
801053a8:	5d                   	pop    %ebp
801053a9:	c3                   	ret
801053aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b5:	eb ec                	jmp    801053a3 <sys_fstat+0x53>
801053b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053be:	00 
801053bf:	90                   	nop

801053c0 <sys_link>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801053c8:	53                   	push   %ebx
801053c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 2c fb ff ff       	call   80104f00 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 fb 00 00 00    	js     801054da <sys_link+0x11a>
801053df:	83 ec 08             	sub    $0x8,%esp
801053e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053e5:	50                   	push   %eax
801053e6:	6a 01                	push   $0x1
801053e8:	e8 13 fb ff ff       	call   80104f00 <argstr>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	0f 88 e2 00 00 00    	js     801054da <sys_link+0x11a>
  begin_op();
801053f8:	e8 33 de ff ff       	call   80103230 <begin_op>
  if((ip = namei(old)) == 0){
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	ff 75 d4             	push   -0x2c(%ebp)
80105403:	e8 68 d1 ff ff       	call   80102570 <namei>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	89 c3                	mov    %eax,%ebx
8010540d:	85 c0                	test   %eax,%eax
8010540f:	0f 84 df 00 00 00    	je     801054f4 <sys_link+0x134>
  ilock(ip);
80105415:	83 ec 0c             	sub    $0xc,%esp
80105418:	50                   	push   %eax
80105419:	e8 72 c8 ff ff       	call   80101c90 <ilock>
  if(ip->type == T_DIR){
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105426:	0f 84 b5 00 00 00    	je     801054e1 <sys_link+0x121>
  iupdate(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010542f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105434:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105437:	53                   	push   %ebx
80105438:	e8 a3 c7 ff ff       	call   80101be0 <iupdate>
  iunlock(ip);
8010543d:	89 1c 24             	mov    %ebx,(%esp)
80105440:	e8 2b c9 ff ff       	call   80101d70 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105445:	58                   	pop    %eax
80105446:	5a                   	pop    %edx
80105447:	57                   	push   %edi
80105448:	ff 75 d0             	push   -0x30(%ebp)
8010544b:	e8 40 d1 ff ff       	call   80102590 <nameiparent>
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	89 c6                	mov    %eax,%esi
80105455:	85 c0                	test   %eax,%eax
80105457:	74 5b                	je     801054b4 <sys_link+0xf4>
  ilock(dp);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 2e c8 ff ff       	call   80101c90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105462:	8b 03                	mov    (%ebx),%eax
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	39 06                	cmp    %eax,(%esi)
80105469:	75 3d                	jne    801054a8 <sys_link+0xe8>
8010546b:	83 ec 04             	sub    $0x4,%esp
8010546e:	ff 73 04             	push   0x4(%ebx)
80105471:	57                   	push   %edi
80105472:	56                   	push   %esi
80105473:	e8 38 d0 ff ff       	call   801024b0 <dirlink>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	78 29                	js     801054a8 <sys_link+0xe8>
  iunlockput(dp);
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	56                   	push   %esi
80105483:	e8 98 ca ff ff       	call   80101f20 <iunlockput>
  iput(ip);
80105488:	89 1c 24             	mov    %ebx,(%esp)
8010548b:	e8 30 c9 ff ff       	call   80101dc0 <iput>
  end_op();
80105490:	e8 0b de ff ff       	call   801032a0 <end_op>
  return 0;
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	31 c0                	xor    %eax,%eax
}
8010549a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010549d:	5b                   	pop    %ebx
8010549e:	5e                   	pop    %esi
8010549f:	5f                   	pop    %edi
801054a0:	5d                   	pop    %ebp
801054a1:	c3                   	ret
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	56                   	push   %esi
801054ac:	e8 6f ca ff ff       	call   80101f20 <iunlockput>
    goto bad;
801054b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801054b4:	83 ec 0c             	sub    $0xc,%esp
801054b7:	53                   	push   %ebx
801054b8:	e8 d3 c7 ff ff       	call   80101c90 <ilock>
  ip->nlink--;
801054bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054c2:	89 1c 24             	mov    %ebx,(%esp)
801054c5:	e8 16 c7 ff ff       	call   80101be0 <iupdate>
  iunlockput(ip);
801054ca:	89 1c 24             	mov    %ebx,(%esp)
801054cd:	e8 4e ca ff ff       	call   80101f20 <iunlockput>
  end_op();
801054d2:	e8 c9 dd ff ff       	call   801032a0 <end_op>
  return -1;
801054d7:	83 c4 10             	add    $0x10,%esp
    return -1;
801054da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054df:	eb b9                	jmp    8010549a <sys_link+0xda>
    iunlockput(ip);
801054e1:	83 ec 0c             	sub    $0xc,%esp
801054e4:	53                   	push   %ebx
801054e5:	e8 36 ca ff ff       	call   80101f20 <iunlockput>
    end_op();
801054ea:	e8 b1 dd ff ff       	call   801032a0 <end_op>
    return -1;
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	eb e6                	jmp    801054da <sys_link+0x11a>
    end_op();
801054f4:	e8 a7 dd ff ff       	call   801032a0 <end_op>
    return -1;
801054f9:	eb df                	jmp    801054da <sys_link+0x11a>
801054fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105500 <sys_unlink>:
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105505:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105508:	53                   	push   %ebx
80105509:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 ec f9 ff ff       	call   80104f00 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 54 01 00 00    	js     80105673 <sys_unlink+0x173>
  begin_op();
8010551f:	e8 0c dd ff ff       	call   80103230 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105524:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105527:	83 ec 08             	sub    $0x8,%esp
8010552a:	53                   	push   %ebx
8010552b:	ff 75 c0             	push   -0x40(%ebp)
8010552e:	e8 5d d0 ff ff       	call   80102590 <nameiparent>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105539:	85 c0                	test   %eax,%eax
8010553b:	0f 84 58 01 00 00    	je     80105699 <sys_unlink+0x199>
  ilock(dp);
80105541:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	57                   	push   %edi
80105548:	e8 43 c7 ff ff       	call   80101c90 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010554d:	58                   	pop    %eax
8010554e:	5a                   	pop    %edx
8010554f:	68 09 7a 10 80       	push   $0x80107a09
80105554:	53                   	push   %ebx
80105555:	e8 66 cc ff ff       	call   801021c0 <namecmp>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	0f 84 fb 00 00 00    	je     80105660 <sys_unlink+0x160>
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	68 08 7a 10 80       	push   $0x80107a08
8010556d:	53                   	push   %ebx
8010556e:	e8 4d cc ff ff       	call   801021c0 <namecmp>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	0f 84 e2 00 00 00    	je     80105660 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010557e:	83 ec 04             	sub    $0x4,%esp
80105581:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105584:	50                   	push   %eax
80105585:	53                   	push   %ebx
80105586:	57                   	push   %edi
80105587:	e8 54 cc ff ff       	call   801021e0 <dirlookup>
8010558c:	83 c4 10             	add    $0x10,%esp
8010558f:	89 c3                	mov    %eax,%ebx
80105591:	85 c0                	test   %eax,%eax
80105593:	0f 84 c7 00 00 00    	je     80105660 <sys_unlink+0x160>
  ilock(ip);
80105599:	83 ec 0c             	sub    $0xc,%esp
8010559c:	50                   	push   %eax
8010559d:	e8 ee c6 ff ff       	call   80101c90 <ilock>
  if(ip->nlink < 1)
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055aa:	0f 8e 0a 01 00 00    	jle    801056ba <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055b8:	74 66                	je     80105620 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801055ba:	83 ec 04             	sub    $0x4,%esp
801055bd:	6a 10                	push   $0x10
801055bf:	6a 00                	push   $0x0
801055c1:	57                   	push   %edi
801055c2:	e8 c9 f5 ff ff       	call   80104b90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c7:	6a 10                	push   $0x10
801055c9:	ff 75 c4             	push   -0x3c(%ebp)
801055cc:	57                   	push   %edi
801055cd:	ff 75 b4             	push   -0x4c(%ebp)
801055d0:	e8 cb ca ff ff       	call   801020a0 <writei>
801055d5:	83 c4 20             	add    $0x20,%esp
801055d8:	83 f8 10             	cmp    $0x10,%eax
801055db:	0f 85 cc 00 00 00    	jne    801056ad <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801055e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055e6:	0f 84 94 00 00 00    	je     80105680 <sys_unlink+0x180>
  iunlockput(dp);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	ff 75 b4             	push   -0x4c(%ebp)
801055f2:	e8 29 c9 ff ff       	call   80101f20 <iunlockput>
  ip->nlink--;
801055f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055fc:	89 1c 24             	mov    %ebx,(%esp)
801055ff:	e8 dc c5 ff ff       	call   80101be0 <iupdate>
  iunlockput(ip);
80105604:	89 1c 24             	mov    %ebx,(%esp)
80105607:	e8 14 c9 ff ff       	call   80101f20 <iunlockput>
  end_op();
8010560c:	e8 8f dc ff ff       	call   801032a0 <end_op>
  return 0;
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	31 c0                	xor    %eax,%eax
}
80105616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105619:	5b                   	pop    %ebx
8010561a:	5e                   	pop    %esi
8010561b:	5f                   	pop    %edi
8010561c:	5d                   	pop    %ebp
8010561d:	c3                   	ret
8010561e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105620:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105624:	76 94                	jbe    801055ba <sys_unlink+0xba>
80105626:	be 20 00 00 00       	mov    $0x20,%esi
8010562b:	eb 0b                	jmp    80105638 <sys_unlink+0x138>
8010562d:	8d 76 00             	lea    0x0(%esi),%esi
80105630:	83 c6 10             	add    $0x10,%esi
80105633:	3b 73 58             	cmp    0x58(%ebx),%esi
80105636:	73 82                	jae    801055ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105638:	6a 10                	push   $0x10
8010563a:	56                   	push   %esi
8010563b:	57                   	push   %edi
8010563c:	53                   	push   %ebx
8010563d:	e8 5e c9 ff ff       	call   80101fa0 <readi>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	83 f8 10             	cmp    $0x10,%eax
80105648:	75 56                	jne    801056a0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010564a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010564f:	74 df                	je     80105630 <sys_unlink+0x130>
    iunlockput(ip);
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	53                   	push   %ebx
80105655:	e8 c6 c8 ff ff       	call   80101f20 <iunlockput>
    goto bad;
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	ff 75 b4             	push   -0x4c(%ebp)
80105666:	e8 b5 c8 ff ff       	call   80101f20 <iunlockput>
  end_op();
8010566b:	e8 30 dc ff ff       	call   801032a0 <end_op>
  return -1;
80105670:	83 c4 10             	add    $0x10,%esp
    return -1;
80105673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105678:	eb 9c                	jmp    80105616 <sys_unlink+0x116>
8010567a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105680:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105683:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105686:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010568b:	50                   	push   %eax
8010568c:	e8 4f c5 ff ff       	call   80101be0 <iupdate>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	e9 53 ff ff ff       	jmp    801055ec <sys_unlink+0xec>
    end_op();
80105699:	e8 02 dc ff ff       	call   801032a0 <end_op>
    return -1;
8010569e:	eb d3                	jmp    80105673 <sys_unlink+0x173>
      panic("isdirempty: readi");
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	68 2d 7a 10 80       	push   $0x80107a2d
801056a8:	e8 c3 ac ff ff       	call   80100370 <panic>
    panic("unlink: writei");
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	68 3f 7a 10 80       	push   $0x80107a3f
801056b5:	e8 b6 ac ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	68 1b 7a 10 80       	push   $0x80107a1b
801056c2:	e8 a9 ac ff ff       	call   80100370 <panic>
801056c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ce:	00 
801056cf:	90                   	nop

801056d0 <sys_open>:

int
sys_open(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056d8:	53                   	push   %ebx
801056d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056dc:	50                   	push   %eax
801056dd:	6a 00                	push   $0x0
801056df:	e8 1c f8 ff ff       	call   80104f00 <argstr>
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	85 c0                	test   %eax,%eax
801056e9:	0f 88 8e 00 00 00    	js     8010577d <sys_open+0xad>
801056ef:	83 ec 08             	sub    $0x8,%esp
801056f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056f5:	50                   	push   %eax
801056f6:	6a 01                	push   $0x1
801056f8:	e8 43 f7 ff ff       	call   80104e40 <argint>
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	85 c0                	test   %eax,%eax
80105702:	78 79                	js     8010577d <sys_open+0xad>
    return -1;

  begin_op();
80105704:	e8 27 db ff ff       	call   80103230 <begin_op>

  if(omode & O_CREATE){
80105709:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010570d:	75 79                	jne    80105788 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	ff 75 e0             	push   -0x20(%ebp)
80105715:	e8 56 ce ff ff       	call   80102570 <namei>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	89 c6                	mov    %eax,%esi
8010571f:	85 c0                	test   %eax,%eax
80105721:	0f 84 7e 00 00 00    	je     801057a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105727:	83 ec 0c             	sub    $0xc,%esp
8010572a:	50                   	push   %eax
8010572b:	e8 60 c5 ff ff       	call   80101c90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105730:	83 c4 10             	add    $0x10,%esp
80105733:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105738:	0f 84 ba 00 00 00    	je     801057f8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010573e:	e8 fd bb ff ff       	call   80101340 <filealloc>
80105743:	89 c7                	mov    %eax,%edi
80105745:	85 c0                	test   %eax,%eax
80105747:	74 23                	je     8010576c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105749:	e8 02 e7 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010574e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105750:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105754:	85 d2                	test   %edx,%edx
80105756:	74 58                	je     801057b0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105758:	83 c3 01             	add    $0x1,%ebx
8010575b:	83 fb 10             	cmp    $0x10,%ebx
8010575e:	75 f0                	jne    80105750 <sys_open+0x80>
    if(f)
      fileclose(f);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	57                   	push   %edi
80105764:	e8 97 bc ff ff       	call   80101400 <fileclose>
80105769:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010576c:	83 ec 0c             	sub    $0xc,%esp
8010576f:	56                   	push   %esi
80105770:	e8 ab c7 ff ff       	call   80101f20 <iunlockput>
    end_op();
80105775:	e8 26 db ff ff       	call   801032a0 <end_op>
    return -1;
8010577a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010577d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105782:	eb 65                	jmp    801057e9 <sys_open+0x119>
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	31 c9                	xor    %ecx,%ecx
8010578d:	ba 02 00 00 00       	mov    $0x2,%edx
80105792:	6a 00                	push   $0x0
80105794:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105797:	e8 54 f8 ff ff       	call   80104ff0 <create>
    if(ip == 0){
8010579c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010579f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057a1:	85 c0                	test   %eax,%eax
801057a3:	75 99                	jne    8010573e <sys_open+0x6e>
      end_op();
801057a5:	e8 f6 da ff ff       	call   801032a0 <end_op>
      return -1;
801057aa:	eb d1                	jmp    8010577d <sys_open+0xad>
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057b3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801057b7:	56                   	push   %esi
801057b8:	e8 b3 c5 ff ff       	call   80101d70 <iunlock>
  end_op();
801057bd:	e8 de da ff ff       	call   801032a0 <end_op>

  f->type = FD_INODE;
801057c2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057cb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057ce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801057d1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801057d3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057da:	f7 d0                	not    %eax
801057dc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057df:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057e2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057e5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ec:	89 d8                	mov    %ebx,%eax
801057ee:	5b                   	pop    %ebx
801057ef:	5e                   	pop    %esi
801057f0:	5f                   	pop    %edi
801057f1:	5d                   	pop    %ebp
801057f2:	c3                   	ret
801057f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801057f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057fb:	85 c9                	test   %ecx,%ecx
801057fd:	0f 84 3b ff ff ff    	je     8010573e <sys_open+0x6e>
80105803:	e9 64 ff ff ff       	jmp    8010576c <sys_open+0x9c>
80105808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010580f:	00 

80105810 <sys_mkdir>:

int
sys_mkdir(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105816:	e8 15 da ff ff       	call   80103230 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105821:	50                   	push   %eax
80105822:	6a 00                	push   $0x0
80105824:	e8 d7 f6 ff ff       	call   80104f00 <argstr>
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	85 c0                	test   %eax,%eax
8010582e:	78 30                	js     80105860 <sys_mkdir+0x50>
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105836:	31 c9                	xor    %ecx,%ecx
80105838:	ba 01 00 00 00       	mov    $0x1,%edx
8010583d:	6a 00                	push   $0x0
8010583f:	e8 ac f7 ff ff       	call   80104ff0 <create>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	74 15                	je     80105860 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010584b:	83 ec 0c             	sub    $0xc,%esp
8010584e:	50                   	push   %eax
8010584f:	e8 cc c6 ff ff       	call   80101f20 <iunlockput>
  end_op();
80105854:	e8 47 da ff ff       	call   801032a0 <end_op>
  return 0;
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	31 c0                	xor    %eax,%eax
}
8010585e:	c9                   	leave
8010585f:	c3                   	ret
    end_op();
80105860:	e8 3b da ff ff       	call   801032a0 <end_op>
    return -1;
80105865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010586a:	c9                   	leave
8010586b:	c3                   	ret
8010586c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105870 <sys_mknod>:

int
sys_mknod(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105876:	e8 b5 d9 ff ff       	call   80103230 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010587b:	83 ec 08             	sub    $0x8,%esp
8010587e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105881:	50                   	push   %eax
80105882:	6a 00                	push   $0x0
80105884:	e8 77 f6 ff ff       	call   80104f00 <argstr>
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	85 c0                	test   %eax,%eax
8010588e:	78 60                	js     801058f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105890:	83 ec 08             	sub    $0x8,%esp
80105893:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105896:	50                   	push   %eax
80105897:	6a 01                	push   $0x1
80105899:	e8 a2 f5 ff ff       	call   80104e40 <argint>
  if((argstr(0, &path)) < 0 ||
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	85 c0                	test   %eax,%eax
801058a3:	78 4b                	js     801058f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058a5:	83 ec 08             	sub    $0x8,%esp
801058a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ab:	50                   	push   %eax
801058ac:	6a 02                	push   $0x2
801058ae:	e8 8d f5 ff ff       	call   80104e40 <argint>
     argint(1, &major) < 0 ||
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	78 36                	js     801058f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058be:	83 ec 0c             	sub    $0xc,%esp
801058c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058c5:	ba 03 00 00 00       	mov    $0x3,%edx
801058ca:	50                   	push   %eax
801058cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058ce:	e8 1d f7 ff ff       	call   80104ff0 <create>
     argint(2, &minor) < 0 ||
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 c0                	test   %eax,%eax
801058d8:	74 16                	je     801058f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	50                   	push   %eax
801058de:	e8 3d c6 ff ff       	call   80101f20 <iunlockput>
  end_op();
801058e3:	e8 b8 d9 ff ff       	call   801032a0 <end_op>
  return 0;
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	31 c0                	xor    %eax,%eax
}
801058ed:	c9                   	leave
801058ee:	c3                   	ret
801058ef:	90                   	nop
    end_op();
801058f0:	e8 ab d9 ff ff       	call   801032a0 <end_op>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave
801058fb:	c3                   	ret
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_chdir>:

int
sys_chdir(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	56                   	push   %esi
80105904:	53                   	push   %ebx
80105905:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105908:	e8 43 e5 ff ff       	call   80103e50 <myproc>
8010590d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010590f:	e8 1c d9 ff ff       	call   80103230 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105914:	83 ec 08             	sub    $0x8,%esp
80105917:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 de f5 ff ff       	call   80104f00 <argstr>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 77                	js     801059a0 <sys_chdir+0xa0>
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	ff 75 f4             	push   -0xc(%ebp)
8010592f:	e8 3c cc ff ff       	call   80102570 <namei>
80105934:	83 c4 10             	add    $0x10,%esp
80105937:	89 c3                	mov    %eax,%ebx
80105939:	85 c0                	test   %eax,%eax
8010593b:	74 63                	je     801059a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	50                   	push   %eax
80105941:	e8 4a c3 ff ff       	call   80101c90 <ilock>
  if(ip->type != T_DIR){
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010594e:	75 30                	jne    80105980 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	53                   	push   %ebx
80105954:	e8 17 c4 ff ff       	call   80101d70 <iunlock>
  iput(curproc->cwd);
80105959:	58                   	pop    %eax
8010595a:	ff 76 68             	push   0x68(%esi)
8010595d:	e8 5e c4 ff ff       	call   80101dc0 <iput>
  end_op();
80105962:	e8 39 d9 ff ff       	call   801032a0 <end_op>
  curproc->cwd = ip;
80105967:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	31 c0                	xor    %eax,%eax
}
8010596f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5d                   	pop    %ebp
80105975:	c3                   	ret
80105976:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010597d:	00 
8010597e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	53                   	push   %ebx
80105984:	e8 97 c5 ff ff       	call   80101f20 <iunlockput>
    end_op();
80105989:	e8 12 d9 ff ff       	call   801032a0 <end_op>
    return -1;
8010598e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105996:	eb d7                	jmp    8010596f <sys_chdir+0x6f>
80105998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599f:	00 
    end_op();
801059a0:	e8 fb d8 ff ff       	call   801032a0 <end_op>
    return -1;
801059a5:	eb ea                	jmp    80105991 <sys_chdir+0x91>
801059a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ae:	00 
801059af:	90                   	nop

801059b0 <sys_exec>:

int
sys_exec(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059bb:	53                   	push   %ebx
801059bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059c2:	50                   	push   %eax
801059c3:	6a 00                	push   $0x0
801059c5:	e8 36 f5 ff ff       	call   80104f00 <argstr>
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	85 c0                	test   %eax,%eax
801059cf:	0f 88 87 00 00 00    	js     80105a5c <sys_exec+0xac>
801059d5:	83 ec 08             	sub    $0x8,%esp
801059d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059de:	50                   	push   %eax
801059df:	6a 01                	push   $0x1
801059e1:	e8 5a f4 ff ff       	call   80104e40 <argint>
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	85 c0                	test   %eax,%eax
801059eb:	78 6f                	js     80105a5c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059ed:	83 ec 04             	sub    $0x4,%esp
801059f0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801059f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059f8:	68 80 00 00 00       	push   $0x80
801059fd:	6a 00                	push   $0x0
801059ff:	56                   	push   %esi
80105a00:	e8 8b f1 ff ff       	call   80104b90 <memset>
80105a05:	83 c4 10             	add    $0x10,%esp
80105a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a0f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a10:	83 ec 08             	sub    $0x8,%esp
80105a13:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105a19:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105a20:	50                   	push   %eax
80105a21:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a27:	01 f8                	add    %edi,%eax
80105a29:	50                   	push   %eax
80105a2a:	e8 81 f3 ff ff       	call   80104db0 <fetchint>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 c0                	test   %eax,%eax
80105a34:	78 26                	js     80105a5c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105a36:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	74 30                	je     80105a70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a40:	83 ec 08             	sub    $0x8,%esp
80105a43:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105a46:	52                   	push   %edx
80105a47:	50                   	push   %eax
80105a48:	e8 a3 f3 ff ff       	call   80104df0 <fetchstr>
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	85 c0                	test   %eax,%eax
80105a52:	78 08                	js     80105a5c <sys_exec+0xac>
  for(i=0;; i++){
80105a54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a57:	83 fb 20             	cmp    $0x20,%ebx
80105a5a:	75 b4                	jne    80105a10 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105a70:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a77:	00 00 00 00 
  return exec(path, argv);
80105a7b:	83 ec 08             	sub    $0x8,%esp
80105a7e:	56                   	push   %esi
80105a7f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a85:	e8 16 b5 ff ff       	call   80100fa0 <exec>
80105a8a:	83 c4 10             	add    $0x10,%esp
}
80105a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a90:	5b                   	pop    %ebx
80105a91:	5e                   	pop    %esi
80105a92:	5f                   	pop    %edi
80105a93:	5d                   	pop    %ebp
80105a94:	c3                   	ret
80105a95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a9c:	00 
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi

80105aa0 <sys_pipe>:

int
sys_pipe(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aa5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105aa8:	53                   	push   %ebx
80105aa9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aac:	6a 08                	push   $0x8
80105aae:	50                   	push   %eax
80105aaf:	6a 00                	push   $0x0
80105ab1:	e8 da f3 ff ff       	call   80104e90 <argptr>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	0f 88 8b 00 00 00    	js     80105b4c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ac1:	83 ec 08             	sub    $0x8,%esp
80105ac4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac7:	50                   	push   %eax
80105ac8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105acb:	50                   	push   %eax
80105acc:	e8 2f de ff ff       	call   80103900 <pipealloc>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 74                	js     80105b4c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ad8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105adb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105add:	e8 6e e3 ff ff       	call   80103e50 <myproc>
    if(curproc->ofile[fd] == 0){
80105ae2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ae6:	85 f6                	test   %esi,%esi
80105ae8:	74 16                	je     80105b00 <sys_pipe+0x60>
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105af0:	83 c3 01             	add    $0x1,%ebx
80105af3:	83 fb 10             	cmp    $0x10,%ebx
80105af6:	74 3d                	je     80105b35 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105af8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105afc:	85 f6                	test   %esi,%esi
80105afe:	75 f0                	jne    80105af0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b00:	8d 73 08             	lea    0x8(%ebx),%esi
80105b03:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b0a:	e8 41 e3 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b0f:	31 d2                	xor    %edx,%edx
80105b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b18:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b1c:	85 c9                	test   %ecx,%ecx
80105b1e:	74 38                	je     80105b58 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105b20:	83 c2 01             	add    $0x1,%edx
80105b23:	83 fa 10             	cmp    $0x10,%edx
80105b26:	75 f0                	jne    80105b18 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b28:	e8 23 e3 ff ff       	call   80103e50 <myproc>
80105b2d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b34:	00 
    fileclose(rf);
80105b35:	83 ec 0c             	sub    $0xc,%esp
80105b38:	ff 75 e0             	push   -0x20(%ebp)
80105b3b:	e8 c0 b8 ff ff       	call   80101400 <fileclose>
    fileclose(wf);
80105b40:	58                   	pop    %eax
80105b41:	ff 75 e4             	push   -0x1c(%ebp)
80105b44:	e8 b7 b8 ff ff       	call   80101400 <fileclose>
    return -1;
80105b49:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b51:	eb 16                	jmp    80105b69 <sys_pipe+0xc9>
80105b53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105b58:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b5f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b64:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b67:	31 c0                	xor    %eax,%eax
}
80105b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6c:	5b                   	pop    %ebx
80105b6d:	5e                   	pop    %esi
80105b6e:	5f                   	pop    %edi
80105b6f:	5d                   	pop    %ebp
80105b70:	c3                   	ret
80105b71:	66 90                	xchg   %ax,%ax
80105b73:	66 90                	xchg   %ax,%ax
80105b75:	66 90                	xchg   %ax,%ax
80105b77:	66 90                	xchg   %ax,%ax
80105b79:	66 90                	xchg   %ax,%ax
80105b7b:	66 90                	xchg   %ax,%ax
80105b7d:	66 90                	xchg   %ax,%ax
80105b7f:	90                   	nop

80105b80 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105b80:	e9 6b e4 ff ff       	jmp    80103ff0 <fork>
80105b85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b8c:	00 
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi

80105b90 <sys_exit>:
}

int
sys_exit(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b96:	e8 c5 e6 ff ff       	call   80104260 <exit>
  return 0;  // not reached
}
80105b9b:	31 c0                	xor    %eax,%eax
80105b9d:	c9                   	leave
80105b9e:	c3                   	ret
80105b9f:	90                   	nop

80105ba0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ba0:	e9 eb e7 ff ff       	jmp    80104390 <wait>
80105ba5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bac:	00 
80105bad:	8d 76 00             	lea    0x0(%esi),%esi

80105bb0 <sys_kill>:
}

int
sys_kill(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bb9:	50                   	push   %eax
80105bba:	6a 00                	push   $0x0
80105bbc:	e8 7f f2 ff ff       	call   80104e40 <argint>
80105bc1:	83 c4 10             	add    $0x10,%esp
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	78 18                	js     80105be0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bc8:	83 ec 0c             	sub    $0xc,%esp
80105bcb:	ff 75 f4             	push   -0xc(%ebp)
80105bce:	e8 5d ea ff ff       	call   80104630 <kill>
80105bd3:	83 c4 10             	add    $0x10,%esp
}
80105bd6:	c9                   	leave
80105bd7:	c3                   	ret
80105bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bdf:	00 
80105be0:	c9                   	leave
    return -1;
80105be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be6:	c3                   	ret
80105be7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bee:	00 
80105bef:	90                   	nop

80105bf0 <sys_getpid>:

int
sys_getpid(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bf6:	e8 55 e2 ff ff       	call   80103e50 <myproc>
80105bfb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105bfe:	c9                   	leave
80105bff:	c3                   	ret

80105c00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c0a:	50                   	push   %eax
80105c0b:	6a 00                	push   $0x0
80105c0d:	e8 2e f2 ff ff       	call   80104e40 <argint>
80105c12:	83 c4 10             	add    $0x10,%esp
80105c15:	85 c0                	test   %eax,%eax
80105c17:	78 27                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c19:	e8 32 e2 ff ff       	call   80103e50 <myproc>
  if(growproc(n) < 0)
80105c1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c23:	ff 75 f4             	push   -0xc(%ebp)
80105c26:	e8 45 e3 ff ff       	call   80103f70 <growproc>
80105c2b:	83 c4 10             	add    $0x10,%esp
80105c2e:	85 c0                	test   %eax,%eax
80105c30:	78 0e                	js     80105c40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c32:	89 d8                	mov    %ebx,%eax
80105c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c37:	c9                   	leave
80105c38:	c3                   	ret
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c45:	eb eb                	jmp    80105c32 <sys_sbrk+0x32>
80105c47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c4e:	00 
80105c4f:	90                   	nop

80105c50 <sys_sleep>:

int
sys_sleep(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 de f1 ff ff       	call   80104e40 <argint>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 64                	js     80105ccd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105c69:	83 ec 0c             	sub    $0xc,%esp
80105c6c:	68 80 4c 11 80       	push   $0x80114c80
80105c71:	e8 1a ee ff ff       	call   80104a90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c79:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  while(ticks - ticks0 < n){
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	85 d2                	test   %edx,%edx
80105c84:	75 2b                	jne    80105cb1 <sys_sleep+0x61>
80105c86:	eb 58                	jmp    80105ce0 <sys_sleep+0x90>
80105c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c8f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	68 80 4c 11 80       	push   $0x80114c80
80105c98:	68 60 4c 11 80       	push   $0x80114c60
80105c9d:	e8 6e e8 ff ff       	call   80104510 <sleep>
  while(ticks - ticks0 < n){
80105ca2:	a1 60 4c 11 80       	mov    0x80114c60,%eax
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	29 d8                	sub    %ebx,%eax
80105cac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105caf:	73 2f                	jae    80105ce0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cb1:	e8 9a e1 ff ff       	call   80103e50 <myproc>
80105cb6:	8b 40 24             	mov    0x24(%eax),%eax
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 d3                	je     80105c90 <sys_sleep+0x40>
      release(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 80 4c 11 80       	push   $0x80114c80
80105cc5:	e8 66 ed ff ff       	call   80104a30 <release>
      return -1;
80105cca:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cd5:	c9                   	leave
80105cd6:	c3                   	ret
80105cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cde:	00 
80105cdf:	90                   	nop
  release(&tickslock);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	68 80 4c 11 80       	push   $0x80114c80
80105ce8:	e8 43 ed ff ff       	call   80104a30 <release>
}
80105ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	31 c0                	xor    %eax,%eax
}
80105cf5:	c9                   	leave
80105cf6:	c3                   	ret
80105cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cfe:	00 
80105cff:	90                   	nop

80105d00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	53                   	push   %ebx
80105d04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d07:	68 80 4c 11 80       	push   $0x80114c80
80105d0c:	e8 7f ed ff ff       	call   80104a90 <acquire>
  xticks = ticks;
80105d11:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  release(&tickslock);
80105d17:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105d1e:	e8 0d ed ff ff       	call   80104a30 <release>
  return xticks;
}
80105d23:	89 d8                	mov    %ebx,%eax
80105d25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d28:	c9                   	leave
80105d29:	c3                   	ret

80105d2a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d2a:	1e                   	push   %ds
  pushl %es
80105d2b:	06                   	push   %es
  pushl %fs
80105d2c:	0f a0                	push   %fs
  pushl %gs
80105d2e:	0f a8                	push   %gs
  pushal
80105d30:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d31:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d35:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d37:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d39:	54                   	push   %esp
  call trap
80105d3a:	e8 c1 00 00 00       	call   80105e00 <trap>
  addl $4, %esp
80105d3f:	83 c4 04             	add    $0x4,%esp

80105d42 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d42:	61                   	popa
  popl %gs
80105d43:	0f a9                	pop    %gs
  popl %fs
80105d45:	0f a1                	pop    %fs
  popl %es
80105d47:	07                   	pop    %es
  popl %ds
80105d48:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d49:	83 c4 08             	add    $0x8,%esp
  iret
80105d4c:	cf                   	iret
80105d4d:	66 90                	xchg   %ax,%ax
80105d4f:	90                   	nop

80105d50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d51:	31 c0                	xor    %eax,%eax
{
80105d53:	89 e5                	mov    %esp,%ebp
80105d55:	83 ec 08             	sub    $0x8,%esp
80105d58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d5f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d60:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d67:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105d6e:	08 00 00 8e 
80105d72:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105d79:	80 
80105d7a:	c1 ea 10             	shr    $0x10,%edx
80105d7d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105d84:	80 
  for(i = 0; i < 256; i++)
80105d85:	83 c0 01             	add    $0x1,%eax
80105d88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d8d:	75 d1                	jne    80105d60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d92:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d97:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105d9e:	00 00 ef 
  initlock(&tickslock, "time");
80105da1:	68 4e 7a 10 80       	push   $0x80107a4e
80105da6:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dab:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105db1:	c1 e8 10             	shr    $0x10,%eax
80105db4:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105dba:	e8 e1 ea ff ff       	call   801048a0 <initlock>
}
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	c9                   	leave
80105dc3:	c3                   	ret
80105dc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dcb:	00 
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <idtinit>:

void
idtinit(void)
{
80105dd0:	55                   	push   %ebp
  pd[0] = size-1;
80105dd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dd6:	89 e5                	mov    %esp,%ebp
80105dd8:	83 ec 10             	sub    $0x10,%esp
80105ddb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ddf:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105de4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105de8:	c1 e8 10             	shr    $0x10,%eax
80105deb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105def:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105df2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105df5:	c9                   	leave
80105df6:	c3                   	ret
80105df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dfe:	00 
80105dff:	90                   	nop

80105e00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	83 ec 1c             	sub    $0x1c,%esp
80105e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e0f:	83 f8 40             	cmp    $0x40,%eax
80105e12:	0f 84 58 01 00 00    	je     80105f70 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e18:	83 e8 20             	sub    $0x20,%eax
80105e1b:	83 f8 1f             	cmp    $0x1f,%eax
80105e1e:	0f 87 7c 00 00 00    	ja     80105ea0 <trap+0xa0>
80105e24:	ff 24 85 f8 7f 10 80 	jmp    *-0x7fef8008(,%eax,4)
80105e2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e30:	e8 eb c8 ff ff       	call   80102720 <ideintr>
    lapiceoi();
80105e35:	e8 a6 cf ff ff       	call   80102de0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e3a:	e8 11 e0 ff ff       	call   80103e50 <myproc>
80105e3f:	85 c0                	test   %eax,%eax
80105e41:	74 1a                	je     80105e5d <trap+0x5d>
80105e43:	e8 08 e0 ff ff       	call   80103e50 <myproc>
80105e48:	8b 50 24             	mov    0x24(%eax),%edx
80105e4b:	85 d2                	test   %edx,%edx
80105e4d:	74 0e                	je     80105e5d <trap+0x5d>
80105e4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e53:	f7 d0                	not    %eax
80105e55:	a8 03                	test   $0x3,%al
80105e57:	0f 84 db 01 00 00    	je     80106038 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e5d:	e8 ee df ff ff       	call   80103e50 <myproc>
80105e62:	85 c0                	test   %eax,%eax
80105e64:	74 0f                	je     80105e75 <trap+0x75>
80105e66:	e8 e5 df ff ff       	call   80103e50 <myproc>
80105e6b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e6f:	0f 84 ab 00 00 00    	je     80105f20 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e75:	e8 d6 df ff ff       	call   80103e50 <myproc>
80105e7a:	85 c0                	test   %eax,%eax
80105e7c:	74 1a                	je     80105e98 <trap+0x98>
80105e7e:	e8 cd df ff ff       	call   80103e50 <myproc>
80105e83:	8b 40 24             	mov    0x24(%eax),%eax
80105e86:	85 c0                	test   %eax,%eax
80105e88:	74 0e                	je     80105e98 <trap+0x98>
80105e8a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e8e:	f7 d0                	not    %eax
80105e90:	a8 03                	test   $0x3,%al
80105e92:	0f 84 05 01 00 00    	je     80105f9d <trap+0x19d>
    exit();
}
80105e98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e9b:	5b                   	pop    %ebx
80105e9c:	5e                   	pop    %esi
80105e9d:	5f                   	pop    %edi
80105e9e:	5d                   	pop    %ebp
80105e9f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ea0:	e8 ab df ff ff       	call   80103e50 <myproc>
80105ea5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	0f 84 a2 01 00 00    	je     80106052 <trap+0x252>
80105eb0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105eb4:	0f 84 98 01 00 00    	je     80106052 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eba:	0f 20 d1             	mov    %cr2,%ecx
80105ebd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec0:	e8 6b df ff ff       	call   80103e30 <cpuid>
80105ec5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ec8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ecb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ed1:	e8 7a df ff ff       	call   80103e50 <myproc>
80105ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ed9:	e8 72 df ff ff       	call   80103e50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ede:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ee1:	51                   	push   %ecx
80105ee2:	57                   	push   %edi
80105ee3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ee6:	52                   	push   %edx
80105ee7:	ff 75 e4             	push   -0x1c(%ebp)
80105eea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105eeb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105eee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ef1:	56                   	push   %esi
80105ef2:	ff 70 10             	push   0x10(%eax)
80105ef5:	68 f4 7c 10 80       	push   $0x80107cf4
80105efa:	e8 61 a8 ff ff       	call   80100760 <cprintf>
    myproc()->killed = 1;
80105eff:	83 c4 20             	add    $0x20,%esp
80105f02:	e8 49 df ff ff       	call   80103e50 <myproc>
80105f07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0e:	e8 3d df ff ff       	call   80103e50 <myproc>
80105f13:	85 c0                	test   %eax,%eax
80105f15:	0f 85 28 ff ff ff    	jne    80105e43 <trap+0x43>
80105f1b:	e9 3d ff ff ff       	jmp    80105e5d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105f20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f24:	0f 85 4b ff ff ff    	jne    80105e75 <trap+0x75>
    yield();
80105f2a:	e8 91 e5 ff ff       	call   801044c0 <yield>
80105f2f:	e9 41 ff ff ff       	jmp    80105e75 <trap+0x75>
80105f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f38:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f3b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f3f:	e8 ec de ff ff       	call   80103e30 <cpuid>
80105f44:	57                   	push   %edi
80105f45:	56                   	push   %esi
80105f46:	50                   	push   %eax
80105f47:	68 9c 7c 10 80       	push   $0x80107c9c
80105f4c:	e8 0f a8 ff ff       	call   80100760 <cprintf>
    lapiceoi();
80105f51:	e8 8a ce ff ff       	call   80102de0 <lapiceoi>
    break;
80105f56:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f59:	e8 f2 de ff ff       	call   80103e50 <myproc>
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	0f 85 dd fe ff ff    	jne    80105e43 <trap+0x43>
80105f66:	e9 f2 fe ff ff       	jmp    80105e5d <trap+0x5d>
80105f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f70:	e8 db de ff ff       	call   80103e50 <myproc>
80105f75:	8b 70 24             	mov    0x24(%eax),%esi
80105f78:	85 f6                	test   %esi,%esi
80105f7a:	0f 85 c8 00 00 00    	jne    80106048 <trap+0x248>
    myproc()->tf = tf;
80105f80:	e8 cb de ff ff       	call   80103e50 <myproc>
80105f85:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f88:	e8 f3 ef ff ff       	call   80104f80 <syscall>
    if(myproc()->killed)
80105f8d:	e8 be de ff ff       	call   80103e50 <myproc>
80105f92:	8b 48 24             	mov    0x24(%eax),%ecx
80105f95:	85 c9                	test   %ecx,%ecx
80105f97:	0f 84 fb fe ff ff    	je     80105e98 <trap+0x98>
}
80105f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa0:	5b                   	pop    %ebx
80105fa1:	5e                   	pop    %esi
80105fa2:	5f                   	pop    %edi
80105fa3:	5d                   	pop    %ebp
      exit();
80105fa4:	e9 b7 e2 ff ff       	jmp    80104260 <exit>
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fb0:	e8 4b 02 00 00       	call   80106200 <uartintr>
    lapiceoi();
80105fb5:	e8 26 ce ff ff       	call   80102de0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fba:	e8 91 de ff ff       	call   80103e50 <myproc>
80105fbf:	85 c0                	test   %eax,%eax
80105fc1:	0f 85 7c fe ff ff    	jne    80105e43 <trap+0x43>
80105fc7:	e9 91 fe ff ff       	jmp    80105e5d <trap+0x5d>
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fd0:	e8 db cc ff ff       	call   80102cb0 <kbdintr>
    lapiceoi();
80105fd5:	e8 06 ce ff ff       	call   80102de0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fda:	e8 71 de ff ff       	call   80103e50 <myproc>
80105fdf:	85 c0                	test   %eax,%eax
80105fe1:	0f 85 5c fe ff ff    	jne    80105e43 <trap+0x43>
80105fe7:	e9 71 fe ff ff       	jmp    80105e5d <trap+0x5d>
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ff0:	e8 3b de ff ff       	call   80103e30 <cpuid>
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	0f 85 38 fe ff ff    	jne    80105e35 <trap+0x35>
      acquire(&tickslock);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	68 80 4c 11 80       	push   $0x80114c80
80106005:	e8 86 ea ff ff       	call   80104a90 <acquire>
      ticks++;
8010600a:	83 05 60 4c 11 80 01 	addl   $0x1,0x80114c60
      wakeup(&ticks);
80106011:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80106018:	e8 b3 e5 ff ff       	call   801045d0 <wakeup>
      release(&tickslock);
8010601d:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80106024:	e8 07 ea ff ff       	call   80104a30 <release>
80106029:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010602c:	e9 04 fe ff ff       	jmp    80105e35 <trap+0x35>
80106031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106038:	e8 23 e2 ff ff       	call   80104260 <exit>
8010603d:	e9 1b fe ff ff       	jmp    80105e5d <trap+0x5d>
80106042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106048:	e8 13 e2 ff ff       	call   80104260 <exit>
8010604d:	e9 2e ff ff ff       	jmp    80105f80 <trap+0x180>
80106052:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106055:	e8 d6 dd ff ff       	call   80103e30 <cpuid>
8010605a:	83 ec 0c             	sub    $0xc,%esp
8010605d:	56                   	push   %esi
8010605e:	57                   	push   %edi
8010605f:	50                   	push   %eax
80106060:	ff 73 30             	push   0x30(%ebx)
80106063:	68 c0 7c 10 80       	push   $0x80107cc0
80106068:	e8 f3 a6 ff ff       	call   80100760 <cprintf>
      panic("trap");
8010606d:	83 c4 14             	add    $0x14,%esp
80106070:	68 53 7a 10 80       	push   $0x80107a53
80106075:	e8 f6 a2 ff ff       	call   80100370 <panic>
8010607a:	66 90                	xchg   %ax,%ax
8010607c:	66 90                	xchg   %ax,%ax
8010607e:	66 90                	xchg   %ax,%ax

80106080 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106080:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106085:	85 c0                	test   %eax,%eax
80106087:	74 17                	je     801060a0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106089:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010608e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010608f:	a8 01                	test   $0x1,%al
80106091:	74 0d                	je     801060a0 <uartgetc+0x20>
80106093:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106098:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106099:	0f b6 c0             	movzbl %al,%eax
8010609c:	c3                   	ret
8010609d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801060a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060a5:	c3                   	ret
801060a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060ad:	00 
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <uartinit>:
{
801060b0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060b1:	31 c9                	xor    %ecx,%ecx
801060b3:	89 c8                	mov    %ecx,%eax
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	57                   	push   %edi
801060b8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060bd:	56                   	push   %esi
801060be:	89 fa                	mov    %edi,%edx
801060c0:	53                   	push   %ebx
801060c1:	83 ec 1c             	sub    $0x1c,%esp
801060c4:	ee                   	out    %al,(%dx)
801060c5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060cf:	89 f2                	mov    %esi,%edx
801060d1:	ee                   	out    %al,(%dx)
801060d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060dc:	ee                   	out    %al,(%dx)
801060dd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060e2:	89 c8                	mov    %ecx,%eax
801060e4:	89 da                	mov    %ebx,%edx
801060e6:	ee                   	out    %al,(%dx)
801060e7:	b8 03 00 00 00       	mov    $0x3,%eax
801060ec:	89 f2                	mov    %esi,%edx
801060ee:	ee                   	out    %al,(%dx)
801060ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060f4:	89 c8                	mov    %ecx,%eax
801060f6:	ee                   	out    %al,(%dx)
801060f7:	b8 01 00 00 00       	mov    $0x1,%eax
801060fc:	89 da                	mov    %ebx,%edx
801060fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106104:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106105:	3c ff                	cmp    $0xff,%al
80106107:	0f 84 7c 00 00 00    	je     80106189 <uartinit+0xd9>
  uart = 1;
8010610d:	c7 05 c0 54 11 80 01 	movl   $0x1,0x801154c0
80106114:	00 00 00 
80106117:	89 fa                	mov    %edi,%edx
80106119:	ec                   	in     (%dx),%al
8010611a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010611f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106120:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106123:	bf 58 7a 10 80       	mov    $0x80107a58,%edi
80106128:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010612d:	6a 00                	push   $0x0
8010612f:	6a 04                	push   $0x4
80106131:	e8 1a c8 ff ff       	call   80102950 <ioapicenable>
80106136:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106139:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106140:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106145:	85 c0                	test   %eax,%eax
80106147:	74 32                	je     8010617b <uartinit+0xcb>
80106149:	89 f2                	mov    %esi,%edx
8010614b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010614c:	a8 20                	test   $0x20,%al
8010614e:	75 21                	jne    80106171 <uartinit+0xc1>
80106150:	bb 80 00 00 00       	mov    $0x80,%ebx
80106155:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106158:	83 ec 0c             	sub    $0xc,%esp
8010615b:	6a 0a                	push   $0xa
8010615d:	e8 9e cc ff ff       	call   80102e00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106162:	83 c4 10             	add    $0x10,%esp
80106165:	83 eb 01             	sub    $0x1,%ebx
80106168:	74 07                	je     80106171 <uartinit+0xc1>
8010616a:	89 f2                	mov    %esi,%edx
8010616c:	ec                   	in     (%dx),%al
8010616d:	a8 20                	test   $0x20,%al
8010616f:	74 e7                	je     80106158 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106171:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106176:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010617a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010617b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010617f:	83 c7 01             	add    $0x1,%edi
80106182:	88 45 e7             	mov    %al,-0x19(%ebp)
80106185:	84 c0                	test   %al,%al
80106187:	75 b7                	jne    80106140 <uartinit+0x90>
}
80106189:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010618c:	5b                   	pop    %ebx
8010618d:	5e                   	pop    %esi
8010618e:	5f                   	pop    %edi
8010618f:	5d                   	pop    %ebp
80106190:	c3                   	ret
80106191:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106198:	00 
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <uartputc>:
  if(!uart)
801061a0:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801061a5:	85 c0                	test   %eax,%eax
801061a7:	74 4f                	je     801061f8 <uartputc+0x58>
{
801061a9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061aa:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061af:	89 e5                	mov    %esp,%ebp
801061b1:	56                   	push   %esi
801061b2:	53                   	push   %ebx
801061b3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061b4:	a8 20                	test   $0x20,%al
801061b6:	75 29                	jne    801061e1 <uartputc+0x41>
801061b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061c8:	83 ec 0c             	sub    $0xc,%esp
801061cb:	6a 0a                	push   $0xa
801061cd:	e8 2e cc ff ff       	call   80102e00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061d2:	83 c4 10             	add    $0x10,%esp
801061d5:	83 eb 01             	sub    $0x1,%ebx
801061d8:	74 07                	je     801061e1 <uartputc+0x41>
801061da:	89 f2                	mov    %esi,%edx
801061dc:	ec                   	in     (%dx),%al
801061dd:	a8 20                	test   $0x20,%al
801061df:	74 e7                	je     801061c8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061e1:	8b 45 08             	mov    0x8(%ebp),%eax
801061e4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061e9:	ee                   	out    %al,(%dx)
}
801061ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061ed:	5b                   	pop    %ebx
801061ee:	5e                   	pop    %esi
801061ef:	5d                   	pop    %ebp
801061f0:	c3                   	ret
801061f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061f8:	c3                   	ret
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106200 <uartintr>:

void
uartintr(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106206:	68 80 60 10 80       	push   $0x80106080
8010620b:	e8 60 a7 ff ff       	call   80100970 <consoleintr>
}
80106210:	83 c4 10             	add    $0x10,%esp
80106213:	c9                   	leave
80106214:	c3                   	ret

80106215 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $0
80106217:	6a 00                	push   $0x0
  jmp alltraps
80106219:	e9 0c fb ff ff       	jmp    80105d2a <alltraps>

8010621e <vector1>:
.globl vector1
vector1:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $1
80106220:	6a 01                	push   $0x1
  jmp alltraps
80106222:	e9 03 fb ff ff       	jmp    80105d2a <alltraps>

80106227 <vector2>:
.globl vector2
vector2:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $2
80106229:	6a 02                	push   $0x2
  jmp alltraps
8010622b:	e9 fa fa ff ff       	jmp    80105d2a <alltraps>

80106230 <vector3>:
.globl vector3
vector3:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $3
80106232:	6a 03                	push   $0x3
  jmp alltraps
80106234:	e9 f1 fa ff ff       	jmp    80105d2a <alltraps>

80106239 <vector4>:
.globl vector4
vector4:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $4
8010623b:	6a 04                	push   $0x4
  jmp alltraps
8010623d:	e9 e8 fa ff ff       	jmp    80105d2a <alltraps>

80106242 <vector5>:
.globl vector5
vector5:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $5
80106244:	6a 05                	push   $0x5
  jmp alltraps
80106246:	e9 df fa ff ff       	jmp    80105d2a <alltraps>

8010624b <vector6>:
.globl vector6
vector6:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $6
8010624d:	6a 06                	push   $0x6
  jmp alltraps
8010624f:	e9 d6 fa ff ff       	jmp    80105d2a <alltraps>

80106254 <vector7>:
.globl vector7
vector7:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $7
80106256:	6a 07                	push   $0x7
  jmp alltraps
80106258:	e9 cd fa ff ff       	jmp    80105d2a <alltraps>

8010625d <vector8>:
.globl vector8
vector8:
  pushl $8
8010625d:	6a 08                	push   $0x8
  jmp alltraps
8010625f:	e9 c6 fa ff ff       	jmp    80105d2a <alltraps>

80106264 <vector9>:
.globl vector9
vector9:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $9
80106266:	6a 09                	push   $0x9
  jmp alltraps
80106268:	e9 bd fa ff ff       	jmp    80105d2a <alltraps>

8010626d <vector10>:
.globl vector10
vector10:
  pushl $10
8010626d:	6a 0a                	push   $0xa
  jmp alltraps
8010626f:	e9 b6 fa ff ff       	jmp    80105d2a <alltraps>

80106274 <vector11>:
.globl vector11
vector11:
  pushl $11
80106274:	6a 0b                	push   $0xb
  jmp alltraps
80106276:	e9 af fa ff ff       	jmp    80105d2a <alltraps>

8010627b <vector12>:
.globl vector12
vector12:
  pushl $12
8010627b:	6a 0c                	push   $0xc
  jmp alltraps
8010627d:	e9 a8 fa ff ff       	jmp    80105d2a <alltraps>

80106282 <vector13>:
.globl vector13
vector13:
  pushl $13
80106282:	6a 0d                	push   $0xd
  jmp alltraps
80106284:	e9 a1 fa ff ff       	jmp    80105d2a <alltraps>

80106289 <vector14>:
.globl vector14
vector14:
  pushl $14
80106289:	6a 0e                	push   $0xe
  jmp alltraps
8010628b:	e9 9a fa ff ff       	jmp    80105d2a <alltraps>

80106290 <vector15>:
.globl vector15
vector15:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $15
80106292:	6a 0f                	push   $0xf
  jmp alltraps
80106294:	e9 91 fa ff ff       	jmp    80105d2a <alltraps>

80106299 <vector16>:
.globl vector16
vector16:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $16
8010629b:	6a 10                	push   $0x10
  jmp alltraps
8010629d:	e9 88 fa ff ff       	jmp    80105d2a <alltraps>

801062a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062a2:	6a 11                	push   $0x11
  jmp alltraps
801062a4:	e9 81 fa ff ff       	jmp    80105d2a <alltraps>

801062a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $18
801062ab:	6a 12                	push   $0x12
  jmp alltraps
801062ad:	e9 78 fa ff ff       	jmp    80105d2a <alltraps>

801062b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $19
801062b4:	6a 13                	push   $0x13
  jmp alltraps
801062b6:	e9 6f fa ff ff       	jmp    80105d2a <alltraps>

801062bb <vector20>:
.globl vector20
vector20:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $20
801062bd:	6a 14                	push   $0x14
  jmp alltraps
801062bf:	e9 66 fa ff ff       	jmp    80105d2a <alltraps>

801062c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $21
801062c6:	6a 15                	push   $0x15
  jmp alltraps
801062c8:	e9 5d fa ff ff       	jmp    80105d2a <alltraps>

801062cd <vector22>:
.globl vector22
vector22:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $22
801062cf:	6a 16                	push   $0x16
  jmp alltraps
801062d1:	e9 54 fa ff ff       	jmp    80105d2a <alltraps>

801062d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $23
801062d8:	6a 17                	push   $0x17
  jmp alltraps
801062da:	e9 4b fa ff ff       	jmp    80105d2a <alltraps>

801062df <vector24>:
.globl vector24
vector24:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $24
801062e1:	6a 18                	push   $0x18
  jmp alltraps
801062e3:	e9 42 fa ff ff       	jmp    80105d2a <alltraps>

801062e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $25
801062ea:	6a 19                	push   $0x19
  jmp alltraps
801062ec:	e9 39 fa ff ff       	jmp    80105d2a <alltraps>

801062f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $26
801062f3:	6a 1a                	push   $0x1a
  jmp alltraps
801062f5:	e9 30 fa ff ff       	jmp    80105d2a <alltraps>

801062fa <vector27>:
.globl vector27
vector27:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $27
801062fc:	6a 1b                	push   $0x1b
  jmp alltraps
801062fe:	e9 27 fa ff ff       	jmp    80105d2a <alltraps>

80106303 <vector28>:
.globl vector28
vector28:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $28
80106305:	6a 1c                	push   $0x1c
  jmp alltraps
80106307:	e9 1e fa ff ff       	jmp    80105d2a <alltraps>

8010630c <vector29>:
.globl vector29
vector29:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $29
8010630e:	6a 1d                	push   $0x1d
  jmp alltraps
80106310:	e9 15 fa ff ff       	jmp    80105d2a <alltraps>

80106315 <vector30>:
.globl vector30
vector30:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $30
80106317:	6a 1e                	push   $0x1e
  jmp alltraps
80106319:	e9 0c fa ff ff       	jmp    80105d2a <alltraps>

8010631e <vector31>:
.globl vector31
vector31:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $31
80106320:	6a 1f                	push   $0x1f
  jmp alltraps
80106322:	e9 03 fa ff ff       	jmp    80105d2a <alltraps>

80106327 <vector32>:
.globl vector32
vector32:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $32
80106329:	6a 20                	push   $0x20
  jmp alltraps
8010632b:	e9 fa f9 ff ff       	jmp    80105d2a <alltraps>

80106330 <vector33>:
.globl vector33
vector33:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $33
80106332:	6a 21                	push   $0x21
  jmp alltraps
80106334:	e9 f1 f9 ff ff       	jmp    80105d2a <alltraps>

80106339 <vector34>:
.globl vector34
vector34:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $34
8010633b:	6a 22                	push   $0x22
  jmp alltraps
8010633d:	e9 e8 f9 ff ff       	jmp    80105d2a <alltraps>

80106342 <vector35>:
.globl vector35
vector35:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $35
80106344:	6a 23                	push   $0x23
  jmp alltraps
80106346:	e9 df f9 ff ff       	jmp    80105d2a <alltraps>

8010634b <vector36>:
.globl vector36
vector36:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $36
8010634d:	6a 24                	push   $0x24
  jmp alltraps
8010634f:	e9 d6 f9 ff ff       	jmp    80105d2a <alltraps>

80106354 <vector37>:
.globl vector37
vector37:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $37
80106356:	6a 25                	push   $0x25
  jmp alltraps
80106358:	e9 cd f9 ff ff       	jmp    80105d2a <alltraps>

8010635d <vector38>:
.globl vector38
vector38:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $38
8010635f:	6a 26                	push   $0x26
  jmp alltraps
80106361:	e9 c4 f9 ff ff       	jmp    80105d2a <alltraps>

80106366 <vector39>:
.globl vector39
vector39:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $39
80106368:	6a 27                	push   $0x27
  jmp alltraps
8010636a:	e9 bb f9 ff ff       	jmp    80105d2a <alltraps>

8010636f <vector40>:
.globl vector40
vector40:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $40
80106371:	6a 28                	push   $0x28
  jmp alltraps
80106373:	e9 b2 f9 ff ff       	jmp    80105d2a <alltraps>

80106378 <vector41>:
.globl vector41
vector41:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $41
8010637a:	6a 29                	push   $0x29
  jmp alltraps
8010637c:	e9 a9 f9 ff ff       	jmp    80105d2a <alltraps>

80106381 <vector42>:
.globl vector42
vector42:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $42
80106383:	6a 2a                	push   $0x2a
  jmp alltraps
80106385:	e9 a0 f9 ff ff       	jmp    80105d2a <alltraps>

8010638a <vector43>:
.globl vector43
vector43:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $43
8010638c:	6a 2b                	push   $0x2b
  jmp alltraps
8010638e:	e9 97 f9 ff ff       	jmp    80105d2a <alltraps>

80106393 <vector44>:
.globl vector44
vector44:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $44
80106395:	6a 2c                	push   $0x2c
  jmp alltraps
80106397:	e9 8e f9 ff ff       	jmp    80105d2a <alltraps>

8010639c <vector45>:
.globl vector45
vector45:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $45
8010639e:	6a 2d                	push   $0x2d
  jmp alltraps
801063a0:	e9 85 f9 ff ff       	jmp    80105d2a <alltraps>

801063a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $46
801063a7:	6a 2e                	push   $0x2e
  jmp alltraps
801063a9:	e9 7c f9 ff ff       	jmp    80105d2a <alltraps>

801063ae <vector47>:
.globl vector47
vector47:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $47
801063b0:	6a 2f                	push   $0x2f
  jmp alltraps
801063b2:	e9 73 f9 ff ff       	jmp    80105d2a <alltraps>

801063b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $48
801063b9:	6a 30                	push   $0x30
  jmp alltraps
801063bb:	e9 6a f9 ff ff       	jmp    80105d2a <alltraps>

801063c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $49
801063c2:	6a 31                	push   $0x31
  jmp alltraps
801063c4:	e9 61 f9 ff ff       	jmp    80105d2a <alltraps>

801063c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $50
801063cb:	6a 32                	push   $0x32
  jmp alltraps
801063cd:	e9 58 f9 ff ff       	jmp    80105d2a <alltraps>

801063d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $51
801063d4:	6a 33                	push   $0x33
  jmp alltraps
801063d6:	e9 4f f9 ff ff       	jmp    80105d2a <alltraps>

801063db <vector52>:
.globl vector52
vector52:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $52
801063dd:	6a 34                	push   $0x34
  jmp alltraps
801063df:	e9 46 f9 ff ff       	jmp    80105d2a <alltraps>

801063e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $53
801063e6:	6a 35                	push   $0x35
  jmp alltraps
801063e8:	e9 3d f9 ff ff       	jmp    80105d2a <alltraps>

801063ed <vector54>:
.globl vector54
vector54:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $54
801063ef:	6a 36                	push   $0x36
  jmp alltraps
801063f1:	e9 34 f9 ff ff       	jmp    80105d2a <alltraps>

801063f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $55
801063f8:	6a 37                	push   $0x37
  jmp alltraps
801063fa:	e9 2b f9 ff ff       	jmp    80105d2a <alltraps>

801063ff <vector56>:
.globl vector56
vector56:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $56
80106401:	6a 38                	push   $0x38
  jmp alltraps
80106403:	e9 22 f9 ff ff       	jmp    80105d2a <alltraps>

80106408 <vector57>:
.globl vector57
vector57:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $57
8010640a:	6a 39                	push   $0x39
  jmp alltraps
8010640c:	e9 19 f9 ff ff       	jmp    80105d2a <alltraps>

80106411 <vector58>:
.globl vector58
vector58:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $58
80106413:	6a 3a                	push   $0x3a
  jmp alltraps
80106415:	e9 10 f9 ff ff       	jmp    80105d2a <alltraps>

8010641a <vector59>:
.globl vector59
vector59:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $59
8010641c:	6a 3b                	push   $0x3b
  jmp alltraps
8010641e:	e9 07 f9 ff ff       	jmp    80105d2a <alltraps>

80106423 <vector60>:
.globl vector60
vector60:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $60
80106425:	6a 3c                	push   $0x3c
  jmp alltraps
80106427:	e9 fe f8 ff ff       	jmp    80105d2a <alltraps>

8010642c <vector61>:
.globl vector61
vector61:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $61
8010642e:	6a 3d                	push   $0x3d
  jmp alltraps
80106430:	e9 f5 f8 ff ff       	jmp    80105d2a <alltraps>

80106435 <vector62>:
.globl vector62
vector62:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $62
80106437:	6a 3e                	push   $0x3e
  jmp alltraps
80106439:	e9 ec f8 ff ff       	jmp    80105d2a <alltraps>

8010643e <vector63>:
.globl vector63
vector63:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $63
80106440:	6a 3f                	push   $0x3f
  jmp alltraps
80106442:	e9 e3 f8 ff ff       	jmp    80105d2a <alltraps>

80106447 <vector64>:
.globl vector64
vector64:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $64
80106449:	6a 40                	push   $0x40
  jmp alltraps
8010644b:	e9 da f8 ff ff       	jmp    80105d2a <alltraps>

80106450 <vector65>:
.globl vector65
vector65:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $65
80106452:	6a 41                	push   $0x41
  jmp alltraps
80106454:	e9 d1 f8 ff ff       	jmp    80105d2a <alltraps>

80106459 <vector66>:
.globl vector66
vector66:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $66
8010645b:	6a 42                	push   $0x42
  jmp alltraps
8010645d:	e9 c8 f8 ff ff       	jmp    80105d2a <alltraps>

80106462 <vector67>:
.globl vector67
vector67:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $67
80106464:	6a 43                	push   $0x43
  jmp alltraps
80106466:	e9 bf f8 ff ff       	jmp    80105d2a <alltraps>

8010646b <vector68>:
.globl vector68
vector68:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $68
8010646d:	6a 44                	push   $0x44
  jmp alltraps
8010646f:	e9 b6 f8 ff ff       	jmp    80105d2a <alltraps>

80106474 <vector69>:
.globl vector69
vector69:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $69
80106476:	6a 45                	push   $0x45
  jmp alltraps
80106478:	e9 ad f8 ff ff       	jmp    80105d2a <alltraps>

8010647d <vector70>:
.globl vector70
vector70:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $70
8010647f:	6a 46                	push   $0x46
  jmp alltraps
80106481:	e9 a4 f8 ff ff       	jmp    80105d2a <alltraps>

80106486 <vector71>:
.globl vector71
vector71:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $71
80106488:	6a 47                	push   $0x47
  jmp alltraps
8010648a:	e9 9b f8 ff ff       	jmp    80105d2a <alltraps>

8010648f <vector72>:
.globl vector72
vector72:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $72
80106491:	6a 48                	push   $0x48
  jmp alltraps
80106493:	e9 92 f8 ff ff       	jmp    80105d2a <alltraps>

80106498 <vector73>:
.globl vector73
vector73:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $73
8010649a:	6a 49                	push   $0x49
  jmp alltraps
8010649c:	e9 89 f8 ff ff       	jmp    80105d2a <alltraps>

801064a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $74
801064a3:	6a 4a                	push   $0x4a
  jmp alltraps
801064a5:	e9 80 f8 ff ff       	jmp    80105d2a <alltraps>

801064aa <vector75>:
.globl vector75
vector75:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $75
801064ac:	6a 4b                	push   $0x4b
  jmp alltraps
801064ae:	e9 77 f8 ff ff       	jmp    80105d2a <alltraps>

801064b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $76
801064b5:	6a 4c                	push   $0x4c
  jmp alltraps
801064b7:	e9 6e f8 ff ff       	jmp    80105d2a <alltraps>

801064bc <vector77>:
.globl vector77
vector77:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $77
801064be:	6a 4d                	push   $0x4d
  jmp alltraps
801064c0:	e9 65 f8 ff ff       	jmp    80105d2a <alltraps>

801064c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $78
801064c7:	6a 4e                	push   $0x4e
  jmp alltraps
801064c9:	e9 5c f8 ff ff       	jmp    80105d2a <alltraps>

801064ce <vector79>:
.globl vector79
vector79:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $79
801064d0:	6a 4f                	push   $0x4f
  jmp alltraps
801064d2:	e9 53 f8 ff ff       	jmp    80105d2a <alltraps>

801064d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $80
801064d9:	6a 50                	push   $0x50
  jmp alltraps
801064db:	e9 4a f8 ff ff       	jmp    80105d2a <alltraps>

801064e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $81
801064e2:	6a 51                	push   $0x51
  jmp alltraps
801064e4:	e9 41 f8 ff ff       	jmp    80105d2a <alltraps>

801064e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $82
801064eb:	6a 52                	push   $0x52
  jmp alltraps
801064ed:	e9 38 f8 ff ff       	jmp    80105d2a <alltraps>

801064f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $83
801064f4:	6a 53                	push   $0x53
  jmp alltraps
801064f6:	e9 2f f8 ff ff       	jmp    80105d2a <alltraps>

801064fb <vector84>:
.globl vector84
vector84:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $84
801064fd:	6a 54                	push   $0x54
  jmp alltraps
801064ff:	e9 26 f8 ff ff       	jmp    80105d2a <alltraps>

80106504 <vector85>:
.globl vector85
vector85:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $85
80106506:	6a 55                	push   $0x55
  jmp alltraps
80106508:	e9 1d f8 ff ff       	jmp    80105d2a <alltraps>

8010650d <vector86>:
.globl vector86
vector86:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $86
8010650f:	6a 56                	push   $0x56
  jmp alltraps
80106511:	e9 14 f8 ff ff       	jmp    80105d2a <alltraps>

80106516 <vector87>:
.globl vector87
vector87:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $87
80106518:	6a 57                	push   $0x57
  jmp alltraps
8010651a:	e9 0b f8 ff ff       	jmp    80105d2a <alltraps>

8010651f <vector88>:
.globl vector88
vector88:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $88
80106521:	6a 58                	push   $0x58
  jmp alltraps
80106523:	e9 02 f8 ff ff       	jmp    80105d2a <alltraps>

80106528 <vector89>:
.globl vector89
vector89:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $89
8010652a:	6a 59                	push   $0x59
  jmp alltraps
8010652c:	e9 f9 f7 ff ff       	jmp    80105d2a <alltraps>

80106531 <vector90>:
.globl vector90
vector90:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $90
80106533:	6a 5a                	push   $0x5a
  jmp alltraps
80106535:	e9 f0 f7 ff ff       	jmp    80105d2a <alltraps>

8010653a <vector91>:
.globl vector91
vector91:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $91
8010653c:	6a 5b                	push   $0x5b
  jmp alltraps
8010653e:	e9 e7 f7 ff ff       	jmp    80105d2a <alltraps>

80106543 <vector92>:
.globl vector92
vector92:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $92
80106545:	6a 5c                	push   $0x5c
  jmp alltraps
80106547:	e9 de f7 ff ff       	jmp    80105d2a <alltraps>

8010654c <vector93>:
.globl vector93
vector93:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $93
8010654e:	6a 5d                	push   $0x5d
  jmp alltraps
80106550:	e9 d5 f7 ff ff       	jmp    80105d2a <alltraps>

80106555 <vector94>:
.globl vector94
vector94:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $94
80106557:	6a 5e                	push   $0x5e
  jmp alltraps
80106559:	e9 cc f7 ff ff       	jmp    80105d2a <alltraps>

8010655e <vector95>:
.globl vector95
vector95:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $95
80106560:	6a 5f                	push   $0x5f
  jmp alltraps
80106562:	e9 c3 f7 ff ff       	jmp    80105d2a <alltraps>

80106567 <vector96>:
.globl vector96
vector96:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $96
80106569:	6a 60                	push   $0x60
  jmp alltraps
8010656b:	e9 ba f7 ff ff       	jmp    80105d2a <alltraps>

80106570 <vector97>:
.globl vector97
vector97:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $97
80106572:	6a 61                	push   $0x61
  jmp alltraps
80106574:	e9 b1 f7 ff ff       	jmp    80105d2a <alltraps>

80106579 <vector98>:
.globl vector98
vector98:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $98
8010657b:	6a 62                	push   $0x62
  jmp alltraps
8010657d:	e9 a8 f7 ff ff       	jmp    80105d2a <alltraps>

80106582 <vector99>:
.globl vector99
vector99:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $99
80106584:	6a 63                	push   $0x63
  jmp alltraps
80106586:	e9 9f f7 ff ff       	jmp    80105d2a <alltraps>

8010658b <vector100>:
.globl vector100
vector100:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $100
8010658d:	6a 64                	push   $0x64
  jmp alltraps
8010658f:	e9 96 f7 ff ff       	jmp    80105d2a <alltraps>

80106594 <vector101>:
.globl vector101
vector101:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $101
80106596:	6a 65                	push   $0x65
  jmp alltraps
80106598:	e9 8d f7 ff ff       	jmp    80105d2a <alltraps>

8010659d <vector102>:
.globl vector102
vector102:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $102
8010659f:	6a 66                	push   $0x66
  jmp alltraps
801065a1:	e9 84 f7 ff ff       	jmp    80105d2a <alltraps>

801065a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $103
801065a8:	6a 67                	push   $0x67
  jmp alltraps
801065aa:	e9 7b f7 ff ff       	jmp    80105d2a <alltraps>

801065af <vector104>:
.globl vector104
vector104:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $104
801065b1:	6a 68                	push   $0x68
  jmp alltraps
801065b3:	e9 72 f7 ff ff       	jmp    80105d2a <alltraps>

801065b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $105
801065ba:	6a 69                	push   $0x69
  jmp alltraps
801065bc:	e9 69 f7 ff ff       	jmp    80105d2a <alltraps>

801065c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $106
801065c3:	6a 6a                	push   $0x6a
  jmp alltraps
801065c5:	e9 60 f7 ff ff       	jmp    80105d2a <alltraps>

801065ca <vector107>:
.globl vector107
vector107:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $107
801065cc:	6a 6b                	push   $0x6b
  jmp alltraps
801065ce:	e9 57 f7 ff ff       	jmp    80105d2a <alltraps>

801065d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $108
801065d5:	6a 6c                	push   $0x6c
  jmp alltraps
801065d7:	e9 4e f7 ff ff       	jmp    80105d2a <alltraps>

801065dc <vector109>:
.globl vector109
vector109:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $109
801065de:	6a 6d                	push   $0x6d
  jmp alltraps
801065e0:	e9 45 f7 ff ff       	jmp    80105d2a <alltraps>

801065e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $110
801065e7:	6a 6e                	push   $0x6e
  jmp alltraps
801065e9:	e9 3c f7 ff ff       	jmp    80105d2a <alltraps>

801065ee <vector111>:
.globl vector111
vector111:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $111
801065f0:	6a 6f                	push   $0x6f
  jmp alltraps
801065f2:	e9 33 f7 ff ff       	jmp    80105d2a <alltraps>

801065f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $112
801065f9:	6a 70                	push   $0x70
  jmp alltraps
801065fb:	e9 2a f7 ff ff       	jmp    80105d2a <alltraps>

80106600 <vector113>:
.globl vector113
vector113:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $113
80106602:	6a 71                	push   $0x71
  jmp alltraps
80106604:	e9 21 f7 ff ff       	jmp    80105d2a <alltraps>

80106609 <vector114>:
.globl vector114
vector114:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $114
8010660b:	6a 72                	push   $0x72
  jmp alltraps
8010660d:	e9 18 f7 ff ff       	jmp    80105d2a <alltraps>

80106612 <vector115>:
.globl vector115
vector115:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $115
80106614:	6a 73                	push   $0x73
  jmp alltraps
80106616:	e9 0f f7 ff ff       	jmp    80105d2a <alltraps>

8010661b <vector116>:
.globl vector116
vector116:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $116
8010661d:	6a 74                	push   $0x74
  jmp alltraps
8010661f:	e9 06 f7 ff ff       	jmp    80105d2a <alltraps>

80106624 <vector117>:
.globl vector117
vector117:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $117
80106626:	6a 75                	push   $0x75
  jmp alltraps
80106628:	e9 fd f6 ff ff       	jmp    80105d2a <alltraps>

8010662d <vector118>:
.globl vector118
vector118:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $118
8010662f:	6a 76                	push   $0x76
  jmp alltraps
80106631:	e9 f4 f6 ff ff       	jmp    80105d2a <alltraps>

80106636 <vector119>:
.globl vector119
vector119:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $119
80106638:	6a 77                	push   $0x77
  jmp alltraps
8010663a:	e9 eb f6 ff ff       	jmp    80105d2a <alltraps>

8010663f <vector120>:
.globl vector120
vector120:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $120
80106641:	6a 78                	push   $0x78
  jmp alltraps
80106643:	e9 e2 f6 ff ff       	jmp    80105d2a <alltraps>

80106648 <vector121>:
.globl vector121
vector121:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $121
8010664a:	6a 79                	push   $0x79
  jmp alltraps
8010664c:	e9 d9 f6 ff ff       	jmp    80105d2a <alltraps>

80106651 <vector122>:
.globl vector122
vector122:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $122
80106653:	6a 7a                	push   $0x7a
  jmp alltraps
80106655:	e9 d0 f6 ff ff       	jmp    80105d2a <alltraps>

8010665a <vector123>:
.globl vector123
vector123:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $123
8010665c:	6a 7b                	push   $0x7b
  jmp alltraps
8010665e:	e9 c7 f6 ff ff       	jmp    80105d2a <alltraps>

80106663 <vector124>:
.globl vector124
vector124:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $124
80106665:	6a 7c                	push   $0x7c
  jmp alltraps
80106667:	e9 be f6 ff ff       	jmp    80105d2a <alltraps>

8010666c <vector125>:
.globl vector125
vector125:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $125
8010666e:	6a 7d                	push   $0x7d
  jmp alltraps
80106670:	e9 b5 f6 ff ff       	jmp    80105d2a <alltraps>

80106675 <vector126>:
.globl vector126
vector126:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $126
80106677:	6a 7e                	push   $0x7e
  jmp alltraps
80106679:	e9 ac f6 ff ff       	jmp    80105d2a <alltraps>

8010667e <vector127>:
.globl vector127
vector127:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $127
80106680:	6a 7f                	push   $0x7f
  jmp alltraps
80106682:	e9 a3 f6 ff ff       	jmp    80105d2a <alltraps>

80106687 <vector128>:
.globl vector128
vector128:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $128
80106689:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010668e:	e9 97 f6 ff ff       	jmp    80105d2a <alltraps>

80106693 <vector129>:
.globl vector129
vector129:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $129
80106695:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010669a:	e9 8b f6 ff ff       	jmp    80105d2a <alltraps>

8010669f <vector130>:
.globl vector130
vector130:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $130
801066a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066a6:	e9 7f f6 ff ff       	jmp    80105d2a <alltraps>

801066ab <vector131>:
.globl vector131
vector131:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $131
801066ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066b2:	e9 73 f6 ff ff       	jmp    80105d2a <alltraps>

801066b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $132
801066b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066be:	e9 67 f6 ff ff       	jmp    80105d2a <alltraps>

801066c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $133
801066c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ca:	e9 5b f6 ff ff       	jmp    80105d2a <alltraps>

801066cf <vector134>:
.globl vector134
vector134:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $134
801066d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066d6:	e9 4f f6 ff ff       	jmp    80105d2a <alltraps>

801066db <vector135>:
.globl vector135
vector135:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $135
801066dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066e2:	e9 43 f6 ff ff       	jmp    80105d2a <alltraps>

801066e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $136
801066e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ee:	e9 37 f6 ff ff       	jmp    80105d2a <alltraps>

801066f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $137
801066f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066fa:	e9 2b f6 ff ff       	jmp    80105d2a <alltraps>

801066ff <vector138>:
.globl vector138
vector138:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $138
80106701:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106706:	e9 1f f6 ff ff       	jmp    80105d2a <alltraps>

8010670b <vector139>:
.globl vector139
vector139:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $139
8010670d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106712:	e9 13 f6 ff ff       	jmp    80105d2a <alltraps>

80106717 <vector140>:
.globl vector140
vector140:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $140
80106719:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010671e:	e9 07 f6 ff ff       	jmp    80105d2a <alltraps>

80106723 <vector141>:
.globl vector141
vector141:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $141
80106725:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010672a:	e9 fb f5 ff ff       	jmp    80105d2a <alltraps>

8010672f <vector142>:
.globl vector142
vector142:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $142
80106731:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106736:	e9 ef f5 ff ff       	jmp    80105d2a <alltraps>

8010673b <vector143>:
.globl vector143
vector143:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $143
8010673d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106742:	e9 e3 f5 ff ff       	jmp    80105d2a <alltraps>

80106747 <vector144>:
.globl vector144
vector144:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $144
80106749:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010674e:	e9 d7 f5 ff ff       	jmp    80105d2a <alltraps>

80106753 <vector145>:
.globl vector145
vector145:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $145
80106755:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010675a:	e9 cb f5 ff ff       	jmp    80105d2a <alltraps>

8010675f <vector146>:
.globl vector146
vector146:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $146
80106761:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106766:	e9 bf f5 ff ff       	jmp    80105d2a <alltraps>

8010676b <vector147>:
.globl vector147
vector147:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $147
8010676d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106772:	e9 b3 f5 ff ff       	jmp    80105d2a <alltraps>

80106777 <vector148>:
.globl vector148
vector148:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $148
80106779:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010677e:	e9 a7 f5 ff ff       	jmp    80105d2a <alltraps>

80106783 <vector149>:
.globl vector149
vector149:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $149
80106785:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010678a:	e9 9b f5 ff ff       	jmp    80105d2a <alltraps>

8010678f <vector150>:
.globl vector150
vector150:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $150
80106791:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106796:	e9 8f f5 ff ff       	jmp    80105d2a <alltraps>

8010679b <vector151>:
.globl vector151
vector151:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $151
8010679d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067a2:	e9 83 f5 ff ff       	jmp    80105d2a <alltraps>

801067a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $152
801067a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ae:	e9 77 f5 ff ff       	jmp    80105d2a <alltraps>

801067b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $153
801067b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ba:	e9 6b f5 ff ff       	jmp    80105d2a <alltraps>

801067bf <vector154>:
.globl vector154
vector154:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $154
801067c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067c6:	e9 5f f5 ff ff       	jmp    80105d2a <alltraps>

801067cb <vector155>:
.globl vector155
vector155:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $155
801067cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067d2:	e9 53 f5 ff ff       	jmp    80105d2a <alltraps>

801067d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $156
801067d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067de:	e9 47 f5 ff ff       	jmp    80105d2a <alltraps>

801067e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $157
801067e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ea:	e9 3b f5 ff ff       	jmp    80105d2a <alltraps>

801067ef <vector158>:
.globl vector158
vector158:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $158
801067f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067f6:	e9 2f f5 ff ff       	jmp    80105d2a <alltraps>

801067fb <vector159>:
.globl vector159
vector159:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $159
801067fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106802:	e9 23 f5 ff ff       	jmp    80105d2a <alltraps>

80106807 <vector160>:
.globl vector160
vector160:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $160
80106809:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010680e:	e9 17 f5 ff ff       	jmp    80105d2a <alltraps>

80106813 <vector161>:
.globl vector161
vector161:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $161
80106815:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010681a:	e9 0b f5 ff ff       	jmp    80105d2a <alltraps>

8010681f <vector162>:
.globl vector162
vector162:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $162
80106821:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106826:	e9 ff f4 ff ff       	jmp    80105d2a <alltraps>

8010682b <vector163>:
.globl vector163
vector163:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $163
8010682d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106832:	e9 f3 f4 ff ff       	jmp    80105d2a <alltraps>

80106837 <vector164>:
.globl vector164
vector164:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $164
80106839:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010683e:	e9 e7 f4 ff ff       	jmp    80105d2a <alltraps>

80106843 <vector165>:
.globl vector165
vector165:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $165
80106845:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010684a:	e9 db f4 ff ff       	jmp    80105d2a <alltraps>

8010684f <vector166>:
.globl vector166
vector166:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $166
80106851:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106856:	e9 cf f4 ff ff       	jmp    80105d2a <alltraps>

8010685b <vector167>:
.globl vector167
vector167:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $167
8010685d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106862:	e9 c3 f4 ff ff       	jmp    80105d2a <alltraps>

80106867 <vector168>:
.globl vector168
vector168:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $168
80106869:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010686e:	e9 b7 f4 ff ff       	jmp    80105d2a <alltraps>

80106873 <vector169>:
.globl vector169
vector169:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $169
80106875:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010687a:	e9 ab f4 ff ff       	jmp    80105d2a <alltraps>

8010687f <vector170>:
.globl vector170
vector170:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $170
80106881:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106886:	e9 9f f4 ff ff       	jmp    80105d2a <alltraps>

8010688b <vector171>:
.globl vector171
vector171:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $171
8010688d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106892:	e9 93 f4 ff ff       	jmp    80105d2a <alltraps>

80106897 <vector172>:
.globl vector172
vector172:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $172
80106899:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010689e:	e9 87 f4 ff ff       	jmp    80105d2a <alltraps>

801068a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $173
801068a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068aa:	e9 7b f4 ff ff       	jmp    80105d2a <alltraps>

801068af <vector174>:
.globl vector174
vector174:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $174
801068b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068b6:	e9 6f f4 ff ff       	jmp    80105d2a <alltraps>

801068bb <vector175>:
.globl vector175
vector175:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $175
801068bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068c2:	e9 63 f4 ff ff       	jmp    80105d2a <alltraps>

801068c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $176
801068c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ce:	e9 57 f4 ff ff       	jmp    80105d2a <alltraps>

801068d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $177
801068d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068da:	e9 4b f4 ff ff       	jmp    80105d2a <alltraps>

801068df <vector178>:
.globl vector178
vector178:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $178
801068e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068e6:	e9 3f f4 ff ff       	jmp    80105d2a <alltraps>

801068eb <vector179>:
.globl vector179
vector179:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $179
801068ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068f2:	e9 33 f4 ff ff       	jmp    80105d2a <alltraps>

801068f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $180
801068f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068fe:	e9 27 f4 ff ff       	jmp    80105d2a <alltraps>

80106903 <vector181>:
.globl vector181
vector181:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $181
80106905:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010690a:	e9 1b f4 ff ff       	jmp    80105d2a <alltraps>

8010690f <vector182>:
.globl vector182
vector182:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $182
80106911:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106916:	e9 0f f4 ff ff       	jmp    80105d2a <alltraps>

8010691b <vector183>:
.globl vector183
vector183:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $183
8010691d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106922:	e9 03 f4 ff ff       	jmp    80105d2a <alltraps>

80106927 <vector184>:
.globl vector184
vector184:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $184
80106929:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010692e:	e9 f7 f3 ff ff       	jmp    80105d2a <alltraps>

80106933 <vector185>:
.globl vector185
vector185:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $185
80106935:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010693a:	e9 eb f3 ff ff       	jmp    80105d2a <alltraps>

8010693f <vector186>:
.globl vector186
vector186:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $186
80106941:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106946:	e9 df f3 ff ff       	jmp    80105d2a <alltraps>

8010694b <vector187>:
.globl vector187
vector187:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $187
8010694d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106952:	e9 d3 f3 ff ff       	jmp    80105d2a <alltraps>

80106957 <vector188>:
.globl vector188
vector188:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $188
80106959:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010695e:	e9 c7 f3 ff ff       	jmp    80105d2a <alltraps>

80106963 <vector189>:
.globl vector189
vector189:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $189
80106965:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010696a:	e9 bb f3 ff ff       	jmp    80105d2a <alltraps>

8010696f <vector190>:
.globl vector190
vector190:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $190
80106971:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106976:	e9 af f3 ff ff       	jmp    80105d2a <alltraps>

8010697b <vector191>:
.globl vector191
vector191:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $191
8010697d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106982:	e9 a3 f3 ff ff       	jmp    80105d2a <alltraps>

80106987 <vector192>:
.globl vector192
vector192:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $192
80106989:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010698e:	e9 97 f3 ff ff       	jmp    80105d2a <alltraps>

80106993 <vector193>:
.globl vector193
vector193:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $193
80106995:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010699a:	e9 8b f3 ff ff       	jmp    80105d2a <alltraps>

8010699f <vector194>:
.globl vector194
vector194:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $194
801069a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069a6:	e9 7f f3 ff ff       	jmp    80105d2a <alltraps>

801069ab <vector195>:
.globl vector195
vector195:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $195
801069ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069b2:	e9 73 f3 ff ff       	jmp    80105d2a <alltraps>

801069b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $196
801069b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069be:	e9 67 f3 ff ff       	jmp    80105d2a <alltraps>

801069c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $197
801069c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ca:	e9 5b f3 ff ff       	jmp    80105d2a <alltraps>

801069cf <vector198>:
.globl vector198
vector198:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $198
801069d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069d6:	e9 4f f3 ff ff       	jmp    80105d2a <alltraps>

801069db <vector199>:
.globl vector199
vector199:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $199
801069dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069e2:	e9 43 f3 ff ff       	jmp    80105d2a <alltraps>

801069e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $200
801069e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ee:	e9 37 f3 ff ff       	jmp    80105d2a <alltraps>

801069f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $201
801069f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069fa:	e9 2b f3 ff ff       	jmp    80105d2a <alltraps>

801069ff <vector202>:
.globl vector202
vector202:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $202
80106a01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a06:	e9 1f f3 ff ff       	jmp    80105d2a <alltraps>

80106a0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $203
80106a0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a12:	e9 13 f3 ff ff       	jmp    80105d2a <alltraps>

80106a17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $204
80106a19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a1e:	e9 07 f3 ff ff       	jmp    80105d2a <alltraps>

80106a23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $205
80106a25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a2a:	e9 fb f2 ff ff       	jmp    80105d2a <alltraps>

80106a2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $206
80106a31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a36:	e9 ef f2 ff ff       	jmp    80105d2a <alltraps>

80106a3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $207
80106a3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a42:	e9 e3 f2 ff ff       	jmp    80105d2a <alltraps>

80106a47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $208
80106a49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a4e:	e9 d7 f2 ff ff       	jmp    80105d2a <alltraps>

80106a53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $209
80106a55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a5a:	e9 cb f2 ff ff       	jmp    80105d2a <alltraps>

80106a5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $210
80106a61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a66:	e9 bf f2 ff ff       	jmp    80105d2a <alltraps>

80106a6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $211
80106a6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a72:	e9 b3 f2 ff ff       	jmp    80105d2a <alltraps>

80106a77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $212
80106a79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a7e:	e9 a7 f2 ff ff       	jmp    80105d2a <alltraps>

80106a83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $213
80106a85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a8a:	e9 9b f2 ff ff       	jmp    80105d2a <alltraps>

80106a8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $214
80106a91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a96:	e9 8f f2 ff ff       	jmp    80105d2a <alltraps>

80106a9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $215
80106a9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106aa2:	e9 83 f2 ff ff       	jmp    80105d2a <alltraps>

80106aa7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $216
80106aa9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aae:	e9 77 f2 ff ff       	jmp    80105d2a <alltraps>

80106ab3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $217
80106ab5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aba:	e9 6b f2 ff ff       	jmp    80105d2a <alltraps>

80106abf <vector218>:
.globl vector218
vector218:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $218
80106ac1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ac6:	e9 5f f2 ff ff       	jmp    80105d2a <alltraps>

80106acb <vector219>:
.globl vector219
vector219:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $219
80106acd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ad2:	e9 53 f2 ff ff       	jmp    80105d2a <alltraps>

80106ad7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $220
80106ad9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ade:	e9 47 f2 ff ff       	jmp    80105d2a <alltraps>

80106ae3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $221
80106ae5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aea:	e9 3b f2 ff ff       	jmp    80105d2a <alltraps>

80106aef <vector222>:
.globl vector222
vector222:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $222
80106af1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106af6:	e9 2f f2 ff ff       	jmp    80105d2a <alltraps>

80106afb <vector223>:
.globl vector223
vector223:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $223
80106afd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b02:	e9 23 f2 ff ff       	jmp    80105d2a <alltraps>

80106b07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $224
80106b09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b0e:	e9 17 f2 ff ff       	jmp    80105d2a <alltraps>

80106b13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $225
80106b15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b1a:	e9 0b f2 ff ff       	jmp    80105d2a <alltraps>

80106b1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $226
80106b21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b26:	e9 ff f1 ff ff       	jmp    80105d2a <alltraps>

80106b2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $227
80106b2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b32:	e9 f3 f1 ff ff       	jmp    80105d2a <alltraps>

80106b37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $228
80106b39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b3e:	e9 e7 f1 ff ff       	jmp    80105d2a <alltraps>

80106b43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $229
80106b45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b4a:	e9 db f1 ff ff       	jmp    80105d2a <alltraps>

80106b4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $230
80106b51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b56:	e9 cf f1 ff ff       	jmp    80105d2a <alltraps>

80106b5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $231
80106b5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b62:	e9 c3 f1 ff ff       	jmp    80105d2a <alltraps>

80106b67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $232
80106b69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b6e:	e9 b7 f1 ff ff       	jmp    80105d2a <alltraps>

80106b73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $233
80106b75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b7a:	e9 ab f1 ff ff       	jmp    80105d2a <alltraps>

80106b7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $234
80106b81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b86:	e9 9f f1 ff ff       	jmp    80105d2a <alltraps>

80106b8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $235
80106b8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b92:	e9 93 f1 ff ff       	jmp    80105d2a <alltraps>

80106b97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $236
80106b99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b9e:	e9 87 f1 ff ff       	jmp    80105d2a <alltraps>

80106ba3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $237
80106ba5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106baa:	e9 7b f1 ff ff       	jmp    80105d2a <alltraps>

80106baf <vector238>:
.globl vector238
vector238:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $238
80106bb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bb6:	e9 6f f1 ff ff       	jmp    80105d2a <alltraps>

80106bbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $239
80106bbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bc2:	e9 63 f1 ff ff       	jmp    80105d2a <alltraps>

80106bc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $240
80106bc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bce:	e9 57 f1 ff ff       	jmp    80105d2a <alltraps>

80106bd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $241
80106bd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bda:	e9 4b f1 ff ff       	jmp    80105d2a <alltraps>

80106bdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $242
80106be1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106be6:	e9 3f f1 ff ff       	jmp    80105d2a <alltraps>

80106beb <vector243>:
.globl vector243
vector243:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $243
80106bed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bf2:	e9 33 f1 ff ff       	jmp    80105d2a <alltraps>

80106bf7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $244
80106bf9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bfe:	e9 27 f1 ff ff       	jmp    80105d2a <alltraps>

80106c03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $245
80106c05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c0a:	e9 1b f1 ff ff       	jmp    80105d2a <alltraps>

80106c0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $246
80106c11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c16:	e9 0f f1 ff ff       	jmp    80105d2a <alltraps>

80106c1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $247
80106c1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c22:	e9 03 f1 ff ff       	jmp    80105d2a <alltraps>

80106c27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $248
80106c29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c2e:	e9 f7 f0 ff ff       	jmp    80105d2a <alltraps>

80106c33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $249
80106c35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c3a:	e9 eb f0 ff ff       	jmp    80105d2a <alltraps>

80106c3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $250
80106c41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c46:	e9 df f0 ff ff       	jmp    80105d2a <alltraps>

80106c4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $251
80106c4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c52:	e9 d3 f0 ff ff       	jmp    80105d2a <alltraps>

80106c57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $252
80106c59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c5e:	e9 c7 f0 ff ff       	jmp    80105d2a <alltraps>

80106c63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $253
80106c65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c6a:	e9 bb f0 ff ff       	jmp    80105d2a <alltraps>

80106c6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $254
80106c71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c76:	e9 af f0 ff ff       	jmp    80105d2a <alltraps>

80106c7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $255
80106c7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c82:	e9 a3 f0 ff ff       	jmp    80105d2a <alltraps>
80106c87:	66 90                	xchg   %ax,%ax
80106c89:	66 90                	xchg   %ax,%ax
80106c8b:	66 90                	xchg   %ax,%ax
80106c8d:	66 90                	xchg   %ax,%ax
80106c8f:	90                   	nop

80106c90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106ca5:	39 d3                	cmp    %edx,%ebx
80106ca7:	73 56                	jae    80106cff <deallocuvm.part.0+0x6f>
80106ca9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106cac:	89 c6                	mov    %eax,%esi
80106cae:	89 d7                	mov    %edx,%edi
80106cb0:	eb 12                	jmp    80106cc4 <deallocuvm.part.0+0x34>
80106cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cb8:	83 c2 01             	add    $0x1,%edx
80106cbb:	89 d3                	mov    %edx,%ebx
80106cbd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cc0:	39 fb                	cmp    %edi,%ebx
80106cc2:	73 38                	jae    80106cfc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106cc4:	89 da                	mov    %ebx,%edx
80106cc6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106cc9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106ccc:	a8 01                	test   $0x1,%al
80106cce:	74 e8                	je     80106cb8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106cd0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cd7:	c1 e9 0a             	shr    $0xa,%ecx
80106cda:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106ce0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106ce7:	85 c0                	test   %eax,%eax
80106ce9:	74 cd                	je     80106cb8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106ceb:	8b 10                	mov    (%eax),%edx
80106ced:	f6 c2 01             	test   $0x1,%dl
80106cf0:	75 1e                	jne    80106d10 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106cf2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cf8:	39 fb                	cmp    %edi,%ebx
80106cfa:	72 c8                	jb     80106cc4 <deallocuvm.part.0+0x34>
80106cfc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d02:	89 c8                	mov    %ecx,%eax
80106d04:	5b                   	pop    %ebx
80106d05:	5e                   	pop    %esi
80106d06:	5f                   	pop    %edi
80106d07:	5d                   	pop    %ebp
80106d08:	c3                   	ret
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106d10:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d16:	74 26                	je     80106d3e <deallocuvm.part.0+0xae>
      kfree(v);
80106d18:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d1b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d24:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d2a:	52                   	push   %edx
80106d2b:	e8 60 bc ff ff       	call   80102990 <kfree>
      *pte = 0;
80106d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106d33:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106d3c:	eb 82                	jmp    80106cc0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106d3e:	83 ec 0c             	sub    $0xc,%esp
80106d41:	68 2c 78 10 80       	push   $0x8010782c
80106d46:	e8 25 96 ff ff       	call   80100370 <panic>
80106d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d50 <mappages>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d56:	89 d3                	mov    %edx,%ebx
80106d58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d5e:	83 ec 1c             	sub    $0x1c,%esp
80106d61:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d70:	8b 45 08             	mov    0x8(%ebp),%eax
80106d73:	29 d8                	sub    %ebx,%eax
80106d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d78:	eb 3f                	jmp    80106db9 <mappages+0x69>
80106d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d80:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d87:	c1 ea 0a             	shr    $0xa,%edx
80106d8a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d90:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d97:	85 c0                	test   %eax,%eax
80106d99:	74 75                	je     80106e10 <mappages+0xc0>
    if(*pte & PTE_P)
80106d9b:	f6 00 01             	testb  $0x1,(%eax)
80106d9e:	0f 85 86 00 00 00    	jne    80106e2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106da4:	0b 75 0c             	or     0xc(%ebp),%esi
80106da7:	83 ce 01             	or     $0x1,%esi
80106daa:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dac:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106daf:	39 c3                	cmp    %eax,%ebx
80106db1:	74 6d                	je     80106e20 <mappages+0xd0>
    a += PGSIZE;
80106db3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106dbc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106dbf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106dc2:	89 d8                	mov    %ebx,%eax
80106dc4:	c1 e8 16             	shr    $0x16,%eax
80106dc7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106dca:	8b 07                	mov    (%edi),%eax
80106dcc:	a8 01                	test   $0x1,%al
80106dce:	75 b0                	jne    80106d80 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dd0:	e8 7b bd ff ff       	call   80102b50 <kalloc>
80106dd5:	85 c0                	test   %eax,%eax
80106dd7:	74 37                	je     80106e10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dd9:	83 ec 04             	sub    $0x4,%esp
80106ddc:	68 00 10 00 00       	push   $0x1000
80106de1:	6a 00                	push   $0x0
80106de3:	50                   	push   %eax
80106de4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106de7:	e8 a4 dd ff ff       	call   80104b90 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dec:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106def:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106df2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106df8:	83 c8 07             	or     $0x7,%eax
80106dfb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106dfd:	89 d8                	mov    %ebx,%eax
80106dff:	c1 e8 0a             	shr    $0xa,%eax
80106e02:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e07:	01 d0                	add    %edx,%eax
80106e09:	eb 90                	jmp    80106d9b <mappages+0x4b>
80106e0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e18:	5b                   	pop    %ebx
80106e19:	5e                   	pop    %esi
80106e1a:	5f                   	pop    %edi
80106e1b:	5d                   	pop    %ebp
80106e1c:	c3                   	ret
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret
      panic("remap");
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 60 7a 10 80       	push   $0x80107a60
80106e32:	e8 39 95 ff ff       	call   80100370 <panic>
80106e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e3e:	00 
80106e3f:	90                   	nop

80106e40 <seginit>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e46:	e8 e5 cf ff ff       	call   80103e30 <cpuid>
  pd[0] = size-1;
80106e4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106e5a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e61:	ff 00 00 
80106e64:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e6e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e75:	ff 00 00 
80106e78:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e82:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e89:	ff 00 00 
80106e8c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e96:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e9d:	ff 00 00 
80106ea0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106ea7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eaa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106eaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106eb3:	c1 e8 10             	shr    $0x10,%eax
80106eb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ebd:	0f 01 10             	lgdtl  (%eax)
}
80106ec0:	c9                   	leave
80106ec1:	c3                   	ret
80106ec2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ec9:	00 
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ed0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ed0:	a1 c4 54 11 80       	mov    0x801154c4,%eax
80106ed5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eda:	0f 22 d8             	mov    %eax,%cr3
}
80106edd:	c3                   	ret
80106ede:	66 90                	xchg   %ax,%ax

80106ee0 <switchuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 1c             	sub    $0x1c,%esp
80106ee9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106eec:	85 f6                	test   %esi,%esi
80106eee:	0f 84 cb 00 00 00    	je     80106fbf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ef4:	8b 46 08             	mov    0x8(%esi),%eax
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	0f 84 da 00 00 00    	je     80106fd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eff:	8b 46 04             	mov    0x4(%esi),%eax
80106f02:	85 c0                	test   %eax,%eax
80106f04:	0f 84 c2 00 00 00    	je     80106fcc <switchuvm+0xec>
  pushcli();
80106f0a:	e8 31 da ff ff       	call   80104940 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f0f:	e8 bc ce ff ff       	call   80103dd0 <mycpu>
80106f14:	89 c3                	mov    %eax,%ebx
80106f16:	e8 b5 ce ff ff       	call   80103dd0 <mycpu>
80106f1b:	89 c7                	mov    %eax,%edi
80106f1d:	e8 ae ce ff ff       	call   80103dd0 <mycpu>
80106f22:	83 c7 08             	add    $0x8,%edi
80106f25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f28:	e8 a3 ce ff ff       	call   80103dd0 <mycpu>
80106f2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f30:	ba 67 00 00 00       	mov    $0x67,%edx
80106f35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f3c:	83 c0 08             	add    $0x8,%eax
80106f3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f4b:	83 c1 08             	add    $0x8,%ecx
80106f4e:	c1 e8 18             	shr    $0x18,%eax
80106f51:	c1 e9 10             	shr    $0x10,%ecx
80106f54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f71:	e8 5a ce ff ff       	call   80103dd0 <mycpu>
80106f76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f7d:	e8 4e ce ff ff       	call   80103dd0 <mycpu>
80106f82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f86:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f8f:	e8 3c ce ff ff       	call   80103dd0 <mycpu>
80106f94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f97:	e8 34 ce ff ff       	call   80103dd0 <mycpu>
80106f9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fa0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fa5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fa8:	8b 46 04             	mov    0x4(%esi),%eax
80106fab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fb0:	0f 22 d8             	mov    %eax,%cr3
}
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	5b                   	pop    %ebx
80106fb7:	5e                   	pop    %esi
80106fb8:	5f                   	pop    %edi
80106fb9:	5d                   	pop    %ebp
  popcli();
80106fba:	e9 d1 d9 ff ff       	jmp    80104990 <popcli>
    panic("switchuvm: no process");
80106fbf:	83 ec 0c             	sub    $0xc,%esp
80106fc2:	68 66 7a 10 80       	push   $0x80107a66
80106fc7:	e8 a4 93 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
80106fcc:	83 ec 0c             	sub    $0xc,%esp
80106fcf:	68 91 7a 10 80       	push   $0x80107a91
80106fd4:	e8 97 93 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
80106fd9:	83 ec 0c             	sub    $0xc,%esp
80106fdc:	68 7c 7a 10 80       	push   $0x80107a7c
80106fe1:	e8 8a 93 ff ff       	call   80100370 <panic>
80106fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fed:	00 
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <inituvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffc:	8b 75 10             	mov    0x10(%ebp),%esi
80106fff:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107002:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107005:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010700b:	77 49                	ja     80107056 <inituvm+0x66>
  mem = kalloc();
8010700d:	e8 3e bb ff ff       	call   80102b50 <kalloc>
  memset(mem, 0, PGSIZE);
80107012:	83 ec 04             	sub    $0x4,%esp
80107015:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010701a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010701c:	6a 00                	push   $0x0
8010701e:	50                   	push   %eax
8010701f:	e8 6c db ff ff       	call   80104b90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107024:	58                   	pop    %eax
80107025:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010702b:	5a                   	pop    %edx
8010702c:	6a 06                	push   $0x6
8010702e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107033:	31 d2                	xor    %edx,%edx
80107035:	50                   	push   %eax
80107036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107039:	e8 12 fd ff ff       	call   80106d50 <mappages>
  memmove(mem, init, sz);
8010703e:	83 c4 10             	add    $0x10,%esp
80107041:	89 75 10             	mov    %esi,0x10(%ebp)
80107044:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107047:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010704a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704d:	5b                   	pop    %ebx
8010704e:	5e                   	pop    %esi
8010704f:	5f                   	pop    %edi
80107050:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107051:	e9 ca db ff ff       	jmp    80104c20 <memmove>
    panic("inituvm: more than a page");
80107056:	83 ec 0c             	sub    $0xc,%esp
80107059:	68 a5 7a 10 80       	push   $0x80107aa5
8010705e:	e8 0d 93 ff ff       	call   80100370 <panic>
80107063:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010706a:	00 
8010706b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107070 <loaduvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107079:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010707c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010707f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107085:	0f 85 a2 00 00 00    	jne    8010712d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010708b:	85 ff                	test   %edi,%edi
8010708d:	74 7d                	je     8010710c <loaduvm+0x9c>
8010708f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107090:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107093:	8b 55 08             	mov    0x8(%ebp),%edx
80107096:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107098:	89 c1                	mov    %eax,%ecx
8010709a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010709d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801070a0:	f6 c1 01             	test   $0x1,%cl
801070a3:	75 13                	jne    801070b8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801070a5:	83 ec 0c             	sub    $0xc,%esp
801070a8:	68 bf 7a 10 80       	push   $0x80107abf
801070ad:	e8 be 92 ff ff       	call   80100370 <panic>
801070b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070b8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070bb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070c1:	25 fc 0f 00 00       	and    $0xffc,%eax
801070c6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070cd:	85 c9                	test   %ecx,%ecx
801070cf:	74 d4                	je     801070a5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801070d1:	89 fb                	mov    %edi,%ebx
801070d3:	b8 00 10 00 00       	mov    $0x1000,%eax
801070d8:	29 f3                	sub    %esi,%ebx
801070da:	39 c3                	cmp    %eax,%ebx
801070dc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070df:	53                   	push   %ebx
801070e0:	8b 45 14             	mov    0x14(%ebp),%eax
801070e3:	01 f0                	add    %esi,%eax
801070e5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801070e6:	8b 01                	mov    (%ecx),%eax
801070e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ed:	05 00 00 00 80       	add    $0x80000000,%eax
801070f2:	50                   	push   %eax
801070f3:	ff 75 10             	push   0x10(%ebp)
801070f6:	e8 a5 ae ff ff       	call   80101fa0 <readi>
801070fb:	83 c4 10             	add    $0x10,%esp
801070fe:	39 d8                	cmp    %ebx,%eax
80107100:	75 1e                	jne    80107120 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107102:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107108:	39 fe                	cmp    %edi,%esi
8010710a:	72 84                	jb     80107090 <loaduvm+0x20>
}
8010710c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010710f:	31 c0                	xor    %eax,%eax
}
80107111:	5b                   	pop    %ebx
80107112:	5e                   	pop    %esi
80107113:	5f                   	pop    %edi
80107114:	5d                   	pop    %ebp
80107115:	c3                   	ret
80107116:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010711d:	00 
8010711e:	66 90                	xchg   %ax,%ax
80107120:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107123:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107128:	5b                   	pop    %ebx
80107129:	5e                   	pop    %esi
8010712a:	5f                   	pop    %edi
8010712b:	5d                   	pop    %ebp
8010712c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010712d:	83 ec 0c             	sub    $0xc,%esp
80107130:	68 38 7d 10 80       	push   $0x80107d38
80107135:	e8 36 92 ff ff       	call   80100370 <panic>
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107140 <allocuvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010714c:	85 f6                	test   %esi,%esi
8010714e:	0f 88 98 00 00 00    	js     801071ec <allocuvm+0xac>
80107154:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107156:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107159:	0f 82 a1 00 00 00    	jb     80107200 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010715f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107162:	05 ff 0f 00 00       	add    $0xfff,%eax
80107167:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010716c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010716e:	39 f0                	cmp    %esi,%eax
80107170:	0f 83 8d 00 00 00    	jae    80107203 <allocuvm+0xc3>
80107176:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107179:	eb 44                	jmp    801071bf <allocuvm+0x7f>
8010717b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107180:	83 ec 04             	sub    $0x4,%esp
80107183:	68 00 10 00 00       	push   $0x1000
80107188:	6a 00                	push   $0x0
8010718a:	50                   	push   %eax
8010718b:	e8 00 da ff ff       	call   80104b90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107190:	58                   	pop    %eax
80107191:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107197:	5a                   	pop    %edx
80107198:	6a 06                	push   $0x6
8010719a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010719f:	89 fa                	mov    %edi,%edx
801071a1:	50                   	push   %eax
801071a2:	8b 45 08             	mov    0x8(%ebp),%eax
801071a5:	e8 a6 fb ff ff       	call   80106d50 <mappages>
801071aa:	83 c4 10             	add    $0x10,%esp
801071ad:	85 c0                	test   %eax,%eax
801071af:	78 5f                	js     80107210 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801071b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071b7:	39 f7                	cmp    %esi,%edi
801071b9:	0f 83 89 00 00 00    	jae    80107248 <allocuvm+0x108>
    mem = kalloc();
801071bf:	e8 8c b9 ff ff       	call   80102b50 <kalloc>
801071c4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071c6:	85 c0                	test   %eax,%eax
801071c8:	75 b6                	jne    80107180 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071ca:	83 ec 0c             	sub    $0xc,%esp
801071cd:	68 dd 7a 10 80       	push   $0x80107add
801071d2:	e8 89 95 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
801071d7:	83 c4 10             	add    $0x10,%esp
801071da:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071dd:	74 0d                	je     801071ec <allocuvm+0xac>
801071df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071e2:	8b 45 08             	mov    0x8(%ebp),%eax
801071e5:	89 f2                	mov    %esi,%edx
801071e7:	e8 a4 fa ff ff       	call   80106c90 <deallocuvm.part.0>
    return 0;
801071ec:	31 d2                	xor    %edx,%edx
}
801071ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f1:	89 d0                	mov    %edx,%eax
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5f                   	pop    %edi
801071f6:	5d                   	pop    %ebp
801071f7:	c3                   	ret
801071f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ff:	00 
    return oldsz;
80107200:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107206:	89 d0                	mov    %edx,%eax
80107208:	5b                   	pop    %ebx
80107209:	5e                   	pop    %esi
8010720a:	5f                   	pop    %edi
8010720b:	5d                   	pop    %ebp
8010720c:	c3                   	ret
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107210:	83 ec 0c             	sub    $0xc,%esp
80107213:	68 f5 7a 10 80       	push   $0x80107af5
80107218:	e8 43 95 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
8010721d:	83 c4 10             	add    $0x10,%esp
80107220:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107223:	74 0d                	je     80107232 <allocuvm+0xf2>
80107225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107228:	8b 45 08             	mov    0x8(%ebp),%eax
8010722b:	89 f2                	mov    %esi,%edx
8010722d:	e8 5e fa ff ff       	call   80106c90 <deallocuvm.part.0>
      kfree(mem);
80107232:	83 ec 0c             	sub    $0xc,%esp
80107235:	53                   	push   %ebx
80107236:	e8 55 b7 ff ff       	call   80102990 <kfree>
      return 0;
8010723b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010723e:	31 d2                	xor    %edx,%edx
80107240:	eb ac                	jmp    801071ee <allocuvm+0xae>
80107242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107248:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010724b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724e:	5b                   	pop    %ebx
8010724f:	5e                   	pop    %esi
80107250:	89 d0                	mov    %edx,%eax
80107252:	5f                   	pop    %edi
80107253:	5d                   	pop    %ebp
80107254:	c3                   	ret
80107255:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010725c:	00 
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <deallocuvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	8b 55 0c             	mov    0xc(%ebp),%edx
80107266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107269:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010726c:	39 d1                	cmp    %edx,%ecx
8010726e:	73 10                	jae    80107280 <deallocuvm+0x20>
}
80107270:	5d                   	pop    %ebp
80107271:	e9 1a fa ff ff       	jmp    80106c90 <deallocuvm.part.0>
80107276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727d:	00 
8010727e:	66 90                	xchg   %ax,%ax
80107280:	89 d0                	mov    %edx,%eax
80107282:	5d                   	pop    %ebp
80107283:	c3                   	ret
80107284:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010728b:	00 
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010729c:	85 f6                	test   %esi,%esi
8010729e:	74 59                	je     801072f9 <freevm+0x69>
  if(newsz >= oldsz)
801072a0:	31 c9                	xor    %ecx,%ecx
801072a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072a7:	89 f0                	mov    %esi,%eax
801072a9:	89 f3                	mov    %esi,%ebx
801072ab:	e8 e0 f9 ff ff       	call   80106c90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072b6:	eb 0f                	jmp    801072c7 <freevm+0x37>
801072b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072bf:	00 
801072c0:	83 c3 04             	add    $0x4,%ebx
801072c3:	39 fb                	cmp    %edi,%ebx
801072c5:	74 23                	je     801072ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072c7:	8b 03                	mov    (%ebx),%eax
801072c9:	a8 01                	test   $0x1,%al
801072cb:	74 f3                	je     801072c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072dd:	50                   	push   %eax
801072de:	e8 ad b6 ff ff       	call   80102990 <kfree>
801072e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072e6:	39 fb                	cmp    %edi,%ebx
801072e8:	75 dd                	jne    801072c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f0:	5b                   	pop    %ebx
801072f1:	5e                   	pop    %esi
801072f2:	5f                   	pop    %edi
801072f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072f4:	e9 97 b6 ff ff       	jmp    80102990 <kfree>
    panic("freevm: no pgdir");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 11 7b 10 80       	push   $0x80107b11
80107301:	e8 6a 90 ff ff       	call   80100370 <panic>
80107306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010730d:	00 
8010730e:	66 90                	xchg   %ax,%ax

80107310 <setupkvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	56                   	push   %esi
80107314:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107315:	e8 36 b8 ff ff       	call   80102b50 <kalloc>
8010731a:	85 c0                	test   %eax,%eax
8010731c:	74 5e                	je     8010737c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010731e:	83 ec 04             	sub    $0x4,%esp
80107321:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107323:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107328:	68 00 10 00 00       	push   $0x1000
8010732d:	6a 00                	push   $0x0
8010732f:	50                   	push   %eax
80107330:	e8 5b d8 ff ff       	call   80104b90 <memset>
80107335:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107338:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010733b:	83 ec 08             	sub    $0x8,%esp
8010733e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107341:	8b 13                	mov    (%ebx),%edx
80107343:	ff 73 0c             	push   0xc(%ebx)
80107346:	50                   	push   %eax
80107347:	29 c1                	sub    %eax,%ecx
80107349:	89 f0                	mov    %esi,%eax
8010734b:	e8 00 fa ff ff       	call   80106d50 <mappages>
80107350:	83 c4 10             	add    $0x10,%esp
80107353:	85 c0                	test   %eax,%eax
80107355:	78 19                	js     80107370 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107357:	83 c3 10             	add    $0x10,%ebx
8010735a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107360:	75 d6                	jne    80107338 <setupkvm+0x28>
}
80107362:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107365:	89 f0                	mov    %esi,%eax
80107367:	5b                   	pop    %ebx
80107368:	5e                   	pop    %esi
80107369:	5d                   	pop    %ebp
8010736a:	c3                   	ret
8010736b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	56                   	push   %esi
80107374:	e8 17 ff ff ff       	call   80107290 <freevm>
      return 0;
80107379:	83 c4 10             	add    $0x10,%esp
}
8010737c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010737f:	31 f6                	xor    %esi,%esi
}
80107381:	89 f0                	mov    %esi,%eax
80107383:	5b                   	pop    %ebx
80107384:	5e                   	pop    %esi
80107385:	5d                   	pop    %ebp
80107386:	c3                   	ret
80107387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010738e:	00 
8010738f:	90                   	nop

80107390 <kvmalloc>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107396:	e8 75 ff ff ff       	call   80107310 <setupkvm>
8010739b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073a0:	05 00 00 00 80       	add    $0x80000000,%eax
801073a5:	0f 22 d8             	mov    %eax,%cr3
}
801073a8:	c9                   	leave
801073a9:	c3                   	ret
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	83 ec 08             	sub    $0x8,%esp
801073b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073bc:	89 c1                	mov    %eax,%ecx
801073be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c4:	f6 c2 01             	test   $0x1,%dl
801073c7:	75 17                	jne    801073e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073c9:	83 ec 0c             	sub    $0xc,%esp
801073cc:	68 22 7b 10 80       	push   $0x80107b22
801073d1:	e8 9a 8f ff ff       	call   80100370 <panic>
801073d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073dd:	00 
801073de:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801073e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073f5:	85 c0                	test   %eax,%eax
801073f7:	74 d0                	je     801073c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073fc:	c9                   	leave
801073fd:	c3                   	ret
801073fe:	66 90                	xchg   %ax,%ax

80107400 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107409:	e8 02 ff ff ff       	call   80107310 <setupkvm>
8010740e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107411:	85 c0                	test   %eax,%eax
80107413:	0f 84 e9 00 00 00    	je     80107502 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107419:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010741c:	85 c9                	test   %ecx,%ecx
8010741e:	0f 84 b2 00 00 00    	je     801074d6 <copyuvm+0xd6>
80107424:	31 f6                	xor    %esi,%esi
80107426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010742d:	00 
8010742e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107430:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107433:	89 f0                	mov    %esi,%eax
80107435:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107438:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010743b:	a8 01                	test   $0x1,%al
8010743d:	75 11                	jne    80107450 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010743f:	83 ec 0c             	sub    $0xc,%esp
80107442:	68 2c 7b 10 80       	push   $0x80107b2c
80107447:	e8 24 8f ff ff       	call   80100370 <panic>
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107450:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107457:	c1 ea 0a             	shr    $0xa,%edx
8010745a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107460:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107467:	85 c0                	test   %eax,%eax
80107469:	74 d4                	je     8010743f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010746b:	8b 00                	mov    (%eax),%eax
8010746d:	a8 01                	test   $0x1,%al
8010746f:	0f 84 9f 00 00 00    	je     80107514 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107475:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107477:	25 ff 0f 00 00       	and    $0xfff,%eax
8010747c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010747f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107485:	e8 c6 b6 ff ff       	call   80102b50 <kalloc>
8010748a:	89 c3                	mov    %eax,%ebx
8010748c:	85 c0                	test   %eax,%eax
8010748e:	74 64                	je     801074f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107490:	83 ec 04             	sub    $0x4,%esp
80107493:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107499:	68 00 10 00 00       	push   $0x1000
8010749e:	57                   	push   %edi
8010749f:	50                   	push   %eax
801074a0:	e8 7b d7 ff ff       	call   80104c20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801074a5:	58                   	pop    %eax
801074a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074ac:	5a                   	pop    %edx
801074ad:	ff 75 e4             	push   -0x1c(%ebp)
801074b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074b5:	89 f2                	mov    %esi,%edx
801074b7:	50                   	push   %eax
801074b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074bb:	e8 90 f8 ff ff       	call   80106d50 <mappages>
801074c0:	83 c4 10             	add    $0x10,%esp
801074c3:	85 c0                	test   %eax,%eax
801074c5:	78 21                	js     801074e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074cd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801074d0:	0f 82 5a ff ff ff    	jb     80107430 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074dc:	5b                   	pop    %ebx
801074dd:	5e                   	pop    %esi
801074de:	5f                   	pop    %edi
801074df:	5d                   	pop    %ebp
801074e0:	c3                   	ret
801074e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074e8:	83 ec 0c             	sub    $0xc,%esp
801074eb:	53                   	push   %ebx
801074ec:	e8 9f b4 ff ff       	call   80102990 <kfree>
      goto bad;
801074f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074f4:	83 ec 0c             	sub    $0xc,%esp
801074f7:	ff 75 e0             	push   -0x20(%ebp)
801074fa:	e8 91 fd ff ff       	call   80107290 <freevm>
  return 0;
801074ff:	83 c4 10             	add    $0x10,%esp
    return 0;
80107502:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107509:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010750c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010750f:	5b                   	pop    %ebx
80107510:	5e                   	pop    %esi
80107511:	5f                   	pop    %edi
80107512:	5d                   	pop    %ebp
80107513:	c3                   	ret
      panic("copyuvm: page not present");
80107514:	83 ec 0c             	sub    $0xc,%esp
80107517:	68 46 7b 10 80       	push   $0x80107b46
8010751c:	e8 4f 8e ff ff       	call   80100370 <panic>
80107521:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107528:	00 
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107530 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107536:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107539:	89 c1                	mov    %eax,%ecx
8010753b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010753e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107541:	f6 c2 01             	test   $0x1,%dl
80107544:	0f 84 f8 00 00 00    	je     80107642 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010754a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010754d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107553:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107554:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107559:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107560:	89 d0                	mov    %edx,%eax
80107562:	f7 d2                	not    %edx
80107564:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107569:	05 00 00 00 80       	add    $0x80000000,%eax
8010756e:	83 e2 05             	and    $0x5,%edx
80107571:	ba 00 00 00 00       	mov    $0x0,%edx
80107576:	0f 45 c2             	cmovne %edx,%eax
}
80107579:	c3                   	ret
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107580 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 0c             	sub    $0xc,%esp
80107589:	8b 75 14             	mov    0x14(%ebp),%esi
8010758c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010758f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107592:	85 f6                	test   %esi,%esi
80107594:	75 51                	jne    801075e7 <copyout+0x67>
80107596:	e9 9d 00 00 00       	jmp    80107638 <copyout+0xb8>
8010759b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801075a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801075ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075b2:	74 74                	je     80107628 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801075b4:	89 fb                	mov    %edi,%ebx
801075b6:	29 c3                	sub    %eax,%ebx
801075b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801075be:	39 f3                	cmp    %esi,%ebx
801075c0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075c3:	29 f8                	sub    %edi,%eax
801075c5:	83 ec 04             	sub    $0x4,%esp
801075c8:	01 c1                	add    %eax,%ecx
801075ca:	53                   	push   %ebx
801075cb:	52                   	push   %edx
801075cc:	89 55 10             	mov    %edx,0x10(%ebp)
801075cf:	51                   	push   %ecx
801075d0:	e8 4b d6 ff ff       	call   80104c20 <memmove>
    len -= n;
    buf += n;
801075d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801075e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801075e3:	29 de                	sub    %ebx,%esi
801075e5:	74 51                	je     80107638 <copyout+0xb8>
  if(*pde & PTE_P){
801075e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801075ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801075ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801075f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801075fa:	f6 c1 01             	test   $0x1,%cl
801075fd:	0f 84 46 00 00 00    	je     80107649 <copyout.cold>
  return &pgtab[PTX(va)];
80107603:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107605:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010760b:	c1 eb 0c             	shr    $0xc,%ebx
8010760e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107614:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010761b:	89 d9                	mov    %ebx,%ecx
8010761d:	f7 d1                	not    %ecx
8010761f:	83 e1 05             	and    $0x5,%ecx
80107622:	0f 84 78 ff ff ff    	je     801075a0 <copyout+0x20>
  }
  return 0;
}
80107628:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010762b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107630:	5b                   	pop    %ebx
80107631:	5e                   	pop    %esi
80107632:	5f                   	pop    %edi
80107633:	5d                   	pop    %ebp
80107634:	c3                   	ret
80107635:	8d 76 00             	lea    0x0(%esi),%esi
80107638:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010763b:	31 c0                	xor    %eax,%eax
}
8010763d:	5b                   	pop    %ebx
8010763e:	5e                   	pop    %esi
8010763f:	5f                   	pop    %edi
80107640:	5d                   	pop    %ebp
80107641:	c3                   	ret

80107642 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107642:	a1 00 00 00 00       	mov    0x0,%eax
80107647:	0f 0b                	ud2

80107649 <copyout.cold>:
80107649:	a1 00 00 00 00       	mov    0x0,%eax
8010764e:	0f 0b                	ud2
