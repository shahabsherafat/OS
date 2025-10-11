
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
80100028:	bc d0 66 11 80       	mov    $0x801166d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 39 10 80       	mov    $0x80103930,%eax
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
8010004c:	68 60 7a 10 80       	push   $0x80107a60
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 55 4c 00 00       	call   80104cb0 <initlock>
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
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 e3 4a 00 00       	call   80104b80 <initsleeplock>
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
801000e4:	e8 b7 4d 00 00       	call   80104ea0 <acquire>
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
80100162:	e8 d9 4c 00 00       	call   80104e40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4a 00 00       	call   80104bc0 <acquiresleep>
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
8010018c:	e8 3f 2a 00 00       	call   80102bd0 <iderw>
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
801001a1:	68 6e 7a 10 80       	push   $0x80107a6e
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
801001be:	e8 9d 4a 00 00       	call   80104c60 <holdingsleep>
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
801001d4:	e9 f7 29 00 00       	jmp    80102bd0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 7a 10 80       	push   $0x80107a7f
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
801001ff:	e8 5c 4a 00 00       	call   80104c60 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 4a 00 00       	call   80104c20 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 80 4c 00 00       	call   80104ea0 <acquire>
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
80100269:	e9 d2 4b 00 00       	jmp    80104e40 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 7a 10 80       	push   $0x80107a86
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
80100290:	e8 eb 1e 00 00       	call   80102180 <iunlock>
  target = n;
  acquire(&cons.lock);
80100295:	c7 04 24 20 01 11 80 	movl   $0x80110120,(%esp)
8010029c:	e8 ff 4b 00 00       	call   80104ea0 <acquire>
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
801002c3:	68 20 01 11 80       	push   $0x80110120
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 4e 46 00 00       	call   80104920 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 3f 00 00       	call   80104260 <myproc>
801002e7:	8b 40 24             	mov    0x24(%eax),%eax
801002ea:	85 c0                	test   %eax,%eax
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 01 11 80       	push   $0x80110120
801002f6:	e8 45 4b 00 00       	call   80104e40 <release>
        ilock(ip);
801002fb:	89 3c 24             	mov    %edi,(%esp)
801002fe:	e8 9d 1d 00 00       	call   801020a0 <ilock>
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
8010033f:	68 20 01 11 80       	push   $0x80110120
80100344:	e8 f7 4a 00 00       	call   80104e40 <release>
  ilock(ip);
80100349:	89 3c 24             	mov    %edi,(%esp)
8010034c:	e8 4f 1d 00 00       	call   801020a0 <ilock>
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
80100379:	c7 05 54 01 11 80 00 	movl   $0x0,0x80110154
80100380:	00 00 00 
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 42 2e 00 00       	call   801031d0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 7a 10 80       	push   $0x80107a8d
80100397:	e8 c4 03 00 00       	call   80100760 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	push   0x8(%ebp)
801003a0:	e8 bb 03 00 00       	call   80100760 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 0f 7f 10 80 	movl   $0x80107f0f,(%esp)
801003ac:	e8 af 03 00 00       	call   80100760 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	8d 45 08             	lea    0x8(%ebp),%eax
801003b4:	5a                   	pop    %edx
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 13 49 00 00       	call   80104cd0 <getcallerpcs>
  for(i=0; i<10; i++)
801003bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003c5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003c8:	68 a1 7a 10 80       	push   $0x80107aa1
801003cd:	e8 8e 03 00 00       	call   80100760 <cprintf>
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
  panicked = 1;
801003d9:	c7 05 58 01 11 80 01 	movl   $0x1,0x80110158
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
80100425:	e8 86 61 00 00       	call   801065b0 <uartputc>
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
801004c9:	e8 e2 60 00 00       	call   801065b0 <uartputc>
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
8010050e:	68 a5 7a 10 80       	push   $0x80107aa5
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
8010053a:	e8 f1 4a 00 00       	call   80105030 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010053f:	b8 80 07 00 00       	mov    $0x780,%eax
80100544:	83 c4 0c             	add    $0xc,%esp
80100547:	29 d8                	sub    %ebx,%eax
80100549:	01 c0                	add    %eax,%eax
8010054b:	50                   	push   %eax
8010054c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100553:	6a 00                	push   $0x0
80100555:	50                   	push   %eax
80100556:	e8 45 4a 00 00       	call   80104fa0 <memset>
  outb(CRTPORT+1, pos);
8010055b:	83 c4 10             	add    $0x10,%esp
8010055e:	e9 27 ff ff ff       	jmp    8010048a <consputc.part.0+0x9a>
80100563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100568:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100570:	6a 08                	push   $0x8
80100572:	e8 39 60 00 00       	call   801065b0 <uartputc>
80100577:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010057e:	e8 2d 60 00 00       	call   801065b0 <uartputc>
80100583:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010058a:	e8 21 60 00 00       	call   801065b0 <uartputc>
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
8010061a:	e8 91 5f 00 00       	call   801065b0 <uartputc>
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
8010066f:	e8 0c 1b 00 00       	call   80102180 <iunlock>
  acquire(&cons.lock);
80100674:	c7 04 24 20 01 11 80 	movl   $0x80110120,(%esp)
8010067b:	e8 20 48 00 00       	call   80104ea0 <acquire>
  for(i = 0; i < n; i++)
80100680:	83 c4 10             	add    $0x10,%esp
80100683:	85 f6                	test   %esi,%esi
80100685:	7e 27                	jle    801006ae <consolewrite+0x4e>
80100687:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010068a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010068d:	8b 15 58 01 11 80    	mov    0x80110158,%edx
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
801006b1:	68 20 01 11 80       	push   $0x80110120
801006b6:	e8 85 47 00 00       	call   80104e40 <release>
  ilock(ip);
801006bb:	58                   	pop    %eax
801006bc:	ff 75 08             	push   0x8(%ebp)
801006bf:	e8 dc 19 00 00       	call   801020a0 <ilock>
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
801006fb:	0f b6 92 cc 7f 10 80 	movzbl -0x7fef8034(%edx),%edx
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
80100721:	8b 15 58 01 11 80    	mov    0x80110158,%edx
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
80100769:	8b 3d 54 01 11 80    	mov    0x80110154,%edi
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
801007f0:	8b 3d 58 01 11 80    	mov    0x80110158,%edi
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
8010080f:	8b 3d 58 01 11 80    	mov    0x80110158,%edi
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
8010082e:	8b 15 58 01 11 80    	mov    0x80110158,%edx
80100834:	85 d2                	test   %edx,%edx
80100836:	0f 85 e8 00 00 00    	jne    80100924 <cprintf+0x1c4>
8010083c:	31 d2                	xor    %edx,%edx
8010083e:	b8 25 00 00 00       	mov    $0x25,%eax
80100843:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100846:	e8 a5 fb ff ff       	call   801003f0 <consputc.part.0>
8010084b:	a1 58 01 11 80       	mov    0x80110158,%eax
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
80100883:	68 20 01 11 80       	push   $0x80110120
80100888:	e8 13 46 00 00       	call   80104ea0 <acquire>
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
801008a6:	68 20 01 11 80       	push   $0x80110120
801008ab:	e8 90 45 00 00       	call   80104e40 <release>
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
801008d5:	8b 15 58 01 11 80    	mov    0x80110158,%edx
801008db:	85 d2                	test   %edx,%edx
801008dd:	74 26                	je     80100905 <cprintf+0x1a5>
801008df:	fa                   	cli
    for(;;)
801008e0:	eb fe                	jmp    801008e0 <cprintf+0x180>
801008e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
801008e8:	bf b8 7a 10 80       	mov    $0x80107ab8,%edi
801008ed:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801008f0:	b8 28 00 00 00       	mov    $0x28,%eax
801008f5:	89 fb                	mov    %edi,%ebx
801008f7:	89 f7                	mov    %esi,%edi
801008f9:	89 d6                	mov    %edx,%esi
  if(panicked){
801008fb:	8b 15 58 01 11 80    	mov    0x80110158,%edx
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
80100965:	68 bf 7a 10 80       	push   $0x80107abf
8010096a:	e8 01 fa ff ff       	call   80100370 <panic>
8010096f:	90                   	nop

80100970 <consoleintr>:
{
80100970:	55                   	push   %ebp
80100971:	89 e5                	mov    %esp,%ebp
80100973:	57                   	push   %edi
80100974:	56                   	push   %esi
80100975:	53                   	push   %ebx
80100976:	83 ec 38             	sub    $0x38,%esp
80100979:	8b 45 08             	mov    0x8(%ebp),%eax
8010097c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&cons.lock);
8010097f:	68 20 01 11 80       	push   $0x80110120
80100984:	e8 17 45 00 00       	call   80104ea0 <acquire>
  while((c = getc()) >= 0){
80100989:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010098c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((c = getc()) >= 0){
80100993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100996:	ff d0                	call   *%eax
80100998:	89 c3                	mov    %eax,%ebx
8010099a:	85 c0                	test   %eax,%eax
8010099c:	0f 88 46 03 00 00    	js     80100ce8 <consoleintr+0x378>
    switch(c){
801009a2:	83 fb 1a             	cmp    $0x1a,%ebx
801009a5:	7f 19                	jg     801009c0 <consoleintr+0x50>
801009a7:	85 db                	test   %ebx,%ebx
801009a9:	74 e8                	je     80100993 <consoleintr+0x23>
801009ab:	83 fb 1a             	cmp    $0x1a,%ebx
801009ae:	77 30                	ja     801009e0 <consoleintr+0x70>
801009b0:	ff 24 9d 60 7f 10 80 	jmp    *-0x7fef80a0(,%ebx,4)
801009b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801009be:	00 
801009bf:	90                   	nop
801009c0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
801009c6:	74 70                	je     80100a38 <consoleintr+0xc8>
801009c8:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
801009ce:	0f 84 3c 03 00 00    	je     80100d10 <consoleintr+0x3a0>
801009d4:	83 fb 7f             	cmp    $0x7f,%ebx
801009d7:	0f 84 8b 00 00 00    	je     80100a68 <consoleintr+0xf8>
801009dd:	8d 76 00             	lea    0x0(%esi),%esi
      if(input.e < input.real_end){
801009e0:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
801009e5:	8b 35 08 ff 10 80    	mov    0x8010ff08,%esi
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
801009eb:	89 c2                	mov    %eax,%edx
801009ed:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
      if(input.e < input.real_end){
801009f3:	39 c6                	cmp    %eax,%esi
801009f5:	0f 83 a5 04 00 00    	jae    80100ea0 <consoleintr+0x530>
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
801009fb:	83 fa 7f             	cmp    $0x7f,%edx
801009fe:	77 93                	ja     80100993 <consoleintr+0x23>
  if(panicked){
80100a00:	8b 3d 58 01 11 80    	mov    0x80110158,%edi
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a06:	8d 48 01             	lea    0x1(%eax),%ecx
          if(c != '\n'){
80100a09:	83 fb 0a             	cmp    $0xa,%ebx
80100a0c:	0f 85 6e 06 00 00    	jne    80101080 <consoleintr+0x710>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80100a12:	83 e0 7f             	and    $0x7f,%eax
80100a15:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80100a1b:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
80100a22:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
  if(panicked){
80100a28:	85 ff                	test   %edi,%edi
80100a2a:	0f 84 44 08 00 00    	je     80101274 <consoleintr+0x904>
80100a30:	fa                   	cli
    for(;;)
80100a31:	eb fe                	jmp    80100a31 <consoleintr+0xc1>
80100a33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e > input.w){
80100a38:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a3d:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100a43:	0f 83 4a ff ff ff    	jae    80100993 <consoleintr+0x23>
        input.e--;
80100a49:	83 e8 01             	sub    $0x1,%eax
80100a4c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a51:	a1 58 01 11 80       	mov    0x80110158,%eax
80100a56:	85 c0                	test   %eax,%eax
80100a58:	0f 84 c5 04 00 00    	je     80100f23 <consoleintr+0x5b3>
80100a5e:	fa                   	cli
    for(;;)
80100a5f:	eb fe                	jmp    80100a5f <consoleintr+0xef>
80100a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w) {
80100a68:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
80100a6e:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
80100a74:	39 f1                	cmp    %esi,%ecx
80100a76:	0f 84 17 ff ff ff    	je     80100993 <consoleintr+0x23>
        if (input.e == input.real_end) {
80100a7c:	8b 15 0c ff 10 80    	mov    0x8010ff0c,%edx
          input.e--;
80100a82:	8d 79 ff             	lea    -0x1(%ecx),%edi
80100a85:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
          input.real_end--;
80100a8b:	8d 5a ff             	lea    -0x1(%edx),%ebx
        if (input.e == input.real_end) {
80100a8e:	39 d1                	cmp    %edx,%ecx
80100a90:	0f 84 f2 03 00 00    	je     80100e88 <consoleintr+0x518>
          for (uint i = input.e; i < input.real_end - 1; i++) {
80100a96:	89 f8                	mov    %edi,%eax
80100a98:	39 df                	cmp    %ebx,%edi
80100a9a:	73 41                	jae    80100add <consoleintr+0x16d>
80100a9c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80100a9f:	89 75 d8             	mov    %esi,-0x28(%ebp)
80100aa2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100aa8:	89 c1                	mov    %eax,%ecx
80100aaa:	83 c0 01             	add    $0x1,%eax
80100aad:	89 c6                	mov    %eax,%esi
80100aaf:	83 e1 7f             	and    $0x7f,%ecx
80100ab2:	83 e6 7f             	and    $0x7f,%esi
80100ab5:	0f b6 96 80 fe 10 80 	movzbl -0x7fef0180(%esi),%edx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100abc:	8b 34 b5 10 ff 10 80 	mov    -0x7fef00f0(,%esi,4),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100ac3:	88 91 80 fe 10 80    	mov    %dl,-0x7fef0180(%ecx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100ac9:	89 34 8d 10 ff 10 80 	mov    %esi,-0x7fef00f0(,%ecx,4)
          for (uint i = input.e; i < input.real_end - 1; i++) {
80100ad0:	39 d8                	cmp    %ebx,%eax
80100ad2:	75 d4                	jne    80100aa8 <consoleintr+0x138>
80100ad4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80100ad7:	8b 75 d8             	mov    -0x28(%ebp),%esi
80100ada:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          input.real_end--;
80100add:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
          if (input.e > input.real_end) input.e = input.real_end;
80100ae3:	39 fb                	cmp    %edi,%ebx
80100ae5:	0f 82 15 04 00 00    	jb     80100f00 <consoleintr+0x590>
          int old_cursor_off = old_e - (int)input.w;
80100aeb:	89 c8                	mov    %ecx,%eax
          if (old_cursor_off < 0) old_cursor_off = 0;
80100aed:	31 c9                	xor    %ecx,%ecx
          int old_cursor_off = old_e - (int)input.w;
80100aef:	29 f0                	sub    %esi,%eax
          if (old_cursor_off < 0) old_cursor_off = 0;
80100af1:	85 c0                	test   %eax,%eax
80100af3:	0f 49 c8             	cmovns %eax,%ecx
80100af6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
          for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);
80100af9:	b9 00 00 00 00       	mov    $0x0,%ecx
80100afe:	0f 8e 44 03 00 00    	jle    80100e48 <consoleintr+0x4d8>
80100b04:	89 75 d8             	mov    %esi,-0x28(%ebp)
80100b07:	89 d6                	mov    %edx,%esi
80100b09:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80100b0c:	89 cb                	mov    %ecx,%ebx
  if(panicked){
80100b0e:	8b 15 58 01 11 80    	mov    0x80110158,%edx
80100b14:	85 d2                	test   %edx,%edx
80100b16:	0f 84 0c 03 00 00    	je     80100e28 <consoleintr+0x4b8>
80100b1c:	fa                   	cli
    for(;;)
80100b1d:	eb fe                	jmp    80100b1d <consoleintr+0x1ad>
80100b1f:	90                   	nop
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100b20:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b25:	89 c2                	mov    %eax,%edx
80100b27:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100b2d:	0f 83 60 fe ff ff    	jae    80100993 <consoleintr+0x23>
80100b33:	83 e2 7f             	and    $0x7f,%edx
80100b36:	0f be 92 80 fe 10 80 	movsbl -0x7fef0180(%edx),%edx
80100b3d:	80 fa 20             	cmp    $0x20,%dl
80100b40:	0f 84 b7 02 00 00    	je     80100dfd <consoleintr+0x48d>
80100b46:	80 fa 0a             	cmp    $0xa,%dl
80100b49:	0f 84 ae 02 00 00    	je     80100dfd <consoleintr+0x48d>
  if(panicked){
80100b4f:	a1 58 01 11 80       	mov    0x80110158,%eax
80100b54:	85 c0                	test   %eax,%eax
80100b56:	0f 84 15 02 00 00    	je     80100d71 <consoleintr+0x401>
80100b5c:	fa                   	cli
    for(;;)
80100b5d:	eb fe                	jmp    80100b5d <consoleintr+0x1ed>
80100b5f:	90                   	nop
      if(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100b60:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b65:	89 c2                	mov    %eax,%edx
80100b67:	85 c0                	test   %eax,%eax
80100b69:	0f 84 24 fe ff ff    	je     80100993 <consoleintr+0x23>
80100b6f:	8d 48 ff             	lea    -0x1(%eax),%ecx
80100b72:	83 e1 7f             	and    $0x7f,%ecx
80100b75:	80 b9 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%ecx)
80100b7c:	0f 84 0e 04 00 00    	je     80100f90 <consoleintr+0x620>
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100b82:	83 e2 7f             	and    $0x7f,%edx
80100b85:	80 ba 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%edx)
80100b8c:	0f 85 b3 03 00 00    	jne    80100f45 <consoleintr+0x5d5>
  if(panicked){
80100b92:	8b 3d 58 01 11 80    	mov    0x80110158,%edi
80100b98:	85 ff                	test   %edi,%edi
80100b9a:	0f 84 00 02 00 00    	je     80100da0 <consoleintr+0x430>
80100ba0:	fa                   	cli
    for(;;)
80100ba1:	eb fe                	jmp    80100ba1 <consoleintr+0x231>
80100ba3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.real_end > input.w) {
80100ba8:	8b 1d 0c ff 10 80    	mov    0x8010ff0c,%ebx
80100bae:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
80100bb4:	39 de                	cmp    %ebx,%esi
80100bb6:	0f 83 d7 fd ff ff    	jae    80100993 <consoleintr+0x23>
        for (uint i = input.w; i < input.real_end; i++) {
80100bbc:	89 f0                	mov    %esi,%eax
        int max_t = -1, idx = -1;
80100bbe:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80100bc3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80100bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100bcf:	00 
          int t = input.insert_order[i % INPUT_BUF];
80100bd0:	89 c2                	mov    %eax,%edx
80100bd2:	83 e2 7f             	and    $0x7f,%edx
80100bd5:	8b 14 95 10 ff 10 80 	mov    -0x7fef00f0(,%edx,4),%edx
          if (t > max_t) {
80100bdc:	39 fa                	cmp    %edi,%edx
80100bde:	7e 04                	jle    80100be4 <consoleintr+0x274>
            idx = (int)i;
80100be0:	89 c1                	mov    %eax,%ecx
            max_t = t;
80100be2:	89 d7                	mov    %edx,%edi
        for (uint i = input.w; i < input.real_end; i++) {
80100be4:	83 c0 01             	add    $0x1,%eax
80100be7:	39 c3                	cmp    %eax,%ebx
80100be9:	75 e5                	jne    80100bd0 <consoleintr+0x260>
        if (idx >= 0) {
80100beb:	85 c9                	test   %ecx,%ecx
80100bed:	0f 88 a0 fd ff ff    	js     80100993 <consoleintr+0x23>
          int old_e = (int)input.e;
80100bf3:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
          for (int i = idx; i < old_real_end - 1; i++) {
80100bf9:	8d 7b ff             	lea    -0x1(%ebx),%edi
80100bfc:	89 c8                	mov    %ecx,%eax
          int old_e = (int)input.e;
80100bfe:	89 55 dc             	mov    %edx,-0x24(%ebp)
          for (int i = idx; i < old_real_end - 1; i++) {
80100c01:	39 f9                	cmp    %edi,%ecx
80100c03:	7d 3e                	jge    80100c43 <consoleintr+0x2d3>
80100c05:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80100c08:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80100c0b:	89 55 d0             	mov    %edx,-0x30(%ebp)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100c0e:	89 c1                	mov    %eax,%ecx
80100c10:	83 c0 01             	add    $0x1,%eax
80100c13:	89 c3                	mov    %eax,%ebx
80100c15:	83 e1 7f             	and    $0x7f,%ecx
80100c18:	83 e3 7f             	and    $0x7f,%ebx
80100c1b:	0f b6 93 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%edx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100c22:	8b 1c 9d 10 ff 10 80 	mov    -0x7fef00f0(,%ebx,4),%ebx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100c29:	88 91 80 fe 10 80    	mov    %dl,-0x7fef0180(%ecx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80100c2f:	89 1c 8d 10 ff 10 80 	mov    %ebx,-0x7fef00f0(,%ecx,4)
          for (int i = idx; i < old_real_end - 1; i++) {
80100c36:	39 f8                	cmp    %edi,%eax
80100c38:	75 d4                	jne    80100c0e <consoleintr+0x29e>
80100c3a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80100c3d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80100c40:	8b 55 d0             	mov    -0x30(%ebp),%edx
          input.real_end--;
80100c43:	89 3d 0c ff 10 80    	mov    %edi,0x8010ff0c
          if ((int)input.e > idx) 
80100c49:	39 d1                	cmp    %edx,%ecx
80100c4b:	7d 09                	jge    80100c56 <consoleintr+0x2e6>
              input.e--;
80100c4d:	83 ea 01             	sub    $0x1,%edx
80100c50:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          if (input.e < input.w) 
80100c56:	39 f2                	cmp    %esi,%edx
80100c58:	73 08                	jae    80100c62 <consoleintr+0x2f2>
              input.e = input.w;
80100c5a:	89 35 08 ff 10 80    	mov    %esi,0x8010ff08
80100c60:	89 f2                	mov    %esi,%edx
          if (input.e > input.real_end) 
80100c62:	39 d7                	cmp    %edx,%edi
80100c64:	73 08                	jae    80100c6e <consoleintr+0x2fe>
              input.e = input.real_end;
80100c66:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
80100c6c:	89 fa                	mov    %edi,%edx
          int old_cursor_off = old_e - (int)input.w;
80100c6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
          if (old_cursor_off < 0) 
80100c71:	31 c9                	xor    %ecx,%ecx
          int old_cursor_off = old_e - (int)input.w;
80100c73:	29 f0                	sub    %esi,%eax
          if (old_cursor_off < 0) 
80100c75:	85 c0                	test   %eax,%eax
80100c77:	0f 49 c8             	cmovns %eax,%ecx
80100c7a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
          for (int i = 0; i < old_cursor_off; i++) 
80100c7d:	b9 00 00 00 00       	mov    $0x0,%ecx
80100c82:	0f 8e 38 03 00 00    	jle    80100fc0 <consoleintr+0x650>
80100c88:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80100c8b:	89 cb                	mov    %ecx,%ebx
80100c8d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100c90:	89 d7                	mov    %edx,%edi
  if(panicked){
80100c92:	a1 58 01 11 80       	mov    0x80110158,%eax
80100c97:	85 c0                	test   %eax,%eax
80100c99:	0f 84 01 03 00 00    	je     80100fa0 <consoleintr+0x630>
80100c9f:	fa                   	cli
    for(;;)
80100ca0:	eb fe                	jmp    80100ca0 <consoleintr+0x330>
80100ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100ca8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100cad:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
80100cb3:	0f 84 a4 00 00 00    	je     80100d5d <consoleintr+0x3ed>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100cb9:	8d 50 ff             	lea    -0x1(%eax),%edx
80100cbc:	89 d1                	mov    %edx,%ecx
80100cbe:	83 e1 7f             	and    $0x7f,%ecx
      while(input.e != input.w &&
80100cc1:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
80100cc8:	0f 84 8f 00 00 00    	je     80100d5d <consoleintr+0x3ed>
  if(panicked){
80100cce:	8b 1d 58 01 11 80    	mov    0x80110158,%ebx
        input.e--;
80100cd4:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if(panicked){
80100cda:	85 db                	test   %ebx,%ebx
80100cdc:	74 62                	je     80100d40 <consoleintr+0x3d0>
80100cde:	fa                   	cli
    for(;;)
80100cdf:	eb fe                	jmp    80100cdf <consoleintr+0x36f>
80100ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	68 20 01 11 80       	push   $0x80110120
80100cf0:	e8 4b 41 00 00       	call   80104e40 <release>
  if(doprocdump)
80100cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cf8:	83 c4 10             	add    $0x10,%esp
80100cfb:	85 c0                	test   %eax,%eax
80100cfd:	0f 85 c6 00 00 00    	jne    80100dc9 <consoleintr+0x459>
}
80100d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d06:	5b                   	pop    %ebx
80100d07:	5e                   	pop    %esi
80100d08:	5f                   	pop    %edi
80100d09:	5d                   	pop    %ebp
80100d0a:	c3                   	ret
80100d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (input.e < input.real_end){
80100d10:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d15:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100d1b:	0f 83 72 fc ff ff    	jae    80100993 <consoleintr+0x23>
        char ch = input.buf[input.e % INPUT_BUF];
80100d21:	83 e0 7f             	and    $0x7f,%eax
80100d24:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if(panicked){
80100d2b:	a1 58 01 11 80       	mov    0x80110158,%eax
80100d30:	85 c0                	test   %eax,%eax
80100d32:	0f 84 d5 01 00 00    	je     80100f0d <consoleintr+0x59d>
80100d38:	fa                   	cli
    for(;;)
80100d39:	eb fe                	jmp    80100d39 <consoleintr+0x3c9>
80100d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d40:	b8 00 01 00 00       	mov    $0x100,%eax
80100d45:	31 d2                	xor    %edx,%edx
80100d47:	e8 a4 f6 ff ff       	call   801003f0 <consputc.part.0>
      while(input.e != input.w &&
80100d4c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d51:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100d57:	0f 85 5c ff ff ff    	jne    80100cb9 <consoleintr+0x349>
      input.real_end = input.e;
80100d5d:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      input.current_time = 0;
80100d62:	c7 05 10 01 11 80 00 	movl   $0x0,0x80110110
80100d69:	00 00 00 
      break;
80100d6c:	e9 22 fc ff ff       	jmp    80100993 <consoleintr+0x23>
80100d71:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100d76:	e8 75 f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100d7b:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d80:	8d 50 01             	lea    0x1(%eax),%edx
80100d83:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100d89:	89 d0                	mov    %edx,%eax
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100d8b:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80100d91:	0f 82 9c fd ff ff    	jb     80100b33 <consoleintr+0x1c3>
80100d97:	e9 f7 fb ff ff       	jmp    80100993 <consoleintr+0x23>
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100da0:	31 d2                	xor    %edx,%edx
80100da2:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100da7:	e8 44 f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e--;
80100dac:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100db1:	8d 50 ff             	lea    -0x1(%eax),%edx
80100db4:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100dba:	89 d0                	mov    %edx,%eax
      while(input.e>0 && input.buf[input.e % INPUT_BUF] == ' '){
80100dbc:	85 d2                	test   %edx,%edx
80100dbe:	0f 85 be fd ff ff    	jne    80100b82 <consoleintr+0x212>
80100dc4:	e9 ca fb ff ff       	jmp    80100993 <consoleintr+0x23>
}
80100dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100dcc:	5b                   	pop    %ebx
80100dcd:	5e                   	pop    %esi
80100dce:	5f                   	pop    %edi
80100dcf:	5d                   	pop    %ebp
    procdump();
80100dd0:	e9 eb 3c 00 00       	jmp    80104ac0 <procdump>
    switch(c){
80100dd5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80100ddc:	e9 b2 fb ff ff       	jmp    80100993 <consoleintr+0x23>
80100de1:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100de6:	ba 20 00 00 00       	mov    $0x20,%edx
80100deb:	e8 00 f6 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100df0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100df5:	83 c0 01             	add    $0x1,%eax
80100df8:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n'){
80100dfd:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
80100e03:	0f 83 8a fb ff ff    	jae    80100993 <consoleintr+0x23>
80100e09:	83 e0 7f             	and    $0x7f,%eax
80100e0c:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100e13:	0f 85 7a fb ff ff    	jne    80100993 <consoleintr+0x23>
  if(panicked){
80100e19:	a1 58 01 11 80       	mov    0x80110158,%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	74 bf                	je     80100de1 <consoleintr+0x471>
80100e22:	fa                   	cli
    for(;;)
80100e23:	eb fe                	jmp    80100e23 <consoleintr+0x4b3>
80100e25:	8d 76 00             	lea    0x0(%esi),%esi
80100e28:	31 d2                	xor    %edx,%edx
80100e2a:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++) consputc(KEY_LF, 0);
80100e2f:	83 c3 01             	add    $0x1,%ebx
80100e32:	e8 b9 f5 ff ff       	call   801003f0 <consputc.part.0>
80100e37:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80100e3a:	0f 8f ce fc ff ff    	jg     80100b0e <consoleintr+0x19e>
80100e40:	89 f2                	mov    %esi,%edx
80100e42:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80100e45:	8b 75 d8             	mov    -0x28(%ebp),%esi
          int old_len = old_real_end - (int)input.w;
80100e48:	89 d0                	mov    %edx,%eax
          if (old_len < 0) old_len = 0;
80100e4a:	b9 00 00 00 00       	mov    $0x0,%ecx
min_int(int a, int b) { return a < b ? a : b; }
80100e4f:	ba 50 00 00 00       	mov    $0x50,%edx
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
80100e54:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
          int old_len = old_real_end - (int)input.w;
80100e5b:	29 f0                	sub    %esi,%eax
          if (old_len < 0) old_len = 0;
80100e5d:	0f 49 c8             	cmovns %eax,%ecx
min_int(int a, int b) { return a < b ? a : b; }
80100e60:	39 d1                	cmp    %edx,%ecx
80100e62:	0f 4f ca             	cmovg  %edx,%ecx
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
80100e65:	85 c0                	test   %eax,%eax
80100e67:	0f 8e 39 03 00 00    	jle    801011a6 <consoleintr+0x836>
80100e6d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
80100e70:	89 cb                	mov    %ecx,%ebx
  if(panicked){
80100e72:	a1 58 01 11 80       	mov    0x80110158,%eax
80100e77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	0f 84 c4 01 00 00    	je     80101046 <consoleintr+0x6d6>
80100e82:	fa                   	cli
    for(;;)
80100e83:	eb fe                	jmp    80100e83 <consoleintr+0x513>
80100e85:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100e88:	8b 0d 58 01 11 80    	mov    0x80110158,%ecx
          input.real_end--;
80100e8e:	89 1d 0c ff 10 80    	mov    %ebx,0x8010ff0c
  if(panicked){
80100e94:	85 c9                	test   %ecx,%ecx
80100e96:	0f 84 98 00 00 00    	je     80100f34 <consoleintr+0x5c4>
80100e9c:	fa                   	cli
    for(;;)
80100e9d:	eb fe                	jmp    80100e9d <consoleintr+0x52d>
80100e9f:	90                   	nop
        if(c != 0 && input.real_end-input.r < INPUT_BUF){
80100ea0:	83 fa 7f             	cmp    $0x7f,%edx
80100ea3:	0f 87 ea fa ff ff    	ja     80100993 <consoleintr+0x23>
            input.buf[input.e % INPUT_BUF] = c;
80100ea9:	89 d9                	mov    %ebx,%ecx
          c = (c == '\r') ? '\n' : c;
80100eab:	83 fb 0d             	cmp    $0xd,%ebx
80100eae:	75 0a                	jne    80100eba <consoleintr+0x54a>
80100eb0:	b9 0a 00 00 00       	mov    $0xa,%ecx
80100eb5:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
80100eba:	8b 3d 10 01 11 80    	mov    0x80110110,%edi
          input.buf[input.e++ % INPUT_BUF] = c;
80100ec0:	8d 56 01             	lea    0x1(%esi),%edx
80100ec3:	83 e6 7f             	and    $0x7f,%esi
80100ec6:	88 8e 80 fe 10 80    	mov    %cl,-0x7fef0180(%esi)
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
80100ecc:	8d 4f 01             	lea    0x1(%edi),%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80100ecf:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          input.insert_order[(input.e-1) % INPUT_BUF] = ++input.current_time;
80100ed5:	89 0d 10 01 11 80    	mov    %ecx,0x80110110
80100edb:	89 0c b5 10 ff 10 80 	mov    %ecx,-0x7fef00f0(,%esi,4)
          if (input.e > input.real_end) input.real_end = input.e;
80100ee2:	39 d0                	cmp    %edx,%eax
80100ee4:	73 06                	jae    80100eec <consoleintr+0x57c>
80100ee6:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if(panicked){
80100eec:	8b 15 58 01 11 80    	mov    0x80110158,%edx
80100ef2:	85 d2                	test   %edx,%edx
80100ef4:	0f 84 06 01 00 00    	je     80101000 <consoleintr+0x690>
80100efa:	fa                   	cli
    for(;;)
80100efb:	eb fe                	jmp    80100efb <consoleintr+0x58b>
80100efd:	8d 76 00             	lea    0x0(%esi),%esi
          if (input.e > input.real_end) input.e = input.real_end;
80100f00:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
80100f06:	89 df                	mov    %ebx,%edi
80100f08:	e9 de fb ff ff       	jmp    80100aeb <consoleintr+0x17b>
80100f0d:	b8 e5 00 00 00       	mov    $0xe5,%eax
80100f12:	e8 d9 f4 ff ff       	call   801003f0 <consputc.part.0>
        input.e++;
80100f17:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
80100f1e:	e9 70 fa ff ff       	jmp    80100993 <consoleintr+0x23>
80100f23:	31 d2                	xor    %edx,%edx
80100f25:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100f2a:	e8 c1 f4 ff ff       	call   801003f0 <consputc.part.0>
80100f2f:	e9 5f fa ff ff       	jmp    80100993 <consoleintr+0x23>
80100f34:	31 d2                	xor    %edx,%edx
80100f36:	b8 00 01 00 00       	mov    $0x100,%eax
80100f3b:	e8 b0 f4 ff ff       	call   801003f0 <consputc.part.0>
80100f40:	e9 4e fa ff ff       	jmp    80100993 <consoleintr+0x23>
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
80100f45:	85 c0                	test   %eax,%eax
80100f47:	0f 84 46 fa ff ff    	je     80100993 <consoleintr+0x23>
80100f4d:	83 e8 01             	sub    $0x1,%eax
80100f50:	83 e0 7f             	and    $0x7f,%eax
80100f53:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80100f5a:	0f 84 33 fa ff ff    	je     80100993 <consoleintr+0x23>
  if(panicked){
80100f60:	8b 35 58 01 11 80    	mov    0x80110158,%esi
80100f66:	85 f6                	test   %esi,%esi
80100f68:	74 06                	je     80100f70 <consoleintr+0x600>
80100f6a:	fa                   	cli
    for(;;)
80100f6b:	eb fe                	jmp    80100f6b <consoleintr+0x5fb>
80100f6d:	8d 76 00             	lea    0x0(%esi),%esi
80100f70:	31 d2                	xor    %edx,%edx
80100f72:	b8 e4 00 00 00       	mov    $0xe4,%eax
80100f77:	e8 74 f4 ff ff       	call   801003f0 <consputc.part.0>
        input.e--;
80100f7c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f81:	83 e8 01             	sub    $0x1,%eax
80100f84:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while(input.e>0 && input.buf[(input.e - 1) % INPUT_BUF] !=' '){
80100f89:	75 c2                	jne    80100f4d <consoleintr+0x5dd>
80100f8b:	e9 03 fa ff ff       	jmp    80100993 <consoleintr+0x23>
  if(panicked){
80100f90:	a1 58 01 11 80       	mov    0x80110158,%eax
80100f95:	85 c0                	test   %eax,%eax
80100f97:	0f 84 03 fe ff ff    	je     80100da0 <consoleintr+0x430>
80100f9d:	fa                   	cli
    for(;;)
80100f9e:	eb fe                	jmp    80100f9e <consoleintr+0x62e>
80100fa0:	31 d2                	xor    %edx,%edx
80100fa2:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++) 
80100fa7:	83 c3 01             	add    $0x1,%ebx
80100faa:	e8 41 f4 ff ff       	call   801003f0 <consputc.part.0>
80100faf:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
80100fb2:	0f 8f da fc ff ff    	jg     80100c92 <consoleintr+0x322>
80100fb8:	89 fa                	mov    %edi,%edx
80100fba:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80100fbd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
          int old_len = old_real_end - (int)input.w;
80100fc0:	89 d8                	mov    %ebx,%eax
          if (old_len < 0) old_len = 0;
80100fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80100fc7:	b9 50 00 00 00       	mov    $0x50,%ecx
          int old_len = old_real_end - (int)input.w;
80100fcc:	29 f0                	sub    %esi,%eax
          if (old_len < 0) old_len = 0;
80100fce:	0f 49 d8             	cmovns %eax,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80100fd1:	39 cb                	cmp    %ecx,%ebx
80100fd3:	0f 4f d9             	cmovg  %ecx,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++) 
80100fd6:	31 c9                	xor    %ecx,%ecx
80100fd8:	85 c0                	test   %eax,%eax
80100fda:	0f 8e c2 02 00 00    	jle    801012a2 <consoleintr+0x932>
80100fe0:	89 75 d8             	mov    %esi,-0x28(%ebp)
80100fe3:	89 ce                	mov    %ecx,%esi
80100fe5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100fe8:	89 d7                	mov    %edx,%edi
  if(panicked){
80100fea:	a1 58 01 11 80       	mov    0x80110158,%eax
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	85 c0                	test   %eax,%eax
80100ff4:	0f 84 f6 01 00 00    	je     801011f0 <consoleintr+0x880>
80100ffa:	fa                   	cli
    for(;;)
80100ffb:	eb fe                	jmp    80100ffb <consoleintr+0x68b>
80100ffd:	8d 76 00             	lea    0x0(%esi),%esi
80101000:	31 d2                	xor    %edx,%edx
80101002:	89 d8                	mov    %ebx,%eax
80101004:	e8 e7 f3 ff ff       	call   801003f0 <consputc.part.0>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
80101009:	83 fb 0a             	cmp    $0xa,%ebx
8010100c:	74 14                	je     80101022 <consoleintr+0x6b2>
8010100e:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80101013:	83 e8 80             	sub    $0xffffff80,%eax
80101016:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
8010101c:	0f 85 71 f9 ff ff    	jne    80100993 <consoleintr+0x23>
            input.w = input.e;
80101022:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80101027:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
8010102a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
8010102f:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
80101034:	68 00 ff 10 80       	push   $0x8010ff00
80101039:	e8 a2 39 00 00       	call   801049e0 <wakeup>
8010103e:	83 c4 10             	add    $0x10,%esp
80101041:	e9 4d f9 ff ff       	jmp    80100993 <consoleintr+0x23>
80101046:	b8 20 00 00 00       	mov    $0x20,%eax
8010104b:	31 d2                	xor    %edx,%edx
8010104d:	e8 9e f3 ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(' ', 0);
80101052:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
80101056:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101059:	39 d8                	cmp    %ebx,%eax
8010105b:	0f 8c 11 fe ff ff    	jl     80100e72 <consoleintr+0x502>
80101061:	89 d9                	mov    %ebx,%ecx
80101063:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80101066:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80101069:	89 cb                	mov    %ecx,%ebx
  if(panicked){
8010106b:	a1 58 01 11 80       	mov    0x80110158,%eax
80101070:	85 c0                	test   %eax,%eax
80101072:	0f 84 10 01 00 00    	je     80101188 <consoleintr+0x818>
80101078:	fa                   	cli
    for(;;)
80101079:	eb fe                	jmp    80101079 <consoleintr+0x709>
8010107b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
80101080:	8d 56 ff             	lea    -0x1(%esi),%edx
80101083:	83 e8 01             	sub    $0x1,%eax
80101086:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101089:	39 c6                	cmp    %eax,%esi
8010108b:	7f 53                	jg     801010e0 <consoleintr+0x770>
8010108d:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80101090:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80101093:	89 4d d0             	mov    %ecx,-0x30(%ebp)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101096:	99                   	cltd
80101097:	c1 ea 19             	shr    $0x19,%edx
8010109a:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
8010109d:	83 e3 7f             	and    $0x7f,%ebx
801010a0:	29 d3                	sub    %edx,%ebx
801010a2:	8d 50 01             	lea    0x1(%eax),%edx
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
801010a5:	83 e8 01             	sub    $0x1,%eax
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801010a8:	89 d7                	mov    %edx,%edi
801010aa:	0f b6 8b 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%ecx
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801010b1:	8b 1c 9d 10 ff 10 80 	mov    -0x7fef00f0(,%ebx,4),%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801010b8:	c1 ff 1f             	sar    $0x1f,%edi
801010bb:	c1 ef 19             	shr    $0x19,%edi
801010be:	01 fa                	add    %edi,%edx
801010c0:	83 e2 7f             	and    $0x7f,%edx
801010c3:	29 fa                	sub    %edi,%edx
801010c5:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801010cb:	89 1c 95 10 ff 10 80 	mov    %ebx,-0x7fef00f0(,%edx,4)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--) {
801010d2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
801010d5:	75 bf                	jne    80101096 <consoleintr+0x726>
801010d7:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801010da:	8b 7d d4             	mov    -0x2c(%ebp),%edi
801010dd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
801010e0:	a1 10 01 11 80       	mov    0x80110110,%eax
            input.buf[input.e % INPUT_BUF] = c;
801010e5:	83 e6 7f             	and    $0x7f,%esi
            input.real_end++;
801010e8:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
            input.buf[input.e % INPUT_BUF] = c;
801010ee:	88 9e 80 fe 10 80    	mov    %bl,-0x7fef0180(%esi)
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
801010f4:	83 c0 01             	add    $0x1,%eax
801010f7:	a3 10 01 11 80       	mov    %eax,0x80110110
801010fc:	89 04 b5 10 ff 10 80 	mov    %eax,-0x7fef00f0(,%esi,4)
  if(panicked){
80101103:	85 ff                	test   %edi,%edi
80101105:	74 09                	je     80101110 <consoleintr+0x7a0>
80101107:	fa                   	cli
    for(;;)
80101108:	eb fe                	jmp    80101108 <consoleintr+0x798>
8010110a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101110:	89 d8                	mov    %ebx,%eax
80101112:	31 d2                	xor    %edx,%edx
80101114:	e8 d7 f2 ff ff       	call   801003f0 <consputc.part.0>
            input.e++;
80101119:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010111e:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
80101121:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
80101126:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
8010112c:	39 c3                	cmp    %eax,%ebx
8010112e:	0f 83 08 01 00 00    	jae    8010123c <consoleintr+0x8cc>
              consputc(input.buf[i % INPUT_BUF], 0);
80101134:	89 d8                	mov    %ebx,%eax
  if(panicked){
80101136:	8b 35 58 01 11 80    	mov    0x80110158,%esi
              consputc(input.buf[i % INPUT_BUF], 0);
8010113c:	83 e0 7f             	and    $0x7f,%eax
8010113f:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
80101146:	85 f6                	test   %esi,%esi
80101148:	74 06                	je     80101150 <consoleintr+0x7e0>
8010114a:	fa                   	cli
    for(;;)
8010114b:	eb fe                	jmp    8010114b <consoleintr+0x7db>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
80101150:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80101152:	83 c3 01             	add    $0x1,%ebx
80101155:	e8 96 f2 ff ff       	call   801003f0 <consputc.part.0>
8010115a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
8010115f:	39 c3                	cmp    %eax,%ebx
80101161:	72 d1                	jb     80101134 <consoleintr+0x7c4>
            for (uint k = input.e; k < input.real_end; k++)
80101163:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80101169:	39 c3                	cmp    %eax,%ebx
8010116b:	0f 83 cb 00 00 00    	jae    8010123c <consoleintr+0x8cc>
  if(panicked){
80101171:	8b 0d 58 01 11 80    	mov    0x80110158,%ecx
80101177:	85 c9                	test   %ecx,%ecx
80101179:	0f 84 a1 00 00 00    	je     80101220 <consoleintr+0x8b0>
8010117f:	fa                   	cli
    for(;;)
80101180:	eb fe                	jmp    80101180 <consoleintr+0x810>
80101182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101188:	b8 e4 00 00 00       	mov    $0xe4,%eax
8010118d:	31 d2                	xor    %edx,%edx
8010118f:	e8 5c f2 ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) consputc(KEY_LF, 0);
80101194:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101198:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010119b:	39 d8                	cmp    %ebx,%eax
8010119d:	0f 8c c8 fe ff ff    	jl     8010106b <consoleintr+0x6fb>
801011a3:	8b 5d d8             	mov    -0x28(%ebp),%ebx
          int new_len = (int)input.real_end - (int)input.w;
801011a6:	89 d8                	mov    %ebx,%eax
          if (new_len < 0) new_len = 0;
801011a8:	31 db                	xor    %ebx,%ebx
          for (int i = 0; i < new_len; i++)
801011aa:	b9 00 00 00 00       	mov    $0x0,%ecx
          int new_len = (int)input.real_end - (int)input.w;
801011af:	29 f0                	sub    %esi,%eax
          if (new_len < 0) new_len = 0;
801011b1:	85 c0                	test   %eax,%eax
801011b3:	0f 49 d8             	cmovns %eax,%ebx
          for (int i = 0; i < new_len; i++)
801011b6:	0f 8e 71 01 00 00    	jle    8010132d <consoleintr+0x9bd>
801011bc:	89 7d dc             	mov    %edi,-0x24(%ebp)
801011bf:	89 f7                	mov    %esi,%edi
801011c1:	89 de                	mov    %ebx,%esi
801011c3:	89 cb                	mov    %ecx,%ebx
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801011c5:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801011ca:	01 d8                	add    %ebx,%eax
801011cc:	83 e0 7f             	and    $0x7f,%eax
  if(panicked){
801011cf:	83 3d 58 01 11 80 00 	cmpl   $0x0,0x80110158
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801011d6:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801011dd:	0f 84 31 01 00 00    	je     80101314 <consoleintr+0x9a4>
801011e3:	fa                   	cli
    for(;;)
801011e4:	eb fe                	jmp    801011e4 <consoleintr+0x874>
801011e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801011ed:	00 
801011ee:	66 90                	xchg   %ax,%ax
801011f0:	31 d2                	xor    %edx,%edx
801011f2:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++) 
801011f7:	83 c6 01             	add    $0x1,%esi
801011fa:	e8 f1 f1 ff ff       	call   801003f0 <consputc.part.0>
801011ff:	39 de                	cmp    %ebx,%esi
80101201:	0f 8c e3 fd ff ff    	jl     80100fea <consoleintr+0x67a>
80101207:	89 fa                	mov    %edi,%edx
80101209:	8b 7d d4             	mov    -0x2c(%ebp),%edi
8010120c:	8b 75 d8             	mov    -0x28(%ebp),%esi
8010120f:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101212:	89 d7                	mov    %edx,%edi
  if(panicked){
80101214:	a1 58 01 11 80       	mov    0x80110158,%eax
80101219:	85 c0                	test   %eax,%eax
8010121b:	74 65                	je     80101282 <consoleintr+0x912>
8010121d:	fa                   	cli
    for(;;)
8010121e:	eb fe                	jmp    8010121e <consoleintr+0x8ae>
80101220:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101225:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80101227:	83 c3 01             	add    $0x1,%ebx
8010122a:	e8 c1 f1 ff ff       	call   801003f0 <consputc.part.0>
8010122f:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80101234:	39 c3                	cmp    %eax,%ebx
80101236:	0f 82 35 ff ff ff    	jb     80101171 <consoleintr+0x801>
          if(c == '\n' || input.real_end == input.r+INPUT_BUF){
8010123c:	8b 3d 00 ff 10 80    	mov    0x8010ff00,%edi
80101242:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
80101248:	39 c2                	cmp    %eax,%edx
8010124a:	0f 85 43 f7 ff ff    	jne    80100993 <consoleintr+0x23>
            input.e = input.real_end;
80101250:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            input.w = input.e;
80101255:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
8010125a:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
8010125d:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
80101262:	68 00 ff 10 80       	push   $0x8010ff00
80101267:	e8 74 37 00 00       	call   801049e0 <wakeup>
8010126c:	83 c4 10             	add    $0x10,%esp
8010126f:	e9 1f f7 ff ff       	jmp    80100993 <consoleintr+0x23>
80101274:	31 d2                	xor    %edx,%edx
80101276:	b8 0a 00 00 00       	mov    $0xa,%eax
8010127b:	e8 70 f1 ff ff       	call   801003f0 <consputc.part.0>
80101280:	eb d3                	jmp    80101255 <consoleintr+0x8e5>
80101282:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101287:	31 d2                	xor    %edx,%edx
80101289:	e8 62 f1 ff ff       	call   801003f0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++) 
8010128e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
80101292:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101295:	39 d8                	cmp    %ebx,%eax
80101297:	0f 8c 77 ff ff ff    	jl     80101214 <consoleintr+0x8a4>
8010129d:	89 fa                	mov    %edi,%edx
8010129f:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012a2:	89 55 dc             	mov    %edx,-0x24(%ebp)
          int new_len = (int)input.real_end - (int)input.w;
801012a5:	29 f7                	sub    %esi,%edi
          if (new_len < 0) 
801012a7:	b8 00 00 00 00       	mov    $0x0,%eax
801012ac:	0f 48 f8             	cmovs  %eax,%edi
          for (int i = 0; i < new_len; i++)
801012af:	31 db                	xor    %ebx,%ebx
801012b1:	39 df                	cmp    %ebx,%edi
801012b3:	74 29                	je     801012de <consoleintr+0x96e>
              consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801012b5:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801012ba:	01 d8                	add    %ebx,%eax
801012bc:	83 e0 7f             	and    $0x7f,%eax
  if(panicked){
801012bf:	83 3d 58 01 11 80 00 	cmpl   $0x0,0x80110158
              consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801012c6:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if(panicked){
801012cd:	74 03                	je     801012d2 <consoleintr+0x962>
801012cf:	fa                   	cli
    for(;;)
801012d0:	eb fe                	jmp    801012d0 <consoleintr+0x960>
801012d2:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
801012d4:	83 c3 01             	add    $0x1,%ebx
801012d7:	e8 14 f1 ff ff       	call   801003f0 <consputc.part.0>
801012dc:	eb d3                	jmp    801012b1 <consoleintr+0x941>
          int new_cursor_off = (int)input.e - (int)input.w;
801012de:	8b 55 dc             	mov    -0x24(%ebp),%edx
          if (new_cursor_off < 0) 
801012e1:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
801012e6:	29 f2                	sub    %esi,%edx
          if (new_cursor_off < 0) 
801012e8:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++) 
801012eb:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
801012ed:	29 d7                	sub    %edx,%edi
          for (int i = 0; i < moves_left; i++) 
801012ef:	39 fb                	cmp    %edi,%ebx
801012f1:	0f 8d 9c f6 ff ff    	jge    80100993 <consoleintr+0x23>
  if(panicked){
801012f7:	83 3d 58 01 11 80 00 	cmpl   $0x0,0x80110158
801012fe:	74 03                	je     80101303 <consoleintr+0x993>
80101300:	fa                   	cli
    for(;;)
80101301:	eb fe                	jmp    80101301 <consoleintr+0x991>
80101303:	31 d2                	xor    %edx,%edx
80101305:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++) 
8010130a:	83 c3 01             	add    $0x1,%ebx
8010130d:	e8 de f0 ff ff       	call   801003f0 <consputc.part.0>
80101312:	eb db                	jmp    801012ef <consoleintr+0x97f>
80101314:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101316:	83 c3 01             	add    $0x1,%ebx
80101319:	e8 d2 f0 ff ff       	call   801003f0 <consputc.part.0>
8010131e:	39 de                	cmp    %ebx,%esi
80101320:	0f 8f 9f fe ff ff    	jg     801011c5 <consoleintr+0x855>
80101326:	89 f3                	mov    %esi,%ebx
80101328:	89 fe                	mov    %edi,%esi
8010132a:	8b 7d dc             	mov    -0x24(%ebp),%edi
          if (new_cursor_off < 0) new_cursor_off = 0;
8010132d:	29 f7                	sub    %esi,%edi
8010132f:	b8 00 00 00 00       	mov    $0x0,%eax
80101334:	0f 49 c7             	cmovns %edi,%eax
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
80101337:	31 f6                	xor    %esi,%esi
          int moves_left = new_len - new_cursor_off;
80101339:	29 c3                	sub    %eax,%ebx
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
8010133b:	39 de                	cmp    %ebx,%esi
8010133d:	0f 8d 50 f6 ff ff    	jge    80100993 <consoleintr+0x23>
  if(panicked){
80101343:	83 3d 58 01 11 80 00 	cmpl   $0x0,0x80110158
8010134a:	74 03                	je     8010134f <consoleintr+0x9df>
8010134c:	fa                   	cli
    for(;;)
8010134d:	eb fe                	jmp    8010134d <consoleintr+0x9dd>
8010134f:	31 d2                	xor    %edx,%edx
80101351:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++) consputc(KEY_LF, 0);
80101356:	83 c6 01             	add    $0x1,%esi
80101359:	e8 92 f0 ff ff       	call   801003f0 <consputc.part.0>
8010135e:	eb db                	jmp    8010133b <consoleintr+0x9cb>

80101360 <consoleinit>:

void
consoleinit(void)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101366:	68 c8 7a 10 80       	push   $0x80107ac8
8010136b:	68 20 01 11 80       	push   $0x80110120
80101370:	e8 3b 39 00 00       	call   80104cb0 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  ioapicenable(IRQ_KBD, 0);
80101375:	58                   	pop    %eax
80101376:	5a                   	pop    %edx
80101377:	6a 00                	push   $0x0
80101379:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010137b:	c7 05 0c 0b 11 80 60 	movl   $0x80100660,0x80110b0c
80101382:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80101385:	c7 05 08 0b 11 80 80 	movl   $0x80100280,0x80110b08
8010138c:	02 10 80 
  cons.locking = 1;
8010138f:	c7 05 54 01 11 80 01 	movl   $0x1,0x80110154
80101396:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101399:	e8 c2 19 00 00       	call   80102d60 <ioapicenable>
}
8010139e:	83 c4 10             	add    $0x10,%esp
801013a1:	c9                   	leave
801013a2:	c3                   	ret
801013a3:	66 90                	xchg   %ax,%ax
801013a5:	66 90                	xchg   %ax,%ax
801013a7:	66 90                	xchg   %ax,%ax
801013a9:	66 90                	xchg   %ax,%ax
801013ab:	66 90                	xchg   %ax,%ax
801013ad:	66 90                	xchg   %ax,%ax
801013af:	90                   	nop

801013b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801013bc:	e8 9f 2e 00 00       	call   80104260 <myproc>
801013c1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801013c7:	e8 74 22 00 00       	call   80103640 <begin_op>

  if((ip = namei(path)) == 0){
801013cc:	83 ec 0c             	sub    $0xc,%esp
801013cf:	ff 75 08             	push   0x8(%ebp)
801013d2:	e8 a9 15 00 00       	call   80102980 <namei>
801013d7:	83 c4 10             	add    $0x10,%esp
801013da:	85 c0                	test   %eax,%eax
801013dc:	0f 84 30 03 00 00    	je     80101712 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801013e2:	83 ec 0c             	sub    $0xc,%esp
801013e5:	89 c7                	mov    %eax,%edi
801013e7:	50                   	push   %eax
801013e8:	e8 b3 0c 00 00       	call   801020a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801013ed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801013f3:	6a 34                	push   $0x34
801013f5:	6a 00                	push   $0x0
801013f7:	50                   	push   %eax
801013f8:	57                   	push   %edi
801013f9:	e8 b2 0f 00 00       	call   801023b0 <readi>
801013fe:	83 c4 20             	add    $0x20,%esp
80101401:	83 f8 34             	cmp    $0x34,%eax
80101404:	0f 85 01 01 00 00    	jne    8010150b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
8010140a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101411:	45 4c 46 
80101414:	0f 85 f1 00 00 00    	jne    8010150b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
8010141a:	e8 01 63 00 00       	call   80107720 <setupkvm>
8010141f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101425:	85 c0                	test   %eax,%eax
80101427:	0f 84 de 00 00 00    	je     8010150b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010142d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101434:	00 
80101435:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010143b:	0f 84 a1 02 00 00    	je     801016e2 <exec+0x332>
  sz = 0;
80101441:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101448:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010144b:	31 db                	xor    %ebx,%ebx
8010144d:	e9 8c 00 00 00       	jmp    801014de <exec+0x12e>
80101452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101458:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
8010145f:	75 6c                	jne    801014cd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101461:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101467:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010146d:	0f 82 87 00 00 00    	jb     801014fa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101473:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101479:	72 7f                	jb     801014fa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010147b:	83 ec 04             	sub    $0x4,%esp
8010147e:	50                   	push   %eax
8010147f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101485:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010148b:	e8 c0 60 00 00       	call   80107550 <allocuvm>
80101490:	83 c4 10             	add    $0x10,%esp
80101493:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101499:	85 c0                	test   %eax,%eax
8010149b:	74 5d                	je     801014fa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010149d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801014a3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801014a8:	75 50                	jne    801014fa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801014aa:	83 ec 0c             	sub    $0xc,%esp
801014ad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
801014b3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
801014b9:	57                   	push   %edi
801014ba:	50                   	push   %eax
801014bb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801014c1:	e8 ba 5f 00 00       	call   80107480 <loaduvm>
801014c6:	83 c4 20             	add    $0x20,%esp
801014c9:	85 c0                	test   %eax,%eax
801014cb:	78 2d                	js     801014fa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801014cd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801014d4:	83 c3 01             	add    $0x1,%ebx
801014d7:	83 c6 20             	add    $0x20,%esi
801014da:	39 d8                	cmp    %ebx,%eax
801014dc:	7e 52                	jle    80101530 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801014de:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801014e4:	6a 20                	push   $0x20
801014e6:	56                   	push   %esi
801014e7:	50                   	push   %eax
801014e8:	57                   	push   %edi
801014e9:	e8 c2 0e 00 00       	call   801023b0 <readi>
801014ee:	83 c4 10             	add    $0x10,%esp
801014f1:	83 f8 20             	cmp    $0x20,%eax
801014f4:	0f 84 5e ff ff ff    	je     80101458 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
801014fa:	83 ec 0c             	sub    $0xc,%esp
801014fd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101503:	e8 98 61 00 00       	call   801076a0 <freevm>
  if(ip){
80101508:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010150b:	83 ec 0c             	sub    $0xc,%esp
8010150e:	57                   	push   %edi
8010150f:	e8 1c 0e 00 00       	call   80102330 <iunlockput>
    end_op();
80101514:	e8 97 21 00 00       	call   801036b0 <end_op>
80101519:	83 c4 10             	add    $0x10,%esp
    return -1;
8010151c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80101521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101524:	5b                   	pop    %ebx
80101525:	5e                   	pop    %esi
80101526:	5f                   	pop    %edi
80101527:	5d                   	pop    %ebp
80101528:	c3                   	ret
80101529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101530:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101536:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
8010153c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101542:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101548:	83 ec 0c             	sub    $0xc,%esp
8010154b:	57                   	push   %edi
8010154c:	e8 df 0d 00 00       	call   80102330 <iunlockput>
  end_op();
80101551:	e8 5a 21 00 00       	call   801036b0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101556:	83 c4 0c             	add    $0xc,%esp
80101559:	53                   	push   %ebx
8010155a:	56                   	push   %esi
8010155b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101561:	56                   	push   %esi
80101562:	e8 e9 5f 00 00       	call   80107550 <allocuvm>
80101567:	83 c4 10             	add    $0x10,%esp
8010156a:	89 c7                	mov    %eax,%edi
8010156c:	85 c0                	test   %eax,%eax
8010156e:	0f 84 86 00 00 00    	je     801015fa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101574:	83 ec 08             	sub    $0x8,%esp
80101577:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010157d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010157f:	50                   	push   %eax
80101580:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101581:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101583:	e8 38 62 00 00       	call   801077c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101588:	8b 45 0c             	mov    0xc(%ebp),%eax
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	8b 10                	mov    (%eax),%edx
80101590:	85 d2                	test   %edx,%edx
80101592:	0f 84 56 01 00 00    	je     801016ee <exec+0x33e>
80101598:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010159e:	8b 7d 0c             	mov    0xc(%ebp),%edi
801015a1:	eb 23                	jmp    801015c6 <exec+0x216>
801015a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801015a8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
801015ab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
801015b2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
801015b8:	8b 14 87             	mov    (%edi,%eax,4),%edx
801015bb:	85 d2                	test   %edx,%edx
801015bd:	74 51                	je     80101610 <exec+0x260>
    if(argc >= MAXARG)
801015bf:	83 f8 20             	cmp    $0x20,%eax
801015c2:	74 36                	je     801015fa <exec+0x24a>
801015c4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801015c6:	83 ec 0c             	sub    $0xc,%esp
801015c9:	52                   	push   %edx
801015ca:	e8 c1 3b 00 00       	call   80105190 <strlen>
801015cf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801015d1:	58                   	pop    %eax
801015d2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801015d5:	83 eb 01             	sub    $0x1,%ebx
801015d8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801015db:	e8 b0 3b 00 00       	call   80105190 <strlen>
801015e0:	83 c0 01             	add    $0x1,%eax
801015e3:	50                   	push   %eax
801015e4:	ff 34 b7             	push   (%edi,%esi,4)
801015e7:	53                   	push   %ebx
801015e8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801015ee:	e8 9d 63 00 00       	call   80107990 <copyout>
801015f3:	83 c4 20             	add    $0x20,%esp
801015f6:	85 c0                	test   %eax,%eax
801015f8:	79 ae                	jns    801015a8 <exec+0x1f8>
    freevm(pgdir);
801015fa:	83 ec 0c             	sub    $0xc,%esp
801015fd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101603:	e8 98 60 00 00       	call   801076a0 <freevm>
80101608:	83 c4 10             	add    $0x10,%esp
8010160b:	e9 0c ff ff ff       	jmp    8010151c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101610:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80101617:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
8010161d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101623:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80101626:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80101629:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101630:	00 00 00 00 
  ustack[1] = argc;
80101634:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010163a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101641:	ff ff ff 
  ustack[1] = argc;
80101644:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010164a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010164c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010164e:	29 d0                	sub    %edx,%eax
80101650:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101656:	56                   	push   %esi
80101657:	51                   	push   %ecx
80101658:	53                   	push   %ebx
80101659:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010165f:	e8 2c 63 00 00       	call   80107990 <copyout>
80101664:	83 c4 10             	add    $0x10,%esp
80101667:	85 c0                	test   %eax,%eax
80101669:	78 8f                	js     801015fa <exec+0x24a>
  for(last=s=path; *s; s++)
8010166b:	8b 45 08             	mov    0x8(%ebp),%eax
8010166e:	8b 55 08             	mov    0x8(%ebp),%edx
80101671:	0f b6 00             	movzbl (%eax),%eax
80101674:	84 c0                	test   %al,%al
80101676:	74 17                	je     8010168f <exec+0x2df>
80101678:	89 d1                	mov    %edx,%ecx
8010167a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80101680:	83 c1 01             	add    $0x1,%ecx
80101683:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101685:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101688:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010168b:	84 c0                	test   %al,%al
8010168d:	75 f1                	jne    80101680 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010168f:	83 ec 04             	sub    $0x4,%esp
80101692:	6a 10                	push   $0x10
80101694:	52                   	push   %edx
80101695:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010169b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010169e:	50                   	push   %eax
8010169f:	e8 ac 3a 00 00       	call   80105150 <safestrcpy>
  curproc->pgdir = pgdir;
801016a4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801016aa:	89 f0                	mov    %esi,%eax
801016ac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
801016af:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
801016b1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801016b4:	89 c1                	mov    %eax,%ecx
801016b6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801016bc:	8b 40 18             	mov    0x18(%eax),%eax
801016bf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801016c2:	8b 41 18             	mov    0x18(%ecx),%eax
801016c5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801016c8:	89 0c 24             	mov    %ecx,(%esp)
801016cb:	e8 20 5c 00 00       	call   801072f0 <switchuvm>
  freevm(oldpgdir);
801016d0:	89 34 24             	mov    %esi,(%esp)
801016d3:	e8 c8 5f 00 00       	call   801076a0 <freevm>
  return 0;
801016d8:	83 c4 10             	add    $0x10,%esp
801016db:	31 c0                	xor    %eax,%eax
801016dd:	e9 3f fe ff ff       	jmp    80101521 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801016e2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801016e7:	31 f6                	xor    %esi,%esi
801016e9:	e9 5a fe ff ff       	jmp    80101548 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801016ee:	be 10 00 00 00       	mov    $0x10,%esi
801016f3:	ba 04 00 00 00       	mov    $0x4,%edx
801016f8:	b8 03 00 00 00       	mov    $0x3,%eax
801016fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101704:	00 00 00 
80101707:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
8010170d:	e9 17 ff ff ff       	jmp    80101629 <exec+0x279>
    end_op();
80101712:	e8 99 1f 00 00       	call   801036b0 <end_op>
    cprintf("exec: fail\n");
80101717:	83 ec 0c             	sub    $0xc,%esp
8010171a:	68 d0 7a 10 80       	push   $0x80107ad0
8010171f:	e8 3c f0 ff ff       	call   80100760 <cprintf>
    return -1;
80101724:	83 c4 10             	add    $0x10,%esp
80101727:	e9 f0 fd ff ff       	jmp    8010151c <exec+0x16c>
8010172c:	66 90                	xchg   %ax,%ax
8010172e:	66 90                	xchg   %ax,%ax

80101730 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101736:	68 dc 7a 10 80       	push   $0x80107adc
8010173b:	68 60 01 11 80       	push   $0x80110160
80101740:	e8 6b 35 00 00       	call   80104cb0 <initlock>
}
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	c9                   	leave
80101749:	c3                   	ret
8010174a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101750 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101754:	bb 94 01 11 80       	mov    $0x80110194,%ebx
{
80101759:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010175c:	68 60 01 11 80       	push   $0x80110160
80101761:	e8 3a 37 00 00       	call   80104ea0 <acquire>
80101766:	83 c4 10             	add    $0x10,%esp
80101769:	eb 10                	jmp    8010177b <filealloc+0x2b>
8010176b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101770:	83 c3 18             	add    $0x18,%ebx
80101773:	81 fb f4 0a 11 80    	cmp    $0x80110af4,%ebx
80101779:	74 25                	je     801017a0 <filealloc+0x50>
    if(f->ref == 0){
8010177b:	8b 43 04             	mov    0x4(%ebx),%eax
8010177e:	85 c0                	test   %eax,%eax
80101780:	75 ee                	jne    80101770 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101782:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101785:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010178c:	68 60 01 11 80       	push   $0x80110160
80101791:	e8 aa 36 00 00       	call   80104e40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101796:	89 d8                	mov    %ebx,%eax
      return f;
80101798:	83 c4 10             	add    $0x10,%esp
}
8010179b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179e:	c9                   	leave
8010179f:	c3                   	ret
  release(&ftable.lock);
801017a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801017a3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801017a5:	68 60 01 11 80       	push   $0x80110160
801017aa:	e8 91 36 00 00       	call   80104e40 <release>
}
801017af:	89 d8                	mov    %ebx,%eax
  return 0;
801017b1:	83 c4 10             	add    $0x10,%esp
}
801017b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017b7:	c9                   	leave
801017b8:	c3                   	ret
801017b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801017c0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801017ca:	68 60 01 11 80       	push   $0x80110160
801017cf:	e8 cc 36 00 00       	call   80104ea0 <acquire>
  if(f->ref < 1)
801017d4:	8b 43 04             	mov    0x4(%ebx),%eax
801017d7:	83 c4 10             	add    $0x10,%esp
801017da:	85 c0                	test   %eax,%eax
801017dc:	7e 1a                	jle    801017f8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801017de:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801017e1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801017e4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801017e7:	68 60 01 11 80       	push   $0x80110160
801017ec:	e8 4f 36 00 00       	call   80104e40 <release>
  return f;
}
801017f1:	89 d8                	mov    %ebx,%eax
801017f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017f6:	c9                   	leave
801017f7:	c3                   	ret
    panic("filedup");
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e3 7a 10 80       	push   $0x80107ae3
80101800:	e8 6b eb ff ff       	call   80100370 <panic>
80101805:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010180c:	00 
8010180d:	8d 76 00             	lea    0x0(%esi),%esi

80101810 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	56                   	push   %esi
80101815:	53                   	push   %ebx
80101816:	83 ec 28             	sub    $0x28,%esp
80101819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010181c:	68 60 01 11 80       	push   $0x80110160
80101821:	e8 7a 36 00 00       	call   80104ea0 <acquire>
  if(f->ref < 1)
80101826:	8b 53 04             	mov    0x4(%ebx),%edx
80101829:	83 c4 10             	add    $0x10,%esp
8010182c:	85 d2                	test   %edx,%edx
8010182e:	0f 8e a5 00 00 00    	jle    801018d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101834:	83 ea 01             	sub    $0x1,%edx
80101837:	89 53 04             	mov    %edx,0x4(%ebx)
8010183a:	75 44                	jne    80101880 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010183c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101840:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101843:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101845:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010184b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010184e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101851:	8b 43 10             	mov    0x10(%ebx),%eax
80101854:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101857:	68 60 01 11 80       	push   $0x80110160
8010185c:	e8 df 35 00 00       	call   80104e40 <release>

  if(ff.type == FD_PIPE)
80101861:	83 c4 10             	add    $0x10,%esp
80101864:	83 ff 01             	cmp    $0x1,%edi
80101867:	74 57                	je     801018c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101869:	83 ff 02             	cmp    $0x2,%edi
8010186c:	74 2a                	je     80101898 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010186e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101871:	5b                   	pop    %ebx
80101872:	5e                   	pop    %esi
80101873:	5f                   	pop    %edi
80101874:	5d                   	pop    %ebp
80101875:	c3                   	ret
80101876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187d:	00 
8010187e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101880:	c7 45 08 60 01 11 80 	movl   $0x80110160,0x8(%ebp)
}
80101887:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188a:	5b                   	pop    %ebx
8010188b:	5e                   	pop    %esi
8010188c:	5f                   	pop    %edi
8010188d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010188e:	e9 ad 35 00 00       	jmp    80104e40 <release>
80101893:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101898:	e8 a3 1d 00 00       	call   80103640 <begin_op>
    iput(ff.ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
801018a0:	ff 75 e0             	push   -0x20(%ebp)
801018a3:	e8 28 09 00 00       	call   801021d0 <iput>
    end_op();
801018a8:	83 c4 10             	add    $0x10,%esp
}
801018ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ae:	5b                   	pop    %ebx
801018af:	5e                   	pop    %esi
801018b0:	5f                   	pop    %edi
801018b1:	5d                   	pop    %ebp
    end_op();
801018b2:	e9 f9 1d 00 00       	jmp    801036b0 <end_op>
801018b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018be:	00 
801018bf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
801018c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801018c4:	83 ec 08             	sub    $0x8,%esp
801018c7:	53                   	push   %ebx
801018c8:	56                   	push   %esi
801018c9:	e8 32 25 00 00       	call   80103e00 <pipeclose>
801018ce:	83 c4 10             	add    $0x10,%esp
}
801018d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018d4:	5b                   	pop    %ebx
801018d5:	5e                   	pop    %esi
801018d6:	5f                   	pop    %edi
801018d7:	5d                   	pop    %ebp
801018d8:	c3                   	ret
    panic("fileclose");
801018d9:	83 ec 0c             	sub    $0xc,%esp
801018dc:	68 eb 7a 10 80       	push   $0x80107aeb
801018e1:	e8 8a ea ff ff       	call   80100370 <panic>
801018e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018ed:	00 
801018ee:	66 90                	xchg   %ax,%ax

801018f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 04             	sub    $0x4,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801018fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801018fd:	75 31                	jne    80101930 <filestat+0x40>
    ilock(f->ip);
801018ff:	83 ec 0c             	sub    $0xc,%esp
80101902:	ff 73 10             	push   0x10(%ebx)
80101905:	e8 96 07 00 00       	call   801020a0 <ilock>
    stati(f->ip, st);
8010190a:	58                   	pop    %eax
8010190b:	5a                   	pop    %edx
8010190c:	ff 75 0c             	push   0xc(%ebp)
8010190f:	ff 73 10             	push   0x10(%ebx)
80101912:	e8 69 0a 00 00       	call   80102380 <stati>
    iunlock(f->ip);
80101917:	59                   	pop    %ecx
80101918:	ff 73 10             	push   0x10(%ebx)
8010191b:	e8 60 08 00 00       	call   80102180 <iunlock>
    return 0;
  }
  return -1;
}
80101920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	31 c0                	xor    %eax,%eax
}
80101928:	c9                   	leave
80101929:	c3                   	ret
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101930:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101938:	c9                   	leave
80101939:	c3                   	ret
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101940 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010194c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010194f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101952:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101956:	74 60                	je     801019b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101958:	8b 03                	mov    (%ebx),%eax
8010195a:	83 f8 01             	cmp    $0x1,%eax
8010195d:	74 41                	je     801019a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010195f:	83 f8 02             	cmp    $0x2,%eax
80101962:	75 5b                	jne    801019bf <fileread+0x7f>
    ilock(f->ip);
80101964:	83 ec 0c             	sub    $0xc,%esp
80101967:	ff 73 10             	push   0x10(%ebx)
8010196a:	e8 31 07 00 00       	call   801020a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010196f:	57                   	push   %edi
80101970:	ff 73 14             	push   0x14(%ebx)
80101973:	56                   	push   %esi
80101974:	ff 73 10             	push   0x10(%ebx)
80101977:	e8 34 0a 00 00       	call   801023b0 <readi>
8010197c:	83 c4 20             	add    $0x20,%esp
8010197f:	89 c6                	mov    %eax,%esi
80101981:	85 c0                	test   %eax,%eax
80101983:	7e 03                	jle    80101988 <fileread+0x48>
      f->off += r;
80101985:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101988:	83 ec 0c             	sub    $0xc,%esp
8010198b:	ff 73 10             	push   0x10(%ebx)
8010198e:	e8 ed 07 00 00       	call   80102180 <iunlock>
    return r;
80101993:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101996:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101999:	89 f0                	mov    %esi,%eax
8010199b:	5b                   	pop    %ebx
8010199c:	5e                   	pop    %esi
8010199d:	5f                   	pop    %edi
8010199e:	5d                   	pop    %ebp
8010199f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801019a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801019a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a9:	5b                   	pop    %ebx
801019aa:	5e                   	pop    %esi
801019ab:	5f                   	pop    %edi
801019ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801019ad:	e9 0e 26 00 00       	jmp    80103fc0 <piperead>
801019b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801019b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801019bd:	eb d7                	jmp    80101996 <fileread+0x56>
  panic("fileread");
801019bf:	83 ec 0c             	sub    $0xc,%esp
801019c2:	68 f5 7a 10 80       	push   $0x80107af5
801019c7:	e8 a4 e9 ff ff       	call   80100370 <panic>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801019dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801019df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801019e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801019e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801019e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801019ec:	0f 84 bb 00 00 00    	je     80101aad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801019f2:	8b 03                	mov    (%ebx),%eax
801019f4:	83 f8 01             	cmp    $0x1,%eax
801019f7:	0f 84 bf 00 00 00    	je     80101abc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801019fd:	83 f8 02             	cmp    $0x2,%eax
80101a00:	0f 85 c8 00 00 00    	jne    80101ace <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101a09:	31 f6                	xor    %esi,%esi
    while(i < n){
80101a0b:	85 c0                	test   %eax,%eax
80101a0d:	7f 30                	jg     80101a3f <filewrite+0x6f>
80101a0f:	e9 94 00 00 00       	jmp    80101aa8 <filewrite+0xd8>
80101a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101a18:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80101a1b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
80101a1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101a21:	ff 73 10             	push   0x10(%ebx)
80101a24:	e8 57 07 00 00       	call   80102180 <iunlock>
      end_op();
80101a29:	e8 82 1c 00 00       	call   801036b0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a31:	83 c4 10             	add    $0x10,%esp
80101a34:	39 c7                	cmp    %eax,%edi
80101a36:	75 5c                	jne    80101a94 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101a38:	01 fe                	add    %edi,%esi
    while(i < n){
80101a3a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101a3d:	7e 69                	jle    80101aa8 <filewrite+0xd8>
      int n1 = n - i;
80101a3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101a42:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101a47:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101a49:	39 c7                	cmp    %eax,%edi
80101a4b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80101a4e:	e8 ed 1b 00 00       	call   80103640 <begin_op>
      ilock(f->ip);
80101a53:	83 ec 0c             	sub    $0xc,%esp
80101a56:	ff 73 10             	push   0x10(%ebx)
80101a59:	e8 42 06 00 00       	call   801020a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101a5e:	57                   	push   %edi
80101a5f:	ff 73 14             	push   0x14(%ebx)
80101a62:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101a65:	01 f0                	add    %esi,%eax
80101a67:	50                   	push   %eax
80101a68:	ff 73 10             	push   0x10(%ebx)
80101a6b:	e8 40 0a 00 00       	call   801024b0 <writei>
80101a70:	83 c4 20             	add    $0x20,%esp
80101a73:	85 c0                	test   %eax,%eax
80101a75:	7f a1                	jg     80101a18 <filewrite+0x48>
80101a77:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101a7a:	83 ec 0c             	sub    $0xc,%esp
80101a7d:	ff 73 10             	push   0x10(%ebx)
80101a80:	e8 fb 06 00 00       	call   80102180 <iunlock>
      end_op();
80101a85:	e8 26 1c 00 00       	call   801036b0 <end_op>
      if(r < 0)
80101a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a8d:	83 c4 10             	add    $0x10,%esp
80101a90:	85 c0                	test   %eax,%eax
80101a92:	75 14                	jne    80101aa8 <filewrite+0xd8>
        panic("short filewrite");
80101a94:	83 ec 0c             	sub    $0xc,%esp
80101a97:	68 fe 7a 10 80       	push   $0x80107afe
80101a9c:	e8 cf e8 ff ff       	call   80100370 <panic>
80101aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101aa8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101aab:	74 05                	je     80101ab2 <filewrite+0xe2>
80101aad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101ab2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab5:	89 f0                	mov    %esi,%eax
80101ab7:	5b                   	pop    %ebx
80101ab8:	5e                   	pop    %esi
80101ab9:	5f                   	pop    %edi
80101aba:	5d                   	pop    %ebp
80101abb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80101abc:	8b 43 0c             	mov    0xc(%ebx),%eax
80101abf:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac5:	5b                   	pop    %ebx
80101ac6:	5e                   	pop    %esi
80101ac7:	5f                   	pop    %edi
80101ac8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101ac9:	e9 d2 23 00 00       	jmp    80103ea0 <pipewrite>
  panic("filewrite");
80101ace:	83 ec 0c             	sub    $0xc,%esp
80101ad1:	68 04 7b 10 80       	push   $0x80107b04
80101ad6:	e8 95 e8 ff ff       	call   80100370 <panic>
80101adb:	66 90                	xchg   %ax,%ax
80101add:	66 90                	xchg   %ax,%ax
80101adf:	90                   	nop

80101ae0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101ae9:	8b 0d b4 27 11 80    	mov    0x801127b4,%ecx
{
80101aef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101af2:	85 c9                	test   %ecx,%ecx
80101af4:	0f 84 8c 00 00 00    	je     80101b86 <balloc+0xa6>
80101afa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
80101afc:	89 f8                	mov    %edi,%eax
80101afe:	83 ec 08             	sub    $0x8,%esp
80101b01:	89 fe                	mov    %edi,%esi
80101b03:	c1 f8 0c             	sar    $0xc,%eax
80101b06:	03 05 cc 27 11 80    	add    0x801127cc,%eax
80101b0c:	50                   	push   %eax
80101b0d:	ff 75 dc             	push   -0x24(%ebp)
80101b10:	e8 bb e5 ff ff       	call   801000d0 <bread>
80101b15:	83 c4 10             	add    $0x10,%esp
80101b18:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101b1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b1e:	a1 b4 27 11 80       	mov    0x801127b4,%eax
80101b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b26:	31 c0                	xor    %eax,%eax
80101b28:	eb 32                	jmp    80101b5c <balloc+0x7c>
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101b30:	89 c1                	mov    %eax,%ecx
80101b32:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
80101b3a:	83 e1 07             	and    $0x7,%ecx
80101b3d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b3f:	89 c1                	mov    %eax,%ecx
80101b41:	c1 f9 03             	sar    $0x3,%ecx
80101b44:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101b49:	89 fa                	mov    %edi,%edx
80101b4b:	85 df                	test   %ebx,%edi
80101b4d:	74 49                	je     80101b98 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b4f:	83 c0 01             	add    $0x1,%eax
80101b52:	83 c6 01             	add    $0x1,%esi
80101b55:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101b5a:	74 07                	je     80101b63 <balloc+0x83>
80101b5c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101b5f:	39 d6                	cmp    %edx,%esi
80101b61:	72 cd                	jb     80101b30 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101b63:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101b6c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101b72:	e8 79 e6 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	3b 3d b4 27 11 80    	cmp    0x801127b4,%edi
80101b80:	0f 82 76 ff ff ff    	jb     80101afc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101b86:	83 ec 0c             	sub    $0xc,%esp
80101b89:	68 0e 7b 10 80       	push   $0x80107b0e
80101b8e:	e8 dd e7 ff ff       	call   80100370 <panic>
80101b93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101b98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101b9e:	09 da                	or     %ebx,%edx
80101ba0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101ba4:	57                   	push   %edi
80101ba5:	e8 76 1c 00 00       	call   80103820 <log_write>
        brelse(bp);
80101baa:	89 3c 24             	mov    %edi,(%esp)
80101bad:	e8 3e e6 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101bb2:	58                   	pop    %eax
80101bb3:	5a                   	pop    %edx
80101bb4:	56                   	push   %esi
80101bb5:	ff 75 dc             	push   -0x24(%ebp)
80101bb8:	e8 13 e5 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101bbd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101bc0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101bc2:	8d 40 5c             	lea    0x5c(%eax),%eax
80101bc5:	68 00 02 00 00       	push   $0x200
80101bca:	6a 00                	push   $0x0
80101bcc:	50                   	push   %eax
80101bcd:	e8 ce 33 00 00       	call   80104fa0 <memset>
  log_write(bp);
80101bd2:	89 1c 24             	mov    %ebx,(%esp)
80101bd5:	e8 46 1c 00 00       	call   80103820 <log_write>
  brelse(bp);
80101bda:	89 1c 24             	mov    %ebx,(%esp)
80101bdd:	e8 0e e6 ff ff       	call   801001f0 <brelse>
}
80101be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be5:	89 f0                	mov    %esi,%eax
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
80101beb:	c3                   	ret
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bf0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101bf4:	31 ff                	xor    %edi,%edi
{
80101bf6:	56                   	push   %esi
80101bf7:	89 c6                	mov    %eax,%esi
80101bf9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bfa:	bb 94 0b 11 80       	mov    $0x80110b94,%ebx
{
80101bff:	83 ec 28             	sub    $0x28,%esp
80101c02:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101c05:	68 60 0b 11 80       	push   $0x80110b60
80101c0a:	e8 91 32 00 00       	call   80104ea0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	eb 1b                	jmp    80101c32 <iget+0x42>
80101c17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c1e:	00 
80101c1f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c20:	39 33                	cmp    %esi,(%ebx)
80101c22:	74 6c                	je     80101c90 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c24:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c2a:	81 fb b4 27 11 80    	cmp    $0x801127b4,%ebx
80101c30:	74 26                	je     80101c58 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c32:	8b 43 08             	mov    0x8(%ebx),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	7f e7                	jg     80101c20 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101c39:	85 ff                	test   %edi,%edi
80101c3b:	75 e7                	jne    80101c24 <iget+0x34>
80101c3d:	85 c0                	test   %eax,%eax
80101c3f:	75 76                	jne    80101cb7 <iget+0xc7>
      empty = ip;
80101c41:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c43:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c49:	81 fb b4 27 11 80    	cmp    $0x801127b4,%ebx
80101c4f:	75 e1                	jne    80101c32 <iget+0x42>
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c58:	85 ff                	test   %edi,%edi
80101c5a:	74 79                	je     80101cd5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101c5c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101c5f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101c61:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101c64:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
80101c6b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101c72:	68 60 0b 11 80       	push   $0x80110b60
80101c77:	e8 c4 31 00 00       	call   80104e40 <release>

  return ip;
80101c7c:	83 c4 10             	add    $0x10,%esp
}
80101c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c82:	89 f8                	mov    %edi,%eax
80101c84:	5b                   	pop    %ebx
80101c85:	5e                   	pop    %esi
80101c86:	5f                   	pop    %edi
80101c87:	5d                   	pop    %ebp
80101c88:	c3                   	ret
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c90:	39 53 04             	cmp    %edx,0x4(%ebx)
80101c93:	75 8f                	jne    80101c24 <iget+0x34>
      ip->ref++;
80101c95:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101c98:	83 ec 0c             	sub    $0xc,%esp
      return ip;
80101c9b:	89 df                	mov    %ebx,%edi
      ip->ref++;
80101c9d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101ca0:	68 60 0b 11 80       	push   $0x80110b60
80101ca5:	e8 96 31 00 00       	call   80104e40 <release>
      return ip;
80101caa:	83 c4 10             	add    $0x10,%esp
}
80101cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cb0:	89 f8                	mov    %edi,%eax
80101cb2:	5b                   	pop    %ebx
80101cb3:	5e                   	pop    %esi
80101cb4:	5f                   	pop    %edi
80101cb5:	5d                   	pop    %ebp
80101cb6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cb7:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101cbd:	81 fb b4 27 11 80    	cmp    $0x801127b4,%ebx
80101cc3:	74 10                	je     80101cd5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101cc5:	8b 43 08             	mov    0x8(%ebx),%eax
80101cc8:	85 c0                	test   %eax,%eax
80101cca:	0f 8f 50 ff ff ff    	jg     80101c20 <iget+0x30>
80101cd0:	e9 68 ff ff ff       	jmp    80101c3d <iget+0x4d>
    panic("iget: no inodes");
80101cd5:	83 ec 0c             	sub    $0xc,%esp
80101cd8:	68 24 7b 10 80       	push   $0x80107b24
80101cdd:	e8 8e e6 ff ff       	call   80100370 <panic>
80101ce2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ce9:	00 
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cf0 <bfree>:
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101cf3:	89 d0                	mov    %edx,%eax
80101cf5:	c1 e8 0c             	shr    $0xc,%eax
{
80101cf8:	89 e5                	mov    %esp,%ebp
80101cfa:	56                   	push   %esi
80101cfb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
80101cfc:	03 05 cc 27 11 80    	add    0x801127cc,%eax
{
80101d02:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101d04:	83 ec 08             	sub    $0x8,%esp
80101d07:	50                   	push   %eax
80101d08:	51                   	push   %ecx
80101d09:	e8 c2 e3 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101d0e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101d10:	c1 fb 03             	sar    $0x3,%ebx
80101d13:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101d16:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101d18:	83 e1 07             	and    $0x7,%ecx
80101d1b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101d20:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101d26:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101d28:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101d2d:	85 c1                	test   %eax,%ecx
80101d2f:	74 23                	je     80101d54 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101d31:	f7 d0                	not    %eax
  log_write(bp);
80101d33:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101d36:	21 c8                	and    %ecx,%eax
80101d38:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101d3c:	56                   	push   %esi
80101d3d:	e8 de 1a 00 00       	call   80103820 <log_write>
  brelse(bp);
80101d42:	89 34 24             	mov    %esi,(%esp)
80101d45:	e8 a6 e4 ff ff       	call   801001f0 <brelse>
}
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d50:	5b                   	pop    %ebx
80101d51:	5e                   	pop    %esi
80101d52:	5d                   	pop    %ebp
80101d53:	c3                   	ret
    panic("freeing free block");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 34 7b 10 80       	push   $0x80107b34
80101d5c:	e8 0f e6 ff ff       	call   80100370 <panic>
80101d61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d68:	00 
80101d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d70 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	89 c6                	mov    %eax,%esi
80101d77:	53                   	push   %ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d7b:	83 fa 0b             	cmp    $0xb,%edx
80101d7e:	0f 86 8c 00 00 00    	jbe    80101e10 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101d84:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101d87:	83 fb 7f             	cmp    $0x7f,%ebx
80101d8a:	0f 87 a2 00 00 00    	ja     80101e32 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d90:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d96:	85 c0                	test   %eax,%eax
80101d98:	74 5e                	je     80101df8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101d9a:	83 ec 08             	sub    $0x8,%esp
80101d9d:	50                   	push   %eax
80101d9e:	ff 36                	push   (%esi)
80101da0:	e8 2b e3 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101da5:	83 c4 10             	add    $0x10,%esp
80101da8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80101dac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80101dae:	8b 3b                	mov    (%ebx),%edi
80101db0:	85 ff                	test   %edi,%edi
80101db2:	74 1c                	je     80101dd0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	52                   	push   %edx
80101db8:	e8 33 e4 ff ff       	call   801001f0 <brelse>
80101dbd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc3:	89 f8                	mov    %edi,%eax
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret
80101dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101dd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101dd3:	8b 06                	mov    (%esi),%eax
80101dd5:	e8 06 fd ff ff       	call   80101ae0 <balloc>
      log_write(bp);
80101dda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ddd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101de0:	89 03                	mov    %eax,(%ebx)
80101de2:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101de4:	52                   	push   %edx
80101de5:	e8 36 1a 00 00       	call   80103820 <log_write>
80101dea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ded:	83 c4 10             	add    $0x10,%esp
80101df0:	eb c2                	jmp    80101db4 <bmap+0x44>
80101df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101df8:	8b 06                	mov    (%esi),%eax
80101dfa:	e8 e1 fc ff ff       	call   80101ae0 <balloc>
80101dff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101e05:	eb 93                	jmp    80101d9a <bmap+0x2a>
80101e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e0e:	00 
80101e0f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101e10:	8d 5a 14             	lea    0x14(%edx),%ebx
80101e13:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101e17:	85 ff                	test   %edi,%edi
80101e19:	75 a5                	jne    80101dc0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e1b:	8b 00                	mov    (%eax),%eax
80101e1d:	e8 be fc ff ff       	call   80101ae0 <balloc>
80101e22:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101e26:	89 c7                	mov    %eax,%edi
}
80101e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e2b:	5b                   	pop    %ebx
80101e2c:	89 f8                	mov    %edi,%eax
80101e2e:	5e                   	pop    %esi
80101e2f:	5f                   	pop    %edi
80101e30:	5d                   	pop    %ebp
80101e31:	c3                   	ret
  panic("bmap: out of range");
80101e32:	83 ec 0c             	sub    $0xc,%esp
80101e35:	68 47 7b 10 80       	push   $0x80107b47
80101e3a:	e8 31 e5 ff ff       	call   80100370 <panic>
80101e3f:	90                   	nop

80101e40 <readsb>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	56                   	push   %esi
80101e44:	53                   	push   %ebx
80101e45:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101e48:	83 ec 08             	sub    $0x8,%esp
80101e4b:	6a 01                	push   $0x1
80101e4d:	ff 75 08             	push   0x8(%ebp)
80101e50:	e8 7b e2 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101e55:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101e58:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101e5a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101e5d:	6a 1c                	push   $0x1c
80101e5f:	50                   	push   %eax
80101e60:	56                   	push   %esi
80101e61:	e8 ca 31 00 00       	call   80105030 <memmove>
  brelse(bp);
80101e66:	83 c4 10             	add    $0x10,%esp
80101e69:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101e6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e6f:	5b                   	pop    %ebx
80101e70:	5e                   	pop    %esi
80101e71:	5d                   	pop    %ebp
  brelse(bp);
80101e72:	e9 79 e3 ff ff       	jmp    801001f0 <brelse>
80101e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e7e:	00 
80101e7f:	90                   	nop

80101e80 <iinit>:
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	53                   	push   %ebx
80101e84:	bb a0 0b 11 80       	mov    $0x80110ba0,%ebx
80101e89:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101e8c:	68 5a 7b 10 80       	push   $0x80107b5a
80101e91:	68 60 0b 11 80       	push   $0x80110b60
80101e96:	e8 15 2e 00 00       	call   80104cb0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101e9b:	83 c4 10             	add    $0x10,%esp
80101e9e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101ea0:	83 ec 08             	sub    $0x8,%esp
80101ea3:	68 61 7b 10 80       	push   $0x80107b61
80101ea8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101ea9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101eaf:	e8 cc 2c 00 00       	call   80104b80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101eb4:	83 c4 10             	add    $0x10,%esp
80101eb7:	81 fb c0 27 11 80    	cmp    $0x801127c0,%ebx
80101ebd:	75 e1                	jne    80101ea0 <iinit+0x20>
  bp = bread(dev, 1);
80101ebf:	83 ec 08             	sub    $0x8,%esp
80101ec2:	6a 01                	push   $0x1
80101ec4:	ff 75 08             	push   0x8(%ebp)
80101ec7:	e8 04 e2 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101ecc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101ecf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101ed1:	8d 40 5c             	lea    0x5c(%eax),%eax
80101ed4:	6a 1c                	push   $0x1c
80101ed6:	50                   	push   %eax
80101ed7:	68 b4 27 11 80       	push   $0x801127b4
80101edc:	e8 4f 31 00 00       	call   80105030 <memmove>
  brelse(bp);
80101ee1:	89 1c 24             	mov    %ebx,(%esp)
80101ee4:	e8 07 e3 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ee9:	ff 35 cc 27 11 80    	push   0x801127cc
80101eef:	ff 35 c8 27 11 80    	push   0x801127c8
80101ef5:	ff 35 c4 27 11 80    	push   0x801127c4
80101efb:	ff 35 c0 27 11 80    	push   0x801127c0
80101f01:	ff 35 bc 27 11 80    	push   0x801127bc
80101f07:	ff 35 b8 27 11 80    	push   0x801127b8
80101f0d:	ff 35 b4 27 11 80    	push   0x801127b4
80101f13:	68 e0 7f 10 80       	push   $0x80107fe0
80101f18:	e8 43 e8 ff ff       	call   80100760 <cprintf>
}
80101f1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f20:	83 c4 30             	add    $0x30,%esp
80101f23:	c9                   	leave
80101f24:	c3                   	ret
80101f25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f2c:	00 
80101f2d:	8d 76 00             	lea    0x0(%esi),%esi

80101f30 <ialloc>:
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101f3c:	83 3d bc 27 11 80 01 	cmpl   $0x1,0x801127bc
{
80101f43:	8b 75 08             	mov    0x8(%ebp),%esi
80101f46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101f49:	0f 86 91 00 00 00    	jbe    80101fe0 <ialloc+0xb0>
80101f4f:	bf 01 00 00 00       	mov    $0x1,%edi
80101f54:	eb 21                	jmp    80101f77 <ialloc+0x47>
80101f56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f5d:	00 
80101f5e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101f60:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101f63:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101f66:	53                   	push   %ebx
80101f67:	e8 84 e2 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101f6c:	83 c4 10             	add    $0x10,%esp
80101f6f:	3b 3d bc 27 11 80    	cmp    0x801127bc,%edi
80101f75:	73 69                	jae    80101fe0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101f77:	89 f8                	mov    %edi,%eax
80101f79:	83 ec 08             	sub    $0x8,%esp
80101f7c:	c1 e8 03             	shr    $0x3,%eax
80101f7f:	03 05 c8 27 11 80    	add    0x801127c8,%eax
80101f85:	50                   	push   %eax
80101f86:	56                   	push   %esi
80101f87:	e8 44 e1 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101f8c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101f8f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	83 e0 07             	and    $0x7,%eax
80101f96:	c1 e0 06             	shl    $0x6,%eax
80101f99:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101f9d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101fa1:	75 bd                	jne    80101f60 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101fa3:	83 ec 04             	sub    $0x4,%esp
80101fa6:	6a 40                	push   $0x40
80101fa8:	6a 00                	push   $0x0
80101faa:	51                   	push   %ecx
80101fab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fae:	e8 ed 2f 00 00       	call   80104fa0 <memset>
      dip->type = type;
80101fb3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101fb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101fbd:	89 1c 24             	mov    %ebx,(%esp)
80101fc0:	e8 5b 18 00 00       	call   80103820 <log_write>
      brelse(bp);
80101fc5:	89 1c 24             	mov    %ebx,(%esp)
80101fc8:	e8 23 e2 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101fcd:	83 c4 10             	add    $0x10,%esp
}
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101fd3:	89 fa                	mov    %edi,%edx
}
80101fd5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101fd6:	89 f0                	mov    %esi,%eax
}
80101fd8:	5e                   	pop    %esi
80101fd9:	5f                   	pop    %edi
80101fda:	5d                   	pop    %ebp
      return iget(dev, inum);
80101fdb:	e9 10 fc ff ff       	jmp    80101bf0 <iget>
  panic("ialloc: no inodes");
80101fe0:	83 ec 0c             	sub    $0xc,%esp
80101fe3:	68 67 7b 10 80       	push   $0x80107b67
80101fe8:	e8 83 e3 ff ff       	call   80100370 <panic>
80101fed:	8d 76 00             	lea    0x0(%esi),%esi

80101ff0 <iupdate>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	56                   	push   %esi
80101ff4:	53                   	push   %ebx
80101ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ff8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ffb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ffe:	83 ec 08             	sub    $0x8,%esp
80102001:	c1 e8 03             	shr    $0x3,%eax
80102004:	03 05 c8 27 11 80    	add    0x801127c8,%eax
8010200a:	50                   	push   %eax
8010200b:	ff 73 a4             	push   -0x5c(%ebx)
8010200e:	e8 bd e0 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102013:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102017:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010201a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010201c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010201f:	83 e0 07             	and    $0x7,%eax
80102022:	c1 e0 06             	shl    $0x6,%eax
80102025:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102029:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010202c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102030:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102033:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102037:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010203b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010203f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102043:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102047:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010204a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010204d:	6a 34                	push   $0x34
8010204f:	53                   	push   %ebx
80102050:	50                   	push   %eax
80102051:	e8 da 2f 00 00       	call   80105030 <memmove>
  log_write(bp);
80102056:	89 34 24             	mov    %esi,(%esp)
80102059:	e8 c2 17 00 00       	call   80103820 <log_write>
  brelse(bp);
8010205e:	83 c4 10             	add    $0x10,%esp
80102061:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102064:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102067:	5b                   	pop    %ebx
80102068:	5e                   	pop    %esi
80102069:	5d                   	pop    %ebp
  brelse(bp);
8010206a:	e9 81 e1 ff ff       	jmp    801001f0 <brelse>
8010206f:	90                   	nop

80102070 <idup>:
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	53                   	push   %ebx
80102074:	83 ec 10             	sub    $0x10,%esp
80102077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010207a:	68 60 0b 11 80       	push   $0x80110b60
8010207f:	e8 1c 2e 00 00       	call   80104ea0 <acquire>
  ip->ref++;
80102084:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102088:	c7 04 24 60 0b 11 80 	movl   $0x80110b60,(%esp)
8010208f:	e8 ac 2d 00 00       	call   80104e40 <release>
}
80102094:	89 d8                	mov    %ebx,%eax
80102096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102099:	c9                   	leave
8010209a:	c3                   	ret
8010209b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801020a0 <ilock>:
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	56                   	push   %esi
801020a4:	53                   	push   %ebx
801020a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801020a8:	85 db                	test   %ebx,%ebx
801020aa:	0f 84 b7 00 00 00    	je     80102167 <ilock+0xc7>
801020b0:	8b 53 08             	mov    0x8(%ebx),%edx
801020b3:	85 d2                	test   %edx,%edx
801020b5:	0f 8e ac 00 00 00    	jle    80102167 <ilock+0xc7>
  acquiresleep(&ip->lock);
801020bb:	83 ec 0c             	sub    $0xc,%esp
801020be:	8d 43 0c             	lea    0xc(%ebx),%eax
801020c1:	50                   	push   %eax
801020c2:	e8 f9 2a 00 00       	call   80104bc0 <acquiresleep>
  if(ip->valid == 0){
801020c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801020ca:	83 c4 10             	add    $0x10,%esp
801020cd:	85 c0                	test   %eax,%eax
801020cf:	74 0f                	je     801020e0 <ilock+0x40>
}
801020d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020d4:	5b                   	pop    %ebx
801020d5:	5e                   	pop    %esi
801020d6:	5d                   	pop    %ebp
801020d7:	c3                   	ret
801020d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801020e0:	8b 43 04             	mov    0x4(%ebx),%eax
801020e3:	83 ec 08             	sub    $0x8,%esp
801020e6:	c1 e8 03             	shr    $0x3,%eax
801020e9:	03 05 c8 27 11 80    	add    0x801127c8,%eax
801020ef:	50                   	push   %eax
801020f0:	ff 33                	push   (%ebx)
801020f2:	e8 d9 df ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801020f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801020fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801020fc:	8b 43 04             	mov    0x4(%ebx),%eax
801020ff:	83 e0 07             	and    $0x7,%eax
80102102:	c1 e0 06             	shl    $0x6,%eax
80102105:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102109:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010210c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010210f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102113:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102117:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010211b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010211f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102123:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102127:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010212b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010212e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102131:	6a 34                	push   $0x34
80102133:	50                   	push   %eax
80102134:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102137:	50                   	push   %eax
80102138:	e8 f3 2e 00 00       	call   80105030 <memmove>
    brelse(bp);
8010213d:	89 34 24             	mov    %esi,(%esp)
80102140:	e8 ab e0 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102145:	83 c4 10             	add    $0x10,%esp
80102148:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010214d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102154:	0f 85 77 ff ff ff    	jne    801020d1 <ilock+0x31>
      panic("ilock: no type");
8010215a:	83 ec 0c             	sub    $0xc,%esp
8010215d:	68 7f 7b 10 80       	push   $0x80107b7f
80102162:	e8 09 e2 ff ff       	call   80100370 <panic>
    panic("ilock");
80102167:	83 ec 0c             	sub    $0xc,%esp
8010216a:	68 79 7b 10 80       	push   $0x80107b79
8010216f:	e8 fc e1 ff ff       	call   80100370 <panic>
80102174:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010217b:	00 
8010217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102180 <iunlock>:
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	56                   	push   %esi
80102184:	53                   	push   %ebx
80102185:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102188:	85 db                	test   %ebx,%ebx
8010218a:	74 28                	je     801021b4 <iunlock+0x34>
8010218c:	83 ec 0c             	sub    $0xc,%esp
8010218f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102192:	56                   	push   %esi
80102193:	e8 c8 2a 00 00       	call   80104c60 <holdingsleep>
80102198:	83 c4 10             	add    $0x10,%esp
8010219b:	85 c0                	test   %eax,%eax
8010219d:	74 15                	je     801021b4 <iunlock+0x34>
8010219f:	8b 43 08             	mov    0x8(%ebx),%eax
801021a2:	85 c0                	test   %eax,%eax
801021a4:	7e 0e                	jle    801021b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801021a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801021a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021ac:	5b                   	pop    %ebx
801021ad:	5e                   	pop    %esi
801021ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801021af:	e9 6c 2a 00 00       	jmp    80104c20 <releasesleep>
    panic("iunlock");
801021b4:	83 ec 0c             	sub    $0xc,%esp
801021b7:	68 8e 7b 10 80       	push   $0x80107b8e
801021bc:	e8 af e1 ff ff       	call   80100370 <panic>
801021c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021c8:	00 
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <iput>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 28             	sub    $0x28,%esp
801021d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801021dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801021df:	57                   	push   %edi
801021e0:	e8 db 29 00 00       	call   80104bc0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801021e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801021e8:	83 c4 10             	add    $0x10,%esp
801021eb:	85 d2                	test   %edx,%edx
801021ed:	74 07                	je     801021f6 <iput+0x26>
801021ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801021f4:	74 32                	je     80102228 <iput+0x58>
  releasesleep(&ip->lock);
801021f6:	83 ec 0c             	sub    $0xc,%esp
801021f9:	57                   	push   %edi
801021fa:	e8 21 2a 00 00       	call   80104c20 <releasesleep>
  acquire(&icache.lock);
801021ff:	c7 04 24 60 0b 11 80 	movl   $0x80110b60,(%esp)
80102206:	e8 95 2c 00 00       	call   80104ea0 <acquire>
  ip->ref--;
8010220b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010220f:	83 c4 10             	add    $0x10,%esp
80102212:	c7 45 08 60 0b 11 80 	movl   $0x80110b60,0x8(%ebp)
}
80102219:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221c:	5b                   	pop    %ebx
8010221d:	5e                   	pop    %esi
8010221e:	5f                   	pop    %edi
8010221f:	5d                   	pop    %ebp
  release(&icache.lock);
80102220:	e9 1b 2c 00 00       	jmp    80104e40 <release>
80102225:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 60 0b 11 80       	push   $0x80110b60
80102230:	e8 6b 2c 00 00       	call   80104ea0 <acquire>
    int r = ip->ref;
80102235:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102238:	c7 04 24 60 0b 11 80 	movl   $0x80110b60,(%esp)
8010223f:	e8 fc 2b 00 00       	call   80104e40 <release>
    if(r == 1){
80102244:	83 c4 10             	add    $0x10,%esp
80102247:	83 fe 01             	cmp    $0x1,%esi
8010224a:	75 aa                	jne    801021f6 <iput+0x26>
8010224c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102252:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102255:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102258:	89 df                	mov    %ebx,%edi
8010225a:	89 cb                	mov    %ecx,%ebx
8010225c:	eb 09                	jmp    80102267 <iput+0x97>
8010225e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102260:	83 c6 04             	add    $0x4,%esi
80102263:	39 de                	cmp    %ebx,%esi
80102265:	74 19                	je     80102280 <iput+0xb0>
    if(ip->addrs[i]){
80102267:	8b 16                	mov    (%esi),%edx
80102269:	85 d2                	test   %edx,%edx
8010226b:	74 f3                	je     80102260 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010226d:	8b 07                	mov    (%edi),%eax
8010226f:	e8 7c fa ff ff       	call   80101cf0 <bfree>
      ip->addrs[i] = 0;
80102274:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010227a:	eb e4                	jmp    80102260 <iput+0x90>
8010227c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102280:	89 fb                	mov    %edi,%ebx
80102282:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102285:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010228b:	85 c0                	test   %eax,%eax
8010228d:	75 2d                	jne    801022bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010228f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102292:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102299:	53                   	push   %ebx
8010229a:	e8 51 fd ff ff       	call   80101ff0 <iupdate>
      ip->type = 0;
8010229f:	31 c0                	xor    %eax,%eax
801022a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801022a5:	89 1c 24             	mov    %ebx,(%esp)
801022a8:	e8 43 fd ff ff       	call   80101ff0 <iupdate>
      ip->valid = 0;
801022ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801022b4:	83 c4 10             	add    $0x10,%esp
801022b7:	e9 3a ff ff ff       	jmp    801021f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801022bc:	83 ec 08             	sub    $0x8,%esp
801022bf:	50                   	push   %eax
801022c0:	ff 33                	push   (%ebx)
801022c2:	e8 09 de ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801022cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801022d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801022d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801022d9:	89 cf                	mov    %ecx,%edi
801022db:	eb 0a                	jmp    801022e7 <iput+0x117>
801022dd:	8d 76 00             	lea    0x0(%esi),%esi
801022e0:	83 c6 04             	add    $0x4,%esi
801022e3:	39 fe                	cmp    %edi,%esi
801022e5:	74 0f                	je     801022f6 <iput+0x126>
      if(a[j])
801022e7:	8b 16                	mov    (%esi),%edx
801022e9:	85 d2                	test   %edx,%edx
801022eb:	74 f3                	je     801022e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801022ed:	8b 03                	mov    (%ebx),%eax
801022ef:	e8 fc f9 ff ff       	call   80101cf0 <bfree>
801022f4:	eb ea                	jmp    801022e0 <iput+0x110>
    brelse(bp);
801022f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801022f9:	83 ec 0c             	sub    $0xc,%esp
801022fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801022ff:	50                   	push   %eax
80102300:	e8 eb de ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102305:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010230b:	8b 03                	mov    (%ebx),%eax
8010230d:	e8 de f9 ff ff       	call   80101cf0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102312:	83 c4 10             	add    $0x10,%esp
80102315:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010231c:	00 00 00 
8010231f:	e9 6b ff ff ff       	jmp    8010228f <iput+0xbf>
80102324:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010232b:	00 
8010232c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102330 <iunlockput>:
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	56                   	push   %esi
80102334:	53                   	push   %ebx
80102335:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102338:	85 db                	test   %ebx,%ebx
8010233a:	74 34                	je     80102370 <iunlockput+0x40>
8010233c:	83 ec 0c             	sub    $0xc,%esp
8010233f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102342:	56                   	push   %esi
80102343:	e8 18 29 00 00       	call   80104c60 <holdingsleep>
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	85 c0                	test   %eax,%eax
8010234d:	74 21                	je     80102370 <iunlockput+0x40>
8010234f:	8b 43 08             	mov    0x8(%ebx),%eax
80102352:	85 c0                	test   %eax,%eax
80102354:	7e 1a                	jle    80102370 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102356:	83 ec 0c             	sub    $0xc,%esp
80102359:	56                   	push   %esi
8010235a:	e8 c1 28 00 00       	call   80104c20 <releasesleep>
  iput(ip);
8010235f:	83 c4 10             	add    $0x10,%esp
80102362:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102365:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102368:	5b                   	pop    %ebx
80102369:	5e                   	pop    %esi
8010236a:	5d                   	pop    %ebp
  iput(ip);
8010236b:	e9 60 fe ff ff       	jmp    801021d0 <iput>
    panic("iunlock");
80102370:	83 ec 0c             	sub    $0xc,%esp
80102373:	68 8e 7b 10 80       	push   $0x80107b8e
80102378:	e8 f3 df ff ff       	call   80100370 <panic>
8010237d:	8d 76 00             	lea    0x0(%esi),%esi

80102380 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	8b 55 08             	mov    0x8(%ebp),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102389:	8b 0a                	mov    (%edx),%ecx
8010238b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010238e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102391:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102394:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102398:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010239b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010239f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801023a3:	8b 52 58             	mov    0x58(%edx),%edx
801023a6:	89 50 10             	mov    %edx,0x10(%eax)
}
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret
801023ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801023b0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	57                   	push   %edi
801023b4:	56                   	push   %esi
801023b5:	53                   	push   %ebx
801023b6:	83 ec 1c             	sub    $0x1c,%esp
801023b9:	8b 75 08             	mov    0x8(%ebp),%esi
801023bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801023bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023c2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
801023c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801023ca:	89 75 d8             	mov    %esi,-0x28(%ebp)
801023cd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
801023d0:	0f 84 aa 00 00 00    	je     80102480 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801023d6:	8b 75 d8             	mov    -0x28(%ebp),%esi
801023d9:	8b 56 58             	mov    0x58(%esi),%edx
801023dc:	39 fa                	cmp    %edi,%edx
801023de:	0f 82 bd 00 00 00    	jb     801024a1 <readi+0xf1>
801023e4:	89 f9                	mov    %edi,%ecx
801023e6:	31 db                	xor    %ebx,%ebx
801023e8:	01 c1                	add    %eax,%ecx
801023ea:	0f 92 c3             	setb   %bl
801023ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801023f0:	0f 82 ab 00 00 00    	jb     801024a1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801023f6:	89 d3                	mov    %edx,%ebx
801023f8:	29 fb                	sub    %edi,%ebx
801023fa:	39 ca                	cmp    %ecx,%edx
801023fc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023ff:	85 c0                	test   %eax,%eax
80102401:	74 73                	je     80102476 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102403:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102410:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102413:	89 fa                	mov    %edi,%edx
80102415:	c1 ea 09             	shr    $0x9,%edx
80102418:	89 d8                	mov    %ebx,%eax
8010241a:	e8 51 f9 ff ff       	call   80101d70 <bmap>
8010241f:	83 ec 08             	sub    $0x8,%esp
80102422:	50                   	push   %eax
80102423:	ff 33                	push   (%ebx)
80102425:	e8 a6 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010242a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010242d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102432:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102434:	89 f8                	mov    %edi,%eax
80102436:	25 ff 01 00 00       	and    $0x1ff,%eax
8010243b:	29 f3                	sub    %esi,%ebx
8010243d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
8010243f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102443:	39 d9                	cmp    %ebx,%ecx
80102445:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102448:	83 c4 0c             	add    $0xc,%esp
8010244b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010244c:	01 de                	add    %ebx,%esi
8010244e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102450:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102453:	50                   	push   %eax
80102454:	ff 75 e0             	push   -0x20(%ebp)
80102457:	e8 d4 2b 00 00       	call   80105030 <memmove>
    brelse(bp);
8010245c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010245f:	89 14 24             	mov    %edx,(%esp)
80102462:	e8 89 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102467:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010246a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	72 9c                	jb     80102410 <readi+0x60>
80102474:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102476:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102479:	5b                   	pop    %ebx
8010247a:	5e                   	pop    %esi
8010247b:	5f                   	pop    %edi
8010247c:	5d                   	pop    %ebp
8010247d:	c3                   	ret
8010247e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102480:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102484:	66 83 fa 09          	cmp    $0x9,%dx
80102488:	77 17                	ja     801024a1 <readi+0xf1>
8010248a:	8b 14 d5 00 0b 11 80 	mov    -0x7feef500(,%edx,8),%edx
80102491:	85 d2                	test   %edx,%edx
80102493:	74 0c                	je     801024a1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102495:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5f                   	pop    %edi
8010249e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010249f:	ff e2                	jmp    *%edx
      return -1;
801024a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024a6:	eb ce                	jmp    80102476 <readi+0xc6>
801024a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024af:	00 

801024b0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 1c             	sub    $0x1c,%esp
801024b9:	8b 45 08             	mov    0x8(%ebp),%eax
801024bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801024bf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801024c2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801024c7:	89 7d dc             	mov    %edi,-0x24(%ebp)
801024ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
801024cd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801024d0:	0f 84 ba 00 00 00    	je     80102590 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801024d6:	39 78 58             	cmp    %edi,0x58(%eax)
801024d9:	0f 82 ea 00 00 00    	jb     801025c9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801024df:	8b 75 e0             	mov    -0x20(%ebp),%esi
801024e2:	89 f2                	mov    %esi,%edx
801024e4:	01 fa                	add    %edi,%edx
801024e6:	0f 82 dd 00 00 00    	jb     801025c9 <writei+0x119>
801024ec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
801024f2:	0f 87 d1 00 00 00    	ja     801025c9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801024f8:	85 f6                	test   %esi,%esi
801024fa:	0f 84 85 00 00 00    	je     80102585 <writei+0xd5>
80102500:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102507:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102510:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102513:	89 fa                	mov    %edi,%edx
80102515:	c1 ea 09             	shr    $0x9,%edx
80102518:	89 f0                	mov    %esi,%eax
8010251a:	e8 51 f8 ff ff       	call   80101d70 <bmap>
8010251f:	83 ec 08             	sub    $0x8,%esp
80102522:	50                   	push   %eax
80102523:	ff 36                	push   (%esi)
80102525:	e8 a6 db ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010252a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010252d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102530:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102535:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102537:	89 f8                	mov    %edi,%eax
80102539:	25 ff 01 00 00       	and    $0x1ff,%eax
8010253e:	29 d3                	sub    %edx,%ebx
80102540:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102542:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102546:	39 d9                	cmp    %ebx,%ecx
80102548:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010254b:	83 c4 0c             	add    $0xc,%esp
8010254e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010254f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102551:	ff 75 dc             	push   -0x24(%ebp)
80102554:	50                   	push   %eax
80102555:	e8 d6 2a 00 00       	call   80105030 <memmove>
    log_write(bp);
8010255a:	89 34 24             	mov    %esi,(%esp)
8010255d:	e8 be 12 00 00       	call   80103820 <log_write>
    brelse(bp);
80102562:	89 34 24             	mov    %esi,(%esp)
80102565:	e8 86 dc ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010256a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010256d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102570:	83 c4 10             	add    $0x10,%esp
80102573:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102576:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102579:	39 d8                	cmp    %ebx,%eax
8010257b:	72 93                	jb     80102510 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010257d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102580:	39 78 58             	cmp    %edi,0x58(%eax)
80102583:	72 33                	jb     801025b8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102585:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102588:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010258b:	5b                   	pop    %ebx
8010258c:	5e                   	pop    %esi
8010258d:	5f                   	pop    %edi
8010258e:	5d                   	pop    %ebp
8010258f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102590:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102594:	66 83 f8 09          	cmp    $0x9,%ax
80102598:	77 2f                	ja     801025c9 <writei+0x119>
8010259a:	8b 04 c5 04 0b 11 80 	mov    -0x7feef4fc(,%eax,8),%eax
801025a1:	85 c0                	test   %eax,%eax
801025a3:	74 24                	je     801025c9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
801025a5:	89 75 10             	mov    %esi,0x10(%ebp)
}
801025a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025ab:	5b                   	pop    %ebx
801025ac:	5e                   	pop    %esi
801025ad:	5f                   	pop    %edi
801025ae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801025af:	ff e0                	jmp    *%eax
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
801025b8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801025bb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
801025be:	50                   	push   %eax
801025bf:	e8 2c fa ff ff       	call   80101ff0 <iupdate>
801025c4:	83 c4 10             	add    $0x10,%esp
801025c7:	eb bc                	jmp    80102585 <writei+0xd5>
      return -1;
801025c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ce:	eb b8                	jmp    80102588 <writei+0xd8>

801025d0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801025d6:	6a 0e                	push   $0xe
801025d8:	ff 75 0c             	push   0xc(%ebp)
801025db:	ff 75 08             	push   0x8(%ebp)
801025de:	e8 bd 2a 00 00       	call   801050a0 <strncmp>
}
801025e3:	c9                   	leave
801025e4:	c3                   	ret
801025e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ec:	00 
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	57                   	push   %edi
801025f4:	56                   	push   %esi
801025f5:	53                   	push   %ebx
801025f6:	83 ec 1c             	sub    $0x1c,%esp
801025f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801025fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102601:	0f 85 85 00 00 00    	jne    8010268c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102607:	8b 53 58             	mov    0x58(%ebx),%edx
8010260a:	31 ff                	xor    %edi,%edi
8010260c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010260f:	85 d2                	test   %edx,%edx
80102611:	74 3e                	je     80102651 <dirlookup+0x61>
80102613:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102618:	6a 10                	push   $0x10
8010261a:	57                   	push   %edi
8010261b:	56                   	push   %esi
8010261c:	53                   	push   %ebx
8010261d:	e8 8e fd ff ff       	call   801023b0 <readi>
80102622:	83 c4 10             	add    $0x10,%esp
80102625:	83 f8 10             	cmp    $0x10,%eax
80102628:	75 55                	jne    8010267f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010262a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010262f:	74 18                	je     80102649 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102631:	83 ec 04             	sub    $0x4,%esp
80102634:	8d 45 da             	lea    -0x26(%ebp),%eax
80102637:	6a 0e                	push   $0xe
80102639:	50                   	push   %eax
8010263a:	ff 75 0c             	push   0xc(%ebp)
8010263d:	e8 5e 2a 00 00       	call   801050a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102642:	83 c4 10             	add    $0x10,%esp
80102645:	85 c0                	test   %eax,%eax
80102647:	74 17                	je     80102660 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102649:	83 c7 10             	add    $0x10,%edi
8010264c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010264f:	72 c7                	jb     80102618 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102651:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102654:	31 c0                	xor    %eax,%eax
}
80102656:	5b                   	pop    %ebx
80102657:	5e                   	pop    %esi
80102658:	5f                   	pop    %edi
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80102660:	8b 45 10             	mov    0x10(%ebp),%eax
80102663:	85 c0                	test   %eax,%eax
80102665:	74 05                	je     8010266c <dirlookup+0x7c>
        *poff = off;
80102667:	8b 45 10             	mov    0x10(%ebp),%eax
8010266a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010266c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102670:	8b 03                	mov    (%ebx),%eax
80102672:	e8 79 f5 ff ff       	call   80101bf0 <iget>
}
80102677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010267a:	5b                   	pop    %ebx
8010267b:	5e                   	pop    %esi
8010267c:	5f                   	pop    %edi
8010267d:	5d                   	pop    %ebp
8010267e:	c3                   	ret
      panic("dirlookup read");
8010267f:	83 ec 0c             	sub    $0xc,%esp
80102682:	68 a8 7b 10 80       	push   $0x80107ba8
80102687:	e8 e4 dc ff ff       	call   80100370 <panic>
    panic("dirlookup not DIR");
8010268c:	83 ec 0c             	sub    $0xc,%esp
8010268f:	68 96 7b 10 80       	push   $0x80107b96
80102694:	e8 d7 dc ff ff       	call   80100370 <panic>
80102699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	57                   	push   %edi
801026a4:	56                   	push   %esi
801026a5:	53                   	push   %ebx
801026a6:	89 c3                	mov    %eax,%ebx
801026a8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801026ab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801026ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
801026b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801026b4:	0f 84 9e 01 00 00    	je     80102858 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801026ba:	e8 a1 1b 00 00       	call   80104260 <myproc>
  acquire(&icache.lock);
801026bf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801026c2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801026c5:	68 60 0b 11 80       	push   $0x80110b60
801026ca:	e8 d1 27 00 00       	call   80104ea0 <acquire>
  ip->ref++;
801026cf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801026d3:	c7 04 24 60 0b 11 80 	movl   $0x80110b60,(%esp)
801026da:	e8 61 27 00 00       	call   80104e40 <release>
801026df:	83 c4 10             	add    $0x10,%esp
801026e2:	eb 07                	jmp    801026eb <namex+0x4b>
801026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801026e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801026eb:	0f b6 03             	movzbl (%ebx),%eax
801026ee:	3c 2f                	cmp    $0x2f,%al
801026f0:	74 f6                	je     801026e8 <namex+0x48>
  if(*path == 0)
801026f2:	84 c0                	test   %al,%al
801026f4:	0f 84 06 01 00 00    	je     80102800 <namex+0x160>
  while(*path != '/' && *path != 0)
801026fa:	0f b6 03             	movzbl (%ebx),%eax
801026fd:	84 c0                	test   %al,%al
801026ff:	0f 84 10 01 00 00    	je     80102815 <namex+0x175>
80102705:	89 df                	mov    %ebx,%edi
80102707:	3c 2f                	cmp    $0x2f,%al
80102709:	0f 84 06 01 00 00    	je     80102815 <namex+0x175>
8010270f:	90                   	nop
80102710:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80102714:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80102717:	3c 2f                	cmp    $0x2f,%al
80102719:	74 04                	je     8010271f <namex+0x7f>
8010271b:	84 c0                	test   %al,%al
8010271d:	75 f1                	jne    80102710 <namex+0x70>
  len = path - s;
8010271f:	89 f8                	mov    %edi,%eax
80102721:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80102723:	83 f8 0d             	cmp    $0xd,%eax
80102726:	0f 8e ac 00 00 00    	jle    801027d8 <namex+0x138>
    memmove(name, s, DIRSIZ);
8010272c:	83 ec 04             	sub    $0x4,%esp
8010272f:	6a 0e                	push   $0xe
80102731:	53                   	push   %ebx
80102732:	89 fb                	mov    %edi,%ebx
80102734:	ff 75 e4             	push   -0x1c(%ebp)
80102737:	e8 f4 28 00 00       	call   80105030 <memmove>
8010273c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010273f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102742:	75 0c                	jne    80102750 <namex+0xb0>
80102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102748:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010274b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010274e:	74 f8                	je     80102748 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	56                   	push   %esi
80102754:	e8 47 f9 ff ff       	call   801020a0 <ilock>
    if(ip->type != T_DIR){
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102761:	0f 85 b7 00 00 00    	jne    8010281e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102767:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010276a:	85 c0                	test   %eax,%eax
8010276c:	74 09                	je     80102777 <namex+0xd7>
8010276e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102771:	0f 84 f7 00 00 00    	je     8010286e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102777:	83 ec 04             	sub    $0x4,%esp
8010277a:	6a 00                	push   $0x0
8010277c:	ff 75 e4             	push   -0x1c(%ebp)
8010277f:	56                   	push   %esi
80102780:	e8 6b fe ff ff       	call   801025f0 <dirlookup>
80102785:	83 c4 10             	add    $0x10,%esp
80102788:	89 c7                	mov    %eax,%edi
8010278a:	85 c0                	test   %eax,%eax
8010278c:	0f 84 8c 00 00 00    	je     8010281e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102792:	83 ec 0c             	sub    $0xc,%esp
80102795:	8d 4e 0c             	lea    0xc(%esi),%ecx
80102798:	51                   	push   %ecx
80102799:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010279c:	e8 bf 24 00 00       	call   80104c60 <holdingsleep>
801027a1:	83 c4 10             	add    $0x10,%esp
801027a4:	85 c0                	test   %eax,%eax
801027a6:	0f 84 02 01 00 00    	je     801028ae <namex+0x20e>
801027ac:	8b 56 08             	mov    0x8(%esi),%edx
801027af:	85 d2                	test   %edx,%edx
801027b1:	0f 8e f7 00 00 00    	jle    801028ae <namex+0x20e>
  releasesleep(&ip->lock);
801027b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	51                   	push   %ecx
801027be:	e8 5d 24 00 00       	call   80104c20 <releasesleep>
  iput(ip);
801027c3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
801027c6:	89 fe                	mov    %edi,%esi
  iput(ip);
801027c8:	e8 03 fa ff ff       	call   801021d0 <iput>
801027cd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801027d0:	e9 16 ff ff ff       	jmp    801026eb <namex+0x4b>
801027d5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801027d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801027db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
801027de:	83 ec 04             	sub    $0x4,%esp
801027e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801027e4:	50                   	push   %eax
801027e5:	53                   	push   %ebx
    name[len] = 0;
801027e6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801027e8:	ff 75 e4             	push   -0x1c(%ebp)
801027eb:	e8 40 28 00 00       	call   80105030 <memmove>
    name[len] = 0;
801027f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	c6 01 00             	movb   $0x0,(%ecx)
801027f9:	e9 41 ff ff ff       	jmp    8010273f <namex+0x9f>
801027fe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80102800:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102803:	85 c0                	test   %eax,%eax
80102805:	0f 85 93 00 00 00    	jne    8010289e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
8010280b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010280e:	89 f0                	mov    %esi,%eax
80102810:	5b                   	pop    %ebx
80102811:	5e                   	pop    %esi
80102812:	5f                   	pop    %edi
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret
  while(*path != '/' && *path != 0)
80102815:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102818:	89 df                	mov    %ebx,%edi
8010281a:	31 c0                	xor    %eax,%eax
8010281c:	eb c0                	jmp    801027de <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010281e:	83 ec 0c             	sub    $0xc,%esp
80102821:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102824:	53                   	push   %ebx
80102825:	e8 36 24 00 00       	call   80104c60 <holdingsleep>
8010282a:	83 c4 10             	add    $0x10,%esp
8010282d:	85 c0                	test   %eax,%eax
8010282f:	74 7d                	je     801028ae <namex+0x20e>
80102831:	8b 4e 08             	mov    0x8(%esi),%ecx
80102834:	85 c9                	test   %ecx,%ecx
80102836:	7e 76                	jle    801028ae <namex+0x20e>
  releasesleep(&ip->lock);
80102838:	83 ec 0c             	sub    $0xc,%esp
8010283b:	53                   	push   %ebx
8010283c:	e8 df 23 00 00       	call   80104c20 <releasesleep>
  iput(ip);
80102841:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102844:	31 f6                	xor    %esi,%esi
  iput(ip);
80102846:	e8 85 f9 ff ff       	call   801021d0 <iput>
      return 0;
8010284b:	83 c4 10             	add    $0x10,%esp
}
8010284e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102851:	89 f0                	mov    %esi,%eax
80102853:	5b                   	pop    %ebx
80102854:	5e                   	pop    %esi
80102855:	5f                   	pop    %edi
80102856:	5d                   	pop    %ebp
80102857:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80102858:	ba 01 00 00 00       	mov    $0x1,%edx
8010285d:	b8 01 00 00 00       	mov    $0x1,%eax
80102862:	e8 89 f3 ff ff       	call   80101bf0 <iget>
80102867:	89 c6                	mov    %eax,%esi
80102869:	e9 7d fe ff ff       	jmp    801026eb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010286e:	83 ec 0c             	sub    $0xc,%esp
80102871:	8d 5e 0c             	lea    0xc(%esi),%ebx
80102874:	53                   	push   %ebx
80102875:	e8 e6 23 00 00       	call   80104c60 <holdingsleep>
8010287a:	83 c4 10             	add    $0x10,%esp
8010287d:	85 c0                	test   %eax,%eax
8010287f:	74 2d                	je     801028ae <namex+0x20e>
80102881:	8b 7e 08             	mov    0x8(%esi),%edi
80102884:	85 ff                	test   %edi,%edi
80102886:	7e 26                	jle    801028ae <namex+0x20e>
  releasesleep(&ip->lock);
80102888:	83 ec 0c             	sub    $0xc,%esp
8010288b:	53                   	push   %ebx
8010288c:	e8 8f 23 00 00       	call   80104c20 <releasesleep>
}
80102891:	83 c4 10             	add    $0x10,%esp
}
80102894:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102897:	89 f0                	mov    %esi,%eax
80102899:	5b                   	pop    %ebx
8010289a:	5e                   	pop    %esi
8010289b:	5f                   	pop    %edi
8010289c:	5d                   	pop    %ebp
8010289d:	c3                   	ret
    iput(ip);
8010289e:	83 ec 0c             	sub    $0xc,%esp
801028a1:	56                   	push   %esi
      return 0;
801028a2:	31 f6                	xor    %esi,%esi
    iput(ip);
801028a4:	e8 27 f9 ff ff       	call   801021d0 <iput>
    return 0;
801028a9:	83 c4 10             	add    $0x10,%esp
801028ac:	eb a0                	jmp    8010284e <namex+0x1ae>
    panic("iunlock");
801028ae:	83 ec 0c             	sub    $0xc,%esp
801028b1:	68 8e 7b 10 80       	push   $0x80107b8e
801028b6:	e8 b5 da ff ff       	call   80100370 <panic>
801028bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801028c0 <dirlink>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	57                   	push   %edi
801028c4:	56                   	push   %esi
801028c5:	53                   	push   %ebx
801028c6:	83 ec 20             	sub    $0x20,%esp
801028c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801028cc:	6a 00                	push   $0x0
801028ce:	ff 75 0c             	push   0xc(%ebp)
801028d1:	53                   	push   %ebx
801028d2:	e8 19 fd ff ff       	call   801025f0 <dirlookup>
801028d7:	83 c4 10             	add    $0x10,%esp
801028da:	85 c0                	test   %eax,%eax
801028dc:	75 67                	jne    80102945 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801028de:	8b 7b 58             	mov    0x58(%ebx),%edi
801028e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801028e4:	85 ff                	test   %edi,%edi
801028e6:	74 29                	je     80102911 <dirlink+0x51>
801028e8:	31 ff                	xor    %edi,%edi
801028ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801028ed:	eb 09                	jmp    801028f8 <dirlink+0x38>
801028ef:	90                   	nop
801028f0:	83 c7 10             	add    $0x10,%edi
801028f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801028f6:	73 19                	jae    80102911 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028f8:	6a 10                	push   $0x10
801028fa:	57                   	push   %edi
801028fb:	56                   	push   %esi
801028fc:	53                   	push   %ebx
801028fd:	e8 ae fa ff ff       	call   801023b0 <readi>
80102902:	83 c4 10             	add    $0x10,%esp
80102905:	83 f8 10             	cmp    $0x10,%eax
80102908:	75 4e                	jne    80102958 <dirlink+0x98>
    if(de.inum == 0)
8010290a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010290f:	75 df                	jne    801028f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102911:	83 ec 04             	sub    $0x4,%esp
80102914:	8d 45 da             	lea    -0x26(%ebp),%eax
80102917:	6a 0e                	push   $0xe
80102919:	ff 75 0c             	push   0xc(%ebp)
8010291c:	50                   	push   %eax
8010291d:	e8 ce 27 00 00       	call   801050f0 <strncpy>
  de.inum = inum;
80102922:	8b 45 10             	mov    0x10(%ebp),%eax
80102925:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102929:	6a 10                	push   $0x10
8010292b:	57                   	push   %edi
8010292c:	56                   	push   %esi
8010292d:	53                   	push   %ebx
8010292e:	e8 7d fb ff ff       	call   801024b0 <writei>
80102933:	83 c4 20             	add    $0x20,%esp
80102936:	83 f8 10             	cmp    $0x10,%eax
80102939:	75 2a                	jne    80102965 <dirlink+0xa5>
  return 0;
8010293b:	31 c0                	xor    %eax,%eax
}
8010293d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102940:	5b                   	pop    %ebx
80102941:	5e                   	pop    %esi
80102942:	5f                   	pop    %edi
80102943:	5d                   	pop    %ebp
80102944:	c3                   	ret
    iput(ip);
80102945:	83 ec 0c             	sub    $0xc,%esp
80102948:	50                   	push   %eax
80102949:	e8 82 f8 ff ff       	call   801021d0 <iput>
    return -1;
8010294e:	83 c4 10             	add    $0x10,%esp
80102951:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102956:	eb e5                	jmp    8010293d <dirlink+0x7d>
      panic("dirlink read");
80102958:	83 ec 0c             	sub    $0xc,%esp
8010295b:	68 b7 7b 10 80       	push   $0x80107bb7
80102960:	e8 0b da ff ff       	call   80100370 <panic>
    panic("dirlink");
80102965:	83 ec 0c             	sub    $0xc,%esp
80102968:	68 13 7e 10 80       	push   $0x80107e13
8010296d:	e8 fe d9 ff ff       	call   80100370 <panic>
80102972:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102979:	00 
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102980 <namei>:

struct inode*
namei(char *path)
{
80102980:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102981:	31 d2                	xor    %edx,%edx
{
80102983:	89 e5                	mov    %esp,%ebp
80102985:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
8010298b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010298e:	e8 0d fd ff ff       	call   801026a0 <namex>
}
80102993:	c9                   	leave
80102994:	c3                   	ret
80102995:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010299c:	00 
8010299d:	8d 76 00             	lea    0x0(%esi),%esi

801029a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801029a0:	55                   	push   %ebp
  return namex(path, 1, name);
801029a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801029a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801029a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801029ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801029af:	e9 ec fc ff ff       	jmp    801026a0 <namex>
801029b4:	66 90                	xchg   %ax,%ax
801029b6:	66 90                	xchg   %ax,%ax
801029b8:	66 90                	xchg   %ax,%ax
801029ba:	66 90                	xchg   %ax,%ax
801029bc:	66 90                	xchg   %ax,%ax
801029be:	66 90                	xchg   %ax,%ax

801029c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	57                   	push   %edi
801029c4:	56                   	push   %esi
801029c5:	53                   	push   %ebx
801029c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801029c9:	85 c0                	test   %eax,%eax
801029cb:	0f 84 b4 00 00 00    	je     80102a85 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801029d1:	8b 70 08             	mov    0x8(%eax),%esi
801029d4:	89 c3                	mov    %eax,%ebx
801029d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801029dc:	0f 87 96 00 00 00    	ja     80102a78 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801029e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ee:	00 
801029ef:	90                   	nop
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801029f3:	83 e0 c0             	and    $0xffffffc0,%eax
801029f6:	3c 40                	cmp    $0x40,%al
801029f8:	75 f6                	jne    801029f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	31 ff                	xor    %edi,%edi
801029fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102a01:	89 f8                	mov    %edi,%eax
80102a03:	ee                   	out    %al,(%dx)
80102a04:	b8 01 00 00 00       	mov    $0x1,%eax
80102a09:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102a0e:	ee                   	out    %al,(%dx)
80102a0f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102a14:	89 f0                	mov    %esi,%eax
80102a16:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102a17:	89 f0                	mov    %esi,%eax
80102a19:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102a1e:	c1 f8 08             	sar    $0x8,%eax
80102a21:	ee                   	out    %al,(%dx)
80102a22:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102a27:	89 f8                	mov    %edi,%eax
80102a29:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102a2a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102a2e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a33:	c1 e0 04             	shl    $0x4,%eax
80102a36:	83 e0 10             	and    $0x10,%eax
80102a39:	83 c8 e0             	or     $0xffffffe0,%eax
80102a3c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102a3d:	f6 03 04             	testb  $0x4,(%ebx)
80102a40:	75 16                	jne    80102a58 <idestart+0x98>
80102a42:	b8 20 00 00 00       	mov    $0x20,%eax
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5f                   	pop    %edi
80102a50:	5d                   	pop    %ebp
80102a51:	c3                   	ret
80102a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a58:	b8 30 00 00 00       	mov    $0x30,%eax
80102a5d:	89 ca                	mov    %ecx,%edx
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102a60:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102a65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102a68:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102a6d:	fc                   	cld
80102a6e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a73:	5b                   	pop    %ebx
80102a74:	5e                   	pop    %esi
80102a75:	5f                   	pop    %edi
80102a76:	5d                   	pop    %ebp
80102a77:	c3                   	ret
    panic("incorrect blockno");
80102a78:	83 ec 0c             	sub    $0xc,%esp
80102a7b:	68 cd 7b 10 80       	push   $0x80107bcd
80102a80:	e8 eb d8 ff ff       	call   80100370 <panic>
    panic("idestart");
80102a85:	83 ec 0c             	sub    $0xc,%esp
80102a88:	68 c4 7b 10 80       	push   $0x80107bc4
80102a8d:	e8 de d8 ff ff       	call   80100370 <panic>
80102a92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a99:	00 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <ideinit>:
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102aa6:	68 df 7b 10 80       	push   $0x80107bdf
80102aab:	68 00 28 11 80       	push   $0x80112800
80102ab0:	e8 fb 21 00 00       	call   80104cb0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102ab5:	58                   	pop    %eax
80102ab6:	a1 84 29 11 80       	mov    0x80112984,%eax
80102abb:	5a                   	pop    %edx
80102abc:	83 e8 01             	sub    $0x1,%eax
80102abf:	50                   	push   %eax
80102ac0:	6a 0e                	push   $0xe
80102ac2:	e8 99 02 00 00       	call   80102d60 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102ac7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102acf:	90                   	nop
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	83 e0 c0             	and    $0xffffffc0,%eax
80102ad6:	3c 40                	cmp    $0x40,%al
80102ad8:	75 f6                	jne    80102ad0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ada:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102adf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 ca                	mov    %ecx,%edx
80102ae7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102ae8:	84 c0                	test   %al,%al
80102aea:	75 1e                	jne    80102b0a <ideinit+0x6a>
80102aec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102af1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102af6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102afd:	00 
80102afe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102b00:	83 e9 01             	sub    $0x1,%ecx
80102b03:	74 0f                	je     80102b14 <ideinit+0x74>
80102b05:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102b06:	84 c0                	test   %al,%al
80102b08:	74 f6                	je     80102b00 <ideinit+0x60>
      havedisk1 = 1;
80102b0a:	c7 05 e0 27 11 80 01 	movl   $0x1,0x801127e0
80102b11:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102b19:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b1e:	ee                   	out    %al,(%dx)
}
80102b1f:	c9                   	leave
80102b20:	c3                   	ret
80102b21:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b28:	00 
80102b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b30 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	57                   	push   %edi
80102b34:	56                   	push   %esi
80102b35:	53                   	push   %ebx
80102b36:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b39:	68 00 28 11 80       	push   $0x80112800
80102b3e:	e8 5d 23 00 00       	call   80104ea0 <acquire>

  if((b = idequeue) == 0){
80102b43:	8b 1d e4 27 11 80    	mov    0x801127e4,%ebx
80102b49:	83 c4 10             	add    $0x10,%esp
80102b4c:	85 db                	test   %ebx,%ebx
80102b4e:	74 63                	je     80102bb3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102b50:	8b 43 58             	mov    0x58(%ebx),%eax
80102b53:	a3 e4 27 11 80       	mov    %eax,0x801127e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b58:	8b 33                	mov    (%ebx),%esi
80102b5a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102b60:	75 2f                	jne    80102b91 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b62:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b6e:	00 
80102b6f:	90                   	nop
80102b70:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102b71:	89 c1                	mov    %eax,%ecx
80102b73:	83 e1 c0             	and    $0xffffffc0,%ecx
80102b76:	80 f9 40             	cmp    $0x40,%cl
80102b79:	75 f5                	jne    80102b70 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102b7b:	a8 21                	test   $0x21,%al
80102b7d:	75 12                	jne    80102b91 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102b7f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102b82:	b9 80 00 00 00       	mov    $0x80,%ecx
80102b87:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102b8c:	fc                   	cld
80102b8d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102b8f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102b91:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102b94:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102b97:	83 ce 02             	or     $0x2,%esi
80102b9a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102b9c:	53                   	push   %ebx
80102b9d:	e8 3e 1e 00 00       	call   801049e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ba2:	a1 e4 27 11 80       	mov    0x801127e4,%eax
80102ba7:	83 c4 10             	add    $0x10,%esp
80102baa:	85 c0                	test   %eax,%eax
80102bac:	74 05                	je     80102bb3 <ideintr+0x83>
    idestart(idequeue);
80102bae:	e8 0d fe ff ff       	call   801029c0 <idestart>
    release(&idelock);
80102bb3:	83 ec 0c             	sub    $0xc,%esp
80102bb6:	68 00 28 11 80       	push   $0x80112800
80102bbb:	e8 80 22 00 00       	call   80104e40 <release>

  release(&idelock);
}
80102bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc3:	5b                   	pop    %ebx
80102bc4:	5e                   	pop    %esi
80102bc5:	5f                   	pop    %edi
80102bc6:	5d                   	pop    %ebp
80102bc7:	c3                   	ret
80102bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bcf:	00 

80102bd0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	53                   	push   %ebx
80102bd4:	83 ec 10             	sub    $0x10,%esp
80102bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102bda:	8d 43 0c             	lea    0xc(%ebx),%eax
80102bdd:	50                   	push   %eax
80102bde:	e8 7d 20 00 00       	call   80104c60 <holdingsleep>
80102be3:	83 c4 10             	add    $0x10,%esp
80102be6:	85 c0                	test   %eax,%eax
80102be8:	0f 84 c3 00 00 00    	je     80102cb1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102bee:	8b 03                	mov    (%ebx),%eax
80102bf0:	83 e0 06             	and    $0x6,%eax
80102bf3:	83 f8 02             	cmp    $0x2,%eax
80102bf6:	0f 84 a8 00 00 00    	je     80102ca4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102bfc:	8b 53 04             	mov    0x4(%ebx),%edx
80102bff:	85 d2                	test   %edx,%edx
80102c01:	74 0d                	je     80102c10 <iderw+0x40>
80102c03:	a1 e0 27 11 80       	mov    0x801127e0,%eax
80102c08:	85 c0                	test   %eax,%eax
80102c0a:	0f 84 87 00 00 00    	je     80102c97 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102c10:	83 ec 0c             	sub    $0xc,%esp
80102c13:	68 00 28 11 80       	push   $0x80112800
80102c18:	e8 83 22 00 00       	call   80104ea0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c1d:	a1 e4 27 11 80       	mov    0x801127e4,%eax
  b->qnext = 0;
80102c22:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c29:	83 c4 10             	add    $0x10,%esp
80102c2c:	85 c0                	test   %eax,%eax
80102c2e:	74 60                	je     80102c90 <iderw+0xc0>
80102c30:	89 c2                	mov    %eax,%edx
80102c32:	8b 40 58             	mov    0x58(%eax),%eax
80102c35:	85 c0                	test   %eax,%eax
80102c37:	75 f7                	jne    80102c30 <iderw+0x60>
80102c39:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102c3c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102c3e:	39 1d e4 27 11 80    	cmp    %ebx,0x801127e4
80102c44:	74 3a                	je     80102c80 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c46:	8b 03                	mov    (%ebx),%eax
80102c48:	83 e0 06             	and    $0x6,%eax
80102c4b:	83 f8 02             	cmp    $0x2,%eax
80102c4e:	74 1b                	je     80102c6b <iderw+0x9b>
    sleep(b, &idelock);
80102c50:	83 ec 08             	sub    $0x8,%esp
80102c53:	68 00 28 11 80       	push   $0x80112800
80102c58:	53                   	push   %ebx
80102c59:	e8 c2 1c 00 00       	call   80104920 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c5e:	8b 03                	mov    (%ebx),%eax
80102c60:	83 c4 10             	add    $0x10,%esp
80102c63:	83 e0 06             	and    $0x6,%eax
80102c66:	83 f8 02             	cmp    $0x2,%eax
80102c69:	75 e5                	jne    80102c50 <iderw+0x80>
  }


  release(&idelock);
80102c6b:	c7 45 08 00 28 11 80 	movl   $0x80112800,0x8(%ebp)
}
80102c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c75:	c9                   	leave
  release(&idelock);
80102c76:	e9 c5 21 00 00       	jmp    80104e40 <release>
80102c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102c80:	89 d8                	mov    %ebx,%eax
80102c82:	e8 39 fd ff ff       	call   801029c0 <idestart>
80102c87:	eb bd                	jmp    80102c46 <iderw+0x76>
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c90:	ba e4 27 11 80       	mov    $0x801127e4,%edx
80102c95:	eb a5                	jmp    80102c3c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102c97:	83 ec 0c             	sub    $0xc,%esp
80102c9a:	68 0e 7c 10 80       	push   $0x80107c0e
80102c9f:	e8 cc d6 ff ff       	call   80100370 <panic>
    panic("iderw: nothing to do");
80102ca4:	83 ec 0c             	sub    $0xc,%esp
80102ca7:	68 f9 7b 10 80       	push   $0x80107bf9
80102cac:	e8 bf d6 ff ff       	call   80100370 <panic>
    panic("iderw: buf not locked");
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	68 e3 7b 10 80       	push   $0x80107be3
80102cb9:	e8 b2 d6 ff ff       	call   80100370 <panic>
80102cbe:	66 90                	xchg   %ax,%ax

80102cc0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	56                   	push   %esi
80102cc4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102cc5:	c7 05 34 28 11 80 00 	movl   $0xfec00000,0x80112834
80102ccc:	00 c0 fe 
  ioapic->reg = reg;
80102ccf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102cd6:	00 00 00 
  return ioapic->data;
80102cd9:	8b 15 34 28 11 80    	mov    0x80112834,%edx
80102cdf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102ce2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102ce8:	8b 1d 34 28 11 80    	mov    0x80112834,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102cee:	0f b6 15 80 29 11 80 	movzbl 0x80112980,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102cf5:	c1 ee 10             	shr    $0x10,%esi
80102cf8:	89 f0                	mov    %esi,%eax
80102cfa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102cfd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102d00:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102d03:	39 c2                	cmp    %eax,%edx
80102d05:	74 16                	je     80102d1d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 34 80 10 80       	push   $0x80108034
80102d0f:	e8 4c da ff ff       	call   80100760 <cprintf>
  ioapic->reg = reg;
80102d14:	8b 1d 34 28 11 80    	mov    0x80112834,%ebx
80102d1a:	83 c4 10             	add    $0x10,%esp
{
80102d1d:	ba 10 00 00 00       	mov    $0x10,%edx
80102d22:	31 c0                	xor    %eax,%eax
80102d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102d28:	89 13                	mov    %edx,(%ebx)
80102d2a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
80102d2d:	8b 1d 34 28 11 80    	mov    0x80112834,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d33:	83 c0 01             	add    $0x1,%eax
80102d36:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
80102d3c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
80102d3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102d42:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102d45:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102d47:	8b 1d 34 28 11 80    	mov    0x80112834,%ebx
80102d4d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102d54:	39 c6                	cmp    %eax,%esi
80102d56:	7d d0                	jge    80102d28 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d5b:	5b                   	pop    %ebx
80102d5c:	5e                   	pop    %esi
80102d5d:	5d                   	pop    %ebp
80102d5e:	c3                   	ret
80102d5f:	90                   	nop

80102d60 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102d60:	55                   	push   %ebp
  ioapic->reg = reg;
80102d61:	8b 0d 34 28 11 80    	mov    0x80112834,%ecx
{
80102d67:	89 e5                	mov    %esp,%ebp
80102d69:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102d6c:	8d 50 20             	lea    0x20(%eax),%edx
80102d6f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102d73:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d75:	8b 0d 34 28 11 80    	mov    0x80112834,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d7b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102d7e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102d84:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d86:	a1 34 28 11 80       	mov    0x80112834,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d8b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102d8e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d91:	5d                   	pop    %ebp
80102d92:	c3                   	ret
80102d93:	66 90                	xchg   %ax,%ax
80102d95:	66 90                	xchg   %ax,%ax
80102d97:	66 90                	xchg   %ax,%ax
80102d99:	66 90                	xchg   %ax,%ax
80102d9b:	66 90                	xchg   %ax,%ax
80102d9d:	66 90                	xchg   %ax,%ax
80102d9f:	90                   	nop

80102da0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 04             	sub    $0x4,%esp
80102da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102daa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102db0:	75 76                	jne    80102e28 <kfree+0x88>
80102db2:	81 fb d0 66 11 80    	cmp    $0x801166d0,%ebx
80102db8:	72 6e                	jb     80102e28 <kfree+0x88>
80102dba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102dc0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102dc5:	77 61                	ja     80102e28 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102dc7:	83 ec 04             	sub    $0x4,%esp
80102dca:	68 00 10 00 00       	push   $0x1000
80102dcf:	6a 01                	push   $0x1
80102dd1:	53                   	push   %ebx
80102dd2:	e8 c9 21 00 00       	call   80104fa0 <memset>

  if(kmem.use_lock)
80102dd7:	8b 15 74 28 11 80    	mov    0x80112874,%edx
80102ddd:	83 c4 10             	add    $0x10,%esp
80102de0:	85 d2                	test   %edx,%edx
80102de2:	75 1c                	jne    80102e00 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102de4:	a1 78 28 11 80       	mov    0x80112878,%eax
80102de9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102deb:	a1 74 28 11 80       	mov    0x80112874,%eax
  kmem.freelist = r;
80102df0:	89 1d 78 28 11 80    	mov    %ebx,0x80112878
  if(kmem.use_lock)
80102df6:	85 c0                	test   %eax,%eax
80102df8:	75 1e                	jne    80102e18 <kfree+0x78>
    release(&kmem.lock);
}
80102dfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfd:	c9                   	leave
80102dfe:	c3                   	ret
80102dff:	90                   	nop
    acquire(&kmem.lock);
80102e00:	83 ec 0c             	sub    $0xc,%esp
80102e03:	68 40 28 11 80       	push   $0x80112840
80102e08:	e8 93 20 00 00       	call   80104ea0 <acquire>
80102e0d:	83 c4 10             	add    $0x10,%esp
80102e10:	eb d2                	jmp    80102de4 <kfree+0x44>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102e18:	c7 45 08 40 28 11 80 	movl   $0x80112840,0x8(%ebp)
}
80102e1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e22:	c9                   	leave
    release(&kmem.lock);
80102e23:	e9 18 20 00 00       	jmp    80104e40 <release>
    panic("kfree");
80102e28:	83 ec 0c             	sub    $0xc,%esp
80102e2b:	68 2c 7c 10 80       	push   $0x80107c2c
80102e30:	e8 3b d5 ff ff       	call   80100370 <panic>
80102e35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e3c:	00 
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi

80102e40 <freerange>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	56                   	push   %esi
80102e44:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e45:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e48:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e4b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e51:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e57:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e5d:	39 de                	cmp    %ebx,%esi
80102e5f:	72 23                	jb     80102e84 <freerange+0x44>
80102e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e68:	83 ec 0c             	sub    $0xc,%esp
80102e6b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e77:	50                   	push   %eax
80102e78:	e8 23 ff ff ff       	call   80102da0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e7d:	83 c4 10             	add    $0x10,%esp
80102e80:	39 de                	cmp    %ebx,%esi
80102e82:	73 e4                	jae    80102e68 <freerange+0x28>
}
80102e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e87:	5b                   	pop    %ebx
80102e88:	5e                   	pop    %esi
80102e89:	5d                   	pop    %ebp
80102e8a:	c3                   	ret
80102e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102e90 <kinit2>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	56                   	push   %esi
80102e94:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e95:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e98:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e9b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ea1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ea7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ead:	39 de                	cmp    %ebx,%esi
80102eaf:	72 23                	jb     80102ed4 <kinit2+0x44>
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ec1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ec7:	50                   	push   %eax
80102ec8:	e8 d3 fe ff ff       	call   80102da0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ecd:	83 c4 10             	add    $0x10,%esp
80102ed0:	39 de                	cmp    %ebx,%esi
80102ed2:	73 e4                	jae    80102eb8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ed4:	c7 05 74 28 11 80 01 	movl   $0x1,0x80112874
80102edb:	00 00 00 
}
80102ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ee1:	5b                   	pop    %ebx
80102ee2:	5e                   	pop    %esi
80102ee3:	5d                   	pop    %ebp
80102ee4:	c3                   	ret
80102ee5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102eec:	00 
80102eed:	8d 76 00             	lea    0x0(%esi),%esi

80102ef0 <kinit1>:
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	56                   	push   %esi
80102ef4:	53                   	push   %ebx
80102ef5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 32 7c 10 80       	push   $0x80107c32
80102f00:	68 40 28 11 80       	push   $0x80112840
80102f05:	e8 a6 1d 00 00       	call   80104cb0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f0d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102f10:	c7 05 74 28 11 80 00 	movl   $0x0,0x80112874
80102f17:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102f1a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102f20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f26:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102f2c:	39 de                	cmp    %ebx,%esi
80102f2e:	72 1c                	jb     80102f4c <kinit1+0x5c>
    kfree(p);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102f3f:	50                   	push   %eax
80102f40:	e8 5b fe ff ff       	call   80102da0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f45:	83 c4 10             	add    $0x10,%esp
80102f48:	39 de                	cmp    %ebx,%esi
80102f4a:	73 e4                	jae    80102f30 <kinit1+0x40>
}
80102f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5d                   	pop    %ebp
80102f52:	c3                   	ret
80102f53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f5a:	00 
80102f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102f60 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102f67:	a1 74 28 11 80       	mov    0x80112874,%eax
80102f6c:	85 c0                	test   %eax,%eax
80102f6e:	75 20                	jne    80102f90 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102f70:	8b 1d 78 28 11 80    	mov    0x80112878,%ebx
  if(r)
80102f76:	85 db                	test   %ebx,%ebx
80102f78:	74 07                	je     80102f81 <kalloc+0x21>
    kmem.freelist = r->next;
80102f7a:	8b 03                	mov    (%ebx),%eax
80102f7c:	a3 78 28 11 80       	mov    %eax,0x80112878
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102f81:	89 d8                	mov    %ebx,%eax
80102f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f86:	c9                   	leave
80102f87:	c3                   	ret
80102f88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f8f:	00 
    acquire(&kmem.lock);
80102f90:	83 ec 0c             	sub    $0xc,%esp
80102f93:	68 40 28 11 80       	push   $0x80112840
80102f98:	e8 03 1f 00 00       	call   80104ea0 <acquire>
  r = kmem.freelist;
80102f9d:	8b 1d 78 28 11 80    	mov    0x80112878,%ebx
  if(kmem.use_lock)
80102fa3:	a1 74 28 11 80       	mov    0x80112874,%eax
  if(r)
80102fa8:	83 c4 10             	add    $0x10,%esp
80102fab:	85 db                	test   %ebx,%ebx
80102fad:	74 08                	je     80102fb7 <kalloc+0x57>
    kmem.freelist = r->next;
80102faf:	8b 13                	mov    (%ebx),%edx
80102fb1:	89 15 78 28 11 80    	mov    %edx,0x80112878
  if(kmem.use_lock)
80102fb7:	85 c0                	test   %eax,%eax
80102fb9:	74 c6                	je     80102f81 <kalloc+0x21>
    release(&kmem.lock);
80102fbb:	83 ec 0c             	sub    $0xc,%esp
80102fbe:	68 40 28 11 80       	push   $0x80112840
80102fc3:	e8 78 1e 00 00       	call   80104e40 <release>
}
80102fc8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80102fca:	83 c4 10             	add    $0x10,%esp
}
80102fcd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fd0:	c9                   	leave
80102fd1:	c3                   	ret
80102fd2:	66 90                	xchg   %ax,%ax
80102fd4:	66 90                	xchg   %ax,%ax
80102fd6:	66 90                	xchg   %ax,%ax
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe0:	ba 64 00 00 00       	mov    $0x64,%edx
80102fe5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102fe6:	a8 01                	test   $0x1,%al
80102fe8:	0f 84 c2 00 00 00    	je     801030b0 <kbdgetc+0xd0>
{
80102fee:	55                   	push   %ebp
80102fef:	ba 60 00 00 00       	mov    $0x60,%edx
80102ff4:	89 e5                	mov    %esp,%ebp
80102ff6:	53                   	push   %ebx
80102ff7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102ff8:	8b 1d 7c 28 11 80    	mov    0x8011287c,%ebx
  data = inb(KBDATAP);
80102ffe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103001:	3c e0                	cmp    $0xe0,%al
80103003:	74 5b                	je     80103060 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103005:	89 da                	mov    %ebx,%edx
80103007:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010300a:	84 c0                	test   %al,%al
8010300c:	78 62                	js     80103070 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010300e:	85 d2                	test   %edx,%edx
80103010:	74 09                	je     8010301b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103012:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103015:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103018:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010301b:	0f b6 91 a0 82 10 80 	movzbl -0x7fef7d60(%ecx),%edx
  shift ^= togglecode[data];
80103022:	0f b6 81 a0 81 10 80 	movzbl -0x7fef7e60(%ecx),%eax
  shift |= shiftcode[data];
80103029:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010302b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010302d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010302f:	89 15 7c 28 11 80    	mov    %edx,0x8011287c
  c = charcode[shift & (CTL | SHIFT)][data];
80103035:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103038:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010303b:	8b 04 85 80 81 10 80 	mov    -0x7fef7e80(,%eax,4),%eax
80103042:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103046:	74 0b                	je     80103053 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103048:	8d 50 9f             	lea    -0x61(%eax),%edx
8010304b:	83 fa 19             	cmp    $0x19,%edx
8010304e:	77 48                	ja     80103098 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103050:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103053:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103056:	c9                   	leave
80103057:	c3                   	ret
80103058:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010305f:	00 
    shift |= E0ESC;
80103060:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103063:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103065:	89 1d 7c 28 11 80    	mov    %ebx,0x8011287c
}
8010306b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010306e:	c9                   	leave
8010306f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80103070:	83 e0 7f             	and    $0x7f,%eax
80103073:	85 d2                	test   %edx,%edx
80103075:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103078:	0f b6 81 a0 82 10 80 	movzbl -0x7fef7d60(%ecx),%eax
8010307f:	83 c8 40             	or     $0x40,%eax
80103082:	0f b6 c0             	movzbl %al,%eax
80103085:	f7 d0                	not    %eax
80103087:	21 d8                	and    %ebx,%eax
80103089:	a3 7c 28 11 80       	mov    %eax,0x8011287c
    return 0;
8010308e:	31 c0                	xor    %eax,%eax
80103090:	eb d9                	jmp    8010306b <kbdgetc+0x8b>
80103092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103098:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010309b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010309e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030a1:	c9                   	leave
      c += 'a' - 'A';
801030a2:	83 f9 1a             	cmp    $0x1a,%ecx
801030a5:	0f 42 c2             	cmovb  %edx,%eax
}
801030a8:	c3                   	ret
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801030b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801030b5:	c3                   	ret
801030b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030bd:	00 
801030be:	66 90                	xchg   %ax,%ax

801030c0 <kbdintr>:

void
kbdintr(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801030c6:	68 e0 2f 10 80       	push   $0x80102fe0
801030cb:	e8 a0 d8 ff ff       	call   80100970 <consoleintr>
}
801030d0:	83 c4 10             	add    $0x10,%esp
801030d3:	c9                   	leave
801030d4:	c3                   	ret
801030d5:	66 90                	xchg   %ax,%ax
801030d7:	66 90                	xchg   %ax,%ax
801030d9:	66 90                	xchg   %ax,%ax
801030db:	66 90                	xchg   %ax,%ax
801030dd:	66 90                	xchg   %ax,%ax
801030df:	90                   	nop

801030e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801030e0:	a1 80 28 11 80       	mov    0x80112880,%eax
801030e5:	85 c0                	test   %eax,%eax
801030e7:	0f 84 c3 00 00 00    	je     801031b0 <lapicinit+0xd0>
  lapic[index] = value;
801030ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801030f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103101:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103104:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103107:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010310e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103111:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103114:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010311b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010311e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103121:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103128:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010312b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010312e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103135:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103138:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010313b:	8b 50 30             	mov    0x30(%eax),%edx
8010313e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80103144:	75 72                	jne    801031b8 <lapicinit+0xd8>
  lapic[index] = value;
80103146:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010314d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103150:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103153:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010315a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010315d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103160:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103167:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010316a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010316d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103174:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103177:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010317a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103181:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103184:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103187:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010318e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103191:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103198:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010319e:	80 e6 10             	and    $0x10,%dh
801031a1:	75 f5                	jne    80103198 <lapicinit+0xb8>
  lapic[index] = value;
801031a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801031aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801031b0:	c3                   	ret
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801031b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801031bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801031c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801031c5:	e9 7c ff ff ff       	jmp    80103146 <lapicinit+0x66>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801031d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801031d0:	a1 80 28 11 80       	mov    0x80112880,%eax
801031d5:	85 c0                	test   %eax,%eax
801031d7:	74 07                	je     801031e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801031d9:	8b 40 20             	mov    0x20(%eax),%eax
801031dc:	c1 e8 18             	shr    $0x18,%eax
801031df:	c3                   	ret
    return 0;
801031e0:	31 c0                	xor    %eax,%eax
}
801031e2:	c3                   	ret
801031e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ea:	00 
801031eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801031f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801031f0:	a1 80 28 11 80       	mov    0x80112880,%eax
801031f5:	85 c0                	test   %eax,%eax
801031f7:	74 0d                	je     80103206 <lapiceoi+0x16>
  lapic[index] = value;
801031f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103200:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103203:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103206:	c3                   	ret
80103207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010320e:	00 
8010320f:	90                   	nop

80103210 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103210:	c3                   	ret
80103211:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103218:	00 
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103220:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103221:	b8 0f 00 00 00       	mov    $0xf,%eax
80103226:	ba 70 00 00 00       	mov    $0x70,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	53                   	push   %ebx
8010322e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103231:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103234:	ee                   	out    %al,(%dx)
80103235:	b8 0a 00 00 00       	mov    $0xa,%eax
8010323a:	ba 71 00 00 00       	mov    $0x71,%edx
8010323f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103240:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80103242:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103245:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010324b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010324d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80103250:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103252:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103255:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103258:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010325e:	a1 80 28 11 80       	mov    0x80112880,%eax
80103263:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103269:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010326c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103273:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103276:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103279:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103280:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103283:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103286:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010328c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010328f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103295:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103298:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010329e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801032a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801032aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032ad:	c9                   	leave
801032ae:	c3                   	ret
801032af:	90                   	nop

801032b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801032b0:	55                   	push   %ebp
801032b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801032b6:	ba 70 00 00 00       	mov    $0x70,%edx
801032bb:	89 e5                	mov    %esp,%ebp
801032bd:	57                   	push   %edi
801032be:	56                   	push   %esi
801032bf:	53                   	push   %ebx
801032c0:	83 ec 4c             	sub    $0x4c,%esp
801032c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c4:	ba 71 00 00 00       	mov    $0x71,%edx
801032c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801032ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032cd:	bf 70 00 00 00       	mov    $0x70,%edi
801032d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801032d5:	8d 76 00             	lea    0x0(%esi),%esi
801032d8:	31 c0                	xor    %eax,%eax
801032da:	89 fa                	mov    %edi,%edx
801032dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801032e2:	89 ca                	mov    %ecx,%edx
801032e4:	ec                   	in     (%dx),%al
801032e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032e8:	89 fa                	mov    %edi,%edx
801032ea:	b8 02 00 00 00       	mov    $0x2,%eax
801032ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f0:	89 ca                	mov    %ecx,%edx
801032f2:	ec                   	in     (%dx),%al
801032f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f6:	89 fa                	mov    %edi,%edx
801032f8:	b8 04 00 00 00       	mov    $0x4,%eax
801032fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032fe:	89 ca                	mov    %ecx,%edx
80103300:	ec                   	in     (%dx),%al
80103301:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103304:	89 fa                	mov    %edi,%edx
80103306:	b8 07 00 00 00       	mov    $0x7,%eax
8010330b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010330c:	89 ca                	mov    %ecx,%edx
8010330e:	ec                   	in     (%dx),%al
8010330f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	89 fa                	mov    %edi,%edx
80103314:	b8 08 00 00 00       	mov    $0x8,%eax
80103319:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010331a:	89 ca                	mov    %ecx,%edx
8010331c:	ec                   	in     (%dx),%al
8010331d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331f:	89 fa                	mov    %edi,%edx
80103321:	b8 09 00 00 00       	mov    $0x9,%eax
80103326:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103327:	89 ca                	mov    %ecx,%edx
80103329:	ec                   	in     (%dx),%al
8010332a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332d:	89 fa                	mov    %edi,%edx
8010332f:	b8 0a 00 00 00       	mov    $0xa,%eax
80103334:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103335:	89 ca                	mov    %ecx,%edx
80103337:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103338:	84 c0                	test   %al,%al
8010333a:	78 9c                	js     801032d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010333c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103340:	89 f2                	mov    %esi,%edx
80103342:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103345:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103348:	89 fa                	mov    %edi,%edx
8010334a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010334d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103351:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103354:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103357:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010335b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010335e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103362:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103365:	31 c0                	xor    %eax,%eax
80103367:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103368:	89 ca                	mov    %ecx,%edx
8010336a:	ec                   	in     (%dx),%al
8010336b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	89 fa                	mov    %edi,%edx
80103370:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103373:	b8 02 00 00 00       	mov    $0x2,%eax
80103378:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103379:	89 ca                	mov    %ecx,%edx
8010337b:	ec                   	in     (%dx),%al
8010337c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337f:	89 fa                	mov    %edi,%edx
80103381:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103384:	b8 04 00 00 00       	mov    $0x4,%eax
80103389:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010338a:	89 ca                	mov    %ecx,%edx
8010338c:	ec                   	in     (%dx),%al
8010338d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103390:	89 fa                	mov    %edi,%edx
80103392:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103395:	b8 07 00 00 00       	mov    $0x7,%eax
8010339a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010339b:	89 ca                	mov    %ecx,%edx
8010339d:	ec                   	in     (%dx),%al
8010339e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a1:	89 fa                	mov    %edi,%edx
801033a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801033a6:	b8 08 00 00 00       	mov    $0x8,%eax
801033ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033ac:	89 ca                	mov    %ecx,%edx
801033ae:	ec                   	in     (%dx),%al
801033af:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033b2:	89 fa                	mov    %edi,%edx
801033b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801033b7:	b8 09 00 00 00       	mov    $0x9,%eax
801033bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033bd:	89 ca                	mov    %ecx,%edx
801033bf:	ec                   	in     (%dx),%al
801033c0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033c3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801033c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801033c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801033cc:	6a 18                	push   $0x18
801033ce:	50                   	push   %eax
801033cf:	8d 45 b8             	lea    -0x48(%ebp),%eax
801033d2:	50                   	push   %eax
801033d3:	e8 08 1c 00 00       	call   80104fe0 <memcmp>
801033d8:	83 c4 10             	add    $0x10,%esp
801033db:	85 c0                	test   %eax,%eax
801033dd:	0f 85 f5 fe ff ff    	jne    801032d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801033e3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801033e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ea:	89 f0                	mov    %esi,%eax
801033ec:	84 c0                	test   %al,%al
801033ee:	75 78                	jne    80103468 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801033f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033f3:	89 c2                	mov    %eax,%edx
801033f5:	83 e0 0f             	and    $0xf,%eax
801033f8:	c1 ea 04             	shr    $0x4,%edx
801033fb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033fe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103401:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103404:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103407:	89 c2                	mov    %eax,%edx
80103409:	83 e0 0f             	and    $0xf,%eax
8010340c:	c1 ea 04             	shr    $0x4,%edx
8010340f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103412:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103415:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103418:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010341b:	89 c2                	mov    %eax,%edx
8010341d:	83 e0 0f             	and    $0xf,%eax
80103420:	c1 ea 04             	shr    $0x4,%edx
80103423:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103426:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103429:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
8010342c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010342f:	89 c2                	mov    %eax,%edx
80103431:	83 e0 0f             	and    $0xf,%eax
80103434:	c1 ea 04             	shr    $0x4,%edx
80103437:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010343a:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010343d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103440:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103443:	89 c2                	mov    %eax,%edx
80103445:	83 e0 0f             	and    $0xf,%eax
80103448:	c1 ea 04             	shr    $0x4,%edx
8010344b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010344e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103451:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103454:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103457:	89 c2                	mov    %eax,%edx
80103459:	83 e0 0f             	and    $0xf,%eax
8010345c:	c1 ea 04             	shr    $0x4,%edx
8010345f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103462:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103465:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103468:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010346b:	89 03                	mov    %eax,(%ebx)
8010346d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103470:	89 43 04             	mov    %eax,0x4(%ebx)
80103473:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103476:	89 43 08             	mov    %eax,0x8(%ebx)
80103479:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010347c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010347f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103482:	89 43 10             	mov    %eax,0x10(%ebx)
80103485:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103488:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010348b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103495:	5b                   	pop    %ebx
80103496:	5e                   	pop    %esi
80103497:	5f                   	pop    %edi
80103498:	5d                   	pop    %ebp
80103499:	c3                   	ret
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034a0:	8b 0d e8 28 11 80    	mov    0x801128e8,%ecx
801034a6:	85 c9                	test   %ecx,%ecx
801034a8:	0f 8e 8a 00 00 00    	jle    80103538 <install_trans+0x98>
{
801034ae:	55                   	push   %ebp
801034af:	89 e5                	mov    %esp,%ebp
801034b1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801034b2:	31 ff                	xor    %edi,%edi
{
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034c0:	a1 d4 28 11 80       	mov    0x801128d4,%eax
801034c5:	83 ec 08             	sub    $0x8,%esp
801034c8:	01 f8                	add    %edi,%eax
801034ca:	83 c0 01             	add    $0x1,%eax
801034cd:	50                   	push   %eax
801034ce:	ff 35 e4 28 11 80    	push   0x801128e4
801034d4:	e8 f7 cb ff ff       	call   801000d0 <bread>
801034d9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034db:	58                   	pop    %eax
801034dc:	5a                   	pop    %edx
801034dd:	ff 34 bd ec 28 11 80 	push   -0x7feed714(,%edi,4)
801034e4:	ff 35 e4 28 11 80    	push   0x801128e4
  for (tail = 0; tail < log.lh.n; tail++) {
801034ea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034ed:	e8 de cb ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034f5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034f7:	8d 46 5c             	lea    0x5c(%esi),%eax
801034fa:	68 00 02 00 00       	push   $0x200
801034ff:	50                   	push   %eax
80103500:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103503:	50                   	push   %eax
80103504:	e8 27 1b 00 00       	call   80105030 <memmove>
    bwrite(dbuf);  // write dst to disk
80103509:	89 1c 24             	mov    %ebx,(%esp)
8010350c:	e8 9f cc ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103511:	89 34 24             	mov    %esi,(%esp)
80103514:	e8 d7 cc ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103519:	89 1c 24             	mov    %ebx,(%esp)
8010351c:	e8 cf cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103521:	83 c4 10             	add    $0x10,%esp
80103524:	39 3d e8 28 11 80    	cmp    %edi,0x801128e8
8010352a:	7f 94                	jg     801034c0 <install_trans+0x20>
  }
}
8010352c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010352f:	5b                   	pop    %ebx
80103530:	5e                   	pop    %esi
80103531:	5f                   	pop    %edi
80103532:	5d                   	pop    %ebp
80103533:	c3                   	ret
80103534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103538:	c3                   	ret
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	53                   	push   %ebx
80103544:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103547:	ff 35 d4 28 11 80    	push   0x801128d4
8010354d:	ff 35 e4 28 11 80    	push   0x801128e4
80103553:	e8 78 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103558:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010355b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010355d:	a1 e8 28 11 80       	mov    0x801128e8,%eax
80103562:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103565:	85 c0                	test   %eax,%eax
80103567:	7e 19                	jle    80103582 <write_head+0x42>
80103569:	31 d2                	xor    %edx,%edx
8010356b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103570:	8b 0c 95 ec 28 11 80 	mov    -0x7feed714(,%edx,4),%ecx
80103577:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010357b:	83 c2 01             	add    $0x1,%edx
8010357e:	39 d0                	cmp    %edx,%eax
80103580:	75 ee                	jne    80103570 <write_head+0x30>
  }
  bwrite(buf);
80103582:	83 ec 0c             	sub    $0xc,%esp
80103585:	53                   	push   %ebx
80103586:	e8 25 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010358b:	89 1c 24             	mov    %ebx,(%esp)
8010358e:	e8 5d cc ff ff       	call   801001f0 <brelse>
}
80103593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103596:	83 c4 10             	add    $0x10,%esp
80103599:	c9                   	leave
8010359a:	c3                   	ret
8010359b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801035a0 <initlog>:
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
801035a4:	83 ec 2c             	sub    $0x2c,%esp
801035a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801035aa:	68 37 7c 10 80       	push   $0x80107c37
801035af:	68 a0 28 11 80       	push   $0x801128a0
801035b4:	e8 f7 16 00 00       	call   80104cb0 <initlock>
  readsb(dev, &sb);
801035b9:	58                   	pop    %eax
801035ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
801035bd:	5a                   	pop    %edx
801035be:	50                   	push   %eax
801035bf:	53                   	push   %ebx
801035c0:	e8 7b e8 ff ff       	call   80101e40 <readsb>
  log.start = sb.logstart;
801035c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801035c8:	59                   	pop    %ecx
  log.dev = dev;
801035c9:	89 1d e4 28 11 80    	mov    %ebx,0x801128e4
  log.size = sb.nlog;
801035cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801035d2:	a3 d4 28 11 80       	mov    %eax,0x801128d4
  log.size = sb.nlog;
801035d7:	89 15 d8 28 11 80    	mov    %edx,0x801128d8
  struct buf *buf = bread(log.dev, log.start);
801035dd:	5a                   	pop    %edx
801035de:	50                   	push   %eax
801035df:	53                   	push   %ebx
801035e0:	e8 eb ca ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801035e5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801035e8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801035eb:	89 1d e8 28 11 80    	mov    %ebx,0x801128e8
  for (i = 0; i < log.lh.n; i++) {
801035f1:	85 db                	test   %ebx,%ebx
801035f3:	7e 1d                	jle    80103612 <initlog+0x72>
801035f5:	31 d2                	xor    %edx,%edx
801035f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801035fe:	00 
801035ff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103600:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103604:	89 0c 95 ec 28 11 80 	mov    %ecx,-0x7feed714(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010360b:	83 c2 01             	add    $0x1,%edx
8010360e:	39 d3                	cmp    %edx,%ebx
80103610:	75 ee                	jne    80103600 <initlog+0x60>
  brelse(buf);
80103612:	83 ec 0c             	sub    $0xc,%esp
80103615:	50                   	push   %eax
80103616:	e8 d5 cb ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010361b:	e8 80 fe ff ff       	call   801034a0 <install_trans>
  log.lh.n = 0;
80103620:	c7 05 e8 28 11 80 00 	movl   $0x0,0x801128e8
80103627:	00 00 00 
  write_head(); // clear the log
8010362a:	e8 11 ff ff ff       	call   80103540 <write_head>
}
8010362f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	c9                   	leave
80103636:	c3                   	ret
80103637:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010363e:	00 
8010363f:	90                   	nop

80103640 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103646:	68 a0 28 11 80       	push   $0x801128a0
8010364b:	e8 50 18 00 00       	call   80104ea0 <acquire>
80103650:	83 c4 10             	add    $0x10,%esp
80103653:	eb 18                	jmp    8010366d <begin_op+0x2d>
80103655:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103658:	83 ec 08             	sub    $0x8,%esp
8010365b:	68 a0 28 11 80       	push   $0x801128a0
80103660:	68 a0 28 11 80       	push   $0x801128a0
80103665:	e8 b6 12 00 00       	call   80104920 <sleep>
8010366a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010366d:	a1 e0 28 11 80       	mov    0x801128e0,%eax
80103672:	85 c0                	test   %eax,%eax
80103674:	75 e2                	jne    80103658 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103676:	a1 dc 28 11 80       	mov    0x801128dc,%eax
8010367b:	8b 15 e8 28 11 80    	mov    0x801128e8,%edx
80103681:	83 c0 01             	add    $0x1,%eax
80103684:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103687:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010368a:	83 fa 1e             	cmp    $0x1e,%edx
8010368d:	7f c9                	jg     80103658 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010368f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103692:	a3 dc 28 11 80       	mov    %eax,0x801128dc
      release(&log.lock);
80103697:	68 a0 28 11 80       	push   $0x801128a0
8010369c:	e8 9f 17 00 00       	call   80104e40 <release>
      break;
    }
  }
}
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	c9                   	leave
801036a5:	c3                   	ret
801036a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036ad:	00 
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	57                   	push   %edi
801036b4:	56                   	push   %esi
801036b5:	53                   	push   %ebx
801036b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801036b9:	68 a0 28 11 80       	push   $0x801128a0
801036be:	e8 dd 17 00 00       	call   80104ea0 <acquire>
  log.outstanding -= 1;
801036c3:	a1 dc 28 11 80       	mov    0x801128dc,%eax
  if(log.committing)
801036c8:	8b 35 e0 28 11 80    	mov    0x801128e0,%esi
801036ce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801036d4:	89 1d dc 28 11 80    	mov    %ebx,0x801128dc
  if(log.committing)
801036da:	85 f6                	test   %esi,%esi
801036dc:	0f 85 22 01 00 00    	jne    80103804 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801036e2:	85 db                	test   %ebx,%ebx
801036e4:	0f 85 f6 00 00 00    	jne    801037e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801036ea:	c7 05 e0 28 11 80 01 	movl   $0x1,0x801128e0
801036f1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	68 a0 28 11 80       	push   $0x801128a0
801036fc:	e8 3f 17 00 00       	call   80104e40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103701:	8b 0d e8 28 11 80    	mov    0x801128e8,%ecx
80103707:	83 c4 10             	add    $0x10,%esp
8010370a:	85 c9                	test   %ecx,%ecx
8010370c:	7f 42                	jg     80103750 <end_op+0xa0>
    acquire(&log.lock);
8010370e:	83 ec 0c             	sub    $0xc,%esp
80103711:	68 a0 28 11 80       	push   $0x801128a0
80103716:	e8 85 17 00 00       	call   80104ea0 <acquire>
    log.committing = 0;
8010371b:	c7 05 e0 28 11 80 00 	movl   $0x0,0x801128e0
80103722:	00 00 00 
    wakeup(&log);
80103725:	c7 04 24 a0 28 11 80 	movl   $0x801128a0,(%esp)
8010372c:	e8 af 12 00 00       	call   801049e0 <wakeup>
    release(&log.lock);
80103731:	c7 04 24 a0 28 11 80 	movl   $0x801128a0,(%esp)
80103738:	e8 03 17 00 00       	call   80104e40 <release>
8010373d:	83 c4 10             	add    $0x10,%esp
}
80103740:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103743:	5b                   	pop    %ebx
80103744:	5e                   	pop    %esi
80103745:	5f                   	pop    %edi
80103746:	5d                   	pop    %ebp
80103747:	c3                   	ret
80103748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010374f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103750:	a1 d4 28 11 80       	mov    0x801128d4,%eax
80103755:	83 ec 08             	sub    $0x8,%esp
80103758:	01 d8                	add    %ebx,%eax
8010375a:	83 c0 01             	add    $0x1,%eax
8010375d:	50                   	push   %eax
8010375e:	ff 35 e4 28 11 80    	push   0x801128e4
80103764:	e8 67 c9 ff ff       	call   801000d0 <bread>
80103769:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010376b:	58                   	pop    %eax
8010376c:	5a                   	pop    %edx
8010376d:	ff 34 9d ec 28 11 80 	push   -0x7feed714(,%ebx,4)
80103774:	ff 35 e4 28 11 80    	push   0x801128e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010377a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010377d:	e8 4e c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103782:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103785:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103787:	8d 40 5c             	lea    0x5c(%eax),%eax
8010378a:	68 00 02 00 00       	push   $0x200
8010378f:	50                   	push   %eax
80103790:	8d 46 5c             	lea    0x5c(%esi),%eax
80103793:	50                   	push   %eax
80103794:	e8 97 18 00 00       	call   80105030 <memmove>
    bwrite(to);  // write the log
80103799:	89 34 24             	mov    %esi,(%esp)
8010379c:	e8 0f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
801037a1:	89 3c 24             	mov    %edi,(%esp)
801037a4:	e8 47 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
801037a9:	89 34 24             	mov    %esi,(%esp)
801037ac:	e8 3f ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801037b1:	83 c4 10             	add    $0x10,%esp
801037b4:	3b 1d e8 28 11 80    	cmp    0x801128e8,%ebx
801037ba:	7c 94                	jl     80103750 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801037bc:	e8 7f fd ff ff       	call   80103540 <write_head>
    install_trans(); // Now install writes to home locations
801037c1:	e8 da fc ff ff       	call   801034a0 <install_trans>
    log.lh.n = 0;
801037c6:	c7 05 e8 28 11 80 00 	movl   $0x0,0x801128e8
801037cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801037d0:	e8 6b fd ff ff       	call   80103540 <write_head>
801037d5:	e9 34 ff ff ff       	jmp    8010370e <end_op+0x5e>
801037da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	68 a0 28 11 80       	push   $0x801128a0
801037e8:	e8 f3 11 00 00       	call   801049e0 <wakeup>
  release(&log.lock);
801037ed:	c7 04 24 a0 28 11 80 	movl   $0x801128a0,(%esp)
801037f4:	e8 47 16 00 00       	call   80104e40 <release>
801037f9:	83 c4 10             	add    $0x10,%esp
}
801037fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ff:	5b                   	pop    %ebx
80103800:	5e                   	pop    %esi
80103801:	5f                   	pop    %edi
80103802:	5d                   	pop    %ebp
80103803:	c3                   	ret
    panic("log.committing");
80103804:	83 ec 0c             	sub    $0xc,%esp
80103807:	68 3b 7c 10 80       	push   $0x80107c3b
8010380c:	e8 5f cb ff ff       	call   80100370 <panic>
80103811:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103818:	00 
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103820 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103827:	8b 15 e8 28 11 80    	mov    0x801128e8,%edx
{
8010382d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103830:	83 fa 1d             	cmp    $0x1d,%edx
80103833:	7f 7d                	jg     801038b2 <log_write+0x92>
80103835:	a1 d8 28 11 80       	mov    0x801128d8,%eax
8010383a:	83 e8 01             	sub    $0x1,%eax
8010383d:	39 c2                	cmp    %eax,%edx
8010383f:	7d 71                	jge    801038b2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103841:	a1 dc 28 11 80       	mov    0x801128dc,%eax
80103846:	85 c0                	test   %eax,%eax
80103848:	7e 75                	jle    801038bf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010384a:	83 ec 0c             	sub    $0xc,%esp
8010384d:	68 a0 28 11 80       	push   $0x801128a0
80103852:	e8 49 16 00 00       	call   80104ea0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103857:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010385a:	83 c4 10             	add    $0x10,%esp
8010385d:	31 c0                	xor    %eax,%eax
8010385f:	8b 15 e8 28 11 80    	mov    0x801128e8,%edx
80103865:	85 d2                	test   %edx,%edx
80103867:	7f 0e                	jg     80103877 <log_write+0x57>
80103869:	eb 15                	jmp    80103880 <log_write+0x60>
8010386b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103870:	83 c0 01             	add    $0x1,%eax
80103873:	39 c2                	cmp    %eax,%edx
80103875:	74 29                	je     801038a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103877:	39 0c 85 ec 28 11 80 	cmp    %ecx,-0x7feed714(,%eax,4)
8010387e:	75 f0                	jne    80103870 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103880:	89 0c 85 ec 28 11 80 	mov    %ecx,-0x7feed714(,%eax,4)
  if (i == log.lh.n)
80103887:	39 c2                	cmp    %eax,%edx
80103889:	74 1c                	je     801038a7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010388b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010388e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103891:	c7 45 08 a0 28 11 80 	movl   $0x801128a0,0x8(%ebp)
}
80103898:	c9                   	leave
  release(&log.lock);
80103899:	e9 a2 15 00 00       	jmp    80104e40 <release>
8010389e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801038a0:	89 0c 95 ec 28 11 80 	mov    %ecx,-0x7feed714(,%edx,4)
    log.lh.n++;
801038a7:	83 c2 01             	add    $0x1,%edx
801038aa:	89 15 e8 28 11 80    	mov    %edx,0x801128e8
801038b0:	eb d9                	jmp    8010388b <log_write+0x6b>
    panic("too big a transaction");
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	68 4a 7c 10 80       	push   $0x80107c4a
801038ba:	e8 b1 ca ff ff       	call   80100370 <panic>
    panic("log_write outside of trans");
801038bf:	83 ec 0c             	sub    $0xc,%esp
801038c2:	68 60 7c 10 80       	push   $0x80107c60
801038c7:	e8 a4 ca ff ff       	call   80100370 <panic>
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038d7:	e8 64 09 00 00       	call   80104240 <cpuid>
801038dc:	89 c3                	mov    %eax,%ebx
801038de:	e8 5d 09 00 00       	call   80104240 <cpuid>
801038e3:	83 ec 04             	sub    $0x4,%esp
801038e6:	53                   	push   %ebx
801038e7:	50                   	push   %eax
801038e8:	68 7b 7c 10 80       	push   $0x80107c7b
801038ed:	e8 6e ce ff ff       	call   80100760 <cprintf>
  idtinit();       // load idt register
801038f2:	e8 e9 28 00 00       	call   801061e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038f7:	e8 e4 08 00 00       	call   801041e0 <mycpu>
801038fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103903:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010390a:	e8 01 0c 00 00       	call   80104510 <scheduler>
8010390f:	90                   	nop

80103910 <mpenter>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103916:	e8 c5 39 00 00       	call   801072e0 <switchkvm>
  seginit();
8010391b:	e8 30 39 00 00       	call   80107250 <seginit>
  lapicinit();
80103920:	e8 bb f7 ff ff       	call   801030e0 <lapicinit>
  mpmain();
80103925:	e8 a6 ff ff ff       	call   801038d0 <mpmain>
8010392a:	66 90                	xchg   %ax,%ax
8010392c:	66 90                	xchg   %ax,%ax
8010392e:	66 90                	xchg   %ax,%ax

80103930 <main>:
{
80103930:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103934:	83 e4 f0             	and    $0xfffffff0,%esp
80103937:	ff 71 fc             	push   -0x4(%ecx)
8010393a:	55                   	push   %ebp
8010393b:	89 e5                	mov    %esp,%ebp
8010393d:	53                   	push   %ebx
8010393e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010393f:	83 ec 08             	sub    $0x8,%esp
80103942:	68 00 00 40 80       	push   $0x80400000
80103947:	68 d0 66 11 80       	push   $0x801166d0
8010394c:	e8 9f f5 ff ff       	call   80102ef0 <kinit1>
  kvmalloc();      // kernel page table
80103951:	e8 4a 3e 00 00       	call   801077a0 <kvmalloc>
  mpinit();        // detect other processors
80103956:	e8 85 01 00 00       	call   80103ae0 <mpinit>
  lapicinit();     // interrupt controller
8010395b:	e8 80 f7 ff ff       	call   801030e0 <lapicinit>
  seginit();       // segment descriptors
80103960:	e8 eb 38 00 00       	call   80107250 <seginit>
  picinit();       // disable pic
80103965:	e8 86 03 00 00       	call   80103cf0 <picinit>
  ioapicinit();    // another interrupt controller
8010396a:	e8 51 f3 ff ff       	call   80102cc0 <ioapicinit>
  consoleinit();   // console hardware
8010396f:	e8 ec d9 ff ff       	call   80101360 <consoleinit>
  uartinit();      // serial port
80103974:	e8 47 2b 00 00       	call   801064c0 <uartinit>
  pinit();         // process table
80103979:	e8 42 08 00 00       	call   801041c0 <pinit>
  tvinit();        // trap vectors
8010397e:	e8 dd 27 00 00       	call   80106160 <tvinit>
  binit();         // buffer cache
80103983:	e8 b8 c6 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103988:	e8 a3 dd ff ff       	call   80101730 <fileinit>
  ideinit();       // disk 
8010398d:	e8 0e f1 ff ff       	call   80102aa0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103992:	83 c4 0c             	add    $0xc,%esp
80103995:	68 8a 00 00 00       	push   $0x8a
8010399a:	68 8c b4 10 80       	push   $0x8010b48c
8010399f:	68 00 70 00 80       	push   $0x80007000
801039a4:	e8 87 16 00 00       	call   80105030 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801039a9:	83 c4 10             	add    $0x10,%esp
801039ac:	69 05 84 29 11 80 b0 	imul   $0xb0,0x80112984,%eax
801039b3:	00 00 00 
801039b6:	05 a0 29 11 80       	add    $0x801129a0,%eax
801039bb:	3d a0 29 11 80       	cmp    $0x801129a0,%eax
801039c0:	76 7e                	jbe    80103a40 <main+0x110>
801039c2:	bb a0 29 11 80       	mov    $0x801129a0,%ebx
801039c7:	eb 20                	jmp    801039e9 <main+0xb9>
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039d0:	69 05 84 29 11 80 b0 	imul   $0xb0,0x80112984,%eax
801039d7:	00 00 00 
801039da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039e0:	05 a0 29 11 80       	add    $0x801129a0,%eax
801039e5:	39 c3                	cmp    %eax,%ebx
801039e7:	73 57                	jae    80103a40 <main+0x110>
    if(c == mycpu())  // We've started already.
801039e9:	e8 f2 07 00 00       	call   801041e0 <mycpu>
801039ee:	39 c3                	cmp    %eax,%ebx
801039f0:	74 de                	je     801039d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039f2:	e8 69 f5 ff ff       	call   80102f60 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801039f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801039fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103910,0x80006ff8
80103a01:	39 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103a04:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103a0b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a0e:	05 00 10 00 00       	add    $0x1000,%eax
80103a13:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103a18:	0f b6 03             	movzbl (%ebx),%eax
80103a1b:	68 00 70 00 00       	push   $0x7000
80103a20:	50                   	push   %eax
80103a21:	e8 fa f7 ff ff       	call   80103220 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a26:	83 c4 10             	add    $0x10,%esp
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a30:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103a36:	85 c0                	test   %eax,%eax
80103a38:	74 f6                	je     80103a30 <main+0x100>
80103a3a:	eb 94                	jmp    801039d0 <main+0xa0>
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a40:	83 ec 08             	sub    $0x8,%esp
80103a43:	68 00 00 00 8e       	push   $0x8e000000
80103a48:	68 00 00 40 80       	push   $0x80400000
80103a4d:	e8 3e f4 ff ff       	call   80102e90 <kinit2>
  userinit();      // first user process
80103a52:	e8 39 08 00 00       	call   80104290 <userinit>
  mpmain();        // finish this processor's setup
80103a57:	e8 74 fe ff ff       	call   801038d0 <mpmain>
80103a5c:	66 90                	xchg   %ax,%ax
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a65:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a6b:	53                   	push   %ebx
  e = addr+len;
80103a6c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a6f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a72:	39 de                	cmp    %ebx,%esi
80103a74:	72 10                	jb     80103a86 <mpsearch1+0x26>
80103a76:	eb 50                	jmp    80103ac8 <mpsearch1+0x68>
80103a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a7f:	00 
80103a80:	89 fe                	mov    %edi,%esi
80103a82:	39 df                	cmp    %ebx,%edi
80103a84:	73 42                	jae    80103ac8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a86:	83 ec 04             	sub    $0x4,%esp
80103a89:	8d 7e 10             	lea    0x10(%esi),%edi
80103a8c:	6a 04                	push   $0x4
80103a8e:	68 8f 7c 10 80       	push   $0x80107c8f
80103a93:	56                   	push   %esi
80103a94:	e8 47 15 00 00       	call   80104fe0 <memcmp>
80103a99:	83 c4 10             	add    $0x10,%esp
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	75 e0                	jne    80103a80 <mpsearch1+0x20>
80103aa0:	89 f2                	mov    %esi,%edx
80103aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103aa8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103aab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103aae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103ab0:	39 fa                	cmp    %edi,%edx
80103ab2:	75 f4                	jne    80103aa8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ab4:	84 c0                	test   %al,%al
80103ab6:	75 c8                	jne    80103a80 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103abb:	89 f0                	mov    %esi,%eax
80103abd:	5b                   	pop    %ebx
80103abe:	5e                   	pop    %esi
80103abf:	5f                   	pop    %edi
80103ac0:	5d                   	pop    %ebp
80103ac1:	c3                   	ret
80103ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103acb:	31 f6                	xor    %esi,%esi
}
80103acd:	5b                   	pop    %ebx
80103ace:	89 f0                	mov    %esi,%eax
80103ad0:	5e                   	pop    %esi
80103ad1:	5f                   	pop    %edi
80103ad2:	5d                   	pop    %ebp
80103ad3:	c3                   	ret
80103ad4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103adb:	00 
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ae9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103af0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103af7:	c1 e0 08             	shl    $0x8,%eax
80103afa:	09 d0                	or     %edx,%eax
80103afc:	c1 e0 04             	shl    $0x4,%eax
80103aff:	75 1b                	jne    80103b1c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b01:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103b08:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103b0f:	c1 e0 08             	shl    $0x8,%eax
80103b12:	09 d0                	or     %edx,%eax
80103b14:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103b17:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103b1c:	ba 00 04 00 00       	mov    $0x400,%edx
80103b21:	e8 3a ff ff ff       	call   80103a60 <mpsearch1>
80103b26:	89 c3                	mov    %eax,%ebx
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	0f 84 58 01 00 00    	je     80103c88 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b30:	8b 73 04             	mov    0x4(%ebx),%esi
80103b33:	85 f6                	test   %esi,%esi
80103b35:	0f 84 3d 01 00 00    	je     80103c78 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
80103b3b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b3e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b47:	6a 04                	push   $0x4
80103b49:	68 94 7c 10 80       	push   $0x80107c94
80103b4e:	50                   	push   %eax
80103b4f:	e8 8c 14 00 00       	call   80104fe0 <memcmp>
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	85 c0                	test   %eax,%eax
80103b59:	0f 85 19 01 00 00    	jne    80103c78 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
80103b5f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103b66:	3c 01                	cmp    $0x1,%al
80103b68:	74 08                	je     80103b72 <mpinit+0x92>
80103b6a:	3c 04                	cmp    $0x4,%al
80103b6c:	0f 85 06 01 00 00    	jne    80103c78 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103b72:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103b79:	66 85 d2             	test   %dx,%dx
80103b7c:	74 22                	je     80103ba0 <mpinit+0xc0>
80103b7e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103b81:	89 f0                	mov    %esi,%eax
  sum = 0;
80103b83:	31 d2                	xor    %edx,%edx
80103b85:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103b88:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103b8f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103b92:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b94:	39 f8                	cmp    %edi,%eax
80103b96:	75 f0                	jne    80103b88 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103b98:	84 d2                	test   %dl,%dl
80103b9a:	0f 85 d8 00 00 00    	jne    80103c78 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103ba0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ba6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ba9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103bac:	a3 80 28 11 80       	mov    %eax,0x80112880
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bb1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103bb8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103bbe:	01 d7                	add    %edx,%edi
80103bc0:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103bc2:	bf 01 00 00 00       	mov    $0x1,%edi
80103bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bce:	00 
80103bcf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bd0:	39 d0                	cmp    %edx,%eax
80103bd2:	73 19                	jae    80103bed <mpinit+0x10d>
    switch(*p){
80103bd4:	0f b6 08             	movzbl (%eax),%ecx
80103bd7:	80 f9 02             	cmp    $0x2,%cl
80103bda:	0f 84 80 00 00 00    	je     80103c60 <mpinit+0x180>
80103be0:	77 6e                	ja     80103c50 <mpinit+0x170>
80103be2:	84 c9                	test   %cl,%cl
80103be4:	74 3a                	je     80103c20 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103be6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103be9:	39 d0                	cmp    %edx,%eax
80103beb:	72 e7                	jb     80103bd4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103bed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bf0:	85 ff                	test   %edi,%edi
80103bf2:	0f 84 dd 00 00 00    	je     80103cd5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103bf8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103bfc:	74 15                	je     80103c13 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bfe:	b8 70 00 00 00       	mov    $0x70,%eax
80103c03:	ba 22 00 00 00       	mov    $0x22,%edx
80103c08:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c09:	ba 23 00 00 00       	mov    $0x23,%edx
80103c0e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c0f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c12:	ee                   	out    %al,(%dx)
  }
}
80103c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c16:	5b                   	pop    %ebx
80103c17:	5e                   	pop    %esi
80103c18:	5f                   	pop    %edi
80103c19:	5d                   	pop    %ebp
80103c1a:	c3                   	ret
80103c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103c20:	8b 0d 84 29 11 80    	mov    0x80112984,%ecx
80103c26:	83 f9 07             	cmp    $0x7,%ecx
80103c29:	7f 19                	jg     80103c44 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c2b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103c31:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103c35:	83 c1 01             	add    $0x1,%ecx
80103c38:	89 0d 84 29 11 80    	mov    %ecx,0x80112984
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c3e:	88 9e a0 29 11 80    	mov    %bl,-0x7feed660(%esi)
      p += sizeof(struct mpproc);
80103c44:	83 c0 14             	add    $0x14,%eax
      continue;
80103c47:	eb 87                	jmp    80103bd0 <mpinit+0xf0>
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103c50:	83 e9 03             	sub    $0x3,%ecx
80103c53:	80 f9 01             	cmp    $0x1,%cl
80103c56:	76 8e                	jbe    80103be6 <mpinit+0x106>
80103c58:	31 ff                	xor    %edi,%edi
80103c5a:	e9 71 ff ff ff       	jmp    80103bd0 <mpinit+0xf0>
80103c5f:	90                   	nop
      ioapicid = ioapic->apicno;
80103c60:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103c64:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103c67:	88 0d 80 29 11 80    	mov    %cl,0x80112980
      continue;
80103c6d:	e9 5e ff ff ff       	jmp    80103bd0 <mpinit+0xf0>
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103c78:	83 ec 0c             	sub    $0xc,%esp
80103c7b:	68 99 7c 10 80       	push   $0x80107c99
80103c80:	e8 eb c6 ff ff       	call   80100370 <panic>
80103c85:	8d 76 00             	lea    0x0(%esi),%esi
{
80103c88:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103c8d:	eb 0b                	jmp    80103c9a <mpinit+0x1ba>
80103c8f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103c90:	89 f3                	mov    %esi,%ebx
80103c92:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103c98:	74 de                	je     80103c78 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c9a:	83 ec 04             	sub    $0x4,%esp
80103c9d:	8d 73 10             	lea    0x10(%ebx),%esi
80103ca0:	6a 04                	push   $0x4
80103ca2:	68 8f 7c 10 80       	push   $0x80107c8f
80103ca7:	53                   	push   %ebx
80103ca8:	e8 33 13 00 00       	call   80104fe0 <memcmp>
80103cad:	83 c4 10             	add    $0x10,%esp
80103cb0:	85 c0                	test   %eax,%eax
80103cb2:	75 dc                	jne    80103c90 <mpinit+0x1b0>
80103cb4:	89 da                	mov    %ebx,%edx
80103cb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cbd:	00 
80103cbe:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103cc0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103cc3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103cc6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103cc8:	39 d6                	cmp    %edx,%esi
80103cca:	75 f4                	jne    80103cc0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103ccc:	84 c0                	test   %al,%al
80103cce:	75 c0                	jne    80103c90 <mpinit+0x1b0>
80103cd0:	e9 5b fe ff ff       	jmp    80103b30 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103cd5:	83 ec 0c             	sub    $0xc,%esp
80103cd8:	68 68 80 10 80       	push   $0x80108068
80103cdd:	e8 8e c6 ff ff       	call   80100370 <panic>
80103ce2:	66 90                	xchg   %ax,%ax
80103ce4:	66 90                	xchg   %ax,%ax
80103ce6:	66 90                	xchg   %ax,%ax
80103ce8:	66 90                	xchg   %ax,%ax
80103cea:	66 90                	xchg   %ax,%ax
80103cec:	66 90                	xchg   %ax,%ax
80103cee:	66 90                	xchg   %ax,%ax

80103cf0 <picinit>:
80103cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cf5:	ba 21 00 00 00       	mov    $0x21,%edx
80103cfa:	ee                   	out    %al,(%dx)
80103cfb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103d00:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103d01:	c3                   	ret
80103d02:	66 90                	xchg   %ax,%ax
80103d04:	66 90                	xchg   %ax,%ax
80103d06:	66 90                	xchg   %ax,%ax
80103d08:	66 90                	xchg   %ax,%ax
80103d0a:	66 90                	xchg   %ax,%ax
80103d0c:	66 90                	xchg   %ax,%ax
80103d0e:	66 90                	xchg   %ax,%ax

80103d10 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
80103d19:	8b 75 08             	mov    0x8(%ebp),%esi
80103d1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103d1f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103d25:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d2b:	e8 20 da ff ff       	call   80101750 <filealloc>
80103d30:	89 06                	mov    %eax,(%esi)
80103d32:	85 c0                	test   %eax,%eax
80103d34:	0f 84 a5 00 00 00    	je     80103ddf <pipealloc+0xcf>
80103d3a:	e8 11 da ff ff       	call   80101750 <filealloc>
80103d3f:	89 07                	mov    %eax,(%edi)
80103d41:	85 c0                	test   %eax,%eax
80103d43:	0f 84 84 00 00 00    	je     80103dcd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d49:	e8 12 f2 ff ff       	call   80102f60 <kalloc>
80103d4e:	89 c3                	mov    %eax,%ebx
80103d50:	85 c0                	test   %eax,%eax
80103d52:	0f 84 a0 00 00 00    	je     80103df8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103d58:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d5f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103d62:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103d65:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d6c:	00 00 00 
  p->nwrite = 0;
80103d6f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d76:	00 00 00 
  p->nread = 0;
80103d79:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d80:	00 00 00 
  initlock(&p->lock, "pipe");
80103d83:	68 b1 7c 10 80       	push   $0x80107cb1
80103d88:	50                   	push   %eax
80103d89:	e8 22 0f 00 00       	call   80104cb0 <initlock>
  (*f0)->type = FD_PIPE;
80103d8e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103d90:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d93:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d99:	8b 06                	mov    (%esi),%eax
80103d9b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d9f:	8b 06                	mov    (%esi),%eax
80103da1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103da5:	8b 06                	mov    (%esi),%eax
80103da7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103daa:	8b 07                	mov    (%edi),%eax
80103dac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103db2:	8b 07                	mov    (%edi),%eax
80103db4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103db8:	8b 07                	mov    (%edi),%eax
80103dba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dbe:	8b 07                	mov    (%edi),%eax
80103dc0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103dc3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc8:	5b                   	pop    %ebx
80103dc9:	5e                   	pop    %esi
80103dca:	5f                   	pop    %edi
80103dcb:	5d                   	pop    %ebp
80103dcc:	c3                   	ret
  if(*f0)
80103dcd:	8b 06                	mov    (%esi),%eax
80103dcf:	85 c0                	test   %eax,%eax
80103dd1:	74 1e                	je     80103df1 <pipealloc+0xe1>
    fileclose(*f0);
80103dd3:	83 ec 0c             	sub    $0xc,%esp
80103dd6:	50                   	push   %eax
80103dd7:	e8 34 da ff ff       	call   80101810 <fileclose>
80103ddc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103ddf:	8b 07                	mov    (%edi),%eax
80103de1:	85 c0                	test   %eax,%eax
80103de3:	74 0c                	je     80103df1 <pipealloc+0xe1>
    fileclose(*f1);
80103de5:	83 ec 0c             	sub    $0xc,%esp
80103de8:	50                   	push   %eax
80103de9:	e8 22 da ff ff       	call   80101810 <fileclose>
80103dee:	83 c4 10             	add    $0x10,%esp
  return -1;
80103df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103df6:	eb cd                	jmp    80103dc5 <pipealloc+0xb5>
  if(*f0)
80103df8:	8b 06                	mov    (%esi),%eax
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	75 d5                	jne    80103dd3 <pipealloc+0xc3>
80103dfe:	eb df                	jmp    80103ddf <pipealloc+0xcf>

80103e00 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	56                   	push   %esi
80103e04:	53                   	push   %ebx
80103e05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e08:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103e0b:	83 ec 0c             	sub    $0xc,%esp
80103e0e:	53                   	push   %ebx
80103e0f:	e8 8c 10 00 00       	call   80104ea0 <acquire>
  if(writable){
80103e14:	83 c4 10             	add    $0x10,%esp
80103e17:	85 f6                	test   %esi,%esi
80103e19:	74 65                	je     80103e80 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80103e1b:	83 ec 0c             	sub    $0xc,%esp
80103e1e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103e24:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103e2b:	00 00 00 
    wakeup(&p->nread);
80103e2e:	50                   	push   %eax
80103e2f:	e8 ac 0b 00 00       	call   801049e0 <wakeup>
80103e34:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e37:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103e3d:	85 d2                	test   %edx,%edx
80103e3f:	75 0a                	jne    80103e4b <pipeclose+0x4b>
80103e41:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103e47:	85 c0                	test   %eax,%eax
80103e49:	74 15                	je     80103e60 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103e4b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e51:	5b                   	pop    %ebx
80103e52:	5e                   	pop    %esi
80103e53:	5d                   	pop    %ebp
    release(&p->lock);
80103e54:	e9 e7 0f 00 00       	jmp    80104e40 <release>
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	53                   	push   %ebx
80103e64:	e8 d7 0f 00 00       	call   80104e40 <release>
    kfree((char*)p);
80103e69:	83 c4 10             	add    $0x10,%esp
80103e6c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e72:	5b                   	pop    %ebx
80103e73:	5e                   	pop    %esi
80103e74:	5d                   	pop    %ebp
    kfree((char*)p);
80103e75:	e9 26 ef ff ff       	jmp    80102da0 <kfree>
80103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103e89:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e90:	00 00 00 
    wakeup(&p->nwrite);
80103e93:	50                   	push   %eax
80103e94:	e8 47 0b 00 00       	call   801049e0 <wakeup>
80103e99:	83 c4 10             	add    $0x10,%esp
80103e9c:	eb 99                	jmp    80103e37 <pipeclose+0x37>
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
80103ea6:	83 ec 28             	sub    $0x28,%esp
80103ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103eac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80103eaf:	53                   	push   %ebx
80103eb0:	e8 eb 0f 00 00       	call   80104ea0 <acquire>
  for(i = 0; i < n; i++){
80103eb5:	83 c4 10             	add    $0x10,%esp
80103eb8:	85 ff                	test   %edi,%edi
80103eba:	0f 8e ce 00 00 00    	jle    80103f8e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ec0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ec9:	89 7d 10             	mov    %edi,0x10(%ebp)
80103ecc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ecf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103ed2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103ed5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103edb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ee1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ee7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103eed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103ef0:	0f 85 b6 00 00 00    	jne    80103fac <pipewrite+0x10c>
80103ef6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103ef9:	eb 3b                	jmp    80103f36 <pipewrite+0x96>
80103efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103f00:	e8 5b 03 00 00       	call   80104260 <myproc>
80103f05:	8b 48 24             	mov    0x24(%eax),%ecx
80103f08:	85 c9                	test   %ecx,%ecx
80103f0a:	75 34                	jne    80103f40 <pipewrite+0xa0>
      wakeup(&p->nread);
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	56                   	push   %esi
80103f10:	e8 cb 0a 00 00       	call   801049e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f15:	58                   	pop    %eax
80103f16:	5a                   	pop    %edx
80103f17:	53                   	push   %ebx
80103f18:	57                   	push   %edi
80103f19:	e8 02 0a 00 00       	call   80104920 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f1e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103f24:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103f2a:	83 c4 10             	add    $0x10,%esp
80103f2d:	05 00 02 00 00       	add    $0x200,%eax
80103f32:	39 c2                	cmp    %eax,%edx
80103f34:	75 2a                	jne    80103f60 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103f36:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103f3c:	85 c0                	test   %eax,%eax
80103f3e:	75 c0                	jne    80103f00 <pipewrite+0x60>
        release(&p->lock);
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	53                   	push   %ebx
80103f44:	e8 f7 0e 00 00       	call   80104e40 <release>
        return -1;
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f54:	5b                   	pop    %ebx
80103f55:	5e                   	pop    %esi
80103f56:	5f                   	pop    %edi
80103f57:	5d                   	pop    %ebp
80103f58:	c3                   	ret
80103f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f63:	8d 42 01             	lea    0x1(%edx),%eax
80103f66:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80103f6c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f6f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103f78:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80103f7c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f83:	39 c1                	cmp    %eax,%ecx
80103f85:	0f 85 50 ff ff ff    	jne    80103edb <pipewrite+0x3b>
80103f8b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f97:	50                   	push   %eax
80103f98:	e8 43 0a 00 00       	call   801049e0 <wakeup>
  release(&p->lock);
80103f9d:	89 1c 24             	mov    %ebx,(%esp)
80103fa0:	e8 9b 0e 00 00       	call   80104e40 <release>
  return n;
80103fa5:	83 c4 10             	add    $0x10,%esp
80103fa8:	89 f8                	mov    %edi,%eax
80103faa:	eb a5                	jmp    80103f51 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103fac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103faf:	eb b2                	jmp    80103f63 <pipewrite+0xc3>
80103fb1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fb8:	00 
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 18             	sub    $0x18,%esp
80103fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80103fcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103fcf:	56                   	push   %esi
80103fd0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103fd6:	e8 c5 0e 00 00       	call   80104ea0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fdb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fe1:	83 c4 10             	add    $0x10,%esp
80103fe4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103fea:	74 2f                	je     8010401b <piperead+0x5b>
80103fec:	eb 37                	jmp    80104025 <piperead+0x65>
80103fee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103ff0:	e8 6b 02 00 00       	call   80104260 <myproc>
80103ff5:	8b 40 24             	mov    0x24(%eax),%eax
80103ff8:	85 c0                	test   %eax,%eax
80103ffa:	0f 85 80 00 00 00    	jne    80104080 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104000:	83 ec 08             	sub    $0x8,%esp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	e8 16 09 00 00       	call   80104920 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010400a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104010:	83 c4 10             	add    $0x10,%esp
80104013:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104019:	75 0a                	jne    80104025 <piperead+0x65>
8010401b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80104021:	85 d2                	test   %edx,%edx
80104023:	75 cb                	jne    80103ff0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104025:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104028:	31 db                	xor    %ebx,%ebx
8010402a:	85 c9                	test   %ecx,%ecx
8010402c:	7f 26                	jg     80104054 <piperead+0x94>
8010402e:	eb 2c                	jmp    8010405c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104030:	8d 48 01             	lea    0x1(%eax),%ecx
80104033:	25 ff 01 00 00       	and    $0x1ff,%eax
80104038:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010403e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104043:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104046:	83 c3 01             	add    $0x1,%ebx
80104049:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010404c:	74 0e                	je     8010405c <piperead+0x9c>
8010404e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80104054:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010405a:	75 d4                	jne    80104030 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010405c:	83 ec 0c             	sub    $0xc,%esp
8010405f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104065:	50                   	push   %eax
80104066:	e8 75 09 00 00       	call   801049e0 <wakeup>
  release(&p->lock);
8010406b:	89 34 24             	mov    %esi,(%esp)
8010406e:	e8 cd 0d 00 00       	call   80104e40 <release>
  return i;
80104073:	83 c4 10             	add    $0x10,%esp
}
80104076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104079:	89 d8                	mov    %ebx,%eax
8010407b:	5b                   	pop    %ebx
8010407c:	5e                   	pop    %esi
8010407d:	5f                   	pop    %edi
8010407e:	5d                   	pop    %ebp
8010407f:	c3                   	ret
      release(&p->lock);
80104080:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104083:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104088:	56                   	push   %esi
80104089:	e8 b2 0d 00 00       	call   80104e40 <release>
      return -1;
8010408e:	83 c4 10             	add    $0x10,%esp
}
80104091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104094:	89 d8                	mov    %ebx,%eax
80104096:	5b                   	pop    %ebx
80104097:	5e                   	pop    %esi
80104098:	5f                   	pop    %edi
80104099:	5d                   	pop    %ebp
8010409a:	c3                   	ret
8010409b:	66 90                	xchg   %ax,%ax
8010409d:	66 90                	xchg   %ax,%ax
8010409f:	90                   	nop

801040a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a4:	bb 54 2f 11 80       	mov    $0x80112f54,%ebx
{
801040a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801040ac:	68 20 2f 11 80       	push   $0x80112f20
801040b1:	e8 ea 0d 00 00       	call   80104ea0 <acquire>
801040b6:	83 c4 10             	add    $0x10,%esp
801040b9:	eb 10                	jmp    801040cb <allocproc+0x2b>
801040bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c0:	83 c3 7c             	add    $0x7c,%ebx
801040c3:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801040c9:	74 75                	je     80104140 <allocproc+0xa0>
    if(p->state == UNUSED)
801040cb:	8b 43 0c             	mov    0xc(%ebx),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	75 ee                	jne    801040c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801040d2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801040d7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801040da:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801040e1:	89 43 10             	mov    %eax,0x10(%ebx)
801040e4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801040e7:	68 20 2f 11 80       	push   $0x80112f20
  p->pid = nextpid++;
801040ec:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801040f2:	e8 49 0d 00 00       	call   80104e40 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040f7:	e8 64 ee ff ff       	call   80102f60 <kalloc>
801040fc:	83 c4 10             	add    $0x10,%esp
801040ff:	89 43 08             	mov    %eax,0x8(%ebx)
80104102:	85 c0                	test   %eax,%eax
80104104:	74 53                	je     80104159 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104106:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010410c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010410f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104114:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104117:	c7 40 14 52 61 10 80 	movl   $0x80106152,0x14(%eax)
  p->context = (struct context*)sp;
8010411e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104121:	6a 14                	push   $0x14
80104123:	6a 00                	push   $0x0
80104125:	50                   	push   %eax
80104126:	e8 75 0e 00 00       	call   80104fa0 <memset>
  p->context->eip = (uint)forkret;
8010412b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010412e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104131:	c7 40 10 70 41 10 80 	movl   $0x80104170,0x10(%eax)
}
80104138:	89 d8                	mov    %ebx,%eax
8010413a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010413d:	c9                   	leave
8010413e:	c3                   	ret
8010413f:	90                   	nop
  release(&ptable.lock);
80104140:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104143:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104145:	68 20 2f 11 80       	push   $0x80112f20
8010414a:	e8 f1 0c 00 00       	call   80104e40 <release>
  return 0;
8010414f:	83 c4 10             	add    $0x10,%esp
}
80104152:	89 d8                	mov    %ebx,%eax
80104154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104157:	c9                   	leave
80104158:	c3                   	ret
    p->state = UNUSED;
80104159:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104160:	31 db                	xor    %ebx,%ebx
80104162:	eb ee                	jmp    80104152 <allocproc+0xb2>
80104164:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010416b:	00 
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104170 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104176:	68 20 2f 11 80       	push   $0x80112f20
8010417b:	e8 c0 0c 00 00       	call   80104e40 <release>

  if (first) {
80104180:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104185:	83 c4 10             	add    $0x10,%esp
80104188:	85 c0                	test   %eax,%eax
8010418a:	75 04                	jne    80104190 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010418c:	c9                   	leave
8010418d:	c3                   	ret
8010418e:	66 90                	xchg   %ax,%ax
    first = 0;
80104190:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104197:	00 00 00 
    iinit(ROOTDEV);
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	6a 01                	push   $0x1
8010419f:	e8 dc dc ff ff       	call   80101e80 <iinit>
    initlog(ROOTDEV);
801041a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801041ab:	e8 f0 f3 ff ff       	call   801035a0 <initlog>
}
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	c9                   	leave
801041b4:	c3                   	ret
801041b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041bc:	00 
801041bd:	8d 76 00             	lea    0x0(%esi),%esi

801041c0 <pinit>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801041c6:	68 b6 7c 10 80       	push   $0x80107cb6
801041cb:	68 20 2f 11 80       	push   $0x80112f20
801041d0:	e8 db 0a 00 00       	call   80104cb0 <initlock>
}
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	c9                   	leave
801041d9:	c3                   	ret
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <mycpu>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e5:	9c                   	pushf
801041e6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e7:	f6 c4 02             	test   $0x2,%ah
801041ea:	75 46                	jne    80104232 <mycpu+0x52>
  apicid = lapicid();
801041ec:	e8 df ef ff ff       	call   801031d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801041f1:	8b 35 84 29 11 80    	mov    0x80112984,%esi
801041f7:	85 f6                	test   %esi,%esi
801041f9:	7e 2a                	jle    80104225 <mycpu+0x45>
801041fb:	31 d2                	xor    %edx,%edx
801041fd:	eb 08                	jmp    80104207 <mycpu+0x27>
801041ff:	90                   	nop
80104200:	83 c2 01             	add    $0x1,%edx
80104203:	39 f2                	cmp    %esi,%edx
80104205:	74 1e                	je     80104225 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104207:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010420d:	0f b6 99 a0 29 11 80 	movzbl -0x7feed660(%ecx),%ebx
80104214:	39 c3                	cmp    %eax,%ebx
80104216:	75 e8                	jne    80104200 <mycpu+0x20>
}
80104218:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010421b:	8d 81 a0 29 11 80    	lea    -0x7feed660(%ecx),%eax
}
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5d                   	pop    %ebp
80104224:	c3                   	ret
  panic("unknown apicid\n");
80104225:	83 ec 0c             	sub    $0xc,%esp
80104228:	68 bd 7c 10 80       	push   $0x80107cbd
8010422d:	e8 3e c1 ff ff       	call   80100370 <panic>
    panic("mycpu called with interrupts enabled\n");
80104232:	83 ec 0c             	sub    $0xc,%esp
80104235:	68 88 80 10 80       	push   $0x80108088
8010423a:	e8 31 c1 ff ff       	call   80100370 <panic>
8010423f:	90                   	nop

80104240 <cpuid>:
cpuid() {
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104246:	e8 95 ff ff ff       	call   801041e0 <mycpu>
}
8010424b:	c9                   	leave
  return mycpu()-cpus;
8010424c:	2d a0 29 11 80       	sub    $0x801129a0,%eax
80104251:	c1 f8 04             	sar    $0x4,%eax
80104254:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010425a:	c3                   	ret
8010425b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104260 <myproc>:
myproc(void) {
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104267:	e8 e4 0a 00 00       	call   80104d50 <pushcli>
  c = mycpu();
8010426c:	e8 6f ff ff ff       	call   801041e0 <mycpu>
  p = c->proc;
80104271:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104277:	e8 24 0b 00 00       	call   80104da0 <popcli>
}
8010427c:	89 d8                	mov    %ebx,%eax
8010427e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104281:	c9                   	leave
80104282:	c3                   	ret
80104283:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010428a:	00 
8010428b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104290 <userinit>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104297:	e8 04 fe ff ff       	call   801040a0 <allocproc>
8010429c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010429e:	a3 54 4e 11 80       	mov    %eax,0x80114e54
  if((p->pgdir = setupkvm()) == 0)
801042a3:	e8 78 34 00 00       	call   80107720 <setupkvm>
801042a8:	89 43 04             	mov    %eax,0x4(%ebx)
801042ab:	85 c0                	test   %eax,%eax
801042ad:	0f 84 bd 00 00 00    	je     80104370 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042b3:	83 ec 04             	sub    $0x4,%esp
801042b6:	68 2c 00 00 00       	push   $0x2c
801042bb:	68 60 b4 10 80       	push   $0x8010b460
801042c0:	50                   	push   %eax
801042c1:	e8 3a 31 00 00       	call   80107400 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801042c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801042c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801042cf:	6a 4c                	push   $0x4c
801042d1:	6a 00                	push   $0x0
801042d3:	ff 73 18             	push   0x18(%ebx)
801042d6:	e8 c5 0c 00 00       	call   80104fa0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042db:	8b 43 18             	mov    0x18(%ebx),%eax
801042de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042e3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042e6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ef:	8b 43 18             	mov    0x18(%ebx),%eax
801042f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042f6:	8b 43 18             	mov    0x18(%ebx),%eax
801042f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104301:	8b 43 18             	mov    0x18(%ebx),%eax
80104304:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104308:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010430c:	8b 43 18             	mov    0x18(%ebx),%eax
8010430f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104316:	8b 43 18             	mov    0x18(%ebx),%eax
80104319:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104320:	8b 43 18             	mov    0x18(%ebx),%eax
80104323:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010432a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010432d:	6a 10                	push   $0x10
8010432f:	68 e6 7c 10 80       	push   $0x80107ce6
80104334:	50                   	push   %eax
80104335:	e8 16 0e 00 00       	call   80105150 <safestrcpy>
  p->cwd = namei("/");
8010433a:	c7 04 24 ef 7c 10 80 	movl   $0x80107cef,(%esp)
80104341:	e8 3a e6 ff ff       	call   80102980 <namei>
80104346:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104349:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80104350:	e8 4b 0b 00 00       	call   80104ea0 <acquire>
  p->state = RUNNABLE;
80104355:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010435c:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80104363:	e8 d8 0a 00 00       	call   80104e40 <release>
}
80104368:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010436b:	83 c4 10             	add    $0x10,%esp
8010436e:	c9                   	leave
8010436f:	c3                   	ret
    panic("userinit: out of memory?");
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	68 cd 7c 10 80       	push   $0x80107ccd
80104378:	e8 f3 bf ff ff       	call   80100370 <panic>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <growproc>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104388:	e8 c3 09 00 00       	call   80104d50 <pushcli>
  c = mycpu();
8010438d:	e8 4e fe ff ff       	call   801041e0 <mycpu>
  p = c->proc;
80104392:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104398:	e8 03 0a 00 00       	call   80104da0 <popcli>
  sz = curproc->sz;
8010439d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010439f:	85 f6                	test   %esi,%esi
801043a1:	7f 1d                	jg     801043c0 <growproc+0x40>
  } else if(n < 0){
801043a3:	75 3b                	jne    801043e0 <growproc+0x60>
  switchuvm(curproc);
801043a5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801043a8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801043aa:	53                   	push   %ebx
801043ab:	e8 40 2f 00 00       	call   801072f0 <switchuvm>
  return 0;
801043b0:	83 c4 10             	add    $0x10,%esp
801043b3:	31 c0                	xor    %eax,%eax
}
801043b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b8:	5b                   	pop    %ebx
801043b9:	5e                   	pop    %esi
801043ba:	5d                   	pop    %ebp
801043bb:	c3                   	ret
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043c0:	83 ec 04             	sub    $0x4,%esp
801043c3:	01 c6                	add    %eax,%esi
801043c5:	56                   	push   %esi
801043c6:	50                   	push   %eax
801043c7:	ff 73 04             	push   0x4(%ebx)
801043ca:	e8 81 31 00 00       	call   80107550 <allocuvm>
801043cf:	83 c4 10             	add    $0x10,%esp
801043d2:	85 c0                	test   %eax,%eax
801043d4:	75 cf                	jne    801043a5 <growproc+0x25>
      return -1;
801043d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043db:	eb d8                	jmp    801043b5 <growproc+0x35>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043e0:	83 ec 04             	sub    $0x4,%esp
801043e3:	01 c6                	add    %eax,%esi
801043e5:	56                   	push   %esi
801043e6:	50                   	push   %eax
801043e7:	ff 73 04             	push   0x4(%ebx)
801043ea:	e8 81 32 00 00       	call   80107670 <deallocuvm>
801043ef:	83 c4 10             	add    $0x10,%esp
801043f2:	85 c0                	test   %eax,%eax
801043f4:	75 af                	jne    801043a5 <growproc+0x25>
801043f6:	eb de                	jmp    801043d6 <growproc+0x56>
801043f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043ff:	00 

80104400 <fork>:
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	57                   	push   %edi
80104404:	56                   	push   %esi
80104405:	53                   	push   %ebx
80104406:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104409:	e8 42 09 00 00       	call   80104d50 <pushcli>
  c = mycpu();
8010440e:	e8 cd fd ff ff       	call   801041e0 <mycpu>
  p = c->proc;
80104413:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104419:	e8 82 09 00 00       	call   80104da0 <popcli>
  if((np = allocproc()) == 0){
8010441e:	e8 7d fc ff ff       	call   801040a0 <allocproc>
80104423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104426:	85 c0                	test   %eax,%eax
80104428:	0f 84 d6 00 00 00    	je     80104504 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010442e:	83 ec 08             	sub    $0x8,%esp
80104431:	ff 33                	push   (%ebx)
80104433:	89 c7                	mov    %eax,%edi
80104435:	ff 73 04             	push   0x4(%ebx)
80104438:	e8 d3 33 00 00       	call   80107810 <copyuvm>
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	89 47 04             	mov    %eax,0x4(%edi)
80104443:	85 c0                	test   %eax,%eax
80104445:	0f 84 9a 00 00 00    	je     801044e5 <fork+0xe5>
  np->sz = curproc->sz;
8010444b:	8b 03                	mov    (%ebx),%eax
8010444d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104450:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104452:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104455:	89 c8                	mov    %ecx,%eax
80104457:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010445a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010445f:	8b 73 18             	mov    0x18(%ebx),%esi
80104462:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104464:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104466:	8b 40 18             	mov    0x18(%eax),%eax
80104469:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104470:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104474:	85 c0                	test   %eax,%eax
80104476:	74 13                	je     8010448b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	50                   	push   %eax
8010447c:	e8 3f d3 ff ff       	call   801017c0 <filedup>
80104481:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104484:	83 c4 10             	add    $0x10,%esp
80104487:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010448b:	83 c6 01             	add    $0x1,%esi
8010448e:	83 fe 10             	cmp    $0x10,%esi
80104491:	75 dd                	jne    80104470 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104499:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010449c:	e8 cf db ff ff       	call   80102070 <idup>
801044a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044a4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801044a7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801044aa:	8d 47 6c             	lea    0x6c(%edi),%eax
801044ad:	6a 10                	push   $0x10
801044af:	53                   	push   %ebx
801044b0:	50                   	push   %eax
801044b1:	e8 9a 0c 00 00       	call   80105150 <safestrcpy>
  pid = np->pid;
801044b6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801044b9:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
801044c0:	e8 db 09 00 00       	call   80104ea0 <acquire>
  np->state = RUNNABLE;
801044c5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801044cc:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
801044d3:	e8 68 09 00 00       	call   80104e40 <release>
  return pid;
801044d8:	83 c4 10             	add    $0x10,%esp
}
801044db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044de:	89 d8                	mov    %ebx,%eax
801044e0:	5b                   	pop    %ebx
801044e1:	5e                   	pop    %esi
801044e2:	5f                   	pop    %edi
801044e3:	5d                   	pop    %ebp
801044e4:	c3                   	ret
    kfree(np->kstack);
801044e5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	ff 73 08             	push   0x8(%ebx)
801044ee:	e8 ad e8 ff ff       	call   80102da0 <kfree>
    np->kstack = 0;
801044f3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801044fa:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801044fd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104504:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104509:	eb d0                	jmp    801044db <fork+0xdb>
8010450b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104510 <scheduler>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
80104516:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104519:	e8 c2 fc ff ff       	call   801041e0 <mycpu>
  c->proc = 0;
8010451e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104525:	00 00 00 
  struct cpu *c = mycpu();
80104528:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010452a:	8d 78 04             	lea    0x4(%eax),%edi
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104530:	fb                   	sti
    acquire(&ptable.lock);
80104531:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104534:	bb 54 2f 11 80       	mov    $0x80112f54,%ebx
    acquire(&ptable.lock);
80104539:	68 20 2f 11 80       	push   $0x80112f20
8010453e:	e8 5d 09 00 00       	call   80104ea0 <acquire>
80104543:	83 c4 10             	add    $0x10,%esp
80104546:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010454d:	00 
8010454e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104550:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104554:	75 33                	jne    80104589 <scheduler+0x79>
      switchuvm(p);
80104556:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104559:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010455f:	53                   	push   %ebx
80104560:	e8 8b 2d 00 00       	call   801072f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104565:	58                   	pop    %eax
80104566:	5a                   	pop    %edx
80104567:	ff 73 1c             	push   0x1c(%ebx)
8010456a:	57                   	push   %edi
      p->state = RUNNING;
8010456b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104572:	e8 34 0c 00 00       	call   801051ab <swtch>
      switchkvm();
80104577:	e8 64 2d 00 00       	call   801072e0 <switchkvm>
      c->proc = 0;
8010457c:	83 c4 10             	add    $0x10,%esp
8010457f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104586:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104589:	83 c3 7c             	add    $0x7c,%ebx
8010458c:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80104592:	75 bc                	jne    80104550 <scheduler+0x40>
    release(&ptable.lock);
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	68 20 2f 11 80       	push   $0x80112f20
8010459c:	e8 9f 08 00 00       	call   80104e40 <release>
    sti();
801045a1:	83 c4 10             	add    $0x10,%esp
801045a4:	eb 8a                	jmp    80104530 <scheduler+0x20>
801045a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045ad:	00 
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <sched>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
  pushcli();
801045b5:	e8 96 07 00 00       	call   80104d50 <pushcli>
  c = mycpu();
801045ba:	e8 21 fc ff ff       	call   801041e0 <mycpu>
  p = c->proc;
801045bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045c5:	e8 d6 07 00 00       	call   80104da0 <popcli>
  if(!holding(&ptable.lock))
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	68 20 2f 11 80       	push   $0x80112f20
801045d2:	e8 29 08 00 00       	call   80104e00 <holding>
801045d7:	83 c4 10             	add    $0x10,%esp
801045da:	85 c0                	test   %eax,%eax
801045dc:	74 4f                	je     8010462d <sched+0x7d>
  if(mycpu()->ncli != 1)
801045de:	e8 fd fb ff ff       	call   801041e0 <mycpu>
801045e3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801045ea:	75 68                	jne    80104654 <sched+0xa4>
  if(p->state == RUNNING)
801045ec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801045f0:	74 55                	je     80104647 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045f2:	9c                   	pushf
801045f3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045f4:	f6 c4 02             	test   $0x2,%ah
801045f7:	75 41                	jne    8010463a <sched+0x8a>
  intena = mycpu()->intena;
801045f9:	e8 e2 fb ff ff       	call   801041e0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801045fe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104601:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104607:	e8 d4 fb ff ff       	call   801041e0 <mycpu>
8010460c:	83 ec 08             	sub    $0x8,%esp
8010460f:	ff 70 04             	push   0x4(%eax)
80104612:	53                   	push   %ebx
80104613:	e8 93 0b 00 00       	call   801051ab <swtch>
  mycpu()->intena = intena;
80104618:	e8 c3 fb ff ff       	call   801041e0 <mycpu>
}
8010461d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104620:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104626:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104629:	5b                   	pop    %ebx
8010462a:	5e                   	pop    %esi
8010462b:	5d                   	pop    %ebp
8010462c:	c3                   	ret
    panic("sched ptable.lock");
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	68 f1 7c 10 80       	push   $0x80107cf1
80104635:	e8 36 bd ff ff       	call   80100370 <panic>
    panic("sched interruptible");
8010463a:	83 ec 0c             	sub    $0xc,%esp
8010463d:	68 1d 7d 10 80       	push   $0x80107d1d
80104642:	e8 29 bd ff ff       	call   80100370 <panic>
    panic("sched running");
80104647:	83 ec 0c             	sub    $0xc,%esp
8010464a:	68 0f 7d 10 80       	push   $0x80107d0f
8010464f:	e8 1c bd ff ff       	call   80100370 <panic>
    panic("sched locks");
80104654:	83 ec 0c             	sub    $0xc,%esp
80104657:	68 03 7d 10 80       	push   $0x80107d03
8010465c:	e8 0f bd ff ff       	call   80100370 <panic>
80104661:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104668:	00 
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <exit>:
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
80104675:	53                   	push   %ebx
80104676:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104679:	e8 e2 fb ff ff       	call   80104260 <myproc>
  if(curproc == initproc)
8010467e:	39 05 54 4e 11 80    	cmp    %eax,0x80114e54
80104684:	0f 84 fd 00 00 00    	je     80104787 <exit+0x117>
8010468a:	89 c3                	mov    %eax,%ebx
8010468c:	8d 70 28             	lea    0x28(%eax),%esi
8010468f:	8d 78 68             	lea    0x68(%eax),%edi
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104698:	8b 06                	mov    (%esi),%eax
8010469a:	85 c0                	test   %eax,%eax
8010469c:	74 12                	je     801046b0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010469e:	83 ec 0c             	sub    $0xc,%esp
801046a1:	50                   	push   %eax
801046a2:	e8 69 d1 ff ff       	call   80101810 <fileclose>
      curproc->ofile[fd] = 0;
801046a7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046ad:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801046b0:	83 c6 04             	add    $0x4,%esi
801046b3:	39 f7                	cmp    %esi,%edi
801046b5:	75 e1                	jne    80104698 <exit+0x28>
  begin_op();
801046b7:	e8 84 ef ff ff       	call   80103640 <begin_op>
  iput(curproc->cwd);
801046bc:	83 ec 0c             	sub    $0xc,%esp
801046bf:	ff 73 68             	push   0x68(%ebx)
801046c2:	e8 09 db ff ff       	call   801021d0 <iput>
  end_op();
801046c7:	e8 e4 ef ff ff       	call   801036b0 <end_op>
  curproc->cwd = 0;
801046cc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801046d3:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
801046da:	e8 c1 07 00 00       	call   80104ea0 <acquire>
  wakeup1(curproc->parent);
801046df:	8b 53 14             	mov    0x14(%ebx),%edx
801046e2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046e5:	b8 54 2f 11 80       	mov    $0x80112f54,%eax
801046ea:	eb 0e                	jmp    801046fa <exit+0x8a>
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f0:	83 c0 7c             	add    $0x7c,%eax
801046f3:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801046f8:	74 1c                	je     80104716 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801046fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046fe:	75 f0                	jne    801046f0 <exit+0x80>
80104700:	3b 50 20             	cmp    0x20(%eax),%edx
80104703:	75 eb                	jne    801046f0 <exit+0x80>
      p->state = RUNNABLE;
80104705:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010470c:	83 c0 7c             	add    $0x7c,%eax
8010470f:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104714:	75 e4                	jne    801046fa <exit+0x8a>
      p->parent = initproc;
80104716:	8b 0d 54 4e 11 80    	mov    0x80114e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471c:	ba 54 2f 11 80       	mov    $0x80112f54,%edx
80104721:	eb 10                	jmp    80104733 <exit+0xc3>
80104723:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104728:	83 c2 7c             	add    $0x7c,%edx
8010472b:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80104731:	74 3b                	je     8010476e <exit+0xfe>
    if(p->parent == curproc){
80104733:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104736:	75 f0                	jne    80104728 <exit+0xb8>
      if(p->state == ZOMBIE)
80104738:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010473c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010473f:	75 e7                	jne    80104728 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104741:	b8 54 2f 11 80       	mov    $0x80112f54,%eax
80104746:	eb 12                	jmp    8010475a <exit+0xea>
80104748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474f:	00 
80104750:	83 c0 7c             	add    $0x7c,%eax
80104753:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104758:	74 ce                	je     80104728 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010475a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010475e:	75 f0                	jne    80104750 <exit+0xe0>
80104760:	3b 48 20             	cmp    0x20(%eax),%ecx
80104763:	75 eb                	jne    80104750 <exit+0xe0>
      p->state = RUNNABLE;
80104765:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010476c:	eb e2                	jmp    80104750 <exit+0xe0>
  curproc->state = ZOMBIE;
8010476e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104775:	e8 36 fe ff ff       	call   801045b0 <sched>
  panic("zombie exit");
8010477a:	83 ec 0c             	sub    $0xc,%esp
8010477d:	68 3e 7d 10 80       	push   $0x80107d3e
80104782:	e8 e9 bb ff ff       	call   80100370 <panic>
    panic("init exiting");
80104787:	83 ec 0c             	sub    $0xc,%esp
8010478a:	68 31 7d 10 80       	push   $0x80107d31
8010478f:	e8 dc bb ff ff       	call   80100370 <panic>
80104794:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010479b:	00 
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047a0 <wait>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
  pushcli();
801047a5:	e8 a6 05 00 00       	call   80104d50 <pushcli>
  c = mycpu();
801047aa:	e8 31 fa ff ff       	call   801041e0 <mycpu>
  p = c->proc;
801047af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047b5:	e8 e6 05 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
801047ba:	83 ec 0c             	sub    $0xc,%esp
801047bd:	68 20 2f 11 80       	push   $0x80112f20
801047c2:	e8 d9 06 00 00       	call   80104ea0 <acquire>
801047c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801047ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047cc:	bb 54 2f 11 80       	mov    $0x80112f54,%ebx
801047d1:	eb 10                	jmp    801047e3 <wait+0x43>
801047d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801047d8:	83 c3 7c             	add    $0x7c,%ebx
801047db:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801047e1:	74 1b                	je     801047fe <wait+0x5e>
      if(p->parent != curproc)
801047e3:	39 73 14             	cmp    %esi,0x14(%ebx)
801047e6:	75 f0                	jne    801047d8 <wait+0x38>
      if(p->state == ZOMBIE){
801047e8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801047ec:	74 62                	je     80104850 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ee:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801047f1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801047fc:	75 e5                	jne    801047e3 <wait+0x43>
    if(!havekids || curproc->killed){
801047fe:	85 c0                	test   %eax,%eax
80104800:	0f 84 a0 00 00 00    	je     801048a6 <wait+0x106>
80104806:	8b 46 24             	mov    0x24(%esi),%eax
80104809:	85 c0                	test   %eax,%eax
8010480b:	0f 85 95 00 00 00    	jne    801048a6 <wait+0x106>
  pushcli();
80104811:	e8 3a 05 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104816:	e8 c5 f9 ff ff       	call   801041e0 <mycpu>
  p = c->proc;
8010481b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104821:	e8 7a 05 00 00       	call   80104da0 <popcli>
  if(p == 0)
80104826:	85 db                	test   %ebx,%ebx
80104828:	0f 84 8f 00 00 00    	je     801048bd <wait+0x11d>
  p->chan = chan;
8010482e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104831:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104838:	e8 73 fd ff ff       	call   801045b0 <sched>
  p->chan = 0;
8010483d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104844:	eb 84                	jmp    801047ca <wait+0x2a>
80104846:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010484d:	00 
8010484e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104850:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104853:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104856:	ff 73 08             	push   0x8(%ebx)
80104859:	e8 42 e5 ff ff       	call   80102da0 <kfree>
        p->kstack = 0;
8010485e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104865:	5a                   	pop    %edx
80104866:	ff 73 04             	push   0x4(%ebx)
80104869:	e8 32 2e 00 00       	call   801076a0 <freevm>
        p->pid = 0;
8010486e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104875:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010487c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104880:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104887:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010488e:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80104895:	e8 a6 05 00 00       	call   80104e40 <release>
        return pid;
8010489a:	83 c4 10             	add    $0x10,%esp
}
8010489d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a0:	89 f0                	mov    %esi,%eax
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret
      release(&ptable.lock);
801048a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801048a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801048ae:	68 20 2f 11 80       	push   $0x80112f20
801048b3:	e8 88 05 00 00       	call   80104e40 <release>
      return -1;
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	eb e0                	jmp    8010489d <wait+0xfd>
    panic("sleep");
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	68 4a 7d 10 80       	push   $0x80107d4a
801048c5:	e8 a6 ba ff ff       	call   80100370 <panic>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <yield>:
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801048d7:	68 20 2f 11 80       	push   $0x80112f20
801048dc:	e8 bf 05 00 00       	call   80104ea0 <acquire>
  pushcli();
801048e1:	e8 6a 04 00 00       	call   80104d50 <pushcli>
  c = mycpu();
801048e6:	e8 f5 f8 ff ff       	call   801041e0 <mycpu>
  p = c->proc;
801048eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048f1:	e8 aa 04 00 00       	call   80104da0 <popcli>
  myproc()->state = RUNNABLE;
801048f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801048fd:	e8 ae fc ff ff       	call   801045b0 <sched>
  release(&ptable.lock);
80104902:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
80104909:	e8 32 05 00 00       	call   80104e40 <release>
}
8010490e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104911:	83 c4 10             	add    $0x10,%esp
80104914:	c9                   	leave
80104915:	c3                   	ret
80104916:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010491d:	00 
8010491e:	66 90                	xchg   %ax,%ax

80104920 <sleep>:
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	8b 7d 08             	mov    0x8(%ebp),%edi
8010492c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010492f:	e8 1c 04 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104934:	e8 a7 f8 ff ff       	call   801041e0 <mycpu>
  p = c->proc;
80104939:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010493f:	e8 5c 04 00 00       	call   80104da0 <popcli>
  if(p == 0)
80104944:	85 db                	test   %ebx,%ebx
80104946:	0f 84 87 00 00 00    	je     801049d3 <sleep+0xb3>
  if(lk == 0)
8010494c:	85 f6                	test   %esi,%esi
8010494e:	74 76                	je     801049c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104950:	81 fe 20 2f 11 80    	cmp    $0x80112f20,%esi
80104956:	74 50                	je     801049a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104958:	83 ec 0c             	sub    $0xc,%esp
8010495b:	68 20 2f 11 80       	push   $0x80112f20
80104960:	e8 3b 05 00 00       	call   80104ea0 <acquire>
    release(lk);
80104965:	89 34 24             	mov    %esi,(%esp)
80104968:	e8 d3 04 00 00       	call   80104e40 <release>
  p->chan = chan;
8010496d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104970:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104977:	e8 34 fc ff ff       	call   801045b0 <sched>
  p->chan = 0;
8010497c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104983:	c7 04 24 20 2f 11 80 	movl   $0x80112f20,(%esp)
8010498a:	e8 b1 04 00 00       	call   80104e40 <release>
    acquire(lk);
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104995:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104998:	5b                   	pop    %ebx
80104999:	5e                   	pop    %esi
8010499a:	5f                   	pop    %edi
8010499b:	5d                   	pop    %ebp
    acquire(lk);
8010499c:	e9 ff 04 00 00       	jmp    80104ea0 <acquire>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801049a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801049ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049b2:	e8 f9 fb ff ff       	call   801045b0 <sched>
  p->chan = 0;
801049b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c1:	5b                   	pop    %ebx
801049c2:	5e                   	pop    %esi
801049c3:	5f                   	pop    %edi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret
    panic("sleep without lk");
801049c6:	83 ec 0c             	sub    $0xc,%esp
801049c9:	68 50 7d 10 80       	push   $0x80107d50
801049ce:	e8 9d b9 ff ff       	call   80100370 <panic>
    panic("sleep");
801049d3:	83 ec 0c             	sub    $0xc,%esp
801049d6:	68 4a 7d 10 80       	push   $0x80107d4a
801049db:	e8 90 b9 ff ff       	call   80100370 <panic>

801049e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 10             	sub    $0x10,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ea:	68 20 2f 11 80       	push   $0x80112f20
801049ef:	e8 ac 04 00 00       	call   80104ea0 <acquire>
801049f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049f7:	b8 54 2f 11 80       	mov    $0x80112f54,%eax
801049fc:	eb 0c                	jmp    80104a0a <wakeup+0x2a>
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	83 c0 7c             	add    $0x7c,%eax
80104a03:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104a08:	74 1c                	je     80104a26 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80104a0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a0e:	75 f0                	jne    80104a00 <wakeup+0x20>
80104a10:	3b 58 20             	cmp    0x20(%eax),%ebx
80104a13:	75 eb                	jne    80104a00 <wakeup+0x20>
      p->state = RUNNABLE;
80104a15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a1c:	83 c0 7c             	add    $0x7c,%eax
80104a1f:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104a24:	75 e4                	jne    80104a0a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104a26:	c7 45 08 20 2f 11 80 	movl   $0x80112f20,0x8(%ebp)
}
80104a2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a30:	c9                   	leave
  release(&ptable.lock);
80104a31:	e9 0a 04 00 00       	jmp    80104e40 <release>
80104a36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a3d:	00 
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 10             	sub    $0x10,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a4a:	68 20 2f 11 80       	push   $0x80112f20
80104a4f:	e8 4c 04 00 00       	call   80104ea0 <acquire>
80104a54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a57:	b8 54 2f 11 80       	mov    $0x80112f54,%eax
80104a5c:	eb 0c                	jmp    80104a6a <kill+0x2a>
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	83 c0 7c             	add    $0x7c,%eax
80104a63:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80104a68:	74 36                	je     80104aa0 <kill+0x60>
    if(p->pid == pid){
80104a6a:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a6d:	75 f1                	jne    80104a60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a6f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a7a:	75 07                	jne    80104a83 <kill+0x43>
        p->state = RUNNABLE;
80104a7c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a83:	83 ec 0c             	sub    $0xc,%esp
80104a86:	68 20 2f 11 80       	push   $0x80112f20
80104a8b:	e8 b0 03 00 00       	call   80104e40 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a93:	83 c4 10             	add    $0x10,%esp
80104a96:	31 c0                	xor    %eax,%eax
}
80104a98:	c9                   	leave
80104a99:	c3                   	ret
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	68 20 2f 11 80       	push   $0x80112f20
80104aa8:	e8 93 03 00 00       	call   80104e40 <release>
}
80104aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104ab0:	83 c4 10             	add    $0x10,%esp
80104ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ab8:	c9                   	leave
80104ab9:	c3                   	ret
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104ac8:	53                   	push   %ebx
80104ac9:	bb c0 2f 11 80       	mov    $0x80112fc0,%ebx
80104ace:	83 ec 3c             	sub    $0x3c,%esp
80104ad1:	eb 24                	jmp    80104af7 <procdump+0x37>
80104ad3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	68 0f 7f 10 80       	push   $0x80107f0f
80104ae0:	e8 7b bc ff ff       	call   80100760 <cprintf>
80104ae5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae8:	83 c3 7c             	add    $0x7c,%ebx
80104aeb:	81 fb c0 4e 11 80    	cmp    $0x80114ec0,%ebx
80104af1:	0f 84 81 00 00 00    	je     80104b78 <procdump+0xb8>
    if(p->state == UNUSED)
80104af7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104afa:	85 c0                	test   %eax,%eax
80104afc:	74 ea                	je     80104ae8 <procdump+0x28>
      state = "???";
80104afe:	ba 61 7d 10 80       	mov    $0x80107d61,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b03:	83 f8 05             	cmp    $0x5,%eax
80104b06:	77 11                	ja     80104b19 <procdump+0x59>
80104b08:	8b 14 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%edx
      state = "???";
80104b0f:	b8 61 7d 10 80       	mov    $0x80107d61,%eax
80104b14:	85 d2                	test   %edx,%edx
80104b16:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b19:	53                   	push   %ebx
80104b1a:	52                   	push   %edx
80104b1b:	ff 73 a4             	push   -0x5c(%ebx)
80104b1e:	68 65 7d 10 80       	push   $0x80107d65
80104b23:	e8 38 bc ff ff       	call   80100760 <cprintf>
    if(p->state == SLEEPING){
80104b28:	83 c4 10             	add    $0x10,%esp
80104b2b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104b2f:	75 a7                	jne    80104ad8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b31:	83 ec 08             	sub    $0x8,%esp
80104b34:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b37:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b3a:	50                   	push   %eax
80104b3b:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104b3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104b41:	83 c0 08             	add    $0x8,%eax
80104b44:	50                   	push   %eax
80104b45:	e8 86 01 00 00       	call   80104cd0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b4a:	83 c4 10             	add    $0x10,%esp
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
80104b50:	8b 17                	mov    (%edi),%edx
80104b52:	85 d2                	test   %edx,%edx
80104b54:	74 82                	je     80104ad8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104b56:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104b59:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104b5c:	52                   	push   %edx
80104b5d:	68 a1 7a 10 80       	push   $0x80107aa1
80104b62:	e8 f9 bb ff ff       	call   80100760 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b67:	83 c4 10             	add    $0x10,%esp
80104b6a:	39 f7                	cmp    %esi,%edi
80104b6c:	75 e2                	jne    80104b50 <procdump+0x90>
80104b6e:	e9 65 ff ff ff       	jmp    80104ad8 <procdump+0x18>
80104b73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7b:	5b                   	pop    %ebx
80104b7c:	5e                   	pop    %esi
80104b7d:	5f                   	pop    %edi
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret

80104b80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b8a:	68 98 7d 10 80       	push   $0x80107d98
80104b8f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b92:	50                   	push   %eax
80104b93:	e8 18 01 00 00       	call   80104cb0 <initlock>
  lk->name = name;
80104b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ba1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ba4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb1:	c9                   	leave
80104bb2:	c3                   	ret
80104bb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bba:	00 
80104bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104bc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bc8:	8d 73 04             	lea    0x4(%ebx),%esi
80104bcb:	83 ec 0c             	sub    $0xc,%esp
80104bce:	56                   	push   %esi
80104bcf:	e8 cc 02 00 00       	call   80104ea0 <acquire>
  while (lk->locked) {
80104bd4:	8b 13                	mov    (%ebx),%edx
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	85 d2                	test   %edx,%edx
80104bdb:	74 16                	je     80104bf3 <acquiresleep+0x33>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104be0:	83 ec 08             	sub    $0x8,%esp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	e8 36 fd ff ff       	call   80104920 <sleep>
  while (lk->locked) {
80104bea:	8b 03                	mov    (%ebx),%eax
80104bec:	83 c4 10             	add    $0x10,%esp
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	75 ed                	jne    80104be0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104bf3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bf9:	e8 62 f6 ff ff       	call   80104260 <myproc>
80104bfe:	8b 40 10             	mov    0x10(%eax),%eax
80104c01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c0a:	5b                   	pop    %ebx
80104c0b:	5e                   	pop    %esi
80104c0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c0d:	e9 2e 02 00 00       	jmp    80104e40 <release>
80104c12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c19:	00 
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c28:	8d 73 04             	lea    0x4(%ebx),%esi
80104c2b:	83 ec 0c             	sub    $0xc,%esp
80104c2e:	56                   	push   %esi
80104c2f:	e8 6c 02 00 00       	call   80104ea0 <acquire>
  lk->locked = 0;
80104c34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c41:	89 1c 24             	mov    %ebx,(%esp)
80104c44:	e8 97 fd ff ff       	call   801049e0 <wakeup>
  release(&lk->lk);
80104c49:	83 c4 10             	add    $0x10,%esp
80104c4c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c52:	5b                   	pop    %ebx
80104c53:	5e                   	pop    %esi
80104c54:	5d                   	pop    %ebp
  release(&lk->lk);
80104c55:	e9 e6 01 00 00       	jmp    80104e40 <release>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	31 ff                	xor    %edi,%edi
80104c66:	56                   	push   %esi
80104c67:	53                   	push   %ebx
80104c68:	83 ec 18             	sub    $0x18,%esp
80104c6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c6e:	8d 73 04             	lea    0x4(%ebx),%esi
80104c71:	56                   	push   %esi
80104c72:	e8 29 02 00 00       	call   80104ea0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c77:	8b 03                	mov    (%ebx),%eax
80104c79:	83 c4 10             	add    $0x10,%esp
80104c7c:	85 c0                	test   %eax,%eax
80104c7e:	75 18                	jne    80104c98 <holdingsleep+0x38>
  release(&lk->lk);
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	56                   	push   %esi
80104c84:	e8 b7 01 00 00       	call   80104e40 <release>
  return r;
}
80104c89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c8c:	89 f8                	mov    %edi,%eax
80104c8e:	5b                   	pop    %ebx
80104c8f:	5e                   	pop    %esi
80104c90:	5f                   	pop    %edi
80104c91:	5d                   	pop    %ebp
80104c92:	c3                   	ret
80104c93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104c98:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c9b:	e8 c0 f5 ff ff       	call   80104260 <myproc>
80104ca0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ca3:	0f 94 c0             	sete   %al
80104ca6:	0f b6 c0             	movzbl %al,%eax
80104ca9:	89 c7                	mov    %eax,%edi
80104cab:	eb d3                	jmp    80104c80 <holdingsleep+0x20>
80104cad:	66 90                	xchg   %ax,%ax
80104caf:	90                   	nop

80104cb0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cbf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret
80104ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104cd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	53                   	push   %ebx
80104cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104cda:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cdd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104ce2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104ce7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cec:	76 10                	jbe    80104cfe <getcallerpcs+0x2e>
80104cee:	eb 28                	jmp    80104d18 <getcallerpcs+0x48>
80104cf0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104cf6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cfc:	77 1a                	ja     80104d18 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cfe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104d01:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104d04:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104d07:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104d09:	83 f8 0a             	cmp    $0xa,%eax
80104d0c:	75 e2                	jne    80104cf0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d11:	c9                   	leave
80104d12:	c3                   	ret
80104d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d18:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80104d1b:	83 c1 28             	add    $0x28,%ecx
80104d1e:	89 ca                	mov    %ecx,%edx
80104d20:	29 c2                	sub    %eax,%edx
80104d22:	83 e2 04             	and    $0x4,%edx
80104d25:	74 11                	je     80104d38 <getcallerpcs+0x68>
    pcs[i] = 0;
80104d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d2d:	83 c0 04             	add    $0x4,%eax
80104d30:	39 c1                	cmp    %eax,%ecx
80104d32:	74 da                	je     80104d0e <getcallerpcs+0x3e>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104d38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d3e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104d41:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104d48:	39 c1                	cmp    %eax,%ecx
80104d4a:	75 ec                	jne    80104d38 <getcallerpcs+0x68>
80104d4c:	eb c0                	jmp    80104d0e <getcallerpcs+0x3e>
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 04             	sub    $0x4,%esp
80104d57:	9c                   	pushf
80104d58:	5b                   	pop    %ebx
  asm volatile("cli");
80104d59:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d5a:	e8 81 f4 ff ff       	call   801041e0 <mycpu>
80104d5f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d65:	85 c0                	test   %eax,%eax
80104d67:	74 17                	je     80104d80 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d69:	e8 72 f4 ff ff       	call   801041e0 <mycpu>
80104d6e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d78:	c9                   	leave
80104d79:	c3                   	ret
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104d80:	e8 5b f4 ff ff       	call   801041e0 <mycpu>
80104d85:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d8b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d91:	eb d6                	jmp    80104d69 <pushcli+0x19>
80104d93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9a:	00 
80104d9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104da0 <popcli>:

void
popcli(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104da6:	9c                   	pushf
80104da7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104da8:	f6 c4 02             	test   $0x2,%ah
80104dab:	75 35                	jne    80104de2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104dad:	e8 2e f4 ff ff       	call   801041e0 <mycpu>
80104db2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104db9:	78 34                	js     80104def <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dbb:	e8 20 f4 ff ff       	call   801041e0 <mycpu>
80104dc0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dc6:	85 d2                	test   %edx,%edx
80104dc8:	74 06                	je     80104dd0 <popcli+0x30>
    sti();
}
80104dca:	c9                   	leave
80104dcb:	c3                   	ret
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dd0:	e8 0b f4 ff ff       	call   801041e0 <mycpu>
80104dd5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	74 eb                	je     80104dca <popcli+0x2a>
  asm volatile("sti");
80104ddf:	fb                   	sti
}
80104de0:	c9                   	leave
80104de1:	c3                   	ret
    panic("popcli - interruptible");
80104de2:	83 ec 0c             	sub    $0xc,%esp
80104de5:	68 a3 7d 10 80       	push   $0x80107da3
80104dea:	e8 81 b5 ff ff       	call   80100370 <panic>
    panic("popcli");
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	68 ba 7d 10 80       	push   $0x80107dba
80104df7:	e8 74 b5 ff ff       	call   80100370 <panic>
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <holding>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 75 08             	mov    0x8(%ebp),%esi
80104e08:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e0a:	e8 41 ff ff ff       	call   80104d50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e0f:	8b 06                	mov    (%esi),%eax
80104e11:	85 c0                	test   %eax,%eax
80104e13:	75 0b                	jne    80104e20 <holding+0x20>
  popcli();
80104e15:	e8 86 ff ff ff       	call   80104da0 <popcli>
}
80104e1a:	89 d8                	mov    %ebx,%eax
80104e1c:	5b                   	pop    %ebx
80104e1d:	5e                   	pop    %esi
80104e1e:	5d                   	pop    %ebp
80104e1f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104e20:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e23:	e8 b8 f3 ff ff       	call   801041e0 <mycpu>
80104e28:	39 c3                	cmp    %eax,%ebx
80104e2a:	0f 94 c3             	sete   %bl
  popcli();
80104e2d:	e8 6e ff ff ff       	call   80104da0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e32:	0f b6 db             	movzbl %bl,%ebx
}
80104e35:	89 d8                	mov    %ebx,%eax
80104e37:	5b                   	pop    %ebx
80104e38:	5e                   	pop    %esi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret
80104e3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104e40 <release>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e48:	e8 03 ff ff ff       	call   80104d50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e4d:	8b 03                	mov    (%ebx),%eax
80104e4f:	85 c0                	test   %eax,%eax
80104e51:	75 15                	jne    80104e68 <release+0x28>
  popcli();
80104e53:	e8 48 ff ff ff       	call   80104da0 <popcli>
    panic("release");
80104e58:	83 ec 0c             	sub    $0xc,%esp
80104e5b:	68 c1 7d 10 80       	push   $0x80107dc1
80104e60:	e8 0b b5 ff ff       	call   80100370 <panic>
80104e65:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e68:	8b 73 08             	mov    0x8(%ebx),%esi
80104e6b:	e8 70 f3 ff ff       	call   801041e0 <mycpu>
80104e70:	39 c6                	cmp    %eax,%esi
80104e72:	75 df                	jne    80104e53 <release+0x13>
  popcli();
80104e74:	e8 27 ff ff ff       	call   80104da0 <popcli>
  lk->pcs[0] = 0;
80104e79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e80:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e87:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e8c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5d                   	pop    %ebp
  popcli();
80104e98:	e9 03 ff ff ff       	jmp    80104da0 <popcli>
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <acquire>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ea7:	e8 a4 fe ff ff       	call   80104d50 <pushcli>
  if(holding(lk))
80104eac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104eaf:	e8 9c fe ff ff       	call   80104d50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104eb4:	8b 03                	mov    (%ebx),%eax
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	0f 85 b2 00 00 00    	jne    80104f70 <acquire+0xd0>
  popcli();
80104ebe:	e8 dd fe ff ff       	call   80104da0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104ec3:	b9 01 00 00 00       	mov    $0x1,%ecx
80104ec8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ecf:	00 
  while(xchg(&lk->locked, 1) != 0)
80104ed0:	8b 55 08             	mov    0x8(%ebp),%edx
80104ed3:	89 c8                	mov    %ecx,%eax
80104ed5:	f0 87 02             	lock xchg %eax,(%edx)
80104ed8:	85 c0                	test   %eax,%eax
80104eda:	75 f4                	jne    80104ed0 <acquire+0x30>
  __sync_synchronize();
80104edc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ee1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ee4:	e8 f7 f2 ff ff       	call   801041e0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
80104eec:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
80104eee:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ef1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104ef7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80104efc:	77 32                	ja     80104f30 <acquire+0x90>
  ebp = (uint*)v - 2;
80104efe:	89 e8                	mov    %ebp,%eax
80104f00:	eb 14                	jmp    80104f16 <acquire+0x76>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f08:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104f0e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f14:	77 1a                	ja     80104f30 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104f16:	8b 58 04             	mov    0x4(%eax),%ebx
80104f19:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104f1d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104f20:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f22:	83 fa 0a             	cmp    $0xa,%edx
80104f25:	75 e1                	jne    80104f08 <acquire+0x68>
}
80104f27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f2a:	c9                   	leave
80104f2b:	c3                   	ret
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f30:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104f34:	83 c1 34             	add    $0x34,%ecx
80104f37:	89 ca                	mov    %ecx,%edx
80104f39:	29 c2                	sub    %eax,%edx
80104f3b:	83 e2 04             	and    $0x4,%edx
80104f3e:	74 10                	je     80104f50 <acquire+0xb0>
    pcs[i] = 0;
80104f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f46:	83 c0 04             	add    $0x4,%eax
80104f49:	39 c1                	cmp    %eax,%ecx
80104f4b:	74 da                	je     80104f27 <acquire+0x87>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f56:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104f59:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104f60:	39 c1                	cmp    %eax,%ecx
80104f62:	75 ec                	jne    80104f50 <acquire+0xb0>
80104f64:	eb c1                	jmp    80104f27 <acquire+0x87>
80104f66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f6d:	00 
80104f6e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104f70:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104f73:	e8 68 f2 ff ff       	call   801041e0 <mycpu>
80104f78:	39 c3                	cmp    %eax,%ebx
80104f7a:	0f 85 3e ff ff ff    	jne    80104ebe <acquire+0x1e>
  popcli();
80104f80:	e8 1b fe ff ff       	call   80104da0 <popcli>
    panic("acquire");
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	68 c9 7d 10 80       	push   $0x80107dc9
80104f8d:	e8 de b3 ff ff       	call   80100370 <panic>
80104f92:	66 90                	xchg   %ax,%ax
80104f94:	66 90                	xchg   %ax,%ax
80104f96:	66 90                	xchg   %ax,%ax
80104f98:	66 90                	xchg   %ax,%ax
80104f9a:	66 90                	xchg   %ax,%ax
80104f9c:	66 90                	xchg   %ax,%ax
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104faa:	89 d0                	mov    %edx,%eax
80104fac:	09 c8                	or     %ecx,%eax
80104fae:	a8 03                	test   $0x3,%al
80104fb0:	75 1e                	jne    80104fd0 <memset+0x30>
    c &= 0xFF;
80104fb2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fb6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104fb9:	89 d7                	mov    %edx,%edi
80104fbb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104fc1:	fc                   	cld
80104fc2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104fc4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104fc7:	89 d0                	mov    %edx,%eax
80104fc9:	c9                   	leave
80104fca:	c3                   	ret
80104fcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd3:	89 d7                	mov    %edx,%edi
80104fd5:	fc                   	cld
80104fd6:	f3 aa                	rep stos %al,%es:(%edi)
80104fd8:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104fdb:	89 d0                	mov    %edx,%eax
80104fdd:	c9                   	leave
80104fde:	c3                   	ret
80104fdf:	90                   	nop

80104fe0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fea:	53                   	push   %ebx
80104feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fee:	85 f6                	test   %esi,%esi
80104ff0:	74 2e                	je     80105020 <memcmp+0x40>
80104ff2:	01 c6                	add    %eax,%esi
80104ff4:	eb 14                	jmp    8010500a <memcmp+0x2a>
80104ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ffd:	00 
80104ffe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105000:	83 c0 01             	add    $0x1,%eax
80105003:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105006:	39 f0                	cmp    %esi,%eax
80105008:	74 16                	je     80105020 <memcmp+0x40>
    if(*s1 != *s2)
8010500a:	0f b6 08             	movzbl (%eax),%ecx
8010500d:	0f b6 1a             	movzbl (%edx),%ebx
80105010:	38 d9                	cmp    %bl,%cl
80105012:	74 ec                	je     80105000 <memcmp+0x20>
      return *s1 - *s2;
80105014:	0f b6 c1             	movzbl %cl,%eax
80105017:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105019:	5b                   	pop    %ebx
8010501a:	5e                   	pop    %esi
8010501b:	5d                   	pop    %ebp
8010501c:	c3                   	ret
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
80105020:	5b                   	pop    %ebx
  return 0;
80105021:	31 c0                	xor    %eax,%eax
}
80105023:	5e                   	pop    %esi
80105024:	5d                   	pop    %ebp
80105025:	c3                   	ret
80105026:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010502d:	00 
8010502e:	66 90                	xchg   %ax,%ax

80105030 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	8b 55 08             	mov    0x8(%ebp),%edx
80105037:	8b 45 10             	mov    0x10(%ebp),%eax
8010503a:	56                   	push   %esi
8010503b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010503e:	39 d6                	cmp    %edx,%esi
80105040:	73 26                	jae    80105068 <memmove+0x38>
80105042:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80105045:	39 ca                	cmp    %ecx,%edx
80105047:	73 1f                	jae    80105068 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105049:	85 c0                	test   %eax,%eax
8010504b:	74 0f                	je     8010505c <memmove+0x2c>
8010504d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80105050:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105054:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105057:	83 e8 01             	sub    $0x1,%eax
8010505a:	73 f4                	jae    80105050 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010505c:	5e                   	pop    %esi
8010505d:	89 d0                	mov    %edx,%eax
8010505f:	5f                   	pop    %edi
80105060:	5d                   	pop    %ebp
80105061:	c3                   	ret
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105068:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010506b:	89 d7                	mov    %edx,%edi
8010506d:	85 c0                	test   %eax,%eax
8010506f:	74 eb                	je     8010505c <memmove+0x2c>
80105071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105078:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105079:	39 ce                	cmp    %ecx,%esi
8010507b:	75 fb                	jne    80105078 <memmove+0x48>
}
8010507d:	5e                   	pop    %esi
8010507e:	89 d0                	mov    %edx,%eax
80105080:	5f                   	pop    %edi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret
80105083:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010508a:	00 
8010508b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105090 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105090:	eb 9e                	jmp    80105030 <memmove>
80105092:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105099:	00 
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	53                   	push   %ebx
801050a4:	8b 55 10             	mov    0x10(%ebp),%edx
801050a7:	8b 45 08             	mov    0x8(%ebp),%eax
801050aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801050ad:	85 d2                	test   %edx,%edx
801050af:	75 16                	jne    801050c7 <strncmp+0x27>
801050b1:	eb 2d                	jmp    801050e0 <strncmp+0x40>
801050b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801050b8:	3a 19                	cmp    (%ecx),%bl
801050ba:	75 12                	jne    801050ce <strncmp+0x2e>
    n--, p++, q++;
801050bc:	83 c0 01             	add    $0x1,%eax
801050bf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050c2:	83 ea 01             	sub    $0x1,%edx
801050c5:	74 19                	je     801050e0 <strncmp+0x40>
801050c7:	0f b6 18             	movzbl (%eax),%ebx
801050ca:	84 db                	test   %bl,%bl
801050cc:	75 ea                	jne    801050b8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801050ce:	0f b6 00             	movzbl (%eax),%eax
801050d1:	0f b6 11             	movzbl (%ecx),%edx
}
801050d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801050d8:	29 d0                	sub    %edx,%eax
}
801050da:	c3                   	ret
801050db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801050e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801050e3:	31 c0                	xor    %eax,%eax
}
801050e5:	c9                   	leave
801050e6:	c3                   	ret
801050e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050ee:	00 
801050ef:	90                   	nop

801050f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
801050f5:	8b 75 08             	mov    0x8(%ebp),%esi
801050f8:	53                   	push   %ebx
801050f9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050fc:	89 f0                	mov    %esi,%eax
801050fe:	eb 15                	jmp    80105115 <strncpy+0x25>
80105100:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105104:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105107:	83 c0 01             	add    $0x1,%eax
8010510a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010510e:	88 48 ff             	mov    %cl,-0x1(%eax)
80105111:	84 c9                	test   %cl,%cl
80105113:	74 13                	je     80105128 <strncpy+0x38>
80105115:	89 d3                	mov    %edx,%ebx
80105117:	83 ea 01             	sub    $0x1,%edx
8010511a:	85 db                	test   %ebx,%ebx
8010511c:	7f e2                	jg     80105100 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010511e:	5b                   	pop    %ebx
8010511f:	89 f0                	mov    %esi,%eax
80105121:	5e                   	pop    %esi
80105122:	5f                   	pop    %edi
80105123:	5d                   	pop    %ebp
80105124:	c3                   	ret
80105125:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80105128:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010512b:	83 e9 01             	sub    $0x1,%ecx
8010512e:	85 d2                	test   %edx,%edx
80105130:	74 ec                	je     8010511e <strncpy+0x2e>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80105138:	83 c0 01             	add    $0x1,%eax
8010513b:	89 ca                	mov    %ecx,%edx
8010513d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80105141:	29 c2                	sub    %eax,%edx
80105143:	85 d2                	test   %edx,%edx
80105145:	7f f1                	jg     80105138 <strncpy+0x48>
}
80105147:	5b                   	pop    %ebx
80105148:	89 f0                	mov    %esi,%eax
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret
8010514e:	66 90                	xchg   %ax,%ax

80105150 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	8b 55 10             	mov    0x10(%ebp),%edx
80105157:	8b 75 08             	mov    0x8(%ebp),%esi
8010515a:	53                   	push   %ebx
8010515b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010515e:	85 d2                	test   %edx,%edx
80105160:	7e 25                	jle    80105187 <safestrcpy+0x37>
80105162:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105166:	89 f2                	mov    %esi,%edx
80105168:	eb 16                	jmp    80105180 <safestrcpy+0x30>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105170:	0f b6 08             	movzbl (%eax),%ecx
80105173:	83 c0 01             	add    $0x1,%eax
80105176:	83 c2 01             	add    $0x1,%edx
80105179:	88 4a ff             	mov    %cl,-0x1(%edx)
8010517c:	84 c9                	test   %cl,%cl
8010517e:	74 04                	je     80105184 <safestrcpy+0x34>
80105180:	39 d8                	cmp    %ebx,%eax
80105182:	75 ec                	jne    80105170 <safestrcpy+0x20>
    ;
  *s = 0;
80105184:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105187:	89 f0                	mov    %esi,%eax
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5d                   	pop    %ebp
8010518c:	c3                   	ret
8010518d:	8d 76 00             	lea    0x0(%esi),%esi

80105190 <strlen>:

int
strlen(const char *s)
{
80105190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105198:	80 3a 00             	cmpb   $0x0,(%edx)
8010519b:	74 0c                	je     801051a9 <strlen+0x19>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c0 01             	add    $0x1,%eax
801051a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051a7:	75 f7                	jne    801051a0 <strlen+0x10>
    ;
  return n;
}
801051a9:	5d                   	pop    %ebp
801051aa:	c3                   	ret

801051ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051b3:	55                   	push   %ebp
  pushl %ebx
801051b4:	53                   	push   %ebx
  pushl %esi
801051b5:	56                   	push   %esi
  pushl %edi
801051b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051bb:	5f                   	pop    %edi
  popl %esi
801051bc:	5e                   	pop    %esi
  popl %ebx
801051bd:	5b                   	pop    %ebx
  popl %ebp
801051be:	5d                   	pop    %ebp
  ret
801051bf:	c3                   	ret

801051c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 04             	sub    $0x4,%esp
801051c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051ca:	e8 91 f0 ff ff       	call   80104260 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051cf:	8b 00                	mov    (%eax),%eax
801051d1:	39 c3                	cmp    %eax,%ebx
801051d3:	73 1b                	jae    801051f0 <fetchint+0x30>
801051d5:	8d 53 04             	lea    0x4(%ebx),%edx
801051d8:	39 d0                	cmp    %edx,%eax
801051da:	72 14                	jb     801051f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801051df:	8b 13                	mov    (%ebx),%edx
801051e1:	89 10                	mov    %edx,(%eax)
  return 0;
801051e3:	31 c0                	xor    %eax,%eax
}
801051e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051e8:	c9                   	leave
801051e9:	c3                   	ret
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f5:	eb ee                	jmp    801051e5 <fetchint+0x25>
801051f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fe:	00 
801051ff:	90                   	nop

80105200 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	53                   	push   %ebx
80105204:	83 ec 04             	sub    $0x4,%esp
80105207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010520a:	e8 51 f0 ff ff       	call   80104260 <myproc>

  if(addr >= curproc->sz)
8010520f:	3b 18                	cmp    (%eax),%ebx
80105211:	73 2d                	jae    80105240 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105213:	8b 55 0c             	mov    0xc(%ebp),%edx
80105216:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105218:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010521a:	39 d3                	cmp    %edx,%ebx
8010521c:	73 22                	jae    80105240 <fetchstr+0x40>
8010521e:	89 d8                	mov    %ebx,%eax
80105220:	eb 0d                	jmp    8010522f <fetchstr+0x2f>
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105228:	83 c0 01             	add    $0x1,%eax
8010522b:	39 d0                	cmp    %edx,%eax
8010522d:	73 11                	jae    80105240 <fetchstr+0x40>
    if(*s == 0)
8010522f:	80 38 00             	cmpb   $0x0,(%eax)
80105232:	75 f4                	jne    80105228 <fetchstr+0x28>
      return s - *pp;
80105234:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105236:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105239:	c9                   	leave
8010523a:	c3                   	ret
8010523b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105248:	c9                   	leave
80105249:	c3                   	ret
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105250 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105255:	e8 06 f0 ff ff       	call   80104260 <myproc>
8010525a:	8b 55 08             	mov    0x8(%ebp),%edx
8010525d:	8b 40 18             	mov    0x18(%eax),%eax
80105260:	8b 40 44             	mov    0x44(%eax),%eax
80105263:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105266:	e8 f5 ef ff ff       	call   80104260 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010526b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010526e:	8b 00                	mov    (%eax),%eax
80105270:	39 c6                	cmp    %eax,%esi
80105272:	73 1c                	jae    80105290 <argint+0x40>
80105274:	8d 53 08             	lea    0x8(%ebx),%edx
80105277:	39 d0                	cmp    %edx,%eax
80105279:	72 15                	jb     80105290 <argint+0x40>
  *ip = *(int*)(addr);
8010527b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527e:	8b 53 04             	mov    0x4(%ebx),%edx
80105281:	89 10                	mov    %edx,(%eax)
  return 0;
80105283:	31 c0                	xor    %eax,%eax
}
80105285:	5b                   	pop    %ebx
80105286:	5e                   	pop    %esi
80105287:	5d                   	pop    %ebp
80105288:	c3                   	ret
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105295:	eb ee                	jmp    80105285 <argint+0x35>
80105297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010529e:	00 
8010529f:	90                   	nop

801052a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
801052a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801052a9:	e8 b2 ef ff ff       	call   80104260 <myproc>
801052ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052b0:	e8 ab ef ff ff       	call   80104260 <myproc>
801052b5:	8b 55 08             	mov    0x8(%ebp),%edx
801052b8:	8b 40 18             	mov    0x18(%eax),%eax
801052bb:	8b 40 44             	mov    0x44(%eax),%eax
801052be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801052c1:	e8 9a ef ff ff       	call   80104260 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052c9:	8b 00                	mov    (%eax),%eax
801052cb:	39 c7                	cmp    %eax,%edi
801052cd:	73 31                	jae    80105300 <argptr+0x60>
801052cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801052d2:	39 c8                	cmp    %ecx,%eax
801052d4:	72 2a                	jb     80105300 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801052d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052dc:	85 d2                	test   %edx,%edx
801052de:	78 20                	js     80105300 <argptr+0x60>
801052e0:	8b 16                	mov    (%esi),%edx
801052e2:	39 d0                	cmp    %edx,%eax
801052e4:	73 1a                	jae    80105300 <argptr+0x60>
801052e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801052e9:	01 c3                	add    %eax,%ebx
801052eb:	39 da                	cmp    %ebx,%edx
801052ed:	72 11                	jb     80105300 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801052ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801052f2:	89 02                	mov    %eax,(%edx)
  return 0;
801052f4:	31 c0                	xor    %eax,%eax
}
801052f6:	83 c4 0c             	add    $0xc,%esp
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5f                   	pop    %edi
801052fc:	5d                   	pop    %ebp
801052fd:	c3                   	ret
801052fe:	66 90                	xchg   %ax,%ax
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb ef                	jmp    801052f6 <argptr+0x56>
80105307:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010530e:	00 
8010530f:	90                   	nop

80105310 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105315:	e8 46 ef ff ff       	call   80104260 <myproc>
8010531a:	8b 55 08             	mov    0x8(%ebp),%edx
8010531d:	8b 40 18             	mov    0x18(%eax),%eax
80105320:	8b 40 44             	mov    0x44(%eax),%eax
80105323:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105326:	e8 35 ef ff ff       	call   80104260 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010532b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010532e:	8b 00                	mov    (%eax),%eax
80105330:	39 c6                	cmp    %eax,%esi
80105332:	73 44                	jae    80105378 <argstr+0x68>
80105334:	8d 53 08             	lea    0x8(%ebx),%edx
80105337:	39 d0                	cmp    %edx,%eax
80105339:	72 3d                	jb     80105378 <argstr+0x68>
  *ip = *(int*)(addr);
8010533b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010533e:	e8 1d ef ff ff       	call   80104260 <myproc>
  if(addr >= curproc->sz)
80105343:	3b 18                	cmp    (%eax),%ebx
80105345:	73 31                	jae    80105378 <argstr+0x68>
  *pp = (char*)addr;
80105347:	8b 55 0c             	mov    0xc(%ebp),%edx
8010534a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010534c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010534e:	39 d3                	cmp    %edx,%ebx
80105350:	73 26                	jae    80105378 <argstr+0x68>
80105352:	89 d8                	mov    %ebx,%eax
80105354:	eb 11                	jmp    80105367 <argstr+0x57>
80105356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010535d:	00 
8010535e:	66 90                	xchg   %ax,%ax
80105360:	83 c0 01             	add    $0x1,%eax
80105363:	39 d0                	cmp    %edx,%eax
80105365:	73 11                	jae    80105378 <argstr+0x68>
    if(*s == 0)
80105367:	80 38 00             	cmpb   $0x0,(%eax)
8010536a:	75 f4                	jne    80105360 <argstr+0x50>
      return s - *pp;
8010536c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010536e:	5b                   	pop    %ebx
8010536f:	5e                   	pop    %esi
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret
80105372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105378:	5b                   	pop    %ebx
    return -1;
80105379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537e:	5e                   	pop    %esi
8010537f:	5d                   	pop    %ebp
80105380:	c3                   	ret
80105381:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105388:	00 
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105390 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105397:	e8 c4 ee ff ff       	call   80104260 <myproc>
8010539c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010539e:	8b 40 18             	mov    0x18(%eax),%eax
801053a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a7:	83 fa 14             	cmp    $0x14,%edx
801053aa:	77 24                	ja     801053d0 <syscall+0x40>
801053ac:	8b 14 85 c0 83 10 80 	mov    -0x7fef7c40(,%eax,4),%edx
801053b3:	85 d2                	test   %edx,%edx
801053b5:	74 19                	je     801053d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801053b7:	ff d2                	call   *%edx
801053b9:	89 c2                	mov    %eax,%edx
801053bb:	8b 43 18             	mov    0x18(%ebx),%eax
801053be:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801053c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053c4:	c9                   	leave
801053c5:	c3                   	ret
801053c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053cd:	00 
801053ce:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801053d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801053d1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801053d4:	50                   	push   %eax
801053d5:	ff 73 10             	push   0x10(%ebx)
801053d8:	68 d1 7d 10 80       	push   $0x80107dd1
801053dd:	e8 7e b3 ff ff       	call   80100760 <cprintf>
    curproc->tf->eax = -1;
801053e2:	8b 43 18             	mov    0x18(%ebx),%eax
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053f2:	c9                   	leave
801053f3:	c3                   	ret
801053f4:	66 90                	xchg   %ax,%ax
801053f6:	66 90                	xchg   %ax,%ax
801053f8:	66 90                	xchg   %ax,%ax
801053fa:	66 90                	xchg   %ax,%ax
801053fc:	66 90                	xchg   %ax,%ax
801053fe:	66 90                	xchg   %ax,%ax

80105400 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105405:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105408:	53                   	push   %ebx
80105409:	83 ec 34             	sub    $0x34,%esp
8010540c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010540f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105412:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105415:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105418:	57                   	push   %edi
80105419:	50                   	push   %eax
8010541a:	e8 81 d5 ff ff       	call   801029a0 <nameiparent>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	74 5e                	je     80105484 <create+0x84>
    return 0;
  ilock(dp);
80105426:	83 ec 0c             	sub    $0xc,%esp
80105429:	89 c3                	mov    %eax,%ebx
8010542b:	50                   	push   %eax
8010542c:	e8 6f cc ff ff       	call   801020a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105431:	83 c4 0c             	add    $0xc,%esp
80105434:	6a 00                	push   $0x0
80105436:	57                   	push   %edi
80105437:	53                   	push   %ebx
80105438:	e8 b3 d1 ff ff       	call   801025f0 <dirlookup>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	89 c6                	mov    %eax,%esi
80105442:	85 c0                	test   %eax,%eax
80105444:	74 4a                	je     80105490 <create+0x90>
    iunlockput(dp);
80105446:	83 ec 0c             	sub    $0xc,%esp
80105449:	53                   	push   %ebx
8010544a:	e8 e1 ce ff ff       	call   80102330 <iunlockput>
    ilock(ip);
8010544f:	89 34 24             	mov    %esi,(%esp)
80105452:	e8 49 cc ff ff       	call   801020a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105457:	83 c4 10             	add    $0x10,%esp
8010545a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010545f:	75 17                	jne    80105478 <create+0x78>
80105461:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105466:	75 10                	jne    80105478 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546b:	89 f0                	mov    %esi,%eax
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	56                   	push   %esi
8010547c:	e8 af ce ff ff       	call   80102330 <iunlockput>
    return 0;
80105481:	83 c4 10             	add    $0x10,%esp
}
80105484:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105487:	31 f6                	xor    %esi,%esi
}
80105489:	5b                   	pop    %ebx
8010548a:	89 f0                	mov    %esi,%eax
8010548c:	5e                   	pop    %esi
8010548d:	5f                   	pop    %edi
8010548e:	5d                   	pop    %ebp
8010548f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105490:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105494:	83 ec 08             	sub    $0x8,%esp
80105497:	50                   	push   %eax
80105498:	ff 33                	push   (%ebx)
8010549a:	e8 91 ca ff ff       	call   80101f30 <ialloc>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	89 c6                	mov    %eax,%esi
801054a4:	85 c0                	test   %eax,%eax
801054a6:	0f 84 bc 00 00 00    	je     80105568 <create+0x168>
  ilock(ip);
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	50                   	push   %eax
801054b0:	e8 eb cb ff ff       	call   801020a0 <ilock>
  ip->major = major;
801054b5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801054b9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801054bd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801054c1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801054c5:	b8 01 00 00 00       	mov    $0x1,%eax
801054ca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801054ce:	89 34 24             	mov    %esi,(%esp)
801054d1:	e8 1a cb ff ff       	call   80101ff0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801054de:	74 30                	je     80105510 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801054e0:	83 ec 04             	sub    $0x4,%esp
801054e3:	ff 76 04             	push   0x4(%esi)
801054e6:	57                   	push   %edi
801054e7:	53                   	push   %ebx
801054e8:	e8 d3 d3 ff ff       	call   801028c0 <dirlink>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 67                	js     8010555b <create+0x15b>
  iunlockput(dp);
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	53                   	push   %ebx
801054f8:	e8 33 ce ff ff       	call   80102330 <iunlockput>
  return ip;
801054fd:	83 c4 10             	add    $0x10,%esp
}
80105500:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105503:	89 f0                	mov    %esi,%eax
80105505:	5b                   	pop    %ebx
80105506:	5e                   	pop    %esi
80105507:	5f                   	pop    %edi
80105508:	5d                   	pop    %ebp
80105509:	c3                   	ret
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105510:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105513:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105518:	53                   	push   %ebx
80105519:	e8 d2 ca ff ff       	call   80101ff0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010551e:	83 c4 0c             	add    $0xc,%esp
80105521:	ff 76 04             	push   0x4(%esi)
80105524:	68 09 7e 10 80       	push   $0x80107e09
80105529:	56                   	push   %esi
8010552a:	e8 91 d3 ff ff       	call   801028c0 <dirlink>
8010552f:	83 c4 10             	add    $0x10,%esp
80105532:	85 c0                	test   %eax,%eax
80105534:	78 18                	js     8010554e <create+0x14e>
80105536:	83 ec 04             	sub    $0x4,%esp
80105539:	ff 73 04             	push   0x4(%ebx)
8010553c:	68 08 7e 10 80       	push   $0x80107e08
80105541:	56                   	push   %esi
80105542:	e8 79 d3 ff ff       	call   801028c0 <dirlink>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	85 c0                	test   %eax,%eax
8010554c:	79 92                	jns    801054e0 <create+0xe0>
      panic("create dots");
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	68 fc 7d 10 80       	push   $0x80107dfc
80105556:	e8 15 ae ff ff       	call   80100370 <panic>
    panic("create: dirlink");
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	68 0b 7e 10 80       	push   $0x80107e0b
80105563:	e8 08 ae ff ff       	call   80100370 <panic>
    panic("create: ialloc");
80105568:	83 ec 0c             	sub    $0xc,%esp
8010556b:	68 ed 7d 10 80       	push   $0x80107ded
80105570:	e8 fb ad ff ff       	call   80100370 <panic>
80105575:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010557c:	00 
8010557d:	8d 76 00             	lea    0x0(%esi),%esi

80105580 <sys_dup>:
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	56                   	push   %esi
80105584:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105585:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105588:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010558b:	50                   	push   %eax
8010558c:	6a 00                	push   $0x0
8010558e:	e8 bd fc ff ff       	call   80105250 <argint>
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	78 36                	js     801055d0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010559a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010559e:	77 30                	ja     801055d0 <sys_dup+0x50>
801055a0:	e8 bb ec ff ff       	call   80104260 <myproc>
801055a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055ac:	85 f6                	test   %esi,%esi
801055ae:	74 20                	je     801055d0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801055b0:	e8 ab ec ff ff       	call   80104260 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055b5:	31 db                	xor    %ebx,%ebx
801055b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055be:	00 
801055bf:	90                   	nop
    if(curproc->ofile[fd] == 0){
801055c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	74 18                	je     801055e0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801055c8:	83 c3 01             	add    $0x1,%ebx
801055cb:	83 fb 10             	cmp    $0x10,%ebx
801055ce:	75 f0                	jne    801055c0 <sys_dup+0x40>
}
801055d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055d8:	89 d8                	mov    %ebx,%eax
801055da:	5b                   	pop    %ebx
801055db:	5e                   	pop    %esi
801055dc:	5d                   	pop    %ebp
801055dd:	c3                   	ret
801055de:	66 90                	xchg   %ax,%ax
  filedup(f);
801055e0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055e3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055e7:	56                   	push   %esi
801055e8:	e8 d3 c1 ff ff       	call   801017c0 <filedup>
  return fd;
801055ed:	83 c4 10             	add    $0x10,%esp
}
801055f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f3:	89 d8                	mov    %ebx,%eax
801055f5:	5b                   	pop    %ebx
801055f6:	5e                   	pop    %esi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_read>:
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	56                   	push   %esi
80105604:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105605:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105608:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010560b:	53                   	push   %ebx
8010560c:	6a 00                	push   $0x0
8010560e:	e8 3d fc ff ff       	call   80105250 <argint>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	78 5e                	js     80105678 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010561a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010561e:	77 58                	ja     80105678 <sys_read+0x78>
80105620:	e8 3b ec ff ff       	call   80104260 <myproc>
80105625:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105628:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010562c:	85 f6                	test   %esi,%esi
8010562e:	74 48                	je     80105678 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105636:	50                   	push   %eax
80105637:	6a 02                	push   $0x2
80105639:	e8 12 fc ff ff       	call   80105250 <argint>
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 33                	js     80105678 <sys_read+0x78>
80105645:	83 ec 04             	sub    $0x4,%esp
80105648:	ff 75 f0             	push   -0x10(%ebp)
8010564b:	53                   	push   %ebx
8010564c:	6a 01                	push   $0x1
8010564e:	e8 4d fc ff ff       	call   801052a0 <argptr>
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 1e                	js     80105678 <sys_read+0x78>
  return fileread(f, p, n);
8010565a:	83 ec 04             	sub    $0x4,%esp
8010565d:	ff 75 f0             	push   -0x10(%ebp)
80105660:	ff 75 f4             	push   -0xc(%ebp)
80105663:	56                   	push   %esi
80105664:	e8 d7 c2 ff ff       	call   80101940 <fileread>
80105669:	83 c4 10             	add    $0x10,%esp
}
8010566c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010566f:	5b                   	pop    %ebx
80105670:	5e                   	pop    %esi
80105671:	5d                   	pop    %ebp
80105672:	c3                   	ret
80105673:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105678:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567d:	eb ed                	jmp    8010566c <sys_read+0x6c>
8010567f:	90                   	nop

80105680 <sys_write>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105685:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105688:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010568b:	53                   	push   %ebx
8010568c:	6a 00                	push   $0x0
8010568e:	e8 bd fb ff ff       	call   80105250 <argint>
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	78 5e                	js     801056f8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010569a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010569e:	77 58                	ja     801056f8 <sys_write+0x78>
801056a0:	e8 bb eb ff ff       	call   80104260 <myproc>
801056a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801056ac:	85 f6                	test   %esi,%esi
801056ae:	74 48                	je     801056f8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056b0:	83 ec 08             	sub    $0x8,%esp
801056b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b6:	50                   	push   %eax
801056b7:	6a 02                	push   $0x2
801056b9:	e8 92 fb ff ff       	call   80105250 <argint>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 33                	js     801056f8 <sys_write+0x78>
801056c5:	83 ec 04             	sub    $0x4,%esp
801056c8:	ff 75 f0             	push   -0x10(%ebp)
801056cb:	53                   	push   %ebx
801056cc:	6a 01                	push   $0x1
801056ce:	e8 cd fb ff ff       	call   801052a0 <argptr>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	78 1e                	js     801056f8 <sys_write+0x78>
  return filewrite(f, p, n);
801056da:	83 ec 04             	sub    $0x4,%esp
801056dd:	ff 75 f0             	push   -0x10(%ebp)
801056e0:	ff 75 f4             	push   -0xc(%ebp)
801056e3:	56                   	push   %esi
801056e4:	e8 e7 c2 ff ff       	call   801019d0 <filewrite>
801056e9:	83 c4 10             	add    $0x10,%esp
}
801056ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056ef:	5b                   	pop    %ebx
801056f0:	5e                   	pop    %esi
801056f1:	5d                   	pop    %ebp
801056f2:	c3                   	ret
801056f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801056f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fd:	eb ed                	jmp    801056ec <sys_write+0x6c>
801056ff:	90                   	nop

80105700 <sys_close>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	56                   	push   %esi
80105704:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105705:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105708:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010570b:	50                   	push   %eax
8010570c:	6a 00                	push   $0x0
8010570e:	e8 3d fb ff ff       	call   80105250 <argint>
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	78 3e                	js     80105758 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010571a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010571e:	77 38                	ja     80105758 <sys_close+0x58>
80105720:	e8 3b eb ff ff       	call   80104260 <myproc>
80105725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105728:	8d 5a 08             	lea    0x8(%edx),%ebx
8010572b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010572f:	85 f6                	test   %esi,%esi
80105731:	74 25                	je     80105758 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105733:	e8 28 eb ff ff       	call   80104260 <myproc>
  fileclose(f);
80105738:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010573b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105742:	00 
  fileclose(f);
80105743:	56                   	push   %esi
80105744:	e8 c7 c0 ff ff       	call   80101810 <fileclose>
  return 0;
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	31 c0                	xor    %eax,%eax
}
8010574e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105751:	5b                   	pop    %ebx
80105752:	5e                   	pop    %esi
80105753:	5d                   	pop    %ebp
80105754:	c3                   	ret
80105755:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010575d:	eb ef                	jmp    8010574e <sys_close+0x4e>
8010575f:	90                   	nop

80105760 <sys_fstat>:
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105765:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105768:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010576b:	53                   	push   %ebx
8010576c:	6a 00                	push   $0x0
8010576e:	e8 dd fa ff ff       	call   80105250 <argint>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	78 46                	js     801057c0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010577a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010577e:	77 40                	ja     801057c0 <sys_fstat+0x60>
80105780:	e8 db ea ff ff       	call   80104260 <myproc>
80105785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105788:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010578c:	85 f6                	test   %esi,%esi
8010578e:	74 30                	je     801057c0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	6a 14                	push   $0x14
80105795:	53                   	push   %ebx
80105796:	6a 01                	push   $0x1
80105798:	e8 03 fb ff ff       	call   801052a0 <argptr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 1c                	js     801057c0 <sys_fstat+0x60>
  return filestat(f, st);
801057a4:	83 ec 08             	sub    $0x8,%esp
801057a7:	ff 75 f4             	push   -0xc(%ebp)
801057aa:	56                   	push   %esi
801057ab:	e8 40 c1 ff ff       	call   801018f0 <filestat>
801057b0:	83 c4 10             	add    $0x10,%esp
}
801057b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057b6:	5b                   	pop    %ebx
801057b7:	5e                   	pop    %esi
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c5:	eb ec                	jmp    801057b3 <sys_fstat+0x53>
801057c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ce:	00 
801057cf:	90                   	nop

801057d0 <sys_link>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057d5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801057d8:	53                   	push   %ebx
801057d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801057dc:	50                   	push   %eax
801057dd:	6a 00                	push   $0x0
801057df:	e8 2c fb ff ff       	call   80105310 <argstr>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	0f 88 fb 00 00 00    	js     801058ea <sys_link+0x11a>
801057ef:	83 ec 08             	sub    $0x8,%esp
801057f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057f5:	50                   	push   %eax
801057f6:	6a 01                	push   $0x1
801057f8:	e8 13 fb ff ff       	call   80105310 <argstr>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	0f 88 e2 00 00 00    	js     801058ea <sys_link+0x11a>
  begin_op();
80105808:	e8 33 de ff ff       	call   80103640 <begin_op>
  if((ip = namei(old)) == 0){
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	ff 75 d4             	push   -0x2c(%ebp)
80105813:	e8 68 d1 ff ff       	call   80102980 <namei>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	89 c3                	mov    %eax,%ebx
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 84 df 00 00 00    	je     80105904 <sys_link+0x134>
  ilock(ip);
80105825:	83 ec 0c             	sub    $0xc,%esp
80105828:	50                   	push   %eax
80105829:	e8 72 c8 ff ff       	call   801020a0 <ilock>
  if(ip->type == T_DIR){
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105836:	0f 84 b5 00 00 00    	je     801058f1 <sys_link+0x121>
  iupdate(ip);
8010583c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010583f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105844:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105847:	53                   	push   %ebx
80105848:	e8 a3 c7 ff ff       	call   80101ff0 <iupdate>
  iunlock(ip);
8010584d:	89 1c 24             	mov    %ebx,(%esp)
80105850:	e8 2b c9 ff ff       	call   80102180 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105855:	58                   	pop    %eax
80105856:	5a                   	pop    %edx
80105857:	57                   	push   %edi
80105858:	ff 75 d0             	push   -0x30(%ebp)
8010585b:	e8 40 d1 ff ff       	call   801029a0 <nameiparent>
80105860:	83 c4 10             	add    $0x10,%esp
80105863:	89 c6                	mov    %eax,%esi
80105865:	85 c0                	test   %eax,%eax
80105867:	74 5b                	je     801058c4 <sys_link+0xf4>
  ilock(dp);
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	50                   	push   %eax
8010586d:	e8 2e c8 ff ff       	call   801020a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105872:	8b 03                	mov    (%ebx),%eax
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	39 06                	cmp    %eax,(%esi)
80105879:	75 3d                	jne    801058b8 <sys_link+0xe8>
8010587b:	83 ec 04             	sub    $0x4,%esp
8010587e:	ff 73 04             	push   0x4(%ebx)
80105881:	57                   	push   %edi
80105882:	56                   	push   %esi
80105883:	e8 38 d0 ff ff       	call   801028c0 <dirlink>
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	85 c0                	test   %eax,%eax
8010588d:	78 29                	js     801058b8 <sys_link+0xe8>
  iunlockput(dp);
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	56                   	push   %esi
80105893:	e8 98 ca ff ff       	call   80102330 <iunlockput>
  iput(ip);
80105898:	89 1c 24             	mov    %ebx,(%esp)
8010589b:	e8 30 c9 ff ff       	call   801021d0 <iput>
  end_op();
801058a0:	e8 0b de ff ff       	call   801036b0 <end_op>
  return 0;
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	31 c0                	xor    %eax,%eax
}
801058aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ad:	5b                   	pop    %ebx
801058ae:	5e                   	pop    %esi
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret
801058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	56                   	push   %esi
801058bc:	e8 6f ca ff ff       	call   80102330 <iunlockput>
    goto bad;
801058c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	53                   	push   %ebx
801058c8:	e8 d3 c7 ff ff       	call   801020a0 <ilock>
  ip->nlink--;
801058cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058d2:	89 1c 24             	mov    %ebx,(%esp)
801058d5:	e8 16 c7 ff ff       	call   80101ff0 <iupdate>
  iunlockput(ip);
801058da:	89 1c 24             	mov    %ebx,(%esp)
801058dd:	e8 4e ca ff ff       	call   80102330 <iunlockput>
  end_op();
801058e2:	e8 c9 dd ff ff       	call   801036b0 <end_op>
  return -1;
801058e7:	83 c4 10             	add    $0x10,%esp
    return -1;
801058ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ef:	eb b9                	jmp    801058aa <sys_link+0xda>
    iunlockput(ip);
801058f1:	83 ec 0c             	sub    $0xc,%esp
801058f4:	53                   	push   %ebx
801058f5:	e8 36 ca ff ff       	call   80102330 <iunlockput>
    end_op();
801058fa:	e8 b1 dd ff ff       	call   801036b0 <end_op>
    return -1;
801058ff:	83 c4 10             	add    $0x10,%esp
80105902:	eb e6                	jmp    801058ea <sys_link+0x11a>
    end_op();
80105904:	e8 a7 dd ff ff       	call   801036b0 <end_op>
    return -1;
80105909:	eb df                	jmp    801058ea <sys_link+0x11a>
8010590b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105910 <sys_unlink>:
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105915:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105918:	53                   	push   %ebx
80105919:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010591c:	50                   	push   %eax
8010591d:	6a 00                	push   $0x0
8010591f:	e8 ec f9 ff ff       	call   80105310 <argstr>
80105924:	83 c4 10             	add    $0x10,%esp
80105927:	85 c0                	test   %eax,%eax
80105929:	0f 88 54 01 00 00    	js     80105a83 <sys_unlink+0x173>
  begin_op();
8010592f:	e8 0c dd ff ff       	call   80103640 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105934:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105937:	83 ec 08             	sub    $0x8,%esp
8010593a:	53                   	push   %ebx
8010593b:	ff 75 c0             	push   -0x40(%ebp)
8010593e:	e8 5d d0 ff ff       	call   801029a0 <nameiparent>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105949:	85 c0                	test   %eax,%eax
8010594b:	0f 84 58 01 00 00    	je     80105aa9 <sys_unlink+0x199>
  ilock(dp);
80105951:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105954:	83 ec 0c             	sub    $0xc,%esp
80105957:	57                   	push   %edi
80105958:	e8 43 c7 ff ff       	call   801020a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010595d:	58                   	pop    %eax
8010595e:	5a                   	pop    %edx
8010595f:	68 09 7e 10 80       	push   $0x80107e09
80105964:	53                   	push   %ebx
80105965:	e8 66 cc ff ff       	call   801025d0 <namecmp>
8010596a:	83 c4 10             	add    $0x10,%esp
8010596d:	85 c0                	test   %eax,%eax
8010596f:	0f 84 fb 00 00 00    	je     80105a70 <sys_unlink+0x160>
80105975:	83 ec 08             	sub    $0x8,%esp
80105978:	68 08 7e 10 80       	push   $0x80107e08
8010597d:	53                   	push   %ebx
8010597e:	e8 4d cc ff ff       	call   801025d0 <namecmp>
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	0f 84 e2 00 00 00    	je     80105a70 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010598e:	83 ec 04             	sub    $0x4,%esp
80105991:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105994:	50                   	push   %eax
80105995:	53                   	push   %ebx
80105996:	57                   	push   %edi
80105997:	e8 54 cc ff ff       	call   801025f0 <dirlookup>
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	89 c3                	mov    %eax,%ebx
801059a1:	85 c0                	test   %eax,%eax
801059a3:	0f 84 c7 00 00 00    	je     80105a70 <sys_unlink+0x160>
  ilock(ip);
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	50                   	push   %eax
801059ad:	e8 ee c6 ff ff       	call   801020a0 <ilock>
  if(ip->nlink < 1)
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059ba:	0f 8e 0a 01 00 00    	jle    80105aca <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801059c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801059c8:	74 66                	je     80105a30 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801059ca:	83 ec 04             	sub    $0x4,%esp
801059cd:	6a 10                	push   $0x10
801059cf:	6a 00                	push   $0x0
801059d1:	57                   	push   %edi
801059d2:	e8 c9 f5 ff ff       	call   80104fa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059d7:	6a 10                	push   $0x10
801059d9:	ff 75 c4             	push   -0x3c(%ebp)
801059dc:	57                   	push   %edi
801059dd:	ff 75 b4             	push   -0x4c(%ebp)
801059e0:	e8 cb ca ff ff       	call   801024b0 <writei>
801059e5:	83 c4 20             	add    $0x20,%esp
801059e8:	83 f8 10             	cmp    $0x10,%eax
801059eb:	0f 85 cc 00 00 00    	jne    80105abd <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801059f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059f6:	0f 84 94 00 00 00    	je     80105a90 <sys_unlink+0x180>
  iunlockput(dp);
801059fc:	83 ec 0c             	sub    $0xc,%esp
801059ff:	ff 75 b4             	push   -0x4c(%ebp)
80105a02:	e8 29 c9 ff ff       	call   80102330 <iunlockput>
  ip->nlink--;
80105a07:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a0c:	89 1c 24             	mov    %ebx,(%esp)
80105a0f:	e8 dc c5 ff ff       	call   80101ff0 <iupdate>
  iunlockput(ip);
80105a14:	89 1c 24             	mov    %ebx,(%esp)
80105a17:	e8 14 c9 ff ff       	call   80102330 <iunlockput>
  end_op();
80105a1c:	e8 8f dc ff ff       	call   801036b0 <end_op>
  return 0;
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	31 c0                	xor    %eax,%eax
}
80105a26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a29:	5b                   	pop    %ebx
80105a2a:	5e                   	pop    %esi
80105a2b:	5f                   	pop    %edi
80105a2c:	5d                   	pop    %ebp
80105a2d:	c3                   	ret
80105a2e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a34:	76 94                	jbe    801059ca <sys_unlink+0xba>
80105a36:	be 20 00 00 00       	mov    $0x20,%esi
80105a3b:	eb 0b                	jmp    80105a48 <sys_unlink+0x138>
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
80105a40:	83 c6 10             	add    $0x10,%esi
80105a43:	3b 73 58             	cmp    0x58(%ebx),%esi
80105a46:	73 82                	jae    801059ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a48:	6a 10                	push   $0x10
80105a4a:	56                   	push   %esi
80105a4b:	57                   	push   %edi
80105a4c:	53                   	push   %ebx
80105a4d:	e8 5e c9 ff ff       	call   801023b0 <readi>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	83 f8 10             	cmp    $0x10,%eax
80105a58:	75 56                	jne    80105ab0 <sys_unlink+0x1a0>
    if(de.inum != 0)
80105a5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a5f:	74 df                	je     80105a40 <sys_unlink+0x130>
    iunlockput(ip);
80105a61:	83 ec 0c             	sub    $0xc,%esp
80105a64:	53                   	push   %ebx
80105a65:	e8 c6 c8 ff ff       	call   80102330 <iunlockput>
    goto bad;
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	ff 75 b4             	push   -0x4c(%ebp)
80105a76:	e8 b5 c8 ff ff       	call   80102330 <iunlockput>
  end_op();
80105a7b:	e8 30 dc ff ff       	call   801036b0 <end_op>
  return -1;
80105a80:	83 c4 10             	add    $0x10,%esp
    return -1;
80105a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a88:	eb 9c                	jmp    80105a26 <sys_unlink+0x116>
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105a90:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105a93:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a96:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105a9b:	50                   	push   %eax
80105a9c:	e8 4f c5 ff ff       	call   80101ff0 <iupdate>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	e9 53 ff ff ff       	jmp    801059fc <sys_unlink+0xec>
    end_op();
80105aa9:	e8 02 dc ff ff       	call   801036b0 <end_op>
    return -1;
80105aae:	eb d3                	jmp    80105a83 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	68 2d 7e 10 80       	push   $0x80107e2d
80105ab8:	e8 b3 a8 ff ff       	call   80100370 <panic>
    panic("unlink: writei");
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	68 3f 7e 10 80       	push   $0x80107e3f
80105ac5:	e8 a6 a8 ff ff       	call   80100370 <panic>
    panic("unlink: nlink < 1");
80105aca:	83 ec 0c             	sub    $0xc,%esp
80105acd:	68 1b 7e 10 80       	push   $0x80107e1b
80105ad2:	e8 99 a8 ff ff       	call   80100370 <panic>
80105ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ade:	00 
80105adf:	90                   	nop

80105ae0 <sys_open>:

int
sys_open(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ae5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ae8:	53                   	push   %ebx
80105ae9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aec:	50                   	push   %eax
80105aed:	6a 00                	push   $0x0
80105aef:	e8 1c f8 ff ff       	call   80105310 <argstr>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	85 c0                	test   %eax,%eax
80105af9:	0f 88 8e 00 00 00    	js     80105b8d <sys_open+0xad>
80105aff:	83 ec 08             	sub    $0x8,%esp
80105b02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b05:	50                   	push   %eax
80105b06:	6a 01                	push   $0x1
80105b08:	e8 43 f7 ff ff       	call   80105250 <argint>
80105b0d:	83 c4 10             	add    $0x10,%esp
80105b10:	85 c0                	test   %eax,%eax
80105b12:	78 79                	js     80105b8d <sys_open+0xad>
    return -1;

  begin_op();
80105b14:	e8 27 db ff ff       	call   80103640 <begin_op>

  if(omode & O_CREATE){
80105b19:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b1d:	75 79                	jne    80105b98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b1f:	83 ec 0c             	sub    $0xc,%esp
80105b22:	ff 75 e0             	push   -0x20(%ebp)
80105b25:	e8 56 ce ff ff       	call   80102980 <namei>
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	89 c6                	mov    %eax,%esi
80105b2f:	85 c0                	test   %eax,%eax
80105b31:	0f 84 7e 00 00 00    	je     80105bb5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105b37:	83 ec 0c             	sub    $0xc,%esp
80105b3a:	50                   	push   %eax
80105b3b:	e8 60 c5 ff ff       	call   801020a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b40:	83 c4 10             	add    $0x10,%esp
80105b43:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b48:	0f 84 ba 00 00 00    	je     80105c08 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b4e:	e8 fd bb ff ff       	call   80101750 <filealloc>
80105b53:	89 c7                	mov    %eax,%edi
80105b55:	85 c0                	test   %eax,%eax
80105b57:	74 23                	je     80105b7c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b59:	e8 02 e7 ff ff       	call   80104260 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b5e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b64:	85 d2                	test   %edx,%edx
80105b66:	74 58                	je     80105bc0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105b68:	83 c3 01             	add    $0x1,%ebx
80105b6b:	83 fb 10             	cmp    $0x10,%ebx
80105b6e:	75 f0                	jne    80105b60 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	57                   	push   %edi
80105b74:	e8 97 bc ff ff       	call   80101810 <fileclose>
80105b79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b7c:	83 ec 0c             	sub    $0xc,%esp
80105b7f:	56                   	push   %esi
80105b80:	e8 ab c7 ff ff       	call   80102330 <iunlockput>
    end_op();
80105b85:	e8 26 db ff ff       	call   801036b0 <end_op>
    return -1;
80105b8a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b92:	eb 65                	jmp    80105bf9 <sys_open+0x119>
80105b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	31 c9                	xor    %ecx,%ecx
80105b9d:	ba 02 00 00 00       	mov    $0x2,%edx
80105ba2:	6a 00                	push   $0x0
80105ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ba7:	e8 54 f8 ff ff       	call   80105400 <create>
    if(ip == 0){
80105bac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105baf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105bb1:	85 c0                	test   %eax,%eax
80105bb3:	75 99                	jne    80105b4e <sys_open+0x6e>
      end_op();
80105bb5:	e8 f6 da ff ff       	call   801036b0 <end_op>
      return -1;
80105bba:	eb d1                	jmp    80105b8d <sys_open+0xad>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105bc3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bc7:	56                   	push   %esi
80105bc8:	e8 b3 c5 ff ff       	call   80102180 <iunlock>
  end_op();
80105bcd:	e8 de da ff ff       	call   801036b0 <end_op>

  f->type = FD_INODE;
80105bd2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bdb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bde:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105be1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105be3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bea:	f7 d0                	not    %eax
80105bec:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bef:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bf2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bf5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bfc:	89 d8                	mov    %ebx,%eax
80105bfe:	5b                   	pop    %ebx
80105bff:	5e                   	pop    %esi
80105c00:	5f                   	pop    %edi
80105c01:	5d                   	pop    %ebp
80105c02:	c3                   	ret
80105c03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c0b:	85 c9                	test   %ecx,%ecx
80105c0d:	0f 84 3b ff ff ff    	je     80105b4e <sys_open+0x6e>
80105c13:	e9 64 ff ff ff       	jmp    80105b7c <sys_open+0x9c>
80105c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c1f:	00 

80105c20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c26:	e8 15 da ff ff       	call   80103640 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c2b:	83 ec 08             	sub    $0x8,%esp
80105c2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c31:	50                   	push   %eax
80105c32:	6a 00                	push   $0x0
80105c34:	e8 d7 f6 ff ff       	call   80105310 <argstr>
80105c39:	83 c4 10             	add    $0x10,%esp
80105c3c:	85 c0                	test   %eax,%eax
80105c3e:	78 30                	js     80105c70 <sys_mkdir+0x50>
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c46:	31 c9                	xor    %ecx,%ecx
80105c48:	ba 01 00 00 00       	mov    $0x1,%edx
80105c4d:	6a 00                	push   $0x0
80105c4f:	e8 ac f7 ff ff       	call   80105400 <create>
80105c54:	83 c4 10             	add    $0x10,%esp
80105c57:	85 c0                	test   %eax,%eax
80105c59:	74 15                	je     80105c70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c5b:	83 ec 0c             	sub    $0xc,%esp
80105c5e:	50                   	push   %eax
80105c5f:	e8 cc c6 ff ff       	call   80102330 <iunlockput>
  end_op();
80105c64:	e8 47 da ff ff       	call   801036b0 <end_op>
  return 0;
80105c69:	83 c4 10             	add    $0x10,%esp
80105c6c:	31 c0                	xor    %eax,%eax
}
80105c6e:	c9                   	leave
80105c6f:	c3                   	ret
    end_op();
80105c70:	e8 3b da ff ff       	call   801036b0 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c7a:	c9                   	leave
80105c7b:	c3                   	ret
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_mknod>:

int
sys_mknod(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c86:	e8 b5 d9 ff ff       	call   80103640 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c8b:	83 ec 08             	sub    $0x8,%esp
80105c8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c91:	50                   	push   %eax
80105c92:	6a 00                	push   $0x0
80105c94:	e8 77 f6 ff ff       	call   80105310 <argstr>
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	85 c0                	test   %eax,%eax
80105c9e:	78 60                	js     80105d00 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ca6:	50                   	push   %eax
80105ca7:	6a 01                	push   $0x1
80105ca9:	e8 a2 f5 ff ff       	call   80105250 <argint>
  if((argstr(0, &path)) < 0 ||
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	85 c0                	test   %eax,%eax
80105cb3:	78 4b                	js     80105d00 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105cb5:	83 ec 08             	sub    $0x8,%esp
80105cb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cbb:	50                   	push   %eax
80105cbc:	6a 02                	push   $0x2
80105cbe:	e8 8d f5 ff ff       	call   80105250 <argint>
     argint(1, &major) < 0 ||
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	85 c0                	test   %eax,%eax
80105cc8:	78 36                	js     80105d00 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105cd5:	ba 03 00 00 00       	mov    $0x3,%edx
80105cda:	50                   	push   %eax
80105cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cde:	e8 1d f7 ff ff       	call   80105400 <create>
     argint(2, &minor) < 0 ||
80105ce3:	83 c4 10             	add    $0x10,%esp
80105ce6:	85 c0                	test   %eax,%eax
80105ce8:	74 16                	je     80105d00 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cea:	83 ec 0c             	sub    $0xc,%esp
80105ced:	50                   	push   %eax
80105cee:	e8 3d c6 ff ff       	call   80102330 <iunlockput>
  end_op();
80105cf3:	e8 b8 d9 ff ff       	call   801036b0 <end_op>
  return 0;
80105cf8:	83 c4 10             	add    $0x10,%esp
80105cfb:	31 c0                	xor    %eax,%eax
}
80105cfd:	c9                   	leave
80105cfe:	c3                   	ret
80105cff:	90                   	nop
    end_op();
80105d00:	e8 ab d9 ff ff       	call   801036b0 <end_op>
    return -1;
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d0a:	c9                   	leave
80105d0b:	c3                   	ret
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d10 <sys_chdir>:

int
sys_chdir(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	56                   	push   %esi
80105d14:	53                   	push   %ebx
80105d15:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d18:	e8 43 e5 ff ff       	call   80104260 <myproc>
80105d1d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d1f:	e8 1c d9 ff ff       	call   80103640 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d24:	83 ec 08             	sub    $0x8,%esp
80105d27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 de f5 ff ff       	call   80105310 <argstr>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 77                	js     80105db0 <sys_chdir+0xa0>
80105d39:	83 ec 0c             	sub    $0xc,%esp
80105d3c:	ff 75 f4             	push   -0xc(%ebp)
80105d3f:	e8 3c cc ff ff       	call   80102980 <namei>
80105d44:	83 c4 10             	add    $0x10,%esp
80105d47:	89 c3                	mov    %eax,%ebx
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	74 63                	je     80105db0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	50                   	push   %eax
80105d51:	e8 4a c3 ff ff       	call   801020a0 <ilock>
  if(ip->type != T_DIR){
80105d56:	83 c4 10             	add    $0x10,%esp
80105d59:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d5e:	75 30                	jne    80105d90 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d60:	83 ec 0c             	sub    $0xc,%esp
80105d63:	53                   	push   %ebx
80105d64:	e8 17 c4 ff ff       	call   80102180 <iunlock>
  iput(curproc->cwd);
80105d69:	58                   	pop    %eax
80105d6a:	ff 76 68             	push   0x68(%esi)
80105d6d:	e8 5e c4 ff ff       	call   801021d0 <iput>
  end_op();
80105d72:	e8 39 d9 ff ff       	call   801036b0 <end_op>
  curproc->cwd = ip;
80105d77:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d7a:	83 c4 10             	add    $0x10,%esp
80105d7d:	31 c0                	xor    %eax,%eax
}
80105d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d82:	5b                   	pop    %ebx
80105d83:	5e                   	pop    %esi
80105d84:	5d                   	pop    %ebp
80105d85:	c3                   	ret
80105d86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d8d:	00 
80105d8e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105d90:	83 ec 0c             	sub    $0xc,%esp
80105d93:	53                   	push   %ebx
80105d94:	e8 97 c5 ff ff       	call   80102330 <iunlockput>
    end_op();
80105d99:	e8 12 d9 ff ff       	call   801036b0 <end_op>
    return -1;
80105d9e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da6:	eb d7                	jmp    80105d7f <sys_chdir+0x6f>
80105da8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105daf:	00 
    end_op();
80105db0:	e8 fb d8 ff ff       	call   801036b0 <end_op>
    return -1;
80105db5:	eb ea                	jmp    80105da1 <sys_chdir+0x91>
80105db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbe:	00 
80105dbf:	90                   	nop

80105dc0 <sys_exec>:

int
sys_exec(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	57                   	push   %edi
80105dc4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105dc5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dcb:	53                   	push   %ebx
80105dcc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105dd2:	50                   	push   %eax
80105dd3:	6a 00                	push   $0x0
80105dd5:	e8 36 f5 ff ff       	call   80105310 <argstr>
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	0f 88 87 00 00 00    	js     80105e6c <sys_exec+0xac>
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dee:	50                   	push   %eax
80105def:	6a 01                	push   $0x1
80105df1:	e8 5a f4 ff ff       	call   80105250 <argint>
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	85 c0                	test   %eax,%eax
80105dfb:	78 6f                	js     80105e6c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105dfd:	83 ec 04             	sub    $0x4,%esp
80105e00:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105e06:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e08:	68 80 00 00 00       	push   $0x80
80105e0d:	6a 00                	push   $0x0
80105e0f:	56                   	push   %esi
80105e10:	e8 8b f1 ff ff       	call   80104fa0 <memset>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e1f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e20:	83 ec 08             	sub    $0x8,%esp
80105e23:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105e29:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105e30:	50                   	push   %eax
80105e31:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e37:	01 f8                	add    %edi,%eax
80105e39:	50                   	push   %eax
80105e3a:	e8 81 f3 ff ff       	call   801051c0 <fetchint>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	85 c0                	test   %eax,%eax
80105e44:	78 26                	js     80105e6c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105e46:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e4c:	85 c0                	test   %eax,%eax
80105e4e:	74 30                	je     80105e80 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105e56:	52                   	push   %edx
80105e57:	50                   	push   %eax
80105e58:	e8 a3 f3 ff ff       	call   80105200 <fetchstr>
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	85 c0                	test   %eax,%eax
80105e62:	78 08                	js     80105e6c <sys_exec+0xac>
  for(i=0;; i++){
80105e64:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e67:	83 fb 20             	cmp    $0x20,%ebx
80105e6a:	75 b4                	jne    80105e20 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e74:	5b                   	pop    %ebx
80105e75:	5e                   	pop    %esi
80105e76:	5f                   	pop    %edi
80105e77:	5d                   	pop    %ebp
80105e78:	c3                   	ret
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105e80:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e87:	00 00 00 00 
  return exec(path, argv);
80105e8b:	83 ec 08             	sub    $0x8,%esp
80105e8e:	56                   	push   %esi
80105e8f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105e95:	e8 16 b5 ff ff       	call   801013b0 <exec>
80105e9a:	83 c4 10             	add    $0x10,%esp
}
80105e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea0:	5b                   	pop    %ebx
80105ea1:	5e                   	pop    %esi
80105ea2:	5f                   	pop    %edi
80105ea3:	5d                   	pop    %ebp
80105ea4:	c3                   	ret
80105ea5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105eac:	00 
80105ead:	8d 76 00             	lea    0x0(%esi),%esi

80105eb0 <sys_pipe>:

int
sys_pipe(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105eb5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105eb8:	53                   	push   %ebx
80105eb9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ebc:	6a 08                	push   $0x8
80105ebe:	50                   	push   %eax
80105ebf:	6a 00                	push   $0x0
80105ec1:	e8 da f3 ff ff       	call   801052a0 <argptr>
80105ec6:	83 c4 10             	add    $0x10,%esp
80105ec9:	85 c0                	test   %eax,%eax
80105ecb:	0f 88 8b 00 00 00    	js     80105f5c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ed7:	50                   	push   %eax
80105ed8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105edb:	50                   	push   %eax
80105edc:	e8 2f de ff ff       	call   80103d10 <pipealloc>
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 74                	js     80105f5c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ee8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105eeb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105eed:	e8 6e e3 ff ff       	call   80104260 <myproc>
    if(curproc->ofile[fd] == 0){
80105ef2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ef6:	85 f6                	test   %esi,%esi
80105ef8:	74 16                	je     80105f10 <sys_pipe+0x60>
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f00:	83 c3 01             	add    $0x1,%ebx
80105f03:	83 fb 10             	cmp    $0x10,%ebx
80105f06:	74 3d                	je     80105f45 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105f08:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f0c:	85 f6                	test   %esi,%esi
80105f0e:	75 f0                	jne    80105f00 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105f10:	8d 73 08             	lea    0x8(%ebx),%esi
80105f13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f1a:	e8 41 e3 ff ff       	call   80104260 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f1f:	31 d2                	xor    %edx,%edx
80105f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f28:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f2c:	85 c9                	test   %ecx,%ecx
80105f2e:	74 38                	je     80105f68 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105f30:	83 c2 01             	add    $0x1,%edx
80105f33:	83 fa 10             	cmp    $0x10,%edx
80105f36:	75 f0                	jne    80105f28 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105f38:	e8 23 e3 ff ff       	call   80104260 <myproc>
80105f3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f44:	00 
    fileclose(rf);
80105f45:	83 ec 0c             	sub    $0xc,%esp
80105f48:	ff 75 e0             	push   -0x20(%ebp)
80105f4b:	e8 c0 b8 ff ff       	call   80101810 <fileclose>
    fileclose(wf);
80105f50:	58                   	pop    %eax
80105f51:	ff 75 e4             	push   -0x1c(%ebp)
80105f54:	e8 b7 b8 ff ff       	call   80101810 <fileclose>
    return -1;
80105f59:	83 c4 10             	add    $0x10,%esp
    return -1;
80105f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f61:	eb 16                	jmp    80105f79 <sys_pipe+0xc9>
80105f63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105f68:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f6f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f74:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f77:	31 c0                	xor    %eax,%eax
}
80105f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f7c:	5b                   	pop    %ebx
80105f7d:	5e                   	pop    %esi
80105f7e:	5f                   	pop    %edi
80105f7f:	5d                   	pop    %ebp
80105f80:	c3                   	ret
80105f81:	66 90                	xchg   %ax,%ax
80105f83:	66 90                	xchg   %ax,%ax
80105f85:	66 90                	xchg   %ax,%ax
80105f87:	66 90                	xchg   %ax,%ax
80105f89:	66 90                	xchg   %ax,%ax
80105f8b:	66 90                	xchg   %ax,%ax
80105f8d:	66 90                	xchg   %ax,%ax
80105f8f:	90                   	nop

80105f90 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105f90:	e9 6b e4 ff ff       	jmp    80104400 <fork>
80105f95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f9c:	00 
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi

80105fa0 <sys_exit>:
}

int
sys_exit(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105fa6:	e8 c5 e6 ff ff       	call   80104670 <exit>
  return 0;  // not reached
}
80105fab:	31 c0                	xor    %eax,%eax
80105fad:	c9                   	leave
80105fae:	c3                   	ret
80105faf:	90                   	nop

80105fb0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105fb0:	e9 eb e7 ff ff       	jmp    801047a0 <wait>
80105fb5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fbc:	00 
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi

80105fc0 <sys_kill>:
}

int
sys_kill(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc9:	50                   	push   %eax
80105fca:	6a 00                	push   $0x0
80105fcc:	e8 7f f2 ff ff       	call   80105250 <argint>
80105fd1:	83 c4 10             	add    $0x10,%esp
80105fd4:	85 c0                	test   %eax,%eax
80105fd6:	78 18                	js     80105ff0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fd8:	83 ec 0c             	sub    $0xc,%esp
80105fdb:	ff 75 f4             	push   -0xc(%ebp)
80105fde:	e8 5d ea ff ff       	call   80104a40 <kill>
80105fe3:	83 c4 10             	add    $0x10,%esp
}
80105fe6:	c9                   	leave
80105fe7:	c3                   	ret
80105fe8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fef:	00 
80105ff0:	c9                   	leave
    return -1;
80105ff1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ff6:	c3                   	ret
80105ff7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ffe:	00 
80105fff:	90                   	nop

80106000 <sys_getpid>:

int
sys_getpid(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106006:	e8 55 e2 ff ff       	call   80104260 <myproc>
8010600b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010600e:	c9                   	leave
8010600f:	c3                   	ret

80106010 <sys_sbrk>:

int
sys_sbrk(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106014:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106017:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010601a:	50                   	push   %eax
8010601b:	6a 00                	push   $0x0
8010601d:	e8 2e f2 ff ff       	call   80105250 <argint>
80106022:	83 c4 10             	add    $0x10,%esp
80106025:	85 c0                	test   %eax,%eax
80106027:	78 27                	js     80106050 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106029:	e8 32 e2 ff ff       	call   80104260 <myproc>
  if(growproc(n) < 0)
8010602e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106031:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106033:	ff 75 f4             	push   -0xc(%ebp)
80106036:	e8 45 e3 ff ff       	call   80104380 <growproc>
8010603b:	83 c4 10             	add    $0x10,%esp
8010603e:	85 c0                	test   %eax,%eax
80106040:	78 0e                	js     80106050 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106042:	89 d8                	mov    %ebx,%eax
80106044:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106047:	c9                   	leave
80106048:	c3                   	ret
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106050:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106055:	eb eb                	jmp    80106042 <sys_sbrk+0x32>
80106057:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010605e:	00 
8010605f:	90                   	nop

80106060 <sys_sleep>:

int
sys_sleep(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106064:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106067:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010606a:	50                   	push   %eax
8010606b:	6a 00                	push   $0x0
8010606d:	e8 de f1 ff ff       	call   80105250 <argint>
80106072:	83 c4 10             	add    $0x10,%esp
80106075:	85 c0                	test   %eax,%eax
80106077:	78 64                	js     801060dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80106079:	83 ec 0c             	sub    $0xc,%esp
8010607c:	68 80 4e 11 80       	push   $0x80114e80
80106081:	e8 1a ee ff ff       	call   80104ea0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106089:	8b 1d 60 4e 11 80    	mov    0x80114e60,%ebx
  while(ticks - ticks0 < n){
8010608f:	83 c4 10             	add    $0x10,%esp
80106092:	85 d2                	test   %edx,%edx
80106094:	75 2b                	jne    801060c1 <sys_sleep+0x61>
80106096:	eb 58                	jmp    801060f0 <sys_sleep+0x90>
80106098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010609f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060a0:	83 ec 08             	sub    $0x8,%esp
801060a3:	68 80 4e 11 80       	push   $0x80114e80
801060a8:	68 60 4e 11 80       	push   $0x80114e60
801060ad:	e8 6e e8 ff ff       	call   80104920 <sleep>
  while(ticks - ticks0 < n){
801060b2:	a1 60 4e 11 80       	mov    0x80114e60,%eax
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	29 d8                	sub    %ebx,%eax
801060bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060bf:	73 2f                	jae    801060f0 <sys_sleep+0x90>
    if(myproc()->killed){
801060c1:	e8 9a e1 ff ff       	call   80104260 <myproc>
801060c6:	8b 40 24             	mov    0x24(%eax),%eax
801060c9:	85 c0                	test   %eax,%eax
801060cb:	74 d3                	je     801060a0 <sys_sleep+0x40>
      release(&tickslock);
801060cd:	83 ec 0c             	sub    $0xc,%esp
801060d0:	68 80 4e 11 80       	push   $0x80114e80
801060d5:	e8 66 ed ff ff       	call   80104e40 <release>
      return -1;
801060da:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801060dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801060e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e5:	c9                   	leave
801060e6:	c3                   	ret
801060e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060ee:	00 
801060ef:	90                   	nop
  release(&tickslock);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	68 80 4e 11 80       	push   $0x80114e80
801060f8:	e8 43 ed ff ff       	call   80104e40 <release>
}
801060fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80106100:	83 c4 10             	add    $0x10,%esp
80106103:	31 c0                	xor    %eax,%eax
}
80106105:	c9                   	leave
80106106:	c3                   	ret
80106107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010610e:	00 
8010610f:	90                   	nop

80106110 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	53                   	push   %ebx
80106114:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106117:	68 80 4e 11 80       	push   $0x80114e80
8010611c:	e8 7f ed ff ff       	call   80104ea0 <acquire>
  xticks = ticks;
80106121:	8b 1d 60 4e 11 80    	mov    0x80114e60,%ebx
  release(&tickslock);
80106127:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
8010612e:	e8 0d ed ff ff       	call   80104e40 <release>
  return xticks;
}
80106133:	89 d8                	mov    %ebx,%eax
80106135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106138:	c9                   	leave
80106139:	c3                   	ret

8010613a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010613a:	1e                   	push   %ds
  pushl %es
8010613b:	06                   	push   %es
  pushl %fs
8010613c:	0f a0                	push   %fs
  pushl %gs
8010613e:	0f a8                	push   %gs
  pushal
80106140:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106141:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106145:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106147:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106149:	54                   	push   %esp
  call trap
8010614a:	e8 c1 00 00 00       	call   80106210 <trap>
  addl $4, %esp
8010614f:	83 c4 04             	add    $0x4,%esp

80106152 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106152:	61                   	popa
  popl %gs
80106153:	0f a9                	pop    %gs
  popl %fs
80106155:	0f a1                	pop    %fs
  popl %es
80106157:	07                   	pop    %es
  popl %ds
80106158:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106159:	83 c4 08             	add    $0x8,%esp
  iret
8010615c:	cf                   	iret
8010615d:	66 90                	xchg   %ax,%ax
8010615f:	90                   	nop

80106160 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106160:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106161:	31 c0                	xor    %eax,%eax
{
80106163:	89 e5                	mov    %esp,%ebp
80106165:	83 ec 08             	sub    $0x8,%esp
80106168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010616f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106170:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106177:	c7 04 c5 c2 4e 11 80 	movl   $0x8e000008,-0x7feeb13e(,%eax,8)
8010617e:	08 00 00 8e 
80106182:	66 89 14 c5 c0 4e 11 	mov    %dx,-0x7feeb140(,%eax,8)
80106189:	80 
8010618a:	c1 ea 10             	shr    $0x10,%edx
8010618d:	66 89 14 c5 c6 4e 11 	mov    %dx,-0x7feeb13a(,%eax,8)
80106194:	80 
  for(i = 0; i < 256; i++)
80106195:	83 c0 01             	add    $0x1,%eax
80106198:	3d 00 01 00 00       	cmp    $0x100,%eax
8010619d:	75 d1                	jne    80106170 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010619f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061a2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061a7:	c7 05 c2 50 11 80 08 	movl   $0xef000008,0x801150c2
801061ae:	00 00 ef 
  initlock(&tickslock, "time");
801061b1:	68 4e 7e 10 80       	push   $0x80107e4e
801061b6:	68 80 4e 11 80       	push   $0x80114e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061bb:	66 a3 c0 50 11 80    	mov    %ax,0x801150c0
801061c1:	c1 e8 10             	shr    $0x10,%eax
801061c4:	66 a3 c6 50 11 80    	mov    %ax,0x801150c6
  initlock(&tickslock, "time");
801061ca:	e8 e1 ea ff ff       	call   80104cb0 <initlock>
}
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	c9                   	leave
801061d3:	c3                   	ret
801061d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801061db:	00 
801061dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061e0 <idtinit>:

void
idtinit(void)
{
801061e0:	55                   	push   %ebp
  pd[0] = size-1;
801061e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061e6:	89 e5                	mov    %esp,%ebp
801061e8:	83 ec 10             	sub    $0x10,%esp
801061eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061ef:	b8 c0 4e 11 80       	mov    $0x80114ec0,%eax
801061f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061f8:	c1 e8 10             	shr    $0x10,%eax
801061fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106202:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106205:	c9                   	leave
80106206:	c3                   	ret
80106207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010620e:	00 
8010620f:	90                   	nop

80106210 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	57                   	push   %edi
80106214:	56                   	push   %esi
80106215:	53                   	push   %ebx
80106216:	83 ec 1c             	sub    $0x1c,%esp
80106219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010621c:	8b 43 30             	mov    0x30(%ebx),%eax
8010621f:	83 f8 40             	cmp    $0x40,%eax
80106222:	0f 84 58 01 00 00    	je     80106380 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106228:	83 e8 20             	sub    $0x20,%eax
8010622b:	83 f8 1f             	cmp    $0x1f,%eax
8010622e:	0f 87 7c 00 00 00    	ja     801062b0 <trap+0xa0>
80106234:	ff 24 85 18 84 10 80 	jmp    *-0x7fef7be8(,%eax,4)
8010623b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106240:	e8 eb c8 ff ff       	call   80102b30 <ideintr>
    lapiceoi();
80106245:	e8 a6 cf ff ff       	call   801031f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010624a:	e8 11 e0 ff ff       	call   80104260 <myproc>
8010624f:	85 c0                	test   %eax,%eax
80106251:	74 1a                	je     8010626d <trap+0x5d>
80106253:	e8 08 e0 ff ff       	call   80104260 <myproc>
80106258:	8b 50 24             	mov    0x24(%eax),%edx
8010625b:	85 d2                	test   %edx,%edx
8010625d:	74 0e                	je     8010626d <trap+0x5d>
8010625f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106263:	f7 d0                	not    %eax
80106265:	a8 03                	test   $0x3,%al
80106267:	0f 84 db 01 00 00    	je     80106448 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010626d:	e8 ee df ff ff       	call   80104260 <myproc>
80106272:	85 c0                	test   %eax,%eax
80106274:	74 0f                	je     80106285 <trap+0x75>
80106276:	e8 e5 df ff ff       	call   80104260 <myproc>
8010627b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010627f:	0f 84 ab 00 00 00    	je     80106330 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106285:	e8 d6 df ff ff       	call   80104260 <myproc>
8010628a:	85 c0                	test   %eax,%eax
8010628c:	74 1a                	je     801062a8 <trap+0x98>
8010628e:	e8 cd df ff ff       	call   80104260 <myproc>
80106293:	8b 40 24             	mov    0x24(%eax),%eax
80106296:	85 c0                	test   %eax,%eax
80106298:	74 0e                	je     801062a8 <trap+0x98>
8010629a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010629e:	f7 d0                	not    %eax
801062a0:	a8 03                	test   $0x3,%al
801062a2:	0f 84 05 01 00 00    	je     801063ad <trap+0x19d>
    exit();
}
801062a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062ab:	5b                   	pop    %ebx
801062ac:	5e                   	pop    %esi
801062ad:	5f                   	pop    %edi
801062ae:	5d                   	pop    %ebp
801062af:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
801062b0:	e8 ab df ff ff       	call   80104260 <myproc>
801062b5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062b8:	85 c0                	test   %eax,%eax
801062ba:	0f 84 a2 01 00 00    	je     80106462 <trap+0x252>
801062c0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062c4:	0f 84 98 01 00 00    	je     80106462 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062ca:	0f 20 d1             	mov    %cr2,%ecx
801062cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062d0:	e8 6b df ff ff       	call   80104240 <cpuid>
801062d5:	8b 73 30             	mov    0x30(%ebx),%esi
801062d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062db:	8b 43 34             	mov    0x34(%ebx),%eax
801062de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801062e1:	e8 7a df ff ff       	call   80104260 <myproc>
801062e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062e9:	e8 72 df ff ff       	call   80104260 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062f1:	51                   	push   %ecx
801062f2:	57                   	push   %edi
801062f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062f6:	52                   	push   %edx
801062f7:	ff 75 e4             	push   -0x1c(%ebp)
801062fa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062fb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801062fe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106301:	56                   	push   %esi
80106302:	ff 70 10             	push   0x10(%eax)
80106305:	68 08 81 10 80       	push   $0x80108108
8010630a:	e8 51 a4 ff ff       	call   80100760 <cprintf>
    myproc()->killed = 1;
8010630f:	83 c4 20             	add    $0x20,%esp
80106312:	e8 49 df ff ff       	call   80104260 <myproc>
80106317:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010631e:	e8 3d df ff ff       	call   80104260 <myproc>
80106323:	85 c0                	test   %eax,%eax
80106325:	0f 85 28 ff ff ff    	jne    80106253 <trap+0x43>
8010632b:	e9 3d ff ff ff       	jmp    8010626d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80106330:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106334:	0f 85 4b ff ff ff    	jne    80106285 <trap+0x75>
    yield();
8010633a:	e8 91 e5 ff ff       	call   801048d0 <yield>
8010633f:	e9 41 ff ff ff       	jmp    80106285 <trap+0x75>
80106344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106348:	8b 7b 38             	mov    0x38(%ebx),%edi
8010634b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010634f:	e8 ec de ff ff       	call   80104240 <cpuid>
80106354:	57                   	push   %edi
80106355:	56                   	push   %esi
80106356:	50                   	push   %eax
80106357:	68 b0 80 10 80       	push   $0x801080b0
8010635c:	e8 ff a3 ff ff       	call   80100760 <cprintf>
    lapiceoi();
80106361:	e8 8a ce ff ff       	call   801031f0 <lapiceoi>
    break;
80106366:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106369:	e8 f2 de ff ff       	call   80104260 <myproc>
8010636e:	85 c0                	test   %eax,%eax
80106370:	0f 85 dd fe ff ff    	jne    80106253 <trap+0x43>
80106376:	e9 f2 fe ff ff       	jmp    8010626d <trap+0x5d>
8010637b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106380:	e8 db de ff ff       	call   80104260 <myproc>
80106385:	8b 70 24             	mov    0x24(%eax),%esi
80106388:	85 f6                	test   %esi,%esi
8010638a:	0f 85 c8 00 00 00    	jne    80106458 <trap+0x248>
    myproc()->tf = tf;
80106390:	e8 cb de ff ff       	call   80104260 <myproc>
80106395:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106398:	e8 f3 ef ff ff       	call   80105390 <syscall>
    if(myproc()->killed)
8010639d:	e8 be de ff ff       	call   80104260 <myproc>
801063a2:	8b 48 24             	mov    0x24(%eax),%ecx
801063a5:	85 c9                	test   %ecx,%ecx
801063a7:	0f 84 fb fe ff ff    	je     801062a8 <trap+0x98>
}
801063ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b0:	5b                   	pop    %ebx
801063b1:	5e                   	pop    %esi
801063b2:	5f                   	pop    %edi
801063b3:	5d                   	pop    %ebp
      exit();
801063b4:	e9 b7 e2 ff ff       	jmp    80104670 <exit>
801063b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801063c0:	e8 4b 02 00 00       	call   80106610 <uartintr>
    lapiceoi();
801063c5:	e8 26 ce ff ff       	call   801031f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ca:	e8 91 de ff ff       	call   80104260 <myproc>
801063cf:	85 c0                	test   %eax,%eax
801063d1:	0f 85 7c fe ff ff    	jne    80106253 <trap+0x43>
801063d7:	e9 91 fe ff ff       	jmp    8010626d <trap+0x5d>
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801063e0:	e8 db cc ff ff       	call   801030c0 <kbdintr>
    lapiceoi();
801063e5:	e8 06 ce ff ff       	call   801031f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ea:	e8 71 de ff ff       	call   80104260 <myproc>
801063ef:	85 c0                	test   %eax,%eax
801063f1:	0f 85 5c fe ff ff    	jne    80106253 <trap+0x43>
801063f7:	e9 71 fe ff ff       	jmp    8010626d <trap+0x5d>
801063fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106400:	e8 3b de ff ff       	call   80104240 <cpuid>
80106405:	85 c0                	test   %eax,%eax
80106407:	0f 85 38 fe ff ff    	jne    80106245 <trap+0x35>
      acquire(&tickslock);
8010640d:	83 ec 0c             	sub    $0xc,%esp
80106410:	68 80 4e 11 80       	push   $0x80114e80
80106415:	e8 86 ea ff ff       	call   80104ea0 <acquire>
      ticks++;
8010641a:	83 05 60 4e 11 80 01 	addl   $0x1,0x80114e60
      wakeup(&ticks);
80106421:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80106428:	e8 b3 e5 ff ff       	call   801049e0 <wakeup>
      release(&tickslock);
8010642d:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
80106434:	e8 07 ea ff ff       	call   80104e40 <release>
80106439:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010643c:	e9 04 fe ff ff       	jmp    80106245 <trap+0x35>
80106441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106448:	e8 23 e2 ff ff       	call   80104670 <exit>
8010644d:	e9 1b fe ff ff       	jmp    8010626d <trap+0x5d>
80106452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106458:	e8 13 e2 ff ff       	call   80104670 <exit>
8010645d:	e9 2e ff ff ff       	jmp    80106390 <trap+0x180>
80106462:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106465:	e8 d6 dd ff ff       	call   80104240 <cpuid>
8010646a:	83 ec 0c             	sub    $0xc,%esp
8010646d:	56                   	push   %esi
8010646e:	57                   	push   %edi
8010646f:	50                   	push   %eax
80106470:	ff 73 30             	push   0x30(%ebx)
80106473:	68 d4 80 10 80       	push   $0x801080d4
80106478:	e8 e3 a2 ff ff       	call   80100760 <cprintf>
      panic("trap");
8010647d:	83 c4 14             	add    $0x14,%esp
80106480:	68 53 7e 10 80       	push   $0x80107e53
80106485:	e8 e6 9e ff ff       	call   80100370 <panic>
8010648a:	66 90                	xchg   %ax,%ax
8010648c:	66 90                	xchg   %ax,%ax
8010648e:	66 90                	xchg   %ax,%ax

80106490 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106490:	a1 c0 56 11 80       	mov    0x801156c0,%eax
80106495:	85 c0                	test   %eax,%eax
80106497:	74 17                	je     801064b0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106499:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010649e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010649f:	a8 01                	test   $0x1,%al
801064a1:	74 0d                	je     801064b0 <uartgetc+0x20>
801064a3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064a8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064a9:	0f b6 c0             	movzbl %al,%eax
801064ac:	c3                   	ret
801064ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064b5:	c3                   	ret
801064b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064bd:	00 
801064be:	66 90                	xchg   %ax,%ax

801064c0 <uartinit>:
{
801064c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c1:	31 c9                	xor    %ecx,%ecx
801064c3:	89 c8                	mov    %ecx,%eax
801064c5:	89 e5                	mov    %esp,%ebp
801064c7:	57                   	push   %edi
801064c8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801064cd:	56                   	push   %esi
801064ce:	89 fa                	mov    %edi,%edx
801064d0:	53                   	push   %ebx
801064d1:	83 ec 1c             	sub    $0x1c,%esp
801064d4:	ee                   	out    %al,(%dx)
801064d5:	be fb 03 00 00       	mov    $0x3fb,%esi
801064da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064df:	89 f2                	mov    %esi,%edx
801064e1:	ee                   	out    %al,(%dx)
801064e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ec:	ee                   	out    %al,(%dx)
801064ed:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801064f2:	89 c8                	mov    %ecx,%eax
801064f4:	89 da                	mov    %ebx,%edx
801064f6:	ee                   	out    %al,(%dx)
801064f7:	b8 03 00 00 00       	mov    $0x3,%eax
801064fc:	89 f2                	mov    %esi,%edx
801064fe:	ee                   	out    %al,(%dx)
801064ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106504:	89 c8                	mov    %ecx,%eax
80106506:	ee                   	out    %al,(%dx)
80106507:	b8 01 00 00 00       	mov    $0x1,%eax
8010650c:	89 da                	mov    %ebx,%edx
8010650e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010650f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106514:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106515:	3c ff                	cmp    $0xff,%al
80106517:	0f 84 7c 00 00 00    	je     80106599 <uartinit+0xd9>
  uart = 1;
8010651d:	c7 05 c0 56 11 80 01 	movl   $0x1,0x801156c0
80106524:	00 00 00 
80106527:	89 fa                	mov    %edi,%edx
80106529:	ec                   	in     (%dx),%al
8010652a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010652f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106530:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106533:	bf 58 7e 10 80       	mov    $0x80107e58,%edi
80106538:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010653d:	6a 00                	push   $0x0
8010653f:	6a 04                	push   $0x4
80106541:	e8 1a c8 ff ff       	call   80102d60 <ioapicenable>
80106546:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106549:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010654d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106550:	a1 c0 56 11 80       	mov    0x801156c0,%eax
80106555:	85 c0                	test   %eax,%eax
80106557:	74 32                	je     8010658b <uartinit+0xcb>
80106559:	89 f2                	mov    %esi,%edx
8010655b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010655c:	a8 20                	test   $0x20,%al
8010655e:	75 21                	jne    80106581 <uartinit+0xc1>
80106560:	bb 80 00 00 00       	mov    $0x80,%ebx
80106565:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106568:	83 ec 0c             	sub    $0xc,%esp
8010656b:	6a 0a                	push   $0xa
8010656d:	e8 9e cc ff ff       	call   80103210 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106572:	83 c4 10             	add    $0x10,%esp
80106575:	83 eb 01             	sub    $0x1,%ebx
80106578:	74 07                	je     80106581 <uartinit+0xc1>
8010657a:	89 f2                	mov    %esi,%edx
8010657c:	ec                   	in     (%dx),%al
8010657d:	a8 20                	test   $0x20,%al
8010657f:	74 e7                	je     80106568 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106581:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106586:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010658a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010658b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010658f:	83 c7 01             	add    $0x1,%edi
80106592:	88 45 e7             	mov    %al,-0x19(%ebp)
80106595:	84 c0                	test   %al,%al
80106597:	75 b7                	jne    80106550 <uartinit+0x90>
}
80106599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010659c:	5b                   	pop    %ebx
8010659d:	5e                   	pop    %esi
8010659e:	5f                   	pop    %edi
8010659f:	5d                   	pop    %ebp
801065a0:	c3                   	ret
801065a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065a8:	00 
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065b0 <uartputc>:
  if(!uart)
801065b0:	a1 c0 56 11 80       	mov    0x801156c0,%eax
801065b5:	85 c0                	test   %eax,%eax
801065b7:	74 4f                	je     80106608 <uartputc+0x58>
{
801065b9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065ba:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065bf:	89 e5                	mov    %esp,%ebp
801065c1:	56                   	push   %esi
801065c2:	53                   	push   %ebx
801065c3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065c4:	a8 20                	test   $0x20,%al
801065c6:	75 29                	jne    801065f1 <uartputc+0x41>
801065c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801065cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801065d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801065d8:	83 ec 0c             	sub    $0xc,%esp
801065db:	6a 0a                	push   $0xa
801065dd:	e8 2e cc ff ff       	call   80103210 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065e2:	83 c4 10             	add    $0x10,%esp
801065e5:	83 eb 01             	sub    $0x1,%ebx
801065e8:	74 07                	je     801065f1 <uartputc+0x41>
801065ea:	89 f2                	mov    %esi,%edx
801065ec:	ec                   	in     (%dx),%al
801065ed:	a8 20                	test   $0x20,%al
801065ef:	74 e7                	je     801065d8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065f1:	8b 45 08             	mov    0x8(%ebp),%eax
801065f4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065f9:	ee                   	out    %al,(%dx)
}
801065fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065fd:	5b                   	pop    %ebx
801065fe:	5e                   	pop    %esi
801065ff:	5d                   	pop    %ebp
80106600:	c3                   	ret
80106601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106608:	c3                   	ret
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106610 <uartintr>:

void
uartintr(void)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106616:	68 90 64 10 80       	push   $0x80106490
8010661b:	e8 50 a3 ff ff       	call   80100970 <consoleintr>
}
80106620:	83 c4 10             	add    $0x10,%esp
80106623:	c9                   	leave
80106624:	c3                   	ret

80106625 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $0
80106627:	6a 00                	push   $0x0
  jmp alltraps
80106629:	e9 0c fb ff ff       	jmp    8010613a <alltraps>

8010662e <vector1>:
.globl vector1
vector1:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $1
80106630:	6a 01                	push   $0x1
  jmp alltraps
80106632:	e9 03 fb ff ff       	jmp    8010613a <alltraps>

80106637 <vector2>:
.globl vector2
vector2:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $2
80106639:	6a 02                	push   $0x2
  jmp alltraps
8010663b:	e9 fa fa ff ff       	jmp    8010613a <alltraps>

80106640 <vector3>:
.globl vector3
vector3:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $3
80106642:	6a 03                	push   $0x3
  jmp alltraps
80106644:	e9 f1 fa ff ff       	jmp    8010613a <alltraps>

80106649 <vector4>:
.globl vector4
vector4:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $4
8010664b:	6a 04                	push   $0x4
  jmp alltraps
8010664d:	e9 e8 fa ff ff       	jmp    8010613a <alltraps>

80106652 <vector5>:
.globl vector5
vector5:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $5
80106654:	6a 05                	push   $0x5
  jmp alltraps
80106656:	e9 df fa ff ff       	jmp    8010613a <alltraps>

8010665b <vector6>:
.globl vector6
vector6:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $6
8010665d:	6a 06                	push   $0x6
  jmp alltraps
8010665f:	e9 d6 fa ff ff       	jmp    8010613a <alltraps>

80106664 <vector7>:
.globl vector7
vector7:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $7
80106666:	6a 07                	push   $0x7
  jmp alltraps
80106668:	e9 cd fa ff ff       	jmp    8010613a <alltraps>

8010666d <vector8>:
.globl vector8
vector8:
  pushl $8
8010666d:	6a 08                	push   $0x8
  jmp alltraps
8010666f:	e9 c6 fa ff ff       	jmp    8010613a <alltraps>

80106674 <vector9>:
.globl vector9
vector9:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $9
80106676:	6a 09                	push   $0x9
  jmp alltraps
80106678:	e9 bd fa ff ff       	jmp    8010613a <alltraps>

8010667d <vector10>:
.globl vector10
vector10:
  pushl $10
8010667d:	6a 0a                	push   $0xa
  jmp alltraps
8010667f:	e9 b6 fa ff ff       	jmp    8010613a <alltraps>

80106684 <vector11>:
.globl vector11
vector11:
  pushl $11
80106684:	6a 0b                	push   $0xb
  jmp alltraps
80106686:	e9 af fa ff ff       	jmp    8010613a <alltraps>

8010668b <vector12>:
.globl vector12
vector12:
  pushl $12
8010668b:	6a 0c                	push   $0xc
  jmp alltraps
8010668d:	e9 a8 fa ff ff       	jmp    8010613a <alltraps>

80106692 <vector13>:
.globl vector13
vector13:
  pushl $13
80106692:	6a 0d                	push   $0xd
  jmp alltraps
80106694:	e9 a1 fa ff ff       	jmp    8010613a <alltraps>

80106699 <vector14>:
.globl vector14
vector14:
  pushl $14
80106699:	6a 0e                	push   $0xe
  jmp alltraps
8010669b:	e9 9a fa ff ff       	jmp    8010613a <alltraps>

801066a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $15
801066a2:	6a 0f                	push   $0xf
  jmp alltraps
801066a4:	e9 91 fa ff ff       	jmp    8010613a <alltraps>

801066a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $16
801066ab:	6a 10                	push   $0x10
  jmp alltraps
801066ad:	e9 88 fa ff ff       	jmp    8010613a <alltraps>

801066b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066b2:	6a 11                	push   $0x11
  jmp alltraps
801066b4:	e9 81 fa ff ff       	jmp    8010613a <alltraps>

801066b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $18
801066bb:	6a 12                	push   $0x12
  jmp alltraps
801066bd:	e9 78 fa ff ff       	jmp    8010613a <alltraps>

801066c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $19
801066c4:	6a 13                	push   $0x13
  jmp alltraps
801066c6:	e9 6f fa ff ff       	jmp    8010613a <alltraps>

801066cb <vector20>:
.globl vector20
vector20:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $20
801066cd:	6a 14                	push   $0x14
  jmp alltraps
801066cf:	e9 66 fa ff ff       	jmp    8010613a <alltraps>

801066d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $21
801066d6:	6a 15                	push   $0x15
  jmp alltraps
801066d8:	e9 5d fa ff ff       	jmp    8010613a <alltraps>

801066dd <vector22>:
.globl vector22
vector22:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $22
801066df:	6a 16                	push   $0x16
  jmp alltraps
801066e1:	e9 54 fa ff ff       	jmp    8010613a <alltraps>

801066e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $23
801066e8:	6a 17                	push   $0x17
  jmp alltraps
801066ea:	e9 4b fa ff ff       	jmp    8010613a <alltraps>

801066ef <vector24>:
.globl vector24
vector24:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $24
801066f1:	6a 18                	push   $0x18
  jmp alltraps
801066f3:	e9 42 fa ff ff       	jmp    8010613a <alltraps>

801066f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $25
801066fa:	6a 19                	push   $0x19
  jmp alltraps
801066fc:	e9 39 fa ff ff       	jmp    8010613a <alltraps>

80106701 <vector26>:
.globl vector26
vector26:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $26
80106703:	6a 1a                	push   $0x1a
  jmp alltraps
80106705:	e9 30 fa ff ff       	jmp    8010613a <alltraps>

8010670a <vector27>:
.globl vector27
vector27:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $27
8010670c:	6a 1b                	push   $0x1b
  jmp alltraps
8010670e:	e9 27 fa ff ff       	jmp    8010613a <alltraps>

80106713 <vector28>:
.globl vector28
vector28:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $28
80106715:	6a 1c                	push   $0x1c
  jmp alltraps
80106717:	e9 1e fa ff ff       	jmp    8010613a <alltraps>

8010671c <vector29>:
.globl vector29
vector29:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $29
8010671e:	6a 1d                	push   $0x1d
  jmp alltraps
80106720:	e9 15 fa ff ff       	jmp    8010613a <alltraps>

80106725 <vector30>:
.globl vector30
vector30:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $30
80106727:	6a 1e                	push   $0x1e
  jmp alltraps
80106729:	e9 0c fa ff ff       	jmp    8010613a <alltraps>

8010672e <vector31>:
.globl vector31
vector31:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $31
80106730:	6a 1f                	push   $0x1f
  jmp alltraps
80106732:	e9 03 fa ff ff       	jmp    8010613a <alltraps>

80106737 <vector32>:
.globl vector32
vector32:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $32
80106739:	6a 20                	push   $0x20
  jmp alltraps
8010673b:	e9 fa f9 ff ff       	jmp    8010613a <alltraps>

80106740 <vector33>:
.globl vector33
vector33:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $33
80106742:	6a 21                	push   $0x21
  jmp alltraps
80106744:	e9 f1 f9 ff ff       	jmp    8010613a <alltraps>

80106749 <vector34>:
.globl vector34
vector34:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $34
8010674b:	6a 22                	push   $0x22
  jmp alltraps
8010674d:	e9 e8 f9 ff ff       	jmp    8010613a <alltraps>

80106752 <vector35>:
.globl vector35
vector35:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $35
80106754:	6a 23                	push   $0x23
  jmp alltraps
80106756:	e9 df f9 ff ff       	jmp    8010613a <alltraps>

8010675b <vector36>:
.globl vector36
vector36:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $36
8010675d:	6a 24                	push   $0x24
  jmp alltraps
8010675f:	e9 d6 f9 ff ff       	jmp    8010613a <alltraps>

80106764 <vector37>:
.globl vector37
vector37:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $37
80106766:	6a 25                	push   $0x25
  jmp alltraps
80106768:	e9 cd f9 ff ff       	jmp    8010613a <alltraps>

8010676d <vector38>:
.globl vector38
vector38:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $38
8010676f:	6a 26                	push   $0x26
  jmp alltraps
80106771:	e9 c4 f9 ff ff       	jmp    8010613a <alltraps>

80106776 <vector39>:
.globl vector39
vector39:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $39
80106778:	6a 27                	push   $0x27
  jmp alltraps
8010677a:	e9 bb f9 ff ff       	jmp    8010613a <alltraps>

8010677f <vector40>:
.globl vector40
vector40:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $40
80106781:	6a 28                	push   $0x28
  jmp alltraps
80106783:	e9 b2 f9 ff ff       	jmp    8010613a <alltraps>

80106788 <vector41>:
.globl vector41
vector41:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $41
8010678a:	6a 29                	push   $0x29
  jmp alltraps
8010678c:	e9 a9 f9 ff ff       	jmp    8010613a <alltraps>

80106791 <vector42>:
.globl vector42
vector42:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $42
80106793:	6a 2a                	push   $0x2a
  jmp alltraps
80106795:	e9 a0 f9 ff ff       	jmp    8010613a <alltraps>

8010679a <vector43>:
.globl vector43
vector43:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $43
8010679c:	6a 2b                	push   $0x2b
  jmp alltraps
8010679e:	e9 97 f9 ff ff       	jmp    8010613a <alltraps>

801067a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $44
801067a5:	6a 2c                	push   $0x2c
  jmp alltraps
801067a7:	e9 8e f9 ff ff       	jmp    8010613a <alltraps>

801067ac <vector45>:
.globl vector45
vector45:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $45
801067ae:	6a 2d                	push   $0x2d
  jmp alltraps
801067b0:	e9 85 f9 ff ff       	jmp    8010613a <alltraps>

801067b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $46
801067b7:	6a 2e                	push   $0x2e
  jmp alltraps
801067b9:	e9 7c f9 ff ff       	jmp    8010613a <alltraps>

801067be <vector47>:
.globl vector47
vector47:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $47
801067c0:	6a 2f                	push   $0x2f
  jmp alltraps
801067c2:	e9 73 f9 ff ff       	jmp    8010613a <alltraps>

801067c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $48
801067c9:	6a 30                	push   $0x30
  jmp alltraps
801067cb:	e9 6a f9 ff ff       	jmp    8010613a <alltraps>

801067d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $49
801067d2:	6a 31                	push   $0x31
  jmp alltraps
801067d4:	e9 61 f9 ff ff       	jmp    8010613a <alltraps>

801067d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $50
801067db:	6a 32                	push   $0x32
  jmp alltraps
801067dd:	e9 58 f9 ff ff       	jmp    8010613a <alltraps>

801067e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $51
801067e4:	6a 33                	push   $0x33
  jmp alltraps
801067e6:	e9 4f f9 ff ff       	jmp    8010613a <alltraps>

801067eb <vector52>:
.globl vector52
vector52:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $52
801067ed:	6a 34                	push   $0x34
  jmp alltraps
801067ef:	e9 46 f9 ff ff       	jmp    8010613a <alltraps>

801067f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $53
801067f6:	6a 35                	push   $0x35
  jmp alltraps
801067f8:	e9 3d f9 ff ff       	jmp    8010613a <alltraps>

801067fd <vector54>:
.globl vector54
vector54:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $54
801067ff:	6a 36                	push   $0x36
  jmp alltraps
80106801:	e9 34 f9 ff ff       	jmp    8010613a <alltraps>

80106806 <vector55>:
.globl vector55
vector55:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $55
80106808:	6a 37                	push   $0x37
  jmp alltraps
8010680a:	e9 2b f9 ff ff       	jmp    8010613a <alltraps>

8010680f <vector56>:
.globl vector56
vector56:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $56
80106811:	6a 38                	push   $0x38
  jmp alltraps
80106813:	e9 22 f9 ff ff       	jmp    8010613a <alltraps>

80106818 <vector57>:
.globl vector57
vector57:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $57
8010681a:	6a 39                	push   $0x39
  jmp alltraps
8010681c:	e9 19 f9 ff ff       	jmp    8010613a <alltraps>

80106821 <vector58>:
.globl vector58
vector58:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $58
80106823:	6a 3a                	push   $0x3a
  jmp alltraps
80106825:	e9 10 f9 ff ff       	jmp    8010613a <alltraps>

8010682a <vector59>:
.globl vector59
vector59:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $59
8010682c:	6a 3b                	push   $0x3b
  jmp alltraps
8010682e:	e9 07 f9 ff ff       	jmp    8010613a <alltraps>

80106833 <vector60>:
.globl vector60
vector60:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $60
80106835:	6a 3c                	push   $0x3c
  jmp alltraps
80106837:	e9 fe f8 ff ff       	jmp    8010613a <alltraps>

8010683c <vector61>:
.globl vector61
vector61:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $61
8010683e:	6a 3d                	push   $0x3d
  jmp alltraps
80106840:	e9 f5 f8 ff ff       	jmp    8010613a <alltraps>

80106845 <vector62>:
.globl vector62
vector62:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $62
80106847:	6a 3e                	push   $0x3e
  jmp alltraps
80106849:	e9 ec f8 ff ff       	jmp    8010613a <alltraps>

8010684e <vector63>:
.globl vector63
vector63:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $63
80106850:	6a 3f                	push   $0x3f
  jmp alltraps
80106852:	e9 e3 f8 ff ff       	jmp    8010613a <alltraps>

80106857 <vector64>:
.globl vector64
vector64:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $64
80106859:	6a 40                	push   $0x40
  jmp alltraps
8010685b:	e9 da f8 ff ff       	jmp    8010613a <alltraps>

80106860 <vector65>:
.globl vector65
vector65:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $65
80106862:	6a 41                	push   $0x41
  jmp alltraps
80106864:	e9 d1 f8 ff ff       	jmp    8010613a <alltraps>

80106869 <vector66>:
.globl vector66
vector66:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $66
8010686b:	6a 42                	push   $0x42
  jmp alltraps
8010686d:	e9 c8 f8 ff ff       	jmp    8010613a <alltraps>

80106872 <vector67>:
.globl vector67
vector67:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $67
80106874:	6a 43                	push   $0x43
  jmp alltraps
80106876:	e9 bf f8 ff ff       	jmp    8010613a <alltraps>

8010687b <vector68>:
.globl vector68
vector68:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $68
8010687d:	6a 44                	push   $0x44
  jmp alltraps
8010687f:	e9 b6 f8 ff ff       	jmp    8010613a <alltraps>

80106884 <vector69>:
.globl vector69
vector69:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $69
80106886:	6a 45                	push   $0x45
  jmp alltraps
80106888:	e9 ad f8 ff ff       	jmp    8010613a <alltraps>

8010688d <vector70>:
.globl vector70
vector70:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $70
8010688f:	6a 46                	push   $0x46
  jmp alltraps
80106891:	e9 a4 f8 ff ff       	jmp    8010613a <alltraps>

80106896 <vector71>:
.globl vector71
vector71:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $71
80106898:	6a 47                	push   $0x47
  jmp alltraps
8010689a:	e9 9b f8 ff ff       	jmp    8010613a <alltraps>

8010689f <vector72>:
.globl vector72
vector72:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $72
801068a1:	6a 48                	push   $0x48
  jmp alltraps
801068a3:	e9 92 f8 ff ff       	jmp    8010613a <alltraps>

801068a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068a8:	6a 00                	push   $0x0
  pushl $73
801068aa:	6a 49                	push   $0x49
  jmp alltraps
801068ac:	e9 89 f8 ff ff       	jmp    8010613a <alltraps>

801068b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068b1:	6a 00                	push   $0x0
  pushl $74
801068b3:	6a 4a                	push   $0x4a
  jmp alltraps
801068b5:	e9 80 f8 ff ff       	jmp    8010613a <alltraps>

801068ba <vector75>:
.globl vector75
vector75:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $75
801068bc:	6a 4b                	push   $0x4b
  jmp alltraps
801068be:	e9 77 f8 ff ff       	jmp    8010613a <alltraps>

801068c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $76
801068c5:	6a 4c                	push   $0x4c
  jmp alltraps
801068c7:	e9 6e f8 ff ff       	jmp    8010613a <alltraps>

801068cc <vector77>:
.globl vector77
vector77:
  pushl $0
801068cc:	6a 00                	push   $0x0
  pushl $77
801068ce:	6a 4d                	push   $0x4d
  jmp alltraps
801068d0:	e9 65 f8 ff ff       	jmp    8010613a <alltraps>

801068d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068d5:	6a 00                	push   $0x0
  pushl $78
801068d7:	6a 4e                	push   $0x4e
  jmp alltraps
801068d9:	e9 5c f8 ff ff       	jmp    8010613a <alltraps>

801068de <vector79>:
.globl vector79
vector79:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $79
801068e0:	6a 4f                	push   $0x4f
  jmp alltraps
801068e2:	e9 53 f8 ff ff       	jmp    8010613a <alltraps>

801068e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $80
801068e9:	6a 50                	push   $0x50
  jmp alltraps
801068eb:	e9 4a f8 ff ff       	jmp    8010613a <alltraps>

801068f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068f0:	6a 00                	push   $0x0
  pushl $81
801068f2:	6a 51                	push   $0x51
  jmp alltraps
801068f4:	e9 41 f8 ff ff       	jmp    8010613a <alltraps>

801068f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068f9:	6a 00                	push   $0x0
  pushl $82
801068fb:	6a 52                	push   $0x52
  jmp alltraps
801068fd:	e9 38 f8 ff ff       	jmp    8010613a <alltraps>

80106902 <vector83>:
.globl vector83
vector83:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $83
80106904:	6a 53                	push   $0x53
  jmp alltraps
80106906:	e9 2f f8 ff ff       	jmp    8010613a <alltraps>

8010690b <vector84>:
.globl vector84
vector84:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $84
8010690d:	6a 54                	push   $0x54
  jmp alltraps
8010690f:	e9 26 f8 ff ff       	jmp    8010613a <alltraps>

80106914 <vector85>:
.globl vector85
vector85:
  pushl $0
80106914:	6a 00                	push   $0x0
  pushl $85
80106916:	6a 55                	push   $0x55
  jmp alltraps
80106918:	e9 1d f8 ff ff       	jmp    8010613a <alltraps>

8010691d <vector86>:
.globl vector86
vector86:
  pushl $0
8010691d:	6a 00                	push   $0x0
  pushl $86
8010691f:	6a 56                	push   $0x56
  jmp alltraps
80106921:	e9 14 f8 ff ff       	jmp    8010613a <alltraps>

80106926 <vector87>:
.globl vector87
vector87:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $87
80106928:	6a 57                	push   $0x57
  jmp alltraps
8010692a:	e9 0b f8 ff ff       	jmp    8010613a <alltraps>

8010692f <vector88>:
.globl vector88
vector88:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $88
80106931:	6a 58                	push   $0x58
  jmp alltraps
80106933:	e9 02 f8 ff ff       	jmp    8010613a <alltraps>

80106938 <vector89>:
.globl vector89
vector89:
  pushl $0
80106938:	6a 00                	push   $0x0
  pushl $89
8010693a:	6a 59                	push   $0x59
  jmp alltraps
8010693c:	e9 f9 f7 ff ff       	jmp    8010613a <alltraps>

80106941 <vector90>:
.globl vector90
vector90:
  pushl $0
80106941:	6a 00                	push   $0x0
  pushl $90
80106943:	6a 5a                	push   $0x5a
  jmp alltraps
80106945:	e9 f0 f7 ff ff       	jmp    8010613a <alltraps>

8010694a <vector91>:
.globl vector91
vector91:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $91
8010694c:	6a 5b                	push   $0x5b
  jmp alltraps
8010694e:	e9 e7 f7 ff ff       	jmp    8010613a <alltraps>

80106953 <vector92>:
.globl vector92
vector92:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $92
80106955:	6a 5c                	push   $0x5c
  jmp alltraps
80106957:	e9 de f7 ff ff       	jmp    8010613a <alltraps>

8010695c <vector93>:
.globl vector93
vector93:
  pushl $0
8010695c:	6a 00                	push   $0x0
  pushl $93
8010695e:	6a 5d                	push   $0x5d
  jmp alltraps
80106960:	e9 d5 f7 ff ff       	jmp    8010613a <alltraps>

80106965 <vector94>:
.globl vector94
vector94:
  pushl $0
80106965:	6a 00                	push   $0x0
  pushl $94
80106967:	6a 5e                	push   $0x5e
  jmp alltraps
80106969:	e9 cc f7 ff ff       	jmp    8010613a <alltraps>

8010696e <vector95>:
.globl vector95
vector95:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $95
80106970:	6a 5f                	push   $0x5f
  jmp alltraps
80106972:	e9 c3 f7 ff ff       	jmp    8010613a <alltraps>

80106977 <vector96>:
.globl vector96
vector96:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $96
80106979:	6a 60                	push   $0x60
  jmp alltraps
8010697b:	e9 ba f7 ff ff       	jmp    8010613a <alltraps>

80106980 <vector97>:
.globl vector97
vector97:
  pushl $0
80106980:	6a 00                	push   $0x0
  pushl $97
80106982:	6a 61                	push   $0x61
  jmp alltraps
80106984:	e9 b1 f7 ff ff       	jmp    8010613a <alltraps>

80106989 <vector98>:
.globl vector98
vector98:
  pushl $0
80106989:	6a 00                	push   $0x0
  pushl $98
8010698b:	6a 62                	push   $0x62
  jmp alltraps
8010698d:	e9 a8 f7 ff ff       	jmp    8010613a <alltraps>

80106992 <vector99>:
.globl vector99
vector99:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $99
80106994:	6a 63                	push   $0x63
  jmp alltraps
80106996:	e9 9f f7 ff ff       	jmp    8010613a <alltraps>

8010699b <vector100>:
.globl vector100
vector100:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $100
8010699d:	6a 64                	push   $0x64
  jmp alltraps
8010699f:	e9 96 f7 ff ff       	jmp    8010613a <alltraps>

801069a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069a4:	6a 00                	push   $0x0
  pushl $101
801069a6:	6a 65                	push   $0x65
  jmp alltraps
801069a8:	e9 8d f7 ff ff       	jmp    8010613a <alltraps>

801069ad <vector102>:
.globl vector102
vector102:
  pushl $0
801069ad:	6a 00                	push   $0x0
  pushl $102
801069af:	6a 66                	push   $0x66
  jmp alltraps
801069b1:	e9 84 f7 ff ff       	jmp    8010613a <alltraps>

801069b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $103
801069b8:	6a 67                	push   $0x67
  jmp alltraps
801069ba:	e9 7b f7 ff ff       	jmp    8010613a <alltraps>

801069bf <vector104>:
.globl vector104
vector104:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $104
801069c1:	6a 68                	push   $0x68
  jmp alltraps
801069c3:	e9 72 f7 ff ff       	jmp    8010613a <alltraps>

801069c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069c8:	6a 00                	push   $0x0
  pushl $105
801069ca:	6a 69                	push   $0x69
  jmp alltraps
801069cc:	e9 69 f7 ff ff       	jmp    8010613a <alltraps>

801069d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069d1:	6a 00                	push   $0x0
  pushl $106
801069d3:	6a 6a                	push   $0x6a
  jmp alltraps
801069d5:	e9 60 f7 ff ff       	jmp    8010613a <alltraps>

801069da <vector107>:
.globl vector107
vector107:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $107
801069dc:	6a 6b                	push   $0x6b
  jmp alltraps
801069de:	e9 57 f7 ff ff       	jmp    8010613a <alltraps>

801069e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $108
801069e5:	6a 6c                	push   $0x6c
  jmp alltraps
801069e7:	e9 4e f7 ff ff       	jmp    8010613a <alltraps>

801069ec <vector109>:
.globl vector109
vector109:
  pushl $0
801069ec:	6a 00                	push   $0x0
  pushl $109
801069ee:	6a 6d                	push   $0x6d
  jmp alltraps
801069f0:	e9 45 f7 ff ff       	jmp    8010613a <alltraps>

801069f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069f5:	6a 00                	push   $0x0
  pushl $110
801069f7:	6a 6e                	push   $0x6e
  jmp alltraps
801069f9:	e9 3c f7 ff ff       	jmp    8010613a <alltraps>

801069fe <vector111>:
.globl vector111
vector111:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $111
80106a00:	6a 6f                	push   $0x6f
  jmp alltraps
80106a02:	e9 33 f7 ff ff       	jmp    8010613a <alltraps>

80106a07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $112
80106a09:	6a 70                	push   $0x70
  jmp alltraps
80106a0b:	e9 2a f7 ff ff       	jmp    8010613a <alltraps>

80106a10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a10:	6a 00                	push   $0x0
  pushl $113
80106a12:	6a 71                	push   $0x71
  jmp alltraps
80106a14:	e9 21 f7 ff ff       	jmp    8010613a <alltraps>

80106a19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a19:	6a 00                	push   $0x0
  pushl $114
80106a1b:	6a 72                	push   $0x72
  jmp alltraps
80106a1d:	e9 18 f7 ff ff       	jmp    8010613a <alltraps>

80106a22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $115
80106a24:	6a 73                	push   $0x73
  jmp alltraps
80106a26:	e9 0f f7 ff ff       	jmp    8010613a <alltraps>

80106a2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $116
80106a2d:	6a 74                	push   $0x74
  jmp alltraps
80106a2f:	e9 06 f7 ff ff       	jmp    8010613a <alltraps>

80106a34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $117
80106a36:	6a 75                	push   $0x75
  jmp alltraps
80106a38:	e9 fd f6 ff ff       	jmp    8010613a <alltraps>

80106a3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $118
80106a3f:	6a 76                	push   $0x76
  jmp alltraps
80106a41:	e9 f4 f6 ff ff       	jmp    8010613a <alltraps>

80106a46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $119
80106a48:	6a 77                	push   $0x77
  jmp alltraps
80106a4a:	e9 eb f6 ff ff       	jmp    8010613a <alltraps>

80106a4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $120
80106a51:	6a 78                	push   $0x78
  jmp alltraps
80106a53:	e9 e2 f6 ff ff       	jmp    8010613a <alltraps>

80106a58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $121
80106a5a:	6a 79                	push   $0x79
  jmp alltraps
80106a5c:	e9 d9 f6 ff ff       	jmp    8010613a <alltraps>

80106a61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $122
80106a63:	6a 7a                	push   $0x7a
  jmp alltraps
80106a65:	e9 d0 f6 ff ff       	jmp    8010613a <alltraps>

80106a6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $123
80106a6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a6e:	e9 c7 f6 ff ff       	jmp    8010613a <alltraps>

80106a73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $124
80106a75:	6a 7c                	push   $0x7c
  jmp alltraps
80106a77:	e9 be f6 ff ff       	jmp    8010613a <alltraps>

80106a7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $125
80106a7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a80:	e9 b5 f6 ff ff       	jmp    8010613a <alltraps>

80106a85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $126
80106a87:	6a 7e                	push   $0x7e
  jmp alltraps
80106a89:	e9 ac f6 ff ff       	jmp    8010613a <alltraps>

80106a8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $127
80106a90:	6a 7f                	push   $0x7f
  jmp alltraps
80106a92:	e9 a3 f6 ff ff       	jmp    8010613a <alltraps>

80106a97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $128
80106a99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a9e:	e9 97 f6 ff ff       	jmp    8010613a <alltraps>

80106aa3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $129
80106aa5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aaa:	e9 8b f6 ff ff       	jmp    8010613a <alltraps>

80106aaf <vector130>:
.globl vector130
vector130:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $130
80106ab1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ab6:	e9 7f f6 ff ff       	jmp    8010613a <alltraps>

80106abb <vector131>:
.globl vector131
vector131:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $131
80106abd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ac2:	e9 73 f6 ff ff       	jmp    8010613a <alltraps>

80106ac7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $132
80106ac9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ace:	e9 67 f6 ff ff       	jmp    8010613a <alltraps>

80106ad3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $133
80106ad5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ada:	e9 5b f6 ff ff       	jmp    8010613a <alltraps>

80106adf <vector134>:
.globl vector134
vector134:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $134
80106ae1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ae6:	e9 4f f6 ff ff       	jmp    8010613a <alltraps>

80106aeb <vector135>:
.globl vector135
vector135:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $135
80106aed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106af2:	e9 43 f6 ff ff       	jmp    8010613a <alltraps>

80106af7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $136
80106af9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106afe:	e9 37 f6 ff ff       	jmp    8010613a <alltraps>

80106b03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $137
80106b05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b0a:	e9 2b f6 ff ff       	jmp    8010613a <alltraps>

80106b0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $138
80106b11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b16:	e9 1f f6 ff ff       	jmp    8010613a <alltraps>

80106b1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $139
80106b1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b22:	e9 13 f6 ff ff       	jmp    8010613a <alltraps>

80106b27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $140
80106b29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b2e:	e9 07 f6 ff ff       	jmp    8010613a <alltraps>

80106b33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $141
80106b35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b3a:	e9 fb f5 ff ff       	jmp    8010613a <alltraps>

80106b3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $142
80106b41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b46:	e9 ef f5 ff ff       	jmp    8010613a <alltraps>

80106b4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $143
80106b4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b52:	e9 e3 f5 ff ff       	jmp    8010613a <alltraps>

80106b57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $144
80106b59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b5e:	e9 d7 f5 ff ff       	jmp    8010613a <alltraps>

80106b63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $145
80106b65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b6a:	e9 cb f5 ff ff       	jmp    8010613a <alltraps>

80106b6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $146
80106b71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b76:	e9 bf f5 ff ff       	jmp    8010613a <alltraps>

80106b7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $147
80106b7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b82:	e9 b3 f5 ff ff       	jmp    8010613a <alltraps>

80106b87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $148
80106b89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b8e:	e9 a7 f5 ff ff       	jmp    8010613a <alltraps>

80106b93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $149
80106b95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b9a:	e9 9b f5 ff ff       	jmp    8010613a <alltraps>

80106b9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $150
80106ba1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ba6:	e9 8f f5 ff ff       	jmp    8010613a <alltraps>

80106bab <vector151>:
.globl vector151
vector151:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $151
80106bad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bb2:	e9 83 f5 ff ff       	jmp    8010613a <alltraps>

80106bb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $152
80106bb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bbe:	e9 77 f5 ff ff       	jmp    8010613a <alltraps>

80106bc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $153
80106bc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bca:	e9 6b f5 ff ff       	jmp    8010613a <alltraps>

80106bcf <vector154>:
.globl vector154
vector154:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $154
80106bd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bd6:	e9 5f f5 ff ff       	jmp    8010613a <alltraps>

80106bdb <vector155>:
.globl vector155
vector155:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $155
80106bdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106be2:	e9 53 f5 ff ff       	jmp    8010613a <alltraps>

80106be7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $156
80106be9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bee:	e9 47 f5 ff ff       	jmp    8010613a <alltraps>

80106bf3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $157
80106bf5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bfa:	e9 3b f5 ff ff       	jmp    8010613a <alltraps>

80106bff <vector158>:
.globl vector158
vector158:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $158
80106c01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c06:	e9 2f f5 ff ff       	jmp    8010613a <alltraps>

80106c0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $159
80106c0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c12:	e9 23 f5 ff ff       	jmp    8010613a <alltraps>

80106c17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $160
80106c19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c1e:	e9 17 f5 ff ff       	jmp    8010613a <alltraps>

80106c23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $161
80106c25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c2a:	e9 0b f5 ff ff       	jmp    8010613a <alltraps>

80106c2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $162
80106c31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c36:	e9 ff f4 ff ff       	jmp    8010613a <alltraps>

80106c3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $163
80106c3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c42:	e9 f3 f4 ff ff       	jmp    8010613a <alltraps>

80106c47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $164
80106c49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c4e:	e9 e7 f4 ff ff       	jmp    8010613a <alltraps>

80106c53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $165
80106c55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c5a:	e9 db f4 ff ff       	jmp    8010613a <alltraps>

80106c5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $166
80106c61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c66:	e9 cf f4 ff ff       	jmp    8010613a <alltraps>

80106c6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $167
80106c6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c72:	e9 c3 f4 ff ff       	jmp    8010613a <alltraps>

80106c77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $168
80106c79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c7e:	e9 b7 f4 ff ff       	jmp    8010613a <alltraps>

80106c83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $169
80106c85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c8a:	e9 ab f4 ff ff       	jmp    8010613a <alltraps>

80106c8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $170
80106c91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c96:	e9 9f f4 ff ff       	jmp    8010613a <alltraps>

80106c9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $171
80106c9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ca2:	e9 93 f4 ff ff       	jmp    8010613a <alltraps>

80106ca7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $172
80106ca9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cae:	e9 87 f4 ff ff       	jmp    8010613a <alltraps>

80106cb3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $173
80106cb5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cba:	e9 7b f4 ff ff       	jmp    8010613a <alltraps>

80106cbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $174
80106cc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cc6:	e9 6f f4 ff ff       	jmp    8010613a <alltraps>

80106ccb <vector175>:
.globl vector175
vector175:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $175
80106ccd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cd2:	e9 63 f4 ff ff       	jmp    8010613a <alltraps>

80106cd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $176
80106cd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cde:	e9 57 f4 ff ff       	jmp    8010613a <alltraps>

80106ce3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $177
80106ce5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cea:	e9 4b f4 ff ff       	jmp    8010613a <alltraps>

80106cef <vector178>:
.globl vector178
vector178:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $178
80106cf1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cf6:	e9 3f f4 ff ff       	jmp    8010613a <alltraps>

80106cfb <vector179>:
.globl vector179
vector179:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $179
80106cfd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d02:	e9 33 f4 ff ff       	jmp    8010613a <alltraps>

80106d07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $180
80106d09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d0e:	e9 27 f4 ff ff       	jmp    8010613a <alltraps>

80106d13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $181
80106d15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d1a:	e9 1b f4 ff ff       	jmp    8010613a <alltraps>

80106d1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $182
80106d21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d26:	e9 0f f4 ff ff       	jmp    8010613a <alltraps>

80106d2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $183
80106d2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d32:	e9 03 f4 ff ff       	jmp    8010613a <alltraps>

80106d37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $184
80106d39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d3e:	e9 f7 f3 ff ff       	jmp    8010613a <alltraps>

80106d43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $185
80106d45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d4a:	e9 eb f3 ff ff       	jmp    8010613a <alltraps>

80106d4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $186
80106d51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d56:	e9 df f3 ff ff       	jmp    8010613a <alltraps>

80106d5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $187
80106d5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d62:	e9 d3 f3 ff ff       	jmp    8010613a <alltraps>

80106d67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $188
80106d69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d6e:	e9 c7 f3 ff ff       	jmp    8010613a <alltraps>

80106d73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $189
80106d75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d7a:	e9 bb f3 ff ff       	jmp    8010613a <alltraps>

80106d7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $190
80106d81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d86:	e9 af f3 ff ff       	jmp    8010613a <alltraps>

80106d8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $191
80106d8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d92:	e9 a3 f3 ff ff       	jmp    8010613a <alltraps>

80106d97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $192
80106d99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d9e:	e9 97 f3 ff ff       	jmp    8010613a <alltraps>

80106da3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $193
80106da5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106daa:	e9 8b f3 ff ff       	jmp    8010613a <alltraps>

80106daf <vector194>:
.globl vector194
vector194:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $194
80106db1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106db6:	e9 7f f3 ff ff       	jmp    8010613a <alltraps>

80106dbb <vector195>:
.globl vector195
vector195:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $195
80106dbd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106dc2:	e9 73 f3 ff ff       	jmp    8010613a <alltraps>

80106dc7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $196
80106dc9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dce:	e9 67 f3 ff ff       	jmp    8010613a <alltraps>

80106dd3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $197
80106dd5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dda:	e9 5b f3 ff ff       	jmp    8010613a <alltraps>

80106ddf <vector198>:
.globl vector198
vector198:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $198
80106de1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106de6:	e9 4f f3 ff ff       	jmp    8010613a <alltraps>

80106deb <vector199>:
.globl vector199
vector199:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $199
80106ded:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106df2:	e9 43 f3 ff ff       	jmp    8010613a <alltraps>

80106df7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $200
80106df9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dfe:	e9 37 f3 ff ff       	jmp    8010613a <alltraps>

80106e03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $201
80106e05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e0a:	e9 2b f3 ff ff       	jmp    8010613a <alltraps>

80106e0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $202
80106e11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e16:	e9 1f f3 ff ff       	jmp    8010613a <alltraps>

80106e1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $203
80106e1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e22:	e9 13 f3 ff ff       	jmp    8010613a <alltraps>

80106e27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $204
80106e29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e2e:	e9 07 f3 ff ff       	jmp    8010613a <alltraps>

80106e33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $205
80106e35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e3a:	e9 fb f2 ff ff       	jmp    8010613a <alltraps>

80106e3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $206
80106e41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e46:	e9 ef f2 ff ff       	jmp    8010613a <alltraps>

80106e4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $207
80106e4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e52:	e9 e3 f2 ff ff       	jmp    8010613a <alltraps>

80106e57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $208
80106e59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e5e:	e9 d7 f2 ff ff       	jmp    8010613a <alltraps>

80106e63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $209
80106e65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e6a:	e9 cb f2 ff ff       	jmp    8010613a <alltraps>

80106e6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $210
80106e71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e76:	e9 bf f2 ff ff       	jmp    8010613a <alltraps>

80106e7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $211
80106e7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e82:	e9 b3 f2 ff ff       	jmp    8010613a <alltraps>

80106e87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $212
80106e89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e8e:	e9 a7 f2 ff ff       	jmp    8010613a <alltraps>

80106e93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $213
80106e95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e9a:	e9 9b f2 ff ff       	jmp    8010613a <alltraps>

80106e9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $214
80106ea1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ea6:	e9 8f f2 ff ff       	jmp    8010613a <alltraps>

80106eab <vector215>:
.globl vector215
vector215:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $215
80106ead:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106eb2:	e9 83 f2 ff ff       	jmp    8010613a <alltraps>

80106eb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $216
80106eb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ebe:	e9 77 f2 ff ff       	jmp    8010613a <alltraps>

80106ec3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $217
80106ec5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eca:	e9 6b f2 ff ff       	jmp    8010613a <alltraps>

80106ecf <vector218>:
.globl vector218
vector218:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $218
80106ed1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ed6:	e9 5f f2 ff ff       	jmp    8010613a <alltraps>

80106edb <vector219>:
.globl vector219
vector219:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $219
80106edd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ee2:	e9 53 f2 ff ff       	jmp    8010613a <alltraps>

80106ee7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $220
80106ee9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eee:	e9 47 f2 ff ff       	jmp    8010613a <alltraps>

80106ef3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $221
80106ef5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106efa:	e9 3b f2 ff ff       	jmp    8010613a <alltraps>

80106eff <vector222>:
.globl vector222
vector222:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $222
80106f01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f06:	e9 2f f2 ff ff       	jmp    8010613a <alltraps>

80106f0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $223
80106f0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f12:	e9 23 f2 ff ff       	jmp    8010613a <alltraps>

80106f17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $224
80106f19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f1e:	e9 17 f2 ff ff       	jmp    8010613a <alltraps>

80106f23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $225
80106f25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f2a:	e9 0b f2 ff ff       	jmp    8010613a <alltraps>

80106f2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $226
80106f31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f36:	e9 ff f1 ff ff       	jmp    8010613a <alltraps>

80106f3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $227
80106f3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f42:	e9 f3 f1 ff ff       	jmp    8010613a <alltraps>

80106f47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $228
80106f49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f4e:	e9 e7 f1 ff ff       	jmp    8010613a <alltraps>

80106f53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $229
80106f55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f5a:	e9 db f1 ff ff       	jmp    8010613a <alltraps>

80106f5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $230
80106f61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f66:	e9 cf f1 ff ff       	jmp    8010613a <alltraps>

80106f6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $231
80106f6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f72:	e9 c3 f1 ff ff       	jmp    8010613a <alltraps>

80106f77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $232
80106f79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f7e:	e9 b7 f1 ff ff       	jmp    8010613a <alltraps>

80106f83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $233
80106f85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f8a:	e9 ab f1 ff ff       	jmp    8010613a <alltraps>

80106f8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $234
80106f91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f96:	e9 9f f1 ff ff       	jmp    8010613a <alltraps>

80106f9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $235
80106f9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fa2:	e9 93 f1 ff ff       	jmp    8010613a <alltraps>

80106fa7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $236
80106fa9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fae:	e9 87 f1 ff ff       	jmp    8010613a <alltraps>

80106fb3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $237
80106fb5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fba:	e9 7b f1 ff ff       	jmp    8010613a <alltraps>

80106fbf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $238
80106fc1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fc6:	e9 6f f1 ff ff       	jmp    8010613a <alltraps>

80106fcb <vector239>:
.globl vector239
vector239:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $239
80106fcd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fd2:	e9 63 f1 ff ff       	jmp    8010613a <alltraps>

80106fd7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $240
80106fd9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fde:	e9 57 f1 ff ff       	jmp    8010613a <alltraps>

80106fe3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $241
80106fe5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fea:	e9 4b f1 ff ff       	jmp    8010613a <alltraps>

80106fef <vector242>:
.globl vector242
vector242:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $242
80106ff1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ff6:	e9 3f f1 ff ff       	jmp    8010613a <alltraps>

80106ffb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $243
80106ffd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107002:	e9 33 f1 ff ff       	jmp    8010613a <alltraps>

80107007 <vector244>:
.globl vector244
vector244:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $244
80107009:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010700e:	e9 27 f1 ff ff       	jmp    8010613a <alltraps>

80107013 <vector245>:
.globl vector245
vector245:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $245
80107015:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010701a:	e9 1b f1 ff ff       	jmp    8010613a <alltraps>

8010701f <vector246>:
.globl vector246
vector246:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $246
80107021:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107026:	e9 0f f1 ff ff       	jmp    8010613a <alltraps>

8010702b <vector247>:
.globl vector247
vector247:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $247
8010702d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107032:	e9 03 f1 ff ff       	jmp    8010613a <alltraps>

80107037 <vector248>:
.globl vector248
vector248:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $248
80107039:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010703e:	e9 f7 f0 ff ff       	jmp    8010613a <alltraps>

80107043 <vector249>:
.globl vector249
vector249:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $249
80107045:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010704a:	e9 eb f0 ff ff       	jmp    8010613a <alltraps>

8010704f <vector250>:
.globl vector250
vector250:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $250
80107051:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107056:	e9 df f0 ff ff       	jmp    8010613a <alltraps>

8010705b <vector251>:
.globl vector251
vector251:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $251
8010705d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107062:	e9 d3 f0 ff ff       	jmp    8010613a <alltraps>

80107067 <vector252>:
.globl vector252
vector252:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $252
80107069:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010706e:	e9 c7 f0 ff ff       	jmp    8010613a <alltraps>

80107073 <vector253>:
.globl vector253
vector253:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $253
80107075:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010707a:	e9 bb f0 ff ff       	jmp    8010613a <alltraps>

8010707f <vector254>:
.globl vector254
vector254:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $254
80107081:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107086:	e9 af f0 ff ff       	jmp    8010613a <alltraps>

8010708b <vector255>:
.globl vector255
vector255:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $255
8010708d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107092:	e9 a3 f0 ff ff       	jmp    8010613a <alltraps>
80107097:	66 90                	xchg   %ax,%ax
80107099:	66 90                	xchg   %ax,%ax
8010709b:	66 90                	xchg   %ax,%ax
8010709d:	66 90                	xchg   %ax,%ax
8010709f:	90                   	nop

801070a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070b2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801070b5:	39 d3                	cmp    %edx,%ebx
801070b7:	73 56                	jae    8010710f <deallocuvm.part.0+0x6f>
801070b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801070bc:	89 c6                	mov    %eax,%esi
801070be:	89 d7                	mov    %edx,%edi
801070c0:	eb 12                	jmp    801070d4 <deallocuvm.part.0+0x34>
801070c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070c8:	83 c2 01             	add    $0x1,%edx
801070cb:	89 d3                	mov    %edx,%ebx
801070cd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070d0:	39 fb                	cmp    %edi,%ebx
801070d2:	73 38                	jae    8010710c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801070d4:	89 da                	mov    %ebx,%edx
801070d6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801070d9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801070dc:	a8 01                	test   $0x1,%al
801070de:	74 e8                	je     801070c8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801070e0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070e7:	c1 e9 0a             	shr    $0xa,%ecx
801070ea:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801070f0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801070f7:	85 c0                	test   %eax,%eax
801070f9:	74 cd                	je     801070c8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801070fb:	8b 10                	mov    (%eax),%edx
801070fd:	f6 c2 01             	test   $0x1,%dl
80107100:	75 1e                	jne    80107120 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80107102:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107108:	39 fb                	cmp    %edi,%ebx
8010710a:	72 c8                	jb     801070d4 <deallocuvm.part.0+0x34>
8010710c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
8010710f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107112:	89 c8                	mov    %ecx,%eax
80107114:	5b                   	pop    %ebx
80107115:	5e                   	pop    %esi
80107116:	5f                   	pop    %edi
80107117:	5d                   	pop    %ebp
80107118:	c3                   	ret
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80107120:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107126:	74 26                	je     8010714e <deallocuvm.part.0+0xae>
      kfree(v);
80107128:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010712b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107134:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010713a:	52                   	push   %edx
8010713b:	e8 60 bc ff ff       	call   80102da0 <kfree>
      *pte = 0;
80107140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80107143:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107146:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010714c:	eb 82                	jmp    801070d0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010714e:	83 ec 0c             	sub    $0xc,%esp
80107151:	68 2c 7c 10 80       	push   $0x80107c2c
80107156:	e8 15 92 ff ff       	call   80100370 <panic>
8010715b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107160 <mappages>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107166:	89 d3                	mov    %edx,%ebx
80107168:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010716e:	83 ec 1c             	sub    $0x1c,%esp
80107171:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107174:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010717d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107180:	8b 45 08             	mov    0x8(%ebp),%eax
80107183:	29 d8                	sub    %ebx,%eax
80107185:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107188:	eb 3f                	jmp    801071c9 <mappages+0x69>
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107190:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107197:	c1 ea 0a             	shr    $0xa,%edx
8010719a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071a7:	85 c0                	test   %eax,%eax
801071a9:	74 75                	je     80107220 <mappages+0xc0>
    if(*pte & PTE_P)
801071ab:	f6 00 01             	testb  $0x1,(%eax)
801071ae:	0f 85 86 00 00 00    	jne    8010723a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071b4:	0b 75 0c             	or     0xc(%ebp),%esi
801071b7:	83 ce 01             	or     $0x1,%esi
801071ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801071bf:	39 c3                	cmp    %eax,%ebx
801071c1:	74 6d                	je     80107230 <mappages+0xd0>
    a += PGSIZE;
801071c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801071cf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801071d2:	89 d8                	mov    %ebx,%eax
801071d4:	c1 e8 16             	shr    $0x16,%eax
801071d7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071da:	8b 07                	mov    (%edi),%eax
801071dc:	a8 01                	test   $0x1,%al
801071de:	75 b0                	jne    80107190 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071e0:	e8 7b bd ff ff       	call   80102f60 <kalloc>
801071e5:	85 c0                	test   %eax,%eax
801071e7:	74 37                	je     80107220 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071e9:	83 ec 04             	sub    $0x4,%esp
801071ec:	68 00 10 00 00       	push   $0x1000
801071f1:	6a 00                	push   $0x0
801071f3:	50                   	push   %eax
801071f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801071f7:	e8 a4 dd ff ff       	call   80104fa0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801071ff:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107202:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107208:	83 c8 07             	or     $0x7,%eax
8010720b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010720d:	89 d8                	mov    %ebx,%eax
8010720f:	c1 e8 0a             	shr    $0xa,%eax
80107212:	25 fc 0f 00 00       	and    $0xffc,%eax
80107217:	01 d0                	add    %edx,%eax
80107219:	eb 90                	jmp    801071ab <mappages+0x4b>
8010721b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80107220:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107228:	5b                   	pop    %ebx
80107229:	5e                   	pop    %esi
8010722a:	5f                   	pop    %edi
8010722b:	5d                   	pop    %ebp
8010722c:	c3                   	ret
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret
      panic("remap");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 60 7e 10 80       	push   $0x80107e60
80107242:	e8 29 91 ff ff       	call   80100370 <panic>
80107247:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010724e:	00 
8010724f:	90                   	nop

80107250 <seginit>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107256:	e8 e5 cf ff ff       	call   80104240 <cpuid>
  pd[0] = size-1;
8010725b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107260:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107266:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010726a:	c7 80 18 2a 11 80 ff 	movl   $0xffff,-0x7feed5e8(%eax)
80107271:	ff 00 00 
80107274:	c7 80 1c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed5e4(%eax)
8010727b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010727e:	c7 80 20 2a 11 80 ff 	movl   $0xffff,-0x7feed5e0(%eax)
80107285:	ff 00 00 
80107288:	c7 80 24 2a 11 80 00 	movl   $0xcf9200,-0x7feed5dc(%eax)
8010728f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107292:	c7 80 28 2a 11 80 ff 	movl   $0xffff,-0x7feed5d8(%eax)
80107299:	ff 00 00 
8010729c:	c7 80 2c 2a 11 80 00 	movl   $0xcffa00,-0x7feed5d4(%eax)
801072a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072a6:	c7 80 30 2a 11 80 ff 	movl   $0xffff,-0x7feed5d0(%eax)
801072ad:	ff 00 00 
801072b0:	c7 80 34 2a 11 80 00 	movl   $0xcff200,-0x7feed5cc(%eax)
801072b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ba:	05 10 2a 11 80       	add    $0x80112a10,%eax
  pd[1] = (uint)p;
801072bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072c3:	c1 e8 10             	shr    $0x10,%eax
801072c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072cd:	0f 01 10             	lgdtl  (%eax)
}
801072d0:	c9                   	leave
801072d1:	c3                   	ret
801072d2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072d9:	00 
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e0:	a1 c4 56 11 80       	mov    0x801156c4,%eax
801072e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ea:	0f 22 d8             	mov    %eax,%cr3
}
801072ed:	c3                   	ret
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <switchuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
801072f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801072fc:	85 f6                	test   %esi,%esi
801072fe:	0f 84 cb 00 00 00    	je     801073cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107304:	8b 46 08             	mov    0x8(%esi),%eax
80107307:	85 c0                	test   %eax,%eax
80107309:	0f 84 da 00 00 00    	je     801073e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010730f:	8b 46 04             	mov    0x4(%esi),%eax
80107312:	85 c0                	test   %eax,%eax
80107314:	0f 84 c2 00 00 00    	je     801073dc <switchuvm+0xec>
  pushcli();
8010731a:	e8 31 da ff ff       	call   80104d50 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010731f:	e8 bc ce ff ff       	call   801041e0 <mycpu>
80107324:	89 c3                	mov    %eax,%ebx
80107326:	e8 b5 ce ff ff       	call   801041e0 <mycpu>
8010732b:	89 c7                	mov    %eax,%edi
8010732d:	e8 ae ce ff ff       	call   801041e0 <mycpu>
80107332:	83 c7 08             	add    $0x8,%edi
80107335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107338:	e8 a3 ce ff ff       	call   801041e0 <mycpu>
8010733d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107340:	ba 67 00 00 00       	mov    $0x67,%edx
80107345:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010734c:	83 c0 08             	add    $0x8,%eax
8010734f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107356:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735b:	83 c1 08             	add    $0x8,%ecx
8010735e:	c1 e8 18             	shr    $0x18,%eax
80107361:	c1 e9 10             	shr    $0x10,%ecx
80107364:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010736a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107370:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107375:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010737c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107381:	e8 5a ce ff ff       	call   801041e0 <mycpu>
80107386:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010738d:	e8 4e ce ff ff       	call   801041e0 <mycpu>
80107392:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107396:	8b 5e 08             	mov    0x8(%esi),%ebx
80107399:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010739f:	e8 3c ce ff ff       	call   801041e0 <mycpu>
801073a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073a7:	e8 34 ce ff ff       	call   801041e0 <mycpu>
801073ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073b0:	b8 28 00 00 00       	mov    $0x28,%eax
801073b5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073b8:	8b 46 04             	mov    0x4(%esi),%eax
801073bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073c0:	0f 22 d8             	mov    %eax,%cr3
}
801073c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c6:	5b                   	pop    %ebx
801073c7:	5e                   	pop    %esi
801073c8:	5f                   	pop    %edi
801073c9:	5d                   	pop    %ebp
  popcli();
801073ca:	e9 d1 d9 ff ff       	jmp    80104da0 <popcli>
    panic("switchuvm: no process");
801073cf:	83 ec 0c             	sub    $0xc,%esp
801073d2:	68 66 7e 10 80       	push   $0x80107e66
801073d7:	e8 94 8f ff ff       	call   80100370 <panic>
    panic("switchuvm: no pgdir");
801073dc:	83 ec 0c             	sub    $0xc,%esp
801073df:	68 91 7e 10 80       	push   $0x80107e91
801073e4:	e8 87 8f ff ff       	call   80100370 <panic>
    panic("switchuvm: no kstack");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 7c 7e 10 80       	push   $0x80107e7c
801073f1:	e8 7a 8f ff ff       	call   80100370 <panic>
801073f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073fd:	00 
801073fe:	66 90                	xchg   %ax,%ax

80107400 <inituvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
80107409:	8b 45 08             	mov    0x8(%ebp),%eax
8010740c:	8b 75 10             	mov    0x10(%ebp),%esi
8010740f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107415:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010741b:	77 49                	ja     80107466 <inituvm+0x66>
  mem = kalloc();
8010741d:	e8 3e bb ff ff       	call   80102f60 <kalloc>
  memset(mem, 0, PGSIZE);
80107422:	83 ec 04             	sub    $0x4,%esp
80107425:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010742a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010742c:	6a 00                	push   $0x0
8010742e:	50                   	push   %eax
8010742f:	e8 6c db ff ff       	call   80104fa0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107434:	58                   	pop    %eax
80107435:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010743b:	5a                   	pop    %edx
8010743c:	6a 06                	push   $0x6
8010743e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107443:	31 d2                	xor    %edx,%edx
80107445:	50                   	push   %eax
80107446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107449:	e8 12 fd ff ff       	call   80107160 <mappages>
  memmove(mem, init, sz);
8010744e:	83 c4 10             	add    $0x10,%esp
80107451:	89 75 10             	mov    %esi,0x10(%ebp)
80107454:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107457:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010745a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010745d:	5b                   	pop    %ebx
8010745e:	5e                   	pop    %esi
8010745f:	5f                   	pop    %edi
80107460:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107461:	e9 ca db ff ff       	jmp    80105030 <memmove>
    panic("inituvm: more than a page");
80107466:	83 ec 0c             	sub    $0xc,%esp
80107469:	68 a5 7e 10 80       	push   $0x80107ea5
8010746e:	e8 fd 8e ff ff       	call   80100370 <panic>
80107473:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010747a:	00 
8010747b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107480 <loaduvm>:
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107489:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010748c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010748f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107495:	0f 85 a2 00 00 00    	jne    8010753d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010749b:	85 ff                	test   %edi,%edi
8010749d:	74 7d                	je     8010751c <loaduvm+0x9c>
8010749f:	90                   	nop
  pde = &pgdir[PDX(va)];
801074a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801074a3:	8b 55 08             	mov    0x8(%ebp),%edx
801074a6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
801074a8:	89 c1                	mov    %eax,%ecx
801074aa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801074ad:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
801074b0:	f6 c1 01             	test   $0x1,%cl
801074b3:	75 13                	jne    801074c8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
801074b5:	83 ec 0c             	sub    $0xc,%esp
801074b8:	68 bf 7e 10 80       	push   $0x80107ebf
801074bd:	e8 ae 8e ff ff       	call   80100370 <panic>
801074c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074c8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074cb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074d1:	25 fc 0f 00 00       	and    $0xffc,%eax
801074d6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074dd:	85 c9                	test   %ecx,%ecx
801074df:	74 d4                	je     801074b5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
801074e1:	89 fb                	mov    %edi,%ebx
801074e3:	b8 00 10 00 00       	mov    $0x1000,%eax
801074e8:	29 f3                	sub    %esi,%ebx
801074ea:	39 c3                	cmp    %eax,%ebx
801074ec:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074ef:	53                   	push   %ebx
801074f0:	8b 45 14             	mov    0x14(%ebp),%eax
801074f3:	01 f0                	add    %esi,%eax
801074f5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
801074f6:	8b 01                	mov    (%ecx),%eax
801074f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074fd:	05 00 00 00 80       	add    $0x80000000,%eax
80107502:	50                   	push   %eax
80107503:	ff 75 10             	push   0x10(%ebp)
80107506:	e8 a5 ae ff ff       	call   801023b0 <readi>
8010750b:	83 c4 10             	add    $0x10,%esp
8010750e:	39 d8                	cmp    %ebx,%eax
80107510:	75 1e                	jne    80107530 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107512:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107518:	39 fe                	cmp    %edi,%esi
8010751a:	72 84                	jb     801074a0 <loaduvm+0x20>
}
8010751c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010751f:	31 c0                	xor    %eax,%eax
}
80107521:	5b                   	pop    %ebx
80107522:	5e                   	pop    %esi
80107523:	5f                   	pop    %edi
80107524:	5d                   	pop    %ebp
80107525:	c3                   	ret
80107526:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010752d:	00 
8010752e:	66 90                	xchg   %ax,%ax
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107538:	5b                   	pop    %ebx
80107539:	5e                   	pop    %esi
8010753a:	5f                   	pop    %edi
8010753b:	5d                   	pop    %ebp
8010753c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010753d:	83 ec 0c             	sub    $0xc,%esp
80107540:	68 4c 81 10 80       	push   $0x8010814c
80107545:	e8 26 8e ff ff       	call   80100370 <panic>
8010754a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107550 <allocuvm>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	57                   	push   %edi
80107554:	56                   	push   %esi
80107555:	53                   	push   %ebx
80107556:	83 ec 1c             	sub    $0x1c,%esp
80107559:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010755c:	85 f6                	test   %esi,%esi
8010755e:	0f 88 98 00 00 00    	js     801075fc <allocuvm+0xac>
80107564:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107566:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107569:	0f 82 a1 00 00 00    	jb     80107610 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010756f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107572:	05 ff 0f 00 00       	add    $0xfff,%eax
80107577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010757c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010757e:	39 f0                	cmp    %esi,%eax
80107580:	0f 83 8d 00 00 00    	jae    80107613 <allocuvm+0xc3>
80107586:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107589:	eb 44                	jmp    801075cf <allocuvm+0x7f>
8010758b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	68 00 10 00 00       	push   $0x1000
80107598:	6a 00                	push   $0x0
8010759a:	50                   	push   %eax
8010759b:	e8 00 da ff ff       	call   80104fa0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075a0:	58                   	pop    %eax
801075a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075a7:	5a                   	pop    %edx
801075a8:	6a 06                	push   $0x6
801075aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075af:	89 fa                	mov    %edi,%edx
801075b1:	50                   	push   %eax
801075b2:	8b 45 08             	mov    0x8(%ebp),%eax
801075b5:	e8 a6 fb ff ff       	call   80107160 <mappages>
801075ba:	83 c4 10             	add    $0x10,%esp
801075bd:	85 c0                	test   %eax,%eax
801075bf:	78 5f                	js     80107620 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801075c1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075c7:	39 f7                	cmp    %esi,%edi
801075c9:	0f 83 89 00 00 00    	jae    80107658 <allocuvm+0x108>
    mem = kalloc();
801075cf:	e8 8c b9 ff ff       	call   80102f60 <kalloc>
801075d4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075d6:	85 c0                	test   %eax,%eax
801075d8:	75 b6                	jne    80107590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	68 dd 7e 10 80       	push   $0x80107edd
801075e2:	e8 79 91 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
801075e7:	83 c4 10             	add    $0x10,%esp
801075ea:	3b 75 0c             	cmp    0xc(%ebp),%esi
801075ed:	74 0d                	je     801075fc <allocuvm+0xac>
801075ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075f2:	8b 45 08             	mov    0x8(%ebp),%eax
801075f5:	89 f2                	mov    %esi,%edx
801075f7:	e8 a4 fa ff ff       	call   801070a0 <deallocuvm.part.0>
    return 0;
801075fc:	31 d2                	xor    %edx,%edx
}
801075fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107601:	89 d0                	mov    %edx,%eax
80107603:	5b                   	pop    %ebx
80107604:	5e                   	pop    %esi
80107605:	5f                   	pop    %edi
80107606:	5d                   	pop    %ebp
80107607:	c3                   	ret
80107608:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010760f:	00 
    return oldsz;
80107610:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107613:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107616:	89 d0                	mov    %edx,%eax
80107618:	5b                   	pop    %ebx
80107619:	5e                   	pop    %esi
8010761a:	5f                   	pop    %edi
8010761b:	5d                   	pop    %ebp
8010761c:	c3                   	ret
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107620:	83 ec 0c             	sub    $0xc,%esp
80107623:	68 f5 7e 10 80       	push   $0x80107ef5
80107628:	e8 33 91 ff ff       	call   80100760 <cprintf>
  if(newsz >= oldsz)
8010762d:	83 c4 10             	add    $0x10,%esp
80107630:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107633:	74 0d                	je     80107642 <allocuvm+0xf2>
80107635:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107638:	8b 45 08             	mov    0x8(%ebp),%eax
8010763b:	89 f2                	mov    %esi,%edx
8010763d:	e8 5e fa ff ff       	call   801070a0 <deallocuvm.part.0>
      kfree(mem);
80107642:	83 ec 0c             	sub    $0xc,%esp
80107645:	53                   	push   %ebx
80107646:	e8 55 b7 ff ff       	call   80102da0 <kfree>
      return 0;
8010764b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010764e:	31 d2                	xor    %edx,%edx
80107650:	eb ac                	jmp    801075fe <allocuvm+0xae>
80107652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107658:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010765b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765e:	5b                   	pop    %ebx
8010765f:	5e                   	pop    %esi
80107660:	89 d0                	mov    %edx,%eax
80107662:	5f                   	pop    %edi
80107663:	5d                   	pop    %ebp
80107664:	c3                   	ret
80107665:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010766c:	00 
8010766d:	8d 76 00             	lea    0x0(%esi),%esi

80107670 <deallocuvm>:
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	8b 55 0c             	mov    0xc(%ebp),%edx
80107676:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107679:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010767c:	39 d1                	cmp    %edx,%ecx
8010767e:	73 10                	jae    80107690 <deallocuvm+0x20>
}
80107680:	5d                   	pop    %ebp
80107681:	e9 1a fa ff ff       	jmp    801070a0 <deallocuvm.part.0>
80107686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010768d:	00 
8010768e:	66 90                	xchg   %ax,%ax
80107690:	89 d0                	mov    %edx,%eax
80107692:	5d                   	pop    %ebp
80107693:	c3                   	ret
80107694:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010769b:	00 
8010769c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076ac:	85 f6                	test   %esi,%esi
801076ae:	74 59                	je     80107709 <freevm+0x69>
  if(newsz >= oldsz)
801076b0:	31 c9                	xor    %ecx,%ecx
801076b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076b7:	89 f0                	mov    %esi,%eax
801076b9:	89 f3                	mov    %esi,%ebx
801076bb:	e8 e0 f9 ff ff       	call   801070a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076c6:	eb 0f                	jmp    801076d7 <freevm+0x37>
801076c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076cf:	00 
801076d0:	83 c3 04             	add    $0x4,%ebx
801076d3:	39 fb                	cmp    %edi,%ebx
801076d5:	74 23                	je     801076fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076d7:	8b 03                	mov    (%ebx),%eax
801076d9:	a8 01                	test   $0x1,%al
801076db:	74 f3                	je     801076d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076e2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076ed:	50                   	push   %eax
801076ee:	e8 ad b6 ff ff       	call   80102da0 <kfree>
801076f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076f6:	39 fb                	cmp    %edi,%ebx
801076f8:	75 dd                	jne    801076d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107700:	5b                   	pop    %ebx
80107701:	5e                   	pop    %esi
80107702:	5f                   	pop    %edi
80107703:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107704:	e9 97 b6 ff ff       	jmp    80102da0 <kfree>
    panic("freevm: no pgdir");
80107709:	83 ec 0c             	sub    $0xc,%esp
8010770c:	68 11 7f 10 80       	push   $0x80107f11
80107711:	e8 5a 8c ff ff       	call   80100370 <panic>
80107716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010771d:	00 
8010771e:	66 90                	xchg   %ax,%ax

80107720 <setupkvm>:
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	56                   	push   %esi
80107724:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107725:	e8 36 b8 ff ff       	call   80102f60 <kalloc>
8010772a:	85 c0                	test   %eax,%eax
8010772c:	74 5e                	je     8010778c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010772e:	83 ec 04             	sub    $0x4,%esp
80107731:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107733:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107738:	68 00 10 00 00       	push   $0x1000
8010773d:	6a 00                	push   $0x0
8010773f:	50                   	push   %eax
80107740:	e8 5b d8 ff ff       	call   80104fa0 <memset>
80107745:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107748:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010774b:	83 ec 08             	sub    $0x8,%esp
8010774e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107751:	8b 13                	mov    (%ebx),%edx
80107753:	ff 73 0c             	push   0xc(%ebx)
80107756:	50                   	push   %eax
80107757:	29 c1                	sub    %eax,%ecx
80107759:	89 f0                	mov    %esi,%eax
8010775b:	e8 00 fa ff ff       	call   80107160 <mappages>
80107760:	83 c4 10             	add    $0x10,%esp
80107763:	85 c0                	test   %eax,%eax
80107765:	78 19                	js     80107780 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107767:	83 c3 10             	add    $0x10,%ebx
8010776a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107770:	75 d6                	jne    80107748 <setupkvm+0x28>
}
80107772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107775:	89 f0                	mov    %esi,%eax
80107777:	5b                   	pop    %ebx
80107778:	5e                   	pop    %esi
80107779:	5d                   	pop    %ebp
8010777a:	c3                   	ret
8010777b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107780:	83 ec 0c             	sub    $0xc,%esp
80107783:	56                   	push   %esi
80107784:	e8 17 ff ff ff       	call   801076a0 <freevm>
      return 0;
80107789:	83 c4 10             	add    $0x10,%esp
}
8010778c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010778f:	31 f6                	xor    %esi,%esi
}
80107791:	89 f0                	mov    %esi,%eax
80107793:	5b                   	pop    %ebx
80107794:	5e                   	pop    %esi
80107795:	5d                   	pop    %ebp
80107796:	c3                   	ret
80107797:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010779e:	00 
8010779f:	90                   	nop

801077a0 <kvmalloc>:
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077a6:	e8 75 ff ff ff       	call   80107720 <setupkvm>
801077ab:	a3 c4 56 11 80       	mov    %eax,0x801156c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077b0:	05 00 00 00 80       	add    $0x80000000,%eax
801077b5:	0f 22 d8             	mov    %eax,%cr3
}
801077b8:	c9                   	leave
801077b9:	c3                   	ret
801077ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	83 ec 08             	sub    $0x8,%esp
801077c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801077c9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077cc:	89 c1                	mov    %eax,%ecx
801077ce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801077d1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077d4:	f6 c2 01             	test   $0x1,%dl
801077d7:	75 17                	jne    801077f0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801077d9:	83 ec 0c             	sub    $0xc,%esp
801077dc:	68 22 7f 10 80       	push   $0x80107f22
801077e1:	e8 8a 8b ff ff       	call   80100370 <panic>
801077e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077ed:	00 
801077ee:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801077f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801077f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801077fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107805:	85 c0                	test   %eax,%eax
80107807:	74 d0                	je     801077d9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107809:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010780c:	c9                   	leave
8010780d:	c3                   	ret
8010780e:	66 90                	xchg   %ax,%ax

80107810 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	57                   	push   %edi
80107814:	56                   	push   %esi
80107815:	53                   	push   %ebx
80107816:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107819:	e8 02 ff ff ff       	call   80107720 <setupkvm>
8010781e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107821:	85 c0                	test   %eax,%eax
80107823:	0f 84 e9 00 00 00    	je     80107912 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010782c:	85 c9                	test   %ecx,%ecx
8010782e:	0f 84 b2 00 00 00    	je     801078e6 <copyuvm+0xd6>
80107834:	31 f6                	xor    %esi,%esi
80107836:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010783d:	00 
8010783e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107843:	89 f0                	mov    %esi,%eax
80107845:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107848:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010784b:	a8 01                	test   $0x1,%al
8010784d:	75 11                	jne    80107860 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010784f:	83 ec 0c             	sub    $0xc,%esp
80107852:	68 2c 7f 10 80       	push   $0x80107f2c
80107857:	e8 14 8b ff ff       	call   80100370 <panic>
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107860:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107867:	c1 ea 0a             	shr    $0xa,%edx
8010786a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107870:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107877:	85 c0                	test   %eax,%eax
80107879:	74 d4                	je     8010784f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010787b:	8b 00                	mov    (%eax),%eax
8010787d:	a8 01                	test   $0x1,%al
8010787f:	0f 84 9f 00 00 00    	je     80107924 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107885:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107887:	25 ff 0f 00 00       	and    $0xfff,%eax
8010788c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010788f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107895:	e8 c6 b6 ff ff       	call   80102f60 <kalloc>
8010789a:	89 c3                	mov    %eax,%ebx
8010789c:	85 c0                	test   %eax,%eax
8010789e:	74 64                	je     80107904 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078a0:	83 ec 04             	sub    $0x4,%esp
801078a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078a9:	68 00 10 00 00       	push   $0x1000
801078ae:	57                   	push   %edi
801078af:	50                   	push   %eax
801078b0:	e8 7b d7 ff ff       	call   80105030 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078b5:	58                   	pop    %eax
801078b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078bc:	5a                   	pop    %edx
801078bd:	ff 75 e4             	push   -0x1c(%ebp)
801078c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078c5:	89 f2                	mov    %esi,%edx
801078c7:	50                   	push   %eax
801078c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078cb:	e8 90 f8 ff ff       	call   80107160 <mappages>
801078d0:	83 c4 10             	add    $0x10,%esp
801078d3:	85 c0                	test   %eax,%eax
801078d5:	78 21                	js     801078f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801078d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078dd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801078e0:	0f 82 5a ff ff ff    	jb     80107840 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801078e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ec:	5b                   	pop    %ebx
801078ed:	5e                   	pop    %esi
801078ee:	5f                   	pop    %edi
801078ef:	5d                   	pop    %ebp
801078f0:	c3                   	ret
801078f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801078f8:	83 ec 0c             	sub    $0xc,%esp
801078fb:	53                   	push   %ebx
801078fc:	e8 9f b4 ff ff       	call   80102da0 <kfree>
      goto bad;
80107901:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107904:	83 ec 0c             	sub    $0xc,%esp
80107907:	ff 75 e0             	push   -0x20(%ebp)
8010790a:	e8 91 fd ff ff       	call   801076a0 <freevm>
  return 0;
8010790f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107912:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107919:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010791c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010791f:	5b                   	pop    %ebx
80107920:	5e                   	pop    %esi
80107921:	5f                   	pop    %edi
80107922:	5d                   	pop    %ebp
80107923:	c3                   	ret
      panic("copyuvm: page not present");
80107924:	83 ec 0c             	sub    $0xc,%esp
80107927:	68 46 7f 10 80       	push   $0x80107f46
8010792c:	e8 3f 8a ff ff       	call   80100370 <panic>
80107931:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107938:	00 
80107939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107940 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107946:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107949:	89 c1                	mov    %eax,%ecx
8010794b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010794e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107951:	f6 c2 01             	test   $0x1,%dl
80107954:	0f 84 f8 00 00 00    	je     80107a52 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010795a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010795d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107963:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107964:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107969:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107970:	89 d0                	mov    %edx,%eax
80107972:	f7 d2                	not    %edx
80107974:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107979:	05 00 00 00 80       	add    $0x80000000,%eax
8010797e:	83 e2 05             	and    $0x5,%edx
80107981:	ba 00 00 00 00       	mov    $0x0,%edx
80107986:	0f 45 c2             	cmovne %edx,%eax
}
80107989:	c3                   	ret
8010798a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107990 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	57                   	push   %edi
80107994:	56                   	push   %esi
80107995:	53                   	push   %ebx
80107996:	83 ec 0c             	sub    $0xc,%esp
80107999:	8b 75 14             	mov    0x14(%ebp),%esi
8010799c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010799f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079a2:	85 f6                	test   %esi,%esi
801079a4:	75 51                	jne    801079f7 <copyout+0x67>
801079a6:	e9 9d 00 00 00       	jmp    80107a48 <copyout+0xb8>
801079ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801079b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801079b6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801079bc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801079c2:	74 74                	je     80107a38 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801079c4:	89 fb                	mov    %edi,%ebx
801079c6:	29 c3                	sub    %eax,%ebx
801079c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801079ce:	39 f3                	cmp    %esi,%ebx
801079d0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079d3:	29 f8                	sub    %edi,%eax
801079d5:	83 ec 04             	sub    $0x4,%esp
801079d8:	01 c1                	add    %eax,%ecx
801079da:	53                   	push   %ebx
801079db:	52                   	push   %edx
801079dc:	89 55 10             	mov    %edx,0x10(%ebp)
801079df:	51                   	push   %ecx
801079e0:	e8 4b d6 ff ff       	call   80105030 <memmove>
    len -= n;
    buf += n;
801079e5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801079e8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801079ee:	83 c4 10             	add    $0x10,%esp
    buf += n;
801079f1:	01 da                	add    %ebx,%edx
  while(len > 0){
801079f3:	29 de                	sub    %ebx,%esi
801079f5:	74 51                	je     80107a48 <copyout+0xb8>
  if(*pde & PTE_P){
801079f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801079fa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801079fc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801079fe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a01:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a07:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a0a:	f6 c1 01             	test   $0x1,%cl
80107a0d:	0f 84 46 00 00 00    	je     80107a59 <copyout.cold>
  return &pgtab[PTX(va)];
80107a13:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a15:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a1b:	c1 eb 0c             	shr    $0xc,%ebx
80107a1e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a24:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a2b:	89 d9                	mov    %ebx,%ecx
80107a2d:	f7 d1                	not    %ecx
80107a2f:	83 e1 05             	and    $0x5,%ecx
80107a32:	0f 84 78 ff ff ff    	je     801079b0 <copyout+0x20>
  }
  return 0;
}
80107a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a40:	5b                   	pop    %ebx
80107a41:	5e                   	pop    %esi
80107a42:	5f                   	pop    %edi
80107a43:	5d                   	pop    %ebp
80107a44:	c3                   	ret
80107a45:	8d 76 00             	lea    0x0(%esi),%esi
80107a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a4b:	31 c0                	xor    %eax,%eax
}
80107a4d:	5b                   	pop    %ebx
80107a4e:	5e                   	pop    %esi
80107a4f:	5f                   	pop    %edi
80107a50:	5d                   	pop    %ebp
80107a51:	c3                   	ret

80107a52 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107a52:	a1 00 00 00 00       	mov    0x0,%eax
80107a57:	0f 0b                	ud2

80107a59 <copyout.cold>:
80107a59:	a1 00 00 00 00       	mov    0x0,%eax
80107a5e:	0f 0b                	ud2
