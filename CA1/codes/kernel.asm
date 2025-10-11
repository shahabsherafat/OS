
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
80100028:	bc 50 67 11 80       	mov    $0x80116750,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 3b 10 80       	mov    $0x80103b00,%eax
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
8010004c:	68 40 7c 10 80       	push   $0x80107c40
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 4e 00 00       	call   80104e80 <initlock>
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
80100092:	68 47 7c 10 80       	push   $0x80107c47
80100097:	50                   	push   %eax
80100098:	e8 b3 4c 00 00       	call   80104d50 <initsleeplock>
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
801000e4:	e8 87 4f 00 00       	call   80105070 <acquire>
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
80100162:	e8 a9 4e 00 00       	call   80105010 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 4c 00 00       	call   80104d90 <acquiresleep>
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
8010018c:	e8 0f 2c 00 00       	call   80102da0 <iderw>
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
801001a1:	68 4e 7c 10 80       	push   $0x80107c4e
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
801001be:	e8 6d 4c 00 00       	call   80104e30 <holdingsleep>
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
801001d4:	e9 c7 2b 00 00       	jmp    80102da0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 7c 10 80       	push   $0x80107c5f
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
801001ff:	e8 2c 4c 00 00       	call   80104e30 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 4b 00 00       	call   80104df0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 4e 00 00       	call   80105070 <acquire>
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
80100269:	e9 a2 4d 00 00       	jmp    80105010 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 7c 10 80       	push   $0x80107c66
80100276:	e8 f5 00 00 00       	call   80100370 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
    procdump();
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
80100290:	e8 bb 20 00 00       	call   80102350 <iunlock>
  target = n;
  acquire(&cons.lock);
80100295:	c7 04 24 a0 01 11 80 	movl   $0x801101a0,(%esp)
8010029c:	e8 cf 4d 00 00       	call   80105070 <acquire>
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
801002c3:	68 a0 01 11 80       	push   $0x801101a0
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 48 00 00       	call   80104af0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 49 41 00 00       	call   80104430 <myproc>
801002e7:	8b 40 24             	mov    0x24(%eax),%eax
801002ea:	85 c0                	test   %eax,%eax
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 a0 01 11 80       	push   $0x801101a0
801002f6:	e8 15 4d 00 00       	call   80105010 <release>
        ilock(ip);
801002fb:	89 3c 24             	mov    %edi,(%esp)
801002fe:	e8 6d 1f 00 00       	call   80102270 <ilock>
        return -1;
80100303:	83 c4 10             	add    $0x10,%esp
      break;
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
8010033f:	68 a0 01 11 80       	push   $0x801101a0
80100344:	e8 c7 4c 00 00       	call   80105010 <release>
  ilock(ip);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 1f 1f 00 00       	call   80102270 <ilock>
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
80100379:	c7 05 d4 01 11 80 00 	movl   $0x0,0x801101d4
80100380:	00 00 00 
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 12 30 00 00       	call   801033a0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 7c 10 80       	push   $0x80107c6d
80100397:	e8 14 05 00 00       	call   801008b0 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	push   0x8(%ebp)
801003a0:	e8 0b 05 00 00       	call   801008b0 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 ef 80 10 80 	movl   $0x801080ef,(%esp)
801003ac:	e8 ff 04 00 00       	call   801008b0 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	8d 45 08             	lea    0x8(%ebp),%eax
801003b4:	5a                   	pop    %edx
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 e3 4a 00 00       	call   80104ea0 <getcallerpcs>
  for(i=0; i<10; i++)
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003c8:	68 81 7c 10 80       	push   $0x80107c81
801003cd:	e8 de 04 00 00       	call   801008b0 <cprintf>
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
  panicked = 1;
801003d9:	c7 05 d8 01 11 80 01 	movl   $0x1,0x801101d8
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
80100425:	e8 56 63 00 00       	call   80106780 <uartputc>
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
801004c9:	e8 b2 62 00 00       	call   80106780 <uartputc>
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
8010050e:	68 85 7c 10 80       	push   $0x80107c85
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
8010053a:	e8 c1 4c 00 00       	call   80105200 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010053f:	b8 80 07 00 00       	mov    $0x780,%eax
80100544:	83 c4 0c             	add    $0xc,%esp
80100547:	29 d8                	sub    %ebx,%eax
80100549:	01 c0                	add    %eax,%eax
8010054b:	50                   	push   %eax
8010054c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100553:	6a 00                	push   $0x0
80100555:	50                   	push   %eax
80100556:	e8 15 4c 00 00       	call   80105170 <memset>
  outb(CRTPORT+1, pos);
8010055b:	83 c4 10             	add    $0x10,%esp
8010055e:	e9 27 ff ff ff       	jmp    8010048a <consputc.part.0+0x9a>
80100563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100568:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100570:	6a 08                	push   $0x8
80100572:	e8 09 62 00 00       	call   80106780 <uartputc>
80100577:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010057e:	e8 fd 61 00 00       	call   80106780 <uartputc>
80100583:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010058a:	e8 f1 61 00 00       	call   80106780 <uartputc>
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
    crt[pos++] = (c & 0xff) | cg_attr;
801005e0:	89 f1                	mov    %esi,%ecx
801005e2:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos]   = ' ' | 0x0700;
801005e5:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c & 0xff) | cg_attr;
801005ea:	01 c0                	add    %eax,%eax
801005ec:	0f b6 f1             	movzbl %cl,%esi
801005ef:	66 0b 35 00 90 10 80 	or     0x80109000,%si
    crt[pos]   = ' ' | 0x0700;
801005f6:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c & 0xff) | cg_attr;
801005fd:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos]   = ' ' | 0x0700;
80100604:	e9 66 fe ff ff       	jmp    8010046f <consputc.part.0+0x7f>
80100609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80100610:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100613:	be d4 03 00 00       	mov    $0x3d4,%esi
80100618:	6a 08                	push   $0x8
8010061a:	e8 61 61 00 00       	call   80106780 <uartputc>
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
8010066f:	e8 dc 1c 00 00       	call   80102350 <iunlock>
  acquire(&cons.lock);
80100674:	c7 04 24 a0 01 11 80 	movl   $0x801101a0,(%esp)
8010067b:	e8 f0 49 00 00       	call   80105070 <acquire>
  for(i = 0; i < n; i++)
80100680:	83 c4 10             	add    $0x10,%esp
80100683:	85 f6                	test   %esi,%esi
80100685:	7e 27                	jle    801006ae <consolewrite+0x4e>
80100687:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010068a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010068d:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
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
801006b1:	68 a0 01 11 80       	push   $0x801101a0
801006b6:	e8 55 49 00 00       	call   80105010 <release>
  ilock(ip);
801006bb:	58                   	pop    %eax
801006bc:	ff 75 08             	push   0x8(%ebp)
801006bf:	e8 ac 1b 00 00       	call   80102270 <ilock>
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

801006d0 <redraw_edit_with_selection>:
static void redraw_edit_with_selection(void) {
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	31 ff                	xor    %edi,%edi
801006d6:	56                   	push   %esi
801006d7:	53                   	push   %ebx
  if (off_from_start < 0) off_from_start = 0;
801006d8:	31 db                	xor    %ebx,%ebx
static void redraw_edit_with_selection(void) {
801006da:	83 ec 1c             	sub    $0x1c,%esp
  int len   = (int)input.real_end - (int)input.w;
801006dd:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
801006e2:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
801006e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int off_from_start = old_e - (int)input.w;
801006eb:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801006f0:	29 f0                	sub    %esi,%eax
  if (off_from_start < 0) off_from_start = 0;
801006f2:	85 c0                	test   %eax,%eax
801006f4:	0f 49 d8             	cmovns %eax,%ebx
  for (int i = 0; i < off_from_start; i++)
801006f7:	7e 2a                	jle    80100723 <redraw_edit_with_selection+0x53>
  if(panicked){
801006f9:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
801006ff:	85 c9                	test   %ecx,%ecx
80100701:	74 0d                	je     80100710 <redraw_edit_with_selection+0x40>
80100703:	fa                   	cli
    for(;;)
80100704:	eb fe                	jmp    80100704 <redraw_edit_with_selection+0x34>
80100706:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010070d:	00 
8010070e:	66 90                	xchg   %ax,%ax
80100710:	31 d2                	xor    %edx,%edx
80100712:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < off_from_start; i++)
80100717:	83 c7 01             	add    $0x1,%edi
8010071a:	e8 d1 fc ff ff       	call   801003f0 <consputc.part.0>
8010071f:	39 fb                	cmp    %edi,%ebx
80100721:	7f d6                	jg     801006f9 <redraw_edit_with_selection+0x29>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b) {
80100723:	8b 0d 14 01 11 80    	mov    0x80110114,%ecx
80100729:	85 c9                	test   %ecx,%ecx
8010072b:	78 1f                	js     8010074c <redraw_edit_with_selection+0x7c>
8010072d:	8b 15 18 01 11 80    	mov    0x80110118,%edx
80100733:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100736:	85 d2                	test   %edx,%edx
80100738:	78 12                	js     8010074c <redraw_edit_with_selection+0x7c>
8010073a:	39 d1                	cmp    %edx,%ecx
8010073c:	74 0e                	je     8010074c <redraw_edit_with_selection+0x7c>
    sel = 1;
8010073e:	b8 01 00 00 00       	mov    $0x1,%eax
    if (lo > hi) { int t = lo; lo = hi; hi = t; }
80100743:	7f 15                	jg     8010075a <redraw_edit_with_selection+0x8a>
    lo = input.sel_a; hi = input.sel_b;
80100745:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100748:	89 d1                	mov    %edx,%ecx
8010074a:	eb 0e                	jmp    8010075a <redraw_edit_with_selection+0x8a>
  int lo = -1, hi = -1;
8010074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  int sel = 0;
80100753:	31 c0                	xor    %eax,%eax
  int lo = -1, hi = -1;
80100755:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  int len   = (int)input.real_end - (int)input.w;
8010075a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (len < 0) len = 0;
8010075d:	31 d2                	xor    %edx,%edx
  int len   = (int)input.real_end - (int)input.w;
8010075f:	29 f7                	sub    %esi,%edi
  if (len < 0) len = 0;
80100761:	85 ff                	test   %edi,%edi
80100763:	0f 49 d7             	cmovns %edi,%edx
80100766:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for (int i = 0; i < len; i++) {
80100769:	7e 7e                	jle    801007e9 <redraw_edit_with_selection+0x119>
    int in_sel = sel && idx >= lo && idx < hi;
8010076b:	83 e0 01             	and    $0x1,%eax
    ushort prev = cg_attr;
8010076e:	0f b7 3d 00 90 10 80 	movzwl 0x80109000,%edi
  for (int i = 0; i < len; i++) {
80100775:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80100778:	31 f6                	xor    %esi,%esi
    int in_sel = sel && idx >= lo && idx < hi;
8010077a:	88 45 df             	mov    %al,-0x21(%ebp)
  for (int i = 0; i < len; i++) {
8010077d:	89 cb                	mov    %ecx,%ebx
    int idx = (int)input.w + i;
8010077f:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80100784:	01 f0                	add    %esi,%eax
    int in_sel = sel && idx >= lo && idx < hi;
80100786:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80100789:	0f 9e c1             	setle  %cl
8010078c:	39 c3                	cmp    %eax,%ebx
8010078e:	0f 9f c2             	setg   %dl
80100791:	84 d1                	test   %dl,%cl
80100793:	74 0b                	je     801007a0 <redraw_edit_with_selection+0xd0>
80100795:	80 7d df 00          	cmpb   $0x0,-0x21(%ebp)
    cg_attr = in_sel ? 0x7000 : 0x0700;
80100799:	ba 00 70 00 00       	mov    $0x7000,%edx
    int in_sel = sel && idx >= lo && idx < hi;
8010079e:	75 05                	jne    801007a5 <redraw_edit_with_selection+0xd5>
    cg_attr = in_sel ? 0x7000 : 0x0700;
801007a0:	ba 00 07 00 00       	mov    $0x700,%edx
801007a5:	66 89 15 00 90 10 80 	mov    %dx,0x80109000
    consputc(input.buf[idx % INPUT_BUF], 0);
801007ac:	99                   	cltd
801007ad:	c1 ea 19             	shr    $0x19,%edx
801007b0:	01 d0                	add    %edx,%eax
801007b2:	83 e0 7f             	and    $0x7f,%eax
801007b5:	29 d0                	sub    %edx,%eax
  if(panicked){
801007b7:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(input.buf[idx % INPUT_BUF], 0);
801007bd:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801007c4:	85 d2                	test   %edx,%edx
801007c6:	74 08                	je     801007d0 <redraw_edit_with_selection+0x100>
801007c8:	fa                   	cli
    for(;;)
801007c9:	eb fe                	jmp    801007c9 <redraw_edit_with_selection+0xf9>
801007cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801007d0:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < len; i++) {
801007d2:	83 c6 01             	add    $0x1,%esi
801007d5:	e8 16 fc ff ff       	call   801003f0 <consputc.part.0>
    cg_attr = prev;
801007da:	66 89 3d 00 90 10 80 	mov    %di,0x80109000
  for (int i = 0; i < len; i++) {
801007e1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801007e4:	7f 99                	jg     8010077f <redraw_edit_with_selection+0xaf>
801007e6:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  int back = len - off_from_start;
801007e9:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007ec:	29 de                	sub    %ebx,%esi
  for (int i = 0; i < back; i++)
801007ee:	31 db                	xor    %ebx,%ebx
801007f0:	85 f6                	test   %esi,%esi
801007f2:	7e 1f                	jle    80100813 <redraw_edit_with_selection+0x143>
  if(panicked){
801007f4:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801007f9:	85 c0                	test   %eax,%eax
801007fb:	74 03                	je     80100800 <redraw_edit_with_selection+0x130>
801007fd:	fa                   	cli
    for(;;)
801007fe:	eb fe                	jmp    801007fe <redraw_edit_with_selection+0x12e>
80100800:	31 d2                	xor    %edx,%edx
80100802:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < back; i++)
80100807:	83 c3 01             	add    $0x1,%ebx
8010080a:	e8 e1 fb ff ff       	call   801003f0 <consputc.part.0>
8010080f:	39 de                	cmp    %ebx,%esi
80100811:	75 e1                	jne    801007f4 <redraw_edit_with_selection+0x124>
}
80100813:	83 c4 1c             	add    $0x1c,%esp
80100816:	5b                   	pop    %ebx
80100817:	5e                   	pop    %esi
80100818:	5f                   	pop    %edi
80100819:	5d                   	pop    %ebp
8010081a:	c3                   	ret
8010081b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100820 <printint>:
{
80100820:	55                   	push   %ebp
80100821:	89 e5                	mov    %esp,%ebp
80100823:	57                   	push   %edi
80100824:	56                   	push   %esi
80100825:	53                   	push   %ebx
80100826:	89 d3                	mov    %edx,%ebx
80100828:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010082b:	85 c0                	test   %eax,%eax
8010082d:	79 05                	jns    80100834 <printint+0x14>
8010082f:	83 e1 01             	and    $0x1,%ecx
80100832:	75 66                	jne    8010089a <printint+0x7a>
    x = xx;
80100834:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010083b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010083d:	31 f6                	xor    %esi,%esi
8010083f:	90                   	nop
    buf[i++] = digits[x % base];
80100840:	89 c8                	mov    %ecx,%eax
80100842:	31 d2                	xor    %edx,%edx
80100844:	89 f7                	mov    %esi,%edi
80100846:	f7 f3                	div    %ebx
80100848:	8d 76 01             	lea    0x1(%esi),%esi
8010084b:	0f b6 92 ac 81 10 80 	movzbl -0x7fef7e54(%edx),%edx
80100852:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100856:	89 ca                	mov    %ecx,%edx
80100858:	89 c1                	mov    %eax,%ecx
8010085a:	39 da                	cmp    %ebx,%edx
8010085c:	73 e2                	jae    80100840 <printint+0x20>
  if(sign)
8010085e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100861:	85 c9                	test   %ecx,%ecx
80100863:	74 07                	je     8010086c <printint+0x4c>
    buf[i++] = '-';
80100865:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010086a:	89 f7                	mov    %esi,%edi
8010086c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010086f:	01 df                	add    %ebx,%edi
  if(panicked){
80100871:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(buf[i], 0);
80100877:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010087a:	85 d2                	test   %edx,%edx
8010087c:	74 0a                	je     80100888 <printint+0x68>
8010087e:	fa                   	cli
    for(;;)
8010087f:	eb fe                	jmp    8010087f <printint+0x5f>
80100881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100888:	31 d2                	xor    %edx,%edx
8010088a:	e8 61 fb ff ff       	call   801003f0 <consputc.part.0>
  while(--i >= 0)
8010088f:	8d 47 ff             	lea    -0x1(%edi),%eax
80100892:	39 df                	cmp    %ebx,%edi
80100894:	74 11                	je     801008a7 <printint+0x87>
80100896:	89 c7                	mov    %eax,%edi
80100898:	eb d7                	jmp    80100871 <printint+0x51>
    x = -xx;
8010089a:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010089c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801008a3:	89 c1                	mov    %eax,%ecx
801008a5:	eb 96                	jmp    8010083d <printint+0x1d>
}
801008a7:	83 c4 2c             	add    $0x2c,%esp
801008aa:	5b                   	pop    %ebx
801008ab:	5e                   	pop    %esi
801008ac:	5f                   	pop    %edi
801008ad:	5d                   	pop    %ebp
801008ae:	c3                   	ret
801008af:	90                   	nop

801008b0 <cprintf>:
{
801008b0:	55                   	push   %ebp
801008b1:	89 e5                	mov    %esp,%ebp
801008b3:	57                   	push   %edi
801008b4:	56                   	push   %esi
801008b5:	53                   	push   %ebx
801008b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801008b9:	8b 3d d4 01 11 80    	mov    0x801101d4,%edi
  if (fmt == 0)
801008bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801008c2:	85 ff                	test   %edi,%edi
801008c4:	0f 85 06 01 00 00    	jne    801009d0 <cprintf+0x120>
  if (fmt == 0)
801008ca:	85 f6                	test   %esi,%esi
801008cc:	0f 84 e0 01 00 00    	je     80100ab2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008d2:	0f b6 06             	movzbl (%esi),%eax
801008d5:	85 c0                	test   %eax,%eax
801008d7:	74 59                	je     80100932 <cprintf+0x82>
801008d9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint*)(void*)(&fmt + 1);
801008dc:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008df:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
801008e1:	83 f8 25             	cmp    $0x25,%eax
801008e4:	75 5a                	jne    80100940 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801008e6:	83 c3 01             	add    $0x1,%ebx
801008e9:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if(c == 0)
801008ed:	85 ff                	test   %edi,%edi
801008ef:	74 36                	je     80100927 <cprintf+0x77>
    switch(c){
801008f1:	83 ff 70             	cmp    $0x70,%edi
801008f4:	0f 84 b6 00 00 00    	je     801009b0 <cprintf+0x100>
801008fa:	7f 74                	jg     80100970 <cprintf+0xc0>
801008fc:	83 ff 25             	cmp    $0x25,%edi
801008ff:	74 5e                	je     8010095f <cprintf+0xaf>
80100901:	83 ff 64             	cmp    $0x64,%edi
80100904:	75 78                	jne    8010097e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100906:	8b 01                	mov    (%ecx),%eax
80100908:	8d 79 04             	lea    0x4(%ecx),%edi
8010090b:	ba 0a 00 00 00       	mov    $0xa,%edx
80100910:	b9 01 00 00 00       	mov    $0x1,%ecx
80100915:	e8 06 ff ff ff       	call   80100820 <printint>
8010091a:	89 f9                	mov    %edi,%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010091c:	83 c3 01             	add    $0x1,%ebx
8010091f:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100923:	85 c0                	test   %eax,%eax
80100925:	75 ba                	jne    801008e1 <cprintf+0x31>
80100927:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
8010092a:	85 ff                	test   %edi,%edi
8010092c:	0f 85 c1 00 00 00    	jne    801009f3 <cprintf+0x143>
}
80100932:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100935:	5b                   	pop    %ebx
80100936:	5e                   	pop    %esi
80100937:	5f                   	pop    %edi
80100938:	5d                   	pop    %ebp
80100939:	c3                   	ret
8010093a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(panicked){
80100940:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80100946:	85 ff                	test   %edi,%edi
80100948:	74 06                	je     80100950 <cprintf+0xa0>
8010094a:	fa                   	cli
    for(;;)
8010094b:	eb fe                	jmp    8010094b <cprintf+0x9b>
8010094d:	8d 76 00             	lea    0x0(%esi),%esi
80100950:	31 d2                	xor    %edx,%edx
80100952:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100955:	e8 96 fa ff ff       	call   801003f0 <consputc.part.0>
      continue;
8010095a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010095d:	eb bd                	jmp    8010091c <cprintf+0x6c>
  if(panicked){
8010095f:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80100965:	85 ff                	test   %edi,%edi
80100967:	0f 84 13 01 00 00    	je     80100a80 <cprintf+0x1d0>
8010096d:	fa                   	cli
    for(;;)
8010096e:	eb fe                	jmp    8010096e <cprintf+0xbe>
    switch(c){
80100970:	83 ff 73             	cmp    $0x73,%edi
80100973:	0f 84 8f 00 00 00    	je     80100a08 <cprintf+0x158>
80100979:	83 ff 78             	cmp    $0x78,%edi
8010097c:	74 32                	je     801009b0 <cprintf+0x100>
  if(panicked){
8010097e:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100984:	85 d2                	test   %edx,%edx
80100986:	0f 85 e8 00 00 00    	jne    80100a74 <cprintf+0x1c4>
8010098c:	31 d2                	xor    %edx,%edx
8010098e:	b8 25 00 00 00       	mov    $0x25,%eax
80100993:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100996:	e8 55 fa ff ff       	call   801003f0 <consputc.part.0>
8010099b:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801009a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801009a3:	85 c0                	test   %eax,%eax
801009a5:	0f 84 ec 00 00 00    	je     80100a97 <cprintf+0x1e7>
801009ab:	fa                   	cli
    for(;;)
801009ac:	eb fe                	jmp    801009ac <cprintf+0xfc>
801009ae:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
801009b0:	8b 01                	mov    (%ecx),%eax
801009b2:	8d 79 04             	lea    0x4(%ecx),%edi
801009b5:	ba 10 00 00 00       	mov    $0x10,%edx
801009ba:	31 c9                	xor    %ecx,%ecx
801009bc:	e8 5f fe ff ff       	call   80100820 <printint>
801009c1:	89 f9                	mov    %edi,%ecx
      break;
801009c3:	e9 54 ff ff ff       	jmp    8010091c <cprintf+0x6c>
801009c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801009cf:	00 
    acquire(&cons.lock);
801009d0:	83 ec 0c             	sub    $0xc,%esp
801009d3:	68 a0 01 11 80       	push   $0x801101a0
801009d8:	e8 93 46 00 00       	call   80105070 <acquire>
  if (fmt == 0)
801009dd:	83 c4 10             	add    $0x10,%esp
801009e0:	85 f6                	test   %esi,%esi
801009e2:	0f 84 ca 00 00 00    	je     80100ab2 <cprintf+0x202>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801009e8:	0f b6 06             	movzbl (%esi),%eax
801009eb:	85 c0                	test   %eax,%eax
801009ed:	0f 85 e6 fe ff ff    	jne    801008d9 <cprintf+0x29>
    release(&cons.lock);
801009f3:	83 ec 0c             	sub    $0xc,%esp
801009f6:	68 a0 01 11 80       	push   $0x801101a0
801009fb:	e8 10 46 00 00       	call   80105010 <release>
80100a00:	83 c4 10             	add    $0x10,%esp
80100a03:	e9 2a ff ff ff       	jmp    80100932 <cprintf+0x82>
      if((s = (char*)*argp++) == 0)
80100a08:	8b 39                	mov    (%ecx),%edi
80100a0a:	8d 51 04             	lea    0x4(%ecx),%edx
80100a0d:	85 ff                	test   %edi,%edi
80100a0f:	74 27                	je     80100a38 <cprintf+0x188>
      for(; *s; s++)
80100a11:	0f be 07             	movsbl (%edi),%eax
80100a14:	84 c0                	test   %al,%al
80100a16:	0f 84 8f 00 00 00    	je     80100aab <cprintf+0x1fb>
80100a1c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100a1f:	89 fb                	mov    %edi,%ebx
80100a21:	89 f7                	mov    %esi,%edi
80100a23:	89 d6                	mov    %edx,%esi
  if(panicked){
80100a25:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100a2b:	85 d2                	test   %edx,%edx
80100a2d:	74 26                	je     80100a55 <cprintf+0x1a5>
80100a2f:	fa                   	cli
    for(;;)
80100a30:	eb fe                	jmp    80100a30 <cprintf+0x180>
80100a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
80100a38:	bf 98 7c 10 80       	mov    $0x80107c98,%edi
80100a3d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100a40:	b8 28 00 00 00       	mov    $0x28,%eax
80100a45:	89 fb                	mov    %edi,%ebx
80100a47:	89 f7                	mov    %esi,%edi
80100a49:	89 d6                	mov    %edx,%esi
  if(panicked){
80100a4b:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100a51:	85 d2                	test   %edx,%edx
80100a53:	75 da                	jne    80100a2f <cprintf+0x17f>
80100a55:	31 d2                	xor    %edx,%edx
      for(; *s; s++)
80100a57:	83 c3 01             	add    $0x1,%ebx
80100a5a:	e8 91 f9 ff ff       	call   801003f0 <consputc.part.0>
80100a5f:	0f be 03             	movsbl (%ebx),%eax
80100a62:	84 c0                	test   %al,%al
80100a64:	75 bf                	jne    80100a25 <cprintf+0x175>
      if((s = (char*)*argp++) == 0)
80100a66:	89 f2                	mov    %esi,%edx
80100a68:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100a6b:	89 fe                	mov    %edi,%esi
80100a6d:	89 d1                	mov    %edx,%ecx
80100a6f:	e9 a8 fe ff ff       	jmp    8010091c <cprintf+0x6c>
80100a74:	fa                   	cli
    for(;;)
80100a75:	eb fe                	jmp    80100a75 <cprintf+0x1c5>
80100a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a7e:	00 
80100a7f:	90                   	nop
80100a80:	31 d2                	xor    %edx,%edx
80100a82:	b8 25 00 00 00       	mov    $0x25,%eax
80100a87:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100a8a:	e8 61 f9 ff ff       	call   801003f0 <consputc.part.0>
      break;
80100a8f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100a92:	e9 85 fe ff ff       	jmp    8010091c <cprintf+0x6c>
80100a97:	31 d2                	xor    %edx,%edx
80100a99:	89 f8                	mov    %edi,%eax
80100a9b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100a9e:	e8 4d f9 ff ff       	call   801003f0 <consputc.part.0>
      break;
80100aa3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100aa6:	e9 71 fe ff ff       	jmp    8010091c <cprintf+0x6c>
      if((s = (char*)*argp++) == 0)
80100aab:	89 d1                	mov    %edx,%ecx
80100aad:	e9 6a fe ff ff       	jmp    8010091c <cprintf+0x6c>
    panic("null fmt");
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	68 9f 7c 10 80       	push   $0x80107c9f
80100aba:	e8 b1 f8 ff ff       	call   80100370 <panic>
80100abf:	90                   	nop

80100ac0 <consoleintr>:
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	57                   	push   %edi
80100ac4:	56                   	push   %esi
80100ac5:	53                   	push   %ebx
80100ac6:	83 ec 38             	sub    $0x38,%esp
80100ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80100acc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
80100acf:	68 a0 01 11 80       	push   $0x801101a0
80100ad4:	e8 97 45 00 00       	call   80105070 <acquire>
  while((c = getc()) >= 0){
80100ad9:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100adc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((c = getc()) >= 0){
80100ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ae6:	ff d0                	call   *%eax
80100ae8:	89 c3                	mov    %eax,%ebx
80100aea:	85 c0                	test   %eax,%eax
80100aec:	0f 88 fe 00 00 00    	js     80100bf0 <consoleintr+0x130>
    switch(c){
80100af2:	83 fb 1a             	cmp    $0x1a,%ebx
80100af5:	7f 19                	jg     80100b10 <consoleintr+0x50>
80100af7:	85 db                	test   %ebx,%ebx
80100af9:	74 e8                	je     80100ae3 <consoleintr+0x23>
80100afb:	83 fb 1a             	cmp    $0x1a,%ebx
80100afe:	0f 87 14 01 00 00    	ja     80100c18 <consoleintr+0x158>
80100b04:	ff 24 9d 40 81 10 80 	jmp    *-0x7fef7ec0(,%ebx,4)
80100b0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b10:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100b16:	0f 84 54 01 00 00    	je     80100c70 <consoleintr+0x1b0>
80100b1c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100b22:	0f 84 78 01 00 00    	je     80100ca0 <consoleintr+0x1e0>
80100b28:	83 fb 7f             	cmp    $0x7f,%ebx
80100b2b:	0f 85 e7 00 00 00    	jne    80100c18 <consoleintr+0x158>
      if (input.e != input.w) {
80100b31:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
80100b37:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
80100b3d:	39 f1                	cmp    %esi,%ecx
80100b3f:	74 a2                	je     80100ae3 <consoleintr+0x23>
        if (input.e == input.real_end) {
80100b41:	8b 15 0c ff 10 80    	mov    0x8010ff0c,%edx
          input.e--;
80100b47:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100b4a:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
          input.real_end--;
80100b50:	8d 5a ff             	lea    -0x1(%edx),%ebx
        if (input.e == input.real_end) {
80100b53:	39 d1                	cmp    %edx,%ecx
80100b55:	0f 84 cf 04 00 00    	je     8010102a <consoleintr+0x56a>
          for (uint i = input.e; i < input.real_end - 1; i++) {
80100b5b:	89 f8                	mov    %edi,%eax
80100b5d:	39 df                	cmp    %ebx,%edi
80100b5f:	73 44                	jae    80100ba5 <consoleintr+0xe5>
80100b61:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80100b64:	89 75 d8             	mov    %esi,-0x28(%ebp)
80100b67:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100b70:	89 c1                	mov    %eax,%ecx
80100b72:	83 c0 01             	add    $0x1,%eax
80100b75:	89 c6                	mov    %eax,%esi
80100b77:	83 e1 7f             	and    $0x7f,%ecx
80100b7a:	83 e6 7f             	and    $0x7f,%esi
80100b7d:	0f b6 96 80 fe 10 80 	movzbl -0x7fef0180(%esi),%edx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100b84:	8b 34 b5 10 ff 10 80 	mov    -0x7fef00f0(,%esi,4),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100b8b:	88 91 80 fe 10 80    	mov    %dl,-0x7fef0180(%ecx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100b91:	89 34 8d 10 ff 10 80 	mov    %esi,-0x7fef00f0(,%ecx,4)
          for (uint i = input.e; i < input.real_end - 1; i++) {
80100b98:	39 d8                	cmp    %ebx,%eax
80100b9a:	75 d4                	jne    80100b70 <consoleintr+0xb0>
80100b9c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80100b9f:	8b 75 d8             	mov    -0x28(%ebp),%esi
80100ba2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          input.real_end--;
80100ba5:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
          if (input.e > input.real_end) input.e = input.real_end;
80100bab:	39 fb                	cmp    %edi,%ebx
80100bad:	0f 82 f5 04 00 00    	jb     801010a8 <consoleintr+0x5e8>
          int old_cursor_off = old_e - (int)input.w;
80100bb3:	89 c8                	mov    %ecx,%eax
          if (old_cursor_off < 0) old_cursor_off = 0;
80100bb5:	31 c9                	xor    %ecx,%ecx
          int old_cursor_off = old_e - (int)input.w;
80100bb7:	29 f0                	sub    %esi,%eax
          if (old_cursor_off < 0) old_cursor_off = 0;
80100bb9:	85 c0                	test   %eax,%eax
80100bbb:	0f 49 c8             	cmovns %eax,%ecx
80100bbe:	89 4d dc             	mov    %ecx,-0x24(%ebp)
          for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);
80100bc1:	b9 00 00 00 00       	mov    $0x0,%ecx
80100bc6:	0f 8e 0f 04 00 00    	jle    80100fdb <consoleintr+0x51b>
80100bcc:	89 75 d8             	mov    %esi,-0x28(%ebp)
80100bcf:	89 d6                	mov    %edx,%esi
80100bd1:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80100bd4:	89 cb                	mov    %ecx,%ebx
  if(panicked){
80100bd6:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100bdc:	85 d2                	test   %edx,%edx
80100bde:	0f 84 d7 03 00 00    	je     80100fbb <consoleintr+0x4fb>
80100be4:	fa                   	cli
    for(;;)
80100be5:	eb fe                	jmp    80100be5 <consoleintr+0x125>
80100be7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100bee:	00 
80100bef:	90                   	nop
  release(&cons.lock);
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	68 a0 01 11 80       	push   $0x801101a0
80100bf8:	e8 13 44 00 00       	call   80105010 <release>
  if(doprocdump)
80100bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	85 c0                	test   %eax,%eax
80100c05:	0f 85 c5 00 00 00    	jne    80100cd0 <consoleintr+0x210>
}
80100c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c0e:	5b                   	pop    %ebx
80100c0f:	5e                   	pop    %esi
80100c10:	5f                   	pop    %edi
80100c11:	5d                   	pop    %ebp
80100c12:	c3                   	ret
80100c13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(input.e < input.real_end){
80100c18:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100c1d:	8b 35 08 ff 10 80    	mov    0x8010ff08,%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100c23:	89 c2                	mov    %eax,%edx
80100c25:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
      if(input.e < input.real_end){
80100c2b:	39 c6                	cmp    %eax,%esi
80100c2d:	0f 83 15 04 00 00    	jae    80101048 <consoleintr+0x588>
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100c33:	83 fa 7f             	cmp    $0x7f,%edx
80100c36:	0f 87 a7 fe ff ff    	ja     80100ae3 <consoleintr+0x23>
  if(panicked){
80100c3c:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100c42:	8d 48 01             	lea    0x1(%eax),%ecx
          if(c != '\n'){
80100c45:	83 fb 0a             	cmp    $0xa,%ebx
80100c48:	0f 85 e0 05 00 00    	jne    8010122e <consoleintr+0x76e>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100c4e:	83 e0 7f             	and    $0x7f,%eax
80100c51:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100c57:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
80100c5e:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
  if(panicked){
80100c64:	85 ff                	test   %edi,%edi
80100c66:	0f 84 64 07 00 00    	je     801013d0 <consoleintr+0x910>
80100c6c:	fa                   	cli
    for(;;)
80100c6d:	eb fe                	jmp    80100c6d <consoleintr+0x1ad>
80100c6f:	90                   	nop
      if (input.e > input.w){
80100c70:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100c75:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100c7b:	0f 83 62 fe ff ff    	jae    80100ae3 <consoleintr+0x23>
        input.e--;
80100c81:	83 e8 01             	sub    $0x1,%eax
80100c84:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100c89:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100c8e:	85 c0                	test   %eax,%eax
80100c90:	0f 84 35 04 00 00    	je     801010cb <consoleintr+0x60b>
80100c96:	fa                   	cli
    for(;;)
80100c97:	eb fe                	jmp    80100c97 <consoleintr+0x1d7>
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.e < input.real_end){
80100ca0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ca5:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100cab:	0f 83 32 fe ff ff    	jae    80100ae3 <consoleintr+0x23>
        char ch = input.buf[input.e % INPUT_BUF];
80100cb1:	83 e0 7f             	and    $0x7f,%eax
80100cb4:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if(panicked){
80100cbb:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100cc0:	85 c0                	test   %eax,%eax
80100cc2:	0f 84 ed 03 00 00    	je     801010b5 <consoleintr+0x5f5>
80100cc8:	fa                   	cli
    for(;;)
80100cc9:	eb fe                	jmp    80100cc9 <consoleintr+0x209>
80100ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80100cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cd3:	5b                   	pop    %ebx
80100cd4:	5e                   	pop    %esi
80100cd5:	5f                   	pop    %edi
80100cd6:	5d                   	pop    %ebp
    procdump();
80100cd7:	e9 b4 3f 00 00       	jmp    80104c90 <procdump>
      if (input.real_end > input.w) {
80100cdc:	8b 1d 0c ff 10 80    	mov    0x8010ff0c,%ebx
80100ce2:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
80100ce8:	39 de                	cmp    %ebx,%esi
80100cea:	0f 83 f3 fd ff ff    	jae    80100ae3 <consoleintr+0x23>
        for (uint i = input.w; i < input.real_end; i++) {
80100cf0:	89 f0                	mov    %esi,%eax
        int max_t = -1, idx = -1;
80100cf2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80100cf7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80100cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          int t = input.insert_order[i % INPUT_BUF];
80100d00:	89 c2                	mov    %eax,%edx
80100d02:	83 e2 7f             	and    $0x7f,%edx
80100d05:	8b 14 95 10 ff 10 80 	mov    -0x7fef00f0(,%edx,4),%edx
          if (t > max_t) {
80100d0c:	39 fa                	cmp    %edi,%edx
80100d0e:	7e 04                	jle    80100d14 <consoleintr+0x254>
            idx = (int)i;
80100d10:	89 c1                	mov    %eax,%ecx
            max_t = t;
80100d12:	89 d7                	mov    %edx,%edi
        for (uint i = input.w; i < input.real_end; i++) {
80100d14:	83 c0 01             	add    $0x1,%eax
80100d17:	39 c3                	cmp    %eax,%ebx
80100d19:	75 e5                	jne    80100d00 <consoleintr+0x240>
        if (idx >= 0) {
80100d1b:	85 c9                	test   %ecx,%ecx
80100d1d:	0f 88 c0 fd ff ff    	js     80100ae3 <consoleintr+0x23>
          int old_e = (int)input.e;
80100d23:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
          for (int i = idx; i < old_real_end - 1; i++) {
80100d29:	8d 7b ff             	lea    -0x1(%ebx),%edi
80100d2c:	89 c8                	mov    %ecx,%eax
          int old_e = (int)input.e;
80100d2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
          for (int i = idx; i < old_real_end - 1; i++) {
80100d31:	39 f9                	cmp    %edi,%ecx
80100d33:	7d 3e                	jge    80100d73 <consoleintr+0x2b3>
80100d35:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80100d38:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80100d3b:	89 55 d0             	mov    %edx,-0x30(%ebp)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100d3e:	89 c1                	mov    %eax,%ecx
80100d40:	83 c0 01             	add    $0x1,%eax
80100d43:	89 c3                	mov    %eax,%ebx
80100d45:	83 e1 7f             	and    $0x7f,%ecx
80100d48:	83 e3 7f             	and    $0x7f,%ebx
80100d4b:	0f b6 93 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%edx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100d52:	8b 1c 9d 10 ff 10 80 	mov    -0x7fef00f0(,%ebx,4),%ebx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100d59:	88 91 80 fe 10 80    	mov    %dl,-0x7fef0180(%ecx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100d5f:	89 1c 8d 10 ff 10 80 	mov    %ebx,-0x7fef00f0(,%ecx,4)
          for (int i = idx; i < old_real_end - 1; i++) {
80100d66:	39 f8                	cmp    %edi,%eax
80100d68:	75 d4                	jne    80100d3e <consoleintr+0x27e>
80100d6a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80100d6d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80100d70:	8b 55 d0             	mov    -0x30(%ebp),%edx
          input.real_end--;
80100d73:	89 3d 0c ff 10 80    	mov    %edi,0x8010ff0c
          if ((int)input.e > idx) 
80100d79:	39 d1                	cmp    %edx,%ecx
80100d7b:	7d 09                	jge    80100d86 <consoleintr+0x2c6>
              input.e--;
80100d7d:	83 ea 01             	sub    $0x1,%edx
80100d80:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          if (input.e < input.w) 
80100d86:	39 f2                	cmp    %esi,%edx
80100d88:	73 08                	jae    80100d92 <consoleintr+0x2d2>
              input.e = input.w;
80100d8a:	89 35 08 ff 10 80    	mov    %esi,0x8010ff08
80100d90:	89 f2                	mov    %esi,%edx
          if (input.e > input.real_end) 
80100d92:	39 d7                	cmp    %edx,%edi
80100d94:	73 08                	jae    80100d9e <consoleintr+0x2de>
              input.e = input.real_end;
80100d96:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
80100d9c:	89 fa                	mov    %edi,%edx
          int old_cursor_off = old_e - (int)input.w;
80100d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
          if (old_cursor_off < 0) 
80100da1:	31 c9                	xor    %ecx,%ecx
          int old_cursor_off = old_e - (int)input.w;
80100da3:	29 f0                	sub    %esi,%eax
          if (old_cursor_off < 0) 
80100da5:	85 c0                	test   %eax,%eax
80100da7:	0f 49 c8             	cmovns %eax,%ecx
80100daa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
          for (int i = 0; i < old_cursor_off; i++) 
80100dad:	b9 00 00 00 00       	mov    $0x0,%ecx
80100db2:	0f 8e b8 03 00 00    	jle    80101170 <consoleintr+0x6b0>
80100db8:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80100dbb:	89 cb                	mov    %ecx,%ebx
80100dbd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100dc0:	89 d7                	mov    %edx,%edi
  if(panicked){
80100dc2:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100dc7:	85 c0                	test   %eax,%eax
80100dc9:	0f 84 81 03 00 00    	je     80101150 <consoleintr+0x690>
80100dcf:	fa                   	cli
    for(;;)
80100dd0:	eb fe                	jmp    80100dd0 <consoleintr+0x310>
80100dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100dd8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ddd:	89 c2                	mov    %eax,%edx
80100ddf:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100de5:	0f 83 f8 fc ff ff    	jae    80100ae3 <consoleintr+0x23>
80100deb:	83 e2 7f             	and    $0x7f,%edx
80100dee:	0f be 92 80 fe 10 80 	movsbl -0x7fef0180(%edx),%edx
80100df5:	80 fa 20             	cmp    $0x20,%dl
80100df8:	0f 84 2a 01 00 00    	je     80100f28 <consoleintr+0x468>
80100dfe:	80 fa 0a             	cmp    $0xa,%dl
80100e01:	0f 84 21 01 00 00    	je     80100f28 <consoleintr+0x468>
  if(panicked){
80100e07:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100e0c:	85 c0                	test   %eax,%eax
80100e0e:	0f 84 3c 01 00 00    	je     80100f50 <consoleintr+0x490>
80100e14:	fa                   	cli
    for(;;)
80100e15:	eb fe                	jmp    80100e15 <consoleintr+0x355>
80100e17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e1e:	00 
80100e1f:	90                   	nop
      if(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100e20:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e25:	89 c2                	mov    %eax,%edx
80100e27:	85 c0                	test   %eax,%eax
80100e29:	0f 84 b4 fc ff ff    	je     80100ae3 <consoleintr+0x23>
80100e2f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100e32:	83 e1 7f             	and    $0x7f,%ecx
80100e35:	80 b9 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%ecx)
80100e3c:	0f 84 fe 02 00 00    	je     80101140 <consoleintr+0x680>
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100e42:	83 e2 7f             	and    $0x7f,%edx
80100e45:	80 ba 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%edx)
80100e4c:	0f 85 9b 02 00 00    	jne    801010ed <consoleintr+0x62d>
  if(panicked){
80100e52:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80100e58:	85 ff                	test   %edi,%edi
80100e5a:	74 04                	je     80100e60 <consoleintr+0x3a0>
80100e5c:	fa                   	cli
    for(;;)
80100e5d:	eb fe                	jmp    80100e5d <consoleintr+0x39d>
80100e5f:	90                   	nop
80100e60:	31 d2                	xor    %edx,%edx
80100e62:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100e67:	e8 84 f5 ff ff       	call   801003f0 <consputc.part.0>
        input.e--;
80100e6c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100e71:	8d 50 ff             	lea    -0x1(%eax),%edx
80100e74:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100e7a:	89 d0                	mov    %edx,%eax
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100e7c:	85 d2                	test   %edx,%edx
80100e7e:	75 c2                	jne    80100e42 <consoleintr+0x382>
80100e80:	e9 5e fc ff ff       	jmp    80100ae3 <consoleintr+0x23>
80100e85:	8d 76 00             	lea    0x0(%esi),%esi
  if (input.sel_a < 0) {
80100e88:	8b 15 14 01 11 80    	mov    0x80110114,%edx
    input.sel_a = (int)input.e;
80100e8e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  if (input.sel_a < 0) {
80100e93:	85 d2                	test   %edx,%edx
80100e95:	0f 88 16 01 00 00    	js     80100fb1 <consoleintr+0x4f1>
    input.sel_b = (int)input.e;
80100e9b:	a3 18 01 11 80       	mov    %eax,0x80110118
  if (input.sel_b == input.sel_a) { clear_selection(); break; }
80100ea0:	39 c2                	cmp    %eax,%edx
80100ea2:	0f 85 78 01 00 00    	jne    80101020 <consoleintr+0x560>
  input.sel_a = input.sel_b = -1;
80100ea8:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80100eaf:	ff ff ff 
80100eb2:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80100eb9:	ff ff ff 
}
80100ebc:	e9 22 fc ff ff       	jmp    80100ae3 <consoleintr+0x23>
      while(input.e != input.w &&
80100ec1:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ec6:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100ecc:	0f 84 cb 00 00 00    	je     80100f9d <consoleintr+0x4dd>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ed2:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ed5:	89 d1                	mov    %edx,%ecx
80100ed7:	83 e1 7f             	and    $0x7f,%ecx
      while(input.e != input.w &&
80100eda:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
80100ee1:	0f 84 b6 00 00 00    	je     80100f9d <consoleintr+0x4dd>
  if(panicked){
80100ee7:	8b 1d d8 01 11 80    	mov    0x801101d8,%ebx
        input.e--;
80100eed:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if(panicked){
80100ef3:	85 db                	test   %ebx,%ebx
80100ef5:	0f 84 85 00 00 00    	je     80100f80 <consoleintr+0x4c0>
80100efb:	fa                   	cli
    for(;;)
80100efc:	eb fe                	jmp    80100efc <consoleintr+0x43c>
80100efe:	66 90                	xchg   %ax,%ax
    switch(c){
80100f00:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80100f07:	e9 d7 fb ff ff       	jmp    80100ae3 <consoleintr+0x23>
80100f0c:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100f11:	ba 20 00 00 00       	mov    $0x20,%edx
80100f16:	e8 d5 f4 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100f1b:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f20:	83 c0 01             	add    $0x1,%eax
80100f23:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100f28:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100f2e:	0f 83 af fb ff ff    	jae    80100ae3 <consoleintr+0x23>
80100f34:	83 e0 7f             	and    $0x7f,%eax
80100f37:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100f3e:	0f 85 9f fb ff ff    	jne    80100ae3 <consoleintr+0x23>
  if(panicked){
80100f44:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100f49:	85 c0                	test   %eax,%eax
80100f4b:	74 bf                	je     80100f0c <consoleintr+0x44c>
80100f4d:	fa                   	cli
    for(;;)
80100f4e:	eb fe                	jmp    80100f4e <consoleintr+0x48e>
80100f50:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100f55:	e8 96 f4 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100f5a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f5f:	8d 50 01             	lea    0x1(%eax),%edx
80100f62:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100f68:	89 d0                	mov    %edx,%eax
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100f6a:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100f70:	0f 82 75 fe ff ff    	jb     80100deb <consoleintr+0x32b>
80100f76:	e9 68 fb ff ff       	jmp    80100ae3 <consoleintr+0x23>
80100f7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f80:	b8 00 01 00 00       	mov    $0x100,%eax
80100f85:	31 d2                	xor    %edx,%edx
80100f87:	e8 64 f4 ff ff       	call   801003f0 <consputc.part.0>
      while(input.e != input.w &&
80100f8c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f91:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100f97:	0f 85 35 ff ff ff    	jne    80100ed2 <consoleintr+0x412>
      input.real_end = input.e;
80100f9d:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      input.current_time = 0;
80100fa2:	c7 05 10 01 11 80 00 	movl   $0x0,0x80110110
80100fa9:	00 00 00 
      break;
80100fac:	e9 32 fb ff ff       	jmp    80100ae3 <consoleintr+0x23>
    input.sel_a = (int)input.e;
80100fb1:	a3 14 01 11 80       	mov    %eax,0x80110114
    break;
80100fb6:	e9 28 fb ff ff       	jmp    80100ae3 <consoleintr+0x23>
80100fbb:	31 d2                	xor    %edx,%edx
80100fbd:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);
80100fc2:	83 c3 01             	add    $0x1,%ebx
80100fc5:	e8 26 f4 ff ff       	call   801003f0 <consputc.part.0>
80100fca:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80100fcd:	0f 8f 03 fc ff ff    	jg     80100bd6 <consoleintr+0x116>
80100fd3:	89 f2                	mov    %esi,%edx
80100fd5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80100fd8:	8b 75 d8             	mov    -0x28(%ebp),%esi
          int old_len = old_real_end - (int)input.w;
80100fdb:	89 d0                	mov    %edx,%eax
          if (old_len < 0) old_len = 0;
80100fdd:	b9 00 00 00 00       	mov    $0x0,%ecx
min_int(int a, int b) { return a < b ? a : b; }
80100fe2:	ba 50 00 00 00       	mov    $0x50,%edx
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
80100fe7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
          int old_len = old_real_end - (int)input.w;
80100fee:	29 f0                	sub    %esi,%eax
          if (old_len < 0) old_len = 0;
80100ff0:	0f 49 c8             	cmovns %eax,%ecx
min_int(int a, int b) { return a < b ? a : b; }
80100ff3:	39 d1                	cmp    %edx,%ecx
80100ff5:	0f 4f ca             	cmovg  %edx,%ecx
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
80100ff8:	85 c0                	test   %eax,%eax
80100ffa:	0f 8e 8e 03 00 00    	jle    8010138e <consoleintr+0x8ce>
80101000:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80101003:	89 cb                	mov    %ecx,%ebx
  if(panicked){
80101005:	a1 d8 01 11 80       	mov    0x801101d8,%eax
8010100a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010100d:	85 c0                	test   %eax,%eax
8010100f:	0f 84 9b 01 00 00    	je     801011b0 <consoleintr+0x6f0>
80101015:	fa                   	cli
    for(;;)
80101016:	eb fe                	jmp    80101016 <consoleintr+0x556>
80101018:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101f:	00 
  redraw_edit_with_selection();
80101020:	e8 ab f6 ff ff       	call   801006d0 <redraw_edit_with_selection>
  break;
80101025:	e9 b9 fa ff ff       	jmp    80100ae3 <consoleintr+0x23>
  if(panicked){
8010102a:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
          input.real_end--;
80101030:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80101036:	85 c9                	test   %ecx,%ecx
80101038:	0f 84 9e 00 00 00    	je     801010dc <consoleintr+0x61c>
8010103e:	fa                   	cli
    for(;;)
8010103f:	eb fe                	jmp    8010103f <consoleintr+0x57f>
80101041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80101048:	83 fa 7f             	cmp    $0x7f,%edx
8010104b:	0f 87 92 fa ff ff    	ja     80100ae3 <consoleintr+0x23>
            input.buf[input.e % INPUT_BUF] = c;
80101051:	89 d9                	mov    %ebx,%ecx
          c = (c == '\r') ? '\n' : c;
80101053:	83 fb 0d             	cmp    $0xd,%ebx
80101056:	75 0a                	jne    80101062 <consoleintr+0x5a2>
80101058:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010105d:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
80101062:	8b 3d 10 01 11 80    	mov    0x80110110,%edi
          input.buf[input.e++ % INPUT_BUF] = c;
80101068:	8d 56 01             	lea    0x1(%esi),%edx
8010106b:	83 e6 7f             	and    $0x7f,%esi
8010106e:	88 8e 80 fe 10 80    	mov    %cl,-0x7fef0180(%esi)
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
80101074:	8d 4f 01             	lea    0x1(%edi),%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80101077:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
8010107d:	89 0d 10 01 11 80    	mov    %ecx,0x80110110
80101083:	89 0c b5 10 ff 10 80 	mov    %ecx,-0x7fef00f0(,%esi,4)
          if (input.e > input.real_end) input.real_end = input.e;
8010108a:	39 d0                	cmp    %edx,%eax
8010108c:	73 06                	jae    80101094 <consoleintr+0x5d4>
8010108e:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80101094:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
8010109a:	85 d2                	test   %edx,%edx
8010109c:	0f 84 46 01 00 00    	je     801011e8 <consoleintr+0x728>
801010a2:	fa                   	cli
    for(;;)
801010a3:	eb fe                	jmp    801010a3 <consoleintr+0x5e3>
801010a5:	8d 76 00             	lea    0x0(%esi),%esi
          if (input.e > input.real_end) input.e = input.real_end;
801010a8:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
801010ae:	89 df                	mov    %ebx,%edi
801010b0:	e9 fe fa ff ff       	jmp    80100bb3 <consoleintr+0xf3>
801010b5:	b8 e5 00 00 00       	mov    $0xe5,%eax
801010ba:	e8 31 f3 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
801010bf:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
801010c6:	e9 18 fa ff ff       	jmp    80100ae3 <consoleintr+0x23>
801010cb:	31 d2                	xor    %edx,%edx
801010cd:	b8 e4 00 00 00       	mov    $0xe4,%eax
801010d2:	e8 19 f3 ff ff       	call   801003f0 <consputc.part.0>
801010d7:	e9 07 fa ff ff       	jmp    80100ae3 <consoleintr+0x23>
801010dc:	31 d2                	xor    %edx,%edx
801010de:	b8 00 01 00 00       	mov    $0x100,%eax
801010e3:	e8 08 f3 ff ff       	call   801003f0 <consputc.part.0>
801010e8:	e9 f6 f9 ff ff       	jmp    80100ae3 <consoleintr+0x23>
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
801010ed:	85 c0                	test   %eax,%eax
801010ef:	0f 84 ee f9 ff ff    	je     80100ae3 <consoleintr+0x23>
801010f5:	83 e8 01             	sub    $0x1,%eax
801010f8:	83 e0 7f             	and    $0x7f,%eax
801010fb:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80101102:	0f 84 db f9 ff ff    	je     80100ae3 <consoleintr+0x23>
  if(panicked){
80101108:	8b 35 d8 01 11 80    	mov    0x801101d8,%esi
8010110e:	85 f6                	test   %esi,%esi
80101110:	74 06                	je     80101118 <consoleintr+0x658>
80101112:	fa                   	cli
    for(;;)
80101113:	eb fe                	jmp    80101113 <consoleintr+0x653>
80101115:	8d 76 00             	lea    0x0(%esi),%esi
80101118:	31 d2                	xor    %edx,%edx
8010111a:	b8 e4 00 00 00       	mov    $0xe4,%eax
8010111f:	e8 cc f2 ff ff       	call   801003f0 <consputc.part.0>
        input.e--;
80101124:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101129:	83 e8 01             	sub    $0x1,%eax
8010112c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
80101131:	75 c2                	jne    801010f5 <consoleintr+0x635>
80101133:	e9 ab f9 ff ff       	jmp    80100ae3 <consoleintr+0x23>
80101138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010113f:	00 
  if(panicked){
80101140:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101145:	85 c0                	test   %eax,%eax
80101147:	0f 84 13 fd ff ff    	je     80100e60 <consoleintr+0x3a0>
8010114d:	fa                   	cli
    for(;;)
8010114e:	eb fe                	jmp    8010114e <consoleintr+0x68e>
80101150:	31 d2                	xor    %edx,%edx
80101152:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++) 
80101157:	83 c3 01             	add    $0x1,%ebx
8010115a:	e8 91 f2 ff ff       	call   801003f0 <consputc.part.0>
8010115f:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80101162:	0f 8f 5a fc ff ff    	jg     80100dc2 <consoleintr+0x302>
80101168:	89 fa                	mov    %edi,%edx
8010116a:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010116d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
          int old_len = old_real_end - (int)input.w;
80101170:	89 d8                	mov    %ebx,%eax
          if (old_len < 0) old_len = 0;
80101172:	bb 00 00 00 00       	mov    $0x0,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80101177:	b9 50 00 00 00       	mov    $0x50,%ecx
          int old_len = old_real_end - (int)input.w;
8010117c:	29 f0                	sub    %esi,%eax
          if (old_len < 0) old_len = 0;
8010117e:	0f 49 d8             	cmovns %eax,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80101181:	39 cb                	cmp    %ecx,%ebx
80101183:	0f 4f d9             	cmovg  %ecx,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++) 
80101186:	31 c9                	xor    %ecx,%ecx
80101188:	85 c0                	test   %eax,%eax
8010118a:	0f 8e 0e 03 00 00    	jle    8010149e <consoleintr+0x9de>
80101190:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101193:	89 ce                	mov    %ecx,%esi
80101195:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80101198:	89 d7                	mov    %edx,%edi
  if(panicked){
8010119a:	a1 d8 01 11 80       	mov    0x801101d8,%eax
8010119f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011a2:	85 c0                	test   %eax,%eax
801011a4:	0f 84 8e 01 00 00    	je     80101338 <consoleintr+0x878>
801011aa:	fa                   	cli
    for(;;)
801011ab:	eb fe                	jmp    801011ab <consoleintr+0x6eb>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi
801011b0:	b8 20 00 00 00       	mov    $0x20,%eax
801011b5:	31 d2                	xor    %edx,%edx
801011b7:	e8 34 f2 ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
801011bc:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
801011c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c3:	39 d8                	cmp    %ebx,%eax
801011c5:	0f 8c 3a fe ff ff    	jl     80101005 <consoleintr+0x545>
801011cb:	89 d9                	mov    %ebx,%ecx
801011cd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801011d0:	89 5d d8             	mov    %ebx,-0x28(%ebp)
801011d3:	89 cb                	mov    %ecx,%ebx
  if(panicked){
801011d5:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801011da:	85 c0                	test   %eax,%eax
801011dc:	0f 84 8e 01 00 00    	je     80101370 <consoleintr+0x8b0>
801011e2:	fa                   	cli
    for(;;)
801011e3:	eb fe                	jmp    801011e3 <consoleintr+0x723>
801011e5:	8d 76 00             	lea    0x0(%esi),%esi
801011e8:	31 d2                	xor    %edx,%edx
801011ea:	89 d8                	mov    %ebx,%eax
801011ec:	e8 ff f1 ff ff       	call   801003f0 <consputc.part.0>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
801011f1:	83 fb 0a             	cmp    $0xa,%ebx
801011f4:	74 14                	je     8010120a <consoleintr+0x74a>
801011f6:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801011fb:	83 e8 80             	sub    $0xffffff80,%eax
801011fe:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
80101204:	0f 85 d9 f8 ff ff    	jne    80100ae3 <consoleintr+0x23>
            input.w = input.e;
8010120a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
8010120f:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80101212:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
80101217:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
8010121c:	68 00 ff 10 80       	push   $0x8010ff00
80101221:	e8 8a 39 00 00       	call   80104bb0 <wakeup>
80101226:	83 c4 10             	add    $0x10,%esp
80101229:	e9 b5 f8 ff ff       	jmp    80100ae3 <consoleintr+0x23>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
8010122e:	83 e8 01             	sub    $0x1,%eax
80101231:	8d 56 ff             	lea    -0x1(%esi),%edx
80101234:	39 c6                	cmp    %eax,%esi
80101236:	7f 58                	jg     80101290 <consoleintr+0x7d0>
80101238:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010123b:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
8010123e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80101241:	89 55 dc             	mov    %edx,-0x24(%ebp)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101244:	99                   	cltd
80101245:	c1 ea 19             	shr    $0x19,%edx
80101248:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
8010124b:	83 e3 7f             	and    $0x7f,%ebx
8010124e:	29 d3                	sub    %edx,%ebx
80101250:	8d 50 01             	lea    0x1(%eax),%edx
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
80101253:	83 e8 01             	sub    $0x1,%eax
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101256:	89 d6                	mov    %edx,%esi
80101258:	0f b6 8b 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%ecx
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
8010125f:	8b 1c 9d 10 ff 10 80 	mov    -0x7fef00f0(,%ebx,4),%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101266:	c1 fe 1f             	sar    $0x1f,%esi
80101269:	c1 ee 19             	shr    $0x19,%esi
8010126c:	01 f2                	add    %esi,%edx
8010126e:	83 e2 7f             	and    $0x7f,%edx
80101271:	29 f2                	sub    %esi,%edx
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
80101273:	8b 75 dc             	mov    -0x24(%ebp),%esi
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101276:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
8010127c:	89 1c 95 10 ff 10 80 	mov    %ebx,-0x7fef00f0(,%edx,4)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
80101283:	39 f0                	cmp    %esi,%eax
80101285:	75 bd                	jne    80101244 <consoleintr+0x784>
80101287:	8b 75 d8             	mov    -0x28(%ebp),%esi
8010128a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
8010128d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80101290:	a1 10 01 11 80       	mov    0x80110110,%eax
            input.buf[input.e % INPUT_BUF] = c;
80101295:	83 e6 7f             	and    $0x7f,%esi
            input.real_end++;
80101298:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
            input.buf[input.e % INPUT_BUF] = c;
8010129e:	88 9e 80 fe 10 80    	mov    %bl,-0x7fef0180(%esi)
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
801012a4:	83 c0 01             	add    $0x1,%eax
801012a7:	a3 10 01 11 80       	mov    %eax,0x80110110
801012ac:	89 04 b5 10 ff 10 80 	mov    %eax,-0x7fef00f0(,%esi,4)
  if(panicked){
801012b3:	85 ff                	test   %edi,%edi
801012b5:	74 09                	je     801012c0 <consoleintr+0x800>
801012b7:	fa                   	cli
    for(;;)
801012b8:	eb fe                	jmp    801012b8 <consoleintr+0x7f8>
801012ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012c0:	89 d8                	mov    %ebx,%eax
801012c2:	31 d2                	xor    %edx,%edx
801012c4:	e8 27 f1 ff ff       	call   801003f0 <consputc.part.0>
            input.e++;
801012c9:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801012ce:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
801012d1:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
801012d6:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
801012dc:	39 c3                	cmp    %eax,%ebx
801012de:	0f 83 33 01 00 00    	jae    80101417 <consoleintr+0x957>
              consputc(input.buf[i % INPUT_BUF], 0);
801012e4:	89 d8                	mov    %ebx,%eax
  if(panicked){
801012e6:	8b 35 d8 01 11 80    	mov    0x801101d8,%esi
              consputc(input.buf[i % INPUT_BUF], 0);
801012ec:	83 e0 7f             	and    $0x7f,%eax
801012ef:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801012f6:	85 f6                	test   %esi,%esi
801012f8:	74 06                	je     80101300 <consoleintr+0x840>
801012fa:	fa                   	cli
    for(;;)
801012fb:	eb fe                	jmp    801012fb <consoleintr+0x83b>
801012fd:	8d 76 00             	lea    0x0(%esi),%esi
80101300:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80101302:	83 c3 01             	add    $0x1,%ebx
80101305:	e8 e6 f0 ff ff       	call   801003f0 <consputc.part.0>
8010130a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
8010130f:	39 c3                	cmp    %eax,%ebx
80101311:	72 d1                	jb     801012e4 <consoleintr+0x824>
            for (uint k = input.e; k < input.real_end; k++)
80101313:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80101319:	39 c3                	cmp    %eax,%ebx
8010131b:	0f 83 f6 00 00 00    	jae    80101417 <consoleintr+0x957>
  if(panicked){
80101321:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
80101327:	85 c9                	test   %ecx,%ecx
80101329:	0f 84 cc 00 00 00    	je     801013fb <consoleintr+0x93b>
8010132f:	fa                   	cli
    for(;;)
80101330:	eb fe                	jmp    80101330 <consoleintr+0x870>
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101338:	31 d2                	xor    %edx,%edx
8010133a:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++) 
8010133f:	83 c6 01             	add    $0x1,%esi
80101342:	e8 a9 f0 ff ff       	call   801003f0 <consputc.part.0>
80101347:	39 de                	cmp    %ebx,%esi
80101349:	0f 8c 4b fe ff ff    	jl     8010119a <consoleintr+0x6da>
8010134f:	89 fa                	mov    %edi,%edx
80101351:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80101354:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101357:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010135a:	89 d7                	mov    %edx,%edi
  if(panicked){
8010135c:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101361:	85 c0                	test   %eax,%eax
80101363:	0f 84 15 01 00 00    	je     8010147e <consoleintr+0x9be>
80101369:	fa                   	cli
    for(;;)
8010136a:	eb fe                	jmp    8010136a <consoleintr+0x8aa>
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101370:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101375:	31 d2                	xor    %edx,%edx
80101377:	e8 74 f0 ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(KEY_LF, 0);
8010137c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101380:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101383:	39 d8                	cmp    %ebx,%eax
80101385:	0f 8c 4a fe ff ff    	jl     801011d5 <consoleintr+0x715>
8010138b:	8b 5d d8             	mov    -0x28(%ebp),%ebx
          int new_len = (int)input.real_end - (int)input.w;
8010138e:	89 d8                	mov    %ebx,%eax
          if (new_len < 0) new_len = 0;
80101390:	31 db                	xor    %ebx,%ebx
          for (int i = 0; i < new_len; i++)
80101392:	b9 00 00 00 00       	mov    $0x0,%ecx
          int new_len = (int)input.real_end - (int)input.w;
80101397:	29 f0                	sub    %esi,%eax
          if (new_len < 0) new_len = 0;
80101399:	85 c0                	test   %eax,%eax
8010139b:	0f 49 d8             	cmovns %eax,%ebx
          for (int i = 0; i < new_len; i++)
8010139e:	0f 8e a7 00 00 00    	jle    8010144b <consoleintr+0x98b>
801013a4:	89 7d dc             	mov    %edi,-0x24(%ebp)
801013a7:	89 f7                	mov    %esi,%edi
801013a9:	89 de                	mov    %ebx,%esi
801013ab:	89 cb                	mov    %ecx,%ebx
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801013ad:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801013b2:	01 d8                	add    %ebx,%eax
801013b4:	83 e0 7f             	and    $0x7f,%eax
  if(panicked){
801013b7:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801013be:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801013c5:	74 6b                	je     80101432 <consoleintr+0x972>
801013c7:	fa                   	cli
    for(;;)
801013c8:	eb fe                	jmp    801013c8 <consoleintr+0x908>
801013ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013d0:	31 d2                	xor    %edx,%edx
801013d2:	b8 0a 00 00 00       	mov    $0xa,%eax
801013d7:	e8 14 f0 ff ff       	call   801003f0 <consputc.part.0>
            input.w = input.e;
801013dc:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
801013e1:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
801013e4:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
801013e9:	68 00 ff 10 80       	push   $0x8010ff00
801013ee:	e8 bd 37 00 00       	call   80104bb0 <wakeup>
801013f3:	83 c4 10             	add    $0x10,%esp
801013f6:	e9 e8 f6 ff ff       	jmp    80100ae3 <consoleintr+0x23>
801013fb:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101400:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80101402:	83 c3 01             	add    $0x1,%ebx
80101405:	e8 e6 ef ff ff       	call   801003f0 <consputc.part.0>
8010140a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
8010140f:	39 c3                	cmp    %eax,%ebx
80101411:	0f 82 0a ff ff ff    	jb     80101321 <consoleintr+0x861>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80101417:	8b 3d 00 ff 10 80    	mov    0x8010ff00,%edi
8010141d:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80101423:	39 c2                	cmp    %eax,%edx
80101425:	0f 85 b8 f6 ff ff    	jne    80100ae3 <consoleintr+0x23>
            input.e = input.real_end;
8010142b:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            if (c == '\n') {
80101430:	eb aa                	jmp    801013dc <consoleintr+0x91c>
80101432:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101434:	83 c3 01             	add    $0x1,%ebx
80101437:	e8 b4 ef ff ff       	call   801003f0 <consputc.part.0>
8010143c:	39 de                	cmp    %ebx,%esi
8010143e:	0f 8f 69 ff ff ff    	jg     801013ad <consoleintr+0x8ed>
80101444:	89 f3                	mov    %esi,%ebx
80101446:	89 fe                	mov    %edi,%esi
80101448:	8b 7d dc             	mov    -0x24(%ebp),%edi
          if (new_cursor_off < 0) new_cursor_off = 0;
8010144b:	29 f7                	sub    %esi,%edi
8010144d:	b8 00 00 00 00       	mov    $0x0,%eax
80101452:	0f 49 c7             	cmovns %edi,%eax
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
80101455:	31 f6                	xor    %esi,%esi
          int moves_left = new_len - new_cursor_off;
80101457:	29 c3                	sub    %eax,%ebx
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
80101459:	39 de                	cmp    %ebx,%esi
8010145b:	0f 8d 82 f6 ff ff    	jge    80100ae3 <consoleintr+0x23>
  if(panicked){
80101461:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
80101468:	74 03                	je     8010146d <consoleintr+0x9ad>
8010146a:	fa                   	cli
    for(;;)
8010146b:	eb fe                	jmp    8010146b <consoleintr+0x9ab>
8010146d:	31 d2                	xor    %edx,%edx
8010146f:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
80101474:	83 c6 01             	add    $0x1,%esi
80101477:	e8 74 ef ff ff       	call   801003f0 <consputc.part.0>
8010147c:	eb db                	jmp    80101459 <consoleintr+0x999>
8010147e:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101483:	31 d2                	xor    %edx,%edx
80101485:	e8 66 ef ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) 
8010148a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
8010148e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101491:	39 d8                	cmp    %ebx,%eax
80101493:	0f 8c c3 fe ff ff    	jl     8010135c <consoleintr+0x89c>
80101499:	89 fa                	mov    %edi,%edx
8010149b:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010149e:	89 55 dc             	mov    %edx,-0x24(%ebp)
          int new_len = (int)input.real_end - (int)input.w;
801014a1:	29 f7                	sub    %esi,%edi
          if (new_len < 0) 
801014a3:	b8 00 00 00 00       	mov    $0x0,%eax
801014a8:	0f 48 f8             	cmovs  %eax,%edi
          for (int i = 0; i < new_len; i++)
801014ab:	31 db                	xor    %ebx,%ebx
801014ad:	39 df                	cmp    %ebx,%edi
801014af:	74 29                	je     801014da <consoleintr+0xa1a>
              consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801014b1:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801014b6:	01 d8                	add    %ebx,%eax
801014b8:	83 e0 7f             	and    $0x7f,%eax
  if(panicked){
801014bb:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
              consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801014c2:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801014c9:	74 03                	je     801014ce <consoleintr+0xa0e>
801014cb:	fa                   	cli
    for(;;)
801014cc:	eb fe                	jmp    801014cc <consoleintr+0xa0c>
801014ce:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
801014d0:	83 c3 01             	add    $0x1,%ebx
801014d3:	e8 18 ef ff ff       	call   801003f0 <consputc.part.0>
801014d8:	eb d3                	jmp    801014ad <consoleintr+0x9ed>
          int new_cursor_off = (int)input.e - (int)input.w;
801014da:	8b 55 dc             	mov    -0x24(%ebp),%edx
          if (new_cursor_off < 0) 
801014dd:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
801014e2:	29 f2                	sub    %esi,%edx
          if (new_cursor_off < 0) 
801014e4:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++) 
801014e7:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
801014e9:	29 d7                	sub    %edx,%edi
          for (int i = 0; i < moves_left; i++) 
801014eb:	39 fb                	cmp    %edi,%ebx
801014ed:	0f 8d f0 f5 ff ff    	jge    80100ae3 <consoleintr+0x23>
  if(panicked){
801014f3:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
801014fa:	74 03                	je     801014ff <consoleintr+0xa3f>
801014fc:	fa                   	cli
    for(;;)
801014fd:	eb fe                	jmp    801014fd <consoleintr+0xa3d>
801014ff:	31 d2                	xor    %edx,%edx
80101501:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++) 
80101506:	83 c3 01             	add    $0x1,%ebx
80101509:	e8 e2 ee ff ff       	call   801003f0 <consputc.part.0>
8010150e:	eb db                	jmp    801014eb <consoleintr+0xa2b>

80101510 <consoleinit>:

void
consoleinit(void)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101516:	68 a8 7c 10 80       	push   $0x80107ca8
8010151b:	68 a0 01 11 80       	push   $0x801101a0
80101520:	e8 5b 39 00 00       	call   80104e80 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  ioapicenable(IRQ_KBD, 0);
80101525:	58                   	pop    %eax
80101526:	5a                   	pop    %edx
80101527:	6a 00                	push   $0x0
80101529:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010152b:	c7 05 8c 0b 11 80 60 	movl   $0x80100660,0x80110b8c
80101532:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101535:	c7 05 88 0b 11 80 80 	movl   $0x80100280,0x80110b88
8010153c:	02 10 80 
  cons.locking = 1;
8010153f:	c7 05 d4 01 11 80 01 	movl   $0x1,0x801101d4
80101546:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101549:	e8 e2 19 00 00       	call   80102f30 <ioapicenable>
  input.sel_a = input.sel_b = -1;
  input.clip_len = 0;
}
8010154e:	83 c4 10             	add    $0x10,%esp
  input.sel_a = input.sel_b = -1;
80101551:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80101558:	ff ff ff 
8010155b:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80101562:	ff ff ff 
  input.clip_len = 0;
80101565:	c7 05 9c 01 11 80 00 	movl   $0x0,0x8011019c
8010156c:	00 00 00 
}
8010156f:	c9                   	leave
80101570:	c3                   	ret
80101571:	66 90                	xchg   %ax,%ax
80101573:	66 90                	xchg   %ax,%ax
80101575:	66 90                	xchg   %ax,%ax
80101577:	66 90                	xchg   %ax,%ax
80101579:	66 90                	xchg   %ax,%ax
8010157b:	66 90                	xchg   %ax,%ax
8010157d:	66 90                	xchg   %ax,%ax
8010157f:	90                   	nop

80101580 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010158c:	e8 9f 2e 00 00       	call   80104430 <myproc>
80101591:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101597:	e8 74 22 00 00       	call   80103810 <begin_op>

  if((ip = namei(path)) == 0){
8010159c:	83 ec 0c             	sub    $0xc,%esp
8010159f:	ff 75 08             	push   0x8(%ebp)
801015a2:	e8 a9 15 00 00       	call   80102b50 <namei>
801015a7:	83 c4 10             	add    $0x10,%esp
801015aa:	85 c0                	test   %eax,%eax
801015ac:	0f 84 30 03 00 00    	je     801018e2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801015b2:	83 ec 0c             	sub    $0xc,%esp
801015b5:	89 c7                	mov    %eax,%edi
801015b7:	50                   	push   %eax
801015b8:	e8 b3 0c 00 00       	call   80102270 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801015bd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801015c3:	6a 34                	push   $0x34
801015c5:	6a 00                	push   $0x0
801015c7:	50                   	push   %eax
801015c8:	57                   	push   %edi
801015c9:	e8 b2 0f 00 00       	call   80102580 <readi>
801015ce:	83 c4 20             	add    $0x20,%esp
801015d1:	83 f8 34             	cmp    $0x34,%eax
801015d4:	0f 85 01 01 00 00    	jne    801016db <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801015da:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801015e1:	45 4c 46 
801015e4:	0f 85 f1 00 00 00    	jne    801016db <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801015ea:	e8 01 63 00 00       	call   801078f0 <setupkvm>
801015ef:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801015f5:	85 c0                	test   %eax,%eax
801015f7:	0f 84 de 00 00 00    	je     801016db <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801015fd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101604:	00 
80101605:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010160b:	0f 84 a1 02 00 00    	je     801018b2 <exec+0x332>
  sz = 0;
80101611:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101618:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010161b:	31 db                	xor    %ebx,%ebx
8010161d:	e9 8c 00 00 00       	jmp    801016ae <exec+0x12e>
80101622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101628:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010162f:	75 6c                	jne    8010169d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101631:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101637:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010163d:	0f 82 87 00 00 00    	jb     801016ca <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101643:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101649:	72 7f                	jb     801016ca <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010164b:	83 ec 04             	sub    $0x4,%esp
8010164e:	50                   	push   %eax
8010164f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101655:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010165b:	e8 c0 60 00 00       	call   80107720 <allocuvm>
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101669:	85 c0                	test   %eax,%eax
8010166b:	74 5d                	je     801016ca <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010166d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101673:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101678:	75 50                	jne    801016ca <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010167a:	83 ec 0c             	sub    $0xc,%esp
8010167d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101683:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101689:	57                   	push   %edi
8010168a:	50                   	push   %eax
8010168b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101691:	e8 ba 5f 00 00       	call   80107650 <loaduvm>
80101696:	83 c4 20             	add    $0x20,%esp
80101699:	85 c0                	test   %eax,%eax
8010169b:	78 2d                	js     801016ca <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010169d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801016a4:	83 c3 01             	add    $0x1,%ebx
801016a7:	83 c6 20             	add    $0x20,%esi
801016aa:	39 d8                	cmp    %ebx,%eax
801016ac:	7e 52                	jle    80101700 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801016ae:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801016b4:	6a 20                	push   $0x20
801016b6:	56                   	push   %esi
801016b7:	50                   	push   %eax
801016b8:	57                   	push   %edi
801016b9:	e8 c2 0e 00 00       	call   80102580 <readi>
801016be:	83 c4 10             	add    $0x10,%esp
801016c1:	83 f8 20             	cmp    $0x20,%eax
801016c4:	0f 84 5e ff ff ff    	je     80101628 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801016ca:	83 ec 0c             	sub    $0xc,%esp
801016cd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801016d3:	e8 98 61 00 00       	call   80107870 <freevm>
  if(ip){
801016d8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801016db:	83 ec 0c             	sub    $0xc,%esp
801016de:	57                   	push   %edi
801016df:	e8 1c 0e 00 00       	call   80102500 <iunlockput>
    end_op();
801016e4:	e8 97 21 00 00       	call   80103880 <end_op>
801016e9:	83 c4 10             	add    $0x10,%esp
    return -1;
801016ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
801016f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5f                   	pop    %edi
801016f7:	5d                   	pop    %ebp
801016f8:	c3                   	ret
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101700:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101706:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010170c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101712:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101718:	83 ec 0c             	sub    $0xc,%esp
8010171b:	57                   	push   %edi
8010171c:	e8 df 0d 00 00       	call   80102500 <iunlockput>
  end_op();
80101721:	e8 5a 21 00 00       	call   80103880 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101726:	83 c4 0c             	add    $0xc,%esp
80101729:	53                   	push   %ebx
8010172a:	56                   	push   %esi
8010172b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101731:	56                   	push   %esi
80101732:	e8 e9 5f 00 00       	call   80107720 <allocuvm>
80101737:	83 c4 10             	add    $0x10,%esp
8010173a:	89 c7                	mov    %eax,%edi
8010173c:	85 c0                	test   %eax,%eax
8010173e:	0f 84 86 00 00 00    	je     801017ca <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101744:	83 ec 08             	sub    $0x8,%esp
80101747:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010174d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010174f:	50                   	push   %eax
80101750:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101751:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101753:	e8 38 62 00 00       	call   80107990 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101758:	8b 45 0c             	mov    0xc(%ebp),%eax
8010175b:	83 c4 10             	add    $0x10,%esp
8010175e:	8b 10                	mov    (%eax),%edx
80101760:	85 d2                	test   %edx,%edx
80101762:	0f 84 56 01 00 00    	je     801018be <exec+0x33e>
80101768:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010176e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101771:	eb 23                	jmp    80101796 <exec+0x216>
80101773:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101778:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010177b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101782:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101788:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010178b:	85 d2                	test   %edx,%edx
8010178d:	74 51                	je     801017e0 <exec+0x260>
    if(argc >= MAXARG)
8010178f:	83 f8 20             	cmp    $0x20,%eax
80101792:	74 36                	je     801017ca <exec+0x24a>
80101794:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101796:	83 ec 0c             	sub    $0xc,%esp
80101799:	52                   	push   %edx
8010179a:	e8 c1 3b 00 00       	call   80105360 <strlen>
8010179f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801017a1:	58                   	pop    %eax
801017a2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801017a5:	83 eb 01             	sub    $0x1,%ebx
801017a8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801017ab:	e8 b0 3b 00 00       	call   80105360 <strlen>
801017b0:	83 c0 01             	add    $0x1,%eax
801017b3:	50                   	push   %eax
801017b4:	ff 34 b7             	push   (%edi,%esi,4)
801017b7:	53                   	push   %ebx
801017b8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801017be:	e8 9d 63 00 00       	call   80107b60 <copyout>
801017c3:	83 c4 20             	add    $0x20,%esp
801017c6:	85 c0                	test   %eax,%eax
801017c8:	79 ae                	jns    80101778 <exec+0x1f8>
    freevm(pgdir);
801017ca:	83 ec 0c             	sub    $0xc,%esp
801017cd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801017d3:	e8 98 60 00 00       	call   80107870 <freevm>
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	e9 0c ff ff ff       	jmp    801016ec <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801017e0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801017e7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801017ed:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801017f3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
801017f6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
801017f9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101800:	00 00 00 00 
  ustack[1] = argc;
80101804:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010180a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101811:	ff ff ff 
  ustack[1] = argc;
80101814:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010181a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010181c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010181e:	29 d0                	sub    %edx,%eax
80101820:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101826:	56                   	push   %esi
80101827:	51                   	push   %ecx
80101828:	53                   	push   %ebx
80101829:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010182f:	e8 2c 63 00 00       	call   80107b60 <copyout>
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	85 c0                	test   %eax,%eax
80101839:	78 8f                	js     801017ca <exec+0x24a>
  for(last=s=path; *s; s++)
8010183b:	8b 45 08             	mov    0x8(%ebp),%eax
8010183e:	8b 55 08             	mov    0x8(%ebp),%edx
80101841:	0f b6 00             	movzbl (%eax),%eax
80101844:	84 c0                	test   %al,%al
80101846:	74 17                	je     8010185f <exec+0x2df>
80101848:	89 d1                	mov    %edx,%ecx
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101850:	83 c1 01             	add    $0x1,%ecx
80101853:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101855:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101858:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010185b:	84 c0                	test   %al,%al
8010185d:	75 f1                	jne    80101850 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010185f:	83 ec 04             	sub    $0x4,%esp
80101862:	6a 10                	push   $0x10
80101864:	52                   	push   %edx
80101865:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010186b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010186e:	50                   	push   %eax
8010186f:	e8 ac 3a 00 00       	call   80105320 <safestrcpy>
  curproc->pgdir = pgdir;
80101874:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010187a:	89 f0                	mov    %esi,%eax
8010187c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010187f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80101881:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101884:	89 c1                	mov    %eax,%ecx
80101886:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010188c:	8b 40 18             	mov    0x18(%eax),%eax
8010188f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101892:	8b 41 18             	mov    0x18(%ecx),%eax
80101895:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101898:	89 0c 24             	mov    %ecx,(%esp)
8010189b:	e8 20 5c 00 00       	call   801074c0 <switchuvm>
  freevm(oldpgdir);
801018a0:	89 34 24             	mov    %esi,(%esp)
801018a3:	e8 c8 5f 00 00       	call   80107870 <freevm>
  return 0;
801018a8:	83 c4 10             	add    $0x10,%esp
801018ab:	31 c0                	xor    %eax,%eax
801018ad:	e9 3f fe ff ff       	jmp    801016f1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801018b2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801018b7:	31 f6                	xor    %esi,%esi
801018b9:	e9 5a fe ff ff       	jmp    80101718 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801018be:	be 10 00 00 00       	mov    $0x10,%esi
801018c3:	ba 04 00 00 00       	mov    $0x4,%edx
801018c8:	b8 03 00 00 00       	mov    $0x3,%eax
801018cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801018d4:	00 00 00 
801018d7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801018dd:	e9 17 ff ff ff       	jmp    801017f9 <exec+0x279>
    end_op();
801018e2:	e8 99 1f 00 00       	call   80103880 <end_op>
    cprintf("exec: fail\n");
801018e7:	83 ec 0c             	sub    $0xc,%esp
801018ea:	68 b0 7c 10 80       	push   $0x80107cb0
801018ef:	e8 bc ef ff ff       	call   801008b0 <cprintf>
    return -1;
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	e9 f0 fd ff ff       	jmp    801016ec <exec+0x16c>
801018fc:	66 90                	xchg   %ax,%ax
801018fe:	66 90                	xchg   %ax,%ax

80101900 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101906:	68 bc 7c 10 80       	push   $0x80107cbc
8010190b:	68 e0 01 11 80       	push   $0x801101e0
80101910:	e8 6b 35 00 00       	call   80104e80 <initlock>
}
80101915:	83 c4 10             	add    $0x10,%esp
80101918:	c9                   	leave
80101919:	c3                   	ret
8010191a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101920 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101924:	bb 14 02 11 80       	mov    $0x80110214,%ebx
{
80101929:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010192c:	68 e0 01 11 80       	push   $0x801101e0
80101931:	e8 3a 37 00 00       	call   80105070 <acquire>
80101936:	83 c4 10             	add    $0x10,%esp
80101939:	eb 10                	jmp    8010194b <filealloc+0x2b>
8010193b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101940:	83 c3 18             	add    $0x18,%ebx
80101943:	81 fb 74 0b 11 80    	cmp    $0x80110b74,%ebx
80101949:	74 25                	je     80101970 <filealloc+0x50>
    if(f->ref == 0){
8010194b:	8b 43 04             	mov    0x4(%ebx),%eax
8010194e:	85 c0                	test   %eax,%eax
80101950:	75 ee                	jne    80101940 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101952:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101955:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010195c:	68 e0 01 11 80       	push   $0x801101e0
80101961:	e8 aa 36 00 00       	call   80105010 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101966:	89 d8                	mov    %ebx,%eax
      return f;
80101968:	83 c4 10             	add    $0x10,%esp
}
8010196b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010196e:	c9                   	leave
8010196f:	c3                   	ret
  release(&ftable.lock);
80101970:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101973:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101975:	68 e0 01 11 80       	push   $0x801101e0
8010197a:	e8 91 36 00 00       	call   80105010 <release>
}
8010197f:	89 d8                	mov    %ebx,%eax
  return 0;
80101981:	83 c4 10             	add    $0x10,%esp
}
80101984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101987:	c9                   	leave
80101988:	c3                   	ret
80101989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101990 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	83 ec 10             	sub    $0x10,%esp
80101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010199a:	68 e0 01 11 80       	push   $0x801101e0
8010199f:	e8 cc 36 00 00       	call   80105070 <acquire>
  if(f->ref < 1)
801019a4:	8b 43 04             	mov    0x4(%ebx),%eax
801019a7:	83 c4 10             	add    $0x10,%esp
801019aa:	85 c0                	test   %eax,%eax
801019ac:	7e 1a                	jle    801019c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801019ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801019b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801019b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801019b7:	68 e0 01 11 80       	push   $0x801101e0
801019bc:	e8 4f 36 00 00       	call   80105010 <release>
  return f;
}
801019c1:	89 d8                	mov    %ebx,%eax
801019c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c6:	c9                   	leave
801019c7:	c3                   	ret
    panic("filedup");
801019c8:	83 ec 0c             	sub    $0xc,%esp
801019cb:	68 c3 7c 10 80       	push   $0x80107cc3
801019d0:	e8 9b e9 ff ff       	call   80100370 <panic>
801019d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019dc:	00 
801019dd:	8d 76 00             	lea    0x0(%esi),%esi

801019e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 28             	sub    $0x28,%esp
801019e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801019ec:	68 e0 01 11 80       	push   $0x801101e0
801019f1:	e8 7a 36 00 00       	call   80105070 <acquire>
  if(f->ref < 1)
801019f6:	8b 53 04             	mov    0x4(%ebx),%edx
801019f9:	83 c4 10             	add    $0x10,%esp
801019fc:	85 d2                	test   %edx,%edx
801019fe:	0f 8e a5 00 00 00    	jle    80101aa9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101a04:	83 ea 01             	sub    $0x1,%edx
80101a07:	89 53 04             	mov    %edx,0x4(%ebx)
80101a0a:	75 44                	jne    80101a50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101a0c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101a10:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101a13:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101a15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80101a1b:	8b 73 0c             	mov    0xc(%ebx),%esi
80101a1e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101a21:	8b 43 10             	mov    0x10(%ebx),%eax
80101a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101a27:	68 e0 01 11 80       	push   $0x801101e0
80101a2c:	e8 df 35 00 00       	call   80105010 <release>

  if(ff.type == FD_PIPE)
80101a31:	83 c4 10             	add    $0x10,%esp
80101a34:	83 ff 01             	cmp    $0x1,%edi
80101a37:	74 57                	je     80101a90 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101a39:	83 ff 02             	cmp    $0x2,%edi
80101a3c:	74 2a                	je     80101a68 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a41:	5b                   	pop    %ebx
80101a42:	5e                   	pop    %esi
80101a43:	5f                   	pop    %edi
80101a44:	5d                   	pop    %ebp
80101a45:	c3                   	ret
80101a46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a4d:	00 
80101a4e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101a50:	c7 45 08 e0 01 11 80 	movl   $0x801101e0,0x8(%ebp)
}
80101a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5a:	5b                   	pop    %ebx
80101a5b:	5e                   	pop    %esi
80101a5c:	5f                   	pop    %edi
80101a5d:	5d                   	pop    %ebp
    release(&ftable.lock);
80101a5e:	e9 ad 35 00 00       	jmp    80105010 <release>
80101a63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101a68:	e8 a3 1d 00 00       	call   80103810 <begin_op>
    iput(ff.ip);
80101a6d:	83 ec 0c             	sub    $0xc,%esp
80101a70:	ff 75 e0             	push   -0x20(%ebp)
80101a73:	e8 28 09 00 00       	call   801023a0 <iput>
    end_op();
80101a78:	83 c4 10             	add    $0x10,%esp
}
80101a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7e:	5b                   	pop    %ebx
80101a7f:	5e                   	pop    %esi
80101a80:	5f                   	pop    %edi
80101a81:	5d                   	pop    %ebp
    end_op();
80101a82:	e9 f9 1d 00 00       	jmp    80103880 <end_op>
80101a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a8e:	00 
80101a8f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101a90:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101a94:	83 ec 08             	sub    $0x8,%esp
80101a97:	53                   	push   %ebx
80101a98:	56                   	push   %esi
80101a99:	e8 32 25 00 00       	call   80103fd0 <pipeclose>
80101a9e:	83 c4 10             	add    $0x10,%esp
}
80101aa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa4:	5b                   	pop    %ebx
80101aa5:	5e                   	pop    %esi
80101aa6:	5f                   	pop    %edi
80101aa7:	5d                   	pop    %ebp
80101aa8:	c3                   	ret
    panic("fileclose");
80101aa9:	83 ec 0c             	sub    $0xc,%esp
80101aac:	68 cb 7c 10 80       	push   $0x80107ccb
80101ab1:	e8 ba e8 ff ff       	call   80100370 <panic>
80101ab6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101abd:	00 
80101abe:	66 90                	xchg   %ax,%ax

80101ac0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	53                   	push   %ebx
80101ac4:	83 ec 04             	sub    $0x4,%esp
80101ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80101aca:	83 3b 02             	cmpl   $0x2,(%ebx)
80101acd:	75 31                	jne    80101b00 <filestat+0x40>
    ilock(f->ip);
80101acf:	83 ec 0c             	sub    $0xc,%esp
80101ad2:	ff 73 10             	push   0x10(%ebx)
80101ad5:	e8 96 07 00 00       	call   80102270 <ilock>
    stati(f->ip, st);
80101ada:	58                   	pop    %eax
80101adb:	5a                   	pop    %edx
80101adc:	ff 75 0c             	push   0xc(%ebp)
80101adf:	ff 73 10             	push   0x10(%ebx)
80101ae2:	e8 69 0a 00 00       	call   80102550 <stati>
    iunlock(f->ip);
80101ae7:	59                   	pop    %ecx
80101ae8:	ff 73 10             	push   0x10(%ebx)
80101aeb:	e8 60 08 00 00       	call   80102350 <iunlock>
    return 0;
  }
  return -1;
}
80101af0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101af3:	83 c4 10             	add    $0x10,%esp
80101af6:	31 c0                	xor    %eax,%eax
}
80101af8:	c9                   	leave
80101af9:	c3                   	ret
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b08:	c9                   	leave
80101b09:	c3                   	ret
80101b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b10 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 0c             	sub    $0xc,%esp
80101b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101b22:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101b26:	74 60                	je     80101b88 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101b28:	8b 03                	mov    (%ebx),%eax
80101b2a:	83 f8 01             	cmp    $0x1,%eax
80101b2d:	74 41                	je     80101b70 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101b2f:	83 f8 02             	cmp    $0x2,%eax
80101b32:	75 5b                	jne    80101b8f <fileread+0x7f>
    ilock(f->ip);
80101b34:	83 ec 0c             	sub    $0xc,%esp
80101b37:	ff 73 10             	push   0x10(%ebx)
80101b3a:	e8 31 07 00 00       	call   80102270 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101b3f:	57                   	push   %edi
80101b40:	ff 73 14             	push   0x14(%ebx)
80101b43:	56                   	push   %esi
80101b44:	ff 73 10             	push   0x10(%ebx)
80101b47:	e8 34 0a 00 00       	call   80102580 <readi>
80101b4c:	83 c4 20             	add    $0x20,%esp
80101b4f:	89 c6                	mov    %eax,%esi
80101b51:	85 c0                	test   %eax,%eax
80101b53:	7e 03                	jle    80101b58 <fileread+0x48>
      f->off += r;
80101b55:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101b58:	83 ec 0c             	sub    $0xc,%esp
80101b5b:	ff 73 10             	push   0x10(%ebx)
80101b5e:	e8 ed 07 00 00       	call   80102350 <iunlock>
    return r;
80101b63:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101b66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b69:	89 f0                	mov    %esi,%eax
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
80101b6f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101b70:	8b 43 0c             	mov    0xc(%ebx),%eax
80101b73:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101b7d:	e9 0e 26 00 00       	jmp    80104190 <piperead>
80101b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101b88:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101b8d:	eb d7                	jmp    80101b66 <fileread+0x56>
  panic("fileread");
80101b8f:	83 ec 0c             	sub    $0xc,%esp
80101b92:	68 d5 7c 10 80       	push   $0x80107cd5
80101b97:	e8 d4 e7 ff ff       	call   80100370 <panic>
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ba0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bac:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101baf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101bb5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101bbc:	0f 84 bb 00 00 00    	je     80101c7d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101bc2:	8b 03                	mov    (%ebx),%eax
80101bc4:	83 f8 01             	cmp    $0x1,%eax
80101bc7:	0f 84 bf 00 00 00    	je     80101c8c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101bcd:	83 f8 02             	cmp    $0x2,%eax
80101bd0:	0f 85 c8 00 00 00    	jne    80101c9e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101bd9:	31 f6                	xor    %esi,%esi
    while(i < n){
80101bdb:	85 c0                	test   %eax,%eax
80101bdd:	7f 30                	jg     80101c0f <filewrite+0x6f>
80101bdf:	e9 94 00 00 00       	jmp    80101c78 <filewrite+0xd8>
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101be8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80101beb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
80101bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101bf1:	ff 73 10             	push   0x10(%ebx)
80101bf4:	e8 57 07 00 00       	call   80102350 <iunlock>
      end_op();
80101bf9:	e8 82 1c 00 00       	call   80103880 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c01:	83 c4 10             	add    $0x10,%esp
80101c04:	39 c7                	cmp    %eax,%edi
80101c06:	75 5c                	jne    80101c64 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101c08:	01 fe                	add    %edi,%esi
    while(i < n){
80101c0a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101c0d:	7e 69                	jle    80101c78 <filewrite+0xd8>
      int n1 = n - i;
80101c0f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101c12:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101c17:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101c19:	39 c7                	cmp    %eax,%edi
80101c1b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80101c1e:	e8 ed 1b 00 00       	call   80103810 <begin_op>
      ilock(f->ip);
80101c23:	83 ec 0c             	sub    $0xc,%esp
80101c26:	ff 73 10             	push   0x10(%ebx)
80101c29:	e8 42 06 00 00       	call   80102270 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101c2e:	57                   	push   %edi
80101c2f:	ff 73 14             	push   0x14(%ebx)
80101c32:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c35:	01 f0                	add    %esi,%eax
80101c37:	50                   	push   %eax
80101c38:	ff 73 10             	push   0x10(%ebx)
80101c3b:	e8 40 0a 00 00       	call   80102680 <writei>
80101c40:	83 c4 20             	add    $0x20,%esp
80101c43:	85 c0                	test   %eax,%eax
80101c45:	7f a1                	jg     80101be8 <filewrite+0x48>
80101c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101c4a:	83 ec 0c             	sub    $0xc,%esp
80101c4d:	ff 73 10             	push   0x10(%ebx)
80101c50:	e8 fb 06 00 00       	call   80102350 <iunlock>
      end_op();
80101c55:	e8 26 1c 00 00       	call   80103880 <end_op>
      if(r < 0)
80101c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101c5d:	83 c4 10             	add    $0x10,%esp
80101c60:	85 c0                	test   %eax,%eax
80101c62:	75 14                	jne    80101c78 <filewrite+0xd8>
        panic("short filewrite");
80101c64:	83 ec 0c             	sub    $0xc,%esp
80101c67:	68 de 7c 10 80       	push   $0x80107cde
80101c6c:	e8 ff e6 ff ff       	call   80100370 <panic>
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101c78:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101c7b:	74 05                	je     80101c82 <filewrite+0xe2>
80101c7d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c85:	89 f0                	mov    %esi,%eax
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80101c8c:	8b 43 0c             	mov    0xc(%ebx),%eax
80101c8f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c95:	5b                   	pop    %ebx
80101c96:	5e                   	pop    %esi
80101c97:	5f                   	pop    %edi
80101c98:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101c99:	e9 d2 23 00 00       	jmp    80104070 <pipewrite>
  panic("filewrite");
80101c9e:	83 ec 0c             	sub    $0xc,%esp
80101ca1:	68 e4 7c 10 80       	push   $0x80107ce4
80101ca6:	e8 c5 e6 ff ff       	call   80100370 <panic>
80101cab:	66 90                	xchg   %ax,%ax
80101cad:	66 90                	xchg   %ax,%ax
80101caf:	90                   	nop

80101cb0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	53                   	push   %ebx
80101cb6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101cb9:	8b 0d 34 28 11 80    	mov    0x80112834,%ecx
{
80101cbf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101cc2:	85 c9                	test   %ecx,%ecx
80101cc4:	0f 84 8c 00 00 00    	je     80101d56 <balloc+0xa6>
80101cca:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
80101ccc:	89 f8                	mov    %edi,%eax
80101cce:	83 ec 08             	sub    $0x8,%esp
80101cd1:	89 fe                	mov    %edi,%esi
80101cd3:	c1 f8 0c             	sar    $0xc,%eax
80101cd6:	03 05 4c 28 11 80    	add    0x8011284c,%eax
80101cdc:	50                   	push   %eax
80101cdd:	ff 75 dc             	push   -0x24(%ebp)
80101ce0:	e8 eb e3 ff ff       	call   801000d0 <bread>
80101ce5:	83 c4 10             	add    $0x10,%esp
80101ce8:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101ceb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101cee:	a1 34 28 11 80       	mov    0x80112834,%eax
80101cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101cf6:	31 c0                	xor    %eax,%eax
80101cf8:	eb 32                	jmp    80101d2c <balloc+0x7c>
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101d00:	89 c1                	mov    %eax,%ecx
80101d02:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101d07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
80101d0a:	83 e1 07             	and    $0x7,%ecx
80101d0d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101d0f:	89 c1                	mov    %eax,%ecx
80101d11:	c1 f9 03             	sar    $0x3,%ecx
80101d14:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101d19:	89 fa                	mov    %edi,%edx
80101d1b:	85 df                	test   %ebx,%edi
80101d1d:	74 49                	je     80101d68 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101d1f:	83 c0 01             	add    $0x1,%eax
80101d22:	83 c6 01             	add    $0x1,%esi
80101d25:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101d2a:	74 07                	je     80101d33 <balloc+0x83>
80101d2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2f:	39 d6                	cmp    %edx,%esi
80101d31:	72 cd                	jb     80101d00 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101d33:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d36:	83 ec 0c             	sub    $0xc,%esp
80101d39:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101d3c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101d42:	e8 a9 e4 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101d47:	83 c4 10             	add    $0x10,%esp
80101d4a:	3b 3d 34 28 11 80    	cmp    0x80112834,%edi
80101d50:	0f 82 76 ff ff ff    	jb     80101ccc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101d56:	83 ec 0c             	sub    $0xc,%esp
80101d59:	68 ee 7c 10 80       	push   $0x80107cee
80101d5e:	e8 0d e6 ff ff       	call   80100370 <panic>
80101d63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101d68:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101d6b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101d6e:	09 da                	or     %ebx,%edx
80101d70:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101d74:	57                   	push   %edi
80101d75:	e8 76 1c 00 00       	call   801039f0 <log_write>
        brelse(bp);
80101d7a:	89 3c 24             	mov    %edi,(%esp)
80101d7d:	e8 6e e4 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101d82:	58                   	pop    %eax
80101d83:	5a                   	pop    %edx
80101d84:	56                   	push   %esi
80101d85:	ff 75 dc             	push   -0x24(%ebp)
80101d88:	e8 43 e3 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101d8d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101d90:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101d92:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d95:	68 00 02 00 00       	push   $0x200
80101d9a:	6a 00                	push   $0x0
80101d9c:	50                   	push   %eax
80101d9d:	e8 ce 33 00 00       	call   80105170 <memset>
  log_write(bp);
80101da2:	89 1c 24             	mov    %ebx,(%esp)
80101da5:	e8 46 1c 00 00       	call   801039f0 <log_write>
  brelse(bp);
80101daa:	89 1c 24             	mov    %ebx,(%esp)
80101dad:	e8 3e e4 ff ff       	call   801001f0 <brelse>
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db5:	89 f0                	mov    %esi,%eax
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101dc4:	31 ff                	xor    %edi,%edi
{
80101dc6:	56                   	push   %esi
80101dc7:	89 c6                	mov    %eax,%esi
80101dc9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101dca:	bb 14 0c 11 80       	mov    $0x80110c14,%ebx
{
80101dcf:	83 ec 28             	sub    $0x28,%esp
80101dd2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101dd5:	68 e0 0b 11 80       	push   $0x80110be0
80101dda:	e8 91 32 00 00       	call   80105070 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ddf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101de2:	83 c4 10             	add    $0x10,%esp
80101de5:	eb 1b                	jmp    80101e02 <iget+0x42>
80101de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dee:	00 
80101def:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101df0:	39 33                	cmp    %esi,(%ebx)
80101df2:	74 6c                	je     80101e60 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101df4:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101dfa:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
80101e00:	74 26                	je     80101e28 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101e02:	8b 43 08             	mov    0x8(%ebx),%eax
80101e05:	85 c0                	test   %eax,%eax
80101e07:	7f e7                	jg     80101df0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101e09:	85 ff                	test   %edi,%edi
80101e0b:	75 e7                	jne    80101df4 <iget+0x34>
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	75 76                	jne    80101e87 <iget+0xc7>
      empty = ip;
80101e11:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101e13:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101e19:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
80101e1f:	75 e1                	jne    80101e02 <iget+0x42>
80101e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101e28:	85 ff                	test   %edi,%edi
80101e2a:	74 79                	je     80101ea5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101e2c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101e2f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101e31:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101e34:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101e3b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101e42:	68 e0 0b 11 80       	push   $0x80110be0
80101e47:	e8 c4 31 00 00       	call   80105010 <release>

  return ip;
80101e4c:	83 c4 10             	add    $0x10,%esp
}
80101e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e52:	89 f8                	mov    %edi,%eax
80101e54:	5b                   	pop    %ebx
80101e55:	5e                   	pop    %esi
80101e56:	5f                   	pop    %edi
80101e57:	5d                   	pop    %ebp
80101e58:	c3                   	ret
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101e60:	39 53 04             	cmp    %edx,0x4(%ebx)
80101e63:	75 8f                	jne    80101df4 <iget+0x34>
      ip->ref++;
80101e65:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101e68:	83 ec 0c             	sub    $0xc,%esp
      return ip;
80101e6b:	89 df                	mov    %ebx,%edi
      ip->ref++;
80101e6d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101e70:	68 e0 0b 11 80       	push   $0x80110be0
80101e75:	e8 96 31 00 00       	call   80105010 <release>
      return ip;
80101e7a:	83 c4 10             	add    $0x10,%esp
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	89 f8                	mov    %edi,%eax
80101e82:	5b                   	pop    %ebx
80101e83:	5e                   	pop    %esi
80101e84:	5f                   	pop    %edi
80101e85:	5d                   	pop    %ebp
80101e86:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101e87:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101e8d:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
80101e93:	74 10                	je     80101ea5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101e95:	8b 43 08             	mov    0x8(%ebx),%eax
80101e98:	85 c0                	test   %eax,%eax
80101e9a:	0f 8f 50 ff ff ff    	jg     80101df0 <iget+0x30>
80101ea0:	e9 68 ff ff ff       	jmp    80101e0d <iget+0x4d>
    panic("iget: no inodes");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 04 7d 10 80       	push   $0x80107d04
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101eb9:	00 
80101eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ec0 <bfree>:
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101ec3:	89 d0                	mov    %edx,%eax
80101ec5:	c1 e8 0c             	shr    $0xc,%eax
{
80101ec8:	89 e5                	mov    %esp,%ebp
80101eca:	56                   	push   %esi
80101ecb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
80101ecc:	03 05 4c 28 11 80    	add    0x8011284c,%eax
{
80101ed2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101ed4:	83 ec 08             	sub    $0x8,%esp
80101ed7:	50                   	push   %eax
80101ed8:	51                   	push   %ecx
80101ed9:	e8 f2 e1 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101ede:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101ee0:	c1 fb 03             	sar    $0x3,%ebx
80101ee3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101ee6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101ee8:	83 e1 07             	and    $0x7,%ecx
80101eeb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101ef0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101ef6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101ef8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101efd:	85 c1                	test   %eax,%ecx
80101eff:	74 23                	je     80101f24 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101f01:	f7 d0                	not    %eax
  log_write(bp);
80101f03:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101f06:	21 c8                	and    %ecx,%eax
80101f08:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101f0c:	56                   	push   %esi
80101f0d:	e8 de 1a 00 00       	call   801039f0 <log_write>
  brelse(bp);
80101f12:	89 34 24             	mov    %esi,(%esp)
80101f15:	e8 d6 e2 ff ff       	call   801001f0 <brelse>
}
80101f1a:	83 c4 10             	add    $0x10,%esp
80101f1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5d                   	pop    %ebp
80101f23:	c3                   	ret
    panic("freeing free block");
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	68 14 7d 10 80       	push   $0x80107d14
80101f2c:	e8 3f e4 ff ff       	call   80100370 <panic>
80101f31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f38:	00 
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f40 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	57                   	push   %edi
80101f44:	56                   	push   %esi
80101f45:	89 c6                	mov    %eax,%esi
80101f47:	53                   	push   %ebx
80101f48:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101f4b:	83 fa 0b             	cmp    $0xb,%edx
80101f4e:	0f 86 8c 00 00 00    	jbe    80101fe0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101f54:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101f57:	83 fb 7f             	cmp    $0x7f,%ebx
80101f5a:	0f 87 a2 00 00 00    	ja     80102002 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101f60:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101f66:	85 c0                	test   %eax,%eax
80101f68:	74 5e                	je     80101fc8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101f6a:	83 ec 08             	sub    $0x8,%esp
80101f6d:	50                   	push   %eax
80101f6e:	ff 36                	push   (%esi)
80101f70:	e8 5b e1 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101f75:	83 c4 10             	add    $0x10,%esp
80101f78:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101f7c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101f7e:	8b 3b                	mov    (%ebx),%edi
80101f80:	85 ff                	test   %edi,%edi
80101f82:	74 1c                	je     80101fa0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101f84:	83 ec 0c             	sub    $0xc,%esp
80101f87:	52                   	push   %edx
80101f88:	e8 63 e2 ff ff       	call   801001f0 <brelse>
80101f8d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f93:	89 f8                	mov    %edi,%eax
80101f95:	5b                   	pop    %ebx
80101f96:	5e                   	pop    %esi
80101f97:	5f                   	pop    %edi
80101f98:	5d                   	pop    %ebp
80101f99:	c3                   	ret
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101fa3:	8b 06                	mov    (%esi),%eax
80101fa5:	e8 06 fd ff ff       	call   80101cb0 <balloc>
      log_write(bp);
80101faa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101fb0:	89 03                	mov    %eax,(%ebx)
80101fb2:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101fb4:	52                   	push   %edx
80101fb5:	e8 36 1a 00 00       	call   801039f0 <log_write>
80101fba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fbd:	83 c4 10             	add    $0x10,%esp
80101fc0:	eb c2                	jmp    80101f84 <bmap+0x44>
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101fc8:	8b 06                	mov    (%esi),%eax
80101fca:	e8 e1 fc ff ff       	call   80101cb0 <balloc>
80101fcf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101fd5:	eb 93                	jmp    80101f6a <bmap+0x2a>
80101fd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fde:	00 
80101fdf:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101fe0:	8d 5a 14             	lea    0x14(%edx),%ebx
80101fe3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101fe7:	85 ff                	test   %edi,%edi
80101fe9:	75 a5                	jne    80101f90 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101feb:	8b 00                	mov    (%eax),%eax
80101fed:	e8 be fc ff ff       	call   80101cb0 <balloc>
80101ff2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101ff6:	89 c7                	mov    %eax,%edi
}
80101ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	89 f8                	mov    %edi,%eax
80101ffe:	5e                   	pop    %esi
80101fff:	5f                   	pop    %edi
80102000:	5d                   	pop    %ebp
80102001:	c3                   	ret
  panic("bmap: out of range");
80102002:	83 ec 0c             	sub    $0xc,%esp
80102005:	68 27 7d 10 80       	push   $0x80107d27
8010200a:	e8 61 e3 ff ff       	call   80100370 <panic>
8010200f:	90                   	nop

80102010 <readsb>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	56                   	push   %esi
80102014:	53                   	push   %ebx
80102015:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102018:	83 ec 08             	sub    $0x8,%esp
8010201b:	6a 01                	push   $0x1
8010201d:	ff 75 08             	push   0x8(%ebp)
80102020:	e8 ab e0 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102025:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102028:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010202a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010202d:	6a 1c                	push   $0x1c
8010202f:	50                   	push   %eax
80102030:	56                   	push   %esi
80102031:	e8 ca 31 00 00       	call   80105200 <memmove>
  brelse(bp);
80102036:	83 c4 10             	add    $0x10,%esp
80102039:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010203c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010203f:	5b                   	pop    %ebx
80102040:	5e                   	pop    %esi
80102041:	5d                   	pop    %ebp
  brelse(bp);
80102042:	e9 a9 e1 ff ff       	jmp    801001f0 <brelse>
80102047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010204e:	00 
8010204f:	90                   	nop

80102050 <iinit>:
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	53                   	push   %ebx
80102054:	bb 20 0c 11 80       	mov    $0x80110c20,%ebx
80102059:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010205c:	68 3a 7d 10 80       	push   $0x80107d3a
80102061:	68 e0 0b 11 80       	push   $0x80110be0
80102066:	e8 15 2e 00 00       	call   80104e80 <initlock>
  for(i = 0; i < NINODE; i++) {
8010206b:	83 c4 10             	add    $0x10,%esp
8010206e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102070:	83 ec 08             	sub    $0x8,%esp
80102073:	68 41 7d 10 80       	push   $0x80107d41
80102078:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102079:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010207f:	e8 cc 2c 00 00       	call   80104d50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102084:	83 c4 10             	add    $0x10,%esp
80102087:	81 fb 40 28 11 80    	cmp    $0x80112840,%ebx
8010208d:	75 e1                	jne    80102070 <iinit+0x20>
  bp = bread(dev, 1);
8010208f:	83 ec 08             	sub    $0x8,%esp
80102092:	6a 01                	push   $0x1
80102094:	ff 75 08             	push   0x8(%ebp)
80102097:	e8 34 e0 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010209c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010209f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801020a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801020a4:	6a 1c                	push   $0x1c
801020a6:	50                   	push   %eax
801020a7:	68 34 28 11 80       	push   $0x80112834
801020ac:	e8 4f 31 00 00       	call   80105200 <memmove>
  brelse(bp);
801020b1:	89 1c 24             	mov    %ebx,(%esp)
801020b4:	e8 37 e1 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801020b9:	ff 35 4c 28 11 80    	push   0x8011284c
801020bf:	ff 35 48 28 11 80    	push   0x80112848
801020c5:	ff 35 44 28 11 80    	push   0x80112844
801020cb:	ff 35 40 28 11 80    	push   0x80112840
801020d1:	ff 35 3c 28 11 80    	push   0x8011283c
801020d7:	ff 35 38 28 11 80    	push   0x80112838
801020dd:	ff 35 34 28 11 80    	push   0x80112834
801020e3:	68 c0 81 10 80       	push   $0x801081c0
801020e8:	e8 c3 e7 ff ff       	call   801008b0 <cprintf>
}
801020ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020f0:	83 c4 30             	add    $0x30,%esp
801020f3:	c9                   	leave
801020f4:	c3                   	ret
801020f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020fc:	00 
801020fd:	8d 76 00             	lea    0x0(%esi),%esi

80102100 <ialloc>:
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	57                   	push   %edi
80102104:	56                   	push   %esi
80102105:	53                   	push   %ebx
80102106:	83 ec 1c             	sub    $0x1c,%esp
80102109:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010210c:	83 3d 3c 28 11 80 01 	cmpl   $0x1,0x8011283c
{
80102113:	8b 75 08             	mov    0x8(%ebp),%esi
80102116:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102119:	0f 86 91 00 00 00    	jbe    801021b0 <ialloc+0xb0>
8010211f:	bf 01 00 00 00       	mov    $0x1,%edi
80102124:	eb 21                	jmp    80102147 <ialloc+0x47>
80102126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010212d:	00 
8010212e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80102130:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102133:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102136:	53                   	push   %ebx
80102137:	e8 b4 e0 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010213c:	83 c4 10             	add    $0x10,%esp
8010213f:	3b 3d 3c 28 11 80    	cmp    0x8011283c,%edi
80102145:	73 69                	jae    801021b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102147:	89 f8                	mov    %edi,%eax
80102149:	83 ec 08             	sub    $0x8,%esp
8010214c:	c1 e8 03             	shr    $0x3,%eax
8010214f:	03 05 48 28 11 80    	add    0x80112848,%eax
80102155:	50                   	push   %eax
80102156:	56                   	push   %esi
80102157:	e8 74 df ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010215c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010215f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102161:	89 f8                	mov    %edi,%eax
80102163:	83 e0 07             	and    $0x7,%eax
80102166:	c1 e0 06             	shl    $0x6,%eax
80102169:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010216d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102171:	75 bd                	jne    80102130 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102173:	83 ec 04             	sub    $0x4,%esp
80102176:	6a 40                	push   $0x40
80102178:	6a 00                	push   $0x0
8010217a:	51                   	push   %ecx
8010217b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010217e:	e8 ed 2f 00 00       	call   80105170 <memset>
      dip->type = type;
80102183:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102187:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010218a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010218d:	89 1c 24             	mov    %ebx,(%esp)
80102190:	e8 5b 18 00 00       	call   801039f0 <log_write>
      brelse(bp);
80102195:	89 1c 24             	mov    %ebx,(%esp)
80102198:	e8 53 e0 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010219d:	83 c4 10             	add    $0x10,%esp
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801021a3:	89 fa                	mov    %edi,%edx
}
801021a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801021a6:	89 f0                	mov    %esi,%eax
}
801021a8:	5e                   	pop    %esi
801021a9:	5f                   	pop    %edi
801021aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801021ab:	e9 10 fc ff ff       	jmp    80101dc0 <iget>
  panic("ialloc: no inodes");
801021b0:	83 ec 0c             	sub    $0xc,%esp
801021b3:	68 47 7d 10 80       	push   $0x80107d47
801021b8:	e8 b3 e1 ff ff       	call   80100370 <panic>
801021bd:	8d 76 00             	lea    0x0(%esi),%esi

801021c0 <iupdate>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx
801021c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801021c8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801021cb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801021ce:	83 ec 08             	sub    $0x8,%esp
801021d1:	c1 e8 03             	shr    $0x3,%eax
801021d4:	03 05 48 28 11 80    	add    0x80112848,%eax
801021da:	50                   	push   %eax
801021db:	ff 73 a4             	push   -0x5c(%ebx)
801021de:	e8 ed de ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801021e3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801021e7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801021ea:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801021ec:	8b 43 a8             	mov    -0x58(%ebx),%eax
801021ef:	83 e0 07             	and    $0x7,%eax
801021f2:	c1 e0 06             	shl    $0x6,%eax
801021f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801021f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801021fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102200:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102203:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102207:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010220b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010220f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102213:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102217:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010221a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010221d:	6a 34                	push   $0x34
8010221f:	53                   	push   %ebx
80102220:	50                   	push   %eax
80102221:	e8 da 2f 00 00       	call   80105200 <memmove>
  log_write(bp);
80102226:	89 34 24             	mov    %esi,(%esp)
80102229:	e8 c2 17 00 00       	call   801039f0 <log_write>
  brelse(bp);
8010222e:	83 c4 10             	add    $0x10,%esp
80102231:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102234:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102237:	5b                   	pop    %ebx
80102238:	5e                   	pop    %esi
80102239:	5d                   	pop    %ebp
  brelse(bp);
8010223a:	e9 b1 df ff ff       	jmp    801001f0 <brelse>
8010223f:	90                   	nop

80102240 <idup>:
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	53                   	push   %ebx
80102244:	83 ec 10             	sub    $0x10,%esp
80102247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010224a:	68 e0 0b 11 80       	push   $0x80110be0
8010224f:	e8 1c 2e 00 00       	call   80105070 <acquire>
  ip->ref++;
80102254:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102258:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
8010225f:	e8 ac 2d 00 00       	call   80105010 <release>
}
80102264:	89 d8                	mov    %ebx,%eax
80102266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102269:	c9                   	leave
8010226a:	c3                   	ret
8010226b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102270 <ilock>:
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	56                   	push   %esi
80102274:	53                   	push   %ebx
80102275:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102278:	85 db                	test   %ebx,%ebx
8010227a:	0f 84 b7 00 00 00    	je     80102337 <ilock+0xc7>
80102280:	8b 53 08             	mov    0x8(%ebx),%edx
80102283:	85 d2                	test   %edx,%edx
80102285:	0f 8e ac 00 00 00    	jle    80102337 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010228b:	83 ec 0c             	sub    $0xc,%esp
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 f9 2a 00 00       	call   80104d90 <acquiresleep>
  if(ip->valid == 0){
80102297:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	85 c0                	test   %eax,%eax
8010229f:	74 0f                	je     801022b0 <ilock+0x40>
}
801022a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022a4:	5b                   	pop    %ebx
801022a5:	5e                   	pop    %esi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret
801022a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022af:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801022b0:	8b 43 04             	mov    0x4(%ebx),%eax
801022b3:	83 ec 08             	sub    $0x8,%esp
801022b6:	c1 e8 03             	shr    $0x3,%eax
801022b9:	03 05 48 28 11 80    	add    0x80112848,%eax
801022bf:	50                   	push   %eax
801022c0:	ff 33                	push   (%ebx)
801022c2:	e8 09 de ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801022c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801022ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801022cc:	8b 43 04             	mov    0x4(%ebx),%eax
801022cf:	83 e0 07             	and    $0x7,%eax
801022d2:	c1 e0 06             	shl    $0x6,%eax
801022d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801022d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801022dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801022df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801022e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801022e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801022eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801022ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801022f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801022f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801022fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801022fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102301:	6a 34                	push   $0x34
80102303:	50                   	push   %eax
80102304:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102307:	50                   	push   %eax
80102308:	e8 f3 2e 00 00       	call   80105200 <memmove>
    brelse(bp);
8010230d:	89 34 24             	mov    %esi,(%esp)
80102310:	e8 db de ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102315:	83 c4 10             	add    $0x10,%esp
80102318:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010231d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102324:	0f 85 77 ff ff ff    	jne    801022a1 <ilock+0x31>
      panic("ilock: no type");
8010232a:	83 ec 0c             	sub    $0xc,%esp
8010232d:	68 5f 7d 10 80       	push   $0x80107d5f
80102332:	e8 39 e0 ff ff       	call   80100370 <panic>
    panic("ilock");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 59 7d 10 80       	push   $0x80107d59
8010233f:	e8 2c e0 ff ff       	call   80100370 <panic>
80102344:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010234b:	00 
8010234c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102350 <iunlock>:
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx
80102355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102358:	85 db                	test   %ebx,%ebx
8010235a:	74 28                	je     80102384 <iunlock+0x34>
8010235c:	83 ec 0c             	sub    $0xc,%esp
8010235f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102362:	56                   	push   %esi
80102363:	e8 c8 2a 00 00       	call   80104e30 <holdingsleep>
80102368:	83 c4 10             	add    $0x10,%esp
8010236b:	85 c0                	test   %eax,%eax
8010236d:	74 15                	je     80102384 <iunlock+0x34>
8010236f:	8b 43 08             	mov    0x8(%ebx),%eax
80102372:	85 c0                	test   %eax,%eax
80102374:	7e 0e                	jle    80102384 <iunlock+0x34>
  releasesleep(&ip->lock);
80102376:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102379:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010237c:	5b                   	pop    %ebx
8010237d:	5e                   	pop    %esi
8010237e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010237f:	e9 6c 2a 00 00       	jmp    80104df0 <releasesleep>
    panic("iunlock");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 6e 7d 10 80       	push   $0x80107d6e
8010238c:	e8 df df ff ff       	call   80100370 <panic>
80102391:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102398:	00 
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023a0 <iput>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	57                   	push   %edi
801023a4:	56                   	push   %esi
801023a5:	53                   	push   %ebx
801023a6:	83 ec 28             	sub    $0x28,%esp
801023a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801023ac:	8d 7b 0c             	lea    0xc(%ebx),%edi
801023af:	57                   	push   %edi
801023b0:	e8 db 29 00 00       	call   80104d90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801023b5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801023b8:	83 c4 10             	add    $0x10,%esp
801023bb:	85 d2                	test   %edx,%edx
801023bd:	74 07                	je     801023c6 <iput+0x26>
801023bf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801023c4:	74 32                	je     801023f8 <iput+0x58>
  releasesleep(&ip->lock);
801023c6:	83 ec 0c             	sub    $0xc,%esp
801023c9:	57                   	push   %edi
801023ca:	e8 21 2a 00 00       	call   80104df0 <releasesleep>
  acquire(&icache.lock);
801023cf:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
801023d6:	e8 95 2c 00 00       	call   80105070 <acquire>
  ip->ref--;
801023db:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801023df:	83 c4 10             	add    $0x10,%esp
801023e2:	c7 45 08 e0 0b 11 80 	movl   $0x80110be0,0x8(%ebp)
}
801023e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ec:	5b                   	pop    %ebx
801023ed:	5e                   	pop    %esi
801023ee:	5f                   	pop    %edi
801023ef:	5d                   	pop    %ebp
  release(&icache.lock);
801023f0:	e9 1b 2c 00 00       	jmp    80105010 <release>
801023f5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801023f8:	83 ec 0c             	sub    $0xc,%esp
801023fb:	68 e0 0b 11 80       	push   $0x80110be0
80102400:	e8 6b 2c 00 00       	call   80105070 <acquire>
    int r = ip->ref;
80102405:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102408:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
8010240f:	e8 fc 2b 00 00       	call   80105010 <release>
    if(r == 1){
80102414:	83 c4 10             	add    $0x10,%esp
80102417:	83 fe 01             	cmp    $0x1,%esi
8010241a:	75 aa                	jne    801023c6 <iput+0x26>
8010241c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102422:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102425:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102428:	89 df                	mov    %ebx,%edi
8010242a:	89 cb                	mov    %ecx,%ebx
8010242c:	eb 09                	jmp    80102437 <iput+0x97>
8010242e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102430:	83 c6 04             	add    $0x4,%esi
80102433:	39 de                	cmp    %ebx,%esi
80102435:	74 19                	je     80102450 <iput+0xb0>
    if(ip->addrs[i]){
80102437:	8b 16                	mov    (%esi),%edx
80102439:	85 d2                	test   %edx,%edx
8010243b:	74 f3                	je     80102430 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010243d:	8b 07                	mov    (%edi),%eax
8010243f:	e8 7c fa ff ff       	call   80101ec0 <bfree>
      ip->addrs[i] = 0;
80102444:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010244a:	eb e4                	jmp    80102430 <iput+0x90>
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102450:	89 fb                	mov    %edi,%ebx
80102452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102455:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010245b:	85 c0                	test   %eax,%eax
8010245d:	75 2d                	jne    8010248c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010245f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102462:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102469:	53                   	push   %ebx
8010246a:	e8 51 fd ff ff       	call   801021c0 <iupdate>
      ip->type = 0;
8010246f:	31 c0                	xor    %eax,%eax
80102471:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102475:	89 1c 24             	mov    %ebx,(%esp)
80102478:	e8 43 fd ff ff       	call   801021c0 <iupdate>
      ip->valid = 0;
8010247d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102484:	83 c4 10             	add    $0x10,%esp
80102487:	e9 3a ff ff ff       	jmp    801023c6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010248c:	83 ec 08             	sub    $0x8,%esp
8010248f:	50                   	push   %eax
80102490:	ff 33                	push   (%ebx)
80102492:	e8 39 dc ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80102497:	83 c4 10             	add    $0x10,%esp
8010249a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010249d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801024a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801024a6:	8d 70 5c             	lea    0x5c(%eax),%esi
801024a9:	89 cf                	mov    %ecx,%edi
801024ab:	eb 0a                	jmp    801024b7 <iput+0x117>
801024ad:	8d 76 00             	lea    0x0(%esi),%esi
801024b0:	83 c6 04             	add    $0x4,%esi
801024b3:	39 fe                	cmp    %edi,%esi
801024b5:	74 0f                	je     801024c6 <iput+0x126>
      if(a[j])
801024b7:	8b 16                	mov    (%esi),%edx
801024b9:	85 d2                	test   %edx,%edx
801024bb:	74 f3                	je     801024b0 <iput+0x110>
        bfree(ip->dev, a[j]);
801024bd:	8b 03                	mov    (%ebx),%eax
801024bf:	e8 fc f9 ff ff       	call   80101ec0 <bfree>
801024c4:	eb ea                	jmp    801024b0 <iput+0x110>
    brelse(bp);
801024c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801024c9:	83 ec 0c             	sub    $0xc,%esp
801024cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801024cf:	50                   	push   %eax
801024d0:	e8 1b dd ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801024d5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801024db:	8b 03                	mov    (%ebx),%eax
801024dd:	e8 de f9 ff ff       	call   80101ec0 <bfree>
    ip->addrs[NDIRECT] = 0;
801024e2:	83 c4 10             	add    $0x10,%esp
801024e5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801024ec:	00 00 00 
801024ef:	e9 6b ff ff ff       	jmp    8010245f <iput+0xbf>
801024f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024fb:	00 
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102500 <iunlockput>:
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx
80102505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102508:	85 db                	test   %ebx,%ebx
8010250a:	74 34                	je     80102540 <iunlockput+0x40>
8010250c:	83 ec 0c             	sub    $0xc,%esp
8010250f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102512:	56                   	push   %esi
80102513:	e8 18 29 00 00       	call   80104e30 <holdingsleep>
80102518:	83 c4 10             	add    $0x10,%esp
8010251b:	85 c0                	test   %eax,%eax
8010251d:	74 21                	je     80102540 <iunlockput+0x40>
8010251f:	8b 43 08             	mov    0x8(%ebx),%eax
80102522:	85 c0                	test   %eax,%eax
80102524:	7e 1a                	jle    80102540 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	56                   	push   %esi
8010252a:	e8 c1 28 00 00       	call   80104df0 <releasesleep>
  iput(ip);
8010252f:	83 c4 10             	add    $0x10,%esp
80102532:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102535:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102538:	5b                   	pop    %ebx
80102539:	5e                   	pop    %esi
8010253a:	5d                   	pop    %ebp
  iput(ip);
8010253b:	e9 60 fe ff ff       	jmp    801023a0 <iput>
    panic("iunlock");
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 6e 7d 10 80       	push   $0x80107d6e
80102548:	e8 23 de ff ff       	call   80100370 <panic>
8010254d:	8d 76 00             	lea    0x0(%esi),%esi

80102550 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	8b 55 08             	mov    0x8(%ebp),%edx
80102556:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102559:	8b 0a                	mov    (%edx),%ecx
8010255b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010255e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102561:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102564:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102568:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010256b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010256f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102573:	8b 52 58             	mov    0x58(%edx),%edx
80102576:	89 50 10             	mov    %edx,0x10(%eax)
}
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret
8010257b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102580 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	57                   	push   %edi
80102584:	56                   	push   %esi
80102585:	53                   	push   %ebx
80102586:	83 ec 1c             	sub    $0x1c,%esp
80102589:	8b 75 08             	mov    0x8(%ebp),%esi
8010258c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010258f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102592:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80102597:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010259a:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010259d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
801025a0:	0f 84 aa 00 00 00    	je     80102650 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801025a6:	8b 75 d8             	mov    -0x28(%ebp),%esi
801025a9:	8b 56 58             	mov    0x58(%esi),%edx
801025ac:	39 fa                	cmp    %edi,%edx
801025ae:	0f 82 bd 00 00 00    	jb     80102671 <readi+0xf1>
801025b4:	89 f9                	mov    %edi,%ecx
801025b6:	31 db                	xor    %ebx,%ebx
801025b8:	01 c1                	add    %eax,%ecx
801025ba:	0f 92 c3             	setb   %bl
801025bd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801025c0:	0f 82 ab 00 00 00    	jb     80102671 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801025c6:	89 d3                	mov    %edx,%ebx
801025c8:	29 fb                	sub    %edi,%ebx
801025ca:	39 ca                	cmp    %ecx,%edx
801025cc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801025cf:	85 c0                	test   %eax,%eax
801025d1:	74 73                	je     80102646 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801025d3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801025d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801025d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801025e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801025e3:	89 fa                	mov    %edi,%edx
801025e5:	c1 ea 09             	shr    $0x9,%edx
801025e8:	89 d8                	mov    %ebx,%eax
801025ea:	e8 51 f9 ff ff       	call   80101f40 <bmap>
801025ef:	83 ec 08             	sub    $0x8,%esp
801025f2:	50                   	push   %eax
801025f3:	ff 33                	push   (%ebx)
801025f5:	e8 d6 da ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801025fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801025fd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102602:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102604:	89 f8                	mov    %edi,%eax
80102606:	25 ff 01 00 00       	and    $0x1ff,%eax
8010260b:	29 f3                	sub    %esi,%ebx
8010260d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
8010260f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102613:	39 d9                	cmp    %ebx,%ecx
80102615:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102618:	83 c4 0c             	add    $0xc,%esp
8010261b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010261c:	01 de                	add    %ebx,%esi
8010261e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102620:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102623:	50                   	push   %eax
80102624:	ff 75 e0             	push   -0x20(%ebp)
80102627:	e8 d4 2b 00 00       	call   80105200 <memmove>
    brelse(bp);
8010262c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010262f:	89 14 24             	mov    %edx,(%esp)
80102632:	e8 b9 db ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102637:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010263a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	72 9c                	jb     801025e0 <readi+0x60>
80102644:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102646:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102649:	5b                   	pop    %ebx
8010264a:	5e                   	pop    %esi
8010264b:	5f                   	pop    %edi
8010264c:	5d                   	pop    %ebp
8010264d:	c3                   	ret
8010264e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102650:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102654:	66 83 fa 09          	cmp    $0x9,%dx
80102658:	77 17                	ja     80102671 <readi+0xf1>
8010265a:	8b 14 d5 80 0b 11 80 	mov    -0x7feef480(,%edx,8),%edx
80102661:	85 d2                	test   %edx,%edx
80102663:	74 0c                	je     80102671 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102665:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010266b:	5b                   	pop    %ebx
8010266c:	5e                   	pop    %esi
8010266d:	5f                   	pop    %edi
8010266e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010266f:	ff e2                	jmp    *%edx
      return -1;
80102671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102676:	eb ce                	jmp    80102646 <readi+0xc6>
80102678:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010267f:	00 

80102680 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	83 ec 1c             	sub    $0x1c,%esp
80102689:	8b 45 08             	mov    0x8(%ebp),%eax
8010268c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010268f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102692:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102697:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010269a:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010269d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801026a0:	0f 84 ba 00 00 00    	je     80102760 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801026a6:	39 78 58             	cmp    %edi,0x58(%eax)
801026a9:	0f 82 ea 00 00 00    	jb     80102799 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801026af:	8b 75 e0             	mov    -0x20(%ebp),%esi
801026b2:	89 f2                	mov    %esi,%edx
801026b4:	01 fa                	add    %edi,%edx
801026b6:	0f 82 dd 00 00 00    	jb     80102799 <writei+0x119>
801026bc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801026c2:	0f 87 d1 00 00 00    	ja     80102799 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801026c8:	85 f6                	test   %esi,%esi
801026ca:	0f 84 85 00 00 00    	je     80102755 <writei+0xd5>
801026d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801026d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801026e0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801026e3:	89 fa                	mov    %edi,%edx
801026e5:	c1 ea 09             	shr    $0x9,%edx
801026e8:	89 f0                	mov    %esi,%eax
801026ea:	e8 51 f8 ff ff       	call   80101f40 <bmap>
801026ef:	83 ec 08             	sub    $0x8,%esp
801026f2:	50                   	push   %eax
801026f3:	ff 36                	push   (%esi)
801026f5:	e8 d6 d9 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801026fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801026fd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102700:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102705:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102707:	89 f8                	mov    %edi,%eax
80102709:	25 ff 01 00 00       	and    $0x1ff,%eax
8010270e:	29 d3                	sub    %edx,%ebx
80102710:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102712:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102716:	39 d9                	cmp    %ebx,%ecx
80102718:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010271b:	83 c4 0c             	add    $0xc,%esp
8010271e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010271f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102721:	ff 75 dc             	push   -0x24(%ebp)
80102724:	50                   	push   %eax
80102725:	e8 d6 2a 00 00       	call   80105200 <memmove>
    log_write(bp);
8010272a:	89 34 24             	mov    %esi,(%esp)
8010272d:	e8 be 12 00 00       	call   801039f0 <log_write>
    brelse(bp);
80102732:	89 34 24             	mov    %esi,(%esp)
80102735:	e8 b6 da ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010273a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010273d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102740:	83 c4 10             	add    $0x10,%esp
80102743:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102746:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102749:	39 d8                	cmp    %ebx,%eax
8010274b:	72 93                	jb     801026e0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010274d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102750:	39 78 58             	cmp    %edi,0x58(%eax)
80102753:	72 33                	jb     80102788 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102755:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010275b:	5b                   	pop    %ebx
8010275c:	5e                   	pop    %esi
8010275d:	5f                   	pop    %edi
8010275e:	5d                   	pop    %ebp
8010275f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102760:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102764:	66 83 f8 09          	cmp    $0x9,%ax
80102768:	77 2f                	ja     80102799 <writei+0x119>
8010276a:	8b 04 c5 84 0b 11 80 	mov    -0x7feef47c(,%eax,8),%eax
80102771:	85 c0                	test   %eax,%eax
80102773:	74 24                	je     80102799 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102775:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102778:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010277b:	5b                   	pop    %ebx
8010277c:	5e                   	pop    %esi
8010277d:	5f                   	pop    %edi
8010277e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010277f:	ff e0                	jmp    *%eax
80102781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102788:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010278b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010278e:	50                   	push   %eax
8010278f:	e8 2c fa ff ff       	call   801021c0 <iupdate>
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	eb bc                	jmp    80102755 <writei+0xd5>
      return -1;
80102799:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010279e:	eb b8                	jmp    80102758 <writei+0xd8>

801027a0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801027a6:	6a 0e                	push   $0xe
801027a8:	ff 75 0c             	push   0xc(%ebp)
801027ab:	ff 75 08             	push   0x8(%ebp)
801027ae:	e8 bd 2a 00 00       	call   80105270 <strncmp>
}
801027b3:	c9                   	leave
801027b4:	c3                   	ret
801027b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bc:	00 
801027bd:	8d 76 00             	lea    0x0(%esi),%esi

801027c0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	57                   	push   %edi
801027c4:	56                   	push   %esi
801027c5:	53                   	push   %ebx
801027c6:	83 ec 1c             	sub    $0x1c,%esp
801027c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801027cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801027d1:	0f 85 85 00 00 00    	jne    8010285c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801027d7:	8b 53 58             	mov    0x58(%ebx),%edx
801027da:	31 ff                	xor    %edi,%edi
801027dc:	8d 75 d8             	lea    -0x28(%ebp),%esi
801027df:	85 d2                	test   %edx,%edx
801027e1:	74 3e                	je     80102821 <dirlookup+0x61>
801027e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801027e8:	6a 10                	push   $0x10
801027ea:	57                   	push   %edi
801027eb:	56                   	push   %esi
801027ec:	53                   	push   %ebx
801027ed:	e8 8e fd ff ff       	call   80102580 <readi>
801027f2:	83 c4 10             	add    $0x10,%esp
801027f5:	83 f8 10             	cmp    $0x10,%eax
801027f8:	75 55                	jne    8010284f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801027fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801027ff:	74 18                	je     80102819 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102801:	83 ec 04             	sub    $0x4,%esp
80102804:	8d 45 da             	lea    -0x26(%ebp),%eax
80102807:	6a 0e                	push   $0xe
80102809:	50                   	push   %eax
8010280a:	ff 75 0c             	push   0xc(%ebp)
8010280d:	e8 5e 2a 00 00       	call   80105270 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102812:	83 c4 10             	add    $0x10,%esp
80102815:	85 c0                	test   %eax,%eax
80102817:	74 17                	je     80102830 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102819:	83 c7 10             	add    $0x10,%edi
8010281c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010281f:	72 c7                	jb     801027e8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102821:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102824:	31 c0                	xor    %eax,%eax
}
80102826:	5b                   	pop    %ebx
80102827:	5e                   	pop    %esi
80102828:	5f                   	pop    %edi
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret
8010282b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80102830:	8b 45 10             	mov    0x10(%ebp),%eax
80102833:	85 c0                	test   %eax,%eax
80102835:	74 05                	je     8010283c <dirlookup+0x7c>
        *poff = off;
80102837:	8b 45 10             	mov    0x10(%ebp),%eax
8010283a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010283c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102840:	8b 03                	mov    (%ebx),%eax
80102842:	e8 79 f5 ff ff       	call   80101dc0 <iget>
}
80102847:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010284a:	5b                   	pop    %ebx
8010284b:	5e                   	pop    %esi
8010284c:	5f                   	pop    %edi
8010284d:	5d                   	pop    %ebp
8010284e:	c3                   	ret
      panic("dirlookup read");
8010284f:	83 ec 0c             	sub    $0xc,%esp
80102852:	68 88 7d 10 80       	push   $0x80107d88
80102857:	e8 14 db ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 76 7d 10 80       	push   $0x80107d76
80102864:	e8 07 db ff ff       	call   80100370 <panic>
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102870 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	57                   	push   %edi
80102874:	56                   	push   %esi
80102875:	53                   	push   %ebx
80102876:	89 c3                	mov    %eax,%ebx
80102878:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010287b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010287e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102881:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102884:	0f 84 9e 01 00 00    	je     80102a28 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010288a:	e8 a1 1b 00 00       	call   80104430 <myproc>
  acquire(&icache.lock);
8010288f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102892:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102895:	68 e0 0b 11 80       	push   $0x80110be0
8010289a:	e8 d1 27 00 00       	call   80105070 <acquire>
  ip->ref++;
8010289f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801028a3:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
801028aa:	e8 61 27 00 00       	call   80105010 <release>
801028af:	83 c4 10             	add    $0x10,%esp
801028b2:	eb 07                	jmp    801028bb <namex+0x4b>
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801028b8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801028bb:	0f b6 03             	movzbl (%ebx),%eax
801028be:	3c 2f                	cmp    $0x2f,%al
801028c0:	74 f6                	je     801028b8 <namex+0x48>
  if(*path == 0)
801028c2:	84 c0                	test   %al,%al
801028c4:	0f 84 06 01 00 00    	je     801029d0 <namex+0x160>
  while(*path != '/' && *path != 0)
801028ca:	0f b6 03             	movzbl (%ebx),%eax
801028cd:	84 c0                	test   %al,%al
801028cf:	0f 84 10 01 00 00    	je     801029e5 <namex+0x175>
801028d5:	89 df                	mov    %ebx,%edi
801028d7:	3c 2f                	cmp    $0x2f,%al
801028d9:	0f 84 06 01 00 00    	je     801029e5 <namex+0x175>
801028df:	90                   	nop
801028e0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801028e4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801028e7:	3c 2f                	cmp    $0x2f,%al
801028e9:	74 04                	je     801028ef <namex+0x7f>
801028eb:	84 c0                	test   %al,%al
801028ed:	75 f1                	jne    801028e0 <namex+0x70>
  len = path - s;
801028ef:	89 f8                	mov    %edi,%eax
801028f1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801028f3:	83 f8 0d             	cmp    $0xd,%eax
801028f6:	0f 8e ac 00 00 00    	jle    801029a8 <namex+0x138>
    memmove(name, s, DIRSIZ);
801028fc:	83 ec 04             	sub    $0x4,%esp
801028ff:	6a 0e                	push   $0xe
80102901:	53                   	push   %ebx
80102902:	89 fb                	mov    %edi,%ebx
80102904:	ff 75 e4             	push   -0x1c(%ebp)
80102907:	e8 f4 28 00 00       	call   80105200 <memmove>
8010290c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010290f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102912:	75 0c                	jne    80102920 <namex+0xb0>
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102918:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010291b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010291e:	74 f8                	je     80102918 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102920:	83 ec 0c             	sub    $0xc,%esp
80102923:	56                   	push   %esi
80102924:	e8 47 f9 ff ff       	call   80102270 <ilock>
    if(ip->type != T_DIR){
80102929:	83 c4 10             	add    $0x10,%esp
8010292c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102931:	0f 85 b7 00 00 00    	jne    801029ee <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102937:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010293a:	85 c0                	test   %eax,%eax
8010293c:	74 09                	je     80102947 <namex+0xd7>
8010293e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102941:	0f 84 f7 00 00 00    	je     80102a3e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102947:	83 ec 04             	sub    $0x4,%esp
8010294a:	6a 00                	push   $0x0
8010294c:	ff 75 e4             	push   -0x1c(%ebp)
8010294f:	56                   	push   %esi
80102950:	e8 6b fe ff ff       	call   801027c0 <dirlookup>
80102955:	83 c4 10             	add    $0x10,%esp
80102958:	89 c7                	mov    %eax,%edi
8010295a:	85 c0                	test   %eax,%eax
8010295c:	0f 84 8c 00 00 00    	je     801029ee <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102962:	83 ec 0c             	sub    $0xc,%esp
80102965:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102968:	51                   	push   %ecx
80102969:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010296c:	e8 bf 24 00 00       	call   80104e30 <holdingsleep>
80102971:	83 c4 10             	add    $0x10,%esp
80102974:	85 c0                	test   %eax,%eax
80102976:	0f 84 02 01 00 00    	je     80102a7e <namex+0x20e>
8010297c:	8b 56 08             	mov    0x8(%esi),%edx
8010297f:	85 d2                	test   %edx,%edx
80102981:	0f 8e f7 00 00 00    	jle    80102a7e <namex+0x20e>
  releasesleep(&ip->lock);
80102987:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010298a:	83 ec 0c             	sub    $0xc,%esp
8010298d:	51                   	push   %ecx
8010298e:	e8 5d 24 00 00       	call   80104df0 <releasesleep>
  iput(ip);
80102993:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80102996:	89 fe                	mov    %edi,%esi
  iput(ip);
80102998:	e8 03 fa ff ff       	call   801023a0 <iput>
8010299d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801029a0:	e9 16 ff ff ff       	jmp    801028bb <namex+0x4b>
801029a5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801029a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801029ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
801029ae:	83 ec 04             	sub    $0x4,%esp
801029b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801029b4:	50                   	push   %eax
801029b5:	53                   	push   %ebx
    name[len] = 0;
801029b6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801029b8:	ff 75 e4             	push   -0x1c(%ebp)
801029bb:	e8 40 28 00 00       	call   80105200 <memmove>
    name[len] = 0;
801029c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801029c3:	83 c4 10             	add    $0x10,%esp
801029c6:	c6 01 00             	movb   $0x0,(%ecx)
801029c9:	e9 41 ff ff ff       	jmp    8010290f <namex+0x9f>
801029ce:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801029d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801029d3:	85 c0                	test   %eax,%eax
801029d5:	0f 85 93 00 00 00    	jne    80102a6e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801029db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029de:	89 f0                	mov    %esi,%eax
801029e0:	5b                   	pop    %ebx
801029e1:	5e                   	pop    %esi
801029e2:	5f                   	pop    %edi
801029e3:	5d                   	pop    %ebp
801029e4:	c3                   	ret
  while(*path != '/' && *path != 0)
801029e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801029e8:	89 df                	mov    %ebx,%edi
801029ea:	31 c0                	xor    %eax,%eax
801029ec:	eb c0                	jmp    801029ae <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801029ee:	83 ec 0c             	sub    $0xc,%esp
801029f1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801029f4:	53                   	push   %ebx
801029f5:	e8 36 24 00 00       	call   80104e30 <holdingsleep>
801029fa:	83 c4 10             	add    $0x10,%esp
801029fd:	85 c0                	test   %eax,%eax
801029ff:	74 7d                	je     80102a7e <namex+0x20e>
80102a01:	8b 4e 08             	mov    0x8(%esi),%ecx
80102a04:	85 c9                	test   %ecx,%ecx
80102a06:	7e 76                	jle    80102a7e <namex+0x20e>
  releasesleep(&ip->lock);
80102a08:	83 ec 0c             	sub    $0xc,%esp
80102a0b:	53                   	push   %ebx
80102a0c:	e8 df 23 00 00       	call   80104df0 <releasesleep>
  iput(ip);
80102a11:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102a14:	31 f6                	xor    %esi,%esi
  iput(ip);
80102a16:	e8 85 f9 ff ff       	call   801023a0 <iput>
      return 0;
80102a1b:	83 c4 10             	add    $0x10,%esp
}
80102a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a21:	89 f0                	mov    %esi,%eax
80102a23:	5b                   	pop    %ebx
80102a24:	5e                   	pop    %esi
80102a25:	5f                   	pop    %edi
80102a26:	5d                   	pop    %ebp
80102a27:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102a28:	ba 01 00 00 00       	mov    $0x1,%edx
80102a2d:	b8 01 00 00 00       	mov    $0x1,%eax
80102a32:	e8 89 f3 ff ff       	call   80101dc0 <iget>
80102a37:	89 c6                	mov    %eax,%esi
80102a39:	e9 7d fe ff ff       	jmp    801028bb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102a3e:	83 ec 0c             	sub    $0xc,%esp
80102a41:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102a44:	53                   	push   %ebx
80102a45:	e8 e6 23 00 00       	call   80104e30 <holdingsleep>
80102a4a:	83 c4 10             	add    $0x10,%esp
80102a4d:	85 c0                	test   %eax,%eax
80102a4f:	74 2d                	je     80102a7e <namex+0x20e>
80102a51:	8b 7e 08             	mov    0x8(%esi),%edi
80102a54:	85 ff                	test   %edi,%edi
80102a56:	7e 26                	jle    80102a7e <namex+0x20e>
  releasesleep(&ip->lock);
80102a58:	83 ec 0c             	sub    $0xc,%esp
80102a5b:	53                   	push   %ebx
80102a5c:	e8 8f 23 00 00       	call   80104df0 <releasesleep>
}
80102a61:	83 c4 10             	add    $0x10,%esp
}
80102a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a67:	89 f0                	mov    %esi,%eax
80102a69:	5b                   	pop    %ebx
80102a6a:	5e                   	pop    %esi
80102a6b:	5f                   	pop    %edi
80102a6c:	5d                   	pop    %ebp
80102a6d:	c3                   	ret
    iput(ip);
80102a6e:	83 ec 0c             	sub    $0xc,%esp
80102a71:	56                   	push   %esi
      return 0;
80102a72:	31 f6                	xor    %esi,%esi
    iput(ip);
80102a74:	e8 27 f9 ff ff       	call   801023a0 <iput>
    return 0;
80102a79:	83 c4 10             	add    $0x10,%esp
80102a7c:	eb a0                	jmp    80102a1e <namex+0x1ae>
    panic("iunlock");
80102a7e:	83 ec 0c             	sub    $0xc,%esp
80102a81:	68 6e 7d 10 80       	push   $0x80107d6e
80102a86:	e8 e5 d8 ff ff       	call   80100370 <panic>
80102a8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a90 <dirlink>:
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	57                   	push   %edi
80102a94:	56                   	push   %esi
80102a95:	53                   	push   %ebx
80102a96:	83 ec 20             	sub    $0x20,%esp
80102a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102a9c:	6a 00                	push   $0x0
80102a9e:	ff 75 0c             	push   0xc(%ebp)
80102aa1:	53                   	push   %ebx
80102aa2:	e8 19 fd ff ff       	call   801027c0 <dirlookup>
80102aa7:	83 c4 10             	add    $0x10,%esp
80102aaa:	85 c0                	test   %eax,%eax
80102aac:	75 67                	jne    80102b15 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102aae:	8b 7b 58             	mov    0x58(%ebx),%edi
80102ab1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102ab4:	85 ff                	test   %edi,%edi
80102ab6:	74 29                	je     80102ae1 <dirlink+0x51>
80102ab8:	31 ff                	xor    %edi,%edi
80102aba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102abd:	eb 09                	jmp    80102ac8 <dirlink+0x38>
80102abf:	90                   	nop
80102ac0:	83 c7 10             	add    $0x10,%edi
80102ac3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102ac6:	73 19                	jae    80102ae1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102ac8:	6a 10                	push   $0x10
80102aca:	57                   	push   %edi
80102acb:	56                   	push   %esi
80102acc:	53                   	push   %ebx
80102acd:	e8 ae fa ff ff       	call   80102580 <readi>
80102ad2:	83 c4 10             	add    $0x10,%esp
80102ad5:	83 f8 10             	cmp    $0x10,%eax
80102ad8:	75 4e                	jne    80102b28 <dirlink+0x98>
    if(de.inum == 0)
80102ada:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102adf:	75 df                	jne    80102ac0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102ae1:	83 ec 04             	sub    $0x4,%esp
80102ae4:	8d 45 da             	lea    -0x26(%ebp),%eax
80102ae7:	6a 0e                	push   $0xe
80102ae9:	ff 75 0c             	push   0xc(%ebp)
80102aec:	50                   	push   %eax
80102aed:	e8 ce 27 00 00       	call   801052c0 <strncpy>
  de.inum = inum;
80102af2:	8b 45 10             	mov    0x10(%ebp),%eax
80102af5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102af9:	6a 10                	push   $0x10
80102afb:	57                   	push   %edi
80102afc:	56                   	push   %esi
80102afd:	53                   	push   %ebx
80102afe:	e8 7d fb ff ff       	call   80102680 <writei>
80102b03:	83 c4 20             	add    $0x20,%esp
80102b06:	83 f8 10             	cmp    $0x10,%eax
80102b09:	75 2a                	jne    80102b35 <dirlink+0xa5>
  return 0;
80102b0b:	31 c0                	xor    %eax,%eax
}
80102b0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b10:	5b                   	pop    %ebx
80102b11:	5e                   	pop    %esi
80102b12:	5f                   	pop    %edi
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret
    iput(ip);
80102b15:	83 ec 0c             	sub    $0xc,%esp
80102b18:	50                   	push   %eax
80102b19:	e8 82 f8 ff ff       	call   801023a0 <iput>
    return -1;
80102b1e:	83 c4 10             	add    $0x10,%esp
80102b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b26:	eb e5                	jmp    80102b0d <dirlink+0x7d>
      panic("dirlink read");
80102b28:	83 ec 0c             	sub    $0xc,%esp
80102b2b:	68 97 7d 10 80       	push   $0x80107d97
80102b30:	e8 3b d8 ff ff       	call   80100370 <panic>
    panic("dirlink");
80102b35:	83 ec 0c             	sub    $0xc,%esp
80102b38:	68 f3 7f 10 80       	push   $0x80107ff3
80102b3d:	e8 2e d8 ff ff       	call   80100370 <panic>
80102b42:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b49:	00 
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b50 <namei>:

struct inode*
namei(char *path)
{
80102b50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102b51:	31 d2                	xor    %edx,%edx
{
80102b53:	89 e5                	mov    %esp,%ebp
80102b55:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102b58:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102b5e:	e8 0d fd ff ff       	call   80102870 <namex>
}
80102b63:	c9                   	leave
80102b64:	c3                   	ret
80102b65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b6c:	00 
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102b70:	55                   	push   %ebp
  return namex(path, 1, name);
80102b71:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102b76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102b78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102b7e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102b7f:	e9 ec fc ff ff       	jmp    80102870 <namex>
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102b99:	85 c0                	test   %eax,%eax
80102b9b:	0f 84 b4 00 00 00    	je     80102c55 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102ba1:	8b 70 08             	mov    0x8(%eax),%esi
80102ba4:	89 c3                	mov    %eax,%ebx
80102ba6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80102bac:	0f 87 96 00 00 00    	ja     80102c48 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bbe:	00 
80102bbf:	90                   	nop
80102bc0:	89 ca                	mov    %ecx,%edx
80102bc2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102bc3:	83 e0 c0             	and    $0xffffffc0,%eax
80102bc6:	3c 40                	cmp    $0x40,%al
80102bc8:	75 f6                	jne    80102bc0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bca:	31 ff                	xor    %edi,%edi
80102bcc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102bd1:	89 f8                	mov    %edi,%eax
80102bd3:	ee                   	out    %al,(%dx)
80102bd4:	b8 01 00 00 00       	mov    $0x1,%eax
80102bd9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102bde:	ee                   	out    %al,(%dx)
80102bdf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102be4:	89 f0                	mov    %esi,%eax
80102be6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102be7:	89 f0                	mov    %esi,%eax
80102be9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102bee:	c1 f8 08             	sar    $0x8,%eax
80102bf1:	ee                   	out    %al,(%dx)
80102bf2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102bf7:	89 f8                	mov    %edi,%eax
80102bf9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102bfa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102bfe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c03:	c1 e0 04             	shl    $0x4,%eax
80102c06:	83 e0 10             	and    $0x10,%eax
80102c09:	83 c8 e0             	or     $0xffffffe0,%eax
80102c0c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102c0d:	f6 03 04             	testb  $0x4,(%ebx)
80102c10:	75 16                	jne    80102c28 <idestart+0x98>
80102c12:	b8 20 00 00 00       	mov    $0x20,%eax
80102c17:	89 ca                	mov    %ecx,%edx
80102c19:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102c1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1d:	5b                   	pop    %ebx
80102c1e:	5e                   	pop    %esi
80102c1f:	5f                   	pop    %edi
80102c20:	5d                   	pop    %ebp
80102c21:	c3                   	ret
80102c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c28:	b8 30 00 00 00       	mov    $0x30,%eax
80102c2d:	89 ca                	mov    %ecx,%edx
80102c2f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102c30:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102c35:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102c38:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102c3d:	fc                   	cld
80102c3e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c43:	5b                   	pop    %ebx
80102c44:	5e                   	pop    %esi
80102c45:	5f                   	pop    %edi
80102c46:	5d                   	pop    %ebp
80102c47:	c3                   	ret
    panic("incorrect blockno");
80102c48:	83 ec 0c             	sub    $0xc,%esp
80102c4b:	68 ad 7d 10 80       	push   $0x80107dad
80102c50:	e8 1b d7 ff ff       	call   80100370 <panic>
    panic("idestart");
80102c55:	83 ec 0c             	sub    $0xc,%esp
80102c58:	68 a4 7d 10 80       	push   $0x80107da4
80102c5d:	e8 0e d7 ff ff       	call   80100370 <panic>
80102c62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c69:	00 
80102c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c70 <ideinit>:
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102c76:	68 bf 7d 10 80       	push   $0x80107dbf
80102c7b:	68 80 28 11 80       	push   $0x80112880
80102c80:	e8 fb 21 00 00       	call   80104e80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102c85:	58                   	pop    %eax
80102c86:	a1 04 2a 11 80       	mov    0x80112a04,%eax
80102c8b:	5a                   	pop    %edx
80102c8c:	83 e8 01             	sub    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	6a 0e                	push   $0xe
80102c92:	e8 99 02 00 00       	call   80102f30 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102c97:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102c9f:	90                   	nop
80102ca0:	89 ca                	mov    %ecx,%edx
80102ca2:	ec                   	in     (%dx),%al
80102ca3:	83 e0 c0             	and    $0xffffffc0,%eax
80102ca6:	3c 40                	cmp    $0x40,%al
80102ca8:	75 f6                	jne    80102ca0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102caa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102caf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102cb4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb5:	89 ca                	mov    %ecx,%edx
80102cb7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102cb8:	84 c0                	test   %al,%al
80102cba:	75 1e                	jne    80102cda <ideinit+0x6a>
80102cbc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102cc1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ccd:	00 
80102cce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102cd0:	83 e9 01             	sub    $0x1,%ecx
80102cd3:	74 0f                	je     80102ce4 <ideinit+0x74>
80102cd5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102cd6:	84 c0                	test   %al,%al
80102cd8:	74 f6                	je     80102cd0 <ideinit+0x60>
      havedisk1 = 1;
80102cda:	c7 05 60 28 11 80 01 	movl   $0x1,0x80112860
80102ce1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102ce9:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102cee:	ee                   	out    %al,(%dx)
}
80102cef:	c9                   	leave
80102cf0:	c3                   	ret
80102cf1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cf8:	00 
80102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d00 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	57                   	push   %edi
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102d09:	68 80 28 11 80       	push   $0x80112880
80102d0e:	e8 5d 23 00 00       	call   80105070 <acquire>

  if((b = idequeue) == 0){
80102d13:	8b 1d 64 28 11 80    	mov    0x80112864,%ebx
80102d19:	83 c4 10             	add    $0x10,%esp
80102d1c:	85 db                	test   %ebx,%ebx
80102d1e:	74 63                	je     80102d83 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102d20:	8b 43 58             	mov    0x58(%ebx),%eax
80102d23:	a3 64 28 11 80       	mov    %eax,0x80112864

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102d28:	8b 33                	mov    (%ebx),%esi
80102d2a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102d30:	75 2f                	jne    80102d61 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d32:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop
80102d40:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102d41:	89 c1                	mov    %eax,%ecx
80102d43:	83 e1 c0             	and    $0xffffffc0,%ecx
80102d46:	80 f9 40             	cmp    $0x40,%cl
80102d49:	75 f5                	jne    80102d40 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102d4b:	a8 21                	test   $0x21,%al
80102d4d:	75 12                	jne    80102d61 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102d4f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102d52:	b9 80 00 00 00       	mov    $0x80,%ecx
80102d57:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102d5c:	fc                   	cld
80102d5d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102d5f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102d61:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102d64:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102d67:	83 ce 02             	or     $0x2,%esi
80102d6a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102d6c:	53                   	push   %ebx
80102d6d:	e8 3e 1e 00 00       	call   80104bb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102d72:	a1 64 28 11 80       	mov    0x80112864,%eax
80102d77:	83 c4 10             	add    $0x10,%esp
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	74 05                	je     80102d83 <ideintr+0x83>
    idestart(idequeue);
80102d7e:	e8 0d fe ff ff       	call   80102b90 <idestart>
    release(&idelock);
80102d83:	83 ec 0c             	sub    $0xc,%esp
80102d86:	68 80 28 11 80       	push   $0x80112880
80102d8b:	e8 80 22 00 00       	call   80105010 <release>

  release(&idelock);
}
80102d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d93:	5b                   	pop    %ebx
80102d94:	5e                   	pop    %esi
80102d95:	5f                   	pop    %edi
80102d96:	5d                   	pop    %ebp
80102d97:	c3                   	ret
80102d98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d9f:	00 

80102da0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 10             	sub    $0x10,%esp
80102da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102daa:	8d 43 0c             	lea    0xc(%ebx),%eax
80102dad:	50                   	push   %eax
80102dae:	e8 7d 20 00 00       	call   80104e30 <holdingsleep>
80102db3:	83 c4 10             	add    $0x10,%esp
80102db6:	85 c0                	test   %eax,%eax
80102db8:	0f 84 c3 00 00 00    	je     80102e81 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102dbe:	8b 03                	mov    (%ebx),%eax
80102dc0:	83 e0 06             	and    $0x6,%eax
80102dc3:	83 f8 02             	cmp    $0x2,%eax
80102dc6:	0f 84 a8 00 00 00    	je     80102e74 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102dcc:	8b 53 04             	mov    0x4(%ebx),%edx
80102dcf:	85 d2                	test   %edx,%edx
80102dd1:	74 0d                	je     80102de0 <iderw+0x40>
80102dd3:	a1 60 28 11 80       	mov    0x80112860,%eax
80102dd8:	85 c0                	test   %eax,%eax
80102dda:	0f 84 87 00 00 00    	je     80102e67 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102de0:	83 ec 0c             	sub    $0xc,%esp
80102de3:	68 80 28 11 80       	push   $0x80112880
80102de8:	e8 83 22 00 00       	call   80105070 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102ded:	a1 64 28 11 80       	mov    0x80112864,%eax
  b->qnext = 0;
80102df2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	85 c0                	test   %eax,%eax
80102dfe:	74 60                	je     80102e60 <iderw+0xc0>
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	8b 40 58             	mov    0x58(%eax),%eax
80102e05:	85 c0                	test   %eax,%eax
80102e07:	75 f7                	jne    80102e00 <iderw+0x60>
80102e09:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102e0c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102e0e:	39 1d 64 28 11 80    	cmp    %ebx,0x80112864
80102e14:	74 3a                	je     80102e50 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102e16:	8b 03                	mov    (%ebx),%eax
80102e18:	83 e0 06             	and    $0x6,%eax
80102e1b:	83 f8 02             	cmp    $0x2,%eax
80102e1e:	74 1b                	je     80102e3b <iderw+0x9b>
    sleep(b, &idelock);
80102e20:	83 ec 08             	sub    $0x8,%esp
80102e23:	68 80 28 11 80       	push   $0x80112880
80102e28:	53                   	push   %ebx
80102e29:	e8 c2 1c 00 00       	call   80104af0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102e2e:	8b 03                	mov    (%ebx),%eax
80102e30:	83 c4 10             	add    $0x10,%esp
80102e33:	83 e0 06             	and    $0x6,%eax
80102e36:	83 f8 02             	cmp    $0x2,%eax
80102e39:	75 e5                	jne    80102e20 <iderw+0x80>
  }


  release(&idelock);
80102e3b:	c7 45 08 80 28 11 80 	movl   $0x80112880,0x8(%ebp)
}
80102e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e45:	c9                   	leave
  release(&idelock);
80102e46:	e9 c5 21 00 00       	jmp    80105010 <release>
80102e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102e50:	89 d8                	mov    %ebx,%eax
80102e52:	e8 39 fd ff ff       	call   80102b90 <idestart>
80102e57:	eb bd                	jmp    80102e16 <iderw+0x76>
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102e60:	ba 64 28 11 80       	mov    $0x80112864,%edx
80102e65:	eb a5                	jmp    80102e0c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102e67:	83 ec 0c             	sub    $0xc,%esp
80102e6a:	68 ee 7d 10 80       	push   $0x80107dee
80102e6f:	e8 fc d4 ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
80102e74:	83 ec 0c             	sub    $0xc,%esp
80102e77:	68 d9 7d 10 80       	push   $0x80107dd9
80102e7c:	e8 ef d4 ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	68 c3 7d 10 80       	push   $0x80107dc3
80102e89:	e8 e2 d4 ff ff       	call   80100370 <panic>
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	56                   	push   %esi
80102e94:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102e95:	c7 05 b4 28 11 80 00 	movl   $0xfec00000,0x801128b4
80102e9c:	00 c0 fe 
  ioapic->reg = reg;
80102e9f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102ea6:	00 00 00 
  return ioapic->data;
80102ea9:	8b 15 b4 28 11 80    	mov    0x801128b4,%edx
80102eaf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102eb2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102eb8:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102ebe:	0f b6 15 00 2a 11 80 	movzbl 0x80112a00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ec5:	c1 ee 10             	shr    $0x10,%esi
80102ec8:	89 f0                	mov    %esi,%eax
80102eca:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102ed0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102ed3:	39 c2                	cmp    %eax,%edx
80102ed5:	74 16                	je     80102eed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102ed7:	83 ec 0c             	sub    $0xc,%esp
80102eda:	68 14 82 10 80       	push   $0x80108214
80102edf:	e8 cc d9 ff ff       	call   801008b0 <cprintf>
  ioapic->reg = reg;
80102ee4:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
80102eea:	83 c4 10             	add    $0x10,%esp
{
80102eed:	ba 10 00 00 00       	mov    $0x10,%edx
80102ef2:	31 c0                	xor    %eax,%eax
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102ef8:	89 13                	mov    %edx,(%ebx)
80102efa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
80102efd:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102f03:	83 c0 01             	add    $0x1,%eax
80102f06:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
80102f0c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
80102f0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102f12:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102f15:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102f17:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
80102f1d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102f24:	39 c6                	cmp    %eax,%esi
80102f26:	7d d0                	jge    80102ef8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102f28:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f2b:	5b                   	pop    %ebx
80102f2c:	5e                   	pop    %esi
80102f2d:	5d                   	pop    %ebp
80102f2e:	c3                   	ret
80102f2f:	90                   	nop

80102f30 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102f30:	55                   	push   %ebp
  ioapic->reg = reg;
80102f31:	8b 0d b4 28 11 80    	mov    0x801128b4,%ecx
{
80102f37:	89 e5                	mov    %esp,%ebp
80102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102f3c:	8d 50 20             	lea    0x20(%eax),%edx
80102f3f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102f43:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102f45:	8b 0d b4 28 11 80    	mov    0x801128b4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102f4b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102f4e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102f54:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102f56:	a1 b4 28 11 80       	mov    0x801128b4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102f5b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102f5e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102f61:	5d                   	pop    %ebp
80102f62:	c3                   	ret
80102f63:	66 90                	xchg   %ax,%ax
80102f65:	66 90                	xchg   %ax,%ax
80102f67:	66 90                	xchg   %ax,%ax
80102f69:	66 90                	xchg   %ax,%ax
80102f6b:	66 90                	xchg   %ax,%ax
80102f6d:	66 90                	xchg   %ax,%ax
80102f6f:	90                   	nop

80102f70 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	53                   	push   %ebx
80102f74:	83 ec 04             	sub    $0x4,%esp
80102f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102f7a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102f80:	75 76                	jne    80102ff8 <kfree+0x88>
80102f82:	81 fb 50 67 11 80    	cmp    $0x80116750,%ebx
80102f88:	72 6e                	jb     80102ff8 <kfree+0x88>
80102f8a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102f90:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f95:	77 61                	ja     80102ff8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f97:	83 ec 04             	sub    $0x4,%esp
80102f9a:	68 00 10 00 00       	push   $0x1000
80102f9f:	6a 01                	push   $0x1
80102fa1:	53                   	push   %ebx
80102fa2:	e8 c9 21 00 00       	call   80105170 <memset>

  if(kmem.use_lock)
80102fa7:	8b 15 f4 28 11 80    	mov    0x801128f4,%edx
80102fad:	83 c4 10             	add    $0x10,%esp
80102fb0:	85 d2                	test   %edx,%edx
80102fb2:	75 1c                	jne    80102fd0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102fb4:	a1 f8 28 11 80       	mov    0x801128f8,%eax
80102fb9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102fbb:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  kmem.freelist = r;
80102fc0:	89 1d f8 28 11 80    	mov    %ebx,0x801128f8
  if(kmem.use_lock)
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	75 1e                	jne    80102fe8 <kfree+0x78>
    release(&kmem.lock);
}
80102fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fcd:	c9                   	leave
80102fce:	c3                   	ret
80102fcf:	90                   	nop
    acquire(&kmem.lock);
80102fd0:	83 ec 0c             	sub    $0xc,%esp
80102fd3:	68 c0 28 11 80       	push   $0x801128c0
80102fd8:	e8 93 20 00 00       	call   80105070 <acquire>
80102fdd:	83 c4 10             	add    $0x10,%esp
80102fe0:	eb d2                	jmp    80102fb4 <kfree+0x44>
80102fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102fe8:	c7 45 08 c0 28 11 80 	movl   $0x801128c0,0x8(%ebp)
}
80102fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff2:	c9                   	leave
    release(&kmem.lock);
80102ff3:	e9 18 20 00 00       	jmp    80105010 <release>
    panic("kfree");
80102ff8:	83 ec 0c             	sub    $0xc,%esp
80102ffb:	68 0c 7e 10 80       	push   $0x80107e0c
80103000:	e8 6b d3 ff ff       	call   80100370 <panic>
80103005:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010300c:	00 
8010300d:	8d 76 00             	lea    0x0(%esi),%esi

80103010 <freerange>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	56                   	push   %esi
80103014:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103015:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103018:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010301b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103021:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103027:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010302d:	39 de                	cmp    %ebx,%esi
8010302f:	72 23                	jb     80103054 <freerange+0x44>
80103031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103038:	83 ec 0c             	sub    $0xc,%esp
8010303b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103041:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103047:	50                   	push   %eax
80103048:	e8 23 ff ff ff       	call   80102f70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010304d:	83 c4 10             	add    $0x10,%esp
80103050:	39 de                	cmp    %ebx,%esi
80103052:	73 e4                	jae    80103038 <freerange+0x28>
}
80103054:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103057:	5b                   	pop    %ebx
80103058:	5e                   	pop    %esi
80103059:	5d                   	pop    %ebp
8010305a:	c3                   	ret
8010305b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103060 <kinit2>:
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	56                   	push   %esi
80103064:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103065:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103068:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010306b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103071:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103077:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010307d:	39 de                	cmp    %ebx,%esi
8010307f:	72 23                	jb     801030a4 <kinit2+0x44>
80103081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103088:	83 ec 0c             	sub    $0xc,%esp
8010308b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103091:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103097:	50                   	push   %eax
80103098:	e8 d3 fe ff ff       	call   80102f70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010309d:	83 c4 10             	add    $0x10,%esp
801030a0:	39 de                	cmp    %ebx,%esi
801030a2:	73 e4                	jae    80103088 <kinit2+0x28>
  kmem.use_lock = 1;
801030a4:	c7 05 f4 28 11 80 01 	movl   $0x1,0x801128f4
801030ab:	00 00 00 
}
801030ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030b1:	5b                   	pop    %ebx
801030b2:	5e                   	pop    %esi
801030b3:	5d                   	pop    %ebp
801030b4:	c3                   	ret
801030b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030bc:	00 
801030bd:	8d 76 00             	lea    0x0(%esi),%esi

801030c0 <kinit1>:
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	56                   	push   %esi
801030c4:	53                   	push   %ebx
801030c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801030c8:	83 ec 08             	sub    $0x8,%esp
801030cb:	68 12 7e 10 80       	push   $0x80107e12
801030d0:	68 c0 28 11 80       	push   $0x801128c0
801030d5:	e8 a6 1d 00 00       	call   80104e80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801030da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801030e0:	c7 05 f4 28 11 80 00 	movl   $0x0,0x801128f4
801030e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801030ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801030f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801030fc:	39 de                	cmp    %ebx,%esi
801030fe:	72 1c                	jb     8010311c <kinit1+0x5c>
    kfree(p);
80103100:	83 ec 0c             	sub    $0xc,%esp
80103103:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103109:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010310f:	50                   	push   %eax
80103110:	e8 5b fe ff ff       	call   80102f70 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103115:	83 c4 10             	add    $0x10,%esp
80103118:	39 de                	cmp    %ebx,%esi
8010311a:	73 e4                	jae    80103100 <kinit1+0x40>
}
8010311c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010311f:	5b                   	pop    %ebx
80103120:	5e                   	pop    %esi
80103121:	5d                   	pop    %ebp
80103122:	c3                   	ret
80103123:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010312a:	00 
8010312b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103130 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80103137:	a1 f4 28 11 80       	mov    0x801128f4,%eax
8010313c:	85 c0                	test   %eax,%eax
8010313e:	75 20                	jne    80103160 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103140:	8b 1d f8 28 11 80    	mov    0x801128f8,%ebx
  if(r)
80103146:	85 db                	test   %ebx,%ebx
80103148:	74 07                	je     80103151 <kalloc+0x21>
    kmem.freelist = r->next;
8010314a:	8b 03                	mov    (%ebx),%eax
8010314c:	a3 f8 28 11 80       	mov    %eax,0x801128f8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80103151:	89 d8                	mov    %ebx,%eax
80103153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103156:	c9                   	leave
80103157:	c3                   	ret
80103158:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010315f:	00 
    acquire(&kmem.lock);
80103160:	83 ec 0c             	sub    $0xc,%esp
80103163:	68 c0 28 11 80       	push   $0x801128c0
80103168:	e8 03 1f 00 00       	call   80105070 <acquire>
  r = kmem.freelist;
8010316d:	8b 1d f8 28 11 80    	mov    0x801128f8,%ebx
  if(kmem.use_lock)
80103173:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  if(r)
80103178:	83 c4 10             	add    $0x10,%esp
8010317b:	85 db                	test   %ebx,%ebx
8010317d:	74 08                	je     80103187 <kalloc+0x57>
    kmem.freelist = r->next;
8010317f:	8b 13                	mov    (%ebx),%edx
80103181:	89 15 f8 28 11 80    	mov    %edx,0x801128f8
  if(kmem.use_lock)
80103187:	85 c0                	test   %eax,%eax
80103189:	74 c6                	je     80103151 <kalloc+0x21>
    release(&kmem.lock);
8010318b:	83 ec 0c             	sub    $0xc,%esp
8010318e:	68 c0 28 11 80       	push   $0x801128c0
80103193:	e8 78 1e 00 00       	call   80105010 <release>
}
80103198:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010319a:	83 c4 10             	add    $0x10,%esp
}
8010319d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031a0:	c9                   	leave
801031a1:	c3                   	ret
801031a2:	66 90                	xchg   %ax,%ax
801031a4:	66 90                	xchg   %ax,%ax
801031a6:	66 90                	xchg   %ax,%ax
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b0:	ba 64 00 00 00       	mov    $0x64,%edx
801031b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801031b6:	a8 01                	test   $0x1,%al
801031b8:	0f 84 c2 00 00 00    	je     80103280 <kbdgetc+0xd0>
{
801031be:	55                   	push   %ebp
801031bf:	ba 60 00 00 00       	mov    $0x60,%edx
801031c4:	89 e5                	mov    %esp,%ebp
801031c6:	53                   	push   %ebx
801031c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801031c8:	8b 1d fc 28 11 80    	mov    0x801128fc,%ebx
  data = inb(KBDATAP);
801031ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801031d1:	3c e0                	cmp    $0xe0,%al
801031d3:	74 5b                	je     80103230 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801031d5:	89 da                	mov    %ebx,%edx
801031d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801031da:	84 c0                	test   %al,%al
801031dc:	78 62                	js     80103240 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801031de:	85 d2                	test   %edx,%edx
801031e0:	74 09                	je     801031eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801031e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801031e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801031e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801031eb:	0f b6 91 80 84 10 80 	movzbl -0x7fef7b80(%ecx),%edx
  shift ^= togglecode[data];
801031f2:	0f b6 81 80 83 10 80 	movzbl -0x7fef7c80(%ecx),%eax
  shift |= shiftcode[data];
801031f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801031fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801031fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801031ff:	89 15 fc 28 11 80    	mov    %edx,0x801128fc
  c = charcode[shift & (CTL | SHIFT)][data];
80103205:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103208:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010320b:	8b 04 85 60 83 10 80 	mov    -0x7fef7ca0(,%eax,4),%eax
80103212:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103216:	74 0b                	je     80103223 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103218:	8d 50 9f             	lea    -0x61(%eax),%edx
8010321b:	83 fa 19             	cmp    $0x19,%edx
8010321e:	77 48                	ja     80103268 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103220:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103226:	c9                   	leave
80103227:	c3                   	ret
80103228:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010322f:	00 
    shift |= E0ESC;
80103230:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103233:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103235:	89 1d fc 28 11 80    	mov    %ebx,0x801128fc
}
8010323b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010323e:	c9                   	leave
8010323f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80103240:	83 e0 7f             	and    $0x7f,%eax
80103243:	85 d2                	test   %edx,%edx
80103245:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103248:	0f b6 81 80 84 10 80 	movzbl -0x7fef7b80(%ecx),%eax
8010324f:	83 c8 40             	or     $0x40,%eax
80103252:	0f b6 c0             	movzbl %al,%eax
80103255:	f7 d0                	not    %eax
80103257:	21 d8                	and    %ebx,%eax
80103259:	a3 fc 28 11 80       	mov    %eax,0x801128fc
    return 0;
8010325e:	31 c0                	xor    %eax,%eax
80103260:	eb d9                	jmp    8010323b <kbdgetc+0x8b>
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103268:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010326b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010326e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103271:	c9                   	leave
      c += 'a' - 'A';
80103272:	83 f9 1a             	cmp    $0x1a,%ecx
80103275:	0f 42 c2             	cmovb  %edx,%eax
}
80103278:	c3                   	ret
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103285:	c3                   	ret
80103286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010328d:	00 
8010328e:	66 90                	xchg   %ax,%ax

80103290 <kbdintr>:

void
kbdintr(void)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103296:	68 b0 31 10 80       	push   $0x801031b0
8010329b:	e8 20 d8 ff ff       	call   80100ac0 <consoleintr>
}
801032a0:	83 c4 10             	add    $0x10,%esp
801032a3:	c9                   	leave
801032a4:	c3                   	ret
801032a5:	66 90                	xchg   %ax,%ax
801032a7:	66 90                	xchg   %ax,%ax
801032a9:	66 90                	xchg   %ax,%ax
801032ab:	66 90                	xchg   %ax,%ax
801032ad:	66 90                	xchg   %ax,%ax
801032af:	90                   	nop

801032b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801032b0:	a1 00 29 11 80       	mov    0x80112900,%eax
801032b5:	85 c0                	test   %eax,%eax
801032b7:	0f 84 c3 00 00 00    	je     80103380 <lapicinit+0xd0>
  lapic[index] = value;
801032bd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801032c4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032ca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801032d1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032d7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801032de:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801032e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032e4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801032eb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801032ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032f1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801032f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801032fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032fe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103305:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103308:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010330b:	8b 50 30             	mov    0x30(%eax),%edx
8010330e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80103314:	75 72                	jne    80103388 <lapicinit+0xd8>
  lapic[index] = value;
80103316:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010331d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103320:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103323:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010332a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010332d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103330:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103337:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010333a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010333d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103344:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103347:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010334a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103351:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103354:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103357:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010335e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103361:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103368:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010336e:	80 e6 10             	and    $0x10,%dh
80103371:	75 f5                	jne    80103368 <lapicinit+0xb8>
  lapic[index] = value;
80103373:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010337a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010337d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103380:	c3                   	ret
80103381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103388:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010338f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103392:	8b 50 20             	mov    0x20(%eax),%edx
}
80103395:	e9 7c ff ff ff       	jmp    80103316 <lapicinit+0x66>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801033a0:	a1 00 29 11 80       	mov    0x80112900,%eax
801033a5:	85 c0                	test   %eax,%eax
801033a7:	74 07                	je     801033b0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801033a9:	8b 40 20             	mov    0x20(%eax),%eax
801033ac:	c1 e8 18             	shr    $0x18,%eax
801033af:	c3                   	ret
    return 0;
801033b0:	31 c0                	xor    %eax,%eax
}
801033b2:	c3                   	ret
801033b3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ba:	00 
801033bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801033c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801033c0:	a1 00 29 11 80       	mov    0x80112900,%eax
801033c5:	85 c0                	test   %eax,%eax
801033c7:	74 0d                	je     801033d6 <lapiceoi+0x16>
  lapic[index] = value;
801033c9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801033d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033d3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801033d6:	c3                   	ret
801033d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033de:	00 
801033df:	90                   	nop

801033e0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801033e0:	c3                   	ret
801033e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033e8:	00 
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801033f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801033f6:	ba 70 00 00 00       	mov    $0x70,%edx
801033fb:	89 e5                	mov    %esp,%ebp
801033fd:	53                   	push   %ebx
801033fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103401:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103404:	ee                   	out    %al,(%dx)
80103405:	b8 0a 00 00 00       	mov    $0xa,%eax
8010340a:	ba 71 00 00 00       	mov    $0x71,%edx
8010340f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103410:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80103412:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103415:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010341b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010341d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80103420:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103422:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103425:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103428:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010342e:	a1 00 29 11 80       	mov    0x80112900,%eax
80103433:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103439:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010343c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103443:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103446:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103449:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103450:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103453:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103456:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010345c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010345f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103465:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103468:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010346e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103471:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103477:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010347a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010347d:	c9                   	leave
8010347e:	c3                   	ret
8010347f:	90                   	nop

80103480 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103480:	55                   	push   %ebp
80103481:	b8 0b 00 00 00       	mov    $0xb,%eax
80103486:	ba 70 00 00 00       	mov    $0x70,%edx
8010348b:	89 e5                	mov    %esp,%ebp
8010348d:	57                   	push   %edi
8010348e:	56                   	push   %esi
8010348f:	53                   	push   %ebx
80103490:	83 ec 4c             	sub    $0x4c,%esp
80103493:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103494:	ba 71 00 00 00       	mov    $0x71,%edx
80103499:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010349a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010349d:	bf 70 00 00 00       	mov    $0x70,%edi
801034a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801034a5:	8d 76 00             	lea    0x0(%esi),%esi
801034a8:	31 c0                	xor    %eax,%eax
801034aa:	89 fa                	mov    %edi,%edx
801034ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ad:	b9 71 00 00 00       	mov    $0x71,%ecx
801034b2:	89 ca                	mov    %ecx,%edx
801034b4:	ec                   	in     (%dx),%al
801034b5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034b8:	89 fa                	mov    %edi,%edx
801034ba:	b8 02 00 00 00       	mov    $0x2,%eax
801034bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034c0:	89 ca                	mov    %ecx,%edx
801034c2:	ec                   	in     (%dx),%al
801034c3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034c6:	89 fa                	mov    %edi,%edx
801034c8:	b8 04 00 00 00       	mov    $0x4,%eax
801034cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ce:	89 ca                	mov    %ecx,%edx
801034d0:	ec                   	in     (%dx),%al
801034d1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d4:	89 fa                	mov    %edi,%edx
801034d6:	b8 07 00 00 00       	mov    $0x7,%eax
801034db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034dc:	89 ca                	mov    %ecx,%edx
801034de:	ec                   	in     (%dx),%al
801034df:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e2:	89 fa                	mov    %edi,%edx
801034e4:	b8 08 00 00 00       	mov    $0x8,%eax
801034e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034ea:	89 ca                	mov    %ecx,%edx
801034ec:	ec                   	in     (%dx),%al
801034ed:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034ef:	89 fa                	mov    %edi,%edx
801034f1:	b8 09 00 00 00       	mov    $0x9,%eax
801034f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f7:	89 ca                	mov    %ecx,%edx
801034f9:	ec                   	in     (%dx),%al
801034fa:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fd:	89 fa                	mov    %edi,%edx
801034ff:	b8 0a 00 00 00       	mov    $0xa,%eax
80103504:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103505:	89 ca                	mov    %ecx,%edx
80103507:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103508:	84 c0                	test   %al,%al
8010350a:	78 9c                	js     801034a8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010350c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103510:	89 f2                	mov    %esi,%edx
80103512:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103515:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103518:	89 fa                	mov    %edi,%edx
8010351a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010351d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103521:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103524:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103527:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010352b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010352e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103532:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103535:	31 c0                	xor    %eax,%eax
80103537:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103538:	89 ca                	mov    %ecx,%edx
8010353a:	ec                   	in     (%dx),%al
8010353b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353e:	89 fa                	mov    %edi,%edx
80103540:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103543:	b8 02 00 00 00       	mov    $0x2,%eax
80103548:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103549:	89 ca                	mov    %ecx,%edx
8010354b:	ec                   	in     (%dx),%al
8010354c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010354f:	89 fa                	mov    %edi,%edx
80103551:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103554:	b8 04 00 00 00       	mov    $0x4,%eax
80103559:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010355a:	89 ca                	mov    %ecx,%edx
8010355c:	ec                   	in     (%dx),%al
8010355d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103560:	89 fa                	mov    %edi,%edx
80103562:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103565:	b8 07 00 00 00       	mov    $0x7,%eax
8010356a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010356b:	89 ca                	mov    %ecx,%edx
8010356d:	ec                   	in     (%dx),%al
8010356e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103571:	89 fa                	mov    %edi,%edx
80103573:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103576:	b8 08 00 00 00       	mov    $0x8,%eax
8010357b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010357c:	89 ca                	mov    %ecx,%edx
8010357e:	ec                   	in     (%dx),%al
8010357f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103582:	89 fa                	mov    %edi,%edx
80103584:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103587:	b8 09 00 00 00       	mov    $0x9,%eax
8010358c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010358d:	89 ca                	mov    %ecx,%edx
8010358f:	ec                   	in     (%dx),%al
80103590:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103593:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103599:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010359c:	6a 18                	push   $0x18
8010359e:	50                   	push   %eax
8010359f:	8d 45 b8             	lea    -0x48(%ebp),%eax
801035a2:	50                   	push   %eax
801035a3:	e8 08 1c 00 00       	call   801051b0 <memcmp>
801035a8:	83 c4 10             	add    $0x10,%esp
801035ab:	85 c0                	test   %eax,%eax
801035ad:	0f 85 f5 fe ff ff    	jne    801034a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801035b3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801035b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ba:	89 f0                	mov    %esi,%eax
801035bc:	84 c0                	test   %al,%al
801035be:	75 78                	jne    80103638 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801035c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801035c3:	89 c2                	mov    %eax,%edx
801035c5:	83 e0 0f             	and    $0xf,%eax
801035c8:	c1 ea 04             	shr    $0x4,%edx
801035cb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035ce:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035d1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801035d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801035d7:	89 c2                	mov    %eax,%edx
801035d9:	83 e0 0f             	and    $0xf,%eax
801035dc:	c1 ea 04             	shr    $0x4,%edx
801035df:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035e2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801035e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801035eb:	89 c2                	mov    %eax,%edx
801035ed:	83 e0 0f             	and    $0xf,%eax
801035f0:	c1 ea 04             	shr    $0x4,%edx
801035f3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035f6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035f9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801035fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801035ff:	89 c2                	mov    %eax,%edx
80103601:	83 e0 0f             	and    $0xf,%eax
80103604:	c1 ea 04             	shr    $0x4,%edx
80103607:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010360a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010360d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103610:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103613:	89 c2                	mov    %eax,%edx
80103615:	83 e0 0f             	and    $0xf,%eax
80103618:	c1 ea 04             	shr    $0x4,%edx
8010361b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010361e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103621:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103624:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103627:	89 c2                	mov    %eax,%edx
80103629:	83 e0 0f             	and    $0xf,%eax
8010362c:	c1 ea 04             	shr    $0x4,%edx
8010362f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103632:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103635:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103638:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010363b:	89 03                	mov    %eax,(%ebx)
8010363d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103640:	89 43 04             	mov    %eax,0x4(%ebx)
80103643:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103646:	89 43 08             	mov    %eax,0x8(%ebx)
80103649:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010364c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010364f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103652:	89 43 10             	mov    %eax,0x10(%ebx)
80103655:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103658:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010365b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103662:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103665:	5b                   	pop    %ebx
80103666:	5e                   	pop    %esi
80103667:	5f                   	pop    %edi
80103668:	5d                   	pop    %ebp
80103669:	c3                   	ret
8010366a:	66 90                	xchg   %ax,%ax
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103670:	8b 0d 68 29 11 80    	mov    0x80112968,%ecx
80103676:	85 c9                	test   %ecx,%ecx
80103678:	0f 8e 8a 00 00 00    	jle    80103708 <install_trans+0x98>
{
8010367e:	55                   	push   %ebp
8010367f:	89 e5                	mov    %esp,%ebp
80103681:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103682:	31 ff                	xor    %edi,%edi
{
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103690:	a1 54 29 11 80       	mov    0x80112954,%eax
80103695:	83 ec 08             	sub    $0x8,%esp
80103698:	01 f8                	add    %edi,%eax
8010369a:	83 c0 01             	add    $0x1,%eax
8010369d:	50                   	push   %eax
8010369e:	ff 35 64 29 11 80    	push   0x80112964
801036a4:	e8 27 ca ff ff       	call   801000d0 <bread>
801036a9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036ab:	58                   	pop    %eax
801036ac:	5a                   	pop    %edx
801036ad:	ff 34 bd 6c 29 11 80 	push   -0x7feed694(,%edi,4)
801036b4:	ff 35 64 29 11 80    	push   0x80112964
  for (tail = 0; tail < log.lh.n; tail++) {
801036ba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036bd:	e8 0e ca ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801036c2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036c5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801036c7:	8d 46 5c             	lea    0x5c(%esi),%eax
801036ca:	68 00 02 00 00       	push   $0x200
801036cf:	50                   	push   %eax
801036d0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801036d3:	50                   	push   %eax
801036d4:	e8 27 1b 00 00       	call   80105200 <memmove>
    bwrite(dbuf);  // write dst to disk
801036d9:	89 1c 24             	mov    %ebx,(%esp)
801036dc:	e8 cf ca ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801036e1:	89 34 24             	mov    %esi,(%esp)
801036e4:	e8 07 cb ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801036e9:	89 1c 24             	mov    %ebx,(%esp)
801036ec:	e8 ff ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 3d 68 29 11 80    	cmp    %edi,0x80112968
801036fa:	7f 94                	jg     80103690 <install_trans+0x20>
  }
}
801036fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ff:	5b                   	pop    %ebx
80103700:	5e                   	pop    %esi
80103701:	5f                   	pop    %edi
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret
80103704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103708:	c3                   	ret
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103710 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103717:	ff 35 54 29 11 80    	push   0x80112954
8010371d:	ff 35 64 29 11 80    	push   0x80112964
80103723:	e8 a8 c9 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103728:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010372b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010372d:	a1 68 29 11 80       	mov    0x80112968,%eax
80103732:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103735:	85 c0                	test   %eax,%eax
80103737:	7e 19                	jle    80103752 <write_head+0x42>
80103739:	31 d2                	xor    %edx,%edx
8010373b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103740:	8b 0c 95 6c 29 11 80 	mov    -0x7feed694(,%edx,4),%ecx
80103747:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010374b:	83 c2 01             	add    $0x1,%edx
8010374e:	39 d0                	cmp    %edx,%eax
80103750:	75 ee                	jne    80103740 <write_head+0x30>
  }
  bwrite(buf);
80103752:	83 ec 0c             	sub    $0xc,%esp
80103755:	53                   	push   %ebx
80103756:	e8 55 ca ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010375b:	89 1c 24             	mov    %ebx,(%esp)
8010375e:	e8 8d ca ff ff       	call   801001f0 <brelse>
}
80103763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103766:	83 c4 10             	add    $0x10,%esp
80103769:	c9                   	leave
8010376a:	c3                   	ret
8010376b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103770 <initlog>:
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
80103774:	83 ec 2c             	sub    $0x2c,%esp
80103777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010377a:	68 17 7e 10 80       	push   $0x80107e17
8010377f:	68 20 29 11 80       	push   $0x80112920
80103784:	e8 f7 16 00 00       	call   80104e80 <initlock>
  readsb(dev, &sb);
80103789:	58                   	pop    %eax
8010378a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010378d:	5a                   	pop    %edx
8010378e:	50                   	push   %eax
8010378f:	53                   	push   %ebx
80103790:	e8 7b e8 ff ff       	call   80102010 <readsb>
  log.start = sb.logstart;
80103795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103798:	59                   	pop    %ecx
  log.dev = dev;
80103799:	89 1d 64 29 11 80    	mov    %ebx,0x80112964
  log.size = sb.nlog;
8010379f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801037a2:	a3 54 29 11 80       	mov    %eax,0x80112954
  log.size = sb.nlog;
801037a7:	89 15 58 29 11 80    	mov    %edx,0x80112958
  struct buf *buf = bread(log.dev, log.start);
801037ad:	5a                   	pop    %edx
801037ae:	50                   	push   %eax
801037af:	53                   	push   %ebx
801037b0:	e8 1b c9 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801037b5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801037b8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801037bb:	89 1d 68 29 11 80    	mov    %ebx,0x80112968
  for (i = 0; i < log.lh.n; i++) {
801037c1:	85 db                	test   %ebx,%ebx
801037c3:	7e 1d                	jle    801037e2 <initlog+0x72>
801037c5:	31 d2                	xor    %edx,%edx
801037c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037ce:	00 
801037cf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801037d0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801037d4:	89 0c 95 6c 29 11 80 	mov    %ecx,-0x7feed694(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801037db:	83 c2 01             	add    $0x1,%edx
801037de:	39 d3                	cmp    %edx,%ebx
801037e0:	75 ee                	jne    801037d0 <initlog+0x60>
  brelse(buf);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	50                   	push   %eax
801037e6:	e8 05 ca ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801037eb:	e8 80 fe ff ff       	call   80103670 <install_trans>
  log.lh.n = 0;
801037f0:	c7 05 68 29 11 80 00 	movl   $0x0,0x80112968
801037f7:	00 00 00 
  write_head(); // clear the log
801037fa:	e8 11 ff ff ff       	call   80103710 <write_head>
}
801037ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103802:	83 c4 10             	add    $0x10,%esp
80103805:	c9                   	leave
80103806:	c3                   	ret
80103807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010380e:	00 
8010380f:	90                   	nop

80103810 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103816:	68 20 29 11 80       	push   $0x80112920
8010381b:	e8 50 18 00 00       	call   80105070 <acquire>
80103820:	83 c4 10             	add    $0x10,%esp
80103823:	eb 18                	jmp    8010383d <begin_op+0x2d>
80103825:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103828:	83 ec 08             	sub    $0x8,%esp
8010382b:	68 20 29 11 80       	push   $0x80112920
80103830:	68 20 29 11 80       	push   $0x80112920
80103835:	e8 b6 12 00 00       	call   80104af0 <sleep>
8010383a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010383d:	a1 60 29 11 80       	mov    0x80112960,%eax
80103842:	85 c0                	test   %eax,%eax
80103844:	75 e2                	jne    80103828 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103846:	a1 5c 29 11 80       	mov    0x8011295c,%eax
8010384b:	8b 15 68 29 11 80    	mov    0x80112968,%edx
80103851:	83 c0 01             	add    $0x1,%eax
80103854:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103857:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010385a:	83 fa 1e             	cmp    $0x1e,%edx
8010385d:	7f c9                	jg     80103828 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010385f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103862:	a3 5c 29 11 80       	mov    %eax,0x8011295c
      release(&log.lock);
80103867:	68 20 29 11 80       	push   $0x80112920
8010386c:	e8 9f 17 00 00       	call   80105010 <release>
      break;
    }
  }
}
80103871:	83 c4 10             	add    $0x10,%esp
80103874:	c9                   	leave
80103875:	c3                   	ret
80103876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010387d:	00 
8010387e:	66 90                	xchg   %ax,%ax

80103880 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103889:	68 20 29 11 80       	push   $0x80112920
8010388e:	e8 dd 17 00 00       	call   80105070 <acquire>
  log.outstanding -= 1;
80103893:	a1 5c 29 11 80       	mov    0x8011295c,%eax
  if(log.committing)
80103898:	8b 35 60 29 11 80    	mov    0x80112960,%esi
8010389e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801038a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801038a4:	89 1d 5c 29 11 80    	mov    %ebx,0x8011295c
  if(log.committing)
801038aa:	85 f6                	test   %esi,%esi
801038ac:	0f 85 22 01 00 00    	jne    801039d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801038b2:	85 db                	test   %ebx,%ebx
801038b4:	0f 85 f6 00 00 00    	jne    801039b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801038ba:	c7 05 60 29 11 80 01 	movl   $0x1,0x80112960
801038c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801038c4:	83 ec 0c             	sub    $0xc,%esp
801038c7:	68 20 29 11 80       	push   $0x80112920
801038cc:	e8 3f 17 00 00       	call   80105010 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801038d1:	8b 0d 68 29 11 80    	mov    0x80112968,%ecx
801038d7:	83 c4 10             	add    $0x10,%esp
801038da:	85 c9                	test   %ecx,%ecx
801038dc:	7f 42                	jg     80103920 <end_op+0xa0>
    acquire(&log.lock);
801038de:	83 ec 0c             	sub    $0xc,%esp
801038e1:	68 20 29 11 80       	push   $0x80112920
801038e6:	e8 85 17 00 00       	call   80105070 <acquire>
    log.committing = 0;
801038eb:	c7 05 60 29 11 80 00 	movl   $0x0,0x80112960
801038f2:	00 00 00 
    wakeup(&log);
801038f5:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
801038fc:	e8 af 12 00 00       	call   80104bb0 <wakeup>
    release(&log.lock);
80103901:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
80103908:	e8 03 17 00 00       	call   80105010 <release>
8010390d:	83 c4 10             	add    $0x10,%esp
}
80103910:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103913:	5b                   	pop    %ebx
80103914:	5e                   	pop    %esi
80103915:	5f                   	pop    %edi
80103916:	5d                   	pop    %ebp
80103917:	c3                   	ret
80103918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010391f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103920:	a1 54 29 11 80       	mov    0x80112954,%eax
80103925:	83 ec 08             	sub    $0x8,%esp
80103928:	01 d8                	add    %ebx,%eax
8010392a:	83 c0 01             	add    $0x1,%eax
8010392d:	50                   	push   %eax
8010392e:	ff 35 64 29 11 80    	push   0x80112964
80103934:	e8 97 c7 ff ff       	call   801000d0 <bread>
80103939:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010393b:	58                   	pop    %eax
8010393c:	5a                   	pop    %edx
8010393d:	ff 34 9d 6c 29 11 80 	push   -0x7feed694(,%ebx,4)
80103944:	ff 35 64 29 11 80    	push   0x80112964
  for (tail = 0; tail < log.lh.n; tail++) {
8010394a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010394d:	e8 7e c7 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103952:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103955:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103957:	8d 40 5c             	lea    0x5c(%eax),%eax
8010395a:	68 00 02 00 00       	push   $0x200
8010395f:	50                   	push   %eax
80103960:	8d 46 5c             	lea    0x5c(%esi),%eax
80103963:	50                   	push   %eax
80103964:	e8 97 18 00 00       	call   80105200 <memmove>
    bwrite(to);  // write the log
80103969:	89 34 24             	mov    %esi,(%esp)
8010396c:	e8 3f c8 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103971:	89 3c 24             	mov    %edi,(%esp)
80103974:	e8 77 c8 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103979:	89 34 24             	mov    %esi,(%esp)
8010397c:	e8 6f c8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103981:	83 c4 10             	add    $0x10,%esp
80103984:	3b 1d 68 29 11 80    	cmp    0x80112968,%ebx
8010398a:	7c 94                	jl     80103920 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010398c:	e8 7f fd ff ff       	call   80103710 <write_head>
    install_trans(); // Now install writes to home locations
80103991:	e8 da fc ff ff       	call   80103670 <install_trans>
    log.lh.n = 0;
80103996:	c7 05 68 29 11 80 00 	movl   $0x0,0x80112968
8010399d:	00 00 00 
    write_head();    // Erase the transaction from the log
801039a0:	e8 6b fd ff ff       	call   80103710 <write_head>
801039a5:	e9 34 ff ff ff       	jmp    801038de <end_op+0x5e>
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801039b0:	83 ec 0c             	sub    $0xc,%esp
801039b3:	68 20 29 11 80       	push   $0x80112920
801039b8:	e8 f3 11 00 00       	call   80104bb0 <wakeup>
  release(&log.lock);
801039bd:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
801039c4:	e8 47 16 00 00       	call   80105010 <release>
801039c9:	83 c4 10             	add    $0x10,%esp
}
801039cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039cf:	5b                   	pop    %ebx
801039d0:	5e                   	pop    %esi
801039d1:	5f                   	pop    %edi
801039d2:	5d                   	pop    %ebp
801039d3:	c3                   	ret
    panic("log.committing");
801039d4:	83 ec 0c             	sub    $0xc,%esp
801039d7:	68 1b 7e 10 80       	push   $0x80107e1b
801039dc:	e8 8f c9 ff ff       	call   80100370 <panic>
801039e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039e8:	00 
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039f7:	8b 15 68 29 11 80    	mov    0x80112968,%edx
{
801039fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a00:	83 fa 1d             	cmp    $0x1d,%edx
80103a03:	7f 7d                	jg     80103a82 <log_write+0x92>
80103a05:	a1 58 29 11 80       	mov    0x80112958,%eax
80103a0a:	83 e8 01             	sub    $0x1,%eax
80103a0d:	39 c2                	cmp    %eax,%edx
80103a0f:	7d 71                	jge    80103a82 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103a11:	a1 5c 29 11 80       	mov    0x8011295c,%eax
80103a16:	85 c0                	test   %eax,%eax
80103a18:	7e 75                	jle    80103a8f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	68 20 29 11 80       	push   $0x80112920
80103a22:	e8 49 16 00 00       	call   80105070 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a27:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103a2a:	83 c4 10             	add    $0x10,%esp
80103a2d:	31 c0                	xor    %eax,%eax
80103a2f:	8b 15 68 29 11 80    	mov    0x80112968,%edx
80103a35:	85 d2                	test   %edx,%edx
80103a37:	7f 0e                	jg     80103a47 <log_write+0x57>
80103a39:	eb 15                	jmp    80103a50 <log_write+0x60>
80103a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a40:	83 c0 01             	add    $0x1,%eax
80103a43:	39 c2                	cmp    %eax,%edx
80103a45:	74 29                	je     80103a70 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a47:	39 0c 85 6c 29 11 80 	cmp    %ecx,-0x7feed694(,%eax,4)
80103a4e:	75 f0                	jne    80103a40 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103a50:	89 0c 85 6c 29 11 80 	mov    %ecx,-0x7feed694(,%eax,4)
  if (i == log.lh.n)
80103a57:	39 c2                	cmp    %eax,%edx
80103a59:	74 1c                	je     80103a77 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103a5b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103a61:	c7 45 08 20 29 11 80 	movl   $0x80112920,0x8(%ebp)
}
80103a68:	c9                   	leave
  release(&log.lock);
80103a69:	e9 a2 15 00 00       	jmp    80105010 <release>
80103a6e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103a70:	89 0c 95 6c 29 11 80 	mov    %ecx,-0x7feed694(,%edx,4)
    log.lh.n++;
80103a77:	83 c2 01             	add    $0x1,%edx
80103a7a:	89 15 68 29 11 80    	mov    %edx,0x80112968
80103a80:	eb d9                	jmp    80103a5b <log_write+0x6b>
    panic("too big a transaction");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 2a 7e 10 80       	push   $0x80107e2a
80103a8a:	e8 e1 c8 ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	68 40 7e 10 80       	push   $0x80107e40
80103a97:	e8 d4 c8 ff ff       	call   80100370 <panic>
80103a9c:	66 90                	xchg   %ax,%ax
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	53                   	push   %ebx
80103aa4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103aa7:	e8 64 09 00 00       	call   80104410 <cpuid>
80103aac:	89 c3                	mov    %eax,%ebx
80103aae:	e8 5d 09 00 00       	call   80104410 <cpuid>
80103ab3:	83 ec 04             	sub    $0x4,%esp
80103ab6:	53                   	push   %ebx
80103ab7:	50                   	push   %eax
80103ab8:	68 5b 7e 10 80       	push   $0x80107e5b
80103abd:	e8 ee cd ff ff       	call   801008b0 <cprintf>
  idtinit();       // load idt register
80103ac2:	e8 e9 28 00 00       	call   801063b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103ac7:	e8 e4 08 00 00       	call   801043b0 <mycpu>
80103acc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103ace:	b8 01 00 00 00       	mov    $0x1,%eax
80103ad3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80103ada:	e8 01 0c 00 00       	call   801046e0 <scheduler>
80103adf:	90                   	nop

80103ae0 <mpenter>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103ae6:	e8 c5 39 00 00       	call   801074b0 <switchkvm>
  seginit();
80103aeb:	e8 30 39 00 00       	call   80107420 <seginit>
  lapicinit();
80103af0:	e8 bb f7 ff ff       	call   801032b0 <lapicinit>
  mpmain();
80103af5:	e8 a6 ff ff ff       	call   80103aa0 <mpmain>
80103afa:	66 90                	xchg   %ax,%ax
80103afc:	66 90                	xchg   %ax,%ax
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <main>:
{
80103b00:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103b04:	83 e4 f0             	and    $0xfffffff0,%esp
80103b07:	ff 71 fc             	push   -0x4(%ecx)
80103b0a:	55                   	push   %ebp
80103b0b:	89 e5                	mov    %esp,%ebp
80103b0d:	53                   	push   %ebx
80103b0e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b0f:	83 ec 08             	sub    $0x8,%esp
80103b12:	68 00 00 40 80       	push   $0x80400000
80103b17:	68 50 67 11 80       	push   $0x80116750
80103b1c:	e8 9f f5 ff ff       	call   801030c0 <kinit1>
  kvmalloc();      // kernel page table
80103b21:	e8 4a 3e 00 00       	call   80107970 <kvmalloc>
  mpinit();        // detect other processors
80103b26:	e8 85 01 00 00       	call   80103cb0 <mpinit>
  lapicinit();     // interrupt controller
80103b2b:	e8 80 f7 ff ff       	call   801032b0 <lapicinit>
  seginit();       // segment descriptors
80103b30:	e8 eb 38 00 00       	call   80107420 <seginit>
  picinit();       // disable pic
80103b35:	e8 86 03 00 00       	call   80103ec0 <picinit>
  ioapicinit();    // another interrupt controller
80103b3a:	e8 51 f3 ff ff       	call   80102e90 <ioapicinit>
  consoleinit();   // console hardware
80103b3f:	e8 cc d9 ff ff       	call   80101510 <consoleinit>
  uartinit();      // serial port
80103b44:	e8 47 2b 00 00       	call   80106690 <uartinit>
  pinit();         // process table
80103b49:	e8 42 08 00 00       	call   80104390 <pinit>
  tvinit();        // trap vectors
80103b4e:	e8 dd 27 00 00       	call   80106330 <tvinit>
  binit();         // buffer cache
80103b53:	e8 e8 c4 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103b58:	e8 a3 dd ff ff       	call   80101900 <fileinit>
  ideinit();       // disk 
80103b5d:	e8 0e f1 ff ff       	call   80102c70 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b62:	83 c4 0c             	add    $0xc,%esp
80103b65:	68 8a 00 00 00       	push   $0x8a
80103b6a:	68 8c b4 10 80       	push   $0x8010b48c
80103b6f:	68 00 70 00 80       	push   $0x80007000
80103b74:	e8 87 16 00 00       	call   80105200 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103b79:	83 c4 10             	add    $0x10,%esp
80103b7c:	69 05 04 2a 11 80 b0 	imul   $0xb0,0x80112a04,%eax
80103b83:	00 00 00 
80103b86:	05 20 2a 11 80       	add    $0x80112a20,%eax
80103b8b:	3d 20 2a 11 80       	cmp    $0x80112a20,%eax
80103b90:	76 7e                	jbe    80103c10 <main+0x110>
80103b92:	bb 20 2a 11 80       	mov    $0x80112a20,%ebx
80103b97:	eb 20                	jmp    80103bb9 <main+0xb9>
80103b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ba0:	69 05 04 2a 11 80 b0 	imul   $0xb0,0x80112a04,%eax
80103ba7:	00 00 00 
80103baa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103bb0:	05 20 2a 11 80       	add    $0x80112a20,%eax
80103bb5:	39 c3                	cmp    %eax,%ebx
80103bb7:	73 57                	jae    80103c10 <main+0x110>
    if(c == mycpu())  // We've started already.
80103bb9:	e8 f2 07 00 00       	call   801043b0 <mycpu>
80103bbe:	39 c3                	cmp    %eax,%ebx
80103bc0:	74 de                	je     80103ba0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103bc2:	e8 69 f5 ff ff       	call   80103130 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103bc7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103bca:	c7 05 f8 6f 00 80 e0 	movl   $0x80103ae0,0x80006ff8
80103bd1:	3a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103bd4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103bdb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103bde:	05 00 10 00 00       	add    $0x1000,%eax
80103be3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103be8:	0f b6 03             	movzbl (%ebx),%eax
80103beb:	68 00 70 00 00       	push   $0x7000
80103bf0:	50                   	push   %eax
80103bf1:	e8 fa f7 ff ff       	call   801033f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bf6:	83 c4 10             	add    $0x10,%esp
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103c06:	85 c0                	test   %eax,%eax
80103c08:	74 f6                	je     80103c00 <main+0x100>
80103c0a:	eb 94                	jmp    80103ba0 <main+0xa0>
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c10:	83 ec 08             	sub    $0x8,%esp
80103c13:	68 00 00 00 8e       	push   $0x8e000000
80103c18:	68 00 00 40 80       	push   $0x80400000
80103c1d:	e8 3e f4 ff ff       	call   80103060 <kinit2>
  userinit();      // first user process
80103c22:	e8 39 08 00 00       	call   80104460 <userinit>
  mpmain();        // finish this processor's setup
80103c27:	e8 74 fe ff ff       	call   80103aa0 <mpmain>
80103c2c:	66 90                	xchg   %ax,%ax
80103c2e:	66 90                	xchg   %ax,%ax

80103c30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c35:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103c3b:	53                   	push   %ebx
  e = addr+len;
80103c3c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103c3f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103c42:	39 de                	cmp    %ebx,%esi
80103c44:	72 10                	jb     80103c56 <mpsearch1+0x26>
80103c46:	eb 50                	jmp    80103c98 <mpsearch1+0x68>
80103c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4f:	00 
80103c50:	89 fe                	mov    %edi,%esi
80103c52:	39 df                	cmp    %ebx,%edi
80103c54:	73 42                	jae    80103c98 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c56:	83 ec 04             	sub    $0x4,%esp
80103c59:	8d 7e 10             	lea    0x10(%esi),%edi
80103c5c:	6a 04                	push   $0x4
80103c5e:	68 6f 7e 10 80       	push   $0x80107e6f
80103c63:	56                   	push   %esi
80103c64:	e8 47 15 00 00       	call   801051b0 <memcmp>
80103c69:	83 c4 10             	add    $0x10,%esp
80103c6c:	85 c0                	test   %eax,%eax
80103c6e:	75 e0                	jne    80103c50 <mpsearch1+0x20>
80103c70:	89 f2                	mov    %esi,%edx
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103c78:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103c7b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103c7e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103c80:	39 fa                	cmp    %edi,%edx
80103c82:	75 f4                	jne    80103c78 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c84:	84 c0                	test   %al,%al
80103c86:	75 c8                	jne    80103c50 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c8b:	89 f0                	mov    %esi,%eax
80103c8d:	5b                   	pop    %ebx
80103c8e:	5e                   	pop    %esi
80103c8f:	5f                   	pop    %edi
80103c90:	5d                   	pop    %ebp
80103c91:	c3                   	ret
80103c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c9b:	31 f6                	xor    %esi,%esi
}
80103c9d:	5b                   	pop    %ebx
80103c9e:	89 f0                	mov    %esi,%eax
80103ca0:	5e                   	pop    %esi
80103ca1:	5f                   	pop    %edi
80103ca2:	5d                   	pop    %ebp
80103ca3:	c3                   	ret
80103ca4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cab:	00 
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103cb0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cb9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103cc0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103cc7:	c1 e0 08             	shl    $0x8,%eax
80103cca:	09 d0                	or     %edx,%eax
80103ccc:	c1 e0 04             	shl    $0x4,%eax
80103ccf:	75 1b                	jne    80103cec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103cd1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103cd8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103cdf:	c1 e0 08             	shl    $0x8,%eax
80103ce2:	09 d0                	or     %edx,%eax
80103ce4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103ce7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103cec:	ba 00 04 00 00       	mov    $0x400,%edx
80103cf1:	e8 3a ff ff ff       	call   80103c30 <mpsearch1>
80103cf6:	89 c3                	mov    %eax,%ebx
80103cf8:	85 c0                	test   %eax,%eax
80103cfa:	0f 84 58 01 00 00    	je     80103e58 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d00:	8b 73 04             	mov    0x4(%ebx),%esi
80103d03:	85 f6                	test   %esi,%esi
80103d05:	0f 84 3d 01 00 00    	je     80103e48 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
80103d0b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103d0e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103d14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d17:	6a 04                	push   $0x4
80103d19:	68 74 7e 10 80       	push   $0x80107e74
80103d1e:	50                   	push   %eax
80103d1f:	e8 8c 14 00 00       	call   801051b0 <memcmp>
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	85 c0                	test   %eax,%eax
80103d29:	0f 85 19 01 00 00    	jne    80103e48 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
80103d2f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103d36:	3c 01                	cmp    $0x1,%al
80103d38:	74 08                	je     80103d42 <mpinit+0x92>
80103d3a:	3c 04                	cmp    $0x4,%al
80103d3c:	0f 85 06 01 00 00    	jne    80103e48 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103d42:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103d49:	66 85 d2             	test   %dx,%dx
80103d4c:	74 22                	je     80103d70 <mpinit+0xc0>
80103d4e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103d51:	89 f0                	mov    %esi,%eax
  sum = 0;
80103d53:	31 d2                	xor    %edx,%edx
80103d55:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103d58:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103d5f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103d62:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103d64:	39 f8                	cmp    %edi,%eax
80103d66:	75 f0                	jne    80103d58 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103d68:	84 d2                	test   %dl,%dl
80103d6a:	0f 85 d8 00 00 00    	jne    80103e48 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103d70:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103d79:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103d7c:	a3 00 29 11 80       	mov    %eax,0x80112900
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d81:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103d88:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103d8e:	01 d7                	add    %edx,%edi
80103d90:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103d92:	bf 01 00 00 00       	mov    $0x1,%edi
80103d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d9e:	00 
80103d9f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103da0:	39 d0                	cmp    %edx,%eax
80103da2:	73 19                	jae    80103dbd <mpinit+0x10d>
    switch(*p){
80103da4:	0f b6 08             	movzbl (%eax),%ecx
80103da7:	80 f9 02             	cmp    $0x2,%cl
80103daa:	0f 84 80 00 00 00    	je     80103e30 <mpinit+0x180>
80103db0:	77 6e                	ja     80103e20 <mpinit+0x170>
80103db2:	84 c9                	test   %cl,%cl
80103db4:	74 3a                	je     80103df0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103db6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103db9:	39 d0                	cmp    %edx,%eax
80103dbb:	72 e7                	jb     80103da4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103dbd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dc0:	85 ff                	test   %edi,%edi
80103dc2:	0f 84 dd 00 00 00    	je     80103ea5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103dc8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103dcc:	74 15                	je     80103de3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dce:	b8 70 00 00 00       	mov    $0x70,%eax
80103dd3:	ba 22 00 00 00       	mov    $0x22,%edx
80103dd8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103dd9:	ba 23 00 00 00       	mov    $0x23,%edx
80103dde:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ddf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103de2:	ee                   	out    %al,(%dx)
  }
}
80103de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103de6:	5b                   	pop    %ebx
80103de7:	5e                   	pop    %esi
80103de8:	5f                   	pop    %edi
80103de9:	5d                   	pop    %ebp
80103dea:	c3                   	ret
80103deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103df0:	8b 0d 04 2a 11 80    	mov    0x80112a04,%ecx
80103df6:	83 f9 07             	cmp    $0x7,%ecx
80103df9:	7f 19                	jg     80103e14 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103dfb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103e01:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103e05:	83 c1 01             	add    $0x1,%ecx
80103e08:	89 0d 04 2a 11 80    	mov    %ecx,0x80112a04
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103e0e:	88 9e 20 2a 11 80    	mov    %bl,-0x7feed5e0(%esi)
      p += sizeof(struct mpproc);
80103e14:	83 c0 14             	add    $0x14,%eax
      continue;
80103e17:	eb 87                	jmp    80103da0 <mpinit+0xf0>
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103e20:	83 e9 03             	sub    $0x3,%ecx
80103e23:	80 f9 01             	cmp    $0x1,%cl
80103e26:	76 8e                	jbe    80103db6 <mpinit+0x106>
80103e28:	31 ff                	xor    %edi,%edi
80103e2a:	e9 71 ff ff ff       	jmp    80103da0 <mpinit+0xf0>
80103e2f:	90                   	nop
      ioapicid = ioapic->apicno;
80103e30:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103e34:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103e37:	88 0d 00 2a 11 80    	mov    %cl,0x80112a00
      continue;
80103e3d:	e9 5e ff ff ff       	jmp    80103da0 <mpinit+0xf0>
80103e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	68 79 7e 10 80       	push   $0x80107e79
80103e50:	e8 1b c5 ff ff       	call   80100370 <panic>
80103e55:	8d 76 00             	lea    0x0(%esi),%esi
{
80103e58:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103e5d:	eb 0b                	jmp    80103e6a <mpinit+0x1ba>
80103e5f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103e60:	89 f3                	mov    %esi,%ebx
80103e62:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103e68:	74 de                	je     80103e48 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e6a:	83 ec 04             	sub    $0x4,%esp
80103e6d:	8d 73 10             	lea    0x10(%ebx),%esi
80103e70:	6a 04                	push   $0x4
80103e72:	68 6f 7e 10 80       	push   $0x80107e6f
80103e77:	53                   	push   %ebx
80103e78:	e8 33 13 00 00       	call   801051b0 <memcmp>
80103e7d:	83 c4 10             	add    $0x10,%esp
80103e80:	85 c0                	test   %eax,%eax
80103e82:	75 dc                	jne    80103e60 <mpinit+0x1b0>
80103e84:	89 da                	mov    %ebx,%edx
80103e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e8d:	00 
80103e8e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103e90:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103e93:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103e96:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103e98:	39 d6                	cmp    %edx,%esi
80103e9a:	75 f4                	jne    80103e90 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e9c:	84 c0                	test   %al,%al
80103e9e:	75 c0                	jne    80103e60 <mpinit+0x1b0>
80103ea0:	e9 5b fe ff ff       	jmp    80103d00 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103ea5:	83 ec 0c             	sub    $0xc,%esp
80103ea8:	68 48 82 10 80       	push   $0x80108248
80103ead:	e8 be c4 ff ff       	call   80100370 <panic>
80103eb2:	66 90                	xchg   %ax,%ax
80103eb4:	66 90                	xchg   %ax,%ax
80103eb6:	66 90                	xchg   %ax,%ax
80103eb8:	66 90                	xchg   %ax,%ax
80103eba:	66 90                	xchg   %ax,%ax
80103ebc:	66 90                	xchg   %ax,%ax
80103ebe:	66 90                	xchg   %ax,%ax

80103ec0 <picinit>:
80103ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ec5:	ba 21 00 00 00       	mov    $0x21,%edx
80103eca:	ee                   	out    %al,(%dx)
80103ecb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103ed0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103ed1:	c3                   	ret
80103ed2:	66 90                	xchg   %ax,%ax
80103ed4:	66 90                	xchg   %ax,%ax
80103ed6:	66 90                	xchg   %ax,%ax
80103ed8:	66 90                	xchg   %ax,%ax
80103eda:	66 90                	xchg   %ax,%ax
80103edc:	66 90                	xchg   %ax,%ax
80103ede:	66 90                	xchg   %ax,%ax

80103ee0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	8b 75 08             	mov    0x8(%ebp),%esi
80103eec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103eef:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103ef5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103efb:	e8 20 da ff ff       	call   80101920 <filealloc>
80103f00:	89 06                	mov    %eax,(%esi)
80103f02:	85 c0                	test   %eax,%eax
80103f04:	0f 84 a5 00 00 00    	je     80103faf <pipealloc+0xcf>
80103f0a:	e8 11 da ff ff       	call   80101920 <filealloc>
80103f0f:	89 07                	mov    %eax,(%edi)
80103f11:	85 c0                	test   %eax,%eax
80103f13:	0f 84 84 00 00 00    	je     80103f9d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103f19:	e8 12 f2 ff ff       	call   80103130 <kalloc>
80103f1e:	89 c3                	mov    %eax,%ebx
80103f20:	85 c0                	test   %eax,%eax
80103f22:	0f 84 a0 00 00 00    	je     80103fc8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103f28:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103f2f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103f32:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103f35:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103f3c:	00 00 00 
  p->nwrite = 0;
80103f3f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103f46:	00 00 00 
  p->nread = 0;
80103f49:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103f50:	00 00 00 
  initlock(&p->lock, "pipe");
80103f53:	68 91 7e 10 80       	push   $0x80107e91
80103f58:	50                   	push   %eax
80103f59:	e8 22 0f 00 00       	call   80104e80 <initlock>
  (*f0)->type = FD_PIPE;
80103f5e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103f60:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103f63:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103f69:	8b 06                	mov    (%esi),%eax
80103f6b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103f6f:	8b 06                	mov    (%esi),%eax
80103f71:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103f75:	8b 06                	mov    (%esi),%eax
80103f77:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103f7a:	8b 07                	mov    (%edi),%eax
80103f7c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103f82:	8b 07                	mov    (%edi),%eax
80103f84:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103f88:	8b 07                	mov    (%edi),%eax
80103f8a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103f8e:	8b 07                	mov    (%edi),%eax
80103f90:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103f93:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103f95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f98:	5b                   	pop    %ebx
80103f99:	5e                   	pop    %esi
80103f9a:	5f                   	pop    %edi
80103f9b:	5d                   	pop    %ebp
80103f9c:	c3                   	ret
  if(*f0)
80103f9d:	8b 06                	mov    (%esi),%eax
80103f9f:	85 c0                	test   %eax,%eax
80103fa1:	74 1e                	je     80103fc1 <pipealloc+0xe1>
    fileclose(*f0);
80103fa3:	83 ec 0c             	sub    $0xc,%esp
80103fa6:	50                   	push   %eax
80103fa7:	e8 34 da ff ff       	call   801019e0 <fileclose>
80103fac:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103faf:	8b 07                	mov    (%edi),%eax
80103fb1:	85 c0                	test   %eax,%eax
80103fb3:	74 0c                	je     80103fc1 <pipealloc+0xe1>
    fileclose(*f1);
80103fb5:	83 ec 0c             	sub    $0xc,%esp
80103fb8:	50                   	push   %eax
80103fb9:	e8 22 da ff ff       	call   801019e0 <fileclose>
80103fbe:	83 c4 10             	add    $0x10,%esp
  return -1;
80103fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fc6:	eb cd                	jmp    80103f95 <pipealloc+0xb5>
  if(*f0)
80103fc8:	8b 06                	mov    (%esi),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	75 d5                	jne    80103fa3 <pipealloc+0xc3>
80103fce:	eb df                	jmp    80103faf <pipealloc+0xcf>

80103fd0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103fdb:	83 ec 0c             	sub    $0xc,%esp
80103fde:	53                   	push   %ebx
80103fdf:	e8 8c 10 00 00       	call   80105070 <acquire>
  if(writable){
80103fe4:	83 c4 10             	add    $0x10,%esp
80103fe7:	85 f6                	test   %esi,%esi
80103fe9:	74 65                	je     80104050 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103feb:	83 ec 0c             	sub    $0xc,%esp
80103fee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103ff4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103ffb:	00 00 00 
    wakeup(&p->nread);
80103ffe:	50                   	push   %eax
80103fff:	e8 ac 0b 00 00       	call   80104bb0 <wakeup>
80104004:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104007:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010400d:	85 d2                	test   %edx,%edx
8010400f:	75 0a                	jne    8010401b <pipeclose+0x4b>
80104011:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104017:	85 c0                	test   %eax,%eax
80104019:	74 15                	je     80104030 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010401b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010401e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104021:	5b                   	pop    %ebx
80104022:	5e                   	pop    %esi
80104023:	5d                   	pop    %ebp
    release(&p->lock);
80104024:	e9 e7 0f 00 00       	jmp    80105010 <release>
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104030:	83 ec 0c             	sub    $0xc,%esp
80104033:	53                   	push   %ebx
80104034:	e8 d7 0f 00 00       	call   80105010 <release>
    kfree((char*)p);
80104039:	83 c4 10             	add    $0x10,%esp
8010403c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010403f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104042:	5b                   	pop    %ebx
80104043:	5e                   	pop    %esi
80104044:	5d                   	pop    %ebp
    kfree((char*)p);
80104045:	e9 26 ef ff ff       	jmp    80102f70 <kfree>
8010404a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104059:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104060:	00 00 00 
    wakeup(&p->nwrite);
80104063:	50                   	push   %eax
80104064:	e8 47 0b 00 00       	call   80104bb0 <wakeup>
80104069:	83 c4 10             	add    $0x10,%esp
8010406c:	eb 99                	jmp    80104007 <pipeclose+0x37>
8010406e:	66 90                	xchg   %ax,%ax

80104070 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 28             	sub    $0x28,%esp
80104079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010407c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010407f:	53                   	push   %ebx
80104080:	e8 eb 0f 00 00       	call   80105070 <acquire>
  for(i = 0; i < n; i++){
80104085:	83 c4 10             	add    $0x10,%esp
80104088:	85 ff                	test   %edi,%edi
8010408a:	0f 8e ce 00 00 00    	jle    8010415e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104090:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80104096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104099:	89 7d 10             	mov    %edi,0x10(%ebp)
8010409c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010409f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801040a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801040a5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040ab:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801040b1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040b7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801040bd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801040c0:	0f 85 b6 00 00 00    	jne    8010417c <pipewrite+0x10c>
801040c6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801040c9:	eb 3b                	jmp    80104106 <pipewrite+0x96>
801040cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801040d0:	e8 5b 03 00 00       	call   80104430 <myproc>
801040d5:	8b 48 24             	mov    0x24(%eax),%ecx
801040d8:	85 c9                	test   %ecx,%ecx
801040da:	75 34                	jne    80104110 <pipewrite+0xa0>
      wakeup(&p->nread);
801040dc:	83 ec 0c             	sub    $0xc,%esp
801040df:	56                   	push   %esi
801040e0:	e8 cb 0a 00 00       	call   80104bb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801040e5:	58                   	pop    %eax
801040e6:	5a                   	pop    %edx
801040e7:	53                   	push   %ebx
801040e8:	57                   	push   %edi
801040e9:	e8 02 0a 00 00       	call   80104af0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801040f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801040fa:	83 c4 10             	add    $0x10,%esp
801040fd:	05 00 02 00 00       	add    $0x200,%eax
80104102:	39 c2                	cmp    %eax,%edx
80104104:	75 2a                	jne    80104130 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80104106:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010410c:	85 c0                	test   %eax,%eax
8010410e:	75 c0                	jne    801040d0 <pipewrite+0x60>
        release(&p->lock);
80104110:	83 ec 0c             	sub    $0xc,%esp
80104113:	53                   	push   %ebx
80104114:	e8 f7 0e 00 00       	call   80105010 <release>
        return -1;
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104121:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104124:	5b                   	pop    %ebx
80104125:	5e                   	pop    %esi
80104126:	5f                   	pop    %edi
80104127:	5d                   	pop    %ebp
80104128:	c3                   	ret
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104130:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104133:	8d 42 01             	lea    0x1(%edx),%eax
80104136:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010413c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010413f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80104145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104148:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010414c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104150:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104153:	39 c1                	cmp    %eax,%ecx
80104155:	0f 85 50 ff ff ff    	jne    801040ab <pipewrite+0x3b>
8010415b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010415e:	83 ec 0c             	sub    $0xc,%esp
80104161:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104167:	50                   	push   %eax
80104168:	e8 43 0a 00 00       	call   80104bb0 <wakeup>
  release(&p->lock);
8010416d:	89 1c 24             	mov    %ebx,(%esp)
80104170:	e8 9b 0e 00 00       	call   80105010 <release>
  return n;
80104175:	83 c4 10             	add    $0x10,%esp
80104178:	89 f8                	mov    %edi,%eax
8010417a:	eb a5                	jmp    80104121 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010417c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010417f:	eb b2                	jmp    80104133 <pipewrite+0xc3>
80104181:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104188:	00 
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104190 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 18             	sub    $0x18,%esp
80104199:	8b 75 08             	mov    0x8(%ebp),%esi
8010419c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010419f:	56                   	push   %esi
801041a0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801041a6:	e8 c5 0e 00 00       	call   80105070 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801041ab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801041ba:	74 2f                	je     801041eb <piperead+0x5b>
801041bc:	eb 37                	jmp    801041f5 <piperead+0x65>
801041be:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801041c0:	e8 6b 02 00 00       	call   80104430 <myproc>
801041c5:	8b 40 24             	mov    0x24(%eax),%eax
801041c8:	85 c0                	test   %eax,%eax
801041ca:	0f 85 80 00 00 00    	jne    80104250 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801041d0:	83 ec 08             	sub    $0x8,%esp
801041d3:	56                   	push   %esi
801041d4:	53                   	push   %ebx
801041d5:	e8 16 09 00 00       	call   80104af0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801041da:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801041e0:	83 c4 10             	add    $0x10,%esp
801041e3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801041e9:	75 0a                	jne    801041f5 <piperead+0x65>
801041eb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801041f1:	85 d2                	test   %edx,%edx
801041f3:	75 cb                	jne    801041c0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801041f8:	31 db                	xor    %ebx,%ebx
801041fa:	85 c9                	test   %ecx,%ecx
801041fc:	7f 26                	jg     80104224 <piperead+0x94>
801041fe:	eb 2c                	jmp    8010422c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104200:	8d 48 01             	lea    0x1(%eax),%ecx
80104203:	25 ff 01 00 00       	and    $0x1ff,%eax
80104208:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010420e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104213:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104216:	83 c3 01             	add    $0x1,%ebx
80104219:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010421c:	74 0e                	je     8010422c <piperead+0x9c>
8010421e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80104224:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010422a:	75 d4                	jne    80104200 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010422c:	83 ec 0c             	sub    $0xc,%esp
8010422f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104235:	50                   	push   %eax
80104236:	e8 75 09 00 00       	call   80104bb0 <wakeup>
  release(&p->lock);
8010423b:	89 34 24             	mov    %esi,(%esp)
8010423e:	e8 cd 0d 00 00       	call   80105010 <release>
  return i;
80104243:	83 c4 10             	add    $0x10,%esp
}
80104246:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104249:	89 d8                	mov    %ebx,%eax
8010424b:	5b                   	pop    %ebx
8010424c:	5e                   	pop    %esi
8010424d:	5f                   	pop    %edi
8010424e:	5d                   	pop    %ebp
8010424f:	c3                   	ret
      release(&p->lock);
80104250:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104253:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104258:	56                   	push   %esi
80104259:	e8 b2 0d 00 00       	call   80105010 <release>
      return -1;
8010425e:	83 c4 10             	add    $0x10,%esp
}
80104261:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104264:	89 d8                	mov    %ebx,%eax
80104266:	5b                   	pop    %ebx
80104267:	5e                   	pop    %esi
80104268:	5f                   	pop    %edi
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret
8010426b:	66 90                	xchg   %ax,%ax
8010426d:	66 90                	xchg   %ax,%ax
8010426f:	90                   	nop

80104270 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104274:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
{
80104279:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010427c:	68 a0 2f 11 80       	push   $0x80112fa0
80104281:	e8 ea 0d 00 00       	call   80105070 <acquire>
80104286:	83 c4 10             	add    $0x10,%esp
80104289:	eb 10                	jmp    8010429b <allocproc+0x2b>
8010428b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104290:	83 c3 7c             	add    $0x7c,%ebx
80104293:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80104299:	74 75                	je     80104310 <allocproc+0xa0>
    if(p->state == UNUSED)
8010429b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010429e:	85 c0                	test   %eax,%eax
801042a0:	75 ee                	jne    80104290 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801042a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801042a7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801042aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801042b1:	89 43 10             	mov    %eax,0x10(%ebx)
801042b4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801042b7:	68 a0 2f 11 80       	push   $0x80112fa0
  p->pid = nextpid++;
801042bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801042c2:	e8 49 0d 00 00       	call   80105010 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801042c7:	e8 64 ee ff ff       	call   80103130 <kalloc>
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	89 43 08             	mov    %eax,0x8(%ebx)
801042d2:	85 c0                	test   %eax,%eax
801042d4:	74 53                	je     80104329 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801042d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801042dc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801042df:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801042e4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801042e7:	c7 40 14 22 63 10 80 	movl   $0x80106322,0x14(%eax)
  p->context = (struct context*)sp;
801042ee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801042f1:	6a 14                	push   $0x14
801042f3:	6a 00                	push   $0x0
801042f5:	50                   	push   %eax
801042f6:	e8 75 0e 00 00       	call   80105170 <memset>
  p->context->eip = (uint)forkret;
801042fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801042fe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104301:	c7 40 10 40 43 10 80 	movl   $0x80104340,0x10(%eax)
}
80104308:	89 d8                	mov    %ebx,%eax
8010430a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010430d:	c9                   	leave
8010430e:	c3                   	ret
8010430f:	90                   	nop
  release(&ptable.lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104313:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104315:	68 a0 2f 11 80       	push   $0x80112fa0
8010431a:	e8 f1 0c 00 00       	call   80105010 <release>
  return 0;
8010431f:	83 c4 10             	add    $0x10,%esp
}
80104322:	89 d8                	mov    %ebx,%eax
80104324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104327:	c9                   	leave
80104328:	c3                   	ret
    p->state = UNUSED;
80104329:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104330:	31 db                	xor    %ebx,%ebx
80104332:	eb ee                	jmp    80104322 <allocproc+0xb2>
80104334:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010433b:	00 
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104346:	68 a0 2f 11 80       	push   $0x80112fa0
8010434b:	e8 c0 0c 00 00       	call   80105010 <release>

  if (first) {
80104350:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104355:	83 c4 10             	add    $0x10,%esp
80104358:	85 c0                	test   %eax,%eax
8010435a:	75 04                	jne    80104360 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010435c:	c9                   	leave
8010435d:	c3                   	ret
8010435e:	66 90                	xchg   %ax,%ax
    first = 0;
80104360:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104367:	00 00 00 
    iinit(ROOTDEV);
8010436a:	83 ec 0c             	sub    $0xc,%esp
8010436d:	6a 01                	push   $0x1
8010436f:	e8 dc dc ff ff       	call   80102050 <iinit>
    initlog(ROOTDEV);
80104374:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010437b:	e8 f0 f3 ff ff       	call   80103770 <initlog>
}
80104380:	83 c4 10             	add    $0x10,%esp
80104383:	c9                   	leave
80104384:	c3                   	ret
80104385:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010438c:	00 
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <pinit>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104396:	68 96 7e 10 80       	push   $0x80107e96
8010439b:	68 a0 2f 11 80       	push   $0x80112fa0
801043a0:	e8 db 0a 00 00       	call   80104e80 <initlock>
}
801043a5:	83 c4 10             	add    $0x10,%esp
801043a8:	c9                   	leave
801043a9:	c3                   	ret
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <mycpu>:
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043b5:	9c                   	pushf
801043b6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043b7:	f6 c4 02             	test   $0x2,%ah
801043ba:	75 46                	jne    80104402 <mycpu+0x52>
  apicid = lapicid();
801043bc:	e8 df ef ff ff       	call   801033a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801043c1:	8b 35 04 2a 11 80    	mov    0x80112a04,%esi
801043c7:	85 f6                	test   %esi,%esi
801043c9:	7e 2a                	jle    801043f5 <mycpu+0x45>
801043cb:	31 d2                	xor    %edx,%edx
801043cd:	eb 08                	jmp    801043d7 <mycpu+0x27>
801043cf:	90                   	nop
801043d0:	83 c2 01             	add    $0x1,%edx
801043d3:	39 f2                	cmp    %esi,%edx
801043d5:	74 1e                	je     801043f5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801043d7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801043dd:	0f b6 99 20 2a 11 80 	movzbl -0x7feed5e0(%ecx),%ebx
801043e4:	39 c3                	cmp    %eax,%ebx
801043e6:	75 e8                	jne    801043d0 <mycpu+0x20>
}
801043e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801043eb:	8d 81 20 2a 11 80    	lea    -0x7feed5e0(%ecx),%eax
}
801043f1:	5b                   	pop    %ebx
801043f2:	5e                   	pop    %esi
801043f3:	5d                   	pop    %ebp
801043f4:	c3                   	ret
  panic("unknown apicid\n");
801043f5:	83 ec 0c             	sub    $0xc,%esp
801043f8:	68 9d 7e 10 80       	push   $0x80107e9d
801043fd:	e8 6e bf ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80104402:	83 ec 0c             	sub    $0xc,%esp
80104405:	68 68 82 10 80       	push   $0x80108268
8010440a:	e8 61 bf ff ff       	call   80100370 <panic>
8010440f:	90                   	nop

80104410 <cpuid>:
cpuid() {
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104416:	e8 95 ff ff ff       	call   801043b0 <mycpu>
}
8010441b:	c9                   	leave
  return mycpu()-cpus;
8010441c:	2d 20 2a 11 80       	sub    $0x80112a20,%eax
80104421:	c1 f8 04             	sar    $0x4,%eax
80104424:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010442a:	c3                   	ret
8010442b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104430 <myproc>:
myproc(void) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104437:	e8 e4 0a 00 00       	call   80104f20 <pushcli>
  c = mycpu();
8010443c:	e8 6f ff ff ff       	call   801043b0 <mycpu>
  p = c->proc;
80104441:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104447:	e8 24 0b 00 00       	call   80104f70 <popcli>
}
8010444c:	89 d8                	mov    %ebx,%eax
8010444e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104451:	c9                   	leave
80104452:	c3                   	ret
80104453:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010445a:	00 
8010445b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104460 <userinit>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104467:	e8 04 fe ff ff       	call   80104270 <allocproc>
8010446c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010446e:	a3 d4 4e 11 80       	mov    %eax,0x80114ed4
  if((p->pgdir = setupkvm()) == 0)
80104473:	e8 78 34 00 00       	call   801078f0 <setupkvm>
80104478:	89 43 04             	mov    %eax,0x4(%ebx)
8010447b:	85 c0                	test   %eax,%eax
8010447d:	0f 84 bd 00 00 00    	je     80104540 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104483:	83 ec 04             	sub    $0x4,%esp
80104486:	68 2c 00 00 00       	push   $0x2c
8010448b:	68 60 b4 10 80       	push   $0x8010b460
80104490:	50                   	push   %eax
80104491:	e8 3a 31 00 00       	call   801075d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104496:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104499:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010449f:	6a 4c                	push   $0x4c
801044a1:	6a 00                	push   $0x0
801044a3:	ff 73 18             	push   0x18(%ebx)
801044a6:	e8 c5 0c 00 00       	call   80105170 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044ab:	8b 43 18             	mov    0x18(%ebx),%eax
801044ae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801044b3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044b6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801044bb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801044bf:	8b 43 18             	mov    0x18(%ebx),%eax
801044c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801044c6:	8b 43 18             	mov    0x18(%ebx),%eax
801044c9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801044cd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801044d1:	8b 43 18             	mov    0x18(%ebx),%eax
801044d4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801044d8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801044dc:	8b 43 18             	mov    0x18(%ebx),%eax
801044df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801044e6:	8b 43 18             	mov    0x18(%ebx),%eax
801044e9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801044f0:	8b 43 18             	mov    0x18(%ebx),%eax
801044f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801044fa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044fd:	6a 10                	push   $0x10
801044ff:	68 c6 7e 10 80       	push   $0x80107ec6
80104504:	50                   	push   %eax
80104505:	e8 16 0e 00 00       	call   80105320 <safestrcpy>
  p->cwd = namei("/");
8010450a:	c7 04 24 cf 7e 10 80 	movl   $0x80107ecf,(%esp)
80104511:	e8 3a e6 ff ff       	call   80102b50 <namei>
80104516:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104519:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104520:	e8 4b 0b 00 00       	call   80105070 <acquire>
  p->state = RUNNABLE;
80104525:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010452c:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104533:	e8 d8 0a 00 00       	call   80105010 <release>
}
80104538:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010453b:	83 c4 10             	add    $0x10,%esp
8010453e:	c9                   	leave
8010453f:	c3                   	ret
    panic("userinit: out of memory?");
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 ad 7e 10 80       	push   $0x80107ead
80104548:	e8 23 be ff ff       	call   80100370 <panic>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi

80104550 <growproc>:
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104558:	e8 c3 09 00 00       	call   80104f20 <pushcli>
  c = mycpu();
8010455d:	e8 4e fe ff ff       	call   801043b0 <mycpu>
  p = c->proc;
80104562:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104568:	e8 03 0a 00 00       	call   80104f70 <popcli>
  sz = curproc->sz;
8010456d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010456f:	85 f6                	test   %esi,%esi
80104571:	7f 1d                	jg     80104590 <growproc+0x40>
  } else if(n < 0){
80104573:	75 3b                	jne    801045b0 <growproc+0x60>
  switchuvm(curproc);
80104575:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104578:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010457a:	53                   	push   %ebx
8010457b:	e8 40 2f 00 00       	call   801074c0 <switchuvm>
  return 0;
80104580:	83 c4 10             	add    $0x10,%esp
80104583:	31 c0                	xor    %eax,%eax
}
80104585:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104590:	83 ec 04             	sub    $0x4,%esp
80104593:	01 c6                	add    %eax,%esi
80104595:	56                   	push   %esi
80104596:	50                   	push   %eax
80104597:	ff 73 04             	push   0x4(%ebx)
8010459a:	e8 81 31 00 00       	call   80107720 <allocuvm>
8010459f:	83 c4 10             	add    $0x10,%esp
801045a2:	85 c0                	test   %eax,%eax
801045a4:	75 cf                	jne    80104575 <growproc+0x25>
      return -1;
801045a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ab:	eb d8                	jmp    80104585 <growproc+0x35>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801045b0:	83 ec 04             	sub    $0x4,%esp
801045b3:	01 c6                	add    %eax,%esi
801045b5:	56                   	push   %esi
801045b6:	50                   	push   %eax
801045b7:	ff 73 04             	push   0x4(%ebx)
801045ba:	e8 81 32 00 00       	call   80107840 <deallocuvm>
801045bf:	83 c4 10             	add    $0x10,%esp
801045c2:	85 c0                	test   %eax,%eax
801045c4:	75 af                	jne    80104575 <growproc+0x25>
801045c6:	eb de                	jmp    801045a6 <growproc+0x56>
801045c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045cf:	00 

801045d0 <fork>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801045d9:	e8 42 09 00 00       	call   80104f20 <pushcli>
  c = mycpu();
801045de:	e8 cd fd ff ff       	call   801043b0 <mycpu>
  p = c->proc;
801045e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e9:	e8 82 09 00 00       	call   80104f70 <popcli>
  if((np = allocproc()) == 0){
801045ee:	e8 7d fc ff ff       	call   80104270 <allocproc>
801045f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801045f6:	85 c0                	test   %eax,%eax
801045f8:	0f 84 d6 00 00 00    	je     801046d4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801045fe:	83 ec 08             	sub    $0x8,%esp
80104601:	ff 33                	push   (%ebx)
80104603:	89 c7                	mov    %eax,%edi
80104605:	ff 73 04             	push   0x4(%ebx)
80104608:	e8 d3 33 00 00       	call   801079e0 <copyuvm>
8010460d:	83 c4 10             	add    $0x10,%esp
80104610:	89 47 04             	mov    %eax,0x4(%edi)
80104613:	85 c0                	test   %eax,%eax
80104615:	0f 84 9a 00 00 00    	je     801046b5 <fork+0xe5>
  np->sz = curproc->sz;
8010461b:	8b 03                	mov    (%ebx),%eax
8010461d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104620:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104622:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104625:	89 c8                	mov    %ecx,%eax
80104627:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010462a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010462f:	8b 73 18             	mov    0x18(%ebx),%esi
80104632:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104634:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104636:	8b 40 18             	mov    0x18(%eax),%eax
80104639:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104640:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104644:	85 c0                	test   %eax,%eax
80104646:	74 13                	je     8010465b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	50                   	push   %eax
8010464c:	e8 3f d3 ff ff       	call   80101990 <filedup>
80104651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010465b:	83 c6 01             	add    $0x1,%esi
8010465e:	83 fe 10             	cmp    $0x10,%esi
80104661:	75 dd                	jne    80104640 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104663:	83 ec 0c             	sub    $0xc,%esp
80104666:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104669:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010466c:	e8 cf db ff ff       	call   80102240 <idup>
80104671:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104674:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104677:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010467a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010467d:	6a 10                	push   $0x10
8010467f:	53                   	push   %ebx
80104680:	50                   	push   %eax
80104681:	e8 9a 0c 00 00       	call   80105320 <safestrcpy>
  pid = np->pid;
80104686:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104689:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104690:	e8 db 09 00 00       	call   80105070 <acquire>
  np->state = RUNNABLE;
80104695:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010469c:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
801046a3:	e8 68 09 00 00       	call   80105010 <release>
  return pid;
801046a8:	83 c4 10             	add    $0x10,%esp
}
801046ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ae:	89 d8                	mov    %ebx,%eax
801046b0:	5b                   	pop    %ebx
801046b1:	5e                   	pop    %esi
801046b2:	5f                   	pop    %edi
801046b3:	5d                   	pop    %ebp
801046b4:	c3                   	ret
    kfree(np->kstack);
801046b5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	ff 73 08             	push   0x8(%ebx)
801046be:	e8 ad e8 ff ff       	call   80102f70 <kfree>
    np->kstack = 0;
801046c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801046ca:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801046cd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801046d4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046d9:	eb d0                	jmp    801046ab <fork+0xdb>
801046db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046e0 <scheduler>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801046e9:	e8 c2 fc ff ff       	call   801043b0 <mycpu>
  c->proc = 0;
801046ee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801046f5:	00 00 00 
  struct cpu *c = mycpu();
801046f8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801046fa:	8d 78 04             	lea    0x4(%eax),%edi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104700:	fb                   	sti
    acquire(&ptable.lock);
80104701:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104704:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
    acquire(&ptable.lock);
80104709:	68 a0 2f 11 80       	push   $0x80112fa0
8010470e:	e8 5d 09 00 00       	call   80105070 <acquire>
80104713:	83 c4 10             	add    $0x10,%esp
80104716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010471d:	00 
8010471e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104720:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104724:	75 33                	jne    80104759 <scheduler+0x79>
      switchuvm(p);
80104726:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104729:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010472f:	53                   	push   %ebx
80104730:	e8 8b 2d 00 00       	call   801074c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104735:	58                   	pop    %eax
80104736:	5a                   	pop    %edx
80104737:	ff 73 1c             	push   0x1c(%ebx)
8010473a:	57                   	push   %edi
      p->state = RUNNING;
8010473b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104742:	e8 34 0c 00 00       	call   8010537b <swtch>
      switchkvm();
80104747:	e8 64 2d 00 00       	call   801074b0 <switchkvm>
      c->proc = 0;
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104756:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104759:	83 c3 7c             	add    $0x7c,%ebx
8010475c:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80104762:	75 bc                	jne    80104720 <scheduler+0x40>
    release(&ptable.lock);
80104764:	83 ec 0c             	sub    $0xc,%esp
80104767:	68 a0 2f 11 80       	push   $0x80112fa0
8010476c:	e8 9f 08 00 00       	call   80105010 <release>
    sti();
80104771:	83 c4 10             	add    $0x10,%esp
80104774:	eb 8a                	jmp    80104700 <scheduler+0x20>
80104776:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010477d:	00 
8010477e:	66 90                	xchg   %ax,%ax

80104780 <sched>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
  pushcli();
80104785:	e8 96 07 00 00       	call   80104f20 <pushcli>
  c = mycpu();
8010478a:	e8 21 fc ff ff       	call   801043b0 <mycpu>
  p = c->proc;
8010478f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104795:	e8 d6 07 00 00       	call   80104f70 <popcli>
  if(!holding(&ptable.lock))
8010479a:	83 ec 0c             	sub    $0xc,%esp
8010479d:	68 a0 2f 11 80       	push   $0x80112fa0
801047a2:	e8 29 08 00 00       	call   80104fd0 <holding>
801047a7:	83 c4 10             	add    $0x10,%esp
801047aa:	85 c0                	test   %eax,%eax
801047ac:	74 4f                	je     801047fd <sched+0x7d>
  if(mycpu()->ncli != 1)
801047ae:	e8 fd fb ff ff       	call   801043b0 <mycpu>
801047b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801047ba:	75 68                	jne    80104824 <sched+0xa4>
  if(p->state == RUNNING)
801047bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801047c0:	74 55                	je     80104817 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047c2:	9c                   	pushf
801047c3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047c4:	f6 c4 02             	test   $0x2,%ah
801047c7:	75 41                	jne    8010480a <sched+0x8a>
  intena = mycpu()->intena;
801047c9:	e8 e2 fb ff ff       	call   801043b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801047ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801047d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801047d7:	e8 d4 fb ff ff       	call   801043b0 <mycpu>
801047dc:	83 ec 08             	sub    $0x8,%esp
801047df:	ff 70 04             	push   0x4(%eax)
801047e2:	53                   	push   %ebx
801047e3:	e8 93 0b 00 00       	call   8010537b <swtch>
  mycpu()->intena = intena;
801047e8:	e8 c3 fb ff ff       	call   801043b0 <mycpu>
}
801047ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801047f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801047f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047f9:	5b                   	pop    %ebx
801047fa:	5e                   	pop    %esi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret
    panic("sched ptable.lock");
801047fd:	83 ec 0c             	sub    $0xc,%esp
80104800:	68 d1 7e 10 80       	push   $0x80107ed1
80104805:	e8 66 bb ff ff       	call   80100370 <panic>
    panic("sched interruptible");
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	68 fd 7e 10 80       	push   $0x80107efd
80104812:	e8 59 bb ff ff       	call   80100370 <panic>
    panic("sched running");
80104817:	83 ec 0c             	sub    $0xc,%esp
8010481a:	68 ef 7e 10 80       	push   $0x80107eef
8010481f:	e8 4c bb ff ff       	call   80100370 <panic>
    panic("sched locks");
80104824:	83 ec 0c             	sub    $0xc,%esp
80104827:	68 e3 7e 10 80       	push   $0x80107ee3
8010482c:	e8 3f bb ff ff       	call   80100370 <panic>
80104831:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104838:	00 
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <exit>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
80104846:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104849:	e8 e2 fb ff ff       	call   80104430 <myproc>
  if(curproc == initproc)
8010484e:	39 05 d4 4e 11 80    	cmp    %eax,0x80114ed4
80104854:	0f 84 fd 00 00 00    	je     80104957 <exit+0x117>
8010485a:	89 c3                	mov    %eax,%ebx
8010485c:	8d 70 28             	lea    0x28(%eax),%esi
8010485f:	8d 78 68             	lea    0x68(%eax),%edi
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104868:	8b 06                	mov    (%esi),%eax
8010486a:	85 c0                	test   %eax,%eax
8010486c:	74 12                	je     80104880 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010486e:	83 ec 0c             	sub    $0xc,%esp
80104871:	50                   	push   %eax
80104872:	e8 69 d1 ff ff       	call   801019e0 <fileclose>
      curproc->ofile[fd] = 0;
80104877:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010487d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104880:	83 c6 04             	add    $0x4,%esi
80104883:	39 f7                	cmp    %esi,%edi
80104885:	75 e1                	jne    80104868 <exit+0x28>
  begin_op();
80104887:	e8 84 ef ff ff       	call   80103810 <begin_op>
  iput(curproc->cwd);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	ff 73 68             	push   0x68(%ebx)
80104892:	e8 09 db ff ff       	call   801023a0 <iput>
  end_op();
80104897:	e8 e4 ef ff ff       	call   80103880 <end_op>
  curproc->cwd = 0;
8010489c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801048a3:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
801048aa:	e8 c1 07 00 00       	call   80105070 <acquire>
  wakeup1(curproc->parent);
801048af:	8b 53 14             	mov    0x14(%ebx),%edx
801048b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b5:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
801048ba:	eb 0e                	jmp    801048ca <exit+0x8a>
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c0:	83 c0 7c             	add    $0x7c,%eax
801048c3:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801048c8:	74 1c                	je     801048e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801048ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048ce:	75 f0                	jne    801048c0 <exit+0x80>
801048d0:	3b 50 20             	cmp    0x20(%eax),%edx
801048d3:	75 eb                	jne    801048c0 <exit+0x80>
      p->state = RUNNABLE;
801048d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048dc:	83 c0 7c             	add    $0x7c,%eax
801048df:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801048e4:	75 e4                	jne    801048ca <exit+0x8a>
      p->parent = initproc;
801048e6:	8b 0d d4 4e 11 80    	mov    0x80114ed4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ec:	ba d4 2f 11 80       	mov    $0x80112fd4,%edx
801048f1:	eb 10                	jmp    80104903 <exit+0xc3>
801048f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048f8:	83 c2 7c             	add    $0x7c,%edx
801048fb:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80104901:	74 3b                	je     8010493e <exit+0xfe>
    if(p->parent == curproc){
80104903:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104906:	75 f0                	jne    801048f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80104908:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010490c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010490f:	75 e7                	jne    801048f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104911:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
80104916:	eb 12                	jmp    8010492a <exit+0xea>
80104918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491f:	00 
80104920:	83 c0 7c             	add    $0x7c,%eax
80104923:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80104928:	74 ce                	je     801048f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010492a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010492e:	75 f0                	jne    80104920 <exit+0xe0>
80104930:	3b 48 20             	cmp    0x20(%eax),%ecx
80104933:	75 eb                	jne    80104920 <exit+0xe0>
      p->state = RUNNABLE;
80104935:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010493c:	eb e2                	jmp    80104920 <exit+0xe0>
  curproc->state = ZOMBIE;
8010493e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104945:	e8 36 fe ff ff       	call   80104780 <sched>
  panic("zombie exit");
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	68 1e 7f 10 80       	push   $0x80107f1e
80104952:	e8 19 ba ff ff       	call   80100370 <panic>
    panic("init exiting");
80104957:	83 ec 0c             	sub    $0xc,%esp
8010495a:	68 11 7f 10 80       	push   $0x80107f11
8010495f:	e8 0c ba ff ff       	call   80100370 <panic>
80104964:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496b:	00 
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <wait>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
  pushcli();
80104975:	e8 a6 05 00 00       	call   80104f20 <pushcli>
  c = mycpu();
8010497a:	e8 31 fa ff ff       	call   801043b0 <mycpu>
  p = c->proc;
8010497f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104985:	e8 e6 05 00 00       	call   80104f70 <popcli>
  acquire(&ptable.lock);
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	68 a0 2f 11 80       	push   $0x80112fa0
80104992:	e8 d9 06 00 00       	call   80105070 <acquire>
80104997:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010499a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010499c:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
801049a1:	eb 10                	jmp    801049b3 <wait+0x43>
801049a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049a8:	83 c3 7c             	add    $0x7c,%ebx
801049ab:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
801049b1:	74 1b                	je     801049ce <wait+0x5e>
      if(p->parent != curproc)
801049b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801049b6:	75 f0                	jne    801049a8 <wait+0x38>
      if(p->state == ZOMBIE){
801049b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049bc:	74 62                	je     80104a20 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801049c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c6:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
801049cc:	75 e5                	jne    801049b3 <wait+0x43>
    if(!havekids || curproc->killed){
801049ce:	85 c0                	test   %eax,%eax
801049d0:	0f 84 a0 00 00 00    	je     80104a76 <wait+0x106>
801049d6:	8b 46 24             	mov    0x24(%esi),%eax
801049d9:	85 c0                	test   %eax,%eax
801049db:	0f 85 95 00 00 00    	jne    80104a76 <wait+0x106>
  pushcli();
801049e1:	e8 3a 05 00 00       	call   80104f20 <pushcli>
  c = mycpu();
801049e6:	e8 c5 f9 ff ff       	call   801043b0 <mycpu>
  p = c->proc;
801049eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049f1:	e8 7a 05 00 00       	call   80104f70 <popcli>
  if(p == 0)
801049f6:	85 db                	test   %ebx,%ebx
801049f8:	0f 84 8f 00 00 00    	je     80104a8d <wait+0x11d>
  p->chan = chan;
801049fe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104a01:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a08:	e8 73 fd ff ff       	call   80104780 <sched>
  p->chan = 0;
80104a0d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104a14:	eb 84                	jmp    8010499a <wait+0x2a>
80104a16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a1d:	00 
80104a1e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104a20:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104a23:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104a26:	ff 73 08             	push   0x8(%ebx)
80104a29:	e8 42 e5 ff ff       	call   80102f70 <kfree>
        p->kstack = 0;
80104a2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a35:	5a                   	pop    %edx
80104a36:	ff 73 04             	push   0x4(%ebx)
80104a39:	e8 32 2e 00 00       	call   80107870 <freevm>
        p->pid = 0;
80104a3e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a45:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a4c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a50:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a5e:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104a65:	e8 a6 05 00 00       	call   80105010 <release>
        return pid;
80104a6a:	83 c4 10             	add    $0x10,%esp
}
80104a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a70:	89 f0                	mov    %esi,%eax
80104a72:	5b                   	pop    %ebx
80104a73:	5e                   	pop    %esi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret
      release(&ptable.lock);
80104a76:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a79:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a7e:	68 a0 2f 11 80       	push   $0x80112fa0
80104a83:	e8 88 05 00 00       	call   80105010 <release>
      return -1;
80104a88:	83 c4 10             	add    $0x10,%esp
80104a8b:	eb e0                	jmp    80104a6d <wait+0xfd>
    panic("sleep");
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	68 2a 7f 10 80       	push   $0x80107f2a
80104a95:	e8 d6 b8 ff ff       	call   80100370 <panic>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <yield>:
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104aa7:	68 a0 2f 11 80       	push   $0x80112fa0
80104aac:	e8 bf 05 00 00       	call   80105070 <acquire>
  pushcli();
80104ab1:	e8 6a 04 00 00       	call   80104f20 <pushcli>
  c = mycpu();
80104ab6:	e8 f5 f8 ff ff       	call   801043b0 <mycpu>
  p = c->proc;
80104abb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ac1:	e8 aa 04 00 00       	call   80104f70 <popcli>
  myproc()->state = RUNNABLE;
80104ac6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104acd:	e8 ae fc ff ff       	call   80104780 <sched>
  release(&ptable.lock);
80104ad2:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104ad9:	e8 32 05 00 00       	call   80105010 <release>
}
80104ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae1:	83 c4 10             	add    $0x10,%esp
80104ae4:	c9                   	leave
80104ae5:	c3                   	ret
80104ae6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aed:	00 
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <sleep>:
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	83 ec 0c             	sub    $0xc,%esp
80104af9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104aff:	e8 1c 04 00 00       	call   80104f20 <pushcli>
  c = mycpu();
80104b04:	e8 a7 f8 ff ff       	call   801043b0 <mycpu>
  p = c->proc;
80104b09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b0f:	e8 5c 04 00 00       	call   80104f70 <popcli>
  if(p == 0)
80104b14:	85 db                	test   %ebx,%ebx
80104b16:	0f 84 87 00 00 00    	je     80104ba3 <sleep+0xb3>
  if(lk == 0)
80104b1c:	85 f6                	test   %esi,%esi
80104b1e:	74 76                	je     80104b96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b20:	81 fe a0 2f 11 80    	cmp    $0x80112fa0,%esi
80104b26:	74 50                	je     80104b78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 a0 2f 11 80       	push   $0x80112fa0
80104b30:	e8 3b 05 00 00       	call   80105070 <acquire>
    release(lk);
80104b35:	89 34 24             	mov    %esi,(%esp)
80104b38:	e8 d3 04 00 00       	call   80105010 <release>
  p->chan = chan;
80104b3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b47:	e8 34 fc ff ff       	call   80104780 <sched>
  p->chan = 0;
80104b4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b53:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104b5a:	e8 b1 04 00 00       	call   80105010 <release>
    acquire(lk);
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5f                   	pop    %edi
80104b6b:	5d                   	pop    %ebp
    acquire(lk);
80104b6c:	e9 ff 04 00 00       	jmp    80105070 <acquire>
80104b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b82:	e8 f9 fb ff ff       	call   80104780 <sched>
  p->chan = 0;
80104b87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b91:	5b                   	pop    %ebx
80104b92:	5e                   	pop    %esi
80104b93:	5f                   	pop    %edi
80104b94:	5d                   	pop    %ebp
80104b95:	c3                   	ret
    panic("sleep without lk");
80104b96:	83 ec 0c             	sub    $0xc,%esp
80104b99:	68 30 7f 10 80       	push   $0x80107f30
80104b9e:	e8 cd b7 ff ff       	call   80100370 <panic>
    panic("sleep");
80104ba3:	83 ec 0c             	sub    $0xc,%esp
80104ba6:	68 2a 7f 10 80       	push   $0x80107f2a
80104bab:	e8 c0 b7 ff ff       	call   80100370 <panic>

80104bb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 10             	sub    $0x10,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104bba:	68 a0 2f 11 80       	push   $0x80112fa0
80104bbf:	e8 ac 04 00 00       	call   80105070 <acquire>
80104bc4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc7:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
80104bcc:	eb 0c                	jmp    80104bda <wakeup+0x2a>
80104bce:	66 90                	xchg   %ax,%ax
80104bd0:	83 c0 7c             	add    $0x7c,%eax
80104bd3:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80104bd8:	74 1c                	je     80104bf6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80104bda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bde:	75 f0                	jne    80104bd0 <wakeup+0x20>
80104be0:	3b 58 20             	cmp    0x20(%eax),%ebx
80104be3:	75 eb                	jne    80104bd0 <wakeup+0x20>
      p->state = RUNNABLE;
80104be5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bec:	83 c0 7c             	add    $0x7c,%eax
80104bef:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80104bf4:	75 e4                	jne    80104bda <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104bf6:	c7 45 08 a0 2f 11 80 	movl   $0x80112fa0,0x8(%ebp)
}
80104bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c00:	c9                   	leave
  release(&ptable.lock);
80104c01:	e9 0a 04 00 00       	jmp    80105010 <release>
80104c06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c0d:	00 
80104c0e:	66 90                	xchg   %ax,%ax

80104c10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 10             	sub    $0x10,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104c1a:	68 a0 2f 11 80       	push   $0x80112fa0
80104c1f:	e8 4c 04 00 00       	call   80105070 <acquire>
80104c24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c27:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
80104c2c:	eb 0c                	jmp    80104c3a <kill+0x2a>
80104c2e:	66 90                	xchg   %ax,%ax
80104c30:	83 c0 7c             	add    $0x7c,%eax
80104c33:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80104c38:	74 36                	je     80104c70 <kill+0x60>
    if(p->pid == pid){
80104c3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c3d:	75 f1                	jne    80104c30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104c43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104c4a:	75 07                	jne    80104c53 <kill+0x43>
        p->state = RUNNABLE;
80104c4c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c53:	83 ec 0c             	sub    $0xc,%esp
80104c56:	68 a0 2f 11 80       	push   $0x80112fa0
80104c5b:	e8 b0 03 00 00       	call   80105010 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104c63:	83 c4 10             	add    $0x10,%esp
80104c66:	31 c0                	xor    %eax,%eax
}
80104c68:	c9                   	leave
80104c69:	c3                   	ret
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	68 a0 2f 11 80       	push   $0x80112fa0
80104c78:	e8 93 03 00 00       	call   80105010 <release>
}
80104c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c88:	c9                   	leave
80104c89:	c3                   	ret
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104c98:	53                   	push   %ebx
80104c99:	bb 40 30 11 80       	mov    $0x80113040,%ebx
80104c9e:	83 ec 3c             	sub    $0x3c,%esp
80104ca1:	eb 24                	jmp    80104cc7 <procdump+0x37>
80104ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	68 ef 80 10 80       	push   $0x801080ef
80104cb0:	e8 fb bb ff ff       	call   801008b0 <cprintf>
80104cb5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cb8:	83 c3 7c             	add    $0x7c,%ebx
80104cbb:	81 fb 40 4f 11 80    	cmp    $0x80114f40,%ebx
80104cc1:	0f 84 81 00 00 00    	je     80104d48 <procdump+0xb8>
    if(p->state == UNUSED)
80104cc7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	74 ea                	je     80104cb8 <procdump+0x28>
      state = "???";
80104cce:	ba 41 7f 10 80       	mov    $0x80107f41,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cd3:	83 f8 05             	cmp    $0x5,%eax
80104cd6:	77 11                	ja     80104ce9 <procdump+0x59>
80104cd8:	8b 14 85 80 85 10 80 	mov    -0x7fef7a80(,%eax,4),%edx
      state = "???";
80104cdf:	b8 41 7f 10 80       	mov    $0x80107f41,%eax
80104ce4:	85 d2                	test   %edx,%edx
80104ce6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104ce9:	53                   	push   %ebx
80104cea:	52                   	push   %edx
80104ceb:	ff 73 a4             	push   -0x5c(%ebx)
80104cee:	68 45 7f 10 80       	push   $0x80107f45
80104cf3:	e8 b8 bb ff ff       	call   801008b0 <cprintf>
    if(p->state == SLEEPING){
80104cf8:	83 c4 10             	add    $0x10,%esp
80104cfb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104cff:	75 a7                	jne    80104ca8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d01:	83 ec 08             	sub    $0x8,%esp
80104d04:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d07:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104d0a:	50                   	push   %eax
80104d0b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104d0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d11:	83 c0 08             	add    $0x8,%eax
80104d14:	50                   	push   %eax
80104d15:	e8 86 01 00 00       	call   80104ea0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d1a:	83 c4 10             	add    $0x10,%esp
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
80104d20:	8b 17                	mov    (%edi),%edx
80104d22:	85 d2                	test   %edx,%edx
80104d24:	74 82                	je     80104ca8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104d26:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104d29:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104d2c:	52                   	push   %edx
80104d2d:	68 81 7c 10 80       	push   $0x80107c81
80104d32:	e8 79 bb ff ff       	call   801008b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	39 f7                	cmp    %esi,%edi
80104d3c:	75 e2                	jne    80104d20 <procdump+0x90>
80104d3e:	e9 65 ff ff ff       	jmp    80104ca8 <procdump+0x18>
80104d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4b:	5b                   	pop    %ebx
80104d4c:	5e                   	pop    %esi
80104d4d:	5f                   	pop    %edi
80104d4e:	5d                   	pop    %ebp
80104d4f:	c3                   	ret

80104d50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d5a:	68 78 7f 10 80       	push   $0x80107f78
80104d5f:	8d 43 04             	lea    0x4(%ebx),%eax
80104d62:	50                   	push   %eax
80104d63:	e8 18 01 00 00       	call   80104e80 <initlock>
  lk->name = name;
80104d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d71:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d74:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d7b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d81:	c9                   	leave
80104d82:	c3                   	ret
80104d83:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d8a:	00 
80104d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d98:	8d 73 04             	lea    0x4(%ebx),%esi
80104d9b:	83 ec 0c             	sub    $0xc,%esp
80104d9e:	56                   	push   %esi
80104d9f:	e8 cc 02 00 00       	call   80105070 <acquire>
  while (lk->locked) {
80104da4:	8b 13                	mov    (%ebx),%edx
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	85 d2                	test   %edx,%edx
80104dab:	74 16                	je     80104dc3 <acquiresleep+0x33>
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104db0:	83 ec 08             	sub    $0x8,%esp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
80104db5:	e8 36 fd ff ff       	call   80104af0 <sleep>
  while (lk->locked) {
80104dba:	8b 03                	mov    (%ebx),%eax
80104dbc:	83 c4 10             	add    $0x10,%esp
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	75 ed                	jne    80104db0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104dc3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104dc9:	e8 62 f6 ff ff       	call   80104430 <myproc>
80104dce:	8b 40 10             	mov    0x10(%eax),%eax
80104dd1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104dd4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104dd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dda:	5b                   	pop    %ebx
80104ddb:	5e                   	pop    %esi
80104ddc:	5d                   	pop    %ebp
  release(&lk->lk);
80104ddd:	e9 2e 02 00 00       	jmp    80105010 <release>
80104de2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104de9:	00 
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104df8:	8d 73 04             	lea    0x4(%ebx),%esi
80104dfb:	83 ec 0c             	sub    $0xc,%esp
80104dfe:	56                   	push   %esi
80104dff:	e8 6c 02 00 00       	call   80105070 <acquire>
  lk->locked = 0;
80104e04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e11:	89 1c 24             	mov    %ebx,(%esp)
80104e14:	e8 97 fd ff ff       	call   80104bb0 <wakeup>
  release(&lk->lk);
80104e19:	83 c4 10             	add    $0x10,%esp
80104e1c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
  release(&lk->lk);
80104e25:	e9 e6 01 00 00       	jmp    80105010 <release>
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	31 ff                	xor    %edi,%edi
80104e36:	56                   	push   %esi
80104e37:	53                   	push   %ebx
80104e38:	83 ec 18             	sub    $0x18,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e3e:	8d 73 04             	lea    0x4(%ebx),%esi
80104e41:	56                   	push   %esi
80104e42:	e8 29 02 00 00       	call   80105070 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e47:	8b 03                	mov    (%ebx),%eax
80104e49:	83 c4 10             	add    $0x10,%esp
80104e4c:	85 c0                	test   %eax,%eax
80104e4e:	75 18                	jne    80104e68 <holdingsleep+0x38>
  release(&lk->lk);
80104e50:	83 ec 0c             	sub    $0xc,%esp
80104e53:	56                   	push   %esi
80104e54:	e8 b7 01 00 00       	call   80105010 <release>
  return r;
}
80104e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e5c:	89 f8                	mov    %edi,%eax
80104e5e:	5b                   	pop    %ebx
80104e5f:	5e                   	pop    %esi
80104e60:	5f                   	pop    %edi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret
80104e63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104e68:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e6b:	e8 c0 f5 ff ff       	call   80104430 <myproc>
80104e70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e73:	0f 94 c0             	sete   %al
80104e76:	0f b6 c0             	movzbl %al,%eax
80104e79:	89 c7                	mov    %eax,%edi
80104e7b:	eb d3                	jmp    80104e50 <holdingsleep+0x20>
80104e7d:	66 90                	xchg   %ax,%ax
80104e7f:	90                   	nop

80104e80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret
80104e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104ea0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104eaa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ead:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104eb2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104eb7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ebc:	76 10                	jbe    80104ece <getcallerpcs+0x2e>
80104ebe:	eb 28                	jmp    80104ee8 <getcallerpcs+0x48>
80104ec0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104ec6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ecc:	77 1a                	ja     80104ee8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ece:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ed1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104ed4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104ed7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104ed9:	83 f8 0a             	cmp    $0xa,%eax
80104edc:	75 e2                	jne    80104ec0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee1:	c9                   	leave
80104ee2:	c3                   	ret
80104ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ee8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80104eeb:	83 c1 28             	add    $0x28,%ecx
80104eee:	89 ca                	mov    %ecx,%edx
80104ef0:	29 c2                	sub    %eax,%edx
80104ef2:	83 e2 04             	and    $0x4,%edx
80104ef5:	74 11                	je     80104f08 <getcallerpcs+0x68>
    pcs[i] = 0;
80104ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104efd:	83 c0 04             	add    $0x4,%eax
80104f00:	39 c1                	cmp    %eax,%ecx
80104f02:	74 da                	je     80104ede <getcallerpcs+0x3e>
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104f08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f0e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104f11:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104f18:	39 c1                	cmp    %eax,%ecx
80104f1a:	75 ec                	jne    80104f08 <getcallerpcs+0x68>
80104f1c:	eb c0                	jmp    80104ede <getcallerpcs+0x3e>
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
80104f27:	9c                   	pushf
80104f28:	5b                   	pop    %ebx
  asm volatile("cli");
80104f29:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104f2a:	e8 81 f4 ff ff       	call   801043b0 <mycpu>
80104f2f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f35:	85 c0                	test   %eax,%eax
80104f37:	74 17                	je     80104f50 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104f39:	e8 72 f4 ff ff       	call   801043b0 <mycpu>
80104f3e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f48:	c9                   	leave
80104f49:	c3                   	ret
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104f50:	e8 5b f4 ff ff       	call   801043b0 <mycpu>
80104f55:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f5b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104f61:	eb d6                	jmp    80104f39 <pushcli+0x19>
80104f63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f6a:	00 
80104f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104f70 <popcli>:

void
popcli(void)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f76:	9c                   	pushf
80104f77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f78:	f6 c4 02             	test   $0x2,%ah
80104f7b:	75 35                	jne    80104fb2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f7d:	e8 2e f4 ff ff       	call   801043b0 <mycpu>
80104f82:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f89:	78 34                	js     80104fbf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f8b:	e8 20 f4 ff ff       	call   801043b0 <mycpu>
80104f90:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f96:	85 d2                	test   %edx,%edx
80104f98:	74 06                	je     80104fa0 <popcli+0x30>
    sti();
}
80104f9a:	c9                   	leave
80104f9b:	c3                   	ret
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fa0:	e8 0b f4 ff ff       	call   801043b0 <mycpu>
80104fa5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104fab:	85 c0                	test   %eax,%eax
80104fad:	74 eb                	je     80104f9a <popcli+0x2a>
  asm volatile("sti");
80104faf:	fb                   	sti
}
80104fb0:	c9                   	leave
80104fb1:	c3                   	ret
    panic("popcli - interruptible");
80104fb2:	83 ec 0c             	sub    $0xc,%esp
80104fb5:	68 83 7f 10 80       	push   $0x80107f83
80104fba:	e8 b1 b3 ff ff       	call   80100370 <panic>
    panic("popcli");
80104fbf:	83 ec 0c             	sub    $0xc,%esp
80104fc2:	68 9a 7f 10 80       	push   $0x80107f9a
80104fc7:	e8 a4 b3 ff ff       	call   80100370 <panic>
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <holding>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	8b 75 08             	mov    0x8(%ebp),%esi
80104fd8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104fda:	e8 41 ff ff ff       	call   80104f20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fdf:	8b 06                	mov    (%esi),%eax
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	75 0b                	jne    80104ff0 <holding+0x20>
  popcli();
80104fe5:	e8 86 ff ff ff       	call   80104f70 <popcli>
}
80104fea:	89 d8                	mov    %ebx,%eax
80104fec:	5b                   	pop    %ebx
80104fed:	5e                   	pop    %esi
80104fee:	5d                   	pop    %ebp
80104fef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104ff0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ff3:	e8 b8 f3 ff ff       	call   801043b0 <mycpu>
80104ff8:	39 c3                	cmp    %eax,%ebx
80104ffa:	0f 94 c3             	sete   %bl
  popcli();
80104ffd:	e8 6e ff ff ff       	call   80104f70 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105002:	0f b6 db             	movzbl %bl,%ebx
}
80105005:	89 d8                	mov    %ebx,%eax
80105007:	5b                   	pop    %ebx
80105008:	5e                   	pop    %esi
80105009:	5d                   	pop    %ebp
8010500a:	c3                   	ret
8010500b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105010 <release>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105018:	e8 03 ff ff ff       	call   80104f20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010501d:	8b 03                	mov    (%ebx),%eax
8010501f:	85 c0                	test   %eax,%eax
80105021:	75 15                	jne    80105038 <release+0x28>
  popcli();
80105023:	e8 48 ff ff ff       	call   80104f70 <popcli>
    panic("release");
80105028:	83 ec 0c             	sub    $0xc,%esp
8010502b:	68 a1 7f 10 80       	push   $0x80107fa1
80105030:	e8 3b b3 ff ff       	call   80100370 <panic>
80105035:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105038:	8b 73 08             	mov    0x8(%ebx),%esi
8010503b:	e8 70 f3 ff ff       	call   801043b0 <mycpu>
80105040:	39 c6                	cmp    %eax,%esi
80105042:	75 df                	jne    80105023 <release+0x13>
  popcli();
80105044:	e8 27 ff ff ff       	call   80104f70 <popcli>
  lk->pcs[0] = 0;
80105049:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105050:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105057:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010505c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105062:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105065:	5b                   	pop    %ebx
80105066:	5e                   	pop    %esi
80105067:	5d                   	pop    %ebp
  popcli();
80105068:	e9 03 ff ff ff       	jmp    80104f70 <popcli>
8010506d:	8d 76 00             	lea    0x0(%esi),%esi

80105070 <acquire>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	53                   	push   %ebx
80105074:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105077:	e8 a4 fe ff ff       	call   80104f20 <pushcli>
  if(holding(lk))
8010507c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010507f:	e8 9c fe ff ff       	call   80104f20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105084:	8b 03                	mov    (%ebx),%eax
80105086:	85 c0                	test   %eax,%eax
80105088:	0f 85 b2 00 00 00    	jne    80105140 <acquire+0xd0>
  popcli();
8010508e:	e8 dd fe ff ff       	call   80104f70 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105093:	b9 01 00 00 00       	mov    $0x1,%ecx
80105098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010509f:	00 
  while(xchg(&lk->locked, 1) != 0)
801050a0:	8b 55 08             	mov    0x8(%ebp),%edx
801050a3:	89 c8                	mov    %ecx,%eax
801050a5:	f0 87 02             	lock xchg %eax,(%edx)
801050a8:	85 c0                	test   %eax,%eax
801050aa:	75 f4                	jne    801050a0 <acquire+0x30>
  __sync_synchronize();
801050ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050b4:	e8 f7 f2 ff ff       	call   801043b0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801050b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801050bc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801050be:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050c1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801050c7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801050cc:	77 32                	ja     80105100 <acquire+0x90>
  ebp = (uint*)v - 2;
801050ce:	89 e8                	mov    %ebp,%eax
801050d0:	eb 14                	jmp    801050e6 <acquire+0x76>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050e4:	77 1a                	ja     80105100 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801050e6:	8b 58 04             	mov    0x4(%eax),%ebx
801050e9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050ed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050f0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050f2:	83 fa 0a             	cmp    $0xa,%edx
801050f5:	75 e1                	jne    801050d8 <acquire+0x68>
}
801050f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050fa:	c9                   	leave
801050fb:	c3                   	ret
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105100:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80105104:	83 c1 34             	add    $0x34,%ecx
80105107:	89 ca                	mov    %ecx,%edx
80105109:	29 c2                	sub    %eax,%edx
8010510b:	83 e2 04             	and    $0x4,%edx
8010510e:	74 10                	je     80105120 <acquire+0xb0>
    pcs[i] = 0;
80105110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105116:	83 c0 04             	add    $0x4,%eax
80105119:	39 c1                	cmp    %eax,%ecx
8010511b:	74 da                	je     801050f7 <acquire+0x87>
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105126:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80105129:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80105130:	39 c1                	cmp    %eax,%ecx
80105132:	75 ec                	jne    80105120 <acquire+0xb0>
80105134:	eb c1                	jmp    801050f7 <acquire+0x87>
80105136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010513d:	00 
8010513e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80105140:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105143:	e8 68 f2 ff ff       	call   801043b0 <mycpu>
80105148:	39 c3                	cmp    %eax,%ebx
8010514a:	0f 85 3e ff ff ff    	jne    8010508e <acquire+0x1e>
  popcli();
80105150:	e8 1b fe ff ff       	call   80104f70 <popcli>
    panic("acquire");
80105155:	83 ec 0c             	sub    $0xc,%esp
80105158:	68 a9 7f 10 80       	push   $0x80107fa9
8010515d:	e8 0e b2 ff ff       	call   80100370 <panic>
80105162:	66 90                	xchg   %ax,%ax
80105164:	66 90                	xchg   %ax,%ax
80105166:	66 90                	xchg   %ax,%ax
80105168:	66 90                	xchg   %ax,%ax
8010516a:	66 90                	xchg   %ax,%ax
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	8b 55 08             	mov    0x8(%ebp),%edx
80105177:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010517a:	89 d0                	mov    %edx,%eax
8010517c:	09 c8                	or     %ecx,%eax
8010517e:	a8 03                	test   $0x3,%al
80105180:	75 1e                	jne    801051a0 <memset+0x30>
    c &= 0xFF;
80105182:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105186:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80105189:	89 d7                	mov    %edx,%edi
8010518b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80105191:	fc                   	cld
80105192:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105194:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105197:	89 d0                	mov    %edx,%eax
80105199:	c9                   	leave
8010519a:	c3                   	ret
8010519b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801051a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801051a3:	89 d7                	mov    %edx,%edi
801051a5:	fc                   	cld
801051a6:	f3 aa                	rep stos %al,%es:(%edi)
801051a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801051ab:	89 d0                	mov    %edx,%eax
801051ad:	c9                   	leave
801051ae:	c3                   	ret
801051af:	90                   	nop

801051b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	56                   	push   %esi
801051b4:	8b 75 10             	mov    0x10(%ebp),%esi
801051b7:	8b 45 08             	mov    0x8(%ebp),%eax
801051ba:	53                   	push   %ebx
801051bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051be:	85 f6                	test   %esi,%esi
801051c0:	74 2e                	je     801051f0 <memcmp+0x40>
801051c2:	01 c6                	add    %eax,%esi
801051c4:	eb 14                	jmp    801051da <memcmp+0x2a>
801051c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051cd:	00 
801051ce:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801051d0:	83 c0 01             	add    $0x1,%eax
801051d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801051d6:	39 f0                	cmp    %esi,%eax
801051d8:	74 16                	je     801051f0 <memcmp+0x40>
    if(*s1 != *s2)
801051da:	0f b6 08             	movzbl (%eax),%ecx
801051dd:	0f b6 1a             	movzbl (%edx),%ebx
801051e0:	38 d9                	cmp    %bl,%cl
801051e2:	74 ec                	je     801051d0 <memcmp+0x20>
      return *s1 - *s2;
801051e4:	0f b6 c1             	movzbl %cl,%eax
801051e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801051e9:	5b                   	pop    %ebx
801051ea:	5e                   	pop    %esi
801051eb:	5d                   	pop    %ebp
801051ec:	c3                   	ret
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
801051f0:	5b                   	pop    %ebx
  return 0;
801051f1:	31 c0                	xor    %eax,%eax
}
801051f3:	5e                   	pop    %esi
801051f4:	5d                   	pop    %ebp
801051f5:	c3                   	ret
801051f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fd:	00 
801051fe:	66 90                	xchg   %ax,%ax

80105200 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	8b 55 08             	mov    0x8(%ebp),%edx
80105207:	8b 45 10             	mov    0x10(%ebp),%eax
8010520a:	56                   	push   %esi
8010520b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010520e:	39 d6                	cmp    %edx,%esi
80105210:	73 26                	jae    80105238 <memmove+0x38>
80105212:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80105215:	39 ca                	cmp    %ecx,%edx
80105217:	73 1f                	jae    80105238 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105219:	85 c0                	test   %eax,%eax
8010521b:	74 0f                	je     8010522c <memmove+0x2c>
8010521d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80105220:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105224:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105227:	83 e8 01             	sub    $0x1,%eax
8010522a:	73 f4                	jae    80105220 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010522c:	5e                   	pop    %esi
8010522d:	89 d0                	mov    %edx,%eax
8010522f:	5f                   	pop    %edi
80105230:	5d                   	pop    %ebp
80105231:	c3                   	ret
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105238:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010523b:	89 d7                	mov    %edx,%edi
8010523d:	85 c0                	test   %eax,%eax
8010523f:	74 eb                	je     8010522c <memmove+0x2c>
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105248:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105249:	39 ce                	cmp    %ecx,%esi
8010524b:	75 fb                	jne    80105248 <memmove+0x48>
}
8010524d:	5e                   	pop    %esi
8010524e:	89 d0                	mov    %edx,%eax
80105250:	5f                   	pop    %edi
80105251:	5d                   	pop    %ebp
80105252:	c3                   	ret
80105253:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010525a:	00 
8010525b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105260 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105260:	eb 9e                	jmp    80105200 <memmove>
80105262:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105269:	00 
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105270 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	53                   	push   %ebx
80105274:	8b 55 10             	mov    0x10(%ebp),%edx
80105277:	8b 45 08             	mov    0x8(%ebp),%eax
8010527a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010527d:	85 d2                	test   %edx,%edx
8010527f:	75 16                	jne    80105297 <strncmp+0x27>
80105281:	eb 2d                	jmp    801052b0 <strncmp+0x40>
80105283:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105288:	3a 19                	cmp    (%ecx),%bl
8010528a:	75 12                	jne    8010529e <strncmp+0x2e>
    n--, p++, q++;
8010528c:	83 c0 01             	add    $0x1,%eax
8010528f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105292:	83 ea 01             	sub    $0x1,%edx
80105295:	74 19                	je     801052b0 <strncmp+0x40>
80105297:	0f b6 18             	movzbl (%eax),%ebx
8010529a:	84 db                	test   %bl,%bl
8010529c:	75 ea                	jne    80105288 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010529e:	0f b6 00             	movzbl (%eax),%eax
801052a1:	0f b6 11             	movzbl (%ecx),%edx
}
801052a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801052a8:	29 d0                	sub    %edx,%eax
}
801052aa:	c3                   	ret
801052ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801052b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801052b3:	31 c0                	xor    %eax,%eax
}
801052b5:	c9                   	leave
801052b6:	c3                   	ret
801052b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052be:	00 
801052bf:	90                   	nop

801052c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	8b 75 08             	mov    0x8(%ebp),%esi
801052c8:	53                   	push   %ebx
801052c9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801052cc:	89 f0                	mov    %esi,%eax
801052ce:	eb 15                	jmp    801052e5 <strncpy+0x25>
801052d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801052d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801052d7:	83 c0 01             	add    $0x1,%eax
801052da:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801052de:	88 48 ff             	mov    %cl,-0x1(%eax)
801052e1:	84 c9                	test   %cl,%cl
801052e3:	74 13                	je     801052f8 <strncpy+0x38>
801052e5:	89 d3                	mov    %edx,%ebx
801052e7:	83 ea 01             	sub    $0x1,%edx
801052ea:	85 db                	test   %ebx,%ebx
801052ec:	7f e2                	jg     801052d0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801052ee:	5b                   	pop    %ebx
801052ef:	89 f0                	mov    %esi,%eax
801052f1:	5e                   	pop    %esi
801052f2:	5f                   	pop    %edi
801052f3:	5d                   	pop    %ebp
801052f4:	c3                   	ret
801052f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801052f8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801052fb:	83 e9 01             	sub    $0x1,%ecx
801052fe:	85 d2                	test   %edx,%edx
80105300:	74 ec                	je     801052ee <strncpy+0x2e>
80105302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80105308:	83 c0 01             	add    $0x1,%eax
8010530b:	89 ca                	mov    %ecx,%edx
8010530d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80105311:	29 c2                	sub    %eax,%edx
80105313:	85 d2                	test   %edx,%edx
80105315:	7f f1                	jg     80105308 <strncpy+0x48>
}
80105317:	5b                   	pop    %ebx
80105318:	89 f0                	mov    %esi,%eax
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret
8010531e:	66 90                	xchg   %ax,%ax

80105320 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	8b 55 10             	mov    0x10(%ebp),%edx
80105327:	8b 75 08             	mov    0x8(%ebp),%esi
8010532a:	53                   	push   %ebx
8010532b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010532e:	85 d2                	test   %edx,%edx
80105330:	7e 25                	jle    80105357 <safestrcpy+0x37>
80105332:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105336:	89 f2                	mov    %esi,%edx
80105338:	eb 16                	jmp    80105350 <safestrcpy+0x30>
8010533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105340:	0f b6 08             	movzbl (%eax),%ecx
80105343:	83 c0 01             	add    $0x1,%eax
80105346:	83 c2 01             	add    $0x1,%edx
80105349:	88 4a ff             	mov    %cl,-0x1(%edx)
8010534c:	84 c9                	test   %cl,%cl
8010534e:	74 04                	je     80105354 <safestrcpy+0x34>
80105350:	39 d8                	cmp    %ebx,%eax
80105352:	75 ec                	jne    80105340 <safestrcpy+0x20>
    ;
  *s = 0;
80105354:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105357:	89 f0                	mov    %esi,%eax
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5d                   	pop    %ebp
8010535c:	c3                   	ret
8010535d:	8d 76 00             	lea    0x0(%esi),%esi

80105360 <strlen>:

int
strlen(const char *s)
{
80105360:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105361:	31 c0                	xor    %eax,%eax
{
80105363:	89 e5                	mov    %esp,%ebp
80105365:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105368:	80 3a 00             	cmpb   $0x0,(%edx)
8010536b:	74 0c                	je     80105379 <strlen+0x19>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
80105370:	83 c0 01             	add    $0x1,%eax
80105373:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105377:	75 f7                	jne    80105370 <strlen+0x10>
    ;
  return n;
}
80105379:	5d                   	pop    %ebp
8010537a:	c3                   	ret

8010537b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010537b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010537f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105383:	55                   	push   %ebp
  pushl %ebx
80105384:	53                   	push   %ebx
  pushl %esi
80105385:	56                   	push   %esi
  pushl %edi
80105386:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105387:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105389:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010538b:	5f                   	pop    %edi
  popl %esi
8010538c:	5e                   	pop    %esi
  popl %ebx
8010538d:	5b                   	pop    %ebx
  popl %ebp
8010538e:	5d                   	pop    %ebp
  ret
8010538f:	c3                   	ret

80105390 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 04             	sub    $0x4,%esp
80105397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010539a:	e8 91 f0 ff ff       	call   80104430 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010539f:	8b 00                	mov    (%eax),%eax
801053a1:	39 c3                	cmp    %eax,%ebx
801053a3:	73 1b                	jae    801053c0 <fetchint+0x30>
801053a5:	8d 53 04             	lea    0x4(%ebx),%edx
801053a8:	39 d0                	cmp    %edx,%eax
801053aa:	72 14                	jb     801053c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801053ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801053af:	8b 13                	mov    (%ebx),%edx
801053b1:	89 10                	mov    %edx,(%eax)
  return 0;
801053b3:	31 c0                	xor    %eax,%eax
}
801053b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053b8:	c9                   	leave
801053b9:	c3                   	ret
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c5:	eb ee                	jmp    801053b5 <fetchint+0x25>
801053c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ce:	00 
801053cf:	90                   	nop

801053d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	53                   	push   %ebx
801053d4:	83 ec 04             	sub    $0x4,%esp
801053d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801053da:	e8 51 f0 ff ff       	call   80104430 <myproc>

  if(addr >= curproc->sz)
801053df:	3b 18                	cmp    (%eax),%ebx
801053e1:	73 2d                	jae    80105410 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801053e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801053e6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801053e8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801053ea:	39 d3                	cmp    %edx,%ebx
801053ec:	73 22                	jae    80105410 <fetchstr+0x40>
801053ee:	89 d8                	mov    %ebx,%eax
801053f0:	eb 0d                	jmp    801053ff <fetchstr+0x2f>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053f8:	83 c0 01             	add    $0x1,%eax
801053fb:	39 d0                	cmp    %edx,%eax
801053fd:	73 11                	jae    80105410 <fetchstr+0x40>
    if(*s == 0)
801053ff:	80 38 00             	cmpb   $0x0,(%eax)
80105402:	75 f4                	jne    801053f8 <fetchstr+0x28>
      return s - *pp;
80105404:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105406:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105409:	c9                   	leave
8010540a:	c3                   	ret
8010540b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105410:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105418:	c9                   	leave
80105419:	c3                   	ret
8010541a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105420 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105425:	e8 06 f0 ff ff       	call   80104430 <myproc>
8010542a:	8b 55 08             	mov    0x8(%ebp),%edx
8010542d:	8b 40 18             	mov    0x18(%eax),%eax
80105430:	8b 40 44             	mov    0x44(%eax),%eax
80105433:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105436:	e8 f5 ef ff ff       	call   80104430 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010543b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010543e:	8b 00                	mov    (%eax),%eax
80105440:	39 c6                	cmp    %eax,%esi
80105442:	73 1c                	jae    80105460 <argint+0x40>
80105444:	8d 53 08             	lea    0x8(%ebx),%edx
80105447:	39 d0                	cmp    %edx,%eax
80105449:	72 15                	jb     80105460 <argint+0x40>
  *ip = *(int*)(addr);
8010544b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544e:	8b 53 04             	mov    0x4(%ebx),%edx
80105451:	89 10                	mov    %edx,(%eax)
  return 0;
80105453:	31 c0                	xor    %eax,%eax
}
80105455:	5b                   	pop    %ebx
80105456:	5e                   	pop    %esi
80105457:	5d                   	pop    %ebp
80105458:	c3                   	ret
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105465:	eb ee                	jmp    80105455 <argint+0x35>
80105467:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010546e:	00 
8010546f:	90                   	nop

80105470 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
80105476:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105479:	e8 b2 ef ff ff       	call   80104430 <myproc>
8010547e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105480:	e8 ab ef ff ff       	call   80104430 <myproc>
80105485:	8b 55 08             	mov    0x8(%ebp),%edx
80105488:	8b 40 18             	mov    0x18(%eax),%eax
8010548b:	8b 40 44             	mov    0x44(%eax),%eax
8010548e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105491:	e8 9a ef ff ff       	call   80104430 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105496:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105499:	8b 00                	mov    (%eax),%eax
8010549b:	39 c7                	cmp    %eax,%edi
8010549d:	73 31                	jae    801054d0 <argptr+0x60>
8010549f:	8d 4b 08             	lea    0x8(%ebx),%ecx
801054a2:	39 c8                	cmp    %ecx,%eax
801054a4:	72 2a                	jb     801054d0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054a6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801054a9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054ac:	85 d2                	test   %edx,%edx
801054ae:	78 20                	js     801054d0 <argptr+0x60>
801054b0:	8b 16                	mov    (%esi),%edx
801054b2:	39 d0                	cmp    %edx,%eax
801054b4:	73 1a                	jae    801054d0 <argptr+0x60>
801054b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801054b9:	01 c3                	add    %eax,%ebx
801054bb:	39 da                	cmp    %ebx,%edx
801054bd:	72 11                	jb     801054d0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801054bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801054c2:	89 02                	mov    %eax,(%edx)
  return 0;
801054c4:	31 c0                	xor    %eax,%eax
}
801054c6:	83 c4 0c             	add    $0xc,%esp
801054c9:	5b                   	pop    %ebx
801054ca:	5e                   	pop    %esi
801054cb:	5f                   	pop    %edi
801054cc:	5d                   	pop    %ebp
801054cd:	c3                   	ret
801054ce:	66 90                	xchg   %ax,%ax
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	eb ef                	jmp    801054c6 <argptr+0x56>
801054d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054de:	00 
801054df:	90                   	nop

801054e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054e5:	e8 46 ef ff ff       	call   80104430 <myproc>
801054ea:	8b 55 08             	mov    0x8(%ebp),%edx
801054ed:	8b 40 18             	mov    0x18(%eax),%eax
801054f0:	8b 40 44             	mov    0x44(%eax),%eax
801054f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801054f6:	e8 35 ef ff ff       	call   80104430 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054fb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054fe:	8b 00                	mov    (%eax),%eax
80105500:	39 c6                	cmp    %eax,%esi
80105502:	73 44                	jae    80105548 <argstr+0x68>
80105504:	8d 53 08             	lea    0x8(%ebx),%edx
80105507:	39 d0                	cmp    %edx,%eax
80105509:	72 3d                	jb     80105548 <argstr+0x68>
  *ip = *(int*)(addr);
8010550b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010550e:	e8 1d ef ff ff       	call   80104430 <myproc>
  if(addr >= curproc->sz)
80105513:	3b 18                	cmp    (%eax),%ebx
80105515:	73 31                	jae    80105548 <argstr+0x68>
  *pp = (char*)addr;
80105517:	8b 55 0c             	mov    0xc(%ebp),%edx
8010551a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010551c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010551e:	39 d3                	cmp    %edx,%ebx
80105520:	73 26                	jae    80105548 <argstr+0x68>
80105522:	89 d8                	mov    %ebx,%eax
80105524:	eb 11                	jmp    80105537 <argstr+0x57>
80105526:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010552d:	00 
8010552e:	66 90                	xchg   %ax,%ax
80105530:	83 c0 01             	add    $0x1,%eax
80105533:	39 d0                	cmp    %edx,%eax
80105535:	73 11                	jae    80105548 <argstr+0x68>
    if(*s == 0)
80105537:	80 38 00             	cmpb   $0x0,(%eax)
8010553a:	75 f4                	jne    80105530 <argstr+0x50>
      return s - *pp;
8010553c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010553e:	5b                   	pop    %ebx
8010553f:	5e                   	pop    %esi
80105540:	5d                   	pop    %ebp
80105541:	c3                   	ret
80105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105548:	5b                   	pop    %ebx
    return -1;
80105549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010554e:	5e                   	pop    %esi
8010554f:	5d                   	pop    %ebp
80105550:	c3                   	ret
80105551:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105558:	00 
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105560 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105567:	e8 c4 ee ff ff       	call   80104430 <myproc>
8010556c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010556e:	8b 40 18             	mov    0x18(%eax),%eax
80105571:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105574:	8d 50 ff             	lea    -0x1(%eax),%edx
80105577:	83 fa 14             	cmp    $0x14,%edx
8010557a:	77 24                	ja     801055a0 <syscall+0x40>
8010557c:	8b 14 85 a0 85 10 80 	mov    -0x7fef7a60(,%eax,4),%edx
80105583:	85 d2                	test   %edx,%edx
80105585:	74 19                	je     801055a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105587:	ff d2                	call   *%edx
80105589:	89 c2                	mov    %eax,%edx
8010558b:	8b 43 18             	mov    0x18(%ebx),%eax
8010558e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105594:	c9                   	leave
80105595:	c3                   	ret
80105596:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010559d:	00 
8010559e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801055a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801055a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801055a4:	50                   	push   %eax
801055a5:	ff 73 10             	push   0x10(%ebx)
801055a8:	68 b1 7f 10 80       	push   $0x80107fb1
801055ad:	e8 fe b2 ff ff       	call   801008b0 <cprintf>
    curproc->tf->eax = -1;
801055b2:	8b 43 18             	mov    0x18(%ebx),%eax
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801055bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c2:	c9                   	leave
801055c3:	c3                   	ret
801055c4:	66 90                	xchg   %ax,%ax
801055c6:	66 90                	xchg   %ax,%ax
801055c8:	66 90                	xchg   %ax,%ax
801055ca:	66 90                	xchg   %ax,%ax
801055cc:	66 90                	xchg   %ax,%ax
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801055d8:	53                   	push   %ebx
801055d9:	83 ec 34             	sub    $0x34,%esp
801055dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801055df:	8b 4d 08             	mov    0x8(%ebp),%ecx
801055e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801055e5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801055e8:	57                   	push   %edi
801055e9:	50                   	push   %eax
801055ea:	e8 81 d5 ff ff       	call   80102b70 <nameiparent>
801055ef:	83 c4 10             	add    $0x10,%esp
801055f2:	85 c0                	test   %eax,%eax
801055f4:	74 5e                	je     80105654 <create+0x84>
    return 0;
  ilock(dp);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	89 c3                	mov    %eax,%ebx
801055fb:	50                   	push   %eax
801055fc:	e8 6f cc ff ff       	call   80102270 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105601:	83 c4 0c             	add    $0xc,%esp
80105604:	6a 00                	push   $0x0
80105606:	57                   	push   %edi
80105607:	53                   	push   %ebx
80105608:	e8 b3 d1 ff ff       	call   801027c0 <dirlookup>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	89 c6                	mov    %eax,%esi
80105612:	85 c0                	test   %eax,%eax
80105614:	74 4a                	je     80105660 <create+0x90>
    iunlockput(dp);
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	53                   	push   %ebx
8010561a:	e8 e1 ce ff ff       	call   80102500 <iunlockput>
    ilock(ip);
8010561f:	89 34 24             	mov    %esi,(%esp)
80105622:	e8 49 cc ff ff       	call   80102270 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010562f:	75 17                	jne    80105648 <create+0x78>
80105631:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105636:	75 10                	jne    80105648 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010563b:	89 f0                	mov    %esi,%eax
8010563d:	5b                   	pop    %ebx
8010563e:	5e                   	pop    %esi
8010563f:	5f                   	pop    %edi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	56                   	push   %esi
8010564c:	e8 af ce ff ff       	call   80102500 <iunlockput>
    return 0;
80105651:	83 c4 10             	add    $0x10,%esp
}
80105654:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105657:	31 f6                	xor    %esi,%esi
}
80105659:	5b                   	pop    %ebx
8010565a:	89 f0                	mov    %esi,%eax
8010565c:	5e                   	pop    %esi
8010565d:	5f                   	pop    %edi
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105660:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	50                   	push   %eax
80105668:	ff 33                	push   (%ebx)
8010566a:	e8 91 ca ff ff       	call   80102100 <ialloc>
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	89 c6                	mov    %eax,%esi
80105674:	85 c0                	test   %eax,%eax
80105676:	0f 84 bc 00 00 00    	je     80105738 <create+0x168>
  ilock(ip);
8010567c:	83 ec 0c             	sub    $0xc,%esp
8010567f:	50                   	push   %eax
80105680:	e8 eb cb ff ff       	call   80102270 <ilock>
  ip->major = major;
80105685:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105689:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010568d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105691:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105695:	b8 01 00 00 00       	mov    $0x1,%eax
8010569a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010569e:	89 34 24             	mov    %esi,(%esp)
801056a1:	e8 1a cb ff ff       	call   801021c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056ae:	74 30                	je     801056e0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801056b0:	83 ec 04             	sub    $0x4,%esp
801056b3:	ff 76 04             	push   0x4(%esi)
801056b6:	57                   	push   %edi
801056b7:	53                   	push   %ebx
801056b8:	e8 d3 d3 ff ff       	call   80102a90 <dirlink>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 67                	js     8010572b <create+0x15b>
  iunlockput(dp);
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	53                   	push   %ebx
801056c8:	e8 33 ce ff ff       	call   80102500 <iunlockput>
  return ip;
801056cd:	83 c4 10             	add    $0x10,%esp
}
801056d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d3:	89 f0                	mov    %esi,%eax
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5f                   	pop    %edi
801056d8:	5d                   	pop    %ebp
801056d9:	c3                   	ret
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801056e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801056e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801056e8:	53                   	push   %ebx
801056e9:	e8 d2 ca ff ff       	call   801021c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056ee:	83 c4 0c             	add    $0xc,%esp
801056f1:	ff 76 04             	push   0x4(%esi)
801056f4:	68 e9 7f 10 80       	push   $0x80107fe9
801056f9:	56                   	push   %esi
801056fa:	e8 91 d3 ff ff       	call   80102a90 <dirlink>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	78 18                	js     8010571e <create+0x14e>
80105706:	83 ec 04             	sub    $0x4,%esp
80105709:	ff 73 04             	push   0x4(%ebx)
8010570c:	68 e8 7f 10 80       	push   $0x80107fe8
80105711:	56                   	push   %esi
80105712:	e8 79 d3 ff ff       	call   80102a90 <dirlink>
80105717:	83 c4 10             	add    $0x10,%esp
8010571a:	85 c0                	test   %eax,%eax
8010571c:	79 92                	jns    801056b0 <create+0xe0>
      panic("create dots");
8010571e:	83 ec 0c             	sub    $0xc,%esp
80105721:	68 dc 7f 10 80       	push   $0x80107fdc
80105726:	e8 45 ac ff ff       	call   80100370 <panic>
    panic("create: dirlink");
8010572b:	83 ec 0c             	sub    $0xc,%esp
8010572e:	68 eb 7f 10 80       	push   $0x80107feb
80105733:	e8 38 ac ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80105738:	83 ec 0c             	sub    $0xc,%esp
8010573b:	68 cd 7f 10 80       	push   $0x80107fcd
80105740:	e8 2b ac ff ff       	call   80100370 <panic>
80105745:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010574c:	00 
8010574d:	8d 76 00             	lea    0x0(%esi),%esi

80105750 <sys_dup>:
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	56                   	push   %esi
80105754:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105755:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105758:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010575b:	50                   	push   %eax
8010575c:	6a 00                	push   $0x0
8010575e:	e8 bd fc ff ff       	call   80105420 <argint>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	78 36                	js     801057a0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010576a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010576e:	77 30                	ja     801057a0 <sys_dup+0x50>
80105770:	e8 bb ec ff ff       	call   80104430 <myproc>
80105775:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105778:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010577c:	85 f6                	test   %esi,%esi
8010577e:	74 20                	je     801057a0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105780:	e8 ab ec ff ff       	call   80104430 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105785:	31 db                	xor    %ebx,%ebx
80105787:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010578e:	00 
8010578f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105790:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105794:	85 d2                	test   %edx,%edx
80105796:	74 18                	je     801057b0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105798:	83 c3 01             	add    $0x1,%ebx
8010579b:	83 fb 10             	cmp    $0x10,%ebx
8010579e:	75 f0                	jne    80105790 <sys_dup+0x40>
}
801057a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801057a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801057a8:	89 d8                	mov    %ebx,%eax
801057aa:	5b                   	pop    %ebx
801057ab:	5e                   	pop    %esi
801057ac:	5d                   	pop    %ebp
801057ad:	c3                   	ret
801057ae:	66 90                	xchg   %ax,%ax
  filedup(f);
801057b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057b3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801057b7:	56                   	push   %esi
801057b8:	e8 d3 c1 ff ff       	call   80101990 <filedup>
  return fd;
801057bd:	83 c4 10             	add    $0x10,%esp
}
801057c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057c3:	89 d8                	mov    %ebx,%eax
801057c5:	5b                   	pop    %ebx
801057c6:	5e                   	pop    %esi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_read>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801057d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801057d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057db:	53                   	push   %ebx
801057dc:	6a 00                	push   $0x0
801057de:	e8 3d fc ff ff       	call   80105420 <argint>
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	85 c0                	test   %eax,%eax
801057e8:	78 5e                	js     80105848 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057ee:	77 58                	ja     80105848 <sys_read+0x78>
801057f0:	e8 3b ec ff ff       	call   80104430 <myproc>
801057f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801057fc:	85 f6                	test   %esi,%esi
801057fe:	74 48                	je     80105848 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105806:	50                   	push   %eax
80105807:	6a 02                	push   $0x2
80105809:	e8 12 fc ff ff       	call   80105420 <argint>
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	85 c0                	test   %eax,%eax
80105813:	78 33                	js     80105848 <sys_read+0x78>
80105815:	83 ec 04             	sub    $0x4,%esp
80105818:	ff 75 f0             	push   -0x10(%ebp)
8010581b:	53                   	push   %ebx
8010581c:	6a 01                	push   $0x1
8010581e:	e8 4d fc ff ff       	call   80105470 <argptr>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 c0                	test   %eax,%eax
80105828:	78 1e                	js     80105848 <sys_read+0x78>
  return fileread(f, p, n);
8010582a:	83 ec 04             	sub    $0x4,%esp
8010582d:	ff 75 f0             	push   -0x10(%ebp)
80105830:	ff 75 f4             	push   -0xc(%ebp)
80105833:	56                   	push   %esi
80105834:	e8 d7 c2 ff ff       	call   80101b10 <fileread>
80105839:	83 c4 10             	add    $0x10,%esp
}
8010583c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010583f:	5b                   	pop    %ebx
80105840:	5e                   	pop    %esi
80105841:	5d                   	pop    %ebp
80105842:	c3                   	ret
80105843:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584d:	eb ed                	jmp    8010583c <sys_read+0x6c>
8010584f:	90                   	nop

80105850 <sys_write>:
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	56                   	push   %esi
80105854:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105855:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105858:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010585b:	53                   	push   %ebx
8010585c:	6a 00                	push   $0x0
8010585e:	e8 bd fb ff ff       	call   80105420 <argint>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	78 5e                	js     801058c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010586a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010586e:	77 58                	ja     801058c8 <sys_write+0x78>
80105870:	e8 bb eb ff ff       	call   80104430 <myproc>
80105875:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105878:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010587c:	85 f6                	test   %esi,%esi
8010587e:	74 48                	je     801058c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105886:	50                   	push   %eax
80105887:	6a 02                	push   $0x2
80105889:	e8 92 fb ff ff       	call   80105420 <argint>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	85 c0                	test   %eax,%eax
80105893:	78 33                	js     801058c8 <sys_write+0x78>
80105895:	83 ec 04             	sub    $0x4,%esp
80105898:	ff 75 f0             	push   -0x10(%ebp)
8010589b:	53                   	push   %ebx
8010589c:	6a 01                	push   $0x1
8010589e:	e8 cd fb ff ff       	call   80105470 <argptr>
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	78 1e                	js     801058c8 <sys_write+0x78>
  return filewrite(f, p, n);
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	ff 75 f0             	push   -0x10(%ebp)
801058b0:	ff 75 f4             	push   -0xc(%ebp)
801058b3:	56                   	push   %esi
801058b4:	e8 e7 c2 ff ff       	call   80101ba0 <filewrite>
801058b9:	83 c4 10             	add    $0x10,%esp
}
801058bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058bf:	5b                   	pop    %ebx
801058c0:	5e                   	pop    %esi
801058c1:	5d                   	pop    %ebp
801058c2:	c3                   	ret
801058c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801058c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cd:	eb ed                	jmp    801058bc <sys_write+0x6c>
801058cf:	90                   	nop

801058d0 <sys_close>:
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	56                   	push   %esi
801058d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058db:	50                   	push   %eax
801058dc:	6a 00                	push   $0x0
801058de:	e8 3d fb ff ff       	call   80105420 <argint>
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	78 3e                	js     80105928 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058ee:	77 38                	ja     80105928 <sys_close+0x58>
801058f0:	e8 3b eb ff ff       	call   80104430 <myproc>
801058f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801058fb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801058ff:	85 f6                	test   %esi,%esi
80105901:	74 25                	je     80105928 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105903:	e8 28 eb ff ff       	call   80104430 <myproc>
  fileclose(f);
80105908:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010590b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105912:	00 
  fileclose(f);
80105913:	56                   	push   %esi
80105914:	e8 c7 c0 ff ff       	call   801019e0 <fileclose>
  return 0;
80105919:	83 c4 10             	add    $0x10,%esp
8010591c:	31 c0                	xor    %eax,%eax
}
8010591e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105921:	5b                   	pop    %ebx
80105922:	5e                   	pop    %esi
80105923:	5d                   	pop    %ebp
80105924:	c3                   	ret
80105925:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592d:	eb ef                	jmp    8010591e <sys_close+0x4e>
8010592f:	90                   	nop

80105930 <sys_fstat>:
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	56                   	push   %esi
80105934:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105935:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105938:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010593b:	53                   	push   %ebx
8010593c:	6a 00                	push   $0x0
8010593e:	e8 dd fa ff ff       	call   80105420 <argint>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 46                	js     80105990 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010594a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010594e:	77 40                	ja     80105990 <sys_fstat+0x60>
80105950:	e8 db ea ff ff       	call   80104430 <myproc>
80105955:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105958:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010595c:	85 f6                	test   %esi,%esi
8010595e:	74 30                	je     80105990 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105960:	83 ec 04             	sub    $0x4,%esp
80105963:	6a 14                	push   $0x14
80105965:	53                   	push   %ebx
80105966:	6a 01                	push   $0x1
80105968:	e8 03 fb ff ff       	call   80105470 <argptr>
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	85 c0                	test   %eax,%eax
80105972:	78 1c                	js     80105990 <sys_fstat+0x60>
  return filestat(f, st);
80105974:	83 ec 08             	sub    $0x8,%esp
80105977:	ff 75 f4             	push   -0xc(%ebp)
8010597a:	56                   	push   %esi
8010597b:	e8 40 c1 ff ff       	call   80101ac0 <filestat>
80105980:	83 c4 10             	add    $0x10,%esp
}
80105983:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105986:	5b                   	pop    %ebx
80105987:	5e                   	pop    %esi
80105988:	5d                   	pop    %ebp
80105989:	c3                   	ret
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105995:	eb ec                	jmp    80105983 <sys_fstat+0x53>
80105997:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010599e:	00 
8010599f:	90                   	nop

801059a0 <sys_link>:
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059a8:	53                   	push   %ebx
801059a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059ac:	50                   	push   %eax
801059ad:	6a 00                	push   $0x0
801059af:	e8 2c fb ff ff       	call   801054e0 <argstr>
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
801059b9:	0f 88 fb 00 00 00    	js     80105aba <sys_link+0x11a>
801059bf:	83 ec 08             	sub    $0x8,%esp
801059c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059c5:	50                   	push   %eax
801059c6:	6a 01                	push   $0x1
801059c8:	e8 13 fb ff ff       	call   801054e0 <argstr>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	0f 88 e2 00 00 00    	js     80105aba <sys_link+0x11a>
  begin_op();
801059d8:	e8 33 de ff ff       	call   80103810 <begin_op>
  if((ip = namei(old)) == 0){
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	ff 75 d4             	push   -0x2c(%ebp)
801059e3:	e8 68 d1 ff ff       	call   80102b50 <namei>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	89 c3                	mov    %eax,%ebx
801059ed:	85 c0                	test   %eax,%eax
801059ef:	0f 84 df 00 00 00    	je     80105ad4 <sys_link+0x134>
  ilock(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 72 c8 ff ff       	call   80102270 <ilock>
  if(ip->type == T_DIR){
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a06:	0f 84 b5 00 00 00    	je     80105ac1 <sys_link+0x121>
  iupdate(ip);
80105a0c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105a0f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105a14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a17:	53                   	push   %ebx
80105a18:	e8 a3 c7 ff ff       	call   801021c0 <iupdate>
  iunlock(ip);
80105a1d:	89 1c 24             	mov    %ebx,(%esp)
80105a20:	e8 2b c9 ff ff       	call   80102350 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a25:	58                   	pop    %eax
80105a26:	5a                   	pop    %edx
80105a27:	57                   	push   %edi
80105a28:	ff 75 d0             	push   -0x30(%ebp)
80105a2b:	e8 40 d1 ff ff       	call   80102b70 <nameiparent>
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	89 c6                	mov    %eax,%esi
80105a35:	85 c0                	test   %eax,%eax
80105a37:	74 5b                	je     80105a94 <sys_link+0xf4>
  ilock(dp);
80105a39:	83 ec 0c             	sub    $0xc,%esp
80105a3c:	50                   	push   %eax
80105a3d:	e8 2e c8 ff ff       	call   80102270 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a42:	8b 03                	mov    (%ebx),%eax
80105a44:	83 c4 10             	add    $0x10,%esp
80105a47:	39 06                	cmp    %eax,(%esi)
80105a49:	75 3d                	jne    80105a88 <sys_link+0xe8>
80105a4b:	83 ec 04             	sub    $0x4,%esp
80105a4e:	ff 73 04             	push   0x4(%ebx)
80105a51:	57                   	push   %edi
80105a52:	56                   	push   %esi
80105a53:	e8 38 d0 ff ff       	call   80102a90 <dirlink>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	78 29                	js     80105a88 <sys_link+0xe8>
  iunlockput(dp);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	56                   	push   %esi
80105a63:	e8 98 ca ff ff       	call   80102500 <iunlockput>
  iput(ip);
80105a68:	89 1c 24             	mov    %ebx,(%esp)
80105a6b:	e8 30 c9 ff ff       	call   801023a0 <iput>
  end_op();
80105a70:	e8 0b de ff ff       	call   80103880 <end_op>
  return 0;
80105a75:	83 c4 10             	add    $0x10,%esp
80105a78:	31 c0                	xor    %eax,%eax
}
80105a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a7d:	5b                   	pop    %ebx
80105a7e:	5e                   	pop    %esi
80105a7f:	5f                   	pop    %edi
80105a80:	5d                   	pop    %ebp
80105a81:	c3                   	ret
80105a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	56                   	push   %esi
80105a8c:	e8 6f ca ff ff       	call   80102500 <iunlockput>
    goto bad;
80105a91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a94:	83 ec 0c             	sub    $0xc,%esp
80105a97:	53                   	push   %ebx
80105a98:	e8 d3 c7 ff ff       	call   80102270 <ilock>
  ip->nlink--;
80105a9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105aa2:	89 1c 24             	mov    %ebx,(%esp)
80105aa5:	e8 16 c7 ff ff       	call   801021c0 <iupdate>
  iunlockput(ip);
80105aaa:	89 1c 24             	mov    %ebx,(%esp)
80105aad:	e8 4e ca ff ff       	call   80102500 <iunlockput>
  end_op();
80105ab2:	e8 c9 dd ff ff       	call   80103880 <end_op>
  return -1;
80105ab7:	83 c4 10             	add    $0x10,%esp
    return -1;
80105aba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abf:	eb b9                	jmp    80105a7a <sys_link+0xda>
    iunlockput(ip);
80105ac1:	83 ec 0c             	sub    $0xc,%esp
80105ac4:	53                   	push   %ebx
80105ac5:	e8 36 ca ff ff       	call   80102500 <iunlockput>
    end_op();
80105aca:	e8 b1 dd ff ff       	call   80103880 <end_op>
    return -1;
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	eb e6                	jmp    80105aba <sys_link+0x11a>
    end_op();
80105ad4:	e8 a7 dd ff ff       	call   80103880 <end_op>
    return -1;
80105ad9:	eb df                	jmp    80105aba <sys_link+0x11a>
80105adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105ae0 <sys_unlink>:
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105ae5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105ae8:	53                   	push   %ebx
80105ae9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105aec:	50                   	push   %eax
80105aed:	6a 00                	push   $0x0
80105aef:	e8 ec f9 ff ff       	call   801054e0 <argstr>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	85 c0                	test   %eax,%eax
80105af9:	0f 88 54 01 00 00    	js     80105c53 <sys_unlink+0x173>
  begin_op();
80105aff:	e8 0c dd ff ff       	call   80103810 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b04:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105b07:	83 ec 08             	sub    $0x8,%esp
80105b0a:	53                   	push   %ebx
80105b0b:	ff 75 c0             	push   -0x40(%ebp)
80105b0e:	e8 5d d0 ff ff       	call   80102b70 <nameiparent>
80105b13:	83 c4 10             	add    $0x10,%esp
80105b16:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	0f 84 58 01 00 00    	je     80105c79 <sys_unlink+0x199>
  ilock(dp);
80105b21:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105b24:	83 ec 0c             	sub    $0xc,%esp
80105b27:	57                   	push   %edi
80105b28:	e8 43 c7 ff ff       	call   80102270 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b2d:	58                   	pop    %eax
80105b2e:	5a                   	pop    %edx
80105b2f:	68 e9 7f 10 80       	push   $0x80107fe9
80105b34:	53                   	push   %ebx
80105b35:	e8 66 cc ff ff       	call   801027a0 <namecmp>
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	0f 84 fb 00 00 00    	je     80105c40 <sys_unlink+0x160>
80105b45:	83 ec 08             	sub    $0x8,%esp
80105b48:	68 e8 7f 10 80       	push   $0x80107fe8
80105b4d:	53                   	push   %ebx
80105b4e:	e8 4d cc ff ff       	call   801027a0 <namecmp>
80105b53:	83 c4 10             	add    $0x10,%esp
80105b56:	85 c0                	test   %eax,%eax
80105b58:	0f 84 e2 00 00 00    	je     80105c40 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105b5e:	83 ec 04             	sub    $0x4,%esp
80105b61:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b64:	50                   	push   %eax
80105b65:	53                   	push   %ebx
80105b66:	57                   	push   %edi
80105b67:	e8 54 cc ff ff       	call   801027c0 <dirlookup>
80105b6c:	83 c4 10             	add    $0x10,%esp
80105b6f:	89 c3                	mov    %eax,%ebx
80105b71:	85 c0                	test   %eax,%eax
80105b73:	0f 84 c7 00 00 00    	je     80105c40 <sys_unlink+0x160>
  ilock(ip);
80105b79:	83 ec 0c             	sub    $0xc,%esp
80105b7c:	50                   	push   %eax
80105b7d:	e8 ee c6 ff ff       	call   80102270 <ilock>
  if(ip->nlink < 1)
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b8a:	0f 8e 0a 01 00 00    	jle    80105c9a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b90:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b95:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b98:	74 66                	je     80105c00 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b9a:	83 ec 04             	sub    $0x4,%esp
80105b9d:	6a 10                	push   $0x10
80105b9f:	6a 00                	push   $0x0
80105ba1:	57                   	push   %edi
80105ba2:	e8 c9 f5 ff ff       	call   80105170 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ba7:	6a 10                	push   $0x10
80105ba9:	ff 75 c4             	push   -0x3c(%ebp)
80105bac:	57                   	push   %edi
80105bad:	ff 75 b4             	push   -0x4c(%ebp)
80105bb0:	e8 cb ca ff ff       	call   80102680 <writei>
80105bb5:	83 c4 20             	add    $0x20,%esp
80105bb8:	83 f8 10             	cmp    $0x10,%eax
80105bbb:	0f 85 cc 00 00 00    	jne    80105c8d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105bc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bc6:	0f 84 94 00 00 00    	je     80105c60 <sys_unlink+0x180>
  iunlockput(dp);
80105bcc:	83 ec 0c             	sub    $0xc,%esp
80105bcf:	ff 75 b4             	push   -0x4c(%ebp)
80105bd2:	e8 29 c9 ff ff       	call   80102500 <iunlockput>
  ip->nlink--;
80105bd7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bdc:	89 1c 24             	mov    %ebx,(%esp)
80105bdf:	e8 dc c5 ff ff       	call   801021c0 <iupdate>
  iunlockput(ip);
80105be4:	89 1c 24             	mov    %ebx,(%esp)
80105be7:	e8 14 c9 ff ff       	call   80102500 <iunlockput>
  end_op();
80105bec:	e8 8f dc ff ff       	call   80103880 <end_op>
  return 0;
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	31 c0                	xor    %eax,%eax
}
80105bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf9:	5b                   	pop    %ebx
80105bfa:	5e                   	pop    %esi
80105bfb:	5f                   	pop    %edi
80105bfc:	5d                   	pop    %ebp
80105bfd:	c3                   	ret
80105bfe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c00:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105c04:	76 94                	jbe    80105b9a <sys_unlink+0xba>
80105c06:	be 20 00 00 00       	mov    $0x20,%esi
80105c0b:	eb 0b                	jmp    80105c18 <sys_unlink+0x138>
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
80105c10:	83 c6 10             	add    $0x10,%esi
80105c13:	3b 73 58             	cmp    0x58(%ebx),%esi
80105c16:	73 82                	jae    80105b9a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c18:	6a 10                	push   $0x10
80105c1a:	56                   	push   %esi
80105c1b:	57                   	push   %edi
80105c1c:	53                   	push   %ebx
80105c1d:	e8 5e c9 ff ff       	call   80102580 <readi>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	83 f8 10             	cmp    $0x10,%eax
80105c28:	75 56                	jne    80105c80 <sys_unlink+0x1a0>
    if(de.inum != 0)
80105c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105c2f:	74 df                	je     80105c10 <sys_unlink+0x130>
    iunlockput(ip);
80105c31:	83 ec 0c             	sub    $0xc,%esp
80105c34:	53                   	push   %ebx
80105c35:	e8 c6 c8 ff ff       	call   80102500 <iunlockput>
    goto bad;
80105c3a:	83 c4 10             	add    $0x10,%esp
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	ff 75 b4             	push   -0x4c(%ebp)
80105c46:	e8 b5 c8 ff ff       	call   80102500 <iunlockput>
  end_op();
80105c4b:	e8 30 dc ff ff       	call   80103880 <end_op>
  return -1;
80105c50:	83 c4 10             	add    $0x10,%esp
    return -1;
80105c53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c58:	eb 9c                	jmp    80105bf6 <sys_unlink+0x116>
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105c60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105c63:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105c66:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105c6b:	50                   	push   %eax
80105c6c:	e8 4f c5 ff ff       	call   801021c0 <iupdate>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	e9 53 ff ff ff       	jmp    80105bcc <sys_unlink+0xec>
    end_op();
80105c79:	e8 02 dc ff ff       	call   80103880 <end_op>
    return -1;
80105c7e:	eb d3                	jmp    80105c53 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 0d 80 10 80       	push   $0x8010800d
80105c88:	e8 e3 a6 ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 1f 80 10 80       	push   $0x8010801f
80105c95:	e8 d6 a6 ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	68 fb 7f 10 80       	push   $0x80107ffb
80105ca2:	e8 c9 a6 ff ff       	call   80100370 <panic>
80105ca7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cae:	00 
80105caf:	90                   	nop

80105cb0 <sys_open>:

int
sys_open(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cb5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105cb8:	53                   	push   %ebx
80105cb9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105cbc:	50                   	push   %eax
80105cbd:	6a 00                	push   $0x0
80105cbf:	e8 1c f8 ff ff       	call   801054e0 <argstr>
80105cc4:	83 c4 10             	add    $0x10,%esp
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	0f 88 8e 00 00 00    	js     80105d5d <sys_open+0xad>
80105ccf:	83 ec 08             	sub    $0x8,%esp
80105cd2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105cd5:	50                   	push   %eax
80105cd6:	6a 01                	push   $0x1
80105cd8:	e8 43 f7 ff ff       	call   80105420 <argint>
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	78 79                	js     80105d5d <sys_open+0xad>
    return -1;

  begin_op();
80105ce4:	e8 27 db ff ff       	call   80103810 <begin_op>

  if(omode & O_CREATE){
80105ce9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ced:	75 79                	jne    80105d68 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105cef:	83 ec 0c             	sub    $0xc,%esp
80105cf2:	ff 75 e0             	push   -0x20(%ebp)
80105cf5:	e8 56 ce ff ff       	call   80102b50 <namei>
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	89 c6                	mov    %eax,%esi
80105cff:	85 c0                	test   %eax,%eax
80105d01:	0f 84 7e 00 00 00    	je     80105d85 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105d07:	83 ec 0c             	sub    $0xc,%esp
80105d0a:	50                   	push   %eax
80105d0b:	e8 60 c5 ff ff       	call   80102270 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d10:	83 c4 10             	add    $0x10,%esp
80105d13:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d18:	0f 84 ba 00 00 00    	je     80105dd8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d1e:	e8 fd bb ff ff       	call   80101920 <filealloc>
80105d23:	89 c7                	mov    %eax,%edi
80105d25:	85 c0                	test   %eax,%eax
80105d27:	74 23                	je     80105d4c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d29:	e8 02 e7 ff ff       	call   80104430 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d2e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105d30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d34:	85 d2                	test   %edx,%edx
80105d36:	74 58                	je     80105d90 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105d38:	83 c3 01             	add    $0x1,%ebx
80105d3b:	83 fb 10             	cmp    $0x10,%ebx
80105d3e:	75 f0                	jne    80105d30 <sys_open+0x80>
    if(f)
      fileclose(f);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	57                   	push   %edi
80105d44:	e8 97 bc ff ff       	call   801019e0 <fileclose>
80105d49:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d4c:	83 ec 0c             	sub    $0xc,%esp
80105d4f:	56                   	push   %esi
80105d50:	e8 ab c7 ff ff       	call   80102500 <iunlockput>
    end_op();
80105d55:	e8 26 db ff ff       	call   80103880 <end_op>
    return -1;
80105d5a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d5d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d62:	eb 65                	jmp    80105dc9 <sys_open+0x119>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	31 c9                	xor    %ecx,%ecx
80105d6d:	ba 02 00 00 00       	mov    $0x2,%edx
80105d72:	6a 00                	push   $0x0
80105d74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d77:	e8 54 f8 ff ff       	call   801055d0 <create>
    if(ip == 0){
80105d7c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d7f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d81:	85 c0                	test   %eax,%eax
80105d83:	75 99                	jne    80105d1e <sys_open+0x6e>
      end_op();
80105d85:	e8 f6 da ff ff       	call   80103880 <end_op>
      return -1;
80105d8a:	eb d1                	jmp    80105d5d <sys_open+0xad>
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105d90:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d93:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105d97:	56                   	push   %esi
80105d98:	e8 b3 c5 ff ff       	call   80102350 <iunlock>
  end_op();
80105d9d:	e8 de da ff ff       	call   80103880 <end_op>

  f->type = FD_INODE;
80105da2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dab:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105dae:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105db1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105db3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105dba:	f7 d0                	not    %eax
80105dbc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dbf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105dc2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105dc5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dcc:	89 d8                	mov    %ebx,%eax
80105dce:	5b                   	pop    %ebx
80105dcf:	5e                   	pop    %esi
80105dd0:	5f                   	pop    %edi
80105dd1:	5d                   	pop    %ebp
80105dd2:	c3                   	ret
80105dd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105dd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ddb:	85 c9                	test   %ecx,%ecx
80105ddd:	0f 84 3b ff ff ff    	je     80105d1e <sys_open+0x6e>
80105de3:	e9 64 ff ff ff       	jmp    80105d4c <sys_open+0x9c>
80105de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105def:	00 

80105df0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105df6:	e8 15 da ff ff       	call   80103810 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105dfb:	83 ec 08             	sub    $0x8,%esp
80105dfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e01:	50                   	push   %eax
80105e02:	6a 00                	push   $0x0
80105e04:	e8 d7 f6 ff ff       	call   801054e0 <argstr>
80105e09:	83 c4 10             	add    $0x10,%esp
80105e0c:	85 c0                	test   %eax,%eax
80105e0e:	78 30                	js     80105e40 <sys_mkdir+0x50>
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e16:	31 c9                	xor    %ecx,%ecx
80105e18:	ba 01 00 00 00       	mov    $0x1,%edx
80105e1d:	6a 00                	push   $0x0
80105e1f:	e8 ac f7 ff ff       	call   801055d0 <create>
80105e24:	83 c4 10             	add    $0x10,%esp
80105e27:	85 c0                	test   %eax,%eax
80105e29:	74 15                	je     80105e40 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e2b:	83 ec 0c             	sub    $0xc,%esp
80105e2e:	50                   	push   %eax
80105e2f:	e8 cc c6 ff ff       	call   80102500 <iunlockput>
  end_op();
80105e34:	e8 47 da ff ff       	call   80103880 <end_op>
  return 0;
80105e39:	83 c4 10             	add    $0x10,%esp
80105e3c:	31 c0                	xor    %eax,%eax
}
80105e3e:	c9                   	leave
80105e3f:	c3                   	ret
    end_op();
80105e40:	e8 3b da ff ff       	call   80103880 <end_op>
    return -1;
80105e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e4a:	c9                   	leave
80105e4b:	c3                   	ret
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e50 <sys_mknod>:

int
sys_mknod(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e56:	e8 b5 d9 ff ff       	call   80103810 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e5b:	83 ec 08             	sub    $0x8,%esp
80105e5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e61:	50                   	push   %eax
80105e62:	6a 00                	push   $0x0
80105e64:	e8 77 f6 ff ff       	call   801054e0 <argstr>
80105e69:	83 c4 10             	add    $0x10,%esp
80105e6c:	85 c0                	test   %eax,%eax
80105e6e:	78 60                	js     80105ed0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e76:	50                   	push   %eax
80105e77:	6a 01                	push   $0x1
80105e79:	e8 a2 f5 ff ff       	call   80105420 <argint>
  if((argstr(0, &path)) < 0 ||
80105e7e:	83 c4 10             	add    $0x10,%esp
80105e81:	85 c0                	test   %eax,%eax
80105e83:	78 4b                	js     80105ed0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e85:	83 ec 08             	sub    $0x8,%esp
80105e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e8b:	50                   	push   %eax
80105e8c:	6a 02                	push   $0x2
80105e8e:	e8 8d f5 ff ff       	call   80105420 <argint>
     argint(1, &major) < 0 ||
80105e93:	83 c4 10             	add    $0x10,%esp
80105e96:	85 c0                	test   %eax,%eax
80105e98:	78 36                	js     80105ed0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e9a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e9e:	83 ec 0c             	sub    $0xc,%esp
80105ea1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ea5:	ba 03 00 00 00       	mov    $0x3,%edx
80105eaa:	50                   	push   %eax
80105eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105eae:	e8 1d f7 ff ff       	call   801055d0 <create>
     argint(2, &minor) < 0 ||
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	85 c0                	test   %eax,%eax
80105eb8:	74 16                	je     80105ed0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105eba:	83 ec 0c             	sub    $0xc,%esp
80105ebd:	50                   	push   %eax
80105ebe:	e8 3d c6 ff ff       	call   80102500 <iunlockput>
  end_op();
80105ec3:	e8 b8 d9 ff ff       	call   80103880 <end_op>
  return 0;
80105ec8:	83 c4 10             	add    $0x10,%esp
80105ecb:	31 c0                	xor    %eax,%eax
}
80105ecd:	c9                   	leave
80105ece:	c3                   	ret
80105ecf:	90                   	nop
    end_op();
80105ed0:	e8 ab d9 ff ff       	call   80103880 <end_op>
    return -1;
80105ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eda:	c9                   	leave
80105edb:	c3                   	ret
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_chdir>:

int
sys_chdir(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	56                   	push   %esi
80105ee4:	53                   	push   %ebx
80105ee5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ee8:	e8 43 e5 ff ff       	call   80104430 <myproc>
80105eed:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105eef:	e8 1c d9 ff ff       	call   80103810 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ef4:	83 ec 08             	sub    $0x8,%esp
80105ef7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 de f5 ff ff       	call   801054e0 <argstr>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 77                	js     80105f80 <sys_chdir+0xa0>
80105f09:	83 ec 0c             	sub    $0xc,%esp
80105f0c:	ff 75 f4             	push   -0xc(%ebp)
80105f0f:	e8 3c cc ff ff       	call   80102b50 <namei>
80105f14:	83 c4 10             	add    $0x10,%esp
80105f17:	89 c3                	mov    %eax,%ebx
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 63                	je     80105f80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	50                   	push   %eax
80105f21:	e8 4a c3 ff ff       	call   80102270 <ilock>
  if(ip->type != T_DIR){
80105f26:	83 c4 10             	add    $0x10,%esp
80105f29:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f2e:	75 30                	jne    80105f60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	53                   	push   %ebx
80105f34:	e8 17 c4 ff ff       	call   80102350 <iunlock>
  iput(curproc->cwd);
80105f39:	58                   	pop    %eax
80105f3a:	ff 76 68             	push   0x68(%esi)
80105f3d:	e8 5e c4 ff ff       	call   801023a0 <iput>
  end_op();
80105f42:	e8 39 d9 ff ff       	call   80103880 <end_op>
  curproc->cwd = ip;
80105f47:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105f4a:	83 c4 10             	add    $0x10,%esp
80105f4d:	31 c0                	xor    %eax,%eax
}
80105f4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f52:	5b                   	pop    %ebx
80105f53:	5e                   	pop    %esi
80105f54:	5d                   	pop    %ebp
80105f55:	c3                   	ret
80105f56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f5d:	00 
80105f5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	53                   	push   %ebx
80105f64:	e8 97 c5 ff ff       	call   80102500 <iunlockput>
    end_op();
80105f69:	e8 12 d9 ff ff       	call   80103880 <end_op>
    return -1;
80105f6e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f76:	eb d7                	jmp    80105f4f <sys_chdir+0x6f>
80105f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f7f:	00 
    end_op();
80105f80:	e8 fb d8 ff ff       	call   80103880 <end_op>
    return -1;
80105f85:	eb ea                	jmp    80105f71 <sys_chdir+0x91>
80105f87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f8e:	00 
80105f8f:	90                   	nop

80105f90 <sys_exec>:

int
sys_exec(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	57                   	push   %edi
80105f94:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f95:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f9b:	53                   	push   %ebx
80105f9c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105fa2:	50                   	push   %eax
80105fa3:	6a 00                	push   $0x0
80105fa5:	e8 36 f5 ff ff       	call   801054e0 <argstr>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	85 c0                	test   %eax,%eax
80105faf:	0f 88 87 00 00 00    	js     8010603c <sys_exec+0xac>
80105fb5:	83 ec 08             	sub    $0x8,%esp
80105fb8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105fbe:	50                   	push   %eax
80105fbf:	6a 01                	push   $0x1
80105fc1:	e8 5a f4 ff ff       	call   80105420 <argint>
80105fc6:	83 c4 10             	add    $0x10,%esp
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	78 6f                	js     8010603c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105fcd:	83 ec 04             	sub    $0x4,%esp
80105fd0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105fd6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fd8:	68 80 00 00 00       	push   $0x80
80105fdd:	6a 00                	push   $0x0
80105fdf:	56                   	push   %esi
80105fe0:	e8 8b f1 ff ff       	call   80105170 <memset>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fef:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ff9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106000:	50                   	push   %eax
80106001:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106007:	01 f8                	add    %edi,%eax
80106009:	50                   	push   %eax
8010600a:	e8 81 f3 ff ff       	call   80105390 <fetchint>
8010600f:	83 c4 10             	add    $0x10,%esp
80106012:	85 c0                	test   %eax,%eax
80106014:	78 26                	js     8010603c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106016:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010601c:	85 c0                	test   %eax,%eax
8010601e:	74 30                	je     80106050 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106020:	83 ec 08             	sub    $0x8,%esp
80106023:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106026:	52                   	push   %edx
80106027:	50                   	push   %eax
80106028:	e8 a3 f3 ff ff       	call   801053d0 <fetchstr>
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	85 c0                	test   %eax,%eax
80106032:	78 08                	js     8010603c <sys_exec+0xac>
  for(i=0;; i++){
80106034:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106037:	83 fb 20             	cmp    $0x20,%ebx
8010603a:	75 b4                	jne    80105ff0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010603c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010603f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106044:	5b                   	pop    %ebx
80106045:	5e                   	pop    %esi
80106046:	5f                   	pop    %edi
80106047:	5d                   	pop    %ebp
80106048:	c3                   	ret
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106050:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106057:	00 00 00 00 
  return exec(path, argv);
8010605b:	83 ec 08             	sub    $0x8,%esp
8010605e:	56                   	push   %esi
8010605f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106065:	e8 16 b5 ff ff       	call   80101580 <exec>
8010606a:	83 c4 10             	add    $0x10,%esp
}
8010606d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106070:	5b                   	pop    %ebx
80106071:	5e                   	pop    %esi
80106072:	5f                   	pop    %edi
80106073:	5d                   	pop    %ebp
80106074:	c3                   	ret
80106075:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010607c:	00 
8010607d:	8d 76 00             	lea    0x0(%esi),%esi

80106080 <sys_pipe>:

int
sys_pipe(void)
{
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	57                   	push   %edi
80106084:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106085:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106088:	53                   	push   %ebx
80106089:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010608c:	6a 08                	push   $0x8
8010608e:	50                   	push   %eax
8010608f:	6a 00                	push   $0x0
80106091:	e8 da f3 ff ff       	call   80105470 <argptr>
80106096:	83 c4 10             	add    $0x10,%esp
80106099:	85 c0                	test   %eax,%eax
8010609b:	0f 88 8b 00 00 00    	js     8010612c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801060a1:	83 ec 08             	sub    $0x8,%esp
801060a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060a7:	50                   	push   %eax
801060a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801060ab:	50                   	push   %eax
801060ac:	e8 2f de ff ff       	call   80103ee0 <pipealloc>
801060b1:	83 c4 10             	add    $0x10,%esp
801060b4:	85 c0                	test   %eax,%eax
801060b6:	78 74                	js     8010612c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801060bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801060bd:	e8 6e e3 ff ff       	call   80104430 <myproc>
    if(curproc->ofile[fd] == 0){
801060c2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801060c6:	85 f6                	test   %esi,%esi
801060c8:	74 16                	je     801060e0 <sys_pipe+0x60>
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801060d0:	83 c3 01             	add    $0x1,%ebx
801060d3:	83 fb 10             	cmp    $0x10,%ebx
801060d6:	74 3d                	je     80106115 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801060d8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801060dc:	85 f6                	test   %esi,%esi
801060de:	75 f0                	jne    801060d0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801060e0:	8d 73 08             	lea    0x8(%ebx),%esi
801060e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801060ea:	e8 41 e3 ff ff       	call   80104430 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ef:	31 d2                	xor    %edx,%edx
801060f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801060f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801060fc:	85 c9                	test   %ecx,%ecx
801060fe:	74 38                	je     80106138 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80106100:	83 c2 01             	add    $0x1,%edx
80106103:	83 fa 10             	cmp    $0x10,%edx
80106106:	75 f0                	jne    801060f8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106108:	e8 23 e3 ff ff       	call   80104430 <myproc>
8010610d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106114:	00 
    fileclose(rf);
80106115:	83 ec 0c             	sub    $0xc,%esp
80106118:	ff 75 e0             	push   -0x20(%ebp)
8010611b:	e8 c0 b8 ff ff       	call   801019e0 <fileclose>
    fileclose(wf);
80106120:	58                   	pop    %eax
80106121:	ff 75 e4             	push   -0x1c(%ebp)
80106124:	e8 b7 b8 ff ff       	call   801019e0 <fileclose>
    return -1;
80106129:	83 c4 10             	add    $0x10,%esp
    return -1;
8010612c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106131:	eb 16                	jmp    80106149 <sys_pipe+0xc9>
80106133:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106138:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010613c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010613f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106141:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106144:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106147:	31 c0                	xor    %eax,%eax
}
80106149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010614c:	5b                   	pop    %ebx
8010614d:	5e                   	pop    %esi
8010614e:	5f                   	pop    %edi
8010614f:	5d                   	pop    %ebp
80106150:	c3                   	ret
80106151:	66 90                	xchg   %ax,%ax
80106153:	66 90                	xchg   %ax,%ax
80106155:	66 90                	xchg   %ax,%ax
80106157:	66 90                	xchg   %ax,%ax
80106159:	66 90                	xchg   %ax,%ax
8010615b:	66 90                	xchg   %ax,%ax
8010615d:	66 90                	xchg   %ax,%ax
8010615f:	90                   	nop

80106160 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106160:	e9 6b e4 ff ff       	jmp    801045d0 <fork>
80106165:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010616c:	00 
8010616d:	8d 76 00             	lea    0x0(%esi),%esi

80106170 <sys_exit>:
}

int
sys_exit(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 08             	sub    $0x8,%esp
  exit();
80106176:	e8 c5 e6 ff ff       	call   80104840 <exit>
  return 0;  // not reached
}
8010617b:	31 c0                	xor    %eax,%eax
8010617d:	c9                   	leave
8010617e:	c3                   	ret
8010617f:	90                   	nop

80106180 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106180:	e9 eb e7 ff ff       	jmp    80104970 <wait>
80106185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010618c:	00 
8010618d:	8d 76 00             	lea    0x0(%esi),%esi

80106190 <sys_kill>:
}

int
sys_kill(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106196:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106199:	50                   	push   %eax
8010619a:	6a 00                	push   $0x0
8010619c:	e8 7f f2 ff ff       	call   80105420 <argint>
801061a1:	83 c4 10             	add    $0x10,%esp
801061a4:	85 c0                	test   %eax,%eax
801061a6:	78 18                	js     801061c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801061a8:	83 ec 0c             	sub    $0xc,%esp
801061ab:	ff 75 f4             	push   -0xc(%ebp)
801061ae:	e8 5d ea ff ff       	call   80104c10 <kill>
801061b3:	83 c4 10             	add    $0x10,%esp
}
801061b6:	c9                   	leave
801061b7:	c3                   	ret
801061b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061bf:	00 
801061c0:	c9                   	leave
    return -1;
801061c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061c6:	c3                   	ret
801061c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061ce:	00 
801061cf:	90                   	nop

801061d0 <sys_getpid>:

int
sys_getpid(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801061d6:	e8 55 e2 ff ff       	call   80104430 <myproc>
801061db:	8b 40 10             	mov    0x10(%eax),%eax
}
801061de:	c9                   	leave
801061df:	c3                   	ret

801061e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801061e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061ea:	50                   	push   %eax
801061eb:	6a 00                	push   $0x0
801061ed:	e8 2e f2 ff ff       	call   80105420 <argint>
801061f2:	83 c4 10             	add    $0x10,%esp
801061f5:	85 c0                	test   %eax,%eax
801061f7:	78 27                	js     80106220 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801061f9:	e8 32 e2 ff ff       	call   80104430 <myproc>
  if(growproc(n) < 0)
801061fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106201:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106203:	ff 75 f4             	push   -0xc(%ebp)
80106206:	e8 45 e3 ff ff       	call   80104550 <growproc>
8010620b:	83 c4 10             	add    $0x10,%esp
8010620e:	85 c0                	test   %eax,%eax
80106210:	78 0e                	js     80106220 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106212:	89 d8                	mov    %ebx,%eax
80106214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106217:	c9                   	leave
80106218:	c3                   	ret
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106220:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106225:	eb eb                	jmp    80106212 <sys_sbrk+0x32>
80106227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010622e:	00 
8010622f:	90                   	nop

80106230 <sys_sleep>:

int
sys_sleep(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106234:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106237:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010623a:	50                   	push   %eax
8010623b:	6a 00                	push   $0x0
8010623d:	e8 de f1 ff ff       	call   80105420 <argint>
80106242:	83 c4 10             	add    $0x10,%esp
80106245:	85 c0                	test   %eax,%eax
80106247:	78 64                	js     801062ad <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80106249:	83 ec 0c             	sub    $0xc,%esp
8010624c:	68 00 4f 11 80       	push   $0x80114f00
80106251:	e8 1a ee ff ff       	call   80105070 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106259:	8b 1d e0 4e 11 80    	mov    0x80114ee0,%ebx
  while(ticks - ticks0 < n){
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	85 d2                	test   %edx,%edx
80106264:	75 2b                	jne    80106291 <sys_sleep+0x61>
80106266:	eb 58                	jmp    801062c0 <sys_sleep+0x90>
80106268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010626f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106270:	83 ec 08             	sub    $0x8,%esp
80106273:	68 00 4f 11 80       	push   $0x80114f00
80106278:	68 e0 4e 11 80       	push   $0x80114ee0
8010627d:	e8 6e e8 ff ff       	call   80104af0 <sleep>
  while(ticks - ticks0 < n){
80106282:	a1 e0 4e 11 80       	mov    0x80114ee0,%eax
80106287:	83 c4 10             	add    $0x10,%esp
8010628a:	29 d8                	sub    %ebx,%eax
8010628c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010628f:	73 2f                	jae    801062c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106291:	e8 9a e1 ff ff       	call   80104430 <myproc>
80106296:	8b 40 24             	mov    0x24(%eax),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 d3                	je     80106270 <sys_sleep+0x40>
      release(&tickslock);
8010629d:	83 ec 0c             	sub    $0xc,%esp
801062a0:	68 00 4f 11 80       	push   $0x80114f00
801062a5:	e8 66 ed ff ff       	call   80105010 <release>
      return -1;
801062aa:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801062ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b5:	c9                   	leave
801062b6:	c3                   	ret
801062b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062be:	00 
801062bf:	90                   	nop
  release(&tickslock);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	68 00 4f 11 80       	push   $0x80114f00
801062c8:	e8 43 ed ff ff       	call   80105010 <release>
}
801062cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801062d0:	83 c4 10             	add    $0x10,%esp
801062d3:	31 c0                	xor    %eax,%eax
}
801062d5:	c9                   	leave
801062d6:	c3                   	ret
801062d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062de:	00 
801062df:	90                   	nop

801062e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	53                   	push   %ebx
801062e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062e7:	68 00 4f 11 80       	push   $0x80114f00
801062ec:	e8 7f ed ff ff       	call   80105070 <acquire>
  xticks = ticks;
801062f1:	8b 1d e0 4e 11 80    	mov    0x80114ee0,%ebx
  release(&tickslock);
801062f7:	c7 04 24 00 4f 11 80 	movl   $0x80114f00,(%esp)
801062fe:	e8 0d ed ff ff       	call   80105010 <release>
  return xticks;
}
80106303:	89 d8                	mov    %ebx,%eax
80106305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106308:	c9                   	leave
80106309:	c3                   	ret

8010630a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010630a:	1e                   	push   %ds
  pushl %es
8010630b:	06                   	push   %es
  pushl %fs
8010630c:	0f a0                	push   %fs
  pushl %gs
8010630e:	0f a8                	push   %gs
  pushal
80106310:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106311:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106315:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106317:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106319:	54                   	push   %esp
  call trap
8010631a:	e8 c1 00 00 00       	call   801063e0 <trap>
  addl $4, %esp
8010631f:	83 c4 04             	add    $0x4,%esp

80106322 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106322:	61                   	popa
  popl %gs
80106323:	0f a9                	pop    %gs
  popl %fs
80106325:	0f a1                	pop    %fs
  popl %es
80106327:	07                   	pop    %es
  popl %ds
80106328:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106329:	83 c4 08             	add    $0x8,%esp
  iret
8010632c:	cf                   	iret
8010632d:	66 90                	xchg   %ax,%ax
8010632f:	90                   	nop

80106330 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106330:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106331:	31 c0                	xor    %eax,%eax
{
80106333:	89 e5                	mov    %esp,%ebp
80106335:	83 ec 08             	sub    $0x8,%esp
80106338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010633f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106340:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106347:	c7 04 c5 42 4f 11 80 	movl   $0x8e000008,-0x7feeb0be(,%eax,8)
8010634e:	08 00 00 8e 
80106352:	66 89 14 c5 40 4f 11 	mov    %dx,-0x7feeb0c0(,%eax,8)
80106359:	80 
8010635a:	c1 ea 10             	shr    $0x10,%edx
8010635d:	66 89 14 c5 46 4f 11 	mov    %dx,-0x7feeb0ba(,%eax,8)
80106364:	80 
  for(i = 0; i < 256; i++)
80106365:	83 c0 01             	add    $0x1,%eax
80106368:	3d 00 01 00 00       	cmp    $0x100,%eax
8010636d:	75 d1                	jne    80106340 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010636f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106372:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106377:	c7 05 42 51 11 80 08 	movl   $0xef000008,0x80115142
8010637e:	00 00 ef 
  initlock(&tickslock, "time");
80106381:	68 2e 80 10 80       	push   $0x8010802e
80106386:	68 00 4f 11 80       	push   $0x80114f00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010638b:	66 a3 40 51 11 80    	mov    %ax,0x80115140
80106391:	c1 e8 10             	shr    $0x10,%eax
80106394:	66 a3 46 51 11 80    	mov    %ax,0x80115146
  initlock(&tickslock, "time");
8010639a:	e8 e1 ea ff ff       	call   80104e80 <initlock>
}
8010639f:	83 c4 10             	add    $0x10,%esp
801063a2:	c9                   	leave
801063a3:	c3                   	ret
801063a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ab:	00 
801063ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063b0 <idtinit>:

void
idtinit(void)
{
801063b0:	55                   	push   %ebp
  pd[0] = size-1;
801063b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801063b6:	89 e5                	mov    %esp,%ebp
801063b8:	83 ec 10             	sub    $0x10,%esp
801063bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063bf:	b8 40 4f 11 80       	mov    $0x80114f40,%eax
801063c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063c8:	c1 e8 10             	shr    $0x10,%eax
801063cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801063cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801063d5:	c9                   	leave
801063d6:	c3                   	ret
801063d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063de:	00 
801063df:	90                   	nop

801063e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	57                   	push   %edi
801063e4:	56                   	push   %esi
801063e5:	53                   	push   %ebx
801063e6:	83 ec 1c             	sub    $0x1c,%esp
801063e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801063ec:	8b 43 30             	mov    0x30(%ebx),%eax
801063ef:	83 f8 40             	cmp    $0x40,%eax
801063f2:	0f 84 58 01 00 00    	je     80106550 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801063f8:	83 e8 20             	sub    $0x20,%eax
801063fb:	83 f8 1f             	cmp    $0x1f,%eax
801063fe:	0f 87 7c 00 00 00    	ja     80106480 <trap+0xa0>
80106404:	ff 24 85 f8 85 10 80 	jmp    *-0x7fef7a08(,%eax,4)
8010640b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106410:	e8 eb c8 ff ff       	call   80102d00 <ideintr>
    lapiceoi();
80106415:	e8 a6 cf ff ff       	call   801033c0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010641a:	e8 11 e0 ff ff       	call   80104430 <myproc>
8010641f:	85 c0                	test   %eax,%eax
80106421:	74 1a                	je     8010643d <trap+0x5d>
80106423:	e8 08 e0 ff ff       	call   80104430 <myproc>
80106428:	8b 50 24             	mov    0x24(%eax),%edx
8010642b:	85 d2                	test   %edx,%edx
8010642d:	74 0e                	je     8010643d <trap+0x5d>
8010642f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106433:	f7 d0                	not    %eax
80106435:	a8 03                	test   $0x3,%al
80106437:	0f 84 db 01 00 00    	je     80106618 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010643d:	e8 ee df ff ff       	call   80104430 <myproc>
80106442:	85 c0                	test   %eax,%eax
80106444:	74 0f                	je     80106455 <trap+0x75>
80106446:	e8 e5 df ff ff       	call   80104430 <myproc>
8010644b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010644f:	0f 84 ab 00 00 00    	je     80106500 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106455:	e8 d6 df ff ff       	call   80104430 <myproc>
8010645a:	85 c0                	test   %eax,%eax
8010645c:	74 1a                	je     80106478 <trap+0x98>
8010645e:	e8 cd df ff ff       	call   80104430 <myproc>
80106463:	8b 40 24             	mov    0x24(%eax),%eax
80106466:	85 c0                	test   %eax,%eax
80106468:	74 0e                	je     80106478 <trap+0x98>
8010646a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010646e:	f7 d0                	not    %eax
80106470:	a8 03                	test   $0x3,%al
80106472:	0f 84 05 01 00 00    	je     8010657d <trap+0x19d>
    exit();
}
80106478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010647b:	5b                   	pop    %ebx
8010647c:	5e                   	pop    %esi
8010647d:	5f                   	pop    %edi
8010647e:	5d                   	pop    %ebp
8010647f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80106480:	e8 ab df ff ff       	call   80104430 <myproc>
80106485:	8b 7b 38             	mov    0x38(%ebx),%edi
80106488:	85 c0                	test   %eax,%eax
8010648a:	0f 84 a2 01 00 00    	je     80106632 <trap+0x252>
80106490:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106494:	0f 84 98 01 00 00    	je     80106632 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010649a:	0f 20 d1             	mov    %cr2,%ecx
8010649d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064a0:	e8 6b df ff ff       	call   80104410 <cpuid>
801064a5:	8b 73 30             	mov    0x30(%ebx),%esi
801064a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801064ab:	8b 43 34             	mov    0x34(%ebx),%eax
801064ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801064b1:	e8 7a df ff ff       	call   80104430 <myproc>
801064b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801064b9:	e8 72 df ff ff       	call   80104430 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064c1:	51                   	push   %ecx
801064c2:	57                   	push   %edi
801064c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064c6:	52                   	push   %edx
801064c7:	ff 75 e4             	push   -0x1c(%ebp)
801064ca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801064cb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801064ce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064d1:	56                   	push   %esi
801064d2:	ff 70 10             	push   0x10(%eax)
801064d5:	68 e8 82 10 80       	push   $0x801082e8
801064da:	e8 d1 a3 ff ff       	call   801008b0 <cprintf>
    myproc()->killed = 1;
801064df:	83 c4 20             	add    $0x20,%esp
801064e2:	e8 49 df ff ff       	call   80104430 <myproc>
801064e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064ee:	e8 3d df ff ff       	call   80104430 <myproc>
801064f3:	85 c0                	test   %eax,%eax
801064f5:	0f 85 28 ff ff ff    	jne    80106423 <trap+0x43>
801064fb:	e9 3d ff ff ff       	jmp    8010643d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80106500:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106504:	0f 85 4b ff ff ff    	jne    80106455 <trap+0x75>
    yield();
8010650a:	e8 91 e5 ff ff       	call   80104aa0 <yield>
8010650f:	e9 41 ff ff ff       	jmp    80106455 <trap+0x75>
80106514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106518:	8b 7b 38             	mov    0x38(%ebx),%edi
8010651b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010651f:	e8 ec de ff ff       	call   80104410 <cpuid>
80106524:	57                   	push   %edi
80106525:	56                   	push   %esi
80106526:	50                   	push   %eax
80106527:	68 90 82 10 80       	push   $0x80108290
8010652c:	e8 7f a3 ff ff       	call   801008b0 <cprintf>
    lapiceoi();
80106531:	e8 8a ce ff ff       	call   801033c0 <lapiceoi>
    break;
80106536:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106539:	e8 f2 de ff ff       	call   80104430 <myproc>
8010653e:	85 c0                	test   %eax,%eax
80106540:	0f 85 dd fe ff ff    	jne    80106423 <trap+0x43>
80106546:	e9 f2 fe ff ff       	jmp    8010643d <trap+0x5d>
8010654b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106550:	e8 db de ff ff       	call   80104430 <myproc>
80106555:	8b 70 24             	mov    0x24(%eax),%esi
80106558:	85 f6                	test   %esi,%esi
8010655a:	0f 85 c8 00 00 00    	jne    80106628 <trap+0x248>
    myproc()->tf = tf;
80106560:	e8 cb de ff ff       	call   80104430 <myproc>
80106565:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106568:	e8 f3 ef ff ff       	call   80105560 <syscall>
    if(myproc()->killed)
8010656d:	e8 be de ff ff       	call   80104430 <myproc>
80106572:	8b 48 24             	mov    0x24(%eax),%ecx
80106575:	85 c9                	test   %ecx,%ecx
80106577:	0f 84 fb fe ff ff    	je     80106478 <trap+0x98>
}
8010657d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106580:	5b                   	pop    %ebx
80106581:	5e                   	pop    %esi
80106582:	5f                   	pop    %edi
80106583:	5d                   	pop    %ebp
      exit();
80106584:	e9 b7 e2 ff ff       	jmp    80104840 <exit>
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106590:	e8 4b 02 00 00       	call   801067e0 <uartintr>
    lapiceoi();
80106595:	e8 26 ce ff ff       	call   801033c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010659a:	e8 91 de ff ff       	call   80104430 <myproc>
8010659f:	85 c0                	test   %eax,%eax
801065a1:	0f 85 7c fe ff ff    	jne    80106423 <trap+0x43>
801065a7:	e9 91 fe ff ff       	jmp    8010643d <trap+0x5d>
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801065b0:	e8 db cc ff ff       	call   80103290 <kbdintr>
    lapiceoi();
801065b5:	e8 06 ce ff ff       	call   801033c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065ba:	e8 71 de ff ff       	call   80104430 <myproc>
801065bf:	85 c0                	test   %eax,%eax
801065c1:	0f 85 5c fe ff ff    	jne    80106423 <trap+0x43>
801065c7:	e9 71 fe ff ff       	jmp    8010643d <trap+0x5d>
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801065d0:	e8 3b de ff ff       	call   80104410 <cpuid>
801065d5:	85 c0                	test   %eax,%eax
801065d7:	0f 85 38 fe ff ff    	jne    80106415 <trap+0x35>
      acquire(&tickslock);
801065dd:	83 ec 0c             	sub    $0xc,%esp
801065e0:	68 00 4f 11 80       	push   $0x80114f00
801065e5:	e8 86 ea ff ff       	call   80105070 <acquire>
      ticks++;
801065ea:	83 05 e0 4e 11 80 01 	addl   $0x1,0x80114ee0
      wakeup(&ticks);
801065f1:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
801065f8:	e8 b3 e5 ff ff       	call   80104bb0 <wakeup>
      release(&tickslock);
801065fd:	c7 04 24 00 4f 11 80 	movl   $0x80114f00,(%esp)
80106604:	e8 07 ea ff ff       	call   80105010 <release>
80106609:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010660c:	e9 04 fe ff ff       	jmp    80106415 <trap+0x35>
80106611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106618:	e8 23 e2 ff ff       	call   80104840 <exit>
8010661d:	e9 1b fe ff ff       	jmp    8010643d <trap+0x5d>
80106622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106628:	e8 13 e2 ff ff       	call   80104840 <exit>
8010662d:	e9 2e ff ff ff       	jmp    80106560 <trap+0x180>
80106632:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106635:	e8 d6 dd ff ff       	call   80104410 <cpuid>
8010663a:	83 ec 0c             	sub    $0xc,%esp
8010663d:	56                   	push   %esi
8010663e:	57                   	push   %edi
8010663f:	50                   	push   %eax
80106640:	ff 73 30             	push   0x30(%ebx)
80106643:	68 b4 82 10 80       	push   $0x801082b4
80106648:	e8 63 a2 ff ff       	call   801008b0 <cprintf>
      panic("trap");
8010664d:	83 c4 14             	add    $0x14,%esp
80106650:	68 33 80 10 80       	push   $0x80108033
80106655:	e8 16 9d ff ff       	call   80100370 <panic>
8010665a:	66 90                	xchg   %ax,%ax
8010665c:	66 90                	xchg   %ax,%ax
8010665e:	66 90                	xchg   %ax,%ax

80106660 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106660:	a1 40 57 11 80       	mov    0x80115740,%eax
80106665:	85 c0                	test   %eax,%eax
80106667:	74 17                	je     80106680 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106669:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010666e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010666f:	a8 01                	test   $0x1,%al
80106671:	74 0d                	je     80106680 <uartgetc+0x20>
80106673:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106678:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106679:	0f b6 c0             	movzbl %al,%eax
8010667c:	c3                   	ret
8010667d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106685:	c3                   	ret
80106686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010668d:	00 
8010668e:	66 90                	xchg   %ax,%ax

80106690 <uartinit>:
{
80106690:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106691:	31 c9                	xor    %ecx,%ecx
80106693:	89 c8                	mov    %ecx,%eax
80106695:	89 e5                	mov    %esp,%ebp
80106697:	57                   	push   %edi
80106698:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010669d:	56                   	push   %esi
8010669e:	89 fa                	mov    %edi,%edx
801066a0:	53                   	push   %ebx
801066a1:	83 ec 1c             	sub    $0x1c,%esp
801066a4:	ee                   	out    %al,(%dx)
801066a5:	be fb 03 00 00       	mov    $0x3fb,%esi
801066aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066af:	89 f2                	mov    %esi,%edx
801066b1:	ee                   	out    %al,(%dx)
801066b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801066b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066bc:	ee                   	out    %al,(%dx)
801066bd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801066c2:	89 c8                	mov    %ecx,%eax
801066c4:	89 da                	mov    %ebx,%edx
801066c6:	ee                   	out    %al,(%dx)
801066c7:	b8 03 00 00 00       	mov    $0x3,%eax
801066cc:	89 f2                	mov    %esi,%edx
801066ce:	ee                   	out    %al,(%dx)
801066cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066d4:	89 c8                	mov    %ecx,%eax
801066d6:	ee                   	out    %al,(%dx)
801066d7:	b8 01 00 00 00       	mov    $0x1,%eax
801066dc:	89 da                	mov    %ebx,%edx
801066de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066e5:	3c ff                	cmp    $0xff,%al
801066e7:	0f 84 7c 00 00 00    	je     80106769 <uartinit+0xd9>
  uart = 1;
801066ed:	c7 05 40 57 11 80 01 	movl   $0x1,0x80115740
801066f4:	00 00 00 
801066f7:	89 fa                	mov    %edi,%edx
801066f9:	ec                   	in     (%dx),%al
801066fa:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ff:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106700:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106703:	bf 38 80 10 80       	mov    $0x80108038,%edi
80106708:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010670d:	6a 00                	push   $0x0
8010670f:	6a 04                	push   $0x4
80106711:	e8 1a c8 ff ff       	call   80102f30 <ioapicenable>
80106716:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106719:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010671d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106720:	a1 40 57 11 80       	mov    0x80115740,%eax
80106725:	85 c0                	test   %eax,%eax
80106727:	74 32                	je     8010675b <uartinit+0xcb>
80106729:	89 f2                	mov    %esi,%edx
8010672b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010672c:	a8 20                	test   $0x20,%al
8010672e:	75 21                	jne    80106751 <uartinit+0xc1>
80106730:	bb 80 00 00 00       	mov    $0x80,%ebx
80106735:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106738:	83 ec 0c             	sub    $0xc,%esp
8010673b:	6a 0a                	push   $0xa
8010673d:	e8 9e cc ff ff       	call   801033e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106742:	83 c4 10             	add    $0x10,%esp
80106745:	83 eb 01             	sub    $0x1,%ebx
80106748:	74 07                	je     80106751 <uartinit+0xc1>
8010674a:	89 f2                	mov    %esi,%edx
8010674c:	ec                   	in     (%dx),%al
8010674d:	a8 20                	test   $0x20,%al
8010674f:	74 e7                	je     80106738 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106751:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106756:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010675a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010675b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010675f:	83 c7 01             	add    $0x1,%edi
80106762:	88 45 e7             	mov    %al,-0x19(%ebp)
80106765:	84 c0                	test   %al,%al
80106767:	75 b7                	jne    80106720 <uartinit+0x90>
}
80106769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010676c:	5b                   	pop    %ebx
8010676d:	5e                   	pop    %esi
8010676e:	5f                   	pop    %edi
8010676f:	5d                   	pop    %ebp
80106770:	c3                   	ret
80106771:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106778:	00 
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106780 <uartputc>:
  if(!uart)
80106780:	a1 40 57 11 80       	mov    0x80115740,%eax
80106785:	85 c0                	test   %eax,%eax
80106787:	74 4f                	je     801067d8 <uartputc+0x58>
{
80106789:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010678a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010678f:	89 e5                	mov    %esp,%ebp
80106791:	56                   	push   %esi
80106792:	53                   	push   %ebx
80106793:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106794:	a8 20                	test   $0x20,%al
80106796:	75 29                	jne    801067c1 <uartputc+0x41>
80106798:	bb 80 00 00 00       	mov    $0x80,%ebx
8010679d:	be fd 03 00 00       	mov    $0x3fd,%esi
801067a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801067a8:	83 ec 0c             	sub    $0xc,%esp
801067ab:	6a 0a                	push   $0xa
801067ad:	e8 2e cc ff ff       	call   801033e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801067b2:	83 c4 10             	add    $0x10,%esp
801067b5:	83 eb 01             	sub    $0x1,%ebx
801067b8:	74 07                	je     801067c1 <uartputc+0x41>
801067ba:	89 f2                	mov    %esi,%edx
801067bc:	ec                   	in     (%dx),%al
801067bd:	a8 20                	test   $0x20,%al
801067bf:	74 e7                	je     801067a8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067c1:	8b 45 08             	mov    0x8(%ebp),%eax
801067c4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067c9:	ee                   	out    %al,(%dx)
}
801067ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801067cd:	5b                   	pop    %ebx
801067ce:	5e                   	pop    %esi
801067cf:	5d                   	pop    %ebp
801067d0:	c3                   	ret
801067d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d8:	c3                   	ret
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067e0 <uartintr>:

void
uartintr(void)
{
801067e0:	55                   	push   %ebp
801067e1:	89 e5                	mov    %esp,%ebp
801067e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067e6:	68 60 66 10 80       	push   $0x80106660
801067eb:	e8 d0 a2 ff ff       	call   80100ac0 <consoleintr>
}
801067f0:	83 c4 10             	add    $0x10,%esp
801067f3:	c9                   	leave
801067f4:	c3                   	ret

801067f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $0
801067f7:	6a 00                	push   $0x0
  jmp alltraps
801067f9:	e9 0c fb ff ff       	jmp    8010630a <alltraps>

801067fe <vector1>:
.globl vector1
vector1:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $1
80106800:	6a 01                	push   $0x1
  jmp alltraps
80106802:	e9 03 fb ff ff       	jmp    8010630a <alltraps>

80106807 <vector2>:
.globl vector2
vector2:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $2
80106809:	6a 02                	push   $0x2
  jmp alltraps
8010680b:	e9 fa fa ff ff       	jmp    8010630a <alltraps>

80106810 <vector3>:
.globl vector3
vector3:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $3
80106812:	6a 03                	push   $0x3
  jmp alltraps
80106814:	e9 f1 fa ff ff       	jmp    8010630a <alltraps>

80106819 <vector4>:
.globl vector4
vector4:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $4
8010681b:	6a 04                	push   $0x4
  jmp alltraps
8010681d:	e9 e8 fa ff ff       	jmp    8010630a <alltraps>

80106822 <vector5>:
.globl vector5
vector5:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $5
80106824:	6a 05                	push   $0x5
  jmp alltraps
80106826:	e9 df fa ff ff       	jmp    8010630a <alltraps>

8010682b <vector6>:
.globl vector6
vector6:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $6
8010682d:	6a 06                	push   $0x6
  jmp alltraps
8010682f:	e9 d6 fa ff ff       	jmp    8010630a <alltraps>

80106834 <vector7>:
.globl vector7
vector7:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $7
80106836:	6a 07                	push   $0x7
  jmp alltraps
80106838:	e9 cd fa ff ff       	jmp    8010630a <alltraps>

8010683d <vector8>:
.globl vector8
vector8:
  pushl $8
8010683d:	6a 08                	push   $0x8
  jmp alltraps
8010683f:	e9 c6 fa ff ff       	jmp    8010630a <alltraps>

80106844 <vector9>:
.globl vector9
vector9:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $9
80106846:	6a 09                	push   $0x9
  jmp alltraps
80106848:	e9 bd fa ff ff       	jmp    8010630a <alltraps>

8010684d <vector10>:
.globl vector10
vector10:
  pushl $10
8010684d:	6a 0a                	push   $0xa
  jmp alltraps
8010684f:	e9 b6 fa ff ff       	jmp    8010630a <alltraps>

80106854 <vector11>:
.globl vector11
vector11:
  pushl $11
80106854:	6a 0b                	push   $0xb
  jmp alltraps
80106856:	e9 af fa ff ff       	jmp    8010630a <alltraps>

8010685b <vector12>:
.globl vector12
vector12:
  pushl $12
8010685b:	6a 0c                	push   $0xc
  jmp alltraps
8010685d:	e9 a8 fa ff ff       	jmp    8010630a <alltraps>

80106862 <vector13>:
.globl vector13
vector13:
  pushl $13
80106862:	6a 0d                	push   $0xd
  jmp alltraps
80106864:	e9 a1 fa ff ff       	jmp    8010630a <alltraps>

80106869 <vector14>:
.globl vector14
vector14:
  pushl $14
80106869:	6a 0e                	push   $0xe
  jmp alltraps
8010686b:	e9 9a fa ff ff       	jmp    8010630a <alltraps>

80106870 <vector15>:
.globl vector15
vector15:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $15
80106872:	6a 0f                	push   $0xf
  jmp alltraps
80106874:	e9 91 fa ff ff       	jmp    8010630a <alltraps>

80106879 <vector16>:
.globl vector16
vector16:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $16
8010687b:	6a 10                	push   $0x10
  jmp alltraps
8010687d:	e9 88 fa ff ff       	jmp    8010630a <alltraps>

80106882 <vector17>:
.globl vector17
vector17:
  pushl $17
80106882:	6a 11                	push   $0x11
  jmp alltraps
80106884:	e9 81 fa ff ff       	jmp    8010630a <alltraps>

80106889 <vector18>:
.globl vector18
vector18:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $18
8010688b:	6a 12                	push   $0x12
  jmp alltraps
8010688d:	e9 78 fa ff ff       	jmp    8010630a <alltraps>

80106892 <vector19>:
.globl vector19
vector19:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $19
80106894:	6a 13                	push   $0x13
  jmp alltraps
80106896:	e9 6f fa ff ff       	jmp    8010630a <alltraps>

8010689b <vector20>:
.globl vector20
vector20:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $20
8010689d:	6a 14                	push   $0x14
  jmp alltraps
8010689f:	e9 66 fa ff ff       	jmp    8010630a <alltraps>

801068a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $21
801068a6:	6a 15                	push   $0x15
  jmp alltraps
801068a8:	e9 5d fa ff ff       	jmp    8010630a <alltraps>

801068ad <vector22>:
.globl vector22
vector22:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $22
801068af:	6a 16                	push   $0x16
  jmp alltraps
801068b1:	e9 54 fa ff ff       	jmp    8010630a <alltraps>

801068b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $23
801068b8:	6a 17                	push   $0x17
  jmp alltraps
801068ba:	e9 4b fa ff ff       	jmp    8010630a <alltraps>

801068bf <vector24>:
.globl vector24
vector24:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $24
801068c1:	6a 18                	push   $0x18
  jmp alltraps
801068c3:	e9 42 fa ff ff       	jmp    8010630a <alltraps>

801068c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $25
801068ca:	6a 19                	push   $0x19
  jmp alltraps
801068cc:	e9 39 fa ff ff       	jmp    8010630a <alltraps>

801068d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $26
801068d3:	6a 1a                	push   $0x1a
  jmp alltraps
801068d5:	e9 30 fa ff ff       	jmp    8010630a <alltraps>

801068da <vector27>:
.globl vector27
vector27:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $27
801068dc:	6a 1b                	push   $0x1b
  jmp alltraps
801068de:	e9 27 fa ff ff       	jmp    8010630a <alltraps>

801068e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $28
801068e5:	6a 1c                	push   $0x1c
  jmp alltraps
801068e7:	e9 1e fa ff ff       	jmp    8010630a <alltraps>

801068ec <vector29>:
.globl vector29
vector29:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $29
801068ee:	6a 1d                	push   $0x1d
  jmp alltraps
801068f0:	e9 15 fa ff ff       	jmp    8010630a <alltraps>

801068f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $30
801068f7:	6a 1e                	push   $0x1e
  jmp alltraps
801068f9:	e9 0c fa ff ff       	jmp    8010630a <alltraps>

801068fe <vector31>:
.globl vector31
vector31:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $31
80106900:	6a 1f                	push   $0x1f
  jmp alltraps
80106902:	e9 03 fa ff ff       	jmp    8010630a <alltraps>

80106907 <vector32>:
.globl vector32
vector32:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $32
80106909:	6a 20                	push   $0x20
  jmp alltraps
8010690b:	e9 fa f9 ff ff       	jmp    8010630a <alltraps>

80106910 <vector33>:
.globl vector33
vector33:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $33
80106912:	6a 21                	push   $0x21
  jmp alltraps
80106914:	e9 f1 f9 ff ff       	jmp    8010630a <alltraps>

80106919 <vector34>:
.globl vector34
vector34:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $34
8010691b:	6a 22                	push   $0x22
  jmp alltraps
8010691d:	e9 e8 f9 ff ff       	jmp    8010630a <alltraps>

80106922 <vector35>:
.globl vector35
vector35:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $35
80106924:	6a 23                	push   $0x23
  jmp alltraps
80106926:	e9 df f9 ff ff       	jmp    8010630a <alltraps>

8010692b <vector36>:
.globl vector36
vector36:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $36
8010692d:	6a 24                	push   $0x24
  jmp alltraps
8010692f:	e9 d6 f9 ff ff       	jmp    8010630a <alltraps>

80106934 <vector37>:
.globl vector37
vector37:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $37
80106936:	6a 25                	push   $0x25
  jmp alltraps
80106938:	e9 cd f9 ff ff       	jmp    8010630a <alltraps>

8010693d <vector38>:
.globl vector38
vector38:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $38
8010693f:	6a 26                	push   $0x26
  jmp alltraps
80106941:	e9 c4 f9 ff ff       	jmp    8010630a <alltraps>

80106946 <vector39>:
.globl vector39
vector39:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $39
80106948:	6a 27                	push   $0x27
  jmp alltraps
8010694a:	e9 bb f9 ff ff       	jmp    8010630a <alltraps>

8010694f <vector40>:
.globl vector40
vector40:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $40
80106951:	6a 28                	push   $0x28
  jmp alltraps
80106953:	e9 b2 f9 ff ff       	jmp    8010630a <alltraps>

80106958 <vector41>:
.globl vector41
vector41:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $41
8010695a:	6a 29                	push   $0x29
  jmp alltraps
8010695c:	e9 a9 f9 ff ff       	jmp    8010630a <alltraps>

80106961 <vector42>:
.globl vector42
vector42:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $42
80106963:	6a 2a                	push   $0x2a
  jmp alltraps
80106965:	e9 a0 f9 ff ff       	jmp    8010630a <alltraps>

8010696a <vector43>:
.globl vector43
vector43:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $43
8010696c:	6a 2b                	push   $0x2b
  jmp alltraps
8010696e:	e9 97 f9 ff ff       	jmp    8010630a <alltraps>

80106973 <vector44>:
.globl vector44
vector44:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $44
80106975:	6a 2c                	push   $0x2c
  jmp alltraps
80106977:	e9 8e f9 ff ff       	jmp    8010630a <alltraps>

8010697c <vector45>:
.globl vector45
vector45:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $45
8010697e:	6a 2d                	push   $0x2d
  jmp alltraps
80106980:	e9 85 f9 ff ff       	jmp    8010630a <alltraps>

80106985 <vector46>:
.globl vector46
vector46:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $46
80106987:	6a 2e                	push   $0x2e
  jmp alltraps
80106989:	e9 7c f9 ff ff       	jmp    8010630a <alltraps>

8010698e <vector47>:
.globl vector47
vector47:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $47
80106990:	6a 2f                	push   $0x2f
  jmp alltraps
80106992:	e9 73 f9 ff ff       	jmp    8010630a <alltraps>

80106997 <vector48>:
.globl vector48
vector48:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $48
80106999:	6a 30                	push   $0x30
  jmp alltraps
8010699b:	e9 6a f9 ff ff       	jmp    8010630a <alltraps>

801069a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $49
801069a2:	6a 31                	push   $0x31
  jmp alltraps
801069a4:	e9 61 f9 ff ff       	jmp    8010630a <alltraps>

801069a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $50
801069ab:	6a 32                	push   $0x32
  jmp alltraps
801069ad:	e9 58 f9 ff ff       	jmp    8010630a <alltraps>

801069b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $51
801069b4:	6a 33                	push   $0x33
  jmp alltraps
801069b6:	e9 4f f9 ff ff       	jmp    8010630a <alltraps>

801069bb <vector52>:
.globl vector52
vector52:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $52
801069bd:	6a 34                	push   $0x34
  jmp alltraps
801069bf:	e9 46 f9 ff ff       	jmp    8010630a <alltraps>

801069c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $53
801069c6:	6a 35                	push   $0x35
  jmp alltraps
801069c8:	e9 3d f9 ff ff       	jmp    8010630a <alltraps>

801069cd <vector54>:
.globl vector54
vector54:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $54
801069cf:	6a 36                	push   $0x36
  jmp alltraps
801069d1:	e9 34 f9 ff ff       	jmp    8010630a <alltraps>

801069d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $55
801069d8:	6a 37                	push   $0x37
  jmp alltraps
801069da:	e9 2b f9 ff ff       	jmp    8010630a <alltraps>

801069df <vector56>:
.globl vector56
vector56:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $56
801069e1:	6a 38                	push   $0x38
  jmp alltraps
801069e3:	e9 22 f9 ff ff       	jmp    8010630a <alltraps>

801069e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $57
801069ea:	6a 39                	push   $0x39
  jmp alltraps
801069ec:	e9 19 f9 ff ff       	jmp    8010630a <alltraps>

801069f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $58
801069f3:	6a 3a                	push   $0x3a
  jmp alltraps
801069f5:	e9 10 f9 ff ff       	jmp    8010630a <alltraps>

801069fa <vector59>:
.globl vector59
vector59:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $59
801069fc:	6a 3b                	push   $0x3b
  jmp alltraps
801069fe:	e9 07 f9 ff ff       	jmp    8010630a <alltraps>

80106a03 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $60
80106a05:	6a 3c                	push   $0x3c
  jmp alltraps
80106a07:	e9 fe f8 ff ff       	jmp    8010630a <alltraps>

80106a0c <vector61>:
.globl vector61
vector61:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $61
80106a0e:	6a 3d                	push   $0x3d
  jmp alltraps
80106a10:	e9 f5 f8 ff ff       	jmp    8010630a <alltraps>

80106a15 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $62
80106a17:	6a 3e                	push   $0x3e
  jmp alltraps
80106a19:	e9 ec f8 ff ff       	jmp    8010630a <alltraps>

80106a1e <vector63>:
.globl vector63
vector63:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $63
80106a20:	6a 3f                	push   $0x3f
  jmp alltraps
80106a22:	e9 e3 f8 ff ff       	jmp    8010630a <alltraps>

80106a27 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $64
80106a29:	6a 40                	push   $0x40
  jmp alltraps
80106a2b:	e9 da f8 ff ff       	jmp    8010630a <alltraps>

80106a30 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $65
80106a32:	6a 41                	push   $0x41
  jmp alltraps
80106a34:	e9 d1 f8 ff ff       	jmp    8010630a <alltraps>

80106a39 <vector66>:
.globl vector66
vector66:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $66
80106a3b:	6a 42                	push   $0x42
  jmp alltraps
80106a3d:	e9 c8 f8 ff ff       	jmp    8010630a <alltraps>

80106a42 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $67
80106a44:	6a 43                	push   $0x43
  jmp alltraps
80106a46:	e9 bf f8 ff ff       	jmp    8010630a <alltraps>

80106a4b <vector68>:
.globl vector68
vector68:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $68
80106a4d:	6a 44                	push   $0x44
  jmp alltraps
80106a4f:	e9 b6 f8 ff ff       	jmp    8010630a <alltraps>

80106a54 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $69
80106a56:	6a 45                	push   $0x45
  jmp alltraps
80106a58:	e9 ad f8 ff ff       	jmp    8010630a <alltraps>

80106a5d <vector70>:
.globl vector70
vector70:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $70
80106a5f:	6a 46                	push   $0x46
  jmp alltraps
80106a61:	e9 a4 f8 ff ff       	jmp    8010630a <alltraps>

80106a66 <vector71>:
.globl vector71
vector71:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $71
80106a68:	6a 47                	push   $0x47
  jmp alltraps
80106a6a:	e9 9b f8 ff ff       	jmp    8010630a <alltraps>

80106a6f <vector72>:
.globl vector72
vector72:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $72
80106a71:	6a 48                	push   $0x48
  jmp alltraps
80106a73:	e9 92 f8 ff ff       	jmp    8010630a <alltraps>

80106a78 <vector73>:
.globl vector73
vector73:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $73
80106a7a:	6a 49                	push   $0x49
  jmp alltraps
80106a7c:	e9 89 f8 ff ff       	jmp    8010630a <alltraps>

80106a81 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $74
80106a83:	6a 4a                	push   $0x4a
  jmp alltraps
80106a85:	e9 80 f8 ff ff       	jmp    8010630a <alltraps>

80106a8a <vector75>:
.globl vector75
vector75:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $75
80106a8c:	6a 4b                	push   $0x4b
  jmp alltraps
80106a8e:	e9 77 f8 ff ff       	jmp    8010630a <alltraps>

80106a93 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $76
80106a95:	6a 4c                	push   $0x4c
  jmp alltraps
80106a97:	e9 6e f8 ff ff       	jmp    8010630a <alltraps>

80106a9c <vector77>:
.globl vector77
vector77:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $77
80106a9e:	6a 4d                	push   $0x4d
  jmp alltraps
80106aa0:	e9 65 f8 ff ff       	jmp    8010630a <alltraps>

80106aa5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $78
80106aa7:	6a 4e                	push   $0x4e
  jmp alltraps
80106aa9:	e9 5c f8 ff ff       	jmp    8010630a <alltraps>

80106aae <vector79>:
.globl vector79
vector79:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $79
80106ab0:	6a 4f                	push   $0x4f
  jmp alltraps
80106ab2:	e9 53 f8 ff ff       	jmp    8010630a <alltraps>

80106ab7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $80
80106ab9:	6a 50                	push   $0x50
  jmp alltraps
80106abb:	e9 4a f8 ff ff       	jmp    8010630a <alltraps>

80106ac0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $81
80106ac2:	6a 51                	push   $0x51
  jmp alltraps
80106ac4:	e9 41 f8 ff ff       	jmp    8010630a <alltraps>

80106ac9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $82
80106acb:	6a 52                	push   $0x52
  jmp alltraps
80106acd:	e9 38 f8 ff ff       	jmp    8010630a <alltraps>

80106ad2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $83
80106ad4:	6a 53                	push   $0x53
  jmp alltraps
80106ad6:	e9 2f f8 ff ff       	jmp    8010630a <alltraps>

80106adb <vector84>:
.globl vector84
vector84:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $84
80106add:	6a 54                	push   $0x54
  jmp alltraps
80106adf:	e9 26 f8 ff ff       	jmp    8010630a <alltraps>

80106ae4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $85
80106ae6:	6a 55                	push   $0x55
  jmp alltraps
80106ae8:	e9 1d f8 ff ff       	jmp    8010630a <alltraps>

80106aed <vector86>:
.globl vector86
vector86:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $86
80106aef:	6a 56                	push   $0x56
  jmp alltraps
80106af1:	e9 14 f8 ff ff       	jmp    8010630a <alltraps>

80106af6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $87
80106af8:	6a 57                	push   $0x57
  jmp alltraps
80106afa:	e9 0b f8 ff ff       	jmp    8010630a <alltraps>

80106aff <vector88>:
.globl vector88
vector88:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $88
80106b01:	6a 58                	push   $0x58
  jmp alltraps
80106b03:	e9 02 f8 ff ff       	jmp    8010630a <alltraps>

80106b08 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $89
80106b0a:	6a 59                	push   $0x59
  jmp alltraps
80106b0c:	e9 f9 f7 ff ff       	jmp    8010630a <alltraps>

80106b11 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $90
80106b13:	6a 5a                	push   $0x5a
  jmp alltraps
80106b15:	e9 f0 f7 ff ff       	jmp    8010630a <alltraps>

80106b1a <vector91>:
.globl vector91
vector91:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $91
80106b1c:	6a 5b                	push   $0x5b
  jmp alltraps
80106b1e:	e9 e7 f7 ff ff       	jmp    8010630a <alltraps>

80106b23 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $92
80106b25:	6a 5c                	push   $0x5c
  jmp alltraps
80106b27:	e9 de f7 ff ff       	jmp    8010630a <alltraps>

80106b2c <vector93>:
.globl vector93
vector93:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $93
80106b2e:	6a 5d                	push   $0x5d
  jmp alltraps
80106b30:	e9 d5 f7 ff ff       	jmp    8010630a <alltraps>

80106b35 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $94
80106b37:	6a 5e                	push   $0x5e
  jmp alltraps
80106b39:	e9 cc f7 ff ff       	jmp    8010630a <alltraps>

80106b3e <vector95>:
.globl vector95
vector95:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $95
80106b40:	6a 5f                	push   $0x5f
  jmp alltraps
80106b42:	e9 c3 f7 ff ff       	jmp    8010630a <alltraps>

80106b47 <vector96>:
.globl vector96
vector96:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $96
80106b49:	6a 60                	push   $0x60
  jmp alltraps
80106b4b:	e9 ba f7 ff ff       	jmp    8010630a <alltraps>

80106b50 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $97
80106b52:	6a 61                	push   $0x61
  jmp alltraps
80106b54:	e9 b1 f7 ff ff       	jmp    8010630a <alltraps>

80106b59 <vector98>:
.globl vector98
vector98:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $98
80106b5b:	6a 62                	push   $0x62
  jmp alltraps
80106b5d:	e9 a8 f7 ff ff       	jmp    8010630a <alltraps>

80106b62 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $99
80106b64:	6a 63                	push   $0x63
  jmp alltraps
80106b66:	e9 9f f7 ff ff       	jmp    8010630a <alltraps>

80106b6b <vector100>:
.globl vector100
vector100:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $100
80106b6d:	6a 64                	push   $0x64
  jmp alltraps
80106b6f:	e9 96 f7 ff ff       	jmp    8010630a <alltraps>

80106b74 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $101
80106b76:	6a 65                	push   $0x65
  jmp alltraps
80106b78:	e9 8d f7 ff ff       	jmp    8010630a <alltraps>

80106b7d <vector102>:
.globl vector102
vector102:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $102
80106b7f:	6a 66                	push   $0x66
  jmp alltraps
80106b81:	e9 84 f7 ff ff       	jmp    8010630a <alltraps>

80106b86 <vector103>:
.globl vector103
vector103:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $103
80106b88:	6a 67                	push   $0x67
  jmp alltraps
80106b8a:	e9 7b f7 ff ff       	jmp    8010630a <alltraps>

80106b8f <vector104>:
.globl vector104
vector104:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $104
80106b91:	6a 68                	push   $0x68
  jmp alltraps
80106b93:	e9 72 f7 ff ff       	jmp    8010630a <alltraps>

80106b98 <vector105>:
.globl vector105
vector105:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $105
80106b9a:	6a 69                	push   $0x69
  jmp alltraps
80106b9c:	e9 69 f7 ff ff       	jmp    8010630a <alltraps>

80106ba1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $106
80106ba3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ba5:	e9 60 f7 ff ff       	jmp    8010630a <alltraps>

80106baa <vector107>:
.globl vector107
vector107:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $107
80106bac:	6a 6b                	push   $0x6b
  jmp alltraps
80106bae:	e9 57 f7 ff ff       	jmp    8010630a <alltraps>

80106bb3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $108
80106bb5:	6a 6c                	push   $0x6c
  jmp alltraps
80106bb7:	e9 4e f7 ff ff       	jmp    8010630a <alltraps>

80106bbc <vector109>:
.globl vector109
vector109:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $109
80106bbe:	6a 6d                	push   $0x6d
  jmp alltraps
80106bc0:	e9 45 f7 ff ff       	jmp    8010630a <alltraps>

80106bc5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $110
80106bc7:	6a 6e                	push   $0x6e
  jmp alltraps
80106bc9:	e9 3c f7 ff ff       	jmp    8010630a <alltraps>

80106bce <vector111>:
.globl vector111
vector111:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $111
80106bd0:	6a 6f                	push   $0x6f
  jmp alltraps
80106bd2:	e9 33 f7 ff ff       	jmp    8010630a <alltraps>

80106bd7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $112
80106bd9:	6a 70                	push   $0x70
  jmp alltraps
80106bdb:	e9 2a f7 ff ff       	jmp    8010630a <alltraps>

80106be0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $113
80106be2:	6a 71                	push   $0x71
  jmp alltraps
80106be4:	e9 21 f7 ff ff       	jmp    8010630a <alltraps>

80106be9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $114
80106beb:	6a 72                	push   $0x72
  jmp alltraps
80106bed:	e9 18 f7 ff ff       	jmp    8010630a <alltraps>

80106bf2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $115
80106bf4:	6a 73                	push   $0x73
  jmp alltraps
80106bf6:	e9 0f f7 ff ff       	jmp    8010630a <alltraps>

80106bfb <vector116>:
.globl vector116
vector116:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $116
80106bfd:	6a 74                	push   $0x74
  jmp alltraps
80106bff:	e9 06 f7 ff ff       	jmp    8010630a <alltraps>

80106c04 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $117
80106c06:	6a 75                	push   $0x75
  jmp alltraps
80106c08:	e9 fd f6 ff ff       	jmp    8010630a <alltraps>

80106c0d <vector118>:
.globl vector118
vector118:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $118
80106c0f:	6a 76                	push   $0x76
  jmp alltraps
80106c11:	e9 f4 f6 ff ff       	jmp    8010630a <alltraps>

80106c16 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $119
80106c18:	6a 77                	push   $0x77
  jmp alltraps
80106c1a:	e9 eb f6 ff ff       	jmp    8010630a <alltraps>

80106c1f <vector120>:
.globl vector120
vector120:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $120
80106c21:	6a 78                	push   $0x78
  jmp alltraps
80106c23:	e9 e2 f6 ff ff       	jmp    8010630a <alltraps>

80106c28 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $121
80106c2a:	6a 79                	push   $0x79
  jmp alltraps
80106c2c:	e9 d9 f6 ff ff       	jmp    8010630a <alltraps>

80106c31 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $122
80106c33:	6a 7a                	push   $0x7a
  jmp alltraps
80106c35:	e9 d0 f6 ff ff       	jmp    8010630a <alltraps>

80106c3a <vector123>:
.globl vector123
vector123:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $123
80106c3c:	6a 7b                	push   $0x7b
  jmp alltraps
80106c3e:	e9 c7 f6 ff ff       	jmp    8010630a <alltraps>

80106c43 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $124
80106c45:	6a 7c                	push   $0x7c
  jmp alltraps
80106c47:	e9 be f6 ff ff       	jmp    8010630a <alltraps>

80106c4c <vector125>:
.globl vector125
vector125:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $125
80106c4e:	6a 7d                	push   $0x7d
  jmp alltraps
80106c50:	e9 b5 f6 ff ff       	jmp    8010630a <alltraps>

80106c55 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $126
80106c57:	6a 7e                	push   $0x7e
  jmp alltraps
80106c59:	e9 ac f6 ff ff       	jmp    8010630a <alltraps>

80106c5e <vector127>:
.globl vector127
vector127:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $127
80106c60:	6a 7f                	push   $0x7f
  jmp alltraps
80106c62:	e9 a3 f6 ff ff       	jmp    8010630a <alltraps>

80106c67 <vector128>:
.globl vector128
vector128:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $128
80106c69:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c6e:	e9 97 f6 ff ff       	jmp    8010630a <alltraps>

80106c73 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $129
80106c75:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c7a:	e9 8b f6 ff ff       	jmp    8010630a <alltraps>

80106c7f <vector130>:
.globl vector130
vector130:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $130
80106c81:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c86:	e9 7f f6 ff ff       	jmp    8010630a <alltraps>

80106c8b <vector131>:
.globl vector131
vector131:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $131
80106c8d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c92:	e9 73 f6 ff ff       	jmp    8010630a <alltraps>

80106c97 <vector132>:
.globl vector132
vector132:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $132
80106c99:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c9e:	e9 67 f6 ff ff       	jmp    8010630a <alltraps>

80106ca3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $133
80106ca5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106caa:	e9 5b f6 ff ff       	jmp    8010630a <alltraps>

80106caf <vector134>:
.globl vector134
vector134:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $134
80106cb1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cb6:	e9 4f f6 ff ff       	jmp    8010630a <alltraps>

80106cbb <vector135>:
.globl vector135
vector135:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $135
80106cbd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cc2:	e9 43 f6 ff ff       	jmp    8010630a <alltraps>

80106cc7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $136
80106cc9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cce:	e9 37 f6 ff ff       	jmp    8010630a <alltraps>

80106cd3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $137
80106cd5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cda:	e9 2b f6 ff ff       	jmp    8010630a <alltraps>

80106cdf <vector138>:
.globl vector138
vector138:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $138
80106ce1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ce6:	e9 1f f6 ff ff       	jmp    8010630a <alltraps>

80106ceb <vector139>:
.globl vector139
vector139:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $139
80106ced:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cf2:	e9 13 f6 ff ff       	jmp    8010630a <alltraps>

80106cf7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $140
80106cf9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cfe:	e9 07 f6 ff ff       	jmp    8010630a <alltraps>

80106d03 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $141
80106d05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d0a:	e9 fb f5 ff ff       	jmp    8010630a <alltraps>

80106d0f <vector142>:
.globl vector142
vector142:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $142
80106d11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d16:	e9 ef f5 ff ff       	jmp    8010630a <alltraps>

80106d1b <vector143>:
.globl vector143
vector143:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $143
80106d1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d22:	e9 e3 f5 ff ff       	jmp    8010630a <alltraps>

80106d27 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $144
80106d29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d2e:	e9 d7 f5 ff ff       	jmp    8010630a <alltraps>

80106d33 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $145
80106d35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d3a:	e9 cb f5 ff ff       	jmp    8010630a <alltraps>

80106d3f <vector146>:
.globl vector146
vector146:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $146
80106d41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d46:	e9 bf f5 ff ff       	jmp    8010630a <alltraps>

80106d4b <vector147>:
.globl vector147
vector147:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $147
80106d4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d52:	e9 b3 f5 ff ff       	jmp    8010630a <alltraps>

80106d57 <vector148>:
.globl vector148
vector148:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $148
80106d59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d5e:	e9 a7 f5 ff ff       	jmp    8010630a <alltraps>

80106d63 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $149
80106d65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d6a:	e9 9b f5 ff ff       	jmp    8010630a <alltraps>

80106d6f <vector150>:
.globl vector150
vector150:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $150
80106d71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d76:	e9 8f f5 ff ff       	jmp    8010630a <alltraps>

80106d7b <vector151>:
.globl vector151
vector151:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $151
80106d7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d82:	e9 83 f5 ff ff       	jmp    8010630a <alltraps>

80106d87 <vector152>:
.globl vector152
vector152:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $152
80106d89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d8e:	e9 77 f5 ff ff       	jmp    8010630a <alltraps>

80106d93 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $153
80106d95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d9a:	e9 6b f5 ff ff       	jmp    8010630a <alltraps>

80106d9f <vector154>:
.globl vector154
vector154:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $154
80106da1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106da6:	e9 5f f5 ff ff       	jmp    8010630a <alltraps>

80106dab <vector155>:
.globl vector155
vector155:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $155
80106dad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106db2:	e9 53 f5 ff ff       	jmp    8010630a <alltraps>

80106db7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $156
80106db9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106dbe:	e9 47 f5 ff ff       	jmp    8010630a <alltraps>

80106dc3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $157
80106dc5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dca:	e9 3b f5 ff ff       	jmp    8010630a <alltraps>

80106dcf <vector158>:
.globl vector158
vector158:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $158
80106dd1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106dd6:	e9 2f f5 ff ff       	jmp    8010630a <alltraps>

80106ddb <vector159>:
.globl vector159
vector159:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $159
80106ddd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106de2:	e9 23 f5 ff ff       	jmp    8010630a <alltraps>

80106de7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $160
80106de9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106dee:	e9 17 f5 ff ff       	jmp    8010630a <alltraps>

80106df3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $161
80106df5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dfa:	e9 0b f5 ff ff       	jmp    8010630a <alltraps>

80106dff <vector162>:
.globl vector162
vector162:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $162
80106e01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e06:	e9 ff f4 ff ff       	jmp    8010630a <alltraps>

80106e0b <vector163>:
.globl vector163
vector163:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $163
80106e0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e12:	e9 f3 f4 ff ff       	jmp    8010630a <alltraps>

80106e17 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $164
80106e19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e1e:	e9 e7 f4 ff ff       	jmp    8010630a <alltraps>

80106e23 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $165
80106e25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e2a:	e9 db f4 ff ff       	jmp    8010630a <alltraps>

80106e2f <vector166>:
.globl vector166
vector166:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $166
80106e31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e36:	e9 cf f4 ff ff       	jmp    8010630a <alltraps>

80106e3b <vector167>:
.globl vector167
vector167:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $167
80106e3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e42:	e9 c3 f4 ff ff       	jmp    8010630a <alltraps>

80106e47 <vector168>:
.globl vector168
vector168:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $168
80106e49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e4e:	e9 b7 f4 ff ff       	jmp    8010630a <alltraps>

80106e53 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $169
80106e55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e5a:	e9 ab f4 ff ff       	jmp    8010630a <alltraps>

80106e5f <vector170>:
.globl vector170
vector170:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $170
80106e61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e66:	e9 9f f4 ff ff       	jmp    8010630a <alltraps>

80106e6b <vector171>:
.globl vector171
vector171:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $171
80106e6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e72:	e9 93 f4 ff ff       	jmp    8010630a <alltraps>

80106e77 <vector172>:
.globl vector172
vector172:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $172
80106e79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e7e:	e9 87 f4 ff ff       	jmp    8010630a <alltraps>

80106e83 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $173
80106e85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e8a:	e9 7b f4 ff ff       	jmp    8010630a <alltraps>

80106e8f <vector174>:
.globl vector174
vector174:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $174
80106e91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e96:	e9 6f f4 ff ff       	jmp    8010630a <alltraps>

80106e9b <vector175>:
.globl vector175
vector175:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $175
80106e9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ea2:	e9 63 f4 ff ff       	jmp    8010630a <alltraps>

80106ea7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $176
80106ea9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106eae:	e9 57 f4 ff ff       	jmp    8010630a <alltraps>

80106eb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $177
80106eb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106eba:	e9 4b f4 ff ff       	jmp    8010630a <alltraps>

80106ebf <vector178>:
.globl vector178
vector178:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $178
80106ec1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ec6:	e9 3f f4 ff ff       	jmp    8010630a <alltraps>

80106ecb <vector179>:
.globl vector179
vector179:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $179
80106ecd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ed2:	e9 33 f4 ff ff       	jmp    8010630a <alltraps>

80106ed7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $180
80106ed9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ede:	e9 27 f4 ff ff       	jmp    8010630a <alltraps>

80106ee3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $181
80106ee5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106eea:	e9 1b f4 ff ff       	jmp    8010630a <alltraps>

80106eef <vector182>:
.globl vector182
vector182:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $182
80106ef1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ef6:	e9 0f f4 ff ff       	jmp    8010630a <alltraps>

80106efb <vector183>:
.globl vector183
vector183:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $183
80106efd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f02:	e9 03 f4 ff ff       	jmp    8010630a <alltraps>

80106f07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $184
80106f09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f0e:	e9 f7 f3 ff ff       	jmp    8010630a <alltraps>

80106f13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $185
80106f15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f1a:	e9 eb f3 ff ff       	jmp    8010630a <alltraps>

80106f1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $186
80106f21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f26:	e9 df f3 ff ff       	jmp    8010630a <alltraps>

80106f2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $187
80106f2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f32:	e9 d3 f3 ff ff       	jmp    8010630a <alltraps>

80106f37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $188
80106f39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f3e:	e9 c7 f3 ff ff       	jmp    8010630a <alltraps>

80106f43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $189
80106f45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f4a:	e9 bb f3 ff ff       	jmp    8010630a <alltraps>

80106f4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $190
80106f51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f56:	e9 af f3 ff ff       	jmp    8010630a <alltraps>

80106f5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $191
80106f5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f62:	e9 a3 f3 ff ff       	jmp    8010630a <alltraps>

80106f67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $192
80106f69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f6e:	e9 97 f3 ff ff       	jmp    8010630a <alltraps>

80106f73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $193
80106f75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f7a:	e9 8b f3 ff ff       	jmp    8010630a <alltraps>

80106f7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $194
80106f81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f86:	e9 7f f3 ff ff       	jmp    8010630a <alltraps>

80106f8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $195
80106f8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f92:	e9 73 f3 ff ff       	jmp    8010630a <alltraps>

80106f97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $196
80106f99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f9e:	e9 67 f3 ff ff       	jmp    8010630a <alltraps>

80106fa3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $197
80106fa5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106faa:	e9 5b f3 ff ff       	jmp    8010630a <alltraps>

80106faf <vector198>:
.globl vector198
vector198:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $198
80106fb1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106fb6:	e9 4f f3 ff ff       	jmp    8010630a <alltraps>

80106fbb <vector199>:
.globl vector199
vector199:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $199
80106fbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106fc2:	e9 43 f3 ff ff       	jmp    8010630a <alltraps>

80106fc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $200
80106fc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fce:	e9 37 f3 ff ff       	jmp    8010630a <alltraps>

80106fd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $201
80106fd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fda:	e9 2b f3 ff ff       	jmp    8010630a <alltraps>

80106fdf <vector202>:
.globl vector202
vector202:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $202
80106fe1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fe6:	e9 1f f3 ff ff       	jmp    8010630a <alltraps>

80106feb <vector203>:
.globl vector203
vector203:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $203
80106fed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ff2:	e9 13 f3 ff ff       	jmp    8010630a <alltraps>

80106ff7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $204
80106ff9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ffe:	e9 07 f3 ff ff       	jmp    8010630a <alltraps>

80107003 <vector205>:
.globl vector205
vector205:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $205
80107005:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010700a:	e9 fb f2 ff ff       	jmp    8010630a <alltraps>

8010700f <vector206>:
.globl vector206
vector206:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $206
80107011:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107016:	e9 ef f2 ff ff       	jmp    8010630a <alltraps>

8010701b <vector207>:
.globl vector207
vector207:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $207
8010701d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107022:	e9 e3 f2 ff ff       	jmp    8010630a <alltraps>

80107027 <vector208>:
.globl vector208
vector208:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $208
80107029:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010702e:	e9 d7 f2 ff ff       	jmp    8010630a <alltraps>

80107033 <vector209>:
.globl vector209
vector209:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $209
80107035:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010703a:	e9 cb f2 ff ff       	jmp    8010630a <alltraps>

8010703f <vector210>:
.globl vector210
vector210:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $210
80107041:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107046:	e9 bf f2 ff ff       	jmp    8010630a <alltraps>

8010704b <vector211>:
.globl vector211
vector211:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $211
8010704d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107052:	e9 b3 f2 ff ff       	jmp    8010630a <alltraps>

80107057 <vector212>:
.globl vector212
vector212:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $212
80107059:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010705e:	e9 a7 f2 ff ff       	jmp    8010630a <alltraps>

80107063 <vector213>:
.globl vector213
vector213:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $213
80107065:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010706a:	e9 9b f2 ff ff       	jmp    8010630a <alltraps>

8010706f <vector214>:
.globl vector214
vector214:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $214
80107071:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107076:	e9 8f f2 ff ff       	jmp    8010630a <alltraps>

8010707b <vector215>:
.globl vector215
vector215:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $215
8010707d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107082:	e9 83 f2 ff ff       	jmp    8010630a <alltraps>

80107087 <vector216>:
.globl vector216
vector216:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $216
80107089:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010708e:	e9 77 f2 ff ff       	jmp    8010630a <alltraps>

80107093 <vector217>:
.globl vector217
vector217:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $217
80107095:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010709a:	e9 6b f2 ff ff       	jmp    8010630a <alltraps>

8010709f <vector218>:
.globl vector218
vector218:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $218
801070a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070a6:	e9 5f f2 ff ff       	jmp    8010630a <alltraps>

801070ab <vector219>:
.globl vector219
vector219:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $219
801070ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070b2:	e9 53 f2 ff ff       	jmp    8010630a <alltraps>

801070b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $220
801070b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070be:	e9 47 f2 ff ff       	jmp    8010630a <alltraps>

801070c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $221
801070c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070ca:	e9 3b f2 ff ff       	jmp    8010630a <alltraps>

801070cf <vector222>:
.globl vector222
vector222:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $222
801070d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070d6:	e9 2f f2 ff ff       	jmp    8010630a <alltraps>

801070db <vector223>:
.globl vector223
vector223:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $223
801070dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070e2:	e9 23 f2 ff ff       	jmp    8010630a <alltraps>

801070e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $224
801070e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070ee:	e9 17 f2 ff ff       	jmp    8010630a <alltraps>

801070f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $225
801070f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070fa:	e9 0b f2 ff ff       	jmp    8010630a <alltraps>

801070ff <vector226>:
.globl vector226
vector226:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $226
80107101:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107106:	e9 ff f1 ff ff       	jmp    8010630a <alltraps>

8010710b <vector227>:
.globl vector227
vector227:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $227
8010710d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107112:	e9 f3 f1 ff ff       	jmp    8010630a <alltraps>

80107117 <vector228>:
.globl vector228
vector228:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $228
80107119:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010711e:	e9 e7 f1 ff ff       	jmp    8010630a <alltraps>

80107123 <vector229>:
.globl vector229
vector229:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $229
80107125:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010712a:	e9 db f1 ff ff       	jmp    8010630a <alltraps>

8010712f <vector230>:
.globl vector230
vector230:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $230
80107131:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107136:	e9 cf f1 ff ff       	jmp    8010630a <alltraps>

8010713b <vector231>:
.globl vector231
vector231:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $231
8010713d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107142:	e9 c3 f1 ff ff       	jmp    8010630a <alltraps>

80107147 <vector232>:
.globl vector232
vector232:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $232
80107149:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010714e:	e9 b7 f1 ff ff       	jmp    8010630a <alltraps>

80107153 <vector233>:
.globl vector233
vector233:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $233
80107155:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010715a:	e9 ab f1 ff ff       	jmp    8010630a <alltraps>

8010715f <vector234>:
.globl vector234
vector234:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $234
80107161:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107166:	e9 9f f1 ff ff       	jmp    8010630a <alltraps>

8010716b <vector235>:
.globl vector235
vector235:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $235
8010716d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107172:	e9 93 f1 ff ff       	jmp    8010630a <alltraps>

80107177 <vector236>:
.globl vector236
vector236:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $236
80107179:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010717e:	e9 87 f1 ff ff       	jmp    8010630a <alltraps>

80107183 <vector237>:
.globl vector237
vector237:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $237
80107185:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010718a:	e9 7b f1 ff ff       	jmp    8010630a <alltraps>

8010718f <vector238>:
.globl vector238
vector238:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $238
80107191:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107196:	e9 6f f1 ff ff       	jmp    8010630a <alltraps>

8010719b <vector239>:
.globl vector239
vector239:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $239
8010719d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071a2:	e9 63 f1 ff ff       	jmp    8010630a <alltraps>

801071a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $240
801071a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071ae:	e9 57 f1 ff ff       	jmp    8010630a <alltraps>

801071b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $241
801071b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071ba:	e9 4b f1 ff ff       	jmp    8010630a <alltraps>

801071bf <vector242>:
.globl vector242
vector242:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $242
801071c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071c6:	e9 3f f1 ff ff       	jmp    8010630a <alltraps>

801071cb <vector243>:
.globl vector243
vector243:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $243
801071cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071d2:	e9 33 f1 ff ff       	jmp    8010630a <alltraps>

801071d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $244
801071d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071de:	e9 27 f1 ff ff       	jmp    8010630a <alltraps>

801071e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $245
801071e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071ea:	e9 1b f1 ff ff       	jmp    8010630a <alltraps>

801071ef <vector246>:
.globl vector246
vector246:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $246
801071f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071f6:	e9 0f f1 ff ff       	jmp    8010630a <alltraps>

801071fb <vector247>:
.globl vector247
vector247:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $247
801071fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107202:	e9 03 f1 ff ff       	jmp    8010630a <alltraps>

80107207 <vector248>:
.globl vector248
vector248:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $248
80107209:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010720e:	e9 f7 f0 ff ff       	jmp    8010630a <alltraps>

80107213 <vector249>:
.globl vector249
vector249:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $249
80107215:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010721a:	e9 eb f0 ff ff       	jmp    8010630a <alltraps>

8010721f <vector250>:
.globl vector250
vector250:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $250
80107221:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107226:	e9 df f0 ff ff       	jmp    8010630a <alltraps>

8010722b <vector251>:
.globl vector251
vector251:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $251
8010722d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107232:	e9 d3 f0 ff ff       	jmp    8010630a <alltraps>

80107237 <vector252>:
.globl vector252
vector252:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $252
80107239:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010723e:	e9 c7 f0 ff ff       	jmp    8010630a <alltraps>

80107243 <vector253>:
.globl vector253
vector253:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $253
80107245:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010724a:	e9 bb f0 ff ff       	jmp    8010630a <alltraps>

8010724f <vector254>:
.globl vector254
vector254:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $254
80107251:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107256:	e9 af f0 ff ff       	jmp    8010630a <alltraps>

8010725b <vector255>:
.globl vector255
vector255:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $255
8010725d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107262:	e9 a3 f0 ff ff       	jmp    8010630a <alltraps>
80107267:	66 90                	xchg   %ax,%ax
80107269:	66 90                	xchg   %ax,%ax
8010726b:	66 90                	xchg   %ax,%ax
8010726d:	66 90                	xchg   %ax,%ax
8010726f:	90                   	nop

80107270 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107276:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010727c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107282:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80107285:	39 d3                	cmp    %edx,%ebx
80107287:	73 56                	jae    801072df <deallocuvm.part.0+0x6f>
80107289:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010728c:	89 c6                	mov    %eax,%esi
8010728e:	89 d7                	mov    %edx,%edi
80107290:	eb 12                	jmp    801072a4 <deallocuvm.part.0+0x34>
80107292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107298:	83 c2 01             	add    $0x1,%edx
8010729b:	89 d3                	mov    %edx,%ebx
8010729d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801072a0:	39 fb                	cmp    %edi,%ebx
801072a2:	73 38                	jae    801072dc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801072a4:	89 da                	mov    %ebx,%edx
801072a6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801072a9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801072ac:	a8 01                	test   $0x1,%al
801072ae:	74 e8                	je     80107298 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801072b0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072b7:	c1 e9 0a             	shr    $0xa,%ecx
801072ba:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801072c0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801072c7:	85 c0                	test   %eax,%eax
801072c9:	74 cd                	je     80107298 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801072cb:	8b 10                	mov    (%eax),%edx
801072cd:	f6 c2 01             	test   $0x1,%dl
801072d0:	75 1e                	jne    801072f0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801072d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072d8:	39 fb                	cmp    %edi,%ebx
801072da:	72 c8                	jb     801072a4 <deallocuvm.part.0+0x34>
801072dc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801072df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e2:	89 c8                	mov    %ecx,%eax
801072e4:	5b                   	pop    %ebx
801072e5:	5e                   	pop    %esi
801072e6:	5f                   	pop    %edi
801072e7:	5d                   	pop    %ebp
801072e8:	c3                   	ret
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801072f0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801072f6:	74 26                	je     8010731e <deallocuvm.part.0+0xae>
      kfree(v);
801072f8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801072fb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107304:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010730a:	52                   	push   %edx
8010730b:	e8 60 bc ff ff       	call   80102f70 <kfree>
      *pte = 0;
80107310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80107313:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010731c:	eb 82                	jmp    801072a0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010731e:	83 ec 0c             	sub    $0xc,%esp
80107321:	68 0c 7e 10 80       	push   $0x80107e0c
80107326:	e8 45 90 ff ff       	call   80100370 <panic>
8010732b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107330 <mappages>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107336:	89 d3                	mov    %edx,%ebx
80107338:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010733e:	83 ec 1c             	sub    $0x1c,%esp
80107341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107344:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107348:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010734d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107350:	8b 45 08             	mov    0x8(%ebp),%eax
80107353:	29 d8                	sub    %ebx,%eax
80107355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107358:	eb 3f                	jmp    80107399 <mappages+0x69>
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107360:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107362:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107367:	c1 ea 0a             	shr    $0xa,%edx
8010736a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107370:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107377:	85 c0                	test   %eax,%eax
80107379:	74 75                	je     801073f0 <mappages+0xc0>
    if(*pte & PTE_P)
8010737b:	f6 00 01             	testb  $0x1,(%eax)
8010737e:	0f 85 86 00 00 00    	jne    8010740a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107384:	0b 75 0c             	or     0xc(%ebp),%esi
80107387:	83 ce 01             	or     $0x1,%esi
8010738a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010738c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010738f:	39 c3                	cmp    %eax,%ebx
80107391:	74 6d                	je     80107400 <mappages+0xd0>
    a += PGSIZE;
80107393:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010739c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010739f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801073a2:	89 d8                	mov    %ebx,%eax
801073a4:	c1 e8 16             	shr    $0x16,%eax
801073a7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801073aa:	8b 07                	mov    (%edi),%eax
801073ac:	a8 01                	test   $0x1,%al
801073ae:	75 b0                	jne    80107360 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801073b0:	e8 7b bd ff ff       	call   80103130 <kalloc>
801073b5:	85 c0                	test   %eax,%eax
801073b7:	74 37                	je     801073f0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801073b9:	83 ec 04             	sub    $0x4,%esp
801073bc:	68 00 10 00 00       	push   $0x1000
801073c1:	6a 00                	push   $0x0
801073c3:	50                   	push   %eax
801073c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801073c7:	e8 a4 dd ff ff       	call   80105170 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801073cf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801073d2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801073d8:	83 c8 07             	or     $0x7,%eax
801073db:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801073dd:	89 d8                	mov    %ebx,%eax
801073df:	c1 e8 0a             	shr    $0xa,%eax
801073e2:	25 fc 0f 00 00       	and    $0xffc,%eax
801073e7:	01 d0                	add    %edx,%eax
801073e9:	eb 90                	jmp    8010737b <mappages+0x4b>
801073eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
801073f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073f8:	5b                   	pop    %ebx
801073f9:	5e                   	pop    %esi
801073fa:	5f                   	pop    %edi
801073fb:	5d                   	pop    %ebp
801073fc:	c3                   	ret
801073fd:	8d 76 00             	lea    0x0(%esi),%esi
80107400:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107403:	31 c0                	xor    %eax,%eax
}
80107405:	5b                   	pop    %ebx
80107406:	5e                   	pop    %esi
80107407:	5f                   	pop    %edi
80107408:	5d                   	pop    %ebp
80107409:	c3                   	ret
      panic("remap");
8010740a:	83 ec 0c             	sub    $0xc,%esp
8010740d:	68 40 80 10 80       	push   $0x80108040
80107412:	e8 59 8f ff ff       	call   80100370 <panic>
80107417:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010741e:	00 
8010741f:	90                   	nop

80107420 <seginit>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107426:	e8 e5 cf ff ff       	call   80104410 <cpuid>
  pd[0] = size-1;
8010742b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107430:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107436:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010743a:	c7 80 98 2a 11 80 ff 	movl   $0xffff,-0x7feed568(%eax)
80107441:	ff 00 00 
80107444:	c7 80 9c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed564(%eax)
8010744b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010744e:	c7 80 a0 2a 11 80 ff 	movl   $0xffff,-0x7feed560(%eax)
80107455:	ff 00 00 
80107458:	c7 80 a4 2a 11 80 00 	movl   $0xcf9200,-0x7feed55c(%eax)
8010745f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107462:	c7 80 a8 2a 11 80 ff 	movl   $0xffff,-0x7feed558(%eax)
80107469:	ff 00 00 
8010746c:	c7 80 ac 2a 11 80 00 	movl   $0xcffa00,-0x7feed554(%eax)
80107473:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107476:	c7 80 b0 2a 11 80 ff 	movl   $0xffff,-0x7feed550(%eax)
8010747d:	ff 00 00 
80107480:	c7 80 b4 2a 11 80 00 	movl   $0xcff200,-0x7feed54c(%eax)
80107487:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010748a:	05 90 2a 11 80       	add    $0x80112a90,%eax
  pd[1] = (uint)p;
8010748f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107493:	c1 e8 10             	shr    $0x10,%eax
80107496:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010749a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010749d:	0f 01 10             	lgdtl  (%eax)
}
801074a0:	c9                   	leave
801074a1:	c3                   	ret
801074a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074a9:	00 
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074b0:	a1 44 57 11 80       	mov    0x80115744,%eax
801074b5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074ba:	0f 22 d8             	mov    %eax,%cr3
}
801074bd:	c3                   	ret
801074be:	66 90                	xchg   %ax,%ax

801074c0 <switchuvm>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
801074c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801074cc:	85 f6                	test   %esi,%esi
801074ce:	0f 84 cb 00 00 00    	je     8010759f <switchuvm+0xdf>
  if(p->kstack == 0)
801074d4:	8b 46 08             	mov    0x8(%esi),%eax
801074d7:	85 c0                	test   %eax,%eax
801074d9:	0f 84 da 00 00 00    	je     801075b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801074df:	8b 46 04             	mov    0x4(%esi),%eax
801074e2:	85 c0                	test   %eax,%eax
801074e4:	0f 84 c2 00 00 00    	je     801075ac <switchuvm+0xec>
  pushcli();
801074ea:	e8 31 da ff ff       	call   80104f20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074ef:	e8 bc ce ff ff       	call   801043b0 <mycpu>
801074f4:	89 c3                	mov    %eax,%ebx
801074f6:	e8 b5 ce ff ff       	call   801043b0 <mycpu>
801074fb:	89 c7                	mov    %eax,%edi
801074fd:	e8 ae ce ff ff       	call   801043b0 <mycpu>
80107502:	83 c7 08             	add    $0x8,%edi
80107505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107508:	e8 a3 ce ff ff       	call   801043b0 <mycpu>
8010750d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107510:	ba 67 00 00 00       	mov    $0x67,%edx
80107515:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010751c:	83 c0 08             	add    $0x8,%eax
8010751f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107526:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010752b:	83 c1 08             	add    $0x8,%ecx
8010752e:	c1 e8 18             	shr    $0x18,%eax
80107531:	c1 e9 10             	shr    $0x10,%ecx
80107534:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010753a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107540:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107545:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010754c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107551:	e8 5a ce ff ff       	call   801043b0 <mycpu>
80107556:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010755d:	e8 4e ce ff ff       	call   801043b0 <mycpu>
80107562:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107566:	8b 5e 08             	mov    0x8(%esi),%ebx
80107569:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010756f:	e8 3c ce ff ff       	call   801043b0 <mycpu>
80107574:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107577:	e8 34 ce ff ff       	call   801043b0 <mycpu>
8010757c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107580:	b8 28 00 00 00       	mov    $0x28,%eax
80107585:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107588:	8b 46 04             	mov    0x4(%esi),%eax
8010758b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107590:	0f 22 d8             	mov    %eax,%cr3
}
80107593:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107596:	5b                   	pop    %ebx
80107597:	5e                   	pop    %esi
80107598:	5f                   	pop    %edi
80107599:	5d                   	pop    %ebp
  popcli();
8010759a:	e9 d1 d9 ff ff       	jmp    80104f70 <popcli>
    panic("switchuvm: no process");
8010759f:	83 ec 0c             	sub    $0xc,%esp
801075a2:	68 46 80 10 80       	push   $0x80108046
801075a7:	e8 c4 8d ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
801075ac:	83 ec 0c             	sub    $0xc,%esp
801075af:	68 71 80 10 80       	push   $0x80108071
801075b4:	e8 b7 8d ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
801075b9:	83 ec 0c             	sub    $0xc,%esp
801075bc:	68 5c 80 10 80       	push   $0x8010805c
801075c1:	e8 aa 8d ff ff       	call   80100370 <panic>
801075c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075cd:	00 
801075ce:	66 90                	xchg   %ax,%ax

801075d0 <inituvm>:
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	57                   	push   %edi
801075d4:	56                   	push   %esi
801075d5:	53                   	push   %ebx
801075d6:	83 ec 1c             	sub    $0x1c,%esp
801075d9:	8b 45 08             	mov    0x8(%ebp),%eax
801075dc:	8b 75 10             	mov    0x10(%ebp),%esi
801075df:	8b 7d 0c             	mov    0xc(%ebp),%edi
801075e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801075e5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075eb:	77 49                	ja     80107636 <inituvm+0x66>
  mem = kalloc();
801075ed:	e8 3e bb ff ff       	call   80103130 <kalloc>
  memset(mem, 0, PGSIZE);
801075f2:	83 ec 04             	sub    $0x4,%esp
801075f5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075fa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075fc:	6a 00                	push   $0x0
801075fe:	50                   	push   %eax
801075ff:	e8 6c db ff ff       	call   80105170 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107604:	58                   	pop    %eax
80107605:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010760b:	5a                   	pop    %edx
8010760c:	6a 06                	push   $0x6
8010760e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107613:	31 d2                	xor    %edx,%edx
80107615:	50                   	push   %eax
80107616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107619:	e8 12 fd ff ff       	call   80107330 <mappages>
  memmove(mem, init, sz);
8010761e:	83 c4 10             	add    $0x10,%esp
80107621:	89 75 10             	mov    %esi,0x10(%ebp)
80107624:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107627:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010762a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107631:	e9 ca db ff ff       	jmp    80105200 <memmove>
    panic("inituvm: more than a page");
80107636:	83 ec 0c             	sub    $0xc,%esp
80107639:	68 85 80 10 80       	push   $0x80108085
8010763e:	e8 2d 8d ff ff       	call   80100370 <panic>
80107643:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010764a:	00 
8010764b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107650 <loaduvm>:
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	57                   	push   %edi
80107654:	56                   	push   %esi
80107655:	53                   	push   %ebx
80107656:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107659:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010765c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010765f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107665:	0f 85 a2 00 00 00    	jne    8010770d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010766b:	85 ff                	test   %edi,%edi
8010766d:	74 7d                	je     801076ec <loaduvm+0x9c>
8010766f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107670:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107673:	8b 55 08             	mov    0x8(%ebp),%edx
80107676:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107678:	89 c1                	mov    %eax,%ecx
8010767a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010767d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107680:	f6 c1 01             	test   $0x1,%cl
80107683:	75 13                	jne    80107698 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107685:	83 ec 0c             	sub    $0xc,%esp
80107688:	68 9f 80 10 80       	push   $0x8010809f
8010768d:	e8 de 8c ff ff       	call   80100370 <panic>
80107692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107698:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010769b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076a1:	25 fc 0f 00 00       	and    $0xffc,%eax
801076a6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801076ad:	85 c9                	test   %ecx,%ecx
801076af:	74 d4                	je     80107685 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801076b1:	89 fb                	mov    %edi,%ebx
801076b3:	b8 00 10 00 00       	mov    $0x1000,%eax
801076b8:	29 f3                	sub    %esi,%ebx
801076ba:	39 c3                	cmp    %eax,%ebx
801076bc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076bf:	53                   	push   %ebx
801076c0:	8b 45 14             	mov    0x14(%ebp),%eax
801076c3:	01 f0                	add    %esi,%eax
801076c5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801076c6:	8b 01                	mov    (%ecx),%eax
801076c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076cd:	05 00 00 00 80       	add    $0x80000000,%eax
801076d2:	50                   	push   %eax
801076d3:	ff 75 10             	push   0x10(%ebp)
801076d6:	e8 a5 ae ff ff       	call   80102580 <readi>
801076db:	83 c4 10             	add    $0x10,%esp
801076de:	39 d8                	cmp    %ebx,%eax
801076e0:	75 1e                	jne    80107700 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801076e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076e8:	39 fe                	cmp    %edi,%esi
801076ea:	72 84                	jb     80107670 <loaduvm+0x20>
}
801076ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076ef:	31 c0                	xor    %eax,%eax
}
801076f1:	5b                   	pop    %ebx
801076f2:	5e                   	pop    %esi
801076f3:	5f                   	pop    %edi
801076f4:	5d                   	pop    %ebp
801076f5:	c3                   	ret
801076f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076fd:	00 
801076fe:	66 90                	xchg   %ax,%ax
80107700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107708:	5b                   	pop    %ebx
80107709:	5e                   	pop    %esi
8010770a:	5f                   	pop    %edi
8010770b:	5d                   	pop    %ebp
8010770c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010770d:	83 ec 0c             	sub    $0xc,%esp
80107710:	68 2c 83 10 80       	push   $0x8010832c
80107715:	e8 56 8c ff ff       	call   80100370 <panic>
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107720 <allocuvm>:
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
80107726:	83 ec 1c             	sub    $0x1c,%esp
80107729:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010772c:	85 f6                	test   %esi,%esi
8010772e:	0f 88 98 00 00 00    	js     801077cc <allocuvm+0xac>
80107734:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107736:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107739:	0f 82 a1 00 00 00    	jb     801077e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010773f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107742:	05 ff 0f 00 00       	add    $0xfff,%eax
80107747:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010774c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010774e:	39 f0                	cmp    %esi,%eax
80107750:	0f 83 8d 00 00 00    	jae    801077e3 <allocuvm+0xc3>
80107756:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107759:	eb 44                	jmp    8010779f <allocuvm+0x7f>
8010775b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107760:	83 ec 04             	sub    $0x4,%esp
80107763:	68 00 10 00 00       	push   $0x1000
80107768:	6a 00                	push   $0x0
8010776a:	50                   	push   %eax
8010776b:	e8 00 da ff ff       	call   80105170 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107770:	58                   	pop    %eax
80107771:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107777:	5a                   	pop    %edx
80107778:	6a 06                	push   $0x6
8010777a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010777f:	89 fa                	mov    %edi,%edx
80107781:	50                   	push   %eax
80107782:	8b 45 08             	mov    0x8(%ebp),%eax
80107785:	e8 a6 fb ff ff       	call   80107330 <mappages>
8010778a:	83 c4 10             	add    $0x10,%esp
8010778d:	85 c0                	test   %eax,%eax
8010778f:	78 5f                	js     801077f0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107791:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107797:	39 f7                	cmp    %esi,%edi
80107799:	0f 83 89 00 00 00    	jae    80107828 <allocuvm+0x108>
    mem = kalloc();
8010779f:	e8 8c b9 ff ff       	call   80103130 <kalloc>
801077a4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801077a6:	85 c0                	test   %eax,%eax
801077a8:	75 b6                	jne    80107760 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801077aa:	83 ec 0c             	sub    $0xc,%esp
801077ad:	68 bd 80 10 80       	push   $0x801080bd
801077b2:	e8 f9 90 ff ff       	call   801008b0 <cprintf>
  if(newsz >= oldsz)
801077b7:	83 c4 10             	add    $0x10,%esp
801077ba:	3b 75 0c             	cmp    0xc(%ebp),%esi
801077bd:	74 0d                	je     801077cc <allocuvm+0xac>
801077bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077c2:	8b 45 08             	mov    0x8(%ebp),%eax
801077c5:	89 f2                	mov    %esi,%edx
801077c7:	e8 a4 fa ff ff       	call   80107270 <deallocuvm.part.0>
    return 0;
801077cc:	31 d2                	xor    %edx,%edx
}
801077ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d1:	89 d0                	mov    %edx,%eax
801077d3:	5b                   	pop    %ebx
801077d4:	5e                   	pop    %esi
801077d5:	5f                   	pop    %edi
801077d6:	5d                   	pop    %ebp
801077d7:	c3                   	ret
801077d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077df:	00 
    return oldsz;
801077e0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801077e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e6:	89 d0                	mov    %edx,%eax
801077e8:	5b                   	pop    %ebx
801077e9:	5e                   	pop    %esi
801077ea:	5f                   	pop    %edi
801077eb:	5d                   	pop    %ebp
801077ec:	c3                   	ret
801077ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	68 d5 80 10 80       	push   $0x801080d5
801077f8:	e8 b3 90 ff ff       	call   801008b0 <cprintf>
  if(newsz >= oldsz)
801077fd:	83 c4 10             	add    $0x10,%esp
80107800:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107803:	74 0d                	je     80107812 <allocuvm+0xf2>
80107805:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107808:	8b 45 08             	mov    0x8(%ebp),%eax
8010780b:	89 f2                	mov    %esi,%edx
8010780d:	e8 5e fa ff ff       	call   80107270 <deallocuvm.part.0>
      kfree(mem);
80107812:	83 ec 0c             	sub    $0xc,%esp
80107815:	53                   	push   %ebx
80107816:	e8 55 b7 ff ff       	call   80102f70 <kfree>
      return 0;
8010781b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010781e:	31 d2                	xor    %edx,%edx
80107820:	eb ac                	jmp    801077ce <allocuvm+0xae>
80107822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107828:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010782b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010782e:	5b                   	pop    %ebx
8010782f:	5e                   	pop    %esi
80107830:	89 d0                	mov    %edx,%eax
80107832:	5f                   	pop    %edi
80107833:	5d                   	pop    %ebp
80107834:	c3                   	ret
80107835:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010783c:	00 
8010783d:	8d 76 00             	lea    0x0(%esi),%esi

80107840 <deallocuvm>:
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	8b 55 0c             	mov    0xc(%ebp),%edx
80107846:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107849:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010784c:	39 d1                	cmp    %edx,%ecx
8010784e:	73 10                	jae    80107860 <deallocuvm+0x20>
}
80107850:	5d                   	pop    %ebp
80107851:	e9 1a fa ff ff       	jmp    80107270 <deallocuvm.part.0>
80107856:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010785d:	00 
8010785e:	66 90                	xchg   %ax,%ax
80107860:	89 d0                	mov    %edx,%eax
80107862:	5d                   	pop    %ebp
80107863:	c3                   	ret
80107864:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010786b:	00 
8010786c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107870 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107870:	55                   	push   %ebp
80107871:	89 e5                	mov    %esp,%ebp
80107873:	57                   	push   %edi
80107874:	56                   	push   %esi
80107875:	53                   	push   %ebx
80107876:	83 ec 0c             	sub    $0xc,%esp
80107879:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010787c:	85 f6                	test   %esi,%esi
8010787e:	74 59                	je     801078d9 <freevm+0x69>
  if(newsz >= oldsz)
80107880:	31 c9                	xor    %ecx,%ecx
80107882:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107887:	89 f0                	mov    %esi,%eax
80107889:	89 f3                	mov    %esi,%ebx
8010788b:	e8 e0 f9 ff ff       	call   80107270 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107890:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107896:	eb 0f                	jmp    801078a7 <freevm+0x37>
80107898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010789f:	00 
801078a0:	83 c3 04             	add    $0x4,%ebx
801078a3:	39 fb                	cmp    %edi,%ebx
801078a5:	74 23                	je     801078ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801078a7:	8b 03                	mov    (%ebx),%eax
801078a9:	a8 01                	test   $0x1,%al
801078ab:	74 f3                	je     801078a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078bd:	50                   	push   %eax
801078be:	e8 ad b6 ff ff       	call   80102f70 <kfree>
801078c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078c6:	39 fb                	cmp    %edi,%ebx
801078c8:	75 dd                	jne    801078a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801078ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d0:	5b                   	pop    %ebx
801078d1:	5e                   	pop    %esi
801078d2:	5f                   	pop    %edi
801078d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078d4:	e9 97 b6 ff ff       	jmp    80102f70 <kfree>
    panic("freevm: no pgdir");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 f1 80 10 80       	push   $0x801080f1
801078e1:	e8 8a 8a ff ff       	call   80100370 <panic>
801078e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078ed:	00 
801078ee:	66 90                	xchg   %ax,%ax

801078f0 <setupkvm>:
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	56                   	push   %esi
801078f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078f5:	e8 36 b8 ff ff       	call   80103130 <kalloc>
801078fa:	85 c0                	test   %eax,%eax
801078fc:	74 5e                	je     8010795c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801078fe:	83 ec 04             	sub    $0x4,%esp
80107901:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107903:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107908:	68 00 10 00 00       	push   $0x1000
8010790d:	6a 00                	push   $0x0
8010790f:	50                   	push   %eax
80107910:	e8 5b d8 ff ff       	call   80105170 <memset>
80107915:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107918:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010791b:	83 ec 08             	sub    $0x8,%esp
8010791e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107921:	8b 13                	mov    (%ebx),%edx
80107923:	ff 73 0c             	push   0xc(%ebx)
80107926:	50                   	push   %eax
80107927:	29 c1                	sub    %eax,%ecx
80107929:	89 f0                	mov    %esi,%eax
8010792b:	e8 00 fa ff ff       	call   80107330 <mappages>
80107930:	83 c4 10             	add    $0x10,%esp
80107933:	85 c0                	test   %eax,%eax
80107935:	78 19                	js     80107950 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107937:	83 c3 10             	add    $0x10,%ebx
8010793a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107940:	75 d6                	jne    80107918 <setupkvm+0x28>
}
80107942:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107945:	89 f0                	mov    %esi,%eax
80107947:	5b                   	pop    %ebx
80107948:	5e                   	pop    %esi
80107949:	5d                   	pop    %ebp
8010794a:	c3                   	ret
8010794b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	56                   	push   %esi
80107954:	e8 17 ff ff ff       	call   80107870 <freevm>
      return 0;
80107959:	83 c4 10             	add    $0x10,%esp
}
8010795c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010795f:	31 f6                	xor    %esi,%esi
}
80107961:	89 f0                	mov    %esi,%eax
80107963:	5b                   	pop    %ebx
80107964:	5e                   	pop    %esi
80107965:	5d                   	pop    %ebp
80107966:	c3                   	ret
80107967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010796e:	00 
8010796f:	90                   	nop

80107970 <kvmalloc>:
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107976:	e8 75 ff ff ff       	call   801078f0 <setupkvm>
8010797b:	a3 44 57 11 80       	mov    %eax,0x80115744
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107980:	05 00 00 00 80       	add    $0x80000000,%eax
80107985:	0f 22 d8             	mov    %eax,%cr3
}
80107988:	c9                   	leave
80107989:	c3                   	ret
8010798a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107990 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	83 ec 08             	sub    $0x8,%esp
80107996:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107999:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010799c:	89 c1                	mov    %eax,%ecx
8010799e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079a4:	f6 c2 01             	test   $0x1,%dl
801079a7:	75 17                	jne    801079c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801079a9:	83 ec 0c             	sub    $0xc,%esp
801079ac:	68 02 81 10 80       	push   $0x80108102
801079b1:	e8 ba 89 ff ff       	call   80100370 <panic>
801079b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079bd:	00 
801079be:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801079c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801079c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801079ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801079d5:	85 c0                	test   %eax,%eax
801079d7:	74 d0                	je     801079a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801079d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079dc:	c9                   	leave
801079dd:	c3                   	ret
801079de:	66 90                	xchg   %ax,%ax

801079e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079e9:	e8 02 ff ff ff       	call   801078f0 <setupkvm>
801079ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079f1:	85 c0                	test   %eax,%eax
801079f3:	0f 84 e9 00 00 00    	je     80107ae2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079fc:	85 c9                	test   %ecx,%ecx
801079fe:	0f 84 b2 00 00 00    	je     80107ab6 <copyuvm+0xd6>
80107a04:	31 f6                	xor    %esi,%esi
80107a06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a0d:	00 
80107a0e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107a10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107a13:	89 f0                	mov    %esi,%eax
80107a15:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107a18:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107a1b:	a8 01                	test   $0x1,%al
80107a1d:	75 11                	jne    80107a30 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107a1f:	83 ec 0c             	sub    $0xc,%esp
80107a22:	68 0c 81 10 80       	push   $0x8010810c
80107a27:	e8 44 89 ff ff       	call   80100370 <panic>
80107a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107a30:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107a37:	c1 ea 0a             	shr    $0xa,%edx
80107a3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107a40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a47:	85 c0                	test   %eax,%eax
80107a49:	74 d4                	je     80107a1f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107a4b:	8b 00                	mov    (%eax),%eax
80107a4d:	a8 01                	test   $0x1,%al
80107a4f:	0f 84 9f 00 00 00    	je     80107af4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107a55:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a57:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a5f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a65:	e8 c6 b6 ff ff       	call   80103130 <kalloc>
80107a6a:	89 c3                	mov    %eax,%ebx
80107a6c:	85 c0                	test   %eax,%eax
80107a6e:	74 64                	je     80107ad4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a70:	83 ec 04             	sub    $0x4,%esp
80107a73:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a79:	68 00 10 00 00       	push   $0x1000
80107a7e:	57                   	push   %edi
80107a7f:	50                   	push   %eax
80107a80:	e8 7b d7 ff ff       	call   80105200 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a85:	58                   	pop    %eax
80107a86:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a8c:	5a                   	pop    %edx
80107a8d:	ff 75 e4             	push   -0x1c(%ebp)
80107a90:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a95:	89 f2                	mov    %esi,%edx
80107a97:	50                   	push   %eax
80107a98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a9b:	e8 90 f8 ff ff       	call   80107330 <mappages>
80107aa0:	83 c4 10             	add    $0x10,%esp
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	78 21                	js     80107ac8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107aa7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107aad:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107ab0:	0f 82 5a ff ff ff    	jb     80107a10 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107abc:	5b                   	pop    %ebx
80107abd:	5e                   	pop    %esi
80107abe:	5f                   	pop    %edi
80107abf:	5d                   	pop    %ebp
80107ac0:	c3                   	ret
80107ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107ac8:	83 ec 0c             	sub    $0xc,%esp
80107acb:	53                   	push   %ebx
80107acc:	e8 9f b4 ff ff       	call   80102f70 <kfree>
      goto bad;
80107ad1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ad4:	83 ec 0c             	sub    $0xc,%esp
80107ad7:	ff 75 e0             	push   -0x20(%ebp)
80107ada:	e8 91 fd ff ff       	call   80107870 <freevm>
  return 0;
80107adf:	83 c4 10             	add    $0x10,%esp
    return 0;
80107ae2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107aef:	5b                   	pop    %ebx
80107af0:	5e                   	pop    %esi
80107af1:	5f                   	pop    %edi
80107af2:	5d                   	pop    %ebp
80107af3:	c3                   	ret
      panic("copyuvm: page not present");
80107af4:	83 ec 0c             	sub    $0xc,%esp
80107af7:	68 26 81 10 80       	push   $0x80108126
80107afc:	e8 6f 88 ff ff       	call   80100370 <panic>
80107b01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b08:	00 
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107b16:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107b19:	89 c1                	mov    %eax,%ecx
80107b1b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107b1e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107b21:	f6 c2 01             	test   $0x1,%dl
80107b24:	0f 84 f8 00 00 00    	je     80107c22 <uva2ka.cold>
  return &pgtab[PTX(va)];
80107b2a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b2d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b33:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107b34:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107b39:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b40:	89 d0                	mov    %edx,%eax
80107b42:	f7 d2                	not    %edx
80107b44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b49:	05 00 00 00 80       	add    $0x80000000,%eax
80107b4e:	83 e2 05             	and    $0x5,%edx
80107b51:	ba 00 00 00 00       	mov    $0x0,%edx
80107b56:	0f 45 c2             	cmovne %edx,%eax
}
80107b59:	c3                   	ret
80107b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b60:	55                   	push   %ebp
80107b61:	89 e5                	mov    %esp,%ebp
80107b63:	57                   	push   %edi
80107b64:	56                   	push   %esi
80107b65:	53                   	push   %ebx
80107b66:	83 ec 0c             	sub    $0xc,%esp
80107b69:	8b 75 14             	mov    0x14(%ebp),%esi
80107b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b6f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b72:	85 f6                	test   %esi,%esi
80107b74:	75 51                	jne    80107bc7 <copyout+0x67>
80107b76:	e9 9d 00 00 00       	jmp    80107c18 <copyout+0xb8>
80107b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107b80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b86:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107b8c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107b92:	74 74                	je     80107c08 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107b94:	89 fb                	mov    %edi,%ebx
80107b96:	29 c3                	sub    %eax,%ebx
80107b98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b9e:	39 f3                	cmp    %esi,%ebx
80107ba0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ba3:	29 f8                	sub    %edi,%eax
80107ba5:	83 ec 04             	sub    $0x4,%esp
80107ba8:	01 c1                	add    %eax,%ecx
80107baa:	53                   	push   %ebx
80107bab:	52                   	push   %edx
80107bac:	89 55 10             	mov    %edx,0x10(%ebp)
80107baf:	51                   	push   %ecx
80107bb0:	e8 4b d6 ff ff       	call   80105200 <memmove>
    len -= n;
    buf += n;
80107bb5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107bb8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107bbe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107bc1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107bc3:	29 de                	sub    %ebx,%esi
80107bc5:	74 51                	je     80107c18 <copyout+0xb8>
  if(*pde & PTE_P){
80107bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107bca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107bcc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107bce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107bd1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107bd7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107bda:	f6 c1 01             	test   $0x1,%cl
80107bdd:	0f 84 46 00 00 00    	je     80107c29 <copyout.cold>
  return &pgtab[PTX(va)];
80107be3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107be5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107beb:	c1 eb 0c             	shr    $0xc,%ebx
80107bee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107bf4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107bfb:	89 d9                	mov    %ebx,%ecx
80107bfd:	f7 d1                	not    %ecx
80107bff:	83 e1 05             	and    $0x5,%ecx
80107c02:	0f 84 78 ff ff ff    	je     80107b80 <copyout+0x20>
  }
  return 0;
}
80107c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107c0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c10:	5b                   	pop    %ebx
80107c11:	5e                   	pop    %esi
80107c12:	5f                   	pop    %edi
80107c13:	5d                   	pop    %ebp
80107c14:	c3                   	ret
80107c15:	8d 76 00             	lea    0x0(%esi),%esi
80107c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c1b:	31 c0                	xor    %eax,%eax
}
80107c1d:	5b                   	pop    %ebx
80107c1e:	5e                   	pop    %esi
80107c1f:	5f                   	pop    %edi
80107c20:	5d                   	pop    %ebp
80107c21:	c3                   	ret

80107c22 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107c22:	a1 00 00 00 00       	mov    0x0,%eax
80107c27:	0f 0b                	ud2

80107c29 <copyout.cold>:
80107c29:	a1 00 00 00 00       	mov    0x0,%eax
80107c2e:	0f 0b                	ud2
