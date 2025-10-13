
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
8010002d:	b8 00 43 10 80       	mov    $0x80104300,%eax
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
8010004c:	68 40 84 10 80       	push   $0x80108440
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 56 00 00       	call   80105680 <initlock>
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
80100092:	68 47 84 10 80       	push   $0x80108447
80100097:	50                   	push   %eax
80100098:	e8 b3 54 00 00       	call   80105550 <initsleeplock>
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
801000e4:	e8 87 57 00 00       	call   80105870 <acquire>
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
80100162:	e8 a9 56 00 00       	call   80105810 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 54 00 00       	call   80105590 <acquiresleep>
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
8010018c:	e8 0f 34 00 00       	call   801035a0 <iderw>
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
801001a1:	68 4e 84 10 80       	push   $0x8010844e
801001a6:	e8 95 03 00 00       	call   80100540 <panic>
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
801001be:	e8 6d 54 00 00       	call   80105630 <holdingsleep>
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
801001d4:	e9 c7 33 00 00       	jmp    801035a0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 84 10 80       	push   $0x8010845f
801001e1:	e8 5a 03 00 00       	call   80100540 <panic>
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
801001ff:	e8 2c 54 00 00       	call   80105630 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 53 00 00       	call   801055f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 56 00 00       	call   80105870 <acquire>
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
80100269:	e9 a2 55 00 00       	jmp    80105810 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 84 10 80       	push   $0x80108466
80100276:	e8 c5 02 00 00       	call   80100540 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <insert_at>:
  if (input.e < input.w)
    input.e = input.w;
}

static int insert_at(int pos, const char *src, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 0c             	sub    $0xc,%esp
80100289:	89 55 f0             	mov    %edx,-0x10(%ebp)
  if (n <= 0)
    return 0;
8010028c:	31 d2                	xor    %edx,%edx
  if (n <= 0)
8010028e:	85 c9                	test   %ecx,%ecx
80100290:	0f 8e db 00 00 00    	jle    80100371 <insert_at+0xf1>
  int inuse = (int)input.real_end - (int)input.r;
80100296:	8b 3d 0c ff 10 80    	mov    0x8010ff0c,%edi
8010029c:	89 c3                	mov    %eax,%ebx
  int free = INPUT_BUF - inuse;
8010029e:	b8 80 00 00 00       	mov    $0x80,%eax
  int inuse = (int)input.real_end - (int)input.r;
801002a3:	89 fa                	mov    %edi,%edx
801002a5:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801002ab:	89 7d ec             	mov    %edi,-0x14(%ebp)
  int free = INPUT_BUF - inuse;
801002ae:	29 d0                	sub    %edx,%eax
    return 0;
801002b0:	31 d2                	xor    %edx,%edx
  if (free <= 0)
801002b2:	85 c0                	test   %eax,%eax
801002b4:	0f 8e b7 00 00 00    	jle    80100371 <insert_at+0xf1>
801002ba:	89 ce                	mov    %ecx,%esi
    return 0;
  if (n > free)
801002bc:	39 c1                	cmp    %eax,%ecx
    n = free;

  for (int i = (int)input.real_end - 1; i >= pos; --i)
801002be:	8d 4f ff             	lea    -0x1(%edi),%ecx
  if (n > free)
801002c1:	0f 4f f0             	cmovg  %eax,%esi
  for (int i = (int)input.real_end - 1; i >= pos; --i)
801002c4:	8d 7b ff             	lea    -0x1(%ebx),%edi
801002c7:	39 d9                	cmp    %ebx,%ecx
801002c9:	7c 4c                	jl     80100317 <insert_at+0x97>
801002cb:	89 5d e8             	mov    %ebx,-0x18(%ebp)
801002ce:	66 90                	xchg   %ax,%ax
  {
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801002d0:	89 c8                	mov    %ecx,%eax
801002d2:	c1 f8 1f             	sar    $0x1f,%eax
801002d5:	c1 e8 19             	shr    $0x19,%eax
801002d8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801002db:	83 e2 7f             	and    $0x7f,%edx
801002de:	29 c2                	sub    %eax,%edx
801002e0:	8d 04 31             	lea    (%ecx,%esi,1),%eax
  for (int i = (int)input.real_end - 1; i >= pos; --i)
801002e3:	83 e9 01             	sub    $0x1,%ecx
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801002e6:	89 c3                	mov    %eax,%ebx
801002e8:	c1 fb 1f             	sar    $0x1f,%ebx
801002eb:	c1 eb 19             	shr    $0x19,%ebx
801002ee:	01 d8                	add    %ebx,%eax
801002f0:	83 e0 7f             	and    $0x7f,%eax
801002f3:	29 d8                	sub    %ebx,%eax
801002f5:	0f b6 9a 80 fe 10 80 	movzbl -0x7fef0180(%edx),%ebx
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801002fc:	8b 14 95 10 ff 10 80 	mov    -0x7fef00f0(,%edx,4),%edx
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100303:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100309:	89 14 85 10 ff 10 80 	mov    %edx,-0x7fef00f0(,%eax,4)
  for (int i = (int)input.real_end - 1; i >= pos; --i)
80100310:	39 f9                	cmp    %edi,%ecx
80100312:	75 bc                	jne    801002d0 <insert_at+0x50>
80100314:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  }
  int wrote = 0;
80100317:	31 d2                	xor    %edx,%edx
80100319:	89 df                	mov    %ebx,%edi
8010031b:	eb 35                	jmp    80100352 <insert_at+0xd2>
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
  for (; wrote < n; ++wrote)
  {
    char ch = src[wrote];
    if (ch == '\n')
      break; // اجازه‌ی newline نده
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100320:	89 c1                	mov    %eax,%ecx
  for (; wrote < n; ++wrote)
80100322:	83 c2 01             	add    $0x1,%edx
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100325:	c1 f9 1f             	sar    $0x1f,%ecx
80100328:	c1 e9 19             	shr    $0x19,%ecx
8010032b:	01 c8                	add    %ecx,%eax
8010032d:	83 e0 7f             	and    $0x7f,%eax
80100330:	29 c8                	sub    %ecx,%eax
80100332:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
    input.insert_order[(pos + wrote) % INPUT_BUF] = ++input.current_time;
80100338:	8b 1d 10 01 11 80    	mov    0x80110110,%ebx
8010033e:	8d 4b 01             	lea    0x1(%ebx),%ecx
80100341:	89 0d 10 01 11 80    	mov    %ecx,0x80110110
80100347:	89 0c 85 10 ff 10 80 	mov    %ecx,-0x7fef00f0(,%eax,4)
  for (; wrote < n; ++wrote)
8010034e:	39 d6                	cmp    %edx,%esi
80100350:	74 2e                	je     80100380 <insert_at+0x100>
    char ch = src[wrote];
80100352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100355:	0f b6 1c 10          	movzbl (%eax,%edx,1),%ebx
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100359:	8d 04 17             	lea    (%edi,%edx,1),%eax
    if (ch == '\n')
8010035c:	80 fb 0a             	cmp    $0xa,%bl
8010035f:	75 bf                	jne    80100320 <insert_at+0xa0>
  }
  input.real_end += wrote;
80100361:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  input.e = pos + wrote;
80100364:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  input.real_end += wrote;
80100369:	01 d1                	add    %edx,%ecx
8010036b:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
  return wrote;
}
80100371:	83 c4 0c             	add    $0xc,%esp
80100374:	89 d0                	mov    %edx,%eax
80100376:	5b                   	pop    %ebx
80100377:	5e                   	pop    %esi
80100378:	5f                   	pop    %edi
80100379:	5d                   	pop    %ebp
8010037a:	c3                   	ret
8010037b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100380:	8d 04 17             	lea    (%edi,%edx,1),%eax
80100383:	eb dc                	jmp    80100361 <insert_at+0xe1>
80100385:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010038c:	00 
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <consoleread>:
  if (doprocdump)
    procdump();
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	57                   	push   %edi
80100394:	56                   	push   %esi
80100395:	53                   	push   %ebx
80100396:	83 ec 18             	sub    $0x18,%esp
80100399:	8b 7d 08             	mov    0x8(%ebp),%edi
8010039c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010039f:	57                   	push   %edi
801003a0:	e8 ab 27 00 00       	call   80102b50 <iunlock>
  target = n;
  acquire(&cons.lock);
801003a5:	c7 04 24 a0 01 11 80 	movl   $0x801101a0,(%esp)
801003ac:	e8 bf 54 00 00       	call   80105870 <acquire>
  while (n > 0)
801003b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801003b4:	83 c4 10             	add    $0x10,%esp
801003b7:	85 db                	test   %ebx,%ebx
801003b9:	0f 8e 8d 00 00 00    	jle    8010044c <consoleread+0xbc>
  {
    while (input.r == input.w)
801003bf:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003c4:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003ca:	74 26                	je     801003f2 <consoleread+0x62>
801003cc:	eb 5a                	jmp    80100428 <consoleread+0x98>
801003ce:	66 90                	xchg   %ax,%ax
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	68 a0 01 11 80       	push   $0x801101a0
801003d8:	68 00 ff 10 80       	push   $0x8010ff00
801003dd:	e8 0e 4f 00 00       	call   801052f0 <sleep>
    while (input.r == input.w)
801003e2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801003e7:	83 c4 10             	add    $0x10,%esp
801003ea:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801003f0:	75 36                	jne    80100428 <consoleread+0x98>
      if (myproc()->killed)
801003f2:	e8 39 48 00 00       	call   80104c30 <myproc>
801003f7:	8b 40 24             	mov    0x24(%eax),%eax
801003fa:	85 c0                	test   %eax,%eax
801003fc:	74 d2                	je     801003d0 <consoleread+0x40>
        release(&cons.lock);
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	68 a0 01 11 80       	push   $0x801101a0
80100406:	e8 05 54 00 00       	call   80105810 <release>
        ilock(ip);
8010040b:	89 3c 24             	mov    %edi,(%esp)
8010040e:	e8 5d 26 00 00       	call   80102a70 <ilock>
        return -1;
80100413:	83 c4 10             	add    $0x10,%esp
      break;
  }
  release(&cons.lock);
  ilock(ip);
  return target - n;
}
80100416:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010041e:	5b                   	pop    %ebx
8010041f:	5e                   	pop    %esi
80100420:	5f                   	pop    %edi
80100421:	5d                   	pop    %ebp
80100422:	c3                   	ret
80100423:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100428:	8d 50 01             	lea    0x1(%eax),%edx
8010042b:	83 e0 7f             	and    $0x7f,%eax
    *dst++ = c;
8010042e:	83 c6 01             	add    $0x1,%esi
    --n;
80100431:	83 eb 01             	sub    $0x1,%ebx
    c = input.buf[input.r++ % INPUT_BUF];
80100434:	0f b6 80 80 fe 10 80 	movzbl -0x7fef0180(%eax),%eax
8010043b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
    *dst++ = c;
80100441:	88 46 ff             	mov    %al,-0x1(%esi)
    if (c == '\n')
80100444:	3c 0a                	cmp    $0xa,%al
80100446:	0f 85 6b ff ff ff    	jne    801003b7 <consoleread+0x27>
  release(&cons.lock);
8010044c:	83 ec 0c             	sub    $0xc,%esp
8010044f:	68 a0 01 11 80       	push   $0x801101a0
80100454:	e8 b7 53 00 00       	call   80105810 <release>
  ilock(ip);
80100459:	89 3c 24             	mov    %edi,(%esp)
8010045c:	e8 0f 26 00 00       	call   80102a70 <ilock>
  return target - n;
80100461:	8b 45 10             	mov    0x10(%ebp),%eax
80100464:	83 c4 10             	add    $0x10,%esp
}
80100467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010046a:	29 d8                	sub    %ebx,%eax
}
8010046c:	5b                   	pop    %ebx
8010046d:	5e                   	pop    %esi
8010046e:	5f                   	pop    %edi
8010046f:	5d                   	pop    %ebp
80100470:	c3                   	ret
80100471:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100478:	00 
80100479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100480 <delete_range.part.0>:
static void delete_range(int lo, int hi)
80100480:	55                   	push   %ebp
80100481:	89 e5                	mov    %esp,%ebp
80100483:	57                   	push   %edi
80100484:	56                   	push   %esi
  int deln = hi - lo;
80100485:	89 d6                	mov    %edx,%esi
static void delete_range(int lo, int hi)
80100487:	53                   	push   %ebx
  int deln = hi - lo;
80100488:	29 c6                	sub    %eax,%esi
static void delete_range(int lo, int hi)
8010048a:	89 c3                	mov    %eax,%ebx
8010048c:	83 ec 0c             	sub    $0xc,%esp
  for (int i = hi; i < (int)input.real_end; i++)
8010048f:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80100494:	89 c7                	mov    %eax,%edi
80100496:	29 f7                	sub    %esi,%edi
80100498:	39 c2                	cmp    %eax,%edx
8010049a:	7d 5d                	jge    801004f9 <delete_range.part.0+0x79>
8010049c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010049f:	89 d9                	mov    %ebx,%ecx
801004a1:	89 5d ec             	mov    %ebx,-0x14(%ebp)
801004a4:	89 55 e8             	mov    %edx,-0x18(%ebp)
801004a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801004ae:	00 
801004af:	90                   	nop
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004b0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801004b3:	89 cb                	mov    %ecx,%ebx
801004b5:	99                   	cltd
801004b6:	c1 fb 1f             	sar    $0x1f,%ebx
801004b9:	c1 ea 19             	shr    $0x19,%edx
801004bc:	c1 eb 19             	shr    $0x19,%ebx
801004bf:	01 d0                	add    %edx,%eax
801004c1:	83 e0 7f             	and    $0x7f,%eax
801004c4:	29 d0                	sub    %edx,%eax
801004c6:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
  for (int i = hi; i < (int)input.real_end; i++)
801004c9:	83 c1 01             	add    $0x1,%ecx
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004cc:	83 e2 7f             	and    $0x7f,%edx
801004cf:	29 da                	sub    %ebx,%edx
801004d1:	0f b6 98 80 fe 10 80 	movzbl -0x7fef0180(%eax),%ebx
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801004d8:	8b 04 85 10 ff 10 80 	mov    -0x7fef00f0(,%eax,4),%eax
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004df:	88 9a 80 fe 10 80    	mov    %bl,-0x7fef0180(%edx)
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801004e5:	89 04 95 10 ff 10 80 	mov    %eax,-0x7fef00f0(,%edx,4)
  for (int i = hi; i < (int)input.real_end; i++)
801004ec:	39 cf                	cmp    %ecx,%edi
801004ee:	75 c0                	jne    801004b0 <delete_range.part.0+0x30>
801004f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004f3:	8b 5d ec             	mov    -0x14(%ebp),%ebx
801004f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  input.real_end -= deln;
801004f9:	29 f0                	sub    %esi,%eax
801004fb:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
  if (input.e > hi)
80100500:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100505:	39 c2                	cmp    %eax,%edx
80100507:	73 27                	jae    80100530 <delete_range.part.0+0xb0>
    input.e -= deln;
80100509:	29 f0                	sub    %esi,%eax
8010050b:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if (input.e < input.w)
80100510:	8b 15 04 ff 10 80    	mov    0x8010ff04,%edx
80100516:	39 d0                	cmp    %edx,%eax
80100518:	73 06                	jae    80100520 <delete_range.part.0+0xa0>
    input.e = input.w;
8010051a:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
}
80100520:	83 c4 0c             	add    $0xc,%esp
80100523:	5b                   	pop    %ebx
80100524:	5e                   	pop    %esi
80100525:	5f                   	pop    %edi
80100526:	5d                   	pop    %ebp
80100527:	c3                   	ret
80100528:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010052f:	00 
  else if (input.e > lo)
80100530:	39 c3                	cmp    %eax,%ebx
80100532:	73 dc                	jae    80100510 <delete_range.part.0+0x90>
    input.e = lo;
80100534:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
8010053a:	89 d8                	mov    %ebx,%eax
8010053c:	eb d2                	jmp    80100510 <delete_range.part.0+0x90>
8010053e:	66 90                	xchg   %ax,%ax

80100540 <panic>:
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	56                   	push   %esi
80100544:	53                   	push   %ebx
80100545:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100548:	fa                   	cli
  cons.locking = 0;
80100549:	c7 05 d4 01 11 80 00 	movl   $0x0,0x801101d4
80100550:	00 00 00 
  getcallerpcs(&s, pcs);
80100553:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100556:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100559:	e8 42 36 00 00       	call   80103ba0 <lapicid>
8010055e:	83 ec 08             	sub    $0x8,%esp
80100561:	50                   	push   %eax
80100562:	68 6d 84 10 80       	push   $0x8010846d
80100567:	e8 c4 06 00 00       	call   80100c30 <cprintf>
  cprintf(s);
8010056c:	58                   	pop    %eax
8010056d:	ff 75 08             	push   0x8(%ebp)
80100570:	e8 bb 06 00 00       	call   80100c30 <cprintf>
  cprintf("\n");
80100575:	c7 04 24 ef 88 10 80 	movl   $0x801088ef,(%esp)
8010057c:	e8 af 06 00 00       	call   80100c30 <cprintf>
  getcallerpcs(&s, pcs);
80100581:	8d 45 08             	lea    0x8(%ebp),%eax
80100584:	5a                   	pop    %edx
80100585:	59                   	pop    %ecx
80100586:	53                   	push   %ebx
80100587:	50                   	push   %eax
80100588:	e8 13 51 00 00       	call   801056a0 <getcallerpcs>
  for (i = 0; i < 10; i++)
8010058d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100590:	83 ec 08             	sub    $0x8,%esp
80100593:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
80100595:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100598:	68 81 84 10 80       	push   $0x80108481
8010059d:	e8 8e 06 00 00       	call   80100c30 <cprintf>
  for (i = 0; i < 10; i++)
801005a2:	83 c4 10             	add    $0x10,%esp
801005a5:	39 f3                	cmp    %esi,%ebx
801005a7:	75 e7                	jne    80100590 <panic+0x50>
  panicked = 1;
801005a9:	c7 05 d8 01 11 80 01 	movl   $0x1,0x801101d8
801005b0:	00 00 00 
  for (;;)
801005b3:	eb fe                	jmp    801005b3 <panic+0x73>
801005b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005bc:	00 
801005bd:	8d 76 00             	lea    0x0(%esi),%esi

801005c0 <consputc.part.0>:
void consputc(int c, int k)
801005c0:	55                   	push   %ebp
801005c1:	89 e5                	mov    %esp,%ebp
801005c3:	57                   	push   %edi
801005c4:	56                   	push   %esi
801005c5:	53                   	push   %ebx
801005c6:	83 ec 0c             	sub    $0xc,%esp
  if (c == BACKSPACE)
801005c9:	3d 00 01 00 00       	cmp    $0x100,%eax
801005ce:	0f 84 64 01 00 00    	je     80100738 <consputc.part.0+0x178>
801005d4:	89 c6                	mov    %eax,%esi
  else if (c == KEY_LF)
801005d6:	3d e4 00 00 00       	cmp    $0xe4,%eax
801005db:	0f 84 ff 01 00 00    	je     801007e0 <consputc.part.0+0x220>
  else if (c == KEY_RT)
801005e1:	3d e5 00 00 00       	cmp    $0xe5,%eax
801005e6:	0f 84 a4 00 00 00    	je     80100690 <consputc.part.0+0xd0>
    uartputc(c);
801005ec:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005ef:	bf d4 03 00 00       	mov    $0x3d4,%edi
801005f4:	50                   	push   %eax
801005f5:	e8 86 69 00 00       	call   80106f80 <uartputc>
801005fa:	b8 0e 00 00 00       	mov    $0xe,%eax
801005ff:	89 fa                	mov    %edi,%edx
80100601:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100602:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100607:	89 da                	mov    %ebx,%edx
80100609:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010060a:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010060d:	89 fa                	mov    %edi,%edx
8010060f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100614:	c1 e1 08             	shl    $0x8,%ecx
80100617:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100618:	89 da                	mov    %ebx,%edx
8010061a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010061b:	0f b6 c0             	movzbl %al,%eax
  if (c == '\n')
8010061e:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
80100621:	09 c8                	or     %ecx,%eax
  if (c == '\n')
80100623:	83 fe 0a             	cmp    $0xa,%esi
80100626:	0f 85 84 01 00 00    	jne    801007b0 <consputc.part.0+0x1f0>
    pos += 80 - pos % 80;
8010062c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100631:	f7 e2                	mul    %edx
80100633:	c1 ea 06             	shr    $0x6,%edx
80100636:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100639:	c1 e0 04             	shl    $0x4,%eax
8010063c:	8d 58 50             	lea    0x50(%eax),%ebx
  if (pos < 0 || pos > 25 * 80)
8010063f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100645:	0f 8f 90 00 00 00    	jg     801006db <consputc.part.0+0x11b>
  outb(CRTPORT + 1, pos >> 8);
8010064b:	0f b6 f7             	movzbl %bh,%esi
  if ((pos / 80) >= 24)
8010064e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100654:	0f 8f 96 00 00 00    	jg     801006f0 <consputc.part.0+0x130>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010065a:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010065f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100664:	89 fa                	mov    %edi,%edx
80100666:	ee                   	out    %al,(%dx)
80100667:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010066c:	89 f0                	mov    %esi,%eax
8010066e:	89 ca                	mov    %ecx,%edx
80100670:	ee                   	out    %al,(%dx)
80100671:	b8 0f 00 00 00       	mov    $0xf,%eax
80100676:	89 fa                	mov    %edi,%edx
80100678:	ee                   	out    %al,(%dx)
80100679:	89 d8                	mov    %ebx,%eax
8010067b:	89 ca                	mov    %ecx,%edx
8010067d:	ee                   	out    %al,(%dx)
}
8010067e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100681:	5b                   	pop    %ebx
80100682:	5e                   	pop    %esi
80100683:	5f                   	pop    %edi
80100684:	5d                   	pop    %ebp
80100685:	c3                   	ret
80100686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010068d:	00 
8010068e:	66 90                	xchg   %ax,%ax
    uartputc(k);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	be d4 03 00 00       	mov    $0x3d4,%esi
80100698:	52                   	push   %edx
80100699:	e8 e2 68 00 00       	call   80106f80 <uartputc>
8010069e:	b8 0e 00 00 00       	mov    $0xe,%eax
801006a3:	89 f2                	mov    %esi,%edx
801006a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006a6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801006ab:	89 da                	mov    %ebx,%edx
801006ad:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801006ae:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006b1:	89 f2                	mov    %esi,%edx
801006b3:	b8 0f 00 00 00       	mov    $0xf,%eax
801006b8:	c1 e1 08             	shl    $0x8,%ecx
801006bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006bc:	89 da                	mov    %ebx,%edx
801006be:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801006bf:	0f b6 d8             	movzbl %al,%ebx
    if (pos < 25 * 80 - 1)
801006c2:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
801006c5:	09 cb                	or     %ecx,%ebx
    if (pos < 25 * 80 - 1)
801006c7:	81 fb ce 07 00 00    	cmp    $0x7ce,%ebx
801006cd:	0f 8e 55 01 00 00    	jle    80100828 <consputc.part.0+0x268>
  if (pos < 0 || pos > 25 * 80)
801006d3:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801006d9:	7e 15                	jle    801006f0 <consputc.part.0+0x130>
    panic("pos under/overflow");
801006db:	83 ec 0c             	sub    $0xc,%esp
801006de:	68 85 84 10 80       	push   $0x80108485
801006e3:	e8 58 fe ff ff       	call   80100540 <panic>
801006e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006ef:	00 
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801006f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801006f3:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT + 1, pos);
801006f6:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801006fb:	68 60 0e 00 00       	push   $0xe60
80100700:	68 a0 80 0b 80       	push   $0x800b80a0
80100705:	68 00 80 0b 80       	push   $0x800b8000
8010070a:	e8 f1 52 00 00       	call   80105a00 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010070f:	b8 80 07 00 00       	mov    $0x780,%eax
80100714:	83 c4 0c             	add    $0xc,%esp
80100717:	29 d8                	sub    %ebx,%eax
80100719:	01 c0                	add    %eax,%eax
8010071b:	50                   	push   %eax
8010071c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100723:	6a 00                	push   $0x0
80100725:	50                   	push   %eax
80100726:	e8 45 52 00 00       	call   80105970 <memset>
  outb(CRTPORT + 1, pos);
8010072b:	83 c4 10             	add    $0x10,%esp
8010072e:	e9 27 ff ff ff       	jmp    8010065a <consputc.part.0+0x9a>
80100733:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80100738:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010073b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100740:	6a 08                	push   $0x8
80100742:	e8 39 68 00 00       	call   80106f80 <uartputc>
    uartputc(' ');
80100747:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010074e:	e8 2d 68 00 00       	call   80106f80 <uartputc>
    uartputc('\b');
80100753:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010075a:	e8 21 68 00 00       	call   80106f80 <uartputc>
8010075f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100764:	89 f2                	mov    %esi,%edx
80100766:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100767:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010076c:	89 da                	mov    %ebx,%edx
8010076e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010076f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100772:	89 f2                	mov    %esi,%edx
80100774:	b8 0f 00 00 00       	mov    $0xf,%eax
80100779:	c1 e1 08             	shl    $0x8,%ecx
8010077c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010077d:	89 da                	mov    %ebx,%edx
8010077f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100780:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
80100783:	83 c4 10             	add    $0x10,%esp
80100786:	09 cb                	or     %ecx,%ebx
80100788:	74 16                	je     801007a0 <consputc.part.0+0x1e0>
      --pos;
8010078a:	83 eb 01             	sub    $0x1,%ebx
      crt[pos] = ' ' | 0x0700;
8010078d:	b9 20 07 00 00       	mov    $0x720,%ecx
80100792:	66 89 8c 1b 00 80 0b 	mov    %cx,-0x7ff48000(%ebx,%ebx,1)
80100799:	80 
8010079a:	e9 a0 fe ff ff       	jmp    8010063f <consputc.part.0+0x7f>
8010079f:	90                   	nop
  outb(CRTPORT + 1, pos);
801007a0:	31 db                	xor    %ebx,%ebx
801007a2:	31 f6                	xor    %esi,%esi
801007a4:	e9 b1 fe ff ff       	jmp    8010065a <consputc.part.0+0x9a>
801007a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c & 0xff) | cg_attr;
801007b0:	89 f1                	mov    %esi,%ecx
801007b2:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos] = ' ' | 0x0700;
801007b5:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c & 0xff) | cg_attr;
801007ba:	01 c0                	add    %eax,%eax
801007bc:	0f b6 f1             	movzbl %cl,%esi
801007bf:	66 0b 35 00 90 10 80 	or     0x80109000,%si
    crt[pos] = ' ' | 0x0700;
801007c6:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c & 0xff) | cg_attr;
801007cd:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos] = ' ' | 0x0700;
801007d4:	e9 66 fe ff ff       	jmp    8010063f <consputc.part.0+0x7f>
801007d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
801007e0:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801007e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801007e8:	6a 08                	push   $0x8
801007ea:	e8 91 67 00 00       	call   80106f80 <uartputc>
801007ef:	b8 0e 00 00 00       	mov    $0xe,%eax
801007f4:	89 f2                	mov    %esi,%edx
801007f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801007f7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801007fc:	89 da                	mov    %ebx,%edx
801007fe:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801007ff:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100802:	89 f2                	mov    %esi,%edx
80100804:	b8 0f 00 00 00       	mov    $0xf,%eax
80100809:	c1 e1 08             	shl    $0x8,%ecx
8010080c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010080d:	89 da                	mov    %ebx,%edx
8010080f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100810:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
80100813:	83 c4 10             	add    $0x10,%esp
80100816:	09 cb                	or     %ecx,%ebx
80100818:	74 86                	je     801007a0 <consputc.part.0+0x1e0>
      --pos;
8010081a:	83 eb 01             	sub    $0x1,%ebx
8010081d:	e9 1d fe ff ff       	jmp    8010063f <consputc.part.0+0x7f>
80100822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ++pos;
80100828:	83 c3 01             	add    $0x1,%ebx
  if (pos < 0 || pos > 25 * 80)
8010082b:	e9 1b fe ff ff       	jmp    8010064b <consputc.part.0+0x8b>

80100830 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80100830:	55                   	push   %ebp
80100831:	89 e5                	mov    %esp,%ebp
80100833:	57                   	push   %edi
80100834:	56                   	push   %esi
80100835:	53                   	push   %ebx
80100836:	83 ec 18             	sub    $0x18,%esp
80100839:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010083c:	ff 75 08             	push   0x8(%ebp)
8010083f:	e8 0c 23 00 00       	call   80102b50 <iunlock>
  acquire(&cons.lock);
80100844:	c7 04 24 a0 01 11 80 	movl   $0x801101a0,(%esp)
8010084b:	e8 20 50 00 00       	call   80105870 <acquire>
  for (i = 0; i < n; i++)
80100850:	83 c4 10             	add    $0x10,%esp
80100853:	85 f6                	test   %esi,%esi
80100855:	7e 27                	jle    8010087e <consolewrite+0x4e>
80100857:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010085a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if (panicked)
8010085d:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(buf[i] & 0xff, 0);
80100863:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
80100866:	85 d2                	test   %edx,%edx
80100868:	74 06                	je     80100870 <consolewrite+0x40>
  asm volatile("cli");
8010086a:	fa                   	cli
    for (;;)
8010086b:	eb fe                	jmp    8010086b <consolewrite+0x3b>
8010086d:	8d 76 00             	lea    0x0(%esi),%esi
80100870:	31 d2                	xor    %edx,%edx
  for (i = 0; i < n; i++)
80100872:	83 c3 01             	add    $0x1,%ebx
80100875:	e8 46 fd ff ff       	call   801005c0 <consputc.part.0>
8010087a:	39 fb                	cmp    %edi,%ebx
8010087c:	75 df                	jne    8010085d <consolewrite+0x2d>
  release(&cons.lock);
8010087e:	83 ec 0c             	sub    $0xc,%esp
80100881:	68 a0 01 11 80       	push   $0x801101a0
80100886:	e8 85 4f 00 00       	call   80105810 <release>
  ilock(ip);
8010088b:	58                   	pop    %eax
8010088c:	ff 75 08             	push   0x8(%ebp)
8010088f:	e8 dc 21 00 00       	call   80102a70 <ilock>
  return n;
}
80100894:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100897:	89 f0                	mov    %esi,%eax
80100899:	5b                   	pop    %ebx
8010089a:	5e                   	pop    %esi
8010089b:	5f                   	pop    %edi
8010089c:	5d                   	pop    %ebp
8010089d:	c3                   	ret
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <printint>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
801008a4:	56                   	push   %esi
801008a5:	53                   	push   %ebx
801008a6:	89 d3                	mov    %edx,%ebx
801008a8:	83 ec 2c             	sub    $0x2c,%esp
  if (sign && (sign = xx < 0))
801008ab:	85 c0                	test   %eax,%eax
801008ad:	79 05                	jns    801008b4 <printint+0x14>
801008af:	83 e1 01             	and    $0x1,%ecx
801008b2:	75 66                	jne    8010091a <printint+0x7a>
    x = xx;
801008b4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801008bb:	89 c1                	mov    %eax,%ecx
  i = 0;
801008bd:	31 f6                	xor    %esi,%esi
801008bf:	90                   	nop
    buf[i++] = digits[x % base];
801008c0:	89 c8                	mov    %ecx,%eax
801008c2:	31 d2                	xor    %edx,%edx
801008c4:	89 f7                	mov    %esi,%edi
801008c6:	f7 f3                	div    %ebx
801008c8:	8d 76 01             	lea    0x1(%esi),%esi
801008cb:	0f b6 92 ac 89 10 80 	movzbl -0x7fef7654(%edx),%edx
801008d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  } while ((x /= base) != 0);
801008d6:	89 ca                	mov    %ecx,%edx
801008d8:	89 c1                	mov    %eax,%ecx
801008da:	39 da                	cmp    %ebx,%edx
801008dc:	73 e2                	jae    801008c0 <printint+0x20>
  if (sign)
801008de:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
801008e1:	85 c9                	test   %ecx,%ecx
801008e3:	74 07                	je     801008ec <printint+0x4c>
    buf[i++] = '-';
801008e5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while (--i >= 0)
801008ea:	89 f7                	mov    %esi,%edi
801008ec:	8d 5d d8             	lea    -0x28(%ebp),%ebx
801008ef:	01 df                	add    %ebx,%edi
  if (panicked)
801008f1:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(buf[i], 0);
801008f7:	0f be 07             	movsbl (%edi),%eax
  if (panicked)
801008fa:	85 d2                	test   %edx,%edx
801008fc:	74 0a                	je     80100908 <printint+0x68>
801008fe:	fa                   	cli
    for (;;)
801008ff:	eb fe                	jmp    801008ff <printint+0x5f>
80100901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100908:	31 d2                	xor    %edx,%edx
8010090a:	e8 b1 fc ff ff       	call   801005c0 <consputc.part.0>
  while (--i >= 0)
8010090f:	8d 47 ff             	lea    -0x1(%edi),%eax
80100912:	39 df                	cmp    %ebx,%edi
80100914:	74 11                	je     80100927 <printint+0x87>
80100916:	89 c7                	mov    %eax,%edi
80100918:	eb d7                	jmp    801008f1 <printint+0x51>
    x = -xx;
8010091a:	f7 d8                	neg    %eax
  if (sign && (sign = xx < 0))
8010091c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80100923:	89 c1                	mov    %eax,%ecx
80100925:	eb 96                	jmp    801008bd <printint+0x1d>
}
80100927:	83 c4 2c             	add    $0x2c,%esp
8010092a:	5b                   	pop    %ebx
8010092b:	5e                   	pop    %esi
8010092c:	5f                   	pop    %edi
8010092d:	5d                   	pop    %ebp
8010092e:	c3                   	ret
8010092f:	90                   	nop

80100930 <full_redraw_after_edit>:
{
80100930:	55                   	push   %ebp
80100931:	89 e5                	mov    %esp,%ebp
80100933:	57                   	push   %edi
  if (old_cursor_off < 0)
80100934:	31 ff                	xor    %edi,%edi
{
80100936:	56                   	push   %esi
80100937:	53                   	push   %ebx
80100938:	83 ec 1c             	sub    $0x1c,%esp
  int old_len = (int)input.real_end - (int)input.w;
8010093b:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
80100941:	8b 15 0c ff 10 80    	mov    0x8010ff0c,%edx
  int old_cursor_off = (int)old_e - (int)input.w;
80100947:	29 f0                	sub    %esi,%eax
  int old_len = (int)input.real_end - (int)input.w;
80100949:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if (old_cursor_off < 0)
8010094c:	85 c0                	test   %eax,%eax
8010094e:	0f 49 f8             	cmovns %eax,%edi
  for (int i = 0; i < old_cursor_off; i++)
80100951:	7e 28                	jle    8010097b <full_redraw_after_edit+0x4b>
80100953:	31 db                	xor    %ebx,%ebx
  if (panicked)
80100955:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
8010095b:	85 c9                	test   %ecx,%ecx
8010095d:	74 09                	je     80100968 <full_redraw_after_edit+0x38>
8010095f:	fa                   	cli
    for (;;)
80100960:	eb fe                	jmp    80100960 <full_redraw_after_edit+0x30>
80100962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100968:	31 d2                	xor    %edx,%edx
8010096a:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
8010096f:	83 c3 01             	add    $0x1,%ebx
80100972:	e8 49 fc ff ff       	call   801005c0 <consputc.part.0>
80100977:	39 df                	cmp    %ebx,%edi
80100979:	7f da                	jg     80100955 <full_redraw_after_edit+0x25>
  int old_len = (int)input.real_end - (int)input.w;
8010097b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
min_int(int a, int b) { return a < b ? a : b; }
8010097e:	bf 50 00 00 00       	mov    $0x50,%edi
  int old_len = (int)input.real_end - (int)input.w;
80100983:	29 f3                	sub    %esi,%ebx
  if (old_len < 0)
80100985:	be 00 00 00 00       	mov    $0x0,%esi
8010098a:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
8010098d:	39 fe                	cmp    %edi,%esi
8010098f:	0f 4e fe             	cmovle %esi,%edi
  for (int i = 0; i < min_int(old_len, 80); i++)
80100992:	85 db                	test   %ebx,%ebx
80100994:	0f 8e 92 00 00 00    	jle    80100a2c <full_redraw_after_edit+0xfc>
8010099a:	31 c9                	xor    %ecx,%ecx
  if (panicked)
8010099c:	8b 1d d8 01 11 80    	mov    0x801101d8,%ebx
801009a2:	85 db                	test   %ebx,%ebx
801009a4:	74 0a                	je     801009b0 <full_redraw_after_edit+0x80>
801009a6:	fa                   	cli
    for (;;)
801009a7:	eb fe                	jmp    801009a7 <full_redraw_after_edit+0x77>
801009a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009b0:	31 d2                	xor    %edx,%edx
801009b2:	b8 20 00 00 00       	mov    $0x20,%eax
801009b7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801009ba:	e8 01 fc ff ff       	call   801005c0 <consputc.part.0>
  for (int i = 0; i < min_int(old_len, 80); i++)
801009bf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801009c2:	83 c1 01             	add    $0x1,%ecx
801009c5:	39 f9                	cmp    %edi,%ecx
801009c7:	7c d3                	jl     8010099c <full_redraw_after_edit+0x6c>
  if (panicked)
801009c9:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
801009cf:	85 c9                	test   %ecx,%ecx
801009d1:	75 3d                	jne    80100a10 <full_redraw_after_edit+0xe0>
801009d3:	31 d2                	xor    %edx,%edx
801009d5:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < min_int(old_len, 80); i++)
801009da:	83 c3 01             	add    $0x1,%ebx
801009dd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801009e0:	e8 db fb ff ff       	call   801005c0 <consputc.part.0>
801009e5:	39 fb                	cmp    %edi,%ebx
801009e7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801009ea:	7c dd                	jl     801009c9 <full_redraw_after_edit+0x99>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801009ec:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
  if (panicked)
801009f1:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801009f7:	01 c8                	add    %ecx,%eax
801009f9:	83 e0 7f             	and    $0x7f,%eax
801009fc:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
80100a03:	85 d2                	test   %edx,%edx
80100a05:	74 11                	je     80100a18 <full_redraw_after_edit+0xe8>
80100a07:	fa                   	cli
    for (;;)
80100a08:	eb fe                	jmp    80100a08 <full_redraw_after_edit+0xd8>
80100a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a10:	fa                   	cli
80100a11:	eb fe                	jmp    80100a11 <full_redraw_after_edit+0xe1>
80100a13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a18:	31 d2                	xor    %edx,%edx
80100a1a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100a1d:	e8 9e fb ff ff       	call   801005c0 <consputc.part.0>
  for (int i = 0; i < old_len; i++)
80100a22:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100a25:	83 c1 01             	add    $0x1,%ecx
80100a28:	39 ce                	cmp    %ecx,%esi
80100a2a:	7f c0                	jg     801009ec <full_redraw_after_edit+0xbc>
  int moves_left = old_len - new_cursor_off;
80100a2c:	8b 1d 04 ff 10 80    	mov    0x8010ff04,%ebx
  int new_cursor_off = (int)input.e - (int)input.w;
80100a32:	2b 35 08 ff 10 80    	sub    0x8010ff08,%esi
  int moves_left = old_len - new_cursor_off;
80100a38:	01 f3                	add    %esi,%ebx
  for (int i = 0; i < moves_left; i++)
80100a3a:	31 f6                	xor    %esi,%esi
80100a3c:	85 db                	test   %ebx,%ebx
80100a3e:	7e 23                	jle    80100a63 <full_redraw_after_edit+0x133>
  if (panicked)
80100a40:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100a45:	85 c0                	test   %eax,%eax
80100a47:	74 07                	je     80100a50 <full_redraw_after_edit+0x120>
80100a49:	fa                   	cli
    for (;;)
80100a4a:	eb fe                	jmp    80100a4a <full_redraw_after_edit+0x11a>
80100a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a50:	31 d2                	xor    %edx,%edx
80100a52:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
80100a57:	83 c6 01             	add    $0x1,%esi
80100a5a:	e8 61 fb ff ff       	call   801005c0 <consputc.part.0>
80100a5f:	39 f3                	cmp    %esi,%ebx
80100a61:	75 dd                	jne    80100a40 <full_redraw_after_edit+0x110>
}
80100a63:	83 c4 1c             	add    $0x1c,%esp
80100a66:	5b                   	pop    %ebx
80100a67:	5e                   	pop    %esi
80100a68:	5f                   	pop    %edi
80100a69:	5d                   	pop    %ebp
80100a6a:	c3                   	ret
80100a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100a70 <full_redraw_after_edit_len>:
{
80100a70:	55                   	push   %ebp
80100a71:	89 e5                	mov    %esp,%ebp
80100a73:	57                   	push   %edi
80100a74:	31 ff                	xor    %edi,%edi
80100a76:	56                   	push   %esi
80100a77:	53                   	push   %ebx
80100a78:	89 d3                	mov    %edx,%ebx
  if (old_cursor_off < 0)
80100a7a:	31 d2                	xor    %edx,%edx
80100a7c:	89 d6                	mov    %edx,%esi
{
80100a7e:	83 ec 0c             	sub    $0xc,%esp
  int old_cursor_off = (int)old_e - (int)input.w;
80100a81:	2b 05 04 ff 10 80    	sub    0x8010ff04,%eax
  if (old_cursor_off < 0)
80100a87:	85 c0                	test   %eax,%eax
80100a89:	0f 49 f0             	cmovns %eax,%esi
  for (int i = 0; i < old_cursor_off; i++)
80100a8c:	7e 25                	jle    80100ab3 <full_redraw_after_edit_len+0x43>
  if (panicked)
80100a8e:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100a93:	85 c0                	test   %eax,%eax
80100a95:	74 09                	je     80100aa0 <full_redraw_after_edit_len+0x30>
80100a97:	fa                   	cli
    for (;;)
80100a98:	eb fe                	jmp    80100a98 <full_redraw_after_edit_len+0x28>
80100a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100aa0:	31 d2                	xor    %edx,%edx
80100aa2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	e8 11 fb ff ff       	call   801005c0 <consputc.part.0>
80100aaf:	39 f7                	cmp    %esi,%edi
80100ab1:	7c db                	jl     80100a8e <full_redraw_after_edit_len+0x1e>
  if (old_len_before < 0)
80100ab3:	31 f6                	xor    %esi,%esi
80100ab5:	85 db                	test   %ebx,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80100ab7:	b8 50 00 00 00       	mov    $0x50,%eax
  if (old_len_before < 0)
80100abc:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
80100abf:	39 c6                	cmp    %eax,%esi
80100ac1:	0f 4f f0             	cmovg  %eax,%esi
  for (int i = 0; i < wipe; i++)
80100ac4:	31 ff                	xor    %edi,%edi
80100ac6:	85 db                	test   %ebx,%ebx
80100ac8:	7e 46                	jle    80100b10 <full_redraw_after_edit_len+0xa0>
  if (panicked)
80100aca:	8b 1d d8 01 11 80    	mov    0x801101d8,%ebx
80100ad0:	85 db                	test   %ebx,%ebx
80100ad2:	74 0c                	je     80100ae0 <full_redraw_after_edit_len+0x70>
80100ad4:	fa                   	cli
    for (;;)
80100ad5:	eb fe                	jmp    80100ad5 <full_redraw_after_edit_len+0x65>
80100ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ade:	00 
80100adf:	90                   	nop
80100ae0:	31 d2                	xor    %edx,%edx
80100ae2:	b8 20 00 00 00       	mov    $0x20,%eax
  for (int i = 0; i < wipe; i++)
80100ae7:	83 c7 01             	add    $0x1,%edi
80100aea:	e8 d1 fa ff ff       	call   801005c0 <consputc.part.0>
80100aef:	39 fe                	cmp    %edi,%esi
80100af1:	7f d7                	jg     80100aca <full_redraw_after_edit_len+0x5a>
  if (panicked)
80100af3:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
80100af9:	85 c9                	test   %ecx,%ecx
80100afb:	75 4b                	jne    80100b48 <full_redraw_after_edit_len+0xd8>
80100afd:	31 d2                	xor    %edx,%edx
80100aff:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < wipe; i++)
80100b04:	83 c3 01             	add    $0x1,%ebx
80100b07:	e8 b4 fa ff ff       	call   801005c0 <consputc.part.0>
80100b0c:	39 de                	cmp    %ebx,%esi
80100b0e:	7f e3                	jg     80100af3 <full_redraw_after_edit_len+0x83>
  int new_len = (int)input.real_end - (int)input.w;
80100b10:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80100b15:	8b 15 0c ff 10 80    	mov    0x8010ff0c,%edx
  if (new_len < 0)
80100b1b:	31 db                	xor    %ebx,%ebx
  for (int i = 0; i < new_len; i++)
80100b1d:	be 00 00 00 00       	mov    $0x0,%esi
  int new_len = (int)input.real_end - (int)input.w;
80100b22:	29 c2                	sub    %eax,%edx
  if (new_len < 0)
80100b24:	85 d2                	test   %edx,%edx
80100b26:	0f 49 da             	cmovns %edx,%ebx
  for (int i = 0; i < new_len; i++)
80100b29:	7e 3a                	jle    80100b65 <full_redraw_after_edit_len+0xf5>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80100b2b:	01 f0                	add    %esi,%eax
  if (panicked)
80100b2d:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80100b33:	83 e0 7f             	and    $0x7f,%eax
80100b36:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
80100b3d:	85 d2                	test   %edx,%edx
80100b3f:	74 0f                	je     80100b50 <full_redraw_after_edit_len+0xe0>
80100b41:	fa                   	cli
    for (;;)
80100b42:	eb fe                	jmp    80100b42 <full_redraw_after_edit_len+0xd2>
80100b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b48:	fa                   	cli
80100b49:	eb fe                	jmp    80100b49 <full_redraw_after_edit_len+0xd9>
80100b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100b50:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < new_len; i++)
80100b52:	83 c6 01             	add    $0x1,%esi
80100b55:	e8 66 fa ff ff       	call   801005c0 <consputc.part.0>
80100b5a:	39 f3                	cmp    %esi,%ebx
80100b5c:	7e 07                	jle    80100b65 <full_redraw_after_edit_len+0xf5>
  int new_cursor_off = (int)input.e - (int)input.w;
80100b5e:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80100b63:	eb c6                	jmp    80100b2b <full_redraw_after_edit_len+0xbb>
80100b65:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  if (new_cursor_off < 0)
80100b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  int new_cursor_off = (int)input.e - (int)input.w;
80100b6f:	2b 05 04 ff 10 80    	sub    0x8010ff04,%eax
  if (new_cursor_off < 0)
80100b75:	0f 48 c2             	cmovs  %edx,%eax
  for (int i = 0; i < moves_left; i++)
80100b78:	31 f6                	xor    %esi,%esi
  int moves_left = new_len - new_cursor_off;
80100b7a:	29 c3                	sub    %eax,%ebx
  for (int i = 0; i < moves_left; i++)
80100b7c:	85 db                	test   %ebx,%ebx
80100b7e:	7e 23                	jle    80100ba3 <full_redraw_after_edit_len+0x133>
  if (panicked)
80100b80:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100b85:	85 c0                	test   %eax,%eax
80100b87:	74 07                	je     80100b90 <full_redraw_after_edit_len+0x120>
80100b89:	fa                   	cli
    for (;;)
80100b8a:	eb fe                	jmp    80100b8a <full_redraw_after_edit_len+0x11a>
80100b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b90:	31 d2                	xor    %edx,%edx
80100b92:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
80100b97:	83 c6 01             	add    $0x1,%esi
80100b9a:	e8 21 fa ff ff       	call   801005c0 <consputc.part.0>
80100b9f:	39 f3                	cmp    %esi,%ebx
80100ba1:	75 dd                	jne    80100b80 <full_redraw_after_edit_len+0x110>
}
80100ba3:	83 c4 0c             	add    $0xc,%esp
80100ba6:	5b                   	pop    %ebx
80100ba7:	5e                   	pop    %esi
80100ba8:	5f                   	pop    %edi
80100ba9:	5d                   	pop    %ebp
80100baa:	c3                   	ret
80100bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100bb0 <replace_selection_with>:
{
80100bb0:	55                   	push   %ebp
80100bb1:	89 d1                	mov    %edx,%ecx
80100bb3:	89 e5                	mov    %esp,%ebp
80100bb5:	57                   	push   %edi
80100bb6:	56                   	push   %esi
80100bb7:	89 c6                	mov    %eax,%esi
80100bb9:	53                   	push   %ebx
80100bba:	83 ec 1c             	sub    $0x1c,%esp
  int a = input.sel_a, b = input.sel_b;
80100bbd:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80100bc3:	a1 18 01 11 80       	mov    0x80110118,%eax
  int old_len = (int)input.real_end - (int)input.w;
80100bc8:	8b 1d 0c ff 10 80    	mov    0x8010ff0c,%ebx
  uint old_e = input.e;
80100bce:	8b 3d 08 ff 10 80    	mov    0x8010ff08,%edi
  int old_len = (int)input.real_end - (int)input.w;
80100bd4:	2b 1d 04 ff 10 80    	sub    0x8010ff04,%ebx
  if (a > b)
80100bda:	39 c2                	cmp    %eax,%edx
80100bdc:	7f 3a                	jg     80100c18 <replace_selection_with+0x68>
  if (hi <= lo)
80100bde:	75 30                	jne    80100c10 <replace_selection_with+0x60>
  insert_at(lo, src, n);
80100be0:	89 f2                	mov    %esi,%edx
80100be2:	e8 99 f6 ff ff       	call   80100280 <insert_at>
  full_redraw_after_edit_len(old_e, old_len);
80100be7:	89 da                	mov    %ebx,%edx
80100be9:	89 f8                	mov    %edi,%eax
  input.sel_a = input.sel_b = -1;
80100beb:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80100bf2:	ff ff ff 
80100bf5:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80100bfc:	ff ff ff 
}
80100bff:	83 c4 1c             	add    $0x1c,%esp
80100c02:	5b                   	pop    %ebx
80100c03:	5e                   	pop    %esi
80100c04:	5f                   	pop    %edi
80100c05:	5d                   	pop    %ebp
  full_redraw_after_edit_len(old_e, old_len);
80100c06:	e9 65 fe ff ff       	jmp    80100a70 <full_redraw_after_edit_len>
80100c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c13:	89 d0                	mov    %edx,%eax
80100c15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100c18:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100c1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100c1e:	e8 5d f8 ff ff       	call   80100480 <delete_range.part.0>
80100c23:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c29:	eb b5                	jmp    80100be0 <replace_selection_with+0x30>
80100c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100c30 <cprintf>:
{
80100c30:	55                   	push   %ebp
80100c31:	89 e5                	mov    %esp,%ebp
80100c33:	57                   	push   %edi
80100c34:	56                   	push   %esi
80100c35:	53                   	push   %ebx
80100c36:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100c39:	8b 3d d4 01 11 80    	mov    0x801101d4,%edi
  if (fmt == 0)
80100c3f:	8b 75 08             	mov    0x8(%ebp),%esi
  if (locking)
80100c42:	85 ff                	test   %edi,%edi
80100c44:	0f 85 06 01 00 00    	jne    80100d50 <cprintf+0x120>
  if (fmt == 0)
80100c4a:	85 f6                	test   %esi,%esi
80100c4c:	0f 84 e0 01 00 00    	je     80100e32 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100c52:	0f b6 06             	movzbl (%esi),%eax
80100c55:	85 c0                	test   %eax,%eax
80100c57:	74 59                	je     80100cb2 <cprintf+0x82>
80100c59:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint *)(void *)(&fmt + 1);
80100c5c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100c5f:	31 db                	xor    %ebx,%ebx
    if (c != '%')
80100c61:	83 f8 25             	cmp    $0x25,%eax
80100c64:	75 5a                	jne    80100cc0 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100c66:	83 c3 01             	add    $0x1,%ebx
80100c69:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if (c == 0)
80100c6d:	85 ff                	test   %edi,%edi
80100c6f:	74 36                	je     80100ca7 <cprintf+0x77>
    switch (c)
80100c71:	83 ff 70             	cmp    $0x70,%edi
80100c74:	0f 84 b6 00 00 00    	je     80100d30 <cprintf+0x100>
80100c7a:	7f 74                	jg     80100cf0 <cprintf+0xc0>
80100c7c:	83 ff 25             	cmp    $0x25,%edi
80100c7f:	74 5e                	je     80100cdf <cprintf+0xaf>
80100c81:	83 ff 64             	cmp    $0x64,%edi
80100c84:	75 78                	jne    80100cfe <cprintf+0xce>
      printint(*argp++, 10, 1);
80100c86:	8b 01                	mov    (%ecx),%eax
80100c88:	8d 79 04             	lea    0x4(%ecx),%edi
80100c8b:	ba 0a 00 00 00       	mov    $0xa,%edx
80100c90:	b9 01 00 00 00       	mov    $0x1,%ecx
80100c95:	e8 06 fc ff ff       	call   801008a0 <printint>
80100c9a:	89 f9                	mov    %edi,%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100c9c:	83 c3 01             	add    $0x1,%ebx
80100c9f:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100ca3:	85 c0                	test   %eax,%eax
80100ca5:	75 ba                	jne    80100c61 <cprintf+0x31>
80100ca7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (locking)
80100caa:	85 ff                	test   %edi,%edi
80100cac:	0f 85 c1 00 00 00    	jne    80100d73 <cprintf+0x143>
}
80100cb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cb5:	5b                   	pop    %ebx
80100cb6:	5e                   	pop    %esi
80100cb7:	5f                   	pop    %edi
80100cb8:	5d                   	pop    %ebp
80100cb9:	c3                   	ret
80100cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (panicked)
80100cc0:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80100cc6:	85 ff                	test   %edi,%edi
80100cc8:	74 06                	je     80100cd0 <cprintf+0xa0>
80100cca:	fa                   	cli
    for (;;)
80100ccb:	eb fe                	jmp    80100ccb <cprintf+0x9b>
80100ccd:	8d 76 00             	lea    0x0(%esi),%esi
80100cd0:	31 d2                	xor    %edx,%edx
80100cd2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100cd5:	e8 e6 f8 ff ff       	call   801005c0 <consputc.part.0>
      continue;
80100cda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100cdd:	eb bd                	jmp    80100c9c <cprintf+0x6c>
  if (panicked)
80100cdf:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80100ce5:	85 ff                	test   %edi,%edi
80100ce7:	0f 84 13 01 00 00    	je     80100e00 <cprintf+0x1d0>
80100ced:	fa                   	cli
    for (;;)
80100cee:	eb fe                	jmp    80100cee <cprintf+0xbe>
    switch (c)
80100cf0:	83 ff 73             	cmp    $0x73,%edi
80100cf3:	0f 84 8f 00 00 00    	je     80100d88 <cprintf+0x158>
80100cf9:	83 ff 78             	cmp    $0x78,%edi
80100cfc:	74 32                	je     80100d30 <cprintf+0x100>
  if (panicked)
80100cfe:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100d04:	85 d2                	test   %edx,%edx
80100d06:	0f 85 e8 00 00 00    	jne    80100df4 <cprintf+0x1c4>
80100d0c:	31 d2                	xor    %edx,%edx
80100d0e:	b8 25 00 00 00       	mov    $0x25,%eax
80100d13:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100d16:	e8 a5 f8 ff ff       	call   801005c0 <consputc.part.0>
80100d1b:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80100d20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100d23:	85 c0                	test   %eax,%eax
80100d25:	0f 84 ec 00 00 00    	je     80100e17 <cprintf+0x1e7>
80100d2b:	fa                   	cli
    for (;;)
80100d2c:	eb fe                	jmp    80100d2c <cprintf+0xfc>
80100d2e:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
80100d30:	8b 01                	mov    (%ecx),%eax
80100d32:	8d 79 04             	lea    0x4(%ecx),%edi
80100d35:	ba 10 00 00 00       	mov    $0x10,%edx
80100d3a:	31 c9                	xor    %ecx,%ecx
80100d3c:	e8 5f fb ff ff       	call   801008a0 <printint>
80100d41:	89 f9                	mov    %edi,%ecx
      break;
80100d43:	e9 54 ff ff ff       	jmp    80100c9c <cprintf+0x6c>
80100d48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d4f:	00 
    acquire(&cons.lock);
80100d50:	83 ec 0c             	sub    $0xc,%esp
80100d53:	68 a0 01 11 80       	push   $0x801101a0
80100d58:	e8 13 4b 00 00       	call   80105870 <acquire>
  if (fmt == 0)
80100d5d:	83 c4 10             	add    $0x10,%esp
80100d60:	85 f6                	test   %esi,%esi
80100d62:	0f 84 ca 00 00 00    	je     80100e32 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100d68:	0f b6 06             	movzbl (%esi),%eax
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	0f 85 e6 fe ff ff    	jne    80100c59 <cprintf+0x29>
    release(&cons.lock);
80100d73:	83 ec 0c             	sub    $0xc,%esp
80100d76:	68 a0 01 11 80       	push   $0x801101a0
80100d7b:	e8 90 4a 00 00       	call   80105810 <release>
80100d80:	83 c4 10             	add    $0x10,%esp
80100d83:	e9 2a ff ff ff       	jmp    80100cb2 <cprintf+0x82>
      if ((s = (char *)*argp++) == 0)
80100d88:	8b 39                	mov    (%ecx),%edi
80100d8a:	8d 51 04             	lea    0x4(%ecx),%edx
80100d8d:	85 ff                	test   %edi,%edi
80100d8f:	74 27                	je     80100db8 <cprintf+0x188>
      for (; *s; s++)
80100d91:	0f be 07             	movsbl (%edi),%eax
80100d94:	84 c0                	test   %al,%al
80100d96:	0f 84 8f 00 00 00    	je     80100e2b <cprintf+0x1fb>
80100d9c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100d9f:	89 fb                	mov    %edi,%ebx
80100da1:	89 f7                	mov    %esi,%edi
80100da3:	89 d6                	mov    %edx,%esi
  if (panicked)
80100da5:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100dab:	85 d2                	test   %edx,%edx
80100dad:	74 26                	je     80100dd5 <cprintf+0x1a5>
80100daf:	fa                   	cli
    for (;;)
80100db0:	eb fe                	jmp    80100db0 <cprintf+0x180>
80100db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
80100db8:	bf 98 84 10 80       	mov    $0x80108498,%edi
80100dbd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100dc0:	b8 28 00 00 00       	mov    $0x28,%eax
80100dc5:	89 fb                	mov    %edi,%ebx
80100dc7:	89 f7                	mov    %esi,%edi
80100dc9:	89 d6                	mov    %edx,%esi
  if (panicked)
80100dcb:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80100dd1:	85 d2                	test   %edx,%edx
80100dd3:	75 da                	jne    80100daf <cprintf+0x17f>
80100dd5:	31 d2                	xor    %edx,%edx
      for (; *s; s++)
80100dd7:	83 c3 01             	add    $0x1,%ebx
80100dda:	e8 e1 f7 ff ff       	call   801005c0 <consputc.part.0>
80100ddf:	0f be 03             	movsbl (%ebx),%eax
80100de2:	84 c0                	test   %al,%al
80100de4:	75 bf                	jne    80100da5 <cprintf+0x175>
      if ((s = (char *)*argp++) == 0)
80100de6:	89 f2                	mov    %esi,%edx
80100de8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100deb:	89 fe                	mov    %edi,%esi
80100ded:	89 d1                	mov    %edx,%ecx
80100def:	e9 a8 fe ff ff       	jmp    80100c9c <cprintf+0x6c>
80100df4:	fa                   	cli
    for (;;)
80100df5:	eb fe                	jmp    80100df5 <cprintf+0x1c5>
80100df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100dfe:	00 
80100dff:	90                   	nop
80100e00:	31 d2                	xor    %edx,%edx
80100e02:	b8 25 00 00 00       	mov    $0x25,%eax
80100e07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100e0a:	e8 b1 f7 ff ff       	call   801005c0 <consputc.part.0>
      break;
80100e0f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100e12:	e9 85 fe ff ff       	jmp    80100c9c <cprintf+0x6c>
80100e17:	31 d2                	xor    %edx,%edx
80100e19:	89 f8                	mov    %edi,%eax
80100e1b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100e1e:	e8 9d f7 ff ff       	call   801005c0 <consputc.part.0>
      break;
80100e23:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100e26:	e9 71 fe ff ff       	jmp    80100c9c <cprintf+0x6c>
      if ((s = (char *)*argp++) == 0)
80100e2b:	89 d1                	mov    %edx,%ecx
80100e2d:	e9 6a fe ff ff       	jmp    80100c9c <cprintf+0x6c>
    panic("null fmt");
80100e32:	83 ec 0c             	sub    $0xc,%esp
80100e35:	68 9f 84 10 80       	push   $0x8010849f
80100e3a:	e8 01 f7 ff ff       	call   80100540 <panic>
80100e3f:	90                   	nop

80100e40 <consoleintr>:
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 48             	sub    $0x48,%esp
80100e49:	8b 45 08             	mov    0x8(%ebp),%eax
80100e4c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  acquire(&cons.lock);
80100e4f:	68 a0 01 11 80       	push   $0x801101a0
80100e54:	e8 17 4a 00 00       	call   80105870 <acquire>
  while ((c = getc()) >= 0)
80100e59:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100e5c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  while ((c = getc()) >= 0)
80100e63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e66:	ff d0                	call   *%eax
80100e68:	89 c3                	mov    %eax,%ebx
80100e6a:	85 c0                	test   %eax,%eax
80100e6c:	0f 88 ee 00 00 00    	js     80100f60 <consoleintr+0x120>
    switch (c)
80100e72:	83 fb 1a             	cmp    $0x1a,%ebx
80100e75:	7f 19                	jg     80100e90 <consoleintr+0x50>
80100e77:	85 db                	test   %ebx,%ebx
80100e79:	74 e8                	je     80100e63 <consoleintr+0x23>
80100e7b:	83 fb 1a             	cmp    $0x1a,%ebx
80100e7e:	0f 87 04 01 00 00    	ja     80100f88 <consoleintr+0x148>
80100e84:	ff 24 9d 40 89 10 80 	jmp    *-0x7fef76c0(,%ebx,4)
80100e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e90:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100e96:	0f 84 34 01 00 00    	je     80100fd0 <consoleintr+0x190>
80100e9c:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100ea2:	0f 84 88 01 00 00    	je     80101030 <consoleintr+0x1f0>
80100ea8:	83 fb 7f             	cmp    $0x7f,%ebx
80100eab:	0f 85 d7 00 00 00    	jne    80100f88 <consoleintr+0x148>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80100eb1:	8b 15 14 01 11 80    	mov    0x80110114,%edx
      while (input.e != input.w &&
80100eb7:	8b 3d 04 ff 10 80    	mov    0x8010ff04,%edi
80100ebd:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80100ec3:	85 d2                	test   %edx,%edx
80100ec5:	0f 88 39 05 00 00    	js     80101404 <consoleintr+0x5c4>
80100ecb:	a1 18 01 11 80       	mov    0x80110118,%eax
80100ed0:	85 c0                	test   %eax,%eax
80100ed2:	0f 88 2c 05 00 00    	js     80101404 <consoleintr+0x5c4>
80100ed8:	39 d0                	cmp    %edx,%eax
80100eda:	0f 84 24 05 00 00    	je     80101404 <consoleintr+0x5c4>
        int old_len = (int)input.real_end - (int)input.w; // BEFORE delete
80100ee0:	8b 35 0c ff 10 80    	mov    0x8010ff0c,%esi
80100ee6:	29 fe                	sub    %edi,%esi
  if (a > b)
80100ee8:	39 d0                	cmp    %edx,%eax
80100eea:	7c 06                	jl     80100ef2 <consoleintr+0xb2>
80100eec:	89 d1                	mov    %edx,%ecx
  int a = input.sel_a, b = input.sel_b;
80100eee:	89 c2                	mov    %eax,%edx
80100ef0:	89 c8                	mov    %ecx,%eax
80100ef2:	e8 89 f5 ff ff       	call   80100480 <delete_range.part.0>
        full_redraw_after_edit_len(old_e, old_len);
80100ef7:	89 f2                	mov    %esi,%edx
80100ef9:	89 d8                	mov    %ebx,%eax
  input.sel_a = input.sel_b = -1;
80100efb:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80100f02:	ff ff ff 
80100f05:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80100f0c:	ff ff ff 
        full_redraw_after_edit_len(old_e, old_len);
80100f0f:	e8 5c fb ff ff       	call   80100a70 <full_redraw_after_edit_len>
        break;
80100f14:	e9 4a ff ff ff       	jmp    80100e63 <consoleintr+0x23>
80100f19:	31 d2                	xor    %edx,%edx
80100f1b:	b8 00 01 00 00       	mov    $0x100,%eax
80100f20:	e8 9b f6 ff ff       	call   801005c0 <consputc.part.0>
      while (input.e != input.w &&
80100f25:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100f2a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100f30:	0f 84 aa 07 00 00    	je     801016e0 <consoleintr+0x8a0>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
80100f36:	8d 50 ff             	lea    -0x1(%eax),%edx
80100f39:	89 d1                	mov    %edx,%ecx
80100f3b:	83 e1 7f             	and    $0x7f,%ecx
      while (input.e != input.w &&
80100f3e:	80 b9 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%ecx)
80100f45:	0f 84 95 07 00 00    	je     801016e0 <consoleintr+0x8a0>
  if (panicked)
80100f4b:	a1 d8 01 11 80       	mov    0x801101d8,%eax
        input.e--;
80100f50:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
  if (panicked)
80100f56:	85 c0                	test   %eax,%eax
80100f58:	74 bf                	je     80100f19 <consoleintr+0xd9>
80100f5a:	fa                   	cli
    for (;;)
80100f5b:	eb fe                	jmp    80100f5b <consoleintr+0x11b>
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100f60:	83 ec 0c             	sub    $0xc,%esp
80100f63:	68 a0 01 11 80       	push   $0x801101a0
80100f68:	e8 a3 48 00 00       	call   80105810 <release>
  if (doprocdump)
80100f6d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	85 c0                	test   %eax,%eax
80100f75:	0f 85 15 01 00 00    	jne    80101090 <consoleintr+0x250>
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
80100f82:	c3                   	ret
80100f83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80100f88:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80100f8e:	a1 18 01 11 80       	mov    0x80110118,%eax
80100f93:	89 d6                	mov    %edx,%esi
80100f95:	09 c6                	or     %eax,%esi
80100f97:	0f 88 6a 06 00 00    	js     80101607 <consoleintr+0x7c7>
80100f9d:	39 c2                	cmp    %eax,%edx
80100f9f:	0f 84 62 06 00 00    	je     80101607 <consoleintr+0x7c7>
        if (ch >= 32 && ch != 0x7f)
80100fa5:	80 fb 1f             	cmp    $0x1f,%bl
80100fa8:	0f 86 b5 fe ff ff    	jbe    80100e63 <consoleintr+0x23>
80100fae:	80 fb 7f             	cmp    $0x7f,%bl
80100fb1:	0f 84 ac fe ff ff    	je     80100e63 <consoleintr+0x23>
          replace_selection_with(one, 1); // handles delete+insert+redraw+deselect
80100fb7:	ba 01 00 00 00       	mov    $0x1,%edx
80100fbc:	8d 45 e7             	lea    -0x19(%ebp),%eax
          char one[1] = {(char)ch};
80100fbf:	88 5d e7             	mov    %bl,-0x19(%ebp)
          replace_selection_with(one, 1); // handles delete+insert+redraw+deselect
80100fc2:	e8 e9 fb ff ff       	call   80100bb0 <replace_selection_with>
80100fc7:	e9 97 fe ff ff       	jmp    80100e63 <consoleintr+0x23>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80100fd0:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80100fd6:	a1 18 01 11 80       	mov    0x80110118,%eax
80100fdb:	89 d6                	mov    %edx,%esi
80100fdd:	09 c6                	or     %eax,%esi
80100fdf:	78 22                	js     80101003 <consoleintr+0x1c3>
80100fe1:	39 c2                	cmp    %eax,%edx
80100fe3:	74 1e                	je     80101003 <consoleintr+0x1c3>
    full_redraw_after_edit(old_e);
80100fe5:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
80100fea:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80100ff1:	ff ff ff 
80100ff4:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80100ffb:	ff ff ff 
    full_redraw_after_edit(old_e);
80100ffe:	e8 2d f9 ff ff       	call   80100930 <full_redraw_after_edit>
      if (input.e > input.w)
80101003:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101008:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010100e:	0f 83 4f fe ff ff    	jae    80100e63 <consoleintr+0x23>
  if (panicked)
80101014:	8b 1d d8 01 11 80    	mov    0x801101d8,%ebx
        input.e--;
8010101a:	83 e8 01             	sub    $0x1,%eax
8010101d:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if (panicked)
80101022:	85 db                	test   %ebx,%ebx
80101024:	0f 84 cc 05 00 00    	je     801015f6 <consoleintr+0x7b6>
8010102a:	fa                   	cli
    for (;;)
8010102b:	eb fe                	jmp    8010102b <consoleintr+0x1eb>
8010102d:	8d 76 00             	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101030:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80101036:	a1 18 01 11 80       	mov    0x80110118,%eax
8010103b:	89 d7                	mov    %edx,%edi
8010103d:	09 c7                	or     %eax,%edi
8010103f:	78 22                	js     80101063 <consoleintr+0x223>
80101041:	39 c2                	cmp    %eax,%edx
80101043:	74 1e                	je     80101063 <consoleintr+0x223>
    full_redraw_after_edit(old_e);
80101045:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
8010104a:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80101051:	ff ff ff 
80101054:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
8010105b:	ff ff ff 
    full_redraw_after_edit(old_e);
8010105e:	e8 cd f8 ff ff       	call   80100930 <full_redraw_after_edit>
      if (input.e < input.real_end)
80101063:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101068:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
8010106e:	0f 83 ef fd ff ff    	jae    80100e63 <consoleintr+0x23>
  if (panicked)
80101074:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
        char ch = input.buf[input.e % INPUT_BUF];
8010107a:	83 e0 7f             	and    $0x7f,%eax
8010107d:	0f be 90 80 fe 10 80 	movsbl -0x7fef0180(%eax),%edx
  if (panicked)
80101084:	85 c9                	test   %ecx,%ecx
80101086:	0f 84 54 05 00 00    	je     801015e0 <consoleintr+0x7a0>
8010108c:	fa                   	cli
    for (;;)
8010108d:	eb fe                	jmp    8010108d <consoleintr+0x24d>
8010108f:	90                   	nop
}
80101090:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101093:	5b                   	pop    %ebx
80101094:	5e                   	pop    %esi
80101095:	5f                   	pop    %edi
80101096:	5d                   	pop    %ebp
    procdump();
80101097:	e9 f4 43 00 00       	jmp    80105490 <procdump>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010109c:	8b 15 14 01 11 80    	mov    0x80110114,%edx
801010a2:	a1 18 01 11 80       	mov    0x80110118,%eax
801010a7:	89 d7                	mov    %edx,%edi
801010a9:	09 c7                	or     %eax,%edi
801010ab:	78 22                	js     801010cf <consoleintr+0x28f>
801010ad:	39 c2                	cmp    %eax,%edx
801010af:	74 1e                	je     801010cf <consoleintr+0x28f>
    full_redraw_after_edit(old_e);
801010b1:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
801010b6:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
801010bd:	ff ff ff 
801010c0:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
801010c7:	ff ff ff 
    full_redraw_after_edit(old_e);
801010ca:	e8 61 f8 ff ff       	call   80100930 <full_redraw_after_edit>
      if (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] == ' ')
801010cf:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801010d4:	89 c2                	mov    %eax,%edx
801010d6:	85 c0                	test   %eax,%eax
801010d8:	0f 84 85 fd ff ff    	je     80100e63 <consoleintr+0x23>
801010de:	8d 48 ff             	lea    -0x1(%eax),%ecx
801010e1:	83 e1 7f             	and    $0x7f,%ecx
801010e4:	80 b9 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%ecx)
801010eb:	0f 84 93 07 00 00    	je     80101884 <consoleintr+0xa44>
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
801010f1:	83 e2 7f             	and    $0x7f,%edx
801010f4:	80 ba 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%edx)
801010fb:	0f 85 0f 07 00 00    	jne    80101810 <consoleintr+0x9d0>
  if (panicked)
80101101:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
80101107:	85 d2                	test   %edx,%edx
80101109:	74 05                	je     80101110 <consoleintr+0x2d0>
8010110b:	fa                   	cli
    for (;;)
8010110c:	eb fe                	jmp    8010110c <consoleintr+0x2cc>
8010110e:	66 90                	xchg   %ax,%ax
80101110:	31 d2                	xor    %edx,%edx
80101112:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101117:	e8 a4 f4 ff ff       	call   801005c0 <consputc.part.0>
        input.e--;
8010111c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101121:	8d 50 ff             	lea    -0x1(%eax),%edx
80101124:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
8010112a:	89 d0                	mov    %edx,%eax
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
8010112c:	85 d2                	test   %edx,%edx
8010112e:	75 c1                	jne    801010f1 <consoleintr+0x2b1>
80101130:	e9 2e fd ff ff       	jmp    80100e63 <consoleintr+0x23>
80101135:	8d 76 00             	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101138:	a1 14 01 11 80       	mov    0x80110114,%eax
8010113d:	85 c0                	test   %eax,%eax
8010113f:	0f 88 1e fd ff ff    	js     80100e63 <consoleintr+0x23>
80101145:	8b 0d 18 01 11 80    	mov    0x80110118,%ecx
8010114b:	85 c9                	test   %ecx,%ecx
8010114d:	0f 88 10 fd ff ff    	js     80100e63 <consoleintr+0x23>
80101153:	39 c8                	cmp    %ecx,%eax
80101155:	0f 84 08 fd ff ff    	je     80100e63 <consoleintr+0x23>
  if (a > b)
8010115b:	0f 8f ff 06 00 00    	jg     80101860 <consoleintr+0xa20>
        int n = hi - lo;
80101161:	29 c1                	sub    %eax,%ecx
        if (n > INPUT_BUF)
80101163:	ba 80 00 00 00       	mov    $0x80,%edx
        int n = hi - lo;
80101168:	89 cb                	mov    %ecx,%ebx
        if (n > INPUT_BUF)
8010116a:	39 d1                	cmp    %edx,%ecx
  int a = input.sel_a, b = input.sel_b;
8010116c:	89 c1                	mov    %eax,%ecx
        if (n > INPUT_BUF)
8010116e:	0f 4f da             	cmovg  %edx,%ebx
  int a = input.sel_a, b = input.sel_b;
80101171:	31 c0                	xor    %eax,%eax
80101173:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
80101178:	8d 14 01             	lea    (%ecx,%eax,1),%edx
        for (int i = 0; i < n; ++i)
8010117b:	83 c0 01             	add    $0x1,%eax
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
8010117e:	83 e2 7f             	and    $0x7f,%edx
80101181:	0f b6 92 80 fe 10 80 	movzbl -0x7fef0180(%edx),%edx
80101188:	88 90 1b 01 11 80    	mov    %dl,-0x7feefee5(%eax)
        for (int i = 0; i < n; ++i)
8010118e:	39 d8                	cmp    %ebx,%eax
80101190:	7c e6                	jl     80101178 <consoleintr+0x338>
        input.clip_len = n;
80101192:	89 1d 9c 01 11 80    	mov    %ebx,0x8011019c
80101198:	e9 c6 fc ff ff       	jmp    80100e63 <consoleintr+0x23>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010119d:	8b 15 14 01 11 80    	mov    0x80110114,%edx
801011a3:	a1 18 01 11 80       	mov    0x80110118,%eax
801011a8:	89 d7                	mov    %edx,%edi
801011aa:	09 c7                	or     %eax,%edi
801011ac:	78 22                	js     801011d0 <consoleintr+0x390>
801011ae:	39 c2                	cmp    %eax,%edx
801011b0:	74 1e                	je     801011d0 <consoleintr+0x390>
    full_redraw_after_edit(old_e);
801011b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
801011b7:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
801011be:	ff ff ff 
801011c1:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
801011c8:	ff ff ff 
    full_redraw_after_edit(old_e);
801011cb:	e8 60 f7 ff ff       	call   80100930 <full_redraw_after_edit>
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801011d0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801011d5:	89 c2                	mov    %eax,%edx
801011d7:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
801011dd:	0f 83 80 fc ff ff    	jae    80100e63 <consoleintr+0x23>
801011e3:	83 e2 7f             	and    $0x7f,%edx
801011e6:	0f be 92 80 fe 10 80 	movsbl -0x7fef0180(%edx),%edx
801011ed:	80 fa 0a             	cmp    $0xa,%dl
801011f0:	0f 84 51 03 00 00    	je     80101547 <consoleintr+0x707>
801011f6:	80 fa 20             	cmp    $0x20,%dl
801011f9:	0f 84 48 03 00 00    	je     80101547 <consoleintr+0x707>
  if (panicked)
801011ff:	8b 35 d8 01 11 80    	mov    0x801101d8,%esi
80101205:	85 f6                	test   %esi,%esi
80101207:	0f 84 63 03 00 00    	je     80101570 <consoleintr+0x730>
8010120d:	fa                   	cli
    for (;;)
8010120e:	eb fe                	jmp    8010120e <consoleintr+0x3ce>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101210:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80101216:	a1 18 01 11 80       	mov    0x80110118,%eax
8010121b:	89 d6                	mov    %edx,%esi
8010121d:	09 c6                	or     %eax,%esi
8010121f:	78 22                	js     80101243 <consoleintr+0x403>
80101221:	39 c2                	cmp    %eax,%edx
80101223:	74 1e                	je     80101243 <consoleintr+0x403>
    full_redraw_after_edit(old_e);
80101225:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
8010122a:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80101231:	ff ff ff 
80101234:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
8010123b:	ff ff ff 
    full_redraw_after_edit(old_e);
8010123e:	e8 ed f6 ff ff       	call   80100930 <full_redraw_after_edit>
      if (input.real_end > input.w)
80101243:	8b 1d 0c ff 10 80    	mov    0x8010ff0c,%ebx
80101249:	8b 35 04 ff 10 80    	mov    0x8010ff04,%esi
8010124f:	39 de                	cmp    %ebx,%esi
80101251:	0f 83 0c fc ff ff    	jae    80100e63 <consoleintr+0x23>
        for (uint i = input.w; i < input.real_end; i++)
80101257:	89 f0                	mov    %esi,%eax
        int max_t = -1, idx = -1;
80101259:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
8010125e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80101263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          int t = input.insert_order[i % INPUT_BUF];
80101268:	89 c2                	mov    %eax,%edx
8010126a:	83 e2 7f             	and    $0x7f,%edx
8010126d:	8b 14 95 10 ff 10 80 	mov    -0x7fef00f0(,%edx,4),%edx
          if (t > max_t)
80101274:	39 fa                	cmp    %edi,%edx
80101276:	7e 04                	jle    8010127c <consoleintr+0x43c>
            idx = (int)i;
80101278:	89 c1                	mov    %eax,%ecx
            max_t = t;
8010127a:	89 d7                	mov    %edx,%edi
        for (uint i = input.w; i < input.real_end; i++)
8010127c:	83 c0 01             	add    $0x1,%eax
8010127f:	39 c3                	cmp    %eax,%ebx
80101281:	75 e5                	jne    80101268 <consoleintr+0x428>
        if (idx >= 0)
80101283:	85 c9                	test   %ecx,%ecx
80101285:	0f 88 d8 fb ff ff    	js     80100e63 <consoleintr+0x23>
          int old_e = (int)input.e;
8010128b:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
          for (int i = idx; i < old_real_end - 1; i++)
80101291:	8d 7b ff             	lea    -0x1(%ebx),%edi
80101294:	89 c8                	mov    %ecx,%eax
          int old_e = (int)input.e;
80101296:	89 55 cc             	mov    %edx,-0x34(%ebp)
          for (int i = idx; i < old_real_end - 1; i++)
80101299:	39 f9                	cmp    %edi,%ecx
8010129b:	7d 3e                	jge    801012db <consoleintr+0x49b>
8010129d:	89 5d c8             	mov    %ebx,-0x38(%ebp)
801012a0:	89 75 c4             	mov    %esi,-0x3c(%ebp)
801012a3:	89 55 c0             	mov    %edx,-0x40(%ebp)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801012a6:	89 c3                	mov    %eax,%ebx
801012a8:	83 c0 01             	add    $0x1,%eax
801012ab:	89 c6                	mov    %eax,%esi
801012ad:	83 e3 7f             	and    $0x7f,%ebx
801012b0:	83 e6 7f             	and    $0x7f,%esi
801012b3:	0f b6 96 80 fe 10 80 	movzbl -0x7fef0180(%esi),%edx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
801012ba:	8b 34 b5 10 ff 10 80 	mov    -0x7fef00f0(,%esi,4),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801012c1:	88 93 80 fe 10 80    	mov    %dl,-0x7fef0180(%ebx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
801012c7:	89 34 9d 10 ff 10 80 	mov    %esi,-0x7fef00f0(,%ebx,4)
          for (int i = idx; i < old_real_end - 1; i++)
801012ce:	39 f8                	cmp    %edi,%eax
801012d0:	75 d4                	jne    801012a6 <consoleintr+0x466>
801012d2:	8b 5d c8             	mov    -0x38(%ebp),%ebx
801012d5:	8b 75 c4             	mov    -0x3c(%ebp),%esi
801012d8:	8b 55 c0             	mov    -0x40(%ebp),%edx
          input.real_end--;
801012db:	89 3d 0c ff 10 80    	mov    %edi,0x8010ff0c
          if ((int)input.e > idx)
801012e1:	39 d1                	cmp    %edx,%ecx
801012e3:	7d 09                	jge    801012ee <consoleintr+0x4ae>
            input.e--;
801012e5:	83 ea 01             	sub    $0x1,%edx
801012e8:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          if (input.e < input.w)
801012ee:	39 f2                	cmp    %esi,%edx
801012f0:	73 08                	jae    801012fa <consoleintr+0x4ba>
            input.e = input.w;
801012f2:	89 35 08 ff 10 80    	mov    %esi,0x8010ff08
801012f8:	89 f2                	mov    %esi,%edx
          if (input.e > input.real_end)
801012fa:	39 d7                	cmp    %edx,%edi
801012fc:	73 08                	jae    80101306 <consoleintr+0x4c6>
            input.e = input.real_end;
801012fe:	89 3d 08 ff 10 80    	mov    %edi,0x8010ff08
80101304:	89 fa                	mov    %edi,%edx
          int old_cursor_off = old_e - (int)input.w;
80101306:	8b 45 cc             	mov    -0x34(%ebp),%eax
          if (old_cursor_off < 0)
80101309:	31 c9                	xor    %ecx,%ecx
          int old_cursor_off = old_e - (int)input.w;
8010130b:	29 f0                	sub    %esi,%eax
          if (old_cursor_off < 0)
8010130d:	85 c0                	test   %eax,%eax
8010130f:	0f 49 c8             	cmovns %eax,%ecx
80101312:	89 4d cc             	mov    %ecx,-0x34(%ebp)
          for (int i = 0; i < old_cursor_off; i++)
80101315:	b9 00 00 00 00       	mov    $0x0,%ecx
8010131a:	0f 8e c2 05 00 00    	jle    801018e2 <consoleintr+0xaa2>
80101320:	89 5d c8             	mov    %ebx,-0x38(%ebp)
80101323:	89 cb                	mov    %ecx,%ebx
80101325:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80101328:	89 d7                	mov    %edx,%edi
  if (panicked)
8010132a:	a1 d8 01 11 80       	mov    0x801101d8,%eax
8010132f:	85 c0                	test   %eax,%eax
80101331:	0f 84 89 05 00 00    	je     801018c0 <consoleintr+0xa80>
80101337:	fa                   	cli
    for (;;)
80101338:	eb fe                	jmp    80101338 <consoleintr+0x4f8>
8010133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (input.clip_len <= 0)
80101340:	8b 0d 9c 01 11 80    	mov    0x8011019c,%ecx
80101346:	85 c9                	test   %ecx,%ecx
80101348:	0f 8e 15 fb ff ff    	jle    80100e63 <consoleintr+0x23>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010134e:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80101354:	a1 18 01 11 80       	mov    0x80110118,%eax
80101359:	89 d7                	mov    %edx,%edi
8010135b:	09 c7                	or     %eax,%edi
8010135d:	0f 88 4d 01 00 00    	js     801014b0 <consoleintr+0x670>
80101363:	39 c2                	cmp    %eax,%edx
80101365:	0f 84 45 01 00 00    	je     801014b0 <consoleintr+0x670>
        replace_selection_with(input.clip, input.clip_len);
8010136b:	89 ca                	mov    %ecx,%edx
8010136d:	b8 1c 01 11 80       	mov    $0x8011011c,%eax
80101372:	e8 39 f8 ff ff       	call   80100bb0 <replace_selection_with>
80101377:	e9 e7 fa ff ff       	jmp    80100e63 <consoleintr+0x23>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010137c:	8b 15 14 01 11 80    	mov    0x80110114,%edx
80101382:	a1 18 01 11 80       	mov    0x80110118,%eax
80101387:	89 d7                	mov    %edx,%edi
80101389:	09 c7                	or     %eax,%edi
8010138b:	78 22                	js     801013af <consoleintr+0x56f>
8010138d:	39 c2                	cmp    %eax,%edx
8010138f:	74 1e                	je     801013af <consoleintr+0x56f>
    full_redraw_after_edit(old_e);
80101391:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  input.sel_a = input.sel_b = -1;
80101396:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
8010139d:	ff ff ff 
801013a0:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
801013a7:	ff ff ff 
    full_redraw_after_edit(old_e);
801013aa:	e8 81 f5 ff ff       	call   80100930 <full_redraw_after_edit>
      doprocdump = 1;
801013af:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
801013b6:	e9 a8 fa ff ff       	jmp    80100e63 <consoleintr+0x23>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801013bb:	8b 1d 14 01 11 80    	mov    0x80110114,%ebx
      while (input.e != input.w &&
801013c1:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801013c7:	85 db                	test   %ebx,%ebx
801013c9:	0f 88 d1 01 00 00    	js     801015a0 <consoleintr+0x760>
801013cf:	a1 18 01 11 80       	mov    0x80110118,%eax
801013d4:	85 c0                	test   %eax,%eax
801013d6:	0f 88 26 01 00 00    	js     80101502 <consoleintr+0x6c2>
801013dc:	39 c3                	cmp    %eax,%ebx
801013de:	0f 84 1e 01 00 00    	je     80101502 <consoleintr+0x6c2>
  input.sel_a = input.sel_b = -1;
801013e4:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
801013eb:	ff ff ff 
        full_redraw_after_edit(old_e); // remove highlight
801013ee:	89 d0                	mov    %edx,%eax
  input.sel_a = input.sel_b = -1;
801013f0:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
801013f7:	ff ff ff 
        full_redraw_after_edit(old_e); // remove highlight
801013fa:	e8 31 f5 ff ff       	call   80100930 <full_redraw_after_edit>
        break;
801013ff:	e9 5f fa ff ff       	jmp    80100e63 <consoleintr+0x23>
      if (input.e != input.w)
80101404:	39 df                	cmp    %ebx,%edi
80101406:	0f 84 57 fa ff ff    	je     80100e63 <consoleintr+0x23>
        if (input.e == input.real_end)
8010140c:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
          input.e--;
80101412:	8d 53 ff             	lea    -0x1(%ebx),%edx
80101415:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          input.real_end--;
8010141b:	8d 71 ff             	lea    -0x1(%ecx),%esi
        if (input.e == input.real_end)
8010141e:	39 d9                	cmp    %ebx,%ecx
80101420:	0f 84 9a 02 00 00    	je     801016c0 <consoleintr+0x880>
          for (uint i = input.e; i < input.real_end - 1; i++)
80101426:	89 d0                	mov    %edx,%eax
80101428:	39 f2                	cmp    %esi,%edx
8010142a:	73 41                	jae    8010146d <consoleintr+0x62d>
8010142c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
8010142f:	89 55 c8             	mov    %edx,-0x38(%ebp)
80101432:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
80101435:	8d 76 00             	lea    0x0(%esi),%esi
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101438:	89 c2                	mov    %eax,%edx
8010143a:	83 c0 01             	add    $0x1,%eax
8010143d:	89 c1                	mov    %eax,%ecx
8010143f:	83 e2 7f             	and    $0x7f,%edx
80101442:	83 e1 7f             	and    $0x7f,%ecx
80101445:	0f b6 99 80 fe 10 80 	movzbl -0x7fef0180(%ecx),%ebx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
8010144c:	8b 0c 8d 10 ff 10 80 	mov    -0x7fef00f0(,%ecx,4),%ecx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101453:	88 9a 80 fe 10 80    	mov    %bl,-0x7fef0180(%edx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101459:	89 0c 95 10 ff 10 80 	mov    %ecx,-0x7fef00f0(,%edx,4)
          for (uint i = input.e; i < input.real_end - 1; i++)
80101460:	39 f0                	cmp    %esi,%eax
80101462:	75 d4                	jne    80101438 <consoleintr+0x5f8>
80101464:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80101467:	8b 55 c8             	mov    -0x38(%ebp),%edx
8010146a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
          input.real_end--;
8010146d:	89 35 0c ff 10 80    	mov    %esi,0x8010ff0c
          if (input.e > input.real_end)
80101473:	39 d6                	cmp    %edx,%esi
80101475:	73 08                	jae    8010147f <consoleintr+0x63f>
            input.e = input.real_end;
80101477:	89 35 08 ff 10 80    	mov    %esi,0x8010ff08
8010147d:	89 f2                	mov    %esi,%edx
          int old_cursor_off = old_e - (int)input.w;
8010147f:	89 d8                	mov    %ebx,%eax
          if (old_cursor_off < 0)
80101481:	31 db                	xor    %ebx,%ebx
          int old_cursor_off = old_e - (int)input.w;
80101483:	29 f8                	sub    %edi,%eax
          if (old_cursor_off < 0)
80101485:	85 c0                	test   %eax,%eax
80101487:	0f 49 d8             	cmovns %eax,%ebx
8010148a:	89 5d cc             	mov    %ebx,-0x34(%ebp)
          for (int i = 0; i < old_cursor_off; i++)
8010148d:	bb 00 00 00 00       	mov    $0x0,%ebx
80101492:	0f 8e e6 01 00 00    	jle    8010167e <consoleintr+0x83e>
80101498:	89 4d c8             	mov    %ecx,-0x38(%ebp)
8010149b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  if (panicked)
8010149e:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801014a3:	85 c0                	test   %eax,%eax
801014a5:	0f 84 b5 01 00 00    	je     80101660 <consoleintr+0x820>
801014ab:	fa                   	cli
    for (;;)
801014ac:	eb fe                	jmp    801014ac <consoleintr+0x66c>
801014ae:	66 90                	xchg   %ax,%ax
        uint old_e = input.e;
801014b0:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
801014b6:	ba 1c 01 11 80       	mov    $0x8011011c,%edx
        int old_len = (int)input.real_end - (int)input.w;
801014bb:	8b 35 0c ff 10 80    	mov    0x8010ff0c,%esi
801014c1:	8b 3d 04 ff 10 80    	mov    0x8010ff04,%edi
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
801014c7:	89 d8                	mov    %ebx,%eax
801014c9:	e8 b2 ed ff ff       	call   80100280 <insert_at>
  input.sel_a = input.sel_b = -1;
801014ce:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
801014d5:	ff ff ff 
801014d8:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
801014df:	ff ff ff 
        if (wrote <= 0)
801014e2:	85 c0                	test   %eax,%eax
801014e4:	0f 8e 79 f9 ff ff    	jle    80100e63 <consoleintr+0x23>
        if (!was_end)
801014ea:	39 de                	cmp    %ebx,%esi
801014ec:	0f 84 a6 03 00 00    	je     80101898 <consoleintr+0xa58>
        int old_len = (int)input.real_end - (int)input.w;
801014f2:	29 fe                	sub    %edi,%esi
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
801014f4:	89 d8                	mov    %ebx,%eax
        int old_len = (int)input.real_end - (int)input.w;
801014f6:	89 f2                	mov    %esi,%edx
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
801014f8:	e8 73 f5 ff ff       	call   80100a70 <full_redraw_after_edit_len>
801014fd:	e9 61 f9 ff ff       	jmp    80100e63 <consoleintr+0x23>
      input.sel_b = (int)input.e; // 2nd Ctrl+S → set active end
80101502:	89 15 18 01 11 80    	mov    %edx,0x80110118
80101508:	89 d6                	mov    %edx,%esi
      if (input.sel_b == input.sel_a)
8010150a:	39 da                	cmp    %ebx,%edx
8010150c:	0f 85 99 00 00 00    	jne    801015ab <consoleintr+0x76b>
  input.sel_a = input.sel_b = -1;
80101512:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80101519:	ff ff ff 
8010151c:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80101523:	ff ff ff 
}
80101526:	e9 38 f9 ff ff       	jmp    80100e63 <consoleintr+0x23>
8010152b:	b8 e5 00 00 00       	mov    $0xe5,%eax
80101530:	ba 20 00 00 00       	mov    $0x20,%edx
80101535:	e8 86 f0 ff ff       	call   801005c0 <consputc.part.0>
        input.e++;
8010153a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010153f:	83 c0 01             	add    $0x1,%eax
80101542:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101547:	3b 05 0c ff 10 80    	cmp    0x8010ff0c,%eax
8010154d:	0f 83 10 f9 ff ff    	jae    80100e63 <consoleintr+0x23>
80101553:	83 e0 7f             	and    $0x7f,%eax
80101556:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
8010155d:	0f 85 00 f9 ff ff    	jne    80100e63 <consoleintr+0x23>
  if (panicked)
80101563:	8b 1d d8 01 11 80    	mov    0x801101d8,%ebx
80101569:	85 db                	test   %ebx,%ebx
8010156b:	74 be                	je     8010152b <consoleintr+0x6eb>
8010156d:	fa                   	cli
    for (;;)
8010156e:	eb fe                	jmp    8010156e <consoleintr+0x72e>
80101570:	b8 e5 00 00 00       	mov    $0xe5,%eax
80101575:	e8 46 f0 ff ff       	call   801005c0 <consputc.part.0>
        input.e++;
8010157a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010157f:	8d 50 01             	lea    0x1(%eax),%edx
80101582:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80101588:	89 d0                	mov    %edx,%eax
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
8010158a:	3b 15 0c ff 10 80    	cmp    0x8010ff0c,%edx
80101590:	0f 82 4d fc ff ff    	jb     801011e3 <consoleintr+0x3a3>
80101596:	e9 c8 f8 ff ff       	jmp    80100e63 <consoleintr+0x23>
8010159b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        input.sel_a = (int)input.e;
801015a0:	89 15 14 01 11 80    	mov    %edx,0x80110114
        break;
801015a6:	e9 b8 f8 ff ff       	jmp    80100e63 <consoleintr+0x23>
  int len = (int)input.real_end - (int)input.w;
801015ab:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
  if (off_from_start < 0)
801015b0:	31 c9                	xor    %ecx,%ecx
  int len = (int)input.real_end - (int)input.w;
801015b2:	8b 3d 0c ff 10 80    	mov    0x8010ff0c,%edi
  int off_from_start = old_e - (int)input.w;
801015b8:	29 c2                	sub    %eax,%edx
  if (off_from_start < 0)
801015ba:	85 d2                	test   %edx,%edx
801015bc:	0f 49 ca             	cmovns %edx,%ecx
801015bf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  for (int i = 0; i < off_from_start; i++)
801015c2:	0f 8e be 04 00 00    	jle    80101a86 <consoleintr+0xc46>
801015c8:	31 db                	xor    %ebx,%ebx
801015ca:	89 c6                	mov    %eax,%esi
  if (panicked)
801015cc:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
801015d2:	85 c9                	test   %ecx,%ecx
801015d4:	0f 84 86 01 00 00    	je     80101760 <consoleintr+0x920>
801015da:	fa                   	cli
    for (;;)
801015db:	eb fe                	jmp    801015db <consoleintr+0x79b>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi
801015e0:	b8 e5 00 00 00       	mov    $0xe5,%eax
801015e5:	e8 d6 ef ff ff       	call   801005c0 <consputc.part.0>
        input.e++;
801015ea:	83 05 08 ff 10 80 01 	addl   $0x1,0x8010ff08
801015f1:	e9 6d f8 ff ff       	jmp    80100e63 <consoleintr+0x23>
801015f6:	31 d2                	xor    %edx,%edx
801015f8:	b8 e4 00 00 00       	mov    $0xe4,%eax
801015fd:	e8 be ef ff ff       	call   801005c0 <consputc.part.0>
80101602:	e9 5c f8 ff ff       	jmp    80100e63 <consoleintr+0x23>
      if (input.e < input.real_end)
80101607:	8b 3d 08 ff 10 80    	mov    0x8010ff08,%edi
8010160d:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80101612:	39 c7                	cmp    %eax,%edi
80101614:	0f 83 da 00 00 00    	jae    801016f4 <consoleintr+0x8b4>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
8010161a:	89 c2                	mov    %eax,%edx
8010161c:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80101622:	83 fa 7f             	cmp    $0x7f,%edx
80101625:	0f 87 38 f8 ff ff    	ja     80100e63 <consoleintr+0x23>
  if (panicked)
8010162b:	8b 35 d8 01 11 80    	mov    0x801101d8,%esi
            input.real_end++;
80101631:	8d 48 01             	lea    0x1(%eax),%ecx
          if (c != '\n')
80101634:	83 fb 0a             	cmp    $0xa,%ebx
80101637:	0f 85 73 03 00 00    	jne    801019b0 <consoleintr+0xb70>
              input.buf[input.e++ % INPUT_BUF] = '\n';
8010163d:	83 e0 7f             	and    $0x7f,%eax
80101640:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
80101646:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
              input.real_end = input.e;
8010164d:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
  if (panicked)
80101653:	85 f6                	test   %esi,%esi
80101655:	0f 84 55 05 00 00    	je     80101bb0 <consoleintr+0xd70>
8010165b:	fa                   	cli
    for (;;)
8010165c:	eb fe                	jmp    8010165c <consoleintr+0x81c>
8010165e:	66 90                	xchg   %ax,%ax
80101660:	31 d2                	xor    %edx,%edx
80101662:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++)
80101667:	83 c3 01             	add    $0x1,%ebx
8010166a:	e8 51 ef ff ff       	call   801005c0 <consputc.part.0>
8010166f:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
80101672:	0f 8f 26 fe ff ff    	jg     8010149e <consoleintr+0x65e>
80101678:	8b 4d c8             	mov    -0x38(%ebp),%ecx
8010167b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
          int old_len = old_real_end - (int)input.w;
8010167e:	89 c8                	mov    %ecx,%eax
          if (old_len < 0)
80101680:	bb 00 00 00 00       	mov    $0x0,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80101685:	b9 50 00 00 00       	mov    $0x50,%ecx
          int old_len = old_real_end - (int)input.w;
8010168a:	29 f8                	sub    %edi,%eax
          if (old_len < 0)
8010168c:	0f 49 d8             	cmovns %eax,%ebx
min_int(int a, int b) { return a < b ? a : b; }
8010168f:	39 cb                	cmp    %ecx,%ebx
80101691:	0f 4f d9             	cmovg  %ecx,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++)
80101694:	31 c9                	xor    %ecx,%ecx
80101696:	85 c0                	test   %eax,%eax
80101698:	0f 8e d8 04 00 00    	jle    80101b76 <consoleintr+0xd36>
8010169e:	89 55 c8             	mov    %edx,-0x38(%ebp)
801016a1:	89 7d c4             	mov    %edi,-0x3c(%ebp)
801016a4:	89 f7                	mov    %esi,%edi
801016a6:	89 de                	mov    %ebx,%esi
801016a8:	89 cb                	mov    %ecx,%ebx
  if (panicked)
801016aa:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801016af:	89 45 cc             	mov    %eax,-0x34(%ebp)
801016b2:	85 c0                	test   %eax,%eax
801016b4:	0f 84 c3 02 00 00    	je     8010197d <consoleintr+0xb3d>
801016ba:	fa                   	cli
    for (;;)
801016bb:	eb fe                	jmp    801016bb <consoleintr+0x87b>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi
  if (panicked)
801016c0:	a1 d8 01 11 80       	mov    0x801101d8,%eax
          input.real_end--;
801016c5:	89 35 0c ff 10 80    	mov    %esi,0x8010ff0c
  if (panicked)
801016cb:	85 c0                	test   %eax,%eax
801016cd:	0f 84 a0 01 00 00    	je     80101873 <consoleintr+0xa33>
801016d3:	fa                   	cli
    for (;;)
801016d4:	eb fe                	jmp    801016d4 <consoleintr+0x894>
801016d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016dd:	00 
801016de:	66 90                	xchg   %ax,%ax
      input.real_end = input.e;
801016e0:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
      input.current_time = 0;
801016e5:	c7 05 10 01 11 80 00 	movl   $0x0,0x80110110
801016ec:	00 00 00 
      break;
801016ef:	e9 6f f7 ff ff       	jmp    80100e63 <consoleintr+0x23>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
801016f4:	89 c2                	mov    %eax,%edx
801016f6:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801016fc:	83 fa 7f             	cmp    $0x7f,%edx
801016ff:	0f 87 5e f7 ff ff    	ja     80100e63 <consoleintr+0x23>
          char one[1] = {(char)ch};
80101705:	89 d9                	mov    %ebx,%ecx
          c = (c == '\r') ? '\n' : c;
80101707:	83 fb 0d             	cmp    $0xd,%ebx
8010170a:	75 0a                	jne    80101716 <consoleintr+0x8d6>
8010170c:	b9 0a 00 00 00       	mov    $0xa,%ecx
80101711:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101716:	8b 35 10 01 11 80    	mov    0x80110110,%esi
          input.buf[input.e++ % INPUT_BUF] = c;
8010171c:	8d 57 01             	lea    0x1(%edi),%edx
8010171f:	83 e7 7f             	and    $0x7f,%edi
80101722:	88 8f 80 fe 10 80    	mov    %cl,-0x7fef0180(%edi)
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101728:	8d 4e 01             	lea    0x1(%esi),%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
8010172b:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101731:	89 0d 10 01 11 80    	mov    %ecx,0x80110110
80101737:	89 0c bd 10 ff 10 80 	mov    %ecx,-0x7fef00f0(,%edi,4)
          if (input.e > input.real_end)
8010173e:	39 d0                	cmp    %edx,%eax
80101740:	73 06                	jae    80101748 <consoleintr+0x908>
            input.real_end = input.e;
80101742:	89 15 0c ff 10 80    	mov    %edx,0x8010ff0c
  if (panicked)
80101748:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
8010174e:	85 d2                	test   %edx,%edx
80101750:	0f 84 e1 01 00 00    	je     80101937 <consoleintr+0xaf7>
80101756:	fa                   	cli
    for (;;)
80101757:	eb fe                	jmp    80101757 <consoleintr+0x917>
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101760:	31 d2                	xor    %edx,%edx
80101762:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < off_from_start; i++)
80101767:	83 c3 01             	add    $0x1,%ebx
8010176a:	e8 51 ee ff ff       	call   801005c0 <consputc.part.0>
8010176f:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
80101772:	0f 8f 54 fe ff ff    	jg     801015cc <consoleintr+0x78c>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
80101778:	8b 1d 14 01 11 80    	mov    0x80110114,%ebx
8010177e:	89 f0                	mov    %esi,%eax
80101780:	85 db                	test   %ebx,%ebx
80101782:	0f 89 f8 02 00 00    	jns    80101a80 <consoleintr+0xc40>
  int sel = 0;
80101788:	31 c9                	xor    %ecx,%ecx
  int lo = -1, hi = -1;
8010178a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010178f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  int len = (int)input.real_end - (int)input.w;
80101794:	29 c7                	sub    %eax,%edi
  if (len < 0)
80101796:	31 c0                	xor    %eax,%eax
80101798:	85 ff                	test   %edi,%edi
8010179a:	0f 49 c7             	cmovns %edi,%eax
8010179d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  for (int i = 0; i < len; i++)
801017a0:	0f 8e b7 02 00 00    	jle    80101a5d <consoleintr+0xc1d>
    int in_sel = sel && idx >= lo && idx < hi;
801017a6:	89 c8                	mov    %ecx,%eax
  for (int i = 0; i < len; i++)
801017a8:	31 ff                	xor    %edi,%edi
    int in_sel = sel && idx >= lo && idx < hi;
801017aa:	83 e0 01             	and    $0x1,%eax
801017ad:	88 45 c4             	mov    %al,-0x3c(%ebp)
    ushort prev = cg_attr;
801017b0:	0f b7 05 00 90 10 80 	movzwl 0x80109000,%eax
801017b7:	66 89 45 c0          	mov    %ax,-0x40(%ebp)
    int idx = (int)input.w + i;
801017bb:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
801017c0:	01 f8                	add    %edi,%eax
    int in_sel = sel && idx >= lo && idx < hi;
801017c2:	39 d8                	cmp    %ebx,%eax
801017c4:	0f 9c c1             	setl   %cl
801017c7:	39 f0                	cmp    %esi,%eax
801017c9:	0f 9d c2             	setge  %dl
801017cc:	84 d1                	test   %dl,%cl
801017ce:	74 0b                	je     801017db <consoleintr+0x99b>
801017d0:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
    cg_attr = in_sel ? 0x7000 : 0x0700;
801017d4:	ba 00 70 00 00       	mov    $0x7000,%edx
    int in_sel = sel && idx >= lo && idx < hi;
801017d9:	75 05                	jne    801017e0 <consoleintr+0x9a0>
    cg_attr = in_sel ? 0x7000 : 0x0700;
801017db:	ba 00 07 00 00       	mov    $0x700,%edx
801017e0:	66 89 15 00 90 10 80 	mov    %dx,0x80109000
    consputc(input.buf[idx % INPUT_BUF], 0);
801017e7:	99                   	cltd
801017e8:	c1 ea 19             	shr    $0x19,%edx
801017eb:	01 d0                	add    %edx,%eax
801017ed:	83 e0 7f             	and    $0x7f,%eax
801017f0:	29 d0                	sub    %edx,%eax
  if (panicked)
801017f2:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
    consputc(input.buf[idx % INPUT_BUF], 0);
801017f8:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
801017ff:	85 d2                	test   %edx,%edx
80101801:	0f 84 39 02 00 00    	je     80101a40 <consoleintr+0xc00>
80101807:	fa                   	cli
    for (;;)
80101808:	eb fe                	jmp    80101808 <consoleintr+0x9c8>
8010180a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80101810:	85 c0                	test   %eax,%eax
80101812:	0f 84 4b f6 ff ff    	je     80100e63 <consoleintr+0x23>
80101818:	83 e8 01             	sub    $0x1,%eax
8010181b:	83 e0 7f             	and    $0x7f,%eax
8010181e:	80 b8 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%eax)
80101825:	0f 84 38 f6 ff ff    	je     80100e63 <consoleintr+0x23>
  if (panicked)
8010182b:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101830:	85 c0                	test   %eax,%eax
80101832:	74 0c                	je     80101840 <consoleintr+0xa00>
80101834:	fa                   	cli
    for (;;)
80101835:	eb fe                	jmp    80101835 <consoleintr+0x9f5>
80101837:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010183e:	00 
8010183f:	90                   	nop
80101840:	31 d2                	xor    %edx,%edx
80101842:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101847:	e8 74 ed ff ff       	call   801005c0 <consputc.part.0>
        input.e--;
8010184c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101851:	83 e8 01             	sub    $0x1,%eax
80101854:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80101859:	75 bd                	jne    80101818 <consoleintr+0x9d8>
8010185b:	e9 03 f6 ff ff       	jmp    80100e63 <consoleintr+0x23>
        int n = hi - lo;
80101860:	29 c8                	sub    %ecx,%eax
80101862:	89 c3                	mov    %eax,%ebx
        if (n > INPUT_BUF)
80101864:	b8 80 00 00 00       	mov    $0x80,%eax
80101869:	39 c3                	cmp    %eax,%ebx
8010186b:	0f 4f d8             	cmovg  %eax,%ebx
        for (int i = 0; i < n; ++i)
8010186e:	e9 fe f8 ff ff       	jmp    80101171 <consoleintr+0x331>
80101873:	31 d2                	xor    %edx,%edx
80101875:	b8 00 01 00 00       	mov    $0x100,%eax
8010187a:	e8 41 ed ff ff       	call   801005c0 <consputc.part.0>
8010187f:	e9 df f5 ff ff       	jmp    80100e63 <consoleintr+0x23>
  if (panicked)
80101884:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
8010188a:	85 c9                	test   %ecx,%ecx
8010188c:	0f 84 7e f8 ff ff    	je     80101110 <consoleintr+0x2d0>
80101892:	fa                   	cli
    for (;;)
80101893:	eb fe                	jmp    80101893 <consoleintr+0xa53>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
          for (int i = 0; i < wrote; ++i)
80101898:	31 db                	xor    %ebx,%ebx
8010189a:	89 c6                	mov    %eax,%esi
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
8010189c:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  if (panicked)
801018a1:	8b 15 d8 01 11 80    	mov    0x801101d8,%edx
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
801018a7:	29 f0                	sub    %esi,%eax
801018a9:	01 d8                	add    %ebx,%eax
801018ab:	83 e0 7f             	and    $0x7f,%eax
801018ae:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
801018b5:	85 d2                	test   %edx,%edx
801018b7:	74 67                	je     80101920 <consoleintr+0xae0>
801018b9:	fa                   	cli
    for (;;)
801018ba:	eb fe                	jmp    801018ba <consoleintr+0xa7a>
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c0:	b8 e4 00 00 00       	mov    $0xe4,%eax
801018c5:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < old_cursor_off; i++)
801018c7:	83 c3 01             	add    $0x1,%ebx
801018ca:	e8 f1 ec ff ff       	call   801005c0 <consputc.part.0>
801018cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801018d2:	39 c3                	cmp    %eax,%ebx
801018d4:	0f 8c 50 fa ff ff    	jl     8010132a <consoleintr+0x4ea>
801018da:	89 fa                	mov    %edi,%edx
801018dc:	8b 5d c8             	mov    -0x38(%ebp),%ebx
801018df:	8b 7d c4             	mov    -0x3c(%ebp),%edi
          int old_len = old_real_end - (int)input.w;
801018e2:	89 d8                	mov    %ebx,%eax
          if (old_len < 0)
801018e4:	bb 00 00 00 00       	mov    $0x0,%ebx
min_int(int a, int b) { return a < b ? a : b; }
801018e9:	b9 50 00 00 00       	mov    $0x50,%ecx
          int old_len = old_real_end - (int)input.w;
801018ee:	29 f0                	sub    %esi,%eax
          if (old_len < 0)
801018f0:	0f 49 d8             	cmovns %eax,%ebx
min_int(int a, int b) { return a < b ? a : b; }
801018f3:	39 cb                	cmp    %ecx,%ebx
801018f5:	0f 4f d9             	cmovg  %ecx,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++)
801018f8:	31 c9                	xor    %ecx,%ecx
801018fa:	85 c0                	test   %eax,%eax
801018fc:	0f 8e 93 03 00 00    	jle    80101c95 <consoleintr+0xe55>
80101902:	89 75 c8             	mov    %esi,-0x38(%ebp)
80101905:	89 ce                	mov    %ecx,%esi
80101907:	89 7d c4             	mov    %edi,-0x3c(%ebp)
8010190a:	89 d7                	mov    %edx,%edi
  if (panicked)
8010190c:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101911:	89 45 cc             	mov    %eax,-0x34(%ebp)
80101914:	85 c0                	test   %eax,%eax
80101916:	0f 84 04 02 00 00    	je     80101b20 <consoleintr+0xce0>
8010191c:	fa                   	cli
    for (;;)
8010191d:	eb fe                	jmp    8010191d <consoleintr+0xadd>
8010191f:	90                   	nop
80101920:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < wrote; ++i)
80101922:	83 c3 01             	add    $0x1,%ebx
80101925:	e8 96 ec ff ff       	call   801005c0 <consputc.part.0>
8010192a:	39 de                	cmp    %ebx,%esi
8010192c:	0f 85 6a ff ff ff    	jne    8010189c <consoleintr+0xa5c>
80101932:	e9 2c f5 ff ff       	jmp    80100e63 <consoleintr+0x23>
80101937:	31 d2                	xor    %edx,%edx
80101939:	89 d8                	mov    %ebx,%eax
8010193b:	e8 80 ec ff ff       	call   801005c0 <consputc.part.0>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
80101940:	83 fb 0a             	cmp    $0xa,%ebx
80101943:	74 14                	je     80101959 <consoleintr+0xb19>
80101945:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010194a:	83 e8 80             	sub    $0xffffff80,%eax
8010194d:	39 05 0c ff 10 80    	cmp    %eax,0x8010ff0c
80101953:	0f 85 0a f5 ff ff    	jne    80100e63 <consoleintr+0x23>
            input.w = input.e;
80101959:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
8010195e:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80101961:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            input.real_end = input.e;
80101966:	a3 0c ff 10 80       	mov    %eax,0x8010ff0c
            wakeup(&input.r);
8010196b:	68 00 ff 10 80       	push   $0x8010ff00
80101970:	e8 3b 3a 00 00       	call   801053b0 <wakeup>
80101975:	83 c4 10             	add    $0x10,%esp
80101978:	e9 e6 f4 ff ff       	jmp    80100e63 <consoleintr+0x23>
8010197d:	31 d2                	xor    %edx,%edx
8010197f:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
80101984:	83 c3 01             	add    $0x1,%ebx
80101987:	e8 34 ec ff ff       	call   801005c0 <consputc.part.0>
8010198c:	39 f3                	cmp    %esi,%ebx
8010198e:	0f 8c 16 fd ff ff    	jl     801016aa <consoleintr+0x86a>
80101994:	89 f3                	mov    %esi,%ebx
80101996:	89 fe                	mov    %edi,%esi
80101998:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  if (panicked)
8010199b:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801019a0:	85 c0                	test   %eax,%eax
801019a2:	0f 84 b0 01 00 00    	je     80101b58 <consoleintr+0xd18>
801019a8:	fa                   	cli
    for (;;)
801019a9:	eb fe                	jmp    801019a9 <consoleintr+0xb69>
801019ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
801019b0:	8d 57 ff             	lea    -0x1(%edi),%edx
801019b3:	83 e8 01             	sub    $0x1,%eax
801019b6:	89 55 cc             	mov    %edx,-0x34(%ebp)
801019b9:	39 c7                	cmp    %eax,%edi
801019bb:	7f 53                	jg     80101a10 <consoleintr+0xbd0>
801019bd:	89 7d c8             	mov    %edi,-0x38(%ebp)
801019c0:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
801019c3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801019c6:	99                   	cltd
801019c7:	c1 ea 19             	shr    $0x19,%edx
801019ca:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
801019cd:	83 e3 7f             	and    $0x7f,%ebx
801019d0:	29 d3                	sub    %edx,%ebx
801019d2:	8d 50 01             	lea    0x1(%eax),%edx
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
801019d5:	83 e8 01             	sub    $0x1,%eax
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801019d8:	89 d7                	mov    %edx,%edi
801019da:	0f b6 8b 80 fe 10 80 	movzbl -0x7fef0180(%ebx),%ecx
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801019e1:	8b 1c 9d 10 ff 10 80 	mov    -0x7fef00f0(,%ebx,4),%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801019e8:	c1 ff 1f             	sar    $0x1f,%edi
801019eb:	c1 ef 19             	shr    $0x19,%edi
801019ee:	01 fa                	add    %edi,%edx
801019f0:	83 e2 7f             	and    $0x7f,%edx
801019f3:	29 fa                	sub    %edi,%edx
801019f5:	88 8a 80 fe 10 80    	mov    %cl,-0x7fef0180(%edx)
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801019fb:	89 1c 95 10 ff 10 80 	mov    %ebx,-0x7fef00f0(,%edx,4)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80101a02:	39 45 cc             	cmp    %eax,-0x34(%ebp)
80101a05:	75 bf                	jne    801019c6 <consoleintr+0xb86>
80101a07:	8b 7d c8             	mov    -0x38(%ebp),%edi
80101a0a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
80101a0d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80101a10:	a1 10 01 11 80       	mov    0x80110110,%eax
            input.buf[input.e % INPUT_BUF] = c;
80101a15:	83 e7 7f             	and    $0x7f,%edi
            input.real_end++;
80101a18:	89 0d 0c ff 10 80    	mov    %ecx,0x8010ff0c
            input.buf[input.e % INPUT_BUF] = c;
80101a1e:	88 9f 80 fe 10 80    	mov    %bl,-0x7fef0180(%edi)
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80101a24:	83 c0 01             	add    $0x1,%eax
80101a27:	a3 10 01 11 80       	mov    %eax,0x80110110
80101a2c:	89 04 bd 10 ff 10 80 	mov    %eax,-0x7fef00f0(,%edi,4)
  if (panicked)
80101a33:	85 f6                	test   %esi,%esi
80101a35:	74 71                	je     80101aa8 <consoleintr+0xc68>
80101a37:	fa                   	cli
    for (;;)
80101a38:	eb fe                	jmp    80101a38 <consoleintr+0xbf8>
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a40:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < len; i++)
80101a42:	83 c7 01             	add    $0x1,%edi
80101a45:	e8 76 eb ff ff       	call   801005c0 <consputc.part.0>
    cg_attr = prev;
80101a4a:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80101a4e:	66 a3 00 90 10 80    	mov    %ax,0x80109000
  for (int i = 0; i < len; i++)
80101a54:	39 7d c8             	cmp    %edi,-0x38(%ebp)
80101a57:	0f 8f 5e fd ff ff    	jg     801017bb <consoleintr+0x97b>
  int back = len - off_from_start;
80101a5d:	8b 75 c8             	mov    -0x38(%ebp),%esi
80101a60:	8b 45 cc             	mov    -0x34(%ebp),%eax
  for (int i = 0; i < back; i++)
80101a63:	31 db                	xor    %ebx,%ebx
  int back = len - off_from_start;
80101a65:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < back; i++)
80101a67:	85 f6                	test   %esi,%esi
80101a69:	0f 8e f4 f3 ff ff    	jle    80100e63 <consoleintr+0x23>
  if (panicked)
80101a6f:	8b 3d d8 01 11 80    	mov    0x801101d8,%edi
80101a75:	85 ff                	test   %edi,%edi
80101a77:	0f 84 5e 01 00 00    	je     80101bdb <consoleintr+0xd9b>
80101a7d:	fa                   	cli
    for (;;)
80101a7e:	eb fe                	jmp    80101a7e <consoleintr+0xc3e>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
80101a80:	8b 35 18 01 11 80    	mov    0x80110118,%esi
80101a86:	85 f6                	test   %esi,%esi
80101a88:	0f 88 fa fc ff ff    	js     80101788 <consoleintr+0x948>
80101a8e:	39 f3                	cmp    %esi,%ebx
80101a90:	0f 84 f2 fc ff ff    	je     80101788 <consoleintr+0x948>
    sel = 1;
80101a96:	b9 01 00 00 00       	mov    $0x1,%ecx
    if (lo > hi)
80101a9b:	0f 8f f3 fc ff ff    	jg     80101794 <consoleintr+0x954>
    hi = input.sel_b;
80101aa1:	87 de                	xchg   %ebx,%esi
80101aa3:	e9 ec fc ff ff       	jmp    80101794 <consoleintr+0x954>
80101aa8:	89 d8                	mov    %ebx,%eax
80101aaa:	31 d2                	xor    %edx,%edx
80101aac:	e8 0f eb ff ff       	call   801005c0 <consputc.part.0>
            input.e++;
80101ab1:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80101ab6:	8d 58 01             	lea    0x1(%eax),%ebx
            for (uint i = input.e; i < input.real_end; i++)
80101ab9:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
            input.e++;
80101abe:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
            for (uint i = input.e; i < input.real_end; i++)
80101ac4:	39 c3                	cmp    %eax,%ebx
80101ac6:	0f 83 8b 01 00 00    	jae    80101c57 <consoleintr+0xe17>
              consputc(input.buf[i % INPUT_BUF], 0);
80101acc:	89 d8                	mov    %ebx,%eax
  if (panicked)
80101ace:	8b 35 d8 01 11 80    	mov    0x801101d8,%esi
              consputc(input.buf[i % INPUT_BUF], 0);
80101ad4:	83 e0 7f             	and    $0x7f,%eax
80101ad7:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
80101ade:	85 f6                	test   %esi,%esi
80101ae0:	74 06                	je     80101ae8 <consoleintr+0xca8>
80101ae2:	fa                   	cli
    for (;;)
80101ae3:	eb fe                	jmp    80101ae3 <consoleintr+0xca3>
80101ae5:	8d 76 00             	lea    0x0(%esi),%esi
80101ae8:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80101aea:	83 c3 01             	add    $0x1,%ebx
80101aed:	e8 ce ea ff ff       	call   801005c0 <consputc.part.0>
80101af2:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80101af7:	39 c3                	cmp    %eax,%ebx
80101af9:	72 d1                	jb     80101acc <consoleintr+0xc8c>
            for (uint k = input.e; k < input.real_end; k++)
80101afb:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
80101b01:	39 c3                	cmp    %eax,%ebx
80101b03:	0f 83 4e 01 00 00    	jae    80101c57 <consoleintr+0xe17>
  if (panicked)
80101b09:	8b 0d d8 01 11 80    	mov    0x801101d8,%ecx
80101b0f:	85 c9                	test   %ecx,%ecx
80101b11:	0f 84 24 01 00 00    	je     80101c3b <consoleintr+0xdfb>
80101b17:	fa                   	cli
    for (;;)
80101b18:	eb fe                	jmp    80101b18 <consoleintr+0xcd8>
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b20:	31 d2                	xor    %edx,%edx
80101b22:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
80101b27:	83 c6 01             	add    $0x1,%esi
80101b2a:	e8 91 ea ff ff       	call   801005c0 <consputc.part.0>
80101b2f:	39 de                	cmp    %ebx,%esi
80101b31:	0f 8c d5 fd ff ff    	jl     8010190c <consoleintr+0xacc>
80101b37:	89 fa                	mov    %edi,%edx
80101b39:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80101b3c:	8b 75 c8             	mov    -0x38(%ebp),%esi
80101b3f:	89 7d c8             	mov    %edi,-0x38(%ebp)
80101b42:	89 d7                	mov    %edx,%edi
  if (panicked)
80101b44:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101b49:	85 c0                	test   %eax,%eax
80101b4b:	0f 84 24 01 00 00    	je     80101c75 <consoleintr+0xe35>
80101b51:	fa                   	cli
    for (;;)
80101b52:	eb fe                	jmp    80101b52 <consoleintr+0xd12>
80101b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b58:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101b5d:	31 d2                	xor    %edx,%edx
80101b5f:	e8 5c ea ff ff       	call   801005c0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++)
80101b64:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80101b68:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101b6b:	39 d8                	cmp    %ebx,%eax
80101b6d:	0f 8c 28 fe ff ff    	jl     8010199b <consoleintr+0xb5b>
80101b73:	8b 55 c8             	mov    -0x38(%ebp),%edx
          int new_len = (int)input.real_end - (int)input.w;
80101b76:	29 fe                	sub    %edi,%esi
          if (new_len < 0)
80101b78:	b8 00 00 00 00       	mov    $0x0,%eax
80101b7d:	89 7d cc             	mov    %edi,-0x34(%ebp)
80101b80:	89 d7                	mov    %edx,%edi
80101b82:	0f 48 f0             	cmovs  %eax,%esi
          for (int i = 0; i < new_len; i++)
80101b85:	31 db                	xor    %ebx,%ebx
80101b87:	39 de                	cmp    %ebx,%esi
80101b89:	74 78                	je     80101c03 <consoleintr+0xdc3>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101b8b:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80101b90:	01 d8                	add    %ebx,%eax
80101b92:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
80101b95:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101b9c:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
80101ba3:	74 52                	je     80101bf7 <consoleintr+0xdb7>
80101ba5:	fa                   	cli
    for (;;)
80101ba6:	eb fe                	jmp    80101ba6 <consoleintr+0xd66>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 
80101bb0:	31 d2                	xor    %edx,%edx
80101bb2:	b8 0a 00 00 00       	mov    $0xa,%eax
80101bb7:	e8 04 ea ff ff       	call   801005c0 <consputc.part.0>
            input.w = input.e;
80101bbc:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
            wakeup(&input.r);
80101bc1:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80101bc4:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
            wakeup(&input.r);
80101bc9:	68 00 ff 10 80       	push   $0x8010ff00
80101bce:	e8 dd 37 00 00       	call   801053b0 <wakeup>
80101bd3:	83 c4 10             	add    $0x10,%esp
80101bd6:	e9 88 f2 ff ff       	jmp    80100e63 <consoleintr+0x23>
80101bdb:	31 d2                	xor    %edx,%edx
80101bdd:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < back; i++)
80101be2:	83 c3 01             	add    $0x1,%ebx
80101be5:	e8 d6 e9 ff ff       	call   801005c0 <consputc.part.0>
80101bea:	39 de                	cmp    %ebx,%esi
80101bec:	0f 85 7d fe ff ff    	jne    80101a6f <consoleintr+0xc2f>
80101bf2:	e9 6c f2 ff ff       	jmp    80100e63 <consoleintr+0x23>
80101bf7:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101bf9:	83 c3 01             	add    $0x1,%ebx
80101bfc:	e8 bf e9 ff ff       	call   801005c0 <consputc.part.0>
80101c01:	eb 84                	jmp    80101b87 <consoleintr+0xd47>
          int new_cursor_off = (int)input.e - (int)input.w;
80101c03:	89 fa                	mov    %edi,%edx
80101c05:	8b 7d cc             	mov    -0x34(%ebp),%edi
          if (new_cursor_off < 0)
80101c08:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
80101c0d:	29 fa                	sub    %edi,%edx
          if (new_cursor_off < 0)
80101c0f:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++)
80101c12:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
80101c14:	29 d6                	sub    %edx,%esi
          for (int i = 0; i < moves_left; i++)
80101c16:	39 f3                	cmp    %esi,%ebx
80101c18:	0f 8d 45 f2 ff ff    	jge    80100e63 <consoleintr+0x23>
  if (panicked)
80101c1e:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
80101c25:	74 03                	je     80101c2a <consoleintr+0xdea>
80101c27:	fa                   	cli
    for (;;)
80101c28:	eb fe                	jmp    80101c28 <consoleintr+0xde8>
80101c2a:	31 d2                	xor    %edx,%edx
80101c2c:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
80101c31:	83 c3 01             	add    $0x1,%ebx
80101c34:	e8 87 e9 ff ff       	call   801005c0 <consputc.part.0>
80101c39:	eb db                	jmp    80101c16 <consoleintr+0xdd6>
80101c3b:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101c40:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80101c42:	83 c3 01             	add    $0x1,%ebx
80101c45:	e8 76 e9 ff ff       	call   801005c0 <consputc.part.0>
80101c4a:	a1 0c ff 10 80       	mov    0x8010ff0c,%eax
80101c4f:	39 c3                	cmp    %eax,%ebx
80101c51:	0f 82 b2 fe ff ff    	jb     80101b09 <consoleintr+0xcc9>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
80101c57:	8b 35 00 ff 10 80    	mov    0x8010ff00,%esi
80101c5d:	8d 96 80 00 00 00    	lea    0x80(%esi),%edx
80101c63:	39 c2                	cmp    %eax,%edx
80101c65:	0f 85 f8 f1 ff ff    	jne    80100e63 <consoleintr+0x23>
            input.e = input.real_end;
80101c6b:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
            if (c == '\n')
80101c70:	e9 47 ff ff ff       	jmp    80101bbc <consoleintr+0xd7c>
80101c75:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101c7a:	31 d2                	xor    %edx,%edx
80101c7c:	e8 3f e9 ff ff       	call   801005c0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++)
80101c81:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80101c85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101c88:	39 d8                	cmp    %ebx,%eax
80101c8a:	0f 8c b4 fe ff ff    	jl     80101b44 <consoleintr+0xd04>
80101c90:	89 fa                	mov    %edi,%edx
80101c92:	8b 7d c8             	mov    -0x38(%ebp),%edi
80101c95:	89 55 cc             	mov    %edx,-0x34(%ebp)
          int new_len = (int)input.real_end - (int)input.w;
80101c98:	29 f7                	sub    %esi,%edi
          if (new_len < 0)
80101c9a:	b8 00 00 00 00       	mov    $0x0,%eax
80101c9f:	0f 48 f8             	cmovs  %eax,%edi
          for (int i = 0; i < new_len; i++)
80101ca2:	31 db                	xor    %ebx,%ebx
80101ca4:	39 df                	cmp    %ebx,%edi
80101ca6:	74 29                	je     80101cd1 <consoleintr+0xe91>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101ca8:	a1 04 ff 10 80       	mov    0x8010ff04,%eax
80101cad:	01 d8                	add    %ebx,%eax
80101caf:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
80101cb2:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101cb9:	0f be 80 80 fe 10 80 	movsbl -0x7fef0180(%eax),%eax
  if (panicked)
80101cc0:	74 03                	je     80101cc5 <consoleintr+0xe85>
80101cc2:	fa                   	cli
    for (;;)
80101cc3:	eb fe                	jmp    80101cc3 <consoleintr+0xe83>
80101cc5:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101cc7:	83 c3 01             	add    $0x1,%ebx
80101cca:	e8 f1 e8 ff ff       	call   801005c0 <consputc.part.0>
80101ccf:	eb d3                	jmp    80101ca4 <consoleintr+0xe64>
          int new_cursor_off = (int)input.e - (int)input.w;
80101cd1:	8b 55 cc             	mov    -0x34(%ebp),%edx
          if (new_cursor_off < 0)
80101cd4:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
80101cd9:	29 f2                	sub    %esi,%edx
          if (new_cursor_off < 0)
80101cdb:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++)
80101cde:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
80101ce0:	29 d7                	sub    %edx,%edi
          for (int i = 0; i < moves_left; i++)
80101ce2:	39 fb                	cmp    %edi,%ebx
80101ce4:	0f 8d 79 f1 ff ff    	jge    80100e63 <consoleintr+0x23>
  if (panicked)
80101cea:	83 3d d8 01 11 80 00 	cmpl   $0x0,0x801101d8
80101cf1:	74 03                	je     80101cf6 <consoleintr+0xeb6>
80101cf3:	fa                   	cli
    for (;;)
80101cf4:	eb fe                	jmp    80101cf4 <consoleintr+0xeb4>
80101cf6:	31 d2                	xor    %edx,%edx
80101cf8:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
80101cfd:	83 c3 01             	add    $0x1,%ebx
80101d00:	e8 bb e8 ff ff       	call   801005c0 <consputc.part.0>
80101d05:	eb db                	jmp    80101ce2 <consoleintr+0xea2>
80101d07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d0e:	00 
80101d0f:	90                   	nop

80101d10 <consoleinit>:

void consoleinit(void)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80101d16:	68 a8 84 10 80       	push   $0x801084a8
80101d1b:	68 a0 01 11 80       	push   $0x801101a0
80101d20:	e8 5b 39 00 00       	call   80105680 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  ioapicenable(IRQ_KBD, 0);
80101d25:	58                   	pop    %eax
80101d26:	5a                   	pop    %edx
80101d27:	6a 00                	push   $0x0
80101d29:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80101d2b:	c7 05 8c 0b 11 80 30 	movl   $0x80100830,0x80110b8c
80101d32:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80101d35:	c7 05 88 0b 11 80 90 	movl   $0x80100390,0x80110b88
80101d3c:	03 10 80 
  cons.locking = 1;
80101d3f:	c7 05 d4 01 11 80 01 	movl   $0x1,0x801101d4
80101d46:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80101d49:	e8 e2 19 00 00       	call   80103730 <ioapicenable>
  input.sel_a = input.sel_b = -1;
  input.clip_len = 0;
}
80101d4e:	83 c4 10             	add    $0x10,%esp
  input.sel_a = input.sel_b = -1;
80101d51:	c7 05 18 01 11 80 ff 	movl   $0xffffffff,0x80110118
80101d58:	ff ff ff 
80101d5b:	c7 05 14 01 11 80 ff 	movl   $0xffffffff,0x80110114
80101d62:	ff ff ff 
  input.clip_len = 0;
80101d65:	c7 05 9c 01 11 80 00 	movl   $0x0,0x8011019c
80101d6c:	00 00 00 
}
80101d6f:	c9                   	leave
80101d70:	c3                   	ret
80101d71:	66 90                	xchg   %ax,%ax
80101d73:	66 90                	xchg   %ax,%ax
80101d75:	66 90                	xchg   %ax,%ax
80101d77:	66 90                	xchg   %ax,%ax
80101d79:	66 90                	xchg   %ax,%ax
80101d7b:	66 90                	xchg   %ax,%ax
80101d7d:	66 90                	xchg   %ax,%ax
80101d7f:	90                   	nop

80101d80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101d8c:	e8 9f 2e 00 00       	call   80104c30 <myproc>
80101d91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80101d97:	e8 74 22 00 00       	call   80104010 <begin_op>

  if((ip = namei(path)) == 0){
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	ff 75 08             	push   0x8(%ebp)
80101da2:	e8 a9 15 00 00       	call   80103350 <namei>
80101da7:	83 c4 10             	add    $0x10,%esp
80101daa:	85 c0                	test   %eax,%eax
80101dac:	0f 84 30 03 00 00    	je     801020e2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101db2:	83 ec 0c             	sub    $0xc,%esp
80101db5:	89 c7                	mov    %eax,%edi
80101db7:	50                   	push   %eax
80101db8:	e8 b3 0c 00 00       	call   80102a70 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101dbd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101dc3:	6a 34                	push   $0x34
80101dc5:	6a 00                	push   $0x0
80101dc7:	50                   	push   %eax
80101dc8:	57                   	push   %edi
80101dc9:	e8 b2 0f 00 00       	call   80102d80 <readi>
80101dce:	83 c4 20             	add    $0x20,%esp
80101dd1:	83 f8 34             	cmp    $0x34,%eax
80101dd4:	0f 85 01 01 00 00    	jne    80101edb <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80101dda:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101de1:	45 4c 46 
80101de4:	0f 85 f1 00 00 00    	jne    80101edb <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80101dea:	e8 01 63 00 00       	call   801080f0 <setupkvm>
80101def:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101df5:	85 c0                	test   %eax,%eax
80101df7:	0f 84 de 00 00 00    	je     80101edb <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101dfd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101e04:	00 
80101e05:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101e0b:	0f 84 a1 02 00 00    	je     801020b2 <exec+0x332>
  sz = 0;
80101e11:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101e18:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e1b:	31 db                	xor    %ebx,%ebx
80101e1d:	e9 8c 00 00 00       	jmp    80101eae <exec+0x12e>
80101e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80101e28:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101e2f:	75 6c                	jne    80101e9d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80101e31:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80101e37:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101e3d:	0f 82 87 00 00 00    	jb     80101eca <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80101e43:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101e49:	72 7f                	jb     80101eca <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101e4b:	83 ec 04             	sub    $0x4,%esp
80101e4e:	50                   	push   %eax
80101e4f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80101e55:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101e5b:	e8 c0 60 00 00       	call   80107f20 <allocuvm>
80101e60:	83 c4 10             	add    $0x10,%esp
80101e63:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101e69:	85 c0                	test   %eax,%eax
80101e6b:	74 5d                	je     80101eca <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80101e6d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101e73:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101e78:	75 50                	jne    80101eca <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101e7a:	83 ec 0c             	sub    $0xc,%esp
80101e7d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80101e83:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101e89:	57                   	push   %edi
80101e8a:	50                   	push   %eax
80101e8b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101e91:	e8 ba 5f 00 00       	call   80107e50 <loaduvm>
80101e96:	83 c4 20             	add    $0x20,%esp
80101e99:	85 c0                	test   %eax,%eax
80101e9b:	78 2d                	js     80101eca <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101e9d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80101ea4:	83 c3 01             	add    $0x1,%ebx
80101ea7:	83 c6 20             	add    $0x20,%esi
80101eaa:	39 d8                	cmp    %ebx,%eax
80101eac:	7e 52                	jle    80101f00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101eae:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101eb4:	6a 20                	push   $0x20
80101eb6:	56                   	push   %esi
80101eb7:	50                   	push   %eax
80101eb8:	57                   	push   %edi
80101eb9:	e8 c2 0e 00 00       	call   80102d80 <readi>
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	83 f8 20             	cmp    $0x20,%eax
80101ec4:	0f 84 5e ff ff ff    	je     80101e28 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80101eca:	83 ec 0c             	sub    $0xc,%esp
80101ecd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101ed3:	e8 98 61 00 00       	call   80108070 <freevm>
  if(ip){
80101ed8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80101edb:	83 ec 0c             	sub    $0xc,%esp
80101ede:	57                   	push   %edi
80101edf:	e8 1c 0e 00 00       	call   80102d00 <iunlockput>
    end_op();
80101ee4:	e8 97 21 00 00       	call   80104080 <end_op>
80101ee9:	83 c4 10             	add    $0x10,%esp
    return -1;
80101eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80101ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef4:	5b                   	pop    %ebx
80101ef5:	5e                   	pop    %esi
80101ef6:	5f                   	pop    %edi
80101ef7:	5d                   	pop    %ebp
80101ef8:	c3                   	ret
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80101f00:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101f06:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80101f0c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f12:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	57                   	push   %edi
80101f1c:	e8 df 0d 00 00       	call   80102d00 <iunlockput>
  end_op();
80101f21:	e8 5a 21 00 00       	call   80104080 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101f26:	83 c4 0c             	add    $0xc,%esp
80101f29:	53                   	push   %ebx
80101f2a:	56                   	push   %esi
80101f2b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80101f31:	56                   	push   %esi
80101f32:	e8 e9 5f 00 00       	call   80107f20 <allocuvm>
80101f37:	83 c4 10             	add    $0x10,%esp
80101f3a:	89 c7                	mov    %eax,%edi
80101f3c:	85 c0                	test   %eax,%eax
80101f3e:	0f 84 86 00 00 00    	je     80101fca <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f44:	83 ec 08             	sub    $0x8,%esp
80101f47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80101f4d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f4f:	50                   	push   %eax
80101f50:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80101f51:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101f53:	e8 38 62 00 00       	call   80108190 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101f58:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	8b 10                	mov    (%eax),%edx
80101f60:	85 d2                	test   %edx,%edx
80101f62:	0f 84 56 01 00 00    	je     801020be <exec+0x33e>
80101f68:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80101f6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f71:	eb 23                	jmp    80101f96 <exec+0x216>
80101f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f78:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80101f7b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80101f82:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80101f88:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101f8b:	85 d2                	test   %edx,%edx
80101f8d:	74 51                	je     80101fe0 <exec+0x260>
    if(argc >= MAXARG)
80101f8f:	83 f8 20             	cmp    $0x20,%eax
80101f92:	74 36                	je     80101fca <exec+0x24a>
80101f94:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101f96:	83 ec 0c             	sub    $0xc,%esp
80101f99:	52                   	push   %edx
80101f9a:	e8 c1 3b 00 00       	call   80105b60 <strlen>
80101f9f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101fa1:	58                   	pop    %eax
80101fa2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101fa5:	83 eb 01             	sub    $0x1,%ebx
80101fa8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101fab:	e8 b0 3b 00 00       	call   80105b60 <strlen>
80101fb0:	83 c0 01             	add    $0x1,%eax
80101fb3:	50                   	push   %eax
80101fb4:	ff 34 b7             	push   (%edi,%esi,4)
80101fb7:	53                   	push   %ebx
80101fb8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fbe:	e8 9d 63 00 00       	call   80108360 <copyout>
80101fc3:	83 c4 20             	add    $0x20,%esp
80101fc6:	85 c0                	test   %eax,%eax
80101fc8:	79 ae                	jns    80101f78 <exec+0x1f8>
    freevm(pgdir);
80101fca:	83 ec 0c             	sub    $0xc,%esp
80101fcd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101fd3:	e8 98 60 00 00       	call   80108070 <freevm>
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	e9 0c ff ff ff       	jmp    80101eec <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101fe0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80101fe7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101fed:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101ff3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80101ff6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80101ff9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80102000:	00 00 00 00 
  ustack[1] = argc;
80102004:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
8010200a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80102011:	ff ff ff 
  ustack[1] = argc;
80102014:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010201a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
8010201c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010201e:	29 d0                	sub    %edx,%eax
80102020:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102026:	56                   	push   %esi
80102027:	51                   	push   %ecx
80102028:	53                   	push   %ebx
80102029:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010202f:	e8 2c 63 00 00       	call   80108360 <copyout>
80102034:	83 c4 10             	add    $0x10,%esp
80102037:	85 c0                	test   %eax,%eax
80102039:	78 8f                	js     80101fca <exec+0x24a>
  for(last=s=path; *s; s++)
8010203b:	8b 45 08             	mov    0x8(%ebp),%eax
8010203e:	8b 55 08             	mov    0x8(%ebp),%edx
80102041:	0f b6 00             	movzbl (%eax),%eax
80102044:	84 c0                	test   %al,%al
80102046:	74 17                	je     8010205f <exec+0x2df>
80102048:	89 d1                	mov    %edx,%ecx
8010204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80102050:	83 c1 01             	add    $0x1,%ecx
80102053:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102055:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102058:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010205b:	84 c0                	test   %al,%al
8010205d:	75 f1                	jne    80102050 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010205f:	83 ec 04             	sub    $0x4,%esp
80102062:	6a 10                	push   $0x10
80102064:	52                   	push   %edx
80102065:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010206b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010206e:	50                   	push   %eax
8010206f:	e8 ac 3a 00 00       	call   80105b20 <safestrcpy>
  curproc->pgdir = pgdir;
80102074:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010207a:	89 f0                	mov    %esi,%eax
8010207c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010207f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80102081:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102084:	89 c1                	mov    %eax,%ecx
80102086:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010208c:	8b 40 18             	mov    0x18(%eax),%eax
8010208f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80102092:	8b 41 18             	mov    0x18(%ecx),%eax
80102095:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80102098:	89 0c 24             	mov    %ecx,(%esp)
8010209b:	e8 20 5c 00 00       	call   80107cc0 <switchuvm>
  freevm(oldpgdir);
801020a0:	89 34 24             	mov    %esi,(%esp)
801020a3:	e8 c8 5f 00 00       	call   80108070 <freevm>
  return 0;
801020a8:	83 c4 10             	add    $0x10,%esp
801020ab:	31 c0                	xor    %eax,%eax
801020ad:	e9 3f fe ff ff       	jmp    80101ef1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801020b2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801020b7:	31 f6                	xor    %esi,%esi
801020b9:	e9 5a fe ff ff       	jmp    80101f18 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
801020be:	be 10 00 00 00       	mov    $0x10,%esi
801020c3:	ba 04 00 00 00       	mov    $0x4,%edx
801020c8:	b8 03 00 00 00       	mov    $0x3,%eax
801020cd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801020d4:	00 00 00 
801020d7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801020dd:	e9 17 ff ff ff       	jmp    80101ff9 <exec+0x279>
    end_op();
801020e2:	e8 99 1f 00 00       	call   80104080 <end_op>
    cprintf("exec: fail\n");
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 b0 84 10 80       	push   $0x801084b0
801020ef:	e8 3c eb ff ff       	call   80100c30 <cprintf>
    return -1;
801020f4:	83 c4 10             	add    $0x10,%esp
801020f7:	e9 f0 fd ff ff       	jmp    80101eec <exec+0x16c>
801020fc:	66 90                	xchg   %ax,%ax
801020fe:	66 90                	xchg   %ax,%ax

80102100 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102106:	68 bc 84 10 80       	push   $0x801084bc
8010210b:	68 e0 01 11 80       	push   $0x801101e0
80102110:	e8 6b 35 00 00       	call   80105680 <initlock>
}
80102115:	83 c4 10             	add    $0x10,%esp
80102118:	c9                   	leave
80102119:	c3                   	ret
8010211a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102120 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102124:	bb 14 02 11 80       	mov    $0x80110214,%ebx
{
80102129:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010212c:	68 e0 01 11 80       	push   $0x801101e0
80102131:	e8 3a 37 00 00       	call   80105870 <acquire>
80102136:	83 c4 10             	add    $0x10,%esp
80102139:	eb 10                	jmp    8010214b <filealloc+0x2b>
8010213b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102140:	83 c3 18             	add    $0x18,%ebx
80102143:	81 fb 74 0b 11 80    	cmp    $0x80110b74,%ebx
80102149:	74 25                	je     80102170 <filealloc+0x50>
    if(f->ref == 0){
8010214b:	8b 43 04             	mov    0x4(%ebx),%eax
8010214e:	85 c0                	test   %eax,%eax
80102150:	75 ee                	jne    80102140 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102152:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102155:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010215c:	68 e0 01 11 80       	push   $0x801101e0
80102161:	e8 aa 36 00 00       	call   80105810 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102166:	89 d8                	mov    %ebx,%eax
      return f;
80102168:	83 c4 10             	add    $0x10,%esp
}
8010216b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010216e:	c9                   	leave
8010216f:	c3                   	ret
  release(&ftable.lock);
80102170:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102173:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102175:	68 e0 01 11 80       	push   $0x801101e0
8010217a:	e8 91 36 00 00       	call   80105810 <release>
}
8010217f:	89 d8                	mov    %ebx,%eax
  return 0;
80102181:	83 c4 10             	add    $0x10,%esp
}
80102184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102187:	c9                   	leave
80102188:	c3                   	ret
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102190 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	53                   	push   %ebx
80102194:	83 ec 10             	sub    $0x10,%esp
80102197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010219a:	68 e0 01 11 80       	push   $0x801101e0
8010219f:	e8 cc 36 00 00       	call   80105870 <acquire>
  if(f->ref < 1)
801021a4:	8b 43 04             	mov    0x4(%ebx),%eax
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	85 c0                	test   %eax,%eax
801021ac:	7e 1a                	jle    801021c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801021ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801021b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801021b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801021b7:	68 e0 01 11 80       	push   $0x801101e0
801021bc:	e8 4f 36 00 00       	call   80105810 <release>
  return f;
}
801021c1:	89 d8                	mov    %ebx,%eax
801021c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021c6:	c9                   	leave
801021c7:	c3                   	ret
    panic("filedup");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 c3 84 10 80       	push   $0x801084c3
801021d0:	e8 6b e3 ff ff       	call   80100540 <panic>
801021d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021dc:	00 
801021dd:	8d 76 00             	lea    0x0(%esi),%esi

801021e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 28             	sub    $0x28,%esp
801021e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801021ec:	68 e0 01 11 80       	push   $0x801101e0
801021f1:	e8 7a 36 00 00       	call   80105870 <acquire>
  if(f->ref < 1)
801021f6:	8b 53 04             	mov    0x4(%ebx),%edx
801021f9:	83 c4 10             	add    $0x10,%esp
801021fc:	85 d2                	test   %edx,%edx
801021fe:	0f 8e a5 00 00 00    	jle    801022a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102204:	83 ea 01             	sub    $0x1,%edx
80102207:	89 53 04             	mov    %edx,0x4(%ebx)
8010220a:	75 44                	jne    80102250 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010220c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102210:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102213:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102215:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010221b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010221e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102221:	8b 43 10             	mov    0x10(%ebx),%eax
80102224:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80102227:	68 e0 01 11 80       	push   $0x801101e0
8010222c:	e8 df 35 00 00       	call   80105810 <release>

  if(ff.type == FD_PIPE)
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	83 ff 01             	cmp    $0x1,%edi
80102237:	74 57                	je     80102290 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102239:	83 ff 02             	cmp    $0x2,%edi
8010223c:	74 2a                	je     80102268 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010223e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102241:	5b                   	pop    %ebx
80102242:	5e                   	pop    %esi
80102243:	5f                   	pop    %edi
80102244:	5d                   	pop    %ebp
80102245:	c3                   	ret
80102246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010224d:	00 
8010224e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80102250:	c7 45 08 e0 01 11 80 	movl   $0x801101e0,0x8(%ebp)
}
80102257:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010225a:	5b                   	pop    %ebx
8010225b:	5e                   	pop    %esi
8010225c:	5f                   	pop    %edi
8010225d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010225e:	e9 ad 35 00 00       	jmp    80105810 <release>
80102263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80102268:	e8 a3 1d 00 00       	call   80104010 <begin_op>
    iput(ff.ip);
8010226d:	83 ec 0c             	sub    $0xc,%esp
80102270:	ff 75 e0             	push   -0x20(%ebp)
80102273:	e8 28 09 00 00       	call   80102ba0 <iput>
    end_op();
80102278:	83 c4 10             	add    $0x10,%esp
}
8010227b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227e:	5b                   	pop    %ebx
8010227f:	5e                   	pop    %esi
80102280:	5f                   	pop    %edi
80102281:	5d                   	pop    %ebp
    end_op();
80102282:	e9 f9 1d 00 00       	jmp    80104080 <end_op>
80102287:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010228e:	00 
8010228f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80102290:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102294:	83 ec 08             	sub    $0x8,%esp
80102297:	53                   	push   %ebx
80102298:	56                   	push   %esi
80102299:	e8 32 25 00 00       	call   801047d0 <pipeclose>
8010229e:	83 c4 10             	add    $0x10,%esp
}
801022a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a4:	5b                   	pop    %ebx
801022a5:	5e                   	pop    %esi
801022a6:	5f                   	pop    %edi
801022a7:	5d                   	pop    %ebp
801022a8:	c3                   	ret
    panic("fileclose");
801022a9:	83 ec 0c             	sub    $0xc,%esp
801022ac:	68 cb 84 10 80       	push   $0x801084cb
801022b1:	e8 8a e2 ff ff       	call   80100540 <panic>
801022b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022bd:	00 
801022be:	66 90                	xchg   %ax,%ax

801022c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 04             	sub    $0x4,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801022ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801022cd:	75 31                	jne    80102300 <filestat+0x40>
    ilock(f->ip);
801022cf:	83 ec 0c             	sub    $0xc,%esp
801022d2:	ff 73 10             	push   0x10(%ebx)
801022d5:	e8 96 07 00 00       	call   80102a70 <ilock>
    stati(f->ip, st);
801022da:	58                   	pop    %eax
801022db:	5a                   	pop    %edx
801022dc:	ff 75 0c             	push   0xc(%ebp)
801022df:	ff 73 10             	push   0x10(%ebx)
801022e2:	e8 69 0a 00 00       	call   80102d50 <stati>
    iunlock(f->ip);
801022e7:	59                   	pop    %ecx
801022e8:	ff 73 10             	push   0x10(%ebx)
801022eb:	e8 60 08 00 00       	call   80102b50 <iunlock>
    return 0;
  }
  return -1;
}
801022f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	31 c0                	xor    %eax,%eax
}
801022f8:	c9                   	leave
801022f9:	c3                   	ret
801022fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102308:	c9                   	leave
80102309:	c3                   	ret
8010230a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102310 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	57                   	push   %edi
80102314:	56                   	push   %esi
80102315:	53                   	push   %ebx
80102316:	83 ec 0c             	sub    $0xc,%esp
80102319:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010231c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010231f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102322:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102326:	74 60                	je     80102388 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102328:	8b 03                	mov    (%ebx),%eax
8010232a:	83 f8 01             	cmp    $0x1,%eax
8010232d:	74 41                	je     80102370 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010232f:	83 f8 02             	cmp    $0x2,%eax
80102332:	75 5b                	jne    8010238f <fileread+0x7f>
    ilock(f->ip);
80102334:	83 ec 0c             	sub    $0xc,%esp
80102337:	ff 73 10             	push   0x10(%ebx)
8010233a:	e8 31 07 00 00       	call   80102a70 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010233f:	57                   	push   %edi
80102340:	ff 73 14             	push   0x14(%ebx)
80102343:	56                   	push   %esi
80102344:	ff 73 10             	push   0x10(%ebx)
80102347:	e8 34 0a 00 00       	call   80102d80 <readi>
8010234c:	83 c4 20             	add    $0x20,%esp
8010234f:	89 c6                	mov    %eax,%esi
80102351:	85 c0                	test   %eax,%eax
80102353:	7e 03                	jle    80102358 <fileread+0x48>
      f->off += r;
80102355:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102358:	83 ec 0c             	sub    $0xc,%esp
8010235b:	ff 73 10             	push   0x10(%ebx)
8010235e:	e8 ed 07 00 00       	call   80102b50 <iunlock>
    return r;
80102363:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102369:	89 f0                	mov    %esi,%eax
8010236b:	5b                   	pop    %ebx
8010236c:	5e                   	pop    %esi
8010236d:	5f                   	pop    %edi
8010236e:	5d                   	pop    %ebp
8010236f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80102370:	8b 43 0c             	mov    0xc(%ebx),%eax
80102373:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102379:	5b                   	pop    %ebx
8010237a:	5e                   	pop    %esi
8010237b:	5f                   	pop    %edi
8010237c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010237d:	e9 0e 26 00 00       	jmp    80104990 <piperead>
80102382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102388:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010238d:	eb d7                	jmp    80102366 <fileread+0x56>
  panic("fileread");
8010238f:	83 ec 0c             	sub    $0xc,%esp
80102392:	68 d5 84 10 80       	push   $0x801084d5
80102397:	e8 a4 e1 ff ff       	call   80100540 <panic>
8010239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	57                   	push   %edi
801023a4:	56                   	push   %esi
801023a5:	53                   	push   %ebx
801023a6:	83 ec 1c             	sub    $0x1c,%esp
801023a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
801023af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801023b2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801023b5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801023b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801023bc:	0f 84 bb 00 00 00    	je     8010247d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801023c2:	8b 03                	mov    (%ebx),%eax
801023c4:	83 f8 01             	cmp    $0x1,%eax
801023c7:	0f 84 bf 00 00 00    	je     8010248c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801023cd:	83 f8 02             	cmp    $0x2,%eax
801023d0:	0f 85 c8 00 00 00    	jne    8010249e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801023d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801023d9:	31 f6                	xor    %esi,%esi
    while(i < n){
801023db:	85 c0                	test   %eax,%eax
801023dd:	7f 30                	jg     8010240f <filewrite+0x6f>
801023df:	e9 94 00 00 00       	jmp    80102478 <filewrite+0xd8>
801023e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801023e8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801023eb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801023ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801023f1:	ff 73 10             	push   0x10(%ebx)
801023f4:	e8 57 07 00 00       	call   80102b50 <iunlock>
      end_op();
801023f9:	e8 82 1c 00 00       	call   80104080 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801023fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102401:	83 c4 10             	add    $0x10,%esp
80102404:	39 c7                	cmp    %eax,%edi
80102406:	75 5c                	jne    80102464 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102408:	01 fe                	add    %edi,%esi
    while(i < n){
8010240a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010240d:	7e 69                	jle    80102478 <filewrite+0xd8>
      int n1 = n - i;
8010240f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80102412:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80102417:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80102419:	39 c7                	cmp    %eax,%edi
8010241b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010241e:	e8 ed 1b 00 00       	call   80104010 <begin_op>
      ilock(f->ip);
80102423:	83 ec 0c             	sub    $0xc,%esp
80102426:	ff 73 10             	push   0x10(%ebx)
80102429:	e8 42 06 00 00       	call   80102a70 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010242e:	57                   	push   %edi
8010242f:	ff 73 14             	push   0x14(%ebx)
80102432:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102435:	01 f0                	add    %esi,%eax
80102437:	50                   	push   %eax
80102438:	ff 73 10             	push   0x10(%ebx)
8010243b:	e8 40 0a 00 00       	call   80102e80 <writei>
80102440:	83 c4 20             	add    $0x20,%esp
80102443:	85 c0                	test   %eax,%eax
80102445:	7f a1                	jg     801023e8 <filewrite+0x48>
80102447:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010244a:	83 ec 0c             	sub    $0xc,%esp
8010244d:	ff 73 10             	push   0x10(%ebx)
80102450:	e8 fb 06 00 00       	call   80102b50 <iunlock>
      end_op();
80102455:	e8 26 1c 00 00       	call   80104080 <end_op>
      if(r < 0)
8010245a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010245d:	83 c4 10             	add    $0x10,%esp
80102460:	85 c0                	test   %eax,%eax
80102462:	75 14                	jne    80102478 <filewrite+0xd8>
        panic("short filewrite");
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	68 de 84 10 80       	push   $0x801084de
8010246c:	e8 cf e0 ff ff       	call   80100540 <panic>
80102471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102478:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010247b:	74 05                	je     80102482 <filewrite+0xe2>
8010247d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80102482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102485:	89 f0                	mov    %esi,%eax
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5f                   	pop    %edi
8010248a:	5d                   	pop    %ebp
8010248b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010248c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010248f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102495:	5b                   	pop    %ebx
80102496:	5e                   	pop    %esi
80102497:	5f                   	pop    %edi
80102498:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102499:	e9 d2 23 00 00       	jmp    80104870 <pipewrite>
  panic("filewrite");
8010249e:	83 ec 0c             	sub    $0xc,%esp
801024a1:	68 e4 84 10 80       	push   $0x801084e4
801024a6:	e8 95 e0 ff ff       	call   80100540 <panic>
801024ab:	66 90                	xchg   %ax,%ax
801024ad:	66 90                	xchg   %ax,%ax
801024af:	90                   	nop

801024b0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801024b9:	8b 0d 34 28 11 80    	mov    0x80112834,%ecx
{
801024bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801024c2:	85 c9                	test   %ecx,%ecx
801024c4:	0f 84 8c 00 00 00    	je     80102556 <balloc+0xa6>
801024ca:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801024cc:	89 f8                	mov    %edi,%eax
801024ce:	83 ec 08             	sub    $0x8,%esp
801024d1:	89 fe                	mov    %edi,%esi
801024d3:	c1 f8 0c             	sar    $0xc,%eax
801024d6:	03 05 4c 28 11 80    	add    0x8011284c,%eax
801024dc:	50                   	push   %eax
801024dd:	ff 75 dc             	push   -0x24(%ebp)
801024e0:	e8 eb db ff ff       	call   801000d0 <bread>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801024eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801024ee:	a1 34 28 11 80       	mov    0x80112834,%eax
801024f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801024f6:	31 c0                	xor    %eax,%eax
801024f8:	eb 32                	jmp    8010252c <balloc+0x7c>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80102500:	89 c1                	mov    %eax,%ecx
80102502:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102507:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010250a:	83 e1 07             	and    $0x7,%ecx
8010250d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010250f:	89 c1                	mov    %eax,%ecx
80102511:	c1 f9 03             	sar    $0x3,%ecx
80102514:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80102519:	89 fa                	mov    %edi,%edx
8010251b:	85 df                	test   %ebx,%edi
8010251d:	74 49                	je     80102568 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010251f:	83 c0 01             	add    $0x1,%eax
80102522:	83 c6 01             	add    $0x1,%esi
80102525:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010252a:	74 07                	je     80102533 <balloc+0x83>
8010252c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010252f:	39 d6                	cmp    %edx,%esi
80102531:	72 cd                	jb     80102500 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80102533:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010253c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80102542:	e8 a9 dc ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80102547:	83 c4 10             	add    $0x10,%esp
8010254a:	3b 3d 34 28 11 80    	cmp    0x80112834,%edi
80102550:	0f 82 76 ff ff ff    	jb     801024cc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	68 ee 84 10 80       	push   $0x801084ee
8010255e:	e8 dd df ff ff       	call   80100540 <panic>
80102563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80102568:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010256b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010256e:	09 da                	or     %ebx,%edx
80102570:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80102574:	57                   	push   %edi
80102575:	e8 76 1c 00 00       	call   801041f0 <log_write>
        brelse(bp);
8010257a:	89 3c 24             	mov    %edi,(%esp)
8010257d:	e8 6e dc ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80102582:	58                   	pop    %eax
80102583:	5a                   	pop    %edx
80102584:	56                   	push   %esi
80102585:	ff 75 dc             	push   -0x24(%ebp)
80102588:	e8 43 db ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010258d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102590:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80102592:	8d 40 5c             	lea    0x5c(%eax),%eax
80102595:	68 00 02 00 00       	push   $0x200
8010259a:	6a 00                	push   $0x0
8010259c:	50                   	push   %eax
8010259d:	e8 ce 33 00 00       	call   80105970 <memset>
  log_write(bp);
801025a2:	89 1c 24             	mov    %ebx,(%esp)
801025a5:	e8 46 1c 00 00       	call   801041f0 <log_write>
  brelse(bp);
801025aa:	89 1c 24             	mov    %ebx,(%esp)
801025ad:	e8 3e dc ff ff       	call   801001f0 <brelse>
}
801025b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025b5:	89 f0                	mov    %esi,%eax
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5f                   	pop    %edi
801025ba:	5d                   	pop    %ebp
801025bb:	c3                   	ret
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801025c4:	31 ff                	xor    %edi,%edi
{
801025c6:	56                   	push   %esi
801025c7:	89 c6                	mov    %eax,%esi
801025c9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801025ca:	bb 14 0c 11 80       	mov    $0x80110c14,%ebx
{
801025cf:	83 ec 28             	sub    $0x28,%esp
801025d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801025d5:	68 e0 0b 11 80       	push   $0x80110be0
801025da:	e8 91 32 00 00       	call   80105870 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801025df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801025e2:	83 c4 10             	add    $0x10,%esp
801025e5:	eb 1b                	jmp    80102602 <iget+0x42>
801025e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ee:	00 
801025ef:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801025f0:	39 33                	cmp    %esi,(%ebx)
801025f2:	74 6c                	je     80102660 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801025f4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801025fa:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
80102600:	74 26                	je     80102628 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102602:	8b 43 08             	mov    0x8(%ebx),%eax
80102605:	85 c0                	test   %eax,%eax
80102607:	7f e7                	jg     801025f0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80102609:	85 ff                	test   %edi,%edi
8010260b:	75 e7                	jne    801025f4 <iget+0x34>
8010260d:	85 c0                	test   %eax,%eax
8010260f:	75 76                	jne    80102687 <iget+0xc7>
      empty = ip;
80102611:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102613:	81 c3 90 00 00 00    	add    $0x90,%ebx
80102619:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
8010261f:	75 e1                	jne    80102602 <iget+0x42>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80102628:	85 ff                	test   %edi,%edi
8010262a:	74 79                	je     801026a5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010262c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010262f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80102631:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80102634:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010263b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80102642:	68 e0 0b 11 80       	push   $0x80110be0
80102647:	e8 c4 31 00 00       	call   80105810 <release>

  return ip;
8010264c:	83 c4 10             	add    $0x10,%esp
}
8010264f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102652:	89 f8                	mov    %edi,%eax
80102654:	5b                   	pop    %ebx
80102655:	5e                   	pop    %esi
80102656:	5f                   	pop    %edi
80102657:	5d                   	pop    %ebp
80102658:	c3                   	ret
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102660:	39 53 04             	cmp    %edx,0x4(%ebx)
80102663:	75 8f                	jne    801025f4 <iget+0x34>
      ip->ref++;
80102665:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80102668:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010266b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010266d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102670:	68 e0 0b 11 80       	push   $0x80110be0
80102675:	e8 96 31 00 00       	call   80105810 <release>
      return ip;
8010267a:	83 c4 10             	add    $0x10,%esp
}
8010267d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102680:	89 f8                	mov    %edi,%eax
80102682:	5b                   	pop    %ebx
80102683:	5e                   	pop    %esi
80102684:	5f                   	pop    %edi
80102685:	5d                   	pop    %ebp
80102686:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102687:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010268d:	81 fb 34 28 11 80    	cmp    $0x80112834,%ebx
80102693:	74 10                	je     801026a5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102695:	8b 43 08             	mov    0x8(%ebx),%eax
80102698:	85 c0                	test   %eax,%eax
8010269a:	0f 8f 50 ff ff ff    	jg     801025f0 <iget+0x30>
801026a0:	e9 68 ff ff ff       	jmp    8010260d <iget+0x4d>
    panic("iget: no inodes");
801026a5:	83 ec 0c             	sub    $0xc,%esp
801026a8:	68 04 85 10 80       	push   $0x80108504
801026ad:	e8 8e de ff ff       	call   80100540 <panic>
801026b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026b9:	00 
801026ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801026c0 <bfree>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801026c3:	89 d0                	mov    %edx,%eax
801026c5:	c1 e8 0c             	shr    $0xc,%eax
{
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	56                   	push   %esi
801026cb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801026cc:	03 05 4c 28 11 80    	add    0x8011284c,%eax
{
801026d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801026d4:	83 ec 08             	sub    $0x8,%esp
801026d7:	50                   	push   %eax
801026d8:	51                   	push   %ecx
801026d9:	e8 f2 d9 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801026de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801026e0:	c1 fb 03             	sar    $0x3,%ebx
801026e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801026e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801026e8:	83 e1 07             	and    $0x7,%ecx
801026eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801026f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801026f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801026f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801026fd:	85 c1                	test   %eax,%ecx
801026ff:	74 23                	je     80102724 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80102701:	f7 d0                	not    %eax
  log_write(bp);
80102703:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80102706:	21 c8                	and    %ecx,%eax
80102708:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010270c:	56                   	push   %esi
8010270d:	e8 de 1a 00 00       	call   801041f0 <log_write>
  brelse(bp);
80102712:	89 34 24             	mov    %esi,(%esp)
80102715:	e8 d6 da ff ff       	call   801001f0 <brelse>
}
8010271a:	83 c4 10             	add    $0x10,%esp
8010271d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102720:	5b                   	pop    %ebx
80102721:	5e                   	pop    %esi
80102722:	5d                   	pop    %ebp
80102723:	c3                   	ret
    panic("freeing free block");
80102724:	83 ec 0c             	sub    $0xc,%esp
80102727:	68 14 85 10 80       	push   $0x80108514
8010272c:	e8 0f de ff ff       	call   80100540 <panic>
80102731:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102738:	00 
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102740 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	57                   	push   %edi
80102744:	56                   	push   %esi
80102745:	89 c6                	mov    %eax,%esi
80102747:	53                   	push   %ebx
80102748:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010274b:	83 fa 0b             	cmp    $0xb,%edx
8010274e:	0f 86 8c 00 00 00    	jbe    801027e0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102754:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102757:	83 fb 7f             	cmp    $0x7f,%ebx
8010275a:	0f 87 a2 00 00 00    	ja     80102802 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102760:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102766:	85 c0                	test   %eax,%eax
80102768:	74 5e                	je     801027c8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010276a:	83 ec 08             	sub    $0x8,%esp
8010276d:	50                   	push   %eax
8010276e:	ff 36                	push   (%esi)
80102770:	e8 5b d9 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010277c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010277e:	8b 3b                	mov    (%ebx),%edi
80102780:	85 ff                	test   %edi,%edi
80102782:	74 1c                	je     801027a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80102784:	83 ec 0c             	sub    $0xc,%esp
80102787:	52                   	push   %edx
80102788:	e8 63 da ff ff       	call   801001f0 <brelse>
8010278d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80102790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102793:	89 f8                	mov    %edi,%eax
80102795:	5b                   	pop    %ebx
80102796:	5e                   	pop    %esi
80102797:	5f                   	pop    %edi
80102798:	5d                   	pop    %ebp
80102799:	c3                   	ret
8010279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801027a3:	8b 06                	mov    (%esi),%eax
801027a5:	e8 06 fd ff ff       	call   801024b0 <balloc>
      log_write(bp);
801027aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801027ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801027b0:	89 03                	mov    %eax,(%ebx)
801027b2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801027b4:	52                   	push   %edx
801027b5:	e8 36 1a 00 00       	call   801041f0 <log_write>
801027ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801027bd:	83 c4 10             	add    $0x10,%esp
801027c0:	eb c2                	jmp    80102784 <bmap+0x44>
801027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801027c8:	8b 06                	mov    (%esi),%eax
801027ca:	e8 e1 fc ff ff       	call   801024b0 <balloc>
801027cf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801027d5:	eb 93                	jmp    8010276a <bmap+0x2a>
801027d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027de:	00 
801027df:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
801027e0:	8d 5a 14             	lea    0x14(%edx),%ebx
801027e3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801027e7:	85 ff                	test   %edi,%edi
801027e9:	75 a5                	jne    80102790 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801027eb:	8b 00                	mov    (%eax),%eax
801027ed:	e8 be fc ff ff       	call   801024b0 <balloc>
801027f2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801027f6:	89 c7                	mov    %eax,%edi
}
801027f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027fb:	5b                   	pop    %ebx
801027fc:	89 f8                	mov    %edi,%eax
801027fe:	5e                   	pop    %esi
801027ff:	5f                   	pop    %edi
80102800:	5d                   	pop    %ebp
80102801:	c3                   	ret
  panic("bmap: out of range");
80102802:	83 ec 0c             	sub    $0xc,%esp
80102805:	68 27 85 10 80       	push   $0x80108527
8010280a:	e8 31 dd ff ff       	call   80100540 <panic>
8010280f:	90                   	nop

80102810 <readsb>:
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	56                   	push   %esi
80102814:	53                   	push   %ebx
80102815:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102818:	83 ec 08             	sub    $0x8,%esp
8010281b:	6a 01                	push   $0x1
8010281d:	ff 75 08             	push   0x8(%ebp)
80102820:	e8 ab d8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102825:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102828:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010282a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010282d:	6a 1c                	push   $0x1c
8010282f:	50                   	push   %eax
80102830:	56                   	push   %esi
80102831:	e8 ca 31 00 00       	call   80105a00 <memmove>
  brelse(bp);
80102836:	83 c4 10             	add    $0x10,%esp
80102839:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010283c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010283f:	5b                   	pop    %ebx
80102840:	5e                   	pop    %esi
80102841:	5d                   	pop    %ebp
  brelse(bp);
80102842:	e9 a9 d9 ff ff       	jmp    801001f0 <brelse>
80102847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010284e:	00 
8010284f:	90                   	nop

80102850 <iinit>:
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	bb 20 0c 11 80       	mov    $0x80110c20,%ebx
80102859:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010285c:	68 3a 85 10 80       	push   $0x8010853a
80102861:	68 e0 0b 11 80       	push   $0x80110be0
80102866:	e8 15 2e 00 00       	call   80105680 <initlock>
  for(i = 0; i < NINODE; i++) {
8010286b:	83 c4 10             	add    $0x10,%esp
8010286e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102870:	83 ec 08             	sub    $0x8,%esp
80102873:	68 41 85 10 80       	push   $0x80108541
80102878:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102879:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010287f:	e8 cc 2c 00 00       	call   80105550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102884:	83 c4 10             	add    $0x10,%esp
80102887:	81 fb 40 28 11 80    	cmp    $0x80112840,%ebx
8010288d:	75 e1                	jne    80102870 <iinit+0x20>
  bp = bread(dev, 1);
8010288f:	83 ec 08             	sub    $0x8,%esp
80102892:	6a 01                	push   $0x1
80102894:	ff 75 08             	push   0x8(%ebp)
80102897:	e8 34 d8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010289c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010289f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801028a1:	8d 40 5c             	lea    0x5c(%eax),%eax
801028a4:	6a 1c                	push   $0x1c
801028a6:	50                   	push   %eax
801028a7:	68 34 28 11 80       	push   $0x80112834
801028ac:	e8 4f 31 00 00       	call   80105a00 <memmove>
  brelse(bp);
801028b1:	89 1c 24             	mov    %ebx,(%esp)
801028b4:	e8 37 d9 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801028b9:	ff 35 4c 28 11 80    	push   0x8011284c
801028bf:	ff 35 48 28 11 80    	push   0x80112848
801028c5:	ff 35 44 28 11 80    	push   0x80112844
801028cb:	ff 35 40 28 11 80    	push   0x80112840
801028d1:	ff 35 3c 28 11 80    	push   0x8011283c
801028d7:	ff 35 38 28 11 80    	push   0x80112838
801028dd:	ff 35 34 28 11 80    	push   0x80112834
801028e3:	68 c0 89 10 80       	push   $0x801089c0
801028e8:	e8 43 e3 ff ff       	call   80100c30 <cprintf>
}
801028ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028f0:	83 c4 30             	add    $0x30,%esp
801028f3:	c9                   	leave
801028f4:	c3                   	ret
801028f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028fc:	00 
801028fd:	8d 76 00             	lea    0x0(%esi),%esi

80102900 <ialloc>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	57                   	push   %edi
80102904:	56                   	push   %esi
80102905:	53                   	push   %ebx
80102906:	83 ec 1c             	sub    $0x1c,%esp
80102909:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010290c:	83 3d 3c 28 11 80 01 	cmpl   $0x1,0x8011283c
{
80102913:	8b 75 08             	mov    0x8(%ebp),%esi
80102916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102919:	0f 86 91 00 00 00    	jbe    801029b0 <ialloc+0xb0>
8010291f:	bf 01 00 00 00       	mov    $0x1,%edi
80102924:	eb 21                	jmp    80102947 <ialloc+0x47>
80102926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010292d:	00 
8010292e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80102930:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102933:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102936:	53                   	push   %ebx
80102937:	e8 b4 d8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	3b 3d 3c 28 11 80    	cmp    0x8011283c,%edi
80102945:	73 69                	jae    801029b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102947:	89 f8                	mov    %edi,%eax
80102949:	83 ec 08             	sub    $0x8,%esp
8010294c:	c1 e8 03             	shr    $0x3,%eax
8010294f:	03 05 48 28 11 80    	add    0x80112848,%eax
80102955:	50                   	push   %eax
80102956:	56                   	push   %esi
80102957:	e8 74 d7 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010295c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010295f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102961:	89 f8                	mov    %edi,%eax
80102963:	83 e0 07             	and    $0x7,%eax
80102966:	c1 e0 06             	shl    $0x6,%eax
80102969:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010296d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102971:	75 bd                	jne    80102930 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102973:	83 ec 04             	sub    $0x4,%esp
80102976:	6a 40                	push   $0x40
80102978:	6a 00                	push   $0x0
8010297a:	51                   	push   %ecx
8010297b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010297e:	e8 ed 2f 00 00       	call   80105970 <memset>
      dip->type = type;
80102983:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102987:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010298a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010298d:	89 1c 24             	mov    %ebx,(%esp)
80102990:	e8 5b 18 00 00       	call   801041f0 <log_write>
      brelse(bp);
80102995:	89 1c 24             	mov    %ebx,(%esp)
80102998:	e8 53 d8 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010299d:	83 c4 10             	add    $0x10,%esp
}
801029a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801029a3:	89 fa                	mov    %edi,%edx
}
801029a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801029a6:	89 f0                	mov    %esi,%eax
}
801029a8:	5e                   	pop    %esi
801029a9:	5f                   	pop    %edi
801029aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801029ab:	e9 10 fc ff ff       	jmp    801025c0 <iget>
  panic("ialloc: no inodes");
801029b0:	83 ec 0c             	sub    $0xc,%esp
801029b3:	68 47 85 10 80       	push   $0x80108547
801029b8:	e8 83 db ff ff       	call   80100540 <panic>
801029bd:	8d 76 00             	lea    0x0(%esi),%esi

801029c0 <iupdate>:
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	56                   	push   %esi
801029c4:	53                   	push   %ebx
801029c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029c8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801029cb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029ce:	83 ec 08             	sub    $0x8,%esp
801029d1:	c1 e8 03             	shr    $0x3,%eax
801029d4:	03 05 48 28 11 80    	add    0x80112848,%eax
801029da:	50                   	push   %eax
801029db:	ff 73 a4             	push   -0x5c(%ebx)
801029de:	e8 ed d6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801029e3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801029e7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801029ea:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801029ec:	8b 43 a8             	mov    -0x58(%ebx),%eax
801029ef:	83 e0 07             	and    $0x7,%eax
801029f2:	c1 e0 06             	shl    $0x6,%eax
801029f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801029f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801029fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a00:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102a03:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102a07:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102a0b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102a0f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102a13:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102a17:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102a1a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102a1d:	6a 34                	push   $0x34
80102a1f:	53                   	push   %ebx
80102a20:	50                   	push   %eax
80102a21:	e8 da 2f 00 00       	call   80105a00 <memmove>
  log_write(bp);
80102a26:	89 34 24             	mov    %esi,(%esp)
80102a29:	e8 c2 17 00 00       	call   801041f0 <log_write>
  brelse(bp);
80102a2e:	83 c4 10             	add    $0x10,%esp
80102a31:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a37:	5b                   	pop    %ebx
80102a38:	5e                   	pop    %esi
80102a39:	5d                   	pop    %ebp
  brelse(bp);
80102a3a:	e9 b1 d7 ff ff       	jmp    801001f0 <brelse>
80102a3f:	90                   	nop

80102a40 <idup>:
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	53                   	push   %ebx
80102a44:	83 ec 10             	sub    $0x10,%esp
80102a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102a4a:	68 e0 0b 11 80       	push   $0x80110be0
80102a4f:	e8 1c 2e 00 00       	call   80105870 <acquire>
  ip->ref++;
80102a54:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102a58:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
80102a5f:	e8 ac 2d 00 00       	call   80105810 <release>
}
80102a64:	89 d8                	mov    %ebx,%eax
80102a66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a69:	c9                   	leave
80102a6a:	c3                   	ret
80102a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102a70 <ilock>:
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102a78:	85 db                	test   %ebx,%ebx
80102a7a:	0f 84 b7 00 00 00    	je     80102b37 <ilock+0xc7>
80102a80:	8b 53 08             	mov    0x8(%ebx),%edx
80102a83:	85 d2                	test   %edx,%edx
80102a85:	0f 8e ac 00 00 00    	jle    80102b37 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102a8b:	83 ec 0c             	sub    $0xc,%esp
80102a8e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102a91:	50                   	push   %eax
80102a92:	e8 f9 2a 00 00       	call   80105590 <acquiresleep>
  if(ip->valid == 0){
80102a97:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102a9a:	83 c4 10             	add    $0x10,%esp
80102a9d:	85 c0                	test   %eax,%eax
80102a9f:	74 0f                	je     80102ab0 <ilock+0x40>
}
80102aa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa4:	5b                   	pop    %ebx
80102aa5:	5e                   	pop    %esi
80102aa6:	5d                   	pop    %ebp
80102aa7:	c3                   	ret
80102aa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102aaf:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102ab0:	8b 43 04             	mov    0x4(%ebx),%eax
80102ab3:	83 ec 08             	sub    $0x8,%esp
80102ab6:	c1 e8 03             	shr    $0x3,%eax
80102ab9:	03 05 48 28 11 80    	add    0x80112848,%eax
80102abf:	50                   	push   %eax
80102ac0:	ff 33                	push   (%ebx)
80102ac2:	e8 09 d6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102ac7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102aca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102acc:	8b 43 04             	mov    0x4(%ebx),%eax
80102acf:	83 e0 07             	and    $0x7,%eax
80102ad2:	c1 e0 06             	shl    $0x6,%eax
80102ad5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102ad9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102adc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102adf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102ae3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102ae7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102aeb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102aef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102af3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102af7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102afb:	8b 50 fc             	mov    -0x4(%eax),%edx
80102afe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102b01:	6a 34                	push   $0x34
80102b03:	50                   	push   %eax
80102b04:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102b07:	50                   	push   %eax
80102b08:	e8 f3 2e 00 00       	call   80105a00 <memmove>
    brelse(bp);
80102b0d:	89 34 24             	mov    %esi,(%esp)
80102b10:	e8 db d6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102b15:	83 c4 10             	add    $0x10,%esp
80102b18:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102b1d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102b24:	0f 85 77 ff ff ff    	jne    80102aa1 <ilock+0x31>
      panic("ilock: no type");
80102b2a:	83 ec 0c             	sub    $0xc,%esp
80102b2d:	68 5f 85 10 80       	push   $0x8010855f
80102b32:	e8 09 da ff ff       	call   80100540 <panic>
    panic("ilock");
80102b37:	83 ec 0c             	sub    $0xc,%esp
80102b3a:	68 59 85 10 80       	push   $0x80108559
80102b3f:	e8 fc d9 ff ff       	call   80100540 <panic>
80102b44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b4b:	00 
80102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b50 <iunlock>:
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
80102b55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102b58:	85 db                	test   %ebx,%ebx
80102b5a:	74 28                	je     80102b84 <iunlock+0x34>
80102b5c:	83 ec 0c             	sub    $0xc,%esp
80102b5f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102b62:	56                   	push   %esi
80102b63:	e8 c8 2a 00 00       	call   80105630 <holdingsleep>
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 c0                	test   %eax,%eax
80102b6d:	74 15                	je     80102b84 <iunlock+0x34>
80102b6f:	8b 43 08             	mov    0x8(%ebx),%eax
80102b72:	85 c0                	test   %eax,%eax
80102b74:	7e 0e                	jle    80102b84 <iunlock+0x34>
  releasesleep(&ip->lock);
80102b76:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102b79:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b7c:	5b                   	pop    %ebx
80102b7d:	5e                   	pop    %esi
80102b7e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102b7f:	e9 6c 2a 00 00       	jmp    801055f0 <releasesleep>
    panic("iunlock");
80102b84:	83 ec 0c             	sub    $0xc,%esp
80102b87:	68 6e 85 10 80       	push   $0x8010856e
80102b8c:	e8 af d9 ff ff       	call   80100540 <panic>
80102b91:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b98:	00 
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <iput>:
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	57                   	push   %edi
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 28             	sub    $0x28,%esp
80102ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102bac:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102baf:	57                   	push   %edi
80102bb0:	e8 db 29 00 00       	call   80105590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102bb5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102bb8:	83 c4 10             	add    $0x10,%esp
80102bbb:	85 d2                	test   %edx,%edx
80102bbd:	74 07                	je     80102bc6 <iput+0x26>
80102bbf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102bc4:	74 32                	je     80102bf8 <iput+0x58>
  releasesleep(&ip->lock);
80102bc6:	83 ec 0c             	sub    $0xc,%esp
80102bc9:	57                   	push   %edi
80102bca:	e8 21 2a 00 00       	call   801055f0 <releasesleep>
  acquire(&icache.lock);
80102bcf:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
80102bd6:	e8 95 2c 00 00       	call   80105870 <acquire>
  ip->ref--;
80102bdb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102bdf:	83 c4 10             	add    $0x10,%esp
80102be2:	c7 45 08 e0 0b 11 80 	movl   $0x80110be0,0x8(%ebp)
}
80102be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bec:	5b                   	pop    %ebx
80102bed:	5e                   	pop    %esi
80102bee:	5f                   	pop    %edi
80102bef:	5d                   	pop    %ebp
  release(&icache.lock);
80102bf0:	e9 1b 2c 00 00       	jmp    80105810 <release>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102bf8:	83 ec 0c             	sub    $0xc,%esp
80102bfb:	68 e0 0b 11 80       	push   $0x80110be0
80102c00:	e8 6b 2c 00 00       	call   80105870 <acquire>
    int r = ip->ref;
80102c05:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102c08:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
80102c0f:	e8 fc 2b 00 00       	call   80105810 <release>
    if(r == 1){
80102c14:	83 c4 10             	add    $0x10,%esp
80102c17:	83 fe 01             	cmp    $0x1,%esi
80102c1a:	75 aa                	jne    80102bc6 <iput+0x26>
80102c1c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102c22:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102c25:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102c28:	89 df                	mov    %ebx,%edi
80102c2a:	89 cb                	mov    %ecx,%ebx
80102c2c:	eb 09                	jmp    80102c37 <iput+0x97>
80102c2e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102c30:	83 c6 04             	add    $0x4,%esi
80102c33:	39 de                	cmp    %ebx,%esi
80102c35:	74 19                	je     80102c50 <iput+0xb0>
    if(ip->addrs[i]){
80102c37:	8b 16                	mov    (%esi),%edx
80102c39:	85 d2                	test   %edx,%edx
80102c3b:	74 f3                	je     80102c30 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102c3d:	8b 07                	mov    (%edi),%eax
80102c3f:	e8 7c fa ff ff       	call   801026c0 <bfree>
      ip->addrs[i] = 0;
80102c44:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102c4a:	eb e4                	jmp    80102c30 <iput+0x90>
80102c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102c50:	89 fb                	mov    %edi,%ebx
80102c52:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102c55:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102c5b:	85 c0                	test   %eax,%eax
80102c5d:	75 2d                	jne    80102c8c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102c5f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102c62:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102c69:	53                   	push   %ebx
80102c6a:	e8 51 fd ff ff       	call   801029c0 <iupdate>
      ip->type = 0;
80102c6f:	31 c0                	xor    %eax,%eax
80102c71:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102c75:	89 1c 24             	mov    %ebx,(%esp)
80102c78:	e8 43 fd ff ff       	call   801029c0 <iupdate>
      ip->valid = 0;
80102c7d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102c84:	83 c4 10             	add    $0x10,%esp
80102c87:	e9 3a ff ff ff       	jmp    80102bc6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102c8c:	83 ec 08             	sub    $0x8,%esp
80102c8f:	50                   	push   %eax
80102c90:	ff 33                	push   (%ebx)
80102c92:	e8 39 d4 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80102c97:	83 c4 10             	add    $0x10,%esp
80102c9a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102c9d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102ca3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ca6:	8d 70 5c             	lea    0x5c(%eax),%esi
80102ca9:	89 cf                	mov    %ecx,%edi
80102cab:	eb 0a                	jmp    80102cb7 <iput+0x117>
80102cad:	8d 76 00             	lea    0x0(%esi),%esi
80102cb0:	83 c6 04             	add    $0x4,%esi
80102cb3:	39 fe                	cmp    %edi,%esi
80102cb5:	74 0f                	je     80102cc6 <iput+0x126>
      if(a[j])
80102cb7:	8b 16                	mov    (%esi),%edx
80102cb9:	85 d2                	test   %edx,%edx
80102cbb:	74 f3                	je     80102cb0 <iput+0x110>
        bfree(ip->dev, a[j]);
80102cbd:	8b 03                	mov    (%ebx),%eax
80102cbf:	e8 fc f9 ff ff       	call   801026c0 <bfree>
80102cc4:	eb ea                	jmp    80102cb0 <iput+0x110>
    brelse(bp);
80102cc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102cc9:	83 ec 0c             	sub    $0xc,%esp
80102ccc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102ccf:	50                   	push   %eax
80102cd0:	e8 1b d5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102cd5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102cdb:	8b 03                	mov    (%ebx),%eax
80102cdd:	e8 de f9 ff ff       	call   801026c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80102ce2:	83 c4 10             	add    $0x10,%esp
80102ce5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102cec:	00 00 00 
80102cef:	e9 6b ff ff ff       	jmp    80102c5f <iput+0xbf>
80102cf4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cfb:	00 
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d00 <iunlockput>:
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	56                   	push   %esi
80102d04:	53                   	push   %ebx
80102d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102d08:	85 db                	test   %ebx,%ebx
80102d0a:	74 34                	je     80102d40 <iunlockput+0x40>
80102d0c:	83 ec 0c             	sub    $0xc,%esp
80102d0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102d12:	56                   	push   %esi
80102d13:	e8 18 29 00 00       	call   80105630 <holdingsleep>
80102d18:	83 c4 10             	add    $0x10,%esp
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	74 21                	je     80102d40 <iunlockput+0x40>
80102d1f:	8b 43 08             	mov    0x8(%ebx),%eax
80102d22:	85 c0                	test   %eax,%eax
80102d24:	7e 1a                	jle    80102d40 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	56                   	push   %esi
80102d2a:	e8 c1 28 00 00       	call   801055f0 <releasesleep>
  iput(ip);
80102d2f:	83 c4 10             	add    $0x10,%esp
80102d32:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102d35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d38:	5b                   	pop    %ebx
80102d39:	5e                   	pop    %esi
80102d3a:	5d                   	pop    %ebp
  iput(ip);
80102d3b:	e9 60 fe ff ff       	jmp    80102ba0 <iput>
    panic("iunlock");
80102d40:	83 ec 0c             	sub    $0xc,%esp
80102d43:	68 6e 85 10 80       	push   $0x8010856e
80102d48:	e8 f3 d7 ff ff       	call   80100540 <panic>
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi

80102d50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	8b 55 08             	mov    0x8(%ebp),%edx
80102d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102d59:	8b 0a                	mov    (%edx),%ecx
80102d5b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102d5e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102d61:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102d64:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102d68:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80102d6b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102d6f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102d73:	8b 52 58             	mov    0x58(%edx),%edx
80102d76:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d79:	5d                   	pop    %ebp
80102d7a:	c3                   	ret
80102d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	57                   	push   %edi
80102d84:	56                   	push   %esi
80102d85:	53                   	push   %ebx
80102d86:	83 ec 1c             	sub    $0x1c,%esp
80102d89:	8b 75 08             	mov    0x8(%ebp),%esi
80102d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102d92:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80102d97:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d9a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80102d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80102da0:	0f 84 aa 00 00 00    	je     80102e50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80102da6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102da9:	8b 56 58             	mov    0x58(%esi),%edx
80102dac:	39 fa                	cmp    %edi,%edx
80102dae:	0f 82 bd 00 00 00    	jb     80102e71 <readi+0xf1>
80102db4:	89 f9                	mov    %edi,%ecx
80102db6:	31 db                	xor    %ebx,%ebx
80102db8:	01 c1                	add    %eax,%ecx
80102dba:	0f 92 c3             	setb   %bl
80102dbd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102dc0:	0f 82 ab 00 00 00    	jb     80102e71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80102dc6:	89 d3                	mov    %edx,%ebx
80102dc8:	29 fb                	sub    %edi,%ebx
80102dca:	39 ca                	cmp    %ecx,%edx
80102dcc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102dcf:	85 c0                	test   %eax,%eax
80102dd1:	74 73                	je     80102e46 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102dd3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80102dd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102de0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102de3:	89 fa                	mov    %edi,%edx
80102de5:	c1 ea 09             	shr    $0x9,%edx
80102de8:	89 d8                	mov    %ebx,%eax
80102dea:	e8 51 f9 ff ff       	call   80102740 <bmap>
80102def:	83 ec 08             	sub    $0x8,%esp
80102df2:	50                   	push   %eax
80102df3:	ff 33                	push   (%ebx)
80102df5:	e8 d6 d2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102dfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102dfd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102e02:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102e04:	89 f8                	mov    %edi,%eax
80102e06:	25 ff 01 00 00       	and    $0x1ff,%eax
80102e0b:	29 f3                	sub    %esi,%ebx
80102e0d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102e0f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102e13:	39 d9                	cmp    %ebx,%ecx
80102e15:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102e18:	83 c4 0c             	add    $0xc,%esp
80102e1b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e1c:	01 de                	add    %ebx,%esi
80102e1e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102e20:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102e23:	50                   	push   %eax
80102e24:	ff 75 e0             	push   -0x20(%ebp)
80102e27:	e8 d4 2b 00 00       	call   80105a00 <memmove>
    brelse(bp);
80102e2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102e2f:	89 14 24             	mov    %edx,(%esp)
80102e32:	e8 b9 d3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102e37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80102e3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102e3d:	83 c4 10             	add    $0x10,%esp
80102e40:	39 de                	cmp    %ebx,%esi
80102e42:	72 9c                	jb     80102de0 <readi+0x60>
80102e44:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80102e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e49:	5b                   	pop    %ebx
80102e4a:	5e                   	pop    %esi
80102e4b:	5f                   	pop    %edi
80102e4c:	5d                   	pop    %ebp
80102e4d:	c3                   	ret
80102e4e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102e50:	0f bf 56 52          	movswl 0x52(%esi),%edx
80102e54:	66 83 fa 09          	cmp    $0x9,%dx
80102e58:	77 17                	ja     80102e71 <readi+0xf1>
80102e5a:	8b 14 d5 80 0b 11 80 	mov    -0x7feef480(,%edx,8),%edx
80102e61:	85 d2                	test   %edx,%edx
80102e63:	74 0c                	je     80102e71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102e65:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e6b:	5b                   	pop    %ebx
80102e6c:	5e                   	pop    %esi
80102e6d:	5f                   	pop    %edi
80102e6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80102e6f:	ff e2                	jmp    *%edx
      return -1;
80102e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e76:	eb ce                	jmp    80102e46 <readi+0xc6>
80102e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7f:	00 

80102e80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 1c             	sub    $0x1c,%esp
80102e89:	8b 45 08             	mov    0x8(%ebp),%eax
80102e8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102e8f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102e92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102e97:	89 7d dc             	mov    %edi,-0x24(%ebp)
80102e9a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102e9d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80102ea0:	0f 84 ba 00 00 00    	je     80102f60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102ea6:	39 78 58             	cmp    %edi,0x58(%eax)
80102ea9:	0f 82 ea 00 00 00    	jb     80102f99 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102eaf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80102eb2:	89 f2                	mov    %esi,%edx
80102eb4:	01 fa                	add    %edi,%edx
80102eb6:	0f 82 dd 00 00 00    	jb     80102f99 <writei+0x119>
80102ebc:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80102ec2:	0f 87 d1 00 00 00    	ja     80102f99 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102ec8:	85 f6                	test   %esi,%esi
80102eca:	0f 84 85 00 00 00    	je     80102f55 <writei+0xd5>
80102ed0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80102ed7:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102ee0:	8b 75 d8             	mov    -0x28(%ebp),%esi
80102ee3:	89 fa                	mov    %edi,%edx
80102ee5:	c1 ea 09             	shr    $0x9,%edx
80102ee8:	89 f0                	mov    %esi,%eax
80102eea:	e8 51 f8 ff ff       	call   80102740 <bmap>
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	50                   	push   %eax
80102ef3:	ff 36                	push   (%esi)
80102ef5:	e8 d6 d1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80102efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102efd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102f00:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102f05:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80102f07:	89 f8                	mov    %edi,%eax
80102f09:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f0e:	29 d3                	sub    %edx,%ebx
80102f10:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102f12:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102f16:	39 d9                	cmp    %ebx,%ecx
80102f18:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80102f1b:	83 c4 0c             	add    $0xc,%esp
80102f1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f1f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80102f21:	ff 75 dc             	push   -0x24(%ebp)
80102f24:	50                   	push   %eax
80102f25:	e8 d6 2a 00 00       	call   80105a00 <memmove>
    log_write(bp);
80102f2a:	89 34 24             	mov    %esi,(%esp)
80102f2d:	e8 be 12 00 00       	call   801041f0 <log_write>
    brelse(bp);
80102f32:	89 34 24             	mov    %esi,(%esp)
80102f35:	e8 b6 d2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102f3a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80102f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102f40:	83 c4 10             	add    $0x10,%esp
80102f43:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102f46:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102f49:	39 d8                	cmp    %ebx,%eax
80102f4b:	72 93                	jb     80102ee0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102f4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102f50:	39 78 58             	cmp    %edi,0x58(%eax)
80102f53:	72 33                	jb     80102f88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102f55:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f5b:	5b                   	pop    %ebx
80102f5c:	5e                   	pop    %esi
80102f5d:	5f                   	pop    %edi
80102f5e:	5d                   	pop    %ebp
80102f5f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102f60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102f64:	66 83 f8 09          	cmp    $0x9,%ax
80102f68:	77 2f                	ja     80102f99 <writei+0x119>
80102f6a:	8b 04 c5 84 0b 11 80 	mov    -0x7feef47c(,%eax,8),%eax
80102f71:	85 c0                	test   %eax,%eax
80102f73:	74 24                	je     80102f99 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80102f75:	89 75 10             	mov    %esi,0x10(%ebp)
}
80102f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7b:	5b                   	pop    %ebx
80102f7c:	5e                   	pop    %esi
80102f7d:	5f                   	pop    %edi
80102f7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80102f7f:	ff e0                	jmp    *%eax
80102f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80102f88:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80102f8b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80102f8e:	50                   	push   %eax
80102f8f:	e8 2c fa ff ff       	call   801029c0 <iupdate>
80102f94:	83 c4 10             	add    $0x10,%esp
80102f97:	eb bc                	jmp    80102f55 <writei+0xd5>
      return -1;
80102f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f9e:	eb b8                	jmp    80102f58 <writei+0xd8>

80102fa0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102fa6:	6a 0e                	push   $0xe
80102fa8:	ff 75 0c             	push   0xc(%ebp)
80102fab:	ff 75 08             	push   0x8(%ebp)
80102fae:	e8 bd 2a 00 00       	call   80105a70 <strncmp>
}
80102fb3:	c9                   	leave
80102fb4:	c3                   	ret
80102fb5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fbc:	00 
80102fbd:	8d 76 00             	lea    0x0(%esi),%esi

80102fc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
80102fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102fcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102fd1:	0f 85 85 00 00 00    	jne    8010305c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102fd7:	8b 53 58             	mov    0x58(%ebx),%edx
80102fda:	31 ff                	xor    %edi,%edi
80102fdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102fdf:	85 d2                	test   %edx,%edx
80102fe1:	74 3e                	je     80103021 <dirlookup+0x61>
80102fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102fe8:	6a 10                	push   $0x10
80102fea:	57                   	push   %edi
80102feb:	56                   	push   %esi
80102fec:	53                   	push   %ebx
80102fed:	e8 8e fd ff ff       	call   80102d80 <readi>
80102ff2:	83 c4 10             	add    $0x10,%esp
80102ff5:	83 f8 10             	cmp    $0x10,%eax
80102ff8:	75 55                	jne    8010304f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80102ffa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102fff:	74 18                	je     80103019 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80103001:	83 ec 04             	sub    $0x4,%esp
80103004:	8d 45 da             	lea    -0x26(%ebp),%eax
80103007:	6a 0e                	push   $0xe
80103009:	50                   	push   %eax
8010300a:	ff 75 0c             	push   0xc(%ebp)
8010300d:	e8 5e 2a 00 00       	call   80105a70 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103012:	83 c4 10             	add    $0x10,%esp
80103015:	85 c0                	test   %eax,%eax
80103017:	74 17                	je     80103030 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103019:	83 c7 10             	add    $0x10,%edi
8010301c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010301f:	72 c7                	jb     80102fe8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103024:	31 c0                	xor    %eax,%eax
}
80103026:	5b                   	pop    %ebx
80103027:	5e                   	pop    %esi
80103028:	5f                   	pop    %edi
80103029:	5d                   	pop    %ebp
8010302a:	c3                   	ret
8010302b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80103030:	8b 45 10             	mov    0x10(%ebp),%eax
80103033:	85 c0                	test   %eax,%eax
80103035:	74 05                	je     8010303c <dirlookup+0x7c>
        *poff = off;
80103037:	8b 45 10             	mov    0x10(%ebp),%eax
8010303a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010303c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103040:	8b 03                	mov    (%ebx),%eax
80103042:	e8 79 f5 ff ff       	call   801025c0 <iget>
}
80103047:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304a:	5b                   	pop    %ebx
8010304b:	5e                   	pop    %esi
8010304c:	5f                   	pop    %edi
8010304d:	5d                   	pop    %ebp
8010304e:	c3                   	ret
      panic("dirlookup read");
8010304f:	83 ec 0c             	sub    $0xc,%esp
80103052:	68 88 85 10 80       	push   $0x80108588
80103057:	e8 e4 d4 ff ff       	call   80100540 <panic>
    panic("dirlookup not DIR");
8010305c:	83 ec 0c             	sub    $0xc,%esp
8010305f:	68 76 85 10 80       	push   $0x80108576
80103064:	e8 d7 d4 ff ff       	call   80100540 <panic>
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103070 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	89 c3                	mov    %eax,%ebx
80103078:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010307b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010307e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103081:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103084:	0f 84 9e 01 00 00    	je     80103228 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010308a:	e8 a1 1b 00 00       	call   80104c30 <myproc>
  acquire(&icache.lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103092:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103095:	68 e0 0b 11 80       	push   $0x80110be0
8010309a:	e8 d1 27 00 00       	call   80105870 <acquire>
  ip->ref++;
8010309f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801030a3:	c7 04 24 e0 0b 11 80 	movl   $0x80110be0,(%esp)
801030aa:	e8 61 27 00 00       	call   80105810 <release>
801030af:	83 c4 10             	add    $0x10,%esp
801030b2:	eb 07                	jmp    801030bb <namex+0x4b>
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801030b8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801030bb:	0f b6 03             	movzbl (%ebx),%eax
801030be:	3c 2f                	cmp    $0x2f,%al
801030c0:	74 f6                	je     801030b8 <namex+0x48>
  if(*path == 0)
801030c2:	84 c0                	test   %al,%al
801030c4:	0f 84 06 01 00 00    	je     801031d0 <namex+0x160>
  while(*path != '/' && *path != 0)
801030ca:	0f b6 03             	movzbl (%ebx),%eax
801030cd:	84 c0                	test   %al,%al
801030cf:	0f 84 10 01 00 00    	je     801031e5 <namex+0x175>
801030d5:	89 df                	mov    %ebx,%edi
801030d7:	3c 2f                	cmp    $0x2f,%al
801030d9:	0f 84 06 01 00 00    	je     801031e5 <namex+0x175>
801030df:	90                   	nop
801030e0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801030e4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801030e7:	3c 2f                	cmp    $0x2f,%al
801030e9:	74 04                	je     801030ef <namex+0x7f>
801030eb:	84 c0                	test   %al,%al
801030ed:	75 f1                	jne    801030e0 <namex+0x70>
  len = path - s;
801030ef:	89 f8                	mov    %edi,%eax
801030f1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801030f3:	83 f8 0d             	cmp    $0xd,%eax
801030f6:	0f 8e ac 00 00 00    	jle    801031a8 <namex+0x138>
    memmove(name, s, DIRSIZ);
801030fc:	83 ec 04             	sub    $0x4,%esp
801030ff:	6a 0e                	push   $0xe
80103101:	53                   	push   %ebx
80103102:	89 fb                	mov    %edi,%ebx
80103104:	ff 75 e4             	push   -0x1c(%ebp)
80103107:	e8 f4 28 00 00       	call   80105a00 <memmove>
8010310c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010310f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103112:	75 0c                	jne    80103120 <namex+0xb0>
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103118:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010311b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010311e:	74 f8                	je     80103118 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103120:	83 ec 0c             	sub    $0xc,%esp
80103123:	56                   	push   %esi
80103124:	e8 47 f9 ff ff       	call   80102a70 <ilock>
    if(ip->type != T_DIR){
80103129:	83 c4 10             	add    $0x10,%esp
8010312c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103131:	0f 85 b7 00 00 00    	jne    801031ee <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103137:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010313a:	85 c0                	test   %eax,%eax
8010313c:	74 09                	je     80103147 <namex+0xd7>
8010313e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103141:	0f 84 f7 00 00 00    	je     8010323e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103147:	83 ec 04             	sub    $0x4,%esp
8010314a:	6a 00                	push   $0x0
8010314c:	ff 75 e4             	push   -0x1c(%ebp)
8010314f:	56                   	push   %esi
80103150:	e8 6b fe ff ff       	call   80102fc0 <dirlookup>
80103155:	83 c4 10             	add    $0x10,%esp
80103158:	89 c7                	mov    %eax,%edi
8010315a:	85 c0                	test   %eax,%eax
8010315c:	0f 84 8c 00 00 00    	je     801031ee <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103162:	83 ec 0c             	sub    $0xc,%esp
80103165:	8d 4e 0c             	lea    0xc(%esi),%ecx
80103168:	51                   	push   %ecx
80103169:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010316c:	e8 bf 24 00 00       	call   80105630 <holdingsleep>
80103171:	83 c4 10             	add    $0x10,%esp
80103174:	85 c0                	test   %eax,%eax
80103176:	0f 84 02 01 00 00    	je     8010327e <namex+0x20e>
8010317c:	8b 56 08             	mov    0x8(%esi),%edx
8010317f:	85 d2                	test   %edx,%edx
80103181:	0f 8e f7 00 00 00    	jle    8010327e <namex+0x20e>
  releasesleep(&ip->lock);
80103187:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010318a:	83 ec 0c             	sub    $0xc,%esp
8010318d:	51                   	push   %ecx
8010318e:	e8 5d 24 00 00       	call   801055f0 <releasesleep>
  iput(ip);
80103193:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103196:	89 fe                	mov    %edi,%esi
  iput(ip);
80103198:	e8 03 fa ff ff       	call   80102ba0 <iput>
8010319d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801031a0:	e9 16 ff ff ff       	jmp    801030bb <namex+0x4b>
801031a5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801031a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
801031ae:	83 ec 04             	sub    $0x4,%esp
801031b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801031b4:	50                   	push   %eax
801031b5:	53                   	push   %ebx
    name[len] = 0;
801031b6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801031b8:	ff 75 e4             	push   -0x1c(%ebp)
801031bb:	e8 40 28 00 00       	call   80105a00 <memmove>
    name[len] = 0;
801031c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801031c3:	83 c4 10             	add    $0x10,%esp
801031c6:	c6 01 00             	movb   $0x0,(%ecx)
801031c9:	e9 41 ff ff ff       	jmp    8010310f <namex+0x9f>
801031ce:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801031d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031d3:	85 c0                	test   %eax,%eax
801031d5:	0f 85 93 00 00 00    	jne    8010326e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801031db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5b                   	pop    %ebx
801031e1:	5e                   	pop    %esi
801031e2:	5f                   	pop    %edi
801031e3:	5d                   	pop    %ebp
801031e4:	c3                   	ret
  while(*path != '/' && *path != 0)
801031e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801031e8:	89 df                	mov    %ebx,%edi
801031ea:	31 c0                	xor    %eax,%eax
801031ec:	eb c0                	jmp    801031ae <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801031ee:	83 ec 0c             	sub    $0xc,%esp
801031f1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801031f4:	53                   	push   %ebx
801031f5:	e8 36 24 00 00       	call   80105630 <holdingsleep>
801031fa:	83 c4 10             	add    $0x10,%esp
801031fd:	85 c0                	test   %eax,%eax
801031ff:	74 7d                	je     8010327e <namex+0x20e>
80103201:	8b 4e 08             	mov    0x8(%esi),%ecx
80103204:	85 c9                	test   %ecx,%ecx
80103206:	7e 76                	jle    8010327e <namex+0x20e>
  releasesleep(&ip->lock);
80103208:	83 ec 0c             	sub    $0xc,%esp
8010320b:	53                   	push   %ebx
8010320c:	e8 df 23 00 00       	call   801055f0 <releasesleep>
  iput(ip);
80103211:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103214:	31 f6                	xor    %esi,%esi
  iput(ip);
80103216:	e8 85 f9 ff ff       	call   80102ba0 <iput>
      return 0;
8010321b:	83 c4 10             	add    $0x10,%esp
}
8010321e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103221:	89 f0                	mov    %esi,%eax
80103223:	5b                   	pop    %ebx
80103224:	5e                   	pop    %esi
80103225:	5f                   	pop    %edi
80103226:	5d                   	pop    %ebp
80103227:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80103228:	ba 01 00 00 00       	mov    $0x1,%edx
8010322d:	b8 01 00 00 00       	mov    $0x1,%eax
80103232:	e8 89 f3 ff ff       	call   801025c0 <iget>
80103237:	89 c6                	mov    %eax,%esi
80103239:	e9 7d fe ff ff       	jmp    801030bb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010323e:	83 ec 0c             	sub    $0xc,%esp
80103241:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103244:	53                   	push   %ebx
80103245:	e8 e6 23 00 00       	call   80105630 <holdingsleep>
8010324a:	83 c4 10             	add    $0x10,%esp
8010324d:	85 c0                	test   %eax,%eax
8010324f:	74 2d                	je     8010327e <namex+0x20e>
80103251:	8b 7e 08             	mov    0x8(%esi),%edi
80103254:	85 ff                	test   %edi,%edi
80103256:	7e 26                	jle    8010327e <namex+0x20e>
  releasesleep(&ip->lock);
80103258:	83 ec 0c             	sub    $0xc,%esp
8010325b:	53                   	push   %ebx
8010325c:	e8 8f 23 00 00       	call   801055f0 <releasesleep>
}
80103261:	83 c4 10             	add    $0x10,%esp
}
80103264:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103267:	89 f0                	mov    %esi,%eax
80103269:	5b                   	pop    %ebx
8010326a:	5e                   	pop    %esi
8010326b:	5f                   	pop    %edi
8010326c:	5d                   	pop    %ebp
8010326d:	c3                   	ret
    iput(ip);
8010326e:	83 ec 0c             	sub    $0xc,%esp
80103271:	56                   	push   %esi
      return 0;
80103272:	31 f6                	xor    %esi,%esi
    iput(ip);
80103274:	e8 27 f9 ff ff       	call   80102ba0 <iput>
    return 0;
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	eb a0                	jmp    8010321e <namex+0x1ae>
    panic("iunlock");
8010327e:	83 ec 0c             	sub    $0xc,%esp
80103281:	68 6e 85 10 80       	push   $0x8010856e
80103286:	e8 b5 d2 ff ff       	call   80100540 <panic>
8010328b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103290 <dirlink>:
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 20             	sub    $0x20,%esp
80103299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010329c:	6a 00                	push   $0x0
8010329e:	ff 75 0c             	push   0xc(%ebp)
801032a1:	53                   	push   %ebx
801032a2:	e8 19 fd ff ff       	call   80102fc0 <dirlookup>
801032a7:	83 c4 10             	add    $0x10,%esp
801032aa:	85 c0                	test   %eax,%eax
801032ac:	75 67                	jne    80103315 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801032ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801032b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801032b4:	85 ff                	test   %edi,%edi
801032b6:	74 29                	je     801032e1 <dirlink+0x51>
801032b8:	31 ff                	xor    %edi,%edi
801032ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801032bd:	eb 09                	jmp    801032c8 <dirlink+0x38>
801032bf:	90                   	nop
801032c0:	83 c7 10             	add    $0x10,%edi
801032c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801032c6:	73 19                	jae    801032e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801032c8:	6a 10                	push   $0x10
801032ca:	57                   	push   %edi
801032cb:	56                   	push   %esi
801032cc:	53                   	push   %ebx
801032cd:	e8 ae fa ff ff       	call   80102d80 <readi>
801032d2:	83 c4 10             	add    $0x10,%esp
801032d5:	83 f8 10             	cmp    $0x10,%eax
801032d8:	75 4e                	jne    80103328 <dirlink+0x98>
    if(de.inum == 0)
801032da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801032df:	75 df                	jne    801032c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801032e1:	83 ec 04             	sub    $0x4,%esp
801032e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801032e7:	6a 0e                	push   $0xe
801032e9:	ff 75 0c             	push   0xc(%ebp)
801032ec:	50                   	push   %eax
801032ed:	e8 ce 27 00 00       	call   80105ac0 <strncpy>
  de.inum = inum;
801032f2:	8b 45 10             	mov    0x10(%ebp),%eax
801032f5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801032f9:	6a 10                	push   $0x10
801032fb:	57                   	push   %edi
801032fc:	56                   	push   %esi
801032fd:	53                   	push   %ebx
801032fe:	e8 7d fb ff ff       	call   80102e80 <writei>
80103303:	83 c4 20             	add    $0x20,%esp
80103306:	83 f8 10             	cmp    $0x10,%eax
80103309:	75 2a                	jne    80103335 <dirlink+0xa5>
  return 0;
8010330b:	31 c0                	xor    %eax,%eax
}
8010330d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103310:	5b                   	pop    %ebx
80103311:	5e                   	pop    %esi
80103312:	5f                   	pop    %edi
80103313:	5d                   	pop    %ebp
80103314:	c3                   	ret
    iput(ip);
80103315:	83 ec 0c             	sub    $0xc,%esp
80103318:	50                   	push   %eax
80103319:	e8 82 f8 ff ff       	call   80102ba0 <iput>
    return -1;
8010331e:	83 c4 10             	add    $0x10,%esp
80103321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103326:	eb e5                	jmp    8010330d <dirlink+0x7d>
      panic("dirlink read");
80103328:	83 ec 0c             	sub    $0xc,%esp
8010332b:	68 97 85 10 80       	push   $0x80108597
80103330:	e8 0b d2 ff ff       	call   80100540 <panic>
    panic("dirlink");
80103335:	83 ec 0c             	sub    $0xc,%esp
80103338:	68 f3 87 10 80       	push   $0x801087f3
8010333d:	e8 fe d1 ff ff       	call   80100540 <panic>
80103342:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103349:	00 
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103350 <namei>:

struct inode*
namei(char *path)
{
80103350:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103351:	31 d2                	xor    %edx,%edx
{
80103353:	89 e5                	mov    %esp,%ebp
80103355:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103358:	8b 45 08             	mov    0x8(%ebp),%eax
8010335b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010335e:	e8 0d fd ff ff       	call   80103070 <namex>
}
80103363:	c9                   	leave
80103364:	c3                   	ret
80103365:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010336c:	00 
8010336d:	8d 76 00             	lea    0x0(%esi),%esi

80103370 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103370:	55                   	push   %ebp
  return namex(path, 1, name);
80103371:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103376:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103378:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010337b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010337e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010337f:	e9 ec fc ff ff       	jmp    80103070 <namex>
80103384:	66 90                	xchg   %ax,%ax
80103386:	66 90                	xchg   %ax,%ax
80103388:	66 90                	xchg   %ax,%ax
8010338a:	66 90                	xchg   %ax,%ax
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103399:	85 c0                	test   %eax,%eax
8010339b:	0f 84 b4 00 00 00    	je     80103455 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801033a1:	8b 70 08             	mov    0x8(%eax),%esi
801033a4:	89 c3                	mov    %eax,%ebx
801033a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801033ac:	0f 87 96 00 00 00    	ja     80103448 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801033b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033be:	00 
801033bf:	90                   	nop
801033c0:	89 ca                	mov    %ecx,%edx
801033c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801033c3:	83 e0 c0             	and    $0xffffffc0,%eax
801033c6:	3c 40                	cmp    $0x40,%al
801033c8:	75 f6                	jne    801033c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ca:	31 ff                	xor    %edi,%edi
801033cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801033d1:	89 f8                	mov    %edi,%eax
801033d3:	ee                   	out    %al,(%dx)
801033d4:	b8 01 00 00 00       	mov    $0x1,%eax
801033d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801033e4:	89 f0                	mov    %esi,%eax
801033e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801033e7:	89 f0                	mov    %esi,%eax
801033e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801033ee:	c1 f8 08             	sar    $0x8,%eax
801033f1:	ee                   	out    %al,(%dx)
801033f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801033f7:	89 f8                	mov    %edi,%eax
801033f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801033fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801033fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103403:	c1 e0 04             	shl    $0x4,%eax
80103406:	83 e0 10             	and    $0x10,%eax
80103409:	83 c8 e0             	or     $0xffffffe0,%eax
8010340c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010340d:	f6 03 04             	testb  $0x4,(%ebx)
80103410:	75 16                	jne    80103428 <idestart+0x98>
80103412:	b8 20 00 00 00       	mov    $0x20,%eax
80103417:	89 ca                	mov    %ecx,%edx
80103419:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010341a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341d:	5b                   	pop    %ebx
8010341e:	5e                   	pop    %esi
8010341f:	5f                   	pop    %edi
80103420:	5d                   	pop    %ebp
80103421:	c3                   	ret
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103428:	b8 30 00 00 00       	mov    $0x30,%eax
8010342d:	89 ca                	mov    %ecx,%edx
8010342f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103430:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103435:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103438:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010343d:	fc                   	cld
8010343e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103440:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103443:	5b                   	pop    %ebx
80103444:	5e                   	pop    %esi
80103445:	5f                   	pop    %edi
80103446:	5d                   	pop    %ebp
80103447:	c3                   	ret
    panic("incorrect blockno");
80103448:	83 ec 0c             	sub    $0xc,%esp
8010344b:	68 ad 85 10 80       	push   $0x801085ad
80103450:	e8 eb d0 ff ff       	call   80100540 <panic>
    panic("idestart");
80103455:	83 ec 0c             	sub    $0xc,%esp
80103458:	68 a4 85 10 80       	push   $0x801085a4
8010345d:	e8 de d0 ff ff       	call   80100540 <panic>
80103462:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103469:	00 
8010346a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103470 <ideinit>:
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80103476:	68 bf 85 10 80       	push   $0x801085bf
8010347b:	68 80 28 11 80       	push   $0x80112880
80103480:	e8 fb 21 00 00       	call   80105680 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80103485:	58                   	pop    %eax
80103486:	a1 04 2a 11 80       	mov    0x80112a04,%eax
8010348b:	5a                   	pop    %edx
8010348c:	83 e8 01             	sub    $0x1,%eax
8010348f:	50                   	push   %eax
80103490:	6a 0e                	push   $0xe
80103492:	e8 99 02 00 00       	call   80103730 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103497:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010349a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010349f:	90                   	nop
801034a0:	89 ca                	mov    %ecx,%edx
801034a2:	ec                   	in     (%dx),%al
801034a3:	83 e0 c0             	and    $0xffffffc0,%eax
801034a6:	3c 40                	cmp    $0x40,%al
801034a8:	75 f6                	jne    801034a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034aa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801034af:	ba f6 01 00 00       	mov    $0x1f6,%edx
801034b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034b5:	89 ca                	mov    %ecx,%edx
801034b7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801034b8:	84 c0                	test   %al,%al
801034ba:	75 1e                	jne    801034da <ideinit+0x6a>
801034bc:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801034c1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801034c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034cd:	00 
801034ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801034d0:	83 e9 01             	sub    $0x1,%ecx
801034d3:	74 0f                	je     801034e4 <ideinit+0x74>
801034d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801034d6:	84 c0                	test   %al,%al
801034d8:	74 f6                	je     801034d0 <ideinit+0x60>
      havedisk1 = 1;
801034da:	c7 05 60 28 11 80 01 	movl   $0x1,0x80112860
801034e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801034e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801034ee:	ee                   	out    %al,(%dx)
}
801034ef:	c9                   	leave
801034f0:	c3                   	ret
801034f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034f8:	00 
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80103509:	68 80 28 11 80       	push   $0x80112880
8010350e:	e8 5d 23 00 00       	call   80105870 <acquire>

  if((b = idequeue) == 0){
80103513:	8b 1d 64 28 11 80    	mov    0x80112864,%ebx
80103519:	83 c4 10             	add    $0x10,%esp
8010351c:	85 db                	test   %ebx,%ebx
8010351e:	74 63                	je     80103583 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80103520:	8b 43 58             	mov    0x58(%ebx),%eax
80103523:	a3 64 28 11 80       	mov    %eax,0x80112864

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80103528:	8b 33                	mov    (%ebx),%esi
8010352a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103530:	75 2f                	jne    80103561 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103532:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010353e:	00 
8010353f:	90                   	nop
80103540:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103541:	89 c1                	mov    %eax,%ecx
80103543:	83 e1 c0             	and    $0xffffffc0,%ecx
80103546:	80 f9 40             	cmp    $0x40,%cl
80103549:	75 f5                	jne    80103540 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010354b:	a8 21                	test   $0x21,%al
8010354d:	75 12                	jne    80103561 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010354f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103552:	b9 80 00 00 00       	mov    $0x80,%ecx
80103557:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010355c:	fc                   	cld
8010355d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010355f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80103561:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80103564:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80103567:	83 ce 02             	or     $0x2,%esi
8010356a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010356c:	53                   	push   %ebx
8010356d:	e8 3e 1e 00 00       	call   801053b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103572:	a1 64 28 11 80       	mov    0x80112864,%eax
80103577:	83 c4 10             	add    $0x10,%esp
8010357a:	85 c0                	test   %eax,%eax
8010357c:	74 05                	je     80103583 <ideintr+0x83>
    idestart(idequeue);
8010357e:	e8 0d fe ff ff       	call   80103390 <idestart>
    release(&idelock);
80103583:	83 ec 0c             	sub    $0xc,%esp
80103586:	68 80 28 11 80       	push   $0x80112880
8010358b:	e8 80 22 00 00       	call   80105810 <release>

  release(&idelock);
}
80103590:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103593:	5b                   	pop    %ebx
80103594:	5e                   	pop    %esi
80103595:	5f                   	pop    %edi
80103596:	5d                   	pop    %ebp
80103597:	c3                   	ret
80103598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010359f:	00 

801035a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	53                   	push   %ebx
801035a4:	83 ec 10             	sub    $0x10,%esp
801035a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801035aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801035ad:	50                   	push   %eax
801035ae:	e8 7d 20 00 00       	call   80105630 <holdingsleep>
801035b3:	83 c4 10             	add    $0x10,%esp
801035b6:	85 c0                	test   %eax,%eax
801035b8:	0f 84 c3 00 00 00    	je     80103681 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801035be:	8b 03                	mov    (%ebx),%eax
801035c0:	83 e0 06             	and    $0x6,%eax
801035c3:	83 f8 02             	cmp    $0x2,%eax
801035c6:	0f 84 a8 00 00 00    	je     80103674 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801035cc:	8b 53 04             	mov    0x4(%ebx),%edx
801035cf:	85 d2                	test   %edx,%edx
801035d1:	74 0d                	je     801035e0 <iderw+0x40>
801035d3:	a1 60 28 11 80       	mov    0x80112860,%eax
801035d8:	85 c0                	test   %eax,%eax
801035da:	0f 84 87 00 00 00    	je     80103667 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	68 80 28 11 80       	push   $0x80112880
801035e8:	e8 83 22 00 00       	call   80105870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801035ed:	a1 64 28 11 80       	mov    0x80112864,%eax
  b->qnext = 0;
801035f2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	85 c0                	test   %eax,%eax
801035fe:	74 60                	je     80103660 <iderw+0xc0>
80103600:	89 c2                	mov    %eax,%edx
80103602:	8b 40 58             	mov    0x58(%eax),%eax
80103605:	85 c0                	test   %eax,%eax
80103607:	75 f7                	jne    80103600 <iderw+0x60>
80103609:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010360c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010360e:	39 1d 64 28 11 80    	cmp    %ebx,0x80112864
80103614:	74 3a                	je     80103650 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80103616:	8b 03                	mov    (%ebx),%eax
80103618:	83 e0 06             	and    $0x6,%eax
8010361b:	83 f8 02             	cmp    $0x2,%eax
8010361e:	74 1b                	je     8010363b <iderw+0x9b>
    sleep(b, &idelock);
80103620:	83 ec 08             	sub    $0x8,%esp
80103623:	68 80 28 11 80       	push   $0x80112880
80103628:	53                   	push   %ebx
80103629:	e8 c2 1c 00 00       	call   801052f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010362e:	8b 03                	mov    (%ebx),%eax
80103630:	83 c4 10             	add    $0x10,%esp
80103633:	83 e0 06             	and    $0x6,%eax
80103636:	83 f8 02             	cmp    $0x2,%eax
80103639:	75 e5                	jne    80103620 <iderw+0x80>
  }


  release(&idelock);
8010363b:	c7 45 08 80 28 11 80 	movl   $0x80112880,0x8(%ebp)
}
80103642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103645:	c9                   	leave
  release(&idelock);
80103646:	e9 c5 21 00 00       	jmp    80105810 <release>
8010364b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80103650:	89 d8                	mov    %ebx,%eax
80103652:	e8 39 fd ff ff       	call   80103390 <idestart>
80103657:	eb bd                	jmp    80103616 <iderw+0x76>
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103660:	ba 64 28 11 80       	mov    $0x80112864,%edx
80103665:	eb a5                	jmp    8010360c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103667:	83 ec 0c             	sub    $0xc,%esp
8010366a:	68 ee 85 10 80       	push   $0x801085ee
8010366f:	e8 cc ce ff ff       	call   80100540 <panic>
    panic("iderw: nothing to do");
80103674:	83 ec 0c             	sub    $0xc,%esp
80103677:	68 d9 85 10 80       	push   $0x801085d9
8010367c:	e8 bf ce ff ff       	call   80100540 <panic>
    panic("iderw: buf not locked");
80103681:	83 ec 0c             	sub    $0xc,%esp
80103684:	68 c3 85 10 80       	push   $0x801085c3
80103689:	e8 b2 ce ff ff       	call   80100540 <panic>
8010368e:	66 90                	xchg   %ax,%ax

80103690 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	56                   	push   %esi
80103694:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103695:	c7 05 b4 28 11 80 00 	movl   $0xfec00000,0x801128b4
8010369c:	00 c0 fe 
  ioapic->reg = reg;
8010369f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801036a6:	00 00 00 
  return ioapic->data;
801036a9:	8b 15 b4 28 11 80    	mov    0x801128b4,%edx
801036af:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801036b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801036b8:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801036be:	0f b6 15 00 2a 11 80 	movzbl 0x80112a00,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801036c5:	c1 ee 10             	shr    $0x10,%esi
801036c8:	89 f0                	mov    %esi,%eax
801036ca:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801036cd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801036d0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801036d3:	39 c2                	cmp    %eax,%edx
801036d5:	74 16                	je     801036ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 14 8a 10 80       	push   $0x80108a14
801036df:	e8 4c d5 ff ff       	call   80100c30 <cprintf>
  ioapic->reg = reg;
801036e4:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
801036ea:	83 c4 10             	add    $0x10,%esp
{
801036ed:	ba 10 00 00 00       	mov    $0x10,%edx
801036f2:	31 c0                	xor    %eax,%eax
801036f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801036f8:	89 13                	mov    %edx,(%ebx)
801036fa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801036fd:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80103703:	83 c0 01             	add    $0x1,%eax
80103706:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010370c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010370f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80103712:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80103715:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80103717:	8b 1d b4 28 11 80    	mov    0x801128b4,%ebx
8010371d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80103724:	39 c6                	cmp    %eax,%esi
80103726:	7d d0                	jge    801036f8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80103728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010372b:	5b                   	pop    %ebx
8010372c:	5e                   	pop    %esi
8010372d:	5d                   	pop    %ebp
8010372e:	c3                   	ret
8010372f:	90                   	nop

80103730 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103730:	55                   	push   %ebp
  ioapic->reg = reg;
80103731:	8b 0d b4 28 11 80    	mov    0x801128b4,%ecx
{
80103737:	89 e5                	mov    %esp,%ebp
80103739:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010373c:	8d 50 20             	lea    0x20(%eax),%edx
8010373f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80103743:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103745:	8b 0d b4 28 11 80    	mov    0x801128b4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010374b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010374e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103751:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80103754:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103756:	a1 b4 28 11 80       	mov    0x801128b4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010375b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010375e:	89 50 10             	mov    %edx,0x10(%eax)
}
80103761:	5d                   	pop    %ebp
80103762:	c3                   	ret
80103763:	66 90                	xchg   %ax,%ax
80103765:	66 90                	xchg   %ax,%ax
80103767:	66 90                	xchg   %ax,%ax
80103769:	66 90                	xchg   %ax,%ax
8010376b:	66 90                	xchg   %ax,%ax
8010376d:	66 90                	xchg   %ax,%ax
8010376f:	90                   	nop

80103770 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
80103774:	83 ec 04             	sub    $0x4,%esp
80103777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010377a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80103780:	75 76                	jne    801037f8 <kfree+0x88>
80103782:	81 fb 50 67 11 80    	cmp    $0x80116750,%ebx
80103788:	72 6e                	jb     801037f8 <kfree+0x88>
8010378a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103790:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103795:	77 61                	ja     801037f8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80103797:	83 ec 04             	sub    $0x4,%esp
8010379a:	68 00 10 00 00       	push   $0x1000
8010379f:	6a 01                	push   $0x1
801037a1:	53                   	push   %ebx
801037a2:	e8 c9 21 00 00       	call   80105970 <memset>

  if(kmem.use_lock)
801037a7:	8b 15 f4 28 11 80    	mov    0x801128f4,%edx
801037ad:	83 c4 10             	add    $0x10,%esp
801037b0:	85 d2                	test   %edx,%edx
801037b2:	75 1c                	jne    801037d0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801037b4:	a1 f8 28 11 80       	mov    0x801128f8,%eax
801037b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801037bb:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  kmem.freelist = r;
801037c0:	89 1d f8 28 11 80    	mov    %ebx,0x801128f8
  if(kmem.use_lock)
801037c6:	85 c0                	test   %eax,%eax
801037c8:	75 1e                	jne    801037e8 <kfree+0x78>
    release(&kmem.lock);
}
801037ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037cd:	c9                   	leave
801037ce:	c3                   	ret
801037cf:	90                   	nop
    acquire(&kmem.lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	68 c0 28 11 80       	push   $0x801128c0
801037d8:	e8 93 20 00 00       	call   80105870 <acquire>
801037dd:	83 c4 10             	add    $0x10,%esp
801037e0:	eb d2                	jmp    801037b4 <kfree+0x44>
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801037e8:	c7 45 08 c0 28 11 80 	movl   $0x801128c0,0x8(%ebp)
}
801037ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f2:	c9                   	leave
    release(&kmem.lock);
801037f3:	e9 18 20 00 00       	jmp    80105810 <release>
    panic("kfree");
801037f8:	83 ec 0c             	sub    $0xc,%esp
801037fb:	68 0c 86 10 80       	push   $0x8010860c
80103800:	e8 3b cd ff ff       	call   80100540 <panic>
80103805:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010380c:	00 
8010380d:	8d 76 00             	lea    0x0(%esi),%esi

80103810 <freerange>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103815:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103818:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010381b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103821:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103827:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010382d:	39 de                	cmp    %ebx,%esi
8010382f:	72 23                	jb     80103854 <freerange+0x44>
80103831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103838:	83 ec 0c             	sub    $0xc,%esp
8010383b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103841:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103847:	50                   	push   %eax
80103848:	e8 23 ff ff ff       	call   80103770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010384d:	83 c4 10             	add    $0x10,%esp
80103850:	39 de                	cmp    %ebx,%esi
80103852:	73 e4                	jae    80103838 <freerange+0x28>
}
80103854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103857:	5b                   	pop    %ebx
80103858:	5e                   	pop    %esi
80103859:	5d                   	pop    %ebp
8010385a:	c3                   	ret
8010385b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103860 <kinit2>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103865:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103868:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010386b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103871:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103877:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010387d:	39 de                	cmp    %ebx,%esi
8010387f:	72 23                	jb     801038a4 <kinit2+0x44>
80103881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103888:	83 ec 0c             	sub    $0xc,%esp
8010388b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103891:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103897:	50                   	push   %eax
80103898:	e8 d3 fe ff ff       	call   80103770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010389d:	83 c4 10             	add    $0x10,%esp
801038a0:	39 de                	cmp    %ebx,%esi
801038a2:	73 e4                	jae    80103888 <kinit2+0x28>
  kmem.use_lock = 1;
801038a4:	c7 05 f4 28 11 80 01 	movl   $0x1,0x801128f4
801038ab:	00 00 00 
}
801038ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b1:	5b                   	pop    %ebx
801038b2:	5e                   	pop    %esi
801038b3:	5d                   	pop    %ebp
801038b4:	c3                   	ret
801038b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038bc:	00 
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <kinit1>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801038c8:	83 ec 08             	sub    $0x8,%esp
801038cb:	68 12 86 10 80       	push   $0x80108612
801038d0:	68 c0 28 11 80       	push   $0x801128c0
801038d5:	e8 a6 1d 00 00       	call   80105680 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801038da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801038e0:	c7 05 f4 28 11 80 00 	movl   $0x0,0x801128f4
801038e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801038ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801038f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801038f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801038fc:	39 de                	cmp    %ebx,%esi
801038fe:	72 1c                	jb     8010391c <kinit1+0x5c>
    kfree(p);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103909:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010390f:	50                   	push   %eax
80103910:	e8 5b fe ff ff       	call   80103770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	39 de                	cmp    %ebx,%esi
8010391a:	73 e4                	jae    80103900 <kinit1+0x40>
}
8010391c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010391f:	5b                   	pop    %ebx
80103920:	5e                   	pop    %esi
80103921:	5d                   	pop    %ebp
80103922:	c3                   	ret
80103923:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392a:	00 
8010392b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103930 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80103937:	a1 f4 28 11 80       	mov    0x801128f4,%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	75 20                	jne    80103960 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103940:	8b 1d f8 28 11 80    	mov    0x801128f8,%ebx
  if(r)
80103946:	85 db                	test   %ebx,%ebx
80103948:	74 07                	je     80103951 <kalloc+0x21>
    kmem.freelist = r->next;
8010394a:	8b 03                	mov    (%ebx),%eax
8010394c:	a3 f8 28 11 80       	mov    %eax,0x801128f8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80103951:	89 d8                	mov    %ebx,%eax
80103953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103956:	c9                   	leave
80103957:	c3                   	ret
80103958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010395f:	00 
    acquire(&kmem.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 c0 28 11 80       	push   $0x801128c0
80103968:	e8 03 1f 00 00       	call   80105870 <acquire>
  r = kmem.freelist;
8010396d:	8b 1d f8 28 11 80    	mov    0x801128f8,%ebx
  if(kmem.use_lock)
80103973:	a1 f4 28 11 80       	mov    0x801128f4,%eax
  if(r)
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	85 db                	test   %ebx,%ebx
8010397d:	74 08                	je     80103987 <kalloc+0x57>
    kmem.freelist = r->next;
8010397f:	8b 13                	mov    (%ebx),%edx
80103981:	89 15 f8 28 11 80    	mov    %edx,0x801128f8
  if(kmem.use_lock)
80103987:	85 c0                	test   %eax,%eax
80103989:	74 c6                	je     80103951 <kalloc+0x21>
    release(&kmem.lock);
8010398b:	83 ec 0c             	sub    $0xc,%esp
8010398e:	68 c0 28 11 80       	push   $0x801128c0
80103993:	e8 78 1e 00 00       	call   80105810 <release>
}
80103998:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010399a:	83 c4 10             	add    $0x10,%esp
}
8010399d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a0:	c9                   	leave
801039a1:	c3                   	ret
801039a2:	66 90                	xchg   %ax,%ax
801039a4:	66 90                	xchg   %ax,%ax
801039a6:	66 90                	xchg   %ax,%ax
801039a8:	66 90                	xchg   %ax,%ax
801039aa:	66 90                	xchg   %ax,%ax
801039ac:	66 90                	xchg   %ax,%ax
801039ae:	66 90                	xchg   %ax,%ax

801039b0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039b0:	ba 64 00 00 00       	mov    $0x64,%edx
801039b5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801039b6:	a8 01                	test   $0x1,%al
801039b8:	0f 84 c2 00 00 00    	je     80103a80 <kbdgetc+0xd0>
{
801039be:	55                   	push   %ebp
801039bf:	ba 60 00 00 00       	mov    $0x60,%edx
801039c4:	89 e5                	mov    %esp,%ebp
801039c6:	53                   	push   %ebx
801039c7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801039c8:	8b 1d fc 28 11 80    	mov    0x801128fc,%ebx
  data = inb(KBDATAP);
801039ce:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801039d1:	3c e0                	cmp    $0xe0,%al
801039d3:	74 5b                	je     80103a30 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801039d5:	89 da                	mov    %ebx,%edx
801039d7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801039da:	84 c0                	test   %al,%al
801039dc:	78 62                	js     80103a40 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801039de:	85 d2                	test   %edx,%edx
801039e0:	74 09                	je     801039eb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801039e2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801039e5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801039e8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801039eb:	0f b6 91 80 8c 10 80 	movzbl -0x7fef7380(%ecx),%edx
  shift ^= togglecode[data];
801039f2:	0f b6 81 80 8b 10 80 	movzbl -0x7fef7480(%ecx),%eax
  shift |= shiftcode[data];
801039f9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801039fb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801039fd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801039ff:	89 15 fc 28 11 80    	mov    %edx,0x801128fc
  c = charcode[shift & (CTL | SHIFT)][data];
80103a05:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103a08:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103a0b:	8b 04 85 60 8b 10 80 	mov    -0x7fef74a0(,%eax,4),%eax
80103a12:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103a16:	74 0b                	je     80103a23 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103a18:	8d 50 9f             	lea    -0x61(%eax),%edx
80103a1b:	83 fa 19             	cmp    $0x19,%edx
80103a1e:	77 48                	ja     80103a68 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103a20:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a26:	c9                   	leave
80103a27:	c3                   	ret
80103a28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a2f:	00 
    shift |= E0ESC;
80103a30:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103a33:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103a35:	89 1d fc 28 11 80    	mov    %ebx,0x801128fc
}
80103a3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3e:	c9                   	leave
80103a3f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80103a40:	83 e0 7f             	and    $0x7f,%eax
80103a43:	85 d2                	test   %edx,%edx
80103a45:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103a48:	0f b6 81 80 8c 10 80 	movzbl -0x7fef7380(%ecx),%eax
80103a4f:	83 c8 40             	or     $0x40,%eax
80103a52:	0f b6 c0             	movzbl %al,%eax
80103a55:	f7 d0                	not    %eax
80103a57:	21 d8                	and    %ebx,%eax
80103a59:	a3 fc 28 11 80       	mov    %eax,0x801128fc
    return 0;
80103a5e:	31 c0                	xor    %eax,%eax
80103a60:	eb d9                	jmp    80103a3b <kbdgetc+0x8b>
80103a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103a68:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103a6b:	8d 50 20             	lea    0x20(%eax),%edx
}
80103a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a71:	c9                   	leave
      c += 'a' - 'A';
80103a72:	83 f9 1a             	cmp    $0x1a,%ecx
80103a75:	0f 42 c2             	cmovb  %edx,%eax
}
80103a78:	c3                   	ret
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a85:	c3                   	ret
80103a86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a8d:	00 
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <kbdintr>:

void
kbdintr(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103a96:	68 b0 39 10 80       	push   $0x801039b0
80103a9b:	e8 a0 d3 ff ff       	call   80100e40 <consoleintr>
}
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	c9                   	leave
80103aa4:	c3                   	ret
80103aa5:	66 90                	xchg   %ax,%ax
80103aa7:	66 90                	xchg   %ax,%ax
80103aa9:	66 90                	xchg   %ax,%ax
80103aab:	66 90                	xchg   %ax,%ax
80103aad:	66 90                	xchg   %ax,%ax
80103aaf:	90                   	nop

80103ab0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103ab0:	a1 00 29 11 80       	mov    0x80112900,%eax
80103ab5:	85 c0                	test   %eax,%eax
80103ab7:	0f 84 c3 00 00 00    	je     80103b80 <lapicinit+0xd0>
  lapic[index] = value;
80103abd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103ac4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ac7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103aca:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103ad1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ad4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103ad7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103ade:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103ae1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103ae4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103aeb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103aee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103af1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103af8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103afb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103afe:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103b05:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b08:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103b0b:	8b 50 30             	mov    0x30(%eax),%edx
80103b0e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80103b14:	75 72                	jne    80103b88 <lapicinit+0xd8>
  lapic[index] = value;
80103b16:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103b1d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b20:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b23:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103b2a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b2d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b30:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103b37:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b3a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b3d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103b44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b4a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103b51:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103b57:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103b5e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103b61:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b68:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103b6e:	80 e6 10             	and    $0x10,%dh
80103b71:	75 f5                	jne    80103b68 <lapicinit+0xb8>
  lapic[index] = value;
80103b73:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103b7a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103b7d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103b80:	c3                   	ret
80103b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103b88:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103b8f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103b92:	8b 50 20             	mov    0x20(%eax),%edx
}
80103b95:	e9 7c ff ff ff       	jmp    80103b16 <lapicinit+0x66>
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103ba0:	a1 00 29 11 80       	mov    0x80112900,%eax
80103ba5:	85 c0                	test   %eax,%eax
80103ba7:	74 07                	je     80103bb0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103ba9:	8b 40 20             	mov    0x20(%eax),%eax
80103bac:	c1 e8 18             	shr    $0x18,%eax
80103baf:	c3                   	ret
    return 0;
80103bb0:	31 c0                	xor    %eax,%eax
}
80103bb2:	c3                   	ret
80103bb3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bba:	00 
80103bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103bc0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103bc0:	a1 00 29 11 80       	mov    0x80112900,%eax
80103bc5:	85 c0                	test   %eax,%eax
80103bc7:	74 0d                	je     80103bd6 <lapiceoi+0x16>
  lapic[index] = value;
80103bc9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103bd0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103bd3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103bd6:	c3                   	ret
80103bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bde:	00 
80103bdf:	90                   	nop

80103be0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103be0:	c3                   	ret
80103be1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103be8:	00 
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103bf0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bf1:	b8 0f 00 00 00       	mov    $0xf,%eax
80103bf6:	ba 70 00 00 00       	mov    $0x70,%edx
80103bfb:	89 e5                	mov    %esp,%ebp
80103bfd:	53                   	push   %ebx
80103bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c04:	ee                   	out    %al,(%dx)
80103c05:	b8 0a 00 00 00       	mov    $0xa,%eax
80103c0a:	ba 71 00 00 00       	mov    $0x71,%edx
80103c0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103c10:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80103c12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103c15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103c1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80103c20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103c22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103c25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103c28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103c2e:	a1 00 29 11 80       	mov    0x80112900,%eax
80103c33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103c43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103c50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103c53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103c68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103c71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103c77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c7d:	c9                   	leave
80103c7e:	c3                   	ret
80103c7f:	90                   	nop

80103c80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103c80:	55                   	push   %ebp
80103c81:	b8 0b 00 00 00       	mov    $0xb,%eax
80103c86:	ba 70 00 00 00       	mov    $0x70,%edx
80103c8b:	89 e5                	mov    %esp,%ebp
80103c8d:	57                   	push   %edi
80103c8e:	56                   	push   %esi
80103c8f:	53                   	push   %ebx
80103c90:	83 ec 4c             	sub    $0x4c,%esp
80103c93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c94:	ba 71 00 00 00       	mov    $0x71,%edx
80103c99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103c9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c9d:	bf 70 00 00 00       	mov    $0x70,%edi
80103ca2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103ca5:	8d 76 00             	lea    0x0(%esi),%esi
80103ca8:	31 c0                	xor    %eax,%eax
80103caa:	89 fa                	mov    %edi,%edx
80103cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cad:	b9 71 00 00 00       	mov    $0x71,%ecx
80103cb2:	89 ca                	mov    %ecx,%edx
80103cb4:	ec                   	in     (%dx),%al
80103cb5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cb8:	89 fa                	mov    %edi,%edx
80103cba:	b8 02 00 00 00       	mov    $0x2,%eax
80103cbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cc0:	89 ca                	mov    %ecx,%edx
80103cc2:	ec                   	in     (%dx),%al
80103cc3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cc6:	89 fa                	mov    %edi,%edx
80103cc8:	b8 04 00 00 00       	mov    $0x4,%eax
80103ccd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cce:	89 ca                	mov    %ecx,%edx
80103cd0:	ec                   	in     (%dx),%al
80103cd1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cd4:	89 fa                	mov    %edi,%edx
80103cd6:	b8 07 00 00 00       	mov    $0x7,%eax
80103cdb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cdc:	89 ca                	mov    %ecx,%edx
80103cde:	ec                   	in     (%dx),%al
80103cdf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ce2:	89 fa                	mov    %edi,%edx
80103ce4:	b8 08 00 00 00       	mov    $0x8,%eax
80103ce9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cea:	89 ca                	mov    %ecx,%edx
80103cec:	ec                   	in     (%dx),%al
80103ced:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cef:	89 fa                	mov    %edi,%edx
80103cf1:	b8 09 00 00 00       	mov    $0x9,%eax
80103cf6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103cf7:	89 ca                	mov    %ecx,%edx
80103cf9:	ec                   	in     (%dx),%al
80103cfa:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103cfd:	89 fa                	mov    %edi,%edx
80103cff:	b8 0a 00 00 00       	mov    $0xa,%eax
80103d04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d05:	89 ca                	mov    %ecx,%edx
80103d07:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103d08:	84 c0                	test   %al,%al
80103d0a:	78 9c                	js     80103ca8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103d0c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103d10:	89 f2                	mov    %esi,%edx
80103d12:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103d15:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d18:	89 fa                	mov    %edi,%edx
80103d1a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103d1d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103d21:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103d24:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103d27:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103d2b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103d2e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103d32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103d35:	31 c0                	xor    %eax,%eax
80103d37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d38:	89 ca                	mov    %ecx,%edx
80103d3a:	ec                   	in     (%dx),%al
80103d3b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d3e:	89 fa                	mov    %edi,%edx
80103d40:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103d43:	b8 02 00 00 00       	mov    $0x2,%eax
80103d48:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d49:	89 ca                	mov    %ecx,%edx
80103d4b:	ec                   	in     (%dx),%al
80103d4c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d4f:	89 fa                	mov    %edi,%edx
80103d51:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103d54:	b8 04 00 00 00       	mov    $0x4,%eax
80103d59:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d5a:	89 ca                	mov    %ecx,%edx
80103d5c:	ec                   	in     (%dx),%al
80103d5d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d60:	89 fa                	mov    %edi,%edx
80103d62:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103d65:	b8 07 00 00 00       	mov    $0x7,%eax
80103d6a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d6b:	89 ca                	mov    %ecx,%edx
80103d6d:	ec                   	in     (%dx),%al
80103d6e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d71:	89 fa                	mov    %edi,%edx
80103d73:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103d76:	b8 08 00 00 00       	mov    $0x8,%eax
80103d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d7c:	89 ca                	mov    %ecx,%edx
80103d7e:	ec                   	in     (%dx),%al
80103d7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d82:	89 fa                	mov    %edi,%edx
80103d84:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103d87:	b8 09 00 00 00       	mov    $0x9,%eax
80103d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d8d:	89 ca                	mov    %ecx,%edx
80103d8f:	ec                   	in     (%dx),%al
80103d90:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103d93:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103d99:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103d9c:	6a 18                	push   $0x18
80103d9e:	50                   	push   %eax
80103d9f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103da2:	50                   	push   %eax
80103da3:	e8 08 1c 00 00       	call   801059b0 <memcmp>
80103da8:	83 c4 10             	add    $0x10,%esp
80103dab:	85 c0                	test   %eax,%eax
80103dad:	0f 85 f5 fe ff ff    	jne    80103ca8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103db3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80103db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dba:	89 f0                	mov    %esi,%eax
80103dbc:	84 c0                	test   %al,%al
80103dbe:	75 78                	jne    80103e38 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103dc0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103dc3:	89 c2                	mov    %eax,%edx
80103dc5:	83 e0 0f             	and    $0xf,%eax
80103dc8:	c1 ea 04             	shr    $0x4,%edx
80103dcb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103dce:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103dd1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103dd4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103dd7:	89 c2                	mov    %eax,%edx
80103dd9:	83 e0 0f             	and    $0xf,%eax
80103ddc:	c1 ea 04             	shr    $0x4,%edx
80103ddf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103de2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103de5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103de8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103deb:	89 c2                	mov    %eax,%edx
80103ded:	83 e0 0f             	and    $0xf,%eax
80103df0:	c1 ea 04             	shr    $0x4,%edx
80103df3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103df6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103df9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103dfc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103dff:	89 c2                	mov    %eax,%edx
80103e01:	83 e0 0f             	and    $0xf,%eax
80103e04:	c1 ea 04             	shr    $0x4,%edx
80103e07:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e0a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e0d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103e10:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103e13:	89 c2                	mov    %eax,%edx
80103e15:	83 e0 0f             	and    $0xf,%eax
80103e18:	c1 ea 04             	shr    $0x4,%edx
80103e1b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e1e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e21:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103e24:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103e27:	89 c2                	mov    %eax,%edx
80103e29:	83 e0 0f             	and    $0xf,%eax
80103e2c:	c1 ea 04             	shr    $0x4,%edx
80103e2f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103e32:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103e35:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103e38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103e3b:	89 03                	mov    %eax,(%ebx)
80103e3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103e40:	89 43 04             	mov    %eax,0x4(%ebx)
80103e43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103e46:	89 43 08             	mov    %eax,0x8(%ebx)
80103e49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103e4c:	89 43 0c             	mov    %eax,0xc(%ebx)
80103e4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103e52:	89 43 10             	mov    %eax,0x10(%ebx)
80103e55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103e58:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80103e5b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80103e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e65:	5b                   	pop    %ebx
80103e66:	5e                   	pop    %esi
80103e67:	5f                   	pop    %edi
80103e68:	5d                   	pop    %ebp
80103e69:	c3                   	ret
80103e6a:	66 90                	xchg   %ax,%ax
80103e6c:	66 90                	xchg   %ax,%ax
80103e6e:	66 90                	xchg   %ax,%ax

80103e70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103e70:	8b 0d 68 29 11 80    	mov    0x80112968,%ecx
80103e76:	85 c9                	test   %ecx,%ecx
80103e78:	0f 8e 8a 00 00 00    	jle    80103f08 <install_trans+0x98>
{
80103e7e:	55                   	push   %ebp
80103e7f:	89 e5                	mov    %esp,%ebp
80103e81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103e82:	31 ff                	xor    %edi,%edi
{
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103e90:	a1 54 29 11 80       	mov    0x80112954,%eax
80103e95:	83 ec 08             	sub    $0x8,%esp
80103e98:	01 f8                	add    %edi,%eax
80103e9a:	83 c0 01             	add    $0x1,%eax
80103e9d:	50                   	push   %eax
80103e9e:	ff 35 64 29 11 80    	push   0x80112964
80103ea4:	e8 27 c2 ff ff       	call   801000d0 <bread>
80103ea9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103eab:	58                   	pop    %eax
80103eac:	5a                   	pop    %edx
80103ead:	ff 34 bd 6c 29 11 80 	push   -0x7feed694(,%edi,4)
80103eb4:	ff 35 64 29 11 80    	push   0x80112964
  for (tail = 0; tail < log.lh.n; tail++) {
80103eba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103ebd:	e8 0e c2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103ec5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103ec7:	8d 46 5c             	lea    0x5c(%esi),%eax
80103eca:	68 00 02 00 00       	push   $0x200
80103ecf:	50                   	push   %eax
80103ed0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103ed3:	50                   	push   %eax
80103ed4:	e8 27 1b 00 00       	call   80105a00 <memmove>
    bwrite(dbuf);  // write dst to disk
80103ed9:	89 1c 24             	mov    %ebx,(%esp)
80103edc:	e8 cf c2 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103ee1:	89 34 24             	mov    %esi,(%esp)
80103ee4:	e8 07 c3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103ee9:	89 1c 24             	mov    %ebx,(%esp)
80103eec:	e8 ff c2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103ef1:	83 c4 10             	add    $0x10,%esp
80103ef4:	39 3d 68 29 11 80    	cmp    %edi,0x80112968
80103efa:	7f 94                	jg     80103e90 <install_trans+0x20>
  }
}
80103efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eff:	5b                   	pop    %ebx
80103f00:	5e                   	pop    %esi
80103f01:	5f                   	pop    %edi
80103f02:	5d                   	pop    %ebp
80103f03:	c3                   	ret
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f08:	c3                   	ret
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f17:	ff 35 54 29 11 80    	push   0x80112954
80103f1d:	ff 35 64 29 11 80    	push   0x80112964
80103f23:	e8 a8 c1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103f28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103f2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80103f2d:	a1 68 29 11 80       	mov    0x80112968,%eax
80103f32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103f35:	85 c0                	test   %eax,%eax
80103f37:	7e 19                	jle    80103f52 <write_head+0x42>
80103f39:	31 d2                	xor    %edx,%edx
80103f3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80103f40:	8b 0c 95 6c 29 11 80 	mov    -0x7feed694(,%edx,4),%ecx
80103f47:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103f4b:	83 c2 01             	add    $0x1,%edx
80103f4e:	39 d0                	cmp    %edx,%eax
80103f50:	75 ee                	jne    80103f40 <write_head+0x30>
  }
  bwrite(buf);
80103f52:	83 ec 0c             	sub    $0xc,%esp
80103f55:	53                   	push   %ebx
80103f56:	e8 55 c2 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80103f5b:	89 1c 24             	mov    %ebx,(%esp)
80103f5e:	e8 8d c2 ff ff       	call   801001f0 <brelse>
}
80103f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f66:	83 c4 10             	add    $0x10,%esp
80103f69:	c9                   	leave
80103f6a:	c3                   	ret
80103f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103f70 <initlog>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 2c             	sub    $0x2c,%esp
80103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80103f7a:	68 17 86 10 80       	push   $0x80108617
80103f7f:	68 20 29 11 80       	push   $0x80112920
80103f84:	e8 f7 16 00 00       	call   80105680 <initlock>
  readsb(dev, &sb);
80103f89:	58                   	pop    %eax
80103f8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103f8d:	5a                   	pop    %edx
80103f8e:	50                   	push   %eax
80103f8f:	53                   	push   %ebx
80103f90:	e8 7b e8 ff ff       	call   80102810 <readsb>
  log.start = sb.logstart;
80103f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103f98:	59                   	pop    %ecx
  log.dev = dev;
80103f99:	89 1d 64 29 11 80    	mov    %ebx,0x80112964
  log.size = sb.nlog;
80103f9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103fa2:	a3 54 29 11 80       	mov    %eax,0x80112954
  log.size = sb.nlog;
80103fa7:	89 15 58 29 11 80    	mov    %edx,0x80112958
  struct buf *buf = bread(log.dev, log.start);
80103fad:	5a                   	pop    %edx
80103fae:	50                   	push   %eax
80103faf:	53                   	push   %ebx
80103fb0:	e8 1b c1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103fb5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80103fb8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80103fbb:	89 1d 68 29 11 80    	mov    %ebx,0x80112968
  for (i = 0; i < log.lh.n; i++) {
80103fc1:	85 db                	test   %ebx,%ebx
80103fc3:	7e 1d                	jle    80103fe2 <initlog+0x72>
80103fc5:	31 d2                	xor    %edx,%edx
80103fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fce:	00 
80103fcf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103fd0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80103fd4:	89 0c 95 6c 29 11 80 	mov    %ecx,-0x7feed694(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103fdb:	83 c2 01             	add    $0x1,%edx
80103fde:	39 d3                	cmp    %edx,%ebx
80103fe0:	75 ee                	jne    80103fd0 <initlog+0x60>
  brelse(buf);
80103fe2:	83 ec 0c             	sub    $0xc,%esp
80103fe5:	50                   	push   %eax
80103fe6:	e8 05 c2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80103feb:	e8 80 fe ff ff       	call   80103e70 <install_trans>
  log.lh.n = 0;
80103ff0:	c7 05 68 29 11 80 00 	movl   $0x0,0x80112968
80103ff7:	00 00 00 
  write_head(); // clear the log
80103ffa:	e8 11 ff ff ff       	call   80103f10 <write_head>
}
80103fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104002:	83 c4 10             	add    $0x10,%esp
80104005:	c9                   	leave
80104006:	c3                   	ret
80104007:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010400e:	00 
8010400f:	90                   	nop

80104010 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104016:	68 20 29 11 80       	push   $0x80112920
8010401b:	e8 50 18 00 00       	call   80105870 <acquire>
80104020:	83 c4 10             	add    $0x10,%esp
80104023:	eb 18                	jmp    8010403d <begin_op+0x2d>
80104025:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104028:	83 ec 08             	sub    $0x8,%esp
8010402b:	68 20 29 11 80       	push   $0x80112920
80104030:	68 20 29 11 80       	push   $0x80112920
80104035:	e8 b6 12 00 00       	call   801052f0 <sleep>
8010403a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010403d:	a1 60 29 11 80       	mov    0x80112960,%eax
80104042:	85 c0                	test   %eax,%eax
80104044:	75 e2                	jne    80104028 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104046:	a1 5c 29 11 80       	mov    0x8011295c,%eax
8010404b:	8b 15 68 29 11 80    	mov    0x80112968,%edx
80104051:	83 c0 01             	add    $0x1,%eax
80104054:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104057:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010405a:	83 fa 1e             	cmp    $0x1e,%edx
8010405d:	7f c9                	jg     80104028 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010405f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104062:	a3 5c 29 11 80       	mov    %eax,0x8011295c
      release(&log.lock);
80104067:	68 20 29 11 80       	push   $0x80112920
8010406c:	e8 9f 17 00 00       	call   80105810 <release>
      break;
    }
  }
}
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	c9                   	leave
80104075:	c3                   	ret
80104076:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010407d:	00 
8010407e:	66 90                	xchg   %ax,%ax

80104080 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80104089:	68 20 29 11 80       	push   $0x80112920
8010408e:	e8 dd 17 00 00       	call   80105870 <acquire>
  log.outstanding -= 1;
80104093:	a1 5c 29 11 80       	mov    0x8011295c,%eax
  if(log.committing)
80104098:	8b 35 60 29 11 80    	mov    0x80112960,%esi
8010409e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801040a1:	8d 58 ff             	lea    -0x1(%eax),%ebx
801040a4:	89 1d 5c 29 11 80    	mov    %ebx,0x8011295c
  if(log.committing)
801040aa:	85 f6                	test   %esi,%esi
801040ac:	0f 85 22 01 00 00    	jne    801041d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801040b2:	85 db                	test   %ebx,%ebx
801040b4:	0f 85 f6 00 00 00    	jne    801041b0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801040ba:	c7 05 60 29 11 80 01 	movl   $0x1,0x80112960
801040c1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	68 20 29 11 80       	push   $0x80112920
801040cc:	e8 3f 17 00 00       	call   80105810 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801040d1:	8b 0d 68 29 11 80    	mov    0x80112968,%ecx
801040d7:	83 c4 10             	add    $0x10,%esp
801040da:	85 c9                	test   %ecx,%ecx
801040dc:	7f 42                	jg     80104120 <end_op+0xa0>
    acquire(&log.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	68 20 29 11 80       	push   $0x80112920
801040e6:	e8 85 17 00 00       	call   80105870 <acquire>
    log.committing = 0;
801040eb:	c7 05 60 29 11 80 00 	movl   $0x0,0x80112960
801040f2:	00 00 00 
    wakeup(&log);
801040f5:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
801040fc:	e8 af 12 00 00       	call   801053b0 <wakeup>
    release(&log.lock);
80104101:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
80104108:	e8 03 17 00 00       	call   80105810 <release>
8010410d:	83 c4 10             	add    $0x10,%esp
}
80104110:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104113:	5b                   	pop    %ebx
80104114:	5e                   	pop    %esi
80104115:	5f                   	pop    %edi
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret
80104118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010411f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104120:	a1 54 29 11 80       	mov    0x80112954,%eax
80104125:	83 ec 08             	sub    $0x8,%esp
80104128:	01 d8                	add    %ebx,%eax
8010412a:	83 c0 01             	add    $0x1,%eax
8010412d:	50                   	push   %eax
8010412e:	ff 35 64 29 11 80    	push   0x80112964
80104134:	e8 97 bf ff ff       	call   801000d0 <bread>
80104139:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010413b:	58                   	pop    %eax
8010413c:	5a                   	pop    %edx
8010413d:	ff 34 9d 6c 29 11 80 	push   -0x7feed694(,%ebx,4)
80104144:	ff 35 64 29 11 80    	push   0x80112964
  for (tail = 0; tail < log.lh.n; tail++) {
8010414a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010414d:	e8 7e bf ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104152:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104155:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104157:	8d 40 5c             	lea    0x5c(%eax),%eax
8010415a:	68 00 02 00 00       	push   $0x200
8010415f:	50                   	push   %eax
80104160:	8d 46 5c             	lea    0x5c(%esi),%eax
80104163:	50                   	push   %eax
80104164:	e8 97 18 00 00       	call   80105a00 <memmove>
    bwrite(to);  // write the log
80104169:	89 34 24             	mov    %esi,(%esp)
8010416c:	e8 3f c0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80104171:	89 3c 24             	mov    %edi,(%esp)
80104174:	e8 77 c0 ff ff       	call   801001f0 <brelse>
    brelse(to);
80104179:	89 34 24             	mov    %esi,(%esp)
8010417c:	e8 6f c0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104181:	83 c4 10             	add    $0x10,%esp
80104184:	3b 1d 68 29 11 80    	cmp    0x80112968,%ebx
8010418a:	7c 94                	jl     80104120 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010418c:	e8 7f fd ff ff       	call   80103f10 <write_head>
    install_trans(); // Now install writes to home locations
80104191:	e8 da fc ff ff       	call   80103e70 <install_trans>
    log.lh.n = 0;
80104196:	c7 05 68 29 11 80 00 	movl   $0x0,0x80112968
8010419d:	00 00 00 
    write_head();    // Erase the transaction from the log
801041a0:	e8 6b fd ff ff       	call   80103f10 <write_head>
801041a5:	e9 34 ff ff ff       	jmp    801040de <end_op+0x5e>
801041aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	68 20 29 11 80       	push   $0x80112920
801041b8:	e8 f3 11 00 00       	call   801053b0 <wakeup>
  release(&log.lock);
801041bd:	c7 04 24 20 29 11 80 	movl   $0x80112920,(%esp)
801041c4:	e8 47 16 00 00       	call   80105810 <release>
801041c9:	83 c4 10             	add    $0x10,%esp
}
801041cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041cf:	5b                   	pop    %ebx
801041d0:	5e                   	pop    %esi
801041d1:	5f                   	pop    %edi
801041d2:	5d                   	pop    %ebp
801041d3:	c3                   	ret
    panic("log.committing");
801041d4:	83 ec 0c             	sub    $0xc,%esp
801041d7:	68 1b 86 10 80       	push   $0x8010861b
801041dc:	e8 5f c3 ff ff       	call   80100540 <panic>
801041e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801041e8:	00 
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801041f7:	8b 15 68 29 11 80    	mov    0x80112968,%edx
{
801041fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104200:	83 fa 1d             	cmp    $0x1d,%edx
80104203:	7f 7d                	jg     80104282 <log_write+0x92>
80104205:	a1 58 29 11 80       	mov    0x80112958,%eax
8010420a:	83 e8 01             	sub    $0x1,%eax
8010420d:	39 c2                	cmp    %eax,%edx
8010420f:	7d 71                	jge    80104282 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104211:	a1 5c 29 11 80       	mov    0x8011295c,%eax
80104216:	85 c0                	test   %eax,%eax
80104218:	7e 75                	jle    8010428f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010421a:	83 ec 0c             	sub    $0xc,%esp
8010421d:	68 20 29 11 80       	push   $0x80112920
80104222:	e8 49 16 00 00       	call   80105870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104227:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010422a:	83 c4 10             	add    $0x10,%esp
8010422d:	31 c0                	xor    %eax,%eax
8010422f:	8b 15 68 29 11 80    	mov    0x80112968,%edx
80104235:	85 d2                	test   %edx,%edx
80104237:	7f 0e                	jg     80104247 <log_write+0x57>
80104239:	eb 15                	jmp    80104250 <log_write+0x60>
8010423b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104240:	83 c0 01             	add    $0x1,%eax
80104243:	39 c2                	cmp    %eax,%edx
80104245:	74 29                	je     80104270 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104247:	39 0c 85 6c 29 11 80 	cmp    %ecx,-0x7feed694(,%eax,4)
8010424e:	75 f0                	jne    80104240 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104250:	89 0c 85 6c 29 11 80 	mov    %ecx,-0x7feed694(,%eax,4)
  if (i == log.lh.n)
80104257:	39 c2                	cmp    %eax,%edx
80104259:	74 1c                	je     80104277 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010425b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010425e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80104261:	c7 45 08 20 29 11 80 	movl   $0x80112920,0x8(%ebp)
}
80104268:	c9                   	leave
  release(&log.lock);
80104269:	e9 a2 15 00 00       	jmp    80105810 <release>
8010426e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104270:	89 0c 95 6c 29 11 80 	mov    %ecx,-0x7feed694(,%edx,4)
    log.lh.n++;
80104277:	83 c2 01             	add    $0x1,%edx
8010427a:	89 15 68 29 11 80    	mov    %edx,0x80112968
80104280:	eb d9                	jmp    8010425b <log_write+0x6b>
    panic("too big a transaction");
80104282:	83 ec 0c             	sub    $0xc,%esp
80104285:	68 2a 86 10 80       	push   $0x8010862a
8010428a:	e8 b1 c2 ff ff       	call   80100540 <panic>
    panic("log_write outside of trans");
8010428f:	83 ec 0c             	sub    $0xc,%esp
80104292:	68 40 86 10 80       	push   $0x80108640
80104297:	e8 a4 c2 ff ff       	call   80100540 <panic>
8010429c:	66 90                	xchg   %ax,%ax
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801042a7:	e8 64 09 00 00       	call   80104c10 <cpuid>
801042ac:	89 c3                	mov    %eax,%ebx
801042ae:	e8 5d 09 00 00       	call   80104c10 <cpuid>
801042b3:	83 ec 04             	sub    $0x4,%esp
801042b6:	53                   	push   %ebx
801042b7:	50                   	push   %eax
801042b8:	68 5b 86 10 80       	push   $0x8010865b
801042bd:	e8 6e c9 ff ff       	call   80100c30 <cprintf>
  idtinit();       // load idt register
801042c2:	e8 e9 28 00 00       	call   80106bb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801042c7:	e8 e4 08 00 00       	call   80104bb0 <mycpu>
801042cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801042ce:	b8 01 00 00 00       	mov    $0x1,%eax
801042d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801042da:	e8 01 0c 00 00       	call   80104ee0 <scheduler>
801042df:	90                   	nop

801042e0 <mpenter>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801042e6:	e8 c5 39 00 00       	call   80107cb0 <switchkvm>
  seginit();
801042eb:	e8 30 39 00 00       	call   80107c20 <seginit>
  lapicinit();
801042f0:	e8 bb f7 ff ff       	call   80103ab0 <lapicinit>
  mpmain();
801042f5:	e8 a6 ff ff ff       	call   801042a0 <mpmain>
801042fa:	66 90                	xchg   %ax,%ax
801042fc:	66 90                	xchg   %ax,%ax
801042fe:	66 90                	xchg   %ax,%ax

80104300 <main>:
{
80104300:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104304:	83 e4 f0             	and    $0xfffffff0,%esp
80104307:	ff 71 fc             	push   -0x4(%ecx)
8010430a:	55                   	push   %ebp
8010430b:	89 e5                	mov    %esp,%ebp
8010430d:	53                   	push   %ebx
8010430e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010430f:	83 ec 08             	sub    $0x8,%esp
80104312:	68 00 00 40 80       	push   $0x80400000
80104317:	68 50 67 11 80       	push   $0x80116750
8010431c:	e8 9f f5 ff ff       	call   801038c0 <kinit1>
  kvmalloc();      // kernel page table
80104321:	e8 4a 3e 00 00       	call   80108170 <kvmalloc>
  mpinit();        // detect other processors
80104326:	e8 85 01 00 00       	call   801044b0 <mpinit>
  lapicinit();     // interrupt controller
8010432b:	e8 80 f7 ff ff       	call   80103ab0 <lapicinit>
  seginit();       // segment descriptors
80104330:	e8 eb 38 00 00       	call   80107c20 <seginit>
  picinit();       // disable pic
80104335:	e8 86 03 00 00       	call   801046c0 <picinit>
  ioapicinit();    // another interrupt controller
8010433a:	e8 51 f3 ff ff       	call   80103690 <ioapicinit>
  consoleinit();   // console hardware
8010433f:	e8 cc d9 ff ff       	call   80101d10 <consoleinit>
  uartinit();      // serial port
80104344:	e8 47 2b 00 00       	call   80106e90 <uartinit>
  pinit();         // process table
80104349:	e8 42 08 00 00       	call   80104b90 <pinit>
  tvinit();        // trap vectors
8010434e:	e8 dd 27 00 00       	call   80106b30 <tvinit>
  binit();         // buffer cache
80104353:	e8 e8 bc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104358:	e8 a3 dd ff ff       	call   80102100 <fileinit>
  ideinit();       // disk 
8010435d:	e8 0e f1 ff ff       	call   80103470 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104362:	83 c4 0c             	add    $0xc,%esp
80104365:	68 8a 00 00 00       	push   $0x8a
8010436a:	68 8c b4 10 80       	push   $0x8010b48c
8010436f:	68 00 70 00 80       	push   $0x80007000
80104374:	e8 87 16 00 00       	call   80105a00 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104379:	83 c4 10             	add    $0x10,%esp
8010437c:	69 05 04 2a 11 80 b0 	imul   $0xb0,0x80112a04,%eax
80104383:	00 00 00 
80104386:	05 20 2a 11 80       	add    $0x80112a20,%eax
8010438b:	3d 20 2a 11 80       	cmp    $0x80112a20,%eax
80104390:	76 7e                	jbe    80104410 <main+0x110>
80104392:	bb 20 2a 11 80       	mov    $0x80112a20,%ebx
80104397:	eb 20                	jmp    801043b9 <main+0xb9>
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a0:	69 05 04 2a 11 80 b0 	imul   $0xb0,0x80112a04,%eax
801043a7:	00 00 00 
801043aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801043b0:	05 20 2a 11 80       	add    $0x80112a20,%eax
801043b5:	39 c3                	cmp    %eax,%ebx
801043b7:	73 57                	jae    80104410 <main+0x110>
    if(c == mycpu())  // We've started already.
801043b9:	e8 f2 07 00 00       	call   80104bb0 <mycpu>
801043be:	39 c3                	cmp    %eax,%ebx
801043c0:	74 de                	je     801043a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801043c2:	e8 69 f5 ff ff       	call   80103930 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801043c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801043ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801042e0,0x80006ff8
801043d1:	42 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801043d4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801043db:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801043de:	05 00 10 00 00       	add    $0x1000,%eax
801043e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801043e8:	0f b6 03             	movzbl (%ebx),%eax
801043eb:	68 00 70 00 00       	push   $0x7000
801043f0:	50                   	push   %eax
801043f1:	e8 fa f7 ff ff       	call   80103bf0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801043f6:	83 c4 10             	add    $0x10,%esp
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104400:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80104406:	85 c0                	test   %eax,%eax
80104408:	74 f6                	je     80104400 <main+0x100>
8010440a:	eb 94                	jmp    801043a0 <main+0xa0>
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80104410:	83 ec 08             	sub    $0x8,%esp
80104413:	68 00 00 00 8e       	push   $0x8e000000
80104418:	68 00 00 40 80       	push   $0x80400000
8010441d:	e8 3e f4 ff ff       	call   80103860 <kinit2>
  userinit();      // first user process
80104422:	e8 39 08 00 00       	call   80104c60 <userinit>
  mpmain();        // finish this processor's setup
80104427:	e8 74 fe ff ff       	call   801042a0 <mpmain>
8010442c:	66 90                	xchg   %ax,%ax
8010442e:	66 90                	xchg   %ax,%ax

80104430 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104435:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010443b:	53                   	push   %ebx
  e = addr+len;
8010443c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010443f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80104442:	39 de                	cmp    %ebx,%esi
80104444:	72 10                	jb     80104456 <mpsearch1+0x26>
80104446:	eb 50                	jmp    80104498 <mpsearch1+0x68>
80104448:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010444f:	00 
80104450:	89 fe                	mov    %edi,%esi
80104452:	39 df                	cmp    %ebx,%edi
80104454:	73 42                	jae    80104498 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104456:	83 ec 04             	sub    $0x4,%esp
80104459:	8d 7e 10             	lea    0x10(%esi),%edi
8010445c:	6a 04                	push   $0x4
8010445e:	68 6f 86 10 80       	push   $0x8010866f
80104463:	56                   	push   %esi
80104464:	e8 47 15 00 00       	call   801059b0 <memcmp>
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	85 c0                	test   %eax,%eax
8010446e:	75 e0                	jne    80104450 <mpsearch1+0x20>
80104470:	89 f2                	mov    %esi,%edx
80104472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80104478:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010447b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010447e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104480:	39 fa                	cmp    %edi,%edx
80104482:	75 f4                	jne    80104478 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104484:	84 c0                	test   %al,%al
80104486:	75 c8                	jne    80104450 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80104488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010448b:	89 f0                	mov    %esi,%eax
8010448d:	5b                   	pop    %ebx
8010448e:	5e                   	pop    %esi
8010448f:	5f                   	pop    %edi
80104490:	5d                   	pop    %ebp
80104491:	c3                   	ret
80104492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010449b:	31 f6                	xor    %esi,%esi
}
8010449d:	5b                   	pop    %ebx
8010449e:	89 f0                	mov    %esi,%eax
801044a0:	5e                   	pop    %esi
801044a1:	5f                   	pop    %edi
801044a2:	5d                   	pop    %ebp
801044a3:	c3                   	ret
801044a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044ab:	00 
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	56                   	push   %esi
801044b5:	53                   	push   %ebx
801044b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801044b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801044c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801044c7:	c1 e0 08             	shl    $0x8,%eax
801044ca:	09 d0                	or     %edx,%eax
801044cc:	c1 e0 04             	shl    $0x4,%eax
801044cf:	75 1b                	jne    801044ec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801044d1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801044d8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801044df:	c1 e0 08             	shl    $0x8,%eax
801044e2:	09 d0                	or     %edx,%eax
801044e4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801044e7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801044ec:	ba 00 04 00 00       	mov    $0x400,%edx
801044f1:	e8 3a ff ff ff       	call   80104430 <mpsearch1>
801044f6:	89 c3                	mov    %eax,%ebx
801044f8:	85 c0                	test   %eax,%eax
801044fa:	0f 84 58 01 00 00    	je     80104658 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104500:	8b 73 04             	mov    0x4(%ebx),%esi
80104503:	85 f6                	test   %esi,%esi
80104505:	0f 84 3d 01 00 00    	je     80104648 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010450b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010450e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80104514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80104517:	6a 04                	push   $0x4
80104519:	68 74 86 10 80       	push   $0x80108674
8010451e:	50                   	push   %eax
8010451f:	e8 8c 14 00 00       	call   801059b0 <memcmp>
80104524:	83 c4 10             	add    $0x10,%esp
80104527:	85 c0                	test   %eax,%eax
80104529:	0f 85 19 01 00 00    	jne    80104648 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010452f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104536:	3c 01                	cmp    $0x1,%al
80104538:	74 08                	je     80104542 <mpinit+0x92>
8010453a:	3c 04                	cmp    $0x4,%al
8010453c:	0f 85 06 01 00 00    	jne    80104648 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80104542:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80104549:	66 85 d2             	test   %dx,%dx
8010454c:	74 22                	je     80104570 <mpinit+0xc0>
8010454e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80104551:	89 f0                	mov    %esi,%eax
  sum = 0;
80104553:	31 d2                	xor    %edx,%edx
80104555:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104558:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010455f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80104562:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80104564:	39 f8                	cmp    %edi,%eax
80104566:	75 f0                	jne    80104558 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80104568:	84 d2                	test   %dl,%dl
8010456a:	0f 85 d8 00 00 00    	jne    80104648 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80104570:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104576:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104579:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010457c:	a3 00 29 11 80       	mov    %eax,0x80112900
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104581:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80104588:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010458e:	01 d7                	add    %edx,%edi
80104590:	89 fa                	mov    %edi,%edx
  ismp = 1;
80104592:	bf 01 00 00 00       	mov    $0x1,%edi
80104597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010459e:	00 
8010459f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045a0:	39 d0                	cmp    %edx,%eax
801045a2:	73 19                	jae    801045bd <mpinit+0x10d>
    switch(*p){
801045a4:	0f b6 08             	movzbl (%eax),%ecx
801045a7:	80 f9 02             	cmp    $0x2,%cl
801045aa:	0f 84 80 00 00 00    	je     80104630 <mpinit+0x180>
801045b0:	77 6e                	ja     80104620 <mpinit+0x170>
801045b2:	84 c9                	test   %cl,%cl
801045b4:	74 3a                	je     801045f0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801045b6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801045b9:	39 d0                	cmp    %edx,%eax
801045bb:	72 e7                	jb     801045a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801045bd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801045c0:	85 ff                	test   %edi,%edi
801045c2:	0f 84 dd 00 00 00    	je     801046a5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801045c8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801045cc:	74 15                	je     801045e3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045ce:	b8 70 00 00 00       	mov    $0x70,%eax
801045d3:	ba 22 00 00 00       	mov    $0x22,%edx
801045d8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045d9:	ba 23 00 00 00       	mov    $0x23,%edx
801045de:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801045df:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801045e2:	ee                   	out    %al,(%dx)
  }
}
801045e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e6:	5b                   	pop    %ebx
801045e7:	5e                   	pop    %esi
801045e8:	5f                   	pop    %edi
801045e9:	5d                   	pop    %ebp
801045ea:	c3                   	ret
801045eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801045f0:	8b 0d 04 2a 11 80    	mov    0x80112a04,%ecx
801045f6:	83 f9 07             	cmp    $0x7,%ecx
801045f9:	7f 19                	jg     80104614 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801045fb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80104601:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80104605:	83 c1 01             	add    $0x1,%ecx
80104608:	89 0d 04 2a 11 80    	mov    %ecx,0x80112a04
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010460e:	88 9e 20 2a 11 80    	mov    %bl,-0x7feed5e0(%esi)
      p += sizeof(struct mpproc);
80104614:	83 c0 14             	add    $0x14,%eax
      continue;
80104617:	eb 87                	jmp    801045a0 <mpinit+0xf0>
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80104620:	83 e9 03             	sub    $0x3,%ecx
80104623:	80 f9 01             	cmp    $0x1,%cl
80104626:	76 8e                	jbe    801045b6 <mpinit+0x106>
80104628:	31 ff                	xor    %edi,%edi
8010462a:	e9 71 ff ff ff       	jmp    801045a0 <mpinit+0xf0>
8010462f:	90                   	nop
      ioapicid = ioapic->apicno;
80104630:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104634:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104637:	88 0d 00 2a 11 80    	mov    %cl,0x80112a00
      continue;
8010463d:	e9 5e ff ff ff       	jmp    801045a0 <mpinit+0xf0>
80104642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 79 86 10 80       	push   $0x80108679
80104650:	e8 eb be ff ff       	call   80100540 <panic>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
{
80104658:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010465d:	eb 0b                	jmp    8010466a <mpinit+0x1ba>
8010465f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80104660:	89 f3                	mov    %esi,%ebx
80104662:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80104668:	74 de                	je     80104648 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010466a:	83 ec 04             	sub    $0x4,%esp
8010466d:	8d 73 10             	lea    0x10(%ebx),%esi
80104670:	6a 04                	push   $0x4
80104672:	68 6f 86 10 80       	push   $0x8010866f
80104677:	53                   	push   %ebx
80104678:	e8 33 13 00 00       	call   801059b0 <memcmp>
8010467d:	83 c4 10             	add    $0x10,%esp
80104680:	85 c0                	test   %eax,%eax
80104682:	75 dc                	jne    80104660 <mpinit+0x1b0>
80104684:	89 da                	mov    %ebx,%edx
80104686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010468d:	00 
8010468e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80104690:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104693:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104696:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104698:	39 d6                	cmp    %edx,%esi
8010469a:	75 f4                	jne    80104690 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010469c:	84 c0                	test   %al,%al
8010469e:	75 c0                	jne    80104660 <mpinit+0x1b0>
801046a0:	e9 5b fe ff ff       	jmp    80104500 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801046a5:	83 ec 0c             	sub    $0xc,%esp
801046a8:	68 48 8a 10 80       	push   $0x80108a48
801046ad:	e8 8e be ff ff       	call   80100540 <panic>
801046b2:	66 90                	xchg   %ax,%ax
801046b4:	66 90                	xchg   %ax,%ax
801046b6:	66 90                	xchg   %ax,%ax
801046b8:	66 90                	xchg   %ax,%ax
801046ba:	66 90                	xchg   %ax,%ax
801046bc:	66 90                	xchg   %ax,%ax
801046be:	66 90                	xchg   %ax,%ax

801046c0 <picinit>:
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046c5:	ba 21 00 00 00       	mov    $0x21,%edx
801046ca:	ee                   	out    %al,(%dx)
801046cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801046d0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801046d1:	c3                   	ret
801046d2:	66 90                	xchg   %ax,%ax
801046d4:	66 90                	xchg   %ax,%ax
801046d6:	66 90                	xchg   %ax,%ax
801046d8:	66 90                	xchg   %ax,%ax
801046da:	66 90                	xchg   %ax,%ax
801046dc:	66 90                	xchg   %ax,%ax
801046de:	66 90                	xchg   %ax,%ax

801046e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	83 ec 0c             	sub    $0xc,%esp
801046e9:	8b 75 08             	mov    0x8(%ebp),%esi
801046ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801046ef:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801046f5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801046fb:	e8 20 da ff ff       	call   80102120 <filealloc>
80104700:	89 06                	mov    %eax,(%esi)
80104702:	85 c0                	test   %eax,%eax
80104704:	0f 84 a5 00 00 00    	je     801047af <pipealloc+0xcf>
8010470a:	e8 11 da ff ff       	call   80102120 <filealloc>
8010470f:	89 07                	mov    %eax,(%edi)
80104711:	85 c0                	test   %eax,%eax
80104713:	0f 84 84 00 00 00    	je     8010479d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104719:	e8 12 f2 ff ff       	call   80103930 <kalloc>
8010471e:	89 c3                	mov    %eax,%ebx
80104720:	85 c0                	test   %eax,%eax
80104722:	0f 84 a0 00 00 00    	je     801047c8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80104728:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010472f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104732:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104735:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010473c:	00 00 00 
  p->nwrite = 0;
8010473f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104746:	00 00 00 
  p->nread = 0;
80104749:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104750:	00 00 00 
  initlock(&p->lock, "pipe");
80104753:	68 91 86 10 80       	push   $0x80108691
80104758:	50                   	push   %eax
80104759:	e8 22 0f 00 00       	call   80105680 <initlock>
  (*f0)->type = FD_PIPE;
8010475e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80104760:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104763:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104769:	8b 06                	mov    (%esi),%eax
8010476b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010476f:	8b 06                	mov    (%esi),%eax
80104771:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104775:	8b 06                	mov    (%esi),%eax
80104777:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010477a:	8b 07                	mov    (%edi),%eax
8010477c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104782:	8b 07                	mov    (%edi),%eax
80104784:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104788:	8b 07                	mov    (%edi),%eax
8010478a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010478e:	8b 07                	mov    (%edi),%eax
80104790:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80104793:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80104795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104798:	5b                   	pop    %ebx
80104799:	5e                   	pop    %esi
8010479a:	5f                   	pop    %edi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret
  if(*f0)
8010479d:	8b 06                	mov    (%esi),%eax
8010479f:	85 c0                	test   %eax,%eax
801047a1:	74 1e                	je     801047c1 <pipealloc+0xe1>
    fileclose(*f0);
801047a3:	83 ec 0c             	sub    $0xc,%esp
801047a6:	50                   	push   %eax
801047a7:	e8 34 da ff ff       	call   801021e0 <fileclose>
801047ac:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801047af:	8b 07                	mov    (%edi),%eax
801047b1:	85 c0                	test   %eax,%eax
801047b3:	74 0c                	je     801047c1 <pipealloc+0xe1>
    fileclose(*f1);
801047b5:	83 ec 0c             	sub    $0xc,%esp
801047b8:	50                   	push   %eax
801047b9:	e8 22 da ff ff       	call   801021e0 <fileclose>
801047be:	83 c4 10             	add    $0x10,%esp
  return -1;
801047c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c6:	eb cd                	jmp    80104795 <pipealloc+0xb5>
  if(*f0)
801047c8:	8b 06                	mov    (%esi),%eax
801047ca:	85 c0                	test   %eax,%eax
801047cc:	75 d5                	jne    801047a3 <pipealloc+0xc3>
801047ce:	eb df                	jmp    801047af <pipealloc+0xcf>

801047d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801047db:	83 ec 0c             	sub    $0xc,%esp
801047de:	53                   	push   %ebx
801047df:	e8 8c 10 00 00       	call   80105870 <acquire>
  if(writable){
801047e4:	83 c4 10             	add    $0x10,%esp
801047e7:	85 f6                	test   %esi,%esi
801047e9:	74 65                	je     80104850 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801047eb:	83 ec 0c             	sub    $0xc,%esp
801047ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801047f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801047fb:	00 00 00 
    wakeup(&p->nread);
801047fe:	50                   	push   %eax
801047ff:	e8 ac 0b 00 00       	call   801053b0 <wakeup>
80104804:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104807:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010480d:	85 d2                	test   %edx,%edx
8010480f:	75 0a                	jne    8010481b <pipeclose+0x4b>
80104811:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104817:	85 c0                	test   %eax,%eax
80104819:	74 15                	je     80104830 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010481b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010481e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5d                   	pop    %ebp
    release(&p->lock);
80104824:	e9 e7 0f 00 00       	jmp    80105810 <release>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	53                   	push   %ebx
80104834:	e8 d7 0f 00 00       	call   80105810 <release>
    kfree((char*)p);
80104839:	83 c4 10             	add    $0x10,%esp
8010483c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010483f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104842:	5b                   	pop    %ebx
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
    kfree((char*)p);
80104845:	e9 26 ef ff ff       	jmp    80103770 <kfree>
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104859:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104860:	00 00 00 
    wakeup(&p->nwrite);
80104863:	50                   	push   %eax
80104864:	e8 47 0b 00 00       	call   801053b0 <wakeup>
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	eb 99                	jmp    80104807 <pipeclose+0x37>
8010486e:	66 90                	xchg   %ax,%ax

80104870 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	56                   	push   %esi
80104875:	53                   	push   %ebx
80104876:	83 ec 28             	sub    $0x28,%esp
80104879:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010487c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010487f:	53                   	push   %ebx
80104880:	e8 eb 0f 00 00       	call   80105870 <acquire>
  for(i = 0; i < n; i++){
80104885:	83 c4 10             	add    $0x10,%esp
80104888:	85 ff                	test   %edi,%edi
8010488a:	0f 8e ce 00 00 00    	jle    8010495e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104890:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80104896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104899:	89 7d 10             	mov    %edi,0x10(%ebp)
8010489c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010489f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801048a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801048a5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048ab:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801048b1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048b7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801048bd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801048c0:	0f 85 b6 00 00 00    	jne    8010497c <pipewrite+0x10c>
801048c6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801048c9:	eb 3b                	jmp    80104906 <pipewrite+0x96>
801048cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801048d0:	e8 5b 03 00 00       	call   80104c30 <myproc>
801048d5:	8b 48 24             	mov    0x24(%eax),%ecx
801048d8:	85 c9                	test   %ecx,%ecx
801048da:	75 34                	jne    80104910 <pipewrite+0xa0>
      wakeup(&p->nread);
801048dc:	83 ec 0c             	sub    $0xc,%esp
801048df:	56                   	push   %esi
801048e0:	e8 cb 0a 00 00       	call   801053b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801048e5:	58                   	pop    %eax
801048e6:	5a                   	pop    %edx
801048e7:	53                   	push   %ebx
801048e8:	57                   	push   %edi
801048e9:	e8 02 0a 00 00       	call   801052f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801048ee:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801048f4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	05 00 02 00 00       	add    $0x200,%eax
80104902:	39 c2                	cmp    %eax,%edx
80104904:	75 2a                	jne    80104930 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80104906:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010490c:	85 c0                	test   %eax,%eax
8010490e:	75 c0                	jne    801048d0 <pipewrite+0x60>
        release(&p->lock);
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	53                   	push   %ebx
80104914:	e8 f7 0e 00 00       	call   80105810 <release>
        return -1;
80104919:	83 c4 10             	add    $0x10,%esp
8010491c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104924:	5b                   	pop    %ebx
80104925:	5e                   	pop    %esi
80104926:	5f                   	pop    %edi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104930:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104933:	8d 42 01             	lea    0x1(%edx),%eax
80104936:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010493c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010493f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80104945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104948:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010494c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104950:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104953:	39 c1                	cmp    %eax,%ecx
80104955:	0f 85 50 ff ff ff    	jne    801048ab <pipewrite+0x3b>
8010495b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010495e:	83 ec 0c             	sub    $0xc,%esp
80104961:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104967:	50                   	push   %eax
80104968:	e8 43 0a 00 00       	call   801053b0 <wakeup>
  release(&p->lock);
8010496d:	89 1c 24             	mov    %ebx,(%esp)
80104970:	e8 9b 0e 00 00       	call   80105810 <release>
  return n;
80104975:	83 c4 10             	add    $0x10,%esp
80104978:	89 f8                	mov    %edi,%eax
8010497a:	eb a5                	jmp    80104921 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010497c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010497f:	eb b2                	jmp    80104933 <pipewrite+0xc3>
80104981:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104988:	00 
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104990 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	83 ec 18             	sub    $0x18,%esp
80104999:	8b 75 08             	mov    0x8(%ebp),%esi
8010499c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010499f:	56                   	push   %esi
801049a0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801049a6:	e8 c5 0e 00 00       	call   80105870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801049ab:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801049b1:	83 c4 10             	add    $0x10,%esp
801049b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801049ba:	74 2f                	je     801049eb <piperead+0x5b>
801049bc:	eb 37                	jmp    801049f5 <piperead+0x65>
801049be:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801049c0:	e8 6b 02 00 00       	call   80104c30 <myproc>
801049c5:	8b 40 24             	mov    0x24(%eax),%eax
801049c8:	85 c0                	test   %eax,%eax
801049ca:	0f 85 80 00 00 00    	jne    80104a50 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801049d0:	83 ec 08             	sub    $0x8,%esp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	e8 16 09 00 00       	call   801052f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801049da:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801049e0:	83 c4 10             	add    $0x10,%esp
801049e3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801049e9:	75 0a                	jne    801049f5 <piperead+0x65>
801049eb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801049f1:	85 d2                	test   %edx,%edx
801049f3:	75 cb                	jne    801049c0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801049f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049f8:	31 db                	xor    %ebx,%ebx
801049fa:	85 c9                	test   %ecx,%ecx
801049fc:	7f 26                	jg     80104a24 <piperead+0x94>
801049fe:	eb 2c                	jmp    80104a2c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104a00:	8d 48 01             	lea    0x1(%eax),%ecx
80104a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80104a08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104a0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104a13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104a16:	83 c3 01             	add    $0x1,%ebx
80104a19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104a1c:	74 0e                	je     80104a2c <piperead+0x9c>
80104a1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80104a24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104a2a:	75 d4                	jne    80104a00 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104a2c:	83 ec 0c             	sub    $0xc,%esp
80104a2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104a35:	50                   	push   %eax
80104a36:	e8 75 09 00 00       	call   801053b0 <wakeup>
  release(&p->lock);
80104a3b:	89 34 24             	mov    %esi,(%esp)
80104a3e:	e8 cd 0d 00 00       	call   80105810 <release>
  return i;
80104a43:	83 c4 10             	add    $0x10,%esp
}
80104a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a49:	89 d8                	mov    %ebx,%eax
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5f                   	pop    %edi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret
      release(&p->lock);
80104a50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104a58:	56                   	push   %esi
80104a59:	e8 b2 0d 00 00       	call   80105810 <release>
      return -1;
80104a5e:	83 c4 10             	add    $0x10,%esp
}
80104a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a64:	89 d8                	mov    %ebx,%eax
80104a66:	5b                   	pop    %ebx
80104a67:	5e                   	pop    %esi
80104a68:	5f                   	pop    %edi
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret
80104a6b:	66 90                	xchg   %ax,%ax
80104a6d:	66 90                	xchg   %ax,%ax
80104a6f:	90                   	nop

80104a70 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a74:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
{
80104a79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104a7c:	68 a0 2f 11 80       	push   $0x80112fa0
80104a81:	e8 ea 0d 00 00       	call   80105870 <acquire>
80104a86:	83 c4 10             	add    $0x10,%esp
80104a89:	eb 10                	jmp    80104a9b <allocproc+0x2b>
80104a8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a90:	83 c3 7c             	add    $0x7c,%ebx
80104a93:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80104a99:	74 75                	je     80104b10 <allocproc+0xa0>
    if(p->state == UNUSED)
80104a9b:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a9e:	85 c0                	test   %eax,%eax
80104aa0:	75 ee                	jne    80104a90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104aa2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104aa7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104aaa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104ab1:	89 43 10             	mov    %eax,0x10(%ebx)
80104ab4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104ab7:	68 a0 2f 11 80       	push   $0x80112fa0
  p->pid = nextpid++;
80104abc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104ac2:	e8 49 0d 00 00       	call   80105810 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104ac7:	e8 64 ee ff ff       	call   80103930 <kalloc>
80104acc:	83 c4 10             	add    $0x10,%esp
80104acf:	89 43 08             	mov    %eax,0x8(%ebx)
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	74 53                	je     80104b29 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104ad6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104adc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104adf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104ae4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104ae7:	c7 40 14 22 6b 10 80 	movl   $0x80106b22,0x14(%eax)
  p->context = (struct context*)sp;
80104aee:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104af1:	6a 14                	push   $0x14
80104af3:	6a 00                	push   $0x0
80104af5:	50                   	push   %eax
80104af6:	e8 75 0e 00 00       	call   80105970 <memset>
  p->context->eip = (uint)forkret;
80104afb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80104afe:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104b01:	c7 40 10 40 4b 10 80 	movl   $0x80104b40,0x10(%eax)
}
80104b08:	89 d8                	mov    %ebx,%eax
80104b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b0d:	c9                   	leave
80104b0e:	c3                   	ret
80104b0f:	90                   	nop
  release(&ptable.lock);
80104b10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104b13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104b15:	68 a0 2f 11 80       	push   $0x80112fa0
80104b1a:	e8 f1 0c 00 00       	call   80105810 <release>
  return 0;
80104b1f:	83 c4 10             	add    $0x10,%esp
}
80104b22:	89 d8                	mov    %ebx,%eax
80104b24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b27:	c9                   	leave
80104b28:	c3                   	ret
    p->state = UNUSED;
80104b29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104b30:	31 db                	xor    %ebx,%ebx
80104b32:	eb ee                	jmp    80104b22 <allocproc+0xb2>
80104b34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3b:	00 
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104b46:	68 a0 2f 11 80       	push   $0x80112fa0
80104b4b:	e8 c0 0c 00 00       	call   80105810 <release>

  if (first) {
80104b50:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104b55:	83 c4 10             	add    $0x10,%esp
80104b58:	85 c0                	test   %eax,%eax
80104b5a:	75 04                	jne    80104b60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104b5c:	c9                   	leave
80104b5d:	c3                   	ret
80104b5e:	66 90                	xchg   %ax,%ax
    first = 0;
80104b60:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80104b67:	00 00 00 
    iinit(ROOTDEV);
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	6a 01                	push   $0x1
80104b6f:	e8 dc dc ff ff       	call   80102850 <iinit>
    initlog(ROOTDEV);
80104b74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b7b:	e8 f0 f3 ff ff       	call   80103f70 <initlog>
}
80104b80:	83 c4 10             	add    $0x10,%esp
80104b83:	c9                   	leave
80104b84:	c3                   	ret
80104b85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8c:	00 
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <pinit>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104b96:	68 96 86 10 80       	push   $0x80108696
80104b9b:	68 a0 2f 11 80       	push   $0x80112fa0
80104ba0:	e8 db 0a 00 00       	call   80105680 <initlock>
}
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	c9                   	leave
80104ba9:	c3                   	ret
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bb0 <mycpu>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bb5:	9c                   	pushf
80104bb6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bb7:	f6 c4 02             	test   $0x2,%ah
80104bba:	75 46                	jne    80104c02 <mycpu+0x52>
  apicid = lapicid();
80104bbc:	e8 df ef ff ff       	call   80103ba0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104bc1:	8b 35 04 2a 11 80    	mov    0x80112a04,%esi
80104bc7:	85 f6                	test   %esi,%esi
80104bc9:	7e 2a                	jle    80104bf5 <mycpu+0x45>
80104bcb:	31 d2                	xor    %edx,%edx
80104bcd:	eb 08                	jmp    80104bd7 <mycpu+0x27>
80104bcf:	90                   	nop
80104bd0:	83 c2 01             	add    $0x1,%edx
80104bd3:	39 f2                	cmp    %esi,%edx
80104bd5:	74 1e                	je     80104bf5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104bd7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104bdd:	0f b6 99 20 2a 11 80 	movzbl -0x7feed5e0(%ecx),%ebx
80104be4:	39 c3                	cmp    %eax,%ebx
80104be6:	75 e8                	jne    80104bd0 <mycpu+0x20>
}
80104be8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104beb:	8d 81 20 2a 11 80    	lea    -0x7feed5e0(%ecx),%eax
}
80104bf1:	5b                   	pop    %ebx
80104bf2:	5e                   	pop    %esi
80104bf3:	5d                   	pop    %ebp
80104bf4:	c3                   	ret
  panic("unknown apicid\n");
80104bf5:	83 ec 0c             	sub    $0xc,%esp
80104bf8:	68 9d 86 10 80       	push   $0x8010869d
80104bfd:	e8 3e b9 ff ff       	call   80100540 <panic>
    panic("mycpu called with interrupts enabled\n");
80104c02:	83 ec 0c             	sub    $0xc,%esp
80104c05:	68 68 8a 10 80       	push   $0x80108a68
80104c0a:	e8 31 b9 ff ff       	call   80100540 <panic>
80104c0f:	90                   	nop

80104c10 <cpuid>:
cpuid() {
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104c16:	e8 95 ff ff ff       	call   80104bb0 <mycpu>
}
80104c1b:	c9                   	leave
  return mycpu()-cpus;
80104c1c:	2d 20 2a 11 80       	sub    $0x80112a20,%eax
80104c21:	c1 f8 04             	sar    $0x4,%eax
80104c24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104c2a:	c3                   	ret
80104c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104c30 <myproc>:
myproc(void) {
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104c37:	e8 e4 0a 00 00       	call   80105720 <pushcli>
  c = mycpu();
80104c3c:	e8 6f ff ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
80104c41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104c47:	e8 24 0b 00 00       	call   80105770 <popcli>
}
80104c4c:	89 d8                	mov    %ebx,%eax
80104c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c51:	c9                   	leave
80104c52:	c3                   	ret
80104c53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c5a:	00 
80104c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104c60 <userinit>:
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104c67:	e8 04 fe ff ff       	call   80104a70 <allocproc>
80104c6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104c6e:	a3 d4 4e 11 80       	mov    %eax,0x80114ed4
  if((p->pgdir = setupkvm()) == 0)
80104c73:	e8 78 34 00 00       	call   801080f0 <setupkvm>
80104c78:	89 43 04             	mov    %eax,0x4(%ebx)
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	0f 84 bd 00 00 00    	je     80104d40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104c83:	83 ec 04             	sub    $0x4,%esp
80104c86:	68 2c 00 00 00       	push   $0x2c
80104c8b:	68 60 b4 10 80       	push   $0x8010b460
80104c90:	50                   	push   %eax
80104c91:	e8 3a 31 00 00       	call   80107dd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104c96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104c99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104c9f:	6a 4c                	push   $0x4c
80104ca1:	6a 00                	push   $0x0
80104ca3:	ff 73 18             	push   0x18(%ebx)
80104ca6:	e8 c5 0c 00 00       	call   80105970 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104cab:	8b 43 18             	mov    0x18(%ebx),%eax
80104cae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104cb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104cb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104cbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104cbf:	8b 43 18             	mov    0x18(%ebx),%eax
80104cc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104cc6:	8b 43 18             	mov    0x18(%ebx),%eax
80104cc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104ccd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104cd1:	8b 43 18             	mov    0x18(%ebx),%eax
80104cd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104cd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104cdc:	8b 43 18             	mov    0x18(%ebx),%eax
80104cdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104ce6:	8b 43 18             	mov    0x18(%ebx),%eax
80104ce9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104cf0:	8b 43 18             	mov    0x18(%ebx),%eax
80104cf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104cfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104cfd:	6a 10                	push   $0x10
80104cff:	68 c6 86 10 80       	push   $0x801086c6
80104d04:	50                   	push   %eax
80104d05:	e8 16 0e 00 00       	call   80105b20 <safestrcpy>
  p->cwd = namei("/");
80104d0a:	c7 04 24 cf 86 10 80 	movl   $0x801086cf,(%esp)
80104d11:	e8 3a e6 ff ff       	call   80103350 <namei>
80104d16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104d19:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104d20:	e8 4b 0b 00 00       	call   80105870 <acquire>
  p->state = RUNNABLE;
80104d25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104d2c:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104d33:	e8 d8 0a 00 00       	call   80105810 <release>
}
80104d38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d3b:	83 c4 10             	add    $0x10,%esp
80104d3e:	c9                   	leave
80104d3f:	c3                   	ret
    panic("userinit: out of memory?");
80104d40:	83 ec 0c             	sub    $0xc,%esp
80104d43:	68 ad 86 10 80       	push   $0x801086ad
80104d48:	e8 f3 b7 ff ff       	call   80100540 <panic>
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi

80104d50 <growproc>:
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104d58:	e8 c3 09 00 00       	call   80105720 <pushcli>
  c = mycpu();
80104d5d:	e8 4e fe ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
80104d62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d68:	e8 03 0a 00 00       	call   80105770 <popcli>
  sz = curproc->sz;
80104d6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104d6f:	85 f6                	test   %esi,%esi
80104d71:	7f 1d                	jg     80104d90 <growproc+0x40>
  } else if(n < 0){
80104d73:	75 3b                	jne    80104db0 <growproc+0x60>
  switchuvm(curproc);
80104d75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104d78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80104d7a:	53                   	push   %ebx
80104d7b:	e8 40 2f 00 00       	call   80107cc0 <switchuvm>
  return 0;
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d88:	5b                   	pop    %ebx
80104d89:	5e                   	pop    %esi
80104d8a:	5d                   	pop    %ebp
80104d8b:	c3                   	ret
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104d90:	83 ec 04             	sub    $0x4,%esp
80104d93:	01 c6                	add    %eax,%esi
80104d95:	56                   	push   %esi
80104d96:	50                   	push   %eax
80104d97:	ff 73 04             	push   0x4(%ebx)
80104d9a:	e8 81 31 00 00       	call   80107f20 <allocuvm>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	75 cf                	jne    80104d75 <growproc+0x25>
      return -1;
80104da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dab:	eb d8                	jmp    80104d85 <growproc+0x35>
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	01 c6                	add    %eax,%esi
80104db5:	56                   	push   %esi
80104db6:	50                   	push   %eax
80104db7:	ff 73 04             	push   0x4(%ebx)
80104dba:	e8 81 32 00 00       	call   80108040 <deallocuvm>
80104dbf:	83 c4 10             	add    $0x10,%esp
80104dc2:	85 c0                	test   %eax,%eax
80104dc4:	75 af                	jne    80104d75 <growproc+0x25>
80104dc6:	eb de                	jmp    80104da6 <growproc+0x56>
80104dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dcf:	00 

80104dd0 <fork>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104dd9:	e8 42 09 00 00       	call   80105720 <pushcli>
  c = mycpu();
80104dde:	e8 cd fd ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
80104de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104de9:	e8 82 09 00 00       	call   80105770 <popcli>
  if((np = allocproc()) == 0){
80104dee:	e8 7d fc ff ff       	call   80104a70 <allocproc>
80104df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104df6:	85 c0                	test   %eax,%eax
80104df8:	0f 84 d6 00 00 00    	je     80104ed4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104dfe:	83 ec 08             	sub    $0x8,%esp
80104e01:	ff 33                	push   (%ebx)
80104e03:	89 c7                	mov    %eax,%edi
80104e05:	ff 73 04             	push   0x4(%ebx)
80104e08:	e8 d3 33 00 00       	call   801081e0 <copyuvm>
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	89 47 04             	mov    %eax,0x4(%edi)
80104e13:	85 c0                	test   %eax,%eax
80104e15:	0f 84 9a 00 00 00    	je     80104eb5 <fork+0xe5>
  np->sz = curproc->sz;
80104e1b:	8b 03                	mov    (%ebx),%eax
80104e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104e20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104e22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104e25:	89 c8                	mov    %ecx,%eax
80104e27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104e2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80104e2f:	8b 73 18             	mov    0x18(%ebx),%esi
80104e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104e34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104e36:	8b 40 18             	mov    0x18(%eax),%eax
80104e39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104e44:	85 c0                	test   %eax,%eax
80104e46:	74 13                	je     80104e5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	50                   	push   %eax
80104e4c:	e8 3f d3 ff ff       	call   80102190 <filedup>
80104e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e54:	83 c4 10             	add    $0x10,%esp
80104e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104e5b:	83 c6 01             	add    $0x1,%esi
80104e5e:	83 fe 10             	cmp    $0x10,%esi
80104e61:	75 dd                	jne    80104e40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104e63:	83 ec 0c             	sub    $0xc,%esp
80104e66:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104e6c:	e8 cf db ff ff       	call   80102a40 <idup>
80104e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104e77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80104e7d:	6a 10                	push   $0x10
80104e7f:	53                   	push   %ebx
80104e80:	50                   	push   %eax
80104e81:	e8 9a 0c 00 00       	call   80105b20 <safestrcpy>
  pid = np->pid;
80104e86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104e89:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104e90:	e8 db 09 00 00       	call   80105870 <acquire>
  np->state = RUNNABLE;
80104e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104e9c:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80104ea3:	e8 68 09 00 00       	call   80105810 <release>
  return pid;
80104ea8:	83 c4 10             	add    $0x10,%esp
}
80104eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eae:	89 d8                	mov    %ebx,%eax
80104eb0:	5b                   	pop    %ebx
80104eb1:	5e                   	pop    %esi
80104eb2:	5f                   	pop    %edi
80104eb3:	5d                   	pop    %ebp
80104eb4:	c3                   	ret
    kfree(np->kstack);
80104eb5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104eb8:	83 ec 0c             	sub    $0xc,%esp
80104ebb:	ff 73 08             	push   0x8(%ebx)
80104ebe:	e8 ad e8 ff ff       	call   80103770 <kfree>
    np->kstack = 0;
80104ec3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104eca:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104ecd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104ed4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ed9:	eb d0                	jmp    80104eab <fork+0xdb>
80104edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104ee0 <scheduler>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104ee9:	e8 c2 fc ff ff       	call   80104bb0 <mycpu>
  c->proc = 0;
80104eee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104ef5:	00 00 00 
  struct cpu *c = mycpu();
80104ef8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104efa:	8d 78 04             	lea    0x4(%eax),%edi
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104f00:	fb                   	sti
    acquire(&ptable.lock);
80104f01:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f04:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
    acquire(&ptable.lock);
80104f09:	68 a0 2f 11 80       	push   $0x80112fa0
80104f0e:	e8 5d 09 00 00       	call   80105870 <acquire>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f1d:	00 
80104f1e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104f20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104f24:	75 33                	jne    80104f59 <scheduler+0x79>
      switchuvm(p);
80104f26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104f29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104f2f:	53                   	push   %ebx
80104f30:	e8 8b 2d 00 00       	call   80107cc0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104f35:	58                   	pop    %eax
80104f36:	5a                   	pop    %edx
80104f37:	ff 73 1c             	push   0x1c(%ebx)
80104f3a:	57                   	push   %edi
      p->state = RUNNING;
80104f3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104f42:	e8 34 0c 00 00       	call   80105b7b <swtch>
      switchkvm();
80104f47:	e8 64 2d 00 00       	call   80107cb0 <switchkvm>
      c->proc = 0;
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104f56:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f59:	83 c3 7c             	add    $0x7c,%ebx
80104f5c:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
80104f62:	75 bc                	jne    80104f20 <scheduler+0x40>
    release(&ptable.lock);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	68 a0 2f 11 80       	push   $0x80112fa0
80104f6c:	e8 9f 08 00 00       	call   80105810 <release>
    sti();
80104f71:	83 c4 10             	add    $0x10,%esp
80104f74:	eb 8a                	jmp    80104f00 <scheduler+0x20>
80104f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f7d:	00 
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <sched>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  pushcli();
80104f85:	e8 96 07 00 00       	call   80105720 <pushcli>
  c = mycpu();
80104f8a:	e8 21 fc ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
80104f8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f95:	e8 d6 07 00 00       	call   80105770 <popcli>
  if(!holding(&ptable.lock))
80104f9a:	83 ec 0c             	sub    $0xc,%esp
80104f9d:	68 a0 2f 11 80       	push   $0x80112fa0
80104fa2:	e8 29 08 00 00       	call   801057d0 <holding>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	74 4f                	je     80104ffd <sched+0x7d>
  if(mycpu()->ncli != 1)
80104fae:	e8 fd fb ff ff       	call   80104bb0 <mycpu>
80104fb3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80104fba:	75 68                	jne    80105024 <sched+0xa4>
  if(p->state == RUNNING)
80104fbc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104fc0:	74 55                	je     80105017 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fc2:	9c                   	pushf
80104fc3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fc4:	f6 c4 02             	test   $0x2,%ah
80104fc7:	75 41                	jne    8010500a <sched+0x8a>
  intena = mycpu()->intena;
80104fc9:	e8 e2 fb ff ff       	call   80104bb0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104fce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104fd1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104fd7:	e8 d4 fb ff ff       	call   80104bb0 <mycpu>
80104fdc:	83 ec 08             	sub    $0x8,%esp
80104fdf:	ff 70 04             	push   0x4(%eax)
80104fe2:	53                   	push   %ebx
80104fe3:	e8 93 0b 00 00       	call   80105b7b <swtch>
  mycpu()->intena = intena;
80104fe8:	e8 c3 fb ff ff       	call   80104bb0 <mycpu>
}
80104fed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104ff0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff9:	5b                   	pop    %ebx
80104ffa:	5e                   	pop    %esi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret
    panic("sched ptable.lock");
80104ffd:	83 ec 0c             	sub    $0xc,%esp
80105000:	68 d1 86 10 80       	push   $0x801086d1
80105005:	e8 36 b5 ff ff       	call   80100540 <panic>
    panic("sched interruptible");
8010500a:	83 ec 0c             	sub    $0xc,%esp
8010500d:	68 fd 86 10 80       	push   $0x801086fd
80105012:	e8 29 b5 ff ff       	call   80100540 <panic>
    panic("sched running");
80105017:	83 ec 0c             	sub    $0xc,%esp
8010501a:	68 ef 86 10 80       	push   $0x801086ef
8010501f:	e8 1c b5 ff ff       	call   80100540 <panic>
    panic("sched locks");
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	68 e3 86 10 80       	push   $0x801086e3
8010502c:	e8 0f b5 ff ff       	call   80100540 <panic>
80105031:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105038:	00 
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105040 <exit>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105049:	e8 e2 fb ff ff       	call   80104c30 <myproc>
  if(curproc == initproc)
8010504e:	39 05 d4 4e 11 80    	cmp    %eax,0x80114ed4
80105054:	0f 84 fd 00 00 00    	je     80105157 <exit+0x117>
8010505a:	89 c3                	mov    %eax,%ebx
8010505c:	8d 70 28             	lea    0x28(%eax),%esi
8010505f:	8d 78 68             	lea    0x68(%eax),%edi
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105068:	8b 06                	mov    (%esi),%eax
8010506a:	85 c0                	test   %eax,%eax
8010506c:	74 12                	je     80105080 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010506e:	83 ec 0c             	sub    $0xc,%esp
80105071:	50                   	push   %eax
80105072:	e8 69 d1 ff ff       	call   801021e0 <fileclose>
      curproc->ofile[fd] = 0;
80105077:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010507d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105080:	83 c6 04             	add    $0x4,%esi
80105083:	39 f7                	cmp    %esi,%edi
80105085:	75 e1                	jne    80105068 <exit+0x28>
  begin_op();
80105087:	e8 84 ef ff ff       	call   80104010 <begin_op>
  iput(curproc->cwd);
8010508c:	83 ec 0c             	sub    $0xc,%esp
8010508f:	ff 73 68             	push   0x68(%ebx)
80105092:	e8 09 db ff ff       	call   80102ba0 <iput>
  end_op();
80105097:	e8 e4 ef ff ff       	call   80104080 <end_op>
  curproc->cwd = 0;
8010509c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801050a3:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
801050aa:	e8 c1 07 00 00       	call   80105870 <acquire>
  wakeup1(curproc->parent);
801050af:	8b 53 14             	mov    0x14(%ebx),%edx
801050b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050b5:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
801050ba:	eb 0e                	jmp    801050ca <exit+0x8a>
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050c0:	83 c0 7c             	add    $0x7c,%eax
801050c3:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801050c8:	74 1c                	je     801050e6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801050ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801050ce:	75 f0                	jne    801050c0 <exit+0x80>
801050d0:	3b 50 20             	cmp    0x20(%eax),%edx
801050d3:	75 eb                	jne    801050c0 <exit+0x80>
      p->state = RUNNABLE;
801050d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801050dc:	83 c0 7c             	add    $0x7c,%eax
801050df:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801050e4:	75 e4                	jne    801050ca <exit+0x8a>
      p->parent = initproc;
801050e6:	8b 0d d4 4e 11 80    	mov    0x80114ed4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050ec:	ba d4 2f 11 80       	mov    $0x80112fd4,%edx
801050f1:	eb 10                	jmp    80105103 <exit+0xc3>
801050f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801050f8:	83 c2 7c             	add    $0x7c,%edx
801050fb:	81 fa d4 4e 11 80    	cmp    $0x80114ed4,%edx
80105101:	74 3b                	je     8010513e <exit+0xfe>
    if(p->parent == curproc){
80105103:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105106:	75 f0                	jne    801050f8 <exit+0xb8>
      if(p->state == ZOMBIE)
80105108:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010510c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010510f:	75 e7                	jne    801050f8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105111:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
80105116:	eb 12                	jmp    8010512a <exit+0xea>
80105118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010511f:	00 
80105120:	83 c0 7c             	add    $0x7c,%eax
80105123:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80105128:	74 ce                	je     801050f8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010512a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010512e:	75 f0                	jne    80105120 <exit+0xe0>
80105130:	3b 48 20             	cmp    0x20(%eax),%ecx
80105133:	75 eb                	jne    80105120 <exit+0xe0>
      p->state = RUNNABLE;
80105135:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010513c:	eb e2                	jmp    80105120 <exit+0xe0>
  curproc->state = ZOMBIE;
8010513e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105145:	e8 36 fe ff ff       	call   80104f80 <sched>
  panic("zombie exit");
8010514a:	83 ec 0c             	sub    $0xc,%esp
8010514d:	68 1e 87 10 80       	push   $0x8010871e
80105152:	e8 e9 b3 ff ff       	call   80100540 <panic>
    panic("init exiting");
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	68 11 87 10 80       	push   $0x80108711
8010515f:	e8 dc b3 ff ff       	call   80100540 <panic>
80105164:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010516b:	00 
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <wait>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
  pushcli();
80105175:	e8 a6 05 00 00       	call   80105720 <pushcli>
  c = mycpu();
8010517a:	e8 31 fa ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
8010517f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105185:	e8 e6 05 00 00       	call   80105770 <popcli>
  acquire(&ptable.lock);
8010518a:	83 ec 0c             	sub    $0xc,%esp
8010518d:	68 a0 2f 11 80       	push   $0x80112fa0
80105192:	e8 d9 06 00 00       	call   80105870 <acquire>
80105197:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010519a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010519c:	bb d4 2f 11 80       	mov    $0x80112fd4,%ebx
801051a1:	eb 10                	jmp    801051b3 <wait+0x43>
801051a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801051a8:	83 c3 7c             	add    $0x7c,%ebx
801051ab:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
801051b1:	74 1b                	je     801051ce <wait+0x5e>
      if(p->parent != curproc)
801051b3:	39 73 14             	cmp    %esi,0x14(%ebx)
801051b6:	75 f0                	jne    801051a8 <wait+0x38>
      if(p->state == ZOMBIE){
801051b8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801051bc:	74 62                	je     80105220 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051be:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801051c1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051c6:	81 fb d4 4e 11 80    	cmp    $0x80114ed4,%ebx
801051cc:	75 e5                	jne    801051b3 <wait+0x43>
    if(!havekids || curproc->killed){
801051ce:	85 c0                	test   %eax,%eax
801051d0:	0f 84 a0 00 00 00    	je     80105276 <wait+0x106>
801051d6:	8b 46 24             	mov    0x24(%esi),%eax
801051d9:	85 c0                	test   %eax,%eax
801051db:	0f 85 95 00 00 00    	jne    80105276 <wait+0x106>
  pushcli();
801051e1:	e8 3a 05 00 00       	call   80105720 <pushcli>
  c = mycpu();
801051e6:	e8 c5 f9 ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
801051eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801051f1:	e8 7a 05 00 00       	call   80105770 <popcli>
  if(p == 0)
801051f6:	85 db                	test   %ebx,%ebx
801051f8:	0f 84 8f 00 00 00    	je     8010528d <wait+0x11d>
  p->chan = chan;
801051fe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105201:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105208:	e8 73 fd ff ff       	call   80104f80 <sched>
  p->chan = 0;
8010520d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105214:	eb 84                	jmp    8010519a <wait+0x2a>
80105216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010521d:	00 
8010521e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80105220:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105223:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105226:	ff 73 08             	push   0x8(%ebx)
80105229:	e8 42 e5 ff ff       	call   80103770 <kfree>
        p->kstack = 0;
8010522e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105235:	5a                   	pop    %edx
80105236:	ff 73 04             	push   0x4(%ebx)
80105239:	e8 32 2e 00 00       	call   80108070 <freevm>
        p->pid = 0;
8010523e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105245:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010524c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105250:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105257:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010525e:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
80105265:	e8 a6 05 00 00       	call   80105810 <release>
        return pid;
8010526a:	83 c4 10             	add    $0x10,%esp
}
8010526d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105270:	89 f0                	mov    %esi,%eax
80105272:	5b                   	pop    %ebx
80105273:	5e                   	pop    %esi
80105274:	5d                   	pop    %ebp
80105275:	c3                   	ret
      release(&ptable.lock);
80105276:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105279:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010527e:	68 a0 2f 11 80       	push   $0x80112fa0
80105283:	e8 88 05 00 00       	call   80105810 <release>
      return -1;
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	eb e0                	jmp    8010526d <wait+0xfd>
    panic("sleep");
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	68 2a 87 10 80       	push   $0x8010872a
80105295:	e8 a6 b2 ff ff       	call   80100540 <panic>
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052a0 <yield>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	53                   	push   %ebx
801052a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801052a7:	68 a0 2f 11 80       	push   $0x80112fa0
801052ac:	e8 bf 05 00 00       	call   80105870 <acquire>
  pushcli();
801052b1:	e8 6a 04 00 00       	call   80105720 <pushcli>
  c = mycpu();
801052b6:	e8 f5 f8 ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
801052bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801052c1:	e8 aa 04 00 00       	call   80105770 <popcli>
  myproc()->state = RUNNABLE;
801052c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801052cd:	e8 ae fc ff ff       	call   80104f80 <sched>
  release(&ptable.lock);
801052d2:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
801052d9:	e8 32 05 00 00       	call   80105810 <release>
}
801052de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	c9                   	leave
801052e5:	c3                   	ret
801052e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052ed:	00 
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <sleep>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
801052f6:	83 ec 0c             	sub    $0xc,%esp
801052f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801052fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801052ff:	e8 1c 04 00 00       	call   80105720 <pushcli>
  c = mycpu();
80105304:	e8 a7 f8 ff ff       	call   80104bb0 <mycpu>
  p = c->proc;
80105309:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010530f:	e8 5c 04 00 00       	call   80105770 <popcli>
  if(p == 0)
80105314:	85 db                	test   %ebx,%ebx
80105316:	0f 84 87 00 00 00    	je     801053a3 <sleep+0xb3>
  if(lk == 0)
8010531c:	85 f6                	test   %esi,%esi
8010531e:	74 76                	je     80105396 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105320:	81 fe a0 2f 11 80    	cmp    $0x80112fa0,%esi
80105326:	74 50                	je     80105378 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	68 a0 2f 11 80       	push   $0x80112fa0
80105330:	e8 3b 05 00 00       	call   80105870 <acquire>
    release(lk);
80105335:	89 34 24             	mov    %esi,(%esp)
80105338:	e8 d3 04 00 00       	call   80105810 <release>
  p->chan = chan;
8010533d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105340:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105347:	e8 34 fc ff ff       	call   80104f80 <sched>
  p->chan = 0;
8010534c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105353:	c7 04 24 a0 2f 11 80 	movl   $0x80112fa0,(%esp)
8010535a:	e8 b1 04 00 00       	call   80105810 <release>
    acquire(lk);
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105365:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105368:	5b                   	pop    %ebx
80105369:	5e                   	pop    %esi
8010536a:	5f                   	pop    %edi
8010536b:	5d                   	pop    %ebp
    acquire(lk);
8010536c:	e9 ff 04 00 00       	jmp    80105870 <acquire>
80105371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105378:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010537b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105382:	e8 f9 fb ff ff       	call   80104f80 <sched>
  p->chan = 0;
80105387:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010538e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105391:	5b                   	pop    %ebx
80105392:	5e                   	pop    %esi
80105393:	5f                   	pop    %edi
80105394:	5d                   	pop    %ebp
80105395:	c3                   	ret
    panic("sleep without lk");
80105396:	83 ec 0c             	sub    $0xc,%esp
80105399:	68 30 87 10 80       	push   $0x80108730
8010539e:	e8 9d b1 ff ff       	call   80100540 <panic>
    panic("sleep");
801053a3:	83 ec 0c             	sub    $0xc,%esp
801053a6:	68 2a 87 10 80       	push   $0x8010872a
801053ab:	e8 90 b1 ff ff       	call   80100540 <panic>

801053b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	53                   	push   %ebx
801053b4:	83 ec 10             	sub    $0x10,%esp
801053b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801053ba:	68 a0 2f 11 80       	push   $0x80112fa0
801053bf:	e8 ac 04 00 00       	call   80105870 <acquire>
801053c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053c7:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
801053cc:	eb 0c                	jmp    801053da <wakeup+0x2a>
801053ce:	66 90                	xchg   %ax,%ax
801053d0:	83 c0 7c             	add    $0x7c,%eax
801053d3:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801053d8:	74 1c                	je     801053f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801053da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801053de:	75 f0                	jne    801053d0 <wakeup+0x20>
801053e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801053e3:	75 eb                	jne    801053d0 <wakeup+0x20>
      p->state = RUNNABLE;
801053e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053ec:	83 c0 7c             	add    $0x7c,%eax
801053ef:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
801053f4:	75 e4                	jne    801053da <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801053f6:	c7 45 08 a0 2f 11 80 	movl   $0x80112fa0,0x8(%ebp)
}
801053fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105400:	c9                   	leave
  release(&ptable.lock);
80105401:	e9 0a 04 00 00       	jmp    80105810 <release>
80105406:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010540d:	00 
8010540e:	66 90                	xchg   %ax,%ax

80105410 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
80105414:	83 ec 10             	sub    $0x10,%esp
80105417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010541a:	68 a0 2f 11 80       	push   $0x80112fa0
8010541f:	e8 4c 04 00 00       	call   80105870 <acquire>
80105424:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105427:	b8 d4 2f 11 80       	mov    $0x80112fd4,%eax
8010542c:	eb 0c                	jmp    8010543a <kill+0x2a>
8010542e:	66 90                	xchg   %ax,%ax
80105430:	83 c0 7c             	add    $0x7c,%eax
80105433:	3d d4 4e 11 80       	cmp    $0x80114ed4,%eax
80105438:	74 36                	je     80105470 <kill+0x60>
    if(p->pid == pid){
8010543a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010543d:	75 f1                	jne    80105430 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010543f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80105443:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010544a:	75 07                	jne    80105453 <kill+0x43>
        p->state = RUNNABLE;
8010544c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80105453:	83 ec 0c             	sub    $0xc,%esp
80105456:	68 a0 2f 11 80       	push   $0x80112fa0
8010545b:	e8 b0 03 00 00       	call   80105810 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80105460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	31 c0                	xor    %eax,%eax
}
80105468:	c9                   	leave
80105469:	c3                   	ret
8010546a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	68 a0 2f 11 80       	push   $0x80112fa0
80105478:	e8 93 03 00 00       	call   80105810 <release>
}
8010547d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105488:	c9                   	leave
80105489:	c3                   	ret
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105498:	53                   	push   %ebx
80105499:	bb 40 30 11 80       	mov    $0x80113040,%ebx
8010549e:	83 ec 3c             	sub    $0x3c,%esp
801054a1:	eb 24                	jmp    801054c7 <procdump+0x37>
801054a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	68 ef 88 10 80       	push   $0x801088ef
801054b0:	e8 7b b7 ff ff       	call   80100c30 <cprintf>
801054b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054b8:	83 c3 7c             	add    $0x7c,%ebx
801054bb:	81 fb 40 4f 11 80    	cmp    $0x80114f40,%ebx
801054c1:	0f 84 81 00 00 00    	je     80105548 <procdump+0xb8>
    if(p->state == UNUSED)
801054c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801054ca:	85 c0                	test   %eax,%eax
801054cc:	74 ea                	je     801054b8 <procdump+0x28>
      state = "???";
801054ce:	ba 41 87 10 80       	mov    $0x80108741,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801054d3:	83 f8 05             	cmp    $0x5,%eax
801054d6:	77 11                	ja     801054e9 <procdump+0x59>
801054d8:	8b 14 85 80 8d 10 80 	mov    -0x7fef7280(,%eax,4),%edx
      state = "???";
801054df:	b8 41 87 10 80       	mov    $0x80108741,%eax
801054e4:	85 d2                	test   %edx,%edx
801054e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801054e9:	53                   	push   %ebx
801054ea:	52                   	push   %edx
801054eb:	ff 73 a4             	push   -0x5c(%ebx)
801054ee:	68 45 87 10 80       	push   $0x80108745
801054f3:	e8 38 b7 ff ff       	call   80100c30 <cprintf>
    if(p->state == SLEEPING){
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801054ff:	75 a7                	jne    801054a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105501:	83 ec 08             	sub    $0x8,%esp
80105504:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105507:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010550a:	50                   	push   %eax
8010550b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010550e:	8b 40 0c             	mov    0xc(%eax),%eax
80105511:	83 c0 08             	add    $0x8,%eax
80105514:	50                   	push   %eax
80105515:	e8 86 01 00 00       	call   801056a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	8b 17                	mov    (%edi),%edx
80105522:	85 d2                	test   %edx,%edx
80105524:	74 82                	je     801054a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105526:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105529:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010552c:	52                   	push   %edx
8010552d:	68 81 84 10 80       	push   $0x80108481
80105532:	e8 f9 b6 ff ff       	call   80100c30 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105537:	83 c4 10             	add    $0x10,%esp
8010553a:	39 f7                	cmp    %esi,%edi
8010553c:	75 e2                	jne    80105520 <procdump+0x90>
8010553e:	e9 65 ff ff ff       	jmp    801054a8 <procdump+0x18>
80105543:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80105548:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010554b:	5b                   	pop    %ebx
8010554c:	5e                   	pop    %esi
8010554d:	5f                   	pop    %edi
8010554e:	5d                   	pop    %ebp
8010554f:	c3                   	ret

80105550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	53                   	push   %ebx
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010555a:	68 78 87 10 80       	push   $0x80108778
8010555f:	8d 43 04             	lea    0x4(%ebx),%eax
80105562:	50                   	push   %eax
80105563:	e8 18 01 00 00       	call   80105680 <initlock>
  lk->name = name;
80105568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010556b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010557b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010557e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105581:	c9                   	leave
80105582:	c3                   	ret
80105583:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010558a:	00 
8010558b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105598:	8d 73 04             	lea    0x4(%ebx),%esi
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	56                   	push   %esi
8010559f:	e8 cc 02 00 00       	call   80105870 <acquire>
  while (lk->locked) {
801055a4:	8b 13                	mov    (%ebx),%edx
801055a6:	83 c4 10             	add    $0x10,%esp
801055a9:	85 d2                	test   %edx,%edx
801055ab:	74 16                	je     801055c3 <acquiresleep+0x33>
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
801055b5:	e8 36 fd ff ff       	call   801052f0 <sleep>
  while (lk->locked) {
801055ba:	8b 03                	mov    (%ebx),%eax
801055bc:	83 c4 10             	add    $0x10,%esp
801055bf:	85 c0                	test   %eax,%eax
801055c1:	75 ed                	jne    801055b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801055c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801055c9:	e8 62 f6 ff ff       	call   80104c30 <myproc>
801055ce:	8b 40 10             	mov    0x10(%eax),%eax
801055d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801055d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801055d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055da:	5b                   	pop    %ebx
801055db:	5e                   	pop    %esi
801055dc:	5d                   	pop    %ebp
  release(&lk->lk);
801055dd:	e9 2e 02 00 00       	jmp    80105810 <release>
801055e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055e9:	00 
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
801055f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801055f8:	8d 73 04             	lea    0x4(%ebx),%esi
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	56                   	push   %esi
801055ff:	e8 6c 02 00 00       	call   80105870 <acquire>
  lk->locked = 0;
80105604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010560a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105611:	89 1c 24             	mov    %ebx,(%esp)
80105614:	e8 97 fd ff ff       	call   801053b0 <wakeup>
  release(&lk->lk);
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010561f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105622:	5b                   	pop    %ebx
80105623:	5e                   	pop    %esi
80105624:	5d                   	pop    %ebp
  release(&lk->lk);
80105625:	e9 e6 01 00 00       	jmp    80105810 <release>
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	57                   	push   %edi
80105634:	31 ff                	xor    %edi,%edi
80105636:	56                   	push   %esi
80105637:	53                   	push   %ebx
80105638:	83 ec 18             	sub    $0x18,%esp
8010563b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010563e:	8d 73 04             	lea    0x4(%ebx),%esi
80105641:	56                   	push   %esi
80105642:	e8 29 02 00 00       	call   80105870 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105647:	8b 03                	mov    (%ebx),%eax
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	75 18                	jne    80105668 <holdingsleep+0x38>
  release(&lk->lk);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	56                   	push   %esi
80105654:	e8 b7 01 00 00       	call   80105810 <release>
  return r;
}
80105659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010565c:	89 f8                	mov    %edi,%eax
8010565e:	5b                   	pop    %ebx
8010565f:	5e                   	pop    %esi
80105660:	5f                   	pop    %edi
80105661:	5d                   	pop    %ebp
80105662:	c3                   	ret
80105663:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80105668:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010566b:	e8 c0 f5 ff ff       	call   80104c30 <myproc>
80105670:	39 58 10             	cmp    %ebx,0x10(%eax)
80105673:	0f 94 c0             	sete   %al
80105676:	0f b6 c0             	movzbl %al,%eax
80105679:	89 c7                	mov    %eax,%edi
8010567b:	eb d3                	jmp    80105650 <holdingsleep+0x20>
8010567d:	66 90                	xchg   %ax,%ax
8010567f:	90                   	nop

80105680 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105686:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010568f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105692:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret
8010569b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801056a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	8b 45 08             	mov    0x8(%ebp),%eax
801056a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801056aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056ad:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801056b2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801056b7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056bc:	76 10                	jbe    801056ce <getcallerpcs+0x2e>
801056be:	eb 28                	jmp    801056e8 <getcallerpcs+0x48>
801056c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801056c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801056cc:	77 1a                	ja     801056e8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801056d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801056d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801056d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801056d9:	83 f8 0a             	cmp    $0xa,%eax
801056dc:	75 e2                	jne    801056c0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801056de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e1:	c9                   	leave
801056e2:	c3                   	ret
801056e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801056e8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801056eb:	83 c1 28             	add    $0x28,%ecx
801056ee:	89 ca                	mov    %ecx,%edx
801056f0:	29 c2                	sub    %eax,%edx
801056f2:	83 e2 04             	and    $0x4,%edx
801056f5:	74 11                	je     80105708 <getcallerpcs+0x68>
    pcs[i] = 0;
801056f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056fd:	83 c0 04             	add    $0x4,%eax
80105700:	39 c1                	cmp    %eax,%ecx
80105702:	74 da                	je     801056de <getcallerpcs+0x3e>
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80105708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010570e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80105711:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80105718:	39 c1                	cmp    %eax,%ecx
8010571a:	75 ec                	jne    80105708 <getcallerpcs+0x68>
8010571c:	eb c0                	jmp    801056de <getcallerpcs+0x3e>
8010571e:	66 90                	xchg   %ax,%ax

80105720 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	53                   	push   %ebx
80105724:	83 ec 04             	sub    $0x4,%esp
80105727:	9c                   	pushf
80105728:	5b                   	pop    %ebx
  asm volatile("cli");
80105729:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010572a:	e8 81 f4 ff ff       	call   80104bb0 <mycpu>
8010572f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105735:	85 c0                	test   %eax,%eax
80105737:	74 17                	je     80105750 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105739:	e8 72 f4 ff ff       	call   80104bb0 <mycpu>
8010573e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105748:	c9                   	leave
80105749:	c3                   	ret
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105750:	e8 5b f4 ff ff       	call   80104bb0 <mycpu>
80105755:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010575b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105761:	eb d6                	jmp    80105739 <pushcli+0x19>
80105763:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010576a:	00 
8010576b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105770 <popcli>:

void
popcli(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105776:	9c                   	pushf
80105777:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105778:	f6 c4 02             	test   $0x2,%ah
8010577b:	75 35                	jne    801057b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010577d:	e8 2e f4 ff ff       	call   80104bb0 <mycpu>
80105782:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105789:	78 34                	js     801057bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010578b:	e8 20 f4 ff ff       	call   80104bb0 <mycpu>
80105790:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105796:	85 d2                	test   %edx,%edx
80105798:	74 06                	je     801057a0 <popcli+0x30>
    sti();
}
8010579a:	c9                   	leave
8010579b:	c3                   	ret
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801057a0:	e8 0b f4 ff ff       	call   80104bb0 <mycpu>
801057a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801057ab:	85 c0                	test   %eax,%eax
801057ad:	74 eb                	je     8010579a <popcli+0x2a>
  asm volatile("sti");
801057af:	fb                   	sti
}
801057b0:	c9                   	leave
801057b1:	c3                   	ret
    panic("popcli - interruptible");
801057b2:	83 ec 0c             	sub    $0xc,%esp
801057b5:	68 83 87 10 80       	push   $0x80108783
801057ba:	e8 81 ad ff ff       	call   80100540 <panic>
    panic("popcli");
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	68 9a 87 10 80       	push   $0x8010879a
801057c7:	e8 74 ad ff ff       	call   80100540 <panic>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <holding>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	8b 75 08             	mov    0x8(%ebp),%esi
801057d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801057da:	e8 41 ff ff ff       	call   80105720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801057df:	8b 06                	mov    (%esi),%eax
801057e1:	85 c0                	test   %eax,%eax
801057e3:	75 0b                	jne    801057f0 <holding+0x20>
  popcli();
801057e5:	e8 86 ff ff ff       	call   80105770 <popcli>
}
801057ea:	89 d8                	mov    %ebx,%eax
801057ec:	5b                   	pop    %ebx
801057ed:	5e                   	pop    %esi
801057ee:	5d                   	pop    %ebp
801057ef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801057f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801057f3:	e8 b8 f3 ff ff       	call   80104bb0 <mycpu>
801057f8:	39 c3                	cmp    %eax,%ebx
801057fa:	0f 94 c3             	sete   %bl
  popcli();
801057fd:	e8 6e ff ff ff       	call   80105770 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105802:	0f b6 db             	movzbl %bl,%ebx
}
80105805:	89 d8                	mov    %ebx,%eax
80105807:	5b                   	pop    %ebx
80105808:	5e                   	pop    %esi
80105809:	5d                   	pop    %ebp
8010580a:	c3                   	ret
8010580b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105810 <release>:
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	53                   	push   %ebx
80105815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105818:	e8 03 ff ff ff       	call   80105720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010581d:	8b 03                	mov    (%ebx),%eax
8010581f:	85 c0                	test   %eax,%eax
80105821:	75 15                	jne    80105838 <release+0x28>
  popcli();
80105823:	e8 48 ff ff ff       	call   80105770 <popcli>
    panic("release");
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	68 a1 87 10 80       	push   $0x801087a1
80105830:	e8 0b ad ff ff       	call   80100540 <panic>
80105835:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105838:	8b 73 08             	mov    0x8(%ebx),%esi
8010583b:	e8 70 f3 ff ff       	call   80104bb0 <mycpu>
80105840:	39 c6                	cmp    %eax,%esi
80105842:	75 df                	jne    80105823 <release+0x13>
  popcli();
80105844:	e8 27 ff ff ff       	call   80105770 <popcli>
  lk->pcs[0] = 0;
80105849:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105850:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105857:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010585c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105862:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105865:	5b                   	pop    %ebx
80105866:	5e                   	pop    %esi
80105867:	5d                   	pop    %ebp
  popcli();
80105868:	e9 03 ff ff ff       	jmp    80105770 <popcli>
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <acquire>:
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	53                   	push   %ebx
80105874:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105877:	e8 a4 fe ff ff       	call   80105720 <pushcli>
  if(holding(lk))
8010587c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010587f:	e8 9c fe ff ff       	call   80105720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105884:	8b 03                	mov    (%ebx),%eax
80105886:	85 c0                	test   %eax,%eax
80105888:	0f 85 b2 00 00 00    	jne    80105940 <acquire+0xd0>
  popcli();
8010588e:	e8 dd fe ff ff       	call   80105770 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105893:	b9 01 00 00 00       	mov    $0x1,%ecx
80105898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589f:	00 
  while(xchg(&lk->locked, 1) != 0)
801058a0:	8b 55 08             	mov    0x8(%ebp),%edx
801058a3:	89 c8                	mov    %ecx,%eax
801058a5:	f0 87 02             	lock xchg %eax,(%edx)
801058a8:	85 c0                	test   %eax,%eax
801058aa:	75 f4                	jne    801058a0 <acquire+0x30>
  __sync_synchronize();
801058ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801058b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801058b4:	e8 f7 f2 ff ff       	call   80104bb0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801058b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801058bc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801058be:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801058c1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801058c7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801058cc:	77 32                	ja     80105900 <acquire+0x90>
  ebp = (uint*)v - 2;
801058ce:	89 e8                	mov    %ebp,%eax
801058d0:	eb 14                	jmp    801058e6 <acquire+0x76>
801058d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801058d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801058de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801058e4:	77 1a                	ja     80105900 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801058e6:	8b 58 04             	mov    0x4(%eax),%ebx
801058e9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801058ed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801058f0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801058f2:	83 fa 0a             	cmp    $0xa,%edx
801058f5:	75 e1                	jne    801058d8 <acquire+0x68>
}
801058f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058fa:	c9                   	leave
801058fb:	c3                   	ret
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105900:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80105904:	83 c1 34             	add    $0x34,%ecx
80105907:	89 ca                	mov    %ecx,%edx
80105909:	29 c2                	sub    %eax,%edx
8010590b:	83 e2 04             	and    $0x4,%edx
8010590e:	74 10                	je     80105920 <acquire+0xb0>
    pcs[i] = 0;
80105910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105916:	83 c0 04             	add    $0x4,%eax
80105919:	39 c1                	cmp    %eax,%ecx
8010591b:	74 da                	je     801058f7 <acquire+0x87>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105926:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80105929:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80105930:	39 c1                	cmp    %eax,%ecx
80105932:	75 ec                	jne    80105920 <acquire+0xb0>
80105934:	eb c1                	jmp    801058f7 <acquire+0x87>
80105936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593d:	00 
8010593e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80105940:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105943:	e8 68 f2 ff ff       	call   80104bb0 <mycpu>
80105948:	39 c3                	cmp    %eax,%ebx
8010594a:	0f 85 3e ff ff ff    	jne    8010588e <acquire+0x1e>
  popcli();
80105950:	e8 1b fe ff ff       	call   80105770 <popcli>
    panic("acquire");
80105955:	83 ec 0c             	sub    $0xc,%esp
80105958:	68 a9 87 10 80       	push   $0x801087a9
8010595d:	e8 de ab ff ff       	call   80100540 <panic>
80105962:	66 90                	xchg   %ax,%ax
80105964:	66 90                	xchg   %ax,%ax
80105966:	66 90                	xchg   %ax,%ax
80105968:	66 90                	xchg   %ax,%ax
8010596a:	66 90                	xchg   %ax,%ax
8010596c:	66 90                	xchg   %ax,%ax
8010596e:	66 90                	xchg   %ax,%ax

80105970 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	8b 55 08             	mov    0x8(%ebp),%edx
80105977:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010597a:	89 d0                	mov    %edx,%eax
8010597c:	09 c8                	or     %ecx,%eax
8010597e:	a8 03                	test   $0x3,%al
80105980:	75 1e                	jne    801059a0 <memset+0x30>
    c &= 0xFF;
80105982:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105986:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80105989:	89 d7                	mov    %edx,%edi
8010598b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80105991:	fc                   	cld
80105992:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105994:	8b 7d fc             	mov    -0x4(%ebp),%edi
80105997:	89 d0                	mov    %edx,%eax
80105999:	c9                   	leave
8010599a:	c3                   	ret
8010599b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801059a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a3:	89 d7                	mov    %edx,%edi
801059a5:	fc                   	cld
801059a6:	f3 aa                	rep stos %al,%es:(%edi)
801059a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801059ab:	89 d0                	mov    %edx,%eax
801059ad:	c9                   	leave
801059ae:	c3                   	ret
801059af:	90                   	nop

801059b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	56                   	push   %esi
801059b4:	8b 75 10             	mov    0x10(%ebp),%esi
801059b7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ba:	53                   	push   %ebx
801059bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801059be:	85 f6                	test   %esi,%esi
801059c0:	74 2e                	je     801059f0 <memcmp+0x40>
801059c2:	01 c6                	add    %eax,%esi
801059c4:	eb 14                	jmp    801059da <memcmp+0x2a>
801059c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059cd:	00 
801059ce:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801059d0:	83 c0 01             	add    $0x1,%eax
801059d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801059d6:	39 f0                	cmp    %esi,%eax
801059d8:	74 16                	je     801059f0 <memcmp+0x40>
    if(*s1 != *s2)
801059da:	0f b6 08             	movzbl (%eax),%ecx
801059dd:	0f b6 1a             	movzbl (%edx),%ebx
801059e0:	38 d9                	cmp    %bl,%cl
801059e2:	74 ec                	je     801059d0 <memcmp+0x20>
      return *s1 - *s2;
801059e4:	0f b6 c1             	movzbl %cl,%eax
801059e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801059e9:	5b                   	pop    %ebx
801059ea:	5e                   	pop    %esi
801059eb:	5d                   	pop    %ebp
801059ec:	c3                   	ret
801059ed:	8d 76 00             	lea    0x0(%esi),%esi
801059f0:	5b                   	pop    %ebx
  return 0;
801059f1:	31 c0                	xor    %eax,%eax
}
801059f3:	5e                   	pop    %esi
801059f4:	5d                   	pop    %ebp
801059f5:	c3                   	ret
801059f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059fd:	00 
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	8b 55 08             	mov    0x8(%ebp),%edx
80105a07:	8b 45 10             	mov    0x10(%ebp),%eax
80105a0a:	56                   	push   %esi
80105a0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105a0e:	39 d6                	cmp    %edx,%esi
80105a10:	73 26                	jae    80105a38 <memmove+0x38>
80105a12:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80105a15:	39 ca                	cmp    %ecx,%edx
80105a17:	73 1f                	jae    80105a38 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	74 0f                	je     80105a2c <memmove+0x2c>
80105a1d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80105a20:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105a24:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105a27:	83 e8 01             	sub    $0x1,%eax
80105a2a:	73 f4                	jae    80105a20 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105a2c:	5e                   	pop    %esi
80105a2d:	89 d0                	mov    %edx,%eax
80105a2f:	5f                   	pop    %edi
80105a30:	5d                   	pop    %ebp
80105a31:	c3                   	ret
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105a38:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80105a3b:	89 d7                	mov    %edx,%edi
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	74 eb                	je     80105a2c <memmove+0x2c>
80105a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105a48:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105a49:	39 ce                	cmp    %ecx,%esi
80105a4b:	75 fb                	jne    80105a48 <memmove+0x48>
}
80105a4d:	5e                   	pop    %esi
80105a4e:	89 d0                	mov    %edx,%eax
80105a50:	5f                   	pop    %edi
80105a51:	5d                   	pop    %ebp
80105a52:	c3                   	ret
80105a53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a5a:	00 
80105a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105a60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105a60:	eb 9e                	jmp    80105a00 <memmove>
80105a62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a69:	00 
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
80105a74:	8b 55 10             	mov    0x10(%ebp),%edx
80105a77:	8b 45 08             	mov    0x8(%ebp),%eax
80105a7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80105a7d:	85 d2                	test   %edx,%edx
80105a7f:	75 16                	jne    80105a97 <strncmp+0x27>
80105a81:	eb 2d                	jmp    80105ab0 <strncmp+0x40>
80105a83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a88:	3a 19                	cmp    (%ecx),%bl
80105a8a:	75 12                	jne    80105a9e <strncmp+0x2e>
    n--, p++, q++;
80105a8c:	83 c0 01             	add    $0x1,%eax
80105a8f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105a92:	83 ea 01             	sub    $0x1,%edx
80105a95:	74 19                	je     80105ab0 <strncmp+0x40>
80105a97:	0f b6 18             	movzbl (%eax),%ebx
80105a9a:	84 db                	test   %bl,%bl
80105a9c:	75 ea                	jne    80105a88 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105a9e:	0f b6 00             	movzbl (%eax),%eax
80105aa1:	0f b6 11             	movzbl (%ecx),%edx
}
80105aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80105aa8:	29 d0                	sub    %edx,%eax
}
80105aaa:	c3                   	ret
80105aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80105ab3:	31 c0                	xor    %eax,%eax
}
80105ab5:	c9                   	leave
80105ab6:	c3                   	ret
80105ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abe:	00 
80105abf:	90                   	nop

80105ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80105ac8:	53                   	push   %ebx
80105ac9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105acc:	89 f0                	mov    %esi,%eax
80105ace:	eb 15                	jmp    80105ae5 <strncpy+0x25>
80105ad0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105ad4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105ad7:	83 c0 01             	add    $0x1,%eax
80105ada:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80105ade:	88 48 ff             	mov    %cl,-0x1(%eax)
80105ae1:	84 c9                	test   %cl,%cl
80105ae3:	74 13                	je     80105af8 <strncpy+0x38>
80105ae5:	89 d3                	mov    %edx,%ebx
80105ae7:	83 ea 01             	sub    $0x1,%edx
80105aea:	85 db                	test   %ebx,%ebx
80105aec:	7f e2                	jg     80105ad0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80105aee:	5b                   	pop    %ebx
80105aef:	89 f0                	mov    %esi,%eax
80105af1:	5e                   	pop    %esi
80105af2:	5f                   	pop    %edi
80105af3:	5d                   	pop    %ebp
80105af4:	c3                   	ret
80105af5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80105af8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80105afb:	83 e9 01             	sub    $0x1,%ecx
80105afe:	85 d2                	test   %edx,%edx
80105b00:	74 ec                	je     80105aee <strncpy+0x2e>
80105b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80105b08:	83 c0 01             	add    $0x1,%eax
80105b0b:	89 ca                	mov    %ecx,%edx
80105b0d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80105b11:	29 c2                	sub    %eax,%edx
80105b13:	85 d2                	test   %edx,%edx
80105b15:	7f f1                	jg     80105b08 <strncpy+0x48>
}
80105b17:	5b                   	pop    %ebx
80105b18:	89 f0                	mov    %esi,%eax
80105b1a:	5e                   	pop    %esi
80105b1b:	5f                   	pop    %edi
80105b1c:	5d                   	pop    %ebp
80105b1d:	c3                   	ret
80105b1e:	66 90                	xchg   %ax,%ax

80105b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	8b 55 10             	mov    0x10(%ebp),%edx
80105b27:	8b 75 08             	mov    0x8(%ebp),%esi
80105b2a:	53                   	push   %ebx
80105b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105b2e:	85 d2                	test   %edx,%edx
80105b30:	7e 25                	jle    80105b57 <safestrcpy+0x37>
80105b32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105b36:	89 f2                	mov    %esi,%edx
80105b38:	eb 16                	jmp    80105b50 <safestrcpy+0x30>
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105b40:	0f b6 08             	movzbl (%eax),%ecx
80105b43:	83 c0 01             	add    $0x1,%eax
80105b46:	83 c2 01             	add    $0x1,%edx
80105b49:	88 4a ff             	mov    %cl,-0x1(%edx)
80105b4c:	84 c9                	test   %cl,%cl
80105b4e:	74 04                	je     80105b54 <safestrcpy+0x34>
80105b50:	39 d8                	cmp    %ebx,%eax
80105b52:	75 ec                	jne    80105b40 <safestrcpy+0x20>
    ;
  *s = 0;
80105b54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105b57:	89 f0                	mov    %esi,%eax
80105b59:	5b                   	pop    %ebx
80105b5a:	5e                   	pop    %esi
80105b5b:	5d                   	pop    %ebp
80105b5c:	c3                   	ret
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi

80105b60 <strlen>:

int
strlen(const char *s)
{
80105b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105b61:	31 c0                	xor    %eax,%eax
{
80105b63:	89 e5                	mov    %esp,%ebp
80105b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105b68:	80 3a 00             	cmpb   $0x0,(%edx)
80105b6b:	74 0c                	je     80105b79 <strlen+0x19>
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi
80105b70:	83 c0 01             	add    $0x1,%eax
80105b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105b77:	75 f7                	jne    80105b70 <strlen+0x10>
    ;
  return n;
}
80105b79:	5d                   	pop    %ebp
80105b7a:	c3                   	ret

80105b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105b83:	55                   	push   %ebp
  pushl %ebx
80105b84:	53                   	push   %ebx
  pushl %esi
80105b85:	56                   	push   %esi
  pushl %edi
80105b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105b89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105b8b:	5f                   	pop    %edi
  popl %esi
80105b8c:	5e                   	pop    %esi
  popl %ebx
80105b8d:	5b                   	pop    %ebx
  popl %ebp
80105b8e:	5d                   	pop    %ebp
  ret
80105b8f:	c3                   	ret

80105b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
80105b94:	83 ec 04             	sub    $0x4,%esp
80105b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105b9a:	e8 91 f0 ff ff       	call   80104c30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105b9f:	8b 00                	mov    (%eax),%eax
80105ba1:	39 c3                	cmp    %eax,%ebx
80105ba3:	73 1b                	jae    80105bc0 <fetchint+0x30>
80105ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80105ba8:	39 d0                	cmp    %edx,%eax
80105baa:	72 14                	jb     80105bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80105baf:	8b 13                	mov    (%ebx),%edx
80105bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80105bb3:	31 c0                	xor    %eax,%eax
}
80105bb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb8:	c9                   	leave
80105bb9:	c3                   	ret
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc5:	eb ee                	jmp    80105bb5 <fetchint+0x25>
80105bc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bce:	00 
80105bcf:	90                   	nop

80105bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
80105bd4:	83 ec 04             	sub    $0x4,%esp
80105bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105bda:	e8 51 f0 ff ff       	call   80104c30 <myproc>

  if(addr >= curproc->sz)
80105bdf:	3b 18                	cmp    (%eax),%ebx
80105be1:	73 2d                	jae    80105c10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105be6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105be8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105bea:	39 d3                	cmp    %edx,%ebx
80105bec:	73 22                	jae    80105c10 <fetchstr+0x40>
80105bee:	89 d8                	mov    %ebx,%eax
80105bf0:	eb 0d                	jmp    80105bff <fetchstr+0x2f>
80105bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bf8:	83 c0 01             	add    $0x1,%eax
80105bfb:	39 d0                	cmp    %edx,%eax
80105bfd:	73 11                	jae    80105c10 <fetchstr+0x40>
    if(*s == 0)
80105bff:	80 38 00             	cmpb   $0x0,(%eax)
80105c02:	75 f4                	jne    80105bf8 <fetchstr+0x28>
      return s - *pp;
80105c04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c09:	c9                   	leave
80105c0a:	c3                   	ret
80105c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c18:	c9                   	leave
80105c19:	c3                   	ret
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	56                   	push   %esi
80105c24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c25:	e8 06 f0 ff ff       	call   80104c30 <myproc>
80105c2a:	8b 55 08             	mov    0x8(%ebp),%edx
80105c2d:	8b 40 18             	mov    0x18(%eax),%eax
80105c30:	8b 40 44             	mov    0x44(%eax),%eax
80105c33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c36:	e8 f5 ef ff ff       	call   80104c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c3e:	8b 00                	mov    (%eax),%eax
80105c40:	39 c6                	cmp    %eax,%esi
80105c42:	73 1c                	jae    80105c60 <argint+0x40>
80105c44:	8d 53 08             	lea    0x8(%ebx),%edx
80105c47:	39 d0                	cmp    %edx,%eax
80105c49:	72 15                	jb     80105c60 <argint+0x40>
  *ip = *(int*)(addr);
80105c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c4e:	8b 53 04             	mov    0x4(%ebx),%edx
80105c51:	89 10                	mov    %edx,(%eax)
  return 0;
80105c53:	31 c0                	xor    %eax,%eax
}
80105c55:	5b                   	pop    %ebx
80105c56:	5e                   	pop    %esi
80105c57:	5d                   	pop    %ebp
80105c58:	c3                   	ret
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c65:	eb ee                	jmp    80105c55 <argint+0x35>
80105c67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c6e:	00 
80105c6f:	90                   	nop

80105c70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105c79:	e8 b2 ef ff ff       	call   80104c30 <myproc>
80105c7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c80:	e8 ab ef ff ff       	call   80104c30 <myproc>
80105c85:	8b 55 08             	mov    0x8(%ebp),%edx
80105c88:	8b 40 18             	mov    0x18(%eax),%eax
80105c8b:	8b 40 44             	mov    0x44(%eax),%eax
80105c8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105c91:	e8 9a ef ff ff       	call   80104c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105c96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105c99:	8b 00                	mov    (%eax),%eax
80105c9b:	39 c7                	cmp    %eax,%edi
80105c9d:	73 31                	jae    80105cd0 <argptr+0x60>
80105c9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105ca2:	39 c8                	cmp    %ecx,%eax
80105ca4:	72 2a                	jb     80105cd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105ca6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105ca9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105cac:	85 d2                	test   %edx,%edx
80105cae:	78 20                	js     80105cd0 <argptr+0x60>
80105cb0:	8b 16                	mov    (%esi),%edx
80105cb2:	39 d0                	cmp    %edx,%eax
80105cb4:	73 1a                	jae    80105cd0 <argptr+0x60>
80105cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105cb9:	01 c3                	add    %eax,%ebx
80105cbb:	39 da                	cmp    %ebx,%edx
80105cbd:	72 11                	jb     80105cd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cc2:	89 02                	mov    %eax,(%edx)
  return 0;
80105cc4:	31 c0                	xor    %eax,%eax
}
80105cc6:	83 c4 0c             	add    $0xc,%esp
80105cc9:	5b                   	pop    %ebx
80105cca:	5e                   	pop    %esi
80105ccb:	5f                   	pop    %edi
80105ccc:	5d                   	pop    %ebp
80105ccd:	c3                   	ret
80105cce:	66 90                	xchg   %ax,%ax
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd5:	eb ef                	jmp    80105cc6 <argptr+0x56>
80105cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cde:	00 
80105cdf:	90                   	nop

80105ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	56                   	push   %esi
80105ce4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ce5:	e8 46 ef ff ff       	call   80104c30 <myproc>
80105cea:	8b 55 08             	mov    0x8(%ebp),%edx
80105ced:	8b 40 18             	mov    0x18(%eax),%eax
80105cf0:	8b 40 44             	mov    0x44(%eax),%eax
80105cf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105cf6:	e8 35 ef ff ff       	call   80104c30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105cfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105cfe:	8b 00                	mov    (%eax),%eax
80105d00:	39 c6                	cmp    %eax,%esi
80105d02:	73 44                	jae    80105d48 <argstr+0x68>
80105d04:	8d 53 08             	lea    0x8(%ebx),%edx
80105d07:	39 d0                	cmp    %edx,%eax
80105d09:	72 3d                	jb     80105d48 <argstr+0x68>
  *ip = *(int*)(addr);
80105d0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105d0e:	e8 1d ef ff ff       	call   80104c30 <myproc>
  if(addr >= curproc->sz)
80105d13:	3b 18                	cmp    (%eax),%ebx
80105d15:	73 31                	jae    80105d48 <argstr+0x68>
  *pp = (char*)addr;
80105d17:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105d1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105d1e:	39 d3                	cmp    %edx,%ebx
80105d20:	73 26                	jae    80105d48 <argstr+0x68>
80105d22:	89 d8                	mov    %ebx,%eax
80105d24:	eb 11                	jmp    80105d37 <argstr+0x57>
80105d26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d2d:	00 
80105d2e:	66 90                	xchg   %ax,%ax
80105d30:	83 c0 01             	add    $0x1,%eax
80105d33:	39 d0                	cmp    %edx,%eax
80105d35:	73 11                	jae    80105d48 <argstr+0x68>
    if(*s == 0)
80105d37:	80 38 00             	cmpb   $0x0,(%eax)
80105d3a:	75 f4                	jne    80105d30 <argstr+0x50>
      return s - *pp;
80105d3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105d3e:	5b                   	pop    %ebx
80105d3f:	5e                   	pop    %esi
80105d40:	5d                   	pop    %ebp
80105d41:	c3                   	ret
80105d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d48:	5b                   	pop    %ebx
    return -1;
80105d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4e:	5e                   	pop    %esi
80105d4f:	5d                   	pop    %ebp
80105d50:	c3                   	ret
80105d51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d58:	00 
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	53                   	push   %ebx
80105d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105d67:	e8 c4 ee ff ff       	call   80104c30 <myproc>
80105d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105d6e:	8b 40 18             	mov    0x18(%eax),%eax
80105d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d77:	83 fa 14             	cmp    $0x14,%edx
80105d7a:	77 24                	ja     80105da0 <syscall+0x40>
80105d7c:	8b 14 85 a0 8d 10 80 	mov    -0x7fef7260(,%eax,4),%edx
80105d83:	85 d2                	test   %edx,%edx
80105d85:	74 19                	je     80105da0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105d87:	ff d2                	call   *%edx
80105d89:	89 c2                	mov    %eax,%edx
80105d8b:	8b 43 18             	mov    0x18(%ebx),%eax
80105d8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d94:	c9                   	leave
80105d95:	c3                   	ret
80105d96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d9d:	00 
80105d9e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80105da0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105da1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105da4:	50                   	push   %eax
80105da5:	ff 73 10             	push   0x10(%ebx)
80105da8:	68 b1 87 10 80       	push   $0x801087b1
80105dad:	e8 7e ae ff ff       	call   80100c30 <cprintf>
    curproc->tf->eax = -1;
80105db2:	8b 43 18             	mov    0x18(%ebx),%eax
80105db5:	83 c4 10             	add    $0x10,%esp
80105db8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105dbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dc2:	c9                   	leave
80105dc3:	c3                   	ret
80105dc4:	66 90                	xchg   %ax,%ax
80105dc6:	66 90                	xchg   %ax,%ax
80105dc8:	66 90                	xchg   %ax,%ax
80105dca:	66 90                	xchg   %ax,%ax
80105dcc:	66 90                	xchg   %ax,%ax
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105dd0:	55                   	push   %ebp
80105dd1:	89 e5                	mov    %esp,%ebp
80105dd3:	57                   	push   %edi
80105dd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105dd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105dd8:	53                   	push   %ebx
80105dd9:	83 ec 34             	sub    $0x34,%esp
80105ddc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105de2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105de5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105de8:	57                   	push   %edi
80105de9:	50                   	push   %eax
80105dea:	e8 81 d5 ff ff       	call   80103370 <nameiparent>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	85 c0                	test   %eax,%eax
80105df4:	74 5e                	je     80105e54 <create+0x84>
    return 0;
  ilock(dp);
80105df6:	83 ec 0c             	sub    $0xc,%esp
80105df9:	89 c3                	mov    %eax,%ebx
80105dfb:	50                   	push   %eax
80105dfc:	e8 6f cc ff ff       	call   80102a70 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105e01:	83 c4 0c             	add    $0xc,%esp
80105e04:	6a 00                	push   $0x0
80105e06:	57                   	push   %edi
80105e07:	53                   	push   %ebx
80105e08:	e8 b3 d1 ff ff       	call   80102fc0 <dirlookup>
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	89 c6                	mov    %eax,%esi
80105e12:	85 c0                	test   %eax,%eax
80105e14:	74 4a                	je     80105e60 <create+0x90>
    iunlockput(dp);
80105e16:	83 ec 0c             	sub    $0xc,%esp
80105e19:	53                   	push   %ebx
80105e1a:	e8 e1 ce ff ff       	call   80102d00 <iunlockput>
    ilock(ip);
80105e1f:	89 34 24             	mov    %esi,(%esp)
80105e22:	e8 49 cc ff ff       	call   80102a70 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e27:	83 c4 10             	add    $0x10,%esp
80105e2a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e2f:	75 17                	jne    80105e48 <create+0x78>
80105e31:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105e36:	75 10                	jne    80105e48 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e3b:	89 f0                	mov    %esi,%eax
80105e3d:	5b                   	pop    %ebx
80105e3e:	5e                   	pop    %esi
80105e3f:	5f                   	pop    %edi
80105e40:	5d                   	pop    %ebp
80105e41:	c3                   	ret
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	56                   	push   %esi
80105e4c:	e8 af ce ff ff       	call   80102d00 <iunlockput>
    return 0;
80105e51:	83 c4 10             	add    $0x10,%esp
}
80105e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105e57:	31 f6                	xor    %esi,%esi
}
80105e59:	5b                   	pop    %ebx
80105e5a:	89 f0                	mov    %esi,%eax
80105e5c:	5e                   	pop    %esi
80105e5d:	5f                   	pop    %edi
80105e5e:	5d                   	pop    %ebp
80105e5f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105e60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105e64:	83 ec 08             	sub    $0x8,%esp
80105e67:	50                   	push   %eax
80105e68:	ff 33                	push   (%ebx)
80105e6a:	e8 91 ca ff ff       	call   80102900 <ialloc>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	89 c6                	mov    %eax,%esi
80105e74:	85 c0                	test   %eax,%eax
80105e76:	0f 84 bc 00 00 00    	je     80105f38 <create+0x168>
  ilock(ip);
80105e7c:	83 ec 0c             	sub    $0xc,%esp
80105e7f:	50                   	push   %eax
80105e80:	e8 eb cb ff ff       	call   80102a70 <ilock>
  ip->major = major;
80105e85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105e8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105e95:	b8 01 00 00 00       	mov    $0x1,%eax
80105e9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105e9e:	89 34 24             	mov    %esi,(%esp)
80105ea1:	e8 1a cb ff ff       	call   801029c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105eae:	74 30                	je     80105ee0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80105eb0:	83 ec 04             	sub    $0x4,%esp
80105eb3:	ff 76 04             	push   0x4(%esi)
80105eb6:	57                   	push   %edi
80105eb7:	53                   	push   %ebx
80105eb8:	e8 d3 d3 ff ff       	call   80103290 <dirlink>
80105ebd:	83 c4 10             	add    $0x10,%esp
80105ec0:	85 c0                	test   %eax,%eax
80105ec2:	78 67                	js     80105f2b <create+0x15b>
  iunlockput(dp);
80105ec4:	83 ec 0c             	sub    $0xc,%esp
80105ec7:	53                   	push   %ebx
80105ec8:	e8 33 ce ff ff       	call   80102d00 <iunlockput>
  return ip;
80105ecd:	83 c4 10             	add    $0x10,%esp
}
80105ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed3:	89 f0                	mov    %esi,%eax
80105ed5:	5b                   	pop    %ebx
80105ed6:	5e                   	pop    %esi
80105ed7:	5f                   	pop    %edi
80105ed8:	5d                   	pop    %ebp
80105ed9:	c3                   	ret
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105ee3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105ee8:	53                   	push   %ebx
80105ee9:	e8 d2 ca ff ff       	call   801029c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105eee:	83 c4 0c             	add    $0xc,%esp
80105ef1:	ff 76 04             	push   0x4(%esi)
80105ef4:	68 e9 87 10 80       	push   $0x801087e9
80105ef9:	56                   	push   %esi
80105efa:	e8 91 d3 ff ff       	call   80103290 <dirlink>
80105eff:	83 c4 10             	add    $0x10,%esp
80105f02:	85 c0                	test   %eax,%eax
80105f04:	78 18                	js     80105f1e <create+0x14e>
80105f06:	83 ec 04             	sub    $0x4,%esp
80105f09:	ff 73 04             	push   0x4(%ebx)
80105f0c:	68 e8 87 10 80       	push   $0x801087e8
80105f11:	56                   	push   %esi
80105f12:	e8 79 d3 ff ff       	call   80103290 <dirlink>
80105f17:	83 c4 10             	add    $0x10,%esp
80105f1a:	85 c0                	test   %eax,%eax
80105f1c:	79 92                	jns    80105eb0 <create+0xe0>
      panic("create dots");
80105f1e:	83 ec 0c             	sub    $0xc,%esp
80105f21:	68 dc 87 10 80       	push   $0x801087dc
80105f26:	e8 15 a6 ff ff       	call   80100540 <panic>
    panic("create: dirlink");
80105f2b:	83 ec 0c             	sub    $0xc,%esp
80105f2e:	68 eb 87 10 80       	push   $0x801087eb
80105f33:	e8 08 a6 ff ff       	call   80100540 <panic>
    panic("create: ialloc");
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	68 cd 87 10 80       	push   $0x801087cd
80105f40:	e8 fb a5 ff ff       	call   80100540 <panic>
80105f45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f4c:	00 
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi

80105f50 <sys_dup>:
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	56                   	push   %esi
80105f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105f5b:	50                   	push   %eax
80105f5c:	6a 00                	push   $0x0
80105f5e:	e8 bd fc ff ff       	call   80105c20 <argint>
80105f63:	83 c4 10             	add    $0x10,%esp
80105f66:	85 c0                	test   %eax,%eax
80105f68:	78 36                	js     80105fa0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105f6e:	77 30                	ja     80105fa0 <sys_dup+0x50>
80105f70:	e8 bb ec ff ff       	call   80104c30 <myproc>
80105f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105f7c:	85 f6                	test   %esi,%esi
80105f7e:	74 20                	je     80105fa0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105f80:	e8 ab ec ff ff       	call   80104c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f85:	31 db                	xor    %ebx,%ebx
80105f87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f8e:	00 
80105f8f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105f90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f94:	85 d2                	test   %edx,%edx
80105f96:	74 18                	je     80105fb0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105f98:	83 c3 01             	add    $0x1,%ebx
80105f9b:	83 fb 10             	cmp    $0x10,%ebx
80105f9e:	75 f0                	jne    80105f90 <sys_dup+0x40>
}
80105fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105fa3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105fa8:	89 d8                	mov    %ebx,%eax
80105faa:	5b                   	pop    %ebx
80105fab:	5e                   	pop    %esi
80105fac:	5d                   	pop    %ebp
80105fad:	c3                   	ret
80105fae:	66 90                	xchg   %ax,%ax
  filedup(f);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105fb3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105fb7:	56                   	push   %esi
80105fb8:	e8 d3 c1 ff ff       	call   80102190 <filedup>
  return fd;
80105fbd:	83 c4 10             	add    $0x10,%esp
}
80105fc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fc3:	89 d8                	mov    %ebx,%eax
80105fc5:	5b                   	pop    %ebx
80105fc6:	5e                   	pop    %esi
80105fc7:	5d                   	pop    %ebp
80105fc8:	c3                   	ret
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_read>:
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	56                   	push   %esi
80105fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105fd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105fdb:	53                   	push   %ebx
80105fdc:	6a 00                	push   $0x0
80105fde:	e8 3d fc ff ff       	call   80105c20 <argint>
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	85 c0                	test   %eax,%eax
80105fe8:	78 5e                	js     80106048 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105fee:	77 58                	ja     80106048 <sys_read+0x78>
80105ff0:	e8 3b ec ff ff       	call   80104c30 <myproc>
80105ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ff8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105ffc:	85 f6                	test   %esi,%esi
80105ffe:	74 48                	je     80106048 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106000:	83 ec 08             	sub    $0x8,%esp
80106003:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106006:	50                   	push   %eax
80106007:	6a 02                	push   $0x2
80106009:	e8 12 fc ff ff       	call   80105c20 <argint>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	85 c0                	test   %eax,%eax
80106013:	78 33                	js     80106048 <sys_read+0x78>
80106015:	83 ec 04             	sub    $0x4,%esp
80106018:	ff 75 f0             	push   -0x10(%ebp)
8010601b:	53                   	push   %ebx
8010601c:	6a 01                	push   $0x1
8010601e:	e8 4d fc ff ff       	call   80105c70 <argptr>
80106023:	83 c4 10             	add    $0x10,%esp
80106026:	85 c0                	test   %eax,%eax
80106028:	78 1e                	js     80106048 <sys_read+0x78>
  return fileread(f, p, n);
8010602a:	83 ec 04             	sub    $0x4,%esp
8010602d:	ff 75 f0             	push   -0x10(%ebp)
80106030:	ff 75 f4             	push   -0xc(%ebp)
80106033:	56                   	push   %esi
80106034:	e8 d7 c2 ff ff       	call   80102310 <fileread>
80106039:	83 c4 10             	add    $0x10,%esp
}
8010603c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010603f:	5b                   	pop    %ebx
80106040:	5e                   	pop    %esi
80106041:	5d                   	pop    %ebp
80106042:	c3                   	ret
80106043:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604d:	eb ed                	jmp    8010603c <sys_read+0x6c>
8010604f:	90                   	nop

80106050 <sys_write>:
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	56                   	push   %esi
80106054:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106055:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106058:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010605b:	53                   	push   %ebx
8010605c:	6a 00                	push   $0x0
8010605e:	e8 bd fb ff ff       	call   80105c20 <argint>
80106063:	83 c4 10             	add    $0x10,%esp
80106066:	85 c0                	test   %eax,%eax
80106068:	78 5e                	js     801060c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010606a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010606e:	77 58                	ja     801060c8 <sys_write+0x78>
80106070:	e8 bb eb ff ff       	call   80104c30 <myproc>
80106075:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106078:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010607c:	85 f6                	test   %esi,%esi
8010607e:	74 48                	je     801060c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106086:	50                   	push   %eax
80106087:	6a 02                	push   $0x2
80106089:	e8 92 fb ff ff       	call   80105c20 <argint>
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	85 c0                	test   %eax,%eax
80106093:	78 33                	js     801060c8 <sys_write+0x78>
80106095:	83 ec 04             	sub    $0x4,%esp
80106098:	ff 75 f0             	push   -0x10(%ebp)
8010609b:	53                   	push   %ebx
8010609c:	6a 01                	push   $0x1
8010609e:	e8 cd fb ff ff       	call   80105c70 <argptr>
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	85 c0                	test   %eax,%eax
801060a8:	78 1e                	js     801060c8 <sys_write+0x78>
  return filewrite(f, p, n);
801060aa:	83 ec 04             	sub    $0x4,%esp
801060ad:	ff 75 f0             	push   -0x10(%ebp)
801060b0:	ff 75 f4             	push   -0xc(%ebp)
801060b3:	56                   	push   %esi
801060b4:	e8 e7 c2 ff ff       	call   801023a0 <filewrite>
801060b9:	83 c4 10             	add    $0x10,%esp
}
801060bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060bf:	5b                   	pop    %ebx
801060c0:	5e                   	pop    %esi
801060c1:	5d                   	pop    %ebp
801060c2:	c3                   	ret
801060c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801060c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060cd:	eb ed                	jmp    801060bc <sys_write+0x6c>
801060cf:	90                   	nop

801060d0 <sys_close>:
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	56                   	push   %esi
801060d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801060d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801060db:	50                   	push   %eax
801060dc:	6a 00                	push   $0x0
801060de:	e8 3d fb ff ff       	call   80105c20 <argint>
801060e3:	83 c4 10             	add    $0x10,%esp
801060e6:	85 c0                	test   %eax,%eax
801060e8:	78 3e                	js     80106128 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801060ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801060ee:	77 38                	ja     80106128 <sys_close+0x58>
801060f0:	e8 3b eb ff ff       	call   80104c30 <myproc>
801060f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801060fb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801060ff:	85 f6                	test   %esi,%esi
80106101:	74 25                	je     80106128 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106103:	e8 28 eb ff ff       	call   80104c30 <myproc>
  fileclose(f);
80106108:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010610b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106112:	00 
  fileclose(f);
80106113:	56                   	push   %esi
80106114:	e8 c7 c0 ff ff       	call   801021e0 <fileclose>
  return 0;
80106119:	83 c4 10             	add    $0x10,%esp
8010611c:	31 c0                	xor    %eax,%eax
}
8010611e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106121:	5b                   	pop    %ebx
80106122:	5e                   	pop    %esi
80106123:	5d                   	pop    %ebp
80106124:	c3                   	ret
80106125:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612d:	eb ef                	jmp    8010611e <sys_close+0x4e>
8010612f:	90                   	nop

80106130 <sys_fstat>:
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	56                   	push   %esi
80106134:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106135:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106138:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010613b:	53                   	push   %ebx
8010613c:	6a 00                	push   $0x0
8010613e:	e8 dd fa ff ff       	call   80105c20 <argint>
80106143:	83 c4 10             	add    $0x10,%esp
80106146:	85 c0                	test   %eax,%eax
80106148:	78 46                	js     80106190 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010614a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010614e:	77 40                	ja     80106190 <sys_fstat+0x60>
80106150:	e8 db ea ff ff       	call   80104c30 <myproc>
80106155:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106158:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010615c:	85 f6                	test   %esi,%esi
8010615e:	74 30                	je     80106190 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106160:	83 ec 04             	sub    $0x4,%esp
80106163:	6a 14                	push   $0x14
80106165:	53                   	push   %ebx
80106166:	6a 01                	push   $0x1
80106168:	e8 03 fb ff ff       	call   80105c70 <argptr>
8010616d:	83 c4 10             	add    $0x10,%esp
80106170:	85 c0                	test   %eax,%eax
80106172:	78 1c                	js     80106190 <sys_fstat+0x60>
  return filestat(f, st);
80106174:	83 ec 08             	sub    $0x8,%esp
80106177:	ff 75 f4             	push   -0xc(%ebp)
8010617a:	56                   	push   %esi
8010617b:	e8 40 c1 ff ff       	call   801022c0 <filestat>
80106180:	83 c4 10             	add    $0x10,%esp
}
80106183:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106186:	5b                   	pop    %ebx
80106187:	5e                   	pop    %esi
80106188:	5d                   	pop    %ebp
80106189:	c3                   	ret
8010618a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106195:	eb ec                	jmp    80106183 <sys_fstat+0x53>
80106197:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010619e:	00 
8010619f:	90                   	nop

801061a0 <sys_link>:
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	57                   	push   %edi
801061a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801061a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801061a8:	53                   	push   %ebx
801061a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801061ac:	50                   	push   %eax
801061ad:	6a 00                	push   $0x0
801061af:	e8 2c fb ff ff       	call   80105ce0 <argstr>
801061b4:	83 c4 10             	add    $0x10,%esp
801061b7:	85 c0                	test   %eax,%eax
801061b9:	0f 88 fb 00 00 00    	js     801062ba <sys_link+0x11a>
801061bf:	83 ec 08             	sub    $0x8,%esp
801061c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801061c5:	50                   	push   %eax
801061c6:	6a 01                	push   $0x1
801061c8:	e8 13 fb ff ff       	call   80105ce0 <argstr>
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	85 c0                	test   %eax,%eax
801061d2:	0f 88 e2 00 00 00    	js     801062ba <sys_link+0x11a>
  begin_op();
801061d8:	e8 33 de ff ff       	call   80104010 <begin_op>
  if((ip = namei(old)) == 0){
801061dd:	83 ec 0c             	sub    $0xc,%esp
801061e0:	ff 75 d4             	push   -0x2c(%ebp)
801061e3:	e8 68 d1 ff ff       	call   80103350 <namei>
801061e8:	83 c4 10             	add    $0x10,%esp
801061eb:	89 c3                	mov    %eax,%ebx
801061ed:	85 c0                	test   %eax,%eax
801061ef:	0f 84 df 00 00 00    	je     801062d4 <sys_link+0x134>
  ilock(ip);
801061f5:	83 ec 0c             	sub    $0xc,%esp
801061f8:	50                   	push   %eax
801061f9:	e8 72 c8 ff ff       	call   80102a70 <ilock>
  if(ip->type == T_DIR){
801061fe:	83 c4 10             	add    $0x10,%esp
80106201:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106206:	0f 84 b5 00 00 00    	je     801062c1 <sys_link+0x121>
  iupdate(ip);
8010620c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010620f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106214:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106217:	53                   	push   %ebx
80106218:	e8 a3 c7 ff ff       	call   801029c0 <iupdate>
  iunlock(ip);
8010621d:	89 1c 24             	mov    %ebx,(%esp)
80106220:	e8 2b c9 ff ff       	call   80102b50 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106225:	58                   	pop    %eax
80106226:	5a                   	pop    %edx
80106227:	57                   	push   %edi
80106228:	ff 75 d0             	push   -0x30(%ebp)
8010622b:	e8 40 d1 ff ff       	call   80103370 <nameiparent>
80106230:	83 c4 10             	add    $0x10,%esp
80106233:	89 c6                	mov    %eax,%esi
80106235:	85 c0                	test   %eax,%eax
80106237:	74 5b                	je     80106294 <sys_link+0xf4>
  ilock(dp);
80106239:	83 ec 0c             	sub    $0xc,%esp
8010623c:	50                   	push   %eax
8010623d:	e8 2e c8 ff ff       	call   80102a70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106242:	8b 03                	mov    (%ebx),%eax
80106244:	83 c4 10             	add    $0x10,%esp
80106247:	39 06                	cmp    %eax,(%esi)
80106249:	75 3d                	jne    80106288 <sys_link+0xe8>
8010624b:	83 ec 04             	sub    $0x4,%esp
8010624e:	ff 73 04             	push   0x4(%ebx)
80106251:	57                   	push   %edi
80106252:	56                   	push   %esi
80106253:	e8 38 d0 ff ff       	call   80103290 <dirlink>
80106258:	83 c4 10             	add    $0x10,%esp
8010625b:	85 c0                	test   %eax,%eax
8010625d:	78 29                	js     80106288 <sys_link+0xe8>
  iunlockput(dp);
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	56                   	push   %esi
80106263:	e8 98 ca ff ff       	call   80102d00 <iunlockput>
  iput(ip);
80106268:	89 1c 24             	mov    %ebx,(%esp)
8010626b:	e8 30 c9 ff ff       	call   80102ba0 <iput>
  end_op();
80106270:	e8 0b de ff ff       	call   80104080 <end_op>
  return 0;
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	31 c0                	xor    %eax,%eax
}
8010627a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010627d:	5b                   	pop    %ebx
8010627e:	5e                   	pop    %esi
8010627f:	5f                   	pop    %edi
80106280:	5d                   	pop    %ebp
80106281:	c3                   	ret
80106282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106288:	83 ec 0c             	sub    $0xc,%esp
8010628b:	56                   	push   %esi
8010628c:	e8 6f ca ff ff       	call   80102d00 <iunlockput>
    goto bad;
80106291:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106294:	83 ec 0c             	sub    $0xc,%esp
80106297:	53                   	push   %ebx
80106298:	e8 d3 c7 ff ff       	call   80102a70 <ilock>
  ip->nlink--;
8010629d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801062a2:	89 1c 24             	mov    %ebx,(%esp)
801062a5:	e8 16 c7 ff ff       	call   801029c0 <iupdate>
  iunlockput(ip);
801062aa:	89 1c 24             	mov    %ebx,(%esp)
801062ad:	e8 4e ca ff ff       	call   80102d00 <iunlockput>
  end_op();
801062b2:	e8 c9 dd ff ff       	call   80104080 <end_op>
  return -1;
801062b7:	83 c4 10             	add    $0x10,%esp
    return -1;
801062ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bf:	eb b9                	jmp    8010627a <sys_link+0xda>
    iunlockput(ip);
801062c1:	83 ec 0c             	sub    $0xc,%esp
801062c4:	53                   	push   %ebx
801062c5:	e8 36 ca ff ff       	call   80102d00 <iunlockput>
    end_op();
801062ca:	e8 b1 dd ff ff       	call   80104080 <end_op>
    return -1;
801062cf:	83 c4 10             	add    $0x10,%esp
801062d2:	eb e6                	jmp    801062ba <sys_link+0x11a>
    end_op();
801062d4:	e8 a7 dd ff ff       	call   80104080 <end_op>
    return -1;
801062d9:	eb df                	jmp    801062ba <sys_link+0x11a>
801062db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801062e0 <sys_unlink>:
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	57                   	push   %edi
801062e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801062e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801062e8:	53                   	push   %ebx
801062e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801062ec:	50                   	push   %eax
801062ed:	6a 00                	push   $0x0
801062ef:	e8 ec f9 ff ff       	call   80105ce0 <argstr>
801062f4:	83 c4 10             	add    $0x10,%esp
801062f7:	85 c0                	test   %eax,%eax
801062f9:	0f 88 54 01 00 00    	js     80106453 <sys_unlink+0x173>
  begin_op();
801062ff:	e8 0c dd ff ff       	call   80104010 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106304:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106307:	83 ec 08             	sub    $0x8,%esp
8010630a:	53                   	push   %ebx
8010630b:	ff 75 c0             	push   -0x40(%ebp)
8010630e:	e8 5d d0 ff ff       	call   80103370 <nameiparent>
80106313:	83 c4 10             	add    $0x10,%esp
80106316:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106319:	85 c0                	test   %eax,%eax
8010631b:	0f 84 58 01 00 00    	je     80106479 <sys_unlink+0x199>
  ilock(dp);
80106321:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106324:	83 ec 0c             	sub    $0xc,%esp
80106327:	57                   	push   %edi
80106328:	e8 43 c7 ff ff       	call   80102a70 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010632d:	58                   	pop    %eax
8010632e:	5a                   	pop    %edx
8010632f:	68 e9 87 10 80       	push   $0x801087e9
80106334:	53                   	push   %ebx
80106335:	e8 66 cc ff ff       	call   80102fa0 <namecmp>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	85 c0                	test   %eax,%eax
8010633f:	0f 84 fb 00 00 00    	je     80106440 <sys_unlink+0x160>
80106345:	83 ec 08             	sub    $0x8,%esp
80106348:	68 e8 87 10 80       	push   $0x801087e8
8010634d:	53                   	push   %ebx
8010634e:	e8 4d cc ff ff       	call   80102fa0 <namecmp>
80106353:	83 c4 10             	add    $0x10,%esp
80106356:	85 c0                	test   %eax,%eax
80106358:	0f 84 e2 00 00 00    	je     80106440 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010635e:	83 ec 04             	sub    $0x4,%esp
80106361:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106364:	50                   	push   %eax
80106365:	53                   	push   %ebx
80106366:	57                   	push   %edi
80106367:	e8 54 cc ff ff       	call   80102fc0 <dirlookup>
8010636c:	83 c4 10             	add    $0x10,%esp
8010636f:	89 c3                	mov    %eax,%ebx
80106371:	85 c0                	test   %eax,%eax
80106373:	0f 84 c7 00 00 00    	je     80106440 <sys_unlink+0x160>
  ilock(ip);
80106379:	83 ec 0c             	sub    $0xc,%esp
8010637c:	50                   	push   %eax
8010637d:	e8 ee c6 ff ff       	call   80102a70 <ilock>
  if(ip->nlink < 1)
80106382:	83 c4 10             	add    $0x10,%esp
80106385:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010638a:	0f 8e 0a 01 00 00    	jle    8010649a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106390:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106395:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106398:	74 66                	je     80106400 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010639a:	83 ec 04             	sub    $0x4,%esp
8010639d:	6a 10                	push   $0x10
8010639f:	6a 00                	push   $0x0
801063a1:	57                   	push   %edi
801063a2:	e8 c9 f5 ff ff       	call   80105970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063a7:	6a 10                	push   $0x10
801063a9:	ff 75 c4             	push   -0x3c(%ebp)
801063ac:	57                   	push   %edi
801063ad:	ff 75 b4             	push   -0x4c(%ebp)
801063b0:	e8 cb ca ff ff       	call   80102e80 <writei>
801063b5:	83 c4 20             	add    $0x20,%esp
801063b8:	83 f8 10             	cmp    $0x10,%eax
801063bb:	0f 85 cc 00 00 00    	jne    8010648d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801063c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801063c6:	0f 84 94 00 00 00    	je     80106460 <sys_unlink+0x180>
  iunlockput(dp);
801063cc:	83 ec 0c             	sub    $0xc,%esp
801063cf:	ff 75 b4             	push   -0x4c(%ebp)
801063d2:	e8 29 c9 ff ff       	call   80102d00 <iunlockput>
  ip->nlink--;
801063d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801063dc:	89 1c 24             	mov    %ebx,(%esp)
801063df:	e8 dc c5 ff ff       	call   801029c0 <iupdate>
  iunlockput(ip);
801063e4:	89 1c 24             	mov    %ebx,(%esp)
801063e7:	e8 14 c9 ff ff       	call   80102d00 <iunlockput>
  end_op();
801063ec:	e8 8f dc ff ff       	call   80104080 <end_op>
  return 0;
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	31 c0                	xor    %eax,%eax
}
801063f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f9:	5b                   	pop    %ebx
801063fa:	5e                   	pop    %esi
801063fb:	5f                   	pop    %edi
801063fc:	5d                   	pop    %ebp
801063fd:	c3                   	ret
801063fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106400:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106404:	76 94                	jbe    8010639a <sys_unlink+0xba>
80106406:	be 20 00 00 00       	mov    $0x20,%esi
8010640b:	eb 0b                	jmp    80106418 <sys_unlink+0x138>
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
80106410:	83 c6 10             	add    $0x10,%esi
80106413:	3b 73 58             	cmp    0x58(%ebx),%esi
80106416:	73 82                	jae    8010639a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106418:	6a 10                	push   $0x10
8010641a:	56                   	push   %esi
8010641b:	57                   	push   %edi
8010641c:	53                   	push   %ebx
8010641d:	e8 5e c9 ff ff       	call   80102d80 <readi>
80106422:	83 c4 10             	add    $0x10,%esp
80106425:	83 f8 10             	cmp    $0x10,%eax
80106428:	75 56                	jne    80106480 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010642a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010642f:	74 df                	je     80106410 <sys_unlink+0x130>
    iunlockput(ip);
80106431:	83 ec 0c             	sub    $0xc,%esp
80106434:	53                   	push   %ebx
80106435:	e8 c6 c8 ff ff       	call   80102d00 <iunlockput>
    goto bad;
8010643a:	83 c4 10             	add    $0x10,%esp
8010643d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	ff 75 b4             	push   -0x4c(%ebp)
80106446:	e8 b5 c8 ff ff       	call   80102d00 <iunlockput>
  end_op();
8010644b:	e8 30 dc ff ff       	call   80104080 <end_op>
  return -1;
80106450:	83 c4 10             	add    $0x10,%esp
    return -1;
80106453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106458:	eb 9c                	jmp    801063f6 <sys_unlink+0x116>
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106460:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106463:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106466:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010646b:	50                   	push   %eax
8010646c:	e8 4f c5 ff ff       	call   801029c0 <iupdate>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	e9 53 ff ff ff       	jmp    801063cc <sys_unlink+0xec>
    end_op();
80106479:	e8 02 dc ff ff       	call   80104080 <end_op>
    return -1;
8010647e:	eb d3                	jmp    80106453 <sys_unlink+0x173>
      panic("isdirempty: readi");
80106480:	83 ec 0c             	sub    $0xc,%esp
80106483:	68 0d 88 10 80       	push   $0x8010880d
80106488:	e8 b3 a0 ff ff       	call   80100540 <panic>
    panic("unlink: writei");
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	68 1f 88 10 80       	push   $0x8010881f
80106495:	e8 a6 a0 ff ff       	call   80100540 <panic>
    panic("unlink: nlink < 1");
8010649a:	83 ec 0c             	sub    $0xc,%esp
8010649d:	68 fb 87 10 80       	push   $0x801087fb
801064a2:	e8 99 a0 ff ff       	call   80100540 <panic>
801064a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064ae:	00 
801064af:	90                   	nop

801064b0 <sys_open>:

int
sys_open(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801064b8:	53                   	push   %ebx
801064b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801064bc:	50                   	push   %eax
801064bd:	6a 00                	push   $0x0
801064bf:	e8 1c f8 ff ff       	call   80105ce0 <argstr>
801064c4:	83 c4 10             	add    $0x10,%esp
801064c7:	85 c0                	test   %eax,%eax
801064c9:	0f 88 8e 00 00 00    	js     8010655d <sys_open+0xad>
801064cf:	83 ec 08             	sub    $0x8,%esp
801064d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801064d5:	50                   	push   %eax
801064d6:	6a 01                	push   $0x1
801064d8:	e8 43 f7 ff ff       	call   80105c20 <argint>
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	85 c0                	test   %eax,%eax
801064e2:	78 79                	js     8010655d <sys_open+0xad>
    return -1;

  begin_op();
801064e4:	e8 27 db ff ff       	call   80104010 <begin_op>

  if(omode & O_CREATE){
801064e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801064ed:	75 79                	jne    80106568 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	ff 75 e0             	push   -0x20(%ebp)
801064f5:	e8 56 ce ff ff       	call   80103350 <namei>
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	89 c6                	mov    %eax,%esi
801064ff:	85 c0                	test   %eax,%eax
80106501:	0f 84 7e 00 00 00    	je     80106585 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106507:	83 ec 0c             	sub    $0xc,%esp
8010650a:	50                   	push   %eax
8010650b:	e8 60 c5 ff ff       	call   80102a70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106510:	83 c4 10             	add    $0x10,%esp
80106513:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106518:	0f 84 ba 00 00 00    	je     801065d8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010651e:	e8 fd bb ff ff       	call   80102120 <filealloc>
80106523:	89 c7                	mov    %eax,%edi
80106525:	85 c0                	test   %eax,%eax
80106527:	74 23                	je     8010654c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106529:	e8 02 e7 ff ff       	call   80104c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010652e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106530:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106534:	85 d2                	test   %edx,%edx
80106536:	74 58                	je     80106590 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80106538:	83 c3 01             	add    $0x1,%ebx
8010653b:	83 fb 10             	cmp    $0x10,%ebx
8010653e:	75 f0                	jne    80106530 <sys_open+0x80>
    if(f)
      fileclose(f);
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	57                   	push   %edi
80106544:	e8 97 bc ff ff       	call   801021e0 <fileclose>
80106549:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010654c:	83 ec 0c             	sub    $0xc,%esp
8010654f:	56                   	push   %esi
80106550:	e8 ab c7 ff ff       	call   80102d00 <iunlockput>
    end_op();
80106555:	e8 26 db ff ff       	call   80104080 <end_op>
    return -1;
8010655a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010655d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106562:	eb 65                	jmp    801065c9 <sys_open+0x119>
80106564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106568:	83 ec 0c             	sub    $0xc,%esp
8010656b:	31 c9                	xor    %ecx,%ecx
8010656d:	ba 02 00 00 00       	mov    $0x2,%edx
80106572:	6a 00                	push   $0x0
80106574:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106577:	e8 54 f8 ff ff       	call   80105dd0 <create>
    if(ip == 0){
8010657c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010657f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106581:	85 c0                	test   %eax,%eax
80106583:	75 99                	jne    8010651e <sys_open+0x6e>
      end_op();
80106585:	e8 f6 da ff ff       	call   80104080 <end_op>
      return -1;
8010658a:	eb d1                	jmp    8010655d <sys_open+0xad>
8010658c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106590:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106593:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106597:	56                   	push   %esi
80106598:	e8 b3 c5 ff ff       	call   80102b50 <iunlock>
  end_op();
8010659d:	e8 de da ff ff       	call   80104080 <end_op>

  f->type = FD_INODE;
801065a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801065a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065ab:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801065ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801065b1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801065b3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801065ba:	f7 d0                	not    %eax
801065bc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065bf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801065c2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801065c5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801065c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065cc:	89 d8                	mov    %ebx,%eax
801065ce:	5b                   	pop    %ebx
801065cf:	5e                   	pop    %esi
801065d0:	5f                   	pop    %edi
801065d1:	5d                   	pop    %ebp
801065d2:	c3                   	ret
801065d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801065d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801065db:	85 c9                	test   %ecx,%ecx
801065dd:	0f 84 3b ff ff ff    	je     8010651e <sys_open+0x6e>
801065e3:	e9 64 ff ff ff       	jmp    8010654c <sys_open+0x9c>
801065e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065ef:	00 

801065f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065f6:	e8 15 da ff ff       	call   80104010 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065fb:	83 ec 08             	sub    $0x8,%esp
801065fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106601:	50                   	push   %eax
80106602:	6a 00                	push   $0x0
80106604:	e8 d7 f6 ff ff       	call   80105ce0 <argstr>
80106609:	83 c4 10             	add    $0x10,%esp
8010660c:	85 c0                	test   %eax,%eax
8010660e:	78 30                	js     80106640 <sys_mkdir+0x50>
80106610:	83 ec 0c             	sub    $0xc,%esp
80106613:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106616:	31 c9                	xor    %ecx,%ecx
80106618:	ba 01 00 00 00       	mov    $0x1,%edx
8010661d:	6a 00                	push   $0x0
8010661f:	e8 ac f7 ff ff       	call   80105dd0 <create>
80106624:	83 c4 10             	add    $0x10,%esp
80106627:	85 c0                	test   %eax,%eax
80106629:	74 15                	je     80106640 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010662b:	83 ec 0c             	sub    $0xc,%esp
8010662e:	50                   	push   %eax
8010662f:	e8 cc c6 ff ff       	call   80102d00 <iunlockput>
  end_op();
80106634:	e8 47 da ff ff       	call   80104080 <end_op>
  return 0;
80106639:	83 c4 10             	add    $0x10,%esp
8010663c:	31 c0                	xor    %eax,%eax
}
8010663e:	c9                   	leave
8010663f:	c3                   	ret
    end_op();
80106640:	e8 3b da ff ff       	call   80104080 <end_op>
    return -1;
80106645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010664a:	c9                   	leave
8010664b:	c3                   	ret
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106650 <sys_mknod>:

int
sys_mknod(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106656:	e8 b5 d9 ff ff       	call   80104010 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010665b:	83 ec 08             	sub    $0x8,%esp
8010665e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106661:	50                   	push   %eax
80106662:	6a 00                	push   $0x0
80106664:	e8 77 f6 ff ff       	call   80105ce0 <argstr>
80106669:	83 c4 10             	add    $0x10,%esp
8010666c:	85 c0                	test   %eax,%eax
8010666e:	78 60                	js     801066d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106670:	83 ec 08             	sub    $0x8,%esp
80106673:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106676:	50                   	push   %eax
80106677:	6a 01                	push   $0x1
80106679:	e8 a2 f5 ff ff       	call   80105c20 <argint>
  if((argstr(0, &path)) < 0 ||
8010667e:	83 c4 10             	add    $0x10,%esp
80106681:	85 c0                	test   %eax,%eax
80106683:	78 4b                	js     801066d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106685:	83 ec 08             	sub    $0x8,%esp
80106688:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010668b:	50                   	push   %eax
8010668c:	6a 02                	push   $0x2
8010668e:	e8 8d f5 ff ff       	call   80105c20 <argint>
     argint(1, &major) < 0 ||
80106693:	83 c4 10             	add    $0x10,%esp
80106696:	85 c0                	test   %eax,%eax
80106698:	78 36                	js     801066d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010669a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010669e:	83 ec 0c             	sub    $0xc,%esp
801066a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801066a5:	ba 03 00 00 00       	mov    $0x3,%edx
801066aa:	50                   	push   %eax
801066ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066ae:	e8 1d f7 ff ff       	call   80105dd0 <create>
     argint(2, &minor) < 0 ||
801066b3:	83 c4 10             	add    $0x10,%esp
801066b6:	85 c0                	test   %eax,%eax
801066b8:	74 16                	je     801066d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801066ba:	83 ec 0c             	sub    $0xc,%esp
801066bd:	50                   	push   %eax
801066be:	e8 3d c6 ff ff       	call   80102d00 <iunlockput>
  end_op();
801066c3:	e8 b8 d9 ff ff       	call   80104080 <end_op>
  return 0;
801066c8:	83 c4 10             	add    $0x10,%esp
801066cb:	31 c0                	xor    %eax,%eax
}
801066cd:	c9                   	leave
801066ce:	c3                   	ret
801066cf:	90                   	nop
    end_op();
801066d0:	e8 ab d9 ff ff       	call   80104080 <end_op>
    return -1;
801066d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066da:	c9                   	leave
801066db:	c3                   	ret
801066dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066e0 <sys_chdir>:

int
sys_chdir(void)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	56                   	push   %esi
801066e4:	53                   	push   %ebx
801066e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801066e8:	e8 43 e5 ff ff       	call   80104c30 <myproc>
801066ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801066ef:	e8 1c d9 ff ff       	call   80104010 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066f4:	83 ec 08             	sub    $0x8,%esp
801066f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066fa:	50                   	push   %eax
801066fb:	6a 00                	push   $0x0
801066fd:	e8 de f5 ff ff       	call   80105ce0 <argstr>
80106702:	83 c4 10             	add    $0x10,%esp
80106705:	85 c0                	test   %eax,%eax
80106707:	78 77                	js     80106780 <sys_chdir+0xa0>
80106709:	83 ec 0c             	sub    $0xc,%esp
8010670c:	ff 75 f4             	push   -0xc(%ebp)
8010670f:	e8 3c cc ff ff       	call   80103350 <namei>
80106714:	83 c4 10             	add    $0x10,%esp
80106717:	89 c3                	mov    %eax,%ebx
80106719:	85 c0                	test   %eax,%eax
8010671b:	74 63                	je     80106780 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010671d:	83 ec 0c             	sub    $0xc,%esp
80106720:	50                   	push   %eax
80106721:	e8 4a c3 ff ff       	call   80102a70 <ilock>
  if(ip->type != T_DIR){
80106726:	83 c4 10             	add    $0x10,%esp
80106729:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010672e:	75 30                	jne    80106760 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106730:	83 ec 0c             	sub    $0xc,%esp
80106733:	53                   	push   %ebx
80106734:	e8 17 c4 ff ff       	call   80102b50 <iunlock>
  iput(curproc->cwd);
80106739:	58                   	pop    %eax
8010673a:	ff 76 68             	push   0x68(%esi)
8010673d:	e8 5e c4 ff ff       	call   80102ba0 <iput>
  end_op();
80106742:	e8 39 d9 ff ff       	call   80104080 <end_op>
  curproc->cwd = ip;
80106747:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010674a:	83 c4 10             	add    $0x10,%esp
8010674d:	31 c0                	xor    %eax,%eax
}
8010674f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106752:	5b                   	pop    %ebx
80106753:	5e                   	pop    %esi
80106754:	5d                   	pop    %ebp
80106755:	c3                   	ret
80106756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010675d:	00 
8010675e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	53                   	push   %ebx
80106764:	e8 97 c5 ff ff       	call   80102d00 <iunlockput>
    end_op();
80106769:	e8 12 d9 ff ff       	call   80104080 <end_op>
    return -1;
8010676e:	83 c4 10             	add    $0x10,%esp
    return -1;
80106771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106776:	eb d7                	jmp    8010674f <sys_chdir+0x6f>
80106778:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010677f:	00 
    end_op();
80106780:	e8 fb d8 ff ff       	call   80104080 <end_op>
    return -1;
80106785:	eb ea                	jmp    80106771 <sys_chdir+0x91>
80106787:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010678e:	00 
8010678f:	90                   	nop

80106790 <sys_exec>:

int
sys_exec(void)
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106795:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010679b:	53                   	push   %ebx
8010679c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801067a2:	50                   	push   %eax
801067a3:	6a 00                	push   $0x0
801067a5:	e8 36 f5 ff ff       	call   80105ce0 <argstr>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	85 c0                	test   %eax,%eax
801067af:	0f 88 87 00 00 00    	js     8010683c <sys_exec+0xac>
801067b5:	83 ec 08             	sub    $0x8,%esp
801067b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801067be:	50                   	push   %eax
801067bf:	6a 01                	push   $0x1
801067c1:	e8 5a f4 ff ff       	call   80105c20 <argint>
801067c6:	83 c4 10             	add    $0x10,%esp
801067c9:	85 c0                	test   %eax,%eax
801067cb:	78 6f                	js     8010683c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801067cd:	83 ec 04             	sub    $0x4,%esp
801067d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801067d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801067d8:	68 80 00 00 00       	push   $0x80
801067dd:	6a 00                	push   $0x0
801067df:	56                   	push   %esi
801067e0:	e8 8b f1 ff ff       	call   80105970 <memset>
801067e5:	83 c4 10             	add    $0x10,%esp
801067e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067ef:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067f0:	83 ec 08             	sub    $0x8,%esp
801067f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801067f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106800:	50                   	push   %eax
80106801:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106807:	01 f8                	add    %edi,%eax
80106809:	50                   	push   %eax
8010680a:	e8 81 f3 ff ff       	call   80105b90 <fetchint>
8010680f:	83 c4 10             	add    $0x10,%esp
80106812:	85 c0                	test   %eax,%eax
80106814:	78 26                	js     8010683c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106816:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010681c:	85 c0                	test   %eax,%eax
8010681e:	74 30                	je     80106850 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106820:	83 ec 08             	sub    $0x8,%esp
80106823:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106826:	52                   	push   %edx
80106827:	50                   	push   %eax
80106828:	e8 a3 f3 ff ff       	call   80105bd0 <fetchstr>
8010682d:	83 c4 10             	add    $0x10,%esp
80106830:	85 c0                	test   %eax,%eax
80106832:	78 08                	js     8010683c <sys_exec+0xac>
  for(i=0;; i++){
80106834:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106837:	83 fb 20             	cmp    $0x20,%ebx
8010683a:	75 b4                	jne    801067f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010683c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010683f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106844:	5b                   	pop    %ebx
80106845:	5e                   	pop    %esi
80106846:	5f                   	pop    %edi
80106847:	5d                   	pop    %ebp
80106848:	c3                   	ret
80106849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106850:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106857:	00 00 00 00 
  return exec(path, argv);
8010685b:	83 ec 08             	sub    $0x8,%esp
8010685e:	56                   	push   %esi
8010685f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106865:	e8 16 b5 ff ff       	call   80101d80 <exec>
8010686a:	83 c4 10             	add    $0x10,%esp
}
8010686d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106870:	5b                   	pop    %ebx
80106871:	5e                   	pop    %esi
80106872:	5f                   	pop    %edi
80106873:	5d                   	pop    %ebp
80106874:	c3                   	ret
80106875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010687c:	00 
8010687d:	8d 76 00             	lea    0x0(%esi),%esi

80106880 <sys_pipe>:

int
sys_pipe(void)
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106885:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106888:	53                   	push   %ebx
80106889:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010688c:	6a 08                	push   $0x8
8010688e:	50                   	push   %eax
8010688f:	6a 00                	push   $0x0
80106891:	e8 da f3 ff ff       	call   80105c70 <argptr>
80106896:	83 c4 10             	add    $0x10,%esp
80106899:	85 c0                	test   %eax,%eax
8010689b:	0f 88 8b 00 00 00    	js     8010692c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801068a1:	83 ec 08             	sub    $0x8,%esp
801068a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068a7:	50                   	push   %eax
801068a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801068ab:	50                   	push   %eax
801068ac:	e8 2f de ff ff       	call   801046e0 <pipealloc>
801068b1:	83 c4 10             	add    $0x10,%esp
801068b4:	85 c0                	test   %eax,%eax
801068b6:	78 74                	js     8010692c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801068bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801068bd:	e8 6e e3 ff ff       	call   80104c30 <myproc>
    if(curproc->ofile[fd] == 0){
801068c2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068c6:	85 f6                	test   %esi,%esi
801068c8:	74 16                	je     801068e0 <sys_pipe+0x60>
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801068d0:	83 c3 01             	add    $0x1,%ebx
801068d3:	83 fb 10             	cmp    $0x10,%ebx
801068d6:	74 3d                	je     80106915 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801068d8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801068dc:	85 f6                	test   %esi,%esi
801068de:	75 f0                	jne    801068d0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801068e0:	8d 73 08             	lea    0x8(%ebx),%esi
801068e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801068ea:	e8 41 e3 ff ff       	call   80104c30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801068ef:	31 d2                	xor    %edx,%edx
801068f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801068f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801068fc:	85 c9                	test   %ecx,%ecx
801068fe:	74 38                	je     80106938 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80106900:	83 c2 01             	add    $0x1,%edx
80106903:	83 fa 10             	cmp    $0x10,%edx
80106906:	75 f0                	jne    801068f8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106908:	e8 23 e3 ff ff       	call   80104c30 <myproc>
8010690d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106914:	00 
    fileclose(rf);
80106915:	83 ec 0c             	sub    $0xc,%esp
80106918:	ff 75 e0             	push   -0x20(%ebp)
8010691b:	e8 c0 b8 ff ff       	call   801021e0 <fileclose>
    fileclose(wf);
80106920:	58                   	pop    %eax
80106921:	ff 75 e4             	push   -0x1c(%ebp)
80106924:	e8 b7 b8 ff ff       	call   801021e0 <fileclose>
    return -1;
80106929:	83 c4 10             	add    $0x10,%esp
    return -1;
8010692c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106931:	eb 16                	jmp    80106949 <sys_pipe+0xc9>
80106933:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106938:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010693c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010693f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106941:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106944:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106947:	31 c0                	xor    %eax,%eax
}
80106949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010694c:	5b                   	pop    %ebx
8010694d:	5e                   	pop    %esi
8010694e:	5f                   	pop    %edi
8010694f:	5d                   	pop    %ebp
80106950:	c3                   	ret
80106951:	66 90                	xchg   %ax,%ax
80106953:	66 90                	xchg   %ax,%ax
80106955:	66 90                	xchg   %ax,%ax
80106957:	66 90                	xchg   %ax,%ax
80106959:	66 90                	xchg   %ax,%ax
8010695b:	66 90                	xchg   %ax,%ax
8010695d:	66 90                	xchg   %ax,%ax
8010695f:	90                   	nop

80106960 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106960:	e9 6b e4 ff ff       	jmp    80104dd0 <fork>
80106965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010696c:	00 
8010696d:	8d 76 00             	lea    0x0(%esi),%esi

80106970 <sys_exit>:
}

int
sys_exit(void)
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	83 ec 08             	sub    $0x8,%esp
  exit();
80106976:	e8 c5 e6 ff ff       	call   80105040 <exit>
  return 0;  // not reached
}
8010697b:	31 c0                	xor    %eax,%eax
8010697d:	c9                   	leave
8010697e:	c3                   	ret
8010697f:	90                   	nop

80106980 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106980:	e9 eb e7 ff ff       	jmp    80105170 <wait>
80106985:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010698c:	00 
8010698d:	8d 76 00             	lea    0x0(%esi),%esi

80106990 <sys_kill>:
}

int
sys_kill(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106999:	50                   	push   %eax
8010699a:	6a 00                	push   $0x0
8010699c:	e8 7f f2 ff ff       	call   80105c20 <argint>
801069a1:	83 c4 10             	add    $0x10,%esp
801069a4:	85 c0                	test   %eax,%eax
801069a6:	78 18                	js     801069c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801069a8:	83 ec 0c             	sub    $0xc,%esp
801069ab:	ff 75 f4             	push   -0xc(%ebp)
801069ae:	e8 5d ea ff ff       	call   80105410 <kill>
801069b3:	83 c4 10             	add    $0x10,%esp
}
801069b6:	c9                   	leave
801069b7:	c3                   	ret
801069b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069bf:	00 
801069c0:	c9                   	leave
    return -1;
801069c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069c6:	c3                   	ret
801069c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069ce:	00 
801069cf:	90                   	nop

801069d0 <sys_getpid>:

int
sys_getpid(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801069d6:	e8 55 e2 ff ff       	call   80104c30 <myproc>
801069db:	8b 40 10             	mov    0x10(%eax),%eax
}
801069de:	c9                   	leave
801069df:	c3                   	ret

801069e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801069e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801069ea:	50                   	push   %eax
801069eb:	6a 00                	push   $0x0
801069ed:	e8 2e f2 ff ff       	call   80105c20 <argint>
801069f2:	83 c4 10             	add    $0x10,%esp
801069f5:	85 c0                	test   %eax,%eax
801069f7:	78 27                	js     80106a20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801069f9:	e8 32 e2 ff ff       	call   80104c30 <myproc>
  if(growproc(n) < 0)
801069fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106a01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106a03:	ff 75 f4             	push   -0xc(%ebp)
80106a06:	e8 45 e3 ff ff       	call   80104d50 <growproc>
80106a0b:	83 c4 10             	add    $0x10,%esp
80106a0e:	85 c0                	test   %eax,%eax
80106a10:	78 0e                	js     80106a20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106a12:	89 d8                	mov    %ebx,%eax
80106a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a17:	c9                   	leave
80106a18:	c3                   	ret
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106a20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a25:	eb eb                	jmp    80106a12 <sys_sbrk+0x32>
80106a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a2e:	00 
80106a2f:	90                   	nop

80106a30 <sys_sleep>:

int
sys_sleep(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106a3a:	50                   	push   %eax
80106a3b:	6a 00                	push   $0x0
80106a3d:	e8 de f1 ff ff       	call   80105c20 <argint>
80106a42:	83 c4 10             	add    $0x10,%esp
80106a45:	85 c0                	test   %eax,%eax
80106a47:	78 64                	js     80106aad <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80106a49:	83 ec 0c             	sub    $0xc,%esp
80106a4c:	68 00 4f 11 80       	push   $0x80114f00
80106a51:	e8 1a ee ff ff       	call   80105870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106a59:	8b 1d e0 4e 11 80    	mov    0x80114ee0,%ebx
  while(ticks - ticks0 < n){
80106a5f:	83 c4 10             	add    $0x10,%esp
80106a62:	85 d2                	test   %edx,%edx
80106a64:	75 2b                	jne    80106a91 <sys_sleep+0x61>
80106a66:	eb 58                	jmp    80106ac0 <sys_sleep+0x90>
80106a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a6f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106a70:	83 ec 08             	sub    $0x8,%esp
80106a73:	68 00 4f 11 80       	push   $0x80114f00
80106a78:	68 e0 4e 11 80       	push   $0x80114ee0
80106a7d:	e8 6e e8 ff ff       	call   801052f0 <sleep>
  while(ticks - ticks0 < n){
80106a82:	a1 e0 4e 11 80       	mov    0x80114ee0,%eax
80106a87:	83 c4 10             	add    $0x10,%esp
80106a8a:	29 d8                	sub    %ebx,%eax
80106a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106a8f:	73 2f                	jae    80106ac0 <sys_sleep+0x90>
    if(myproc()->killed){
80106a91:	e8 9a e1 ff ff       	call   80104c30 <myproc>
80106a96:	8b 40 24             	mov    0x24(%eax),%eax
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	74 d3                	je     80106a70 <sys_sleep+0x40>
      release(&tickslock);
80106a9d:	83 ec 0c             	sub    $0xc,%esp
80106aa0:	68 00 4f 11 80       	push   $0x80114f00
80106aa5:	e8 66 ed ff ff       	call   80105810 <release>
      return -1;
80106aaa:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80106aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab5:	c9                   	leave
80106ab6:	c3                   	ret
80106ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106abe:	00 
80106abf:	90                   	nop
  release(&tickslock);
80106ac0:	83 ec 0c             	sub    $0xc,%esp
80106ac3:	68 00 4f 11 80       	push   $0x80114f00
80106ac8:	e8 43 ed ff ff       	call   80105810 <release>
}
80106acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80106ad0:	83 c4 10             	add    $0x10,%esp
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	c9                   	leave
80106ad6:	c3                   	ret
80106ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ade:	00 
80106adf:	90                   	nop

80106ae0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	53                   	push   %ebx
80106ae4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106ae7:	68 00 4f 11 80       	push   $0x80114f00
80106aec:	e8 7f ed ff ff       	call   80105870 <acquire>
  xticks = ticks;
80106af1:	8b 1d e0 4e 11 80    	mov    0x80114ee0,%ebx
  release(&tickslock);
80106af7:	c7 04 24 00 4f 11 80 	movl   $0x80114f00,(%esp)
80106afe:	e8 0d ed ff ff       	call   80105810 <release>
  return xticks;
}
80106b03:	89 d8                	mov    %ebx,%eax
80106b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b08:	c9                   	leave
80106b09:	c3                   	ret

80106b0a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106b0a:	1e                   	push   %ds
  pushl %es
80106b0b:	06                   	push   %es
  pushl %fs
80106b0c:	0f a0                	push   %fs
  pushl %gs
80106b0e:	0f a8                	push   %gs
  pushal
80106b10:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106b11:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106b15:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106b17:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106b19:	54                   	push   %esp
  call trap
80106b1a:	e8 c1 00 00 00       	call   80106be0 <trap>
  addl $4, %esp
80106b1f:	83 c4 04             	add    $0x4,%esp

80106b22 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106b22:	61                   	popa
  popl %gs
80106b23:	0f a9                	pop    %gs
  popl %fs
80106b25:	0f a1                	pop    %fs
  popl %es
80106b27:	07                   	pop    %es
  popl %ds
80106b28:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106b29:	83 c4 08             	add    $0x8,%esp
  iret
80106b2c:	cf                   	iret
80106b2d:	66 90                	xchg   %ax,%ax
80106b2f:	90                   	nop

80106b30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106b30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106b31:	31 c0                	xor    %eax,%eax
{
80106b33:	89 e5                	mov    %esp,%ebp
80106b35:	83 ec 08             	sub    $0x8,%esp
80106b38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b3f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106b40:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106b47:	c7 04 c5 42 4f 11 80 	movl   $0x8e000008,-0x7feeb0be(,%eax,8)
80106b4e:	08 00 00 8e 
80106b52:	66 89 14 c5 40 4f 11 	mov    %dx,-0x7feeb0c0(,%eax,8)
80106b59:	80 
80106b5a:	c1 ea 10             	shr    $0x10,%edx
80106b5d:	66 89 14 c5 46 4f 11 	mov    %dx,-0x7feeb0ba(,%eax,8)
80106b64:	80 
  for(i = 0; i < 256; i++)
80106b65:	83 c0 01             	add    $0x1,%eax
80106b68:	3d 00 01 00 00       	cmp    $0x100,%eax
80106b6d:	75 d1                	jne    80106b40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80106b6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b72:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106b77:	c7 05 42 51 11 80 08 	movl   $0xef000008,0x80115142
80106b7e:	00 00 ef 
  initlock(&tickslock, "time");
80106b81:	68 2e 88 10 80       	push   $0x8010882e
80106b86:	68 00 4f 11 80       	push   $0x80114f00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106b8b:	66 a3 40 51 11 80    	mov    %ax,0x80115140
80106b91:	c1 e8 10             	shr    $0x10,%eax
80106b94:	66 a3 46 51 11 80    	mov    %ax,0x80115146
  initlock(&tickslock, "time");
80106b9a:	e8 e1 ea ff ff       	call   80105680 <initlock>
}
80106b9f:	83 c4 10             	add    $0x10,%esp
80106ba2:	c9                   	leave
80106ba3:	c3                   	ret
80106ba4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bab:	00 
80106bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106bb0 <idtinit>:

void
idtinit(void)
{
80106bb0:	55                   	push   %ebp
  pd[0] = size-1;
80106bb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106bb6:	89 e5                	mov    %esp,%ebp
80106bb8:	83 ec 10             	sub    $0x10,%esp
80106bbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106bbf:	b8 40 4f 11 80       	mov    $0x80114f40,%eax
80106bc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106bc8:	c1 e8 10             	shr    $0x10,%eax
80106bcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106bcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106bd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106bd5:	c9                   	leave
80106bd6:	c3                   	ret
80106bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bde:	00 
80106bdf:	90                   	nop

80106be0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
80106be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106bec:	8b 43 30             	mov    0x30(%ebx),%eax
80106bef:	83 f8 40             	cmp    $0x40,%eax
80106bf2:	0f 84 58 01 00 00    	je     80106d50 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106bf8:	83 e8 20             	sub    $0x20,%eax
80106bfb:	83 f8 1f             	cmp    $0x1f,%eax
80106bfe:	0f 87 7c 00 00 00    	ja     80106c80 <trap+0xa0>
80106c04:	ff 24 85 f8 8d 10 80 	jmp    *-0x7fef7208(,%eax,4)
80106c0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106c10:	e8 eb c8 ff ff       	call   80103500 <ideintr>
    lapiceoi();
80106c15:	e8 a6 cf ff ff       	call   80103bc0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c1a:	e8 11 e0 ff ff       	call   80104c30 <myproc>
80106c1f:	85 c0                	test   %eax,%eax
80106c21:	74 1a                	je     80106c3d <trap+0x5d>
80106c23:	e8 08 e0 ff ff       	call   80104c30 <myproc>
80106c28:	8b 50 24             	mov    0x24(%eax),%edx
80106c2b:	85 d2                	test   %edx,%edx
80106c2d:	74 0e                	je     80106c3d <trap+0x5d>
80106c2f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c33:	f7 d0                	not    %eax
80106c35:	a8 03                	test   $0x3,%al
80106c37:	0f 84 db 01 00 00    	je     80106e18 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106c3d:	e8 ee df ff ff       	call   80104c30 <myproc>
80106c42:	85 c0                	test   %eax,%eax
80106c44:	74 0f                	je     80106c55 <trap+0x75>
80106c46:	e8 e5 df ff ff       	call   80104c30 <myproc>
80106c4b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106c4f:	0f 84 ab 00 00 00    	je     80106d00 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c55:	e8 d6 df ff ff       	call   80104c30 <myproc>
80106c5a:	85 c0                	test   %eax,%eax
80106c5c:	74 1a                	je     80106c78 <trap+0x98>
80106c5e:	e8 cd df ff ff       	call   80104c30 <myproc>
80106c63:	8b 40 24             	mov    0x24(%eax),%eax
80106c66:	85 c0                	test   %eax,%eax
80106c68:	74 0e                	je     80106c78 <trap+0x98>
80106c6a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106c6e:	f7 d0                	not    %eax
80106c70:	a8 03                	test   $0x3,%al
80106c72:	0f 84 05 01 00 00    	je     80106d7d <trap+0x19d>
    exit();
}
80106c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c7b:	5b                   	pop    %ebx
80106c7c:	5e                   	pop    %esi
80106c7d:	5f                   	pop    %edi
80106c7e:	5d                   	pop    %ebp
80106c7f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80106c80:	e8 ab df ff ff       	call   80104c30 <myproc>
80106c85:	8b 7b 38             	mov    0x38(%ebx),%edi
80106c88:	85 c0                	test   %eax,%eax
80106c8a:	0f 84 a2 01 00 00    	je     80106e32 <trap+0x252>
80106c90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106c94:	0f 84 98 01 00 00    	je     80106e32 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106c9a:	0f 20 d1             	mov    %cr2,%ecx
80106c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106ca0:	e8 6b df ff ff       	call   80104c10 <cpuid>
80106ca5:	8b 73 30             	mov    0x30(%ebx),%esi
80106ca8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cab:	8b 43 34             	mov    0x34(%ebx),%eax
80106cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106cb1:	e8 7a df ff ff       	call   80104c30 <myproc>
80106cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106cb9:	e8 72 df ff ff       	call   80104c30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106cc1:	51                   	push   %ecx
80106cc2:	57                   	push   %edi
80106cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106cc6:	52                   	push   %edx
80106cc7:	ff 75 e4             	push   -0x1c(%ebp)
80106cca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106ccb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106cce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106cd1:	56                   	push   %esi
80106cd2:	ff 70 10             	push   0x10(%eax)
80106cd5:	68 e8 8a 10 80       	push   $0x80108ae8
80106cda:	e8 51 9f ff ff       	call   80100c30 <cprintf>
    myproc()->killed = 1;
80106cdf:	83 c4 20             	add    $0x20,%esp
80106ce2:	e8 49 df ff ff       	call   80104c30 <myproc>
80106ce7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106cee:	e8 3d df ff ff       	call   80104c30 <myproc>
80106cf3:	85 c0                	test   %eax,%eax
80106cf5:	0f 85 28 ff ff ff    	jne    80106c23 <trap+0x43>
80106cfb:	e9 3d ff ff ff       	jmp    80106c3d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80106d00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106d04:	0f 85 4b ff ff ff    	jne    80106c55 <trap+0x75>
    yield();
80106d0a:	e8 91 e5 ff ff       	call   801052a0 <yield>
80106d0f:	e9 41 ff ff ff       	jmp    80106c55 <trap+0x75>
80106d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106d18:	8b 7b 38             	mov    0x38(%ebx),%edi
80106d1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106d1f:	e8 ec de ff ff       	call   80104c10 <cpuid>
80106d24:	57                   	push   %edi
80106d25:	56                   	push   %esi
80106d26:	50                   	push   %eax
80106d27:	68 90 8a 10 80       	push   $0x80108a90
80106d2c:	e8 ff 9e ff ff       	call   80100c30 <cprintf>
    lapiceoi();
80106d31:	e8 8a ce ff ff       	call   80103bc0 <lapiceoi>
    break;
80106d36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d39:	e8 f2 de ff ff       	call   80104c30 <myproc>
80106d3e:	85 c0                	test   %eax,%eax
80106d40:	0f 85 dd fe ff ff    	jne    80106c23 <trap+0x43>
80106d46:	e9 f2 fe ff ff       	jmp    80106c3d <trap+0x5d>
80106d4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106d50:	e8 db de ff ff       	call   80104c30 <myproc>
80106d55:	8b 70 24             	mov    0x24(%eax),%esi
80106d58:	85 f6                	test   %esi,%esi
80106d5a:	0f 85 c8 00 00 00    	jne    80106e28 <trap+0x248>
    myproc()->tf = tf;
80106d60:	e8 cb de ff ff       	call   80104c30 <myproc>
80106d65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106d68:	e8 f3 ef ff ff       	call   80105d60 <syscall>
    if(myproc()->killed)
80106d6d:	e8 be de ff ff       	call   80104c30 <myproc>
80106d72:	8b 48 24             	mov    0x24(%eax),%ecx
80106d75:	85 c9                	test   %ecx,%ecx
80106d77:	0f 84 fb fe ff ff    	je     80106c78 <trap+0x98>
}
80106d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d80:	5b                   	pop    %ebx
80106d81:	5e                   	pop    %esi
80106d82:	5f                   	pop    %edi
80106d83:	5d                   	pop    %ebp
      exit();
80106d84:	e9 b7 e2 ff ff       	jmp    80105040 <exit>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106d90:	e8 4b 02 00 00       	call   80106fe0 <uartintr>
    lapiceoi();
80106d95:	e8 26 ce ff ff       	call   80103bc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106d9a:	e8 91 de ff ff       	call   80104c30 <myproc>
80106d9f:	85 c0                	test   %eax,%eax
80106da1:	0f 85 7c fe ff ff    	jne    80106c23 <trap+0x43>
80106da7:	e9 91 fe ff ff       	jmp    80106c3d <trap+0x5d>
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106db0:	e8 db cc ff ff       	call   80103a90 <kbdintr>
    lapiceoi();
80106db5:	e8 06 ce ff ff       	call   80103bc0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106dba:	e8 71 de ff ff       	call   80104c30 <myproc>
80106dbf:	85 c0                	test   %eax,%eax
80106dc1:	0f 85 5c fe ff ff    	jne    80106c23 <trap+0x43>
80106dc7:	e9 71 fe ff ff       	jmp    80106c3d <trap+0x5d>
80106dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106dd0:	e8 3b de ff ff       	call   80104c10 <cpuid>
80106dd5:	85 c0                	test   %eax,%eax
80106dd7:	0f 85 38 fe ff ff    	jne    80106c15 <trap+0x35>
      acquire(&tickslock);
80106ddd:	83 ec 0c             	sub    $0xc,%esp
80106de0:	68 00 4f 11 80       	push   $0x80114f00
80106de5:	e8 86 ea ff ff       	call   80105870 <acquire>
      ticks++;
80106dea:	83 05 e0 4e 11 80 01 	addl   $0x1,0x80114ee0
      wakeup(&ticks);
80106df1:	c7 04 24 e0 4e 11 80 	movl   $0x80114ee0,(%esp)
80106df8:	e8 b3 e5 ff ff       	call   801053b0 <wakeup>
      release(&tickslock);
80106dfd:	c7 04 24 00 4f 11 80 	movl   $0x80114f00,(%esp)
80106e04:	e8 07 ea ff ff       	call   80105810 <release>
80106e09:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106e0c:	e9 04 fe ff ff       	jmp    80106c15 <trap+0x35>
80106e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106e18:	e8 23 e2 ff ff       	call   80105040 <exit>
80106e1d:	e9 1b fe ff ff       	jmp    80106c3d <trap+0x5d>
80106e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106e28:	e8 13 e2 ff ff       	call   80105040 <exit>
80106e2d:	e9 2e ff ff ff       	jmp    80106d60 <trap+0x180>
80106e32:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106e35:	e8 d6 dd ff ff       	call   80104c10 <cpuid>
80106e3a:	83 ec 0c             	sub    $0xc,%esp
80106e3d:	56                   	push   %esi
80106e3e:	57                   	push   %edi
80106e3f:	50                   	push   %eax
80106e40:	ff 73 30             	push   0x30(%ebx)
80106e43:	68 b4 8a 10 80       	push   $0x80108ab4
80106e48:	e8 e3 9d ff ff       	call   80100c30 <cprintf>
      panic("trap");
80106e4d:	83 c4 14             	add    $0x14,%esp
80106e50:	68 33 88 10 80       	push   $0x80108833
80106e55:	e8 e6 96 ff ff       	call   80100540 <panic>
80106e5a:	66 90                	xchg   %ax,%ax
80106e5c:	66 90                	xchg   %ax,%ax
80106e5e:	66 90                	xchg   %ax,%ax

80106e60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106e60:	a1 40 57 11 80       	mov    0x80115740,%eax
80106e65:	85 c0                	test   %eax,%eax
80106e67:	74 17                	je     80106e80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106e69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106e6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106e6f:	a8 01                	test   $0x1,%al
80106e71:	74 0d                	je     80106e80 <uartgetc+0x20>
80106e73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106e79:	0f b6 c0             	movzbl %al,%eax
80106e7c:	c3                   	ret
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e85:	c3                   	ret
80106e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e8d:	00 
80106e8e:	66 90                	xchg   %ax,%ax

80106e90 <uartinit>:
{
80106e90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e91:	31 c9                	xor    %ecx,%ecx
80106e93:	89 c8                	mov    %ecx,%eax
80106e95:	89 e5                	mov    %esp,%ebp
80106e97:	57                   	push   %edi
80106e98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106e9d:	56                   	push   %esi
80106e9e:	89 fa                	mov    %edi,%edx
80106ea0:	53                   	push   %ebx
80106ea1:	83 ec 1c             	sub    $0x1c,%esp
80106ea4:	ee                   	out    %al,(%dx)
80106ea5:	be fb 03 00 00       	mov    $0x3fb,%esi
80106eaa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106eaf:	89 f2                	mov    %esi,%edx
80106eb1:	ee                   	out    %al,(%dx)
80106eb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106eb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ebc:	ee                   	out    %al,(%dx)
80106ebd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106ec2:	89 c8                	mov    %ecx,%eax
80106ec4:	89 da                	mov    %ebx,%edx
80106ec6:	ee                   	out    %al,(%dx)
80106ec7:	b8 03 00 00 00       	mov    $0x3,%eax
80106ecc:	89 f2                	mov    %esi,%edx
80106ece:	ee                   	out    %al,(%dx)
80106ecf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ed4:	89 c8                	mov    %ecx,%eax
80106ed6:	ee                   	out    %al,(%dx)
80106ed7:	b8 01 00 00 00       	mov    $0x1,%eax
80106edc:	89 da                	mov    %ebx,%edx
80106ede:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106edf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ee4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ee5:	3c ff                	cmp    $0xff,%al
80106ee7:	0f 84 7c 00 00 00    	je     80106f69 <uartinit+0xd9>
  uart = 1;
80106eed:	c7 05 40 57 11 80 01 	movl   $0x1,0x80115740
80106ef4:	00 00 00 
80106ef7:	89 fa                	mov    %edi,%edx
80106ef9:	ec                   	in     (%dx),%al
80106efa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106eff:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106f00:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106f03:	bf 38 88 10 80       	mov    $0x80108838,%edi
80106f08:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106f0d:	6a 00                	push   $0x0
80106f0f:	6a 04                	push   $0x4
80106f11:	e8 1a c8 ff ff       	call   80103730 <ioapicenable>
80106f16:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106f19:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80106f1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106f20:	a1 40 57 11 80       	mov    0x80115740,%eax
80106f25:	85 c0                	test   %eax,%eax
80106f27:	74 32                	je     80106f5b <uartinit+0xcb>
80106f29:	89 f2                	mov    %esi,%edx
80106f2b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f2c:	a8 20                	test   $0x20,%al
80106f2e:	75 21                	jne    80106f51 <uartinit+0xc1>
80106f30:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f35:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106f38:	83 ec 0c             	sub    $0xc,%esp
80106f3b:	6a 0a                	push   $0xa
80106f3d:	e8 9e cc ff ff       	call   80103be0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f42:	83 c4 10             	add    $0x10,%esp
80106f45:	83 eb 01             	sub    $0x1,%ebx
80106f48:	74 07                	je     80106f51 <uartinit+0xc1>
80106f4a:	89 f2                	mov    %esi,%edx
80106f4c:	ec                   	in     (%dx),%al
80106f4d:	a8 20                	test   $0x20,%al
80106f4f:	74 e7                	je     80106f38 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106f51:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106f56:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106f5a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106f5b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106f5f:	83 c7 01             	add    $0x1,%edi
80106f62:	88 45 e7             	mov    %al,-0x19(%ebp)
80106f65:	84 c0                	test   %al,%al
80106f67:	75 b7                	jne    80106f20 <uartinit+0x90>
}
80106f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f6c:	5b                   	pop    %ebx
80106f6d:	5e                   	pop    %esi
80106f6e:	5f                   	pop    %edi
80106f6f:	5d                   	pop    %ebp
80106f70:	c3                   	ret
80106f71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f78:	00 
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f80 <uartputc>:
  if(!uart)
80106f80:	a1 40 57 11 80       	mov    0x80115740,%eax
80106f85:	85 c0                	test   %eax,%eax
80106f87:	74 4f                	je     80106fd8 <uartputc+0x58>
{
80106f89:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106f8a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106f8f:	89 e5                	mov    %esp,%ebp
80106f91:	56                   	push   %esi
80106f92:	53                   	push   %ebx
80106f93:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106f94:	a8 20                	test   $0x20,%al
80106f96:	75 29                	jne    80106fc1 <uartputc+0x41>
80106f98:	bb 80 00 00 00       	mov    $0x80,%ebx
80106f9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106fa8:	83 ec 0c             	sub    $0xc,%esp
80106fab:	6a 0a                	push   $0xa
80106fad:	e8 2e cc ff ff       	call   80103be0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106fb2:	83 c4 10             	add    $0x10,%esp
80106fb5:	83 eb 01             	sub    $0x1,%ebx
80106fb8:	74 07                	je     80106fc1 <uartputc+0x41>
80106fba:	89 f2                	mov    %esi,%edx
80106fbc:	ec                   	in     (%dx),%al
80106fbd:	a8 20                	test   $0x20,%al
80106fbf:	74 e7                	je     80106fa8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106fc9:	ee                   	out    %al,(%dx)
}
80106fca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fcd:	5b                   	pop    %ebx
80106fce:	5e                   	pop    %esi
80106fcf:	5d                   	pop    %ebp
80106fd0:	c3                   	ret
80106fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd8:	c3                   	ret
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fe0 <uartintr>:

void
uartintr(void)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106fe6:	68 60 6e 10 80       	push   $0x80106e60
80106feb:	e8 50 9e ff ff       	call   80100e40 <consoleintr>
}
80106ff0:	83 c4 10             	add    $0x10,%esp
80106ff3:	c9                   	leave
80106ff4:	c3                   	ret

80106ff5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $0
80106ff7:	6a 00                	push   $0x0
  jmp alltraps
80106ff9:	e9 0c fb ff ff       	jmp    80106b0a <alltraps>

80106ffe <vector1>:
.globl vector1
vector1:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $1
80107000:	6a 01                	push   $0x1
  jmp alltraps
80107002:	e9 03 fb ff ff       	jmp    80106b0a <alltraps>

80107007 <vector2>:
.globl vector2
vector2:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $2
80107009:	6a 02                	push   $0x2
  jmp alltraps
8010700b:	e9 fa fa ff ff       	jmp    80106b0a <alltraps>

80107010 <vector3>:
.globl vector3
vector3:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $3
80107012:	6a 03                	push   $0x3
  jmp alltraps
80107014:	e9 f1 fa ff ff       	jmp    80106b0a <alltraps>

80107019 <vector4>:
.globl vector4
vector4:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $4
8010701b:	6a 04                	push   $0x4
  jmp alltraps
8010701d:	e9 e8 fa ff ff       	jmp    80106b0a <alltraps>

80107022 <vector5>:
.globl vector5
vector5:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $5
80107024:	6a 05                	push   $0x5
  jmp alltraps
80107026:	e9 df fa ff ff       	jmp    80106b0a <alltraps>

8010702b <vector6>:
.globl vector6
vector6:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $6
8010702d:	6a 06                	push   $0x6
  jmp alltraps
8010702f:	e9 d6 fa ff ff       	jmp    80106b0a <alltraps>

80107034 <vector7>:
.globl vector7
vector7:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $7
80107036:	6a 07                	push   $0x7
  jmp alltraps
80107038:	e9 cd fa ff ff       	jmp    80106b0a <alltraps>

8010703d <vector8>:
.globl vector8
vector8:
  pushl $8
8010703d:	6a 08                	push   $0x8
  jmp alltraps
8010703f:	e9 c6 fa ff ff       	jmp    80106b0a <alltraps>

80107044 <vector9>:
.globl vector9
vector9:
  pushl $0
80107044:	6a 00                	push   $0x0
  pushl $9
80107046:	6a 09                	push   $0x9
  jmp alltraps
80107048:	e9 bd fa ff ff       	jmp    80106b0a <alltraps>

8010704d <vector10>:
.globl vector10
vector10:
  pushl $10
8010704d:	6a 0a                	push   $0xa
  jmp alltraps
8010704f:	e9 b6 fa ff ff       	jmp    80106b0a <alltraps>

80107054 <vector11>:
.globl vector11
vector11:
  pushl $11
80107054:	6a 0b                	push   $0xb
  jmp alltraps
80107056:	e9 af fa ff ff       	jmp    80106b0a <alltraps>

8010705b <vector12>:
.globl vector12
vector12:
  pushl $12
8010705b:	6a 0c                	push   $0xc
  jmp alltraps
8010705d:	e9 a8 fa ff ff       	jmp    80106b0a <alltraps>

80107062 <vector13>:
.globl vector13
vector13:
  pushl $13
80107062:	6a 0d                	push   $0xd
  jmp alltraps
80107064:	e9 a1 fa ff ff       	jmp    80106b0a <alltraps>

80107069 <vector14>:
.globl vector14
vector14:
  pushl $14
80107069:	6a 0e                	push   $0xe
  jmp alltraps
8010706b:	e9 9a fa ff ff       	jmp    80106b0a <alltraps>

80107070 <vector15>:
.globl vector15
vector15:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $15
80107072:	6a 0f                	push   $0xf
  jmp alltraps
80107074:	e9 91 fa ff ff       	jmp    80106b0a <alltraps>

80107079 <vector16>:
.globl vector16
vector16:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $16
8010707b:	6a 10                	push   $0x10
  jmp alltraps
8010707d:	e9 88 fa ff ff       	jmp    80106b0a <alltraps>

80107082 <vector17>:
.globl vector17
vector17:
  pushl $17
80107082:	6a 11                	push   $0x11
  jmp alltraps
80107084:	e9 81 fa ff ff       	jmp    80106b0a <alltraps>

80107089 <vector18>:
.globl vector18
vector18:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $18
8010708b:	6a 12                	push   $0x12
  jmp alltraps
8010708d:	e9 78 fa ff ff       	jmp    80106b0a <alltraps>

80107092 <vector19>:
.globl vector19
vector19:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $19
80107094:	6a 13                	push   $0x13
  jmp alltraps
80107096:	e9 6f fa ff ff       	jmp    80106b0a <alltraps>

8010709b <vector20>:
.globl vector20
vector20:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $20
8010709d:	6a 14                	push   $0x14
  jmp alltraps
8010709f:	e9 66 fa ff ff       	jmp    80106b0a <alltraps>

801070a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $21
801070a6:	6a 15                	push   $0x15
  jmp alltraps
801070a8:	e9 5d fa ff ff       	jmp    80106b0a <alltraps>

801070ad <vector22>:
.globl vector22
vector22:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $22
801070af:	6a 16                	push   $0x16
  jmp alltraps
801070b1:	e9 54 fa ff ff       	jmp    80106b0a <alltraps>

801070b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $23
801070b8:	6a 17                	push   $0x17
  jmp alltraps
801070ba:	e9 4b fa ff ff       	jmp    80106b0a <alltraps>

801070bf <vector24>:
.globl vector24
vector24:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $24
801070c1:	6a 18                	push   $0x18
  jmp alltraps
801070c3:	e9 42 fa ff ff       	jmp    80106b0a <alltraps>

801070c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $25
801070ca:	6a 19                	push   $0x19
  jmp alltraps
801070cc:	e9 39 fa ff ff       	jmp    80106b0a <alltraps>

801070d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $26
801070d3:	6a 1a                	push   $0x1a
  jmp alltraps
801070d5:	e9 30 fa ff ff       	jmp    80106b0a <alltraps>

801070da <vector27>:
.globl vector27
vector27:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $27
801070dc:	6a 1b                	push   $0x1b
  jmp alltraps
801070de:	e9 27 fa ff ff       	jmp    80106b0a <alltraps>

801070e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $28
801070e5:	6a 1c                	push   $0x1c
  jmp alltraps
801070e7:	e9 1e fa ff ff       	jmp    80106b0a <alltraps>

801070ec <vector29>:
.globl vector29
vector29:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $29
801070ee:	6a 1d                	push   $0x1d
  jmp alltraps
801070f0:	e9 15 fa ff ff       	jmp    80106b0a <alltraps>

801070f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $30
801070f7:	6a 1e                	push   $0x1e
  jmp alltraps
801070f9:	e9 0c fa ff ff       	jmp    80106b0a <alltraps>

801070fe <vector31>:
.globl vector31
vector31:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $31
80107100:	6a 1f                	push   $0x1f
  jmp alltraps
80107102:	e9 03 fa ff ff       	jmp    80106b0a <alltraps>

80107107 <vector32>:
.globl vector32
vector32:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $32
80107109:	6a 20                	push   $0x20
  jmp alltraps
8010710b:	e9 fa f9 ff ff       	jmp    80106b0a <alltraps>

80107110 <vector33>:
.globl vector33
vector33:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $33
80107112:	6a 21                	push   $0x21
  jmp alltraps
80107114:	e9 f1 f9 ff ff       	jmp    80106b0a <alltraps>

80107119 <vector34>:
.globl vector34
vector34:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $34
8010711b:	6a 22                	push   $0x22
  jmp alltraps
8010711d:	e9 e8 f9 ff ff       	jmp    80106b0a <alltraps>

80107122 <vector35>:
.globl vector35
vector35:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $35
80107124:	6a 23                	push   $0x23
  jmp alltraps
80107126:	e9 df f9 ff ff       	jmp    80106b0a <alltraps>

8010712b <vector36>:
.globl vector36
vector36:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $36
8010712d:	6a 24                	push   $0x24
  jmp alltraps
8010712f:	e9 d6 f9 ff ff       	jmp    80106b0a <alltraps>

80107134 <vector37>:
.globl vector37
vector37:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $37
80107136:	6a 25                	push   $0x25
  jmp alltraps
80107138:	e9 cd f9 ff ff       	jmp    80106b0a <alltraps>

8010713d <vector38>:
.globl vector38
vector38:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $38
8010713f:	6a 26                	push   $0x26
  jmp alltraps
80107141:	e9 c4 f9 ff ff       	jmp    80106b0a <alltraps>

80107146 <vector39>:
.globl vector39
vector39:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $39
80107148:	6a 27                	push   $0x27
  jmp alltraps
8010714a:	e9 bb f9 ff ff       	jmp    80106b0a <alltraps>

8010714f <vector40>:
.globl vector40
vector40:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $40
80107151:	6a 28                	push   $0x28
  jmp alltraps
80107153:	e9 b2 f9 ff ff       	jmp    80106b0a <alltraps>

80107158 <vector41>:
.globl vector41
vector41:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $41
8010715a:	6a 29                	push   $0x29
  jmp alltraps
8010715c:	e9 a9 f9 ff ff       	jmp    80106b0a <alltraps>

80107161 <vector42>:
.globl vector42
vector42:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $42
80107163:	6a 2a                	push   $0x2a
  jmp alltraps
80107165:	e9 a0 f9 ff ff       	jmp    80106b0a <alltraps>

8010716a <vector43>:
.globl vector43
vector43:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $43
8010716c:	6a 2b                	push   $0x2b
  jmp alltraps
8010716e:	e9 97 f9 ff ff       	jmp    80106b0a <alltraps>

80107173 <vector44>:
.globl vector44
vector44:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $44
80107175:	6a 2c                	push   $0x2c
  jmp alltraps
80107177:	e9 8e f9 ff ff       	jmp    80106b0a <alltraps>

8010717c <vector45>:
.globl vector45
vector45:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $45
8010717e:	6a 2d                	push   $0x2d
  jmp alltraps
80107180:	e9 85 f9 ff ff       	jmp    80106b0a <alltraps>

80107185 <vector46>:
.globl vector46
vector46:
  pushl $0
80107185:	6a 00                	push   $0x0
  pushl $46
80107187:	6a 2e                	push   $0x2e
  jmp alltraps
80107189:	e9 7c f9 ff ff       	jmp    80106b0a <alltraps>

8010718e <vector47>:
.globl vector47
vector47:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $47
80107190:	6a 2f                	push   $0x2f
  jmp alltraps
80107192:	e9 73 f9 ff ff       	jmp    80106b0a <alltraps>

80107197 <vector48>:
.globl vector48
vector48:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $48
80107199:	6a 30                	push   $0x30
  jmp alltraps
8010719b:	e9 6a f9 ff ff       	jmp    80106b0a <alltraps>

801071a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $49
801071a2:	6a 31                	push   $0x31
  jmp alltraps
801071a4:	e9 61 f9 ff ff       	jmp    80106b0a <alltraps>

801071a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801071a9:	6a 00                	push   $0x0
  pushl $50
801071ab:	6a 32                	push   $0x32
  jmp alltraps
801071ad:	e9 58 f9 ff ff       	jmp    80106b0a <alltraps>

801071b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $51
801071b4:	6a 33                	push   $0x33
  jmp alltraps
801071b6:	e9 4f f9 ff ff       	jmp    80106b0a <alltraps>

801071bb <vector52>:
.globl vector52
vector52:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $52
801071bd:	6a 34                	push   $0x34
  jmp alltraps
801071bf:	e9 46 f9 ff ff       	jmp    80106b0a <alltraps>

801071c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $53
801071c6:	6a 35                	push   $0x35
  jmp alltraps
801071c8:	e9 3d f9 ff ff       	jmp    80106b0a <alltraps>

801071cd <vector54>:
.globl vector54
vector54:
  pushl $0
801071cd:	6a 00                	push   $0x0
  pushl $54
801071cf:	6a 36                	push   $0x36
  jmp alltraps
801071d1:	e9 34 f9 ff ff       	jmp    80106b0a <alltraps>

801071d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $55
801071d8:	6a 37                	push   $0x37
  jmp alltraps
801071da:	e9 2b f9 ff ff       	jmp    80106b0a <alltraps>

801071df <vector56>:
.globl vector56
vector56:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $56
801071e1:	6a 38                	push   $0x38
  jmp alltraps
801071e3:	e9 22 f9 ff ff       	jmp    80106b0a <alltraps>

801071e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $57
801071ea:	6a 39                	push   $0x39
  jmp alltraps
801071ec:	e9 19 f9 ff ff       	jmp    80106b0a <alltraps>

801071f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801071f1:	6a 00                	push   $0x0
  pushl $58
801071f3:	6a 3a                	push   $0x3a
  jmp alltraps
801071f5:	e9 10 f9 ff ff       	jmp    80106b0a <alltraps>

801071fa <vector59>:
.globl vector59
vector59:
  pushl $0
801071fa:	6a 00                	push   $0x0
  pushl $59
801071fc:	6a 3b                	push   $0x3b
  jmp alltraps
801071fe:	e9 07 f9 ff ff       	jmp    80106b0a <alltraps>

80107203 <vector60>:
.globl vector60
vector60:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $60
80107205:	6a 3c                	push   $0x3c
  jmp alltraps
80107207:	e9 fe f8 ff ff       	jmp    80106b0a <alltraps>

8010720c <vector61>:
.globl vector61
vector61:
  pushl $0
8010720c:	6a 00                	push   $0x0
  pushl $61
8010720e:	6a 3d                	push   $0x3d
  jmp alltraps
80107210:	e9 f5 f8 ff ff       	jmp    80106b0a <alltraps>

80107215 <vector62>:
.globl vector62
vector62:
  pushl $0
80107215:	6a 00                	push   $0x0
  pushl $62
80107217:	6a 3e                	push   $0x3e
  jmp alltraps
80107219:	e9 ec f8 ff ff       	jmp    80106b0a <alltraps>

8010721e <vector63>:
.globl vector63
vector63:
  pushl $0
8010721e:	6a 00                	push   $0x0
  pushl $63
80107220:	6a 3f                	push   $0x3f
  jmp alltraps
80107222:	e9 e3 f8 ff ff       	jmp    80106b0a <alltraps>

80107227 <vector64>:
.globl vector64
vector64:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $64
80107229:	6a 40                	push   $0x40
  jmp alltraps
8010722b:	e9 da f8 ff ff       	jmp    80106b0a <alltraps>

80107230 <vector65>:
.globl vector65
vector65:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $65
80107232:	6a 41                	push   $0x41
  jmp alltraps
80107234:	e9 d1 f8 ff ff       	jmp    80106b0a <alltraps>

80107239 <vector66>:
.globl vector66
vector66:
  pushl $0
80107239:	6a 00                	push   $0x0
  pushl $66
8010723b:	6a 42                	push   $0x42
  jmp alltraps
8010723d:	e9 c8 f8 ff ff       	jmp    80106b0a <alltraps>

80107242 <vector67>:
.globl vector67
vector67:
  pushl $0
80107242:	6a 00                	push   $0x0
  pushl $67
80107244:	6a 43                	push   $0x43
  jmp alltraps
80107246:	e9 bf f8 ff ff       	jmp    80106b0a <alltraps>

8010724b <vector68>:
.globl vector68
vector68:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $68
8010724d:	6a 44                	push   $0x44
  jmp alltraps
8010724f:	e9 b6 f8 ff ff       	jmp    80106b0a <alltraps>

80107254 <vector69>:
.globl vector69
vector69:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $69
80107256:	6a 45                	push   $0x45
  jmp alltraps
80107258:	e9 ad f8 ff ff       	jmp    80106b0a <alltraps>

8010725d <vector70>:
.globl vector70
vector70:
  pushl $0
8010725d:	6a 00                	push   $0x0
  pushl $70
8010725f:	6a 46                	push   $0x46
  jmp alltraps
80107261:	e9 a4 f8 ff ff       	jmp    80106b0a <alltraps>

80107266 <vector71>:
.globl vector71
vector71:
  pushl $0
80107266:	6a 00                	push   $0x0
  pushl $71
80107268:	6a 47                	push   $0x47
  jmp alltraps
8010726a:	e9 9b f8 ff ff       	jmp    80106b0a <alltraps>

8010726f <vector72>:
.globl vector72
vector72:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $72
80107271:	6a 48                	push   $0x48
  jmp alltraps
80107273:	e9 92 f8 ff ff       	jmp    80106b0a <alltraps>

80107278 <vector73>:
.globl vector73
vector73:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $73
8010727a:	6a 49                	push   $0x49
  jmp alltraps
8010727c:	e9 89 f8 ff ff       	jmp    80106b0a <alltraps>

80107281 <vector74>:
.globl vector74
vector74:
  pushl $0
80107281:	6a 00                	push   $0x0
  pushl $74
80107283:	6a 4a                	push   $0x4a
  jmp alltraps
80107285:	e9 80 f8 ff ff       	jmp    80106b0a <alltraps>

8010728a <vector75>:
.globl vector75
vector75:
  pushl $0
8010728a:	6a 00                	push   $0x0
  pushl $75
8010728c:	6a 4b                	push   $0x4b
  jmp alltraps
8010728e:	e9 77 f8 ff ff       	jmp    80106b0a <alltraps>

80107293 <vector76>:
.globl vector76
vector76:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $76
80107295:	6a 4c                	push   $0x4c
  jmp alltraps
80107297:	e9 6e f8 ff ff       	jmp    80106b0a <alltraps>

8010729c <vector77>:
.globl vector77
vector77:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $77
8010729e:	6a 4d                	push   $0x4d
  jmp alltraps
801072a0:	e9 65 f8 ff ff       	jmp    80106b0a <alltraps>

801072a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801072a5:	6a 00                	push   $0x0
  pushl $78
801072a7:	6a 4e                	push   $0x4e
  jmp alltraps
801072a9:	e9 5c f8 ff ff       	jmp    80106b0a <alltraps>

801072ae <vector79>:
.globl vector79
vector79:
  pushl $0
801072ae:	6a 00                	push   $0x0
  pushl $79
801072b0:	6a 4f                	push   $0x4f
  jmp alltraps
801072b2:	e9 53 f8 ff ff       	jmp    80106b0a <alltraps>

801072b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $80
801072b9:	6a 50                	push   $0x50
  jmp alltraps
801072bb:	e9 4a f8 ff ff       	jmp    80106b0a <alltraps>

801072c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $81
801072c2:	6a 51                	push   $0x51
  jmp alltraps
801072c4:	e9 41 f8 ff ff       	jmp    80106b0a <alltraps>

801072c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801072c9:	6a 00                	push   $0x0
  pushl $82
801072cb:	6a 52                	push   $0x52
  jmp alltraps
801072cd:	e9 38 f8 ff ff       	jmp    80106b0a <alltraps>

801072d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801072d2:	6a 00                	push   $0x0
  pushl $83
801072d4:	6a 53                	push   $0x53
  jmp alltraps
801072d6:	e9 2f f8 ff ff       	jmp    80106b0a <alltraps>

801072db <vector84>:
.globl vector84
vector84:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $84
801072dd:	6a 54                	push   $0x54
  jmp alltraps
801072df:	e9 26 f8 ff ff       	jmp    80106b0a <alltraps>

801072e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $85
801072e6:	6a 55                	push   $0x55
  jmp alltraps
801072e8:	e9 1d f8 ff ff       	jmp    80106b0a <alltraps>

801072ed <vector86>:
.globl vector86
vector86:
  pushl $0
801072ed:	6a 00                	push   $0x0
  pushl $86
801072ef:	6a 56                	push   $0x56
  jmp alltraps
801072f1:	e9 14 f8 ff ff       	jmp    80106b0a <alltraps>

801072f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801072f6:	6a 00                	push   $0x0
  pushl $87
801072f8:	6a 57                	push   $0x57
  jmp alltraps
801072fa:	e9 0b f8 ff ff       	jmp    80106b0a <alltraps>

801072ff <vector88>:
.globl vector88
vector88:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $88
80107301:	6a 58                	push   $0x58
  jmp alltraps
80107303:	e9 02 f8 ff ff       	jmp    80106b0a <alltraps>

80107308 <vector89>:
.globl vector89
vector89:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $89
8010730a:	6a 59                	push   $0x59
  jmp alltraps
8010730c:	e9 f9 f7 ff ff       	jmp    80106b0a <alltraps>

80107311 <vector90>:
.globl vector90
vector90:
  pushl $0
80107311:	6a 00                	push   $0x0
  pushl $90
80107313:	6a 5a                	push   $0x5a
  jmp alltraps
80107315:	e9 f0 f7 ff ff       	jmp    80106b0a <alltraps>

8010731a <vector91>:
.globl vector91
vector91:
  pushl $0
8010731a:	6a 00                	push   $0x0
  pushl $91
8010731c:	6a 5b                	push   $0x5b
  jmp alltraps
8010731e:	e9 e7 f7 ff ff       	jmp    80106b0a <alltraps>

80107323 <vector92>:
.globl vector92
vector92:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $92
80107325:	6a 5c                	push   $0x5c
  jmp alltraps
80107327:	e9 de f7 ff ff       	jmp    80106b0a <alltraps>

8010732c <vector93>:
.globl vector93
vector93:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $93
8010732e:	6a 5d                	push   $0x5d
  jmp alltraps
80107330:	e9 d5 f7 ff ff       	jmp    80106b0a <alltraps>

80107335 <vector94>:
.globl vector94
vector94:
  pushl $0
80107335:	6a 00                	push   $0x0
  pushl $94
80107337:	6a 5e                	push   $0x5e
  jmp alltraps
80107339:	e9 cc f7 ff ff       	jmp    80106b0a <alltraps>

8010733e <vector95>:
.globl vector95
vector95:
  pushl $0
8010733e:	6a 00                	push   $0x0
  pushl $95
80107340:	6a 5f                	push   $0x5f
  jmp alltraps
80107342:	e9 c3 f7 ff ff       	jmp    80106b0a <alltraps>

80107347 <vector96>:
.globl vector96
vector96:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $96
80107349:	6a 60                	push   $0x60
  jmp alltraps
8010734b:	e9 ba f7 ff ff       	jmp    80106b0a <alltraps>

80107350 <vector97>:
.globl vector97
vector97:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $97
80107352:	6a 61                	push   $0x61
  jmp alltraps
80107354:	e9 b1 f7 ff ff       	jmp    80106b0a <alltraps>

80107359 <vector98>:
.globl vector98
vector98:
  pushl $0
80107359:	6a 00                	push   $0x0
  pushl $98
8010735b:	6a 62                	push   $0x62
  jmp alltraps
8010735d:	e9 a8 f7 ff ff       	jmp    80106b0a <alltraps>

80107362 <vector99>:
.globl vector99
vector99:
  pushl $0
80107362:	6a 00                	push   $0x0
  pushl $99
80107364:	6a 63                	push   $0x63
  jmp alltraps
80107366:	e9 9f f7 ff ff       	jmp    80106b0a <alltraps>

8010736b <vector100>:
.globl vector100
vector100:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $100
8010736d:	6a 64                	push   $0x64
  jmp alltraps
8010736f:	e9 96 f7 ff ff       	jmp    80106b0a <alltraps>

80107374 <vector101>:
.globl vector101
vector101:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $101
80107376:	6a 65                	push   $0x65
  jmp alltraps
80107378:	e9 8d f7 ff ff       	jmp    80106b0a <alltraps>

8010737d <vector102>:
.globl vector102
vector102:
  pushl $0
8010737d:	6a 00                	push   $0x0
  pushl $102
8010737f:	6a 66                	push   $0x66
  jmp alltraps
80107381:	e9 84 f7 ff ff       	jmp    80106b0a <alltraps>

80107386 <vector103>:
.globl vector103
vector103:
  pushl $0
80107386:	6a 00                	push   $0x0
  pushl $103
80107388:	6a 67                	push   $0x67
  jmp alltraps
8010738a:	e9 7b f7 ff ff       	jmp    80106b0a <alltraps>

8010738f <vector104>:
.globl vector104
vector104:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $104
80107391:	6a 68                	push   $0x68
  jmp alltraps
80107393:	e9 72 f7 ff ff       	jmp    80106b0a <alltraps>

80107398 <vector105>:
.globl vector105
vector105:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $105
8010739a:	6a 69                	push   $0x69
  jmp alltraps
8010739c:	e9 69 f7 ff ff       	jmp    80106b0a <alltraps>

801073a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801073a1:	6a 00                	push   $0x0
  pushl $106
801073a3:	6a 6a                	push   $0x6a
  jmp alltraps
801073a5:	e9 60 f7 ff ff       	jmp    80106b0a <alltraps>

801073aa <vector107>:
.globl vector107
vector107:
  pushl $0
801073aa:	6a 00                	push   $0x0
  pushl $107
801073ac:	6a 6b                	push   $0x6b
  jmp alltraps
801073ae:	e9 57 f7 ff ff       	jmp    80106b0a <alltraps>

801073b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $108
801073b5:	6a 6c                	push   $0x6c
  jmp alltraps
801073b7:	e9 4e f7 ff ff       	jmp    80106b0a <alltraps>

801073bc <vector109>:
.globl vector109
vector109:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $109
801073be:	6a 6d                	push   $0x6d
  jmp alltraps
801073c0:	e9 45 f7 ff ff       	jmp    80106b0a <alltraps>

801073c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801073c5:	6a 00                	push   $0x0
  pushl $110
801073c7:	6a 6e                	push   $0x6e
  jmp alltraps
801073c9:	e9 3c f7 ff ff       	jmp    80106b0a <alltraps>

801073ce <vector111>:
.globl vector111
vector111:
  pushl $0
801073ce:	6a 00                	push   $0x0
  pushl $111
801073d0:	6a 6f                	push   $0x6f
  jmp alltraps
801073d2:	e9 33 f7 ff ff       	jmp    80106b0a <alltraps>

801073d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $112
801073d9:	6a 70                	push   $0x70
  jmp alltraps
801073db:	e9 2a f7 ff ff       	jmp    80106b0a <alltraps>

801073e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $113
801073e2:	6a 71                	push   $0x71
  jmp alltraps
801073e4:	e9 21 f7 ff ff       	jmp    80106b0a <alltraps>

801073e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801073e9:	6a 00                	push   $0x0
  pushl $114
801073eb:	6a 72                	push   $0x72
  jmp alltraps
801073ed:	e9 18 f7 ff ff       	jmp    80106b0a <alltraps>

801073f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801073f2:	6a 00                	push   $0x0
  pushl $115
801073f4:	6a 73                	push   $0x73
  jmp alltraps
801073f6:	e9 0f f7 ff ff       	jmp    80106b0a <alltraps>

801073fb <vector116>:
.globl vector116
vector116:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $116
801073fd:	6a 74                	push   $0x74
  jmp alltraps
801073ff:	e9 06 f7 ff ff       	jmp    80106b0a <alltraps>

80107404 <vector117>:
.globl vector117
vector117:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $117
80107406:	6a 75                	push   $0x75
  jmp alltraps
80107408:	e9 fd f6 ff ff       	jmp    80106b0a <alltraps>

8010740d <vector118>:
.globl vector118
vector118:
  pushl $0
8010740d:	6a 00                	push   $0x0
  pushl $118
8010740f:	6a 76                	push   $0x76
  jmp alltraps
80107411:	e9 f4 f6 ff ff       	jmp    80106b0a <alltraps>

80107416 <vector119>:
.globl vector119
vector119:
  pushl $0
80107416:	6a 00                	push   $0x0
  pushl $119
80107418:	6a 77                	push   $0x77
  jmp alltraps
8010741a:	e9 eb f6 ff ff       	jmp    80106b0a <alltraps>

8010741f <vector120>:
.globl vector120
vector120:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $120
80107421:	6a 78                	push   $0x78
  jmp alltraps
80107423:	e9 e2 f6 ff ff       	jmp    80106b0a <alltraps>

80107428 <vector121>:
.globl vector121
vector121:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $121
8010742a:	6a 79                	push   $0x79
  jmp alltraps
8010742c:	e9 d9 f6 ff ff       	jmp    80106b0a <alltraps>

80107431 <vector122>:
.globl vector122
vector122:
  pushl $0
80107431:	6a 00                	push   $0x0
  pushl $122
80107433:	6a 7a                	push   $0x7a
  jmp alltraps
80107435:	e9 d0 f6 ff ff       	jmp    80106b0a <alltraps>

8010743a <vector123>:
.globl vector123
vector123:
  pushl $0
8010743a:	6a 00                	push   $0x0
  pushl $123
8010743c:	6a 7b                	push   $0x7b
  jmp alltraps
8010743e:	e9 c7 f6 ff ff       	jmp    80106b0a <alltraps>

80107443 <vector124>:
.globl vector124
vector124:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $124
80107445:	6a 7c                	push   $0x7c
  jmp alltraps
80107447:	e9 be f6 ff ff       	jmp    80106b0a <alltraps>

8010744c <vector125>:
.globl vector125
vector125:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $125
8010744e:	6a 7d                	push   $0x7d
  jmp alltraps
80107450:	e9 b5 f6 ff ff       	jmp    80106b0a <alltraps>

80107455 <vector126>:
.globl vector126
vector126:
  pushl $0
80107455:	6a 00                	push   $0x0
  pushl $126
80107457:	6a 7e                	push   $0x7e
  jmp alltraps
80107459:	e9 ac f6 ff ff       	jmp    80106b0a <alltraps>

8010745e <vector127>:
.globl vector127
vector127:
  pushl $0
8010745e:	6a 00                	push   $0x0
  pushl $127
80107460:	6a 7f                	push   $0x7f
  jmp alltraps
80107462:	e9 a3 f6 ff ff       	jmp    80106b0a <alltraps>

80107467 <vector128>:
.globl vector128
vector128:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $128
80107469:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010746e:	e9 97 f6 ff ff       	jmp    80106b0a <alltraps>

80107473 <vector129>:
.globl vector129
vector129:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $129
80107475:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010747a:	e9 8b f6 ff ff       	jmp    80106b0a <alltraps>

8010747f <vector130>:
.globl vector130
vector130:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $130
80107481:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107486:	e9 7f f6 ff ff       	jmp    80106b0a <alltraps>

8010748b <vector131>:
.globl vector131
vector131:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $131
8010748d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107492:	e9 73 f6 ff ff       	jmp    80106b0a <alltraps>

80107497 <vector132>:
.globl vector132
vector132:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $132
80107499:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010749e:	e9 67 f6 ff ff       	jmp    80106b0a <alltraps>

801074a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $133
801074a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801074aa:	e9 5b f6 ff ff       	jmp    80106b0a <alltraps>

801074af <vector134>:
.globl vector134
vector134:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $134
801074b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801074b6:	e9 4f f6 ff ff       	jmp    80106b0a <alltraps>

801074bb <vector135>:
.globl vector135
vector135:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $135
801074bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801074c2:	e9 43 f6 ff ff       	jmp    80106b0a <alltraps>

801074c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $136
801074c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801074ce:	e9 37 f6 ff ff       	jmp    80106b0a <alltraps>

801074d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $137
801074d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801074da:	e9 2b f6 ff ff       	jmp    80106b0a <alltraps>

801074df <vector138>:
.globl vector138
vector138:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $138
801074e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801074e6:	e9 1f f6 ff ff       	jmp    80106b0a <alltraps>

801074eb <vector139>:
.globl vector139
vector139:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $139
801074ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801074f2:	e9 13 f6 ff ff       	jmp    80106b0a <alltraps>

801074f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $140
801074f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801074fe:	e9 07 f6 ff ff       	jmp    80106b0a <alltraps>

80107503 <vector141>:
.globl vector141
vector141:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $141
80107505:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010750a:	e9 fb f5 ff ff       	jmp    80106b0a <alltraps>

8010750f <vector142>:
.globl vector142
vector142:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $142
80107511:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107516:	e9 ef f5 ff ff       	jmp    80106b0a <alltraps>

8010751b <vector143>:
.globl vector143
vector143:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $143
8010751d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107522:	e9 e3 f5 ff ff       	jmp    80106b0a <alltraps>

80107527 <vector144>:
.globl vector144
vector144:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $144
80107529:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010752e:	e9 d7 f5 ff ff       	jmp    80106b0a <alltraps>

80107533 <vector145>:
.globl vector145
vector145:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $145
80107535:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010753a:	e9 cb f5 ff ff       	jmp    80106b0a <alltraps>

8010753f <vector146>:
.globl vector146
vector146:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $146
80107541:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107546:	e9 bf f5 ff ff       	jmp    80106b0a <alltraps>

8010754b <vector147>:
.globl vector147
vector147:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $147
8010754d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107552:	e9 b3 f5 ff ff       	jmp    80106b0a <alltraps>

80107557 <vector148>:
.globl vector148
vector148:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $148
80107559:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010755e:	e9 a7 f5 ff ff       	jmp    80106b0a <alltraps>

80107563 <vector149>:
.globl vector149
vector149:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $149
80107565:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010756a:	e9 9b f5 ff ff       	jmp    80106b0a <alltraps>

8010756f <vector150>:
.globl vector150
vector150:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $150
80107571:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107576:	e9 8f f5 ff ff       	jmp    80106b0a <alltraps>

8010757b <vector151>:
.globl vector151
vector151:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $151
8010757d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107582:	e9 83 f5 ff ff       	jmp    80106b0a <alltraps>

80107587 <vector152>:
.globl vector152
vector152:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $152
80107589:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010758e:	e9 77 f5 ff ff       	jmp    80106b0a <alltraps>

80107593 <vector153>:
.globl vector153
vector153:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $153
80107595:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010759a:	e9 6b f5 ff ff       	jmp    80106b0a <alltraps>

8010759f <vector154>:
.globl vector154
vector154:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $154
801075a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801075a6:	e9 5f f5 ff ff       	jmp    80106b0a <alltraps>

801075ab <vector155>:
.globl vector155
vector155:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $155
801075ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801075b2:	e9 53 f5 ff ff       	jmp    80106b0a <alltraps>

801075b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $156
801075b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801075be:	e9 47 f5 ff ff       	jmp    80106b0a <alltraps>

801075c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $157
801075c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801075ca:	e9 3b f5 ff ff       	jmp    80106b0a <alltraps>

801075cf <vector158>:
.globl vector158
vector158:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $158
801075d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801075d6:	e9 2f f5 ff ff       	jmp    80106b0a <alltraps>

801075db <vector159>:
.globl vector159
vector159:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $159
801075dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801075e2:	e9 23 f5 ff ff       	jmp    80106b0a <alltraps>

801075e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $160
801075e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801075ee:	e9 17 f5 ff ff       	jmp    80106b0a <alltraps>

801075f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $161
801075f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801075fa:	e9 0b f5 ff ff       	jmp    80106b0a <alltraps>

801075ff <vector162>:
.globl vector162
vector162:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $162
80107601:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107606:	e9 ff f4 ff ff       	jmp    80106b0a <alltraps>

8010760b <vector163>:
.globl vector163
vector163:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $163
8010760d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107612:	e9 f3 f4 ff ff       	jmp    80106b0a <alltraps>

80107617 <vector164>:
.globl vector164
vector164:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $164
80107619:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010761e:	e9 e7 f4 ff ff       	jmp    80106b0a <alltraps>

80107623 <vector165>:
.globl vector165
vector165:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $165
80107625:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010762a:	e9 db f4 ff ff       	jmp    80106b0a <alltraps>

8010762f <vector166>:
.globl vector166
vector166:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $166
80107631:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107636:	e9 cf f4 ff ff       	jmp    80106b0a <alltraps>

8010763b <vector167>:
.globl vector167
vector167:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $167
8010763d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107642:	e9 c3 f4 ff ff       	jmp    80106b0a <alltraps>

80107647 <vector168>:
.globl vector168
vector168:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $168
80107649:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010764e:	e9 b7 f4 ff ff       	jmp    80106b0a <alltraps>

80107653 <vector169>:
.globl vector169
vector169:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $169
80107655:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010765a:	e9 ab f4 ff ff       	jmp    80106b0a <alltraps>

8010765f <vector170>:
.globl vector170
vector170:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $170
80107661:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107666:	e9 9f f4 ff ff       	jmp    80106b0a <alltraps>

8010766b <vector171>:
.globl vector171
vector171:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $171
8010766d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107672:	e9 93 f4 ff ff       	jmp    80106b0a <alltraps>

80107677 <vector172>:
.globl vector172
vector172:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $172
80107679:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010767e:	e9 87 f4 ff ff       	jmp    80106b0a <alltraps>

80107683 <vector173>:
.globl vector173
vector173:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $173
80107685:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010768a:	e9 7b f4 ff ff       	jmp    80106b0a <alltraps>

8010768f <vector174>:
.globl vector174
vector174:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $174
80107691:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107696:	e9 6f f4 ff ff       	jmp    80106b0a <alltraps>

8010769b <vector175>:
.globl vector175
vector175:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $175
8010769d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801076a2:	e9 63 f4 ff ff       	jmp    80106b0a <alltraps>

801076a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $176
801076a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801076ae:	e9 57 f4 ff ff       	jmp    80106b0a <alltraps>

801076b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $177
801076b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801076ba:	e9 4b f4 ff ff       	jmp    80106b0a <alltraps>

801076bf <vector178>:
.globl vector178
vector178:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $178
801076c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801076c6:	e9 3f f4 ff ff       	jmp    80106b0a <alltraps>

801076cb <vector179>:
.globl vector179
vector179:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $179
801076cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801076d2:	e9 33 f4 ff ff       	jmp    80106b0a <alltraps>

801076d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $180
801076d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801076de:	e9 27 f4 ff ff       	jmp    80106b0a <alltraps>

801076e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $181
801076e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801076ea:	e9 1b f4 ff ff       	jmp    80106b0a <alltraps>

801076ef <vector182>:
.globl vector182
vector182:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $182
801076f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801076f6:	e9 0f f4 ff ff       	jmp    80106b0a <alltraps>

801076fb <vector183>:
.globl vector183
vector183:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $183
801076fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107702:	e9 03 f4 ff ff       	jmp    80106b0a <alltraps>

80107707 <vector184>:
.globl vector184
vector184:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $184
80107709:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010770e:	e9 f7 f3 ff ff       	jmp    80106b0a <alltraps>

80107713 <vector185>:
.globl vector185
vector185:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $185
80107715:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010771a:	e9 eb f3 ff ff       	jmp    80106b0a <alltraps>

8010771f <vector186>:
.globl vector186
vector186:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $186
80107721:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107726:	e9 df f3 ff ff       	jmp    80106b0a <alltraps>

8010772b <vector187>:
.globl vector187
vector187:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $187
8010772d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107732:	e9 d3 f3 ff ff       	jmp    80106b0a <alltraps>

80107737 <vector188>:
.globl vector188
vector188:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $188
80107739:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010773e:	e9 c7 f3 ff ff       	jmp    80106b0a <alltraps>

80107743 <vector189>:
.globl vector189
vector189:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $189
80107745:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010774a:	e9 bb f3 ff ff       	jmp    80106b0a <alltraps>

8010774f <vector190>:
.globl vector190
vector190:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $190
80107751:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107756:	e9 af f3 ff ff       	jmp    80106b0a <alltraps>

8010775b <vector191>:
.globl vector191
vector191:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $191
8010775d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107762:	e9 a3 f3 ff ff       	jmp    80106b0a <alltraps>

80107767 <vector192>:
.globl vector192
vector192:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $192
80107769:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010776e:	e9 97 f3 ff ff       	jmp    80106b0a <alltraps>

80107773 <vector193>:
.globl vector193
vector193:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $193
80107775:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010777a:	e9 8b f3 ff ff       	jmp    80106b0a <alltraps>

8010777f <vector194>:
.globl vector194
vector194:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $194
80107781:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107786:	e9 7f f3 ff ff       	jmp    80106b0a <alltraps>

8010778b <vector195>:
.globl vector195
vector195:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $195
8010778d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107792:	e9 73 f3 ff ff       	jmp    80106b0a <alltraps>

80107797 <vector196>:
.globl vector196
vector196:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $196
80107799:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010779e:	e9 67 f3 ff ff       	jmp    80106b0a <alltraps>

801077a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $197
801077a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801077aa:	e9 5b f3 ff ff       	jmp    80106b0a <alltraps>

801077af <vector198>:
.globl vector198
vector198:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $198
801077b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801077b6:	e9 4f f3 ff ff       	jmp    80106b0a <alltraps>

801077bb <vector199>:
.globl vector199
vector199:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $199
801077bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801077c2:	e9 43 f3 ff ff       	jmp    80106b0a <alltraps>

801077c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $200
801077c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801077ce:	e9 37 f3 ff ff       	jmp    80106b0a <alltraps>

801077d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $201
801077d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801077da:	e9 2b f3 ff ff       	jmp    80106b0a <alltraps>

801077df <vector202>:
.globl vector202
vector202:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $202
801077e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801077e6:	e9 1f f3 ff ff       	jmp    80106b0a <alltraps>

801077eb <vector203>:
.globl vector203
vector203:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $203
801077ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801077f2:	e9 13 f3 ff ff       	jmp    80106b0a <alltraps>

801077f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801077f7:	6a 00                	push   $0x0
  pushl $204
801077f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801077fe:	e9 07 f3 ff ff       	jmp    80106b0a <alltraps>

80107803 <vector205>:
.globl vector205
vector205:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $205
80107805:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010780a:	e9 fb f2 ff ff       	jmp    80106b0a <alltraps>

8010780f <vector206>:
.globl vector206
vector206:
  pushl $0
8010780f:	6a 00                	push   $0x0
  pushl $206
80107811:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107816:	e9 ef f2 ff ff       	jmp    80106b0a <alltraps>

8010781b <vector207>:
.globl vector207
vector207:
  pushl $0
8010781b:	6a 00                	push   $0x0
  pushl $207
8010781d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107822:	e9 e3 f2 ff ff       	jmp    80106b0a <alltraps>

80107827 <vector208>:
.globl vector208
vector208:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $208
80107829:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010782e:	e9 d7 f2 ff ff       	jmp    80106b0a <alltraps>

80107833 <vector209>:
.globl vector209
vector209:
  pushl $0
80107833:	6a 00                	push   $0x0
  pushl $209
80107835:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010783a:	e9 cb f2 ff ff       	jmp    80106b0a <alltraps>

8010783f <vector210>:
.globl vector210
vector210:
  pushl $0
8010783f:	6a 00                	push   $0x0
  pushl $210
80107841:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107846:	e9 bf f2 ff ff       	jmp    80106b0a <alltraps>

8010784b <vector211>:
.globl vector211
vector211:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $211
8010784d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107852:	e9 b3 f2 ff ff       	jmp    80106b0a <alltraps>

80107857 <vector212>:
.globl vector212
vector212:
  pushl $0
80107857:	6a 00                	push   $0x0
  pushl $212
80107859:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010785e:	e9 a7 f2 ff ff       	jmp    80106b0a <alltraps>

80107863 <vector213>:
.globl vector213
vector213:
  pushl $0
80107863:	6a 00                	push   $0x0
  pushl $213
80107865:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010786a:	e9 9b f2 ff ff       	jmp    80106b0a <alltraps>

8010786f <vector214>:
.globl vector214
vector214:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $214
80107871:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107876:	e9 8f f2 ff ff       	jmp    80106b0a <alltraps>

8010787b <vector215>:
.globl vector215
vector215:
  pushl $0
8010787b:	6a 00                	push   $0x0
  pushl $215
8010787d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107882:	e9 83 f2 ff ff       	jmp    80106b0a <alltraps>

80107887 <vector216>:
.globl vector216
vector216:
  pushl $0
80107887:	6a 00                	push   $0x0
  pushl $216
80107889:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010788e:	e9 77 f2 ff ff       	jmp    80106b0a <alltraps>

80107893 <vector217>:
.globl vector217
vector217:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $217
80107895:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010789a:	e9 6b f2 ff ff       	jmp    80106b0a <alltraps>

8010789f <vector218>:
.globl vector218
vector218:
  pushl $0
8010789f:	6a 00                	push   $0x0
  pushl $218
801078a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801078a6:	e9 5f f2 ff ff       	jmp    80106b0a <alltraps>

801078ab <vector219>:
.globl vector219
vector219:
  pushl $0
801078ab:	6a 00                	push   $0x0
  pushl $219
801078ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801078b2:	e9 53 f2 ff ff       	jmp    80106b0a <alltraps>

801078b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $220
801078b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801078be:	e9 47 f2 ff ff       	jmp    80106b0a <alltraps>

801078c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801078c3:	6a 00                	push   $0x0
  pushl $221
801078c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801078ca:	e9 3b f2 ff ff       	jmp    80106b0a <alltraps>

801078cf <vector222>:
.globl vector222
vector222:
  pushl $0
801078cf:	6a 00                	push   $0x0
  pushl $222
801078d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801078d6:	e9 2f f2 ff ff       	jmp    80106b0a <alltraps>

801078db <vector223>:
.globl vector223
vector223:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $223
801078dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801078e2:	e9 23 f2 ff ff       	jmp    80106b0a <alltraps>

801078e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801078e7:	6a 00                	push   $0x0
  pushl $224
801078e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801078ee:	e9 17 f2 ff ff       	jmp    80106b0a <alltraps>

801078f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801078f3:	6a 00                	push   $0x0
  pushl $225
801078f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801078fa:	e9 0b f2 ff ff       	jmp    80106b0a <alltraps>

801078ff <vector226>:
.globl vector226
vector226:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $226
80107901:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107906:	e9 ff f1 ff ff       	jmp    80106b0a <alltraps>

8010790b <vector227>:
.globl vector227
vector227:
  pushl $0
8010790b:	6a 00                	push   $0x0
  pushl $227
8010790d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107912:	e9 f3 f1 ff ff       	jmp    80106b0a <alltraps>

80107917 <vector228>:
.globl vector228
vector228:
  pushl $0
80107917:	6a 00                	push   $0x0
  pushl $228
80107919:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010791e:	e9 e7 f1 ff ff       	jmp    80106b0a <alltraps>

80107923 <vector229>:
.globl vector229
vector229:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $229
80107925:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010792a:	e9 db f1 ff ff       	jmp    80106b0a <alltraps>

8010792f <vector230>:
.globl vector230
vector230:
  pushl $0
8010792f:	6a 00                	push   $0x0
  pushl $230
80107931:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107936:	e9 cf f1 ff ff       	jmp    80106b0a <alltraps>

8010793b <vector231>:
.globl vector231
vector231:
  pushl $0
8010793b:	6a 00                	push   $0x0
  pushl $231
8010793d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107942:	e9 c3 f1 ff ff       	jmp    80106b0a <alltraps>

80107947 <vector232>:
.globl vector232
vector232:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $232
80107949:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010794e:	e9 b7 f1 ff ff       	jmp    80106b0a <alltraps>

80107953 <vector233>:
.globl vector233
vector233:
  pushl $0
80107953:	6a 00                	push   $0x0
  pushl $233
80107955:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010795a:	e9 ab f1 ff ff       	jmp    80106b0a <alltraps>

8010795f <vector234>:
.globl vector234
vector234:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $234
80107961:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107966:	e9 9f f1 ff ff       	jmp    80106b0a <alltraps>

8010796b <vector235>:
.globl vector235
vector235:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $235
8010796d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107972:	e9 93 f1 ff ff       	jmp    80106b0a <alltraps>

80107977 <vector236>:
.globl vector236
vector236:
  pushl $0
80107977:	6a 00                	push   $0x0
  pushl $236
80107979:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010797e:	e9 87 f1 ff ff       	jmp    80106b0a <alltraps>

80107983 <vector237>:
.globl vector237
vector237:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $237
80107985:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010798a:	e9 7b f1 ff ff       	jmp    80106b0a <alltraps>

8010798f <vector238>:
.globl vector238
vector238:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $238
80107991:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107996:	e9 6f f1 ff ff       	jmp    80106b0a <alltraps>

8010799b <vector239>:
.globl vector239
vector239:
  pushl $0
8010799b:	6a 00                	push   $0x0
  pushl $239
8010799d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801079a2:	e9 63 f1 ff ff       	jmp    80106b0a <alltraps>

801079a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $240
801079a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801079ae:	e9 57 f1 ff ff       	jmp    80106b0a <alltraps>

801079b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $241
801079b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801079ba:	e9 4b f1 ff ff       	jmp    80106b0a <alltraps>

801079bf <vector242>:
.globl vector242
vector242:
  pushl $0
801079bf:	6a 00                	push   $0x0
  pushl $242
801079c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801079c6:	e9 3f f1 ff ff       	jmp    80106b0a <alltraps>

801079cb <vector243>:
.globl vector243
vector243:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $243
801079cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801079d2:	e9 33 f1 ff ff       	jmp    80106b0a <alltraps>

801079d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $244
801079d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801079de:	e9 27 f1 ff ff       	jmp    80106b0a <alltraps>

801079e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801079e3:	6a 00                	push   $0x0
  pushl $245
801079e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801079ea:	e9 1b f1 ff ff       	jmp    80106b0a <alltraps>

801079ef <vector246>:
.globl vector246
vector246:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $246
801079f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801079f6:	e9 0f f1 ff ff       	jmp    80106b0a <alltraps>

801079fb <vector247>:
.globl vector247
vector247:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $247
801079fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107a02:	e9 03 f1 ff ff       	jmp    80106b0a <alltraps>

80107a07 <vector248>:
.globl vector248
vector248:
  pushl $0
80107a07:	6a 00                	push   $0x0
  pushl $248
80107a09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107a0e:	e9 f7 f0 ff ff       	jmp    80106b0a <alltraps>

80107a13 <vector249>:
.globl vector249
vector249:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $249
80107a15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107a1a:	e9 eb f0 ff ff       	jmp    80106b0a <alltraps>

80107a1f <vector250>:
.globl vector250
vector250:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $250
80107a21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107a26:	e9 df f0 ff ff       	jmp    80106b0a <alltraps>

80107a2b <vector251>:
.globl vector251
vector251:
  pushl $0
80107a2b:	6a 00                	push   $0x0
  pushl $251
80107a2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107a32:	e9 d3 f0 ff ff       	jmp    80106b0a <alltraps>

80107a37 <vector252>:
.globl vector252
vector252:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $252
80107a39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107a3e:	e9 c7 f0 ff ff       	jmp    80106b0a <alltraps>

80107a43 <vector253>:
.globl vector253
vector253:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $253
80107a45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107a4a:	e9 bb f0 ff ff       	jmp    80106b0a <alltraps>

80107a4f <vector254>:
.globl vector254
vector254:
  pushl $0
80107a4f:	6a 00                	push   $0x0
  pushl $254
80107a51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107a56:	e9 af f0 ff ff       	jmp    80106b0a <alltraps>

80107a5b <vector255>:
.globl vector255
vector255:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $255
80107a5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107a62:	e9 a3 f0 ff ff       	jmp    80106b0a <alltraps>
80107a67:	66 90                	xchg   %ax,%ax
80107a69:	66 90                	xchg   %ax,%ax
80107a6b:	66 90                	xchg   %ax,%ax
80107a6d:	66 90                	xchg   %ax,%ax
80107a6f:	90                   	nop

80107a70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	57                   	push   %edi
80107a74:	56                   	push   %esi
80107a75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107a76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80107a7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107a82:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80107a85:	39 d3                	cmp    %edx,%ebx
80107a87:	73 56                	jae    80107adf <deallocuvm.part.0+0x6f>
80107a89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107a8c:	89 c6                	mov    %eax,%esi
80107a8e:	89 d7                	mov    %edx,%edi
80107a90:	eb 12                	jmp    80107aa4 <deallocuvm.part.0+0x34>
80107a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a98:	83 c2 01             	add    $0x1,%edx
80107a9b:	89 d3                	mov    %edx,%ebx
80107a9d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107aa0:	39 fb                	cmp    %edi,%ebx
80107aa2:	73 38                	jae    80107adc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80107aa4:	89 da                	mov    %ebx,%edx
80107aa6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107aa9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80107aac:	a8 01                	test   $0x1,%al
80107aae:	74 e8                	je     80107a98 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80107ab0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107ab2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107ab7:	c1 e9 0a             	shr    $0xa,%ecx
80107aba:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80107ac0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80107ac7:	85 c0                	test   %eax,%eax
80107ac9:	74 cd                	je     80107a98 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80107acb:	8b 10                	mov    (%eax),%edx
80107acd:	f6 c2 01             	test   $0x1,%dl
80107ad0:	75 1e                	jne    80107af0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80107ad2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ad8:	39 fb                	cmp    %edi,%ebx
80107ada:	72 c8                	jb     80107aa4 <deallocuvm.part.0+0x34>
80107adc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107adf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ae2:	89 c8                	mov    %ecx,%eax
80107ae4:	5b                   	pop    %ebx
80107ae5:	5e                   	pop    %esi
80107ae6:	5f                   	pop    %edi
80107ae7:	5d                   	pop    %ebp
80107ae8:	c3                   	ret
80107ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80107af0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107af6:	74 26                	je     80107b1e <deallocuvm.part.0+0xae>
      kfree(v);
80107af8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107afb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107b04:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107b0a:	52                   	push   %edx
80107b0b:	e8 60 bc ff ff       	call   80103770 <kfree>
      *pte = 0;
80107b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80107b13:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80107b1c:	eb 82                	jmp    80107aa0 <deallocuvm.part.0+0x30>
        panic("kfree");
80107b1e:	83 ec 0c             	sub    $0xc,%esp
80107b21:	68 0c 86 10 80       	push   $0x8010860c
80107b26:	e8 15 8a ff ff       	call   80100540 <panic>
80107b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107b30 <mappages>:
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107b36:	89 d3                	mov    %edx,%ebx
80107b38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80107b3e:	83 ec 1c             	sub    $0x1c,%esp
80107b41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107b48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107b50:	8b 45 08             	mov    0x8(%ebp),%eax
80107b53:	29 d8                	sub    %ebx,%eax
80107b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b58:	eb 3f                	jmp    80107b99 <mappages+0x69>
80107b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107b60:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107b67:	c1 ea 0a             	shr    $0xa,%edx
80107b6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107b70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b77:	85 c0                	test   %eax,%eax
80107b79:	74 75                	je     80107bf0 <mappages+0xc0>
    if(*pte & PTE_P)
80107b7b:	f6 00 01             	testb  $0x1,(%eax)
80107b7e:	0f 85 86 00 00 00    	jne    80107c0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107b84:	0b 75 0c             	or     0xc(%ebp),%esi
80107b87:	83 ce 01             	or     $0x1,%esi
80107b8a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80107b8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107b8f:	39 c3                	cmp    %eax,%ebx
80107b91:	74 6d                	je     80107c00 <mappages+0xd0>
    a += PGSIZE;
80107b93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80107b9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107b9f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80107ba2:	89 d8                	mov    %ebx,%eax
80107ba4:	c1 e8 16             	shr    $0x16,%eax
80107ba7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107baa:	8b 07                	mov    (%edi),%eax
80107bac:	a8 01                	test   $0x1,%al
80107bae:	75 b0                	jne    80107b60 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107bb0:	e8 7b bd ff ff       	call   80103930 <kalloc>
80107bb5:	85 c0                	test   %eax,%eax
80107bb7:	74 37                	je     80107bf0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107bb9:	83 ec 04             	sub    $0x4,%esp
80107bbc:	68 00 10 00 00       	push   $0x1000
80107bc1:	6a 00                	push   $0x0
80107bc3:	50                   	push   %eax
80107bc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107bc7:	e8 a4 dd ff ff       	call   80105970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107bcc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107bcf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107bd2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107bd8:	83 c8 07             	or     $0x7,%eax
80107bdb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107bdd:	89 d8                	mov    %ebx,%eax
80107bdf:	c1 e8 0a             	shr    $0xa,%eax
80107be2:	25 fc 0f 00 00       	and    $0xffc,%eax
80107be7:	01 d0                	add    %edx,%eax
80107be9:	eb 90                	jmp    80107b7b <mappages+0x4b>
80107beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80107bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bf8:	5b                   	pop    %ebx
80107bf9:	5e                   	pop    %esi
80107bfa:	5f                   	pop    %edi
80107bfb:	5d                   	pop    %ebp
80107bfc:	c3                   	ret
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi
80107c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107c03:	31 c0                	xor    %eax,%eax
}
80107c05:	5b                   	pop    %ebx
80107c06:	5e                   	pop    %esi
80107c07:	5f                   	pop    %edi
80107c08:	5d                   	pop    %ebp
80107c09:	c3                   	ret
      panic("remap");
80107c0a:	83 ec 0c             	sub    $0xc,%esp
80107c0d:	68 40 88 10 80       	push   $0x80108840
80107c12:	e8 29 89 ff ff       	call   80100540 <panic>
80107c17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c1e:	00 
80107c1f:	90                   	nop

80107c20 <seginit>:
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107c26:	e8 e5 cf ff ff       	call   80104c10 <cpuid>
  pd[0] = size-1;
80107c2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107c30:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107c36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80107c3a:	c7 80 98 2a 11 80 ff 	movl   $0xffff,-0x7feed568(%eax)
80107c41:	ff 00 00 
80107c44:	c7 80 9c 2a 11 80 00 	movl   $0xcf9a00,-0x7feed564(%eax)
80107c4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107c4e:	c7 80 a0 2a 11 80 ff 	movl   $0xffff,-0x7feed560(%eax)
80107c55:	ff 00 00 
80107c58:	c7 80 a4 2a 11 80 00 	movl   $0xcf9200,-0x7feed55c(%eax)
80107c5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107c62:	c7 80 a8 2a 11 80 ff 	movl   $0xffff,-0x7feed558(%eax)
80107c69:	ff 00 00 
80107c6c:	c7 80 ac 2a 11 80 00 	movl   $0xcffa00,-0x7feed554(%eax)
80107c73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107c76:	c7 80 b0 2a 11 80 ff 	movl   $0xffff,-0x7feed550(%eax)
80107c7d:	ff 00 00 
80107c80:	c7 80 b4 2a 11 80 00 	movl   $0xcff200,-0x7feed54c(%eax)
80107c87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107c8a:	05 90 2a 11 80       	add    $0x80112a90,%eax
  pd[1] = (uint)p;
80107c8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107c93:	c1 e8 10             	shr    $0x10,%eax
80107c96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107c9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107c9d:	0f 01 10             	lgdtl  (%eax)
}
80107ca0:	c9                   	leave
80107ca1:	c3                   	ret
80107ca2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107ca9:	00 
80107caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107cb0:	a1 44 57 11 80       	mov    0x80115744,%eax
80107cb5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107cba:	0f 22 d8             	mov    %eax,%cr3
}
80107cbd:	c3                   	ret
80107cbe:	66 90                	xchg   %ax,%ax

80107cc0 <switchuvm>:
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
80107cc6:	83 ec 1c             	sub    $0x1c,%esp
80107cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107ccc:	85 f6                	test   %esi,%esi
80107cce:	0f 84 cb 00 00 00    	je     80107d9f <switchuvm+0xdf>
  if(p->kstack == 0)
80107cd4:	8b 46 08             	mov    0x8(%esi),%eax
80107cd7:	85 c0                	test   %eax,%eax
80107cd9:	0f 84 da 00 00 00    	je     80107db9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107cdf:	8b 46 04             	mov    0x4(%esi),%eax
80107ce2:	85 c0                	test   %eax,%eax
80107ce4:	0f 84 c2 00 00 00    	je     80107dac <switchuvm+0xec>
  pushcli();
80107cea:	e8 31 da ff ff       	call   80105720 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107cef:	e8 bc ce ff ff       	call   80104bb0 <mycpu>
80107cf4:	89 c3                	mov    %eax,%ebx
80107cf6:	e8 b5 ce ff ff       	call   80104bb0 <mycpu>
80107cfb:	89 c7                	mov    %eax,%edi
80107cfd:	e8 ae ce ff ff       	call   80104bb0 <mycpu>
80107d02:	83 c7 08             	add    $0x8,%edi
80107d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d08:	e8 a3 ce ff ff       	call   80104bb0 <mycpu>
80107d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107d10:	ba 67 00 00 00       	mov    $0x67,%edx
80107d15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107d1c:	83 c0 08             	add    $0x8,%eax
80107d1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107d26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d2b:	83 c1 08             	add    $0x8,%ecx
80107d2e:	c1 e8 18             	shr    $0x18,%eax
80107d31:	c1 e9 10             	shr    $0x10,%ecx
80107d34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107d3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107d40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107d45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107d4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107d51:	e8 5a ce ff ff       	call   80104bb0 <mycpu>
80107d56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107d5d:	e8 4e ce ff ff       	call   80104bb0 <mycpu>
80107d62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107d66:	8b 5e 08             	mov    0x8(%esi),%ebx
80107d69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d6f:	e8 3c ce ff ff       	call   80104bb0 <mycpu>
80107d74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107d77:	e8 34 ce ff ff       	call   80104bb0 <mycpu>
80107d7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107d80:	b8 28 00 00 00       	mov    $0x28,%eax
80107d85:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107d88:	8b 46 04             	mov    0x4(%esi),%eax
80107d8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107d90:	0f 22 d8             	mov    %eax,%cr3
}
80107d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d96:	5b                   	pop    %ebx
80107d97:	5e                   	pop    %esi
80107d98:	5f                   	pop    %edi
80107d99:	5d                   	pop    %ebp
  popcli();
80107d9a:	e9 d1 d9 ff ff       	jmp    80105770 <popcli>
    panic("switchuvm: no process");
80107d9f:	83 ec 0c             	sub    $0xc,%esp
80107da2:	68 46 88 10 80       	push   $0x80108846
80107da7:	e8 94 87 ff ff       	call   80100540 <panic>
    panic("switchuvm: no pgdir");
80107dac:	83 ec 0c             	sub    $0xc,%esp
80107daf:	68 71 88 10 80       	push   $0x80108871
80107db4:	e8 87 87 ff ff       	call   80100540 <panic>
    panic("switchuvm: no kstack");
80107db9:	83 ec 0c             	sub    $0xc,%esp
80107dbc:	68 5c 88 10 80       	push   $0x8010885c
80107dc1:	e8 7a 87 ff ff       	call   80100540 <panic>
80107dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107dcd:	00 
80107dce:	66 90                	xchg   %ax,%ax

80107dd0 <inituvm>:
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
80107dd6:	83 ec 1c             	sub    $0x1c,%esp
80107dd9:	8b 45 08             	mov    0x8(%ebp),%eax
80107ddc:	8b 75 10             	mov    0x10(%ebp),%esi
80107ddf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107de5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107deb:	77 49                	ja     80107e36 <inituvm+0x66>
  mem = kalloc();
80107ded:	e8 3e bb ff ff       	call   80103930 <kalloc>
  memset(mem, 0, PGSIZE);
80107df2:	83 ec 04             	sub    $0x4,%esp
80107df5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107dfa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107dfc:	6a 00                	push   $0x0
80107dfe:	50                   	push   %eax
80107dff:	e8 6c db ff ff       	call   80105970 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107e04:	58                   	pop    %eax
80107e05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e0b:	5a                   	pop    %edx
80107e0c:	6a 06                	push   $0x6
80107e0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e13:	31 d2                	xor    %edx,%edx
80107e15:	50                   	push   %eax
80107e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e19:	e8 12 fd ff ff       	call   80107b30 <mappages>
  memmove(mem, init, sz);
80107e1e:	83 c4 10             	add    $0x10,%esp
80107e21:	89 75 10             	mov    %esi,0x10(%ebp)
80107e24:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107e27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e2d:	5b                   	pop    %ebx
80107e2e:	5e                   	pop    %esi
80107e2f:	5f                   	pop    %edi
80107e30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107e31:	e9 ca db ff ff       	jmp    80105a00 <memmove>
    panic("inituvm: more than a page");
80107e36:	83 ec 0c             	sub    $0xc,%esp
80107e39:	68 85 88 10 80       	push   $0x80108885
80107e3e:	e8 fd 86 ff ff       	call   80100540 <panic>
80107e43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107e4a:	00 
80107e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107e50 <loaduvm>:
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	53                   	push   %ebx
80107e56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107e59:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80107e5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80107e5f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107e65:	0f 85 a2 00 00 00    	jne    80107f0d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80107e6b:	85 ff                	test   %edi,%edi
80107e6d:	74 7d                	je     80107eec <loaduvm+0x9c>
80107e6f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107e73:	8b 55 08             	mov    0x8(%ebp),%edx
80107e76:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107e78:	89 c1                	mov    %eax,%ecx
80107e7a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107e7d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107e80:	f6 c1 01             	test   $0x1,%cl
80107e83:	75 13                	jne    80107e98 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107e85:	83 ec 0c             	sub    $0xc,%esp
80107e88:	68 9f 88 10 80       	push   $0x8010889f
80107e8d:	e8 ae 86 ff ff       	call   80100540 <panic>
80107e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107e98:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107ea1:	25 fc 0f 00 00       	and    $0xffc,%eax
80107ea6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ead:	85 c9                	test   %ecx,%ecx
80107eaf:	74 d4                	je     80107e85 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107eb1:	89 fb                	mov    %edi,%ebx
80107eb3:	b8 00 10 00 00       	mov    $0x1000,%eax
80107eb8:	29 f3                	sub    %esi,%ebx
80107eba:	39 c3                	cmp    %eax,%ebx
80107ebc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ebf:	53                   	push   %ebx
80107ec0:	8b 45 14             	mov    0x14(%ebp),%eax
80107ec3:	01 f0                	add    %esi,%eax
80107ec5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107ec6:	8b 01                	mov    (%ecx),%eax
80107ec8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ecd:	05 00 00 00 80       	add    $0x80000000,%eax
80107ed2:	50                   	push   %eax
80107ed3:	ff 75 10             	push   0x10(%ebp)
80107ed6:	e8 a5 ae ff ff       	call   80102d80 <readi>
80107edb:	83 c4 10             	add    $0x10,%esp
80107ede:	39 d8                	cmp    %ebx,%eax
80107ee0:	75 1e                	jne    80107f00 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107ee2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ee8:	39 fe                	cmp    %edi,%esi
80107eea:	72 84                	jb     80107e70 <loaduvm+0x20>
}
80107eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107eef:	31 c0                	xor    %eax,%eax
}
80107ef1:	5b                   	pop    %ebx
80107ef2:	5e                   	pop    %esi
80107ef3:	5f                   	pop    %edi
80107ef4:	5d                   	pop    %ebp
80107ef5:	c3                   	ret
80107ef6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107efd:	00 
80107efe:	66 90                	xchg   %ax,%ax
80107f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f08:	5b                   	pop    %ebx
80107f09:	5e                   	pop    %esi
80107f0a:	5f                   	pop    %edi
80107f0b:	5d                   	pop    %ebp
80107f0c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80107f0d:	83 ec 0c             	sub    $0xc,%esp
80107f10:	68 2c 8b 10 80       	push   $0x80108b2c
80107f15:	e8 26 86 ff ff       	call   80100540 <panic>
80107f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f20 <allocuvm>:
{
80107f20:	55                   	push   %ebp
80107f21:	89 e5                	mov    %esp,%ebp
80107f23:	57                   	push   %edi
80107f24:	56                   	push   %esi
80107f25:	53                   	push   %ebx
80107f26:	83 ec 1c             	sub    $0x1c,%esp
80107f29:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80107f2c:	85 f6                	test   %esi,%esi
80107f2e:	0f 88 98 00 00 00    	js     80107fcc <allocuvm+0xac>
80107f34:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107f36:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107f39:	0f 82 a1 00 00 00    	jb     80107fe0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f42:	05 ff 0f 00 00       	add    $0xfff,%eax
80107f47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f4c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80107f4e:	39 f0                	cmp    %esi,%eax
80107f50:	0f 83 8d 00 00 00    	jae    80107fe3 <allocuvm+0xc3>
80107f56:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107f59:	eb 44                	jmp    80107f9f <allocuvm+0x7f>
80107f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107f60:	83 ec 04             	sub    $0x4,%esp
80107f63:	68 00 10 00 00       	push   $0x1000
80107f68:	6a 00                	push   $0x0
80107f6a:	50                   	push   %eax
80107f6b:	e8 00 da ff ff       	call   80105970 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f70:	58                   	pop    %eax
80107f71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f77:	5a                   	pop    %edx
80107f78:	6a 06                	push   $0x6
80107f7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f7f:	89 fa                	mov    %edi,%edx
80107f81:	50                   	push   %eax
80107f82:	8b 45 08             	mov    0x8(%ebp),%eax
80107f85:	e8 a6 fb ff ff       	call   80107b30 <mappages>
80107f8a:	83 c4 10             	add    $0x10,%esp
80107f8d:	85 c0                	test   %eax,%eax
80107f8f:	78 5f                	js     80107ff0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107f91:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107f97:	39 f7                	cmp    %esi,%edi
80107f99:	0f 83 89 00 00 00    	jae    80108028 <allocuvm+0x108>
    mem = kalloc();
80107f9f:	e8 8c b9 ff ff       	call   80103930 <kalloc>
80107fa4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107fa6:	85 c0                	test   %eax,%eax
80107fa8:	75 b6                	jne    80107f60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107faa:	83 ec 0c             	sub    $0xc,%esp
80107fad:	68 bd 88 10 80       	push   $0x801088bd
80107fb2:	e8 79 8c ff ff       	call   80100c30 <cprintf>
  if(newsz >= oldsz)
80107fb7:	83 c4 10             	add    $0x10,%esp
80107fba:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107fbd:	74 0d                	je     80107fcc <allocuvm+0xac>
80107fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc5:	89 f2                	mov    %esi,%edx
80107fc7:	e8 a4 fa ff ff       	call   80107a70 <deallocuvm.part.0>
    return 0;
80107fcc:	31 d2                	xor    %edx,%edx
}
80107fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fd1:	89 d0                	mov    %edx,%eax
80107fd3:	5b                   	pop    %ebx
80107fd4:	5e                   	pop    %esi
80107fd5:	5f                   	pop    %edi
80107fd6:	5d                   	pop    %ebp
80107fd7:	c3                   	ret
80107fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107fdf:	00 
    return oldsz;
80107fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fe6:	89 d0                	mov    %edx,%eax
80107fe8:	5b                   	pop    %ebx
80107fe9:	5e                   	pop    %esi
80107fea:	5f                   	pop    %edi
80107feb:	5d                   	pop    %ebp
80107fec:	c3                   	ret
80107fed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107ff0:	83 ec 0c             	sub    $0xc,%esp
80107ff3:	68 d5 88 10 80       	push   $0x801088d5
80107ff8:	e8 33 8c ff ff       	call   80100c30 <cprintf>
  if(newsz >= oldsz)
80107ffd:	83 c4 10             	add    $0x10,%esp
80108000:	3b 75 0c             	cmp    0xc(%ebp),%esi
80108003:	74 0d                	je     80108012 <allocuvm+0xf2>
80108005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108008:	8b 45 08             	mov    0x8(%ebp),%eax
8010800b:	89 f2                	mov    %esi,%edx
8010800d:	e8 5e fa ff ff       	call   80107a70 <deallocuvm.part.0>
      kfree(mem);
80108012:	83 ec 0c             	sub    $0xc,%esp
80108015:	53                   	push   %ebx
80108016:	e8 55 b7 ff ff       	call   80103770 <kfree>
      return 0;
8010801b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010801e:	31 d2                	xor    %edx,%edx
80108020:	eb ac                	jmp    80107fce <allocuvm+0xae>
80108022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108028:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010802b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010802e:	5b                   	pop    %ebx
8010802f:	5e                   	pop    %esi
80108030:	89 d0                	mov    %edx,%eax
80108032:	5f                   	pop    %edi
80108033:	5d                   	pop    %ebp
80108034:	c3                   	ret
80108035:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010803c:	00 
8010803d:	8d 76 00             	lea    0x0(%esi),%esi

80108040 <deallocuvm>:
{
80108040:	55                   	push   %ebp
80108041:	89 e5                	mov    %esp,%ebp
80108043:	8b 55 0c             	mov    0xc(%ebp),%edx
80108046:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108049:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010804c:	39 d1                	cmp    %edx,%ecx
8010804e:	73 10                	jae    80108060 <deallocuvm+0x20>
}
80108050:	5d                   	pop    %ebp
80108051:	e9 1a fa ff ff       	jmp    80107a70 <deallocuvm.part.0>
80108056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010805d:	00 
8010805e:	66 90                	xchg   %ax,%ax
80108060:	89 d0                	mov    %edx,%eax
80108062:	5d                   	pop    %ebp
80108063:	c3                   	ret
80108064:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010806b:	00 
8010806c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108070 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	57                   	push   %edi
80108074:	56                   	push   %esi
80108075:	53                   	push   %ebx
80108076:	83 ec 0c             	sub    $0xc,%esp
80108079:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010807c:	85 f6                	test   %esi,%esi
8010807e:	74 59                	je     801080d9 <freevm+0x69>
  if(newsz >= oldsz)
80108080:	31 c9                	xor    %ecx,%ecx
80108082:	ba 00 00 00 80       	mov    $0x80000000,%edx
80108087:	89 f0                	mov    %esi,%eax
80108089:	89 f3                	mov    %esi,%ebx
8010808b:	e8 e0 f9 ff ff       	call   80107a70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108090:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108096:	eb 0f                	jmp    801080a7 <freevm+0x37>
80108098:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010809f:	00 
801080a0:	83 c3 04             	add    $0x4,%ebx
801080a3:	39 fb                	cmp    %edi,%ebx
801080a5:	74 23                	je     801080ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801080a7:	8b 03                	mov    (%ebx),%eax
801080a9:	a8 01                	test   $0x1,%al
801080ab:	74 f3                	je     801080a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801080b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801080bd:	50                   	push   %eax
801080be:	e8 ad b6 ff ff       	call   80103770 <kfree>
801080c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080c6:	39 fb                	cmp    %edi,%ebx
801080c8:	75 dd                	jne    801080a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801080ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801080cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080d0:	5b                   	pop    %ebx
801080d1:	5e                   	pop    %esi
801080d2:	5f                   	pop    %edi
801080d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801080d4:	e9 97 b6 ff ff       	jmp    80103770 <kfree>
    panic("freevm: no pgdir");
801080d9:	83 ec 0c             	sub    $0xc,%esp
801080dc:	68 f1 88 10 80       	push   $0x801088f1
801080e1:	e8 5a 84 ff ff       	call   80100540 <panic>
801080e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801080ed:	00 
801080ee:	66 90                	xchg   %ax,%ax

801080f0 <setupkvm>:
{
801080f0:	55                   	push   %ebp
801080f1:	89 e5                	mov    %esp,%ebp
801080f3:	56                   	push   %esi
801080f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801080f5:	e8 36 b8 ff ff       	call   80103930 <kalloc>
801080fa:	85 c0                	test   %eax,%eax
801080fc:	74 5e                	je     8010815c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801080fe:	83 ec 04             	sub    $0x4,%esp
80108101:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108103:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80108108:	68 00 10 00 00       	push   $0x1000
8010810d:	6a 00                	push   $0x0
8010810f:	50                   	push   %eax
80108110:	e8 5b d8 ff ff       	call   80105970 <memset>
80108115:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108118:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010811b:	83 ec 08             	sub    $0x8,%esp
8010811e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108121:	8b 13                	mov    (%ebx),%edx
80108123:	ff 73 0c             	push   0xc(%ebx)
80108126:	50                   	push   %eax
80108127:	29 c1                	sub    %eax,%ecx
80108129:	89 f0                	mov    %esi,%eax
8010812b:	e8 00 fa ff ff       	call   80107b30 <mappages>
80108130:	83 c4 10             	add    $0x10,%esp
80108133:	85 c0                	test   %eax,%eax
80108135:	78 19                	js     80108150 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108137:	83 c3 10             	add    $0x10,%ebx
8010813a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80108140:	75 d6                	jne    80108118 <setupkvm+0x28>
}
80108142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108145:	89 f0                	mov    %esi,%eax
80108147:	5b                   	pop    %ebx
80108148:	5e                   	pop    %esi
80108149:	5d                   	pop    %ebp
8010814a:	c3                   	ret
8010814b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108150:	83 ec 0c             	sub    $0xc,%esp
80108153:	56                   	push   %esi
80108154:	e8 17 ff ff ff       	call   80108070 <freevm>
      return 0;
80108159:	83 c4 10             	add    $0x10,%esp
}
8010815c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010815f:	31 f6                	xor    %esi,%esi
}
80108161:	89 f0                	mov    %esi,%eax
80108163:	5b                   	pop    %ebx
80108164:	5e                   	pop    %esi
80108165:	5d                   	pop    %ebp
80108166:	c3                   	ret
80108167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010816e:	00 
8010816f:	90                   	nop

80108170 <kvmalloc>:
{
80108170:	55                   	push   %ebp
80108171:	89 e5                	mov    %esp,%ebp
80108173:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108176:	e8 75 ff ff ff       	call   801080f0 <setupkvm>
8010817b:	a3 44 57 11 80       	mov    %eax,0x80115744
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108180:	05 00 00 00 80       	add    $0x80000000,%eax
80108185:	0f 22 d8             	mov    %eax,%cr3
}
80108188:	c9                   	leave
80108189:	c3                   	ret
8010818a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108190 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108190:	55                   	push   %ebp
80108191:	89 e5                	mov    %esp,%ebp
80108193:	83 ec 08             	sub    $0x8,%esp
80108196:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108199:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010819c:	89 c1                	mov    %eax,%ecx
8010819e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801081a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801081a4:	f6 c2 01             	test   $0x1,%dl
801081a7:	75 17                	jne    801081c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801081a9:	83 ec 0c             	sub    $0xc,%esp
801081ac:	68 02 89 10 80       	push   $0x80108902
801081b1:	e8 8a 83 ff ff       	call   80100540 <panic>
801081b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801081bd:	00 
801081be:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801081c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801081c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801081ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801081d5:	85 c0                	test   %eax,%eax
801081d7:	74 d0                	je     801081a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801081d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801081dc:	c9                   	leave
801081dd:	c3                   	ret
801081de:	66 90                	xchg   %ax,%ax

801081e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801081e0:	55                   	push   %ebp
801081e1:	89 e5                	mov    %esp,%ebp
801081e3:	57                   	push   %edi
801081e4:	56                   	push   %esi
801081e5:	53                   	push   %ebx
801081e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801081e9:	e8 02 ff ff ff       	call   801080f0 <setupkvm>
801081ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801081f1:	85 c0                	test   %eax,%eax
801081f3:	0f 84 e9 00 00 00    	je     801082e2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801081f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801081fc:	85 c9                	test   %ecx,%ecx
801081fe:	0f 84 b2 00 00 00    	je     801082b6 <copyuvm+0xd6>
80108204:	31 f6                	xor    %esi,%esi
80108206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010820d:	00 
8010820e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80108210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108213:	89 f0                	mov    %esi,%eax
80108215:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108218:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010821b:	a8 01                	test   $0x1,%al
8010821d:	75 11                	jne    80108230 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010821f:	83 ec 0c             	sub    $0xc,%esp
80108222:	68 0c 89 10 80       	push   $0x8010890c
80108227:	e8 14 83 ff ff       	call   80100540 <panic>
8010822c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108230:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108232:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108237:	c1 ea 0a             	shr    $0xa,%edx
8010823a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108240:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108247:	85 c0                	test   %eax,%eax
80108249:	74 d4                	je     8010821f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010824b:	8b 00                	mov    (%eax),%eax
8010824d:	a8 01                	test   $0x1,%al
8010824f:	0f 84 9f 00 00 00    	je     801082f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108255:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108257:	25 ff 0f 00 00       	and    $0xfff,%eax
8010825c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010825f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108265:	e8 c6 b6 ff ff       	call   80103930 <kalloc>
8010826a:	89 c3                	mov    %eax,%ebx
8010826c:	85 c0                	test   %eax,%eax
8010826e:	74 64                	je     801082d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108270:	83 ec 04             	sub    $0x4,%esp
80108273:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108279:	68 00 10 00 00       	push   $0x1000
8010827e:	57                   	push   %edi
8010827f:	50                   	push   %eax
80108280:	e8 7b d7 ff ff       	call   80105a00 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108285:	58                   	pop    %eax
80108286:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010828c:	5a                   	pop    %edx
8010828d:	ff 75 e4             	push   -0x1c(%ebp)
80108290:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108295:	89 f2                	mov    %esi,%edx
80108297:	50                   	push   %eax
80108298:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010829b:	e8 90 f8 ff ff       	call   80107b30 <mappages>
801082a0:	83 c4 10             	add    $0x10,%esp
801082a3:	85 c0                	test   %eax,%eax
801082a5:	78 21                	js     801082c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801082a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801082ad:	3b 75 0c             	cmp    0xc(%ebp),%esi
801082b0:	0f 82 5a ff ff ff    	jb     80108210 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801082b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082bc:	5b                   	pop    %ebx
801082bd:	5e                   	pop    %esi
801082be:	5f                   	pop    %edi
801082bf:	5d                   	pop    %ebp
801082c0:	c3                   	ret
801082c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801082c8:	83 ec 0c             	sub    $0xc,%esp
801082cb:	53                   	push   %ebx
801082cc:	e8 9f b4 ff ff       	call   80103770 <kfree>
      goto bad;
801082d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801082d4:	83 ec 0c             	sub    $0xc,%esp
801082d7:	ff 75 e0             	push   -0x20(%ebp)
801082da:	e8 91 fd ff ff       	call   80108070 <freevm>
  return 0;
801082df:	83 c4 10             	add    $0x10,%esp
    return 0;
801082e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801082e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082ef:	5b                   	pop    %ebx
801082f0:	5e                   	pop    %esi
801082f1:	5f                   	pop    %edi
801082f2:	5d                   	pop    %ebp
801082f3:	c3                   	ret
      panic("copyuvm: page not present");
801082f4:	83 ec 0c             	sub    $0xc,%esp
801082f7:	68 26 89 10 80       	push   $0x80108926
801082fc:	e8 3f 82 ff ff       	call   80100540 <panic>
80108301:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108308:	00 
80108309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108310 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108316:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108319:	89 c1                	mov    %eax,%ecx
8010831b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010831e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108321:	f6 c2 01             	test   $0x1,%dl
80108324:	0f 84 f8 00 00 00    	je     80108422 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010832a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010832d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108333:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108334:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108339:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108340:	89 d0                	mov    %edx,%eax
80108342:	f7 d2                	not    %edx
80108344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108349:	05 00 00 00 80       	add    $0x80000000,%eax
8010834e:	83 e2 05             	and    $0x5,%edx
80108351:	ba 00 00 00 00       	mov    $0x0,%edx
80108356:	0f 45 c2             	cmovne %edx,%eax
}
80108359:	c3                   	ret
8010835a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108360 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108360:	55                   	push   %ebp
80108361:	89 e5                	mov    %esp,%ebp
80108363:	57                   	push   %edi
80108364:	56                   	push   %esi
80108365:	53                   	push   %ebx
80108366:	83 ec 0c             	sub    $0xc,%esp
80108369:	8b 75 14             	mov    0x14(%ebp),%esi
8010836c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010836f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108372:	85 f6                	test   %esi,%esi
80108374:	75 51                	jne    801083c7 <copyout+0x67>
80108376:	e9 9d 00 00 00       	jmp    80108418 <copyout+0xb8>
8010837b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80108380:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108386:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010838c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108392:	74 74                	je     80108408 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80108394:	89 fb                	mov    %edi,%ebx
80108396:	29 c3                	sub    %eax,%ebx
80108398:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010839e:	39 f3                	cmp    %esi,%ebx
801083a0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801083a3:	29 f8                	sub    %edi,%eax
801083a5:	83 ec 04             	sub    $0x4,%esp
801083a8:	01 c1                	add    %eax,%ecx
801083aa:	53                   	push   %ebx
801083ab:	52                   	push   %edx
801083ac:	89 55 10             	mov    %edx,0x10(%ebp)
801083af:	51                   	push   %ecx
801083b0:	e8 4b d6 ff ff       	call   80105a00 <memmove>
    len -= n;
    buf += n;
801083b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801083b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801083be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801083c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801083c3:	29 de                	sub    %ebx,%esi
801083c5:	74 51                	je     80108418 <copyout+0xb8>
  if(*pde & PTE_P){
801083c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801083ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801083cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801083ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801083d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801083d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801083da:	f6 c1 01             	test   $0x1,%cl
801083dd:	0f 84 46 00 00 00    	je     80108429 <copyout.cold>
  return &pgtab[PTX(va)];
801083e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801083e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801083eb:	c1 eb 0c             	shr    $0xc,%ebx
801083ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801083f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801083fb:	89 d9                	mov    %ebx,%ecx
801083fd:	f7 d1                	not    %ecx
801083ff:	83 e1 05             	and    $0x5,%ecx
80108402:	0f 84 78 ff ff ff    	je     80108380 <copyout+0x20>
  }
  return 0;
}
80108408:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010840b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108410:	5b                   	pop    %ebx
80108411:	5e                   	pop    %esi
80108412:	5f                   	pop    %edi
80108413:	5d                   	pop    %ebp
80108414:	c3                   	ret
80108415:	8d 76 00             	lea    0x0(%esi),%esi
80108418:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010841b:	31 c0                	xor    %eax,%eax
}
8010841d:	5b                   	pop    %ebx
8010841e:	5e                   	pop    %esi
8010841f:	5f                   	pop    %edi
80108420:	5d                   	pop    %ebp
80108421:	c3                   	ret

80108422 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108422:	a1 00 00 00 00       	mov    0x0,%eax
80108427:	0f 0b                	ud2

80108429 <copyout.cold>:
80108429:	a1 00 00 00 00       	mov    0x0,%eax
8010842e:	0f 0b                	ud2
