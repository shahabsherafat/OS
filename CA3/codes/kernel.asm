
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
80100028:	bc 70 8d 11 80       	mov    $0x80118d70,%esp

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
8010004c:	68 40 95 10 80       	push   $0x80109540
80100051:	68 20 d5 10 80       	push   $0x8010d520
80100056:	e8 15 60 00 00       	call   80106070 <initlock>
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
80100092:	68 47 95 10 80       	push   $0x80109547
80100097:	50                   	push   %eax
80100098:	e8 a3 5e 00 00       	call   80105f40 <initsleeplock>
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
801000e4:	e8 77 61 00 00       	call   80106260 <acquire>
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
80100162:	e8 99 60 00 00       	call   80106200 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 5e 00 00       	call   80105f80 <acquiresleep>
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
801001a1:	68 4e 95 10 80       	push   $0x8010954e
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
801001be:	e8 5d 5e 00 00       	call   80106020 <holdingsleep>
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
801001dc:	68 5f 95 10 80       	push   $0x8010955f
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
801001ff:	e8 1c 5e 00 00       	call   80106020 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 5d 00 00       	call   80105fe0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010021b:	e8 40 60 00 00       	call   80106260 <acquire>
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
80100269:	e9 92 5f 00 00       	jmp    80106200 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 95 10 80       	push   $0x80109566
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
801003ac:	e8 af 5e 00 00       	call   80106260 <acquire>

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
801003dd:	e8 4e 54 00 00       	call   80105830 <sleep>
    while (input.r == input.w)
801003e2:	a1 00 1f 11 80       	mov    0x80111f00,%eax
801003e7:	83 c4 10             	add    $0x10,%esp
801003ea:	3b 05 04 1f 11 80    	cmp    0x80111f04,%eax
801003f0:	75 36                	jne    80100428 <consoleread+0x98>
      if (myproc()->killed)
801003f2:	e8 b9 4c 00 00       	call   801050b0 <myproc>
801003f7:	8b 40 24             	mov    0x24(%eax),%eax
801003fa:	85 c0                	test   %eax,%eax
801003fc:	74 d2                	je     801003d0 <consoleread+0x40>
        release(&cons.lock);
801003fe:	83 ec 0c             	sub    $0xc,%esp
80100401:	68 c0 21 11 80       	push   $0x801121c0
80100406:	e8 f5 5d 00 00       	call   80106200 <release>
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
80100473:	e8 88 5d 00 00       	call   80106200 <release>
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
80100572:	68 6d 95 10 80       	push   $0x8010956d
80100577:	e8 e4 07 00 00       	call   80100d60 <cprintf>
  cprintf(s);
8010057c:	58                   	pop    %eax
8010057d:	ff 75 08             	push   0x8(%ebp)
80100580:	e8 db 07 00 00       	call   80100d60 <cprintf>
  cprintf("\n");
80100585:	c7 04 24 88 9a 10 80 	movl   $0x80109a88,(%esp)
8010058c:	e8 cf 07 00 00       	call   80100d60 <cprintf>
  getcallerpcs(&s, pcs);
80100591:	8d 45 08             	lea    0x8(%ebp),%eax
80100594:	5a                   	pop    %edx
80100595:	59                   	pop    %ecx
80100596:	53                   	push   %ebx
80100597:	50                   	push   %eax
80100598:	e8 f3 5a 00 00       	call   80106090 <getcallerpcs>
  for (i = 0; i < 10; i++)
8010059d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801005a0:	83 ec 08             	sub    $0x8,%esp
801005a3:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
801005a5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801005a8:	68 81 95 10 80       	push   $0x80109581
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
80100605:	e8 76 7a 00 00       	call   80108080 <uartputc>
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
801006a9:	e8 d2 79 00 00       	call   80108080 <uartputc>
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
801006ee:	68 85 95 10 80       	push   $0x80109585
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
8010071a:	e8 d1 5c 00 00       	call   801063f0 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010071f:	b8 80 07 00 00       	mov    $0x780,%eax
80100724:	83 c4 0c             	add    $0xc,%esp
80100727:	29 d8                	sub    %ebx,%eax
80100729:	01 c0                	add    %eax,%eax
8010072b:	50                   	push   %eax
8010072c:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100733:	6a 00                	push   $0x0
80100735:	50                   	push   %eax
80100736:	e8 25 5c 00 00       	call   80106360 <memset>
  outb(CRTPORT + 1, pos);
8010073b:	83 c4 10             	add    $0x10,%esp
8010073e:	e9 27 ff ff ff       	jmp    8010066a <consputc.part.0+0x9a>
80100743:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80100748:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010074b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100750:	6a 08                	push   $0x8
80100752:	e8 29 79 00 00       	call   80108080 <uartputc>
    uartputc(' ');
80100757:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010075e:	e8 1d 79 00 00       	call   80108080 <uartputc>
    uartputc('\b');
80100763:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010076a:	e8 11 79 00 00       	call   80108080 <uartputc>
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
801007fa:	e8 81 78 00 00       	call   80108080 <uartputc>
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
8010086b:	0f b6 92 48 9b 10 80 	movzbl -0x7fef64b8(%edx),%edx
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
80100beb:	e8 70 56 00 00       	call   80106260 <acquire>

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
80100c76:	e8 85 55 00 00       	call   80106200 <release>
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
80100e88:	e8 d3 53 00 00       	call   80106260 <acquire>
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
80100eab:	e8 50 53 00 00       	call   80106200 <release>
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
80100ee8:	bf 98 95 10 80       	mov    $0x80109598,%edi
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
80100f65:	68 9f 95 10 80       	push   $0x8010959f
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
80100f81:	e8 da 52 00 00       	call   80106260 <acquire>
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
80100fa8:	ff 24 85 dc 9a 10 80 	jmp    *-0x7fef6524(,%eax,4)
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
801014c2:	e8 c9 45 00 00       	call   80105a90 <wakeup>
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
80101508:	e8 f3 4c 00 00       	call   80106200 <release>
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
80101858:	e9 e3 42 00 00       	jmp    80105b40 <procdump>
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
80101c0d:	e8 7e 3e 00 00       	call   80105a90 <wakeup>
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
80101ead:	e8 de 3b 00 00       	call   80105a90 <wakeup>
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
80101fe0:	68 a8 95 10 80       	push   $0x801095a8
80101fe5:	68 c0 21 11 80       	push   $0x801121c0
80101fea:	e8 81 40 00 00       	call   80106070 <initlock>
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
8010205c:	e8 4f 30 00 00       	call   801050b0 <myproc>
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
801020ba:	e8 31 71 00 00       	call   801091f0 <setupkvm>
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
8010212b:	e8 f0 6e 00 00       	call   80109020 <allocuvm>
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
80102161:	e8 ea 6d 00 00       	call   80108f50 <loaduvm>
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
801021a3:	e8 c8 6f 00 00       	call   80109170 <freevm>
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
80102202:	e8 19 6e 00 00       	call   80109020 <allocuvm>
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
80102223:	e8 68 70 00 00       	call   80109290 <clearpteu>
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
8010226a:	e8 e1 42 00 00       	call   80106550 <strlen>
8010226f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102271:	58                   	pop    %eax
80102272:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102275:	83 eb 01             	sub    $0x1,%ebx
80102278:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010227b:	e8 d0 42 00 00       	call   80106550 <strlen>
80102280:	83 c0 01             	add    $0x1,%eax
80102283:	50                   	push   %eax
80102284:	ff 34 b7             	push   (%edi,%esi,4)
80102287:	53                   	push   %ebx
80102288:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
8010228e:	e8 cd 71 00 00       	call   80109460 <copyout>
80102293:	83 c4 20             	add    $0x20,%esp
80102296:	85 c0                	test   %eax,%eax
80102298:	79 ae                	jns    80102248 <exec+0x1f8>
    freevm(pgdir);
8010229a:	83 ec 0c             	sub    $0xc,%esp
8010229d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801022a3:	e8 c8 6e 00 00       	call   80109170 <freevm>
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
801022ff:	e8 5c 71 00 00       	call   80109460 <copyout>
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
8010233f:	e8 cc 41 00 00       	call   80106510 <safestrcpy>
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
8010236b:	e8 50 6a 00 00       	call   80108dc0 <switchuvm>
  freevm(oldpgdir);
80102370:	89 34 24             	mov    %esi,(%esp)
80102373:	e8 f8 6d 00 00       	call   80109170 <freevm>
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
801023ba:	68 b0 95 10 80       	push   $0x801095b0
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
801023d6:	68 bc 95 10 80       	push   $0x801095bc
801023db:	68 00 22 11 80       	push   $0x80112200
801023e0:	e8 8b 3c 00 00       	call   80106070 <initlock>
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
80102401:	e8 5a 3e 00 00       	call   80106260 <acquire>
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
80102431:	e8 ca 3d 00 00       	call   80106200 <release>
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
8010244a:	e8 b1 3d 00 00       	call   80106200 <release>
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
8010246f:	e8 ec 3d 00 00       	call   80106260 <acquire>
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
8010248c:	e8 6f 3d 00 00       	call   80106200 <release>
  return f;
}
80102491:	89 d8                	mov    %ebx,%eax
80102493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102496:	c9                   	leave
80102497:	c3                   	ret
    panic("filedup");
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 c3 95 10 80       	push   $0x801095c3
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
801024c1:	e8 9a 3d 00 00       	call   80106260 <acquire>
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
801024fc:	e8 ff 3c 00 00       	call   80106200 <release>

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
8010252e:	e9 cd 3c 00 00       	jmp    80106200 <release>
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
8010257c:	68 cb 95 10 80       	push   $0x801095cb
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
80102662:	68 d5 95 10 80       	push   $0x801095d5
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
80102737:	68 de 95 10 80       	push   $0x801095de
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
80102771:	68 e4 95 10 80       	push   $0x801095e4
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
80102829:	68 ee 95 10 80       	push   $0x801095ee
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
8010286d:	e8 ee 3a 00 00       	call   80106360 <memset>
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
801028aa:	e8 b1 39 00 00       	call   80106260 <acquire>
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
80102917:	e8 e4 38 00 00       	call   80106200 <release>

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
80102945:	e8 b6 38 00 00       	call   80106200 <release>
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
80102978:	68 04 96 10 80       	push   $0x80109604
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
801029f7:	68 14 96 10 80       	push   $0x80109614
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
80102ad5:	68 27 96 10 80       	push   $0x80109627
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
80102b01:	e8 ea 38 00 00       	call   801063f0 <memmove>
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
80102b2c:	68 3a 96 10 80       	push   $0x8010963a
80102b31:	68 00 2c 11 80       	push   $0x80112c00
80102b36:	e8 35 35 00 00       	call   80106070 <initlock>
  for(i = 0; i < NINODE; i++) {
80102b3b:	83 c4 10             	add    $0x10,%esp
80102b3e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80102b40:	83 ec 08             	sub    $0x8,%esp
80102b43:	68 41 96 10 80       	push   $0x80109641
80102b48:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80102b49:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80102b4f:	e8 ec 33 00 00       	call   80105f40 <initsleeplock>
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
80102b7c:	e8 6f 38 00 00       	call   801063f0 <memmove>
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
80102bb3:	68 5c 9b 10 80       	push   $0x80109b5c
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
80102c4e:	e8 0d 37 00 00       	call   80106360 <memset>
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
80102c83:	68 47 96 10 80       	push   $0x80109647
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
80102cf1:	e8 fa 36 00 00       	call   801063f0 <memmove>
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
80102d1f:	e8 3c 35 00 00       	call   80106260 <acquire>
  ip->ref++;
80102d24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102d28:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102d2f:	e8 cc 34 00 00       	call   80106200 <release>
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
80102d62:	e8 19 32 00 00       	call   80105f80 <acquiresleep>
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
80102dd8:	e8 13 36 00 00       	call   801063f0 <memmove>
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
80102dfd:	68 5f 96 10 80       	push   $0x8010965f
80102e02:	e8 49 d7 ff ff       	call   80100550 <panic>
    panic("ilock");
80102e07:	83 ec 0c             	sub    $0xc,%esp
80102e0a:	68 59 96 10 80       	push   $0x80109659
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
80102e33:	e8 e8 31 00 00       	call   80106020 <holdingsleep>
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
80102e4f:	e9 8c 31 00 00       	jmp    80105fe0 <releasesleep>
    panic("iunlock");
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 6e 96 10 80       	push   $0x8010966e
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
80102e80:	e8 fb 30 00 00       	call   80105f80 <acquiresleep>
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
80102e9a:	e8 41 31 00 00       	call   80105fe0 <releasesleep>
  acquire(&icache.lock);
80102e9f:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102ea6:	e8 b5 33 00 00       	call   80106260 <acquire>
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
80102ec0:	e9 3b 33 00 00       	jmp    80106200 <release>
80102ec5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102ec8:	83 ec 0c             	sub    $0xc,%esp
80102ecb:	68 00 2c 11 80       	push   $0x80112c00
80102ed0:	e8 8b 33 00 00       	call   80106260 <acquire>
    int r = ip->ref;
80102ed5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102ed8:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
80102edf:	e8 1c 33 00 00       	call   80106200 <release>
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
80102fe3:	e8 38 30 00 00       	call   80106020 <holdingsleep>
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	85 c0                	test   %eax,%eax
80102fed:	74 21                	je     80103010 <iunlockput+0x40>
80102fef:	8b 43 08             	mov    0x8(%ebx),%eax
80102ff2:	85 c0                	test   %eax,%eax
80102ff4:	7e 1a                	jle    80103010 <iunlockput+0x40>
  releasesleep(&ip->lock);
80102ff6:	83 ec 0c             	sub    $0xc,%esp
80102ff9:	56                   	push   %esi
80102ffa:	e8 e1 2f 00 00       	call   80105fe0 <releasesleep>
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
80103013:	68 6e 96 10 80       	push   $0x8010966e
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
801030f7:	e8 f4 32 00 00       	call   801063f0 <memmove>
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
801031f5:	e8 f6 31 00 00       	call   801063f0 <memmove>
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
8010327e:	e8 dd 31 00 00       	call   80106460 <strncmp>
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
801032dd:	e8 7e 31 00 00       	call   80106460 <strncmp>
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
80103322:	68 88 96 10 80       	push   $0x80109688
80103327:	e8 24 d2 ff ff       	call   80100550 <panic>
    panic("dirlookup not DIR");
8010332c:	83 ec 0c             	sub    $0xc,%esp
8010332f:	68 76 96 10 80       	push   $0x80109676
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
8010335a:	e8 51 1d 00 00       	call   801050b0 <myproc>
  acquire(&icache.lock);
8010335f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103362:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103365:	68 00 2c 11 80       	push   $0x80112c00
8010336a:	e8 f1 2e 00 00       	call   80106260 <acquire>
  ip->ref++;
8010336f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80103373:	c7 04 24 00 2c 11 80 	movl   $0x80112c00,(%esp)
8010337a:	e8 81 2e 00 00       	call   80106200 <release>
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
801033d7:	e8 14 30 00 00       	call   801063f0 <memmove>
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
8010343c:	e8 df 2b 00 00       	call   80106020 <holdingsleep>
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
8010345e:	e8 7d 2b 00 00       	call   80105fe0 <releasesleep>
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
8010348b:	e8 60 2f 00 00       	call   801063f0 <memmove>
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
801034c5:	e8 56 2b 00 00       	call   80106020 <holdingsleep>
801034ca:	83 c4 10             	add    $0x10,%esp
801034cd:	85 c0                	test   %eax,%eax
801034cf:	74 7d                	je     8010354e <namex+0x20e>
801034d1:	8b 4e 08             	mov    0x8(%esi),%ecx
801034d4:	85 c9                	test   %ecx,%ecx
801034d6:	7e 76                	jle    8010354e <namex+0x20e>
  releasesleep(&ip->lock);
801034d8:	83 ec 0c             	sub    $0xc,%esp
801034db:	53                   	push   %ebx
801034dc:	e8 ff 2a 00 00       	call   80105fe0 <releasesleep>
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
80103515:	e8 06 2b 00 00       	call   80106020 <holdingsleep>
8010351a:	83 c4 10             	add    $0x10,%esp
8010351d:	85 c0                	test   %eax,%eax
8010351f:	74 2d                	je     8010354e <namex+0x20e>
80103521:	8b 7e 08             	mov    0x8(%esi),%edi
80103524:	85 ff                	test   %edi,%edi
80103526:	7e 26                	jle    8010354e <namex+0x20e>
  releasesleep(&ip->lock);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	53                   	push   %ebx
8010352c:	e8 af 2a 00 00       	call   80105fe0 <releasesleep>
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
80103551:	68 6e 96 10 80       	push   $0x8010966e
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
801035bd:	e8 ee 2e 00 00       	call   801064b0 <strncpy>
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
801035fb:	68 97 96 10 80       	push   $0x80109697
80103600:	e8 4b cf ff ff       	call   80100550 <panic>
    panic("dirlink");
80103605:	83 ec 0c             	sub    $0xc,%esp
80103608:	68 86 99 10 80       	push   $0x80109986
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
80103676:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
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
8010371b:	68 ad 96 10 80       	push   $0x801096ad
80103720:	e8 2b ce ff ff       	call   80100550 <panic>
    panic("idestart");
80103725:	83 ec 0c             	sub    $0xc,%esp
80103728:	68 a4 96 10 80       	push   $0x801096a4
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
80103746:	68 bf 96 10 80       	push   $0x801096bf
8010374b:	68 a0 48 11 80       	push   $0x801148a0
80103750:	e8 1b 29 00 00       	call   80106070 <initlock>
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
801037de:	e8 7d 2a 00 00       	call   80106260 <acquire>

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
8010383d:	e8 4e 22 00 00       	call   80105a90 <wakeup>

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
8010385b:	e8 a0 29 00 00       	call   80106200 <release>

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
8010387e:	e8 9d 27 00 00       	call   80106020 <holdingsleep>
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
801038b8:	e8 a3 29 00 00       	call   80106260 <acquire>

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
801038f9:	e8 32 1f 00 00       	call   80105830 <sleep>
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
80103916:	e9 e5 28 00 00       	jmp    80106200 <release>
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
8010393a:	68 ee 96 10 80       	push   $0x801096ee
8010393f:	e8 0c cc ff ff       	call   80100550 <panic>
    panic("iderw: nothing to do");
80103944:	83 ec 0c             	sub    $0xc,%esp
80103947:	68 d9 96 10 80       	push   $0x801096d9
8010394c:	e8 ff cb ff ff       	call   80100550 <panic>
    panic("iderw: buf not locked");
80103951:	83 ec 0c             	sub    $0xc,%esp
80103954:	68 c3 96 10 80       	push   $0x801096c3
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
801039aa:	68 b0 9b 10 80       	push   $0x80109bb0
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
80103a52:	81 fb 70 8d 11 80    	cmp    $0x80118d70,%ebx
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
80103a72:	e8 e9 28 00 00       	call   80106360 <memset>

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
80103aa8:	e8 b3 27 00 00       	call   80106260 <acquire>
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	eb d2                	jmp    80103a84 <kfree+0x44>
80103ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80103ab8:	c7 45 08 e0 48 11 80 	movl   $0x801148e0,0x8(%ebp)
}
80103abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac2:	c9                   	leave
    release(&kmem.lock);
80103ac3:	e9 38 27 00 00       	jmp    80106200 <release>
    panic("kfree");
80103ac8:	83 ec 0c             	sub    $0xc,%esp
80103acb:	68 0c 97 10 80       	push   $0x8010970c
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
80103b9b:	68 12 97 10 80       	push   $0x80109712
80103ba0:	68 e0 48 11 80       	push   $0x801148e0
80103ba5:	e8 c6 24 00 00       	call   80106070 <initlock>
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
80103c38:	e8 23 26 00 00       	call   80106260 <acquire>
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
80103c63:	e8 98 25 00 00       	call   80106200 <release>
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
80103cbb:	0f b6 91 80 9e 10 80 	movzbl -0x7fef6180(%ecx),%edx
  shift ^= togglecode[data];
80103cc2:	0f b6 81 80 9d 10 80 	movzbl -0x7fef6280(%ecx),%eax
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
80103cdb:	8b 04 85 60 9d 10 80 	mov    -0x7fef62a0(,%eax,4),%eax
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
80103d18:	0f b6 81 80 9e 10 80 	movzbl -0x7fef6180(%ecx),%eax
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
80104073:	e8 28 23 00 00       	call   801063a0 <memcmp>
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
801041a4:	e8 47 22 00 00       	call   801063f0 <memmove>
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
8010424a:	68 17 97 10 80       	push   $0x80109717
8010424f:	68 40 49 11 80       	push   $0x80114940
80104254:	e8 17 1e 00 00       	call   80106070 <initlock>
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
801042eb:	e8 70 1f 00 00       	call   80106260 <acquire>
801042f0:	83 c4 10             	add    $0x10,%esp
801042f3:	eb 18                	jmp    8010430d <begin_op+0x2d>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801042f8:	83 ec 08             	sub    $0x8,%esp
801042fb:	68 40 49 11 80       	push   $0x80114940
80104300:	68 40 49 11 80       	push   $0x80114940
80104305:	e8 26 15 00 00       	call   80105830 <sleep>
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
8010433c:	e8 bf 1e 00 00       	call   80106200 <release>
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
8010435e:	e8 fd 1e 00 00       	call   80106260 <acquire>
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
8010439c:	e8 5f 1e 00 00       	call   80106200 <release>
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
801043b6:	e8 a5 1e 00 00       	call   80106260 <acquire>
    log.committing = 0;
801043bb:	c7 05 80 49 11 80 00 	movl   $0x0,0x80114980
801043c2:	00 00 00 
    wakeup(&log);
801043c5:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
801043cc:	e8 bf 16 00 00       	call   80105a90 <wakeup>
    release(&log.lock);
801043d1:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
801043d8:	e8 23 1e 00 00       	call   80106200 <release>
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
80104434:	e8 b7 1f 00 00       	call   801063f0 <memmove>
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
80104488:	e8 03 16 00 00       	call   80105a90 <wakeup>
  release(&log.lock);
8010448d:	c7 04 24 40 49 11 80 	movl   $0x80114940,(%esp)
80104494:	e8 67 1d 00 00       	call   80106200 <release>
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
801044a7:	68 1b 97 10 80       	push   $0x8010971b
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
801044f2:	e8 69 1d 00 00       	call   80106260 <acquire>
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
80104539:	e9 c2 1c 00 00       	jmp    80106200 <release>
8010453e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104540:	89 0c 95 8c 49 11 80 	mov    %ecx,-0x7feeb674(,%edx,4)
    log.lh.n++;
80104547:	83 c2 01             	add    $0x1,%edx
8010454a:	89 15 88 49 11 80    	mov    %edx,0x80114988
80104550:	eb d9                	jmp    8010452b <log_write+0x6b>
    panic("too big a transaction");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 2a 97 10 80       	push   $0x8010972a
8010455a:	e8 f1 bf ff ff       	call   80100550 <panic>
    panic("log_write outside of trans");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 40 97 10 80       	push   $0x80109740
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
80104577:	e8 b4 0a 00 00       	call   80105030 <cpuid>
8010457c:	89 c3                	mov    %eax,%ebx
8010457e:	e8 ad 0a 00 00       	call   80105030 <cpuid>
80104583:	83 ec 04             	sub    $0x4,%esp
80104586:	53                   	push   %ebx
80104587:	50                   	push   %eax
80104588:	68 5b 97 10 80       	push   $0x8010975b
8010458d:	e8 ce c7 ff ff       	call   80100d60 <cprintf>
  idtinit();       // load idt register
80104592:	e8 b9 36 00 00       	call   80107c50 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104597:	e8 34 0a 00 00       	call   80104fd0 <mycpu>
8010459c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010459e:	b8 01 00 00 00       	mov    $0x1,%eax
801045a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801045aa:	e8 61 0e 00 00       	call   80105410 <scheduler>
801045af:	90                   	nop

801045b0 <mpenter>:
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801045b6:	e8 f5 47 00 00       	call   80108db0 <switchkvm>
  seginit();
801045bb:	e8 60 47 00 00       	call   80108d20 <seginit>
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
801045e7:	68 70 8d 11 80       	push   $0x80118d70
801045ec:	e8 9f f5 ff ff       	call   80103b90 <kinit1>
  kvmalloc();      // kernel page table
801045f1:	e8 7a 4c 00 00       	call   80109270 <kvmalloc>
  mpinit();        // detect other processors
801045f6:	e8 85 01 00 00       	call   80104780 <mpinit>
  lapicinit();     // interrupt controller
801045fb:	e8 80 f7 ff ff       	call   80103d80 <lapicinit>
  seginit();       // segment descriptors
80104600:	e8 1b 47 00 00       	call   80108d20 <seginit>
  picinit();       // disable pic
80104605:	e8 86 03 00 00       	call   80104990 <picinit>
  ioapicinit();    // another interrupt controller
8010460a:	e8 51 f3 ff ff       	call   80103960 <ioapicinit>
  consoleinit();   // console hardware
8010460f:	e8 bc d9 ff ff       	call   80101fd0 <consoleinit>
  uartinit();      // serial port
80104614:	e8 77 39 00 00       	call   80107f90 <uartinit>
  pinit();         // process table
80104619:	e8 12 09 00 00       	call   80104f30 <pinit>
  tvinit();        // trap vectors
8010461e:	e8 ad 35 00 00       	call   80107bd0 <tvinit>
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
80104644:	e8 a7 1d 00 00       	call   801063f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	69 05 24 4a 11 80 b4 	imul   $0xb4,0x80114a24,%eax
80104653:	00 00 00 
80104656:	05 40 4a 11 80       	add    $0x80114a40,%eax
8010465b:	3d 40 4a 11 80       	cmp    $0x80114a40,%eax
80104660:	76 7e                	jbe    801046e0 <main+0x110>
80104662:	bb 40 4a 11 80       	mov    $0x80114a40,%ebx
80104667:	eb 20                	jmp    80104689 <main+0xb9>
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104670:	69 05 24 4a 11 80 b4 	imul   $0xb4,0x80114a24,%eax
80104677:	00 00 00 
8010467a:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80104680:	05 40 4a 11 80       	add    $0x80114a40,%eax
80104685:	39 c3                	cmp    %eax,%ebx
80104687:	73 57                	jae    801046e0 <main+0x110>
    if(c == mycpu())  // We've started already.
80104689:	e8 42 09 00 00       	call   80104fd0 <mycpu>
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
801046f2:	e8 e9 09 00 00       	call   801050e0 <userinit>
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
8010472e:	68 6f 97 10 80       	push   $0x8010976f
80104733:	56                   	push   %esi
80104734:	e8 67 1c 00 00       	call   801063a0 <memcmp>
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
801047e9:	68 74 97 10 80       	push   $0x80109774
801047ee:	50                   	push   %eax
801047ef:	e8 ac 1b 00 00       	call   801063a0 <memcmp>
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
801048cb:	69 f1 b4 00 00 00    	imul   $0xb4,%ecx,%esi
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
8010491b:	68 79 97 10 80       	push   $0x80109779
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
80104942:	68 6f 97 10 80       	push   $0x8010976f
80104947:	53                   	push   %ebx
80104948:	e8 53 1a 00 00       	call   801063a0 <memcmp>
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
80104978:	68 e4 9b 10 80       	push   $0x80109be4
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
80104a23:	68 91 97 10 80       	push   $0x80109791
80104a28:	50                   	push   %eax
80104a29:	e8 42 16 00 00       	call   80106070 <initlock>
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
80104aaf:	e8 ac 17 00 00       	call   80106260 <acquire>
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
80104acf:	e8 bc 0f 00 00       	call   80105a90 <wakeup>
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
80104af4:	e9 07 17 00 00       	jmp    80106200 <release>
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	53                   	push   %ebx
80104b04:	e8 f7 16 00 00       	call   80106200 <release>
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
80104b34:	e8 57 0f 00 00       	call   80105a90 <wakeup>
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
80104b50:	e8 0b 17 00 00       	call   80106260 <acquire>
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
80104ba0:	e8 0b 05 00 00       	call   801050b0 <myproc>
80104ba5:	8b 48 24             	mov    0x24(%eax),%ecx
80104ba8:	85 c9                	test   %ecx,%ecx
80104baa:	75 34                	jne    80104be0 <pipewrite+0xa0>
      wakeup(&p->nread);
80104bac:	83 ec 0c             	sub    $0xc,%esp
80104baf:	56                   	push   %esi
80104bb0:	e8 db 0e 00 00       	call   80105a90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104bb5:	58                   	pop    %eax
80104bb6:	5a                   	pop    %edx
80104bb7:	53                   	push   %ebx
80104bb8:	57                   	push   %edi
80104bb9:	e8 72 0c 00 00       	call   80105830 <sleep>
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
80104be4:	e8 17 16 00 00       	call   80106200 <release>
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
80104c38:	e8 53 0e 00 00       	call   80105a90 <wakeup>
  release(&p->lock);
80104c3d:	89 1c 24             	mov    %ebx,(%esp)
80104c40:	e8 bb 15 00 00       	call   80106200 <release>
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
80104c76:	e8 e5 15 00 00       	call   80106260 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104c7b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80104c8a:	74 2f                	je     80104cbb <piperead+0x5b>
80104c8c:	eb 37                	jmp    80104cc5 <piperead+0x65>
80104c8e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80104c90:	e8 1b 04 00 00       	call   801050b0 <myproc>
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
80104ca5:	e8 86 0b 00 00       	call   80105830 <sleep>
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
80104d06:	e8 85 0d 00 00       	call   80105a90 <wakeup>
  release(&p->lock);
80104d0b:	89 34 24             	mov    %esi,(%esp)
80104d0e:	e8 ed 14 00 00       	call   80106200 <release>
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
80104d29:	e8 d2 14 00 00       	call   80106200 <release>
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

80104d40 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	89 c6                	mov    %eax,%esi
80104d47:	53                   	push   %ebx
80104d48:	bb d4 54 11 80       	mov    $0x801154d4,%ebx
80104d4d:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i;

  // پیمایش تمام صف‌ها چون پردازه خوابیده ممکن است در هر صفی باشد
  for(i = 0; i < NCPU; i++) {
      acquire(&ptables[i].lock);
80104d50:	83 ec 0c             	sub    $0xc,%esp
80104d53:	8d bb 6c fb ff ff    	lea    -0x494(%ebx),%edi
80104d59:	57                   	push   %edi
80104d5a:	e8 01 15 00 00       	call   80106260 <acquire>
      for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++)
80104d5f:	8d 83 a0 fb ff ff    	lea    -0x460(%ebx),%eax
80104d65:	83 c4 10             	add    $0x10,%esp
80104d68:	81 fb 5f 04 00 00    	cmp    $0x45f,%ebx
80104d6e:	77 11                	ja     80104d81 <wakeup1+0x41>
80104d70:	eb 2e                	jmp    80104da0 <wakeup1+0x60>
80104d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d78:	05 8c 00 00 00       	add    $0x8c,%eax
80104d7d:	39 d8                	cmp    %ebx,%eax
80104d7f:	73 1f                	jae    80104da0 <wakeup1+0x60>
        if(p->state == SLEEPING && p->chan == chan)
80104d81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d85:	75 f1                	jne    80104d78 <wakeup1+0x38>
80104d87:	39 70 20             	cmp    %esi,0x20(%eax)
80104d8a:	75 ec                	jne    80104d78 <wakeup1+0x38>
          p->state = RUNNABLE;
80104d8c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++)
80104d93:	05 8c 00 00 00       	add    $0x8c,%eax
80104d98:	39 d8                	cmp    %ebx,%eax
80104d9a:	72 e5                	jb     80104d81 <wakeup1+0x41>
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&ptables[i].lock);
80104da0:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
80104da3:	81 c3 94 04 00 00    	add    $0x494,%ebx
      release(&ptables[i].lock);
80104da9:	57                   	push   %edi
80104daa:	e8 51 14 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	81 fb 74 79 11 80    	cmp    $0x80117974,%ebx
80104db8:	75 96                	jne    80104d50 <wakeup1+0x10>
  }
}
80104dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dbd:	5b                   	pop    %ebx
80104dbe:	5e                   	pop    %esi
80104dbf:	5f                   	pop    %edi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret
80104dc2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dc9:	00 
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <allocproc>:
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	56                   	push   %esi
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 28             	sub    $0x28,%esp
  acquire(&pid_lock);
80104dd9:	68 00 50 11 80       	push   $0x80115000
80104dde:	e8 7d 14 00 00       	call   80106260 <acquire>
  pid = nextpid++;
80104de3:	8b 35 04 d0 10 80    	mov    0x8010d004,%esi
80104de9:	8d 46 01             	lea    0x1(%esi),%eax
80104dec:	a3 04 d0 10 80       	mov    %eax,0x8010d004
  release(&pid_lock);
80104df1:	c7 04 24 00 50 11 80 	movl   $0x80115000,(%esp)
80104df8:	e8 03 14 00 00       	call   80106200 <release>
  int cpu_idx = pid % ncpu;
80104dfd:	89 f0                	mov    %esi,%eax
80104dff:	99                   	cltd
80104e00:	f7 3d 24 4a 11 80    	idivl  0x80114a24
80104e06:	69 d2 94 04 00 00    	imul   $0x494,%edx,%edx
  acquire(&pq->lock);
80104e0c:	8d ba 40 50 11 80    	lea    -0x7feeafc0(%edx),%edi
80104e12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104e15:	89 3c 24             	mov    %edi,(%esp)
80104e18:	e8 43 14 00 00       	call   80106260 <acquire>
  for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++)
80104e1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e20:	83 c4 10             	add    $0x10,%esp
80104e23:	8d 9a 74 50 11 80    	lea    -0x7feeaf8c(%edx),%ebx
80104e29:	81 c2 d4 54 11 80    	add    $0x801154d4,%edx
80104e2f:	39 d3                	cmp    %edx,%ebx
80104e31:	72 1b                	jb     80104e4e <allocproc+0x7e>
80104e33:	e9 c0 00 00 00       	jmp    80104ef8 <allocproc+0x128>
80104e38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e3f:	00 
80104e40:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104e46:	39 d3                	cmp    %edx,%ebx
80104e48:	0f 83 aa 00 00 00    	jae    80104ef8 <allocproc+0x128>
    if(p->state == UNUSED)
80104e4e:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e51:	85 c0                	test   %eax,%eax
80104e53:	75 eb                	jne    80104e40 <allocproc+0x70>
  acquire(&tickslock);
80104e55:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104e58:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = pid;
80104e5f:	89 73 10             	mov    %esi,0x10(%ebx)
  acquire(&tickslock);
80104e62:	68 20 75 11 80       	push   $0x80117520
80104e67:	e8 f4 13 00 00       	call   80106260 <acquire>
  p->creation_time = ticks;   // زمان ایجاد پردازه بر حسب tick
80104e6c:	a1 00 75 11 80       	mov    0x80117500,%eax
80104e71:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  release(&tickslock);
80104e77:	c7 04 24 20 75 11 80 	movl   $0x80117520,(%esp)
80104e7e:	e8 7d 13 00 00       	call   80106200 <release>
  release(&pq->lock);
80104e83:	89 3c 24             	mov    %edi,(%esp)
80104e86:	e8 75 13 00 00       	call   80106200 <release>
  if((p->kstack = kalloc()) == 0){
80104e8b:	e8 70 ed ff ff       	call   80103c00 <kalloc>
80104e90:	83 c4 10             	add    $0x10,%esp
80104e93:	89 43 08             	mov    %eax,0x8(%ebx)
80104e96:	85 c0                	test   %eax,%eax
80104e98:	74 6e                	je     80104f08 <allocproc+0x138>
  sp -= sizeof *p->tf;
80104e9a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80104ea0:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104ea3:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104ea8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104eab:	c7 40 14 bd 7b 10 80 	movl   $0x80107bbd,0x14(%eax)
  p->context = (struct context*)sp;
80104eb2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104eb5:	6a 14                	push   $0x14
80104eb7:	6a 00                	push   $0x0
80104eb9:	50                   	push   %eax
80104eba:	e8 a1 14 00 00       	call   80106360 <memset>
  p->context->eip = (uint)forkret;
80104ebf:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
80104ec2:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104ec5:	c7 40 10 50 50 10 80 	movl   $0x80105050,0x10(%eax)
  p->priority = PRIO_DEFAULT;
80104ecc:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  p->tick_count = 0;
80104ed3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104eda:	00 00 00 
  p->total_tick_count = 0;
80104edd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104ee4:	00 00 00 
}
80104ee7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eea:	89 d8                	mov    %ebx,%eax
80104eec:	5b                   	pop    %ebx
80104eed:	5e                   	pop    %esi
80104eee:	5f                   	pop    %edi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&pq->lock);
80104ef8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104efb:	31 db                	xor    %ebx,%ebx
  release(&pq->lock);
80104efd:	57                   	push   %edi
80104efe:	e8 fd 12 00 00       	call   80106200 <release>
  return 0;
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	eb df                	jmp    80104ee7 <allocproc+0x117>
    acquire(&pq->lock);
80104f08:	83 ec 0c             	sub    $0xc,%esp
80104f0b:	57                   	push   %edi
80104f0c:	e8 4f 13 00 00       	call   80106260 <acquire>
    p->state = UNUSED;
80104f11:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80104f18:	31 db                	xor    %ebx,%ebx
    release(&pq->lock);
80104f1a:	89 3c 24             	mov    %edi,(%esp)
80104f1d:	e8 de 12 00 00       	call   80106200 <release>
    return 0;
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	eb c0                	jmp    80104ee7 <allocproc+0x117>
80104f27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f2e:	00 
80104f2f:	90                   	nop

80104f30 <pinit>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	bb 40 50 11 80       	mov    $0x80115040,%ebx
80104f39:	83 ec 0c             	sub    $0xc,%esp
  initlock(&pid_lock, "nextpid");
80104f3c:	68 96 97 10 80       	push   $0x80109796
80104f41:	68 00 50 11 80       	push   $0x80115000
80104f46:	e8 25 11 00 00       	call   80106070 <initlock>
  for(i = 0; i < NCPU; i++) {
80104f4b:	83 c4 10             	add    $0x10,%esp
80104f4e:	66 90                	xchg   %ax,%ax
    initlock(&ptables[i].lock, "ptable");
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	68 9e 97 10 80       	push   $0x8010979e
80104f58:	53                   	push   %ebx
  for(i = 0; i < NCPU; i++) {
80104f59:	81 c3 94 04 00 00    	add    $0x494,%ebx
    initlock(&ptables[i].lock, "ptable");
80104f5f:	e8 0c 11 00 00       	call   80106070 <initlock>
  for(i = 0; i < NCPU; i++) {
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	81 fb e0 74 11 80    	cmp    $0x801174e0,%ebx
80104f6d:	75 e1                	jne    80104f50 <pinit+0x20>
}
80104f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f72:	c9                   	leave
80104f73:	c3                   	ret
80104f74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f7b:	00 
80104f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f80 <get_proc_cpuid>:
{
80104f80:	55                   	push   %ebp
80104f81:	b8 74 50 11 80       	mov    $0x80115074,%eax
  for(i = 0; i < NCPU; i++){
80104f86:	31 d2                	xor    %edx,%edx
{
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	53                   	push   %ebx
80104f8b:	83 ec 04             	sub    $0x4,%esp
80104f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= ptables[i].proc && p < ptables[i].proc + NPROC_PER_CPU)
80104f98:	39 c1                	cmp    %eax,%ecx
80104f9a:	72 0a                	jb     80104fa6 <get_proc_cpuid+0x26>
80104f9c:	8d 98 60 04 00 00    	lea    0x460(%eax),%ebx
80104fa2:	39 d9                	cmp    %ebx,%ecx
80104fa4:	72 1a                	jb     80104fc0 <get_proc_cpuid+0x40>
  for(i = 0; i < NCPU; i++){
80104fa6:	83 c2 01             	add    $0x1,%edx
80104fa9:	05 94 04 00 00       	add    $0x494,%eax
80104fae:	83 fa 08             	cmp    $0x8,%edx
80104fb1:	75 e5                	jne    80104f98 <get_proc_cpuid+0x18>
  panic("get_proc_cpuid: process not in any queue");
80104fb3:	83 ec 0c             	sub    $0xc,%esp
80104fb6:	68 04 9c 10 80       	push   $0x80109c04
80104fbb:	e8 90 b5 ff ff       	call   80100550 <panic>
}
80104fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc3:	89 d0                	mov    %edx,%eax
80104fc5:	c9                   	leave
80104fc6:	c3                   	ret
80104fc7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fce:	00 
80104fcf:	90                   	nop

80104fd0 <mycpu>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fd5:	9c                   	pushf
80104fd6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fd7:	f6 c4 02             	test   $0x2,%ah
80104fda:	75 46                	jne    80105022 <mycpu+0x52>
  apicid = lapicid();
80104fdc:	e8 8f ee ff ff       	call   80103e70 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104fe1:	8b 35 24 4a 11 80    	mov    0x80114a24,%esi
80104fe7:	85 f6                	test   %esi,%esi
80104fe9:	7e 2a                	jle    80105015 <mycpu+0x45>
80104feb:	31 d2                	xor    %edx,%edx
80104fed:	eb 08                	jmp    80104ff7 <mycpu+0x27>
80104fef:	90                   	nop
80104ff0:	83 c2 01             	add    $0x1,%edx
80104ff3:	39 f2                	cmp    %esi,%edx
80104ff5:	74 1e                	je     80105015 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80104ff7:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
80104ffd:	0f b6 99 40 4a 11 80 	movzbl -0x7feeb5c0(%ecx),%ebx
80105004:	39 c3                	cmp    %eax,%ebx
80105006:	75 e8                	jne    80104ff0 <mycpu+0x20>
}
80105008:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010500b:	8d 81 40 4a 11 80    	lea    -0x7feeb5c0(%ecx),%eax
}
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5d                   	pop    %ebp
80105014:	c3                   	ret
  panic("unknown apicid\n");
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	68 a5 97 10 80       	push   $0x801097a5
8010501d:	e8 2e b5 ff ff       	call   80100550 <panic>
    panic("mycpu called with interrupts enabled\n");
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 30 9c 10 80       	push   $0x80109c30
8010502a:	e8 21 b5 ff ff       	call   80100550 <panic>
8010502f:	90                   	nop

80105030 <cpuid>:
cpuid() {
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80105036:	e8 95 ff ff ff       	call   80104fd0 <mycpu>
}
8010503b:	c9                   	leave
  return mycpu()-cpus;
8010503c:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
80105041:	c1 f8 02             	sar    $0x2,%eax
80105044:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
8010504a:	c3                   	ret
8010504b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105050 <forkret>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80105056:	e8 75 ff ff ff       	call   80104fd0 <mycpu>
  release(&ptables[cpuid()].lock);
8010505b:	83 ec 0c             	sub    $0xc,%esp
  return mycpu()-cpus;
8010505e:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
80105063:	c1 f8 02             	sar    $0x2,%eax
  release(&ptables[cpuid()].lock);
80105066:	69 c0 64 9f f4 49    	imul   $0x49f49f64,%eax,%eax
8010506c:	05 40 50 11 80       	add    $0x80115040,%eax
80105071:	50                   	push   %eax
80105072:	e8 89 11 00 00       	call   80106200 <release>
  if (first) {
80105077:	a1 00 d0 10 80       	mov    0x8010d000,%eax
8010507c:	83 c4 10             	add    $0x10,%esp
8010507f:	85 c0                	test   %eax,%eax
80105081:	75 05                	jne    80105088 <forkret+0x38>
}
80105083:	c9                   	leave
80105084:	c3                   	ret
80105085:	8d 76 00             	lea    0x0(%esi),%esi
    first = 0;
80105088:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
8010508f:	00 00 00 
    iinit(ROOTDEV);
80105092:	83 ec 0c             	sub    $0xc,%esp
80105095:	6a 01                	push   $0x1
80105097:	e8 84 da ff ff       	call   80102b20 <iinit>
    initlog(ROOTDEV);
8010509c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050a3:	e8 98 f1 ff ff       	call   80104240 <initlog>
}
801050a8:	83 c4 10             	add    $0x10,%esp
801050ab:	c9                   	leave
801050ac:	c3                   	ret
801050ad:	8d 76 00             	lea    0x0(%esi),%esi

801050b0 <myproc>:
myproc(void) {
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801050b7:	e8 54 10 00 00       	call   80106110 <pushcli>
  c = mycpu();
801050bc:	e8 0f ff ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
801050c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801050c7:	e8 94 10 00 00       	call   80106160 <popcli>
}
801050cc:	89 d8                	mov    %ebx,%eax
801050ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050d1:	c9                   	leave
801050d2:	c3                   	ret
801050d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050da:	00 
801050db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801050e0 <userinit>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  p = allocproc();
801050e5:	e8 e6 fc ff ff       	call   80104dd0 <allocproc>
801050ea:	89 c6                	mov    %eax,%esi
  initproc = p;
801050ec:	a3 e0 74 11 80       	mov    %eax,0x801174e0
  if((p->pgdir = setupkvm()) == 0)
801050f1:	e8 fa 40 00 00       	call   801091f0 <setupkvm>
801050f6:	89 46 04             	mov    %eax,0x4(%esi)
801050f9:	85 c0                	test   %eax,%eax
801050fb:	0f 84 f1 00 00 00    	je     801051f2 <userinit+0x112>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80105101:	83 ec 04             	sub    $0x4,%esp
80105104:	68 2c 00 00 00       	push   $0x2c
80105109:	68 60 d4 10 80       	push   $0x8010d460
8010510e:	50                   	push   %eax
8010510f:	e8 bc 3d 00 00       	call   80108ed0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80105114:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80105117:	c7 06 00 10 00 00    	movl   $0x1000,(%esi)
  memset(p->tf, 0, sizeof(*p->tf));
8010511d:	6a 4c                	push   $0x4c
8010511f:	6a 00                	push   $0x0
80105121:	ff 76 18             	push   0x18(%esi)
80105124:	e8 37 12 00 00       	call   80106360 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80105129:	8b 46 18             	mov    0x18(%esi),%eax
8010512c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105131:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80105134:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80105139:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010513d:	8b 46 18             	mov    0x18(%esi),%eax
80105140:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80105144:	8b 46 18             	mov    0x18(%esi),%eax
80105147:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010514b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010514f:	8b 46 18             	mov    0x18(%esi),%eax
80105152:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80105156:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010515a:	8b 46 18             	mov    0x18(%esi),%eax
8010515d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80105164:	8b 46 18             	mov    0x18(%esi),%eax
80105167:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010516e:	8b 46 18             	mov    0x18(%esi),%eax
80105171:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105178:	8d 46 6c             	lea    0x6c(%esi),%eax
8010517b:	6a 10                	push   $0x10
8010517d:	68 ce 97 10 80       	push   $0x801097ce
80105182:	50                   	push   %eax
80105183:	e8 88 13 00 00       	call   80106510 <safestrcpy>
  p->cwd = namei("/");
80105188:	c7 04 24 d7 97 10 80 	movl   $0x801097d7,(%esp)
8010518f:	e8 8c e4 ff ff       	call   80103620 <namei>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	89 46 68             	mov    %eax,0x68(%esi)
  for(i = 0; i < NCPU; i++){
8010519a:	b8 74 50 11 80       	mov    $0x80115074,%eax
8010519f:	90                   	nop
    if(p >= ptables[i].proc && p < ptables[i].proc + NPROC_PER_CPU)
801051a0:	39 c6                	cmp    %eax,%esi
801051a2:	72 0a                	jb     801051ae <userinit+0xce>
801051a4:	8d 90 60 04 00 00    	lea    0x460(%eax),%edx
801051aa:	39 d6                	cmp    %edx,%esi
801051ac:	72 22                	jb     801051d0 <userinit+0xf0>
  for(i = 0; i < NCPU; i++){
801051ae:	05 94 04 00 00       	add    $0x494,%eax
801051b3:	3d 14 75 11 80       	cmp    $0x80117514,%eax
801051b8:	75 e6                	jne    801051a0 <userinit+0xc0>
  panic("get_proc_cpuid: process not in any queue");
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	68 04 9c 10 80       	push   $0x80109c04
801051c2:	e8 89 b3 ff ff       	call   80100550 <panic>
801051c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051ce:	00 
801051cf:	90                   	nop
  acquire(&ptables[owner_cpu].lock);
801051d0:	8d 58 cc             	lea    -0x34(%eax),%ebx
801051d3:	83 ec 0c             	sub    $0xc,%esp
801051d6:	53                   	push   %ebx
801051d7:	e8 84 10 00 00       	call   80106260 <acquire>
  p->state = RUNNABLE;
801051dc:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptables[owner_cpu].lock);
801051e3:	89 1c 24             	mov    %ebx,(%esp)
801051e6:	e8 15 10 00 00       	call   80106200 <release>
}
801051eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ee:	5b                   	pop    %ebx
801051ef:	5e                   	pop    %esi
801051f0:	5d                   	pop    %ebp
801051f1:	c3                   	ret
    panic("userinit: out of memory?");
801051f2:	83 ec 0c             	sub    $0xc,%esp
801051f5:	68 b5 97 10 80       	push   $0x801097b5
801051fa:	e8 51 b3 ff ff       	call   80100550 <panic>
801051ff:	90                   	nop

80105200 <growproc>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
80105205:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105208:	e8 03 0f 00 00       	call   80106110 <pushcli>
  c = mycpu();
8010520d:	e8 be fd ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
80105212:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105218:	e8 43 0f 00 00       	call   80106160 <popcli>
  sz = curproc->sz;
8010521d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010521f:	85 f6                	test   %esi,%esi
80105221:	7f 1d                	jg     80105240 <growproc+0x40>
  } else if(n < 0){
80105223:	75 3b                	jne    80105260 <growproc+0x60>
  switchuvm(curproc);
80105225:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80105228:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010522a:	53                   	push   %ebx
8010522b:	e8 90 3b 00 00       	call   80108dc0 <switchuvm>
  return 0;
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105238:	5b                   	pop    %ebx
80105239:	5e                   	pop    %esi
8010523a:	5d                   	pop    %ebp
8010523b:	c3                   	ret
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105240:	83 ec 04             	sub    $0x4,%esp
80105243:	01 c6                	add    %eax,%esi
80105245:	56                   	push   %esi
80105246:	50                   	push   %eax
80105247:	ff 73 04             	push   0x4(%ebx)
8010524a:	e8 d1 3d 00 00       	call   80109020 <allocuvm>
8010524f:	83 c4 10             	add    $0x10,%esp
80105252:	85 c0                	test   %eax,%eax
80105254:	75 cf                	jne    80105225 <growproc+0x25>
      return -1;
80105256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525b:	eb d8                	jmp    80105235 <growproc+0x35>
8010525d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105260:	83 ec 04             	sub    $0x4,%esp
80105263:	01 c6                	add    %eax,%esi
80105265:	56                   	push   %esi
80105266:	50                   	push   %eax
80105267:	ff 73 04             	push   0x4(%ebx)
8010526a:	e8 d1 3e 00 00       	call   80109140 <deallocuvm>
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	85 c0                	test   %eax,%eax
80105274:	75 af                	jne    80105225 <growproc+0x25>
80105276:	eb de                	jmp    80105256 <growproc+0x56>
80105278:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010527f:	00 

80105280 <fork>:
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
80105286:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80105289:	e8 82 0e 00 00       	call   80106110 <pushcli>
  c = mycpu();
8010528e:	e8 3d fd ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
80105293:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105299:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
8010529c:	e8 bf 0e 00 00       	call   80106160 <popcli>
  if((np = allocproc()) == 0){
801052a1:	e8 2a fb ff ff       	call   80104dd0 <allocproc>
801052a6:	85 c0                	test   %eax,%eax
801052a8:	0f 84 5c 01 00 00    	je     8010540a <fork+0x18a>
  np->priority = curproc->priority;
801052ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052b1:	89 c3                	mov    %eax,%ebx
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801052b3:	83 ec 08             	sub    $0x8,%esp
  np->priority = curproc->priority;
801052b6:	8b 42 7c             	mov    0x7c(%edx),%eax
801052b9:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801052bc:	ff 32                	push   (%edx)
801052be:	ff 72 04             	push   0x4(%edx)
801052c1:	e8 1a 40 00 00       	call   801092e0 <copyuvm>
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052cc:	85 c0                	test   %eax,%eax
801052ce:	89 43 04             	mov    %eax,0x4(%ebx)
801052d1:	0f 84 e1 00 00 00    	je     801053b8 <fork+0x138>
  np->sz = curproc->sz;
801052d7:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
801052d9:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
801052dc:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
801052df:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801052e4:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
801052e6:	8b 72 18             	mov    0x18(%edx),%esi
801052e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801052eb:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801052ed:	8b 43 18             	mov    0x18(%ebx),%eax
801052f0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801052f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052fe:	00 
801052ff:	90                   	nop
    if(curproc->ofile[i])
80105300:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80105304:	85 c0                	test   %eax,%eax
80105306:	74 16                	je     8010531e <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010530e:	50                   	push   %eax
8010530f:	e8 4c d1 ff ff       	call   80102460 <filedup>
80105314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105317:	83 c4 10             	add    $0x10,%esp
8010531a:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010531e:	83 c6 01             	add    $0x1,%esi
80105321:	83 fe 10             	cmp    $0x10,%esi
80105324:	75 da                	jne    80105300 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80105326:	83 ec 0c             	sub    $0xc,%esp
80105329:	ff 72 68             	push   0x68(%edx)
8010532c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010532f:	e8 dc d9 ff ff       	call   80102d10 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105334:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105337:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010533a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010533d:	6a 10                	push   $0x10
8010533f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105342:	83 c2 6c             	add    $0x6c,%edx
80105345:	52                   	push   %edx
80105346:	50                   	push   %eax
80105347:	e8 c4 11 00 00       	call   80106510 <safestrcpy>
  pid = np->pid;
8010534c:	8b 7b 10             	mov    0x10(%ebx),%edi
  for(i = 0; i < NCPU; i++){
8010534f:	b8 74 50 11 80       	mov    $0x80115074,%eax
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010535e:	00 
8010535f:	90                   	nop
    if(p >= ptables[i].proc && p < ptables[i].proc + NPROC_PER_CPU)
80105360:	39 c3                	cmp    %eax,%ebx
80105362:	72 0a                	jb     8010536e <fork+0xee>
80105364:	8d 90 60 04 00 00    	lea    0x460(%eax),%edx
8010536a:	39 d3                	cmp    %edx,%ebx
8010536c:	72 22                	jb     80105390 <fork+0x110>
  for(i = 0; i < NCPU; i++){
8010536e:	05 94 04 00 00       	add    $0x494,%eax
80105373:	3d 14 75 11 80       	cmp    $0x80117514,%eax
80105378:	75 e6                	jne    80105360 <fork+0xe0>
  panic("get_proc_cpuid: process not in any queue");
8010537a:	83 ec 0c             	sub    $0xc,%esp
8010537d:	68 04 9c 10 80       	push   $0x80109c04
80105382:	e8 c9 b1 ff ff       	call   80100550 <panic>
80105387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010538e:	00 
8010538f:	90                   	nop
  acquire(&ptables[np_cpu].lock);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	8d 70 cc             	lea    -0x34(%eax),%esi
80105396:	56                   	push   %esi
80105397:	e8 c4 0e 00 00       	call   80106260 <acquire>
  np->state = RUNNABLE;
8010539c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptables[np_cpu].lock);
801053a3:	89 34 24             	mov    %esi,(%esp)
801053a6:	e8 55 0e 00 00       	call   80106200 <release>
  return pid;
801053ab:	83 c4 10             	add    $0x10,%esp
}
801053ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b1:	89 f8                	mov    %edi,%eax
801053b3:	5b                   	pop    %ebx
801053b4:	5e                   	pop    %esi
801053b5:	5f                   	pop    %edi
801053b6:	5d                   	pop    %ebp
801053b7:	c3                   	ret
    kfree(np->kstack);
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	ff 73 08             	push   0x8(%ebx)
801053be:	e8 7d e6 ff ff       	call   80103a40 <kfree>
    np->kstack = 0;
801053c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  for(i = 0; i < NCPU; i++){
801053ca:	b8 74 50 11 80       	mov    $0x80115074,%eax
801053cf:	83 c4 10             	add    $0x10,%esp
    if(p >= ptables[i].proc && p < ptables[i].proc + NPROC_PER_CPU)
801053d2:	39 c3                	cmp    %eax,%ebx
801053d4:	72 0a                	jb     801053e0 <fork+0x160>
801053d6:	8d 90 60 04 00 00    	lea    0x460(%eax),%edx
801053dc:	39 d3                	cmp    %edx,%ebx
801053de:	72 0e                	jb     801053ee <fork+0x16e>
  for(i = 0; i < NCPU; i++){
801053e0:	05 94 04 00 00       	add    $0x494,%eax
801053e5:	3d 14 75 11 80       	cmp    $0x80117514,%eax
801053ea:	75 e6                	jne    801053d2 <fork+0x152>
801053ec:	eb 8c                	jmp    8010537a <fork+0xfa>
    acquire(&ptables[np_cpu].lock);
801053ee:	83 ec 0c             	sub    $0xc,%esp
801053f1:	8d 70 cc             	lea    -0x34(%eax),%esi
801053f4:	56                   	push   %esi
801053f5:	e8 66 0e 00 00       	call   80106260 <acquire>
    np->state = UNUSED;
801053fa:	31 c0                	xor    %eax,%eax
801053fc:	89 43 0c             	mov    %eax,0xc(%ebx)
    release(&ptables[np_cpu].lock);
801053ff:	89 34 24             	mov    %esi,(%esp)
80105402:	e8 f9 0d 00 00       	call   80106200 <release>
    return -1;
80105407:	83 c4 10             	add    $0x10,%esp
    return -1;
8010540a:	83 cf ff             	or     $0xffffffff,%edi
8010540d:	eb 9f                	jmp    801053ae <fork+0x12e>
8010540f:	90                   	nop

80105410 <scheduler>:
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
80105416:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80105419:	e8 b2 fb ff ff       	call   80104fd0 <mycpu>
  c->proc = 0;
8010541e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105425:	00 00 00 
  struct cpu *c = mycpu();
80105428:	89 c2                	mov    %eax,%edx
  if (c->apicid % 2 == 0)
8010542a:	0f b6 00             	movzbl (%eax),%eax
8010542d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  return mycpu()-cpus;
80105430:	83 e0 01             	and    $0x1,%eax
80105433:	89 82 b0 00 00 00    	mov    %eax,0xb0(%edx)
80105439:	e8 92 fb ff ff       	call   80104fd0 <mycpu>
  struct cpu_queue *pq = &ptables[id];
8010543e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  return mycpu()-cpus;
80105441:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
80105446:	89 c3                	mov    %eax,%ebx
80105448:	89 d7                	mov    %edx,%edi
8010544a:	c1 fb 02             	sar    $0x2,%ebx
8010544d:	69 db 64 9f f4 49    	imul   $0x49f49f64,%ebx,%ebx
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105453:	8d 83 74 50 11 80    	lea    -0x7feeaf8c(%ebx),%eax
    acquire(&pq->lock);
80105459:	8d b3 40 50 11 80    	lea    -0x7feeafc0(%ebx),%esi
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
8010545f:	81 c3 d4 54 11 80    	add    $0x801154d4,%ebx
80105465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105468:	8d 42 04             	lea    0x4(%edx),%eax
8010546b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010546e:	eb 64                	jmp    801054d4 <scheduler+0xc4>
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105470:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105473:	39 d9                	cmp    %ebx,%ecx
80105475:	73 51                	jae    801054c8 <scheduler+0xb8>
80105477:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010547a:	89 de                	mov    %ebx,%esi
8010547c:	89 cb                	mov    %ecx,%ebx
        if(p->state != RUNNABLE)
8010547e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80105482:	75 35                	jne    801054b9 <scheduler+0xa9>
        switchuvm(p);
80105484:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80105487:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
        switchuvm(p);
8010548d:	53                   	push   %ebx
8010548e:	e8 2d 39 00 00       	call   80108dc0 <switchuvm>
        p->state = RUNNING;
80105493:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
8010549a:	58                   	pop    %eax
8010549b:	5a                   	pop    %edx
8010549c:	ff 73 1c             	push   0x1c(%ebx)
8010549f:	ff 75 dc             	push   -0x24(%ebp)
801054a2:	e8 c4 10 00 00       	call   8010656b <swtch>
        switchkvm();
801054a7:	e8 04 39 00 00       	call   80108db0 <switchkvm>
        c->proc = 0;
801054ac:	83 c4 10             	add    $0x10,%esp
801054af:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801054b6:	00 00 00 
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
801054b9:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801054bf:	39 f3                	cmp    %esi,%ebx
801054c1:	72 bb                	jb     8010547e <scheduler+0x6e>
801054c3:	89 f3                	mov    %esi,%ebx
801054c5:	8b 75 e0             	mov    -0x20(%ebp),%esi
    release(&pq->lock);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	56                   	push   %esi
801054cc:	e8 2f 0d 00 00       	call   80106200 <release>
    sti();
801054d1:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801054d4:	fb                   	sti
    acquire(&pq->lock);
801054d5:	83 ec 0c             	sub    $0xc,%esp
801054d8:	56                   	push   %esi
801054d9:	e8 82 0d 00 00       	call   80106260 <acquire>
    if (c->core_type == 0) {
801054de:	8b 8f b0 00 00 00    	mov    0xb0(%edi),%ecx
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c9                	test   %ecx,%ecx
801054e9:	74 85                	je     80105470 <scheduler+0x60>
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
801054eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801054ee:	39 d8                	cmp    %ebx,%eax
801054f0:	73 d6                	jae    801054c8 <scheduler+0xb8>
      struct proc *best = 0;
801054f2:	31 d2                	xor    %edx,%edx
801054f4:	eb 15                	jmp    8010550b <scheduler+0xfb>
801054f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054fd:	00 
801054fe:	66 90                	xchg   %ax,%ax
          best = p;
80105500:	89 c2                	mov    %eax,%edx
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105502:	05 8c 00 00 00       	add    $0x8c,%eax
80105507:	39 d8                	cmp    %ebx,%eax
80105509:	73 55                	jae    80105560 <scheduler+0x150>
        if(p->state != RUNNABLE)
8010550b:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010550f:	75 f1                	jne    80105502 <scheduler+0xf2>
        if(best == 0 || p->creation_time < best->creation_time)
80105511:	85 d2                	test   %edx,%edx
80105513:	74 eb                	je     80105500 <scheduler+0xf0>
80105515:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
8010551b:	39 88 88 00 00 00    	cmp    %ecx,0x88(%eax)
80105521:	73 22                	jae    80105545 <scheduler+0x135>
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105523:	8d 88 8c 00 00 00    	lea    0x8c(%eax),%ecx
          best = p;
80105529:	89 c2                	mov    %eax,%edx
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
8010552b:	39 d9                	cmp    %ebx,%ecx
8010552d:	73 39                	jae    80105568 <scheduler+0x158>
        if(p->state != RUNNABLE)
8010552f:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105533:	89 c8                	mov    %ecx,%eax
        if(p->state != RUNNABLE)
80105535:	75 cb                	jne    80105502 <scheduler+0xf2>
        if(best == 0 || p->creation_time < best->creation_time)
80105537:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
8010553d:	39 88 88 00 00 00    	cmp    %ecx,0x88(%eax)
80105543:	72 de                	jb     80105523 <scheduler+0x113>
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105545:	05 8c 00 00 00       	add    $0x8c,%eax
8010554a:	39 d8                	cmp    %ebx,%eax
8010554c:	73 12                	jae    80105560 <scheduler+0x150>
        if(p->state != RUNNABLE)
8010554e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105552:	74 c1                	je     80105515 <scheduler+0x105>
      for(p = pq->proc; p < &pq->proc[NPROC_PER_CPU]; p++){
80105554:	05 8c 00 00 00       	add    $0x8c,%eax
80105559:	39 d8                	cmp    %ebx,%eax
8010555b:	72 ae                	jb     8010550b <scheduler+0xfb>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
      if(best != 0){
80105560:	85 d2                	test   %edx,%edx
80105562:	0f 84 60 ff ff ff    	je     801054c8 <scheduler+0xb8>
        switchuvm(best);
80105568:	83 ec 0c             	sub    $0xc,%esp
        c->proc = best;
8010556b:	89 97 ac 00 00 00    	mov    %edx,0xac(%edi)
        switchuvm(best);
80105571:	52                   	push   %edx
80105572:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105575:	e8 46 38 00 00       	call   80108dc0 <switchuvm>
        best->state = RUNNING;
8010557a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010557d:	c7 42 0c 04 00 00 00 	movl   $0x4,0xc(%edx)
        swtch(&(c->scheduler), best->context);
80105584:	58                   	pop    %eax
80105585:	59                   	pop    %ecx
80105586:	ff 72 1c             	push   0x1c(%edx)
80105589:	ff 75 dc             	push   -0x24(%ebp)
8010558c:	e8 da 0f 00 00       	call   8010656b <swtch>
        switchkvm();
80105591:	e8 1a 38 00 00       	call   80108db0 <switchkvm>
        c->proc = 0;
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801055a0:	00 00 00 
801055a3:	e9 20 ff ff ff       	jmp    801054c8 <scheduler+0xb8>
801055a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055af:	00 

801055b0 <sched>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
  pushcli();
801055b5:	e8 56 0b 00 00       	call   80106110 <pushcli>
  c = mycpu();
801055ba:	e8 11 fa ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
801055bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801055c5:	e8 96 0b 00 00       	call   80106160 <popcli>
  return mycpu()-cpus;
801055ca:	e8 01 fa ff ff       	call   80104fd0 <mycpu>
  if(!holding(&ptables[id].lock))
801055cf:	83 ec 0c             	sub    $0xc,%esp
  return mycpu()-cpus;
801055d2:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
801055d7:	c1 f8 02             	sar    $0x2,%eax
  if(!holding(&ptables[id].lock))
801055da:	69 c0 64 9f f4 49    	imul   $0x49f49f64,%eax,%eax
801055e0:	05 40 50 11 80       	add    $0x80115040,%eax
801055e5:	50                   	push   %eax
801055e6:	e8 d5 0b 00 00       	call   801061c0 <holding>
801055eb:	83 c4 10             	add    $0x10,%esp
801055ee:	85 c0                	test   %eax,%eax
801055f0:	74 4f                	je     80105641 <sched+0x91>
  if(mycpu()->ncli != 1)
801055f2:	e8 d9 f9 ff ff       	call   80104fd0 <mycpu>
801055f7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801055fe:	75 68                	jne    80105668 <sched+0xb8>
  if(p->state == RUNNING)
80105600:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105604:	74 55                	je     8010565b <sched+0xab>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105606:	9c                   	pushf
80105607:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105608:	f6 c4 02             	test   $0x2,%ah
8010560b:	75 41                	jne    8010564e <sched+0x9e>
  intena = mycpu()->intena;
8010560d:	e8 be f9 ff ff       	call   80104fd0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80105612:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105615:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010561b:	e8 b0 f9 ff ff       	call   80104fd0 <mycpu>
80105620:	83 ec 08             	sub    $0x8,%esp
80105623:	ff 70 04             	push   0x4(%eax)
80105626:	53                   	push   %ebx
80105627:	e8 3f 0f 00 00       	call   8010656b <swtch>
  mycpu()->intena = intena;
8010562c:	e8 9f f9 ff ff       	call   80104fd0 <mycpu>
}
80105631:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105634:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010563a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010563d:	5b                   	pop    %ebx
8010563e:	5e                   	pop    %esi
8010563f:	5d                   	pop    %ebp
80105640:	c3                   	ret
    panic("sched ptable.lock");
80105641:	83 ec 0c             	sub    $0xc,%esp
80105644:	68 d9 97 10 80       	push   $0x801097d9
80105649:	e8 02 af ff ff       	call   80100550 <panic>
    panic("sched interruptible");
8010564e:	83 ec 0c             	sub    $0xc,%esp
80105651:	68 05 98 10 80       	push   $0x80109805
80105656:	e8 f5 ae ff ff       	call   80100550 <panic>
    panic("sched running");
8010565b:	83 ec 0c             	sub    $0xc,%esp
8010565e:	68 f7 97 10 80       	push   $0x801097f7
80105663:	e8 e8 ae ff ff       	call   80100550 <panic>
    panic("sched locks");
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	68 eb 97 10 80       	push   $0x801097eb
80105670:	e8 db ae ff ff       	call   80100550 <panic>
80105675:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010567c:	00 
8010567d:	8d 76 00             	lea    0x0(%esi),%esi

80105680 <exit>:
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	57                   	push   %edi
80105684:	56                   	push   %esi
80105685:	53                   	push   %ebx
80105686:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80105689:	e8 22 fa ff ff       	call   801050b0 <myproc>
  if(curproc == initproc)
8010568e:	39 05 e0 74 11 80    	cmp    %eax,0x801174e0
80105694:	0f 84 22 01 00 00    	je     801057bc <exit+0x13c>
8010569a:	89 c7                	mov    %eax,%edi
8010569c:	8d 58 28             	lea    0x28(%eax),%ebx
8010569f:	8d 70 68             	lea    0x68(%eax),%esi
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801056a8:	8b 03                	mov    (%ebx),%eax
801056aa:	85 c0                	test   %eax,%eax
801056ac:	74 12                	je     801056c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801056ae:	83 ec 0c             	sub    $0xc,%esp
801056b1:	50                   	push   %eax
801056b2:	e8 f9 cd ff ff       	call   801024b0 <fileclose>
      curproc->ofile[fd] = 0;
801056b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801056bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c3 04             	add    $0x4,%ebx
801056c3:	39 f3                	cmp    %esi,%ebx
801056c5:	75 e1                	jne    801056a8 <exit+0x28>
  begin_op();
801056c7:	e8 14 ec ff ff       	call   801042e0 <begin_op>
  iput(curproc->cwd);
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	ff 77 68             	push   0x68(%edi)
801056d2:	be d4 54 11 80       	mov    $0x801154d4,%esi
801056d7:	e8 94 d7 ff ff       	call   80102e70 <iput>
  end_op();
801056dc:	e8 6f ec ff ff       	call   80104350 <end_op>
  curproc->cwd = 0;
801056e1:	c7 47 68 00 00 00 00 	movl   $0x0,0x68(%edi)
  wakeup1(curproc->parent);
801056e8:	8b 47 14             	mov    0x14(%edi),%eax
801056eb:	e8 50 f6 ff ff       	call   80104d40 <wakeup1>
  for(i = 0; i < NCPU; i++) {
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    acquire(&ptables[i].lock);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	8d 96 6c fb ff ff    	lea    -0x494(%esi),%edx
    for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
80105701:	8d 9e a0 fb ff ff    	lea    -0x460(%esi),%ebx
    acquire(&ptables[i].lock);
80105707:	52                   	push   %edx
80105708:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010570b:	e8 50 0b 00 00       	call   80106260 <acquire>
    for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	81 fe 5f 04 00 00    	cmp    $0x45f,%esi
80105719:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010571c:	77 0c                	ja     8010572a <exit+0xaa>
8010571e:	eb 38                	jmp    80105758 <exit+0xd8>
80105720:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105726:	39 f3                	cmp    %esi,%ebx
80105728:	73 2e                	jae    80105758 <exit+0xd8>
      if(p->parent == curproc){
8010572a:	39 7b 14             	cmp    %edi,0x14(%ebx)
8010572d:	75 f1                	jne    80105720 <exit+0xa0>
        p->parent = initproc;
8010572f:	a1 e0 74 11 80       	mov    0x801174e0,%eax
        if(p->state == ZOMBIE)
80105734:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
        p->parent = initproc;
80105738:	89 43 14             	mov    %eax,0x14(%ebx)
        if(p->state == ZOMBIE)
8010573b:	75 e3                	jne    80105720 <exit+0xa0>
    for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
8010573d:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105743:	89 55 e4             	mov    %edx,-0x1c(%ebp)
          wakeup1(initproc);
80105746:	e8 f5 f5 ff ff       	call   80104d40 <wakeup1>
8010574b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
8010574e:	39 f3                	cmp    %esi,%ebx
80105750:	72 d8                	jb     8010572a <exit+0xaa>
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptables[i].lock);
80105758:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
8010575b:	81 c6 94 04 00 00    	add    $0x494,%esi
    release(&ptables[i].lock);
80105761:	52                   	push   %edx
80105762:	e8 99 0a 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80105767:	83 c4 10             	add    $0x10,%esp
8010576a:	81 fe 74 79 11 80    	cmp    $0x80117974,%esi
80105770:	75 86                	jne    801056f8 <exit+0x78>
  if(is_measuring_throughput){
80105772:	a1 e8 4f 11 80       	mov    0x80114fe8,%eax
80105777:	85 c0                	test   %eax,%eax
80105779:	74 0d                	je     80105788 <exit+0x108>
    if(curproc->pid > 2)
8010577b:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010577f:	7e 07                	jle    80105788 <exit+0x108>
      throughput_finished_procs++;
80105781:	83 05 e0 4f 11 80 01 	addl   $0x1,0x80114fe0
  int my_cpu_id = get_proc_cpuid(curproc);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	57                   	push   %edi
8010578c:	e8 ef f7 ff ff       	call   80104f80 <get_proc_cpuid>
  acquire(&ptables[my_cpu_id].lock);
80105791:	69 c0 94 04 00 00    	imul   $0x494,%eax,%eax
80105797:	05 40 50 11 80       	add    $0x80115040,%eax
8010579c:	89 04 24             	mov    %eax,(%esp)
8010579f:	e8 bc 0a 00 00       	call   80106260 <acquire>
  curproc->state = ZOMBIE;
801057a4:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
  sched();
801057ab:	e8 00 fe ff ff       	call   801055b0 <sched>
  panic("zombie exit");
801057b0:	c7 04 24 26 98 10 80 	movl   $0x80109826,(%esp)
801057b7:	e8 94 ad ff ff       	call   80100550 <panic>
    panic("init exiting");
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	68 19 98 10 80       	push   $0x80109819
801057c4:	e8 87 ad ff ff       	call   80100550 <panic>
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057d0 <yield>:
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
  return mycpu()-cpus;
801057d5:	e8 f6 f7 ff ff       	call   80104fd0 <mycpu>
  acquire(&ptables[id].lock);  //DOC: yieldlock
801057da:	83 ec 0c             	sub    $0xc,%esp
  return mycpu()-cpus;
801057dd:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
801057e2:	89 c3                	mov    %eax,%ebx
801057e4:	c1 fb 02             	sar    $0x2,%ebx
  acquire(&ptables[id].lock);  //DOC: yieldlock
801057e7:	69 db 64 9f f4 49    	imul   $0x49f49f64,%ebx,%ebx
801057ed:	81 c3 40 50 11 80    	add    $0x80115040,%ebx
801057f3:	53                   	push   %ebx
801057f4:	e8 67 0a 00 00       	call   80106260 <acquire>
  pushcli();
801057f9:	e8 12 09 00 00       	call   80106110 <pushcli>
  c = mycpu();
801057fe:	e8 cd f7 ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
80105803:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105809:	e8 52 09 00 00       	call   80106160 <popcli>
  myproc()->state = RUNNABLE;
8010580e:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  sched();
80105815:	e8 96 fd ff ff       	call   801055b0 <sched>
  release(&ptables[id].lock);
8010581a:	89 1c 24             	mov    %ebx,(%esp)
8010581d:	e8 de 09 00 00       	call   80106200 <release>
}
80105822:	83 c4 10             	add    $0x10,%esp
80105825:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105828:	5b                   	pop    %ebx
80105829:	5e                   	pop    %esi
8010582a:	5d                   	pop    %ebp
8010582b:	c3                   	ret
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105830 <sleep>:
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	83 ec 1c             	sub    $0x1c,%esp
80105839:	8b 7d 08             	mov    0x8(%ebp),%edi
8010583c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010583f:	e8 cc 08 00 00       	call   80106110 <pushcli>
  c = mycpu();
80105844:	e8 87 f7 ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
80105849:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010584f:	e8 0c 09 00 00       	call   80106160 <popcli>
  return mycpu()-cpus;
80105854:	e8 77 f7 ff ff       	call   80104fd0 <mycpu>
80105859:	2d 40 4a 11 80       	sub    $0x80114a40,%eax
8010585e:	c1 f8 02             	sar    $0x2,%eax
  struct spinlock *pt_lock = &ptables[id].lock;
80105861:	69 c0 64 9f f4 49    	imul   $0x49f49f64,%eax,%eax
80105867:	05 40 50 11 80       	add    $0x80115040,%eax
  if(p == 0)
8010586c:	85 db                	test   %ebx,%ebx
8010586e:	74 7b                	je     801058eb <sleep+0xbb>
  if(lk == 0)
80105870:	85 f6                	test   %esi,%esi
80105872:	74 6a                	je     801058de <sleep+0xae>
  if(lk != pt_lock){  //DOC: sleeplock0
80105874:	39 f0                	cmp    %esi,%eax
80105876:	74 48                	je     801058c0 <sleep+0x90>
    acquire(pt_lock);  //DOC: sleeplock1
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	50                   	push   %eax
8010587c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010587f:	e8 dc 09 00 00       	call   80106260 <acquire>
    release(lk);
80105884:	89 34 24             	mov    %esi,(%esp)
80105887:	e8 74 09 00 00       	call   80106200 <release>
  p->chan = chan;
8010588c:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010588f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105896:	e8 15 fd ff ff       	call   801055b0 <sched>
    release(pt_lock);
8010589b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  p->chan = 0;
8010589e:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(pt_lock);
801058a5:	89 04 24             	mov    %eax,(%esp)
801058a8:	e8 53 09 00 00       	call   80106200 <release>
    acquire(lk);
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	89 75 08             	mov    %esi,0x8(%ebp)
}
801058b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b6:	5b                   	pop    %ebx
801058b7:	5e                   	pop    %esi
801058b8:	5f                   	pop    %edi
801058b9:	5d                   	pop    %ebp
    acquire(lk);
801058ba:	e9 a1 09 00 00       	jmp    80106260 <acquire>
801058bf:	90                   	nop
  p->chan = chan;
801058c0:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801058c3:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801058ca:	e8 e1 fc ff ff       	call   801055b0 <sched>
  p->chan = 0;
801058cf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801058d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058d9:	5b                   	pop    %ebx
801058da:	5e                   	pop    %esi
801058db:	5f                   	pop    %edi
801058dc:	5d                   	pop    %ebp
801058dd:	c3                   	ret
    panic("sleep without lk");
801058de:	83 ec 0c             	sub    $0xc,%esp
801058e1:	68 38 98 10 80       	push   $0x80109838
801058e6:	e8 65 ac ff ff       	call   80100550 <panic>
    panic("sleep");
801058eb:	83 ec 0c             	sub    $0xc,%esp
801058ee:	68 32 98 10 80       	push   $0x80109832
801058f3:	e8 58 ac ff ff       	call   80100550 <panic>
801058f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ff:	00 

80105900 <wait>:
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
80105905:	53                   	push   %ebx
80105906:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80105909:	e8 02 08 00 00       	call   80106110 <pushcli>
  c = mycpu();
8010590e:	e8 bd f6 ff ff       	call   80104fd0 <mycpu>
  p = c->proc;
80105913:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80105919:	e8 42 08 00 00       	call   80106160 <popcli>
  for(i = 0; i < NCPU; i++){
8010591e:	b8 74 50 11 80       	mov    $0x80115074,%eax
80105923:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p >= ptables[i].proc && p < ptables[i].proc + NPROC_PER_CPU)
80105928:	39 c7                	cmp    %eax,%edi
8010592a:	72 0a                	jb     80105936 <wait+0x36>
8010592c:	8d 90 60 04 00 00    	lea    0x460(%eax),%edx
80105932:	39 d7                	cmp    %edx,%edi
80105934:	72 1a                	jb     80105950 <wait+0x50>
  for(i = 0; i < NCPU; i++){
80105936:	05 94 04 00 00       	add    $0x494,%eax
8010593b:	3d 14 75 11 80       	cmp    $0x80117514,%eax
80105940:	75 e6                	jne    80105928 <wait+0x28>
  panic("get_proc_cpuid: process not in any queue");
80105942:	83 ec 0c             	sub    $0xc,%esp
80105945:	68 04 9c 10 80       	push   $0x80109c04
8010594a:	e8 01 ac ff ff       	call   80100550 <panic>
8010594f:	90                   	nop
  acquire(&ptables[my_cpu_id].lock);
80105950:	83 e8 34             	sub    $0x34,%eax
80105953:	83 ec 0c             	sub    $0xc,%esp
80105956:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105959:	50                   	push   %eax
8010595a:	e8 01 09 00 00       	call   80106260 <acquire>
8010595f:	83 c4 10             	add    $0x10,%esp
    release(&ptables[my_cpu_id].lock);
80105962:	83 ec 0c             	sub    $0xc,%esp
80105965:	ff 75 dc             	push   -0x24(%ebp)
    havekids = 0;
80105968:	31 f6                	xor    %esi,%esi
    release(&ptables[my_cpu_id].lock);
8010596a:	e8 91 08 00 00       	call   80106200 <release>
    for(i = 0; i < NCPU; i++) {
8010596f:	b8 d4 54 11 80       	mov    $0x801154d4,%eax
80105974:	83 c4 10             	add    $0x10,%esp
        acquire(&ptables[i].lock);
80105977:	8d 90 6c fb ff ff    	lea    -0x494(%eax),%edx
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105983:	52                   	push   %edx
80105984:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105987:	e8 d4 08 00 00       	call   80106260 <acquire>
        for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
8010598c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105995:	3d 5f 04 00 00       	cmp    $0x45f,%eax
8010599a:	8d 98 a0 fb ff ff    	lea    -0x460(%eax),%ebx
801059a0:	77 10                	ja     801059b2 <wait+0xb2>
801059a2:	eb 28                	jmp    801059cc <wait+0xcc>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059a8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801059ae:	39 c3                	cmp    %eax,%ebx
801059b0:	73 1a                	jae    801059cc <wait+0xcc>
          if(p->parent != curproc)
801059b2:	39 7b 14             	cmp    %edi,0x14(%ebx)
801059b5:	75 f1                	jne    801059a8 <wait+0xa8>
          if(p->state == ZOMBIE){
801059b7:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801059bb:	74 63                	je     80105a20 <wait+0x120>
        for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
801059bd:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
          havekids = 1;
801059c3:	be 01 00 00 00       	mov    $0x1,%esi
        for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
801059c8:	39 c3                	cmp    %eax,%ebx
801059ca:	72 e6                	jb     801059b2 <wait+0xb2>
        release(&ptables[i].lock);
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801059d2:	52                   	push   %edx
801059d3:	e8 28 08 00 00       	call   80106200 <release>
    for(i = 0; i < NCPU; i++) {
801059d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	05 94 04 00 00       	add    $0x494,%eax
801059e3:	3d 74 79 11 80       	cmp    $0x80117974,%eax
801059e8:	75 8d                	jne    80105977 <wait+0x77>
    acquire(&ptables[my_cpu_id].lock);
801059ea:	83 ec 0c             	sub    $0xc,%esp
801059ed:	ff 75 dc             	push   -0x24(%ebp)
801059f0:	e8 6b 08 00 00       	call   80106260 <acquire>
    if(!havekids || curproc->killed){
801059f5:	83 c4 10             	add    $0x10,%esp
801059f8:	85 f6                	test   %esi,%esi
801059fa:	74 7d                	je     80105a79 <wait+0x179>
801059fc:	8b 47 24             	mov    0x24(%edi),%eax
801059ff:	85 c0                	test   %eax,%eax
80105a01:	75 76                	jne    80105a79 <wait+0x179>
    sleep(curproc, &ptables[my_cpu_id].lock);  //DOC: wait-sleep
80105a03:	83 ec 08             	sub    $0x8,%esp
80105a06:	ff 75 dc             	push   -0x24(%ebp)
80105a09:	57                   	push   %edi
80105a0a:	e8 21 fe ff ff       	call   80105830 <sleep>
    havekids = 0;
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	e9 4b ff ff ff       	jmp    80105962 <wait+0x62>
80105a17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1e:	00 
80105a1f:	90                   	nop
            kfree(p->kstack);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            pid = p->pid;
80105a26:	8b 73 10             	mov    0x10(%ebx),%esi
            kfree(p->kstack);
80105a29:	ff 73 08             	push   0x8(%ebx)
80105a2c:	e8 0f e0 ff ff       	call   80103a40 <kfree>
            p->kstack = 0;
80105a31:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
            freevm(p->pgdir);
80105a38:	5a                   	pop    %edx
80105a39:	ff 73 04             	push   0x4(%ebx)
80105a3c:	e8 2f 37 00 00       	call   80109170 <freevm>
            release(&ptables[i].lock);
80105a41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            p->pid = 0;
80105a44:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            p->parent = 0;
80105a4b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
            p->name[0] = 0;
80105a52:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
            p->killed = 0;
80105a56:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
            p->state = UNUSED;
80105a5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
            release(&ptables[i].lock);
80105a64:	89 14 24             	mov    %edx,(%esp)
80105a67:	e8 94 07 00 00       	call   80106200 <release>
            return pid;
80105a6c:	83 c4 10             	add    $0x10,%esp
}
80105a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a72:	89 f0                	mov    %esi,%eax
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	c3                   	ret
      release(&ptables[my_cpu_id].lock);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	ff 75 dc             	push   -0x24(%ebp)
      return -1;
80105a7f:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptables[my_cpu_id].lock);
80105a84:	e8 77 07 00 00       	call   80106200 <release>
      return -1;
80105a89:	83 c4 10             	add    $0x10,%esp
80105a8c:	eb e1                	jmp    80105a6f <wait+0x16f>
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
  // wakeup1 خودش قفل‌گذاری را مدیریت می‌کند
  wakeup1(chan);
80105a93:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105a96:	5d                   	pop    %ebp
  wakeup1(chan);
80105a97:	e9 a4 f2 ff ff       	jmp    80104d40 <wakeup1>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	bb d4 54 11 80       	mov    $0x801154d4,%ebx
80105aab:	83 ec 0c             	sub    $0xc,%esp
80105aae:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  int i;

  // جستجو در تمام صف‌ها
  for(i = 0; i < NCPU; i++) {
      acquire(&ptables[i].lock);
80105ab1:	83 ec 0c             	sub    $0xc,%esp
80105ab4:	8d bb 6c fb ff ff    	lea    -0x494(%ebx),%edi
80105aba:	57                   	push   %edi
80105abb:	e8 a0 07 00 00       	call   80106260 <acquire>
      for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
80105ac0:	8d 83 a0 fb ff ff    	lea    -0x460(%ebx),%eax
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	81 fb 5f 04 00 00    	cmp    $0x45f,%ebx
80105acf:	77 10                	ja     80105ae1 <kill+0x41>
80105ad1:	eb 3d                	jmp    80105b10 <kill+0x70>
80105ad3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ad8:	05 8c 00 00 00       	add    $0x8c,%eax
80105add:	39 d8                	cmp    %ebx,%eax
80105adf:	73 2f                	jae    80105b10 <kill+0x70>
        if(p->pid == pid){
80105ae1:	39 70 10             	cmp    %esi,0x10(%eax)
80105ae4:	75 f2                	jne    80105ad8 <kill+0x38>
          p->killed = 1;
          // Wake process from sleep if necessary.
          if(p->state == SLEEPING)
80105ae6:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
          p->killed = 1;
80105aea:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          if(p->state == SLEEPING)
80105af1:	75 07                	jne    80105afa <kill+0x5a>
            p->state = RUNNABLE;
80105af3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          release(&ptables[i].lock);
80105afa:	83 ec 0c             	sub    $0xc,%esp
80105afd:	57                   	push   %edi
80105afe:	e8 fd 06 00 00       	call   80106200 <release>
          return 0;
80105b03:	83 c4 10             	add    $0x10,%esp
80105b06:	31 c0                	xor    %eax,%eax
        }
      }
      release(&ptables[i].lock);
  }
  return -1;
}
80105b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b0b:	5b                   	pop    %ebx
80105b0c:	5e                   	pop    %esi
80105b0d:	5f                   	pop    %edi
80105b0e:	5d                   	pop    %ebp
80105b0f:	c3                   	ret
      release(&ptables[i].lock);
80105b10:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
80105b13:	81 c3 94 04 00 00    	add    $0x494,%ebx
      release(&ptables[i].lock);
80105b19:	57                   	push   %edi
80105b1a:	e8 e1 06 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80105b1f:	83 c4 10             	add    $0x10,%esp
80105b22:	81 fb 74 79 11 80    	cmp    $0x80117974,%ebx
80105b28:	75 87                	jne    80105ab1 <kill+0x11>
  return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2f:	eb d7                	jmp    80105b08 <kill+0x68>
80105b31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b38:	00 
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b40 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
80105b46:	bb d4 54 11 80       	mov    $0x801154d4,%ebx
80105b4b:	83 ec 3c             	sub    $0x3c,%esp
80105b4e:	66 90                	xchg   %ax,%ax
  struct proc *p;
  char *state;
  uint pc[10];

  for(cpu = 0; cpu < NCPU; cpu++) {
      for(p = ptables[cpu].proc; p < &ptables[cpu].proc[NPROC_PER_CPU]; p++){
80105b50:	8d bb a0 fb ff ff    	lea    -0x460(%ebx),%edi
80105b56:	81 fb 5f 04 00 00    	cmp    $0x45f,%ebx
80105b5c:	76 59                	jbe    80105bb7 <procdump+0x77>
80105b5e:	66 90                	xchg   %ax,%ax
        if(p->state == UNUSED)
80105b60:	8b 57 0c             	mov    0xc(%edi),%edx
80105b63:	85 d2                	test   %edx,%edx
80105b65:	74 46                	je     80105bad <procdump+0x6d>
          continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
          state = states[p->state];
        else
          state = "???";
80105b67:	b9 49 98 10 80       	mov    $0x80109849,%ecx
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105b6c:	83 fa 05             	cmp    $0x5,%edx
80105b6f:	77 11                	ja     80105b82 <procdump+0x42>
80105b71:	8b 0c 95 80 9f 10 80 	mov    -0x7fef6080(,%edx,4),%ecx
          state = "???";
80105b78:	b8 49 98 10 80       	mov    $0x80109849,%eax
80105b7d:	85 c9                	test   %ecx,%ecx
80105b7f:	0f 44 c8             	cmove  %eax,%ecx
        cprintf("%d %s %s", p->pid, state, p->name);
80105b82:	8d 57 6c             	lea    0x6c(%edi),%edx
80105b85:	52                   	push   %edx
80105b86:	51                   	push   %ecx
80105b87:	ff 77 10             	push   0x10(%edi)
80105b8a:	68 4d 98 10 80       	push   $0x8010984d
80105b8f:	e8 cc b1 ff ff       	call   80100d60 <cprintf>
        if(p->state == SLEEPING){
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	83 7f 0c 02          	cmpl   $0x2,0xc(%edi)
80105b9b:	74 33                	je     80105bd0 <procdump+0x90>
          getcallerpcs((uint*)p->context->ebp+2, pc);
          for(i=0; i<10 && pc[i] != 0; i++)
            cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 88 9a 10 80       	push   $0x80109a88
80105ba5:	e8 b6 b1 ff ff       	call   80100d60 <cprintf>
80105baa:	83 c4 10             	add    $0x10,%esp
      for(p = ptables[cpu].proc; p < &ptables[cpu].proc[NPROC_PER_CPU]; p++){
80105bad:	81 c7 8c 00 00 00    	add    $0x8c,%edi
80105bb3:	39 df                	cmp    %ebx,%edi
80105bb5:	72 a9                	jb     80105b60 <procdump+0x20>
  for(cpu = 0; cpu < NCPU; cpu++) {
80105bb7:	81 c3 94 04 00 00    	add    $0x494,%ebx
80105bbd:	81 fb 74 79 11 80    	cmp    $0x80117974,%ebx
80105bc3:	75 8b                	jne    80105b50 <procdump+0x10>
      }
  }
}
80105bc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc8:	5b                   	pop    %ebx
80105bc9:	5e                   	pop    %esi
80105bca:	5f                   	pop    %edi
80105bcb:	5d                   	pop    %ebp
80105bcc:	c3                   	ret
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi
          getcallerpcs((uint*)p->context->ebp+2, pc);
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 75 c0             	lea    -0x40(%ebp),%esi
80105bd6:	56                   	push   %esi
80105bd7:	8b 57 1c             	mov    0x1c(%edi),%edx
80105bda:	8b 52 0c             	mov    0xc(%edx),%edx
80105bdd:	83 c2 08             	add    $0x8,%edx
80105be0:	52                   	push   %edx
80105be1:	e8 aa 04 00 00       	call   80106090 <getcallerpcs>
          for(i=0; i<10 && pc[i] != 0; i++)
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bf0:	8b 0e                	mov    (%esi),%ecx
80105bf2:	85 c9                	test   %ecx,%ecx
80105bf4:	74 a7                	je     80105b9d <procdump+0x5d>
            cprintf(" %p", pc[i]);
80105bf6:	83 ec 08             	sub    $0x8,%esp
          for(i=0; i<10 && pc[i] != 0; i++)
80105bf9:	83 c6 04             	add    $0x4,%esi
            cprintf(" %p", pc[i]);
80105bfc:	51                   	push   %ecx
80105bfd:	68 81 95 10 80       	push   $0x80109581
80105c02:	e8 59 b1 ff ff       	call   80100d60 <cprintf>
          for(i=0; i<10 && pc[i] != 0; i++)
80105c07:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c0a:	83 c4 10             	add    $0x10,%esp
80105c0d:	39 c6                	cmp    %eax,%esi
80105c0f:	75 df                	jne    80105bf0 <procdump+0xb0>
80105c11:	eb 8a                	jmp    80105b9d <procdump+0x5d>
80105c13:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c1a:	00 
80105c1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105c20 <process_family>:

int
process_family(int pid)
{
80105c20:	55                   	push   %ebp
80105c21:	b8 d4 54 11 80       	mov    $0x801154d4,%eax
80105c26:	89 e5                	mov    %esp,%ebp
80105c28:	57                   	push   %edi
80105c29:	56                   	push   %esi
80105c2a:	89 c6                	mov    %eax,%esi
80105c2c:	53                   	push   %ebx
80105c2d:	83 ec 1c             	sub    $0x1c,%esp
80105c30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c33:	8b 7d 08             	mov    0x8(%ebp),%edi
80105c36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c3d:	00 
80105c3e:	66 90                	xchg   %ax,%ax
  struct proc *p, *target=0, *parent =0;
  int i;

  // 1. پیدا کردن پردازه هدف و والدش
  for(i = 0; i < NCPU; i++) {
    acquire(&ptables[i].lock);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	8d 96 6c fb ff ff    	lea    -0x494(%esi),%edx
    for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105c49:	8d 9e a0 fb ff ff    	lea    -0x460(%esi),%ebx
    acquire(&ptables[i].lock);
80105c4f:	52                   	push   %edx
80105c50:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105c53:	e8 08 06 00 00       	call   80106260 <acquire>
    for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105c58:	83 c4 10             	add    $0x10,%esp
80105c5b:	81 fe 5f 04 00 00    	cmp    $0x45f,%esi
80105c61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105c64:	76 20                	jbe    80105c86 <process_family+0x66>
80105c66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c6d:	00 
80105c6e:	66 90                	xchg   %ax,%ax
      if (p->state != UNUSED && p->pid == pid) {
80105c70:	8b 43 0c             	mov    0xc(%ebx),%eax
80105c73:	85 c0                	test   %eax,%eax
80105c75:	74 05                	je     80105c7c <process_family+0x5c>
80105c77:	39 7b 10             	cmp    %edi,0x10(%ebx)
80105c7a:	74 34                	je     80105cb0 <process_family+0x90>
    for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105c7c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105c82:	39 f3                	cmp    %esi,%ebx
80105c84:	72 ea                	jb     80105c70 <process_family+0x50>
        target = p;
        parent = p->parent; // اشاره‌گر به والد (ممکن است در صف دیگری باشد ولی آدرس حافظه معتبر است)
        break;
      }
    }
    release(&ptables[i].lock);
80105c86:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
80105c89:	81 c6 94 04 00 00    	add    $0x494,%esi
    release(&ptables[i].lock);
80105c8f:	52                   	push   %edx
80105c90:	e8 6b 05 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	81 fe 74 79 11 80    	cmp    $0x80117974,%esi
80105c9e:	75 a0                	jne    80105c40 <process_family+0x20>
  }
  if (!have_sib)
    cprintf("No siblings.\n");

  return 0;
}
80105ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1; // pid not found
80105ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ca8:	5b                   	pop    %ebx
80105ca9:	5e                   	pop    %esi
80105caa:	5f                   	pop    %edi
80105cab:	5d                   	pop    %ebp
80105cac:	c3                   	ret
80105cad:	8d 76 00             	lea    0x0(%esi),%esi
        parent = p->parent; // اشاره‌گر به والد (ممکن است در صف دیگری باشد ولی آدرس حافظه معتبر است)
80105cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
    release(&ptables[i].lock);
80105cb3:	83 ec 0c             	sub    $0xc,%esp
        parent = p->parent; // اشاره‌گر به والد (ممکن است در صف دیگری باشد ولی آدرس حافظه معتبر است)
80105cb6:	8b 73 14             	mov    0x14(%ebx),%esi
80105cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    release(&ptables[i].lock);
80105cbc:	52                   	push   %edx
80105cbd:	e8 3e 05 00 00       	call   80106200 <release>
  cprintf("My id: %d, My parent id: %d\n",target->pid, parent ? parent->pid : -1);
80105cc2:	83 c4 10             	add    $0x10,%esp
80105cc5:	85 f6                	test   %esi,%esi
80105cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cca:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105ccf:	74 03                	je     80105cd4 <process_family+0xb4>
80105cd1:	8b 56 10             	mov    0x10(%esi),%edx
80105cd4:	83 ec 04             	sub    $0x4,%esp
80105cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105cda:	52                   	push   %edx
80105cdb:	ff 73 10             	push   0x10(%ebx)
80105cde:	68 56 98 10 80       	push   $0x80109856
80105ce3:	e8 78 b0 ff ff       	call   80100d60 <cprintf>
  cprintf("Children of process %d:\n", target->pid);
80105ce8:	59                   	pop    %ecx
80105ce9:	5f                   	pop    %edi
80105cea:	ff 73 10             	push   0x10(%ebx)
80105ced:	68 73 98 10 80       	push   $0x80109873
80105cf2:	bf d4 54 11 80       	mov    $0x801154d4,%edi
80105cf7:	e8 64 b0 ff ff       	call   80100d60 <cprintf>
  int have_child = 0;
80105cfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cff:	31 c9                	xor    %ecx,%ecx
  cprintf("Children of process %d:\n", target->pid);
80105d01:	83 c4 10             	add    $0x10,%esp
  int have_child = 0;
80105d04:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80105d07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d0a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptables[i].lock);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	8d b7 6c fb ff ff    	lea    -0x494(%edi),%esi
80105d19:	56                   	push   %esi
80105d1a:	e8 41 05 00 00       	call   80106260 <acquire>
    for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105d1f:	8d 87 a0 fb ff ff    	lea    -0x460(%edi),%eax
80105d25:	83 c4 10             	add    $0x10,%esp
80105d28:	81 ff 5f 04 00 00    	cmp    $0x45f,%edi
80105d2e:	76 2f                	jbe    80105d5f <process_family+0x13f>
80105d30:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80105d33:	89 de                	mov    %ebx,%esi
80105d35:	89 c3                	mov    %eax,%ebx
80105d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d3e:	00 
80105d3f:	90                   	nop
      if (p->state != UNUSED && p->parent == target) {
80105d40:	8b 53 0c             	mov    0xc(%ebx),%edx
80105d43:	85 d2                	test   %edx,%edx
80105d45:	74 09                	je     80105d50 <process_family+0x130>
80105d47:	39 73 14             	cmp    %esi,0x14(%ebx)
80105d4a:	0f 84 f0 00 00 00    	je     80105e40 <process_family+0x220>
    for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105d50:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80105d56:	39 fb                	cmp    %edi,%ebx
80105d58:	72 e6                	jb     80105d40 <process_family+0x120>
80105d5a:	89 f3                	mov    %esi,%ebx
80105d5c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    release(&ptables[i].lock);
80105d5f:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
80105d62:	81 c7 94 04 00 00    	add    $0x494,%edi
    release(&ptables[i].lock);
80105d68:	56                   	push   %esi
80105d69:	e8 92 04 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	81 ff 74 79 11 80    	cmp    $0x80117974,%edi
80105d77:	75 97                	jne    80105d10 <process_family+0xf0>
  if (!have_child)
80105d79:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80105d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d7f:	8b 75 d8             	mov    -0x28(%ebp),%esi
80105d82:	85 c9                	test   %ecx,%ecx
80105d84:	0f 84 fb 00 00 00    	je     80105e85 <process_family+0x265>
  cprintf("Siblings of process %d:\n", target->pid);
80105d8a:	83 ec 08             	sub    $0x8,%esp
80105d8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105d90:	ff 73 10             	push   0x10(%ebx)
80105d93:	68 a9 98 10 80       	push   $0x801098a9
80105d98:	e8 c3 af ff ff       	call   80100d60 <cprintf>
  if (parent) {
80105d9d:	83 c4 10             	add    $0x10,%esp
  int have_sib = 0;
80105da0:	31 c9                	xor    %ecx,%ecx
  if (parent) {
80105da2:	85 f6                	test   %esi,%esi
80105da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105da7:	74 73                	je     80105e1c <process_family+0x1fc>
80105da9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80105dac:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80105daf:	89 c3                	mov    %eax,%ebx
80105db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        acquire(&ptables[i].lock);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	8d bb 6c fb ff ff    	lea    -0x494(%ebx),%edi
80105dc1:	57                   	push   %edi
80105dc2:	e8 99 04 00 00       	call   80106260 <acquire>
        for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105dc7:	8d 93 a0 fb ff ff    	lea    -0x460(%ebx),%edx
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	81 fb 5f 04 00 00    	cmp    $0x45f,%ebx
80105dd6:	76 23                	jbe    80105dfb <process_family+0x1db>
80105dd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ddf:	00 
          if (p->state != UNUSED && p->parent == parent && p != target) {
80105de0:	8b 42 0c             	mov    0xc(%edx),%eax
80105de3:	85 c0                	test   %eax,%eax
80105de5:	74 0a                	je     80105df1 <process_family+0x1d1>
80105de7:	39 72 14             	cmp    %esi,0x14(%edx)
80105dea:	75 05                	jne    80105df1 <process_family+0x1d1>
80105dec:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80105def:	75 6f                	jne    80105e60 <process_family+0x240>
        for (p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++) {
80105df1:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80105df7:	39 da                	cmp    %ebx,%edx
80105df9:	72 e5                	jb     80105de0 <process_family+0x1c0>
        release(&ptables[i].lock);
80105dfb:	83 ec 0c             	sub    $0xc,%esp
    for(i = 0; i < NCPU; i++) {
80105dfe:	81 c3 94 04 00 00    	add    $0x494,%ebx
        release(&ptables[i].lock);
80105e04:	57                   	push   %edi
80105e05:	e8 f6 03 00 00       	call   80106200 <release>
    for(i = 0; i < NCPU; i++) {
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	81 fb 74 79 11 80    	cmp    $0x80117974,%ebx
80105e13:	75 a3                	jne    80105db8 <process_family+0x198>
  if (!have_sib)
80105e15:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105e18:	85 c9                	test   %ecx,%ecx
80105e1a:	75 10                	jne    80105e2c <process_family+0x20c>
    cprintf("No siblings.\n");
80105e1c:	83 ec 0c             	sub    $0xc,%esp
80105e1f:	68 c2 98 10 80       	push   $0x801098c2
80105e24:	e8 37 af ff ff       	call   80100d60 <cprintf>
80105e29:	83 c4 10             	add    $0x10,%esp
}
80105e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80105e2f:	31 c0                	xor    %eax,%eax
}
80105e31:	5b                   	pop    %ebx
80105e32:	5e                   	pop    %esi
80105e33:	5f                   	pop    %edi
80105e34:	5d                   	pop    %ebp
80105e35:	c3                   	ret
80105e36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e3d:	00 
80105e3e:	66 90                	xchg   %ax,%ax
        cprintf("Child pid: %d\n", p->pid);
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	ff 73 10             	push   0x10(%ebx)
80105e46:	68 8c 98 10 80       	push   $0x8010988c
80105e4b:	e8 10 af ff ff       	call   80100d60 <cprintf>
80105e50:	83 c4 10             	add    $0x10,%esp
        have_child = 1;
80105e53:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80105e5a:	e9 f1 fe ff ff       	jmp    80105d50 <process_family+0x130>
80105e5f:	90                   	nop
            cprintf("Sibling pid: %d\n", p->pid);
80105e60:	83 ec 08             	sub    $0x8,%esp
80105e63:	ff 72 10             	push   0x10(%edx)
80105e66:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105e69:	68 d0 98 10 80       	push   $0x801098d0
80105e6e:	e8 ed ae ff ff       	call   80100d60 <cprintf>
80105e73:	83 c4 10             	add    $0x10,%esp
            have_sib = 1;
80105e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105e79:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
80105e80:	e9 6c ff ff ff       	jmp    80105df1 <process_family+0x1d1>
    cprintf("No children.\n");
80105e85:	83 ec 0c             	sub    $0xc,%esp
80105e88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e8b:	68 9b 98 10 80       	push   $0x8010989b
80105e90:	e8 cb ae ff ff       	call   80100d60 <cprintf>
80105e95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e98:	83 c4 10             	add    $0x10,%esp
80105e9b:	e9 ea fe ff ff       	jmp    80105d8a <process_family+0x16a>

80105ea0 <set_priority>:

int
set_priority(int pid, int new_priority)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
80105ea6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int old = -1;
  int i;

  if(new_priority > PRIO_MIN || new_priority < PRIO_MAX)
80105ea9:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
{
80105ead:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(new_priority > PRIO_MIN || new_priority < PRIO_MAX)
80105eb0:	77 78                	ja     80105f2a <set_priority+0x8a>
80105eb2:	bb d4 54 11 80       	mov    $0x801154d4,%ebx
    return -1;

  // جستجو در تمام صف‌ها برای پیدا کردن PID
  for(i = 0; i < NCPU; i++) {
      acquire(&ptables[i].lock);
80105eb7:	83 ec 0c             	sub    $0xc,%esp
80105eba:	8d b3 6c fb ff ff    	lea    -0x494(%ebx),%esi
80105ec0:	56                   	push   %esi
80105ec1:	e8 9a 03 00 00       	call   80106260 <acquire>
      for(p = ptables[i].proc; p < &ptables[i].proc[NPROC_PER_CPU]; p++){
80105ec6:	8d 83 a0 fb ff ff    	lea    -0x460(%ebx),%eax
80105ecc:	83 c4 10             	add    $0x10,%esp
80105ecf:	81 fb 5f 04 00 00    	cmp    $0x45f,%ebx
80105ed5:	77 12                	ja     80105ee9 <set_priority+0x49>
80105ed7:	eb 37                	jmp    80105f10 <set_priority+0x70>
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee0:	05 8c 00 00 00       	add    $0x8c,%eax
80105ee5:	39 d8                	cmp    %ebx,%eax
80105ee7:	73 27                	jae    80105f10 <set_priority+0x70>
        if(p->pid == pid){
80105ee9:	39 78 10             	cmp    %edi,0x10(%eax)
80105eec:	75 f2                	jne    80105ee0 <set_priority+0x40>
          old = p->priority;
          p->priority = new_priority;
80105eee:	8b 55 0c             	mov    0xc(%ebp),%edx
          release(&ptables[i].lock);
80105ef1:	83 ec 0c             	sub    $0xc,%esp
          old = p->priority;
80105ef4:	8b 58 7c             	mov    0x7c(%eax),%ebx
          p->priority = new_priority;
80105ef7:	89 50 7c             	mov    %edx,0x7c(%eax)
          release(&ptables[i].lock);
80105efa:	56                   	push   %esi
80105efb:	e8 00 03 00 00       	call   80106200 <release>
          return old;
80105f00:	83 c4 10             	add    $0x10,%esp
        }
      }
      release(&ptables[i].lock);
  }
  return old;
80105f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f06:	89 d8                	mov    %ebx,%eax
80105f08:	5b                   	pop    %ebx
80105f09:	5e                   	pop    %esi
80105f0a:	5f                   	pop    %edi
80105f0b:	5d                   	pop    %ebp
80105f0c:	c3                   	ret
80105f0d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&ptables[i].lock);
80105f10:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NCPU; i++) {
80105f13:	81 c3 94 04 00 00    	add    $0x494,%ebx
      release(&ptables[i].lock);
80105f19:	56                   	push   %esi
80105f1a:	e8 e1 02 00 00       	call   80106200 <release>
  for(i = 0; i < NCPU; i++) {
80105f1f:	83 c4 10             	add    $0x10,%esp
80105f22:	81 fb 74 79 11 80    	cmp    $0x80117974,%ebx
80105f28:	75 8d                	jne    80105eb7 <set_priority+0x17>
80105f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f32:	89 d8                	mov    %ebx,%eax
80105f34:	5b                   	pop    %ebx
80105f35:	5e                   	pop    %esi
80105f36:	5f                   	pop    %edi
80105f37:	5d                   	pop    %ebp
80105f38:	c3                   	ret
80105f39:	66 90                	xchg   %ax,%ax
80105f3b:	66 90                	xchg   %ax,%ax
80105f3d:	66 90                	xchg   %ax,%ax
80105f3f:	90                   	nop

80105f40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
80105f44:	83 ec 0c             	sub    $0xc,%esp
80105f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80105f4a:	68 0b 99 10 80       	push   $0x8010990b
80105f4f:	8d 43 04             	lea    0x4(%ebx),%eax
80105f52:	50                   	push   %eax
80105f53:	e8 18 01 00 00       	call   80106070 <initlock>
  lk->name = name;
80105f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80105f5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105f61:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105f64:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80105f6b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f71:	c9                   	leave
80105f72:	c3                   	ret
80105f73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f7a:	00 
80105f7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105f80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	56                   	push   %esi
80105f84:	53                   	push   %ebx
80105f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105f88:	8d 73 04             	lea    0x4(%ebx),%esi
80105f8b:	83 ec 0c             	sub    $0xc,%esp
80105f8e:	56                   	push   %esi
80105f8f:	e8 cc 02 00 00       	call   80106260 <acquire>
  while (lk->locked) {
80105f94:	8b 13                	mov    (%ebx),%edx
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 d2                	test   %edx,%edx
80105f9b:	74 16                	je     80105fb3 <acquiresleep+0x33>
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105fa0:	83 ec 08             	sub    $0x8,%esp
80105fa3:	56                   	push   %esi
80105fa4:	53                   	push   %ebx
80105fa5:	e8 86 f8 ff ff       	call   80105830 <sleep>
  while (lk->locked) {
80105faa:	8b 03                	mov    (%ebx),%eax
80105fac:	83 c4 10             	add    $0x10,%esp
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	75 ed                	jne    80105fa0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105fb3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105fb9:	e8 f2 f0 ff ff       	call   801050b0 <myproc>
80105fbe:	8b 40 10             	mov    0x10(%eax),%eax
80105fc1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105fc4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105fc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fca:	5b                   	pop    %ebx
80105fcb:	5e                   	pop    %esi
80105fcc:	5d                   	pop    %ebp
  release(&lk->lk);
80105fcd:	e9 2e 02 00 00       	jmp    80106200 <release>
80105fd2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105fd9:	00 
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fe0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	56                   	push   %esi
80105fe4:	53                   	push   %ebx
80105fe5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105fe8:	8d 73 04             	lea    0x4(%ebx),%esi
80105feb:	83 ec 0c             	sub    $0xc,%esp
80105fee:	56                   	push   %esi
80105fef:	e8 6c 02 00 00       	call   80106260 <acquire>
  lk->locked = 0;
80105ff4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80105ffa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80106001:	89 1c 24             	mov    %ebx,(%esp)
80106004:	e8 87 fa ff ff       	call   80105a90 <wakeup>
  release(&lk->lk);
80106009:	83 c4 10             	add    $0x10,%esp
8010600c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010600f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106012:	5b                   	pop    %ebx
80106013:	5e                   	pop    %esi
80106014:	5d                   	pop    %ebp
  release(&lk->lk);
80106015:	e9 e6 01 00 00       	jmp    80106200 <release>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106020 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	57                   	push   %edi
80106024:	31 ff                	xor    %edi,%edi
80106026:	56                   	push   %esi
80106027:	53                   	push   %ebx
80106028:	83 ec 18             	sub    $0x18,%esp
8010602b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010602e:	8d 73 04             	lea    0x4(%ebx),%esi
80106031:	56                   	push   %esi
80106032:	e8 29 02 00 00       	call   80106260 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80106037:	8b 03                	mov    (%ebx),%eax
80106039:	83 c4 10             	add    $0x10,%esp
8010603c:	85 c0                	test   %eax,%eax
8010603e:	75 18                	jne    80106058 <holdingsleep+0x38>
  release(&lk->lk);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	56                   	push   %esi
80106044:	e8 b7 01 00 00       	call   80106200 <release>
  return r;
}
80106049:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604c:	89 f8                	mov    %edi,%eax
8010604e:	5b                   	pop    %ebx
8010604f:	5e                   	pop    %esi
80106050:	5f                   	pop    %edi
80106051:	5d                   	pop    %ebp
80106052:	c3                   	ret
80106053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80106058:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010605b:	e8 50 f0 ff ff       	call   801050b0 <myproc>
80106060:	39 58 10             	cmp    %ebx,0x10(%eax)
80106063:	0f 94 c0             	sete   %al
80106066:	0f b6 c0             	movzbl %al,%eax
80106069:	89 c7                	mov    %eax,%edi
8010606b:	eb d3                	jmp    80106040 <holdingsleep+0x20>
8010606d:	66 90                	xchg   %ax,%ax
8010606f:	90                   	nop

80106070 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80106076:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80106079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010607f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80106082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106089:	5d                   	pop    %ebp
8010608a:	c3                   	ret
8010608b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106090 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	53                   	push   %ebx
80106094:	8b 45 08             	mov    0x8(%ebp),%eax
80106097:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010609a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010609d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801060a2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801060a7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801060ac:	76 10                	jbe    801060be <getcallerpcs+0x2e>
801060ae:	eb 28                	jmp    801060d8 <getcallerpcs+0x48>
801060b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801060b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801060bc:	77 1a                	ja     801060d8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801060be:	8b 5a 04             	mov    0x4(%edx),%ebx
801060c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801060c4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801060c7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801060c9:	83 f8 0a             	cmp    $0xa,%eax
801060cc:	75 e2                	jne    801060b0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801060ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d1:	c9                   	leave
801060d2:	c3                   	ret
801060d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801060d8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801060db:	83 c1 28             	add    $0x28,%ecx
801060de:	89 ca                	mov    %ecx,%edx
801060e0:	29 c2                	sub    %eax,%edx
801060e2:	83 e2 04             	and    $0x4,%edx
801060e5:	74 11                	je     801060f8 <getcallerpcs+0x68>
    pcs[i] = 0;
801060e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801060ed:	83 c0 04             	add    $0x4,%eax
801060f0:	39 c1                	cmp    %eax,%ecx
801060f2:	74 da                	je     801060ce <getcallerpcs+0x3e>
801060f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801060f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801060fe:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106101:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106108:	39 c1                	cmp    %eax,%ecx
8010610a:	75 ec                	jne    801060f8 <getcallerpcs+0x68>
8010610c:	eb c0                	jmp    801060ce <getcallerpcs+0x3e>
8010610e:	66 90                	xchg   %ax,%ax

80106110 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	53                   	push   %ebx
80106114:	83 ec 04             	sub    $0x4,%esp
80106117:	9c                   	pushf
80106118:	5b                   	pop    %ebx
  asm volatile("cli");
80106119:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010611a:	e8 b1 ee ff ff       	call   80104fd0 <mycpu>
8010611f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 17                	je     80106140 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80106129:	e8 a2 ee ff ff       	call   80104fd0 <mycpu>
8010612e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80106135:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106138:	c9                   	leave
80106139:	c3                   	ret
8010613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80106140:	e8 8b ee ff ff       	call   80104fd0 <mycpu>
80106145:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010614b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80106151:	eb d6                	jmp    80106129 <pushcli+0x19>
80106153:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010615a:	00 
8010615b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106160 <popcli>:

void
popcli(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106166:	9c                   	pushf
80106167:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80106168:	f6 c4 02             	test   $0x2,%ah
8010616b:	75 35                	jne    801061a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010616d:	e8 5e ee ff ff       	call   80104fd0 <mycpu>
80106172:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106179:	78 34                	js     801061af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010617b:	e8 50 ee ff ff       	call   80104fd0 <mycpu>
80106180:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80106186:	85 d2                	test   %edx,%edx
80106188:	74 06                	je     80106190 <popcli+0x30>
    sti();
}
8010618a:	c9                   	leave
8010618b:	c3                   	ret
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106190:	e8 3b ee ff ff       	call   80104fd0 <mycpu>
80106195:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010619b:	85 c0                	test   %eax,%eax
8010619d:	74 eb                	je     8010618a <popcli+0x2a>
  asm volatile("sti");
8010619f:	fb                   	sti
}
801061a0:	c9                   	leave
801061a1:	c3                   	ret
    panic("popcli - interruptible");
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	68 16 99 10 80       	push   $0x80109916
801061aa:	e8 a1 a3 ff ff       	call   80100550 <panic>
    panic("popcli");
801061af:	83 ec 0c             	sub    $0xc,%esp
801061b2:	68 2d 99 10 80       	push   $0x8010992d
801061b7:	e8 94 a3 ff ff       	call   80100550 <panic>
801061bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061c0 <holding>:
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
801061c3:	56                   	push   %esi
801061c4:	53                   	push   %ebx
801061c5:	8b 75 08             	mov    0x8(%ebp),%esi
801061c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801061ca:	e8 41 ff ff ff       	call   80106110 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801061cf:	8b 06                	mov    (%esi),%eax
801061d1:	85 c0                	test   %eax,%eax
801061d3:	75 0b                	jne    801061e0 <holding+0x20>
  popcli();
801061d5:	e8 86 ff ff ff       	call   80106160 <popcli>
}
801061da:	89 d8                	mov    %ebx,%eax
801061dc:	5b                   	pop    %ebx
801061dd:	5e                   	pop    %esi
801061de:	5d                   	pop    %ebp
801061df:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801061e0:	8b 5e 08             	mov    0x8(%esi),%ebx
801061e3:	e8 e8 ed ff ff       	call   80104fd0 <mycpu>
801061e8:	39 c3                	cmp    %eax,%ebx
801061ea:	0f 94 c3             	sete   %bl
  popcli();
801061ed:	e8 6e ff ff ff       	call   80106160 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801061f2:	0f b6 db             	movzbl %bl,%ebx
}
801061f5:	89 d8                	mov    %ebx,%eax
801061f7:	5b                   	pop    %ebx
801061f8:	5e                   	pop    %esi
801061f9:	5d                   	pop    %ebp
801061fa:	c3                   	ret
801061fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106200 <release>:
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	56                   	push   %esi
80106204:	53                   	push   %ebx
80106205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106208:	e8 03 ff ff ff       	call   80106110 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010620d:	8b 03                	mov    (%ebx),%eax
8010620f:	85 c0                	test   %eax,%eax
80106211:	75 15                	jne    80106228 <release+0x28>
  popcli();
80106213:	e8 48 ff ff ff       	call   80106160 <popcli>
    panic("release");
80106218:	83 ec 0c             	sub    $0xc,%esp
8010621b:	68 34 99 10 80       	push   $0x80109934
80106220:	e8 2b a3 ff ff       	call   80100550 <panic>
80106225:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80106228:	8b 73 08             	mov    0x8(%ebx),%esi
8010622b:	e8 a0 ed ff ff       	call   80104fd0 <mycpu>
80106230:	39 c6                	cmp    %eax,%esi
80106232:	75 df                	jne    80106213 <release+0x13>
  popcli();
80106234:	e8 27 ff ff ff       	call   80106160 <popcli>
  lk->pcs[0] = 0;
80106239:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80106240:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80106247:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010624c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80106252:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106255:	5b                   	pop    %ebx
80106256:	5e                   	pop    %esi
80106257:	5d                   	pop    %ebp
  popcli();
80106258:	e9 03 ff ff ff       	jmp    80106160 <popcli>
8010625d:	8d 76 00             	lea    0x0(%esi),%esi

80106260 <acquire>:
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	53                   	push   %ebx
80106264:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106267:	e8 a4 fe ff ff       	call   80106110 <pushcli>
  if(holding(lk))
8010626c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010626f:	e8 9c fe ff ff       	call   80106110 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106274:	8b 03                	mov    (%ebx),%eax
80106276:	85 c0                	test   %eax,%eax
80106278:	0f 85 b2 00 00 00    	jne    80106330 <acquire+0xd0>
  popcli();
8010627e:	e8 dd fe ff ff       	call   80106160 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80106283:	b9 01 00 00 00       	mov    $0x1,%ecx
80106288:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010628f:	00 
  while(xchg(&lk->locked, 1) != 0)
80106290:	8b 55 08             	mov    0x8(%ebp),%edx
80106293:	89 c8                	mov    %ecx,%eax
80106295:	f0 87 02             	lock xchg %eax,(%edx)
80106298:	85 c0                	test   %eax,%eax
8010629a:	75 f4                	jne    80106290 <acquire+0x30>
  __sync_synchronize();
8010629c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801062a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801062a4:	e8 27 ed ff ff       	call   80104fd0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801062a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801062ac:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801062ae:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801062b1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801062b7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801062bc:	77 32                	ja     801062f0 <acquire+0x90>
  ebp = (uint*)v - 2;
801062be:	89 e8                	mov    %ebp,%eax
801062c0:	eb 14                	jmp    801062d6 <acquire+0x76>
801062c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801062c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801062ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801062d4:	77 1a                	ja     801062f0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801062d6:	8b 58 04             	mov    0x4(%eax),%ebx
801062d9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801062dd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801062e0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801062e2:	83 fa 0a             	cmp    $0xa,%edx
801062e5:	75 e1                	jne    801062c8 <acquire+0x68>
}
801062e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062ea:	c9                   	leave
801062eb:	c3                   	ret
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062f0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801062f4:	83 c1 34             	add    $0x34,%ecx
801062f7:	89 ca                	mov    %ecx,%edx
801062f9:	29 c2                	sub    %eax,%edx
801062fb:	83 e2 04             	and    $0x4,%edx
801062fe:	74 10                	je     80106310 <acquire+0xb0>
    pcs[i] = 0;
80106300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106306:	83 c0 04             	add    $0x4,%eax
80106309:	39 c1                	cmp    %eax,%ecx
8010630b:	74 da                	je     801062e7 <acquire+0x87>
8010630d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80106310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106316:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106319:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106320:	39 c1                	cmp    %eax,%ecx
80106322:	75 ec                	jne    80106310 <acquire+0xb0>
80106324:	eb c1                	jmp    801062e7 <acquire+0x87>
80106326:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010632d:	00 
8010632e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80106330:	8b 5b 08             	mov    0x8(%ebx),%ebx
80106333:	e8 98 ec ff ff       	call   80104fd0 <mycpu>
80106338:	39 c3                	cmp    %eax,%ebx
8010633a:	0f 85 3e ff ff ff    	jne    8010627e <acquire+0x1e>
  popcli();
80106340:	e8 1b fe ff ff       	call   80106160 <popcli>
    panic("acquire");
80106345:	83 ec 0c             	sub    $0xc,%esp
80106348:	68 3c 99 10 80       	push   $0x8010993c
8010634d:	e8 fe a1 ff ff       	call   80100550 <panic>
80106352:	66 90                	xchg   %ax,%ax
80106354:	66 90                	xchg   %ax,%ax
80106356:	66 90                	xchg   %ax,%ax
80106358:	66 90                	xchg   %ax,%ax
8010635a:	66 90                	xchg   %ax,%ax
8010635c:	66 90                	xchg   %ax,%ax
8010635e:	66 90                	xchg   %ax,%ax

80106360 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	57                   	push   %edi
80106364:	8b 55 08             	mov    0x8(%ebp),%edx
80106367:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010636a:	89 d0                	mov    %edx,%eax
8010636c:	09 c8                	or     %ecx,%eax
8010636e:	a8 03                	test   $0x3,%al
80106370:	75 1e                	jne    80106390 <memset+0x30>
    c &= 0xFF;
80106372:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106376:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80106379:	89 d7                	mov    %edx,%edi
8010637b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80106381:	fc                   	cld
80106382:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80106384:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106387:	89 d0                	mov    %edx,%eax
80106389:	c9                   	leave
8010638a:	c3                   	ret
8010638b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80106390:	8b 45 0c             	mov    0xc(%ebp),%eax
80106393:	89 d7                	mov    %edx,%edi
80106395:	fc                   	cld
80106396:	f3 aa                	rep stos %al,%es:(%edi)
80106398:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010639b:	89 d0                	mov    %edx,%eax
8010639d:	c9                   	leave
8010639e:	c3                   	ret
8010639f:	90                   	nop

801063a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	56                   	push   %esi
801063a4:	8b 75 10             	mov    0x10(%ebp),%esi
801063a7:	8b 45 08             	mov    0x8(%ebp),%eax
801063aa:	53                   	push   %ebx
801063ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801063ae:	85 f6                	test   %esi,%esi
801063b0:	74 2e                	je     801063e0 <memcmp+0x40>
801063b2:	01 c6                	add    %eax,%esi
801063b4:	eb 14                	jmp    801063ca <memcmp+0x2a>
801063b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063bd:	00 
801063be:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801063c0:	83 c0 01             	add    $0x1,%eax
801063c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801063c6:	39 f0                	cmp    %esi,%eax
801063c8:	74 16                	je     801063e0 <memcmp+0x40>
    if(*s1 != *s2)
801063ca:	0f b6 08             	movzbl (%eax),%ecx
801063cd:	0f b6 1a             	movzbl (%edx),%ebx
801063d0:	38 d9                	cmp    %bl,%cl
801063d2:	74 ec                	je     801063c0 <memcmp+0x20>
      return *s1 - *s2;
801063d4:	0f b6 c1             	movzbl %cl,%eax
801063d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801063d9:	5b                   	pop    %ebx
801063da:	5e                   	pop    %esi
801063db:	5d                   	pop    %ebp
801063dc:	c3                   	ret
801063dd:	8d 76 00             	lea    0x0(%esi),%esi
801063e0:	5b                   	pop    %ebx
  return 0;
801063e1:	31 c0                	xor    %eax,%eax
}
801063e3:	5e                   	pop    %esi
801063e4:	5d                   	pop    %ebp
801063e5:	c3                   	ret
801063e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ed:	00 
801063ee:	66 90                	xchg   %ax,%ax

801063f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	57                   	push   %edi
801063f4:	8b 55 08             	mov    0x8(%ebp),%edx
801063f7:	8b 45 10             	mov    0x10(%ebp),%eax
801063fa:	56                   	push   %esi
801063fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801063fe:	39 d6                	cmp    %edx,%esi
80106400:	73 26                	jae    80106428 <memmove+0x38>
80106402:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80106405:	39 ca                	cmp    %ecx,%edx
80106407:	73 1f                	jae    80106428 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80106409:	85 c0                	test   %eax,%eax
8010640b:	74 0f                	je     8010641c <memmove+0x2c>
8010640d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80106410:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80106414:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80106417:	83 e8 01             	sub    $0x1,%eax
8010641a:	73 f4                	jae    80106410 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010641c:	5e                   	pop    %esi
8010641d:	89 d0                	mov    %edx,%eax
8010641f:	5f                   	pop    %edi
80106420:	5d                   	pop    %ebp
80106421:	c3                   	ret
80106422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80106428:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010642b:	89 d7                	mov    %edx,%edi
8010642d:	85 c0                	test   %eax,%eax
8010642f:	74 eb                	je     8010641c <memmove+0x2c>
80106431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80106438:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80106439:	39 ce                	cmp    %ecx,%esi
8010643b:	75 fb                	jne    80106438 <memmove+0x48>
}
8010643d:	5e                   	pop    %esi
8010643e:	89 d0                	mov    %edx,%eax
80106440:	5f                   	pop    %edi
80106441:	5d                   	pop    %ebp
80106442:	c3                   	ret
80106443:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010644a:	00 
8010644b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106450 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80106450:	eb 9e                	jmp    801063f0 <memmove>
80106452:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106459:	00 
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106460 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	53                   	push   %ebx
80106464:	8b 55 10             	mov    0x10(%ebp),%edx
80106467:	8b 45 08             	mov    0x8(%ebp),%eax
8010646a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010646d:	85 d2                	test   %edx,%edx
8010646f:	75 16                	jne    80106487 <strncmp+0x27>
80106471:	eb 2d                	jmp    801064a0 <strncmp+0x40>
80106473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106478:	3a 19                	cmp    (%ecx),%bl
8010647a:	75 12                	jne    8010648e <strncmp+0x2e>
    n--, p++, q++;
8010647c:	83 c0 01             	add    $0x1,%eax
8010647f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80106482:	83 ea 01             	sub    $0x1,%edx
80106485:	74 19                	je     801064a0 <strncmp+0x40>
80106487:	0f b6 18             	movzbl (%eax),%ebx
8010648a:	84 db                	test   %bl,%bl
8010648c:	75 ea                	jne    80106478 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010648e:	0f b6 00             	movzbl (%eax),%eax
80106491:	0f b6 11             	movzbl (%ecx),%edx
}
80106494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106497:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80106498:	29 d0                	sub    %edx,%eax
}
8010649a:	c3                   	ret
8010649b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801064a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801064a3:	31 c0                	xor    %eax,%eax
}
801064a5:	c9                   	leave
801064a6:	c3                   	ret
801064a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064ae:	00 
801064af:	90                   	nop

801064b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	56                   	push   %esi
801064b5:	8b 75 08             	mov    0x8(%ebp),%esi
801064b8:	53                   	push   %ebx
801064b9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801064bc:	89 f0                	mov    %esi,%eax
801064be:	eb 15                	jmp    801064d5 <strncpy+0x25>
801064c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801064c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801064c7:	83 c0 01             	add    $0x1,%eax
801064ca:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801064ce:	88 48 ff             	mov    %cl,-0x1(%eax)
801064d1:	84 c9                	test   %cl,%cl
801064d3:	74 13                	je     801064e8 <strncpy+0x38>
801064d5:	89 d3                	mov    %edx,%ebx
801064d7:	83 ea 01             	sub    $0x1,%edx
801064da:	85 db                	test   %ebx,%ebx
801064dc:	7f e2                	jg     801064c0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801064de:	5b                   	pop    %ebx
801064df:	89 f0                	mov    %esi,%eax
801064e1:	5e                   	pop    %esi
801064e2:	5f                   	pop    %edi
801064e3:	5d                   	pop    %ebp
801064e4:	c3                   	ret
801064e5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801064e8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801064eb:	83 e9 01             	sub    $0x1,%ecx
801064ee:	85 d2                	test   %edx,%edx
801064f0:	74 ec                	je     801064de <strncpy+0x2e>
801064f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801064f8:	83 c0 01             	add    $0x1,%eax
801064fb:	89 ca                	mov    %ecx,%edx
801064fd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80106501:	29 c2                	sub    %eax,%edx
80106503:	85 d2                	test   %edx,%edx
80106505:	7f f1                	jg     801064f8 <strncpy+0x48>
}
80106507:	5b                   	pop    %ebx
80106508:	89 f0                	mov    %esi,%eax
8010650a:	5e                   	pop    %esi
8010650b:	5f                   	pop    %edi
8010650c:	5d                   	pop    %ebp
8010650d:	c3                   	ret
8010650e:	66 90                	xchg   %ax,%ax

80106510 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	56                   	push   %esi
80106514:	8b 55 10             	mov    0x10(%ebp),%edx
80106517:	8b 75 08             	mov    0x8(%ebp),%esi
8010651a:	53                   	push   %ebx
8010651b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010651e:	85 d2                	test   %edx,%edx
80106520:	7e 25                	jle    80106547 <safestrcpy+0x37>
80106522:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80106526:	89 f2                	mov    %esi,%edx
80106528:	eb 16                	jmp    80106540 <safestrcpy+0x30>
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80106530:	0f b6 08             	movzbl (%eax),%ecx
80106533:	83 c0 01             	add    $0x1,%eax
80106536:	83 c2 01             	add    $0x1,%edx
80106539:	88 4a ff             	mov    %cl,-0x1(%edx)
8010653c:	84 c9                	test   %cl,%cl
8010653e:	74 04                	je     80106544 <safestrcpy+0x34>
80106540:	39 d8                	cmp    %ebx,%eax
80106542:	75 ec                	jne    80106530 <safestrcpy+0x20>
    ;
  *s = 0;
80106544:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80106547:	89 f0                	mov    %esi,%eax
80106549:	5b                   	pop    %ebx
8010654a:	5e                   	pop    %esi
8010654b:	5d                   	pop    %ebp
8010654c:	c3                   	ret
8010654d:	8d 76 00             	lea    0x0(%esi),%esi

80106550 <strlen>:

int
strlen(const char *s)
{
80106550:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80106551:	31 c0                	xor    %eax,%eax
{
80106553:	89 e5                	mov    %esp,%ebp
80106555:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80106558:	80 3a 00             	cmpb   $0x0,(%edx)
8010655b:	74 0c                	je     80106569 <strlen+0x19>
8010655d:	8d 76 00             	lea    0x0(%esi),%esi
80106560:	83 c0 01             	add    $0x1,%eax
80106563:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80106567:	75 f7                	jne    80106560 <strlen+0x10>
    ;
  return n;
}
80106569:	5d                   	pop    %ebp
8010656a:	c3                   	ret

8010656b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010656b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010656f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80106573:	55                   	push   %ebp
  pushl %ebx
80106574:	53                   	push   %ebx
  pushl %esi
80106575:	56                   	push   %esi
  pushl %edi
80106576:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106577:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106579:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010657b:	5f                   	pop    %edi
  popl %esi
8010657c:	5e                   	pop    %esi
  popl %ebx
8010657d:	5b                   	pop    %ebx
  popl %ebp
8010657e:	5d                   	pop    %ebp
  ret
8010657f:	c3                   	ret

80106580 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	53                   	push   %ebx
80106584:	83 ec 04             	sub    $0x4,%esp
80106587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010658a:	e8 21 eb ff ff       	call   801050b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010658f:	8b 00                	mov    (%eax),%eax
80106591:	39 c3                	cmp    %eax,%ebx
80106593:	73 1b                	jae    801065b0 <fetchint+0x30>
80106595:	8d 53 04             	lea    0x4(%ebx),%edx
80106598:	39 d0                	cmp    %edx,%eax
8010659a:	72 14                	jb     801065b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010659c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010659f:	8b 13                	mov    (%ebx),%edx
801065a1:	89 10                	mov    %edx,(%eax)
  return 0;
801065a3:	31 c0                	xor    %eax,%eax
}
801065a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065a8:	c9                   	leave
801065a9:	c3                   	ret
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801065b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b5:	eb ee                	jmp    801065a5 <fetchint+0x25>
801065b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065be:	00 
801065bf:	90                   	nop

801065c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	53                   	push   %ebx
801065c4:	83 ec 04             	sub    $0x4,%esp
801065c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801065ca:	e8 e1 ea ff ff       	call   801050b0 <myproc>

  if(addr >= curproc->sz)
801065cf:	3b 18                	cmp    (%eax),%ebx
801065d1:	73 2d                	jae    80106600 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801065d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801065d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801065d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801065da:	39 d3                	cmp    %edx,%ebx
801065dc:	73 22                	jae    80106600 <fetchstr+0x40>
801065de:	89 d8                	mov    %ebx,%eax
801065e0:	eb 0d                	jmp    801065ef <fetchstr+0x2f>
801065e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065e8:	83 c0 01             	add    $0x1,%eax
801065eb:	39 d0                	cmp    %edx,%eax
801065ed:	73 11                	jae    80106600 <fetchstr+0x40>
    if(*s == 0)
801065ef:	80 38 00             	cmpb   $0x0,(%eax)
801065f2:	75 f4                	jne    801065e8 <fetchstr+0x28>
      return s - *pp;
801065f4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801065f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065f9:	c9                   	leave
801065fa:	c3                   	ret
801065fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106600:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80106603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106608:	c9                   	leave
80106609:	c3                   	ret
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106610 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	56                   	push   %esi
80106614:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106615:	e8 96 ea ff ff       	call   801050b0 <myproc>
8010661a:	8b 55 08             	mov    0x8(%ebp),%edx
8010661d:	8b 40 18             	mov    0x18(%eax),%eax
80106620:	8b 40 44             	mov    0x44(%eax),%eax
80106623:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106626:	e8 85 ea ff ff       	call   801050b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010662b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010662e:	8b 00                	mov    (%eax),%eax
80106630:	39 c6                	cmp    %eax,%esi
80106632:	73 1c                	jae    80106650 <argint+0x40>
80106634:	8d 53 08             	lea    0x8(%ebx),%edx
80106637:	39 d0                	cmp    %edx,%eax
80106639:	72 15                	jb     80106650 <argint+0x40>
  *ip = *(int*)(addr);
8010663b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010663e:	8b 53 04             	mov    0x4(%ebx),%edx
80106641:	89 10                	mov    %edx,(%eax)
  return 0;
80106643:	31 c0                	xor    %eax,%eax
}
80106645:	5b                   	pop    %ebx
80106646:	5e                   	pop    %esi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106655:	eb ee                	jmp    80106645 <argint+0x35>
80106657:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010665e:	00 
8010665f:	90                   	nop

80106660 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	56                   	push   %esi
80106665:	53                   	push   %ebx
80106666:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80106669:	e8 42 ea ff ff       	call   801050b0 <myproc>
8010666e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106670:	e8 3b ea ff ff       	call   801050b0 <myproc>
80106675:	8b 55 08             	mov    0x8(%ebp),%edx
80106678:	8b 40 18             	mov    0x18(%eax),%eax
8010667b:	8b 40 44             	mov    0x44(%eax),%eax
8010667e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80106681:	e8 2a ea ff ff       	call   801050b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106686:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106689:	8b 00                	mov    (%eax),%eax
8010668b:	39 c7                	cmp    %eax,%edi
8010668d:	73 31                	jae    801066c0 <argptr+0x60>
8010668f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80106692:	39 c8                	cmp    %ecx,%eax
80106694:	72 2a                	jb     801066c0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106696:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80106699:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010669c:	85 d2                	test   %edx,%edx
8010669e:	78 20                	js     801066c0 <argptr+0x60>
801066a0:	8b 16                	mov    (%esi),%edx
801066a2:	39 d0                	cmp    %edx,%eax
801066a4:	73 1a                	jae    801066c0 <argptr+0x60>
801066a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801066a9:	01 c3                	add    %eax,%ebx
801066ab:	39 da                	cmp    %ebx,%edx
801066ad:	72 11                	jb     801066c0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801066af:	8b 55 0c             	mov    0xc(%ebp),%edx
801066b2:	89 02                	mov    %eax,(%edx)
  return 0;
801066b4:	31 c0                	xor    %eax,%eax
}
801066b6:	83 c4 0c             	add    $0xc,%esp
801066b9:	5b                   	pop    %ebx
801066ba:	5e                   	pop    %esi
801066bb:	5f                   	pop    %edi
801066bc:	5d                   	pop    %ebp
801066bd:	c3                   	ret
801066be:	66 90                	xchg   %ax,%ax
    return -1;
801066c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c5:	eb ef                	jmp    801066b6 <argptr+0x56>
801066c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801066ce:	00 
801066cf:	90                   	nop

801066d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	56                   	push   %esi
801066d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066d5:	e8 d6 e9 ff ff       	call   801050b0 <myproc>
801066da:	8b 55 08             	mov    0x8(%ebp),%edx
801066dd:	8b 40 18             	mov    0x18(%eax),%eax
801066e0:	8b 40 44             	mov    0x44(%eax),%eax
801066e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801066e6:	e8 c5 e9 ff ff       	call   801050b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801066eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801066ee:	8b 00                	mov    (%eax),%eax
801066f0:	39 c6                	cmp    %eax,%esi
801066f2:	73 44                	jae    80106738 <argstr+0x68>
801066f4:	8d 53 08             	lea    0x8(%ebx),%edx
801066f7:	39 d0                	cmp    %edx,%eax
801066f9:	72 3d                	jb     80106738 <argstr+0x68>
  *ip = *(int*)(addr);
801066fb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801066fe:	e8 ad e9 ff ff       	call   801050b0 <myproc>
  if(addr >= curproc->sz)
80106703:	3b 18                	cmp    (%eax),%ebx
80106705:	73 31                	jae    80106738 <argstr+0x68>
  *pp = (char*)addr;
80106707:	8b 55 0c             	mov    0xc(%ebp),%edx
8010670a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010670c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010670e:	39 d3                	cmp    %edx,%ebx
80106710:	73 26                	jae    80106738 <argstr+0x68>
80106712:	89 d8                	mov    %ebx,%eax
80106714:	eb 11                	jmp    80106727 <argstr+0x57>
80106716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010671d:	00 
8010671e:	66 90                	xchg   %ax,%ax
80106720:	83 c0 01             	add    $0x1,%eax
80106723:	39 d0                	cmp    %edx,%eax
80106725:	73 11                	jae    80106738 <argstr+0x68>
    if(*s == 0)
80106727:	80 38 00             	cmpb   $0x0,(%eax)
8010672a:	75 f4                	jne    80106720 <argstr+0x50>
      return s - *pp;
8010672c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010672e:	5b                   	pop    %ebx
8010672f:	5e                   	pop    %esi
80106730:	5d                   	pop    %ebp
80106731:	c3                   	ret
80106732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106738:	5b                   	pop    %ebx
    return -1;
80106739:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010673e:	5e                   	pop    %esi
8010673f:	5d                   	pop    %ebp
80106740:	c3                   	ret
80106741:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106748:	00 
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106750 <syscall>:

};

void
syscall(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	53                   	push   %ebx
80106754:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106757:	e8 54 e9 ff ff       	call   801050b0 <myproc>
8010675c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010675e:	8b 40 18             	mov    0x18(%eax),%eax
80106761:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106764:	8d 50 ff             	lea    -0x1(%eax),%edx
80106767:	83 fa 1b             	cmp    $0x1b,%edx
8010676a:	77 24                	ja     80106790 <syscall+0x40>
8010676c:	8b 14 85 a0 9f 10 80 	mov    -0x7fef6060(,%eax,4),%edx
80106773:	85 d2                	test   %edx,%edx
80106775:	74 19                	je     80106790 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80106777:	ff d2                	call   *%edx
80106779:	89 c2                	mov    %eax,%edx
8010677b:	8b 43 18             	mov    0x18(%ebx),%eax
8010677e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80106781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106784:	c9                   	leave
80106785:	c3                   	ret
80106786:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010678d:	00 
8010678e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80106790:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106791:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106794:	50                   	push   %eax
80106795:	ff 73 10             	push   0x10(%ebx)
80106798:	68 44 99 10 80       	push   $0x80109944
8010679d:	e8 be a5 ff ff       	call   80100d60 <cprintf>
    curproc->tf->eax = -1;
801067a2:	8b 43 18             	mov    0x18(%ebx),%eax
801067a5:	83 c4 10             	add    $0x10,%esp
801067a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801067af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067b2:	c9                   	leave
801067b3:	c3                   	ret
801067b4:	66 90                	xchg   %ax,%ax
801067b6:	66 90                	xchg   %ax,%ax
801067b8:	66 90                	xchg   %ax,%ax
801067ba:	66 90                	xchg   %ax,%ax
801067bc:	66 90                	xchg   %ax,%ax
801067be:	66 90                	xchg   %ax,%ax

801067c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801067c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801067c8:	53                   	push   %ebx
801067c9:	83 ec 34             	sub    $0x34,%esp
801067cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801067cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801067d2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801067d5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801067d8:	57                   	push   %edi
801067d9:	50                   	push   %eax
801067da:	e8 61 ce ff ff       	call   80103640 <nameiparent>
801067df:	83 c4 10             	add    $0x10,%esp
801067e2:	85 c0                	test   %eax,%eax
801067e4:	74 5e                	je     80106844 <create+0x84>
    return 0;
  ilock(dp);
801067e6:	83 ec 0c             	sub    $0xc,%esp
801067e9:	89 c3                	mov    %eax,%ebx
801067eb:	50                   	push   %eax
801067ec:	e8 4f c5 ff ff       	call   80102d40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801067f1:	83 c4 0c             	add    $0xc,%esp
801067f4:	6a 00                	push   $0x0
801067f6:	57                   	push   %edi
801067f7:	53                   	push   %ebx
801067f8:	e8 93 ca ff ff       	call   80103290 <dirlookup>
801067fd:	83 c4 10             	add    $0x10,%esp
80106800:	89 c6                	mov    %eax,%esi
80106802:	85 c0                	test   %eax,%eax
80106804:	74 4a                	je     80106850 <create+0x90>
    iunlockput(dp);
80106806:	83 ec 0c             	sub    $0xc,%esp
80106809:	53                   	push   %ebx
8010680a:	e8 c1 c7 ff ff       	call   80102fd0 <iunlockput>
    ilock(ip);
8010680f:	89 34 24             	mov    %esi,(%esp)
80106812:	e8 29 c5 ff ff       	call   80102d40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106817:	83 c4 10             	add    $0x10,%esp
8010681a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010681f:	75 17                	jne    80106838 <create+0x78>
80106821:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80106826:	75 10                	jne    80106838 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80106828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010682b:	89 f0                	mov    %esi,%eax
8010682d:	5b                   	pop    %ebx
8010682e:	5e                   	pop    %esi
8010682f:	5f                   	pop    %edi
80106830:	5d                   	pop    %ebp
80106831:	c3                   	ret
80106832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106838:	83 ec 0c             	sub    $0xc,%esp
8010683b:	56                   	push   %esi
8010683c:	e8 8f c7 ff ff       	call   80102fd0 <iunlockput>
    return 0;
80106841:	83 c4 10             	add    $0x10,%esp
}
80106844:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106847:	31 f6                	xor    %esi,%esi
}
80106849:	5b                   	pop    %ebx
8010684a:	89 f0                	mov    %esi,%eax
8010684c:	5e                   	pop    %esi
8010684d:	5f                   	pop    %edi
8010684e:	5d                   	pop    %ebp
8010684f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80106850:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106854:	83 ec 08             	sub    $0x8,%esp
80106857:	50                   	push   %eax
80106858:	ff 33                	push   (%ebx)
8010685a:	e8 71 c3 ff ff       	call   80102bd0 <ialloc>
8010685f:	83 c4 10             	add    $0x10,%esp
80106862:	89 c6                	mov    %eax,%esi
80106864:	85 c0                	test   %eax,%eax
80106866:	0f 84 bc 00 00 00    	je     80106928 <create+0x168>
  ilock(ip);
8010686c:	83 ec 0c             	sub    $0xc,%esp
8010686f:	50                   	push   %eax
80106870:	e8 cb c4 ff ff       	call   80102d40 <ilock>
  ip->major = major;
80106875:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106879:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010687d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106881:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106885:	b8 01 00 00 00       	mov    $0x1,%eax
8010688a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010688e:	89 34 24             	mov    %esi,(%esp)
80106891:	e8 fa c3 ff ff       	call   80102c90 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106896:	83 c4 10             	add    $0x10,%esp
80106899:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010689e:	74 30                	je     801068d0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801068a0:	83 ec 04             	sub    $0x4,%esp
801068a3:	ff 76 04             	push   0x4(%esi)
801068a6:	57                   	push   %edi
801068a7:	53                   	push   %ebx
801068a8:	e8 b3 cc ff ff       	call   80103560 <dirlink>
801068ad:	83 c4 10             	add    $0x10,%esp
801068b0:	85 c0                	test   %eax,%eax
801068b2:	78 67                	js     8010691b <create+0x15b>
  iunlockput(dp);
801068b4:	83 ec 0c             	sub    $0xc,%esp
801068b7:	53                   	push   %ebx
801068b8:	e8 13 c7 ff ff       	call   80102fd0 <iunlockput>
  return ip;
801068bd:	83 c4 10             	add    $0x10,%esp
}
801068c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068c3:	89 f0                	mov    %esi,%eax
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801068d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801068d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801068d8:	53                   	push   %ebx
801068d9:	e8 b2 c3 ff ff       	call   80102c90 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801068de:	83 c4 0c             	add    $0xc,%esp
801068e1:	ff 76 04             	push   0x4(%esi)
801068e4:	68 7c 99 10 80       	push   $0x8010997c
801068e9:	56                   	push   %esi
801068ea:	e8 71 cc ff ff       	call   80103560 <dirlink>
801068ef:	83 c4 10             	add    $0x10,%esp
801068f2:	85 c0                	test   %eax,%eax
801068f4:	78 18                	js     8010690e <create+0x14e>
801068f6:	83 ec 04             	sub    $0x4,%esp
801068f9:	ff 73 04             	push   0x4(%ebx)
801068fc:	68 7b 99 10 80       	push   $0x8010997b
80106901:	56                   	push   %esi
80106902:	e8 59 cc ff ff       	call   80103560 <dirlink>
80106907:	83 c4 10             	add    $0x10,%esp
8010690a:	85 c0                	test   %eax,%eax
8010690c:	79 92                	jns    801068a0 <create+0xe0>
      panic("create dots");
8010690e:	83 ec 0c             	sub    $0xc,%esp
80106911:	68 6f 99 10 80       	push   $0x8010996f
80106916:	e8 35 9c ff ff       	call   80100550 <panic>
    panic("create: dirlink");
8010691b:	83 ec 0c             	sub    $0xc,%esp
8010691e:	68 7e 99 10 80       	push   $0x8010997e
80106923:	e8 28 9c ff ff       	call   80100550 <panic>
    panic("create: ialloc");
80106928:	83 ec 0c             	sub    $0xc,%esp
8010692b:	68 60 99 10 80       	push   $0x80109960
80106930:	e8 1b 9c ff ff       	call   80100550 <panic>
80106935:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010693c:	00 
8010693d:	8d 76 00             	lea    0x0(%esi),%esi

80106940 <sys_dup>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	56                   	push   %esi
80106944:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106945:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106948:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010694b:	50                   	push   %eax
8010694c:	6a 00                	push   $0x0
8010694e:	e8 bd fc ff ff       	call   80106610 <argint>
80106953:	83 c4 10             	add    $0x10,%esp
80106956:	85 c0                	test   %eax,%eax
80106958:	78 36                	js     80106990 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010695a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010695e:	77 30                	ja     80106990 <sys_dup+0x50>
80106960:	e8 4b e7 ff ff       	call   801050b0 <myproc>
80106965:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106968:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010696c:	85 f6                	test   %esi,%esi
8010696e:	74 20                	je     80106990 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106970:	e8 3b e7 ff ff       	call   801050b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106975:	31 db                	xor    %ebx,%ebx
80106977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010697e:	00 
8010697f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80106980:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106984:	85 d2                	test   %edx,%edx
80106986:	74 18                	je     801069a0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106988:	83 c3 01             	add    $0x1,%ebx
8010698b:	83 fb 10             	cmp    $0x10,%ebx
8010698e:	75 f0                	jne    80106980 <sys_dup+0x40>
}
80106990:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106993:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106998:	89 d8                	mov    %ebx,%eax
8010699a:	5b                   	pop    %ebx
8010699b:	5e                   	pop    %esi
8010699c:	5d                   	pop    %ebp
8010699d:	c3                   	ret
8010699e:	66 90                	xchg   %ax,%ax
  filedup(f);
801069a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801069a3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801069a7:	56                   	push   %esi
801069a8:	e8 b3 ba ff ff       	call   80102460 <filedup>
  return fd;
801069ad:	83 c4 10             	add    $0x10,%esp
}
801069b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069b3:	89 d8                	mov    %ebx,%eax
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5d                   	pop    %ebp
801069b8:	c3                   	ret
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <sys_read>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	56                   	push   %esi
801069c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801069c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801069c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801069cb:	53                   	push   %ebx
801069cc:	6a 00                	push   $0x0
801069ce:	e8 3d fc ff ff       	call   80106610 <argint>
801069d3:	83 c4 10             	add    $0x10,%esp
801069d6:	85 c0                	test   %eax,%eax
801069d8:	78 5e                	js     80106a38 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801069da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801069de:	77 58                	ja     80106a38 <sys_read+0x78>
801069e0:	e8 cb e6 ff ff       	call   801050b0 <myproc>
801069e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801069ec:	85 f6                	test   %esi,%esi
801069ee:	74 48                	je     80106a38 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801069f0:	83 ec 08             	sub    $0x8,%esp
801069f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069f6:	50                   	push   %eax
801069f7:	6a 02                	push   $0x2
801069f9:	e8 12 fc ff ff       	call   80106610 <argint>
801069fe:	83 c4 10             	add    $0x10,%esp
80106a01:	85 c0                	test   %eax,%eax
80106a03:	78 33                	js     80106a38 <sys_read+0x78>
80106a05:	83 ec 04             	sub    $0x4,%esp
80106a08:	ff 75 f0             	push   -0x10(%ebp)
80106a0b:	53                   	push   %ebx
80106a0c:	6a 01                	push   $0x1
80106a0e:	e8 4d fc ff ff       	call   80106660 <argptr>
80106a13:	83 c4 10             	add    $0x10,%esp
80106a16:	85 c0                	test   %eax,%eax
80106a18:	78 1e                	js     80106a38 <sys_read+0x78>
  return fileread(f, p, n);
80106a1a:	83 ec 04             	sub    $0x4,%esp
80106a1d:	ff 75 f0             	push   -0x10(%ebp)
80106a20:	ff 75 f4             	push   -0xc(%ebp)
80106a23:	56                   	push   %esi
80106a24:	e8 b7 bb ff ff       	call   801025e0 <fileread>
80106a29:	83 c4 10             	add    $0x10,%esp
}
80106a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a2f:	5b                   	pop    %ebx
80106a30:	5e                   	pop    %esi
80106a31:	5d                   	pop    %ebp
80106a32:	c3                   	ret
80106a33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3d:	eb ed                	jmp    80106a2c <sys_read+0x6c>
80106a3f:	90                   	nop

80106a40 <sys_write>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	56                   	push   %esi
80106a44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106a45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106a48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106a4b:	53                   	push   %ebx
80106a4c:	6a 00                	push   $0x0
80106a4e:	e8 bd fb ff ff       	call   80106610 <argint>
80106a53:	83 c4 10             	add    $0x10,%esp
80106a56:	85 c0                	test   %eax,%eax
80106a58:	78 5e                	js     80106ab8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106a5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106a5e:	77 58                	ja     80106ab8 <sys_write+0x78>
80106a60:	e8 4b e6 ff ff       	call   801050b0 <myproc>
80106a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106a6c:	85 f6                	test   %esi,%esi
80106a6e:	74 48                	je     80106ab8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a70:	83 ec 08             	sub    $0x8,%esp
80106a73:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a76:	50                   	push   %eax
80106a77:	6a 02                	push   $0x2
80106a79:	e8 92 fb ff ff       	call   80106610 <argint>
80106a7e:	83 c4 10             	add    $0x10,%esp
80106a81:	85 c0                	test   %eax,%eax
80106a83:	78 33                	js     80106ab8 <sys_write+0x78>
80106a85:	83 ec 04             	sub    $0x4,%esp
80106a88:	ff 75 f0             	push   -0x10(%ebp)
80106a8b:	53                   	push   %ebx
80106a8c:	6a 01                	push   $0x1
80106a8e:	e8 cd fb ff ff       	call   80106660 <argptr>
80106a93:	83 c4 10             	add    $0x10,%esp
80106a96:	85 c0                	test   %eax,%eax
80106a98:	78 1e                	js     80106ab8 <sys_write+0x78>
  return filewrite(f, p, n);
80106a9a:	83 ec 04             	sub    $0x4,%esp
80106a9d:	ff 75 f0             	push   -0x10(%ebp)
80106aa0:	ff 75 f4             	push   -0xc(%ebp)
80106aa3:	56                   	push   %esi
80106aa4:	e8 c7 bb ff ff       	call   80102670 <filewrite>
80106aa9:	83 c4 10             	add    $0x10,%esp
}
80106aac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106aaf:	5b                   	pop    %ebx
80106ab0:	5e                   	pop    %esi
80106ab1:	5d                   	pop    %ebp
80106ab2:	c3                   	ret
80106ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80106ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106abd:	eb ed                	jmp    80106aac <sys_write+0x6c>
80106abf:	90                   	nop

80106ac0 <sys_close>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	56                   	push   %esi
80106ac4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106ac5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106ac8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106acb:	50                   	push   %eax
80106acc:	6a 00                	push   $0x0
80106ace:	e8 3d fb ff ff       	call   80106610 <argint>
80106ad3:	83 c4 10             	add    $0x10,%esp
80106ad6:	85 c0                	test   %eax,%eax
80106ad8:	78 3e                	js     80106b18 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106ada:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106ade:	77 38                	ja     80106b18 <sys_close+0x58>
80106ae0:	e8 cb e5 ff ff       	call   801050b0 <myproc>
80106ae5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ae8:	8d 5a 08             	lea    0x8(%edx),%ebx
80106aeb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80106aef:	85 f6                	test   %esi,%esi
80106af1:	74 25                	je     80106b18 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106af3:	e8 b8 e5 ff ff       	call   801050b0 <myproc>
  fileclose(f);
80106af8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106afb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80106b02:	00 
  fileclose(f);
80106b03:	56                   	push   %esi
80106b04:	e8 a7 b9 ff ff       	call   801024b0 <fileclose>
  return 0;
80106b09:	83 c4 10             	add    $0x10,%esp
80106b0c:	31 c0                	xor    %eax,%eax
}
80106b0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b11:	5b                   	pop    %ebx
80106b12:	5e                   	pop    %esi
80106b13:	5d                   	pop    %ebp
80106b14:	c3                   	ret
80106b15:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1d:	eb ef                	jmp    80106b0e <sys_close+0x4e>
80106b1f:	90                   	nop

80106b20 <sys_fstat>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	56                   	push   %esi
80106b24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106b25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106b28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80106b2b:	53                   	push   %ebx
80106b2c:	6a 00                	push   $0x0
80106b2e:	e8 dd fa ff ff       	call   80106610 <argint>
80106b33:	83 c4 10             	add    $0x10,%esp
80106b36:	85 c0                	test   %eax,%eax
80106b38:	78 46                	js     80106b80 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80106b3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106b3e:	77 40                	ja     80106b80 <sys_fstat+0x60>
80106b40:	e8 6b e5 ff ff       	call   801050b0 <myproc>
80106b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80106b4c:	85 f6                	test   %esi,%esi
80106b4e:	74 30                	je     80106b80 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106b50:	83 ec 04             	sub    $0x4,%esp
80106b53:	6a 14                	push   $0x14
80106b55:	53                   	push   %ebx
80106b56:	6a 01                	push   $0x1
80106b58:	e8 03 fb ff ff       	call   80106660 <argptr>
80106b5d:	83 c4 10             	add    $0x10,%esp
80106b60:	85 c0                	test   %eax,%eax
80106b62:	78 1c                	js     80106b80 <sys_fstat+0x60>
  return filestat(f, st);
80106b64:	83 ec 08             	sub    $0x8,%esp
80106b67:	ff 75 f4             	push   -0xc(%ebp)
80106b6a:	56                   	push   %esi
80106b6b:	e8 20 ba ff ff       	call   80102590 <filestat>
80106b70:	83 c4 10             	add    $0x10,%esp
}
80106b73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b76:	5b                   	pop    %ebx
80106b77:	5e                   	pop    %esi
80106b78:	5d                   	pop    %ebp
80106b79:	c3                   	ret
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b85:	eb ec                	jmp    80106b73 <sys_fstat+0x53>
80106b87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b8e:	00 
80106b8f:	90                   	nop

80106b90 <sys_link>:
{
80106b90:	55                   	push   %ebp
80106b91:	89 e5                	mov    %esp,%ebp
80106b93:	57                   	push   %edi
80106b94:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106b95:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106b98:	53                   	push   %ebx
80106b99:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106b9c:	50                   	push   %eax
80106b9d:	6a 00                	push   $0x0
80106b9f:	e8 2c fb ff ff       	call   801066d0 <argstr>
80106ba4:	83 c4 10             	add    $0x10,%esp
80106ba7:	85 c0                	test   %eax,%eax
80106ba9:	0f 88 fb 00 00 00    	js     80106caa <sys_link+0x11a>
80106baf:	83 ec 08             	sub    $0x8,%esp
80106bb2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106bb5:	50                   	push   %eax
80106bb6:	6a 01                	push   $0x1
80106bb8:	e8 13 fb ff ff       	call   801066d0 <argstr>
80106bbd:	83 c4 10             	add    $0x10,%esp
80106bc0:	85 c0                	test   %eax,%eax
80106bc2:	0f 88 e2 00 00 00    	js     80106caa <sys_link+0x11a>
  begin_op();
80106bc8:	e8 13 d7 ff ff       	call   801042e0 <begin_op>
  if((ip = namei(old)) == 0){
80106bcd:	83 ec 0c             	sub    $0xc,%esp
80106bd0:	ff 75 d4             	push   -0x2c(%ebp)
80106bd3:	e8 48 ca ff ff       	call   80103620 <namei>
80106bd8:	83 c4 10             	add    $0x10,%esp
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	85 c0                	test   %eax,%eax
80106bdf:	0f 84 df 00 00 00    	je     80106cc4 <sys_link+0x134>
  ilock(ip);
80106be5:	83 ec 0c             	sub    $0xc,%esp
80106be8:	50                   	push   %eax
80106be9:	e8 52 c1 ff ff       	call   80102d40 <ilock>
  if(ip->type == T_DIR){
80106bee:	83 c4 10             	add    $0x10,%esp
80106bf1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106bf6:	0f 84 b5 00 00 00    	je     80106cb1 <sys_link+0x121>
  iupdate(ip);
80106bfc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106bff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106c04:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80106c07:	53                   	push   %ebx
80106c08:	e8 83 c0 ff ff       	call   80102c90 <iupdate>
  iunlock(ip);
80106c0d:	89 1c 24             	mov    %ebx,(%esp)
80106c10:	e8 0b c2 ff ff       	call   80102e20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106c15:	58                   	pop    %eax
80106c16:	5a                   	pop    %edx
80106c17:	57                   	push   %edi
80106c18:	ff 75 d0             	push   -0x30(%ebp)
80106c1b:	e8 20 ca ff ff       	call   80103640 <nameiparent>
80106c20:	83 c4 10             	add    $0x10,%esp
80106c23:	89 c6                	mov    %eax,%esi
80106c25:	85 c0                	test   %eax,%eax
80106c27:	74 5b                	je     80106c84 <sys_link+0xf4>
  ilock(dp);
80106c29:	83 ec 0c             	sub    $0xc,%esp
80106c2c:	50                   	push   %eax
80106c2d:	e8 0e c1 ff ff       	call   80102d40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106c32:	8b 03                	mov    (%ebx),%eax
80106c34:	83 c4 10             	add    $0x10,%esp
80106c37:	39 06                	cmp    %eax,(%esi)
80106c39:	75 3d                	jne    80106c78 <sys_link+0xe8>
80106c3b:	83 ec 04             	sub    $0x4,%esp
80106c3e:	ff 73 04             	push   0x4(%ebx)
80106c41:	57                   	push   %edi
80106c42:	56                   	push   %esi
80106c43:	e8 18 c9 ff ff       	call   80103560 <dirlink>
80106c48:	83 c4 10             	add    $0x10,%esp
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	78 29                	js     80106c78 <sys_link+0xe8>
  iunlockput(dp);
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	56                   	push   %esi
80106c53:	e8 78 c3 ff ff       	call   80102fd0 <iunlockput>
  iput(ip);
80106c58:	89 1c 24             	mov    %ebx,(%esp)
80106c5b:	e8 10 c2 ff ff       	call   80102e70 <iput>
  end_op();
80106c60:	e8 eb d6 ff ff       	call   80104350 <end_op>
  return 0;
80106c65:	83 c4 10             	add    $0x10,%esp
80106c68:	31 c0                	xor    %eax,%eax
}
80106c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c6d:	5b                   	pop    %ebx
80106c6e:	5e                   	pop    %esi
80106c6f:	5f                   	pop    %edi
80106c70:	5d                   	pop    %ebp
80106c71:	c3                   	ret
80106c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106c78:	83 ec 0c             	sub    $0xc,%esp
80106c7b:	56                   	push   %esi
80106c7c:	e8 4f c3 ff ff       	call   80102fd0 <iunlockput>
    goto bad;
80106c81:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106c84:	83 ec 0c             	sub    $0xc,%esp
80106c87:	53                   	push   %ebx
80106c88:	e8 b3 c0 ff ff       	call   80102d40 <ilock>
  ip->nlink--;
80106c8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106c92:	89 1c 24             	mov    %ebx,(%esp)
80106c95:	e8 f6 bf ff ff       	call   80102c90 <iupdate>
  iunlockput(ip);
80106c9a:	89 1c 24             	mov    %ebx,(%esp)
80106c9d:	e8 2e c3 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106ca2:	e8 a9 d6 ff ff       	call   80104350 <end_op>
  return -1;
80106ca7:	83 c4 10             	add    $0x10,%esp
    return -1;
80106caa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106caf:	eb b9                	jmp    80106c6a <sys_link+0xda>
    iunlockput(ip);
80106cb1:	83 ec 0c             	sub    $0xc,%esp
80106cb4:	53                   	push   %ebx
80106cb5:	e8 16 c3 ff ff       	call   80102fd0 <iunlockput>
    end_op();
80106cba:	e8 91 d6 ff ff       	call   80104350 <end_op>
    return -1;
80106cbf:	83 c4 10             	add    $0x10,%esp
80106cc2:	eb e6                	jmp    80106caa <sys_link+0x11a>
    end_op();
80106cc4:	e8 87 d6 ff ff       	call   80104350 <end_op>
    return -1;
80106cc9:	eb df                	jmp    80106caa <sys_link+0x11a>
80106ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106cd0 <sys_unlink>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106cd5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106cd8:	53                   	push   %ebx
80106cd9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106cdc:	50                   	push   %eax
80106cdd:	6a 00                	push   $0x0
80106cdf:	e8 ec f9 ff ff       	call   801066d0 <argstr>
80106ce4:	83 c4 10             	add    $0x10,%esp
80106ce7:	85 c0                	test   %eax,%eax
80106ce9:	0f 88 54 01 00 00    	js     80106e43 <sys_unlink+0x173>
  begin_op();
80106cef:	e8 ec d5 ff ff       	call   801042e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106cf4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106cf7:	83 ec 08             	sub    $0x8,%esp
80106cfa:	53                   	push   %ebx
80106cfb:	ff 75 c0             	push   -0x40(%ebp)
80106cfe:	e8 3d c9 ff ff       	call   80103640 <nameiparent>
80106d03:	83 c4 10             	add    $0x10,%esp
80106d06:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	0f 84 58 01 00 00    	je     80106e69 <sys_unlink+0x199>
  ilock(dp);
80106d11:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106d14:	83 ec 0c             	sub    $0xc,%esp
80106d17:	57                   	push   %edi
80106d18:	e8 23 c0 ff ff       	call   80102d40 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106d1d:	58                   	pop    %eax
80106d1e:	5a                   	pop    %edx
80106d1f:	68 7c 99 10 80       	push   $0x8010997c
80106d24:	53                   	push   %ebx
80106d25:	e8 46 c5 ff ff       	call   80103270 <namecmp>
80106d2a:	83 c4 10             	add    $0x10,%esp
80106d2d:	85 c0                	test   %eax,%eax
80106d2f:	0f 84 fb 00 00 00    	je     80106e30 <sys_unlink+0x160>
80106d35:	83 ec 08             	sub    $0x8,%esp
80106d38:	68 7b 99 10 80       	push   $0x8010997b
80106d3d:	53                   	push   %ebx
80106d3e:	e8 2d c5 ff ff       	call   80103270 <namecmp>
80106d43:	83 c4 10             	add    $0x10,%esp
80106d46:	85 c0                	test   %eax,%eax
80106d48:	0f 84 e2 00 00 00    	je     80106e30 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80106d4e:	83 ec 04             	sub    $0x4,%esp
80106d51:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106d54:	50                   	push   %eax
80106d55:	53                   	push   %ebx
80106d56:	57                   	push   %edi
80106d57:	e8 34 c5 ff ff       	call   80103290 <dirlookup>
80106d5c:	83 c4 10             	add    $0x10,%esp
80106d5f:	89 c3                	mov    %eax,%ebx
80106d61:	85 c0                	test   %eax,%eax
80106d63:	0f 84 c7 00 00 00    	je     80106e30 <sys_unlink+0x160>
  ilock(ip);
80106d69:	83 ec 0c             	sub    $0xc,%esp
80106d6c:	50                   	push   %eax
80106d6d:	e8 ce bf ff ff       	call   80102d40 <ilock>
  if(ip->nlink < 1)
80106d72:	83 c4 10             	add    $0x10,%esp
80106d75:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106d7a:	0f 8e 0a 01 00 00    	jle    80106e8a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106d80:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106d85:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106d88:	74 66                	je     80106df0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106d8a:	83 ec 04             	sub    $0x4,%esp
80106d8d:	6a 10                	push   $0x10
80106d8f:	6a 00                	push   $0x0
80106d91:	57                   	push   %edi
80106d92:	e8 c9 f5 ff ff       	call   80106360 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106d97:	6a 10                	push   $0x10
80106d99:	ff 75 c4             	push   -0x3c(%ebp)
80106d9c:	57                   	push   %edi
80106d9d:	ff 75 b4             	push   -0x4c(%ebp)
80106da0:	e8 ab c3 ff ff       	call   80103150 <writei>
80106da5:	83 c4 20             	add    $0x20,%esp
80106da8:	83 f8 10             	cmp    $0x10,%eax
80106dab:	0f 85 cc 00 00 00    	jne    80106e7d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80106db1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106db6:	0f 84 94 00 00 00    	je     80106e50 <sys_unlink+0x180>
  iunlockput(dp);
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	ff 75 b4             	push   -0x4c(%ebp)
80106dc2:	e8 09 c2 ff ff       	call   80102fd0 <iunlockput>
  ip->nlink--;
80106dc7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106dcc:	89 1c 24             	mov    %ebx,(%esp)
80106dcf:	e8 bc be ff ff       	call   80102c90 <iupdate>
  iunlockput(ip);
80106dd4:	89 1c 24             	mov    %ebx,(%esp)
80106dd7:	e8 f4 c1 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106ddc:	e8 6f d5 ff ff       	call   80104350 <end_op>
  return 0;
80106de1:	83 c4 10             	add    $0x10,%esp
80106de4:	31 c0                	xor    %eax,%eax
}
80106de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de9:	5b                   	pop    %ebx
80106dea:	5e                   	pop    %esi
80106deb:	5f                   	pop    %edi
80106dec:	5d                   	pop    %ebp
80106ded:	c3                   	ret
80106dee:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106df0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106df4:	76 94                	jbe    80106d8a <sys_unlink+0xba>
80106df6:	be 20 00 00 00       	mov    $0x20,%esi
80106dfb:	eb 0b                	jmp    80106e08 <sys_unlink+0x138>
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
80106e00:	83 c6 10             	add    $0x10,%esi
80106e03:	3b 73 58             	cmp    0x58(%ebx),%esi
80106e06:	73 82                	jae    80106d8a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106e08:	6a 10                	push   $0x10
80106e0a:	56                   	push   %esi
80106e0b:	57                   	push   %edi
80106e0c:	53                   	push   %ebx
80106e0d:	e8 3e c2 ff ff       	call   80103050 <readi>
80106e12:	83 c4 10             	add    $0x10,%esp
80106e15:	83 f8 10             	cmp    $0x10,%eax
80106e18:	75 56                	jne    80106e70 <sys_unlink+0x1a0>
    if(de.inum != 0)
80106e1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106e1f:	74 df                	je     80106e00 <sys_unlink+0x130>
    iunlockput(ip);
80106e21:	83 ec 0c             	sub    $0xc,%esp
80106e24:	53                   	push   %ebx
80106e25:	e8 a6 c1 ff ff       	call   80102fd0 <iunlockput>
    goto bad;
80106e2a:	83 c4 10             	add    $0x10,%esp
80106e2d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106e30:	83 ec 0c             	sub    $0xc,%esp
80106e33:	ff 75 b4             	push   -0x4c(%ebp)
80106e36:	e8 95 c1 ff ff       	call   80102fd0 <iunlockput>
  end_op();
80106e3b:	e8 10 d5 ff ff       	call   80104350 <end_op>
  return -1;
80106e40:	83 c4 10             	add    $0x10,%esp
    return -1;
80106e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e48:	eb 9c                	jmp    80106de6 <sys_unlink+0x116>
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106e50:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106e53:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106e56:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80106e5b:	50                   	push   %eax
80106e5c:	e8 2f be ff ff       	call   80102c90 <iupdate>
80106e61:	83 c4 10             	add    $0x10,%esp
80106e64:	e9 53 ff ff ff       	jmp    80106dbc <sys_unlink+0xec>
    end_op();
80106e69:	e8 e2 d4 ff ff       	call   80104350 <end_op>
    return -1;
80106e6e:	eb d3                	jmp    80106e43 <sys_unlink+0x173>
      panic("isdirempty: readi");
80106e70:	83 ec 0c             	sub    $0xc,%esp
80106e73:	68 a0 99 10 80       	push   $0x801099a0
80106e78:	e8 d3 96 ff ff       	call   80100550 <panic>
    panic("unlink: writei");
80106e7d:	83 ec 0c             	sub    $0xc,%esp
80106e80:	68 b2 99 10 80       	push   $0x801099b2
80106e85:	e8 c6 96 ff ff       	call   80100550 <panic>
    panic("unlink: nlink < 1");
80106e8a:	83 ec 0c             	sub    $0xc,%esp
80106e8d:	68 8e 99 10 80       	push   $0x8010998e
80106e92:	e8 b9 96 ff ff       	call   80100550 <panic>
80106e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e9e:	00 
80106e9f:	90                   	nop

80106ea0 <sys_open>:

int
sys_open(void)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106ea5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106ea8:	53                   	push   %ebx
80106ea9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106eac:	50                   	push   %eax
80106ead:	6a 00                	push   $0x0
80106eaf:	e8 1c f8 ff ff       	call   801066d0 <argstr>
80106eb4:	83 c4 10             	add    $0x10,%esp
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	0f 88 8e 00 00 00    	js     80106f4d <sys_open+0xad>
80106ebf:	83 ec 08             	sub    $0x8,%esp
80106ec2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ec5:	50                   	push   %eax
80106ec6:	6a 01                	push   $0x1
80106ec8:	e8 43 f7 ff ff       	call   80106610 <argint>
80106ecd:	83 c4 10             	add    $0x10,%esp
80106ed0:	85 c0                	test   %eax,%eax
80106ed2:	78 79                	js     80106f4d <sys_open+0xad>
    return -1;

  begin_op();
80106ed4:	e8 07 d4 ff ff       	call   801042e0 <begin_op>

  if(omode & O_CREATE){
80106ed9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106edd:	75 79                	jne    80106f58 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106edf:	83 ec 0c             	sub    $0xc,%esp
80106ee2:	ff 75 e0             	push   -0x20(%ebp)
80106ee5:	e8 36 c7 ff ff       	call   80103620 <namei>
80106eea:	83 c4 10             	add    $0x10,%esp
80106eed:	89 c6                	mov    %eax,%esi
80106eef:	85 c0                	test   %eax,%eax
80106ef1:	0f 84 7e 00 00 00    	je     80106f75 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106ef7:	83 ec 0c             	sub    $0xc,%esp
80106efa:	50                   	push   %eax
80106efb:	e8 40 be ff ff       	call   80102d40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106f00:	83 c4 10             	add    $0x10,%esp
80106f03:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106f08:	0f 84 ba 00 00 00    	je     80106fc8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106f0e:	e8 dd b4 ff ff       	call   801023f0 <filealloc>
80106f13:	89 c7                	mov    %eax,%edi
80106f15:	85 c0                	test   %eax,%eax
80106f17:	74 23                	je     80106f3c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106f19:	e8 92 e1 ff ff       	call   801050b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106f1e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106f20:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106f24:	85 d2                	test   %edx,%edx
80106f26:	74 58                	je     80106f80 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80106f28:	83 c3 01             	add    $0x1,%ebx
80106f2b:	83 fb 10             	cmp    $0x10,%ebx
80106f2e:	75 f0                	jne    80106f20 <sys_open+0x80>
    if(f)
      fileclose(f);
80106f30:	83 ec 0c             	sub    $0xc,%esp
80106f33:	57                   	push   %edi
80106f34:	e8 77 b5 ff ff       	call   801024b0 <fileclose>
80106f39:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	56                   	push   %esi
80106f40:	e8 8b c0 ff ff       	call   80102fd0 <iunlockput>
    end_op();
80106f45:	e8 06 d4 ff ff       	call   80104350 <end_op>
    return -1;
80106f4a:	83 c4 10             	add    $0x10,%esp
    return -1;
80106f4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106f52:	eb 65                	jmp    80106fb9 <sys_open+0x119>
80106f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106f58:	83 ec 0c             	sub    $0xc,%esp
80106f5b:	31 c9                	xor    %ecx,%ecx
80106f5d:	ba 02 00 00 00       	mov    $0x2,%edx
80106f62:	6a 00                	push   $0x0
80106f64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f67:	e8 54 f8 ff ff       	call   801067c0 <create>
    if(ip == 0){
80106f6c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106f6f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106f71:	85 c0                	test   %eax,%eax
80106f73:	75 99                	jne    80106f0e <sys_open+0x6e>
      end_op();
80106f75:	e8 d6 d3 ff ff       	call   80104350 <end_op>
      return -1;
80106f7a:	eb d1                	jmp    80106f4d <sys_open+0xad>
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106f80:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106f83:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106f87:	56                   	push   %esi
80106f88:	e8 93 be ff ff       	call   80102e20 <iunlock>
  end_op();
80106f8d:	e8 be d3 ff ff       	call   80104350 <end_op>

  f->type = FD_INODE;
80106f92:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106f98:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106f9b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106f9e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106fa1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106fa3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106faa:	f7 d0                	not    %eax
80106fac:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106faf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106fb2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106fb5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbc:	89 d8                	mov    %ebx,%eax
80106fbe:	5b                   	pop    %ebx
80106fbf:	5e                   	pop    %esi
80106fc0:	5f                   	pop    %edi
80106fc1:	5d                   	pop    %ebp
80106fc2:	c3                   	ret
80106fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106fc8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fcb:	85 c9                	test   %ecx,%ecx
80106fcd:	0f 84 3b ff ff ff    	je     80106f0e <sys_open+0x6e>
80106fd3:	e9 64 ff ff ff       	jmp    80106f3c <sys_open+0x9c>
80106fd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fdf:	00 

80106fe0 <sys_mkdir>:

int
sys_mkdir(void)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106fe6:	e8 f5 d2 ff ff       	call   801042e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106feb:	83 ec 08             	sub    $0x8,%esp
80106fee:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ff1:	50                   	push   %eax
80106ff2:	6a 00                	push   $0x0
80106ff4:	e8 d7 f6 ff ff       	call   801066d0 <argstr>
80106ff9:	83 c4 10             	add    $0x10,%esp
80106ffc:	85 c0                	test   %eax,%eax
80106ffe:	78 30                	js     80107030 <sys_mkdir+0x50>
80107000:	83 ec 0c             	sub    $0xc,%esp
80107003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107006:	31 c9                	xor    %ecx,%ecx
80107008:	ba 01 00 00 00       	mov    $0x1,%edx
8010700d:	6a 00                	push   $0x0
8010700f:	e8 ac f7 ff ff       	call   801067c0 <create>
80107014:	83 c4 10             	add    $0x10,%esp
80107017:	85 c0                	test   %eax,%eax
80107019:	74 15                	je     80107030 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010701b:	83 ec 0c             	sub    $0xc,%esp
8010701e:	50                   	push   %eax
8010701f:	e8 ac bf ff ff       	call   80102fd0 <iunlockput>
  end_op();
80107024:	e8 27 d3 ff ff       	call   80104350 <end_op>
  return 0;
80107029:	83 c4 10             	add    $0x10,%esp
8010702c:	31 c0                	xor    %eax,%eax
}
8010702e:	c9                   	leave
8010702f:	c3                   	ret
    end_op();
80107030:	e8 1b d3 ff ff       	call   80104350 <end_op>
    return -1;
80107035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010703a:	c9                   	leave
8010703b:	c3                   	ret
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107040 <sys_mknod>:

int
sys_mknod(void)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80107046:	e8 95 d2 ff ff       	call   801042e0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010704b:	83 ec 08             	sub    $0x8,%esp
8010704e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107051:	50                   	push   %eax
80107052:	6a 00                	push   $0x0
80107054:	e8 77 f6 ff ff       	call   801066d0 <argstr>
80107059:	83 c4 10             	add    $0x10,%esp
8010705c:	85 c0                	test   %eax,%eax
8010705e:	78 60                	js     801070c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80107060:	83 ec 08             	sub    $0x8,%esp
80107063:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107066:	50                   	push   %eax
80107067:	6a 01                	push   $0x1
80107069:	e8 a2 f5 ff ff       	call   80106610 <argint>
  if((argstr(0, &path)) < 0 ||
8010706e:	83 c4 10             	add    $0x10,%esp
80107071:	85 c0                	test   %eax,%eax
80107073:	78 4b                	js     801070c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80107075:	83 ec 08             	sub    $0x8,%esp
80107078:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010707b:	50                   	push   %eax
8010707c:	6a 02                	push   $0x2
8010707e:	e8 8d f5 ff ff       	call   80106610 <argint>
     argint(1, &major) < 0 ||
80107083:	83 c4 10             	add    $0x10,%esp
80107086:	85 c0                	test   %eax,%eax
80107088:	78 36                	js     801070c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010708a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010708e:	83 ec 0c             	sub    $0xc,%esp
80107091:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107095:	ba 03 00 00 00       	mov    $0x3,%edx
8010709a:	50                   	push   %eax
8010709b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010709e:	e8 1d f7 ff ff       	call   801067c0 <create>
     argint(2, &minor) < 0 ||
801070a3:	83 c4 10             	add    $0x10,%esp
801070a6:	85 c0                	test   %eax,%eax
801070a8:	74 16                	je     801070c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801070aa:	83 ec 0c             	sub    $0xc,%esp
801070ad:	50                   	push   %eax
801070ae:	e8 1d bf ff ff       	call   80102fd0 <iunlockput>
  end_op();
801070b3:	e8 98 d2 ff ff       	call   80104350 <end_op>
  return 0;
801070b8:	83 c4 10             	add    $0x10,%esp
801070bb:	31 c0                	xor    %eax,%eax
}
801070bd:	c9                   	leave
801070be:	c3                   	ret
801070bf:	90                   	nop
    end_op();
801070c0:	e8 8b d2 ff ff       	call   80104350 <end_op>
    return -1;
801070c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070ca:	c9                   	leave
801070cb:	c3                   	ret
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070d0 <sys_chdir>:

int
sys_chdir(void)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	56                   	push   %esi
801070d4:	53                   	push   %ebx
801070d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801070d8:	e8 d3 df ff ff       	call   801050b0 <myproc>
801070dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801070df:	e8 fc d1 ff ff       	call   801042e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801070e4:	83 ec 08             	sub    $0x8,%esp
801070e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070ea:	50                   	push   %eax
801070eb:	6a 00                	push   $0x0
801070ed:	e8 de f5 ff ff       	call   801066d0 <argstr>
801070f2:	83 c4 10             	add    $0x10,%esp
801070f5:	85 c0                	test   %eax,%eax
801070f7:	78 77                	js     80107170 <sys_chdir+0xa0>
801070f9:	83 ec 0c             	sub    $0xc,%esp
801070fc:	ff 75 f4             	push   -0xc(%ebp)
801070ff:	e8 1c c5 ff ff       	call   80103620 <namei>
80107104:	83 c4 10             	add    $0x10,%esp
80107107:	89 c3                	mov    %eax,%ebx
80107109:	85 c0                	test   %eax,%eax
8010710b:	74 63                	je     80107170 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010710d:	83 ec 0c             	sub    $0xc,%esp
80107110:	50                   	push   %eax
80107111:	e8 2a bc ff ff       	call   80102d40 <ilock>
  if(ip->type != T_DIR){
80107116:	83 c4 10             	add    $0x10,%esp
80107119:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010711e:	75 30                	jne    80107150 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80107120:	83 ec 0c             	sub    $0xc,%esp
80107123:	53                   	push   %ebx
80107124:	e8 f7 bc ff ff       	call   80102e20 <iunlock>
  iput(curproc->cwd);
80107129:	58                   	pop    %eax
8010712a:	ff 76 68             	push   0x68(%esi)
8010712d:	e8 3e bd ff ff       	call   80102e70 <iput>
  end_op();
80107132:	e8 19 d2 ff ff       	call   80104350 <end_op>
  curproc->cwd = ip;
80107137:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010713a:	83 c4 10             	add    $0x10,%esp
8010713d:	31 c0                	xor    %eax,%eax
}
8010713f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107142:	5b                   	pop    %ebx
80107143:	5e                   	pop    %esi
80107144:	5d                   	pop    %ebp
80107145:	c3                   	ret
80107146:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010714d:	00 
8010714e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	53                   	push   %ebx
80107154:	e8 77 be ff ff       	call   80102fd0 <iunlockput>
    end_op();
80107159:	e8 f2 d1 ff ff       	call   80104350 <end_op>
    return -1;
8010715e:	83 c4 10             	add    $0x10,%esp
    return -1;
80107161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107166:	eb d7                	jmp    8010713f <sys_chdir+0x6f>
80107168:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010716f:	00 
    end_op();
80107170:	e8 db d1 ff ff       	call   80104350 <end_op>
    return -1;
80107175:	eb ea                	jmp    80107161 <sys_chdir+0x91>
80107177:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010717e:	00 
8010717f:	90                   	nop

80107180 <sys_exec>:

int
sys_exec(void)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107185:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010718b:	53                   	push   %ebx
8010718c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107192:	50                   	push   %eax
80107193:	6a 00                	push   $0x0
80107195:	e8 36 f5 ff ff       	call   801066d0 <argstr>
8010719a:	83 c4 10             	add    $0x10,%esp
8010719d:	85 c0                	test   %eax,%eax
8010719f:	0f 88 87 00 00 00    	js     8010722c <sys_exec+0xac>
801071a5:	83 ec 08             	sub    $0x8,%esp
801071a8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801071ae:	50                   	push   %eax
801071af:	6a 01                	push   $0x1
801071b1:	e8 5a f4 ff ff       	call   80106610 <argint>
801071b6:	83 c4 10             	add    $0x10,%esp
801071b9:	85 c0                	test   %eax,%eax
801071bb:	78 6f                	js     8010722c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801071bd:	83 ec 04             	sub    $0x4,%esp
801071c0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801071c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801071c8:	68 80 00 00 00       	push   $0x80
801071cd:	6a 00                	push   $0x0
801071cf:	56                   	push   %esi
801071d0:	e8 8b f1 ff ff       	call   80106360 <memset>
801071d5:	83 c4 10             	add    $0x10,%esp
801071d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071df:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801071e0:	83 ec 08             	sub    $0x8,%esp
801071e3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801071e9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801071f0:	50                   	push   %eax
801071f1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801071f7:	01 f8                	add    %edi,%eax
801071f9:	50                   	push   %eax
801071fa:	e8 81 f3 ff ff       	call   80106580 <fetchint>
801071ff:	83 c4 10             	add    $0x10,%esp
80107202:	85 c0                	test   %eax,%eax
80107204:	78 26                	js     8010722c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80107206:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010720c:	85 c0                	test   %eax,%eax
8010720e:	74 30                	je     80107240 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107210:	83 ec 08             	sub    $0x8,%esp
80107213:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80107216:	52                   	push   %edx
80107217:	50                   	push   %eax
80107218:	e8 a3 f3 ff ff       	call   801065c0 <fetchstr>
8010721d:	83 c4 10             	add    $0x10,%esp
80107220:	85 c0                	test   %eax,%eax
80107222:	78 08                	js     8010722c <sys_exec+0xac>
  for(i=0;; i++){
80107224:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80107227:	83 fb 20             	cmp    $0x20,%ebx
8010722a:	75 b4                	jne    801071e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010722c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010722f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107234:	5b                   	pop    %ebx
80107235:	5e                   	pop    %esi
80107236:	5f                   	pop    %edi
80107237:	5d                   	pop    %ebp
80107238:	c3                   	ret
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80107240:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80107247:	00 00 00 00 
  return exec(path, argv);
8010724b:	83 ec 08             	sub    $0x8,%esp
8010724e:	56                   	push   %esi
8010724f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80107255:	e8 f6 ad ff ff       	call   80102050 <exec>
8010725a:	83 c4 10             	add    $0x10,%esp
}
8010725d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107260:	5b                   	pop    %ebx
80107261:	5e                   	pop    %esi
80107262:	5f                   	pop    %edi
80107263:	5d                   	pop    %ebp
80107264:	c3                   	ret
80107265:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010726c:	00 
8010726d:	8d 76 00             	lea    0x0(%esi),%esi

80107270 <sys_pipe>:

int
sys_pipe(void)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107275:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80107278:	53                   	push   %ebx
80107279:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010727c:	6a 08                	push   $0x8
8010727e:	50                   	push   %eax
8010727f:	6a 00                	push   $0x0
80107281:	e8 da f3 ff ff       	call   80106660 <argptr>
80107286:	83 c4 10             	add    $0x10,%esp
80107289:	85 c0                	test   %eax,%eax
8010728b:	0f 88 8b 00 00 00    	js     8010731c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80107291:	83 ec 08             	sub    $0x8,%esp
80107294:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107297:	50                   	push   %eax
80107298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010729b:	50                   	push   %eax
8010729c:	e8 0f d7 ff ff       	call   801049b0 <pipealloc>
801072a1:	83 c4 10             	add    $0x10,%esp
801072a4:	85 c0                	test   %eax,%eax
801072a6:	78 74                	js     8010731c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801072a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801072ab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801072ad:	e8 fe dd ff ff       	call   801050b0 <myproc>
    if(curproc->ofile[fd] == 0){
801072b2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801072b6:	85 f6                	test   %esi,%esi
801072b8:	74 16                	je     801072d0 <sys_pipe+0x60>
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801072c0:	83 c3 01             	add    $0x1,%ebx
801072c3:	83 fb 10             	cmp    $0x10,%ebx
801072c6:	74 3d                	je     80107305 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801072c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801072cc:	85 f6                	test   %esi,%esi
801072ce:	75 f0                	jne    801072c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801072d0:	8d 73 08             	lea    0x8(%ebx),%esi
801072d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801072d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801072da:	e8 d1 dd ff ff       	call   801050b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801072df:	31 d2                	xor    %edx,%edx
801072e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801072e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801072ec:	85 c9                	test   %ecx,%ecx
801072ee:	74 38                	je     80107328 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801072f0:	83 c2 01             	add    $0x1,%edx
801072f3:	83 fa 10             	cmp    $0x10,%edx
801072f6:	75 f0                	jne    801072e8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801072f8:	e8 b3 dd ff ff       	call   801050b0 <myproc>
801072fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107304:	00 
    fileclose(rf);
80107305:	83 ec 0c             	sub    $0xc,%esp
80107308:	ff 75 e0             	push   -0x20(%ebp)
8010730b:	e8 a0 b1 ff ff       	call   801024b0 <fileclose>
    fileclose(wf);
80107310:	58                   	pop    %eax
80107311:	ff 75 e4             	push   -0x1c(%ebp)
80107314:	e8 97 b1 ff ff       	call   801024b0 <fileclose>
    return -1;
80107319:	83 c4 10             	add    $0x10,%esp
    return -1;
8010731c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107321:	eb 16                	jmp    80107339 <sys_pipe+0xc9>
80107323:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80107328:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010732c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010732f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80107331:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107334:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80107337:	31 c0                	xor    %eax,%eax
}
80107339:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010733c:	5b                   	pop    %ebx
8010733d:	5e                   	pop    %esi
8010733e:	5f                   	pop    %edi
8010733f:	5d                   	pop    %ebp
80107340:	c3                   	ret
80107341:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107348:	00 
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107350 <sys_make_duplicate_file>:

int
sys_make_duplicate_file(void)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
  char *org;
  char newname[MAXPATH];
  struct inode *orgi, *newi;

  if(argstr(0, &org) < 0)
80107355:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
{
8010735b:	53                   	push   %ebx
8010735c:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  if(argstr(0, &org) < 0)
80107362:	50                   	push   %eax
80107363:	6a 00                	push   $0x0
80107365:	e8 66 f3 ff ff       	call   801066d0 <argstr>
8010736a:	83 c4 10             	add    $0x10,%esp
8010736d:	85 c0                	test   %eax,%eax
8010736f:	0f 88 6d 01 00 00    	js     801074e2 <sys_make_duplicate_file+0x192>
    return -1;

  int olen = strlen(org);
80107375:	83 ec 0c             	sub    $0xc,%esp
80107378:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
8010737e:	e8 cd f1 ff ff       	call   80106550 <strlen>
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80107383:	83 c4 10             	add    $0x10,%esp
  int olen = strlen(org);
80107386:	89 c3                	mov    %eax,%ebx
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80107388:	83 f8 79             	cmp    $0x79,%eax
8010738b:	0f 8f 51 01 00 00    	jg     801074e2 <sys_make_duplicate_file+0x192>
    return -1;
  safestrcpy(newname, org, MAXPATH);
80107391:	83 ec 04             	sub    $0x4,%esp
80107394:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010739a:	68 80 00 00 00       	push   $0x80
  memmove(newname + olen, "_copy", 6);
8010739f:	01 f3                	add    %esi,%ebx
  safestrcpy(newname, org, MAXPATH);
801073a1:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
801073a7:	56                   	push   %esi
801073a8:	e8 63 f1 ff ff       	call   80106510 <safestrcpy>
  memmove(newname + olen, "_copy", 6);
801073ad:	83 c4 0c             	add    $0xc,%esp
801073b0:	6a 06                	push   $0x6
801073b2:	68 c1 99 10 80       	push   $0x801099c1
801073b7:	53                   	push   %ebx
801073b8:	e8 33 f0 ff ff       	call   801063f0 <memmove>

  begin_op();
801073bd:	e8 1e cf ff ff       	call   801042e0 <begin_op>

  if(namei(newname) != 0){          // no locks needed for pure existence test
801073c2:	89 34 24             	mov    %esi,(%esp)
801073c5:	e8 56 c2 ff ff       	call   80103620 <namei>
801073ca:	83 c4 10             	add    $0x10,%esp
801073cd:	85 c0                	test   %eax,%eax
801073cf:	0f 85 5d 01 00 00    	jne    80107532 <sys_make_duplicate_file+0x1e2>
    end_op();
    return -1;
  }

  orgi = namei(org);
801073d5:	83 ec 0c             	sub    $0xc,%esp
801073d8:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
801073de:	e8 3d c2 ff ff       	call   80103620 <namei>
  if(!orgi){
801073e3:	83 c4 10             	add    $0x10,%esp
  orgi = namei(org);
801073e6:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
801073ec:	89 c3                	mov    %eax,%ebx
  if(!orgi){
801073ee:	85 c0                	test   %eax,%eax
801073f0:	0f 84 3c 01 00 00    	je     80107532 <sys_make_duplicate_file+0x1e2>
    end_op();
    return -1;
  }

  ilock(orgi);
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	50                   	push   %eax
801073fa:	e8 41 b9 ff ff       	call   80102d40 <ilock>
  if(orgi->type != T_FILE){
801073ff:	83 c4 10             	add    $0x10,%esp
80107402:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80107407:	0f 85 4b 01 00 00    	jne    80107558 <sys_make_duplicate_file+0x208>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = namei(newname);
8010740d:	83 ec 0c             	sub    $0xc,%esp
80107410:	56                   	push   %esi
80107411:	e8 0a c2 ff ff       	call   80103620 <namei>
  if(newi){
80107416:	83 c4 10             	add    $0x10,%esp
80107419:	85 c0                	test   %eax,%eax
8010741b:	0f 85 18 01 00 00    	jne    80107539 <sys_make_duplicate_file+0x1e9>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = create(newname, T_FILE, 0, 0);
80107421:	83 ec 0c             	sub    $0xc,%esp
80107424:	31 c9                	xor    %ecx,%ecx
80107426:	ba 02 00 00 00       	mov    $0x2,%edx
8010742b:	89 f0                	mov    %esi,%eax
8010742d:	6a 00                	push   $0x0
8010742f:	e8 8c f3 ff ff       	call   801067c0 <create>
  if(!newi){
80107434:	83 c4 10             	add    $0x10,%esp
  newi = create(newname, T_FILE, 0, 0);
80107437:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  if(!newi){
8010743d:	85 c0                	test   %eax,%eax
8010743f:	0f 84 2e 01 00 00    	je     80107573 <sys_make_duplicate_file+0x223>
    iput(orgi);
    end_op();
    return -1;
  }

  uint total = orgi->size;
80107445:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
8010744b:	8b 70 58             	mov    0x58(%eax),%esi
  char *kbuf = kalloc();
8010744e:	e8 ad c7 ff ff       	call   80103c00 <kalloc>
80107453:	89 c3                	mov    %eax,%ebx
  if(!kbuf){
80107455:	85 c0                	test   %eax,%eax
80107457:	0f 84 3a 01 00 00    	je     80107597 <sys_make_duplicate_file+0x247>
    iput(orgi);
    end_op();
    return -1;
  }

  uint done = 0;
8010745d:	31 ff                	xor    %edi,%edi
  while(done < total){
8010745f:	85 f6                	test   %esi,%esi
80107461:	75 28                	jne    8010748b <sys_make_duplicate_file+0x13b>
80107463:	e9 88 00 00 00       	jmp    801074f0 <sys_make_duplicate_file+0x1a0>
80107468:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010746f:	00 
    if(chunk > BSIZE) chunk = BSIZE;

    int got = readi(orgi, kbuf, done, chunk);
    if(got < 0) goto err;

    int put = writei(newi, kbuf, done, got);
80107470:	50                   	push   %eax
80107471:	57                   	push   %edi
80107472:	53                   	push   %ebx
80107473:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80107479:	e8 d2 bc ff ff       	call   80103150 <writei>
    if(put < 0) goto err;
8010747e:	83 c4 10             	add    $0x10,%esp
80107481:	85 c0                	test   %eax,%eax
80107483:	78 29                	js     801074ae <sys_make_duplicate_file+0x15e>

    done += put;
80107485:	01 c7                	add    %eax,%edi
  while(done < total){
80107487:	39 f7                	cmp    %esi,%edi
80107489:	73 65                	jae    801074f0 <sys_make_duplicate_file+0x1a0>
    uint chunk = total - done;
8010748b:	89 f0                	mov    %esi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
8010748d:	b9 00 02 00 00       	mov    $0x200,%ecx
    uint chunk = total - done;
80107492:	29 f8                	sub    %edi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
80107494:	39 c8                	cmp    %ecx,%eax
80107496:	0f 47 c1             	cmova  %ecx,%eax
    int got = readi(orgi, kbuf, done, chunk);
80107499:	50                   	push   %eax
8010749a:	57                   	push   %edi
8010749b:	53                   	push   %ebx
8010749c:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801074a2:	e8 a9 bb ff ff       	call   80103050 <readi>
    if(got < 0) goto err;
801074a7:	83 c4 10             	add    $0x10,%esp
801074aa:	85 c0                	test   %eax,%eax
801074ac:	79 c2                	jns    80107470 <sys_make_duplicate_file+0x120>
  kfree(kbuf);
  end_op();
  return 0;

err:
  iunlockput(newi);
801074ae:	83 ec 0c             	sub    $0xc,%esp
801074b1:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
801074b7:	e8 14 bb ff ff       	call   80102fd0 <iunlockput>
  iunlock(orgi);
801074bc:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
801074c2:	89 34 24             	mov    %esi,(%esp)
801074c5:	e8 56 b9 ff ff       	call   80102e20 <iunlock>
  iput(orgi);
801074ca:	89 34 24             	mov    %esi,(%esp)
801074cd:	e8 9e b9 ff ff       	call   80102e70 <iput>
  kfree(kbuf);
801074d2:	89 1c 24             	mov    %ebx,(%esp)
801074d5:	e8 66 c5 ff ff       	call   80103a40 <kfree>
  end_op();
801074da:	e8 71 ce ff ff       	call   80104350 <end_op>
  return -1;
801074df:	83 c4 10             	add    $0x10,%esp
}
801074e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801074e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074ea:	5b                   	pop    %ebx
801074eb:	5e                   	pop    %esi
801074ec:	5f                   	pop    %edi
801074ed:	5d                   	pop    %ebp
801074ee:	c3                   	ret
801074ef:	90                   	nop
  newi->size = total;
801074f0:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  iupdate(newi);
801074f6:	83 ec 0c             	sub    $0xc,%esp
  newi->size = total;
801074f9:	89 70 58             	mov    %esi,0x58(%eax)
  iupdate(newi);
801074fc:	89 c6                	mov    %eax,%esi
801074fe:	50                   	push   %eax
801074ff:	e8 8c b7 ff ff       	call   80102c90 <iupdate>
  iunlock(newi);
80107504:	89 34 24             	mov    %esi,(%esp)
80107507:	e8 14 b9 ff ff       	call   80102e20 <iunlock>
  iunlock(orgi);
8010750c:	58                   	pop    %eax
8010750d:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80107513:	e8 08 b9 ff ff       	call   80102e20 <iunlock>
  kfree(kbuf);
80107518:	89 1c 24             	mov    %ebx,(%esp)
8010751b:	e8 20 c5 ff ff       	call   80103a40 <kfree>
  end_op();
80107520:	e8 2b ce ff ff       	call   80104350 <end_op>
  return 0;
80107525:	83 c4 10             	add    $0x10,%esp
}
80107528:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010752b:	31 c0                	xor    %eax,%eax
}
8010752d:	5b                   	pop    %ebx
8010752e:	5e                   	pop    %esi
8010752f:	5f                   	pop    %edi
80107530:	5d                   	pop    %ebp
80107531:	c3                   	ret
    end_op();
80107532:	e8 19 ce ff ff       	call   80104350 <end_op>
    return -1;
80107537:	eb a9                	jmp    801074e2 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
80107539:	83 ec 0c             	sub    $0xc,%esp
8010753c:	50                   	push   %eax
8010753d:	e8 8e ba ff ff       	call   80102fd0 <iunlockput>
    iunlockput(orgi);
80107542:	5a                   	pop    %edx
80107543:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80107549:	e8 82 ba ff ff       	call   80102fd0 <iunlockput>
    end_op();
8010754e:	e8 fd cd ff ff       	call   80104350 <end_op>
    return -1;
80107553:	83 c4 10             	add    $0x10,%esp
80107556:	eb 8a                	jmp    801074e2 <sys_make_duplicate_file+0x192>
    iunlockput(orgi);
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80107561:	e8 6a ba ff ff       	call   80102fd0 <iunlockput>
    end_op();
80107566:	e8 e5 cd ff ff       	call   80104350 <end_op>
    return -1;
8010756b:	83 c4 10             	add    $0x10,%esp
8010756e:	e9 6f ff ff ff       	jmp    801074e2 <sys_make_duplicate_file+0x192>
    iunlock(orgi);
80107573:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
80107579:	83 ec 0c             	sub    $0xc,%esp
8010757c:	56                   	push   %esi
    iunlock(orgi);
8010757d:	e8 9e b8 ff ff       	call   80102e20 <iunlock>
    iput(orgi);
80107582:	89 34 24             	mov    %esi,(%esp)
80107585:	e8 e6 b8 ff ff       	call   80102e70 <iput>
    end_op();
8010758a:	e8 c1 cd ff ff       	call   80104350 <end_op>
    return -1;
8010758f:	83 c4 10             	add    $0x10,%esp
80107592:	e9 4b ff ff ff       	jmp    801074e2 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
80107597:	83 ec 0c             	sub    $0xc,%esp
8010759a:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
801075a0:	e8 2b ba ff ff       	call   80102fd0 <iunlockput>
    iunlock(orgi);
801075a5:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
801075ab:	89 34 24             	mov    %esi,(%esp)
801075ae:	eb cd                	jmp    8010757d <sys_make_duplicate_file+0x22d>

801075b0 <sys_grep_syscall>:
    }

    return 0;
}

int sys_grep_syscall(void){
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
    char *keyword, *filename;
    char *ubuf;
    int bufsz;

    if(argstr(0, &keyword) < 0)
801075b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_grep_syscall(void){
801075b8:	53                   	push   %ebx
801075b9:	83 ec 44             	sub    $0x44,%esp
    if(argstr(0, &keyword) < 0)
801075bc:	50                   	push   %eax
801075bd:	6a 00                	push   $0x0
801075bf:	e8 0c f1 ff ff       	call   801066d0 <argstr>
801075c4:	83 c4 10             	add    $0x10,%esp
801075c7:	85 c0                	test   %eax,%eax
801075c9:	0f 88 96 02 00 00    	js     80107865 <sys_grep_syscall+0x2b5>
        return -1;
    if((1, &filename) < 0)
        return -1;
    if(argint(3, &bufsz) < 0 || bufsz <= 1)
801075cf:	83 ec 08             	sub    $0x8,%esp
801075d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801075d5:	50                   	push   %eax
801075d6:	6a 03                	push   $0x3
801075d8:	e8 33 f0 ff ff       	call   80106610 <argint>
801075dd:	83 c4 10             	add    $0x10,%esp
801075e0:	85 c0                	test   %eax,%eax
801075e2:	0f 88 7d 02 00 00    	js     80107865 <sys_grep_syscall+0x2b5>
801075e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075eb:	83 f8 01             	cmp    $0x1,%eax
801075ee:	0f 8e 71 02 00 00    	jle    80107865 <sys_grep_syscall+0x2b5>
        return -1;
    if(argptr(2, &ubuf, bufsz) < 0)
801075f4:	83 ec 04             	sub    $0x4,%esp
801075f7:	50                   	push   %eax
801075f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801075fb:	50                   	push   %eax
801075fc:	6a 02                	push   $0x2
801075fe:	e8 5d f0 ff ff       	call   80106660 <argptr>
80107603:	83 c4 10             	add    $0x10,%esp
80107606:	85 c0                	test   %eax,%eax
80107608:	0f 88 57 02 00 00    	js     80107865 <sys_grep_syscall+0x2b5>
        return -1;

    struct inode *ip = namei(filename);
8010760e:	83 ec 0c             	sub    $0xc,%esp
80107611:	6a 00                	push   $0x0
80107613:	e8 08 c0 ff ff       	call   80103620 <namei>
    if(!ip)
80107618:	83 c4 10             	add    $0x10,%esp
    struct inode *ip = namei(filename);
8010761b:	89 45 c8             	mov    %eax,-0x38(%ebp)
8010761e:	89 c3                	mov    %eax,%ebx
    if(!ip)
80107620:	85 c0                	test   %eax,%eax
80107622:	0f 84 3d 02 00 00    	je     80107865 <sys_grep_syscall+0x2b5>
        return -1;

    ilock(ip);
80107628:	83 ec 0c             	sub    $0xc,%esp
8010762b:	50                   	push   %eax
8010762c:	e8 0f b7 ff ff       	call   80102d40 <ilock>
    if(ip->type != T_FILE && ip->type != T_DEV){
80107631:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80107635:	83 c4 10             	add    $0x10,%esp
80107638:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
8010763c:	83 e8 02             	sub    $0x2,%eax
8010763f:	66 83 f8 01          	cmp    $0x1,%ax
80107643:	0f 87 0e 02 00 00    	ja     80107857 <sys_grep_syscall+0x2a7>
        iunlockput(ip);
        return -1;
    }

    char *buf = kalloc();
80107649:	e8 b2 c5 ff ff       	call   80103c00 <kalloc>
8010764e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(!buf){
80107651:	85 c0                	test   %eax,%eax
80107653:	0f 84 fe 01 00 00    	je     80107857 <sys_grep_syscall+0x2a7>
        iunlockput(ip);
        return -1;
    }

    char *line = kalloc();
80107659:	e8 a2 c5 ff ff       	call   80103c00 <kalloc>
8010765e:	89 c7                	mov    %eax,%edi
    if(!line){
80107660:	85 c0                	test   %eax,%eax
80107662:	0f 84 07 02 00 00    	je     8010786f <sys_grep_syscall+0x2bf>
        return -1;
    }

    int offset = 0;
    int res = -1;
    int line_len = 0;
80107668:	31 f6                	xor    %esi,%esi
    int offset = 0;
8010766a:	31 db                	xor    %ebx,%ebx

    while(1){
        int n = readi(ip, buf, offset, CHUNK);
8010766c:	68 00 02 00 00       	push   $0x200
80107671:	53                   	push   %ebx
80107672:	ff 75 cc             	push   -0x34(%ebp)
80107675:	ff 75 c8             	push   -0x38(%ebp)
80107678:	e8 d3 b9 ff ff       	call   80103050 <readi>
        if(n < 0)
8010767d:	83 c4 10             	add    $0x10,%esp
80107680:	85 c0                	test   %eax,%eax
80107682:	0f 88 ab 00 00 00    	js     80107733 <sys_grep_syscall+0x183>
            break;

        if(n == 0){
80107688:	0f 84 5d 01 00 00    	je     801077eb <sys_grep_syscall+0x23b>
            }

            break;
        }

        for(int i = 0; i < n; i++){
8010768e:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80107691:	31 d2                	xor    %edx,%edx
80107693:	eb 1a                	jmp    801076af <sys_grep_syscall+0xff>
80107695:	8d 76 00             	lea    0x0(%esi),%esi
                }

                line_len = 0;
            }
            
            else if(line_len < PGSIZE - 1){
80107698:	81 fe fe 0f 00 00    	cmp    $0xffe,%esi
8010769e:	0f 8e f1 00 00 00    	jle    80107795 <sys_grep_syscall+0x1e5>
        for(int i = 0; i < n; i++){
801076a4:	83 c2 01             	add    $0x1,%edx
801076a7:	39 d0                	cmp    %edx,%eax
801076a9:	0f 8e f7 00 00 00    	jle    801077a6 <sys_grep_syscall+0x1f6>
            char c = buf[i];
801076af:	8b 5d cc             	mov    -0x34(%ebp),%ebx
801076b2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
            if(c == '\n'){
801076b6:	80 f9 0a             	cmp    $0xa,%cl
801076b9:	75 dd                	jne    80107698 <sys_grep_syscall+0xe8>
                if(line_has_keyword(line, line_len, keyword)){
801076bb:	8b 5d dc             	mov    -0x24(%ebp),%ebx
    if(!key[0])
801076be:	0f b6 0b             	movzbl (%ebx),%ecx
801076c1:	88 4d d4             	mov    %cl,-0x2c(%ebp)
801076c4:	84 c9                	test   %cl,%cl
801076c6:	74 3c                	je     80107704 <sys_grep_syscall+0x154>
    for (int i = 0; i < n; i++){
801076c8:	85 f6                	test   %esi,%esi
801076ca:	0f 8e b0 00 00 00    	jle    80107780 <sys_grep_syscall+0x1d0>
801076d0:	89 d9                	mov    %ebx,%ecx
801076d2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801076d5:	89 45 c0             	mov    %eax,-0x40(%ebp)
801076d8:	29 f1                	sub    %esi,%ecx
801076da:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801076dd:	89 d9                	mov    %ebx,%ecx
801076df:	90                   	nop
801076e0:	89 d8                	mov    %ebx,%eax
        while(i+j < n && key[j] && line[i+j] == key[j])
801076e2:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
801076e6:	29 c8                	sub    %ecx,%eax
801076e8:	39 c6                	cmp    %eax,%esi
801076ea:	0f 8e 7c 00 00 00    	jle    8010776c <sys_grep_syscall+0x1bc>
801076f0:	3a 14 07             	cmp    (%edi,%eax,1),%dl
801076f3:	75 77                	jne    8010776c <sys_grep_syscall+0x1bc>
801076f5:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
801076f8:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
801076fc:	39 c6                	cmp    %eax,%esi
801076fe:	74 68                	je     80107768 <sys_grep_syscall+0x1b8>
80107700:	84 d2                	test   %dl,%dl
80107702:	75 ec                	jne    801076f0 <sys_grep_syscall+0x140>
                    int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
80107704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107707:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010770a:	39 f3                	cmp    %esi,%ebx
8010770c:	0f 4f de             	cmovg  %esi,%ebx
                    if(copyout(myproc()->pgdir, (uint)ubuf, line, copylen) >= 0){
8010770f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107712:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80107715:	e8 96 d9 ff ff       	call   801050b0 <myproc>
8010771a:	53                   	push   %ebx
8010771b:	57                   	push   %edi
8010771c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010771f:	52                   	push   %edx
80107720:	ff 70 04             	push   0x4(%eax)
80107723:	e8 38 1d 00 00       	call   80109460 <copyout>
80107728:	83 c4 10             	add    $0x10,%esp
8010772b:	85 c0                	test   %eax,%eax
8010772d:	0f 89 89 00 00 00    	jns    801077bc <sys_grep_syscall+0x20c>
    int res = -1;
80107733:	be ff ff ff ff       	mov    $0xffffffff,%esi
        }

        offset += n;
    }

    kfree(buf);
80107738:	83 ec 0c             	sub    $0xc,%esp
8010773b:	ff 75 cc             	push   -0x34(%ebp)
8010773e:	e8 fd c2 ff ff       	call   80103a40 <kfree>
    kfree(line);
80107743:	89 3c 24             	mov    %edi,(%esp)
80107746:	e8 f5 c2 ff ff       	call   80103a40 <kfree>
    iunlockput(ip);
8010774b:	58                   	pop    %eax
8010774c:	ff 75 c8             	push   -0x38(%ebp)
8010774f:	e8 7c b8 ff ff       	call   80102fd0 <iunlockput>

    return res;
80107754:	83 c4 10             	add    $0x10,%esp
80107757:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010775a:	89 f0                	mov    %esi,%eax
8010775c:	5b                   	pop    %ebx
8010775d:	5e                   	pop    %esi
8010775e:	5f                   	pop    %edi
8010775f:	5d                   	pop    %ebp
80107760:	c3                   	ret
80107761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(key[j] == 0)
80107768:	84 d2                	test   %dl,%dl
8010776a:	74 98                	je     80107704 <sys_grep_syscall+0x154>
    for (int i = 0; i < n; i++){
8010776c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010776f:	83 e9 01             	sub    $0x1,%ecx
80107772:	39 c1                	cmp    %eax,%ecx
80107774:	0f 85 66 ff ff ff    	jne    801076e0 <sys_grep_syscall+0x130>
8010777a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010777d:	8b 45 c0             	mov    -0x40(%ebp),%eax
        for(int i = 0; i < n; i++){
80107780:	83 c2 01             	add    $0x1,%edx
80107783:	39 d0                	cmp    %edx,%eax
80107785:	7e 58                	jle    801077df <sys_grep_syscall+0x22f>
            char c = buf[i];
80107787:	8b 75 cc             	mov    -0x34(%ebp),%esi
8010778a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
            if(c == '\n'){
8010778e:	80 f9 0a             	cmp    $0xa,%cl
80107791:	74 1d                	je     801077b0 <sys_grep_syscall+0x200>
                line_len = 0;
80107793:	31 f6                	xor    %esi,%esi
        for(int i = 0; i < n; i++){
80107795:	83 c2 01             	add    $0x1,%edx
                line[line_len++] = c;
80107798:	88 0c 37             	mov    %cl,(%edi,%esi,1)
8010779b:	83 c6 01             	add    $0x1,%esi
        for(int i = 0; i < n; i++){
8010779e:	39 d0                	cmp    %edx,%eax
801077a0:	0f 8f 09 ff ff ff    	jg     801076af <sys_grep_syscall+0xff>
801077a6:	8b 5d bc             	mov    -0x44(%ebp),%ebx
        offset += n;
801077a9:	01 c3                	add    %eax,%ebx
    while(1){
801077ab:	e9 bc fe ff ff       	jmp    8010766c <sys_grep_syscall+0xbc>
    if(!key[0])
801077b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801077b3:	75 cb                	jne    80107780 <sys_grep_syscall+0x1d0>
                line_len = 0;
801077b5:	31 f6                	xor    %esi,%esi
801077b7:	e9 48 ff ff ff       	jmp    80107704 <sys_grep_syscall+0x154>
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
801077bc:	03 5d e0             	add    -0x20(%ebp),%ebx
                        char z = 0;
801077bf:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
801077c3:	e8 e8 d8 ff ff       	call   801050b0 <myproc>
801077c8:	8d 55 db             	lea    -0x25(%ebp),%edx
801077cb:	6a 01                	push   $0x1
801077cd:	52                   	push   %edx
801077ce:	53                   	push   %ebx
801077cf:	ff 70 04             	push   0x4(%eax)
801077d2:	e8 89 1c 00 00       	call   80109460 <copyout>
                        res = line_len;
801077d7:	83 c4 10             	add    $0x10,%esp
801077da:	e9 59 ff ff ff       	jmp    80107738 <sys_grep_syscall+0x188>
                line_len = 0;
801077df:	8b 5d bc             	mov    -0x44(%ebp),%ebx
801077e2:	31 f6                	xor    %esi,%esi
        offset += n;
801077e4:	01 c3                	add    %eax,%ebx
    while(1){
801077e6:	e9 81 fe ff ff       	jmp    8010766c <sys_grep_syscall+0xbc>
            if(line_len > 0 && line_has_keyword(line, line_len, keyword)){
801077eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801077ee:	85 f6                	test   %esi,%esi
801077f0:	0f 8e 3d ff ff ff    	jle    80107733 <sys_grep_syscall+0x183>
801077f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801077f9:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801077fc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    if(!key[0])
801077ff:	0f b6 00             	movzbl (%eax),%eax
80107802:	88 45 d0             	mov    %al,-0x30(%ebp)
80107805:	84 c0                	test   %al,%al
80107807:	74 28                	je     80107831 <sys_grep_syscall+0x281>
        while(i+j < n && key[j] && line[i+j] == key[j])
80107809:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010780c:	39 c6                	cmp    %eax,%esi
8010780e:	7e 37                	jle    80107847 <sys_grep_syscall+0x297>
80107810:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
80107813:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
80107817:	01 f8                	add    %edi,%eax
80107819:	83 c1 01             	add    $0x1,%ecx
8010781c:	38 10                	cmp    %dl,(%eax)
8010781e:	75 27                	jne    80107847 <sys_grep_syscall+0x297>
80107820:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
80107823:	0f b6 11             	movzbl (%ecx),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
80107826:	83 c1 01             	add    $0x1,%ecx
80107829:	39 d8                	cmp    %ebx,%eax
8010782b:	74 16                	je     80107843 <sys_grep_syscall+0x293>
8010782d:	84 d2                	test   %dl,%dl
8010782f:	75 eb                	jne    8010781c <sys_grep_syscall+0x26c>
                int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
80107831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107834:	83 e8 01             	sub    $0x1,%eax
80107837:	39 f0                	cmp    %esi,%eax
80107839:	0f 4f c6             	cmovg  %esi,%eax
8010783c:	89 c3                	mov    %eax,%ebx
8010783e:	e9 cc fe ff ff       	jmp    8010770f <sys_grep_syscall+0x15f>
        if(key[j] == 0)
80107843:	84 d2                	test   %dl,%dl
80107845:	74 ea                	je     80107831 <sys_grep_syscall+0x281>
    for (int i = 0; i < n; i++){
80107847:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
8010784b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010784e:	39 c6                	cmp    %eax,%esi
80107850:	75 b7                	jne    80107809 <sys_grep_syscall+0x259>
80107852:	e9 dc fe ff ff       	jmp    80107733 <sys_grep_syscall+0x183>
        iunlockput(ip);
80107857:	83 ec 0c             	sub    $0xc,%esp
8010785a:	ff 75 c8             	push   -0x38(%ebp)
8010785d:	e8 6e b7 ff ff       	call   80102fd0 <iunlockput>
        return -1;
80107862:	83 c4 10             	add    $0x10,%esp
        return -1;
80107865:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010786a:	e9 e8 fe ff ff       	jmp    80107757 <sys_grep_syscall+0x1a7>
        kfree(buf);
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	ff 75 cc             	push   -0x34(%ebp)
80107875:	e8 c6 c1 ff ff       	call   80103a40 <kfree>
        iunlockput(ip);
8010787a:	5a                   	pop    %edx
8010787b:	ff 75 c8             	push   -0x38(%ebp)
8010787e:	e8 4d b7 ff ff       	call   80102fd0 <iunlockput>
        return -1;
80107883:	83 c4 10             	add    $0x10,%esp
80107886:	eb dd                	jmp    80107865 <sys_grep_syscall+0x2b5>
80107888:	66 90                	xchg   %ax,%ax
8010788a:	66 90                	xchg   %ax,%ax
8010788c:	66 90                	xchg   %ax,%ax
8010788e:	66 90                	xchg   %ax,%ax

80107890 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80107890:	e9 eb d9 ff ff       	jmp    80105280 <fork>
80107895:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010789c:	00 
8010789d:	8d 76 00             	lea    0x0(%esi),%esi

801078a0 <sys_exit>:
}

int
sys_exit(void)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801078a6:	e8 d5 dd ff ff       	call   80105680 <exit>
  return 0;  // not reached
}
801078ab:	31 c0                	xor    %eax,%eax
801078ad:	c9                   	leave
801078ae:	c3                   	ret
801078af:	90                   	nop

801078b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801078b0:	e9 4b e0 ff ff       	jmp    80105900 <wait>
801078b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078bc:	00 
801078bd:	8d 76 00             	lea    0x0(%esi),%esi

801078c0 <sys_kill>:
}

int
sys_kill(void)
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801078c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078c9:	50                   	push   %eax
801078ca:	6a 00                	push   $0x0
801078cc:	e8 3f ed ff ff       	call   80106610 <argint>
801078d1:	83 c4 10             	add    $0x10,%esp
801078d4:	85 c0                	test   %eax,%eax
801078d6:	78 18                	js     801078f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801078d8:	83 ec 0c             	sub    $0xc,%esp
801078db:	ff 75 f4             	push   -0xc(%ebp)
801078de:	e8 bd e1 ff ff       	call   80105aa0 <kill>
801078e3:	83 c4 10             	add    $0x10,%esp
}
801078e6:	c9                   	leave
801078e7:	c3                   	ret
801078e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078ef:	00 
801078f0:	c9                   	leave
    return -1;
801078f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078f6:	c3                   	ret
801078f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078fe:	00 
801078ff:	90                   	nop

80107900 <sys_getpid>:

int
sys_getpid(void)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107906:	e8 a5 d7 ff ff       	call   801050b0 <myproc>
8010790b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010790e:	c9                   	leave
8010790f:	c3                   	ret

80107910 <sys_sbrk>:

int
sys_sbrk(void)
{
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107914:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107917:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010791a:	50                   	push   %eax
8010791b:	6a 00                	push   $0x0
8010791d:	e8 ee ec ff ff       	call   80106610 <argint>
80107922:	83 c4 10             	add    $0x10,%esp
80107925:	85 c0                	test   %eax,%eax
80107927:	78 27                	js     80107950 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80107929:	e8 82 d7 ff ff       	call   801050b0 <myproc>
  if(growproc(n) < 0)
8010792e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107931:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80107933:	ff 75 f4             	push   -0xc(%ebp)
80107936:	e8 c5 d8 ff ff       	call   80105200 <growproc>
8010793b:	83 c4 10             	add    $0x10,%esp
8010793e:	85 c0                	test   %eax,%eax
80107940:	78 0e                	js     80107950 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107942:	89 d8                	mov    %ebx,%eax
80107944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107947:	c9                   	leave
80107948:	c3                   	ret
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107950:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107955:	eb eb                	jmp    80107942 <sys_sbrk+0x32>
80107957:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010795e:	00 
8010795f:	90                   	nop

80107960 <sys_sleep>:

int
sys_sleep(void)
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80107964:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107967:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010796a:	50                   	push   %eax
8010796b:	6a 00                	push   $0x0
8010796d:	e8 9e ec ff ff       	call   80106610 <argint>
80107972:	83 c4 10             	add    $0x10,%esp
80107975:	85 c0                	test   %eax,%eax
80107977:	78 64                	js     801079dd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80107979:	83 ec 0c             	sub    $0xc,%esp
8010797c:	68 20 75 11 80       	push   $0x80117520
80107981:	e8 da e8 ff ff       	call   80106260 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107989:	8b 1d 00 75 11 80    	mov    0x80117500,%ebx
  while(ticks - ticks0 < n){
8010798f:	83 c4 10             	add    $0x10,%esp
80107992:	85 d2                	test   %edx,%edx
80107994:	75 2b                	jne    801079c1 <sys_sleep+0x61>
80107996:	eb 58                	jmp    801079f0 <sys_sleep+0x90>
80107998:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010799f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801079a0:	83 ec 08             	sub    $0x8,%esp
801079a3:	68 20 75 11 80       	push   $0x80117520
801079a8:	68 00 75 11 80       	push   $0x80117500
801079ad:	e8 7e de ff ff       	call   80105830 <sleep>
  while(ticks - ticks0 < n){
801079b2:	a1 00 75 11 80       	mov    0x80117500,%eax
801079b7:	83 c4 10             	add    $0x10,%esp
801079ba:	29 d8                	sub    %ebx,%eax
801079bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801079bf:	73 2f                	jae    801079f0 <sys_sleep+0x90>
    if(myproc()->killed){
801079c1:	e8 ea d6 ff ff       	call   801050b0 <myproc>
801079c6:	8b 40 24             	mov    0x24(%eax),%eax
801079c9:	85 c0                	test   %eax,%eax
801079cb:	74 d3                	je     801079a0 <sys_sleep+0x40>
      release(&tickslock);
801079cd:	83 ec 0c             	sub    $0xc,%esp
801079d0:	68 20 75 11 80       	push   $0x80117520
801079d5:	e8 26 e8 ff ff       	call   80106200 <release>
      return -1;
801079da:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801079dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801079e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079e5:	c9                   	leave
801079e6:	c3                   	ret
801079e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079ee:	00 
801079ef:	90                   	nop
  release(&tickslock);
801079f0:	83 ec 0c             	sub    $0xc,%esp
801079f3:	68 20 75 11 80       	push   $0x80117520
801079f8:	e8 03 e8 ff ff       	call   80106200 <release>
}
801079fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80107a00:	83 c4 10             	add    $0x10,%esp
80107a03:	31 c0                	xor    %eax,%eax
}
80107a05:	c9                   	leave
80107a06:	c3                   	ret
80107a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a0e:	00 
80107a0f:	90                   	nop

80107a10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	53                   	push   %ebx
80107a14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107a17:	68 20 75 11 80       	push   $0x80117520
80107a1c:	e8 3f e8 ff ff       	call   80106260 <acquire>
  xticks = ticks;
80107a21:	8b 1d 00 75 11 80    	mov    0x80117500,%ebx
  release(&tickslock);
80107a27:	c7 04 24 20 75 11 80 	movl   $0x80117520,(%esp)
80107a2e:	e8 cd e7 ff ff       	call   80106200 <release>
  return xticks;
}
80107a33:	89 d8                	mov    %ebx,%eax
80107a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a38:	c9                   	leave
80107a39:	c3                   	ret
80107a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a40 <sys_show_process_family>:

int
sys_show_process_family(void)
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0) 
80107a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a49:	50                   	push   %eax
80107a4a:	6a 00                	push   $0x0
80107a4c:	e8 bf eb ff ff       	call   80106610 <argint>
80107a51:	83 c4 10             	add    $0x10,%esp
80107a54:	85 c0                	test   %eax,%eax
80107a56:	78 18                	js     80107a70 <sys_show_process_family+0x30>
    {
      return -1;
    }
  return process_family(pid);
80107a58:	83 ec 0c             	sub    $0xc,%esp
80107a5b:	ff 75 f4             	push   -0xc(%ebp)
80107a5e:	e8 bd e1 ff ff       	call   80105c20 <process_family>
80107a63:	83 c4 10             	add    $0x10,%esp
}
80107a66:	c9                   	leave
80107a67:	c3                   	ret
80107a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a6f:	00 
80107a70:	c9                   	leave
      return -1;
80107a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a76:	c3                   	ret
80107a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a7e:	00 
80107a7f:	90                   	nop

80107a80 <sys_simple_arithmetic>:

int
sys_simple_arithmetic(void)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	53                   	push   %ebx
80107a84:	83 ec 04             	sub    $0x4,%esp
  struct proc *p = myproc();
80107a87:	e8 24 d6 ff ff       	call   801050b0 <myproc>
  int a = p->tf->ebx; 
80107a8c:	8b 40 18             	mov    0x18(%eax),%eax
80107a8f:	8b 50 10             	mov    0x10(%eax),%edx
  int b = p->tf->ecx;
80107a92:	8b 48 18             	mov    0x18(%eax),%ecx

  int sum = a + b;
  int diff = a - b;
80107a95:	89 d0                	mov    %edx,%eax
  int sum = a + b;
80107a97:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
  int diff = a - b;
80107a9a:	29 c8                	sub    %ecx,%eax
  int res = sum * diff;
80107a9c:	0f af d8             	imul   %eax,%ebx

  cprintf("simple_arith: a=%d b=%d -> (%d+%d)*(%d-%d) = %d\n",a, b, a, b, a, b, res);
80107a9f:	53                   	push   %ebx
80107aa0:	51                   	push   %ecx
80107aa1:	52                   	push   %edx
80107aa2:	51                   	push   %ecx
80107aa3:	52                   	push   %edx
80107aa4:	51                   	push   %ecx
80107aa5:	52                   	push   %edx
80107aa6:	68 58 9c 10 80       	push   $0x80109c58
80107aab:	e8 b0 92 ff ff       	call   80100d60 <cprintf>

  return res;
}
80107ab0:	89 d8                	mov    %ebx,%eax
80107ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107ab5:	c9                   	leave
80107ab6:	c3                   	ret
80107ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107abe:	00 
80107abf:	90                   	nop

80107ac0 <sys_set_priority_syscall>:

int
sys_set_priority_syscall(void)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	83 ec 20             	sub    $0x20,%esp
  int pid, prio;
  if(argint(0, &pid)  < 0) return -1;
80107ac6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ac9:	50                   	push   %eax
80107aca:	6a 00                	push   $0x0
80107acc:	e8 3f eb ff ff       	call   80106610 <argint>
80107ad1:	83 c4 10             	add    $0x10,%esp
80107ad4:	85 c0                	test   %eax,%eax
80107ad6:	78 28                	js     80107b00 <sys_set_priority_syscall+0x40>
  if(argint(1, &prio) < 0) return -1;
80107ad8:	83 ec 08             	sub    $0x8,%esp
80107adb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ade:	50                   	push   %eax
80107adf:	6a 01                	push   $0x1
80107ae1:	e8 2a eb ff ff       	call   80106610 <argint>
80107ae6:	83 c4 10             	add    $0x10,%esp
80107ae9:	85 c0                	test   %eax,%eax
80107aeb:	78 13                	js     80107b00 <sys_set_priority_syscall+0x40>
  return set_priority(pid, prio);
80107aed:	83 ec 08             	sub    $0x8,%esp
80107af0:	ff 75 f4             	push   -0xc(%ebp)
80107af3:	ff 75 f0             	push   -0x10(%ebp)
80107af6:	e8 a5 e3 ff ff       	call   80105ea0 <set_priority>
80107afb:	83 c4 10             	add    $0x10,%esp
}
80107afe:	c9                   	leave
80107aff:	c3                   	ret
80107b00:	c9                   	leave
  if(argint(0, &pid)  < 0) return -1;
80107b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b06:	c3                   	ret
80107b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b0e:	00 
80107b0f:	90                   	nop

80107b10 <sys_start_throughput>:

int
sys_start_throughput(void)
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	83 ec 14             	sub    $0x14,%esp
  acquire(&tickslock);
80107b16:	68 20 75 11 80       	push   $0x80117520
80107b1b:	e8 40 e7 ff ff       	call   80106260 <acquire>
  throughput_start_tick = ticks;
80107b20:	a1 00 75 11 80       	mov    0x80117500,%eax
  release(&tickslock);
80107b25:	c7 04 24 20 75 11 80 	movl   $0x80117520,(%esp)
  throughput_start_tick = ticks;
80107b2c:	a3 e4 4f 11 80       	mov    %eax,0x80114fe4
  release(&tickslock);
80107b31:	e8 ca e6 ff ff       	call   80106200 <release>

  throughput_finished_procs = 0;
  is_measuring_throughput = 1;

  return 0;
}
80107b36:	31 c0                	xor    %eax,%eax
  throughput_finished_procs = 0;
80107b38:	c7 05 e0 4f 11 80 00 	movl   $0x0,0x80114fe0
80107b3f:	00 00 00 
  is_measuring_throughput = 1;
80107b42:	c7 05 e8 4f 11 80 01 	movl   $0x1,0x80114fe8
80107b49:	00 00 00 
}
80107b4c:	c9                   	leave
80107b4d:	c3                   	ret
80107b4e:	66 90                	xchg   %ax,%ax

80107b50 <sys_end_throughput>:

int
sys_end_throughput(void)
{
80107b50:	55                   	push   %ebp
80107b51:	89 e5                	mov    %esp,%ebp
80107b53:	56                   	push   %esi
80107b54:	53                   	push   %ebx
  uint start, end, diff;
  int procs;

  acquire(&tickslock);
80107b55:	83 ec 0c             	sub    $0xc,%esp
80107b58:	68 20 75 11 80       	push   $0x80117520
80107b5d:	e8 fe e6 ff ff       	call   80106260 <acquire>
  start = throughput_start_tick;
80107b62:	8b 35 e4 4f 11 80    	mov    0x80114fe4,%esi
  end   = ticks;
80107b68:	8b 1d 00 75 11 80    	mov    0x80117500,%ebx
  release(&tickslock);
80107b6e:	c7 04 24 20 75 11 80 	movl   $0x80117520,(%esp)
80107b75:	e8 86 e6 ff ff       	call   80106200 <release>
  diff  = end - start;

  if(diff == 0)
    diff = 1;

  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107b7a:	ba 01 00 00 00       	mov    $0x1,%edx
80107b7f:	69 05 e0 4f 11 80 e8 	imul   $0x3e8,0x80114fe0,%eax
80107b86:	03 00 00 
  diff  = end - start;
80107b89:	29 f3                	sub    %esi,%ebx
  is_measuring_throughput = 0;
80107b8b:	c7 05 e8 4f 11 80 00 	movl   $0x0,0x80114fe8
80107b92:	00 00 00 
  diff  = end - start;
80107b95:	89 d9                	mov    %ebx,%ecx
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107b97:	0f 44 ca             	cmove  %edx,%ecx

  // cprintf("Throughput: %d procs in %d ticks (~%d procs/tick)\n",
  //         throughput_finished_procs, diff, th_per_tick);

  return th_per_tick;
}
80107b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107b9d:	31 d2                	xor    %edx,%edx
}
80107b9f:	5b                   	pop    %ebx
80107ba0:	5e                   	pop    %esi
  int th_per_tick = throughput_finished_procs * 1000 / diff;
80107ba1:	f7 f1                	div    %ecx
}
80107ba3:	5d                   	pop    %ebp
80107ba4:	c3                   	ret

80107ba5 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107ba5:	1e                   	push   %ds
  pushl %es
80107ba6:	06                   	push   %es
  pushl %fs
80107ba7:	0f a0                	push   %fs
  pushl %gs
80107ba9:	0f a8                	push   %gs
  pushal
80107bab:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107bac:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107bb0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107bb2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107bb4:	54                   	push   %esp
  call trap
80107bb5:	e8 c6 00 00 00       	call   80107c80 <trap>
  addl $4, %esp
80107bba:	83 c4 04             	add    $0x4,%esp

80107bbd <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107bbd:	61                   	popa
  popl %gs
80107bbe:	0f a9                	pop    %gs
  popl %fs
80107bc0:	0f a1                	pop    %fs
  popl %es
80107bc2:	07                   	pop    %es
  popl %ds
80107bc3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107bc4:	83 c4 08             	add    $0x8,%esp
  iret
80107bc7:	cf                   	iret
80107bc8:	66 90                	xchg   %ax,%ax
80107bca:	66 90                	xchg   %ax,%ax
80107bcc:	66 90                	xchg   %ax,%ax
80107bce:	66 90                	xchg   %ax,%ax

80107bd0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107bd0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107bd1:	31 c0                	xor    %eax,%eax
{
80107bd3:	89 e5                	mov    %esp,%ebp
80107bd5:	83 ec 08             	sub    $0x8,%esp
80107bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107bdf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107be0:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80107be7:	c7 04 c5 62 75 11 80 	movl   $0x8e000008,-0x7fee8a9e(,%eax,8)
80107bee:	08 00 00 8e 
80107bf2:	66 89 14 c5 60 75 11 	mov    %dx,-0x7fee8aa0(,%eax,8)
80107bf9:	80 
80107bfa:	c1 ea 10             	shr    $0x10,%edx
80107bfd:	66 89 14 c5 66 75 11 	mov    %dx,-0x7fee8a9a(,%eax,8)
80107c04:	80 
  for(i = 0; i < 256; i++)
80107c05:	83 c0 01             	add    $0x1,%eax
80107c08:	3d 00 01 00 00       	cmp    $0x100,%eax
80107c0d:	75 d1                	jne    80107be0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80107c0f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107c12:	a1 08 d1 10 80       	mov    0x8010d108,%eax
80107c17:	c7 05 62 77 11 80 08 	movl   $0xef000008,0x80117762
80107c1e:	00 00 ef 
  initlock(&tickslock, "time");
80107c21:	68 c7 99 10 80       	push   $0x801099c7
80107c26:	68 20 75 11 80       	push   $0x80117520
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107c2b:	66 a3 60 77 11 80    	mov    %ax,0x80117760
80107c31:	c1 e8 10             	shr    $0x10,%eax
80107c34:	66 a3 66 77 11 80    	mov    %ax,0x80117766
  initlock(&tickslock, "time");
80107c3a:	e8 31 e4 ff ff       	call   80106070 <initlock>
}
80107c3f:	83 c4 10             	add    $0x10,%esp
80107c42:	c9                   	leave
80107c43:	c3                   	ret
80107c44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c4b:	00 
80107c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c50 <idtinit>:

void
idtinit(void)
{
80107c50:	55                   	push   %ebp
  pd[0] = size-1;
80107c51:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107c56:	89 e5                	mov    %esp,%ebp
80107c58:	83 ec 10             	sub    $0x10,%esp
80107c5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107c5f:	b8 60 75 11 80       	mov    $0x80117560,%eax
80107c64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107c68:	c1 e8 10             	shr    $0x10,%eax
80107c6b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80107c6f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107c72:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107c75:	c9                   	leave
80107c76:	c3                   	ret
80107c77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c7e:	00 
80107c7f:	90                   	nop

80107c80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107c80:	55                   	push   %ebp
80107c81:	89 e5                	mov    %esp,%ebp
80107c83:	57                   	push   %edi
80107c84:	56                   	push   %esi
80107c85:	53                   	push   %ebx
80107c86:	83 ec 1c             	sub    $0x1c,%esp
80107c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80107c8c:	8b 43 30             	mov    0x30(%ebx),%eax
80107c8f:	83 f8 40             	cmp    $0x40,%eax
80107c92:	0f 84 a0 01 00 00    	je     80107e38 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80107c98:	83 e8 20             	sub    $0x20,%eax
80107c9b:	83 f8 1f             	cmp    $0x1f,%eax
80107c9e:	0f 87 7c 00 00 00    	ja     80107d20 <trap+0xa0>
80107ca4:	ff 24 85 14 a0 10 80 	jmp    *-0x7fef5fec(,%eax,4)
80107cab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107cb0:	e8 1b bb ff ff       	call   801037d0 <ideintr>
    lapiceoi();
80107cb5:	e8 d6 c1 ff ff       	call   80103e90 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107cba:	e8 f1 d3 ff ff       	call   801050b0 <myproc>
80107cbf:	85 c0                	test   %eax,%eax
80107cc1:	74 1a                	je     80107cdd <trap+0x5d>
80107cc3:	e8 e8 d3 ff ff       	call   801050b0 <myproc>
80107cc8:	8b 50 24             	mov    0x24(%eax),%edx
80107ccb:	85 d2                	test   %edx,%edx
80107ccd:	74 0e                	je     80107cdd <trap+0x5d>
80107ccf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107cd3:	f7 d0                	not    %eax
80107cd5:	a8 03                	test   $0x3,%al
80107cd7:	0f 84 23 02 00 00    	je     80107f00 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

if(myproc() && myproc()->state == RUNNING &&
80107cdd:	e8 ce d3 ff ff       	call   801050b0 <myproc>
80107ce2:	85 c0                	test   %eax,%eax
80107ce4:	74 0f                	je     80107cf5 <trap+0x75>
80107ce6:	e8 c5 d3 ff ff       	call   801050b0 <myproc>
80107ceb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107cef:	0f 84 ab 00 00 00    	je     80107da0 <trap+0x120>
         yield();
     }
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107cf5:	e8 b6 d3 ff ff       	call   801050b0 <myproc>
80107cfa:	85 c0                	test   %eax,%eax
80107cfc:	74 1a                	je     80107d18 <trap+0x98>
80107cfe:	e8 ad d3 ff ff       	call   801050b0 <myproc>
80107d03:	8b 40 24             	mov    0x24(%eax),%eax
80107d06:	85 c0                	test   %eax,%eax
80107d08:	74 0e                	je     80107d18 <trap+0x98>
80107d0a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107d0e:	f7 d0                	not    %eax
80107d10:	a8 03                	test   $0x3,%al
80107d12:	0f 84 4d 01 00 00    	je     80107e65 <trap+0x1e5>
    exit();
80107d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d1b:	5b                   	pop    %ebx
80107d1c:	5e                   	pop    %esi
80107d1d:	5f                   	pop    %edi
80107d1e:	5d                   	pop    %ebp
80107d1f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80107d20:	e8 8b d3 ff ff       	call   801050b0 <myproc>
80107d25:	8b 7b 38             	mov    0x38(%ebx),%edi
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	0f 84 fa 01 00 00    	je     80107f2a <trap+0x2aa>
80107d30:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107d34:	0f 84 f0 01 00 00    	je     80107f2a <trap+0x2aa>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107d3a:	0f 20 d1             	mov    %cr2,%ecx
80107d3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107d40:	e8 eb d2 ff ff       	call   80105030 <cpuid>
80107d45:	8b 73 30             	mov    0x30(%ebx),%esi
80107d48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107d4b:	8b 43 34             	mov    0x34(%ebx),%eax
80107d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80107d51:	e8 5a d3 ff ff       	call   801050b0 <myproc>
80107d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d59:	e8 52 d3 ff ff       	call   801050b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107d5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107d61:	51                   	push   %ecx
80107d62:	57                   	push   %edi
80107d63:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107d66:	52                   	push   %edx
80107d67:	ff 75 e4             	push   -0x1c(%ebp)
80107d6a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107d6b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80107d6e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107d71:	56                   	push   %esi
80107d72:	ff 70 10             	push   0x10(%eax)
80107d75:	68 e4 9c 10 80       	push   $0x80109ce4
80107d7a:	e8 e1 8f ff ff       	call   80100d60 <cprintf>
    myproc()->killed = 1;
80107d7f:	83 c4 20             	add    $0x20,%esp
80107d82:	e8 29 d3 ff ff       	call   801050b0 <myproc>
80107d87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107d8e:	e8 1d d3 ff ff       	call   801050b0 <myproc>
80107d93:	85 c0                	test   %eax,%eax
80107d95:	0f 85 28 ff ff ff    	jne    80107cc3 <trap+0x43>
80107d9b:	e9 3d ff ff ff       	jmp    80107cdd <trap+0x5d>
if(myproc() && myproc()->state == RUNNING &&
80107da0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107da4:	0f 85 4b ff ff ff    	jne    80107cf5 <trap+0x75>
     struct cpu *c = mycpu();
80107daa:	e8 21 d2 ff ff       	call   80104fd0 <mycpu>
     if (cpuid() % 2 == 0) { // E-Core
80107daf:	e8 7c d2 ff ff       	call   80105030 <cpuid>
80107db4:	a8 01                	test   $0x1,%al
80107db6:	0f 85 64 01 00 00    	jne    80107f20 <trap+0x2a0>
         myproc()->tick_count++;
80107dbc:	e8 ef d2 ff ff       	call   801050b0 <myproc>
80107dc1:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
         myproc()->total_tick_count++;
80107dc8:	e8 e3 d2 ff ff       	call   801050b0 <myproc>
80107dcd:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
         if (myproc()->tick_count >= 3) {
80107dd4:	e8 d7 d2 ff ff       	call   801050b0 <myproc>
80107dd9:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80107de0:	0f 8e 0f ff ff ff    	jle    80107cf5 <trap+0x75>
             myproc()->tick_count = 0;
80107de6:	e8 c5 d2 ff ff       	call   801050b0 <myproc>
80107deb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80107df2:	00 00 00 
             yield();
80107df5:	e8 d6 d9 ff ff       	call   801057d0 <yield>
80107dfa:	e9 f6 fe ff ff       	jmp    80107cf5 <trap+0x75>
80107dff:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107e00:	8b 7b 38             	mov    0x38(%ebx),%edi
80107e03:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107e07:	e8 24 d2 ff ff       	call   80105030 <cpuid>
80107e0c:	57                   	push   %edi
80107e0d:	56                   	push   %esi
80107e0e:	50                   	push   %eax
80107e0f:	68 8c 9c 10 80       	push   $0x80109c8c
80107e14:	e8 47 8f ff ff       	call   80100d60 <cprintf>
    lapiceoi();
80107e19:	e8 72 c0 ff ff       	call   80103e90 <lapiceoi>
    break;
80107e1e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107e21:	e8 8a d2 ff ff       	call   801050b0 <myproc>
80107e26:	85 c0                	test   %eax,%eax
80107e28:	0f 85 95 fe ff ff    	jne    80107cc3 <trap+0x43>
80107e2e:	e9 aa fe ff ff       	jmp    80107cdd <trap+0x5d>
80107e33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80107e38:	e8 73 d2 ff ff       	call   801050b0 <myproc>
80107e3d:	8b 70 24             	mov    0x24(%eax),%esi
80107e40:	85 f6                	test   %esi,%esi
80107e42:	0f 85 c8 00 00 00    	jne    80107f10 <trap+0x290>
    myproc()->tf = tf;
80107e48:	e8 63 d2 ff ff       	call   801050b0 <myproc>
80107e4d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107e50:	e8 fb e8 ff ff       	call   80106750 <syscall>
    if(myproc()->killed)
80107e55:	e8 56 d2 ff ff       	call   801050b0 <myproc>
80107e5a:	8b 48 24             	mov    0x24(%eax),%ecx
80107e5d:	85 c9                	test   %ecx,%ecx
80107e5f:	0f 84 b3 fe ff ff    	je     80107d18 <trap+0x98>
80107e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e68:	5b                   	pop    %ebx
80107e69:	5e                   	pop    %esi
80107e6a:	5f                   	pop    %edi
80107e6b:	5d                   	pop    %ebp
      exit();
80107e6c:	e9 0f d8 ff ff       	jmp    80105680 <exit>
80107e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80107e78:	e8 63 02 00 00       	call   801080e0 <uartintr>
    lapiceoi();
80107e7d:	e8 0e c0 ff ff       	call   80103e90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107e82:	e8 29 d2 ff ff       	call   801050b0 <myproc>
80107e87:	85 c0                	test   %eax,%eax
80107e89:	0f 85 34 fe ff ff    	jne    80107cc3 <trap+0x43>
80107e8f:	e9 49 fe ff ff       	jmp    80107cdd <trap+0x5d>
80107e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107e98:	e8 c3 be ff ff       	call   80103d60 <kbdintr>
    lapiceoi();
80107e9d:	e8 ee bf ff ff       	call   80103e90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107ea2:	e8 09 d2 ff ff       	call   801050b0 <myproc>
80107ea7:	85 c0                	test   %eax,%eax
80107ea9:	0f 85 14 fe ff ff    	jne    80107cc3 <trap+0x43>
80107eaf:	e9 29 fe ff ff       	jmp    80107cdd <trap+0x5d>
80107eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80107eb8:	e8 73 d1 ff ff       	call   80105030 <cpuid>
80107ebd:	85 c0                	test   %eax,%eax
80107ebf:	0f 85 f0 fd ff ff    	jne    80107cb5 <trap+0x35>
      acquire(&tickslock);
80107ec5:	83 ec 0c             	sub    $0xc,%esp
80107ec8:	68 20 75 11 80       	push   $0x80117520
80107ecd:	e8 8e e3 ff ff       	call   80106260 <acquire>
      ticks++;
80107ed2:	83 05 00 75 11 80 01 	addl   $0x1,0x80117500
      wakeup(&ticks);
80107ed9:	c7 04 24 00 75 11 80 	movl   $0x80117500,(%esp)
80107ee0:	e8 ab db ff ff       	call   80105a90 <wakeup>
      release(&tickslock);
80107ee5:	c7 04 24 20 75 11 80 	movl   $0x80117520,(%esp)
80107eec:	e8 0f e3 ff ff       	call   80106200 <release>
80107ef1:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107ef4:	e9 bc fd ff ff       	jmp    80107cb5 <trap+0x35>
80107ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107f00:	e8 7b d7 ff ff       	call   80105680 <exit>
80107f05:	e9 d3 fd ff ff       	jmp    80107cdd <trap+0x5d>
80107f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107f10:	e8 6b d7 ff ff       	call   80105680 <exit>
80107f15:	e9 2e ff ff ff       	jmp    80107e48 <trap+0x1c8>
80107f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
         yield();
80107f20:	e8 ab d8 ff ff       	call   801057d0 <yield>
80107f25:	e9 cb fd ff ff       	jmp    80107cf5 <trap+0x75>
80107f2a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107f2d:	e8 fe d0 ff ff       	call   80105030 <cpuid>
80107f32:	83 ec 0c             	sub    $0xc,%esp
80107f35:	56                   	push   %esi
80107f36:	57                   	push   %edi
80107f37:	50                   	push   %eax
80107f38:	ff 73 30             	push   0x30(%ebx)
80107f3b:	68 b0 9c 10 80       	push   $0x80109cb0
80107f40:	e8 1b 8e ff ff       	call   80100d60 <cprintf>
      panic("trap");
80107f45:	83 c4 14             	add    $0x14,%esp
80107f48:	68 cc 99 10 80       	push   $0x801099cc
80107f4d:	e8 fe 85 ff ff       	call   80100550 <panic>
80107f52:	66 90                	xchg   %ax,%ax
80107f54:	66 90                	xchg   %ax,%ax
80107f56:	66 90                	xchg   %ax,%ax
80107f58:	66 90                	xchg   %ax,%ax
80107f5a:	66 90                	xchg   %ax,%ax
80107f5c:	66 90                	xchg   %ax,%ax
80107f5e:	66 90                	xchg   %ax,%ax

80107f60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107f60:	a1 60 7d 11 80       	mov    0x80117d60,%eax
80107f65:	85 c0                	test   %eax,%eax
80107f67:	74 17                	je     80107f80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107f6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107f6f:	a8 01                	test   $0x1,%al
80107f71:	74 0d                	je     80107f80 <uartgetc+0x20>
80107f73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107f78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107f79:	0f b6 c0             	movzbl %al,%eax
80107f7c:	c3                   	ret
80107f7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f85:	c3                   	ret
80107f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107f8d:	00 
80107f8e:	66 90                	xchg   %ax,%ax

80107f90 <uartinit>:
{
80107f90:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f91:	31 c9                	xor    %ecx,%ecx
80107f93:	89 c8                	mov    %ecx,%eax
80107f95:	89 e5                	mov    %esp,%ebp
80107f97:	57                   	push   %edi
80107f98:	bf fa 03 00 00       	mov    $0x3fa,%edi
80107f9d:	56                   	push   %esi
80107f9e:	89 fa                	mov    %edi,%edx
80107fa0:	53                   	push   %ebx
80107fa1:	83 ec 1c             	sub    $0x1c,%esp
80107fa4:	ee                   	out    %al,(%dx)
80107fa5:	be fb 03 00 00       	mov    $0x3fb,%esi
80107faa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80107faf:	89 f2                	mov    %esi,%edx
80107fb1:	ee                   	out    %al,(%dx)
80107fb2:	b8 0c 00 00 00       	mov    $0xc,%eax
80107fb7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107fbc:	ee                   	out    %al,(%dx)
80107fbd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80107fc2:	89 c8                	mov    %ecx,%eax
80107fc4:	89 da                	mov    %ebx,%edx
80107fc6:	ee                   	out    %al,(%dx)
80107fc7:	b8 03 00 00 00       	mov    $0x3,%eax
80107fcc:	89 f2                	mov    %esi,%edx
80107fce:	ee                   	out    %al,(%dx)
80107fcf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107fd4:	89 c8                	mov    %ecx,%eax
80107fd6:	ee                   	out    %al,(%dx)
80107fd7:	b8 01 00 00 00       	mov    $0x1,%eax
80107fdc:	89 da                	mov    %ebx,%edx
80107fde:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107fdf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107fe4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107fe5:	3c ff                	cmp    $0xff,%al
80107fe7:	0f 84 7c 00 00 00    	je     80108069 <uartinit+0xd9>
  uart = 1;
80107fed:	c7 05 60 7d 11 80 01 	movl   $0x1,0x80117d60
80107ff4:	00 00 00 
80107ff7:	89 fa                	mov    %edi,%edx
80107ff9:	ec                   	in     (%dx),%al
80107ffa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107fff:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80108000:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80108003:	bf d1 99 10 80       	mov    $0x801099d1,%edi
80108008:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010800d:	6a 00                	push   $0x0
8010800f:	6a 04                	push   $0x4
80108011:	e8 ea b9 ff ff       	call   80103a00 <ioapicenable>
80108016:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80108019:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010801d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80108020:	a1 60 7d 11 80       	mov    0x80117d60,%eax
80108025:	85 c0                	test   %eax,%eax
80108027:	74 32                	je     8010805b <uartinit+0xcb>
80108029:	89 f2                	mov    %esi,%edx
8010802b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010802c:	a8 20                	test   $0x20,%al
8010802e:	75 21                	jne    80108051 <uartinit+0xc1>
80108030:	bb 80 00 00 00       	mov    $0x80,%ebx
80108035:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80108038:	83 ec 0c             	sub    $0xc,%esp
8010803b:	6a 0a                	push   $0xa
8010803d:	e8 6e be ff ff       	call   80103eb0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108042:	83 c4 10             	add    $0x10,%esp
80108045:	83 eb 01             	sub    $0x1,%ebx
80108048:	74 07                	je     80108051 <uartinit+0xc1>
8010804a:	89 f2                	mov    %esi,%edx
8010804c:	ec                   	in     (%dx),%al
8010804d:	a8 20                	test   $0x20,%al
8010804f:	74 e7                	je     80108038 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108051:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108056:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010805a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010805b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
8010805f:	83 c7 01             	add    $0x1,%edi
80108062:	88 45 e7             	mov    %al,-0x19(%ebp)
80108065:	84 c0                	test   %al,%al
80108067:	75 b7                	jne    80108020 <uartinit+0x90>
}
80108069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010806c:	5b                   	pop    %ebx
8010806d:	5e                   	pop    %esi
8010806e:	5f                   	pop    %edi
8010806f:	5d                   	pop    %ebp
80108070:	c3                   	ret
80108071:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108078:	00 
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108080 <uartputc>:
  if(!uart)
80108080:	a1 60 7d 11 80       	mov    0x80117d60,%eax
80108085:	85 c0                	test   %eax,%eax
80108087:	74 4f                	je     801080d8 <uartputc+0x58>
{
80108089:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010808a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010808f:	89 e5                	mov    %esp,%ebp
80108091:	56                   	push   %esi
80108092:	53                   	push   %ebx
80108093:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108094:	a8 20                	test   $0x20,%al
80108096:	75 29                	jne    801080c1 <uartputc+0x41>
80108098:	bb 80 00 00 00       	mov    $0x80,%ebx
8010809d:	be fd 03 00 00       	mov    $0x3fd,%esi
801080a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801080a8:	83 ec 0c             	sub    $0xc,%esp
801080ab:	6a 0a                	push   $0xa
801080ad:	e8 fe bd ff ff       	call   80103eb0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801080b2:	83 c4 10             	add    $0x10,%esp
801080b5:	83 eb 01             	sub    $0x1,%ebx
801080b8:	74 07                	je     801080c1 <uartputc+0x41>
801080ba:	89 f2                	mov    %esi,%edx
801080bc:	ec                   	in     (%dx),%al
801080bd:	a8 20                	test   $0x20,%al
801080bf:	74 e7                	je     801080a8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801080c1:	8b 45 08             	mov    0x8(%ebp),%eax
801080c4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801080c9:	ee                   	out    %al,(%dx)
}
801080ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080cd:	5b                   	pop    %ebx
801080ce:	5e                   	pop    %esi
801080cf:	5d                   	pop    %ebp
801080d0:	c3                   	ret
801080d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080d8:	c3                   	ret
801080d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080e0 <uartintr>:

void
uartintr(void)
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801080e6:	68 60 7f 10 80       	push   $0x80107f60
801080eb:	e8 80 8e ff ff       	call   80100f70 <consoleintr>
}
801080f0:	83 c4 10             	add    $0x10,%esp
801080f3:	c9                   	leave
801080f4:	c3                   	ret

801080f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801080f5:	6a 00                	push   $0x0
  pushl $0
801080f7:	6a 00                	push   $0x0
  jmp alltraps
801080f9:	e9 a7 fa ff ff       	jmp    80107ba5 <alltraps>

801080fe <vector1>:
.globl vector1
vector1:
  pushl $0
801080fe:	6a 00                	push   $0x0
  pushl $1
80108100:	6a 01                	push   $0x1
  jmp alltraps
80108102:	e9 9e fa ff ff       	jmp    80107ba5 <alltraps>

80108107 <vector2>:
.globl vector2
vector2:
  pushl $0
80108107:	6a 00                	push   $0x0
  pushl $2
80108109:	6a 02                	push   $0x2
  jmp alltraps
8010810b:	e9 95 fa ff ff       	jmp    80107ba5 <alltraps>

80108110 <vector3>:
.globl vector3
vector3:
  pushl $0
80108110:	6a 00                	push   $0x0
  pushl $3
80108112:	6a 03                	push   $0x3
  jmp alltraps
80108114:	e9 8c fa ff ff       	jmp    80107ba5 <alltraps>

80108119 <vector4>:
.globl vector4
vector4:
  pushl $0
80108119:	6a 00                	push   $0x0
  pushl $4
8010811b:	6a 04                	push   $0x4
  jmp alltraps
8010811d:	e9 83 fa ff ff       	jmp    80107ba5 <alltraps>

80108122 <vector5>:
.globl vector5
vector5:
  pushl $0
80108122:	6a 00                	push   $0x0
  pushl $5
80108124:	6a 05                	push   $0x5
  jmp alltraps
80108126:	e9 7a fa ff ff       	jmp    80107ba5 <alltraps>

8010812b <vector6>:
.globl vector6
vector6:
  pushl $0
8010812b:	6a 00                	push   $0x0
  pushl $6
8010812d:	6a 06                	push   $0x6
  jmp alltraps
8010812f:	e9 71 fa ff ff       	jmp    80107ba5 <alltraps>

80108134 <vector7>:
.globl vector7
vector7:
  pushl $0
80108134:	6a 00                	push   $0x0
  pushl $7
80108136:	6a 07                	push   $0x7
  jmp alltraps
80108138:	e9 68 fa ff ff       	jmp    80107ba5 <alltraps>

8010813d <vector8>:
.globl vector8
vector8:
  pushl $8
8010813d:	6a 08                	push   $0x8
  jmp alltraps
8010813f:	e9 61 fa ff ff       	jmp    80107ba5 <alltraps>

80108144 <vector9>:
.globl vector9
vector9:
  pushl $0
80108144:	6a 00                	push   $0x0
  pushl $9
80108146:	6a 09                	push   $0x9
  jmp alltraps
80108148:	e9 58 fa ff ff       	jmp    80107ba5 <alltraps>

8010814d <vector10>:
.globl vector10
vector10:
  pushl $10
8010814d:	6a 0a                	push   $0xa
  jmp alltraps
8010814f:	e9 51 fa ff ff       	jmp    80107ba5 <alltraps>

80108154 <vector11>:
.globl vector11
vector11:
  pushl $11
80108154:	6a 0b                	push   $0xb
  jmp alltraps
80108156:	e9 4a fa ff ff       	jmp    80107ba5 <alltraps>

8010815b <vector12>:
.globl vector12
vector12:
  pushl $12
8010815b:	6a 0c                	push   $0xc
  jmp alltraps
8010815d:	e9 43 fa ff ff       	jmp    80107ba5 <alltraps>

80108162 <vector13>:
.globl vector13
vector13:
  pushl $13
80108162:	6a 0d                	push   $0xd
  jmp alltraps
80108164:	e9 3c fa ff ff       	jmp    80107ba5 <alltraps>

80108169 <vector14>:
.globl vector14
vector14:
  pushl $14
80108169:	6a 0e                	push   $0xe
  jmp alltraps
8010816b:	e9 35 fa ff ff       	jmp    80107ba5 <alltraps>

80108170 <vector15>:
.globl vector15
vector15:
  pushl $0
80108170:	6a 00                	push   $0x0
  pushl $15
80108172:	6a 0f                	push   $0xf
  jmp alltraps
80108174:	e9 2c fa ff ff       	jmp    80107ba5 <alltraps>

80108179 <vector16>:
.globl vector16
vector16:
  pushl $0
80108179:	6a 00                	push   $0x0
  pushl $16
8010817b:	6a 10                	push   $0x10
  jmp alltraps
8010817d:	e9 23 fa ff ff       	jmp    80107ba5 <alltraps>

80108182 <vector17>:
.globl vector17
vector17:
  pushl $17
80108182:	6a 11                	push   $0x11
  jmp alltraps
80108184:	e9 1c fa ff ff       	jmp    80107ba5 <alltraps>

80108189 <vector18>:
.globl vector18
vector18:
  pushl $0
80108189:	6a 00                	push   $0x0
  pushl $18
8010818b:	6a 12                	push   $0x12
  jmp alltraps
8010818d:	e9 13 fa ff ff       	jmp    80107ba5 <alltraps>

80108192 <vector19>:
.globl vector19
vector19:
  pushl $0
80108192:	6a 00                	push   $0x0
  pushl $19
80108194:	6a 13                	push   $0x13
  jmp alltraps
80108196:	e9 0a fa ff ff       	jmp    80107ba5 <alltraps>

8010819b <vector20>:
.globl vector20
vector20:
  pushl $0
8010819b:	6a 00                	push   $0x0
  pushl $20
8010819d:	6a 14                	push   $0x14
  jmp alltraps
8010819f:	e9 01 fa ff ff       	jmp    80107ba5 <alltraps>

801081a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801081a4:	6a 00                	push   $0x0
  pushl $21
801081a6:	6a 15                	push   $0x15
  jmp alltraps
801081a8:	e9 f8 f9 ff ff       	jmp    80107ba5 <alltraps>

801081ad <vector22>:
.globl vector22
vector22:
  pushl $0
801081ad:	6a 00                	push   $0x0
  pushl $22
801081af:	6a 16                	push   $0x16
  jmp alltraps
801081b1:	e9 ef f9 ff ff       	jmp    80107ba5 <alltraps>

801081b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801081b6:	6a 00                	push   $0x0
  pushl $23
801081b8:	6a 17                	push   $0x17
  jmp alltraps
801081ba:	e9 e6 f9 ff ff       	jmp    80107ba5 <alltraps>

801081bf <vector24>:
.globl vector24
vector24:
  pushl $0
801081bf:	6a 00                	push   $0x0
  pushl $24
801081c1:	6a 18                	push   $0x18
  jmp alltraps
801081c3:	e9 dd f9 ff ff       	jmp    80107ba5 <alltraps>

801081c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801081c8:	6a 00                	push   $0x0
  pushl $25
801081ca:	6a 19                	push   $0x19
  jmp alltraps
801081cc:	e9 d4 f9 ff ff       	jmp    80107ba5 <alltraps>

801081d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801081d1:	6a 00                	push   $0x0
  pushl $26
801081d3:	6a 1a                	push   $0x1a
  jmp alltraps
801081d5:	e9 cb f9 ff ff       	jmp    80107ba5 <alltraps>

801081da <vector27>:
.globl vector27
vector27:
  pushl $0
801081da:	6a 00                	push   $0x0
  pushl $27
801081dc:	6a 1b                	push   $0x1b
  jmp alltraps
801081de:	e9 c2 f9 ff ff       	jmp    80107ba5 <alltraps>

801081e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801081e3:	6a 00                	push   $0x0
  pushl $28
801081e5:	6a 1c                	push   $0x1c
  jmp alltraps
801081e7:	e9 b9 f9 ff ff       	jmp    80107ba5 <alltraps>

801081ec <vector29>:
.globl vector29
vector29:
  pushl $0
801081ec:	6a 00                	push   $0x0
  pushl $29
801081ee:	6a 1d                	push   $0x1d
  jmp alltraps
801081f0:	e9 b0 f9 ff ff       	jmp    80107ba5 <alltraps>

801081f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801081f5:	6a 00                	push   $0x0
  pushl $30
801081f7:	6a 1e                	push   $0x1e
  jmp alltraps
801081f9:	e9 a7 f9 ff ff       	jmp    80107ba5 <alltraps>

801081fe <vector31>:
.globl vector31
vector31:
  pushl $0
801081fe:	6a 00                	push   $0x0
  pushl $31
80108200:	6a 1f                	push   $0x1f
  jmp alltraps
80108202:	e9 9e f9 ff ff       	jmp    80107ba5 <alltraps>

80108207 <vector32>:
.globl vector32
vector32:
  pushl $0
80108207:	6a 00                	push   $0x0
  pushl $32
80108209:	6a 20                	push   $0x20
  jmp alltraps
8010820b:	e9 95 f9 ff ff       	jmp    80107ba5 <alltraps>

80108210 <vector33>:
.globl vector33
vector33:
  pushl $0
80108210:	6a 00                	push   $0x0
  pushl $33
80108212:	6a 21                	push   $0x21
  jmp alltraps
80108214:	e9 8c f9 ff ff       	jmp    80107ba5 <alltraps>

80108219 <vector34>:
.globl vector34
vector34:
  pushl $0
80108219:	6a 00                	push   $0x0
  pushl $34
8010821b:	6a 22                	push   $0x22
  jmp alltraps
8010821d:	e9 83 f9 ff ff       	jmp    80107ba5 <alltraps>

80108222 <vector35>:
.globl vector35
vector35:
  pushl $0
80108222:	6a 00                	push   $0x0
  pushl $35
80108224:	6a 23                	push   $0x23
  jmp alltraps
80108226:	e9 7a f9 ff ff       	jmp    80107ba5 <alltraps>

8010822b <vector36>:
.globl vector36
vector36:
  pushl $0
8010822b:	6a 00                	push   $0x0
  pushl $36
8010822d:	6a 24                	push   $0x24
  jmp alltraps
8010822f:	e9 71 f9 ff ff       	jmp    80107ba5 <alltraps>

80108234 <vector37>:
.globl vector37
vector37:
  pushl $0
80108234:	6a 00                	push   $0x0
  pushl $37
80108236:	6a 25                	push   $0x25
  jmp alltraps
80108238:	e9 68 f9 ff ff       	jmp    80107ba5 <alltraps>

8010823d <vector38>:
.globl vector38
vector38:
  pushl $0
8010823d:	6a 00                	push   $0x0
  pushl $38
8010823f:	6a 26                	push   $0x26
  jmp alltraps
80108241:	e9 5f f9 ff ff       	jmp    80107ba5 <alltraps>

80108246 <vector39>:
.globl vector39
vector39:
  pushl $0
80108246:	6a 00                	push   $0x0
  pushl $39
80108248:	6a 27                	push   $0x27
  jmp alltraps
8010824a:	e9 56 f9 ff ff       	jmp    80107ba5 <alltraps>

8010824f <vector40>:
.globl vector40
vector40:
  pushl $0
8010824f:	6a 00                	push   $0x0
  pushl $40
80108251:	6a 28                	push   $0x28
  jmp alltraps
80108253:	e9 4d f9 ff ff       	jmp    80107ba5 <alltraps>

80108258 <vector41>:
.globl vector41
vector41:
  pushl $0
80108258:	6a 00                	push   $0x0
  pushl $41
8010825a:	6a 29                	push   $0x29
  jmp alltraps
8010825c:	e9 44 f9 ff ff       	jmp    80107ba5 <alltraps>

80108261 <vector42>:
.globl vector42
vector42:
  pushl $0
80108261:	6a 00                	push   $0x0
  pushl $42
80108263:	6a 2a                	push   $0x2a
  jmp alltraps
80108265:	e9 3b f9 ff ff       	jmp    80107ba5 <alltraps>

8010826a <vector43>:
.globl vector43
vector43:
  pushl $0
8010826a:	6a 00                	push   $0x0
  pushl $43
8010826c:	6a 2b                	push   $0x2b
  jmp alltraps
8010826e:	e9 32 f9 ff ff       	jmp    80107ba5 <alltraps>

80108273 <vector44>:
.globl vector44
vector44:
  pushl $0
80108273:	6a 00                	push   $0x0
  pushl $44
80108275:	6a 2c                	push   $0x2c
  jmp alltraps
80108277:	e9 29 f9 ff ff       	jmp    80107ba5 <alltraps>

8010827c <vector45>:
.globl vector45
vector45:
  pushl $0
8010827c:	6a 00                	push   $0x0
  pushl $45
8010827e:	6a 2d                	push   $0x2d
  jmp alltraps
80108280:	e9 20 f9 ff ff       	jmp    80107ba5 <alltraps>

80108285 <vector46>:
.globl vector46
vector46:
  pushl $0
80108285:	6a 00                	push   $0x0
  pushl $46
80108287:	6a 2e                	push   $0x2e
  jmp alltraps
80108289:	e9 17 f9 ff ff       	jmp    80107ba5 <alltraps>

8010828e <vector47>:
.globl vector47
vector47:
  pushl $0
8010828e:	6a 00                	push   $0x0
  pushl $47
80108290:	6a 2f                	push   $0x2f
  jmp alltraps
80108292:	e9 0e f9 ff ff       	jmp    80107ba5 <alltraps>

80108297 <vector48>:
.globl vector48
vector48:
  pushl $0
80108297:	6a 00                	push   $0x0
  pushl $48
80108299:	6a 30                	push   $0x30
  jmp alltraps
8010829b:	e9 05 f9 ff ff       	jmp    80107ba5 <alltraps>

801082a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801082a0:	6a 00                	push   $0x0
  pushl $49
801082a2:	6a 31                	push   $0x31
  jmp alltraps
801082a4:	e9 fc f8 ff ff       	jmp    80107ba5 <alltraps>

801082a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801082a9:	6a 00                	push   $0x0
  pushl $50
801082ab:	6a 32                	push   $0x32
  jmp alltraps
801082ad:	e9 f3 f8 ff ff       	jmp    80107ba5 <alltraps>

801082b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801082b2:	6a 00                	push   $0x0
  pushl $51
801082b4:	6a 33                	push   $0x33
  jmp alltraps
801082b6:	e9 ea f8 ff ff       	jmp    80107ba5 <alltraps>

801082bb <vector52>:
.globl vector52
vector52:
  pushl $0
801082bb:	6a 00                	push   $0x0
  pushl $52
801082bd:	6a 34                	push   $0x34
  jmp alltraps
801082bf:	e9 e1 f8 ff ff       	jmp    80107ba5 <alltraps>

801082c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801082c4:	6a 00                	push   $0x0
  pushl $53
801082c6:	6a 35                	push   $0x35
  jmp alltraps
801082c8:	e9 d8 f8 ff ff       	jmp    80107ba5 <alltraps>

801082cd <vector54>:
.globl vector54
vector54:
  pushl $0
801082cd:	6a 00                	push   $0x0
  pushl $54
801082cf:	6a 36                	push   $0x36
  jmp alltraps
801082d1:	e9 cf f8 ff ff       	jmp    80107ba5 <alltraps>

801082d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801082d6:	6a 00                	push   $0x0
  pushl $55
801082d8:	6a 37                	push   $0x37
  jmp alltraps
801082da:	e9 c6 f8 ff ff       	jmp    80107ba5 <alltraps>

801082df <vector56>:
.globl vector56
vector56:
  pushl $0
801082df:	6a 00                	push   $0x0
  pushl $56
801082e1:	6a 38                	push   $0x38
  jmp alltraps
801082e3:	e9 bd f8 ff ff       	jmp    80107ba5 <alltraps>

801082e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801082e8:	6a 00                	push   $0x0
  pushl $57
801082ea:	6a 39                	push   $0x39
  jmp alltraps
801082ec:	e9 b4 f8 ff ff       	jmp    80107ba5 <alltraps>

801082f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801082f1:	6a 00                	push   $0x0
  pushl $58
801082f3:	6a 3a                	push   $0x3a
  jmp alltraps
801082f5:	e9 ab f8 ff ff       	jmp    80107ba5 <alltraps>

801082fa <vector59>:
.globl vector59
vector59:
  pushl $0
801082fa:	6a 00                	push   $0x0
  pushl $59
801082fc:	6a 3b                	push   $0x3b
  jmp alltraps
801082fe:	e9 a2 f8 ff ff       	jmp    80107ba5 <alltraps>

80108303 <vector60>:
.globl vector60
vector60:
  pushl $0
80108303:	6a 00                	push   $0x0
  pushl $60
80108305:	6a 3c                	push   $0x3c
  jmp alltraps
80108307:	e9 99 f8 ff ff       	jmp    80107ba5 <alltraps>

8010830c <vector61>:
.globl vector61
vector61:
  pushl $0
8010830c:	6a 00                	push   $0x0
  pushl $61
8010830e:	6a 3d                	push   $0x3d
  jmp alltraps
80108310:	e9 90 f8 ff ff       	jmp    80107ba5 <alltraps>

80108315 <vector62>:
.globl vector62
vector62:
  pushl $0
80108315:	6a 00                	push   $0x0
  pushl $62
80108317:	6a 3e                	push   $0x3e
  jmp alltraps
80108319:	e9 87 f8 ff ff       	jmp    80107ba5 <alltraps>

8010831e <vector63>:
.globl vector63
vector63:
  pushl $0
8010831e:	6a 00                	push   $0x0
  pushl $63
80108320:	6a 3f                	push   $0x3f
  jmp alltraps
80108322:	e9 7e f8 ff ff       	jmp    80107ba5 <alltraps>

80108327 <vector64>:
.globl vector64
vector64:
  pushl $0
80108327:	6a 00                	push   $0x0
  pushl $64
80108329:	6a 40                	push   $0x40
  jmp alltraps
8010832b:	e9 75 f8 ff ff       	jmp    80107ba5 <alltraps>

80108330 <vector65>:
.globl vector65
vector65:
  pushl $0
80108330:	6a 00                	push   $0x0
  pushl $65
80108332:	6a 41                	push   $0x41
  jmp alltraps
80108334:	e9 6c f8 ff ff       	jmp    80107ba5 <alltraps>

80108339 <vector66>:
.globl vector66
vector66:
  pushl $0
80108339:	6a 00                	push   $0x0
  pushl $66
8010833b:	6a 42                	push   $0x42
  jmp alltraps
8010833d:	e9 63 f8 ff ff       	jmp    80107ba5 <alltraps>

80108342 <vector67>:
.globl vector67
vector67:
  pushl $0
80108342:	6a 00                	push   $0x0
  pushl $67
80108344:	6a 43                	push   $0x43
  jmp alltraps
80108346:	e9 5a f8 ff ff       	jmp    80107ba5 <alltraps>

8010834b <vector68>:
.globl vector68
vector68:
  pushl $0
8010834b:	6a 00                	push   $0x0
  pushl $68
8010834d:	6a 44                	push   $0x44
  jmp alltraps
8010834f:	e9 51 f8 ff ff       	jmp    80107ba5 <alltraps>

80108354 <vector69>:
.globl vector69
vector69:
  pushl $0
80108354:	6a 00                	push   $0x0
  pushl $69
80108356:	6a 45                	push   $0x45
  jmp alltraps
80108358:	e9 48 f8 ff ff       	jmp    80107ba5 <alltraps>

8010835d <vector70>:
.globl vector70
vector70:
  pushl $0
8010835d:	6a 00                	push   $0x0
  pushl $70
8010835f:	6a 46                	push   $0x46
  jmp alltraps
80108361:	e9 3f f8 ff ff       	jmp    80107ba5 <alltraps>

80108366 <vector71>:
.globl vector71
vector71:
  pushl $0
80108366:	6a 00                	push   $0x0
  pushl $71
80108368:	6a 47                	push   $0x47
  jmp alltraps
8010836a:	e9 36 f8 ff ff       	jmp    80107ba5 <alltraps>

8010836f <vector72>:
.globl vector72
vector72:
  pushl $0
8010836f:	6a 00                	push   $0x0
  pushl $72
80108371:	6a 48                	push   $0x48
  jmp alltraps
80108373:	e9 2d f8 ff ff       	jmp    80107ba5 <alltraps>

80108378 <vector73>:
.globl vector73
vector73:
  pushl $0
80108378:	6a 00                	push   $0x0
  pushl $73
8010837a:	6a 49                	push   $0x49
  jmp alltraps
8010837c:	e9 24 f8 ff ff       	jmp    80107ba5 <alltraps>

80108381 <vector74>:
.globl vector74
vector74:
  pushl $0
80108381:	6a 00                	push   $0x0
  pushl $74
80108383:	6a 4a                	push   $0x4a
  jmp alltraps
80108385:	e9 1b f8 ff ff       	jmp    80107ba5 <alltraps>

8010838a <vector75>:
.globl vector75
vector75:
  pushl $0
8010838a:	6a 00                	push   $0x0
  pushl $75
8010838c:	6a 4b                	push   $0x4b
  jmp alltraps
8010838e:	e9 12 f8 ff ff       	jmp    80107ba5 <alltraps>

80108393 <vector76>:
.globl vector76
vector76:
  pushl $0
80108393:	6a 00                	push   $0x0
  pushl $76
80108395:	6a 4c                	push   $0x4c
  jmp alltraps
80108397:	e9 09 f8 ff ff       	jmp    80107ba5 <alltraps>

8010839c <vector77>:
.globl vector77
vector77:
  pushl $0
8010839c:	6a 00                	push   $0x0
  pushl $77
8010839e:	6a 4d                	push   $0x4d
  jmp alltraps
801083a0:	e9 00 f8 ff ff       	jmp    80107ba5 <alltraps>

801083a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801083a5:	6a 00                	push   $0x0
  pushl $78
801083a7:	6a 4e                	push   $0x4e
  jmp alltraps
801083a9:	e9 f7 f7 ff ff       	jmp    80107ba5 <alltraps>

801083ae <vector79>:
.globl vector79
vector79:
  pushl $0
801083ae:	6a 00                	push   $0x0
  pushl $79
801083b0:	6a 4f                	push   $0x4f
  jmp alltraps
801083b2:	e9 ee f7 ff ff       	jmp    80107ba5 <alltraps>

801083b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801083b7:	6a 00                	push   $0x0
  pushl $80
801083b9:	6a 50                	push   $0x50
  jmp alltraps
801083bb:	e9 e5 f7 ff ff       	jmp    80107ba5 <alltraps>

801083c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801083c0:	6a 00                	push   $0x0
  pushl $81
801083c2:	6a 51                	push   $0x51
  jmp alltraps
801083c4:	e9 dc f7 ff ff       	jmp    80107ba5 <alltraps>

801083c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801083c9:	6a 00                	push   $0x0
  pushl $82
801083cb:	6a 52                	push   $0x52
  jmp alltraps
801083cd:	e9 d3 f7 ff ff       	jmp    80107ba5 <alltraps>

801083d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801083d2:	6a 00                	push   $0x0
  pushl $83
801083d4:	6a 53                	push   $0x53
  jmp alltraps
801083d6:	e9 ca f7 ff ff       	jmp    80107ba5 <alltraps>

801083db <vector84>:
.globl vector84
vector84:
  pushl $0
801083db:	6a 00                	push   $0x0
  pushl $84
801083dd:	6a 54                	push   $0x54
  jmp alltraps
801083df:	e9 c1 f7 ff ff       	jmp    80107ba5 <alltraps>

801083e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801083e4:	6a 00                	push   $0x0
  pushl $85
801083e6:	6a 55                	push   $0x55
  jmp alltraps
801083e8:	e9 b8 f7 ff ff       	jmp    80107ba5 <alltraps>

801083ed <vector86>:
.globl vector86
vector86:
  pushl $0
801083ed:	6a 00                	push   $0x0
  pushl $86
801083ef:	6a 56                	push   $0x56
  jmp alltraps
801083f1:	e9 af f7 ff ff       	jmp    80107ba5 <alltraps>

801083f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801083f6:	6a 00                	push   $0x0
  pushl $87
801083f8:	6a 57                	push   $0x57
  jmp alltraps
801083fa:	e9 a6 f7 ff ff       	jmp    80107ba5 <alltraps>

801083ff <vector88>:
.globl vector88
vector88:
  pushl $0
801083ff:	6a 00                	push   $0x0
  pushl $88
80108401:	6a 58                	push   $0x58
  jmp alltraps
80108403:	e9 9d f7 ff ff       	jmp    80107ba5 <alltraps>

80108408 <vector89>:
.globl vector89
vector89:
  pushl $0
80108408:	6a 00                	push   $0x0
  pushl $89
8010840a:	6a 59                	push   $0x59
  jmp alltraps
8010840c:	e9 94 f7 ff ff       	jmp    80107ba5 <alltraps>

80108411 <vector90>:
.globl vector90
vector90:
  pushl $0
80108411:	6a 00                	push   $0x0
  pushl $90
80108413:	6a 5a                	push   $0x5a
  jmp alltraps
80108415:	e9 8b f7 ff ff       	jmp    80107ba5 <alltraps>

8010841a <vector91>:
.globl vector91
vector91:
  pushl $0
8010841a:	6a 00                	push   $0x0
  pushl $91
8010841c:	6a 5b                	push   $0x5b
  jmp alltraps
8010841e:	e9 82 f7 ff ff       	jmp    80107ba5 <alltraps>

80108423 <vector92>:
.globl vector92
vector92:
  pushl $0
80108423:	6a 00                	push   $0x0
  pushl $92
80108425:	6a 5c                	push   $0x5c
  jmp alltraps
80108427:	e9 79 f7 ff ff       	jmp    80107ba5 <alltraps>

8010842c <vector93>:
.globl vector93
vector93:
  pushl $0
8010842c:	6a 00                	push   $0x0
  pushl $93
8010842e:	6a 5d                	push   $0x5d
  jmp alltraps
80108430:	e9 70 f7 ff ff       	jmp    80107ba5 <alltraps>

80108435 <vector94>:
.globl vector94
vector94:
  pushl $0
80108435:	6a 00                	push   $0x0
  pushl $94
80108437:	6a 5e                	push   $0x5e
  jmp alltraps
80108439:	e9 67 f7 ff ff       	jmp    80107ba5 <alltraps>

8010843e <vector95>:
.globl vector95
vector95:
  pushl $0
8010843e:	6a 00                	push   $0x0
  pushl $95
80108440:	6a 5f                	push   $0x5f
  jmp alltraps
80108442:	e9 5e f7 ff ff       	jmp    80107ba5 <alltraps>

80108447 <vector96>:
.globl vector96
vector96:
  pushl $0
80108447:	6a 00                	push   $0x0
  pushl $96
80108449:	6a 60                	push   $0x60
  jmp alltraps
8010844b:	e9 55 f7 ff ff       	jmp    80107ba5 <alltraps>

80108450 <vector97>:
.globl vector97
vector97:
  pushl $0
80108450:	6a 00                	push   $0x0
  pushl $97
80108452:	6a 61                	push   $0x61
  jmp alltraps
80108454:	e9 4c f7 ff ff       	jmp    80107ba5 <alltraps>

80108459 <vector98>:
.globl vector98
vector98:
  pushl $0
80108459:	6a 00                	push   $0x0
  pushl $98
8010845b:	6a 62                	push   $0x62
  jmp alltraps
8010845d:	e9 43 f7 ff ff       	jmp    80107ba5 <alltraps>

80108462 <vector99>:
.globl vector99
vector99:
  pushl $0
80108462:	6a 00                	push   $0x0
  pushl $99
80108464:	6a 63                	push   $0x63
  jmp alltraps
80108466:	e9 3a f7 ff ff       	jmp    80107ba5 <alltraps>

8010846b <vector100>:
.globl vector100
vector100:
  pushl $0
8010846b:	6a 00                	push   $0x0
  pushl $100
8010846d:	6a 64                	push   $0x64
  jmp alltraps
8010846f:	e9 31 f7 ff ff       	jmp    80107ba5 <alltraps>

80108474 <vector101>:
.globl vector101
vector101:
  pushl $0
80108474:	6a 00                	push   $0x0
  pushl $101
80108476:	6a 65                	push   $0x65
  jmp alltraps
80108478:	e9 28 f7 ff ff       	jmp    80107ba5 <alltraps>

8010847d <vector102>:
.globl vector102
vector102:
  pushl $0
8010847d:	6a 00                	push   $0x0
  pushl $102
8010847f:	6a 66                	push   $0x66
  jmp alltraps
80108481:	e9 1f f7 ff ff       	jmp    80107ba5 <alltraps>

80108486 <vector103>:
.globl vector103
vector103:
  pushl $0
80108486:	6a 00                	push   $0x0
  pushl $103
80108488:	6a 67                	push   $0x67
  jmp alltraps
8010848a:	e9 16 f7 ff ff       	jmp    80107ba5 <alltraps>

8010848f <vector104>:
.globl vector104
vector104:
  pushl $0
8010848f:	6a 00                	push   $0x0
  pushl $104
80108491:	6a 68                	push   $0x68
  jmp alltraps
80108493:	e9 0d f7 ff ff       	jmp    80107ba5 <alltraps>

80108498 <vector105>:
.globl vector105
vector105:
  pushl $0
80108498:	6a 00                	push   $0x0
  pushl $105
8010849a:	6a 69                	push   $0x69
  jmp alltraps
8010849c:	e9 04 f7 ff ff       	jmp    80107ba5 <alltraps>

801084a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801084a1:	6a 00                	push   $0x0
  pushl $106
801084a3:	6a 6a                	push   $0x6a
  jmp alltraps
801084a5:	e9 fb f6 ff ff       	jmp    80107ba5 <alltraps>

801084aa <vector107>:
.globl vector107
vector107:
  pushl $0
801084aa:	6a 00                	push   $0x0
  pushl $107
801084ac:	6a 6b                	push   $0x6b
  jmp alltraps
801084ae:	e9 f2 f6 ff ff       	jmp    80107ba5 <alltraps>

801084b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801084b3:	6a 00                	push   $0x0
  pushl $108
801084b5:	6a 6c                	push   $0x6c
  jmp alltraps
801084b7:	e9 e9 f6 ff ff       	jmp    80107ba5 <alltraps>

801084bc <vector109>:
.globl vector109
vector109:
  pushl $0
801084bc:	6a 00                	push   $0x0
  pushl $109
801084be:	6a 6d                	push   $0x6d
  jmp alltraps
801084c0:	e9 e0 f6 ff ff       	jmp    80107ba5 <alltraps>

801084c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801084c5:	6a 00                	push   $0x0
  pushl $110
801084c7:	6a 6e                	push   $0x6e
  jmp alltraps
801084c9:	e9 d7 f6 ff ff       	jmp    80107ba5 <alltraps>

801084ce <vector111>:
.globl vector111
vector111:
  pushl $0
801084ce:	6a 00                	push   $0x0
  pushl $111
801084d0:	6a 6f                	push   $0x6f
  jmp alltraps
801084d2:	e9 ce f6 ff ff       	jmp    80107ba5 <alltraps>

801084d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801084d7:	6a 00                	push   $0x0
  pushl $112
801084d9:	6a 70                	push   $0x70
  jmp alltraps
801084db:	e9 c5 f6 ff ff       	jmp    80107ba5 <alltraps>

801084e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801084e0:	6a 00                	push   $0x0
  pushl $113
801084e2:	6a 71                	push   $0x71
  jmp alltraps
801084e4:	e9 bc f6 ff ff       	jmp    80107ba5 <alltraps>

801084e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801084e9:	6a 00                	push   $0x0
  pushl $114
801084eb:	6a 72                	push   $0x72
  jmp alltraps
801084ed:	e9 b3 f6 ff ff       	jmp    80107ba5 <alltraps>

801084f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801084f2:	6a 00                	push   $0x0
  pushl $115
801084f4:	6a 73                	push   $0x73
  jmp alltraps
801084f6:	e9 aa f6 ff ff       	jmp    80107ba5 <alltraps>

801084fb <vector116>:
.globl vector116
vector116:
  pushl $0
801084fb:	6a 00                	push   $0x0
  pushl $116
801084fd:	6a 74                	push   $0x74
  jmp alltraps
801084ff:	e9 a1 f6 ff ff       	jmp    80107ba5 <alltraps>

80108504 <vector117>:
.globl vector117
vector117:
  pushl $0
80108504:	6a 00                	push   $0x0
  pushl $117
80108506:	6a 75                	push   $0x75
  jmp alltraps
80108508:	e9 98 f6 ff ff       	jmp    80107ba5 <alltraps>

8010850d <vector118>:
.globl vector118
vector118:
  pushl $0
8010850d:	6a 00                	push   $0x0
  pushl $118
8010850f:	6a 76                	push   $0x76
  jmp alltraps
80108511:	e9 8f f6 ff ff       	jmp    80107ba5 <alltraps>

80108516 <vector119>:
.globl vector119
vector119:
  pushl $0
80108516:	6a 00                	push   $0x0
  pushl $119
80108518:	6a 77                	push   $0x77
  jmp alltraps
8010851a:	e9 86 f6 ff ff       	jmp    80107ba5 <alltraps>

8010851f <vector120>:
.globl vector120
vector120:
  pushl $0
8010851f:	6a 00                	push   $0x0
  pushl $120
80108521:	6a 78                	push   $0x78
  jmp alltraps
80108523:	e9 7d f6 ff ff       	jmp    80107ba5 <alltraps>

80108528 <vector121>:
.globl vector121
vector121:
  pushl $0
80108528:	6a 00                	push   $0x0
  pushl $121
8010852a:	6a 79                	push   $0x79
  jmp alltraps
8010852c:	e9 74 f6 ff ff       	jmp    80107ba5 <alltraps>

80108531 <vector122>:
.globl vector122
vector122:
  pushl $0
80108531:	6a 00                	push   $0x0
  pushl $122
80108533:	6a 7a                	push   $0x7a
  jmp alltraps
80108535:	e9 6b f6 ff ff       	jmp    80107ba5 <alltraps>

8010853a <vector123>:
.globl vector123
vector123:
  pushl $0
8010853a:	6a 00                	push   $0x0
  pushl $123
8010853c:	6a 7b                	push   $0x7b
  jmp alltraps
8010853e:	e9 62 f6 ff ff       	jmp    80107ba5 <alltraps>

80108543 <vector124>:
.globl vector124
vector124:
  pushl $0
80108543:	6a 00                	push   $0x0
  pushl $124
80108545:	6a 7c                	push   $0x7c
  jmp alltraps
80108547:	e9 59 f6 ff ff       	jmp    80107ba5 <alltraps>

8010854c <vector125>:
.globl vector125
vector125:
  pushl $0
8010854c:	6a 00                	push   $0x0
  pushl $125
8010854e:	6a 7d                	push   $0x7d
  jmp alltraps
80108550:	e9 50 f6 ff ff       	jmp    80107ba5 <alltraps>

80108555 <vector126>:
.globl vector126
vector126:
  pushl $0
80108555:	6a 00                	push   $0x0
  pushl $126
80108557:	6a 7e                	push   $0x7e
  jmp alltraps
80108559:	e9 47 f6 ff ff       	jmp    80107ba5 <alltraps>

8010855e <vector127>:
.globl vector127
vector127:
  pushl $0
8010855e:	6a 00                	push   $0x0
  pushl $127
80108560:	6a 7f                	push   $0x7f
  jmp alltraps
80108562:	e9 3e f6 ff ff       	jmp    80107ba5 <alltraps>

80108567 <vector128>:
.globl vector128
vector128:
  pushl $0
80108567:	6a 00                	push   $0x0
  pushl $128
80108569:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010856e:	e9 32 f6 ff ff       	jmp    80107ba5 <alltraps>

80108573 <vector129>:
.globl vector129
vector129:
  pushl $0
80108573:	6a 00                	push   $0x0
  pushl $129
80108575:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010857a:	e9 26 f6 ff ff       	jmp    80107ba5 <alltraps>

8010857f <vector130>:
.globl vector130
vector130:
  pushl $0
8010857f:	6a 00                	push   $0x0
  pushl $130
80108581:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108586:	e9 1a f6 ff ff       	jmp    80107ba5 <alltraps>

8010858b <vector131>:
.globl vector131
vector131:
  pushl $0
8010858b:	6a 00                	push   $0x0
  pushl $131
8010858d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108592:	e9 0e f6 ff ff       	jmp    80107ba5 <alltraps>

80108597 <vector132>:
.globl vector132
vector132:
  pushl $0
80108597:	6a 00                	push   $0x0
  pushl $132
80108599:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010859e:	e9 02 f6 ff ff       	jmp    80107ba5 <alltraps>

801085a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801085a3:	6a 00                	push   $0x0
  pushl $133
801085a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801085aa:	e9 f6 f5 ff ff       	jmp    80107ba5 <alltraps>

801085af <vector134>:
.globl vector134
vector134:
  pushl $0
801085af:	6a 00                	push   $0x0
  pushl $134
801085b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801085b6:	e9 ea f5 ff ff       	jmp    80107ba5 <alltraps>

801085bb <vector135>:
.globl vector135
vector135:
  pushl $0
801085bb:	6a 00                	push   $0x0
  pushl $135
801085bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801085c2:	e9 de f5 ff ff       	jmp    80107ba5 <alltraps>

801085c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801085c7:	6a 00                	push   $0x0
  pushl $136
801085c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801085ce:	e9 d2 f5 ff ff       	jmp    80107ba5 <alltraps>

801085d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801085d3:	6a 00                	push   $0x0
  pushl $137
801085d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801085da:	e9 c6 f5 ff ff       	jmp    80107ba5 <alltraps>

801085df <vector138>:
.globl vector138
vector138:
  pushl $0
801085df:	6a 00                	push   $0x0
  pushl $138
801085e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801085e6:	e9 ba f5 ff ff       	jmp    80107ba5 <alltraps>

801085eb <vector139>:
.globl vector139
vector139:
  pushl $0
801085eb:	6a 00                	push   $0x0
  pushl $139
801085ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801085f2:	e9 ae f5 ff ff       	jmp    80107ba5 <alltraps>

801085f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801085f7:	6a 00                	push   $0x0
  pushl $140
801085f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801085fe:	e9 a2 f5 ff ff       	jmp    80107ba5 <alltraps>

80108603 <vector141>:
.globl vector141
vector141:
  pushl $0
80108603:	6a 00                	push   $0x0
  pushl $141
80108605:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010860a:	e9 96 f5 ff ff       	jmp    80107ba5 <alltraps>

8010860f <vector142>:
.globl vector142
vector142:
  pushl $0
8010860f:	6a 00                	push   $0x0
  pushl $142
80108611:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108616:	e9 8a f5 ff ff       	jmp    80107ba5 <alltraps>

8010861b <vector143>:
.globl vector143
vector143:
  pushl $0
8010861b:	6a 00                	push   $0x0
  pushl $143
8010861d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108622:	e9 7e f5 ff ff       	jmp    80107ba5 <alltraps>

80108627 <vector144>:
.globl vector144
vector144:
  pushl $0
80108627:	6a 00                	push   $0x0
  pushl $144
80108629:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010862e:	e9 72 f5 ff ff       	jmp    80107ba5 <alltraps>

80108633 <vector145>:
.globl vector145
vector145:
  pushl $0
80108633:	6a 00                	push   $0x0
  pushl $145
80108635:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010863a:	e9 66 f5 ff ff       	jmp    80107ba5 <alltraps>

8010863f <vector146>:
.globl vector146
vector146:
  pushl $0
8010863f:	6a 00                	push   $0x0
  pushl $146
80108641:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108646:	e9 5a f5 ff ff       	jmp    80107ba5 <alltraps>

8010864b <vector147>:
.globl vector147
vector147:
  pushl $0
8010864b:	6a 00                	push   $0x0
  pushl $147
8010864d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108652:	e9 4e f5 ff ff       	jmp    80107ba5 <alltraps>

80108657 <vector148>:
.globl vector148
vector148:
  pushl $0
80108657:	6a 00                	push   $0x0
  pushl $148
80108659:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010865e:	e9 42 f5 ff ff       	jmp    80107ba5 <alltraps>

80108663 <vector149>:
.globl vector149
vector149:
  pushl $0
80108663:	6a 00                	push   $0x0
  pushl $149
80108665:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010866a:	e9 36 f5 ff ff       	jmp    80107ba5 <alltraps>

8010866f <vector150>:
.globl vector150
vector150:
  pushl $0
8010866f:	6a 00                	push   $0x0
  pushl $150
80108671:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108676:	e9 2a f5 ff ff       	jmp    80107ba5 <alltraps>

8010867b <vector151>:
.globl vector151
vector151:
  pushl $0
8010867b:	6a 00                	push   $0x0
  pushl $151
8010867d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108682:	e9 1e f5 ff ff       	jmp    80107ba5 <alltraps>

80108687 <vector152>:
.globl vector152
vector152:
  pushl $0
80108687:	6a 00                	push   $0x0
  pushl $152
80108689:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010868e:	e9 12 f5 ff ff       	jmp    80107ba5 <alltraps>

80108693 <vector153>:
.globl vector153
vector153:
  pushl $0
80108693:	6a 00                	push   $0x0
  pushl $153
80108695:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010869a:	e9 06 f5 ff ff       	jmp    80107ba5 <alltraps>

8010869f <vector154>:
.globl vector154
vector154:
  pushl $0
8010869f:	6a 00                	push   $0x0
  pushl $154
801086a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801086a6:	e9 fa f4 ff ff       	jmp    80107ba5 <alltraps>

801086ab <vector155>:
.globl vector155
vector155:
  pushl $0
801086ab:	6a 00                	push   $0x0
  pushl $155
801086ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801086b2:	e9 ee f4 ff ff       	jmp    80107ba5 <alltraps>

801086b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801086b7:	6a 00                	push   $0x0
  pushl $156
801086b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801086be:	e9 e2 f4 ff ff       	jmp    80107ba5 <alltraps>

801086c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801086c3:	6a 00                	push   $0x0
  pushl $157
801086c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801086ca:	e9 d6 f4 ff ff       	jmp    80107ba5 <alltraps>

801086cf <vector158>:
.globl vector158
vector158:
  pushl $0
801086cf:	6a 00                	push   $0x0
  pushl $158
801086d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801086d6:	e9 ca f4 ff ff       	jmp    80107ba5 <alltraps>

801086db <vector159>:
.globl vector159
vector159:
  pushl $0
801086db:	6a 00                	push   $0x0
  pushl $159
801086dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801086e2:	e9 be f4 ff ff       	jmp    80107ba5 <alltraps>

801086e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801086e7:	6a 00                	push   $0x0
  pushl $160
801086e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801086ee:	e9 b2 f4 ff ff       	jmp    80107ba5 <alltraps>

801086f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801086f3:	6a 00                	push   $0x0
  pushl $161
801086f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801086fa:	e9 a6 f4 ff ff       	jmp    80107ba5 <alltraps>

801086ff <vector162>:
.globl vector162
vector162:
  pushl $0
801086ff:	6a 00                	push   $0x0
  pushl $162
80108701:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108706:	e9 9a f4 ff ff       	jmp    80107ba5 <alltraps>

8010870b <vector163>:
.globl vector163
vector163:
  pushl $0
8010870b:	6a 00                	push   $0x0
  pushl $163
8010870d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108712:	e9 8e f4 ff ff       	jmp    80107ba5 <alltraps>

80108717 <vector164>:
.globl vector164
vector164:
  pushl $0
80108717:	6a 00                	push   $0x0
  pushl $164
80108719:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010871e:	e9 82 f4 ff ff       	jmp    80107ba5 <alltraps>

80108723 <vector165>:
.globl vector165
vector165:
  pushl $0
80108723:	6a 00                	push   $0x0
  pushl $165
80108725:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010872a:	e9 76 f4 ff ff       	jmp    80107ba5 <alltraps>

8010872f <vector166>:
.globl vector166
vector166:
  pushl $0
8010872f:	6a 00                	push   $0x0
  pushl $166
80108731:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108736:	e9 6a f4 ff ff       	jmp    80107ba5 <alltraps>

8010873b <vector167>:
.globl vector167
vector167:
  pushl $0
8010873b:	6a 00                	push   $0x0
  pushl $167
8010873d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108742:	e9 5e f4 ff ff       	jmp    80107ba5 <alltraps>

80108747 <vector168>:
.globl vector168
vector168:
  pushl $0
80108747:	6a 00                	push   $0x0
  pushl $168
80108749:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010874e:	e9 52 f4 ff ff       	jmp    80107ba5 <alltraps>

80108753 <vector169>:
.globl vector169
vector169:
  pushl $0
80108753:	6a 00                	push   $0x0
  pushl $169
80108755:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010875a:	e9 46 f4 ff ff       	jmp    80107ba5 <alltraps>

8010875f <vector170>:
.globl vector170
vector170:
  pushl $0
8010875f:	6a 00                	push   $0x0
  pushl $170
80108761:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108766:	e9 3a f4 ff ff       	jmp    80107ba5 <alltraps>

8010876b <vector171>:
.globl vector171
vector171:
  pushl $0
8010876b:	6a 00                	push   $0x0
  pushl $171
8010876d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108772:	e9 2e f4 ff ff       	jmp    80107ba5 <alltraps>

80108777 <vector172>:
.globl vector172
vector172:
  pushl $0
80108777:	6a 00                	push   $0x0
  pushl $172
80108779:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010877e:	e9 22 f4 ff ff       	jmp    80107ba5 <alltraps>

80108783 <vector173>:
.globl vector173
vector173:
  pushl $0
80108783:	6a 00                	push   $0x0
  pushl $173
80108785:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010878a:	e9 16 f4 ff ff       	jmp    80107ba5 <alltraps>

8010878f <vector174>:
.globl vector174
vector174:
  pushl $0
8010878f:	6a 00                	push   $0x0
  pushl $174
80108791:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108796:	e9 0a f4 ff ff       	jmp    80107ba5 <alltraps>

8010879b <vector175>:
.globl vector175
vector175:
  pushl $0
8010879b:	6a 00                	push   $0x0
  pushl $175
8010879d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801087a2:	e9 fe f3 ff ff       	jmp    80107ba5 <alltraps>

801087a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801087a7:	6a 00                	push   $0x0
  pushl $176
801087a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801087ae:	e9 f2 f3 ff ff       	jmp    80107ba5 <alltraps>

801087b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801087b3:	6a 00                	push   $0x0
  pushl $177
801087b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801087ba:	e9 e6 f3 ff ff       	jmp    80107ba5 <alltraps>

801087bf <vector178>:
.globl vector178
vector178:
  pushl $0
801087bf:	6a 00                	push   $0x0
  pushl $178
801087c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801087c6:	e9 da f3 ff ff       	jmp    80107ba5 <alltraps>

801087cb <vector179>:
.globl vector179
vector179:
  pushl $0
801087cb:	6a 00                	push   $0x0
  pushl $179
801087cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801087d2:	e9 ce f3 ff ff       	jmp    80107ba5 <alltraps>

801087d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801087d7:	6a 00                	push   $0x0
  pushl $180
801087d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801087de:	e9 c2 f3 ff ff       	jmp    80107ba5 <alltraps>

801087e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801087e3:	6a 00                	push   $0x0
  pushl $181
801087e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801087ea:	e9 b6 f3 ff ff       	jmp    80107ba5 <alltraps>

801087ef <vector182>:
.globl vector182
vector182:
  pushl $0
801087ef:	6a 00                	push   $0x0
  pushl $182
801087f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801087f6:	e9 aa f3 ff ff       	jmp    80107ba5 <alltraps>

801087fb <vector183>:
.globl vector183
vector183:
  pushl $0
801087fb:	6a 00                	push   $0x0
  pushl $183
801087fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108802:	e9 9e f3 ff ff       	jmp    80107ba5 <alltraps>

80108807 <vector184>:
.globl vector184
vector184:
  pushl $0
80108807:	6a 00                	push   $0x0
  pushl $184
80108809:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010880e:	e9 92 f3 ff ff       	jmp    80107ba5 <alltraps>

80108813 <vector185>:
.globl vector185
vector185:
  pushl $0
80108813:	6a 00                	push   $0x0
  pushl $185
80108815:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010881a:	e9 86 f3 ff ff       	jmp    80107ba5 <alltraps>

8010881f <vector186>:
.globl vector186
vector186:
  pushl $0
8010881f:	6a 00                	push   $0x0
  pushl $186
80108821:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108826:	e9 7a f3 ff ff       	jmp    80107ba5 <alltraps>

8010882b <vector187>:
.globl vector187
vector187:
  pushl $0
8010882b:	6a 00                	push   $0x0
  pushl $187
8010882d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108832:	e9 6e f3 ff ff       	jmp    80107ba5 <alltraps>

80108837 <vector188>:
.globl vector188
vector188:
  pushl $0
80108837:	6a 00                	push   $0x0
  pushl $188
80108839:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010883e:	e9 62 f3 ff ff       	jmp    80107ba5 <alltraps>

80108843 <vector189>:
.globl vector189
vector189:
  pushl $0
80108843:	6a 00                	push   $0x0
  pushl $189
80108845:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010884a:	e9 56 f3 ff ff       	jmp    80107ba5 <alltraps>

8010884f <vector190>:
.globl vector190
vector190:
  pushl $0
8010884f:	6a 00                	push   $0x0
  pushl $190
80108851:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108856:	e9 4a f3 ff ff       	jmp    80107ba5 <alltraps>

8010885b <vector191>:
.globl vector191
vector191:
  pushl $0
8010885b:	6a 00                	push   $0x0
  pushl $191
8010885d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108862:	e9 3e f3 ff ff       	jmp    80107ba5 <alltraps>

80108867 <vector192>:
.globl vector192
vector192:
  pushl $0
80108867:	6a 00                	push   $0x0
  pushl $192
80108869:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010886e:	e9 32 f3 ff ff       	jmp    80107ba5 <alltraps>

80108873 <vector193>:
.globl vector193
vector193:
  pushl $0
80108873:	6a 00                	push   $0x0
  pushl $193
80108875:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010887a:	e9 26 f3 ff ff       	jmp    80107ba5 <alltraps>

8010887f <vector194>:
.globl vector194
vector194:
  pushl $0
8010887f:	6a 00                	push   $0x0
  pushl $194
80108881:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108886:	e9 1a f3 ff ff       	jmp    80107ba5 <alltraps>

8010888b <vector195>:
.globl vector195
vector195:
  pushl $0
8010888b:	6a 00                	push   $0x0
  pushl $195
8010888d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108892:	e9 0e f3 ff ff       	jmp    80107ba5 <alltraps>

80108897 <vector196>:
.globl vector196
vector196:
  pushl $0
80108897:	6a 00                	push   $0x0
  pushl $196
80108899:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010889e:	e9 02 f3 ff ff       	jmp    80107ba5 <alltraps>

801088a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801088a3:	6a 00                	push   $0x0
  pushl $197
801088a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801088aa:	e9 f6 f2 ff ff       	jmp    80107ba5 <alltraps>

801088af <vector198>:
.globl vector198
vector198:
  pushl $0
801088af:	6a 00                	push   $0x0
  pushl $198
801088b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801088b6:	e9 ea f2 ff ff       	jmp    80107ba5 <alltraps>

801088bb <vector199>:
.globl vector199
vector199:
  pushl $0
801088bb:	6a 00                	push   $0x0
  pushl $199
801088bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801088c2:	e9 de f2 ff ff       	jmp    80107ba5 <alltraps>

801088c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801088c7:	6a 00                	push   $0x0
  pushl $200
801088c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801088ce:	e9 d2 f2 ff ff       	jmp    80107ba5 <alltraps>

801088d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801088d3:	6a 00                	push   $0x0
  pushl $201
801088d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801088da:	e9 c6 f2 ff ff       	jmp    80107ba5 <alltraps>

801088df <vector202>:
.globl vector202
vector202:
  pushl $0
801088df:	6a 00                	push   $0x0
  pushl $202
801088e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801088e6:	e9 ba f2 ff ff       	jmp    80107ba5 <alltraps>

801088eb <vector203>:
.globl vector203
vector203:
  pushl $0
801088eb:	6a 00                	push   $0x0
  pushl $203
801088ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801088f2:	e9 ae f2 ff ff       	jmp    80107ba5 <alltraps>

801088f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801088f7:	6a 00                	push   $0x0
  pushl $204
801088f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801088fe:	e9 a2 f2 ff ff       	jmp    80107ba5 <alltraps>

80108903 <vector205>:
.globl vector205
vector205:
  pushl $0
80108903:	6a 00                	push   $0x0
  pushl $205
80108905:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010890a:	e9 96 f2 ff ff       	jmp    80107ba5 <alltraps>

8010890f <vector206>:
.globl vector206
vector206:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $206
80108911:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108916:	e9 8a f2 ff ff       	jmp    80107ba5 <alltraps>

8010891b <vector207>:
.globl vector207
vector207:
  pushl $0
8010891b:	6a 00                	push   $0x0
  pushl $207
8010891d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108922:	e9 7e f2 ff ff       	jmp    80107ba5 <alltraps>

80108927 <vector208>:
.globl vector208
vector208:
  pushl $0
80108927:	6a 00                	push   $0x0
  pushl $208
80108929:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010892e:	e9 72 f2 ff ff       	jmp    80107ba5 <alltraps>

80108933 <vector209>:
.globl vector209
vector209:
  pushl $0
80108933:	6a 00                	push   $0x0
  pushl $209
80108935:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010893a:	e9 66 f2 ff ff       	jmp    80107ba5 <alltraps>

8010893f <vector210>:
.globl vector210
vector210:
  pushl $0
8010893f:	6a 00                	push   $0x0
  pushl $210
80108941:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108946:	e9 5a f2 ff ff       	jmp    80107ba5 <alltraps>

8010894b <vector211>:
.globl vector211
vector211:
  pushl $0
8010894b:	6a 00                	push   $0x0
  pushl $211
8010894d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108952:	e9 4e f2 ff ff       	jmp    80107ba5 <alltraps>

80108957 <vector212>:
.globl vector212
vector212:
  pushl $0
80108957:	6a 00                	push   $0x0
  pushl $212
80108959:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010895e:	e9 42 f2 ff ff       	jmp    80107ba5 <alltraps>

80108963 <vector213>:
.globl vector213
vector213:
  pushl $0
80108963:	6a 00                	push   $0x0
  pushl $213
80108965:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010896a:	e9 36 f2 ff ff       	jmp    80107ba5 <alltraps>

8010896f <vector214>:
.globl vector214
vector214:
  pushl $0
8010896f:	6a 00                	push   $0x0
  pushl $214
80108971:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108976:	e9 2a f2 ff ff       	jmp    80107ba5 <alltraps>

8010897b <vector215>:
.globl vector215
vector215:
  pushl $0
8010897b:	6a 00                	push   $0x0
  pushl $215
8010897d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108982:	e9 1e f2 ff ff       	jmp    80107ba5 <alltraps>

80108987 <vector216>:
.globl vector216
vector216:
  pushl $0
80108987:	6a 00                	push   $0x0
  pushl $216
80108989:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010898e:	e9 12 f2 ff ff       	jmp    80107ba5 <alltraps>

80108993 <vector217>:
.globl vector217
vector217:
  pushl $0
80108993:	6a 00                	push   $0x0
  pushl $217
80108995:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010899a:	e9 06 f2 ff ff       	jmp    80107ba5 <alltraps>

8010899f <vector218>:
.globl vector218
vector218:
  pushl $0
8010899f:	6a 00                	push   $0x0
  pushl $218
801089a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801089a6:	e9 fa f1 ff ff       	jmp    80107ba5 <alltraps>

801089ab <vector219>:
.globl vector219
vector219:
  pushl $0
801089ab:	6a 00                	push   $0x0
  pushl $219
801089ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801089b2:	e9 ee f1 ff ff       	jmp    80107ba5 <alltraps>

801089b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801089b7:	6a 00                	push   $0x0
  pushl $220
801089b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801089be:	e9 e2 f1 ff ff       	jmp    80107ba5 <alltraps>

801089c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801089c3:	6a 00                	push   $0x0
  pushl $221
801089c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801089ca:	e9 d6 f1 ff ff       	jmp    80107ba5 <alltraps>

801089cf <vector222>:
.globl vector222
vector222:
  pushl $0
801089cf:	6a 00                	push   $0x0
  pushl $222
801089d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801089d6:	e9 ca f1 ff ff       	jmp    80107ba5 <alltraps>

801089db <vector223>:
.globl vector223
vector223:
  pushl $0
801089db:	6a 00                	push   $0x0
  pushl $223
801089dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801089e2:	e9 be f1 ff ff       	jmp    80107ba5 <alltraps>

801089e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801089e7:	6a 00                	push   $0x0
  pushl $224
801089e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801089ee:	e9 b2 f1 ff ff       	jmp    80107ba5 <alltraps>

801089f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801089f3:	6a 00                	push   $0x0
  pushl $225
801089f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801089fa:	e9 a6 f1 ff ff       	jmp    80107ba5 <alltraps>

801089ff <vector226>:
.globl vector226
vector226:
  pushl $0
801089ff:	6a 00                	push   $0x0
  pushl $226
80108a01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108a06:	e9 9a f1 ff ff       	jmp    80107ba5 <alltraps>

80108a0b <vector227>:
.globl vector227
vector227:
  pushl $0
80108a0b:	6a 00                	push   $0x0
  pushl $227
80108a0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108a12:	e9 8e f1 ff ff       	jmp    80107ba5 <alltraps>

80108a17 <vector228>:
.globl vector228
vector228:
  pushl $0
80108a17:	6a 00                	push   $0x0
  pushl $228
80108a19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108a1e:	e9 82 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a23 <vector229>:
.globl vector229
vector229:
  pushl $0
80108a23:	6a 00                	push   $0x0
  pushl $229
80108a25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108a2a:	e9 76 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a2f <vector230>:
.globl vector230
vector230:
  pushl $0
80108a2f:	6a 00                	push   $0x0
  pushl $230
80108a31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a36:	e9 6a f1 ff ff       	jmp    80107ba5 <alltraps>

80108a3b <vector231>:
.globl vector231
vector231:
  pushl $0
80108a3b:	6a 00                	push   $0x0
  pushl $231
80108a3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a42:	e9 5e f1 ff ff       	jmp    80107ba5 <alltraps>

80108a47 <vector232>:
.globl vector232
vector232:
  pushl $0
80108a47:	6a 00                	push   $0x0
  pushl $232
80108a49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a4e:	e9 52 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a53 <vector233>:
.globl vector233
vector233:
  pushl $0
80108a53:	6a 00                	push   $0x0
  pushl $233
80108a55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108a5a:	e9 46 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a5f <vector234>:
.globl vector234
vector234:
  pushl $0
80108a5f:	6a 00                	push   $0x0
  pushl $234
80108a61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108a66:	e9 3a f1 ff ff       	jmp    80107ba5 <alltraps>

80108a6b <vector235>:
.globl vector235
vector235:
  pushl $0
80108a6b:	6a 00                	push   $0x0
  pushl $235
80108a6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108a72:	e9 2e f1 ff ff       	jmp    80107ba5 <alltraps>

80108a77 <vector236>:
.globl vector236
vector236:
  pushl $0
80108a77:	6a 00                	push   $0x0
  pushl $236
80108a79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108a7e:	e9 22 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a83 <vector237>:
.globl vector237
vector237:
  pushl $0
80108a83:	6a 00                	push   $0x0
  pushl $237
80108a85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108a8a:	e9 16 f1 ff ff       	jmp    80107ba5 <alltraps>

80108a8f <vector238>:
.globl vector238
vector238:
  pushl $0
80108a8f:	6a 00                	push   $0x0
  pushl $238
80108a91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108a96:	e9 0a f1 ff ff       	jmp    80107ba5 <alltraps>

80108a9b <vector239>:
.globl vector239
vector239:
  pushl $0
80108a9b:	6a 00                	push   $0x0
  pushl $239
80108a9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108aa2:	e9 fe f0 ff ff       	jmp    80107ba5 <alltraps>

80108aa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80108aa7:	6a 00                	push   $0x0
  pushl $240
80108aa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108aae:	e9 f2 f0 ff ff       	jmp    80107ba5 <alltraps>

80108ab3 <vector241>:
.globl vector241
vector241:
  pushl $0
80108ab3:	6a 00                	push   $0x0
  pushl $241
80108ab5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108aba:	e9 e6 f0 ff ff       	jmp    80107ba5 <alltraps>

80108abf <vector242>:
.globl vector242
vector242:
  pushl $0
80108abf:	6a 00                	push   $0x0
  pushl $242
80108ac1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108ac6:	e9 da f0 ff ff       	jmp    80107ba5 <alltraps>

80108acb <vector243>:
.globl vector243
vector243:
  pushl $0
80108acb:	6a 00                	push   $0x0
  pushl $243
80108acd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108ad2:	e9 ce f0 ff ff       	jmp    80107ba5 <alltraps>

80108ad7 <vector244>:
.globl vector244
vector244:
  pushl $0
80108ad7:	6a 00                	push   $0x0
  pushl $244
80108ad9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108ade:	e9 c2 f0 ff ff       	jmp    80107ba5 <alltraps>

80108ae3 <vector245>:
.globl vector245
vector245:
  pushl $0
80108ae3:	6a 00                	push   $0x0
  pushl $245
80108ae5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108aea:	e9 b6 f0 ff ff       	jmp    80107ba5 <alltraps>

80108aef <vector246>:
.globl vector246
vector246:
  pushl $0
80108aef:	6a 00                	push   $0x0
  pushl $246
80108af1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108af6:	e9 aa f0 ff ff       	jmp    80107ba5 <alltraps>

80108afb <vector247>:
.globl vector247
vector247:
  pushl $0
80108afb:	6a 00                	push   $0x0
  pushl $247
80108afd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108b02:	e9 9e f0 ff ff       	jmp    80107ba5 <alltraps>

80108b07 <vector248>:
.globl vector248
vector248:
  pushl $0
80108b07:	6a 00                	push   $0x0
  pushl $248
80108b09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108b0e:	e9 92 f0 ff ff       	jmp    80107ba5 <alltraps>

80108b13 <vector249>:
.globl vector249
vector249:
  pushl $0
80108b13:	6a 00                	push   $0x0
  pushl $249
80108b15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108b1a:	e9 86 f0 ff ff       	jmp    80107ba5 <alltraps>

80108b1f <vector250>:
.globl vector250
vector250:
  pushl $0
80108b1f:	6a 00                	push   $0x0
  pushl $250
80108b21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108b26:	e9 7a f0 ff ff       	jmp    80107ba5 <alltraps>

80108b2b <vector251>:
.globl vector251
vector251:
  pushl $0
80108b2b:	6a 00                	push   $0x0
  pushl $251
80108b2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b32:	e9 6e f0 ff ff       	jmp    80107ba5 <alltraps>

80108b37 <vector252>:
.globl vector252
vector252:
  pushl $0
80108b37:	6a 00                	push   $0x0
  pushl $252
80108b39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b3e:	e9 62 f0 ff ff       	jmp    80107ba5 <alltraps>

80108b43 <vector253>:
.globl vector253
vector253:
  pushl $0
80108b43:	6a 00                	push   $0x0
  pushl $253
80108b45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b4a:	e9 56 f0 ff ff       	jmp    80107ba5 <alltraps>

80108b4f <vector254>:
.globl vector254
vector254:
  pushl $0
80108b4f:	6a 00                	push   $0x0
  pushl $254
80108b51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108b56:	e9 4a f0 ff ff       	jmp    80107ba5 <alltraps>

80108b5b <vector255>:
.globl vector255
vector255:
  pushl $0
80108b5b:	6a 00                	push   $0x0
  pushl $255
80108b5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108b62:	e9 3e f0 ff ff       	jmp    80107ba5 <alltraps>
80108b67:	66 90                	xchg   %ax,%ax
80108b69:	66 90                	xchg   %ax,%ax
80108b6b:	66 90                	xchg   %ax,%ax
80108b6d:	66 90                	xchg   %ax,%ax
80108b6f:	90                   	nop

80108b70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108b70:	55                   	push   %ebp
80108b71:	89 e5                	mov    %esp,%ebp
80108b73:	57                   	push   %edi
80108b74:	56                   	push   %esi
80108b75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108b76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80108b7c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108b82:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80108b85:	39 d3                	cmp    %edx,%ebx
80108b87:	73 56                	jae    80108bdf <deallocuvm.part.0+0x6f>
80108b89:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80108b8c:	89 c6                	mov    %eax,%esi
80108b8e:	89 d7                	mov    %edx,%edi
80108b90:	eb 12                	jmp    80108ba4 <deallocuvm.part.0+0x34>
80108b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108b98:	83 c2 01             	add    $0x1,%edx
80108b9b:	89 d3                	mov    %edx,%ebx
80108b9d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108ba0:	39 fb                	cmp    %edi,%ebx
80108ba2:	73 38                	jae    80108bdc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80108ba4:	89 da                	mov    %ebx,%edx
80108ba6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108ba9:	8b 04 96             	mov    (%esi,%edx,4),%eax
80108bac:	a8 01                	test   $0x1,%al
80108bae:	74 e8                	je     80108b98 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80108bb0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108bb7:	c1 e9 0a             	shr    $0xa,%ecx
80108bba:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80108bc0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80108bc7:	85 c0                	test   %eax,%eax
80108bc9:	74 cd                	je     80108b98 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80108bcb:	8b 10                	mov    (%eax),%edx
80108bcd:	f6 c2 01             	test   $0x1,%dl
80108bd0:	75 1e                	jne    80108bf0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80108bd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108bd8:	39 fb                	cmp    %edi,%ebx
80108bda:	72 c8                	jb     80108ba4 <deallocuvm.part.0+0x34>
80108bdc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80108bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108be2:	89 c8                	mov    %ecx,%eax
80108be4:	5b                   	pop    %ebx
80108be5:	5e                   	pop    %esi
80108be6:	5f                   	pop    %edi
80108be7:	5d                   	pop    %ebp
80108be8:	c3                   	ret
80108be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80108bf0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108bf6:	74 26                	je     80108c1e <deallocuvm.part.0+0xae>
      kfree(v);
80108bf8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80108bfb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108c04:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80108c0a:	52                   	push   %edx
80108c0b:	e8 30 ae ff ff       	call   80103a40 <kfree>
      *pte = 0;
80108c10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80108c13:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108c16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80108c1c:	eb 82                	jmp    80108ba0 <deallocuvm.part.0+0x30>
        panic("kfree");
80108c1e:	83 ec 0c             	sub    $0xc,%esp
80108c21:	68 0c 97 10 80       	push   $0x8010970c
80108c26:	e8 25 79 ff ff       	call   80100550 <panic>
80108c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108c30 <mappages>:
{
80108c30:	55                   	push   %ebp
80108c31:	89 e5                	mov    %esp,%ebp
80108c33:	57                   	push   %edi
80108c34:	56                   	push   %esi
80108c35:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108c36:	89 d3                	mov    %edx,%ebx
80108c38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80108c3e:	83 ec 1c             	sub    $0x1c,%esp
80108c41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108c44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108c48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108c50:	8b 45 08             	mov    0x8(%ebp),%eax
80108c53:	29 d8                	sub    %ebx,%eax
80108c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108c58:	eb 3f                	jmp    80108c99 <mappages+0x69>
80108c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108c60:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108c62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108c67:	c1 ea 0a             	shr    $0xa,%edx
80108c6a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108c70:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108c77:	85 c0                	test   %eax,%eax
80108c79:	74 75                	je     80108cf0 <mappages+0xc0>
    if(*pte & PTE_P)
80108c7b:	f6 00 01             	testb  $0x1,(%eax)
80108c7e:	0f 85 86 00 00 00    	jne    80108d0a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108c84:	0b 75 0c             	or     0xc(%ebp),%esi
80108c87:	83 ce 01             	or     $0x1,%esi
80108c8a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80108c8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c8f:	39 c3                	cmp    %eax,%ebx
80108c91:	74 6d                	je     80108d00 <mappages+0xd0>
    a += PGSIZE;
80108c93:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80108c9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108c9f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108ca2:	89 d8                	mov    %ebx,%eax
80108ca4:	c1 e8 16             	shr    $0x16,%eax
80108ca7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108caa:	8b 07                	mov    (%edi),%eax
80108cac:	a8 01                	test   $0x1,%al
80108cae:	75 b0                	jne    80108c60 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108cb0:	e8 4b af ff ff       	call   80103c00 <kalloc>
80108cb5:	85 c0                	test   %eax,%eax
80108cb7:	74 37                	je     80108cf0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80108cb9:	83 ec 04             	sub    $0x4,%esp
80108cbc:	68 00 10 00 00       	push   $0x1000
80108cc1:	6a 00                	push   $0x0
80108cc3:	50                   	push   %eax
80108cc4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108cc7:	e8 94 d6 ff ff       	call   80106360 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108ccc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80108ccf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108cd2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80108cd8:	83 c8 07             	or     $0x7,%eax
80108cdb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80108cdd:	89 d8                	mov    %ebx,%eax
80108cdf:	c1 e8 0a             	shr    $0xa,%eax
80108ce2:	25 fc 0f 00 00       	and    $0xffc,%eax
80108ce7:	01 d0                	add    %edx,%eax
80108ce9:	eb 90                	jmp    80108c7b <mappages+0x4b>
80108ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80108cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108cf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108cf8:	5b                   	pop    %ebx
80108cf9:	5e                   	pop    %esi
80108cfa:	5f                   	pop    %edi
80108cfb:	5d                   	pop    %ebp
80108cfc:	c3                   	ret
80108cfd:	8d 76 00             	lea    0x0(%esi),%esi
80108d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108d03:	31 c0                	xor    %eax,%eax
}
80108d05:	5b                   	pop    %ebx
80108d06:	5e                   	pop    %esi
80108d07:	5f                   	pop    %edi
80108d08:	5d                   	pop    %ebp
80108d09:	c3                   	ret
      panic("remap");
80108d0a:	83 ec 0c             	sub    $0xc,%esp
80108d0d:	68 d9 99 10 80       	push   $0x801099d9
80108d12:	e8 39 78 ff ff       	call   80100550 <panic>
80108d17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108d1e:	00 
80108d1f:	90                   	nop

80108d20 <seginit>:
{
80108d20:	55                   	push   %ebp
80108d21:	89 e5                	mov    %esp,%ebp
80108d23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108d26:	e8 05 c3 ff ff       	call   80105030 <cpuid>
  pd[0] = size-1;
80108d2b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108d30:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
80108d36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80108d3a:	c7 80 b8 4a 11 80 ff 	movl   $0xffff,-0x7feeb548(%eax)
80108d41:	ff 00 00 
80108d44:	c7 80 bc 4a 11 80 00 	movl   $0xcf9a00,-0x7feeb544(%eax)
80108d4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108d4e:	c7 80 c0 4a 11 80 ff 	movl   $0xffff,-0x7feeb540(%eax)
80108d55:	ff 00 00 
80108d58:	c7 80 c4 4a 11 80 00 	movl   $0xcf9200,-0x7feeb53c(%eax)
80108d5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108d62:	c7 80 c8 4a 11 80 ff 	movl   $0xffff,-0x7feeb538(%eax)
80108d69:	ff 00 00 
80108d6c:	c7 80 cc 4a 11 80 00 	movl   $0xcffa00,-0x7feeb534(%eax)
80108d73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108d76:	c7 80 d0 4a 11 80 ff 	movl   $0xffff,-0x7feeb530(%eax)
80108d7d:	ff 00 00 
80108d80:	c7 80 d4 4a 11 80 00 	movl   $0xcff200,-0x7feeb52c(%eax)
80108d87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80108d8a:	05 b0 4a 11 80       	add    $0x80114ab0,%eax
  pd[1] = (uint)p;
80108d8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108d93:	c1 e8 10             	shr    $0x10,%eax
80108d96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80108d9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108d9d:	0f 01 10             	lgdtl  (%eax)
}
80108da0:	c9                   	leave
80108da1:	c3                   	ret
80108da2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108da9:	00 
80108daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108db0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108db0:	a1 64 7d 11 80       	mov    0x80117d64,%eax
80108db5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108dba:	0f 22 d8             	mov    %eax,%cr3
}
80108dbd:	c3                   	ret
80108dbe:	66 90                	xchg   %ax,%ax

80108dc0 <switchuvm>:
{
80108dc0:	55                   	push   %ebp
80108dc1:	89 e5                	mov    %esp,%ebp
80108dc3:	57                   	push   %edi
80108dc4:	56                   	push   %esi
80108dc5:	53                   	push   %ebx
80108dc6:	83 ec 1c             	sub    $0x1c,%esp
80108dc9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80108dcc:	85 f6                	test   %esi,%esi
80108dce:	0f 84 cb 00 00 00    	je     80108e9f <switchuvm+0xdf>
  if(p->kstack == 0)
80108dd4:	8b 46 08             	mov    0x8(%esi),%eax
80108dd7:	85 c0                	test   %eax,%eax
80108dd9:	0f 84 da 00 00 00    	je     80108eb9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80108ddf:	8b 46 04             	mov    0x4(%esi),%eax
80108de2:	85 c0                	test   %eax,%eax
80108de4:	0f 84 c2 00 00 00    	je     80108eac <switchuvm+0xec>
  pushcli();
80108dea:	e8 21 d3 ff ff       	call   80106110 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108def:	e8 dc c1 ff ff       	call   80104fd0 <mycpu>
80108df4:	89 c3                	mov    %eax,%ebx
80108df6:	e8 d5 c1 ff ff       	call   80104fd0 <mycpu>
80108dfb:	89 c7                	mov    %eax,%edi
80108dfd:	e8 ce c1 ff ff       	call   80104fd0 <mycpu>
80108e02:	83 c7 08             	add    $0x8,%edi
80108e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108e08:	e8 c3 c1 ff ff       	call   80104fd0 <mycpu>
80108e0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108e10:	ba 67 00 00 00       	mov    $0x67,%edx
80108e15:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108e1c:	83 c0 08             	add    $0x8,%eax
80108e1f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108e26:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108e2b:	83 c1 08             	add    $0x8,%ecx
80108e2e:	c1 e8 18             	shr    $0x18,%eax
80108e31:	c1 e9 10             	shr    $0x10,%ecx
80108e34:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80108e3a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108e40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108e45:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108e4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108e51:	e8 7a c1 ff ff       	call   80104fd0 <mycpu>
80108e56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108e5d:	e8 6e c1 ff ff       	call   80104fd0 <mycpu>
80108e62:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108e66:	8b 5e 08             	mov    0x8(%esi),%ebx
80108e69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108e6f:	e8 5c c1 ff ff       	call   80104fd0 <mycpu>
80108e74:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108e77:	e8 54 c1 ff ff       	call   80104fd0 <mycpu>
80108e7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108e80:	b8 28 00 00 00       	mov    $0x28,%eax
80108e85:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108e88:	8b 46 04             	mov    0x4(%esi),%eax
80108e8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108e90:	0f 22 d8             	mov    %eax,%cr3
}
80108e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e96:	5b                   	pop    %ebx
80108e97:	5e                   	pop    %esi
80108e98:	5f                   	pop    %edi
80108e99:	5d                   	pop    %ebp
  popcli();
80108e9a:	e9 c1 d2 ff ff       	jmp    80106160 <popcli>
    panic("switchuvm: no process");
80108e9f:	83 ec 0c             	sub    $0xc,%esp
80108ea2:	68 df 99 10 80       	push   $0x801099df
80108ea7:	e8 a4 76 ff ff       	call   80100550 <panic>
    panic("switchuvm: no pgdir");
80108eac:	83 ec 0c             	sub    $0xc,%esp
80108eaf:	68 0a 9a 10 80       	push   $0x80109a0a
80108eb4:	e8 97 76 ff ff       	call   80100550 <panic>
    panic("switchuvm: no kstack");
80108eb9:	83 ec 0c             	sub    $0xc,%esp
80108ebc:	68 f5 99 10 80       	push   $0x801099f5
80108ec1:	e8 8a 76 ff ff       	call   80100550 <panic>
80108ec6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108ecd:	00 
80108ece:	66 90                	xchg   %ax,%ax

80108ed0 <inituvm>:
{
80108ed0:	55                   	push   %ebp
80108ed1:	89 e5                	mov    %esp,%ebp
80108ed3:	57                   	push   %edi
80108ed4:	56                   	push   %esi
80108ed5:	53                   	push   %ebx
80108ed6:	83 ec 1c             	sub    $0x1c,%esp
80108ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80108edc:	8b 75 10             	mov    0x10(%ebp),%esi
80108edf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108ee5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108eeb:	77 49                	ja     80108f36 <inituvm+0x66>
  mem = kalloc();
80108eed:	e8 0e ad ff ff       	call   80103c00 <kalloc>
  memset(mem, 0, PGSIZE);
80108ef2:	83 ec 04             	sub    $0x4,%esp
80108ef5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80108efa:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108efc:	6a 00                	push   $0x0
80108efe:	50                   	push   %eax
80108eff:	e8 5c d4 ff ff       	call   80106360 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108f04:	58                   	pop    %eax
80108f05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108f0b:	5a                   	pop    %edx
80108f0c:	6a 06                	push   $0x6
80108f0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108f13:	31 d2                	xor    %edx,%edx
80108f15:	50                   	push   %eax
80108f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108f19:	e8 12 fd ff ff       	call   80108c30 <mappages>
  memmove(mem, init, sz);
80108f1e:	83 c4 10             	add    $0x10,%esp
80108f21:	89 75 10             	mov    %esi,0x10(%ebp)
80108f24:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108f27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80108f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108f2d:	5b                   	pop    %ebx
80108f2e:	5e                   	pop    %esi
80108f2f:	5f                   	pop    %edi
80108f30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108f31:	e9 ba d4 ff ff       	jmp    801063f0 <memmove>
    panic("inituvm: more than a page");
80108f36:	83 ec 0c             	sub    $0xc,%esp
80108f39:	68 1e 9a 10 80       	push   $0x80109a1e
80108f3e:	e8 0d 76 ff ff       	call   80100550 <panic>
80108f43:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108f4a:	00 
80108f4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108f50 <loaduvm>:
{
80108f50:	55                   	push   %ebp
80108f51:	89 e5                	mov    %esp,%ebp
80108f53:	57                   	push   %edi
80108f54:	56                   	push   %esi
80108f55:	53                   	push   %ebx
80108f56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80108f59:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80108f5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80108f5f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80108f65:	0f 85 a2 00 00 00    	jne    8010900d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80108f6b:	85 ff                	test   %edi,%edi
80108f6d:	74 7d                	je     80108fec <loaduvm+0x9c>
80108f6f:	90                   	nop
  pde = &pgdir[PDX(va)];
80108f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108f73:	8b 55 08             	mov    0x8(%ebp),%edx
80108f76:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80108f78:	89 c1                	mov    %eax,%ecx
80108f7a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108f7d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80108f80:	f6 c1 01             	test   $0x1,%cl
80108f83:	75 13                	jne    80108f98 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80108f85:	83 ec 0c             	sub    $0xc,%esp
80108f88:	68 38 9a 10 80       	push   $0x80109a38
80108f8d:	e8 be 75 ff ff       	call   80100550 <panic>
80108f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108f98:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108f9b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108fa1:	25 fc 0f 00 00       	and    $0xffc,%eax
80108fa6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108fad:	85 c9                	test   %ecx,%ecx
80108faf:	74 d4                	je     80108f85 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80108fb1:	89 fb                	mov    %edi,%ebx
80108fb3:	b8 00 10 00 00       	mov    $0x1000,%eax
80108fb8:	29 f3                	sub    %esi,%ebx
80108fba:	39 c3                	cmp    %eax,%ebx
80108fbc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108fbf:	53                   	push   %ebx
80108fc0:	8b 45 14             	mov    0x14(%ebp),%eax
80108fc3:	01 f0                	add    %esi,%eax
80108fc5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80108fc6:	8b 01                	mov    (%ecx),%eax
80108fc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108fcd:	05 00 00 00 80       	add    $0x80000000,%eax
80108fd2:	50                   	push   %eax
80108fd3:	ff 75 10             	push   0x10(%ebp)
80108fd6:	e8 75 a0 ff ff       	call   80103050 <readi>
80108fdb:	83 c4 10             	add    $0x10,%esp
80108fde:	39 d8                	cmp    %ebx,%eax
80108fe0:	75 1e                	jne    80109000 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80108fe2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108fe8:	39 fe                	cmp    %edi,%esi
80108fea:	72 84                	jb     80108f70 <loaduvm+0x20>
}
80108fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108fef:	31 c0                	xor    %eax,%eax
}
80108ff1:	5b                   	pop    %ebx
80108ff2:	5e                   	pop    %esi
80108ff3:	5f                   	pop    %edi
80108ff4:	5d                   	pop    %ebp
80108ff5:	c3                   	ret
80108ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108ffd:	00 
80108ffe:	66 90                	xchg   %ax,%ax
80109000:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80109003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109008:	5b                   	pop    %ebx
80109009:	5e                   	pop    %esi
8010900a:	5f                   	pop    %edi
8010900b:	5d                   	pop    %ebp
8010900c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010900d:	83 ec 0c             	sub    $0xc,%esp
80109010:	68 28 9d 10 80       	push   $0x80109d28
80109015:	e8 36 75 ff ff       	call   80100550 <panic>
8010901a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109020 <allocuvm>:
{
80109020:	55                   	push   %ebp
80109021:	89 e5                	mov    %esp,%ebp
80109023:	57                   	push   %edi
80109024:	56                   	push   %esi
80109025:	53                   	push   %ebx
80109026:	83 ec 1c             	sub    $0x1c,%esp
80109029:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010902c:	85 f6                	test   %esi,%esi
8010902e:	0f 88 98 00 00 00    	js     801090cc <allocuvm+0xac>
80109034:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80109036:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109039:	0f 82 a1 00 00 00    	jb     801090e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010903f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109042:	05 ff 0f 00 00       	add    $0xfff,%eax
80109047:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010904c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010904e:	39 f0                	cmp    %esi,%eax
80109050:	0f 83 8d 00 00 00    	jae    801090e3 <allocuvm+0xc3>
80109056:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80109059:	eb 44                	jmp    8010909f <allocuvm+0x7f>
8010905b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80109060:	83 ec 04             	sub    $0x4,%esp
80109063:	68 00 10 00 00       	push   $0x1000
80109068:	6a 00                	push   $0x0
8010906a:	50                   	push   %eax
8010906b:	e8 f0 d2 ff ff       	call   80106360 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80109070:	58                   	pop    %eax
80109071:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80109077:	5a                   	pop    %edx
80109078:	6a 06                	push   $0x6
8010907a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010907f:	89 fa                	mov    %edi,%edx
80109081:	50                   	push   %eax
80109082:	8b 45 08             	mov    0x8(%ebp),%eax
80109085:	e8 a6 fb ff ff       	call   80108c30 <mappages>
8010908a:	83 c4 10             	add    $0x10,%esp
8010908d:	85 c0                	test   %eax,%eax
8010908f:	78 5f                	js     801090f0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80109091:	81 c7 00 10 00 00    	add    $0x1000,%edi
80109097:	39 f7                	cmp    %esi,%edi
80109099:	0f 83 89 00 00 00    	jae    80109128 <allocuvm+0x108>
    mem = kalloc();
8010909f:	e8 5c ab ff ff       	call   80103c00 <kalloc>
801090a4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801090a6:	85 c0                	test   %eax,%eax
801090a8:	75 b6                	jne    80109060 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801090aa:	83 ec 0c             	sub    $0xc,%esp
801090ad:	68 56 9a 10 80       	push   $0x80109a56
801090b2:	e8 a9 7c ff ff       	call   80100d60 <cprintf>
  if(newsz >= oldsz)
801090b7:	83 c4 10             	add    $0x10,%esp
801090ba:	3b 75 0c             	cmp    0xc(%ebp),%esi
801090bd:	74 0d                	je     801090cc <allocuvm+0xac>
801090bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801090c2:	8b 45 08             	mov    0x8(%ebp),%eax
801090c5:	89 f2                	mov    %esi,%edx
801090c7:	e8 a4 fa ff ff       	call   80108b70 <deallocuvm.part.0>
    return 0;
801090cc:	31 d2                	xor    %edx,%edx
}
801090ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801090d1:	89 d0                	mov    %edx,%eax
801090d3:	5b                   	pop    %ebx
801090d4:	5e                   	pop    %esi
801090d5:	5f                   	pop    %edi
801090d6:	5d                   	pop    %ebp
801090d7:	c3                   	ret
801090d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801090df:	00 
    return oldsz;
801090e0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801090e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801090e6:	89 d0                	mov    %edx,%eax
801090e8:	5b                   	pop    %ebx
801090e9:	5e                   	pop    %esi
801090ea:	5f                   	pop    %edi
801090eb:	5d                   	pop    %ebp
801090ec:	c3                   	ret
801090ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801090f0:	83 ec 0c             	sub    $0xc,%esp
801090f3:	68 6e 9a 10 80       	push   $0x80109a6e
801090f8:	e8 63 7c ff ff       	call   80100d60 <cprintf>
  if(newsz >= oldsz)
801090fd:	83 c4 10             	add    $0x10,%esp
80109100:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109103:	74 0d                	je     80109112 <allocuvm+0xf2>
80109105:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109108:	8b 45 08             	mov    0x8(%ebp),%eax
8010910b:	89 f2                	mov    %esi,%edx
8010910d:	e8 5e fa ff ff       	call   80108b70 <deallocuvm.part.0>
      kfree(mem);
80109112:	83 ec 0c             	sub    $0xc,%esp
80109115:	53                   	push   %ebx
80109116:	e8 25 a9 ff ff       	call   80103a40 <kfree>
      return 0;
8010911b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010911e:	31 d2                	xor    %edx,%edx
80109120:	eb ac                	jmp    801090ce <allocuvm+0xae>
80109122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80109128:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010912b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010912e:	5b                   	pop    %ebx
8010912f:	5e                   	pop    %esi
80109130:	89 d0                	mov    %edx,%eax
80109132:	5f                   	pop    %edi
80109133:	5d                   	pop    %ebp
80109134:	c3                   	ret
80109135:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010913c:	00 
8010913d:	8d 76 00             	lea    0x0(%esi),%esi

80109140 <deallocuvm>:
{
80109140:	55                   	push   %ebp
80109141:	89 e5                	mov    %esp,%ebp
80109143:	8b 55 0c             	mov    0xc(%ebp),%edx
80109146:	8b 4d 10             	mov    0x10(%ebp),%ecx
80109149:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010914c:	39 d1                	cmp    %edx,%ecx
8010914e:	73 10                	jae    80109160 <deallocuvm+0x20>
}
80109150:	5d                   	pop    %ebp
80109151:	e9 1a fa ff ff       	jmp    80108b70 <deallocuvm.part.0>
80109156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010915d:	00 
8010915e:	66 90                	xchg   %ax,%ax
80109160:	89 d0                	mov    %edx,%eax
80109162:	5d                   	pop    %ebp
80109163:	c3                   	ret
80109164:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010916b:	00 
8010916c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80109170 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109170:	55                   	push   %ebp
80109171:	89 e5                	mov    %esp,%ebp
80109173:	57                   	push   %edi
80109174:	56                   	push   %esi
80109175:	53                   	push   %ebx
80109176:	83 ec 0c             	sub    $0xc,%esp
80109179:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010917c:	85 f6                	test   %esi,%esi
8010917e:	74 59                	je     801091d9 <freevm+0x69>
  if(newsz >= oldsz)
80109180:	31 c9                	xor    %ecx,%ecx
80109182:	ba 00 00 00 80       	mov    $0x80000000,%edx
80109187:	89 f0                	mov    %esi,%eax
80109189:	89 f3                	mov    %esi,%ebx
8010918b:	e8 e0 f9 ff ff       	call   80108b70 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109190:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80109196:	eb 0f                	jmp    801091a7 <freevm+0x37>
80109198:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010919f:	00 
801091a0:	83 c3 04             	add    $0x4,%ebx
801091a3:	39 fb                	cmp    %edi,%ebx
801091a5:	74 23                	je     801091ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801091a7:	8b 03                	mov    (%ebx),%eax
801091a9:	a8 01                	test   $0x1,%al
801091ab:	74 f3                	je     801091a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801091ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801091b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801091b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801091b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801091bd:	50                   	push   %eax
801091be:	e8 7d a8 ff ff       	call   80103a40 <kfree>
801091c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801091c6:	39 fb                	cmp    %edi,%ebx
801091c8:	75 dd                	jne    801091a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801091ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801091cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801091d0:	5b                   	pop    %ebx
801091d1:	5e                   	pop    %esi
801091d2:	5f                   	pop    %edi
801091d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801091d4:	e9 67 a8 ff ff       	jmp    80103a40 <kfree>
    panic("freevm: no pgdir");
801091d9:	83 ec 0c             	sub    $0xc,%esp
801091dc:	68 8a 9a 10 80       	push   $0x80109a8a
801091e1:	e8 6a 73 ff ff       	call   80100550 <panic>
801091e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801091ed:	00 
801091ee:	66 90                	xchg   %ax,%ax

801091f0 <setupkvm>:
{
801091f0:	55                   	push   %ebp
801091f1:	89 e5                	mov    %esp,%ebp
801091f3:	56                   	push   %esi
801091f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801091f5:	e8 06 aa ff ff       	call   80103c00 <kalloc>
801091fa:	85 c0                	test   %eax,%eax
801091fc:	74 5e                	je     8010925c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
801091fe:	83 ec 04             	sub    $0x4,%esp
80109201:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109203:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
80109208:	68 00 10 00 00       	push   $0x1000
8010920d:	6a 00                	push   $0x0
8010920f:	50                   	push   %eax
80109210:	e8 4b d1 ff ff       	call   80106360 <memset>
80109215:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80109218:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010921b:	83 ec 08             	sub    $0x8,%esp
8010921e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80109221:	8b 13                	mov    (%ebx),%edx
80109223:	ff 73 0c             	push   0xc(%ebx)
80109226:	50                   	push   %eax
80109227:	29 c1                	sub    %eax,%ecx
80109229:	89 f0                	mov    %esi,%eax
8010922b:	e8 00 fa ff ff       	call   80108c30 <mappages>
80109230:	83 c4 10             	add    $0x10,%esp
80109233:	85 c0                	test   %eax,%eax
80109235:	78 19                	js     80109250 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109237:	83 c3 10             	add    $0x10,%ebx
8010923a:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
80109240:	75 d6                	jne    80109218 <setupkvm+0x28>
}
80109242:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109245:	89 f0                	mov    %esi,%eax
80109247:	5b                   	pop    %ebx
80109248:	5e                   	pop    %esi
80109249:	5d                   	pop    %ebp
8010924a:	c3                   	ret
8010924b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80109250:	83 ec 0c             	sub    $0xc,%esp
80109253:	56                   	push   %esi
80109254:	e8 17 ff ff ff       	call   80109170 <freevm>
      return 0;
80109259:	83 c4 10             	add    $0x10,%esp
}
8010925c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010925f:	31 f6                	xor    %esi,%esi
}
80109261:	89 f0                	mov    %esi,%eax
80109263:	5b                   	pop    %ebx
80109264:	5e                   	pop    %esi
80109265:	5d                   	pop    %ebp
80109266:	c3                   	ret
80109267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010926e:	00 
8010926f:	90                   	nop

80109270 <kvmalloc>:
{
80109270:	55                   	push   %ebp
80109271:	89 e5                	mov    %esp,%ebp
80109273:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109276:	e8 75 ff ff ff       	call   801091f0 <setupkvm>
8010927b:	a3 64 7d 11 80       	mov    %eax,0x80117d64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80109280:	05 00 00 00 80       	add    $0x80000000,%eax
80109285:	0f 22 d8             	mov    %eax,%cr3
}
80109288:	c9                   	leave
80109289:	c3                   	ret
8010928a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109290 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109290:	55                   	push   %ebp
80109291:	89 e5                	mov    %esp,%ebp
80109293:	83 ec 08             	sub    $0x8,%esp
80109296:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109299:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010929c:	89 c1                	mov    %eax,%ecx
8010929e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801092a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801092a4:	f6 c2 01             	test   $0x1,%dl
801092a7:	75 17                	jne    801092c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801092a9:	83 ec 0c             	sub    $0xc,%esp
801092ac:	68 9b 9a 10 80       	push   $0x80109a9b
801092b1:	e8 9a 72 ff ff       	call   80100550 <panic>
801092b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801092bd:	00 
801092be:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801092c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801092c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801092c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801092ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801092d5:	85 c0                	test   %eax,%eax
801092d7:	74 d0                	je     801092a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801092d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801092dc:	c9                   	leave
801092dd:	c3                   	ret
801092de:	66 90                	xchg   %ax,%ax

801092e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801092e0:	55                   	push   %ebp
801092e1:	89 e5                	mov    %esp,%ebp
801092e3:	57                   	push   %edi
801092e4:	56                   	push   %esi
801092e5:	53                   	push   %ebx
801092e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801092e9:	e8 02 ff ff ff       	call   801091f0 <setupkvm>
801092ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801092f1:	85 c0                	test   %eax,%eax
801092f3:	0f 84 e9 00 00 00    	je     801093e2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801092f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801092fc:	85 c9                	test   %ecx,%ecx
801092fe:	0f 84 b2 00 00 00    	je     801093b6 <copyuvm+0xd6>
80109304:	31 f6                	xor    %esi,%esi
80109306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010930d:	00 
8010930e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80109310:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80109313:	89 f0                	mov    %esi,%eax
80109315:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80109318:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010931b:	a8 01                	test   $0x1,%al
8010931d:	75 11                	jne    80109330 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010931f:	83 ec 0c             	sub    $0xc,%esp
80109322:	68 a5 9a 10 80       	push   $0x80109aa5
80109327:	e8 24 72 ff ff       	call   80100550 <panic>
8010932c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80109330:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109337:	c1 ea 0a             	shr    $0xa,%edx
8010933a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80109340:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109347:	85 c0                	test   %eax,%eax
80109349:	74 d4                	je     8010931f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010934b:	8b 00                	mov    (%eax),%eax
8010934d:	a8 01                	test   $0x1,%al
8010934f:	0f 84 9f 00 00 00    	je     801093f4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80109355:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80109357:	25 ff 0f 00 00       	and    $0xfff,%eax
8010935c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010935f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80109365:	e8 96 a8 ff ff       	call   80103c00 <kalloc>
8010936a:	89 c3                	mov    %eax,%ebx
8010936c:	85 c0                	test   %eax,%eax
8010936e:	74 64                	je     801093d4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80109370:	83 ec 04             	sub    $0x4,%esp
80109373:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80109379:	68 00 10 00 00       	push   $0x1000
8010937e:	57                   	push   %edi
8010937f:	50                   	push   %eax
80109380:	e8 6b d0 ff ff       	call   801063f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80109385:	58                   	pop    %eax
80109386:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010938c:	5a                   	pop    %edx
8010938d:	ff 75 e4             	push   -0x1c(%ebp)
80109390:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109395:	89 f2                	mov    %esi,%edx
80109397:	50                   	push   %eax
80109398:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010939b:	e8 90 f8 ff ff       	call   80108c30 <mappages>
801093a0:	83 c4 10             	add    $0x10,%esp
801093a3:	85 c0                	test   %eax,%eax
801093a5:	78 21                	js     801093c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801093a7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801093ad:	3b 75 0c             	cmp    0xc(%ebp),%esi
801093b0:	0f 82 5a ff ff ff    	jb     80109310 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801093b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801093b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801093bc:	5b                   	pop    %ebx
801093bd:	5e                   	pop    %esi
801093be:	5f                   	pop    %edi
801093bf:	5d                   	pop    %ebp
801093c0:	c3                   	ret
801093c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801093c8:	83 ec 0c             	sub    $0xc,%esp
801093cb:	53                   	push   %ebx
801093cc:	e8 6f a6 ff ff       	call   80103a40 <kfree>
      goto bad;
801093d1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801093d4:	83 ec 0c             	sub    $0xc,%esp
801093d7:	ff 75 e0             	push   -0x20(%ebp)
801093da:	e8 91 fd ff ff       	call   80109170 <freevm>
  return 0;
801093df:	83 c4 10             	add    $0x10,%esp
    return 0;
801093e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801093e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801093ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801093ef:	5b                   	pop    %ebx
801093f0:	5e                   	pop    %esi
801093f1:	5f                   	pop    %edi
801093f2:	5d                   	pop    %ebp
801093f3:	c3                   	ret
      panic("copyuvm: page not present");
801093f4:	83 ec 0c             	sub    $0xc,%esp
801093f7:	68 bf 9a 10 80       	push   $0x80109abf
801093fc:	e8 4f 71 ff ff       	call   80100550 <panic>
80109401:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109408:	00 
80109409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109410 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109410:	55                   	push   %ebp
80109411:	89 e5                	mov    %esp,%ebp
80109413:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109416:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80109419:	89 c1                	mov    %eax,%ecx
8010941b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010941e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80109421:	f6 c2 01             	test   $0x1,%dl
80109424:	0f 84 f8 00 00 00    	je     80109522 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010942a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010942d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80109433:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80109434:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80109439:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80109440:	89 d0                	mov    %edx,%eax
80109442:	f7 d2                	not    %edx
80109444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109449:	05 00 00 00 80       	add    $0x80000000,%eax
8010944e:	83 e2 05             	and    $0x5,%edx
80109451:	ba 00 00 00 00       	mov    $0x0,%edx
80109456:	0f 45 c2             	cmovne %edx,%eax
}
80109459:	c3                   	ret
8010945a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109460 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109460:	55                   	push   %ebp
80109461:	89 e5                	mov    %esp,%ebp
80109463:	57                   	push   %edi
80109464:	56                   	push   %esi
80109465:	53                   	push   %ebx
80109466:	83 ec 0c             	sub    $0xc,%esp
80109469:	8b 75 14             	mov    0x14(%ebp),%esi
8010946c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010946f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109472:	85 f6                	test   %esi,%esi
80109474:	75 51                	jne    801094c7 <copyout+0x67>
80109476:	e9 9d 00 00 00       	jmp    80109518 <copyout+0xb8>
8010947b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80109480:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80109486:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010948c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80109492:	74 74                	je     80109508 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80109494:	89 fb                	mov    %edi,%ebx
80109496:	29 c3                	sub    %eax,%ebx
80109498:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010949e:	39 f3                	cmp    %esi,%ebx
801094a0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801094a3:	29 f8                	sub    %edi,%eax
801094a5:	83 ec 04             	sub    $0x4,%esp
801094a8:	01 c1                	add    %eax,%ecx
801094aa:	53                   	push   %ebx
801094ab:	52                   	push   %edx
801094ac:	89 55 10             	mov    %edx,0x10(%ebp)
801094af:	51                   	push   %ecx
801094b0:	e8 3b cf ff ff       	call   801063f0 <memmove>
    len -= n;
    buf += n;
801094b5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801094b8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801094be:	83 c4 10             	add    $0x10,%esp
    buf += n;
801094c1:	01 da                	add    %ebx,%edx
  while(len > 0){
801094c3:	29 de                	sub    %ebx,%esi
801094c5:	74 51                	je     80109518 <copyout+0xb8>
  if(*pde & PTE_P){
801094c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801094ca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801094cc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801094ce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801094d1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801094d7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801094da:	f6 c1 01             	test   $0x1,%cl
801094dd:	0f 84 46 00 00 00    	je     80109529 <copyout.cold>
  return &pgtab[PTX(va)];
801094e3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801094e5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801094eb:	c1 eb 0c             	shr    $0xc,%ebx
801094ee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801094f4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801094fb:	89 d9                	mov    %ebx,%ecx
801094fd:	f7 d1                	not    %ecx
801094ff:	83 e1 05             	and    $0x5,%ecx
80109502:	0f 84 78 ff ff ff    	je     80109480 <copyout+0x20>
  }
  return 0;
}
80109508:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010950b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109510:	5b                   	pop    %ebx
80109511:	5e                   	pop    %esi
80109512:	5f                   	pop    %edi
80109513:	5d                   	pop    %ebp
80109514:	c3                   	ret
80109515:	8d 76 00             	lea    0x0(%esi),%esi
80109518:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010951b:	31 c0                	xor    %eax,%eax
}
8010951d:	5b                   	pop    %ebx
8010951e:	5e                   	pop    %esi
8010951f:	5f                   	pop    %edi
80109520:	5d                   	pop    %ebp
80109521:	c3                   	ret

80109522 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80109522:	a1 00 00 00 00       	mov    0x0,%eax
80109527:	0f 0b                	ud2

80109529 <copyout.cold>:
80109529:	a1 00 00 00 00       	mov    0x0,%eax
8010952e:	0f 0b                	ud2
