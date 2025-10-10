
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
8010002d:	b8 10 35 10 80       	mov    $0x80103510,%eax
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
8010004c:	68 40 76 10 80       	push   $0x80107640
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 35 48 00 00       	call   80104890 <initlock>
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
80100092:	68 47 76 10 80       	push   $0x80107647
80100097:	50                   	push   %eax
80100098:	e8 c3 46 00 00       	call   80104760 <initsleeplock>
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
801000e4:	e8 97 49 00 00       	call   80104a80 <acquire>
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
80100162:	e8 b9 48 00 00       	call   80104a20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 46 00 00       	call   801047a0 <acquiresleep>
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
8010018c:	e8 1f 26 00 00       	call   801027b0 <iderw>
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
801001a1:	68 4e 76 10 80       	push   $0x8010764e
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
801001be:	e8 7d 46 00 00       	call   80104840 <holdingsleep>
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
801001d4:	e9 d7 25 00 00       	jmp    801027b0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 76 10 80       	push   $0x8010765f
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
801001ff:	e8 3c 46 00 00       	call   80104840 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 45 00 00       	call   80104800 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 60 48 00 00       	call   80104a80 <acquire>
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
80100269:	e9 b2 47 00 00       	jmp    80104a20 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 76 10 80       	push   $0x80107666
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
80100290:	e8 cb 1a 00 00       	call   80101d60 <iunlock>
  target = n;
  acquire(&cons.lock);
80100295:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010029c:	e8 df 47 00 00       	call   80104a80 <acquire>
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
801002cd:	e8 2e 42 00 00       	call   80104500 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 59 3b 00 00       	call   80103e40 <myproc>
801002e7:	8b 40 24             	mov    0x24(%eax),%eax
801002ea:	85 c0                	test   %eax,%eax
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 25 47 00 00       	call   80104a20 <release>
        ilock(ip);
801002fb:	89 3c 24             	mov    %edi,(%esp)
801002fe:	e8 7d 19 00 00       	call   80101c80 <ilock>
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
80100344:	e8 d7 46 00 00       	call   80104a20 <release>
  ilock(ip);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 2f 19 00 00       	call   80101c80 <ilock>
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
80100389:	e8 22 2a 00 00       	call   80102db0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 76 10 80       	push   $0x8010766d
80100397:	e8 b4 03 00 00       	call   80100750 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	push   0x8(%ebp)
801003a0:	e8 ab 03 00 00       	call   80100750 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 ef 7a 10 80 	movl   $0x80107aef,(%esp)
801003ac:	e8 9f 03 00 00       	call   80100750 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	8d 45 08             	lea    0x8(%ebp),%eax
801003b4:	5a                   	pop    %edx
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 f3 44 00 00       	call   801048b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003c8:	68 81 76 10 80       	push   $0x80107681
801003cd:	e8 7e 03 00 00       	call   80100750 <cprintf>
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
801003fe:	0f 84 4c 01 00 00    	je     80100550 <consputc.part.0+0x160>
80100404:	89 c6                	mov    %eax,%esi
  else if(c == KEY_LF){
80100406:	3d e4 00 00 00       	cmp    $0xe4,%eax
8010040b:	0f 84 ef 01 00 00    	je     80100600 <consputc.part.0+0x210>
  else if(c == KEY_RT){
80100411:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100416:	0f 84 d4 00 00 00    	je     801004f0 <consputc.part.0+0x100>
    uartputc(c);
8010041c:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041f:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100424:	50                   	push   %eax
80100425:	e8 66 5d 00 00       	call   80106190 <uartputc>
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
80100456:	0f 85 74 01 00 00    	jne    801005d0 <consputc.part.0+0x1e0>
    pos += 80 - pos%80;
8010045c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100461:	f7 e2                	mul    %edx
80100463:	c1 ea 06             	shr    $0x6,%edx
80100466:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100469:	c1 e0 04             	shl    $0x4,%eax
8010046c:	8d 58 50             	lea    0x50(%eax),%ebx
  if(pos < 0 || pos > 25*80)
8010046f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100475:	0f 8f c7 01 00 00    	jg     80100642 <consputc.part.0+0x252>
  outb(CRTPORT+1, pos>>8);
8010047b:	0f b6 f7             	movzbl %bh,%esi
  if((pos/80) >= 24){
8010047e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100484:	7e 3e                	jle    801004c4 <consputc.part.0+0xd4>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100486:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100489:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT+1, pos);
8010048c:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100491:	68 60 0e 00 00       	push   $0xe60
80100496:	68 a0 80 0b 80       	push   $0x800b80a0
8010049b:	68 00 80 0b 80       	push   $0x800b8000
801004a0:	e8 6b 47 00 00       	call   80104c10 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004a5:	b8 80 07 00 00       	mov    $0x780,%eax
801004aa:	83 c4 0c             	add    $0xc,%esp
801004ad:	29 d8                	sub    %ebx,%eax
801004af:	01 c0                	add    %eax,%eax
801004b1:	50                   	push   %eax
801004b2:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801004b9:	6a 00                	push   $0x0
801004bb:	50                   	push   %eax
801004bc:	e8 bf 46 00 00       	call   80104b80 <memset>
  outb(CRTPORT+1, pos);
801004c1:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004c4:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004c9:	b8 0e 00 00 00       	mov    $0xe,%eax
801004ce:	89 fa                	mov    %edi,%edx
801004d0:	ee                   	out    %al,(%dx)
801004d1:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004d6:	89 f0                	mov    %esi,%eax
801004d8:	89 ca                	mov    %ecx,%edx
801004da:	ee                   	out    %al,(%dx)
801004db:	b8 0f 00 00 00       	mov    $0xf,%eax
801004e0:	89 fa                	mov    %edi,%edx
801004e2:	ee                   	out    %al,(%dx)
801004e3:	89 d8                	mov    %ebx,%eax
801004e5:	89 ca                	mov    %ecx,%edx
801004e7:	ee                   	out    %al,(%dx)
}
801004e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004eb:	5b                   	pop    %ebx
801004ec:	5e                   	pop    %esi
801004ed:	5f                   	pop    %edi
801004ee:	5d                   	pop    %ebp
801004ef:	c3                   	ret
    uartputc(k);
801004f0:	83 ec 0c             	sub    $0xc,%esp
801004f3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004f8:	52                   	push   %edx
801004f9:	e8 92 5c 00 00       	call   80106190 <uartputc>
801004fe:	b8 0e 00 00 00       	mov    $0xe,%eax
80100503:	89 f2                	mov    %esi,%edx
80100505:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100506:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010050b:	89 da                	mov    %ebx,%edx
8010050d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010050e:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100511:	89 f2                	mov    %esi,%edx
80100513:	b8 0f 00 00 00       	mov    $0xf,%eax
80100518:	c1 e1 08             	shl    $0x8,%ecx
8010051b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010051c:	89 da                	mov    %ebx,%edx
8010051e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010051f:	0f b6 d8             	movzbl %al,%ebx
    if(pos % 80 < 79)
80100522:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80100527:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010052a:	09 cb                	or     %ecx,%ebx
    if(pos % 80 < 79)
8010052c:	f7 e3                	mul    %ebx
8010052e:	c1 ea 06             	shr    $0x6,%edx
80100531:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100534:	89 da                	mov    %ebx,%edx
80100536:	c1 e0 04             	shl    $0x4,%eax
80100539:	29 c2                	sub    %eax,%edx
      ++pos;
8010053b:	31 c0                	xor    %eax,%eax
8010053d:	83 fa 4f             	cmp    $0x4f,%edx
80100540:	0f 95 c0             	setne  %al
80100543:	01 c3                	add    %eax,%ebx
80100545:	e9 25 ff ff ff       	jmp    8010046f <consputc.part.0+0x7f>
8010054a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100550:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100553:	be d4 03 00 00       	mov    $0x3d4,%esi
80100558:	6a 08                	push   $0x8
8010055a:	e8 31 5c 00 00       	call   80106190 <uartputc>
8010055f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100566:	e8 25 5c 00 00       	call   80106190 <uartputc>
8010056b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100572:	e8 19 5c 00 00       	call   80106190 <uartputc>
80100577:	b8 0e 00 00 00       	mov    $0xe,%eax
8010057c:	89 f2                	mov    %esi,%edx
8010057e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010057f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100584:	89 da                	mov    %ebx,%edx
80100586:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100587:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010058a:	89 f2                	mov    %esi,%edx
8010058c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100591:	c1 e1 08             	shl    $0x8,%ecx
80100594:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100595:	89 da                	mov    %ebx,%edx
80100597:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100598:	0f b6 d8             	movzbl %al,%ebx
    if(pos > 0){
8010059b:	83 c4 10             	add    $0x10,%esp
8010059e:	09 cb                	or     %ecx,%ebx
801005a0:	74 1e                	je     801005c0 <consputc.part.0+0x1d0>
      --pos;
801005a2:	83 eb 01             	sub    $0x1,%ebx
      crt[pos] = ' ' | 0x0700;
801005a5:	b9 20 07 00 00       	mov    $0x720,%ecx
801005aa:	66 89 8c 1b 00 80 0b 	mov    %cx,-0x7ff48000(%ebx,%ebx,1)
801005b1:	80 
801005b2:	e9 b8 fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
801005b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005be:	00 
801005bf:	90                   	nop
  outb(CRTPORT+1, pos);
801005c0:	31 db                	xor    %ebx,%ebx
801005c2:	31 f6                	xor    %esi,%esi
801005c4:	e9 fb fe ff ff       	jmp    801004c4 <consputc.part.0+0xd4>
801005c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c&0xff) | 0x0700;
801005d0:	89 f1                	mov    %esi,%ecx
801005d2:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos]   = ' ' | 0x0700;
801005d5:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c&0xff) | 0x0700;
801005da:	01 c0                	add    %eax,%eax
801005dc:	0f b6 f1             	movzbl %cl,%esi
    crt[pos]   = ' ' | 0x0700;
801005df:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c&0xff) | 0x0700;
801005e6:	66 81 ce 00 07       	or     $0x700,%si
801005eb:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos]   = ' ' | 0x0700;
801005f2:	e9 78 fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
801005f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005fe:	00 
801005ff:	90                   	nop
    uartputc('\b');
80100600:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100603:	be d4 03 00 00       	mov    $0x3d4,%esi
80100608:	6a 08                	push   $0x8
8010060a:	e8 81 5b 00 00       	call   80106190 <uartputc>
8010060f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100614:	89 f2                	mov    %esi,%edx
80100616:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100617:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010061c:	89 da                	mov    %ebx,%edx
8010061e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010061f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100622:	89 f2                	mov    %esi,%edx
80100624:	b8 0f 00 00 00       	mov    $0xf,%eax
80100629:	c1 e1 08             	shl    $0x8,%ecx
8010062c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010062d:	89 da                	mov    %ebx,%edx
8010062f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100630:	0f b6 d8             	movzbl %al,%ebx
    if(pos > 0)
80100633:	83 c4 10             	add    $0x10,%esp
80100636:	09 cb                	or     %ecx,%ebx
80100638:	74 86                	je     801005c0 <consputc.part.0+0x1d0>
      --pos;
8010063a:	83 eb 01             	sub    $0x1,%ebx
8010063d:	e9 2d fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
    panic("pos under/overflow");
80100642:	83 ec 0c             	sub    $0xc,%esp
80100645:	68 85 76 10 80       	push   $0x80107685
8010064a:	e8 21 fd ff ff       	call   80100370 <panic>
8010064f:	90                   	nop

80100650 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 18             	sub    $0x18,%esp
80100659:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010065c:	ff 75 08             	push   0x8(%ebp)
8010065f:	e8 fc 16 00 00       	call   80101d60 <iunlock>
  acquire(&cons.lock);
80100664:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010066b:	e8 10 44 00 00       	call   80104a80 <acquire>
  for(i = 0; i < n; i++)
80100670:	83 c4 10             	add    $0x10,%esp
80100673:	85 f6                	test   %esi,%esi
80100675:	7e 27                	jle    8010069e <consolewrite+0x4e>
80100677:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010067a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010067d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff, 0);
80100683:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
80100686:	85 d2                	test   %edx,%edx
80100688:	74 06                	je     80100690 <consolewrite+0x40>
  asm volatile("cli");
8010068a:	fa                   	cli
    for(;;)
8010068b:	eb fe                	jmp    8010068b <consolewrite+0x3b>
8010068d:	8d 76 00             	lea    0x0(%esi),%esi
80100690:	31 d2                	xor    %edx,%edx
  for(i = 0; i < n; i++)
80100692:	83 c3 01             	add    $0x1,%ebx
80100695:	e8 56 fd ff ff       	call   801003f0 <consputc.part.0>
8010069a:	39 fb                	cmp    %edi,%ebx
8010069c:	75 df                	jne    8010067d <consolewrite+0x2d>
  release(&cons.lock);
8010069e:	83 ec 0c             	sub    $0xc,%esp
801006a1:	68 20 ff 10 80       	push   $0x8010ff20
801006a6:	e8 75 43 00 00       	call   80104a20 <release>
  ilock(ip);
801006ab:	58                   	pop    %eax
801006ac:	ff 75 08             	push   0x8(%ebp)
801006af:	e8 cc 15 00 00       	call   80101c80 <ilock>

  return n;
}
801006b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006b7:	89 f0                	mov    %esi,%eax
801006b9:	5b                   	pop    %ebx
801006ba:	5e                   	pop    %esi
801006bb:	5f                   	pop    %edi
801006bc:	5d                   	pop    %ebp
801006bd:	c3                   	ret
801006be:	66 90                	xchg   %ax,%ax

801006c0 <printint>:
{
801006c0:	55                   	push   %ebp
801006c1:	89 e5                	mov    %esp,%ebp
801006c3:	57                   	push   %edi
801006c4:	56                   	push   %esi
801006c5:	53                   	push   %ebx
801006c6:	89 d3                	mov    %edx,%ebx
801006c8:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
801006cb:	85 c0                	test   %eax,%eax
801006cd:	79 05                	jns    801006d4 <printint+0x14>
801006cf:	83 e1 01             	and    $0x1,%ecx
801006d2:	75 66                	jne    8010073a <printint+0x7a>
    x = xx;
801006d4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801006db:	89 c1                	mov    %eax,%ecx
  i = 0;
801006dd:	31 f6                	xor    %esi,%esi
801006df:	90                   	nop
    buf[i++] = digits[x % base];
801006e0:	89 c8                	mov    %ecx,%eax
801006e2:	31 d2                	xor    %edx,%edx
801006e4:	89 f7                	mov    %esi,%edi
801006e6:	f7 f3                	div    %ebx
801006e8:	8d 76 01             	lea    0x1(%esi),%esi
801006eb:	0f b6 92 98 7b 10 80 	movzbl -0x7fef8468(%edx),%edx
801006f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
801006f6:	89 ca                	mov    %ecx,%edx
801006f8:	89 c1                	mov    %eax,%ecx
801006fa:	39 da                	cmp    %ebx,%edx
801006fc:	73 e2                	jae    801006e0 <printint+0x20>
  if(sign)
801006fe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100701:	85 c9                	test   %ecx,%ecx
80100703:	74 07                	je     8010070c <printint+0x4c>
    buf[i++] = '-';
80100705:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010070a:	89 f7                	mov    %esi,%edi
8010070c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010070f:	01 df                	add    %ebx,%edi
  if(panicked){
80100711:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i], 0);
80100717:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010071a:	85 d2                	test   %edx,%edx
8010071c:	74 0a                	je     80100728 <printint+0x68>
8010071e:	fa                   	cli
    for(;;)
8010071f:	eb fe                	jmp    8010071f <printint+0x5f>
80100721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100728:	31 d2                	xor    %edx,%edx
8010072a:	e8 c1 fc ff ff       	call   801003f0 <consputc.part.0>
  while(--i >= 0)
8010072f:	8d 47 ff             	lea    -0x1(%edi),%eax
80100732:	39 df                	cmp    %ebx,%edi
80100734:	74 11                	je     80100747 <printint+0x87>
80100736:	89 c7                	mov    %eax,%edi
80100738:	eb d7                	jmp    80100711 <printint+0x51>
    x = -xx;
8010073a:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010073c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80100743:	89 c1                	mov    %eax,%ecx
80100745:	eb 96                	jmp    801006dd <printint+0x1d>
}
80100747:	83 c4 2c             	add    $0x2c,%esp
8010074a:	5b                   	pop    %ebx
8010074b:	5e                   	pop    %esi
8010074c:	5f                   	pop    %edi
8010074d:	5d                   	pop    %ebp
8010074e:	c3                   	ret
8010074f:	90                   	nop

80100750 <cprintf>:
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	57                   	push   %edi
80100754:	56                   	push   %esi
80100755:	53                   	push   %ebx
80100756:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100759:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
8010075f:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
80100762:	85 ff                	test   %edi,%edi
80100764:	0f 85 06 01 00 00    	jne    80100870 <cprintf+0x120>
  if (fmt == 0)
8010076a:	85 f6                	test   %esi,%esi
8010076c:	0f 84 e0 01 00 00    	je     80100952 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100772:	0f b6 06             	movzbl (%esi),%eax
80100775:	85 c0                	test   %eax,%eax
80100777:	74 59                	je     801007d2 <cprintf+0x82>
80100779:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
8010077c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
80100781:	83 f8 25             	cmp    $0x25,%eax
80100784:	75 5a                	jne    801007e0 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100786:	83 c3 01             	add    $0x1,%ebx
80100789:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if(c == 0)
8010078d:	85 ff                	test   %edi,%edi
8010078f:	74 36                	je     801007c7 <cprintf+0x77>
    switch(c){
80100791:	83 ff 70             	cmp    $0x70,%edi
80100794:	0f 84 b6 00 00 00    	je     80100850 <cprintf+0x100>
8010079a:	7f 74                	jg     80100810 <cprintf+0xc0>
8010079c:	83 ff 25             	cmp    $0x25,%edi
8010079f:	74 5e                	je     801007ff <cprintf+0xaf>
801007a1:	83 ff 64             	cmp    $0x64,%edi
801007a4:	75 78                	jne    8010081e <cprintf+0xce>
      printint(*argp++, 10, 1);
801007a6:	8b 01                	mov    (%ecx),%eax
801007a8:	8d 79 04             	lea    0x4(%ecx),%edi
801007ab:	ba 0a 00 00 00       	mov    $0xa,%edx
801007b0:	b9 01 00 00 00       	mov    $0x1,%ecx
801007b5:	e8 06 ff ff ff       	call   801006c0 <printint>
801007ba:	89 f9                	mov    %edi,%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007bc:	83 c3 01             	add    $0x1,%ebx
801007bf:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007c3:	85 c0                	test   %eax,%eax
801007c5:	75 ba                	jne    80100781 <cprintf+0x31>
801007c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
801007ca:	85 ff                	test   %edi,%edi
801007cc:	0f 85 c1 00 00 00    	jne    80100893 <cprintf+0x143>
}
801007d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007d5:	5b                   	pop    %ebx
801007d6:	5e                   	pop    %esi
801007d7:	5f                   	pop    %edi
801007d8:	5d                   	pop    %ebp
801007d9:	c3                   	ret
801007da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(panicked){
801007e0:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	74 06                	je     801007f0 <cprintf+0xa0>
801007ea:	fa                   	cli
    for(;;)
801007eb:	eb fe                	jmp    801007eb <cprintf+0x9b>
801007ed:	8d 76 00             	lea    0x0(%esi),%esi
801007f0:	31 d2                	xor    %edx,%edx
801007f2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801007f5:	e8 f6 fb ff ff       	call   801003f0 <consputc.part.0>
      continue;
801007fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007fd:	eb bd                	jmp    801007bc <cprintf+0x6c>
  if(panicked){
801007ff:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
80100805:	85 ff                	test   %edi,%edi
80100807:	0f 84 13 01 00 00    	je     80100920 <cprintf+0x1d0>
8010080d:	fa                   	cli
    for(;;)
8010080e:	eb fe                	jmp    8010080e <cprintf+0xbe>
    switch(c){
80100810:	83 ff 73             	cmp    $0x73,%edi
80100813:	0f 84 8f 00 00 00    	je     801008a8 <cprintf+0x158>
80100819:	83 ff 78             	cmp    $0x78,%edi
8010081c:	74 32                	je     80100850 <cprintf+0x100>
  if(panicked){
8010081e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100824:	85 d2                	test   %edx,%edx
80100826:	0f 85 e8 00 00 00    	jne    80100914 <cprintf+0x1c4>
8010082c:	31 d2                	xor    %edx,%edx
8010082e:	b8 25 00 00 00       	mov    $0x25,%eax
80100833:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100836:	e8 b5 fb ff ff       	call   801003f0 <consputc.part.0>
8010083b:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100840:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100843:	85 c0                	test   %eax,%eax
80100845:	0f 84 ec 00 00 00    	je     80100937 <cprintf+0x1e7>
8010084b:	fa                   	cli
    for(;;)
8010084c:	eb fe                	jmp    8010084c <cprintf+0xfc>
8010084e:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
80100850:	8b 01                	mov    (%ecx),%eax
80100852:	8d 79 04             	lea    0x4(%ecx),%edi
80100855:	ba 10 00 00 00       	mov    $0x10,%edx
8010085a:	31 c9                	xor    %ecx,%ecx
8010085c:	e8 5f fe ff ff       	call   801006c0 <printint>
80100861:	89 f9                	mov    %edi,%ecx
      break;
80100863:	e9 54 ff ff ff       	jmp    801007bc <cprintf+0x6c>
80100868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010086f:	00 
    acquire(&cons.lock);
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 20 ff 10 80       	push   $0x8010ff20
80100878:	e8 03 42 00 00       	call   80104a80 <acquire>
  if (fmt == 0)
8010087d:	83 c4 10             	add    $0x10,%esp
80100880:	85 f6                	test   %esi,%esi
80100882:	0f 84 ca 00 00 00    	je     80100952 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100888:	0f b6 06             	movzbl (%esi),%eax
8010088b:	85 c0                	test   %eax,%eax
8010088d:	0f 85 e6 fe ff ff    	jne    80100779 <cprintf+0x29>
    release(&cons.lock);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 20 ff 10 80       	push   $0x8010ff20
8010089b:	e8 80 41 00 00       	call   80104a20 <release>
801008a0:	83 c4 10             	add    $0x10,%esp
801008a3:	e9 2a ff ff ff       	jmp    801007d2 <cprintf+0x82>
      if((s = (char*)*argp++) == 0)
801008a8:	8b 39                	mov    (%ecx),%edi
801008aa:	8d 51 04             	lea    0x4(%ecx),%edx
801008ad:	85 ff                	test   %edi,%edi
801008af:	74 27                	je     801008d8 <cprintf+0x188>
      for(; *s; s++)
801008b1:	0f be 07             	movsbl (%edi),%eax
801008b4:	84 c0                	test   %al,%al
801008b6:	0f 84 8f 00 00 00    	je     8010094b <cprintf+0x1fb>
801008bc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008bf:	89 fb                	mov    %edi,%ebx
801008c1:	89 f7                	mov    %esi,%edi
801008c3:	89 d6                	mov    %edx,%esi
  if(panicked){
801008c5:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801008cb:	85 d2                	test   %edx,%edx
801008cd:	74 26                	je     801008f5 <cprintf+0x1a5>
801008cf:	fa                   	cli
    for(;;)
801008d0:	eb fe                	jmp    801008d0 <cprintf+0x180>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
801008d8:	bf 98 76 10 80       	mov    $0x80107698,%edi
801008dd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008e0:	b8 28 00 00 00       	mov    $0x28,%eax
801008e5:	89 fb                	mov    %edi,%ebx
801008e7:	89 f7                	mov    %esi,%edi
801008e9:	89 d6                	mov    %edx,%esi
  if(panicked){
801008eb:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801008f1:	85 d2                	test   %edx,%edx
801008f3:	75 da                	jne    801008cf <cprintf+0x17f>
801008f5:	31 d2                	xor    %edx,%edx
      for(; *s; s++)
801008f7:	83 c3 01             	add    $0x1,%ebx
801008fa:	e8 f1 fa ff ff       	call   801003f0 <consputc.part.0>
801008ff:	0f be 03             	movsbl (%ebx),%eax
80100902:	84 c0                	test   %al,%al
80100904:	75 bf                	jne    801008c5 <cprintf+0x175>
      if((s = (char*)*argp++) == 0)
80100906:	89 f2                	mov    %esi,%edx
80100908:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010090b:	89 fe                	mov    %edi,%esi
8010090d:	89 d1                	mov    %edx,%ecx
8010090f:	e9 a8 fe ff ff       	jmp    801007bc <cprintf+0x6c>
80100914:	fa                   	cli
    for(;;)
80100915:	eb fe                	jmp    80100915 <cprintf+0x1c5>
80100917:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010091e:	00 
8010091f:	90                   	nop
80100920:	31 d2                	xor    %edx,%edx
80100922:	b8 25 00 00 00       	mov    $0x25,%eax
80100927:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc.part.0>
      break;
8010092f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100932:	e9 85 fe ff ff       	jmp    801007bc <cprintf+0x6c>
80100937:	31 d2                	xor    %edx,%edx
80100939:	89 f8                	mov    %edi,%eax
8010093b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010093e:	e8 ad fa ff ff       	call   801003f0 <consputc.part.0>
      break;
80100943:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100946:	e9 71 fe ff ff       	jmp    801007bc <cprintf+0x6c>
      if((s = (char*)*argp++) == 0)
8010094b:	89 d1                	mov    %edx,%ecx
8010094d:	e9 6a fe ff ff       	jmp    801007bc <cprintf+0x6c>
    panic("null fmt");
80100952:	83 ec 0c             	sub    $0xc,%esp
80100955:	68 9f 76 10 80       	push   $0x8010769f
8010095a:	e8 11 fa ff ff       	call   80100370 <panic>
8010095f:	90                   	nop

80100960 <consoleintr>:
{
80100960:	55                   	push   %ebp
80100961:	89 e5                	mov    %esp,%ebp
80100963:	57                   	push   %edi
  int c, doprocdump = 0;
80100964:	31 ff                	xor    %edi,%edi
{
80100966:	56                   	push   %esi
80100967:	53                   	push   %ebx
80100968:	83 ec 38             	sub    $0x38,%esp
8010096b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
8010096e:	68 20 ff 10 80       	push   $0x8010ff20
80100973:	e8 08 41 00 00       	call   80104a80 <acquire>
  while((c = getc()) >= 0){
80100978:	83 c4 10             	add    $0x10,%esp
8010097b:	ff d6                	call   *%esi
8010097d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100980:	85 c0                	test   %eax,%eax
80100982:	0f 88 00 02 00 00    	js     80100b88 <consoleintr+0x228>
    switch(c){
80100988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010098b:	83 f8 15             	cmp    $0x15,%eax
8010098e:	7f 58                	jg     801009e8 <consoleintr+0x88>
80100990:	85 c0                	test   %eax,%eax
80100992:	74 e7                	je     8010097b <consoleintr+0x1b>
80100994:	83 f8 15             	cmp    $0x15,%eax
80100997:	77 77                	ja     80100a10 <consoleintr+0xb0>
80100999:	ff 24 85 40 7b 10 80 	jmp    *-0x7fef84c0(,%eax,4)
801009a0:	31 d2                	xor    %edx,%edx
801009a2:	b8 00 01 00 00       	mov    $0x100,%eax
801009a7:	e8 44 fa ff ff       	call   801003f0 <consputc.part.0>
      while(input.e != input.w &&
801009ac:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b1:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009b7:	0f 84 31 02 00 00    	je     80100bee <consoleintr+0x28e>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009bd:	8d 50 ff             	lea    -0x1(%eax),%edx
801009c0:	89 d1                	mov    %edx,%ecx
801009c2:	83 e1 7f             	and    $0x7f,%ecx
      while(input.e != input.w &&
801009c5:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
801009cc:	0f 84 1c 02 00 00    	je     80100bee <consoleintr+0x28e>
  if(panicked){
801009d2:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
        input.e--;
801009d7:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if(panicked){
801009dd:	85 c0                	test   %eax,%eax
801009df:	74 bf                	je     801009a0 <consoleintr+0x40>
801009e1:	fa                   	cli
    for(;;)
801009e2:	eb fe                	jmp    801009e2 <consoleintr+0x82>
801009e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801009e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009eb:	3d e4 00 00 00       	cmp    $0xe4,%eax
801009f0:	0f 84 62 01 00 00    	je     80100b58 <consoleintr+0x1f8>
801009f6:	3d e5 00 00 00       	cmp    $0xe5,%eax
801009fb:	74 73                	je     80100a70 <consoleintr+0x110>
801009fd:	83 f8 7f             	cmp    $0x7f,%eax
80100a00:	0f 84 9a 00 00 00    	je     80100aa0 <consoleintr+0x140>
80100a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a0d:	00 
80100a0e:	66 90                	xchg   %ax,%ax
      if(input.e < input.real_end){
80100a10:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100a15:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100a1b:	89 c2                	mov    %eax,%edx
80100a1d:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
      if(input.e < input.real_end){
80100a23:	39 c1                	cmp    %eax,%ecx
80100a25:	0f 83 e5 01 00 00    	jae    80100c10 <consoleintr+0x2b0>
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100a2b:	83 fa 7f             	cmp    $0x7f,%edx
80100a2e:	0f 87 47 ff ff ff    	ja     8010097b <consoleintr+0x1b>
  if(panicked){
80100a34:	8b 1d 58 ff 10 80    	mov    0x8010ff58,%ebx
          if(c != '\n'){
80100a3a:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%ebp)
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a3e:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a41:	89 5d e0             	mov    %ebx,-0x20(%ebp)
          if(c != '\n'){
80100a44:	0f 85 58 03 00 00    	jne    80100da2 <consoleintr+0x442>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a4a:	83 e0 7f             	and    $0x7f,%eax
80100a4d:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a53:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
80100a5a:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100a60:	85 db                	test   %ebx,%ebx
80100a62:	0f 84 74 04 00 00    	je     80100edc <consoleintr+0x57c>
80100a68:	fa                   	cli
    for(;;)
80100a69:	eb fe                	jmp    80100a69 <consoleintr+0x109>
80100a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e < input.real_end){
80100a70:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a75:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100a7b:	0f 83 fa fe ff ff    	jae    8010097b <consoleintr+0x1b>
        char ch = input.buf[input.e % INPUT_BUF];
80100a81:	83 e0 7f             	and    $0x7f,%eax
80100a84:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if(panicked){
80100a8b:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 84 69 02 00 00    	je     80100d01 <consoleintr+0x3a1>
80100a98:	fa                   	cli
    for(;;)
80100a99:	eb fe                	jmp    80100a99 <consoleintr+0x139>
80100a9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e != input.w) {
80100aa0:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100aa6:	3b 15 04 ff 10 80    	cmp    0x8010ff04,%edx
80100aac:	0f 84 c9 fe ff ff    	je     8010097b <consoleintr+0x1b>
          input.real_end--;
80100ab2:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
  if(panicked){
80100ab7:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        if (input.e == input.real_end) {
80100abd:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
          input.real_end--;
80100ac3:	8d 58 ff             	lea    -0x1(%eax),%ebx
          input.e--;
80100ac6:	8d 42 ff             	lea    -0x1(%edx),%eax
  if(panicked){
80100ac9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
          input.e--;
80100acc:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
        if (input.e == input.real_end) {
80100ad1:	0f 84 21 01 00 00    	je     80100bf8 <consoleintr+0x298>
          for (uint i = input.e; i < input.real_end - 1; i++)
80100ad7:	39 d8                	cmp    %ebx,%eax
80100ad9:	73 23                	jae    80100afe <consoleintr+0x19e>
80100adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100ae0:	89 c2                	mov    %eax,%edx
80100ae2:	83 c0 01             	add    $0x1,%eax
80100ae5:	89 c1                	mov    %eax,%ecx
80100ae7:	83 e2 7f             	and    $0x7f,%edx
80100aea:	83 e1 7f             	and    $0x7f,%ecx
80100aed:	0f b6 89 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ecx
80100af4:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
          for (uint i = input.e; i < input.real_end - 1; i++)
80100afa:	39 d8                	cmp    %ebx,%eax
80100afc:	75 e2                	jne    80100ae0 <consoleintr+0x180>
          input.real_end--;
80100afe:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100b04:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100b07:	85 db                	test   %ebx,%ebx
80100b09:	0f 84 51 01 00 00    	je     80100c60 <consoleintr+0x300>
80100b0f:	fa                   	cli
    for(;;)
80100b10:	eb fe                	jmp    80100b10 <consoleintr+0x1b0>
80100b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100b18:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100b1e:	89 d0                	mov    %edx,%eax
80100b20:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100b26:	0f 83 4f fe ff ff    	jae    8010097b <consoleintr+0x1b>
80100b2c:	83 e0 7f             	and    $0x7f,%eax
80100b2f:	0f b6 80 80 fe 10 80 	movzbl -0x7fef0180(%eax),%eax
80100b36:	3c 20                	cmp    $0x20,%al
80100b38:	0f 84 82 01 00 00    	je     80100cc0 <consoleintr+0x360>
80100b3e:	3c 0a                	cmp    $0xa,%al
80100b40:	0f 84 7a 01 00 00    	je     80100cc0 <consoleintr+0x360>
  if(panicked){
80100b46:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100b4c:	85 d2                	test   %edx,%edx
80100b4e:	74 54                	je     80100ba4 <consoleintr+0x244>
80100b50:	fa                   	cli
    for(;;)
80100b51:	eb fe                	jmp    80100b51 <consoleintr+0x1f1>
80100b53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e > input.w){
80100b58:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b5d:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100b63:	0f 83 12 fe ff ff    	jae    8010097b <consoleintr+0x1b>
        input.e--;
80100b69:	83 e8 01             	sub    $0x1,%eax
80100b6c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100b71:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100b76:	85 c0                	test   %eax,%eax
80100b78:	0f 84 72 01 00 00    	je     80100cf0 <consoleintr+0x390>
80100b7e:	fa                   	cli
    for(;;)
80100b7f:	eb fe                	jmp    80100b7f <consoleintr+0x21f>
80100b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	68 20 ff 10 80       	push   $0x8010ff20
80100b90:	e8 8b 3e 00 00       	call   80104a20 <release>
  if(doprocdump) {
80100b95:	83 c4 10             	add    $0x10,%esp
80100b98:	85 ff                	test   %edi,%edi
80100b9a:	75 46                	jne    80100be2 <consoleintr+0x282>
}
80100b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b9f:	5b                   	pop    %ebx
80100ba0:	5e                   	pop    %esi
80100ba1:	5f                   	pop    %edi
80100ba2:	5d                   	pop    %ebp
80100ba3:	c3                   	ret
        consputc(KEY_RT, ch);
80100ba4:	0f be d0             	movsbl %al,%edx
80100ba7:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100bac:	e8 3f f8 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100bb1:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100bb7:	8d 42 01             	lea    0x1(%edx),%eax
80100bba:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
80100bbf:	89 c2                	mov    %eax,%edx
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100bc1:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100bc7:	0f 82 5f ff ff ff    	jb     80100b2c <consoleintr+0x1cc>
80100bcd:	e9 a9 fd ff ff       	jmp    8010097b <consoleintr+0x1b>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100bd8:	bf 01 00 00 00       	mov    $0x1,%edi
80100bdd:	e9 99 fd ff ff       	jmp    8010097b <consoleintr+0x1b>
}
80100be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100be5:	5b                   	pop    %ebx
80100be6:	5e                   	pop    %esi
80100be7:	5f                   	pop    %edi
80100be8:	5d                   	pop    %ebp
    procdump();
80100be9:	e9 b2 3a 00 00       	jmp    801046a0 <procdump>
      input.real_end = input.e;
80100bee:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      break;
80100bf3:	e9 83 fd ff ff       	jmp    8010097b <consoleintr+0x1b>
          input.real_end--;
80100bf8:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100bfe:	85 c9                	test   %ecx,%ecx
80100c00:	0f 84 42 01 00 00    	je     80100d48 <consoleintr+0x3e8>
80100c06:	fa                   	cli
    for(;;)
80100c07:	eb fe                	jmp    80100c07 <consoleintr+0x2a7>
80100c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100c10:	83 fa 7f             	cmp    $0x7f,%edx
80100c13:	0f 87 62 fd ff ff    	ja     8010097b <consoleintr+0x1b>
          c = (c == '\r') ? '\n' : c;
80100c19:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100c1c:	83 fb 0d             	cmp    $0xd,%ebx
80100c1f:	75 0c                	jne    80100c2d <consoleintr+0x2cd>
80100c21:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
80100c28:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100c2d:	8d 51 01             	lea    0x1(%ecx),%edx
80100c30:	83 e1 7f             	and    $0x7f,%ecx
80100c33:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100c39:	88 99 80 fe 10 80    	mov    %bl,-0x7fef0180(%ecx)
          if (input.e > input.real_end) input.real_end = input.e;
80100c3f:	39 d0                	cmp    %edx,%eax
80100c41:	73 06                	jae    80100c49 <consoleintr+0x2e9>
80100c43:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100c49:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100c4e:	85 c0                	test   %eax,%eax
80100c50:	0f 84 03 01 00 00    	je     80100d59 <consoleintr+0x3f9>
80100c56:	fa                   	cli
    for(;;)
80100c57:	eb fe                	jmp    80100c57 <consoleintr+0x2f7>
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c60:	31 d2                	xor    %edx,%edx
80100c62:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100c67:	e8 84 f7 ff ff       	call   801003f0 <consputc.part.0>
          for (uint i = input.e; i < input.real_end; i++)
80100c6c:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100c72:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100c78:	73 2c                	jae    80100ca6 <consoleintr+0x346>
            consputc(input.buf[i % INPUT_BUF], 0);
80100c7a:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100c7c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
            consputc(input.buf[i % INPUT_BUF], 0);
80100c82:	83 e0 7f             	and    $0x7f,%eax
80100c85:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100c8c:	85 d2                	test   %edx,%edx
80100c8e:	0f 85 ac 00 00 00    	jne    80100d40 <consoleintr+0x3e0>
80100c94:	31 d2                	xor    %edx,%edx
          for (uint i = input.e; i < input.real_end; i++)
80100c96:	83 c3 01             	add    $0x1,%ebx
80100c99:	e8 52 f7 ff ff       	call   801003f0 <consputc.part.0>
80100c9e:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100ca4:	72 d4                	jb     80100c7a <consoleintr+0x31a>
  if(panicked){
80100ca6:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100cac:	85 c9                	test   %ecx,%ecx
80100cae:	0f 84 dc 01 00 00    	je     80100e90 <consoleintr+0x530>
80100cb4:	fa                   	cli
    for(;;)
80100cb5:	eb fe                	jmp    80100cb5 <consoleintr+0x355>
80100cb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100cbe:	00 
80100cbf:	90                   	nop
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100cc0:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100cc6:	0f 83 af fc ff ff    	jae    8010097b <consoleintr+0x1b>
80100ccc:	89 d0                	mov    %edx,%eax
80100cce:	83 e0 7f             	and    $0x7f,%eax
80100cd1:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100cd8:	0f 85 9d fc ff ff    	jne    8010097b <consoleintr+0x1b>
  if(panicked){
80100cde:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100ce3:	85 c0                	test   %eax,%eax
80100ce5:	74 30                	je     80100d17 <consoleintr+0x3b7>
80100ce7:	fa                   	cli
    for(;;)
80100ce8:	eb fe                	jmp    80100ce8 <consoleintr+0x388>
80100cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100cf0:	31 d2                	xor    %edx,%edx
80100cf2:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100cf7:	e8 f4 f6 ff ff       	call   801003f0 <consputc.part.0>
80100cfc:	e9 7a fc ff ff       	jmp    8010097b <consoleintr+0x1b>
80100d01:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d06:	e8 e5 f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d0b:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
80100d12:	e9 64 fc ff ff       	jmp    8010097b <consoleintr+0x1b>
80100d17:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d1c:	ba 20 00 00 00       	mov    $0x20,%edx
80100d21:	e8 ca f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d26:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d2b:	83 c0 01             	add    $0x1,%eax
80100d2e:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100d33:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100d39:	72 93                	jb     80100cce <consoleintr+0x36e>
80100d3b:	e9 3b fc ff ff       	jmp    8010097b <consoleintr+0x1b>
80100d40:	fa                   	cli
    for(;;)
80100d41:	eb fe                	jmp    80100d41 <consoleintr+0x3e1>
80100d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d48:	31 d2                	xor    %edx,%edx
80100d4a:	b8 00 01 00 00       	mov    $0x100,%eax
80100d4f:	e8 9c f6 ff ff       	call   801003f0 <consputc.part.0>
80100d54:	e9 22 fc ff ff       	jmp    8010097b <consoleintr+0x1b>
80100d59:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100d5c:	31 d2                	xor    %edx,%edx
80100d5e:	89 d8                	mov    %ebx,%eax
80100d60:	e8 8b f6 ff ff       	call   801003f0 <consputc.part.0>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100d65:	83 fb 0a             	cmp    $0xa,%ebx
80100d68:	74 14                	je     80100d7e <consoleintr+0x41e>
80100d6a:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100d6f:	83 e8 80             	sub    $0xffffff80,%eax
80100d72:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
80100d78:	0f 85 fd fb ff ff    	jne    8010097b <consoleintr+0x1b>
            input.w = input.e;
80100d7e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100d83:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100d86:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
80100d8b:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
80100d90:	68 00 ff 10 80       	push   $0x8010ff00
80100d95:	e8 26 38 00 00       	call   801045c0 <wakeup>
80100d9a:	83 c4 10             	add    $0x10,%esp
80100d9d:	e9 d9 fb ff ff       	jmp    8010097b <consoleintr+0x1b>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100da2:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100da5:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100da8:	39 cb                	cmp    %ecx,%ebx
80100daa:	7c 4e                	jl     80100dfa <consoleintr+0x49a>
80100dac:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80100daf:	89 7d dc             	mov    %edi,-0x24(%ebp)
80100db2:	89 d7                	mov    %edx,%edi
80100db4:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80100db7:	89 c6                	mov    %eax,%esi
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100db9:	89 da                	mov    %ebx,%edx
80100dbb:	c1 fa 1f             	sar    $0x1f,%edx
80100dbe:	c1 ea 19             	shr    $0x19,%edx
80100dc1:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80100dc4:	83 e0 7f             	and    $0x7f,%eax
80100dc7:	29 d0                	sub    %edx,%eax
80100dc9:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
80100dd0:	8d 43 01             	lea    0x1(%ebx),%eax
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100dd3:	83 eb 01             	sub    $0x1,%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100dd6:	89 c1                	mov    %eax,%ecx
80100dd8:	c1 f9 1f             	sar    $0x1f,%ecx
80100ddb:	c1 e9 19             	shr    $0x19,%ecx
80100dde:	01 c8                	add    %ecx,%eax
80100de0:	83 e0 7f             	and    $0x7f,%eax
80100de3:	29 c8                	sub    %ecx,%eax
80100de5:	88 90 80 fe 10 80    	mov    %dl,-0x7fef0180(%eax)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100deb:	39 f3                	cmp    %esi,%ebx
80100ded:	75 ca                	jne    80100db9 <consoleintr+0x459>
80100def:	89 fa                	mov    %edi,%edx
80100df1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80100df4:	8b 7d dc             	mov    -0x24(%ebp),%edi
80100df7:	8b 75 d4             	mov    -0x2c(%ebp),%esi
            input.buf[input.e] = c;
80100dfa:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  if(panicked){
80100dfe:	8b 5d e0             	mov    -0x20(%ebp),%ebx
            input.real_end++;
80100e01:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
            input.buf[input.e] = c;
80100e07:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked){
80100e0d:	85 db                	test   %ebx,%ebx
80100e0f:	74 07                	je     80100e18 <consoleintr+0x4b8>
80100e11:	fa                   	cli
    for(;;)
80100e12:	eb fe                	jmp    80100e12 <consoleintr+0x4b2>
80100e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e1b:	31 d2                	xor    %edx,%edx
80100e1d:	e8 ce f5 ff ff       	call   801003f0 <consputc.part.0>
            input.e++;
80100e22:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e27:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
80100e2a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
80100e2f:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
80100e35:	39 c3                	cmp    %eax,%ebx
80100e37:	0f 83 e6 00 00 00    	jae    80100f23 <consoleintr+0x5c3>
              consputc(input.buf[i % INPUT_BUF], 0);
80100e3d:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100e3f:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
              consputc(input.buf[i % INPUT_BUF], 0);
80100e45:	83 e0 7f             	and    $0x7f,%eax
80100e48:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100e4f:	85 c9                	test   %ecx,%ecx
80100e51:	74 0d                	je     80100e60 <consoleintr+0x500>
80100e53:	fa                   	cli
    for(;;)
80100e54:	eb fe                	jmp    80100e54 <consoleintr+0x4f4>
80100e56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e5d:	00 
80100e5e:	66 90                	xchg   %ax,%ax
80100e60:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80100e62:	83 c3 01             	add    $0x1,%ebx
80100e65:	e8 86 f5 ff ff       	call   801003f0 <consputc.part.0>
80100e6a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100e6f:	39 c3                	cmp    %eax,%ebx
80100e71:	72 ca                	jb     80100e3d <consoleintr+0x4dd>
            for (uint k = input.e; k < input.real_end; k++)
80100e73:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100e79:	39 c3                	cmp    %eax,%ebx
80100e7b:	0f 83 a2 00 00 00    	jae    80100f23 <consoleintr+0x5c3>
  if(panicked){
80100e81:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100e87:	85 d2                	test   %edx,%edx
80100e89:	74 7c                	je     80100f07 <consoleintr+0x5a7>
80100e8b:	fa                   	cli
    for(;;)
80100e8c:	eb fe                	jmp    80100e8c <consoleintr+0x52c>
80100e8e:	66 90                	xchg   %ax,%ax
80100e90:	31 d2                	xor    %edx,%edx
80100e92:	b8 20 00 00 00       	mov    $0x20,%eax
80100e97:	e8 54 f5 ff ff       	call   801003f0 <consputc.part.0>
          for (uint k = input.e; k <= input.real_end; k++)
80100e9c:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100ea2:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100ea8:	0f 82 cd fa ff ff    	jb     8010097b <consoleintr+0x1b>
  if(panicked){
80100eae:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100eb3:	85 c0                	test   %eax,%eax
80100eb5:	74 09                	je     80100ec0 <consoleintr+0x560>
80100eb7:	fa                   	cli
    for(;;)
80100eb8:	eb fe                	jmp    80100eb8 <consoleintr+0x558>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec0:	31 d2                	xor    %edx,%edx
80100ec2:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (uint k = input.e; k <= input.real_end; k++)
80100ec7:	83 c3 01             	add    $0x1,%ebx
80100eca:	e8 21 f5 ff ff       	call   801003f0 <consputc.part.0>
80100ecf:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100ed5:	73 d7                	jae    80100eae <consoleintr+0x54e>
80100ed7:	e9 9f fa ff ff       	jmp    8010097b <consoleintr+0x1b>
80100edc:	31 d2                	xor    %edx,%edx
80100ede:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ee3:	e8 08 f5 ff ff       	call   801003f0 <consputc.part.0>
            input.w = input.e;
80100ee8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100eed:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100ef0:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
80100ef5:	68 00 ff 10 80       	push   $0x8010ff00
80100efa:	e8 c1 36 00 00       	call   801045c0 <wakeup>
80100eff:	83 c4 10             	add    $0x10,%esp
80100f02:	e9 74 fa ff ff       	jmp    8010097b <consoleintr+0x1b>
80100f07:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100f0c:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80100f0e:	83 c3 01             	add    $0x1,%ebx
80100f11:	e8 da f4 ff ff       	call   801003f0 <consputc.part.0>
80100f16:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100f1b:	39 c3                	cmp    %eax,%ebx
80100f1d:	0f 82 5e ff ff ff    	jb     80100e81 <consoleintr+0x521>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100f23:	8b 1d 00 ff 10 80    	mov    0x8010ff00,%ebx
80100f29:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80100f2f:	39 c2                	cmp    %eax,%edx
80100f31:	0f 85 44 fa ff ff    	jne    8010097b <consoleintr+0x1b>
            input.e = input.real_end;
80100f37:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            if (c == '\n') {
80100f3c:	eb aa                	jmp    80100ee8 <consoleintr+0x588>
80100f3e:	66 90                	xchg   %ax,%ax

80100f40 <consoleinit>:

void
consoleinit(void)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f46:	68 a8 76 10 80       	push   $0x801076a8
80100f4b:	68 20 ff 10 80       	push   $0x8010ff20
80100f50:	e8 3b 39 00 00       	call   80104890 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f55:	58                   	pop    %eax
80100f56:	5a                   	pop    %edx
80100f57:	6a 00                	push   $0x0
80100f59:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f5b:	c7 05 0c 09 11 80 50 	movl   $0x80100650,0x8011090c
80100f62:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100f65:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100f6c:	02 10 80 
  cons.locking = 1;
80100f6f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100f76:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f79:	e8 c2 19 00 00       	call   80102940 <ioapicenable>
}
80100f7e:	83 c4 10             	add    $0x10,%esp
80100f81:	c9                   	leave
80100f82:	c3                   	ret
80100f83:	66 90                	xchg   %ax,%ax
80100f85:	66 90                	xchg   %ax,%ax
80100f87:	66 90                	xchg   %ax,%ax
80100f89:	66 90                	xchg   %ax,%ax
80100f8b:	66 90                	xchg   %ax,%ax
80100f8d:	66 90                	xchg   %ax,%ax
80100f8f:	90                   	nop

80100f90 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f9c:	e8 9f 2e 00 00       	call   80103e40 <myproc>
80100fa1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100fa7:	e8 74 22 00 00       	call   80103220 <begin_op>

  if((ip = namei(path)) == 0){
80100fac:	83 ec 0c             	sub    $0xc,%esp
80100faf:	ff 75 08             	push   0x8(%ebp)
80100fb2:	e8 a9 15 00 00       	call   80102560 <namei>
80100fb7:	83 c4 10             	add    $0x10,%esp
80100fba:	85 c0                	test   %eax,%eax
80100fbc:	0f 84 30 03 00 00    	je     801012f2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fc2:	83 ec 0c             	sub    $0xc,%esp
80100fc5:	89 c7                	mov    %eax,%edi
80100fc7:	50                   	push   %eax
80100fc8:	e8 b3 0c 00 00       	call   80101c80 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100fcd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100fd3:	6a 34                	push   $0x34
80100fd5:	6a 00                	push   $0x0
80100fd7:	50                   	push   %eax
80100fd8:	57                   	push   %edi
80100fd9:	e8 b2 0f 00 00       	call   80101f90 <readi>
80100fde:	83 c4 20             	add    $0x20,%esp
80100fe1:	83 f8 34             	cmp    $0x34,%eax
80100fe4:	0f 85 01 01 00 00    	jne    801010eb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100fea:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ff1:	45 4c 46 
80100ff4:	0f 85 f1 00 00 00    	jne    801010eb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100ffa:	e8 01 63 00 00       	call   80107300 <setupkvm>
80100fff:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101005:	85 c0                	test   %eax,%eax
80101007:	0f 84 de 00 00 00    	je     801010eb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010100d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101014:	00 
80101015:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010101b:	0f 84 a1 02 00 00    	je     801012c2 <exec+0x332>
  sz = 0;
80101021:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101028:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010102b:	31 db                	xor    %ebx,%ebx
8010102d:	e9 8c 00 00 00       	jmp    801010be <exec+0x12e>
80101032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101038:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010103f:	75 6c                	jne    801010ad <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101041:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101047:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010104d:	0f 82 87 00 00 00    	jb     801010da <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101053:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101059:	72 7f                	jb     801010da <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010105b:	83 ec 04             	sub    $0x4,%esp
8010105e:	50                   	push   %eax
8010105f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101065:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010106b:	e8 c0 60 00 00       	call   80107130 <allocuvm>
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101079:	85 c0                	test   %eax,%eax
8010107b:	74 5d                	je     801010da <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010107d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101083:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101088:	75 50                	jne    801010da <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101093:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101099:	57                   	push   %edi
8010109a:	50                   	push   %eax
8010109b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010a1:	e8 ba 5f 00 00       	call   80107060 <loaduvm>
801010a6:	83 c4 20             	add    $0x20,%esp
801010a9:	85 c0                	test   %eax,%eax
801010ab:	78 2d                	js     801010da <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010ad:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010b4:	83 c3 01             	add    $0x1,%ebx
801010b7:	83 c6 20             	add    $0x20,%esi
801010ba:	39 d8                	cmp    %ebx,%eax
801010bc:	7e 52                	jle    80101110 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010be:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010c4:	6a 20                	push   $0x20
801010c6:	56                   	push   %esi
801010c7:	50                   	push   %eax
801010c8:	57                   	push   %edi
801010c9:	e8 c2 0e 00 00       	call   80101f90 <readi>
801010ce:	83 c4 10             	add    $0x10,%esp
801010d1:	83 f8 20             	cmp    $0x20,%eax
801010d4:	0f 84 5e ff ff ff    	je     80101038 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801010da:	83 ec 0c             	sub    $0xc,%esp
801010dd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010e3:	e8 98 61 00 00       	call   80107280 <freevm>
  if(ip){
801010e8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	57                   	push   %edi
801010ef:	e8 1c 0e 00 00       	call   80101f10 <iunlockput>
    end_op();
801010f4:	e8 97 21 00 00       	call   80103290 <end_op>
801010f9:	83 c4 10             	add    $0x10,%esp
    return -1;
801010fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80101101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101104:	5b                   	pop    %ebx
80101105:	5e                   	pop    %esi
80101106:	5f                   	pop    %edi
80101107:	5d                   	pop    %ebp
80101108:	c3                   	ret
80101109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101110:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101116:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010111c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101122:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101128:	83 ec 0c             	sub    $0xc,%esp
8010112b:	57                   	push   %edi
8010112c:	e8 df 0d 00 00       	call   80101f10 <iunlockput>
  end_op();
80101131:	e8 5a 21 00 00       	call   80103290 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101136:	83 c4 0c             	add    $0xc,%esp
80101139:	53                   	push   %ebx
8010113a:	56                   	push   %esi
8010113b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101141:	56                   	push   %esi
80101142:	e8 e9 5f 00 00       	call   80107130 <allocuvm>
80101147:	83 c4 10             	add    $0x10,%esp
8010114a:	89 c7                	mov    %eax,%edi
8010114c:	85 c0                	test   %eax,%eax
8010114e:	0f 84 86 00 00 00    	je     801011da <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101154:	83 ec 08             	sub    $0x8,%esp
80101157:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010115d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010115f:	50                   	push   %eax
80101160:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101161:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101163:	e8 38 62 00 00       	call   801073a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101168:	8b 45 0c             	mov    0xc(%ebp),%eax
8010116b:	83 c4 10             	add    $0x10,%esp
8010116e:	8b 10                	mov    (%eax),%edx
80101170:	85 d2                	test   %edx,%edx
80101172:	0f 84 56 01 00 00    	je     801012ce <exec+0x33e>
80101178:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010117e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101181:	eb 23                	jmp    801011a6 <exec+0x216>
80101183:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101188:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010118b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101192:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101198:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010119b:	85 d2                	test   %edx,%edx
8010119d:	74 51                	je     801011f0 <exec+0x260>
    if(argc >= MAXARG)
8010119f:	83 f8 20             	cmp    $0x20,%eax
801011a2:	74 36                	je     801011da <exec+0x24a>
801011a4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	52                   	push   %edx
801011aa:	e8 c1 3b 00 00       	call   80104d70 <strlen>
801011af:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011b1:	58                   	pop    %eax
801011b2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011b5:	83 eb 01             	sub    $0x1,%ebx
801011b8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011bb:	e8 b0 3b 00 00       	call   80104d70 <strlen>
801011c0:	83 c0 01             	add    $0x1,%eax
801011c3:	50                   	push   %eax
801011c4:	ff 34 b7             	push   (%edi,%esi,4)
801011c7:	53                   	push   %ebx
801011c8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011ce:	e8 9d 63 00 00       	call   80107570 <copyout>
801011d3:	83 c4 20             	add    $0x20,%esp
801011d6:	85 c0                	test   %eax,%eax
801011d8:	79 ae                	jns    80101188 <exec+0x1f8>
    freevm(pgdir);
801011da:	83 ec 0c             	sub    $0xc,%esp
801011dd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011e3:	e8 98 60 00 00       	call   80107280 <freevm>
801011e8:	83 c4 10             	add    $0x10,%esp
801011eb:	e9 0c ff ff ff       	jmp    801010fc <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011f0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801011f7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801011fd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101203:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80101206:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80101209:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101210:	00 00 00 00 
  ustack[1] = argc;
80101214:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010121a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101221:	ff ff ff 
  ustack[1] = argc;
80101224:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010122a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010122c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010122e:	29 d0                	sub    %edx,%eax
80101230:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101236:	56                   	push   %esi
80101237:	51                   	push   %ecx
80101238:	53                   	push   %ebx
80101239:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010123f:	e8 2c 63 00 00       	call   80107570 <copyout>
80101244:	83 c4 10             	add    $0x10,%esp
80101247:	85 c0                	test   %eax,%eax
80101249:	78 8f                	js     801011da <exec+0x24a>
  for(last=s=path; *s; s++)
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	8b 55 08             	mov    0x8(%ebp),%edx
80101251:	0f b6 00             	movzbl (%eax),%eax
80101254:	84 c0                	test   %al,%al
80101256:	74 17                	je     8010126f <exec+0x2df>
80101258:	89 d1                	mov    %edx,%ecx
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101260:	83 c1 01             	add    $0x1,%ecx
80101263:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101265:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101268:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010126b:	84 c0                	test   %al,%al
8010126d:	75 f1                	jne    80101260 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010126f:	83 ec 04             	sub    $0x4,%esp
80101272:	6a 10                	push   $0x10
80101274:	52                   	push   %edx
80101275:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010127b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010127e:	50                   	push   %eax
8010127f:	e8 ac 3a 00 00       	call   80104d30 <safestrcpy>
  curproc->pgdir = pgdir;
80101284:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010128a:	89 f0                	mov    %esi,%eax
8010128c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010128f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80101291:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101294:	89 c1                	mov    %eax,%ecx
80101296:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010129c:	8b 40 18             	mov    0x18(%eax),%eax
8010129f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801012a2:	8b 41 18             	mov    0x18(%ecx),%eax
801012a5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801012a8:	89 0c 24             	mov    %ecx,(%esp)
801012ab:	e8 20 5c 00 00       	call   80106ed0 <switchuvm>
  freevm(oldpgdir);
801012b0:	89 34 24             	mov    %esi,(%esp)
801012b3:	e8 c8 5f 00 00       	call   80107280 <freevm>
  return 0;
801012b8:	83 c4 10             	add    $0x10,%esp
801012bb:	31 c0                	xor    %eax,%eax
801012bd:	e9 3f fe ff ff       	jmp    80101101 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012c2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801012c7:	31 f6                	xor    %esi,%esi
801012c9:	e9 5a fe ff ff       	jmp    80101128 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801012ce:	be 10 00 00 00       	mov    $0x10,%esi
801012d3:	ba 04 00 00 00       	mov    $0x4,%edx
801012d8:	b8 03 00 00 00       	mov    $0x3,%eax
801012dd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801012e4:	00 00 00 
801012e7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801012ed:	e9 17 ff ff ff       	jmp    80101209 <exec+0x279>
    end_op();
801012f2:	e8 99 1f 00 00       	call   80103290 <end_op>
    cprintf("exec: fail\n");
801012f7:	83 ec 0c             	sub    $0xc,%esp
801012fa:	68 b0 76 10 80       	push   $0x801076b0
801012ff:	e8 4c f4 ff ff       	call   80100750 <cprintf>
    return -1;
80101304:	83 c4 10             	add    $0x10,%esp
80101307:	e9 f0 fd ff ff       	jmp    801010fc <exec+0x16c>
8010130c:	66 90                	xchg   %ax,%ax
8010130e:	66 90                	xchg   %ax,%ax

80101310 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101316:	68 bc 76 10 80       	push   $0x801076bc
8010131b:	68 60 ff 10 80       	push   $0x8010ff60
80101320:	e8 6b 35 00 00       	call   80104890 <initlock>
}
80101325:	83 c4 10             	add    $0x10,%esp
80101328:	c9                   	leave
80101329:	c3                   	ret
8010132a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101330 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101334:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80101339:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010133c:	68 60 ff 10 80       	push   $0x8010ff60
80101341:	e8 3a 37 00 00       	call   80104a80 <acquire>
80101346:	83 c4 10             	add    $0x10,%esp
80101349:	eb 10                	jmp    8010135b <filealloc+0x2b>
8010134b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101350:	83 c3 18             	add    $0x18,%ebx
80101353:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80101359:	74 25                	je     80101380 <filealloc+0x50>
    if(f->ref == 0){
8010135b:	8b 43 04             	mov    0x4(%ebx),%eax
8010135e:	85 c0                	test   %eax,%eax
80101360:	75 ee                	jne    80101350 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101362:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101365:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010136c:	68 60 ff 10 80       	push   $0x8010ff60
80101371:	e8 aa 36 00 00       	call   80104a20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101376:	89 d8                	mov    %ebx,%eax
      return f;
80101378:	83 c4 10             	add    $0x10,%esp
}
8010137b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010137e:	c9                   	leave
8010137f:	c3                   	ret
  release(&ftable.lock);
80101380:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101383:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101385:	68 60 ff 10 80       	push   $0x8010ff60
8010138a:	e8 91 36 00 00       	call   80104a20 <release>
}
8010138f:	89 d8                	mov    %ebx,%eax
  return 0;
80101391:	83 c4 10             	add    $0x10,%esp
}
80101394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101397:	c9                   	leave
80101398:	c3                   	ret
80101399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	53                   	push   %ebx
801013a4:	83 ec 10             	sub    $0x10,%esp
801013a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801013aa:	68 60 ff 10 80       	push   $0x8010ff60
801013af:	e8 cc 36 00 00       	call   80104a80 <acquire>
  if(f->ref < 1)
801013b4:	8b 43 04             	mov    0x4(%ebx),%eax
801013b7:	83 c4 10             	add    $0x10,%esp
801013ba:	85 c0                	test   %eax,%eax
801013bc:	7e 1a                	jle    801013d8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801013be:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801013c1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801013c4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801013c7:	68 60 ff 10 80       	push   $0x8010ff60
801013cc:	e8 4f 36 00 00       	call   80104a20 <release>
  return f;
}
801013d1:	89 d8                	mov    %ebx,%eax
801013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d6:	c9                   	leave
801013d7:	c3                   	ret
    panic("filedup");
801013d8:	83 ec 0c             	sub    $0xc,%esp
801013db:	68 c3 76 10 80       	push   $0x801076c3
801013e0:	e8 8b ef ff ff       	call   80100370 <panic>
801013e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013ec:	00 
801013ed:	8d 76 00             	lea    0x0(%esi),%esi

801013f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	56                   	push   %esi
801013f5:	53                   	push   %ebx
801013f6:	83 ec 28             	sub    $0x28,%esp
801013f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013fc:	68 60 ff 10 80       	push   $0x8010ff60
80101401:	e8 7a 36 00 00       	call   80104a80 <acquire>
  if(f->ref < 1)
80101406:	8b 53 04             	mov    0x4(%ebx),%edx
80101409:	83 c4 10             	add    $0x10,%esp
8010140c:	85 d2                	test   %edx,%edx
8010140e:	0f 8e a5 00 00 00    	jle    801014b9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101414:	83 ea 01             	sub    $0x1,%edx
80101417:	89 53 04             	mov    %edx,0x4(%ebx)
8010141a:	75 44                	jne    80101460 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010141c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101420:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101423:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101425:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010142b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010142e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101431:	8b 43 10             	mov    0x10(%ebx),%eax
80101434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101437:	68 60 ff 10 80       	push   $0x8010ff60
8010143c:	e8 df 35 00 00       	call   80104a20 <release>

  if(ff.type == FD_PIPE)
80101441:	83 c4 10             	add    $0x10,%esp
80101444:	83 ff 01             	cmp    $0x1,%edi
80101447:	74 57                	je     801014a0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101449:	83 ff 02             	cmp    $0x2,%edi
8010144c:	74 2a                	je     80101478 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010144e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101451:	5b                   	pop    %ebx
80101452:	5e                   	pop    %esi
80101453:	5f                   	pop    %edi
80101454:	5d                   	pop    %ebp
80101455:	c3                   	ret
80101456:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010145d:	00 
8010145e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101460:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101467:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010146a:	5b                   	pop    %ebx
8010146b:	5e                   	pop    %esi
8010146c:	5f                   	pop    %edi
8010146d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010146e:	e9 ad 35 00 00       	jmp    80104a20 <release>
80101473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101478:	e8 a3 1d 00 00       	call   80103220 <begin_op>
    iput(ff.ip);
8010147d:	83 ec 0c             	sub    $0xc,%esp
80101480:	ff 75 e0             	push   -0x20(%ebp)
80101483:	e8 28 09 00 00       	call   80101db0 <iput>
    end_op();
80101488:	83 c4 10             	add    $0x10,%esp
}
8010148b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010148e:	5b                   	pop    %ebx
8010148f:	5e                   	pop    %esi
80101490:	5f                   	pop    %edi
80101491:	5d                   	pop    %ebp
    end_op();
80101492:	e9 f9 1d 00 00       	jmp    80103290 <end_op>
80101497:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149e:	00 
8010149f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
801014a0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014a4:	83 ec 08             	sub    $0x8,%esp
801014a7:	53                   	push   %ebx
801014a8:	56                   	push   %esi
801014a9:	e8 32 25 00 00       	call   801039e0 <pipeclose>
801014ae:	83 c4 10             	add    $0x10,%esp
}
801014b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b4:	5b                   	pop    %ebx
801014b5:	5e                   	pop    %esi
801014b6:	5f                   	pop    %edi
801014b7:	5d                   	pop    %ebp
801014b8:	c3                   	ret
    panic("fileclose");
801014b9:	83 ec 0c             	sub    $0xc,%esp
801014bc:	68 cb 76 10 80       	push   $0x801076cb
801014c1:	e8 aa ee ff ff       	call   80100370 <panic>
801014c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014cd:	00 
801014ce:	66 90                	xchg   %ax,%ax

801014d0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	53                   	push   %ebx
801014d4:	83 ec 04             	sub    $0x4,%esp
801014d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801014da:	83 3b 02             	cmpl   $0x2,(%ebx)
801014dd:	75 31                	jne    80101510 <filestat+0x40>
    ilock(f->ip);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 73 10             	push   0x10(%ebx)
801014e5:	e8 96 07 00 00       	call   80101c80 <ilock>
    stati(f->ip, st);
801014ea:	58                   	pop    %eax
801014eb:	5a                   	pop    %edx
801014ec:	ff 75 0c             	push   0xc(%ebp)
801014ef:	ff 73 10             	push   0x10(%ebx)
801014f2:	e8 69 0a 00 00       	call   80101f60 <stati>
    iunlock(f->ip);
801014f7:	59                   	pop    %ecx
801014f8:	ff 73 10             	push   0x10(%ebx)
801014fb:	e8 60 08 00 00       	call   80101d60 <iunlock>
    return 0;
  }
  return -1;
}
80101500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101503:	83 c4 10             	add    $0x10,%esp
80101506:	31 c0                	xor    %eax,%eax
}
80101508:	c9                   	leave
80101509:	c3                   	ret
8010150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101510:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101518:	c9                   	leave
80101519:	c3                   	ret
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101520 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 0c             	sub    $0xc,%esp
80101529:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010152c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010152f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101532:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101536:	74 60                	je     80101598 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101538:	8b 03                	mov    (%ebx),%eax
8010153a:	83 f8 01             	cmp    $0x1,%eax
8010153d:	74 41                	je     80101580 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010153f:	83 f8 02             	cmp    $0x2,%eax
80101542:	75 5b                	jne    8010159f <fileread+0x7f>
    ilock(f->ip);
80101544:	83 ec 0c             	sub    $0xc,%esp
80101547:	ff 73 10             	push   0x10(%ebx)
8010154a:	e8 31 07 00 00       	call   80101c80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010154f:	57                   	push   %edi
80101550:	ff 73 14             	push   0x14(%ebx)
80101553:	56                   	push   %esi
80101554:	ff 73 10             	push   0x10(%ebx)
80101557:	e8 34 0a 00 00       	call   80101f90 <readi>
8010155c:	83 c4 20             	add    $0x20,%esp
8010155f:	89 c6                	mov    %eax,%esi
80101561:	85 c0                	test   %eax,%eax
80101563:	7e 03                	jle    80101568 <fileread+0x48>
      f->off += r;
80101565:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101568:	83 ec 0c             	sub    $0xc,%esp
8010156b:	ff 73 10             	push   0x10(%ebx)
8010156e:	e8 ed 07 00 00       	call   80101d60 <iunlock>
    return r;
80101573:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101576:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101579:	89 f0                	mov    %esi,%eax
8010157b:	5b                   	pop    %ebx
8010157c:	5e                   	pop    %esi
8010157d:	5f                   	pop    %edi
8010157e:	5d                   	pop    %ebp
8010157f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101580:	8b 43 0c             	mov    0xc(%ebx),%eax
80101583:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101589:	5b                   	pop    %ebx
8010158a:	5e                   	pop    %esi
8010158b:	5f                   	pop    %edi
8010158c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010158d:	e9 0e 26 00 00       	jmp    80103ba0 <piperead>
80101592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101598:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010159d:	eb d7                	jmp    80101576 <fileread+0x56>
  panic("fileread");
8010159f:	83 ec 0c             	sub    $0xc,%esp
801015a2:	68 d5 76 10 80       	push   $0x801076d5
801015a7:	e8 c4 ed ff ff       	call   80100370 <panic>
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
801015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801015bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801015c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801015c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801015cc:	0f 84 bb 00 00 00    	je     8010168d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801015d2:	8b 03                	mov    (%ebx),%eax
801015d4:	83 f8 01             	cmp    $0x1,%eax
801015d7:	0f 84 bf 00 00 00    	je     8010169c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015dd:	83 f8 02             	cmp    $0x2,%eax
801015e0:	0f 85 c8 00 00 00    	jne    801016ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801015eb:	85 c0                	test   %eax,%eax
801015ed:	7f 30                	jg     8010161f <filewrite+0x6f>
801015ef:	e9 94 00 00 00       	jmp    80101688 <filewrite+0xd8>
801015f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801015f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801015fb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801015fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101601:	ff 73 10             	push   0x10(%ebx)
80101604:	e8 57 07 00 00       	call   80101d60 <iunlock>
      end_op();
80101609:	e8 82 1c 00 00       	call   80103290 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010160e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101611:	83 c4 10             	add    $0x10,%esp
80101614:	39 c7                	cmp    %eax,%edi
80101616:	75 5c                	jne    80101674 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101618:	01 fe                	add    %edi,%esi
    while(i < n){
8010161a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010161d:	7e 69                	jle    80101688 <filewrite+0xd8>
      int n1 = n - i;
8010161f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101622:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101627:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101629:	39 c7                	cmp    %eax,%edi
8010162b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010162e:	e8 ed 1b 00 00       	call   80103220 <begin_op>
      ilock(f->ip);
80101633:	83 ec 0c             	sub    $0xc,%esp
80101636:	ff 73 10             	push   0x10(%ebx)
80101639:	e8 42 06 00 00       	call   80101c80 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010163e:	57                   	push   %edi
8010163f:	ff 73 14             	push   0x14(%ebx)
80101642:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101645:	01 f0                	add    %esi,%eax
80101647:	50                   	push   %eax
80101648:	ff 73 10             	push   0x10(%ebx)
8010164b:	e8 40 0a 00 00       	call   80102090 <writei>
80101650:	83 c4 20             	add    $0x20,%esp
80101653:	85 c0                	test   %eax,%eax
80101655:	7f a1                	jg     801015f8 <filewrite+0x48>
80101657:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010165a:	83 ec 0c             	sub    $0xc,%esp
8010165d:	ff 73 10             	push   0x10(%ebx)
80101660:	e8 fb 06 00 00       	call   80101d60 <iunlock>
      end_op();
80101665:	e8 26 1c 00 00       	call   80103290 <end_op>
      if(r < 0)
8010166a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010166d:	83 c4 10             	add    $0x10,%esp
80101670:	85 c0                	test   %eax,%eax
80101672:	75 14                	jne    80101688 <filewrite+0xd8>
        panic("short filewrite");
80101674:	83 ec 0c             	sub    $0xc,%esp
80101677:	68 de 76 10 80       	push   $0x801076de
8010167c:	e8 ef ec ff ff       	call   80100370 <panic>
80101681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101688:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010168b:	74 05                	je     80101692 <filewrite+0xe2>
8010168d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101695:	89 f0                	mov    %esi,%eax
80101697:	5b                   	pop    %ebx
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
8010169b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010169c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010169f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a5:	5b                   	pop    %ebx
801016a6:	5e                   	pop    %esi
801016a7:	5f                   	pop    %edi
801016a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801016a9:	e9 d2 23 00 00       	jmp    80103a80 <pipewrite>
  panic("filewrite");
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	68 e4 76 10 80       	push   $0x801076e4
801016b6:	e8 b5 ec ff ff       	call   80100370 <panic>
801016bb:	66 90                	xchg   %ax,%ax
801016bd:	66 90                	xchg   %ax,%ax
801016bf:	90                   	nop

801016c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	57                   	push   %edi
801016c4:	56                   	push   %esi
801016c5:	53                   	push   %ebx
801016c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016c9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801016cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016d2:	85 c9                	test   %ecx,%ecx
801016d4:	0f 84 8c 00 00 00    	je     80101766 <balloc+0xa6>
801016da:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801016dc:	89 f8                	mov    %edi,%eax
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	89 fe                	mov    %edi,%esi
801016e3:	c1 f8 0c             	sar    $0xc,%eax
801016e6:	03 05 cc 25 11 80    	add    0x801125cc,%eax
801016ec:	50                   	push   %eax
801016ed:	ff 75 dc             	push   -0x24(%ebp)
801016f0:	e8 db e9 ff ff       	call   801000d0 <bread>
801016f5:	83 c4 10             	add    $0x10,%esp
801016f8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016fe:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101703:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101706:	31 c0                	xor    %eax,%eax
80101708:	eb 32                	jmp    8010173c <balloc+0x7c>
8010170a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101710:	89 c1                	mov    %eax,%ecx
80101712:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101717:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010171a:	83 e1 07             	and    $0x7,%ecx
8010171d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010171f:	89 c1                	mov    %eax,%ecx
80101721:	c1 f9 03             	sar    $0x3,%ecx
80101724:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101729:	89 fa                	mov    %edi,%edx
8010172b:	85 df                	test   %ebx,%edi
8010172d:	74 49                	je     80101778 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010172f:	83 c0 01             	add    $0x1,%eax
80101732:	83 c6 01             	add    $0x1,%esi
80101735:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010173a:	74 07                	je     80101743 <balloc+0x83>
8010173c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010173f:	39 d6                	cmp    %edx,%esi
80101741:	72 cd                	jb     80101710 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101743:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101746:	83 ec 0c             	sub    $0xc,%esp
80101749:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010174c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101752:	e8 99 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101757:	83 c4 10             	add    $0x10,%esp
8010175a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101760:	0f 82 76 ff ff ff    	jb     801016dc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101766:	83 ec 0c             	sub    $0xc,%esp
80101769:	68 ee 76 10 80       	push   $0x801076ee
8010176e:	e8 fd eb ff ff       	call   80100370 <panic>
80101773:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101778:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010177b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010177e:	09 da                	or     %ebx,%edx
80101780:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101784:	57                   	push   %edi
80101785:	e8 76 1c 00 00       	call   80103400 <log_write>
        brelse(bp);
8010178a:	89 3c 24             	mov    %edi,(%esp)
8010178d:	e8 5e ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101792:	58                   	pop    %eax
80101793:	5a                   	pop    %edx
80101794:	56                   	push   %esi
80101795:	ff 75 dc             	push   -0x24(%ebp)
80101798:	e8 33 e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010179d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017a0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017a2:	8d 40 5c             	lea    0x5c(%eax),%eax
801017a5:	68 00 02 00 00       	push   $0x200
801017aa:	6a 00                	push   $0x0
801017ac:	50                   	push   %eax
801017ad:	e8 ce 33 00 00       	call   80104b80 <memset>
  log_write(bp);
801017b2:	89 1c 24             	mov    %ebx,(%esp)
801017b5:	e8 46 1c 00 00       	call   80103400 <log_write>
  brelse(bp);
801017ba:	89 1c 24             	mov    %ebx,(%esp)
801017bd:	e8 2e ea ff ff       	call   801001f0 <brelse>
}
801017c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017c5:	89 f0                	mov    %esi,%eax
801017c7:	5b                   	pop    %ebx
801017c8:	5e                   	pop    %esi
801017c9:	5f                   	pop    %edi
801017ca:	5d                   	pop    %ebp
801017cb:	c3                   	ret
801017cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801017d4:	31 ff                	xor    %edi,%edi
{
801017d6:	56                   	push   %esi
801017d7:	89 c6                	mov    %eax,%esi
801017d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017da:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801017df:	83 ec 28             	sub    $0x28,%esp
801017e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801017e5:	68 60 09 11 80       	push   $0x80110960
801017ea:	e8 91 32 00 00       	call   80104a80 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801017f2:	83 c4 10             	add    $0x10,%esp
801017f5:	eb 1b                	jmp    80101812 <iget+0x42>
801017f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017fe:	00 
801017ff:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101800:	39 33                	cmp    %esi,(%ebx)
80101802:	74 6c                	je     80101870 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101804:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010180a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101810:	74 26                	je     80101838 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101812:	8b 43 08             	mov    0x8(%ebx),%eax
80101815:	85 c0                	test   %eax,%eax
80101817:	7f e7                	jg     80101800 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101819:	85 ff                	test   %edi,%edi
8010181b:	75 e7                	jne    80101804 <iget+0x34>
8010181d:	85 c0                	test   %eax,%eax
8010181f:	75 76                	jne    80101897 <iget+0xc7>
      empty = ip;
80101821:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101823:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101829:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010182f:	75 e1                	jne    80101812 <iget+0x42>
80101831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101838:	85 ff                	test   %edi,%edi
8010183a:	74 79                	je     801018b5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010183c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010183f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101841:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101844:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010184b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101852:	68 60 09 11 80       	push   $0x80110960
80101857:	e8 c4 31 00 00       	call   80104a20 <release>

  return ip;
8010185c:	83 c4 10             	add    $0x10,%esp
}
8010185f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101862:	89 f8                	mov    %edi,%eax
80101864:	5b                   	pop    %ebx
80101865:	5e                   	pop    %esi
80101866:	5f                   	pop    %edi
80101867:	5d                   	pop    %ebp
80101868:	c3                   	ret
80101869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101870:	39 53 04             	cmp    %edx,0x4(%ebx)
80101873:	75 8f                	jne    80101804 <iget+0x34>
      ip->ref++;
80101875:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101878:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010187b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010187d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101880:	68 60 09 11 80       	push   $0x80110960
80101885:	e8 96 31 00 00       	call   80104a20 <release>
      return ip;
8010188a:	83 c4 10             	add    $0x10,%esp
}
8010188d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101890:	89 f8                	mov    %edi,%eax
80101892:	5b                   	pop    %ebx
80101893:	5e                   	pop    %esi
80101894:	5f                   	pop    %edi
80101895:	5d                   	pop    %ebp
80101896:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101897:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010189d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801018a3:	74 10                	je     801018b5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018a5:	8b 43 08             	mov    0x8(%ebx),%eax
801018a8:	85 c0                	test   %eax,%eax
801018aa:	0f 8f 50 ff ff ff    	jg     80101800 <iget+0x30>
801018b0:	e9 68 ff ff ff       	jmp    8010181d <iget+0x4d>
    panic("iget: no inodes");
801018b5:	83 ec 0c             	sub    $0xc,%esp
801018b8:	68 04 77 10 80       	push   $0x80107704
801018bd:	e8 ae ea ff ff       	call   80100370 <panic>
801018c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c9:	00 
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018d0 <bfree>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801018d3:	89 d0                	mov    %edx,%eax
801018d5:	c1 e8 0c             	shr    $0xc,%eax
{
801018d8:	89 e5                	mov    %esp,%ebp
801018da:	56                   	push   %esi
801018db:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801018dc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801018e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801018e4:	83 ec 08             	sub    $0x8,%esp
801018e7:	50                   	push   %eax
801018e8:	51                   	push   %ecx
801018e9:	e8 e2 e7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801018ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801018f0:	c1 fb 03             	sar    $0x3,%ebx
801018f3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801018f6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801018f8:	83 e1 07             	and    $0x7,%ecx
801018fb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101900:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101906:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101908:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010190d:	85 c1                	test   %eax,%ecx
8010190f:	74 23                	je     80101934 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101911:	f7 d0                	not    %eax
  log_write(bp);
80101913:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101916:	21 c8                	and    %ecx,%eax
80101918:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010191c:	56                   	push   %esi
8010191d:	e8 de 1a 00 00       	call   80103400 <log_write>
  brelse(bp);
80101922:	89 34 24             	mov    %esi,(%esp)
80101925:	e8 c6 e8 ff ff       	call   801001f0 <brelse>
}
8010192a:	83 c4 10             	add    $0x10,%esp
8010192d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101930:	5b                   	pop    %ebx
80101931:	5e                   	pop    %esi
80101932:	5d                   	pop    %ebp
80101933:	c3                   	ret
    panic("freeing free block");
80101934:	83 ec 0c             	sub    $0xc,%esp
80101937:	68 14 77 10 80       	push   $0x80107714
8010193c:	e8 2f ea ff ff       	call   80100370 <panic>
80101941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101948:	00 
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101950 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	89 c6                	mov    %eax,%esi
80101957:	53                   	push   %ebx
80101958:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010195b:	83 fa 0b             	cmp    $0xb,%edx
8010195e:	0f 86 8c 00 00 00    	jbe    801019f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101964:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101967:	83 fb 7f             	cmp    $0x7f,%ebx
8010196a:	0f 87 a2 00 00 00    	ja     80101a12 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101970:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101976:	85 c0                	test   %eax,%eax
80101978:	74 5e                	je     801019d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010197a:	83 ec 08             	sub    $0x8,%esp
8010197d:	50                   	push   %eax
8010197e:	ff 36                	push   (%esi)
80101980:	e8 4b e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010198c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010198e:	8b 3b                	mov    (%ebx),%edi
80101990:	85 ff                	test   %edi,%edi
80101992:	74 1c                	je     801019b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101994:	83 ec 0c             	sub    $0xc,%esp
80101997:	52                   	push   %edx
80101998:	e8 53 e8 ff ff       	call   801001f0 <brelse>
8010199d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801019a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a3:	89 f8                	mov    %edi,%eax
801019a5:	5b                   	pop    %ebx
801019a6:	5e                   	pop    %esi
801019a7:	5f                   	pop    %edi
801019a8:	5d                   	pop    %ebp
801019a9:	c3                   	ret
801019aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801019b3:	8b 06                	mov    (%esi),%eax
801019b5:	e8 06 fd ff ff       	call   801016c0 <balloc>
      log_write(bp);
801019ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801019c0:	89 03                	mov    %eax,(%ebx)
801019c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801019c4:	52                   	push   %edx
801019c5:	e8 36 1a 00 00       	call   80103400 <log_write>
801019ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019cd:	83 c4 10             	add    $0x10,%esp
801019d0:	eb c2                	jmp    80101994 <bmap+0x44>
801019d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801019d8:	8b 06                	mov    (%esi),%eax
801019da:	e8 e1 fc ff ff       	call   801016c0 <balloc>
801019df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801019e5:	eb 93                	jmp    8010197a <bmap+0x2a>
801019e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019ee:	00 
801019ef:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801019f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801019f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801019f7:	85 ff                	test   %edi,%edi
801019f9:	75 a5                	jne    801019a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019fb:	8b 00                	mov    (%eax),%eax
801019fd:	e8 be fc ff ff       	call   801016c0 <balloc>
80101a02:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101a06:	89 c7                	mov    %eax,%edi
}
80101a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0b:	5b                   	pop    %ebx
80101a0c:	89 f8                	mov    %edi,%eax
80101a0e:	5e                   	pop    %esi
80101a0f:	5f                   	pop    %edi
80101a10:	5d                   	pop    %ebp
80101a11:	c3                   	ret
  panic("bmap: out of range");
80101a12:	83 ec 0c             	sub    $0xc,%esp
80101a15:	68 27 77 10 80       	push   $0x80107727
80101a1a:	e8 51 e9 ff ff       	call   80100370 <panic>
80101a1f:	90                   	nop

80101a20 <readsb>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a28:	83 ec 08             	sub    $0x8,%esp
80101a2b:	6a 01                	push   $0x1
80101a2d:	ff 75 08             	push   0x8(%ebp)
80101a30:	e8 9b e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a35:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a38:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a3a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a3d:	6a 1c                	push   $0x1c
80101a3f:	50                   	push   %eax
80101a40:	56                   	push   %esi
80101a41:	e8 ca 31 00 00       	call   80104c10 <memmove>
  brelse(bp);
80101a46:	83 c4 10             	add    $0x10,%esp
80101a49:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a4f:	5b                   	pop    %ebx
80101a50:	5e                   	pop    %esi
80101a51:	5d                   	pop    %ebp
  brelse(bp);
80101a52:	e9 99 e7 ff ff       	jmp    801001f0 <brelse>
80101a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a5e:	00 
80101a5f:	90                   	nop

80101a60 <iinit>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	53                   	push   %ebx
80101a64:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101a69:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a6c:	68 3a 77 10 80       	push   $0x8010773a
80101a71:	68 60 09 11 80       	push   $0x80110960
80101a76:	e8 15 2e 00 00       	call   80104890 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a7b:	83 c4 10             	add    $0x10,%esp
80101a7e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a80:	83 ec 08             	sub    $0x8,%esp
80101a83:	68 41 77 10 80       	push   $0x80107741
80101a88:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a89:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a8f:	e8 cc 2c 00 00       	call   80104760 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a94:	83 c4 10             	add    $0x10,%esp
80101a97:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
80101a9d:	75 e1                	jne    80101a80 <iinit+0x20>
  bp = bread(dev, 1);
80101a9f:	83 ec 08             	sub    $0x8,%esp
80101aa2:	6a 01                	push   $0x1
80101aa4:	ff 75 08             	push   0x8(%ebp)
80101aa7:	e8 24 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101aac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101aaf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101ab1:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ab4:	6a 1c                	push   $0x1c
80101ab6:	50                   	push   %eax
80101ab7:	68 b4 25 11 80       	push   $0x801125b4
80101abc:	e8 4f 31 00 00       	call   80104c10 <memmove>
  brelse(bp);
80101ac1:	89 1c 24             	mov    %ebx,(%esp)
80101ac4:	e8 27 e7 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ac9:	ff 35 cc 25 11 80    	push   0x801125cc
80101acf:	ff 35 c8 25 11 80    	push   0x801125c8
80101ad5:	ff 35 c4 25 11 80    	push   0x801125c4
80101adb:	ff 35 c0 25 11 80    	push   0x801125c0
80101ae1:	ff 35 bc 25 11 80    	push   0x801125bc
80101ae7:	ff 35 b8 25 11 80    	push   0x801125b8
80101aed:	ff 35 b4 25 11 80    	push   0x801125b4
80101af3:	68 ac 7b 10 80       	push   $0x80107bac
80101af8:	e8 53 ec ff ff       	call   80100750 <cprintf>
}
80101afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b00:	83 c4 30             	add    $0x30,%esp
80101b03:	c9                   	leave
80101b04:	c3                   	ret
80101b05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b0c:	00 
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi

80101b10 <ialloc>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101b1c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101b23:	8b 75 08             	mov    0x8(%ebp),%esi
80101b26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b29:	0f 86 91 00 00 00    	jbe    80101bc0 <ialloc+0xb0>
80101b2f:	bf 01 00 00 00       	mov    $0x1,%edi
80101b34:	eb 21                	jmp    80101b57 <ialloc+0x47>
80101b36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b3d:	00 
80101b3e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101b40:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b43:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b46:	53                   	push   %ebx
80101b47:	e8 a4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b4c:	83 c4 10             	add    $0x10,%esp
80101b4f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101b55:	73 69                	jae    80101bc0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b57:	89 f8                	mov    %edi,%eax
80101b59:	83 ec 08             	sub    $0x8,%esp
80101b5c:	c1 e8 03             	shr    $0x3,%eax
80101b5f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101b65:	50                   	push   %eax
80101b66:	56                   	push   %esi
80101b67:	e8 64 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b6c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b6f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b71:	89 f8                	mov    %edi,%eax
80101b73:	83 e0 07             	and    $0x7,%eax
80101b76:	c1 e0 06             	shl    $0x6,%eax
80101b79:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b7d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b81:	75 bd                	jne    80101b40 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b83:	83 ec 04             	sub    $0x4,%esp
80101b86:	6a 40                	push   $0x40
80101b88:	6a 00                	push   $0x0
80101b8a:	51                   	push   %ecx
80101b8b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b8e:	e8 ed 2f 00 00       	call   80104b80 <memset>
      dip->type = type;
80101b93:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b97:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b9a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b9d:	89 1c 24             	mov    %ebx,(%esp)
80101ba0:	e8 5b 18 00 00       	call   80103400 <log_write>
      brelse(bp);
80101ba5:	89 1c 24             	mov    %ebx,(%esp)
80101ba8:	e8 43 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101bad:	83 c4 10             	add    $0x10,%esp
}
80101bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101bb3:	89 fa                	mov    %edi,%edx
}
80101bb5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101bb6:	89 f0                	mov    %esi,%eax
}
80101bb8:	5e                   	pop    %esi
80101bb9:	5f                   	pop    %edi
80101bba:	5d                   	pop    %ebp
      return iget(dev, inum);
80101bbb:	e9 10 fc ff ff       	jmp    801017d0 <iget>
  panic("ialloc: no inodes");
80101bc0:	83 ec 0c             	sub    $0xc,%esp
80101bc3:	68 47 77 10 80       	push   $0x80107747
80101bc8:	e8 a3 e7 ff ff       	call   80100370 <panic>
80101bcd:	8d 76 00             	lea    0x0(%esi),%esi

80101bd0 <iupdate>:
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bd8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bdb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bde:	83 ec 08             	sub    $0x8,%esp
80101be1:	c1 e8 03             	shr    $0x3,%eax
80101be4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101bea:	50                   	push   %eax
80101beb:	ff 73 a4             	push   -0x5c(%ebx)
80101bee:	e8 dd e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101bf3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bf7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bfa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bfc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bff:	83 e0 07             	and    $0x7,%eax
80101c02:	c1 e0 06             	shl    $0x6,%eax
80101c05:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101c09:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c0c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c10:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c13:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c17:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c1b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c1f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c23:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c27:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c2a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c2d:	6a 34                	push   $0x34
80101c2f:	53                   	push   %ebx
80101c30:	50                   	push   %eax
80101c31:	e8 da 2f 00 00       	call   80104c10 <memmove>
  log_write(bp);
80101c36:	89 34 24             	mov    %esi,(%esp)
80101c39:	e8 c2 17 00 00       	call   80103400 <log_write>
  brelse(bp);
80101c3e:	83 c4 10             	add    $0x10,%esp
80101c41:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5d                   	pop    %ebp
  brelse(bp);
80101c4a:	e9 a1 e5 ff ff       	jmp    801001f0 <brelse>
80101c4f:	90                   	nop

80101c50 <idup>:
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	53                   	push   %ebx
80101c54:	83 ec 10             	sub    $0x10,%esp
80101c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c5a:	68 60 09 11 80       	push   $0x80110960
80101c5f:	e8 1c 2e 00 00       	call   80104a80 <acquire>
  ip->ref++;
80101c64:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c68:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101c6f:	e8 ac 2d 00 00       	call   80104a20 <release>
}
80101c74:	89 d8                	mov    %ebx,%eax
80101c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c79:	c9                   	leave
80101c7a:	c3                   	ret
80101c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101c80 <ilock>:
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	56                   	push   %esi
80101c84:	53                   	push   %ebx
80101c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c88:	85 db                	test   %ebx,%ebx
80101c8a:	0f 84 b7 00 00 00    	je     80101d47 <ilock+0xc7>
80101c90:	8b 53 08             	mov    0x8(%ebx),%edx
80101c93:	85 d2                	test   %edx,%edx
80101c95:	0f 8e ac 00 00 00    	jle    80101d47 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
80101c9e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ca1:	50                   	push   %eax
80101ca2:	e8 f9 2a 00 00       	call   801047a0 <acquiresleep>
  if(ip->valid == 0){
80101ca7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101caa:	83 c4 10             	add    $0x10,%esp
80101cad:	85 c0                	test   %eax,%eax
80101caf:	74 0f                	je     80101cc0 <ilock+0x40>
}
80101cb1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cb4:	5b                   	pop    %ebx
80101cb5:	5e                   	pop    %esi
80101cb6:	5d                   	pop    %ebp
80101cb7:	c3                   	ret
80101cb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cbf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cc0:	8b 43 04             	mov    0x4(%ebx),%eax
80101cc3:	83 ec 08             	sub    $0x8,%esp
80101cc6:	c1 e8 03             	shr    $0x3,%eax
80101cc9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101ccf:	50                   	push   %eax
80101cd0:	ff 33                	push   (%ebx)
80101cd2:	e8 f9 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cd7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cda:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cdc:	8b 43 04             	mov    0x4(%ebx),%eax
80101cdf:	83 e0 07             	and    $0x7,%eax
80101ce2:	c1 e0 06             	shl    $0x6,%eax
80101ce5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ce9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101cef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cf3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cf7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cfb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101cff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d03:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d07:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d0b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d0e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d11:	6a 34                	push   $0x34
80101d13:	50                   	push   %eax
80101d14:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d17:	50                   	push   %eax
80101d18:	e8 f3 2e 00 00       	call   80104c10 <memmove>
    brelse(bp);
80101d1d:	89 34 24             	mov    %esi,(%esp)
80101d20:	e8 cb e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d2d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d34:	0f 85 77 ff ff ff    	jne    80101cb1 <ilock+0x31>
      panic("ilock: no type");
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	68 5f 77 10 80       	push   $0x8010775f
80101d42:	e8 29 e6 ff ff       	call   80100370 <panic>
    panic("ilock");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 59 77 10 80       	push   $0x80107759
80101d4f:	e8 1c e6 ff ff       	call   80100370 <panic>
80101d54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d5b:	00 
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d60 <iunlock>:
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	56                   	push   %esi
80101d64:	53                   	push   %ebx
80101d65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d68:	85 db                	test   %ebx,%ebx
80101d6a:	74 28                	je     80101d94 <iunlock+0x34>
80101d6c:	83 ec 0c             	sub    $0xc,%esp
80101d6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d72:	56                   	push   %esi
80101d73:	e8 c8 2a 00 00       	call   80104840 <holdingsleep>
80101d78:	83 c4 10             	add    $0x10,%esp
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	74 15                	je     80101d94 <iunlock+0x34>
80101d7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d82:	85 c0                	test   %eax,%eax
80101d84:	7e 0e                	jle    80101d94 <iunlock+0x34>
  releasesleep(&ip->lock);
80101d86:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d8c:	5b                   	pop    %ebx
80101d8d:	5e                   	pop    %esi
80101d8e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d8f:	e9 6c 2a 00 00       	jmp    80104800 <releasesleep>
    panic("iunlock");
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	68 6e 77 10 80       	push   $0x8010776e
80101d9c:	e8 cf e5 ff ff       	call   80100370 <panic>
80101da1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101da8:	00 
80101da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101db0 <iput>:
{
80101db0:	55                   	push   %ebp
80101db1:	89 e5                	mov    %esp,%ebp
80101db3:	57                   	push   %edi
80101db4:	56                   	push   %esi
80101db5:	53                   	push   %ebx
80101db6:	83 ec 28             	sub    $0x28,%esp
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101dbc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101dbf:	57                   	push   %edi
80101dc0:	e8 db 29 00 00       	call   801047a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101dc5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101dc8:	83 c4 10             	add    $0x10,%esp
80101dcb:	85 d2                	test   %edx,%edx
80101dcd:	74 07                	je     80101dd6 <iput+0x26>
80101dcf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101dd4:	74 32                	je     80101e08 <iput+0x58>
  releasesleep(&ip->lock);
80101dd6:	83 ec 0c             	sub    $0xc,%esp
80101dd9:	57                   	push   %edi
80101dda:	e8 21 2a 00 00       	call   80104800 <releasesleep>
  acquire(&icache.lock);
80101ddf:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101de6:	e8 95 2c 00 00       	call   80104a80 <acquire>
  ip->ref--;
80101deb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101def:	83 c4 10             	add    $0x10,%esp
80101df2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101df9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfc:	5b                   	pop    %ebx
80101dfd:	5e                   	pop    %esi
80101dfe:	5f                   	pop    %edi
80101dff:	5d                   	pop    %ebp
  release(&icache.lock);
80101e00:	e9 1b 2c 00 00       	jmp    80104a20 <release>
80101e05:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101e08:	83 ec 0c             	sub    $0xc,%esp
80101e0b:	68 60 09 11 80       	push   $0x80110960
80101e10:	e8 6b 2c 00 00       	call   80104a80 <acquire>
    int r = ip->ref;
80101e15:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e18:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e1f:	e8 fc 2b 00 00       	call   80104a20 <release>
    if(r == 1){
80101e24:	83 c4 10             	add    $0x10,%esp
80101e27:	83 fe 01             	cmp    $0x1,%esi
80101e2a:	75 aa                	jne    80101dd6 <iput+0x26>
80101e2c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e32:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e35:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e38:	89 df                	mov    %ebx,%edi
80101e3a:	89 cb                	mov    %ecx,%ebx
80101e3c:	eb 09                	jmp    80101e47 <iput+0x97>
80101e3e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e40:	83 c6 04             	add    $0x4,%esi
80101e43:	39 de                	cmp    %ebx,%esi
80101e45:	74 19                	je     80101e60 <iput+0xb0>
    if(ip->addrs[i]){
80101e47:	8b 16                	mov    (%esi),%edx
80101e49:	85 d2                	test   %edx,%edx
80101e4b:	74 f3                	je     80101e40 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101e4d:	8b 07                	mov    (%edi),%eax
80101e4f:	e8 7c fa ff ff       	call   801018d0 <bfree>
      ip->addrs[i] = 0;
80101e54:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e5a:	eb e4                	jmp    80101e40 <iput+0x90>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e60:	89 fb                	mov    %edi,%ebx
80101e62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e65:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e6b:	85 c0                	test   %eax,%eax
80101e6d:	75 2d                	jne    80101e9c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e6f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e72:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e79:	53                   	push   %ebx
80101e7a:	e8 51 fd ff ff       	call   80101bd0 <iupdate>
      ip->type = 0;
80101e7f:	31 c0                	xor    %eax,%eax
80101e81:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e85:	89 1c 24             	mov    %ebx,(%esp)
80101e88:	e8 43 fd ff ff       	call   80101bd0 <iupdate>
      ip->valid = 0;
80101e8d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e94:	83 c4 10             	add    $0x10,%esp
80101e97:	e9 3a ff ff ff       	jmp    80101dd6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e9c:	83 ec 08             	sub    $0x8,%esp
80101e9f:	50                   	push   %eax
80101ea0:	ff 33                	push   (%ebx)
80101ea2:	e8 29 e2 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ead:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101eb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101eb6:	8d 70 5c             	lea    0x5c(%eax),%esi
80101eb9:	89 cf                	mov    %ecx,%edi
80101ebb:	eb 0a                	jmp    80101ec7 <iput+0x117>
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
80101ec0:	83 c6 04             	add    $0x4,%esi
80101ec3:	39 fe                	cmp    %edi,%esi
80101ec5:	74 0f                	je     80101ed6 <iput+0x126>
      if(a[j])
80101ec7:	8b 16                	mov    (%esi),%edx
80101ec9:	85 d2                	test   %edx,%edx
80101ecb:	74 f3                	je     80101ec0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101ecd:	8b 03                	mov    (%ebx),%eax
80101ecf:	e8 fc f9 ff ff       	call   801018d0 <bfree>
80101ed4:	eb ea                	jmp    80101ec0 <iput+0x110>
    brelse(bp);
80101ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed9:	83 ec 0c             	sub    $0xc,%esp
80101edc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101edf:	50                   	push   %eax
80101ee0:	e8 0b e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ee5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101eeb:	8b 03                	mov    (%ebx),%eax
80101eed:	e8 de f9 ff ff       	call   801018d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101efc:	00 00 00 
80101eff:	e9 6b ff ff ff       	jmp    80101e6f <iput+0xbf>
80101f04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f0b:	00 
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f10 <iunlockput>:
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	56                   	push   %esi
80101f14:	53                   	push   %ebx
80101f15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f18:	85 db                	test   %ebx,%ebx
80101f1a:	74 34                	je     80101f50 <iunlockput+0x40>
80101f1c:	83 ec 0c             	sub    $0xc,%esp
80101f1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101f22:	56                   	push   %esi
80101f23:	e8 18 29 00 00       	call   80104840 <holdingsleep>
80101f28:	83 c4 10             	add    $0x10,%esp
80101f2b:	85 c0                	test   %eax,%eax
80101f2d:	74 21                	je     80101f50 <iunlockput+0x40>
80101f2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101f32:	85 c0                	test   %eax,%eax
80101f34:	7e 1a                	jle    80101f50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101f36:	83 ec 0c             	sub    $0xc,%esp
80101f39:	56                   	push   %esi
80101f3a:	e8 c1 28 00 00       	call   80104800 <releasesleep>
  iput(ip);
80101f3f:	83 c4 10             	add    $0x10,%esp
80101f42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f48:	5b                   	pop    %ebx
80101f49:	5e                   	pop    %esi
80101f4a:	5d                   	pop    %ebp
  iput(ip);
80101f4b:	e9 60 fe ff ff       	jmp    80101db0 <iput>
    panic("iunlock");
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	68 6e 77 10 80       	push   $0x8010776e
80101f58:	e8 13 e4 ff ff       	call   80100370 <panic>
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi

80101f60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	8b 55 08             	mov    0x8(%ebp),%edx
80101f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f69:	8b 0a                	mov    (%edx),%ecx
80101f6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f83:	8b 52 58             	mov    0x58(%edx),%edx
80101f86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f89:	5d                   	pop    %ebp
80101f8a:	c3                   	ret
80101f8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101f90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 1c             	sub    $0x1c,%esp
80101f99:	8b 75 08             	mov    0x8(%ebp),%esi
80101f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fa2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101fa7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101faa:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101fad:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101fb0:	0f 84 aa 00 00 00    	je     80102060 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fb6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101fb9:	8b 56 58             	mov    0x58(%esi),%edx
80101fbc:	39 fa                	cmp    %edi,%edx
80101fbe:	0f 82 bd 00 00 00    	jb     80102081 <readi+0xf1>
80101fc4:	89 f9                	mov    %edi,%ecx
80101fc6:	31 db                	xor    %ebx,%ebx
80101fc8:	01 c1                	add    %eax,%ecx
80101fca:	0f 92 c3             	setb   %bl
80101fcd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101fd0:	0f 82 ab 00 00 00    	jb     80102081 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fd6:	89 d3                	mov    %edx,%ebx
80101fd8:	29 fb                	sub    %edi,%ebx
80101fda:	39 ca                	cmp    %ecx,%edx
80101fdc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fdf:	85 c0                	test   %eax,%eax
80101fe1:	74 73                	je     80102056 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ff0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ff3:	89 fa                	mov    %edi,%edx
80101ff5:	c1 ea 09             	shr    $0x9,%edx
80101ff8:	89 d8                	mov    %ebx,%eax
80101ffa:	e8 51 f9 ff ff       	call   80101950 <bmap>
80101fff:	83 ec 08             	sub    $0x8,%esp
80102002:	50                   	push   %eax
80102003:	ff 33                	push   (%ebx)
80102005:	e8 c6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010200a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010200d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102012:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102014:	89 f8                	mov    %edi,%eax
80102016:	25 ff 01 00 00       	and    $0x1ff,%eax
8010201b:	29 f3                	sub    %esi,%ebx
8010201d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
8010201f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102023:	39 d9                	cmp    %ebx,%ecx
80102025:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102028:	83 c4 0c             	add    $0xc,%esp
8010202b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010202c:	01 de                	add    %ebx,%esi
8010202e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102030:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102033:	50                   	push   %eax
80102034:	ff 75 e0             	push   -0x20(%ebp)
80102037:	e8 d4 2b 00 00       	call   80104c10 <memmove>
    brelse(bp);
8010203c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010203f:	89 14 24             	mov    %edx,(%esp)
80102042:	e8 a9 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102047:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010204a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010204d:	83 c4 10             	add    $0x10,%esp
80102050:	39 de                	cmp    %ebx,%esi
80102052:	72 9c                	jb     80101ff0 <readi+0x60>
80102054:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102059:	5b                   	pop    %ebx
8010205a:	5e                   	pop    %esi
8010205b:	5f                   	pop    %edi
8010205c:	5d                   	pop    %ebp
8010205d:	c3                   	ret
8010205e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102060:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102064:	66 83 fa 09          	cmp    $0x9,%dx
80102068:	77 17                	ja     80102081 <readi+0xf1>
8010206a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80102071:	85 d2                	test   %edx,%edx
80102073:	74 0c                	je     80102081 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102075:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010207f:	ff e2                	jmp    *%edx
      return -1;
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb ce                	jmp    80102056 <readi+0xc6>
80102088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010208f:	00 

80102090 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
80102099:	8b 45 08             	mov    0x8(%ebp),%eax
8010209c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010209f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020a7:	89 7d dc             	mov    %edi,-0x24(%ebp)
801020aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
801020ad:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801020b0:	0f 84 ba 00 00 00    	je     80102170 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020b6:	39 78 58             	cmp    %edi,0x58(%eax)
801020b9:	0f 82 ea 00 00 00    	jb     801021a9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020bf:	8b 75 e0             	mov    -0x20(%ebp),%esi
801020c2:	89 f2                	mov    %esi,%edx
801020c4:	01 fa                	add    %edi,%edx
801020c6:	0f 82 dd 00 00 00    	jb     801021a9 <writei+0x119>
801020cc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801020d2:	0f 87 d1 00 00 00    	ja     801021a9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d8:	85 f6                	test   %esi,%esi
801020da:	0f 84 85 00 00 00    	je     80102165 <writei+0xd5>
801020e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801020e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020f0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801020f3:	89 fa                	mov    %edi,%edx
801020f5:	c1 ea 09             	shr    $0x9,%edx
801020f8:	89 f0                	mov    %esi,%eax
801020fa:	e8 51 f8 ff ff       	call   80101950 <bmap>
801020ff:	83 ec 08             	sub    $0x8,%esp
80102102:	50                   	push   %eax
80102103:	ff 36                	push   (%esi)
80102105:	e8 c6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010210a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010210d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102110:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102115:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102117:	89 f8                	mov    %edi,%eax
80102119:	25 ff 01 00 00       	and    $0x1ff,%eax
8010211e:	29 d3                	sub    %edx,%ebx
80102120:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102122:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102126:	39 d9                	cmp    %ebx,%ecx
80102128:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010212b:	83 c4 0c             	add    $0xc,%esp
8010212e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010212f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102131:	ff 75 dc             	push   -0x24(%ebp)
80102134:	50                   	push   %eax
80102135:	e8 d6 2a 00 00       	call   80104c10 <memmove>
    log_write(bp);
8010213a:	89 34 24             	mov    %esi,(%esp)
8010213d:	e8 be 12 00 00       	call   80103400 <log_write>
    brelse(bp);
80102142:	89 34 24             	mov    %esi,(%esp)
80102145:	e8 a6 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010214a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010214d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102150:	83 c4 10             	add    $0x10,%esp
80102153:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102156:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102159:	39 d8                	cmp    %ebx,%eax
8010215b:	72 93                	jb     801020f0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010215d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102160:	39 78 58             	cmp    %edi,0x58(%eax)
80102163:	72 33                	jb     80102198 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102165:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102168:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216b:	5b                   	pop    %ebx
8010216c:	5e                   	pop    %esi
8010216d:	5f                   	pop    %edi
8010216e:	5d                   	pop    %ebp
8010216f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102170:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102174:	66 83 f8 09          	cmp    $0x9,%ax
80102178:	77 2f                	ja     801021a9 <writei+0x119>
8010217a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80102181:	85 c0                	test   %eax,%eax
80102183:	74 24                	je     801021a9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102185:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102188:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010218b:	5b                   	pop    %ebx
8010218c:	5e                   	pop    %esi
8010218d:	5f                   	pop    %edi
8010218e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010218f:	ff e0                	jmp    *%eax
80102191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102198:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010219b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010219e:	50                   	push   %eax
8010219f:	e8 2c fa ff ff       	call   80101bd0 <iupdate>
801021a4:	83 c4 10             	add    $0x10,%esp
801021a7:	eb bc                	jmp    80102165 <writei+0xd5>
      return -1;
801021a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021ae:	eb b8                	jmp    80102168 <writei+0xd8>

801021b0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021b6:	6a 0e                	push   $0xe
801021b8:	ff 75 0c             	push   0xc(%ebp)
801021bb:	ff 75 08             	push   0x8(%ebp)
801021be:	e8 bd 2a 00 00       	call   80104c80 <strncmp>
}
801021c3:	c9                   	leave
801021c4:	c3                   	ret
801021c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021cc:	00 
801021cd:	8d 76 00             	lea    0x0(%esi),%esi

801021d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 1c             	sub    $0x1c,%esp
801021d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021e1:	0f 85 85 00 00 00    	jne    8010226c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021e7:	8b 53 58             	mov    0x58(%ebx),%edx
801021ea:	31 ff                	xor    %edi,%edi
801021ec:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ef:	85 d2                	test   %edx,%edx
801021f1:	74 3e                	je     80102231 <dirlookup+0x61>
801021f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f8:	6a 10                	push   $0x10
801021fa:	57                   	push   %edi
801021fb:	56                   	push   %esi
801021fc:	53                   	push   %ebx
801021fd:	e8 8e fd ff ff       	call   80101f90 <readi>
80102202:	83 c4 10             	add    $0x10,%esp
80102205:	83 f8 10             	cmp    $0x10,%eax
80102208:	75 55                	jne    8010225f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010220a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010220f:	74 18                	je     80102229 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102211:	83 ec 04             	sub    $0x4,%esp
80102214:	8d 45 da             	lea    -0x26(%ebp),%eax
80102217:	6a 0e                	push   $0xe
80102219:	50                   	push   %eax
8010221a:	ff 75 0c             	push   0xc(%ebp)
8010221d:	e8 5e 2a 00 00       	call   80104c80 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102222:	83 c4 10             	add    $0x10,%esp
80102225:	85 c0                	test   %eax,%eax
80102227:	74 17                	je     80102240 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102229:	83 c7 10             	add    $0x10,%edi
8010222c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010222f:	72 c7                	jb     801021f8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102234:	31 c0                	xor    %eax,%eax
}
80102236:	5b                   	pop    %ebx
80102237:	5e                   	pop    %esi
80102238:	5f                   	pop    %edi
80102239:	5d                   	pop    %ebp
8010223a:	c3                   	ret
8010223b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80102240:	8b 45 10             	mov    0x10(%ebp),%eax
80102243:	85 c0                	test   %eax,%eax
80102245:	74 05                	je     8010224c <dirlookup+0x7c>
        *poff = off;
80102247:	8b 45 10             	mov    0x10(%ebp),%eax
8010224a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010224c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102250:	8b 03                	mov    (%ebx),%eax
80102252:	e8 79 f5 ff ff       	call   801017d0 <iget>
}
80102257:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225a:	5b                   	pop    %ebx
8010225b:	5e                   	pop    %esi
8010225c:	5f                   	pop    %edi
8010225d:	5d                   	pop    %ebp
8010225e:	c3                   	ret
      panic("dirlookup read");
8010225f:	83 ec 0c             	sub    $0xc,%esp
80102262:	68 88 77 10 80       	push   $0x80107788
80102267:	e8 04 e1 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
8010226c:	83 ec 0c             	sub    $0xc,%esp
8010226f:	68 76 77 10 80       	push   $0x80107776
80102274:	e8 f7 e0 ff ff       	call   80100370 <panic>
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102280 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	89 c3                	mov    %eax,%ebx
80102288:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010228b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010228e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102291:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102294:	0f 84 9e 01 00 00    	je     80102438 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010229a:	e8 a1 1b 00 00       	call   80103e40 <myproc>
  acquire(&icache.lock);
8010229f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801022a2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022a5:	68 60 09 11 80       	push   $0x80110960
801022aa:	e8 d1 27 00 00       	call   80104a80 <acquire>
  ip->ref++;
801022af:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022b3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801022ba:	e8 61 27 00 00       	call   80104a20 <release>
801022bf:	83 c4 10             	add    $0x10,%esp
801022c2:	eb 07                	jmp    801022cb <namex+0x4b>
801022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022c8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022cb:	0f b6 03             	movzbl (%ebx),%eax
801022ce:	3c 2f                	cmp    $0x2f,%al
801022d0:	74 f6                	je     801022c8 <namex+0x48>
  if(*path == 0)
801022d2:	84 c0                	test   %al,%al
801022d4:	0f 84 06 01 00 00    	je     801023e0 <namex+0x160>
  while(*path != '/' && *path != 0)
801022da:	0f b6 03             	movzbl (%ebx),%eax
801022dd:	84 c0                	test   %al,%al
801022df:	0f 84 10 01 00 00    	je     801023f5 <namex+0x175>
801022e5:	89 df                	mov    %ebx,%edi
801022e7:	3c 2f                	cmp    $0x2f,%al
801022e9:	0f 84 06 01 00 00    	je     801023f5 <namex+0x175>
801022ef:	90                   	nop
801022f0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801022f4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801022f7:	3c 2f                	cmp    $0x2f,%al
801022f9:	74 04                	je     801022ff <namex+0x7f>
801022fb:	84 c0                	test   %al,%al
801022fd:	75 f1                	jne    801022f0 <namex+0x70>
  len = path - s;
801022ff:	89 f8                	mov    %edi,%eax
80102301:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102303:	83 f8 0d             	cmp    $0xd,%eax
80102306:	0f 8e ac 00 00 00    	jle    801023b8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010230c:	83 ec 04             	sub    $0x4,%esp
8010230f:	6a 0e                	push   $0xe
80102311:	53                   	push   %ebx
80102312:	89 fb                	mov    %edi,%ebx
80102314:	ff 75 e4             	push   -0x1c(%ebp)
80102317:	e8 f4 28 00 00       	call   80104c10 <memmove>
8010231c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010231f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102322:	75 0c                	jne    80102330 <namex+0xb0>
80102324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102328:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010232b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010232e:	74 f8                	je     80102328 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	56                   	push   %esi
80102334:	e8 47 f9 ff ff       	call   80101c80 <ilock>
    if(ip->type != T_DIR){
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102341:	0f 85 b7 00 00 00    	jne    801023fe <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102347:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010234a:	85 c0                	test   %eax,%eax
8010234c:	74 09                	je     80102357 <namex+0xd7>
8010234e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102351:	0f 84 f7 00 00 00    	je     8010244e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102357:	83 ec 04             	sub    $0x4,%esp
8010235a:	6a 00                	push   $0x0
8010235c:	ff 75 e4             	push   -0x1c(%ebp)
8010235f:	56                   	push   %esi
80102360:	e8 6b fe ff ff       	call   801021d0 <dirlookup>
80102365:	83 c4 10             	add    $0x10,%esp
80102368:	89 c7                	mov    %eax,%edi
8010236a:	85 c0                	test   %eax,%eax
8010236c:	0f 84 8c 00 00 00    	je     801023fe <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102372:	83 ec 0c             	sub    $0xc,%esp
80102375:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102378:	51                   	push   %ecx
80102379:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010237c:	e8 bf 24 00 00       	call   80104840 <holdingsleep>
80102381:	83 c4 10             	add    $0x10,%esp
80102384:	85 c0                	test   %eax,%eax
80102386:	0f 84 02 01 00 00    	je     8010248e <namex+0x20e>
8010238c:	8b 56 08             	mov    0x8(%esi),%edx
8010238f:	85 d2                	test   %edx,%edx
80102391:	0f 8e f7 00 00 00    	jle    8010248e <namex+0x20e>
  releasesleep(&ip->lock);
80102397:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010239a:	83 ec 0c             	sub    $0xc,%esp
8010239d:	51                   	push   %ecx
8010239e:	e8 5d 24 00 00       	call   80104800 <releasesleep>
  iput(ip);
801023a3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
801023a6:	89 fe                	mov    %edi,%esi
  iput(ip);
801023a8:	e8 03 fa ff ff       	call   80101db0 <iput>
801023ad:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801023b0:	e9 16 ff ff ff       	jmp    801022cb <namex+0x4b>
801023b5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801023b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023bb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
801023be:	83 ec 04             	sub    $0x4,%esp
801023c1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801023c4:	50                   	push   %eax
801023c5:	53                   	push   %ebx
    name[len] = 0;
801023c6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801023c8:	ff 75 e4             	push   -0x1c(%ebp)
801023cb:	e8 40 28 00 00       	call   80104c10 <memmove>
    name[len] = 0;
801023d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	c6 01 00             	movb   $0x0,(%ecx)
801023d9:	e9 41 ff ff ff       	jmp    8010231f <namex+0x9f>
801023de:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801023e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023e3:	85 c0                	test   %eax,%eax
801023e5:	0f 85 93 00 00 00    	jne    8010247e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801023eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ee:	89 f0                	mov    %esi,%eax
801023f0:	5b                   	pop    %ebx
801023f1:	5e                   	pop    %esi
801023f2:	5f                   	pop    %edi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret
  while(*path != '/' && *path != 0)
801023f5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801023f8:	89 df                	mov    %ebx,%edi
801023fa:	31 c0                	xor    %eax,%eax
801023fc:	eb c0                	jmp    801023be <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801023fe:	83 ec 0c             	sub    $0xc,%esp
80102401:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102404:	53                   	push   %ebx
80102405:	e8 36 24 00 00       	call   80104840 <holdingsleep>
8010240a:	83 c4 10             	add    $0x10,%esp
8010240d:	85 c0                	test   %eax,%eax
8010240f:	74 7d                	je     8010248e <namex+0x20e>
80102411:	8b 4e 08             	mov    0x8(%esi),%ecx
80102414:	85 c9                	test   %ecx,%ecx
80102416:	7e 76                	jle    8010248e <namex+0x20e>
  releasesleep(&ip->lock);
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	53                   	push   %ebx
8010241c:	e8 df 23 00 00       	call   80104800 <releasesleep>
  iput(ip);
80102421:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102424:	31 f6                	xor    %esi,%esi
  iput(ip);
80102426:	e8 85 f9 ff ff       	call   80101db0 <iput>
      return 0;
8010242b:	83 c4 10             	add    $0x10,%esp
}
8010242e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102431:	89 f0                	mov    %esi,%eax
80102433:	5b                   	pop    %ebx
80102434:	5e                   	pop    %esi
80102435:	5f                   	pop    %edi
80102436:	5d                   	pop    %ebp
80102437:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102438:	ba 01 00 00 00       	mov    $0x1,%edx
8010243d:	b8 01 00 00 00       	mov    $0x1,%eax
80102442:	e8 89 f3 ff ff       	call   801017d0 <iget>
80102447:	89 c6                	mov    %eax,%esi
80102449:	e9 7d fe ff ff       	jmp    801022cb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010244e:	83 ec 0c             	sub    $0xc,%esp
80102451:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102454:	53                   	push   %ebx
80102455:	e8 e6 23 00 00       	call   80104840 <holdingsleep>
8010245a:	83 c4 10             	add    $0x10,%esp
8010245d:	85 c0                	test   %eax,%eax
8010245f:	74 2d                	je     8010248e <namex+0x20e>
80102461:	8b 7e 08             	mov    0x8(%esi),%edi
80102464:	85 ff                	test   %edi,%edi
80102466:	7e 26                	jle    8010248e <namex+0x20e>
  releasesleep(&ip->lock);
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	53                   	push   %ebx
8010246c:	e8 8f 23 00 00       	call   80104800 <releasesleep>
}
80102471:	83 c4 10             	add    $0x10,%esp
}
80102474:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102477:	89 f0                	mov    %esi,%eax
80102479:	5b                   	pop    %ebx
8010247a:	5e                   	pop    %esi
8010247b:	5f                   	pop    %edi
8010247c:	5d                   	pop    %ebp
8010247d:	c3                   	ret
    iput(ip);
8010247e:	83 ec 0c             	sub    $0xc,%esp
80102481:	56                   	push   %esi
      return 0;
80102482:	31 f6                	xor    %esi,%esi
    iput(ip);
80102484:	e8 27 f9 ff ff       	call   80101db0 <iput>
    return 0;
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	eb a0                	jmp    8010242e <namex+0x1ae>
    panic("iunlock");
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	68 6e 77 10 80       	push   $0x8010776e
80102496:	e8 d5 de ff ff       	call   80100370 <panic>
8010249b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801024a0 <dirlink>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	57                   	push   %edi
801024a4:	56                   	push   %esi
801024a5:	53                   	push   %ebx
801024a6:	83 ec 20             	sub    $0x20,%esp
801024a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024ac:	6a 00                	push   $0x0
801024ae:	ff 75 0c             	push   0xc(%ebp)
801024b1:	53                   	push   %ebx
801024b2:	e8 19 fd ff ff       	call   801021d0 <dirlookup>
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	85 c0                	test   %eax,%eax
801024bc:	75 67                	jne    80102525 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024be:	8b 7b 58             	mov    0x58(%ebx),%edi
801024c1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024c4:	85 ff                	test   %edi,%edi
801024c6:	74 29                	je     801024f1 <dirlink+0x51>
801024c8:	31 ff                	xor    %edi,%edi
801024ca:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024cd:	eb 09                	jmp    801024d8 <dirlink+0x38>
801024cf:	90                   	nop
801024d0:	83 c7 10             	add    $0x10,%edi
801024d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024d6:	73 19                	jae    801024f1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d8:	6a 10                	push   $0x10
801024da:	57                   	push   %edi
801024db:	56                   	push   %esi
801024dc:	53                   	push   %ebx
801024dd:	e8 ae fa ff ff       	call   80101f90 <readi>
801024e2:	83 c4 10             	add    $0x10,%esp
801024e5:	83 f8 10             	cmp    $0x10,%eax
801024e8:	75 4e                	jne    80102538 <dirlink+0x98>
    if(de.inum == 0)
801024ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024ef:	75 df                	jne    801024d0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801024f1:	83 ec 04             	sub    $0x4,%esp
801024f4:	8d 45 da             	lea    -0x26(%ebp),%eax
801024f7:	6a 0e                	push   $0xe
801024f9:	ff 75 0c             	push   0xc(%ebp)
801024fc:	50                   	push   %eax
801024fd:	e8 ce 27 00 00       	call   80104cd0 <strncpy>
  de.inum = inum;
80102502:	8b 45 10             	mov    0x10(%ebp),%eax
80102505:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102509:	6a 10                	push   $0x10
8010250b:	57                   	push   %edi
8010250c:	56                   	push   %esi
8010250d:	53                   	push   %ebx
8010250e:	e8 7d fb ff ff       	call   80102090 <writei>
80102513:	83 c4 20             	add    $0x20,%esp
80102516:	83 f8 10             	cmp    $0x10,%eax
80102519:	75 2a                	jne    80102545 <dirlink+0xa5>
  return 0;
8010251b:	31 c0                	xor    %eax,%eax
}
8010251d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102520:	5b                   	pop    %ebx
80102521:	5e                   	pop    %esi
80102522:	5f                   	pop    %edi
80102523:	5d                   	pop    %ebp
80102524:	c3                   	ret
    iput(ip);
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	50                   	push   %eax
80102529:	e8 82 f8 ff ff       	call   80101db0 <iput>
    return -1;
8010252e:	83 c4 10             	add    $0x10,%esp
80102531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102536:	eb e5                	jmp    8010251d <dirlink+0x7d>
      panic("dirlink read");
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	68 97 77 10 80       	push   $0x80107797
80102540:	e8 2b de ff ff       	call   80100370 <panic>
    panic("dirlink");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 f3 79 10 80       	push   $0x801079f3
8010254d:	e8 1e de ff ff       	call   80100370 <panic>
80102552:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102559:	00 
8010255a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102560 <namei>:

struct inode*
namei(char *path)
{
80102560:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102561:	31 d2                	xor    %edx,%edx
{
80102563:	89 e5                	mov    %esp,%ebp
80102565:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102568:	8b 45 08             	mov    0x8(%ebp),%eax
8010256b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010256e:	e8 0d fd ff ff       	call   80102280 <namex>
}
80102573:	c9                   	leave
80102574:	c3                   	ret
80102575:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010257c:	00 
8010257d:	8d 76 00             	lea    0x0(%esi),%esi

80102580 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102580:	55                   	push   %ebp
  return namex(path, 1, name);
80102581:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102586:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010258b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010258e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010258f:	e9 ec fc ff ff       	jmp    80102280 <namex>
80102594:	66 90                	xchg   %ax,%ax
80102596:	66 90                	xchg   %ax,%ax
80102598:	66 90                	xchg   %ax,%ax
8010259a:	66 90                	xchg   %ax,%ax
8010259c:	66 90                	xchg   %ax,%ax
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	57                   	push   %edi
801025a4:	56                   	push   %esi
801025a5:	53                   	push   %ebx
801025a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801025a9:	85 c0                	test   %eax,%eax
801025ab:	0f 84 b4 00 00 00    	je     80102665 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025b1:	8b 70 08             	mov    0x8(%eax),%esi
801025b4:	89 c3                	mov    %eax,%ebx
801025b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025bc:	0f 87 96 00 00 00    	ja     80102658 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ce:	00 
801025cf:	90                   	nop
801025d0:	89 ca                	mov    %ecx,%edx
801025d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025d3:	83 e0 c0             	and    $0xffffffc0,%eax
801025d6:	3c 40                	cmp    $0x40,%al
801025d8:	75 f6                	jne    801025d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025da:	31 ff                	xor    %edi,%edi
801025dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025e1:	89 f8                	mov    %edi,%eax
801025e3:	ee                   	out    %al,(%dx)
801025e4:	b8 01 00 00 00       	mov    $0x1,%eax
801025e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025ee:	ee                   	out    %al,(%dx)
801025ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025f4:	89 f0                	mov    %esi,%eax
801025f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025f7:	89 f0                	mov    %esi,%eax
801025f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025fe:	c1 f8 08             	sar    $0x8,%eax
80102601:	ee                   	out    %al,(%dx)
80102602:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102607:	89 f8                	mov    %edi,%eax
80102609:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010260a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010260e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102613:	c1 e0 04             	shl    $0x4,%eax
80102616:	83 e0 10             	and    $0x10,%eax
80102619:	83 c8 e0             	or     $0xffffffe0,%eax
8010261c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010261d:	f6 03 04             	testb  $0x4,(%ebx)
80102620:	75 16                	jne    80102638 <idestart+0x98>
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 ca                	mov    %ecx,%edx
80102629:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010262a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010262d:	5b                   	pop    %ebx
8010262e:	5e                   	pop    %esi
8010262f:	5f                   	pop    %edi
80102630:	5d                   	pop    %ebp
80102631:	c3                   	ret
80102632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102638:	b8 30 00 00 00       	mov    $0x30,%eax
8010263d:	89 ca                	mov    %ecx,%edx
8010263f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102640:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102645:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102648:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010264d:	fc                   	cld
8010264e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102650:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102653:	5b                   	pop    %ebx
80102654:	5e                   	pop    %esi
80102655:	5f                   	pop    %edi
80102656:	5d                   	pop    %ebp
80102657:	c3                   	ret
    panic("incorrect blockno");
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	68 ad 77 10 80       	push   $0x801077ad
80102660:	e8 0b dd ff ff       	call   80100370 <panic>
    panic("idestart");
80102665:	83 ec 0c             	sub    $0xc,%esp
80102668:	68 a4 77 10 80       	push   $0x801077a4
8010266d:	e8 fe dc ff ff       	call   80100370 <panic>
80102672:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102679:	00 
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <ideinit>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102686:	68 bf 77 10 80       	push   $0x801077bf
8010268b:	68 00 26 11 80       	push   $0x80112600
80102690:	e8 fb 21 00 00       	call   80104890 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102695:	58                   	pop    %eax
80102696:	a1 84 27 11 80       	mov    0x80112784,%eax
8010269b:	5a                   	pop    %edx
8010269c:	83 e8 01             	sub    $0x1,%eax
8010269f:	50                   	push   %eax
801026a0:	6a 0e                	push   $0xe
801026a2:	e8 99 02 00 00       	call   80102940 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026a7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026aa:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801026af:	90                   	nop
801026b0:	89 ca                	mov    %ecx,%edx
801026b2:	ec                   	in     (%dx),%al
801026b3:	83 e0 c0             	and    $0xffffffc0,%eax
801026b6:	3c 40                	cmp    $0x40,%al
801026b8:	75 f6                	jne    801026b0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ba:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026bf:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c5:	89 ca                	mov    %ecx,%edx
801026c7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026c8:	84 c0                	test   %al,%al
801026ca:	75 1e                	jne    801026ea <ideinit+0x6a>
801026cc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801026d1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026dd:	00 
801026de:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801026e0:	83 e9 01             	sub    $0x1,%ecx
801026e3:	74 0f                	je     801026f4 <ideinit+0x74>
801026e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026e6:	84 c0                	test   %al,%al
801026e8:	74 f6                	je     801026e0 <ideinit+0x60>
      havedisk1 = 1;
801026ea:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801026f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026fe:	ee                   	out    %al,(%dx)
}
801026ff:	c9                   	leave
80102700:	c3                   	ret
80102701:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102708:	00 
80102709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102710 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	57                   	push   %edi
80102714:	56                   	push   %esi
80102715:	53                   	push   %ebx
80102716:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102719:	68 00 26 11 80       	push   $0x80112600
8010271e:	e8 5d 23 00 00       	call   80104a80 <acquire>

  if((b = idequeue) == 0){
80102723:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102729:	83 c4 10             	add    $0x10,%esp
8010272c:	85 db                	test   %ebx,%ebx
8010272e:	74 63                	je     80102793 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102730:	8b 43 58             	mov    0x58(%ebx),%eax
80102733:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102738:	8b 33                	mov    (%ebx),%esi
8010273a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102740:	75 2f                	jne    80102771 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102742:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102747:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010274e:	00 
8010274f:	90                   	nop
80102750:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102751:	89 c1                	mov    %eax,%ecx
80102753:	83 e1 c0             	and    $0xffffffc0,%ecx
80102756:	80 f9 40             	cmp    $0x40,%cl
80102759:	75 f5                	jne    80102750 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010275b:	a8 21                	test   $0x21,%al
8010275d:	75 12                	jne    80102771 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010275f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102762:	b9 80 00 00 00       	mov    $0x80,%ecx
80102767:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010276c:	fc                   	cld
8010276d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010276f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102771:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102774:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102777:	83 ce 02             	or     $0x2,%esi
8010277a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010277c:	53                   	push   %ebx
8010277d:	e8 3e 1e 00 00       	call   801045c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102782:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102787:	83 c4 10             	add    $0x10,%esp
8010278a:	85 c0                	test   %eax,%eax
8010278c:	74 05                	je     80102793 <ideintr+0x83>
    idestart(idequeue);
8010278e:	e8 0d fe ff ff       	call   801025a0 <idestart>
    release(&idelock);
80102793:	83 ec 0c             	sub    $0xc,%esp
80102796:	68 00 26 11 80       	push   $0x80112600
8010279b:	e8 80 22 00 00       	call   80104a20 <release>

  release(&idelock);
}
801027a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027a3:	5b                   	pop    %ebx
801027a4:	5e                   	pop    %esi
801027a5:	5f                   	pop    %edi
801027a6:	5d                   	pop    %ebp
801027a7:	c3                   	ret
801027a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027af:	00 

801027b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	53                   	push   %ebx
801027b4:	83 ec 10             	sub    $0x10,%esp
801027b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801027bd:	50                   	push   %eax
801027be:	e8 7d 20 00 00       	call   80104840 <holdingsleep>
801027c3:	83 c4 10             	add    $0x10,%esp
801027c6:	85 c0                	test   %eax,%eax
801027c8:	0f 84 c3 00 00 00    	je     80102891 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 e0 06             	and    $0x6,%eax
801027d3:	83 f8 02             	cmp    $0x2,%eax
801027d6:	0f 84 a8 00 00 00    	je     80102884 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027dc:	8b 53 04             	mov    0x4(%ebx),%edx
801027df:	85 d2                	test   %edx,%edx
801027e1:	74 0d                	je     801027f0 <iderw+0x40>
801027e3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801027e8:	85 c0                	test   %eax,%eax
801027ea:	0f 84 87 00 00 00    	je     80102877 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027f0:	83 ec 0c             	sub    $0xc,%esp
801027f3:	68 00 26 11 80       	push   $0x80112600
801027f8:	e8 83 22 00 00       	call   80104a80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027fd:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102802:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102809:	83 c4 10             	add    $0x10,%esp
8010280c:	85 c0                	test   %eax,%eax
8010280e:	74 60                	je     80102870 <iderw+0xc0>
80102810:	89 c2                	mov    %eax,%edx
80102812:	8b 40 58             	mov    0x58(%eax),%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	75 f7                	jne    80102810 <iderw+0x60>
80102819:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010281c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010281e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102824:	74 3a                	je     80102860 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102826:	8b 03                	mov    (%ebx),%eax
80102828:	83 e0 06             	and    $0x6,%eax
8010282b:	83 f8 02             	cmp    $0x2,%eax
8010282e:	74 1b                	je     8010284b <iderw+0x9b>
    sleep(b, &idelock);
80102830:	83 ec 08             	sub    $0x8,%esp
80102833:	68 00 26 11 80       	push   $0x80112600
80102838:	53                   	push   %ebx
80102839:	e8 c2 1c 00 00       	call   80104500 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010283e:	8b 03                	mov    (%ebx),%eax
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	83 e0 06             	and    $0x6,%eax
80102846:	83 f8 02             	cmp    $0x2,%eax
80102849:	75 e5                	jne    80102830 <iderw+0x80>
  }


  release(&idelock);
8010284b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102855:	c9                   	leave
  release(&idelock);
80102856:	e9 c5 21 00 00       	jmp    80104a20 <release>
8010285b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102860:	89 d8                	mov    %ebx,%eax
80102862:	e8 39 fd ff ff       	call   801025a0 <idestart>
80102867:	eb bd                	jmp    80102826 <iderw+0x76>
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102870:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102875:	eb a5                	jmp    8010281c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102877:	83 ec 0c             	sub    $0xc,%esp
8010287a:	68 ee 77 10 80       	push   $0x801077ee
8010287f:	e8 ec da ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
80102884:	83 ec 0c             	sub    $0xc,%esp
80102887:	68 d9 77 10 80       	push   $0x801077d9
8010288c:	e8 df da ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
80102891:	83 ec 0c             	sub    $0xc,%esp
80102894:	68 c3 77 10 80       	push   $0x801077c3
80102899:	e8 d2 da ff ff       	call   80100370 <panic>
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	56                   	push   %esi
801028a4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028a5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801028ac:	00 c0 fe 
  ioapic->reg = reg;
801028af:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028b6:	00 00 00 
  return ioapic->data;
801028b9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801028bf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801028c2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801028c8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028ce:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028d5:	c1 ee 10             	shr    $0x10,%esi
801028d8:	89 f0                	mov    %esi,%eax
801028da:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028dd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801028e0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028e3:	39 c2                	cmp    %eax,%edx
801028e5:	74 16                	je     801028fd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028e7:	83 ec 0c             	sub    $0xc,%esp
801028ea:	68 00 7c 10 80       	push   $0x80107c00
801028ef:	e8 5c de ff ff       	call   80100750 <cprintf>
  ioapic->reg = reg;
801028f4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801028fa:	83 c4 10             	add    $0x10,%esp
{
801028fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102902:	31 c0                	xor    %eax,%eax
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102908:	89 13                	mov    %edx,(%ebx)
8010290a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010290d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102913:	83 c0 01             	add    $0x1,%eax
80102916:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010291c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010291f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102922:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102925:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102927:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010292d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102934:	39 c6                	cmp    %eax,%esi
80102936:	7d d0                	jge    80102908 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102938:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010293b:	5b                   	pop    %ebx
8010293c:	5e                   	pop    %esi
8010293d:	5d                   	pop    %ebp
8010293e:	c3                   	ret
8010293f:	90                   	nop

80102940 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102940:	55                   	push   %ebp
  ioapic->reg = reg;
80102941:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102947:	89 e5                	mov    %esp,%ebp
80102949:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010294c:	8d 50 20             	lea    0x20(%eax),%edx
8010294f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102953:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102955:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010295b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010295e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102961:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102964:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102966:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010296e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102971:	5d                   	pop    %ebp
80102972:	c3                   	ret
80102973:	66 90                	xchg   %ax,%ax
80102975:	66 90                	xchg   %ax,%ax
80102977:	66 90                	xchg   %ax,%ax
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	53                   	push   %ebx
80102984:	83 ec 04             	sub    $0x4,%esp
80102987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010298a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102990:	75 76                	jne    80102a08 <kfree+0x88>
80102992:	81 fb d0 64 11 80    	cmp    $0x801164d0,%ebx
80102998:	72 6e                	jb     80102a08 <kfree+0x88>
8010299a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029a5:	77 61                	ja     80102a08 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029a7:	83 ec 04             	sub    $0x4,%esp
801029aa:	68 00 10 00 00       	push   $0x1000
801029af:	6a 01                	push   $0x1
801029b1:	53                   	push   %ebx
801029b2:	e8 c9 21 00 00       	call   80104b80 <memset>

  if(kmem.use_lock)
801029b7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	85 d2                	test   %edx,%edx
801029c2:	75 1c                	jne    801029e0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029c4:	a1 78 26 11 80       	mov    0x80112678,%eax
801029c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029cb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801029d0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801029d6:	85 c0                	test   %eax,%eax
801029d8:	75 1e                	jne    801029f8 <kfree+0x78>
    release(&kmem.lock);
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave
801029de:	c3                   	ret
801029df:	90                   	nop
    acquire(&kmem.lock);
801029e0:	83 ec 0c             	sub    $0xc,%esp
801029e3:	68 40 26 11 80       	push   $0x80112640
801029e8:	e8 93 20 00 00       	call   80104a80 <acquire>
801029ed:	83 c4 10             	add    $0x10,%esp
801029f0:	eb d2                	jmp    801029c4 <kfree+0x44>
801029f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029f8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801029ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a02:	c9                   	leave
    release(&kmem.lock);
80102a03:	e9 18 20 00 00       	jmp    80104a20 <release>
    panic("kfree");
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	68 0c 78 10 80       	push   $0x8010780c
80102a10:	e8 5b d9 ff ff       	call   80100370 <panic>
80102a15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a1c:	00 
80102a1d:	8d 76 00             	lea    0x0(%esi),%esi

80102a20 <freerange>:
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	56                   	push   %esi
80102a24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a3d:	39 de                	cmp    %ebx,%esi
80102a3f:	72 23                	jb     80102a64 <freerange+0x44>
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a57:	50                   	push   %eax
80102a58:	e8 23 ff ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	39 de                	cmp    %ebx,%esi
80102a62:	73 e4                	jae    80102a48 <freerange+0x28>
}
80102a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a67:	5b                   	pop    %ebx
80102a68:	5e                   	pop    %esi
80102a69:	5d                   	pop    %ebp
80102a6a:	c3                   	ret
80102a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a70 <kinit2>:
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a75:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a7b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a81:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a87:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a8d:	39 de                	cmp    %ebx,%esi
80102a8f:	72 23                	jb     80102ab4 <kinit2+0x44>
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a98:	83 ec 0c             	sub    $0xc,%esp
80102a9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102aa7:	50                   	push   %eax
80102aa8:	e8 d3 fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aad:	83 c4 10             	add    $0x10,%esp
80102ab0:	39 de                	cmp    %ebx,%esi
80102ab2:	73 e4                	jae    80102a98 <kinit2+0x28>
  kmem.use_lock = 1;
80102ab4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102abb:	00 00 00 
}
80102abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac1:	5b                   	pop    %ebx
80102ac2:	5e                   	pop    %esi
80102ac3:	5d                   	pop    %ebp
80102ac4:	c3                   	ret
80102ac5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102acc:	00 
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <kinit1>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
80102ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102ad8:	83 ec 08             	sub    $0x8,%esp
80102adb:	68 12 78 10 80       	push   $0x80107812
80102ae0:	68 40 26 11 80       	push   $0x80112640
80102ae5:	e8 a6 1d 00 00       	call   80104890 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102aea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102af0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102af7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102afa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b0c:	39 de                	cmp    %ebx,%esi
80102b0e:	72 1c                	jb     80102b2c <kinit1+0x5c>
    kfree(p);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b19:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b1f:	50                   	push   %eax
80102b20:	e8 5b fe ff ff       	call   80102980 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b25:	83 c4 10             	add    $0x10,%esp
80102b28:	39 de                	cmp    %ebx,%esi
80102b2a:	73 e4                	jae    80102b10 <kinit1+0x40>
}
80102b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b2f:	5b                   	pop    %ebx
80102b30:	5e                   	pop    %esi
80102b31:	5d                   	pop    %ebp
80102b32:	c3                   	ret
80102b33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b3a:	00 
80102b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102b40 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102b47:	a1 74 26 11 80       	mov    0x80112674,%eax
80102b4c:	85 c0                	test   %eax,%eax
80102b4e:	75 20                	jne    80102b70 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b50:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102b56:	85 db                	test   %ebx,%ebx
80102b58:	74 07                	je     80102b61 <kalloc+0x21>
    kmem.freelist = r->next;
80102b5a:	8b 03                	mov    (%ebx),%eax
80102b5c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102b61:	89 d8                	mov    %ebx,%eax
80102b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b66:	c9                   	leave
80102b67:	c3                   	ret
80102b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b6f:	00 
    acquire(&kmem.lock);
80102b70:	83 ec 0c             	sub    $0xc,%esp
80102b73:	68 40 26 11 80       	push   $0x80112640
80102b78:	e8 03 1f 00 00       	call   80104a80 <acquire>
  r = kmem.freelist;
80102b7d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102b83:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
80102b8d:	74 08                	je     80102b97 <kalloc+0x57>
    kmem.freelist = r->next;
80102b8f:	8b 13                	mov    (%ebx),%edx
80102b91:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102b97:	85 c0                	test   %eax,%eax
80102b99:	74 c6                	je     80102b61 <kalloc+0x21>
    release(&kmem.lock);
80102b9b:	83 ec 0c             	sub    $0xc,%esp
80102b9e:	68 40 26 11 80       	push   $0x80112640
80102ba3:	e8 78 1e 00 00       	call   80104a20 <release>
}
80102ba8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102baa:	83 c4 10             	add    $0x10,%esp
}
80102bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb0:	c9                   	leave
80102bb1:	c3                   	ret
80102bb2:	66 90                	xchg   %ax,%ax
80102bb4:	66 90                	xchg   %ax,%ax
80102bb6:	66 90                	xchg   %ax,%ax
80102bb8:	66 90                	xchg   %ax,%ax
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc0:	ba 64 00 00 00       	mov    $0x64,%edx
80102bc5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102bc6:	a8 01                	test   $0x1,%al
80102bc8:	0f 84 c2 00 00 00    	je     80102c90 <kbdgetc+0xd0>
{
80102bce:	55                   	push   %ebp
80102bcf:	ba 60 00 00 00       	mov    $0x60,%edx
80102bd4:	89 e5                	mov    %esp,%ebp
80102bd6:	53                   	push   %ebx
80102bd7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102bd8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
80102bde:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102be1:	3c e0                	cmp    $0xe0,%al
80102be3:	74 5b                	je     80102c40 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102be5:	89 da                	mov    %ebx,%edx
80102be7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102bea:	84 c0                	test   %al,%al
80102bec:	78 62                	js     80102c50 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bee:	85 d2                	test   %edx,%edx
80102bf0:	74 09                	je     80102bfb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bf2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bf5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bf8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102bfb:	0f b6 91 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%edx
  shift ^= togglecode[data];
80102c02:	0f b6 81 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%eax
  shift |= shiftcode[data];
80102c09:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102c0b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c0d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102c0f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c15:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c18:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c1b:	8b 04 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%eax
80102c22:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102c26:	74 0b                	je     80102c33 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102c28:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c2b:	83 fa 19             	cmp    $0x19,%edx
80102c2e:	77 48                	ja     80102c78 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c30:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c36:	c9                   	leave
80102c37:	c3                   	ret
80102c38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c3f:	00 
    shift |= E0ESC;
80102c40:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c43:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c45:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
80102c4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c4e:	c9                   	leave
80102c4f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102c50:	83 e0 7f             	and    $0x7f,%eax
80102c53:	85 d2                	test   %edx,%edx
80102c55:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102c58:	0f b6 81 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%eax
80102c5f:	83 c8 40             	or     $0x40,%eax
80102c62:	0f b6 c0             	movzbl %al,%eax
80102c65:	f7 d0                	not    %eax
80102c67:	21 d8                	and    %ebx,%eax
80102c69:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102c6e:	31 c0                	xor    %eax,%eax
80102c70:	eb d9                	jmp    80102c4b <kbdgetc+0x8b>
80102c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102c78:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c7b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c81:	c9                   	leave
      c += 'a' - 'A';
80102c82:	83 f9 1a             	cmp    $0x1a,%ecx
80102c85:	0f 42 c2             	cmovb  %edx,%eax
}
80102c88:	c3                   	ret
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c95:	c3                   	ret
80102c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c9d:	00 
80102c9e:	66 90                	xchg   %ax,%ax

80102ca0 <kbdintr>:

void
kbdintr(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ca6:	68 c0 2b 10 80       	push   $0x80102bc0
80102cab:	e8 b0 dc ff ff       	call   80100960 <consoleintr>
}
80102cb0:	83 c4 10             	add    $0x10,%esp
80102cb3:	c9                   	leave
80102cb4:	c3                   	ret
80102cb5:	66 90                	xchg   %ax,%ax
80102cb7:	66 90                	xchg   %ax,%ax
80102cb9:	66 90                	xchg   %ax,%ax
80102cbb:	66 90                	xchg   %ax,%ax
80102cbd:	66 90                	xchg   %ax,%ax
80102cbf:	90                   	nop

80102cc0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102cc0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102cc5:	85 c0                	test   %eax,%eax
80102cc7:	0f 84 c3 00 00 00    	je     80102d90 <lapicinit+0xd0>
  lapic[index] = value;
80102ccd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102cd4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cda:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ce1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cee:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102cfb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d01:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d08:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d15:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d18:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d1b:	8b 50 30             	mov    0x30(%eax),%edx
80102d1e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102d24:	75 72                	jne    80102d98 <lapicinit+0xd8>
  lapic[index] = value;
80102d26:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d30:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d3d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d40:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d4d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d5a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d61:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d67:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d6e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d71:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d78:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d7e:	80 e6 10             	and    $0x10,%dh
80102d81:	75 f5                	jne    80102d78 <lapicinit+0xb8>
  lapic[index] = value;
80102d83:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d8d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d90:	c3                   	ret
80102d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d98:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d9f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102da2:	8b 50 20             	mov    0x20(%eax),%edx
}
80102da5:	e9 7c ff ff ff       	jmp    80102d26 <lapicinit+0x66>
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102db0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102db0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102db5:	85 c0                	test   %eax,%eax
80102db7:	74 07                	je     80102dc0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102db9:	8b 40 20             	mov    0x20(%eax),%eax
80102dbc:	c1 e8 18             	shr    $0x18,%eax
80102dbf:	c3                   	ret
    return 0;
80102dc0:	31 c0                	xor    %eax,%eax
}
80102dc2:	c3                   	ret
80102dc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dca:	00 
80102dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102dd0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102dd0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102dd5:	85 c0                	test   %eax,%eax
80102dd7:	74 0d                	je     80102de6 <lapiceoi+0x16>
  lapic[index] = value;
80102dd9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102de0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102de6:	c3                   	ret
80102de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dee:	00 
80102def:	90                   	nop

80102df0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102df0:	c3                   	ret
80102df1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df8:	00 
80102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e01:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e06:	ba 70 00 00 00       	mov    $0x70,%edx
80102e0b:	89 e5                	mov    %esp,%ebp
80102e0d:	53                   	push   %ebx
80102e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e14:	ee                   	out    %al,(%dx)
80102e15:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e1a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e20:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102e22:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e2d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102e30:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e32:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e35:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e38:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e3e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102e43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e49:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e56:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e63:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e6c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e75:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e87:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e8d:	c9                   	leave
80102e8e:	c3                   	ret
80102e8f:	90                   	nop

80102e90 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e90:	55                   	push   %ebp
80102e91:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e96:	ba 70 00 00 00       	mov    $0x70,%edx
80102e9b:	89 e5                	mov    %esp,%ebp
80102e9d:	57                   	push   %edi
80102e9e:	56                   	push   %esi
80102e9f:	53                   	push   %ebx
80102ea0:	83 ec 4c             	sub    $0x4c,%esp
80102ea3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ea9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102eaa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ead:	bf 70 00 00 00       	mov    $0x70,%edi
80102eb2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102eb5:	8d 76 00             	lea    0x0(%esi),%esi
80102eb8:	31 c0                	xor    %eax,%eax
80102eba:	89 fa                	mov    %edi,%edx
80102ebc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ec2:	89 ca                	mov    %ecx,%edx
80102ec4:	ec                   	in     (%dx),%al
80102ec5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec8:	89 fa                	mov    %edi,%edx
80102eca:	b8 02 00 00 00       	mov    $0x2,%eax
80102ecf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed0:	89 ca                	mov    %ecx,%edx
80102ed2:	ec                   	in     (%dx),%al
80102ed3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed6:	89 fa                	mov    %edi,%edx
80102ed8:	b8 04 00 00 00       	mov    $0x4,%eax
80102edd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ede:	89 ca                	mov    %ecx,%edx
80102ee0:	ec                   	in     (%dx),%al
80102ee1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ee4:	89 fa                	mov    %edi,%edx
80102ee6:	b8 07 00 00 00       	mov    $0x7,%eax
80102eeb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eec:	89 ca                	mov    %ecx,%edx
80102eee:	ec                   	in     (%dx),%al
80102eef:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef2:	89 fa                	mov    %edi,%edx
80102ef4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ef9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efa:	89 ca                	mov    %ecx,%edx
80102efc:	ec                   	in     (%dx),%al
80102efd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eff:	89 fa                	mov    %edi,%edx
80102f01:	b8 09 00 00 00       	mov    $0x9,%eax
80102f06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f07:	89 ca                	mov    %ecx,%edx
80102f09:	ec                   	in     (%dx),%al
80102f0a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0d:	89 fa                	mov    %edi,%edx
80102f0f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f15:	89 ca                	mov    %ecx,%edx
80102f17:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f18:	84 c0                	test   %al,%al
80102f1a:	78 9c                	js     80102eb8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102f1c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f20:	89 f2                	mov    %esi,%edx
80102f22:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102f25:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f28:	89 fa                	mov    %edi,%edx
80102f2a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f2d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f31:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102f34:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f37:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f3b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f3e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f45:	31 c0                	xor    %eax,%eax
80102f47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f48:	89 ca                	mov    %ecx,%edx
80102f4a:	ec                   	in     (%dx),%al
80102f4b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4e:	89 fa                	mov    %edi,%edx
80102f50:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f53:	b8 02 00 00 00       	mov    $0x2,%eax
80102f58:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f59:	89 ca                	mov    %ecx,%edx
80102f5b:	ec                   	in     (%dx),%al
80102f5c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5f:	89 fa                	mov    %edi,%edx
80102f61:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f64:	b8 04 00 00 00       	mov    $0x4,%eax
80102f69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6a:	89 ca                	mov    %ecx,%edx
80102f6c:	ec                   	in     (%dx),%al
80102f6d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f70:	89 fa                	mov    %edi,%edx
80102f72:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f75:	b8 07 00 00 00       	mov    $0x7,%eax
80102f7a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f7b:	89 ca                	mov    %ecx,%edx
80102f7d:	ec                   	in     (%dx),%al
80102f7e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f81:	89 fa                	mov    %edi,%edx
80102f83:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f86:	b8 08 00 00 00       	mov    $0x8,%eax
80102f8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f8c:	89 ca                	mov    %ecx,%edx
80102f8e:	ec                   	in     (%dx),%al
80102f8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f92:	89 fa                	mov    %edi,%edx
80102f94:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f97:	b8 09 00 00 00       	mov    $0x9,%eax
80102f9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f9d:	89 ca                	mov    %ecx,%edx
80102f9f:	ec                   	in     (%dx),%al
80102fa0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fa3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102fa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fa9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102fac:	6a 18                	push   $0x18
80102fae:	50                   	push   %eax
80102faf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102fb2:	50                   	push   %eax
80102fb3:	e8 08 1c 00 00       	call   80104bc0 <memcmp>
80102fb8:	83 c4 10             	add    $0x10,%esp
80102fbb:	85 c0                	test   %eax,%eax
80102fbd:	0f 85 f5 fe ff ff    	jne    80102eb8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102fc3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fca:	89 f0                	mov    %esi,%eax
80102fcc:	84 c0                	test   %al,%al
80102fce:	75 78                	jne    80103048 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fd0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fd3:	89 c2                	mov    %eax,%edx
80102fd5:	83 e0 0f             	and    $0xf,%eax
80102fd8:	c1 ea 04             	shr    $0x4,%edx
80102fdb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fde:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fe1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fe4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fe7:	89 c2                	mov    %eax,%edx
80102fe9:	83 e0 0f             	and    $0xf,%eax
80102fec:	c1 ea 04             	shr    $0x4,%edx
80102fef:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ff2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ff8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ffb:	89 c2                	mov    %eax,%edx
80102ffd:	83 e0 0f             	and    $0xf,%eax
80103000:	c1 ea 04             	shr    $0x4,%edx
80103003:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103006:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103009:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010300c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010300f:	89 c2                	mov    %eax,%edx
80103011:	83 e0 0f             	and    $0xf,%eax
80103014:	c1 ea 04             	shr    $0x4,%edx
80103017:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010301a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103020:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103023:	89 c2                	mov    %eax,%edx
80103025:	83 e0 0f             	and    $0xf,%eax
80103028:	c1 ea 04             	shr    $0x4,%edx
8010302b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103031:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103034:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103037:	89 c2                	mov    %eax,%edx
80103039:	83 e0 0f             	and    $0xf,%eax
8010303c:	c1 ea 04             	shr    $0x4,%edx
8010303f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103042:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103045:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103048:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010304b:	89 03                	mov    %eax,(%ebx)
8010304d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103050:	89 43 04             	mov    %eax,0x4(%ebx)
80103053:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103056:	89 43 08             	mov    %eax,0x8(%ebx)
80103059:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010305c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010305f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103062:	89 43 10             	mov    %eax,0x10(%ebx)
80103065:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103068:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010306b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103072:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103075:	5b                   	pop    %ebx
80103076:	5e                   	pop    %esi
80103077:	5f                   	pop    %edi
80103078:	5d                   	pop    %ebp
80103079:	c3                   	ret
8010307a:	66 90                	xchg   %ax,%ax
8010307c:	66 90                	xchg   %ax,%ax
8010307e:	66 90                	xchg   %ax,%ax

80103080 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103080:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103086:	85 c9                	test   %ecx,%ecx
80103088:	0f 8e 8a 00 00 00    	jle    80103118 <install_trans+0x98>
{
8010308e:	55                   	push   %ebp
8010308f:	89 e5                	mov    %esp,%ebp
80103091:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103092:	31 ff                	xor    %edi,%edi
{
80103094:	56                   	push   %esi
80103095:	53                   	push   %ebx
80103096:	83 ec 0c             	sub    $0xc,%esp
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030a0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801030a5:	83 ec 08             	sub    $0x8,%esp
801030a8:	01 f8                	add    %edi,%eax
801030aa:	83 c0 01             	add    $0x1,%eax
801030ad:	50                   	push   %eax
801030ae:	ff 35 e4 26 11 80    	push   0x801126e4
801030b4:	e8 17 d0 ff ff       	call   801000d0 <bread>
801030b9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030bb:	58                   	pop    %eax
801030bc:	5a                   	pop    %edx
801030bd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
801030c4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030ca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030cd:	e8 fe cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030d5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030d7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030da:	68 00 02 00 00       	push   $0x200
801030df:	50                   	push   %eax
801030e0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030e3:	50                   	push   %eax
801030e4:	e8 27 1b 00 00       	call   80104c10 <memmove>
    bwrite(dbuf);  // write dst to disk
801030e9:	89 1c 24             	mov    %ebx,(%esp)
801030ec:	e8 bf d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030f1:	89 34 24             	mov    %esi,(%esp)
801030f4:	e8 f7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030f9:	89 1c 24             	mov    %ebx,(%esp)
801030fc:	e8 ef d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103101:	83 c4 10             	add    $0x10,%esp
80103104:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
8010310a:	7f 94                	jg     801030a0 <install_trans+0x20>
  }
}
8010310c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103118:	c3                   	ret
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103120 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103127:	ff 35 d4 26 11 80    	push   0x801126d4
8010312d:	ff 35 e4 26 11 80    	push   0x801126e4
80103133:	e8 98 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103138:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010313b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010313d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80103142:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103145:	85 c0                	test   %eax,%eax
80103147:	7e 19                	jle    80103162 <write_head+0x42>
80103149:	31 d2                	xor    %edx,%edx
8010314b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103150:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80103157:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010315b:	83 c2 01             	add    $0x1,%edx
8010315e:	39 d0                	cmp    %edx,%eax
80103160:	75 ee                	jne    80103150 <write_head+0x30>
  }
  bwrite(buf);
80103162:	83 ec 0c             	sub    $0xc,%esp
80103165:	53                   	push   %ebx
80103166:	e8 45 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010316b:	89 1c 24             	mov    %ebx,(%esp)
8010316e:	e8 7d d0 ff ff       	call   801001f0 <brelse>
}
80103173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103176:	83 c4 10             	add    $0x10,%esp
80103179:	c9                   	leave
8010317a:	c3                   	ret
8010317b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103180 <initlog>:
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	53                   	push   %ebx
80103184:	83 ec 2c             	sub    $0x2c,%esp
80103187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010318a:	68 17 78 10 80       	push   $0x80107817
8010318f:	68 a0 26 11 80       	push   $0x801126a0
80103194:	e8 f7 16 00 00       	call   80104890 <initlock>
  readsb(dev, &sb);
80103199:	58                   	pop    %eax
8010319a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010319d:	5a                   	pop    %edx
8010319e:	50                   	push   %eax
8010319f:	53                   	push   %ebx
801031a0:	e8 7b e8 ff ff       	call   80101a20 <readsb>
  log.start = sb.logstart;
801031a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031a8:	59                   	pop    %ecx
  log.dev = dev;
801031a9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
801031af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031b2:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
801031b7:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
801031bd:	5a                   	pop    %edx
801031be:	50                   	push   %eax
801031bf:	53                   	push   %ebx
801031c0:	e8 0b cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031c5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031c8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801031cb:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
801031d1:	85 db                	test   %ebx,%ebx
801031d3:	7e 1d                	jle    801031f2 <initlog+0x72>
801031d5:	31 d2                	xor    %edx,%edx
801031d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031de:	00 
801031df:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031e0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801031e4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031eb:	83 c2 01             	add    $0x1,%edx
801031ee:	39 d3                	cmp    %edx,%ebx
801031f0:	75 ee                	jne    801031e0 <initlog+0x60>
  brelse(buf);
801031f2:	83 ec 0c             	sub    $0xc,%esp
801031f5:	50                   	push   %eax
801031f6:	e8 f5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031fb:	e8 80 fe ff ff       	call   80103080 <install_trans>
  log.lh.n = 0;
80103200:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80103207:	00 00 00 
  write_head(); // clear the log
8010320a:	e8 11 ff ff ff       	call   80103120 <write_head>
}
8010320f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103212:	83 c4 10             	add    $0x10,%esp
80103215:	c9                   	leave
80103216:	c3                   	ret
80103217:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010321e:	00 
8010321f:	90                   	nop

80103220 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103226:	68 a0 26 11 80       	push   $0x801126a0
8010322b:	e8 50 18 00 00       	call   80104a80 <acquire>
80103230:	83 c4 10             	add    $0x10,%esp
80103233:	eb 18                	jmp    8010324d <begin_op+0x2d>
80103235:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103238:	83 ec 08             	sub    $0x8,%esp
8010323b:	68 a0 26 11 80       	push   $0x801126a0
80103240:	68 a0 26 11 80       	push   $0x801126a0
80103245:	e8 b6 12 00 00       	call   80104500 <sleep>
8010324a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010324d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	75 e2                	jne    80103238 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103256:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010325b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103261:	83 c0 01             	add    $0x1,%eax
80103264:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103267:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010326a:	83 fa 1e             	cmp    $0x1e,%edx
8010326d:	7f c9                	jg     80103238 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010326f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103272:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80103277:	68 a0 26 11 80       	push   $0x801126a0
8010327c:	e8 9f 17 00 00       	call   80104a20 <release>
      break;
    }
  }
}
80103281:	83 c4 10             	add    $0x10,%esp
80103284:	c9                   	leave
80103285:	c3                   	ret
80103286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010328d:	00 
8010328e:	66 90                	xchg   %ax,%ax

80103290 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103299:	68 a0 26 11 80       	push   $0x801126a0
8010329e:	e8 dd 17 00 00       	call   80104a80 <acquire>
  log.outstanding -= 1;
801032a3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
801032a8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
801032ae:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032b4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
801032ba:	85 f6                	test   %esi,%esi
801032bc:	0f 85 22 01 00 00    	jne    801033e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032c2:	85 db                	test   %ebx,%ebx
801032c4:	0f 85 f6 00 00 00    	jne    801033c0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032ca:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
801032d1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032d4:	83 ec 0c             	sub    $0xc,%esp
801032d7:	68 a0 26 11 80       	push   $0x801126a0
801032dc:	e8 3f 17 00 00       	call   80104a20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032e1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801032e7:	83 c4 10             	add    $0x10,%esp
801032ea:	85 c9                	test   %ecx,%ecx
801032ec:	7f 42                	jg     80103330 <end_op+0xa0>
    acquire(&log.lock);
801032ee:	83 ec 0c             	sub    $0xc,%esp
801032f1:	68 a0 26 11 80       	push   $0x801126a0
801032f6:	e8 85 17 00 00       	call   80104a80 <acquire>
    log.committing = 0;
801032fb:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80103302:	00 00 00 
    wakeup(&log);
80103305:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010330c:	e8 af 12 00 00       	call   801045c0 <wakeup>
    release(&log.lock);
80103311:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103318:	e8 03 17 00 00       	call   80104a20 <release>
8010331d:	83 c4 10             	add    $0x10,%esp
}
80103320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103323:	5b                   	pop    %ebx
80103324:	5e                   	pop    %esi
80103325:	5f                   	pop    %edi
80103326:	5d                   	pop    %ebp
80103327:	c3                   	ret
80103328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010332f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103330:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103335:	83 ec 08             	sub    $0x8,%esp
80103338:	01 d8                	add    %ebx,%eax
8010333a:	83 c0 01             	add    $0x1,%eax
8010333d:	50                   	push   %eax
8010333e:	ff 35 e4 26 11 80    	push   0x801126e4
80103344:	e8 87 cd ff ff       	call   801000d0 <bread>
80103349:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010334b:	58                   	pop    %eax
8010334c:	5a                   	pop    %edx
8010334d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103354:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010335a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010335d:	e8 6e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103362:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103365:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103367:	8d 40 5c             	lea    0x5c(%eax),%eax
8010336a:	68 00 02 00 00       	push   $0x200
8010336f:	50                   	push   %eax
80103370:	8d 46 5c             	lea    0x5c(%esi),%eax
80103373:	50                   	push   %eax
80103374:	e8 97 18 00 00       	call   80104c10 <memmove>
    bwrite(to);  // write the log
80103379:	89 34 24             	mov    %esi,(%esp)
8010337c:	e8 2f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103381:	89 3c 24             	mov    %edi,(%esp)
80103384:	e8 67 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103389:	89 34 24             	mov    %esi,(%esp)
8010338c:	e8 5f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010339a:	7c 94                	jl     80103330 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010339c:	e8 7f fd ff ff       	call   80103120 <write_head>
    install_trans(); // Now install writes to home locations
801033a1:	e8 da fc ff ff       	call   80103080 <install_trans>
    log.lh.n = 0;
801033a6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801033ad:	00 00 00 
    write_head();    // Erase the transaction from the log
801033b0:	e8 6b fd ff ff       	call   80103120 <write_head>
801033b5:	e9 34 ff ff ff       	jmp    801032ee <end_op+0x5e>
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 a0 26 11 80       	push   $0x801126a0
801033c8:	e8 f3 11 00 00       	call   801045c0 <wakeup>
  release(&log.lock);
801033cd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033d4:	e8 47 16 00 00       	call   80104a20 <release>
801033d9:	83 c4 10             	add    $0x10,%esp
}
801033dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033df:	5b                   	pop    %ebx
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret
    panic("log.committing");
801033e4:	83 ec 0c             	sub    $0xc,%esp
801033e7:	68 1b 78 10 80       	push   $0x8010781b
801033ec:	e8 7f cf ff ff       	call   80100370 <panic>
801033f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033f8:	00 
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103400 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	53                   	push   %ebx
80103404:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103407:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103410:	83 fa 1d             	cmp    $0x1d,%edx
80103413:	7f 7d                	jg     80103492 <log_write+0x92>
80103415:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010341a:	83 e8 01             	sub    $0x1,%eax
8010341d:	39 c2                	cmp    %eax,%edx
8010341f:	7d 71                	jge    80103492 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103421:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80103426:	85 c0                	test   %eax,%eax
80103428:	7e 75                	jle    8010349f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010342a:	83 ec 0c             	sub    $0xc,%esp
8010342d:	68 a0 26 11 80       	push   $0x801126a0
80103432:	e8 49 16 00 00       	call   80104a80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103437:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010343a:	83 c4 10             	add    $0x10,%esp
8010343d:	31 c0                	xor    %eax,%eax
8010343f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103445:	85 d2                	test   %edx,%edx
80103447:	7f 0e                	jg     80103457 <log_write+0x57>
80103449:	eb 15                	jmp    80103460 <log_write+0x60>
8010344b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103450:	83 c0 01             	add    $0x1,%eax
80103453:	39 c2                	cmp    %eax,%edx
80103455:	74 29                	je     80103480 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103457:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010345e:	75 f0                	jne    80103450 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103460:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103467:	39 c2                	cmp    %eax,%edx
80103469:	74 1c                	je     80103487 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010346b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010346e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103471:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103478:	c9                   	leave
  release(&log.lock);
80103479:	e9 a2 15 00 00       	jmp    80104a20 <release>
8010347e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103480:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103487:	83 c2 01             	add    $0x1,%edx
8010348a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103490:	eb d9                	jmp    8010346b <log_write+0x6b>
    panic("too big a transaction");
80103492:	83 ec 0c             	sub    $0xc,%esp
80103495:	68 2a 78 10 80       	push   $0x8010782a
8010349a:	e8 d1 ce ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
8010349f:	83 ec 0c             	sub    $0xc,%esp
801034a2:	68 40 78 10 80       	push   $0x80107840
801034a7:	e8 c4 ce ff ff       	call   80100370 <panic>
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
801034b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034b7:	e8 64 09 00 00       	call   80103e20 <cpuid>
801034bc:	89 c3                	mov    %eax,%ebx
801034be:	e8 5d 09 00 00       	call   80103e20 <cpuid>
801034c3:	83 ec 04             	sub    $0x4,%esp
801034c6:	53                   	push   %ebx
801034c7:	50                   	push   %eax
801034c8:	68 5b 78 10 80       	push   $0x8010785b
801034cd:	e8 7e d2 ff ff       	call   80100750 <cprintf>
  idtinit();       // load idt register
801034d2:	e8 e9 28 00 00       	call   80105dc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034d7:	e8 e4 08 00 00       	call   80103dc0 <mycpu>
801034dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034de:	b8 01 00 00 00       	mov    $0x1,%eax
801034e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ea:	e8 01 0c 00 00       	call   801040f0 <scheduler>
801034ef:	90                   	nop

801034f0 <mpenter>:
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034f6:	e8 c5 39 00 00       	call   80106ec0 <switchkvm>
  seginit();
801034fb:	e8 30 39 00 00       	call   80106e30 <seginit>
  lapicinit();
80103500:	e8 bb f7 ff ff       	call   80102cc0 <lapicinit>
  mpmain();
80103505:	e8 a6 ff ff ff       	call   801034b0 <mpmain>
8010350a:	66 90                	xchg   %ax,%ax
8010350c:	66 90                	xchg   %ax,%ax
8010350e:	66 90                	xchg   %ax,%ax

80103510 <main>:
{
80103510:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103514:	83 e4 f0             	and    $0xfffffff0,%esp
80103517:	ff 71 fc             	push   -0x4(%ecx)
8010351a:	55                   	push   %ebp
8010351b:	89 e5                	mov    %esp,%ebp
8010351d:	53                   	push   %ebx
8010351e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010351f:	83 ec 08             	sub    $0x8,%esp
80103522:	68 00 00 40 80       	push   $0x80400000
80103527:	68 d0 64 11 80       	push   $0x801164d0
8010352c:	e8 9f f5 ff ff       	call   80102ad0 <kinit1>
  kvmalloc();      // kernel page table
80103531:	e8 4a 3e 00 00       	call   80107380 <kvmalloc>
  mpinit();        // detect other processors
80103536:	e8 85 01 00 00       	call   801036c0 <mpinit>
  lapicinit();     // interrupt controller
8010353b:	e8 80 f7 ff ff       	call   80102cc0 <lapicinit>
  seginit();       // segment descriptors
80103540:	e8 eb 38 00 00       	call   80106e30 <seginit>
  picinit();       // disable pic
80103545:	e8 86 03 00 00       	call   801038d0 <picinit>
  ioapicinit();    // another interrupt controller
8010354a:	e8 51 f3 ff ff       	call   801028a0 <ioapicinit>
  consoleinit();   // console hardware
8010354f:	e8 ec d9 ff ff       	call   80100f40 <consoleinit>
  uartinit();      // serial port
80103554:	e8 47 2b 00 00       	call   801060a0 <uartinit>
  pinit();         // process table
80103559:	e8 42 08 00 00       	call   80103da0 <pinit>
  tvinit();        // trap vectors
8010355e:	e8 dd 27 00 00       	call   80105d40 <tvinit>
  binit();         // buffer cache
80103563:	e8 d8 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103568:	e8 a3 dd ff ff       	call   80101310 <fileinit>
  ideinit();       // disk 
8010356d:	e8 0e f1 ff ff       	call   80102680 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103572:	83 c4 0c             	add    $0xc,%esp
80103575:	68 8a 00 00 00       	push   $0x8a
8010357a:	68 8c b4 10 80       	push   $0x8010b48c
8010357f:	68 00 70 00 80       	push   $0x80007000
80103584:	e8 87 16 00 00       	call   80104c10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103593:	00 00 00 
80103596:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010359b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801035a0:	76 7e                	jbe    80103620 <main+0x110>
801035a2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801035a7:	eb 20                	jmp    801035c9 <main+0xb9>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035b0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801035b7:	00 00 00 
801035ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035c0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801035c5:	39 c3                	cmp    %eax,%ebx
801035c7:	73 57                	jae    80103620 <main+0x110>
    if(c == mycpu())  // We've started already.
801035c9:	e8 f2 07 00 00       	call   80103dc0 <mycpu>
801035ce:	39 c3                	cmp    %eax,%ebx
801035d0:	74 de                	je     801035b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035d2:	e8 69 f5 ff ff       	call   80102b40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035da:	c7 05 f8 6f 00 80 f0 	movl   $0x801034f0,0x80006ff8
801035e1:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035ee:	05 00 10 00 00       	add    $0x1000,%eax
801035f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035f8:	0f b6 03             	movzbl (%ebx),%eax
801035fb:	68 00 70 00 00       	push   $0x7000
80103600:	50                   	push   %eax
80103601:	e8 fa f7 ff ff       	call   80102e00 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103606:	83 c4 10             	add    $0x10,%esp
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103610:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103616:	85 c0                	test   %eax,%eax
80103618:	74 f6                	je     80103610 <main+0x100>
8010361a:	eb 94                	jmp    801035b0 <main+0xa0>
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103620:	83 ec 08             	sub    $0x8,%esp
80103623:	68 00 00 00 8e       	push   $0x8e000000
80103628:	68 00 00 40 80       	push   $0x80400000
8010362d:	e8 3e f4 ff ff       	call   80102a70 <kinit2>
  userinit();      // first user process
80103632:	e8 39 08 00 00       	call   80103e70 <userinit>
  mpmain();        // finish this processor's setup
80103637:	e8 74 fe ff ff       	call   801034b0 <mpmain>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103645:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010364b:	53                   	push   %ebx
  e = addr+len;
8010364c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010364f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103652:	39 de                	cmp    %ebx,%esi
80103654:	72 10                	jb     80103666 <mpsearch1+0x26>
80103656:	eb 50                	jmp    801036a8 <mpsearch1+0x68>
80103658:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010365f:	00 
80103660:	89 fe                	mov    %edi,%esi
80103662:	39 df                	cmp    %ebx,%edi
80103664:	73 42                	jae    801036a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103666:	83 ec 04             	sub    $0x4,%esp
80103669:	8d 7e 10             	lea    0x10(%esi),%edi
8010366c:	6a 04                	push   $0x4
8010366e:	68 6f 78 10 80       	push   $0x8010786f
80103673:	56                   	push   %esi
80103674:	e8 47 15 00 00       	call   80104bc0 <memcmp>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	85 c0                	test   %eax,%eax
8010367e:	75 e0                	jne    80103660 <mpsearch1+0x20>
80103680:	89 f2                	mov    %esi,%edx
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103688:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010368b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010368e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103690:	39 fa                	cmp    %edi,%edx
80103692:	75 f4                	jne    80103688 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103694:	84 c0                	test   %al,%al
80103696:	75 c8                	jne    80103660 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369b:	89 f0                	mov    %esi,%eax
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5f                   	pop    %edi
801036a0:	5d                   	pop    %ebp
801036a1:	c3                   	ret
801036a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ab:	31 f6                	xor    %esi,%esi
}
801036ad:	5b                   	pop    %ebx
801036ae:	89 f0                	mov    %esi,%eax
801036b0:	5e                   	pop    %esi
801036b1:	5f                   	pop    %edi
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret
801036b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036bb:	00 
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036d7:	c1 e0 08             	shl    $0x8,%eax
801036da:	09 d0                	or     %edx,%eax
801036dc:	c1 e0 04             	shl    $0x4,%eax
801036df:	75 1b                	jne    801036fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036ef:	c1 e0 08             	shl    $0x8,%eax
801036f2:	09 d0                	or     %edx,%eax
801036f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103701:	e8 3a ff ff ff       	call   80103640 <mpsearch1>
80103706:	89 c3                	mov    %eax,%ebx
80103708:	85 c0                	test   %eax,%eax
8010370a:	0f 84 58 01 00 00    	je     80103868 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103710:	8b 73 04             	mov    0x4(%ebx),%esi
80103713:	85 f6                	test   %esi,%esi
80103715:	0f 84 3d 01 00 00    	je     80103858 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010371b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010371e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103724:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103727:	6a 04                	push   $0x4
80103729:	68 74 78 10 80       	push   $0x80107874
8010372e:	50                   	push   %eax
8010372f:	e8 8c 14 00 00       	call   80104bc0 <memcmp>
80103734:	83 c4 10             	add    $0x10,%esp
80103737:	85 c0                	test   %eax,%eax
80103739:	0f 85 19 01 00 00    	jne    80103858 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010373f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103746:	3c 01                	cmp    $0x1,%al
80103748:	74 08                	je     80103752 <mpinit+0x92>
8010374a:	3c 04                	cmp    $0x4,%al
8010374c:	0f 85 06 01 00 00    	jne    80103858 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103752:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103759:	66 85 d2             	test   %dx,%dx
8010375c:	74 22                	je     80103780 <mpinit+0xc0>
8010375e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103761:	89 f0                	mov    %esi,%eax
  sum = 0;
80103763:	31 d2                	xor    %edx,%edx
80103765:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103768:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010376f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103772:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103774:	39 f8                	cmp    %edi,%eax
80103776:	75 f0                	jne    80103768 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103778:	84 d2                	test   %dl,%dl
8010377a:	0f 85 d8 00 00 00    	jne    80103858 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103780:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103786:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103789:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010378c:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103791:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103798:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010379e:	01 d7                	add    %edx,%edi
801037a0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801037a2:	bf 01 00 00 00       	mov    $0x1,%edi
801037a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037ae:	00 
801037af:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037b0:	39 d0                	cmp    %edx,%eax
801037b2:	73 19                	jae    801037cd <mpinit+0x10d>
    switch(*p){
801037b4:	0f b6 08             	movzbl (%eax),%ecx
801037b7:	80 f9 02             	cmp    $0x2,%cl
801037ba:	0f 84 80 00 00 00    	je     80103840 <mpinit+0x180>
801037c0:	77 6e                	ja     80103830 <mpinit+0x170>
801037c2:	84 c9                	test   %cl,%cl
801037c4:	74 3a                	je     80103800 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037c6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037c9:	39 d0                	cmp    %edx,%eax
801037cb:	72 e7                	jb     801037b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037cd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801037d0:	85 ff                	test   %edi,%edi
801037d2:	0f 84 dd 00 00 00    	je     801038b5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037d8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801037dc:	74 15                	je     801037f3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037de:	b8 70 00 00 00       	mov    $0x70,%eax
801037e3:	ba 22 00 00 00       	mov    $0x22,%edx
801037e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037e9:	ba 23 00 00 00       	mov    $0x23,%edx
801037ee:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037ef:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037f2:	ee                   	out    %al,(%dx)
  }
}
801037f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f6:	5b                   	pop    %ebx
801037f7:	5e                   	pop    %esi
801037f8:	5f                   	pop    %edi
801037f9:	5d                   	pop    %ebp
801037fa:	c3                   	ret
801037fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103800:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103806:	83 f9 07             	cmp    $0x7,%ecx
80103809:	7f 19                	jg     80103824 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010380b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103811:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103815:	83 c1 01             	add    $0x1,%ecx
80103818:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010381e:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
80103824:	83 c0 14             	add    $0x14,%eax
      continue;
80103827:	eb 87                	jmp    801037b0 <mpinit+0xf0>
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103830:	83 e9 03             	sub    $0x3,%ecx
80103833:	80 f9 01             	cmp    $0x1,%cl
80103836:	76 8e                	jbe    801037c6 <mpinit+0x106>
80103838:	31 ff                	xor    %edi,%edi
8010383a:	e9 71 ff ff ff       	jmp    801037b0 <mpinit+0xf0>
8010383f:	90                   	nop
      ioapicid = ioapic->apicno;
80103840:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103844:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103847:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010384d:	e9 5e ff ff ff       	jmp    801037b0 <mpinit+0xf0>
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	68 79 78 10 80       	push   $0x80107879
80103860:	e8 0b cb ff ff       	call   80100370 <panic>
80103865:	8d 76 00             	lea    0x0(%esi),%esi
{
80103868:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010386d:	eb 0b                	jmp    8010387a <mpinit+0x1ba>
8010386f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103870:	89 f3                	mov    %esi,%ebx
80103872:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103878:	74 de                	je     80103858 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010387a:	83 ec 04             	sub    $0x4,%esp
8010387d:	8d 73 10             	lea    0x10(%ebx),%esi
80103880:	6a 04                	push   $0x4
80103882:	68 6f 78 10 80       	push   $0x8010786f
80103887:	53                   	push   %ebx
80103888:	e8 33 13 00 00       	call   80104bc0 <memcmp>
8010388d:	83 c4 10             	add    $0x10,%esp
80103890:	85 c0                	test   %eax,%eax
80103892:	75 dc                	jne    80103870 <mpinit+0x1b0>
80103894:	89 da                	mov    %ebx,%edx
80103896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010389d:	00 
8010389e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801038a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801038a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801038a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801038a8:	39 d6                	cmp    %edx,%esi
801038aa:	75 f4                	jne    801038a0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038ac:	84 c0                	test   %al,%al
801038ae:	75 c0                	jne    80103870 <mpinit+0x1b0>
801038b0:	e9 5b fe ff ff       	jmp    80103710 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801038b5:	83 ec 0c             	sub    $0xc,%esp
801038b8:	68 34 7c 10 80       	push   $0x80107c34
801038bd:	e8 ae ca ff ff       	call   80100370 <panic>
801038c2:	66 90                	xchg   %ax,%ax
801038c4:	66 90                	xchg   %ax,%ax
801038c6:	66 90                	xchg   %ax,%ax
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <picinit>:
801038d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038d5:	ba 21 00 00 00       	mov    $0x21,%edx
801038da:	ee                   	out    %al,(%dx)
801038db:	ba a1 00 00 00       	mov    $0xa1,%edx
801038e0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038e1:	c3                   	ret
801038e2:	66 90                	xchg   %ax,%ax
801038e4:	66 90                	xchg   %ax,%ax
801038e6:	66 90                	xchg   %ax,%ax
801038e8:	66 90                	xchg   %ax,%ax
801038ea:	66 90                	xchg   %ax,%ax
801038ec:	66 90                	xchg   %ax,%ax
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	8b 75 08             	mov    0x8(%ebp),%esi
801038fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038ff:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103905:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010390b:	e8 20 da ff ff       	call   80101330 <filealloc>
80103910:	89 06                	mov    %eax,(%esi)
80103912:	85 c0                	test   %eax,%eax
80103914:	0f 84 a5 00 00 00    	je     801039bf <pipealloc+0xcf>
8010391a:	e8 11 da ff ff       	call   80101330 <filealloc>
8010391f:	89 07                	mov    %eax,(%edi)
80103921:	85 c0                	test   %eax,%eax
80103923:	0f 84 84 00 00 00    	je     801039ad <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103929:	e8 12 f2 ff ff       	call   80102b40 <kalloc>
8010392e:	89 c3                	mov    %eax,%ebx
80103930:	85 c0                	test   %eax,%eax
80103932:	0f 84 a0 00 00 00    	je     801039d8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103938:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010393f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103942:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103945:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010394c:	00 00 00 
  p->nwrite = 0;
8010394f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103956:	00 00 00 
  p->nread = 0;
80103959:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103960:	00 00 00 
  initlock(&p->lock, "pipe");
80103963:	68 91 78 10 80       	push   $0x80107891
80103968:	50                   	push   %eax
80103969:	e8 22 0f 00 00       	call   80104890 <initlock>
  (*f0)->type = FD_PIPE;
8010396e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103970:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103973:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103979:	8b 06                	mov    (%esi),%eax
8010397b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010397f:	8b 06                	mov    (%esi),%eax
80103981:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103985:	8b 06                	mov    (%esi),%eax
80103987:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010398a:	8b 07                	mov    (%edi),%eax
8010398c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103992:	8b 07                	mov    (%edi),%eax
80103994:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103998:	8b 07                	mov    (%edi),%eax
8010399a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010399e:	8b 07                	mov    (%edi),%eax
801039a0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801039a3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801039a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a8:	5b                   	pop    %ebx
801039a9:	5e                   	pop    %esi
801039aa:	5f                   	pop    %edi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret
  if(*f0)
801039ad:	8b 06                	mov    (%esi),%eax
801039af:	85 c0                	test   %eax,%eax
801039b1:	74 1e                	je     801039d1 <pipealloc+0xe1>
    fileclose(*f0);
801039b3:	83 ec 0c             	sub    $0xc,%esp
801039b6:	50                   	push   %eax
801039b7:	e8 34 da ff ff       	call   801013f0 <fileclose>
801039bc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039bf:	8b 07                	mov    (%edi),%eax
801039c1:	85 c0                	test   %eax,%eax
801039c3:	74 0c                	je     801039d1 <pipealloc+0xe1>
    fileclose(*f1);
801039c5:	83 ec 0c             	sub    $0xc,%esp
801039c8:	50                   	push   %eax
801039c9:	e8 22 da ff ff       	call   801013f0 <fileclose>
801039ce:	83 c4 10             	add    $0x10,%esp
  return -1;
801039d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039d6:	eb cd                	jmp    801039a5 <pipealloc+0xb5>
  if(*f0)
801039d8:	8b 06                	mov    (%esi),%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	75 d5                	jne    801039b3 <pipealloc+0xc3>
801039de:	eb df                	jmp    801039bf <pipealloc+0xcf>

801039e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	56                   	push   %esi
801039e4:	53                   	push   %ebx
801039e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039eb:	83 ec 0c             	sub    $0xc,%esp
801039ee:	53                   	push   %ebx
801039ef:	e8 8c 10 00 00       	call   80104a80 <acquire>
  if(writable){
801039f4:	83 c4 10             	add    $0x10,%esp
801039f7:	85 f6                	test   %esi,%esi
801039f9:	74 65                	je     80103a60 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801039fb:	83 ec 0c             	sub    $0xc,%esp
801039fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a04:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a0b:	00 00 00 
    wakeup(&p->nread);
80103a0e:	50                   	push   %eax
80103a0f:	e8 ac 0b 00 00       	call   801045c0 <wakeup>
80103a14:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a17:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a1d:	85 d2                	test   %edx,%edx
80103a1f:	75 0a                	jne    80103a2b <pipeclose+0x4b>
80103a21:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a27:	85 c0                	test   %eax,%eax
80103a29:	74 15                	je     80103a40 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a31:	5b                   	pop    %ebx
80103a32:	5e                   	pop    %esi
80103a33:	5d                   	pop    %ebp
    release(&p->lock);
80103a34:	e9 e7 0f 00 00       	jmp    80104a20 <release>
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	53                   	push   %ebx
80103a44:	e8 d7 0f 00 00       	call   80104a20 <release>
    kfree((char*)p);
80103a49:	83 c4 10             	add    $0x10,%esp
80103a4c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a52:	5b                   	pop    %ebx
80103a53:	5e                   	pop    %esi
80103a54:	5d                   	pop    %ebp
    kfree((char*)p);
80103a55:	e9 26 ef ff ff       	jmp    80102980 <kfree>
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a70:	00 00 00 
    wakeup(&p->nwrite);
80103a73:	50                   	push   %eax
80103a74:	e8 47 0b 00 00       	call   801045c0 <wakeup>
80103a79:	83 c4 10             	add    $0x10,%esp
80103a7c:	eb 99                	jmp    80103a17 <pipeclose+0x37>
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	57                   	push   %edi
80103a84:	56                   	push   %esi
80103a85:	53                   	push   %ebx
80103a86:	83 ec 28             	sub    $0x28,%esp
80103a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a8c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103a8f:	53                   	push   %ebx
80103a90:	e8 eb 0f 00 00       	call   80104a80 <acquire>
  for(i = 0; i < n; i++){
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	85 ff                	test   %edi,%edi
80103a9a:	0f 8e ce 00 00 00    	jle    80103b6e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aa0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103aa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103aa9:	89 7d 10             	mov    %edi,0x10(%ebp)
80103aac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aaf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103ab2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ab5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103abb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ac1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ac7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103acd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103ad0:	0f 85 b6 00 00 00    	jne    80103b8c <pipewrite+0x10c>
80103ad6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103ad9:	eb 3b                	jmp    80103b16 <pipewrite+0x96>
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ae0:	e8 5b 03 00 00       	call   80103e40 <myproc>
80103ae5:	8b 48 24             	mov    0x24(%eax),%ecx
80103ae8:	85 c9                	test   %ecx,%ecx
80103aea:	75 34                	jne    80103b20 <pipewrite+0xa0>
      wakeup(&p->nread);
80103aec:	83 ec 0c             	sub    $0xc,%esp
80103aef:	56                   	push   %esi
80103af0:	e8 cb 0a 00 00       	call   801045c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103af5:	58                   	pop    %eax
80103af6:	5a                   	pop    %edx
80103af7:	53                   	push   %ebx
80103af8:	57                   	push   %edi
80103af9:	e8 02 0a 00 00       	call   80104500 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103afe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b04:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b0a:	83 c4 10             	add    $0x10,%esp
80103b0d:	05 00 02 00 00       	add    $0x200,%eax
80103b12:	39 c2                	cmp    %eax,%edx
80103b14:	75 2a                	jne    80103b40 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103b16:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b1c:	85 c0                	test   %eax,%eax
80103b1e:	75 c0                	jne    80103ae0 <pipewrite+0x60>
        release(&p->lock);
80103b20:	83 ec 0c             	sub    $0xc,%esp
80103b23:	53                   	push   %ebx
80103b24:	e8 f7 0e 00 00       	call   80104a20 <release>
        return -1;
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b34:	5b                   	pop    %ebx
80103b35:	5e                   	pop    %esi
80103b36:	5f                   	pop    %edi
80103b37:	5d                   	pop    %ebp
80103b38:	c3                   	ret
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b43:	8d 42 01             	lea    0x1(%edx),%eax
80103b46:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80103b4c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b4f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b58:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80103b5c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103b63:	39 c1                	cmp    %eax,%ecx
80103b65:	0f 85 50 ff ff ff    	jne    80103abb <pipewrite+0x3b>
80103b6b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b6e:	83 ec 0c             	sub    $0xc,%esp
80103b71:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b77:	50                   	push   %eax
80103b78:	e8 43 0a 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103b7d:	89 1c 24             	mov    %ebx,(%esp)
80103b80:	e8 9b 0e 00 00       	call   80104a20 <release>
  return n;
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	89 f8                	mov    %edi,%eax
80103b8a:	eb a5                	jmp    80103b31 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b8f:	eb b2                	jmp    80103b43 <pipewrite+0xc3>
80103b91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b98:	00 
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ba0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 18             	sub    $0x18,%esp
80103ba9:	8b 75 08             	mov    0x8(%ebp),%esi
80103bac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103baf:	56                   	push   %esi
80103bb0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103bb6:	e8 c5 0e 00 00       	call   80104a80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bbb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bc1:	83 c4 10             	add    $0x10,%esp
80103bc4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103bca:	74 2f                	je     80103bfb <piperead+0x5b>
80103bcc:	eb 37                	jmp    80103c05 <piperead+0x65>
80103bce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103bd0:	e8 6b 02 00 00       	call   80103e40 <myproc>
80103bd5:	8b 40 24             	mov    0x24(%eax),%eax
80103bd8:	85 c0                	test   %eax,%eax
80103bda:	0f 85 80 00 00 00    	jne    80103c60 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103be0:	83 ec 08             	sub    $0x8,%esp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
80103be5:	e8 16 09 00 00       	call   80104500 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bea:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bf0:	83 c4 10             	add    $0x10,%esp
80103bf3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103bf9:	75 0a                	jne    80103c05 <piperead+0x65>
80103bfb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103c01:	85 d2                	test   %edx,%edx
80103c03:	75 cb                	jne    80103bd0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103c08:	31 db                	xor    %ebx,%ebx
80103c0a:	85 c9                	test   %ecx,%ecx
80103c0c:	7f 26                	jg     80103c34 <piperead+0x94>
80103c0e:	eb 2c                	jmp    80103c3c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c10:	8d 48 01             	lea    0x1(%eax),%ecx
80103c13:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c18:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c1e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c23:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c26:	83 c3 01             	add    $0x1,%ebx
80103c29:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c2c:	74 0e                	je     80103c3c <piperead+0x9c>
80103c2e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103c34:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c3a:	75 d4                	jne    80103c10 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c3c:	83 ec 0c             	sub    $0xc,%esp
80103c3f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c45:	50                   	push   %eax
80103c46:	e8 75 09 00 00       	call   801045c0 <wakeup>
  release(&p->lock);
80103c4b:	89 34 24             	mov    %esi,(%esp)
80103c4e:	e8 cd 0d 00 00       	call   80104a20 <release>
  return i;
80103c53:	83 c4 10             	add    $0x10,%esp
}
80103c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c59:	89 d8                	mov    %ebx,%eax
80103c5b:	5b                   	pop    %ebx
80103c5c:	5e                   	pop    %esi
80103c5d:	5f                   	pop    %edi
80103c5e:	5d                   	pop    %ebp
80103c5f:	c3                   	ret
      release(&p->lock);
80103c60:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c68:	56                   	push   %esi
80103c69:	e8 b2 0d 00 00       	call   80104a20 <release>
      return -1;
80103c6e:	83 c4 10             	add    $0x10,%esp
}
80103c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c74:	89 d8                	mov    %ebx,%eax
80103c76:	5b                   	pop    %ebx
80103c77:	5e                   	pop    %esi
80103c78:	5f                   	pop    %edi
80103c79:	5d                   	pop    %ebp
80103c7a:	c3                   	ret
80103c7b:	66 90                	xchg   %ax,%ax
80103c7d:	66 90                	xchg   %ax,%ax
80103c7f:	90                   	nop

80103c80 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c84:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103c89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c8c:	68 20 2d 11 80       	push   $0x80112d20
80103c91:	e8 ea 0d 00 00       	call   80104a80 <acquire>
80103c96:	83 c4 10             	add    $0x10,%esp
80103c99:	eb 10                	jmp    80103cab <allocproc+0x2b>
80103c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca0:	83 c3 7c             	add    $0x7c,%ebx
80103ca3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ca9:	74 75                	je     80103d20 <allocproc+0xa0>
    if(p->state == UNUSED)
80103cab:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cae:	85 c0                	test   %eax,%eax
80103cb0:	75 ee                	jne    80103ca0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103cb2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103cb7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103cba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103cc1:	89 43 10             	mov    %eax,0x10(%ebx)
80103cc4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103cc7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103ccc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103cd2:	e8 49 0d 00 00       	call   80104a20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cd7:	e8 64 ee ff ff       	call   80102b40 <kalloc>
80103cdc:	83 c4 10             	add    $0x10,%esp
80103cdf:	89 43 08             	mov    %eax,0x8(%ebx)
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	74 53                	je     80103d39 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ce6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cec:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cef:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cf4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cf7:	c7 40 14 32 5d 10 80 	movl   $0x80105d32,0x14(%eax)
  p->context = (struct context*)sp;
80103cfe:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d01:	6a 14                	push   $0x14
80103d03:	6a 00                	push   $0x0
80103d05:	50                   	push   %eax
80103d06:	e8 75 0e 00 00       	call   80104b80 <memset>
  p->context->eip = (uint)forkret;
80103d0b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103d0e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103d11:	c7 40 10 50 3d 10 80 	movl   $0x80103d50,0x10(%eax)
}
80103d18:	89 d8                	mov    %ebx,%eax
80103d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d1d:	c9                   	leave
80103d1e:	c3                   	ret
80103d1f:	90                   	nop
  release(&ptable.lock);
80103d20:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d23:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d25:	68 20 2d 11 80       	push   $0x80112d20
80103d2a:	e8 f1 0c 00 00       	call   80104a20 <release>
  return 0;
80103d2f:	83 c4 10             	add    $0x10,%esp
}
80103d32:	89 d8                	mov    %ebx,%eax
80103d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d37:	c9                   	leave
80103d38:	c3                   	ret
    p->state = UNUSED;
80103d39:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103d40:	31 db                	xor    %ebx,%ebx
80103d42:	eb ee                	jmp    80103d32 <allocproc+0xb2>
80103d44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d4b:	00 
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d56:	68 20 2d 11 80       	push   $0x80112d20
80103d5b:	e8 c0 0c 00 00       	call   80104a20 <release>

  if (first) {
80103d60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d65:	83 c4 10             	add    $0x10,%esp
80103d68:	85 c0                	test   %eax,%eax
80103d6a:	75 04                	jne    80103d70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d6c:	c9                   	leave
80103d6d:	c3                   	ret
80103d6e:	66 90                	xchg   %ax,%ax
    first = 0;
80103d70:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d77:	00 00 00 
    iinit(ROOTDEV);
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	6a 01                	push   $0x1
80103d7f:	e8 dc dc ff ff       	call   80101a60 <iinit>
    initlog(ROOTDEV);
80103d84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d8b:	e8 f0 f3 ff ff       	call   80103180 <initlog>
}
80103d90:	83 c4 10             	add    $0x10,%esp
80103d93:	c9                   	leave
80103d94:	c3                   	ret
80103d95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d9c:	00 
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi

80103da0 <pinit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103da6:	68 96 78 10 80       	push   $0x80107896
80103dab:	68 20 2d 11 80       	push   $0x80112d20
80103db0:	e8 db 0a 00 00       	call   80104890 <initlock>
}
80103db5:	83 c4 10             	add    $0x10,%esp
80103db8:	c9                   	leave
80103db9:	c3                   	ret
80103dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103dc0 <mycpu>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dc5:	9c                   	pushf
80103dc6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc7:	f6 c4 02             	test   $0x2,%ah
80103dca:	75 46                	jne    80103e12 <mycpu+0x52>
  apicid = lapicid();
80103dcc:	e8 df ef ff ff       	call   80102db0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103dd1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103dd7:	85 f6                	test   %esi,%esi
80103dd9:	7e 2a                	jle    80103e05 <mycpu+0x45>
80103ddb:	31 d2                	xor    %edx,%edx
80103ddd:	eb 08                	jmp    80103de7 <mycpu+0x27>
80103ddf:	90                   	nop
80103de0:	83 c2 01             	add    $0x1,%edx
80103de3:	39 f2                	cmp    %esi,%edx
80103de5:	74 1e                	je     80103e05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103de7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ded:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103df4:	39 c3                	cmp    %eax,%ebx
80103df6:	75 e8                	jne    80103de0 <mycpu+0x20>
}
80103df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103dfb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103e01:	5b                   	pop    %ebx
80103e02:	5e                   	pop    %esi
80103e03:	5d                   	pop    %ebp
80103e04:	c3                   	ret
  panic("unknown apicid\n");
80103e05:	83 ec 0c             	sub    $0xc,%esp
80103e08:	68 9d 78 10 80       	push   $0x8010789d
80103e0d:	e8 5e c5 ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e12:	83 ec 0c             	sub    $0xc,%esp
80103e15:	68 54 7c 10 80       	push   $0x80107c54
80103e1a:	e8 51 c5 ff ff       	call   80100370 <panic>
80103e1f:	90                   	nop

80103e20 <cpuid>:
cpuid() {
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e26:	e8 95 ff ff ff       	call   80103dc0 <mycpu>
}
80103e2b:	c9                   	leave
  return mycpu()-cpus;
80103e2c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103e31:	c1 f8 04             	sar    $0x4,%eax
80103e34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e3a:	c3                   	ret
80103e3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e40 <myproc>:
myproc(void) {
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e47:	e8 e4 0a 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103e4c:	e8 6f ff ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
80103e51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e57:	e8 24 0b 00 00       	call   80104980 <popcli>
}
80103e5c:	89 d8                	mov    %ebx,%eax
80103e5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e61:	c9                   	leave
80103e62:	c3                   	ret
80103e63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e6a:	00 
80103e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e70 <userinit>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	53                   	push   %ebx
80103e74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e77:	e8 04 fe ff ff       	call   80103c80 <allocproc>
80103e7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e7e:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  if((p->pgdir = setupkvm()) == 0)
80103e83:	e8 78 34 00 00       	call   80107300 <setupkvm>
80103e88:	89 43 04             	mov    %eax,0x4(%ebx)
80103e8b:	85 c0                	test   %eax,%eax
80103e8d:	0f 84 bd 00 00 00    	je     80103f50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e93:	83 ec 04             	sub    $0x4,%esp
80103e96:	68 2c 00 00 00       	push   $0x2c
80103e9b:	68 60 b4 10 80       	push   $0x8010b460
80103ea0:	50                   	push   %eax
80103ea1:	e8 3a 31 00 00       	call   80106fe0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ea6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ea9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103eaf:	6a 4c                	push   $0x4c
80103eb1:	6a 00                	push   $0x0
80103eb3:	ff 73 18             	push   0x18(%ebx)
80103eb6:	e8 c5 0c 00 00       	call   80104b80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ebe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ec3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ec6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ecb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ecf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ed6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103edd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ee1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ee8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103eec:	8b 43 18             	mov    0x18(%ebx),%eax
80103eef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ef6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f00:	8b 43 18             	mov    0x18(%ebx),%eax
80103f03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f0d:	6a 10                	push   $0x10
80103f0f:	68 c6 78 10 80       	push   $0x801078c6
80103f14:	50                   	push   %eax
80103f15:	e8 16 0e 00 00       	call   80104d30 <safestrcpy>
  p->cwd = namei("/");
80103f1a:	c7 04 24 cf 78 10 80 	movl   $0x801078cf,(%esp)
80103f21:	e8 3a e6 ff ff       	call   80102560 <namei>
80103f26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f29:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f30:	e8 4b 0b 00 00       	call   80104a80 <acquire>
  p->state = RUNNABLE;
80103f35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f43:	e8 d8 0a 00 00       	call   80104a20 <release>
}
80103f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f4b:	83 c4 10             	add    $0x10,%esp
80103f4e:	c9                   	leave
80103f4f:	c3                   	ret
    panic("userinit: out of memory?");
80103f50:	83 ec 0c             	sub    $0xc,%esp
80103f53:	68 ad 78 10 80       	push   $0x801078ad
80103f58:	e8 13 c4 ff ff       	call   80100370 <panic>
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi

80103f60 <growproc>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
80103f65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f68:	e8 c3 09 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103f6d:	e8 4e fe ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
80103f72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f78:	e8 03 0a 00 00       	call   80104980 <popcli>
  sz = curproc->sz;
80103f7d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f7f:	85 f6                	test   %esi,%esi
80103f81:	7f 1d                	jg     80103fa0 <growproc+0x40>
  } else if(n < 0){
80103f83:	75 3b                	jne    80103fc0 <growproc+0x60>
  switchuvm(curproc);
80103f85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f8a:	53                   	push   %ebx
80103f8b:	e8 40 2f 00 00       	call   80106ed0 <switchuvm>
  return 0;
80103f90:	83 c4 10             	add    $0x10,%esp
80103f93:	31 c0                	xor    %eax,%eax
}
80103f95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f98:	5b                   	pop    %ebx
80103f99:	5e                   	pop    %esi
80103f9a:	5d                   	pop    %ebp
80103f9b:	c3                   	ret
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fa0:	83 ec 04             	sub    $0x4,%esp
80103fa3:	01 c6                	add    %eax,%esi
80103fa5:	56                   	push   %esi
80103fa6:	50                   	push   %eax
80103fa7:	ff 73 04             	push   0x4(%ebx)
80103faa:	e8 81 31 00 00       	call   80107130 <allocuvm>
80103faf:	83 c4 10             	add    $0x10,%esp
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	75 cf                	jne    80103f85 <growproc+0x25>
      return -1;
80103fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fbb:	eb d8                	jmp    80103f95 <growproc+0x35>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fc0:	83 ec 04             	sub    $0x4,%esp
80103fc3:	01 c6                	add    %eax,%esi
80103fc5:	56                   	push   %esi
80103fc6:	50                   	push   %eax
80103fc7:	ff 73 04             	push   0x4(%ebx)
80103fca:	e8 81 32 00 00       	call   80107250 <deallocuvm>
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	75 af                	jne    80103f85 <growproc+0x25>
80103fd6:	eb de                	jmp    80103fb6 <growproc+0x56>
80103fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fdf:	00 

80103fe0 <fork>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fe9:	e8 42 09 00 00       	call   80104930 <pushcli>
  c = mycpu();
80103fee:	e8 cd fd ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
80103ff3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff9:	e8 82 09 00 00       	call   80104980 <popcli>
  if((np = allocproc()) == 0){
80103ffe:	e8 7d fc ff ff       	call   80103c80 <allocproc>
80104003:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104006:	85 c0                	test   %eax,%eax
80104008:	0f 84 d6 00 00 00    	je     801040e4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010400e:	83 ec 08             	sub    $0x8,%esp
80104011:	ff 33                	push   (%ebx)
80104013:	89 c7                	mov    %eax,%edi
80104015:	ff 73 04             	push   0x4(%ebx)
80104018:	e8 d3 33 00 00       	call   801073f0 <copyuvm>
8010401d:	83 c4 10             	add    $0x10,%esp
80104020:	89 47 04             	mov    %eax,0x4(%edi)
80104023:	85 c0                	test   %eax,%eax
80104025:	0f 84 9a 00 00 00    	je     801040c5 <fork+0xe5>
  np->sz = curproc->sz;
8010402b:	8b 03                	mov    (%ebx),%eax
8010402d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104030:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104032:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104035:	89 c8                	mov    %ecx,%eax
80104037:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010403a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010403f:	8b 73 18             	mov    0x18(%ebx),%esi
80104042:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104044:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104046:	8b 40 18             	mov    0x18(%eax),%eax
80104049:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104050:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104054:	85 c0                	test   %eax,%eax
80104056:	74 13                	je     8010406b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	50                   	push   %eax
8010405c:	e8 3f d3 ff ff       	call   801013a0 <filedup>
80104061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104064:	83 c4 10             	add    $0x10,%esp
80104067:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010406b:	83 c6 01             	add    $0x1,%esi
8010406e:	83 fe 10             	cmp    $0x10,%esi
80104071:	75 dd                	jne    80104050 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104073:	83 ec 0c             	sub    $0xc,%esp
80104076:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104079:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010407c:	e8 cf db ff ff       	call   80101c50 <idup>
80104081:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104084:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104087:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010408a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010408d:	6a 10                	push   $0x10
8010408f:	53                   	push   %ebx
80104090:	50                   	push   %eax
80104091:	e8 9a 0c 00 00       	call   80104d30 <safestrcpy>
  pid = np->pid;
80104096:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104099:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040a0:	e8 db 09 00 00       	call   80104a80 <acquire>
  np->state = RUNNABLE;
801040a5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801040ac:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040b3:	e8 68 09 00 00       	call   80104a20 <release>
  return pid;
801040b8:	83 c4 10             	add    $0x10,%esp
}
801040bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040be:	89 d8                	mov    %ebx,%eax
801040c0:	5b                   	pop    %ebx
801040c1:	5e                   	pop    %esi
801040c2:	5f                   	pop    %edi
801040c3:	5d                   	pop    %ebp
801040c4:	c3                   	ret
    kfree(np->kstack);
801040c5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801040c8:	83 ec 0c             	sub    $0xc,%esp
801040cb:	ff 73 08             	push   0x8(%ebx)
801040ce:	e8 ad e8 ff ff       	call   80102980 <kfree>
    np->kstack = 0;
801040d3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040da:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040dd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040e4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040e9:	eb d0                	jmp    801040bb <fork+0xdb>
801040eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801040f0 <scheduler>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040f9:	e8 c2 fc ff ff       	call   80103dc0 <mycpu>
  c->proc = 0;
801040fe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104105:	00 00 00 
  struct cpu *c = mycpu();
80104108:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010410a:	8d 78 04             	lea    0x4(%eax),%edi
8010410d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104110:	fb                   	sti
    acquire(&ptable.lock);
80104111:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104114:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80104119:	68 20 2d 11 80       	push   $0x80112d20
8010411e:	e8 5d 09 00 00       	call   80104a80 <acquire>
80104123:	83 c4 10             	add    $0x10,%esp
80104126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010412d:	00 
8010412e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104130:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104134:	75 33                	jne    80104169 <scheduler+0x79>
      switchuvm(p);
80104136:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104139:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010413f:	53                   	push   %ebx
80104140:	e8 8b 2d 00 00       	call   80106ed0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104145:	58                   	pop    %eax
80104146:	5a                   	pop    %edx
80104147:	ff 73 1c             	push   0x1c(%ebx)
8010414a:	57                   	push   %edi
      p->state = RUNNING;
8010414b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104152:	e8 34 0c 00 00       	call   80104d8b <swtch>
      switchkvm();
80104157:	e8 64 2d 00 00       	call   80106ec0 <switchkvm>
      c->proc = 0;
8010415c:	83 c4 10             	add    $0x10,%esp
8010415f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104166:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104169:	83 c3 7c             	add    $0x7c,%ebx
8010416c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104172:	75 bc                	jne    80104130 <scheduler+0x40>
    release(&ptable.lock);
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 20 2d 11 80       	push   $0x80112d20
8010417c:	e8 9f 08 00 00       	call   80104a20 <release>
    sti();
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	eb 8a                	jmp    80104110 <scheduler+0x20>
80104186:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010418d:	00 
8010418e:	66 90                	xchg   %ax,%ax

80104190 <sched>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
  pushcli();
80104195:	e8 96 07 00 00       	call   80104930 <pushcli>
  c = mycpu();
8010419a:	e8 21 fc ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
8010419f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a5:	e8 d6 07 00 00       	call   80104980 <popcli>
  if(!holding(&ptable.lock))
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 20 2d 11 80       	push   $0x80112d20
801041b2:	e8 29 08 00 00       	call   801049e0 <holding>
801041b7:	83 c4 10             	add    $0x10,%esp
801041ba:	85 c0                	test   %eax,%eax
801041bc:	74 4f                	je     8010420d <sched+0x7d>
  if(mycpu()->ncli != 1)
801041be:	e8 fd fb ff ff       	call   80103dc0 <mycpu>
801041c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ca:	75 68                	jne    80104234 <sched+0xa4>
  if(p->state == RUNNING)
801041cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041d0:	74 55                	je     80104227 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041d2:	9c                   	pushf
801041d3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041d4:	f6 c4 02             	test   $0x2,%ah
801041d7:	75 41                	jne    8010421a <sched+0x8a>
  intena = mycpu()->intena;
801041d9:	e8 e2 fb ff ff       	call   80103dc0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041de:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041e7:	e8 d4 fb ff ff       	call   80103dc0 <mycpu>
801041ec:	83 ec 08             	sub    $0x8,%esp
801041ef:	ff 70 04             	push   0x4(%eax)
801041f2:	53                   	push   %ebx
801041f3:	e8 93 0b 00 00       	call   80104d8b <swtch>
  mycpu()->intena = intena;
801041f8:	e8 c3 fb ff ff       	call   80103dc0 <mycpu>
}
801041fd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104200:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104206:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104209:	5b                   	pop    %ebx
8010420a:	5e                   	pop    %esi
8010420b:	5d                   	pop    %ebp
8010420c:	c3                   	ret
    panic("sched ptable.lock");
8010420d:	83 ec 0c             	sub    $0xc,%esp
80104210:	68 d1 78 10 80       	push   $0x801078d1
80104215:	e8 56 c1 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 fd 78 10 80       	push   $0x801078fd
80104222:	e8 49 c1 ff ff       	call   80100370 <panic>
    panic("sched running");
80104227:	83 ec 0c             	sub    $0xc,%esp
8010422a:	68 ef 78 10 80       	push   $0x801078ef
8010422f:	e8 3c c1 ff ff       	call   80100370 <panic>
    panic("sched locks");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 e3 78 10 80       	push   $0x801078e3
8010423c:	e8 2f c1 ff ff       	call   80100370 <panic>
80104241:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104248:	00 
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <exit>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	57                   	push   %edi
80104254:	56                   	push   %esi
80104255:	53                   	push   %ebx
80104256:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104259:	e8 e2 fb ff ff       	call   80103e40 <myproc>
  if(curproc == initproc)
8010425e:	39 05 54 4c 11 80    	cmp    %eax,0x80114c54
80104264:	0f 84 fd 00 00 00    	je     80104367 <exit+0x117>
8010426a:	89 c3                	mov    %eax,%ebx
8010426c:	8d 70 28             	lea    0x28(%eax),%esi
8010426f:	8d 78 68             	lea    0x68(%eax),%edi
80104272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104278:	8b 06                	mov    (%esi),%eax
8010427a:	85 c0                	test   %eax,%eax
8010427c:	74 12                	je     80104290 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	50                   	push   %eax
80104282:	e8 69 d1 ff ff       	call   801013f0 <fileclose>
      curproc->ofile[fd] = 0;
80104287:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010428d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104290:	83 c6 04             	add    $0x4,%esi
80104293:	39 f7                	cmp    %esi,%edi
80104295:	75 e1                	jne    80104278 <exit+0x28>
  begin_op();
80104297:	e8 84 ef ff ff       	call   80103220 <begin_op>
  iput(curproc->cwd);
8010429c:	83 ec 0c             	sub    $0xc,%esp
8010429f:	ff 73 68             	push   0x68(%ebx)
801042a2:	e8 09 db ff ff       	call   80101db0 <iput>
  end_op();
801042a7:	e8 e4 ef ff ff       	call   80103290 <end_op>
  curproc->cwd = 0;
801042ac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801042b3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042ba:	e8 c1 07 00 00       	call   80104a80 <acquire>
  wakeup1(curproc->parent);
801042bf:	8b 53 14             	mov    0x14(%ebx),%edx
801042c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042ca:	eb 0e                	jmp    801042da <exit+0x8a>
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d0:	83 c0 7c             	add    $0x7c,%eax
801042d3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801042d8:	74 1c                	je     801042f6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801042da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042de:	75 f0                	jne    801042d0 <exit+0x80>
801042e0:	3b 50 20             	cmp    0x20(%eax),%edx
801042e3:	75 eb                	jne    801042d0 <exit+0x80>
      p->state = RUNNABLE;
801042e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ec:	83 c0 7c             	add    $0x7c,%eax
801042ef:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801042f4:	75 e4                	jne    801042da <exit+0x8a>
      p->parent = initproc;
801042f6:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104301:	eb 10                	jmp    80104313 <exit+0xc3>
80104303:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104308:	83 c2 7c             	add    $0x7c,%edx
8010430b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80104311:	74 3b                	je     8010434e <exit+0xfe>
    if(p->parent == curproc){
80104313:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104316:	75 f0                	jne    80104308 <exit+0xb8>
      if(p->state == ZOMBIE)
80104318:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010431c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010431f:	75 e7                	jne    80104308 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104321:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104326:	eb 12                	jmp    8010433a <exit+0xea>
80104328:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010432f:	00 
80104330:	83 c0 7c             	add    $0x7c,%eax
80104333:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104338:	74 ce                	je     80104308 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010433a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010433e:	75 f0                	jne    80104330 <exit+0xe0>
80104340:	3b 48 20             	cmp    0x20(%eax),%ecx
80104343:	75 eb                	jne    80104330 <exit+0xe0>
      p->state = RUNNABLE;
80104345:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010434c:	eb e2                	jmp    80104330 <exit+0xe0>
  curproc->state = ZOMBIE;
8010434e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104355:	e8 36 fe ff ff       	call   80104190 <sched>
  panic("zombie exit");
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 1e 79 10 80       	push   $0x8010791e
80104362:	e8 09 c0 ff ff       	call   80100370 <panic>
    panic("init exiting");
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	68 11 79 10 80       	push   $0x80107911
8010436f:	e8 fc bf ff ff       	call   80100370 <panic>
80104374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010437b:	00 
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104380 <wait>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
  pushcli();
80104385:	e8 a6 05 00 00       	call   80104930 <pushcli>
  c = mycpu();
8010438a:	e8 31 fa ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
8010438f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104395:	e8 e6 05 00 00       	call   80104980 <popcli>
  acquire(&ptable.lock);
8010439a:	83 ec 0c             	sub    $0xc,%esp
8010439d:	68 20 2d 11 80       	push   $0x80112d20
801043a2:	e8 d9 06 00 00       	call   80104a80 <acquire>
801043a7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043aa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ac:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801043b1:	eb 10                	jmp    801043c3 <wait+0x43>
801043b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801043b8:	83 c3 7c             	add    $0x7c,%ebx
801043bb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801043c1:	74 1b                	je     801043de <wait+0x5e>
      if(p->parent != curproc)
801043c3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043c6:	75 f0                	jne    801043b8 <wait+0x38>
      if(p->state == ZOMBIE){
801043c8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043cc:	74 62                	je     80104430 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043d1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801043dc:	75 e5                	jne    801043c3 <wait+0x43>
    if(!havekids || curproc->killed){
801043de:	85 c0                	test   %eax,%eax
801043e0:	0f 84 a0 00 00 00    	je     80104486 <wait+0x106>
801043e6:	8b 46 24             	mov    0x24(%esi),%eax
801043e9:	85 c0                	test   %eax,%eax
801043eb:	0f 85 95 00 00 00    	jne    80104486 <wait+0x106>
  pushcli();
801043f1:	e8 3a 05 00 00       	call   80104930 <pushcli>
  c = mycpu();
801043f6:	e8 c5 f9 ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
801043fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104401:	e8 7a 05 00 00       	call   80104980 <popcli>
  if(p == 0)
80104406:	85 db                	test   %ebx,%ebx
80104408:	0f 84 8f 00 00 00    	je     8010449d <wait+0x11d>
  p->chan = chan;
8010440e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104411:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104418:	e8 73 fd ff ff       	call   80104190 <sched>
  p->chan = 0;
8010441d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104424:	eb 84                	jmp    801043aa <wait+0x2a>
80104426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010442d:	00 
8010442e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104430:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104433:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104436:	ff 73 08             	push   0x8(%ebx)
80104439:	e8 42 e5 ff ff       	call   80102980 <kfree>
        p->kstack = 0;
8010443e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104445:	5a                   	pop    %edx
80104446:	ff 73 04             	push   0x4(%ebx)
80104449:	e8 32 2e 00 00       	call   80107280 <freevm>
        p->pid = 0;
8010444e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104455:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010445c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104460:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104467:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010446e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104475:	e8 a6 05 00 00       	call   80104a20 <release>
        return pid;
8010447a:	83 c4 10             	add    $0x10,%esp
}
8010447d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104480:	89 f0                	mov    %esi,%eax
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret
      release(&ptable.lock);
80104486:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104489:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010448e:	68 20 2d 11 80       	push   $0x80112d20
80104493:	e8 88 05 00 00       	call   80104a20 <release>
      return -1;
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	eb e0                	jmp    8010447d <wait+0xfd>
    panic("sleep");
8010449d:	83 ec 0c             	sub    $0xc,%esp
801044a0:	68 2a 79 10 80       	push   $0x8010792a
801044a5:	e8 c6 be ff ff       	call   80100370 <panic>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <yield>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044b7:	68 20 2d 11 80       	push   $0x80112d20
801044bc:	e8 bf 05 00 00       	call   80104a80 <acquire>
  pushcli();
801044c1:	e8 6a 04 00 00       	call   80104930 <pushcli>
  c = mycpu();
801044c6:	e8 f5 f8 ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
801044cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044d1:	e8 aa 04 00 00       	call   80104980 <popcli>
  myproc()->state = RUNNABLE;
801044d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044dd:	e8 ae fc ff ff       	call   80104190 <sched>
  release(&ptable.lock);
801044e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801044e9:	e8 32 05 00 00       	call   80104a20 <release>
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	83 c4 10             	add    $0x10,%esp
801044f4:	c9                   	leave
801044f5:	c3                   	ret
801044f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044fd:	00 
801044fe:	66 90                	xchg   %ax,%ax

80104500 <sleep>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	53                   	push   %ebx
80104506:	83 ec 0c             	sub    $0xc,%esp
80104509:	8b 7d 08             	mov    0x8(%ebp),%edi
8010450c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010450f:	e8 1c 04 00 00       	call   80104930 <pushcli>
  c = mycpu();
80104514:	e8 a7 f8 ff ff       	call   80103dc0 <mycpu>
  p = c->proc;
80104519:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010451f:	e8 5c 04 00 00       	call   80104980 <popcli>
  if(p == 0)
80104524:	85 db                	test   %ebx,%ebx
80104526:	0f 84 87 00 00 00    	je     801045b3 <sleep+0xb3>
  if(lk == 0)
8010452c:	85 f6                	test   %esi,%esi
8010452e:	74 76                	je     801045a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104530:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104536:	74 50                	je     80104588 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 20 2d 11 80       	push   $0x80112d20
80104540:	e8 3b 05 00 00       	call   80104a80 <acquire>
    release(lk);
80104545:	89 34 24             	mov    %esi,(%esp)
80104548:	e8 d3 04 00 00       	call   80104a20 <release>
  p->chan = chan;
8010454d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104550:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104557:	e8 34 fc ff ff       	call   80104190 <sched>
  p->chan = 0;
8010455c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104563:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010456a:	e8 b1 04 00 00       	call   80104a20 <release>
    acquire(lk);
8010456f:	83 c4 10             	add    $0x10,%esp
80104572:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104578:	5b                   	pop    %ebx
80104579:	5e                   	pop    %esi
8010457a:	5f                   	pop    %edi
8010457b:	5d                   	pop    %ebp
    acquire(lk);
8010457c:	e9 ff 04 00 00       	jmp    80104a80 <acquire>
80104581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104588:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010458b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104592:	e8 f9 fb ff ff       	call   80104190 <sched>
  p->chan = 0;
80104597:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010459e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045a1:	5b                   	pop    %ebx
801045a2:	5e                   	pop    %esi
801045a3:	5f                   	pop    %edi
801045a4:	5d                   	pop    %ebp
801045a5:	c3                   	ret
    panic("sleep without lk");
801045a6:	83 ec 0c             	sub    $0xc,%esp
801045a9:	68 30 79 10 80       	push   $0x80107930
801045ae:	e8 bd bd ff ff       	call   80100370 <panic>
    panic("sleep");
801045b3:	83 ec 0c             	sub    $0xc,%esp
801045b6:	68 2a 79 10 80       	push   $0x8010792a
801045bb:	e8 b0 bd ff ff       	call   80100370 <panic>

801045c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 10             	sub    $0x10,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045ca:	68 20 2d 11 80       	push   $0x80112d20
801045cf:	e8 ac 04 00 00       	call   80104a80 <acquire>
801045d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045d7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801045dc:	eb 0c                	jmp    801045ea <wakeup+0x2a>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	83 c0 7c             	add    $0x7c,%eax
801045e3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801045e8:	74 1c                	je     80104606 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801045ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ee:	75 f0                	jne    801045e0 <wakeup+0x20>
801045f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801045f3:	75 eb                	jne    801045e0 <wakeup+0x20>
      p->state = RUNNABLE;
801045f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045fc:	83 c0 7c             	add    $0x7c,%eax
801045ff:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104604:	75 e4                	jne    801045ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104606:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave
  release(&ptable.lock);
80104611:	e9 0a 04 00 00       	jmp    80104a20 <release>
80104616:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010461d:	00 
8010461e:	66 90                	xchg   %ax,%ax

80104620 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 10             	sub    $0x10,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010462a:	68 20 2d 11 80       	push   $0x80112d20
8010462f:	e8 4c 04 00 00       	call   80104a80 <acquire>
80104634:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104637:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010463c:	eb 0c                	jmp    8010464a <kill+0x2a>
8010463e:	66 90                	xchg   %ax,%ax
80104640:	83 c0 7c             	add    $0x7c,%eax
80104643:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104648:	74 36                	je     80104680 <kill+0x60>
    if(p->pid == pid){
8010464a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010464d:	75 f1                	jne    80104640 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010464f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104653:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010465a:	75 07                	jne    80104663 <kill+0x43>
        p->state = RUNNABLE;
8010465c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104663:	83 ec 0c             	sub    $0xc,%esp
80104666:	68 20 2d 11 80       	push   $0x80112d20
8010466b:	e8 b0 03 00 00       	call   80104a20 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104670:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104673:	83 c4 10             	add    $0x10,%esp
80104676:	31 c0                	xor    %eax,%eax
}
80104678:	c9                   	leave
80104679:	c3                   	ret
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	68 20 2d 11 80       	push   $0x80112d20
80104688:	e8 93 03 00 00       	call   80104a20 <release>
}
8010468d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104690:	83 c4 10             	add    $0x10,%esp
80104693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104698:	c9                   	leave
80104699:	c3                   	ret
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	56                   	push   %esi
801046a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046a8:	53                   	push   %ebx
801046a9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801046ae:	83 ec 3c             	sub    $0x3c,%esp
801046b1:	eb 24                	jmp    801046d7 <procdump+0x37>
801046b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 ef 7a 10 80       	push   $0x80107aef
801046c0:	e8 8b c0 ff ff       	call   80100750 <cprintf>
801046c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c8:	83 c3 7c             	add    $0x7c,%ebx
801046cb:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
801046d1:	0f 84 81 00 00 00    	je     80104758 <procdump+0xb8>
    if(p->state == UNUSED)
801046d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046da:	85 c0                	test   %eax,%eax
801046dc:	74 ea                	je     801046c8 <procdump+0x28>
      state = "???";
801046de:	ba 41 79 10 80       	mov    $0x80107941,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046e3:	83 f8 05             	cmp    $0x5,%eax
801046e6:	77 11                	ja     801046f9 <procdump+0x59>
801046e8:	8b 14 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%edx
      state = "???";
801046ef:	b8 41 79 10 80       	mov    $0x80107941,%eax
801046f4:	85 d2                	test   %edx,%edx
801046f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046f9:	53                   	push   %ebx
801046fa:	52                   	push   %edx
801046fb:	ff 73 a4             	push   -0x5c(%ebx)
801046fe:	68 45 79 10 80       	push   $0x80107945
80104703:	e8 48 c0 ff ff       	call   80100750 <cprintf>
    if(p->state == SLEEPING){
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010470f:	75 a7                	jne    801046b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104711:	83 ec 08             	sub    $0x8,%esp
80104714:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104717:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010471a:	50                   	push   %eax
8010471b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010471e:	8b 40 0c             	mov    0xc(%eax),%eax
80104721:	83 c0 08             	add    $0x8,%eax
80104724:	50                   	push   %eax
80104725:	e8 86 01 00 00       	call   801048b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010472a:	83 c4 10             	add    $0x10,%esp
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	8b 17                	mov    (%edi),%edx
80104732:	85 d2                	test   %edx,%edx
80104734:	74 82                	je     801046b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104736:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104739:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010473c:	52                   	push   %edx
8010473d:	68 81 76 10 80       	push   $0x80107681
80104742:	e8 09 c0 ff ff       	call   80100750 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104747:	83 c4 10             	add    $0x10,%esp
8010474a:	39 f7                	cmp    %esi,%edi
8010474c:	75 e2                	jne    80104730 <procdump+0x90>
8010474e:	e9 65 ff ff ff       	jmp    801046b8 <procdump+0x18>
80104753:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475b:	5b                   	pop    %ebx
8010475c:	5e                   	pop    %esi
8010475d:	5f                   	pop    %edi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret

80104760 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 0c             	sub    $0xc,%esp
80104767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010476a:	68 78 79 10 80       	push   $0x80107978
8010476f:	8d 43 04             	lea    0x4(%ebx),%eax
80104772:	50                   	push   %eax
80104773:	e8 18 01 00 00       	call   80104890 <initlock>
  lk->name = name;
80104778:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010477b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104781:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104784:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010478b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010478e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104791:	c9                   	leave
80104792:	c3                   	ret
80104793:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010479a:	00 
8010479b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801047a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047a8:	8d 73 04             	lea    0x4(%ebx),%esi
801047ab:	83 ec 0c             	sub    $0xc,%esp
801047ae:	56                   	push   %esi
801047af:	e8 cc 02 00 00       	call   80104a80 <acquire>
  while (lk->locked) {
801047b4:	8b 13                	mov    (%ebx),%edx
801047b6:	83 c4 10             	add    $0x10,%esp
801047b9:	85 d2                	test   %edx,%edx
801047bb:	74 16                	je     801047d3 <acquiresleep+0x33>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801047c0:	83 ec 08             	sub    $0x8,%esp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	e8 36 fd ff ff       	call   80104500 <sleep>
  while (lk->locked) {
801047ca:	8b 03                	mov    (%ebx),%eax
801047cc:	83 c4 10             	add    $0x10,%esp
801047cf:	85 c0                	test   %eax,%eax
801047d1:	75 ed                	jne    801047c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047d9:	e8 62 f6 ff ff       	call   80103e40 <myproc>
801047de:	8b 40 10             	mov    0x10(%eax),%eax
801047e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ea:	5b                   	pop    %ebx
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
  release(&lk->lk);
801047ed:	e9 2e 02 00 00       	jmp    80104a20 <release>
801047f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047f9:	00 
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104808:	8d 73 04             	lea    0x4(%ebx),%esi
8010480b:	83 ec 0c             	sub    $0xc,%esp
8010480e:	56                   	push   %esi
8010480f:	e8 6c 02 00 00       	call   80104a80 <acquire>
  lk->locked = 0;
80104814:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010481a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104821:	89 1c 24             	mov    %ebx,(%esp)
80104824:	e8 97 fd ff ff       	call   801045c0 <wakeup>
  release(&lk->lk);
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010482f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104832:	5b                   	pop    %ebx
80104833:	5e                   	pop    %esi
80104834:	5d                   	pop    %ebp
  release(&lk->lk);
80104835:	e9 e6 01 00 00       	jmp    80104a20 <release>
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104840 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	31 ff                	xor    %edi,%edi
80104846:	56                   	push   %esi
80104847:	53                   	push   %ebx
80104848:	83 ec 18             	sub    $0x18,%esp
8010484b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010484e:	8d 73 04             	lea    0x4(%ebx),%esi
80104851:	56                   	push   %esi
80104852:	e8 29 02 00 00       	call   80104a80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104857:	8b 03                	mov    (%ebx),%eax
80104859:	83 c4 10             	add    $0x10,%esp
8010485c:	85 c0                	test   %eax,%eax
8010485e:	75 18                	jne    80104878 <holdingsleep+0x38>
  release(&lk->lk);
80104860:	83 ec 0c             	sub    $0xc,%esp
80104863:	56                   	push   %esi
80104864:	e8 b7 01 00 00       	call   80104a20 <release>
  return r;
}
80104869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010486c:	89 f8                	mov    %edi,%eax
8010486e:	5b                   	pop    %ebx
8010486f:	5e                   	pop    %esi
80104870:	5f                   	pop    %edi
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret
80104873:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104878:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010487b:	e8 c0 f5 ff ff       	call   80103e40 <myproc>
80104880:	39 58 10             	cmp    %ebx,0x10(%eax)
80104883:	0f 94 c0             	sete   %al
80104886:	0f b6 c0             	movzbl %al,%eax
80104889:	89 c7                	mov    %eax,%edi
8010488b:	eb d3                	jmp    80104860 <holdingsleep+0x20>
8010488d:	66 90                	xchg   %ax,%ax
8010488f:	90                   	nop

80104890 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104896:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010489f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801048a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret
801048ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801048b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	8b 45 08             	mov    0x8(%ebp),%eax
801048b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048bd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801048c2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801048c7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048cc:	76 10                	jbe    801048de <getcallerpcs+0x2e>
801048ce:	eb 28                	jmp    801048f8 <getcallerpcs+0x48>
801048d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048dc:	77 1a                	ja     801048f8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048de:	8b 5a 04             	mov    0x4(%edx),%ebx
801048e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048e9:	83 f8 0a             	cmp    $0xa,%eax
801048ec:	75 e2                	jne    801048d0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f1:	c9                   	leave
801048f2:	c3                   	ret
801048f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048f8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801048fb:	83 c1 28             	add    $0x28,%ecx
801048fe:	89 ca                	mov    %ecx,%edx
80104900:	29 c2                	sub    %eax,%edx
80104902:	83 e2 04             	and    $0x4,%edx
80104905:	74 11                	je     80104918 <getcallerpcs+0x68>
    pcs[i] = 0;
80104907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010490d:	83 c0 04             	add    $0x4,%eax
80104910:	39 c1                	cmp    %eax,%ecx
80104912:	74 da                	je     801048ee <getcallerpcs+0x3e>
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010491e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104921:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104928:	39 c1                	cmp    %eax,%ecx
8010492a:	75 ec                	jne    80104918 <getcallerpcs+0x68>
8010492c:	eb c0                	jmp    801048ee <getcallerpcs+0x3e>
8010492e:	66 90                	xchg   %ax,%ax

80104930 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	53                   	push   %ebx
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	9c                   	pushf
80104938:	5b                   	pop    %ebx
  asm volatile("cli");
80104939:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010493a:	e8 81 f4 ff ff       	call   80103dc0 <mycpu>
8010493f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104945:	85 c0                	test   %eax,%eax
80104947:	74 17                	je     80104960 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104949:	e8 72 f4 ff ff       	call   80103dc0 <mycpu>
8010494e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104955:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104958:	c9                   	leave
80104959:	c3                   	ret
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104960:	e8 5b f4 ff ff       	call   80103dc0 <mycpu>
80104965:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010496b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104971:	eb d6                	jmp    80104949 <pushcli+0x19>
80104973:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010497a:	00 
8010497b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104980 <popcli>:

void
popcli(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104986:	9c                   	pushf
80104987:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104988:	f6 c4 02             	test   $0x2,%ah
8010498b:	75 35                	jne    801049c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010498d:	e8 2e f4 ff ff       	call   80103dc0 <mycpu>
80104992:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104999:	78 34                	js     801049cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010499b:	e8 20 f4 ff ff       	call   80103dc0 <mycpu>
801049a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049a6:	85 d2                	test   %edx,%edx
801049a8:	74 06                	je     801049b0 <popcli+0x30>
    sti();
}
801049aa:	c9                   	leave
801049ab:	c3                   	ret
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049b0:	e8 0b f4 ff ff       	call   80103dc0 <mycpu>
801049b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049bb:	85 c0                	test   %eax,%eax
801049bd:	74 eb                	je     801049aa <popcli+0x2a>
  asm volatile("sti");
801049bf:	fb                   	sti
}
801049c0:	c9                   	leave
801049c1:	c3                   	ret
    panic("popcli - interruptible");
801049c2:	83 ec 0c             	sub    $0xc,%esp
801049c5:	68 83 79 10 80       	push   $0x80107983
801049ca:	e8 a1 b9 ff ff       	call   80100370 <panic>
    panic("popcli");
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	68 9a 79 10 80       	push   $0x8010799a
801049d7:	e8 94 b9 ff ff       	call   80100370 <panic>
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <holding>:
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 75 08             	mov    0x8(%ebp),%esi
801049e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801049ea:	e8 41 ff ff ff       	call   80104930 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801049ef:	8b 06                	mov    (%esi),%eax
801049f1:	85 c0                	test   %eax,%eax
801049f3:	75 0b                	jne    80104a00 <holding+0x20>
  popcli();
801049f5:	e8 86 ff ff ff       	call   80104980 <popcli>
}
801049fa:	89 d8                	mov    %ebx,%eax
801049fc:	5b                   	pop    %ebx
801049fd:	5e                   	pop    %esi
801049fe:	5d                   	pop    %ebp
801049ff:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104a00:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a03:	e8 b8 f3 ff ff       	call   80103dc0 <mycpu>
80104a08:	39 c3                	cmp    %eax,%ebx
80104a0a:	0f 94 c3             	sete   %bl
  popcli();
80104a0d:	e8 6e ff ff ff       	call   80104980 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a12:	0f b6 db             	movzbl %bl,%ebx
}
80104a15:	89 d8                	mov    %ebx,%eax
80104a17:	5b                   	pop    %ebx
80104a18:	5e                   	pop    %esi
80104a19:	5d                   	pop    %ebp
80104a1a:	c3                   	ret
80104a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a20 <release>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a28:	e8 03 ff ff ff       	call   80104930 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a2d:	8b 03                	mov    (%ebx),%eax
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	75 15                	jne    80104a48 <release+0x28>
  popcli();
80104a33:	e8 48 ff ff ff       	call   80104980 <popcli>
    panic("release");
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	68 a1 79 10 80       	push   $0x801079a1
80104a40:	e8 2b b9 ff ff       	call   80100370 <panic>
80104a45:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a48:	8b 73 08             	mov    0x8(%ebx),%esi
80104a4b:	e8 70 f3 ff ff       	call   80103dc0 <mycpu>
80104a50:	39 c6                	cmp    %eax,%esi
80104a52:	75 df                	jne    80104a33 <release+0x13>
  popcli();
80104a54:	e8 27 ff ff ff       	call   80104980 <popcli>
  lk->pcs[0] = 0;
80104a59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a60:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a67:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a75:	5b                   	pop    %ebx
80104a76:	5e                   	pop    %esi
80104a77:	5d                   	pop    %ebp
  popcli();
80104a78:	e9 03 ff ff ff       	jmp    80104980 <popcli>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <acquire>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104a87:	e8 a4 fe ff ff       	call   80104930 <pushcli>
  if(holding(lk))
80104a8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104a8f:	e8 9c fe ff ff       	call   80104930 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a94:	8b 03                	mov    (%ebx),%eax
80104a96:	85 c0                	test   %eax,%eax
80104a98:	0f 85 b2 00 00 00    	jne    80104b50 <acquire+0xd0>
  popcli();
80104a9e:	e8 dd fe ff ff       	call   80104980 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104aa3:	b9 01 00 00 00       	mov    $0x1,%ecx
80104aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aaf:	00 
  while(xchg(&lk->locked, 1) != 0)
80104ab0:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab3:	89 c8                	mov    %ecx,%eax
80104ab5:	f0 87 02             	lock xchg %eax,(%edx)
80104ab8:	85 c0                	test   %eax,%eax
80104aba:	75 f4                	jne    80104ab0 <acquire+0x30>
  __sync_synchronize();
80104abc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ac4:	e8 f7 f2 ff ff       	call   80103dc0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104acc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104ace:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104ad7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104adc:	77 32                	ja     80104b10 <acquire+0x90>
  ebp = (uint*)v - 2;
80104ade:	89 e8                	mov    %ebp,%eax
80104ae0:	eb 14                	jmp    80104af6 <acquire+0x76>
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ae8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104aee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104af4:	77 1a                	ja     80104b10 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104af6:	8b 58 04             	mov    0x4(%eax),%ebx
80104af9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104afd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b00:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b02:	83 fa 0a             	cmp    $0xa,%edx
80104b05:	75 e1                	jne    80104ae8 <acquire+0x68>
}
80104b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b0a:	c9                   	leave
80104b0b:	c3                   	ret
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b10:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104b14:	83 c1 34             	add    $0x34,%ecx
80104b17:	89 ca                	mov    %ecx,%edx
80104b19:	29 c2                	sub    %eax,%edx
80104b1b:	83 e2 04             	and    $0x4,%edx
80104b1e:	74 10                	je     80104b30 <acquire+0xb0>
    pcs[i] = 0;
80104b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b26:	83 c0 04             	add    $0x4,%eax
80104b29:	39 c1                	cmp    %eax,%ecx
80104b2b:	74 da                	je     80104b07 <acquire+0x87>
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b36:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104b39:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104b40:	39 c1                	cmp    %eax,%ecx
80104b42:	75 ec                	jne    80104b30 <acquire+0xb0>
80104b44:	eb c1                	jmp    80104b07 <acquire+0x87>
80104b46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b4d:	00 
80104b4e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104b50:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104b53:	e8 68 f2 ff ff       	call   80103dc0 <mycpu>
80104b58:	39 c3                	cmp    %eax,%ebx
80104b5a:	0f 85 3e ff ff ff    	jne    80104a9e <acquire+0x1e>
  popcli();
80104b60:	e8 1b fe ff ff       	call   80104980 <popcli>
    panic("acquire");
80104b65:	83 ec 0c             	sub    $0xc,%esp
80104b68:	68 a9 79 10 80       	push   $0x801079a9
80104b6d:	e8 fe b7 ff ff       	call   80100370 <panic>
80104b72:	66 90                	xchg   %ax,%ax
80104b74:	66 90                	xchg   %ax,%ax
80104b76:	66 90                	xchg   %ax,%ax
80104b78:	66 90                	xchg   %ax,%ax
80104b7a:	66 90                	xchg   %ax,%ax
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	8b 55 08             	mov    0x8(%ebp),%edx
80104b87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b8a:	89 d0                	mov    %edx,%eax
80104b8c:	09 c8                	or     %ecx,%eax
80104b8e:	a8 03                	test   $0x3,%al
80104b90:	75 1e                	jne    80104bb0 <memset+0x30>
    c &= 0xFF;
80104b92:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b96:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104b99:	89 d7                	mov    %edx,%edi
80104b9b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104ba1:	fc                   	cld
80104ba2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ba4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104ba7:	89 d0                	mov    %edx,%eax
80104ba9:	c9                   	leave
80104baa:	c3                   	ret
80104bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb3:	89 d7                	mov    %edx,%edi
80104bb5:	fc                   	cld
80104bb6:	f3 aa                	rep stos %al,%es:(%edi)
80104bb8:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104bbb:	89 d0                	mov    %edx,%eax
80104bbd:	c9                   	leave
80104bbe:	c3                   	ret
80104bbf:	90                   	nop

80104bc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	8b 75 10             	mov    0x10(%ebp),%esi
80104bc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104bca:	53                   	push   %ebx
80104bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bce:	85 f6                	test   %esi,%esi
80104bd0:	74 2e                	je     80104c00 <memcmp+0x40>
80104bd2:	01 c6                	add    %eax,%esi
80104bd4:	eb 14                	jmp    80104bea <memcmp+0x2a>
80104bd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bdd:	00 
80104bde:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104be0:	83 c0 01             	add    $0x1,%eax
80104be3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104be6:	39 f0                	cmp    %esi,%eax
80104be8:	74 16                	je     80104c00 <memcmp+0x40>
    if(*s1 != *s2)
80104bea:	0f b6 08             	movzbl (%eax),%ecx
80104bed:	0f b6 1a             	movzbl (%edx),%ebx
80104bf0:	38 d9                	cmp    %bl,%cl
80104bf2:	74 ec                	je     80104be0 <memcmp+0x20>
      return *s1 - *s2;
80104bf4:	0f b6 c1             	movzbl %cl,%eax
80104bf7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104bf9:	5b                   	pop    %ebx
80104bfa:	5e                   	pop    %esi
80104bfb:	5d                   	pop    %ebp
80104bfc:	c3                   	ret
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
80104c00:	5b                   	pop    %ebx
  return 0;
80104c01:	31 c0                	xor    %eax,%eax
}
80104c03:	5e                   	pop    %esi
80104c04:	5d                   	pop    %ebp
80104c05:	c3                   	ret
80104c06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c0d:	00 
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	8b 55 08             	mov    0x8(%ebp),%edx
80104c17:	8b 45 10             	mov    0x10(%ebp),%eax
80104c1a:	56                   	push   %esi
80104c1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c1e:	39 d6                	cmp    %edx,%esi
80104c20:	73 26                	jae    80104c48 <memmove+0x38>
80104c22:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c25:	39 ca                	cmp    %ecx,%edx
80104c27:	73 1f                	jae    80104c48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	74 0f                	je     80104c3c <memmove+0x2c>
80104c2d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104c30:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c34:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c37:	83 e8 01             	sub    $0x1,%eax
80104c3a:	73 f4                	jae    80104c30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c3c:	5e                   	pop    %esi
80104c3d:	89 d0                	mov    %edx,%eax
80104c3f:	5f                   	pop    %edi
80104c40:	5d                   	pop    %ebp
80104c41:	c3                   	ret
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c48:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104c4b:	89 d7                	mov    %edx,%edi
80104c4d:	85 c0                	test   %eax,%eax
80104c4f:	74 eb                	je     80104c3c <memmove+0x2c>
80104c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104c58:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104c59:	39 ce                	cmp    %ecx,%esi
80104c5b:	75 fb                	jne    80104c58 <memmove+0x48>
}
80104c5d:	5e                   	pop    %esi
80104c5e:	89 d0                	mov    %edx,%eax
80104c60:	5f                   	pop    %edi
80104c61:	5d                   	pop    %ebp
80104c62:	c3                   	ret
80104c63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c6a:	00 
80104c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104c70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c70:	eb 9e                	jmp    80104c10 <memmove>
80104c72:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c79:	00 
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	8b 55 10             	mov    0x10(%ebp),%edx
80104c87:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104c8d:	85 d2                	test   %edx,%edx
80104c8f:	75 16                	jne    80104ca7 <strncmp+0x27>
80104c91:	eb 2d                	jmp    80104cc0 <strncmp+0x40>
80104c93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c98:	3a 19                	cmp    (%ecx),%bl
80104c9a:	75 12                	jne    80104cae <strncmp+0x2e>
    n--, p++, q++;
80104c9c:	83 c0 01             	add    $0x1,%eax
80104c9f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104ca2:	83 ea 01             	sub    $0x1,%edx
80104ca5:	74 19                	je     80104cc0 <strncmp+0x40>
80104ca7:	0f b6 18             	movzbl (%eax),%ebx
80104caa:	84 db                	test   %bl,%bl
80104cac:	75 ea                	jne    80104c98 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104cae:	0f b6 00             	movzbl (%eax),%eax
80104cb1:	0f b6 11             	movzbl (%ecx),%edx
}
80104cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104cb8:	29 d0                	sub    %edx,%eax
}
80104cba:	c3                   	ret
80104cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	c9                   	leave
80104cc6:	c3                   	ret
80104cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cce:	00 
80104ccf:	90                   	nop

80104cd0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cd8:	53                   	push   %ebx
80104cd9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cdc:	89 f0                	mov    %esi,%eax
80104cde:	eb 15                	jmp    80104cf5 <strncpy+0x25>
80104ce0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ce4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ce7:	83 c0 01             	add    $0x1,%eax
80104cea:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104cee:	88 48 ff             	mov    %cl,-0x1(%eax)
80104cf1:	84 c9                	test   %cl,%cl
80104cf3:	74 13                	je     80104d08 <strncpy+0x38>
80104cf5:	89 d3                	mov    %edx,%ebx
80104cf7:	83 ea 01             	sub    $0x1,%edx
80104cfa:	85 db                	test   %ebx,%ebx
80104cfc:	7f e2                	jg     80104ce0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104cfe:	5b                   	pop    %ebx
80104cff:	89 f0                	mov    %esi,%eax
80104d01:	5e                   	pop    %esi
80104d02:	5f                   	pop    %edi
80104d03:	5d                   	pop    %ebp
80104d04:	c3                   	ret
80104d05:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104d08:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104d0b:	83 e9 01             	sub    $0x1,%ecx
80104d0e:	85 d2                	test   %edx,%edx
80104d10:	74 ec                	je     80104cfe <strncpy+0x2e>
80104d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104d18:	83 c0 01             	add    $0x1,%eax
80104d1b:	89 ca                	mov    %ecx,%edx
80104d1d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104d21:	29 c2                	sub    %eax,%edx
80104d23:	85 d2                	test   %edx,%edx
80104d25:	7f f1                	jg     80104d18 <strncpy+0x48>
}
80104d27:	5b                   	pop    %ebx
80104d28:	89 f0                	mov    %esi,%eax
80104d2a:	5e                   	pop    %esi
80104d2b:	5f                   	pop    %edi
80104d2c:	5d                   	pop    %ebp
80104d2d:	c3                   	ret
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	8b 55 10             	mov    0x10(%ebp),%edx
80104d37:	8b 75 08             	mov    0x8(%ebp),%esi
80104d3a:	53                   	push   %ebx
80104d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d3e:	85 d2                	test   %edx,%edx
80104d40:	7e 25                	jle    80104d67 <safestrcpy+0x37>
80104d42:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d46:	89 f2                	mov    %esi,%edx
80104d48:	eb 16                	jmp    80104d60 <safestrcpy+0x30>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d50:	0f b6 08             	movzbl (%eax),%ecx
80104d53:	83 c0 01             	add    $0x1,%eax
80104d56:	83 c2 01             	add    $0x1,%edx
80104d59:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d5c:	84 c9                	test   %cl,%cl
80104d5e:	74 04                	je     80104d64 <safestrcpy+0x34>
80104d60:	39 d8                	cmp    %ebx,%eax
80104d62:	75 ec                	jne    80104d50 <safestrcpy+0x20>
    ;
  *s = 0;
80104d64:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104d67:	89 f0                	mov    %esi,%eax
80104d69:	5b                   	pop    %ebx
80104d6a:	5e                   	pop    %esi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <strlen>:

int
strlen(const char *s)
{
80104d70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d71:	31 c0                	xor    %eax,%eax
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d78:	80 3a 00             	cmpb   $0x0,(%edx)
80104d7b:	74 0c                	je     80104d89 <strlen+0x19>
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d87:	75 f7                	jne    80104d80 <strlen+0x10>
    ;
  return n;
}
80104d89:	5d                   	pop    %ebp
80104d8a:	c3                   	ret

80104d8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104d93:	55                   	push   %ebp
  pushl %ebx
80104d94:	53                   	push   %ebx
  pushl %esi
80104d95:	56                   	push   %esi
  pushl %edi
80104d96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104d9b:	5f                   	pop    %edi
  popl %esi
80104d9c:	5e                   	pop    %esi
  popl %ebx
80104d9d:	5b                   	pop    %ebx
  popl %ebp
80104d9e:	5d                   	pop    %ebp
  ret
80104d9f:	c3                   	ret

80104da0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 04             	sub    $0x4,%esp
80104da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104daa:	e8 91 f0 ff ff       	call   80103e40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104daf:	8b 00                	mov    (%eax),%eax
80104db1:	39 c3                	cmp    %eax,%ebx
80104db3:	73 1b                	jae    80104dd0 <fetchint+0x30>
80104db5:	8d 53 04             	lea    0x4(%ebx),%edx
80104db8:	39 d0                	cmp    %edx,%eax
80104dba:	72 14                	jb     80104dd0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dbf:	8b 13                	mov    (%ebx),%edx
80104dc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dc3:	31 c0                	xor    %eax,%eax
}
80104dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc8:	c9                   	leave
80104dc9:	c3                   	ret
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	eb ee                	jmp    80104dc5 <fetchint+0x25>
80104dd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dde:	00 
80104ddf:	90                   	nop

80104de0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
80104de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dea:	e8 51 f0 ff ff       	call   80103e40 <myproc>

  if(addr >= curproc->sz)
80104def:	3b 18                	cmp    (%eax),%ebx
80104df1:	73 2d                	jae    80104e20 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104df3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104df6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104df8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104dfa:	39 d3                	cmp    %edx,%ebx
80104dfc:	73 22                	jae    80104e20 <fetchstr+0x40>
80104dfe:	89 d8                	mov    %ebx,%eax
80104e00:	eb 0d                	jmp    80104e0f <fetchstr+0x2f>
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e08:	83 c0 01             	add    $0x1,%eax
80104e0b:	39 d0                	cmp    %edx,%eax
80104e0d:	73 11                	jae    80104e20 <fetchstr+0x40>
    if(*s == 0)
80104e0f:	80 38 00             	cmpb   $0x0,(%eax)
80104e12:	75 f4                	jne    80104e08 <fetchstr+0x28>
      return s - *pp;
80104e14:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e19:	c9                   	leave
80104e1a:	c3                   	ret
80104e1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104e23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e28:	c9                   	leave
80104e29:	c3                   	ret
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e35:	e8 06 f0 ff ff       	call   80103e40 <myproc>
80104e3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3d:	8b 40 18             	mov    0x18(%eax),%eax
80104e40:	8b 40 44             	mov    0x44(%eax),%eax
80104e43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e46:	e8 f5 ef ff ff       	call   80103e40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e4e:	8b 00                	mov    (%eax),%eax
80104e50:	39 c6                	cmp    %eax,%esi
80104e52:	73 1c                	jae    80104e70 <argint+0x40>
80104e54:	8d 53 08             	lea    0x8(%ebx),%edx
80104e57:	39 d0                	cmp    %edx,%eax
80104e59:	72 15                	jb     80104e70 <argint+0x40>
  *ip = *(int*)(addr);
80104e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e61:	89 10                	mov    %edx,(%eax)
  return 0;
80104e63:	31 c0                	xor    %eax,%eax
}
80104e65:	5b                   	pop    %ebx
80104e66:	5e                   	pop    %esi
80104e67:	5d                   	pop    %ebp
80104e68:	c3                   	ret
80104e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e75:	eb ee                	jmp    80104e65 <argint+0x35>
80104e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e7e:	00 
80104e7f:	90                   	nop

80104e80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104e89:	e8 b2 ef ff ff       	call   80103e40 <myproc>
80104e8e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e90:	e8 ab ef ff ff       	call   80103e40 <myproc>
80104e95:	8b 55 08             	mov    0x8(%ebp),%edx
80104e98:	8b 40 18             	mov    0x18(%eax),%eax
80104e9b:	8b 40 44             	mov    0x44(%eax),%eax
80104e9e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ea1:	e8 9a ef ff ff       	call   80103e40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ea6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ea9:	8b 00                	mov    (%eax),%eax
80104eab:	39 c7                	cmp    %eax,%edi
80104ead:	73 31                	jae    80104ee0 <argptr+0x60>
80104eaf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104eb2:	39 c8                	cmp    %ecx,%eax
80104eb4:	72 2a                	jb     80104ee0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104eb6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104eb9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ebc:	85 d2                	test   %edx,%edx
80104ebe:	78 20                	js     80104ee0 <argptr+0x60>
80104ec0:	8b 16                	mov    (%esi),%edx
80104ec2:	39 d0                	cmp    %edx,%eax
80104ec4:	73 1a                	jae    80104ee0 <argptr+0x60>
80104ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ec9:	01 c3                	add    %eax,%ebx
80104ecb:	39 da                	cmp    %ebx,%edx
80104ecd:	72 11                	jb     80104ee0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ed2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ed4:	31 c0                	xor    %eax,%eax
}
80104ed6:	83 c4 0c             	add    $0xc,%esp
80104ed9:	5b                   	pop    %ebx
80104eda:	5e                   	pop    %esi
80104edb:	5f                   	pop    %edi
80104edc:	5d                   	pop    %ebp
80104edd:	c3                   	ret
80104ede:	66 90                	xchg   %ax,%ax
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb ef                	jmp    80104ed6 <argptr+0x56>
80104ee7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104eee:	00 
80104eef:	90                   	nop

80104ef0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ef5:	e8 46 ef ff ff       	call   80103e40 <myproc>
80104efa:	8b 55 08             	mov    0x8(%ebp),%edx
80104efd:	8b 40 18             	mov    0x18(%eax),%eax
80104f00:	8b 40 44             	mov    0x44(%eax),%eax
80104f03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f06:	e8 35 ef ff ff       	call   80103e40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f0e:	8b 00                	mov    (%eax),%eax
80104f10:	39 c6                	cmp    %eax,%esi
80104f12:	73 44                	jae    80104f58 <argstr+0x68>
80104f14:	8d 53 08             	lea    0x8(%ebx),%edx
80104f17:	39 d0                	cmp    %edx,%eax
80104f19:	72 3d                	jb     80104f58 <argstr+0x68>
  *ip = *(int*)(addr);
80104f1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104f1e:	e8 1d ef ff ff       	call   80103e40 <myproc>
  if(addr >= curproc->sz)
80104f23:	3b 18                	cmp    (%eax),%ebx
80104f25:	73 31                	jae    80104f58 <argstr+0x68>
  *pp = (char*)addr;
80104f27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f2e:	39 d3                	cmp    %edx,%ebx
80104f30:	73 26                	jae    80104f58 <argstr+0x68>
80104f32:	89 d8                	mov    %ebx,%eax
80104f34:	eb 11                	jmp    80104f47 <argstr+0x57>
80104f36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f3d:	00 
80104f3e:	66 90                	xchg   %ax,%ax
80104f40:	83 c0 01             	add    $0x1,%eax
80104f43:	39 d0                	cmp    %edx,%eax
80104f45:	73 11                	jae    80104f58 <argstr+0x68>
    if(*s == 0)
80104f47:	80 38 00             	cmpb   $0x0,(%eax)
80104f4a:	75 f4                	jne    80104f40 <argstr+0x50>
      return s - *pp;
80104f4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104f4e:	5b                   	pop    %ebx
80104f4f:	5e                   	pop    %esi
80104f50:	5d                   	pop    %ebp
80104f51:	c3                   	ret
80104f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f58:	5b                   	pop    %ebx
    return -1;
80104f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f5e:	5e                   	pop    %esi
80104f5f:	5d                   	pop    %ebp
80104f60:	c3                   	ret
80104f61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f68:	00 
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f70 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f77:	e8 c4 ee ff ff       	call   80103e40 <myproc>
80104f7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f7e:	8b 40 18             	mov    0x18(%eax),%eax
80104f81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f87:	83 fa 14             	cmp    $0x14,%edx
80104f8a:	77 24                	ja     80104fb0 <syscall+0x40>
80104f8c:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
80104f93:	85 d2                	test   %edx,%edx
80104f95:	74 19                	je     80104fb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104f97:	ff d2                	call   *%edx
80104f99:	89 c2                	mov    %eax,%edx
80104f9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104f9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104fa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fa4:	c9                   	leave
80104fa5:	c3                   	ret
80104fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fad:	00 
80104fae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104fb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fb4:	50                   	push   %eax
80104fb5:	ff 73 10             	push   0x10(%ebx)
80104fb8:	68 b1 79 10 80       	push   $0x801079b1
80104fbd:	e8 8e b7 ff ff       	call   80100750 <cprintf>
    curproc->tf->eax = -1;
80104fc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104fc5:	83 c4 10             	add    $0x10,%esp
80104fc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd2:	c9                   	leave
80104fd3:	c3                   	ret
80104fd4:	66 90                	xchg   %ax,%ax
80104fd6:	66 90                	xchg   %ax,%ax
80104fd8:	66 90                	xchg   %ax,%ax
80104fda:	66 90                	xchg   %ax,%ax
80104fdc:	66 90                	xchg   %ax,%ax
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fe5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104fe8:	53                   	push   %ebx
80104fe9:	83 ec 34             	sub    $0x34,%esp
80104fec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ff2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ff5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ff8:	57                   	push   %edi
80104ff9:	50                   	push   %eax
80104ffa:	e8 81 d5 ff ff       	call   80102580 <nameiparent>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	74 5e                	je     80105064 <create+0x84>
    return 0;
  ilock(dp);
80105006:	83 ec 0c             	sub    $0xc,%esp
80105009:	89 c3                	mov    %eax,%ebx
8010500b:	50                   	push   %eax
8010500c:	e8 6f cc ff ff       	call   80101c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105011:	83 c4 0c             	add    $0xc,%esp
80105014:	6a 00                	push   $0x0
80105016:	57                   	push   %edi
80105017:	53                   	push   %ebx
80105018:	e8 b3 d1 ff ff       	call   801021d0 <dirlookup>
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	89 c6                	mov    %eax,%esi
80105022:	85 c0                	test   %eax,%eax
80105024:	74 4a                	je     80105070 <create+0x90>
    iunlockput(dp);
80105026:	83 ec 0c             	sub    $0xc,%esp
80105029:	53                   	push   %ebx
8010502a:	e8 e1 ce ff ff       	call   80101f10 <iunlockput>
    ilock(ip);
8010502f:	89 34 24             	mov    %esi,(%esp)
80105032:	e8 49 cc ff ff       	call   80101c80 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010503f:	75 17                	jne    80105058 <create+0x78>
80105041:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105046:	75 10                	jne    80105058 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010504b:	89 f0                	mov    %esi,%eax
8010504d:	5b                   	pop    %ebx
8010504e:	5e                   	pop    %esi
8010504f:	5f                   	pop    %edi
80105050:	5d                   	pop    %ebp
80105051:	c3                   	ret
80105052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105058:	83 ec 0c             	sub    $0xc,%esp
8010505b:	56                   	push   %esi
8010505c:	e8 af ce ff ff       	call   80101f10 <iunlockput>
    return 0;
80105061:	83 c4 10             	add    $0x10,%esp
}
80105064:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105067:	31 f6                	xor    %esi,%esi
}
80105069:	5b                   	pop    %ebx
8010506a:	89 f0                	mov    %esi,%eax
8010506c:	5e                   	pop    %esi
8010506d:	5f                   	pop    %edi
8010506e:	5d                   	pop    %ebp
8010506f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105070:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105074:	83 ec 08             	sub    $0x8,%esp
80105077:	50                   	push   %eax
80105078:	ff 33                	push   (%ebx)
8010507a:	e8 91 ca ff ff       	call   80101b10 <ialloc>
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	89 c6                	mov    %eax,%esi
80105084:	85 c0                	test   %eax,%eax
80105086:	0f 84 bc 00 00 00    	je     80105148 <create+0x168>
  ilock(ip);
8010508c:	83 ec 0c             	sub    $0xc,%esp
8010508f:	50                   	push   %eax
80105090:	e8 eb cb ff ff       	call   80101c80 <ilock>
  ip->major = major;
80105095:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105099:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010509d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801050a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801050a5:	b8 01 00 00 00       	mov    $0x1,%eax
801050aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801050ae:	89 34 24             	mov    %esi,(%esp)
801050b1:	e8 1a cb ff ff       	call   80101bd0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050b6:	83 c4 10             	add    $0x10,%esp
801050b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050be:	74 30                	je     801050f0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801050c0:	83 ec 04             	sub    $0x4,%esp
801050c3:	ff 76 04             	push   0x4(%esi)
801050c6:	57                   	push   %edi
801050c7:	53                   	push   %ebx
801050c8:	e8 d3 d3 ff ff       	call   801024a0 <dirlink>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 67                	js     8010513b <create+0x15b>
  iunlockput(dp);
801050d4:	83 ec 0c             	sub    $0xc,%esp
801050d7:	53                   	push   %ebx
801050d8:	e8 33 ce ff ff       	call   80101f10 <iunlockput>
  return ip;
801050dd:	83 c4 10             	add    $0x10,%esp
}
801050e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050e3:	89 f0                	mov    %esi,%eax
801050e5:	5b                   	pop    %ebx
801050e6:	5e                   	pop    %esi
801050e7:	5f                   	pop    %edi
801050e8:	5d                   	pop    %ebp
801050e9:	c3                   	ret
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801050f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801050f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050f8:	53                   	push   %ebx
801050f9:	e8 d2 ca ff ff       	call   80101bd0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050fe:	83 c4 0c             	add    $0xc,%esp
80105101:	ff 76 04             	push   0x4(%esi)
80105104:	68 e9 79 10 80       	push   $0x801079e9
80105109:	56                   	push   %esi
8010510a:	e8 91 d3 ff ff       	call   801024a0 <dirlink>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	85 c0                	test   %eax,%eax
80105114:	78 18                	js     8010512e <create+0x14e>
80105116:	83 ec 04             	sub    $0x4,%esp
80105119:	ff 73 04             	push   0x4(%ebx)
8010511c:	68 e8 79 10 80       	push   $0x801079e8
80105121:	56                   	push   %esi
80105122:	e8 79 d3 ff ff       	call   801024a0 <dirlink>
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	85 c0                	test   %eax,%eax
8010512c:	79 92                	jns    801050c0 <create+0xe0>
      panic("create dots");
8010512e:	83 ec 0c             	sub    $0xc,%esp
80105131:	68 dc 79 10 80       	push   $0x801079dc
80105136:	e8 35 b2 ff ff       	call   80100370 <panic>
    panic("create: dirlink");
8010513b:	83 ec 0c             	sub    $0xc,%esp
8010513e:	68 eb 79 10 80       	push   $0x801079eb
80105143:	e8 28 b2 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80105148:	83 ec 0c             	sub    $0xc,%esp
8010514b:	68 cd 79 10 80       	push   $0x801079cd
80105150:	e8 1b b2 ff ff       	call   80100370 <panic>
80105155:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010515c:	00 
8010515d:	8d 76 00             	lea    0x0(%esi),%esi

80105160 <sys_dup>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105165:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105168:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010516b:	50                   	push   %eax
8010516c:	6a 00                	push   $0x0
8010516e:	e8 bd fc ff ff       	call   80104e30 <argint>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 36                	js     801051b0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010517a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010517e:	77 30                	ja     801051b0 <sys_dup+0x50>
80105180:	e8 bb ec ff ff       	call   80103e40 <myproc>
80105185:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105188:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010518c:	85 f6                	test   %esi,%esi
8010518e:	74 20                	je     801051b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105190:	e8 ab ec ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105195:	31 db                	xor    %ebx,%ebx
80105197:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010519e:	00 
8010519f:	90                   	nop
    if(curproc->ofile[fd] == 0){
801051a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051a4:	85 d2                	test   %edx,%edx
801051a6:	74 18                	je     801051c0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801051a8:	83 c3 01             	add    $0x1,%ebx
801051ab:	83 fb 10             	cmp    $0x10,%ebx
801051ae:	75 f0                	jne    801051a0 <sys_dup+0x40>
}
801051b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051b8:	89 d8                	mov    %ebx,%eax
801051ba:	5b                   	pop    %ebx
801051bb:	5e                   	pop    %esi
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret
801051be:	66 90                	xchg   %ax,%ax
  filedup(f);
801051c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051c7:	56                   	push   %esi
801051c8:	e8 d3 c1 ff ff       	call   801013a0 <filedup>
  return fd;
801051cd:	83 c4 10             	add    $0x10,%esp
}
801051d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d3:	89 d8                	mov    %ebx,%eax
801051d5:	5b                   	pop    %ebx
801051d6:	5e                   	pop    %esi
801051d7:	5d                   	pop    %ebp
801051d8:	c3                   	ret
801051d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_read>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	53                   	push   %ebx
801051ec:	6a 00                	push   $0x0
801051ee:	e8 3d fc ff ff       	call   80104e30 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 5e                	js     80105258 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 58                	ja     80105258 <sys_read+0x78>
80105200:	e8 3b ec ff ff       	call   80103e40 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010520c:	85 f6                	test   %esi,%esi
8010520e:	74 48                	je     80105258 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105210:	83 ec 08             	sub    $0x8,%esp
80105213:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105216:	50                   	push   %eax
80105217:	6a 02                	push   $0x2
80105219:	e8 12 fc ff ff       	call   80104e30 <argint>
8010521e:	83 c4 10             	add    $0x10,%esp
80105221:	85 c0                	test   %eax,%eax
80105223:	78 33                	js     80105258 <sys_read+0x78>
80105225:	83 ec 04             	sub    $0x4,%esp
80105228:	ff 75 f0             	push   -0x10(%ebp)
8010522b:	53                   	push   %ebx
8010522c:	6a 01                	push   $0x1
8010522e:	e8 4d fc ff ff       	call   80104e80 <argptr>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	78 1e                	js     80105258 <sys_read+0x78>
  return fileread(f, p, n);
8010523a:	83 ec 04             	sub    $0x4,%esp
8010523d:	ff 75 f0             	push   -0x10(%ebp)
80105240:	ff 75 f4             	push   -0xc(%ebp)
80105243:	56                   	push   %esi
80105244:	e8 d7 c2 ff ff       	call   80101520 <fileread>
80105249:	83 c4 10             	add    $0x10,%esp
}
8010524c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010524f:	5b                   	pop    %ebx
80105250:	5e                   	pop    %esi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret
80105253:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525d:	eb ed                	jmp    8010524c <sys_read+0x6c>
8010525f:	90                   	nop

80105260 <sys_write>:
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105265:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105268:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010526b:	53                   	push   %ebx
8010526c:	6a 00                	push   $0x0
8010526e:	e8 bd fb ff ff       	call   80104e30 <argint>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	78 5e                	js     801052d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010527a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010527e:	77 58                	ja     801052d8 <sys_write+0x78>
80105280:	e8 bb eb ff ff       	call   80103e40 <myproc>
80105285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105288:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010528c:	85 f6                	test   %esi,%esi
8010528e:	74 48                	je     801052d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105290:	83 ec 08             	sub    $0x8,%esp
80105293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105296:	50                   	push   %eax
80105297:	6a 02                	push   $0x2
80105299:	e8 92 fb ff ff       	call   80104e30 <argint>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 33                	js     801052d8 <sys_write+0x78>
801052a5:	83 ec 04             	sub    $0x4,%esp
801052a8:	ff 75 f0             	push   -0x10(%ebp)
801052ab:	53                   	push   %ebx
801052ac:	6a 01                	push   $0x1
801052ae:	e8 cd fb ff ff       	call   80104e80 <argptr>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	78 1e                	js     801052d8 <sys_write+0x78>
  return filewrite(f, p, n);
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	ff 75 f0             	push   -0x10(%ebp)
801052c0:	ff 75 f4             	push   -0xc(%ebp)
801052c3:	56                   	push   %esi
801052c4:	e8 e7 c2 ff ff       	call   801015b0 <filewrite>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052cf:	5b                   	pop    %ebx
801052d0:	5e                   	pop    %esi
801052d1:	5d                   	pop    %ebp
801052d2:	c3                   	ret
801052d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801052d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052dd:	eb ed                	jmp    801052cc <sys_write+0x6c>
801052df:	90                   	nop

801052e0 <sys_close>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801052e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801052e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052eb:	50                   	push   %eax
801052ec:	6a 00                	push   $0x0
801052ee:	e8 3d fb ff ff       	call   80104e30 <argint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 3e                	js     80105338 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052fe:	77 38                	ja     80105338 <sys_close+0x58>
80105300:	e8 3b eb ff ff       	call   80103e40 <myproc>
80105305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105308:	8d 5a 08             	lea    0x8(%edx),%ebx
8010530b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010530f:	85 f6                	test   %esi,%esi
80105311:	74 25                	je     80105338 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105313:	e8 28 eb ff ff       	call   80103e40 <myproc>
  fileclose(f);
80105318:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010531b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105322:	00 
  fileclose(f);
80105323:	56                   	push   %esi
80105324:	e8 c7 c0 ff ff       	call   801013f0 <fileclose>
  return 0;
80105329:	83 c4 10             	add    $0x10,%esp
8010532c:	31 c0                	xor    %eax,%eax
}
8010532e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5d                   	pop    %ebp
80105334:	c3                   	ret
80105335:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb ef                	jmp    8010532e <sys_close+0x4e>
8010533f:	90                   	nop

80105340 <sys_fstat>:
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	56                   	push   %esi
80105344:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105345:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105348:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010534b:	53                   	push   %ebx
8010534c:	6a 00                	push   $0x0
8010534e:	e8 dd fa ff ff       	call   80104e30 <argint>
80105353:	83 c4 10             	add    $0x10,%esp
80105356:	85 c0                	test   %eax,%eax
80105358:	78 46                	js     801053a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010535a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010535e:	77 40                	ja     801053a0 <sys_fstat+0x60>
80105360:	e8 db ea ff ff       	call   80103e40 <myproc>
80105365:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105368:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010536c:	85 f6                	test   %esi,%esi
8010536e:	74 30                	je     801053a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105370:	83 ec 04             	sub    $0x4,%esp
80105373:	6a 14                	push   $0x14
80105375:	53                   	push   %ebx
80105376:	6a 01                	push   $0x1
80105378:	e8 03 fb ff ff       	call   80104e80 <argptr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	78 1c                	js     801053a0 <sys_fstat+0x60>
  return filestat(f, st);
80105384:	83 ec 08             	sub    $0x8,%esp
80105387:	ff 75 f4             	push   -0xc(%ebp)
8010538a:	56                   	push   %esi
8010538b:	e8 40 c1 ff ff       	call   801014d0 <filestat>
80105390:	83 c4 10             	add    $0x10,%esp
}
80105393:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105396:	5b                   	pop    %ebx
80105397:	5e                   	pop    %esi
80105398:	5d                   	pop    %ebp
80105399:	c3                   	ret
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801053a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a5:	eb ec                	jmp    80105393 <sys_fstat+0x53>
801053a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ae:	00 
801053af:	90                   	nop

801053b0 <sys_link>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801053b8:	53                   	push   %ebx
801053b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053bc:	50                   	push   %eax
801053bd:	6a 00                	push   $0x0
801053bf:	e8 2c fb ff ff       	call   80104ef0 <argstr>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	0f 88 fb 00 00 00    	js     801054ca <sys_link+0x11a>
801053cf:	83 ec 08             	sub    $0x8,%esp
801053d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053d5:	50                   	push   %eax
801053d6:	6a 01                	push   $0x1
801053d8:	e8 13 fb ff ff       	call   80104ef0 <argstr>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	85 c0                	test   %eax,%eax
801053e2:	0f 88 e2 00 00 00    	js     801054ca <sys_link+0x11a>
  begin_op();
801053e8:	e8 33 de ff ff       	call   80103220 <begin_op>
  if((ip = namei(old)) == 0){
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	ff 75 d4             	push   -0x2c(%ebp)
801053f3:	e8 68 d1 ff ff       	call   80102560 <namei>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	89 c3                	mov    %eax,%ebx
801053fd:	85 c0                	test   %eax,%eax
801053ff:	0f 84 df 00 00 00    	je     801054e4 <sys_link+0x134>
  ilock(ip);
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	50                   	push   %eax
80105409:	e8 72 c8 ff ff       	call   80101c80 <ilock>
  if(ip->type == T_DIR){
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105416:	0f 84 b5 00 00 00    	je     801054d1 <sys_link+0x121>
  iupdate(ip);
8010541c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010541f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105424:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105427:	53                   	push   %ebx
80105428:	e8 a3 c7 ff ff       	call   80101bd0 <iupdate>
  iunlock(ip);
8010542d:	89 1c 24             	mov    %ebx,(%esp)
80105430:	e8 2b c9 ff ff       	call   80101d60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105435:	58                   	pop    %eax
80105436:	5a                   	pop    %edx
80105437:	57                   	push   %edi
80105438:	ff 75 d0             	push   -0x30(%ebp)
8010543b:	e8 40 d1 ff ff       	call   80102580 <nameiparent>
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	89 c6                	mov    %eax,%esi
80105445:	85 c0                	test   %eax,%eax
80105447:	74 5b                	je     801054a4 <sys_link+0xf4>
  ilock(dp);
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	50                   	push   %eax
8010544d:	e8 2e c8 ff ff       	call   80101c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105452:	8b 03                	mov    (%ebx),%eax
80105454:	83 c4 10             	add    $0x10,%esp
80105457:	39 06                	cmp    %eax,(%esi)
80105459:	75 3d                	jne    80105498 <sys_link+0xe8>
8010545b:	83 ec 04             	sub    $0x4,%esp
8010545e:	ff 73 04             	push   0x4(%ebx)
80105461:	57                   	push   %edi
80105462:	56                   	push   %esi
80105463:	e8 38 d0 ff ff       	call   801024a0 <dirlink>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	85 c0                	test   %eax,%eax
8010546d:	78 29                	js     80105498 <sys_link+0xe8>
  iunlockput(dp);
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	56                   	push   %esi
80105473:	e8 98 ca ff ff       	call   80101f10 <iunlockput>
  iput(ip);
80105478:	89 1c 24             	mov    %ebx,(%esp)
8010547b:	e8 30 c9 ff ff       	call   80101db0 <iput>
  end_op();
80105480:	e8 0b de ff ff       	call   80103290 <end_op>
  return 0;
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	31 c0                	xor    %eax,%eax
}
8010548a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010548d:	5b                   	pop    %ebx
8010548e:	5e                   	pop    %esi
8010548f:	5f                   	pop    %edi
80105490:	5d                   	pop    %ebp
80105491:	c3                   	ret
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	56                   	push   %esi
8010549c:	e8 6f ca ff ff       	call   80101f10 <iunlockput>
    goto bad;
801054a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	53                   	push   %ebx
801054a8:	e8 d3 c7 ff ff       	call   80101c80 <ilock>
  ip->nlink--;
801054ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054b2:	89 1c 24             	mov    %ebx,(%esp)
801054b5:	e8 16 c7 ff ff       	call   80101bd0 <iupdate>
  iunlockput(ip);
801054ba:	89 1c 24             	mov    %ebx,(%esp)
801054bd:	e8 4e ca ff ff       	call   80101f10 <iunlockput>
  end_op();
801054c2:	e8 c9 dd ff ff       	call   80103290 <end_op>
  return -1;
801054c7:	83 c4 10             	add    $0x10,%esp
    return -1;
801054ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cf:	eb b9                	jmp    8010548a <sys_link+0xda>
    iunlockput(ip);
801054d1:	83 ec 0c             	sub    $0xc,%esp
801054d4:	53                   	push   %ebx
801054d5:	e8 36 ca ff ff       	call   80101f10 <iunlockput>
    end_op();
801054da:	e8 b1 dd ff ff       	call   80103290 <end_op>
    return -1;
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	eb e6                	jmp    801054ca <sys_link+0x11a>
    end_op();
801054e4:	e8 a7 dd ff ff       	call   80103290 <end_op>
    return -1;
801054e9:	eb df                	jmp    801054ca <sys_link+0x11a>
801054eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801054f0 <sys_unlink>:
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801054f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054f8:	53                   	push   %ebx
801054f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 ec f9 ff ff       	call   80104ef0 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 54 01 00 00    	js     80105663 <sys_unlink+0x173>
  begin_op();
8010550f:	e8 0c dd ff ff       	call   80103220 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105514:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	53                   	push   %ebx
8010551b:	ff 75 c0             	push   -0x40(%ebp)
8010551e:	e8 5d d0 ff ff       	call   80102580 <nameiparent>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105529:	85 c0                	test   %eax,%eax
8010552b:	0f 84 58 01 00 00    	je     80105689 <sys_unlink+0x199>
  ilock(dp);
80105531:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	57                   	push   %edi
80105538:	e8 43 c7 ff ff       	call   80101c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010553d:	58                   	pop    %eax
8010553e:	5a                   	pop    %edx
8010553f:	68 e9 79 10 80       	push   $0x801079e9
80105544:	53                   	push   %ebx
80105545:	e8 66 cc ff ff       	call   801021b0 <namecmp>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	0f 84 fb 00 00 00    	je     80105650 <sys_unlink+0x160>
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	68 e8 79 10 80       	push   $0x801079e8
8010555d:	53                   	push   %ebx
8010555e:	e8 4d cc ff ff       	call   801021b0 <namecmp>
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	0f 84 e2 00 00 00    	je     80105650 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010556e:	83 ec 04             	sub    $0x4,%esp
80105571:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105574:	50                   	push   %eax
80105575:	53                   	push   %ebx
80105576:	57                   	push   %edi
80105577:	e8 54 cc ff ff       	call   801021d0 <dirlookup>
8010557c:	83 c4 10             	add    $0x10,%esp
8010557f:	89 c3                	mov    %eax,%ebx
80105581:	85 c0                	test   %eax,%eax
80105583:	0f 84 c7 00 00 00    	je     80105650 <sys_unlink+0x160>
  ilock(ip);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	50                   	push   %eax
8010558d:	e8 ee c6 ff ff       	call   80101c80 <ilock>
  if(ip->nlink < 1)
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010559a:	0f 8e 0a 01 00 00    	jle    801056aa <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055a8:	74 66                	je     80105610 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801055aa:	83 ec 04             	sub    $0x4,%esp
801055ad:	6a 10                	push   $0x10
801055af:	6a 00                	push   $0x0
801055b1:	57                   	push   %edi
801055b2:	e8 c9 f5 ff ff       	call   80104b80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055b7:	6a 10                	push   $0x10
801055b9:	ff 75 c4             	push   -0x3c(%ebp)
801055bc:	57                   	push   %edi
801055bd:	ff 75 b4             	push   -0x4c(%ebp)
801055c0:	e8 cb ca ff ff       	call   80102090 <writei>
801055c5:	83 c4 20             	add    $0x20,%esp
801055c8:	83 f8 10             	cmp    $0x10,%eax
801055cb:	0f 85 cc 00 00 00    	jne    8010569d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	0f 84 94 00 00 00    	je     80105670 <sys_unlink+0x180>
  iunlockput(dp);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	ff 75 b4             	push   -0x4c(%ebp)
801055e2:	e8 29 c9 ff ff       	call   80101f10 <iunlockput>
  ip->nlink--;
801055e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055ec:	89 1c 24             	mov    %ebx,(%esp)
801055ef:	e8 dc c5 ff ff       	call   80101bd0 <iupdate>
  iunlockput(ip);
801055f4:	89 1c 24             	mov    %ebx,(%esp)
801055f7:	e8 14 c9 ff ff       	call   80101f10 <iunlockput>
  end_op();
801055fc:	e8 8f dc ff ff       	call   80103290 <end_op>
  return 0;
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	31 c0                	xor    %eax,%eax
}
80105606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105609:	5b                   	pop    %ebx
8010560a:	5e                   	pop    %esi
8010560b:	5f                   	pop    %edi
8010560c:	5d                   	pop    %ebp
8010560d:	c3                   	ret
8010560e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105610:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105614:	76 94                	jbe    801055aa <sys_unlink+0xba>
80105616:	be 20 00 00 00       	mov    $0x20,%esi
8010561b:	eb 0b                	jmp    80105628 <sys_unlink+0x138>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
80105620:	83 c6 10             	add    $0x10,%esi
80105623:	3b 73 58             	cmp    0x58(%ebx),%esi
80105626:	73 82                	jae    801055aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105628:	6a 10                	push   $0x10
8010562a:	56                   	push   %esi
8010562b:	57                   	push   %edi
8010562c:	53                   	push   %ebx
8010562d:	e8 5e c9 ff ff       	call   80101f90 <readi>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	83 f8 10             	cmp    $0x10,%eax
80105638:	75 56                	jne    80105690 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010563a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010563f:	74 df                	je     80105620 <sys_unlink+0x130>
    iunlockput(ip);
80105641:	83 ec 0c             	sub    $0xc,%esp
80105644:	53                   	push   %ebx
80105645:	e8 c6 c8 ff ff       	call   80101f10 <iunlockput>
    goto bad;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	ff 75 b4             	push   -0x4c(%ebp)
80105656:	e8 b5 c8 ff ff       	call   80101f10 <iunlockput>
  end_op();
8010565b:	e8 30 dc ff ff       	call   80103290 <end_op>
  return -1;
80105660:	83 c4 10             	add    $0x10,%esp
    return -1;
80105663:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105668:	eb 9c                	jmp    80105606 <sys_unlink+0x116>
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105670:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105673:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105676:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010567b:	50                   	push   %eax
8010567c:	e8 4f c5 ff ff       	call   80101bd0 <iupdate>
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	e9 53 ff ff ff       	jmp    801055dc <sys_unlink+0xec>
    end_op();
80105689:	e8 02 dc ff ff       	call   80103290 <end_op>
    return -1;
8010568e:	eb d3                	jmp    80105663 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	68 0d 7a 10 80       	push   $0x80107a0d
80105698:	e8 d3 ac ff ff       	call   80100370 <panic>
    panic("unlink: writei");
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	68 1f 7a 10 80       	push   $0x80107a1f
801056a5:	e8 c6 ac ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	68 fb 79 10 80       	push   $0x801079fb
801056b2:	e8 b9 ac ff ff       	call   80100370 <panic>
801056b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056be:	00 
801056bf:	90                   	nop

801056c0 <sys_open>:

int
sys_open(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056c8:	53                   	push   %ebx
801056c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056cc:	50                   	push   %eax
801056cd:	6a 00                	push   $0x0
801056cf:	e8 1c f8 ff ff       	call   80104ef0 <argstr>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	0f 88 8e 00 00 00    	js     8010576d <sys_open+0xad>
801056df:	83 ec 08             	sub    $0x8,%esp
801056e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056e5:	50                   	push   %eax
801056e6:	6a 01                	push   $0x1
801056e8:	e8 43 f7 ff ff       	call   80104e30 <argint>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	78 79                	js     8010576d <sys_open+0xad>
    return -1;

  begin_op();
801056f4:	e8 27 db ff ff       	call   80103220 <begin_op>

  if(omode & O_CREATE){
801056f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801056fd:	75 79                	jne    80105778 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801056ff:	83 ec 0c             	sub    $0xc,%esp
80105702:	ff 75 e0             	push   -0x20(%ebp)
80105705:	e8 56 ce ff ff       	call   80102560 <namei>
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	89 c6                	mov    %eax,%esi
8010570f:	85 c0                	test   %eax,%eax
80105711:	0f 84 7e 00 00 00    	je     80105795 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105717:	83 ec 0c             	sub    $0xc,%esp
8010571a:	50                   	push   %eax
8010571b:	e8 60 c5 ff ff       	call   80101c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105720:	83 c4 10             	add    $0x10,%esp
80105723:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105728:	0f 84 ba 00 00 00    	je     801057e8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010572e:	e8 fd bb ff ff       	call   80101330 <filealloc>
80105733:	89 c7                	mov    %eax,%edi
80105735:	85 c0                	test   %eax,%eax
80105737:	74 23                	je     8010575c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105739:	e8 02 e7 ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010573e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105740:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105744:	85 d2                	test   %edx,%edx
80105746:	74 58                	je     801057a0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105748:	83 c3 01             	add    $0x1,%ebx
8010574b:	83 fb 10             	cmp    $0x10,%ebx
8010574e:	75 f0                	jne    80105740 <sys_open+0x80>
    if(f)
      fileclose(f);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	57                   	push   %edi
80105754:	e8 97 bc ff ff       	call   801013f0 <fileclose>
80105759:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	56                   	push   %esi
80105760:	e8 ab c7 ff ff       	call   80101f10 <iunlockput>
    end_op();
80105765:	e8 26 db ff ff       	call   80103290 <end_op>
    return -1;
8010576a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010576d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105772:	eb 65                	jmp    801057d9 <sys_open+0x119>
80105774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	31 c9                	xor    %ecx,%ecx
8010577d:	ba 02 00 00 00       	mov    $0x2,%edx
80105782:	6a 00                	push   $0x0
80105784:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105787:	e8 54 f8 ff ff       	call   80104fe0 <create>
    if(ip == 0){
8010578c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010578f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105791:	85 c0                	test   %eax,%eax
80105793:	75 99                	jne    8010572e <sys_open+0x6e>
      end_op();
80105795:	e8 f6 da ff ff       	call   80103290 <end_op>
      return -1;
8010579a:	eb d1                	jmp    8010576d <sys_open+0xad>
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057a3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801057a7:	56                   	push   %esi
801057a8:	e8 b3 c5 ff ff       	call   80101d60 <iunlock>
  end_op();
801057ad:	e8 de da ff ff       	call   80103290 <end_op>

  f->type = FD_INODE;
801057b2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057bb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057be:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801057c1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801057c3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057ca:	f7 d0                	not    %eax
801057cc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057cf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057d2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057d5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dc:	89 d8                	mov    %ebx,%eax
801057de:	5b                   	pop    %ebx
801057df:	5e                   	pop    %esi
801057e0:	5f                   	pop    %edi
801057e1:	5d                   	pop    %ebp
801057e2:	c3                   	ret
801057e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801057e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057eb:	85 c9                	test   %ecx,%ecx
801057ed:	0f 84 3b ff ff ff    	je     8010572e <sys_open+0x6e>
801057f3:	e9 64 ff ff ff       	jmp    8010575c <sys_open+0x9c>
801057f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ff:	00 

80105800 <sys_mkdir>:

int
sys_mkdir(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105806:	e8 15 da ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105811:	50                   	push   %eax
80105812:	6a 00                	push   $0x0
80105814:	e8 d7 f6 ff ff       	call   80104ef0 <argstr>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	78 30                	js     80105850 <sys_mkdir+0x50>
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105826:	31 c9                	xor    %ecx,%ecx
80105828:	ba 01 00 00 00       	mov    $0x1,%edx
8010582d:	6a 00                	push   $0x0
8010582f:	e8 ac f7 ff ff       	call   80104fe0 <create>
80105834:	83 c4 10             	add    $0x10,%esp
80105837:	85 c0                	test   %eax,%eax
80105839:	74 15                	je     80105850 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010583b:	83 ec 0c             	sub    $0xc,%esp
8010583e:	50                   	push   %eax
8010583f:	e8 cc c6 ff ff       	call   80101f10 <iunlockput>
  end_op();
80105844:	e8 47 da ff ff       	call   80103290 <end_op>
  return 0;
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	31 c0                	xor    %eax,%eax
}
8010584e:	c9                   	leave
8010584f:	c3                   	ret
    end_op();
80105850:	e8 3b da ff ff       	call   80103290 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010585a:	c9                   	leave
8010585b:	c3                   	ret
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_mknod>:

int
sys_mknod(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105866:	e8 b5 d9 ff ff       	call   80103220 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105871:	50                   	push   %eax
80105872:	6a 00                	push   $0x0
80105874:	e8 77 f6 ff ff       	call   80104ef0 <argstr>
80105879:	83 c4 10             	add    $0x10,%esp
8010587c:	85 c0                	test   %eax,%eax
8010587e:	78 60                	js     801058e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105886:	50                   	push   %eax
80105887:	6a 01                	push   $0x1
80105889:	e8 a2 f5 ff ff       	call   80104e30 <argint>
  if((argstr(0, &path)) < 0 ||
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	85 c0                	test   %eax,%eax
80105893:	78 4b                	js     801058e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105895:	83 ec 08             	sub    $0x8,%esp
80105898:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010589b:	50                   	push   %eax
8010589c:	6a 02                	push   $0x2
8010589e:	e8 8d f5 ff ff       	call   80104e30 <argint>
     argint(1, &major) < 0 ||
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	78 36                	js     801058e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058ae:	83 ec 0c             	sub    $0xc,%esp
801058b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058b5:	ba 03 00 00 00       	mov    $0x3,%edx
801058ba:	50                   	push   %eax
801058bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058be:	e8 1d f7 ff ff       	call   80104fe0 <create>
     argint(2, &minor) < 0 ||
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	74 16                	je     801058e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058ca:	83 ec 0c             	sub    $0xc,%esp
801058cd:	50                   	push   %eax
801058ce:	e8 3d c6 ff ff       	call   80101f10 <iunlockput>
  end_op();
801058d3:	e8 b8 d9 ff ff       	call   80103290 <end_op>
  return 0;
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	31 c0                	xor    %eax,%eax
}
801058dd:	c9                   	leave
801058de:	c3                   	ret
801058df:	90                   	nop
    end_op();
801058e0:	e8 ab d9 ff ff       	call   80103290 <end_op>
    return -1;
801058e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ea:	c9                   	leave
801058eb:	c3                   	ret
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_chdir>:

int
sys_chdir(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	56                   	push   %esi
801058f4:	53                   	push   %ebx
801058f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801058f8:	e8 43 e5 ff ff       	call   80103e40 <myproc>
801058fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801058ff:	e8 1c d9 ff ff       	call   80103220 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105904:	83 ec 08             	sub    $0x8,%esp
80105907:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 de f5 ff ff       	call   80104ef0 <argstr>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 77                	js     80105990 <sys_chdir+0xa0>
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	ff 75 f4             	push   -0xc(%ebp)
8010591f:	e8 3c cc ff ff       	call   80102560 <namei>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	89 c3                	mov    %eax,%ebx
80105929:	85 c0                	test   %eax,%eax
8010592b:	74 63                	je     80105990 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010592d:	83 ec 0c             	sub    $0xc,%esp
80105930:	50                   	push   %eax
80105931:	e8 4a c3 ff ff       	call   80101c80 <ilock>
  if(ip->type != T_DIR){
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010593e:	75 30                	jne    80105970 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	53                   	push   %ebx
80105944:	e8 17 c4 ff ff       	call   80101d60 <iunlock>
  iput(curproc->cwd);
80105949:	58                   	pop    %eax
8010594a:	ff 76 68             	push   0x68(%esi)
8010594d:	e8 5e c4 ff ff       	call   80101db0 <iput>
  end_op();
80105952:	e8 39 d9 ff ff       	call   80103290 <end_op>
  curproc->cwd = ip;
80105957:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	31 c0                	xor    %eax,%eax
}
8010595f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105962:	5b                   	pop    %ebx
80105963:	5e                   	pop    %esi
80105964:	5d                   	pop    %ebp
80105965:	c3                   	ret
80105966:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596d:	00 
8010596e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	53                   	push   %ebx
80105974:	e8 97 c5 ff ff       	call   80101f10 <iunlockput>
    end_op();
80105979:	e8 12 d9 ff ff       	call   80103290 <end_op>
    return -1;
8010597e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105986:	eb d7                	jmp    8010595f <sys_chdir+0x6f>
80105988:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598f:	00 
    end_op();
80105990:	e8 fb d8 ff ff       	call   80103290 <end_op>
    return -1;
80105995:	eb ea                	jmp    80105981 <sys_chdir+0x91>
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop

801059a0 <sys_exec>:

int
sys_exec(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059ab:	53                   	push   %ebx
801059ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059b2:	50                   	push   %eax
801059b3:	6a 00                	push   $0x0
801059b5:	e8 36 f5 ff ff       	call   80104ef0 <argstr>
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	85 c0                	test   %eax,%eax
801059bf:	0f 88 87 00 00 00    	js     80105a4c <sys_exec+0xac>
801059c5:	83 ec 08             	sub    $0x8,%esp
801059c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059ce:	50                   	push   %eax
801059cf:	6a 01                	push   $0x1
801059d1:	e8 5a f4 ff ff       	call   80104e30 <argint>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	78 6f                	js     80105a4c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059dd:	83 ec 04             	sub    $0x4,%esp
801059e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801059e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801059e8:	68 80 00 00 00       	push   $0x80
801059ed:	6a 00                	push   $0x0
801059ef:	56                   	push   %esi
801059f0:	e8 8b f1 ff ff       	call   80104b80 <memset>
801059f5:	83 c4 10             	add    $0x10,%esp
801059f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ff:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a00:	83 ec 08             	sub    $0x8,%esp
80105a03:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105a09:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105a10:	50                   	push   %eax
80105a11:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a17:	01 f8                	add    %edi,%eax
80105a19:	50                   	push   %eax
80105a1a:	e8 81 f3 ff ff       	call   80104da0 <fetchint>
80105a1f:	83 c4 10             	add    $0x10,%esp
80105a22:	85 c0                	test   %eax,%eax
80105a24:	78 26                	js     80105a4c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105a26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a2c:	85 c0                	test   %eax,%eax
80105a2e:	74 30                	je     80105a60 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105a36:	52                   	push   %edx
80105a37:	50                   	push   %eax
80105a38:	e8 a3 f3 ff ff       	call   80104de0 <fetchstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	78 08                	js     80105a4c <sys_exec+0xac>
  for(i=0;; i++){
80105a44:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a47:	83 fb 20             	cmp    $0x20,%ebx
80105a4a:	75 b4                	jne    80105a00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a54:	5b                   	pop    %ebx
80105a55:	5e                   	pop    %esi
80105a56:	5f                   	pop    %edi
80105a57:	5d                   	pop    %ebp
80105a58:	c3                   	ret
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105a60:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a67:	00 00 00 00 
  return exec(path, argv);
80105a6b:	83 ec 08             	sub    $0x8,%esp
80105a6e:	56                   	push   %esi
80105a6f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105a75:	e8 16 b5 ff ff       	call   80100f90 <exec>
80105a7a:	83 c4 10             	add    $0x10,%esp
}
80105a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a80:	5b                   	pop    %ebx
80105a81:	5e                   	pop    %esi
80105a82:	5f                   	pop    %edi
80105a83:	5d                   	pop    %ebp
80105a84:	c3                   	ret
80105a85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a8c:	00 
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi

80105a90 <sys_pipe>:

int
sys_pipe(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a95:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a98:	53                   	push   %ebx
80105a99:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a9c:	6a 08                	push   $0x8
80105a9e:	50                   	push   %eax
80105a9f:	6a 00                	push   $0x0
80105aa1:	e8 da f3 ff ff       	call   80104e80 <argptr>
80105aa6:	83 c4 10             	add    $0x10,%esp
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	0f 88 8b 00 00 00    	js     80105b3c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ab1:	83 ec 08             	sub    $0x8,%esp
80105ab4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ab7:	50                   	push   %eax
80105ab8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105abb:	50                   	push   %eax
80105abc:	e8 2f de ff ff       	call   801038f0 <pipealloc>
80105ac1:	83 c4 10             	add    $0x10,%esp
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 74                	js     80105b3c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ac8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105acb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105acd:	e8 6e e3 ff ff       	call   80103e40 <myproc>
    if(curproc->ofile[fd] == 0){
80105ad2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ad6:	85 f6                	test   %esi,%esi
80105ad8:	74 16                	je     80105af0 <sys_pipe+0x60>
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ae0:	83 c3 01             	add    $0x1,%ebx
80105ae3:	83 fb 10             	cmp    $0x10,%ebx
80105ae6:	74 3d                	je     80105b25 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105ae8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105aec:	85 f6                	test   %esi,%esi
80105aee:	75 f0                	jne    80105ae0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105af0:	8d 73 08             	lea    0x8(%ebx),%esi
80105af3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105af7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105afa:	e8 41 e3 ff ff       	call   80103e40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aff:	31 d2                	xor    %edx,%edx
80105b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b08:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b0c:	85 c9                	test   %ecx,%ecx
80105b0e:	74 38                	je     80105b48 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105b10:	83 c2 01             	add    $0x1,%edx
80105b13:	83 fa 10             	cmp    $0x10,%edx
80105b16:	75 f0                	jne    80105b08 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b18:	e8 23 e3 ff ff       	call   80103e40 <myproc>
80105b1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b24:	00 
    fileclose(rf);
80105b25:	83 ec 0c             	sub    $0xc,%esp
80105b28:	ff 75 e0             	push   -0x20(%ebp)
80105b2b:	e8 c0 b8 ff ff       	call   801013f0 <fileclose>
    fileclose(wf);
80105b30:	58                   	pop    %eax
80105b31:	ff 75 e4             	push   -0x1c(%ebp)
80105b34:	e8 b7 b8 ff ff       	call   801013f0 <fileclose>
    return -1;
80105b39:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b41:	eb 16                	jmp    80105b59 <sys_pipe+0xc9>
80105b43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105b48:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105b4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b57:	31 c0                	xor    %eax,%eax
}
80105b59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b5c:	5b                   	pop    %ebx
80105b5d:	5e                   	pop    %esi
80105b5e:	5f                   	pop    %edi
80105b5f:	5d                   	pop    %ebp
80105b60:	c3                   	ret
80105b61:	66 90                	xchg   %ax,%ax
80105b63:	66 90                	xchg   %ax,%ax
80105b65:	66 90                	xchg   %ax,%ax
80105b67:	66 90                	xchg   %ax,%ax
80105b69:	66 90                	xchg   %ax,%ax
80105b6b:	66 90                	xchg   %ax,%ax
80105b6d:	66 90                	xchg   %ax,%ax
80105b6f:	90                   	nop

80105b70 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105b70:	e9 6b e4 ff ff       	jmp    80103fe0 <fork>
80105b75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b7c:	00 
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi

80105b80 <sys_exit>:
}

int
sys_exit(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b86:	e8 c5 e6 ff ff       	call   80104250 <exit>
  return 0;  // not reached
}
80105b8b:	31 c0                	xor    %eax,%eax
80105b8d:	c9                   	leave
80105b8e:	c3                   	ret
80105b8f:	90                   	nop

80105b90 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105b90:	e9 eb e7 ff ff       	jmp    80104380 <wait>
80105b95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9c:	00 
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi

80105ba0 <sys_kill>:
}

int
sys_kill(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ba9:	50                   	push   %eax
80105baa:	6a 00                	push   $0x0
80105bac:	e8 7f f2 ff ff       	call   80104e30 <argint>
80105bb1:	83 c4 10             	add    $0x10,%esp
80105bb4:	85 c0                	test   %eax,%eax
80105bb6:	78 18                	js     80105bd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	ff 75 f4             	push   -0xc(%ebp)
80105bbe:	e8 5d ea ff ff       	call   80104620 <kill>
80105bc3:	83 c4 10             	add    $0x10,%esp
}
80105bc6:	c9                   	leave
80105bc7:	c3                   	ret
80105bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bcf:	00 
80105bd0:	c9                   	leave
    return -1;
80105bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bd6:	c3                   	ret
80105bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bde:	00 
80105bdf:	90                   	nop

80105be0 <sys_getpid>:

int
sys_getpid(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105be6:	e8 55 e2 ff ff       	call   80103e40 <myproc>
80105beb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105bee:	c9                   	leave
80105bef:	c3                   	ret

80105bf0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bfa:	50                   	push   %eax
80105bfb:	6a 00                	push   $0x0
80105bfd:	e8 2e f2 ff ff       	call   80104e30 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 27                	js     80105c30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c09:	e8 32 e2 ff ff       	call   80103e40 <myproc>
  if(growproc(n) < 0)
80105c0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c13:	ff 75 f4             	push   -0xc(%ebp)
80105c16:	e8 45 e3 ff ff       	call   80103f60 <growproc>
80105c1b:	83 c4 10             	add    $0x10,%esp
80105c1e:	85 c0                	test   %eax,%eax
80105c20:	78 0e                	js     80105c30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c22:	89 d8                	mov    %ebx,%eax
80105c24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c27:	c9                   	leave
80105c28:	c3                   	ret
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c35:	eb eb                	jmp    80105c22 <sys_sbrk+0x32>
80105c37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c3e:	00 
80105c3f:	90                   	nop

80105c40 <sys_sleep>:

int
sys_sleep(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c4a:	50                   	push   %eax
80105c4b:	6a 00                	push   $0x0
80105c4d:	e8 de f1 ff ff       	call   80104e30 <argint>
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	85 c0                	test   %eax,%eax
80105c57:	78 64                	js     80105cbd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105c59:	83 ec 0c             	sub    $0xc,%esp
80105c5c:	68 80 4c 11 80       	push   $0x80114c80
80105c61:	e8 1a ee ff ff       	call   80104a80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105c69:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  while(ticks - ticks0 < n){
80105c6f:	83 c4 10             	add    $0x10,%esp
80105c72:	85 d2                	test   %edx,%edx
80105c74:	75 2b                	jne    80105ca1 <sys_sleep+0x61>
80105c76:	eb 58                	jmp    80105cd0 <sys_sleep+0x90>
80105c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c7f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c80:	83 ec 08             	sub    $0x8,%esp
80105c83:	68 80 4c 11 80       	push   $0x80114c80
80105c88:	68 60 4c 11 80       	push   $0x80114c60
80105c8d:	e8 6e e8 ff ff       	call   80104500 <sleep>
  while(ticks - ticks0 < n){
80105c92:	a1 60 4c 11 80       	mov    0x80114c60,%eax
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	29 d8                	sub    %ebx,%eax
80105c9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c9f:	73 2f                	jae    80105cd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ca1:	e8 9a e1 ff ff       	call   80103e40 <myproc>
80105ca6:	8b 40 24             	mov    0x24(%eax),%eax
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	74 d3                	je     80105c80 <sys_sleep+0x40>
      release(&tickslock);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	68 80 4c 11 80       	push   $0x80114c80
80105cb5:	e8 66 ed ff ff       	call   80104a20 <release>
      return -1;
80105cba:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105cbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave
80105cc6:	c3                   	ret
80105cc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cce:	00 
80105ccf:	90                   	nop
  release(&tickslock);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	68 80 4c 11 80       	push   $0x80114c80
80105cd8:	e8 43 ed ff ff       	call   80104a20 <release>
}
80105cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105ce0:	83 c4 10             	add    $0x10,%esp
80105ce3:	31 c0                	xor    %eax,%eax
}
80105ce5:	c9                   	leave
80105ce6:	c3                   	ret
80105ce7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cee:	00 
80105cef:	90                   	nop

80105cf0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	53                   	push   %ebx
80105cf4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105cf7:	68 80 4c 11 80       	push   $0x80114c80
80105cfc:	e8 7f ed ff ff       	call   80104a80 <acquire>
  xticks = ticks;
80105d01:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  release(&tickslock);
80105d07:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105d0e:	e8 0d ed ff ff       	call   80104a20 <release>
  return xticks;
}
80105d13:	89 d8                	mov    %ebx,%eax
80105d15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d18:	c9                   	leave
80105d19:	c3                   	ret

80105d1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d1a:	1e                   	push   %ds
  pushl %es
80105d1b:	06                   	push   %es
  pushl %fs
80105d1c:	0f a0                	push   %fs
  pushl %gs
80105d1e:	0f a8                	push   %gs
  pushal
80105d20:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d29:	54                   	push   %esp
  call trap
80105d2a:	e8 c1 00 00 00       	call   80105df0 <trap>
  addl $4, %esp
80105d2f:	83 c4 04             	add    $0x4,%esp

80105d32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d32:	61                   	popa
  popl %gs
80105d33:	0f a9                	pop    %gs
  popl %fs
80105d35:	0f a1                	pop    %fs
  popl %es
80105d37:	07                   	pop    %es
  popl %ds
80105d38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d39:	83 c4 08             	add    $0x8,%esp
  iret
80105d3c:	cf                   	iret
80105d3d:	66 90                	xchg   %ax,%ax
80105d3f:	90                   	nop

80105d40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d41:	31 c0                	xor    %eax,%eax
{
80105d43:	89 e5                	mov    %esp,%ebp
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d4f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d57:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105d5e:	08 00 00 8e 
80105d62:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105d69:	80 
80105d6a:	c1 ea 10             	shr    $0x10,%edx
80105d6d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105d74:	80 
  for(i = 0; i < 256; i++)
80105d75:	83 c0 01             	add    $0x1,%eax
80105d78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d7d:	75 d1                	jne    80105d50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105d7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105d87:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105d8e:	00 00 ef 
  initlock(&tickslock, "time");
80105d91:	68 2e 7a 10 80       	push   $0x80107a2e
80105d96:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d9b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105da1:	c1 e8 10             	shr    $0x10,%eax
80105da4:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105daa:	e8 e1 ea ff ff       	call   80104890 <initlock>
}
80105daf:	83 c4 10             	add    $0x10,%esp
80105db2:	c9                   	leave
80105db3:	c3                   	ret
80105db4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbb:	00 
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dc0 <idtinit>:

void
idtinit(void)
{
80105dc0:	55                   	push   %ebp
  pd[0] = size-1;
80105dc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dc6:	89 e5                	mov    %esp,%ebp
80105dc8:	83 ec 10             	sub    $0x10,%esp
80105dcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dcf:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105dd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dd8:	c1 e8 10             	shr    $0x10,%eax
80105ddb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ddf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105de2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105de5:	c9                   	leave
80105de6:	c3                   	ret
80105de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dee:	00 
80105def:	90                   	nop

80105df0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	83 ec 1c             	sub    $0x1c,%esp
80105df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105dfc:	8b 43 30             	mov    0x30(%ebx),%eax
80105dff:	83 f8 40             	cmp    $0x40,%eax
80105e02:	0f 84 58 01 00 00    	je     80105f60 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e08:	83 e8 20             	sub    $0x20,%eax
80105e0b:	83 f8 1f             	cmp    $0x1f,%eax
80105e0e:	0f 87 7c 00 00 00    	ja     80105e90 <trap+0xa0>
80105e14:	ff 24 85 d8 7f 10 80 	jmp    *-0x7fef8028(,%eax,4)
80105e1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e20:	e8 eb c8 ff ff       	call   80102710 <ideintr>
    lapiceoi();
80105e25:	e8 a6 cf ff ff       	call   80102dd0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e2a:	e8 11 e0 ff ff       	call   80103e40 <myproc>
80105e2f:	85 c0                	test   %eax,%eax
80105e31:	74 1a                	je     80105e4d <trap+0x5d>
80105e33:	e8 08 e0 ff ff       	call   80103e40 <myproc>
80105e38:	8b 50 24             	mov    0x24(%eax),%edx
80105e3b:	85 d2                	test   %edx,%edx
80105e3d:	74 0e                	je     80105e4d <trap+0x5d>
80105e3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e43:	f7 d0                	not    %eax
80105e45:	a8 03                	test   $0x3,%al
80105e47:	0f 84 db 01 00 00    	je     80106028 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e4d:	e8 ee df ff ff       	call   80103e40 <myproc>
80105e52:	85 c0                	test   %eax,%eax
80105e54:	74 0f                	je     80105e65 <trap+0x75>
80105e56:	e8 e5 df ff ff       	call   80103e40 <myproc>
80105e5b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e5f:	0f 84 ab 00 00 00    	je     80105f10 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e65:	e8 d6 df ff ff       	call   80103e40 <myproc>
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	74 1a                	je     80105e88 <trap+0x98>
80105e6e:	e8 cd df ff ff       	call   80103e40 <myproc>
80105e73:	8b 40 24             	mov    0x24(%eax),%eax
80105e76:	85 c0                	test   %eax,%eax
80105e78:	74 0e                	je     80105e88 <trap+0x98>
80105e7a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105e7e:	f7 d0                	not    %eax
80105e80:	a8 03                	test   $0x3,%al
80105e82:	0f 84 05 01 00 00    	je     80105f8d <trap+0x19d>
    exit();
}
80105e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e8b:	5b                   	pop    %ebx
80105e8c:	5e                   	pop    %esi
80105e8d:	5f                   	pop    %edi
80105e8e:	5d                   	pop    %ebp
80105e8f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e90:	e8 ab df ff ff       	call   80103e40 <myproc>
80105e95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	0f 84 a2 01 00 00    	je     80106042 <trap+0x252>
80105ea0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105ea4:	0f 84 98 01 00 00    	je     80106042 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eaa:	0f 20 d1             	mov    %cr2,%ecx
80105ead:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb0:	e8 6b df ff ff       	call   80103e20 <cpuid>
80105eb5:	8b 73 30             	mov    0x30(%ebx),%esi
80105eb8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ebb:	8b 43 34             	mov    0x34(%ebx),%eax
80105ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ec1:	e8 7a df ff ff       	call   80103e40 <myproc>
80105ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ec9:	e8 72 df ff ff       	call   80103e40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ece:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ed1:	51                   	push   %ecx
80105ed2:	57                   	push   %edi
80105ed3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ed6:	52                   	push   %edx
80105ed7:	ff 75 e4             	push   -0x1c(%ebp)
80105eda:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105edb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ede:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ee1:	56                   	push   %esi
80105ee2:	ff 70 10             	push   0x10(%eax)
80105ee5:	68 d4 7c 10 80       	push   $0x80107cd4
80105eea:	e8 61 a8 ff ff       	call   80100750 <cprintf>
    myproc()->killed = 1;
80105eef:	83 c4 20             	add    $0x20,%esp
80105ef2:	e8 49 df ff ff       	call   80103e40 <myproc>
80105ef7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105efe:	e8 3d df ff ff       	call   80103e40 <myproc>
80105f03:	85 c0                	test   %eax,%eax
80105f05:	0f 85 28 ff ff ff    	jne    80105e33 <trap+0x43>
80105f0b:	e9 3d ff ff ff       	jmp    80105e4d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105f10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f14:	0f 85 4b ff ff ff    	jne    80105e65 <trap+0x75>
    yield();
80105f1a:	e8 91 e5 ff ff       	call   801044b0 <yield>
80105f1f:	e9 41 ff ff ff       	jmp    80105e65 <trap+0x75>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f28:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105f2f:	e8 ec de ff ff       	call   80103e20 <cpuid>
80105f34:	57                   	push   %edi
80105f35:	56                   	push   %esi
80105f36:	50                   	push   %eax
80105f37:	68 7c 7c 10 80       	push   $0x80107c7c
80105f3c:	e8 0f a8 ff ff       	call   80100750 <cprintf>
    lapiceoi();
80105f41:	e8 8a ce ff ff       	call   80102dd0 <lapiceoi>
    break;
80105f46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f49:	e8 f2 de ff ff       	call   80103e40 <myproc>
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	0f 85 dd fe ff ff    	jne    80105e33 <trap+0x43>
80105f56:	e9 f2 fe ff ff       	jmp    80105e4d <trap+0x5d>
80105f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f60:	e8 db de ff ff       	call   80103e40 <myproc>
80105f65:	8b 70 24             	mov    0x24(%eax),%esi
80105f68:	85 f6                	test   %esi,%esi
80105f6a:	0f 85 c8 00 00 00    	jne    80106038 <trap+0x248>
    myproc()->tf = tf;
80105f70:	e8 cb de ff ff       	call   80103e40 <myproc>
80105f75:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105f78:	e8 f3 ef ff ff       	call   80104f70 <syscall>
    if(myproc()->killed)
80105f7d:	e8 be de ff ff       	call   80103e40 <myproc>
80105f82:	8b 48 24             	mov    0x24(%eax),%ecx
80105f85:	85 c9                	test   %ecx,%ecx
80105f87:	0f 84 fb fe ff ff    	je     80105e88 <trap+0x98>
}
80105f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f90:	5b                   	pop    %ebx
80105f91:	5e                   	pop    %esi
80105f92:	5f                   	pop    %edi
80105f93:	5d                   	pop    %ebp
      exit();
80105f94:	e9 b7 e2 ff ff       	jmp    80104250 <exit>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fa0:	e8 4b 02 00 00       	call   801061f0 <uartintr>
    lapiceoi();
80105fa5:	e8 26 ce ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105faa:	e8 91 de ff ff       	call   80103e40 <myproc>
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	0f 85 7c fe ff ff    	jne    80105e33 <trap+0x43>
80105fb7:	e9 91 fe ff ff       	jmp    80105e4d <trap+0x5d>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fc0:	e8 db cc ff ff       	call   80102ca0 <kbdintr>
    lapiceoi();
80105fc5:	e8 06 ce ff ff       	call   80102dd0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fca:	e8 71 de ff ff       	call   80103e40 <myproc>
80105fcf:	85 c0                	test   %eax,%eax
80105fd1:	0f 85 5c fe ff ff    	jne    80105e33 <trap+0x43>
80105fd7:	e9 71 fe ff ff       	jmp    80105e4d <trap+0x5d>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105fe0:	e8 3b de ff ff       	call   80103e20 <cpuid>
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	0f 85 38 fe ff ff    	jne    80105e25 <trap+0x35>
      acquire(&tickslock);
80105fed:	83 ec 0c             	sub    $0xc,%esp
80105ff0:	68 80 4c 11 80       	push   $0x80114c80
80105ff5:	e8 86 ea ff ff       	call   80104a80 <acquire>
      ticks++;
80105ffa:	83 05 60 4c 11 80 01 	addl   $0x1,0x80114c60
      wakeup(&ticks);
80106001:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80106008:	e8 b3 e5 ff ff       	call   801045c0 <wakeup>
      release(&tickslock);
8010600d:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80106014:	e8 07 ea ff ff       	call   80104a20 <release>
80106019:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010601c:	e9 04 fe ff ff       	jmp    80105e25 <trap+0x35>
80106021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106028:	e8 23 e2 ff ff       	call   80104250 <exit>
8010602d:	e9 1b fe ff ff       	jmp    80105e4d <trap+0x5d>
80106032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106038:	e8 13 e2 ff ff       	call   80104250 <exit>
8010603d:	e9 2e ff ff ff       	jmp    80105f70 <trap+0x180>
80106042:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106045:	e8 d6 dd ff ff       	call   80103e20 <cpuid>
8010604a:	83 ec 0c             	sub    $0xc,%esp
8010604d:	56                   	push   %esi
8010604e:	57                   	push   %edi
8010604f:	50                   	push   %eax
80106050:	ff 73 30             	push   0x30(%ebx)
80106053:	68 a0 7c 10 80       	push   $0x80107ca0
80106058:	e8 f3 a6 ff ff       	call   80100750 <cprintf>
      panic("trap");
8010605d:	83 c4 14             	add    $0x14,%esp
80106060:	68 33 7a 10 80       	push   $0x80107a33
80106065:	e8 06 a3 ff ff       	call   80100370 <panic>
8010606a:	66 90                	xchg   %ax,%ax
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106070:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 17                	je     80106090 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106079:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010607e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010607f:	a8 01                	test   $0x1,%al
80106081:	74 0d                	je     80106090 <uartgetc+0x20>
80106083:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106088:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106089:	0f b6 c0             	movzbl %al,%eax
8010608c:	c3                   	ret
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c3                   	ret
80106096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010609d:	00 
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <uartinit>:
{
801060a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a1:	31 c9                	xor    %ecx,%ecx
801060a3:	89 c8                	mov    %ecx,%eax
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	57                   	push   %edi
801060a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801060ad:	56                   	push   %esi
801060ae:	89 fa                	mov    %edi,%edx
801060b0:	53                   	push   %ebx
801060b1:	83 ec 1c             	sub    $0x1c,%esp
801060b4:	ee                   	out    %al,(%dx)
801060b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801060ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060bf:	89 f2                	mov    %esi,%edx
801060c1:	ee                   	out    %al,(%dx)
801060c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060cc:	ee                   	out    %al,(%dx)
801060cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060d2:	89 c8                	mov    %ecx,%eax
801060d4:	89 da                	mov    %ebx,%edx
801060d6:	ee                   	out    %al,(%dx)
801060d7:	b8 03 00 00 00       	mov    $0x3,%eax
801060dc:	89 f2                	mov    %esi,%edx
801060de:	ee                   	out    %al,(%dx)
801060df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060e4:	89 c8                	mov    %ecx,%eax
801060e6:	ee                   	out    %al,(%dx)
801060e7:	b8 01 00 00 00       	mov    $0x1,%eax
801060ec:	89 da                	mov    %ebx,%edx
801060ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060f5:	3c ff                	cmp    $0xff,%al
801060f7:	0f 84 7c 00 00 00    	je     80106179 <uartinit+0xd9>
  uart = 1;
801060fd:	c7 05 c0 54 11 80 01 	movl   $0x1,0x801154c0
80106104:	00 00 00 
80106107:	89 fa                	mov    %edi,%edx
80106109:	ec                   	in     (%dx),%al
8010610a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106110:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106113:	bf 38 7a 10 80       	mov    $0x80107a38,%edi
80106118:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010611d:	6a 00                	push   $0x0
8010611f:	6a 04                	push   $0x4
80106121:	e8 1a c8 ff ff       	call   80102940 <ioapicenable>
80106126:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106129:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106130:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106135:	85 c0                	test   %eax,%eax
80106137:	74 32                	je     8010616b <uartinit+0xcb>
80106139:	89 f2                	mov    %esi,%edx
8010613b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010613c:	a8 20                	test   $0x20,%al
8010613e:	75 21                	jne    80106161 <uartinit+0xc1>
80106140:	bb 80 00 00 00       	mov    $0x80,%ebx
80106145:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106148:	83 ec 0c             	sub    $0xc,%esp
8010614b:	6a 0a                	push   $0xa
8010614d:	e8 9e cc ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	83 eb 01             	sub    $0x1,%ebx
80106158:	74 07                	je     80106161 <uartinit+0xc1>
8010615a:	89 f2                	mov    %esi,%edx
8010615c:	ec                   	in     (%dx),%al
8010615d:	a8 20                	test   $0x20,%al
8010615f:	74 e7                	je     80106148 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106161:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106166:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010616a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010616b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010616f:	83 c7 01             	add    $0x1,%edi
80106172:	88 45 e7             	mov    %al,-0x19(%ebp)
80106175:	84 c0                	test   %al,%al
80106177:	75 b7                	jne    80106130 <uartinit+0x90>
}
80106179:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010617c:	5b                   	pop    %ebx
8010617d:	5e                   	pop    %esi
8010617e:	5f                   	pop    %edi
8010617f:	5d                   	pop    %ebp
80106180:	c3                   	ret
80106181:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106188:	00 
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <uartputc>:
  if(!uart)
80106190:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106195:	85 c0                	test   %eax,%eax
80106197:	74 4f                	je     801061e8 <uartputc+0x58>
{
80106199:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010619f:	89 e5                	mov    %esp,%ebp
801061a1:	56                   	push   %esi
801061a2:	53                   	push   %ebx
801061a3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061a4:	a8 20                	test   $0x20,%al
801061a6:	75 29                	jne    801061d1 <uartputc+0x41>
801061a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801061b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	6a 0a                	push   $0xa
801061bd:	e8 2e cc ff ff       	call   80102df0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	83 eb 01             	sub    $0x1,%ebx
801061c8:	74 07                	je     801061d1 <uartputc+0x41>
801061ca:	89 f2                	mov    %esi,%edx
801061cc:	ec                   	in     (%dx),%al
801061cd:	a8 20                	test   $0x20,%al
801061cf:	74 e7                	je     801061b8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d1:	8b 45 08             	mov    0x8(%ebp),%eax
801061d4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061d9:	ee                   	out    %al,(%dx)
}
801061da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061dd:	5b                   	pop    %ebx
801061de:	5e                   	pop    %esi
801061df:	5d                   	pop    %ebp
801061e0:	c3                   	ret
801061e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061e8:	c3                   	ret
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061f0 <uartintr>:

void
uartintr(void)
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061f6:	68 70 60 10 80       	push   $0x80106070
801061fb:	e8 60 a7 ff ff       	call   80100960 <consoleintr>
}
80106200:	83 c4 10             	add    $0x10,%esp
80106203:	c9                   	leave
80106204:	c3                   	ret

80106205 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $0
80106207:	6a 00                	push   $0x0
  jmp alltraps
80106209:	e9 0c fb ff ff       	jmp    80105d1a <alltraps>

8010620e <vector1>:
.globl vector1
vector1:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $1
80106210:	6a 01                	push   $0x1
  jmp alltraps
80106212:	e9 03 fb ff ff       	jmp    80105d1a <alltraps>

80106217 <vector2>:
.globl vector2
vector2:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $2
80106219:	6a 02                	push   $0x2
  jmp alltraps
8010621b:	e9 fa fa ff ff       	jmp    80105d1a <alltraps>

80106220 <vector3>:
.globl vector3
vector3:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $3
80106222:	6a 03                	push   $0x3
  jmp alltraps
80106224:	e9 f1 fa ff ff       	jmp    80105d1a <alltraps>

80106229 <vector4>:
.globl vector4
vector4:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $4
8010622b:	6a 04                	push   $0x4
  jmp alltraps
8010622d:	e9 e8 fa ff ff       	jmp    80105d1a <alltraps>

80106232 <vector5>:
.globl vector5
vector5:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $5
80106234:	6a 05                	push   $0x5
  jmp alltraps
80106236:	e9 df fa ff ff       	jmp    80105d1a <alltraps>

8010623b <vector6>:
.globl vector6
vector6:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $6
8010623d:	6a 06                	push   $0x6
  jmp alltraps
8010623f:	e9 d6 fa ff ff       	jmp    80105d1a <alltraps>

80106244 <vector7>:
.globl vector7
vector7:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $7
80106246:	6a 07                	push   $0x7
  jmp alltraps
80106248:	e9 cd fa ff ff       	jmp    80105d1a <alltraps>

8010624d <vector8>:
.globl vector8
vector8:
  pushl $8
8010624d:	6a 08                	push   $0x8
  jmp alltraps
8010624f:	e9 c6 fa ff ff       	jmp    80105d1a <alltraps>

80106254 <vector9>:
.globl vector9
vector9:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $9
80106256:	6a 09                	push   $0x9
  jmp alltraps
80106258:	e9 bd fa ff ff       	jmp    80105d1a <alltraps>

8010625d <vector10>:
.globl vector10
vector10:
  pushl $10
8010625d:	6a 0a                	push   $0xa
  jmp alltraps
8010625f:	e9 b6 fa ff ff       	jmp    80105d1a <alltraps>

80106264 <vector11>:
.globl vector11
vector11:
  pushl $11
80106264:	6a 0b                	push   $0xb
  jmp alltraps
80106266:	e9 af fa ff ff       	jmp    80105d1a <alltraps>

8010626b <vector12>:
.globl vector12
vector12:
  pushl $12
8010626b:	6a 0c                	push   $0xc
  jmp alltraps
8010626d:	e9 a8 fa ff ff       	jmp    80105d1a <alltraps>

80106272 <vector13>:
.globl vector13
vector13:
  pushl $13
80106272:	6a 0d                	push   $0xd
  jmp alltraps
80106274:	e9 a1 fa ff ff       	jmp    80105d1a <alltraps>

80106279 <vector14>:
.globl vector14
vector14:
  pushl $14
80106279:	6a 0e                	push   $0xe
  jmp alltraps
8010627b:	e9 9a fa ff ff       	jmp    80105d1a <alltraps>

80106280 <vector15>:
.globl vector15
vector15:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $15
80106282:	6a 0f                	push   $0xf
  jmp alltraps
80106284:	e9 91 fa ff ff       	jmp    80105d1a <alltraps>

80106289 <vector16>:
.globl vector16
vector16:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $16
8010628b:	6a 10                	push   $0x10
  jmp alltraps
8010628d:	e9 88 fa ff ff       	jmp    80105d1a <alltraps>

80106292 <vector17>:
.globl vector17
vector17:
  pushl $17
80106292:	6a 11                	push   $0x11
  jmp alltraps
80106294:	e9 81 fa ff ff       	jmp    80105d1a <alltraps>

80106299 <vector18>:
.globl vector18
vector18:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $18
8010629b:	6a 12                	push   $0x12
  jmp alltraps
8010629d:	e9 78 fa ff ff       	jmp    80105d1a <alltraps>

801062a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $19
801062a4:	6a 13                	push   $0x13
  jmp alltraps
801062a6:	e9 6f fa ff ff       	jmp    80105d1a <alltraps>

801062ab <vector20>:
.globl vector20
vector20:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $20
801062ad:	6a 14                	push   $0x14
  jmp alltraps
801062af:	e9 66 fa ff ff       	jmp    80105d1a <alltraps>

801062b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $21
801062b6:	6a 15                	push   $0x15
  jmp alltraps
801062b8:	e9 5d fa ff ff       	jmp    80105d1a <alltraps>

801062bd <vector22>:
.globl vector22
vector22:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $22
801062bf:	6a 16                	push   $0x16
  jmp alltraps
801062c1:	e9 54 fa ff ff       	jmp    80105d1a <alltraps>

801062c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $23
801062c8:	6a 17                	push   $0x17
  jmp alltraps
801062ca:	e9 4b fa ff ff       	jmp    80105d1a <alltraps>

801062cf <vector24>:
.globl vector24
vector24:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $24
801062d1:	6a 18                	push   $0x18
  jmp alltraps
801062d3:	e9 42 fa ff ff       	jmp    80105d1a <alltraps>

801062d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $25
801062da:	6a 19                	push   $0x19
  jmp alltraps
801062dc:	e9 39 fa ff ff       	jmp    80105d1a <alltraps>

801062e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $26
801062e3:	6a 1a                	push   $0x1a
  jmp alltraps
801062e5:	e9 30 fa ff ff       	jmp    80105d1a <alltraps>

801062ea <vector27>:
.globl vector27
vector27:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $27
801062ec:	6a 1b                	push   $0x1b
  jmp alltraps
801062ee:	e9 27 fa ff ff       	jmp    80105d1a <alltraps>

801062f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $28
801062f5:	6a 1c                	push   $0x1c
  jmp alltraps
801062f7:	e9 1e fa ff ff       	jmp    80105d1a <alltraps>

801062fc <vector29>:
.globl vector29
vector29:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $29
801062fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106300:	e9 15 fa ff ff       	jmp    80105d1a <alltraps>

80106305 <vector30>:
.globl vector30
vector30:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $30
80106307:	6a 1e                	push   $0x1e
  jmp alltraps
80106309:	e9 0c fa ff ff       	jmp    80105d1a <alltraps>

8010630e <vector31>:
.globl vector31
vector31:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $31
80106310:	6a 1f                	push   $0x1f
  jmp alltraps
80106312:	e9 03 fa ff ff       	jmp    80105d1a <alltraps>

80106317 <vector32>:
.globl vector32
vector32:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $32
80106319:	6a 20                	push   $0x20
  jmp alltraps
8010631b:	e9 fa f9 ff ff       	jmp    80105d1a <alltraps>

80106320 <vector33>:
.globl vector33
vector33:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $33
80106322:	6a 21                	push   $0x21
  jmp alltraps
80106324:	e9 f1 f9 ff ff       	jmp    80105d1a <alltraps>

80106329 <vector34>:
.globl vector34
vector34:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $34
8010632b:	6a 22                	push   $0x22
  jmp alltraps
8010632d:	e9 e8 f9 ff ff       	jmp    80105d1a <alltraps>

80106332 <vector35>:
.globl vector35
vector35:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $35
80106334:	6a 23                	push   $0x23
  jmp alltraps
80106336:	e9 df f9 ff ff       	jmp    80105d1a <alltraps>

8010633b <vector36>:
.globl vector36
vector36:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $36
8010633d:	6a 24                	push   $0x24
  jmp alltraps
8010633f:	e9 d6 f9 ff ff       	jmp    80105d1a <alltraps>

80106344 <vector37>:
.globl vector37
vector37:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $37
80106346:	6a 25                	push   $0x25
  jmp alltraps
80106348:	e9 cd f9 ff ff       	jmp    80105d1a <alltraps>

8010634d <vector38>:
.globl vector38
vector38:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $38
8010634f:	6a 26                	push   $0x26
  jmp alltraps
80106351:	e9 c4 f9 ff ff       	jmp    80105d1a <alltraps>

80106356 <vector39>:
.globl vector39
vector39:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $39
80106358:	6a 27                	push   $0x27
  jmp alltraps
8010635a:	e9 bb f9 ff ff       	jmp    80105d1a <alltraps>

8010635f <vector40>:
.globl vector40
vector40:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $40
80106361:	6a 28                	push   $0x28
  jmp alltraps
80106363:	e9 b2 f9 ff ff       	jmp    80105d1a <alltraps>

80106368 <vector41>:
.globl vector41
vector41:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $41
8010636a:	6a 29                	push   $0x29
  jmp alltraps
8010636c:	e9 a9 f9 ff ff       	jmp    80105d1a <alltraps>

80106371 <vector42>:
.globl vector42
vector42:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $42
80106373:	6a 2a                	push   $0x2a
  jmp alltraps
80106375:	e9 a0 f9 ff ff       	jmp    80105d1a <alltraps>

8010637a <vector43>:
.globl vector43
vector43:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $43
8010637c:	6a 2b                	push   $0x2b
  jmp alltraps
8010637e:	e9 97 f9 ff ff       	jmp    80105d1a <alltraps>

80106383 <vector44>:
.globl vector44
vector44:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $44
80106385:	6a 2c                	push   $0x2c
  jmp alltraps
80106387:	e9 8e f9 ff ff       	jmp    80105d1a <alltraps>

8010638c <vector45>:
.globl vector45
vector45:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $45
8010638e:	6a 2d                	push   $0x2d
  jmp alltraps
80106390:	e9 85 f9 ff ff       	jmp    80105d1a <alltraps>

80106395 <vector46>:
.globl vector46
vector46:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $46
80106397:	6a 2e                	push   $0x2e
  jmp alltraps
80106399:	e9 7c f9 ff ff       	jmp    80105d1a <alltraps>

8010639e <vector47>:
.globl vector47
vector47:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $47
801063a0:	6a 2f                	push   $0x2f
  jmp alltraps
801063a2:	e9 73 f9 ff ff       	jmp    80105d1a <alltraps>

801063a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $48
801063a9:	6a 30                	push   $0x30
  jmp alltraps
801063ab:	e9 6a f9 ff ff       	jmp    80105d1a <alltraps>

801063b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $49
801063b2:	6a 31                	push   $0x31
  jmp alltraps
801063b4:	e9 61 f9 ff ff       	jmp    80105d1a <alltraps>

801063b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $50
801063bb:	6a 32                	push   $0x32
  jmp alltraps
801063bd:	e9 58 f9 ff ff       	jmp    80105d1a <alltraps>

801063c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $51
801063c4:	6a 33                	push   $0x33
  jmp alltraps
801063c6:	e9 4f f9 ff ff       	jmp    80105d1a <alltraps>

801063cb <vector52>:
.globl vector52
vector52:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $52
801063cd:	6a 34                	push   $0x34
  jmp alltraps
801063cf:	e9 46 f9 ff ff       	jmp    80105d1a <alltraps>

801063d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $53
801063d6:	6a 35                	push   $0x35
  jmp alltraps
801063d8:	e9 3d f9 ff ff       	jmp    80105d1a <alltraps>

801063dd <vector54>:
.globl vector54
vector54:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $54
801063df:	6a 36                	push   $0x36
  jmp alltraps
801063e1:	e9 34 f9 ff ff       	jmp    80105d1a <alltraps>

801063e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $55
801063e8:	6a 37                	push   $0x37
  jmp alltraps
801063ea:	e9 2b f9 ff ff       	jmp    80105d1a <alltraps>

801063ef <vector56>:
.globl vector56
vector56:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $56
801063f1:	6a 38                	push   $0x38
  jmp alltraps
801063f3:	e9 22 f9 ff ff       	jmp    80105d1a <alltraps>

801063f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $57
801063fa:	6a 39                	push   $0x39
  jmp alltraps
801063fc:	e9 19 f9 ff ff       	jmp    80105d1a <alltraps>

80106401 <vector58>:
.globl vector58
vector58:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $58
80106403:	6a 3a                	push   $0x3a
  jmp alltraps
80106405:	e9 10 f9 ff ff       	jmp    80105d1a <alltraps>

8010640a <vector59>:
.globl vector59
vector59:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $59
8010640c:	6a 3b                	push   $0x3b
  jmp alltraps
8010640e:	e9 07 f9 ff ff       	jmp    80105d1a <alltraps>

80106413 <vector60>:
.globl vector60
vector60:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $60
80106415:	6a 3c                	push   $0x3c
  jmp alltraps
80106417:	e9 fe f8 ff ff       	jmp    80105d1a <alltraps>

8010641c <vector61>:
.globl vector61
vector61:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $61
8010641e:	6a 3d                	push   $0x3d
  jmp alltraps
80106420:	e9 f5 f8 ff ff       	jmp    80105d1a <alltraps>

80106425 <vector62>:
.globl vector62
vector62:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $62
80106427:	6a 3e                	push   $0x3e
  jmp alltraps
80106429:	e9 ec f8 ff ff       	jmp    80105d1a <alltraps>

8010642e <vector63>:
.globl vector63
vector63:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $63
80106430:	6a 3f                	push   $0x3f
  jmp alltraps
80106432:	e9 e3 f8 ff ff       	jmp    80105d1a <alltraps>

80106437 <vector64>:
.globl vector64
vector64:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $64
80106439:	6a 40                	push   $0x40
  jmp alltraps
8010643b:	e9 da f8 ff ff       	jmp    80105d1a <alltraps>

80106440 <vector65>:
.globl vector65
vector65:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $65
80106442:	6a 41                	push   $0x41
  jmp alltraps
80106444:	e9 d1 f8 ff ff       	jmp    80105d1a <alltraps>

80106449 <vector66>:
.globl vector66
vector66:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $66
8010644b:	6a 42                	push   $0x42
  jmp alltraps
8010644d:	e9 c8 f8 ff ff       	jmp    80105d1a <alltraps>

80106452 <vector67>:
.globl vector67
vector67:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $67
80106454:	6a 43                	push   $0x43
  jmp alltraps
80106456:	e9 bf f8 ff ff       	jmp    80105d1a <alltraps>

8010645b <vector68>:
.globl vector68
vector68:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $68
8010645d:	6a 44                	push   $0x44
  jmp alltraps
8010645f:	e9 b6 f8 ff ff       	jmp    80105d1a <alltraps>

80106464 <vector69>:
.globl vector69
vector69:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $69
80106466:	6a 45                	push   $0x45
  jmp alltraps
80106468:	e9 ad f8 ff ff       	jmp    80105d1a <alltraps>

8010646d <vector70>:
.globl vector70
vector70:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $70
8010646f:	6a 46                	push   $0x46
  jmp alltraps
80106471:	e9 a4 f8 ff ff       	jmp    80105d1a <alltraps>

80106476 <vector71>:
.globl vector71
vector71:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $71
80106478:	6a 47                	push   $0x47
  jmp alltraps
8010647a:	e9 9b f8 ff ff       	jmp    80105d1a <alltraps>

8010647f <vector72>:
.globl vector72
vector72:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $72
80106481:	6a 48                	push   $0x48
  jmp alltraps
80106483:	e9 92 f8 ff ff       	jmp    80105d1a <alltraps>

80106488 <vector73>:
.globl vector73
vector73:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $73
8010648a:	6a 49                	push   $0x49
  jmp alltraps
8010648c:	e9 89 f8 ff ff       	jmp    80105d1a <alltraps>

80106491 <vector74>:
.globl vector74
vector74:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $74
80106493:	6a 4a                	push   $0x4a
  jmp alltraps
80106495:	e9 80 f8 ff ff       	jmp    80105d1a <alltraps>

8010649a <vector75>:
.globl vector75
vector75:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $75
8010649c:	6a 4b                	push   $0x4b
  jmp alltraps
8010649e:	e9 77 f8 ff ff       	jmp    80105d1a <alltraps>

801064a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $76
801064a5:	6a 4c                	push   $0x4c
  jmp alltraps
801064a7:	e9 6e f8 ff ff       	jmp    80105d1a <alltraps>

801064ac <vector77>:
.globl vector77
vector77:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $77
801064ae:	6a 4d                	push   $0x4d
  jmp alltraps
801064b0:	e9 65 f8 ff ff       	jmp    80105d1a <alltraps>

801064b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $78
801064b7:	6a 4e                	push   $0x4e
  jmp alltraps
801064b9:	e9 5c f8 ff ff       	jmp    80105d1a <alltraps>

801064be <vector79>:
.globl vector79
vector79:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $79
801064c0:	6a 4f                	push   $0x4f
  jmp alltraps
801064c2:	e9 53 f8 ff ff       	jmp    80105d1a <alltraps>

801064c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $80
801064c9:	6a 50                	push   $0x50
  jmp alltraps
801064cb:	e9 4a f8 ff ff       	jmp    80105d1a <alltraps>

801064d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $81
801064d2:	6a 51                	push   $0x51
  jmp alltraps
801064d4:	e9 41 f8 ff ff       	jmp    80105d1a <alltraps>

801064d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $82
801064db:	6a 52                	push   $0x52
  jmp alltraps
801064dd:	e9 38 f8 ff ff       	jmp    80105d1a <alltraps>

801064e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $83
801064e4:	6a 53                	push   $0x53
  jmp alltraps
801064e6:	e9 2f f8 ff ff       	jmp    80105d1a <alltraps>

801064eb <vector84>:
.globl vector84
vector84:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $84
801064ed:	6a 54                	push   $0x54
  jmp alltraps
801064ef:	e9 26 f8 ff ff       	jmp    80105d1a <alltraps>

801064f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $85
801064f6:	6a 55                	push   $0x55
  jmp alltraps
801064f8:	e9 1d f8 ff ff       	jmp    80105d1a <alltraps>

801064fd <vector86>:
.globl vector86
vector86:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $86
801064ff:	6a 56                	push   $0x56
  jmp alltraps
80106501:	e9 14 f8 ff ff       	jmp    80105d1a <alltraps>

80106506 <vector87>:
.globl vector87
vector87:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $87
80106508:	6a 57                	push   $0x57
  jmp alltraps
8010650a:	e9 0b f8 ff ff       	jmp    80105d1a <alltraps>

8010650f <vector88>:
.globl vector88
vector88:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $88
80106511:	6a 58                	push   $0x58
  jmp alltraps
80106513:	e9 02 f8 ff ff       	jmp    80105d1a <alltraps>

80106518 <vector89>:
.globl vector89
vector89:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $89
8010651a:	6a 59                	push   $0x59
  jmp alltraps
8010651c:	e9 f9 f7 ff ff       	jmp    80105d1a <alltraps>

80106521 <vector90>:
.globl vector90
vector90:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $90
80106523:	6a 5a                	push   $0x5a
  jmp alltraps
80106525:	e9 f0 f7 ff ff       	jmp    80105d1a <alltraps>

8010652a <vector91>:
.globl vector91
vector91:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $91
8010652c:	6a 5b                	push   $0x5b
  jmp alltraps
8010652e:	e9 e7 f7 ff ff       	jmp    80105d1a <alltraps>

80106533 <vector92>:
.globl vector92
vector92:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $92
80106535:	6a 5c                	push   $0x5c
  jmp alltraps
80106537:	e9 de f7 ff ff       	jmp    80105d1a <alltraps>

8010653c <vector93>:
.globl vector93
vector93:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $93
8010653e:	6a 5d                	push   $0x5d
  jmp alltraps
80106540:	e9 d5 f7 ff ff       	jmp    80105d1a <alltraps>

80106545 <vector94>:
.globl vector94
vector94:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $94
80106547:	6a 5e                	push   $0x5e
  jmp alltraps
80106549:	e9 cc f7 ff ff       	jmp    80105d1a <alltraps>

8010654e <vector95>:
.globl vector95
vector95:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $95
80106550:	6a 5f                	push   $0x5f
  jmp alltraps
80106552:	e9 c3 f7 ff ff       	jmp    80105d1a <alltraps>

80106557 <vector96>:
.globl vector96
vector96:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $96
80106559:	6a 60                	push   $0x60
  jmp alltraps
8010655b:	e9 ba f7 ff ff       	jmp    80105d1a <alltraps>

80106560 <vector97>:
.globl vector97
vector97:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $97
80106562:	6a 61                	push   $0x61
  jmp alltraps
80106564:	e9 b1 f7 ff ff       	jmp    80105d1a <alltraps>

80106569 <vector98>:
.globl vector98
vector98:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $98
8010656b:	6a 62                	push   $0x62
  jmp alltraps
8010656d:	e9 a8 f7 ff ff       	jmp    80105d1a <alltraps>

80106572 <vector99>:
.globl vector99
vector99:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $99
80106574:	6a 63                	push   $0x63
  jmp alltraps
80106576:	e9 9f f7 ff ff       	jmp    80105d1a <alltraps>

8010657b <vector100>:
.globl vector100
vector100:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $100
8010657d:	6a 64                	push   $0x64
  jmp alltraps
8010657f:	e9 96 f7 ff ff       	jmp    80105d1a <alltraps>

80106584 <vector101>:
.globl vector101
vector101:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $101
80106586:	6a 65                	push   $0x65
  jmp alltraps
80106588:	e9 8d f7 ff ff       	jmp    80105d1a <alltraps>

8010658d <vector102>:
.globl vector102
vector102:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $102
8010658f:	6a 66                	push   $0x66
  jmp alltraps
80106591:	e9 84 f7 ff ff       	jmp    80105d1a <alltraps>

80106596 <vector103>:
.globl vector103
vector103:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $103
80106598:	6a 67                	push   $0x67
  jmp alltraps
8010659a:	e9 7b f7 ff ff       	jmp    80105d1a <alltraps>

8010659f <vector104>:
.globl vector104
vector104:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $104
801065a1:	6a 68                	push   $0x68
  jmp alltraps
801065a3:	e9 72 f7 ff ff       	jmp    80105d1a <alltraps>

801065a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $105
801065aa:	6a 69                	push   $0x69
  jmp alltraps
801065ac:	e9 69 f7 ff ff       	jmp    80105d1a <alltraps>

801065b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $106
801065b3:	6a 6a                	push   $0x6a
  jmp alltraps
801065b5:	e9 60 f7 ff ff       	jmp    80105d1a <alltraps>

801065ba <vector107>:
.globl vector107
vector107:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $107
801065bc:	6a 6b                	push   $0x6b
  jmp alltraps
801065be:	e9 57 f7 ff ff       	jmp    80105d1a <alltraps>

801065c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $108
801065c5:	6a 6c                	push   $0x6c
  jmp alltraps
801065c7:	e9 4e f7 ff ff       	jmp    80105d1a <alltraps>

801065cc <vector109>:
.globl vector109
vector109:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $109
801065ce:	6a 6d                	push   $0x6d
  jmp alltraps
801065d0:	e9 45 f7 ff ff       	jmp    80105d1a <alltraps>

801065d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $110
801065d7:	6a 6e                	push   $0x6e
  jmp alltraps
801065d9:	e9 3c f7 ff ff       	jmp    80105d1a <alltraps>

801065de <vector111>:
.globl vector111
vector111:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $111
801065e0:	6a 6f                	push   $0x6f
  jmp alltraps
801065e2:	e9 33 f7 ff ff       	jmp    80105d1a <alltraps>

801065e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $112
801065e9:	6a 70                	push   $0x70
  jmp alltraps
801065eb:	e9 2a f7 ff ff       	jmp    80105d1a <alltraps>

801065f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $113
801065f2:	6a 71                	push   $0x71
  jmp alltraps
801065f4:	e9 21 f7 ff ff       	jmp    80105d1a <alltraps>

801065f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $114
801065fb:	6a 72                	push   $0x72
  jmp alltraps
801065fd:	e9 18 f7 ff ff       	jmp    80105d1a <alltraps>

80106602 <vector115>:
.globl vector115
vector115:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $115
80106604:	6a 73                	push   $0x73
  jmp alltraps
80106606:	e9 0f f7 ff ff       	jmp    80105d1a <alltraps>

8010660b <vector116>:
.globl vector116
vector116:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $116
8010660d:	6a 74                	push   $0x74
  jmp alltraps
8010660f:	e9 06 f7 ff ff       	jmp    80105d1a <alltraps>

80106614 <vector117>:
.globl vector117
vector117:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $117
80106616:	6a 75                	push   $0x75
  jmp alltraps
80106618:	e9 fd f6 ff ff       	jmp    80105d1a <alltraps>

8010661d <vector118>:
.globl vector118
vector118:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $118
8010661f:	6a 76                	push   $0x76
  jmp alltraps
80106621:	e9 f4 f6 ff ff       	jmp    80105d1a <alltraps>

80106626 <vector119>:
.globl vector119
vector119:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $119
80106628:	6a 77                	push   $0x77
  jmp alltraps
8010662a:	e9 eb f6 ff ff       	jmp    80105d1a <alltraps>

8010662f <vector120>:
.globl vector120
vector120:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $120
80106631:	6a 78                	push   $0x78
  jmp alltraps
80106633:	e9 e2 f6 ff ff       	jmp    80105d1a <alltraps>

80106638 <vector121>:
.globl vector121
vector121:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $121
8010663a:	6a 79                	push   $0x79
  jmp alltraps
8010663c:	e9 d9 f6 ff ff       	jmp    80105d1a <alltraps>

80106641 <vector122>:
.globl vector122
vector122:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $122
80106643:	6a 7a                	push   $0x7a
  jmp alltraps
80106645:	e9 d0 f6 ff ff       	jmp    80105d1a <alltraps>

8010664a <vector123>:
.globl vector123
vector123:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $123
8010664c:	6a 7b                	push   $0x7b
  jmp alltraps
8010664e:	e9 c7 f6 ff ff       	jmp    80105d1a <alltraps>

80106653 <vector124>:
.globl vector124
vector124:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $124
80106655:	6a 7c                	push   $0x7c
  jmp alltraps
80106657:	e9 be f6 ff ff       	jmp    80105d1a <alltraps>

8010665c <vector125>:
.globl vector125
vector125:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $125
8010665e:	6a 7d                	push   $0x7d
  jmp alltraps
80106660:	e9 b5 f6 ff ff       	jmp    80105d1a <alltraps>

80106665 <vector126>:
.globl vector126
vector126:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $126
80106667:	6a 7e                	push   $0x7e
  jmp alltraps
80106669:	e9 ac f6 ff ff       	jmp    80105d1a <alltraps>

8010666e <vector127>:
.globl vector127
vector127:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $127
80106670:	6a 7f                	push   $0x7f
  jmp alltraps
80106672:	e9 a3 f6 ff ff       	jmp    80105d1a <alltraps>

80106677 <vector128>:
.globl vector128
vector128:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $128
80106679:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010667e:	e9 97 f6 ff ff       	jmp    80105d1a <alltraps>

80106683 <vector129>:
.globl vector129
vector129:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $129
80106685:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010668a:	e9 8b f6 ff ff       	jmp    80105d1a <alltraps>

8010668f <vector130>:
.globl vector130
vector130:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $130
80106691:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106696:	e9 7f f6 ff ff       	jmp    80105d1a <alltraps>

8010669b <vector131>:
.globl vector131
vector131:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $131
8010669d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066a2:	e9 73 f6 ff ff       	jmp    80105d1a <alltraps>

801066a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $132
801066a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ae:	e9 67 f6 ff ff       	jmp    80105d1a <alltraps>

801066b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $133
801066b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ba:	e9 5b f6 ff ff       	jmp    80105d1a <alltraps>

801066bf <vector134>:
.globl vector134
vector134:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $134
801066c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066c6:	e9 4f f6 ff ff       	jmp    80105d1a <alltraps>

801066cb <vector135>:
.globl vector135
vector135:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $135
801066cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066d2:	e9 43 f6 ff ff       	jmp    80105d1a <alltraps>

801066d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $136
801066d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066de:	e9 37 f6 ff ff       	jmp    80105d1a <alltraps>

801066e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $137
801066e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066ea:	e9 2b f6 ff ff       	jmp    80105d1a <alltraps>

801066ef <vector138>:
.globl vector138
vector138:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $138
801066f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066f6:	e9 1f f6 ff ff       	jmp    80105d1a <alltraps>

801066fb <vector139>:
.globl vector139
vector139:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $139
801066fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106702:	e9 13 f6 ff ff       	jmp    80105d1a <alltraps>

80106707 <vector140>:
.globl vector140
vector140:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $140
80106709:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010670e:	e9 07 f6 ff ff       	jmp    80105d1a <alltraps>

80106713 <vector141>:
.globl vector141
vector141:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $141
80106715:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010671a:	e9 fb f5 ff ff       	jmp    80105d1a <alltraps>

8010671f <vector142>:
.globl vector142
vector142:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $142
80106721:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106726:	e9 ef f5 ff ff       	jmp    80105d1a <alltraps>

8010672b <vector143>:
.globl vector143
vector143:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $143
8010672d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106732:	e9 e3 f5 ff ff       	jmp    80105d1a <alltraps>

80106737 <vector144>:
.globl vector144
vector144:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $144
80106739:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010673e:	e9 d7 f5 ff ff       	jmp    80105d1a <alltraps>

80106743 <vector145>:
.globl vector145
vector145:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $145
80106745:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010674a:	e9 cb f5 ff ff       	jmp    80105d1a <alltraps>

8010674f <vector146>:
.globl vector146
vector146:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $146
80106751:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106756:	e9 bf f5 ff ff       	jmp    80105d1a <alltraps>

8010675b <vector147>:
.globl vector147
vector147:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $147
8010675d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106762:	e9 b3 f5 ff ff       	jmp    80105d1a <alltraps>

80106767 <vector148>:
.globl vector148
vector148:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $148
80106769:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010676e:	e9 a7 f5 ff ff       	jmp    80105d1a <alltraps>

80106773 <vector149>:
.globl vector149
vector149:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $149
80106775:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010677a:	e9 9b f5 ff ff       	jmp    80105d1a <alltraps>

8010677f <vector150>:
.globl vector150
vector150:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $150
80106781:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106786:	e9 8f f5 ff ff       	jmp    80105d1a <alltraps>

8010678b <vector151>:
.globl vector151
vector151:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $151
8010678d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106792:	e9 83 f5 ff ff       	jmp    80105d1a <alltraps>

80106797 <vector152>:
.globl vector152
vector152:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $152
80106799:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010679e:	e9 77 f5 ff ff       	jmp    80105d1a <alltraps>

801067a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $153
801067a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067aa:	e9 6b f5 ff ff       	jmp    80105d1a <alltraps>

801067af <vector154>:
.globl vector154
vector154:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $154
801067b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067b6:	e9 5f f5 ff ff       	jmp    80105d1a <alltraps>

801067bb <vector155>:
.globl vector155
vector155:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $155
801067bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067c2:	e9 53 f5 ff ff       	jmp    80105d1a <alltraps>

801067c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $156
801067c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067ce:	e9 47 f5 ff ff       	jmp    80105d1a <alltraps>

801067d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $157
801067d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067da:	e9 3b f5 ff ff       	jmp    80105d1a <alltraps>

801067df <vector158>:
.globl vector158
vector158:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $158
801067e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067e6:	e9 2f f5 ff ff       	jmp    80105d1a <alltraps>

801067eb <vector159>:
.globl vector159
vector159:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $159
801067ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067f2:	e9 23 f5 ff ff       	jmp    80105d1a <alltraps>

801067f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $160
801067f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067fe:	e9 17 f5 ff ff       	jmp    80105d1a <alltraps>

80106803 <vector161>:
.globl vector161
vector161:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $161
80106805:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010680a:	e9 0b f5 ff ff       	jmp    80105d1a <alltraps>

8010680f <vector162>:
.globl vector162
vector162:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $162
80106811:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106816:	e9 ff f4 ff ff       	jmp    80105d1a <alltraps>

8010681b <vector163>:
.globl vector163
vector163:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $163
8010681d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106822:	e9 f3 f4 ff ff       	jmp    80105d1a <alltraps>

80106827 <vector164>:
.globl vector164
vector164:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $164
80106829:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010682e:	e9 e7 f4 ff ff       	jmp    80105d1a <alltraps>

80106833 <vector165>:
.globl vector165
vector165:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $165
80106835:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010683a:	e9 db f4 ff ff       	jmp    80105d1a <alltraps>

8010683f <vector166>:
.globl vector166
vector166:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $166
80106841:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106846:	e9 cf f4 ff ff       	jmp    80105d1a <alltraps>

8010684b <vector167>:
.globl vector167
vector167:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $167
8010684d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106852:	e9 c3 f4 ff ff       	jmp    80105d1a <alltraps>

80106857 <vector168>:
.globl vector168
vector168:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $168
80106859:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010685e:	e9 b7 f4 ff ff       	jmp    80105d1a <alltraps>

80106863 <vector169>:
.globl vector169
vector169:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $169
80106865:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010686a:	e9 ab f4 ff ff       	jmp    80105d1a <alltraps>

8010686f <vector170>:
.globl vector170
vector170:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $170
80106871:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106876:	e9 9f f4 ff ff       	jmp    80105d1a <alltraps>

8010687b <vector171>:
.globl vector171
vector171:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $171
8010687d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106882:	e9 93 f4 ff ff       	jmp    80105d1a <alltraps>

80106887 <vector172>:
.globl vector172
vector172:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $172
80106889:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010688e:	e9 87 f4 ff ff       	jmp    80105d1a <alltraps>

80106893 <vector173>:
.globl vector173
vector173:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $173
80106895:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010689a:	e9 7b f4 ff ff       	jmp    80105d1a <alltraps>

8010689f <vector174>:
.globl vector174
vector174:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $174
801068a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068a6:	e9 6f f4 ff ff       	jmp    80105d1a <alltraps>

801068ab <vector175>:
.globl vector175
vector175:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $175
801068ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068b2:	e9 63 f4 ff ff       	jmp    80105d1a <alltraps>

801068b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $176
801068b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068be:	e9 57 f4 ff ff       	jmp    80105d1a <alltraps>

801068c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $177
801068c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068ca:	e9 4b f4 ff ff       	jmp    80105d1a <alltraps>

801068cf <vector178>:
.globl vector178
vector178:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $178
801068d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068d6:	e9 3f f4 ff ff       	jmp    80105d1a <alltraps>

801068db <vector179>:
.globl vector179
vector179:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $179
801068dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068e2:	e9 33 f4 ff ff       	jmp    80105d1a <alltraps>

801068e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $180
801068e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068ee:	e9 27 f4 ff ff       	jmp    80105d1a <alltraps>

801068f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $181
801068f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068fa:	e9 1b f4 ff ff       	jmp    80105d1a <alltraps>

801068ff <vector182>:
.globl vector182
vector182:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $182
80106901:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106906:	e9 0f f4 ff ff       	jmp    80105d1a <alltraps>

8010690b <vector183>:
.globl vector183
vector183:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $183
8010690d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106912:	e9 03 f4 ff ff       	jmp    80105d1a <alltraps>

80106917 <vector184>:
.globl vector184
vector184:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $184
80106919:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010691e:	e9 f7 f3 ff ff       	jmp    80105d1a <alltraps>

80106923 <vector185>:
.globl vector185
vector185:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $185
80106925:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010692a:	e9 eb f3 ff ff       	jmp    80105d1a <alltraps>

8010692f <vector186>:
.globl vector186
vector186:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $186
80106931:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106936:	e9 df f3 ff ff       	jmp    80105d1a <alltraps>

8010693b <vector187>:
.globl vector187
vector187:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $187
8010693d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106942:	e9 d3 f3 ff ff       	jmp    80105d1a <alltraps>

80106947 <vector188>:
.globl vector188
vector188:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $188
80106949:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010694e:	e9 c7 f3 ff ff       	jmp    80105d1a <alltraps>

80106953 <vector189>:
.globl vector189
vector189:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $189
80106955:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010695a:	e9 bb f3 ff ff       	jmp    80105d1a <alltraps>

8010695f <vector190>:
.globl vector190
vector190:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $190
80106961:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106966:	e9 af f3 ff ff       	jmp    80105d1a <alltraps>

8010696b <vector191>:
.globl vector191
vector191:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $191
8010696d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106972:	e9 a3 f3 ff ff       	jmp    80105d1a <alltraps>

80106977 <vector192>:
.globl vector192
vector192:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $192
80106979:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010697e:	e9 97 f3 ff ff       	jmp    80105d1a <alltraps>

80106983 <vector193>:
.globl vector193
vector193:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $193
80106985:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010698a:	e9 8b f3 ff ff       	jmp    80105d1a <alltraps>

8010698f <vector194>:
.globl vector194
vector194:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $194
80106991:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106996:	e9 7f f3 ff ff       	jmp    80105d1a <alltraps>

8010699b <vector195>:
.globl vector195
vector195:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $195
8010699d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069a2:	e9 73 f3 ff ff       	jmp    80105d1a <alltraps>

801069a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $196
801069a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ae:	e9 67 f3 ff ff       	jmp    80105d1a <alltraps>

801069b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $197
801069b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ba:	e9 5b f3 ff ff       	jmp    80105d1a <alltraps>

801069bf <vector198>:
.globl vector198
vector198:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $198
801069c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069c6:	e9 4f f3 ff ff       	jmp    80105d1a <alltraps>

801069cb <vector199>:
.globl vector199
vector199:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $199
801069cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069d2:	e9 43 f3 ff ff       	jmp    80105d1a <alltraps>

801069d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $200
801069d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069de:	e9 37 f3 ff ff       	jmp    80105d1a <alltraps>

801069e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $201
801069e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069ea:	e9 2b f3 ff ff       	jmp    80105d1a <alltraps>

801069ef <vector202>:
.globl vector202
vector202:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $202
801069f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069f6:	e9 1f f3 ff ff       	jmp    80105d1a <alltraps>

801069fb <vector203>:
.globl vector203
vector203:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $203
801069fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a02:	e9 13 f3 ff ff       	jmp    80105d1a <alltraps>

80106a07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $204
80106a09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a0e:	e9 07 f3 ff ff       	jmp    80105d1a <alltraps>

80106a13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $205
80106a15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a1a:	e9 fb f2 ff ff       	jmp    80105d1a <alltraps>

80106a1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $206
80106a21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a26:	e9 ef f2 ff ff       	jmp    80105d1a <alltraps>

80106a2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $207
80106a2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a32:	e9 e3 f2 ff ff       	jmp    80105d1a <alltraps>

80106a37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $208
80106a39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a3e:	e9 d7 f2 ff ff       	jmp    80105d1a <alltraps>

80106a43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $209
80106a45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a4a:	e9 cb f2 ff ff       	jmp    80105d1a <alltraps>

80106a4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $210
80106a51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a56:	e9 bf f2 ff ff       	jmp    80105d1a <alltraps>

80106a5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $211
80106a5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a62:	e9 b3 f2 ff ff       	jmp    80105d1a <alltraps>

80106a67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $212
80106a69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a6e:	e9 a7 f2 ff ff       	jmp    80105d1a <alltraps>

80106a73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $213
80106a75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a7a:	e9 9b f2 ff ff       	jmp    80105d1a <alltraps>

80106a7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $214
80106a81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a86:	e9 8f f2 ff ff       	jmp    80105d1a <alltraps>

80106a8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $215
80106a8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a92:	e9 83 f2 ff ff       	jmp    80105d1a <alltraps>

80106a97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $216
80106a99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a9e:	e9 77 f2 ff ff       	jmp    80105d1a <alltraps>

80106aa3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $217
80106aa5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aaa:	e9 6b f2 ff ff       	jmp    80105d1a <alltraps>

80106aaf <vector218>:
.globl vector218
vector218:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $218
80106ab1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ab6:	e9 5f f2 ff ff       	jmp    80105d1a <alltraps>

80106abb <vector219>:
.globl vector219
vector219:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $219
80106abd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ac2:	e9 53 f2 ff ff       	jmp    80105d1a <alltraps>

80106ac7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $220
80106ac9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ace:	e9 47 f2 ff ff       	jmp    80105d1a <alltraps>

80106ad3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $221
80106ad5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ada:	e9 3b f2 ff ff       	jmp    80105d1a <alltraps>

80106adf <vector222>:
.globl vector222
vector222:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $222
80106ae1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ae6:	e9 2f f2 ff ff       	jmp    80105d1a <alltraps>

80106aeb <vector223>:
.globl vector223
vector223:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $223
80106aed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106af2:	e9 23 f2 ff ff       	jmp    80105d1a <alltraps>

80106af7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $224
80106af9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106afe:	e9 17 f2 ff ff       	jmp    80105d1a <alltraps>

80106b03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $225
80106b05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b0a:	e9 0b f2 ff ff       	jmp    80105d1a <alltraps>

80106b0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $226
80106b11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b16:	e9 ff f1 ff ff       	jmp    80105d1a <alltraps>

80106b1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $227
80106b1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b22:	e9 f3 f1 ff ff       	jmp    80105d1a <alltraps>

80106b27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $228
80106b29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b2e:	e9 e7 f1 ff ff       	jmp    80105d1a <alltraps>

80106b33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $229
80106b35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b3a:	e9 db f1 ff ff       	jmp    80105d1a <alltraps>

80106b3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $230
80106b41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b46:	e9 cf f1 ff ff       	jmp    80105d1a <alltraps>

80106b4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $231
80106b4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b52:	e9 c3 f1 ff ff       	jmp    80105d1a <alltraps>

80106b57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $232
80106b59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b5e:	e9 b7 f1 ff ff       	jmp    80105d1a <alltraps>

80106b63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $233
80106b65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b6a:	e9 ab f1 ff ff       	jmp    80105d1a <alltraps>

80106b6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $234
80106b71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b76:	e9 9f f1 ff ff       	jmp    80105d1a <alltraps>

80106b7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $235
80106b7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b82:	e9 93 f1 ff ff       	jmp    80105d1a <alltraps>

80106b87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $236
80106b89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b8e:	e9 87 f1 ff ff       	jmp    80105d1a <alltraps>

80106b93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $237
80106b95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b9a:	e9 7b f1 ff ff       	jmp    80105d1a <alltraps>

80106b9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $238
80106ba1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ba6:	e9 6f f1 ff ff       	jmp    80105d1a <alltraps>

80106bab <vector239>:
.globl vector239
vector239:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $239
80106bad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bb2:	e9 63 f1 ff ff       	jmp    80105d1a <alltraps>

80106bb7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $240
80106bb9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bbe:	e9 57 f1 ff ff       	jmp    80105d1a <alltraps>

80106bc3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $241
80106bc5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bca:	e9 4b f1 ff ff       	jmp    80105d1a <alltraps>

80106bcf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $242
80106bd1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106bd6:	e9 3f f1 ff ff       	jmp    80105d1a <alltraps>

80106bdb <vector243>:
.globl vector243
vector243:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $243
80106bdd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106be2:	e9 33 f1 ff ff       	jmp    80105d1a <alltraps>

80106be7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $244
80106be9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bee:	e9 27 f1 ff ff       	jmp    80105d1a <alltraps>

80106bf3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $245
80106bf5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bfa:	e9 1b f1 ff ff       	jmp    80105d1a <alltraps>

80106bff <vector246>:
.globl vector246
vector246:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $246
80106c01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c06:	e9 0f f1 ff ff       	jmp    80105d1a <alltraps>

80106c0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $247
80106c0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c12:	e9 03 f1 ff ff       	jmp    80105d1a <alltraps>

80106c17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $248
80106c19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c1e:	e9 f7 f0 ff ff       	jmp    80105d1a <alltraps>

80106c23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $249
80106c25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c2a:	e9 eb f0 ff ff       	jmp    80105d1a <alltraps>

80106c2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $250
80106c31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c36:	e9 df f0 ff ff       	jmp    80105d1a <alltraps>

80106c3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $251
80106c3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c42:	e9 d3 f0 ff ff       	jmp    80105d1a <alltraps>

80106c47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $252
80106c49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c4e:	e9 c7 f0 ff ff       	jmp    80105d1a <alltraps>

80106c53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $253
80106c55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c5a:	e9 bb f0 ff ff       	jmp    80105d1a <alltraps>

80106c5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $254
80106c61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c66:	e9 af f0 ff ff       	jmp    80105d1a <alltraps>

80106c6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $255
80106c6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c72:	e9 a3 f0 ff ff       	jmp    80105d1a <alltraps>
80106c77:	66 90                	xchg   %ax,%ax
80106c79:	66 90                	xchg   %ax,%ax
80106c7b:	66 90                	xchg   %ax,%ax
80106c7d:	66 90                	xchg   %ax,%ax
80106c7f:	90                   	nop

80106c80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106c8c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c92:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106c95:	39 d3                	cmp    %edx,%ebx
80106c97:	73 56                	jae    80106cef <deallocuvm.part.0+0x6f>
80106c99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c9c:	89 c6                	mov    %eax,%esi
80106c9e:	89 d7                	mov    %edx,%edi
80106ca0:	eb 12                	jmp    80106cb4 <deallocuvm.part.0+0x34>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ca8:	83 c2 01             	add    $0x1,%edx
80106cab:	89 d3                	mov    %edx,%ebx
80106cad:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106cb0:	39 fb                	cmp    %edi,%ebx
80106cb2:	73 38                	jae    80106cec <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106cb4:	89 da                	mov    %ebx,%edx
80106cb6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106cb9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106cbc:	a8 01                	test   $0x1,%al
80106cbe:	74 e8                	je     80106ca8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106cc0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106cc7:	c1 e9 0a             	shr    $0xa,%ecx
80106cca:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106cd0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	74 cd                	je     80106ca8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106cdb:	8b 10                	mov    (%eax),%edx
80106cdd:	f6 c2 01             	test   $0x1,%dl
80106ce0:	75 1e                	jne    80106d00 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106ce2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ce8:	39 fb                	cmp    %edi,%ebx
80106cea:	72 c8                	jb     80106cb4 <deallocuvm.part.0+0x34>
80106cec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf2:	89 c8                	mov    %ecx,%eax
80106cf4:	5b                   	pop    %ebx
80106cf5:	5e                   	pop    %esi
80106cf6:	5f                   	pop    %edi
80106cf7:	5d                   	pop    %ebp
80106cf8:	c3                   	ret
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106d00:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d06:	74 26                	je     80106d2e <deallocuvm.part.0+0xae>
      kfree(v);
80106d08:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d0b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d14:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106d1a:	52                   	push   %edx
80106d1b:	e8 60 bc ff ff       	call   80102980 <kfree>
      *pte = 0;
80106d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106d23:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106d26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106d2c:	eb 82                	jmp    80106cb0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106d2e:	83 ec 0c             	sub    $0xc,%esp
80106d31:	68 0c 78 10 80       	push   $0x8010780c
80106d36:	e8 35 96 ff ff       	call   80100370 <panic>
80106d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d40 <mappages>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106d46:	89 d3                	mov    %edx,%ebx
80106d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d4e:	83 ec 1c             	sub    $0x1c,%esp
80106d51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	29 d8                	sub    %ebx,%eax
80106d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d68:	eb 3f                	jmp    80106da9 <mappages+0x69>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d77:	c1 ea 0a             	shr    $0xa,%edx
80106d7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d87:	85 c0                	test   %eax,%eax
80106d89:	74 75                	je     80106e00 <mappages+0xc0>
    if(*pte & PTE_P)
80106d8b:	f6 00 01             	testb  $0x1,(%eax)
80106d8e:	0f 85 86 00 00 00    	jne    80106e1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106d94:	0b 75 0c             	or     0xc(%ebp),%esi
80106d97:	83 ce 01             	or     $0x1,%esi
80106d9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d9f:	39 c3                	cmp    %eax,%ebx
80106da1:	74 6d                	je     80106e10 <mappages+0xd0>
    a += PGSIZE;
80106da3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106dac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106daf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106db2:	89 d8                	mov    %ebx,%eax
80106db4:	c1 e8 16             	shr    $0x16,%eax
80106db7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106dba:	8b 07                	mov    (%edi),%eax
80106dbc:	a8 01                	test   $0x1,%al
80106dbe:	75 b0                	jne    80106d70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106dc0:	e8 7b bd ff ff       	call   80102b40 <kalloc>
80106dc5:	85 c0                	test   %eax,%eax
80106dc7:	74 37                	je     80106e00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106dc9:	83 ec 04             	sub    $0x4,%esp
80106dcc:	68 00 10 00 00       	push   $0x1000
80106dd1:	6a 00                	push   $0x0
80106dd3:	50                   	push   %eax
80106dd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106dd7:	e8 a4 dd ff ff       	call   80104b80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ddc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106ddf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106de2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106de8:	83 c8 07             	or     $0x7,%eax
80106deb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ded:	89 d8                	mov    %ebx,%eax
80106def:	c1 e8 0a             	shr    $0xa,%eax
80106df2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106df7:	01 d0                	add    %edx,%eax
80106df9:	eb 90                	jmp    80106d8b <mappages+0x4b>
80106dfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e08:	5b                   	pop    %ebx
80106e09:	5e                   	pop    %esi
80106e0a:	5f                   	pop    %edi
80106e0b:	5d                   	pop    %ebp
80106e0c:	c3                   	ret
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret
      panic("remap");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 40 7a 10 80       	push   $0x80107a40
80106e22:	e8 49 95 ff ff       	call   80100370 <panic>
80106e27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e2e:	00 
80106e2f:	90                   	nop

80106e30 <seginit>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e36:	e8 e5 cf ff ff       	call   80103e20 <cpuid>
  pd[0] = size-1;
80106e3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106e4a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106e51:	ff 00 00 
80106e54:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106e5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e5e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106e65:	ff 00 00 
80106e68:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106e6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e72:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106e79:	ff 00 00 
80106e7c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106e83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e86:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106e8d:	ff 00 00 
80106e90:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106e97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e9a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106e9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ea3:	c1 e8 10             	shr    $0x10,%eax
80106ea6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eaa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ead:	0f 01 10             	lgdtl  (%eax)
}
80106eb0:	c9                   	leave
80106eb1:	c3                   	ret
80106eb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eb9:	00 
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ec0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ec0:	a1 c4 54 11 80       	mov    0x801154c4,%eax
80106ec5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eca:	0f 22 d8             	mov    %eax,%cr3
}
80106ecd:	c3                   	ret
80106ece:	66 90                	xchg   %ax,%ax

80106ed0 <switchuvm>:
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106edc:	85 f6                	test   %esi,%esi
80106ede:	0f 84 cb 00 00 00    	je     80106faf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ee4:	8b 46 08             	mov    0x8(%esi),%eax
80106ee7:	85 c0                	test   %eax,%eax
80106ee9:	0f 84 da 00 00 00    	je     80106fc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106eef:	8b 46 04             	mov    0x4(%esi),%eax
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	0f 84 c2 00 00 00    	je     80106fbc <switchuvm+0xec>
  pushcli();
80106efa:	e8 31 da ff ff       	call   80104930 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106eff:	e8 bc ce ff ff       	call   80103dc0 <mycpu>
80106f04:	89 c3                	mov    %eax,%ebx
80106f06:	e8 b5 ce ff ff       	call   80103dc0 <mycpu>
80106f0b:	89 c7                	mov    %eax,%edi
80106f0d:	e8 ae ce ff ff       	call   80103dc0 <mycpu>
80106f12:	83 c7 08             	add    $0x8,%edi
80106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f18:	e8 a3 ce ff ff       	call   80103dc0 <mycpu>
80106f1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f20:	ba 67 00 00 00       	mov    $0x67,%edx
80106f25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f2c:	83 c0 08             	add    $0x8,%eax
80106f2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f3b:	83 c1 08             	add    $0x8,%ecx
80106f3e:	c1 e8 18             	shr    $0x18,%eax
80106f41:	c1 e9 10             	shr    $0x10,%ecx
80106f44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106f50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106f61:	e8 5a ce ff ff       	call   80103dc0 <mycpu>
80106f66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f6d:	e8 4e ce ff ff       	call   80103dc0 <mycpu>
80106f72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f76:	8b 5e 08             	mov    0x8(%esi),%ebx
80106f79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7f:	e8 3c ce ff ff       	call   80103dc0 <mycpu>
80106f84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f87:	e8 34 ce ff ff       	call   80103dc0 <mycpu>
80106f8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f90:	b8 28 00 00 00       	mov    $0x28,%eax
80106f95:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f98:	8b 46 04             	mov    0x4(%esi),%eax
80106f9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fa0:	0f 22 d8             	mov    %eax,%cr3
}
80106fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fa6:	5b                   	pop    %ebx
80106fa7:	5e                   	pop    %esi
80106fa8:	5f                   	pop    %edi
80106fa9:	5d                   	pop    %ebp
  popcli();
80106faa:	e9 d1 d9 ff ff       	jmp    80104980 <popcli>
    panic("switchuvm: no process");
80106faf:	83 ec 0c             	sub    $0xc,%esp
80106fb2:	68 46 7a 10 80       	push   $0x80107a46
80106fb7:	e8 b4 93 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	68 71 7a 10 80       	push   $0x80107a71
80106fc4:	e8 a7 93 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
80106fc9:	83 ec 0c             	sub    $0xc,%esp
80106fcc:	68 5c 7a 10 80       	push   $0x80107a5c
80106fd1:	e8 9a 93 ff ff       	call   80100370 <panic>
80106fd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fdd:	00 
80106fde:	66 90                	xchg   %ax,%ax

80106fe0 <inituvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80106fec:	8b 75 10             	mov    0x10(%ebp),%esi
80106fef:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106ff2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ff5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ffb:	77 49                	ja     80107046 <inituvm+0x66>
  mem = kalloc();
80106ffd:	e8 3e bb ff ff       	call   80102b40 <kalloc>
  memset(mem, 0, PGSIZE);
80107002:	83 ec 04             	sub    $0x4,%esp
80107005:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010700a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010700c:	6a 00                	push   $0x0
8010700e:	50                   	push   %eax
8010700f:	e8 6c db ff ff       	call   80104b80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107014:	58                   	pop    %eax
80107015:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010701b:	5a                   	pop    %edx
8010701c:	6a 06                	push   $0x6
8010701e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107023:	31 d2                	xor    %edx,%edx
80107025:	50                   	push   %eax
80107026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107029:	e8 12 fd ff ff       	call   80106d40 <mappages>
  memmove(mem, init, sz);
8010702e:	83 c4 10             	add    $0x10,%esp
80107031:	89 75 10             	mov    %esi,0x10(%ebp)
80107034:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107037:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010703a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010703d:	5b                   	pop    %ebx
8010703e:	5e                   	pop    %esi
8010703f:	5f                   	pop    %edi
80107040:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107041:	e9 ca db ff ff       	jmp    80104c10 <memmove>
    panic("inituvm: more than a page");
80107046:	83 ec 0c             	sub    $0xc,%esp
80107049:	68 85 7a 10 80       	push   $0x80107a85
8010704e:	e8 1d 93 ff ff       	call   80100370 <panic>
80107053:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010705a:	00 
8010705b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107060 <loaduvm>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107069:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010706c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010706f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107075:	0f 85 a2 00 00 00    	jne    8010711d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010707b:	85 ff                	test   %edi,%edi
8010707d:	74 7d                	je     801070fc <loaduvm+0x9c>
8010707f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107080:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107083:	8b 55 08             	mov    0x8(%ebp),%edx
80107086:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107088:	89 c1                	mov    %eax,%ecx
8010708a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010708d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107090:	f6 c1 01             	test   $0x1,%cl
80107093:	75 13                	jne    801070a8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107095:	83 ec 0c             	sub    $0xc,%esp
80107098:	68 9f 7a 10 80       	push   $0x80107a9f
8010709d:	e8 ce 92 ff ff       	call   80100370 <panic>
801070a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070a8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070ab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070b1:	25 fc 0f 00 00       	and    $0xffc,%eax
801070b6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070bd:	85 c9                	test   %ecx,%ecx
801070bf:	74 d4                	je     80107095 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801070c1:	89 fb                	mov    %edi,%ebx
801070c3:	b8 00 10 00 00       	mov    $0x1000,%eax
801070c8:	29 f3                	sub    %esi,%ebx
801070ca:	39 c3                	cmp    %eax,%ebx
801070cc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070cf:	53                   	push   %ebx
801070d0:	8b 45 14             	mov    0x14(%ebp),%eax
801070d3:	01 f0                	add    %esi,%eax
801070d5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801070d6:	8b 01                	mov    (%ecx),%eax
801070d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070dd:	05 00 00 00 80       	add    $0x80000000,%eax
801070e2:	50                   	push   %eax
801070e3:	ff 75 10             	push   0x10(%ebp)
801070e6:	e8 a5 ae ff ff       	call   80101f90 <readi>
801070eb:	83 c4 10             	add    $0x10,%esp
801070ee:	39 d8                	cmp    %ebx,%eax
801070f0:	75 1e                	jne    80107110 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801070f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070f8:	39 fe                	cmp    %edi,%esi
801070fa:	72 84                	jb     80107080 <loaduvm+0x20>
}
801070fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070ff:	31 c0                	xor    %eax,%eax
}
80107101:	5b                   	pop    %ebx
80107102:	5e                   	pop    %esi
80107103:	5f                   	pop    %edi
80107104:	5d                   	pop    %ebp
80107105:	c3                   	ret
80107106:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010710d:	00 
8010710e:	66 90                	xchg   %ax,%ax
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107118:	5b                   	pop    %ebx
80107119:	5e                   	pop    %esi
8010711a:	5f                   	pop    %edi
8010711b:	5d                   	pop    %ebp
8010711c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010711d:	83 ec 0c             	sub    $0xc,%esp
80107120:	68 18 7d 10 80       	push   $0x80107d18
80107125:	e8 46 92 ff ff       	call   80100370 <panic>
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <allocuvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
80107139:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010713c:	85 f6                	test   %esi,%esi
8010713e:	0f 88 98 00 00 00    	js     801071dc <allocuvm+0xac>
80107144:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107146:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107149:	0f 82 a1 00 00 00    	jb     801071f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010714f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107152:	05 ff 0f 00 00       	add    $0xfff,%eax
80107157:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010715c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010715e:	39 f0                	cmp    %esi,%eax
80107160:	0f 83 8d 00 00 00    	jae    801071f3 <allocuvm+0xc3>
80107166:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107169:	eb 44                	jmp    801071af <allocuvm+0x7f>
8010716b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107170:	83 ec 04             	sub    $0x4,%esp
80107173:	68 00 10 00 00       	push   $0x1000
80107178:	6a 00                	push   $0x0
8010717a:	50                   	push   %eax
8010717b:	e8 00 da ff ff       	call   80104b80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107180:	58                   	pop    %eax
80107181:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107187:	5a                   	pop    %edx
80107188:	6a 06                	push   $0x6
8010718a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010718f:	89 fa                	mov    %edi,%edx
80107191:	50                   	push   %eax
80107192:	8b 45 08             	mov    0x8(%ebp),%eax
80107195:	e8 a6 fb ff ff       	call   80106d40 <mappages>
8010719a:	83 c4 10             	add    $0x10,%esp
8010719d:	85 c0                	test   %eax,%eax
8010719f:	78 5f                	js     80107200 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801071a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071a7:	39 f7                	cmp    %esi,%edi
801071a9:	0f 83 89 00 00 00    	jae    80107238 <allocuvm+0x108>
    mem = kalloc();
801071af:	e8 8c b9 ff ff       	call   80102b40 <kalloc>
801071b4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801071b6:	85 c0                	test   %eax,%eax
801071b8:	75 b6                	jne    80107170 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071ba:	83 ec 0c             	sub    $0xc,%esp
801071bd:	68 bd 7a 10 80       	push   $0x80107abd
801071c2:	e8 89 95 ff ff       	call   80100750 <cprintf>
  if(newsz >= oldsz)
801071c7:	83 c4 10             	add    $0x10,%esp
801071ca:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071cd:	74 0d                	je     801071dc <allocuvm+0xac>
801071cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071d2:	8b 45 08             	mov    0x8(%ebp),%eax
801071d5:	89 f2                	mov    %esi,%edx
801071d7:	e8 a4 fa ff ff       	call   80106c80 <deallocuvm.part.0>
    return 0;
801071dc:	31 d2                	xor    %edx,%edx
}
801071de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e1:	89 d0                	mov    %edx,%eax
801071e3:	5b                   	pop    %ebx
801071e4:	5e                   	pop    %esi
801071e5:	5f                   	pop    %edi
801071e6:	5d                   	pop    %ebp
801071e7:	c3                   	ret
801071e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ef:	00 
    return oldsz;
801071f0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801071f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f6:	89 d0                	mov    %edx,%eax
801071f8:	5b                   	pop    %ebx
801071f9:	5e                   	pop    %esi
801071fa:	5f                   	pop    %edi
801071fb:	5d                   	pop    %ebp
801071fc:	c3                   	ret
801071fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	68 d5 7a 10 80       	push   $0x80107ad5
80107208:	e8 43 95 ff ff       	call   80100750 <cprintf>
  if(newsz >= oldsz)
8010720d:	83 c4 10             	add    $0x10,%esp
80107210:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107213:	74 0d                	je     80107222 <allocuvm+0xf2>
80107215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107218:	8b 45 08             	mov    0x8(%ebp),%eax
8010721b:	89 f2                	mov    %esi,%edx
8010721d:	e8 5e fa ff ff       	call   80106c80 <deallocuvm.part.0>
      kfree(mem);
80107222:	83 ec 0c             	sub    $0xc,%esp
80107225:	53                   	push   %ebx
80107226:	e8 55 b7 ff ff       	call   80102980 <kfree>
      return 0;
8010722b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010722e:	31 d2                	xor    %edx,%edx
80107230:	eb ac                	jmp    801071de <allocuvm+0xae>
80107232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010723b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723e:	5b                   	pop    %ebx
8010723f:	5e                   	pop    %esi
80107240:	89 d0                	mov    %edx,%eax
80107242:	5f                   	pop    %edi
80107243:	5d                   	pop    %ebp
80107244:	c3                   	ret
80107245:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010724c:	00 
8010724d:	8d 76 00             	lea    0x0(%esi),%esi

80107250 <deallocuvm>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	8b 55 0c             	mov    0xc(%ebp),%edx
80107256:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107259:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010725c:	39 d1                	cmp    %edx,%ecx
8010725e:	73 10                	jae    80107270 <deallocuvm+0x20>
}
80107260:	5d                   	pop    %ebp
80107261:	e9 1a fa ff ff       	jmp    80106c80 <deallocuvm.part.0>
80107266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010726d:	00 
8010726e:	66 90                	xchg   %ax,%ax
80107270:	89 d0                	mov    %edx,%eax
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret
80107274:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727b:	00 
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107280 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010728c:	85 f6                	test   %esi,%esi
8010728e:	74 59                	je     801072e9 <freevm+0x69>
  if(newsz >= oldsz)
80107290:	31 c9                	xor    %ecx,%ecx
80107292:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107297:	89 f0                	mov    %esi,%eax
80107299:	89 f3                	mov    %esi,%ebx
8010729b:	e8 e0 f9 ff ff       	call   80106c80 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072a6:	eb 0f                	jmp    801072b7 <freevm+0x37>
801072a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072af:	00 
801072b0:	83 c3 04             	add    $0x4,%ebx
801072b3:	39 fb                	cmp    %edi,%ebx
801072b5:	74 23                	je     801072da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072b7:	8b 03                	mov    (%ebx),%eax
801072b9:	a8 01                	test   $0x1,%al
801072bb:	74 f3                	je     801072b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072c2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072cd:	50                   	push   %eax
801072ce:	e8 ad b6 ff ff       	call   80102980 <kfree>
801072d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072d6:	39 fb                	cmp    %edi,%ebx
801072d8:	75 dd                	jne    801072b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e0:	5b                   	pop    %ebx
801072e1:	5e                   	pop    %esi
801072e2:	5f                   	pop    %edi
801072e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801072e4:	e9 97 b6 ff ff       	jmp    80102980 <kfree>
    panic("freevm: no pgdir");
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	68 f1 7a 10 80       	push   $0x80107af1
801072f1:	e8 7a 90 ff ff       	call   80100370 <panic>
801072f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072fd:	00 
801072fe:	66 90                	xchg   %ax,%ax

80107300 <setupkvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	56                   	push   %esi
80107304:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107305:	e8 36 b8 ff ff       	call   80102b40 <kalloc>
8010730a:	85 c0                	test   %eax,%eax
8010730c:	74 5e                	je     8010736c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010730e:	83 ec 04             	sub    $0x4,%esp
80107311:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107313:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107318:	68 00 10 00 00       	push   $0x1000
8010731d:	6a 00                	push   $0x0
8010731f:	50                   	push   %eax
80107320:	e8 5b d8 ff ff       	call   80104b80 <memset>
80107325:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107328:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010732b:	83 ec 08             	sub    $0x8,%esp
8010732e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107331:	8b 13                	mov    (%ebx),%edx
80107333:	ff 73 0c             	push   0xc(%ebx)
80107336:	50                   	push   %eax
80107337:	29 c1                	sub    %eax,%ecx
80107339:	89 f0                	mov    %esi,%eax
8010733b:	e8 00 fa ff ff       	call   80106d40 <mappages>
80107340:	83 c4 10             	add    $0x10,%esp
80107343:	85 c0                	test   %eax,%eax
80107345:	78 19                	js     80107360 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107347:	83 c3 10             	add    $0x10,%ebx
8010734a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107350:	75 d6                	jne    80107328 <setupkvm+0x28>
}
80107352:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107355:	89 f0                	mov    %esi,%eax
80107357:	5b                   	pop    %ebx
80107358:	5e                   	pop    %esi
80107359:	5d                   	pop    %ebp
8010735a:	c3                   	ret
8010735b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	56                   	push   %esi
80107364:	e8 17 ff ff ff       	call   80107280 <freevm>
      return 0;
80107369:	83 c4 10             	add    $0x10,%esp
}
8010736c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010736f:	31 f6                	xor    %esi,%esi
}
80107371:	89 f0                	mov    %esi,%eax
80107373:	5b                   	pop    %ebx
80107374:	5e                   	pop    %esi
80107375:	5d                   	pop    %ebp
80107376:	c3                   	ret
80107377:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010737e:	00 
8010737f:	90                   	nop

80107380 <kvmalloc>:
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107386:	e8 75 ff ff ff       	call   80107300 <setupkvm>
8010738b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107390:	05 00 00 00 80       	add    $0x80000000,%eax
80107395:	0f 22 d8             	mov    %eax,%cr3
}
80107398:	c9                   	leave
80107399:	c3                   	ret
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	83 ec 08             	sub    $0x8,%esp
801073a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073a9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073ac:	89 c1                	mov    %eax,%ecx
801073ae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073b1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073b4:	f6 c2 01             	test   $0x1,%dl
801073b7:	75 17                	jne    801073d0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	68 02 7b 10 80       	push   $0x80107b02
801073c1:	e8 aa 8f ff ff       	call   80100370 <panic>
801073c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073cd:	00 
801073ce:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801073d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801073d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801073de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801073e5:	85 c0                	test   %eax,%eax
801073e7:	74 d0                	je     801073b9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801073e9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073ec:	c9                   	leave
801073ed:	c3                   	ret
801073ee:	66 90                	xchg   %ax,%ax

801073f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073f9:	e8 02 ff ff ff       	call   80107300 <setupkvm>
801073fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107401:	85 c0                	test   %eax,%eax
80107403:	0f 84 e9 00 00 00    	je     801074f2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010740c:	85 c9                	test   %ecx,%ecx
8010740e:	0f 84 b2 00 00 00    	je     801074c6 <copyuvm+0xd6>
80107414:	31 f6                	xor    %esi,%esi
80107416:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010741d:	00 
8010741e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107420:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107423:	89 f0                	mov    %esi,%eax
80107425:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107428:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010742b:	a8 01                	test   $0x1,%al
8010742d:	75 11                	jne    80107440 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010742f:	83 ec 0c             	sub    $0xc,%esp
80107432:	68 0c 7b 10 80       	push   $0x80107b0c
80107437:	e8 34 8f ff ff       	call   80100370 <panic>
8010743c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107440:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107447:	c1 ea 0a             	shr    $0xa,%edx
8010744a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107450:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107457:	85 c0                	test   %eax,%eax
80107459:	74 d4                	je     8010742f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010745b:	8b 00                	mov    (%eax),%eax
8010745d:	a8 01                	test   $0x1,%al
8010745f:	0f 84 9f 00 00 00    	je     80107504 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107465:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107467:	25 ff 0f 00 00       	and    $0xfff,%eax
8010746c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010746f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107475:	e8 c6 b6 ff ff       	call   80102b40 <kalloc>
8010747a:	89 c3                	mov    %eax,%ebx
8010747c:	85 c0                	test   %eax,%eax
8010747e:	74 64                	je     801074e4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107480:	83 ec 04             	sub    $0x4,%esp
80107483:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107489:	68 00 10 00 00       	push   $0x1000
8010748e:	57                   	push   %edi
8010748f:	50                   	push   %eax
80107490:	e8 7b d7 ff ff       	call   80104c10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107495:	58                   	pop    %eax
80107496:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010749c:	5a                   	pop    %edx
8010749d:	ff 75 e4             	push   -0x1c(%ebp)
801074a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074a5:	89 f2                	mov    %esi,%edx
801074a7:	50                   	push   %eax
801074a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074ab:	e8 90 f8 ff ff       	call   80106d40 <mappages>
801074b0:	83 c4 10             	add    $0x10,%esp
801074b3:	85 c0                	test   %eax,%eax
801074b5:	78 21                	js     801074d8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801074b7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074bd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801074c0:	0f 82 5a ff ff ff    	jb     80107420 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801074c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074cc:	5b                   	pop    %ebx
801074cd:	5e                   	pop    %esi
801074ce:	5f                   	pop    %edi
801074cf:	5d                   	pop    %ebp
801074d0:	c3                   	ret
801074d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074d8:	83 ec 0c             	sub    $0xc,%esp
801074db:	53                   	push   %ebx
801074dc:	e8 9f b4 ff ff       	call   80102980 <kfree>
      goto bad;
801074e1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801074e4:	83 ec 0c             	sub    $0xc,%esp
801074e7:	ff 75 e0             	push   -0x20(%ebp)
801074ea:	e8 91 fd ff ff       	call   80107280 <freevm>
  return 0;
801074ef:	83 c4 10             	add    $0x10,%esp
    return 0;
801074f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ff:	5b                   	pop    %ebx
80107500:	5e                   	pop    %esi
80107501:	5f                   	pop    %edi
80107502:	5d                   	pop    %ebp
80107503:	c3                   	ret
      panic("copyuvm: page not present");
80107504:	83 ec 0c             	sub    $0xc,%esp
80107507:	68 26 7b 10 80       	push   $0x80107b26
8010750c:	e8 5f 8e ff ff       	call   80100370 <panic>
80107511:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107518:	00 
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107520 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107526:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107529:	89 c1                	mov    %eax,%ecx
8010752b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010752e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107531:	f6 c2 01             	test   $0x1,%dl
80107534:	0f 84 f8 00 00 00    	je     80107632 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010753a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010753d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107543:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107544:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107549:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107550:	89 d0                	mov    %edx,%eax
80107552:	f7 d2                	not    %edx
80107554:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107559:	05 00 00 00 80       	add    $0x80000000,%eax
8010755e:	83 e2 05             	and    $0x5,%edx
80107561:	ba 00 00 00 00       	mov    $0x0,%edx
80107566:	0f 45 c2             	cmovne %edx,%eax
}
80107569:	c3                   	ret
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 0c             	sub    $0xc,%esp
80107579:	8b 75 14             	mov    0x14(%ebp),%esi
8010757c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010757f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107582:	85 f6                	test   %esi,%esi
80107584:	75 51                	jne    801075d7 <copyout+0x67>
80107586:	e9 9d 00 00 00       	jmp    80107628 <copyout+0xb8>
8010758b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107590:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107596:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010759c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801075a2:	74 74                	je     80107618 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801075a4:	89 fb                	mov    %edi,%ebx
801075a6:	29 c3                	sub    %eax,%ebx
801075a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801075ae:	39 f3                	cmp    %esi,%ebx
801075b0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075b3:	29 f8                	sub    %edi,%eax
801075b5:	83 ec 04             	sub    $0x4,%esp
801075b8:	01 c1                	add    %eax,%ecx
801075ba:	53                   	push   %ebx
801075bb:	52                   	push   %edx
801075bc:	89 55 10             	mov    %edx,0x10(%ebp)
801075bf:	51                   	push   %ecx
801075c0:	e8 4b d6 ff ff       	call   80104c10 <memmove>
    len -= n;
    buf += n;
801075c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801075c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801075ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801075d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801075d3:	29 de                	sub    %ebx,%esi
801075d5:	74 51                	je     80107628 <copyout+0xb8>
  if(*pde & PTE_P){
801075d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801075da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801075de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801075e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801075e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801075ea:	f6 c1 01             	test   $0x1,%cl
801075ed:	0f 84 46 00 00 00    	je     80107639 <copyout.cold>
  return &pgtab[PTX(va)];
801075f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801075fb:	c1 eb 0c             	shr    $0xc,%ebx
801075fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107604:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010760b:	89 d9                	mov    %ebx,%ecx
8010760d:	f7 d1                	not    %ecx
8010760f:	83 e1 05             	and    $0x5,%ecx
80107612:	0f 84 78 ff ff ff    	je     80107590 <copyout+0x20>
  }
  return 0;
}
80107618:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010761b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107620:	5b                   	pop    %ebx
80107621:	5e                   	pop    %esi
80107622:	5f                   	pop    %edi
80107623:	5d                   	pop    %ebp
80107624:	c3                   	ret
80107625:	8d 76 00             	lea    0x0(%esi),%esi
80107628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010762b:	31 c0                	xor    %eax,%eax
}
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret

80107632 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107632:	a1 00 00 00 00       	mov    0x0,%eax
80107637:	0f 0b                	ud2

80107639 <copyout.cold>:
80107639:	a1 00 00 00 00       	mov    0x0,%eax
8010763e:	0f 0b                	ud2
