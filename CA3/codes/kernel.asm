
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 30 8e 11 80       	mov    $0x80118e30,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 45 10 80       	mov    $0x801045d0,%eax
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
80100044:	bb 54 d5 10 80       	mov    $0x8010d554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 96 10 80       	push   $0x80109600
80100051:	68 20 d5 10 80       	push   $0x8010d520
80100056:	e8 c5 60 00 00       	call   80106120 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 1c 11 80       	mov    $0x80111c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 1c 11 80 1c 	movl   $0x80111c1c,0x80111c6c
8010006a:	1c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 1c 11 80 1c 	movl   $0x80111c1c,0x80111c70
80100074:	1c 11 80 
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
8010008b:	c7 43 50 1c 1c 11 80 	movl   $0x80111c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 96 10 80       	push   $0x80109607
80100097:	50                   	push   %eax
80100098:	e8 53 5f 00 00       	call   80105ff0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 1c 11 80       	mov    0x80111c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 1c 11 80    	mov    %ebx,0x80111c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 19 11 80    	cmp    $0x801119c0,%ebx
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
801000df:	68 20 d5 10 80       	push   $0x8010d520
801000e4:	e8 27 62 00 00       	call   80106310 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 1c 11 80    	mov    0x80111c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
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
80100120:	8b 1d 6c 1c 11 80    	mov    0x80111c6c,%ebx
80100126:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 1c 11 80    	cmp    $0x80111c1c,%ebx
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
8010015d:	68 20 d5 10 80       	push   $0x8010d520
80100162:	e8 49 61 00 00       	call   801062b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 5e 00 00       	call   80106030 <acquiresleep>
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
8010018c:	e8 df 36 00 00       	call   80103870 <iderw>
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
801001a1:	68 0e 96 10 80       	push   $0x8010960e
801001a6:	e8 a5 03 00 00       	call   80100550 <panic>
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
801001be:	e8 0d 5f 00 00       	call   801060d0 <holdingsleep>
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
801001d4:	e9 97 36 00 00       	jmp    80103870 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 96 10 80       	push   $0x8010961f
801001e1:	e8 6a 03 00 00       	call   80100550 <panic>
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
801001ff:	e8 cc 5e 00 00       	call   801060d0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 7c 5e 00 00       	call   80106090 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010021b:	e8 f0 60 00 00       	call   80106310 <acquire>
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
8010023f:	a1 70 1c 11 80       	mov    0x80111c70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c 1c 11 80 	movl   $0x80111c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 1c 11 80       	mov    0x80111c70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 1c 11 80    	mov    %ebx,0x80111c70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 d5 10 80 	movl   $0x8010d520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 42 60 00 00       	jmp    801062b0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 96 10 80       	push   $0x80109626
80100276:	e8 d5 02 00 00       	call   80100550 <panic>
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
80100296:	8b 3d 0c 1f 11 80    	mov    0x80111f0c,%edi
8010029c:	89 c3                	mov    %eax,%ebx
  int free = INPUT_BUF - inuse;
8010029e:	b8 80 00 00 00       	mov    $0x80,%eax
  int inuse = (int)input.real_end - (int)input.r;
801002a3:	89 fa                	mov    %edi,%edx
801002a5:	2b 15 00 1f 11 80    	sub    0x80111f00,%edx
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
801002f5:	0f b6 9a 80 1e 11 80 	movzbl -0x7feee180(%edx),%ebx
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801002fc:	8b 14 95 10 1f 11 80 	mov    -0x7feee0f0(,%edx,4),%edx
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100303:	88 98 80 1e 11 80    	mov    %bl,-0x7feee180(%eax)
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100309:	89 14 85 10 1f 11 80 	mov    %edx,-0x7feee0f0(,%eax,4)
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
      break; //Don't allow newline
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
80100332:	88 98 80 1e 11 80    	mov    %bl,-0x7feee180(%eax)
    input.insert_order[(pos + wrote) % INPUT_BUF] = ++input.current_time;
80100338:	8b 1d 10 21 11 80    	mov    0x80112110,%ebx
8010033e:	8d 4b 01             	lea    0x1(%ebx),%ecx
80100341:	89 0d 10 21 11 80    	mov    %ecx,0x80112110
80100347:	89 0c 85 10 1f 11 80 	mov    %ecx,-0x7feee0f0(,%eax,4)
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
80100364:	a3 08 1f 11 80       	mov    %eax,0x80111f08
  input.real_end += wrote;
80100369:	01 d1                	add    %edx,%ecx
8010036b:	89 0d 0c 1f 11 80    	mov    %ecx,0x80111f0c

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
801003a0:	e8 7b 2a 00 00       	call   80102e20 <iunlock>
  target = n;
  acquire(&cons.lock);
801003a5:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
801003ac:	e8 5f 5f 00 00       	call   80106310 <acquire>

  while (n > 0)
801003b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801003b4:	83 c4 10             	add    $0x10,%esp
801003b7:	85 db                	test   %ebx,%ebx
801003b9:	0f 8e ac 00 00 00    	jle    8010046b <consoleread+0xdb>
  {
    while (input.r == input.w)
801003bf:	a1 00 1f 11 80       	mov    0x80111f00,%eax
801003c4:	3b 05 04 1f 11 80    	cmp    0x80111f04,%eax
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
801003d3:	68 c0 21 11 80       	push   $0x801121c0
801003d8:	68 00 1f 11 80       	push   $0x80111f00
801003dd:	e8 5e 56 00 00       	call   80105a40 <sleep>
    while (input.r == input.w)
801003e2:	a1 00 1f 11 80       	mov    0x80111f00,%eax
801003e7:	83 c4 10             	add    $0x10,%esp
801003ea:	3b 05 04 1f 11 80    	cmp    0x80111f04,%eax
801003f0:	75 36                	jne    80100428 <consoleread+0x98>
      if (myproc()->killed)
801003f2:	e8 39 4c 00 00       	call   80105030 <myproc>
801003f7:	8b 40 24             	mov    0x24(%eax),%eax
801003fa:	85 c0                	test   %eax,%eax
801003fc:	74 d2                	je     801003d0 <consoleread+0x40>
        release(&cons.lock);
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	68 c0 21 11 80       	push   $0x801121c0
80100406:	e8 a5 5e 00 00       	call   801062b0 <release>
        ilock(ip);
8010040b:	89 3c 24             	mov    %edi,(%esp)
8010040e:	e8 2d 29 00 00       	call   80102d40 <ilock>
        return -1;
80100413:	83 c4 10             	add    $0x10,%esp

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
80100434:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
8010043b:	89 15 00 1f 11 80    	mov    %edx,0x80111f00
    *dst++ = c;
80100441:	88 46 ff             	mov    %al,-0x1(%esi)
    c = input.buf[input.r++ % INPUT_BUF];
80100444:	89 c2                	mov    %eax,%edx
    if (c == '\n' || c == '\t')
80100446:	83 e8 09             	sub    $0x9,%eax
80100449:	83 f8 01             	cmp    $0x1,%eax
8010044c:	0f 87 65 ff ff ff    	ja     801003b7 <consoleread+0x27>
  if (c == '\t')
80100452:	80 fa 09             	cmp    $0x9,%dl
80100455:	75 14                	jne    8010046b <consoleread+0xdb>
    input.r = input.temp_r;
80100457:	a1 a4 21 11 80       	mov    0x801121a4,%eax
8010045c:	a3 00 1f 11 80       	mov    %eax,0x80111f00
80100461:	a1 a8 21 11 80       	mov    0x801121a8,%eax
80100466:	a3 04 1f 11 80       	mov    %eax,0x80111f04
  release(&cons.lock);
8010046b:	83 ec 0c             	sub    $0xc,%esp
8010046e:	68 c0 21 11 80       	push   $0x801121c0
80100473:	e8 38 5e 00 00       	call   801062b0 <release>
  ilock(ip);
80100478:	89 3c 24             	mov    %edi,(%esp)
8010047b:	e8 c0 28 00 00       	call   80102d40 <ilock>
  return target - n;
80100480:	8b 45 10             	mov    0x10(%ebp),%eax
80100483:	83 c4 10             	add    $0x10,%esp
}
80100486:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100489:	29 d8                	sub    %ebx,%eax
}
8010048b:	5b                   	pop    %ebx
8010048c:	5e                   	pop    %esi
8010048d:	5f                   	pop    %edi
8010048e:	5d                   	pop    %ebp
8010048f:	c3                   	ret

80100490 <delete_range.part.0>:
static void delete_range(int lo, int hi)
80100490:	55                   	push   %ebp
80100491:	89 e5                	mov    %esp,%ebp
80100493:	57                   	push   %edi
80100494:	56                   	push   %esi
  int deln = hi - lo;
80100495:	89 d6                	mov    %edx,%esi
static void delete_range(int lo, int hi)
80100497:	53                   	push   %ebx
  int deln = hi - lo;
80100498:	29 c6                	sub    %eax,%esi
static void delete_range(int lo, int hi)
8010049a:	89 c3                	mov    %eax,%ebx
8010049c:	83 ec 0c             	sub    $0xc,%esp
  for (int i = hi; i < (int)input.real_end; i++)
8010049f:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
801004a4:	89 c7                	mov    %eax,%edi
801004a6:	29 f7                	sub    %esi,%edi
801004a8:	39 c2                	cmp    %eax,%edx
801004aa:	7d 5d                	jge    80100509 <delete_range.part.0+0x79>
801004ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801004af:	89 d9                	mov    %ebx,%ecx
801004b1:	89 5d ec             	mov    %ebx,-0x14(%ebp)
801004b4:	89 55 e8             	mov    %edx,-0x18(%ebp)
801004b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801004be:	00 
801004bf:	90                   	nop
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004c0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801004c3:	89 cb                	mov    %ecx,%ebx
801004c5:	99                   	cltd
801004c6:	c1 fb 1f             	sar    $0x1f,%ebx
801004c9:	c1 ea 19             	shr    $0x19,%edx
801004cc:	c1 eb 19             	shr    $0x19,%ebx
801004cf:	01 d0                	add    %edx,%eax
801004d1:	83 e0 7f             	and    $0x7f,%eax
801004d4:	29 d0                	sub    %edx,%eax
801004d6:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
  for (int i = hi; i < (int)input.real_end; i++)
801004d9:	83 c1 01             	add    $0x1,%ecx
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004dc:	83 e2 7f             	and    $0x7f,%edx
801004df:	29 da                	sub    %ebx,%edx
801004e1:	0f b6 98 80 1e 11 80 	movzbl -0x7feee180(%eax),%ebx
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801004e8:	8b 04 85 10 1f 11 80 	mov    -0x7feee0f0(,%eax,4),%eax
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801004ef:	88 9a 80 1e 11 80    	mov    %bl,-0x7feee180(%edx)
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
801004f5:	89 04 95 10 1f 11 80 	mov    %eax,-0x7feee0f0(,%edx,4)
  for (int i = hi; i < (int)input.real_end; i++)
801004fc:	39 cf                	cmp    %ecx,%edi
801004fe:	75 c0                	jne    801004c0 <delete_range.part.0+0x30>
80100500:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100503:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80100506:	8b 55 e8             	mov    -0x18(%ebp),%edx
  input.real_end -= deln;
80100509:	29 f0                	sub    %esi,%eax
8010050b:	a3 0c 1f 11 80       	mov    %eax,0x80111f0c
  if (input.e > hi)
80100510:	a1 08 1f 11 80       	mov    0x80111f08,%eax
80100515:	39 c2                	cmp    %eax,%edx
80100517:	73 27                	jae    80100540 <delete_range.part.0+0xb0>
    input.e -= deln;
80100519:	29 f0                	sub    %esi,%eax
8010051b:	a3 08 1f 11 80       	mov    %eax,0x80111f08
  if (input.e < input.w)
80100520:	8b 15 04 1f 11 80    	mov    0x80111f04,%edx
80100526:	39 d0                	cmp    %edx,%eax
80100528:	73 06                	jae    80100530 <delete_range.part.0+0xa0>
    input.e = input.w;
8010052a:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
}
80100530:	83 c4 0c             	add    $0xc,%esp
80100533:	5b                   	pop    %ebx
80100534:	5e                   	pop    %esi
80100535:	5f                   	pop    %edi
80100536:	5d                   	pop    %ebp
80100537:	c3                   	ret
80100538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010053f:	00 
  else if (input.e > lo)
80100540:	39 c3                	cmp    %eax,%ebx
80100542:	73 dc                	jae    80100520 <delete_range.part.0+0x90>
    input.e = lo;
80100544:	89 1d 08 1f 11 80    	mov    %ebx,0x80111f08
8010054a:	89 d8                	mov    %ebx,%eax
8010054c:	eb d2                	jmp    80100520 <delete_range.part.0+0x90>
8010054e:	66 90                	xchg   %ax,%ax

80100550 <panic>:
{
80100550:	55                   	push   %ebp
80100551:	89 e5                	mov    %esp,%ebp
80100553:	56                   	push   %esi
80100554:	53                   	push   %ebx
80100555:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100558:	fa                   	cli
  cons.locking = 0;
80100559:	c7 05 f4 21 11 80 00 	movl   $0x0,0x801121f4
80100560:	00 00 00 
  getcallerpcs(&s, pcs);
80100563:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100566:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100569:	e8 02 39 00 00       	call   80103e70 <lapicid>
8010056e:	83 ec 08             	sub    $0x8,%esp
80100571:	50                   	push   %eax
80100572:	68 2d 96 10 80       	push   $0x8010962d
80100577:	e8 e4 07 00 00       	call   80100d60 <cprintf>
  cprintf(s);
8010057c:	58                   	pop    %eax
8010057d:	ff 75 08             	push   0x8(%ebp)
80100580:	e8 db 07 00 00       	call   80100d60 <cprintf>
  cprintf("\n");
80100585:	c7 04 24 c2 9b 10 80 	movl   $0x80109bc2,(%esp)
8010058c:	e8 cf 07 00 00       	call   80100d60 <cprintf>
  getcallerpcs(&s, pcs);
80100591:	8d 45 08             	lea    0x8(%ebp),%eax
80100594:	5a                   	pop    %edx
80100595:	59                   	pop    %ecx
80100596:	53                   	push   %ebx
80100597:	50                   	push   %eax
80100598:	e8 a3 5b 00 00       	call   80106140 <getcallerpcs>
  for (i = 0; i < 10; i++)
8010059d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801005a0:	83 ec 08             	sub    $0x8,%esp
801005a3:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
801005a5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801005a8:	68 41 96 10 80       	push   $0x80109641
801005ad:	e8 ae 07 00 00       	call   80100d60 <cprintf>
  for (i = 0; i < 10; i++)
801005b2:	83 c4 10             	add    $0x10,%esp
801005b5:	39 f3                	cmp    %esi,%ebx
801005b7:	75 e7                	jne    801005a0 <panic+0x50>
  panicked = 1;
801005b9:	c7 05 f8 21 11 80 01 	movl   $0x1,0x801121f8
801005c0:	00 00 00 
  for (;;)
801005c3:	eb fe                	jmp    801005c3 <panic+0x73>
801005c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005cc:	00 
801005cd:	8d 76 00             	lea    0x0(%esi),%esi

801005d0 <consputc.part.0>:
void consputc(int c, int k)
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 0c             	sub    $0xc,%esp
  if (c == BACKSPACE)
801005d9:	3d 00 01 00 00       	cmp    $0x100,%eax
801005de:	0f 84 64 01 00 00    	je     80100748 <consputc.part.0+0x178>
801005e4:	89 c6                	mov    %eax,%esi
  else if (c == KEY_LF)
801005e6:	3d e4 00 00 00       	cmp    $0xe4,%eax
801005eb:	0f 84 ff 01 00 00    	je     801007f0 <consputc.part.0+0x220>
  else if (c == KEY_RT)
801005f1:	3d e5 00 00 00       	cmp    $0xe5,%eax
801005f6:	0f 84 a4 00 00 00    	je     801006a0 <consputc.part.0+0xd0>
    uartputc(c);
801005fc:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005ff:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100604:	50                   	push   %eax
80100605:	e8 46 7b 00 00       	call   80108150 <uartputc>
8010060a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010060f:	89 fa                	mov    %edi,%edx
80100611:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100612:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100617:	89 da                	mov    %ebx,%edx
80100619:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010061a:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010061d:	89 fa                	mov    %edi,%edx
8010061f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100624:	c1 e1 08             	shl    $0x8,%ecx
80100627:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100628:	89 da                	mov    %ebx,%edx
8010062a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
8010062b:	0f b6 c0             	movzbl %al,%eax
  if (c == '\n')
8010062e:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
80100631:	09 c8                	or     %ecx,%eax
  if (c == '\n')
80100633:	83 fe 0a             	cmp    $0xa,%esi
80100636:	0f 85 84 01 00 00    	jne    801007c0 <consputc.part.0+0x1f0>
    pos += 80 - pos % 80;
8010063c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100641:	f7 e2                	mul    %edx
80100643:	c1 ea 06             	shr    $0x6,%edx
80100646:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100649:	c1 e0 04             	shl    $0x4,%eax
8010064c:	8d 58 50             	lea    0x50(%eax),%ebx
  if (pos < 0 || pos > 25 * 80)
8010064f:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100655:	0f 8f 90 00 00 00    	jg     801006eb <consputc.part.0+0x11b>
  outb(CRTPORT + 1, pos >> 8);
8010065b:	0f b6 f7             	movzbl %bh,%esi
  if ((pos / 80) >= 24)
8010065e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100664:	0f 8f 96 00 00 00    	jg     80100700 <consputc.part.0+0x130>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010066a:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010066f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100674:	89 fa                	mov    %edi,%edx
80100676:	ee                   	out    %al,(%dx)
80100677:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010067c:	89 f0                	mov    %esi,%eax
8010067e:	89 ca                	mov    %ecx,%edx
80100680:	ee                   	out    %al,(%dx)
80100681:	b8 0f 00 00 00       	mov    $0xf,%eax
80100686:	89 fa                	mov    %edi,%edx
80100688:	ee                   	out    %al,(%dx)
80100689:	89 d8                	mov    %ebx,%eax
8010068b:	89 ca                	mov    %ecx,%edx
8010068d:	ee                   	out    %al,(%dx)
}
8010068e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100691:	5b                   	pop    %ebx
80100692:	5e                   	pop    %esi
80100693:	5f                   	pop    %edi
80100694:	5d                   	pop    %ebp
80100695:	c3                   	ret
80100696:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010069d:	00 
8010069e:	66 90                	xchg   %ax,%ax
    uartputc(k);
801006a0:	83 ec 0c             	sub    $0xc,%esp
801006a3:	be d4 03 00 00       	mov    $0x3d4,%esi
801006a8:	52                   	push   %edx
801006a9:	e8 a2 7a 00 00       	call   80108150 <uartputc>
801006ae:	b8 0e 00 00 00       	mov    $0xe,%eax
801006b3:	89 f2                	mov    %esi,%edx
801006b5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006b6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801006bb:	89 da                	mov    %ebx,%edx
801006bd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801006be:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006c1:	89 f2                	mov    %esi,%edx
801006c3:	b8 0f 00 00 00       	mov    $0xf,%eax
801006c8:	c1 e1 08             	shl    $0x8,%ecx
801006cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006cc:	89 da                	mov    %ebx,%edx
801006ce:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801006cf:	0f b6 d8             	movzbl %al,%ebx
    if (pos < 25 * 80 - 1)
801006d2:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
801006d5:	09 cb                	or     %ecx,%ebx
    if (pos < 25 * 80 - 1)
801006d7:	81 fb ce 07 00 00    	cmp    $0x7ce,%ebx
801006dd:	0f 8e 55 01 00 00    	jle    80100838 <consputc.part.0+0x268>
  if (pos < 0 || pos > 25 * 80)
801006e3:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801006e9:	7e 15                	jle    80100700 <consputc.part.0+0x130>
    panic("pos under/overflow");
801006eb:	83 ec 0c             	sub    $0xc,%esp
801006ee:	68 45 96 10 80       	push   $0x80109645
801006f3:	e8 58 fe ff ff       	call   80100550 <panic>
801006f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006ff:	00 
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100700:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100703:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT + 1, pos);
80100706:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
8010070b:	68 60 0e 00 00       	push   $0xe60
80100710:	68 a0 80 0b 80       	push   $0x800b80a0
80100715:	68 00 80 0b 80       	push   $0x800b8000
8010071a:	e8 81 5d 00 00       	call   801064a0 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010071f:	b8 80 07 00 00       	mov    $0x780,%eax
80100724:	83 c4 0c             	add    $0xc,%esp
80100727:	29 d8                	sub    %ebx,%eax
80100729:	01 c0                	add    %eax,%eax
8010072b:	50                   	push   %eax
8010072c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100733:	6a 00                	push   $0x0
80100735:	50                   	push   %eax
80100736:	e8 d5 5c 00 00       	call   80106410 <memset>
  outb(CRTPORT + 1, pos);
8010073b:	83 c4 10             	add    $0x10,%esp
8010073e:	e9 27 ff ff ff       	jmp    8010066a <consputc.part.0+0x9a>
80100743:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80100748:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010074b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100750:	6a 08                	push   $0x8
80100752:	e8 f9 79 00 00       	call   80108150 <uartputc>
    uartputc(' ');
80100757:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010075e:	e8 ed 79 00 00       	call   80108150 <uartputc>
    uartputc('\b');
80100763:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010076a:	e8 e1 79 00 00       	call   80108150 <uartputc>
8010076f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100774:	89 f2                	mov    %esi,%edx
80100776:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100777:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010077c:	89 da                	mov    %ebx,%edx
8010077e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010077f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100782:	89 f2                	mov    %esi,%edx
80100784:	b8 0f 00 00 00       	mov    $0xf,%eax
80100789:	c1 e1 08             	shl    $0x8,%ecx
8010078c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010078d:	89 da                	mov    %ebx,%edx
8010078f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100790:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
80100793:	83 c4 10             	add    $0x10,%esp
80100796:	09 cb                	or     %ecx,%ebx
80100798:	74 16                	je     801007b0 <consputc.part.0+0x1e0>
      --pos;
8010079a:	83 eb 01             	sub    $0x1,%ebx
      crt[pos] = ' ' | 0x0700;
8010079d:	b9 20 07 00 00       	mov    $0x720,%ecx
801007a2:	66 89 8c 1b 00 80 0b 	mov    %cx,-0x7ff48000(%ebx,%ebx,1)
801007a9:	80 
801007aa:	e9 a0 fe ff ff       	jmp    8010064f <consputc.part.0+0x7f>
801007af:	90                   	nop
  outb(CRTPORT + 1, pos);
801007b0:	31 db                	xor    %ebx,%ebx
801007b2:	31 f6                	xor    %esi,%esi
801007b4:	e9 b1 fe ff ff       	jmp    8010066a <consputc.part.0+0x9a>
801007b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c & 0xff) | cg_attr;
801007c0:	89 f1                	mov    %esi,%ecx
801007c2:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos] = ' ' | 0x0700;
801007c5:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c & 0xff) | cg_attr;
801007ca:	01 c0                	add    %eax,%eax
801007cc:	0f b6 f1             	movzbl %cl,%esi
801007cf:	66 0b 35 00 b0 10 80 	or     0x8010b000,%si
    crt[pos] = ' ' | 0x0700;
801007d6:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c & 0xff) | cg_attr;
801007dd:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos] = ' ' | 0x0700;
801007e4:	e9 66 fe ff ff       	jmp    8010064f <consputc.part.0+0x7f>
801007e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
801007f0:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801007f3:	be d4 03 00 00       	mov    $0x3d4,%esi
801007f8:	6a 08                	push   $0x8
801007fa:	e8 51 79 00 00       	call   80108150 <uartputc>
801007ff:	b8 0e 00 00 00       	mov    $0xe,%eax
80100804:	89 f2                	mov    %esi,%edx
80100806:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100807:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010080c:	89 da                	mov    %ebx,%edx
8010080e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010080f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100812:	89 f2                	mov    %esi,%edx
80100814:	b8 0f 00 00 00       	mov    $0xf,%eax
80100819:	c1 e1 08             	shl    $0x8,%ecx
8010081c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010081d:	89 da                	mov    %ebx,%edx
8010081f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100820:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
80100823:	83 c4 10             	add    $0x10,%esp
80100826:	09 cb                	or     %ecx,%ebx
80100828:	74 86                	je     801007b0 <consputc.part.0+0x1e0>
      --pos;
8010082a:	83 eb 01             	sub    $0x1,%ebx
8010082d:	e9 1d fe ff ff       	jmp    8010064f <consputc.part.0+0x7f>
80100832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ++pos;
80100838:	83 c3 01             	add    $0x1,%ebx
  if (pos < 0 || pos > 25 * 80)
8010083b:	e9 1b fe ff ff       	jmp    8010065b <consputc.part.0+0x8b>

80100840 <printint>:
{
80100840:	55                   	push   %ebp
80100841:	89 e5                	mov    %esp,%ebp
80100843:	57                   	push   %edi
80100844:	56                   	push   %esi
80100845:	53                   	push   %ebx
80100846:	89 d3                	mov    %edx,%ebx
80100848:	83 ec 2c             	sub    $0x2c,%esp
  if (sign && (sign = xx < 0))
8010084b:	85 c0                	test   %eax,%eax
8010084d:	79 05                	jns    80100854 <printint+0x14>
8010084f:	83 e1 01             	and    $0x1,%ecx
80100852:	75 66                	jne    801008ba <printint+0x7a>
    x = xx;
80100854:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010085b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010085d:	31 f6                	xor    %esi,%esi
8010085f:	90                   	nop
    buf[i++] = digits[x % base];
80100860:	89 c8                	mov    %ecx,%eax
80100862:	31 d2                	xor    %edx,%edx
80100864:	89 f7                	mov    %esi,%edi
80100866:	f7 f3                	div    %ebx
80100868:	8d 76 01             	lea    0x1(%esi),%esi
8010086b:	0f b6 92 80 9c 10 80 	movzbl -0x7fef6380(%edx),%edx
80100872:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  } while ((x /= base) != 0);
80100876:	89 ca                	mov    %ecx,%edx
80100878:	89 c1                	mov    %eax,%ecx
8010087a:	39 da                	cmp    %ebx,%edx
8010087c:	73 e2                	jae    80100860 <printint+0x20>
  if (sign)
8010087e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100881:	85 c9                	test   %ecx,%ecx
80100883:	74 07                	je     8010088c <printint+0x4c>
    buf[i++] = '-';
80100885:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while (--i >= 0)
8010088a:	89 f7                	mov    %esi,%edi
8010088c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010088f:	01 df                	add    %ebx,%edi
  if (panicked)
80100891:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
    consputc(buf[i], 0);
80100897:	0f be 07             	movsbl (%edi),%eax
  if (panicked)
8010089a:	85 d2                	test   %edx,%edx
8010089c:	74 0a                	je     801008a8 <printint+0x68>
  asm volatile("cli");
8010089e:	fa                   	cli
    for (;;)
8010089f:	eb fe                	jmp    8010089f <printint+0x5f>
801008a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008a8:	31 d2                	xor    %edx,%edx
801008aa:	e8 21 fd ff ff       	call   801005d0 <consputc.part.0>
  while (--i >= 0)
801008af:	8d 47 ff             	lea    -0x1(%edi),%eax
801008b2:	39 df                	cmp    %ebx,%edi
801008b4:	74 11                	je     801008c7 <printint+0x87>
801008b6:	89 c7                	mov    %eax,%edi
801008b8:	eb d7                	jmp    80100891 <printint+0x51>
    x = -xx;
801008ba:	f7 d8                	neg    %eax
  if (sign && (sign = xx < 0))
801008bc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801008c3:	89 c1                	mov    %eax,%ecx
801008c5:	eb 96                	jmp    8010085d <printint+0x1d>
}
801008c7:	83 c4 2c             	add    $0x2c,%esp
801008ca:	5b                   	pop    %ebx
801008cb:	5e                   	pop    %esi
801008cc:	5f                   	pop    %edi
801008cd:	5d                   	pop    %ebp
801008ce:	c3                   	ret
801008cf:	90                   	nop

801008d0 <full_redraw_after_edit>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
  if (old_cursor_off < 0)
801008d4:	31 ff                	xor    %edi,%edi
{
801008d6:	56                   	push   %esi
801008d7:	53                   	push   %ebx
801008d8:	83 ec 1c             	sub    $0x1c,%esp
  int old_len = (int)input.real_end - (int)input.w;
801008db:	8b 35 04 1f 11 80    	mov    0x80111f04,%esi
801008e1:	8b 15 0c 1f 11 80    	mov    0x80111f0c,%edx
  int old_cursor_off = (int)old_e - (int)input.w;
801008e7:	29 f0                	sub    %esi,%eax
  int old_len = (int)input.real_end - (int)input.w;
801008e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if (old_cursor_off < 0)
801008ec:	85 c0                	test   %eax,%eax
801008ee:	0f 49 f8             	cmovns %eax,%edi
  for (int i = 0; i < old_cursor_off; i++)
801008f1:	7e 28                	jle    8010091b <full_redraw_after_edit+0x4b>
801008f3:	31 db                	xor    %ebx,%ebx
  if (panicked)
801008f5:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
801008fb:	85 c9                	test   %ecx,%ecx
801008fd:	74 09                	je     80100908 <full_redraw_after_edit+0x38>
801008ff:	fa                   	cli
    for (;;)
80100900:	eb fe                	jmp    80100900 <full_redraw_after_edit+0x30>
80100902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100908:	31 d2                	xor    %edx,%edx
8010090a:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
8010090f:	83 c3 01             	add    $0x1,%ebx
80100912:	e8 b9 fc ff ff       	call   801005d0 <consputc.part.0>
80100917:	39 df                	cmp    %ebx,%edi
80100919:	7f da                	jg     801008f5 <full_redraw_after_edit+0x25>
  int old_len = (int)input.real_end - (int)input.w;
8010091b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
min_int(int a, int b) { return a < b ? a : b; }
8010091e:	bf 50 00 00 00       	mov    $0x50,%edi
  int old_len = (int)input.real_end - (int)input.w;
80100923:	29 f3                	sub    %esi,%ebx
  if (old_len < 0)
80100925:	be 00 00 00 00       	mov    $0x0,%esi
8010092a:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
8010092d:	39 fe                	cmp    %edi,%esi
8010092f:	0f 4e fe             	cmovle %esi,%edi
  for (int i = 0; i < min_int(old_len, 80); i++)
80100932:	85 db                	test   %ebx,%ebx
80100934:	0f 8e 92 00 00 00    	jle    801009cc <full_redraw_after_edit+0xfc>
8010093a:	31 c9                	xor    %ecx,%ecx
  if (panicked)
8010093c:	8b 1d f8 21 11 80    	mov    0x801121f8,%ebx
80100942:	85 db                	test   %ebx,%ebx
80100944:	74 0a                	je     80100950 <full_redraw_after_edit+0x80>
80100946:	fa                   	cli
    for (;;)
80100947:	eb fe                	jmp    80100947 <full_redraw_after_edit+0x77>
80100949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100950:	31 d2                	xor    %edx,%edx
80100952:	b8 20 00 00 00       	mov    $0x20,%eax
80100957:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010095a:	e8 71 fc ff ff       	call   801005d0 <consputc.part.0>
  for (int i = 0; i < min_int(old_len, 80); i++)
8010095f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100962:	83 c1 01             	add    $0x1,%ecx
80100965:	39 f9                	cmp    %edi,%ecx
80100967:	7c d3                	jl     8010093c <full_redraw_after_edit+0x6c>
  if (panicked)
80100969:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
8010096f:	85 c9                	test   %ecx,%ecx
80100971:	75 3d                	jne    801009b0 <full_redraw_after_edit+0xe0>
80100973:	31 d2                	xor    %edx,%edx
80100975:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < min_int(old_len, 80); i++)
8010097a:	83 c3 01             	add    $0x1,%ebx
8010097d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100980:	e8 4b fc ff ff       	call   801005d0 <consputc.part.0>
80100985:	39 fb                	cmp    %edi,%ebx
80100987:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010098a:	7c dd                	jl     80100969 <full_redraw_after_edit+0x99>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
8010098c:	a1 04 1f 11 80       	mov    0x80111f04,%eax
  if (panicked)
80100991:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80100997:	01 c8                	add    %ecx,%eax
80100999:	83 e0 7f             	and    $0x7f,%eax
8010099c:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
801009a3:	85 d2                	test   %edx,%edx
801009a5:	74 11                	je     801009b8 <full_redraw_after_edit+0xe8>
801009a7:	fa                   	cli
    for (;;)
801009a8:	eb fe                	jmp    801009a8 <full_redraw_after_edit+0xd8>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	fa                   	cli
801009b1:	eb fe                	jmp    801009b1 <full_redraw_after_edit+0xe1>
801009b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801009b8:	31 d2                	xor    %edx,%edx
801009ba:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801009bd:	e8 0e fc ff ff       	call   801005d0 <consputc.part.0>
  for (int i = 0; i < old_len; i++)
801009c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801009c5:	83 c1 01             	add    $0x1,%ecx
801009c8:	39 ce                	cmp    %ecx,%esi
801009ca:	7f c0                	jg     8010098c <full_redraw_after_edit+0xbc>
  int moves_left = old_len - new_cursor_off;
801009cc:	8b 1d 04 1f 11 80    	mov    0x80111f04,%ebx
  int new_cursor_off = (int)input.e - (int)input.w;
801009d2:	2b 35 08 1f 11 80    	sub    0x80111f08,%esi
  int moves_left = old_len - new_cursor_off;
801009d8:	01 f3                	add    %esi,%ebx
  for (int i = 0; i < moves_left; i++)
801009da:	31 f6                	xor    %esi,%esi
801009dc:	85 db                	test   %ebx,%ebx
801009de:	7e 23                	jle    80100a03 <full_redraw_after_edit+0x133>
  if (panicked)
801009e0:	a1 f8 21 11 80       	mov    0x801121f8,%eax
801009e5:	85 c0                	test   %eax,%eax
801009e7:	74 07                	je     801009f0 <full_redraw_after_edit+0x120>
801009e9:	fa                   	cli
    for (;;)
801009ea:	eb fe                	jmp    801009ea <full_redraw_after_edit+0x11a>
801009ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009f0:	31 d2                	xor    %edx,%edx
801009f2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
801009f7:	83 c6 01             	add    $0x1,%esi
801009fa:	e8 d1 fb ff ff       	call   801005d0 <consputc.part.0>
801009ff:	39 f3                	cmp    %esi,%ebx
80100a01:	75 dd                	jne    801009e0 <full_redraw_after_edit+0x110>
}
80100a03:	83 c4 1c             	add    $0x1c,%esp
80100a06:	5b                   	pop    %ebx
80100a07:	5e                   	pop    %esi
80100a08:	5f                   	pop    %edi
80100a09:	5d                   	pop    %ebp
80100a0a:	c3                   	ret
80100a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100a10 <full_redraw_after_edit_len>:
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	31 ff                	xor    %edi,%edi
80100a16:	56                   	push   %esi
80100a17:	53                   	push   %ebx
80100a18:	89 d3                	mov    %edx,%ebx
  if (old_cursor_off < 0)
80100a1a:	31 d2                	xor    %edx,%edx
80100a1c:	89 d6                	mov    %edx,%esi
{
80100a1e:	83 ec 0c             	sub    $0xc,%esp
  int old_cursor_off = (int)old_e - (int)input.w;
80100a21:	2b 05 04 1f 11 80    	sub    0x80111f04,%eax
  if (old_cursor_off < 0)
80100a27:	85 c0                	test   %eax,%eax
80100a29:	0f 49 f0             	cmovns %eax,%esi
  for (int i = 0; i < old_cursor_off; i++)
80100a2c:	7e 25                	jle    80100a53 <full_redraw_after_edit_len+0x43>
  if (panicked)
80100a2e:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80100a33:	85 c0                	test   %eax,%eax
80100a35:	74 09                	je     80100a40 <full_redraw_after_edit_len+0x30>
80100a37:	fa                   	cli
    for (;;)
80100a38:	eb fe                	jmp    80100a38 <full_redraw_after_edit_len+0x28>
80100a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a40:	31 d2                	xor    %edx,%edx
80100a42:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
80100a47:	83 c7 01             	add    $0x1,%edi
80100a4a:	e8 81 fb ff ff       	call   801005d0 <consputc.part.0>
80100a4f:	39 f7                	cmp    %esi,%edi
80100a51:	7c db                	jl     80100a2e <full_redraw_after_edit_len+0x1e>
  if (old_len_before < 0)
80100a53:	31 f6                	xor    %esi,%esi
80100a55:	85 db                	test   %ebx,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80100a57:	b8 50 00 00 00       	mov    $0x50,%eax
  if (old_len_before < 0)
80100a5c:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
80100a5f:	39 c6                	cmp    %eax,%esi
80100a61:	0f 4f f0             	cmovg  %eax,%esi
  for (int i = 0; i < wipe; i++)
80100a64:	31 ff                	xor    %edi,%edi
80100a66:	85 db                	test   %ebx,%ebx
80100a68:	7e 46                	jle    80100ab0 <full_redraw_after_edit_len+0xa0>
  if (panicked)
80100a6a:	8b 1d f8 21 11 80    	mov    0x801121f8,%ebx
80100a70:	85 db                	test   %ebx,%ebx
80100a72:	74 0c                	je     80100a80 <full_redraw_after_edit_len+0x70>
80100a74:	fa                   	cli
    for (;;)
80100a75:	eb fe                	jmp    80100a75 <full_redraw_after_edit_len+0x65>
80100a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a7e:	00 
80100a7f:	90                   	nop
80100a80:	31 d2                	xor    %edx,%edx
80100a82:	b8 20 00 00 00       	mov    $0x20,%eax
  for (int i = 0; i < wipe; i++)
80100a87:	83 c7 01             	add    $0x1,%edi
80100a8a:	e8 41 fb ff ff       	call   801005d0 <consputc.part.0>
80100a8f:	39 fe                	cmp    %edi,%esi
80100a91:	7f d7                	jg     80100a6a <full_redraw_after_edit_len+0x5a>
  if (panicked)
80100a93:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
80100a99:	85 c9                	test   %ecx,%ecx
80100a9b:	75 4b                	jne    80100ae8 <full_redraw_after_edit_len+0xd8>
80100a9d:	31 d2                	xor    %edx,%edx
80100a9f:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < wipe; i++)
80100aa4:	83 c3 01             	add    $0x1,%ebx
80100aa7:	e8 24 fb ff ff       	call   801005d0 <consputc.part.0>
80100aac:	39 de                	cmp    %ebx,%esi
80100aae:	7f e3                	jg     80100a93 <full_redraw_after_edit_len+0x83>
  int new_len = (int)input.real_end - (int)input.w;
80100ab0:	a1 04 1f 11 80       	mov    0x80111f04,%eax
80100ab5:	8b 15 0c 1f 11 80    	mov    0x80111f0c,%edx
  if (new_len < 0)
80100abb:	31 db                	xor    %ebx,%ebx
  for (int i = 0; i < new_len; i++)
80100abd:	be 00 00 00 00       	mov    $0x0,%esi
  int new_len = (int)input.real_end - (int)input.w;
80100ac2:	29 c2                	sub    %eax,%edx
  if (new_len < 0)
80100ac4:	85 d2                	test   %edx,%edx
80100ac6:	0f 49 da             	cmovns %edx,%ebx
  for (int i = 0; i < new_len; i++)
80100ac9:	7e 3a                	jle    80100b05 <full_redraw_after_edit_len+0xf5>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80100acb:	01 f0                	add    %esi,%eax
  if (panicked)
80100acd:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80100ad3:	83 e0 7f             	and    $0x7f,%eax
80100ad6:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
80100add:	85 d2                	test   %edx,%edx
80100adf:	74 0f                	je     80100af0 <full_redraw_after_edit_len+0xe0>
80100ae1:	fa                   	cli
    for (;;)
80100ae2:	eb fe                	jmp    80100ae2 <full_redraw_after_edit_len+0xd2>
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ae8:	fa                   	cli
80100ae9:	eb fe                	jmp    80100ae9 <full_redraw_after_edit_len+0xd9>
80100aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100af0:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < new_len; i++)
80100af2:	83 c6 01             	add    $0x1,%esi
80100af5:	e8 d6 fa ff ff       	call   801005d0 <consputc.part.0>
80100afa:	39 f3                	cmp    %esi,%ebx
80100afc:	7e 07                	jle    80100b05 <full_redraw_after_edit_len+0xf5>
  int new_cursor_off = (int)input.e - (int)input.w;
80100afe:	a1 04 1f 11 80       	mov    0x80111f04,%eax
80100b03:	eb c6                	jmp    80100acb <full_redraw_after_edit_len+0xbb>
80100b05:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  if (new_cursor_off < 0)
80100b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  int new_cursor_off = (int)input.e - (int)input.w;
80100b0f:	2b 05 04 1f 11 80    	sub    0x80111f04,%eax
  if (new_cursor_off < 0)
80100b15:	0f 48 c2             	cmovs  %edx,%eax
  for (int i = 0; i < moves_left; i++)
80100b18:	31 f6                	xor    %esi,%esi
  int moves_left = new_len - new_cursor_off;
80100b1a:	29 c3                	sub    %eax,%ebx
  for (int i = 0; i < moves_left; i++)
80100b1c:	85 db                	test   %ebx,%ebx
80100b1e:	7e 23                	jle    80100b43 <full_redraw_after_edit_len+0x133>
  if (panicked)
80100b20:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80100b25:	85 c0                	test   %eax,%eax
80100b27:	74 07                	je     80100b30 <full_redraw_after_edit_len+0x120>
80100b29:	fa                   	cli
    for (;;)
80100b2a:	eb fe                	jmp    80100b2a <full_redraw_after_edit_len+0x11a>
80100b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b30:	31 d2                	xor    %edx,%edx
80100b32:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
80100b37:	83 c6 01             	add    $0x1,%esi
80100b3a:	e8 91 fa ff ff       	call   801005d0 <consputc.part.0>
80100b3f:	39 f3                	cmp    %esi,%ebx
80100b41:	75 dd                	jne    80100b20 <full_redraw_after_edit_len+0x110>
}
80100b43:	83 c4 0c             	add    $0xc,%esp
80100b46:	5b                   	pop    %ebx
80100b47:	5e                   	pop    %esi
80100b48:	5f                   	pop    %edi
80100b49:	5d                   	pop    %ebp
80100b4a:	c3                   	ret
80100b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100b50 <replace_selection_with>:
{
80100b50:	55                   	push   %ebp
80100b51:	89 d1                	mov    %edx,%ecx
80100b53:	89 e5                	mov    %esp,%ebp
80100b55:	57                   	push   %edi
80100b56:	56                   	push   %esi
80100b57:	89 c6                	mov    %eax,%esi
80100b59:	53                   	push   %ebx
80100b5a:	83 ec 1c             	sub    $0x1c,%esp
  int a = input.sel_a, b = input.sel_b;
80100b5d:	8b 15 14 21 11 80    	mov    0x80112114,%edx
80100b63:	a1 18 21 11 80       	mov    0x80112118,%eax
  int old_len = (int)input.real_end - (int)input.w;
80100b68:	8b 1d 0c 1f 11 80    	mov    0x80111f0c,%ebx
  uint old_e = input.e;
80100b6e:	8b 3d 08 1f 11 80    	mov    0x80111f08,%edi
  int old_len = (int)input.real_end - (int)input.w;
80100b74:	2b 1d 04 1f 11 80    	sub    0x80111f04,%ebx
  if (a > b)
80100b7a:	39 c2                	cmp    %eax,%edx
80100b7c:	7f 3a                	jg     80100bb8 <replace_selection_with+0x68>
  if (hi <= lo)
80100b7e:	75 30                	jne    80100bb0 <replace_selection_with+0x60>
  insert_at(lo, src, n);
80100b80:	89 f2                	mov    %esi,%edx
80100b82:	e8 f9 f6 ff ff       	call   80100280 <insert_at>
  full_redraw_after_edit_len(old_e, old_len);
80100b87:	89 da                	mov    %ebx,%edx
80100b89:	89 f8                	mov    %edi,%eax
  input.sel_a = input.sel_b = -1;
80100b8b:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
80100b92:	ff ff ff 
80100b95:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
80100b9c:	ff ff ff 
}
80100b9f:	83 c4 1c             	add    $0x1c,%esp
80100ba2:	5b                   	pop    %ebx
80100ba3:	5e                   	pop    %esi
80100ba4:	5f                   	pop    %edi
80100ba5:	5d                   	pop    %ebp
  full_redraw_after_edit_len(old_e, old_len);
80100ba6:	e9 65 fe ff ff       	jmp    80100a10 <full_redraw_after_edit_len>
80100bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bb3:	89 d0                	mov    %edx,%eax
80100bb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100bb8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100bbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bbe:	e8 cd f8 ff ff       	call   80100490 <delete_range.part.0>
80100bc3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100bc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100bc9:	eb b5                	jmp    80100b80 <replace_selection_with+0x30>
80100bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100bd0 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	57                   	push   %edi
80100bd4:	56                   	push   %esi
80100bd5:	53                   	push   %ebx
80100bd6:	83 ec 28             	sub    $0x28,%esp
80100bd9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100bdc:	ff 75 08             	push   0x8(%ebp)
80100bdf:	e8 3c 22 00 00       	call   80102e20 <iunlock>
  acquire(&cons.lock);
80100be4:	c7 04 24 c0 21 11 80 	movl   $0x801121c0,(%esp)
80100beb:	e8 20 57 00 00       	call   80106310 <acquire>

  if (!input.is_tab_mode)
80100bf0:	8b 0d 9c 21 11 80    	mov    0x8011219c,%ecx
80100bf6:	83 c4 10             	add    $0x10,%esp
80100bf9:	85 c9                	test   %ecx,%ecx
80100bfb:	75 23                	jne    80100c20 <consolewrite+0x50>
  {
    // Normal state of echo
    for (i = 0; i < n; i++)
80100bfd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100c00:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
80100c03:	85 f6                	test   %esi,%esi
80100c05:	7e 67                	jle    80100c6e <consolewrite+0x9e>
  if (panicked)
80100c07:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
      consputc(buf[i] & 0xff, 0);
80100c0d:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
80100c10:	85 d2                	test   %edx,%edx
80100c12:	74 4c                	je     80100c60 <consolewrite+0x90>
80100c14:	fa                   	cli
    for (;;)
80100c15:	eb fe                	jmp    80100c15 <consolewrite+0x45>
80100c17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c1e:	00 
80100c1f:	90                   	nop
  }

  else
  {
    // Write from the cursor point not the beggining
    uint start = input.e;
80100c20:	8b 0d 08 1f 11 80    	mov    0x80111f08,%ecx
    for (i = 0; i < n; i++)
80100c26:	85 f6                	test   %esi,%esi
80100c28:	0f 8e 95 00 00 00    	jle    80100cc3 <consolewrite+0xf3>
80100c2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100c31:	89 75 10             	mov    %esi,0x10(%ebp)
80100c34:	31 ff                	xor    %edi,%edi
80100c36:	89 ce                	mov    %ecx,%esi
    {
      if (buf[i] == TAB)
80100c38:	0f b6 03             	movzbl (%ebx),%eax
80100c3b:	3c 09                	cmp    $0x9,%al
80100c3d:	0f 84 a2 00 00 00    	je     80100ce5 <consolewrite+0x115>
  if (panicked)
80100c43:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
        input.has_enter = 0;
        input.is_tab_mode = 0;
        break;
      }

      if (buf[i] == ENTER || buf[i] == NEW_LINE)
80100c49:	3c 0d                	cmp    $0xd,%al
80100c4b:	0f 84 b3 00 00 00    	je     80100d04 <consolewrite+0x134>
80100c51:	3c 0a                	cmp    $0xa,%al
80100c53:	0f 84 ab 00 00 00    	je     80100d04 <consolewrite+0x134>
  if (panicked)
80100c59:	85 d2                	test   %edx,%edx
80100c5b:	74 31                	je     80100c8e <consolewrite+0xbe>
80100c5d:	fa                   	cli
    for (;;)
80100c5e:	eb fe                	jmp    80100c5e <consolewrite+0x8e>
80100c60:	31 d2                	xor    %edx,%edx
    for (i = 0; i < n; i++)
80100c62:	83 c3 01             	add    $0x1,%ebx
80100c65:	e8 66 f9 ff ff       	call   801005d0 <consputc.part.0>
80100c6a:	39 fb                	cmp    %edi,%ebx
80100c6c:	75 99                	jne    80100c07 <consolewrite+0x37>

    if (input.real_end < input.e)
      input.real_end = input.e;
  }

  release(&cons.lock);
80100c6e:	83 ec 0c             	sub    $0xc,%esp
80100c71:	68 c0 21 11 80       	push   $0x801121c0
80100c76:	e8 35 56 00 00       	call   801062b0 <release>
  ilock(ip);
80100c7b:	58                   	pop    %eax
80100c7c:	ff 75 08             	push   0x8(%ebp)
80100c7f:	e8 bc 20 00 00       	call   80102d40 <ilock>

  return n;
}
80100c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c87:	89 f0                	mov    %esi,%eax
80100c89:	5b                   	pop    %ebx
80100c8a:	5e                   	pop    %esi
80100c8b:	5f                   	pop    %edi
80100c8c:	5d                   	pop    %ebp
80100c8d:	c3                   	ret
80100c8e:	31 d2                	xor    %edx,%edx
    for (i = 0; i < n; i++)
80100c90:	83 c3 01             	add    $0x1,%ebx
80100c93:	e8 38 f9 ff ff       	call   801005d0 <consputc.part.0>
      input.buf[(start + i) % INPUT_BUF] = buf[i];
80100c98:	8d 04 3e             	lea    (%esi,%edi,1),%eax
80100c9b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    for (i = 0; i < n; i++)
80100c9f:	83 c7 01             	add    $0x1,%edi
      input.buf[(start + i) % INPUT_BUF] = buf[i];
80100ca2:	83 e0 7f             	and    $0x7f,%eax
80100ca5:	88 90 80 1e 11 80    	mov    %dl,-0x7feee180(%eax)
    for (i = 0; i < n; i++)
80100cab:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100cae:	75 88                	jne    80100c38 <consolewrite+0x68>
80100cb0:	8b 75 10             	mov    0x10(%ebp),%esi
    if (input.is_tab_mode && !input.has_enter)
80100cb3:	8b 1d 9c 21 11 80    	mov    0x8011219c,%ebx
      input.e += n; // cursor moves right as much as the length of new order is.
80100cb9:	8b 0d 08 1f 11 80    	mov    0x80111f08,%ecx
    if (input.is_tab_mode && !input.has_enter)
80100cbf:	85 db                	test   %ebx,%ebx
80100cc1:	74 12                	je     80100cd5 <consolewrite+0x105>
80100cc3:	8b 15 b4 21 11 80    	mov    0x801121b4,%edx
80100cc9:	85 d2                	test   %edx,%edx
80100ccb:	75 08                	jne    80100cd5 <consolewrite+0x105>
      input.e += n; // cursor moves right as much as the length of new order is.
80100ccd:	01 f1                	add    %esi,%ecx
80100ccf:	89 0d 08 1f 11 80    	mov    %ecx,0x80111f08
    if (input.real_end < input.e)
80100cd5:	39 0d 0c 1f 11 80    	cmp    %ecx,0x80111f0c
80100cdb:	73 91                	jae    80100c6e <consolewrite+0x9e>
      input.real_end = input.e;
80100cdd:	89 0d 0c 1f 11 80    	mov    %ecx,0x80111f0c
80100ce3:	eb 89                	jmp    80100c6e <consolewrite+0x9e>
        input.has_enter = 0;
80100ce5:	c7 05 b4 21 11 80 00 	movl   $0x0,0x801121b4
80100cec:	00 00 00 
80100cef:	8b 75 10             	mov    0x10(%ebp),%esi
        input.is_tab_mode = 0;
80100cf2:	c7 05 9c 21 11 80 00 	movl   $0x0,0x8011219c
80100cf9:	00 00 00 
    if (input.real_end < input.e)
80100cfc:	8b 0d 08 1f 11 80    	mov    0x80111f08,%ecx
80100d02:	eb d1                	jmp    80100cd5 <consolewrite+0x105>
        input.e = input.temp_e;
80100d04:	a1 b0 21 11 80       	mov    0x801121b0,%eax
80100d09:	89 f1                	mov    %esi,%ecx
80100d0b:	8b 75 10             	mov    0x10(%ebp),%esi
        input.has_enter = 1;
80100d0e:	c7 05 b4 21 11 80 01 	movl   $0x1,0x801121b4
80100d15:	00 00 00 
        input.e = input.temp_e;
80100d18:	a3 08 1f 11 80       	mov    %eax,0x80111f08
        consputc(buf[i] & 0xff, 0);
80100d1d:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
80100d20:	85 d2                	test   %edx,%edx
80100d22:	74 0c                	je     80100d30 <consolewrite+0x160>
80100d24:	fa                   	cli
    for (;;)
80100d25:	eb fe                	jmp    80100d25 <consolewrite+0x155>
80100d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d2e:	00 
80100d2f:	90                   	nop
80100d30:	31 d2                	xor    %edx,%edx
80100d32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100d35:	e8 96 f8 ff ff       	call   801005d0 <consputc.part.0>
        input.buf[(start + i) % INPUT_BUF] = buf[i];
80100d3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80100d3d:	0f b6 13             	movzbl (%ebx),%edx
80100d40:	8d 04 39             	lea    (%ecx,%edi,1),%eax
80100d43:	83 e0 7f             	and    $0x7f,%eax
80100d46:	88 90 80 1e 11 80    	mov    %dl,-0x7feee180(%eax)
        break;
80100d4c:	e9 62 ff ff ff       	jmp    80100cb3 <consolewrite+0xe3>
80100d51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d58:	00 
80100d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100d60 <cprintf>:
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	57                   	push   %edi
80100d64:	56                   	push   %esi
80100d65:	53                   	push   %ebx
80100d66:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100d69:	8b 3d f4 21 11 80    	mov    0x801121f4,%edi
  if (fmt == 0)
80100d6f:	8b 75 08             	mov    0x8(%ebp),%esi
  if (locking)
80100d72:	85 ff                	test   %edi,%edi
80100d74:	0f 85 06 01 00 00    	jne    80100e80 <cprintf+0x120>
  if (fmt == 0)
80100d7a:	85 f6                	test   %esi,%esi
80100d7c:	0f 84 e0 01 00 00    	je     80100f62 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100d82:	0f b6 06             	movzbl (%esi),%eax
80100d85:	85 c0                	test   %eax,%eax
80100d87:	74 59                	je     80100de2 <cprintf+0x82>
80100d89:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint *)(void *)(&fmt + 1);
80100d8c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100d8f:	31 db                	xor    %ebx,%ebx
    if (c != '%')
80100d91:	83 f8 25             	cmp    $0x25,%eax
80100d94:	75 5a                	jne    80100df0 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100d96:	83 c3 01             	add    $0x1,%ebx
80100d99:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if (c == 0)
80100d9d:	85 ff                	test   %edi,%edi
80100d9f:	74 36                	je     80100dd7 <cprintf+0x77>
    switch (c)
80100da1:	83 ff 70             	cmp    $0x70,%edi
80100da4:	0f 84 b6 00 00 00    	je     80100e60 <cprintf+0x100>
80100daa:	7f 74                	jg     80100e20 <cprintf+0xc0>
80100dac:	83 ff 25             	cmp    $0x25,%edi
80100daf:	74 5e                	je     80100e0f <cprintf+0xaf>
80100db1:	83 ff 64             	cmp    $0x64,%edi
80100db4:	75 78                	jne    80100e2e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100db6:	8b 01                	mov    (%ecx),%eax
80100db8:	8d 79 04             	lea    0x4(%ecx),%edi
80100dbb:	ba 0a 00 00 00       	mov    $0xa,%edx
80100dc0:	b9 01 00 00 00       	mov    $0x1,%ecx
80100dc5:	e8 76 fa ff ff       	call   80100840 <printint>
80100dca:	89 f9                	mov    %edi,%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100dcc:	83 c3 01             	add    $0x1,%ebx
80100dcf:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100dd3:	85 c0                	test   %eax,%eax
80100dd5:	75 ba                	jne    80100d91 <cprintf+0x31>
80100dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (locking)
80100dda:	85 ff                	test   %edi,%edi
80100ddc:	0f 85 c1 00 00 00    	jne    80100ea3 <cprintf+0x143>
}
80100de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100de5:	5b                   	pop    %ebx
80100de6:	5e                   	pop    %esi
80100de7:	5f                   	pop    %edi
80100de8:	5d                   	pop    %ebp
80100de9:	c3                   	ret
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (panicked)
80100df0:	8b 3d f8 21 11 80    	mov    0x801121f8,%edi
80100df6:	85 ff                	test   %edi,%edi
80100df8:	74 06                	je     80100e00 <cprintf+0xa0>
80100dfa:	fa                   	cli
    for (;;)
80100dfb:	eb fe                	jmp    80100dfb <cprintf+0x9b>
80100dfd:	8d 76 00             	lea    0x0(%esi),%esi
80100e00:	31 d2                	xor    %edx,%edx
80100e02:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100e05:	e8 c6 f7 ff ff       	call   801005d0 <consputc.part.0>
      continue;
80100e0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100e0d:	eb bd                	jmp    80100dcc <cprintf+0x6c>
  if (panicked)
80100e0f:	8b 3d f8 21 11 80    	mov    0x801121f8,%edi
80100e15:	85 ff                	test   %edi,%edi
80100e17:	0f 84 13 01 00 00    	je     80100f30 <cprintf+0x1d0>
80100e1d:	fa                   	cli
    for (;;)
80100e1e:	eb fe                	jmp    80100e1e <cprintf+0xbe>
    switch (c)
80100e20:	83 ff 73             	cmp    $0x73,%edi
80100e23:	0f 84 8f 00 00 00    	je     80100eb8 <cprintf+0x158>
80100e29:	83 ff 78             	cmp    $0x78,%edi
80100e2c:	74 32                	je     80100e60 <cprintf+0x100>
  if (panicked)
80100e2e:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
80100e34:	85 d2                	test   %edx,%edx
80100e36:	0f 85 e8 00 00 00    	jne    80100f24 <cprintf+0x1c4>
80100e3c:	31 d2                	xor    %edx,%edx
80100e3e:	b8 25 00 00 00       	mov    $0x25,%eax
80100e43:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100e46:	e8 85 f7 ff ff       	call   801005d0 <consputc.part.0>
80100e4b:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80100e50:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100e53:	85 c0                	test   %eax,%eax
80100e55:	0f 84 ec 00 00 00    	je     80100f47 <cprintf+0x1e7>
80100e5b:	fa                   	cli
    for (;;)
80100e5c:	eb fe                	jmp    80100e5c <cprintf+0xfc>
80100e5e:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
80100e60:	8b 01                	mov    (%ecx),%eax
80100e62:	8d 79 04             	lea    0x4(%ecx),%edi
80100e65:	ba 10 00 00 00       	mov    $0x10,%edx
80100e6a:	31 c9                	xor    %ecx,%ecx
80100e6c:	e8 cf f9 ff ff       	call   80100840 <printint>
80100e71:	89 f9                	mov    %edi,%ecx
      break;
80100e73:	e9 54 ff ff ff       	jmp    80100dcc <cprintf+0x6c>
80100e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e7f:	00 
    acquire(&cons.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
80100e83:	68 c0 21 11 80       	push   $0x801121c0
80100e88:	e8 83 54 00 00       	call   80106310 <acquire>
  if (fmt == 0)
80100e8d:	83 c4 10             	add    $0x10,%esp
80100e90:	85 f6                	test   %esi,%esi
80100e92:	0f 84 ca 00 00 00    	je     80100f62 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100e98:	0f b6 06             	movzbl (%esi),%eax
80100e9b:	85 c0                	test   %eax,%eax
80100e9d:	0f 85 e6 fe ff ff    	jne    80100d89 <cprintf+0x29>
    release(&cons.lock);
80100ea3:	83 ec 0c             	sub    $0xc,%esp
80100ea6:	68 c0 21 11 80       	push   $0x801121c0
80100eab:	e8 00 54 00 00       	call   801062b0 <release>
80100eb0:	83 c4 10             	add    $0x10,%esp
80100eb3:	e9 2a ff ff ff       	jmp    80100de2 <cprintf+0x82>
      if ((s = (char *)*argp++) == 0)
80100eb8:	8b 39                	mov    (%ecx),%edi
80100eba:	8d 51 04             	lea    0x4(%ecx),%edx
80100ebd:	85 ff                	test   %edi,%edi
80100ebf:	74 27                	je     80100ee8 <cprintf+0x188>
      for (; *s; s++)
80100ec1:	0f be 07             	movsbl (%edi),%eax
80100ec4:	84 c0                	test   %al,%al
80100ec6:	0f 84 8f 00 00 00    	je     80100f5b <cprintf+0x1fb>
80100ecc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100ecf:	89 fb                	mov    %edi,%ebx
80100ed1:	89 f7                	mov    %esi,%edi
80100ed3:	89 d6                	mov    %edx,%esi
  if (panicked)
80100ed5:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
80100edb:	85 d2                	test   %edx,%edx
80100edd:	74 26                	je     80100f05 <cprintf+0x1a5>
80100edf:	fa                   	cli
    for (;;)
80100ee0:	eb fe                	jmp    80100ee0 <cprintf+0x180>
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
80100ee8:	bf 58 96 10 80       	mov    $0x80109658,%edi
80100eed:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80100ef0:	b8 28 00 00 00       	mov    $0x28,%eax
80100ef5:	89 fb                	mov    %edi,%ebx
80100ef7:	89 f7                	mov    %esi,%edi
80100ef9:	89 d6                	mov    %edx,%esi
  if (panicked)
80100efb:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
80100f01:	85 d2                	test   %edx,%edx
80100f03:	75 da                	jne    80100edf <cprintf+0x17f>
80100f05:	31 d2                	xor    %edx,%edx
      for (; *s; s++)
80100f07:	83 c3 01             	add    $0x1,%ebx
80100f0a:	e8 c1 f6 ff ff       	call   801005d0 <consputc.part.0>
80100f0f:	0f be 03             	movsbl (%ebx),%eax
80100f12:	84 c0                	test   %al,%al
80100f14:	75 bf                	jne    80100ed5 <cprintf+0x175>
      if ((s = (char *)*argp++) == 0)
80100f16:	89 f2                	mov    %esi,%edx
80100f18:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100f1b:	89 fe                	mov    %edi,%esi
80100f1d:	89 d1                	mov    %edx,%ecx
80100f1f:	e9 a8 fe ff ff       	jmp    80100dcc <cprintf+0x6c>
80100f24:	fa                   	cli
    for (;;)
80100f25:	eb fe                	jmp    80100f25 <cprintf+0x1c5>
80100f27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f2e:	00 
80100f2f:	90                   	nop
80100f30:	31 d2                	xor    %edx,%edx
80100f32:	b8 25 00 00 00       	mov    $0x25,%eax
80100f37:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100f3a:	e8 91 f6 ff ff       	call   801005d0 <consputc.part.0>
      break;
80100f3f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100f42:	e9 85 fe ff ff       	jmp    80100dcc <cprintf+0x6c>
80100f47:	31 d2                	xor    %edx,%edx
80100f49:	89 f8                	mov    %edi,%eax
80100f4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100f4e:	e8 7d f6 ff ff       	call   801005d0 <consputc.part.0>
      break;
80100f53:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100f56:	e9 71 fe ff ff       	jmp    80100dcc <cprintf+0x6c>
      if ((s = (char *)*argp++) == 0)
80100f5b:	89 d1                	mov    %edx,%ecx
80100f5d:	e9 6a fe ff ff       	jmp    80100dcc <cprintf+0x6c>
    panic("null fmt");
80100f62:	83 ec 0c             	sub    $0xc,%esp
80100f65:	68 5f 96 10 80       	push   $0x8010965f
80100f6a:	e8 e1 f5 ff ff       	call   80100550 <panic>
80100f6f:	90                   	nop

80100f70 <consoleintr>:
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 48             	sub    $0x48,%esp
80100f79:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100f7c:	68 c0 21 11 80       	push   $0x801121c0
80100f81:	e8 8a 53 00 00       	call   80106310 <acquire>
  while ((c = getc()) >= 0)
80100f86:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100f89:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  while ((c = getc()) >= 0)
80100f90:	ff d7                	call   *%edi
80100f92:	85 c0                	test   %eax,%eax
80100f94:	0f 88 66 05 00 00    	js     80101500 <consoleintr+0x590>
    switch (c)
80100f9a:	83 f8 1a             	cmp    $0x1a,%eax
80100f9d:	7f 11                	jg     80100fb0 <consoleintr+0x40>
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	74 ed                	je     80100f90 <consoleintr+0x20>
80100fa3:	83 f8 1a             	cmp    $0x1a,%eax
80100fa6:	77 28                	ja     80100fd0 <consoleintr+0x60>
80100fa8:	ff 24 85 14 9c 10 80 	jmp    *-0x7fef63ec(,%eax,4)
80100faf:	90                   	nop
80100fb0:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100fb5:	74 59                	je     80101010 <consoleintr+0xa0>
80100fb7:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100fbc:	0f 84 66 05 00 00    	je     80101528 <consoleintr+0x5b8>
80100fc2:	83 f8 7f             	cmp    $0x7f,%eax
80100fc5:	0f 84 8d 00 00 00    	je     80101058 <consoleintr+0xe8>
80100fcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80100fd0:	8b 15 14 21 11 80    	mov    0x80112114,%edx
80100fd6:	8b 1d 18 21 11 80    	mov    0x80112118,%ebx
80100fdc:	89 d6                	mov    %edx,%esi
80100fde:	09 de                	or     %ebx,%esi
80100fe0:	0f 88 1a 07 00 00    	js     80101700 <consoleintr+0x790>
80100fe6:	39 da                	cmp    %ebx,%edx
80100fe8:	0f 84 12 07 00 00    	je     80101700 <consoleintr+0x790>
        if (ch >= 32 && ch != 0x7f)
80100fee:	3c 1f                	cmp    $0x1f,%al
80100ff0:	76 9e                	jbe    80100f90 <consoleintr+0x20>
80100ff2:	3c 7f                	cmp    $0x7f,%al
80100ff4:	74 9a                	je     80100f90 <consoleintr+0x20>
          char one[1] = {(char)ch};
80100ff6:	88 45 e7             	mov    %al,-0x19(%ebp)
          replace_selection_with(one, 1); // handles delete+insert+redraw+deselect
80100ff9:	ba 01 00 00 00       	mov    $0x1,%edx
80100ffe:	8d 45 e7             	lea    -0x19(%ebp),%eax
80101001:	e8 4a fb ff ff       	call   80100b50 <replace_selection_with>
80101006:	eb 88                	jmp    80100f90 <consoleintr+0x20>
80101008:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010100f:	00 
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101010:	8b 0d 14 21 11 80    	mov    0x80112114,%ecx
80101016:	8b 15 18 21 11 80    	mov    0x80112118,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
8010101c:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101021:	89 ce                	mov    %ecx,%esi
80101023:	09 d6                	or     %edx,%esi
80101025:	78 08                	js     8010102f <consoleintr+0xbf>
80101027:	39 d1                	cmp    %edx,%ecx
80101029:	0f 85 21 05 00 00    	jne    80101550 <consoleintr+0x5e0>
      if (input.e > input.w)
8010102f:	39 05 04 1f 11 80    	cmp    %eax,0x80111f04
80101035:	0f 83 55 ff ff ff    	jae    80100f90 <consoleintr+0x20>
  if (panicked)
8010103b:	8b 1d f8 21 11 80    	mov    0x801121f8,%ebx
        input.e--;
80101041:	83 e8 01             	sub    $0x1,%eax
80101044:	a3 08 1f 11 80       	mov    %eax,0x80111f08
  if (panicked)
80101049:	85 db                	test   %ebx,%ebx
8010104b:	0f 84 2d 09 00 00    	je     8010197e <consoleintr+0xa0e>
80101051:	fa                   	cli
    for (;;)
80101052:	eb fe                	jmp    80101052 <consoleintr+0xe2>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101058:	8b 15 14 21 11 80    	mov    0x80112114,%edx
      while (input.e != input.w &&
8010105e:	8b 0d 04 1f 11 80    	mov    0x80111f04,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101064:	8b 1d 08 1f 11 80    	mov    0x80111f08,%ebx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010106a:	85 d2                	test   %edx,%edx
8010106c:	0f 88 2e 05 00 00    	js     801015a0 <consoleintr+0x630>
80101072:	a1 18 21 11 80       	mov    0x80112118,%eax
80101077:	85 c0                	test   %eax,%eax
80101079:	0f 88 01 07 00 00    	js     80101780 <consoleintr+0x810>
8010107f:	39 c2                	cmp    %eax,%edx
80101081:	0f 84 f9 06 00 00    	je     80101780 <consoleintr+0x810>
        int old_len = (int)input.real_end - (int)input.w; // BEFORE delete
80101087:	8b 35 0c 1f 11 80    	mov    0x80111f0c,%esi
8010108d:	29 ce                	sub    %ecx,%esi
  if (a > b)
8010108f:	39 c2                	cmp    %eax,%edx
80101091:	7f 06                	jg     80101099 <consoleintr+0x129>
80101093:	89 c1                	mov    %eax,%ecx
  int a = input.sel_a, b = input.sel_b;
80101095:	89 d0                	mov    %edx,%eax
80101097:	89 ca                	mov    %ecx,%edx
80101099:	e8 f2 f3 ff ff       	call   80100490 <delete_range.part.0>
        full_redraw_after_edit_len(old_e, old_len);
8010109e:	89 f2                	mov    %esi,%edx
801010a0:	89 d8                	mov    %ebx,%eax
  input.sel_a = input.sel_b = -1;
801010a2:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
801010a9:	ff ff ff 
801010ac:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
801010b3:	ff ff ff 
        full_redraw_after_edit_len(old_e, old_len);
801010b6:	e8 55 f9 ff ff       	call   80100a10 <full_redraw_after_edit_len>
        break;
801010bb:	e9 d0 fe ff ff       	jmp    80100f90 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801010c0:	8b 1d 18 21 11 80    	mov    0x80112118,%ebx
801010c6:	8b 0d 14 21 11 80    	mov    0x80112114,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801010cc:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801010d1:	89 de                	mov    %ebx,%esi
801010d3:	09 ce                	or     %ecx,%esi
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801010d5:	89 c2                	mov    %eax,%edx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801010d7:	78 08                	js     801010e1 <consoleintr+0x171>
801010d9:	39 cb                	cmp    %ecx,%ebx
801010db:	0f 85 6f 04 00 00    	jne    80101550 <consoleintr+0x5e0>
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801010e1:	3b 05 0c 1f 11 80    	cmp    0x80111f0c,%eax
801010e7:	0f 83 a3 fe ff ff    	jae    80100f90 <consoleintr+0x20>
801010ed:	83 e2 7f             	and    $0x7f,%edx
801010f0:	0f be 92 80 1e 11 80 	movsbl -0x7feee180(%edx),%edx
801010f7:	80 fa 0a             	cmp    $0xa,%dl
801010fa:	0f 84 c1 06 00 00    	je     801017c1 <consoleintr+0x851>
80101100:	80 fa 20             	cmp    $0x20,%dl
80101103:	0f 84 b8 06 00 00    	je     801017c1 <consoleintr+0x851>
  if (panicked)
80101109:	a1 f8 21 11 80       	mov    0x801121f8,%eax
8010110e:	85 c0                	test   %eax,%eax
80101110:	0f 84 da 06 00 00    	je     801017f0 <consoleintr+0x880>
80101116:	fa                   	cli
    for (;;)
80101117:	eb fe                	jmp    80101117 <consoleintr+0x1a7>
80101119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101120:	a1 14 21 11 80       	mov    0x80112114,%eax
80101125:	85 c0                	test   %eax,%eax
80101127:	0f 88 63 fe ff ff    	js     80100f90 <consoleintr+0x20>
8010112d:	8b 0d 18 21 11 80    	mov    0x80112118,%ecx
80101133:	85 c9                	test   %ecx,%ecx
80101135:	0f 88 55 fe ff ff    	js     80100f90 <consoleintr+0x20>
8010113b:	39 c8                	cmp    %ecx,%eax
8010113d:	0f 84 4d fe ff ff    	je     80100f90 <consoleintr+0x20>
  if (a > b)
80101143:	0f 8f 97 09 00 00    	jg     80101ae0 <consoleintr+0xb70>
        int n = hi - lo;
80101149:	89 cb                	mov    %ecx,%ebx
        if (n > INPUT_BUF)
8010114b:	ba 80 00 00 00       	mov    $0x80,%edx
  int a = input.sel_a, b = input.sel_b;
80101150:	89 c1                	mov    %eax,%ecx
        int n = hi - lo;
80101152:	29 c3                	sub    %eax,%ebx
        if (n > INPUT_BUF)
80101154:	39 d3                	cmp    %edx,%ebx
80101156:	0f 4f da             	cmovg  %edx,%ebx
  int a = input.sel_a, b = input.sel_b;
80101159:	31 c0                	xor    %eax,%eax
8010115b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
80101160:	8d 14 01             	lea    (%ecx,%eax,1),%edx
        for (int i = 0; i < n; ++i)
80101163:	83 c0 01             	add    $0x1,%eax
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
80101166:	83 e2 7f             	and    $0x7f,%edx
80101169:	0f b6 92 80 1e 11 80 	movzbl -0x7feee180(%edx),%edx
80101170:	88 90 1b 21 11 80    	mov    %dl,-0x7feedee5(%eax)
        for (int i = 0; i < n; ++i)
80101176:	39 d8                	cmp    %ebx,%eax
80101178:	7c e6                	jl     80101160 <consoleintr+0x1f0>
        input.clip_len = n;
8010117a:	89 1d a0 21 11 80    	mov    %ebx,0x801121a0
80101180:	e9 0b fe ff ff       	jmp    80100f90 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101185:	8b 1d 18 21 11 80    	mov    0x80112118,%ebx
8010118b:	8b 0d 14 21 11 80    	mov    0x80112114,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101191:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101196:	89 de                	mov    %ebx,%esi
80101198:	09 ce                	or     %ecx,%esi
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
8010119a:	89 c2                	mov    %eax,%edx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010119c:	78 08                	js     801011a6 <consoleintr+0x236>
8010119e:	39 cb                	cmp    %ecx,%ebx
801011a0:	0f 85 aa 03 00 00    	jne    80101550 <consoleintr+0x5e0>
      if (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] == ' ')
801011a6:	85 c0                	test   %eax,%eax
801011a8:	0f 84 e2 fd ff ff    	je     80100f90 <consoleintr+0x20>
801011ae:	8d 48 ff             	lea    -0x1(%eax),%ecx
801011b1:	83 e1 7f             	and    $0x7f,%ecx
801011b4:	80 b9 80 1e 11 80 20 	cmpb   $0x20,-0x7feee180(%ecx)
801011bb:	0f 84 43 09 00 00    	je     80101b04 <consoleintr+0xb94>
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
801011c1:	83 e2 7f             	and    $0x7f,%edx
801011c4:	80 ba 80 1e 11 80 20 	cmpb   $0x20,-0x7feee180(%edx)
801011cb:	0f 85 c7 08 00 00    	jne    80101a98 <consoleintr+0xb28>
  if (panicked)
801011d1:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
801011d7:	85 c9                	test   %ecx,%ecx
801011d9:	0f 84 8f 03 00 00    	je     8010156e <consoleintr+0x5fe>
801011df:	fa                   	cli
    for (;;)
801011e0:	eb fe                	jmp    801011e0 <consoleintr+0x270>
801011e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801011e8:	8b 0d 14 21 11 80    	mov    0x80112114,%ecx
801011ee:	a1 18 21 11 80       	mov    0x80112118,%eax
801011f3:	89 ce                	mov    %ecx,%esi
801011f5:	09 c6                	or     %eax,%esi
801011f7:	78 08                	js     80101201 <consoleintr+0x291>
801011f9:	39 c1                	cmp    %eax,%ecx
801011fb:	0f 85 49 02 00 00    	jne    8010144a <consoleintr+0x4da>
      if (input.real_end > input.w)
80101201:	8b 1d 0c 1f 11 80    	mov    0x80111f0c,%ebx
80101207:	8b 15 04 1f 11 80    	mov    0x80111f04,%edx
8010120d:	39 da                	cmp    %ebx,%edx
8010120f:	0f 83 7b fd ff ff    	jae    80100f90 <consoleintr+0x20>
        int max_t = -1, idx = -1;
80101215:	89 55 d0             	mov    %edx,-0x30(%ebp)
        for (uint i = input.w; i < input.real_end; i++)
80101218:	89 d0                	mov    %edx,%eax
        int max_t = -1, idx = -1;
8010121a:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010121f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
80101222:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010122e:	00 
8010122f:	90                   	nop
          int t = input.insert_order[i % INPUT_BUF];
80101230:	89 c2                	mov    %eax,%edx
80101232:	83 e2 7f             	and    $0x7f,%edx
80101235:	8b 14 95 10 1f 11 80 	mov    -0x7feee0f0(,%edx,4),%edx
          if (t > max_t)
8010123c:	39 f2                	cmp    %esi,%edx
8010123e:	7e 04                	jle    80101244 <consoleintr+0x2d4>
            idx = (int)i;
80101240:	89 c1                	mov    %eax,%ecx
            max_t = t;
80101242:	89 d6                	mov    %edx,%esi
        for (uint i = input.w; i < input.real_end; i++)
80101244:	83 c0 01             	add    $0x1,%eax
80101247:	39 c3                	cmp    %eax,%ebx
80101249:	75 e5                	jne    80101230 <consoleintr+0x2c0>
        if (idx >= 0)
8010124b:	89 c8                	mov    %ecx,%eax
8010124d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80101250:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101253:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80101256:	85 c0                	test   %eax,%eax
80101258:	0f 88 32 fd ff ff    	js     80100f90 <consoleintr+0x20>
          int old_e = (int)input.e;
8010125e:	a1 08 1f 11 80       	mov    0x80111f08,%eax
80101263:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101266:	89 45 c0             	mov    %eax,-0x40(%ebp)
          for (int i = idx; i < old_real_end - 1; i++)
80101269:	8d 43 ff             	lea    -0x1(%ebx),%eax
8010126c:	89 45 c8             	mov    %eax,-0x38(%ebp)
8010126f:	89 c6                	mov    %eax,%esi
80101271:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101274:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80101277:	39 75 cc             	cmp    %esi,-0x34(%ebp)
8010127a:	7d 44                	jge    801012c0 <consoleintr+0x350>
8010127c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010127f:	8b 75 c8             	mov    -0x38(%ebp),%esi
80101282:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80101285:	89 55 b8             	mov    %edx,-0x48(%ebp)
80101288:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
8010128b:	89 c2                	mov    %eax,%edx
8010128d:	83 c0 01             	add    $0x1,%eax
80101290:	89 c3                	mov    %eax,%ebx
80101292:	83 e2 7f             	and    $0x7f,%edx
80101295:	83 e3 7f             	and    $0x7f,%ebx
80101298:	0f b6 8b 80 1e 11 80 	movzbl -0x7feee180(%ebx),%ecx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
8010129f:	8b 1c 9d 10 1f 11 80 	mov    -0x7feee0f0(,%ebx,4),%ebx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801012a6:	88 8a 80 1e 11 80    	mov    %cl,-0x7feee180(%edx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
801012ac:	89 1c 95 10 1f 11 80 	mov    %ebx,-0x7feee0f0(,%edx,4)
          for (int i = idx; i < old_real_end - 1; i++)
801012b3:	39 f0                	cmp    %esi,%eax
801012b5:	75 d4                	jne    8010128b <consoleintr+0x31b>
801012b7:	8b 5d bc             	mov    -0x44(%ebp),%ebx
801012ba:	8b 55 b8             	mov    -0x48(%ebp),%edx
801012bd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
          input.real_end--;
801012c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
          if ((int)input.e > idx)
801012c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
          input.real_end--;
801012c6:	a3 0c 1f 11 80       	mov    %eax,0x80111f0c
          if ((int)input.e > idx)
801012cb:	39 75 cc             	cmp    %esi,-0x34(%ebp)
801012ce:	7d 0c                	jge    801012dc <consoleintr+0x36c>
            input.e--;
801012d0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
801012d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
801012d7:	a3 08 1f 11 80       	mov    %eax,0x80111f08
          if (idx <= input.sel_a && input.sel_a >= 0)
801012dc:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
801012df:	7f 12                	jg     801012f3 <consoleintr+0x383>
            input.sel_a--; // Adjust the selection anchor to reflect the removed character
801012e1:	8d 41 ff             	lea    -0x1(%ecx),%eax
801012e4:	85 c9                	test   %ecx,%ecx
801012e6:	b9 00 00 00 00       	mov    $0x0,%ecx
801012eb:	0f 44 c1             	cmove  %ecx,%eax
801012ee:	a3 14 21 11 80       	mov    %eax,0x80112114
          if (input.e < input.w)
801012f3:	39 55 d0             	cmp    %edx,-0x30(%ebp)
801012f6:	73 09                	jae    80101301 <consoleintr+0x391>
            input.e = input.w;
801012f8:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
801012fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
          if (input.e > input.real_end)
80101301:	8b 45 c8             	mov    -0x38(%ebp),%eax
80101304:	8b 75 d0             	mov    -0x30(%ebp),%esi
80101307:	39 f0                	cmp    %esi,%eax
80101309:	73 08                	jae    80101313 <consoleintr+0x3a3>
            input.e = input.real_end;
8010130b:	a3 08 1f 11 80       	mov    %eax,0x80111f08
80101310:	89 45 d0             	mov    %eax,-0x30(%ebp)
          int old_cursor_off = old_e - (int)input.w;
80101313:	8b 45 c0             	mov    -0x40(%ebp),%eax
          if (old_cursor_off < 0)
80101316:	31 f6                	xor    %esi,%esi
          for (int i = 0; i < old_cursor_off; i++)
80101318:	b9 00 00 00 00       	mov    $0x0,%ecx
          int old_cursor_off = old_e - (int)input.w;
8010131d:	29 d0                	sub    %edx,%eax
          if (old_cursor_off < 0)
8010131f:	85 c0                	test   %eax,%eax
80101321:	0f 49 f0             	cmovns %eax,%esi
          for (int i = 0; i < old_cursor_off; i++)
80101324:	0f 8e 24 08 00 00    	jle    80101b4e <consoleintr+0xbde>
8010132a:	89 5d cc             	mov    %ebx,-0x34(%ebp)
8010132d:	89 cb                	mov    %ecx,%ebx
8010132f:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80101332:	89 d7                	mov    %edx,%edi
  if (panicked)
80101334:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80101339:	85 c0                	test   %eax,%eax
8010133b:	0f 84 ee 07 00 00    	je     80101b2f <consoleintr+0xbbf>
80101341:	fa                   	cli
    for (;;)
80101342:	eb fe                	jmp    80101342 <consoleintr+0x3d2>
80101344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.clip_len <= 0)
80101348:	8b 0d a0 21 11 80    	mov    0x801121a0,%ecx
8010134e:	85 c9                	test   %ecx,%ecx
80101350:	0f 8e 3a fc ff ff    	jle    80100f90 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101356:	8b 15 14 21 11 80    	mov    0x80112114,%edx
8010135c:	a1 18 21 11 80       	mov    0x80112118,%eax
80101361:	89 d6                	mov    %edx,%esi
80101363:	09 c6                	or     %eax,%esi
80101365:	0f 88 31 03 00 00    	js     8010169c <consoleintr+0x72c>
8010136b:	39 c2                	cmp    %eax,%edx
8010136d:	0f 84 29 03 00 00    	je     8010169c <consoleintr+0x72c>
        replace_selection_with(input.clip, input.clip_len);
80101373:	89 ca                	mov    %ecx,%edx
80101375:	b8 1c 21 11 80       	mov    $0x8011211c,%eax
8010137a:	e8 d1 f7 ff ff       	call   80100b50 <replace_selection_with>
8010137f:	e9 0c fc ff ff       	jmp    80100f90 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101384:	8b 0d 18 21 11 80    	mov    0x80112118,%ecx
8010138a:	8b 15 14 21 11 80    	mov    0x80112114,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101390:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101395:	89 ce                	mov    %ecx,%esi
80101397:	09 d6                	or     %edx,%esi
80101399:	78 08                	js     801013a3 <consoleintr+0x433>
8010139b:	39 d1                	cmp    %edx,%ecx
8010139d:	0f 85 ad 01 00 00    	jne    80101550 <consoleintr+0x5e0>
      while (input.e != input.w &&
801013a3:	39 05 04 1f 11 80    	cmp    %eax,0x80111f04
801013a9:	0f 84 8e 04 00 00    	je     8010183d <consoleintr+0x8cd>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
801013af:	8d 50 ff             	lea    -0x1(%eax),%edx
801013b2:	89 d1                	mov    %edx,%ecx
801013b4:	83 e1 7f             	and    $0x7f,%ecx
      while (input.e != input.w &&
801013b7:	80 b9 80 1e 11 80 0a 	cmpb   $0xa,-0x7feee180(%ecx)
801013be:	0f 84 79 04 00 00    	je     8010183d <consoleintr+0x8cd>
  if (panicked)
801013c4:	a1 f8 21 11 80       	mov    0x801121f8,%eax
        input.e--;
801013c9:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
  if (panicked)
801013cf:	85 c0                	test   %eax,%eax
801013d1:	0f 84 49 04 00 00    	je     80101820 <consoleintr+0x8b0>
801013d7:	fa                   	cli
    for (;;)
801013d8:	eb fe                	jmp    801013d8 <consoleintr+0x468>
801013da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801013e0:	8b 1d 14 21 11 80    	mov    0x80112114,%ebx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801013e6:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801013eb:	85 db                	test   %ebx,%ebx
801013ed:	0f 88 65 02 00 00    	js     80101658 <consoleintr+0x6e8>
801013f3:	8b 15 18 21 11 80    	mov    0x80112118,%edx
801013f9:	39 d3                	cmp    %edx,%ebx
801013fb:	74 08                	je     80101405 <consoleintr+0x495>
801013fd:	85 d2                	test   %edx,%edx
801013ff:	0f 89 4b 01 00 00    	jns    80101550 <consoleintr+0x5e0>
      input.sel_b = (int)input.e; // 2nd Ctrl+S → set active end
80101405:	a3 18 21 11 80       	mov    %eax,0x80112118
8010140a:	89 c6                	mov    %eax,%esi
      if (input.sel_b == input.sel_a)
8010140c:	39 d8                	cmp    %ebx,%eax
8010140e:	0f 85 bc 04 00 00    	jne    801018d0 <consoleintr+0x960>
  input.sel_a = input.sel_b = -1;
80101414:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
8010141b:	ff ff ff 
8010141e:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
80101425:	ff ff ff 
}
80101428:	e9 63 fb ff ff       	jmp    80100f90 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010142d:	8b 15 18 21 11 80    	mov    0x80112118,%edx
80101433:	a1 14 21 11 80       	mov    0x80112114,%eax
80101438:	89 d6                	mov    %edx,%esi
8010143a:	09 c6                	or     %eax,%esi
8010143c:	0f 88 4e 02 00 00    	js     80101690 <consoleintr+0x720>
80101442:	39 c2                	cmp    %eax,%edx
80101444:	0f 84 46 02 00 00    	je     80101690 <consoleintr+0x720>
  full_redraw_after_edit(old_e);
8010144a:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  input.sel_a = input.sel_b = -1;
8010144f:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
80101456:	ff ff ff 
80101459:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
80101460:	ff ff ff 
  full_redraw_after_edit(old_e);
80101463:	e8 68 f4 ff ff       	call   801008d0 <full_redraw_after_edit>
}
80101468:	e9 23 fb ff ff       	jmp    80100f90 <consoleintr+0x20>
      input.temp_e = input.e;
8010146d:	a1 08 1f 11 80       	mov    0x80111f08,%eax
      wakeup(&input.r);
80101472:	83 ec 0c             	sub    $0xc,%esp
      input.temp_r = input.r;
80101475:	8b 15 04 1f 11 80    	mov    0x80111f04,%edx
      input.is_tab_mode = 1;
8010147b:	c7 05 9c 21 11 80 01 	movl   $0x1,0x8011219c
80101482:	00 00 00 
      input.buf[input.e++ % INPUT_BUF] = '\t';
80101485:	8d 48 01             	lea    0x1(%eax),%ecx
      input.temp_e = input.e;
80101488:	a3 b0 21 11 80       	mov    %eax,0x801121b0
      input.buf[input.e++ % INPUT_BUF] = '\t';
8010148d:	83 e0 7f             	and    $0x7f,%eax
80101490:	c6 80 80 1e 11 80 09 	movb   $0x9,-0x7feee180(%eax)
      input.temp_r = input.r;
80101497:	a1 00 1f 11 80       	mov    0x80111f00,%eax
8010149c:	89 15 a8 21 11 80    	mov    %edx,0x801121a8
801014a2:	a3 a4 21 11 80       	mov    %eax,0x801121a4
      input.temp_real_end = input.real_end;
801014a7:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
      input.buf[input.e++ % INPUT_BUF] = '\t';
801014ac:	89 0d 08 1f 11 80    	mov    %ecx,0x80111f08
      input.temp_real_end = input.real_end;
801014b2:	a3 ac 21 11 80       	mov    %eax,0x801121ac
      input.w = input.e;
801014b7:	89 0d 04 1f 11 80    	mov    %ecx,0x80111f04
      wakeup(&input.r);
801014bd:	68 00 1f 11 80       	push   $0x80111f00
801014c2:	e8 39 46 00 00       	call   80105b00 <wakeup>
      input.buf[input.e % INPUT_BUF] = '\0';
801014c7:	a1 08 1f 11 80       	mov    0x80111f08,%eax
      break;
801014cc:	83 c4 10             	add    $0x10,%esp
      input.buf[input.e % INPUT_BUF] = '\0';
801014cf:	89 c2                	mov    %eax,%edx
      input.e--;
801014d1:	83 e8 01             	sub    $0x1,%eax
801014d4:	a3 08 1f 11 80       	mov    %eax,0x80111f08
      input.real_end = input.temp_real_end;
801014d9:	a1 ac 21 11 80       	mov    0x801121ac,%eax
      input.buf[input.e % INPUT_BUF] = '\0';
801014de:	83 e2 7f             	and    $0x7f,%edx
801014e1:	c6 82 80 1e 11 80 00 	movb   $0x0,-0x7feee180(%edx)
      input.real_end = input.temp_real_end;
801014e8:	a3 0c 1f 11 80       	mov    %eax,0x80111f0c
  while ((c = getc()) >= 0)
801014ed:	ff d7                	call   *%edi
801014ef:	85 c0                	test   %eax,%eax
801014f1:	0f 89 a3 fa ff ff    	jns    80100f9a <consoleintr+0x2a>
801014f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014fe:	00 
801014ff:	90                   	nop
  release(&cons.lock);
80101500:	83 ec 0c             	sub    $0xc,%esp
80101503:	68 c0 21 11 80       	push   $0x801121c0
80101508:	e8 a3 4d 00 00       	call   801062b0 <release>
  if (doprocdump)
8010150d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101510:	83 c4 10             	add    $0x10,%esp
80101513:	85 c0                	test   %eax,%eax
80101515:	0f 85 36 03 00 00    	jne    80101851 <consoleintr+0x8e1>
}
8010151b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151e:	5b                   	pop    %ebx
8010151f:	5e                   	pop    %esi
80101520:	5f                   	pop    %edi
80101521:	5d                   	pop    %ebp
80101522:	c3                   	ret
80101523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101528:	8b 0d 14 21 11 80    	mov    0x80112114,%ecx
8010152e:	8b 15 18 21 11 80    	mov    0x80112118,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101534:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101539:	89 ce                	mov    %ecx,%esi
8010153b:	09 d6                	or     %edx,%esi
8010153d:	0f 88 1f 01 00 00    	js     80101662 <consoleintr+0x6f2>
80101543:	39 d1                	cmp    %edx,%ecx
80101545:	0f 84 17 01 00 00    	je     80101662 <consoleintr+0x6f2>
8010154b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  input.sel_a = input.sel_b = -1;
80101550:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
80101557:	ff ff ff 
8010155a:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
80101561:	ff ff ff 
        full_redraw_after_edit(old_e); // remove highlight
80101564:	e8 67 f3 ff ff       	call   801008d0 <full_redraw_after_edit>
        break;
80101569:	e9 22 fa ff ff       	jmp    80100f90 <consoleintr+0x20>
8010156e:	31 d2                	xor    %edx,%edx
80101570:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101575:	e8 56 f0 ff ff       	call   801005d0 <consputc.part.0>
        input.e--;
8010157a:	a1 08 1f 11 80       	mov    0x80111f08,%eax
8010157f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101582:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
80101588:	89 d0                	mov    %edx,%eax
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
8010158a:	85 d2                	test   %edx,%edx
8010158c:	0f 85 2f fc ff ff    	jne    801011c1 <consoleintr+0x251>
80101592:	e9 f9 f9 ff ff       	jmp    80100f90 <consoleintr+0x20>
80101597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010159e:	00 
8010159f:	90                   	nop
      if (input.e != input.w)
801015a0:	39 d9                	cmp    %ebx,%ecx
801015a2:	0f 84 e8 f9 ff ff    	je     80100f90 <consoleintr+0x20>
        if (input.e == input.real_end)
801015a8:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
          input.e--;
801015ad:	8d 53 ff             	lea    -0x1(%ebx),%edx
801015b0:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
        if (input.e == input.real_end)
801015b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
801015b9:	39 d8                	cmp    %ebx,%eax
801015bb:	0f 84 ff 03 00 00    	je     801019c0 <consoleintr+0xa50>
          for (uint i = input.e; i < input.real_end - 1; i++)
801015c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801015c4:	8d 70 ff             	lea    -0x1(%eax),%esi
801015c7:	89 d0                	mov    %edx,%eax
801015c9:	39 f2                	cmp    %esi,%edx
801015cb:	73 48                	jae    80101615 <consoleintr+0x6a5>
801015cd:	89 55 cc             	mov    %edx,-0x34(%ebp)
801015d0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
801015d3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
801015d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015dd:	00 
801015de:	66 90                	xchg   %ax,%ax
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801015e0:	89 c2                	mov    %eax,%edx
801015e2:	83 c0 01             	add    $0x1,%eax
801015e5:	89 c1                	mov    %eax,%ecx
801015e7:	83 e2 7f             	and    $0x7f,%edx
801015ea:	83 e1 7f             	and    $0x7f,%ecx
801015ed:	0f b6 99 80 1e 11 80 	movzbl -0x7feee180(%ecx),%ebx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
801015f4:	8b 0c 8d 10 1f 11 80 	mov    -0x7feee0f0(,%ecx,4),%ecx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
801015fb:	88 9a 80 1e 11 80    	mov    %bl,-0x7feee180(%edx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101601:	89 0c 95 10 1f 11 80 	mov    %ecx,-0x7feee0f0(,%edx,4)
          for (uint i = input.e; i < input.real_end - 1; i++)
80101608:	39 f0                	cmp    %esi,%eax
8010160a:	75 d4                	jne    801015e0 <consoleintr+0x670>
8010160c:	8b 55 cc             	mov    -0x34(%ebp),%edx
8010160f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80101612:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
          input.real_end--;
80101615:	89 35 0c 1f 11 80    	mov    %esi,0x80111f0c
          if (input.e > input.real_end)
8010161b:	39 d6                	cmp    %edx,%esi
8010161d:	0f 82 ed 02 00 00    	jb     80101910 <consoleintr+0x9a0>
          int old_cursor_off = old_e - (int)input.w;
80101623:	89 d8                	mov    %ebx,%eax
          if (old_cursor_off < 0)
80101625:	31 db                	xor    %ebx,%ebx
          int old_cursor_off = old_e - (int)input.w;
80101627:	29 c8                	sub    %ecx,%eax
          if (old_cursor_off < 0)
80101629:	85 c0                	test   %eax,%eax
8010162b:	0f 49 d8             	cmovns %eax,%ebx
8010162e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
          for (int i = 0; i < old_cursor_off; i++)
80101631:	bb 00 00 00 00       	mov    $0x0,%ebx
80101636:	0f 8e 3f 02 00 00    	jle    8010187b <consoleintr+0x90b>
8010163c:	89 55 c8             	mov    %edx,-0x38(%ebp)
8010163f:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  if (panicked)
80101642:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80101647:	85 c0                	test   %eax,%eax
80101649:	0f 84 0e 02 00 00    	je     8010185d <consoleintr+0x8ed>
8010164f:	fa                   	cli
    for (;;)
80101650:	eb fe                	jmp    80101650 <consoleintr+0x6e0>
80101652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.sel_a = (int)input.e;
80101658:	a3 14 21 11 80       	mov    %eax,0x80112114
        break;
8010165d:	e9 2e f9 ff ff       	jmp    80100f90 <consoleintr+0x20>
      if (input.e < input.real_end)
80101662:	3b 05 0c 1f 11 80    	cmp    0x80111f0c,%eax
80101668:	0f 83 22 f9 ff ff    	jae    80100f90 <consoleintr+0x20>
  if (panicked)
8010166e:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
        char ch = input.buf[input.e % INPUT_BUF];
80101674:	83 e0 7f             	and    $0x7f,%eax
80101677:	0f be 90 80 1e 11 80 	movsbl -0x7feee180(%eax),%edx
  if (panicked)
8010167e:	85 c9                	test   %ecx,%ecx
80101680:	0f 84 e2 02 00 00    	je     80101968 <consoleintr+0x9f8>
80101686:	fa                   	cli
    for (;;)
80101687:	eb fe                	jmp    80101687 <consoleintr+0x717>
80101689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80101690:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
80101697:	e9 f4 f8 ff ff       	jmp    80100f90 <consoleintr+0x20>
        int old_len = (int)input.real_end - (int)input.w;
8010169c:	a1 04 1f 11 80       	mov    0x80111f04,%eax
        uint old_e = input.e;
801016a1:	8b 1d 08 1f 11 80    	mov    0x80111f08,%ebx
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
801016a7:	ba 1c 21 11 80       	mov    $0x8011211c,%edx
        int old_len = (int)input.real_end - (int)input.w;
801016ac:	8b 35 0c 1f 11 80    	mov    0x80111f0c,%esi
801016b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
801016b5:	89 d8                	mov    %ebx,%eax
801016b7:	e8 c4 eb ff ff       	call   80100280 <insert_at>
801016bc:	89 c1                	mov    %eax,%ecx
        if (wrote <= 0)
801016be:	85 c0                	test   %eax,%eax
801016c0:	0f 8e ca f8 ff ff    	jle    80100f90 <consoleintr+0x20>
        if (input.sel_a >= 0 && input.sel_a > old_e)
801016c6:	a1 14 21 11 80       	mov    0x80112114,%eax
801016cb:	85 c0                	test   %eax,%eax
801016cd:	78 16                	js     801016e5 <consoleintr+0x775>
801016cf:	39 c3                	cmp    %eax,%ebx
801016d1:	73 12                	jae    801016e5 <consoleintr+0x775>
            input.sel_a = input.real_end;
801016d3:	8b 15 0c 1f 11 80    	mov    0x80111f0c,%edx
          if (input.sel_a > input.real_end) // Don't go beyond buffer limits
801016d9:	01 c8                	add    %ecx,%eax
            input.sel_a = input.real_end;
801016db:	39 d0                	cmp    %edx,%eax
801016dd:	0f 47 c2             	cmova  %edx,%eax
801016e0:	a3 14 21 11 80       	mov    %eax,0x80112114
        if (!was_end)
801016e5:	39 de                	cmp    %ebx,%esi
801016e7:	0f 84 a2 02 00 00    	je     8010198f <consoleintr+0xa1f>
        int old_len = (int)input.real_end - (int)input.w;
801016ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
801016f0:	29 c6                	sub    %eax,%esi
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
801016f2:	89 d8                	mov    %ebx,%eax
        int old_len = (int)input.real_end - (int)input.w;
801016f4:	89 f2                	mov    %esi,%edx
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
801016f6:	e8 15 f3 ff ff       	call   80100a10 <full_redraw_after_edit_len>
801016fb:	e9 90 f8 ff ff       	jmp    80100f90 <consoleintr+0x20>
      if (input.e < input.real_end)
80101700:	8b 35 08 1f 11 80    	mov    0x80111f08,%esi
80101706:	8b 1d 0c 1f 11 80    	mov    0x80111f0c,%ebx
8010170c:	39 de                	cmp    %ebx,%esi
8010170e:	0f 82 09 02 00 00    	jb     8010191d <consoleintr+0x9ad>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
80101714:	89 da                	mov    %ebx,%edx
80101716:	2b 15 00 1f 11 80    	sub    0x80111f00,%edx
8010171c:	83 fa 7f             	cmp    $0x7f,%edx
8010171f:	0f 87 6b f8 ff ff    	ja     80100f90 <consoleintr+0x20>
          char one[1] = {(char)ch};
80101725:	89 c1                	mov    %eax,%ecx
          c = (c == '\r') ? '\n' : c;
80101727:	83 f8 0d             	cmp    $0xd,%eax
8010172a:	75 0a                	jne    80101736 <consoleintr+0x7c6>
8010172c:	b9 0a 00 00 00       	mov    $0xa,%ecx
80101731:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80101736:	8d 56 01             	lea    0x1(%esi),%edx
80101739:	83 e6 7f             	and    $0x7f,%esi
8010173c:	88 8e 80 1e 11 80    	mov    %cl,-0x7feee180(%esi)
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101742:	8b 0d 10 21 11 80    	mov    0x80112110,%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80101748:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
8010174e:	83 c1 01             	add    $0x1,%ecx
80101751:	89 0d 10 21 11 80    	mov    %ecx,0x80112110
80101757:	89 0c b5 10 1f 11 80 	mov    %ecx,-0x7feee0f0(,%esi,4)
          if (input.e > input.real_end)
8010175e:	39 d3                	cmp    %edx,%ebx
80101760:	73 06                	jae    80101768 <consoleintr+0x7f8>
            input.real_end = input.e;
80101762:	89 15 0c 1f 11 80    	mov    %edx,0x80111f0c
  if (panicked)
80101768:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
8010176e:	85 d2                	test   %edx,%edx
80101770:	0f 84 5a 04 00 00    	je     80101bd0 <consoleintr+0xc60>
80101776:	fa                   	cli
    for (;;)
80101777:	eb fe                	jmp    80101777 <consoleintr+0x807>
80101779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w)
80101780:	39 d9                	cmp    %ebx,%ecx
80101782:	0f 84 08 f8 ff ff    	je     80100f90 <consoleintr+0x20>
        if ((input.sel_a >= input.e) && input.sel_a >= 0)
80101788:	39 da                	cmp    %ebx,%edx
8010178a:	0f 82 18 fe ff ff    	jb     801015a8 <consoleintr+0x638>
          input.sel_a--;
80101790:	8d 42 ff             	lea    -0x1(%edx),%eax
          if (input.sel_a < 0)
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 84 0d fe ff ff    	je     801015a8 <consoleintr+0x638>
          input.sel_a--;
8010179b:	a3 14 21 11 80       	mov    %eax,0x80112114
801017a0:	e9 03 fe ff ff       	jmp    801015a8 <consoleintr+0x638>
801017a5:	b8 e5 00 00 00       	mov    $0xe5,%eax
801017aa:	ba 20 00 00 00       	mov    $0x20,%edx
801017af:	e8 1c ee ff ff       	call   801005d0 <consputc.part.0>
        input.e++;
801017b4:	a1 08 1f 11 80       	mov    0x80111f08,%eax
801017b9:	83 c0 01             	add    $0x1,%eax
801017bc:	a3 08 1f 11 80       	mov    %eax,0x80111f08
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801017c1:	3b 05 0c 1f 11 80    	cmp    0x80111f0c,%eax
801017c7:	0f 83 c3 f7 ff ff    	jae    80100f90 <consoleintr+0x20>
801017cd:	83 e0 7f             	and    $0x7f,%eax
801017d0:	80 b8 80 1e 11 80 20 	cmpb   $0x20,-0x7feee180(%eax)
801017d7:	0f 85 b3 f7 ff ff    	jne    80100f90 <consoleintr+0x20>
  if (panicked)
801017dd:	8b 35 f8 21 11 80    	mov    0x801121f8,%esi
801017e3:	85 f6                	test   %esi,%esi
801017e5:	74 be                	je     801017a5 <consoleintr+0x835>
801017e7:	fa                   	cli
    for (;;)
801017e8:	eb fe                	jmp    801017e8 <consoleintr+0x878>
801017ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017f0:	b8 e5 00 00 00       	mov    $0xe5,%eax
801017f5:	e8 d6 ed ff ff       	call   801005d0 <consputc.part.0>
        input.e++;
801017fa:	a1 08 1f 11 80       	mov    0x80111f08,%eax
801017ff:	8d 50 01             	lea    0x1(%eax),%edx
80101802:	89 15 08 1f 11 80    	mov    %edx,0x80111f08
80101808:	89 d0                	mov    %edx,%eax
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
8010180a:	3b 15 0c 1f 11 80    	cmp    0x80111f0c,%edx
80101810:	0f 82 d7 f8 ff ff    	jb     801010ed <consoleintr+0x17d>
80101816:	e9 75 f7 ff ff       	jmp    80100f90 <consoleintr+0x20>
8010181b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101820:	b8 00 01 00 00       	mov    $0x100,%eax
80101825:	31 d2                	xor    %edx,%edx
80101827:	e8 a4 ed ff ff       	call   801005d0 <consputc.part.0>
      while (input.e != input.w &&
8010182c:	a1 08 1f 11 80       	mov    0x80111f08,%eax
80101831:	3b 05 04 1f 11 80    	cmp    0x80111f04,%eax
80101837:	0f 85 72 fb ff ff    	jne    801013af <consoleintr+0x43f>
      input.real_end = input.e;
8010183d:	a3 0c 1f 11 80       	mov    %eax,0x80111f0c
      input.current_time = 0;
80101842:	c7 05 10 21 11 80 00 	movl   $0x0,0x80112110
80101849:	00 00 00 
      break;
8010184c:	e9 3f f7 ff ff       	jmp    80100f90 <consoleintr+0x20>
}
80101851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101854:	5b                   	pop    %ebx
80101855:	5e                   	pop    %esi
80101856:	5f                   	pop    %edi
80101857:	5d                   	pop    %ebp
    procdump();
80101858:	e9 b3 43 00 00       	jmp    80105c10 <procdump>
8010185d:	31 d2                	xor    %edx,%edx
8010185f:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++)
80101864:	83 c3 01             	add    $0x1,%ebx
80101867:	e8 64 ed ff ff       	call   801005d0 <consputc.part.0>
8010186c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
8010186f:	0f 8f cd fd ff ff    	jg     80101642 <consoleintr+0x6d2>
80101875:	8b 55 c8             	mov    -0x38(%ebp),%edx
80101878:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
          int old_len = old_real_end - (int)input.w;
8010187b:	8b 45 d0             	mov    -0x30(%ebp),%eax
          if (old_len < 0)
8010187e:	bb 00 00 00 00       	mov    $0x0,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++)
80101883:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
          int old_len = old_real_end - (int)input.w;
8010188a:	29 c8                	sub    %ecx,%eax
          if (old_len < 0)
8010188c:	0f 49 d8             	cmovns %eax,%ebx
8010188f:	89 45 c8             	mov    %eax,-0x38(%ebp)
80101892:	89 d8                	mov    %ebx,%eax
min_int(int a, int b) { return a < b ? a : b; }
80101894:	bb 50 00 00 00       	mov    $0x50,%ebx
80101899:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010189c:	39 d8                	cmp    %ebx,%eax
8010189e:	89 d8                	mov    %ebx,%eax
801018a0:	0f 4e 45 d0          	cmovle -0x30(%ebp),%eax
801018a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
          for (int i = 0; i < min_int(old_len, 80); i++)
801018a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801018aa:	85 c0                	test   %eax,%eax
801018ac:	0f 8e 38 05 00 00    	jle    80101dea <consoleintr+0xe7a>
801018b2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
801018b5:	89 7d c4             	mov    %edi,-0x3c(%ebp)
801018b8:	89 d7                	mov    %edx,%edi
  if (panicked)
801018ba:	8b 1d f8 21 11 80    	mov    0x801121f8,%ebx
801018c0:	85 db                	test   %ebx,%ebx
801018c2:	0f 84 c8 02 00 00    	je     80101b90 <consoleintr+0xc20>
801018c8:	fa                   	cli
    for (;;)
801018c9:	eb fe                	jmp    801018c9 <consoleintr+0x959>
801018cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  int len = (int)input.real_end - (int)input.w;
801018d0:	8b 15 04 1f 11 80    	mov    0x80111f04,%edx
801018d6:	8b 0d 0c 1f 11 80    	mov    0x80111f0c,%ecx
  int off_from_start = old_e - (int)input.w;
801018dc:	29 d0                	sub    %edx,%eax
  int len = (int)input.real_end - (int)input.w;
801018de:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if (off_from_start < 0)
801018e1:	31 c9                	xor    %ecx,%ecx
801018e3:	85 c0                	test   %eax,%eax
801018e5:	0f 49 c8             	cmovns %eax,%ecx
801018e8:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  for (int i = 0; i < off_from_start; i++)
801018eb:	0f 8e 17 04 00 00    	jle    80101d08 <consoleintr+0xd98>
801018f1:	31 db                	xor    %ebx,%ebx
801018f3:	89 d6                	mov    %edx,%esi
  if (panicked)
801018f5:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
801018fb:	85 c9                	test   %ecx,%ecx
801018fd:	0f 84 dd 00 00 00    	je     801019e0 <consoleintr+0xa70>
80101903:	fa                   	cli
    for (;;)
80101904:	eb fe                	jmp    80101904 <consoleintr+0x994>
80101906:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010190d:	00 
8010190e:	66 90                	xchg   %ax,%ax
            input.e = input.real_end;
80101910:	89 35 08 1f 11 80    	mov    %esi,0x80111f08
80101916:	89 f2                	mov    %esi,%edx
80101918:	e9 06 fd ff ff       	jmp    80101623 <consoleintr+0x6b3>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
8010191d:	89 da                	mov    %ebx,%edx
8010191f:	2b 15 00 1f 11 80    	sub    0x80111f00,%edx
80101925:	83 fa 7f             	cmp    $0x7f,%edx
80101928:	0f 87 62 f6 ff ff    	ja     80100f90 <consoleintr+0x20>
  if (panicked)
8010192e:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
            input.real_end++;
80101934:	8d 4b 01             	lea    0x1(%ebx),%ecx
          if (c != '\n')
80101937:	83 f8 0a             	cmp    $0xa,%eax
8010193a:	0f 85 da 02 00 00    	jne    80101c1a <consoleintr+0xcaa>
              input.buf[input.e++ % INPUT_BUF] = '\n';
80101940:	89 d8                	mov    %ebx,%eax
80101942:	89 0d 08 1f 11 80    	mov    %ecx,0x80111f08
80101948:	83 e0 7f             	and    $0x7f,%eax
              input.real_end = input.e;
8010194b:	89 0d 0c 1f 11 80    	mov    %ecx,0x80111f0c
              input.buf[input.e++ % INPUT_BUF] = '\n';
80101951:	c6 80 80 1e 11 80 0a 	movb   $0xa,-0x7feee180(%eax)
  if (panicked)
80101958:	85 d2                	test   %edx,%edx
8010195a:	0f 84 5a 05 00 00    	je     80101eba <consoleintr+0xf4a>
80101960:	fa                   	cli
    for (;;)
80101961:	eb fe                	jmp    80101961 <consoleintr+0x9f1>
80101963:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101968:	b8 e5 00 00 00       	mov    $0xe5,%eax
8010196d:	e8 5e ec ff ff       	call   801005d0 <consputc.part.0>
        input.e++;
80101972:	83 05 08 1f 11 80 01 	addl   $0x1,0x80111f08
80101979:	e9 12 f6 ff ff       	jmp    80100f90 <consoleintr+0x20>
8010197e:	31 d2                	xor    %edx,%edx
80101980:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101985:	e8 46 ec ff ff       	call   801005d0 <consputc.part.0>
8010198a:	e9 01 f6 ff ff       	jmp    80100f90 <consoleintr+0x20>
          for (int i = 0; i < wrote; ++i)
8010198f:	31 db                	xor    %ebx,%ebx
80101991:	89 ce                	mov    %ecx,%esi
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
80101993:	a1 08 1f 11 80       	mov    0x80111f08,%eax
  if (panicked)
80101998:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
8010199e:	29 f0                	sub    %esi,%eax
801019a0:	01 d8                	add    %ebx,%eax
801019a2:	83 e0 7f             	and    $0x7f,%eax
801019a5:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
801019ac:	85 d2                	test   %edx,%edx
801019ae:	0f 84 64 01 00 00    	je     80101b18 <consoleintr+0xba8>
801019b4:	fa                   	cli
    for (;;)
801019b5:	eb fe                	jmp    801019b5 <consoleintr+0xa45>
801019b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019be:	00 
801019bf:	90                   	nop
  if (panicked)
801019c0:	a1 f8 21 11 80       	mov    0x801121f8,%eax
          input.real_end--;
801019c5:	89 15 0c 1f 11 80    	mov    %edx,0x80111f0c
  if (panicked)
801019cb:	85 c0                	test   %eax,%eax
801019cd:	0f 84 20 01 00 00    	je     80101af3 <consoleintr+0xb83>
801019d3:	fa                   	cli
    for (;;)
801019d4:	eb fe                	jmp    801019d4 <consoleintr+0xa64>
801019d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801019dd:	00 
801019de:	66 90                	xchg   %ax,%ax
801019e0:	31 d2                	xor    %edx,%edx
801019e2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < off_from_start; i++)
801019e7:	83 c3 01             	add    $0x1,%ebx
801019ea:	e8 e1 eb ff ff       	call   801005d0 <consputc.part.0>
801019ef:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
801019f2:	0f 8f fd fe ff ff    	jg     801018f5 <consoleintr+0x985>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
801019f8:	8b 1d 14 21 11 80    	mov    0x80112114,%ebx
801019fe:	89 f2                	mov    %esi,%edx
80101a00:	85 db                	test   %ebx,%ebx
80101a02:	0f 89 fa 02 00 00    	jns    80101d02 <consoleintr+0xd92>
  int sel = 0;
80101a08:	31 c9                	xor    %ecx,%ecx
  int lo = -1, hi = -1;
80101a0a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80101a0f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  int len = (int)input.real_end - (int)input.w;
80101a14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101a17:	29 d0                	sub    %edx,%eax
  if (len < 0)
80101a19:	31 d2                	xor    %edx,%edx
80101a1b:	85 c0                	test   %eax,%eax
80101a1d:	0f 49 d0             	cmovns %eax,%edx
80101a20:	89 55 cc             	mov    %edx,-0x34(%ebp)
  for (int i = 0; i < len; i++)
80101a23:	0f 8e b7 02 00 00    	jle    80101ce0 <consoleintr+0xd70>
    int in_sel = sel && idx >= lo && idx < hi;
80101a29:	89 c8                	mov    %ecx,%eax
  for (int i = 0; i < len; i++)
80101a2b:	31 c9                	xor    %ecx,%ecx
80101a2d:	89 7d c0             	mov    %edi,-0x40(%ebp)
    int in_sel = sel && idx >= lo && idx < hi;
80101a30:	83 e0 01             	and    $0x1,%eax
  for (int i = 0; i < len; i++)
80101a33:	89 cf                	mov    %ecx,%edi
    int in_sel = sel && idx >= lo && idx < hi;
80101a35:	88 45 c4             	mov    %al,-0x3c(%ebp)
    ushort prev = cg_attr;
80101a38:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80101a3f:	66 89 45 c8          	mov    %ax,-0x38(%ebp)
    int idx = (int)input.w + i;
80101a43:	a1 04 1f 11 80       	mov    0x80111f04,%eax
80101a48:	01 f8                	add    %edi,%eax
    int in_sel = sel && idx >= lo && idx < hi;
80101a4a:	39 f0                	cmp    %esi,%eax
80101a4c:	0f 9d c1             	setge  %cl
80101a4f:	39 d8                	cmp    %ebx,%eax
80101a51:	0f 9c c2             	setl   %dl
80101a54:	84 d1                	test   %dl,%cl
80101a56:	74 0b                	je     80101a63 <consoleintr+0xaf3>
80101a58:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
    cg_attr = in_sel ? 0x7000 : 0x0700;
80101a5c:	ba 00 70 00 00       	mov    $0x7000,%edx
    int in_sel = sel && idx >= lo && idx < hi;
80101a61:	75 05                	jne    80101a68 <consoleintr+0xaf8>
    cg_attr = in_sel ? 0x7000 : 0x0700;
80101a63:	ba 00 07 00 00       	mov    $0x700,%edx
80101a68:	66 89 15 00 b0 10 80 	mov    %dx,0x8010b000
    consputc(input.buf[idx % INPUT_BUF], 0);
80101a6f:	99                   	cltd
80101a70:	c1 ea 19             	shr    $0x19,%edx
80101a73:	01 d0                	add    %edx,%eax
80101a75:	83 e0 7f             	and    $0x7f,%eax
80101a78:	29 d0                	sub    %edx,%eax
  if (panicked)
80101a7a:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
    consputc(input.buf[idx % INPUT_BUF], 0);
80101a80:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
80101a87:	85 d2                	test   %edx,%edx
80101a89:	0f 84 31 02 00 00    	je     80101cc0 <consoleintr+0xd50>
80101a8f:	fa                   	cli
    for (;;)
80101a90:	eb fe                	jmp    80101a90 <consoleintr+0xb20>
80101a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80101a98:	85 c0                	test   %eax,%eax
80101a9a:	0f 84 f0 f4 ff ff    	je     80100f90 <consoleintr+0x20>
80101aa0:	83 e8 01             	sub    $0x1,%eax
80101aa3:	83 e0 7f             	and    $0x7f,%eax
80101aa6:	80 b8 80 1e 11 80 20 	cmpb   $0x20,-0x7feee180(%eax)
80101aad:	0f 84 dd f4 ff ff    	je     80100f90 <consoleintr+0x20>
  if (panicked)
80101ab3:	8b 15 f8 21 11 80    	mov    0x801121f8,%edx
80101ab9:	85 d2                	test   %edx,%edx
80101abb:	74 03                	je     80101ac0 <consoleintr+0xb50>
80101abd:	fa                   	cli
    for (;;)
80101abe:	eb fe                	jmp    80101abe <consoleintr+0xb4e>
80101ac0:	31 d2                	xor    %edx,%edx
80101ac2:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101ac7:	e8 04 eb ff ff       	call   801005d0 <consputc.part.0>
        input.e--;
80101acc:	a1 08 1f 11 80       	mov    0x80111f08,%eax
80101ad1:	83 e8 01             	sub    $0x1,%eax
80101ad4:	a3 08 1f 11 80       	mov    %eax,0x80111f08
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80101ad9:	75 c5                	jne    80101aa0 <consoleintr+0xb30>
80101adb:	e9 b0 f4 ff ff       	jmp    80100f90 <consoleintr+0x20>
        int n = hi - lo;
80101ae0:	29 c8                	sub    %ecx,%eax
80101ae2:	89 c3                	mov    %eax,%ebx
        if (n > INPUT_BUF)
80101ae4:	b8 80 00 00 00       	mov    $0x80,%eax
80101ae9:	39 c3                	cmp    %eax,%ebx
80101aeb:	0f 4f d8             	cmovg  %eax,%ebx
        for (int i = 0; i < n; ++i)
80101aee:	e9 66 f6 ff ff       	jmp    80101159 <consoleintr+0x1e9>
80101af3:	31 d2                	xor    %edx,%edx
80101af5:	b8 00 01 00 00       	mov    $0x100,%eax
80101afa:	e8 d1 ea ff ff       	call   801005d0 <consputc.part.0>
80101aff:	e9 8c f4 ff ff       	jmp    80100f90 <consoleintr+0x20>
  if (panicked)
80101b04:	8b 1d f8 21 11 80    	mov    0x801121f8,%ebx
80101b0a:	85 db                	test   %ebx,%ebx
80101b0c:	0f 84 5c fa ff ff    	je     8010156e <consoleintr+0x5fe>
80101b12:	fa                   	cli
    for (;;)
80101b13:	eb fe                	jmp    80101b13 <consoleintr+0xba3>
80101b15:	8d 76 00             	lea    0x0(%esi),%esi
80101b18:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < wrote; ++i)
80101b1a:	83 c3 01             	add    $0x1,%ebx
80101b1d:	e8 ae ea ff ff       	call   801005d0 <consputc.part.0>
80101b22:	39 de                	cmp    %ebx,%esi
80101b24:	0f 85 69 fe ff ff    	jne    80101993 <consoleintr+0xa23>
80101b2a:	e9 61 f4 ff ff       	jmp    80100f90 <consoleintr+0x20>
80101b2f:	31 d2                	xor    %edx,%edx
80101b31:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++)
80101b36:	83 c3 01             	add    $0x1,%ebx
80101b39:	e8 92 ea ff ff       	call   801005d0 <consputc.part.0>
80101b3e:	39 f3                	cmp    %esi,%ebx
80101b40:	0f 8c ee f7 ff ff    	jl     80101334 <consoleintr+0x3c4>
80101b46:	89 fa                	mov    %edi,%edx
80101b48:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80101b4b:	8b 7d c4             	mov    -0x3c(%ebp),%edi
          int old_len = old_real_end - (int)input.w;
80101b4e:	29 d3                	sub    %edx,%ebx
          if (old_len < 0)
80101b50:	b8 00 00 00 00       	mov    $0x0,%eax
80101b55:	0f 49 c3             	cmovns %ebx,%eax
80101b58:	89 c6                	mov    %eax,%esi
min_int(int a, int b) { return a < b ? a : b; }
80101b5a:	b8 50 00 00 00       	mov    $0x50,%eax
80101b5f:	39 c6                	cmp    %eax,%esi
80101b61:	0f 4f f0             	cmovg  %eax,%esi
          for (int i = 0; i < min_int(old_len, 80); i++)
80101b64:	31 c9                	xor    %ecx,%ecx
80101b66:	85 db                	test   %ebx,%ebx
80101b68:	0f 8e 92 03 00 00    	jle    80101f00 <consoleintr+0xf90>
80101b6e:	89 55 cc             	mov    %edx,-0x34(%ebp)
80101b71:	89 cb                	mov    %ecx,%ebx
80101b73:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80101b76:	89 f7                	mov    %esi,%edi
  if (panicked)
80101b78:	8b 35 f8 21 11 80    	mov    0x801121f8,%esi
80101b7e:	85 f6                	test   %esi,%esi
80101b80:	0f 84 aa 02 00 00    	je     80101e30 <consoleintr+0xec0>
80101b86:	fa                   	cli
    for (;;)
80101b87:	eb fe                	jmp    80101b87 <consoleintr+0xc17>
80101b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b90:	b8 20 00 00 00       	mov    $0x20,%eax
80101b95:	31 d2                	xor    %edx,%edx
80101b97:	e8 34 ea ff ff       	call   801005d0 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++)
80101b9c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80101ba0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80101ba3:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101ba6:	39 c8                	cmp    %ecx,%eax
80101ba8:	0f 8c 0c fd ff ff    	jl     801018ba <consoleintr+0x94a>
80101bae:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80101bb1:	89 fa                	mov    %edi,%edx
80101bb3:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80101bb6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80101bb9:	89 7d c8             	mov    %edi,-0x38(%ebp)
80101bbc:	89 d7                	mov    %edx,%edi
  if (panicked)
80101bbe:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80101bc3:	85 c0                	test   %eax,%eax
80101bc5:	0f 84 fd 01 00 00    	je     80101dc8 <consoleintr+0xe58>
80101bcb:	fa                   	cli
    for (;;)
80101bcc:	eb fe                	jmp    80101bcc <consoleintr+0xc5c>
80101bce:	66 90                	xchg   %ax,%ax
80101bd0:	31 d2                	xor    %edx,%edx
80101bd2:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101bd5:	e8 f6 e9 ff ff       	call   801005d0 <consputc.part.0>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
80101bda:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101bdd:	83 f8 0a             	cmp    $0xa,%eax
80101be0:	74 14                	je     80101bf6 <consoleintr+0xc86>
80101be2:	a1 00 1f 11 80       	mov    0x80111f00,%eax
80101be7:	83 e8 80             	sub    $0xffffff80,%eax
80101bea:	39 05 0c 1f 11 80    	cmp    %eax,0x80111f0c
80101bf0:	0f 85 9a f3 ff ff    	jne    80100f90 <consoleintr+0x20>
            input.w = input.e;
80101bf6:	a1 08 1f 11 80       	mov    0x80111f08,%eax
            wakeup(&input.r);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80101bfe:	a3 04 1f 11 80       	mov    %eax,0x80111f04
            input.real_end = input.e;
80101c03:	a3 0c 1f 11 80       	mov    %eax,0x80111f0c
            wakeup(&input.r);
80101c08:	68 00 1f 11 80       	push   $0x80111f00
80101c0d:	e8 ee 3e 00 00       	call   80105b00 <wakeup>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	e9 76 f3 ff ff       	jmp    80100f90 <consoleintr+0x20>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80101c1a:	83 eb 01             	sub    $0x1,%ebx
80101c1d:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80101c20:	8d 5e ff             	lea    -0x1(%esi),%ebx
80101c23:	89 5d d0             	mov    %ebx,-0x30(%ebp)
80101c26:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80101c29:	39 de                	cmp    %ebx,%esi
80101c2b:	7f 60                	jg     80101c8d <consoleintr+0xd1d>
80101c2d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80101c30:	89 75 c8             	mov    %esi,-0x38(%ebp)
80101c33:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80101c36:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80101c39:	89 55 c0             	mov    %edx,-0x40(%ebp)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101c3c:	89 d8                	mov    %ebx,%eax
80101c3e:	c1 f8 1f             	sar    $0x1f,%eax
80101c41:	c1 e8 19             	shr    $0x19,%eax
80101c44:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
80101c47:	83 e1 7f             	and    $0x7f,%ecx
80101c4a:	29 c1                	sub    %eax,%ecx
80101c4c:	8d 43 01             	lea    0x1(%ebx),%eax
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80101c4f:	83 eb 01             	sub    $0x1,%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101c52:	89 c6                	mov    %eax,%esi
80101c54:	0f b6 91 80 1e 11 80 	movzbl -0x7feee180(%ecx),%edx
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80101c5b:	8b 0c 8d 10 1f 11 80 	mov    -0x7feee0f0(,%ecx,4),%ecx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80101c62:	c1 fe 1f             	sar    $0x1f,%esi
80101c65:	c1 ee 19             	shr    $0x19,%esi
80101c68:	01 f0                	add    %esi,%eax
80101c6a:	83 e0 7f             	and    $0x7f,%eax
80101c6d:	29 f0                	sub    %esi,%eax
80101c6f:	88 90 80 1e 11 80    	mov    %dl,-0x7feee180(%eax)
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80101c75:	89 0c 85 10 1f 11 80 	mov    %ecx,-0x7feee0f0(,%eax,4)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
80101c7c:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
80101c7f:	75 bb                	jne    80101c3c <consoleintr+0xccc>
80101c81:	8b 75 c8             	mov    -0x38(%ebp),%esi
80101c84:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80101c87:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80101c8a:	8b 55 c0             	mov    -0x40(%ebp),%edx
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80101c8d:	8b 1d 10 21 11 80    	mov    0x80112110,%ebx
            input.buf[input.e % INPUT_BUF] = c;
80101c93:	83 e6 7f             	and    $0x7f,%esi
            input.real_end++;
80101c96:	89 0d 0c 1f 11 80    	mov    %ecx,0x80111f0c
            input.buf[input.e % INPUT_BUF] = c;
80101c9c:	88 86 80 1e 11 80    	mov    %al,-0x7feee180(%esi)
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80101ca2:	83 c3 01             	add    $0x1,%ebx
80101ca5:	89 1d 10 21 11 80    	mov    %ebx,0x80112110
80101cab:	89 1c b5 10 1f 11 80 	mov    %ebx,-0x7feee0f0(,%esi,4)
  if (panicked)
80101cb2:	85 d2                	test   %edx,%edx
80101cb4:	74 7a                	je     80101d30 <consoleintr+0xdc0>
80101cb6:	fa                   	cli
    for (;;)
80101cb7:	eb fe                	jmp    80101cb7 <consoleintr+0xd47>
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cc0:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < len; i++)
80101cc2:	83 c7 01             	add    $0x1,%edi
80101cc5:	e8 06 e9 ff ff       	call   801005d0 <consputc.part.0>
    cg_attr = prev;
80101cca:	0f b7 45 c8          	movzwl -0x38(%ebp),%eax
80101cce:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  for (int i = 0; i < len; i++)
80101cd4:	39 7d cc             	cmp    %edi,-0x34(%ebp)
80101cd7:	0f 8f 66 fd ff ff    	jg     80101a43 <consoleintr+0xad3>
80101cdd:	8b 7d c0             	mov    -0x40(%ebp),%edi
  int back = len - off_from_start;
80101ce0:	8b 75 cc             	mov    -0x34(%ebp),%esi
80101ce3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  for (int i = 0; i < back; i++)
80101ce6:	31 db                	xor    %ebx,%ebx
  int back = len - off_from_start;
80101ce8:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < back; i++)
80101cea:	85 f6                	test   %esi,%esi
80101cec:	0f 8e 9e f2 ff ff    	jle    80100f90 <consoleintr+0x20>
  if (panicked)
80101cf2:	a1 f8 21 11 80       	mov    0x801121f8,%eax
80101cf7:	85 c0                	test   %eax,%eax
80101cf9:	0f 84 c9 01 00 00    	je     80101ec8 <consoleintr+0xf58>
80101cff:	fa                   	cli
    for (;;)
80101d00:	eb fe                	jmp    80101d00 <consoleintr+0xd90>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
80101d02:	8b 35 18 21 11 80    	mov    0x80112118,%esi
80101d08:	39 f3                	cmp    %esi,%ebx
80101d0a:	0f 84 f8 fc ff ff    	je     80101a08 <consoleintr+0xa98>
80101d10:	85 f6                	test   %esi,%esi
80101d12:	0f 88 f0 fc ff ff    	js     80101a08 <consoleintr+0xa98>
    sel = 1;
80101d18:	b9 01 00 00 00       	mov    $0x1,%ecx
    if (lo > hi)
80101d1d:	39 f3                	cmp    %esi,%ebx
80101d1f:	0f 8f ef fc ff ff    	jg     80101a14 <consoleintr+0xaa4>
80101d25:	89 f0                	mov    %esi,%eax
    lo = input.sel_a;
80101d27:	89 de                	mov    %ebx,%esi
    hi = input.sel_b;
80101d29:	89 c3                	mov    %eax,%ebx
80101d2b:	e9 e4 fc ff ff       	jmp    80101a14 <consoleintr+0xaa4>
80101d30:	31 d2                	xor    %edx,%edx
80101d32:	e8 99 e8 ff ff       	call   801005d0 <consputc.part.0>
            if (input.sel_a >= 0 && input.sel_a > input.e)
80101d37:	8b 15 14 21 11 80    	mov    0x80112114,%edx
80101d3d:	8b 1d 08 1f 11 80    	mov    0x80111f08,%ebx
              if (input.sel_a > input.real_end)
80101d43:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
            if (input.sel_a >= 0 && input.sel_a > input.e)
80101d48:	85 d2                	test   %edx,%edx
80101d4a:	78 12                	js     80101d5e <consoleintr+0xdee>
80101d4c:	39 d3                	cmp    %edx,%ebx
80101d4e:	73 0e                	jae    80101d5e <consoleintr+0xdee>
              input.sel_a++;
80101d50:	83 c2 01             	add    $0x1,%edx
80101d53:	39 c2                	cmp    %eax,%edx
80101d55:	0f 47 d0             	cmova  %eax,%edx
80101d58:	89 15 14 21 11 80    	mov    %edx,0x80112114
            input.e++;
80101d5e:	83 c3 01             	add    $0x1,%ebx
80101d61:	89 1d 08 1f 11 80    	mov    %ebx,0x80111f08
            for (uint i = input.e; i < input.real_end; i++)
80101d67:	39 c3                	cmp    %eax,%ebx
80101d69:	0f 83 13 01 00 00    	jae    80101e82 <consoleintr+0xf12>
              consputc(input.buf[i % INPUT_BUF], 0);
80101d6f:	89 d8                	mov    %ebx,%eax
  if (panicked)
80101d71:	8b 35 f8 21 11 80    	mov    0x801121f8,%esi
              consputc(input.buf[i % INPUT_BUF], 0);
80101d77:	83 e0 7f             	and    $0x7f,%eax
80101d7a:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
80101d81:	85 f6                	test   %esi,%esi
80101d83:	74 0b                	je     80101d90 <consoleintr+0xe20>
80101d85:	fa                   	cli
    for (;;)
80101d86:	eb fe                	jmp    80101d86 <consoleintr+0xe16>
80101d88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d8f:	00 
80101d90:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80101d92:	83 c3 01             	add    $0x1,%ebx
80101d95:	e8 36 e8 ff ff       	call   801005d0 <consputc.part.0>
80101d9a:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
80101d9f:	39 c3                	cmp    %eax,%ebx
80101da1:	72 cc                	jb     80101d6f <consoleintr+0xdff>
            for (uint k = input.e; k < input.real_end; k++)
80101da3:	8b 1d 08 1f 11 80    	mov    0x80111f08,%ebx
80101da9:	39 c3                	cmp    %eax,%ebx
80101dab:	0f 83 d1 00 00 00    	jae    80101e82 <consoleintr+0xf12>
  if (panicked)
80101db1:	8b 0d f8 21 11 80    	mov    0x801121f8,%ecx
80101db7:	85 c9                	test   %ecx,%ecx
80101db9:	0f 84 a7 00 00 00    	je     80101e66 <consoleintr+0xef6>
80101dbf:	fa                   	cli
    for (;;)
80101dc0:	eb fe                	jmp    80101dc0 <consoleintr+0xe50>
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101dc8:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101dcd:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < min_int(old_len, 80); i++)
80101dcf:	83 c3 01             	add    $0x1,%ebx
80101dd2:	e8 f9 e7 ff ff       	call   801005d0 <consputc.part.0>
80101dd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101dda:	39 c3                	cmp    %eax,%ebx
80101ddc:	0f 8c dc fd ff ff    	jl     80101bbe <consoleintr+0xc4e>
80101de2:	89 fa                	mov    %edi,%edx
80101de4:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80101de7:	8b 7d c8             	mov    -0x38(%ebp),%edi
80101dea:	89 4d d0             	mov    %ecx,-0x30(%ebp)
          int new_len = (int)input.real_end - (int)input.w;
80101ded:	29 ce                	sub    %ecx,%esi
          if (new_len < 0)
80101def:	b8 00 00 00 00       	mov    $0x0,%eax
80101df4:	89 7d cc             	mov    %edi,-0x34(%ebp)
80101df7:	0f 48 f0             	cmovs  %eax,%esi
80101dfa:	89 d7                	mov    %edx,%edi
          for (int i = 0; i < new_len; i++)
80101dfc:	31 db                	xor    %ebx,%ebx
80101dfe:	39 de                	cmp    %ebx,%esi
80101e00:	0f 84 85 01 00 00    	je     80101f8b <consoleintr+0x101b>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101e06:	a1 04 1f 11 80       	mov    0x80111f04,%eax
80101e0b:	01 d8                	add    %ebx,%eax
80101e0d:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
80101e10:	83 3d f8 21 11 80 00 	cmpl   $0x0,0x801121f8
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101e17:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
80101e1e:	0f 84 58 01 00 00    	je     80101f7c <consoleintr+0x100c>
80101e24:	fa                   	cli
    for (;;)
80101e25:	eb fe                	jmp    80101e25 <consoleintr+0xeb5>
80101e27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e2e:	00 
80101e2f:	90                   	nop
80101e30:	31 d2                	xor    %edx,%edx
80101e32:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
80101e37:	83 c3 01             	add    $0x1,%ebx
80101e3a:	e8 91 e7 ff ff       	call   801005d0 <consputc.part.0>
80101e3f:	39 fb                	cmp    %edi,%ebx
80101e41:	0f 8c 31 fd ff ff    	jl     80101b78 <consoleintr+0xc08>
80101e47:	8b 55 cc             	mov    -0x34(%ebp),%edx
80101e4a:	89 f3                	mov    %esi,%ebx
80101e4c:	89 fe                	mov    %edi,%esi
80101e4e:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80101e51:	89 7d cc             	mov    %edi,-0x34(%ebp)
80101e54:	89 d7                	mov    %edx,%edi
  if (panicked)
80101e56:	83 3d f8 21 11 80 00 	cmpl   $0x0,0x801121f8
80101e5d:	0f 84 81 00 00 00    	je     80101ee4 <consoleintr+0xf74>
80101e63:	fa                   	cli
    for (;;)
80101e64:	eb fe                	jmp    80101e64 <consoleintr+0xef4>
80101e66:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101e6b:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
80101e6d:	83 c3 01             	add    $0x1,%ebx
80101e70:	e8 5b e7 ff ff       	call   801005d0 <consputc.part.0>
80101e75:	a1 0c 1f 11 80       	mov    0x80111f0c,%eax
80101e7a:	39 c3                	cmp    %eax,%ebx
80101e7c:	0f 82 2f ff ff ff    	jb     80101db1 <consoleintr+0xe41>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
80101e82:	8b 35 00 1f 11 80    	mov    0x80111f00,%esi
80101e88:	8d 96 80 00 00 00    	lea    0x80(%esi),%edx
80101e8e:	39 c2                	cmp    %eax,%edx
80101e90:	0f 85 fa f0 ff ff    	jne    80100f90 <consoleintr+0x20>
            input.e = input.real_end;
80101e96:	a3 08 1f 11 80       	mov    %eax,0x80111f08
            input.w = input.e;
80101e9b:	a1 08 1f 11 80       	mov    0x80111f08,%eax
            wakeup(&input.r);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80101ea3:	a3 04 1f 11 80       	mov    %eax,0x80111f04
            wakeup(&input.r);
80101ea8:	68 00 1f 11 80       	push   $0x80111f00
80101ead:	e8 4e 3c 00 00       	call   80105b00 <wakeup>
80101eb2:	83 c4 10             	add    $0x10,%esp
80101eb5:	e9 d6 f0 ff ff       	jmp    80100f90 <consoleintr+0x20>
80101eba:	31 d2                	xor    %edx,%edx
80101ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
80101ec1:	e8 0a e7 ff ff       	call   801005d0 <consputc.part.0>
80101ec6:	eb d3                	jmp    80101e9b <consoleintr+0xf2b>
80101ec8:	31 d2                	xor    %edx,%edx
80101eca:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < back; i++)
80101ecf:	83 c3 01             	add    $0x1,%ebx
80101ed2:	e8 f9 e6 ff ff       	call   801005d0 <consputc.part.0>
80101ed7:	39 de                	cmp    %ebx,%esi
80101ed9:	0f 85 13 fe ff ff    	jne    80101cf2 <consoleintr+0xd82>
80101edf:	e9 ac f0 ff ff       	jmp    80100f90 <consoleintr+0x20>
80101ee4:	31 d2                	xor    %edx,%edx
80101ee6:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
80101eeb:	83 c3 01             	add    $0x1,%ebx
80101eee:	e8 dd e6 ff ff       	call   801005d0 <consputc.part.0>
80101ef3:	39 f3                	cmp    %esi,%ebx
80101ef5:	0f 8c 5b ff ff ff    	jl     80101e56 <consoleintr+0xee6>
80101efb:	89 fa                	mov    %edi,%edx
80101efd:	8b 7d cc             	mov    -0x34(%ebp),%edi
          int new_len = (int)input.real_end - (int)input.w;
80101f00:	8b 75 c8             	mov    -0x38(%ebp),%esi
          if (new_len < 0)
80101f03:	b8 00 00 00 00       	mov    $0x0,%eax
80101f08:	89 7d cc             	mov    %edi,-0x34(%ebp)
80101f0b:	89 d7                	mov    %edx,%edi
          int new_len = (int)input.real_end - (int)input.w;
80101f0d:	29 d6                	sub    %edx,%esi
          if (new_len < 0)
80101f0f:	0f 48 f0             	cmovs  %eax,%esi
          for (int i = 0; i < new_len; i++)
80101f12:	31 db                	xor    %ebx,%ebx
80101f14:	39 de                	cmp    %ebx,%esi
80101f16:	74 29                	je     80101f41 <consoleintr+0xfd1>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101f18:	a1 04 1f 11 80       	mov    0x80111f04,%eax
80101f1d:	01 d8                	add    %ebx,%eax
80101f1f:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
80101f22:	83 3d f8 21 11 80 00 	cmpl   $0x0,0x801121f8
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101f29:	0f be 80 80 1e 11 80 	movsbl -0x7feee180(%eax),%eax
  if (panicked)
80101f30:	74 03                	je     80101f35 <consoleintr+0xfc5>
80101f32:	fa                   	cli
    for (;;)
80101f33:	eb fe                	jmp    80101f33 <consoleintr+0xfc3>
80101f35:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101f37:	83 c3 01             	add    $0x1,%ebx
80101f3a:	e8 91 e6 ff ff       	call   801005d0 <consputc.part.0>
80101f3f:	eb d3                	jmp    80101f14 <consoleintr+0xfa4>
          int new_cursor_off = (int)input.e - (int)input.w;
80101f41:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101f44:	89 fa                	mov    %edi,%edx
80101f46:	8b 7d cc             	mov    -0x34(%ebp),%edi
80101f49:	29 d0                	sub    %edx,%eax
          if (new_cursor_off < 0)
80101f4b:	ba 00 00 00 00       	mov    $0x0,%edx
80101f50:	0f 48 c2             	cmovs  %edx,%eax
          for (int i = 0; i < moves_left; i++)
80101f53:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
80101f55:	29 c6                	sub    %eax,%esi
          for (int i = 0; i < moves_left; i++)
80101f57:	39 f3                	cmp    %esi,%ebx
80101f59:	0f 8d 31 f0 ff ff    	jge    80100f90 <consoleintr+0x20>
  if (panicked)
80101f5f:	83 3d f8 21 11 80 00 	cmpl   $0x0,0x801121f8
80101f66:	74 03                	je     80101f6b <consoleintr+0xffb>
80101f68:	fa                   	cli
    for (;;)
80101f69:	eb fe                	jmp    80101f69 <consoleintr+0xff9>
80101f6b:	31 d2                	xor    %edx,%edx
80101f6d:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
80101f72:	83 c3 01             	add    $0x1,%ebx
80101f75:	e8 56 e6 ff ff       	call   801005d0 <consputc.part.0>
80101f7a:	eb db                	jmp    80101f57 <consoleintr+0xfe7>
80101f7c:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
80101f7e:	83 c3 01             	add    $0x1,%ebx
80101f81:	e8 4a e6 ff ff       	call   801005d0 <consputc.part.0>
80101f86:	e9 73 fe ff ff       	jmp    80101dfe <consoleintr+0xe8e>
          int new_cursor_off = (int)input.e - (int)input.w;
80101f8b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80101f8e:	89 fa                	mov    %edi,%edx
          if (new_cursor_off < 0)
80101f90:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
80101f95:	8b 7d cc             	mov    -0x34(%ebp),%edi
80101f98:	29 ca                	sub    %ecx,%edx
          if (new_cursor_off < 0)
80101f9a:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++)
80101f9d:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
80101f9f:	29 d6                	sub    %edx,%esi
          for (int i = 0; i < moves_left; i++)
80101fa1:	39 f3                	cmp    %esi,%ebx
80101fa3:	0f 8d e7 ef ff ff    	jge    80100f90 <consoleintr+0x20>
  if (panicked)
80101fa9:	83 3d f8 21 11 80 00 	cmpl   $0x0,0x801121f8
80101fb0:	74 03                	je     80101fb5 <consoleintr+0x1045>
80101fb2:	fa                   	cli
    for (;;)
80101fb3:	eb fe                	jmp    80101fb3 <consoleintr+0x1043>
80101fb5:	31 d2                	xor    %edx,%edx
80101fb7:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
80101fbc:	83 c3 01             	add    $0x1,%ebx
80101fbf:	e8 0c e6 ff ff       	call   801005d0 <consputc.part.0>
80101fc4:	eb db                	jmp    80101fa1 <consoleintr+0x1031>
80101fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101fcd:	00 
80101fce:	66 90                	xchg   %ax,%ax

80101fd0 <consoleinit>:

void consoleinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  input.is_tab_mode = 0;
80101fd6:	c7 05 9c 21 11 80 00 	movl   $0x0,0x8011219c
80101fdd:	00 00 00 
  initlock(&cons.lock, "console");
80101fe0:	68 68 96 10 80       	push   $0x80109668
80101fe5:	68 c0 21 11 80       	push   $0x801121c0
80101fea:	e8 31 41 00 00       	call   80106120 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  ioapicenable(IRQ_KBD, 0);
80101fef:	58                   	pop    %eax
80101ff0:	5a                   	pop    %edx
80101ff1:	6a 00                	push   $0x0
80101ff3:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80101ff5:	c7 05 ac 2b 11 80 d0 	movl   $0x80100bd0,0x80112bac
80101ffc:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80101fff:	c7 05 a8 2b 11 80 90 	movl   $0x80100390,0x80112ba8
80102006:	03 10 80 
  cons.locking = 1;
80102009:	c7 05 f4 21 11 80 01 	movl   $0x1,0x801121f4
80102010:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80102013:	e8 e8 19 00 00       	call   80103a00 <ioapicenable>
  input.sel_a = input.sel_b = -1;
  input.clip_len = 0;
  input.has_enter = 0;
}
80102018:	83 c4 10             	add    $0x10,%esp
  input.sel_a = input.sel_b = -1;
8010201b:	c7 05 18 21 11 80 ff 	movl   $0xffffffff,0x80112118
80102022:	ff ff ff 
80102025:	c7 05 14 21 11 80 ff 	movl   $0xffffffff,0x80112114
8010202c:	ff ff ff 
  input.clip_len = 0;
8010202f:	c7 05 a0 21 11 80 00 	movl   $0x0,0x801121a0
80102036:	00 00 00 
  input.has_enter = 0;
80102039:	c7 05 b4 21 11 80 00 	movl   $0x0,0x801121b4
80102040:	00 00 00 
}
80102043:	c9                   	leave
80102044:	c3                   	ret
80102045:	66 90                	xchg   %ax,%ax
80102047:	66 90                	xchg   %ax,%ax
80102049:	66 90                	xchg   %ax,%ax
8010204b:	66 90                	xchg   %ax,%ax
8010204d:	66 90                	xchg   %ax,%ax
8010204f:	90                   	nop

80102050 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010205c:	e8 cf 2f 00 00       	call   80105030 <myproc>
80102061:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80102067:	e8 74 22 00 00       	call   801042e0 <begin_op>

  if((ip = namei(path)) == 0){
8010206c:	83 ec 0c             	sub    $0xc,%esp
8010206f:	ff 75 08             	push   0x8(%ebp)
80102072:	e8 a9 15 00 00       	call   80103620 <namei>
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
8010207c:	0f 84 30 03 00 00    	je     801023b2 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80102082:	83 ec 0c             	sub    $0xc,%esp
80102085:	89 c7                	mov    %eax,%edi
80102087:	50                   	push   %eax
80102088:	e8 b3 0c 00 00       	call   80102d40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010208d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80102093:	6a 34                	push   $0x34
80102095:	6a 00                	push   $0x0
80102097:	50                   	push   %eax
80102098:	57                   	push   %edi
80102099:	e8 b2 0f 00 00       	call   80103050 <readi>
8010209e:	83 c4 20             	add    $0x20,%esp
801020a1:	83 f8 34             	cmp    $0x34,%eax
801020a4:	0f 85 01 01 00 00    	jne    801021ab <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
801020aa:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801020b1:	45 4c 46 
801020b4:	0f 85 f1 00 00 00    	jne    801021ab <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
801020ba:	e8 01 72 00 00       	call   801092c0 <setupkvm>
801020bf:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801020c5:	85 c0                	test   %eax,%eax
801020c7:	0f 84 de 00 00 00    	je     801021ab <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801020cd:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801020d4:	00 
801020d5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801020db:	0f 84 a1 02 00 00    	je     80102382 <exec+0x332>
  sz = 0;
801020e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801020e8:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801020eb:	31 db                	xor    %ebx,%ebx
801020ed:	e9 8c 00 00 00       	jmp    8010217e <exec+0x12e>
801020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
801020f8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801020ff:	75 6c                	jne    8010216d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80102101:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80102107:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
8010210d:	0f 82 87 00 00 00    	jb     8010219a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80102113:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80102119:	72 7f                	jb     8010219a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
8010211b:	83 ec 04             	sub    $0x4,%esp
8010211e:	50                   	push   %eax
8010211f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80102125:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010212b:	e8 c0 6f 00 00       	call   801090f0 <allocuvm>
80102130:	83 c4 10             	add    $0x10,%esp
80102133:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102139:	85 c0                	test   %eax,%eax
8010213b:	74 5d                	je     8010219a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
8010213d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80102143:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102148:	75 50                	jne    8010219a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
8010214a:	83 ec 0c             	sub    $0xc,%esp
8010214d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80102153:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80102159:	57                   	push   %edi
8010215a:	50                   	push   %eax
8010215b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102161:	e8 ba 6e 00 00       	call   80109020 <loaduvm>
80102166:	83 c4 20             	add    $0x20,%esp
80102169:	85 c0                	test   %eax,%eax
8010216b:	78 2d                	js     8010219a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010216d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80102174:	83 c3 01             	add    $0x1,%ebx
80102177:	83 c6 20             	add    $0x20,%esi
8010217a:	39 d8                	cmp    %ebx,%eax
8010217c:	7e 52                	jle    801021d0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
8010217e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80102184:	6a 20                	push   $0x20
80102186:	56                   	push   %esi
80102187:	50                   	push   %eax
80102188:	57                   	push   %edi
80102189:	e8 c2 0e 00 00       	call   80103050 <readi>
8010218e:	83 c4 10             	add    $0x10,%esp
80102191:	83 f8 20             	cmp    $0x20,%eax
80102194:	0f 84 5e ff ff ff    	je     801020f8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
8010219a:	83 ec 0c             	sub    $0xc,%esp
8010219d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801021a3:	e8 98 70 00 00       	call   80109240 <freevm>
  if(ip){
801021a8:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801021ab:	83 ec 0c             	sub    $0xc,%esp
801021ae:	57                   	push   %edi
801021af:	e8 1c 0e 00 00       	call   80102fd0 <iunlockput>
    end_op();
801021b4:	e8 97 21 00 00       	call   80104350 <end_op>
801021b9:	83 c4 10             	add    $0x10,%esp
    return -1;
801021bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
801021c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5e                   	pop    %esi
801021c6:	5f                   	pop    %edi
801021c7:	5d                   	pop    %ebp
801021c8:	c3                   	ret
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
801021d0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801021d6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
801021dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801021e2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	57                   	push   %edi
801021ec:	e8 df 0d 00 00       	call   80102fd0 <iunlockput>
  end_op();
801021f1:	e8 5a 21 00 00       	call   80104350 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801021f6:	83 c4 0c             	add    $0xc,%esp
801021f9:	53                   	push   %ebx
801021fa:	56                   	push   %esi
801021fb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80102201:	56                   	push   %esi
80102202:	e8 e9 6e 00 00       	call   801090f0 <allocuvm>
80102207:	83 c4 10             	add    $0x10,%esp
8010220a:	89 c7                	mov    %eax,%edi
8010220c:	85 c0                	test   %eax,%eax
8010220e:	0f 84 86 00 00 00    	je     8010229a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102214:	83 ec 08             	sub    $0x8,%esp
80102217:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
8010221d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010221f:	50                   	push   %eax
80102220:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80102221:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102223:	e8 38 71 00 00       	call   80109360 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102228:	8b 45 0c             	mov    0xc(%ebp),%eax
8010222b:	83 c4 10             	add    $0x10,%esp
8010222e:	8b 10                	mov    (%eax),%edx
80102230:	85 d2                	test   %edx,%edx
80102232:	0f 84 56 01 00 00    	je     8010238e <exec+0x33e>
80102238:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010223e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102241:	eb 23                	jmp    80102266 <exec+0x216>
80102243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102248:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
8010224b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80102252:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80102258:	8b 14 87             	mov    (%edi,%eax,4),%edx
8010225b:	85 d2                	test   %edx,%edx
8010225d:	74 51                	je     801022b0 <exec+0x260>
    if(argc >= MAXARG)
8010225f:	83 f8 20             	cmp    $0x20,%eax
80102262:	74 36                	je     8010229a <exec+0x24a>
80102264:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102266:	83 ec 0c             	sub    $0xc,%esp
80102269:	52                   	push   %edx
8010226a:	e8 91 43 00 00       	call   80106600 <strlen>
8010226f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102271:	58                   	pop    %eax
80102272:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102275:	83 eb 01             	sub    $0x1,%ebx
80102278:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010227b:	e8 80 43 00 00       	call   80106600 <strlen>
80102280:	83 c0 01             	add    $0x1,%eax
80102283:	50                   	push   %eax
80102284:	ff 34 b7             	push   (%edi,%esi,4)
80102287:	53                   	push   %ebx
80102288:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010228e:	e8 9d 72 00 00       	call   80109530 <copyout>
80102293:	83 c4 20             	add    $0x20,%esp
80102296:	85 c0                	test   %eax,%eax
80102298:	79 ae                	jns    80102248 <exec+0x1f8>
    freevm(pgdir);
8010229a:	83 ec 0c             	sub    $0xc,%esp
8010229d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801022a3:	e8 98 6f 00 00       	call   80109240 <freevm>
801022a8:	83 c4 10             	add    $0x10,%esp
801022ab:	e9 0c ff ff ff       	jmp    801021bc <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801022b0:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
801022b7:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801022bd:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801022c3:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
801022c6:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
801022c9:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
801022d0:	00 00 00 00 
  ustack[1] = argc;
801022d4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
801022da:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801022e1:	ff ff ff 
  ustack[1] = argc;
801022e4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801022ea:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
801022ec:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801022ee:	29 d0                	sub    %edx,%eax
801022f0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801022f6:	56                   	push   %esi
801022f7:	51                   	push   %ecx
801022f8:	53                   	push   %ebx
801022f9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801022ff:	e8 2c 72 00 00       	call   80109530 <copyout>
80102304:	83 c4 10             	add    $0x10,%esp
80102307:	85 c0                	test   %eax,%eax
80102309:	78 8f                	js     8010229a <exec+0x24a>
  for(last=s=path; *s; s++)
8010230b:	8b 45 08             	mov    0x8(%ebp),%eax
8010230e:	8b 55 08             	mov    0x8(%ebp),%edx
80102311:	0f b6 00             	movzbl (%eax),%eax
80102314:	84 c0                	test   %al,%al
80102316:	74 17                	je     8010232f <exec+0x2df>
80102318:	89 d1                	mov    %edx,%ecx
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80102320:	83 c1 01             	add    $0x1,%ecx
80102323:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102325:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102328:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010232b:	84 c0                	test   %al,%al
8010232d:	75 f1                	jne    80102320 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010232f:	83 ec 04             	sub    $0x4,%esp
80102332:	6a 10                	push   $0x10
80102334:	52                   	push   %edx
80102335:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010233b:	8d 46 6c             	lea    0x6c(%esi),%eax
8010233e:	50                   	push   %eax
8010233f:	e8 7c 42 00 00       	call   801065c0 <safestrcpy>
  curproc->pgdir = pgdir;
80102344:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010234a:	89 f0                	mov    %esi,%eax
8010234c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
8010234f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80102351:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102354:	89 c1                	mov    %eax,%ecx
80102356:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010235c:	8b 40 18             	mov    0x18(%eax),%eax
8010235f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80102362:	8b 41 18             	mov    0x18(%ecx),%eax
80102365:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80102368:	89 0c 24             	mov    %ecx,(%esp)
8010236b:	e8 20 6b 00 00       	call   80108e90 <switchuvm>
  freevm(oldpgdir);
80102370:	89 34 24             	mov    %esi,(%esp)
80102373:	e8 c8 6e 00 00       	call   80109240 <freevm>
  return 0;
80102378:	83 c4 10             	add    $0x10,%esp
8010237b:	31 c0                	xor    %eax,%eax
8010237d:	e9 3f fe ff ff       	jmp    801021c1 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102382:	bb 00 20 00 00       	mov    $0x2000,%ebx
80102387:	31 f6                	xor    %esi,%esi
80102389:	e9 5a fe ff ff       	jmp    801021e8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
8010238e:	be 10 00 00 00       	mov    $0x10,%esi
80102393:	ba 04 00 00 00       	mov    $0x4,%edx
80102398:	b8 03 00 00 00       	mov    $0x3,%eax
8010239d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801023a4:	00 00 00 
801023a7:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801023ad:	e9 17 ff ff ff       	jmp    801022c9 <exec+0x279>
    end_op();
801023b2:	e8 99 1f 00 00       	call   80104350 <end_op>
    cprintf("exec: fail\n");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 70 96 10 80       	push   $0x80109670
801023bf:	e8 9c e9 ff ff       	call   80100d60 <cprintf>
    return -1;
801023c4:	83 c4 10             	add    $0x10,%esp
801023c7:	e9 f0 fd ff ff       	jmp    801021bc <exec+0x16c>
801023cc:	66 90                	xchg   %ax,%ax
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801023d6:	68 7c 96 10 80       	push   $0x8010967c
801023db:	68 00 22 11 80       	push   $0x80112200
801023e0:	e8 3b 3d 00 00       	call   80106120 <initlock>
}
801023e5:	83 c4 10             	add    $0x10,%esp
801023e8:	c9                   	leave
801023e9:	c3                   	ret
801023ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801023f4:	bb 34 22 11 80       	mov    $0x80112234,%ebx
{
801023f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801023fc:	68 00 22 11 80       	push   $0x80112200
80102401:	e8 0a 3f 00 00       	call   80106310 <acquire>
80102406:	83 c4 10             	add    $0x10,%esp
80102409:	eb 10                	jmp    8010241b <filealloc+0x2b>
8010240b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102410:	83 c3 18             	add    $0x18,%ebx
80102413:	81 fb 94 2b 11 80    	cmp    $0x80112b94,%ebx
80102419:	74 25                	je     80102440 <filealloc+0x50>
    if(f->ref == 0){
8010241b:	8b 43 04             	mov    0x4(%ebx),%eax
8010241e:	85 c0                	test   %eax,%eax
80102420:	75 ee                	jne    80102410 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102422:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102425:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010242c:	68 00 22 11 80       	push   $0x80112200
80102431:	e8 7a 3e 00 00       	call   801062b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102436:	89 d8                	mov    %ebx,%eax
      return f;
80102438:	83 c4 10             	add    $0x10,%esp
}
8010243b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243e:	c9                   	leave
8010243f:	c3                   	ret
  release(&ftable.lock);
80102440:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102443:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102445:	68 00 22 11 80       	push   $0x80112200
8010244a:	e8 61 3e 00 00       	call   801062b0 <release>
}
8010244f:	89 d8                	mov    %ebx,%eax
  return 0;
80102451:	83 c4 10             	add    $0x10,%esp
}
80102454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102457:	c9                   	leave
80102458:	c3                   	ret
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102460 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	53                   	push   %ebx
80102464:	83 ec 10             	sub    $0x10,%esp
80102467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010246a:	68 00 22 11 80       	push   $0x80112200
8010246f:	e8 9c 3e 00 00       	call   80106310 <acquire>
  if(f->ref < 1)
80102474:	8b 43 04             	mov    0x4(%ebx),%eax
80102477:	83 c4 10             	add    $0x10,%esp
8010247a:	85 c0                	test   %eax,%eax
8010247c:	7e 1a                	jle    80102498 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010247e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102481:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102484:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102487:	68 00 22 11 80       	push   $0x80112200
8010248c:	e8 1f 3e 00 00       	call   801062b0 <release>
  return f;
}
80102491:	89 d8                	mov    %ebx,%eax
80102493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102496:	c9                   	leave
80102497:	c3                   	ret
    panic("filedup");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 83 96 10 80       	push   $0x80109683
801024a0:	e8 ab e0 ff ff       	call   80100550 <panic>
801024a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024ac:	00 
801024ad:	8d 76 00             	lea    0x0(%esi),%esi

801024b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 28             	sub    $0x28,%esp
801024b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801024bc:	68 00 22 11 80       	push   $0x80112200
801024c1:	e8 4a 3e 00 00       	call   80106310 <acquire>
  if(f->ref < 1)
801024c6:	8b 53 04             	mov    0x4(%ebx),%edx
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	85 d2                	test   %edx,%edx
801024ce:	0f 8e a5 00 00 00    	jle    80102579 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801024d4:	83 ea 01             	sub    $0x1,%edx
801024d7:	89 53 04             	mov    %edx,0x4(%ebx)
801024da:	75 44                	jne    80102520 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801024dc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801024e0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801024e3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801024e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801024eb:	8b 73 0c             	mov    0xc(%ebx),%esi
801024ee:	88 45 e7             	mov    %al,-0x19(%ebp)
801024f1:	8b 43 10             	mov    0x10(%ebx),%eax
801024f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801024f7:	68 00 22 11 80       	push   $0x80112200
801024fc:	e8 af 3d 00 00       	call   801062b0 <release>

  if(ff.type == FD_PIPE)
80102501:	83 c4 10             	add    $0x10,%esp
80102504:	83 ff 01             	cmp    $0x1,%edi
80102507:	74 57                	je     80102560 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102509:	83 ff 02             	cmp    $0x2,%edi
8010250c:	74 2a                	je     80102538 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010250e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102511:	5b                   	pop    %ebx
80102512:	5e                   	pop    %esi
80102513:	5f                   	pop    %edi
80102514:	5d                   	pop    %ebp
80102515:	c3                   	ret
80102516:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010251d:	00 
8010251e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80102520:	c7 45 08 00 22 11 80 	movl   $0x80112200,0x8(%ebp)
}
80102527:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252a:	5b                   	pop    %ebx
8010252b:	5e                   	pop    %esi
8010252c:	5f                   	pop    %edi
8010252d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010252e:	e9 7d 3d 00 00       	jmp    801062b0 <release>
80102533:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80102538:	e8 a3 1d 00 00       	call   801042e0 <begin_op>
    iput(ff.ip);
8010253d:	83 ec 0c             	sub    $0xc,%esp
80102540:	ff 75 e0             	push   -0x20(%ebp)
80102543:	e8 28 09 00 00       	call   80102e70 <iput>
    end_op();
80102548:	83 c4 10             	add    $0x10,%esp
}
8010254b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010254e:	5b                   	pop    %ebx
8010254f:	5e                   	pop    %esi
80102550:	5f                   	pop    %edi
80102551:	5d                   	pop    %ebp
    end_op();
80102552:	e9 f9 1d 00 00       	jmp    80104350 <end_op>
80102557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010255e:	00 
8010255f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80102560:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102564:	83 ec 08             	sub    $0x8,%esp
80102567:	53                   	push   %ebx
80102568:	56                   	push   %esi
80102569:	e8 32 25 00 00       	call   80104aa0 <pipeclose>
8010256e:	83 c4 10             	add    $0x10,%esp
}
80102571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102574:	5b                   	pop    %ebx
80102575:	5e                   	pop    %esi
80102576:	5f                   	pop    %edi
80102577:	5d                   	pop    %ebp
80102578:	c3                   	ret
    panic("fileclose");
80102579:	83 ec 0c             	sub    $0xc,%esp
8010257c:	68 8b 96 10 80       	push   $0x8010968b
80102581:	e8 ca df ff ff       	call   80100550 <panic>
80102586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010258d:	00 
8010258e:	66 90                	xchg   %ax,%ax

80102590 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	53                   	push   %ebx
80102594:	83 ec 04             	sub    $0x4,%esp
80102597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010259a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010259d:	75 31                	jne    801025d0 <filestat+0x40>
    ilock(f->ip);
8010259f:	83 ec 0c             	sub    $0xc,%esp
801025a2:	ff 73 10             	push   0x10(%ebx)
801025a5:	e8 96 07 00 00       	call   80102d40 <ilock>
    stati(f->ip, st);
801025aa:	58                   	pop    %eax
801025ab:	5a                   	pop    %edx
801025ac:	ff 75 0c             	push   0xc(%ebp)
801025af:	ff 73 10             	push   0x10(%ebx)
801025b2:	e8 69 0a 00 00       	call   80103020 <stati>
    iunlock(f->ip);
801025b7:	59                   	pop    %ecx
801025b8:	ff 73 10             	push   0x10(%ebx)
801025bb:	e8 60 08 00 00       	call   80102e20 <iunlock>
    return 0;
  }
  return -1;
}
801025c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801025c3:	83 c4 10             	add    $0x10,%esp
801025c6:	31 c0                	xor    %eax,%eax
}
801025c8:	c9                   	leave
801025c9:	c3                   	ret
801025ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801025d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801025d8:	c9                   	leave
801025d9:	c3                   	ret
801025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801025f2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801025f6:	74 60                	je     80102658 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801025f8:	8b 03                	mov    (%ebx),%eax
801025fa:	83 f8 01             	cmp    $0x1,%eax
801025fd:	74 41                	je     80102640 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801025ff:	83 f8 02             	cmp    $0x2,%eax
80102602:	75 5b                	jne    8010265f <fileread+0x7f>
    ilock(f->ip);
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	ff 73 10             	push   0x10(%ebx)
8010260a:	e8 31 07 00 00       	call   80102d40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010260f:	57                   	push   %edi
80102610:	ff 73 14             	push   0x14(%ebx)
80102613:	56                   	push   %esi
80102614:	ff 73 10             	push   0x10(%ebx)
80102617:	e8 34 0a 00 00       	call   80103050 <readi>
8010261c:	83 c4 20             	add    $0x20,%esp
8010261f:	89 c6                	mov    %eax,%esi
80102621:	85 c0                	test   %eax,%eax
80102623:	7e 03                	jle    80102628 <fileread+0x48>
      f->off += r;
80102625:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	ff 73 10             	push   0x10(%ebx)
8010262e:	e8 ed 07 00 00       	call   80102e20 <iunlock>
    return r;
80102633:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102639:	89 f0                	mov    %esi,%eax
8010263b:	5b                   	pop    %ebx
8010263c:	5e                   	pop    %esi
8010263d:	5f                   	pop    %edi
8010263e:	5d                   	pop    %ebp
8010263f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80102640:	8b 43 0c             	mov    0xc(%ebx),%eax
80102643:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102646:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102649:	5b                   	pop    %ebx
8010264a:	5e                   	pop    %esi
8010264b:	5f                   	pop    %edi
8010264c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010264d:	e9 0e 26 00 00       	jmp    80104c60 <piperead>
80102652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102658:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010265d:	eb d7                	jmp    80102636 <fileread+0x56>
  panic("fileread");
8010265f:	83 ec 0c             	sub    $0xc,%esp
80102662:	68 95 96 10 80       	push   $0x80109695
80102667:	e8 e4 de ff ff       	call   80100550 <panic>
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	57                   	push   %edi
80102674:	56                   	push   %esi
80102675:	53                   	push   %ebx
80102676:	83 ec 1c             	sub    $0x1c,%esp
80102679:	8b 45 0c             	mov    0xc(%ebp),%eax
8010267c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010267f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102682:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102685:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010268c:	0f 84 bb 00 00 00    	je     8010274d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80102692:	8b 03                	mov    (%ebx),%eax
80102694:	83 f8 01             	cmp    $0x1,%eax
80102697:	0f 84 bf 00 00 00    	je     8010275c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010269d:	83 f8 02             	cmp    $0x2,%eax
801026a0:	0f 85 c8 00 00 00    	jne    8010276e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801026a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801026a9:	31 f6                	xor    %esi,%esi
    while(i < n){
801026ab:	85 c0                	test   %eax,%eax
801026ad:	7f 30                	jg     801026df <filewrite+0x6f>
801026af:	e9 94 00 00 00       	jmp    80102748 <filewrite+0xd8>
801026b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801026b8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801026bb:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
801026be:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801026c1:	ff 73 10             	push   0x10(%ebx)
801026c4:	e8 57 07 00 00       	call   80102e20 <iunlock>
      end_op();
801026c9:	e8 82 1c 00 00       	call   80104350 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801026d1:	83 c4 10             	add    $0x10,%esp
801026d4:	39 c7                	cmp    %eax,%edi
801026d6:	75 5c                	jne    80102734 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801026d8:	01 fe                	add    %edi,%esi
    while(i < n){
801026da:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801026dd:	7e 69                	jle    80102748 <filewrite+0xd8>
      int n1 = n - i;
801026df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801026e2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801026e7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801026e9:	39 c7                	cmp    %eax,%edi
801026eb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801026ee:	e8 ed 1b 00 00       	call   801042e0 <begin_op>
      ilock(f->ip);
801026f3:	83 ec 0c             	sub    $0xc,%esp
801026f6:	ff 73 10             	push   0x10(%ebx)
801026f9:	e8 42 06 00 00       	call   80102d40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801026fe:	57                   	push   %edi
801026ff:	ff 73 14             	push   0x14(%ebx)
80102702:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102705:	01 f0                	add    %esi,%eax
80102707:	50                   	push   %eax
80102708:	ff 73 10             	push   0x10(%ebx)
8010270b:	e8 40 0a 00 00       	call   80103150 <writei>
80102710:	83 c4 20             	add    $0x20,%esp
80102713:	85 c0                	test   %eax,%eax
80102715:	7f a1                	jg     801026b8 <filewrite+0x48>
80102717:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010271a:	83 ec 0c             	sub    $0xc,%esp
8010271d:	ff 73 10             	push   0x10(%ebx)
80102720:	e8 fb 06 00 00       	call   80102e20 <iunlock>
      end_op();
80102725:	e8 26 1c 00 00       	call   80104350 <end_op>
      if(r < 0)
8010272a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	85 c0                	test   %eax,%eax
80102732:	75 14                	jne    80102748 <filewrite+0xd8>
        panic("short filewrite");
80102734:	83 ec 0c             	sub    $0xc,%esp
80102737:	68 9e 96 10 80       	push   $0x8010969e
8010273c:	e8 0f de ff ff       	call   80100550 <panic>
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102748:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010274b:	74 05                	je     80102752 <filewrite+0xe2>
8010274d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80102752:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102755:	89 f0                	mov    %esi,%eax
80102757:	5b                   	pop    %ebx
80102758:	5e                   	pop    %esi
80102759:	5f                   	pop    %edi
8010275a:	5d                   	pop    %ebp
8010275b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010275c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010275f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102762:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102765:	5b                   	pop    %ebx
80102766:	5e                   	pop    %esi
80102767:	5f                   	pop    %edi
80102768:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80102769:	e9 d2 23 00 00       	jmp    80104b40 <pipewrite>
  panic("filewrite");
8010276e:	83 ec 0c             	sub    $0xc,%esp
80102771:	68 a4 96 10 80       	push   $0x801096a4
80102776:	e8 d5 dd ff ff       	call   80100550 <panic>
8010277b:	66 90                	xchg   %ax,%ax
8010277d:	66 90                	xchg   %ax,%ax
8010277f:	90                   	nop

80102780 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	57                   	push   %edi
80102784:	56                   	push   %esi
80102785:	53                   	push   %ebx
80102786:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80102789:	8b 0d 54 48 11 80    	mov    0x80114854,%ecx
{
8010278f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80102792:	85 c9                	test   %ecx,%ecx
80102794:	0f 84 8c 00 00 00    	je     80102826 <balloc+0xa6>
8010279a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010279c:	89 f8                	mov    %edi,%eax
8010279e:	83 ec 08             	sub    $0x8,%esp
801027a1:	89 fe                	mov    %edi,%esi
801027a3:	c1 f8 0c             	sar    $0xc,%eax
801027a6:	03 05 6c 48 11 80    	add    0x8011486c,%eax
801027ac:	50                   	push   %eax
801027ad:	ff 75 dc             	push   -0x24(%ebp)
801027b0:	e8 1b d9 ff ff       	call   801000d0 <bread>
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801027bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801027be:	a1 54 48 11 80       	mov    0x80114854,%eax
801027c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801027c6:	31 c0                	xor    %eax,%eax
801027c8:	eb 32                	jmp    801027fc <balloc+0x7c>
801027ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801027d0:	89 c1                	mov    %eax,%ecx
801027d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801027d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801027da:	83 e1 07             	and    $0x7,%ecx
801027dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801027df:	89 c1                	mov    %eax,%ecx
801027e1:	c1 f9 03             	sar    $0x3,%ecx
801027e4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801027e9:	89 fa                	mov    %edi,%edx
801027eb:	85 df                	test   %ebx,%edi
801027ed:	74 49                	je     80102838 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801027ef:	83 c0 01             	add    $0x1,%eax
801027f2:	83 c6 01             	add    $0x1,%esi
801027f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801027fa:	74 07                	je     80102803 <balloc+0x83>
801027fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801027ff:	39 d6                	cmp    %edx,%esi
80102801:	72 cd                	jb     801027d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80102803:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102806:	83 ec 0c             	sub    $0xc,%esp
80102809:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010280c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80102812:	e8 d9 d9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80102817:	83 c4 10             	add    $0x10,%esp
8010281a:	3b 3d 54 48 11 80    	cmp    0x80114854,%edi
80102820:	0f 82 76 ff ff ff    	jb     8010279c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80102826:	83 ec 0c             	sub    $0xc,%esp
80102829:	68 ae 96 10 80       	push   $0x801096ae
8010282e:	e8 1d dd ff ff       	call   80100550 <panic>
80102833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80102838:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010283b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010283e:	09 da                	or     %ebx,%edx
80102840:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80102844:	57                   	push   %edi
80102845:	e8 76 1c 00 00       	call   801044c0 <log_write>
        brelse(bp);
8010284a:	89 3c 24             	mov    %edi,(%esp)
8010284d:	e8 9e d9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80102852:	58                   	pop    %eax
80102853:	5a                   	pop    %edx
80102854:	56                   	push   %esi
80102855:	ff 75 dc             	push   -0x24(%ebp)
80102858:	e8 73 d8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010285d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80102860:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80102862:	8d 40 5c             	lea    0x5c(%eax),%eax
80102865:	68 00 02 00 00       	push   $0x200
8010286a:	6a 00                	push   $0x0
8010286c:	50                   	push   %eax
8010286d:	e8 9e 3b 00 00       	call   80106410 <memset>
  log_write(bp);
80102872:	89 1c 24             	mov    %ebx,(%esp)
80102875:	e8 46 1c 00 00       	call   801044c0 <log_write>
  brelse(bp);
8010287a:	89 1c 24             	mov    %ebx,(%esp)
8010287d:	e8 6e d9 ff ff       	call   801001f0 <brelse>
}
80102882:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102885:	89 f0                	mov    %esi,%eax
80102887:	5b                   	pop    %ebx
80102888:	5e                   	pop    %esi
80102889:	5f                   	pop    %edi
8010288a:	5d                   	pop    %ebp
8010288b:	c3                   	ret
8010288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102890 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80102894:	31 ff                	xor    %edi,%edi
{
80102896:	56                   	push   %esi
80102897:	89 c6                	mov    %eax,%esi
80102899:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010289a:	bb 34 2c 11 80       	mov    $0x80112c34,%ebx
{
8010289f:	83 ec 28             	sub    $0x28,%esp
801028a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801028a5:	68 00 2c 11 80       	push   $0x80112c00
801028aa:	e8 61 3a 00 00       	call   80106310 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801028af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801028b2:	83 c4 10             	add    $0x10,%esp
801028b5:	eb 1b                	jmp    801028d2 <iget+0x42>
801028b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028be:	00 
801028bf:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801028c0:	39 33                	cmp    %esi,(%ebx)
801028c2:	74 6c                	je     80102930 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801028c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801028ca:	81 fb 54 48 11 80    	cmp    $0x80114854,%ebx
801028d0:	74 26                	je     801028f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801028d2:	8b 43 08             	mov    0x8(%ebx),%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	7f e7                	jg     801028c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801028d9:	85 ff                	test   %edi,%edi
801028db:	75 e7                	jne    801028c4 <iget+0x34>
801028dd:	85 c0                	test   %eax,%eax
801028df:	75 76                	jne    80102957 <iget+0xc7>
      empty = ip;
801028e1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801028e3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801028e9:	81 fb 54 48 11 80    	cmp    $0x80114854,%ebx
801028ef:	75 e1                	jne    801028d2 <iget+0x42>
801028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801028f8:	85 ff                	test   %edi,%edi
801028fa:	74 79                	je     80102975 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801028fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801028ff:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80102901:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80102904:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010290b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80102912:	68 00 2c 11 80       	push   $0x80112c00
80102917:	e8 94 39 00 00       	call   801062b0 <release>

  return ip;
8010291c:	83 c4 10             	add    $0x10,%esp
}
8010291f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102922:	89 f8                	mov    %edi,%eax
80102924:	5b                   	pop    %ebx
80102925:	5e                   	pop    %esi
80102926:	5f                   	pop    %edi
80102927:	5d                   	pop    %ebp
80102928:	c3                   	ret
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102930:	39 53 04             	cmp    %edx,0x4(%ebx)
80102933:	75 8f                	jne    801028c4 <iget+0x34>
      ip->ref++;
80102935:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80102938:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010293b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010293d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80102940:	68 00 2c 11 80       	push   $0x80112c00
80102945:	e8 66 39 00 00       	call   801062b0 <release>
      return ip;
8010294a:	83 c4 10             	add    $0x10,%esp
}
8010294d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102950:	89 f8                	mov    %edi,%eax
80102952:	5b                   	pop    %ebx
80102953:	5e                   	pop    %esi
80102954:	5f                   	pop    %edi
80102955:	5d                   	pop    %ebp
80102956:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80102957:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010295d:	81 fb 54 48 11 80    	cmp    $0x80114854,%ebx
80102963:	74 10                	je     80102975 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80102965:	8b 43 08             	mov    0x8(%ebx),%eax
80102968:	85 c0                	test   %eax,%eax
8010296a:	0f 8f 50 ff ff ff    	jg     801028c0 <iget+0x30>
80102970:	e9 68 ff ff ff       	jmp    801028dd <iget+0x4d>
    panic("iget: no inodes");
80102975:	83 ec 0c             	sub    $0xc,%esp
80102978:	68 c4 96 10 80       	push   $0x801096c4
8010297d:	e8 ce db ff ff       	call   80100550 <panic>
80102982:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102989:	00 
8010298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102990 <bfree>:
{
80102990:	55                   	push   %ebp
80102991:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80102993:	89 d0                	mov    %edx,%eax
80102995:	c1 e8 0c             	shr    $0xc,%eax
{
80102998:	89 e5                	mov    %esp,%ebp
8010299a:	56                   	push   %esi
8010299b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010299c:	03 05 6c 48 11 80    	add    0x8011486c,%eax
{
801029a2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801029a4:	83 ec 08             	sub    $0x8,%esp
801029a7:	50                   	push   %eax
801029a8:	51                   	push   %ecx
801029a9:	e8 22 d7 ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801029ae:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801029b0:	c1 fb 03             	sar    $0x3,%ebx
801029b3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801029b6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801029b8:	83 e1 07             	and    $0x7,%ecx
801029bb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801029c0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801029c6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801029c8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801029cd:	85 c1                	test   %eax,%ecx
801029cf:	74 23                	je     801029f4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801029d1:	f7 d0                	not    %eax
  log_write(bp);
801029d3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801029d6:	21 c8                	and    %ecx,%eax
801029d8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801029dc:	56                   	push   %esi
801029dd:	e8 de 1a 00 00       	call   801044c0 <log_write>
  brelse(bp);
801029e2:	89 34 24             	mov    %esi,(%esp)
801029e5:	e8 06 d8 ff ff       	call   801001f0 <brelse>
}
801029ea:	83 c4 10             	add    $0x10,%esp
801029ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029f0:	5b                   	pop    %ebx
801029f1:	5e                   	pop    %esi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret
    panic("freeing free block");
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	68 d4 96 10 80       	push   $0x801096d4
801029fc:	e8 4f db ff ff       	call   80100550 <panic>
80102a01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a08:	00 
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a10 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	89 c6                	mov    %eax,%esi
80102a17:	53                   	push   %ebx
80102a18:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80102a1b:	83 fa 0b             	cmp    $0xb,%edx
80102a1e:	0f 86 8c 00 00 00    	jbe    80102ab0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80102a24:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80102a27:	83 fb 7f             	cmp    $0x7f,%ebx
80102a2a:	0f 87 a2 00 00 00    	ja     80102ad2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80102a30:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80102a36:	85 c0                	test   %eax,%eax
80102a38:	74 5e                	je     80102a98 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80102a3a:	83 ec 08             	sub    $0x8,%esp
80102a3d:	50                   	push   %eax
80102a3e:	ff 36                	push   (%esi)
80102a40:	e8 8b d6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80102a45:	83 c4 10             	add    $0x10,%esp
80102a48:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
80102a4c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80102a4e:	8b 3b                	mov    (%ebx),%edi
80102a50:	85 ff                	test   %edi,%edi
80102a52:	74 1c                	je     80102a70 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80102a54:	83 ec 0c             	sub    $0xc,%esp
80102a57:	52                   	push   %edx
80102a58:	e8 93 d7 ff ff       	call   801001f0 <brelse>
80102a5d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80102a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a63:	89 f8                	mov    %edi,%eax
80102a65:	5b                   	pop    %ebx
80102a66:	5e                   	pop    %esi
80102a67:	5f                   	pop    %edi
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80102a73:	8b 06                	mov    (%esi),%eax
80102a75:	e8 06 fd ff ff       	call   80102780 <balloc>
      log_write(bp);
80102a7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102a7d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80102a80:	89 03                	mov    %eax,(%ebx)
80102a82:	89 c7                	mov    %eax,%edi
      log_write(bp);
80102a84:	52                   	push   %edx
80102a85:	e8 36 1a 00 00       	call   801044c0 <log_write>
80102a8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102a8d:	83 c4 10             	add    $0x10,%esp
80102a90:	eb c2                	jmp    80102a54 <bmap+0x44>
80102a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80102a98:	8b 06                	mov    (%esi),%eax
80102a9a:	e8 e1 fc ff ff       	call   80102780 <balloc>
80102a9f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80102aa5:	eb 93                	jmp    80102a3a <bmap+0x2a>
80102aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102aae:	00 
80102aaf:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80102ab0:	8d 5a 14             	lea    0x14(%edx),%ebx
80102ab3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80102ab7:	85 ff                	test   %edi,%edi
80102ab9:	75 a5                	jne    80102a60 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
80102abb:	8b 00                	mov    (%eax),%eax
80102abd:	e8 be fc ff ff       	call   80102780 <balloc>
80102ac2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80102ac6:	89 c7                	mov    %eax,%edi
}
80102ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acb:	5b                   	pop    %ebx
80102acc:	89 f8                	mov    %edi,%eax
80102ace:	5e                   	pop    %esi
80102acf:	5f                   	pop    %edi
80102ad0:	5d                   	pop    %ebp
80102ad1:	c3                   	ret
  panic("bmap: out of range");
80102ad2:	83 ec 0c             	sub    $0xc,%esp
80102ad5:	68 e7 96 10 80       	push   $0x801096e7
80102ada:	e8 71 da ff ff       	call   80100550 <panic>
80102adf:	90                   	nop

80102ae0 <readsb>:
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80102ae8:	83 ec 08             	sub    $0x8,%esp
80102aeb:	6a 01                	push   $0x1
80102aed:	ff 75 08             	push   0x8(%ebp)
80102af0:	e8 db d5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102af5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102af8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80102afa:	8d 40 5c             	lea    0x5c(%eax),%eax
80102afd:	6a 1c                	push   $0x1c
80102aff:	50                   	push   %eax
80102b00:	56                   	push   %esi
80102b01:	e8 9a 39 00 00       	call   801064a0 <memmove>
  brelse(bp);
80102b06:	83 c4 10             	add    $0x10,%esp
80102b09:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5d                   	pop    %ebp
  brelse(bp);
80102b12:	e9 d9 d6 ff ff       	jmp    801001f0 <brelse>
80102b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102b1e:	00 
80102b1f:	90                   	nop

80102b20 <iinit>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	bb 40 2c 11 80       	mov    $0x80112c40,%ebx
80102b29:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80102b2c:	68 fa 96 10 80       	push   $0x801096fa
80102b31:	68 00 2c 11 80       	push   $0x80112c00
80102b36:	e8 e5 35 00 00       	call   80106120 <initlock>
  for(i = 0; i < NINODE; i++) {
80102b3b:	83 c4 10             	add    $0x10,%esp
80102b3e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102b40:	83 ec 08             	sub    $0x8,%esp
80102b43:	68 01 97 10 80       	push   $0x80109701
80102b48:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102b49:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80102b4f:	e8 9c 34 00 00       	call   80105ff0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80102b54:	83 c4 10             	add    $0x10,%esp
80102b57:	81 fb 60 48 11 80    	cmp    $0x80114860,%ebx
80102b5d:	75 e1                	jne    80102b40 <iinit+0x20>
  bp = bread(dev, 1);
80102b5f:	83 ec 08             	sub    $0x8,%esp
80102b62:	6a 01                	push   $0x1
80102b64:	ff 75 08             	push   0x8(%ebp)
80102b67:	e8 64 d5 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80102b6c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80102b6f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80102b71:	8d 40 5c             	lea    0x5c(%eax),%eax
80102b74:	6a 1c                	push   $0x1c
80102b76:	50                   	push   %eax
80102b77:	68 54 48 11 80       	push   $0x80114854
80102b7c:	e8 1f 39 00 00       	call   801064a0 <memmove>
  brelse(bp);
80102b81:	89 1c 24             	mov    %ebx,(%esp)
80102b84:	e8 67 d6 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80102b89:	ff 35 6c 48 11 80    	push   0x8011486c
80102b8f:	ff 35 68 48 11 80    	push   0x80114868
80102b95:	ff 35 64 48 11 80    	push   0x80114864
80102b9b:	ff 35 60 48 11 80    	push   0x80114860
80102ba1:	ff 35 5c 48 11 80    	push   0x8011485c
80102ba7:	ff 35 58 48 11 80    	push   0x80114858
80102bad:	ff 35 54 48 11 80    	push   0x80114854
80102bb3:	68 94 9c 10 80       	push   $0x80109c94
80102bb8:	e8 a3 e1 ff ff       	call   80100d60 <cprintf>
}
80102bbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bc0:	83 c4 30             	add    $0x30,%esp
80102bc3:	c9                   	leave
80102bc4:	c3                   	ret
80102bc5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bcc:	00 
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi

80102bd0 <ialloc>:
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 1c             	sub    $0x1c,%esp
80102bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80102bdc:	83 3d 5c 48 11 80 01 	cmpl   $0x1,0x8011485c
{
80102be3:	8b 75 08             	mov    0x8(%ebp),%esi
80102be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80102be9:	0f 86 91 00 00 00    	jbe    80102c80 <ialloc+0xb0>
80102bef:	bf 01 00 00 00       	mov    $0x1,%edi
80102bf4:	eb 21                	jmp    80102c17 <ialloc+0x47>
80102bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102bfd:	00 
80102bfe:	66 90                	xchg   %ax,%ax
    brelse(bp);
80102c00:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80102c03:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80102c06:	53                   	push   %ebx
80102c07:	e8 e4 d5 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80102c0c:	83 c4 10             	add    $0x10,%esp
80102c0f:	3b 3d 5c 48 11 80    	cmp    0x8011485c,%edi
80102c15:	73 69                	jae    80102c80 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80102c17:	89 f8                	mov    %edi,%eax
80102c19:	83 ec 08             	sub    $0x8,%esp
80102c1c:	c1 e8 03             	shr    $0x3,%eax
80102c1f:	03 05 68 48 11 80    	add    0x80114868,%eax
80102c25:	50                   	push   %eax
80102c26:	56                   	push   %esi
80102c27:	e8 a4 d4 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80102c2c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80102c2f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80102c31:	89 f8                	mov    %edi,%eax
80102c33:	83 e0 07             	and    $0x7,%eax
80102c36:	c1 e0 06             	shl    $0x6,%eax
80102c39:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80102c3d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102c41:	75 bd                	jne    80102c00 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80102c43:	83 ec 04             	sub    $0x4,%esp
80102c46:	6a 40                	push   $0x40
80102c48:	6a 00                	push   $0x0
80102c4a:	51                   	push   %ecx
80102c4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102c4e:	e8 bd 37 00 00       	call   80106410 <memset>
      dip->type = type;
80102c53:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102c57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102c5a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80102c5d:	89 1c 24             	mov    %ebx,(%esp)
80102c60:	e8 5b 18 00 00       	call   801044c0 <log_write>
      brelse(bp);
80102c65:	89 1c 24             	mov    %ebx,(%esp)
80102c68:	e8 83 d5 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80102c6d:	83 c4 10             	add    $0x10,%esp
}
80102c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102c73:	89 fa                	mov    %edi,%edx
}
80102c75:	5b                   	pop    %ebx
      return iget(dev, inum);
80102c76:	89 f0                	mov    %esi,%eax
}
80102c78:	5e                   	pop    %esi
80102c79:	5f                   	pop    %edi
80102c7a:	5d                   	pop    %ebp
      return iget(dev, inum);
80102c7b:	e9 10 fc ff ff       	jmp    80102890 <iget>
  panic("ialloc: no inodes");
80102c80:	83 ec 0c             	sub    $0xc,%esp
80102c83:	68 07 97 10 80       	push   $0x80109707
80102c88:	e8 c3 d8 ff ff       	call   80100550 <panic>
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi

80102c90 <iupdate>:
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	56                   	push   %esi
80102c94:	53                   	push   %ebx
80102c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102c98:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102c9b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102c9e:	83 ec 08             	sub    $0x8,%esp
80102ca1:	c1 e8 03             	shr    $0x3,%eax
80102ca4:	03 05 68 48 11 80    	add    0x80114868,%eax
80102caa:	50                   	push   %eax
80102cab:	ff 73 a4             	push   -0x5c(%ebx)
80102cae:	e8 1d d4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80102cb3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102cb7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102cba:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102cbc:	8b 43 a8             	mov    -0x58(%ebx),%eax
80102cbf:	83 e0 07             	and    $0x7,%eax
80102cc2:	c1 e0 06             	shl    $0x6,%eax
80102cc5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102cc9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80102ccc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102cd0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102cd3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102cd7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80102cdb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80102cdf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102ce3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102ce7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80102cea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102ced:	6a 34                	push   $0x34
80102cef:	53                   	push   %ebx
80102cf0:	50                   	push   %eax
80102cf1:	e8 aa 37 00 00       	call   801064a0 <memmove>
  log_write(bp);
80102cf6:	89 34 24             	mov    %esi,(%esp)
80102cf9:	e8 c2 17 00 00       	call   801044c0 <log_write>
  brelse(bp);
80102cfe:	83 c4 10             	add    $0x10,%esp
80102d01:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d07:	5b                   	pop    %ebx
80102d08:	5e                   	pop    %esi
80102d09:	5d                   	pop    %ebp
  brelse(bp);
80102d0a:	e9 e1 d4 ff ff       	jmp    801001f0 <brelse>
80102d0f:	90                   	nop

80102d10 <idup>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 10             	sub    $0x10,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80102d1a:	68 00 2c 11 80       	push   $0x80112c00
80102d1f:	e8 ec 35 00 00       	call   80106310 <acquire>
  ip->ref++;
80102d24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102d28:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102d2f:	e8 7c 35 00 00       	call   801062b0 <release>
}
80102d34:	89 d8                	mov    %ebx,%eax
80102d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d39:	c9                   	leave
80102d3a:	c3                   	ret
80102d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d40 <ilock>:
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	56                   	push   %esi
80102d44:	53                   	push   %ebx
80102d45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80102d48:	85 db                	test   %ebx,%ebx
80102d4a:	0f 84 b7 00 00 00    	je     80102e07 <ilock+0xc7>
80102d50:	8b 53 08             	mov    0x8(%ebx),%edx
80102d53:	85 d2                	test   %edx,%edx
80102d55:	0f 8e ac 00 00 00    	jle    80102e07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80102d5b:	83 ec 0c             	sub    $0xc,%esp
80102d5e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102d61:	50                   	push   %eax
80102d62:	e8 c9 32 00 00       	call   80106030 <acquiresleep>
  if(ip->valid == 0){
80102d67:	8b 43 4c             	mov    0x4c(%ebx),%eax
80102d6a:	83 c4 10             	add    $0x10,%esp
80102d6d:	85 c0                	test   %eax,%eax
80102d6f:	74 0f                	je     80102d80 <ilock+0x40>
}
80102d71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d74:	5b                   	pop    %ebx
80102d75:	5e                   	pop    %esi
80102d76:	5d                   	pop    %ebp
80102d77:	c3                   	ret
80102d78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d7f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102d80:	8b 43 04             	mov    0x4(%ebx),%eax
80102d83:	83 ec 08             	sub    $0x8,%esp
80102d86:	c1 e8 03             	shr    $0x3,%eax
80102d89:	03 05 68 48 11 80    	add    0x80114868,%eax
80102d8f:	50                   	push   %eax
80102d90:	ff 33                	push   (%ebx)
80102d92:	e8 39 d3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102d97:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102d9a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102d9c:	8b 43 04             	mov    0x4(%ebx),%eax
80102d9f:	83 e0 07             	and    $0x7,%eax
80102da2:	c1 e0 06             	shl    $0x6,%eax
80102da5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102da9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102dac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80102daf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102db3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102db7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80102dbb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80102dbf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102dc3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102dc7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80102dcb:	8b 50 fc             	mov    -0x4(%eax),%edx
80102dce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102dd1:	6a 34                	push   $0x34
80102dd3:	50                   	push   %eax
80102dd4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102dd7:	50                   	push   %eax
80102dd8:	e8 c3 36 00 00       	call   801064a0 <memmove>
    brelse(bp);
80102ddd:	89 34 24             	mov    %esi,(%esp)
80102de0:	e8 0b d4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102de5:	83 c4 10             	add    $0x10,%esp
80102de8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80102ded:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102df4:	0f 85 77 ff ff ff    	jne    80102d71 <ilock+0x31>
      panic("ilock: no type");
80102dfa:	83 ec 0c             	sub    $0xc,%esp
80102dfd:	68 1f 97 10 80       	push   $0x8010971f
80102e02:	e8 49 d7 ff ff       	call   80100550 <panic>
    panic("ilock");
80102e07:	83 ec 0c             	sub    $0xc,%esp
80102e0a:	68 19 97 10 80       	push   $0x80109719
80102e0f:	e8 3c d7 ff ff       	call   80100550 <panic>
80102e14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e1b:	00 
80102e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e20 <iunlock>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	56                   	push   %esi
80102e24:	53                   	push   %ebx
80102e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102e28:	85 db                	test   %ebx,%ebx
80102e2a:	74 28                	je     80102e54 <iunlock+0x34>
80102e2c:	83 ec 0c             	sub    $0xc,%esp
80102e2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80102e32:	56                   	push   %esi
80102e33:	e8 98 32 00 00       	call   801060d0 <holdingsleep>
80102e38:	83 c4 10             	add    $0x10,%esp
80102e3b:	85 c0                	test   %eax,%eax
80102e3d:	74 15                	je     80102e54 <iunlock+0x34>
80102e3f:	8b 43 08             	mov    0x8(%ebx),%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	7e 0e                	jle    80102e54 <iunlock+0x34>
  releasesleep(&ip->lock);
80102e46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102e49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e4c:	5b                   	pop    %ebx
80102e4d:	5e                   	pop    %esi
80102e4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102e4f:	e9 3c 32 00 00       	jmp    80106090 <releasesleep>
    panic("iunlock");
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 2e 97 10 80       	push   $0x8010972e
80102e5c:	e8 ef d6 ff ff       	call   80100550 <panic>
80102e61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e68:	00 
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e70 <iput>:
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	57                   	push   %edi
80102e74:	56                   	push   %esi
80102e75:	53                   	push   %ebx
80102e76:	83 ec 28             	sub    $0x28,%esp
80102e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102e7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102e7f:	57                   	push   %edi
80102e80:	e8 ab 31 00 00       	call   80106030 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102e85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102e88:	83 c4 10             	add    $0x10,%esp
80102e8b:	85 d2                	test   %edx,%edx
80102e8d:	74 07                	je     80102e96 <iput+0x26>
80102e8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102e94:	74 32                	je     80102ec8 <iput+0x58>
  releasesleep(&ip->lock);
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	57                   	push   %edi
80102e9a:	e8 f1 31 00 00       	call   80106090 <releasesleep>
  acquire(&icache.lock);
80102e9f:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102ea6:	e8 65 34 00 00       	call   80106310 <acquire>
  ip->ref--;
80102eab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102eaf:	83 c4 10             	add    $0x10,%esp
80102eb2:	c7 45 08 00 2c 11 80 	movl   $0x80112c00,0x8(%ebp)
}
80102eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ebc:	5b                   	pop    %ebx
80102ebd:	5e                   	pop    %esi
80102ebe:	5f                   	pop    %edi
80102ebf:	5d                   	pop    %ebp
  release(&icache.lock);
80102ec0:	e9 eb 33 00 00       	jmp    801062b0 <release>
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102ec8:	83 ec 0c             	sub    $0xc,%esp
80102ecb:	68 00 2c 11 80       	push   $0x80112c00
80102ed0:	e8 3b 34 00 00       	call   80106310 <acquire>
    int r = ip->ref;
80102ed5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102ed8:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102edf:	e8 cc 33 00 00       	call   801062b0 <release>
    if(r == 1){
80102ee4:	83 c4 10             	add    $0x10,%esp
80102ee7:	83 fe 01             	cmp    $0x1,%esi
80102eea:	75 aa                	jne    80102e96 <iput+0x26>
80102eec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102ef2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102ef5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102ef8:	89 df                	mov    %ebx,%edi
80102efa:	89 cb                	mov    %ecx,%ebx
80102efc:	eb 09                	jmp    80102f07 <iput+0x97>
80102efe:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102f00:	83 c6 04             	add    $0x4,%esi
80102f03:	39 de                	cmp    %ebx,%esi
80102f05:	74 19                	je     80102f20 <iput+0xb0>
    if(ip->addrs[i]){
80102f07:	8b 16                	mov    (%esi),%edx
80102f09:	85 d2                	test   %edx,%edx
80102f0b:	74 f3                	je     80102f00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80102f0d:	8b 07                	mov    (%edi),%eax
80102f0f:	e8 7c fa ff ff       	call   80102990 <bfree>
      ip->addrs[i] = 0;
80102f14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102f1a:	eb e4                	jmp    80102f00 <iput+0x90>
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102f20:	89 fb                	mov    %edi,%ebx
80102f22:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102f25:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102f2b:	85 c0                	test   %eax,%eax
80102f2d:	75 2d                	jne    80102f5c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102f2f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102f32:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80102f39:	53                   	push   %ebx
80102f3a:	e8 51 fd ff ff       	call   80102c90 <iupdate>
      ip->type = 0;
80102f3f:	31 c0                	xor    %eax,%eax
80102f41:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80102f45:	89 1c 24             	mov    %ebx,(%esp)
80102f48:	e8 43 fd ff ff       	call   80102c90 <iupdate>
      ip->valid = 0;
80102f4d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102f54:	83 c4 10             	add    $0x10,%esp
80102f57:	e9 3a ff ff ff       	jmp    80102e96 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102f5c:	83 ec 08             	sub    $0x8,%esp
80102f5f:	50                   	push   %eax
80102f60:	ff 33                	push   (%ebx)
80102f62:	e8 69 d1 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80102f67:	83 c4 10             	add    $0x10,%esp
80102f6a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102f6d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f76:	8d 70 5c             	lea    0x5c(%eax),%esi
80102f79:	89 cf                	mov    %ecx,%edi
80102f7b:	eb 0a                	jmp    80102f87 <iput+0x117>
80102f7d:	8d 76 00             	lea    0x0(%esi),%esi
80102f80:	83 c6 04             	add    $0x4,%esi
80102f83:	39 fe                	cmp    %edi,%esi
80102f85:	74 0f                	je     80102f96 <iput+0x126>
      if(a[j])
80102f87:	8b 16                	mov    (%esi),%edx
80102f89:	85 d2                	test   %edx,%edx
80102f8b:	74 f3                	je     80102f80 <iput+0x110>
        bfree(ip->dev, a[j]);
80102f8d:	8b 03                	mov    (%ebx),%eax
80102f8f:	e8 fc f9 ff ff       	call   80102990 <bfree>
80102f94:	eb ea                	jmp    80102f80 <iput+0x110>
    brelse(bp);
80102f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f99:	83 ec 0c             	sub    $0xc,%esp
80102f9c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102f9f:	50                   	push   %eax
80102fa0:	e8 4b d2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102fa5:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102fab:	8b 03                	mov    (%ebx),%eax
80102fad:	e8 de f9 ff ff       	call   80102990 <bfree>
    ip->addrs[NDIRECT] = 0;
80102fb2:	83 c4 10             	add    $0x10,%esp
80102fb5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102fbc:	00 00 00 
80102fbf:	e9 6b ff ff ff       	jmp    80102f2f <iput+0xbf>
80102fc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fcb:	00 
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <iunlockput>:
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	56                   	push   %esi
80102fd4:	53                   	push   %ebx
80102fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102fd8:	85 db                	test   %ebx,%ebx
80102fda:	74 34                	je     80103010 <iunlockput+0x40>
80102fdc:	83 ec 0c             	sub    $0xc,%esp
80102fdf:	8d 73 0c             	lea    0xc(%ebx),%esi
80102fe2:	56                   	push   %esi
80102fe3:	e8 e8 30 00 00       	call   801060d0 <holdingsleep>
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	85 c0                	test   %eax,%eax
80102fed:	74 21                	je     80103010 <iunlockput+0x40>
80102fef:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff2:	85 c0                	test   %eax,%eax
80102ff4:	7e 1a                	jle    80103010 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102ff6:	83 ec 0c             	sub    $0xc,%esp
80102ff9:	56                   	push   %esi
80102ffa:	e8 91 30 00 00       	call   80106090 <releasesleep>
  iput(ip);
80102fff:	83 c4 10             	add    $0x10,%esp
80103002:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103005:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103008:	5b                   	pop    %ebx
80103009:	5e                   	pop    %esi
8010300a:	5d                   	pop    %ebp
  iput(ip);
8010300b:	e9 60 fe ff ff       	jmp    80102e70 <iput>
    panic("iunlock");
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 2e 97 10 80       	push   $0x8010972e
80103018:	e8 33 d5 ff ff       	call   80100550 <panic>
8010301d:	8d 76 00             	lea    0x0(%esi),%esi

80103020 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	8b 55 08             	mov    0x8(%ebp),%edx
80103026:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80103029:	8b 0a                	mov    (%edx),%ecx
8010302b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010302e:	8b 4a 04             	mov    0x4(%edx),%ecx
80103031:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80103034:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80103038:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010303b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010303f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80103043:	8b 52 58             	mov    0x58(%edx),%edx
80103046:	89 50 10             	mov    %edx,0x10(%eax)
}
80103049:	5d                   	pop    %ebp
8010304a:	c3                   	ret
8010304b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103050 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
80103059:	8b 75 08             	mov    0x8(%ebp),%esi
8010305c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010305f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
80103062:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80103067:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010306a:	89 75 d8             	mov    %esi,-0x28(%ebp)
8010306d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80103070:	0f 84 aa 00 00 00    	je     80103120 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80103076:	8b 75 d8             	mov    -0x28(%ebp),%esi
80103079:	8b 56 58             	mov    0x58(%esi),%edx
8010307c:	39 fa                	cmp    %edi,%edx
8010307e:	0f 82 bd 00 00 00    	jb     80103141 <readi+0xf1>
80103084:	89 f9                	mov    %edi,%ecx
80103086:	31 db                	xor    %ebx,%ebx
80103088:	01 c1                	add    %eax,%ecx
8010308a:	0f 92 c3             	setb   %bl
8010308d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103090:	0f 82 ab 00 00 00    	jb     80103141 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80103096:	89 d3                	mov    %edx,%ebx
80103098:	29 fb                	sub    %edi,%ebx
8010309a:	39 ca                	cmp    %ecx,%edx
8010309c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010309f:	85 c0                	test   %eax,%eax
801030a1:	74 73                	je     80103116 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801030a3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801030a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801030b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801030b3:	89 fa                	mov    %edi,%edx
801030b5:	c1 ea 09             	shr    $0x9,%edx
801030b8:	89 d8                	mov    %ebx,%eax
801030ba:	e8 51 f9 ff ff       	call   80102a10 <bmap>
801030bf:	83 ec 08             	sub    $0x8,%esp
801030c2:	50                   	push   %eax
801030c3:	ff 33                	push   (%ebx)
801030c5:	e8 06 d0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801030ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030cd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801030d2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801030d4:	89 f8                	mov    %edi,%eax
801030d6:	25 ff 01 00 00       	and    $0x1ff,%eax
801030db:	29 f3                	sub    %esi,%ebx
801030dd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801030df:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801030e3:	39 d9                	cmp    %ebx,%ecx
801030e5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801030e8:	83 c4 0c             	add    $0xc,%esp
801030eb:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801030ec:	01 de                	add    %ebx,%esi
801030ee:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
801030f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801030f3:	50                   	push   %eax
801030f4:	ff 75 e0             	push   -0x20(%ebp)
801030f7:	e8 a4 33 00 00       	call   801064a0 <memmove>
    brelse(bp);
801030fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801030ff:	89 14 24             	mov    %edx,(%esp)
80103102:	e8 e9 d0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80103107:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010310a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010310d:	83 c4 10             	add    $0x10,%esp
80103110:	39 de                	cmp    %ebx,%esi
80103112:	72 9c                	jb     801030b0 <readi+0x60>
80103114:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80103116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103119:	5b                   	pop    %ebx
8010311a:	5e                   	pop    %esi
8010311b:	5f                   	pop    %edi
8010311c:	5d                   	pop    %ebp
8010311d:	c3                   	ret
8010311e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80103120:	0f bf 56 52          	movswl 0x52(%esi),%edx
80103124:	66 83 fa 09          	cmp    $0x9,%dx
80103128:	77 17                	ja     80103141 <readi+0xf1>
8010312a:	8b 14 d5 a0 2b 11 80 	mov    -0x7feed460(,%edx,8),%edx
80103131:	85 d2                	test   %edx,%edx
80103133:	74 0c                	je     80103141 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80103135:	89 45 10             	mov    %eax,0x10(%ebp)
}
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313b:	5b                   	pop    %ebx
8010313c:	5e                   	pop    %esi
8010313d:	5f                   	pop    %edi
8010313e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010313f:	ff e2                	jmp    *%edx
      return -1;
80103141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103146:	eb ce                	jmp    80103116 <readi+0xc6>
80103148:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010314f:	00 

80103150 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	57                   	push   %edi
80103154:	56                   	push   %esi
80103155:	53                   	push   %ebx
80103156:	83 ec 1c             	sub    $0x1c,%esp
80103159:	8b 45 08             	mov    0x8(%ebp),%eax
8010315c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010315f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80103162:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80103167:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010316a:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010316d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80103170:	0f 84 ba 00 00 00    	je     80103230 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80103176:	39 78 58             	cmp    %edi,0x58(%eax)
80103179:	0f 82 ea 00 00 00    	jb     80103269 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
8010317f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80103182:	89 f2                	mov    %esi,%edx
80103184:	01 fa                	add    %edi,%edx
80103186:	0f 82 dd 00 00 00    	jb     80103269 <writei+0x119>
8010318c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80103192:	0f 87 d1 00 00 00    	ja     80103269 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103198:	85 f6                	test   %esi,%esi
8010319a:	0f 84 85 00 00 00    	je     80103225 <writei+0xd5>
801031a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801031a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801031aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801031b0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801031b3:	89 fa                	mov    %edi,%edx
801031b5:	c1 ea 09             	shr    $0x9,%edx
801031b8:	89 f0                	mov    %esi,%eax
801031ba:	e8 51 f8 ff ff       	call   80102a10 <bmap>
801031bf:	83 ec 08             	sub    $0x8,%esp
801031c2:	50                   	push   %eax
801031c3:	ff 36                	push   (%esi)
801031c5:	e8 06 cf ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801031ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031cd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801031d0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801031d5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801031d7:	89 f8                	mov    %edi,%eax
801031d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801031de:	29 d3                	sub    %edx,%ebx
801031e0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801031e2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801031e6:	39 d9                	cmp    %ebx,%ecx
801031e8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801031eb:	83 c4 0c             	add    $0xc,%esp
801031ee:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801031ef:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
801031f1:	ff 75 dc             	push   -0x24(%ebp)
801031f4:	50                   	push   %eax
801031f5:	e8 a6 32 00 00       	call   801064a0 <memmove>
    log_write(bp);
801031fa:	89 34 24             	mov    %esi,(%esp)
801031fd:	e8 be 12 00 00       	call   801044c0 <log_write>
    brelse(bp);
80103202:	89 34 24             	mov    %esi,(%esp)
80103205:	e8 e6 cf ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010320a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010320d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103216:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103219:	39 d8                	cmp    %ebx,%eax
8010321b:	72 93                	jb     801031b0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
8010321d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103220:	39 78 58             	cmp    %edi,0x58(%eax)
80103223:	72 33                	jb     80103258 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103225:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	5b                   	pop    %ebx
8010322c:	5e                   	pop    %esi
8010322d:	5f                   	pop    %edi
8010322e:	5d                   	pop    %ebp
8010322f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103230:	0f bf 40 52          	movswl 0x52(%eax),%eax
80103234:	66 83 f8 09          	cmp    $0x9,%ax
80103238:	77 2f                	ja     80103269 <writei+0x119>
8010323a:	8b 04 c5 a4 2b 11 80 	mov    -0x7feed45c(,%eax,8),%eax
80103241:	85 c0                	test   %eax,%eax
80103243:	74 24                	je     80103269 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80103245:	89 75 10             	mov    %esi,0x10(%ebp)
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	5b                   	pop    %ebx
8010324c:	5e                   	pop    %esi
8010324d:	5f                   	pop    %edi
8010324e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010324f:	ff e0                	jmp    *%eax
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80103258:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010325b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010325e:	50                   	push   %eax
8010325f:	e8 2c fa ff ff       	call   80102c90 <iupdate>
80103264:	83 c4 10             	add    $0x10,%esp
80103267:	eb bc                	jmp    80103225 <writei+0xd5>
      return -1;
80103269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010326e:	eb b8                	jmp    80103228 <writei+0xd8>

80103270 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80103276:	6a 0e                	push   $0xe
80103278:	ff 75 0c             	push   0xc(%ebp)
8010327b:	ff 75 08             	push   0x8(%ebp)
8010327e:	e8 8d 32 00 00       	call   80106510 <strncmp>
}
80103283:	c9                   	leave
80103284:	c3                   	ret
80103285:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010328c:	00 
8010328d:	8d 76 00             	lea    0x0(%esi),%esi

80103290 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	57                   	push   %edi
80103294:	56                   	push   %esi
80103295:	53                   	push   %ebx
80103296:	83 ec 1c             	sub    $0x1c,%esp
80103299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010329c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801032a1:	0f 85 85 00 00 00    	jne    8010332c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801032a7:	8b 53 58             	mov    0x58(%ebx),%edx
801032aa:	31 ff                	xor    %edi,%edi
801032ac:	8d 75 d8             	lea    -0x28(%ebp),%esi
801032af:	85 d2                	test   %edx,%edx
801032b1:	74 3e                	je     801032f1 <dirlookup+0x61>
801032b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801032b8:	6a 10                	push   $0x10
801032ba:	57                   	push   %edi
801032bb:	56                   	push   %esi
801032bc:	53                   	push   %ebx
801032bd:	e8 8e fd ff ff       	call   80103050 <readi>
801032c2:	83 c4 10             	add    $0x10,%esp
801032c5:	83 f8 10             	cmp    $0x10,%eax
801032c8:	75 55                	jne    8010331f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801032ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801032cf:	74 18                	je     801032e9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801032d1:	83 ec 04             	sub    $0x4,%esp
801032d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801032d7:	6a 0e                	push   $0xe
801032d9:	50                   	push   %eax
801032da:	ff 75 0c             	push   0xc(%ebp)
801032dd:	e8 2e 32 00 00       	call   80106510 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801032e2:	83 c4 10             	add    $0x10,%esp
801032e5:	85 c0                	test   %eax,%eax
801032e7:	74 17                	je     80103300 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801032e9:	83 c7 10             	add    $0x10,%edi
801032ec:	3b 7b 58             	cmp    0x58(%ebx),%edi
801032ef:	72 c7                	jb     801032b8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801032f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032f4:	31 c0                	xor    %eax,%eax
}
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5f                   	pop    %edi
801032f9:	5d                   	pop    %ebp
801032fa:	c3                   	ret
801032fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80103300:	8b 45 10             	mov    0x10(%ebp),%eax
80103303:	85 c0                	test   %eax,%eax
80103305:	74 05                	je     8010330c <dirlookup+0x7c>
        *poff = off;
80103307:	8b 45 10             	mov    0x10(%ebp),%eax
8010330a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010330c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103310:	8b 03                	mov    (%ebx),%eax
80103312:	e8 79 f5 ff ff       	call   80102890 <iget>
}
80103317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010331a:	5b                   	pop    %ebx
8010331b:	5e                   	pop    %esi
8010331c:	5f                   	pop    %edi
8010331d:	5d                   	pop    %ebp
8010331e:	c3                   	ret
      panic("dirlookup read");
8010331f:	83 ec 0c             	sub    $0xc,%esp
80103322:	68 48 97 10 80       	push   $0x80109748
80103327:	e8 24 d2 ff ff       	call   80100550 <panic>
    panic("dirlookup not DIR");
8010332c:	83 ec 0c             	sub    $0xc,%esp
8010332f:	68 36 97 10 80       	push   $0x80109736
80103334:	e8 17 d2 ff ff       	call   80100550 <panic>
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103340 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	89 c3                	mov    %eax,%ebx
80103348:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010334b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010334e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103351:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103354:	0f 84 9e 01 00 00    	je     801034f8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010335a:	e8 d1 1c 00 00       	call   80105030 <myproc>
  acquire(&icache.lock);
8010335f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103362:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103365:	68 00 2c 11 80       	push   $0x80112c00
8010336a:	e8 a1 2f 00 00       	call   80106310 <acquire>
  ip->ref++;
8010336f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80103373:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
8010337a:	e8 31 2f 00 00       	call   801062b0 <release>
8010337f:	83 c4 10             	add    $0x10,%esp
80103382:	eb 07                	jmp    8010338b <namex+0x4b>
80103384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103388:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010338b:	0f b6 03             	movzbl (%ebx),%eax
8010338e:	3c 2f                	cmp    $0x2f,%al
80103390:	74 f6                	je     80103388 <namex+0x48>
  if(*path == 0)
80103392:	84 c0                	test   %al,%al
80103394:	0f 84 06 01 00 00    	je     801034a0 <namex+0x160>
  while(*path != '/' && *path != 0)
8010339a:	0f b6 03             	movzbl (%ebx),%eax
8010339d:	84 c0                	test   %al,%al
8010339f:	0f 84 10 01 00 00    	je     801034b5 <namex+0x175>
801033a5:	89 df                	mov    %ebx,%edi
801033a7:	3c 2f                	cmp    $0x2f,%al
801033a9:	0f 84 06 01 00 00    	je     801034b5 <namex+0x175>
801033af:	90                   	nop
801033b0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801033b4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801033b7:	3c 2f                	cmp    $0x2f,%al
801033b9:	74 04                	je     801033bf <namex+0x7f>
801033bb:	84 c0                	test   %al,%al
801033bd:	75 f1                	jne    801033b0 <namex+0x70>
  len = path - s;
801033bf:	89 f8                	mov    %edi,%eax
801033c1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801033c3:	83 f8 0d             	cmp    $0xd,%eax
801033c6:	0f 8e ac 00 00 00    	jle    80103478 <namex+0x138>
    memmove(name, s, DIRSIZ);
801033cc:	83 ec 04             	sub    $0x4,%esp
801033cf:	6a 0e                	push   $0xe
801033d1:	53                   	push   %ebx
801033d2:	89 fb                	mov    %edi,%ebx
801033d4:	ff 75 e4             	push   -0x1c(%ebp)
801033d7:	e8 c4 30 00 00       	call   801064a0 <memmove>
801033dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801033df:	80 3f 2f             	cmpb   $0x2f,(%edi)
801033e2:	75 0c                	jne    801033f0 <namex+0xb0>
801033e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801033e8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801033eb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801033ee:	74 f8                	je     801033e8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	56                   	push   %esi
801033f4:	e8 47 f9 ff ff       	call   80102d40 <ilock>
    if(ip->type != T_DIR){
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80103401:	0f 85 b7 00 00 00    	jne    801034be <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103407:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	74 09                	je     80103417 <namex+0xd7>
8010340e:	80 3b 00             	cmpb   $0x0,(%ebx)
80103411:	0f 84 f7 00 00 00    	je     8010350e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103417:	83 ec 04             	sub    $0x4,%esp
8010341a:	6a 00                	push   $0x0
8010341c:	ff 75 e4             	push   -0x1c(%ebp)
8010341f:	56                   	push   %esi
80103420:	e8 6b fe ff ff       	call   80103290 <dirlookup>
80103425:	83 c4 10             	add    $0x10,%esp
80103428:	89 c7                	mov    %eax,%edi
8010342a:	85 c0                	test   %eax,%eax
8010342c:	0f 84 8c 00 00 00    	je     801034be <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103432:	83 ec 0c             	sub    $0xc,%esp
80103435:	8d 4e 0c             	lea    0xc(%esi),%ecx
80103438:	51                   	push   %ecx
80103439:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010343c:	e8 8f 2c 00 00       	call   801060d0 <holdingsleep>
80103441:	83 c4 10             	add    $0x10,%esp
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 02 01 00 00    	je     8010354e <namex+0x20e>
8010344c:	8b 56 08             	mov    0x8(%esi),%edx
8010344f:	85 d2                	test   %edx,%edx
80103451:	0f 8e f7 00 00 00    	jle    8010354e <namex+0x20e>
  releasesleep(&ip->lock);
80103457:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010345a:	83 ec 0c             	sub    $0xc,%esp
8010345d:	51                   	push   %ecx
8010345e:	e8 2d 2c 00 00       	call   80106090 <releasesleep>
  iput(ip);
80103463:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103466:	89 fe                	mov    %edi,%esi
  iput(ip);
80103468:	e8 03 fa ff ff       	call   80102e70 <iput>
8010346d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103470:	e9 16 ff ff ff       	jmp    8010338b <namex+0x4b>
80103475:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80103478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010347b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
8010347e:	83 ec 04             	sub    $0x4,%esp
80103481:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103484:	50                   	push   %eax
80103485:	53                   	push   %ebx
    name[len] = 0;
80103486:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103488:	ff 75 e4             	push   -0x1c(%ebp)
8010348b:	e8 10 30 00 00       	call   801064a0 <memmove>
    name[len] = 0;
80103490:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103493:	83 c4 10             	add    $0x10,%esp
80103496:	c6 01 00             	movb   $0x0,(%ecx)
80103499:	e9 41 ff ff ff       	jmp    801033df <namex+0x9f>
8010349e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
801034a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801034a3:	85 c0                	test   %eax,%eax
801034a5:	0f 85 93 00 00 00    	jne    8010353e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
801034ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ae:	89 f0                	mov    %esi,%eax
801034b0:	5b                   	pop    %ebx
801034b1:	5e                   	pop    %esi
801034b2:	5f                   	pop    %edi
801034b3:	5d                   	pop    %ebp
801034b4:	c3                   	ret
  while(*path != '/' && *path != 0)
801034b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034b8:	89 df                	mov    %ebx,%edi
801034ba:	31 c0                	xor    %eax,%eax
801034bc:	eb c0                	jmp    8010347e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	8d 5e 0c             	lea    0xc(%esi),%ebx
801034c4:	53                   	push   %ebx
801034c5:	e8 06 2c 00 00       	call   801060d0 <holdingsleep>
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	85 c0                	test   %eax,%eax
801034cf:	74 7d                	je     8010354e <namex+0x20e>
801034d1:	8b 4e 08             	mov    0x8(%esi),%ecx
801034d4:	85 c9                	test   %ecx,%ecx
801034d6:	7e 76                	jle    8010354e <namex+0x20e>
  releasesleep(&ip->lock);
801034d8:	83 ec 0c             	sub    $0xc,%esp
801034db:	53                   	push   %ebx
801034dc:	e8 af 2b 00 00       	call   80106090 <releasesleep>
  iput(ip);
801034e1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801034e4:	31 f6                	xor    %esi,%esi
  iput(ip);
801034e6:	e8 85 f9 ff ff       	call   80102e70 <iput>
      return 0;
801034eb:	83 c4 10             	add    $0x10,%esp
}
801034ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f1:	89 f0                	mov    %esi,%eax
801034f3:	5b                   	pop    %ebx
801034f4:	5e                   	pop    %esi
801034f5:	5f                   	pop    %edi
801034f6:	5d                   	pop    %ebp
801034f7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
801034f8:	ba 01 00 00 00       	mov    $0x1,%edx
801034fd:	b8 01 00 00 00       	mov    $0x1,%eax
80103502:	e8 89 f3 ff ff       	call   80102890 <iget>
80103507:	89 c6                	mov    %eax,%esi
80103509:	e9 7d fe ff ff       	jmp    8010338b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103514:	53                   	push   %ebx
80103515:	e8 b6 2b 00 00       	call   801060d0 <holdingsleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	85 c0                	test   %eax,%eax
8010351f:	74 2d                	je     8010354e <namex+0x20e>
80103521:	8b 7e 08             	mov    0x8(%esi),%edi
80103524:	85 ff                	test   %edi,%edi
80103526:	7e 26                	jle    8010354e <namex+0x20e>
  releasesleep(&ip->lock);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	53                   	push   %ebx
8010352c:	e8 5f 2b 00 00       	call   80106090 <releasesleep>
}
80103531:	83 c4 10             	add    $0x10,%esp
}
80103534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103537:	89 f0                	mov    %esi,%eax
80103539:	5b                   	pop    %ebx
8010353a:	5e                   	pop    %esi
8010353b:	5f                   	pop    %edi
8010353c:	5d                   	pop    %ebp
8010353d:	c3                   	ret
    iput(ip);
8010353e:	83 ec 0c             	sub    $0xc,%esp
80103541:	56                   	push   %esi
      return 0;
80103542:	31 f6                	xor    %esi,%esi
    iput(ip);
80103544:	e8 27 f9 ff ff       	call   80102e70 <iput>
    return 0;
80103549:	83 c4 10             	add    $0x10,%esp
8010354c:	eb a0                	jmp    801034ee <namex+0x1ae>
    panic("iunlock");
8010354e:	83 ec 0c             	sub    $0xc,%esp
80103551:	68 2e 97 10 80       	push   $0x8010972e
80103556:	e8 f5 cf ff ff       	call   80100550 <panic>
8010355b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103560 <dirlink>:
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 20             	sub    $0x20,%esp
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010356c:	6a 00                	push   $0x0
8010356e:	ff 75 0c             	push   0xc(%ebp)
80103571:	53                   	push   %ebx
80103572:	e8 19 fd ff ff       	call   80103290 <dirlookup>
80103577:	83 c4 10             	add    $0x10,%esp
8010357a:	85 c0                	test   %eax,%eax
8010357c:	75 67                	jne    801035e5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010357e:	8b 7b 58             	mov    0x58(%ebx),%edi
80103581:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103584:	85 ff                	test   %edi,%edi
80103586:	74 29                	je     801035b1 <dirlink+0x51>
80103588:	31 ff                	xor    %edi,%edi
8010358a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010358d:	eb 09                	jmp    80103598 <dirlink+0x38>
8010358f:	90                   	nop
80103590:	83 c7 10             	add    $0x10,%edi
80103593:	3b 7b 58             	cmp    0x58(%ebx),%edi
80103596:	73 19                	jae    801035b1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103598:	6a 10                	push   $0x10
8010359a:	57                   	push   %edi
8010359b:	56                   	push   %esi
8010359c:	53                   	push   %ebx
8010359d:	e8 ae fa ff ff       	call   80103050 <readi>
801035a2:	83 c4 10             	add    $0x10,%esp
801035a5:	83 f8 10             	cmp    $0x10,%eax
801035a8:	75 4e                	jne    801035f8 <dirlink+0x98>
    if(de.inum == 0)
801035aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801035af:	75 df                	jne    80103590 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801035b1:	83 ec 04             	sub    $0x4,%esp
801035b4:	8d 45 da             	lea    -0x26(%ebp),%eax
801035b7:	6a 0e                	push   $0xe
801035b9:	ff 75 0c             	push   0xc(%ebp)
801035bc:	50                   	push   %eax
801035bd:	e8 9e 2f 00 00       	call   80106560 <strncpy>
  de.inum = inum;
801035c2:	8b 45 10             	mov    0x10(%ebp),%eax
801035c5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801035c9:	6a 10                	push   $0x10
801035cb:	57                   	push   %edi
801035cc:	56                   	push   %esi
801035cd:	53                   	push   %ebx
801035ce:	e8 7d fb ff ff       	call   80103150 <writei>
801035d3:	83 c4 20             	add    $0x20,%esp
801035d6:	83 f8 10             	cmp    $0x10,%eax
801035d9:	75 2a                	jne    80103605 <dirlink+0xa5>
  return 0;
801035db:	31 c0                	xor    %eax,%eax
}
801035dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e0:	5b                   	pop    %ebx
801035e1:	5e                   	pop    %esi
801035e2:	5f                   	pop    %edi
801035e3:	5d                   	pop    %ebp
801035e4:	c3                   	ret
    iput(ip);
801035e5:	83 ec 0c             	sub    $0xc,%esp
801035e8:	50                   	push   %eax
801035e9:	e8 82 f8 ff ff       	call   80102e70 <iput>
    return -1;
801035ee:	83 c4 10             	add    $0x10,%esp
801035f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f6:	eb e5                	jmp    801035dd <dirlink+0x7d>
      panic("dirlink read");
801035f8:	83 ec 0c             	sub    $0xc,%esp
801035fb:	68 57 97 10 80       	push   $0x80109757
80103600:	e8 4b cf ff ff       	call   80100550 <panic>
    panic("dirlink");
80103605:	83 ec 0c             	sub    $0xc,%esp
80103608:	68 c0 9a 10 80       	push   $0x80109ac0
8010360d:	e8 3e cf ff ff       	call   80100550 <panic>
80103612:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103619:	00 
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103620 <namei>:

struct inode*
namei(char *path)
{
80103620:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103621:	31 d2                	xor    %edx,%edx
{
80103623:	89 e5                	mov    %esp,%ebp
80103625:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103628:	8b 45 08             	mov    0x8(%ebp),%eax
8010362b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010362e:	e8 0d fd ff ff       	call   80103340 <namex>
}
80103633:	c9                   	leave
80103634:	c3                   	ret
80103635:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010363c:	00 
8010363d:	8d 76 00             	lea    0x0(%esi),%esi

80103640 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103640:	55                   	push   %ebp
  return namex(path, 1, name);
80103641:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103646:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103648:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010364b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010364e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010364f:	e9 ec fc ff ff       	jmp    80103340 <namex>
80103654:	66 90                	xchg   %ax,%ax
80103656:	66 90                	xchg   %ax,%ax
80103658:	66 90                	xchg   %ax,%ax
8010365a:	66 90                	xchg   %ax,%ax
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103669:	85 c0                	test   %eax,%eax
8010366b:	0f 84 b4 00 00 00    	je     80103725 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103671:	8b 70 08             	mov    0x8(%eax),%esi
80103674:	89 c3                	mov    %eax,%ebx
80103676:	81 fe 87 13 00 00    	cmp    $0x1387,%esi
8010367c:	0f 87 96 00 00 00    	ja     80103718 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103682:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103687:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010368e:	00 
8010368f:	90                   	nop
80103690:	89 ca                	mov    %ecx,%edx
80103692:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103693:	83 e0 c0             	and    $0xffffffc0,%eax
80103696:	3c 40                	cmp    $0x40,%al
80103698:	75 f6                	jne    80103690 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010369a:	31 ff                	xor    %edi,%edi
8010369c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801036a1:	89 f8                	mov    %edi,%eax
801036a3:	ee                   	out    %al,(%dx)
801036a4:	b8 01 00 00 00       	mov    $0x1,%eax
801036a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801036ae:	ee                   	out    %al,(%dx)
801036af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801036b4:	89 f0                	mov    %esi,%eax
801036b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801036b7:	89 f0                	mov    %esi,%eax
801036b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801036be:	c1 f8 08             	sar    $0x8,%eax
801036c1:	ee                   	out    %al,(%dx)
801036c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801036c7:	89 f8                	mov    %edi,%eax
801036c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801036ca:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801036ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801036d3:	c1 e0 04             	shl    $0x4,%eax
801036d6:	83 e0 10             	and    $0x10,%eax
801036d9:	83 c8 e0             	or     $0xffffffe0,%eax
801036dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801036dd:	f6 03 04             	testb  $0x4,(%ebx)
801036e0:	75 16                	jne    801036f8 <idestart+0x98>
801036e2:	b8 20 00 00 00       	mov    $0x20,%eax
801036e7:	89 ca                	mov    %ecx,%edx
801036e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801036ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ed:	5b                   	pop    %ebx
801036ee:	5e                   	pop    %esi
801036ef:	5f                   	pop    %edi
801036f0:	5d                   	pop    %ebp
801036f1:	c3                   	ret
801036f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036f8:	b8 30 00 00 00       	mov    $0x30,%eax
801036fd:	89 ca                	mov    %ecx,%edx
801036ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80103700:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80103705:	8d 73 5c             	lea    0x5c(%ebx),%esi
80103708:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010370d:	fc                   	cld
8010370e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80103710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103713:	5b                   	pop    %ebx
80103714:	5e                   	pop    %esi
80103715:	5f                   	pop    %edi
80103716:	5d                   	pop    %ebp
80103717:	c3                   	ret
    panic("incorrect blockno");
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	68 6d 97 10 80       	push   $0x8010976d
80103720:	e8 2b ce ff ff       	call   80100550 <panic>
    panic("idestart");
80103725:	83 ec 0c             	sub    $0xc,%esp
80103728:	68 64 97 10 80       	push   $0x80109764
8010372d:	e8 1e ce ff ff       	call   80100550 <panic>
80103732:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103739:	00 
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103740 <ideinit>:
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80103746:	68 7f 97 10 80       	push   $0x8010977f
8010374b:	68 a0 48 11 80       	push   $0x801148a0
80103750:	e8 cb 29 00 00       	call   80106120 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80103755:	58                   	pop    %eax
80103756:	a1 24 4a 11 80       	mov    0x80114a24,%eax
8010375b:	5a                   	pop    %edx
8010375c:	83 e8 01             	sub    $0x1,%eax
8010375f:	50                   	push   %eax
80103760:	6a 0e                	push   $0xe
80103762:	e8 99 02 00 00       	call   80103a00 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103767:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010376a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010376f:	90                   	nop
80103770:	89 ca                	mov    %ecx,%edx
80103772:	ec                   	in     (%dx),%al
80103773:	83 e0 c0             	and    $0xffffffc0,%eax
80103776:	3c 40                	cmp    $0x40,%al
80103778:	75 f6                	jne    80103770 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010377a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010377f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80103784:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103785:	89 ca                	mov    %ecx,%edx
80103787:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80103788:	84 c0                	test   %al,%al
8010378a:	75 1e                	jne    801037aa <ideinit+0x6a>
8010378c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80103791:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103796:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010379d:	00 
8010379e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801037a0:	83 e9 01             	sub    $0x1,%ecx
801037a3:	74 0f                	je     801037b4 <ideinit+0x74>
801037a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801037a6:	84 c0                	test   %al,%al
801037a8:	74 f6                	je     801037a0 <ideinit+0x60>
      havedisk1 = 1;
801037aa:	c7 05 80 48 11 80 01 	movl   $0x1,0x80114880
801037b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801037b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801037be:	ee                   	out    %al,(%dx)
}
801037bf:	c9                   	leave
801037c0:	c3                   	ret
801037c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037c8:	00 
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801037d9:	68 a0 48 11 80       	push   $0x801148a0
801037de:	e8 2d 2b 00 00       	call   80106310 <acquire>

  if((b = idequeue) == 0){
801037e3:	8b 1d 84 48 11 80    	mov    0x80114884,%ebx
801037e9:	83 c4 10             	add    $0x10,%esp
801037ec:	85 db                	test   %ebx,%ebx
801037ee:	74 63                	je     80103853 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801037f0:	8b 43 58             	mov    0x58(%ebx),%eax
801037f3:	a3 84 48 11 80       	mov    %eax,0x80114884

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801037f8:	8b 33                	mov    (%ebx),%esi
801037fa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80103800:	75 2f                	jne    80103831 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103802:	ba f7 01 00 00       	mov    $0x1f7,%edx
80103807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010380e:	00 
8010380f:	90                   	nop
80103810:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103811:	89 c1                	mov    %eax,%ecx
80103813:	83 e1 c0             	and    $0xffffffc0,%ecx
80103816:	80 f9 40             	cmp    $0x40,%cl
80103819:	75 f5                	jne    80103810 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010381b:	a8 21                	test   $0x21,%al
8010381d:	75 12                	jne    80103831 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010381f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80103822:	b9 80 00 00 00       	mov    $0x80,%ecx
80103827:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010382c:	fc                   	cld
8010382d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010382f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80103831:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80103834:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80103837:	83 ce 02             	or     $0x2,%esi
8010383a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010383c:	53                   	push   %ebx
8010383d:	e8 be 22 00 00       	call   80105b00 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80103842:	a1 84 48 11 80       	mov    0x80114884,%eax
80103847:	83 c4 10             	add    $0x10,%esp
8010384a:	85 c0                	test   %eax,%eax
8010384c:	74 05                	je     80103853 <ideintr+0x83>
    idestart(idequeue);
8010384e:	e8 0d fe ff ff       	call   80103660 <idestart>
    release(&idelock);
80103853:	83 ec 0c             	sub    $0xc,%esp
80103856:	68 a0 48 11 80       	push   $0x801148a0
8010385b:	e8 50 2a 00 00       	call   801062b0 <release>

  release(&idelock);
}
80103860:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103863:	5b                   	pop    %ebx
80103864:	5e                   	pop    %esi
80103865:	5f                   	pop    %edi
80103866:	5d                   	pop    %ebp
80103867:	c3                   	ret
80103868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010386f:	00 

80103870 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	53                   	push   %ebx
80103874:	83 ec 10             	sub    $0x10,%esp
80103877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010387a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010387d:	50                   	push   %eax
8010387e:	e8 4d 28 00 00       	call   801060d0 <holdingsleep>
80103883:	83 c4 10             	add    $0x10,%esp
80103886:	85 c0                	test   %eax,%eax
80103888:	0f 84 c3 00 00 00    	je     80103951 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010388e:	8b 03                	mov    (%ebx),%eax
80103890:	83 e0 06             	and    $0x6,%eax
80103893:	83 f8 02             	cmp    $0x2,%eax
80103896:	0f 84 a8 00 00 00    	je     80103944 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010389c:	8b 53 04             	mov    0x4(%ebx),%edx
8010389f:	85 d2                	test   %edx,%edx
801038a1:	74 0d                	je     801038b0 <iderw+0x40>
801038a3:	a1 80 48 11 80       	mov    0x80114880,%eax
801038a8:	85 c0                	test   %eax,%eax
801038aa:	0f 84 87 00 00 00    	je     80103937 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 a0 48 11 80       	push   $0x801148a0
801038b8:	e8 53 2a 00 00       	call   80106310 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801038bd:	a1 84 48 11 80       	mov    0x80114884,%eax
  b->qnext = 0;
801038c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 60                	je     80103930 <iderw+0xc0>
801038d0:	89 c2                	mov    %eax,%edx
801038d2:	8b 40 58             	mov    0x58(%eax),%eax
801038d5:	85 c0                	test   %eax,%eax
801038d7:	75 f7                	jne    801038d0 <iderw+0x60>
801038d9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801038dc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801038de:	39 1d 84 48 11 80    	cmp    %ebx,0x80114884
801038e4:	74 3a                	je     80103920 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801038e6:	8b 03                	mov    (%ebx),%eax
801038e8:	83 e0 06             	and    $0x6,%eax
801038eb:	83 f8 02             	cmp    $0x2,%eax
801038ee:	74 1b                	je     8010390b <iderw+0x9b>
    sleep(b, &idelock);
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	68 a0 48 11 80       	push   $0x801148a0
801038f8:	53                   	push   %ebx
801038f9:	e8 42 21 00 00       	call   80105a40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801038fe:	8b 03                	mov    (%ebx),%eax
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	83 e0 06             	and    $0x6,%eax
80103906:	83 f8 02             	cmp    $0x2,%eax
80103909:	75 e5                	jne    801038f0 <iderw+0x80>
  }


  release(&idelock);
8010390b:	c7 45 08 a0 48 11 80 	movl   $0x801148a0,0x8(%ebp)
}
80103912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103915:	c9                   	leave
  release(&idelock);
80103916:	e9 95 29 00 00       	jmp    801062b0 <release>
8010391b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80103920:	89 d8                	mov    %ebx,%eax
80103922:	e8 39 fd ff ff       	call   80103660 <idestart>
80103927:	eb bd                	jmp    801038e6 <iderw+0x76>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80103930:	ba 84 48 11 80       	mov    $0x80114884,%edx
80103935:	eb a5                	jmp    801038dc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80103937:	83 ec 0c             	sub    $0xc,%esp
8010393a:	68 ae 97 10 80       	push   $0x801097ae
8010393f:	e8 0c cc ff ff       	call   80100550 <panic>
    panic("iderw: nothing to do");
80103944:	83 ec 0c             	sub    $0xc,%esp
80103947:	68 99 97 10 80       	push   $0x80109799
8010394c:	e8 ff cb ff ff       	call   80100550 <panic>
    panic("iderw: buf not locked");
80103951:	83 ec 0c             	sub    $0xc,%esp
80103954:	68 83 97 10 80       	push   $0x80109783
80103959:	e8 f2 cb ff ff       	call   80100550 <panic>
8010395e:	66 90                	xchg   %ax,%ax

80103960 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	56                   	push   %esi
80103964:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80103965:	c7 05 d4 48 11 80 00 	movl   $0xfec00000,0x801148d4
8010396c:	00 c0 fe 
  ioapic->reg = reg;
8010396f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80103976:	00 00 00 
  return ioapic->data;
80103979:	8b 15 d4 48 11 80    	mov    0x801148d4,%edx
8010397f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80103982:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80103988:	8b 1d d4 48 11 80    	mov    0x801148d4,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010398e:	0f b6 15 20 4a 11 80 	movzbl 0x80114a20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80103995:	c1 ee 10             	shr    $0x10,%esi
80103998:	89 f0                	mov    %esi,%eax
8010399a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010399d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
801039a0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801039a3:	39 c2                	cmp    %eax,%edx
801039a5:	74 16                	je     801039bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801039a7:	83 ec 0c             	sub    $0xc,%esp
801039aa:	68 e8 9c 10 80       	push   $0x80109ce8
801039af:	e8 ac d3 ff ff       	call   80100d60 <cprintf>
  ioapic->reg = reg;
801039b4:	8b 1d d4 48 11 80    	mov    0x801148d4,%ebx
801039ba:	83 c4 10             	add    $0x10,%esp
{
801039bd:	ba 10 00 00 00       	mov    $0x10,%edx
801039c2:	31 c0                	xor    %eax,%eax
801039c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801039c8:	89 13                	mov    %edx,(%ebx)
801039ca:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801039cd:	8b 1d d4 48 11 80    	mov    0x801148d4,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801039d3:	83 c0 01             	add    $0x1,%eax
801039d6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801039dc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801039df:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801039e2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801039e5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801039e7:	8b 1d d4 48 11 80    	mov    0x801148d4,%ebx
801039ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801039f4:	39 c6                	cmp    %eax,%esi
801039f6:	7d d0                	jge    801039c8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801039f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039fb:	5b                   	pop    %ebx
801039fc:	5e                   	pop    %esi
801039fd:	5d                   	pop    %ebp
801039fe:	c3                   	ret
801039ff:	90                   	nop

80103a00 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80103a00:	55                   	push   %ebp
  ioapic->reg = reg;
80103a01:	8b 0d d4 48 11 80    	mov    0x801148d4,%ecx
{
80103a07:	89 e5                	mov    %esp,%ebp
80103a09:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80103a0c:	8d 50 20             	lea    0x20(%eax),%edx
80103a0f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80103a13:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103a15:	8b 0d d4 48 11 80    	mov    0x801148d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103a1b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80103a1e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80103a24:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80103a26:	a1 d4 48 11 80       	mov    0x801148d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103a2b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80103a2e:	89 50 10             	mov    %edx,0x10(%eax)
}
80103a31:	5d                   	pop    %ebp
80103a32:	c3                   	ret
80103a33:	66 90                	xchg   %ax,%ax
80103a35:	66 90                	xchg   %ax,%ax
80103a37:	66 90                	xchg   %ax,%ax
80103a39:	66 90                	xchg   %ax,%ax
80103a3b:	66 90                	xchg   %ax,%ax
80103a3d:	66 90                	xchg   %ax,%ax
80103a3f:	90                   	nop

80103a40 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
80103a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80103a4a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80103a50:	75 76                	jne    80103ac8 <kfree+0x88>
80103a52:	81 fb 30 8e 11 80    	cmp    $0x80118e30,%ebx
80103a58:	72 6e                	jb     80103ac8 <kfree+0x88>
80103a5a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80103a60:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103a65:	77 61                	ja     80103ac8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80103a67:	83 ec 04             	sub    $0x4,%esp
80103a6a:	68 00 10 00 00       	push   $0x1000
80103a6f:	6a 01                	push   $0x1
80103a71:	53                   	push   %ebx
80103a72:	e8 99 29 00 00       	call   80106410 <memset>

  if(kmem.use_lock)
80103a77:	8b 15 14 49 11 80    	mov    0x80114914,%edx
80103a7d:	83 c4 10             	add    $0x10,%esp
80103a80:	85 d2                	test   %edx,%edx
80103a82:	75 1c                	jne    80103aa0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80103a84:	a1 18 49 11 80       	mov    0x80114918,%eax
80103a89:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80103a8b:	a1 14 49 11 80       	mov    0x80114914,%eax
  kmem.freelist = r;
80103a90:	89 1d 18 49 11 80    	mov    %ebx,0x80114918
  if(kmem.use_lock)
80103a96:	85 c0                	test   %eax,%eax
80103a98:	75 1e                	jne    80103ab8 <kfree+0x78>
    release(&kmem.lock);
}
80103a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9d:	c9                   	leave
80103a9e:	c3                   	ret
80103a9f:	90                   	nop
    acquire(&kmem.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 e0 48 11 80       	push   $0x801148e0
80103aa8:	e8 63 28 00 00       	call   80106310 <acquire>
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	eb d2                	jmp    80103a84 <kfree+0x44>
80103ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103ab8:	c7 45 08 e0 48 11 80 	movl   $0x801148e0,0x8(%ebp)
}
80103abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac2:	c9                   	leave
    release(&kmem.lock);
80103ac3:	e9 e8 27 00 00       	jmp    801062b0 <release>
    panic("kfree");
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 cc 97 10 80       	push   $0x801097cc
80103ad0:	e8 7b ca ff ff       	call   80100550 <panic>
80103ad5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103adc:	00 
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <freerange>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103ae8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80103aeb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103af1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103af7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103afd:	39 de                	cmp    %ebx,%esi
80103aff:	72 23                	jb     80103b24 <freerange+0x44>
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103b11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103b17:	50                   	push   %eax
80103b18:	e8 23 ff ff ff       	call   80103a40 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103b1d:	83 c4 10             	add    $0x10,%esp
80103b20:	39 de                	cmp    %ebx,%esi
80103b22:	73 e4                	jae    80103b08 <freerange+0x28>
}
80103b24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b27:	5b                   	pop    %ebx
80103b28:	5e                   	pop    %esi
80103b29:	5d                   	pop    %ebp
80103b2a:	c3                   	ret
80103b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103b30 <kinit2>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	56                   	push   %esi
80103b34:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80103b35:	8b 45 08             	mov    0x8(%ebp),%eax
{
80103b38:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80103b3b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103b41:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103b47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103b4d:	39 de                	cmp    %ebx,%esi
80103b4f:	72 23                	jb     80103b74 <kinit2+0x44>
80103b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103b58:	83 ec 0c             	sub    $0xc,%esp
80103b5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103b61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103b67:	50                   	push   %eax
80103b68:	e8 d3 fe ff ff       	call   80103a40 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	39 de                	cmp    %ebx,%esi
80103b72:	73 e4                	jae    80103b58 <kinit2+0x28>
  kmem.use_lock = 1;
80103b74:	c7 05 14 49 11 80 01 	movl   $0x1,0x80114914
80103b7b:	00 00 00 
}
80103b7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b81:	5b                   	pop    %ebx
80103b82:	5e                   	pop    %esi
80103b83:	5d                   	pop    %ebp
80103b84:	c3                   	ret
80103b85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b8c:	00 
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi

80103b90 <kinit1>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
80103b95:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80103b98:	83 ec 08             	sub    $0x8,%esp
80103b9b:	68 d2 97 10 80       	push   $0x801097d2
80103ba0:	68 e0 48 11 80       	push   $0x801148e0
80103ba5:	e8 76 25 00 00       	call   80106120 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80103baa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103bad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103bb0:	c7 05 14 49 11 80 00 	movl   $0x0,0x80114914
80103bb7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80103bba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103bc0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103bc6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103bcc:	39 de                	cmp    %ebx,%esi
80103bce:	72 1c                	jb     80103bec <kinit1+0x5c>
    kfree(p);
80103bd0:	83 ec 0c             	sub    $0xc,%esp
80103bd3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103bd9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103bdf:	50                   	push   %eax
80103be0:	e8 5b fe ff ff       	call   80103a40 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	39 de                	cmp    %ebx,%esi
80103bea:	73 e4                	jae    80103bd0 <kinit1+0x40>
}
80103bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bef:	5b                   	pop    %ebx
80103bf0:	5e                   	pop    %esi
80103bf1:	5d                   	pop    %ebp
80103bf2:	c3                   	ret
80103bf3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bfa:	00 
80103bfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c00 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80103c07:	a1 14 49 11 80       	mov    0x80114914,%eax
80103c0c:	85 c0                	test   %eax,%eax
80103c0e:	75 20                	jne    80103c30 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80103c10:	8b 1d 18 49 11 80    	mov    0x80114918,%ebx
  if(r)
80103c16:	85 db                	test   %ebx,%ebx
80103c18:	74 07                	je     80103c21 <kalloc+0x21>
    kmem.freelist = r->next;
80103c1a:	8b 03                	mov    (%ebx),%eax
80103c1c:	a3 18 49 11 80       	mov    %eax,0x80114918
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80103c21:	89 d8                	mov    %ebx,%eax
80103c23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c26:	c9                   	leave
80103c27:	c3                   	ret
80103c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c2f:	00 
    acquire(&kmem.lock);
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 e0 48 11 80       	push   $0x801148e0
80103c38:	e8 d3 26 00 00       	call   80106310 <acquire>
  r = kmem.freelist;
80103c3d:	8b 1d 18 49 11 80    	mov    0x80114918,%ebx
  if(kmem.use_lock)
80103c43:	a1 14 49 11 80       	mov    0x80114914,%eax
  if(r)
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	85 db                	test   %ebx,%ebx
80103c4d:	74 08                	je     80103c57 <kalloc+0x57>
    kmem.freelist = r->next;
80103c4f:	8b 13                	mov    (%ebx),%edx
80103c51:	89 15 18 49 11 80    	mov    %edx,0x80114918
  if(kmem.use_lock)
80103c57:	85 c0                	test   %eax,%eax
80103c59:	74 c6                	je     80103c21 <kalloc+0x21>
    release(&kmem.lock);
80103c5b:	83 ec 0c             	sub    $0xc,%esp
80103c5e:	68 e0 48 11 80       	push   $0x801148e0
80103c63:	e8 48 26 00 00       	call   801062b0 <release>
}
80103c68:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
80103c6a:	83 c4 10             	add    $0x10,%esp
}
80103c6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c70:	c9                   	leave
80103c71:	c3                   	ret
80103c72:	66 90                	xchg   %ax,%ax
80103c74:	66 90                	xchg   %ax,%ax
80103c76:	66 90                	xchg   %ax,%ax
80103c78:	66 90                	xchg   %ax,%ax
80103c7a:	66 90                	xchg   %ax,%ax
80103c7c:	66 90                	xchg   %ax,%ax
80103c7e:	66 90                	xchg   %ax,%ax

80103c80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103c80:	ba 64 00 00 00       	mov    $0x64,%edx
80103c85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80103c86:	a8 01                	test   $0x1,%al
80103c88:	0f 84 c2 00 00 00    	je     80103d50 <kbdgetc+0xd0>
{
80103c8e:	55                   	push   %ebp
80103c8f:	ba 60 00 00 00       	mov    $0x60,%edx
80103c94:	89 e5                	mov    %esp,%ebp
80103c96:	53                   	push   %ebx
80103c97:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80103c98:	8b 1d 1c 49 11 80    	mov    0x8011491c,%ebx
  data = inb(KBDATAP);
80103c9e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80103ca1:	3c e0                	cmp    $0xe0,%al
80103ca3:	74 5b                	je     80103d00 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103ca5:	89 da                	mov    %ebx,%edx
80103ca7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80103caa:	84 c0                	test   %al,%al
80103cac:	78 62                	js     80103d10 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103cae:	85 d2                	test   %edx,%edx
80103cb0:	74 09                	je     80103cbb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103cb2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103cb5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80103cb8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80103cbb:	0f b6 91 80 9f 10 80 	movzbl -0x7fef6080(%ecx),%edx
  shift ^= togglecode[data];
80103cc2:	0f b6 81 80 9e 10 80 	movzbl -0x7fef6180(%ecx),%eax
  shift |= shiftcode[data];
80103cc9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80103ccb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103ccd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80103ccf:	89 15 1c 49 11 80    	mov    %edx,0x8011491c
  c = charcode[shift & (CTL | SHIFT)][data];
80103cd5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80103cd8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80103cdb:	8b 04 85 60 9e 10 80 	mov    -0x7fef61a0(,%eax,4),%eax
80103ce2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80103ce6:	74 0b                	je     80103cf3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80103ce8:	8d 50 9f             	lea    -0x61(%eax),%edx
80103ceb:	83 fa 19             	cmp    $0x19,%edx
80103cee:	77 48                	ja     80103d38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80103cf0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80103cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf6:	c9                   	leave
80103cf7:	c3                   	ret
80103cf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cff:	00 
    shift |= E0ESC;
80103d00:	83 cb 40             	or     $0x40,%ebx
    return 0;
80103d03:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80103d05:	89 1d 1c 49 11 80    	mov    %ebx,0x8011491c
}
80103d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0e:	c9                   	leave
80103d0f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80103d10:	83 e0 7f             	and    $0x7f,%eax
80103d13:	85 d2                	test   %edx,%edx
80103d15:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80103d18:	0f b6 81 80 9f 10 80 	movzbl -0x7fef6080(%ecx),%eax
80103d1f:	83 c8 40             	or     $0x40,%eax
80103d22:	0f b6 c0             	movzbl %al,%eax
80103d25:	f7 d0                	not    %eax
80103d27:	21 d8                	and    %ebx,%eax
80103d29:	a3 1c 49 11 80       	mov    %eax,0x8011491c
    return 0;
80103d2e:	31 c0                	xor    %eax,%eax
80103d30:	eb d9                	jmp    80103d0b <kbdgetc+0x8b>
80103d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80103d38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80103d3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80103d3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d41:	c9                   	leave
      c += 'a' - 'A';
80103d42:	83 f9 1a             	cmp    $0x1a,%ecx
80103d45:	0f 42 c2             	cmovb  %edx,%eax
}
80103d48:	c3                   	ret
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80103d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d55:	c3                   	ret
80103d56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d5d:	00 
80103d5e:	66 90                	xchg   %ax,%ax

80103d60 <kbdintr>:

void
kbdintr(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103d66:	68 80 3c 10 80       	push   $0x80103c80
80103d6b:	e8 00 d2 ff ff       	call   80100f70 <consoleintr>
}
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	c9                   	leave
80103d74:	c3                   	ret
80103d75:	66 90                	xchg   %ax,%ax
80103d77:	66 90                	xchg   %ax,%ax
80103d79:	66 90                	xchg   %ax,%ax
80103d7b:	66 90                	xchg   %ax,%ax
80103d7d:	66 90                	xchg   %ax,%ax
80103d7f:	90                   	nop

80103d80 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}
void
lapicinit(void)
{
  if(!lapic)
80103d80:	a1 20 49 11 80       	mov    0x80114920,%eax
80103d85:	85 c0                	test   %eax,%eax
80103d87:	0f 84 c3 00 00 00    	je     80103e50 <lapicinit+0xd0>
  lapic[index] = value;
80103d8d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103d94:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103d97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103d9a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103da1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103da4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103da7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103dae:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103db1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103db4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80103dbb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103dbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103dc1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80103dc8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103dcb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103dce:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103dd5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103dd8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103ddb:	8b 50 30             	mov    0x30(%eax),%edx
80103dde:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80103de4:	75 72                	jne    80103e58 <lapicinit+0xd8>
  lapic[index] = value;
80103de6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103ded:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103df0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103df3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103dfa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103dfd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103e00:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103e07:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103e0a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103e0d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103e14:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103e17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103e1a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103e21:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103e24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103e27:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103e2e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103e31:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e38:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103e3e:	80 e6 10             	and    $0x10,%dh
80103e41:	75 f5                	jne    80103e38 <lapicinit+0xb8>
  lapic[index] = value;
80103e43:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103e4a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103e4d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103e50:	c3                   	ret
80103e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103e58:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103e5f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80103e62:	8b 50 20             	mov    0x20(%eax),%edx
}
80103e65:	e9 7c ff ff ff       	jmp    80103de6 <lapicinit+0x66>
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103e70:	a1 20 49 11 80       	mov    0x80114920,%eax
80103e75:	85 c0                	test   %eax,%eax
80103e77:	74 07                	je     80103e80 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80103e79:	8b 40 20             	mov    0x20(%eax),%eax
80103e7c:	c1 e8 18             	shr    $0x18,%eax
80103e7f:	c3                   	ret
    return 0;
80103e80:	31 c0                	xor    %eax,%eax
}
80103e82:	c3                   	ret
80103e83:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e8a:	00 
80103e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103e90 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103e90:	a1 20 49 11 80       	mov    0x80114920,%eax
80103e95:	85 c0                	test   %eax,%eax
80103e97:	74 0d                	je     80103ea6 <lapiceoi+0x16>
  lapic[index] = value;
80103e99:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103ea0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103ea3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103ea6:	c3                   	ret
80103ea7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eae:	00 
80103eaf:	90                   	nop

80103eb0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80103eb0:	c3                   	ret
80103eb1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eb8:	00 
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103ec0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ec1:	b8 0f 00 00 00       	mov    $0xf,%eax
80103ec6:	ba 70 00 00 00       	mov    $0x70,%edx
80103ecb:	89 e5                	mov    %esp,%ebp
80103ecd:	53                   	push   %ebx
80103ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ed1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ed4:	ee                   	out    %al,(%dx)
80103ed5:	b8 0a 00 00 00       	mov    $0xa,%eax
80103eda:	ba 71 00 00 00       	mov    $0x71,%edx
80103edf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103ee0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80103ee2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103ee5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80103eeb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103eed:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80103ef0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103ef2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103ef5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103ef8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103efe:	a1 20 49 11 80       	mov    0x80114920,%eax
80103f03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103f09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103f0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103f13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103f16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103f19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103f20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103f23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103f26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103f2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103f2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103f35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103f38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103f3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103f41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103f47:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80103f4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f4d:	c9                   	leave
80103f4e:	c3                   	ret
80103f4f:	90                   	nop

80103f50 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103f50:	55                   	push   %ebp
80103f51:	b8 0b 00 00 00       	mov    $0xb,%eax
80103f56:	ba 70 00 00 00       	mov    $0x70,%edx
80103f5b:	89 e5                	mov    %esp,%ebp
80103f5d:	57                   	push   %edi
80103f5e:	56                   	push   %esi
80103f5f:	53                   	push   %ebx
80103f60:	83 ec 4c             	sub    $0x4c,%esp
80103f63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103f64:	ba 71 00 00 00       	mov    $0x71,%edx
80103f69:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80103f6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f6d:	bf 70 00 00 00       	mov    $0x70,%edi
80103f72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
80103f78:	31 c0                	xor    %eax,%eax
80103f7a:	89 fa                	mov    %edi,%edx
80103f7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103f7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103f82:	89 ca                	mov    %ecx,%edx
80103f84:	ec                   	in     (%dx),%al
80103f85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f88:	89 fa                	mov    %edi,%edx
80103f8a:	b8 02 00 00 00       	mov    $0x2,%eax
80103f8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103f90:	89 ca                	mov    %ecx,%edx
80103f92:	ec                   	in     (%dx),%al
80103f93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f96:	89 fa                	mov    %edi,%edx
80103f98:	b8 04 00 00 00       	mov    $0x4,%eax
80103f9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103f9e:	89 ca                	mov    %ecx,%edx
80103fa0:	ec                   	in     (%dx),%al
80103fa1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fa4:	89 fa                	mov    %edi,%edx
80103fa6:	b8 07 00 00 00       	mov    $0x7,%eax
80103fab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fac:	89 ca                	mov    %ecx,%edx
80103fae:	ec                   	in     (%dx),%al
80103faf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fb2:	89 fa                	mov    %edi,%edx
80103fb4:	b8 08 00 00 00       	mov    $0x8,%eax
80103fb9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fba:	89 ca                	mov    %ecx,%edx
80103fbc:	ec                   	in     (%dx),%al
80103fbd:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fbf:	89 fa                	mov    %edi,%edx
80103fc1:	b8 09 00 00 00       	mov    $0x9,%eax
80103fc6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fc7:	89 ca                	mov    %ecx,%edx
80103fc9:	ec                   	in     (%dx),%al
80103fca:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fcd:	89 fa                	mov    %edi,%edx
80103fcf:	b8 0a 00 00 00       	mov    $0xa,%eax
80103fd4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fd5:	89 ca                	mov    %ecx,%edx
80103fd7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103fd8:	84 c0                	test   %al,%al
80103fda:	78 9c                	js     80103f78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80103fdc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103fe0:	89 f2                	mov    %esi,%edx
80103fe2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80103fe5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103fe8:	89 fa                	mov    %edi,%edx
80103fea:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103fed:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103ff1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80103ff4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103ff7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103ffb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103ffe:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80104002:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80104005:	31 c0                	xor    %eax,%eax
80104007:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104008:	89 ca                	mov    %ecx,%edx
8010400a:	ec                   	in     (%dx),%al
8010400b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010400e:	89 fa                	mov    %edi,%edx
80104010:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104013:	b8 02 00 00 00       	mov    $0x2,%eax
80104018:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104019:	89 ca                	mov    %ecx,%edx
8010401b:	ec                   	in     (%dx),%al
8010401c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010401f:	89 fa                	mov    %edi,%edx
80104021:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104024:	b8 04 00 00 00       	mov    $0x4,%eax
80104029:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010402a:	89 ca                	mov    %ecx,%edx
8010402c:	ec                   	in     (%dx),%al
8010402d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104030:	89 fa                	mov    %edi,%edx
80104032:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104035:	b8 07 00 00 00       	mov    $0x7,%eax
8010403a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010403b:	89 ca                	mov    %ecx,%edx
8010403d:	ec                   	in     (%dx),%al
8010403e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104041:	89 fa                	mov    %edi,%edx
80104043:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104046:	b8 08 00 00 00       	mov    $0x8,%eax
8010404b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010404c:	89 ca                	mov    %ecx,%edx
8010404e:	ec                   	in     (%dx),%al
8010404f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104052:	89 fa                	mov    %edi,%edx
80104054:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104057:	b8 09 00 00 00       	mov    $0x9,%eax
8010405c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010405d:	89 ca                	mov    %ecx,%edx
8010405f:	ec                   	in     (%dx),%al
80104060:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80104063:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80104066:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80104069:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010406c:	6a 18                	push   $0x18
8010406e:	50                   	push   %eax
8010406f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80104072:	50                   	push   %eax
80104073:	e8 d8 23 00 00       	call   80106450 <memcmp>
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	85 c0                	test   %eax,%eax
8010407d:	0f 85 f5 fe ff ff    	jne    80103f78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80104083:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010408a:	89 f0                	mov    %esi,%eax
8010408c:	84 c0                	test   %al,%al
8010408e:	75 78                	jne    80104108 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80104090:	8b 45 b8             	mov    -0x48(%ebp),%eax
80104093:	89 c2                	mov    %eax,%edx
80104095:	83 e0 0f             	and    $0xf,%eax
80104098:	c1 ea 04             	shr    $0x4,%edx
8010409b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010409e:	8d 04 50             	lea    (%eax,%edx,2),%eax
801040a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801040a4:	8b 45 bc             	mov    -0x44(%ebp),%eax
801040a7:	89 c2                	mov    %eax,%edx
801040a9:	83 e0 0f             	and    $0xf,%eax
801040ac:	c1 ea 04             	shr    $0x4,%edx
801040af:	8d 14 92             	lea    (%edx,%edx,4),%edx
801040b2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801040b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801040b8:	8b 45 c0             	mov    -0x40(%ebp),%eax
801040bb:	89 c2                	mov    %eax,%edx
801040bd:	83 e0 0f             	and    $0xf,%eax
801040c0:	c1 ea 04             	shr    $0x4,%edx
801040c3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801040c6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801040c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801040cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801040cf:	89 c2                	mov    %eax,%edx
801040d1:	83 e0 0f             	and    $0xf,%eax
801040d4:	c1 ea 04             	shr    $0x4,%edx
801040d7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801040da:	8d 04 50             	lea    (%eax,%edx,2),%eax
801040dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801040e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801040e3:	89 c2                	mov    %eax,%edx
801040e5:	83 e0 0f             	and    $0xf,%eax
801040e8:	c1 ea 04             	shr    $0x4,%edx
801040eb:	8d 14 92             	lea    (%edx,%edx,4),%edx
801040ee:	8d 04 50             	lea    (%eax,%edx,2),%eax
801040f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801040f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
801040f7:	89 c2                	mov    %eax,%edx
801040f9:	83 e0 0f             	and    $0xf,%eax
801040fc:	c1 ea 04             	shr    $0x4,%edx
801040ff:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104102:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104105:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80104108:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010410b:	89 03                	mov    %eax,(%ebx)
8010410d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104110:	89 43 04             	mov    %eax,0x4(%ebx)
80104113:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104116:	89 43 08             	mov    %eax,0x8(%ebx)
80104119:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010411c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010411f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104122:	89 43 10             	mov    %eax,0x10(%ebx)
80104125:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104128:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
8010412b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80104132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104135:	5b                   	pop    %ebx
80104136:	5e                   	pop    %esi
80104137:	5f                   	pop    %edi
80104138:	5d                   	pop    %ebp
80104139:	c3                   	ret
8010413a:	66 90                	xchg   %ax,%ax
8010413c:	66 90                	xchg   %ax,%ax
8010413e:	66 90                	xchg   %ax,%ax

80104140 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80104140:	8b 0d 88 49 11 80    	mov    0x80114988,%ecx
80104146:	85 c9                	test   %ecx,%ecx
80104148:	0f 8e 8a 00 00 00    	jle    801041d8 <install_trans+0x98>
{
8010414e:	55                   	push   %ebp
8010414f:	89 e5                	mov    %esp,%ebp
80104151:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80104152:	31 ff                	xor    %edi,%edi
{
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
80104156:	83 ec 0c             	sub    $0xc,%esp
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80104160:	a1 74 49 11 80       	mov    0x80114974,%eax
80104165:	83 ec 08             	sub    $0x8,%esp
80104168:	01 f8                	add    %edi,%eax
8010416a:	83 c0 01             	add    $0x1,%eax
8010416d:	50                   	push   %eax
8010416e:	ff 35 84 49 11 80    	push   0x80114984
80104174:	e8 57 bf ff ff       	call   801000d0 <bread>
80104179:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010417b:	58                   	pop    %eax
8010417c:	5a                   	pop    %edx
8010417d:	ff 34 bd 8c 49 11 80 	push   -0x7feeb674(,%edi,4)
80104184:	ff 35 84 49 11 80    	push   0x80114984
  for (tail = 0; tail < log.lh.n; tail++) {
8010418a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010418d:	e8 3e bf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104192:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104195:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104197:	8d 46 5c             	lea    0x5c(%esi),%eax
8010419a:	68 00 02 00 00       	push   $0x200
8010419f:	50                   	push   %eax
801041a0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801041a3:	50                   	push   %eax
801041a4:	e8 f7 22 00 00       	call   801064a0 <memmove>
    bwrite(dbuf);  // write dst to disk
801041a9:	89 1c 24             	mov    %ebx,(%esp)
801041ac:	e8 ff bf ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801041b1:	89 34 24             	mov    %esi,(%esp)
801041b4:	e8 37 c0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801041b9:	89 1c 24             	mov    %ebx,(%esp)
801041bc:	e8 2f c0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801041c1:	83 c4 10             	add    $0x10,%esp
801041c4:	39 3d 88 49 11 80    	cmp    %edi,0x80114988
801041ca:	7f 94                	jg     80104160 <install_trans+0x20>
  }
}
801041cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041cf:	5b                   	pop    %ebx
801041d0:	5e                   	pop    %esi
801041d1:	5f                   	pop    %edi
801041d2:	5d                   	pop    %ebp
801041d3:	c3                   	ret
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d8:	c3                   	ret
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041e0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801041e7:	ff 35 74 49 11 80    	push   0x80114974
801041ed:	ff 35 84 49 11 80    	push   0x80114984
801041f3:	e8 d8 be ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801041f8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801041fb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801041fd:	a1 88 49 11 80       	mov    0x80114988,%eax
80104202:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104205:	85 c0                	test   %eax,%eax
80104207:	7e 19                	jle    80104222 <write_head+0x42>
80104209:	31 d2                	xor    %edx,%edx
8010420b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80104210:	8b 0c 95 8c 49 11 80 	mov    -0x7feeb674(,%edx,4),%ecx
80104217:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010421b:	83 c2 01             	add    $0x1,%edx
8010421e:	39 d0                	cmp    %edx,%eax
80104220:	75 ee                	jne    80104210 <write_head+0x30>
  }
  bwrite(buf);
80104222:	83 ec 0c             	sub    $0xc,%esp
80104225:	53                   	push   %ebx
80104226:	e8 85 bf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010422b:	89 1c 24             	mov    %ebx,(%esp)
8010422e:	e8 bd bf ff ff       	call   801001f0 <brelse>
}
80104233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104236:	83 c4 10             	add    $0x10,%esp
80104239:	c9                   	leave
8010423a:	c3                   	ret
8010423b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104240 <initlog>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 2c             	sub    $0x2c,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010424a:	68 d7 97 10 80       	push   $0x801097d7
8010424f:	68 40 49 11 80       	push   $0x80114940
80104254:	e8 c7 1e 00 00       	call   80106120 <initlock>
  readsb(dev, &sb);
80104259:	58                   	pop    %eax
8010425a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010425d:	5a                   	pop    %edx
8010425e:	50                   	push   %eax
8010425f:	53                   	push   %ebx
80104260:	e8 7b e8 ff ff       	call   80102ae0 <readsb>
  log.start = sb.logstart;
80104265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80104268:	59                   	pop    %ecx
  log.dev = dev;
80104269:	89 1d 84 49 11 80    	mov    %ebx,0x80114984
  log.size = sb.nlog;
8010426f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104272:	a3 74 49 11 80       	mov    %eax,0x80114974
  log.size = sb.nlog;
80104277:	89 15 78 49 11 80    	mov    %edx,0x80114978
  struct buf *buf = bread(log.dev, log.start);
8010427d:	5a                   	pop    %edx
8010427e:	50                   	push   %eax
8010427f:	53                   	push   %ebx
80104280:	e8 4b be ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104285:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104288:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010428b:	89 1d 88 49 11 80    	mov    %ebx,0x80114988
  for (i = 0; i < log.lh.n; i++) {
80104291:	85 db                	test   %ebx,%ebx
80104293:	7e 1d                	jle    801042b2 <initlog+0x72>
80104295:	31 d2                	xor    %edx,%edx
80104297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010429e:	00 
8010429f:	90                   	nop
    log.lh.block[i] = lh->block[i];
801042a0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801042a4:	89 0c 95 8c 49 11 80 	mov    %ecx,-0x7feeb674(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801042ab:	83 c2 01             	add    $0x1,%edx
801042ae:	39 d3                	cmp    %edx,%ebx
801042b0:	75 ee                	jne    801042a0 <initlog+0x60>
  brelse(buf);
801042b2:	83 ec 0c             	sub    $0xc,%esp
801042b5:	50                   	push   %eax
801042b6:	e8 35 bf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801042bb:	e8 80 fe ff ff       	call   80104140 <install_trans>
  log.lh.n = 0;
801042c0:	c7 05 88 49 11 80 00 	movl   $0x0,0x80114988
801042c7:	00 00 00 
  write_head(); // clear the log
801042ca:	e8 11 ff ff ff       	call   801041e0 <write_head>
}
801042cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d2:	83 c4 10             	add    $0x10,%esp
801042d5:	c9                   	leave
801042d6:	c3                   	ret
801042d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042de:	00 
801042df:	90                   	nop

801042e0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801042e6:	68 40 49 11 80       	push   $0x80114940
801042eb:	e8 20 20 00 00       	call   80106310 <acquire>
801042f0:	83 c4 10             	add    $0x10,%esp
801042f3:	eb 18                	jmp    8010430d <begin_op+0x2d>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801042f8:	83 ec 08             	sub    $0x8,%esp
801042fb:	68 40 49 11 80       	push   $0x80114940
80104300:	68 40 49 11 80       	push   $0x80114940
80104305:	e8 36 17 00 00       	call   80105a40 <sleep>
8010430a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010430d:	a1 80 49 11 80       	mov    0x80114980,%eax
80104312:	85 c0                	test   %eax,%eax
80104314:	75 e2                	jne    801042f8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104316:	a1 7c 49 11 80       	mov    0x8011497c,%eax
8010431b:	8b 15 88 49 11 80    	mov    0x80114988,%edx
80104321:	83 c0 01             	add    $0x1,%eax
80104324:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104327:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010432a:	83 fa 1e             	cmp    $0x1e,%edx
8010432d:	7f c9                	jg     801042f8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010432f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104332:	a3 7c 49 11 80       	mov    %eax,0x8011497c
      release(&log.lock);
80104337:	68 40 49 11 80       	push   $0x80114940
8010433c:	e8 6f 1f 00 00       	call   801062b0 <release>
      break;
    }
  }
}
80104341:	83 c4 10             	add    $0x10,%esp
80104344:	c9                   	leave
80104345:	c3                   	ret
80104346:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010434d:	00 
8010434e:	66 90                	xchg   %ax,%ax

80104350 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80104359:	68 40 49 11 80       	push   $0x80114940
8010435e:	e8 ad 1f 00 00       	call   80106310 <acquire>
  log.outstanding -= 1;
80104363:	a1 7c 49 11 80       	mov    0x8011497c,%eax
  if(log.committing)
80104368:	8b 35 80 49 11 80    	mov    0x80114980,%esi
8010436e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104371:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104374:	89 1d 7c 49 11 80    	mov    %ebx,0x8011497c
  if(log.committing)
8010437a:	85 f6                	test   %esi,%esi
8010437c:	0f 85 22 01 00 00    	jne    801044a4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104382:	85 db                	test   %ebx,%ebx
80104384:	0f 85 f6 00 00 00    	jne    80104480 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010438a:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
80104391:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104394:	83 ec 0c             	sub    $0xc,%esp
80104397:	68 40 49 11 80       	push   $0x80114940
8010439c:	e8 0f 1f 00 00       	call   801062b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801043a1:	8b 0d 88 49 11 80    	mov    0x80114988,%ecx
801043a7:	83 c4 10             	add    $0x10,%esp
801043aa:	85 c9                	test   %ecx,%ecx
801043ac:	7f 42                	jg     801043f0 <end_op+0xa0>
    acquire(&log.lock);
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	68 40 49 11 80       	push   $0x80114940
801043b6:	e8 55 1f 00 00       	call   80106310 <acquire>
    log.committing = 0;
801043bb:	c7 05 80 49 11 80 00 	movl   $0x0,0x80114980
801043c2:	00 00 00 
    wakeup(&log);
801043c5:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
801043cc:	e8 2f 17 00 00       	call   80105b00 <wakeup>
    release(&log.lock);
801043d1:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
801043d8:	e8 d3 1e 00 00       	call   801062b0 <release>
801043dd:	83 c4 10             	add    $0x10,%esp
}
801043e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e3:	5b                   	pop    %ebx
801043e4:	5e                   	pop    %esi
801043e5:	5f                   	pop    %edi
801043e6:	5d                   	pop    %ebp
801043e7:	c3                   	ret
801043e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043ef:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801043f0:	a1 74 49 11 80       	mov    0x80114974,%eax
801043f5:	83 ec 08             	sub    $0x8,%esp
801043f8:	01 d8                	add    %ebx,%eax
801043fa:	83 c0 01             	add    $0x1,%eax
801043fd:	50                   	push   %eax
801043fe:	ff 35 84 49 11 80    	push   0x80114984
80104404:	e8 c7 bc ff ff       	call   801000d0 <bread>
80104409:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010440b:	58                   	pop    %eax
8010440c:	5a                   	pop    %edx
8010440d:	ff 34 9d 8c 49 11 80 	push   -0x7feeb674(,%ebx,4)
80104414:	ff 35 84 49 11 80    	push   0x80114984
  for (tail = 0; tail < log.lh.n; tail++) {
8010441a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010441d:	e8 ae bc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104422:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104425:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104427:	8d 40 5c             	lea    0x5c(%eax),%eax
8010442a:	68 00 02 00 00       	push   $0x200
8010442f:	50                   	push   %eax
80104430:	8d 46 5c             	lea    0x5c(%esi),%eax
80104433:	50                   	push   %eax
80104434:	e8 67 20 00 00       	call   801064a0 <memmove>
    bwrite(to);  // write the log
80104439:	89 34 24             	mov    %esi,(%esp)
8010443c:	e8 6f bd ff ff       	call   801001b0 <bwrite>
    brelse(from);
80104441:	89 3c 24             	mov    %edi,(%esp)
80104444:	e8 a7 bd ff ff       	call   801001f0 <brelse>
    brelse(to);
80104449:	89 34 24             	mov    %esi,(%esp)
8010444c:	e8 9f bd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104451:	83 c4 10             	add    $0x10,%esp
80104454:	3b 1d 88 49 11 80    	cmp    0x80114988,%ebx
8010445a:	7c 94                	jl     801043f0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010445c:	e8 7f fd ff ff       	call   801041e0 <write_head>
    install_trans(); // Now install writes to home locations
80104461:	e8 da fc ff ff       	call   80104140 <install_trans>
    log.lh.n = 0;
80104466:	c7 05 88 49 11 80 00 	movl   $0x0,0x80114988
8010446d:	00 00 00 
    write_head();    // Erase the transaction from the log
80104470:	e8 6b fd ff ff       	call   801041e0 <write_head>
80104475:	e9 34 ff ff ff       	jmp    801043ae <end_op+0x5e>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 40 49 11 80       	push   $0x80114940
80104488:	e8 73 16 00 00       	call   80105b00 <wakeup>
  release(&log.lock);
8010448d:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
80104494:	e8 17 1e 00 00       	call   801062b0 <release>
80104499:	83 c4 10             	add    $0x10,%esp
}
8010449c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010449f:	5b                   	pop    %ebx
801044a0:	5e                   	pop    %esi
801044a1:	5f                   	pop    %edi
801044a2:	5d                   	pop    %ebp
801044a3:	c3                   	ret
    panic("log.committing");
801044a4:	83 ec 0c             	sub    $0xc,%esp
801044a7:	68 db 97 10 80       	push   $0x801097db
801044ac:	e8 9f c0 ff ff       	call   80100550 <panic>
801044b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044b8:	00 
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801044c7:	8b 15 88 49 11 80    	mov    0x80114988,%edx
{
801044cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801044d0:	83 fa 1d             	cmp    $0x1d,%edx
801044d3:	7f 7d                	jg     80104552 <log_write+0x92>
801044d5:	a1 78 49 11 80       	mov    0x80114978,%eax
801044da:	83 e8 01             	sub    $0x1,%eax
801044dd:	39 c2                	cmp    %eax,%edx
801044df:	7d 71                	jge    80104552 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
801044e1:	a1 7c 49 11 80       	mov    0x8011497c,%eax
801044e6:	85 c0                	test   %eax,%eax
801044e8:	7e 75                	jle    8010455f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	68 40 49 11 80       	push   $0x80114940
801044f2:	e8 19 1e 00 00       	call   80106310 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801044f7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801044fa:	83 c4 10             	add    $0x10,%esp
801044fd:	31 c0                	xor    %eax,%eax
801044ff:	8b 15 88 49 11 80    	mov    0x80114988,%edx
80104505:	85 d2                	test   %edx,%edx
80104507:	7f 0e                	jg     80104517 <log_write+0x57>
80104509:	eb 15                	jmp    80104520 <log_write+0x60>
8010450b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104510:	83 c0 01             	add    $0x1,%eax
80104513:	39 c2                	cmp    %eax,%edx
80104515:	74 29                	je     80104540 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104517:	39 0c 85 8c 49 11 80 	cmp    %ecx,-0x7feeb674(,%eax,4)
8010451e:	75 f0                	jne    80104510 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104520:	89 0c 85 8c 49 11 80 	mov    %ecx,-0x7feeb674(,%eax,4)
  if (i == log.lh.n)
80104527:	39 c2                	cmp    %eax,%edx
80104529:	74 1c                	je     80104547 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010452b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010452e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80104531:	c7 45 08 40 49 11 80 	movl   $0x80114940,0x8(%ebp)
}
80104538:	c9                   	leave
  release(&log.lock);
80104539:	e9 72 1d 00 00       	jmp    801062b0 <release>
8010453e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104540:	89 0c 95 8c 49 11 80 	mov    %ecx,-0x7feeb674(,%edx,4)
    log.lh.n++;
80104547:	83 c2 01             	add    $0x1,%edx
8010454a:	89 15 88 49 11 80    	mov    %edx,0x80114988
80104550:	eb d9                	jmp    8010452b <log_write+0x6b>
    panic("too big a transaction");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 ea 97 10 80       	push   $0x801097ea
8010455a:	e8 f1 bf ff ff       	call   80100550 <panic>
    panic("log_write outside of trans");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 00 98 10 80       	push   $0x80109800
80104567:	e8 e4 bf ff ff       	call   80100550 <panic>
8010456c:	66 90                	xchg   %ax,%ax
8010456e:	66 90                	xchg   %ax,%ax

80104570 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104577:	e8 94 0a 00 00       	call   80105010 <cpuid>
8010457c:	89 c3                	mov    %eax,%ebx
8010457e:	e8 8d 0a 00 00       	call   80105010 <cpuid>
80104583:	83 ec 04             	sub    $0x4,%esp
80104586:	53                   	push   %ebx
80104587:	50                   	push   %eax
80104588:	68 1b 98 10 80       	push   $0x8010981b
8010458d:	e8 ce c7 ff ff       	call   80100d60 <cprintf>
  idtinit();       // load idt register
80104592:	e8 89 37 00 00       	call   80107d20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104597:	e8 14 0a 00 00       	call   80104fb0 <mycpu>
8010459c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010459e:	b8 01 00 00 00       	mov    $0x1,%eax
801045a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801045aa:	e8 61 0d 00 00       	call   80105310 <scheduler>
801045af:	90                   	nop

801045b0 <mpenter>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801045b6:	e8 c5 48 00 00       	call   80108e80 <switchkvm>
  seginit();
801045bb:	e8 30 48 00 00       	call   80108df0 <seginit>
  lapicinit();
801045c0:	e8 bb f7 ff ff       	call   80103d80 <lapicinit>
  mpmain();
801045c5:	e8 a6 ff ff ff       	call   80104570 <mpmain>
801045ca:	66 90                	xchg   %ax,%ax
801045cc:	66 90                	xchg   %ax,%ax
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <main>:
{
801045d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801045d4:	83 e4 f0             	and    $0xfffffff0,%esp
801045d7:	ff 71 fc             	push   -0x4(%ecx)
801045da:	55                   	push   %ebp
801045db:	89 e5                	mov    %esp,%ebp
801045dd:	53                   	push   %ebx
801045de:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801045df:	83 ec 08             	sub    $0x8,%esp
801045e2:	68 00 00 40 80       	push   $0x80400000
801045e7:	68 30 8e 11 80       	push   $0x80118e30
801045ec:	e8 9f f5 ff ff       	call   80103b90 <kinit1>
  kvmalloc();      // kernel page table
801045f1:	e8 4a 4d 00 00       	call   80109340 <kvmalloc>
  mpinit();        // detect other processors
801045f6:	e8 85 01 00 00       	call   80104780 <mpinit>
  lapicinit();     // interrupt controller
801045fb:	e8 80 f7 ff ff       	call   80103d80 <lapicinit>
  seginit();       // segment descriptors
80104600:	e8 eb 47 00 00       	call   80108df0 <seginit>
  picinit();       // disable pic
80104605:	e8 86 03 00 00       	call   80104990 <picinit>
  ioapicinit();    // another interrupt controller
8010460a:	e8 51 f3 ff ff       	call   80103960 <ioapicinit>
  consoleinit();   // console hardware
8010460f:	e8 bc d9 ff ff       	call   80101fd0 <consoleinit>
  uartinit();      // serial port
80104614:	e8 47 3a 00 00       	call   80108060 <uartinit>
  pinit();         // process table
80104619:	e8 72 09 00 00       	call   80104f90 <pinit>
  tvinit();        // trap vectors
8010461e:	e8 7d 36 00 00       	call   80107ca0 <tvinit>
  binit();         // buffer cache
80104623:	e8 18 ba ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104628:	e8 a3 dd ff ff       	call   801023d0 <fileinit>
  ideinit();       // disk 
8010462d:	e8 0e f1 ff ff       	call   80103740 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104632:	83 c4 0c             	add    $0xc,%esp
80104635:	68 8a 00 00 00       	push   $0x8a
8010463a:	68 8c d4 10 80       	push   $0x8010d48c
8010463f:	68 00 70 00 80       	push   $0x80007000
80104644:	e8 57 1e 00 00       	call   801064a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	69 05 24 4a 11 80 b8 	imul   $0xb8,0x80114a24,%eax
80104653:	00 00 00 
80104656:	05 40 4a 11 80       	add    $0x80114a40,%eax
8010465b:	3d 40 4a 11 80       	cmp    $0x80114a40,%eax
80104660:	76 7e                	jbe    801046e0 <main+0x110>
80104662:	bb 40 4a 11 80       	mov    $0x80114a40,%ebx
80104667:	eb 20                	jmp    80104689 <main+0xb9>
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104670:	69 05 24 4a 11 80 b8 	imul   $0xb8,0x80114a24,%eax
80104677:	00 00 00 
8010467a:	81 c3 b8 00 00 00    	add    $0xb8,%ebx
80104680:	05 40 4a 11 80       	add    $0x80114a40,%eax
80104685:	39 c3                	cmp    %eax,%ebx
80104687:	73 57                	jae    801046e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80104689:	e8 22 09 00 00       	call   80104fb0 <mycpu>
8010468e:	39 c3                	cmp    %eax,%ebx
80104690:	74 de                	je     80104670 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80104692:	e8 69 f5 ff ff       	call   80103c00 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80104697:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010469a:	c7 05 f8 6f 00 80 b0 	movl   $0x801045b0,0x80006ff8
801046a1:	45 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801046a4:	c7 05 f4 6f 00 80 00 	movl   $0x10c000,0x80006ff4
801046ab:	c0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801046ae:	05 00 10 00 00       	add    $0x1000,%eax
801046b3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801046b8:	0f b6 03             	movzbl (%ebx),%eax
801046bb:	68 00 70 00 00       	push   $0x7000
801046c0:	50                   	push   %eax
801046c1:	e8 fa f7 ff ff       	call   80103ec0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801046d6:	85 c0                	test   %eax,%eax
801046d8:	74 f6                	je     801046d0 <main+0x100>
801046da:	eb 94                	jmp    80104670 <main+0xa0>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801046e0:	83 ec 08             	sub    $0x8,%esp
801046e3:	68 00 00 00 8e       	push   $0x8e000000
801046e8:	68 00 00 40 80       	push   $0x80400000
801046ed:	e8 3e f4 ff ff       	call   80103b30 <kinit2>
  userinit();      // first user process
801046f2:	e8 69 09 00 00       	call   80105060 <userinit>
  mpmain();        // finish this processor's setup
801046f7:	e8 74 fe ff ff       	call   80104570 <mpmain>
801046fc:	66 90                	xchg   %ax,%ax
801046fe:	66 90                	xchg   %ax,%ax

80104700 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80104705:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010470b:	53                   	push   %ebx
  e = addr+len;
8010470c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010470f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80104712:	39 de                	cmp    %ebx,%esi
80104714:	72 10                	jb     80104726 <mpsearch1+0x26>
80104716:	eb 50                	jmp    80104768 <mpsearch1+0x68>
80104718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010471f:	00 
80104720:	89 fe                	mov    %edi,%esi
80104722:	39 df                	cmp    %ebx,%edi
80104724:	73 42                	jae    80104768 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104726:	83 ec 04             	sub    $0x4,%esp
80104729:	8d 7e 10             	lea    0x10(%esi),%edi
8010472c:	6a 04                	push   $0x4
8010472e:	68 2f 98 10 80       	push   $0x8010982f
80104733:	56                   	push   %esi
80104734:	e8 17 1d 00 00       	call   80106450 <memcmp>
80104739:	83 c4 10             	add    $0x10,%esp
8010473c:	85 c0                	test   %eax,%eax
8010473e:	75 e0                	jne    80104720 <mpsearch1+0x20>
80104740:	89 f2                	mov    %esi,%edx
80104742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80104748:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010474b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010474e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104750:	39 fa                	cmp    %edi,%edx
80104752:	75 f4                	jne    80104748 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80104754:	84 c0                	test   %al,%al
80104756:	75 c8                	jne    80104720 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80104758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475b:	89 f0                	mov    %esi,%eax
8010475d:	5b                   	pop    %ebx
8010475e:	5e                   	pop    %esi
8010475f:	5f                   	pop    %edi
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010476b:	31 f6                	xor    %esi,%esi
}
8010476d:	5b                   	pop    %ebx
8010476e:	89 f0                	mov    %esi,%eax
80104770:	5e                   	pop    %esi
80104771:	5f                   	pop    %edi
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret
80104774:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010477b:	00 
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104780 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx
80104786:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80104789:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80104790:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80104797:	c1 e0 08             	shl    $0x8,%eax
8010479a:	09 d0                	or     %edx,%eax
8010479c:	c1 e0 04             	shl    $0x4,%eax
8010479f:	75 1b                	jne    801047bc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801047a1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801047a8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801047af:	c1 e0 08             	shl    $0x8,%eax
801047b2:	09 d0                	or     %edx,%eax
801047b4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801047b7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801047bc:	ba 00 04 00 00       	mov    $0x400,%edx
801047c1:	e8 3a ff ff ff       	call   80104700 <mpsearch1>
801047c6:	89 c3                	mov    %eax,%ebx
801047c8:	85 c0                	test   %eax,%eax
801047ca:	0f 84 58 01 00 00    	je     80104928 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801047d0:	8b 73 04             	mov    0x4(%ebx),%esi
801047d3:	85 f6                	test   %esi,%esi
801047d5:	0f 84 3d 01 00 00    	je     80104918 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801047db:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801047de:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801047e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801047e7:	6a 04                	push   $0x4
801047e9:	68 34 98 10 80       	push   $0x80109834
801047ee:	50                   	push   %eax
801047ef:	e8 5c 1c 00 00       	call   80106450 <memcmp>
801047f4:	83 c4 10             	add    $0x10,%esp
801047f7:	85 c0                	test   %eax,%eax
801047f9:	0f 85 19 01 00 00    	jne    80104918 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801047ff:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80104806:	3c 01                	cmp    $0x1,%al
80104808:	74 08                	je     80104812 <mpinit+0x92>
8010480a:	3c 04                	cmp    $0x4,%al
8010480c:	0f 85 06 01 00 00    	jne    80104918 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80104812:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80104819:	66 85 d2             	test   %dx,%dx
8010481c:	74 22                	je     80104840 <mpinit+0xc0>
8010481e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80104821:	89 f0                	mov    %esi,%eax
  sum = 0;
80104823:	31 d2                	xor    %edx,%edx
80104825:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80104828:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010482f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80104832:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80104834:	39 f8                	cmp    %edi,%eax
80104836:	75 f0                	jne    80104828 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80104838:	84 d2                	test   %dl,%dl
8010483a:	0f 85 d8 00 00 00    	jne    80104918 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80104840:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104846:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80104849:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010484c:	a3 20 49 11 80       	mov    %eax,0x80114920
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104851:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80104858:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010485e:	01 d7                	add    %edx,%edi
80104860:	89 fa                	mov    %edi,%edx
  ismp = 1;
80104862:	bf 01 00 00 00       	mov    $0x1,%edi
80104867:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010486e:	00 
8010486f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104870:	39 d0                	cmp    %edx,%eax
80104872:	73 19                	jae    8010488d <mpinit+0x10d>
    switch(*p){
80104874:	0f b6 08             	movzbl (%eax),%ecx
80104877:	80 f9 02             	cmp    $0x2,%cl
8010487a:	0f 84 80 00 00 00    	je     80104900 <mpinit+0x180>
80104880:	77 6e                	ja     801048f0 <mpinit+0x170>
80104882:	84 c9                	test   %cl,%cl
80104884:	74 3a                	je     801048c0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104886:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104889:	39 d0                	cmp    %edx,%eax
8010488b:	72 e7                	jb     80104874 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010488d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104890:	85 ff                	test   %edi,%edi
80104892:	0f 84 dd 00 00 00    	je     80104975 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80104898:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010489c:	74 15                	je     801048b3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010489e:	b8 70 00 00 00       	mov    $0x70,%eax
801048a3:	ba 22 00 00 00       	mov    $0x22,%edx
801048a8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801048a9:	ba 23 00 00 00       	mov    $0x23,%edx
801048ae:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801048af:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801048b2:	ee                   	out    %al,(%dx)
  }
}
801048b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048b6:	5b                   	pop    %ebx
801048b7:	5e                   	pop    %esi
801048b8:	5f                   	pop    %edi
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret
801048bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801048c0:	8b 0d 24 4a 11 80    	mov    0x80114a24,%ecx
801048c6:	83 f9 07             	cmp    $0x7,%ecx
801048c9:	7f 19                	jg     801048e4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801048cb:	69 f1 b8 00 00 00    	imul   $0xb8,%ecx,%esi
801048d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801048d5:	83 c1 01             	add    $0x1,%ecx
801048d8:	89 0d 24 4a 11 80    	mov    %ecx,0x80114a24
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801048de:	88 9e 40 4a 11 80    	mov    %bl,-0x7feeb5c0(%esi)
      p += sizeof(struct mpproc);
801048e4:	83 c0 14             	add    $0x14,%eax
      continue;
801048e7:	eb 87                	jmp    80104870 <mpinit+0xf0>
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801048f0:	83 e9 03             	sub    $0x3,%ecx
801048f3:	80 f9 01             	cmp    $0x1,%cl
801048f6:	76 8e                	jbe    80104886 <mpinit+0x106>
801048f8:	31 ff                	xor    %edi,%edi
801048fa:	e9 71 ff ff ff       	jmp    80104870 <mpinit+0xf0>
801048ff:	90                   	nop
      ioapicid = ioapic->apicno;
80104900:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80104904:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80104907:	88 0d 20 4a 11 80    	mov    %cl,0x80114a20
      continue;
8010490d:	e9 5e ff ff ff       	jmp    80104870 <mpinit+0xf0>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80104918:	83 ec 0c             	sub    $0xc,%esp
8010491b:	68 39 98 10 80       	push   $0x80109839
80104920:	e8 2b bc ff ff       	call   80100550 <panic>
80104925:	8d 76 00             	lea    0x0(%esi),%esi
{
80104928:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010492d:	eb 0b                	jmp    8010493a <mpinit+0x1ba>
8010492f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80104930:	89 f3                	mov    %esi,%ebx
80104932:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80104938:	74 de                	je     80104918 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010493a:	83 ec 04             	sub    $0x4,%esp
8010493d:	8d 73 10             	lea    0x10(%ebx),%esi
80104940:	6a 04                	push   $0x4
80104942:	68 2f 98 10 80       	push   $0x8010982f
80104947:	53                   	push   %ebx
80104948:	e8 03 1b 00 00       	call   80106450 <memcmp>
8010494d:	83 c4 10             	add    $0x10,%esp
80104950:	85 c0                	test   %eax,%eax
80104952:	75 dc                	jne    80104930 <mpinit+0x1b0>
80104954:	89 da                	mov    %ebx,%edx
80104956:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010495d:	00 
8010495e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80104960:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80104963:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80104966:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80104968:	39 d6                	cmp    %edx,%esi
8010496a:	75 f4                	jne    80104960 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010496c:	84 c0                	test   %al,%al
8010496e:	75 c0                	jne    80104930 <mpinit+0x1b0>
80104970:	e9 5b fe ff ff       	jmp    801047d0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80104975:	83 ec 0c             	sub    $0xc,%esp
80104978:	68 1c 9d 10 80       	push   $0x80109d1c
8010497d:	e8 ce bb ff ff       	call   80100550 <panic>
80104982:	66 90                	xchg   %ax,%ax
80104984:	66 90                	xchg   %ax,%ax
80104986:	66 90                	xchg   %ax,%ax
80104988:	66 90                	xchg   %ax,%ax
8010498a:	66 90                	xchg   %ax,%ax
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax

80104990 <picinit>:
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	ba 21 00 00 00       	mov    $0x21,%edx
8010499a:	ee                   	out    %al,(%dx)
8010499b:	ba a1 00 00 00       	mov    $0xa1,%edx
801049a0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801049a1:	c3                   	ret
801049a2:	66 90                	xchg   %ax,%ax
801049a4:	66 90                	xchg   %ax,%ax
801049a6:	66 90                	xchg   %ax,%ax
801049a8:	66 90                	xchg   %ax,%ax
801049aa:	66 90                	xchg   %ax,%ax
801049ac:	66 90                	xchg   %ax,%ax
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	53                   	push   %ebx
801049b6:	83 ec 0c             	sub    $0xc,%esp
801049b9:	8b 75 08             	mov    0x8(%ebp),%esi
801049bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801049bf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801049c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801049cb:	e8 20 da ff ff       	call   801023f0 <filealloc>
801049d0:	89 06                	mov    %eax,(%esi)
801049d2:	85 c0                	test   %eax,%eax
801049d4:	0f 84 a5 00 00 00    	je     80104a7f <pipealloc+0xcf>
801049da:	e8 11 da ff ff       	call   801023f0 <filealloc>
801049df:	89 07                	mov    %eax,(%edi)
801049e1:	85 c0                	test   %eax,%eax
801049e3:	0f 84 84 00 00 00    	je     80104a6d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801049e9:	e8 12 f2 ff ff       	call   80103c00 <kalloc>
801049ee:	89 c3                	mov    %eax,%ebx
801049f0:	85 c0                	test   %eax,%eax
801049f2:	0f 84 a0 00 00 00    	je     80104a98 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801049f8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801049ff:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80104a02:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80104a05:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104a0c:	00 00 00 
  p->nwrite = 0;
80104a0f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104a16:	00 00 00 
  p->nread = 0;
80104a19:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104a20:	00 00 00 
  initlock(&p->lock, "pipe");
80104a23:	68 51 98 10 80       	push   $0x80109851
80104a28:	50                   	push   %eax
80104a29:	e8 f2 16 00 00       	call   80106120 <initlock>
  (*f0)->type = FD_PIPE;
80104a2e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80104a30:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104a33:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104a39:	8b 06                	mov    (%esi),%eax
80104a3b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104a3f:	8b 06                	mov    (%esi),%eax
80104a41:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104a45:	8b 06                	mov    (%esi),%eax
80104a47:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104a4a:	8b 07                	mov    (%edi),%eax
80104a4c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104a52:	8b 07                	mov    (%edi),%eax
80104a54:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104a58:	8b 07                	mov    (%edi),%eax
80104a5a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104a5e:	8b 07                	mov    (%edi),%eax
80104a60:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80104a63:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80104a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a68:	5b                   	pop    %ebx
80104a69:	5e                   	pop    %esi
80104a6a:	5f                   	pop    %edi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret
  if(*f0)
80104a6d:	8b 06                	mov    (%esi),%eax
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	74 1e                	je     80104a91 <pipealloc+0xe1>
    fileclose(*f0);
80104a73:	83 ec 0c             	sub    $0xc,%esp
80104a76:	50                   	push   %eax
80104a77:	e8 34 da ff ff       	call   801024b0 <fileclose>
80104a7c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104a7f:	8b 07                	mov    (%edi),%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	74 0c                	je     80104a91 <pipealloc+0xe1>
    fileclose(*f1);
80104a85:	83 ec 0c             	sub    $0xc,%esp
80104a88:	50                   	push   %eax
80104a89:	e8 22 da ff ff       	call   801024b0 <fileclose>
80104a8e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a96:	eb cd                	jmp    80104a65 <pipealloc+0xb5>
  if(*f0)
80104a98:	8b 06                	mov    (%esi),%eax
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	75 d5                	jne    80104a73 <pipealloc+0xc3>
80104a9e:	eb df                	jmp    80104a7f <pipealloc+0xcf>

80104aa0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104aa8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	53                   	push   %ebx
80104aaf:	e8 5c 18 00 00       	call   80106310 <acquire>
  if(writable){
80104ab4:	83 c4 10             	add    $0x10,%esp
80104ab7:	85 f6                	test   %esi,%esi
80104ab9:	74 65                	je     80104b20 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80104ac4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80104acb:	00 00 00 
    wakeup(&p->nread);
80104ace:	50                   	push   %eax
80104acf:	e8 2c 10 00 00       	call   80105b00 <wakeup>
80104ad4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104ad7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80104add:	85 d2                	test   %edx,%edx
80104adf:	75 0a                	jne    80104aeb <pipeclose+0x4b>
80104ae1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104ae7:	85 c0                	test   %eax,%eax
80104ae9:	74 15                	je     80104b00 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80104aeb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af1:	5b                   	pop    %ebx
80104af2:	5e                   	pop    %esi
80104af3:	5d                   	pop    %ebp
    release(&p->lock);
80104af4:	e9 b7 17 00 00       	jmp    801062b0 <release>
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	53                   	push   %ebx
80104b04:	e8 a7 17 00 00       	call   801062b0 <release>
    kfree((char*)p);
80104b09:	83 c4 10             	add    $0x10,%esp
80104b0c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b12:	5b                   	pop    %ebx
80104b13:	5e                   	pop    %esi
80104b14:	5d                   	pop    %ebp
    kfree((char*)p);
80104b15:	e9 26 ef ff ff       	jmp    80103a40 <kfree>
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104b29:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104b30:	00 00 00 
    wakeup(&p->nwrite);
80104b33:	50                   	push   %eax
80104b34:	e8 c7 0f 00 00       	call   80105b00 <wakeup>
80104b39:	83 c4 10             	add    $0x10,%esp
80104b3c:	eb 99                	jmp    80104ad7 <pipeclose+0x37>
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 28             	sub    $0x28,%esp
80104b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b4c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80104b4f:	53                   	push   %ebx
80104b50:	e8 bb 17 00 00       	call   80106310 <acquire>
  for(i = 0; i < n; i++){
80104b55:	83 c4 10             	add    $0x10,%esp
80104b58:	85 ff                	test   %edi,%edi
80104b5a:	0f 8e ce 00 00 00    	jle    80104c2e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104b60:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80104b66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b69:	89 7d 10             	mov    %edi,0x10(%ebp)
80104b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104b6f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80104b72:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104b75:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104b7b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104b81:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104b87:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80104b8d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80104b90:	0f 85 b6 00 00 00    	jne    80104c4c <pipewrite+0x10c>
80104b96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104b99:	eb 3b                	jmp    80104bd6 <pipewrite+0x96>
80104b9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80104ba0:	e8 8b 04 00 00       	call   80105030 <myproc>
80104ba5:	8b 48 24             	mov    0x24(%eax),%ecx
80104ba8:	85 c9                	test   %ecx,%ecx
80104baa:	75 34                	jne    80104be0 <pipewrite+0xa0>
      wakeup(&p->nread);
80104bac:	83 ec 0c             	sub    $0xc,%esp
80104baf:	56                   	push   %esi
80104bb0:	e8 4b 0f 00 00       	call   80105b00 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104bb5:	58                   	pop    %eax
80104bb6:	5a                   	pop    %edx
80104bb7:	53                   	push   %ebx
80104bb8:	57                   	push   %edi
80104bb9:	e8 82 0e 00 00       	call   80105a40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104bbe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104bc4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	05 00 02 00 00       	add    $0x200,%eax
80104bd2:	39 c2                	cmp    %eax,%edx
80104bd4:	75 2a                	jne    80104c00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80104bd6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	75 c0                	jne    80104ba0 <pipewrite+0x60>
        release(&p->lock);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	53                   	push   %ebx
80104be4:	e8 c7 16 00 00       	call   801062b0 <release>
        return -1;
80104be9:	83 c4 10             	add    $0x10,%esp
80104bec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bf4:	5b                   	pop    %ebx
80104bf5:	5e                   	pop    %esi
80104bf6:	5f                   	pop    %edi
80104bf7:	5d                   	pop    %ebp
80104bf8:	c3                   	ret
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104c03:	8d 42 01             	lea    0x1(%edx),%eax
80104c06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
80104c0c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104c0f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80104c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104c18:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
80104c1c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c23:	39 c1                	cmp    %eax,%ecx
80104c25:	0f 85 50 ff ff ff    	jne    80104b7b <pipewrite+0x3b>
80104c2b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104c2e:	83 ec 0c             	sub    $0xc,%esp
80104c31:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104c37:	50                   	push   %eax
80104c38:	e8 c3 0e 00 00       	call   80105b00 <wakeup>
  release(&p->lock);
80104c3d:	89 1c 24             	mov    %ebx,(%esp)
80104c40:	e8 6b 16 00 00       	call   801062b0 <release>
  return n;
80104c45:	83 c4 10             	add    $0x10,%esp
80104c48:	89 f8                	mov    %edi,%eax
80104c4a:	eb a5                	jmp    80104bf1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c4f:	eb b2                	jmp    80104c03 <pipewrite+0xc3>
80104c51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c58:	00 
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c60 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	83 ec 18             	sub    $0x18,%esp
80104c69:	8b 75 08             	mov    0x8(%ebp),%esi
80104c6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104c6f:	56                   	push   %esi
80104c70:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104c76:	e8 95 16 00 00       	call   80106310 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104c7b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104c8a:	74 2f                	je     80104cbb <piperead+0x5b>
80104c8c:	eb 37                	jmp    80104cc5 <piperead+0x65>
80104c8e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104c90:	e8 9b 03 00 00       	call   80105030 <myproc>
80104c95:	8b 40 24             	mov    0x24(%eax),%eax
80104c98:	85 c0                	test   %eax,%eax
80104c9a:	0f 85 80 00 00 00    	jne    80104d20 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104ca0:	83 ec 08             	sub    $0x8,%esp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	e8 96 0d 00 00       	call   80105a40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104caa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104cb0:	83 c4 10             	add    $0x10,%esp
80104cb3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104cb9:	75 0a                	jne    80104cc5 <piperead+0x65>
80104cbb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80104cc1:	85 d2                	test   %edx,%edx
80104cc3:	75 cb                	jne    80104c90 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104cc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cc8:	31 db                	xor    %ebx,%ebx
80104cca:	85 c9                	test   %ecx,%ecx
80104ccc:	7f 26                	jg     80104cf4 <piperead+0x94>
80104cce:	eb 2c                	jmp    80104cfc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104cd0:	8d 48 01             	lea    0x1(%eax),%ecx
80104cd3:	25 ff 01 00 00       	and    $0x1ff,%eax
80104cd8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80104cde:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80104ce3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104ce6:	83 c3 01             	add    $0x1,%ebx
80104ce9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104cec:	74 0e                	je     80104cfc <piperead+0x9c>
80104cee:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80104cf4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104cfa:	75 d4                	jne    80104cd0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104d05:	50                   	push   %eax
80104d06:	e8 f5 0d 00 00       	call   80105b00 <wakeup>
  release(&p->lock);
80104d0b:	89 34 24             	mov    %esi,(%esp)
80104d0e:	e8 9d 15 00 00       	call   801062b0 <release>
  return i;
80104d13:	83 c4 10             	add    $0x10,%esp
}
80104d16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d19:	89 d8                	mov    %ebx,%eax
80104d1b:	5b                   	pop    %ebx
80104d1c:	5e                   	pop    %esi
80104d1d:	5f                   	pop    %edi
80104d1e:	5d                   	pop    %ebp
80104d1f:	c3                   	ret
      release(&p->lock);
80104d20:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104d23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104d28:	56                   	push   %esi
80104d29:	e8 82 15 00 00       	call   801062b0 <release>
      return -1;
80104d2e:	83 c4 10             	add    $0x10,%esp
}
80104d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d34:	89 d8                	mov    %ebx,%eax
80104d36:	5b                   	pop    %ebx
80104d37:	5e                   	pop    %esi
80104d38:	5f                   	pop    %edi
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret
80104d3b:	66 90                	xchg   %ax,%ax
80104d3d:	66 90                	xchg   %ax,%ax
80104d3f:	90                   	nop

80104d40 <choose_e_core_min_load>:

// انتخاب E-core با کمترین طول صف آماده
// فرض: با داشتن ptable.lock صدا زده می‌شود
static int
choose_e_core_min_load(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
  int best = -1;

  for(int i = 0; i < ncpu; i++){
80104d44:	8b 1d 24 4a 11 80    	mov    0x80114a24,%ebx
80104d4a:	85 db                	test   %ebx,%ebx
80104d4c:	7e 5a                	jle    80104da8 <choose_e_core_min_load+0x68>
80104d4e:	31 d2                	xor    %edx,%edx
  int best = -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d55:	eb 21                	jmp    80104d78 <choose_e_core_min_load+0x38>
80104d57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d5e:	00 
80104d5f:	90                   	nop
    // فقط E-Core ها
    if(cpus[i].core_type != 0)
      continue;

    if(best < 0 || ptable.rq_len[i] < ptable.rq_len[best])
      best = i;
80104d60:	8b 0c 85 94 75 11 80 	mov    -0x7fee8a6c(,%eax,4),%ecx
80104d67:	39 0c 95 94 75 11 80 	cmp    %ecx,-0x7fee8a6c(,%edx,4)
80104d6e:	0f 4c c2             	cmovl  %edx,%eax
  for(int i = 0; i < ncpu; i++){
80104d71:	83 c2 01             	add    $0x1,%edx
80104d74:	39 da                	cmp    %ebx,%edx
80104d76:	74 1d                	je     80104d95 <choose_e_core_min_load+0x55>
    if(cpus[i].core_type != 0)
80104d78:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80104d7e:	8b 89 f0 4a 11 80    	mov    -0x7feeb510(%ecx),%ecx
80104d84:	85 c9                	test   %ecx,%ecx
80104d86:	75 e9                	jne    80104d71 <choose_e_core_min_load+0x31>
    if(best < 0 || ptable.rq_len[i] < ptable.rq_len[best])
80104d88:	85 c0                	test   %eax,%eax
80104d8a:	79 d4                	jns    80104d60 <choose_e_core_min_load+0x20>
      best = i;
80104d8c:	89 d0                	mov    %edx,%eax
  for(int i = 0; i < ncpu; i++){
80104d8e:	83 c2 01             	add    $0x1,%edx
80104d91:	39 da                	cmp    %ebx,%edx
80104d93:	75 e3                	jne    80104d78 <choose_e_core_min_load+0x38>
  }

  // اگر هنوز هیچ core_type تنظیم نشده (اوایل boot)،
  // همه core_type ها پیش‌فرض 0 هستند، پس حلقه بالا همه را E فرض می‌کند.
  if(best < 0)
80104d95:	31 d2                	xor    %edx,%edx
80104d97:	85 c0                	test   %eax,%eax
    best = 0;

  return best;
}
80104d99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d9c:	c9                   	leave
  if(best < 0)
80104d9d:	0f 48 c2             	cmovs  %edx,%eax
}
80104da0:	c3                   	ret
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  for(int i = 0; i < ncpu; i++){
80104dab:	31 c0                	xor    %eax,%eax
}
80104dad:	c9                   	leave
80104dae:	c3                   	ret
80104daf:	90                   	nop

80104db0 <rq_enqueue>:



static void
rq_enqueue(int cpu, struct proc *p)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
  if(cpu < 0 || cpu >= ncpu)
80104db4:	85 c0                	test   %eax,%eax
80104db6:	78 48                	js     80104e00 <rq_enqueue+0x50>
    cpu = 0;
80104db8:	31 c9                	xor    %ecx,%ecx
80104dba:	39 05 24 4a 11 80    	cmp    %eax,0x80114a24
80104dc0:	0f 4e c1             	cmovle %ecx,%eax

  p->next = 0;
80104dc3:	c7 82 8c 00 00 00 00 	movl   $0x0,0x8c(%edx)
80104dca:	00 00 00 
  if(ptable.rq_tail[cpu]){
80104dcd:	8d 88 54 09 00 00    	lea    0x954(%eax),%ecx
80104dd3:	8b 1c 8d 24 50 11 80 	mov    -0x7feeafdc(,%ecx,4),%ebx
80104dda:	85 db                	test   %ebx,%ebx
80104ddc:	74 2a                	je     80104e08 <rq_enqueue+0x58>
    ptable.rq_tail[cpu]->next = p;
80104dde:	89 93 8c 00 00 00    	mov    %edx,0x8c(%ebx)
    ptable.rq_tail[cpu] = p;
80104de4:	89 14 8d 24 50 11 80 	mov    %edx,-0x7feeafdc(,%ecx,4)
    ptable.rq_tail[cpu] = p;
  }

  p->queue_id = cpu;
  ptable.rq_len[cpu]++;
}
80104deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  p->queue_id = cpu;
80104dee:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  ptable.rq_len[cpu]++;
80104df4:	83 04 85 94 75 11 80 	addl   $0x1,-0x7fee8a6c(,%eax,4)
80104dfb:	01 
}
80104dfc:	c9                   	leave
80104dfd:	c3                   	ret
80104dfe:	66 90                	xchg   %ax,%ax
    cpu = 0;
80104e00:	31 c0                	xor    %eax,%eax
80104e02:	eb bf                	jmp    80104dc3 <rq_enqueue+0x13>
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ptable.rq_head[cpu] = p;
80104e08:	89 14 85 54 75 11 80 	mov    %edx,-0x7fee8aac(,%eax,4)
    ptable.rq_tail[cpu] = p;
80104e0f:	eb d3                	jmp    80104de4 <rq_enqueue+0x34>
80104e11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e18:	00 
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e20 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e24:	bb 54 50 11 80       	mov    $0x80115054,%ebx
{
80104e29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e2c:	68 20 50 11 80       	push   $0x80115020
80104e31:	e8 da 14 00 00       	call   80106310 <acquire>
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	eb 17                	jmp    80104e52 <allocproc+0x32>
80104e3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e40:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104e46:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80104e4c:	0f 84 be 00 00 00    	je     80104f10 <allocproc+0xf0>
    if(p->state == UNUSED)
80104e52:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e55:	85 c0                	test   %eax,%eax
80104e57:	75 e7                	jne    80104e40 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104e59:	a1 04 d0 10 80       	mov    0x8010d004,%eax
  acquire(&tickslock);
80104e5e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104e61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104e68:	89 43 10             	mov    %eax,0x10(%ebx)
80104e6b:	8d 50 01             	lea    0x1(%eax),%edx
  acquire(&tickslock);
80104e6e:	68 e0 75 11 80       	push   $0x801175e0
  p->pid = nextpid++;
80104e73:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
  acquire(&tickslock);
80104e79:	e8 92 14 00 00       	call   80106310 <acquire>
  p->creation_time = ticks;   // زمان ایجاد پردازه بر حسب tick
80104e7e:	a1 c0 75 11 80       	mov    0x801175c0,%eax
80104e83:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  release(&tickslock);
80104e89:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80104e90:	e8 1b 14 00 00       	call   801062b0 <release>

  release(&ptable.lock);
80104e95:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
80104e9c:	e8 0f 14 00 00       	call   801062b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104ea1:	e8 5a ed ff ff       	call   80103c00 <kalloc>
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	89 43 08             	mov    %eax,0x8(%ebx)
80104eac:	85 c0                	test   %eax,%eax
80104eae:	74 79                	je     80104f29 <allocproc+0x109>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104eb0:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104eb6:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104eb9:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104ebe:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104ec1:	c7 40 14 90 7c 10 80 	movl   $0x80107c90,0x14(%eax)
  p->context = (struct context*)sp;
80104ec8:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104ecb:	6a 14                	push   $0x14
80104ecd:	6a 00                	push   $0x0
80104ecf:	50                   	push   %eax
80104ed0:	e8 3b 15 00 00       	call   80106410 <memset>
  p->context->eip = (uint)forkret;
80104ed5:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->tick_count = 0;
  p->total_tick_count = 0;

  p->next = 0;
  
  return p;
80104ed8:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104edb:	c7 40 10 40 4f 10 80 	movl   $0x80104f40,0x10(%eax)
}
80104ee2:	89 d8                	mov    %ebx,%eax
  p->priority = PRIO_DEFAULT;
80104ee4:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->tick_count = 0;
80104eeb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104ef2:	00 00 00 
  p->total_tick_count = 0;
80104ef5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104efc:	00 00 00 
  p->next = 0;
80104eff:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104f06:	00 00 00 
}
80104f09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f0c:	c9                   	leave
80104f0d:	c3                   	ret
80104f0e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80104f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104f13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104f15:	68 20 50 11 80       	push   $0x80115020
80104f1a:	e8 91 13 00 00       	call   801062b0 <release>
  return 0;
80104f1f:	83 c4 10             	add    $0x10,%esp
}
80104f22:	89 d8                	mov    %ebx,%eax
80104f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f27:	c9                   	leave
80104f28:	c3                   	ret
    p->state = UNUSED;
80104f29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104f30:	31 db                	xor    %ebx,%ebx
80104f32:	eb ee                	jmp    80104f22 <allocproc+0x102>
80104f34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f3b:	00 
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104f46:	68 20 50 11 80       	push   $0x80115020
80104f4b:	e8 60 13 00 00       	call   801062b0 <release>

  if (first){
80104f50:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80104f55:	83 c4 10             	add    $0x10,%esp
80104f58:	85 c0                	test   %eax,%eax
80104f5a:	75 04                	jne    80104f60 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104f5c:	c9                   	leave
80104f5d:	c3                   	ret
80104f5e:	66 90                	xchg   %ax,%ax
    first = 0;
80104f60:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
80104f67:	00 00 00 
    iinit(ROOTDEV);
80104f6a:	83 ec 0c             	sub    $0xc,%esp
80104f6d:	6a 01                	push   $0x1
80104f6f:	e8 ac db ff ff       	call   80102b20 <iinit>
    initlog(ROOTDEV);
80104f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f7b:	e8 c0 f2 ff ff       	call   80104240 <initlog>
}
80104f80:	83 c4 10             	add    $0x10,%esp
80104f83:	c9                   	leave
80104f84:	c3                   	ret
80104f85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f8c:	00 
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <pinit>:
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104f96:	68 56 98 10 80       	push   $0x80109856
80104f9b:	68 20 50 11 80       	push   $0x80115020
80104fa0:	e8 7b 11 00 00       	call   80106120 <initlock>
}
80104fa5:	83 c4 10             	add    $0x10,%esp
80104fa8:	c9                   	leave
80104fa9:	c3                   	ret
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fb0 <mycpu>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fb5:	9c                   	pushf
80104fb6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fb7:	f6 c4 02             	test   $0x2,%ah
80104fba:	75 46                	jne    80105002 <mycpu+0x52>
  apicid = lapicid();
80104fbc:	e8 af ee ff ff       	call   80103e70 <lapicid>
  for (i = 0; i < ncpu; ++i){
80104fc1:	8b 35 24 4a 11 80    	mov    0x80114a24,%esi
80104fc7:	85 f6                	test   %esi,%esi
80104fc9:	7e 2a                	jle    80104ff5 <mycpu+0x45>
80104fcb:	31 d2                	xor    %edx,%edx
80104fcd:	eb 08                	jmp    80104fd7 <mycpu+0x27>
80104fcf:	90                   	nop
80104fd0:	83 c2 01             	add    $0x1,%edx
80104fd3:	39 f2                	cmp    %esi,%edx
80104fd5:	74 1e                	je     80104ff5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104fd7:	69 ca b8 00 00 00    	imul   $0xb8,%edx,%ecx
80104fdd:	0f b6 99 40 4a 11 80 	movzbl -0x7feeb5c0(%ecx),%ebx
80104fe4:	39 c3                	cmp    %eax,%ebx
80104fe6:	75 e8                	jne    80104fd0 <mycpu+0x20>
}
80104fe8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104feb:	8d 81 40 4a 11 80    	lea    -0x7feeb5c0(%ecx),%eax
}
80104ff1:	5b                   	pop    %ebx
80104ff2:	5e                   	pop    %esi
80104ff3:	5d                   	pop    %ebp
80104ff4:	c3                   	ret
  panic("unknown apicid\n");
80104ff5:	83 ec 0c             	sub    $0xc,%esp
80104ff8:	68 5d 98 10 80       	push   $0x8010985d
80104ffd:	e8 4e b5 ff ff       	call   80100550 <panic>
    panic("mycpu called with interrupts enabled\n");
80105002:	83 ec 0c             	sub    $0xc,%esp
80105005:	68 3c 9d 10 80       	push   $0x80109d3c
8010500a:	e8 41 b5 ff ff       	call   80100550 <panic>
8010500f:	90                   	nop

80105010 <cpuid>:
cpuid(){
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80105016:	e8 95 ff ff ff       	call   80104fb0 <mycpu>
}
8010501b:	c9                   	leave
  return mycpu()-cpus;
8010501c:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
80105021:	c1 f8 03             	sar    $0x3,%eax
80105024:	69 c0 a7 37 bd e9    	imul   $0xe9bd37a7,%eax,%eax
}
8010502a:	c3                   	ret
8010502b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105030 <myproc>:
myproc(void){
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80105037:	e8 84 11 00 00       	call   801061c0 <pushcli>
  c = mycpu();
8010503c:	e8 6f ff ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
80105041:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105047:	e8 c4 11 00 00       	call   80106210 <popcli>
}
8010504c:	89 d8                	mov    %ebx,%eax
8010504e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105051:	c9                   	leave
80105052:	c3                   	ret
80105053:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010505a:	00 
8010505b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105060 <userinit>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	53                   	push   %ebx
80105064:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80105067:	e8 b4 fd ff ff       	call   80104e20 <allocproc>
8010506c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010506e:	a3 b4 75 11 80       	mov    %eax,0x801175b4
  if((p->pgdir = setupkvm()) == 0)
80105073:	e8 48 42 00 00       	call   801092c0 <setupkvm>
80105078:	89 43 04             	mov    %eax,0x4(%ebx)
8010507b:	85 c0                	test   %eax,%eax
8010507d:	0f 84 c9 00 00 00    	je     8010514c <userinit+0xec>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80105083:	83 ec 04             	sub    $0x4,%esp
80105086:	68 2c 00 00 00       	push   $0x2c
8010508b:	68 60 d4 10 80       	push   $0x8010d460
80105090:	50                   	push   %eax
80105091:	e8 0a 3f 00 00       	call   80108fa0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80105096:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80105099:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010509f:	6a 4c                	push   $0x4c
801050a1:	6a 00                	push   $0x0
801050a3:	ff 73 18             	push   0x18(%ebx)
801050a6:	e8 65 13 00 00       	call   80106410 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801050ab:	8b 43 18             	mov    0x18(%ebx),%eax
801050ae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801050b3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801050b6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801050bb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801050bf:	8b 43 18             	mov    0x18(%ebx),%eax
801050c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801050c6:	8b 43 18             	mov    0x18(%ebx),%eax
801050c9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801050cd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801050d1:	8b 43 18             	mov    0x18(%ebx),%eax
801050d4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801050d8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801050dc:	8b 43 18             	mov    0x18(%ebx),%eax
801050df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801050e6:	8b 43 18             	mov    0x18(%ebx),%eax
801050e9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801050f0:	8b 43 18             	mov    0x18(%ebx),%eax
801050f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801050fa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801050fd:	6a 10                	push   $0x10
801050ff:	68 86 98 10 80       	push   $0x80109886
80105104:	50                   	push   %eax
80105105:	e8 b6 14 00 00       	call   801065c0 <safestrcpy>
  p->cwd = namei("/");
8010510a:	c7 04 24 8f 98 10 80 	movl   $0x8010988f,(%esp)
80105111:	e8 0a e5 ff ff       	call   80103620 <namei>
80105116:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80105119:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
80105120:	e8 eb 11 00 00       	call   80106310 <acquire>
  p->state = RUNNABLE;
80105125:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  return choose_e_core_min_load();
8010512c:	e8 0f fc ff ff       	call   80104d40 <choose_e_core_min_load>
  rq_enqueue(cid, p);
80105131:	89 da                	mov    %ebx,%edx
80105133:	e8 78 fc ff ff       	call   80104db0 <rq_enqueue>
  release(&ptable.lock);
80105138:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
8010513f:	e8 6c 11 00 00       	call   801062b0 <release>
}
80105144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105147:	83 c4 10             	add    $0x10,%esp
8010514a:	c9                   	leave
8010514b:	c3                   	ret
    panic("userinit: out of memory?");
8010514c:	83 ec 0c             	sub    $0xc,%esp
8010514f:	68 6d 98 10 80       	push   $0x8010986d
80105154:	e8 f7 b3 ff ff       	call   80100550 <panic>
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105160 <growproc>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
80105165:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105168:	e8 53 10 00 00       	call   801061c0 <pushcli>
  c = mycpu();
8010516d:	e8 3e fe ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
80105172:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105178:	e8 93 10 00 00       	call   80106210 <popcli>
  sz = curproc->sz;
8010517d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010517f:	85 f6                	test   %esi,%esi
80105181:	7f 1d                	jg     801051a0 <growproc+0x40>
  } else if(n < 0){
80105183:	75 3b                	jne    801051c0 <growproc+0x60>
  switchuvm(curproc);
80105185:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80105188:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010518a:	53                   	push   %ebx
8010518b:	e8 00 3d 00 00       	call   80108e90 <switchuvm>
  return 0;
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	31 c0                	xor    %eax,%eax
}
80105195:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105198:	5b                   	pop    %ebx
80105199:	5e                   	pop    %esi
8010519a:	5d                   	pop    %ebp
8010519b:	c3                   	ret
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801051a0:	83 ec 04             	sub    $0x4,%esp
801051a3:	01 c6                	add    %eax,%esi
801051a5:	56                   	push   %esi
801051a6:	50                   	push   %eax
801051a7:	ff 73 04             	push   0x4(%ebx)
801051aa:	e8 41 3f 00 00       	call   801090f0 <allocuvm>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	75 cf                	jne    80105185 <growproc+0x25>
      return -1;
801051b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bb:	eb d8                	jmp    80105195 <growproc+0x35>
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801051c0:	83 ec 04             	sub    $0x4,%esp
801051c3:	01 c6                	add    %eax,%esi
801051c5:	56                   	push   %esi
801051c6:	50                   	push   %eax
801051c7:	ff 73 04             	push   0x4(%ebx)
801051ca:	e8 41 40 00 00       	call   80109210 <deallocuvm>
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	85 c0                	test   %eax,%eax
801051d4:	75 af                	jne    80105185 <growproc+0x25>
801051d6:	eb de                	jmp    801051b6 <growproc+0x56>
801051d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051df:	00 

801051e0 <fork>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
801051e5:	53                   	push   %ebx
801051e6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801051e9:	e8 d2 0f 00 00       	call   801061c0 <pushcli>
  c = mycpu();
801051ee:	e8 bd fd ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
801051f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801051f9:	e8 12 10 00 00       	call   80106210 <popcli>
  if((np = allocproc()) == 0){
801051fe:	e8 1d fc ff ff       	call   80104e20 <allocproc>
80105203:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105206:	85 c0                	test   %eax,%eax
80105208:	0f 84 f2 00 00 00    	je     80105300 <fork+0x120>
8010520e:	89 c7                	mov    %eax,%edi
  np->priority = curproc->priority;
80105210:	8b 43 7c             	mov    0x7c(%ebx),%eax
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80105213:	83 ec 08             	sub    $0x8,%esp
  np->priority = curproc->priority;
80105216:	89 47 7c             	mov    %eax,0x7c(%edi)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80105219:	ff 33                	push   (%ebx)
8010521b:	ff 73 04             	push   0x4(%ebx)
8010521e:	e8 8d 41 00 00       	call   801093b0 <copyuvm>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	89 47 04             	mov    %eax,0x4(%edi)
80105229:	85 c0                	test   %eax,%eax
8010522b:	0f 84 b0 00 00 00    	je     801052e1 <fork+0x101>
  np->sz = curproc->sz;
80105231:	8b 03                	mov    (%ebx),%eax
80105233:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105236:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80105238:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
8010523b:	89 c8                	mov    %ecx,%eax
8010523d:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80105240:	b9 13 00 00 00       	mov    $0x13,%ecx
80105245:	8b 73 18             	mov    0x18(%ebx),%esi
80105248:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
8010524a:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010524c:	8b 40 18             	mov    0x18(%eax),%eax
8010524f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80105256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010525d:	00 
8010525e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80105260:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105264:	85 c0                	test   %eax,%eax
80105266:	74 13                	je     8010527b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105268:	83 ec 0c             	sub    $0xc,%esp
8010526b:	50                   	push   %eax
8010526c:	e8 ef d1 ff ff       	call   80102460 <filedup>
80105271:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010527b:	83 c6 01             	add    $0x1,%esi
8010527e:	83 fe 10             	cmp    $0x10,%esi
80105281:	75 dd                	jne    80105260 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105289:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010528c:	e8 7f da ff ff       	call   80102d10 <idup>
80105291:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105294:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105297:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010529a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010529d:	6a 10                	push   $0x10
8010529f:	53                   	push   %ebx
801052a0:	50                   	push   %eax
801052a1:	e8 1a 13 00 00       	call   801065c0 <safestrcpy>
  pid = np->pid;
801052a6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801052a9:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
801052b0:	e8 5b 10 00 00       	call   80106310 <acquire>
  np->state = RUNNABLE;
801052b5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  return choose_e_core_min_load();
801052bc:	e8 7f fa ff ff       	call   80104d40 <choose_e_core_min_load>
  rq_enqueue(cid, np);
801052c1:	89 fa                	mov    %edi,%edx
801052c3:	e8 e8 fa ff ff       	call   80104db0 <rq_enqueue>
  release(&ptable.lock);
801052c8:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
801052cf:	e8 dc 0f 00 00       	call   801062b0 <release>
  return pid;
801052d4:	83 c4 10             	add    $0x10,%esp
}
801052d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052da:	89 d8                	mov    %ebx,%eax
801052dc:	5b                   	pop    %ebx
801052dd:	5e                   	pop    %esi
801052de:	5f                   	pop    %edi
801052df:	5d                   	pop    %ebp
801052e0:	c3                   	ret
    kfree(np->kstack);
801052e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	ff 73 08             	push   0x8(%ebx)
801052ea:	e8 51 e7 ff ff       	call   80103a40 <kfree>
    np->kstack = 0;
801052ef:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801052f6:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801052f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105300:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105305:	eb d0                	jmp    801052d7 <fork+0xf7>
80105307:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010530e:	00 
8010530f:	90                   	nop

80105310 <scheduler>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
80105316:	83 ec 3c             	sub    $0x3c,%esp
  struct cpu *c = mycpu();
80105319:	e8 92 fc ff ff       	call   80104fb0 <mycpu>
  c->proc = 0;
8010531e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105325:	00 00 00 
  struct cpu *c = mycpu();
80105328:	89 c7                	mov    %eax,%edi
  if (c->apicid % 2 == 0)
8010532a:	0f b6 00             	movzbl (%eax),%eax
  c->last_balance = 0;
8010532d:	c7 87 b4 00 00 00 00 	movl   $0x0,0xb4(%edi)
80105334:	00 00 00 
80105337:	83 e0 01             	and    $0x1,%eax
8010533a:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
  int cid = c - cpus;
80105340:	89 f8                	mov    %edi,%eax
80105342:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
80105347:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010534a:	c1 f8 03             	sar    $0x3,%eax
8010534d:	69 c0 a7 37 bd e9    	imul   $0xe9bd37a7,%eax,%eax
80105353:	8d 98 5c 09 00 00    	lea    0x95c(%eax),%ebx
80105359:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010535c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
8010535f:	8d 98 4c 09 00 00    	lea    0x94c(%eax),%ebx
80105365:	05 54 09 00 00       	add    $0x954,%eax
8010536a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010536d:	8d 47 04             	lea    0x4(%edi),%eax
80105370:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80105373:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105376:	e9 c4 00 00 00       	jmp    8010543f <scheduler+0x12f>
8010537b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    acquire(&ptable.lock);
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	68 20 50 11 80       	push   $0x80115020
80105388:	e8 83 0f 00 00       	call   80106310 <acquire>
    if (c->core_type == 0){
8010538d:	8b 9f b0 00 00 00    	mov    0xb0(%edi),%ebx
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 db                	test   %ebx,%ebx
80105398:	0f 85 e2 00 00 00    	jne    80105480 <scheduler+0x170>
      if(now - c->last_balance >= BALANCE_INTERVAL_TICKS){
8010539e:	89 f0                	mov    %esi,%eax
801053a0:	2b 87 b4 00 00 00    	sub    0xb4(%edi),%eax
801053a6:	83 f8 04             	cmp    $0x4,%eax
801053a9:	0f 87 71 01 00 00    	ja     80105520 <scheduler+0x210>
  if(cpu < 0 || cpu >= ncpu)
801053af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801053b2:	85 c9                	test   %ecx,%ecx
801053b4:	78 0c                	js     801053c2 <scheduler+0xb2>
801053b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
801053b9:	3b 05 24 4a 11 80    	cmp    0x80114a24,%eax
801053bf:	0f 4c d8             	cmovl  %eax,%ebx
  struct proc *p = ptable.rq_head[cpu];
801053c2:	8d 83 4c 09 00 00    	lea    0x94c(%ebx),%eax
801053c8:	8b 34 85 24 50 11 80 	mov    -0x7feeafdc(,%eax,4),%esi
  if(p){
801053cf:	85 f6                	test   %esi,%esi
801053d1:	74 5c                	je     8010542f <scheduler+0x11f>
    ptable.rq_head[cpu] = p->next;
801053d3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801053d9:	89 14 85 24 50 11 80 	mov    %edx,-0x7feeafdc(,%eax,4)
    if(ptable.rq_head[cpu] == 0)
801053e0:	85 d2                	test   %edx,%edx
801053e2:	0f 84 38 02 00 00    	je     80105620 <scheduler+0x310>
    p->next = 0;
801053e8:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801053ef:	00 00 00 
    ptable.rq_len[cpu]--;
801053f2:	83 2c 9d 94 75 11 80 	subl   $0x1,-0x7fee8a6c(,%ebx,4)
801053f9:	01 
      switchuvm(p);
801053fa:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801053fd:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
      switchuvm(p);
80105403:	56                   	push   %esi
80105404:	e8 87 3a 00 00       	call   80108e90 <switchuvm>
      p->state = RUNNING;
80105409:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
      swtch(&(c->scheduler), p->context);
80105410:	58                   	pop    %eax
80105411:	5a                   	pop    %edx
80105412:	ff 76 1c             	push   0x1c(%esi)
80105415:	ff 75 dc             	push   -0x24(%ebp)
80105418:	e8 fe 11 00 00       	call   8010661b <swtch>
      switchkvm();
8010541d:	e8 5e 3a 00 00       	call   80108e80 <switchkvm>
      c->proc = 0;
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
8010542c:	00 00 00 
    release(&ptable.lock);
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	68 20 50 11 80       	push   $0x80115020
80105437:	e8 74 0e 00 00       	call   801062b0 <release>
  for(;;){
8010543c:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
8010543f:	fb                   	sti
    if(c->core_type == 0){
80105440:	8b 8f b0 00 00 00    	mov    0xb0(%edi),%ecx
    uint now = 0;
80105446:	31 f6                	xor    %esi,%esi
    if(c->core_type == 0){
80105448:	85 c9                	test   %ecx,%ecx
8010544a:	0f 85 30 ff ff ff    	jne    80105380 <scheduler+0x70>
      acquire(&tickslock);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	68 e0 75 11 80       	push   $0x801175e0
80105458:	e8 b3 0e 00 00       	call   80106310 <acquire>
      release(&tickslock);
8010545d:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
      now = ticks;
80105464:	8b 35 c0 75 11 80    	mov    0x801175c0,%esi
      release(&tickslock);
8010546a:	e8 41 0e 00 00       	call   801062b0 <release>
8010546f:	83 c4 10             	add    $0x10,%esp
80105472:	e9 09 ff ff ff       	jmp    80105380 <scheduler+0x70>
80105477:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010547e:	00 
8010547f:	90                   	nop
      struct proc *cur = ptable.rq_head[cid];
80105480:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105483:	8b 04 85 24 50 11 80 	mov    -0x7feeafdc(,%eax,4),%eax
      while(cur){
8010548a:	85 c0                	test   %eax,%eax
8010548c:	74 a1                	je     8010542f <scheduler+0x11f>
      struct proc *prev = 0;
8010548e:	31 c9                	xor    %ecx,%ecx
      struct proc *best_prev = 0;
80105490:	31 db                	xor    %ebx,%ebx
      struct proc *best = 0;
80105492:	31 f6                	xor    %esi,%esi
80105494:	eb 18                	jmp    801054ae <scheduler+0x19e>
80105496:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010549d:	00 
8010549e:	66 90                	xchg   %ax,%ax
        cur = cur->next;
801054a0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
      while(cur){
801054a6:	89 c1                	mov    %eax,%ecx
801054a8:	85 d2                	test   %edx,%edx
801054aa:	74 2a                	je     801054d6 <scheduler+0x1c6>
801054ac:	89 d0                	mov    %edx,%eax
        if(cur->state == RUNNABLE &&
801054ae:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801054b2:	75 ec                	jne    801054a0 <scheduler+0x190>
801054b4:	85 f6                	test   %esi,%esi
801054b6:	74 0e                	je     801054c6 <scheduler+0x1b6>
           (best == 0 || cur->creation_time < best->creation_time)){
801054b8:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
801054be:	39 90 88 00 00 00    	cmp    %edx,0x88(%eax)
801054c4:	73 da                	jae    801054a0 <scheduler+0x190>
        cur = cur->next;
801054c6:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
          best_prev = prev;
801054cc:	89 cb                	mov    %ecx,%ebx
          best = cur;
801054ce:	89 c6                	mov    %eax,%esi
      while(cur){
801054d0:	89 c1                	mov    %eax,%ecx
801054d2:	85 d2                	test   %edx,%edx
801054d4:	75 d6                	jne    801054ac <scheduler+0x19c>
      if(p){
801054d6:	85 f6                	test   %esi,%esi
801054d8:	0f 84 51 ff ff ff    	je     8010542f <scheduler+0x11f>
          best_prev->next = best->next;
801054de:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
        if(best_prev)
801054e4:	85 db                	test   %ebx,%ebx
801054e6:	0f 84 54 01 00 00    	je     80105640 <scheduler+0x330>
          best_prev->next = best->next;
801054ec:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
        if(ptable.rq_tail[cid] == best)
801054f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801054f5:	39 34 85 24 50 11 80 	cmp    %esi,-0x7feeafdc(,%eax,4)
801054fc:	0f 84 2e 01 00 00    	je     80105630 <scheduler+0x320>
        p->next = 0;
80105502:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80105509:	00 00 00 
        ptable.rq_len[cid]--;
8010550c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010550f:	83 2c 85 24 50 11 80 	subl   $0x1,-0x7feeafdc(,%eax,4)
80105516:	01 
    if(p != 0){
80105517:	e9 de fe ff ff       	jmp    801053fa <scheduler+0xea>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < ncpu; i++){
80105520:	8b 0d 24 4a 11 80    	mov    0x80114a24,%ecx
80105526:	85 c9                	test   %ecx,%ecx
80105528:	0f 8e df 00 00 00    	jle    8010560d <scheduler+0x2fd>
  int p_id = -1;
8010552e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80105535:	ba f0 4a 11 80       	mov    $0x80114af0,%edx
  for(i = 0; i < ncpu; i++){
8010553a:	31 c0                	xor    %eax,%eax
  int min_len = 1000000;
8010553c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
8010553f:	89 cb                	mov    %ecx,%ebx
80105541:	89 75 c8             	mov    %esi,-0x38(%ebp)
80105544:	be 40 42 0f 00       	mov    $0xf4240,%esi
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpus[i].core_type != 1)
80105550:	83 3a 01             	cmpl   $0x1,(%edx)
80105553:	75 10                	jne    80105565 <scheduler+0x255>
    if(ptable.rq_len[i] < min_len){
80105555:	8b 0c 85 94 75 11 80 	mov    -0x7fee8a6c(,%eax,4),%ecx
8010555c:	39 f1                	cmp    %esi,%ecx
8010555e:	7d 05                	jge    80105565 <scheduler+0x255>
      p_id = i;
80105560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      min_len = ptable.rq_len[i];
80105563:	89 ce                	mov    %ecx,%esi
  for(i = 0; i < ncpu; i++){
80105565:	83 c0 01             	add    $0x1,%eax
80105568:	81 c2 b8 00 00 00    	add    $0xb8,%edx
8010556e:	39 c3                	cmp    %eax,%ebx
80105570:	75 de                	jne    80105550 <scheduler+0x240>
  if(p_id < 0)
80105572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105575:	89 f0                	mov    %esi,%eax
80105577:	8b 5d cc             	mov    -0x34(%ebp),%ebx
8010557a:	8b 75 c8             	mov    -0x38(%ebp),%esi
8010557d:	85 d2                	test   %edx,%edx
8010557f:	0f 88 88 00 00 00    	js     8010560d <scheduler+0x2fd>
  if(!(e_len >= min_len + 3))
80105585:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80105588:	83 c0 02             	add    $0x2,%eax
8010558b:	39 04 8d 24 50 11 80 	cmp    %eax,-0x7feeafdc(,%ecx,4)
80105592:	7e 79                	jle    8010560d <scheduler+0x2fd>
  struct proc *cur = ptable.rq_head[e_id];
80105594:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105597:	8b 14 85 24 50 11 80 	mov    -0x7feeafdc(,%eax,4),%edx
  while(cur){
8010559e:	85 d2                	test   %edx,%edx
801055a0:	74 6b                	je     8010560d <scheduler+0x2fd>
  struct proc *prev = 0;
801055a2:	31 c9                	xor    %ecx,%ecx
801055a4:	eb 18                	jmp    801055be <scheduler+0x2ae>
801055a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055ad:	00 
801055ae:	66 90                	xchg   %ax,%ax
    cur = cur->next;
801055b0:	8b 82 8c 00 00 00    	mov    0x8c(%edx),%eax
  while(cur){
801055b6:	89 d1                	mov    %edx,%ecx
801055b8:	85 c0                	test   %eax,%eax
801055ba:	74 51                	je     8010560d <scheduler+0x2fd>
801055bc:	89 c2                	mov    %eax,%edx
    if(cur->state == RUNNABLE && cur->pid > 2)
801055be:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801055c2:	75 ec                	jne    801055b0 <scheduler+0x2a0>
801055c4:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
801055c8:	7e e6                	jle    801055b0 <scheduler+0x2a0>
    prev->next = cur->next;
801055ca:	89 4d cc             	mov    %ecx,-0x34(%ebp)
801055cd:	8b 82 8c 00 00 00    	mov    0x8c(%edx),%eax
  if(prev)
801055d3:	85 c9                	test   %ecx,%ecx
801055d5:	0f 84 81 00 00 00    	je     8010565c <scheduler+0x34c>
    prev->next = cur->next;
801055db:	8b 4d cc             	mov    -0x34(%ebp),%ecx
801055de:	89 81 8c 00 00 00    	mov    %eax,0x8c(%ecx)
  if(ptable.rq_tail[e_id] == cur)
801055e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801055e7:	39 14 85 24 50 11 80 	cmp    %edx,-0x7feeafdc(,%eax,4)
801055ee:	74 60                	je     80105650 <scheduler+0x340>
  cur->next = 0;
801055f0:	c7 82 8c 00 00 00 00 	movl   $0x0,0x8c(%edx)
801055f7:	00 00 00 
  ptable.rq_len[e_id]--;
801055fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801055fd:	83 2c 85 24 50 11 80 	subl   $0x1,-0x7feeafdc(,%eax,4)
80105604:	01 
  rq_enqueue(p_id, cur);
80105605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105608:	e8 a3 f7 ff ff       	call   80104db0 <rq_enqueue>
        c->last_balance = now;
8010560d:	89 b7 b4 00 00 00    	mov    %esi,0xb4(%edi)
80105613:	e9 97 fd ff ff       	jmp    801053af <scheduler+0x9f>
80105618:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010561f:	00 
      ptable.rq_tail[cpu] = 0;
80105620:	c7 04 9d 74 75 11 80 	movl   $0x0,-0x7fee8a8c(,%ebx,4)
80105627:	00 00 00 00 
8010562b:	e9 b8 fd ff ff       	jmp    801053e8 <scheduler+0xd8>
          ptable.rq_tail[cid] = best_prev;
80105630:	89 1c 85 24 50 11 80 	mov    %ebx,-0x7feeafdc(,%eax,4)
80105637:	e9 c6 fe ff ff       	jmp    80105502 <scheduler+0x1f2>
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          ptable.rq_head[cid] = best->next;
80105640:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105643:	89 04 8d 24 50 11 80 	mov    %eax,-0x7feeafdc(,%ecx,4)
8010564a:	e9 a3 fe ff ff       	jmp    801054f2 <scheduler+0x1e2>
8010564f:	90                   	nop
    ptable.rq_tail[e_id] = prev;
80105650:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80105653:	89 0c 85 24 50 11 80 	mov    %ecx,-0x7feeafdc(,%eax,4)
8010565a:	eb 94                	jmp    801055f0 <scheduler+0x2e0>
    ptable.rq_head[e_id] = cur->next;
8010565c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010565f:	89 04 8d 24 50 11 80 	mov    %eax,-0x7feeafdc(,%ecx,4)
80105666:	e9 79 ff ff ff       	jmp    801055e4 <scheduler+0x2d4>
8010566b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105670 <sched>:
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	56                   	push   %esi
80105674:	53                   	push   %ebx
  pushcli();
80105675:	e8 46 0b 00 00       	call   801061c0 <pushcli>
  c = mycpu();
8010567a:	e8 31 f9 ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
8010567f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105685:	e8 86 0b 00 00       	call   80106210 <popcli>
  if(!holding(&ptable.lock))
8010568a:	83 ec 0c             	sub    $0xc,%esp
8010568d:	68 20 50 11 80       	push   $0x80115020
80105692:	e8 d9 0b 00 00       	call   80106270 <holding>
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	85 c0                	test   %eax,%eax
8010569c:	74 4f                	je     801056ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010569e:	e8 0d f9 ff ff       	call   80104fb0 <mycpu>
801056a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801056aa:	75 68                	jne    80105714 <sched+0xa4>
  if(p->state == RUNNING)
801056ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801056b0:	74 55                	je     80105707 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801056b2:	9c                   	pushf
801056b3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801056b4:	f6 c4 02             	test   $0x2,%ah
801056b7:	75 41                	jne    801056fa <sched+0x8a>
  intena = mycpu()->intena;
801056b9:	e8 f2 f8 ff ff       	call   80104fb0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801056be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801056c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801056c7:	e8 e4 f8 ff ff       	call   80104fb0 <mycpu>
801056cc:	83 ec 08             	sub    $0x8,%esp
801056cf:	ff 70 04             	push   0x4(%eax)
801056d2:	53                   	push   %ebx
801056d3:	e8 43 0f 00 00       	call   8010661b <swtch>
  mycpu()->intena = intena;
801056d8:	e8 d3 f8 ff ff       	call   80104fb0 <mycpu>
}
801056dd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801056e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801056e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e9:	5b                   	pop    %ebx
801056ea:	5e                   	pop    %esi
801056eb:	5d                   	pop    %ebp
801056ec:	c3                   	ret
    panic("sched ptable.lock");
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 91 98 10 80       	push   $0x80109891
801056f5:	e8 56 ae ff ff       	call   80100550 <panic>
    panic("sched interruptible");
801056fa:	83 ec 0c             	sub    $0xc,%esp
801056fd:	68 bd 98 10 80       	push   $0x801098bd
80105702:	e8 49 ae ff ff       	call   80100550 <panic>
    panic("sched running");
80105707:	83 ec 0c             	sub    $0xc,%esp
8010570a:	68 af 98 10 80       	push   $0x801098af
8010570f:	e8 3c ae ff ff       	call   80100550 <panic>
    panic("sched locks");
80105714:	83 ec 0c             	sub    $0xc,%esp
80105717:	68 a3 98 10 80       	push   $0x801098a3
8010571c:	e8 2f ae ff ff       	call   80100550 <panic>
80105721:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105728:	00 
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <exit>:
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
80105735:	53                   	push   %ebx
80105736:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80105739:	e8 f2 f8 ff ff       	call   80105030 <myproc>
  if(curproc == initproc)
8010573e:	39 05 b4 75 11 80    	cmp    %eax,0x801175b4
80105744:	0f 84 41 01 00 00    	je     8010588b <exit+0x15b>
8010574a:	89 c7                	mov    %eax,%edi
8010574c:	8d 58 28             	lea    0x28(%eax),%ebx
8010574f:	8d 70 68             	lea    0x68(%eax),%esi
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105758:	8b 03                	mov    (%ebx),%eax
8010575a:	85 c0                	test   %eax,%eax
8010575c:	74 12                	je     80105770 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010575e:	83 ec 0c             	sub    $0xc,%esp
80105761:	50                   	push   %eax
80105762:	e8 49 cd ff ff       	call   801024b0 <fileclose>
      curproc->ofile[fd] = 0;
80105767:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010576d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105770:	83 c3 04             	add    $0x4,%ebx
80105773:	39 f3                	cmp    %esi,%ebx
80105775:	75 e1                	jne    80105758 <exit+0x28>
  begin_op();
80105777:	e8 64 eb ff ff       	call   801042e0 <begin_op>
  iput(curproc->cwd);
8010577c:	83 ec 0c             	sub    $0xc,%esp
8010577f:	ff 77 68             	push   0x68(%edi)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105782:	bb 54 50 11 80       	mov    $0x80115054,%ebx
  iput(curproc->cwd);
80105787:	e8 e4 d6 ff ff       	call   80102e70 <iput>
  end_op();
8010578c:	e8 bf eb ff ff       	call   80104350 <end_op>
  curproc->cwd = 0;
80105791:	c7 47 68 00 00 00 00 	movl   $0x0,0x68(%edi)
  acquire(&ptable.lock);
80105798:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
8010579f:	e8 6c 0b 00 00       	call   80106310 <acquire>
  wakeup1(curproc->parent);
801057a4:	8b 77 14             	mov    0x14(%edi),%esi
801057a7:	83 c4 10             	add    $0x10,%esp
801057aa:	eb 12                	jmp    801057be <exit+0x8e>
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057b0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801057b6:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
801057bc:	74 2c                	je     801057ea <exit+0xba>
  if(p->state == SLEEPING && p->chan == chan){
801057be:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801057c2:	75 ec                	jne    801057b0 <exit+0x80>
801057c4:	3b 73 20             	cmp    0x20(%ebx),%esi
801057c7:	75 e7                	jne    801057b0 <exit+0x80>
    p->state = RUNNABLE;
801057c9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  return choose_e_core_min_load();
801057d0:	e8 6b f5 ff ff       	call   80104d40 <choose_e_core_min_load>
    int cid = pick_cpu_for_new_proc();
    rq_enqueue(cid, p);
801057d5:	89 da                	mov    %ebx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057d7:	81 c3 94 00 00 00    	add    $0x94,%ebx
    rq_enqueue(cid, p);
801057dd:	e8 ce f5 ff ff       	call   80104db0 <rq_enqueue>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057e2:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
801057e8:	75 d4                	jne    801057be <exit+0x8e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057ea:	be 54 50 11 80       	mov    $0x80115054,%esi
801057ef:	eb 15                	jmp    80105806 <exit+0xd6>
801057f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057f8:	81 c6 94 00 00 00    	add    $0x94,%esi
801057fe:	81 fe 54 75 11 80    	cmp    $0x80117554,%esi
80105804:	74 56                	je     8010585c <exit+0x12c>
    if(p->parent == curproc){
80105806:	39 7e 14             	cmp    %edi,0x14(%esi)
80105809:	75 ed                	jne    801057f8 <exit+0xc8>
      p->parent = initproc;
8010580b:	8b 0d b4 75 11 80    	mov    0x801175b4,%ecx
      if(p->state == ZOMBIE)
80105811:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
      p->parent = initproc;
80105815:	89 4e 14             	mov    %ecx,0x14(%esi)
      if(p->state == ZOMBIE)
80105818:	75 de                	jne    801057f8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010581a:	bb 54 50 11 80       	mov    $0x80115054,%ebx
8010581f:	eb 15                	jmp    80105836 <exit+0x106>
80105821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105828:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010582e:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105834:	74 c2                	je     801057f8 <exit+0xc8>
  if(p->state == SLEEPING && p->chan == chan){
80105836:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010583a:	75 ec                	jne    80105828 <exit+0xf8>
8010583c:	3b 4b 20             	cmp    0x20(%ebx),%ecx
8010583f:	75 e7                	jne    80105828 <exit+0xf8>
    p->state = RUNNABLE;
80105841:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80105848:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  return choose_e_core_min_load();
8010584b:	e8 f0 f4 ff ff       	call   80104d40 <choose_e_core_min_load>
    rq_enqueue(cid, p);
80105850:	89 da                	mov    %ebx,%edx
80105852:	e8 59 f5 ff ff       	call   80104db0 <rq_enqueue>
80105857:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010585a:	eb cc                	jmp    80105828 <exit+0xf8>
  if(is_measuring_throughput){
8010585c:	a1 08 50 11 80       	mov    0x80115008,%eax
80105861:	85 c0                	test   %eax,%eax
80105863:	74 0d                	je     80105872 <exit+0x142>
    if(curproc->pid > 2)
80105865:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80105869:	7e 07                	jle    80105872 <exit+0x142>
      throughput_finished_procs++;
8010586b:	83 05 00 50 11 80 01 	addl   $0x1,0x80115000
  curproc->state = ZOMBIE;
80105872:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
  sched();
80105879:	e8 f2 fd ff ff       	call   80105670 <sched>
  panic("zombie exit");
8010587e:	83 ec 0c             	sub    $0xc,%esp
80105881:	68 de 98 10 80       	push   $0x801098de
80105886:	e8 c5 ac ff ff       	call   80100550 <panic>
    panic("init exiting");
8010588b:	83 ec 0c             	sub    $0xc,%esp
8010588e:	68 d1 98 10 80       	push   $0x801098d1
80105893:	e8 b8 ac ff ff       	call   80100550 <panic>
80105898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589f:	00 

801058a0 <wait>:
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	56                   	push   %esi
801058a4:	53                   	push   %ebx
  pushcli();
801058a5:	e8 16 09 00 00       	call   801061c0 <pushcli>
  c = mycpu();
801058aa:	e8 01 f7 ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
801058af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801058b5:	e8 56 09 00 00       	call   80106210 <popcli>
  acquire(&ptable.lock);
801058ba:	83 ec 0c             	sub    $0xc,%esp
801058bd:	68 20 50 11 80       	push   $0x80115020
801058c2:	e8 49 0a 00 00       	call   80106310 <acquire>
801058c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801058ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058cc:	bb 54 50 11 80       	mov    $0x80115054,%ebx
801058d1:	eb 13                	jmp    801058e6 <wait+0x46>
801058d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801058d8:	81 c3 94 00 00 00    	add    $0x94,%ebx
801058de:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
801058e4:	74 1e                	je     80105904 <wait+0x64>
      if(p->parent != curproc)
801058e6:	39 73 14             	cmp    %esi,0x14(%ebx)
801058e9:	75 ed                	jne    801058d8 <wait+0x38>
      if(p->state == ZOMBIE){
801058eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801058ef:	74 5f                	je     80105950 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058f1:	81 c3 94 00 00 00    	add    $0x94,%ebx
      havekids = 1;
801058f7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058fc:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105902:	75 e2                	jne    801058e6 <wait+0x46>
    if(!havekids || curproc->killed){
80105904:	85 c0                	test   %eax,%eax
80105906:	0f 84 9a 00 00 00    	je     801059a6 <wait+0x106>
8010590c:	8b 46 24             	mov    0x24(%esi),%eax
8010590f:	85 c0                	test   %eax,%eax
80105911:	0f 85 8f 00 00 00    	jne    801059a6 <wait+0x106>
  pushcli();
80105917:	e8 a4 08 00 00       	call   801061c0 <pushcli>
  c = mycpu();
8010591c:	e8 8f f6 ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
80105921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105927:	e8 e4 08 00 00       	call   80106210 <popcli>
  if(p == 0)
8010592c:	85 db                	test   %ebx,%ebx
8010592e:	0f 84 89 00 00 00    	je     801059bd <wait+0x11d>
  p->chan = chan;
80105934:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105937:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010593e:	e8 2d fd ff ff       	call   80105670 <sched>
  p->chan = 0;
80105943:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010594a:	e9 7b ff ff ff       	jmp    801058ca <wait+0x2a>
8010594f:	90                   	nop
        kfree(p->kstack);
80105950:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105953:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105956:	ff 73 08             	push   0x8(%ebx)
80105959:	e8 e2 e0 ff ff       	call   80103a40 <kfree>
        p->kstack = 0;
8010595e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105965:	5a                   	pop    %edx
80105966:	ff 73 04             	push   0x4(%ebx)
80105969:	e8 d2 38 00 00       	call   80109240 <freevm>
        p->pid = 0;
8010596e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105975:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010597c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105980:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105987:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010598e:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
80105995:	e8 16 09 00 00       	call   801062b0 <release>
        return pid;
8010599a:	83 c4 10             	add    $0x10,%esp
}
8010599d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059a0:	89 f0                	mov    %esi,%eax
801059a2:	5b                   	pop    %ebx
801059a3:	5e                   	pop    %esi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret
      release(&ptable.lock);
801059a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801059a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801059ae:	68 20 50 11 80       	push   $0x80115020
801059b3:	e8 f8 08 00 00       	call   801062b0 <release>
      return -1;
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	eb e0                	jmp    8010599d <wait+0xfd>
    panic("sleep");
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	68 ea 98 10 80       	push   $0x801098ea
801059c5:	e8 86 ab ff ff       	call   80100550 <panic>
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059d0 <yield>:
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
801059d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801059d7:	68 20 50 11 80       	push   $0x80115020
801059dc:	e8 2f 09 00 00       	call   80106310 <acquire>
  pushcli();
801059e1:	e8 da 07 00 00       	call   801061c0 <pushcli>
  c = mycpu();
801059e6:	e8 c5 f5 ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
801059eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801059f1:	e8 1a 08 00 00       	call   80106210 <popcli>
  if(cid < 0 || cid >= ncpu){
801059f6:	83 c4 10             	add    $0x10,%esp
  int cid = p->queue_id;
801059f9:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  p->state = RUNNABLE;
801059ff:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  if(cid < 0 || cid >= ncpu){
80105a06:	85 c0                	test   %eax,%eax
80105a08:	78 08                	js     80105a12 <yield+0x42>
80105a0a:	39 05 24 4a 11 80    	cmp    %eax,0x80114a24
80105a10:	7f 05                	jg     80105a17 <yield+0x47>
    cid = choose_e_core_min_load();
80105a12:	e8 29 f3 ff ff       	call   80104d40 <choose_e_core_min_load>
  rq_enqueue(cid, p);
80105a17:	89 da                	mov    %ebx,%edx
80105a19:	e8 92 f3 ff ff       	call   80104db0 <rq_enqueue>
  sched();
80105a1e:	e8 4d fc ff ff       	call   80105670 <sched>
  release(&ptable.lock);
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	68 20 50 11 80       	push   $0x80115020
80105a2b:	e8 80 08 00 00       	call   801062b0 <release>
}
80105a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	c9                   	leave
80105a37:	c3                   	ret
80105a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3f:	00 

80105a40 <sleep>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
80105a46:	83 ec 0c             	sub    $0xc,%esp
80105a49:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80105a4f:	e8 6c 07 00 00       	call   801061c0 <pushcli>
  c = mycpu();
80105a54:	e8 57 f5 ff ff       	call   80104fb0 <mycpu>
  p = c->proc;
80105a59:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105a5f:	e8 ac 07 00 00       	call   80106210 <popcli>
  if(p == 0)
80105a64:	85 db                	test   %ebx,%ebx
80105a66:	0f 84 87 00 00 00    	je     80105af3 <sleep+0xb3>
  if(lk == 0)
80105a6c:	85 f6                	test   %esi,%esi
80105a6e:	74 76                	je     80105ae6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105a70:	81 fe 20 50 11 80    	cmp    $0x80115020,%esi
80105a76:	74 50                	je     80105ac8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	68 20 50 11 80       	push   $0x80115020
80105a80:	e8 8b 08 00 00       	call   80106310 <acquire>
    release(lk);
80105a85:	89 34 24             	mov    %esi,(%esp)
80105a88:	e8 23 08 00 00       	call   801062b0 <release>
  p->chan = chan;
80105a8d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105a90:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105a97:	e8 d4 fb ff ff       	call   80105670 <sched>
  p->chan = 0;
80105a9c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105aa3:	c7 04 24 20 50 11 80 	movl   $0x80115020,(%esp)
80105aaa:	e8 01 08 00 00       	call   801062b0 <release>
    acquire(lk);
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab8:	5b                   	pop    %ebx
80105ab9:	5e                   	pop    %esi
80105aba:	5f                   	pop    %edi
80105abb:	5d                   	pop    %ebp
    acquire(lk);
80105abc:	e9 4f 08 00 00       	jmp    80106310 <acquire>
80105ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105ac8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105acb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105ad2:	e8 99 fb ff ff       	call   80105670 <sched>
  p->chan = 0;
80105ad7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae1:	5b                   	pop    %ebx
80105ae2:	5e                   	pop    %esi
80105ae3:	5f                   	pop    %edi
80105ae4:	5d                   	pop    %ebp
80105ae5:	c3                   	ret
    panic("sleep without lk");
80105ae6:	83 ec 0c             	sub    $0xc,%esp
80105ae9:	68 f0 98 10 80       	push   $0x801098f0
80105aee:	e8 5d aa ff ff       	call   80100550 <panic>
    panic("sleep");
80105af3:	83 ec 0c             	sub    $0xc,%esp
80105af6:	68 ea 98 10 80       	push   $0x801098ea
80105afb:	e8 50 aa ff ff       	call   80100550 <panic>

80105b00 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	56                   	push   %esi
80105b04:	53                   	push   %ebx
80105b05:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b08:	bb 54 50 11 80       	mov    $0x80115054,%ebx
  acquire(&ptable.lock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 20 50 11 80       	push   $0x80115020
80105b15:	e8 f6 07 00 00       	call   80106310 <acquire>
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	eb 0f                	jmp    80105b2e <wakeup+0x2e>
80105b1f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b20:	81 c3 94 00 00 00    	add    $0x94,%ebx
80105b26:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105b2c:	74 2c                	je     80105b5a <wakeup+0x5a>
  if(p->state == SLEEPING && p->chan == chan){
80105b2e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80105b32:	75 ec                	jne    80105b20 <wakeup+0x20>
80105b34:	3b 73 20             	cmp    0x20(%ebx),%esi
80105b37:	75 e7                	jne    80105b20 <wakeup+0x20>
    p->state = RUNNABLE;
80105b39:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  return choose_e_core_min_load();
80105b40:	e8 fb f1 ff ff       	call   80104d40 <choose_e_core_min_load>
    rq_enqueue(cid, p);
80105b45:	89 da                	mov    %ebx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b47:	81 c3 94 00 00 00    	add    $0x94,%ebx
    rq_enqueue(cid, p);
80105b4d:	e8 5e f2 ff ff       	call   80104db0 <rq_enqueue>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b52:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105b58:	75 d4                	jne    80105b2e <wakeup+0x2e>
  wakeup1(chan);
  release(&ptable.lock);
80105b5a:	c7 45 08 20 50 11 80 	movl   $0x80115020,0x8(%ebp)
}
80105b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b64:	5b                   	pop    %ebx
80105b65:	5e                   	pop    %esi
80105b66:	5d                   	pop    %ebp
  release(&ptable.lock);
80105b67:	e9 44 07 00 00       	jmp    801062b0 <release>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	56                   	push   %esi
80105b74:	53                   	push   %ebx
80105b75:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b78:	bb 54 50 11 80       	mov    $0x80115054,%ebx
  acquire(&ptable.lock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 20 50 11 80       	push   $0x80115020
80105b85:	e8 86 07 00 00       	call   80106310 <acquire>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	eb 0f                	jmp    80105b9e <kill+0x2e>
80105b8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b90:	81 c3 94 00 00 00    	add    $0x94,%ebx
80105b96:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105b9c:	74 32                	je     80105bd0 <kill+0x60>
    if(p->pid == pid){
80105b9e:	39 73 10             	cmp    %esi,0x10(%ebx)
80105ba1:	75 ed                	jne    80105b90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80105ba3:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
      p->killed = 1;
80105ba7:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      if(p->state == SLEEPING){
80105bae:	74 40                	je     80105bf0 <kill+0x80>
  p->state = RUNNABLE;
  int cid = pick_cpu_for_new_proc();
  rq_enqueue(cid, p);
}

      release(&ptable.lock);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 20 50 11 80       	push   $0x80115020
80105bb8:	e8 f3 06 00 00       	call   801062b0 <release>
      return 0;
80105bbd:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
80105bc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
80105bc3:	31 c0                	xor    %eax,%eax
}
80105bc5:	5b                   	pop    %ebx
80105bc6:	5e                   	pop    %esi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	68 20 50 11 80       	push   $0x80115020
80105bd8:	e8 d3 06 00 00       	call   801062b0 <release>
  return -1;
80105bdd:	83 c4 10             	add    $0x10,%esp
}
80105be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80105be3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be8:	5b                   	pop    %ebx
80105be9:	5e                   	pop    %esi
80105bea:	5d                   	pop    %ebp
80105beb:	c3                   	ret
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p->state = RUNNABLE;
80105bf0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  return choose_e_core_min_load();
80105bf7:	e8 44 f1 ff ff       	call   80104d40 <choose_e_core_min_load>
  rq_enqueue(cid, p);
80105bfc:	89 da                	mov    %ebx,%edx
80105bfe:	e8 ad f1 ff ff       	call   80104db0 <rq_enqueue>
80105c03:	eb ab                	jmp    80105bb0 <kill+0x40>
80105c05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0c:	00 
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi

80105c10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	8d 75 e8             	lea    -0x18(%ebp),%esi
80105c18:	53                   	push   %ebx
80105c19:	bb c0 50 11 80       	mov    $0x801150c0,%ebx
80105c1e:	83 ec 3c             	sub    $0x3c,%esp
80105c21:	eb 27                	jmp    80105c4a <procdump+0x3a>
80105c23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	68 c2 9b 10 80       	push   $0x80109bc2
80105c30:	e8 2b b1 ff ff       	call   80100d60 <cprintf>
80105c35:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105c38:	81 c3 94 00 00 00    	add    $0x94,%ebx
80105c3e:	81 fb c0 75 11 80    	cmp    $0x801175c0,%ebx
80105c44:	0f 84 7e 00 00 00    	je     80105cc8 <procdump+0xb8>
    if(p->state == UNUSED)
80105c4a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	74 e7                	je     80105c38 <procdump+0x28>
      state = "???";
80105c51:	ba 01 99 10 80       	mov    $0x80109901,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105c56:	83 f8 05             	cmp    $0x5,%eax
80105c59:	77 11                	ja     80105c6c <procdump+0x5c>
80105c5b:	8b 14 85 80 a0 10 80 	mov    -0x7fef5f80(,%eax,4),%edx
      state = "???";
80105c62:	b8 01 99 10 80       	mov    $0x80109901,%eax
80105c67:	85 d2                	test   %edx,%edx
80105c69:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105c6c:	53                   	push   %ebx
80105c6d:	52                   	push   %edx
80105c6e:	ff 73 a4             	push   -0x5c(%ebx)
80105c71:	68 05 99 10 80       	push   $0x80109905
80105c76:	e8 e5 b0 ff ff       	call   80100d60 <cprintf>
    if(p->state == SLEEPING){
80105c7b:	83 c4 10             	add    $0x10,%esp
80105c7e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80105c82:	75 a4                	jne    80105c28 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105c8a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80105c8d:	50                   	push   %eax
80105c8e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80105c91:	8b 40 0c             	mov    0xc(%eax),%eax
80105c94:	83 c0 08             	add    $0x8,%eax
80105c97:	50                   	push   %eax
80105c98:	e8 a3 04 00 00       	call   80106140 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105c9d:	83 c4 10             	add    $0x10,%esp
80105ca0:	8b 17                	mov    (%edi),%edx
80105ca2:	85 d2                	test   %edx,%edx
80105ca4:	74 82                	je     80105c28 <procdump+0x18>
        cprintf(" %p", pc[i]);
80105ca6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105ca9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80105cac:	52                   	push   %edx
80105cad:	68 41 96 10 80       	push   $0x80109641
80105cb2:	e8 a9 b0 ff ff       	call   80100d60 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	39 f7                	cmp    %esi,%edi
80105cbc:	75 e2                	jne    80105ca0 <procdump+0x90>
80105cbe:	e9 65 ff ff ff       	jmp    80105c28 <procdump+0x18>
80105cc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80105cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ccb:	5b                   	pop    %ebx
80105ccc:	5e                   	pop    %esi
80105ccd:	5f                   	pop    %edi
80105cce:	5d                   	pop    %ebp
80105ccf:	c3                   	ret

80105cd0 <process_family>:

int
process_family(int pid)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
  struct proc *p, *target=0, *parent =0;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105cd5:	be 54 50 11 80       	mov    $0x80115054,%esi
{
80105cda:	53                   	push   %ebx
80105cdb:	83 ec 18             	sub    $0x18,%esp
80105cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80105ce1:	68 20 50 11 80       	push   $0x80115020
80105ce6:	e8 25 06 00 00       	call   80106310 <acquire>
80105ceb:	83 c4 10             	add    $0x10,%esp
80105cee:	eb 12                	jmp    80105d02 <process_family+0x32>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105cf0:	81 c6 94 00 00 00    	add    $0x94,%esi
80105cf6:	81 fe 54 75 11 80    	cmp    $0x80117554,%esi
80105cfc:	0f 84 4b 01 00 00    	je     80105e4d <process_family+0x17d>
    if (p->state != UNUSED && p->pid == pid){
80105d02:	8b 46 0c             	mov    0xc(%esi),%eax
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 e7                	je     80105cf0 <process_family+0x20>
80105d09:	8b 46 10             	mov    0x10(%esi),%eax
80105d0c:	39 d8                	cmp    %ebx,%eax
80105d0e:	75 e0                	jne    80105cf0 <process_family+0x20>
      target = p;
      parent = p->parent;   // safe while ptable.lock is held
80105d10:	8b 7e 14             	mov    0x14(%esi),%edi
  if (target == 0){
    release(&ptable.lock);
    return -1;              // pid not found
  }

  cprintf("My id: %d, My parent id: %d\n",target->pid, parent ? parent->pid : -1);
80105d13:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105d18:	85 ff                	test   %edi,%edi
80105d1a:	74 03                	je     80105d1f <process_family+0x4f>
80105d1c:	8b 57 10             	mov    0x10(%edi),%edx
80105d1f:	83 ec 04             	sub    $0x4,%esp
80105d22:	52                   	push   %edx
80105d23:	50                   	push   %eax
80105d24:	68 0e 99 10 80       	push   $0x8010990e
80105d29:	e8 32 b0 ff ff       	call   80100d60 <cprintf>

  cprintf("Children of process %d:\n", target->pid);
80105d2e:	5b                   	pop    %ebx
80105d2f:	58                   	pop    %eax
80105d30:	ff 76 10             	push   0x10(%esi)
80105d33:	68 2b 99 10 80       	push   $0x8010992b
  int have_child = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d38:	bb 54 50 11 80       	mov    $0x80115054,%ebx
  cprintf("Children of process %d:\n", target->pid);
80105d3d:	e8 1e b0 ff ff       	call   80100d60 <cprintf>
80105d42:	83 c4 10             	add    $0x10,%esp
  int have_child = 0;
80105d45:	31 c0                	xor    %eax,%eax
80105d47:	eb 15                	jmp    80105d5e <process_family+0x8e>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d50:	81 c3 94 00 00 00    	add    $0x94,%ebx
80105d56:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105d5c:	74 32                	je     80105d90 <process_family+0xc0>
    if (p->state != UNUSED && p->parent == target){
80105d5e:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80105d61:	85 c9                	test   %ecx,%ecx
80105d63:	74 eb                	je     80105d50 <process_family+0x80>
80105d65:	39 73 14             	cmp    %esi,0x14(%ebx)
80105d68:	75 e6                	jne    80105d50 <process_family+0x80>
      cprintf("Child pid: %d\n", p->pid);
80105d6a:	83 ec 08             	sub    $0x8,%esp
80105d6d:	ff 73 10             	push   0x10(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d70:	81 c3 94 00 00 00    	add    $0x94,%ebx
      cprintf("Child pid: %d\n", p->pid);
80105d76:	68 44 99 10 80       	push   $0x80109944
80105d7b:	e8 e0 af ff ff       	call   80100d60 <cprintf>
80105d80:	83 c4 10             	add    $0x10,%esp
      have_child = 1;
80105d83:	b8 01 00 00 00       	mov    $0x1,%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d88:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105d8e:	75 ce                	jne    80105d5e <process_family+0x8e>
    }
  }
  if (!have_child)
80105d90:	85 c0                	test   %eax,%eax
80105d92:	0f 84 a0 00 00 00    	je     80105e38 <process_family+0x168>
    cprintf("No children.\n");

  cprintf("Siblings of process %d:\n", target->pid);
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	ff 76 10             	push   0x10(%esi)
  int have_sib = 0;
  if (parent){
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d9e:	bb 54 50 11 80       	mov    $0x80115054,%ebx
  cprintf("Siblings of process %d:\n", target->pid);
80105da3:	68 61 99 10 80       	push   $0x80109961
80105da8:	e8 b3 af ff ff       	call   80100d60 <cprintf>
  if (parent){
80105dad:	83 c4 10             	add    $0x10,%esp
  int have_sib = 0;
80105db0:	31 c0                	xor    %eax,%eax
  if (parent){
80105db2:	85 ff                	test   %edi,%edi
80105db4:	75 18                	jne    80105dce <process_family+0xfe>
80105db6:	eb 6e                	jmp    80105e26 <process_family+0x156>
80105db8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbf:	00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105dc0:	81 c3 94 00 00 00    	add    $0x94,%ebx
80105dc6:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105dcc:	74 3a                	je     80105e08 <process_family+0x138>
      if (p->state != UNUSED && p->parent == parent && p != target){
80105dce:	8b 53 0c             	mov    0xc(%ebx),%edx
80105dd1:	85 d2                	test   %edx,%edx
80105dd3:	74 eb                	je     80105dc0 <process_family+0xf0>
80105dd5:	39 7b 14             	cmp    %edi,0x14(%ebx)
80105dd8:	75 e6                	jne    80105dc0 <process_family+0xf0>
80105dda:	39 de                	cmp    %ebx,%esi
80105ddc:	74 e2                	je     80105dc0 <process_family+0xf0>
        cprintf("Sibling pid: %d\n", p->pid);
80105dde:	83 ec 08             	sub    $0x8,%esp
80105de1:	ff 73 10             	push   0x10(%ebx)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105de4:	81 c3 94 00 00 00    	add    $0x94,%ebx
        cprintf("Sibling pid: %d\n", p->pid);
80105dea:	68 88 99 10 80       	push   $0x80109988
80105def:	e8 6c af ff ff       	call   80100d60 <cprintf>
80105df4:	83 c4 10             	add    $0x10,%esp
        have_sib = 1;
80105df7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105dfc:	81 fb 54 75 11 80    	cmp    $0x80117554,%ebx
80105e02:	75 ca                	jne    80105dce <process_family+0xfe>
80105e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      }
    }
  }
  if (!have_sib)
80105e08:	85 c0                	test   %eax,%eax
80105e0a:	74 1a                	je     80105e26 <process_family+0x156>
    cprintf("No siblings.\n");

  release(&ptable.lock);
80105e0c:	83 ec 0c             	sub    $0xc,%esp
80105e0f:	68 20 50 11 80       	push   $0x80115020
80105e14:	e8 97 04 00 00       	call   801062b0 <release>
  return 0;
80105e19:	83 c4 10             	add    $0x10,%esp
}
80105e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80105e1f:	31 c0                	xor    %eax,%eax
}
80105e21:	5b                   	pop    %ebx
80105e22:	5e                   	pop    %esi
80105e23:	5f                   	pop    %edi
80105e24:	5d                   	pop    %ebp
80105e25:	c3                   	ret
    cprintf("No siblings.\n");
80105e26:	83 ec 0c             	sub    $0xc,%esp
80105e29:	68 7a 99 10 80       	push   $0x8010997a
80105e2e:	e8 2d af ff ff       	call   80100d60 <cprintf>
80105e33:	83 c4 10             	add    $0x10,%esp
80105e36:	eb d4                	jmp    80105e0c <process_family+0x13c>
    cprintf("No children.\n");
80105e38:	83 ec 0c             	sub    $0xc,%esp
80105e3b:	68 53 99 10 80       	push   $0x80109953
80105e40:	e8 1b af ff ff       	call   80100d60 <cprintf>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	e9 4b ff ff ff       	jmp    80105d98 <process_family+0xc8>
    release(&ptable.lock);
80105e4d:	83 ec 0c             	sub    $0xc,%esp
80105e50:	68 20 50 11 80       	push   $0x80115020
80105e55:	e8 56 04 00 00       	call   801062b0 <release>
    return -1;              // pid not found
80105e5a:	83 c4 10             	add    $0x10,%esp
}
80105e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;              // pid not found
80105e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e65:	5b                   	pop    %ebx
80105e66:	5e                   	pop    %esi
80105e67:	5f                   	pop    %edi
80105e68:	5d                   	pop    %ebp
80105e69:	c3                   	ret
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e70 <set_priority>:

int
set_priority(int pid, int new_priority)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	56                   	push   %esi
80105e74:	53                   	push   %ebx
80105e75:	8b 75 0c             	mov    0xc(%ebp),%esi
80105e78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old = -1;

  if(new_priority > PRIO_MIN || new_priority < PRIO_MAX)
80105e7b:	83 fe 02             	cmp    $0x2,%esi
80105e7e:	77 57                	ja     80105ed7 <set_priority+0x67>
    return -1;

  acquire(&ptable.lock);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	68 20 50 11 80       	push   $0x80115020
80105e88:	e8 83 04 00 00       	call   80106310 <acquire>
80105e8d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e90:	b8 54 50 11 80       	mov    $0x80115054,%eax
80105e95:	eb 15                	jmp    80105eac <set_priority+0x3c>
80105e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e9e:	00 
80105e9f:	90                   	nop
80105ea0:	05 94 00 00 00       	add    $0x94,%eax
80105ea5:	3d 54 75 11 80       	cmp    $0x80117554,%eax
80105eaa:	74 24                	je     80105ed0 <set_priority+0x60>
    if(p->pid == pid){
80105eac:	39 58 10             	cmp    %ebx,0x10(%eax)
80105eaf:	75 ef                	jne    80105ea0 <set_priority+0x30>
      old = p->priority;
80105eb1:	8b 58 7c             	mov    0x7c(%eax),%ebx
      p->priority = new_priority;
80105eb4:	89 70 7c             	mov    %esi,0x7c(%eax)
      break;
    }
  }

  release(&ptable.lock);
80105eb7:	83 ec 0c             	sub    $0xc,%esp
80105eba:	68 20 50 11 80       	push   $0x80115020
80105ebf:	e8 ec 03 00 00       	call   801062b0 <release>
  return old;
80105ec4:	83 c4 10             	add    $0x10,%esp
}
80105ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105eca:	89 d8                	mov    %ebx,%eax
80105ecc:	5b                   	pop    %ebx
80105ecd:	5e                   	pop    %esi
80105ece:	5d                   	pop    %ebp
80105ecf:	c3                   	ret
  int old = -1;
80105ed0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ed5:	eb e0                	jmp    80105eb7 <set_priority+0x47>
    return -1;
80105ed7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105edc:	eb e9                	jmp    80105ec7 <set_priority+0x57>
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <print_process_info>:

void
print_process_info(struct proc *p)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
80105ee6:	83 ec 48             	sub    $0x48,%esp
80105ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint now;

  acquire(&tickslock);
80105eec:	68 e0 75 11 80       	push   $0x801175e0
80105ef1:	e8 1a 04 00 00       	call   80106310 <acquire>
  now = ticks;
80105ef6:	8b 35 c0 75 11 80    	mov    0x801175c0,%esi
  release(&tickslock);
80105efc:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80105f03:	e8 a8 03 00 00       	call   801062b0 <release>
    [RUNNING]   "RUNNING",
    [ZOMBIE]    "ZOMBIE"
  };

  char *st = "???";
  if(p->state >= 0 && p->state < NELEM(states))
80105f08:	8b 43 0c             	mov    0xc(%ebx),%eax
80105f0b:	83 c4 10             	add    $0x10,%esp
  char *states[] = {
80105f0e:	c7 45 d0 a9 99 10 80 	movl   $0x801099a9,-0x30(%ebp)
80105f15:	c7 45 d4 b0 99 10 80 	movl   $0x801099b0,-0x2c(%ebp)
80105f1c:	ba 01 99 10 80       	mov    $0x80109901,%edx
80105f21:	c7 45 d8 b7 99 10 80 	movl   $0x801099b7,-0x28(%ebp)
80105f28:	c7 45 dc c0 99 10 80 	movl   $0x801099c0,-0x24(%ebp)
80105f2f:	c7 45 e0 c9 99 10 80 	movl   $0x801099c9,-0x20(%ebp)
80105f36:	c7 45 e4 d1 99 10 80 	movl   $0x801099d1,-0x1c(%ebp)
  if(p->state >= 0 && p->state < NELEM(states))
80105f3d:	83 f8 05             	cmp    $0x5,%eax
80105f40:	77 04                	ja     80105f46 <print_process_info+0x66>
    st = states[p->state];
80105f42:	8b 54 85 d0          	mov    -0x30(%ebp,%eax,4),%edx

  int q = p->queue_id;
80105f46:	8b bb 90 00 00 00    	mov    0x90(%ebx),%edi
  char *algo = "unknown";
80105f4c:	b8 99 99 10 80       	mov    $0x80109999,%eax

  if(q >= 0 && q < ncpu){
80105f51:	85 ff                	test   %edi,%edi
80105f53:	78 23                	js     80105f78 <print_process_info+0x98>
80105f55:	39 3d 24 4a 11 80    	cmp    %edi,0x80114a24
80105f5b:	7e 1b                	jle    80105f78 <print_process_info+0x98>
    if(cpus[q].core_type == 0)
80105f5d:	69 c7 b8 00 00 00    	imul   $0xb8,%edi,%eax
      algo = "RR";
80105f63:	b9 a6 99 10 80       	mov    $0x801099a6,%ecx
80105f68:	8b 80 f0 4a 11 80    	mov    -0x7feeb510(%eax),%eax
80105f6e:	85 c0                	test   %eax,%eax
80105f70:	b8 a1 99 10 80       	mov    $0x801099a1,%eax
80105f75:	0f 44 c1             	cmove  %ecx,%eax
      algo = "FCFS";
  }

  uint lifetime = now - p->creation_time;

  cprintf("name: %s\n", p->name);
80105f78:	83 ec 08             	sub    $0x8,%esp
80105f7b:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
  uint lifetime = now - p->creation_time;
80105f7e:	2b b3 88 00 00 00    	sub    0x88(%ebx),%esi
80105f84:	89 45 c0             	mov    %eax,-0x40(%ebp)
80105f87:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  cprintf("name: %s\n", p->name);
80105f8a:	51                   	push   %ecx
80105f8b:	68 d8 99 10 80       	push   $0x801099d8
80105f90:	e8 cb ad ff ff       	call   80100d60 <cprintf>
  cprintf("pid: %d\n", p->pid);
80105f95:	58                   	pop    %eax
80105f96:	5a                   	pop    %edx
80105f97:	ff 73 10             	push   0x10(%ebx)
80105f9a:	68 4a 99 10 80       	push   $0x8010994a
80105f9f:	e8 bc ad ff ff       	call   80100d60 <cprintf>
  cprintf("state: %s\n", st);
80105fa4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80105fa7:	59                   	pop    %ecx
80105fa8:	5b                   	pop    %ebx
80105fa9:	52                   	push   %edx
80105faa:	68 e2 99 10 80       	push   $0x801099e2
80105faf:	e8 ac ad ff ff       	call   80100d60 <cprintf>
  cprintf("queue: %d\n", q);
80105fb4:	58                   	pop    %eax
80105fb5:	5a                   	pop    %edx
80105fb6:	57                   	push   %edi
80105fb7:	68 ed 99 10 80       	push   $0x801099ed
80105fbc:	e8 9f ad ff ff       	call   80100d60 <cprintf>
  cprintf("algorithm: %s\n", algo);
80105fc1:	8b 45 c0             	mov    -0x40(%ebp),%eax
80105fc4:	59                   	pop    %ecx
80105fc5:	5b                   	pop    %ebx
80105fc6:	50                   	push   %eax
80105fc7:	68 f8 99 10 80       	push   $0x801099f8
80105fcc:	e8 8f ad ff ff       	call   80100d60 <cprintf>
  cprintf("lifetime_ticks: %d\n", (int)lifetime);
80105fd1:	5f                   	pop    %edi
80105fd2:	58                   	pop    %eax
80105fd3:	56                   	push   %esi
80105fd4:	68 07 9a 10 80       	push   $0x80109a07
80105fd9:	e8 82 ad ff ff       	call   80100d60 <cprintf>
}
80105fde:	83 c4 10             	add    $0x10,%esp
80105fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe4:	5b                   	pop    %ebx
80105fe5:	5e                   	pop    %esi
80105fe6:	5f                   	pop    %edi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret
80105fe9:	66 90                	xchg   %ax,%ax
80105feb:	66 90                	xchg   %ax,%ax
80105fed:	66 90                	xchg   %ax,%ax
80105fef:	90                   	nop

80105ff0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80105ffa:	68 45 9a 10 80       	push   $0x80109a45
80105fff:	8d 43 04             	lea    0x4(%ebx),%eax
80106002:	50                   	push   %eax
80106003:	e8 18 01 00 00       	call   80106120 <initlock>
  lk->name = name;
80106008:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010600b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80106011:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80106014:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010601b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010601e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106021:	c9                   	leave
80106022:	c3                   	ret
80106023:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010602a:	00 
8010602b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106030 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	56                   	push   %esi
80106034:	53                   	push   %ebx
80106035:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106038:	8d 73 04             	lea    0x4(%ebx),%esi
8010603b:	83 ec 0c             	sub    $0xc,%esp
8010603e:	56                   	push   %esi
8010603f:	e8 cc 02 00 00       	call   80106310 <acquire>
  while (lk->locked) {
80106044:	8b 13                	mov    (%ebx),%edx
80106046:	83 c4 10             	add    $0x10,%esp
80106049:	85 d2                	test   %edx,%edx
8010604b:	74 16                	je     80106063 <acquiresleep+0x33>
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80106050:	83 ec 08             	sub    $0x8,%esp
80106053:	56                   	push   %esi
80106054:	53                   	push   %ebx
80106055:	e8 e6 f9 ff ff       	call   80105a40 <sleep>
  while (lk->locked) {
8010605a:	8b 03                	mov    (%ebx),%eax
8010605c:	83 c4 10             	add    $0x10,%esp
8010605f:	85 c0                	test   %eax,%eax
80106061:	75 ed                	jne    80106050 <acquiresleep+0x20>
  }
  lk->locked = 1;
80106063:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80106069:	e8 c2 ef ff ff       	call   80105030 <myproc>
8010606e:	8b 40 10             	mov    0x10(%eax),%eax
80106071:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80106074:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106077:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010607a:	5b                   	pop    %ebx
8010607b:	5e                   	pop    %esi
8010607c:	5d                   	pop    %ebp
  release(&lk->lk);
8010607d:	e9 2e 02 00 00       	jmp    801062b0 <release>
80106082:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106089:	00 
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106090 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	56                   	push   %esi
80106094:	53                   	push   %ebx
80106095:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106098:	8d 73 04             	lea    0x4(%ebx),%esi
8010609b:	83 ec 0c             	sub    $0xc,%esp
8010609e:	56                   	push   %esi
8010609f:	e8 6c 02 00 00       	call   80106310 <acquire>
  lk->locked = 0;
801060a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801060aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801060b1:	89 1c 24             	mov    %ebx,(%esp)
801060b4:	e8 47 fa ff ff       	call   80105b00 <wakeup>
  release(&lk->lk);
801060b9:	83 c4 10             	add    $0x10,%esp
801060bc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801060bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060c2:	5b                   	pop    %ebx
801060c3:	5e                   	pop    %esi
801060c4:	5d                   	pop    %ebp
  release(&lk->lk);
801060c5:	e9 e6 01 00 00       	jmp    801062b0 <release>
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	57                   	push   %edi
801060d4:	31 ff                	xor    %edi,%edi
801060d6:	56                   	push   %esi
801060d7:	53                   	push   %ebx
801060d8:	83 ec 18             	sub    $0x18,%esp
801060db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801060de:	8d 73 04             	lea    0x4(%ebx),%esi
801060e1:	56                   	push   %esi
801060e2:	e8 29 02 00 00       	call   80106310 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801060e7:	8b 03                	mov    (%ebx),%eax
801060e9:	83 c4 10             	add    $0x10,%esp
801060ec:	85 c0                	test   %eax,%eax
801060ee:	75 18                	jne    80106108 <holdingsleep+0x38>
  release(&lk->lk);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	56                   	push   %esi
801060f4:	e8 b7 01 00 00       	call   801062b0 <release>
  return r;
}
801060f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060fc:	89 f8                	mov    %edi,%eax
801060fe:	5b                   	pop    %ebx
801060ff:	5e                   	pop    %esi
80106100:	5f                   	pop    %edi
80106101:	5d                   	pop    %ebp
80106102:	c3                   	ret
80106103:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80106108:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010610b:	e8 20 ef ff ff       	call   80105030 <myproc>
80106110:	39 58 10             	cmp    %ebx,0x10(%eax)
80106113:	0f 94 c0             	sete   %al
80106116:	0f b6 c0             	movzbl %al,%eax
80106119:	89 c7                	mov    %eax,%edi
8010611b:	eb d3                	jmp    801060f0 <holdingsleep+0x20>
8010611d:	66 90                	xchg   %ax,%ax
8010611f:	90                   	nop

80106120 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80106126:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80106129:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010612f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80106132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106139:	5d                   	pop    %ebp
8010613a:	c3                   	ret
8010613b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106140 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	53                   	push   %ebx
80106144:	8b 45 08             	mov    0x8(%ebp),%eax
80106147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010614a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010614d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80106152:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80106157:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010615c:	76 10                	jbe    8010616e <getcallerpcs+0x2e>
8010615e:	eb 28                	jmp    80106188 <getcallerpcs+0x48>
80106160:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80106166:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010616c:	77 1a                	ja     80106188 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010616e:	8b 5a 04             	mov    0x4(%edx),%ebx
80106171:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80106174:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80106177:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80106179:	83 f8 0a             	cmp    $0xa,%eax
8010617c:	75 e2                	jne    80106160 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010617e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106181:	c9                   	leave
80106182:	c3                   	ret
80106183:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106188:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010618b:	83 c1 28             	add    $0x28,%ecx
8010618e:	89 ca                	mov    %ecx,%edx
80106190:	29 c2                	sub    %eax,%edx
80106192:	83 e2 04             	and    $0x4,%edx
80106195:	74 11                	je     801061a8 <getcallerpcs+0x68>
    pcs[i] = 0;
80106197:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010619d:	83 c0 04             	add    $0x4,%eax
801061a0:	39 c1                	cmp    %eax,%ecx
801061a2:	74 da                	je     8010617e <getcallerpcs+0x3e>
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801061a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801061ae:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801061b1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801061b8:	39 c1                	cmp    %eax,%ecx
801061ba:	75 ec                	jne    801061a8 <getcallerpcs+0x68>
801061bc:	eb c0                	jmp    8010617e <getcallerpcs+0x3e>
801061be:	66 90                	xchg   %ax,%ax

801061c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	53                   	push   %ebx
801061c4:	83 ec 04             	sub    $0x4,%esp
801061c7:	9c                   	pushf
801061c8:	5b                   	pop    %ebx
  asm volatile("cli");
801061c9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801061ca:	e8 e1 ed ff ff       	call   80104fb0 <mycpu>
801061cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801061d5:	85 c0                	test   %eax,%eax
801061d7:	74 17                	je     801061f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801061d9:	e8 d2 ed ff ff       	call   80104fb0 <mycpu>
801061de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801061e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061e8:	c9                   	leave
801061e9:	c3                   	ret
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801061f0:	e8 bb ed ff ff       	call   80104fb0 <mycpu>
801061f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801061fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80106201:	eb d6                	jmp    801061d9 <pushcli+0x19>
80106203:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010620a:	00 
8010620b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106210 <popcli>:

void
popcli(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106216:	9c                   	pushf
80106217:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80106218:	f6 c4 02             	test   $0x2,%ah
8010621b:	75 35                	jne    80106252 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010621d:	e8 8e ed ff ff       	call   80104fb0 <mycpu>
80106222:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106229:	78 34                	js     8010625f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010622b:	e8 80 ed ff ff       	call   80104fb0 <mycpu>
80106230:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80106236:	85 d2                	test   %edx,%edx
80106238:	74 06                	je     80106240 <popcli+0x30>
    sti();
}
8010623a:	c9                   	leave
8010623b:	c3                   	ret
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106240:	e8 6b ed ff ff       	call   80104fb0 <mycpu>
80106245:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010624b:	85 c0                	test   %eax,%eax
8010624d:	74 eb                	je     8010623a <popcli+0x2a>
  asm volatile("sti");
8010624f:	fb                   	sti
}
80106250:	c9                   	leave
80106251:	c3                   	ret
    panic("popcli - interruptible");
80106252:	83 ec 0c             	sub    $0xc,%esp
80106255:	68 50 9a 10 80       	push   $0x80109a50
8010625a:	e8 f1 a2 ff ff       	call   80100550 <panic>
    panic("popcli");
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	68 67 9a 10 80       	push   $0x80109a67
80106267:	e8 e4 a2 ff ff       	call   80100550 <panic>
8010626c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106270 <holding>:
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	56                   	push   %esi
80106274:	53                   	push   %ebx
80106275:	8b 75 08             	mov    0x8(%ebp),%esi
80106278:	31 db                	xor    %ebx,%ebx
  pushcli();
8010627a:	e8 41 ff ff ff       	call   801061c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010627f:	8b 06                	mov    (%esi),%eax
80106281:	85 c0                	test   %eax,%eax
80106283:	75 0b                	jne    80106290 <holding+0x20>
  popcli();
80106285:	e8 86 ff ff ff       	call   80106210 <popcli>
}
8010628a:	89 d8                	mov    %ebx,%eax
8010628c:	5b                   	pop    %ebx
8010628d:	5e                   	pop    %esi
8010628e:	5d                   	pop    %ebp
8010628f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80106290:	8b 5e 08             	mov    0x8(%esi),%ebx
80106293:	e8 18 ed ff ff       	call   80104fb0 <mycpu>
80106298:	39 c3                	cmp    %eax,%ebx
8010629a:	0f 94 c3             	sete   %bl
  popcli();
8010629d:	e8 6e ff ff ff       	call   80106210 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801062a2:	0f b6 db             	movzbl %bl,%ebx
}
801062a5:	89 d8                	mov    %ebx,%eax
801062a7:	5b                   	pop    %ebx
801062a8:	5e                   	pop    %esi
801062a9:	5d                   	pop    %ebp
801062aa:	c3                   	ret
801062ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801062b0 <release>:
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	56                   	push   %esi
801062b4:	53                   	push   %ebx
801062b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801062b8:	e8 03 ff ff ff       	call   801061c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801062bd:	8b 03                	mov    (%ebx),%eax
801062bf:	85 c0                	test   %eax,%eax
801062c1:	75 15                	jne    801062d8 <release+0x28>
  popcli();
801062c3:	e8 48 ff ff ff       	call   80106210 <popcli>
    panic("release");
801062c8:	83 ec 0c             	sub    $0xc,%esp
801062cb:	68 6e 9a 10 80       	push   $0x80109a6e
801062d0:	e8 7b a2 ff ff       	call   80100550 <panic>
801062d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801062d8:	8b 73 08             	mov    0x8(%ebx),%esi
801062db:	e8 d0 ec ff ff       	call   80104fb0 <mycpu>
801062e0:	39 c6                	cmp    %eax,%esi
801062e2:	75 df                	jne    801062c3 <release+0x13>
  popcli();
801062e4:	e8 27 ff ff ff       	call   80106210 <popcli>
  lk->pcs[0] = 0;
801062e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801062f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801062f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801062fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80106302:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106305:	5b                   	pop    %ebx
80106306:	5e                   	pop    %esi
80106307:	5d                   	pop    %ebp
  popcli();
80106308:	e9 03 ff ff ff       	jmp    80106210 <popcli>
8010630d:	8d 76 00             	lea    0x0(%esi),%esi

80106310 <acquire>:
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	53                   	push   %ebx
80106314:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106317:	e8 a4 fe ff ff       	call   801061c0 <pushcli>
  if(holding(lk))
8010631c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010631f:	e8 9c fe ff ff       	call   801061c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106324:	8b 03                	mov    (%ebx),%eax
80106326:	85 c0                	test   %eax,%eax
80106328:	0f 85 b2 00 00 00    	jne    801063e0 <acquire+0xd0>
  popcli();
8010632e:	e8 dd fe ff ff       	call   80106210 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80106333:	b9 01 00 00 00       	mov    $0x1,%ecx
80106338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010633f:	00 
  while(xchg(&lk->locked, 1) != 0)
80106340:	8b 55 08             	mov    0x8(%ebp),%edx
80106343:	89 c8                	mov    %ecx,%eax
80106345:	f0 87 02             	lock xchg %eax,(%edx)
80106348:	85 c0                	test   %eax,%eax
8010634a:	75 f4                	jne    80106340 <acquire+0x30>
  __sync_synchronize();
8010634c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80106351:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106354:	e8 57 ec ff ff       	call   80104fb0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80106359:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010635c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010635e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106361:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80106367:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010636c:	77 32                	ja     801063a0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010636e:	89 e8                	mov    %ebp,%eax
80106370:	eb 14                	jmp    80106386 <acquire+0x76>
80106372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106378:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010637e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80106384:	77 1a                	ja     801063a0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80106386:	8b 58 04             	mov    0x4(%eax),%ebx
80106389:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010638d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80106390:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80106392:	83 fa 0a             	cmp    $0xa,%edx
80106395:	75 e1                	jne    80106378 <acquire+0x68>
}
80106397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010639a:	c9                   	leave
8010639b:	c3                   	ret
8010639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063a0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801063a4:	83 c1 34             	add    $0x34,%ecx
801063a7:	89 ca                	mov    %ecx,%edx
801063a9:	29 c2                	sub    %eax,%edx
801063ab:	83 e2 04             	and    $0x4,%edx
801063ae:	74 10                	je     801063c0 <acquire+0xb0>
    pcs[i] = 0;
801063b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801063b6:	83 c0 04             	add    $0x4,%eax
801063b9:	39 c1                	cmp    %eax,%ecx
801063bb:	74 da                	je     80106397 <acquire+0x87>
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801063c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801063c6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801063c9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801063d0:	39 c1                	cmp    %eax,%ecx
801063d2:	75 ec                	jne    801063c0 <acquire+0xb0>
801063d4:	eb c1                	jmp    80106397 <acquire+0x87>
801063d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063dd:	00 
801063de:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801063e0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801063e3:	e8 c8 eb ff ff       	call   80104fb0 <mycpu>
801063e8:	39 c3                	cmp    %eax,%ebx
801063ea:	0f 85 3e ff ff ff    	jne    8010632e <acquire+0x1e>
  popcli();
801063f0:	e8 1b fe ff ff       	call   80106210 <popcli>
    panic("acquire");
801063f5:	83 ec 0c             	sub    $0xc,%esp
801063f8:	68 76 9a 10 80       	push   $0x80109a76
801063fd:	e8 4e a1 ff ff       	call   80100550 <panic>
80106402:	66 90                	xchg   %ax,%ax
80106404:	66 90                	xchg   %ax,%ax
80106406:	66 90                	xchg   %ax,%ax
80106408:	66 90                	xchg   %ax,%ax
8010640a:	66 90                	xchg   %ax,%ax
8010640c:	66 90                	xchg   %ax,%ax
8010640e:	66 90                	xchg   %ax,%ax

80106410 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	8b 55 08             	mov    0x8(%ebp),%edx
80106417:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010641a:	89 d0                	mov    %edx,%eax
8010641c:	09 c8                	or     %ecx,%eax
8010641e:	a8 03                	test   $0x3,%al
80106420:	75 1e                	jne    80106440 <memset+0x30>
    c &= 0xFF;
80106422:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106426:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80106429:	89 d7                	mov    %edx,%edi
8010642b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80106431:	fc                   	cld
80106432:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80106434:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106437:	89 d0                	mov    %edx,%eax
80106439:	c9                   	leave
8010643a:	c3                   	ret
8010643b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80106440:	8b 45 0c             	mov    0xc(%ebp),%eax
80106443:	89 d7                	mov    %edx,%edi
80106445:	fc                   	cld
80106446:	f3 aa                	rep stos %al,%es:(%edi)
80106448:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010644b:	89 d0                	mov    %edx,%eax
8010644d:	c9                   	leave
8010644e:	c3                   	ret
8010644f:	90                   	nop

80106450 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	56                   	push   %esi
80106454:	8b 75 10             	mov    0x10(%ebp),%esi
80106457:	8b 45 08             	mov    0x8(%ebp),%eax
8010645a:	53                   	push   %ebx
8010645b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010645e:	85 f6                	test   %esi,%esi
80106460:	74 2e                	je     80106490 <memcmp+0x40>
80106462:	01 c6                	add    %eax,%esi
80106464:	eb 14                	jmp    8010647a <memcmp+0x2a>
80106466:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010646d:	00 
8010646e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80106470:	83 c0 01             	add    $0x1,%eax
80106473:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80106476:	39 f0                	cmp    %esi,%eax
80106478:	74 16                	je     80106490 <memcmp+0x40>
    if(*s1 != *s2)
8010647a:	0f b6 08             	movzbl (%eax),%ecx
8010647d:	0f b6 1a             	movzbl (%edx),%ebx
80106480:	38 d9                	cmp    %bl,%cl
80106482:	74 ec                	je     80106470 <memcmp+0x20>
      return *s1 - *s2;
80106484:	0f b6 c1             	movzbl %cl,%eax
80106487:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80106489:	5b                   	pop    %ebx
8010648a:	5e                   	pop    %esi
8010648b:	5d                   	pop    %ebp
8010648c:	c3                   	ret
8010648d:	8d 76 00             	lea    0x0(%esi),%esi
80106490:	5b                   	pop    %ebx
  return 0;
80106491:	31 c0                	xor    %eax,%eax
}
80106493:	5e                   	pop    %esi
80106494:	5d                   	pop    %ebp
80106495:	c3                   	ret
80106496:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010649d:	00 
8010649e:	66 90                	xchg   %ax,%ax

801064a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	8b 55 08             	mov    0x8(%ebp),%edx
801064a7:	8b 45 10             	mov    0x10(%ebp),%eax
801064aa:	56                   	push   %esi
801064ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801064ae:	39 d6                	cmp    %edx,%esi
801064b0:	73 26                	jae    801064d8 <memmove+0x38>
801064b2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801064b5:	39 ca                	cmp    %ecx,%edx
801064b7:	73 1f                	jae    801064d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801064b9:	85 c0                	test   %eax,%eax
801064bb:	74 0f                	je     801064cc <memmove+0x2c>
801064bd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801064c0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801064c4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801064c7:	83 e8 01             	sub    $0x1,%eax
801064ca:	73 f4                	jae    801064c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801064cc:	5e                   	pop    %esi
801064cd:	89 d0                	mov    %edx,%eax
801064cf:	5f                   	pop    %edi
801064d0:	5d                   	pop    %ebp
801064d1:	c3                   	ret
801064d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801064d8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801064db:	89 d7                	mov    %edx,%edi
801064dd:	85 c0                	test   %eax,%eax
801064df:	74 eb                	je     801064cc <memmove+0x2c>
801064e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801064e8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801064e9:	39 ce                	cmp    %ecx,%esi
801064eb:	75 fb                	jne    801064e8 <memmove+0x48>
}
801064ed:	5e                   	pop    %esi
801064ee:	89 d0                	mov    %edx,%eax
801064f0:	5f                   	pop    %edi
801064f1:	5d                   	pop    %ebp
801064f2:	c3                   	ret
801064f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064fa:	00 
801064fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106500 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80106500:	eb 9e                	jmp    801064a0 <memmove>
80106502:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106509:	00 
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106510 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	53                   	push   %ebx
80106514:	8b 55 10             	mov    0x10(%ebp),%edx
80106517:	8b 45 08             	mov    0x8(%ebp),%eax
8010651a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010651d:	85 d2                	test   %edx,%edx
8010651f:	75 16                	jne    80106537 <strncmp+0x27>
80106521:	eb 2d                	jmp    80106550 <strncmp+0x40>
80106523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106528:	3a 19                	cmp    (%ecx),%bl
8010652a:	75 12                	jne    8010653e <strncmp+0x2e>
    n--, p++, q++;
8010652c:	83 c0 01             	add    $0x1,%eax
8010652f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80106532:	83 ea 01             	sub    $0x1,%edx
80106535:	74 19                	je     80106550 <strncmp+0x40>
80106537:	0f b6 18             	movzbl (%eax),%ebx
8010653a:	84 db                	test   %bl,%bl
8010653c:	75 ea                	jne    80106528 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010653e:	0f b6 00             	movzbl (%eax),%eax
80106541:	0f b6 11             	movzbl (%ecx),%edx
}
80106544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106547:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80106548:	29 d0                	sub    %edx,%eax
}
8010654a:	c3                   	ret
8010654b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80106553:	31 c0                	xor    %eax,%eax
}
80106555:	c9                   	leave
80106556:	c3                   	ret
80106557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010655e:	00 
8010655f:	90                   	nop

80106560 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	57                   	push   %edi
80106564:	56                   	push   %esi
80106565:	8b 75 08             	mov    0x8(%ebp),%esi
80106568:	53                   	push   %ebx
80106569:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010656c:	89 f0                	mov    %esi,%eax
8010656e:	eb 15                	jmp    80106585 <strncpy+0x25>
80106570:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80106574:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106577:	83 c0 01             	add    $0x1,%eax
8010657a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010657e:	88 48 ff             	mov    %cl,-0x1(%eax)
80106581:	84 c9                	test   %cl,%cl
80106583:	74 13                	je     80106598 <strncpy+0x38>
80106585:	89 d3                	mov    %edx,%ebx
80106587:	83 ea 01             	sub    $0x1,%edx
8010658a:	85 db                	test   %ebx,%ebx
8010658c:	7f e2                	jg     80106570 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010658e:	5b                   	pop    %ebx
8010658f:	89 f0                	mov    %esi,%eax
80106591:	5e                   	pop    %esi
80106592:	5f                   	pop    %edi
80106593:	5d                   	pop    %ebp
80106594:	c3                   	ret
80106595:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80106598:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010659b:	83 e9 01             	sub    $0x1,%ecx
8010659e:	85 d2                	test   %edx,%edx
801065a0:	74 ec                	je     8010658e <strncpy+0x2e>
801065a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801065a8:	83 c0 01             	add    $0x1,%eax
801065ab:	89 ca                	mov    %ecx,%edx
801065ad:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801065b1:	29 c2                	sub    %eax,%edx
801065b3:	85 d2                	test   %edx,%edx
801065b5:	7f f1                	jg     801065a8 <strncpy+0x48>
}
801065b7:	5b                   	pop    %ebx
801065b8:	89 f0                	mov    %esi,%eax
801065ba:	5e                   	pop    %esi
801065bb:	5f                   	pop    %edi
801065bc:	5d                   	pop    %ebp
801065bd:	c3                   	ret
801065be:	66 90                	xchg   %ax,%ax

801065c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	56                   	push   %esi
801065c4:	8b 55 10             	mov    0x10(%ebp),%edx
801065c7:	8b 75 08             	mov    0x8(%ebp),%esi
801065ca:	53                   	push   %ebx
801065cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801065ce:	85 d2                	test   %edx,%edx
801065d0:	7e 25                	jle    801065f7 <safestrcpy+0x37>
801065d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801065d6:	89 f2                	mov    %esi,%edx
801065d8:	eb 16                	jmp    801065f0 <safestrcpy+0x30>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801065e0:	0f b6 08             	movzbl (%eax),%ecx
801065e3:	83 c0 01             	add    $0x1,%eax
801065e6:	83 c2 01             	add    $0x1,%edx
801065e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801065ec:	84 c9                	test   %cl,%cl
801065ee:	74 04                	je     801065f4 <safestrcpy+0x34>
801065f0:	39 d8                	cmp    %ebx,%eax
801065f2:	75 ec                	jne    801065e0 <safestrcpy+0x20>
    ;
  *s = 0;
801065f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801065f7:	89 f0                	mov    %esi,%eax
801065f9:	5b                   	pop    %ebx
801065fa:	5e                   	pop    %esi
801065fb:	5d                   	pop    %ebp
801065fc:	c3                   	ret
801065fd:	8d 76 00             	lea    0x0(%esi),%esi

80106600 <strlen>:

int
strlen(const char *s)
{
80106600:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80106601:	31 c0                	xor    %eax,%eax
{
80106603:	89 e5                	mov    %esp,%ebp
80106605:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80106608:	80 3a 00             	cmpb   $0x0,(%edx)
8010660b:	74 0c                	je     80106619 <strlen+0x19>
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
80106610:	83 c0 01             	add    $0x1,%eax
80106613:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80106617:	75 f7                	jne    80106610 <strlen+0x10>
    ;
  return n;
}
80106619:	5d                   	pop    %ebp
8010661a:	c3                   	ret

8010661b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010661b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010661f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80106623:	55                   	push   %ebp
  pushl %ebx
80106624:	53                   	push   %ebx
  pushl %esi
80106625:	56                   	push   %esi
  pushl %edi
80106626:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106627:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106629:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010662b:	5f                   	pop    %edi
  popl %esi
8010662c:	5e                   	pop    %esi
  popl %ebx
8010662d:	5b                   	pop    %ebx
  popl %ebp
8010662e:	5d                   	pop    %ebp
  ret
8010662f:	c3                   	ret

80106630 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	53                   	push   %ebx
80106634:	83 ec 04             	sub    $0x4,%esp
80106637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010663a:	e8 f1 e9 ff ff       	call   80105030 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010663f:	8b 00                	mov    (%eax),%eax
80106641:	39 c3                	cmp    %eax,%ebx
80106643:	73 1b                	jae    80106660 <fetchint+0x30>
80106645:	8d 53 04             	lea    0x4(%ebx),%edx
80106648:	39 d0                	cmp    %edx,%eax
8010664a:	72 14                	jb     80106660 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010664c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010664f:	8b 13                	mov    (%ebx),%edx
80106651:	89 10                	mov    %edx,(%eax)
  return 0;
80106653:	31 c0                	xor    %eax,%eax
}
80106655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106658:	c9                   	leave
80106659:	c3                   	ret
8010665a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106665:	eb ee                	jmp    80106655 <fetchint+0x25>
80106667:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010666e:	00 
8010666f:	90                   	nop

80106670 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	53                   	push   %ebx
80106674:	83 ec 04             	sub    $0x4,%esp
80106677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010667a:	e8 b1 e9 ff ff       	call   80105030 <myproc>

  if(addr >= curproc->sz)
8010667f:	3b 18                	cmp    (%eax),%ebx
80106681:	73 2d                	jae    801066b0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80106683:	8b 55 0c             	mov    0xc(%ebp),%edx
80106686:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80106688:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010668a:	39 d3                	cmp    %edx,%ebx
8010668c:	73 22                	jae    801066b0 <fetchstr+0x40>
8010668e:	89 d8                	mov    %ebx,%eax
80106690:	eb 0d                	jmp    8010669f <fetchstr+0x2f>
80106692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106698:	83 c0 01             	add    $0x1,%eax
8010669b:	39 d0                	cmp    %edx,%eax
8010669d:	73 11                	jae    801066b0 <fetchstr+0x40>
    if(*s == 0)
8010669f:	80 38 00             	cmpb   $0x0,(%eax)
801066a2:	75 f4                	jne    80106698 <fetchstr+0x28>
      return s - *pp;
801066a4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801066a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066a9:	c9                   	leave
801066aa:	c3                   	ret
801066ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801066b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801066b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066b8:	c9                   	leave
801066b9:	c3                   	ret
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	56                   	push   %esi
801066c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066c5:	e8 66 e9 ff ff       	call   80105030 <myproc>
801066ca:	8b 55 08             	mov    0x8(%ebp),%edx
801066cd:	8b 40 18             	mov    0x18(%eax),%eax
801066d0:	8b 40 44             	mov    0x44(%eax),%eax
801066d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801066d6:	e8 55 e9 ff ff       	call   80105030 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801066de:	8b 00                	mov    (%eax),%eax
801066e0:	39 c6                	cmp    %eax,%esi
801066e2:	73 1c                	jae    80106700 <argint+0x40>
801066e4:	8d 53 08             	lea    0x8(%ebx),%edx
801066e7:	39 d0                	cmp    %edx,%eax
801066e9:	72 15                	jb     80106700 <argint+0x40>
  *ip = *(int*)(addr);
801066eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801066ee:	8b 53 04             	mov    0x4(%ebx),%edx
801066f1:	89 10                	mov    %edx,(%eax)
  return 0;
801066f3:	31 c0                	xor    %eax,%eax
}
801066f5:	5b                   	pop    %ebx
801066f6:	5e                   	pop    %esi
801066f7:	5d                   	pop    %ebp
801066f8:	c3                   	ret
801066f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106705:	eb ee                	jmp    801066f5 <argint+0x35>
80106707:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010670e:	00 
8010670f:	90                   	nop

80106710 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
80106715:	53                   	push   %ebx
80106716:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106719:	e8 12 e9 ff ff       	call   80105030 <myproc>
8010671e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106720:	e8 0b e9 ff ff       	call   80105030 <myproc>
80106725:	8b 55 08             	mov    0x8(%ebp),%edx
80106728:	8b 40 18             	mov    0x18(%eax),%eax
8010672b:	8b 40 44             	mov    0x44(%eax),%eax
8010672e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106731:	e8 fa e8 ff ff       	call   80105030 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106736:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106739:	8b 00                	mov    (%eax),%eax
8010673b:	39 c7                	cmp    %eax,%edi
8010673d:	73 31                	jae    80106770 <argptr+0x60>
8010673f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106742:	39 c8                	cmp    %ecx,%eax
80106744:	72 2a                	jb     80106770 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106746:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106749:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010674c:	85 d2                	test   %edx,%edx
8010674e:	78 20                	js     80106770 <argptr+0x60>
80106750:	8b 16                	mov    (%esi),%edx
80106752:	39 d0                	cmp    %edx,%eax
80106754:	73 1a                	jae    80106770 <argptr+0x60>
80106756:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106759:	01 c3                	add    %eax,%ebx
8010675b:	39 da                	cmp    %ebx,%edx
8010675d:	72 11                	jb     80106770 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010675f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106762:	89 02                	mov    %eax,(%edx)
  return 0;
80106764:	31 c0                	xor    %eax,%eax
}
80106766:	83 c4 0c             	add    $0xc,%esp
80106769:	5b                   	pop    %ebx
8010676a:	5e                   	pop    %esi
8010676b:	5f                   	pop    %edi
8010676c:	5d                   	pop    %ebp
8010676d:	c3                   	ret
8010676e:	66 90                	xchg   %ax,%ax
    return -1;
80106770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106775:	eb ef                	jmp    80106766 <argptr+0x56>
80106777:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010677e:	00 
8010677f:	90                   	nop

80106780 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	56                   	push   %esi
80106784:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106785:	e8 a6 e8 ff ff       	call   80105030 <myproc>
8010678a:	8b 55 08             	mov    0x8(%ebp),%edx
8010678d:	8b 40 18             	mov    0x18(%eax),%eax
80106790:	8b 40 44             	mov    0x44(%eax),%eax
80106793:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106796:	e8 95 e8 ff ff       	call   80105030 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010679b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010679e:	8b 00                	mov    (%eax),%eax
801067a0:	39 c6                	cmp    %eax,%esi
801067a2:	73 44                	jae    801067e8 <argstr+0x68>
801067a4:	8d 53 08             	lea    0x8(%ebx),%edx
801067a7:	39 d0                	cmp    %edx,%eax
801067a9:	72 3d                	jb     801067e8 <argstr+0x68>
  *ip = *(int*)(addr);
801067ab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801067ae:	e8 7d e8 ff ff       	call   80105030 <myproc>
  if(addr >= curproc->sz)
801067b3:	3b 18                	cmp    (%eax),%ebx
801067b5:	73 31                	jae    801067e8 <argstr+0x68>
  *pp = (char*)addr;
801067b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801067ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801067bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801067be:	39 d3                	cmp    %edx,%ebx
801067c0:	73 26                	jae    801067e8 <argstr+0x68>
801067c2:	89 d8                	mov    %ebx,%eax
801067c4:	eb 11                	jmp    801067d7 <argstr+0x57>
801067c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067cd:	00 
801067ce:	66 90                	xchg   %ax,%ax
801067d0:	83 c0 01             	add    $0x1,%eax
801067d3:	39 d0                	cmp    %edx,%eax
801067d5:	73 11                	jae    801067e8 <argstr+0x68>
    if(*s == 0)
801067d7:	80 38 00             	cmpb   $0x0,(%eax)
801067da:	75 f4                	jne    801067d0 <argstr+0x50>
      return s - *pp;
801067dc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801067de:	5b                   	pop    %ebx
801067df:	5e                   	pop    %esi
801067e0:	5d                   	pop    %ebp
801067e1:	c3                   	ret
801067e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067e8:	5b                   	pop    %ebx
    return -1;
801067e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067ee:	5e                   	pop    %esi
801067ef:	5d                   	pop    %ebp
801067f0:	c3                   	ret
801067f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067f8:	00 
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106800 <syscall>:

};

void
syscall(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	53                   	push   %ebx
80106804:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106807:	e8 24 e8 ff ff       	call   80105030 <myproc>
8010680c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010680e:	8b 40 18             	mov    0x18(%eax),%eax
80106811:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106814:	8d 50 ff             	lea    -0x1(%eax),%edx
80106817:	83 fa 1c             	cmp    $0x1c,%edx
8010681a:	77 24                	ja     80106840 <syscall+0x40>
8010681c:	8b 14 85 a0 a0 10 80 	mov    -0x7fef5f60(,%eax,4),%edx
80106823:	85 d2                	test   %edx,%edx
80106825:	74 19                	je     80106840 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80106827:	ff d2                	call   *%edx
80106829:	89 c2                	mov    %eax,%edx
8010682b:	8b 43 18             	mov    0x18(%ebx),%eax
8010682e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80106831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106834:	c9                   	leave
80106835:	c3                   	ret
80106836:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010683d:	00 
8010683e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80106840:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106841:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106844:	50                   	push   %eax
80106845:	ff 73 10             	push   0x10(%ebx)
80106848:	68 7e 9a 10 80       	push   $0x80109a7e
8010684d:	e8 0e a5 ff ff       	call   80100d60 <cprintf>
    curproc->tf->eax = -1;
80106852:	8b 43 18             	mov    0x18(%ebx),%eax
80106855:	83 c4 10             	add    $0x10,%esp
80106858:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010685f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106862:	c9                   	leave
80106863:	c3                   	ret
80106864:	66 90                	xchg   %ax,%ax
80106866:	66 90                	xchg   %ax,%ax
80106868:	66 90                	xchg   %ax,%ax
8010686a:	66 90                	xchg   %ax,%ax
8010686c:	66 90                	xchg   %ax,%ax
8010686e:	66 90                	xchg   %ax,%ax

80106870 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106875:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106878:	53                   	push   %ebx
80106879:	83 ec 34             	sub    $0x34,%esp
8010687c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010687f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106882:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106885:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80106888:	57                   	push   %edi
80106889:	50                   	push   %eax
8010688a:	e8 b1 cd ff ff       	call   80103640 <nameiparent>
8010688f:	83 c4 10             	add    $0x10,%esp
80106892:	85 c0                	test   %eax,%eax
80106894:	74 5e                	je     801068f4 <create+0x84>
    return 0;
  ilock(dp);
80106896:	83 ec 0c             	sub    $0xc,%esp
80106899:	89 c3                	mov    %eax,%ebx
8010689b:	50                   	push   %eax
8010689c:	e8 9f c4 ff ff       	call   80102d40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801068a1:	83 c4 0c             	add    $0xc,%esp
801068a4:	6a 00                	push   $0x0
801068a6:	57                   	push   %edi
801068a7:	53                   	push   %ebx
801068a8:	e8 e3 c9 ff ff       	call   80103290 <dirlookup>
801068ad:	83 c4 10             	add    $0x10,%esp
801068b0:	89 c6                	mov    %eax,%esi
801068b2:	85 c0                	test   %eax,%eax
801068b4:	74 4a                	je     80106900 <create+0x90>
    iunlockput(dp);
801068b6:	83 ec 0c             	sub    $0xc,%esp
801068b9:	53                   	push   %ebx
801068ba:	e8 11 c7 ff ff       	call   80102fd0 <iunlockput>
    ilock(ip);
801068bf:	89 34 24             	mov    %esi,(%esp)
801068c2:	e8 79 c4 ff ff       	call   80102d40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801068c7:	83 c4 10             	add    $0x10,%esp
801068ca:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801068cf:	75 17                	jne    801068e8 <create+0x78>
801068d1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801068d6:	75 10                	jne    801068e8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801068d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068db:	89 f0                	mov    %esi,%eax
801068dd:	5b                   	pop    %ebx
801068de:	5e                   	pop    %esi
801068df:	5f                   	pop    %edi
801068e0:	5d                   	pop    %ebp
801068e1:	c3                   	ret
801068e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801068e8:	83 ec 0c             	sub    $0xc,%esp
801068eb:	56                   	push   %esi
801068ec:	e8 df c6 ff ff       	call   80102fd0 <iunlockput>
    return 0;
801068f1:	83 c4 10             	add    $0x10,%esp
}
801068f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801068f7:	31 f6                	xor    %esi,%esi
}
801068f9:	5b                   	pop    %ebx
801068fa:	89 f0                	mov    %esi,%eax
801068fc:	5e                   	pop    %esi
801068fd:	5f                   	pop    %edi
801068fe:	5d                   	pop    %ebp
801068ff:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80106900:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106904:	83 ec 08             	sub    $0x8,%esp
80106907:	50                   	push   %eax
80106908:	ff 33                	push   (%ebx)
8010690a:	e8 c1 c2 ff ff       	call   80102bd0 <ialloc>
8010690f:	83 c4 10             	add    $0x10,%esp
80106912:	89 c6                	mov    %eax,%esi
80106914:	85 c0                	test   %eax,%eax
80106916:	0f 84 bc 00 00 00    	je     801069d8 <create+0x168>
  ilock(ip);
8010691c:	83 ec 0c             	sub    $0xc,%esp
8010691f:	50                   	push   %eax
80106920:	e8 1b c4 ff ff       	call   80102d40 <ilock>
  ip->major = major;
80106925:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106929:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010692d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106931:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106935:	b8 01 00 00 00       	mov    $0x1,%eax
8010693a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010693e:	89 34 24             	mov    %esi,(%esp)
80106941:	e8 4a c3 ff ff       	call   80102c90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106946:	83 c4 10             	add    $0x10,%esp
80106949:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010694e:	74 30                	je     80106980 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80106950:	83 ec 04             	sub    $0x4,%esp
80106953:	ff 76 04             	push   0x4(%esi)
80106956:	57                   	push   %edi
80106957:	53                   	push   %ebx
80106958:	e8 03 cc ff ff       	call   80103560 <dirlink>
8010695d:	83 c4 10             	add    $0x10,%esp
80106960:	85 c0                	test   %eax,%eax
80106962:	78 67                	js     801069cb <create+0x15b>
  iunlockput(dp);
80106964:	83 ec 0c             	sub    $0xc,%esp
80106967:	53                   	push   %ebx
80106968:	e8 63 c6 ff ff       	call   80102fd0 <iunlockput>
  return ip;
8010696d:	83 c4 10             	add    $0x10,%esp
}
80106970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106973:	89 f0                	mov    %esi,%eax
80106975:	5b                   	pop    %ebx
80106976:	5e                   	pop    %esi
80106977:	5f                   	pop    %edi
80106978:	5d                   	pop    %ebp
80106979:	c3                   	ret
8010697a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106980:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106983:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106988:	53                   	push   %ebx
80106989:	e8 02 c3 ff ff       	call   80102c90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010698e:	83 c4 0c             	add    $0xc,%esp
80106991:	ff 76 04             	push   0x4(%esi)
80106994:	68 b6 9a 10 80       	push   $0x80109ab6
80106999:	56                   	push   %esi
8010699a:	e8 c1 cb ff ff       	call   80103560 <dirlink>
8010699f:	83 c4 10             	add    $0x10,%esp
801069a2:	85 c0                	test   %eax,%eax
801069a4:	78 18                	js     801069be <create+0x14e>
801069a6:	83 ec 04             	sub    $0x4,%esp
801069a9:	ff 73 04             	push   0x4(%ebx)
801069ac:	68 b5 9a 10 80       	push   $0x80109ab5
801069b1:	56                   	push   %esi
801069b2:	e8 a9 cb ff ff       	call   80103560 <dirlink>
801069b7:	83 c4 10             	add    $0x10,%esp
801069ba:	85 c0                	test   %eax,%eax
801069bc:	79 92                	jns    80106950 <create+0xe0>
      panic("create dots");
801069be:	83 ec 0c             	sub    $0xc,%esp
801069c1:	68 a9 9a 10 80       	push   $0x80109aa9
801069c6:	e8 85 9b ff ff       	call   80100550 <panic>
    panic("create: dirlink");
801069cb:	83 ec 0c             	sub    $0xc,%esp
801069ce:	68 b8 9a 10 80       	push   $0x80109ab8
801069d3:	e8 78 9b ff ff       	call   80100550 <panic>
    panic("create: ialloc");
801069d8:	83 ec 0c             	sub    $0xc,%esp
801069db:	68 9a 9a 10 80       	push   $0x80109a9a
801069e0:	e8 6b 9b ff ff       	call   80100550 <panic>
801069e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069ec:	00 
801069ed:	8d 76 00             	lea    0x0(%esi),%esi

801069f0 <sys_dup>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	56                   	push   %esi
801069f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801069f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801069f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801069fb:	50                   	push   %eax
801069fc:	6a 00                	push   $0x0
801069fe:	e8 bd fc ff ff       	call   801066c0 <argint>
80106a03:	83 c4 10             	add    $0x10,%esp
80106a06:	85 c0                	test   %eax,%eax
80106a08:	78 36                	js     80106a40 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106a0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a0e:	77 30                	ja     80106a40 <sys_dup+0x50>
80106a10:	e8 1b e6 ff ff       	call   80105030 <myproc>
80106a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a1c:	85 f6                	test   %esi,%esi
80106a1e:	74 20                	je     80106a40 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106a20:	e8 0b e6 ff ff       	call   80105030 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106a25:	31 db                	xor    %ebx,%ebx
80106a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a2e:	00 
80106a2f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80106a30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106a34:	85 d2                	test   %edx,%edx
80106a36:	74 18                	je     80106a50 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106a38:	83 c3 01             	add    $0x1,%ebx
80106a3b:	83 fb 10             	cmp    $0x10,%ebx
80106a3e:	75 f0                	jne    80106a30 <sys_dup+0x40>
}
80106a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106a43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106a48:	89 d8                	mov    %ebx,%eax
80106a4a:	5b                   	pop    %ebx
80106a4b:	5e                   	pop    %esi
80106a4c:	5d                   	pop    %ebp
80106a4d:	c3                   	ret
80106a4e:	66 90                	xchg   %ax,%ax
  filedup(f);
80106a50:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106a53:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106a57:	56                   	push   %esi
80106a58:	e8 03 ba ff ff       	call   80102460 <filedup>
  return fd;
80106a5d:	83 c4 10             	add    $0x10,%esp
}
80106a60:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a63:	89 d8                	mov    %ebx,%eax
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5d                   	pop    %ebp
80106a68:	c3                   	ret
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a70 <sys_read>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	56                   	push   %esi
80106a74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106a75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106a78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106a7b:	53                   	push   %ebx
80106a7c:	6a 00                	push   $0x0
80106a7e:	e8 3d fc ff ff       	call   801066c0 <argint>
80106a83:	83 c4 10             	add    $0x10,%esp
80106a86:	85 c0                	test   %eax,%eax
80106a88:	78 5e                	js     80106ae8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106a8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a8e:	77 58                	ja     80106ae8 <sys_read+0x78>
80106a90:	e8 9b e5 ff ff       	call   80105030 <myproc>
80106a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a9c:	85 f6                	test   %esi,%esi
80106a9e:	74 48                	je     80106ae8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106aa0:	83 ec 08             	sub    $0x8,%esp
80106aa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aa6:	50                   	push   %eax
80106aa7:	6a 02                	push   $0x2
80106aa9:	e8 12 fc ff ff       	call   801066c0 <argint>
80106aae:	83 c4 10             	add    $0x10,%esp
80106ab1:	85 c0                	test   %eax,%eax
80106ab3:	78 33                	js     80106ae8 <sys_read+0x78>
80106ab5:	83 ec 04             	sub    $0x4,%esp
80106ab8:	ff 75 f0             	push   -0x10(%ebp)
80106abb:	53                   	push   %ebx
80106abc:	6a 01                	push   $0x1
80106abe:	e8 4d fc ff ff       	call   80106710 <argptr>
80106ac3:	83 c4 10             	add    $0x10,%esp
80106ac6:	85 c0                	test   %eax,%eax
80106ac8:	78 1e                	js     80106ae8 <sys_read+0x78>
  return fileread(f, p, n);
80106aca:	83 ec 04             	sub    $0x4,%esp
80106acd:	ff 75 f0             	push   -0x10(%ebp)
80106ad0:	ff 75 f4             	push   -0xc(%ebp)
80106ad3:	56                   	push   %esi
80106ad4:	e8 07 bb ff ff       	call   801025e0 <fileread>
80106ad9:	83 c4 10             	add    $0x10,%esp
}
80106adc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106adf:	5b                   	pop    %ebx
80106ae0:	5e                   	pop    %esi
80106ae1:	5d                   	pop    %ebp
80106ae2:	c3                   	ret
80106ae3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aed:	eb ed                	jmp    80106adc <sys_read+0x6c>
80106aef:	90                   	nop

80106af0 <sys_write>:
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	56                   	push   %esi
80106af4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106af5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106af8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106afb:	53                   	push   %ebx
80106afc:	6a 00                	push   $0x0
80106afe:	e8 bd fb ff ff       	call   801066c0 <argint>
80106b03:	83 c4 10             	add    $0x10,%esp
80106b06:	85 c0                	test   %eax,%eax
80106b08:	78 5e                	js     80106b68 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106b0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106b0e:	77 58                	ja     80106b68 <sys_write+0x78>
80106b10:	e8 1b e5 ff ff       	call   80105030 <myproc>
80106b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106b1c:	85 f6                	test   %esi,%esi
80106b1e:	74 48                	je     80106b68 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106b20:	83 ec 08             	sub    $0x8,%esp
80106b23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b26:	50                   	push   %eax
80106b27:	6a 02                	push   $0x2
80106b29:	e8 92 fb ff ff       	call   801066c0 <argint>
80106b2e:	83 c4 10             	add    $0x10,%esp
80106b31:	85 c0                	test   %eax,%eax
80106b33:	78 33                	js     80106b68 <sys_write+0x78>
80106b35:	83 ec 04             	sub    $0x4,%esp
80106b38:	ff 75 f0             	push   -0x10(%ebp)
80106b3b:	53                   	push   %ebx
80106b3c:	6a 01                	push   $0x1
80106b3e:	e8 cd fb ff ff       	call   80106710 <argptr>
80106b43:	83 c4 10             	add    $0x10,%esp
80106b46:	85 c0                	test   %eax,%eax
80106b48:	78 1e                	js     80106b68 <sys_write+0x78>
  return filewrite(f, p, n);
80106b4a:	83 ec 04             	sub    $0x4,%esp
80106b4d:	ff 75 f0             	push   -0x10(%ebp)
80106b50:	ff 75 f4             	push   -0xc(%ebp)
80106b53:	56                   	push   %esi
80106b54:	e8 17 bb ff ff       	call   80102670 <filewrite>
80106b59:	83 c4 10             	add    $0x10,%esp
}
80106b5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b5f:	5b                   	pop    %ebx
80106b60:	5e                   	pop    %esi
80106b61:	5d                   	pop    %ebp
80106b62:	c3                   	ret
80106b63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6d:	eb ed                	jmp    80106b5c <sys_write+0x6c>
80106b6f:	90                   	nop

80106b70 <sys_close>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	56                   	push   %esi
80106b74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106b75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106b78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106b7b:	50                   	push   %eax
80106b7c:	6a 00                	push   $0x0
80106b7e:	e8 3d fb ff ff       	call   801066c0 <argint>
80106b83:	83 c4 10             	add    $0x10,%esp
80106b86:	85 c0                	test   %eax,%eax
80106b88:	78 3e                	js     80106bc8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106b8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106b8e:	77 38                	ja     80106bc8 <sys_close+0x58>
80106b90:	e8 9b e4 ff ff       	call   80105030 <myproc>
80106b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b98:	8d 5a 08             	lea    0x8(%edx),%ebx
80106b9b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106b9f:	85 f6                	test   %esi,%esi
80106ba1:	74 25                	je     80106bc8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106ba3:	e8 88 e4 ff ff       	call   80105030 <myproc>
  fileclose(f);
80106ba8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106bab:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106bb2:	00 
  fileclose(f);
80106bb3:	56                   	push   %esi
80106bb4:	e8 f7 b8 ff ff       	call   801024b0 <fileclose>
  return 0;
80106bb9:	83 c4 10             	add    $0x10,%esp
80106bbc:	31 c0                	xor    %eax,%eax
}
80106bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106bc1:	5b                   	pop    %ebx
80106bc2:	5e                   	pop    %esi
80106bc3:	5d                   	pop    %ebp
80106bc4:	c3                   	ret
80106bc5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bcd:	eb ef                	jmp    80106bbe <sys_close+0x4e>
80106bcf:	90                   	nop

80106bd0 <sys_fstat>:
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	56                   	push   %esi
80106bd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106bd5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106bd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106bdb:	53                   	push   %ebx
80106bdc:	6a 00                	push   $0x0
80106bde:	e8 dd fa ff ff       	call   801066c0 <argint>
80106be3:	83 c4 10             	add    $0x10,%esp
80106be6:	85 c0                	test   %eax,%eax
80106be8:	78 46                	js     80106c30 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106bea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106bee:	77 40                	ja     80106c30 <sys_fstat+0x60>
80106bf0:	e8 3b e4 ff ff       	call   80105030 <myproc>
80106bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bf8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106bfc:	85 f6                	test   %esi,%esi
80106bfe:	74 30                	je     80106c30 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106c00:	83 ec 04             	sub    $0x4,%esp
80106c03:	6a 14                	push   $0x14
80106c05:	53                   	push   %ebx
80106c06:	6a 01                	push   $0x1
80106c08:	e8 03 fb ff ff       	call   80106710 <argptr>
80106c0d:	83 c4 10             	add    $0x10,%esp
80106c10:	85 c0                	test   %eax,%eax
80106c12:	78 1c                	js     80106c30 <sys_fstat+0x60>
  return filestat(f, st);
80106c14:	83 ec 08             	sub    $0x8,%esp
80106c17:	ff 75 f4             	push   -0xc(%ebp)
80106c1a:	56                   	push   %esi
80106c1b:	e8 70 b9 ff ff       	call   80102590 <filestat>
80106c20:	83 c4 10             	add    $0x10,%esp
}
80106c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c26:	5b                   	pop    %ebx
80106c27:	5e                   	pop    %esi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c35:	eb ec                	jmp    80106c23 <sys_fstat+0x53>
80106c37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c3e:	00 
80106c3f:	90                   	nop

80106c40 <sys_link>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c45:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106c48:	53                   	push   %ebx
80106c49:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106c4c:	50                   	push   %eax
80106c4d:	6a 00                	push   $0x0
80106c4f:	e8 2c fb ff ff       	call   80106780 <argstr>
80106c54:	83 c4 10             	add    $0x10,%esp
80106c57:	85 c0                	test   %eax,%eax
80106c59:	0f 88 fb 00 00 00    	js     80106d5a <sys_link+0x11a>
80106c5f:	83 ec 08             	sub    $0x8,%esp
80106c62:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106c65:	50                   	push   %eax
80106c66:	6a 01                	push   $0x1
80106c68:	e8 13 fb ff ff       	call   80106780 <argstr>
80106c6d:	83 c4 10             	add    $0x10,%esp
80106c70:	85 c0                	test   %eax,%eax
80106c72:	0f 88 e2 00 00 00    	js     80106d5a <sys_link+0x11a>
  begin_op();
80106c78:	e8 63 d6 ff ff       	call   801042e0 <begin_op>
  if((ip = namei(old)) == 0){
80106c7d:	83 ec 0c             	sub    $0xc,%esp
80106c80:	ff 75 d4             	push   -0x2c(%ebp)
80106c83:	e8 98 c9 ff ff       	call   80103620 <namei>
80106c88:	83 c4 10             	add    $0x10,%esp
80106c8b:	89 c3                	mov    %eax,%ebx
80106c8d:	85 c0                	test   %eax,%eax
80106c8f:	0f 84 df 00 00 00    	je     80106d74 <sys_link+0x134>
  ilock(ip);
80106c95:	83 ec 0c             	sub    $0xc,%esp
80106c98:	50                   	push   %eax
80106c99:	e8 a2 c0 ff ff       	call   80102d40 <ilock>
  if(ip->type == T_DIR){
80106c9e:	83 c4 10             	add    $0x10,%esp
80106ca1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106ca6:	0f 84 b5 00 00 00    	je     80106d61 <sys_link+0x121>
  iupdate(ip);
80106cac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106caf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106cb4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106cb7:	53                   	push   %ebx
80106cb8:	e8 d3 bf ff ff       	call   80102c90 <iupdate>
  iunlock(ip);
80106cbd:	89 1c 24             	mov    %ebx,(%esp)
80106cc0:	e8 5b c1 ff ff       	call   80102e20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106cc5:	58                   	pop    %eax
80106cc6:	5a                   	pop    %edx
80106cc7:	57                   	push   %edi
80106cc8:	ff 75 d0             	push   -0x30(%ebp)
80106ccb:	e8 70 c9 ff ff       	call   80103640 <nameiparent>
80106cd0:	83 c4 10             	add    $0x10,%esp
80106cd3:	89 c6                	mov    %eax,%esi
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	74 5b                	je     80106d34 <sys_link+0xf4>
  ilock(dp);
80106cd9:	83 ec 0c             	sub    $0xc,%esp
80106cdc:	50                   	push   %eax
80106cdd:	e8 5e c0 ff ff       	call   80102d40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106ce2:	8b 03                	mov    (%ebx),%eax
80106ce4:	83 c4 10             	add    $0x10,%esp
80106ce7:	39 06                	cmp    %eax,(%esi)
80106ce9:	75 3d                	jne    80106d28 <sys_link+0xe8>
80106ceb:	83 ec 04             	sub    $0x4,%esp
80106cee:	ff 73 04             	push   0x4(%ebx)
80106cf1:	57                   	push   %edi
80106cf2:	56                   	push   %esi
80106cf3:	e8 68 c8 ff ff       	call   80103560 <dirlink>
80106cf8:	83 c4 10             	add    $0x10,%esp
80106cfb:	85 c0                	test   %eax,%eax
80106cfd:	78 29                	js     80106d28 <sys_link+0xe8>
  iunlockput(dp);
80106cff:	83 ec 0c             	sub    $0xc,%esp
80106d02:	56                   	push   %esi
80106d03:	e8 c8 c2 ff ff       	call   80102fd0 <iunlockput>
  iput(ip);
80106d08:	89 1c 24             	mov    %ebx,(%esp)
80106d0b:	e8 60 c1 ff ff       	call   80102e70 <iput>
  end_op();
80106d10:	e8 3b d6 ff ff       	call   80104350 <end_op>
  return 0;
80106d15:	83 c4 10             	add    $0x10,%esp
80106d18:	31 c0                	xor    %eax,%eax
}
80106d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d1d:	5b                   	pop    %ebx
80106d1e:	5e                   	pop    %esi
80106d1f:	5f                   	pop    %edi
80106d20:	5d                   	pop    %ebp
80106d21:	c3                   	ret
80106d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106d28:	83 ec 0c             	sub    $0xc,%esp
80106d2b:	56                   	push   %esi
80106d2c:	e8 9f c2 ff ff       	call   80102fd0 <iunlockput>
    goto bad;
80106d31:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106d34:	83 ec 0c             	sub    $0xc,%esp
80106d37:	53                   	push   %ebx
80106d38:	e8 03 c0 ff ff       	call   80102d40 <ilock>
  ip->nlink--;
80106d3d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106d42:	89 1c 24             	mov    %ebx,(%esp)
80106d45:	e8 46 bf ff ff       	call   80102c90 <iupdate>
  iunlockput(ip);
80106d4a:	89 1c 24             	mov    %ebx,(%esp)
80106d4d:	e8 7e c2 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106d52:	e8 f9 d5 ff ff       	call   80104350 <end_op>
  return -1;
80106d57:	83 c4 10             	add    $0x10,%esp
    return -1;
80106d5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d5f:	eb b9                	jmp    80106d1a <sys_link+0xda>
    iunlockput(ip);
80106d61:	83 ec 0c             	sub    $0xc,%esp
80106d64:	53                   	push   %ebx
80106d65:	e8 66 c2 ff ff       	call   80102fd0 <iunlockput>
    end_op();
80106d6a:	e8 e1 d5 ff ff       	call   80104350 <end_op>
    return -1;
80106d6f:	83 c4 10             	add    $0x10,%esp
80106d72:	eb e6                	jmp    80106d5a <sys_link+0x11a>
    end_op();
80106d74:	e8 d7 d5 ff ff       	call   80104350 <end_op>
    return -1;
80106d79:	eb df                	jmp    80106d5a <sys_link+0x11a>
80106d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d80 <sys_unlink>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106d85:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106d88:	53                   	push   %ebx
80106d89:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106d8c:	50                   	push   %eax
80106d8d:	6a 00                	push   $0x0
80106d8f:	e8 ec f9 ff ff       	call   80106780 <argstr>
80106d94:	83 c4 10             	add    $0x10,%esp
80106d97:	85 c0                	test   %eax,%eax
80106d99:	0f 88 54 01 00 00    	js     80106ef3 <sys_unlink+0x173>
  begin_op();
80106d9f:	e8 3c d5 ff ff       	call   801042e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106da4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106da7:	83 ec 08             	sub    $0x8,%esp
80106daa:	53                   	push   %ebx
80106dab:	ff 75 c0             	push   -0x40(%ebp)
80106dae:	e8 8d c8 ff ff       	call   80103640 <nameiparent>
80106db3:	83 c4 10             	add    $0x10,%esp
80106db6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	0f 84 58 01 00 00    	je     80106f19 <sys_unlink+0x199>
  ilock(dp);
80106dc1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106dc4:	83 ec 0c             	sub    $0xc,%esp
80106dc7:	57                   	push   %edi
80106dc8:	e8 73 bf ff ff       	call   80102d40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106dcd:	58                   	pop    %eax
80106dce:	5a                   	pop    %edx
80106dcf:	68 b6 9a 10 80       	push   $0x80109ab6
80106dd4:	53                   	push   %ebx
80106dd5:	e8 96 c4 ff ff       	call   80103270 <namecmp>
80106dda:	83 c4 10             	add    $0x10,%esp
80106ddd:	85 c0                	test   %eax,%eax
80106ddf:	0f 84 fb 00 00 00    	je     80106ee0 <sys_unlink+0x160>
80106de5:	83 ec 08             	sub    $0x8,%esp
80106de8:	68 b5 9a 10 80       	push   $0x80109ab5
80106ded:	53                   	push   %ebx
80106dee:	e8 7d c4 ff ff       	call   80103270 <namecmp>
80106df3:	83 c4 10             	add    $0x10,%esp
80106df6:	85 c0                	test   %eax,%eax
80106df8:	0f 84 e2 00 00 00    	je     80106ee0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80106dfe:	83 ec 04             	sub    $0x4,%esp
80106e01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106e04:	50                   	push   %eax
80106e05:	53                   	push   %ebx
80106e06:	57                   	push   %edi
80106e07:	e8 84 c4 ff ff       	call   80103290 <dirlookup>
80106e0c:	83 c4 10             	add    $0x10,%esp
80106e0f:	89 c3                	mov    %eax,%ebx
80106e11:	85 c0                	test   %eax,%eax
80106e13:	0f 84 c7 00 00 00    	je     80106ee0 <sys_unlink+0x160>
  ilock(ip);
80106e19:	83 ec 0c             	sub    $0xc,%esp
80106e1c:	50                   	push   %eax
80106e1d:	e8 1e bf ff ff       	call   80102d40 <ilock>
  if(ip->nlink < 1)
80106e22:	83 c4 10             	add    $0x10,%esp
80106e25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106e2a:	0f 8e 0a 01 00 00    	jle    80106f3a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106e30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106e35:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106e38:	74 66                	je     80106ea0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106e3a:	83 ec 04             	sub    $0x4,%esp
80106e3d:	6a 10                	push   $0x10
80106e3f:	6a 00                	push   $0x0
80106e41:	57                   	push   %edi
80106e42:	e8 c9 f5 ff ff       	call   80106410 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e47:	6a 10                	push   $0x10
80106e49:	ff 75 c4             	push   -0x3c(%ebp)
80106e4c:	57                   	push   %edi
80106e4d:	ff 75 b4             	push   -0x4c(%ebp)
80106e50:	e8 fb c2 ff ff       	call   80103150 <writei>
80106e55:	83 c4 20             	add    $0x20,%esp
80106e58:	83 f8 10             	cmp    $0x10,%eax
80106e5b:	0f 85 cc 00 00 00    	jne    80106f2d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80106e61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106e66:	0f 84 94 00 00 00    	je     80106f00 <sys_unlink+0x180>
  iunlockput(dp);
80106e6c:	83 ec 0c             	sub    $0xc,%esp
80106e6f:	ff 75 b4             	push   -0x4c(%ebp)
80106e72:	e8 59 c1 ff ff       	call   80102fd0 <iunlockput>
  ip->nlink--;
80106e77:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106e7c:	89 1c 24             	mov    %ebx,(%esp)
80106e7f:	e8 0c be ff ff       	call   80102c90 <iupdate>
  iunlockput(ip);
80106e84:	89 1c 24             	mov    %ebx,(%esp)
80106e87:	e8 44 c1 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106e8c:	e8 bf d4 ff ff       	call   80104350 <end_op>
  return 0;
80106e91:	83 c4 10             	add    $0x10,%esp
80106e94:	31 c0                	xor    %eax,%eax
}
80106e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e99:	5b                   	pop    %ebx
80106e9a:	5e                   	pop    %esi
80106e9b:	5f                   	pop    %edi
80106e9c:	5d                   	pop    %ebp
80106e9d:	c3                   	ret
80106e9e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106ea0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106ea4:	76 94                	jbe    80106e3a <sys_unlink+0xba>
80106ea6:	be 20 00 00 00       	mov    $0x20,%esi
80106eab:	eb 0b                	jmp    80106eb8 <sys_unlink+0x138>
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
80106eb0:	83 c6 10             	add    $0x10,%esi
80106eb3:	3b 73 58             	cmp    0x58(%ebx),%esi
80106eb6:	73 82                	jae    80106e3a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106eb8:	6a 10                	push   $0x10
80106eba:	56                   	push   %esi
80106ebb:	57                   	push   %edi
80106ebc:	53                   	push   %ebx
80106ebd:	e8 8e c1 ff ff       	call   80103050 <readi>
80106ec2:	83 c4 10             	add    $0x10,%esp
80106ec5:	83 f8 10             	cmp    $0x10,%eax
80106ec8:	75 56                	jne    80106f20 <sys_unlink+0x1a0>
    if(de.inum != 0)
80106eca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106ecf:	74 df                	je     80106eb0 <sys_unlink+0x130>
    iunlockput(ip);
80106ed1:	83 ec 0c             	sub    $0xc,%esp
80106ed4:	53                   	push   %ebx
80106ed5:	e8 f6 c0 ff ff       	call   80102fd0 <iunlockput>
    goto bad;
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	ff 75 b4             	push   -0x4c(%ebp)
80106ee6:	e8 e5 c0 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106eeb:	e8 60 d4 ff ff       	call   80104350 <end_op>
  return -1;
80106ef0:	83 c4 10             	add    $0x10,%esp
    return -1;
80106ef3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ef8:	eb 9c                	jmp    80106e96 <sys_unlink+0x116>
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106f00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106f03:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106f06:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106f0b:	50                   	push   %eax
80106f0c:	e8 7f bd ff ff       	call   80102c90 <iupdate>
80106f11:	83 c4 10             	add    $0x10,%esp
80106f14:	e9 53 ff ff ff       	jmp    80106e6c <sys_unlink+0xec>
    end_op();
80106f19:	e8 32 d4 ff ff       	call   80104350 <end_op>
    return -1;
80106f1e:	eb d3                	jmp    80106ef3 <sys_unlink+0x173>
      panic("isdirempty: readi");
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	68 da 9a 10 80       	push   $0x80109ada
80106f28:	e8 23 96 ff ff       	call   80100550 <panic>
    panic("unlink: writei");
80106f2d:	83 ec 0c             	sub    $0xc,%esp
80106f30:	68 ec 9a 10 80       	push   $0x80109aec
80106f35:	e8 16 96 ff ff       	call   80100550 <panic>
    panic("unlink: nlink < 1");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 c8 9a 10 80       	push   $0x80109ac8
80106f42:	e8 09 96 ff ff       	call   80100550 <panic>
80106f47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f4e:	00 
80106f4f:	90                   	nop

80106f50 <sys_open>:

int
sys_open(void)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106f55:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106f58:	53                   	push   %ebx
80106f59:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106f5c:	50                   	push   %eax
80106f5d:	6a 00                	push   $0x0
80106f5f:	e8 1c f8 ff ff       	call   80106780 <argstr>
80106f64:	83 c4 10             	add    $0x10,%esp
80106f67:	85 c0                	test   %eax,%eax
80106f69:	0f 88 8e 00 00 00    	js     80106ffd <sys_open+0xad>
80106f6f:	83 ec 08             	sub    $0x8,%esp
80106f72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106f75:	50                   	push   %eax
80106f76:	6a 01                	push   $0x1
80106f78:	e8 43 f7 ff ff       	call   801066c0 <argint>
80106f7d:	83 c4 10             	add    $0x10,%esp
80106f80:	85 c0                	test   %eax,%eax
80106f82:	78 79                	js     80106ffd <sys_open+0xad>
    return -1;

  begin_op();
80106f84:	e8 57 d3 ff ff       	call   801042e0 <begin_op>

  if(omode & O_CREATE){
80106f89:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106f8d:	75 79                	jne    80107008 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106f8f:	83 ec 0c             	sub    $0xc,%esp
80106f92:	ff 75 e0             	push   -0x20(%ebp)
80106f95:	e8 86 c6 ff ff       	call   80103620 <namei>
80106f9a:	83 c4 10             	add    $0x10,%esp
80106f9d:	89 c6                	mov    %eax,%esi
80106f9f:	85 c0                	test   %eax,%eax
80106fa1:	0f 84 7e 00 00 00    	je     80107025 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106fa7:	83 ec 0c             	sub    $0xc,%esp
80106faa:	50                   	push   %eax
80106fab:	e8 90 bd ff ff       	call   80102d40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106fb0:	83 c4 10             	add    $0x10,%esp
80106fb3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106fb8:	0f 84 ba 00 00 00    	je     80107078 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106fbe:	e8 2d b4 ff ff       	call   801023f0 <filealloc>
80106fc3:	89 c7                	mov    %eax,%edi
80106fc5:	85 c0                	test   %eax,%eax
80106fc7:	74 23                	je     80106fec <sys_open+0x9c>
  struct proc *curproc = myproc();
80106fc9:	e8 62 e0 ff ff       	call   80105030 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106fce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106fd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106fd4:	85 d2                	test   %edx,%edx
80106fd6:	74 58                	je     80107030 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80106fd8:	83 c3 01             	add    $0x1,%ebx
80106fdb:	83 fb 10             	cmp    $0x10,%ebx
80106fde:	75 f0                	jne    80106fd0 <sys_open+0x80>
    if(f)
      fileclose(f);
80106fe0:	83 ec 0c             	sub    $0xc,%esp
80106fe3:	57                   	push   %edi
80106fe4:	e8 c7 b4 ff ff       	call   801024b0 <fileclose>
80106fe9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106fec:	83 ec 0c             	sub    $0xc,%esp
80106fef:	56                   	push   %esi
80106ff0:	e8 db bf ff ff       	call   80102fd0 <iunlockput>
    end_op();
80106ff5:	e8 56 d3 ff ff       	call   80104350 <end_op>
    return -1;
80106ffa:	83 c4 10             	add    $0x10,%esp
    return -1;
80106ffd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107002:	eb 65                	jmp    80107069 <sys_open+0x119>
80107004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80107008:	83 ec 0c             	sub    $0xc,%esp
8010700b:	31 c9                	xor    %ecx,%ecx
8010700d:	ba 02 00 00 00       	mov    $0x2,%edx
80107012:	6a 00                	push   $0x0
80107014:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107017:	e8 54 f8 ff ff       	call   80106870 <create>
    if(ip == 0){
8010701c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010701f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80107021:	85 c0                	test   %eax,%eax
80107023:	75 99                	jne    80106fbe <sys_open+0x6e>
      end_op();
80107025:	e8 26 d3 ff ff       	call   80104350 <end_op>
      return -1;
8010702a:	eb d1                	jmp    80106ffd <sys_open+0xad>
8010702c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80107030:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80107033:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80107037:	56                   	push   %esi
80107038:	e8 e3 bd ff ff       	call   80102e20 <iunlock>
  end_op();
8010703d:	e8 0e d3 ff ff       	call   80104350 <end_op>

  f->type = FD_INODE;
80107042:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80107048:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010704b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010704e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80107051:	89 d0                	mov    %edx,%eax
  f->off = 0;
80107053:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010705a:	f7 d0                	not    %eax
8010705c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010705f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80107062:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107065:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80107069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706c:	89 d8                	mov    %ebx,%eax
8010706e:	5b                   	pop    %ebx
8010706f:	5e                   	pop    %esi
80107070:	5f                   	pop    %edi
80107071:	5d                   	pop    %ebp
80107072:	c3                   	ret
80107073:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80107078:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010707b:	85 c9                	test   %ecx,%ecx
8010707d:	0f 84 3b ff ff ff    	je     80106fbe <sys_open+0x6e>
80107083:	e9 64 ff ff ff       	jmp    80106fec <sys_open+0x9c>
80107088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010708f:	00 

80107090 <sys_mkdir>:

int
sys_mkdir(void)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107096:	e8 45 d2 ff ff       	call   801042e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010709b:	83 ec 08             	sub    $0x8,%esp
8010709e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070a1:	50                   	push   %eax
801070a2:	6a 00                	push   $0x0
801070a4:	e8 d7 f6 ff ff       	call   80106780 <argstr>
801070a9:	83 c4 10             	add    $0x10,%esp
801070ac:	85 c0                	test   %eax,%eax
801070ae:	78 30                	js     801070e0 <sys_mkdir+0x50>
801070b0:	83 ec 0c             	sub    $0xc,%esp
801070b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b6:	31 c9                	xor    %ecx,%ecx
801070b8:	ba 01 00 00 00       	mov    $0x1,%edx
801070bd:	6a 00                	push   $0x0
801070bf:	e8 ac f7 ff ff       	call   80106870 <create>
801070c4:	83 c4 10             	add    $0x10,%esp
801070c7:	85 c0                	test   %eax,%eax
801070c9:	74 15                	je     801070e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801070cb:	83 ec 0c             	sub    $0xc,%esp
801070ce:	50                   	push   %eax
801070cf:	e8 fc be ff ff       	call   80102fd0 <iunlockput>
  end_op();
801070d4:	e8 77 d2 ff ff       	call   80104350 <end_op>
  return 0;
801070d9:	83 c4 10             	add    $0x10,%esp
801070dc:	31 c0                	xor    %eax,%eax
}
801070de:	c9                   	leave
801070df:	c3                   	ret
    end_op();
801070e0:	e8 6b d2 ff ff       	call   80104350 <end_op>
    return -1;
801070e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070ea:	c9                   	leave
801070eb:	c3                   	ret
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070f0 <sys_mknod>:

int
sys_mknod(void)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801070f6:	e8 e5 d1 ff ff       	call   801042e0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801070fb:	83 ec 08             	sub    $0x8,%esp
801070fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107101:	50                   	push   %eax
80107102:	6a 00                	push   $0x0
80107104:	e8 77 f6 ff ff       	call   80106780 <argstr>
80107109:	83 c4 10             	add    $0x10,%esp
8010710c:	85 c0                	test   %eax,%eax
8010710e:	78 60                	js     80107170 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80107110:	83 ec 08             	sub    $0x8,%esp
80107113:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107116:	50                   	push   %eax
80107117:	6a 01                	push   $0x1
80107119:	e8 a2 f5 ff ff       	call   801066c0 <argint>
  if((argstr(0, &path)) < 0 ||
8010711e:	83 c4 10             	add    $0x10,%esp
80107121:	85 c0                	test   %eax,%eax
80107123:	78 4b                	js     80107170 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80107125:	83 ec 08             	sub    $0x8,%esp
80107128:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010712b:	50                   	push   %eax
8010712c:	6a 02                	push   $0x2
8010712e:	e8 8d f5 ff ff       	call   801066c0 <argint>
     argint(1, &major) < 0 ||
80107133:	83 c4 10             	add    $0x10,%esp
80107136:	85 c0                	test   %eax,%eax
80107138:	78 36                	js     80107170 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010713a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010713e:	83 ec 0c             	sub    $0xc,%esp
80107141:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107145:	ba 03 00 00 00       	mov    $0x3,%edx
8010714a:	50                   	push   %eax
8010714b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010714e:	e8 1d f7 ff ff       	call   80106870 <create>
     argint(2, &minor) < 0 ||
80107153:	83 c4 10             	add    $0x10,%esp
80107156:	85 c0                	test   %eax,%eax
80107158:	74 16                	je     80107170 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	50                   	push   %eax
8010715e:	e8 6d be ff ff       	call   80102fd0 <iunlockput>
  end_op();
80107163:	e8 e8 d1 ff ff       	call   80104350 <end_op>
  return 0;
80107168:	83 c4 10             	add    $0x10,%esp
8010716b:	31 c0                	xor    %eax,%eax
}
8010716d:	c9                   	leave
8010716e:	c3                   	ret
8010716f:	90                   	nop
    end_op();
80107170:	e8 db d1 ff ff       	call   80104350 <end_op>
    return -1;
80107175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010717a:	c9                   	leave
8010717b:	c3                   	ret
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107180 <sys_chdir>:

int
sys_chdir(void)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	56                   	push   %esi
80107184:	53                   	push   %ebx
80107185:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80107188:	e8 a3 de ff ff       	call   80105030 <myproc>
8010718d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010718f:	e8 4c d1 ff ff       	call   801042e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107194:	83 ec 08             	sub    $0x8,%esp
80107197:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010719a:	50                   	push   %eax
8010719b:	6a 00                	push   $0x0
8010719d:	e8 de f5 ff ff       	call   80106780 <argstr>
801071a2:	83 c4 10             	add    $0x10,%esp
801071a5:	85 c0                	test   %eax,%eax
801071a7:	78 77                	js     80107220 <sys_chdir+0xa0>
801071a9:	83 ec 0c             	sub    $0xc,%esp
801071ac:	ff 75 f4             	push   -0xc(%ebp)
801071af:	e8 6c c4 ff ff       	call   80103620 <namei>
801071b4:	83 c4 10             	add    $0x10,%esp
801071b7:	89 c3                	mov    %eax,%ebx
801071b9:	85 c0                	test   %eax,%eax
801071bb:	74 63                	je     80107220 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801071bd:	83 ec 0c             	sub    $0xc,%esp
801071c0:	50                   	push   %eax
801071c1:	e8 7a bb ff ff       	call   80102d40 <ilock>
  if(ip->type != T_DIR){
801071c6:	83 c4 10             	add    $0x10,%esp
801071c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801071ce:	75 30                	jne    80107200 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	53                   	push   %ebx
801071d4:	e8 47 bc ff ff       	call   80102e20 <iunlock>
  iput(curproc->cwd);
801071d9:	58                   	pop    %eax
801071da:	ff 76 68             	push   0x68(%esi)
801071dd:	e8 8e bc ff ff       	call   80102e70 <iput>
  end_op();
801071e2:	e8 69 d1 ff ff       	call   80104350 <end_op>
  curproc->cwd = ip;
801071e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	31 c0                	xor    %eax,%eax
}
801071ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071f2:	5b                   	pop    %ebx
801071f3:	5e                   	pop    %esi
801071f4:	5d                   	pop    %ebp
801071f5:	c3                   	ret
801071f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071fd:	00 
801071fe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	53                   	push   %ebx
80107204:	e8 c7 bd ff ff       	call   80102fd0 <iunlockput>
    end_op();
80107209:	e8 42 d1 ff ff       	call   80104350 <end_op>
    return -1;
8010720e:	83 c4 10             	add    $0x10,%esp
    return -1;
80107211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107216:	eb d7                	jmp    801071ef <sys_chdir+0x6f>
80107218:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010721f:	00 
    end_op();
80107220:	e8 2b d1 ff ff       	call   80104350 <end_op>
    return -1;
80107225:	eb ea                	jmp    80107211 <sys_chdir+0x91>
80107227:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010722e:	00 
8010722f:	90                   	nop

80107230 <sys_exec>:

int
sys_exec(void)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107235:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010723b:	53                   	push   %ebx
8010723c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107242:	50                   	push   %eax
80107243:	6a 00                	push   $0x0
80107245:	e8 36 f5 ff ff       	call   80106780 <argstr>
8010724a:	83 c4 10             	add    $0x10,%esp
8010724d:	85 c0                	test   %eax,%eax
8010724f:	0f 88 87 00 00 00    	js     801072dc <sys_exec+0xac>
80107255:	83 ec 08             	sub    $0x8,%esp
80107258:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010725e:	50                   	push   %eax
8010725f:	6a 01                	push   $0x1
80107261:	e8 5a f4 ff ff       	call   801066c0 <argint>
80107266:	83 c4 10             	add    $0x10,%esp
80107269:	85 c0                	test   %eax,%eax
8010726b:	78 6f                	js     801072dc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010726d:	83 ec 04             	sub    $0x4,%esp
80107270:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80107276:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80107278:	68 80 00 00 00       	push   $0x80
8010727d:	6a 00                	push   $0x0
8010727f:	56                   	push   %esi
80107280:	e8 8b f1 ff ff       	call   80106410 <memset>
80107285:	83 c4 10             	add    $0x10,%esp
80107288:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010728f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107290:	83 ec 08             	sub    $0x8,%esp
80107293:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107299:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801072a0:	50                   	push   %eax
801072a1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801072a7:	01 f8                	add    %edi,%eax
801072a9:	50                   	push   %eax
801072aa:	e8 81 f3 ff ff       	call   80106630 <fetchint>
801072af:	83 c4 10             	add    $0x10,%esp
801072b2:	85 c0                	test   %eax,%eax
801072b4:	78 26                	js     801072dc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801072b6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801072bc:	85 c0                	test   %eax,%eax
801072be:	74 30                	je     801072f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801072c0:	83 ec 08             	sub    $0x8,%esp
801072c3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801072c6:	52                   	push   %edx
801072c7:	50                   	push   %eax
801072c8:	e8 a3 f3 ff ff       	call   80106670 <fetchstr>
801072cd:	83 c4 10             	add    $0x10,%esp
801072d0:	85 c0                	test   %eax,%eax
801072d2:	78 08                	js     801072dc <sys_exec+0xac>
  for(i=0;; i++){
801072d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801072d7:	83 fb 20             	cmp    $0x20,%ebx
801072da:	75 b4                	jne    80107290 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801072dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801072df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072e4:	5b                   	pop    %ebx
801072e5:	5e                   	pop    %esi
801072e6:	5f                   	pop    %edi
801072e7:	5d                   	pop    %ebp
801072e8:	c3                   	ret
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801072f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801072f7:	00 00 00 00 
  return exec(path, argv);
801072fb:	83 ec 08             	sub    $0x8,%esp
801072fe:	56                   	push   %esi
801072ff:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80107305:	e8 46 ad ff ff       	call   80102050 <exec>
8010730a:	83 c4 10             	add    $0x10,%esp
}
8010730d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107310:	5b                   	pop    %ebx
80107311:	5e                   	pop    %esi
80107312:	5f                   	pop    %edi
80107313:	5d                   	pop    %ebp
80107314:	c3                   	ret
80107315:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731c:	00 
8010731d:	8d 76 00             	lea    0x0(%esi),%esi

80107320 <sys_pipe>:

int
sys_pipe(void)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107325:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80107328:	53                   	push   %ebx
80107329:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010732c:	6a 08                	push   $0x8
8010732e:	50                   	push   %eax
8010732f:	6a 00                	push   $0x0
80107331:	e8 da f3 ff ff       	call   80106710 <argptr>
80107336:	83 c4 10             	add    $0x10,%esp
80107339:	85 c0                	test   %eax,%eax
8010733b:	0f 88 8b 00 00 00    	js     801073cc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80107341:	83 ec 08             	sub    $0x8,%esp
80107344:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107347:	50                   	push   %eax
80107348:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010734b:	50                   	push   %eax
8010734c:	e8 5f d6 ff ff       	call   801049b0 <pipealloc>
80107351:	83 c4 10             	add    $0x10,%esp
80107354:	85 c0                	test   %eax,%eax
80107356:	78 74                	js     801073cc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107358:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010735b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010735d:	e8 ce dc ff ff       	call   80105030 <myproc>
    if(curproc->ofile[fd] == 0){
80107362:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107366:	85 f6                	test   %esi,%esi
80107368:	74 16                	je     80107380 <sys_pipe+0x60>
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80107370:	83 c3 01             	add    $0x1,%ebx
80107373:	83 fb 10             	cmp    $0x10,%ebx
80107376:	74 3d                	je     801073b5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80107378:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010737c:	85 f6                	test   %esi,%esi
8010737e:	75 f0                	jne    80107370 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80107380:	8d 73 08             	lea    0x8(%ebx),%esi
80107383:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107387:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010738a:	e8 a1 dc ff ff       	call   80105030 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010738f:	31 d2                	xor    %edx,%edx
80107391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107398:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010739c:	85 c9                	test   %ecx,%ecx
8010739e:	74 38                	je     801073d8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801073a0:	83 c2 01             	add    $0x1,%edx
801073a3:	83 fa 10             	cmp    $0x10,%edx
801073a6:	75 f0                	jne    80107398 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801073a8:	e8 83 dc ff ff       	call   80105030 <myproc>
801073ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801073b4:	00 
    fileclose(rf);
801073b5:	83 ec 0c             	sub    $0xc,%esp
801073b8:	ff 75 e0             	push   -0x20(%ebp)
801073bb:	e8 f0 b0 ff ff       	call   801024b0 <fileclose>
    fileclose(wf);
801073c0:	58                   	pop    %eax
801073c1:	ff 75 e4             	push   -0x1c(%ebp)
801073c4:	e8 e7 b0 ff ff       	call   801024b0 <fileclose>
    return -1;
801073c9:	83 c4 10             	add    $0x10,%esp
    return -1;
801073cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073d1:	eb 16                	jmp    801073e9 <sys_pipe+0xc9>
801073d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801073d8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801073dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801073df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801073e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801073e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801073e7:	31 c0                	xor    %eax,%eax
}
801073e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ec:	5b                   	pop    %ebx
801073ed:	5e                   	pop    %esi
801073ee:	5f                   	pop    %edi
801073ef:	5d                   	pop    %ebp
801073f0:	c3                   	ret
801073f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073f8:	00 
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <sys_make_duplicate_file>:

int
sys_make_duplicate_file(void)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
  char *org;
  char newname[MAXPATH];
  struct inode *orgi, *newi;

  if(argstr(0, &org) < 0)
80107405:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
{
8010740b:	53                   	push   %ebx
8010740c:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  if(argstr(0, &org) < 0)
80107412:	50                   	push   %eax
80107413:	6a 00                	push   $0x0
80107415:	e8 66 f3 ff ff       	call   80106780 <argstr>
8010741a:	83 c4 10             	add    $0x10,%esp
8010741d:	85 c0                	test   %eax,%eax
8010741f:	0f 88 6d 01 00 00    	js     80107592 <sys_make_duplicate_file+0x192>
    return -1;

  int olen = strlen(org);
80107425:	83 ec 0c             	sub    $0xc,%esp
80107428:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
8010742e:	e8 cd f1 ff ff       	call   80106600 <strlen>
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80107433:	83 c4 10             	add    $0x10,%esp
  int olen = strlen(org);
80107436:	89 c3                	mov    %eax,%ebx
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80107438:	83 f8 79             	cmp    $0x79,%eax
8010743b:	0f 8f 51 01 00 00    	jg     80107592 <sys_make_duplicate_file+0x192>
    return -1;
  safestrcpy(newname, org, MAXPATH);
80107441:	83 ec 04             	sub    $0x4,%esp
80107444:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010744a:	68 80 00 00 00       	push   $0x80
  memmove(newname + olen, "_copy", 6);
8010744f:	01 f3                	add    %esi,%ebx
  safestrcpy(newname, org, MAXPATH);
80107451:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
80107457:	56                   	push   %esi
80107458:	e8 63 f1 ff ff       	call   801065c0 <safestrcpy>
  memmove(newname + olen, "_copy", 6);
8010745d:	83 c4 0c             	add    $0xc,%esp
80107460:	6a 06                	push   $0x6
80107462:	68 fb 9a 10 80       	push   $0x80109afb
80107467:	53                   	push   %ebx
80107468:	e8 33 f0 ff ff       	call   801064a0 <memmove>

  begin_op();
8010746d:	e8 6e ce ff ff       	call   801042e0 <begin_op>

  if(namei(newname) != 0){          // no locks needed for pure existence test
80107472:	89 34 24             	mov    %esi,(%esp)
80107475:	e8 a6 c1 ff ff       	call   80103620 <namei>
8010747a:	83 c4 10             	add    $0x10,%esp
8010747d:	85 c0                	test   %eax,%eax
8010747f:	0f 85 5d 01 00 00    	jne    801075e2 <sys_make_duplicate_file+0x1e2>
    end_op();
    return -1;
  }

  orgi = namei(org);
80107485:	83 ec 0c             	sub    $0xc,%esp
80107488:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
8010748e:	e8 8d c1 ff ff       	call   80103620 <namei>
  if(!orgi){
80107493:	83 c4 10             	add    $0x10,%esp
  orgi = namei(org);
80107496:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
8010749c:	89 c3                	mov    %eax,%ebx
  if(!orgi){
8010749e:	85 c0                	test   %eax,%eax
801074a0:	0f 84 3c 01 00 00    	je     801075e2 <sys_make_duplicate_file+0x1e2>
    end_op();
    return -1;
  }

  ilock(orgi);
801074a6:	83 ec 0c             	sub    $0xc,%esp
801074a9:	50                   	push   %eax
801074aa:	e8 91 b8 ff ff       	call   80102d40 <ilock>
  if(orgi->type != T_FILE){
801074af:	83 c4 10             	add    $0x10,%esp
801074b2:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801074b7:	0f 85 4b 01 00 00    	jne    80107608 <sys_make_duplicate_file+0x208>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = namei(newname);
801074bd:	83 ec 0c             	sub    $0xc,%esp
801074c0:	56                   	push   %esi
801074c1:	e8 5a c1 ff ff       	call   80103620 <namei>
  if(newi){
801074c6:	83 c4 10             	add    $0x10,%esp
801074c9:	85 c0                	test   %eax,%eax
801074cb:	0f 85 18 01 00 00    	jne    801075e9 <sys_make_duplicate_file+0x1e9>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = create(newname, T_FILE, 0, 0);
801074d1:	83 ec 0c             	sub    $0xc,%esp
801074d4:	31 c9                	xor    %ecx,%ecx
801074d6:	ba 02 00 00 00       	mov    $0x2,%edx
801074db:	89 f0                	mov    %esi,%eax
801074dd:	6a 00                	push   $0x0
801074df:	e8 8c f3 ff ff       	call   80106870 <create>
  if(!newi){
801074e4:	83 c4 10             	add    $0x10,%esp
  newi = create(newname, T_FILE, 0, 0);
801074e7:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  if(!newi){
801074ed:	85 c0                	test   %eax,%eax
801074ef:	0f 84 2e 01 00 00    	je     80107623 <sys_make_duplicate_file+0x223>
    iput(orgi);
    end_op();
    return -1;
  }

  uint total = orgi->size;
801074f5:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
801074fb:	8b 70 58             	mov    0x58(%eax),%esi
  char *kbuf = kalloc();
801074fe:	e8 fd c6 ff ff       	call   80103c00 <kalloc>
80107503:	89 c3                	mov    %eax,%ebx
  if(!kbuf){
80107505:	85 c0                	test   %eax,%eax
80107507:	0f 84 3a 01 00 00    	je     80107647 <sys_make_duplicate_file+0x247>
    iput(orgi);
    end_op();
    return -1;
  }

  uint done = 0;
8010750d:	31 ff                	xor    %edi,%edi
  while(done < total){
8010750f:	85 f6                	test   %esi,%esi
80107511:	75 28                	jne    8010753b <sys_make_duplicate_file+0x13b>
80107513:	e9 88 00 00 00       	jmp    801075a0 <sys_make_duplicate_file+0x1a0>
80107518:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010751f:	00 
    if(chunk > BSIZE) chunk = BSIZE;

    int got = readi(orgi, kbuf, done, chunk);
    if(got < 0) goto err;

    int put = writei(newi, kbuf, done, got);
80107520:	50                   	push   %eax
80107521:	57                   	push   %edi
80107522:	53                   	push   %ebx
80107523:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80107529:	e8 22 bc ff ff       	call   80103150 <writei>
    if(put < 0) goto err;
8010752e:	83 c4 10             	add    $0x10,%esp
80107531:	85 c0                	test   %eax,%eax
80107533:	78 29                	js     8010755e <sys_make_duplicate_file+0x15e>

    done += put;
80107535:	01 c7                	add    %eax,%edi
  while(done < total){
80107537:	39 f7                	cmp    %esi,%edi
80107539:	73 65                	jae    801075a0 <sys_make_duplicate_file+0x1a0>
    uint chunk = total - done;
8010753b:	89 f0                	mov    %esi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
8010753d:	b9 00 02 00 00       	mov    $0x200,%ecx
    uint chunk = total - done;
80107542:	29 f8                	sub    %edi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
80107544:	39 c8                	cmp    %ecx,%eax
80107546:	0f 47 c1             	cmova  %ecx,%eax
    int got = readi(orgi, kbuf, done, chunk);
80107549:	50                   	push   %eax
8010754a:	57                   	push   %edi
8010754b:	53                   	push   %ebx
8010754c:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80107552:	e8 f9 ba ff ff       	call   80103050 <readi>
    if(got < 0) goto err;
80107557:	83 c4 10             	add    $0x10,%esp
8010755a:	85 c0                	test   %eax,%eax
8010755c:	79 c2                	jns    80107520 <sys_make_duplicate_file+0x120>
  kfree(kbuf);
  end_op();
  return 0;

err:
  iunlockput(newi);
8010755e:	83 ec 0c             	sub    $0xc,%esp
80107561:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80107567:	e8 64 ba ff ff       	call   80102fd0 <iunlockput>
  iunlock(orgi);
8010756c:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
80107572:	89 34 24             	mov    %esi,(%esp)
80107575:	e8 a6 b8 ff ff       	call   80102e20 <iunlock>
  iput(orgi);
8010757a:	89 34 24             	mov    %esi,(%esp)
8010757d:	e8 ee b8 ff ff       	call   80102e70 <iput>
  kfree(kbuf);
80107582:	89 1c 24             	mov    %ebx,(%esp)
80107585:	e8 b6 c4 ff ff       	call   80103a40 <kfree>
  end_op();
8010758a:	e8 c1 cd ff ff       	call   80104350 <end_op>
  return -1;
8010758f:	83 c4 10             	add    $0x10,%esp
}
80107592:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80107595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010759a:	5b                   	pop    %ebx
8010759b:	5e                   	pop    %esi
8010759c:	5f                   	pop    %edi
8010759d:	5d                   	pop    %ebp
8010759e:	c3                   	ret
8010759f:	90                   	nop
  newi->size = total;
801075a0:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  iupdate(newi);
801075a6:	83 ec 0c             	sub    $0xc,%esp
  newi->size = total;
801075a9:	89 70 58             	mov    %esi,0x58(%eax)
  iupdate(newi);
801075ac:	89 c6                	mov    %eax,%esi
801075ae:	50                   	push   %eax
801075af:	e8 dc b6 ff ff       	call   80102c90 <iupdate>
  iunlock(newi);
801075b4:	89 34 24             	mov    %esi,(%esp)
801075b7:	e8 64 b8 ff ff       	call   80102e20 <iunlock>
  iunlock(orgi);
801075bc:	58                   	pop    %eax
801075bd:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801075c3:	e8 58 b8 ff ff       	call   80102e20 <iunlock>
  kfree(kbuf);
801075c8:	89 1c 24             	mov    %ebx,(%esp)
801075cb:	e8 70 c4 ff ff       	call   80103a40 <kfree>
  end_op();
801075d0:	e8 7b cd ff ff       	call   80104350 <end_op>
  return 0;
801075d5:	83 c4 10             	add    $0x10,%esp
}
801075d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075db:	31 c0                	xor    %eax,%eax
}
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret
    end_op();
801075e2:	e8 69 cd ff ff       	call   80104350 <end_op>
    return -1;
801075e7:	eb a9                	jmp    80107592 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
801075e9:	83 ec 0c             	sub    $0xc,%esp
801075ec:	50                   	push   %eax
801075ed:	e8 de b9 ff ff       	call   80102fd0 <iunlockput>
    iunlockput(orgi);
801075f2:	5a                   	pop    %edx
801075f3:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801075f9:	e8 d2 b9 ff ff       	call   80102fd0 <iunlockput>
    end_op();
801075fe:	e8 4d cd ff ff       	call   80104350 <end_op>
    return -1;
80107603:	83 c4 10             	add    $0x10,%esp
80107606:	eb 8a                	jmp    80107592 <sys_make_duplicate_file+0x192>
    iunlockput(orgi);
80107608:	83 ec 0c             	sub    $0xc,%esp
8010760b:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80107611:	e8 ba b9 ff ff       	call   80102fd0 <iunlockput>
    end_op();
80107616:	e8 35 cd ff ff       	call   80104350 <end_op>
    return -1;
8010761b:	83 c4 10             	add    $0x10,%esp
8010761e:	e9 6f ff ff ff       	jmp    80107592 <sys_make_duplicate_file+0x192>
    iunlock(orgi);
80107623:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
80107629:	83 ec 0c             	sub    $0xc,%esp
8010762c:	56                   	push   %esi
    iunlock(orgi);
8010762d:	e8 ee b7 ff ff       	call   80102e20 <iunlock>
    iput(orgi);
80107632:	89 34 24             	mov    %esi,(%esp)
80107635:	e8 36 b8 ff ff       	call   80102e70 <iput>
    end_op();
8010763a:	e8 11 cd ff ff       	call   80104350 <end_op>
    return -1;
8010763f:	83 c4 10             	add    $0x10,%esp
80107642:	e9 4b ff ff ff       	jmp    80107592 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
80107647:	83 ec 0c             	sub    $0xc,%esp
8010764a:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80107650:	e8 7b b9 ff ff       	call   80102fd0 <iunlockput>
    iunlock(orgi);
80107655:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
8010765b:	89 34 24             	mov    %esi,(%esp)
8010765e:	eb cd                	jmp    8010762d <sys_make_duplicate_file+0x22d>

80107660 <sys_grep_syscall>:
    }

    return 0;
}

int sys_grep_syscall(void){
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
    char *keyword, *filename;
    char *ubuf;
    int bufsz;

    if(argstr(0, &keyword) < 0)
80107665:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_grep_syscall(void){
80107668:	53                   	push   %ebx
80107669:	83 ec 44             	sub    $0x44,%esp
    if(argstr(0, &keyword) < 0)
8010766c:	50                   	push   %eax
8010766d:	6a 00                	push   $0x0
8010766f:	e8 0c f1 ff ff       	call   80106780 <argstr>
80107674:	83 c4 10             	add    $0x10,%esp
80107677:	85 c0                	test   %eax,%eax
80107679:	0f 88 96 02 00 00    	js     80107915 <sys_grep_syscall+0x2b5>
        return -1;
    if((1, &filename) < 0)
        return -1;
    if(argint(3, &bufsz) < 0 || bufsz <= 1)
8010767f:	83 ec 08             	sub    $0x8,%esp
80107682:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107685:	50                   	push   %eax
80107686:	6a 03                	push   $0x3
80107688:	e8 33 f0 ff ff       	call   801066c0 <argint>
8010768d:	83 c4 10             	add    $0x10,%esp
80107690:	85 c0                	test   %eax,%eax
80107692:	0f 88 7d 02 00 00    	js     80107915 <sys_grep_syscall+0x2b5>
80107698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010769b:	83 f8 01             	cmp    $0x1,%eax
8010769e:	0f 8e 71 02 00 00    	jle    80107915 <sys_grep_syscall+0x2b5>
        return -1;
    if(argptr(2, &ubuf, bufsz) < 0)
801076a4:	83 ec 04             	sub    $0x4,%esp
801076a7:	50                   	push   %eax
801076a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801076ab:	50                   	push   %eax
801076ac:	6a 02                	push   $0x2
801076ae:	e8 5d f0 ff ff       	call   80106710 <argptr>
801076b3:	83 c4 10             	add    $0x10,%esp
801076b6:	85 c0                	test   %eax,%eax
801076b8:	0f 88 57 02 00 00    	js     80107915 <sys_grep_syscall+0x2b5>
        return -1;

    struct inode *ip = namei(filename);
801076be:	83 ec 0c             	sub    $0xc,%esp
801076c1:	6a 00                	push   $0x0
801076c3:	e8 58 bf ff ff       	call   80103620 <namei>
    if(!ip)
801076c8:	83 c4 10             	add    $0x10,%esp
    struct inode *ip = namei(filename);
801076cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
801076ce:	89 c3                	mov    %eax,%ebx
    if(!ip)
801076d0:	85 c0                	test   %eax,%eax
801076d2:	0f 84 3d 02 00 00    	je     80107915 <sys_grep_syscall+0x2b5>
        return -1;

    ilock(ip);
801076d8:	83 ec 0c             	sub    $0xc,%esp
801076db:	50                   	push   %eax
801076dc:	e8 5f b6 ff ff       	call   80102d40 <ilock>
    if(ip->type != T_FILE && ip->type != T_DEV){
801076e1:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
801076e5:	83 c4 10             	add    $0x10,%esp
801076e8:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
801076ec:	83 e8 02             	sub    $0x2,%eax
801076ef:	66 83 f8 01          	cmp    $0x1,%ax
801076f3:	0f 87 0e 02 00 00    	ja     80107907 <sys_grep_syscall+0x2a7>
        iunlockput(ip);
        return -1;
    }

    char *buf = kalloc();
801076f9:	e8 02 c5 ff ff       	call   80103c00 <kalloc>
801076fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(!buf){
80107701:	85 c0                	test   %eax,%eax
80107703:	0f 84 fe 01 00 00    	je     80107907 <sys_grep_syscall+0x2a7>
        iunlockput(ip);
        return -1;
    }

    char *line = kalloc();
80107709:	e8 f2 c4 ff ff       	call   80103c00 <kalloc>
8010770e:	89 c7                	mov    %eax,%edi
    if(!line){
80107710:	85 c0                	test   %eax,%eax
80107712:	0f 84 07 02 00 00    	je     8010791f <sys_grep_syscall+0x2bf>
        return -1;
    }

    int offset = 0;
    int res = -1;
    int line_len = 0;
80107718:	31 f6                	xor    %esi,%esi
    int offset = 0;
8010771a:	31 db                	xor    %ebx,%ebx

    while(1){
        int n = readi(ip, buf, offset, CHUNK);
8010771c:	68 00 02 00 00       	push   $0x200
80107721:	53                   	push   %ebx
80107722:	ff 75 cc             	push   -0x34(%ebp)
80107725:	ff 75 c8             	push   -0x38(%ebp)
80107728:	e8 23 b9 ff ff       	call   80103050 <readi>
        if(n < 0)
8010772d:	83 c4 10             	add    $0x10,%esp
80107730:	85 c0                	test   %eax,%eax
80107732:	0f 88 ab 00 00 00    	js     801077e3 <sys_grep_syscall+0x183>
            break;

        if(n == 0){
80107738:	0f 84 5d 01 00 00    	je     8010789b <sys_grep_syscall+0x23b>
            }

            break;
        }

        for(int i = 0; i < n; i++){
8010773e:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80107741:	31 d2                	xor    %edx,%edx
80107743:	eb 1a                	jmp    8010775f <sys_grep_syscall+0xff>
80107745:	8d 76 00             	lea    0x0(%esi),%esi
                }

                line_len = 0;
            }
            
            else if(line_len < PGSIZE - 1){
80107748:	81 fe fe 0f 00 00    	cmp    $0xffe,%esi
8010774e:	0f 8e f1 00 00 00    	jle    80107845 <sys_grep_syscall+0x1e5>
        for(int i = 0; i < n; i++){
80107754:	83 c2 01             	add    $0x1,%edx
80107757:	39 d0                	cmp    %edx,%eax
80107759:	0f 8e f7 00 00 00    	jle    80107856 <sys_grep_syscall+0x1f6>
            char c = buf[i];
8010775f:	8b 5d cc             	mov    -0x34(%ebp),%ebx
80107762:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
            if(c == '\n'){
80107766:	80 f9 0a             	cmp    $0xa,%cl
80107769:	75 dd                	jne    80107748 <sys_grep_syscall+0xe8>
                if(line_has_keyword(line, line_len, keyword)){
8010776b:	8b 5d dc             	mov    -0x24(%ebp),%ebx
    if(!key[0])
8010776e:	0f b6 0b             	movzbl (%ebx),%ecx
80107771:	88 4d d4             	mov    %cl,-0x2c(%ebp)
80107774:	84 c9                	test   %cl,%cl
80107776:	74 3c                	je     801077b4 <sys_grep_syscall+0x154>
    for (int i = 0; i < n; i++){
80107778:	85 f6                	test   %esi,%esi
8010777a:	0f 8e b0 00 00 00    	jle    80107830 <sys_grep_syscall+0x1d0>
80107780:	89 d9                	mov    %ebx,%ecx
80107782:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107785:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107788:	29 f1                	sub    %esi,%ecx
8010778a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010778d:	89 d9                	mov    %ebx,%ecx
8010778f:	90                   	nop
80107790:	89 d8                	mov    %ebx,%eax
        while(i+j < n && key[j] && line[i+j] == key[j])
80107792:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
80107796:	29 c8                	sub    %ecx,%eax
80107798:	39 c6                	cmp    %eax,%esi
8010779a:	0f 8e 7c 00 00 00    	jle    8010781c <sys_grep_syscall+0x1bc>
801077a0:	3a 14 07             	cmp    (%edi,%eax,1),%dl
801077a3:	75 77                	jne    8010781c <sys_grep_syscall+0x1bc>
801077a5:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
801077a8:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
801077ac:	39 c6                	cmp    %eax,%esi
801077ae:	74 68                	je     80107818 <sys_grep_syscall+0x1b8>
801077b0:	84 d2                	test   %dl,%dl
801077b2:	75 ec                	jne    801077a0 <sys_grep_syscall+0x140>
                    int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
801077b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
801077ba:	39 f3                	cmp    %esi,%ebx
801077bc:	0f 4f de             	cmovg  %esi,%ebx
                    if(copyout(myproc()->pgdir, (uint)ubuf, line, copylen) >= 0){
801077bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801077c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801077c5:	e8 66 d8 ff ff       	call   80105030 <myproc>
801077ca:	53                   	push   %ebx
801077cb:	57                   	push   %edi
801077cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801077cf:	52                   	push   %edx
801077d0:	ff 70 04             	push   0x4(%eax)
801077d3:	e8 58 1d 00 00       	call   80109530 <copyout>
801077d8:	83 c4 10             	add    $0x10,%esp
801077db:	85 c0                	test   %eax,%eax
801077dd:	0f 89 89 00 00 00    	jns    8010786c <sys_grep_syscall+0x20c>
    int res = -1;
801077e3:	be ff ff ff ff       	mov    $0xffffffff,%esi
        }

        offset += n;
    }

    kfree(buf);
801077e8:	83 ec 0c             	sub    $0xc,%esp
801077eb:	ff 75 cc             	push   -0x34(%ebp)
801077ee:	e8 4d c2 ff ff       	call   80103a40 <kfree>
    kfree(line);
801077f3:	89 3c 24             	mov    %edi,(%esp)
801077f6:	e8 45 c2 ff ff       	call   80103a40 <kfree>
    iunlockput(ip);
801077fb:	58                   	pop    %eax
801077fc:	ff 75 c8             	push   -0x38(%ebp)
801077ff:	e8 cc b7 ff ff       	call   80102fd0 <iunlockput>

    return res;
80107804:	83 c4 10             	add    $0x10,%esp
80107807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010780a:	89 f0                	mov    %esi,%eax
8010780c:	5b                   	pop    %ebx
8010780d:	5e                   	pop    %esi
8010780e:	5f                   	pop    %edi
8010780f:	5d                   	pop    %ebp
80107810:	c3                   	ret
80107811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(key[j] == 0)
80107818:	84 d2                	test   %dl,%dl
8010781a:	74 98                	je     801077b4 <sys_grep_syscall+0x154>
    for (int i = 0; i < n; i++){
8010781c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010781f:	83 e9 01             	sub    $0x1,%ecx
80107822:	39 c1                	cmp    %eax,%ecx
80107824:	0f 85 66 ff ff ff    	jne    80107790 <sys_grep_syscall+0x130>
8010782a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010782d:	8b 45 c0             	mov    -0x40(%ebp),%eax
        for(int i = 0; i < n; i++){
80107830:	83 c2 01             	add    $0x1,%edx
80107833:	39 d0                	cmp    %edx,%eax
80107835:	7e 58                	jle    8010788f <sys_grep_syscall+0x22f>
            char c = buf[i];
80107837:	8b 75 cc             	mov    -0x34(%ebp),%esi
8010783a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
            if(c == '\n'){
8010783e:	80 f9 0a             	cmp    $0xa,%cl
80107841:	74 1d                	je     80107860 <sys_grep_syscall+0x200>
                line_len = 0;
80107843:	31 f6                	xor    %esi,%esi
        for(int i = 0; i < n; i++){
80107845:	83 c2 01             	add    $0x1,%edx
                line[line_len++] = c;
80107848:	88 0c 37             	mov    %cl,(%edi,%esi,1)
8010784b:	83 c6 01             	add    $0x1,%esi
        for(int i = 0; i < n; i++){
8010784e:	39 d0                	cmp    %edx,%eax
80107850:	0f 8f 09 ff ff ff    	jg     8010775f <sys_grep_syscall+0xff>
80107856:	8b 5d bc             	mov    -0x44(%ebp),%ebx
        offset += n;
80107859:	01 c3                	add    %eax,%ebx
    while(1){
8010785b:	e9 bc fe ff ff       	jmp    8010771c <sys_grep_syscall+0xbc>
    if(!key[0])
80107860:	80 3b 00             	cmpb   $0x0,(%ebx)
80107863:	75 cb                	jne    80107830 <sys_grep_syscall+0x1d0>
                line_len = 0;
80107865:	31 f6                	xor    %esi,%esi
80107867:	e9 48 ff ff ff       	jmp    801077b4 <sys_grep_syscall+0x154>
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
8010786c:	03 5d e0             	add    -0x20(%ebp),%ebx
                        char z = 0;
8010786f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
80107873:	e8 b8 d7 ff ff       	call   80105030 <myproc>
80107878:	8d 55 db             	lea    -0x25(%ebp),%edx
8010787b:	6a 01                	push   $0x1
8010787d:	52                   	push   %edx
8010787e:	53                   	push   %ebx
8010787f:	ff 70 04             	push   0x4(%eax)
80107882:	e8 a9 1c 00 00       	call   80109530 <copyout>
                        res = line_len;
80107887:	83 c4 10             	add    $0x10,%esp
8010788a:	e9 59 ff ff ff       	jmp    801077e8 <sys_grep_syscall+0x188>
                line_len = 0;
8010788f:	8b 5d bc             	mov    -0x44(%ebp),%ebx
80107892:	31 f6                	xor    %esi,%esi
        offset += n;
80107894:	01 c3                	add    %eax,%ebx
    while(1){
80107896:	e9 81 fe ff ff       	jmp    8010771c <sys_grep_syscall+0xbc>
            if(line_len > 0 && line_has_keyword(line, line_len, keyword)){
8010789b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010789e:	85 f6                	test   %esi,%esi
801078a0:	0f 8e 3d ff ff ff    	jle    801077e3 <sys_grep_syscall+0x183>
801078a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801078a9:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801078ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    if(!key[0])
801078af:	0f b6 00             	movzbl (%eax),%eax
801078b2:	88 45 d0             	mov    %al,-0x30(%ebp)
801078b5:	84 c0                	test   %al,%al
801078b7:	74 28                	je     801078e1 <sys_grep_syscall+0x281>
        while(i+j < n && key[j] && line[i+j] == key[j])
801078b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801078bc:	39 c6                	cmp    %eax,%esi
801078be:	7e 37                	jle    801078f7 <sys_grep_syscall+0x297>
801078c0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
801078c3:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
801078c7:	01 f8                	add    %edi,%eax
801078c9:	83 c1 01             	add    $0x1,%ecx
801078cc:	38 10                	cmp    %dl,(%eax)
801078ce:	75 27                	jne    801078f7 <sys_grep_syscall+0x297>
801078d0:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
801078d3:	0f b6 11             	movzbl (%ecx),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
801078d6:	83 c1 01             	add    $0x1,%ecx
801078d9:	39 d8                	cmp    %ebx,%eax
801078db:	74 16                	je     801078f3 <sys_grep_syscall+0x293>
801078dd:	84 d2                	test   %dl,%dl
801078df:	75 eb                	jne    801078cc <sys_grep_syscall+0x26c>
                int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
801078e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078e4:	83 e8 01             	sub    $0x1,%eax
801078e7:	39 f0                	cmp    %esi,%eax
801078e9:	0f 4f c6             	cmovg  %esi,%eax
801078ec:	89 c3                	mov    %eax,%ebx
801078ee:	e9 cc fe ff ff       	jmp    801077bf <sys_grep_syscall+0x15f>
        if(key[j] == 0)
801078f3:	84 d2                	test   %dl,%dl
801078f5:	74 ea                	je     801078e1 <sys_grep_syscall+0x281>
    for (int i = 0; i < n; i++){
801078f7:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801078fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801078fe:	39 c6                	cmp    %eax,%esi
80107900:	75 b7                	jne    801078b9 <sys_grep_syscall+0x259>
80107902:	e9 dc fe ff ff       	jmp    801077e3 <sys_grep_syscall+0x183>
        iunlockput(ip);
80107907:	83 ec 0c             	sub    $0xc,%esp
8010790a:	ff 75 c8             	push   -0x38(%ebp)
8010790d:	e8 be b6 ff ff       	call   80102fd0 <iunlockput>
        return -1;
80107912:	83 c4 10             	add    $0x10,%esp
        return -1;
80107915:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010791a:	e9 e8 fe ff ff       	jmp    80107807 <sys_grep_syscall+0x1a7>
        kfree(buf);
8010791f:	83 ec 0c             	sub    $0xc,%esp
80107922:	ff 75 cc             	push   -0x34(%ebp)
80107925:	e8 16 c1 ff ff       	call   80103a40 <kfree>
        iunlockput(ip);
8010792a:	5a                   	pop    %edx
8010792b:	ff 75 c8             	push   -0x38(%ebp)
8010792e:	e8 9d b6 ff ff       	call   80102fd0 <iunlockput>
        return -1;
80107933:	83 c4 10             	add    $0x10,%esp
80107936:	eb dd                	jmp    80107915 <sys_grep_syscall+0x2b5>
80107938:	66 90                	xchg   %ax,%ax
8010793a:	66 90                	xchg   %ax,%ax
8010793c:	66 90                	xchg   %ax,%ax
8010793e:	66 90                	xchg   %ax,%ax

80107940 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80107940:	e9 9b d8 ff ff       	jmp    801051e0 <fork>
80107945:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010794c:	00 
8010794d:	8d 76 00             	lea    0x0(%esi),%esi

80107950 <sys_exit>:
}

int
sys_exit(void)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	83 ec 08             	sub    $0x8,%esp
  exit();
80107956:	e8 d5 dd ff ff       	call   80105730 <exit>
  return 0;  // not reached
}
8010795b:	31 c0                	xor    %eax,%eax
8010795d:	c9                   	leave
8010795e:	c3                   	ret
8010795f:	90                   	nop

80107960 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80107960:	e9 3b df ff ff       	jmp    801058a0 <wait>
80107965:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010796c:	00 
8010796d:	8d 76 00             	lea    0x0(%esi),%esi

80107970 <sys_kill>:
}

int
sys_kill(void)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107976:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107979:	50                   	push   %eax
8010797a:	6a 00                	push   $0x0
8010797c:	e8 3f ed ff ff       	call   801066c0 <argint>
80107981:	83 c4 10             	add    $0x10,%esp
80107984:	85 c0                	test   %eax,%eax
80107986:	78 18                	js     801079a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80107988:	83 ec 0c             	sub    $0xc,%esp
8010798b:	ff 75 f4             	push   -0xc(%ebp)
8010798e:	e8 dd e1 ff ff       	call   80105b70 <kill>
80107993:	83 c4 10             	add    $0x10,%esp
}
80107996:	c9                   	leave
80107997:	c3                   	ret
80107998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010799f:	00 
801079a0:	c9                   	leave
    return -1;
801079a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a6:	c3                   	ret
801079a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079ae:	00 
801079af:	90                   	nop

801079b0 <sys_getpid>:

int
sys_getpid(void)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801079b6:	e8 75 d6 ff ff       	call   80105030 <myproc>
801079bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801079be:	c9                   	leave
801079bf:	c3                   	ret

801079c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801079c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801079c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801079ca:	50                   	push   %eax
801079cb:	6a 00                	push   $0x0
801079cd:	e8 ee ec ff ff       	call   801066c0 <argint>
801079d2:	83 c4 10             	add    $0x10,%esp
801079d5:	85 c0                	test   %eax,%eax
801079d7:	78 27                	js     80107a00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801079d9:	e8 52 d6 ff ff       	call   80105030 <myproc>
  if(growproc(n) < 0)
801079de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801079e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801079e3:	ff 75 f4             	push   -0xc(%ebp)
801079e6:	e8 75 d7 ff ff       	call   80105160 <growproc>
801079eb:	83 c4 10             	add    $0x10,%esp
801079ee:	85 c0                	test   %eax,%eax
801079f0:	78 0e                	js     80107a00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801079f2:	89 d8                	mov    %ebx,%eax
801079f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801079f7:	c9                   	leave
801079f8:	c3                   	ret
801079f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107a00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107a05:	eb eb                	jmp    801079f2 <sys_sbrk+0x32>
80107a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a0e:	00 
80107a0f:	90                   	nop

80107a10 <sys_sleep>:

int
sys_sleep(void)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80107a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107a17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80107a1a:	50                   	push   %eax
80107a1b:	6a 00                	push   $0x0
80107a1d:	e8 9e ec ff ff       	call   801066c0 <argint>
80107a22:	83 c4 10             	add    $0x10,%esp
80107a25:	85 c0                	test   %eax,%eax
80107a27:	78 64                	js     80107a8d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80107a29:	83 ec 0c             	sub    $0xc,%esp
80107a2c:	68 e0 75 11 80       	push   $0x801175e0
80107a31:	e8 da e8 ff ff       	call   80106310 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107a39:	8b 1d c0 75 11 80    	mov    0x801175c0,%ebx
  while(ticks - ticks0 < n){
80107a3f:	83 c4 10             	add    $0x10,%esp
80107a42:	85 d2                	test   %edx,%edx
80107a44:	75 2b                	jne    80107a71 <sys_sleep+0x61>
80107a46:	eb 58                	jmp    80107aa0 <sys_sleep+0x90>
80107a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a4f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107a50:	83 ec 08             	sub    $0x8,%esp
80107a53:	68 e0 75 11 80       	push   $0x801175e0
80107a58:	68 c0 75 11 80       	push   $0x801175c0
80107a5d:	e8 de df ff ff       	call   80105a40 <sleep>
  while(ticks - ticks0 < n){
80107a62:	a1 c0 75 11 80       	mov    0x801175c0,%eax
80107a67:	83 c4 10             	add    $0x10,%esp
80107a6a:	29 d8                	sub    %ebx,%eax
80107a6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80107a6f:	73 2f                	jae    80107aa0 <sys_sleep+0x90>
    if(myproc()->killed){
80107a71:	e8 ba d5 ff ff       	call   80105030 <myproc>
80107a76:	8b 40 24             	mov    0x24(%eax),%eax
80107a79:	85 c0                	test   %eax,%eax
80107a7b:	74 d3                	je     80107a50 <sys_sleep+0x40>
      release(&tickslock);
80107a7d:	83 ec 0c             	sub    $0xc,%esp
80107a80:	68 e0 75 11 80       	push   $0x801175e0
80107a85:	e8 26 e8 ff ff       	call   801062b0 <release>
      return -1;
80107a8a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
80107a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80107a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a95:	c9                   	leave
80107a96:	c3                   	ret
80107a97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a9e:	00 
80107a9f:	90                   	nop
  release(&tickslock);
80107aa0:	83 ec 0c             	sub    $0xc,%esp
80107aa3:	68 e0 75 11 80       	push   $0x801175e0
80107aa8:	e8 03 e8 ff ff       	call   801062b0 <release>
}
80107aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80107ab0:	83 c4 10             	add    $0x10,%esp
80107ab3:	31 c0                	xor    %eax,%eax
}
80107ab5:	c9                   	leave
80107ab6:	c3                   	ret
80107ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107abe:	00 
80107abf:	90                   	nop

80107ac0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	53                   	push   %ebx
80107ac4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107ac7:	68 e0 75 11 80       	push   $0x801175e0
80107acc:	e8 3f e8 ff ff       	call   80106310 <acquire>
  xticks = ticks;
80107ad1:	8b 1d c0 75 11 80    	mov    0x801175c0,%ebx
  release(&tickslock);
80107ad7:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80107ade:	e8 cd e7 ff ff       	call   801062b0 <release>
  return xticks;
}
80107ae3:	89 d8                	mov    %ebx,%eax
80107ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107ae8:	c9                   	leave
80107ae9:	c3                   	ret
80107aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107af0 <sys_show_process_family>:

int
sys_show_process_family(void)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0) 
80107af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107af9:	50                   	push   %eax
80107afa:	6a 00                	push   $0x0
80107afc:	e8 bf eb ff ff       	call   801066c0 <argint>
80107b01:	83 c4 10             	add    $0x10,%esp
80107b04:	85 c0                	test   %eax,%eax
80107b06:	78 18                	js     80107b20 <sys_show_process_family+0x30>
    {
      return -1;
    }
  return process_family(pid);
80107b08:	83 ec 0c             	sub    $0xc,%esp
80107b0b:	ff 75 f4             	push   -0xc(%ebp)
80107b0e:	e8 bd e1 ff ff       	call   80105cd0 <process_family>
80107b13:	83 c4 10             	add    $0x10,%esp
}
80107b16:	c9                   	leave
80107b17:	c3                   	ret
80107b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b1f:	00 
80107b20:	c9                   	leave
      return -1;
80107b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b26:	c3                   	ret
80107b27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b2e:	00 
80107b2f:	90                   	nop

80107b30 <sys_simple_arithmetic>:

int
sys_simple_arithmetic(void)
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	53                   	push   %ebx
80107b34:	83 ec 04             	sub    $0x4,%esp
  struct proc *p = myproc();
80107b37:	e8 f4 d4 ff ff       	call   80105030 <myproc>
  int a = p->tf->ebx; 
80107b3c:	8b 40 18             	mov    0x18(%eax),%eax
80107b3f:	8b 50 10             	mov    0x10(%eax),%edx
  int b = p->tf->ecx;
80107b42:	8b 48 18             	mov    0x18(%eax),%ecx

  int sum = a + b;
  int diff = a - b;
80107b45:	89 d0                	mov    %edx,%eax
  int sum = a + b;
80107b47:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
  int diff = a - b;
80107b4a:	29 c8                	sub    %ecx,%eax
  int res = sum * diff;
80107b4c:	0f af d8             	imul   %eax,%ebx

  cprintf("simple_arith: a=%d b=%d -> (%d+%d)*(%d-%d) = %d\n",a, b, a, b, a, b, res);
80107b4f:	53                   	push   %ebx
80107b50:	51                   	push   %ecx
80107b51:	52                   	push   %edx
80107b52:	51                   	push   %ecx
80107b53:	52                   	push   %edx
80107b54:	51                   	push   %ecx
80107b55:	52                   	push   %edx
80107b56:	68 64 9d 10 80       	push   $0x80109d64
80107b5b:	e8 00 92 ff ff       	call   80100d60 <cprintf>

  return res;
}
80107b60:	89 d8                	mov    %ebx,%eax
80107b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b65:	c9                   	leave
80107b66:	c3                   	ret
80107b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b6e:	00 
80107b6f:	90                   	nop

80107b70 <sys_set_priority_syscall>:

int
sys_set_priority_syscall(void)
{
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	83 ec 20             	sub    $0x20,%esp
  int pid, prio;
  if(argint(0, &pid)  < 0) return -1;
80107b76:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b79:	50                   	push   %eax
80107b7a:	6a 00                	push   $0x0
80107b7c:	e8 3f eb ff ff       	call   801066c0 <argint>
80107b81:	83 c4 10             	add    $0x10,%esp
80107b84:	85 c0                	test   %eax,%eax
80107b86:	78 28                	js     80107bb0 <sys_set_priority_syscall+0x40>
  if(argint(1, &prio) < 0) return -1;
80107b88:	83 ec 08             	sub    $0x8,%esp
80107b8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107b8e:	50                   	push   %eax
80107b8f:	6a 01                	push   $0x1
80107b91:	e8 2a eb ff ff       	call   801066c0 <argint>
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	85 c0                	test   %eax,%eax
80107b9b:	78 13                	js     80107bb0 <sys_set_priority_syscall+0x40>
  return set_priority(pid, prio);
80107b9d:	83 ec 08             	sub    $0x8,%esp
80107ba0:	ff 75 f4             	push   -0xc(%ebp)
80107ba3:	ff 75 f0             	push   -0x10(%ebp)
80107ba6:	e8 c5 e2 ff ff       	call   80105e70 <set_priority>
80107bab:	83 c4 10             	add    $0x10,%esp
}
80107bae:	c9                   	leave
80107baf:	c3                   	ret
80107bb0:	c9                   	leave
  if(argint(0, &pid)  < 0) return -1;
80107bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bb6:	c3                   	ret
80107bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107bbe:	00 
80107bbf:	90                   	nop

80107bc0 <sys_start_throughput>:

int
sys_start_throughput(void)
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&tickslock);
80107bc6:	68 e0 75 11 80       	push   $0x801175e0
80107bcb:	e8 40 e7 ff ff       	call   80106310 <acquire>
  throughput_start_tick = ticks;
80107bd0:	a1 c0 75 11 80       	mov    0x801175c0,%eax
  release(&tickslock);
80107bd5:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
  throughput_start_tick = ticks;
80107bdc:	a3 04 50 11 80       	mov    %eax,0x80115004
  release(&tickslock);
80107be1:	e8 ca e6 ff ff       	call   801062b0 <release>

  throughput_finished_procs = 0;
  is_measuring_throughput = 1;

  return 0;
}
80107be6:	31 c0                	xor    %eax,%eax
  throughput_finished_procs = 0;
80107be8:	c7 05 00 50 11 80 00 	movl   $0x0,0x80115000
80107bef:	00 00 00 
  is_measuring_throughput = 1;
80107bf2:	c7 05 08 50 11 80 01 	movl   $0x1,0x80115008
80107bf9:	00 00 00 
}
80107bfc:	c9                   	leave
80107bfd:	c3                   	ret
80107bfe:	66 90                	xchg   %ax,%ax

80107c00 <sys_end_throughput>:

int
sys_end_throughput(void)
{
80107c00:	55                   	push   %ebp
80107c01:	89 e5                	mov    %esp,%ebp
80107c03:	56                   	push   %esi
80107c04:	53                   	push   %ebx
  uint start, end, diff;
  int procs;

  acquire(&tickslock);
80107c05:	83 ec 0c             	sub    $0xc,%esp
80107c08:	68 e0 75 11 80       	push   $0x801175e0
80107c0d:	e8 fe e6 ff ff       	call   80106310 <acquire>
  start = throughput_start_tick;
80107c12:	8b 35 04 50 11 80    	mov    0x80115004,%esi
  end   = ticks;
80107c18:	8b 1d c0 75 11 80    	mov    0x801175c0,%ebx
  release(&tickslock);
80107c1e:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80107c25:	e8 86 e6 ff ff       	call   801062b0 <release>
  diff  = end - start;

  if(diff == 0)
    diff = 1;

  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107c2a:	ba 01 00 00 00       	mov    $0x1,%edx
80107c2f:	69 05 00 50 11 80 e8 	imul   $0x3e8,0x80115000,%eax
80107c36:	03 00 00 
  diff  = end - start;
80107c39:	29 f3                	sub    %esi,%ebx
  is_measuring_throughput = 0;
80107c3b:	c7 05 08 50 11 80 00 	movl   $0x0,0x80115008
80107c42:	00 00 00 
  diff  = end - start;
80107c45:	89 d9                	mov    %ebx,%ecx
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107c47:	0f 44 ca             	cmove  %edx,%ecx

  // cprintf("Throughput: %d procs in %d ticks (~%d procs/tick)\n",
  //         throughput_finished_procs, diff, th_per_tick);

  return th_per_tick;
}
80107c4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107c4d:	31 d2                	xor    %edx,%edx
}
80107c4f:	5b                   	pop    %ebx
80107c50:	5e                   	pop    %esi
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107c51:	f7 f1                	div    %ecx
}
80107c53:	5d                   	pop    %ebp
80107c54:	c3                   	ret
80107c55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c5c:	00 
80107c5d:	8d 76 00             	lea    0x0(%esi),%esi

80107c60 <sys_print_process_info>:

extern void print_process_info(struct proc *);

int
sys_print_process_info(void)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc();
80107c66:	e8 c5 d3 ff ff       	call   80105030 <myproc>
  print_process_info(p);
80107c6b:	83 ec 0c             	sub    $0xc,%esp
80107c6e:	50                   	push   %eax
80107c6f:	e8 6c e2 ff ff       	call   80105ee0 <print_process_info>
  return 0;
}
80107c74:	31 c0                	xor    %eax,%eax
80107c76:	c9                   	leave
80107c77:	c3                   	ret

80107c78 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107c78:	1e                   	push   %ds
  pushl %es
80107c79:	06                   	push   %es
  pushl %fs
80107c7a:	0f a0                	push   %fs
  pushl %gs
80107c7c:	0f a8                	push   %gs
  pushal
80107c7e:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107c7f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107c83:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107c85:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107c87:	54                   	push   %esp
  call trap
80107c88:	e8 c3 00 00 00       	call   80107d50 <trap>
  addl $4, %esp
80107c8d:	83 c4 04             	add    $0x4,%esp

80107c90 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107c90:	61                   	popa
  popl %gs
80107c91:	0f a9                	pop    %gs
  popl %fs
80107c93:	0f a1                	pop    %fs
  popl %es
80107c95:	07                   	pop    %es
  popl %ds
80107c96:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107c97:	83 c4 08             	add    $0x8,%esp
  iret
80107c9a:	cf                   	iret
80107c9b:	66 90                	xchg   %ax,%ax
80107c9d:	66 90                	xchg   %ax,%ax
80107c9f:	90                   	nop

80107ca0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107ca0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107ca1:	31 c0                	xor    %eax,%eax
{
80107ca3:	89 e5                	mov    %esp,%ebp
80107ca5:	83 ec 08             	sub    $0x8,%esp
80107ca8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107caf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107cb0:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80107cb7:	c7 04 c5 22 76 11 80 	movl   $0x8e000008,-0x7fee89de(,%eax,8)
80107cbe:	08 00 00 8e 
80107cc2:	66 89 14 c5 20 76 11 	mov    %dx,-0x7fee89e0(,%eax,8)
80107cc9:	80 
80107cca:	c1 ea 10             	shr    $0x10,%edx
80107ccd:	66 89 14 c5 26 76 11 	mov    %dx,-0x7fee89da(,%eax,8)
80107cd4:	80 
  for(i = 0; i < 256; i++)
80107cd5:	83 c0 01             	add    $0x1,%eax
80107cd8:	3d 00 01 00 00       	cmp    $0x100,%eax
80107cdd:	75 d1                	jne    80107cb0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80107cdf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107ce2:	a1 08 d1 10 80       	mov    0x8010d108,%eax
80107ce7:	c7 05 22 78 11 80 08 	movl   $0xef000008,0x80117822
80107cee:	00 00 ef 
  initlock(&tickslock, "time");
80107cf1:	68 01 9b 10 80       	push   $0x80109b01
80107cf6:	68 e0 75 11 80       	push   $0x801175e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107cfb:	66 a3 20 78 11 80    	mov    %ax,0x80117820
80107d01:	c1 e8 10             	shr    $0x10,%eax
80107d04:	66 a3 26 78 11 80    	mov    %ax,0x80117826
  initlock(&tickslock, "time");
80107d0a:	e8 11 e4 ff ff       	call   80106120 <initlock>
}
80107d0f:	83 c4 10             	add    $0x10,%esp
80107d12:	c9                   	leave
80107d13:	c3                   	ret
80107d14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d1b:	00 
80107d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d20 <idtinit>:

void
idtinit(void)
{
80107d20:	55                   	push   %ebp
  pd[0] = size-1;
80107d21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107d26:	89 e5                	mov    %esp,%ebp
80107d28:	83 ec 10             	sub    $0x10,%esp
80107d2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107d2f:	b8 20 76 11 80       	mov    $0x80117620,%eax
80107d34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107d38:	c1 e8 10             	shr    $0x10,%eax
80107d3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80107d3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107d42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107d45:	c9                   	leave
80107d46:	c3                   	ret
80107d47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d4e:	00 
80107d4f:	90                   	nop

80107d50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
80107d55:	53                   	push   %ebx
80107d56:	83 ec 1c             	sub    $0x1c,%esp
80107d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80107d5c:	8b 43 30             	mov    0x30(%ebx),%eax
80107d5f:	83 f8 40             	cmp    $0x40,%eax
80107d62:	0f 84 a0 01 00 00    	je     80107f08 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80107d68:	83 e8 20             	sub    $0x20,%eax
80107d6b:	83 f8 1f             	cmp    $0x1f,%eax
80107d6e:	0f 87 7c 00 00 00    	ja     80107df0 <trap+0xa0>
80107d74:	ff 24 85 18 a1 10 80 	jmp    *-0x7fef5ee8(,%eax,4)
80107d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107d80:	e8 4b ba ff ff       	call   801037d0 <ideintr>
    lapiceoi();
80107d85:	e8 06 c1 ff ff       	call   80103e90 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107d8a:	e8 a1 d2 ff ff       	call   80105030 <myproc>
80107d8f:	85 c0                	test   %eax,%eax
80107d91:	74 1a                	je     80107dad <trap+0x5d>
80107d93:	e8 98 d2 ff ff       	call   80105030 <myproc>
80107d98:	8b 50 24             	mov    0x24(%eax),%edx
80107d9b:	85 d2                	test   %edx,%edx
80107d9d:	74 0e                	je     80107dad <trap+0x5d>
80107d9f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107da3:	f7 d0                	not    %eax
80107da5:	a8 03                	test   $0x3,%al
80107da7:	0f 84 23 02 00 00    	je     80107fd0 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

if(myproc() && myproc()->state == RUNNING &&
80107dad:	e8 7e d2 ff ff       	call   80105030 <myproc>
80107db2:	85 c0                	test   %eax,%eax
80107db4:	74 0f                	je     80107dc5 <trap+0x75>
80107db6:	e8 75 d2 ff ff       	call   80105030 <myproc>
80107dbb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107dbf:	0f 84 ab 00 00 00    	je     80107e70 <trap+0x120>
         yield();
     }
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107dc5:	e8 66 d2 ff ff       	call   80105030 <myproc>
80107dca:	85 c0                	test   %eax,%eax
80107dcc:	74 1a                	je     80107de8 <trap+0x98>
80107dce:	e8 5d d2 ff ff       	call   80105030 <myproc>
80107dd3:	8b 40 24             	mov    0x24(%eax),%eax
80107dd6:	85 c0                	test   %eax,%eax
80107dd8:	74 0e                	je     80107de8 <trap+0x98>
80107dda:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107dde:	f7 d0                	not    %eax
80107de0:	a8 03                	test   $0x3,%al
80107de2:	0f 84 4d 01 00 00    	je     80107f35 <trap+0x1e5>
    exit();
80107de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107deb:	5b                   	pop    %ebx
80107dec:	5e                   	pop    %esi
80107ded:	5f                   	pop    %edi
80107dee:	5d                   	pop    %ebp
80107def:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80107df0:	e8 3b d2 ff ff       	call   80105030 <myproc>
80107df5:	8b 7b 38             	mov    0x38(%ebx),%edi
80107df8:	85 c0                	test   %eax,%eax
80107dfa:	0f 84 fa 01 00 00    	je     80107ffa <trap+0x2aa>
80107e00:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107e04:	0f 84 f0 01 00 00    	je     80107ffa <trap+0x2aa>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107e0a:	0f 20 d1             	mov    %cr2,%ecx
80107e0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e10:	e8 fb d1 ff ff       	call   80105010 <cpuid>
80107e15:	8b 73 30             	mov    0x30(%ebx),%esi
80107e18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e1b:	8b 43 34             	mov    0x34(%ebx),%eax
80107e1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107e21:	e8 0a d2 ff ff       	call   80105030 <myproc>
80107e26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e29:	e8 02 d2 ff ff       	call   80105030 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107e31:	51                   	push   %ecx
80107e32:	57                   	push   %edi
80107e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107e36:	52                   	push   %edx
80107e37:	ff 75 e4             	push   -0x1c(%ebp)
80107e3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107e3b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107e3e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e41:	56                   	push   %esi
80107e42:	ff 70 10             	push   0x10(%eax)
80107e45:	68 f0 9d 10 80       	push   $0x80109df0
80107e4a:	e8 11 8f ff ff       	call   80100d60 <cprintf>
    myproc()->killed = 1;
80107e4f:	83 c4 20             	add    $0x20,%esp
80107e52:	e8 d9 d1 ff ff       	call   80105030 <myproc>
80107e57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107e5e:	e8 cd d1 ff ff       	call   80105030 <myproc>
80107e63:	85 c0                	test   %eax,%eax
80107e65:	0f 85 28 ff ff ff    	jne    80107d93 <trap+0x43>
80107e6b:	e9 3d ff ff ff       	jmp    80107dad <trap+0x5d>
if(myproc() && myproc()->state == RUNNING &&
80107e70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107e74:	0f 85 4b ff ff ff    	jne    80107dc5 <trap+0x75>
     struct cpu *c = mycpu();
80107e7a:	e8 31 d1 ff ff       	call   80104fb0 <mycpu>
     if (cpuid() % 2 == 0) { // E-Core
80107e7f:	e8 8c d1 ff ff       	call   80105010 <cpuid>
80107e84:	a8 01                	test   $0x1,%al
80107e86:	0f 85 64 01 00 00    	jne    80107ff0 <trap+0x2a0>
         myproc()->tick_count++;
80107e8c:	e8 9f d1 ff ff       	call   80105030 <myproc>
80107e91:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
         myproc()->total_tick_count++;
80107e98:	e8 93 d1 ff ff       	call   80105030 <myproc>
80107e9d:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
         if (myproc()->tick_count >= 3) {
80107ea4:	e8 87 d1 ff ff       	call   80105030 <myproc>
80107ea9:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80107eb0:	0f 8e 0f ff ff ff    	jle    80107dc5 <trap+0x75>
             myproc()->tick_count = 0;
80107eb6:	e8 75 d1 ff ff       	call   80105030 <myproc>
80107ebb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80107ec2:	00 00 00 
             yield();
80107ec5:	e8 06 db ff ff       	call   801059d0 <yield>
80107eca:	e9 f6 fe ff ff       	jmp    80107dc5 <trap+0x75>
80107ecf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107ed0:	8b 7b 38             	mov    0x38(%ebx),%edi
80107ed3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107ed7:	e8 34 d1 ff ff       	call   80105010 <cpuid>
80107edc:	57                   	push   %edi
80107edd:	56                   	push   %esi
80107ede:	50                   	push   %eax
80107edf:	68 98 9d 10 80       	push   $0x80109d98
80107ee4:	e8 77 8e ff ff       	call   80100d60 <cprintf>
    lapiceoi();
80107ee9:	e8 a2 bf ff ff       	call   80103e90 <lapiceoi>
    break;
80107eee:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107ef1:	e8 3a d1 ff ff       	call   80105030 <myproc>
80107ef6:	85 c0                	test   %eax,%eax
80107ef8:	0f 85 95 fe ff ff    	jne    80107d93 <trap+0x43>
80107efe:	e9 aa fe ff ff       	jmp    80107dad <trap+0x5d>
80107f03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80107f08:	e8 23 d1 ff ff       	call   80105030 <myproc>
80107f0d:	8b 70 24             	mov    0x24(%eax),%esi
80107f10:	85 f6                	test   %esi,%esi
80107f12:	0f 85 c8 00 00 00    	jne    80107fe0 <trap+0x290>
    myproc()->tf = tf;
80107f18:	e8 13 d1 ff ff       	call   80105030 <myproc>
80107f1d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107f20:	e8 db e8 ff ff       	call   80106800 <syscall>
    if(myproc()->killed)
80107f25:	e8 06 d1 ff ff       	call   80105030 <myproc>
80107f2a:	8b 48 24             	mov    0x24(%eax),%ecx
80107f2d:	85 c9                	test   %ecx,%ecx
80107f2f:	0f 84 b3 fe ff ff    	je     80107de8 <trap+0x98>
80107f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f38:	5b                   	pop    %ebx
80107f39:	5e                   	pop    %esi
80107f3a:	5f                   	pop    %edi
80107f3b:	5d                   	pop    %ebp
      exit();
80107f3c:	e9 ef d7 ff ff       	jmp    80105730 <exit>
80107f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107f48:	e8 63 02 00 00       	call   801081b0 <uartintr>
    lapiceoi();
80107f4d:	e8 3e bf ff ff       	call   80103e90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107f52:	e8 d9 d0 ff ff       	call   80105030 <myproc>
80107f57:	85 c0                	test   %eax,%eax
80107f59:	0f 85 34 fe ff ff    	jne    80107d93 <trap+0x43>
80107f5f:	e9 49 fe ff ff       	jmp    80107dad <trap+0x5d>
80107f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107f68:	e8 f3 bd ff ff       	call   80103d60 <kbdintr>
    lapiceoi();
80107f6d:	e8 1e bf ff ff       	call   80103e90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107f72:	e8 b9 d0 ff ff       	call   80105030 <myproc>
80107f77:	85 c0                	test   %eax,%eax
80107f79:	0f 85 14 fe ff ff    	jne    80107d93 <trap+0x43>
80107f7f:	e9 29 fe ff ff       	jmp    80107dad <trap+0x5d>
80107f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80107f88:	e8 83 d0 ff ff       	call   80105010 <cpuid>
80107f8d:	85 c0                	test   %eax,%eax
80107f8f:	0f 85 f0 fd ff ff    	jne    80107d85 <trap+0x35>
      acquire(&tickslock);
80107f95:	83 ec 0c             	sub    $0xc,%esp
80107f98:	68 e0 75 11 80       	push   $0x801175e0
80107f9d:	e8 6e e3 ff ff       	call   80106310 <acquire>
      ticks++;
80107fa2:	83 05 c0 75 11 80 01 	addl   $0x1,0x801175c0
      wakeup(&ticks);
80107fa9:	c7 04 24 c0 75 11 80 	movl   $0x801175c0,(%esp)
80107fb0:	e8 4b db ff ff       	call   80105b00 <wakeup>
      release(&tickslock);
80107fb5:	c7 04 24 e0 75 11 80 	movl   $0x801175e0,(%esp)
80107fbc:	e8 ef e2 ff ff       	call   801062b0 <release>
80107fc1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107fc4:	e9 bc fd ff ff       	jmp    80107d85 <trap+0x35>
80107fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107fd0:	e8 5b d7 ff ff       	call   80105730 <exit>
80107fd5:	e9 d3 fd ff ff       	jmp    80107dad <trap+0x5d>
80107fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107fe0:	e8 4b d7 ff ff       	call   80105730 <exit>
80107fe5:	e9 2e ff ff ff       	jmp    80107f18 <trap+0x1c8>
80107fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
         yield();
80107ff0:	e8 db d9 ff ff       	call   801059d0 <yield>
80107ff5:	e9 cb fd ff ff       	jmp    80107dc5 <trap+0x75>
80107ffa:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107ffd:	e8 0e d0 ff ff       	call   80105010 <cpuid>
80108002:	83 ec 0c             	sub    $0xc,%esp
80108005:	56                   	push   %esi
80108006:	57                   	push   %edi
80108007:	50                   	push   %eax
80108008:	ff 73 30             	push   0x30(%ebx)
8010800b:	68 bc 9d 10 80       	push   $0x80109dbc
80108010:	e8 4b 8d ff ff       	call   80100d60 <cprintf>
      panic("trap");
80108015:	83 c4 14             	add    $0x14,%esp
80108018:	68 06 9b 10 80       	push   $0x80109b06
8010801d:	e8 2e 85 ff ff       	call   80100550 <panic>
80108022:	66 90                	xchg   %ax,%ax
80108024:	66 90                	xchg   %ax,%ax
80108026:	66 90                	xchg   %ax,%ax
80108028:	66 90                	xchg   %ax,%ax
8010802a:	66 90                	xchg   %ax,%ax
8010802c:	66 90                	xchg   %ax,%ax
8010802e:	66 90                	xchg   %ax,%ax

80108030 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80108030:	a1 20 7e 11 80       	mov    0x80117e20,%eax
80108035:	85 c0                	test   %eax,%eax
80108037:	74 17                	je     80108050 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108039:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010803e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010803f:	a8 01                	test   $0x1,%al
80108041:	74 0d                	je     80108050 <uartgetc+0x20>
80108043:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108048:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80108049:	0f b6 c0             	movzbl %al,%eax
8010804c:	c3                   	ret
8010804d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80108050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108055:	c3                   	ret
80108056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010805d:	00 
8010805e:	66 90                	xchg   %ax,%ax

80108060 <uartinit>:
{
80108060:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108061:	31 c9                	xor    %ecx,%ecx
80108063:	89 c8                	mov    %ecx,%eax
80108065:	89 e5                	mov    %esp,%ebp
80108067:	57                   	push   %edi
80108068:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010806d:	56                   	push   %esi
8010806e:	89 fa                	mov    %edi,%edx
80108070:	53                   	push   %ebx
80108071:	83 ec 1c             	sub    $0x1c,%esp
80108074:	ee                   	out    %al,(%dx)
80108075:	be fb 03 00 00       	mov    $0x3fb,%esi
8010807a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010807f:	89 f2                	mov    %esi,%edx
80108081:	ee                   	out    %al,(%dx)
80108082:	b8 0c 00 00 00       	mov    $0xc,%eax
80108087:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010808c:	ee                   	out    %al,(%dx)
8010808d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80108092:	89 c8                	mov    %ecx,%eax
80108094:	89 da                	mov    %ebx,%edx
80108096:	ee                   	out    %al,(%dx)
80108097:	b8 03 00 00 00       	mov    $0x3,%eax
8010809c:	89 f2                	mov    %esi,%edx
8010809e:	ee                   	out    %al,(%dx)
8010809f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801080a4:	89 c8                	mov    %ecx,%eax
801080a6:	ee                   	out    %al,(%dx)
801080a7:	b8 01 00 00 00       	mov    $0x1,%eax
801080ac:	89 da                	mov    %ebx,%edx
801080ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801080af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801080b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801080b5:	3c ff                	cmp    $0xff,%al
801080b7:	0f 84 7c 00 00 00    	je     80108139 <uartinit+0xd9>
  uart = 1;
801080bd:	c7 05 20 7e 11 80 01 	movl   $0x1,0x80117e20
801080c4:	00 00 00 
801080c7:	89 fa                	mov    %edi,%edx
801080c9:	ec                   	in     (%dx),%al
801080ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
801080cf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801080d0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801080d3:	bf 0b 9b 10 80       	mov    $0x80109b0b,%edi
801080d8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801080dd:	6a 00                	push   $0x0
801080df:	6a 04                	push   $0x4
801080e1:	e8 1a b9 ff ff       	call   80103a00 <ioapicenable>
801080e6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801080e9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
801080ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
801080f0:	a1 20 7e 11 80       	mov    0x80117e20,%eax
801080f5:	85 c0                	test   %eax,%eax
801080f7:	74 32                	je     8010812b <uartinit+0xcb>
801080f9:	89 f2                	mov    %esi,%edx
801080fb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801080fc:	a8 20                	test   $0x20,%al
801080fe:	75 21                	jne    80108121 <uartinit+0xc1>
80108100:	bb 80 00 00 00       	mov    $0x80,%ebx
80108105:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80108108:	83 ec 0c             	sub    $0xc,%esp
8010810b:	6a 0a                	push   $0xa
8010810d:	e8 9e bd ff ff       	call   80103eb0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108112:	83 c4 10             	add    $0x10,%esp
80108115:	83 eb 01             	sub    $0x1,%ebx
80108118:	74 07                	je     80108121 <uartinit+0xc1>
8010811a:	89 f2                	mov    %esi,%edx
8010811c:	ec                   	in     (%dx),%al
8010811d:	a8 20                	test   $0x20,%al
8010811f:	74 e7                	je     80108108 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108121:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108126:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010812a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010812b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010812f:	83 c7 01             	add    $0x1,%edi
80108132:	88 45 e7             	mov    %al,-0x19(%ebp)
80108135:	84 c0                	test   %al,%al
80108137:	75 b7                	jne    801080f0 <uartinit+0x90>
}
80108139:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010813c:	5b                   	pop    %ebx
8010813d:	5e                   	pop    %esi
8010813e:	5f                   	pop    %edi
8010813f:	5d                   	pop    %ebp
80108140:	c3                   	ret
80108141:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108148:	00 
80108149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108150 <uartputc>:
  if(!uart)
80108150:	a1 20 7e 11 80       	mov    0x80117e20,%eax
80108155:	85 c0                	test   %eax,%eax
80108157:	74 4f                	je     801081a8 <uartputc+0x58>
{
80108159:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010815a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010815f:	89 e5                	mov    %esp,%ebp
80108161:	56                   	push   %esi
80108162:	53                   	push   %ebx
80108163:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108164:	a8 20                	test   $0x20,%al
80108166:	75 29                	jne    80108191 <uartputc+0x41>
80108168:	bb 80 00 00 00       	mov    $0x80,%ebx
8010816d:	be fd 03 00 00       	mov    $0x3fd,%esi
80108172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80108178:	83 ec 0c             	sub    $0xc,%esp
8010817b:	6a 0a                	push   $0xa
8010817d:	e8 2e bd ff ff       	call   80103eb0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108182:	83 c4 10             	add    $0x10,%esp
80108185:	83 eb 01             	sub    $0x1,%ebx
80108188:	74 07                	je     80108191 <uartputc+0x41>
8010818a:	89 f2                	mov    %esi,%edx
8010818c:	ec                   	in     (%dx),%al
8010818d:	a8 20                	test   $0x20,%al
8010818f:	74 e7                	je     80108178 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108191:	8b 45 08             	mov    0x8(%ebp),%eax
80108194:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108199:	ee                   	out    %al,(%dx)
}
8010819a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010819d:	5b                   	pop    %ebx
8010819e:	5e                   	pop    %esi
8010819f:	5d                   	pop    %ebp
801081a0:	c3                   	ret
801081a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081a8:	c3                   	ret
801081a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801081b0 <uartintr>:

void
uartintr(void)
{
801081b0:	55                   	push   %ebp
801081b1:	89 e5                	mov    %esp,%ebp
801081b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801081b6:	68 30 80 10 80       	push   $0x80108030
801081bb:	e8 b0 8d ff ff       	call   80100f70 <consoleintr>
}
801081c0:	83 c4 10             	add    $0x10,%esp
801081c3:	c9                   	leave
801081c4:	c3                   	ret

801081c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801081c5:	6a 00                	push   $0x0
  pushl $0
801081c7:	6a 00                	push   $0x0
  jmp alltraps
801081c9:	e9 aa fa ff ff       	jmp    80107c78 <alltraps>

801081ce <vector1>:
.globl vector1
vector1:
  pushl $0
801081ce:	6a 00                	push   $0x0
  pushl $1
801081d0:	6a 01                	push   $0x1
  jmp alltraps
801081d2:	e9 a1 fa ff ff       	jmp    80107c78 <alltraps>

801081d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801081d7:	6a 00                	push   $0x0
  pushl $2
801081d9:	6a 02                	push   $0x2
  jmp alltraps
801081db:	e9 98 fa ff ff       	jmp    80107c78 <alltraps>

801081e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801081e0:	6a 00                	push   $0x0
  pushl $3
801081e2:	6a 03                	push   $0x3
  jmp alltraps
801081e4:	e9 8f fa ff ff       	jmp    80107c78 <alltraps>

801081e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801081e9:	6a 00                	push   $0x0
  pushl $4
801081eb:	6a 04                	push   $0x4
  jmp alltraps
801081ed:	e9 86 fa ff ff       	jmp    80107c78 <alltraps>

801081f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801081f2:	6a 00                	push   $0x0
  pushl $5
801081f4:	6a 05                	push   $0x5
  jmp alltraps
801081f6:	e9 7d fa ff ff       	jmp    80107c78 <alltraps>

801081fb <vector6>:
.globl vector6
vector6:
  pushl $0
801081fb:	6a 00                	push   $0x0
  pushl $6
801081fd:	6a 06                	push   $0x6
  jmp alltraps
801081ff:	e9 74 fa ff ff       	jmp    80107c78 <alltraps>

80108204 <vector7>:
.globl vector7
vector7:
  pushl $0
80108204:	6a 00                	push   $0x0
  pushl $7
80108206:	6a 07                	push   $0x7
  jmp alltraps
80108208:	e9 6b fa ff ff       	jmp    80107c78 <alltraps>

8010820d <vector8>:
.globl vector8
vector8:
  pushl $8
8010820d:	6a 08                	push   $0x8
  jmp alltraps
8010820f:	e9 64 fa ff ff       	jmp    80107c78 <alltraps>

80108214 <vector9>:
.globl vector9
vector9:
  pushl $0
80108214:	6a 00                	push   $0x0
  pushl $9
80108216:	6a 09                	push   $0x9
  jmp alltraps
80108218:	e9 5b fa ff ff       	jmp    80107c78 <alltraps>

8010821d <vector10>:
.globl vector10
vector10:
  pushl $10
8010821d:	6a 0a                	push   $0xa
  jmp alltraps
8010821f:	e9 54 fa ff ff       	jmp    80107c78 <alltraps>

80108224 <vector11>:
.globl vector11
vector11:
  pushl $11
80108224:	6a 0b                	push   $0xb
  jmp alltraps
80108226:	e9 4d fa ff ff       	jmp    80107c78 <alltraps>

8010822b <vector12>:
.globl vector12
vector12:
  pushl $12
8010822b:	6a 0c                	push   $0xc
  jmp alltraps
8010822d:	e9 46 fa ff ff       	jmp    80107c78 <alltraps>

80108232 <vector13>:
.globl vector13
vector13:
  pushl $13
80108232:	6a 0d                	push   $0xd
  jmp alltraps
80108234:	e9 3f fa ff ff       	jmp    80107c78 <alltraps>

80108239 <vector14>:
.globl vector14
vector14:
  pushl $14
80108239:	6a 0e                	push   $0xe
  jmp alltraps
8010823b:	e9 38 fa ff ff       	jmp    80107c78 <alltraps>

80108240 <vector15>:
.globl vector15
vector15:
  pushl $0
80108240:	6a 00                	push   $0x0
  pushl $15
80108242:	6a 0f                	push   $0xf
  jmp alltraps
80108244:	e9 2f fa ff ff       	jmp    80107c78 <alltraps>

80108249 <vector16>:
.globl vector16
vector16:
  pushl $0
80108249:	6a 00                	push   $0x0
  pushl $16
8010824b:	6a 10                	push   $0x10
  jmp alltraps
8010824d:	e9 26 fa ff ff       	jmp    80107c78 <alltraps>

80108252 <vector17>:
.globl vector17
vector17:
  pushl $17
80108252:	6a 11                	push   $0x11
  jmp alltraps
80108254:	e9 1f fa ff ff       	jmp    80107c78 <alltraps>

80108259 <vector18>:
.globl vector18
vector18:
  pushl $0
80108259:	6a 00                	push   $0x0
  pushl $18
8010825b:	6a 12                	push   $0x12
  jmp alltraps
8010825d:	e9 16 fa ff ff       	jmp    80107c78 <alltraps>

80108262 <vector19>:
.globl vector19
vector19:
  pushl $0
80108262:	6a 00                	push   $0x0
  pushl $19
80108264:	6a 13                	push   $0x13
  jmp alltraps
80108266:	e9 0d fa ff ff       	jmp    80107c78 <alltraps>

8010826b <vector20>:
.globl vector20
vector20:
  pushl $0
8010826b:	6a 00                	push   $0x0
  pushl $20
8010826d:	6a 14                	push   $0x14
  jmp alltraps
8010826f:	e9 04 fa ff ff       	jmp    80107c78 <alltraps>

80108274 <vector21>:
.globl vector21
vector21:
  pushl $0
80108274:	6a 00                	push   $0x0
  pushl $21
80108276:	6a 15                	push   $0x15
  jmp alltraps
80108278:	e9 fb f9 ff ff       	jmp    80107c78 <alltraps>

8010827d <vector22>:
.globl vector22
vector22:
  pushl $0
8010827d:	6a 00                	push   $0x0
  pushl $22
8010827f:	6a 16                	push   $0x16
  jmp alltraps
80108281:	e9 f2 f9 ff ff       	jmp    80107c78 <alltraps>

80108286 <vector23>:
.globl vector23
vector23:
  pushl $0
80108286:	6a 00                	push   $0x0
  pushl $23
80108288:	6a 17                	push   $0x17
  jmp alltraps
8010828a:	e9 e9 f9 ff ff       	jmp    80107c78 <alltraps>

8010828f <vector24>:
.globl vector24
vector24:
  pushl $0
8010828f:	6a 00                	push   $0x0
  pushl $24
80108291:	6a 18                	push   $0x18
  jmp alltraps
80108293:	e9 e0 f9 ff ff       	jmp    80107c78 <alltraps>

80108298 <vector25>:
.globl vector25
vector25:
  pushl $0
80108298:	6a 00                	push   $0x0
  pushl $25
8010829a:	6a 19                	push   $0x19
  jmp alltraps
8010829c:	e9 d7 f9 ff ff       	jmp    80107c78 <alltraps>

801082a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801082a1:	6a 00                	push   $0x0
  pushl $26
801082a3:	6a 1a                	push   $0x1a
  jmp alltraps
801082a5:	e9 ce f9 ff ff       	jmp    80107c78 <alltraps>

801082aa <vector27>:
.globl vector27
vector27:
  pushl $0
801082aa:	6a 00                	push   $0x0
  pushl $27
801082ac:	6a 1b                	push   $0x1b
  jmp alltraps
801082ae:	e9 c5 f9 ff ff       	jmp    80107c78 <alltraps>

801082b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801082b3:	6a 00                	push   $0x0
  pushl $28
801082b5:	6a 1c                	push   $0x1c
  jmp alltraps
801082b7:	e9 bc f9 ff ff       	jmp    80107c78 <alltraps>

801082bc <vector29>:
.globl vector29
vector29:
  pushl $0
801082bc:	6a 00                	push   $0x0
  pushl $29
801082be:	6a 1d                	push   $0x1d
  jmp alltraps
801082c0:	e9 b3 f9 ff ff       	jmp    80107c78 <alltraps>

801082c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801082c5:	6a 00                	push   $0x0
  pushl $30
801082c7:	6a 1e                	push   $0x1e
  jmp alltraps
801082c9:	e9 aa f9 ff ff       	jmp    80107c78 <alltraps>

801082ce <vector31>:
.globl vector31
vector31:
  pushl $0
801082ce:	6a 00                	push   $0x0
  pushl $31
801082d0:	6a 1f                	push   $0x1f
  jmp alltraps
801082d2:	e9 a1 f9 ff ff       	jmp    80107c78 <alltraps>

801082d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801082d7:	6a 00                	push   $0x0
  pushl $32
801082d9:	6a 20                	push   $0x20
  jmp alltraps
801082db:	e9 98 f9 ff ff       	jmp    80107c78 <alltraps>

801082e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801082e0:	6a 00                	push   $0x0
  pushl $33
801082e2:	6a 21                	push   $0x21
  jmp alltraps
801082e4:	e9 8f f9 ff ff       	jmp    80107c78 <alltraps>

801082e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801082e9:	6a 00                	push   $0x0
  pushl $34
801082eb:	6a 22                	push   $0x22
  jmp alltraps
801082ed:	e9 86 f9 ff ff       	jmp    80107c78 <alltraps>

801082f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801082f2:	6a 00                	push   $0x0
  pushl $35
801082f4:	6a 23                	push   $0x23
  jmp alltraps
801082f6:	e9 7d f9 ff ff       	jmp    80107c78 <alltraps>

801082fb <vector36>:
.globl vector36
vector36:
  pushl $0
801082fb:	6a 00                	push   $0x0
  pushl $36
801082fd:	6a 24                	push   $0x24
  jmp alltraps
801082ff:	e9 74 f9 ff ff       	jmp    80107c78 <alltraps>

80108304 <vector37>:
.globl vector37
vector37:
  pushl $0
80108304:	6a 00                	push   $0x0
  pushl $37
80108306:	6a 25                	push   $0x25
  jmp alltraps
80108308:	e9 6b f9 ff ff       	jmp    80107c78 <alltraps>

8010830d <vector38>:
.globl vector38
vector38:
  pushl $0
8010830d:	6a 00                	push   $0x0
  pushl $38
8010830f:	6a 26                	push   $0x26
  jmp alltraps
80108311:	e9 62 f9 ff ff       	jmp    80107c78 <alltraps>

80108316 <vector39>:
.globl vector39
vector39:
  pushl $0
80108316:	6a 00                	push   $0x0
  pushl $39
80108318:	6a 27                	push   $0x27
  jmp alltraps
8010831a:	e9 59 f9 ff ff       	jmp    80107c78 <alltraps>

8010831f <vector40>:
.globl vector40
vector40:
  pushl $0
8010831f:	6a 00                	push   $0x0
  pushl $40
80108321:	6a 28                	push   $0x28
  jmp alltraps
80108323:	e9 50 f9 ff ff       	jmp    80107c78 <alltraps>

80108328 <vector41>:
.globl vector41
vector41:
  pushl $0
80108328:	6a 00                	push   $0x0
  pushl $41
8010832a:	6a 29                	push   $0x29
  jmp alltraps
8010832c:	e9 47 f9 ff ff       	jmp    80107c78 <alltraps>

80108331 <vector42>:
.globl vector42
vector42:
  pushl $0
80108331:	6a 00                	push   $0x0
  pushl $42
80108333:	6a 2a                	push   $0x2a
  jmp alltraps
80108335:	e9 3e f9 ff ff       	jmp    80107c78 <alltraps>

8010833a <vector43>:
.globl vector43
vector43:
  pushl $0
8010833a:	6a 00                	push   $0x0
  pushl $43
8010833c:	6a 2b                	push   $0x2b
  jmp alltraps
8010833e:	e9 35 f9 ff ff       	jmp    80107c78 <alltraps>

80108343 <vector44>:
.globl vector44
vector44:
  pushl $0
80108343:	6a 00                	push   $0x0
  pushl $44
80108345:	6a 2c                	push   $0x2c
  jmp alltraps
80108347:	e9 2c f9 ff ff       	jmp    80107c78 <alltraps>

8010834c <vector45>:
.globl vector45
vector45:
  pushl $0
8010834c:	6a 00                	push   $0x0
  pushl $45
8010834e:	6a 2d                	push   $0x2d
  jmp alltraps
80108350:	e9 23 f9 ff ff       	jmp    80107c78 <alltraps>

80108355 <vector46>:
.globl vector46
vector46:
  pushl $0
80108355:	6a 00                	push   $0x0
  pushl $46
80108357:	6a 2e                	push   $0x2e
  jmp alltraps
80108359:	e9 1a f9 ff ff       	jmp    80107c78 <alltraps>

8010835e <vector47>:
.globl vector47
vector47:
  pushl $0
8010835e:	6a 00                	push   $0x0
  pushl $47
80108360:	6a 2f                	push   $0x2f
  jmp alltraps
80108362:	e9 11 f9 ff ff       	jmp    80107c78 <alltraps>

80108367 <vector48>:
.globl vector48
vector48:
  pushl $0
80108367:	6a 00                	push   $0x0
  pushl $48
80108369:	6a 30                	push   $0x30
  jmp alltraps
8010836b:	e9 08 f9 ff ff       	jmp    80107c78 <alltraps>

80108370 <vector49>:
.globl vector49
vector49:
  pushl $0
80108370:	6a 00                	push   $0x0
  pushl $49
80108372:	6a 31                	push   $0x31
  jmp alltraps
80108374:	e9 ff f8 ff ff       	jmp    80107c78 <alltraps>

80108379 <vector50>:
.globl vector50
vector50:
  pushl $0
80108379:	6a 00                	push   $0x0
  pushl $50
8010837b:	6a 32                	push   $0x32
  jmp alltraps
8010837d:	e9 f6 f8 ff ff       	jmp    80107c78 <alltraps>

80108382 <vector51>:
.globl vector51
vector51:
  pushl $0
80108382:	6a 00                	push   $0x0
  pushl $51
80108384:	6a 33                	push   $0x33
  jmp alltraps
80108386:	e9 ed f8 ff ff       	jmp    80107c78 <alltraps>

8010838b <vector52>:
.globl vector52
vector52:
  pushl $0
8010838b:	6a 00                	push   $0x0
  pushl $52
8010838d:	6a 34                	push   $0x34
  jmp alltraps
8010838f:	e9 e4 f8 ff ff       	jmp    80107c78 <alltraps>

80108394 <vector53>:
.globl vector53
vector53:
  pushl $0
80108394:	6a 00                	push   $0x0
  pushl $53
80108396:	6a 35                	push   $0x35
  jmp alltraps
80108398:	e9 db f8 ff ff       	jmp    80107c78 <alltraps>

8010839d <vector54>:
.globl vector54
vector54:
  pushl $0
8010839d:	6a 00                	push   $0x0
  pushl $54
8010839f:	6a 36                	push   $0x36
  jmp alltraps
801083a1:	e9 d2 f8 ff ff       	jmp    80107c78 <alltraps>

801083a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801083a6:	6a 00                	push   $0x0
  pushl $55
801083a8:	6a 37                	push   $0x37
  jmp alltraps
801083aa:	e9 c9 f8 ff ff       	jmp    80107c78 <alltraps>

801083af <vector56>:
.globl vector56
vector56:
  pushl $0
801083af:	6a 00                	push   $0x0
  pushl $56
801083b1:	6a 38                	push   $0x38
  jmp alltraps
801083b3:	e9 c0 f8 ff ff       	jmp    80107c78 <alltraps>

801083b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801083b8:	6a 00                	push   $0x0
  pushl $57
801083ba:	6a 39                	push   $0x39
  jmp alltraps
801083bc:	e9 b7 f8 ff ff       	jmp    80107c78 <alltraps>

801083c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801083c1:	6a 00                	push   $0x0
  pushl $58
801083c3:	6a 3a                	push   $0x3a
  jmp alltraps
801083c5:	e9 ae f8 ff ff       	jmp    80107c78 <alltraps>

801083ca <vector59>:
.globl vector59
vector59:
  pushl $0
801083ca:	6a 00                	push   $0x0
  pushl $59
801083cc:	6a 3b                	push   $0x3b
  jmp alltraps
801083ce:	e9 a5 f8 ff ff       	jmp    80107c78 <alltraps>

801083d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801083d3:	6a 00                	push   $0x0
  pushl $60
801083d5:	6a 3c                	push   $0x3c
  jmp alltraps
801083d7:	e9 9c f8 ff ff       	jmp    80107c78 <alltraps>

801083dc <vector61>:
.globl vector61
vector61:
  pushl $0
801083dc:	6a 00                	push   $0x0
  pushl $61
801083de:	6a 3d                	push   $0x3d
  jmp alltraps
801083e0:	e9 93 f8 ff ff       	jmp    80107c78 <alltraps>

801083e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801083e5:	6a 00                	push   $0x0
  pushl $62
801083e7:	6a 3e                	push   $0x3e
  jmp alltraps
801083e9:	e9 8a f8 ff ff       	jmp    80107c78 <alltraps>

801083ee <vector63>:
.globl vector63
vector63:
  pushl $0
801083ee:	6a 00                	push   $0x0
  pushl $63
801083f0:	6a 3f                	push   $0x3f
  jmp alltraps
801083f2:	e9 81 f8 ff ff       	jmp    80107c78 <alltraps>

801083f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801083f7:	6a 00                	push   $0x0
  pushl $64
801083f9:	6a 40                	push   $0x40
  jmp alltraps
801083fb:	e9 78 f8 ff ff       	jmp    80107c78 <alltraps>

80108400 <vector65>:
.globl vector65
vector65:
  pushl $0
80108400:	6a 00                	push   $0x0
  pushl $65
80108402:	6a 41                	push   $0x41
  jmp alltraps
80108404:	e9 6f f8 ff ff       	jmp    80107c78 <alltraps>

80108409 <vector66>:
.globl vector66
vector66:
  pushl $0
80108409:	6a 00                	push   $0x0
  pushl $66
8010840b:	6a 42                	push   $0x42
  jmp alltraps
8010840d:	e9 66 f8 ff ff       	jmp    80107c78 <alltraps>

80108412 <vector67>:
.globl vector67
vector67:
  pushl $0
80108412:	6a 00                	push   $0x0
  pushl $67
80108414:	6a 43                	push   $0x43
  jmp alltraps
80108416:	e9 5d f8 ff ff       	jmp    80107c78 <alltraps>

8010841b <vector68>:
.globl vector68
vector68:
  pushl $0
8010841b:	6a 00                	push   $0x0
  pushl $68
8010841d:	6a 44                	push   $0x44
  jmp alltraps
8010841f:	e9 54 f8 ff ff       	jmp    80107c78 <alltraps>

80108424 <vector69>:
.globl vector69
vector69:
  pushl $0
80108424:	6a 00                	push   $0x0
  pushl $69
80108426:	6a 45                	push   $0x45
  jmp alltraps
80108428:	e9 4b f8 ff ff       	jmp    80107c78 <alltraps>

8010842d <vector70>:
.globl vector70
vector70:
  pushl $0
8010842d:	6a 00                	push   $0x0
  pushl $70
8010842f:	6a 46                	push   $0x46
  jmp alltraps
80108431:	e9 42 f8 ff ff       	jmp    80107c78 <alltraps>

80108436 <vector71>:
.globl vector71
vector71:
  pushl $0
80108436:	6a 00                	push   $0x0
  pushl $71
80108438:	6a 47                	push   $0x47
  jmp alltraps
8010843a:	e9 39 f8 ff ff       	jmp    80107c78 <alltraps>

8010843f <vector72>:
.globl vector72
vector72:
  pushl $0
8010843f:	6a 00                	push   $0x0
  pushl $72
80108441:	6a 48                	push   $0x48
  jmp alltraps
80108443:	e9 30 f8 ff ff       	jmp    80107c78 <alltraps>

80108448 <vector73>:
.globl vector73
vector73:
  pushl $0
80108448:	6a 00                	push   $0x0
  pushl $73
8010844a:	6a 49                	push   $0x49
  jmp alltraps
8010844c:	e9 27 f8 ff ff       	jmp    80107c78 <alltraps>

80108451 <vector74>:
.globl vector74
vector74:
  pushl $0
80108451:	6a 00                	push   $0x0
  pushl $74
80108453:	6a 4a                	push   $0x4a
  jmp alltraps
80108455:	e9 1e f8 ff ff       	jmp    80107c78 <alltraps>

8010845a <vector75>:
.globl vector75
vector75:
  pushl $0
8010845a:	6a 00                	push   $0x0
  pushl $75
8010845c:	6a 4b                	push   $0x4b
  jmp alltraps
8010845e:	e9 15 f8 ff ff       	jmp    80107c78 <alltraps>

80108463 <vector76>:
.globl vector76
vector76:
  pushl $0
80108463:	6a 00                	push   $0x0
  pushl $76
80108465:	6a 4c                	push   $0x4c
  jmp alltraps
80108467:	e9 0c f8 ff ff       	jmp    80107c78 <alltraps>

8010846c <vector77>:
.globl vector77
vector77:
  pushl $0
8010846c:	6a 00                	push   $0x0
  pushl $77
8010846e:	6a 4d                	push   $0x4d
  jmp alltraps
80108470:	e9 03 f8 ff ff       	jmp    80107c78 <alltraps>

80108475 <vector78>:
.globl vector78
vector78:
  pushl $0
80108475:	6a 00                	push   $0x0
  pushl $78
80108477:	6a 4e                	push   $0x4e
  jmp alltraps
80108479:	e9 fa f7 ff ff       	jmp    80107c78 <alltraps>

8010847e <vector79>:
.globl vector79
vector79:
  pushl $0
8010847e:	6a 00                	push   $0x0
  pushl $79
80108480:	6a 4f                	push   $0x4f
  jmp alltraps
80108482:	e9 f1 f7 ff ff       	jmp    80107c78 <alltraps>

80108487 <vector80>:
.globl vector80
vector80:
  pushl $0
80108487:	6a 00                	push   $0x0
  pushl $80
80108489:	6a 50                	push   $0x50
  jmp alltraps
8010848b:	e9 e8 f7 ff ff       	jmp    80107c78 <alltraps>

80108490 <vector81>:
.globl vector81
vector81:
  pushl $0
80108490:	6a 00                	push   $0x0
  pushl $81
80108492:	6a 51                	push   $0x51
  jmp alltraps
80108494:	e9 df f7 ff ff       	jmp    80107c78 <alltraps>

80108499 <vector82>:
.globl vector82
vector82:
  pushl $0
80108499:	6a 00                	push   $0x0
  pushl $82
8010849b:	6a 52                	push   $0x52
  jmp alltraps
8010849d:	e9 d6 f7 ff ff       	jmp    80107c78 <alltraps>

801084a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801084a2:	6a 00                	push   $0x0
  pushl $83
801084a4:	6a 53                	push   $0x53
  jmp alltraps
801084a6:	e9 cd f7 ff ff       	jmp    80107c78 <alltraps>

801084ab <vector84>:
.globl vector84
vector84:
  pushl $0
801084ab:	6a 00                	push   $0x0
  pushl $84
801084ad:	6a 54                	push   $0x54
  jmp alltraps
801084af:	e9 c4 f7 ff ff       	jmp    80107c78 <alltraps>

801084b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801084b4:	6a 00                	push   $0x0
  pushl $85
801084b6:	6a 55                	push   $0x55
  jmp alltraps
801084b8:	e9 bb f7 ff ff       	jmp    80107c78 <alltraps>

801084bd <vector86>:
.globl vector86
vector86:
  pushl $0
801084bd:	6a 00                	push   $0x0
  pushl $86
801084bf:	6a 56                	push   $0x56
  jmp alltraps
801084c1:	e9 b2 f7 ff ff       	jmp    80107c78 <alltraps>

801084c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801084c6:	6a 00                	push   $0x0
  pushl $87
801084c8:	6a 57                	push   $0x57
  jmp alltraps
801084ca:	e9 a9 f7 ff ff       	jmp    80107c78 <alltraps>

801084cf <vector88>:
.globl vector88
vector88:
  pushl $0
801084cf:	6a 00                	push   $0x0
  pushl $88
801084d1:	6a 58                	push   $0x58
  jmp alltraps
801084d3:	e9 a0 f7 ff ff       	jmp    80107c78 <alltraps>

801084d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801084d8:	6a 00                	push   $0x0
  pushl $89
801084da:	6a 59                	push   $0x59
  jmp alltraps
801084dc:	e9 97 f7 ff ff       	jmp    80107c78 <alltraps>

801084e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801084e1:	6a 00                	push   $0x0
  pushl $90
801084e3:	6a 5a                	push   $0x5a
  jmp alltraps
801084e5:	e9 8e f7 ff ff       	jmp    80107c78 <alltraps>

801084ea <vector91>:
.globl vector91
vector91:
  pushl $0
801084ea:	6a 00                	push   $0x0
  pushl $91
801084ec:	6a 5b                	push   $0x5b
  jmp alltraps
801084ee:	e9 85 f7 ff ff       	jmp    80107c78 <alltraps>

801084f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801084f3:	6a 00                	push   $0x0
  pushl $92
801084f5:	6a 5c                	push   $0x5c
  jmp alltraps
801084f7:	e9 7c f7 ff ff       	jmp    80107c78 <alltraps>

801084fc <vector93>:
.globl vector93
vector93:
  pushl $0
801084fc:	6a 00                	push   $0x0
  pushl $93
801084fe:	6a 5d                	push   $0x5d
  jmp alltraps
80108500:	e9 73 f7 ff ff       	jmp    80107c78 <alltraps>

80108505 <vector94>:
.globl vector94
vector94:
  pushl $0
80108505:	6a 00                	push   $0x0
  pushl $94
80108507:	6a 5e                	push   $0x5e
  jmp alltraps
80108509:	e9 6a f7 ff ff       	jmp    80107c78 <alltraps>

8010850e <vector95>:
.globl vector95
vector95:
  pushl $0
8010850e:	6a 00                	push   $0x0
  pushl $95
80108510:	6a 5f                	push   $0x5f
  jmp alltraps
80108512:	e9 61 f7 ff ff       	jmp    80107c78 <alltraps>

80108517 <vector96>:
.globl vector96
vector96:
  pushl $0
80108517:	6a 00                	push   $0x0
  pushl $96
80108519:	6a 60                	push   $0x60
  jmp alltraps
8010851b:	e9 58 f7 ff ff       	jmp    80107c78 <alltraps>

80108520 <vector97>:
.globl vector97
vector97:
  pushl $0
80108520:	6a 00                	push   $0x0
  pushl $97
80108522:	6a 61                	push   $0x61
  jmp alltraps
80108524:	e9 4f f7 ff ff       	jmp    80107c78 <alltraps>

80108529 <vector98>:
.globl vector98
vector98:
  pushl $0
80108529:	6a 00                	push   $0x0
  pushl $98
8010852b:	6a 62                	push   $0x62
  jmp alltraps
8010852d:	e9 46 f7 ff ff       	jmp    80107c78 <alltraps>

80108532 <vector99>:
.globl vector99
vector99:
  pushl $0
80108532:	6a 00                	push   $0x0
  pushl $99
80108534:	6a 63                	push   $0x63
  jmp alltraps
80108536:	e9 3d f7 ff ff       	jmp    80107c78 <alltraps>

8010853b <vector100>:
.globl vector100
vector100:
  pushl $0
8010853b:	6a 00                	push   $0x0
  pushl $100
8010853d:	6a 64                	push   $0x64
  jmp alltraps
8010853f:	e9 34 f7 ff ff       	jmp    80107c78 <alltraps>

80108544 <vector101>:
.globl vector101
vector101:
  pushl $0
80108544:	6a 00                	push   $0x0
  pushl $101
80108546:	6a 65                	push   $0x65
  jmp alltraps
80108548:	e9 2b f7 ff ff       	jmp    80107c78 <alltraps>

8010854d <vector102>:
.globl vector102
vector102:
  pushl $0
8010854d:	6a 00                	push   $0x0
  pushl $102
8010854f:	6a 66                	push   $0x66
  jmp alltraps
80108551:	e9 22 f7 ff ff       	jmp    80107c78 <alltraps>

80108556 <vector103>:
.globl vector103
vector103:
  pushl $0
80108556:	6a 00                	push   $0x0
  pushl $103
80108558:	6a 67                	push   $0x67
  jmp alltraps
8010855a:	e9 19 f7 ff ff       	jmp    80107c78 <alltraps>

8010855f <vector104>:
.globl vector104
vector104:
  pushl $0
8010855f:	6a 00                	push   $0x0
  pushl $104
80108561:	6a 68                	push   $0x68
  jmp alltraps
80108563:	e9 10 f7 ff ff       	jmp    80107c78 <alltraps>

80108568 <vector105>:
.globl vector105
vector105:
  pushl $0
80108568:	6a 00                	push   $0x0
  pushl $105
8010856a:	6a 69                	push   $0x69
  jmp alltraps
8010856c:	e9 07 f7 ff ff       	jmp    80107c78 <alltraps>

80108571 <vector106>:
.globl vector106
vector106:
  pushl $0
80108571:	6a 00                	push   $0x0
  pushl $106
80108573:	6a 6a                	push   $0x6a
  jmp alltraps
80108575:	e9 fe f6 ff ff       	jmp    80107c78 <alltraps>

8010857a <vector107>:
.globl vector107
vector107:
  pushl $0
8010857a:	6a 00                	push   $0x0
  pushl $107
8010857c:	6a 6b                	push   $0x6b
  jmp alltraps
8010857e:	e9 f5 f6 ff ff       	jmp    80107c78 <alltraps>

80108583 <vector108>:
.globl vector108
vector108:
  pushl $0
80108583:	6a 00                	push   $0x0
  pushl $108
80108585:	6a 6c                	push   $0x6c
  jmp alltraps
80108587:	e9 ec f6 ff ff       	jmp    80107c78 <alltraps>

8010858c <vector109>:
.globl vector109
vector109:
  pushl $0
8010858c:	6a 00                	push   $0x0
  pushl $109
8010858e:	6a 6d                	push   $0x6d
  jmp alltraps
80108590:	e9 e3 f6 ff ff       	jmp    80107c78 <alltraps>

80108595 <vector110>:
.globl vector110
vector110:
  pushl $0
80108595:	6a 00                	push   $0x0
  pushl $110
80108597:	6a 6e                	push   $0x6e
  jmp alltraps
80108599:	e9 da f6 ff ff       	jmp    80107c78 <alltraps>

8010859e <vector111>:
.globl vector111
vector111:
  pushl $0
8010859e:	6a 00                	push   $0x0
  pushl $111
801085a0:	6a 6f                	push   $0x6f
  jmp alltraps
801085a2:	e9 d1 f6 ff ff       	jmp    80107c78 <alltraps>

801085a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801085a7:	6a 00                	push   $0x0
  pushl $112
801085a9:	6a 70                	push   $0x70
  jmp alltraps
801085ab:	e9 c8 f6 ff ff       	jmp    80107c78 <alltraps>

801085b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801085b0:	6a 00                	push   $0x0
  pushl $113
801085b2:	6a 71                	push   $0x71
  jmp alltraps
801085b4:	e9 bf f6 ff ff       	jmp    80107c78 <alltraps>

801085b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801085b9:	6a 00                	push   $0x0
  pushl $114
801085bb:	6a 72                	push   $0x72
  jmp alltraps
801085bd:	e9 b6 f6 ff ff       	jmp    80107c78 <alltraps>

801085c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801085c2:	6a 00                	push   $0x0
  pushl $115
801085c4:	6a 73                	push   $0x73
  jmp alltraps
801085c6:	e9 ad f6 ff ff       	jmp    80107c78 <alltraps>

801085cb <vector116>:
.globl vector116
vector116:
  pushl $0
801085cb:	6a 00                	push   $0x0
  pushl $116
801085cd:	6a 74                	push   $0x74
  jmp alltraps
801085cf:	e9 a4 f6 ff ff       	jmp    80107c78 <alltraps>

801085d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801085d4:	6a 00                	push   $0x0
  pushl $117
801085d6:	6a 75                	push   $0x75
  jmp alltraps
801085d8:	e9 9b f6 ff ff       	jmp    80107c78 <alltraps>

801085dd <vector118>:
.globl vector118
vector118:
  pushl $0
801085dd:	6a 00                	push   $0x0
  pushl $118
801085df:	6a 76                	push   $0x76
  jmp alltraps
801085e1:	e9 92 f6 ff ff       	jmp    80107c78 <alltraps>

801085e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801085e6:	6a 00                	push   $0x0
  pushl $119
801085e8:	6a 77                	push   $0x77
  jmp alltraps
801085ea:	e9 89 f6 ff ff       	jmp    80107c78 <alltraps>

801085ef <vector120>:
.globl vector120
vector120:
  pushl $0
801085ef:	6a 00                	push   $0x0
  pushl $120
801085f1:	6a 78                	push   $0x78
  jmp alltraps
801085f3:	e9 80 f6 ff ff       	jmp    80107c78 <alltraps>

801085f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801085f8:	6a 00                	push   $0x0
  pushl $121
801085fa:	6a 79                	push   $0x79
  jmp alltraps
801085fc:	e9 77 f6 ff ff       	jmp    80107c78 <alltraps>

80108601 <vector122>:
.globl vector122
vector122:
  pushl $0
80108601:	6a 00                	push   $0x0
  pushl $122
80108603:	6a 7a                	push   $0x7a
  jmp alltraps
80108605:	e9 6e f6 ff ff       	jmp    80107c78 <alltraps>

8010860a <vector123>:
.globl vector123
vector123:
  pushl $0
8010860a:	6a 00                	push   $0x0
  pushl $123
8010860c:	6a 7b                	push   $0x7b
  jmp alltraps
8010860e:	e9 65 f6 ff ff       	jmp    80107c78 <alltraps>

80108613 <vector124>:
.globl vector124
vector124:
  pushl $0
80108613:	6a 00                	push   $0x0
  pushl $124
80108615:	6a 7c                	push   $0x7c
  jmp alltraps
80108617:	e9 5c f6 ff ff       	jmp    80107c78 <alltraps>

8010861c <vector125>:
.globl vector125
vector125:
  pushl $0
8010861c:	6a 00                	push   $0x0
  pushl $125
8010861e:	6a 7d                	push   $0x7d
  jmp alltraps
80108620:	e9 53 f6 ff ff       	jmp    80107c78 <alltraps>

80108625 <vector126>:
.globl vector126
vector126:
  pushl $0
80108625:	6a 00                	push   $0x0
  pushl $126
80108627:	6a 7e                	push   $0x7e
  jmp alltraps
80108629:	e9 4a f6 ff ff       	jmp    80107c78 <alltraps>

8010862e <vector127>:
.globl vector127
vector127:
  pushl $0
8010862e:	6a 00                	push   $0x0
  pushl $127
80108630:	6a 7f                	push   $0x7f
  jmp alltraps
80108632:	e9 41 f6 ff ff       	jmp    80107c78 <alltraps>

80108637 <vector128>:
.globl vector128
vector128:
  pushl $0
80108637:	6a 00                	push   $0x0
  pushl $128
80108639:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010863e:	e9 35 f6 ff ff       	jmp    80107c78 <alltraps>

80108643 <vector129>:
.globl vector129
vector129:
  pushl $0
80108643:	6a 00                	push   $0x0
  pushl $129
80108645:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010864a:	e9 29 f6 ff ff       	jmp    80107c78 <alltraps>

8010864f <vector130>:
.globl vector130
vector130:
  pushl $0
8010864f:	6a 00                	push   $0x0
  pushl $130
80108651:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108656:	e9 1d f6 ff ff       	jmp    80107c78 <alltraps>

8010865b <vector131>:
.globl vector131
vector131:
  pushl $0
8010865b:	6a 00                	push   $0x0
  pushl $131
8010865d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108662:	e9 11 f6 ff ff       	jmp    80107c78 <alltraps>

80108667 <vector132>:
.globl vector132
vector132:
  pushl $0
80108667:	6a 00                	push   $0x0
  pushl $132
80108669:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010866e:	e9 05 f6 ff ff       	jmp    80107c78 <alltraps>

80108673 <vector133>:
.globl vector133
vector133:
  pushl $0
80108673:	6a 00                	push   $0x0
  pushl $133
80108675:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010867a:	e9 f9 f5 ff ff       	jmp    80107c78 <alltraps>

8010867f <vector134>:
.globl vector134
vector134:
  pushl $0
8010867f:	6a 00                	push   $0x0
  pushl $134
80108681:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108686:	e9 ed f5 ff ff       	jmp    80107c78 <alltraps>

8010868b <vector135>:
.globl vector135
vector135:
  pushl $0
8010868b:	6a 00                	push   $0x0
  pushl $135
8010868d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108692:	e9 e1 f5 ff ff       	jmp    80107c78 <alltraps>

80108697 <vector136>:
.globl vector136
vector136:
  pushl $0
80108697:	6a 00                	push   $0x0
  pushl $136
80108699:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010869e:	e9 d5 f5 ff ff       	jmp    80107c78 <alltraps>

801086a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801086a3:	6a 00                	push   $0x0
  pushl $137
801086a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801086aa:	e9 c9 f5 ff ff       	jmp    80107c78 <alltraps>

801086af <vector138>:
.globl vector138
vector138:
  pushl $0
801086af:	6a 00                	push   $0x0
  pushl $138
801086b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801086b6:	e9 bd f5 ff ff       	jmp    80107c78 <alltraps>

801086bb <vector139>:
.globl vector139
vector139:
  pushl $0
801086bb:	6a 00                	push   $0x0
  pushl $139
801086bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801086c2:	e9 b1 f5 ff ff       	jmp    80107c78 <alltraps>

801086c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801086c7:	6a 00                	push   $0x0
  pushl $140
801086c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801086ce:	e9 a5 f5 ff ff       	jmp    80107c78 <alltraps>

801086d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801086d3:	6a 00                	push   $0x0
  pushl $141
801086d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801086da:	e9 99 f5 ff ff       	jmp    80107c78 <alltraps>

801086df <vector142>:
.globl vector142
vector142:
  pushl $0
801086df:	6a 00                	push   $0x0
  pushl $142
801086e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801086e6:	e9 8d f5 ff ff       	jmp    80107c78 <alltraps>

801086eb <vector143>:
.globl vector143
vector143:
  pushl $0
801086eb:	6a 00                	push   $0x0
  pushl $143
801086ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801086f2:	e9 81 f5 ff ff       	jmp    80107c78 <alltraps>

801086f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801086f7:	6a 00                	push   $0x0
  pushl $144
801086f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801086fe:	e9 75 f5 ff ff       	jmp    80107c78 <alltraps>

80108703 <vector145>:
.globl vector145
vector145:
  pushl $0
80108703:	6a 00                	push   $0x0
  pushl $145
80108705:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010870a:	e9 69 f5 ff ff       	jmp    80107c78 <alltraps>

8010870f <vector146>:
.globl vector146
vector146:
  pushl $0
8010870f:	6a 00                	push   $0x0
  pushl $146
80108711:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108716:	e9 5d f5 ff ff       	jmp    80107c78 <alltraps>

8010871b <vector147>:
.globl vector147
vector147:
  pushl $0
8010871b:	6a 00                	push   $0x0
  pushl $147
8010871d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108722:	e9 51 f5 ff ff       	jmp    80107c78 <alltraps>

80108727 <vector148>:
.globl vector148
vector148:
  pushl $0
80108727:	6a 00                	push   $0x0
  pushl $148
80108729:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010872e:	e9 45 f5 ff ff       	jmp    80107c78 <alltraps>

80108733 <vector149>:
.globl vector149
vector149:
  pushl $0
80108733:	6a 00                	push   $0x0
  pushl $149
80108735:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010873a:	e9 39 f5 ff ff       	jmp    80107c78 <alltraps>

8010873f <vector150>:
.globl vector150
vector150:
  pushl $0
8010873f:	6a 00                	push   $0x0
  pushl $150
80108741:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108746:	e9 2d f5 ff ff       	jmp    80107c78 <alltraps>

8010874b <vector151>:
.globl vector151
vector151:
  pushl $0
8010874b:	6a 00                	push   $0x0
  pushl $151
8010874d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108752:	e9 21 f5 ff ff       	jmp    80107c78 <alltraps>

80108757 <vector152>:
.globl vector152
vector152:
  pushl $0
80108757:	6a 00                	push   $0x0
  pushl $152
80108759:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010875e:	e9 15 f5 ff ff       	jmp    80107c78 <alltraps>

80108763 <vector153>:
.globl vector153
vector153:
  pushl $0
80108763:	6a 00                	push   $0x0
  pushl $153
80108765:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010876a:	e9 09 f5 ff ff       	jmp    80107c78 <alltraps>

8010876f <vector154>:
.globl vector154
vector154:
  pushl $0
8010876f:	6a 00                	push   $0x0
  pushl $154
80108771:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108776:	e9 fd f4 ff ff       	jmp    80107c78 <alltraps>

8010877b <vector155>:
.globl vector155
vector155:
  pushl $0
8010877b:	6a 00                	push   $0x0
  pushl $155
8010877d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108782:	e9 f1 f4 ff ff       	jmp    80107c78 <alltraps>

80108787 <vector156>:
.globl vector156
vector156:
  pushl $0
80108787:	6a 00                	push   $0x0
  pushl $156
80108789:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010878e:	e9 e5 f4 ff ff       	jmp    80107c78 <alltraps>

80108793 <vector157>:
.globl vector157
vector157:
  pushl $0
80108793:	6a 00                	push   $0x0
  pushl $157
80108795:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010879a:	e9 d9 f4 ff ff       	jmp    80107c78 <alltraps>

8010879f <vector158>:
.globl vector158
vector158:
  pushl $0
8010879f:	6a 00                	push   $0x0
  pushl $158
801087a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801087a6:	e9 cd f4 ff ff       	jmp    80107c78 <alltraps>

801087ab <vector159>:
.globl vector159
vector159:
  pushl $0
801087ab:	6a 00                	push   $0x0
  pushl $159
801087ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801087b2:	e9 c1 f4 ff ff       	jmp    80107c78 <alltraps>

801087b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801087b7:	6a 00                	push   $0x0
  pushl $160
801087b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801087be:	e9 b5 f4 ff ff       	jmp    80107c78 <alltraps>

801087c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801087c3:	6a 00                	push   $0x0
  pushl $161
801087c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801087ca:	e9 a9 f4 ff ff       	jmp    80107c78 <alltraps>

801087cf <vector162>:
.globl vector162
vector162:
  pushl $0
801087cf:	6a 00                	push   $0x0
  pushl $162
801087d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801087d6:	e9 9d f4 ff ff       	jmp    80107c78 <alltraps>

801087db <vector163>:
.globl vector163
vector163:
  pushl $0
801087db:	6a 00                	push   $0x0
  pushl $163
801087dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801087e2:	e9 91 f4 ff ff       	jmp    80107c78 <alltraps>

801087e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801087e7:	6a 00                	push   $0x0
  pushl $164
801087e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801087ee:	e9 85 f4 ff ff       	jmp    80107c78 <alltraps>

801087f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801087f3:	6a 00                	push   $0x0
  pushl $165
801087f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801087fa:	e9 79 f4 ff ff       	jmp    80107c78 <alltraps>

801087ff <vector166>:
.globl vector166
vector166:
  pushl $0
801087ff:	6a 00                	push   $0x0
  pushl $166
80108801:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108806:	e9 6d f4 ff ff       	jmp    80107c78 <alltraps>

8010880b <vector167>:
.globl vector167
vector167:
  pushl $0
8010880b:	6a 00                	push   $0x0
  pushl $167
8010880d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108812:	e9 61 f4 ff ff       	jmp    80107c78 <alltraps>

80108817 <vector168>:
.globl vector168
vector168:
  pushl $0
80108817:	6a 00                	push   $0x0
  pushl $168
80108819:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010881e:	e9 55 f4 ff ff       	jmp    80107c78 <alltraps>

80108823 <vector169>:
.globl vector169
vector169:
  pushl $0
80108823:	6a 00                	push   $0x0
  pushl $169
80108825:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010882a:	e9 49 f4 ff ff       	jmp    80107c78 <alltraps>

8010882f <vector170>:
.globl vector170
vector170:
  pushl $0
8010882f:	6a 00                	push   $0x0
  pushl $170
80108831:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108836:	e9 3d f4 ff ff       	jmp    80107c78 <alltraps>

8010883b <vector171>:
.globl vector171
vector171:
  pushl $0
8010883b:	6a 00                	push   $0x0
  pushl $171
8010883d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108842:	e9 31 f4 ff ff       	jmp    80107c78 <alltraps>

80108847 <vector172>:
.globl vector172
vector172:
  pushl $0
80108847:	6a 00                	push   $0x0
  pushl $172
80108849:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010884e:	e9 25 f4 ff ff       	jmp    80107c78 <alltraps>

80108853 <vector173>:
.globl vector173
vector173:
  pushl $0
80108853:	6a 00                	push   $0x0
  pushl $173
80108855:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010885a:	e9 19 f4 ff ff       	jmp    80107c78 <alltraps>

8010885f <vector174>:
.globl vector174
vector174:
  pushl $0
8010885f:	6a 00                	push   $0x0
  pushl $174
80108861:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108866:	e9 0d f4 ff ff       	jmp    80107c78 <alltraps>

8010886b <vector175>:
.globl vector175
vector175:
  pushl $0
8010886b:	6a 00                	push   $0x0
  pushl $175
8010886d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108872:	e9 01 f4 ff ff       	jmp    80107c78 <alltraps>

80108877 <vector176>:
.globl vector176
vector176:
  pushl $0
80108877:	6a 00                	push   $0x0
  pushl $176
80108879:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010887e:	e9 f5 f3 ff ff       	jmp    80107c78 <alltraps>

80108883 <vector177>:
.globl vector177
vector177:
  pushl $0
80108883:	6a 00                	push   $0x0
  pushl $177
80108885:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010888a:	e9 e9 f3 ff ff       	jmp    80107c78 <alltraps>

8010888f <vector178>:
.globl vector178
vector178:
  pushl $0
8010888f:	6a 00                	push   $0x0
  pushl $178
80108891:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108896:	e9 dd f3 ff ff       	jmp    80107c78 <alltraps>

8010889b <vector179>:
.globl vector179
vector179:
  pushl $0
8010889b:	6a 00                	push   $0x0
  pushl $179
8010889d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801088a2:	e9 d1 f3 ff ff       	jmp    80107c78 <alltraps>

801088a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801088a7:	6a 00                	push   $0x0
  pushl $180
801088a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801088ae:	e9 c5 f3 ff ff       	jmp    80107c78 <alltraps>

801088b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801088b3:	6a 00                	push   $0x0
  pushl $181
801088b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801088ba:	e9 b9 f3 ff ff       	jmp    80107c78 <alltraps>

801088bf <vector182>:
.globl vector182
vector182:
  pushl $0
801088bf:	6a 00                	push   $0x0
  pushl $182
801088c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801088c6:	e9 ad f3 ff ff       	jmp    80107c78 <alltraps>

801088cb <vector183>:
.globl vector183
vector183:
  pushl $0
801088cb:	6a 00                	push   $0x0
  pushl $183
801088cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801088d2:	e9 a1 f3 ff ff       	jmp    80107c78 <alltraps>

801088d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801088d7:	6a 00                	push   $0x0
  pushl $184
801088d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801088de:	e9 95 f3 ff ff       	jmp    80107c78 <alltraps>

801088e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801088e3:	6a 00                	push   $0x0
  pushl $185
801088e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801088ea:	e9 89 f3 ff ff       	jmp    80107c78 <alltraps>

801088ef <vector186>:
.globl vector186
vector186:
  pushl $0
801088ef:	6a 00                	push   $0x0
  pushl $186
801088f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801088f6:	e9 7d f3 ff ff       	jmp    80107c78 <alltraps>

801088fb <vector187>:
.globl vector187
vector187:
  pushl $0
801088fb:	6a 00                	push   $0x0
  pushl $187
801088fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108902:	e9 71 f3 ff ff       	jmp    80107c78 <alltraps>

80108907 <vector188>:
.globl vector188
vector188:
  pushl $0
80108907:	6a 00                	push   $0x0
  pushl $188
80108909:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010890e:	e9 65 f3 ff ff       	jmp    80107c78 <alltraps>

80108913 <vector189>:
.globl vector189
vector189:
  pushl $0
80108913:	6a 00                	push   $0x0
  pushl $189
80108915:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010891a:	e9 59 f3 ff ff       	jmp    80107c78 <alltraps>

8010891f <vector190>:
.globl vector190
vector190:
  pushl $0
8010891f:	6a 00                	push   $0x0
  pushl $190
80108921:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108926:	e9 4d f3 ff ff       	jmp    80107c78 <alltraps>

8010892b <vector191>:
.globl vector191
vector191:
  pushl $0
8010892b:	6a 00                	push   $0x0
  pushl $191
8010892d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108932:	e9 41 f3 ff ff       	jmp    80107c78 <alltraps>

80108937 <vector192>:
.globl vector192
vector192:
  pushl $0
80108937:	6a 00                	push   $0x0
  pushl $192
80108939:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010893e:	e9 35 f3 ff ff       	jmp    80107c78 <alltraps>

80108943 <vector193>:
.globl vector193
vector193:
  pushl $0
80108943:	6a 00                	push   $0x0
  pushl $193
80108945:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010894a:	e9 29 f3 ff ff       	jmp    80107c78 <alltraps>

8010894f <vector194>:
.globl vector194
vector194:
  pushl $0
8010894f:	6a 00                	push   $0x0
  pushl $194
80108951:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108956:	e9 1d f3 ff ff       	jmp    80107c78 <alltraps>

8010895b <vector195>:
.globl vector195
vector195:
  pushl $0
8010895b:	6a 00                	push   $0x0
  pushl $195
8010895d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108962:	e9 11 f3 ff ff       	jmp    80107c78 <alltraps>

80108967 <vector196>:
.globl vector196
vector196:
  pushl $0
80108967:	6a 00                	push   $0x0
  pushl $196
80108969:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010896e:	e9 05 f3 ff ff       	jmp    80107c78 <alltraps>

80108973 <vector197>:
.globl vector197
vector197:
  pushl $0
80108973:	6a 00                	push   $0x0
  pushl $197
80108975:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010897a:	e9 f9 f2 ff ff       	jmp    80107c78 <alltraps>

8010897f <vector198>:
.globl vector198
vector198:
  pushl $0
8010897f:	6a 00                	push   $0x0
  pushl $198
80108981:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108986:	e9 ed f2 ff ff       	jmp    80107c78 <alltraps>

8010898b <vector199>:
.globl vector199
vector199:
  pushl $0
8010898b:	6a 00                	push   $0x0
  pushl $199
8010898d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108992:	e9 e1 f2 ff ff       	jmp    80107c78 <alltraps>

80108997 <vector200>:
.globl vector200
vector200:
  pushl $0
80108997:	6a 00                	push   $0x0
  pushl $200
80108999:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010899e:	e9 d5 f2 ff ff       	jmp    80107c78 <alltraps>

801089a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801089a3:	6a 00                	push   $0x0
  pushl $201
801089a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801089aa:	e9 c9 f2 ff ff       	jmp    80107c78 <alltraps>

801089af <vector202>:
.globl vector202
vector202:
  pushl $0
801089af:	6a 00                	push   $0x0
  pushl $202
801089b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801089b6:	e9 bd f2 ff ff       	jmp    80107c78 <alltraps>

801089bb <vector203>:
.globl vector203
vector203:
  pushl $0
801089bb:	6a 00                	push   $0x0
  pushl $203
801089bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801089c2:	e9 b1 f2 ff ff       	jmp    80107c78 <alltraps>

801089c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801089c7:	6a 00                	push   $0x0
  pushl $204
801089c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801089ce:	e9 a5 f2 ff ff       	jmp    80107c78 <alltraps>

801089d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801089d3:	6a 00                	push   $0x0
  pushl $205
801089d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801089da:	e9 99 f2 ff ff       	jmp    80107c78 <alltraps>

801089df <vector206>:
.globl vector206
vector206:
  pushl $0
801089df:	6a 00                	push   $0x0
  pushl $206
801089e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801089e6:	e9 8d f2 ff ff       	jmp    80107c78 <alltraps>

801089eb <vector207>:
.globl vector207
vector207:
  pushl $0
801089eb:	6a 00                	push   $0x0
  pushl $207
801089ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801089f2:	e9 81 f2 ff ff       	jmp    80107c78 <alltraps>

801089f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801089f7:	6a 00                	push   $0x0
  pushl $208
801089f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801089fe:	e9 75 f2 ff ff       	jmp    80107c78 <alltraps>

80108a03 <vector209>:
.globl vector209
vector209:
  pushl $0
80108a03:	6a 00                	push   $0x0
  pushl $209
80108a05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108a0a:	e9 69 f2 ff ff       	jmp    80107c78 <alltraps>

80108a0f <vector210>:
.globl vector210
vector210:
  pushl $0
80108a0f:	6a 00                	push   $0x0
  pushl $210
80108a11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108a16:	e9 5d f2 ff ff       	jmp    80107c78 <alltraps>

80108a1b <vector211>:
.globl vector211
vector211:
  pushl $0
80108a1b:	6a 00                	push   $0x0
  pushl $211
80108a1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108a22:	e9 51 f2 ff ff       	jmp    80107c78 <alltraps>

80108a27 <vector212>:
.globl vector212
vector212:
  pushl $0
80108a27:	6a 00                	push   $0x0
  pushl $212
80108a29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108a2e:	e9 45 f2 ff ff       	jmp    80107c78 <alltraps>

80108a33 <vector213>:
.globl vector213
vector213:
  pushl $0
80108a33:	6a 00                	push   $0x0
  pushl $213
80108a35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108a3a:	e9 39 f2 ff ff       	jmp    80107c78 <alltraps>

80108a3f <vector214>:
.globl vector214
vector214:
  pushl $0
80108a3f:	6a 00                	push   $0x0
  pushl $214
80108a41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108a46:	e9 2d f2 ff ff       	jmp    80107c78 <alltraps>

80108a4b <vector215>:
.globl vector215
vector215:
  pushl $0
80108a4b:	6a 00                	push   $0x0
  pushl $215
80108a4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108a52:	e9 21 f2 ff ff       	jmp    80107c78 <alltraps>

80108a57 <vector216>:
.globl vector216
vector216:
  pushl $0
80108a57:	6a 00                	push   $0x0
  pushl $216
80108a59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108a5e:	e9 15 f2 ff ff       	jmp    80107c78 <alltraps>

80108a63 <vector217>:
.globl vector217
vector217:
  pushl $0
80108a63:	6a 00                	push   $0x0
  pushl $217
80108a65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108a6a:	e9 09 f2 ff ff       	jmp    80107c78 <alltraps>

80108a6f <vector218>:
.globl vector218
vector218:
  pushl $0
80108a6f:	6a 00                	push   $0x0
  pushl $218
80108a71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108a76:	e9 fd f1 ff ff       	jmp    80107c78 <alltraps>

80108a7b <vector219>:
.globl vector219
vector219:
  pushl $0
80108a7b:	6a 00                	push   $0x0
  pushl $219
80108a7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108a82:	e9 f1 f1 ff ff       	jmp    80107c78 <alltraps>

80108a87 <vector220>:
.globl vector220
vector220:
  pushl $0
80108a87:	6a 00                	push   $0x0
  pushl $220
80108a89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108a8e:	e9 e5 f1 ff ff       	jmp    80107c78 <alltraps>

80108a93 <vector221>:
.globl vector221
vector221:
  pushl $0
80108a93:	6a 00                	push   $0x0
  pushl $221
80108a95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108a9a:	e9 d9 f1 ff ff       	jmp    80107c78 <alltraps>

80108a9f <vector222>:
.globl vector222
vector222:
  pushl $0
80108a9f:	6a 00                	push   $0x0
  pushl $222
80108aa1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108aa6:	e9 cd f1 ff ff       	jmp    80107c78 <alltraps>

80108aab <vector223>:
.globl vector223
vector223:
  pushl $0
80108aab:	6a 00                	push   $0x0
  pushl $223
80108aad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108ab2:	e9 c1 f1 ff ff       	jmp    80107c78 <alltraps>

80108ab7 <vector224>:
.globl vector224
vector224:
  pushl $0
80108ab7:	6a 00                	push   $0x0
  pushl $224
80108ab9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108abe:	e9 b5 f1 ff ff       	jmp    80107c78 <alltraps>

80108ac3 <vector225>:
.globl vector225
vector225:
  pushl $0
80108ac3:	6a 00                	push   $0x0
  pushl $225
80108ac5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108aca:	e9 a9 f1 ff ff       	jmp    80107c78 <alltraps>

80108acf <vector226>:
.globl vector226
vector226:
  pushl $0
80108acf:	6a 00                	push   $0x0
  pushl $226
80108ad1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108ad6:	e9 9d f1 ff ff       	jmp    80107c78 <alltraps>

80108adb <vector227>:
.globl vector227
vector227:
  pushl $0
80108adb:	6a 00                	push   $0x0
  pushl $227
80108add:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108ae2:	e9 91 f1 ff ff       	jmp    80107c78 <alltraps>

80108ae7 <vector228>:
.globl vector228
vector228:
  pushl $0
80108ae7:	6a 00                	push   $0x0
  pushl $228
80108ae9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108aee:	e9 85 f1 ff ff       	jmp    80107c78 <alltraps>

80108af3 <vector229>:
.globl vector229
vector229:
  pushl $0
80108af3:	6a 00                	push   $0x0
  pushl $229
80108af5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108afa:	e9 79 f1 ff ff       	jmp    80107c78 <alltraps>

80108aff <vector230>:
.globl vector230
vector230:
  pushl $0
80108aff:	6a 00                	push   $0x0
  pushl $230
80108b01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108b06:	e9 6d f1 ff ff       	jmp    80107c78 <alltraps>

80108b0b <vector231>:
.globl vector231
vector231:
  pushl $0
80108b0b:	6a 00                	push   $0x0
  pushl $231
80108b0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108b12:	e9 61 f1 ff ff       	jmp    80107c78 <alltraps>

80108b17 <vector232>:
.globl vector232
vector232:
  pushl $0
80108b17:	6a 00                	push   $0x0
  pushl $232
80108b19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108b1e:	e9 55 f1 ff ff       	jmp    80107c78 <alltraps>

80108b23 <vector233>:
.globl vector233
vector233:
  pushl $0
80108b23:	6a 00                	push   $0x0
  pushl $233
80108b25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108b2a:	e9 49 f1 ff ff       	jmp    80107c78 <alltraps>

80108b2f <vector234>:
.globl vector234
vector234:
  pushl $0
80108b2f:	6a 00                	push   $0x0
  pushl $234
80108b31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108b36:	e9 3d f1 ff ff       	jmp    80107c78 <alltraps>

80108b3b <vector235>:
.globl vector235
vector235:
  pushl $0
80108b3b:	6a 00                	push   $0x0
  pushl $235
80108b3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108b42:	e9 31 f1 ff ff       	jmp    80107c78 <alltraps>

80108b47 <vector236>:
.globl vector236
vector236:
  pushl $0
80108b47:	6a 00                	push   $0x0
  pushl $236
80108b49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108b4e:	e9 25 f1 ff ff       	jmp    80107c78 <alltraps>

80108b53 <vector237>:
.globl vector237
vector237:
  pushl $0
80108b53:	6a 00                	push   $0x0
  pushl $237
80108b55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108b5a:	e9 19 f1 ff ff       	jmp    80107c78 <alltraps>

80108b5f <vector238>:
.globl vector238
vector238:
  pushl $0
80108b5f:	6a 00                	push   $0x0
  pushl $238
80108b61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108b66:	e9 0d f1 ff ff       	jmp    80107c78 <alltraps>

80108b6b <vector239>:
.globl vector239
vector239:
  pushl $0
80108b6b:	6a 00                	push   $0x0
  pushl $239
80108b6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108b72:	e9 01 f1 ff ff       	jmp    80107c78 <alltraps>

80108b77 <vector240>:
.globl vector240
vector240:
  pushl $0
80108b77:	6a 00                	push   $0x0
  pushl $240
80108b79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108b7e:	e9 f5 f0 ff ff       	jmp    80107c78 <alltraps>

80108b83 <vector241>:
.globl vector241
vector241:
  pushl $0
80108b83:	6a 00                	push   $0x0
  pushl $241
80108b85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108b8a:	e9 e9 f0 ff ff       	jmp    80107c78 <alltraps>

80108b8f <vector242>:
.globl vector242
vector242:
  pushl $0
80108b8f:	6a 00                	push   $0x0
  pushl $242
80108b91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108b96:	e9 dd f0 ff ff       	jmp    80107c78 <alltraps>

80108b9b <vector243>:
.globl vector243
vector243:
  pushl $0
80108b9b:	6a 00                	push   $0x0
  pushl $243
80108b9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108ba2:	e9 d1 f0 ff ff       	jmp    80107c78 <alltraps>

80108ba7 <vector244>:
.globl vector244
vector244:
  pushl $0
80108ba7:	6a 00                	push   $0x0
  pushl $244
80108ba9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108bae:	e9 c5 f0 ff ff       	jmp    80107c78 <alltraps>

80108bb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80108bb3:	6a 00                	push   $0x0
  pushl $245
80108bb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108bba:	e9 b9 f0 ff ff       	jmp    80107c78 <alltraps>

80108bbf <vector246>:
.globl vector246
vector246:
  pushl $0
80108bbf:	6a 00                	push   $0x0
  pushl $246
80108bc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108bc6:	e9 ad f0 ff ff       	jmp    80107c78 <alltraps>

80108bcb <vector247>:
.globl vector247
vector247:
  pushl $0
80108bcb:	6a 00                	push   $0x0
  pushl $247
80108bcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108bd2:	e9 a1 f0 ff ff       	jmp    80107c78 <alltraps>

80108bd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80108bd7:	6a 00                	push   $0x0
  pushl $248
80108bd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108bde:	e9 95 f0 ff ff       	jmp    80107c78 <alltraps>

80108be3 <vector249>:
.globl vector249
vector249:
  pushl $0
80108be3:	6a 00                	push   $0x0
  pushl $249
80108be5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108bea:	e9 89 f0 ff ff       	jmp    80107c78 <alltraps>

80108bef <vector250>:
.globl vector250
vector250:
  pushl $0
80108bef:	6a 00                	push   $0x0
  pushl $250
80108bf1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108bf6:	e9 7d f0 ff ff       	jmp    80107c78 <alltraps>

80108bfb <vector251>:
.globl vector251
vector251:
  pushl $0
80108bfb:	6a 00                	push   $0x0
  pushl $251
80108bfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108c02:	e9 71 f0 ff ff       	jmp    80107c78 <alltraps>

80108c07 <vector252>:
.globl vector252
vector252:
  pushl $0
80108c07:	6a 00                	push   $0x0
  pushl $252
80108c09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108c0e:	e9 65 f0 ff ff       	jmp    80107c78 <alltraps>

80108c13 <vector253>:
.globl vector253
vector253:
  pushl $0
80108c13:	6a 00                	push   $0x0
  pushl $253
80108c15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108c1a:	e9 59 f0 ff ff       	jmp    80107c78 <alltraps>

80108c1f <vector254>:
.globl vector254
vector254:
  pushl $0
80108c1f:	6a 00                	push   $0x0
  pushl $254
80108c21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108c26:	e9 4d f0 ff ff       	jmp    80107c78 <alltraps>

80108c2b <vector255>:
.globl vector255
vector255:
  pushl $0
80108c2b:	6a 00                	push   $0x0
  pushl $255
80108c2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108c32:	e9 41 f0 ff ff       	jmp    80107c78 <alltraps>
80108c37:	66 90                	xchg   %ax,%ax
80108c39:	66 90                	xchg   %ax,%ax
80108c3b:	66 90                	xchg   %ax,%ax
80108c3d:	66 90                	xchg   %ax,%ax
80108c3f:	90                   	nop

80108c40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108c40:	55                   	push   %ebp
80108c41:	89 e5                	mov    %esp,%ebp
80108c43:	57                   	push   %edi
80108c44:	56                   	push   %esi
80108c45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108c46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80108c4c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108c52:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80108c55:	39 d3                	cmp    %edx,%ebx
80108c57:	73 56                	jae    80108caf <deallocuvm.part.0+0x6f>
80108c59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80108c5c:	89 c6                	mov    %eax,%esi
80108c5e:	89 d7                	mov    %edx,%edi
80108c60:	eb 12                	jmp    80108c74 <deallocuvm.part.0+0x34>
80108c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108c68:	83 c2 01             	add    $0x1,%edx
80108c6b:	89 d3                	mov    %edx,%ebx
80108c6d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108c70:	39 fb                	cmp    %edi,%ebx
80108c72:	73 38                	jae    80108cac <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80108c74:	89 da                	mov    %ebx,%edx
80108c76:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108c79:	8b 04 96             	mov    (%esi,%edx,4),%eax
80108c7c:	a8 01                	test   $0x1,%al
80108c7e:	74 e8                	je     80108c68 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80108c80:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108c82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108c87:	c1 e9 0a             	shr    $0xa,%ecx
80108c8a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80108c90:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80108c97:	85 c0                	test   %eax,%eax
80108c99:	74 cd                	je     80108c68 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80108c9b:	8b 10                	mov    (%eax),%edx
80108c9d:	f6 c2 01             	test   $0x1,%dl
80108ca0:	75 1e                	jne    80108cc0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80108ca2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108ca8:	39 fb                	cmp    %edi,%ebx
80108caa:	72 c8                	jb     80108c74 <deallocuvm.part.0+0x34>
80108cac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108cb2:	89 c8                	mov    %ecx,%eax
80108cb4:	5b                   	pop    %ebx
80108cb5:	5e                   	pop    %esi
80108cb6:	5f                   	pop    %edi
80108cb7:	5d                   	pop    %ebp
80108cb8:	c3                   	ret
80108cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80108cc0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108cc6:	74 26                	je     80108cee <deallocuvm.part.0+0xae>
      kfree(v);
80108cc8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80108ccb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108cd4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108cda:	52                   	push   %edx
80108cdb:	e8 60 ad ff ff       	call   80103a40 <kfree>
      *pte = 0;
80108ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80108ce3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108cec:	eb 82                	jmp    80108c70 <deallocuvm.part.0+0x30>
        panic("kfree");
80108cee:	83 ec 0c             	sub    $0xc,%esp
80108cf1:	68 cc 97 10 80       	push   $0x801097cc
80108cf6:	e8 55 78 ff ff       	call   80100550 <panic>
80108cfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108d00 <mappages>:
{
80108d00:	55                   	push   %ebp
80108d01:	89 e5                	mov    %esp,%ebp
80108d03:	57                   	push   %edi
80108d04:	56                   	push   %esi
80108d05:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108d06:	89 d3                	mov    %edx,%ebx
80108d08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80108d0e:	83 ec 1c             	sub    $0x1c,%esp
80108d11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108d14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108d20:	8b 45 08             	mov    0x8(%ebp),%eax
80108d23:	29 d8                	sub    %ebx,%eax
80108d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108d28:	eb 3f                	jmp    80108d69 <mappages+0x69>
80108d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108d30:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108d32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108d37:	c1 ea 0a             	shr    $0xa,%edx
80108d3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108d40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108d47:	85 c0                	test   %eax,%eax
80108d49:	74 75                	je     80108dc0 <mappages+0xc0>
    if(*pte & PTE_P)
80108d4b:	f6 00 01             	testb  $0x1,(%eax)
80108d4e:	0f 85 86 00 00 00    	jne    80108dda <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108d54:	0b 75 0c             	or     0xc(%ebp),%esi
80108d57:	83 ce 01             	or     $0x1,%esi
80108d5a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80108d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d5f:	39 c3                	cmp    %eax,%ebx
80108d61:	74 6d                	je     80108dd0 <mappages+0xd0>
    a += PGSIZE;
80108d63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80108d6c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108d6f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108d72:	89 d8                	mov    %ebx,%eax
80108d74:	c1 e8 16             	shr    $0x16,%eax
80108d77:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108d7a:	8b 07                	mov    (%edi),%eax
80108d7c:	a8 01                	test   $0x1,%al
80108d7e:	75 b0                	jne    80108d30 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108d80:	e8 7b ae ff ff       	call   80103c00 <kalloc>
80108d85:	85 c0                	test   %eax,%eax
80108d87:	74 37                	je     80108dc0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108d89:	83 ec 04             	sub    $0x4,%esp
80108d8c:	68 00 10 00 00       	push   $0x1000
80108d91:	6a 00                	push   $0x0
80108d93:	50                   	push   %eax
80108d94:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108d97:	e8 74 d6 ff ff       	call   80106410 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108d9c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80108d9f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108da2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108da8:	83 c8 07             	or     $0x7,%eax
80108dab:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80108dad:	89 d8                	mov    %ebx,%eax
80108daf:	c1 e8 0a             	shr    $0xa,%eax
80108db2:	25 fc 0f 00 00       	and    $0xffc,%eax
80108db7:	01 d0                	add    %edx,%eax
80108db9:	eb 90                	jmp    80108d4b <mappages+0x4b>
80108dbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80108dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108dc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108dc8:	5b                   	pop    %ebx
80108dc9:	5e                   	pop    %esi
80108dca:	5f                   	pop    %edi
80108dcb:	5d                   	pop    %ebp
80108dcc:	c3                   	ret
80108dcd:	8d 76 00             	lea    0x0(%esi),%esi
80108dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108dd3:	31 c0                	xor    %eax,%eax
}
80108dd5:	5b                   	pop    %ebx
80108dd6:	5e                   	pop    %esi
80108dd7:	5f                   	pop    %edi
80108dd8:	5d                   	pop    %ebp
80108dd9:	c3                   	ret
      panic("remap");
80108dda:	83 ec 0c             	sub    $0xc,%esp
80108ddd:	68 13 9b 10 80       	push   $0x80109b13
80108de2:	e8 69 77 ff ff       	call   80100550 <panic>
80108de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108dee:	00 
80108def:	90                   	nop

80108df0 <seginit>:
{
80108df0:	55                   	push   %ebp
80108df1:	89 e5                	mov    %esp,%ebp
80108df3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108df6:	e8 15 c2 ff ff       	call   80105010 <cpuid>
  pd[0] = size-1;
80108dfb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108e00:	69 c0 b8 00 00 00    	imul   $0xb8,%eax,%eax
80108e06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80108e0a:	c7 80 b8 4a 11 80 ff 	movl   $0xffff,-0x7feeb548(%eax)
80108e11:	ff 00 00 
80108e14:	c7 80 bc 4a 11 80 00 	movl   $0xcf9a00,-0x7feeb544(%eax)
80108e1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108e1e:	c7 80 c0 4a 11 80 ff 	movl   $0xffff,-0x7feeb540(%eax)
80108e25:	ff 00 00 
80108e28:	c7 80 c4 4a 11 80 00 	movl   $0xcf9200,-0x7feeb53c(%eax)
80108e2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108e32:	c7 80 c8 4a 11 80 ff 	movl   $0xffff,-0x7feeb538(%eax)
80108e39:	ff 00 00 
80108e3c:	c7 80 cc 4a 11 80 00 	movl   $0xcffa00,-0x7feeb534(%eax)
80108e43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e46:	c7 80 d0 4a 11 80 ff 	movl   $0xffff,-0x7feeb530(%eax)
80108e4d:	ff 00 00 
80108e50:	c7 80 d4 4a 11 80 00 	movl   $0xcff200,-0x7feeb52c(%eax)
80108e57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80108e5a:	05 b0 4a 11 80       	add    $0x80114ab0,%eax
  pd[1] = (uint)p;
80108e5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108e63:	c1 e8 10             	shr    $0x10,%eax
80108e66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108e6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108e6d:	0f 01 10             	lgdtl  (%eax)
}
80108e70:	c9                   	leave
80108e71:	c3                   	ret
80108e72:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e79:	00 
80108e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108e80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108e80:	a1 24 7e 11 80       	mov    0x80117e24,%eax
80108e85:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108e8a:	0f 22 d8             	mov    %eax,%cr3
}
80108e8d:	c3                   	ret
80108e8e:	66 90                	xchg   %ax,%ax

80108e90 <switchuvm>:
{
80108e90:	55                   	push   %ebp
80108e91:	89 e5                	mov    %esp,%ebp
80108e93:	57                   	push   %edi
80108e94:	56                   	push   %esi
80108e95:	53                   	push   %ebx
80108e96:	83 ec 1c             	sub    $0x1c,%esp
80108e99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80108e9c:	85 f6                	test   %esi,%esi
80108e9e:	0f 84 cb 00 00 00    	je     80108f6f <switchuvm+0xdf>
  if(p->kstack == 0)
80108ea4:	8b 46 08             	mov    0x8(%esi),%eax
80108ea7:	85 c0                	test   %eax,%eax
80108ea9:	0f 84 da 00 00 00    	je     80108f89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80108eaf:	8b 46 04             	mov    0x4(%esi),%eax
80108eb2:	85 c0                	test   %eax,%eax
80108eb4:	0f 84 c2 00 00 00    	je     80108f7c <switchuvm+0xec>
  pushcli();
80108eba:	e8 01 d3 ff ff       	call   801061c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108ebf:	e8 ec c0 ff ff       	call   80104fb0 <mycpu>
80108ec4:	89 c3                	mov    %eax,%ebx
80108ec6:	e8 e5 c0 ff ff       	call   80104fb0 <mycpu>
80108ecb:	89 c7                	mov    %eax,%edi
80108ecd:	e8 de c0 ff ff       	call   80104fb0 <mycpu>
80108ed2:	83 c7 08             	add    $0x8,%edi
80108ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108ed8:	e8 d3 c0 ff ff       	call   80104fb0 <mycpu>
80108edd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108ee0:	ba 67 00 00 00       	mov    $0x67,%edx
80108ee5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108eec:	83 c0 08             	add    $0x8,%eax
80108eef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108ef6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108efb:	83 c1 08             	add    $0x8,%ecx
80108efe:	c1 e8 18             	shr    $0x18,%eax
80108f01:	c1 e9 10             	shr    $0x10,%ecx
80108f04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80108f0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108f10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108f15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108f1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108f21:	e8 8a c0 ff ff       	call   80104fb0 <mycpu>
80108f26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108f2d:	e8 7e c0 ff ff       	call   80104fb0 <mycpu>
80108f32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108f36:	8b 5e 08             	mov    0x8(%esi),%ebx
80108f39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108f3f:	e8 6c c0 ff ff       	call   80104fb0 <mycpu>
80108f44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108f47:	e8 64 c0 ff ff       	call   80104fb0 <mycpu>
80108f4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108f50:	b8 28 00 00 00       	mov    $0x28,%eax
80108f55:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108f58:	8b 46 04             	mov    0x4(%esi),%eax
80108f5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108f60:	0f 22 d8             	mov    %eax,%cr3
}
80108f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108f66:	5b                   	pop    %ebx
80108f67:	5e                   	pop    %esi
80108f68:	5f                   	pop    %edi
80108f69:	5d                   	pop    %ebp
  popcli();
80108f6a:	e9 a1 d2 ff ff       	jmp    80106210 <popcli>
    panic("switchuvm: no process");
80108f6f:	83 ec 0c             	sub    $0xc,%esp
80108f72:	68 19 9b 10 80       	push   $0x80109b19
80108f77:	e8 d4 75 ff ff       	call   80100550 <panic>
    panic("switchuvm: no pgdir");
80108f7c:	83 ec 0c             	sub    $0xc,%esp
80108f7f:	68 44 9b 10 80       	push   $0x80109b44
80108f84:	e8 c7 75 ff ff       	call   80100550 <panic>
    panic("switchuvm: no kstack");
80108f89:	83 ec 0c             	sub    $0xc,%esp
80108f8c:	68 2f 9b 10 80       	push   $0x80109b2f
80108f91:	e8 ba 75 ff ff       	call   80100550 <panic>
80108f96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108f9d:	00 
80108f9e:	66 90                	xchg   %ax,%ax

80108fa0 <inituvm>:
{
80108fa0:	55                   	push   %ebp
80108fa1:	89 e5                	mov    %esp,%ebp
80108fa3:	57                   	push   %edi
80108fa4:	56                   	push   %esi
80108fa5:	53                   	push   %ebx
80108fa6:	83 ec 1c             	sub    $0x1c,%esp
80108fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80108fac:	8b 75 10             	mov    0x10(%ebp),%esi
80108faf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108fb5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108fbb:	77 49                	ja     80109006 <inituvm+0x66>
  mem = kalloc();
80108fbd:	e8 3e ac ff ff       	call   80103c00 <kalloc>
  memset(mem, 0, PGSIZE);
80108fc2:	83 ec 04             	sub    $0x4,%esp
80108fc5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80108fca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108fcc:	6a 00                	push   $0x0
80108fce:	50                   	push   %eax
80108fcf:	e8 3c d4 ff ff       	call   80106410 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108fd4:	58                   	pop    %eax
80108fd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108fdb:	5a                   	pop    %edx
80108fdc:	6a 06                	push   $0x6
80108fde:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108fe3:	31 d2                	xor    %edx,%edx
80108fe5:	50                   	push   %eax
80108fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108fe9:	e8 12 fd ff ff       	call   80108d00 <mappages>
  memmove(mem, init, sz);
80108fee:	83 c4 10             	add    $0x10,%esp
80108ff1:	89 75 10             	mov    %esi,0x10(%ebp)
80108ff4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108ff7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80108ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ffd:	5b                   	pop    %ebx
80108ffe:	5e                   	pop    %esi
80108fff:	5f                   	pop    %edi
80109000:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80109001:	e9 9a d4 ff ff       	jmp    801064a0 <memmove>
    panic("inituvm: more than a page");
80109006:	83 ec 0c             	sub    $0xc,%esp
80109009:	68 58 9b 10 80       	push   $0x80109b58
8010900e:	e8 3d 75 ff ff       	call   80100550 <panic>
80109013:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010901a:	00 
8010901b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80109020 <loaduvm>:
{
80109020:	55                   	push   %ebp
80109021:	89 e5                	mov    %esp,%ebp
80109023:	57                   	push   %edi
80109024:	56                   	push   %esi
80109025:	53                   	push   %ebx
80109026:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80109029:	8b 75 0c             	mov    0xc(%ebp),%esi
{
8010902c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
8010902f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80109035:	0f 85 a2 00 00 00    	jne    801090dd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
8010903b:	85 ff                	test   %edi,%edi
8010903d:	74 7d                	je     801090bc <loaduvm+0x9c>
8010903f:	90                   	nop
  pde = &pgdir[PDX(va)];
80109040:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109043:	8b 55 08             	mov    0x8(%ebp),%edx
80109046:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80109048:	89 c1                	mov    %eax,%ecx
8010904a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010904d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80109050:	f6 c1 01             	test   $0x1,%cl
80109053:	75 13                	jne    80109068 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80109055:	83 ec 0c             	sub    $0xc,%esp
80109058:	68 72 9b 10 80       	push   $0x80109b72
8010905d:	e8 ee 74 ff ff       	call   80100550 <panic>
80109062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80109068:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010906b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80109071:	25 fc 0f 00 00       	and    $0xffc,%eax
80109076:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010907d:	85 c9                	test   %ecx,%ecx
8010907f:	74 d4                	je     80109055 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80109081:	89 fb                	mov    %edi,%ebx
80109083:	b8 00 10 00 00       	mov    $0x1000,%eax
80109088:	29 f3                	sub    %esi,%ebx
8010908a:	39 c3                	cmp    %eax,%ebx
8010908c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010908f:	53                   	push   %ebx
80109090:	8b 45 14             	mov    0x14(%ebp),%eax
80109093:	01 f0                	add    %esi,%eax
80109095:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80109096:	8b 01                	mov    (%ecx),%eax
80109098:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010909d:	05 00 00 00 80       	add    $0x80000000,%eax
801090a2:	50                   	push   %eax
801090a3:	ff 75 10             	push   0x10(%ebp)
801090a6:	e8 a5 9f ff ff       	call   80103050 <readi>
801090ab:	83 c4 10             	add    $0x10,%esp
801090ae:	39 d8                	cmp    %ebx,%eax
801090b0:	75 1e                	jne    801090d0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
801090b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
801090b8:	39 fe                	cmp    %edi,%esi
801090ba:	72 84                	jb     80109040 <loaduvm+0x20>
}
801090bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801090bf:	31 c0                	xor    %eax,%eax
}
801090c1:	5b                   	pop    %ebx
801090c2:	5e                   	pop    %esi
801090c3:	5f                   	pop    %edi
801090c4:	5d                   	pop    %ebp
801090c5:	c3                   	ret
801090c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801090cd:	00 
801090ce:	66 90                	xchg   %ax,%ax
801090d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801090d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801090d8:	5b                   	pop    %ebx
801090d9:	5e                   	pop    %esi
801090da:	5f                   	pop    %edi
801090db:	5d                   	pop    %ebp
801090dc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
801090dd:	83 ec 0c             	sub    $0xc,%esp
801090e0:	68 34 9e 10 80       	push   $0x80109e34
801090e5:	e8 66 74 ff ff       	call   80100550 <panic>
801090ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801090f0 <allocuvm>:
{
801090f0:	55                   	push   %ebp
801090f1:	89 e5                	mov    %esp,%ebp
801090f3:	57                   	push   %edi
801090f4:	56                   	push   %esi
801090f5:	53                   	push   %ebx
801090f6:	83 ec 1c             	sub    $0x1c,%esp
801090f9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
801090fc:	85 f6                	test   %esi,%esi
801090fe:	0f 88 98 00 00 00    	js     8010919c <allocuvm+0xac>
80109104:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80109106:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109109:	0f 82 a1 00 00 00    	jb     801091b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010910f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109112:	05 ff 0f 00 00       	add    $0xfff,%eax
80109117:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010911c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010911e:	39 f0                	cmp    %esi,%eax
80109120:	0f 83 8d 00 00 00    	jae    801091b3 <allocuvm+0xc3>
80109126:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80109129:	eb 44                	jmp    8010916f <allocuvm+0x7f>
8010912b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80109130:	83 ec 04             	sub    $0x4,%esp
80109133:	68 00 10 00 00       	push   $0x1000
80109138:	6a 00                	push   $0x0
8010913a:	50                   	push   %eax
8010913b:	e8 d0 d2 ff ff       	call   80106410 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80109140:	58                   	pop    %eax
80109141:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80109147:	5a                   	pop    %edx
80109148:	6a 06                	push   $0x6
8010914a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010914f:	89 fa                	mov    %edi,%edx
80109151:	50                   	push   %eax
80109152:	8b 45 08             	mov    0x8(%ebp),%eax
80109155:	e8 a6 fb ff ff       	call   80108d00 <mappages>
8010915a:	83 c4 10             	add    $0x10,%esp
8010915d:	85 c0                	test   %eax,%eax
8010915f:	78 5f                	js     801091c0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80109161:	81 c7 00 10 00 00    	add    $0x1000,%edi
80109167:	39 f7                	cmp    %esi,%edi
80109169:	0f 83 89 00 00 00    	jae    801091f8 <allocuvm+0x108>
    mem = kalloc();
8010916f:	e8 8c aa ff ff       	call   80103c00 <kalloc>
80109174:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80109176:	85 c0                	test   %eax,%eax
80109178:	75 b6                	jne    80109130 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010917a:	83 ec 0c             	sub    $0xc,%esp
8010917d:	68 90 9b 10 80       	push   $0x80109b90
80109182:	e8 d9 7b ff ff       	call   80100d60 <cprintf>
  if(newsz >= oldsz)
80109187:	83 c4 10             	add    $0x10,%esp
8010918a:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010918d:	74 0d                	je     8010919c <allocuvm+0xac>
8010918f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109192:	8b 45 08             	mov    0x8(%ebp),%eax
80109195:	89 f2                	mov    %esi,%edx
80109197:	e8 a4 fa ff ff       	call   80108c40 <deallocuvm.part.0>
    return 0;
8010919c:	31 d2                	xor    %edx,%edx
}
8010919e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801091a1:	89 d0                	mov    %edx,%eax
801091a3:	5b                   	pop    %ebx
801091a4:	5e                   	pop    %esi
801091a5:	5f                   	pop    %edi
801091a6:	5d                   	pop    %ebp
801091a7:	c3                   	ret
801091a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801091af:	00 
    return oldsz;
801091b0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801091b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801091b6:	89 d0                	mov    %edx,%eax
801091b8:	5b                   	pop    %ebx
801091b9:	5e                   	pop    %esi
801091ba:	5f                   	pop    %edi
801091bb:	5d                   	pop    %ebp
801091bc:	c3                   	ret
801091bd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801091c0:	83 ec 0c             	sub    $0xc,%esp
801091c3:	68 a8 9b 10 80       	push   $0x80109ba8
801091c8:	e8 93 7b ff ff       	call   80100d60 <cprintf>
  if(newsz >= oldsz)
801091cd:	83 c4 10             	add    $0x10,%esp
801091d0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801091d3:	74 0d                	je     801091e2 <allocuvm+0xf2>
801091d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801091d8:	8b 45 08             	mov    0x8(%ebp),%eax
801091db:	89 f2                	mov    %esi,%edx
801091dd:	e8 5e fa ff ff       	call   80108c40 <deallocuvm.part.0>
      kfree(mem);
801091e2:	83 ec 0c             	sub    $0xc,%esp
801091e5:	53                   	push   %ebx
801091e6:	e8 55 a8 ff ff       	call   80103a40 <kfree>
      return 0;
801091eb:	83 c4 10             	add    $0x10,%esp
    return 0;
801091ee:	31 d2                	xor    %edx,%edx
801091f0:	eb ac                	jmp    8010919e <allocuvm+0xae>
801091f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801091f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
801091fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801091fe:	5b                   	pop    %ebx
801091ff:	5e                   	pop    %esi
80109200:	89 d0                	mov    %edx,%eax
80109202:	5f                   	pop    %edi
80109203:	5d                   	pop    %ebp
80109204:	c3                   	ret
80109205:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010920c:	00 
8010920d:	8d 76 00             	lea    0x0(%esi),%esi

80109210 <deallocuvm>:
{
80109210:	55                   	push   %ebp
80109211:	89 e5                	mov    %esp,%ebp
80109213:	8b 55 0c             	mov    0xc(%ebp),%edx
80109216:	8b 4d 10             	mov    0x10(%ebp),%ecx
80109219:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010921c:	39 d1                	cmp    %edx,%ecx
8010921e:	73 10                	jae    80109230 <deallocuvm+0x20>
}
80109220:	5d                   	pop    %ebp
80109221:	e9 1a fa ff ff       	jmp    80108c40 <deallocuvm.part.0>
80109226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010922d:	00 
8010922e:	66 90                	xchg   %ax,%ax
80109230:	89 d0                	mov    %edx,%eax
80109232:	5d                   	pop    %ebp
80109233:	c3                   	ret
80109234:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010923b:	00 
8010923c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80109240 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109240:	55                   	push   %ebp
80109241:	89 e5                	mov    %esp,%ebp
80109243:	57                   	push   %edi
80109244:	56                   	push   %esi
80109245:	53                   	push   %ebx
80109246:	83 ec 0c             	sub    $0xc,%esp
80109249:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010924c:	85 f6                	test   %esi,%esi
8010924e:	74 59                	je     801092a9 <freevm+0x69>
  if(newsz >= oldsz)
80109250:	31 c9                	xor    %ecx,%ecx
80109252:	ba 00 00 00 80       	mov    $0x80000000,%edx
80109257:	89 f0                	mov    %esi,%eax
80109259:	89 f3                	mov    %esi,%ebx
8010925b:	e8 e0 f9 ff ff       	call   80108c40 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109260:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80109266:	eb 0f                	jmp    80109277 <freevm+0x37>
80109268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010926f:	00 
80109270:	83 c3 04             	add    $0x4,%ebx
80109273:	39 fb                	cmp    %edi,%ebx
80109275:	74 23                	je     8010929a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80109277:	8b 03                	mov    (%ebx),%eax
80109279:	a8 01                	test   $0x1,%al
8010927b:	74 f3                	je     80109270 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010927d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80109282:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109285:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80109288:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010928d:	50                   	push   %eax
8010928e:	e8 ad a7 ff ff       	call   80103a40 <kfree>
80109293:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109296:	39 fb                	cmp    %edi,%ebx
80109298:	75 dd                	jne    80109277 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010929a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010929d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801092a0:	5b                   	pop    %ebx
801092a1:	5e                   	pop    %esi
801092a2:	5f                   	pop    %edi
801092a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801092a4:	e9 97 a7 ff ff       	jmp    80103a40 <kfree>
    panic("freevm: no pgdir");
801092a9:	83 ec 0c             	sub    $0xc,%esp
801092ac:	68 c4 9b 10 80       	push   $0x80109bc4
801092b1:	e8 9a 72 ff ff       	call   80100550 <panic>
801092b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801092bd:	00 
801092be:	66 90                	xchg   %ax,%ax

801092c0 <setupkvm>:
{
801092c0:	55                   	push   %ebp
801092c1:	89 e5                	mov    %esp,%ebp
801092c3:	56                   	push   %esi
801092c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801092c5:	e8 36 a9 ff ff       	call   80103c00 <kalloc>
801092ca:	85 c0                	test   %eax,%eax
801092cc:	74 5e                	je     8010932c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801092ce:	83 ec 04             	sub    $0x4,%esp
801092d1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801092d3:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
801092d8:	68 00 10 00 00       	push   $0x1000
801092dd:	6a 00                	push   $0x0
801092df:	50                   	push   %eax
801092e0:	e8 2b d1 ff ff       	call   80106410 <memset>
801092e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801092e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801092eb:	83 ec 08             	sub    $0x8,%esp
801092ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801092f1:	8b 13                	mov    (%ebx),%edx
801092f3:	ff 73 0c             	push   0xc(%ebx)
801092f6:	50                   	push   %eax
801092f7:	29 c1                	sub    %eax,%ecx
801092f9:	89 f0                	mov    %esi,%eax
801092fb:	e8 00 fa ff ff       	call   80108d00 <mappages>
80109300:	83 c4 10             	add    $0x10,%esp
80109303:	85 c0                	test   %eax,%eax
80109305:	78 19                	js     80109320 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109307:	83 c3 10             	add    $0x10,%ebx
8010930a:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
80109310:	75 d6                	jne    801092e8 <setupkvm+0x28>
}
80109312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109315:	89 f0                	mov    %esi,%eax
80109317:	5b                   	pop    %ebx
80109318:	5e                   	pop    %esi
80109319:	5d                   	pop    %ebp
8010931a:	c3                   	ret
8010931b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80109320:	83 ec 0c             	sub    $0xc,%esp
80109323:	56                   	push   %esi
80109324:	e8 17 ff ff ff       	call   80109240 <freevm>
      return 0;
80109329:	83 c4 10             	add    $0x10,%esp
}
8010932c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010932f:	31 f6                	xor    %esi,%esi
}
80109331:	89 f0                	mov    %esi,%eax
80109333:	5b                   	pop    %ebx
80109334:	5e                   	pop    %esi
80109335:	5d                   	pop    %ebp
80109336:	c3                   	ret
80109337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010933e:	00 
8010933f:	90                   	nop

80109340 <kvmalloc>:
{
80109340:	55                   	push   %ebp
80109341:	89 e5                	mov    %esp,%ebp
80109343:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109346:	e8 75 ff ff ff       	call   801092c0 <setupkvm>
8010934b:	a3 24 7e 11 80       	mov    %eax,0x80117e24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80109350:	05 00 00 00 80       	add    $0x80000000,%eax
80109355:	0f 22 d8             	mov    %eax,%cr3
}
80109358:	c9                   	leave
80109359:	c3                   	ret
8010935a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109360 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109360:	55                   	push   %ebp
80109361:	89 e5                	mov    %esp,%ebp
80109363:	83 ec 08             	sub    $0x8,%esp
80109366:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109369:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010936c:	89 c1                	mov    %eax,%ecx
8010936e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80109371:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80109374:	f6 c2 01             	test   $0x1,%dl
80109377:	75 17                	jne    80109390 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80109379:	83 ec 0c             	sub    $0xc,%esp
8010937c:	68 d5 9b 10 80       	push   $0x80109bd5
80109381:	e8 ca 71 ff ff       	call   80100550 <panic>
80109386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010938d:	00 
8010938e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80109390:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109393:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80109399:	25 fc 0f 00 00       	and    $0xffc,%eax
8010939e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801093a5:	85 c0                	test   %eax,%eax
801093a7:	74 d0                	je     80109379 <clearpteu+0x19>
  *pte &= ~PTE_U;
801093a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801093ac:	c9                   	leave
801093ad:	c3                   	ret
801093ae:	66 90                	xchg   %ax,%ax

801093b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801093b0:	55                   	push   %ebp
801093b1:	89 e5                	mov    %esp,%ebp
801093b3:	57                   	push   %edi
801093b4:	56                   	push   %esi
801093b5:	53                   	push   %ebx
801093b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801093b9:	e8 02 ff ff ff       	call   801092c0 <setupkvm>
801093be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801093c1:	85 c0                	test   %eax,%eax
801093c3:	0f 84 e9 00 00 00    	je     801094b2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801093c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801093cc:	85 c9                	test   %ecx,%ecx
801093ce:	0f 84 b2 00 00 00    	je     80109486 <copyuvm+0xd6>
801093d4:	31 f6                	xor    %esi,%esi
801093d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801093dd:	00 
801093de:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801093e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801093e3:	89 f0                	mov    %esi,%eax
801093e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801093e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801093eb:	a8 01                	test   $0x1,%al
801093ed:	75 11                	jne    80109400 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801093ef:	83 ec 0c             	sub    $0xc,%esp
801093f2:	68 df 9b 10 80       	push   $0x80109bdf
801093f7:	e8 54 71 ff ff       	call   80100550 <panic>
801093fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80109400:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109407:	c1 ea 0a             	shr    $0xa,%edx
8010940a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80109410:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109417:	85 c0                	test   %eax,%eax
80109419:	74 d4                	je     801093ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010941b:	8b 00                	mov    (%eax),%eax
8010941d:	a8 01                	test   $0x1,%al
8010941f:	0f 84 9f 00 00 00    	je     801094c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80109425:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80109427:	25 ff 0f 00 00       	and    $0xfff,%eax
8010942c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010942f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80109435:	e8 c6 a7 ff ff       	call   80103c00 <kalloc>
8010943a:	89 c3                	mov    %eax,%ebx
8010943c:	85 c0                	test   %eax,%eax
8010943e:	74 64                	je     801094a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80109440:	83 ec 04             	sub    $0x4,%esp
80109443:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80109449:	68 00 10 00 00       	push   $0x1000
8010944e:	57                   	push   %edi
8010944f:	50                   	push   %eax
80109450:	e8 4b d0 ff ff       	call   801064a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80109455:	58                   	pop    %eax
80109456:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010945c:	5a                   	pop    %edx
8010945d:	ff 75 e4             	push   -0x1c(%ebp)
80109460:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109465:	89 f2                	mov    %esi,%edx
80109467:	50                   	push   %eax
80109468:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010946b:	e8 90 f8 ff ff       	call   80108d00 <mappages>
80109470:	83 c4 10             	add    $0x10,%esp
80109473:	85 c0                	test   %eax,%eax
80109475:	78 21                	js     80109498 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80109477:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010947d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109480:	0f 82 5a ff ff ff    	jb     801093e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80109486:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109489:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010948c:	5b                   	pop    %ebx
8010948d:	5e                   	pop    %esi
8010948e:	5f                   	pop    %edi
8010948f:	5d                   	pop    %ebp
80109490:	c3                   	ret
80109491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80109498:	83 ec 0c             	sub    $0xc,%esp
8010949b:	53                   	push   %ebx
8010949c:	e8 9f a5 ff ff       	call   80103a40 <kfree>
      goto bad;
801094a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801094a4:	83 ec 0c             	sub    $0xc,%esp
801094a7:	ff 75 e0             	push   -0x20(%ebp)
801094aa:	e8 91 fd ff ff       	call   80109240 <freevm>
  return 0;
801094af:	83 c4 10             	add    $0x10,%esp
    return 0;
801094b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801094b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801094bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801094bf:	5b                   	pop    %ebx
801094c0:	5e                   	pop    %esi
801094c1:	5f                   	pop    %edi
801094c2:	5d                   	pop    %ebp
801094c3:	c3                   	ret
      panic("copyuvm: page not present");
801094c4:	83 ec 0c             	sub    $0xc,%esp
801094c7:	68 f9 9b 10 80       	push   $0x80109bf9
801094cc:	e8 7f 70 ff ff       	call   80100550 <panic>
801094d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801094d8:	00 
801094d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801094e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801094e0:	55                   	push   %ebp
801094e1:	89 e5                	mov    %esp,%ebp
801094e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801094e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801094e9:	89 c1                	mov    %eax,%ecx
801094eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801094ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801094f1:	f6 c2 01             	test   $0x1,%dl
801094f4:	0f 84 f8 00 00 00    	je     801095f2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801094fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801094fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80109503:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80109504:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80109509:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80109510:	89 d0                	mov    %edx,%eax
80109512:	f7 d2                	not    %edx
80109514:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109519:	05 00 00 00 80       	add    $0x80000000,%eax
8010951e:	83 e2 05             	and    $0x5,%edx
80109521:	ba 00 00 00 00       	mov    $0x0,%edx
80109526:	0f 45 c2             	cmovne %edx,%eax
}
80109529:	c3                   	ret
8010952a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109530 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109530:	55                   	push   %ebp
80109531:	89 e5                	mov    %esp,%ebp
80109533:	57                   	push   %edi
80109534:	56                   	push   %esi
80109535:	53                   	push   %ebx
80109536:	83 ec 0c             	sub    $0xc,%esp
80109539:	8b 75 14             	mov    0x14(%ebp),%esi
8010953c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010953f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109542:	85 f6                	test   %esi,%esi
80109544:	75 51                	jne    80109597 <copyout+0x67>
80109546:	e9 9d 00 00 00       	jmp    801095e8 <copyout+0xb8>
8010954b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80109550:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80109556:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010955c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80109562:	74 74                	je     801095d8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80109564:	89 fb                	mov    %edi,%ebx
80109566:	29 c3                	sub    %eax,%ebx
80109568:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010956e:	39 f3                	cmp    %esi,%ebx
80109570:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80109573:	29 f8                	sub    %edi,%eax
80109575:	83 ec 04             	sub    $0x4,%esp
80109578:	01 c1                	add    %eax,%ecx
8010957a:	53                   	push   %ebx
8010957b:	52                   	push   %edx
8010957c:	89 55 10             	mov    %edx,0x10(%ebp)
8010957f:	51                   	push   %ecx
80109580:	e8 1b cf ff ff       	call   801064a0 <memmove>
    len -= n;
    buf += n;
80109585:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80109588:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010958e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80109591:	01 da                	add    %ebx,%edx
  while(len > 0){
80109593:	29 de                	sub    %ebx,%esi
80109595:	74 51                	je     801095e8 <copyout+0xb8>
  if(*pde & PTE_P){
80109597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010959a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010959c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010959e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801095a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801095a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801095aa:	f6 c1 01             	test   $0x1,%cl
801095ad:	0f 84 46 00 00 00    	je     801095f9 <copyout.cold>
  return &pgtab[PTX(va)];
801095b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801095b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801095bb:	c1 eb 0c             	shr    $0xc,%ebx
801095be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801095c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801095cb:	89 d9                	mov    %ebx,%ecx
801095cd:	f7 d1                	not    %ecx
801095cf:	83 e1 05             	and    $0x5,%ecx
801095d2:	0f 84 78 ff ff ff    	je     80109550 <copyout+0x20>
  }
  return 0;
}
801095d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801095db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801095e0:	5b                   	pop    %ebx
801095e1:	5e                   	pop    %esi
801095e2:	5f                   	pop    %edi
801095e3:	5d                   	pop    %ebp
801095e4:	c3                   	ret
801095e5:	8d 76 00             	lea    0x0(%esi),%esi
801095e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801095eb:	31 c0                	xor    %eax,%eax
}
801095ed:	5b                   	pop    %ebx
801095ee:	5e                   	pop    %esi
801095ef:	5f                   	pop    %edi
801095f0:	5d                   	pop    %ebp
801095f1:	c3                   	ret

801095f2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801095f2:	a1 00 00 00 00       	mov    0x0,%eax
801095f7:	0f 0b                	ud2

801095f9 <copyout.cold>:
801095f9:	a1 00 00 00 00       	mov    0x0,%eax
801095fe:	0f 0b                	ud2
