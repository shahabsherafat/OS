
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
8010002d:	b8 c0 35 10 80       	mov    $0x801035c0,%eax
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
8010004c:	68 00 77 10 80       	push   $0x80107700
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 e5 48 00 00       	call   80104940 <initlock>
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
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 73 47 00 00       	call   80104810 <initsleeplock>
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
801000e4:	e8 47 4a 00 00       	call   80104b30 <acquire>
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
80100162:	e8 69 49 00 00       	call   80104ad0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 46 00 00       	call   80104850 <acquiresleep>
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
8010018c:	e8 cf 26 00 00       	call   80102860 <iderw>
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
801001a1:	68 0e 77 10 80       	push   $0x8010770e
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
801001be:	e8 2d 47 00 00       	call   801048f0 <holdingsleep>
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
801001d4:	e9 87 26 00 00       	jmp    80102860 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 77 10 80       	push   $0x8010771f
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
801001ff:	e8 ec 46 00 00       	call   801048f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 46 00 00       	call   801048b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 10 49 00 00       	call   80104b30 <acquire>
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
80100269:	e9 62 48 00 00       	jmp    80104ad0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 77 10 80       	push   $0x80107726
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
80100290:	e8 7b 1b 00 00       	call   80101e10 <iunlock>
  target = n;
  acquire(&cons.lock);
80100295:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010029c:	e8 8f 48 00 00       	call   80104b30 <acquire>
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
801002cd:	e8 de 42 00 00       	call   801045b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 3c 00 00       	call   80103ef0 <myproc>
801002e7:	8b 40 24             	mov    0x24(%eax),%eax
801002ea:	85 c0                	test   %eax,%eax
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 d5 47 00 00       	call   80104ad0 <release>
        ilock(ip);
801002fb:	89 3c 24             	mov    %edi,(%esp)
801002fe:	e8 2d 1a 00 00       	call   80101d30 <ilock>
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
80100344:	e8 87 47 00 00       	call   80104ad0 <release>
  ilock(ip);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 df 19 00 00       	call   80101d30 <ilock>
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
80100389:	e8 d2 2a 00 00       	call   80102e60 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 2d 77 10 80       	push   $0x8010772d
80100397:	e8 c4 03 00 00       	call   80100760 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	push   0x8(%ebp)
801003a0:	e8 bb 03 00 00       	call   80100760 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 af 7b 10 80 	movl   $0x80107baf,(%esp)
801003ac:	e8 af 03 00 00       	call   80100760 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	8d 45 08             	lea    0x8(%ebp),%eax
801003b4:	5a                   	pop    %edx
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 a3 45 00 00       	call   80104960 <getcallerpcs>
  for(i=0; i<10; i++)
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003c8:	68 41 77 10 80       	push   $0x80107741
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
80100425:	e8 16 5e 00 00       	call   80106240 <uartputc>
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
801004c9:	e8 72 5d 00 00       	call   80106240 <uartputc>
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
8010050e:	68 45 77 10 80       	push   $0x80107745
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
8010053a:	e8 81 47 00 00       	call   80104cc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010053f:	b8 80 07 00 00       	mov    $0x780,%eax
80100544:	83 c4 0c             	add    $0xc,%esp
80100547:	29 d8                	sub    %ebx,%eax
80100549:	01 c0                	add    %eax,%eax
8010054b:	50                   	push   %eax
8010054c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100553:	6a 00                	push   $0x0
80100555:	50                   	push   %eax
80100556:	e8 d5 46 00 00       	call   80104c30 <memset>
  outb(CRTPORT+1, pos);
8010055b:	83 c4 10             	add    $0x10,%esp
8010055e:	e9 27 ff ff ff       	jmp    8010048a <consputc.part.0+0x9a>
80100563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100568:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100570:	6a 08                	push   $0x8
80100572:	e8 c9 5c 00 00       	call   80106240 <uartputc>
80100577:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010057e:	e8 bd 5c 00 00       	call   80106240 <uartputc>
80100583:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010058a:	e8 b1 5c 00 00       	call   80106240 <uartputc>
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
8010061a:	e8 21 5c 00 00       	call   80106240 <uartputc>
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
8010066f:	e8 9c 17 00 00       	call   80101e10 <iunlock>
  acquire(&cons.lock);
80100674:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010067b:	e8 b0 44 00 00       	call   80104b30 <acquire>
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
801006b6:	e8 15 44 00 00       	call   80104ad0 <release>
  ilock(ip);
801006bb:	58                   	pop    %eax
801006bc:	ff 75 08             	push   0x8(%ebp)
801006bf:	e8 6c 16 00 00       	call   80101d30 <ilock>

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
801006fb:	0f b6 92 58 7c 10 80 	movzbl -0x7fef83a8(%edx),%edx
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
80100888:	e8 a3 42 00 00       	call   80104b30 <acquire>
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
801008ab:	e8 20 42 00 00       	call   80104ad0 <release>
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
801008e8:	bf 58 77 10 80       	mov    $0x80107758,%edi
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
80100965:	68 5f 77 10 80       	push   $0x8010775f
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
80100983:	e8 a8 41 00 00       	call   80104b30 <acquire>
  while((c = getc()) >= 0){
80100988:	83 c4 10             	add    $0x10,%esp
8010098b:	ff d6                	call   *%esi
8010098d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100990:	85 c0                	test   %eax,%eax
80100992:	0f 88 70 02 00 00    	js     80100c08 <consoleintr+0x298>
    switch(c){
80100998:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010099b:	83 f8 15             	cmp    $0x15,%eax
8010099e:	7f 10                	jg     801009b0 <consoleintr+0x40>
801009a0:	85 c0                	test   %eax,%eax
801009a2:	74 e7                	je     8010098b <consoleintr+0x1b>
801009a4:	83 f8 15             	cmp    $0x15,%eax
801009a7:	77 27                	ja     801009d0 <consoleintr+0x60>
801009a9:	ff 24 85 00 7c 10 80 	jmp    *-0x7fef8400(,%eax,4)
801009b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009b3:	3d e4 00 00 00       	cmp    $0xe4,%eax
801009b8:	74 76                	je     80100a30 <consoleintr+0xc0>
801009ba:	3d e5 00 00 00       	cmp    $0xe5,%eax
801009bf:	0f 84 13 02 00 00    	je     80100bd8 <consoleintr+0x268>
801009c5:	83 f8 7f             	cmp    $0x7f,%eax
801009c8:	0f 84 da 00 00 00    	je     80100aa8 <consoleintr+0x138>
801009ce:	66 90                	xchg   %ax,%ax
      if(input.e < input.real_end){
801009d0:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
801009d5:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
801009db:	89 c2                	mov    %eax,%edx
801009dd:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
      if(input.e < input.real_end){
801009e3:	39 c1                	cmp    %eax,%ecx
801009e5:	0f 83 05 03 00 00    	jae    80100cf0 <consoleintr+0x380>
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
801009eb:	83 fa 7f             	cmp    $0x7f,%edx
801009ee:	77 9b                	ja     8010098b <consoleintr+0x1b>
  if(panicked){
801009f0:	8b 1d 58 ff 10 80    	mov    0x8010ff58,%ebx
          if(c != '\n'){
801009f6:	83 7d e4 0a          	cmpl   $0xa,-0x1c(%ebp)
              input.buf[input.e++ % INPUT_BUF] = '\n';
801009fa:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009fd:	89 5d dc             	mov    %ebx,-0x24(%ebp)
          if(c != '\n'){
80100a00:	0f 85 53 04 00 00    	jne    80100e59 <consoleintr+0x4e9>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a06:	83 e0 7f             	and    $0x7f,%eax
80100a09:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a0f:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
80100a16:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100a1c:	85 db                	test   %ebx,%ebx
80100a1e:	0f 84 68 05 00 00    	je     80100f8c <consoleintr+0x61c>
80100a24:	fa                   	cli
    for(;;)
80100a25:	eb fe                	jmp    80100a25 <consoleintr+0xb5>
80100a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a2e:	00 
80100a2f:	90                   	nop
      if (input.e > input.w){
80100a30:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a35:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100a3b:	0f 83 4a ff ff ff    	jae    8010098b <consoleintr+0x1b>
        input.e--;
80100a41:	83 e8 01             	sub    $0x1,%eax
80100a44:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a49:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	0f 84 f2 02 00 00    	je     80100d48 <consoleintr+0x3d8>
80100a56:	fa                   	cli
    for(;;)
80100a57:	eb fe                	jmp    80100a57 <consoleintr+0xe7>
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a60:	31 d2                	xor    %edx,%edx
80100a62:	b8 00 01 00 00       	mov    $0x100,%eax
80100a67:	e8 84 f9 ff ff       	call   801003f0 <consputc.part.0>
      while(input.e != input.w &&
80100a6c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a71:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a77:	0f 84 03 03 00 00    	je     80100d80 <consoleintr+0x410>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a7d:	8d 50 ff             	lea    -0x1(%eax),%edx
80100a80:	89 d1                	mov    %edx,%ecx
80100a82:	83 e1 7f             	and    $0x7f,%ecx
      while(input.e != input.w &&
80100a85:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
80100a8c:	0f 84 ee 02 00 00    	je     80100d80 <consoleintr+0x410>
  if(panicked){
80100a92:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
        input.e--;
80100a97:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if(panicked){
80100a9d:	85 c0                	test   %eax,%eax
80100a9f:	74 bf                	je     80100a60 <consoleintr+0xf0>
80100aa1:	fa                   	cli
    for(;;)
80100aa2:	eb fe                	jmp    80100aa2 <consoleintr+0x132>
80100aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w) {
80100aa8:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
80100aae:	3b 15 04 ff 10 80    	cmp    0x8010ff04,%edx
80100ab4:	0f 84 d1 fe ff ff    	je     8010098b <consoleintr+0x1b>
  if(panicked){
80100aba:	8b 1d 58 ff 10 80    	mov    0x8010ff58,%ebx
        if (input.e == input.real_end) {
80100ac0:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
          input.e--;
80100ac6:	8d 42 ff             	lea    -0x1(%edx),%eax
80100ac9:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100ace:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
          input.real_end--;
80100ad1:	8d 59 ff             	lea    -0x1(%ecx),%ebx
        if (input.e == input.real_end) {
80100ad4:	39 ca                	cmp    %ecx,%edx
80100ad6:	0f 84 fc 01 00 00    	je     80100cd8 <consoleintr+0x368>
          for (uint i = input.e; i < input.real_end - 1; i++)
80100adc:	39 d8                	cmp    %ebx,%eax
80100ade:	73 1e                	jae    80100afe <consoleintr+0x18e>
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
80100afc:	75 e2                	jne    80100ae0 <consoleintr+0x170>
          input.real_end--;
80100afe:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100b04:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100b07:	85 db                	test   %ebx,%ebx
80100b09:	0f 85 31 02 00 00    	jne    80100d40 <consoleintr+0x3d0>
80100b0f:	31 d2                	xor    %edx,%edx
80100b11:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100b16:	e8 d5 f8 ff ff       	call   801003f0 <consputc.part.0>
          for (uint i = input.e; i < input.real_end; i++)
80100b1b:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100b21:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100b27:	0f 83 a1 02 00 00    	jae    80100dce <consoleintr+0x45e>
            consputc(input.buf[i % INPUT_BUF], 0);
80100b2d:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100b2f:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
            consputc(input.buf[i % INPUT_BUF], 0);
80100b35:	83 e0 7f             	and    $0x7f,%eax
80100b38:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100b3f:	85 d2                	test   %edx,%edx
80100b41:	0f 84 71 02 00 00    	je     80100db8 <consoleintr+0x448>
80100b47:	fa                   	cli
    for(;;)
80100b48:	eb fe                	jmp    80100b48 <consoleintr+0x1d8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100b50:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b55:	89 c2                	mov    %eax,%edx
80100b57:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100b5d:	0f 83 28 fe ff ff    	jae    8010098b <consoleintr+0x1b>
80100b63:	83 e2 7f             	and    $0x7f,%edx
80100b66:	0f be 92 80 fe 10 80 	movsbl -0x7fef0180(%edx),%edx
80100b6d:	80 fa 20             	cmp    $0x20,%dl
80100b70:	0f 84 35 01 00 00    	je     80100cab <consoleintr+0x33b>
80100b76:	80 fa 0a             	cmp    $0xa,%dl
80100b79:	0f 84 2c 01 00 00    	je     80100cab <consoleintr+0x33b>
  if(panicked){
80100b7f:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100b85:	85 c9                	test   %ecx,%ecx
80100b87:	0f 84 97 00 00 00    	je     80100c24 <consoleintr+0x2b4>
80100b8d:	fa                   	cli
    for(;;)
80100b8e:	eb fe                	jmp    80100b8e <consoleintr+0x21e>
      if(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100b90:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b95:	89 c2                	mov    %eax,%edx
80100b97:	85 c0                	test   %eax,%eax
80100b99:	0f 84 ec fd ff ff    	je     8010098b <consoleintr+0x1b>
80100b9f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100ba2:	83 e1 7f             	and    $0x7f,%ecx
80100ba5:	80 b9 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%ecx)
80100bac:	0f 84 4e 02 00 00    	je     80100e00 <consoleintr+0x490>
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100bb2:	83 e2 7f             	and    $0x7f,%edx
80100bb5:	80 ba 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%edx)
80100bbc:	0f 85 c8 01 00 00    	jne    80100d8a <consoleintr+0x41a>
  if(panicked){
80100bc2:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100bc7:	85 c0                	test   %eax,%eax
80100bc9:	0f 84 81 00 00 00    	je     80100c50 <consoleintr+0x2e0>
80100bcf:	fa                   	cli
    for(;;)
80100bd0:	eb fe                	jmp    80100bd0 <consoleintr+0x260>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (input.e < input.real_end){
80100bd8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100bdd:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100be3:	0f 83 a2 fd ff ff    	jae    8010098b <consoleintr+0x1b>
        char ch = input.buf[input.e % INPUT_BUF];
80100be9:	83 e0 7f             	and    $0x7f,%eax
80100bec:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if(panicked){
80100bf3:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100bf8:	85 c0                	test   %eax,%eax
80100bfa:	0f 84 59 01 00 00    	je     80100d59 <consoleintr+0x3e9>
80100c00:	fa                   	cli
    for(;;)
80100c01:	eb fe                	jmp    80100c01 <consoleintr+0x291>
80100c03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100c08:	83 ec 0c             	sub    $0xc,%esp
80100c0b:	68 20 ff 10 80       	push   $0x8010ff20
80100c10:	e8 bb 3e 00 00       	call   80104ad0 <release>
  if(doprocdump) {
80100c15:	83 c4 10             	add    $0x10,%esp
80100c18:	85 ff                	test   %edi,%edi
80100c1a:	75 5d                	jne    80100c79 <consoleintr+0x309>
}
80100c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c1f:	5b                   	pop    %ebx
80100c20:	5e                   	pop    %esi
80100c21:	5f                   	pop    %edi
80100c22:	5d                   	pop    %ebp
80100c23:	c3                   	ret
80100c24:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100c29:	e8 c2 f7 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100c2e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100c33:	8d 50 01             	lea    0x1(%eax),%edx
80100c36:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100c3c:	89 d0                	mov    %edx,%eax
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100c3e:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100c44:	0f 82 19 ff ff ff    	jb     80100b63 <consoleintr+0x1f3>
80100c4a:	e9 3c fd ff ff       	jmp    8010098b <consoleintr+0x1b>
80100c4f:	90                   	nop
80100c50:	31 d2                	xor    %edx,%edx
80100c52:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100c57:	e8 94 f7 ff ff       	call   801003f0 <consputc.part.0>
        input.e--;
80100c5c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100c61:	8d 50 ff             	lea    -0x1(%eax),%edx
80100c64:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100c6a:	89 d0                	mov    %edx,%eax
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100c6c:	85 d2                	test   %edx,%edx
80100c6e:	0f 85 3e ff ff ff    	jne    80100bb2 <consoleintr+0x242>
80100c74:	e9 12 fd ff ff       	jmp    8010098b <consoleintr+0x1b>
}
80100c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c7c:	5b                   	pop    %ebx
80100c7d:	5e                   	pop    %esi
80100c7e:	5f                   	pop    %edi
80100c7f:	5d                   	pop    %ebp
    procdump();
80100c80:	e9 cb 3a 00 00       	jmp    80104750 <procdump>
    switch(c){
80100c85:	bf 01 00 00 00       	mov    $0x1,%edi
80100c8a:	e9 fc fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100c8f:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100c94:	ba 20 00 00 00       	mov    $0x20,%edx
80100c99:	e8 52 f7 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100c9e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ca3:	83 c0 01             	add    $0x1,%eax
80100ca6:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100cab:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100cb1:	0f 83 d4 fc ff ff    	jae    8010098b <consoleintr+0x1b>
80100cb7:	83 e0 7f             	and    $0x7f,%eax
80100cba:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100cc1:	0f 85 c4 fc ff ff    	jne    8010098b <consoleintr+0x1b>
  if(panicked){
80100cc7:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100ccd:	85 d2                	test   %edx,%edx
80100ccf:	74 be                	je     80100c8f <consoleintr+0x31f>
80100cd1:	fa                   	cli
    for(;;)
80100cd2:	eb fe                	jmp    80100cd2 <consoleintr+0x362>
80100cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
          input.real_end--;
80100cdb:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100ce1:	85 c0                	test   %eax,%eax
80100ce3:	0f 84 86 00 00 00    	je     80100d6f <consoleintr+0x3ff>
80100ce9:	fa                   	cli
    for(;;)
80100cea:	eb fe                	jmp    80100cea <consoleintr+0x37a>
80100cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100cf0:	83 fa 7f             	cmp    $0x7f,%edx
80100cf3:	0f 87 92 fc ff ff    	ja     8010098b <consoleintr+0x1b>
          c = (c == '\r') ? '\n' : c;
80100cf9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100cfc:	83 fb 0d             	cmp    $0xd,%ebx
80100cff:	75 0c                	jne    80100d0d <consoleintr+0x39d>
80100d01:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
80100d08:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.buf[input.e++ % INPUT_BUF] = c;
80100d0d:	8d 51 01             	lea    0x1(%ecx),%edx
80100d10:	83 e1 7f             	and    $0x7f,%ecx
80100d13:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100d19:	88 99 80 fe 10 80    	mov    %bl,-0x7fef0180(%ecx)
          if (input.e > input.real_end) input.real_end = input.e;
80100d1f:	39 d0                	cmp    %edx,%eax
80100d21:	73 06                	jae    80100d29 <consoleintr+0x3b9>
80100d23:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100d29:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100d2e:	85 c0                	test   %eax,%eax
80100d30:	0f 84 da 00 00 00    	je     80100e10 <consoleintr+0x4a0>
80100d36:	fa                   	cli
    for(;;)
80100d37:	eb fe                	jmp    80100d37 <consoleintr+0x3c7>
80100d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d40:	fa                   	cli
80100d41:	eb fe                	jmp    80100d41 <consoleintr+0x3d1>
80100d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d48:	31 d2                	xor    %edx,%edx
80100d4a:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100d4f:	e8 9c f6 ff ff       	call   801003f0 <consputc.part.0>
80100d54:	e9 32 fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d59:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d5e:	e8 8d f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d63:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
80100d6a:	e9 1c fc ff ff       	jmp    8010098b <consoleintr+0x1b>
80100d6f:	31 d2                	xor    %edx,%edx
80100d71:	b8 00 01 00 00       	mov    $0x100,%eax
80100d76:	e8 75 f6 ff ff       	call   801003f0 <consputc.part.0>
80100d7b:	e9 0b fc ff ff       	jmp    8010098b <consoleintr+0x1b>
      input.real_end = input.e;
80100d80:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      break;
80100d85:	e9 01 fc ff ff       	jmp    8010098b <consoleintr+0x1b>
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
80100d8a:	85 c0                	test   %eax,%eax
80100d8c:	0f 84 f9 fb ff ff    	je     8010098b <consoleintr+0x1b>
80100d92:	83 e8 01             	sub    $0x1,%eax
80100d95:	83 e0 7f             	and    $0x7f,%eax
80100d98:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100d9f:	0f 84 e6 fb ff ff    	je     8010098b <consoleintr+0x1b>
  if(panicked){
80100da5:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100daa:	85 c0                	test   %eax,%eax
80100dac:	74 32                	je     80100de0 <consoleintr+0x470>
80100dae:	fa                   	cli
    for(;;)
80100daf:	eb fe                	jmp    80100daf <consoleintr+0x43f>
80100db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100db8:	31 d2                	xor    %edx,%edx
          for (uint i = input.e; i < input.real_end; i++)
80100dba:	83 c3 01             	add    $0x1,%ebx
80100dbd:	e8 2e f6 ff ff       	call   801003f0 <consputc.part.0>
80100dc2:	3b 1d 0c ff 10 80    	cmp    0x8010ff0c,%ebx
80100dc8:	0f 82 5f fd ff ff    	jb     80100b2d <consoleintr+0x1bd>
  if(panicked){
80100dce:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100dd4:	85 c9                	test   %ecx,%ecx
80100dd6:	0f 84 64 01 00 00    	je     80100f40 <consoleintr+0x5d0>
80100ddc:	fa                   	cli
    for(;;)
80100ddd:	eb fe                	jmp    80100ddd <consoleintr+0x46d>
80100ddf:	90                   	nop
80100de0:	31 d2                	xor    %edx,%edx
80100de2:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100de7:	e8 04 f6 ff ff       	call   801003f0 <consputc.part.0>
          input.e--;
80100dec:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100df1:	83 e8 01             	sub    $0x1,%eax
80100df4:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
80100df9:	75 97                	jne    80100d92 <consoleintr+0x422>
80100dfb:	e9 8b fb ff ff       	jmp    8010098b <consoleintr+0x1b>
  if(panicked){
80100e00:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100e05:	85 c0                	test   %eax,%eax
80100e07:	0f 84 43 fe ff ff    	je     80100c50 <consoleintr+0x2e0>
80100e0d:	fa                   	cli
    for(;;)
80100e0e:	eb fe                	jmp    80100e0e <consoleintr+0x49e>
80100e10:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100e13:	31 d2                	xor    %edx,%edx
80100e15:	89 d8                	mov    %ebx,%eax
80100e17:	e8 d4 f5 ff ff       	call   801003f0 <consputc.part.0>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100e1c:	83 fb 0a             	cmp    $0xa,%ebx
80100e1f:	74 14                	je     80100e35 <consoleintr+0x4c5>
80100e21:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100e26:	83 e8 80             	sub    $0xffffff80,%eax
80100e29:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
80100e2f:	0f 85 56 fb ff ff    	jne    8010098b <consoleintr+0x1b>
            input.w = input.e;
80100e35:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100e3a:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100e3d:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
80100e42:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
80100e47:	68 00 ff 10 80       	push   $0x8010ff00
80100e4c:	e8 1f 38 00 00       	call   80104670 <wakeup>
80100e51:	83 c4 10             	add    $0x10,%esp
80100e54:	e9 32 fb ff ff       	jmp    8010098b <consoleintr+0x1b>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100e59:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100e5c:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100e5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e62:	39 d9                	cmp    %ebx,%ecx
80100e64:	7f 47                	jg     80100ead <consoleintr+0x53d>
80100e66:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80100e69:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100e6c:	89 d7                	mov    %edx,%edi
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100e6e:	89 da                	mov    %ebx,%edx
80100e70:	c1 fa 1f             	sar    $0x1f,%edx
80100e73:	c1 ea 19             	shr    $0x19,%edx
80100e76:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80100e79:	83 e0 7f             	and    $0x7f,%eax
80100e7c:	29 d0                	sub    %edx,%eax
80100e7e:	0f b6 90 80 fe 10 80 	movzbl -0x7fef0180(%eax),%edx
80100e85:	8d 43 01             	lea    0x1(%ebx),%eax
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100e88:	83 eb 01             	sub    $0x1,%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100e8b:	89 c1                	mov    %eax,%ecx
80100e8d:	c1 f9 1f             	sar    $0x1f,%ecx
80100e90:	c1 e9 19             	shr    $0x19,%ecx
80100e93:	01 c8                	add    %ecx,%eax
80100e95:	83 e0 7f             	and    $0x7f,%eax
80100e98:	29 c8                	sub    %ecx,%eax
80100e9a:	88 90 80 fe 10 80    	mov    %dl,-0x7fef0180(%eax)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80100ea0:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
80100ea3:	75 c9                	jne    80100e6e <consoleintr+0x4fe>
80100ea5:	89 fa                	mov    %edi,%edx
80100ea7:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80100eaa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
            input.buf[input.e] = c;
80100ead:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  if(panicked){
80100eb1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
            input.real_end++;
80100eb4:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
            input.buf[input.e] = c;
80100eba:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked){
80100ec0:	85 db                	test   %ebx,%ebx
80100ec2:	74 0c                	je     80100ed0 <consoleintr+0x560>
80100ec4:	fa                   	cli
    for(;;)
80100ec5:	eb fe                	jmp    80100ec5 <consoleintr+0x555>
80100ec7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ece:	00 
80100ecf:	90                   	nop
80100ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed3:	31 d2                	xor    %edx,%edx
80100ed5:	e8 16 f5 ff ff       	call   801003f0 <consputc.part.0>
            input.e++;
80100eda:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100edf:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
80100ee2:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
80100ee7:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
80100eed:	39 c3                	cmp    %eax,%ebx
80100eef:	0f 83 de 00 00 00    	jae    80100fd3 <consoleintr+0x663>
              consputc(input.buf[i % INPUT_BUF], 0);
80100ef5:	89 d8                	mov    %ebx,%eax
  if(panicked){
80100ef7:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
              consputc(input.buf[i % INPUT_BUF], 0);
80100efd:	83 e0 7f             	and    $0x7f,%eax
80100f00:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80100f07:	85 c9                	test   %ecx,%ecx
80100f09:	74 05                	je     80100f10 <consoleintr+0x5a0>
80100f0b:	fa                   	cli
    for(;;)
80100f0c:	eb fe                	jmp    80100f0c <consoleintr+0x59c>
80100f0e:	66 90                	xchg   %ax,%ax
80100f10:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80100f12:	83 c3 01             	add    $0x1,%ebx
80100f15:	e8 d6 f4 ff ff       	call   801003f0 <consputc.part.0>
80100f1a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100f1f:	39 c3                	cmp    %eax,%ebx
80100f21:	72 d2                	jb     80100ef5 <consoleintr+0x585>
            for (uint k = input.e; k < input.real_end; k++)
80100f23:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100f29:	39 c3                	cmp    %eax,%ebx
80100f2b:	0f 83 a2 00 00 00    	jae    80100fd3 <consoleintr+0x663>
  if(panicked){
80100f31:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100f37:	85 d2                	test   %edx,%edx
80100f39:	74 7c                	je     80100fb7 <consoleintr+0x647>
80100f3b:	fa                   	cli
    for(;;)
80100f3c:	eb fe                	jmp    80100f3c <consoleintr+0x5cc>
80100f3e:	66 90                	xchg   %ax,%ax
80100f40:	31 d2                	xor    %edx,%edx
80100f42:	b8 20 00 00 00       	mov    $0x20,%eax
80100f47:	e8 a4 f4 ff ff       	call   801003f0 <consputc.part.0>
          for (uint k = input.e; k <= input.real_end; k++)
80100f4c:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80100f52:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100f58:	0f 82 2d fa ff ff    	jb     8010098b <consoleintr+0x1b>
  if(panicked){
80100f5e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100f63:	85 c0                	test   %eax,%eax
80100f65:	74 09                	je     80100f70 <consoleintr+0x600>
80100f67:	fa                   	cli
    for(;;)
80100f68:	eb fe                	jmp    80100f68 <consoleintr+0x5f8>
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f70:	31 d2                	xor    %edx,%edx
80100f72:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (uint k = input.e; k <= input.real_end; k++)
80100f77:	83 c3 01             	add    $0x1,%ebx
80100f7a:	e8 71 f4 ff ff       	call   801003f0 <consputc.part.0>
80100f7f:	39 1d 0c ff 10 80    	cmp    %ebx,0x8010ff0c
80100f85:	73 d7                	jae    80100f5e <consoleintr+0x5ee>
80100f87:	e9 ff f9 ff ff       	jmp    8010098b <consoleintr+0x1b>
80100f8c:	31 d2                	xor    %edx,%edx
80100f8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100f93:	e8 58 f4 ff ff       	call   801003f0 <consputc.part.0>
            input.w = input.e;
80100f98:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80100fa0:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
80100fa5:	68 00 ff 10 80       	push   $0x8010ff00
80100faa:	e8 c1 36 00 00       	call   80104670 <wakeup>
80100faf:	83 c4 10             	add    $0x10,%esp
80100fb2:	e9 d4 f9 ff ff       	jmp    8010098b <consoleintr+0x1b>
80100fb7:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100fbc:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80100fbe:	83 c3 01             	add    $0x1,%ebx
80100fc1:	e8 2a f4 ff ff       	call   801003f0 <consputc.part.0>
80100fc6:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100fcb:	39 c3                	cmp    %eax,%ebx
80100fcd:	0f 82 5e ff ff ff    	jb     80100f31 <consoleintr+0x5c1>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80100fd3:	8b 1d 00 ff 10 80    	mov    0x8010ff00,%ebx
80100fd9:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80100fdf:	39 c2                	cmp    %eax,%edx
80100fe1:	0f 85 a4 f9 ff ff    	jne    8010098b <consoleintr+0x1b>
            input.e = input.real_end;
80100fe7:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            if (c == '\n') {
80100fec:	eb aa                	jmp    80100f98 <consoleintr+0x628>
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <consoleinit>:

void
consoleinit(void)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ff6:	68 68 77 10 80       	push   $0x80107768
80100ffb:	68 20 ff 10 80       	push   $0x8010ff20
80101000:	e8 3b 39 00 00       	call   80104940 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101005:	58                   	pop    %eax
80101006:	5a                   	pop    %edx
80101007:	6a 00                	push   $0x0
80101009:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010100b:	c7 05 0c 09 11 80 60 	movl   $0x80100660,0x8011090c
80101012:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101015:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
8010101c:	02 10 80 
  cons.locking = 1;
8010101f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80101026:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101029:	e8 c2 19 00 00       	call   801029f0 <ioapicenable>
}
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	c9                   	leave
80101032:	c3                   	ret
80101033:	66 90                	xchg   %ax,%ax
80101035:	66 90                	xchg   %ax,%ax
80101037:	66 90                	xchg   %ax,%ax
80101039:	66 90                	xchg   %ax,%ax
8010103b:	66 90                	xchg   %ax,%ax
8010103d:	66 90                	xchg   %ax,%ax
8010103f:	90                   	nop

80101040 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010104c:	e8 9f 2e 00 00       	call   80103ef0 <myproc>
80101051:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101057:	e8 74 22 00 00       	call   801032d0 <begin_op>

  if((ip = namei(path)) == 0){
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 75 08             	push   0x8(%ebp)
80101062:	e8 a9 15 00 00       	call   80102610 <namei>
80101067:	83 c4 10             	add    $0x10,%esp
8010106a:	85 c0                	test   %eax,%eax
8010106c:	0f 84 30 03 00 00    	je     801013a2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101072:	83 ec 0c             	sub    $0xc,%esp
80101075:	89 c7                	mov    %eax,%edi
80101077:	50                   	push   %eax
80101078:	e8 b3 0c 00 00       	call   80101d30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010107d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101083:	6a 34                	push   $0x34
80101085:	6a 00                	push   $0x0
80101087:	50                   	push   %eax
80101088:	57                   	push   %edi
80101089:	e8 b2 0f 00 00       	call   80102040 <readi>
8010108e:	83 c4 20             	add    $0x20,%esp
80101091:	83 f8 34             	cmp    $0x34,%eax
80101094:	0f 85 01 01 00 00    	jne    8010119b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
8010109a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801010a1:	45 4c 46 
801010a4:	0f 85 f1 00 00 00    	jne    8010119b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801010aa:	e8 01 63 00 00       	call   801073b0 <setupkvm>
801010af:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801010b5:	85 c0                	test   %eax,%eax
801010b7:	0f 84 de 00 00 00    	je     8010119b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010bd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801010c4:	00 
801010c5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801010cb:	0f 84 a1 02 00 00    	je     80101372 <exec+0x332>
  sz = 0;
801010d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801010d8:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010db:	31 db                	xor    %ebx,%ebx
801010dd:	e9 8c 00 00 00       	jmp    8010116e <exec+0x12e>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
801010e8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801010ef:	75 6c                	jne    8010115d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
801010f1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801010f7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801010fd:	0f 82 87 00 00 00    	jb     8010118a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101103:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101109:	72 7f                	jb     8010118a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010110b:	83 ec 04             	sub    $0x4,%esp
8010110e:	50                   	push   %eax
8010110f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101115:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010111b:	e8 c0 60 00 00       	call   801071e0 <allocuvm>
80101120:	83 c4 10             	add    $0x10,%esp
80101123:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101129:	85 c0                	test   %eax,%eax
8010112b:	74 5d                	je     8010118a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010112d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101133:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101138:	75 50                	jne    8010118a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010113a:	83 ec 0c             	sub    $0xc,%esp
8010113d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101143:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101149:	57                   	push   %edi
8010114a:	50                   	push   %eax
8010114b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101151:	e8 ba 5f 00 00       	call   80107110 <loaduvm>
80101156:	83 c4 20             	add    $0x20,%esp
80101159:	85 c0                	test   %eax,%eax
8010115b:	78 2d                	js     8010118a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010115d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101164:	83 c3 01             	add    $0x1,%ebx
80101167:	83 c6 20             	add    $0x20,%esi
8010116a:	39 d8                	cmp    %ebx,%eax
8010116c:	7e 52                	jle    801011c0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
8010116e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101174:	6a 20                	push   $0x20
80101176:	56                   	push   %esi
80101177:	50                   	push   %eax
80101178:	57                   	push   %edi
80101179:	e8 c2 0e 00 00       	call   80102040 <readi>
8010117e:	83 c4 10             	add    $0x10,%esp
80101181:	83 f8 20             	cmp    $0x20,%eax
80101184:	0f 84 5e ff ff ff    	je     801010e8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101193:	e8 98 61 00 00       	call   80107330 <freevm>
  if(ip){
80101198:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010119b:	83 ec 0c             	sub    $0xc,%esp
8010119e:	57                   	push   %edi
8010119f:	e8 1c 0e 00 00       	call   80101fc0 <iunlockput>
    end_op();
801011a4:	e8 97 21 00 00       	call   80103340 <end_op>
801011a9:	83 c4 10             	add    $0x10,%esp
    return -1;
801011ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
801011b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b4:	5b                   	pop    %ebx
801011b5:	5e                   	pop    %esi
801011b6:	5f                   	pop    %edi
801011b7:	5d                   	pop    %ebp
801011b8:	c3                   	ret
801011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
801011c0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801011c6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
801011cc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011d2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	57                   	push   %edi
801011dc:	e8 df 0d 00 00       	call   80101fc0 <iunlockput>
  end_op();
801011e1:	e8 5a 21 00 00       	call   80103340 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801011e6:	83 c4 0c             	add    $0xc,%esp
801011e9:	53                   	push   %ebx
801011ea:	56                   	push   %esi
801011eb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801011f1:	56                   	push   %esi
801011f2:	e8 e9 5f 00 00       	call   801071e0 <allocuvm>
801011f7:	83 c4 10             	add    $0x10,%esp
801011fa:	89 c7                	mov    %eax,%edi
801011fc:	85 c0                	test   %eax,%eax
801011fe:	0f 84 86 00 00 00    	je     8010128a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010120d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010120f:	50                   	push   %eax
80101210:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101211:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101213:	e8 38 62 00 00       	call   80107450 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010121b:	83 c4 10             	add    $0x10,%esp
8010121e:	8b 10                	mov    (%eax),%edx
80101220:	85 d2                	test   %edx,%edx
80101222:	0f 84 56 01 00 00    	je     8010137e <exec+0x33e>
80101228:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010122e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101231:	eb 23                	jmp    80101256 <exec+0x216>
80101233:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101238:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010123b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101242:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101248:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010124b:	85 d2                	test   %edx,%edx
8010124d:	74 51                	je     801012a0 <exec+0x260>
    if(argc >= MAXARG)
8010124f:	83 f8 20             	cmp    $0x20,%eax
80101252:	74 36                	je     8010128a <exec+0x24a>
80101254:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101256:	83 ec 0c             	sub    $0xc,%esp
80101259:	52                   	push   %edx
8010125a:	e8 c1 3b 00 00       	call   80104e20 <strlen>
8010125f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101261:	58                   	pop    %eax
80101262:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101265:	83 eb 01             	sub    $0x1,%ebx
80101268:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010126b:	e8 b0 3b 00 00       	call   80104e20 <strlen>
80101270:	83 c0 01             	add    $0x1,%eax
80101273:	50                   	push   %eax
80101274:	ff 34 b7             	push   (%edi,%esi,4)
80101277:	53                   	push   %ebx
80101278:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010127e:	e8 9d 63 00 00       	call   80107620 <copyout>
80101283:	83 c4 20             	add    $0x20,%esp
80101286:	85 c0                	test   %eax,%eax
80101288:	79 ae                	jns    80101238 <exec+0x1f8>
    freevm(pgdir);
8010128a:	83 ec 0c             	sub    $0xc,%esp
8010128d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101293:	e8 98 60 00 00       	call   80107330 <freevm>
80101298:	83 c4 10             	add    $0x10,%esp
8010129b:	e9 0c ff ff ff       	jmp    801011ac <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012a0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801012a7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801012ad:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801012b3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
801012b6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
801012b9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
801012c0:	00 00 00 00 
  ustack[1] = argc;
801012c4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
801012ca:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801012d1:	ff ff ff 
  ustack[1] = argc;
801012d4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012da:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
801012dc:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012de:	29 d0                	sub    %edx,%eax
801012e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801012e6:	56                   	push   %esi
801012e7:	51                   	push   %ecx
801012e8:	53                   	push   %ebx
801012e9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801012ef:	e8 2c 63 00 00       	call   80107620 <copyout>
801012f4:	83 c4 10             	add    $0x10,%esp
801012f7:	85 c0                	test   %eax,%eax
801012f9:	78 8f                	js     8010128a <exec+0x24a>
  for(last=s=path; *s; s++)
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	8b 55 08             	mov    0x8(%ebp),%edx
80101301:	0f b6 00             	movzbl (%eax),%eax
80101304:	84 c0                	test   %al,%al
80101306:	74 17                	je     8010131f <exec+0x2df>
80101308:	89 d1                	mov    %edx,%ecx
8010130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101310:	83 c1 01             	add    $0x1,%ecx
80101313:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101315:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101318:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010131b:	84 c0                	test   %al,%al
8010131d:	75 f1                	jne    80101310 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010131f:	83 ec 04             	sub    $0x4,%esp
80101322:	6a 10                	push   $0x10
80101324:	52                   	push   %edx
80101325:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010132b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010132e:	50                   	push   %eax
8010132f:	e8 ac 3a 00 00       	call   80104de0 <safestrcpy>
  curproc->pgdir = pgdir;
80101334:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010133a:	89 f0                	mov    %esi,%eax
8010133c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010133f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80101341:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101344:	89 c1                	mov    %eax,%ecx
80101346:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010134c:	8b 40 18             	mov    0x18(%eax),%eax
8010134f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101352:	8b 41 18             	mov    0x18(%ecx),%eax
80101355:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101358:	89 0c 24             	mov    %ecx,(%esp)
8010135b:	e8 20 5c 00 00       	call   80106f80 <switchuvm>
  freevm(oldpgdir);
80101360:	89 34 24             	mov    %esi,(%esp)
80101363:	e8 c8 5f 00 00       	call   80107330 <freevm>
  return 0;
80101368:	83 c4 10             	add    $0x10,%esp
8010136b:	31 c0                	xor    %eax,%eax
8010136d:	e9 3f fe ff ff       	jmp    801011b1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101372:	bb 00 20 00 00       	mov    $0x2000,%ebx
80101377:	31 f6                	xor    %esi,%esi
80101379:	e9 5a fe ff ff       	jmp    801011d8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
8010137e:	be 10 00 00 00       	mov    $0x10,%esi
80101383:	ba 04 00 00 00       	mov    $0x4,%edx
80101388:	b8 03 00 00 00       	mov    $0x3,%eax
8010138d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101394:	00 00 00 
80101397:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010139d:	e9 17 ff ff ff       	jmp    801012b9 <exec+0x279>
    end_op();
801013a2:	e8 99 1f 00 00       	call   80103340 <end_op>
    cprintf("exec: fail\n");
801013a7:	83 ec 0c             	sub    $0xc,%esp
801013aa:	68 70 77 10 80       	push   $0x80107770
801013af:	e8 ac f3 ff ff       	call   80100760 <cprintf>
    return -1;
801013b4:	83 c4 10             	add    $0x10,%esp
801013b7:	e9 f0 fd ff ff       	jmp    801011ac <exec+0x16c>
801013bc:	66 90                	xchg   %ax,%ax
801013be:	66 90                	xchg   %ax,%ax

801013c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801013c6:	68 7c 77 10 80       	push   $0x8010777c
801013cb:	68 60 ff 10 80       	push   $0x8010ff60
801013d0:	e8 6b 35 00 00       	call   80104940 <initlock>
}
801013d5:	83 c4 10             	add    $0x10,%esp
801013d8:	c9                   	leave
801013d9:	c3                   	ret
801013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801013e4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
801013e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801013ec:	68 60 ff 10 80       	push   $0x8010ff60
801013f1:	e8 3a 37 00 00       	call   80104b30 <acquire>
801013f6:	83 c4 10             	add    $0x10,%esp
801013f9:	eb 10                	jmp    8010140b <filealloc+0x2b>
801013fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101400:	83 c3 18             	add    $0x18,%ebx
80101403:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80101409:	74 25                	je     80101430 <filealloc+0x50>
    if(f->ref == 0){
8010140b:	8b 43 04             	mov    0x4(%ebx),%eax
8010140e:	85 c0                	test   %eax,%eax
80101410:	75 ee                	jne    80101400 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101412:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101415:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010141c:	68 60 ff 10 80       	push   $0x8010ff60
80101421:	e8 aa 36 00 00       	call   80104ad0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101426:	89 d8                	mov    %ebx,%eax
      return f;
80101428:	83 c4 10             	add    $0x10,%esp
}
8010142b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010142e:	c9                   	leave
8010142f:	c3                   	ret
  release(&ftable.lock);
80101430:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101433:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101435:	68 60 ff 10 80       	push   $0x8010ff60
8010143a:	e8 91 36 00 00       	call   80104ad0 <release>
}
8010143f:	89 d8                	mov    %ebx,%eax
  return 0;
80101441:	83 c4 10             	add    $0x10,%esp
}
80101444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101447:	c9                   	leave
80101448:	c3                   	ret
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	83 ec 10             	sub    $0x10,%esp
80101457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010145a:	68 60 ff 10 80       	push   $0x8010ff60
8010145f:	e8 cc 36 00 00       	call   80104b30 <acquire>
  if(f->ref < 1)
80101464:	8b 43 04             	mov    0x4(%ebx),%eax
80101467:	83 c4 10             	add    $0x10,%esp
8010146a:	85 c0                	test   %eax,%eax
8010146c:	7e 1a                	jle    80101488 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010146e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101471:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101474:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101477:	68 60 ff 10 80       	push   $0x8010ff60
8010147c:	e8 4f 36 00 00       	call   80104ad0 <release>
  return f;
}
80101481:	89 d8                	mov    %ebx,%eax
80101483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101486:	c9                   	leave
80101487:	c3                   	ret
    panic("filedup");
80101488:	83 ec 0c             	sub    $0xc,%esp
8010148b:	68 83 77 10 80       	push   $0x80107783
80101490:	e8 db ee ff ff       	call   80100370 <panic>
80101495:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010149c:	00 
8010149d:	8d 76 00             	lea    0x0(%esi),%esi

801014a0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	53                   	push   %ebx
801014a6:	83 ec 28             	sub    $0x28,%esp
801014a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801014ac:	68 60 ff 10 80       	push   $0x8010ff60
801014b1:	e8 7a 36 00 00       	call   80104b30 <acquire>
  if(f->ref < 1)
801014b6:	8b 53 04             	mov    0x4(%ebx),%edx
801014b9:	83 c4 10             	add    $0x10,%esp
801014bc:	85 d2                	test   %edx,%edx
801014be:	0f 8e a5 00 00 00    	jle    80101569 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801014c4:	83 ea 01             	sub    $0x1,%edx
801014c7:	89 53 04             	mov    %edx,0x4(%ebx)
801014ca:	75 44                	jne    80101510 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801014cc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801014d0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801014d3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801014d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801014db:	8b 73 0c             	mov    0xc(%ebx),%esi
801014de:	88 45 e7             	mov    %al,-0x19(%ebp)
801014e1:	8b 43 10             	mov    0x10(%ebx),%eax
801014e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801014e7:	68 60 ff 10 80       	push   $0x8010ff60
801014ec:	e8 df 35 00 00       	call   80104ad0 <release>

  if(ff.type == FD_PIPE)
801014f1:	83 c4 10             	add    $0x10,%esp
801014f4:	83 ff 01             	cmp    $0x1,%edi
801014f7:	74 57                	je     80101550 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801014f9:	83 ff 02             	cmp    $0x2,%edi
801014fc:	74 2a                	je     80101528 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101501:	5b                   	pop    %ebx
80101502:	5e                   	pop    %esi
80101503:	5f                   	pop    %edi
80101504:	5d                   	pop    %ebp
80101505:	c3                   	ret
80101506:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150d:	00 
8010150e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101510:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101517:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151a:	5b                   	pop    %ebx
8010151b:	5e                   	pop    %esi
8010151c:	5f                   	pop    %edi
8010151d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010151e:	e9 ad 35 00 00       	jmp    80104ad0 <release>
80101523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101528:	e8 a3 1d 00 00       	call   801032d0 <begin_op>
    iput(ff.ip);
8010152d:	83 ec 0c             	sub    $0xc,%esp
80101530:	ff 75 e0             	push   -0x20(%ebp)
80101533:	e8 28 09 00 00       	call   80101e60 <iput>
    end_op();
80101538:	83 c4 10             	add    $0x10,%esp
}
8010153b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153e:	5b                   	pop    %ebx
8010153f:	5e                   	pop    %esi
80101540:	5f                   	pop    %edi
80101541:	5d                   	pop    %ebp
    end_op();
80101542:	e9 f9 1d 00 00       	jmp    80103340 <end_op>
80101547:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010154e:	00 
8010154f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101550:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101554:	83 ec 08             	sub    $0x8,%esp
80101557:	53                   	push   %ebx
80101558:	56                   	push   %esi
80101559:	e8 32 25 00 00       	call   80103a90 <pipeclose>
8010155e:	83 c4 10             	add    $0x10,%esp
}
80101561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101564:	5b                   	pop    %ebx
80101565:	5e                   	pop    %esi
80101566:	5f                   	pop    %edi
80101567:	5d                   	pop    %ebp
80101568:	c3                   	ret
    panic("fileclose");
80101569:	83 ec 0c             	sub    $0xc,%esp
8010156c:	68 8b 77 10 80       	push   $0x8010778b
80101571:	e8 fa ed ff ff       	call   80100370 <panic>
80101576:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157d:	00 
8010157e:	66 90                	xchg   %ax,%ax

80101580 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	83 ec 04             	sub    $0x4,%esp
80101587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010158a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010158d:	75 31                	jne    801015c0 <filestat+0x40>
    ilock(f->ip);
8010158f:	83 ec 0c             	sub    $0xc,%esp
80101592:	ff 73 10             	push   0x10(%ebx)
80101595:	e8 96 07 00 00       	call   80101d30 <ilock>
    stati(f->ip, st);
8010159a:	58                   	pop    %eax
8010159b:	5a                   	pop    %edx
8010159c:	ff 75 0c             	push   0xc(%ebp)
8010159f:	ff 73 10             	push   0x10(%ebx)
801015a2:	e8 69 0a 00 00       	call   80102010 <stati>
    iunlock(f->ip);
801015a7:	59                   	pop    %ecx
801015a8:	ff 73 10             	push   0x10(%ebx)
801015ab:	e8 60 08 00 00       	call   80101e10 <iunlock>
    return 0;
  }
  return -1;
}
801015b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801015b3:	83 c4 10             	add    $0x10,%esp
801015b6:	31 c0                	xor    %eax,%eax
}
801015b8:	c9                   	leave
801015b9:	c3                   	ret
801015ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801015c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801015c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801015c8:	c9                   	leave
801015c9:	c3                   	ret
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 0c             	sub    $0xc,%esp
801015d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801015df:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801015e2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801015e6:	74 60                	je     80101648 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801015e8:	8b 03                	mov    (%ebx),%eax
801015ea:	83 f8 01             	cmp    $0x1,%eax
801015ed:	74 41                	je     80101630 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015ef:	83 f8 02             	cmp    $0x2,%eax
801015f2:	75 5b                	jne    8010164f <fileread+0x7f>
    ilock(f->ip);
801015f4:	83 ec 0c             	sub    $0xc,%esp
801015f7:	ff 73 10             	push   0x10(%ebx)
801015fa:	e8 31 07 00 00       	call   80101d30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801015ff:	57                   	push   %edi
80101600:	ff 73 14             	push   0x14(%ebx)
80101603:	56                   	push   %esi
80101604:	ff 73 10             	push   0x10(%ebx)
80101607:	e8 34 0a 00 00       	call   80102040 <readi>
8010160c:	83 c4 20             	add    $0x20,%esp
8010160f:	89 c6                	mov    %eax,%esi
80101611:	85 c0                	test   %eax,%eax
80101613:	7e 03                	jle    80101618 <fileread+0x48>
      f->off += r;
80101615:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101618:	83 ec 0c             	sub    $0xc,%esp
8010161b:	ff 73 10             	push   0x10(%ebx)
8010161e:	e8 ed 07 00 00       	call   80101e10 <iunlock>
    return r;
80101623:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101626:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101629:	89 f0                	mov    %esi,%eax
8010162b:	5b                   	pop    %ebx
8010162c:	5e                   	pop    %esi
8010162d:	5f                   	pop    %edi
8010162e:	5d                   	pop    %ebp
8010162f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101630:	8b 43 0c             	mov    0xc(%ebx),%eax
80101633:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101639:	5b                   	pop    %ebx
8010163a:	5e                   	pop    %esi
8010163b:	5f                   	pop    %edi
8010163c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010163d:	e9 0e 26 00 00       	jmp    80103c50 <piperead>
80101642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101648:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010164d:	eb d7                	jmp    80101626 <fileread+0x56>
  panic("fileread");
8010164f:	83 ec 0c             	sub    $0xc,%esp
80101652:	68 95 77 10 80       	push   $0x80107795
80101657:	e8 14 ed ff ff       	call   80100370 <panic>
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
8010166c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010166f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101672:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101675:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010167c:	0f 84 bb 00 00 00    	je     8010173d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101682:	8b 03                	mov    (%ebx),%eax
80101684:	83 f8 01             	cmp    $0x1,%eax
80101687:	0f 84 bf 00 00 00    	je     8010174c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010168d:	83 f8 02             	cmp    $0x2,%eax
80101690:	0f 85 c8 00 00 00    	jne    8010175e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101699:	31 f6                	xor    %esi,%esi
    while(i < n){
8010169b:	85 c0                	test   %eax,%eax
8010169d:	7f 30                	jg     801016cf <filewrite+0x6f>
8010169f:	e9 94 00 00 00       	jmp    80101738 <filewrite+0xd8>
801016a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801016a8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801016ab:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801016ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801016b1:	ff 73 10             	push   0x10(%ebx)
801016b4:	e8 57 07 00 00       	call   80101e10 <iunlock>
      end_op();
801016b9:	e8 82 1c 00 00       	call   80103340 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801016be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801016c1:	83 c4 10             	add    $0x10,%esp
801016c4:	39 c7                	cmp    %eax,%edi
801016c6:	75 5c                	jne    80101724 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801016c8:	01 fe                	add    %edi,%esi
    while(i < n){
801016ca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801016cd:	7e 69                	jle    80101738 <filewrite+0xd8>
      int n1 = n - i;
801016cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801016d2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801016d7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801016d9:	39 c7                	cmp    %eax,%edi
801016db:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801016de:	e8 ed 1b 00 00       	call   801032d0 <begin_op>
      ilock(f->ip);
801016e3:	83 ec 0c             	sub    $0xc,%esp
801016e6:	ff 73 10             	push   0x10(%ebx)
801016e9:	e8 42 06 00 00       	call   80101d30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801016ee:	57                   	push   %edi
801016ef:	ff 73 14             	push   0x14(%ebx)
801016f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801016f5:	01 f0                	add    %esi,%eax
801016f7:	50                   	push   %eax
801016f8:	ff 73 10             	push   0x10(%ebx)
801016fb:	e8 40 0a 00 00       	call   80102140 <writei>
80101700:	83 c4 20             	add    $0x20,%esp
80101703:	85 c0                	test   %eax,%eax
80101705:	7f a1                	jg     801016a8 <filewrite+0x48>
80101707:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010170a:	83 ec 0c             	sub    $0xc,%esp
8010170d:	ff 73 10             	push   0x10(%ebx)
80101710:	e8 fb 06 00 00       	call   80101e10 <iunlock>
      end_op();
80101715:	e8 26 1c 00 00       	call   80103340 <end_op>
      if(r < 0)
8010171a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010171d:	83 c4 10             	add    $0x10,%esp
80101720:	85 c0                	test   %eax,%eax
80101722:	75 14                	jne    80101738 <filewrite+0xd8>
        panic("short filewrite");
80101724:	83 ec 0c             	sub    $0xc,%esp
80101727:	68 9e 77 10 80       	push   $0x8010779e
8010172c:	e8 3f ec ff ff       	call   80100370 <panic>
80101731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101738:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010173b:	74 05                	je     80101742 <filewrite+0xe2>
8010173d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101745:	89 f0                	mov    %esi,%eax
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5f                   	pop    %edi
8010174a:	5d                   	pop    %ebp
8010174b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010174c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010174f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101752:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101755:	5b                   	pop    %ebx
80101756:	5e                   	pop    %esi
80101757:	5f                   	pop    %edi
80101758:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101759:	e9 d2 23 00 00       	jmp    80103b30 <pipewrite>
  panic("filewrite");
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	68 a4 77 10 80       	push   $0x801077a4
80101766:	e8 05 ec ff ff       	call   80100370 <panic>
8010176b:	66 90                	xchg   %ax,%ax
8010176d:	66 90                	xchg   %ax,%ax
8010176f:	90                   	nop

80101770 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	57                   	push   %edi
80101774:	56                   	push   %esi
80101775:	53                   	push   %ebx
80101776:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101779:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010177f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101782:	85 c9                	test   %ecx,%ecx
80101784:	0f 84 8c 00 00 00    	je     80101816 <balloc+0xa6>
8010178a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010178c:	89 f8                	mov    %edi,%eax
8010178e:	83 ec 08             	sub    $0x8,%esp
80101791:	89 fe                	mov    %edi,%esi
80101793:	c1 f8 0c             	sar    $0xc,%eax
80101796:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010179c:	50                   	push   %eax
8010179d:	ff 75 dc             	push   -0x24(%ebp)
801017a0:	e8 2b e9 ff ff       	call   801000d0 <bread>
801017a5:	83 c4 10             	add    $0x10,%esp
801017a8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801017ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017ae:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801017b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017b6:	31 c0                	xor    %eax,%eax
801017b8:	eb 32                	jmp    801017ec <balloc+0x7c>
801017ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801017c0:	89 c1                	mov    %eax,%ecx
801017c2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801017ca:	83 e1 07             	and    $0x7,%ecx
801017cd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017cf:	89 c1                	mov    %eax,%ecx
801017d1:	c1 f9 03             	sar    $0x3,%ecx
801017d4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801017d9:	89 fa                	mov    %edi,%edx
801017db:	85 df                	test   %ebx,%edi
801017dd:	74 49                	je     80101828 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017df:	83 c0 01             	add    $0x1,%eax
801017e2:	83 c6 01             	add    $0x1,%esi
801017e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801017ea:	74 07                	je     801017f3 <balloc+0x83>
801017ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
801017ef:	39 d6                	cmp    %edx,%esi
801017f1:	72 cd                	jb     801017c0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801017f3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801017fc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101802:	e8 e9 e9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101807:	83 c4 10             	add    $0x10,%esp
8010180a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101810:	0f 82 76 ff ff ff    	jb     8010178c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	68 ae 77 10 80       	push   $0x801077ae
8010181e:	e8 4d eb ff ff       	call   80100370 <panic>
80101823:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101828:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010182b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010182e:	09 da                	or     %ebx,%edx
80101830:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101834:	57                   	push   %edi
80101835:	e8 76 1c 00 00       	call   801034b0 <log_write>
        brelse(bp);
8010183a:	89 3c 24             	mov    %edi,(%esp)
8010183d:	e8 ae e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101842:	58                   	pop    %eax
80101843:	5a                   	pop    %edx
80101844:	56                   	push   %esi
80101845:	ff 75 dc             	push   -0x24(%ebp)
80101848:	e8 83 e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010184d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101850:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101852:	8d 40 5c             	lea    0x5c(%eax),%eax
80101855:	68 00 02 00 00       	push   $0x200
8010185a:	6a 00                	push   $0x0
8010185c:	50                   	push   %eax
8010185d:	e8 ce 33 00 00       	call   80104c30 <memset>
  log_write(bp);
80101862:	89 1c 24             	mov    %ebx,(%esp)
80101865:	e8 46 1c 00 00       	call   801034b0 <log_write>
  brelse(bp);
8010186a:	89 1c 24             	mov    %ebx,(%esp)
8010186d:	e8 7e e9 ff ff       	call   801001f0 <brelse>
}
80101872:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101875:	89 f0                	mov    %esi,%eax
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5f                   	pop    %edi
8010187a:	5d                   	pop    %ebp
8010187b:	c3                   	ret
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101884:	31 ff                	xor    %edi,%edi
{
80101886:	56                   	push   %esi
80101887:	89 c6                	mov    %eax,%esi
80101889:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010188f:	83 ec 28             	sub    $0x28,%esp
80101892:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101895:	68 60 09 11 80       	push   $0x80110960
8010189a:	e8 91 32 00 00       	call   80104b30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010189f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	eb 1b                	jmp    801018c2 <iget+0x42>
801018a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018ae:	00 
801018af:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018b0:	39 33                	cmp    %esi,(%ebx)
801018b2:	74 6c                	je     80101920 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018b4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018ba:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801018c0:	74 26                	je     801018e8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c2:	8b 43 08             	mov    0x8(%ebx),%eax
801018c5:	85 c0                	test   %eax,%eax
801018c7:	7f e7                	jg     801018b0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018c9:	85 ff                	test   %edi,%edi
801018cb:	75 e7                	jne    801018b4 <iget+0x34>
801018cd:	85 c0                	test   %eax,%eax
801018cf:	75 76                	jne    80101947 <iget+0xc7>
      empty = ip;
801018d1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018d3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018d9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801018df:	75 e1                	jne    801018c2 <iget+0x42>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018e8:	85 ff                	test   %edi,%edi
801018ea:	74 79                	je     80101965 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801018ec:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801018ef:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801018f1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801018f4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801018fb:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101902:	68 60 09 11 80       	push   $0x80110960
80101907:	e8 c4 31 00 00       	call   80104ad0 <release>

  return ip;
8010190c:	83 c4 10             	add    $0x10,%esp
}
8010190f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101912:	89 f8                	mov    %edi,%eax
80101914:	5b                   	pop    %ebx
80101915:	5e                   	pop    %esi
80101916:	5f                   	pop    %edi
80101917:	5d                   	pop    %ebp
80101918:	c3                   	ret
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101920:	39 53 04             	cmp    %edx,0x4(%ebx)
80101923:	75 8f                	jne    801018b4 <iget+0x34>
      ip->ref++;
80101925:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010192b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010192d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101930:	68 60 09 11 80       	push   $0x80110960
80101935:	e8 96 31 00 00       	call   80104ad0 <release>
      return ip;
8010193a:	83 c4 10             	add    $0x10,%esp
}
8010193d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101940:	89 f8                	mov    %edi,%eax
80101942:	5b                   	pop    %ebx
80101943:	5e                   	pop    %esi
80101944:	5f                   	pop    %edi
80101945:	5d                   	pop    %ebp
80101946:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101947:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010194d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101953:	74 10                	je     80101965 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101955:	8b 43 08             	mov    0x8(%ebx),%eax
80101958:	85 c0                	test   %eax,%eax
8010195a:	0f 8f 50 ff ff ff    	jg     801018b0 <iget+0x30>
80101960:	e9 68 ff ff ff       	jmp    801018cd <iget+0x4d>
    panic("iget: no inodes");
80101965:	83 ec 0c             	sub    $0xc,%esp
80101968:	68 c4 77 10 80       	push   $0x801077c4
8010196d:	e8 fe e9 ff ff       	call   80100370 <panic>
80101972:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101979:	00 
8010197a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101980 <bfree>:
{
80101980:	55                   	push   %ebp
80101981:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101983:	89 d0                	mov    %edx,%eax
80101985:	c1 e8 0c             	shr    $0xc,%eax
{
80101988:	89 e5                	mov    %esp,%ebp
8010198a:	56                   	push   %esi
8010198b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010198c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101992:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101994:	83 ec 08             	sub    $0x8,%esp
80101997:	50                   	push   %eax
80101998:	51                   	push   %ecx
80101999:	e8 32 e7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010199e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801019a0:	c1 fb 03             	sar    $0x3,%ebx
801019a3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801019a6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801019a8:	83 e1 07             	and    $0x7,%ecx
801019ab:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801019b0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801019b6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801019b8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801019bd:	85 c1                	test   %eax,%ecx
801019bf:	74 23                	je     801019e4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801019c1:	f7 d0                	not    %eax
  log_write(bp);
801019c3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801019c6:	21 c8                	and    %ecx,%eax
801019c8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801019cc:	56                   	push   %esi
801019cd:	e8 de 1a 00 00       	call   801034b0 <log_write>
  brelse(bp);
801019d2:	89 34 24             	mov    %esi,(%esp)
801019d5:	e8 16 e8 ff ff       	call   801001f0 <brelse>
}
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e0:	5b                   	pop    %ebx
801019e1:	5e                   	pop    %esi
801019e2:	5d                   	pop    %ebp
801019e3:	c3                   	ret
    panic("freeing free block");
801019e4:	83 ec 0c             	sub    $0xc,%esp
801019e7:	68 d4 77 10 80       	push   $0x801077d4
801019ec:	e8 7f e9 ff ff       	call   80100370 <panic>
801019f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019f8:	00 
801019f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a00 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	89 c6                	mov    %eax,%esi
80101a07:	53                   	push   %ebx
80101a08:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101a0b:	83 fa 0b             	cmp    $0xb,%edx
80101a0e:	0f 86 8c 00 00 00    	jbe    80101aa0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101a14:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101a17:	83 fb 7f             	cmp    $0x7f,%ebx
80101a1a:	0f 87 a2 00 00 00    	ja     80101ac2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101a20:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101a26:	85 c0                	test   %eax,%eax
80101a28:	74 5e                	je     80101a88 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101a2a:	83 ec 08             	sub    $0x8,%esp
80101a2d:	50                   	push   %eax
80101a2e:	ff 36                	push   (%esi)
80101a30:	e8 9b e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101a35:	83 c4 10             	add    $0x10,%esp
80101a38:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101a3c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101a3e:	8b 3b                	mov    (%ebx),%edi
80101a40:	85 ff                	test   %edi,%edi
80101a42:	74 1c                	je     80101a60 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101a44:	83 ec 0c             	sub    $0xc,%esp
80101a47:	52                   	push   %edx
80101a48:	e8 a3 e7 ff ff       	call   801001f0 <brelse>
80101a4d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a53:	89 f8                	mov    %edi,%eax
80101a55:	5b                   	pop    %ebx
80101a56:	5e                   	pop    %esi
80101a57:	5f                   	pop    %edi
80101a58:	5d                   	pop    %ebp
80101a59:	c3                   	ret
80101a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101a63:	8b 06                	mov    (%esi),%eax
80101a65:	e8 06 fd ff ff       	call   80101770 <balloc>
      log_write(bp);
80101a6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a6d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101a70:	89 03                	mov    %eax,(%ebx)
80101a72:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101a74:	52                   	push   %edx
80101a75:	e8 36 1a 00 00       	call   801034b0 <log_write>
80101a7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a7d:	83 c4 10             	add    $0x10,%esp
80101a80:	eb c2                	jmp    80101a44 <bmap+0x44>
80101a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101a88:	8b 06                	mov    (%esi),%eax
80101a8a:	e8 e1 fc ff ff       	call   80101770 <balloc>
80101a8f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101a95:	eb 93                	jmp    80101a2a <bmap+0x2a>
80101a97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a9e:	00 
80101a9f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101aa0:	8d 5a 14             	lea    0x14(%edx),%ebx
80101aa3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101aa7:	85 ff                	test   %edi,%edi
80101aa9:	75 a5                	jne    80101a50 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101aab:	8b 00                	mov    (%eax),%eax
80101aad:	e8 be fc ff ff       	call   80101770 <balloc>
80101ab2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101ab6:	89 c7                	mov    %eax,%edi
}
80101ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abb:	5b                   	pop    %ebx
80101abc:	89 f8                	mov    %edi,%eax
80101abe:	5e                   	pop    %esi
80101abf:	5f                   	pop    %edi
80101ac0:	5d                   	pop    %ebp
80101ac1:	c3                   	ret
  panic("bmap: out of range");
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	68 e7 77 10 80       	push   $0x801077e7
80101aca:	e8 a1 e8 ff ff       	call   80100370 <panic>
80101acf:	90                   	nop

80101ad0 <readsb>:
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	56                   	push   %esi
80101ad4:	53                   	push   %ebx
80101ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101ad8:	83 ec 08             	sub    $0x8,%esp
80101adb:	6a 01                	push   $0x1
80101add:	ff 75 08             	push   0x8(%ebp)
80101ae0:	e8 eb e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ae5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101ae8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101aea:	8d 40 5c             	lea    0x5c(%eax),%eax
80101aed:	6a 1c                	push   $0x1c
80101aef:	50                   	push   %eax
80101af0:	56                   	push   %esi
80101af1:	e8 ca 31 00 00       	call   80104cc0 <memmove>
  brelse(bp);
80101af6:	83 c4 10             	add    $0x10,%esp
80101af9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101aff:	5b                   	pop    %ebx
80101b00:	5e                   	pop    %esi
80101b01:	5d                   	pop    %ebp
  brelse(bp);
80101b02:	e9 e9 e6 ff ff       	jmp    801001f0 <brelse>
80101b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101b0e:	00 
80101b0f:	90                   	nop

80101b10 <iinit>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	53                   	push   %ebx
80101b14:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101b19:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101b1c:	68 fa 77 10 80       	push   $0x801077fa
80101b21:	68 60 09 11 80       	push   $0x80110960
80101b26:	e8 15 2e 00 00       	call   80104940 <initlock>
  for(i = 0; i < NINODE; i++) {
80101b2b:	83 c4 10             	add    $0x10,%esp
80101b2e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101b30:	83 ec 08             	sub    $0x8,%esp
80101b33:	68 01 78 10 80       	push   $0x80107801
80101b38:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101b39:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101b3f:	e8 cc 2c 00 00       	call   80104810 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101b44:	83 c4 10             	add    $0x10,%esp
80101b47:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
80101b4d:	75 e1                	jne    80101b30 <iinit+0x20>
  bp = bread(dev, 1);
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	6a 01                	push   $0x1
80101b54:	ff 75 08             	push   0x8(%ebp)
80101b57:	e8 74 e5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101b5c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101b5f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101b61:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b64:	6a 1c                	push   $0x1c
80101b66:	50                   	push   %eax
80101b67:	68 b4 25 11 80       	push   $0x801125b4
80101b6c:	e8 4f 31 00 00       	call   80104cc0 <memmove>
  brelse(bp);
80101b71:	89 1c 24             	mov    %ebx,(%esp)
80101b74:	e8 77 e6 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101b79:	ff 35 cc 25 11 80    	push   0x801125cc
80101b7f:	ff 35 c8 25 11 80    	push   0x801125c8
80101b85:	ff 35 c4 25 11 80    	push   0x801125c4
80101b8b:	ff 35 c0 25 11 80    	push   0x801125c0
80101b91:	ff 35 bc 25 11 80    	push   0x801125bc
80101b97:	ff 35 b8 25 11 80    	push   0x801125b8
80101b9d:	ff 35 b4 25 11 80    	push   0x801125b4
80101ba3:	68 6c 7c 10 80       	push   $0x80107c6c
80101ba8:	e8 b3 eb ff ff       	call   80100760 <cprintf>
}
80101bad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bb0:	83 c4 30             	add    $0x30,%esp
80101bb3:	c9                   	leave
80101bb4:	c3                   	ret
80101bb5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bbc:	00 
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi

80101bc0 <ialloc>:
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101bcc:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101bd3:	8b 75 08             	mov    0x8(%ebp),%esi
80101bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101bd9:	0f 86 91 00 00 00    	jbe    80101c70 <ialloc+0xb0>
80101bdf:	bf 01 00 00 00       	mov    $0x1,%edi
80101be4:	eb 21                	jmp    80101c07 <ialloc+0x47>
80101be6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bed:	00 
80101bee:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101bf0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101bf3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101bf6:	53                   	push   %ebx
80101bf7:	e8 f4 e5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101bfc:	83 c4 10             	add    $0x10,%esp
80101bff:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101c05:	73 69                	jae    80101c70 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101c07:	89 f8                	mov    %edi,%eax
80101c09:	83 ec 08             	sub    $0x8,%esp
80101c0c:	c1 e8 03             	shr    $0x3,%eax
80101c0f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101c15:	50                   	push   %eax
80101c16:	56                   	push   %esi
80101c17:	e8 b4 e4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101c1c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101c1f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101c21:	89 f8                	mov    %edi,%eax
80101c23:	83 e0 07             	and    $0x7,%eax
80101c26:	c1 e0 06             	shl    $0x6,%eax
80101c29:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101c2d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101c31:	75 bd                	jne    80101bf0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101c33:	83 ec 04             	sub    $0x4,%esp
80101c36:	6a 40                	push   $0x40
80101c38:	6a 00                	push   $0x0
80101c3a:	51                   	push   %ecx
80101c3b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c3e:	e8 ed 2f 00 00       	call   80104c30 <memset>
      dip->type = type;
80101c43:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101c47:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c4a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101c4d:	89 1c 24             	mov    %ebx,(%esp)
80101c50:	e8 5b 18 00 00       	call   801034b0 <log_write>
      brelse(bp);
80101c55:	89 1c 24             	mov    %ebx,(%esp)
80101c58:	e8 93 e5 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101c5d:	83 c4 10             	add    $0x10,%esp
}
80101c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101c63:	89 fa                	mov    %edi,%edx
}
80101c65:	5b                   	pop    %ebx
      return iget(dev, inum);
80101c66:	89 f0                	mov    %esi,%eax
}
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101c6b:	e9 10 fc ff ff       	jmp    80101880 <iget>
  panic("ialloc: no inodes");
80101c70:	83 ec 0c             	sub    $0xc,%esp
80101c73:	68 07 78 10 80       	push   $0x80107807
80101c78:	e8 f3 e6 ff ff       	call   80100370 <panic>
80101c7d:	8d 76 00             	lea    0x0(%esi),%esi

80101c80 <iupdate>:
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	56                   	push   %esi
80101c84:	53                   	push   %ebx
80101c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c88:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c8b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c8e:	83 ec 08             	sub    $0x8,%esp
80101c91:	c1 e8 03             	shr    $0x3,%eax
80101c94:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101c9a:	50                   	push   %eax
80101c9b:	ff 73 a4             	push   -0x5c(%ebx)
80101c9e:	e8 2d e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101ca3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ca7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101caa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cac:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101caf:	83 e0 07             	and    $0x7,%eax
80101cb2:	c1 e0 06             	shl    $0x6,%eax
80101cb5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101cb9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101cbc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cc0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101cc3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101cc7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101ccb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101ccf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101cd3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101cd7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101cda:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cdd:	6a 34                	push   $0x34
80101cdf:	53                   	push   %ebx
80101ce0:	50                   	push   %eax
80101ce1:	e8 da 2f 00 00       	call   80104cc0 <memmove>
  log_write(bp);
80101ce6:	89 34 24             	mov    %esi,(%esp)
80101ce9:	e8 c2 17 00 00       	call   801034b0 <log_write>
  brelse(bp);
80101cee:	83 c4 10             	add    $0x10,%esp
80101cf1:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cf7:	5b                   	pop    %ebx
80101cf8:	5e                   	pop    %esi
80101cf9:	5d                   	pop    %ebp
  brelse(bp);
80101cfa:	e9 f1 e4 ff ff       	jmp    801001f0 <brelse>
80101cff:	90                   	nop

80101d00 <idup>:
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	53                   	push   %ebx
80101d04:	83 ec 10             	sub    $0x10,%esp
80101d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101d0a:	68 60 09 11 80       	push   $0x80110960
80101d0f:	e8 1c 2e 00 00       	call   80104b30 <acquire>
  ip->ref++;
80101d14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d18:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101d1f:	e8 ac 2d 00 00       	call   80104ad0 <release>
}
80101d24:	89 d8                	mov    %ebx,%eax
80101d26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d29:	c9                   	leave
80101d2a:	c3                   	ret
80101d2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101d30 <ilock>:
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	56                   	push   %esi
80101d34:	53                   	push   %ebx
80101d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101d38:	85 db                	test   %ebx,%ebx
80101d3a:	0f 84 b7 00 00 00    	je     80101df7 <ilock+0xc7>
80101d40:	8b 53 08             	mov    0x8(%ebx),%edx
80101d43:	85 d2                	test   %edx,%edx
80101d45:	0f 8e ac 00 00 00    	jle    80101df7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101d4b:	83 ec 0c             	sub    $0xc,%esp
80101d4e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d51:	50                   	push   %eax
80101d52:	e8 f9 2a 00 00       	call   80104850 <acquiresleep>
  if(ip->valid == 0){
80101d57:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101d5a:	83 c4 10             	add    $0x10,%esp
80101d5d:	85 c0                	test   %eax,%eax
80101d5f:	74 0f                	je     80101d70 <ilock+0x40>
}
80101d61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d64:	5b                   	pop    %ebx
80101d65:	5e                   	pop    %esi
80101d66:	5d                   	pop    %ebp
80101d67:	c3                   	ret
80101d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d6f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d70:	8b 43 04             	mov    0x4(%ebx),%eax
80101d73:	83 ec 08             	sub    $0x8,%esp
80101d76:	c1 e8 03             	shr    $0x3,%eax
80101d79:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101d7f:	50                   	push   %eax
80101d80:	ff 33                	push   (%ebx)
80101d82:	e8 49 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d87:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d8a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d8c:	8b 43 04             	mov    0x4(%ebx),%eax
80101d8f:	83 e0 07             	and    $0x7,%eax
80101d92:	c1 e0 06             	shl    $0x6,%eax
80101d95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101d99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101d9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101da3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101da7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101dab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101daf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101db3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101db7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101dbb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101dbe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dc1:	6a 34                	push   $0x34
80101dc3:	50                   	push   %eax
80101dc4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101dc7:	50                   	push   %eax
80101dc8:	e8 f3 2e 00 00       	call   80104cc0 <memmove>
    brelse(bp);
80101dcd:	89 34 24             	mov    %esi,(%esp)
80101dd0:	e8 1b e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101dd5:	83 c4 10             	add    $0x10,%esp
80101dd8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101ddd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101de4:	0f 85 77 ff ff ff    	jne    80101d61 <ilock+0x31>
      panic("ilock: no type");
80101dea:	83 ec 0c             	sub    $0xc,%esp
80101ded:	68 1f 78 10 80       	push   $0x8010781f
80101df2:	e8 79 e5 ff ff       	call   80100370 <panic>
    panic("ilock");
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	68 19 78 10 80       	push   $0x80107819
80101dff:	e8 6c e5 ff ff       	call   80100370 <panic>
80101e04:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e0b:	00 
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e10 <iunlock>:
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	56                   	push   %esi
80101e14:	53                   	push   %ebx
80101e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e18:	85 db                	test   %ebx,%ebx
80101e1a:	74 28                	je     80101e44 <iunlock+0x34>
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101e22:	56                   	push   %esi
80101e23:	e8 c8 2a 00 00       	call   801048f0 <holdingsleep>
80101e28:	83 c4 10             	add    $0x10,%esp
80101e2b:	85 c0                	test   %eax,%eax
80101e2d:	74 15                	je     80101e44 <iunlock+0x34>
80101e2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101e32:	85 c0                	test   %eax,%eax
80101e34:	7e 0e                	jle    80101e44 <iunlock+0x34>
  releasesleep(&ip->lock);
80101e36:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101e39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e3c:	5b                   	pop    %ebx
80101e3d:	5e                   	pop    %esi
80101e3e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101e3f:	e9 6c 2a 00 00       	jmp    801048b0 <releasesleep>
    panic("iunlock");
80101e44:	83 ec 0c             	sub    $0xc,%esp
80101e47:	68 2e 78 10 80       	push   $0x8010782e
80101e4c:	e8 1f e5 ff ff       	call   80100370 <panic>
80101e51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e58:	00 
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e60 <iput>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 28             	sub    $0x28,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101e6c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e6f:	57                   	push   %edi
80101e70:	e8 db 29 00 00       	call   80104850 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101e75:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	85 d2                	test   %edx,%edx
80101e7d:	74 07                	je     80101e86 <iput+0x26>
80101e7f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e84:	74 32                	je     80101eb8 <iput+0x58>
  releasesleep(&ip->lock);
80101e86:	83 ec 0c             	sub    $0xc,%esp
80101e89:	57                   	push   %edi
80101e8a:	e8 21 2a 00 00       	call   801048b0 <releasesleep>
  acquire(&icache.lock);
80101e8f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e96:	e8 95 2c 00 00       	call   80104b30 <acquire>
  ip->ref--;
80101e9b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101e9f:	83 c4 10             	add    $0x10,%esp
80101ea2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eac:	5b                   	pop    %ebx
80101ead:	5e                   	pop    %esi
80101eae:	5f                   	pop    %edi
80101eaf:	5d                   	pop    %ebp
  release(&icache.lock);
80101eb0:	e9 1b 2c 00 00       	jmp    80104ad0 <release>
80101eb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 60 09 11 80       	push   $0x80110960
80101ec0:	e8 6b 2c 00 00       	call   80104b30 <acquire>
    int r = ip->ref;
80101ec5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ec8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101ecf:	e8 fc 2b 00 00       	call   80104ad0 <release>
    if(r == 1){
80101ed4:	83 c4 10             	add    $0x10,%esp
80101ed7:	83 fe 01             	cmp    $0x1,%esi
80101eda:	75 aa                	jne    80101e86 <iput+0x26>
80101edc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ee2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ee5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ee8:	89 df                	mov    %ebx,%edi
80101eea:	89 cb                	mov    %ecx,%ebx
80101eec:	eb 09                	jmp    80101ef7 <iput+0x97>
80101eee:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ef0:	83 c6 04             	add    $0x4,%esi
80101ef3:	39 de                	cmp    %ebx,%esi
80101ef5:	74 19                	je     80101f10 <iput+0xb0>
    if(ip->addrs[i]){
80101ef7:	8b 16                	mov    (%esi),%edx
80101ef9:	85 d2                	test   %edx,%edx
80101efb:	74 f3                	je     80101ef0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101efd:	8b 07                	mov    (%edi),%eax
80101eff:	e8 7c fa ff ff       	call   80101980 <bfree>
      ip->addrs[i] = 0;
80101f04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101f0a:	eb e4                	jmp    80101ef0 <iput+0x90>
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101f10:	89 fb                	mov    %edi,%ebx
80101f12:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f15:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101f1b:	85 c0                	test   %eax,%eax
80101f1d:	75 2d                	jne    80101f4c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101f1f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101f22:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101f29:	53                   	push   %ebx
80101f2a:	e8 51 fd ff ff       	call   80101c80 <iupdate>
      ip->type = 0;
80101f2f:	31 c0                	xor    %eax,%eax
80101f31:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101f35:	89 1c 24             	mov    %ebx,(%esp)
80101f38:	e8 43 fd ff ff       	call   80101c80 <iupdate>
      ip->valid = 0;
80101f3d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101f44:	83 c4 10             	add    $0x10,%esp
80101f47:	e9 3a ff ff ff       	jmp    80101e86 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f4c:	83 ec 08             	sub    $0x8,%esp
80101f4f:	50                   	push   %eax
80101f50:	ff 33                	push   (%ebx)
80101f52:	e8 79 e1 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101f57:	83 c4 10             	add    $0x10,%esp
80101f5a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101f5d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f63:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101f66:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f69:	89 cf                	mov    %ecx,%edi
80101f6b:	eb 0a                	jmp    80101f77 <iput+0x117>
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi
80101f70:	83 c6 04             	add    $0x4,%esi
80101f73:	39 fe                	cmp    %edi,%esi
80101f75:	74 0f                	je     80101f86 <iput+0x126>
      if(a[j])
80101f77:	8b 16                	mov    (%esi),%edx
80101f79:	85 d2                	test   %edx,%edx
80101f7b:	74 f3                	je     80101f70 <iput+0x110>
        bfree(ip->dev, a[j]);
80101f7d:	8b 03                	mov    (%ebx),%eax
80101f7f:	e8 fc f9 ff ff       	call   80101980 <bfree>
80101f84:	eb ea                	jmp    80101f70 <iput+0x110>
    brelse(bp);
80101f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f8f:	50                   	push   %eax
80101f90:	e8 5b e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f95:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f9b:	8b 03                	mov    (%ebx),%eax
80101f9d:	e8 de f9 ff ff       	call   80101980 <bfree>
    ip->addrs[NDIRECT] = 0;
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101fac:	00 00 00 
80101faf:	e9 6b ff ff ff       	jmp    80101f1f <iput+0xbf>
80101fb4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fbb:	00 
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <iunlockput>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fc8:	85 db                	test   %ebx,%ebx
80101fca:	74 34                	je     80102000 <iunlockput+0x40>
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101fd2:	56                   	push   %esi
80101fd3:	e8 18 29 00 00       	call   801048f0 <holdingsleep>
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	85 c0                	test   %eax,%eax
80101fdd:	74 21                	je     80102000 <iunlockput+0x40>
80101fdf:	8b 43 08             	mov    0x8(%ebx),%eax
80101fe2:	85 c0                	test   %eax,%eax
80101fe4:	7e 1a                	jle    80102000 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101fe6:	83 ec 0c             	sub    $0xc,%esp
80101fe9:	56                   	push   %esi
80101fea:	e8 c1 28 00 00       	call   801048b0 <releasesleep>
  iput(ip);
80101fef:	83 c4 10             	add    $0x10,%esp
80101ff2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5d                   	pop    %ebp
  iput(ip);
80101ffb:	e9 60 fe ff ff       	jmp    80101e60 <iput>
    panic("iunlock");
80102000:	83 ec 0c             	sub    $0xc,%esp
80102003:	68 2e 78 10 80       	push   $0x8010782e
80102008:	e8 63 e3 ff ff       	call   80100370 <panic>
8010200d:	8d 76 00             	lea    0x0(%esi),%esi

80102010 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	8b 55 08             	mov    0x8(%ebp),%edx
80102016:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102019:	8b 0a                	mov    (%edx),%ecx
8010201b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010201e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102021:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102024:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102028:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010202b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010202f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102033:	8b 52 58             	mov    0x58(%edx),%edx
80102036:	89 50 10             	mov    %edx,0x10(%eax)
}
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret
8010203b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102040 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 1c             	sub    $0x1c,%esp
80102049:	8b 75 08             	mov    0x8(%ebp),%esi
8010204c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010204f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102052:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80102057:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010205a:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010205d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80102060:	0f 84 aa 00 00 00    	je     80102110 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102066:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102069:	8b 56 58             	mov    0x58(%esi),%edx
8010206c:	39 fa                	cmp    %edi,%edx
8010206e:	0f 82 bd 00 00 00    	jb     80102131 <readi+0xf1>
80102074:	89 f9                	mov    %edi,%ecx
80102076:	31 db                	xor    %ebx,%ebx
80102078:	01 c1                	add    %eax,%ecx
8010207a:	0f 92 c3             	setb   %bl
8010207d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102080:	0f 82 ab 00 00 00    	jb     80102131 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102086:	89 d3                	mov    %edx,%ebx
80102088:	29 fb                	sub    %edi,%ebx
8010208a:	39 ca                	cmp    %ecx,%edx
8010208c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010208f:	85 c0                	test   %eax,%eax
80102091:	74 73                	je     80102106 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102093:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801020a3:	89 fa                	mov    %edi,%edx
801020a5:	c1 ea 09             	shr    $0x9,%edx
801020a8:	89 d8                	mov    %ebx,%eax
801020aa:	e8 51 f9 ff ff       	call   80101a00 <bmap>
801020af:	83 ec 08             	sub    $0x8,%esp
801020b2:	50                   	push   %eax
801020b3:	ff 33                	push   (%ebx)
801020b5:	e8 16 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801020bd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020c2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801020c4:	89 f8                	mov    %edi,%eax
801020c6:	25 ff 01 00 00       	and    $0x1ff,%eax
801020cb:	29 f3                	sub    %esi,%ebx
801020cd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801020cf:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020d3:	39 d9                	cmp    %ebx,%ecx
801020d5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801020d8:	83 c4 0c             	add    $0xc,%esp
801020db:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020dc:	01 de                	add    %ebx,%esi
801020de:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801020e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020e3:	50                   	push   %eax
801020e4:	ff 75 e0             	push   -0x20(%ebp)
801020e7:	e8 d4 2b 00 00       	call   80104cc0 <memmove>
    brelse(bp);
801020ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
801020ef:	89 14 24             	mov    %edx,(%esp)
801020f2:	e8 f9 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020f7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801020fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801020fd:	83 c4 10             	add    $0x10,%esp
80102100:	39 de                	cmp    %ebx,%esi
80102102:	72 9c                	jb     801020a0 <readi+0x60>
80102104:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102109:	5b                   	pop    %ebx
8010210a:	5e                   	pop    %esi
8010210b:	5f                   	pop    %edi
8010210c:	5d                   	pop    %ebp
8010210d:	c3                   	ret
8010210e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102110:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102114:	66 83 fa 09          	cmp    $0x9,%dx
80102118:	77 17                	ja     80102131 <readi+0xf1>
8010211a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80102121:	85 d2                	test   %edx,%edx
80102123:	74 0c                	je     80102131 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102125:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212b:	5b                   	pop    %ebx
8010212c:	5e                   	pop    %esi
8010212d:	5f                   	pop    %edi
8010212e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010212f:	ff e2                	jmp    *%edx
      return -1;
80102131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102136:	eb ce                	jmp    80102106 <readi+0xc6>
80102138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010213f:	00 

80102140 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 1c             	sub    $0x1c,%esp
80102149:	8b 45 08             	mov    0x8(%ebp),%eax
8010214c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010214f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102152:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102157:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010215a:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010215d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80102160:	0f 84 ba 00 00 00    	je     80102220 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102166:	39 78 58             	cmp    %edi,0x58(%eax)
80102169:	0f 82 ea 00 00 00    	jb     80102259 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010216f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80102172:	89 f2                	mov    %esi,%edx
80102174:	01 fa                	add    %edi,%edx
80102176:	0f 82 dd 00 00 00    	jb     80102259 <writei+0x119>
8010217c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80102182:	0f 87 d1 00 00 00    	ja     80102259 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102188:	85 f6                	test   %esi,%esi
8010218a:	0f 84 85 00 00 00    	je     80102215 <writei+0xd5>
80102190:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102197:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021a0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801021a3:	89 fa                	mov    %edi,%edx
801021a5:	c1 ea 09             	shr    $0x9,%edx
801021a8:	89 f0                	mov    %esi,%eax
801021aa:	e8 51 f8 ff ff       	call   80101a00 <bmap>
801021af:	83 ec 08             	sub    $0x8,%esp
801021b2:	50                   	push   %eax
801021b3:	ff 36                	push   (%esi)
801021b5:	e8 16 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801021ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801021bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801021c0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021c5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801021c7:	89 f8                	mov    %edi,%eax
801021c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ce:	29 d3                	sub    %edx,%ebx
801021d0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801021d2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801021d6:	39 d9                	cmp    %ebx,%ecx
801021d8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801021db:	83 c4 0c             	add    $0xc,%esp
801021de:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021df:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
801021e1:	ff 75 dc             	push   -0x24(%ebp)
801021e4:	50                   	push   %eax
801021e5:	e8 d6 2a 00 00       	call   80104cc0 <memmove>
    log_write(bp);
801021ea:	89 34 24             	mov    %esi,(%esp)
801021ed:	e8 be 12 00 00       	call   801034b0 <log_write>
    brelse(bp);
801021f2:	89 34 24             	mov    %esi,(%esp)
801021f5:	e8 f6 df ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801021fa:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801021fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102200:	83 c4 10             	add    $0x10,%esp
80102203:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102206:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102209:	39 d8                	cmp    %ebx,%eax
8010220b:	72 93                	jb     801021a0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010220d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102210:	39 78 58             	cmp    %edi,0x58(%eax)
80102213:	72 33                	jb     80102248 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102215:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221b:	5b                   	pop    %ebx
8010221c:	5e                   	pop    %esi
8010221d:	5f                   	pop    %edi
8010221e:	5d                   	pop    %ebp
8010221f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102220:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102224:	66 83 f8 09          	cmp    $0x9,%ax
80102228:	77 2f                	ja     80102259 <writei+0x119>
8010222a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80102231:	85 c0                	test   %eax,%eax
80102233:	74 24                	je     80102259 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102235:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102238:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010223b:	5b                   	pop    %ebx
8010223c:	5e                   	pop    %esi
8010223d:	5f                   	pop    %edi
8010223e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010223f:	ff e0                	jmp    *%eax
80102241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102248:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010224b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010224e:	50                   	push   %eax
8010224f:	e8 2c fa ff ff       	call   80101c80 <iupdate>
80102254:	83 c4 10             	add    $0x10,%esp
80102257:	eb bc                	jmp    80102215 <writei+0xd5>
      return -1;
80102259:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010225e:	eb b8                	jmp    80102218 <writei+0xd8>

80102260 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102266:	6a 0e                	push   $0xe
80102268:	ff 75 0c             	push   0xc(%ebp)
8010226b:	ff 75 08             	push   0x8(%ebp)
8010226e:	e8 bd 2a 00 00       	call   80104d30 <strncmp>
}
80102273:	c9                   	leave
80102274:	c3                   	ret
80102275:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010227c:	00 
8010227d:	8d 76 00             	lea    0x0(%esi),%esi

80102280 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	83 ec 1c             	sub    $0x1c,%esp
80102289:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010228c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102291:	0f 85 85 00 00 00    	jne    8010231c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102297:	8b 53 58             	mov    0x58(%ebx),%edx
8010229a:	31 ff                	xor    %edi,%edi
8010229c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010229f:	85 d2                	test   %edx,%edx
801022a1:	74 3e                	je     801022e1 <dirlookup+0x61>
801022a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a8:	6a 10                	push   $0x10
801022aa:	57                   	push   %edi
801022ab:	56                   	push   %esi
801022ac:	53                   	push   %ebx
801022ad:	e8 8e fd ff ff       	call   80102040 <readi>
801022b2:	83 c4 10             	add    $0x10,%esp
801022b5:	83 f8 10             	cmp    $0x10,%eax
801022b8:	75 55                	jne    8010230f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801022ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022bf:	74 18                	je     801022d9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801022c1:	83 ec 04             	sub    $0x4,%esp
801022c4:	8d 45 da             	lea    -0x26(%ebp),%eax
801022c7:	6a 0e                	push   $0xe
801022c9:	50                   	push   %eax
801022ca:	ff 75 0c             	push   0xc(%ebp)
801022cd:	e8 5e 2a 00 00       	call   80104d30 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801022d2:	83 c4 10             	add    $0x10,%esp
801022d5:	85 c0                	test   %eax,%eax
801022d7:	74 17                	je     801022f0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022d9:	83 c7 10             	add    $0x10,%edi
801022dc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022df:	72 c7                	jb     801022a8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801022e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801022e4:	31 c0                	xor    %eax,%eax
}
801022e6:	5b                   	pop    %ebx
801022e7:	5e                   	pop    %esi
801022e8:	5f                   	pop    %edi
801022e9:	5d                   	pop    %ebp
801022ea:	c3                   	ret
801022eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
801022f0:	8b 45 10             	mov    0x10(%ebp),%eax
801022f3:	85 c0                	test   %eax,%eax
801022f5:	74 05                	je     801022fc <dirlookup+0x7c>
        *poff = off;
801022f7:	8b 45 10             	mov    0x10(%ebp),%eax
801022fa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801022fc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102300:	8b 03                	mov    (%ebx),%eax
80102302:	e8 79 f5 ff ff       	call   80101880 <iget>
}
80102307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010230a:	5b                   	pop    %ebx
8010230b:	5e                   	pop    %esi
8010230c:	5f                   	pop    %edi
8010230d:	5d                   	pop    %ebp
8010230e:	c3                   	ret
      panic("dirlookup read");
8010230f:	83 ec 0c             	sub    $0xc,%esp
80102312:	68 48 78 10 80       	push   $0x80107848
80102317:	e8 54 e0 ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
8010231c:	83 ec 0c             	sub    $0xc,%esp
8010231f:	68 36 78 10 80       	push   $0x80107836
80102324:	e8 47 e0 ff ff       	call   80100370 <panic>
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102330 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	57                   	push   %edi
80102334:	56                   	push   %esi
80102335:	53                   	push   %ebx
80102336:	89 c3                	mov    %eax,%ebx
80102338:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010233b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010233e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102341:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102344:	0f 84 9e 01 00 00    	je     801024e8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010234a:	e8 a1 1b 00 00       	call   80103ef0 <myproc>
  acquire(&icache.lock);
8010234f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102352:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102355:	68 60 09 11 80       	push   $0x80110960
8010235a:	e8 d1 27 00 00       	call   80104b30 <acquire>
  ip->ref++;
8010235f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102363:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010236a:	e8 61 27 00 00       	call   80104ad0 <release>
8010236f:	83 c4 10             	add    $0x10,%esp
80102372:	eb 07                	jmp    8010237b <namex+0x4b>
80102374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102378:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010237b:	0f b6 03             	movzbl (%ebx),%eax
8010237e:	3c 2f                	cmp    $0x2f,%al
80102380:	74 f6                	je     80102378 <namex+0x48>
  if(*path == 0)
80102382:	84 c0                	test   %al,%al
80102384:	0f 84 06 01 00 00    	je     80102490 <namex+0x160>
  while(*path != '/' && *path != 0)
8010238a:	0f b6 03             	movzbl (%ebx),%eax
8010238d:	84 c0                	test   %al,%al
8010238f:	0f 84 10 01 00 00    	je     801024a5 <namex+0x175>
80102395:	89 df                	mov    %ebx,%edi
80102397:	3c 2f                	cmp    $0x2f,%al
80102399:	0f 84 06 01 00 00    	je     801024a5 <namex+0x175>
8010239f:	90                   	nop
801023a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801023a4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801023a7:	3c 2f                	cmp    $0x2f,%al
801023a9:	74 04                	je     801023af <namex+0x7f>
801023ab:	84 c0                	test   %al,%al
801023ad:	75 f1                	jne    801023a0 <namex+0x70>
  len = path - s;
801023af:	89 f8                	mov    %edi,%eax
801023b1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801023b3:	83 f8 0d             	cmp    $0xd,%eax
801023b6:	0f 8e ac 00 00 00    	jle    80102468 <namex+0x138>
    memmove(name, s, DIRSIZ);
801023bc:	83 ec 04             	sub    $0x4,%esp
801023bf:	6a 0e                	push   $0xe
801023c1:	53                   	push   %ebx
801023c2:	89 fb                	mov    %edi,%ebx
801023c4:	ff 75 e4             	push   -0x1c(%ebp)
801023c7:	e8 f4 28 00 00       	call   80104cc0 <memmove>
801023cc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801023cf:	80 3f 2f             	cmpb   $0x2f,(%edi)
801023d2:	75 0c                	jne    801023e0 <namex+0xb0>
801023d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801023d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801023db:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801023de:	74 f8                	je     801023d8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	56                   	push   %esi
801023e4:	e8 47 f9 ff ff       	call   80101d30 <ilock>
    if(ip->type != T_DIR){
801023e9:	83 c4 10             	add    $0x10,%esp
801023ec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801023f1:	0f 85 b7 00 00 00    	jne    801024ae <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801023f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023fa:	85 c0                	test   %eax,%eax
801023fc:	74 09                	je     80102407 <namex+0xd7>
801023fe:	80 3b 00             	cmpb   $0x0,(%ebx)
80102401:	0f 84 f7 00 00 00    	je     801024fe <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	6a 00                	push   $0x0
8010240c:	ff 75 e4             	push   -0x1c(%ebp)
8010240f:	56                   	push   %esi
80102410:	e8 6b fe ff ff       	call   80102280 <dirlookup>
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	89 c7                	mov    %eax,%edi
8010241a:	85 c0                	test   %eax,%eax
8010241c:	0f 84 8c 00 00 00    	je     801024ae <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102422:	83 ec 0c             	sub    $0xc,%esp
80102425:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102428:	51                   	push   %ecx
80102429:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010242c:	e8 bf 24 00 00       	call   801048f0 <holdingsleep>
80102431:	83 c4 10             	add    $0x10,%esp
80102434:	85 c0                	test   %eax,%eax
80102436:	0f 84 02 01 00 00    	je     8010253e <namex+0x20e>
8010243c:	8b 56 08             	mov    0x8(%esi),%edx
8010243f:	85 d2                	test   %edx,%edx
80102441:	0f 8e f7 00 00 00    	jle    8010253e <namex+0x20e>
  releasesleep(&ip->lock);
80102447:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010244a:	83 ec 0c             	sub    $0xc,%esp
8010244d:	51                   	push   %ecx
8010244e:	e8 5d 24 00 00       	call   801048b0 <releasesleep>
  iput(ip);
80102453:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80102456:	89 fe                	mov    %edi,%esi
  iput(ip);
80102458:	e8 03 fa ff ff       	call   80101e60 <iput>
8010245d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80102460:	e9 16 ff ff ff       	jmp    8010237b <namex+0x4b>
80102465:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102468:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010246b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
8010246e:	83 ec 04             	sub    $0x4,%esp
80102471:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102474:	50                   	push   %eax
80102475:	53                   	push   %ebx
    name[len] = 0;
80102476:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102478:	ff 75 e4             	push   -0x1c(%ebp)
8010247b:	e8 40 28 00 00       	call   80104cc0 <memmove>
    name[len] = 0;
80102480:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102483:	83 c4 10             	add    $0x10,%esp
80102486:	c6 01 00             	movb   $0x0,(%ecx)
80102489:	e9 41 ff ff ff       	jmp    801023cf <namex+0x9f>
8010248e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80102490:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102493:	85 c0                	test   %eax,%eax
80102495:	0f 85 93 00 00 00    	jne    8010252e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
8010249b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249e:	89 f0                	mov    %esi,%eax
801024a0:	5b                   	pop    %ebx
801024a1:	5e                   	pop    %esi
801024a2:	5f                   	pop    %edi
801024a3:	5d                   	pop    %ebp
801024a4:	c3                   	ret
  while(*path != '/' && *path != 0)
801024a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801024a8:	89 df                	mov    %ebx,%edi
801024aa:	31 c0                	xor    %eax,%eax
801024ac:	eb c0                	jmp    8010246e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801024ae:	83 ec 0c             	sub    $0xc,%esp
801024b1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801024b4:	53                   	push   %ebx
801024b5:	e8 36 24 00 00       	call   801048f0 <holdingsleep>
801024ba:	83 c4 10             	add    $0x10,%esp
801024bd:	85 c0                	test   %eax,%eax
801024bf:	74 7d                	je     8010253e <namex+0x20e>
801024c1:	8b 4e 08             	mov    0x8(%esi),%ecx
801024c4:	85 c9                	test   %ecx,%ecx
801024c6:	7e 76                	jle    8010253e <namex+0x20e>
  releasesleep(&ip->lock);
801024c8:	83 ec 0c             	sub    $0xc,%esp
801024cb:	53                   	push   %ebx
801024cc:	e8 df 23 00 00       	call   801048b0 <releasesleep>
  iput(ip);
801024d1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801024d4:	31 f6                	xor    %esi,%esi
  iput(ip);
801024d6:	e8 85 f9 ff ff       	call   80101e60 <iput>
      return 0;
801024db:	83 c4 10             	add    $0x10,%esp
}
801024de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e1:	89 f0                	mov    %esi,%eax
801024e3:	5b                   	pop    %ebx
801024e4:	5e                   	pop    %esi
801024e5:	5f                   	pop    %edi
801024e6:	5d                   	pop    %ebp
801024e7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
801024e8:	ba 01 00 00 00       	mov    $0x1,%edx
801024ed:	b8 01 00 00 00       	mov    $0x1,%eax
801024f2:	e8 89 f3 ff ff       	call   80101880 <iget>
801024f7:	89 c6                	mov    %eax,%esi
801024f9:	e9 7d fe ff ff       	jmp    8010237b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801024fe:	83 ec 0c             	sub    $0xc,%esp
80102501:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102504:	53                   	push   %ebx
80102505:	e8 e6 23 00 00       	call   801048f0 <holdingsleep>
8010250a:	83 c4 10             	add    $0x10,%esp
8010250d:	85 c0                	test   %eax,%eax
8010250f:	74 2d                	je     8010253e <namex+0x20e>
80102511:	8b 7e 08             	mov    0x8(%esi),%edi
80102514:	85 ff                	test   %edi,%edi
80102516:	7e 26                	jle    8010253e <namex+0x20e>
  releasesleep(&ip->lock);
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	53                   	push   %ebx
8010251c:	e8 8f 23 00 00       	call   801048b0 <releasesleep>
}
80102521:	83 c4 10             	add    $0x10,%esp
}
80102524:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102527:	89 f0                	mov    %esi,%eax
80102529:	5b                   	pop    %ebx
8010252a:	5e                   	pop    %esi
8010252b:	5f                   	pop    %edi
8010252c:	5d                   	pop    %ebp
8010252d:	c3                   	ret
    iput(ip);
8010252e:	83 ec 0c             	sub    $0xc,%esp
80102531:	56                   	push   %esi
      return 0;
80102532:	31 f6                	xor    %esi,%esi
    iput(ip);
80102534:	e8 27 f9 ff ff       	call   80101e60 <iput>
    return 0;
80102539:	83 c4 10             	add    $0x10,%esp
8010253c:	eb a0                	jmp    801024de <namex+0x1ae>
    panic("iunlock");
8010253e:	83 ec 0c             	sub    $0xc,%esp
80102541:	68 2e 78 10 80       	push   $0x8010782e
80102546:	e8 25 de ff ff       	call   80100370 <panic>
8010254b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102550 <dirlink>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	57                   	push   %edi
80102554:	56                   	push   %esi
80102555:	53                   	push   %ebx
80102556:	83 ec 20             	sub    $0x20,%esp
80102559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010255c:	6a 00                	push   $0x0
8010255e:	ff 75 0c             	push   0xc(%ebp)
80102561:	53                   	push   %ebx
80102562:	e8 19 fd ff ff       	call   80102280 <dirlookup>
80102567:	83 c4 10             	add    $0x10,%esp
8010256a:	85 c0                	test   %eax,%eax
8010256c:	75 67                	jne    801025d5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010256e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102571:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102574:	85 ff                	test   %edi,%edi
80102576:	74 29                	je     801025a1 <dirlink+0x51>
80102578:	31 ff                	xor    %edi,%edi
8010257a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010257d:	eb 09                	jmp    80102588 <dirlink+0x38>
8010257f:	90                   	nop
80102580:	83 c7 10             	add    $0x10,%edi
80102583:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102586:	73 19                	jae    801025a1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102588:	6a 10                	push   $0x10
8010258a:	57                   	push   %edi
8010258b:	56                   	push   %esi
8010258c:	53                   	push   %ebx
8010258d:	e8 ae fa ff ff       	call   80102040 <readi>
80102592:	83 c4 10             	add    $0x10,%esp
80102595:	83 f8 10             	cmp    $0x10,%eax
80102598:	75 4e                	jne    801025e8 <dirlink+0x98>
    if(de.inum == 0)
8010259a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010259f:	75 df                	jne    80102580 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801025a1:	83 ec 04             	sub    $0x4,%esp
801025a4:	8d 45 da             	lea    -0x26(%ebp),%eax
801025a7:	6a 0e                	push   $0xe
801025a9:	ff 75 0c             	push   0xc(%ebp)
801025ac:	50                   	push   %eax
801025ad:	e8 ce 27 00 00       	call   80104d80 <strncpy>
  de.inum = inum;
801025b2:	8b 45 10             	mov    0x10(%ebp),%eax
801025b5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025b9:	6a 10                	push   $0x10
801025bb:	57                   	push   %edi
801025bc:	56                   	push   %esi
801025bd:	53                   	push   %ebx
801025be:	e8 7d fb ff ff       	call   80102140 <writei>
801025c3:	83 c4 20             	add    $0x20,%esp
801025c6:	83 f8 10             	cmp    $0x10,%eax
801025c9:	75 2a                	jne    801025f5 <dirlink+0xa5>
  return 0;
801025cb:	31 c0                	xor    %eax,%eax
}
801025cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025d0:	5b                   	pop    %ebx
801025d1:	5e                   	pop    %esi
801025d2:	5f                   	pop    %edi
801025d3:	5d                   	pop    %ebp
801025d4:	c3                   	ret
    iput(ip);
801025d5:	83 ec 0c             	sub    $0xc,%esp
801025d8:	50                   	push   %eax
801025d9:	e8 82 f8 ff ff       	call   80101e60 <iput>
    return -1;
801025de:	83 c4 10             	add    $0x10,%esp
801025e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025e6:	eb e5                	jmp    801025cd <dirlink+0x7d>
      panic("dirlink read");
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 57 78 10 80       	push   $0x80107857
801025f0:	e8 7b dd ff ff       	call   80100370 <panic>
    panic("dirlink");
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	68 b3 7a 10 80       	push   $0x80107ab3
801025fd:	e8 6e dd ff ff       	call   80100370 <panic>
80102602:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102609:	00 
8010260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102610 <namei>:

struct inode*
namei(char *path)
{
80102610:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102611:	31 d2                	xor    %edx,%edx
{
80102613:	89 e5                	mov    %esp,%ebp
80102615:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102618:	8b 45 08             	mov    0x8(%ebp),%eax
8010261b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010261e:	e8 0d fd ff ff       	call   80102330 <namex>
}
80102623:	c9                   	leave
80102624:	c3                   	ret
80102625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010262c:	00 
8010262d:	8d 76 00             	lea    0x0(%esi),%esi

80102630 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102630:	55                   	push   %ebp
  return namex(path, 1, name);
80102631:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102636:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102638:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010263b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010263e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010263f:	e9 ec fc ff ff       	jmp    80102330 <namex>
80102644:	66 90                	xchg   %ax,%ax
80102646:	66 90                	xchg   %ax,%ax
80102648:	66 90                	xchg   %ax,%ax
8010264a:	66 90                	xchg   %ax,%ax
8010264c:	66 90                	xchg   %ax,%ax
8010264e:	66 90                	xchg   %ax,%ax

80102650 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	57                   	push   %edi
80102654:	56                   	push   %esi
80102655:	53                   	push   %ebx
80102656:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102659:	85 c0                	test   %eax,%eax
8010265b:	0f 84 b4 00 00 00    	je     80102715 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102661:	8b 70 08             	mov    0x8(%eax),%esi
80102664:	89 c3                	mov    %eax,%ebx
80102666:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010266c:	0f 87 96 00 00 00    	ja     80102708 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102672:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102677:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010267e:	00 
8010267f:	90                   	nop
80102680:	89 ca                	mov    %ecx,%edx
80102682:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102683:	83 e0 c0             	and    $0xffffffc0,%eax
80102686:	3c 40                	cmp    $0x40,%al
80102688:	75 f6                	jne    80102680 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268a:	31 ff                	xor    %edi,%edi
8010268c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102691:	89 f8                	mov    %edi,%eax
80102693:	ee                   	out    %al,(%dx)
80102694:	b8 01 00 00 00       	mov    $0x1,%eax
80102699:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010269e:	ee                   	out    %al,(%dx)
8010269f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026a4:	89 f0                	mov    %esi,%eax
801026a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026a7:	89 f0                	mov    %esi,%eax
801026a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026ae:	c1 f8 08             	sar    $0x8,%eax
801026b1:	ee                   	out    %al,(%dx)
801026b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026b7:	89 f8                	mov    %edi,%eax
801026b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026ba:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801026be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026c3:	c1 e0 04             	shl    $0x4,%eax
801026c6:	83 e0 10             	and    $0x10,%eax
801026c9:	83 c8 e0             	or     $0xffffffe0,%eax
801026cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026cd:	f6 03 04             	testb  $0x4,(%ebx)
801026d0:	75 16                	jne    801026e8 <idestart+0x98>
801026d2:	b8 20 00 00 00       	mov    $0x20,%eax
801026d7:	89 ca                	mov    %ecx,%edx
801026d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801026da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026dd:	5b                   	pop    %ebx
801026de:	5e                   	pop    %esi
801026df:	5f                   	pop    %edi
801026e0:	5d                   	pop    %ebp
801026e1:	c3                   	ret
801026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026e8:	b8 30 00 00 00       	mov    $0x30,%eax
801026ed:	89 ca                	mov    %ecx,%edx
801026ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801026f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801026f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801026f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801026fd:	fc                   	cld
801026fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102703:	5b                   	pop    %ebx
80102704:	5e                   	pop    %esi
80102705:	5f                   	pop    %edi
80102706:	5d                   	pop    %ebp
80102707:	c3                   	ret
    panic("incorrect blockno");
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	68 6d 78 10 80       	push   $0x8010786d
80102710:	e8 5b dc ff ff       	call   80100370 <panic>
    panic("idestart");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 64 78 10 80       	push   $0x80107864
8010271d:	e8 4e dc ff ff       	call   80100370 <panic>
80102722:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102729:	00 
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102730 <ideinit>:
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102736:	68 7f 78 10 80       	push   $0x8010787f
8010273b:	68 00 26 11 80       	push   $0x80112600
80102740:	e8 fb 21 00 00       	call   80104940 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102745:	58                   	pop    %eax
80102746:	a1 84 27 11 80       	mov    0x80112784,%eax
8010274b:	5a                   	pop    %edx
8010274c:	83 e8 01             	sub    $0x1,%eax
8010274f:	50                   	push   %eax
80102750:	6a 0e                	push   $0xe
80102752:	e8 99 02 00 00       	call   801029f0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102757:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010275a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010275f:	90                   	nop
80102760:	89 ca                	mov    %ecx,%edx
80102762:	ec                   	in     (%dx),%al
80102763:	83 e0 c0             	and    $0xffffffc0,%eax
80102766:	3c 40                	cmp    $0x40,%al
80102768:	75 f6                	jne    80102760 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010276a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010276f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102774:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102775:	89 ca                	mov    %ecx,%edx
80102777:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102778:	84 c0                	test   %al,%al
8010277a:	75 1e                	jne    8010279a <ideinit+0x6a>
8010277c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102781:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102786:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278d:	00 
8010278e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102790:	83 e9 01             	sub    $0x1,%ecx
80102793:	74 0f                	je     801027a4 <ideinit+0x74>
80102795:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102796:	84 c0                	test   %al,%al
80102798:	74 f6                	je     80102790 <ideinit+0x60>
      havedisk1 = 1;
8010279a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801027a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801027a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027ae:	ee                   	out    %al,(%dx)
}
801027af:	c9                   	leave
801027b0:	c3                   	ret
801027b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027b8:	00 
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	57                   	push   %edi
801027c4:	56                   	push   %esi
801027c5:	53                   	push   %ebx
801027c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027c9:	68 00 26 11 80       	push   $0x80112600
801027ce:	e8 5d 23 00 00       	call   80104b30 <acquire>

  if((b = idequeue) == 0){
801027d3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801027d9:	83 c4 10             	add    $0x10,%esp
801027dc:	85 db                	test   %ebx,%ebx
801027de:	74 63                	je     80102843 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801027e0:	8b 43 58             	mov    0x58(%ebx),%eax
801027e3:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027e8:	8b 33                	mov    (%ebx),%esi
801027ea:	f7 c6 04 00 00 00    	test   $0x4,%esi
801027f0:	75 2f                	jne    80102821 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027fe:	00 
801027ff:	90                   	nop
80102800:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102801:	89 c1                	mov    %eax,%ecx
80102803:	83 e1 c0             	and    $0xffffffc0,%ecx
80102806:	80 f9 40             	cmp    $0x40,%cl
80102809:	75 f5                	jne    80102800 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010280b:	a8 21                	test   $0x21,%al
8010280d:	75 12                	jne    80102821 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010280f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102812:	b9 80 00 00 00       	mov    $0x80,%ecx
80102817:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010281c:	fc                   	cld
8010281d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010281f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102821:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102824:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102827:	83 ce 02             	or     $0x2,%esi
8010282a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010282c:	53                   	push   %ebx
8010282d:	e8 3e 1e 00 00       	call   80104670 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102832:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102837:	83 c4 10             	add    $0x10,%esp
8010283a:	85 c0                	test   %eax,%eax
8010283c:	74 05                	je     80102843 <ideintr+0x83>
    idestart(idequeue);
8010283e:	e8 0d fe ff ff       	call   80102650 <idestart>
    release(&idelock);
80102843:	83 ec 0c             	sub    $0xc,%esp
80102846:	68 00 26 11 80       	push   $0x80112600
8010284b:	e8 80 22 00 00       	call   80104ad0 <release>

  release(&idelock);
}
80102850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102853:	5b                   	pop    %ebx
80102854:	5e                   	pop    %esi
80102855:	5f                   	pop    %edi
80102856:	5d                   	pop    %ebp
80102857:	c3                   	ret
80102858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010285f:	00 

80102860 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 10             	sub    $0x10,%esp
80102867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010286a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010286d:	50                   	push   %eax
8010286e:	e8 7d 20 00 00       	call   801048f0 <holdingsleep>
80102873:	83 c4 10             	add    $0x10,%esp
80102876:	85 c0                	test   %eax,%eax
80102878:	0f 84 c3 00 00 00    	je     80102941 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010287e:	8b 03                	mov    (%ebx),%eax
80102880:	83 e0 06             	and    $0x6,%eax
80102883:	83 f8 02             	cmp    $0x2,%eax
80102886:	0f 84 a8 00 00 00    	je     80102934 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010288c:	8b 53 04             	mov    0x4(%ebx),%edx
8010288f:	85 d2                	test   %edx,%edx
80102891:	74 0d                	je     801028a0 <iderw+0x40>
80102893:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102898:	85 c0                	test   %eax,%eax
8010289a:	0f 84 87 00 00 00    	je     80102927 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	68 00 26 11 80       	push   $0x80112600
801028a8:	e8 83 22 00 00       	call   80104b30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ad:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801028b2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028b9:	83 c4 10             	add    $0x10,%esp
801028bc:	85 c0                	test   %eax,%eax
801028be:	74 60                	je     80102920 <iderw+0xc0>
801028c0:	89 c2                	mov    %eax,%edx
801028c2:	8b 40 58             	mov    0x58(%eax),%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	75 f7                	jne    801028c0 <iderw+0x60>
801028c9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801028cc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801028ce:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801028d4:	74 3a                	je     80102910 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028d6:	8b 03                	mov    (%ebx),%eax
801028d8:	83 e0 06             	and    $0x6,%eax
801028db:	83 f8 02             	cmp    $0x2,%eax
801028de:	74 1b                	je     801028fb <iderw+0x9b>
    sleep(b, &idelock);
801028e0:	83 ec 08             	sub    $0x8,%esp
801028e3:	68 00 26 11 80       	push   $0x80112600
801028e8:	53                   	push   %ebx
801028e9:	e8 c2 1c 00 00       	call   801045b0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ee:	8b 03                	mov    (%ebx),%eax
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	83 e0 06             	and    $0x6,%eax
801028f6:	83 f8 02             	cmp    $0x2,%eax
801028f9:	75 e5                	jne    801028e0 <iderw+0x80>
  }


  release(&idelock);
801028fb:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102905:	c9                   	leave
  release(&idelock);
80102906:	e9 c5 21 00 00       	jmp    80104ad0 <release>
8010290b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102910:	89 d8                	mov    %ebx,%eax
80102912:	e8 39 fd ff ff       	call   80102650 <idestart>
80102917:	eb bd                	jmp    801028d6 <iderw+0x76>
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102920:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102925:	eb a5                	jmp    801028cc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102927:	83 ec 0c             	sub    $0xc,%esp
8010292a:	68 ae 78 10 80       	push   $0x801078ae
8010292f:	e8 3c da ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
80102934:	83 ec 0c             	sub    $0xc,%esp
80102937:	68 99 78 10 80       	push   $0x80107899
8010293c:	e8 2f da ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
80102941:	83 ec 0c             	sub    $0xc,%esp
80102944:	68 83 78 10 80       	push   $0x80107883
80102949:	e8 22 da ff ff       	call   80100370 <panic>
8010294e:	66 90                	xchg   %ax,%ax

80102950 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	56                   	push   %esi
80102954:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102955:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010295c:	00 c0 fe 
  ioapic->reg = reg;
8010295f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102966:	00 00 00 
  return ioapic->data;
80102969:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010296f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102972:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102978:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010297e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102985:	c1 ee 10             	shr    $0x10,%esi
80102988:	89 f0                	mov    %esi,%eax
8010298a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010298d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102990:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102993:	39 c2                	cmp    %eax,%edx
80102995:	74 16                	je     801029ad <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102997:	83 ec 0c             	sub    $0xc,%esp
8010299a:	68 c0 7c 10 80       	push   $0x80107cc0
8010299f:	e8 bc dd ff ff       	call   80100760 <cprintf>
  ioapic->reg = reg;
801029a4:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801029aa:	83 c4 10             	add    $0x10,%esp
{
801029ad:	ba 10 00 00 00       	mov    $0x10,%edx
801029b2:	31 c0                	xor    %eax,%eax
801029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801029b8:	89 13                	mov    %edx,(%ebx)
801029ba:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801029bd:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029c3:	83 c0 01             	add    $0x1,%eax
801029c6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801029cc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801029cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801029d2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801029d5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801029d7:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801029dd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801029e4:	39 c6                	cmp    %eax,%esi
801029e6:	7d d0                	jge    801029b8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029eb:	5b                   	pop    %ebx
801029ec:	5e                   	pop    %esi
801029ed:	5d                   	pop    %ebp
801029ee:	c3                   	ret
801029ef:	90                   	nop

801029f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029f0:	55                   	push   %ebp
  ioapic->reg = reg;
801029f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801029f7:	89 e5                	mov    %esp,%ebp
801029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029fc:	8d 50 20             	lea    0x20(%eax),%edx
801029ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a03:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a05:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a0b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a0e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a14:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a16:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a1b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a1e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a21:	5d                   	pop    %ebp
80102a22:	c3                   	ret
80102a23:	66 90                	xchg   %ax,%ax
80102a25:	66 90                	xchg   %ax,%ax
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
80102a34:	83 ec 04             	sub    $0x4,%esp
80102a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a3a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102a40:	75 76                	jne    80102ab8 <kfree+0x88>
80102a42:	81 fb d0 64 11 80    	cmp    $0x801164d0,%ebx
80102a48:	72 6e                	jb     80102ab8 <kfree+0x88>
80102a4a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a50:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a55:	77 61                	ja     80102ab8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a57:	83 ec 04             	sub    $0x4,%esp
80102a5a:	68 00 10 00 00       	push   $0x1000
80102a5f:	6a 01                	push   $0x1
80102a61:	53                   	push   %ebx
80102a62:	e8 c9 21 00 00       	call   80104c30 <memset>

  if(kmem.use_lock)
80102a67:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102a6d:	83 c4 10             	add    $0x10,%esp
80102a70:	85 d2                	test   %edx,%edx
80102a72:	75 1c                	jne    80102a90 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102a74:	a1 78 26 11 80       	mov    0x80112678,%eax
80102a79:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102a7b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102a80:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102a86:	85 c0                	test   %eax,%eax
80102a88:	75 1e                	jne    80102aa8 <kfree+0x78>
    release(&kmem.lock);
}
80102a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a8d:	c9                   	leave
80102a8e:	c3                   	ret
80102a8f:	90                   	nop
    acquire(&kmem.lock);
80102a90:	83 ec 0c             	sub    $0xc,%esp
80102a93:	68 40 26 11 80       	push   $0x80112640
80102a98:	e8 93 20 00 00       	call   80104b30 <acquire>
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	eb d2                	jmp    80102a74 <kfree+0x44>
80102aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102aa8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab2:	c9                   	leave
    release(&kmem.lock);
80102ab3:	e9 18 20 00 00       	jmp    80104ad0 <release>
    panic("kfree");
80102ab8:	83 ec 0c             	sub    $0xc,%esp
80102abb:	68 cc 78 10 80       	push   $0x801078cc
80102ac0:	e8 ab d8 ff ff       	call   80100370 <panic>
80102ac5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102acc:	00 
80102acd:	8d 76 00             	lea    0x0(%esi),%esi

80102ad0 <freerange>:
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	56                   	push   %esi
80102ad4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102ad5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102adb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ae1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ae7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aed:	39 de                	cmp    %ebx,%esi
80102aef:	72 23                	jb     80102b14 <freerange+0x44>
80102af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102af8:	83 ec 0c             	sub    $0xc,%esp
80102afb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b07:	50                   	push   %eax
80102b08:	e8 23 ff ff ff       	call   80102a30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	39 de                	cmp    %ebx,%esi
80102b12:	73 e4                	jae    80102af8 <freerange+0x28>
}
80102b14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b17:	5b                   	pop    %ebx
80102b18:	5e                   	pop    %esi
80102b19:	5d                   	pop    %ebp
80102b1a:	c3                   	ret
80102b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102b20 <kinit2>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b3d:	39 de                	cmp    %ebx,%esi
80102b3f:	72 23                	jb     80102b64 <kinit2+0x44>
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b48:	83 ec 0c             	sub    $0xc,%esp
80102b4b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b57:	50                   	push   %eax
80102b58:	e8 d3 fe ff ff       	call   80102a30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	39 de                	cmp    %ebx,%esi
80102b62:	73 e4                	jae    80102b48 <kinit2+0x28>
  kmem.use_lock = 1;
80102b64:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102b6b:	00 00 00 
}
80102b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b71:	5b                   	pop    %ebx
80102b72:	5e                   	pop    %esi
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret
80102b75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b7c:	00 
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <kinit1>:
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
80102b85:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102b88:	83 ec 08             	sub    $0x8,%esp
80102b8b:	68 d2 78 10 80       	push   $0x801078d2
80102b90:	68 40 26 11 80       	push   $0x80112640
80102b95:	e8 a6 1d 00 00       	call   80104940 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b9d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ba0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102ba7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102baa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bb0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bbc:	39 de                	cmp    %ebx,%esi
80102bbe:	72 1c                	jb     80102bdc <kinit1+0x5c>
    kfree(p);
80102bc0:	83 ec 0c             	sub    $0xc,%esp
80102bc3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102bcf:	50                   	push   %eax
80102bd0:	e8 5b fe ff ff       	call   80102a30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd5:	83 c4 10             	add    $0x10,%esp
80102bd8:	39 de                	cmp    %ebx,%esi
80102bda:	73 e4                	jae    80102bc0 <kinit1+0x40>
}
80102bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5d                   	pop    %ebp
80102be2:	c3                   	ret
80102be3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bea:	00 
80102beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102bf0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102bf7:	a1 74 26 11 80       	mov    0x80112674,%eax
80102bfc:	85 c0                	test   %eax,%eax
80102bfe:	75 20                	jne    80102c20 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102c00:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102c06:	85 db                	test   %ebx,%ebx
80102c08:	74 07                	je     80102c11 <kalloc+0x21>
    kmem.freelist = r->next;
80102c0a:	8b 03                	mov    (%ebx),%eax
80102c0c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102c11:	89 d8                	mov    %ebx,%eax
80102c13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c16:	c9                   	leave
80102c17:	c3                   	ret
80102c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c1f:	00 
    acquire(&kmem.lock);
80102c20:	83 ec 0c             	sub    $0xc,%esp
80102c23:	68 40 26 11 80       	push   $0x80112640
80102c28:	e8 03 1f 00 00       	call   80104b30 <acquire>
  r = kmem.freelist;
80102c2d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102c33:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
80102c38:	83 c4 10             	add    $0x10,%esp
80102c3b:	85 db                	test   %ebx,%ebx
80102c3d:	74 08                	je     80102c47 <kalloc+0x57>
    kmem.freelist = r->next;
80102c3f:	8b 13                	mov    (%ebx),%edx
80102c41:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102c47:	85 c0                	test   %eax,%eax
80102c49:	74 c6                	je     80102c11 <kalloc+0x21>
    release(&kmem.lock);
80102c4b:	83 ec 0c             	sub    $0xc,%esp
80102c4e:	68 40 26 11 80       	push   $0x80112640
80102c53:	e8 78 1e 00 00       	call   80104ad0 <release>
}
80102c58:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102c5a:	83 c4 10             	add    $0x10,%esp
}
80102c5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c60:	c9                   	leave
80102c61:	c3                   	ret
80102c62:	66 90                	xchg   %ax,%ax
80102c64:	66 90                	xchg   %ax,%ax
80102c66:	66 90                	xchg   %ax,%ax
80102c68:	66 90                	xchg   %ax,%ax
80102c6a:	66 90                	xchg   %ax,%ax
80102c6c:	66 90                	xchg   %ax,%ax
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c70:	ba 64 00 00 00       	mov    $0x64,%edx
80102c75:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102c76:	a8 01                	test   $0x1,%al
80102c78:	0f 84 c2 00 00 00    	je     80102d40 <kbdgetc+0xd0>
{
80102c7e:	55                   	push   %ebp
80102c7f:	ba 60 00 00 00       	mov    $0x60,%edx
80102c84:	89 e5                	mov    %esp,%ebp
80102c86:	53                   	push   %ebx
80102c87:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102c88:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
80102c8e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102c91:	3c e0                	cmp    $0xe0,%al
80102c93:	74 5b                	je     80102cf0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c95:	89 da                	mov    %ebx,%edx
80102c97:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102c9a:	84 c0                	test   %al,%al
80102c9c:	78 62                	js     80102d00 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102c9e:	85 d2                	test   %edx,%edx
80102ca0:	74 09                	je     80102cab <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ca2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ca5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102ca8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102cab:	0f b6 91 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%edx
  shift ^= togglecode[data];
80102cb2:	0f b6 81 20 7e 10 80 	movzbl -0x7fef81e0(%ecx),%eax
  shift |= shiftcode[data];
80102cb9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102cbb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102cbd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102cbf:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cc5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102cc8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ccb:	8b 04 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%eax
80102cd2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102cd6:	74 0b                	je     80102ce3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102cd8:	8d 50 9f             	lea    -0x61(%eax),%edx
80102cdb:	83 fa 19             	cmp    $0x19,%edx
80102cde:	77 48                	ja     80102d28 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ce0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	c9                   	leave
80102ce7:	c3                   	ret
80102ce8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cef:	00 
    shift |= E0ESC;
80102cf0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102cf3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102cf5:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
80102cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cfe:	c9                   	leave
80102cff:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102d00:	83 e0 7f             	and    $0x7f,%eax
80102d03:	85 d2                	test   %edx,%edx
80102d05:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102d08:	0f b6 81 20 7f 10 80 	movzbl -0x7fef80e0(%ecx),%eax
80102d0f:	83 c8 40             	or     $0x40,%eax
80102d12:	0f b6 c0             	movzbl %al,%eax
80102d15:	f7 d0                	not    %eax
80102d17:	21 d8                	and    %ebx,%eax
80102d19:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102d1e:	31 c0                	xor    %eax,%eax
80102d20:	eb d9                	jmp    80102cfb <kbdgetc+0x8b>
80102d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102d28:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102d2b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d31:	c9                   	leave
      c += 'a' - 'A';
80102d32:	83 f9 1a             	cmp    $0x1a,%ecx
80102d35:	0f 42 c2             	cmovb  %edx,%eax
}
80102d38:	c3                   	ret
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d45:	c3                   	ret
80102d46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d4d:	00 
80102d4e:	66 90                	xchg   %ax,%ax

80102d50 <kbdintr>:

void
kbdintr(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102d56:	68 70 2c 10 80       	push   $0x80102c70
80102d5b:	e8 10 dc ff ff       	call   80100970 <consoleintr>
}
80102d60:	83 c4 10             	add    $0x10,%esp
80102d63:	c9                   	leave
80102d64:	c3                   	ret
80102d65:	66 90                	xchg   %ax,%ax
80102d67:	66 90                	xchg   %ax,%ax
80102d69:	66 90                	xchg   %ax,%ax
80102d6b:	66 90                	xchg   %ax,%ax
80102d6d:	66 90                	xchg   %ax,%ax
80102d6f:	90                   	nop

80102d70 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102d70:	a1 80 26 11 80       	mov    0x80112680,%eax
80102d75:	85 c0                	test   %eax,%eax
80102d77:	0f 84 c3 00 00 00    	je     80102e40 <lapicinit+0xd0>
  lapic[index] = value;
80102d7d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d84:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d8a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d91:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d97:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d9e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102da1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102da4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102dab:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102dae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102db1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102db8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102dbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dbe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102dc5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dcb:	8b 50 30             	mov    0x30(%eax),%edx
80102dce:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102dd4:	75 72                	jne    80102e48 <lapicinit+0xd8>
  lapic[index] = value;
80102dd6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ddd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102de3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102dea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ded:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102df0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102df7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dfa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dfd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e0a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102e11:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e17:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102e1e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102e21:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102e2e:	80 e6 10             	and    $0x10,%dh
80102e31:	75 f5                	jne    80102e28 <lapicinit+0xb8>
  lapic[index] = value;
80102e33:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102e3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e3d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e40:	c3                   	ret
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102e48:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102e4f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e52:	8b 50 20             	mov    0x20(%eax),%edx
}
80102e55:	e9 7c ff ff ff       	jmp    80102dd6 <lapicinit+0x66>
80102e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e60 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102e60:	a1 80 26 11 80       	mov    0x80112680,%eax
80102e65:	85 c0                	test   %eax,%eax
80102e67:	74 07                	je     80102e70 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102e69:	8b 40 20             	mov    0x20(%eax),%eax
80102e6c:	c1 e8 18             	shr    $0x18,%eax
80102e6f:	c3                   	ret
    return 0;
80102e70:	31 c0                	xor    %eax,%eax
}
80102e72:	c3                   	ret
80102e73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7a:	00 
80102e7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102e80:	a1 80 26 11 80       	mov    0x80112680,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	74 0d                	je     80102e96 <lapiceoi+0x16>
  lapic[index] = value;
80102e89:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e90:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e93:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102e96:	c3                   	ret
80102e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9e:	00 
80102e9f:	90                   	nop

80102ea0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ea0:	c3                   	ret
80102ea1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ea8:	00 
80102ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102eb0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102eb0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102eb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ec1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ec4:	ee                   	out    %al,(%dx)
80102ec5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102eca:	ba 71 00 00 00       	mov    $0x71,%edx
80102ecf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ed0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102ed2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ed5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102edb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102edd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102ee0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ee2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ee5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ee8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102eee:	a1 80 26 11 80       	mov    0x80112680,%eax
80102ef3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ef9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102efc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102f03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f06:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102f10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f13:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f1c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f25:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f37:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f3d:	c9                   	leave
80102f3e:	c3                   	ret
80102f3f:	90                   	nop

80102f40 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102f40:	55                   	push   %ebp
80102f41:	b8 0b 00 00 00       	mov    $0xb,%eax
80102f46:	ba 70 00 00 00       	mov    $0x70,%edx
80102f4b:	89 e5                	mov    %esp,%ebp
80102f4d:	57                   	push   %edi
80102f4e:	56                   	push   %esi
80102f4f:	53                   	push   %ebx
80102f50:	83 ec 4c             	sub    $0x4c,%esp
80102f53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f54:	ba 71 00 00 00       	mov    $0x71,%edx
80102f59:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102f5a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5d:	bf 70 00 00 00       	mov    $0x70,%edi
80102f62:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f65:	8d 76 00             	lea    0x0(%esi),%esi
80102f68:	31 c0                	xor    %eax,%eax
80102f6a:	89 fa                	mov    %edi,%edx
80102f6c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f6d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f72:	89 ca                	mov    %ecx,%edx
80102f74:	ec                   	in     (%dx),%al
80102f75:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f78:	89 fa                	mov    %edi,%edx
80102f7a:	b8 02 00 00 00       	mov    $0x2,%eax
80102f7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f80:	89 ca                	mov    %ecx,%edx
80102f82:	ec                   	in     (%dx),%al
80102f83:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f86:	89 fa                	mov    %edi,%edx
80102f88:	b8 04 00 00 00       	mov    $0x4,%eax
80102f8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f8e:	89 ca                	mov    %ecx,%edx
80102f90:	ec                   	in     (%dx),%al
80102f91:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f94:	89 fa                	mov    %edi,%edx
80102f96:	b8 07 00 00 00       	mov    $0x7,%eax
80102f9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f9c:	89 ca                	mov    %ecx,%edx
80102f9e:	ec                   	in     (%dx),%al
80102f9f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fa2:	89 fa                	mov    %edi,%edx
80102fa4:	b8 08 00 00 00       	mov    $0x8,%eax
80102fa9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102faa:	89 ca                	mov    %ecx,%edx
80102fac:	ec                   	in     (%dx),%al
80102fad:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102faf:	89 fa                	mov    %edi,%edx
80102fb1:	b8 09 00 00 00       	mov    $0x9,%eax
80102fb6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fb7:	89 ca                	mov    %ecx,%edx
80102fb9:	ec                   	in     (%dx),%al
80102fba:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fbd:	89 fa                	mov    %edi,%edx
80102fbf:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fc4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fc5:	89 ca                	mov    %ecx,%edx
80102fc7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102fc8:	84 c0                	test   %al,%al
80102fca:	78 9c                	js     80102f68 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102fcc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102fd0:	89 f2                	mov    %esi,%edx
80102fd2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102fd5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd8:	89 fa                	mov    %edi,%edx
80102fda:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102fdd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102fe1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102fe4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102fe7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102feb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102fee:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ff2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ff5:	31 c0                	xor    %eax,%eax
80102ff7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff8:	89 ca                	mov    %ecx,%edx
80102ffa:	ec                   	in     (%dx),%al
80102ffb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ffe:	89 fa                	mov    %edi,%edx
80103000:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103003:	b8 02 00 00 00       	mov    $0x2,%eax
80103008:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103009:	89 ca                	mov    %ecx,%edx
8010300b:	ec                   	in     (%dx),%al
8010300c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010300f:	89 fa                	mov    %edi,%edx
80103011:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103014:	b8 04 00 00 00       	mov    $0x4,%eax
80103019:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010301a:	89 ca                	mov    %ecx,%edx
8010301c:	ec                   	in     (%dx),%al
8010301d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103020:	89 fa                	mov    %edi,%edx
80103022:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103025:	b8 07 00 00 00       	mov    $0x7,%eax
8010302a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010302b:	89 ca                	mov    %ecx,%edx
8010302d:	ec                   	in     (%dx),%al
8010302e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103031:	89 fa                	mov    %edi,%edx
80103033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103036:	b8 08 00 00 00       	mov    $0x8,%eax
8010303b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010303c:	89 ca                	mov    %ecx,%edx
8010303e:	ec                   	in     (%dx),%al
8010303f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103042:	89 fa                	mov    %edi,%edx
80103044:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103047:	b8 09 00 00 00       	mov    $0x9,%eax
8010304c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010304d:	89 ca                	mov    %ecx,%edx
8010304f:	ec                   	in     (%dx),%al
80103050:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103053:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103056:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103059:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010305c:	6a 18                	push   $0x18
8010305e:	50                   	push   %eax
8010305f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103062:	50                   	push   %eax
80103063:	e8 08 1c 00 00       	call   80104c70 <memcmp>
80103068:	83 c4 10             	add    $0x10,%esp
8010306b:	85 c0                	test   %eax,%eax
8010306d:	0f 85 f5 fe ff ff    	jne    80102f68 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103073:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80103077:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010307a:	89 f0                	mov    %esi,%eax
8010307c:	84 c0                	test   %al,%al
8010307e:	75 78                	jne    801030f8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103080:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103083:	89 c2                	mov    %eax,%edx
80103085:	83 e0 0f             	and    $0xf,%eax
80103088:	c1 ea 04             	shr    $0x4,%edx
8010308b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010308e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103091:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103094:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103097:	89 c2                	mov    %eax,%edx
80103099:	83 e0 0f             	and    $0xf,%eax
8010309c:	c1 ea 04             	shr    $0x4,%edx
8010309f:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030a2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801030a8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030ab:	89 c2                	mov    %eax,%edx
801030ad:	83 e0 0f             	and    $0xf,%eax
801030b0:	c1 ea 04             	shr    $0x4,%edx
801030b3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030b6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801030bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030bf:	89 c2                	mov    %eax,%edx
801030c1:	83 e0 0f             	and    $0xf,%eax
801030c4:	c1 ea 04             	shr    $0x4,%edx
801030c7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030ca:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030cd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801030d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030d3:	89 c2                	mov    %eax,%edx
801030d5:	83 e0 0f             	and    $0xf,%eax
801030d8:	c1 ea 04             	shr    $0x4,%edx
801030db:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030de:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801030e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030e7:	89 c2                	mov    %eax,%edx
801030e9:	83 e0 0f             	and    $0xf,%eax
801030ec:	c1 ea 04             	shr    $0x4,%edx
801030ef:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030f2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801030f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030fb:	89 03                	mov    %eax,(%ebx)
801030fd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103100:	89 43 04             	mov    %eax,0x4(%ebx)
80103103:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103106:	89 43 08             	mov    %eax,0x8(%ebx)
80103109:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010310c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010310f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103112:	89 43 10             	mov    %eax,0x10(%ebx)
80103115:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103118:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010311b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103122:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103125:	5b                   	pop    %ebx
80103126:	5e                   	pop    %esi
80103127:	5f                   	pop    %edi
80103128:	5d                   	pop    %ebp
80103129:	c3                   	ret
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103130:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103136:	85 c9                	test   %ecx,%ecx
80103138:	0f 8e 8a 00 00 00    	jle    801031c8 <install_trans+0x98>
{
8010313e:	55                   	push   %ebp
8010313f:	89 e5                	mov    %esp,%ebp
80103141:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103142:	31 ff                	xor    %edi,%edi
{
80103144:	56                   	push   %esi
80103145:	53                   	push   %ebx
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103150:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103155:	83 ec 08             	sub    $0x8,%esp
80103158:	01 f8                	add    %edi,%eax
8010315a:	83 c0 01             	add    $0x1,%eax
8010315d:	50                   	push   %eax
8010315e:	ff 35 e4 26 11 80    	push   0x801126e4
80103164:	e8 67 cf ff ff       	call   801000d0 <bread>
80103169:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010316b:	58                   	pop    %eax
8010316c:	5a                   	pop    %edx
8010316d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80103174:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010317a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010317d:	e8 4e cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103182:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103185:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103187:	8d 46 5c             	lea    0x5c(%esi),%eax
8010318a:	68 00 02 00 00       	push   $0x200
8010318f:	50                   	push   %eax
80103190:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103193:	50                   	push   %eax
80103194:	e8 27 1b 00 00       	call   80104cc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103199:	89 1c 24             	mov    %ebx,(%esp)
8010319c:	e8 0f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801031a1:	89 34 24             	mov    %esi,(%esp)
801031a4:	e8 47 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801031a9:	89 1c 24             	mov    %ebx,(%esp)
801031ac:	e8 3f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031b1:	83 c4 10             	add    $0x10,%esp
801031b4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
801031ba:	7f 94                	jg     80103150 <install_trans+0x20>
  }
}
801031bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bf:	5b                   	pop    %ebx
801031c0:	5e                   	pop    %esi
801031c1:	5f                   	pop    %edi
801031c2:	5d                   	pop    %ebp
801031c3:	c3                   	ret
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031c8:	c3                   	ret
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801031d7:	ff 35 d4 26 11 80    	push   0x801126d4
801031dd:	ff 35 e4 26 11 80    	push   0x801126e4
801031e3:	e8 e8 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801031eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801031ed:	a1 e8 26 11 80       	mov    0x801126e8,%eax
801031f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801031f5:	85 c0                	test   %eax,%eax
801031f7:	7e 19                	jle    80103212 <write_head+0x42>
801031f9:	31 d2                	xor    %edx,%edx
801031fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103200:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80103207:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010320b:	83 c2 01             	add    $0x1,%edx
8010320e:	39 d0                	cmp    %edx,%eax
80103210:	75 ee                	jne    80103200 <write_head+0x30>
  }
  bwrite(buf);
80103212:	83 ec 0c             	sub    $0xc,%esp
80103215:	53                   	push   %ebx
80103216:	e8 95 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010321b:	89 1c 24             	mov    %ebx,(%esp)
8010321e:	e8 cd cf ff ff       	call   801001f0 <brelse>
}
80103223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103226:	83 c4 10             	add    $0x10,%esp
80103229:	c9                   	leave
8010322a:	c3                   	ret
8010322b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103230 <initlog>:
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	53                   	push   %ebx
80103234:	83 ec 2c             	sub    $0x2c,%esp
80103237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010323a:	68 d7 78 10 80       	push   $0x801078d7
8010323f:	68 a0 26 11 80       	push   $0x801126a0
80103244:	e8 f7 16 00 00       	call   80104940 <initlock>
  readsb(dev, &sb);
80103249:	58                   	pop    %eax
8010324a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010324d:	5a                   	pop    %edx
8010324e:	50                   	push   %eax
8010324f:	53                   	push   %ebx
80103250:	e8 7b e8 ff ff       	call   80101ad0 <readsb>
  log.start = sb.logstart;
80103255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103258:	59                   	pop    %ecx
  log.dev = dev;
80103259:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
8010325f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103262:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80103267:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
8010326d:	5a                   	pop    %edx
8010326e:	50                   	push   %eax
8010326f:	53                   	push   %ebx
80103270:	e8 5b ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103275:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103278:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010327b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80103281:	85 db                	test   %ebx,%ebx
80103283:	7e 1d                	jle    801032a2 <initlog+0x72>
80103285:	31 d2                	xor    %edx,%edx
80103287:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010328e:	00 
8010328f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103290:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103294:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010329b:	83 c2 01             	add    $0x1,%edx
8010329e:	39 d3                	cmp    %edx,%ebx
801032a0:	75 ee                	jne    80103290 <initlog+0x60>
  brelse(buf);
801032a2:	83 ec 0c             	sub    $0xc,%esp
801032a5:	50                   	push   %eax
801032a6:	e8 45 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801032ab:	e8 80 fe ff ff       	call   80103130 <install_trans>
  log.lh.n = 0;
801032b0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801032b7:	00 00 00 
  write_head(); // clear the log
801032ba:	e8 11 ff ff ff       	call   801031d0 <write_head>
}
801032bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032c2:	83 c4 10             	add    $0x10,%esp
801032c5:	c9                   	leave
801032c6:	c3                   	ret
801032c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ce:	00 
801032cf:	90                   	nop

801032d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801032d6:	68 a0 26 11 80       	push   $0x801126a0
801032db:	e8 50 18 00 00       	call   80104b30 <acquire>
801032e0:	83 c4 10             	add    $0x10,%esp
801032e3:	eb 18                	jmp    801032fd <begin_op+0x2d>
801032e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801032e8:	83 ec 08             	sub    $0x8,%esp
801032eb:	68 a0 26 11 80       	push   $0x801126a0
801032f0:	68 a0 26 11 80       	push   $0x801126a0
801032f5:	e8 b6 12 00 00       	call   801045b0 <sleep>
801032fa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801032fd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80103302:	85 c0                	test   %eax,%eax
80103304:	75 e2                	jne    801032e8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103306:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010330b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103311:	83 c0 01             	add    $0x1,%eax
80103314:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103317:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010331a:	83 fa 1e             	cmp    $0x1e,%edx
8010331d:	7f c9                	jg     801032e8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010331f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103322:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80103327:	68 a0 26 11 80       	push   $0x801126a0
8010332c:	e8 9f 17 00 00       	call   80104ad0 <release>
      break;
    }
  }
}
80103331:	83 c4 10             	add    $0x10,%esp
80103334:	c9                   	leave
80103335:	c3                   	ret
80103336:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333d:	00 
8010333e:	66 90                	xchg   %ax,%ax

80103340 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103349:	68 a0 26 11 80       	push   $0x801126a0
8010334e:	e8 dd 17 00 00       	call   80104b30 <acquire>
  log.outstanding -= 1;
80103353:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80103358:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
8010335e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103361:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103364:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
8010336a:	85 f6                	test   %esi,%esi
8010336c:	0f 85 22 01 00 00    	jne    80103494 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103372:	85 db                	test   %ebx,%ebx
80103374:	0f 85 f6 00 00 00    	jne    80103470 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010337a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80103381:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103384:	83 ec 0c             	sub    $0xc,%esp
80103387:	68 a0 26 11 80       	push   $0x801126a0
8010338c:	e8 3f 17 00 00       	call   80104ad0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103391:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103397:	83 c4 10             	add    $0x10,%esp
8010339a:	85 c9                	test   %ecx,%ecx
8010339c:	7f 42                	jg     801033e0 <end_op+0xa0>
    acquire(&log.lock);
8010339e:	83 ec 0c             	sub    $0xc,%esp
801033a1:	68 a0 26 11 80       	push   $0x801126a0
801033a6:	e8 85 17 00 00       	call   80104b30 <acquire>
    log.committing = 0;
801033ab:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
801033b2:	00 00 00 
    wakeup(&log);
801033b5:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033bc:	e8 af 12 00 00       	call   80104670 <wakeup>
    release(&log.lock);
801033c1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033c8:	e8 03 17 00 00       	call   80104ad0 <release>
801033cd:	83 c4 10             	add    $0x10,%esp
}
801033d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d3:	5b                   	pop    %ebx
801033d4:	5e                   	pop    %esi
801033d5:	5f                   	pop    %edi
801033d6:	5d                   	pop    %ebp
801033d7:	c3                   	ret
801033d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033df:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801033e0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801033e5:	83 ec 08             	sub    $0x8,%esp
801033e8:	01 d8                	add    %ebx,%eax
801033ea:	83 c0 01             	add    $0x1,%eax
801033ed:	50                   	push   %eax
801033ee:	ff 35 e4 26 11 80    	push   0x801126e4
801033f4:	e8 d7 cc ff ff       	call   801000d0 <bread>
801033f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033fb:	58                   	pop    %eax
801033fc:	5a                   	pop    %edx
801033fd:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103404:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010340a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010340d:	e8 be cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103412:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103415:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103417:	8d 40 5c             	lea    0x5c(%eax),%eax
8010341a:	68 00 02 00 00       	push   $0x200
8010341f:	50                   	push   %eax
80103420:	8d 46 5c             	lea    0x5c(%esi),%eax
80103423:	50                   	push   %eax
80103424:	e8 97 18 00 00       	call   80104cc0 <memmove>
    bwrite(to);  // write the log
80103429:	89 34 24             	mov    %esi,(%esp)
8010342c:	e8 7f cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103431:	89 3c 24             	mov    %edi,(%esp)
80103434:	e8 b7 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
80103439:	89 34 24             	mov    %esi,(%esp)
8010343c:	e8 af cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103441:	83 c4 10             	add    $0x10,%esp
80103444:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010344a:	7c 94                	jl     801033e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010344c:	e8 7f fd ff ff       	call   801031d0 <write_head>
    install_trans(); // Now install writes to home locations
80103451:	e8 da fc ff ff       	call   80103130 <install_trans>
    log.lh.n = 0;
80103456:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010345d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103460:	e8 6b fd ff ff       	call   801031d0 <write_head>
80103465:	e9 34 ff ff ff       	jmp    8010339e <end_op+0x5e>
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103470:	83 ec 0c             	sub    $0xc,%esp
80103473:	68 a0 26 11 80       	push   $0x801126a0
80103478:	e8 f3 11 00 00       	call   80104670 <wakeup>
  release(&log.lock);
8010347d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103484:	e8 47 16 00 00       	call   80104ad0 <release>
80103489:	83 c4 10             	add    $0x10,%esp
}
8010348c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010348f:	5b                   	pop    %ebx
80103490:	5e                   	pop    %esi
80103491:	5f                   	pop    %edi
80103492:	5d                   	pop    %ebp
80103493:	c3                   	ret
    panic("log.committing");
80103494:	83 ec 0c             	sub    $0xc,%esp
80103497:	68 db 78 10 80       	push   $0x801078db
8010349c:	e8 cf ce ff ff       	call   80100370 <panic>
801034a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034a8:	00 
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
801034b4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801034b7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
801034bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801034c0:	83 fa 1d             	cmp    $0x1d,%edx
801034c3:	7f 7d                	jg     80103542 <log_write+0x92>
801034c5:	a1 d8 26 11 80       	mov    0x801126d8,%eax
801034ca:	83 e8 01             	sub    $0x1,%eax
801034cd:	39 c2                	cmp    %eax,%edx
801034cf:	7d 71                	jge    80103542 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
801034d1:	a1 dc 26 11 80       	mov    0x801126dc,%eax
801034d6:	85 c0                	test   %eax,%eax
801034d8:	7e 75                	jle    8010354f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
801034da:	83 ec 0c             	sub    $0xc,%esp
801034dd:	68 a0 26 11 80       	push   $0x801126a0
801034e2:	e8 49 16 00 00       	call   80104b30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034e7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801034ea:	83 c4 10             	add    $0x10,%esp
801034ed:	31 c0                	xor    %eax,%eax
801034ef:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
801034f5:	85 d2                	test   %edx,%edx
801034f7:	7f 0e                	jg     80103507 <log_write+0x57>
801034f9:	eb 15                	jmp    80103510 <log_write+0x60>
801034fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103500:	83 c0 01             	add    $0x1,%eax
80103503:	39 c2                	cmp    %eax,%edx
80103505:	74 29                	je     80103530 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103507:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010350e:	75 f0                	jne    80103500 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103510:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80103517:	39 c2                	cmp    %eax,%edx
80103519:	74 1c                	je     80103537 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010351b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010351e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103521:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103528:	c9                   	leave
  release(&log.lock);
80103529:	e9 a2 15 00 00       	jmp    80104ad0 <release>
8010352e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103530:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103537:	83 c2 01             	add    $0x1,%edx
8010353a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103540:	eb d9                	jmp    8010351b <log_write+0x6b>
    panic("too big a transaction");
80103542:	83 ec 0c             	sub    $0xc,%esp
80103545:	68 ea 78 10 80       	push   $0x801078ea
8010354a:	e8 21 ce ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	68 00 79 10 80       	push   $0x80107900
80103557:	e8 14 ce ff ff       	call   80100370 <panic>
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	53                   	push   %ebx
80103564:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103567:	e8 64 09 00 00       	call   80103ed0 <cpuid>
8010356c:	89 c3                	mov    %eax,%ebx
8010356e:	e8 5d 09 00 00       	call   80103ed0 <cpuid>
80103573:	83 ec 04             	sub    $0x4,%esp
80103576:	53                   	push   %ebx
80103577:	50                   	push   %eax
80103578:	68 1b 79 10 80       	push   $0x8010791b
8010357d:	e8 de d1 ff ff       	call   80100760 <cprintf>
  idtinit();       // load idt register
80103582:	e8 e9 28 00 00       	call   80105e70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103587:	e8 e4 08 00 00       	call   80103e70 <mycpu>
8010358c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010358e:	b8 01 00 00 00       	mov    $0x1,%eax
80103593:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010359a:	e8 01 0c 00 00       	call   801041a0 <scheduler>
8010359f:	90                   	nop

801035a0 <mpenter>:
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801035a6:	e8 c5 39 00 00       	call   80106f70 <switchkvm>
  seginit();
801035ab:	e8 30 39 00 00       	call   80106ee0 <seginit>
  lapicinit();
801035b0:	e8 bb f7 ff ff       	call   80102d70 <lapicinit>
  mpmain();
801035b5:	e8 a6 ff ff ff       	call   80103560 <mpmain>
801035ba:	66 90                	xchg   %ax,%ax
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <main>:
{
801035c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801035c4:	83 e4 f0             	and    $0xfffffff0,%esp
801035c7:	ff 71 fc             	push   -0x4(%ecx)
801035ca:	55                   	push   %ebp
801035cb:	89 e5                	mov    %esp,%ebp
801035cd:	53                   	push   %ebx
801035ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801035cf:	83 ec 08             	sub    $0x8,%esp
801035d2:	68 00 00 40 80       	push   $0x80400000
801035d7:	68 d0 64 11 80       	push   $0x801164d0
801035dc:	e8 9f f5 ff ff       	call   80102b80 <kinit1>
  kvmalloc();      // kernel page table
801035e1:	e8 4a 3e 00 00       	call   80107430 <kvmalloc>
  mpinit();        // detect other processors
801035e6:	e8 85 01 00 00       	call   80103770 <mpinit>
  lapicinit();     // interrupt controller
801035eb:	e8 80 f7 ff ff       	call   80102d70 <lapicinit>
  seginit();       // segment descriptors
801035f0:	e8 eb 38 00 00       	call   80106ee0 <seginit>
  picinit();       // disable pic
801035f5:	e8 86 03 00 00       	call   80103980 <picinit>
  ioapicinit();    // another interrupt controller
801035fa:	e8 51 f3 ff ff       	call   80102950 <ioapicinit>
  consoleinit();   // console hardware
801035ff:	e8 ec d9 ff ff       	call   80100ff0 <consoleinit>
  uartinit();      // serial port
80103604:	e8 47 2b 00 00       	call   80106150 <uartinit>
  pinit();         // process table
80103609:	e8 42 08 00 00       	call   80103e50 <pinit>
  tvinit();        // trap vectors
8010360e:	e8 dd 27 00 00       	call   80105df0 <tvinit>
  binit();         // buffer cache
80103613:	e8 28 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103618:	e8 a3 dd ff ff       	call   801013c0 <fileinit>
  ideinit();       // disk 
8010361d:	e8 0e f1 ff ff       	call   80102730 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103622:	83 c4 0c             	add    $0xc,%esp
80103625:	68 8a 00 00 00       	push   $0x8a
8010362a:	68 8c b4 10 80       	push   $0x8010b48c
8010362f:	68 00 70 00 80       	push   $0x80007000
80103634:	e8 87 16 00 00       	call   80104cc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103643:	00 00 00 
80103646:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010364b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103650:	76 7e                	jbe    801036d0 <main+0x110>
80103652:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103657:	eb 20                	jmp    80103679 <main+0xb9>
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103667:	00 00 00 
8010366a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103670:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103675:	39 c3                	cmp    %eax,%ebx
80103677:	73 57                	jae    801036d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103679:	e8 f2 07 00 00       	call   80103e70 <mycpu>
8010367e:	39 c3                	cmp    %eax,%ebx
80103680:	74 de                	je     80103660 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103682:	e8 69 f5 ff ff       	call   80102bf0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103687:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010368a:	c7 05 f8 6f 00 80 a0 	movl   $0x801035a0,0x80006ff8
80103691:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103694:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010369b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010369e:	05 00 10 00 00       	add    $0x1000,%eax
801036a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801036a8:	0f b6 03             	movzbl (%ebx),%eax
801036ab:	68 00 70 00 00       	push   $0x7000
801036b0:	50                   	push   %eax
801036b1:	e8 fa f7 ff ff       	call   80102eb0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801036b6:	83 c4 10             	add    $0x10,%esp
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801036c6:	85 c0                	test   %eax,%eax
801036c8:	74 f6                	je     801036c0 <main+0x100>
801036ca:	eb 94                	jmp    80103660 <main+0xa0>
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801036d0:	83 ec 08             	sub    $0x8,%esp
801036d3:	68 00 00 00 8e       	push   $0x8e000000
801036d8:	68 00 00 40 80       	push   $0x80400000
801036dd:	e8 3e f4 ff ff       	call   80102b20 <kinit2>
  userinit();      // first user process
801036e2:	e8 39 08 00 00       	call   80103f20 <userinit>
  mpmain();        // finish this processor's setup
801036e7:	e8 74 fe ff ff       	call   80103560 <mpmain>
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801036f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801036fb:	53                   	push   %ebx
  e = addr+len;
801036fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801036ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103702:	39 de                	cmp    %ebx,%esi
80103704:	72 10                	jb     80103716 <mpsearch1+0x26>
80103706:	eb 50                	jmp    80103758 <mpsearch1+0x68>
80103708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010370f:	00 
80103710:	89 fe                	mov    %edi,%esi
80103712:	39 df                	cmp    %ebx,%edi
80103714:	73 42                	jae    80103758 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103716:	83 ec 04             	sub    $0x4,%esp
80103719:	8d 7e 10             	lea    0x10(%esi),%edi
8010371c:	6a 04                	push   $0x4
8010371e:	68 2f 79 10 80       	push   $0x8010792f
80103723:	56                   	push   %esi
80103724:	e8 47 15 00 00       	call   80104c70 <memcmp>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	85 c0                	test   %eax,%eax
8010372e:	75 e0                	jne    80103710 <mpsearch1+0x20>
80103730:	89 f2                	mov    %esi,%edx
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103738:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010373b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010373e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103740:	39 fa                	cmp    %edi,%edx
80103742:	75 f4                	jne    80103738 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103744:	84 c0                	test   %al,%al
80103746:	75 c8                	jne    80103710 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010374b:	89 f0                	mov    %esi,%eax
8010374d:	5b                   	pop    %ebx
8010374e:	5e                   	pop    %esi
8010374f:	5f                   	pop    %edi
80103750:	5d                   	pop    %ebp
80103751:	c3                   	ret
80103752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010375b:	31 f6                	xor    %esi,%esi
}
8010375d:	5b                   	pop    %ebx
8010375e:	89 f0                	mov    %esi,%eax
80103760:	5e                   	pop    %esi
80103761:	5f                   	pop    %edi
80103762:	5d                   	pop    %ebp
80103763:	c3                   	ret
80103764:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010376b:	00 
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103770 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	53                   	push   %ebx
80103776:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103779:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103780:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103787:	c1 e0 08             	shl    $0x8,%eax
8010378a:	09 d0                	or     %edx,%eax
8010378c:	c1 e0 04             	shl    $0x4,%eax
8010378f:	75 1b                	jne    801037ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103791:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103798:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010379f:	c1 e0 08             	shl    $0x8,%eax
801037a2:	09 d0                	or     %edx,%eax
801037a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801037a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801037ac:	ba 00 04 00 00       	mov    $0x400,%edx
801037b1:	e8 3a ff ff ff       	call   801036f0 <mpsearch1>
801037b6:	89 c3                	mov    %eax,%ebx
801037b8:	85 c0                	test   %eax,%eax
801037ba:	0f 84 58 01 00 00    	je     80103918 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037c0:	8b 73 04             	mov    0x4(%ebx),%esi
801037c3:	85 f6                	test   %esi,%esi
801037c5:	0f 84 3d 01 00 00    	je     80103908 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801037cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801037d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037d7:	6a 04                	push   $0x4
801037d9:	68 34 79 10 80       	push   $0x80107934
801037de:	50                   	push   %eax
801037df:	e8 8c 14 00 00       	call   80104c70 <memcmp>
801037e4:	83 c4 10             	add    $0x10,%esp
801037e7:	85 c0                	test   %eax,%eax
801037e9:	0f 85 19 01 00 00    	jne    80103908 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801037ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801037f6:	3c 01                	cmp    $0x1,%al
801037f8:	74 08                	je     80103802 <mpinit+0x92>
801037fa:	3c 04                	cmp    $0x4,%al
801037fc:	0f 85 06 01 00 00    	jne    80103908 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103802:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103809:	66 85 d2             	test   %dx,%dx
8010380c:	74 22                	je     80103830 <mpinit+0xc0>
8010380e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103811:	89 f0                	mov    %esi,%eax
  sum = 0;
80103813:	31 d2                	xor    %edx,%edx
80103815:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103818:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010381f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103822:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103824:	39 f8                	cmp    %edi,%eax
80103826:	75 f0                	jne    80103818 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103828:	84 d2                	test   %dl,%dl
8010382a:	0f 85 d8 00 00 00    	jne    80103908 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103830:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103839:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010383c:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103841:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103848:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010384e:	01 d7                	add    %edx,%edi
80103850:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103852:	bf 01 00 00 00       	mov    $0x1,%edi
80103857:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010385e:	00 
8010385f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103860:	39 d0                	cmp    %edx,%eax
80103862:	73 19                	jae    8010387d <mpinit+0x10d>
    switch(*p){
80103864:	0f b6 08             	movzbl (%eax),%ecx
80103867:	80 f9 02             	cmp    $0x2,%cl
8010386a:	0f 84 80 00 00 00    	je     801038f0 <mpinit+0x180>
80103870:	77 6e                	ja     801038e0 <mpinit+0x170>
80103872:	84 c9                	test   %cl,%cl
80103874:	74 3a                	je     801038b0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103876:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103879:	39 d0                	cmp    %edx,%eax
8010387b:	72 e7                	jb     80103864 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010387d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103880:	85 ff                	test   %edi,%edi
80103882:	0f 84 dd 00 00 00    	je     80103965 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103888:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010388c:	74 15                	je     801038a3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010388e:	b8 70 00 00 00       	mov    $0x70,%eax
80103893:	ba 22 00 00 00       	mov    $0x22,%edx
80103898:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103899:	ba 23 00 00 00       	mov    $0x23,%edx
8010389e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010389f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038a2:	ee                   	out    %al,(%dx)
  }
}
801038a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a6:	5b                   	pop    %ebx
801038a7:	5e                   	pop    %esi
801038a8:	5f                   	pop    %edi
801038a9:	5d                   	pop    %ebp
801038aa:	c3                   	ret
801038ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801038b0:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
801038b6:	83 f9 07             	cmp    $0x7,%ecx
801038b9:	7f 19                	jg     801038d4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038bb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801038c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038c5:	83 c1 01             	add    $0x1,%ecx
801038c8:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038ce:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
801038d4:	83 c0 14             	add    $0x14,%eax
      continue;
801038d7:	eb 87                	jmp    80103860 <mpinit+0xf0>
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801038e0:	83 e9 03             	sub    $0x3,%ecx
801038e3:	80 f9 01             	cmp    $0x1,%cl
801038e6:	76 8e                	jbe    80103876 <mpinit+0x106>
801038e8:	31 ff                	xor    %edi,%edi
801038ea:	e9 71 ff ff ff       	jmp    80103860 <mpinit+0xf0>
801038ef:	90                   	nop
      ioapicid = ioapic->apicno;
801038f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801038f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801038f7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801038fd:	e9 5e ff ff ff       	jmp    80103860 <mpinit+0xf0>
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103908:	83 ec 0c             	sub    $0xc,%esp
8010390b:	68 39 79 10 80       	push   $0x80107939
80103910:	e8 5b ca ff ff       	call   80100370 <panic>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
{
80103918:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010391d:	eb 0b                	jmp    8010392a <mpinit+0x1ba>
8010391f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103920:	89 f3                	mov    %esi,%ebx
80103922:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103928:	74 de                	je     80103908 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010392a:	83 ec 04             	sub    $0x4,%esp
8010392d:	8d 73 10             	lea    0x10(%ebx),%esi
80103930:	6a 04                	push   $0x4
80103932:	68 2f 79 10 80       	push   $0x8010792f
80103937:	53                   	push   %ebx
80103938:	e8 33 13 00 00       	call   80104c70 <memcmp>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	85 c0                	test   %eax,%eax
80103942:	75 dc                	jne    80103920 <mpinit+0x1b0>
80103944:	89 da                	mov    %ebx,%edx
80103946:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010394d:	00 
8010394e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103950:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103953:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103956:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103958:	39 d6                	cmp    %edx,%esi
8010395a:	75 f4                	jne    80103950 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010395c:	84 c0                	test   %al,%al
8010395e:	75 c0                	jne    80103920 <mpinit+0x1b0>
80103960:	e9 5b fe ff ff       	jmp    801037c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 f4 7c 10 80       	push   $0x80107cf4
8010396d:	e8 fe c9 ff ff       	call   80100370 <panic>
80103972:	66 90                	xchg   %ax,%ax
80103974:	66 90                	xchg   %ax,%ax
80103976:	66 90                	xchg   %ax,%ax
80103978:	66 90                	xchg   %ax,%ax
8010397a:	66 90                	xchg   %ax,%ax
8010397c:	66 90                	xchg   %ax,%ax
8010397e:	66 90                	xchg   %ax,%ax

80103980 <picinit>:
80103980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103985:	ba 21 00 00 00       	mov    $0x21,%edx
8010398a:	ee                   	out    %al,(%dx)
8010398b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103990:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103991:	c3                   	ret
80103992:	66 90                	xchg   %ax,%ax
80103994:	66 90                	xchg   %ax,%ax
80103996:	66 90                	xchg   %ax,%ax
80103998:	66 90                	xchg   %ax,%ax
8010399a:	66 90                	xchg   %ax,%ax
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 0c             	sub    $0xc,%esp
801039a9:	8b 75 08             	mov    0x8(%ebp),%esi
801039ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801039af:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801039b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801039bb:	e8 20 da ff ff       	call   801013e0 <filealloc>
801039c0:	89 06                	mov    %eax,(%esi)
801039c2:	85 c0                	test   %eax,%eax
801039c4:	0f 84 a5 00 00 00    	je     80103a6f <pipealloc+0xcf>
801039ca:	e8 11 da ff ff       	call   801013e0 <filealloc>
801039cf:	89 07                	mov    %eax,(%edi)
801039d1:	85 c0                	test   %eax,%eax
801039d3:	0f 84 84 00 00 00    	je     80103a5d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801039d9:	e8 12 f2 ff ff       	call   80102bf0 <kalloc>
801039de:	89 c3                	mov    %eax,%ebx
801039e0:	85 c0                	test   %eax,%eax
801039e2:	0f 84 a0 00 00 00    	je     80103a88 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801039e8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801039ef:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801039f2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801039f5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039fc:	00 00 00 
  p->nwrite = 0;
801039ff:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a06:	00 00 00 
  p->nread = 0;
80103a09:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103a10:	00 00 00 
  initlock(&p->lock, "pipe");
80103a13:	68 51 79 10 80       	push   $0x80107951
80103a18:	50                   	push   %eax
80103a19:	e8 22 0f 00 00       	call   80104940 <initlock>
  (*f0)->type = FD_PIPE;
80103a1e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103a20:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103a23:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103a29:	8b 06                	mov    (%esi),%eax
80103a2b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103a2f:	8b 06                	mov    (%esi),%eax
80103a31:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103a35:	8b 06                	mov    (%esi),%eax
80103a37:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103a3a:	8b 07                	mov    (%edi),%eax
80103a3c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103a42:	8b 07                	mov    (%edi),%eax
80103a44:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103a48:	8b 07                	mov    (%edi),%eax
80103a4a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103a4e:	8b 07                	mov    (%edi),%eax
80103a50:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103a53:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a58:	5b                   	pop    %ebx
80103a59:	5e                   	pop    %esi
80103a5a:	5f                   	pop    %edi
80103a5b:	5d                   	pop    %ebp
80103a5c:	c3                   	ret
  if(*f0)
80103a5d:	8b 06                	mov    (%esi),%eax
80103a5f:	85 c0                	test   %eax,%eax
80103a61:	74 1e                	je     80103a81 <pipealloc+0xe1>
    fileclose(*f0);
80103a63:	83 ec 0c             	sub    $0xc,%esp
80103a66:	50                   	push   %eax
80103a67:	e8 34 da ff ff       	call   801014a0 <fileclose>
80103a6c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a6f:	8b 07                	mov    (%edi),%eax
80103a71:	85 c0                	test   %eax,%eax
80103a73:	74 0c                	je     80103a81 <pipealloc+0xe1>
    fileclose(*f1);
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	50                   	push   %eax
80103a79:	e8 22 da ff ff       	call   801014a0 <fileclose>
80103a7e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a86:	eb cd                	jmp    80103a55 <pipealloc+0xb5>
  if(*f0)
80103a88:	8b 06                	mov    (%esi),%eax
80103a8a:	85 c0                	test   %eax,%eax
80103a8c:	75 d5                	jne    80103a63 <pipealloc+0xc3>
80103a8e:	eb df                	jmp    80103a6f <pipealloc+0xcf>

80103a90 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
80103a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a98:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103a9b:	83 ec 0c             	sub    $0xc,%esp
80103a9e:	53                   	push   %ebx
80103a9f:	e8 8c 10 00 00       	call   80104b30 <acquire>
  if(writable){
80103aa4:	83 c4 10             	add    $0x10,%esp
80103aa7:	85 f6                	test   %esi,%esi
80103aa9:	74 65                	je     80103b10 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103aab:	83 ec 0c             	sub    $0xc,%esp
80103aae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103ab4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103abb:	00 00 00 
    wakeup(&p->nread);
80103abe:	50                   	push   %eax
80103abf:	e8 ac 0b 00 00       	call   80104670 <wakeup>
80103ac4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103ac7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103acd:	85 d2                	test   %edx,%edx
80103acf:	75 0a                	jne    80103adb <pipeclose+0x4b>
80103ad1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103ad7:	85 c0                	test   %eax,%eax
80103ad9:	74 15                	je     80103af0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103adb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5d                   	pop    %ebp
    release(&p->lock);
80103ae4:	e9 e7 0f 00 00       	jmp    80104ad0 <release>
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	53                   	push   %ebx
80103af4:	e8 d7 0f 00 00       	call   80104ad0 <release>
    kfree((char*)p);
80103af9:	83 c4 10             	add    $0x10,%esp
80103afc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b02:	5b                   	pop    %ebx
80103b03:	5e                   	pop    %esi
80103b04:	5d                   	pop    %ebp
    kfree((char*)p);
80103b05:	e9 26 ef ff ff       	jmp    80102a30 <kfree>
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103b19:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b20:	00 00 00 
    wakeup(&p->nwrite);
80103b23:	50                   	push   %eax
80103b24:	e8 47 0b 00 00       	call   80104670 <wakeup>
80103b29:	83 c4 10             	add    $0x10,%esp
80103b2c:	eb 99                	jmp    80103ac7 <pipeclose+0x37>
80103b2e:	66 90                	xchg   %ax,%ax

80103b30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 28             	sub    $0x28,%esp
80103b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b3c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b3f:	53                   	push   %ebx
80103b40:	e8 eb 0f 00 00       	call   80104b30 <acquire>
  for(i = 0; i < n; i++){
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	85 ff                	test   %edi,%edi
80103b4a:	0f 8e ce 00 00 00    	jle    80103c1e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b50:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103b59:	89 7d 10             	mov    %edi,0x10(%ebp)
80103b5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103b62:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103b65:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b6b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b71:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b77:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103b7d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103b80:	0f 85 b6 00 00 00    	jne    80103c3c <pipewrite+0x10c>
80103b86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103b89:	eb 3b                	jmp    80103bc6 <pipewrite+0x96>
80103b8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103b90:	e8 5b 03 00 00       	call   80103ef0 <myproc>
80103b95:	8b 48 24             	mov    0x24(%eax),%ecx
80103b98:	85 c9                	test   %ecx,%ecx
80103b9a:	75 34                	jne    80103bd0 <pipewrite+0xa0>
      wakeup(&p->nread);
80103b9c:	83 ec 0c             	sub    $0xc,%esp
80103b9f:	56                   	push   %esi
80103ba0:	e8 cb 0a 00 00       	call   80104670 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ba5:	58                   	pop    %eax
80103ba6:	5a                   	pop    %edx
80103ba7:	53                   	push   %ebx
80103ba8:	57                   	push   %edi
80103ba9:	e8 02 0a 00 00       	call   801045b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103bae:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103bb4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103bba:	83 c4 10             	add    $0x10,%esp
80103bbd:	05 00 02 00 00       	add    $0x200,%eax
80103bc2:	39 c2                	cmp    %eax,%edx
80103bc4:	75 2a                	jne    80103bf0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103bc6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	75 c0                	jne    80103b90 <pipewrite+0x60>
        release(&p->lock);
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	53                   	push   %ebx
80103bd4:	e8 f7 0e 00 00       	call   80104ad0 <release>
        return -1;
80103bd9:	83 c4 10             	add    $0x10,%esp
80103bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103be1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103be4:	5b                   	pop    %ebx
80103be5:	5e                   	pop    %esi
80103be6:	5f                   	pop    %edi
80103be7:	5d                   	pop    %ebp
80103be8:	c3                   	ret
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103bf3:	8d 42 01             	lea    0x1(%edx),%eax
80103bf6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80103bfc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103bff:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c08:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80103c0c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c13:	39 c1                	cmp    %eax,%ecx
80103c15:	0f 85 50 ff ff ff    	jne    80103b6b <pipewrite+0x3b>
80103c1b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103c1e:	83 ec 0c             	sub    $0xc,%esp
80103c21:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c27:	50                   	push   %eax
80103c28:	e8 43 0a 00 00       	call   80104670 <wakeup>
  release(&p->lock);
80103c2d:	89 1c 24             	mov    %ebx,(%esp)
80103c30:	e8 9b 0e 00 00       	call   80104ad0 <release>
  return n;
80103c35:	83 c4 10             	add    $0x10,%esp
80103c38:	89 f8                	mov    %edi,%eax
80103c3a:	eb a5                	jmp    80103be1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c3f:	eb b2                	jmp    80103bf3 <pipewrite+0xc3>
80103c41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c48:	00 
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 18             	sub    $0x18,%esp
80103c59:	8b 75 08             	mov    0x8(%ebp),%esi
80103c5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103c5f:	56                   	push   %esi
80103c60:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c66:	e8 c5 0e 00 00       	call   80104b30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c6b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c7a:	74 2f                	je     80103cab <piperead+0x5b>
80103c7c:	eb 37                	jmp    80103cb5 <piperead+0x65>
80103c7e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103c80:	e8 6b 02 00 00       	call   80103ef0 <myproc>
80103c85:	8b 40 24             	mov    0x24(%eax),%eax
80103c88:	85 c0                	test   %eax,%eax
80103c8a:	0f 85 80 00 00 00    	jne    80103d10 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c90:	83 ec 08             	sub    $0x8,%esp
80103c93:	56                   	push   %esi
80103c94:	53                   	push   %ebx
80103c95:	e8 16 09 00 00       	call   801045b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c9a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ca0:	83 c4 10             	add    $0x10,%esp
80103ca3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103ca9:	75 0a                	jne    80103cb5 <piperead+0x65>
80103cab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103cb1:	85 d2                	test   %edx,%edx
80103cb3:	75 cb                	jne    80103c80 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103cb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103cb8:	31 db                	xor    %ebx,%ebx
80103cba:	85 c9                	test   %ecx,%ecx
80103cbc:	7f 26                	jg     80103ce4 <piperead+0x94>
80103cbe:	eb 2c                	jmp    80103cec <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103cc0:	8d 48 01             	lea    0x1(%eax),%ecx
80103cc3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103cc8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103cce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103cd3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103cd6:	83 c3 01             	add    $0x1,%ebx
80103cd9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103cdc:	74 0e                	je     80103cec <piperead+0x9c>
80103cde:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103ce4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103cea:	75 d4                	jne    80103cc0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103cec:	83 ec 0c             	sub    $0xc,%esp
80103cef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103cf5:	50                   	push   %eax
80103cf6:	e8 75 09 00 00       	call   80104670 <wakeup>
  release(&p->lock);
80103cfb:	89 34 24             	mov    %esi,(%esp)
80103cfe:	e8 cd 0d 00 00       	call   80104ad0 <release>
  return i;
80103d03:	83 c4 10             	add    $0x10,%esp
}
80103d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d09:	89 d8                	mov    %ebx,%eax
80103d0b:	5b                   	pop    %ebx
80103d0c:	5e                   	pop    %esi
80103d0d:	5f                   	pop    %edi
80103d0e:	5d                   	pop    %ebp
80103d0f:	c3                   	ret
      release(&p->lock);
80103d10:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d13:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d18:	56                   	push   %esi
80103d19:	e8 b2 0d 00 00       	call   80104ad0 <release>
      return -1;
80103d1e:	83 c4 10             	add    $0x10,%esp
}
80103d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d24:	89 d8                	mov    %ebx,%eax
80103d26:	5b                   	pop    %ebx
80103d27:	5e                   	pop    %esi
80103d28:	5f                   	pop    %edi
80103d29:	5d                   	pop    %ebp
80103d2a:	c3                   	ret
80103d2b:	66 90                	xchg   %ax,%ax
80103d2d:	66 90                	xchg   %ax,%ax
80103d2f:	90                   	nop

80103d30 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103d39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103d3c:	68 20 2d 11 80       	push   $0x80112d20
80103d41:	e8 ea 0d 00 00       	call   80104b30 <acquire>
80103d46:	83 c4 10             	add    $0x10,%esp
80103d49:	eb 10                	jmp    80103d5b <allocproc+0x2b>
80103d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d50:	83 c3 7c             	add    $0x7c,%ebx
80103d53:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103d59:	74 75                	je     80103dd0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103d5b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d5e:	85 c0                	test   %eax,%eax
80103d60:	75 ee                	jne    80103d50 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103d62:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103d67:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d6a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d71:	89 43 10             	mov    %eax,0x10(%ebx)
80103d74:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d77:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103d7c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103d82:	e8 49 0d 00 00       	call   80104ad0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103d87:	e8 64 ee ff ff       	call   80102bf0 <kalloc>
80103d8c:	83 c4 10             	add    $0x10,%esp
80103d8f:	89 43 08             	mov    %eax,0x8(%ebx)
80103d92:	85 c0                	test   %eax,%eax
80103d94:	74 53                	je     80103de9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103d96:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103d9c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d9f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103da4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103da7:	c7 40 14 e2 5d 10 80 	movl   $0x80105de2,0x14(%eax)
  p->context = (struct context*)sp;
80103dae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103db1:	6a 14                	push   $0x14
80103db3:	6a 00                	push   $0x0
80103db5:	50                   	push   %eax
80103db6:	e8 75 0e 00 00       	call   80104c30 <memset>
  p->context->eip = (uint)forkret;
80103dbb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103dbe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103dc1:	c7 40 10 00 3e 10 80 	movl   $0x80103e00,0x10(%eax)
}
80103dc8:	89 d8                	mov    %ebx,%eax
80103dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dcd:	c9                   	leave
80103dce:	c3                   	ret
80103dcf:	90                   	nop
  release(&ptable.lock);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103dd3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103dd5:	68 20 2d 11 80       	push   $0x80112d20
80103dda:	e8 f1 0c 00 00       	call   80104ad0 <release>
  return 0;
80103ddf:	83 c4 10             	add    $0x10,%esp
}
80103de2:	89 d8                	mov    %ebx,%eax
80103de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de7:	c9                   	leave
80103de8:	c3                   	ret
    p->state = UNUSED;
80103de9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103df0:	31 db                	xor    %ebx,%ebx
80103df2:	eb ee                	jmp    80103de2 <allocproc+0xb2>
80103df4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dfb:	00 
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e00 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103e06:	68 20 2d 11 80       	push   $0x80112d20
80103e0b:	e8 c0 0c 00 00       	call   80104ad0 <release>

  if (first) {
80103e10:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103e15:	83 c4 10             	add    $0x10,%esp
80103e18:	85 c0                	test   %eax,%eax
80103e1a:	75 04                	jne    80103e20 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e1c:	c9                   	leave
80103e1d:	c3                   	ret
80103e1e:	66 90                	xchg   %ax,%ax
    first = 0;
80103e20:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103e27:	00 00 00 
    iinit(ROOTDEV);
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	6a 01                	push   $0x1
80103e2f:	e8 dc dc ff ff       	call   80101b10 <iinit>
    initlog(ROOTDEV);
80103e34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e3b:	e8 f0 f3 ff ff       	call   80103230 <initlog>
}
80103e40:	83 c4 10             	add    $0x10,%esp
80103e43:	c9                   	leave
80103e44:	c3                   	ret
80103e45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e4c:	00 
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <pinit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e56:	68 56 79 10 80       	push   $0x80107956
80103e5b:	68 20 2d 11 80       	push   $0x80112d20
80103e60:	e8 db 0a 00 00       	call   80104940 <initlock>
}
80103e65:	83 c4 10             	add    $0x10,%esp
80103e68:	c9                   	leave
80103e69:	c3                   	ret
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <mycpu>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e75:	9c                   	pushf
80103e76:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e77:	f6 c4 02             	test   $0x2,%ah
80103e7a:	75 46                	jne    80103ec2 <mycpu+0x52>
  apicid = lapicid();
80103e7c:	e8 df ef ff ff       	call   80102e60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e81:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103e87:	85 f6                	test   %esi,%esi
80103e89:	7e 2a                	jle    80103eb5 <mycpu+0x45>
80103e8b:	31 d2                	xor    %edx,%edx
80103e8d:	eb 08                	jmp    80103e97 <mycpu+0x27>
80103e8f:	90                   	nop
80103e90:	83 c2 01             	add    $0x1,%edx
80103e93:	39 f2                	cmp    %esi,%edx
80103e95:	74 1e                	je     80103eb5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103e97:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e9d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103ea4:	39 c3                	cmp    %eax,%ebx
80103ea6:	75 e8                	jne    80103e90 <mycpu+0x20>
}
80103ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103eab:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103eb1:	5b                   	pop    %ebx
80103eb2:	5e                   	pop    %esi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret
  panic("unknown apicid\n");
80103eb5:	83 ec 0c             	sub    $0xc,%esp
80103eb8:	68 5d 79 10 80       	push   $0x8010795d
80103ebd:	e8 ae c4 ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ec2:	83 ec 0c             	sub    $0xc,%esp
80103ec5:	68 14 7d 10 80       	push   $0x80107d14
80103eca:	e8 a1 c4 ff ff       	call   80100370 <panic>
80103ecf:	90                   	nop

80103ed0 <cpuid>:
cpuid() {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ed6:	e8 95 ff ff ff       	call   80103e70 <mycpu>
}
80103edb:	c9                   	leave
  return mycpu()-cpus;
80103edc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103ee1:	c1 f8 04             	sar    $0x4,%eax
80103ee4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eea:	c3                   	ret
80103eeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ef0 <myproc>:
myproc(void) {
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ef7:	e8 e4 0a 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103efc:	e8 6f ff ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80103f01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f07:	e8 24 0b 00 00       	call   80104a30 <popcli>
}
80103f0c:	89 d8                	mov    %ebx,%eax
80103f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f11:	c9                   	leave
80103f12:	c3                   	ret
80103f13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f1a:	00 
80103f1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103f20 <userinit>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f27:	e8 04 fe ff ff       	call   80103d30 <allocproc>
80103f2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f2e:	a3 54 4c 11 80       	mov    %eax,0x80114c54
  if((p->pgdir = setupkvm()) == 0)
80103f33:	e8 78 34 00 00       	call   801073b0 <setupkvm>
80103f38:	89 43 04             	mov    %eax,0x4(%ebx)
80103f3b:	85 c0                	test   %eax,%eax
80103f3d:	0f 84 bd 00 00 00    	je     80104000 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f43:	83 ec 04             	sub    $0x4,%esp
80103f46:	68 2c 00 00 00       	push   $0x2c
80103f4b:	68 60 b4 10 80       	push   $0x8010b460
80103f50:	50                   	push   %eax
80103f51:	e8 3a 31 00 00       	call   80107090 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f5f:	6a 4c                	push   $0x4c
80103f61:	6a 00                	push   $0x0
80103f63:	ff 73 18             	push   0x18(%ebx)
80103f66:	e8 c5 0c 00 00       	call   80104c30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f73:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f76:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f86:	8b 43 18             	mov    0x18(%ebx),%eax
80103f89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f91:	8b 43 18             	mov    0x18(%ebx),%eax
80103f94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103fa6:	8b 43 18             	mov    0x18(%ebx),%eax
80103fa9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103fb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fbd:	6a 10                	push   $0x10
80103fbf:	68 86 79 10 80       	push   $0x80107986
80103fc4:	50                   	push   %eax
80103fc5:	e8 16 0e 00 00       	call   80104de0 <safestrcpy>
  p->cwd = namei("/");
80103fca:	c7 04 24 8f 79 10 80 	movl   $0x8010798f,(%esp)
80103fd1:	e8 3a e6 ff ff       	call   80102610 <namei>
80103fd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fd9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fe0:	e8 4b 0b 00 00       	call   80104b30 <acquire>
  p->state = RUNNABLE;
80103fe5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ff3:	e8 d8 0a 00 00       	call   80104ad0 <release>
}
80103ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ffb:	83 c4 10             	add    $0x10,%esp
80103ffe:	c9                   	leave
80103fff:	c3                   	ret
    panic("userinit: out of memory?");
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	68 6d 79 10 80       	push   $0x8010796d
80104008:	e8 63 c3 ff ff       	call   80100370 <panic>
8010400d:	8d 76 00             	lea    0x0(%esi),%esi

80104010 <growproc>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104018:	e8 c3 09 00 00       	call   801049e0 <pushcli>
  c = mycpu();
8010401d:	e8 4e fe ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104022:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104028:	e8 03 0a 00 00       	call   80104a30 <popcli>
  sz = curproc->sz;
8010402d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010402f:	85 f6                	test   %esi,%esi
80104031:	7f 1d                	jg     80104050 <growproc+0x40>
  } else if(n < 0){
80104033:	75 3b                	jne    80104070 <growproc+0x60>
  switchuvm(curproc);
80104035:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104038:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010403a:	53                   	push   %ebx
8010403b:	e8 40 2f 00 00       	call   80106f80 <switchuvm>
  return 0;
80104040:	83 c4 10             	add    $0x10,%esp
80104043:	31 c0                	xor    %eax,%eax
}
80104045:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104048:	5b                   	pop    %ebx
80104049:	5e                   	pop    %esi
8010404a:	5d                   	pop    %ebp
8010404b:	c3                   	ret
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	push   0x4(%ebx)
8010405a:	e8 81 31 00 00       	call   801071e0 <allocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 cf                	jne    80104035 <growproc+0x25>
      return -1;
80104066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406b:	eb d8                	jmp    80104045 <growproc+0x35>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104070:	83 ec 04             	sub    $0x4,%esp
80104073:	01 c6                	add    %eax,%esi
80104075:	56                   	push   %esi
80104076:	50                   	push   %eax
80104077:	ff 73 04             	push   0x4(%ebx)
8010407a:	e8 81 32 00 00       	call   80107300 <deallocuvm>
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	85 c0                	test   %eax,%eax
80104084:	75 af                	jne    80104035 <growproc+0x25>
80104086:	eb de                	jmp    80104066 <growproc+0x56>
80104088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010408f:	00 

80104090 <fork>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104099:	e8 42 09 00 00       	call   801049e0 <pushcli>
  c = mycpu();
8010409e:	e8 cd fd ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801040a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a9:	e8 82 09 00 00       	call   80104a30 <popcli>
  if((np = allocproc()) == 0){
801040ae:	e8 7d fc ff ff       	call   80103d30 <allocproc>
801040b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040b6:	85 c0                	test   %eax,%eax
801040b8:	0f 84 d6 00 00 00    	je     80104194 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801040be:	83 ec 08             	sub    $0x8,%esp
801040c1:	ff 33                	push   (%ebx)
801040c3:	89 c7                	mov    %eax,%edi
801040c5:	ff 73 04             	push   0x4(%ebx)
801040c8:	e8 d3 33 00 00       	call   801074a0 <copyuvm>
801040cd:	83 c4 10             	add    $0x10,%esp
801040d0:	89 47 04             	mov    %eax,0x4(%edi)
801040d3:	85 c0                	test   %eax,%eax
801040d5:	0f 84 9a 00 00 00    	je     80104175 <fork+0xe5>
  np->sz = curproc->sz;
801040db:	8b 03                	mov    (%ebx),%eax
801040dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040e0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801040e2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801040e5:	89 c8                	mov    %ecx,%eax
801040e7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801040ea:	b9 13 00 00 00       	mov    $0x13,%ecx
801040ef:	8b 73 18             	mov    0x18(%ebx),%esi
801040f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040f6:	8b 40 18             	mov    0x18(%eax),%eax
801040f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104100:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104104:	85 c0                	test   %eax,%eax
80104106:	74 13                	je     8010411b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	50                   	push   %eax
8010410c:	e8 3f d3 ff ff       	call   80101450 <filedup>
80104111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104114:	83 c4 10             	add    $0x10,%esp
80104117:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010411b:	83 c6 01             	add    $0x1,%esi
8010411e:	83 fe 10             	cmp    $0x10,%esi
80104121:	75 dd                	jne    80104100 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104129:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010412c:	e8 cf db ff ff       	call   80101d00 <idup>
80104131:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104134:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104137:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010413a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010413d:	6a 10                	push   $0x10
8010413f:	53                   	push   %ebx
80104140:	50                   	push   %eax
80104141:	e8 9a 0c 00 00       	call   80104de0 <safestrcpy>
  pid = np->pid;
80104146:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104149:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104150:	e8 db 09 00 00       	call   80104b30 <acquire>
  np->state = RUNNABLE;
80104155:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010415c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104163:	e8 68 09 00 00       	call   80104ad0 <release>
  return pid;
80104168:	83 c4 10             	add    $0x10,%esp
}
8010416b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416e:	89 d8                	mov    %ebx,%eax
80104170:	5b                   	pop    %ebx
80104171:	5e                   	pop    %esi
80104172:	5f                   	pop    %edi
80104173:	5d                   	pop    %ebp
80104174:	c3                   	ret
    kfree(np->kstack);
80104175:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104178:	83 ec 0c             	sub    $0xc,%esp
8010417b:	ff 73 08             	push   0x8(%ebx)
8010417e:	e8 ad e8 ff ff       	call   80102a30 <kfree>
    np->kstack = 0;
80104183:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010418a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010418d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104194:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104199:	eb d0                	jmp    8010416b <fork+0xdb>
8010419b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801041a0 <scheduler>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801041a9:	e8 c2 fc ff ff       	call   80103e70 <mycpu>
  c->proc = 0;
801041ae:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041b5:	00 00 00 
  struct cpu *c = mycpu();
801041b8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801041ba:	8d 78 04             	lea    0x4(%eax),%edi
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801041c0:	fb                   	sti
    acquire(&ptable.lock);
801041c1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801041c9:	68 20 2d 11 80       	push   $0x80112d20
801041ce:	e8 5d 09 00 00       	call   80104b30 <acquire>
801041d3:	83 c4 10             	add    $0x10,%esp
801041d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041dd:	00 
801041de:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801041e0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041e4:	75 33                	jne    80104219 <scheduler+0x79>
      switchuvm(p);
801041e6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801041e9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801041ef:	53                   	push   %ebx
801041f0:	e8 8b 2d 00 00       	call   80106f80 <switchuvm>
      swtch(&(c->scheduler), p->context);
801041f5:	58                   	pop    %eax
801041f6:	5a                   	pop    %edx
801041f7:	ff 73 1c             	push   0x1c(%ebx)
801041fa:	57                   	push   %edi
      p->state = RUNNING;
801041fb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104202:	e8 34 0c 00 00       	call   80104e3b <swtch>
      switchkvm();
80104207:	e8 64 2d 00 00       	call   80106f70 <switchkvm>
      c->proc = 0;
8010420c:	83 c4 10             	add    $0x10,%esp
8010420f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104216:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104219:	83 c3 7c             	add    $0x7c,%ebx
8010421c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104222:	75 bc                	jne    801041e0 <scheduler+0x40>
    release(&ptable.lock);
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 20 2d 11 80       	push   $0x80112d20
8010422c:	e8 9f 08 00 00       	call   80104ad0 <release>
    sti();
80104231:	83 c4 10             	add    $0x10,%esp
80104234:	eb 8a                	jmp    801041c0 <scheduler+0x20>
80104236:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010423d:	00 
8010423e:	66 90                	xchg   %ax,%ax

80104240 <sched>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
  pushcli();
80104245:	e8 96 07 00 00       	call   801049e0 <pushcli>
  c = mycpu();
8010424a:	e8 21 fc ff ff       	call   80103e70 <mycpu>
  p = c->proc;
8010424f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104255:	e8 d6 07 00 00       	call   80104a30 <popcli>
  if(!holding(&ptable.lock))
8010425a:	83 ec 0c             	sub    $0xc,%esp
8010425d:	68 20 2d 11 80       	push   $0x80112d20
80104262:	e8 29 08 00 00       	call   80104a90 <holding>
80104267:	83 c4 10             	add    $0x10,%esp
8010426a:	85 c0                	test   %eax,%eax
8010426c:	74 4f                	je     801042bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010426e:	e8 fd fb ff ff       	call   80103e70 <mycpu>
80104273:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010427a:	75 68                	jne    801042e4 <sched+0xa4>
  if(p->state == RUNNING)
8010427c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104280:	74 55                	je     801042d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104282:	9c                   	pushf
80104283:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104284:	f6 c4 02             	test   $0x2,%ah
80104287:	75 41                	jne    801042ca <sched+0x8a>
  intena = mycpu()->intena;
80104289:	e8 e2 fb ff ff       	call   80103e70 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010428e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104291:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104297:	e8 d4 fb ff ff       	call   80103e70 <mycpu>
8010429c:	83 ec 08             	sub    $0x8,%esp
8010429f:	ff 70 04             	push   0x4(%eax)
801042a2:	53                   	push   %ebx
801042a3:	e8 93 0b 00 00       	call   80104e3b <swtch>
  mycpu()->intena = intena;
801042a8:	e8 c3 fb ff ff       	call   80103e70 <mycpu>
}
801042ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b9:	5b                   	pop    %ebx
801042ba:	5e                   	pop    %esi
801042bb:	5d                   	pop    %ebp
801042bc:	c3                   	ret
    panic("sched ptable.lock");
801042bd:	83 ec 0c             	sub    $0xc,%esp
801042c0:	68 91 79 10 80       	push   $0x80107991
801042c5:	e8 a6 c0 ff ff       	call   80100370 <panic>
    panic("sched interruptible");
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 bd 79 10 80       	push   $0x801079bd
801042d2:	e8 99 c0 ff ff       	call   80100370 <panic>
    panic("sched running");
801042d7:	83 ec 0c             	sub    $0xc,%esp
801042da:	68 af 79 10 80       	push   $0x801079af
801042df:	e8 8c c0 ff ff       	call   80100370 <panic>
    panic("sched locks");
801042e4:	83 ec 0c             	sub    $0xc,%esp
801042e7:	68 a3 79 10 80       	push   $0x801079a3
801042ec:	e8 7f c0 ff ff       	call   80100370 <panic>
801042f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042f8:	00 
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104300 <exit>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104309:	e8 e2 fb ff ff       	call   80103ef0 <myproc>
  if(curproc == initproc)
8010430e:	39 05 54 4c 11 80    	cmp    %eax,0x80114c54
80104314:	0f 84 fd 00 00 00    	je     80104417 <exit+0x117>
8010431a:	89 c3                	mov    %eax,%ebx
8010431c:	8d 70 28             	lea    0x28(%eax),%esi
8010431f:	8d 78 68             	lea    0x68(%eax),%edi
80104322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104328:	8b 06                	mov    (%esi),%eax
8010432a:	85 c0                	test   %eax,%eax
8010432c:	74 12                	je     80104340 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010432e:	83 ec 0c             	sub    $0xc,%esp
80104331:	50                   	push   %eax
80104332:	e8 69 d1 ff ff       	call   801014a0 <fileclose>
      curproc->ofile[fd] = 0;
80104337:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010433d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104340:	83 c6 04             	add    $0x4,%esi
80104343:	39 f7                	cmp    %esi,%edi
80104345:	75 e1                	jne    80104328 <exit+0x28>
  begin_op();
80104347:	e8 84 ef ff ff       	call   801032d0 <begin_op>
  iput(curproc->cwd);
8010434c:	83 ec 0c             	sub    $0xc,%esp
8010434f:	ff 73 68             	push   0x68(%ebx)
80104352:	e8 09 db ff ff       	call   80101e60 <iput>
  end_op();
80104357:	e8 e4 ef ff ff       	call   80103340 <end_op>
  curproc->cwd = 0;
8010435c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104363:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010436a:	e8 c1 07 00 00       	call   80104b30 <acquire>
  wakeup1(curproc->parent);
8010436f:	8b 53 14             	mov    0x14(%ebx),%edx
80104372:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104375:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010437a:	eb 0e                	jmp    8010438a <exit+0x8a>
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104380:	83 c0 7c             	add    $0x7c,%eax
80104383:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104388:	74 1c                	je     801043a6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010438a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010438e:	75 f0                	jne    80104380 <exit+0x80>
80104390:	3b 50 20             	cmp    0x20(%eax),%edx
80104393:	75 eb                	jne    80104380 <exit+0x80>
      p->state = RUNNABLE;
80104395:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439c:	83 c0 7c             	add    $0x7c,%eax
8010439f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801043a4:	75 e4                	jne    8010438a <exit+0x8a>
      p->parent = initproc;
801043a6:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ac:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801043b1:	eb 10                	jmp    801043c3 <exit+0xc3>
801043b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801043b8:	83 c2 7c             	add    $0x7c,%edx
801043bb:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
801043c1:	74 3b                	je     801043fe <exit+0xfe>
    if(p->parent == curproc){
801043c3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801043c6:	75 f0                	jne    801043b8 <exit+0xb8>
      if(p->state == ZOMBIE)
801043c8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043cc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043cf:	75 e7                	jne    801043b8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043d6:	eb 12                	jmp    801043ea <exit+0xea>
801043d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043df:	00 
801043e0:	83 c0 7c             	add    $0x7c,%eax
801043e3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801043e8:	74 ce                	je     801043b8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
801043ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043ee:	75 f0                	jne    801043e0 <exit+0xe0>
801043f0:	3b 48 20             	cmp    0x20(%eax),%ecx
801043f3:	75 eb                	jne    801043e0 <exit+0xe0>
      p->state = RUNNABLE;
801043f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043fc:	eb e2                	jmp    801043e0 <exit+0xe0>
  curproc->state = ZOMBIE;
801043fe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104405:	e8 36 fe ff ff       	call   80104240 <sched>
  panic("zombie exit");
8010440a:	83 ec 0c             	sub    $0xc,%esp
8010440d:	68 de 79 10 80       	push   $0x801079de
80104412:	e8 59 bf ff ff       	call   80100370 <panic>
    panic("init exiting");
80104417:	83 ec 0c             	sub    $0xc,%esp
8010441a:	68 d1 79 10 80       	push   $0x801079d1
8010441f:	e8 4c bf ff ff       	call   80100370 <panic>
80104424:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010442b:	00 
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104430 <wait>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
  pushcli();
80104435:	e8 a6 05 00 00       	call   801049e0 <pushcli>
  c = mycpu();
8010443a:	e8 31 fa ff ff       	call   80103e70 <mycpu>
  p = c->proc;
8010443f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104445:	e8 e6 05 00 00       	call   80104a30 <popcli>
  acquire(&ptable.lock);
8010444a:	83 ec 0c             	sub    $0xc,%esp
8010444d:	68 20 2d 11 80       	push   $0x80112d20
80104452:	e8 d9 06 00 00       	call   80104b30 <acquire>
80104457:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010445a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104461:	eb 10                	jmp    80104473 <wait+0x43>
80104463:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104468:	83 c3 7c             	add    $0x7c,%ebx
8010446b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80104471:	74 1b                	je     8010448e <wait+0x5e>
      if(p->parent != curproc)
80104473:	39 73 14             	cmp    %esi,0x14(%ebx)
80104476:	75 f0                	jne    80104468 <wait+0x38>
      if(p->state == ZOMBIE){
80104478:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010447c:	74 62                	je     801044e0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010447e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104481:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104486:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010448c:	75 e5                	jne    80104473 <wait+0x43>
    if(!havekids || curproc->killed){
8010448e:	85 c0                	test   %eax,%eax
80104490:	0f 84 a0 00 00 00    	je     80104536 <wait+0x106>
80104496:	8b 46 24             	mov    0x24(%esi),%eax
80104499:	85 c0                	test   %eax,%eax
8010449b:	0f 85 95 00 00 00    	jne    80104536 <wait+0x106>
  pushcli();
801044a1:	e8 3a 05 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801044a6:	e8 c5 f9 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801044ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044b1:	e8 7a 05 00 00       	call   80104a30 <popcli>
  if(p == 0)
801044b6:	85 db                	test   %ebx,%ebx
801044b8:	0f 84 8f 00 00 00    	je     8010454d <wait+0x11d>
  p->chan = chan;
801044be:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801044c1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044c8:	e8 73 fd ff ff       	call   80104240 <sched>
  p->chan = 0;
801044cd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044d4:	eb 84                	jmp    8010445a <wait+0x2a>
801044d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044dd:	00 
801044de:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801044e0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801044e3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044e6:	ff 73 08             	push   0x8(%ebx)
801044e9:	e8 42 e5 ff ff       	call   80102a30 <kfree>
        p->kstack = 0;
801044ee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044f5:	5a                   	pop    %edx
801044f6:	ff 73 04             	push   0x4(%ebx)
801044f9:	e8 32 2e 00 00       	call   80107330 <freevm>
        p->pid = 0;
801044fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104505:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010450c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104510:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104517:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010451e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104525:	e8 a6 05 00 00       	call   80104ad0 <release>
        return pid;
8010452a:	83 c4 10             	add    $0x10,%esp
}
8010452d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104530:	89 f0                	mov    %esi,%eax
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	5d                   	pop    %ebp
80104535:	c3                   	ret
      release(&ptable.lock);
80104536:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104539:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010453e:	68 20 2d 11 80       	push   $0x80112d20
80104543:	e8 88 05 00 00       	call   80104ad0 <release>
      return -1;
80104548:	83 c4 10             	add    $0x10,%esp
8010454b:	eb e0                	jmp    8010452d <wait+0xfd>
    panic("sleep");
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	68 ea 79 10 80       	push   $0x801079ea
80104555:	e8 16 be ff ff       	call   80100370 <panic>
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104560 <yield>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104567:	68 20 2d 11 80       	push   $0x80112d20
8010456c:	e8 bf 05 00 00       	call   80104b30 <acquire>
  pushcli();
80104571:	e8 6a 04 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80104576:	e8 f5 f8 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
8010457b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104581:	e8 aa 04 00 00       	call   80104a30 <popcli>
  myproc()->state = RUNNABLE;
80104586:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010458d:	e8 ae fc ff ff       	call   80104240 <sched>
  release(&ptable.lock);
80104592:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104599:	e8 32 05 00 00       	call   80104ad0 <release>
}
8010459e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a1:	83 c4 10             	add    $0x10,%esp
801045a4:	c9                   	leave
801045a5:	c3                   	ret
801045a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ad:	00 
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <sleep>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	56                   	push   %esi
801045b5:	53                   	push   %ebx
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045bf:	e8 1c 04 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801045c4:	e8 a7 f8 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801045c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045cf:	e8 5c 04 00 00       	call   80104a30 <popcli>
  if(p == 0)
801045d4:	85 db                	test   %ebx,%ebx
801045d6:	0f 84 87 00 00 00    	je     80104663 <sleep+0xb3>
  if(lk == 0)
801045dc:	85 f6                	test   %esi,%esi
801045de:	74 76                	je     80104656 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045e0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801045e6:	74 50                	je     80104638 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045e8:	83 ec 0c             	sub    $0xc,%esp
801045eb:	68 20 2d 11 80       	push   $0x80112d20
801045f0:	e8 3b 05 00 00       	call   80104b30 <acquire>
    release(lk);
801045f5:	89 34 24             	mov    %esi,(%esp)
801045f8:	e8 d3 04 00 00       	call   80104ad0 <release>
  p->chan = chan;
801045fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104600:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104607:	e8 34 fc ff ff       	call   80104240 <sched>
  p->chan = 0;
8010460c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104613:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010461a:	e8 b1 04 00 00       	call   80104ad0 <release>
    acquire(lk);
8010461f:	83 c4 10             	add    $0x10,%esp
80104622:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104625:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5f                   	pop    %edi
8010462b:	5d                   	pop    %ebp
    acquire(lk);
8010462c:	e9 ff 04 00 00       	jmp    80104b30 <acquire>
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104638:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010463b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104642:	e8 f9 fb ff ff       	call   80104240 <sched>
  p->chan = 0;
80104647:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010464e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104651:	5b                   	pop    %ebx
80104652:	5e                   	pop    %esi
80104653:	5f                   	pop    %edi
80104654:	5d                   	pop    %ebp
80104655:	c3                   	ret
    panic("sleep without lk");
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 f0 79 10 80       	push   $0x801079f0
8010465e:	e8 0d bd ff ff       	call   80100370 <panic>
    panic("sleep");
80104663:	83 ec 0c             	sub    $0xc,%esp
80104666:	68 ea 79 10 80       	push   $0x801079ea
8010466b:	e8 00 bd ff ff       	call   80100370 <panic>

80104670 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 10             	sub    $0x10,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010467a:	68 20 2d 11 80       	push   $0x80112d20
8010467f:	e8 ac 04 00 00       	call   80104b30 <acquire>
80104684:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104687:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010468c:	eb 0c                	jmp    8010469a <wakeup+0x2a>
8010468e:	66 90                	xchg   %ax,%ax
80104690:	83 c0 7c             	add    $0x7c,%eax
80104693:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104698:	74 1c                	je     801046b6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010469a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010469e:	75 f0                	jne    80104690 <wakeup+0x20>
801046a0:	3b 58 20             	cmp    0x20(%eax),%ebx
801046a3:	75 eb                	jne    80104690 <wakeup+0x20>
      p->state = RUNNABLE;
801046a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ac:	83 c0 7c             	add    $0x7c,%eax
801046af:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801046b4:	75 e4                	jne    8010469a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801046b6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801046bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c0:	c9                   	leave
  release(&ptable.lock);
801046c1:	e9 0a 04 00 00       	jmp    80104ad0 <release>
801046c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046cd:	00 
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 10             	sub    $0x10,%esp
801046d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801046da:	68 20 2d 11 80       	push   $0x80112d20
801046df:	e8 4c 04 00 00       	call   80104b30 <acquire>
801046e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801046ec:	eb 0c                	jmp    801046fa <kill+0x2a>
801046ee:	66 90                	xchg   %ax,%ax
801046f0:	83 c0 7c             	add    $0x7c,%eax
801046f3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801046f8:	74 36                	je     80104730 <kill+0x60>
    if(p->pid == pid){
801046fa:	39 58 10             	cmp    %ebx,0x10(%eax)
801046fd:	75 f1                	jne    801046f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046ff:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104703:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010470a:	75 07                	jne    80104713 <kill+0x43>
        p->state = RUNNABLE;
8010470c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104713:	83 ec 0c             	sub    $0xc,%esp
80104716:	68 20 2d 11 80       	push   $0x80112d20
8010471b:	e8 b0 03 00 00       	call   80104ad0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104723:	83 c4 10             	add    $0x10,%esp
80104726:	31 c0                	xor    %eax,%eax
}
80104728:	c9                   	leave
80104729:	c3                   	ret
8010472a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	68 20 2d 11 80       	push   $0x80112d20
80104738:	e8 93 03 00 00       	call   80104ad0 <release>
}
8010473d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104740:	83 c4 10             	add    $0x10,%esp
80104743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104748:	c9                   	leave
80104749:	c3                   	ret
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104758:	53                   	push   %ebx
80104759:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010475e:	83 ec 3c             	sub    $0x3c,%esp
80104761:	eb 24                	jmp    80104787 <procdump+0x37>
80104763:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	68 af 7b 10 80       	push   $0x80107baf
80104770:	e8 eb bf ff ff       	call   80100760 <cprintf>
80104775:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104778:	83 c3 7c             	add    $0x7c,%ebx
8010477b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104781:	0f 84 81 00 00 00    	je     80104808 <procdump+0xb8>
    if(p->state == UNUSED)
80104787:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010478a:	85 c0                	test   %eax,%eax
8010478c:	74 ea                	je     80104778 <procdump+0x28>
      state = "???";
8010478e:	ba 01 7a 10 80       	mov    $0x80107a01,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104793:	83 f8 05             	cmp    $0x5,%eax
80104796:	77 11                	ja     801047a9 <procdump+0x59>
80104798:	8b 14 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%edx
      state = "???";
8010479f:	b8 01 7a 10 80       	mov    $0x80107a01,%eax
801047a4:	85 d2                	test   %edx,%edx
801047a6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047a9:	53                   	push   %ebx
801047aa:	52                   	push   %edx
801047ab:	ff 73 a4             	push   -0x5c(%ebx)
801047ae:	68 05 7a 10 80       	push   $0x80107a05
801047b3:	e8 a8 bf ff ff       	call   80100760 <cprintf>
    if(p->state == SLEEPING){
801047b8:	83 c4 10             	add    $0x10,%esp
801047bb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801047bf:	75 a7                	jne    80104768 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801047c1:	83 ec 08             	sub    $0x8,%esp
801047c4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047c7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047ca:	50                   	push   %eax
801047cb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801047ce:	8b 40 0c             	mov    0xc(%eax),%eax
801047d1:	83 c0 08             	add    $0x8,%eax
801047d4:	50                   	push   %eax
801047d5:	e8 86 01 00 00       	call   80104960 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801047da:	83 c4 10             	add    $0x10,%esp
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
801047e0:	8b 17                	mov    (%edi),%edx
801047e2:	85 d2                	test   %edx,%edx
801047e4:	74 82                	je     80104768 <procdump+0x18>
        cprintf(" %p", pc[i]);
801047e6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801047e9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801047ec:	52                   	push   %edx
801047ed:	68 41 77 10 80       	push   $0x80107741
801047f2:	e8 69 bf ff ff       	call   80100760 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047f7:	83 c4 10             	add    $0x10,%esp
801047fa:	39 f7                	cmp    %esi,%edi
801047fc:	75 e2                	jne    801047e0 <procdump+0x90>
801047fe:	e9 65 ff ff ff       	jmp    80104768 <procdump+0x18>
80104803:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104808:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480b:	5b                   	pop    %ebx
8010480c:	5e                   	pop    %esi
8010480d:	5f                   	pop    %edi
8010480e:	5d                   	pop    %ebp
8010480f:	c3                   	ret

80104810 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010481a:	68 38 7a 10 80       	push   $0x80107a38
8010481f:	8d 43 04             	lea    0x4(%ebx),%eax
80104822:	50                   	push   %eax
80104823:	e8 18 01 00 00       	call   80104940 <initlock>
  lk->name = name;
80104828:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010482b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104831:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104834:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010483b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	c9                   	leave
80104842:	c3                   	ret
80104843:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010484a:	00 
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104850 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104858:	8d 73 04             	lea    0x4(%ebx),%esi
8010485b:	83 ec 0c             	sub    $0xc,%esp
8010485e:	56                   	push   %esi
8010485f:	e8 cc 02 00 00       	call   80104b30 <acquire>
  while (lk->locked) {
80104864:	8b 13                	mov    (%ebx),%edx
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 d2                	test   %edx,%edx
8010486b:	74 16                	je     80104883 <acquiresleep+0x33>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	e8 36 fd ff ff       	call   801045b0 <sleep>
  while (lk->locked) {
8010487a:	8b 03                	mov    (%ebx),%eax
8010487c:	83 c4 10             	add    $0x10,%esp
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 ed                	jne    80104870 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104883:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104889:	e8 62 f6 ff ff       	call   80103ef0 <myproc>
8010488e:	8b 40 10             	mov    0x10(%eax),%eax
80104891:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104894:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104897:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
  release(&lk->lk);
8010489d:	e9 2e 02 00 00       	jmp    80104ad0 <release>
801048a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048a9:	00 
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048b8:	8d 73 04             	lea    0x4(%ebx),%esi
801048bb:	83 ec 0c             	sub    $0xc,%esp
801048be:	56                   	push   %esi
801048bf:	e8 6c 02 00 00       	call   80104b30 <acquire>
  lk->locked = 0;
801048c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048d1:	89 1c 24             	mov    %ebx,(%esp)
801048d4:	e8 97 fd ff ff       	call   80104670 <wakeup>
  release(&lk->lk);
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
  release(&lk->lk);
801048e5:	e9 e6 01 00 00       	jmp    80104ad0 <release>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	31 ff                	xor    %edi,%edi
801048f6:	56                   	push   %esi
801048f7:	53                   	push   %ebx
801048f8:	83 ec 18             	sub    $0x18,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104901:	56                   	push   %esi
80104902:	e8 29 02 00 00       	call   80104b30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104907:	8b 03                	mov    (%ebx),%eax
80104909:	83 c4 10             	add    $0x10,%esp
8010490c:	85 c0                	test   %eax,%eax
8010490e:	75 18                	jne    80104928 <holdingsleep+0x38>
  release(&lk->lk);
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	56                   	push   %esi
80104914:	e8 b7 01 00 00       	call   80104ad0 <release>
  return r;
}
80104919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010491c:	89 f8                	mov    %edi,%eax
8010491e:	5b                   	pop    %ebx
8010491f:	5e                   	pop    %esi
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret
80104923:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104928:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010492b:	e8 c0 f5 ff ff       	call   80103ef0 <myproc>
80104930:	39 58 10             	cmp    %ebx,0x10(%eax)
80104933:	0f 94 c0             	sete   %al
80104936:	0f b6 c0             	movzbl %al,%eax
80104939:	89 c7                	mov    %eax,%edi
8010493b:	eb d3                	jmp    80104910 <holdingsleep+0x20>
8010493d:	66 90                	xchg   %ax,%ax
8010493f:	90                   	nop

80104940 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104946:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010494f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104960 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	8b 45 08             	mov    0x8(%ebp),%eax
80104967:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010496a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010496d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104972:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104977:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010497c:	76 10                	jbe    8010498e <getcallerpcs+0x2e>
8010497e:	eb 28                	jmp    801049a8 <getcallerpcs+0x48>
80104980:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104986:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010498c:	77 1a                	ja     801049a8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010498e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104991:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104994:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104997:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104999:	83 f8 0a             	cmp    $0xa,%eax
8010499c:	75 e2                	jne    80104980 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010499e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a1:	c9                   	leave
801049a2:	c3                   	ret
801049a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049a8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801049ab:	83 c1 28             	add    $0x28,%ecx
801049ae:	89 ca                	mov    %ecx,%edx
801049b0:	29 c2                	sub    %eax,%edx
801049b2:	83 e2 04             	and    $0x4,%edx
801049b5:	74 11                	je     801049c8 <getcallerpcs+0x68>
    pcs[i] = 0;
801049b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049bd:	83 c0 04             	add    $0x4,%eax
801049c0:	39 c1                	cmp    %eax,%ecx
801049c2:	74 da                	je     8010499e <getcallerpcs+0x3e>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801049c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049ce:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801049d1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801049d8:	39 c1                	cmp    %eax,%ecx
801049da:	75 ec                	jne    801049c8 <getcallerpcs+0x68>
801049dc:	eb c0                	jmp    8010499e <getcallerpcs+0x3e>
801049de:	66 90                	xchg   %ax,%ax

801049e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	9c                   	pushf
801049e8:	5b                   	pop    %ebx
  asm volatile("cli");
801049e9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ea:	e8 81 f4 ff ff       	call   80103e70 <mycpu>
801049ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049f5:	85 c0                	test   %eax,%eax
801049f7:	74 17                	je     80104a10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049f9:	e8 72 f4 ff ff       	call   80103e70 <mycpu>
801049fe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a08:	c9                   	leave
80104a09:	c3                   	ret
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104a10:	e8 5b f4 ff ff       	call   80103e70 <mycpu>
80104a15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a21:	eb d6                	jmp    801049f9 <pushcli+0x19>
80104a23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a2a:	00 
80104a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a30 <popcli>:

void
popcli(void)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a36:	9c                   	pushf
80104a37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a38:	f6 c4 02             	test   $0x2,%ah
80104a3b:	75 35                	jne    80104a72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a3d:	e8 2e f4 ff ff       	call   80103e70 <mycpu>
80104a42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a49:	78 34                	js     80104a7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a4b:	e8 20 f4 ff ff       	call   80103e70 <mycpu>
80104a50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a56:	85 d2                	test   %edx,%edx
80104a58:	74 06                	je     80104a60 <popcli+0x30>
    sti();
}
80104a5a:	c9                   	leave
80104a5b:	c3                   	ret
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a60:	e8 0b f4 ff ff       	call   80103e70 <mycpu>
80104a65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	74 eb                	je     80104a5a <popcli+0x2a>
  asm volatile("sti");
80104a6f:	fb                   	sti
}
80104a70:	c9                   	leave
80104a71:	c3                   	ret
    panic("popcli - interruptible");
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 43 7a 10 80       	push   $0x80107a43
80104a7a:	e8 f1 b8 ff ff       	call   80100370 <panic>
    panic("popcli");
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	68 5a 7a 10 80       	push   $0x80107a5a
80104a87:	e8 e4 b8 ff ff       	call   80100370 <panic>
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <holding>:
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 75 08             	mov    0x8(%ebp),%esi
80104a98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a9a:	e8 41 ff ff ff       	call   801049e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a9f:	8b 06                	mov    (%esi),%eax
80104aa1:	85 c0                	test   %eax,%eax
80104aa3:	75 0b                	jne    80104ab0 <holding+0x20>
  popcli();
80104aa5:	e8 86 ff ff ff       	call   80104a30 <popcli>
}
80104aaa:	89 d8                	mov    %ebx,%eax
80104aac:	5b                   	pop    %ebx
80104aad:	5e                   	pop    %esi
80104aae:	5d                   	pop    %ebp
80104aaf:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104ab0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ab3:	e8 b8 f3 ff ff       	call   80103e70 <mycpu>
80104ab8:	39 c3                	cmp    %eax,%ebx
80104aba:	0f 94 c3             	sete   %bl
  popcli();
80104abd:	e8 6e ff ff ff       	call   80104a30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104ac2:	0f b6 db             	movzbl %bl,%ebx
}
80104ac5:	89 d8                	mov    %ebx,%eax
80104ac7:	5b                   	pop    %ebx
80104ac8:	5e                   	pop    %esi
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret
80104acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104ad0 <release>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104ad8:	e8 03 ff ff ff       	call   801049e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104add:	8b 03                	mov    (%ebx),%eax
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	75 15                	jne    80104af8 <release+0x28>
  popcli();
80104ae3:	e8 48 ff ff ff       	call   80104a30 <popcli>
    panic("release");
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	68 61 7a 10 80       	push   $0x80107a61
80104af0:	e8 7b b8 ff ff       	call   80100370 <panic>
80104af5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104af8:	8b 73 08             	mov    0x8(%ebx),%esi
80104afb:	e8 70 f3 ff ff       	call   80103e70 <mycpu>
80104b00:	39 c6                	cmp    %eax,%esi
80104b02:	75 df                	jne    80104ae3 <release+0x13>
  popcli();
80104b04:	e8 27 ff ff ff       	call   80104a30 <popcli>
  lk->pcs[0] = 0;
80104b09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b10:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b17:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
  popcli();
80104b28:	e9 03 ff ff ff       	jmp    80104a30 <popcli>
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi

80104b30 <acquire>:
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104b37:	e8 a4 fe ff ff       	call   801049e0 <pushcli>
  if(holding(lk))
80104b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104b3f:	e8 9c fe ff ff       	call   801049e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b44:	8b 03                	mov    (%ebx),%eax
80104b46:	85 c0                	test   %eax,%eax
80104b48:	0f 85 b2 00 00 00    	jne    80104c00 <acquire+0xd0>
  popcli();
80104b4e:	e8 dd fe ff ff       	call   80104a30 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104b53:	b9 01 00 00 00       	mov    $0x1,%ecx
80104b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104b60:	8b 55 08             	mov    0x8(%ebp),%edx
80104b63:	89 c8                	mov    %ecx,%eax
80104b65:	f0 87 02             	lock xchg %eax,(%edx)
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	75 f4                	jne    80104b60 <acquire+0x30>
  __sync_synchronize();
80104b6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b74:	e8 f7 f2 ff ff       	call   80103e70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104b7c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104b7e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b81:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104b87:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104b8c:	77 32                	ja     80104bc0 <acquire+0x90>
  ebp = (uint*)v - 2;
80104b8e:	89 e8                	mov    %ebp,%eax
80104b90:	eb 14                	jmp    80104ba6 <acquire+0x76>
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b98:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ba4:	77 1a                	ja     80104bc0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104ba6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ba9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bad:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bb0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bb2:	83 fa 0a             	cmp    $0xa,%edx
80104bb5:	75 e1                	jne    80104b98 <acquire+0x68>
}
80104bb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bba:	c9                   	leave
80104bbb:	c3                   	ret
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104bc4:	83 c1 34             	add    $0x34,%ecx
80104bc7:	89 ca                	mov    %ecx,%edx
80104bc9:	29 c2                	sub    %eax,%edx
80104bcb:	83 e2 04             	and    $0x4,%edx
80104bce:	74 10                	je     80104be0 <acquire+0xb0>
    pcs[i] = 0;
80104bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104bd6:	83 c0 04             	add    $0x4,%eax
80104bd9:	39 c1                	cmp    %eax,%ecx
80104bdb:	74 da                	je     80104bb7 <acquire+0x87>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104be6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104be9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104bf0:	39 c1                	cmp    %eax,%ecx
80104bf2:	75 ec                	jne    80104be0 <acquire+0xb0>
80104bf4:	eb c1                	jmp    80104bb7 <acquire+0x87>
80104bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bfd:	00 
80104bfe:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104c00:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104c03:	e8 68 f2 ff ff       	call   80103e70 <mycpu>
80104c08:	39 c3                	cmp    %eax,%ebx
80104c0a:	0f 85 3e ff ff ff    	jne    80104b4e <acquire+0x1e>
  popcli();
80104c10:	e8 1b fe ff ff       	call   80104a30 <popcli>
    panic("acquire");
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	68 69 7a 10 80       	push   $0x80107a69
80104c1d:	e8 4e b7 ff ff       	call   80100370 <panic>
80104c22:	66 90                	xchg   %ax,%ax
80104c24:	66 90                	xchg   %ax,%ax
80104c26:	66 90                	xchg   %ax,%ax
80104c28:	66 90                	xchg   %ax,%ax
80104c2a:	66 90                	xchg   %ax,%ax
80104c2c:	66 90                	xchg   %ax,%ax
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	8b 55 08             	mov    0x8(%ebp),%edx
80104c37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c3a:	89 d0                	mov    %edx,%eax
80104c3c:	09 c8                	or     %ecx,%eax
80104c3e:	a8 03                	test   $0x3,%al
80104c40:	75 1e                	jne    80104c60 <memset+0x30>
    c &= 0xFF;
80104c42:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c46:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104c49:	89 d7                	mov    %edx,%edi
80104c4b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104c51:	fc                   	cld
80104c52:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c54:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c57:	89 d0                	mov    %edx,%eax
80104c59:	c9                   	leave
80104c5a:	c3                   	ret
80104c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104c60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c63:	89 d7                	mov    %edx,%edi
80104c65:	fc                   	cld
80104c66:	f3 aa                	rep stos %al,%es:(%edi)
80104c68:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104c6b:	89 d0                	mov    %edx,%eax
80104c6d:	c9                   	leave
80104c6e:	c3                   	ret
80104c6f:	90                   	nop

80104c70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	8b 75 10             	mov    0x10(%ebp),%esi
80104c77:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7a:	53                   	push   %ebx
80104c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c7e:	85 f6                	test   %esi,%esi
80104c80:	74 2e                	je     80104cb0 <memcmp+0x40>
80104c82:	01 c6                	add    %eax,%esi
80104c84:	eb 14                	jmp    80104c9a <memcmp+0x2a>
80104c86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c8d:	00 
80104c8e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c90:	83 c0 01             	add    $0x1,%eax
80104c93:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c96:	39 f0                	cmp    %esi,%eax
80104c98:	74 16                	je     80104cb0 <memcmp+0x40>
    if(*s1 != *s2)
80104c9a:	0f b6 08             	movzbl (%eax),%ecx
80104c9d:	0f b6 1a             	movzbl (%edx),%ebx
80104ca0:	38 d9                	cmp    %bl,%cl
80104ca2:	74 ec                	je     80104c90 <memcmp+0x20>
      return *s1 - *s2;
80104ca4:	0f b6 c1             	movzbl %cl,%eax
80104ca7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ca9:	5b                   	pop    %ebx
80104caa:	5e                   	pop    %esi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	5b                   	pop    %ebx
  return 0;
80104cb1:	31 c0                	xor    %eax,%eax
}
80104cb3:	5e                   	pop    %esi
80104cb4:	5d                   	pop    %ebp
80104cb5:	c3                   	ret
80104cb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cbd:	00 
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80104cca:	56                   	push   %esi
80104ccb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cce:	39 d6                	cmp    %edx,%esi
80104cd0:	73 26                	jae    80104cf8 <memmove+0x38>
80104cd2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104cd5:	39 ca                	cmp    %ecx,%edx
80104cd7:	73 1f                	jae    80104cf8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104cd9:	85 c0                	test   %eax,%eax
80104cdb:	74 0f                	je     80104cec <memmove+0x2c>
80104cdd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104ce0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ce4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104ce7:	83 e8 01             	sub    $0x1,%eax
80104cea:	73 f4                	jae    80104ce0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cec:	5e                   	pop    %esi
80104ced:	89 d0                	mov    %edx,%eax
80104cef:	5f                   	pop    %edi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104cf8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104cfb:	89 d7                	mov    %edx,%edi
80104cfd:	85 c0                	test   %eax,%eax
80104cff:	74 eb                	je     80104cec <memmove+0x2c>
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104d08:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104d09:	39 ce                	cmp    %ecx,%esi
80104d0b:	75 fb                	jne    80104d08 <memmove+0x48>
}
80104d0d:	5e                   	pop    %esi
80104d0e:	89 d0                	mov    %edx,%eax
80104d10:	5f                   	pop    %edi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret
80104d13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d1a:	00 
80104d1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104d20 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104d20:	eb 9e                	jmp    80104cc0 <memmove>
80104d22:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d29:	00 
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	8b 55 10             	mov    0x10(%ebp),%edx
80104d37:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104d3d:	85 d2                	test   %edx,%edx
80104d3f:	75 16                	jne    80104d57 <strncmp+0x27>
80104d41:	eb 2d                	jmp    80104d70 <strncmp+0x40>
80104d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d48:	3a 19                	cmp    (%ecx),%bl
80104d4a:	75 12                	jne    80104d5e <strncmp+0x2e>
    n--, p++, q++;
80104d4c:	83 c0 01             	add    $0x1,%eax
80104d4f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d52:	83 ea 01             	sub    $0x1,%edx
80104d55:	74 19                	je     80104d70 <strncmp+0x40>
80104d57:	0f b6 18             	movzbl (%eax),%ebx
80104d5a:	84 db                	test   %bl,%bl
80104d5c:	75 ea                	jne    80104d48 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d5e:	0f b6 00             	movzbl (%eax),%eax
80104d61:	0f b6 11             	movzbl (%ecx),%edx
}
80104d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d67:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104d68:	29 d0                	sub    %edx,%eax
}
80104d6a:	c3                   	ret
80104d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104d73:	31 c0                	xor    %eax,%eax
}
80104d75:	c9                   	leave
80104d76:	c3                   	ret
80104d77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d7e:	00 
80104d7f:	90                   	nop

80104d80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	8b 75 08             	mov    0x8(%ebp),%esi
80104d88:	53                   	push   %ebx
80104d89:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d8c:	89 f0                	mov    %esi,%eax
80104d8e:	eb 15                	jmp    80104da5 <strncpy+0x25>
80104d90:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d94:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d97:	83 c0 01             	add    $0x1,%eax
80104d9a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104d9e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104da1:	84 c9                	test   %cl,%cl
80104da3:	74 13                	je     80104db8 <strncpy+0x38>
80104da5:	89 d3                	mov    %edx,%ebx
80104da7:	83 ea 01             	sub    $0x1,%edx
80104daa:	85 db                	test   %ebx,%ebx
80104dac:	7f e2                	jg     80104d90 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104dae:	5b                   	pop    %ebx
80104daf:	89 f0                	mov    %esi,%eax
80104db1:	5e                   	pop    %esi
80104db2:	5f                   	pop    %edi
80104db3:	5d                   	pop    %ebp
80104db4:	c3                   	ret
80104db5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104db8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104dbb:	83 e9 01             	sub    $0x1,%ecx
80104dbe:	85 d2                	test   %edx,%edx
80104dc0:	74 ec                	je     80104dae <strncpy+0x2e>
80104dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104dc8:	83 c0 01             	add    $0x1,%eax
80104dcb:	89 ca                	mov    %ecx,%edx
80104dcd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104dd1:	29 c2                	sub    %eax,%edx
80104dd3:	85 d2                	test   %edx,%edx
80104dd5:	7f f1                	jg     80104dc8 <strncpy+0x48>
}
80104dd7:	5b                   	pop    %ebx
80104dd8:	89 f0                	mov    %esi,%eax
80104dda:	5e                   	pop    %esi
80104ddb:	5f                   	pop    %edi
80104ddc:	5d                   	pop    %ebp
80104ddd:	c3                   	ret
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	8b 55 10             	mov    0x10(%ebp),%edx
80104de7:	8b 75 08             	mov    0x8(%ebp),%esi
80104dea:	53                   	push   %ebx
80104deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104dee:	85 d2                	test   %edx,%edx
80104df0:	7e 25                	jle    80104e17 <safestrcpy+0x37>
80104df2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104df6:	89 f2                	mov    %esi,%edx
80104df8:	eb 16                	jmp    80104e10 <safestrcpy+0x30>
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e00:	0f b6 08             	movzbl (%eax),%ecx
80104e03:	83 c0 01             	add    $0x1,%eax
80104e06:	83 c2 01             	add    $0x1,%edx
80104e09:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e0c:	84 c9                	test   %cl,%cl
80104e0e:	74 04                	je     80104e14 <safestrcpy+0x34>
80104e10:	39 d8                	cmp    %ebx,%eax
80104e12:	75 ec                	jne    80104e00 <safestrcpy+0x20>
    ;
  *s = 0;
80104e14:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104e17:	89 f0                	mov    %esi,%eax
80104e19:	5b                   	pop    %ebx
80104e1a:	5e                   	pop    %esi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <strlen>:

int
strlen(const char *s)
{
80104e20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e21:	31 c0                	xor    %eax,%eax
{
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e28:	80 3a 00             	cmpb   $0x0,(%edx)
80104e2b:	74 0c                	je     80104e39 <strlen+0x19>
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
80104e30:	83 c0 01             	add    $0x1,%eax
80104e33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e37:	75 f7                	jne    80104e30 <strlen+0x10>
    ;
  return n;
}
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret

80104e3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e43:	55                   	push   %ebp
  pushl %ebx
80104e44:	53                   	push   %ebx
  pushl %esi
80104e45:	56                   	push   %esi
  pushl %edi
80104e46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e49:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e4b:	5f                   	pop    %edi
  popl %esi
80104e4c:	5e                   	pop    %esi
  popl %ebx
80104e4d:	5b                   	pop    %ebx
  popl %ebp
80104e4e:	5d                   	pop    %ebp
  ret
80104e4f:	c3                   	ret

80104e50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	53                   	push   %ebx
80104e54:	83 ec 04             	sub    $0x4,%esp
80104e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e5a:	e8 91 f0 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e5f:	8b 00                	mov    (%eax),%eax
80104e61:	39 c3                	cmp    %eax,%ebx
80104e63:	73 1b                	jae    80104e80 <fetchint+0x30>
80104e65:	8d 53 04             	lea    0x4(%ebx),%edx
80104e68:	39 d0                	cmp    %edx,%eax
80104e6a:	72 14                	jb     80104e80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6f:	8b 13                	mov    (%ebx),%edx
80104e71:	89 10                	mov    %edx,(%eax)
  return 0;
80104e73:	31 c0                	xor    %eax,%eax
}
80104e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e78:	c9                   	leave
80104e79:	c3                   	ret
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e85:	eb ee                	jmp    80104e75 <fetchint+0x25>
80104e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e8e:	00 
80104e8f:	90                   	nop

80104e90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 04             	sub    $0x4,%esp
80104e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e9a:	e8 51 f0 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz)
80104e9f:	3b 18                	cmp    (%eax),%ebx
80104ea1:	73 2d                	jae    80104ed0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ea6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ea8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104eaa:	39 d3                	cmp    %edx,%ebx
80104eac:	73 22                	jae    80104ed0 <fetchstr+0x40>
80104eae:	89 d8                	mov    %ebx,%eax
80104eb0:	eb 0d                	jmp    80104ebf <fetchstr+0x2f>
80104eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eb8:	83 c0 01             	add    $0x1,%eax
80104ebb:	39 d0                	cmp    %edx,%eax
80104ebd:	73 11                	jae    80104ed0 <fetchstr+0x40>
    if(*s == 0)
80104ebf:	80 38 00             	cmpb   $0x0,(%eax)
80104ec2:	75 f4                	jne    80104eb8 <fetchstr+0x28>
      return s - *pp;
80104ec4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ec6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec9:	c9                   	leave
80104eca:	c3                   	ret
80104ecb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed8:	c9                   	leave
80104ed9:	c3                   	ret
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ee0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ee5:	e8 06 f0 ff ff       	call   80103ef0 <myproc>
80104eea:	8b 55 08             	mov    0x8(%ebp),%edx
80104eed:	8b 40 18             	mov    0x18(%eax),%eax
80104ef0:	8b 40 44             	mov    0x44(%eax),%eax
80104ef3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ef6:	e8 f5 ef ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104efb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104efe:	8b 00                	mov    (%eax),%eax
80104f00:	39 c6                	cmp    %eax,%esi
80104f02:	73 1c                	jae    80104f20 <argint+0x40>
80104f04:	8d 53 08             	lea    0x8(%ebx),%edx
80104f07:	39 d0                	cmp    %edx,%eax
80104f09:	72 15                	jb     80104f20 <argint+0x40>
  *ip = *(int*)(addr);
80104f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f11:	89 10                	mov    %edx,(%eax)
  return 0;
80104f13:	31 c0                	xor    %eax,%eax
}
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f25:	eb ee                	jmp    80104f15 <argint+0x35>
80104f27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f2e:	00 
80104f2f:	90                   	nop

80104f30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	53                   	push   %ebx
80104f36:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104f39:	e8 b2 ef ff ff       	call   80103ef0 <myproc>
80104f3e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f40:	e8 ab ef ff ff       	call   80103ef0 <myproc>
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
80104f48:	8b 40 18             	mov    0x18(%eax),%eax
80104f4b:	8b 40 44             	mov    0x44(%eax),%eax
80104f4e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f51:	e8 9a ef ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f56:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f59:	8b 00                	mov    (%eax),%eax
80104f5b:	39 c7                	cmp    %eax,%edi
80104f5d:	73 31                	jae    80104f90 <argptr+0x60>
80104f5f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104f62:	39 c8                	cmp    %ecx,%eax
80104f64:	72 2a                	jb     80104f90 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f66:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104f69:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f6c:	85 d2                	test   %edx,%edx
80104f6e:	78 20                	js     80104f90 <argptr+0x60>
80104f70:	8b 16                	mov    (%esi),%edx
80104f72:	39 d0                	cmp    %edx,%eax
80104f74:	73 1a                	jae    80104f90 <argptr+0x60>
80104f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f79:	01 c3                	add    %eax,%ebx
80104f7b:	39 da                	cmp    %ebx,%edx
80104f7d:	72 11                	jb     80104f90 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f82:	89 02                	mov    %eax,(%edx)
  return 0;
80104f84:	31 c0                	xor    %eax,%eax
}
80104f86:	83 c4 0c             	add    $0xc,%esp
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5f                   	pop    %edi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret
80104f8e:	66 90                	xchg   %ax,%ax
    return -1;
80104f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f95:	eb ef                	jmp    80104f86 <argptr+0x56>
80104f97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f9e:	00 
80104f9f:	90                   	nop

80104fa0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	e8 46 ef ff ff       	call   80103ef0 <myproc>
80104faa:	8b 55 08             	mov    0x8(%ebp),%edx
80104fad:	8b 40 18             	mov    0x18(%eax),%eax
80104fb0:	8b 40 44             	mov    0x44(%eax),%eax
80104fb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fb6:	e8 35 ef ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fbe:	8b 00                	mov    (%eax),%eax
80104fc0:	39 c6                	cmp    %eax,%esi
80104fc2:	73 44                	jae    80105008 <argstr+0x68>
80104fc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fc7:	39 d0                	cmp    %edx,%eax
80104fc9:	72 3d                	jb     80105008 <argstr+0x68>
  *ip = *(int*)(addr);
80104fcb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104fce:	e8 1d ef ff ff       	call   80103ef0 <myproc>
  if(addr >= curproc->sz)
80104fd3:	3b 18                	cmp    (%eax),%ebx
80104fd5:	73 31                	jae    80105008 <argstr+0x68>
  *pp = (char*)addr;
80104fd7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fda:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104fdc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104fde:	39 d3                	cmp    %edx,%ebx
80104fe0:	73 26                	jae    80105008 <argstr+0x68>
80104fe2:	89 d8                	mov    %ebx,%eax
80104fe4:	eb 11                	jmp    80104ff7 <argstr+0x57>
80104fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fed:	00 
80104fee:	66 90                	xchg   %ax,%ax
80104ff0:	83 c0 01             	add    $0x1,%eax
80104ff3:	39 d0                	cmp    %edx,%eax
80104ff5:	73 11                	jae    80105008 <argstr+0x68>
    if(*s == 0)
80104ff7:	80 38 00             	cmpb   $0x0,(%eax)
80104ffa:	75 f4                	jne    80104ff0 <argstr+0x50>
      return s - *pp;
80104ffc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104ffe:	5b                   	pop    %ebx
80104fff:	5e                   	pop    %esi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105008:	5b                   	pop    %ebx
    return -1;
80105009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010500e:	5e                   	pop    %esi
8010500f:	5d                   	pop    %ebp
80105010:	c3                   	ret
80105011:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105018:	00 
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105020 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105027:	e8 c4 ee ff ff       	call   80103ef0 <myproc>
8010502c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010502e:	8b 40 18             	mov    0x18(%eax),%eax
80105031:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105034:	8d 50 ff             	lea    -0x1(%eax),%edx
80105037:	83 fa 14             	cmp    $0x14,%edx
8010503a:	77 24                	ja     80105060 <syscall+0x40>
8010503c:	8b 14 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%edx
80105043:	85 d2                	test   %edx,%edx
80105045:	74 19                	je     80105060 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105047:	ff d2                	call   *%edx
80105049:	89 c2                	mov    %eax,%edx
8010504b:	8b 43 18             	mov    0x18(%ebx),%eax
8010504e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105054:	c9                   	leave
80105055:	c3                   	ret
80105056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010505d:	00 
8010505e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80105060:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105061:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105064:	50                   	push   %eax
80105065:	ff 73 10             	push   0x10(%ebx)
80105068:	68 71 7a 10 80       	push   $0x80107a71
8010506d:	e8 ee b6 ff ff       	call   80100760 <cprintf>
    curproc->tf->eax = -1;
80105072:	8b 43 18             	mov    0x18(%ebx),%eax
80105075:	83 c4 10             	add    $0x10,%esp
80105078:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010507f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105082:	c9                   	leave
80105083:	c3                   	ret
80105084:	66 90                	xchg   %ax,%ax
80105086:	66 90                	xchg   %ax,%ax
80105088:	66 90                	xchg   %ax,%ax
8010508a:	66 90                	xchg   %ax,%ax
8010508c:	66 90                	xchg   %ax,%ax
8010508e:	66 90                	xchg   %ax,%ax

80105090 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105095:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105098:	53                   	push   %ebx
80105099:	83 ec 34             	sub    $0x34,%esp
8010509c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010509f:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801050a5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801050a8:	57                   	push   %edi
801050a9:	50                   	push   %eax
801050aa:	e8 81 d5 ff ff       	call   80102630 <nameiparent>
801050af:	83 c4 10             	add    $0x10,%esp
801050b2:	85 c0                	test   %eax,%eax
801050b4:	74 5e                	je     80105114 <create+0x84>
    return 0;
  ilock(dp);
801050b6:	83 ec 0c             	sub    $0xc,%esp
801050b9:	89 c3                	mov    %eax,%ebx
801050bb:	50                   	push   %eax
801050bc:	e8 6f cc ff ff       	call   80101d30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801050c1:	83 c4 0c             	add    $0xc,%esp
801050c4:	6a 00                	push   $0x0
801050c6:	57                   	push   %edi
801050c7:	53                   	push   %ebx
801050c8:	e8 b3 d1 ff ff       	call   80102280 <dirlookup>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	89 c6                	mov    %eax,%esi
801050d2:	85 c0                	test   %eax,%eax
801050d4:	74 4a                	je     80105120 <create+0x90>
    iunlockput(dp);
801050d6:	83 ec 0c             	sub    $0xc,%esp
801050d9:	53                   	push   %ebx
801050da:	e8 e1 ce ff ff       	call   80101fc0 <iunlockput>
    ilock(ip);
801050df:	89 34 24             	mov    %esi,(%esp)
801050e2:	e8 49 cc ff ff       	call   80101d30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050ef:	75 17                	jne    80105108 <create+0x78>
801050f1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801050f6:	75 10                	jne    80105108 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050fb:	89 f0                	mov    %esi,%eax
801050fd:	5b                   	pop    %ebx
801050fe:	5e                   	pop    %esi
801050ff:	5f                   	pop    %edi
80105100:	5d                   	pop    %ebp
80105101:	c3                   	ret
80105102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105108:	83 ec 0c             	sub    $0xc,%esp
8010510b:	56                   	push   %esi
8010510c:	e8 af ce ff ff       	call   80101fc0 <iunlockput>
    return 0;
80105111:	83 c4 10             	add    $0x10,%esp
}
80105114:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105117:	31 f6                	xor    %esi,%esi
}
80105119:	5b                   	pop    %ebx
8010511a:	89 f0                	mov    %esi,%eax
8010511c:	5e                   	pop    %esi
8010511d:	5f                   	pop    %edi
8010511e:	5d                   	pop    %ebp
8010511f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105120:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105124:	83 ec 08             	sub    $0x8,%esp
80105127:	50                   	push   %eax
80105128:	ff 33                	push   (%ebx)
8010512a:	e8 91 ca ff ff       	call   80101bc0 <ialloc>
8010512f:	83 c4 10             	add    $0x10,%esp
80105132:	89 c6                	mov    %eax,%esi
80105134:	85 c0                	test   %eax,%eax
80105136:	0f 84 bc 00 00 00    	je     801051f8 <create+0x168>
  ilock(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	50                   	push   %eax
80105140:	e8 eb cb ff ff       	call   80101d30 <ilock>
  ip->major = major;
80105145:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105149:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010514d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105151:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105155:	b8 01 00 00 00       	mov    $0x1,%eax
8010515a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010515e:	89 34 24             	mov    %esi,(%esp)
80105161:	e8 1a cb ff ff       	call   80101c80 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010516e:	74 30                	je     801051a0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105170:	83 ec 04             	sub    $0x4,%esp
80105173:	ff 76 04             	push   0x4(%esi)
80105176:	57                   	push   %edi
80105177:	53                   	push   %ebx
80105178:	e8 d3 d3 ff ff       	call   80102550 <dirlink>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	78 67                	js     801051eb <create+0x15b>
  iunlockput(dp);
80105184:	83 ec 0c             	sub    $0xc,%esp
80105187:	53                   	push   %ebx
80105188:	e8 33 ce ff ff       	call   80101fc0 <iunlockput>
  return ip;
8010518d:	83 c4 10             	add    $0x10,%esp
}
80105190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105193:	89 f0                	mov    %esi,%eax
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5f                   	pop    %edi
80105198:	5d                   	pop    %ebp
80105199:	c3                   	ret
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801051a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801051a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801051a8:	53                   	push   %ebx
801051a9:	e8 d2 ca ff ff       	call   80101c80 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801051ae:	83 c4 0c             	add    $0xc,%esp
801051b1:	ff 76 04             	push   0x4(%esi)
801051b4:	68 a9 7a 10 80       	push   $0x80107aa9
801051b9:	56                   	push   %esi
801051ba:	e8 91 d3 ff ff       	call   80102550 <dirlink>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 18                	js     801051de <create+0x14e>
801051c6:	83 ec 04             	sub    $0x4,%esp
801051c9:	ff 73 04             	push   0x4(%ebx)
801051cc:	68 a8 7a 10 80       	push   $0x80107aa8
801051d1:	56                   	push   %esi
801051d2:	e8 79 d3 ff ff       	call   80102550 <dirlink>
801051d7:	83 c4 10             	add    $0x10,%esp
801051da:	85 c0                	test   %eax,%eax
801051dc:	79 92                	jns    80105170 <create+0xe0>
      panic("create dots");
801051de:	83 ec 0c             	sub    $0xc,%esp
801051e1:	68 9c 7a 10 80       	push   $0x80107a9c
801051e6:	e8 85 b1 ff ff       	call   80100370 <panic>
    panic("create: dirlink");
801051eb:	83 ec 0c             	sub    $0xc,%esp
801051ee:	68 ab 7a 10 80       	push   $0x80107aab
801051f3:	e8 78 b1 ff ff       	call   80100370 <panic>
    panic("create: ialloc");
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	68 8d 7a 10 80       	push   $0x80107a8d
80105200:	e8 6b b1 ff ff       	call   80100370 <panic>
80105205:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010520c:	00 
8010520d:	8d 76 00             	lea    0x0(%esi),%esi

80105210 <sys_dup>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105215:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105218:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521b:	50                   	push   %eax
8010521c:	6a 00                	push   $0x0
8010521e:	e8 bd fc ff ff       	call   80104ee0 <argint>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 36                	js     80105260 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010522e:	77 30                	ja     80105260 <sys_dup+0x50>
80105230:	e8 bb ec ff ff       	call   80103ef0 <myproc>
80105235:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105238:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010523c:	85 f6                	test   %esi,%esi
8010523e:	74 20                	je     80105260 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105240:	e8 ab ec ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105245:	31 db                	xor    %ebx,%ebx
80105247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010524e:	00 
8010524f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105250:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105254:	85 d2                	test   %edx,%edx
80105256:	74 18                	je     80105270 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105258:	83 c3 01             	add    $0x1,%ebx
8010525b:	83 fb 10             	cmp    $0x10,%ebx
8010525e:	75 f0                	jne    80105250 <sys_dup+0x40>
}
80105260:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105263:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105268:	89 d8                	mov    %ebx,%eax
8010526a:	5b                   	pop    %ebx
8010526b:	5e                   	pop    %esi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret
8010526e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105270:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105273:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105277:	56                   	push   %esi
80105278:	e8 d3 c1 ff ff       	call   80101450 <filedup>
  return fd;
8010527d:	83 c4 10             	add    $0x10,%esp
}
80105280:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105283:	89 d8                	mov    %ebx,%eax
80105285:	5b                   	pop    %ebx
80105286:	5e                   	pop    %esi
80105287:	5d                   	pop    %ebp
80105288:	c3                   	ret
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_read>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	56                   	push   %esi
80105294:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105295:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105298:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010529b:	53                   	push   %ebx
8010529c:	6a 00                	push   $0x0
8010529e:	e8 3d fc ff ff       	call   80104ee0 <argint>
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	78 5e                	js     80105308 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052ae:	77 58                	ja     80105308 <sys_read+0x78>
801052b0:	e8 3b ec ff ff       	call   80103ef0 <myproc>
801052b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801052bc:	85 f6                	test   %esi,%esi
801052be:	74 48                	je     80105308 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052c0:	83 ec 08             	sub    $0x8,%esp
801052c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c6:	50                   	push   %eax
801052c7:	6a 02                	push   $0x2
801052c9:	e8 12 fc ff ff       	call   80104ee0 <argint>
801052ce:	83 c4 10             	add    $0x10,%esp
801052d1:	85 c0                	test   %eax,%eax
801052d3:	78 33                	js     80105308 <sys_read+0x78>
801052d5:	83 ec 04             	sub    $0x4,%esp
801052d8:	ff 75 f0             	push   -0x10(%ebp)
801052db:	53                   	push   %ebx
801052dc:	6a 01                	push   $0x1
801052de:	e8 4d fc ff ff       	call   80104f30 <argptr>
801052e3:	83 c4 10             	add    $0x10,%esp
801052e6:	85 c0                	test   %eax,%eax
801052e8:	78 1e                	js     80105308 <sys_read+0x78>
  return fileread(f, p, n);
801052ea:	83 ec 04             	sub    $0x4,%esp
801052ed:	ff 75 f0             	push   -0x10(%ebp)
801052f0:	ff 75 f4             	push   -0xc(%ebp)
801052f3:	56                   	push   %esi
801052f4:	e8 d7 c2 ff ff       	call   801015d0 <fileread>
801052f9:	83 c4 10             	add    $0x10,%esp
}
801052fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ff:	5b                   	pop    %ebx
80105300:	5e                   	pop    %esi
80105301:	5d                   	pop    %ebp
80105302:	c3                   	ret
80105303:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	eb ed                	jmp    801052fc <sys_read+0x6c>
8010530f:	90                   	nop

80105310 <sys_write>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105315:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105318:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010531b:	53                   	push   %ebx
8010531c:	6a 00                	push   $0x0
8010531e:	e8 bd fb ff ff       	call   80104ee0 <argint>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	78 5e                	js     80105388 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010532a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010532e:	77 58                	ja     80105388 <sys_write+0x78>
80105330:	e8 bb eb ff ff       	call   80103ef0 <myproc>
80105335:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105338:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010533c:	85 f6                	test   %esi,%esi
8010533e:	74 48                	je     80105388 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105340:	83 ec 08             	sub    $0x8,%esp
80105343:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105346:	50                   	push   %eax
80105347:	6a 02                	push   $0x2
80105349:	e8 92 fb ff ff       	call   80104ee0 <argint>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	85 c0                	test   %eax,%eax
80105353:	78 33                	js     80105388 <sys_write+0x78>
80105355:	83 ec 04             	sub    $0x4,%esp
80105358:	ff 75 f0             	push   -0x10(%ebp)
8010535b:	53                   	push   %ebx
8010535c:	6a 01                	push   $0x1
8010535e:	e8 cd fb ff ff       	call   80104f30 <argptr>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	85 c0                	test   %eax,%eax
80105368:	78 1e                	js     80105388 <sys_write+0x78>
  return filewrite(f, p, n);
8010536a:	83 ec 04             	sub    $0x4,%esp
8010536d:	ff 75 f0             	push   -0x10(%ebp)
80105370:	ff 75 f4             	push   -0xc(%ebp)
80105373:	56                   	push   %esi
80105374:	e8 e7 c2 ff ff       	call   80101660 <filewrite>
80105379:	83 c4 10             	add    $0x10,%esp
}
8010537c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010537f:	5b                   	pop    %ebx
80105380:	5e                   	pop    %esi
80105381:	5d                   	pop    %ebp
80105382:	c3                   	ret
80105383:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538d:	eb ed                	jmp    8010537c <sys_write+0x6c>
8010538f:	90                   	nop

80105390 <sys_close>:
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105395:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105398:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010539b:	50                   	push   %eax
8010539c:	6a 00                	push   $0x0
8010539e:	e8 3d fb ff ff       	call   80104ee0 <argint>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	78 3e                	js     801053e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053ae:	77 38                	ja     801053e8 <sys_close+0x58>
801053b0:	e8 3b eb ff ff       	call   80103ef0 <myproc>
801053b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801053bb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801053bf:	85 f6                	test   %esi,%esi
801053c1:	74 25                	je     801053e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801053c3:	e8 28 eb ff ff       	call   80103ef0 <myproc>
  fileclose(f);
801053c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053cb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801053d2:	00 
  fileclose(f);
801053d3:	56                   	push   %esi
801053d4:	e8 c7 c0 ff ff       	call   801014a0 <fileclose>
  return 0;
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	31 c0                	xor    %eax,%eax
}
801053de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053e1:	5b                   	pop    %ebx
801053e2:	5e                   	pop    %esi
801053e3:	5d                   	pop    %ebp
801053e4:	c3                   	ret
801053e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ed:	eb ef                	jmp    801053de <sys_close+0x4e>
801053ef:	90                   	nop

801053f0 <sys_fstat>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	56                   	push   %esi
801053f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801053f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801053f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053fb:	53                   	push   %ebx
801053fc:	6a 00                	push   $0x0
801053fe:	e8 dd fa ff ff       	call   80104ee0 <argint>
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	78 46                	js     80105450 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010540a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010540e:	77 40                	ja     80105450 <sys_fstat+0x60>
80105410:	e8 db ea ff ff       	call   80103ef0 <myproc>
80105415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105418:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010541c:	85 f6                	test   %esi,%esi
8010541e:	74 30                	je     80105450 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105420:	83 ec 04             	sub    $0x4,%esp
80105423:	6a 14                	push   $0x14
80105425:	53                   	push   %ebx
80105426:	6a 01                	push   $0x1
80105428:	e8 03 fb ff ff       	call   80104f30 <argptr>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 1c                	js     80105450 <sys_fstat+0x60>
  return filestat(f, st);
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	ff 75 f4             	push   -0xc(%ebp)
8010543a:	56                   	push   %esi
8010543b:	e8 40 c1 ff ff       	call   80101580 <filestat>
80105440:	83 c4 10             	add    $0x10,%esp
}
80105443:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105446:	5b                   	pop    %ebx
80105447:	5e                   	pop    %esi
80105448:	5d                   	pop    %ebp
80105449:	c3                   	ret
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105455:	eb ec                	jmp    80105443 <sys_fstat+0x53>
80105457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010545e:	00 
8010545f:	90                   	nop

80105460 <sys_link>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105465:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105468:	53                   	push   %ebx
80105469:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010546c:	50                   	push   %eax
8010546d:	6a 00                	push   $0x0
8010546f:	e8 2c fb ff ff       	call   80104fa0 <argstr>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	0f 88 fb 00 00 00    	js     8010557a <sys_link+0x11a>
8010547f:	83 ec 08             	sub    $0x8,%esp
80105482:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105485:	50                   	push   %eax
80105486:	6a 01                	push   $0x1
80105488:	e8 13 fb ff ff       	call   80104fa0 <argstr>
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	85 c0                	test   %eax,%eax
80105492:	0f 88 e2 00 00 00    	js     8010557a <sys_link+0x11a>
  begin_op();
80105498:	e8 33 de ff ff       	call   801032d0 <begin_op>
  if((ip = namei(old)) == 0){
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	ff 75 d4             	push   -0x2c(%ebp)
801054a3:	e8 68 d1 ff ff       	call   80102610 <namei>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	89 c3                	mov    %eax,%ebx
801054ad:	85 c0                	test   %eax,%eax
801054af:	0f 84 df 00 00 00    	je     80105594 <sys_link+0x134>
  ilock(ip);
801054b5:	83 ec 0c             	sub    $0xc,%esp
801054b8:	50                   	push   %eax
801054b9:	e8 72 c8 ff ff       	call   80101d30 <ilock>
  if(ip->type == T_DIR){
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c6:	0f 84 b5 00 00 00    	je     80105581 <sys_link+0x121>
  iupdate(ip);
801054cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801054cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801054d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054d7:	53                   	push   %ebx
801054d8:	e8 a3 c7 ff ff       	call   80101c80 <iupdate>
  iunlock(ip);
801054dd:	89 1c 24             	mov    %ebx,(%esp)
801054e0:	e8 2b c9 ff ff       	call   80101e10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054e5:	58                   	pop    %eax
801054e6:	5a                   	pop    %edx
801054e7:	57                   	push   %edi
801054e8:	ff 75 d0             	push   -0x30(%ebp)
801054eb:	e8 40 d1 ff ff       	call   80102630 <nameiparent>
801054f0:	83 c4 10             	add    $0x10,%esp
801054f3:	89 c6                	mov    %eax,%esi
801054f5:	85 c0                	test   %eax,%eax
801054f7:	74 5b                	je     80105554 <sys_link+0xf4>
  ilock(dp);
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	50                   	push   %eax
801054fd:	e8 2e c8 ff ff       	call   80101d30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105502:	8b 03                	mov    (%ebx),%eax
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	39 06                	cmp    %eax,(%esi)
80105509:	75 3d                	jne    80105548 <sys_link+0xe8>
8010550b:	83 ec 04             	sub    $0x4,%esp
8010550e:	ff 73 04             	push   0x4(%ebx)
80105511:	57                   	push   %edi
80105512:	56                   	push   %esi
80105513:	e8 38 d0 ff ff       	call   80102550 <dirlink>
80105518:	83 c4 10             	add    $0x10,%esp
8010551b:	85 c0                	test   %eax,%eax
8010551d:	78 29                	js     80105548 <sys_link+0xe8>
  iunlockput(dp);
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	56                   	push   %esi
80105523:	e8 98 ca ff ff       	call   80101fc0 <iunlockput>
  iput(ip);
80105528:	89 1c 24             	mov    %ebx,(%esp)
8010552b:	e8 30 c9 ff ff       	call   80101e60 <iput>
  end_op();
80105530:	e8 0b de ff ff       	call   80103340 <end_op>
  return 0;
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	31 c0                	xor    %eax,%eax
}
8010553a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010553d:	5b                   	pop    %ebx
8010553e:	5e                   	pop    %esi
8010553f:	5f                   	pop    %edi
80105540:	5d                   	pop    %ebp
80105541:	c3                   	ret
80105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	56                   	push   %esi
8010554c:	e8 6f ca ff ff       	call   80101fc0 <iunlockput>
    goto bad;
80105551:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	53                   	push   %ebx
80105558:	e8 d3 c7 ff ff       	call   80101d30 <ilock>
  ip->nlink--;
8010555d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105562:	89 1c 24             	mov    %ebx,(%esp)
80105565:	e8 16 c7 ff ff       	call   80101c80 <iupdate>
  iunlockput(ip);
8010556a:	89 1c 24             	mov    %ebx,(%esp)
8010556d:	e8 4e ca ff ff       	call   80101fc0 <iunlockput>
  end_op();
80105572:	e8 c9 dd ff ff       	call   80103340 <end_op>
  return -1;
80105577:	83 c4 10             	add    $0x10,%esp
    return -1;
8010557a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557f:	eb b9                	jmp    8010553a <sys_link+0xda>
    iunlockput(ip);
80105581:	83 ec 0c             	sub    $0xc,%esp
80105584:	53                   	push   %ebx
80105585:	e8 36 ca ff ff       	call   80101fc0 <iunlockput>
    end_op();
8010558a:	e8 b1 dd ff ff       	call   80103340 <end_op>
    return -1;
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	eb e6                	jmp    8010557a <sys_link+0x11a>
    end_op();
80105594:	e8 a7 dd ff ff       	call   80103340 <end_op>
    return -1;
80105599:	eb df                	jmp    8010557a <sys_link+0x11a>
8010559b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801055a0 <sys_unlink>:
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801055a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055a8:	53                   	push   %ebx
801055a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 ec f9 ff ff       	call   80104fa0 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 54 01 00 00    	js     80105713 <sys_unlink+0x173>
  begin_op();
801055bf:	e8 0c dd ff ff       	call   801032d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055c7:	83 ec 08             	sub    $0x8,%esp
801055ca:	53                   	push   %ebx
801055cb:	ff 75 c0             	push   -0x40(%ebp)
801055ce:	e8 5d d0 ff ff       	call   80102630 <nameiparent>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801055d9:	85 c0                	test   %eax,%eax
801055db:	0f 84 58 01 00 00    	je     80105739 <sys_unlink+0x199>
  ilock(dp);
801055e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	57                   	push   %edi
801055e8:	e8 43 c7 ff ff       	call   80101d30 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055ed:	58                   	pop    %eax
801055ee:	5a                   	pop    %edx
801055ef:	68 a9 7a 10 80       	push   $0x80107aa9
801055f4:	53                   	push   %ebx
801055f5:	e8 66 cc ff ff       	call   80102260 <namecmp>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	0f 84 fb 00 00 00    	je     80105700 <sys_unlink+0x160>
80105605:	83 ec 08             	sub    $0x8,%esp
80105608:	68 a8 7a 10 80       	push   $0x80107aa8
8010560d:	53                   	push   %ebx
8010560e:	e8 4d cc ff ff       	call   80102260 <namecmp>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	0f 84 e2 00 00 00    	je     80105700 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010561e:	83 ec 04             	sub    $0x4,%esp
80105621:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105624:	50                   	push   %eax
80105625:	53                   	push   %ebx
80105626:	57                   	push   %edi
80105627:	e8 54 cc ff ff       	call   80102280 <dirlookup>
8010562c:	83 c4 10             	add    $0x10,%esp
8010562f:	89 c3                	mov    %eax,%ebx
80105631:	85 c0                	test   %eax,%eax
80105633:	0f 84 c7 00 00 00    	je     80105700 <sys_unlink+0x160>
  ilock(ip);
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	50                   	push   %eax
8010563d:	e8 ee c6 ff ff       	call   80101d30 <ilock>
  if(ip->nlink < 1)
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010564a:	0f 8e 0a 01 00 00    	jle    8010575a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105650:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105655:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105658:	74 66                	je     801056c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010565a:	83 ec 04             	sub    $0x4,%esp
8010565d:	6a 10                	push   $0x10
8010565f:	6a 00                	push   $0x0
80105661:	57                   	push   %edi
80105662:	e8 c9 f5 ff ff       	call   80104c30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105667:	6a 10                	push   $0x10
80105669:	ff 75 c4             	push   -0x3c(%ebp)
8010566c:	57                   	push   %edi
8010566d:	ff 75 b4             	push   -0x4c(%ebp)
80105670:	e8 cb ca ff ff       	call   80102140 <writei>
80105675:	83 c4 20             	add    $0x20,%esp
80105678:	83 f8 10             	cmp    $0x10,%eax
8010567b:	0f 85 cc 00 00 00    	jne    8010574d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105681:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105686:	0f 84 94 00 00 00    	je     80105720 <sys_unlink+0x180>
  iunlockput(dp);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	ff 75 b4             	push   -0x4c(%ebp)
80105692:	e8 29 c9 ff ff       	call   80101fc0 <iunlockput>
  ip->nlink--;
80105697:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010569c:	89 1c 24             	mov    %ebx,(%esp)
8010569f:	e8 dc c5 ff ff       	call   80101c80 <iupdate>
  iunlockput(ip);
801056a4:	89 1c 24             	mov    %ebx,(%esp)
801056a7:	e8 14 c9 ff ff       	call   80101fc0 <iunlockput>
  end_op();
801056ac:	e8 8f dc ff ff       	call   80103340 <end_op>
  return 0;
801056b1:	83 c4 10             	add    $0x10,%esp
801056b4:	31 c0                	xor    %eax,%eax
}
801056b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b9:	5b                   	pop    %ebx
801056ba:	5e                   	pop    %esi
801056bb:	5f                   	pop    %edi
801056bc:	5d                   	pop    %ebp
801056bd:	c3                   	ret
801056be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056c4:	76 94                	jbe    8010565a <sys_unlink+0xba>
801056c6:	be 20 00 00 00       	mov    $0x20,%esi
801056cb:	eb 0b                	jmp    801056d8 <sys_unlink+0x138>
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
801056d0:	83 c6 10             	add    $0x10,%esi
801056d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801056d6:	73 82                	jae    8010565a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056d8:	6a 10                	push   $0x10
801056da:	56                   	push   %esi
801056db:	57                   	push   %edi
801056dc:	53                   	push   %ebx
801056dd:	e8 5e c9 ff ff       	call   80102040 <readi>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	83 f8 10             	cmp    $0x10,%eax
801056e8:	75 56                	jne    80105740 <sys_unlink+0x1a0>
    if(de.inum != 0)
801056ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056ef:	74 df                	je     801056d0 <sys_unlink+0x130>
    iunlockput(ip);
801056f1:	83 ec 0c             	sub    $0xc,%esp
801056f4:	53                   	push   %ebx
801056f5:	e8 c6 c8 ff ff       	call   80101fc0 <iunlockput>
    goto bad;
801056fa:	83 c4 10             	add    $0x10,%esp
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	ff 75 b4             	push   -0x4c(%ebp)
80105706:	e8 b5 c8 ff ff       	call   80101fc0 <iunlockput>
  end_op();
8010570b:	e8 30 dc ff ff       	call   80103340 <end_op>
  return -1;
80105710:	83 c4 10             	add    $0x10,%esp
    return -1;
80105713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105718:	eb 9c                	jmp    801056b6 <sys_unlink+0x116>
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105720:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105723:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105726:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010572b:	50                   	push   %eax
8010572c:	e8 4f c5 ff ff       	call   80101c80 <iupdate>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	e9 53 ff ff ff       	jmp    8010568c <sys_unlink+0xec>
    end_op();
80105739:	e8 02 dc ff ff       	call   80103340 <end_op>
    return -1;
8010573e:	eb d3                	jmp    80105713 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	68 cd 7a 10 80       	push   $0x80107acd
80105748:	e8 23 ac ff ff       	call   80100370 <panic>
    panic("unlink: writei");
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	68 df 7a 10 80       	push   $0x80107adf
80105755:	e8 16 ac ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
8010575a:	83 ec 0c             	sub    $0xc,%esp
8010575d:	68 bb 7a 10 80       	push   $0x80107abb
80105762:	e8 09 ac ff ff       	call   80100370 <panic>
80105767:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576e:	00 
8010576f:	90                   	nop

80105770 <sys_open>:

int
sys_open(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105775:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105778:	53                   	push   %ebx
80105779:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010577c:	50                   	push   %eax
8010577d:	6a 00                	push   $0x0
8010577f:	e8 1c f8 ff ff       	call   80104fa0 <argstr>
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	85 c0                	test   %eax,%eax
80105789:	0f 88 8e 00 00 00    	js     8010581d <sys_open+0xad>
8010578f:	83 ec 08             	sub    $0x8,%esp
80105792:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105795:	50                   	push   %eax
80105796:	6a 01                	push   $0x1
80105798:	e8 43 f7 ff ff       	call   80104ee0 <argint>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 79                	js     8010581d <sys_open+0xad>
    return -1;

  begin_op();
801057a4:	e8 27 db ff ff       	call   801032d0 <begin_op>

  if(omode & O_CREATE){
801057a9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057ad:	75 79                	jne    80105828 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057af:	83 ec 0c             	sub    $0xc,%esp
801057b2:	ff 75 e0             	push   -0x20(%ebp)
801057b5:	e8 56 ce ff ff       	call   80102610 <namei>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	89 c6                	mov    %eax,%esi
801057bf:	85 c0                	test   %eax,%eax
801057c1:	0f 84 7e 00 00 00    	je     80105845 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801057c7:	83 ec 0c             	sub    $0xc,%esp
801057ca:	50                   	push   %eax
801057cb:	e8 60 c5 ff ff       	call   80101d30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057d0:	83 c4 10             	add    $0x10,%esp
801057d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057d8:	0f 84 ba 00 00 00    	je     80105898 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057de:	e8 fd bb ff ff       	call   801013e0 <filealloc>
801057e3:	89 c7                	mov    %eax,%edi
801057e5:	85 c0                	test   %eax,%eax
801057e7:	74 23                	je     8010580c <sys_open+0x9c>
  struct proc *curproc = myproc();
801057e9:	e8 02 e7 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057f4:	85 d2                	test   %edx,%edx
801057f6:	74 58                	je     80105850 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801057f8:	83 c3 01             	add    $0x1,%ebx
801057fb:	83 fb 10             	cmp    $0x10,%ebx
801057fe:	75 f0                	jne    801057f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	57                   	push   %edi
80105804:	e8 97 bc ff ff       	call   801014a0 <fileclose>
80105809:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	56                   	push   %esi
80105810:	e8 ab c7 ff ff       	call   80101fc0 <iunlockput>
    end_op();
80105815:	e8 26 db ff ff       	call   80103340 <end_op>
    return -1;
8010581a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010581d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105822:	eb 65                	jmp    80105889 <sys_open+0x119>
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	31 c9                	xor    %ecx,%ecx
8010582d:	ba 02 00 00 00       	mov    $0x2,%edx
80105832:	6a 00                	push   $0x0
80105834:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105837:	e8 54 f8 ff ff       	call   80105090 <create>
    if(ip == 0){
8010583c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010583f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105841:	85 c0                	test   %eax,%eax
80105843:	75 99                	jne    801057de <sys_open+0x6e>
      end_op();
80105845:	e8 f6 da ff ff       	call   80103340 <end_op>
      return -1;
8010584a:	eb d1                	jmp    8010581d <sys_open+0xad>
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105850:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105853:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105857:	56                   	push   %esi
80105858:	e8 b3 c5 ff ff       	call   80101e10 <iunlock>
  end_op();
8010585d:	e8 de da ff ff       	call   80103340 <end_op>

  f->type = FD_INODE;
80105862:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105868:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010586b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010586e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105871:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105873:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010587a:	f7 d0                	not    %eax
8010587c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010587f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105882:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105885:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010588c:	89 d8                	mov    %ebx,%eax
8010588e:	5b                   	pop    %ebx
8010588f:	5e                   	pop    %esi
80105890:	5f                   	pop    %edi
80105891:	5d                   	pop    %ebp
80105892:	c3                   	ret
80105893:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105898:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010589b:	85 c9                	test   %ecx,%ecx
8010589d:	0f 84 3b ff ff ff    	je     801057de <sys_open+0x6e>
801058a3:	e9 64 ff ff ff       	jmp    8010580c <sys_open+0x9c>
801058a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058af:	00 

801058b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058b6:	e8 15 da ff ff       	call   801032d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	e8 d7 f6 ff ff       	call   80104fa0 <argstr>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	78 30                	js     80105900 <sys_mkdir+0x50>
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d6:	31 c9                	xor    %ecx,%ecx
801058d8:	ba 01 00 00 00       	mov    $0x1,%edx
801058dd:	6a 00                	push   $0x0
801058df:	e8 ac f7 ff ff       	call   80105090 <create>
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
801058e9:	74 15                	je     80105900 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058eb:	83 ec 0c             	sub    $0xc,%esp
801058ee:	50                   	push   %eax
801058ef:	e8 cc c6 ff ff       	call   80101fc0 <iunlockput>
  end_op();
801058f4:	e8 47 da ff ff       	call   80103340 <end_op>
  return 0;
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	31 c0                	xor    %eax,%eax
}
801058fe:	c9                   	leave
801058ff:	c3                   	ret
    end_op();
80105900:	e8 3b da ff ff       	call   80103340 <end_op>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010590a:	c9                   	leave
8010590b:	c3                   	ret
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_mknod>:

int
sys_mknod(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105916:	e8 b5 d9 ff ff       	call   801032d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010591b:	83 ec 08             	sub    $0x8,%esp
8010591e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105921:	50                   	push   %eax
80105922:	6a 00                	push   $0x0
80105924:	e8 77 f6 ff ff       	call   80104fa0 <argstr>
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	85 c0                	test   %eax,%eax
8010592e:	78 60                	js     80105990 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105936:	50                   	push   %eax
80105937:	6a 01                	push   $0x1
80105939:	e8 a2 f5 ff ff       	call   80104ee0 <argint>
  if((argstr(0, &path)) < 0 ||
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	85 c0                	test   %eax,%eax
80105943:	78 4b                	js     80105990 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594b:	50                   	push   %eax
8010594c:	6a 02                	push   $0x2
8010594e:	e8 8d f5 ff ff       	call   80104ee0 <argint>
     argint(1, &major) < 0 ||
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	78 36                	js     80105990 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010595a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010595e:	83 ec 0c             	sub    $0xc,%esp
80105961:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105965:	ba 03 00 00 00       	mov    $0x3,%edx
8010596a:	50                   	push   %eax
8010596b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010596e:	e8 1d f7 ff ff       	call   80105090 <create>
     argint(2, &minor) < 0 ||
80105973:	83 c4 10             	add    $0x10,%esp
80105976:	85 c0                	test   %eax,%eax
80105978:	74 16                	je     80105990 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010597a:	83 ec 0c             	sub    $0xc,%esp
8010597d:	50                   	push   %eax
8010597e:	e8 3d c6 ff ff       	call   80101fc0 <iunlockput>
  end_op();
80105983:	e8 b8 d9 ff ff       	call   80103340 <end_op>
  return 0;
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	31 c0                	xor    %eax,%eax
}
8010598d:	c9                   	leave
8010598e:	c3                   	ret
8010598f:	90                   	nop
    end_op();
80105990:	e8 ab d9 ff ff       	call   80103340 <end_op>
    return -1;
80105995:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010599a:	c9                   	leave
8010599b:	c3                   	ret
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_chdir>:

int
sys_chdir(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	56                   	push   %esi
801059a4:	53                   	push   %ebx
801059a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059a8:	e8 43 e5 ff ff       	call   80103ef0 <myproc>
801059ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059af:	e8 1c d9 ff ff       	call   801032d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059b4:	83 ec 08             	sub    $0x8,%esp
801059b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 de f5 ff ff       	call   80104fa0 <argstr>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 77                	js     80105a40 <sys_chdir+0xa0>
801059c9:	83 ec 0c             	sub    $0xc,%esp
801059cc:	ff 75 f4             	push   -0xc(%ebp)
801059cf:	e8 3c cc ff ff       	call   80102610 <namei>
801059d4:	83 c4 10             	add    $0x10,%esp
801059d7:	89 c3                	mov    %eax,%ebx
801059d9:	85 c0                	test   %eax,%eax
801059db:	74 63                	je     80105a40 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	50                   	push   %eax
801059e1:	e8 4a c3 ff ff       	call   80101d30 <ilock>
  if(ip->type != T_DIR){
801059e6:	83 c4 10             	add    $0x10,%esp
801059e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059ee:	75 30                	jne    80105a20 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	53                   	push   %ebx
801059f4:	e8 17 c4 ff ff       	call   80101e10 <iunlock>
  iput(curproc->cwd);
801059f9:	58                   	pop    %eax
801059fa:	ff 76 68             	push   0x68(%esi)
801059fd:	e8 5e c4 ff ff       	call   80101e60 <iput>
  end_op();
80105a02:	e8 39 d9 ff ff       	call   80103340 <end_op>
  curproc->cwd = ip;
80105a07:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	31 c0                	xor    %eax,%eax
}
80105a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a12:	5b                   	pop    %ebx
80105a13:	5e                   	pop    %esi
80105a14:	5d                   	pop    %ebp
80105a15:	c3                   	ret
80105a16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1d:	00 
80105a1e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	53                   	push   %ebx
80105a24:	e8 97 c5 ff ff       	call   80101fc0 <iunlockput>
    end_op();
80105a29:	e8 12 d9 ff ff       	call   80103340 <end_op>
    return -1;
80105a2e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a36:	eb d7                	jmp    80105a0f <sys_chdir+0x6f>
80105a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3f:	00 
    end_op();
80105a40:	e8 fb d8 ff ff       	call   80103340 <end_op>
    return -1;
80105a45:	eb ea                	jmp    80105a31 <sys_chdir+0x91>
80105a47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4e:	00 
80105a4f:	90                   	nop

80105a50 <sys_exec>:

int
sys_exec(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	57                   	push   %edi
80105a54:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a55:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a5b:	53                   	push   %ebx
80105a5c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a62:	50                   	push   %eax
80105a63:	6a 00                	push   $0x0
80105a65:	e8 36 f5 ff ff       	call   80104fa0 <argstr>
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	85 c0                	test   %eax,%eax
80105a6f:	0f 88 87 00 00 00    	js     80105afc <sys_exec+0xac>
80105a75:	83 ec 08             	sub    $0x8,%esp
80105a78:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a7e:	50                   	push   %eax
80105a7f:	6a 01                	push   $0x1
80105a81:	e8 5a f4 ff ff       	call   80104ee0 <argint>
80105a86:	83 c4 10             	add    $0x10,%esp
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	78 6f                	js     80105afc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a8d:	83 ec 04             	sub    $0x4,%esp
80105a90:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105a96:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a98:	68 80 00 00 00       	push   $0x80
80105a9d:	6a 00                	push   $0x0
80105a9f:	56                   	push   %esi
80105aa0:	e8 8b f1 ff ff       	call   80104c30 <memset>
80105aa5:	83 c4 10             	add    $0x10,%esp
80105aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aaf:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ab0:	83 ec 08             	sub    $0x8,%esp
80105ab3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105ab9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105ac0:	50                   	push   %eax
80105ac1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ac7:	01 f8                	add    %edi,%eax
80105ac9:	50                   	push   %eax
80105aca:	e8 81 f3 ff ff       	call   80104e50 <fetchint>
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	85 c0                	test   %eax,%eax
80105ad4:	78 26                	js     80105afc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105ad6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105adc:	85 c0                	test   %eax,%eax
80105ade:	74 30                	je     80105b10 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105ae6:	52                   	push   %edx
80105ae7:	50                   	push   %eax
80105ae8:	e8 a3 f3 ff ff       	call   80104e90 <fetchstr>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 08                	js     80105afc <sys_exec+0xac>
  for(i=0;; i++){
80105af4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105af7:	83 fb 20             	cmp    $0x20,%ebx
80105afa:	75 b4                	jne    80105ab0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
80105b08:	c3                   	ret
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105b10:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b17:	00 00 00 00 
  return exec(path, argv);
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	56                   	push   %esi
80105b1f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105b25:	e8 16 b5 ff ff       	call   80101040 <exec>
80105b2a:	83 c4 10             	add    $0x10,%esp
}
80105b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b30:	5b                   	pop    %ebx
80105b31:	5e                   	pop    %esi
80105b32:	5f                   	pop    %edi
80105b33:	5d                   	pop    %ebp
80105b34:	c3                   	ret
80105b35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b3c:	00 
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi

80105b40 <sys_pipe>:

int
sys_pipe(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b45:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b48:	53                   	push   %ebx
80105b49:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b4c:	6a 08                	push   $0x8
80105b4e:	50                   	push   %eax
80105b4f:	6a 00                	push   $0x0
80105b51:	e8 da f3 ff ff       	call   80104f30 <argptr>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	0f 88 8b 00 00 00    	js     80105bec <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b61:	83 ec 08             	sub    $0x8,%esp
80105b64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b67:	50                   	push   %eax
80105b68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b6b:	50                   	push   %eax
80105b6c:	e8 2f de ff ff       	call   801039a0 <pipealloc>
80105b71:	83 c4 10             	add    $0x10,%esp
80105b74:	85 c0                	test   %eax,%eax
80105b76:	78 74                	js     80105bec <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b7d:	e8 6e e3 ff ff       	call   80103ef0 <myproc>
    if(curproc->ofile[fd] == 0){
80105b82:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b86:	85 f6                	test   %esi,%esi
80105b88:	74 16                	je     80105ba0 <sys_pipe+0x60>
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	74 3d                	je     80105bd5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105b98:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b9c:	85 f6                	test   %esi,%esi
80105b9e:	75 f0                	jne    80105b90 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ba3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ba7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105baa:	e8 41 e3 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105baf:	31 d2                	xor    %edx,%edx
80105bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bbc:	85 c9                	test   %ecx,%ecx
80105bbe:	74 38                	je     80105bf8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c2 01             	add    $0x1,%edx
80105bc3:	83 fa 10             	cmp    $0x10,%edx
80105bc6:	75 f0                	jne    80105bb8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105bc8:	e8 23 e3 ff ff       	call   80103ef0 <myproc>
80105bcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bd4:	00 
    fileclose(rf);
80105bd5:	83 ec 0c             	sub    $0xc,%esp
80105bd8:	ff 75 e0             	push   -0x20(%ebp)
80105bdb:	e8 c0 b8 ff ff       	call   801014a0 <fileclose>
    fileclose(wf);
80105be0:	58                   	pop    %eax
80105be1:	ff 75 e4             	push   -0x1c(%ebp)
80105be4:	e8 b7 b8 ff ff       	call   801014a0 <fileclose>
    return -1;
80105be9:	83 c4 10             	add    $0x10,%esp
    return -1;
80105bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf1:	eb 16                	jmp    80105c09 <sys_pipe+0xc9>
80105bf3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105bf8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105bfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c07:	31 c0                	xor    %eax,%eax
}
80105c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c0c:	5b                   	pop    %ebx
80105c0d:	5e                   	pop    %esi
80105c0e:	5f                   	pop    %edi
80105c0f:	5d                   	pop    %ebp
80105c10:	c3                   	ret
80105c11:	66 90                	xchg   %ax,%ax
80105c13:	66 90                	xchg   %ax,%ax
80105c15:	66 90                	xchg   %ax,%ax
80105c17:	66 90                	xchg   %ax,%ax
80105c19:	66 90                	xchg   %ax,%ax
80105c1b:	66 90                	xchg   %ax,%ax
80105c1d:	66 90                	xchg   %ax,%ax
80105c1f:	90                   	nop

80105c20 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105c20:	e9 6b e4 ff ff       	jmp    80104090 <fork>
80105c25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c2c:	00 
80105c2d:	8d 76 00             	lea    0x0(%esi),%esi

80105c30 <sys_exit>:
}

int
sys_exit(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c36:	e8 c5 e6 ff ff       	call   80104300 <exit>
  return 0;  // not reached
}
80105c3b:	31 c0                	xor    %eax,%eax
80105c3d:	c9                   	leave
80105c3e:	c3                   	ret
80105c3f:	90                   	nop

80105c40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105c40:	e9 eb e7 ff ff       	jmp    80104430 <wait>
80105c45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c4c:	00 
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi

80105c50 <sys_kill>:
}

int
sys_kill(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c59:	50                   	push   %eax
80105c5a:	6a 00                	push   $0x0
80105c5c:	e8 7f f2 ff ff       	call   80104ee0 <argint>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	78 18                	js     80105c80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	ff 75 f4             	push   -0xc(%ebp)
80105c6e:	e8 5d ea ff ff       	call   801046d0 <kill>
80105c73:	83 c4 10             	add    $0x10,%esp
}
80105c76:	c9                   	leave
80105c77:	c3                   	ret
80105c78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c7f:	00 
80105c80:	c9                   	leave
    return -1;
80105c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c86:	c3                   	ret
80105c87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c8e:	00 
80105c8f:	90                   	nop

80105c90 <sys_getpid>:

int
sys_getpid(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c96:	e8 55 e2 ff ff       	call   80103ef0 <myproc>
80105c9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c9e:	c9                   	leave
80105c9f:	c3                   	ret

80105ca0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ca7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105caa:	50                   	push   %eax
80105cab:	6a 00                	push   $0x0
80105cad:	e8 2e f2 ff ff       	call   80104ee0 <argint>
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	78 27                	js     80105ce0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cb9:	e8 32 e2 ff ff       	call   80103ef0 <myproc>
  if(growproc(n) < 0)
80105cbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105cc1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cc3:	ff 75 f4             	push   -0xc(%ebp)
80105cc6:	e8 45 e3 ff ff       	call   80104010 <growproc>
80105ccb:	83 c4 10             	add    $0x10,%esp
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	78 0e                	js     80105ce0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cd2:	89 d8                	mov    %ebx,%eax
80105cd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cd7:	c9                   	leave
80105cd8:	c3                   	ret
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ce0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ce5:	eb eb                	jmp    80105cd2 <sys_sbrk+0x32>
80105ce7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cee:	00 
80105cef:	90                   	nop

80105cf0 <sys_sleep>:

int
sys_sleep(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cfa:	50                   	push   %eax
80105cfb:	6a 00                	push   $0x0
80105cfd:	e8 de f1 ff ff       	call   80104ee0 <argint>
80105d02:	83 c4 10             	add    $0x10,%esp
80105d05:	85 c0                	test   %eax,%eax
80105d07:	78 64                	js     80105d6d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105d09:	83 ec 0c             	sub    $0xc,%esp
80105d0c:	68 80 4c 11 80       	push   $0x80114c80
80105d11:	e8 1a ee ff ff       	call   80104b30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d19:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  while(ticks - ticks0 < n){
80105d1f:	83 c4 10             	add    $0x10,%esp
80105d22:	85 d2                	test   %edx,%edx
80105d24:	75 2b                	jne    80105d51 <sys_sleep+0x61>
80105d26:	eb 58                	jmp    80105d80 <sys_sleep+0x90>
80105d28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d2f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d30:	83 ec 08             	sub    $0x8,%esp
80105d33:	68 80 4c 11 80       	push   $0x80114c80
80105d38:	68 60 4c 11 80       	push   $0x80114c60
80105d3d:	e8 6e e8 ff ff       	call   801045b0 <sleep>
  while(ticks - ticks0 < n){
80105d42:	a1 60 4c 11 80       	mov    0x80114c60,%eax
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	29 d8                	sub    %ebx,%eax
80105d4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d4f:	73 2f                	jae    80105d80 <sys_sleep+0x90>
    if(myproc()->killed){
80105d51:	e8 9a e1 ff ff       	call   80103ef0 <myproc>
80105d56:	8b 40 24             	mov    0x24(%eax),%eax
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	74 d3                	je     80105d30 <sys_sleep+0x40>
      release(&tickslock);
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	68 80 4c 11 80       	push   $0x80114c80
80105d65:	e8 66 ed ff ff       	call   80104ad0 <release>
      return -1;
80105d6a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80105d6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d75:	c9                   	leave
80105d76:	c3                   	ret
80105d77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d7e:	00 
80105d7f:	90                   	nop
  release(&tickslock);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	68 80 4c 11 80       	push   $0x80114c80
80105d88:	e8 43 ed ff ff       	call   80104ad0 <release>
}
80105d8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	31 c0                	xor    %eax,%eax
}
80105d95:	c9                   	leave
80105d96:	c3                   	ret
80105d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d9e:	00 
80105d9f:	90                   	nop

80105da0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	53                   	push   %ebx
80105da4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105da7:	68 80 4c 11 80       	push   $0x80114c80
80105dac:	e8 7f ed ff ff       	call   80104b30 <acquire>
  xticks = ticks;
80105db1:	8b 1d 60 4c 11 80    	mov    0x80114c60,%ebx
  release(&tickslock);
80105db7:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105dbe:	e8 0d ed ff ff       	call   80104ad0 <release>
  return xticks;
}
80105dc3:	89 d8                	mov    %ebx,%eax
80105dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dc8:	c9                   	leave
80105dc9:	c3                   	ret

80105dca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dca:	1e                   	push   %ds
  pushl %es
80105dcb:	06                   	push   %es
  pushl %fs
80105dcc:	0f a0                	push   %fs
  pushl %gs
80105dce:	0f a8                	push   %gs
  pushal
80105dd0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105dd1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105dd5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105dd7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105dd9:	54                   	push   %esp
  call trap
80105dda:	e8 c1 00 00 00       	call   80105ea0 <trap>
  addl $4, %esp
80105ddf:	83 c4 04             	add    $0x4,%esp

80105de2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105de2:	61                   	popa
  popl %gs
80105de3:	0f a9                	pop    %gs
  popl %fs
80105de5:	0f a1                	pop    %fs
  popl %es
80105de7:	07                   	pop    %es
  popl %ds
80105de8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105de9:	83 c4 08             	add    $0x8,%esp
  iret
80105dec:	cf                   	iret
80105ded:	66 90                	xchg   %ax,%ax
80105def:	90                   	nop

80105df0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105df0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105df1:	31 c0                	xor    %eax,%eax
{
80105df3:	89 e5                	mov    %esp,%ebp
80105df5:	83 ec 08             	sub    $0x8,%esp
80105df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dff:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e00:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e07:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105e0e:	08 00 00 8e 
80105e12:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105e19:	80 
80105e1a:	c1 ea 10             	shr    $0x10,%edx
80105e1d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105e24:	80 
  for(i = 0; i < 256; i++)
80105e25:	83 c0 01             	add    $0x1,%eax
80105e28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e2d:	75 d1                	jne    80105e00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e32:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e37:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105e3e:	00 00 ef 
  initlock(&tickslock, "time");
80105e41:	68 ee 7a 10 80       	push   $0x80107aee
80105e46:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e4b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105e51:	c1 e8 10             	shr    $0x10,%eax
80105e54:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105e5a:	e8 e1 ea ff ff       	call   80104940 <initlock>
}
80105e5f:	83 c4 10             	add    $0x10,%esp
80105e62:	c9                   	leave
80105e63:	c3                   	ret
80105e64:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e6b:	00 
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <idtinit>:

void
idtinit(void)
{
80105e70:	55                   	push   %ebp
  pd[0] = size-1;
80105e71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e76:	89 e5                	mov    %esp,%ebp
80105e78:	83 ec 10             	sub    $0x10,%esp
80105e7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e7f:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105e84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e88:	c1 e8 10             	shr    $0x10,%eax
80105e8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e95:	c9                   	leave
80105e96:	c3                   	ret
80105e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e9e:	00 
80105e9f:	90                   	nop

80105ea0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	83 ec 1c             	sub    $0x1c,%esp
80105ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105eac:	8b 43 30             	mov    0x30(%ebx),%eax
80105eaf:	83 f8 40             	cmp    $0x40,%eax
80105eb2:	0f 84 58 01 00 00    	je     80106010 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105eb8:	83 e8 20             	sub    $0x20,%eax
80105ebb:	83 f8 1f             	cmp    $0x1f,%eax
80105ebe:	0f 87 7c 00 00 00    	ja     80105f40 <trap+0xa0>
80105ec4:	ff 24 85 98 80 10 80 	jmp    *-0x7fef7f68(,%eax,4)
80105ecb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ed0:	e8 eb c8 ff ff       	call   801027c0 <ideintr>
    lapiceoi();
80105ed5:	e8 a6 cf ff ff       	call   80102e80 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eda:	e8 11 e0 ff ff       	call   80103ef0 <myproc>
80105edf:	85 c0                	test   %eax,%eax
80105ee1:	74 1a                	je     80105efd <trap+0x5d>
80105ee3:	e8 08 e0 ff ff       	call   80103ef0 <myproc>
80105ee8:	8b 50 24             	mov    0x24(%eax),%edx
80105eeb:	85 d2                	test   %edx,%edx
80105eed:	74 0e                	je     80105efd <trap+0x5d>
80105eef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ef3:	f7 d0                	not    %eax
80105ef5:	a8 03                	test   $0x3,%al
80105ef7:	0f 84 db 01 00 00    	je     801060d8 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105efd:	e8 ee df ff ff       	call   80103ef0 <myproc>
80105f02:	85 c0                	test   %eax,%eax
80105f04:	74 0f                	je     80105f15 <trap+0x75>
80105f06:	e8 e5 df ff ff       	call   80103ef0 <myproc>
80105f0b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f0f:	0f 84 ab 00 00 00    	je     80105fc0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f15:	e8 d6 df ff ff       	call   80103ef0 <myproc>
80105f1a:	85 c0                	test   %eax,%eax
80105f1c:	74 1a                	je     80105f38 <trap+0x98>
80105f1e:	e8 cd df ff ff       	call   80103ef0 <myproc>
80105f23:	8b 40 24             	mov    0x24(%eax),%eax
80105f26:	85 c0                	test   %eax,%eax
80105f28:	74 0e                	je     80105f38 <trap+0x98>
80105f2a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f2e:	f7 d0                	not    %eax
80105f30:	a8 03                	test   $0x3,%al
80105f32:	0f 84 05 01 00 00    	je     8010603d <trap+0x19d>
    exit();
}
80105f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3b:	5b                   	pop    %ebx
80105f3c:	5e                   	pop    %esi
80105f3d:	5f                   	pop    %edi
80105f3e:	5d                   	pop    %ebp
80105f3f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f40:	e8 ab df ff ff       	call   80103ef0 <myproc>
80105f45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f48:	85 c0                	test   %eax,%eax
80105f4a:	0f 84 a2 01 00 00    	je     801060f2 <trap+0x252>
80105f50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f54:	0f 84 98 01 00 00    	je     801060f2 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f5a:	0f 20 d1             	mov    %cr2,%ecx
80105f5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f60:	e8 6b df ff ff       	call   80103ed0 <cpuid>
80105f65:	8b 73 30             	mov    0x30(%ebx),%esi
80105f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105f71:	e8 7a df ff ff       	call   80103ef0 <myproc>
80105f76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f79:	e8 72 df ff ff       	call   80103ef0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f81:	51                   	push   %ecx
80105f82:	57                   	push   %edi
80105f83:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f86:	52                   	push   %edx
80105f87:	ff 75 e4             	push   -0x1c(%ebp)
80105f8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f91:	56                   	push   %esi
80105f92:	ff 70 10             	push   0x10(%eax)
80105f95:	68 94 7d 10 80       	push   $0x80107d94
80105f9a:	e8 c1 a7 ff ff       	call   80100760 <cprintf>
    myproc()->killed = 1;
80105f9f:	83 c4 20             	add    $0x20,%esp
80105fa2:	e8 49 df ff ff       	call   80103ef0 <myproc>
80105fa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fae:	e8 3d df ff ff       	call   80103ef0 <myproc>
80105fb3:	85 c0                	test   %eax,%eax
80105fb5:	0f 85 28 ff ff ff    	jne    80105ee3 <trap+0x43>
80105fbb:	e9 3d ff ff ff       	jmp    80105efd <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105fc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fc4:	0f 85 4b ff ff ff    	jne    80105f15 <trap+0x75>
    yield();
80105fca:	e8 91 e5 ff ff       	call   80104560 <yield>
80105fcf:	e9 41 ff ff ff       	jmp    80105f15 <trap+0x75>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fd8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fdb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fdf:	e8 ec de ff ff       	call   80103ed0 <cpuid>
80105fe4:	57                   	push   %edi
80105fe5:	56                   	push   %esi
80105fe6:	50                   	push   %eax
80105fe7:	68 3c 7d 10 80       	push   $0x80107d3c
80105fec:	e8 6f a7 ff ff       	call   80100760 <cprintf>
    lapiceoi();
80105ff1:	e8 8a ce ff ff       	call   80102e80 <lapiceoi>
    break;
80105ff6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff9:	e8 f2 de ff ff       	call   80103ef0 <myproc>
80105ffe:	85 c0                	test   %eax,%eax
80106000:	0f 85 dd fe ff ff    	jne    80105ee3 <trap+0x43>
80106006:	e9 f2 fe ff ff       	jmp    80105efd <trap+0x5d>
8010600b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106010:	e8 db de ff ff       	call   80103ef0 <myproc>
80106015:	8b 70 24             	mov    0x24(%eax),%esi
80106018:	85 f6                	test   %esi,%esi
8010601a:	0f 85 c8 00 00 00    	jne    801060e8 <trap+0x248>
    myproc()->tf = tf;
80106020:	e8 cb de ff ff       	call   80103ef0 <myproc>
80106025:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106028:	e8 f3 ef ff ff       	call   80105020 <syscall>
    if(myproc()->killed)
8010602d:	e8 be de ff ff       	call   80103ef0 <myproc>
80106032:	8b 48 24             	mov    0x24(%eax),%ecx
80106035:	85 c9                	test   %ecx,%ecx
80106037:	0f 84 fb fe ff ff    	je     80105f38 <trap+0x98>
}
8010603d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106040:	5b                   	pop    %ebx
80106041:	5e                   	pop    %esi
80106042:	5f                   	pop    %edi
80106043:	5d                   	pop    %ebp
      exit();
80106044:	e9 b7 e2 ff ff       	jmp    80104300 <exit>
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106050:	e8 4b 02 00 00       	call   801062a0 <uartintr>
    lapiceoi();
80106055:	e8 26 ce ff ff       	call   80102e80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010605a:	e8 91 de ff ff       	call   80103ef0 <myproc>
8010605f:	85 c0                	test   %eax,%eax
80106061:	0f 85 7c fe ff ff    	jne    80105ee3 <trap+0x43>
80106067:	e9 91 fe ff ff       	jmp    80105efd <trap+0x5d>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106070:	e8 db cc ff ff       	call   80102d50 <kbdintr>
    lapiceoi();
80106075:	e8 06 ce ff ff       	call   80102e80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010607a:	e8 71 de ff ff       	call   80103ef0 <myproc>
8010607f:	85 c0                	test   %eax,%eax
80106081:	0f 85 5c fe ff ff    	jne    80105ee3 <trap+0x43>
80106087:	e9 71 fe ff ff       	jmp    80105efd <trap+0x5d>
8010608c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106090:	e8 3b de ff ff       	call   80103ed0 <cpuid>
80106095:	85 c0                	test   %eax,%eax
80106097:	0f 85 38 fe ff ff    	jne    80105ed5 <trap+0x35>
      acquire(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 80 4c 11 80       	push   $0x80114c80
801060a5:	e8 86 ea ff ff       	call   80104b30 <acquire>
      ticks++;
801060aa:	83 05 60 4c 11 80 01 	addl   $0x1,0x80114c60
      wakeup(&ticks);
801060b1:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801060b8:	e8 b3 e5 ff ff       	call   80104670 <wakeup>
      release(&tickslock);
801060bd:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
801060c4:	e8 07 ea ff ff       	call   80104ad0 <release>
801060c9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801060cc:	e9 04 fe ff ff       	jmp    80105ed5 <trap+0x35>
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801060d8:	e8 23 e2 ff ff       	call   80104300 <exit>
801060dd:	e9 1b fe ff ff       	jmp    80105efd <trap+0x5d>
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060e8:	e8 13 e2 ff ff       	call   80104300 <exit>
801060ed:	e9 2e ff ff ff       	jmp    80106020 <trap+0x180>
801060f2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060f5:	e8 d6 dd ff ff       	call   80103ed0 <cpuid>
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	56                   	push   %esi
801060fe:	57                   	push   %edi
801060ff:	50                   	push   %eax
80106100:	ff 73 30             	push   0x30(%ebx)
80106103:	68 60 7d 10 80       	push   $0x80107d60
80106108:	e8 53 a6 ff ff       	call   80100760 <cprintf>
      panic("trap");
8010610d:	83 c4 14             	add    $0x14,%esp
80106110:	68 f3 7a 10 80       	push   $0x80107af3
80106115:	e8 56 a2 ff ff       	call   80100370 <panic>
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106120:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 17                	je     80106140 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106129:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010612e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010612f:	a8 01                	test   $0x1,%al
80106131:	74 0d                	je     80106140 <uartgetc+0x20>
80106133:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106138:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106139:	0f b6 c0             	movzbl %al,%eax
8010613c:	c3                   	ret
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c3                   	ret
80106146:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010614d:	00 
8010614e:	66 90                	xchg   %ax,%ax

80106150 <uartinit>:
{
80106150:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106151:	31 c9                	xor    %ecx,%ecx
80106153:	89 c8                	mov    %ecx,%eax
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010615d:	56                   	push   %esi
8010615e:	89 fa                	mov    %edi,%edx
80106160:	53                   	push   %ebx
80106161:	83 ec 1c             	sub    $0x1c,%esp
80106164:	ee                   	out    %al,(%dx)
80106165:	be fb 03 00 00       	mov    $0x3fb,%esi
8010616a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010616f:	89 f2                	mov    %esi,%edx
80106171:	ee                   	out    %al,(%dx)
80106172:	b8 0c 00 00 00       	mov    $0xc,%eax
80106177:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617c:	ee                   	out    %al,(%dx)
8010617d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106182:	89 c8                	mov    %ecx,%eax
80106184:	89 da                	mov    %ebx,%edx
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 03 00 00 00       	mov    $0x3,%eax
8010618c:	89 f2                	mov    %esi,%edx
8010618e:	ee                   	out    %al,(%dx)
8010618f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106194:	89 c8                	mov    %ecx,%eax
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 01 00 00 00       	mov    $0x1,%eax
8010619c:	89 da                	mov    %ebx,%edx
8010619e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061a5:	3c ff                	cmp    $0xff,%al
801061a7:	0f 84 7c 00 00 00    	je     80106229 <uartinit+0xd9>
  uart = 1;
801061ad:	c7 05 c0 54 11 80 01 	movl   $0x1,0x801154c0
801061b4:	00 00 00 
801061b7:	89 fa                	mov    %edi,%edx
801061b9:	ec                   	in     (%dx),%al
801061ba:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061c0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061c3:	bf f8 7a 10 80       	mov    $0x80107af8,%edi
801061c8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801061cd:	6a 00                	push   $0x0
801061cf:	6a 04                	push   $0x4
801061d1:	e8 1a c8 ff ff       	call   801029f0 <ioapicenable>
801061d6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801061d9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801061dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801061e0:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801061e5:	85 c0                	test   %eax,%eax
801061e7:	74 32                	je     8010621b <uartinit+0xcb>
801061e9:	89 f2                	mov    %esi,%edx
801061eb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ec:	a8 20                	test   $0x20,%al
801061ee:	75 21                	jne    80106211 <uartinit+0xc1>
801061f0:	bb 80 00 00 00       	mov    $0x80,%ebx
801061f5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801061f8:	83 ec 0c             	sub    $0xc,%esp
801061fb:	6a 0a                	push   $0xa
801061fd:	e8 9e cc ff ff       	call   80102ea0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106202:	83 c4 10             	add    $0x10,%esp
80106205:	83 eb 01             	sub    $0x1,%ebx
80106208:	74 07                	je     80106211 <uartinit+0xc1>
8010620a:	89 f2                	mov    %esi,%edx
8010620c:	ec                   	in     (%dx),%al
8010620d:	a8 20                	test   $0x20,%al
8010620f:	74 e7                	je     801061f8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106211:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106216:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010621a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010621b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010621f:	83 c7 01             	add    $0x1,%edi
80106222:	88 45 e7             	mov    %al,-0x19(%ebp)
80106225:	84 c0                	test   %al,%al
80106227:	75 b7                	jne    801061e0 <uartinit+0x90>
}
80106229:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010622c:	5b                   	pop    %ebx
8010622d:	5e                   	pop    %esi
8010622e:	5f                   	pop    %edi
8010622f:	5d                   	pop    %ebp
80106230:	c3                   	ret
80106231:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106238:	00 
80106239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106240 <uartputc>:
  if(!uart)
80106240:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106245:	85 c0                	test   %eax,%eax
80106247:	74 4f                	je     80106298 <uartputc+0x58>
{
80106249:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010624a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010624f:	89 e5                	mov    %esp,%ebp
80106251:	56                   	push   %esi
80106252:	53                   	push   %ebx
80106253:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106254:	a8 20                	test   $0x20,%al
80106256:	75 29                	jne    80106281 <uartputc+0x41>
80106258:	bb 80 00 00 00       	mov    $0x80,%ebx
8010625d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	6a 0a                	push   $0xa
8010626d:	e8 2e cc ff ff       	call   80102ea0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106272:	83 c4 10             	add    $0x10,%esp
80106275:	83 eb 01             	sub    $0x1,%ebx
80106278:	74 07                	je     80106281 <uartputc+0x41>
8010627a:	89 f2                	mov    %esi,%edx
8010627c:	ec                   	in     (%dx),%al
8010627d:	a8 20                	test   $0x20,%al
8010627f:	74 e7                	je     80106268 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106281:	8b 45 08             	mov    0x8(%ebp),%eax
80106284:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106289:	ee                   	out    %al,(%dx)
}
8010628a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010628d:	5b                   	pop    %ebx
8010628e:	5e                   	pop    %esi
8010628f:	5d                   	pop    %ebp
80106290:	c3                   	ret
80106291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106298:	c3                   	ret
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062a0 <uartintr>:

void
uartintr(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801062a6:	68 20 61 10 80       	push   $0x80106120
801062ab:	e8 c0 a6 ff ff       	call   80100970 <consoleintr>
}
801062b0:	83 c4 10             	add    $0x10,%esp
801062b3:	c9                   	leave
801062b4:	c3                   	ret

801062b5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $0
801062b7:	6a 00                	push   $0x0
  jmp alltraps
801062b9:	e9 0c fb ff ff       	jmp    80105dca <alltraps>

801062be <vector1>:
.globl vector1
vector1:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $1
801062c0:	6a 01                	push   $0x1
  jmp alltraps
801062c2:	e9 03 fb ff ff       	jmp    80105dca <alltraps>

801062c7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $2
801062c9:	6a 02                	push   $0x2
  jmp alltraps
801062cb:	e9 fa fa ff ff       	jmp    80105dca <alltraps>

801062d0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $3
801062d2:	6a 03                	push   $0x3
  jmp alltraps
801062d4:	e9 f1 fa ff ff       	jmp    80105dca <alltraps>

801062d9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $4
801062db:	6a 04                	push   $0x4
  jmp alltraps
801062dd:	e9 e8 fa ff ff       	jmp    80105dca <alltraps>

801062e2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $5
801062e4:	6a 05                	push   $0x5
  jmp alltraps
801062e6:	e9 df fa ff ff       	jmp    80105dca <alltraps>

801062eb <vector6>:
.globl vector6
vector6:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $6
801062ed:	6a 06                	push   $0x6
  jmp alltraps
801062ef:	e9 d6 fa ff ff       	jmp    80105dca <alltraps>

801062f4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $7
801062f6:	6a 07                	push   $0x7
  jmp alltraps
801062f8:	e9 cd fa ff ff       	jmp    80105dca <alltraps>

801062fd <vector8>:
.globl vector8
vector8:
  pushl $8
801062fd:	6a 08                	push   $0x8
  jmp alltraps
801062ff:	e9 c6 fa ff ff       	jmp    80105dca <alltraps>

80106304 <vector9>:
.globl vector9
vector9:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $9
80106306:	6a 09                	push   $0x9
  jmp alltraps
80106308:	e9 bd fa ff ff       	jmp    80105dca <alltraps>

8010630d <vector10>:
.globl vector10
vector10:
  pushl $10
8010630d:	6a 0a                	push   $0xa
  jmp alltraps
8010630f:	e9 b6 fa ff ff       	jmp    80105dca <alltraps>

80106314 <vector11>:
.globl vector11
vector11:
  pushl $11
80106314:	6a 0b                	push   $0xb
  jmp alltraps
80106316:	e9 af fa ff ff       	jmp    80105dca <alltraps>

8010631b <vector12>:
.globl vector12
vector12:
  pushl $12
8010631b:	6a 0c                	push   $0xc
  jmp alltraps
8010631d:	e9 a8 fa ff ff       	jmp    80105dca <alltraps>

80106322 <vector13>:
.globl vector13
vector13:
  pushl $13
80106322:	6a 0d                	push   $0xd
  jmp alltraps
80106324:	e9 a1 fa ff ff       	jmp    80105dca <alltraps>

80106329 <vector14>:
.globl vector14
vector14:
  pushl $14
80106329:	6a 0e                	push   $0xe
  jmp alltraps
8010632b:	e9 9a fa ff ff       	jmp    80105dca <alltraps>

80106330 <vector15>:
.globl vector15
vector15:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $15
80106332:	6a 0f                	push   $0xf
  jmp alltraps
80106334:	e9 91 fa ff ff       	jmp    80105dca <alltraps>

80106339 <vector16>:
.globl vector16
vector16:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $16
8010633b:	6a 10                	push   $0x10
  jmp alltraps
8010633d:	e9 88 fa ff ff       	jmp    80105dca <alltraps>

80106342 <vector17>:
.globl vector17
vector17:
  pushl $17
80106342:	6a 11                	push   $0x11
  jmp alltraps
80106344:	e9 81 fa ff ff       	jmp    80105dca <alltraps>

80106349 <vector18>:
.globl vector18
vector18:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $18
8010634b:	6a 12                	push   $0x12
  jmp alltraps
8010634d:	e9 78 fa ff ff       	jmp    80105dca <alltraps>

80106352 <vector19>:
.globl vector19
vector19:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $19
80106354:	6a 13                	push   $0x13
  jmp alltraps
80106356:	e9 6f fa ff ff       	jmp    80105dca <alltraps>

8010635b <vector20>:
.globl vector20
vector20:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $20
8010635d:	6a 14                	push   $0x14
  jmp alltraps
8010635f:	e9 66 fa ff ff       	jmp    80105dca <alltraps>

80106364 <vector21>:
.globl vector21
vector21:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $21
80106366:	6a 15                	push   $0x15
  jmp alltraps
80106368:	e9 5d fa ff ff       	jmp    80105dca <alltraps>

8010636d <vector22>:
.globl vector22
vector22:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $22
8010636f:	6a 16                	push   $0x16
  jmp alltraps
80106371:	e9 54 fa ff ff       	jmp    80105dca <alltraps>

80106376 <vector23>:
.globl vector23
vector23:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $23
80106378:	6a 17                	push   $0x17
  jmp alltraps
8010637a:	e9 4b fa ff ff       	jmp    80105dca <alltraps>

8010637f <vector24>:
.globl vector24
vector24:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $24
80106381:	6a 18                	push   $0x18
  jmp alltraps
80106383:	e9 42 fa ff ff       	jmp    80105dca <alltraps>

80106388 <vector25>:
.globl vector25
vector25:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $25
8010638a:	6a 19                	push   $0x19
  jmp alltraps
8010638c:	e9 39 fa ff ff       	jmp    80105dca <alltraps>

80106391 <vector26>:
.globl vector26
vector26:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $26
80106393:	6a 1a                	push   $0x1a
  jmp alltraps
80106395:	e9 30 fa ff ff       	jmp    80105dca <alltraps>

8010639a <vector27>:
.globl vector27
vector27:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $27
8010639c:	6a 1b                	push   $0x1b
  jmp alltraps
8010639e:	e9 27 fa ff ff       	jmp    80105dca <alltraps>

801063a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $28
801063a5:	6a 1c                	push   $0x1c
  jmp alltraps
801063a7:	e9 1e fa ff ff       	jmp    80105dca <alltraps>

801063ac <vector29>:
.globl vector29
vector29:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $29
801063ae:	6a 1d                	push   $0x1d
  jmp alltraps
801063b0:	e9 15 fa ff ff       	jmp    80105dca <alltraps>

801063b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $30
801063b7:	6a 1e                	push   $0x1e
  jmp alltraps
801063b9:	e9 0c fa ff ff       	jmp    80105dca <alltraps>

801063be <vector31>:
.globl vector31
vector31:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $31
801063c0:	6a 1f                	push   $0x1f
  jmp alltraps
801063c2:	e9 03 fa ff ff       	jmp    80105dca <alltraps>

801063c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $32
801063c9:	6a 20                	push   $0x20
  jmp alltraps
801063cb:	e9 fa f9 ff ff       	jmp    80105dca <alltraps>

801063d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $33
801063d2:	6a 21                	push   $0x21
  jmp alltraps
801063d4:	e9 f1 f9 ff ff       	jmp    80105dca <alltraps>

801063d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $34
801063db:	6a 22                	push   $0x22
  jmp alltraps
801063dd:	e9 e8 f9 ff ff       	jmp    80105dca <alltraps>

801063e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $35
801063e4:	6a 23                	push   $0x23
  jmp alltraps
801063e6:	e9 df f9 ff ff       	jmp    80105dca <alltraps>

801063eb <vector36>:
.globl vector36
vector36:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $36
801063ed:	6a 24                	push   $0x24
  jmp alltraps
801063ef:	e9 d6 f9 ff ff       	jmp    80105dca <alltraps>

801063f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $37
801063f6:	6a 25                	push   $0x25
  jmp alltraps
801063f8:	e9 cd f9 ff ff       	jmp    80105dca <alltraps>

801063fd <vector38>:
.globl vector38
vector38:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $38
801063ff:	6a 26                	push   $0x26
  jmp alltraps
80106401:	e9 c4 f9 ff ff       	jmp    80105dca <alltraps>

80106406 <vector39>:
.globl vector39
vector39:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $39
80106408:	6a 27                	push   $0x27
  jmp alltraps
8010640a:	e9 bb f9 ff ff       	jmp    80105dca <alltraps>

8010640f <vector40>:
.globl vector40
vector40:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $40
80106411:	6a 28                	push   $0x28
  jmp alltraps
80106413:	e9 b2 f9 ff ff       	jmp    80105dca <alltraps>

80106418 <vector41>:
.globl vector41
vector41:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $41
8010641a:	6a 29                	push   $0x29
  jmp alltraps
8010641c:	e9 a9 f9 ff ff       	jmp    80105dca <alltraps>

80106421 <vector42>:
.globl vector42
vector42:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $42
80106423:	6a 2a                	push   $0x2a
  jmp alltraps
80106425:	e9 a0 f9 ff ff       	jmp    80105dca <alltraps>

8010642a <vector43>:
.globl vector43
vector43:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $43
8010642c:	6a 2b                	push   $0x2b
  jmp alltraps
8010642e:	e9 97 f9 ff ff       	jmp    80105dca <alltraps>

80106433 <vector44>:
.globl vector44
vector44:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $44
80106435:	6a 2c                	push   $0x2c
  jmp alltraps
80106437:	e9 8e f9 ff ff       	jmp    80105dca <alltraps>

8010643c <vector45>:
.globl vector45
vector45:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $45
8010643e:	6a 2d                	push   $0x2d
  jmp alltraps
80106440:	e9 85 f9 ff ff       	jmp    80105dca <alltraps>

80106445 <vector46>:
.globl vector46
vector46:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $46
80106447:	6a 2e                	push   $0x2e
  jmp alltraps
80106449:	e9 7c f9 ff ff       	jmp    80105dca <alltraps>

8010644e <vector47>:
.globl vector47
vector47:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $47
80106450:	6a 2f                	push   $0x2f
  jmp alltraps
80106452:	e9 73 f9 ff ff       	jmp    80105dca <alltraps>

80106457 <vector48>:
.globl vector48
vector48:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $48
80106459:	6a 30                	push   $0x30
  jmp alltraps
8010645b:	e9 6a f9 ff ff       	jmp    80105dca <alltraps>

80106460 <vector49>:
.globl vector49
vector49:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $49
80106462:	6a 31                	push   $0x31
  jmp alltraps
80106464:	e9 61 f9 ff ff       	jmp    80105dca <alltraps>

80106469 <vector50>:
.globl vector50
vector50:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $50
8010646b:	6a 32                	push   $0x32
  jmp alltraps
8010646d:	e9 58 f9 ff ff       	jmp    80105dca <alltraps>

80106472 <vector51>:
.globl vector51
vector51:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $51
80106474:	6a 33                	push   $0x33
  jmp alltraps
80106476:	e9 4f f9 ff ff       	jmp    80105dca <alltraps>

8010647b <vector52>:
.globl vector52
vector52:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $52
8010647d:	6a 34                	push   $0x34
  jmp alltraps
8010647f:	e9 46 f9 ff ff       	jmp    80105dca <alltraps>

80106484 <vector53>:
.globl vector53
vector53:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $53
80106486:	6a 35                	push   $0x35
  jmp alltraps
80106488:	e9 3d f9 ff ff       	jmp    80105dca <alltraps>

8010648d <vector54>:
.globl vector54
vector54:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $54
8010648f:	6a 36                	push   $0x36
  jmp alltraps
80106491:	e9 34 f9 ff ff       	jmp    80105dca <alltraps>

80106496 <vector55>:
.globl vector55
vector55:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $55
80106498:	6a 37                	push   $0x37
  jmp alltraps
8010649a:	e9 2b f9 ff ff       	jmp    80105dca <alltraps>

8010649f <vector56>:
.globl vector56
vector56:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $56
801064a1:	6a 38                	push   $0x38
  jmp alltraps
801064a3:	e9 22 f9 ff ff       	jmp    80105dca <alltraps>

801064a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $57
801064aa:	6a 39                	push   $0x39
  jmp alltraps
801064ac:	e9 19 f9 ff ff       	jmp    80105dca <alltraps>

801064b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $58
801064b3:	6a 3a                	push   $0x3a
  jmp alltraps
801064b5:	e9 10 f9 ff ff       	jmp    80105dca <alltraps>

801064ba <vector59>:
.globl vector59
vector59:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $59
801064bc:	6a 3b                	push   $0x3b
  jmp alltraps
801064be:	e9 07 f9 ff ff       	jmp    80105dca <alltraps>

801064c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $60
801064c5:	6a 3c                	push   $0x3c
  jmp alltraps
801064c7:	e9 fe f8 ff ff       	jmp    80105dca <alltraps>

801064cc <vector61>:
.globl vector61
vector61:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $61
801064ce:	6a 3d                	push   $0x3d
  jmp alltraps
801064d0:	e9 f5 f8 ff ff       	jmp    80105dca <alltraps>

801064d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $62
801064d7:	6a 3e                	push   $0x3e
  jmp alltraps
801064d9:	e9 ec f8 ff ff       	jmp    80105dca <alltraps>

801064de <vector63>:
.globl vector63
vector63:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $63
801064e0:	6a 3f                	push   $0x3f
  jmp alltraps
801064e2:	e9 e3 f8 ff ff       	jmp    80105dca <alltraps>

801064e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $64
801064e9:	6a 40                	push   $0x40
  jmp alltraps
801064eb:	e9 da f8 ff ff       	jmp    80105dca <alltraps>

801064f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $65
801064f2:	6a 41                	push   $0x41
  jmp alltraps
801064f4:	e9 d1 f8 ff ff       	jmp    80105dca <alltraps>

801064f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $66
801064fb:	6a 42                	push   $0x42
  jmp alltraps
801064fd:	e9 c8 f8 ff ff       	jmp    80105dca <alltraps>

80106502 <vector67>:
.globl vector67
vector67:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $67
80106504:	6a 43                	push   $0x43
  jmp alltraps
80106506:	e9 bf f8 ff ff       	jmp    80105dca <alltraps>

8010650b <vector68>:
.globl vector68
vector68:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $68
8010650d:	6a 44                	push   $0x44
  jmp alltraps
8010650f:	e9 b6 f8 ff ff       	jmp    80105dca <alltraps>

80106514 <vector69>:
.globl vector69
vector69:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $69
80106516:	6a 45                	push   $0x45
  jmp alltraps
80106518:	e9 ad f8 ff ff       	jmp    80105dca <alltraps>

8010651d <vector70>:
.globl vector70
vector70:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $70
8010651f:	6a 46                	push   $0x46
  jmp alltraps
80106521:	e9 a4 f8 ff ff       	jmp    80105dca <alltraps>

80106526 <vector71>:
.globl vector71
vector71:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $71
80106528:	6a 47                	push   $0x47
  jmp alltraps
8010652a:	e9 9b f8 ff ff       	jmp    80105dca <alltraps>

8010652f <vector72>:
.globl vector72
vector72:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $72
80106531:	6a 48                	push   $0x48
  jmp alltraps
80106533:	e9 92 f8 ff ff       	jmp    80105dca <alltraps>

80106538 <vector73>:
.globl vector73
vector73:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $73
8010653a:	6a 49                	push   $0x49
  jmp alltraps
8010653c:	e9 89 f8 ff ff       	jmp    80105dca <alltraps>

80106541 <vector74>:
.globl vector74
vector74:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $74
80106543:	6a 4a                	push   $0x4a
  jmp alltraps
80106545:	e9 80 f8 ff ff       	jmp    80105dca <alltraps>

8010654a <vector75>:
.globl vector75
vector75:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $75
8010654c:	6a 4b                	push   $0x4b
  jmp alltraps
8010654e:	e9 77 f8 ff ff       	jmp    80105dca <alltraps>

80106553 <vector76>:
.globl vector76
vector76:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $76
80106555:	6a 4c                	push   $0x4c
  jmp alltraps
80106557:	e9 6e f8 ff ff       	jmp    80105dca <alltraps>

8010655c <vector77>:
.globl vector77
vector77:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $77
8010655e:	6a 4d                	push   $0x4d
  jmp alltraps
80106560:	e9 65 f8 ff ff       	jmp    80105dca <alltraps>

80106565 <vector78>:
.globl vector78
vector78:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $78
80106567:	6a 4e                	push   $0x4e
  jmp alltraps
80106569:	e9 5c f8 ff ff       	jmp    80105dca <alltraps>

8010656e <vector79>:
.globl vector79
vector79:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $79
80106570:	6a 4f                	push   $0x4f
  jmp alltraps
80106572:	e9 53 f8 ff ff       	jmp    80105dca <alltraps>

80106577 <vector80>:
.globl vector80
vector80:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $80
80106579:	6a 50                	push   $0x50
  jmp alltraps
8010657b:	e9 4a f8 ff ff       	jmp    80105dca <alltraps>

80106580 <vector81>:
.globl vector81
vector81:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $81
80106582:	6a 51                	push   $0x51
  jmp alltraps
80106584:	e9 41 f8 ff ff       	jmp    80105dca <alltraps>

80106589 <vector82>:
.globl vector82
vector82:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $82
8010658b:	6a 52                	push   $0x52
  jmp alltraps
8010658d:	e9 38 f8 ff ff       	jmp    80105dca <alltraps>

80106592 <vector83>:
.globl vector83
vector83:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $83
80106594:	6a 53                	push   $0x53
  jmp alltraps
80106596:	e9 2f f8 ff ff       	jmp    80105dca <alltraps>

8010659b <vector84>:
.globl vector84
vector84:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $84
8010659d:	6a 54                	push   $0x54
  jmp alltraps
8010659f:	e9 26 f8 ff ff       	jmp    80105dca <alltraps>

801065a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $85
801065a6:	6a 55                	push   $0x55
  jmp alltraps
801065a8:	e9 1d f8 ff ff       	jmp    80105dca <alltraps>

801065ad <vector86>:
.globl vector86
vector86:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $86
801065af:	6a 56                	push   $0x56
  jmp alltraps
801065b1:	e9 14 f8 ff ff       	jmp    80105dca <alltraps>

801065b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $87
801065b8:	6a 57                	push   $0x57
  jmp alltraps
801065ba:	e9 0b f8 ff ff       	jmp    80105dca <alltraps>

801065bf <vector88>:
.globl vector88
vector88:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $88
801065c1:	6a 58                	push   $0x58
  jmp alltraps
801065c3:	e9 02 f8 ff ff       	jmp    80105dca <alltraps>

801065c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $89
801065ca:	6a 59                	push   $0x59
  jmp alltraps
801065cc:	e9 f9 f7 ff ff       	jmp    80105dca <alltraps>

801065d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $90
801065d3:	6a 5a                	push   $0x5a
  jmp alltraps
801065d5:	e9 f0 f7 ff ff       	jmp    80105dca <alltraps>

801065da <vector91>:
.globl vector91
vector91:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $91
801065dc:	6a 5b                	push   $0x5b
  jmp alltraps
801065de:	e9 e7 f7 ff ff       	jmp    80105dca <alltraps>

801065e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $92
801065e5:	6a 5c                	push   $0x5c
  jmp alltraps
801065e7:	e9 de f7 ff ff       	jmp    80105dca <alltraps>

801065ec <vector93>:
.globl vector93
vector93:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $93
801065ee:	6a 5d                	push   $0x5d
  jmp alltraps
801065f0:	e9 d5 f7 ff ff       	jmp    80105dca <alltraps>

801065f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $94
801065f7:	6a 5e                	push   $0x5e
  jmp alltraps
801065f9:	e9 cc f7 ff ff       	jmp    80105dca <alltraps>

801065fe <vector95>:
.globl vector95
vector95:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $95
80106600:	6a 5f                	push   $0x5f
  jmp alltraps
80106602:	e9 c3 f7 ff ff       	jmp    80105dca <alltraps>

80106607 <vector96>:
.globl vector96
vector96:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $96
80106609:	6a 60                	push   $0x60
  jmp alltraps
8010660b:	e9 ba f7 ff ff       	jmp    80105dca <alltraps>

80106610 <vector97>:
.globl vector97
vector97:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $97
80106612:	6a 61                	push   $0x61
  jmp alltraps
80106614:	e9 b1 f7 ff ff       	jmp    80105dca <alltraps>

80106619 <vector98>:
.globl vector98
vector98:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $98
8010661b:	6a 62                	push   $0x62
  jmp alltraps
8010661d:	e9 a8 f7 ff ff       	jmp    80105dca <alltraps>

80106622 <vector99>:
.globl vector99
vector99:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $99
80106624:	6a 63                	push   $0x63
  jmp alltraps
80106626:	e9 9f f7 ff ff       	jmp    80105dca <alltraps>

8010662b <vector100>:
.globl vector100
vector100:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $100
8010662d:	6a 64                	push   $0x64
  jmp alltraps
8010662f:	e9 96 f7 ff ff       	jmp    80105dca <alltraps>

80106634 <vector101>:
.globl vector101
vector101:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $101
80106636:	6a 65                	push   $0x65
  jmp alltraps
80106638:	e9 8d f7 ff ff       	jmp    80105dca <alltraps>

8010663d <vector102>:
.globl vector102
vector102:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $102
8010663f:	6a 66                	push   $0x66
  jmp alltraps
80106641:	e9 84 f7 ff ff       	jmp    80105dca <alltraps>

80106646 <vector103>:
.globl vector103
vector103:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $103
80106648:	6a 67                	push   $0x67
  jmp alltraps
8010664a:	e9 7b f7 ff ff       	jmp    80105dca <alltraps>

8010664f <vector104>:
.globl vector104
vector104:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $104
80106651:	6a 68                	push   $0x68
  jmp alltraps
80106653:	e9 72 f7 ff ff       	jmp    80105dca <alltraps>

80106658 <vector105>:
.globl vector105
vector105:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $105
8010665a:	6a 69                	push   $0x69
  jmp alltraps
8010665c:	e9 69 f7 ff ff       	jmp    80105dca <alltraps>

80106661 <vector106>:
.globl vector106
vector106:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $106
80106663:	6a 6a                	push   $0x6a
  jmp alltraps
80106665:	e9 60 f7 ff ff       	jmp    80105dca <alltraps>

8010666a <vector107>:
.globl vector107
vector107:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $107
8010666c:	6a 6b                	push   $0x6b
  jmp alltraps
8010666e:	e9 57 f7 ff ff       	jmp    80105dca <alltraps>

80106673 <vector108>:
.globl vector108
vector108:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $108
80106675:	6a 6c                	push   $0x6c
  jmp alltraps
80106677:	e9 4e f7 ff ff       	jmp    80105dca <alltraps>

8010667c <vector109>:
.globl vector109
vector109:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $109
8010667e:	6a 6d                	push   $0x6d
  jmp alltraps
80106680:	e9 45 f7 ff ff       	jmp    80105dca <alltraps>

80106685 <vector110>:
.globl vector110
vector110:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $110
80106687:	6a 6e                	push   $0x6e
  jmp alltraps
80106689:	e9 3c f7 ff ff       	jmp    80105dca <alltraps>

8010668e <vector111>:
.globl vector111
vector111:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $111
80106690:	6a 6f                	push   $0x6f
  jmp alltraps
80106692:	e9 33 f7 ff ff       	jmp    80105dca <alltraps>

80106697 <vector112>:
.globl vector112
vector112:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $112
80106699:	6a 70                	push   $0x70
  jmp alltraps
8010669b:	e9 2a f7 ff ff       	jmp    80105dca <alltraps>

801066a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $113
801066a2:	6a 71                	push   $0x71
  jmp alltraps
801066a4:	e9 21 f7 ff ff       	jmp    80105dca <alltraps>

801066a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $114
801066ab:	6a 72                	push   $0x72
  jmp alltraps
801066ad:	e9 18 f7 ff ff       	jmp    80105dca <alltraps>

801066b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $115
801066b4:	6a 73                	push   $0x73
  jmp alltraps
801066b6:	e9 0f f7 ff ff       	jmp    80105dca <alltraps>

801066bb <vector116>:
.globl vector116
vector116:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $116
801066bd:	6a 74                	push   $0x74
  jmp alltraps
801066bf:	e9 06 f7 ff ff       	jmp    80105dca <alltraps>

801066c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $117
801066c6:	6a 75                	push   $0x75
  jmp alltraps
801066c8:	e9 fd f6 ff ff       	jmp    80105dca <alltraps>

801066cd <vector118>:
.globl vector118
vector118:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $118
801066cf:	6a 76                	push   $0x76
  jmp alltraps
801066d1:	e9 f4 f6 ff ff       	jmp    80105dca <alltraps>

801066d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $119
801066d8:	6a 77                	push   $0x77
  jmp alltraps
801066da:	e9 eb f6 ff ff       	jmp    80105dca <alltraps>

801066df <vector120>:
.globl vector120
vector120:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $120
801066e1:	6a 78                	push   $0x78
  jmp alltraps
801066e3:	e9 e2 f6 ff ff       	jmp    80105dca <alltraps>

801066e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $121
801066ea:	6a 79                	push   $0x79
  jmp alltraps
801066ec:	e9 d9 f6 ff ff       	jmp    80105dca <alltraps>

801066f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $122
801066f3:	6a 7a                	push   $0x7a
  jmp alltraps
801066f5:	e9 d0 f6 ff ff       	jmp    80105dca <alltraps>

801066fa <vector123>:
.globl vector123
vector123:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $123
801066fc:	6a 7b                	push   $0x7b
  jmp alltraps
801066fe:	e9 c7 f6 ff ff       	jmp    80105dca <alltraps>

80106703 <vector124>:
.globl vector124
vector124:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $124
80106705:	6a 7c                	push   $0x7c
  jmp alltraps
80106707:	e9 be f6 ff ff       	jmp    80105dca <alltraps>

8010670c <vector125>:
.globl vector125
vector125:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $125
8010670e:	6a 7d                	push   $0x7d
  jmp alltraps
80106710:	e9 b5 f6 ff ff       	jmp    80105dca <alltraps>

80106715 <vector126>:
.globl vector126
vector126:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $126
80106717:	6a 7e                	push   $0x7e
  jmp alltraps
80106719:	e9 ac f6 ff ff       	jmp    80105dca <alltraps>

8010671e <vector127>:
.globl vector127
vector127:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $127
80106720:	6a 7f                	push   $0x7f
  jmp alltraps
80106722:	e9 a3 f6 ff ff       	jmp    80105dca <alltraps>

80106727 <vector128>:
.globl vector128
vector128:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $128
80106729:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010672e:	e9 97 f6 ff ff       	jmp    80105dca <alltraps>

80106733 <vector129>:
.globl vector129
vector129:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $129
80106735:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010673a:	e9 8b f6 ff ff       	jmp    80105dca <alltraps>

8010673f <vector130>:
.globl vector130
vector130:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $130
80106741:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106746:	e9 7f f6 ff ff       	jmp    80105dca <alltraps>

8010674b <vector131>:
.globl vector131
vector131:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $131
8010674d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106752:	e9 73 f6 ff ff       	jmp    80105dca <alltraps>

80106757 <vector132>:
.globl vector132
vector132:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $132
80106759:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010675e:	e9 67 f6 ff ff       	jmp    80105dca <alltraps>

80106763 <vector133>:
.globl vector133
vector133:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $133
80106765:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010676a:	e9 5b f6 ff ff       	jmp    80105dca <alltraps>

8010676f <vector134>:
.globl vector134
vector134:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $134
80106771:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106776:	e9 4f f6 ff ff       	jmp    80105dca <alltraps>

8010677b <vector135>:
.globl vector135
vector135:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $135
8010677d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106782:	e9 43 f6 ff ff       	jmp    80105dca <alltraps>

80106787 <vector136>:
.globl vector136
vector136:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $136
80106789:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010678e:	e9 37 f6 ff ff       	jmp    80105dca <alltraps>

80106793 <vector137>:
.globl vector137
vector137:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $137
80106795:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010679a:	e9 2b f6 ff ff       	jmp    80105dca <alltraps>

8010679f <vector138>:
.globl vector138
vector138:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $138
801067a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801067a6:	e9 1f f6 ff ff       	jmp    80105dca <alltraps>

801067ab <vector139>:
.globl vector139
vector139:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $139
801067ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067b2:	e9 13 f6 ff ff       	jmp    80105dca <alltraps>

801067b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $140
801067b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067be:	e9 07 f6 ff ff       	jmp    80105dca <alltraps>

801067c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $141
801067c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067ca:	e9 fb f5 ff ff       	jmp    80105dca <alltraps>

801067cf <vector142>:
.globl vector142
vector142:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $142
801067d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067d6:	e9 ef f5 ff ff       	jmp    80105dca <alltraps>

801067db <vector143>:
.globl vector143
vector143:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $143
801067dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067e2:	e9 e3 f5 ff ff       	jmp    80105dca <alltraps>

801067e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $144
801067e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067ee:	e9 d7 f5 ff ff       	jmp    80105dca <alltraps>

801067f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $145
801067f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067fa:	e9 cb f5 ff ff       	jmp    80105dca <alltraps>

801067ff <vector146>:
.globl vector146
vector146:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $146
80106801:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106806:	e9 bf f5 ff ff       	jmp    80105dca <alltraps>

8010680b <vector147>:
.globl vector147
vector147:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $147
8010680d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106812:	e9 b3 f5 ff ff       	jmp    80105dca <alltraps>

80106817 <vector148>:
.globl vector148
vector148:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $148
80106819:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010681e:	e9 a7 f5 ff ff       	jmp    80105dca <alltraps>

80106823 <vector149>:
.globl vector149
vector149:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $149
80106825:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010682a:	e9 9b f5 ff ff       	jmp    80105dca <alltraps>

8010682f <vector150>:
.globl vector150
vector150:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $150
80106831:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106836:	e9 8f f5 ff ff       	jmp    80105dca <alltraps>

8010683b <vector151>:
.globl vector151
vector151:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $151
8010683d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106842:	e9 83 f5 ff ff       	jmp    80105dca <alltraps>

80106847 <vector152>:
.globl vector152
vector152:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $152
80106849:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010684e:	e9 77 f5 ff ff       	jmp    80105dca <alltraps>

80106853 <vector153>:
.globl vector153
vector153:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $153
80106855:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010685a:	e9 6b f5 ff ff       	jmp    80105dca <alltraps>

8010685f <vector154>:
.globl vector154
vector154:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $154
80106861:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106866:	e9 5f f5 ff ff       	jmp    80105dca <alltraps>

8010686b <vector155>:
.globl vector155
vector155:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $155
8010686d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106872:	e9 53 f5 ff ff       	jmp    80105dca <alltraps>

80106877 <vector156>:
.globl vector156
vector156:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $156
80106879:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010687e:	e9 47 f5 ff ff       	jmp    80105dca <alltraps>

80106883 <vector157>:
.globl vector157
vector157:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $157
80106885:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010688a:	e9 3b f5 ff ff       	jmp    80105dca <alltraps>

8010688f <vector158>:
.globl vector158
vector158:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $158
80106891:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106896:	e9 2f f5 ff ff       	jmp    80105dca <alltraps>

8010689b <vector159>:
.globl vector159
vector159:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $159
8010689d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801068a2:	e9 23 f5 ff ff       	jmp    80105dca <alltraps>

801068a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $160
801068a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801068ae:	e9 17 f5 ff ff       	jmp    80105dca <alltraps>

801068b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $161
801068b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068ba:	e9 0b f5 ff ff       	jmp    80105dca <alltraps>

801068bf <vector162>:
.globl vector162
vector162:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $162
801068c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068c6:	e9 ff f4 ff ff       	jmp    80105dca <alltraps>

801068cb <vector163>:
.globl vector163
vector163:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $163
801068cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068d2:	e9 f3 f4 ff ff       	jmp    80105dca <alltraps>

801068d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $164
801068d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068de:	e9 e7 f4 ff ff       	jmp    80105dca <alltraps>

801068e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $165
801068e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068ea:	e9 db f4 ff ff       	jmp    80105dca <alltraps>

801068ef <vector166>:
.globl vector166
vector166:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $166
801068f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068f6:	e9 cf f4 ff ff       	jmp    80105dca <alltraps>

801068fb <vector167>:
.globl vector167
vector167:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $167
801068fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106902:	e9 c3 f4 ff ff       	jmp    80105dca <alltraps>

80106907 <vector168>:
.globl vector168
vector168:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $168
80106909:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010690e:	e9 b7 f4 ff ff       	jmp    80105dca <alltraps>

80106913 <vector169>:
.globl vector169
vector169:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $169
80106915:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010691a:	e9 ab f4 ff ff       	jmp    80105dca <alltraps>

8010691f <vector170>:
.globl vector170
vector170:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $170
80106921:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106926:	e9 9f f4 ff ff       	jmp    80105dca <alltraps>

8010692b <vector171>:
.globl vector171
vector171:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $171
8010692d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106932:	e9 93 f4 ff ff       	jmp    80105dca <alltraps>

80106937 <vector172>:
.globl vector172
vector172:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $172
80106939:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010693e:	e9 87 f4 ff ff       	jmp    80105dca <alltraps>

80106943 <vector173>:
.globl vector173
vector173:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $173
80106945:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010694a:	e9 7b f4 ff ff       	jmp    80105dca <alltraps>

8010694f <vector174>:
.globl vector174
vector174:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $174
80106951:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106956:	e9 6f f4 ff ff       	jmp    80105dca <alltraps>

8010695b <vector175>:
.globl vector175
vector175:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $175
8010695d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106962:	e9 63 f4 ff ff       	jmp    80105dca <alltraps>

80106967 <vector176>:
.globl vector176
vector176:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $176
80106969:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010696e:	e9 57 f4 ff ff       	jmp    80105dca <alltraps>

80106973 <vector177>:
.globl vector177
vector177:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $177
80106975:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010697a:	e9 4b f4 ff ff       	jmp    80105dca <alltraps>

8010697f <vector178>:
.globl vector178
vector178:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $178
80106981:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106986:	e9 3f f4 ff ff       	jmp    80105dca <alltraps>

8010698b <vector179>:
.globl vector179
vector179:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $179
8010698d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106992:	e9 33 f4 ff ff       	jmp    80105dca <alltraps>

80106997 <vector180>:
.globl vector180
vector180:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $180
80106999:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010699e:	e9 27 f4 ff ff       	jmp    80105dca <alltraps>

801069a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $181
801069a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801069aa:	e9 1b f4 ff ff       	jmp    80105dca <alltraps>

801069af <vector182>:
.globl vector182
vector182:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $182
801069b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069b6:	e9 0f f4 ff ff       	jmp    80105dca <alltraps>

801069bb <vector183>:
.globl vector183
vector183:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $183
801069bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069c2:	e9 03 f4 ff ff       	jmp    80105dca <alltraps>

801069c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $184
801069c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069ce:	e9 f7 f3 ff ff       	jmp    80105dca <alltraps>

801069d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $185
801069d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069da:	e9 eb f3 ff ff       	jmp    80105dca <alltraps>

801069df <vector186>:
.globl vector186
vector186:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $186
801069e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069e6:	e9 df f3 ff ff       	jmp    80105dca <alltraps>

801069eb <vector187>:
.globl vector187
vector187:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $187
801069ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069f2:	e9 d3 f3 ff ff       	jmp    80105dca <alltraps>

801069f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $188
801069f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069fe:	e9 c7 f3 ff ff       	jmp    80105dca <alltraps>

80106a03 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $189
80106a05:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a0a:	e9 bb f3 ff ff       	jmp    80105dca <alltraps>

80106a0f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $190
80106a11:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a16:	e9 af f3 ff ff       	jmp    80105dca <alltraps>

80106a1b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $191
80106a1d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a22:	e9 a3 f3 ff ff       	jmp    80105dca <alltraps>

80106a27 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $192
80106a29:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a2e:	e9 97 f3 ff ff       	jmp    80105dca <alltraps>

80106a33 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $193
80106a35:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a3a:	e9 8b f3 ff ff       	jmp    80105dca <alltraps>

80106a3f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $194
80106a41:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a46:	e9 7f f3 ff ff       	jmp    80105dca <alltraps>

80106a4b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $195
80106a4d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a52:	e9 73 f3 ff ff       	jmp    80105dca <alltraps>

80106a57 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $196
80106a59:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a5e:	e9 67 f3 ff ff       	jmp    80105dca <alltraps>

80106a63 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $197
80106a65:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a6a:	e9 5b f3 ff ff       	jmp    80105dca <alltraps>

80106a6f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $198
80106a71:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a76:	e9 4f f3 ff ff       	jmp    80105dca <alltraps>

80106a7b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $199
80106a7d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a82:	e9 43 f3 ff ff       	jmp    80105dca <alltraps>

80106a87 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $200
80106a89:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a8e:	e9 37 f3 ff ff       	jmp    80105dca <alltraps>

80106a93 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $201
80106a95:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a9a:	e9 2b f3 ff ff       	jmp    80105dca <alltraps>

80106a9f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $202
80106aa1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106aa6:	e9 1f f3 ff ff       	jmp    80105dca <alltraps>

80106aab <vector203>:
.globl vector203
vector203:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $203
80106aad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ab2:	e9 13 f3 ff ff       	jmp    80105dca <alltraps>

80106ab7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $204
80106ab9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106abe:	e9 07 f3 ff ff       	jmp    80105dca <alltraps>

80106ac3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $205
80106ac5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aca:	e9 fb f2 ff ff       	jmp    80105dca <alltraps>

80106acf <vector206>:
.globl vector206
vector206:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $206
80106ad1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ad6:	e9 ef f2 ff ff       	jmp    80105dca <alltraps>

80106adb <vector207>:
.globl vector207
vector207:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $207
80106add:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ae2:	e9 e3 f2 ff ff       	jmp    80105dca <alltraps>

80106ae7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $208
80106ae9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106aee:	e9 d7 f2 ff ff       	jmp    80105dca <alltraps>

80106af3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $209
80106af5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106afa:	e9 cb f2 ff ff       	jmp    80105dca <alltraps>

80106aff <vector210>:
.globl vector210
vector210:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $210
80106b01:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b06:	e9 bf f2 ff ff       	jmp    80105dca <alltraps>

80106b0b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $211
80106b0d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b12:	e9 b3 f2 ff ff       	jmp    80105dca <alltraps>

80106b17 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $212
80106b19:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b1e:	e9 a7 f2 ff ff       	jmp    80105dca <alltraps>

80106b23 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $213
80106b25:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b2a:	e9 9b f2 ff ff       	jmp    80105dca <alltraps>

80106b2f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $214
80106b31:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b36:	e9 8f f2 ff ff       	jmp    80105dca <alltraps>

80106b3b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $215
80106b3d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b42:	e9 83 f2 ff ff       	jmp    80105dca <alltraps>

80106b47 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $216
80106b49:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b4e:	e9 77 f2 ff ff       	jmp    80105dca <alltraps>

80106b53 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $217
80106b55:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b5a:	e9 6b f2 ff ff       	jmp    80105dca <alltraps>

80106b5f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $218
80106b61:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b66:	e9 5f f2 ff ff       	jmp    80105dca <alltraps>

80106b6b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $219
80106b6d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b72:	e9 53 f2 ff ff       	jmp    80105dca <alltraps>

80106b77 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $220
80106b79:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b7e:	e9 47 f2 ff ff       	jmp    80105dca <alltraps>

80106b83 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $221
80106b85:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b8a:	e9 3b f2 ff ff       	jmp    80105dca <alltraps>

80106b8f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $222
80106b91:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b96:	e9 2f f2 ff ff       	jmp    80105dca <alltraps>

80106b9b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $223
80106b9d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ba2:	e9 23 f2 ff ff       	jmp    80105dca <alltraps>

80106ba7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $224
80106ba9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106bae:	e9 17 f2 ff ff       	jmp    80105dca <alltraps>

80106bb3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $225
80106bb5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106bba:	e9 0b f2 ff ff       	jmp    80105dca <alltraps>

80106bbf <vector226>:
.globl vector226
vector226:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $226
80106bc1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bc6:	e9 ff f1 ff ff       	jmp    80105dca <alltraps>

80106bcb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $227
80106bcd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bd2:	e9 f3 f1 ff ff       	jmp    80105dca <alltraps>

80106bd7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $228
80106bd9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bde:	e9 e7 f1 ff ff       	jmp    80105dca <alltraps>

80106be3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $229
80106be5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bea:	e9 db f1 ff ff       	jmp    80105dca <alltraps>

80106bef <vector230>:
.globl vector230
vector230:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $230
80106bf1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bf6:	e9 cf f1 ff ff       	jmp    80105dca <alltraps>

80106bfb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $231
80106bfd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c02:	e9 c3 f1 ff ff       	jmp    80105dca <alltraps>

80106c07 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $232
80106c09:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c0e:	e9 b7 f1 ff ff       	jmp    80105dca <alltraps>

80106c13 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $233
80106c15:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c1a:	e9 ab f1 ff ff       	jmp    80105dca <alltraps>

80106c1f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $234
80106c21:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c26:	e9 9f f1 ff ff       	jmp    80105dca <alltraps>

80106c2b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $235
80106c2d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c32:	e9 93 f1 ff ff       	jmp    80105dca <alltraps>

80106c37 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $236
80106c39:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c3e:	e9 87 f1 ff ff       	jmp    80105dca <alltraps>

80106c43 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $237
80106c45:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c4a:	e9 7b f1 ff ff       	jmp    80105dca <alltraps>

80106c4f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $238
80106c51:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c56:	e9 6f f1 ff ff       	jmp    80105dca <alltraps>

80106c5b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $239
80106c5d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c62:	e9 63 f1 ff ff       	jmp    80105dca <alltraps>

80106c67 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $240
80106c69:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c6e:	e9 57 f1 ff ff       	jmp    80105dca <alltraps>

80106c73 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $241
80106c75:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c7a:	e9 4b f1 ff ff       	jmp    80105dca <alltraps>

80106c7f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $242
80106c81:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c86:	e9 3f f1 ff ff       	jmp    80105dca <alltraps>

80106c8b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $243
80106c8d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c92:	e9 33 f1 ff ff       	jmp    80105dca <alltraps>

80106c97 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $244
80106c99:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c9e:	e9 27 f1 ff ff       	jmp    80105dca <alltraps>

80106ca3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $245
80106ca5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106caa:	e9 1b f1 ff ff       	jmp    80105dca <alltraps>

80106caf <vector246>:
.globl vector246
vector246:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $246
80106cb1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106cb6:	e9 0f f1 ff ff       	jmp    80105dca <alltraps>

80106cbb <vector247>:
.globl vector247
vector247:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $247
80106cbd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cc2:	e9 03 f1 ff ff       	jmp    80105dca <alltraps>

80106cc7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $248
80106cc9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cce:	e9 f7 f0 ff ff       	jmp    80105dca <alltraps>

80106cd3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $249
80106cd5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cda:	e9 eb f0 ff ff       	jmp    80105dca <alltraps>

80106cdf <vector250>:
.globl vector250
vector250:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $250
80106ce1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ce6:	e9 df f0 ff ff       	jmp    80105dca <alltraps>

80106ceb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $251
80106ced:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cf2:	e9 d3 f0 ff ff       	jmp    80105dca <alltraps>

80106cf7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $252
80106cf9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cfe:	e9 c7 f0 ff ff       	jmp    80105dca <alltraps>

80106d03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $253
80106d05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d0a:	e9 bb f0 ff ff       	jmp    80105dca <alltraps>

80106d0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $254
80106d11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d16:	e9 af f0 ff ff       	jmp    80105dca <alltraps>

80106d1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $255
80106d1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d22:	e9 a3 f0 ff ff       	jmp    80105dca <alltraps>
80106d27:	66 90                	xchg   %ax,%ax
80106d29:	66 90                	xchg   %ax,%ax
80106d2b:	66 90                	xchg   %ax,%ax
80106d2d:	66 90                	xchg   %ax,%ax
80106d2f:	90                   	nop

80106d30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d42:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106d45:	39 d3                	cmp    %edx,%ebx
80106d47:	73 56                	jae    80106d9f <deallocuvm.part.0+0x6f>
80106d49:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106d4c:	89 c6                	mov    %eax,%esi
80106d4e:	89 d7                	mov    %edx,%edi
80106d50:	eb 12                	jmp    80106d64 <deallocuvm.part.0+0x34>
80106d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d58:	83 c2 01             	add    $0x1,%edx
80106d5b:	89 d3                	mov    %edx,%ebx
80106d5d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d60:	39 fb                	cmp    %edi,%ebx
80106d62:	73 38                	jae    80106d9c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106d64:	89 da                	mov    %ebx,%edx
80106d66:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d69:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106d6c:	a8 01                	test   $0x1,%al
80106d6e:	74 e8                	je     80106d58 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106d70:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106d77:	c1 e9 0a             	shr    $0xa,%ecx
80106d7a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106d80:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106d87:	85 c0                	test   %eax,%eax
80106d89:	74 cd                	je     80106d58 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106d8b:	8b 10                	mov    (%eax),%edx
80106d8d:	f6 c2 01             	test   $0x1,%dl
80106d90:	75 1e                	jne    80106db0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106d92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d98:	39 fb                	cmp    %edi,%ebx
80106d9a:	72 c8                	jb     80106d64 <deallocuvm.part.0+0x34>
80106d9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106da2:	89 c8                	mov    %ecx,%eax
80106da4:	5b                   	pop    %ebx
80106da5:	5e                   	pop    %esi
80106da6:	5f                   	pop    %edi
80106da7:	5d                   	pop    %ebp
80106da8:	c3                   	ret
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106db0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106db6:	74 26                	je     80106dde <deallocuvm.part.0+0xae>
      kfree(v);
80106db8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dbb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106dc4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106dca:	52                   	push   %edx
80106dcb:	e8 60 bc ff ff       	call   80102a30 <kfree>
      *pte = 0;
80106dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106dd3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106ddc:	eb 82                	jmp    80106d60 <deallocuvm.part.0+0x30>
        panic("kfree");
80106dde:	83 ec 0c             	sub    $0xc,%esp
80106de1:	68 cc 78 10 80       	push   $0x801078cc
80106de6:	e8 85 95 ff ff       	call   80100370 <panic>
80106deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106df0 <mappages>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106df6:	89 d3                	mov    %edx,%ebx
80106df8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dfe:	83 ec 1c             	sub    $0x1c,%esp
80106e01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e10:	8b 45 08             	mov    0x8(%ebp),%eax
80106e13:	29 d8                	sub    %ebx,%eax
80106e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e18:	eb 3f                	jmp    80106e59 <mappages+0x69>
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e20:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e27:	c1 ea 0a             	shr    $0xa,%edx
80106e2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e37:	85 c0                	test   %eax,%eax
80106e39:	74 75                	je     80106eb0 <mappages+0xc0>
    if(*pte & PTE_P)
80106e3b:	f6 00 01             	testb  $0x1,(%eax)
80106e3e:	0f 85 86 00 00 00    	jne    80106eca <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106e44:	0b 75 0c             	or     0xc(%ebp),%esi
80106e47:	83 ce 01             	or     $0x1,%esi
80106e4a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e4f:	39 c3                	cmp    %eax,%ebx
80106e51:	74 6d                	je     80106ec0 <mappages+0xd0>
    a += PGSIZE;
80106e53:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e5c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106e5f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106e62:	89 d8                	mov    %ebx,%eax
80106e64:	c1 e8 16             	shr    $0x16,%eax
80106e67:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e6a:	8b 07                	mov    (%edi),%eax
80106e6c:	a8 01                	test   $0x1,%al
80106e6e:	75 b0                	jne    80106e20 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e70:	e8 7b bd ff ff       	call   80102bf0 <kalloc>
80106e75:	85 c0                	test   %eax,%eax
80106e77:	74 37                	je     80106eb0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106e79:	83 ec 04             	sub    $0x4,%esp
80106e7c:	68 00 10 00 00       	push   $0x1000
80106e81:	6a 00                	push   $0x0
80106e83:	50                   	push   %eax
80106e84:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e87:	e8 a4 dd ff ff       	call   80104c30 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e8f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e92:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e98:	83 c8 07             	or     $0x7,%eax
80106e9b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e9d:	89 d8                	mov    %ebx,%eax
80106e9f:	c1 e8 0a             	shr    $0xa,%eax
80106ea2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ea7:	01 d0                	add    %edx,%eax
80106ea9:	eb 90                	jmp    80106e3b <mappages+0x4b>
80106eab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106eb8:	5b                   	pop    %ebx
80106eb9:	5e                   	pop    %esi
80106eba:	5f                   	pop    %edi
80106ebb:	5d                   	pop    %ebp
80106ebc:	c3                   	ret
80106ebd:	8d 76 00             	lea    0x0(%esi),%esi
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ec3:	31 c0                	xor    %eax,%eax
}
80106ec5:	5b                   	pop    %ebx
80106ec6:	5e                   	pop    %esi
80106ec7:	5f                   	pop    %edi
80106ec8:	5d                   	pop    %ebp
80106ec9:	c3                   	ret
      panic("remap");
80106eca:	83 ec 0c             	sub    $0xc,%esp
80106ecd:	68 00 7b 10 80       	push   $0x80107b00
80106ed2:	e8 99 94 ff ff       	call   80100370 <panic>
80106ed7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ede:	00 
80106edf:	90                   	nop

80106ee0 <seginit>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ee6:	e8 e5 cf ff ff       	call   80103ed0 <cpuid>
  pd[0] = size-1;
80106eeb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ef0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ef6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106efa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106f01:	ff 00 00 
80106f04:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106f0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f0e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106f15:	ff 00 00 
80106f18:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106f1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f22:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106f29:	ff 00 00 
80106f2c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106f33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f36:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106f3d:	ff 00 00 
80106f40:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106f47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f4a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106f4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f53:	c1 e8 10             	shr    $0x10,%eax
80106f56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f5d:	0f 01 10             	lgdtl  (%eax)
}
80106f60:	c9                   	leave
80106f61:	c3                   	ret
80106f62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f69:	00 
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f70:	a1 c4 54 11 80       	mov    0x801154c4,%eax
80106f75:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f7a:	0f 22 d8             	mov    %eax,%cr3
}
80106f7d:	c3                   	ret
80106f7e:	66 90                	xchg   %ax,%ax

80106f80 <switchuvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 1c             	sub    $0x1c,%esp
80106f89:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f8c:	85 f6                	test   %esi,%esi
80106f8e:	0f 84 cb 00 00 00    	je     8010705f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f94:	8b 46 08             	mov    0x8(%esi),%eax
80106f97:	85 c0                	test   %eax,%eax
80106f99:	0f 84 da 00 00 00    	je     80107079 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f9f:	8b 46 04             	mov    0x4(%esi),%eax
80106fa2:	85 c0                	test   %eax,%eax
80106fa4:	0f 84 c2 00 00 00    	je     8010706c <switchuvm+0xec>
  pushcli();
80106faa:	e8 31 da ff ff       	call   801049e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106faf:	e8 bc ce ff ff       	call   80103e70 <mycpu>
80106fb4:	89 c3                	mov    %eax,%ebx
80106fb6:	e8 b5 ce ff ff       	call   80103e70 <mycpu>
80106fbb:	89 c7                	mov    %eax,%edi
80106fbd:	e8 ae ce ff ff       	call   80103e70 <mycpu>
80106fc2:	83 c7 08             	add    $0x8,%edi
80106fc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fc8:	e8 a3 ce ff ff       	call   80103e70 <mycpu>
80106fcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fd0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fd5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fdc:	83 c0 08             	add    $0x8,%eax
80106fdf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fe6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106feb:	83 c1 08             	add    $0x8,%ecx
80106fee:	c1 e8 18             	shr    $0x18,%eax
80106ff1:	c1 e9 10             	shr    $0x10,%ecx
80106ff4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ffa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107000:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107005:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010700c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107011:	e8 5a ce ff ff       	call   80103e70 <mycpu>
80107016:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010701d:	e8 4e ce ff ff       	call   80103e70 <mycpu>
80107022:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107026:	8b 5e 08             	mov    0x8(%esi),%ebx
80107029:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010702f:	e8 3c ce ff ff       	call   80103e70 <mycpu>
80107034:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107037:	e8 34 ce ff ff       	call   80103e70 <mycpu>
8010703c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107040:	b8 28 00 00 00       	mov    $0x28,%eax
80107045:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107048:	8b 46 04             	mov    0x4(%esi),%eax
8010704b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107050:	0f 22 d8             	mov    %eax,%cr3
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	5b                   	pop    %ebx
80107057:	5e                   	pop    %esi
80107058:	5f                   	pop    %edi
80107059:	5d                   	pop    %ebp
  popcli();
8010705a:	e9 d1 d9 ff ff       	jmp    80104a30 <popcli>
    panic("switchuvm: no process");
8010705f:	83 ec 0c             	sub    $0xc,%esp
80107062:	68 06 7b 10 80       	push   $0x80107b06
80107067:	e8 04 93 ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
8010706c:	83 ec 0c             	sub    $0xc,%esp
8010706f:	68 31 7b 10 80       	push   $0x80107b31
80107074:	e8 f7 92 ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
80107079:	83 ec 0c             	sub    $0xc,%esp
8010707c:	68 1c 7b 10 80       	push   $0x80107b1c
80107081:	e8 ea 92 ff ff       	call   80100370 <panic>
80107086:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010708d:	00 
8010708e:	66 90                	xchg   %ax,%ax

80107090 <inituvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 1c             	sub    $0x1c,%esp
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
8010709c:	8b 75 10             	mov    0x10(%ebp),%esi
8010709f:	8b 7d 0c             	mov    0xc(%ebp),%edi
801070a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070a5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070ab:	77 49                	ja     801070f6 <inituvm+0x66>
  mem = kalloc();
801070ad:	e8 3e bb ff ff       	call   80102bf0 <kalloc>
  memset(mem, 0, PGSIZE);
801070b2:	83 ec 04             	sub    $0x4,%esp
801070b5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801070ba:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070bc:	6a 00                	push   $0x0
801070be:	50                   	push   %eax
801070bf:	e8 6c db ff ff       	call   80104c30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070c4:	58                   	pop    %eax
801070c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070cb:	5a                   	pop    %edx
801070cc:	6a 06                	push   $0x6
801070ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070d3:	31 d2                	xor    %edx,%edx
801070d5:	50                   	push   %eax
801070d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d9:	e8 12 fd ff ff       	call   80106df0 <mappages>
  memmove(mem, init, sz);
801070de:	83 c4 10             	add    $0x10,%esp
801070e1:	89 75 10             	mov    %esi,0x10(%ebp)
801070e4:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ed:	5b                   	pop    %ebx
801070ee:	5e                   	pop    %esi
801070ef:	5f                   	pop    %edi
801070f0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070f1:	e9 ca db ff ff       	jmp    80104cc0 <memmove>
    panic("inituvm: more than a page");
801070f6:	83 ec 0c             	sub    $0xc,%esp
801070f9:	68 45 7b 10 80       	push   $0x80107b45
801070fe:	e8 6d 92 ff ff       	call   80100370 <panic>
80107103:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010710a:	00 
8010710b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107110 <loaduvm>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107119:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010711c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010711f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107125:	0f 85 a2 00 00 00    	jne    801071cd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010712b:	85 ff                	test   %edi,%edi
8010712d:	74 7d                	je     801071ac <loaduvm+0x9c>
8010712f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107130:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107133:	8b 55 08             	mov    0x8(%ebp),%edx
80107136:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107138:	89 c1                	mov    %eax,%ecx
8010713a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010713d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107140:	f6 c1 01             	test   $0x1,%cl
80107143:	75 13                	jne    80107158 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107145:	83 ec 0c             	sub    $0xc,%esp
80107148:	68 5f 7b 10 80       	push   $0x80107b5f
8010714d:	e8 1e 92 ff ff       	call   80100370 <panic>
80107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107158:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010715b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107161:	25 fc 0f 00 00       	and    $0xffc,%eax
80107166:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010716d:	85 c9                	test   %ecx,%ecx
8010716f:	74 d4                	je     80107145 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107171:	89 fb                	mov    %edi,%ebx
80107173:	b8 00 10 00 00       	mov    $0x1000,%eax
80107178:	29 f3                	sub    %esi,%ebx
8010717a:	39 c3                	cmp    %eax,%ebx
8010717c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010717f:	53                   	push   %ebx
80107180:	8b 45 14             	mov    0x14(%ebp),%eax
80107183:	01 f0                	add    %esi,%eax
80107185:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107186:	8b 01                	mov    (%ecx),%eax
80107188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010718d:	05 00 00 00 80       	add    $0x80000000,%eax
80107192:	50                   	push   %eax
80107193:	ff 75 10             	push   0x10(%ebp)
80107196:	e8 a5 ae ff ff       	call   80102040 <readi>
8010719b:	83 c4 10             	add    $0x10,%esp
8010719e:	39 d8                	cmp    %ebx,%eax
801071a0:	75 1e                	jne    801071c0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801071a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071a8:	39 fe                	cmp    %edi,%esi
801071aa:	72 84                	jb     80107130 <loaduvm+0x20>
}
801071ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071af:	31 c0                	xor    %eax,%eax
}
801071b1:	5b                   	pop    %ebx
801071b2:	5e                   	pop    %esi
801071b3:	5f                   	pop    %edi
801071b4:	5d                   	pop    %ebp
801071b5:	c3                   	ret
801071b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071bd:	00 
801071be:	66 90                	xchg   %ax,%ax
801071c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071c8:	5b                   	pop    %ebx
801071c9:	5e                   	pop    %esi
801071ca:	5f                   	pop    %edi
801071cb:	5d                   	pop    %ebp
801071cc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801071cd:	83 ec 0c             	sub    $0xc,%esp
801071d0:	68 d8 7d 10 80       	push   $0x80107dd8
801071d5:	e8 96 91 ff ff       	call   80100370 <panic>
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <allocuvm>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
801071e9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801071ec:	85 f6                	test   %esi,%esi
801071ee:	0f 88 98 00 00 00    	js     8010728c <allocuvm+0xac>
801071f4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
801071f6:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071f9:	0f 82 a1 00 00 00    	jb     801072a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801071ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80107202:	05 ff 0f 00 00       	add    $0xfff,%eax
80107207:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010720c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010720e:	39 f0                	cmp    %esi,%eax
80107210:	0f 83 8d 00 00 00    	jae    801072a3 <allocuvm+0xc3>
80107216:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107219:	eb 44                	jmp    8010725f <allocuvm+0x7f>
8010721b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
80107223:	68 00 10 00 00       	push   $0x1000
80107228:	6a 00                	push   $0x0
8010722a:	50                   	push   %eax
8010722b:	e8 00 da ff ff       	call   80104c30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107230:	58                   	pop    %eax
80107231:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107237:	5a                   	pop    %edx
80107238:	6a 06                	push   $0x6
8010723a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010723f:	89 fa                	mov    %edi,%edx
80107241:	50                   	push   %eax
80107242:	8b 45 08             	mov    0x8(%ebp),%eax
80107245:	e8 a6 fb ff ff       	call   80106df0 <mappages>
8010724a:	83 c4 10             	add    $0x10,%esp
8010724d:	85 c0                	test   %eax,%eax
8010724f:	78 5f                	js     801072b0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107251:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107257:	39 f7                	cmp    %esi,%edi
80107259:	0f 83 89 00 00 00    	jae    801072e8 <allocuvm+0x108>
    mem = kalloc();
8010725f:	e8 8c b9 ff ff       	call   80102bf0 <kalloc>
80107264:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107266:	85 c0                	test   %eax,%eax
80107268:	75 b6                	jne    80107220 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	68 7d 7b 10 80       	push   $0x80107b7d
80107272:	e8 e9 94 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
80107277:	83 c4 10             	add    $0x10,%esp
8010727a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010727d:	74 0d                	je     8010728c <allocuvm+0xac>
8010727f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107282:	8b 45 08             	mov    0x8(%ebp),%eax
80107285:	89 f2                	mov    %esi,%edx
80107287:	e8 a4 fa ff ff       	call   80106d30 <deallocuvm.part.0>
    return 0;
8010728c:	31 d2                	xor    %edx,%edx
}
8010728e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107291:	89 d0                	mov    %edx,%eax
80107293:	5b                   	pop    %ebx
80107294:	5e                   	pop    %esi
80107295:	5f                   	pop    %edi
80107296:	5d                   	pop    %ebp
80107297:	c3                   	ret
80107298:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010729f:	00 
    return oldsz;
801072a0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801072a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a6:	89 d0                	mov    %edx,%eax
801072a8:	5b                   	pop    %ebx
801072a9:	5e                   	pop    %esi
801072aa:	5f                   	pop    %edi
801072ab:	5d                   	pop    %ebp
801072ac:	c3                   	ret
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	68 95 7b 10 80       	push   $0x80107b95
801072b8:	e8 a3 94 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
801072bd:	83 c4 10             	add    $0x10,%esp
801072c0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072c3:	74 0d                	je     801072d2 <allocuvm+0xf2>
801072c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072c8:	8b 45 08             	mov    0x8(%ebp),%eax
801072cb:	89 f2                	mov    %esi,%edx
801072cd:	e8 5e fa ff ff       	call   80106d30 <deallocuvm.part.0>
      kfree(mem);
801072d2:	83 ec 0c             	sub    $0xc,%esp
801072d5:	53                   	push   %ebx
801072d6:	e8 55 b7 ff ff       	call   80102a30 <kfree>
      return 0;
801072db:	83 c4 10             	add    $0x10,%esp
    return 0;
801072de:	31 d2                	xor    %edx,%edx
801072e0:	eb ac                	jmp    8010728e <allocuvm+0xae>
801072e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801072eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ee:	5b                   	pop    %ebx
801072ef:	5e                   	pop    %esi
801072f0:	89 d0                	mov    %edx,%eax
801072f2:	5f                   	pop    %edi
801072f3:	5d                   	pop    %ebp
801072f4:	c3                   	ret
801072f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072fc:	00 
801072fd:	8d 76 00             	lea    0x0(%esi),%esi

80107300 <deallocuvm>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	8b 55 0c             	mov    0xc(%ebp),%edx
80107306:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107309:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010730c:	39 d1                	cmp    %edx,%ecx
8010730e:	73 10                	jae    80107320 <deallocuvm+0x20>
}
80107310:	5d                   	pop    %ebp
80107311:	e9 1a fa ff ff       	jmp    80106d30 <deallocuvm.part.0>
80107316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731d:	00 
8010731e:	66 90                	xchg   %ax,%ax
80107320:	89 d0                	mov    %edx,%eax
80107322:	5d                   	pop    %ebp
80107323:	c3                   	ret
80107324:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010732b:	00 
8010732c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107330 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 0c             	sub    $0xc,%esp
80107339:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010733c:	85 f6                	test   %esi,%esi
8010733e:	74 59                	je     80107399 <freevm+0x69>
  if(newsz >= oldsz)
80107340:	31 c9                	xor    %ecx,%ecx
80107342:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107347:	89 f0                	mov    %esi,%eax
80107349:	89 f3                	mov    %esi,%ebx
8010734b:	e8 e0 f9 ff ff       	call   80106d30 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107350:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107356:	eb 0f                	jmp    80107367 <freevm+0x37>
80107358:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010735f:	00 
80107360:	83 c3 04             	add    $0x4,%ebx
80107363:	39 fb                	cmp    %edi,%ebx
80107365:	74 23                	je     8010738a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107367:	8b 03                	mov    (%ebx),%eax
80107369:	a8 01                	test   $0x1,%al
8010736b:	74 f3                	je     80107360 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010736d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107372:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107375:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107378:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010737d:	50                   	push   %eax
8010737e:	e8 ad b6 ff ff       	call   80102a30 <kfree>
80107383:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107386:	39 fb                	cmp    %edi,%ebx
80107388:	75 dd                	jne    80107367 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010738a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010738d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107390:	5b                   	pop    %ebx
80107391:	5e                   	pop    %esi
80107392:	5f                   	pop    %edi
80107393:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107394:	e9 97 b6 ff ff       	jmp    80102a30 <kfree>
    panic("freevm: no pgdir");
80107399:	83 ec 0c             	sub    $0xc,%esp
8010739c:	68 b1 7b 10 80       	push   $0x80107bb1
801073a1:	e8 ca 8f ff ff       	call   80100370 <panic>
801073a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073ad:	00 
801073ae:	66 90                	xchg   %ax,%ax

801073b0 <setupkvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	56                   	push   %esi
801073b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073b5:	e8 36 b8 ff ff       	call   80102bf0 <kalloc>
801073ba:	85 c0                	test   %eax,%eax
801073bc:	74 5e                	je     8010741c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801073be:	83 ec 04             	sub    $0x4,%esp
801073c1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073c8:	68 00 10 00 00       	push   $0x1000
801073cd:	6a 00                	push   $0x0
801073cf:	50                   	push   %eax
801073d0:	e8 5b d8 ff ff       	call   80104c30 <memset>
801073d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073db:	83 ec 08             	sub    $0x8,%esp
801073de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073e1:	8b 13                	mov    (%ebx),%edx
801073e3:	ff 73 0c             	push   0xc(%ebx)
801073e6:	50                   	push   %eax
801073e7:	29 c1                	sub    %eax,%ecx
801073e9:	89 f0                	mov    %esi,%eax
801073eb:	e8 00 fa ff ff       	call   80106df0 <mappages>
801073f0:	83 c4 10             	add    $0x10,%esp
801073f3:	85 c0                	test   %eax,%eax
801073f5:	78 19                	js     80107410 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073f7:	83 c3 10             	add    $0x10,%ebx
801073fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107400:	75 d6                	jne    801073d8 <setupkvm+0x28>
}
80107402:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107405:	89 f0                	mov    %esi,%eax
80107407:	5b                   	pop    %ebx
80107408:	5e                   	pop    %esi
80107409:	5d                   	pop    %ebp
8010740a:	c3                   	ret
8010740b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107410:	83 ec 0c             	sub    $0xc,%esp
80107413:	56                   	push   %esi
80107414:	e8 17 ff ff ff       	call   80107330 <freevm>
      return 0;
80107419:	83 c4 10             	add    $0x10,%esp
}
8010741c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010741f:	31 f6                	xor    %esi,%esi
}
80107421:	89 f0                	mov    %esi,%eax
80107423:	5b                   	pop    %ebx
80107424:	5e                   	pop    %esi
80107425:	5d                   	pop    %ebp
80107426:	c3                   	ret
80107427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010742e:	00 
8010742f:	90                   	nop

80107430 <kvmalloc>:
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107436:	e8 75 ff ff ff       	call   801073b0 <setupkvm>
8010743b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107440:	05 00 00 00 80       	add    $0x80000000,%eax
80107445:	0f 22 d8             	mov    %eax,%cr3
}
80107448:	c9                   	leave
80107449:	c3                   	ret
8010744a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107450 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	83 ec 08             	sub    $0x8,%esp
80107456:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107459:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010745c:	89 c1                	mov    %eax,%ecx
8010745e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107461:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107464:	f6 c2 01             	test   $0x1,%dl
80107467:	75 17                	jne    80107480 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107469:	83 ec 0c             	sub    $0xc,%esp
8010746c:	68 c2 7b 10 80       	push   $0x80107bc2
80107471:	e8 fa 8e ff ff       	call   80100370 <panic>
80107476:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010747d:	00 
8010747e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107480:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107483:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107489:	25 fc 0f 00 00       	and    $0xffc,%eax
8010748e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107495:	85 c0                	test   %eax,%eax
80107497:	74 d0                	je     80107469 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107499:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010749c:	c9                   	leave
8010749d:	c3                   	ret
8010749e:	66 90                	xchg   %ax,%ax

801074a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074a9:	e8 02 ff ff ff       	call   801073b0 <setupkvm>
801074ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074b1:	85 c0                	test   %eax,%eax
801074b3:	0f 84 e9 00 00 00    	je     801075a2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074bc:	85 c9                	test   %ecx,%ecx
801074be:	0f 84 b2 00 00 00    	je     80107576 <copyuvm+0xd6>
801074c4:	31 f6                	xor    %esi,%esi
801074c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074cd:	00 
801074ce:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801074d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074d3:	89 f0                	mov    %esi,%eax
801074d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074db:	a8 01                	test   $0x1,%al
801074dd:	75 11                	jne    801074f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074df:	83 ec 0c             	sub    $0xc,%esp
801074e2:	68 cc 7b 10 80       	push   $0x80107bcc
801074e7:	e8 84 8e ff ff       	call   80100370 <panic>
801074ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801074f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074f7:	c1 ea 0a             	shr    $0xa,%edx
801074fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107500:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107507:	85 c0                	test   %eax,%eax
80107509:	74 d4                	je     801074df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010750b:	8b 00                	mov    (%eax),%eax
8010750d:	a8 01                	test   $0x1,%al
8010750f:	0f 84 9f 00 00 00    	je     801075b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107515:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107517:	25 ff 0f 00 00       	and    $0xfff,%eax
8010751c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010751f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107525:	e8 c6 b6 ff ff       	call   80102bf0 <kalloc>
8010752a:	89 c3                	mov    %eax,%ebx
8010752c:	85 c0                	test   %eax,%eax
8010752e:	74 64                	je     80107594 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107530:	83 ec 04             	sub    $0x4,%esp
80107533:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107539:	68 00 10 00 00       	push   $0x1000
8010753e:	57                   	push   %edi
8010753f:	50                   	push   %eax
80107540:	e8 7b d7 ff ff       	call   80104cc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107545:	58                   	pop    %eax
80107546:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010754c:	5a                   	pop    %edx
8010754d:	ff 75 e4             	push   -0x1c(%ebp)
80107550:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107555:	89 f2                	mov    %esi,%edx
80107557:	50                   	push   %eax
80107558:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010755b:	e8 90 f8 ff ff       	call   80106df0 <mappages>
80107560:	83 c4 10             	add    $0x10,%esp
80107563:	85 c0                	test   %eax,%eax
80107565:	78 21                	js     80107588 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107567:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010756d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107570:	0f 82 5a ff ff ff    	jb     801074d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107576:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757c:	5b                   	pop    %ebx
8010757d:	5e                   	pop    %esi
8010757e:	5f                   	pop    %edi
8010757f:	5d                   	pop    %ebp
80107580:	c3                   	ret
80107581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107588:	83 ec 0c             	sub    $0xc,%esp
8010758b:	53                   	push   %ebx
8010758c:	e8 9f b4 ff ff       	call   80102a30 <kfree>
      goto bad;
80107591:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107594:	83 ec 0c             	sub    $0xc,%esp
80107597:	ff 75 e0             	push   -0x20(%ebp)
8010759a:	e8 91 fd ff ff       	call   80107330 <freevm>
  return 0;
8010759f:	83 c4 10             	add    $0x10,%esp
    return 0;
801075a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801075a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075af:	5b                   	pop    %ebx
801075b0:	5e                   	pop    %esi
801075b1:	5f                   	pop    %edi
801075b2:	5d                   	pop    %ebp
801075b3:	c3                   	ret
      panic("copyuvm: page not present");
801075b4:	83 ec 0c             	sub    $0xc,%esp
801075b7:	68 e6 7b 10 80       	push   $0x80107be6
801075bc:	e8 af 8d ff ff       	call   80100370 <panic>
801075c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075c8:	00 
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075d9:	89 c1                	mov    %eax,%ecx
801075db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075e1:	f6 c2 01             	test   $0x1,%dl
801075e4:	0f 84 f8 00 00 00    	je     801076e2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801075ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801075f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801075f9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107600:	89 d0                	mov    %edx,%eax
80107602:	f7 d2                	not    %edx
80107604:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107609:	05 00 00 00 80       	add    $0x80000000,%eax
8010760e:	83 e2 05             	and    $0x5,%edx
80107611:	ba 00 00 00 00       	mov    $0x0,%edx
80107616:	0f 45 c2             	cmovne %edx,%eax
}
80107619:	c3                   	ret
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107620 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 0c             	sub    $0xc,%esp
80107629:	8b 75 14             	mov    0x14(%ebp),%esi
8010762c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010762f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107632:	85 f6                	test   %esi,%esi
80107634:	75 51                	jne    80107687 <copyout+0x67>
80107636:	e9 9d 00 00 00       	jmp    801076d8 <copyout+0xb8>
8010763b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107646:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010764c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107652:	74 74                	je     801076c8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107654:	89 fb                	mov    %edi,%ebx
80107656:	29 c3                	sub    %eax,%ebx
80107658:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010765e:	39 f3                	cmp    %esi,%ebx
80107660:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107663:	29 f8                	sub    %edi,%eax
80107665:	83 ec 04             	sub    $0x4,%esp
80107668:	01 c1                	add    %eax,%ecx
8010766a:	53                   	push   %ebx
8010766b:	52                   	push   %edx
8010766c:	89 55 10             	mov    %edx,0x10(%ebp)
8010766f:	51                   	push   %ecx
80107670:	e8 4b d6 ff ff       	call   80104cc0 <memmove>
    len -= n;
    buf += n;
80107675:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107678:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010767e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107681:	01 da                	add    %ebx,%edx
  while(len > 0){
80107683:	29 de                	sub    %ebx,%esi
80107685:	74 51                	je     801076d8 <copyout+0xb8>
  if(*pde & PTE_P){
80107687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010768a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010768c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010768e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107691:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107697:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010769a:	f6 c1 01             	test   $0x1,%cl
8010769d:	0f 84 46 00 00 00    	je     801076e9 <copyout.cold>
  return &pgtab[PTX(va)];
801076a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076ab:	c1 eb 0c             	shr    $0xc,%ebx
801076ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076bb:	89 d9                	mov    %ebx,%ecx
801076bd:	f7 d1                	not    %ecx
801076bf:	83 e1 05             	and    $0x5,%ecx
801076c2:	0f 84 78 ff ff ff    	je     80107640 <copyout+0x20>
  }
  return 0;
}
801076c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076d0:	5b                   	pop    %ebx
801076d1:	5e                   	pop    %esi
801076d2:	5f                   	pop    %edi
801076d3:	5d                   	pop    %ebp
801076d4:	c3                   	ret
801076d5:	8d 76 00             	lea    0x0(%esi),%esi
801076d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076db:	31 c0                	xor    %eax,%eax
}
801076dd:	5b                   	pop    %ebx
801076de:	5e                   	pop    %esi
801076df:	5f                   	pop    %edi
801076e0:	5d                   	pop    %ebp
801076e1:	c3                   	ret

801076e2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076e2:	a1 00 00 00 00       	mov    0x0,%eax
801076e7:	0f 0b                	ud2

801076e9 <copyout.cold>:
801076e9:	a1 00 00 00 00       	mov    0x0,%eax
801076ee:	0f 0b                	ud2
