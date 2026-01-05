
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
80100028:	bc f0 a1 11 80       	mov    $0x8011a1f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 4f 10 80       	mov    $0x80104f50,%eax
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
80100044:	bb 94 d5 10 80       	mov    $0x8010d594,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 a3 10 80       	push   $0x8010a320
80100051:	68 20 d5 10 80       	push   $0x8010d520
80100056:	e8 a5 67 00 00       	call   80106800 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 dc 23 11 80       	mov    $0x801123dc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 24 11 80 dc 	movl   $0x801123dc,0x8011246c
8010006a:	23 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 24 11 80 dc 	movl   $0x801123dc,0x80112470
80100074:	23 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100088:	83 ec 08             	sub    $0x8,%esp
8010008b:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008e:	c7 83 90 00 00 00 dc 	movl   $0x801123dc,0x90(%ebx)
80100095:	23 11 80 
    initsleeplock(&b->lock, "buffer");
80100098:	68 27 a3 10 80       	push   $0x8010a327
8010009d:	50                   	push   %eax
8010009e:	e8 4d 63 00 00       	call   801063f0 <initsleeplock>
    bcache.head.next->prev = b;
801000a3:	a1 70 24 11 80       	mov    0x80112470,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a8:	8d 93 9c 02 00 00    	lea    0x29c(%ebx),%edx
801000ae:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000b1:	89 98 90 00 00 00    	mov    %ebx,0x90(%eax)
    bcache.head.next = b;
801000b7:	89 d8                	mov    %ebx,%eax
801000b9:	89 1d 70 24 11 80    	mov    %ebx,0x80112470
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000bf:	81 fb 40 21 11 80    	cmp    $0x80112140,%ebx
801000c5:	75 b9                	jne    80100080 <binit+0x40>
  }
}
801000c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000ca:	c9                   	leave
801000cb:	c3                   	ret
801000cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
801000e4:	e8 27 69 00 00       	call   80106a10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 24 11 80    	mov    0x80112470,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 23 11 80    	cmp    $0x801123dc,%ebx
801000f8:	75 14                	jne    8010010e <bread+0x3e>
801000fa:	eb 2c                	jmp    80100128 <bread+0x58>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 9b 94 00 00 00    	mov    0x94(%ebx),%ebx
80100106:	81 fb dc 23 11 80    	cmp    $0x801123dc,%ebx
8010010c:	74 1a                	je     80100128 <bread+0x58>
    if(b->dev == dev && b->blockno == blockno){
8010010e:	3b 73 04             	cmp    0x4(%ebx),%esi
80100111:	75 ed                	jne    80100100 <bread+0x30>
80100113:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100116:	75 e8                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100118:	83 83 8c 00 00 00 01 	addl   $0x1,0x8c(%ebx)
      release(&bcache.lock);
8010011f:	eb 52                	jmp    80100173 <bread+0xa3>
80100121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100128:	8b 1d 6c 24 11 80    	mov    0x8011246c,%ebx
8010012e:	81 fb dc 23 11 80    	cmp    $0x801123dc,%ebx
80100134:	75 18                	jne    8010014e <bread+0x7e>
80100136:	eb 7e                	jmp    801001b6 <bread+0xe6>
80100138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010013f:	00 
80100140:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
80100146:	81 fb dc 23 11 80    	cmp    $0x801123dc,%ebx
8010014c:	74 68                	je     801001b6 <bread+0xe6>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014e:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80100154:	85 c0                	test   %eax,%eax
80100156:	75 e8                	jne    80100140 <bread+0x70>
80100158:	f6 03 04             	testb  $0x4,(%ebx)
8010015b:	75 e3                	jne    80100140 <bread+0x70>
      b->dev = dev;
8010015d:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100160:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100163:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100169:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80100170:	00 00 00 
      release(&bcache.lock);
80100173:	83 ec 0c             	sub    $0xc,%esp
80100176:	68 20 d5 10 80       	push   $0x8010d520
8010017b:	e8 30 68 00 00       	call   801069b0 <release>
      acquiresleep(&b->lock);
80100180:	8d 43 0c             	lea    0xc(%ebx),%eax
80100183:	89 04 24             	mov    %eax,(%esp)
80100186:	e8 a5 62 00 00       	call   80106430 <acquiresleep>
      return b;
8010018b:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
8010018e:	f6 03 02             	testb  $0x2,(%ebx)
80100191:	74 0d                	je     801001a0 <bread+0xd0>
    iderw(b);
  }
  return b;
}
80100193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100196:	89 d8                	mov    %ebx,%eax
80100198:	5b                   	pop    %ebx
80100199:	5e                   	pop    %esi
8010019a:	5f                   	pop    %edi
8010019b:	5d                   	pop    %ebp
8010019c:	c3                   	ret
8010019d:	8d 76 00             	lea    0x0(%esi),%esi
    iderw(b);
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	53                   	push   %ebx
801001a4:	e8 27 40 00 00       	call   801041d0 <iderw>
801001a9:	83 c4 10             	add    $0x10,%esp
}
801001ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001af:	89 d8                	mov    %ebx,%eax
801001b1:	5b                   	pop    %ebx
801001b2:	5e                   	pop    %esi
801001b3:	5f                   	pop    %edi
801001b4:	5d                   	pop    %ebp
801001b5:	c3                   	ret
  panic("bget: no buffers");
801001b6:	83 ec 0c             	sub    $0xc,%esp
801001b9:	68 2e a3 10 80       	push   $0x8010a32e
801001be:	e8 3d 0c 00 00       	call   80100e00 <panic>
801001c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ca:	00 
801001cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001d0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 10             	sub    $0x10,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001da:	8d 43 0c             	lea    0xc(%ebx),%eax
801001dd:	50                   	push   %eax
801001de:	e8 1d 63 00 00       	call   80106500 <holdingsleep>
801001e3:	83 c4 10             	add    $0x10,%esp
801001e6:	85 c0                	test   %eax,%eax
801001e8:	74 0f                	je     801001f9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ea:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001f3:	c9                   	leave
  iderw(b);
801001f4:	e9 d7 3f 00 00       	jmp    801041d0 <iderw>
    panic("bwrite");
801001f9:	83 ec 0c             	sub    $0xc,%esp
801001fc:	68 3f a3 10 80       	push   $0x8010a33f
80100201:	e8 fa 0b 00 00       	call   80100e00 <panic>
80100206:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010020d:	00 
8010020e:	66 90                	xchg   %ax,%ax

80100210 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100210:	55                   	push   %ebp
80100211:	89 e5                	mov    %esp,%ebp
80100213:	56                   	push   %esi
80100214:	53                   	push   %ebx
80100215:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100218:	8d 73 0c             	lea    0xc(%ebx),%esi
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 dc 62 00 00       	call   80106500 <holdingsleep>
80100224:	83 c4 10             	add    $0x10,%esp
80100227:	85 c0                	test   %eax,%eax
80100229:	0f 84 81 00 00 00    	je     801002b0 <brelse+0xa0>
    panic("brelse");

  releasesleep(&b->lock);
8010022f:	83 ec 0c             	sub    $0xc,%esp
80100232:	56                   	push   %esi
80100233:	e8 58 62 00 00       	call   80106490 <releasesleep>

  acquire(&bcache.lock);
80100238:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010023f:	e8 cc 67 00 00       	call   80106a10 <acquire>
  b->refcnt--;
80100244:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
  if (b->refcnt == 0) {
8010024a:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010024d:	83 e8 01             	sub    $0x1,%eax
80100250:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
  if (b->refcnt == 0) {
80100256:	85 c0                	test   %eax,%eax
80100258:	75 44                	jne    8010029e <brelse+0x8e>
    // no one is waiting for it.
    b->next->prev = b->prev;
8010025a:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
80100260:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80100266:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
    b->prev->next = b->next;
8010026c:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
80100272:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    b->next = bcache.head.next;
80100278:	a1 70 24 11 80       	mov    0x80112470,%eax
    b->prev = &bcache.head;
8010027d:	c7 83 90 00 00 00 dc 	movl   $0x801123dc,0x90(%ebx)
80100284:	23 11 80 
    b->next = bcache.head.next;
80100287:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
    bcache.head.next->prev = b;
8010028d:	a1 70 24 11 80       	mov    0x80112470,%eax
80100292:	89 98 90 00 00 00    	mov    %ebx,0x90(%eax)
    bcache.head.next = b;
80100298:	89 1d 70 24 11 80    	mov    %ebx,0x80112470
  }
  
  release(&bcache.lock);
8010029e:	c7 45 08 20 d5 10 80 	movl   $0x8010d520,0x8(%ebp)
}
801002a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801002a8:	5b                   	pop    %ebx
801002a9:	5e                   	pop    %esi
801002aa:	5d                   	pop    %ebp
  release(&bcache.lock);
801002ab:	e9 00 67 00 00       	jmp    801069b0 <release>
    panic("brelse");
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	68 46 a3 10 80       	push   $0x8010a346
801002b8:	e8 43 0b 00 00       	call   80100e00 <panic>
801002bd:	66 90                	xchg   %ax,%ax
801002bf:	90                   	nop

801002c0 <cpt_get_slot_for_page>:
  return uva2ka(p->pgdir, (char *)user_va_page);
}

static int
cpt_get_slot_for_page(struct proc *p, uint vpn)
{
801002c0:	55                   	push   %ebp
801002c1:	89 e5                	mov    %esp,%ebp
801002c3:	57                   	push   %edi
801002c4:	89 d7                	mov    %edx,%edi
801002c6:	56                   	push   %esi
801002c7:	89 c6                	mov    %eax,%esi
  uint user_va_page = vpn * PGSIZE;
801002c9:	89 d0                	mov    %edx,%eax
{
801002cb:	53                   	push   %ebx
  uint user_va_page = vpn * PGSIZE;
801002cc:	c1 e0 0c             	shl    $0xc,%eax
{
801002cf:	83 ec 34             	sub    $0x34,%esp
  return uva2ka(p->pgdir, (char *)user_va_page);
801002d2:	50                   	push   %eax
801002d3:	ff 76 04             	push   0x4(%esi)
801002d6:	e8 15 9f 00 00       	call   8010a1f0 <uva2ka>
  char *kpage = user_va_page_to_kva(p, user_va_page);
  int slot;

  if (kpage == 0)
801002db:	83 c4 10             	add    $0x10,%esp
  return uva2ka(p->pgdir, (char *)user_va_page);
801002de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (kpage == 0)
801002e1:	85 c0                	test   %eax,%eax
801002e3:	0f 84 e7 02 00 00    	je     801005d0 <cpt_get_slot_for_page+0x310>
    return -1;

  acquire(&g_cpt.lock);
801002e9:	83 ec 0c             	sub    $0xc,%esp
801002ec:	68 80 26 11 80       	push   $0x80112680
801002f1:	e8 1a 67 00 00       	call   80106a10 <acquire>

  if (p->pid == stats_pid)
801002f6:	8b 56 10             	mov    0x10(%esi),%edx
801002f9:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
801002ff:	83 c4 10             	add    $0x10,%esp
80100302:	39 ca                	cmp    %ecx,%edx
80100304:	0f 84 be 01 00 00    	je     801004c8 <cpt_get_slot_for_page+0x208>
  for (i = 0; i < CPT_SIZE; i++)
8010030a:	31 db                	xor    %ebx,%ebx
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
8010030c:	89 d8                	mov    %ebx,%eax
8010030e:	c1 e0 05             	shl    $0x5,%eax
80100311:	83 b8 f4 26 11 80 00 	cmpl   $0x0,-0x7feed90c(%eax)
80100318:	74 0c                	je     80100326 <cpt_get_slot_for_page+0x66>
8010031a:	3b 90 f8 26 11 80    	cmp    -0x7feed908(%eax),%edx
80100320:	0f 84 42 01 00 00    	je     80100468 <cpt_get_slot_for_page+0x1a8>
  for (i = 0; i < CPT_SIZE; i++)
80100326:	83 c3 01             	add    $0x1,%ebx
80100329:	83 fb 04             	cmp    $0x4,%ebx
8010032c:	75 de                	jne    8010030c <cpt_get_slot_for_page+0x4c>
    release(&g_cpt.lock);
    return slot;
  }

  // MISS
  if (p->pid == stats_pid)
8010032e:	39 ca                	cmp    %ecx,%edx
80100330:	0f 84 a2 01 00 00    	je     801004d8 <cpt_get_slot_for_page+0x218>
  for (i = 0; i < CPT_SIZE; i++)
80100336:	31 db                	xor    %ebx,%ebx
    if (g_cpt.e[i].valid == 0)
80100338:	89 d8                	mov    %ebx,%eax
8010033a:	c1 e0 05             	shl    $0x5,%eax
8010033d:	8b 80 f4 26 11 80    	mov    -0x7feed90c(%eax),%eax
80100343:	85 c0                	test   %eax,%eax
80100345:	0f 84 ed 01 00 00    	je     80100538 <cpt_get_slot_for_page+0x278>
  for (i = 0; i < CPT_SIZE; i++)
8010034b:	83 c3 01             	add    $0x1,%ebx
8010034e:	83 fb 04             	cmp    $0x4,%ebx
80100351:	75 e5                	jne    80100338 <cpt_get_slot_for_page+0x78>
  slot = cpt_find_free_nolock();

  if (slot < 0)
  {
    // FULL => eviction
    if (p->pid == stats_pid)
80100353:	39 ca                	cmp    %ecx,%edx
80100355:	75 07                	jne    8010035e <cpt_get_slot_for_page+0x9e>
      g_stats.evictions++;
80100357:	83 05 84 27 11 80 01 	addl   $0x1,0x80112784
static int
cpt_pick_victim_nolock(void)
{
  int i, victim = 0;

  if (cpt_policy == CPT_FIFO)
8010035e:	8b 1d 04 b0 10 80    	mov    0x8010b004,%ebx
80100364:	85 db                	test   %ebx,%ebx
80100366:	0f 84 d4 01 00 00    	je     80100540 <cpt_get_slot_for_page+0x280>
      }
    }
    return victim;
  }

  if (cpt_policy == CPT_LRU)
8010036c:	83 fb 01             	cmp    $0x1,%ebx
8010036f:	0f 84 28 02 00 00    	je     8010059d <cpt_get_slot_for_page+0x2dd>
      }
    }
    return victim;
  }

  if (cpt_policy == CPT_LFU)
80100375:	83 fb 02             	cmp    $0x2,%ebx
80100378:	0f 84 66 01 00 00    	je     801004e4 <cpt_get_slot_for_page+0x224>
  }

  // CPT_CLOCK
  for (;;)
  {
    int h = g_cpt.clock_hand;
8010037e:	8b 1d 74 27 11 80    	mov    0x80112774,%ebx
80100384:	eb 29                	jmp    801003af <cpt_get_slot_for_page+0xef>
80100386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010038d:	00 
8010038e:	66 90                	xchg   %ax,%ax
      victim = h;
      g_cpt.clock_hand = (h + 1) % CPT_SIZE;
      return victim;
    }
    g_cpt.e[h].refbit = 0;
    g_cpt.clock_hand = (h + 1) % CPT_SIZE;
80100390:	83 c3 01             	add    $0x1,%ebx
    g_cpt.e[h].refbit = 0;
80100393:	c1 e2 05             	shl    $0x5,%edx
80100396:	c7 82 8c 26 11 80 00 	movl   $0x0,-0x7feed974(%edx)
8010039d:	00 00 00 
    g_cpt.clock_hand = (h + 1) % CPT_SIZE;
801003a0:	89 d8                	mov    %ebx,%eax
801003a2:	c1 f8 1f             	sar    $0x1f,%eax
801003a5:	c1 e8 1e             	shr    $0x1e,%eax
801003a8:	01 c3                	add    %eax,%ebx
801003aa:	83 e3 03             	and    $0x3,%ebx
801003ad:	29 c3                	sub    %eax,%ebx
    if (g_cpt.e[h].refbit == 0)
801003af:	8d 53 04             	lea    0x4(%ebx),%edx
801003b2:	89 d0                	mov    %edx,%eax
801003b4:	c1 e0 05             	shl    $0x5,%eax
801003b7:	8b 80 8c 26 11 80    	mov    -0x7feed974(%eax),%eax
801003bd:	85 c0                	test   %eax,%eax
801003bf:	75 cf                	jne    80100390 <cpt_get_slot_for_page+0xd0>
      g_cpt.clock_hand = (h + 1) % CPT_SIZE;
801003c1:	8d 4b 01             	lea    0x1(%ebx),%ecx
801003c4:	89 c8                	mov    %ecx,%eax
801003c6:	c1 f8 1f             	sar    $0x1f,%eax
801003c9:	c1 e8 1e             	shr    $0x1e,%eax
801003cc:	01 c1                	add    %eax,%ecx
801003ce:	83 e1 03             	and    $0x3,%ecx
801003d1:	29 c1                	sub    %eax,%ecx
801003d3:	89 0d 74 27 11 80    	mov    %ecx,0x80112774
  memmove(g_cpt.e[slot].frame, kpage, PGSIZE);
801003d9:	89 d9                	mov    %ebx,%ecx
801003db:	83 ec 04             	sub    $0x4,%esp
801003de:	89 55 e0             	mov    %edx,-0x20(%ebp)
801003e1:	c1 e1 05             	shl    $0x5,%ecx
801003e4:	68 00 10 00 00       	push   $0x1000
801003e9:	ff 75 e4             	push   -0x1c(%ebp)
801003ec:	ff b1 00 27 11 80    	push   -0x7feed900(%ecx)
801003f2:	81 c1 80 26 11 80    	add    $0x80112680,%ecx
801003f8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801003fb:	e8 40 6c 00 00       	call   80107040 <memmove>
  g_cpt.e[slot].valid = 1;
80100400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
80100403:	8b 55 e0             	mov    -0x20(%ebp),%edx
  g_cpt.e[slot].valid = 1;
80100406:	c7 41 74 01 00 00 00 	movl   $0x1,0x74(%ecx)
  g_cpt.e[slot].pid = p->pid;
8010040d:	8b 46 10             	mov    0x10(%esi),%eax
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
80100410:	c1 e2 05             	shl    $0x5,%edx
  g_cpt.e[slot].vpn = vpn;
80100413:	89 79 7c             	mov    %edi,0x7c(%ecx)
  g_cpt.e[slot].pid = p->pid;
80100416:	89 41 78             	mov    %eax,0x78(%ecx)
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
80100419:	a1 00 b0 10 80       	mov    0x8010b000,%eax
  g_cpt.e[idx].freq = 1;                // LFU initial
8010041e:	c7 82 88 26 11 80 01 	movl   $0x1,-0x7feed978(%edx)
80100425:	00 00 00 
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
80100428:	89 82 90 26 11 80    	mov    %eax,-0x7feed970(%edx)
  g_cpt.e[idx].last_used = cpt_stamp++; // LRU start time
8010042e:	8d 48 02             	lea    0x2(%eax),%ecx
  g_cpt.e[idx].fifo_age = cpt_stamp++;  // FIFO uses this and it should NOT change on touches
80100431:	83 c0 01             	add    $0x1,%eax
80100434:	89 82 84 26 11 80    	mov    %eax,-0x7feed97c(%edx)
  g_cpt.e[idx].last_used = cpt_stamp++; // LRU start time
8010043a:	89 0d 00 b0 10 80    	mov    %ecx,0x8010b000
  g_cpt.e[idx].refbit = 1;              // CLOCK: recently used
80100440:	c7 82 8c 26 11 80 01 	movl   $0x1,-0x7feed974(%edx)
80100447:	00 00 00 
  release(&g_cpt.lock);
8010044a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80100451:	e8 5a 65 00 00       	call   801069b0 <release>
  return slot;
80100456:	83 c4 10             	add    $0x10,%esp
}
80100459:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010045c:	89 d8                	mov    %ebx,%eax
8010045e:	5b                   	pop    %ebx
8010045f:	5e                   	pop    %esi
80100460:	5f                   	pop    %edi
80100461:	5d                   	pop    %ebp
80100462:	c3                   	ret
80100463:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
80100468:	3b b8 fc 26 11 80    	cmp    -0x7feed904(%eax),%edi
8010046e:	0f 85 b2 fe ff ff    	jne    80100326 <cpt_get_slot_for_page+0x66>
    if (p->pid == stats_pid)
80100474:	39 ca                	cmp    %ecx,%edx
80100476:	75 07                	jne    8010047f <cpt_get_slot_for_page+0x1bf>
      g_stats.hits++;
80100478:	83 05 7c 27 11 80 01 	addl   $0x1,0x8011277c
  g_cpt.e[idx].last_used = cpt_stamp++;
8010047f:	8b 15 00 b0 10 80    	mov    0x8010b000,%edx
    release(&g_cpt.lock);
80100485:	83 ec 0c             	sub    $0xc,%esp
  g_cpt.e[idx].last_used = cpt_stamp++;
80100488:	8d 42 01             	lea    0x1(%edx),%eax
8010048b:	a3 00 b0 10 80       	mov    %eax,0x8010b000
80100490:	89 d8                	mov    %ebx,%eax
80100492:	c1 e0 05             	shl    $0x5,%eax
80100495:	89 90 04 27 11 80    	mov    %edx,-0x7feed8fc(%eax)
8010049b:	05 00 27 11 80       	add    $0x80112700,%eax
  g_cpt.e[idx].freq++;
801004a0:	83 40 08 01          	addl   $0x1,0x8(%eax)
  g_cpt.e[idx].refbit = 1;
801004a4:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    release(&g_cpt.lock);
801004ab:	68 80 26 11 80       	push   $0x80112680
801004b0:	e8 fb 64 00 00       	call   801069b0 <release>
    return slot;
801004b5:	83 c4 10             	add    $0x10,%esp
}
801004b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    g_stats.accesses++;
801004c8:	83 05 78 27 11 80 01 	addl   $0x1,0x80112778
801004cf:	e9 36 fe ff ff       	jmp    8010030a <cpt_get_slot_for_page+0x4a>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    g_stats.misses++;
801004d8:	83 05 80 27 11 80 01 	addl   $0x1,0x80112780
801004df:	e9 52 fe ff ff       	jmp    80100336 <cpt_get_slot_for_page+0x76>
  int i, victim = 0;
801004e4:	31 db                	xor    %ebx,%ebx
    uint bestf = g_cpt.e[0].freq;
801004e6:	a1 08 27 11 80       	mov    0x80112708,%eax
    for (i = 1; i < CPT_SIZE; i++)
801004eb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801004ee:	ba 01 00 00 00       	mov    $0x1,%edx
    uint bestt = g_cpt.e[0].last_used; // tie-breaker with older last_used
801004f3:	8b 0d 04 27 11 80    	mov    0x80112704,%ecx
    for (i = 1; i < CPT_SIZE; i++)
801004f9:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801004fc:	89 75 d8             	mov    %esi,-0x28(%ebp)
801004ff:	89 c6                	mov    %eax,%esi
    uint bestt = g_cpt.e[0].last_used; // tie-breaker with older last_used
80100501:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    for (i = 1; i < CPT_SIZE; i++)
80100504:	b9 80 26 11 80       	mov    $0x80112680,%ecx
      if (g_cpt.e[i].freq < bestf ||
80100509:	8b 81 a8 00 00 00    	mov    0xa8(%ecx),%eax
8010050f:	39 f0                	cmp    %esi,%eax
80100511:	73 6d                	jae    80100580 <cpt_get_slot_for_page+0x2c0>
          (g_cpt.e[i].freq == bestf && g_cpt.e[i].last_used < bestt))
80100513:	8b b1 a4 00 00 00    	mov    0xa4(%ecx),%esi
80100519:	89 75 dc             	mov    %esi,-0x24(%ebp)
        victim = i;
8010051c:	89 55 e0             	mov    %edx,-0x20(%ebp)
        bestf = g_cpt.e[i].freq;
8010051f:	89 c6                	mov    %eax,%esi
    for (i = 1; i < CPT_SIZE; i++)
80100521:	83 c2 01             	add    $0x1,%edx
80100524:	83 c1 20             	add    $0x20,%ecx
80100527:	83 fa 04             	cmp    $0x4,%edx
8010052a:	75 dd                	jne    80100509 <cpt_get_slot_for_page+0x249>
8010052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010052f:	8b 75 d8             	mov    -0x28(%ebp),%esi
80100532:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80100535:	8d 76 00             	lea    0x0(%esi),%esi
80100538:	8d 53 04             	lea    0x4(%ebx),%edx
8010053b:	e9 99 fe ff ff       	jmp    801003d9 <cpt_get_slot_for_page+0x119>
    uint best = g_cpt.e[0].fifo_age;
80100540:	8b 15 10 27 11 80    	mov    0x80112710,%edx
      if (g_cpt.e[i].fifo_age < best)
80100546:	a1 30 27 11 80       	mov    0x80112730,%eax
8010054b:	39 d0                	cmp    %edx,%eax
8010054d:	72 25                	jb     80100574 <cpt_get_slot_for_page+0x2b4>
    uint best = g_cpt.e[0].fifo_age;
8010054f:	89 d0                	mov    %edx,%eax
      if (g_cpt.e[i].fifo_age < best)
80100551:	8b 15 50 27 11 80    	mov    0x80112750,%edx
80100557:	39 c2                	cmp    %eax,%edx
80100559:	72 3b                	jb     80100596 <cpt_get_slot_for_page+0x2d6>
8010055b:	89 c2                	mov    %eax,%edx
8010055d:	39 15 70 27 11 80    	cmp    %edx,0x80112770
80100563:	73 d3                	jae    80100538 <cpt_get_slot_for_page+0x278>
        victim = i;
80100565:	bb 03 00 00 00       	mov    $0x3,%ebx
8010056a:	ba 07 00 00 00       	mov    $0x7,%edx
8010056f:	e9 65 fe ff ff       	jmp    801003d9 <cpt_get_slot_for_page+0x119>
80100574:	bb 01 00 00 00       	mov    $0x1,%ebx
80100579:	eb d6                	jmp    80100551 <cpt_get_slot_for_page+0x291>
8010057b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if (g_cpt.e[i].freq < bestf ||
80100580:	39 c6                	cmp    %eax,%esi
80100582:	75 9d                	jne    80100521 <cpt_get_slot_for_page+0x261>
          (g_cpt.e[i].freq == bestf && g_cpt.e[i].last_used < bestt))
80100584:	8b b9 a4 00 00 00    	mov    0xa4(%ecx),%edi
8010058a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
8010058d:	39 df                	cmp    %ebx,%edi
8010058f:	73 90                	jae    80100521 <cpt_get_slot_for_page+0x261>
80100591:	89 7d dc             	mov    %edi,-0x24(%ebp)
80100594:	eb 86                	jmp    8010051c <cpt_get_slot_for_page+0x25c>
        victim = i;
80100596:	bb 02 00 00 00       	mov    $0x2,%ebx
8010059b:	eb c0                	jmp    8010055d <cpt_get_slot_for_page+0x29d>
    uint best = g_cpt.e[0].last_used;
8010059d:	8b 15 04 27 11 80    	mov    0x80112704,%edx
      if (g_cpt.e[i].last_used < best)
801005a3:	a1 24 27 11 80       	mov    0x80112724,%eax
801005a8:	39 d0                	cmp    %edx,%eax
801005aa:	72 04                	jb     801005b0 <cpt_get_slot_for_page+0x2f0>
    uint best = g_cpt.e[0].last_used;
801005ac:	89 d0                	mov    %edx,%eax
  int i, victim = 0;
801005ae:	31 db                	xor    %ebx,%ebx
      if (g_cpt.e[i].last_used < best)
801005b0:	8b 15 44 27 11 80    	mov    0x80112744,%edx
801005b6:	39 c2                	cmp    %eax,%edx
801005b8:	72 0f                	jb     801005c9 <cpt_get_slot_for_page+0x309>
801005ba:	89 c2                	mov    %eax,%edx
801005bc:	39 15 64 27 11 80    	cmp    %edx,0x80112764
801005c2:	72 a1                	jb     80100565 <cpt_get_slot_for_page+0x2a5>
801005c4:	e9 6f ff ff ff       	jmp    80100538 <cpt_get_slot_for_page+0x278>
        victim = i;
801005c9:	bb 02 00 00 00       	mov    $0x2,%ebx
801005ce:	eb ec                	jmp    801005bc <cpt_get_slot_for_page+0x2fc>
    return -1;
801005d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801005d5:	e9 de fe ff ff       	jmp    801004b8 <cpt_get_slot_for_page+0x1f8>
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005e0 <cpt_init>:
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	53                   	push   %ebx
801005e4:	bb 80 26 11 80       	mov    $0x80112680,%ebx
801005e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&g_cpt.lock, "cpt");
801005ec:	68 4d a3 10 80       	push   $0x8010a34d
801005f1:	68 80 26 11 80       	push   $0x80112680
801005f6:	e8 05 62 00 00       	call   80106800 <initlock>
  g_cpt.clock_hand = 0;
801005fb:	83 c4 10             	add    $0x10,%esp
801005fe:	c7 05 74 27 11 80 00 	movl   $0x0,0x80112774
80100605:	00 00 00 
    g_cpt.e[i].frame = kalloc();
80100608:	e8 63 3f 00 00       	call   80104570 <kalloc>
8010060d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    if (g_cpt.e[i].frame == 0)
80100613:	85 c0                	test   %eax,%eax
80100615:	74 54                	je     8010066b <cpt_init+0x8b>
    memset(g_cpt.e[i].frame, 0, PGSIZE);
80100617:	83 ec 04             	sub    $0x4,%esp
  for (i = 0; i < CPT_SIZE; i++)
8010061a:	83 c3 20             	add    $0x20,%ebx
    memset(g_cpt.e[i].frame, 0, PGSIZE);
8010061d:	68 00 10 00 00       	push   $0x1000
80100622:	6a 00                	push   $0x0
80100624:	50                   	push   %eax
80100625:	e8 86 69 00 00       	call   80106fb0 <memset>
  ent->valid = 0;
8010062a:	c7 43 54 00 00 00 00 	movl   $0x0,0x54(%ebx)
  for (i = 0; i < CPT_SIZE; i++)
80100631:	83 c4 10             	add    $0x10,%esp
  ent->pid = -1;
80100634:	c7 43 58 ff ff ff ff 	movl   $0xffffffff,0x58(%ebx)
  ent->vpn = 0;
8010063b:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
  ent->last_used = 0;
80100642:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
  ent->freq = 0;
80100649:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  ent->refbit = 0;
80100650:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  ent->fifo_age = 0;
80100657:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)
  for (i = 0; i < CPT_SIZE; i++)
8010065e:	81 fb 00 27 11 80    	cmp    $0x80112700,%ebx
80100664:	75 a2                	jne    80100608 <cpt_init+0x28>
}
80100666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100669:	c9                   	leave
8010066a:	c3                   	ret
      panic("cpt_init: kalloc failed");
8010066b:	83 ec 0c             	sub    $0xc,%esp
8010066e:	68 51 a3 10 80       	push   $0x8010a351
80100673:	e8 88 07 00 00       	call   80100e00 <panic>
80100678:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010067f:	00 

80100680 <cpt_lookup>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	56                   	push   %esi
80100684:	53                   	push   %ebx
80100685:	8b 75 08             	mov    0x8(%ebp),%esi
  for (i = 0; i < CPT_SIZE; i++)
80100688:	31 db                	xor    %ebx,%ebx
  acquire(&g_cpt.lock);
8010068a:	83 ec 0c             	sub    $0xc,%esp
8010068d:	68 80 26 11 80       	push   $0x80112680
80100692:	e8 79 63 00 00       	call   80106a10 <acquire>
80100697:	83 c4 10             	add    $0x10,%esp
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
8010069a:	89 d8                	mov    %ebx,%eax
8010069c:	c1 e0 05             	shl    $0x5,%eax
8010069f:	8b 90 f4 26 11 80    	mov    -0x7feed90c(%eax),%edx
801006a5:	85 d2                	test   %edx,%edx
801006a7:	74 08                	je     801006b1 <cpt_lookup+0x31>
801006a9:	39 b0 f8 26 11 80    	cmp    %esi,-0x7feed908(%eax)
801006af:	74 27                	je     801006d8 <cpt_lookup+0x58>
  for (i = 0; i < CPT_SIZE; i++)
801006b1:	83 c3 01             	add    $0x1,%ebx
801006b4:	83 fb 04             	cmp    $0x4,%ebx
801006b7:	75 e1                	jne    8010069a <cpt_lookup+0x1a>
  int idx = -1;
801006b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&g_cpt.lock);
801006be:	83 ec 0c             	sub    $0xc,%esp
801006c1:	68 80 26 11 80       	push   $0x80112680
801006c6:	e8 e5 62 00 00       	call   801069b0 <release>
}
801006cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801006ce:	89 d8                	mov    %ebx,%eax
801006d0:	5b                   	pop    %ebx
801006d1:	5e                   	pop    %esi
801006d2:	5d                   	pop    %ebp
801006d3:	c3                   	ret
801006d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid && g_cpt.e[i].vpn == vpn)
801006d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801006db:	39 90 fc 26 11 80    	cmp    %edx,-0x7feed904(%eax)
801006e1:	75 ce                	jne    801006b1 <cpt_lookup+0x31>
801006e3:	eb d9                	jmp    801006be <cpt_lookup+0x3e>
801006e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006ec:	00 
801006ed:	8d 76 00             	lea    0x0(%esi),%esi

801006f0 <cpt_find_free>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	53                   	push   %ebx
  for (i = 0; i < CPT_SIZE; i++)
801006f4:	31 db                	xor    %ebx,%ebx
{
801006f6:	83 ec 10             	sub    $0x10,%esp
  acquire(&g_cpt.lock);
801006f9:	68 80 26 11 80       	push   $0x80112680
801006fe:	e8 0d 63 00 00       	call   80106a10 <acquire>
80100703:	83 c4 10             	add    $0x10,%esp
    if (g_cpt.e[i].valid == 0)
80100706:	89 d8                	mov    %ebx,%eax
80100708:	c1 e0 05             	shl    $0x5,%eax
8010070b:	8b 80 f4 26 11 80    	mov    -0x7feed90c(%eax),%eax
80100711:	85 c0                	test   %eax,%eax
80100713:	74 0d                	je     80100722 <cpt_find_free+0x32>
  for (i = 0; i < CPT_SIZE; i++)
80100715:	83 c3 01             	add    $0x1,%ebx
80100718:	83 fb 04             	cmp    $0x4,%ebx
8010071b:	75 e9                	jne    80100706 <cpt_find_free+0x16>
  int idx = -1;
8010071d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&g_cpt.lock);
80100722:	83 ec 0c             	sub    $0xc,%esp
80100725:	68 80 26 11 80       	push   $0x80112680
8010072a:	e8 81 62 00 00       	call   801069b0 <release>
}
8010072f:	89 d8                	mov    %ebx,%eax
80100731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100734:	c9                   	leave
80100735:	c3                   	ret
80100736:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010073d:	00 
8010073e:	66 90                	xchg   %ax,%ax

80100740 <cpt_invalidate_pid>:
{
80100740:	55                   	push   %ebp
80100741:	89 e5                	mov    %esp,%ebp
80100743:	53                   	push   %ebx
80100744:	83 ec 10             	sub    $0x10,%esp
80100747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&g_cpt.lock);
8010074a:	68 80 26 11 80       	push   $0x80112680
8010074f:	e8 bc 62 00 00       	call   80106a10 <acquire>
  for (i = 0; i < CPT_SIZE; i++)
80100754:	b8 80 26 11 80       	mov    $0x80112680,%eax
80100759:	83 c4 10             	add    $0x10,%esp
    if (g_cpt.e[i].valid && g_cpt.e[i].pid == pid)
8010075c:	8b 50 74             	mov    0x74(%eax),%edx
8010075f:	85 d2                	test   %edx,%edx
80100761:	74 45                	je     801007a8 <cpt_invalidate_pid+0x68>
80100763:	39 58 78             	cmp    %ebx,0x78(%eax)
80100766:	75 40                	jne    801007a8 <cpt_invalidate_pid+0x68>
  ent->valid = 0;
80100768:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
  ent->pid = -1;
8010076f:	c7 40 78 ff ff ff ff 	movl   $0xffffffff,0x78(%eax)
  ent->vpn = 0;
80100776:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  ent->last_used = 0;
8010077d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80100784:	00 00 00 
  ent->freq = 0;
80100787:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010078e:	00 00 00 
  ent->refbit = 0;
80100791:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80100798:	00 00 00 
  ent->fifo_age = 0;
8010079b:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801007a2:	00 00 00 
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  for (i = 0; i < CPT_SIZE; i++)
801007a8:	83 c0 20             	add    $0x20,%eax
801007ab:	3d 00 27 11 80       	cmp    $0x80112700,%eax
801007b0:	75 aa                	jne    8010075c <cpt_invalidate_pid+0x1c>
  release(&g_cpt.lock);
801007b2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
801007b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007bc:	c9                   	leave
  release(&g_cpt.lock);
801007bd:	e9 ee 61 00 00       	jmp    801069b0 <release>
801007c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801007c9:	00 
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801007d0 <cpt_dump>:
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	56                   	push   %esi
  for (i = 0; i < CPT_SIZE; i++)
801007d4:	31 f6                	xor    %esi,%esi
{
801007d6:	53                   	push   %ebx
801007d7:	bb 80 26 11 80       	mov    $0x80112680,%ebx
  acquire(&g_cpt.lock);
801007dc:	83 ec 0c             	sub    $0xc,%esp
801007df:	68 80 26 11 80       	push   $0x80112680
801007e4:	e8 27 62 00 00       	call   80106a10 <acquire>
  cprintf("[cpt] dump:\n");
801007e9:	c7 04 24 69 a3 10 80 	movl   $0x8010a369,(%esp)
801007f0:	e8 1b 0e 00 00       	call   80101610 <cprintf>
  for (i = 0; i < CPT_SIZE; i++)
801007f5:	83 c4 10             	add    $0x10,%esp
    cprintf("  slot %d: valid=%d pid=%d vpn=%d frame=%p\n", i, g_cpt.e[i].valid, g_cpt.e[i].pid, g_cpt.e[i].vpn, g_cpt.e[i].frame);
801007f8:	83 ec 08             	sub    $0x8,%esp
801007fb:	ff b3 80 00 00 00    	push   0x80(%ebx)
  for (i = 0; i < CPT_SIZE; i++)
80100801:	83 c3 20             	add    $0x20,%ebx
    cprintf("  slot %d: valid=%d pid=%d vpn=%d frame=%p\n", i, g_cpt.e[i].valid, g_cpt.e[i].pid, g_cpt.e[i].vpn, g_cpt.e[i].frame);
80100804:	ff 73 5c             	push   0x5c(%ebx)
80100807:	ff 73 58             	push   0x58(%ebx)
8010080a:	ff 73 54             	push   0x54(%ebx)
8010080d:	56                   	push   %esi
  for (i = 0; i < CPT_SIZE; i++)
8010080e:	83 c6 01             	add    $0x1,%esi
    cprintf("  slot %d: valid=%d pid=%d vpn=%d frame=%p\n", i, g_cpt.e[i].valid, g_cpt.e[i].pid, g_cpt.e[i].vpn, g_cpt.e[i].frame);
80100811:	68 28 a9 10 80       	push   $0x8010a928
80100816:	e8 f5 0d 00 00       	call   80101610 <cprintf>
  for (i = 0; i < CPT_SIZE; i++)
8010081b:	83 c4 20             	add    $0x20,%esp
8010081e:	83 fe 04             	cmp    $0x4,%esi
80100821:	75 d5                	jne    801007f8 <cpt_dump+0x28>
  release(&g_cpt.lock);
80100823:	83 ec 0c             	sub    $0xc,%esp
80100826:	68 80 26 11 80       	push   $0x80112680
8010082b:	e8 80 61 00 00       	call   801069b0 <release>
}
80100830:	83 c4 10             	add    $0x10,%esp
80100833:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100836:	5b                   	pop    %ebx
80100837:	5e                   	pop    %esi
80100838:	5d                   	pop    %ebp
80100839:	c3                   	ret
8010083a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100840 <cpt_read_int>:
{
80100840:	55                   	push   %ebp
80100841:	89 e5                	mov    %esp,%ebp
80100843:	57                   	push   %edi
80100844:	56                   	push   %esi
80100845:	53                   	push   %ebx
80100846:	83 ec 0c             	sub    $0xc,%esp
80100849:	8b 45 08             	mov    0x8(%ebp),%eax
8010084c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010084f:	8b 7d 10             	mov    0x10(%ebp),%edi
  if (p == 0 || out == 0)
80100852:	85 c0                	test   %eax,%eax
80100854:	74 6a                	je     801008c0 <cpt_read_int+0x80>
80100856:	85 ff                	test   %edi,%edi
80100858:	74 66                	je     801008c0 <cpt_read_int+0x80>
  if (user_va + 4 > p->sz)
8010085a:	8d 53 04             	lea    0x4(%ebx),%edx
8010085d:	39 10                	cmp    %edx,(%eax)
8010085f:	72 5f                	jb     801008c0 <cpt_read_int+0x80>
  vpn = user_va / PGSIZE;
80100861:	89 d9                	mov    %ebx,%ecx
  off = user_va % PGSIZE;
80100863:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if (off + 4 > PGSIZE)
80100869:	8d 53 04             	lea    0x4(%ebx),%edx
  vpn = user_va / PGSIZE;
8010086c:	c1 e9 0c             	shr    $0xc,%ecx
  if (off + 4 > PGSIZE)
8010086f:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
80100875:	77 49                	ja     801008c0 <cpt_read_int+0x80>
  slot = cpt_get_slot_for_page(p, vpn);
80100877:	89 ca                	mov    %ecx,%edx
80100879:	e8 42 fa ff ff       	call   801002c0 <cpt_get_slot_for_page>
8010087e:	89 c6                	mov    %eax,%esi
  if (slot < 0)
80100880:	85 c0                	test   %eax,%eax
80100882:	78 3c                	js     801008c0 <cpt_read_int+0x80>
  acquire(&g_cpt.lock);
80100884:	83 ec 0c             	sub    $0xc,%esp
  memmove(out, g_cpt.e[slot].frame + off, 4);
80100887:	c1 e6 05             	shl    $0x5,%esi
  acquire(&g_cpt.lock);
8010088a:	68 80 26 11 80       	push   $0x80112680
8010088f:	e8 7c 61 00 00       	call   80106a10 <acquire>
  memmove(out, g_cpt.e[slot].frame + off, 4);
80100894:	83 c4 0c             	add    $0xc,%esp
80100897:	6a 04                	push   $0x4
80100899:	03 9e 00 27 11 80    	add    -0x7feed900(%esi),%ebx
8010089f:	53                   	push   %ebx
801008a0:	57                   	push   %edi
801008a1:	e8 9a 67 00 00       	call   80107040 <memmove>
  release(&g_cpt.lock);
801008a6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801008ad:	e8 fe 60 00 00       	call   801069b0 <release>
  return 0;
801008b2:	83 c4 10             	add    $0x10,%esp
801008b5:	31 c0                	xor    %eax,%eax
}
801008b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008ba:	5b                   	pop    %ebx
801008bb:	5e                   	pop    %esi
801008bc:	5f                   	pop    %edi
801008bd:	5d                   	pop    %ebp
801008be:	c3                   	ret
801008bf:	90                   	nop
    return -1;
801008c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801008c5:	eb f0                	jmp    801008b7 <cpt_read_int+0x77>
801008c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801008ce:	00 
801008cf:	90                   	nop

801008d0 <cpt_write_int>:
{
801008d0:	55                   	push   %ebp
801008d1:	89 e5                	mov    %esp,%ebp
801008d3:	57                   	push   %edi
801008d4:	56                   	push   %esi
801008d5:	53                   	push   %ebx
801008d6:	83 ec 0c             	sub    $0xc,%esp
801008d9:	8b 75 08             	mov    0x8(%ebp),%esi
  if (p == 0)
801008dc:	85 f6                	test   %esi,%esi
801008de:	0f 84 d4 00 00 00    	je     801009b8 <cpt_write_int+0xe8>
  if (user_va + 4 > p->sz)
801008e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801008e7:	83 c0 04             	add    $0x4,%eax
801008ea:	39 06                	cmp    %eax,(%esi)
801008ec:	0f 82 c6 00 00 00    	jb     801009b8 <cpt_write_int+0xe8>
  off = user_va % PGSIZE;
801008f2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  vpn = user_va / PGSIZE;
801008f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  off = user_va % PGSIZE;
801008f8:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  vpn = user_va / PGSIZE;
801008fe:	c1 ea 0c             	shr    $0xc,%edx
  if (off + 4 > PGSIZE)
80100901:	8d 47 04             	lea    0x4(%edi),%eax
80100904:	3d 00 10 00 00       	cmp    $0x1000,%eax
80100909:	0f 87 a9 00 00 00    	ja     801009b8 <cpt_write_int+0xe8>
  slot = cpt_get_slot_for_page(p, vpn);
8010090f:	89 f0                	mov    %esi,%eax
80100911:	e8 aa f9 ff ff       	call   801002c0 <cpt_get_slot_for_page>
80100916:	89 c3                	mov    %eax,%ebx
  if (slot < 0)
80100918:	85 c0                	test   %eax,%eax
8010091a:	0f 88 98 00 00 00    	js     801009b8 <cpt_write_int+0xe8>
  acquire(&g_cpt.lock);
80100920:	83 ec 0c             	sub    $0xc,%esp
80100923:	68 80 26 11 80       	push   $0x80112680
80100928:	e8 e3 60 00 00       	call   80106a10 <acquire>
  memmove(g_cpt.e[slot].frame + off, &value, 4);
8010092d:	89 d8                	mov    %ebx,%eax
8010092f:	83 c4 0c             	add    $0xc,%esp
80100932:	8d 55 10             	lea    0x10(%ebp),%edx
80100935:	c1 e0 05             	shl    $0x5,%eax
80100938:	6a 04                	push   $0x4
  g_cpt.e[idx].last_used = cpt_stamp++;
8010093a:	c1 e3 05             	shl    $0x5,%ebx
  memmove(g_cpt.e[slot].frame + off, &value, 4);
8010093d:	52                   	push   %edx
8010093e:	8b 88 00 27 11 80    	mov    -0x7feed900(%eax),%ecx
80100944:	01 f9                	add    %edi,%ecx
80100946:	51                   	push   %ecx
80100947:	e8 f4 66 00 00       	call   80107040 <memmove>
  g_cpt.e[idx].last_used = cpt_stamp++;
8010094c:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100951:	8d 48 01             	lea    0x1(%eax),%ecx
80100954:	89 83 04 27 11 80    	mov    %eax,-0x7feed8fc(%ebx)
8010095a:	89 0d 00 b0 10 80    	mov    %ecx,0x8010b000
80100960:	8d 8b 00 27 11 80    	lea    -0x7feed900(%ebx),%ecx
  g_cpt.e[idx].freq++;
80100966:	83 41 08 01          	addl   $0x1,0x8(%ecx)
  g_cpt.e[idx].refbit = 1;
8010096a:	c7 41 0c 01 00 00 00 	movl   $0x1,0xc(%ecx)
  release(&g_cpt.lock);
80100971:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80100978:	e8 33 60 00 00       	call   801069b0 <release>
  return uva2ka(p->pgdir, (char *)user_va_page);
8010097d:	58                   	pop    %eax
  kpage = user_va_page_to_kva(p, vpn * PGSIZE);
8010097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  return uva2ka(p->pgdir, (char *)user_va_page);
80100981:	5a                   	pop    %edx
  kpage = user_va_page_to_kva(p, vpn * PGSIZE);
80100982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return uva2ka(p->pgdir, (char *)user_va_page);
80100987:	50                   	push   %eax
80100988:	ff 76 04             	push   0x4(%esi)
8010098b:	e8 60 98 00 00       	call   8010a1f0 <uva2ka>
  if (kpage == 0)
80100990:	83 c4 10             	add    $0x10,%esp
80100993:	85 c0                	test   %eax,%eax
80100995:	74 21                	je     801009b8 <cpt_write_int+0xe8>
  memmove(kpage + off, &value, 4);
80100997:	83 ec 04             	sub    $0x4,%esp
8010099a:	8d 55 10             	lea    0x10(%ebp),%edx
8010099d:	01 f8                	add    %edi,%eax
8010099f:	6a 04                	push   $0x4
801009a1:	52                   	push   %edx
801009a2:	50                   	push   %eax
801009a3:	e8 98 66 00 00       	call   80107040 <memmove>
  return 0;
801009a8:	83 c4 10             	add    $0x10,%esp
801009ab:	31 c0                	xor    %eax,%eax
}
801009ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009b0:	5b                   	pop    %ebx
801009b1:	5e                   	pop    %esi
801009b2:	5f                   	pop    %edi
801009b3:	5d                   	pop    %ebp
801009b4:	c3                   	ret
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801009b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009bd:	eb ee                	jmp    801009ad <cpt_write_int+0xdd>
801009bf:	90                   	nop

801009c0 <cpt_set_policy>:
  }
}

void cpt_set_policy(int policy)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	53                   	push   %ebx
801009c4:	83 ec 10             	sub    $0x10,%esp
801009c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&g_cpt.lock);
801009ca:	68 80 26 11 80       	push   $0x80112680
801009cf:	e8 3c 60 00 00       	call   80106a10 <acquire>
  cpt_policy = policy;
801009d4:	89 1d 04 b0 10 80    	mov    %ebx,0x8010b004
  g_cpt.clock_hand = 0;
  cpt_stamp = 1;
  release(&g_cpt.lock);
801009da:	83 c4 10             	add    $0x10,%esp
}
801009dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  g_cpt.clock_hand = 0;
801009e0:	c7 05 74 27 11 80 00 	movl   $0x0,0x80112774
801009e7:	00 00 00 
  cpt_stamp = 1;
801009ea:	c7 05 00 b0 10 80 01 	movl   $0x1,0x8010b000
801009f1:	00 00 00 
  release(&g_cpt.lock);
801009f4:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
801009fb:	c9                   	leave
  release(&g_cpt.lock);
801009fc:	e9 af 5f 00 00       	jmp    801069b0 <release>
80100a01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a08:	00 
80100a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100a10 <cpt_reset_stats>:

void cpt_reset_stats(int pid)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	53                   	push   %ebx
80100a14:	83 ec 10             	sub    $0x10,%esp
80100a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&g_cpt.lock);
80100a1a:	68 80 26 11 80       	push   $0x80112680
80100a1f:	e8 ec 5f 00 00       	call   80106a10 <acquire>

  // flush CPT entries for this pid for fair benchmarking
  int i;
  for (i = 0; i < CPT_SIZE; i++)
80100a24:	b8 80 26 11 80       	mov    $0x80112680,%eax
80100a29:	83 c4 10             	add    $0x10,%esp
  ent->valid = 0;
80100a2c:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
  for (i = 0; i < CPT_SIZE; i++)
80100a33:	83 c0 20             	add    $0x20,%eax
  ent->pid = -1;
80100a36:	c7 40 58 ff ff ff ff 	movl   $0xffffffff,0x58(%eax)
  ent->vpn = 0;
80100a3d:	c7 40 5c 00 00 00 00 	movl   $0x0,0x5c(%eax)
  ent->last_used = 0;
80100a44:	c7 40 64 00 00 00 00 	movl   $0x0,0x64(%eax)
  ent->freq = 0;
80100a4b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  ent->refbit = 0;
80100a52:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
  ent->fifo_age = 0;
80100a59:	c7 40 70 00 00 00 00 	movl   $0x0,0x70(%eax)
  for (i = 0; i < CPT_SIZE; i++)
80100a60:	3d 00 27 11 80       	cmp    $0x80112700,%eax
80100a65:	75 c5                	jne    80100a2c <cpt_reset_stats+0x1c>
  stats_pid = pid;
  g_stats.accesses = 0;
  g_stats.hits = 0;
  g_stats.misses = 0;
  g_stats.evictions = 0;
  g_stats.policy = cpt_policy;
80100a67:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  stats_pid = pid;
80100a6c:	89 1d 08 b0 10 80    	mov    %ebx,0x8010b008
  g_cpt.clock_hand = 0;
80100a72:	c7 05 74 27 11 80 00 	movl   $0x0,0x80112774
80100a79:	00 00 00 

  release(&g_cpt.lock);
}
80100a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cpt_stamp = 1;
80100a7f:	c7 05 00 b0 10 80 01 	movl   $0x1,0x8010b000
80100a86:	00 00 00 
  g_stats.accesses = 0;
80100a89:	c7 05 78 27 11 80 00 	movl   $0x0,0x80112778
80100a90:	00 00 00 
  g_stats.hits = 0;
80100a93:	c7 05 7c 27 11 80 00 	movl   $0x0,0x8011277c
80100a9a:	00 00 00 
  g_stats.misses = 0;
80100a9d:	c7 05 80 27 11 80 00 	movl   $0x0,0x80112780
80100aa4:	00 00 00 
  g_stats.evictions = 0;
80100aa7:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
80100aae:	00 00 00 
  g_stats.policy = cpt_policy;
80100ab1:	a3 88 27 11 80       	mov    %eax,0x80112788
  release(&g_cpt.lock);
80100ab6:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80100abd:	c9                   	leave
  release(&g_cpt.lock);
80100abe:	e9 ed 5e 00 00       	jmp    801069b0 <release>
80100ac3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100aca:	00 
80100acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80100ad0 <cpt_get_stats>:

void cpt_get_stats(struct cpt_stats *out)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	53                   	push   %ebx
80100ad4:	83 ec 10             	sub    $0x10,%esp
80100ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&g_cpt.lock);
80100ada:	68 80 26 11 80       	push   $0x80112680
80100adf:	e8 2c 5f 00 00       	call   80106a10 <acquire>
  g_stats.policy = cpt_policy;
  *out = g_stats;
80100ae4:	8b 15 78 27 11 80    	mov    0x80112778,%edx
  g_stats.policy = cpt_policy;
80100aea:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&g_cpt.lock);
80100aef:	83 c4 10             	add    $0x10,%esp
  *out = g_stats;
80100af2:	89 13                	mov    %edx,(%ebx)
80100af4:	8b 15 7c 27 11 80    	mov    0x8011277c,%edx
80100afa:	89 43 10             	mov    %eax,0x10(%ebx)
80100afd:	89 53 04             	mov    %edx,0x4(%ebx)
80100b00:	8b 15 80 27 11 80    	mov    0x80112780,%edx
  g_stats.policy = cpt_policy;
80100b06:	a3 88 27 11 80       	mov    %eax,0x80112788
  *out = g_stats;
80100b0b:	89 53 08             	mov    %edx,0x8(%ebx)
80100b0e:	8b 15 84 27 11 80    	mov    0x80112784,%edx
80100b14:	89 53 0c             	mov    %edx,0xc(%ebx)
}
80100b17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&g_cpt.lock);
80100b1a:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80100b21:	c9                   	leave
  release(&g_cpt.lock);
80100b22:	e9 89 5e 00 00       	jmp    801069b0 <release>
80100b27:	66 90                	xchg   %ax,%ax
80100b29:	66 90                	xchg   %ax,%ax
80100b2b:	66 90                	xchg   %ax,%ax
80100b2d:	66 90                	xchg   %ax,%ax
80100b2f:	90                   	nop

80100b30 <insert_at>:
  if (input.e < input.w)
    input.e = input.w;
}

static int insert_at(int pos, const char *src, int n)
{
80100b30:	55                   	push   %ebp
80100b31:	89 e5                	mov    %esp,%ebp
80100b33:	57                   	push   %edi
80100b34:	56                   	push   %esi
80100b35:	53                   	push   %ebx
80100b36:	83 ec 0c             	sub    $0xc,%esp
80100b39:	89 55 f0             	mov    %edx,-0x10(%ebp)
  if (n <= 0)
    return 0;
80100b3c:	31 d2                	xor    %edx,%edx
  if (n <= 0)
80100b3e:	85 c9                	test   %ecx,%ecx
80100b40:	0f 8e db 00 00 00    	jle    80100c21 <insert_at+0xf1>

  int inuse = (int)input.real_end - (int)input.r;
80100b46:	8b 3d 2c 28 11 80    	mov    0x8011282c,%edi
80100b4c:	89 c3                	mov    %eax,%ebx
  int free = INPUT_BUF - inuse;
80100b4e:	b8 80 00 00 00       	mov    $0x80,%eax
  int inuse = (int)input.real_end - (int)input.r;
80100b53:	89 fa                	mov    %edi,%edx
80100b55:	2b 15 20 28 11 80    	sub    0x80112820,%edx
80100b5b:	89 7d ec             	mov    %edi,-0x14(%ebp)
  int free = INPUT_BUF - inuse;
80100b5e:	29 d0                	sub    %edx,%eax
    return 0;
80100b60:	31 d2                	xor    %edx,%edx

  if (free <= 0)
80100b62:	85 c0                	test   %eax,%eax
80100b64:	0f 8e b7 00 00 00    	jle    80100c21 <insert_at+0xf1>
80100b6a:	89 ce                	mov    %ecx,%esi
    return 0;

  if (n > free)
80100b6c:	39 c1                	cmp    %eax,%ecx
    n = free;

  for (int i = (int)input.real_end - 1; i >= pos; --i)
80100b6e:	8d 4f ff             	lea    -0x1(%edi),%ecx
  if (n > free)
80100b71:	0f 4f f0             	cmovg  %eax,%esi
  for (int i = (int)input.real_end - 1; i >= pos; --i)
80100b74:	8d 7b ff             	lea    -0x1(%ebx),%edi
80100b77:	39 d9                	cmp    %ebx,%ecx
80100b79:	7c 4c                	jl     80100bc7 <insert_at+0x97>
80100b7b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
80100b7e:	66 90                	xchg   %ax,%ax
  {
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100b80:	89 c8                	mov    %ecx,%eax
80100b82:	c1 f8 1f             	sar    $0x1f,%eax
80100b85:	c1 e8 19             	shr    $0x19,%eax
80100b88:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80100b8b:	83 e2 7f             	and    $0x7f,%edx
80100b8e:	29 c2                	sub    %eax,%edx
80100b90:	8d 04 31             	lea    (%ecx,%esi,1),%eax
  for (int i = (int)input.real_end - 1; i >= pos; --i)
80100b93:	83 e9 01             	sub    $0x1,%ecx
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100b96:	89 c3                	mov    %eax,%ebx
80100b98:	c1 fb 1f             	sar    $0x1f,%ebx
80100b9b:	c1 eb 19             	shr    $0x19,%ebx
80100b9e:	01 d8                	add    %ebx,%eax
80100ba0:	83 e0 7f             	and    $0x7f,%eax
80100ba3:	29 d8                	sub    %ebx,%eax
80100ba5:	0f b6 9a a0 27 11 80 	movzbl -0x7feed860(%edx),%ebx
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100bac:	8b 14 95 30 28 11 80 	mov    -0x7feed7d0(,%edx,4),%edx
    input.buf[(i + n) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100bb3:	88 98 a0 27 11 80    	mov    %bl,-0x7feed860(%eax)
    input.insert_order[(i + n) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100bb9:	89 14 85 30 28 11 80 	mov    %edx,-0x7feed7d0(,%eax,4)
  for (int i = (int)input.real_end - 1; i >= pos; --i)
80100bc0:	39 f9                	cmp    %edi,%ecx
80100bc2:	75 bc                	jne    80100b80 <insert_at+0x50>
80100bc4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  }

  int wrote = 0;
80100bc7:	31 d2                	xor    %edx,%edx
80100bc9:	89 df                	mov    %ebx,%edi
80100bcb:	eb 35                	jmp    80100c02 <insert_at+0xd2>
80100bcd:	8d 76 00             	lea    0x0(%esi),%esi
  for (; wrote < n; ++wrote)
  {
    char ch = src[wrote];
    if (ch == '\n')
      break; //Don't allow newline
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100bd0:	89 c1                	mov    %eax,%ecx
  for (; wrote < n; ++wrote)
80100bd2:	83 c2 01             	add    $0x1,%edx
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100bd5:	c1 f9 1f             	sar    $0x1f,%ecx
80100bd8:	c1 e9 19             	shr    $0x19,%ecx
80100bdb:	01 c8                	add    %ecx,%eax
80100bdd:	83 e0 7f             	and    $0x7f,%eax
80100be0:	29 c8                	sub    %ecx,%eax
80100be2:	88 98 a0 27 11 80    	mov    %bl,-0x7feed860(%eax)
    input.insert_order[(pos + wrote) % INPUT_BUF] = ++input.current_time;
80100be8:	8b 1d 30 2a 11 80    	mov    0x80112a30,%ebx
80100bee:	8d 4b 01             	lea    0x1(%ebx),%ecx
80100bf1:	89 0d 30 2a 11 80    	mov    %ecx,0x80112a30
80100bf7:	89 0c 85 30 28 11 80 	mov    %ecx,-0x7feed7d0(,%eax,4)
  for (; wrote < n; ++wrote)
80100bfe:	39 d6                	cmp    %edx,%esi
80100c00:	74 2e                	je     80100c30 <insert_at+0x100>
    char ch = src[wrote];
80100c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100c05:	0f b6 1c 10          	movzbl (%eax,%edx,1),%ebx
    input.buf[(pos + wrote) % INPUT_BUF] = ch;
80100c09:	8d 04 17             	lea    (%edi,%edx,1),%eax
    if (ch == '\n')
80100c0c:	80 fb 0a             	cmp    $0xa,%bl
80100c0f:	75 bf                	jne    80100bd0 <insert_at+0xa0>
  }

  input.real_end += wrote;
80100c11:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  input.e = pos + wrote;
80100c14:	a3 28 28 11 80       	mov    %eax,0x80112828
  input.real_end += wrote;
80100c19:	01 d1                	add    %edx,%ecx
80100c1b:	89 0d 2c 28 11 80    	mov    %ecx,0x8011282c

  return wrote;
}
80100c21:	83 c4 0c             	add    $0xc,%esp
80100c24:	89 d0                	mov    %edx,%eax
80100c26:	5b                   	pop    %ebx
80100c27:	5e                   	pop    %esi
80100c28:	5f                   	pop    %edi
80100c29:	5d                   	pop    %ebp
80100c2a:	c3                   	ret
80100c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c30:	8d 04 17             	lea    (%edi,%edx,1),%eax
80100c33:	eb dc                	jmp    80100c11 <insert_at+0xe1>
80100c35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100c3c:	00 
80100c3d:	8d 76 00             	lea    0x0(%esi),%esi

80100c40 <consoleread>:
  if (doprocdump)
    procdump();
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100c40:	55                   	push   %ebp
80100c41:	89 e5                	mov    %esp,%ebp
80100c43:	57                   	push   %edi
80100c44:	56                   	push   %esi
80100c45:	53                   	push   %ebx
80100c46:	83 ec 18             	sub    $0x18,%esp
80100c49:	8b 7d 08             	mov    0x8(%ebp),%edi
80100c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100c4f:	57                   	push   %edi
80100c50:	e8 ab 2a 00 00       	call   80103700 <iunlock>
  target = n;
  acquire(&cons.lock);
80100c55:	c7 04 24 e0 2a 11 80 	movl   $0x80112ae0,(%esp)
80100c5c:	e8 af 5d 00 00       	call   80106a10 <acquire>

  while (n > 0)
80100c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100c64:	83 c4 10             	add    $0x10,%esp
80100c67:	85 db                	test   %ebx,%ebx
80100c69:	0f 8e ac 00 00 00    	jle    80100d1b <consoleread+0xdb>
  {
    while (input.r == input.w)
80100c6f:	a1 20 28 11 80       	mov    0x80112820,%eax
80100c74:	3b 05 24 28 11 80    	cmp    0x80112824,%eax
80100c7a:	74 26                	je     80100ca2 <consoleread+0x62>
80100c7c:	eb 5a                	jmp    80100cd8 <consoleread+0x98>
80100c7e:	66 90                	xchg   %ax,%ax
      {
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100c80:	83 ec 08             	sub    $0x8,%esp
80100c83:	68 e0 2a 11 80       	push   $0x80112ae0
80100c88:	68 20 28 11 80       	push   $0x80112820
80100c8d:	e8 ee 52 00 00       	call   80105f80 <sleep>
    while (input.r == input.w)
80100c92:	a1 20 28 11 80       	mov    0x80112820,%eax
80100c97:	83 c4 10             	add    $0x10,%esp
80100c9a:	3b 05 24 28 11 80    	cmp    0x80112824,%eax
80100ca0:	75 36                	jne    80100cd8 <consoleread+0x98>
      if (myproc()->killed)
80100ca2:	e8 f9 4b 00 00       	call   801058a0 <myproc>
80100ca7:	8b 40 24             	mov    0x24(%eax),%eax
80100caa:	85 c0                	test   %eax,%eax
80100cac:	74 d2                	je     80100c80 <consoleread+0x40>
        release(&cons.lock);
80100cae:	83 ec 0c             	sub    $0xc,%esp
80100cb1:	68 e0 2a 11 80       	push   $0x80112ae0
80100cb6:	e8 f5 5c 00 00       	call   801069b0 <release>
        ilock(ip);
80100cbb:	89 3c 24             	mov    %edi,(%esp)
80100cbe:	e8 4d 29 00 00       	call   80103610 <ilock>
        return -1;
80100cc3:	83 c4 10             	add    $0x10,%esp

  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100cce:	5b                   	pop    %ebx
80100ccf:	5e                   	pop    %esi
80100cd0:	5f                   	pop    %edi
80100cd1:	5d                   	pop    %ebp
80100cd2:	c3                   	ret
80100cd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100cd8:	8d 50 01             	lea    0x1(%eax),%edx
80100cdb:	83 e0 7f             	and    $0x7f,%eax
    *dst++ = c;
80100cde:	83 c6 01             	add    $0x1,%esi
    --n;
80100ce1:	83 eb 01             	sub    $0x1,%ebx
    c = input.buf[input.r++ % INPUT_BUF];
80100ce4:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
80100ceb:	89 15 20 28 11 80    	mov    %edx,0x80112820
    *dst++ = c;
80100cf1:	88 46 ff             	mov    %al,-0x1(%esi)
    c = input.buf[input.r++ % INPUT_BUF];
80100cf4:	89 c2                	mov    %eax,%edx
    if (c == '\n' || c == '\t')
80100cf6:	83 e8 09             	sub    $0x9,%eax
80100cf9:	83 f8 01             	cmp    $0x1,%eax
80100cfc:	0f 87 65 ff ff ff    	ja     80100c67 <consoleread+0x27>
  if (c == '\t')
80100d02:	80 fa 09             	cmp    $0x9,%dl
80100d05:	75 14                	jne    80100d1b <consoleread+0xdb>
    input.r = input.temp_r;
80100d07:	a1 c4 2a 11 80       	mov    0x80112ac4,%eax
80100d0c:	a3 20 28 11 80       	mov    %eax,0x80112820
80100d11:	a1 c8 2a 11 80       	mov    0x80112ac8,%eax
80100d16:	a3 24 28 11 80       	mov    %eax,0x80112824
  release(&cons.lock);
80100d1b:	83 ec 0c             	sub    $0xc,%esp
80100d1e:	68 e0 2a 11 80       	push   $0x80112ae0
80100d23:	e8 88 5c 00 00       	call   801069b0 <release>
  ilock(ip);
80100d28:	89 3c 24             	mov    %edi,(%esp)
80100d2b:	e8 e0 28 00 00       	call   80103610 <ilock>
  return target - n;
80100d30:	8b 45 10             	mov    0x10(%ebp),%eax
80100d33:	83 c4 10             	add    $0x10,%esp
}
80100d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100d39:	29 d8                	sub    %ebx,%eax
}
80100d3b:	5b                   	pop    %ebx
80100d3c:	5e                   	pop    %esi
80100d3d:	5f                   	pop    %edi
80100d3e:	5d                   	pop    %ebp
80100d3f:	c3                   	ret

80100d40 <delete_range.part.0>:
static void delete_range(int lo, int hi)
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	57                   	push   %edi
80100d44:	56                   	push   %esi
  int deln = hi - lo;
80100d45:	89 d6                	mov    %edx,%esi
static void delete_range(int lo, int hi)
80100d47:	53                   	push   %ebx
  int deln = hi - lo;
80100d48:	29 c6                	sub    %eax,%esi
static void delete_range(int lo, int hi)
80100d4a:	89 c3                	mov    %eax,%ebx
80100d4c:	83 ec 0c             	sub    $0xc,%esp
  for (int i = hi; i < (int)input.real_end; i++)
80100d4f:	a1 2c 28 11 80       	mov    0x8011282c,%eax
80100d54:	89 c7                	mov    %eax,%edi
80100d56:	29 f7                	sub    %esi,%edi
80100d58:	39 c2                	cmp    %eax,%edx
80100d5a:	7d 5d                	jge    80100db9 <delete_range.part.0+0x79>
80100d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100d5f:	89 d9                	mov    %ebx,%ecx
80100d61:	89 5d ec             	mov    %ebx,-0x14(%ebp)
80100d64:	89 55 e8             	mov    %edx,-0x18(%ebp)
80100d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d6e:	00 
80100d6f:	90                   	nop
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100d70:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80100d73:	89 cb                	mov    %ecx,%ebx
80100d75:	99                   	cltd
80100d76:	c1 fb 1f             	sar    $0x1f,%ebx
80100d79:	c1 ea 19             	shr    $0x19,%edx
80100d7c:	c1 eb 19             	shr    $0x19,%ebx
80100d7f:	01 d0                	add    %edx,%eax
80100d81:	83 e0 7f             	and    $0x7f,%eax
80100d84:	29 d0                	sub    %edx,%eax
80100d86:	8d 14 19             	lea    (%ecx,%ebx,1),%edx
  for (int i = hi; i < (int)input.real_end; i++)
80100d89:	83 c1 01             	add    $0x1,%ecx
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100d8c:	83 e2 7f             	and    $0x7f,%edx
80100d8f:	29 da                	sub    %ebx,%edx
80100d91:	0f b6 98 a0 27 11 80 	movzbl -0x7feed860(%eax),%ebx
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100d98:	8b 04 85 30 28 11 80 	mov    -0x7feed7d0(,%eax,4),%eax
    input.buf[(i - deln) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80100d9f:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
    input.insert_order[(i - deln) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80100da5:	89 04 95 30 28 11 80 	mov    %eax,-0x7feed7d0(,%edx,4)
  for (int i = hi; i < (int)input.real_end; i++)
80100dac:	39 cf                	cmp    %ecx,%edi
80100dae:	75 c0                	jne    80100d70 <delete_range.part.0+0x30>
80100db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100db3:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80100db6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  input.real_end -= deln;
80100db9:	29 f0                	sub    %esi,%eax
80100dbb:	a3 2c 28 11 80       	mov    %eax,0x8011282c
  if (input.e > hi)
80100dc0:	a1 28 28 11 80       	mov    0x80112828,%eax
80100dc5:	39 c2                	cmp    %eax,%edx
80100dc7:	73 27                	jae    80100df0 <delete_range.part.0+0xb0>
    input.e -= deln;
80100dc9:	29 f0                	sub    %esi,%eax
80100dcb:	a3 28 28 11 80       	mov    %eax,0x80112828
  if (input.e < input.w)
80100dd0:	8b 15 24 28 11 80    	mov    0x80112824,%edx
80100dd6:	39 d0                	cmp    %edx,%eax
80100dd8:	73 06                	jae    80100de0 <delete_range.part.0+0xa0>
    input.e = input.w;
80100dda:	89 15 28 28 11 80    	mov    %edx,0x80112828
}
80100de0:	83 c4 0c             	add    $0xc,%esp
80100de3:	5b                   	pop    %ebx
80100de4:	5e                   	pop    %esi
80100de5:	5f                   	pop    %edi
80100de6:	5d                   	pop    %ebp
80100de7:	c3                   	ret
80100de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100def:	00 
  else if (input.e > lo)
80100df0:	39 c3                	cmp    %eax,%ebx
80100df2:	73 dc                	jae    80100dd0 <delete_range.part.0+0x90>
    input.e = lo;
80100df4:	89 1d 28 28 11 80    	mov    %ebx,0x80112828
80100dfa:	89 d8                	mov    %ebx,%eax
80100dfc:	eb d2                	jmp    80100dd0 <delete_range.part.0+0x90>
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <panic>:
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	56                   	push   %esi
80100e04:	53                   	push   %ebx
80100e05:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100e08:	fa                   	cli
  cons.locking = 0;
80100e09:	c7 05 54 2b 11 80 00 	movl   $0x0,0x80112b54
80100e10:	00 00 00 
  getcallerpcs(&s, pcs);
80100e13:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100e16:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100e19:	e8 c2 39 00 00       	call   801047e0 <lapicid>
80100e1e:	83 ec 08             	sub    $0x8,%esp
80100e21:	50                   	push   %eax
80100e22:	68 76 a3 10 80       	push   $0x8010a376
80100e27:	e8 e4 07 00 00       	call   80101610 <cprintf>
  cprintf(s);
80100e2c:	58                   	pop    %eax
80100e2d:	ff 75 08             	push   0x8(%ebp)
80100e30:	e8 db 07 00 00       	call   80101610 <cprintf>
  cprintf("\n");
80100e35:	c7 04 24 d7 a8 10 80 	movl   $0x8010a8d7,(%esp)
80100e3c:	e8 cf 07 00 00       	call   80101610 <cprintf>
  getcallerpcs(&s, pcs);
80100e41:	8d 45 08             	lea    0x8(%ebp),%eax
80100e44:	5a                   	pop    %edx
80100e45:	59                   	pop    %ecx
80100e46:	53                   	push   %ebx
80100e47:	50                   	push   %eax
80100e48:	e8 f3 59 00 00       	call   80106840 <getcallerpcs>
  for (i = 0; i < 10; i++)
80100e4d:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100e50:	83 ec 08             	sub    $0x8,%esp
80100e53:	ff 33                	push   (%ebx)
  for (i = 0; i < 10; i++)
80100e55:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
80100e58:	68 8a a3 10 80       	push   $0x8010a38a
80100e5d:	e8 ae 07 00 00       	call   80101610 <cprintf>
  for (i = 0; i < 10; i++)
80100e62:	83 c4 10             	add    $0x10,%esp
80100e65:	39 f3                	cmp    %esi,%ebx
80100e67:	75 e7                	jne    80100e50 <panic+0x50>
  panicked = 1;
80100e69:	c7 05 58 2b 11 80 01 	movl   $0x1,0x80112b58
80100e70:	00 00 00 
  for (;;)
80100e73:	eb fe                	jmp    80100e73 <panic+0x73>
80100e75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100e7c:	00 
80100e7d:	8d 76 00             	lea    0x0(%esi),%esi

80100e80 <consputc.part.0>:
void consputc(int c, int k)
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	57                   	push   %edi
80100e84:	56                   	push   %esi
80100e85:	53                   	push   %ebx
80100e86:	83 ec 0c             	sub    $0xc,%esp
  if (c == BACKSPACE)
80100e89:	3d 00 01 00 00       	cmp    $0x100,%eax
80100e8e:	0f 84 64 01 00 00    	je     80100ff8 <consputc.part.0+0x178>
80100e94:	89 c6                	mov    %eax,%esi
  else if (c == KEY_LF)
80100e96:	3d e4 00 00 00       	cmp    $0xe4,%eax
80100e9b:	0f 84 ff 01 00 00    	je     801010a0 <consputc.part.0+0x220>
  else if (c == KEY_RT)
80100ea1:	3d e5 00 00 00       	cmp    $0xe5,%eax
80100ea6:	0f 84 a4 00 00 00    	je     80100f50 <consputc.part.0+0xd0>
    uartputc(c);
80100eac:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100eaf:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100eb4:	50                   	push   %eax
80100eb5:	e8 a6 7f 00 00       	call   80108e60 <uartputc>
80100eba:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ebf:	89 fa                	mov    %edi,%edx
80100ec1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ec2:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100ec7:	89 da                	mov    %ebx,%edx
80100ec9:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100eca:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ecd:	89 fa                	mov    %edi,%edx
80100ecf:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ed4:	c1 e1 08             	shl    $0x8,%ecx
80100ed7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100ed8:	89 da                	mov    %ebx,%edx
80100eda:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100edb:	0f b6 c0             	movzbl %al,%eax
  if (c == '\n')
80100ede:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
80100ee1:	09 c8                	or     %ecx,%eax
  if (c == '\n')
80100ee3:	83 fe 0a             	cmp    $0xa,%esi
80100ee6:	0f 85 84 01 00 00    	jne    80101070 <consputc.part.0+0x1f0>
    pos += 80 - pos % 80;
80100eec:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100ef1:	f7 e2                	mul    %edx
80100ef3:	c1 ea 06             	shr    $0x6,%edx
80100ef6:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100ef9:	c1 e0 04             	shl    $0x4,%eax
80100efc:	8d 58 50             	lea    0x50(%eax),%ebx
  if (pos < 0 || pos > 25 * 80)
80100eff:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100f05:	0f 8f 90 00 00 00    	jg     80100f9b <consputc.part.0+0x11b>
  outb(CRTPORT + 1, pos >> 8);
80100f0b:	0f b6 f7             	movzbl %bh,%esi
  if ((pos / 80) >= 24)
80100f0e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100f14:	0f 8f 96 00 00 00    	jg     80100fb0 <consputc.part.0+0x130>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f1a:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100f1f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f24:	89 fa                	mov    %edi,%edx
80100f26:	ee                   	out    %al,(%dx)
80100f27:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100f2c:	89 f0                	mov    %esi,%eax
80100f2e:	89 ca                	mov    %ecx,%edx
80100f30:	ee                   	out    %al,(%dx)
80100f31:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f36:	89 fa                	mov    %edi,%edx
80100f38:	ee                   	out    %al,(%dx)
80100f39:	89 d8                	mov    %ebx,%eax
80100f3b:	89 ca                	mov    %ecx,%edx
80100f3d:	ee                   	out    %al,(%dx)
}
80100f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f41:	5b                   	pop    %ebx
80100f42:	5e                   	pop    %esi
80100f43:	5f                   	pop    %edi
80100f44:	5d                   	pop    %ebp
80100f45:	c3                   	ret
80100f46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f4d:	00 
80100f4e:	66 90                	xchg   %ax,%ax
    uartputc(k);
80100f50:	83 ec 0c             	sub    $0xc,%esp
80100f53:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f58:	52                   	push   %edx
80100f59:	e8 02 7f 00 00       	call   80108e60 <uartputc>
80100f5e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f63:	89 f2                	mov    %esi,%edx
80100f65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f66:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100f6b:	89 da                	mov    %ebx,%edx
80100f6d:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100f6e:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100f71:	89 f2                	mov    %esi,%edx
80100f73:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f78:	c1 e1 08             	shl    $0x8,%ecx
80100f7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100f7c:	89 da                	mov    %ebx,%edx
80100f7e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100f7f:	0f b6 d8             	movzbl %al,%ebx
    if (pos < 25 * 80 - 1)
80100f82:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT + 1);
80100f85:	09 cb                	or     %ecx,%ebx
    if (pos < 25 * 80 - 1)
80100f87:	81 fb ce 07 00 00    	cmp    $0x7ce,%ebx
80100f8d:	0f 8e 55 01 00 00    	jle    801010e8 <consputc.part.0+0x268>
  if (pos < 0 || pos > 25 * 80)
80100f93:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100f99:	7e 15                	jle    80100fb0 <consputc.part.0+0x130>
    panic("pos under/overflow");
80100f9b:	83 ec 0c             	sub    $0xc,%esp
80100f9e:	68 8e a3 10 80       	push   $0x8010a38e
80100fa3:	e8 58 fe ff ff       	call   80100e00 <panic>
80100fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100faf:	00 
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100fb0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100fb3:	83 eb 50             	sub    $0x50,%ebx
  outb(CRTPORT + 1, pos);
80100fb6:	be 07 00 00 00       	mov    $0x7,%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100fbb:	68 60 0e 00 00       	push   $0xe60
80100fc0:	68 a0 80 0b 80       	push   $0x800b80a0
80100fc5:	68 00 80 0b 80       	push   $0x800b8000
80100fca:	e8 71 60 00 00       	call   80107040 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100fcf:	b8 80 07 00 00       	mov    $0x780,%eax
80100fd4:	83 c4 0c             	add    $0xc,%esp
80100fd7:	29 d8                	sub    %ebx,%eax
80100fd9:	01 c0                	add    %eax,%eax
80100fdb:	50                   	push   %eax
80100fdc:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
80100fe3:	6a 00                	push   $0x0
80100fe5:	50                   	push   %eax
80100fe6:	e8 c5 5f 00 00       	call   80106fb0 <memset>
  outb(CRTPORT + 1, pos);
80100feb:	83 c4 10             	add    $0x10,%esp
80100fee:	e9 27 ff ff ff       	jmp    80100f1a <consputc.part.0+0x9a>
80100ff3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b');
80100ff8:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ffb:	be d4 03 00 00       	mov    $0x3d4,%esi
80101000:	6a 08                	push   $0x8
80101002:	e8 59 7e 00 00       	call   80108e60 <uartputc>
    uartputc(' ');
80101007:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010100e:	e8 4d 7e 00 00       	call   80108e60 <uartputc>
    uartputc('\b');
80101013:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010101a:	e8 41 7e 00 00       	call   80108e60 <uartputc>
8010101f:	b8 0e 00 00 00       	mov    $0xe,%eax
80101024:	89 f2                	mov    %esi,%edx
80101026:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101027:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010102c:	89 da                	mov    %ebx,%edx
8010102e:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
8010102f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101032:	89 f2                	mov    %esi,%edx
80101034:	b8 0f 00 00 00       	mov    $0xf,%eax
80101039:	c1 e1 08             	shl    $0x8,%ecx
8010103c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010103d:	89 da                	mov    %ebx,%edx
8010103f:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80101040:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
80101043:	83 c4 10             	add    $0x10,%esp
80101046:	09 cb                	or     %ecx,%ebx
80101048:	74 16                	je     80101060 <consputc.part.0+0x1e0>
      --pos;
8010104a:	83 eb 01             	sub    $0x1,%ebx
      crt[pos] = ' ' | 0x0700;
8010104d:	b9 20 07 00 00       	mov    $0x720,%ecx
80101052:	66 89 8c 1b 00 80 0b 	mov    %cx,-0x7ff48000(%ebx,%ebx,1)
80101059:	80 
8010105a:	e9 a0 fe ff ff       	jmp    80100eff <consputc.part.0+0x7f>
8010105f:	90                   	nop
  outb(CRTPORT + 1, pos);
80101060:	31 db                	xor    %ebx,%ebx
80101062:	31 f6                	xor    %esi,%esi
80101064:	e9 b1 fe ff ff       	jmp    80100f1a <consputc.part.0+0x9a>
80101069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c & 0xff) | cg_attr;
80101070:	89 f1                	mov    %esi,%ecx
80101072:	8d 58 01             	lea    0x1(%eax),%ebx
    crt[pos] = ' ' | 0x0700;
80101075:	ba 20 07 00 00       	mov    $0x720,%edx
    crt[pos++] = (c & 0xff) | cg_attr;
8010107a:	01 c0                	add    %eax,%eax
8010107c:	0f b6 f1             	movzbl %cl,%esi
8010107f:	66 0b 35 0c b0 10 80 	or     0x8010b00c,%si
    crt[pos] = ' ' | 0x0700;
80101086:	66 89 90 02 80 0b 80 	mov    %dx,-0x7ff47ffe(%eax)
    crt[pos++] = (c & 0xff) | cg_attr;
8010108d:	66 89 b0 00 80 0b 80 	mov    %si,-0x7ff48000(%eax)
    crt[pos] = ' ' | 0x0700;
80101094:	e9 66 fe ff ff       	jmp    80100eff <consputc.part.0+0x7f>
80101099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b');
801010a0:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801010a3:	be d4 03 00 00       	mov    $0x3d4,%esi
801010a8:	6a 08                	push   $0x8
801010aa:	e8 b1 7d 00 00       	call   80108e60 <uartputc>
801010af:	b8 0e 00 00 00       	mov    $0xe,%eax
801010b4:	89 f2                	mov    %esi,%edx
801010b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801010b7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801010bc:	89 da                	mov    %ebx,%edx
801010be:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
801010bf:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801010c2:	89 f2                	mov    %esi,%edx
801010c4:	b8 0f 00 00 00       	mov    $0xf,%eax
801010c9:	c1 e1 08             	shl    $0x8,%ecx
801010cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801010cd:	89 da                	mov    %ebx,%edx
801010cf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
801010d0:	0f b6 d8             	movzbl %al,%ebx
    if (pos > 0)
801010d3:	83 c4 10             	add    $0x10,%esp
801010d6:	09 cb                	or     %ecx,%ebx
801010d8:	74 86                	je     80101060 <consputc.part.0+0x1e0>
      --pos;
801010da:	83 eb 01             	sub    $0x1,%ebx
801010dd:	e9 1d fe ff ff       	jmp    80100eff <consputc.part.0+0x7f>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ++pos;
801010e8:	83 c3 01             	add    $0x1,%ebx
  if (pos < 0 || pos > 25 * 80)
801010eb:	e9 1b fe ff ff       	jmp    80100f0b <consputc.part.0+0x8b>

801010f0 <printint>:
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	89 d3                	mov    %edx,%ebx
801010f8:	83 ec 2c             	sub    $0x2c,%esp
  if (sign && (sign = xx < 0))
801010fb:	85 c0                	test   %eax,%eax
801010fd:	79 05                	jns    80101104 <printint+0x14>
801010ff:	83 e1 01             	and    $0x1,%ecx
80101102:	75 66                	jne    8010116a <printint+0x7a>
    x = xx;
80101104:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010110b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010110d:	31 f6                	xor    %esi,%esi
8010110f:	90                   	nop
    buf[i++] = digits[x % base];
80101110:	89 c8                	mov    %ecx,%eax
80101112:	31 d2                	xor    %edx,%edx
80101114:	89 f7                	mov    %esi,%edi
80101116:	f7 f3                	div    %ebx
80101118:	8d 76 01             	lea    0x1(%esi),%esi
8010111b:	0f b6 92 14 ac 10 80 	movzbl -0x7fef53ec(%edx),%edx
80101122:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  } while ((x /= base) != 0);
80101126:	89 ca                	mov    %ecx,%edx
80101128:	89 c1                	mov    %eax,%ecx
8010112a:	39 da                	cmp    %ebx,%edx
8010112c:	73 e2                	jae    80101110 <printint+0x20>
  if (sign)
8010112e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80101131:	85 c9                	test   %ecx,%ecx
80101133:	74 07                	je     8010113c <printint+0x4c>
    buf[i++] = '-';
80101135:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while (--i >= 0)
8010113a:	89 f7                	mov    %esi,%edi
8010113c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010113f:	01 df                	add    %ebx,%edi
  if (panicked)
80101141:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
    consputc(buf[i], 0);
80101147:	0f be 07             	movsbl (%edi),%eax
  if (panicked)
8010114a:	85 d2                	test   %edx,%edx
8010114c:	74 0a                	je     80101158 <printint+0x68>
  asm volatile("cli");
8010114e:	fa                   	cli
    for (;;)
8010114f:	eb fe                	jmp    8010114f <printint+0x5f>
80101151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101158:	31 d2                	xor    %edx,%edx
8010115a:	e8 21 fd ff ff       	call   80100e80 <consputc.part.0>
  while (--i >= 0)
8010115f:	8d 47 ff             	lea    -0x1(%edi),%eax
80101162:	39 df                	cmp    %ebx,%edi
80101164:	74 11                	je     80101177 <printint+0x87>
80101166:	89 c7                	mov    %eax,%edi
80101168:	eb d7                	jmp    80101141 <printint+0x51>
    x = -xx;
8010116a:	f7 d8                	neg    %eax
  if (sign && (sign = xx < 0))
8010116c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
80101173:	89 c1                	mov    %eax,%ecx
80101175:	eb 96                	jmp    8010110d <printint+0x1d>
}
80101177:	83 c4 2c             	add    $0x2c,%esp
8010117a:	5b                   	pop    %ebx
8010117b:	5e                   	pop    %esi
8010117c:	5f                   	pop    %edi
8010117d:	5d                   	pop    %ebp
8010117e:	c3                   	ret
8010117f:	90                   	nop

80101180 <full_redraw_after_edit>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
  if (old_cursor_off < 0)
80101184:	31 ff                	xor    %edi,%edi
{
80101186:	56                   	push   %esi
80101187:	53                   	push   %ebx
80101188:	83 ec 1c             	sub    $0x1c,%esp
  int old_len = (int)input.real_end - (int)input.w;
8010118b:	8b 35 24 28 11 80    	mov    0x80112824,%esi
80101191:	8b 15 2c 28 11 80    	mov    0x8011282c,%edx
  int old_cursor_off = (int)old_e - (int)input.w;
80101197:	29 f0                	sub    %esi,%eax
  int old_len = (int)input.real_end - (int)input.w;
80101199:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if (old_cursor_off < 0)
8010119c:	85 c0                	test   %eax,%eax
8010119e:	0f 49 f8             	cmovns %eax,%edi
  for (int i = 0; i < old_cursor_off; i++)
801011a1:	7e 28                	jle    801011cb <full_redraw_after_edit+0x4b>
801011a3:	31 db                	xor    %ebx,%ebx
  if (panicked)
801011a5:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
801011ab:	85 c9                	test   %ecx,%ecx
801011ad:	74 09                	je     801011b8 <full_redraw_after_edit+0x38>
801011af:	fa                   	cli
    for (;;)
801011b0:	eb fe                	jmp    801011b0 <full_redraw_after_edit+0x30>
801011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011b8:	31 d2                	xor    %edx,%edx
801011ba:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
801011bf:	83 c3 01             	add    $0x1,%ebx
801011c2:	e8 b9 fc ff ff       	call   80100e80 <consputc.part.0>
801011c7:	39 df                	cmp    %ebx,%edi
801011c9:	7f da                	jg     801011a5 <full_redraw_after_edit+0x25>
  int old_len = (int)input.real_end - (int)input.w;
801011cb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
min_int(int a, int b) { return a < b ? a : b; }
801011ce:	bf 50 00 00 00       	mov    $0x50,%edi
  int old_len = (int)input.real_end - (int)input.w;
801011d3:	29 f3                	sub    %esi,%ebx
  if (old_len < 0)
801011d5:	be 00 00 00 00       	mov    $0x0,%esi
801011da:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
801011dd:	39 fe                	cmp    %edi,%esi
801011df:	0f 4e fe             	cmovle %esi,%edi
  for (int i = 0; i < min_int(old_len, 80); i++)
801011e2:	85 db                	test   %ebx,%ebx
801011e4:	0f 8e 92 00 00 00    	jle    8010127c <full_redraw_after_edit+0xfc>
801011ea:	31 c9                	xor    %ecx,%ecx
  if (panicked)
801011ec:	8b 1d 58 2b 11 80    	mov    0x80112b58,%ebx
801011f2:	85 db                	test   %ebx,%ebx
801011f4:	74 0a                	je     80101200 <full_redraw_after_edit+0x80>
801011f6:	fa                   	cli
    for (;;)
801011f7:	eb fe                	jmp    801011f7 <full_redraw_after_edit+0x77>
801011f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101200:	31 d2                	xor    %edx,%edx
80101202:	b8 20 00 00 00       	mov    $0x20,%eax
80101207:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010120a:	e8 71 fc ff ff       	call   80100e80 <consputc.part.0>
  for (int i = 0; i < min_int(old_len, 80); i++)
8010120f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101212:	83 c1 01             	add    $0x1,%ecx
80101215:	39 f9                	cmp    %edi,%ecx
80101217:	7c d3                	jl     801011ec <full_redraw_after_edit+0x6c>
  if (panicked)
80101219:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
8010121f:	85 c9                	test   %ecx,%ecx
80101221:	75 3d                	jne    80101260 <full_redraw_after_edit+0xe0>
80101223:	31 d2                	xor    %edx,%edx
80101225:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < min_int(old_len, 80); i++)
8010122a:	83 c3 01             	add    $0x1,%ebx
8010122d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101230:	e8 4b fc ff ff       	call   80100e80 <consputc.part.0>
80101235:	39 fb                	cmp    %edi,%ebx
80101237:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010123a:	7c dd                	jl     80101219 <full_redraw_after_edit+0x99>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
8010123c:	a1 24 28 11 80       	mov    0x80112824,%eax
  if (panicked)
80101241:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101247:	01 c8                	add    %ecx,%eax
80101249:	83 e0 7f             	and    $0x7f,%eax
8010124c:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
80101253:	85 d2                	test   %edx,%edx
80101255:	74 11                	je     80101268 <full_redraw_after_edit+0xe8>
80101257:	fa                   	cli
    for (;;)
80101258:	eb fe                	jmp    80101258 <full_redraw_after_edit+0xd8>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101260:	fa                   	cli
80101261:	eb fe                	jmp    80101261 <full_redraw_after_edit+0xe1>
80101263:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101268:	31 d2                	xor    %edx,%edx
8010126a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010126d:	e8 0e fc ff ff       	call   80100e80 <consputc.part.0>
  for (int i = 0; i < old_len; i++)
80101272:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101275:	83 c1 01             	add    $0x1,%ecx
80101278:	39 ce                	cmp    %ecx,%esi
8010127a:	7f c0                	jg     8010123c <full_redraw_after_edit+0xbc>
  int moves_left = old_len - new_cursor_off;
8010127c:	8b 1d 24 28 11 80    	mov    0x80112824,%ebx
  int new_cursor_off = (int)input.e - (int)input.w;
80101282:	2b 35 28 28 11 80    	sub    0x80112828,%esi
  int moves_left = old_len - new_cursor_off;
80101288:	01 f3                	add    %esi,%ebx
  for (int i = 0; i < moves_left; i++)
8010128a:	31 f6                	xor    %esi,%esi
8010128c:	85 db                	test   %ebx,%ebx
8010128e:	7e 23                	jle    801012b3 <full_redraw_after_edit+0x133>
  if (panicked)
80101290:	a1 58 2b 11 80       	mov    0x80112b58,%eax
80101295:	85 c0                	test   %eax,%eax
80101297:	74 07                	je     801012a0 <full_redraw_after_edit+0x120>
80101299:	fa                   	cli
    for (;;)
8010129a:	eb fe                	jmp    8010129a <full_redraw_after_edit+0x11a>
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012a0:	31 d2                	xor    %edx,%edx
801012a2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
801012a7:	83 c6 01             	add    $0x1,%esi
801012aa:	e8 d1 fb ff ff       	call   80100e80 <consputc.part.0>
801012af:	39 f3                	cmp    %esi,%ebx
801012b1:	75 dd                	jne    80101290 <full_redraw_after_edit+0x110>
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	5b                   	pop    %ebx
801012b7:	5e                   	pop    %esi
801012b8:	5f                   	pop    %edi
801012b9:	5d                   	pop    %ebp
801012ba:	c3                   	ret
801012bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801012c0 <full_redraw_after_edit_len>:
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	31 ff                	xor    %edi,%edi
801012c6:	56                   	push   %esi
801012c7:	53                   	push   %ebx
801012c8:	89 d3                	mov    %edx,%ebx
  if (old_cursor_off < 0)
801012ca:	31 d2                	xor    %edx,%edx
801012cc:	89 d6                	mov    %edx,%esi
{
801012ce:	83 ec 0c             	sub    $0xc,%esp
  int old_cursor_off = (int)old_e - (int)input.w;
801012d1:	2b 05 24 28 11 80    	sub    0x80112824,%eax
  if (old_cursor_off < 0)
801012d7:	85 c0                	test   %eax,%eax
801012d9:	0f 49 f0             	cmovns %eax,%esi
  for (int i = 0; i < old_cursor_off; i++)
801012dc:	7e 25                	jle    80101303 <full_redraw_after_edit_len+0x43>
  if (panicked)
801012de:	a1 58 2b 11 80       	mov    0x80112b58,%eax
801012e3:	85 c0                	test   %eax,%eax
801012e5:	74 09                	je     801012f0 <full_redraw_after_edit_len+0x30>
801012e7:	fa                   	cli
    for (;;)
801012e8:	eb fe                	jmp    801012e8 <full_redraw_after_edit_len+0x28>
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012f0:	31 d2                	xor    %edx,%edx
801012f2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < old_cursor_off; i++)
801012f7:	83 c7 01             	add    $0x1,%edi
801012fa:	e8 81 fb ff ff       	call   80100e80 <consputc.part.0>
801012ff:	39 f7                	cmp    %esi,%edi
80101301:	7c db                	jl     801012de <full_redraw_after_edit_len+0x1e>
  if (old_len_before < 0)
80101303:	31 f6                	xor    %esi,%esi
80101305:	85 db                	test   %ebx,%ebx
min_int(int a, int b) { return a < b ? a : b; }
80101307:	b8 50 00 00 00       	mov    $0x50,%eax
  if (old_len_before < 0)
8010130c:	0f 49 f3             	cmovns %ebx,%esi
min_int(int a, int b) { return a < b ? a : b; }
8010130f:	39 c6                	cmp    %eax,%esi
80101311:	0f 4f f0             	cmovg  %eax,%esi
  for (int i = 0; i < wipe; i++)
80101314:	31 ff                	xor    %edi,%edi
80101316:	85 db                	test   %ebx,%ebx
80101318:	7e 46                	jle    80101360 <full_redraw_after_edit_len+0xa0>
  if (panicked)
8010131a:	8b 1d 58 2b 11 80    	mov    0x80112b58,%ebx
80101320:	85 db                	test   %ebx,%ebx
80101322:	74 0c                	je     80101330 <full_redraw_after_edit_len+0x70>
80101324:	fa                   	cli
    for (;;)
80101325:	eb fe                	jmp    80101325 <full_redraw_after_edit_len+0x65>
80101327:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010132e:	00 
8010132f:	90                   	nop
80101330:	31 d2                	xor    %edx,%edx
80101332:	b8 20 00 00 00       	mov    $0x20,%eax
  for (int i = 0; i < wipe; i++)
80101337:	83 c7 01             	add    $0x1,%edi
8010133a:	e8 41 fb ff ff       	call   80100e80 <consputc.part.0>
8010133f:	39 fe                	cmp    %edi,%esi
80101341:	7f d7                	jg     8010131a <full_redraw_after_edit_len+0x5a>
  if (panicked)
80101343:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
80101349:	85 c9                	test   %ecx,%ecx
8010134b:	75 4b                	jne    80101398 <full_redraw_after_edit_len+0xd8>
8010134d:	31 d2                	xor    %edx,%edx
8010134f:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < wipe; i++)
80101354:	83 c3 01             	add    $0x1,%ebx
80101357:	e8 24 fb ff ff       	call   80100e80 <consputc.part.0>
8010135c:	39 de                	cmp    %ebx,%esi
8010135e:	7f e3                	jg     80101343 <full_redraw_after_edit_len+0x83>
  int new_len = (int)input.real_end - (int)input.w;
80101360:	a1 24 28 11 80       	mov    0x80112824,%eax
80101365:	8b 15 2c 28 11 80    	mov    0x8011282c,%edx
  if (new_len < 0)
8010136b:	31 db                	xor    %ebx,%ebx
  for (int i = 0; i < new_len; i++)
8010136d:	be 00 00 00 00       	mov    $0x0,%esi
  int new_len = (int)input.real_end - (int)input.w;
80101372:	29 c2                	sub    %eax,%edx
  if (new_len < 0)
80101374:	85 d2                	test   %edx,%edx
80101376:	0f 49 da             	cmovns %edx,%ebx
  for (int i = 0; i < new_len; i++)
80101379:	7e 3a                	jle    801013b5 <full_redraw_after_edit_len+0xf5>
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
8010137b:	01 f0                	add    %esi,%eax
  if (panicked)
8010137d:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
    consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
80101383:	83 e0 7f             	and    $0x7f,%eax
80101386:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
8010138d:	85 d2                	test   %edx,%edx
8010138f:	74 0f                	je     801013a0 <full_redraw_after_edit_len+0xe0>
80101391:	fa                   	cli
    for (;;)
80101392:	eb fe                	jmp    80101392 <full_redraw_after_edit_len+0xd2>
80101394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101398:	fa                   	cli
80101399:	eb fe                	jmp    80101399 <full_redraw_after_edit_len+0xd9>
8010139b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801013a0:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < new_len; i++)
801013a2:	83 c6 01             	add    $0x1,%esi
801013a5:	e8 d6 fa ff ff       	call   80100e80 <consputc.part.0>
801013aa:	39 f3                	cmp    %esi,%ebx
801013ac:	7e 07                	jle    801013b5 <full_redraw_after_edit_len+0xf5>
  int new_cursor_off = (int)input.e - (int)input.w;
801013ae:	a1 24 28 11 80       	mov    0x80112824,%eax
801013b3:	eb c6                	jmp    8010137b <full_redraw_after_edit_len+0xbb>
801013b5:	a1 28 28 11 80       	mov    0x80112828,%eax
  if (new_cursor_off < 0)
801013ba:	ba 00 00 00 00       	mov    $0x0,%edx
  int new_cursor_off = (int)input.e - (int)input.w;
801013bf:	2b 05 24 28 11 80    	sub    0x80112824,%eax
  if (new_cursor_off < 0)
801013c5:	0f 48 c2             	cmovs  %edx,%eax
  for (int i = 0; i < moves_left; i++)
801013c8:	31 f6                	xor    %esi,%esi
  int moves_left = new_len - new_cursor_off;
801013ca:	29 c3                	sub    %eax,%ebx
  for (int i = 0; i < moves_left; i++)
801013cc:	85 db                	test   %ebx,%ebx
801013ce:	7e 23                	jle    801013f3 <full_redraw_after_edit_len+0x133>
  if (panicked)
801013d0:	a1 58 2b 11 80       	mov    0x80112b58,%eax
801013d5:	85 c0                	test   %eax,%eax
801013d7:	74 07                	je     801013e0 <full_redraw_after_edit_len+0x120>
801013d9:	fa                   	cli
    for (;;)
801013da:	eb fe                	jmp    801013da <full_redraw_after_edit_len+0x11a>
801013dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e0:	31 d2                	xor    %edx,%edx
801013e2:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < moves_left; i++)
801013e7:	83 c6 01             	add    $0x1,%esi
801013ea:	e8 91 fa ff ff       	call   80100e80 <consputc.part.0>
801013ef:	39 f3                	cmp    %esi,%ebx
801013f1:	75 dd                	jne    801013d0 <full_redraw_after_edit_len+0x110>
}
801013f3:	83 c4 0c             	add    $0xc,%esp
801013f6:	5b                   	pop    %ebx
801013f7:	5e                   	pop    %esi
801013f8:	5f                   	pop    %edi
801013f9:	5d                   	pop    %ebp
801013fa:	c3                   	ret
801013fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101400 <replace_selection_with>:
{
80101400:	55                   	push   %ebp
80101401:	89 d1                	mov    %edx,%ecx
80101403:	89 e5                	mov    %esp,%ebp
80101405:	57                   	push   %edi
80101406:	56                   	push   %esi
80101407:	89 c6                	mov    %eax,%esi
80101409:	53                   	push   %ebx
8010140a:	83 ec 1c             	sub    $0x1c,%esp
  int a = input.sel_a, b = input.sel_b;
8010140d:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
80101413:	a1 38 2a 11 80       	mov    0x80112a38,%eax
  int old_len = (int)input.real_end - (int)input.w;
80101418:	8b 1d 2c 28 11 80    	mov    0x8011282c,%ebx
  uint old_e = input.e;
8010141e:	8b 3d 28 28 11 80    	mov    0x80112828,%edi
  int old_len = (int)input.real_end - (int)input.w;
80101424:	2b 1d 24 28 11 80    	sub    0x80112824,%ebx
  if (a > b)
8010142a:	39 c2                	cmp    %eax,%edx
8010142c:	7f 3a                	jg     80101468 <replace_selection_with+0x68>
  if (hi <= lo)
8010142e:	75 30                	jne    80101460 <replace_selection_with+0x60>
  insert_at(lo, src, n);
80101430:	89 f2                	mov    %esi,%edx
80101432:	e8 f9 f6 ff ff       	call   80100b30 <insert_at>
  full_redraw_after_edit_len(old_e, old_len);
80101437:	89 da                	mov    %ebx,%edx
80101439:	89 f8                	mov    %edi,%eax
  input.sel_a = input.sel_b = -1;
8010143b:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
80101442:	ff ff ff 
80101445:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
8010144c:	ff ff ff 
}
8010144f:	83 c4 1c             	add    $0x1c,%esp
80101452:	5b                   	pop    %ebx
80101453:	5e                   	pop    %esi
80101454:	5f                   	pop    %edi
80101455:	5d                   	pop    %ebp
  full_redraw_after_edit_len(old_e, old_len);
80101456:	e9 65 fe ff ff       	jmp    801012c0 <full_redraw_after_edit_len>
8010145b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80101460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101463:	89 d0                	mov    %edx,%eax
80101465:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101468:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010146b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010146e:	e8 cd f8 ff ff       	call   80100d40 <delete_range.part.0>
80101473:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101479:	eb b5                	jmp    80101430 <replace_selection_with+0x30>
8010147b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101480 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	57                   	push   %edi
80101484:	56                   	push   %esi
80101485:	53                   	push   %ebx
80101486:	83 ec 28             	sub    $0x28,%esp
80101489:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010148c:	ff 75 08             	push   0x8(%ebp)
8010148f:	e8 6c 22 00 00       	call   80103700 <iunlock>
  acquire(&cons.lock);
80101494:	c7 04 24 e0 2a 11 80 	movl   $0x80112ae0,(%esp)
8010149b:	e8 70 55 00 00       	call   80106a10 <acquire>

  if (!input.is_tab_mode)
801014a0:	8b 0d bc 2a 11 80    	mov    0x80112abc,%ecx
801014a6:	83 c4 10             	add    $0x10,%esp
801014a9:	85 c9                	test   %ecx,%ecx
801014ab:	75 23                	jne    801014d0 <consolewrite+0x50>
  {
    // Normal state of echo
    for (i = 0; i < n; i++)
801014ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801014b0:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
801014b3:	85 f6                	test   %esi,%esi
801014b5:	7e 67                	jle    8010151e <consolewrite+0x9e>
  if (panicked)
801014b7:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
      consputc(buf[i] & 0xff, 0);
801014bd:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
801014c0:	85 d2                	test   %edx,%edx
801014c2:	74 4c                	je     80101510 <consolewrite+0x90>
801014c4:	fa                   	cli
    for (;;)
801014c5:	eb fe                	jmp    801014c5 <consolewrite+0x45>
801014c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014ce:	00 
801014cf:	90                   	nop
  }

  else
  {
    // Write from the cursor point not the beggining
    uint start = input.e;
801014d0:	8b 0d 28 28 11 80    	mov    0x80112828,%ecx
    for (i = 0; i < n; i++)
801014d6:	85 f6                	test   %esi,%esi
801014d8:	0f 8e 95 00 00 00    	jle    80101573 <consolewrite+0xf3>
801014de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801014e1:	89 75 10             	mov    %esi,0x10(%ebp)
801014e4:	31 ff                	xor    %edi,%edi
801014e6:	89 ce                	mov    %ecx,%esi
    {
      if (buf[i] == TAB)
801014e8:	0f b6 03             	movzbl (%ebx),%eax
801014eb:	3c 09                	cmp    $0x9,%al
801014ed:	0f 84 a2 00 00 00    	je     80101595 <consolewrite+0x115>
  if (panicked)
801014f3:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
        input.has_enter = 0;
        input.is_tab_mode = 0;
        break;
      }

      if (buf[i] == ENTER || buf[i] == NEW_LINE)
801014f9:	3c 0d                	cmp    $0xd,%al
801014fb:	0f 84 b3 00 00 00    	je     801015b4 <consolewrite+0x134>
80101501:	3c 0a                	cmp    $0xa,%al
80101503:	0f 84 ab 00 00 00    	je     801015b4 <consolewrite+0x134>
  if (panicked)
80101509:	85 d2                	test   %edx,%edx
8010150b:	74 31                	je     8010153e <consolewrite+0xbe>
8010150d:	fa                   	cli
    for (;;)
8010150e:	eb fe                	jmp    8010150e <consolewrite+0x8e>
80101510:	31 d2                	xor    %edx,%edx
    for (i = 0; i < n; i++)
80101512:	83 c3 01             	add    $0x1,%ebx
80101515:	e8 66 f9 ff ff       	call   80100e80 <consputc.part.0>
8010151a:	39 fb                	cmp    %edi,%ebx
8010151c:	75 99                	jne    801014b7 <consolewrite+0x37>

    if (input.real_end < input.e)
      input.real_end = input.e;
  }

  release(&cons.lock);
8010151e:	83 ec 0c             	sub    $0xc,%esp
80101521:	68 e0 2a 11 80       	push   $0x80112ae0
80101526:	e8 85 54 00 00       	call   801069b0 <release>
  ilock(ip);
8010152b:	58                   	pop    %eax
8010152c:	ff 75 08             	push   0x8(%ebp)
8010152f:	e8 dc 20 00 00       	call   80103610 <ilock>

  return n;
}
80101534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101537:	89 f0                	mov    %esi,%eax
80101539:	5b                   	pop    %ebx
8010153a:	5e                   	pop    %esi
8010153b:	5f                   	pop    %edi
8010153c:	5d                   	pop    %ebp
8010153d:	c3                   	ret
8010153e:	31 d2                	xor    %edx,%edx
    for (i = 0; i < n; i++)
80101540:	83 c3 01             	add    $0x1,%ebx
80101543:	e8 38 f9 ff ff       	call   80100e80 <consputc.part.0>
      input.buf[(start + i) % INPUT_BUF] = buf[i];
80101548:	8d 04 3e             	lea    (%esi,%edi,1),%eax
8010154b:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    for (i = 0; i < n; i++)
8010154f:	83 c7 01             	add    $0x1,%edi
      input.buf[(start + i) % INPUT_BUF] = buf[i];
80101552:	83 e0 7f             	and    $0x7f,%eax
80101555:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
    for (i = 0; i < n; i++)
8010155b:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010155e:	75 88                	jne    801014e8 <consolewrite+0x68>
80101560:	8b 75 10             	mov    0x10(%ebp),%esi
    if (input.is_tab_mode && !input.has_enter)
80101563:	8b 1d bc 2a 11 80    	mov    0x80112abc,%ebx
      input.e += n; // cursor moves right as much as the length of new order is.
80101569:	8b 0d 28 28 11 80    	mov    0x80112828,%ecx
    if (input.is_tab_mode && !input.has_enter)
8010156f:	85 db                	test   %ebx,%ebx
80101571:	74 12                	je     80101585 <consolewrite+0x105>
80101573:	8b 15 d4 2a 11 80    	mov    0x80112ad4,%edx
80101579:	85 d2                	test   %edx,%edx
8010157b:	75 08                	jne    80101585 <consolewrite+0x105>
      input.e += n; // cursor moves right as much as the length of new order is.
8010157d:	01 f1                	add    %esi,%ecx
8010157f:	89 0d 28 28 11 80    	mov    %ecx,0x80112828
    if (input.real_end < input.e)
80101585:	39 0d 2c 28 11 80    	cmp    %ecx,0x8011282c
8010158b:	73 91                	jae    8010151e <consolewrite+0x9e>
      input.real_end = input.e;
8010158d:	89 0d 2c 28 11 80    	mov    %ecx,0x8011282c
80101593:	eb 89                	jmp    8010151e <consolewrite+0x9e>
        input.has_enter = 0;
80101595:	c7 05 d4 2a 11 80 00 	movl   $0x0,0x80112ad4
8010159c:	00 00 00 
8010159f:	8b 75 10             	mov    0x10(%ebp),%esi
        input.is_tab_mode = 0;
801015a2:	c7 05 bc 2a 11 80 00 	movl   $0x0,0x80112abc
801015a9:	00 00 00 
    if (input.real_end < input.e)
801015ac:	8b 0d 28 28 11 80    	mov    0x80112828,%ecx
801015b2:	eb d1                	jmp    80101585 <consolewrite+0x105>
        input.e = input.temp_e;
801015b4:	a1 d0 2a 11 80       	mov    0x80112ad0,%eax
801015b9:	89 f1                	mov    %esi,%ecx
801015bb:	8b 75 10             	mov    0x10(%ebp),%esi
        input.has_enter = 1;
801015be:	c7 05 d4 2a 11 80 01 	movl   $0x1,0x80112ad4
801015c5:	00 00 00 
        input.e = input.temp_e;
801015c8:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(buf[i] & 0xff, 0);
801015cd:	0f b6 03             	movzbl (%ebx),%eax
  if (panicked)
801015d0:	85 d2                	test   %edx,%edx
801015d2:	74 0c                	je     801015e0 <consolewrite+0x160>
801015d4:	fa                   	cli
    for (;;)
801015d5:	eb fe                	jmp    801015d5 <consolewrite+0x155>
801015d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015de:	00 
801015df:	90                   	nop
801015e0:	31 d2                	xor    %edx,%edx
801015e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801015e5:	e8 96 f8 ff ff       	call   80100e80 <consputc.part.0>
        input.buf[(start + i) % INPUT_BUF] = buf[i];
801015ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801015ed:	0f b6 13             	movzbl (%ebx),%edx
801015f0:	8d 04 39             	lea    (%ecx,%edi,1),%eax
801015f3:	83 e0 7f             	and    $0x7f,%eax
801015f6:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
        break;
801015fc:	e9 62 ff ff ff       	jmp    80101563 <consolewrite+0xe3>
80101601:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101608:	00 
80101609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101610 <cprintf>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80101619:	8b 3d 54 2b 11 80    	mov    0x80112b54,%edi
  if (fmt == 0)
8010161f:	8b 75 08             	mov    0x8(%ebp),%esi
  if (locking)
80101622:	85 ff                	test   %edi,%edi
80101624:	0f 85 06 01 00 00    	jne    80101730 <cprintf+0x120>
  if (fmt == 0)
8010162a:	85 f6                	test   %esi,%esi
8010162c:	0f 84 e0 01 00 00    	je     80101812 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80101632:	0f b6 06             	movzbl (%esi),%eax
80101635:	85 c0                	test   %eax,%eax
80101637:	74 59                	je     80101692 <cprintf+0x82>
80101639:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  argp = (uint *)(void *)(&fmt + 1);
8010163c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010163f:	31 db                	xor    %ebx,%ebx
    if (c != '%')
80101641:	83 f8 25             	cmp    $0x25,%eax
80101644:	75 5a                	jne    801016a0 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80101646:	83 c3 01             	add    $0x1,%ebx
80101649:	0f b6 3c 1e          	movzbl (%esi,%ebx,1),%edi
    if (c == 0)
8010164d:	85 ff                	test   %edi,%edi
8010164f:	74 36                	je     80101687 <cprintf+0x77>
    switch (c)
80101651:	83 ff 70             	cmp    $0x70,%edi
80101654:	0f 84 b6 00 00 00    	je     80101710 <cprintf+0x100>
8010165a:	7f 74                	jg     801016d0 <cprintf+0xc0>
8010165c:	83 ff 25             	cmp    $0x25,%edi
8010165f:	74 5e                	je     801016bf <cprintf+0xaf>
80101661:	83 ff 64             	cmp    $0x64,%edi
80101664:	75 78                	jne    801016de <cprintf+0xce>
      printint(*argp++, 10, 1);
80101666:	8b 01                	mov    (%ecx),%eax
80101668:	8d 79 04             	lea    0x4(%ecx),%edi
8010166b:	ba 0a 00 00 00       	mov    $0xa,%edx
80101670:	b9 01 00 00 00       	mov    $0x1,%ecx
80101675:	e8 76 fa ff ff       	call   801010f0 <printint>
8010167a:	89 f9                	mov    %edi,%ecx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010167c:	83 c3 01             	add    $0x1,%ebx
8010167f:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80101683:	85 c0                	test   %eax,%eax
80101685:	75 ba                	jne    80101641 <cprintf+0x31>
80101687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if (locking)
8010168a:	85 ff                	test   %edi,%edi
8010168c:	0f 85 c1 00 00 00    	jne    80101753 <cprintf+0x143>
}
80101692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101695:	5b                   	pop    %ebx
80101696:	5e                   	pop    %esi
80101697:	5f                   	pop    %edi
80101698:	5d                   	pop    %ebp
80101699:	c3                   	ret
8010169a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (panicked)
801016a0:	8b 3d 58 2b 11 80    	mov    0x80112b58,%edi
801016a6:	85 ff                	test   %edi,%edi
801016a8:	74 06                	je     801016b0 <cprintf+0xa0>
801016aa:	fa                   	cli
    for (;;)
801016ab:	eb fe                	jmp    801016ab <cprintf+0x9b>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi
801016b0:	31 d2                	xor    %edx,%edx
801016b2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016b5:	e8 c6 f7 ff ff       	call   80100e80 <consputc.part.0>
      continue;
801016ba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016bd:	eb bd                	jmp    8010167c <cprintf+0x6c>
  if (panicked)
801016bf:	8b 3d 58 2b 11 80    	mov    0x80112b58,%edi
801016c5:	85 ff                	test   %edi,%edi
801016c7:	0f 84 13 01 00 00    	je     801017e0 <cprintf+0x1d0>
801016cd:	fa                   	cli
    for (;;)
801016ce:	eb fe                	jmp    801016ce <cprintf+0xbe>
    switch (c)
801016d0:	83 ff 73             	cmp    $0x73,%edi
801016d3:	0f 84 8f 00 00 00    	je     80101768 <cprintf+0x158>
801016d9:	83 ff 78             	cmp    $0x78,%edi
801016dc:	74 32                	je     80101710 <cprintf+0x100>
  if (panicked)
801016de:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
801016e4:	85 d2                	test   %edx,%edx
801016e6:	0f 85 e8 00 00 00    	jne    801017d4 <cprintf+0x1c4>
801016ec:	31 d2                	xor    %edx,%edx
801016ee:	b8 25 00 00 00       	mov    $0x25,%eax
801016f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016f6:	e8 85 f7 ff ff       	call   80100e80 <consputc.part.0>
801016fb:	a1 58 2b 11 80       	mov    0x80112b58,%eax
80101700:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101703:	85 c0                	test   %eax,%eax
80101705:	0f 84 ec 00 00 00    	je     801017f7 <cprintf+0x1e7>
8010170b:	fa                   	cli
    for (;;)
8010170c:	eb fe                	jmp    8010170c <cprintf+0xfc>
8010170e:	66 90                	xchg   %ax,%ax
      printint(*argp++, 16, 0);
80101710:	8b 01                	mov    (%ecx),%eax
80101712:	8d 79 04             	lea    0x4(%ecx),%edi
80101715:	ba 10 00 00 00       	mov    $0x10,%edx
8010171a:	31 c9                	xor    %ecx,%ecx
8010171c:	e8 cf f9 ff ff       	call   801010f0 <printint>
80101721:	89 f9                	mov    %edi,%ecx
      break;
80101723:	e9 54 ff ff ff       	jmp    8010167c <cprintf+0x6c>
80101728:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010172f:	00 
    acquire(&cons.lock);
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 e0 2a 11 80       	push   $0x80112ae0
80101738:	e8 d3 52 00 00       	call   80106a10 <acquire>
  if (fmt == 0)
8010173d:	83 c4 10             	add    $0x10,%esp
80101740:	85 f6                	test   %esi,%esi
80101742:	0f 84 ca 00 00 00    	je     80101812 <cprintf+0x202>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80101748:	0f b6 06             	movzbl (%esi),%eax
8010174b:	85 c0                	test   %eax,%eax
8010174d:	0f 85 e6 fe ff ff    	jne    80101639 <cprintf+0x29>
    release(&cons.lock);
80101753:	83 ec 0c             	sub    $0xc,%esp
80101756:	68 e0 2a 11 80       	push   $0x80112ae0
8010175b:	e8 50 52 00 00       	call   801069b0 <release>
80101760:	83 c4 10             	add    $0x10,%esp
80101763:	e9 2a ff ff ff       	jmp    80101692 <cprintf+0x82>
      if ((s = (char *)*argp++) == 0)
80101768:	8b 39                	mov    (%ecx),%edi
8010176a:	8d 51 04             	lea    0x4(%ecx),%edx
8010176d:	85 ff                	test   %edi,%edi
8010176f:	74 27                	je     80101798 <cprintf+0x188>
      for (; *s; s++)
80101771:	0f be 07             	movsbl (%edi),%eax
80101774:	84 c0                	test   %al,%al
80101776:	0f 84 8f 00 00 00    	je     8010180b <cprintf+0x1fb>
8010177c:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010177f:	89 fb                	mov    %edi,%ebx
80101781:	89 f7                	mov    %esi,%edi
80101783:	89 d6                	mov    %edx,%esi
  if (panicked)
80101785:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
8010178b:	85 d2                	test   %edx,%edx
8010178d:	74 26                	je     801017b5 <cprintf+0x1a5>
8010178f:	fa                   	cli
    for (;;)
80101790:	eb fe                	jmp    80101790 <cprintf+0x180>
80101792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        s = "(null)";
80101798:	bf a1 a3 10 80       	mov    $0x8010a3a1,%edi
8010179d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801017a0:	b8 28 00 00 00       	mov    $0x28,%eax
801017a5:	89 fb                	mov    %edi,%ebx
801017a7:	89 f7                	mov    %esi,%edi
801017a9:	89 d6                	mov    %edx,%esi
  if (panicked)
801017ab:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
801017b1:	85 d2                	test   %edx,%edx
801017b3:	75 da                	jne    8010178f <cprintf+0x17f>
801017b5:	31 d2                	xor    %edx,%edx
      for (; *s; s++)
801017b7:	83 c3 01             	add    $0x1,%ebx
801017ba:	e8 c1 f6 ff ff       	call   80100e80 <consputc.part.0>
801017bf:	0f be 03             	movsbl (%ebx),%eax
801017c2:	84 c0                	test   %al,%al
801017c4:	75 bf                	jne    80101785 <cprintf+0x175>
      if ((s = (char *)*argp++) == 0)
801017c6:	89 f2                	mov    %esi,%edx
801017c8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801017cb:	89 fe                	mov    %edi,%esi
801017cd:	89 d1                	mov    %edx,%ecx
801017cf:	e9 a8 fe ff ff       	jmp    8010167c <cprintf+0x6c>
801017d4:	fa                   	cli
    for (;;)
801017d5:	eb fe                	jmp    801017d5 <cprintf+0x1c5>
801017d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017de:	00 
801017df:	90                   	nop
801017e0:	31 d2                	xor    %edx,%edx
801017e2:	b8 25 00 00 00       	mov    $0x25,%eax
801017e7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017ea:	e8 91 f6 ff ff       	call   80100e80 <consputc.part.0>
      break;
801017ef:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017f2:	e9 85 fe ff ff       	jmp    8010167c <cprintf+0x6c>
801017f7:	31 d2                	xor    %edx,%edx
801017f9:	89 f8                	mov    %edi,%eax
801017fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017fe:	e8 7d f6 ff ff       	call   80100e80 <consputc.part.0>
      break;
80101803:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101806:	e9 71 fe ff ff       	jmp    8010167c <cprintf+0x6c>
      if ((s = (char *)*argp++) == 0)
8010180b:	89 d1                	mov    %edx,%ecx
8010180d:	e9 6a fe ff ff       	jmp    8010167c <cprintf+0x6c>
    panic("null fmt");
80101812:	83 ec 0c             	sub    $0xc,%esp
80101815:	68 a8 a3 10 80       	push   $0x8010a3a8
8010181a:	e8 e1 f5 ff ff       	call   80100e00 <panic>
8010181f:	90                   	nop

80101820 <consoleintr>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	56                   	push   %esi
80101825:	53                   	push   %ebx
80101826:	83 ec 48             	sub    $0x48,%esp
80101829:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010182c:	68 e0 2a 11 80       	push   $0x80112ae0
80101831:	e8 da 51 00 00       	call   80106a10 <acquire>
  while ((c = getc()) >= 0)
80101836:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80101839:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  while ((c = getc()) >= 0)
80101840:	ff d7                	call   *%edi
80101842:	85 c0                	test   %eax,%eax
80101844:	0f 88 66 05 00 00    	js     80101db0 <consoleintr+0x590>
    switch (c)
8010184a:	83 f8 1a             	cmp    $0x1a,%eax
8010184d:	7f 11                	jg     80101860 <consoleintr+0x40>
8010184f:	85 c0                	test   %eax,%eax
80101851:	74 ed                	je     80101840 <consoleintr+0x20>
80101853:	83 f8 1a             	cmp    $0x1a,%eax
80101856:	77 28                	ja     80101880 <consoleintr+0x60>
80101858:	ff 24 85 a8 ab 10 80 	jmp    *-0x7fef5458(,%eax,4)
8010185f:	90                   	nop
80101860:	3d e4 00 00 00       	cmp    $0xe4,%eax
80101865:	74 59                	je     801018c0 <consoleintr+0xa0>
80101867:	3d e5 00 00 00       	cmp    $0xe5,%eax
8010186c:	0f 84 66 05 00 00    	je     80101dd8 <consoleintr+0x5b8>
80101872:	83 f8 7f             	cmp    $0x7f,%eax
80101875:	0f 84 8d 00 00 00    	je     80101908 <consoleintr+0xe8>
8010187b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101880:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
80101886:	8b 1d 38 2a 11 80    	mov    0x80112a38,%ebx
8010188c:	89 d6                	mov    %edx,%esi
8010188e:	09 de                	or     %ebx,%esi
80101890:	0f 88 1a 07 00 00    	js     80101fb0 <consoleintr+0x790>
80101896:	39 da                	cmp    %ebx,%edx
80101898:	0f 84 12 07 00 00    	je     80101fb0 <consoleintr+0x790>
        if (ch >= 32 && ch != 0x7f)
8010189e:	3c 1f                	cmp    $0x1f,%al
801018a0:	76 9e                	jbe    80101840 <consoleintr+0x20>
801018a2:	3c 7f                	cmp    $0x7f,%al
801018a4:	74 9a                	je     80101840 <consoleintr+0x20>
          char one[1] = {(char)ch};
801018a6:	88 45 e7             	mov    %al,-0x19(%ebp)
          replace_selection_with(one, 1); // handles delete+insert+redraw+deselect
801018a9:	ba 01 00 00 00       	mov    $0x1,%edx
801018ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
801018b1:	e8 4a fb ff ff       	call   80101400 <replace_selection_with>
801018b6:	eb 88                	jmp    80101840 <consoleintr+0x20>
801018b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018bf:	00 
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801018c0:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
801018c6:	8b 15 38 2a 11 80    	mov    0x80112a38,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801018cc:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801018d1:	89 ce                	mov    %ecx,%esi
801018d3:	09 d6                	or     %edx,%esi
801018d5:	78 08                	js     801018df <consoleintr+0xbf>
801018d7:	39 d1                	cmp    %edx,%ecx
801018d9:	0f 85 21 05 00 00    	jne    80101e00 <consoleintr+0x5e0>
      if (input.e > input.w)
801018df:	39 05 24 28 11 80    	cmp    %eax,0x80112824
801018e5:	0f 83 55 ff ff ff    	jae    80101840 <consoleintr+0x20>
  if (panicked)
801018eb:	8b 1d 58 2b 11 80    	mov    0x80112b58,%ebx
        input.e--;
801018f1:	83 e8 01             	sub    $0x1,%eax
801018f4:	a3 28 28 11 80       	mov    %eax,0x80112828
  if (panicked)
801018f9:	85 db                	test   %ebx,%ebx
801018fb:	0f 84 2d 09 00 00    	je     8010222e <consoleintr+0xa0e>
80101901:	fa                   	cli
    for (;;)
80101902:	eb fe                	jmp    80101902 <consoleintr+0xe2>
80101904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101908:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
      while (input.e != input.w &&
8010190e:	8b 0d 24 28 11 80    	mov    0x80112824,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101914:	8b 1d 28 28 11 80    	mov    0x80112828,%ebx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
8010191a:	85 d2                	test   %edx,%edx
8010191c:	0f 88 2e 05 00 00    	js     80101e50 <consoleintr+0x630>
80101922:	a1 38 2a 11 80       	mov    0x80112a38,%eax
80101927:	85 c0                	test   %eax,%eax
80101929:	0f 88 01 07 00 00    	js     80102030 <consoleintr+0x810>
8010192f:	39 c2                	cmp    %eax,%edx
80101931:	0f 84 f9 06 00 00    	je     80102030 <consoleintr+0x810>
        int old_len = (int)input.real_end - (int)input.w; // BEFORE delete
80101937:	8b 35 2c 28 11 80    	mov    0x8011282c,%esi
8010193d:	29 ce                	sub    %ecx,%esi
  if (a > b)
8010193f:	39 c2                	cmp    %eax,%edx
80101941:	7f 06                	jg     80101949 <consoleintr+0x129>
80101943:	89 c1                	mov    %eax,%ecx
  int a = input.sel_a, b = input.sel_b;
80101945:	89 d0                	mov    %edx,%eax
80101947:	89 ca                	mov    %ecx,%edx
80101949:	e8 f2 f3 ff ff       	call   80100d40 <delete_range.part.0>
        full_redraw_after_edit_len(old_e, old_len);
8010194e:	89 f2                	mov    %esi,%edx
80101950:	89 d8                	mov    %ebx,%eax
  input.sel_a = input.sel_b = -1;
80101952:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
80101959:	ff ff ff 
8010195c:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
80101963:	ff ff ff 
        full_redraw_after_edit_len(old_e, old_len);
80101966:	e8 55 f9 ff ff       	call   801012c0 <full_redraw_after_edit_len>
        break;
8010196b:	e9 d0 fe ff ff       	jmp    80101840 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101970:	8b 1d 38 2a 11 80    	mov    0x80112a38,%ebx
80101976:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
8010197c:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101981:	89 de                	mov    %ebx,%esi
80101983:	09 ce                	or     %ecx,%esi
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101985:	89 c2                	mov    %eax,%edx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101987:	78 08                	js     80101991 <consoleintr+0x171>
80101989:	39 cb                	cmp    %ecx,%ebx
8010198b:	0f 85 6f 04 00 00    	jne    80101e00 <consoleintr+0x5e0>
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101991:	3b 05 2c 28 11 80    	cmp    0x8011282c,%eax
80101997:	0f 83 a3 fe ff ff    	jae    80101840 <consoleintr+0x20>
8010199d:	83 e2 7f             	and    $0x7f,%edx
801019a0:	0f be 92 a0 27 11 80 	movsbl -0x7feed860(%edx),%edx
801019a7:	80 fa 0a             	cmp    $0xa,%dl
801019aa:	0f 84 c1 06 00 00    	je     80102071 <consoleintr+0x851>
801019b0:	80 fa 20             	cmp    $0x20,%dl
801019b3:	0f 84 b8 06 00 00    	je     80102071 <consoleintr+0x851>
  if (panicked)
801019b9:	a1 58 2b 11 80       	mov    0x80112b58,%eax
801019be:	85 c0                	test   %eax,%eax
801019c0:	0f 84 da 06 00 00    	je     801020a0 <consoleintr+0x880>
801019c6:	fa                   	cli
    for (;;)
801019c7:	eb fe                	jmp    801019c7 <consoleintr+0x1a7>
801019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
801019d0:	a1 34 2a 11 80       	mov    0x80112a34,%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	0f 88 63 fe ff ff    	js     80101840 <consoleintr+0x20>
801019dd:	8b 0d 38 2a 11 80    	mov    0x80112a38,%ecx
801019e3:	85 c9                	test   %ecx,%ecx
801019e5:	0f 88 55 fe ff ff    	js     80101840 <consoleintr+0x20>
801019eb:	39 c8                	cmp    %ecx,%eax
801019ed:	0f 84 4d fe ff ff    	je     80101840 <consoleintr+0x20>
  if (a > b)
801019f3:	0f 8f 97 09 00 00    	jg     80102390 <consoleintr+0xb70>
        int n = hi - lo;
801019f9:	89 cb                	mov    %ecx,%ebx
        if (n > INPUT_BUF)
801019fb:	ba 80 00 00 00       	mov    $0x80,%edx
  int a = input.sel_a, b = input.sel_b;
80101a00:	89 c1                	mov    %eax,%ecx
        int n = hi - lo;
80101a02:	29 c3                	sub    %eax,%ebx
        if (n > INPUT_BUF)
80101a04:	39 d3                	cmp    %edx,%ebx
80101a06:	0f 4f da             	cmovg  %edx,%ebx
  int a = input.sel_a, b = input.sel_b;
80101a09:	31 c0                	xor    %eax,%eax
80101a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
80101a10:	8d 14 01             	lea    (%ecx,%eax,1),%edx
        for (int i = 0; i < n; ++i)
80101a13:	83 c0 01             	add    $0x1,%eax
          input.clip[i] = input.buf[(lo + i) % INPUT_BUF];
80101a16:	83 e2 7f             	and    $0x7f,%edx
80101a19:	0f b6 92 a0 27 11 80 	movzbl -0x7feed860(%edx),%edx
80101a20:	88 90 3b 2a 11 80    	mov    %dl,-0x7feed5c5(%eax)
        for (int i = 0; i < n; ++i)
80101a26:	39 d8                	cmp    %ebx,%eax
80101a28:	7c e6                	jl     80101a10 <consoleintr+0x1f0>
        input.clip_len = n;
80101a2a:	89 1d c0 2a 11 80    	mov    %ebx,0x80112ac0
80101a30:	e9 0b fe ff ff       	jmp    80101840 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101a35:	8b 1d 38 2a 11 80    	mov    0x80112a38,%ebx
80101a3b:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101a41:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101a46:	89 de                	mov    %ebx,%esi
80101a48:	09 ce                	or     %ecx,%esi
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101a4a:	89 c2                	mov    %eax,%edx
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101a4c:	78 08                	js     80101a56 <consoleintr+0x236>
80101a4e:	39 cb                	cmp    %ecx,%ebx
80101a50:	0f 85 aa 03 00 00    	jne    80101e00 <consoleintr+0x5e0>
      if (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] == ' ')
80101a56:	85 c0                	test   %eax,%eax
80101a58:	0f 84 e2 fd ff ff    	je     80101840 <consoleintr+0x20>
80101a5e:	8d 48 ff             	lea    -0x1(%eax),%ecx
80101a61:	83 e1 7f             	and    $0x7f,%ecx
80101a64:	80 b9 a0 27 11 80 20 	cmpb   $0x20,-0x7feed860(%ecx)
80101a6b:	0f 84 43 09 00 00    	je     801023b4 <consoleintr+0xb94>
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
80101a71:	83 e2 7f             	and    $0x7f,%edx
80101a74:	80 ba a0 27 11 80 20 	cmpb   $0x20,-0x7feed860(%edx)
80101a7b:	0f 85 c7 08 00 00    	jne    80102348 <consoleintr+0xb28>
  if (panicked)
80101a81:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
80101a87:	85 c9                	test   %ecx,%ecx
80101a89:	0f 84 8f 03 00 00    	je     80101e1e <consoleintr+0x5fe>
80101a8f:	fa                   	cli
    for (;;)
80101a90:	eb fe                	jmp    80101a90 <consoleintr+0x270>
80101a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101a98:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
80101a9e:	a1 38 2a 11 80       	mov    0x80112a38,%eax
80101aa3:	89 ce                	mov    %ecx,%esi
80101aa5:	09 c6                	or     %eax,%esi
80101aa7:	78 08                	js     80101ab1 <consoleintr+0x291>
80101aa9:	39 c1                	cmp    %eax,%ecx
80101aab:	0f 85 49 02 00 00    	jne    80101cfa <consoleintr+0x4da>
      if (input.real_end > input.w)
80101ab1:	8b 1d 2c 28 11 80    	mov    0x8011282c,%ebx
80101ab7:	8b 15 24 28 11 80    	mov    0x80112824,%edx
80101abd:	39 da                	cmp    %ebx,%edx
80101abf:	0f 83 7b fd ff ff    	jae    80101840 <consoleintr+0x20>
        int max_t = -1, idx = -1;
80101ac5:	89 55 d0             	mov    %edx,-0x30(%ebp)
        for (uint i = input.w; i < input.real_end; i++)
80101ac8:	89 d0                	mov    %edx,%eax
        int max_t = -1, idx = -1;
80101aca:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101acf:	89 4d c8             	mov    %ecx,-0x38(%ebp)
80101ad2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ade:	00 
80101adf:	90                   	nop
          int t = input.insert_order[i % INPUT_BUF];
80101ae0:	89 c2                	mov    %eax,%edx
80101ae2:	83 e2 7f             	and    $0x7f,%edx
80101ae5:	8b 14 95 30 28 11 80 	mov    -0x7feed7d0(,%edx,4),%edx
          if (t > max_t)
80101aec:	39 f2                	cmp    %esi,%edx
80101aee:	7e 04                	jle    80101af4 <consoleintr+0x2d4>
            idx = (int)i;
80101af0:	89 c1                	mov    %eax,%ecx
            max_t = t;
80101af2:	89 d6                	mov    %edx,%esi
        for (uint i = input.w; i < input.real_end; i++)
80101af4:	83 c0 01             	add    $0x1,%eax
80101af7:	39 c3                	cmp    %eax,%ebx
80101af9:	75 e5                	jne    80101ae0 <consoleintr+0x2c0>
        if (idx >= 0)
80101afb:	89 c8                	mov    %ecx,%eax
80101afd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80101b00:	8b 55 d0             	mov    -0x30(%ebp),%edx
80101b03:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80101b06:	85 c0                	test   %eax,%eax
80101b08:	0f 88 32 fd ff ff    	js     80101840 <consoleintr+0x20>
          int old_e = (int)input.e;
80101b0e:	a1 28 28 11 80       	mov    0x80112828,%eax
80101b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101b16:	89 45 c0             	mov    %eax,-0x40(%ebp)
          for (int i = idx; i < old_real_end - 1; i++)
80101b19:	8d 43 ff             	lea    -0x1(%ebx),%eax
80101b1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
80101b1f:	89 c6                	mov    %eax,%esi
80101b21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80101b24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80101b27:	39 75 cc             	cmp    %esi,-0x34(%ebp)
80101b2a:	7d 44                	jge    80101b70 <consoleintr+0x350>
80101b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80101b2f:	8b 75 c8             	mov    -0x38(%ebp),%esi
80101b32:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80101b35:	89 55 b8             	mov    %edx,-0x48(%ebp)
80101b38:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101b3b:	89 c2                	mov    %eax,%edx
80101b3d:	83 c0 01             	add    $0x1,%eax
80101b40:	89 c3                	mov    %eax,%ebx
80101b42:	83 e2 7f             	and    $0x7f,%edx
80101b45:	83 e3 7f             	and    $0x7f,%ebx
80101b48:	0f b6 8b a0 27 11 80 	movzbl -0x7feed860(%ebx),%ecx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101b4f:	8b 1c 9d 30 28 11 80 	mov    -0x7feed7d0(,%ebx,4),%ebx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101b56:	88 8a a0 27 11 80    	mov    %cl,-0x7feed860(%edx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101b5c:	89 1c 95 30 28 11 80 	mov    %ebx,-0x7feed7d0(,%edx,4)
          for (int i = idx; i < old_real_end - 1; i++)
80101b63:	39 f0                	cmp    %esi,%eax
80101b65:	75 d4                	jne    80101b3b <consoleintr+0x31b>
80101b67:	8b 5d bc             	mov    -0x44(%ebp),%ebx
80101b6a:	8b 55 b8             	mov    -0x48(%ebp),%edx
80101b6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
          input.real_end--;
80101b70:	8b 45 c8             	mov    -0x38(%ebp),%eax
          if ((int)input.e > idx)
80101b73:	8b 75 d0             	mov    -0x30(%ebp),%esi
          input.real_end--;
80101b76:	a3 2c 28 11 80       	mov    %eax,0x8011282c
          if ((int)input.e > idx)
80101b7b:	39 75 cc             	cmp    %esi,-0x34(%ebp)
80101b7e:	7d 0c                	jge    80101b8c <consoleintr+0x36c>
            input.e--;
80101b80:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
80101b84:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101b87:	a3 28 28 11 80       	mov    %eax,0x80112828
          if (idx <= input.sel_a && input.sel_a >= 0)
80101b8c:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
80101b8f:	7f 12                	jg     80101ba3 <consoleintr+0x383>
            input.sel_a--; // Adjust the selection anchor to reflect the removed character
80101b91:	8d 41 ff             	lea    -0x1(%ecx),%eax
80101b94:	85 c9                	test   %ecx,%ecx
80101b96:	b9 00 00 00 00       	mov    $0x0,%ecx
80101b9b:	0f 44 c1             	cmove  %ecx,%eax
80101b9e:	a3 34 2a 11 80       	mov    %eax,0x80112a34
          if (input.e < input.w)
80101ba3:	39 55 d0             	cmp    %edx,-0x30(%ebp)
80101ba6:	73 09                	jae    80101bb1 <consoleintr+0x391>
            input.e = input.w;
80101ba8:	89 15 28 28 11 80    	mov    %edx,0x80112828
80101bae:	89 55 d0             	mov    %edx,-0x30(%ebp)
          if (input.e > input.real_end)
80101bb1:	8b 45 c8             	mov    -0x38(%ebp),%eax
80101bb4:	8b 75 d0             	mov    -0x30(%ebp),%esi
80101bb7:	39 f0                	cmp    %esi,%eax
80101bb9:	73 08                	jae    80101bc3 <consoleintr+0x3a3>
            input.e = input.real_end;
80101bbb:	a3 28 28 11 80       	mov    %eax,0x80112828
80101bc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
          int old_cursor_off = old_e - (int)input.w;
80101bc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
          if (old_cursor_off < 0)
80101bc6:	31 f6                	xor    %esi,%esi
          for (int i = 0; i < old_cursor_off; i++)
80101bc8:	b9 00 00 00 00       	mov    $0x0,%ecx
          int old_cursor_off = old_e - (int)input.w;
80101bcd:	29 d0                	sub    %edx,%eax
          if (old_cursor_off < 0)
80101bcf:	85 c0                	test   %eax,%eax
80101bd1:	0f 49 f0             	cmovns %eax,%esi
          for (int i = 0; i < old_cursor_off; i++)
80101bd4:	0f 8e 24 08 00 00    	jle    801023fe <consoleintr+0xbde>
80101bda:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80101bdd:	89 cb                	mov    %ecx,%ebx
80101bdf:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80101be2:	89 d7                	mov    %edx,%edi
  if (panicked)
80101be4:	a1 58 2b 11 80       	mov    0x80112b58,%eax
80101be9:	85 c0                	test   %eax,%eax
80101beb:	0f 84 ee 07 00 00    	je     801023df <consoleintr+0xbbf>
80101bf1:	fa                   	cli
    for (;;)
80101bf2:	eb fe                	jmp    80101bf2 <consoleintr+0x3d2>
80101bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (input.clip_len <= 0)
80101bf8:	8b 0d c0 2a 11 80    	mov    0x80112ac0,%ecx
80101bfe:	85 c9                	test   %ecx,%ecx
80101c00:	0f 8e 3a fc ff ff    	jle    80101840 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101c06:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
80101c0c:	a1 38 2a 11 80       	mov    0x80112a38,%eax
80101c11:	89 d6                	mov    %edx,%esi
80101c13:	09 c6                	or     %eax,%esi
80101c15:	0f 88 31 03 00 00    	js     80101f4c <consoleintr+0x72c>
80101c1b:	39 c2                	cmp    %eax,%edx
80101c1d:	0f 84 29 03 00 00    	je     80101f4c <consoleintr+0x72c>
        replace_selection_with(input.clip, input.clip_len);
80101c23:	89 ca                	mov    %ecx,%edx
80101c25:	b8 3c 2a 11 80       	mov    $0x80112a3c,%eax
80101c2a:	e8 d1 f7 ff ff       	call   80101400 <replace_selection_with>
80101c2f:	e9 0c fc ff ff       	jmp    80101840 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101c34:	8b 0d 38 2a 11 80    	mov    0x80112a38,%ecx
80101c3a:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101c40:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101c45:	89 ce                	mov    %ecx,%esi
80101c47:	09 d6                	or     %edx,%esi
80101c49:	78 08                	js     80101c53 <consoleintr+0x433>
80101c4b:	39 d1                	cmp    %edx,%ecx
80101c4d:	0f 85 ad 01 00 00    	jne    80101e00 <consoleintr+0x5e0>
      while (input.e != input.w &&
80101c53:	39 05 24 28 11 80    	cmp    %eax,0x80112824
80101c59:	0f 84 8e 04 00 00    	je     801020ed <consoleintr+0x8cd>
             input.buf[(input.e - 1) % INPUT_BUF] != '\n')
80101c5f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c62:	89 d1                	mov    %edx,%ecx
80101c64:	83 e1 7f             	and    $0x7f,%ecx
      while (input.e != input.w &&
80101c67:	80 b9 a0 27 11 80 0a 	cmpb   $0xa,-0x7feed860(%ecx)
80101c6e:	0f 84 79 04 00 00    	je     801020ed <consoleintr+0x8cd>
  if (panicked)
80101c74:	a1 58 2b 11 80       	mov    0x80112b58,%eax
        input.e--;
80101c79:	89 15 28 28 11 80    	mov    %edx,0x80112828
  if (panicked)
80101c7f:	85 c0                	test   %eax,%eax
80101c81:	0f 84 49 04 00 00    	je     801020d0 <consoleintr+0x8b0>
80101c87:	fa                   	cli
    for (;;)
80101c88:	eb fe                	jmp    80101c88 <consoleintr+0x468>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101c90:	8b 1d 34 2a 11 80    	mov    0x80112a34,%ebx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101c96:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101c9b:	85 db                	test   %ebx,%ebx
80101c9d:	0f 88 65 02 00 00    	js     80101f08 <consoleintr+0x6e8>
80101ca3:	8b 15 38 2a 11 80    	mov    0x80112a38,%edx
80101ca9:	39 d3                	cmp    %edx,%ebx
80101cab:	74 08                	je     80101cb5 <consoleintr+0x495>
80101cad:	85 d2                	test   %edx,%edx
80101caf:	0f 89 4b 01 00 00    	jns    80101e00 <consoleintr+0x5e0>
      input.sel_b = (int)input.e; // 2nd Ctrl+S → set active end
80101cb5:	a3 38 2a 11 80       	mov    %eax,0x80112a38
80101cba:	89 c6                	mov    %eax,%esi
      if (input.sel_b == input.sel_a)
80101cbc:	39 d8                	cmp    %ebx,%eax
80101cbe:	0f 85 bc 04 00 00    	jne    80102180 <consoleintr+0x960>
  input.sel_a = input.sel_b = -1;
80101cc4:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
80101ccb:	ff ff ff 
80101cce:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
80101cd5:	ff ff ff 
}
80101cd8:	e9 63 fb ff ff       	jmp    80101840 <consoleintr+0x20>
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101cdd:	8b 15 38 2a 11 80    	mov    0x80112a38,%edx
80101ce3:	a1 34 2a 11 80       	mov    0x80112a34,%eax
80101ce8:	89 d6                	mov    %edx,%esi
80101cea:	09 c6                	or     %eax,%esi
80101cec:	0f 88 4e 02 00 00    	js     80101f40 <consoleintr+0x720>
80101cf2:	39 c2                	cmp    %eax,%edx
80101cf4:	0f 84 46 02 00 00    	je     80101f40 <consoleintr+0x720>
  full_redraw_after_edit(old_e);
80101cfa:	a1 28 28 11 80       	mov    0x80112828,%eax
  input.sel_a = input.sel_b = -1;
80101cff:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
80101d06:	ff ff ff 
80101d09:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
80101d10:	ff ff ff 
  full_redraw_after_edit(old_e);
80101d13:	e8 68 f4 ff ff       	call   80101180 <full_redraw_after_edit>
}
80101d18:	e9 23 fb ff ff       	jmp    80101840 <consoleintr+0x20>
      input.temp_e = input.e;
80101d1d:	a1 28 28 11 80       	mov    0x80112828,%eax
      wakeup(&input.r);
80101d22:	83 ec 0c             	sub    $0xc,%esp
      input.temp_r = input.r;
80101d25:	8b 15 24 28 11 80    	mov    0x80112824,%edx
      input.is_tab_mode = 1;
80101d2b:	c7 05 bc 2a 11 80 01 	movl   $0x1,0x80112abc
80101d32:	00 00 00 
      input.buf[input.e++ % INPUT_BUF] = '\t';
80101d35:	8d 48 01             	lea    0x1(%eax),%ecx
      input.temp_e = input.e;
80101d38:	a3 d0 2a 11 80       	mov    %eax,0x80112ad0
      input.buf[input.e++ % INPUT_BUF] = '\t';
80101d3d:	83 e0 7f             	and    $0x7f,%eax
80101d40:	c6 80 a0 27 11 80 09 	movb   $0x9,-0x7feed860(%eax)
      input.temp_r = input.r;
80101d47:	a1 20 28 11 80       	mov    0x80112820,%eax
80101d4c:	89 15 c8 2a 11 80    	mov    %edx,0x80112ac8
80101d52:	a3 c4 2a 11 80       	mov    %eax,0x80112ac4
      input.temp_real_end = input.real_end;
80101d57:	a1 2c 28 11 80       	mov    0x8011282c,%eax
      input.buf[input.e++ % INPUT_BUF] = '\t';
80101d5c:	89 0d 28 28 11 80    	mov    %ecx,0x80112828
      input.temp_real_end = input.real_end;
80101d62:	a3 cc 2a 11 80       	mov    %eax,0x80112acc
      input.w = input.e;
80101d67:	89 0d 24 28 11 80    	mov    %ecx,0x80112824
      wakeup(&input.r);
80101d6d:	68 20 28 11 80       	push   $0x80112820
80101d72:	e8 c9 42 00 00       	call   80106040 <wakeup>
      input.buf[input.e % INPUT_BUF] = '\0';
80101d77:	a1 28 28 11 80       	mov    0x80112828,%eax
      break;
80101d7c:	83 c4 10             	add    $0x10,%esp
      input.buf[input.e % INPUT_BUF] = '\0';
80101d7f:	89 c2                	mov    %eax,%edx
      input.e--;
80101d81:	83 e8 01             	sub    $0x1,%eax
80101d84:	a3 28 28 11 80       	mov    %eax,0x80112828
      input.real_end = input.temp_real_end;
80101d89:	a1 cc 2a 11 80       	mov    0x80112acc,%eax
      input.buf[input.e % INPUT_BUF] = '\0';
80101d8e:	83 e2 7f             	and    $0x7f,%edx
80101d91:	c6 82 a0 27 11 80 00 	movb   $0x0,-0x7feed860(%edx)
      input.real_end = input.temp_real_end;
80101d98:	a3 2c 28 11 80       	mov    %eax,0x8011282c
  while ((c = getc()) >= 0)
80101d9d:	ff d7                	call   *%edi
80101d9f:	85 c0                	test   %eax,%eax
80101da1:	0f 89 a3 fa ff ff    	jns    8010184a <consoleintr+0x2a>
80101da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101dae:	00 
80101daf:	90                   	nop
  release(&cons.lock);
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	68 e0 2a 11 80       	push   $0x80112ae0
80101db8:	e8 f3 4b 00 00       	call   801069b0 <release>
  if (doprocdump)
80101dbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101dc0:	83 c4 10             	add    $0x10,%esp
80101dc3:	85 c0                	test   %eax,%eax
80101dc5:	0f 85 36 03 00 00    	jne    80102101 <consoleintr+0x8e1>
}
80101dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dce:	5b                   	pop    %ebx
80101dcf:	5e                   	pop    %esi
80101dd0:	5f                   	pop    %edi
80101dd1:	5d                   	pop    %ebp
80101dd2:	c3                   	ret
80101dd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101dd8:	8b 0d 34 2a 11 80    	mov    0x80112a34,%ecx
80101dde:	8b 15 38 2a 11 80    	mov    0x80112a38,%edx
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80101de4:	a1 28 28 11 80       	mov    0x80112828,%eax
  return (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b);
80101de9:	89 ce                	mov    %ecx,%esi
80101deb:	09 d6                	or     %edx,%esi
80101ded:	0f 88 1f 01 00 00    	js     80101f12 <consoleintr+0x6f2>
80101df3:	39 d1                	cmp    %edx,%ecx
80101df5:	0f 84 17 01 00 00    	je     80101f12 <consoleintr+0x6f2>
80101dfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  input.sel_a = input.sel_b = -1;
80101e00:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
80101e07:	ff ff ff 
80101e0a:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
80101e11:	ff ff ff 
        full_redraw_after_edit(old_e); // remove highlight
80101e14:	e8 67 f3 ff ff       	call   80101180 <full_redraw_after_edit>
        break;
80101e19:	e9 22 fa ff ff       	jmp    80101840 <consoleintr+0x20>
80101e1e:	31 d2                	xor    %edx,%edx
80101e20:	b8 e4 00 00 00       	mov    $0xe4,%eax
80101e25:	e8 56 f0 ff ff       	call   80100e80 <consputc.part.0>
        input.e--;
80101e2a:	a1 28 28 11 80       	mov    0x80112828,%eax
80101e2f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101e32:	89 15 28 28 11 80    	mov    %edx,0x80112828
80101e38:	89 d0                	mov    %edx,%eax
      while (input.e > 0 && input.buf[input.e % INPUT_BUF] == ' ')
80101e3a:	85 d2                	test   %edx,%edx
80101e3c:	0f 85 2f fc ff ff    	jne    80101a71 <consoleintr+0x251>
80101e42:	e9 f9 f9 ff ff       	jmp    80101840 <consoleintr+0x20>
80101e47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e4e:	00 
80101e4f:	90                   	nop
      if (input.e != input.w)
80101e50:	39 d9                	cmp    %ebx,%ecx
80101e52:	0f 84 e8 f9 ff ff    	je     80101840 <consoleintr+0x20>
        if (input.e == input.real_end)
80101e58:	a1 2c 28 11 80       	mov    0x8011282c,%eax
          input.e--;
80101e5d:	8d 53 ff             	lea    -0x1(%ebx),%edx
80101e60:	89 15 28 28 11 80    	mov    %edx,0x80112828
        if (input.e == input.real_end)
80101e66:	89 45 d0             	mov    %eax,-0x30(%ebp)
80101e69:	39 d8                	cmp    %ebx,%eax
80101e6b:	0f 84 ff 03 00 00    	je     80102270 <consoleintr+0xa50>
          for (uint i = input.e; i < input.real_end - 1; i++)
80101e71:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101e74:	8d 70 ff             	lea    -0x1(%eax),%esi
80101e77:	89 d0                	mov    %edx,%eax
80101e79:	39 f2                	cmp    %esi,%edx
80101e7b:	73 48                	jae    80101ec5 <consoleintr+0x6a5>
80101e7d:	89 55 cc             	mov    %edx,-0x34(%ebp)
80101e80:	89 4d c8             	mov    %ecx,-0x38(%ebp)
80101e83:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
80101e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e8d:	00 
80101e8e:	66 90                	xchg   %ax,%ax
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101e90:	89 c2                	mov    %eax,%edx
80101e92:	83 c0 01             	add    $0x1,%eax
80101e95:	89 c1                	mov    %eax,%ecx
80101e97:	83 e2 7f             	and    $0x7f,%edx
80101e9a:	83 e1 7f             	and    $0x7f,%ecx
80101e9d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101ea4:	8b 0c 8d 30 28 11 80 	mov    -0x7feed7d0(,%ecx,4),%ecx
            input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101eab:	88 9a a0 27 11 80    	mov    %bl,-0x7feed860(%edx)
            input.insert_order[i % INPUT_BUF] = input.insert_order[(i + 1) % INPUT_BUF];
80101eb1:	89 0c 95 30 28 11 80 	mov    %ecx,-0x7feed7d0(,%edx,4)
          for (uint i = input.e; i < input.real_end - 1; i++)
80101eb8:	39 f0                	cmp    %esi,%eax
80101eba:	75 d4                	jne    80101e90 <consoleintr+0x670>
80101ebc:	8b 55 cc             	mov    -0x34(%ebp),%edx
80101ebf:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80101ec2:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
          input.real_end--;
80101ec5:	89 35 2c 28 11 80    	mov    %esi,0x8011282c
          if (input.e > input.real_end)
80101ecb:	39 d6                	cmp    %edx,%esi
80101ecd:	0f 82 ed 02 00 00    	jb     801021c0 <consoleintr+0x9a0>
          int old_cursor_off = old_e - (int)input.w;
80101ed3:	89 d8                	mov    %ebx,%eax
          if (old_cursor_off < 0)
80101ed5:	31 db                	xor    %ebx,%ebx
          int old_cursor_off = old_e - (int)input.w;
80101ed7:	29 c8                	sub    %ecx,%eax
          if (old_cursor_off < 0)
80101ed9:	85 c0                	test   %eax,%eax
80101edb:	0f 49 d8             	cmovns %eax,%ebx
80101ede:	89 5d cc             	mov    %ebx,-0x34(%ebp)
          for (int i = 0; i < old_cursor_off; i++)
80101ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ee6:	0f 8e 3f 02 00 00    	jle    8010212b <consoleintr+0x90b>
80101eec:	89 55 c8             	mov    %edx,-0x38(%ebp)
80101eef:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  if (panicked)
80101ef2:	a1 58 2b 11 80       	mov    0x80112b58,%eax
80101ef7:	85 c0                	test   %eax,%eax
80101ef9:	0f 84 0e 02 00 00    	je     8010210d <consoleintr+0x8ed>
80101eff:	fa                   	cli
    for (;;)
80101f00:	eb fe                	jmp    80101f00 <consoleintr+0x6e0>
80101f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.sel_a = (int)input.e;
80101f08:	a3 34 2a 11 80       	mov    %eax,0x80112a34
        break;
80101f0d:	e9 2e f9 ff ff       	jmp    80101840 <consoleintr+0x20>
      if (input.e < input.real_end)
80101f12:	3b 05 2c 28 11 80    	cmp    0x8011282c,%eax
80101f18:	0f 83 22 f9 ff ff    	jae    80101840 <consoleintr+0x20>
  if (panicked)
80101f1e:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
        char ch = input.buf[input.e % INPUT_BUF];
80101f24:	83 e0 7f             	and    $0x7f,%eax
80101f27:	0f be 90 a0 27 11 80 	movsbl -0x7feed860(%eax),%edx
  if (panicked)
80101f2e:	85 c9                	test   %ecx,%ecx
80101f30:	0f 84 e2 02 00 00    	je     80102218 <consoleintr+0x9f8>
80101f36:	fa                   	cli
    for (;;)
80101f37:	eb fe                	jmp    80101f37 <consoleintr+0x717>
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80101f40:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
80101f47:	e9 f4 f8 ff ff       	jmp    80101840 <consoleintr+0x20>
        int old_len = (int)input.real_end - (int)input.w;
80101f4c:	a1 24 28 11 80       	mov    0x80112824,%eax
        uint old_e = input.e;
80101f51:	8b 1d 28 28 11 80    	mov    0x80112828,%ebx
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
80101f57:	ba 3c 2a 11 80       	mov    $0x80112a3c,%edx
        int old_len = (int)input.real_end - (int)input.w;
80101f5c:	8b 35 2c 28 11 80    	mov    0x8011282c,%esi
80101f62:	89 45 d0             	mov    %eax,-0x30(%ebp)
        int wrote = insert_at((int)input.e, input.clip, input.clip_len);
80101f65:	89 d8                	mov    %ebx,%eax
80101f67:	e8 c4 eb ff ff       	call   80100b30 <insert_at>
80101f6c:	89 c1                	mov    %eax,%ecx
        if (wrote <= 0)
80101f6e:	85 c0                	test   %eax,%eax
80101f70:	0f 8e ca f8 ff ff    	jle    80101840 <consoleintr+0x20>
        if (input.sel_a >= 0 && input.sel_a > old_e)
80101f76:	a1 34 2a 11 80       	mov    0x80112a34,%eax
80101f7b:	85 c0                	test   %eax,%eax
80101f7d:	78 16                	js     80101f95 <consoleintr+0x775>
80101f7f:	39 c3                	cmp    %eax,%ebx
80101f81:	73 12                	jae    80101f95 <consoleintr+0x775>
            input.sel_a = input.real_end;
80101f83:	8b 15 2c 28 11 80    	mov    0x8011282c,%edx
          if (input.sel_a > input.real_end) // Don't go beyond buffer limits
80101f89:	01 c8                	add    %ecx,%eax
            input.sel_a = input.real_end;
80101f8b:	39 d0                	cmp    %edx,%eax
80101f8d:	0f 47 c2             	cmova  %edx,%eax
80101f90:	a3 34 2a 11 80       	mov    %eax,0x80112a34
        if (!was_end)
80101f95:	39 de                	cmp    %ebx,%esi
80101f97:	0f 84 a2 02 00 00    	je     8010223f <consoleintr+0xa1f>
        int old_len = (int)input.real_end - (int)input.w;
80101f9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101fa0:	29 c6                	sub    %eax,%esi
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
80101fa2:	89 d8                	mov    %ebx,%eax
        int old_len = (int)input.real_end - (int)input.w;
80101fa4:	89 f2                	mov    %esi,%edx
          full_redraw_after_edit_len(old_e, old_len); // content after caret shifted
80101fa6:	e8 15 f3 ff ff       	call   801012c0 <full_redraw_after_edit_len>
80101fab:	e9 90 f8 ff ff       	jmp    80101840 <consoleintr+0x20>
      if (input.e < input.real_end)
80101fb0:	8b 35 28 28 11 80    	mov    0x80112828,%esi
80101fb6:	8b 1d 2c 28 11 80    	mov    0x8011282c,%ebx
80101fbc:	39 de                	cmp    %ebx,%esi
80101fbe:	0f 82 09 02 00 00    	jb     801021cd <consoleintr+0x9ad>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
80101fc4:	89 da                	mov    %ebx,%edx
80101fc6:	2b 15 20 28 11 80    	sub    0x80112820,%edx
80101fcc:	83 fa 7f             	cmp    $0x7f,%edx
80101fcf:	0f 87 6b f8 ff ff    	ja     80101840 <consoleintr+0x20>
          char one[1] = {(char)ch};
80101fd5:	89 c1                	mov    %eax,%ecx
          c = (c == '\r') ? '\n' : c;
80101fd7:	83 f8 0d             	cmp    $0xd,%eax
80101fda:	75 0a                	jne    80101fe6 <consoleintr+0x7c6>
80101fdc:	b9 0a 00 00 00       	mov    $0xa,%ecx
80101fe1:	b8 0a 00 00 00       	mov    $0xa,%eax
          input.buf[input.e++ % INPUT_BUF] = c;
80101fe6:	8d 56 01             	lea    0x1(%esi),%edx
80101fe9:	83 e6 7f             	and    $0x7f,%esi
80101fec:	88 8e a0 27 11 80    	mov    %cl,-0x7feed860(%esi)
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101ff2:	8b 0d 30 2a 11 80    	mov    0x80112a30,%ecx
          input.buf[input.e++ % INPUT_BUF] = c;
80101ff8:	89 15 28 28 11 80    	mov    %edx,0x80112828
          input.insert_order[(input.e - 1) % INPUT_BUF] = ++input.current_time;
80101ffe:	83 c1 01             	add    $0x1,%ecx
80102001:	89 0d 30 2a 11 80    	mov    %ecx,0x80112a30
80102007:	89 0c b5 30 28 11 80 	mov    %ecx,-0x7feed7d0(,%esi,4)
          if (input.e > input.real_end)
8010200e:	39 d3                	cmp    %edx,%ebx
80102010:	73 06                	jae    80102018 <consoleintr+0x7f8>
            input.real_end = input.e;
80102012:	89 15 2c 28 11 80    	mov    %edx,0x8011282c
  if (panicked)
80102018:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
8010201e:	85 d2                	test   %edx,%edx
80102020:	0f 84 5a 04 00 00    	je     80102480 <consoleintr+0xc60>
80102026:	fa                   	cli
    for (;;)
80102027:	eb fe                	jmp    80102027 <consoleintr+0x807>
80102029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.e != input.w)
80102030:	39 d9                	cmp    %ebx,%ecx
80102032:	0f 84 08 f8 ff ff    	je     80101840 <consoleintr+0x20>
        if ((input.sel_a >= input.e) && input.sel_a >= 0)
80102038:	39 da                	cmp    %ebx,%edx
8010203a:	0f 82 18 fe ff ff    	jb     80101e58 <consoleintr+0x638>
          input.sel_a--;
80102040:	8d 42 ff             	lea    -0x1(%edx),%eax
          if (input.sel_a < 0)
80102043:	85 d2                	test   %edx,%edx
80102045:	0f 84 0d fe ff ff    	je     80101e58 <consoleintr+0x638>
          input.sel_a--;
8010204b:	a3 34 2a 11 80       	mov    %eax,0x80112a34
80102050:	e9 03 fe ff ff       	jmp    80101e58 <consoleintr+0x638>
80102055:	b8 e5 00 00 00       	mov    $0xe5,%eax
8010205a:	ba 20 00 00 00       	mov    $0x20,%edx
8010205f:	e8 1c ee ff ff       	call   80100e80 <consputc.part.0>
        input.e++;
80102064:	a1 28 28 11 80       	mov    0x80112828,%eax
80102069:	83 c0 01             	add    $0x1,%eax
8010206c:	a3 28 28 11 80       	mov    %eax,0x80112828
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] == ' ' && input.buf[input.e % INPUT_BUF] != '\n')
80102071:	3b 05 2c 28 11 80    	cmp    0x8011282c,%eax
80102077:	0f 83 c3 f7 ff ff    	jae    80101840 <consoleintr+0x20>
8010207d:	83 e0 7f             	and    $0x7f,%eax
80102080:	80 b8 a0 27 11 80 20 	cmpb   $0x20,-0x7feed860(%eax)
80102087:	0f 85 b3 f7 ff ff    	jne    80101840 <consoleintr+0x20>
  if (panicked)
8010208d:	8b 35 58 2b 11 80    	mov    0x80112b58,%esi
80102093:	85 f6                	test   %esi,%esi
80102095:	74 be                	je     80102055 <consoleintr+0x835>
80102097:	fa                   	cli
    for (;;)
80102098:	eb fe                	jmp    80102098 <consoleintr+0x878>
8010209a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020a0:	b8 e5 00 00 00       	mov    $0xe5,%eax
801020a5:	e8 d6 ed ff ff       	call   80100e80 <consputc.part.0>
        input.e++;
801020aa:	a1 28 28 11 80       	mov    0x80112828,%eax
801020af:	8d 50 01             	lea    0x1(%eax),%edx
801020b2:	89 15 28 28 11 80    	mov    %edx,0x80112828
801020b8:	89 d0                	mov    %edx,%eax
      while (input.e < input.real_end && input.buf[input.e % INPUT_BUF] != ' ' && input.buf[input.e % INPUT_BUF] != '\n')
801020ba:	3b 15 2c 28 11 80    	cmp    0x8011282c,%edx
801020c0:	0f 82 d7 f8 ff ff    	jb     8010199d <consoleintr+0x17d>
801020c6:	e9 75 f7 ff ff       	jmp    80101840 <consoleintr+0x20>
801020cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801020d0:	b8 00 01 00 00       	mov    $0x100,%eax
801020d5:	31 d2                	xor    %edx,%edx
801020d7:	e8 a4 ed ff ff       	call   80100e80 <consputc.part.0>
      while (input.e != input.w &&
801020dc:	a1 28 28 11 80       	mov    0x80112828,%eax
801020e1:	3b 05 24 28 11 80    	cmp    0x80112824,%eax
801020e7:	0f 85 72 fb ff ff    	jne    80101c5f <consoleintr+0x43f>
      input.real_end = input.e;
801020ed:	a3 2c 28 11 80       	mov    %eax,0x8011282c
      input.current_time = 0;
801020f2:	c7 05 30 2a 11 80 00 	movl   $0x0,0x80112a30
801020f9:	00 00 00 
      break;
801020fc:	e9 3f f7 ff ff       	jmp    80101840 <consoleintr+0x20>
}
80102101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102104:	5b                   	pop    %ebx
80102105:	5e                   	pop    %esi
80102106:	5f                   	pop    %edi
80102107:	5d                   	pop    %ebp
    procdump();
80102108:	e9 13 40 00 00       	jmp    80106120 <procdump>
8010210d:	31 d2                	xor    %edx,%edx
8010210f:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++)
80102114:	83 c3 01             	add    $0x1,%ebx
80102117:	e8 64 ed ff ff       	call   80100e80 <consputc.part.0>
8010211c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
8010211f:	0f 8f cd fd ff ff    	jg     80101ef2 <consoleintr+0x6d2>
80102125:	8b 55 c8             	mov    -0x38(%ebp),%edx
80102128:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
          int old_len = old_real_end - (int)input.w;
8010212b:	8b 45 d0             	mov    -0x30(%ebp),%eax
          if (old_len < 0)
8010212e:	bb 00 00 00 00       	mov    $0x0,%ebx
          for (int i = 0; i < min_int(old_len, 80); i++)
80102133:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
          int old_len = old_real_end - (int)input.w;
8010213a:	29 c8                	sub    %ecx,%eax
          if (old_len < 0)
8010213c:	0f 49 d8             	cmovns %eax,%ebx
8010213f:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102142:	89 d8                	mov    %ebx,%eax
min_int(int a, int b) { return a < b ? a : b; }
80102144:	bb 50 00 00 00       	mov    $0x50,%ebx
80102149:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010214c:	39 d8                	cmp    %ebx,%eax
8010214e:	89 d8                	mov    %ebx,%eax
80102150:	0f 4e 45 d0          	cmovle -0x30(%ebp),%eax
80102154:	89 45 d0             	mov    %eax,-0x30(%ebp)
          for (int i = 0; i < min_int(old_len, 80); i++)
80102157:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010215a:	85 c0                	test   %eax,%eax
8010215c:	0f 8e 38 05 00 00    	jle    8010269a <consoleintr+0xe7a>
80102162:	89 4d c8             	mov    %ecx,-0x38(%ebp)
80102165:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80102168:	89 d7                	mov    %edx,%edi
  if (panicked)
8010216a:	8b 1d 58 2b 11 80    	mov    0x80112b58,%ebx
80102170:	85 db                	test   %ebx,%ebx
80102172:	0f 84 c8 02 00 00    	je     80102440 <consoleintr+0xc20>
80102178:	fa                   	cli
    for (;;)
80102179:	eb fe                	jmp    80102179 <consoleintr+0x959>
8010217b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  int len = (int)input.real_end - (int)input.w;
80102180:	8b 15 24 28 11 80    	mov    0x80112824,%edx
80102186:	8b 0d 2c 28 11 80    	mov    0x8011282c,%ecx
  int off_from_start = old_e - (int)input.w;
8010218c:	29 d0                	sub    %edx,%eax
  int len = (int)input.real_end - (int)input.w;
8010218e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if (off_from_start < 0)
80102191:	31 c9                	xor    %ecx,%ecx
80102193:	85 c0                	test   %eax,%eax
80102195:	0f 49 c8             	cmovns %eax,%ecx
80102198:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  for (int i = 0; i < off_from_start; i++)
8010219b:	0f 8e 17 04 00 00    	jle    801025b8 <consoleintr+0xd98>
801021a1:	31 db                	xor    %ebx,%ebx
801021a3:	89 d6                	mov    %edx,%esi
  if (panicked)
801021a5:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
801021ab:	85 c9                	test   %ecx,%ecx
801021ad:	0f 84 dd 00 00 00    	je     80102290 <consoleintr+0xa70>
801021b3:	fa                   	cli
    for (;;)
801021b4:	eb fe                	jmp    801021b4 <consoleintr+0x994>
801021b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021bd:	00 
801021be:	66 90                	xchg   %ax,%ax
            input.e = input.real_end;
801021c0:	89 35 28 28 11 80    	mov    %esi,0x80112828
801021c6:	89 f2                	mov    %esi,%edx
801021c8:	e9 06 fd ff ff       	jmp    80101ed3 <consoleintr+0x6b3>
        if (c != 0 && input.real_end - input.r < INPUT_BUF)
801021cd:	89 da                	mov    %ebx,%edx
801021cf:	2b 15 20 28 11 80    	sub    0x80112820,%edx
801021d5:	83 fa 7f             	cmp    $0x7f,%edx
801021d8:	0f 87 62 f6 ff ff    	ja     80101840 <consoleintr+0x20>
  if (panicked)
801021de:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
            input.real_end++;
801021e4:	8d 4b 01             	lea    0x1(%ebx),%ecx
          if (c != '\n')
801021e7:	83 f8 0a             	cmp    $0xa,%eax
801021ea:	0f 85 da 02 00 00    	jne    801024ca <consoleintr+0xcaa>
              input.buf[input.e++ % INPUT_BUF] = '\n';
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	89 0d 28 28 11 80    	mov    %ecx,0x80112828
801021f8:	83 e0 7f             	and    $0x7f,%eax
              input.real_end = input.e;
801021fb:	89 0d 2c 28 11 80    	mov    %ecx,0x8011282c
              input.buf[input.e++ % INPUT_BUF] = '\n';
80102201:	c6 80 a0 27 11 80 0a 	movb   $0xa,-0x7feed860(%eax)
  if (panicked)
80102208:	85 d2                	test   %edx,%edx
8010220a:	0f 84 5a 05 00 00    	je     8010276a <consoleintr+0xf4a>
80102210:	fa                   	cli
    for (;;)
80102211:	eb fe                	jmp    80102211 <consoleintr+0x9f1>
80102213:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102218:	b8 e5 00 00 00       	mov    $0xe5,%eax
8010221d:	e8 5e ec ff ff       	call   80100e80 <consputc.part.0>
        input.e++;
80102222:	83 05 28 28 11 80 01 	addl   $0x1,0x80112828
80102229:	e9 12 f6 ff ff       	jmp    80101840 <consoleintr+0x20>
8010222e:	31 d2                	xor    %edx,%edx
80102230:	b8 e4 00 00 00       	mov    $0xe4,%eax
80102235:	e8 46 ec ff ff       	call   80100e80 <consputc.part.0>
8010223a:	e9 01 f6 ff ff       	jmp    80101840 <consoleintr+0x20>
          for (int i = 0; i < wrote; ++i)
8010223f:	31 db                	xor    %ebx,%ebx
80102241:	89 ce                	mov    %ecx,%esi
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
80102243:	a1 28 28 11 80       	mov    0x80112828,%eax
  if (panicked)
80102248:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
            consputc(input.buf[(input.e - wrote + i) % INPUT_BUF], 0);
8010224e:	29 f0                	sub    %esi,%eax
80102250:	01 d8                	add    %ebx,%eax
80102252:	83 e0 7f             	and    $0x7f,%eax
80102255:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
8010225c:	85 d2                	test   %edx,%edx
8010225e:	0f 84 64 01 00 00    	je     801023c8 <consoleintr+0xba8>
80102264:	fa                   	cli
    for (;;)
80102265:	eb fe                	jmp    80102265 <consoleintr+0xa45>
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
  if (panicked)
80102270:	a1 58 2b 11 80       	mov    0x80112b58,%eax
          input.real_end--;
80102275:	89 15 2c 28 11 80    	mov    %edx,0x8011282c
  if (panicked)
8010227b:	85 c0                	test   %eax,%eax
8010227d:	0f 84 20 01 00 00    	je     801023a3 <consoleintr+0xb83>
80102283:	fa                   	cli
    for (;;)
80102284:	eb fe                	jmp    80102284 <consoleintr+0xa64>
80102286:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010228d:	00 
8010228e:	66 90                	xchg   %ax,%ax
80102290:	31 d2                	xor    %edx,%edx
80102292:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < off_from_start; i++)
80102297:	83 c3 01             	add    $0x1,%ebx
8010229a:	e8 e1 eb ff ff       	call   80100e80 <consputc.part.0>
8010229f:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
801022a2:	0f 8f fd fe ff ff    	jg     801021a5 <consoleintr+0x985>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
801022a8:	8b 1d 34 2a 11 80    	mov    0x80112a34,%ebx
801022ae:	89 f2                	mov    %esi,%edx
801022b0:	85 db                	test   %ebx,%ebx
801022b2:	0f 89 fa 02 00 00    	jns    801025b2 <consoleintr+0xd92>
  int sel = 0;
801022b8:	31 c9                	xor    %ecx,%ecx
  int lo = -1, hi = -1;
801022ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801022bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
  int len = (int)input.real_end - (int)input.w;
801022c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
801022c7:	29 d0                	sub    %edx,%eax
  if (len < 0)
801022c9:	31 d2                	xor    %edx,%edx
801022cb:	85 c0                	test   %eax,%eax
801022cd:	0f 49 d0             	cmovns %eax,%edx
801022d0:	89 55 cc             	mov    %edx,-0x34(%ebp)
  for (int i = 0; i < len; i++)
801022d3:	0f 8e b7 02 00 00    	jle    80102590 <consoleintr+0xd70>
    int in_sel = sel && idx >= lo && idx < hi;
801022d9:	89 c8                	mov    %ecx,%eax
  for (int i = 0; i < len; i++)
801022db:	31 c9                	xor    %ecx,%ecx
801022dd:	89 7d c0             	mov    %edi,-0x40(%ebp)
    int in_sel = sel && idx >= lo && idx < hi;
801022e0:	83 e0 01             	and    $0x1,%eax
  for (int i = 0; i < len; i++)
801022e3:	89 cf                	mov    %ecx,%edi
    int in_sel = sel && idx >= lo && idx < hi;
801022e5:	88 45 c4             	mov    %al,-0x3c(%ebp)
    ushort prev = cg_attr;
801022e8:	0f b7 05 0c b0 10 80 	movzwl 0x8010b00c,%eax
801022ef:	66 89 45 c8          	mov    %ax,-0x38(%ebp)
    int idx = (int)input.w + i;
801022f3:	a1 24 28 11 80       	mov    0x80112824,%eax
801022f8:	01 f8                	add    %edi,%eax
    int in_sel = sel && idx >= lo && idx < hi;
801022fa:	39 f0                	cmp    %esi,%eax
801022fc:	0f 9d c1             	setge  %cl
801022ff:	39 d8                	cmp    %ebx,%eax
80102301:	0f 9c c2             	setl   %dl
80102304:	84 d1                	test   %dl,%cl
80102306:	74 0b                	je     80102313 <consoleintr+0xaf3>
80102308:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
    cg_attr = in_sel ? 0x7000 : 0x0700;
8010230c:	ba 00 70 00 00       	mov    $0x7000,%edx
    int in_sel = sel && idx >= lo && idx < hi;
80102311:	75 05                	jne    80102318 <consoleintr+0xaf8>
    cg_attr = in_sel ? 0x7000 : 0x0700;
80102313:	ba 00 07 00 00       	mov    $0x700,%edx
80102318:	66 89 15 0c b0 10 80 	mov    %dx,0x8010b00c
    consputc(input.buf[idx % INPUT_BUF], 0);
8010231f:	99                   	cltd
80102320:	c1 ea 19             	shr    $0x19,%edx
80102323:	01 d0                	add    %edx,%eax
80102325:	83 e0 7f             	and    $0x7f,%eax
80102328:	29 d0                	sub    %edx,%eax
  if (panicked)
8010232a:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
    consputc(input.buf[idx % INPUT_BUF], 0);
80102330:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
80102337:	85 d2                	test   %edx,%edx
80102339:	0f 84 31 02 00 00    	je     80102570 <consoleintr+0xd50>
8010233f:	fa                   	cli
    for (;;)
80102340:	eb fe                	jmp    80102340 <consoleintr+0xb20>
80102342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80102348:	85 c0                	test   %eax,%eax
8010234a:	0f 84 f0 f4 ff ff    	je     80101840 <consoleintr+0x20>
80102350:	83 e8 01             	sub    $0x1,%eax
80102353:	83 e0 7f             	and    $0x7f,%eax
80102356:	80 b8 a0 27 11 80 20 	cmpb   $0x20,-0x7feed860(%eax)
8010235d:	0f 84 dd f4 ff ff    	je     80101840 <consoleintr+0x20>
  if (panicked)
80102363:	8b 15 58 2b 11 80    	mov    0x80112b58,%edx
80102369:	85 d2                	test   %edx,%edx
8010236b:	74 03                	je     80102370 <consoleintr+0xb50>
8010236d:	fa                   	cli
    for (;;)
8010236e:	eb fe                	jmp    8010236e <consoleintr+0xb4e>
80102370:	31 d2                	xor    %edx,%edx
80102372:	b8 e4 00 00 00       	mov    $0xe4,%eax
80102377:	e8 04 eb ff ff       	call   80100e80 <consputc.part.0>
        input.e--;
8010237c:	a1 28 28 11 80       	mov    0x80112828,%eax
80102381:	83 e8 01             	sub    $0x1,%eax
80102384:	a3 28 28 11 80       	mov    %eax,0x80112828
      while (input.e > 0 && input.buf[(input.e - 1) % INPUT_BUF] != ' ')
80102389:	75 c5                	jne    80102350 <consoleintr+0xb30>
8010238b:	e9 b0 f4 ff ff       	jmp    80101840 <consoleintr+0x20>
        int n = hi - lo;
80102390:	29 c8                	sub    %ecx,%eax
80102392:	89 c3                	mov    %eax,%ebx
        if (n > INPUT_BUF)
80102394:	b8 80 00 00 00       	mov    $0x80,%eax
80102399:	39 c3                	cmp    %eax,%ebx
8010239b:	0f 4f d8             	cmovg  %eax,%ebx
        for (int i = 0; i < n; ++i)
8010239e:	e9 66 f6 ff ff       	jmp    80101a09 <consoleintr+0x1e9>
801023a3:	31 d2                	xor    %edx,%edx
801023a5:	b8 00 01 00 00       	mov    $0x100,%eax
801023aa:	e8 d1 ea ff ff       	call   80100e80 <consputc.part.0>
801023af:	e9 8c f4 ff ff       	jmp    80101840 <consoleintr+0x20>
  if (panicked)
801023b4:	8b 1d 58 2b 11 80    	mov    0x80112b58,%ebx
801023ba:	85 db                	test   %ebx,%ebx
801023bc:	0f 84 5c fa ff ff    	je     80101e1e <consoleintr+0x5fe>
801023c2:	fa                   	cli
    for (;;)
801023c3:	eb fe                	jmp    801023c3 <consoleintr+0xba3>
801023c5:	8d 76 00             	lea    0x0(%esi),%esi
801023c8:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < wrote; ++i)
801023ca:	83 c3 01             	add    $0x1,%ebx
801023cd:	e8 ae ea ff ff       	call   80100e80 <consputc.part.0>
801023d2:	39 de                	cmp    %ebx,%esi
801023d4:	0f 85 69 fe ff ff    	jne    80102243 <consoleintr+0xa23>
801023da:	e9 61 f4 ff ff       	jmp    80101840 <consoleintr+0x20>
801023df:	31 d2                	xor    %edx,%edx
801023e1:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < old_cursor_off; i++)
801023e6:	83 c3 01             	add    $0x1,%ebx
801023e9:	e8 92 ea ff ff       	call   80100e80 <consputc.part.0>
801023ee:	39 f3                	cmp    %esi,%ebx
801023f0:	0f 8c ee f7 ff ff    	jl     80101be4 <consoleintr+0x3c4>
801023f6:	89 fa                	mov    %edi,%edx
801023f8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
801023fb:	8b 7d c4             	mov    -0x3c(%ebp),%edi
          int old_len = old_real_end - (int)input.w;
801023fe:	29 d3                	sub    %edx,%ebx
          if (old_len < 0)
80102400:	b8 00 00 00 00       	mov    $0x0,%eax
80102405:	0f 49 c3             	cmovns %ebx,%eax
80102408:	89 c6                	mov    %eax,%esi
min_int(int a, int b) { return a < b ? a : b; }
8010240a:	b8 50 00 00 00       	mov    $0x50,%eax
8010240f:	39 c6                	cmp    %eax,%esi
80102411:	0f 4f f0             	cmovg  %eax,%esi
          for (int i = 0; i < min_int(old_len, 80); i++)
80102414:	31 c9                	xor    %ecx,%ecx
80102416:	85 db                	test   %ebx,%ebx
80102418:	0f 8e 92 03 00 00    	jle    801027b0 <consoleintr+0xf90>
8010241e:	89 55 cc             	mov    %edx,-0x34(%ebp)
80102421:	89 cb                	mov    %ecx,%ebx
80102423:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80102426:	89 f7                	mov    %esi,%edi
  if (panicked)
80102428:	8b 35 58 2b 11 80    	mov    0x80112b58,%esi
8010242e:	85 f6                	test   %esi,%esi
80102430:	0f 84 aa 02 00 00    	je     801026e0 <consoleintr+0xec0>
80102436:	fa                   	cli
    for (;;)
80102437:	eb fe                	jmp    80102437 <consoleintr+0xc17>
80102439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102440:	b8 20 00 00 00       	mov    $0x20,%eax
80102445:	31 d2                	xor    %edx,%edx
80102447:	e8 34 ea ff ff       	call   80100e80 <consputc.part.0>
          for (int i = 0; i < min_int(old_len, 80); i++)
8010244c:	83 45 cc 01          	addl   $0x1,-0x34(%ebp)
80102450:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80102453:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102456:	39 c8                	cmp    %ecx,%eax
80102458:	0f 8c 0c fd ff ff    	jl     8010216a <consoleintr+0x94a>
8010245e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
80102461:	89 fa                	mov    %edi,%edx
80102463:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80102466:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80102469:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010246c:	89 d7                	mov    %edx,%edi
  if (panicked)
8010246e:	a1 58 2b 11 80       	mov    0x80112b58,%eax
80102473:	85 c0                	test   %eax,%eax
80102475:	0f 84 fd 01 00 00    	je     80102678 <consoleintr+0xe58>
8010247b:	fa                   	cli
    for (;;)
8010247c:	eb fe                	jmp    8010247c <consoleintr+0xc5c>
8010247e:	66 90                	xchg   %ax,%ax
80102480:	31 d2                	xor    %edx,%edx
80102482:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102485:	e8 f6 e9 ff ff       	call   80100e80 <consputc.part.0>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
8010248a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010248d:	83 f8 0a             	cmp    $0xa,%eax
80102490:	74 14                	je     801024a6 <consoleintr+0xc86>
80102492:	a1 20 28 11 80       	mov    0x80112820,%eax
80102497:	83 e8 80             	sub    $0xffffff80,%eax
8010249a:	39 05 2c 28 11 80    	cmp    %eax,0x8011282c
801024a0:	0f 85 9a f3 ff ff    	jne    80101840 <consoleintr+0x20>
            input.w = input.e;
801024a6:	a1 28 28 11 80       	mov    0x80112828,%eax
            wakeup(&input.r);
801024ab:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
801024ae:	a3 24 28 11 80       	mov    %eax,0x80112824
            input.real_end = input.e;
801024b3:	a3 2c 28 11 80       	mov    %eax,0x8011282c
            wakeup(&input.r);
801024b8:	68 20 28 11 80       	push   $0x80112820
801024bd:	e8 7e 3b 00 00       	call   80106040 <wakeup>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	e9 76 f3 ff ff       	jmp    80101840 <consoleintr+0x20>
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
801024ca:	83 eb 01             	sub    $0x1,%ebx
801024cd:	89 5d cc             	mov    %ebx,-0x34(%ebp)
801024d0:	8d 5e ff             	lea    -0x1(%esi),%ebx
801024d3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
801024d6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
801024d9:	39 de                	cmp    %ebx,%esi
801024db:	7f 60                	jg     8010253d <consoleintr+0xd1d>
801024dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
801024e0:	89 75 c8             	mov    %esi,-0x38(%ebp)
801024e3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801024e6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
801024e9:	89 55 c0             	mov    %edx,-0x40(%ebp)
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
801024ec:	89 d8                	mov    %ebx,%eax
801024ee:	c1 f8 1f             	sar    $0x1f,%eax
801024f1:	c1 e8 19             	shr    $0x19,%eax
801024f4:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
801024f7:	83 e1 7f             	and    $0x7f,%ecx
801024fa:	29 c1                	sub    %eax,%ecx
801024fc:	8d 43 01             	lea    0x1(%ebx),%eax
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
801024ff:	83 eb 01             	sub    $0x1,%ebx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80102502:	89 c6                	mov    %eax,%esi
80102504:	0f b6 91 a0 27 11 80 	movzbl -0x7feed860(%ecx),%edx
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
8010250b:	8b 0c 8d 30 28 11 80 	mov    -0x7feed7d0(,%ecx,4),%ecx
              input.buf[(i + 1) % INPUT_BUF] = input.buf[i % INPUT_BUF];
80102512:	c1 fe 1f             	sar    $0x1f,%esi
80102515:	c1 ee 19             	shr    $0x19,%esi
80102518:	01 f0                	add    %esi,%eax
8010251a:	83 e0 7f             	and    $0x7f,%eax
8010251d:	29 f0                	sub    %esi,%eax
8010251f:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
              input.insert_order[(i + 1) % INPUT_BUF] = input.insert_order[i % INPUT_BUF];
80102525:	89 0c 85 30 28 11 80 	mov    %ecx,-0x7feed7d0(,%eax,4)
            for (int i = (int)input.real_end - 1; i >= (int)input.e; i--)
8010252c:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
8010252f:	75 bb                	jne    801024ec <consoleintr+0xccc>
80102531:	8b 75 c8             	mov    -0x38(%ebp),%esi
80102534:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102537:	8b 4d cc             	mov    -0x34(%ebp),%ecx
8010253a:	8b 55 c0             	mov    -0x40(%ebp),%edx
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
8010253d:	8b 1d 30 2a 11 80    	mov    0x80112a30,%ebx
            input.buf[input.e % INPUT_BUF] = c;
80102543:	83 e6 7f             	and    $0x7f,%esi
            input.real_end++;
80102546:	89 0d 2c 28 11 80    	mov    %ecx,0x8011282c
            input.buf[input.e % INPUT_BUF] = c;
8010254c:	88 86 a0 27 11 80    	mov    %al,-0x7feed860(%esi)
            input.insert_order[input.e % INPUT_BUF] = ++input.current_time;
80102552:	83 c3 01             	add    $0x1,%ebx
80102555:	89 1d 30 2a 11 80    	mov    %ebx,0x80112a30
8010255b:	89 1c b5 30 28 11 80 	mov    %ebx,-0x7feed7d0(,%esi,4)
  if (panicked)
80102562:	85 d2                	test   %edx,%edx
80102564:	74 7a                	je     801025e0 <consoleintr+0xdc0>
80102566:	fa                   	cli
    for (;;)
80102567:	eb fe                	jmp    80102567 <consoleintr+0xd47>
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102570:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < len; i++)
80102572:	83 c7 01             	add    $0x1,%edi
80102575:	e8 06 e9 ff ff       	call   80100e80 <consputc.part.0>
    cg_attr = prev;
8010257a:	0f b7 45 c8          	movzwl -0x38(%ebp),%eax
8010257e:	66 a3 0c b0 10 80    	mov    %ax,0x8010b00c
  for (int i = 0; i < len; i++)
80102584:	39 7d cc             	cmp    %edi,-0x34(%ebp)
80102587:	0f 8f 66 fd ff ff    	jg     801022f3 <consoleintr+0xad3>
8010258d:	8b 7d c0             	mov    -0x40(%ebp),%edi
  int back = len - off_from_start;
80102590:	8b 75 cc             	mov    -0x34(%ebp),%esi
80102593:	8b 45 d0             	mov    -0x30(%ebp),%eax
  for (int i = 0; i < back; i++)
80102596:	31 db                	xor    %ebx,%ebx
  int back = len - off_from_start;
80102598:	29 c6                	sub    %eax,%esi
  for (int i = 0; i < back; i++)
8010259a:	85 f6                	test   %esi,%esi
8010259c:	0f 8e 9e f2 ff ff    	jle    80101840 <consoleintr+0x20>
  if (panicked)
801025a2:	a1 58 2b 11 80       	mov    0x80112b58,%eax
801025a7:	85 c0                	test   %eax,%eax
801025a9:	0f 84 c9 01 00 00    	je     80102778 <consoleintr+0xf58>
801025af:	fa                   	cli
    for (;;)
801025b0:	eb fe                	jmp    801025b0 <consoleintr+0xd90>
  if (input.sel_a >= 0 && input.sel_b >= 0 && input.sel_a != input.sel_b)
801025b2:	8b 35 38 2a 11 80    	mov    0x80112a38,%esi
801025b8:	39 f3                	cmp    %esi,%ebx
801025ba:	0f 84 f8 fc ff ff    	je     801022b8 <consoleintr+0xa98>
801025c0:	85 f6                	test   %esi,%esi
801025c2:	0f 88 f0 fc ff ff    	js     801022b8 <consoleintr+0xa98>
    sel = 1;
801025c8:	b9 01 00 00 00       	mov    $0x1,%ecx
    if (lo > hi)
801025cd:	39 f3                	cmp    %esi,%ebx
801025cf:	0f 8f ef fc ff ff    	jg     801022c4 <consoleintr+0xaa4>
801025d5:	89 f0                	mov    %esi,%eax
    lo = input.sel_a;
801025d7:	89 de                	mov    %ebx,%esi
    hi = input.sel_b;
801025d9:	89 c3                	mov    %eax,%ebx
801025db:	e9 e4 fc ff ff       	jmp    801022c4 <consoleintr+0xaa4>
801025e0:	31 d2                	xor    %edx,%edx
801025e2:	e8 99 e8 ff ff       	call   80100e80 <consputc.part.0>
            if (input.sel_a >= 0 && input.sel_a > input.e)
801025e7:	8b 15 34 2a 11 80    	mov    0x80112a34,%edx
801025ed:	8b 1d 28 28 11 80    	mov    0x80112828,%ebx
              if (input.sel_a > input.real_end)
801025f3:	a1 2c 28 11 80       	mov    0x8011282c,%eax
            if (input.sel_a >= 0 && input.sel_a > input.e)
801025f8:	85 d2                	test   %edx,%edx
801025fa:	78 12                	js     8010260e <consoleintr+0xdee>
801025fc:	39 d3                	cmp    %edx,%ebx
801025fe:	73 0e                	jae    8010260e <consoleintr+0xdee>
              input.sel_a++;
80102600:	83 c2 01             	add    $0x1,%edx
80102603:	39 c2                	cmp    %eax,%edx
80102605:	0f 47 d0             	cmova  %eax,%edx
80102608:	89 15 34 2a 11 80    	mov    %edx,0x80112a34
            input.e++;
8010260e:	83 c3 01             	add    $0x1,%ebx
80102611:	89 1d 28 28 11 80    	mov    %ebx,0x80112828
            for (uint i = input.e; i < input.real_end; i++)
80102617:	39 c3                	cmp    %eax,%ebx
80102619:	0f 83 13 01 00 00    	jae    80102732 <consoleintr+0xf12>
              consputc(input.buf[i % INPUT_BUF], 0);
8010261f:	89 d8                	mov    %ebx,%eax
  if (panicked)
80102621:	8b 35 58 2b 11 80    	mov    0x80112b58,%esi
              consputc(input.buf[i % INPUT_BUF], 0);
80102627:	83 e0 7f             	and    $0x7f,%eax
8010262a:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
80102631:	85 f6                	test   %esi,%esi
80102633:	74 0b                	je     80102640 <consoleintr+0xe20>
80102635:	fa                   	cli
    for (;;)
80102636:	eb fe                	jmp    80102636 <consoleintr+0xe16>
80102638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010263f:	00 
80102640:	31 d2                	xor    %edx,%edx
            for (uint i = input.e; i < input.real_end; i++)
80102642:	83 c3 01             	add    $0x1,%ebx
80102645:	e8 36 e8 ff ff       	call   80100e80 <consputc.part.0>
8010264a:	a1 2c 28 11 80       	mov    0x8011282c,%eax
8010264f:	39 c3                	cmp    %eax,%ebx
80102651:	72 cc                	jb     8010261f <consoleintr+0xdff>
            for (uint k = input.e; k < input.real_end; k++)
80102653:	8b 1d 28 28 11 80    	mov    0x80112828,%ebx
80102659:	39 c3                	cmp    %eax,%ebx
8010265b:	0f 83 d1 00 00 00    	jae    80102732 <consoleintr+0xf12>
  if (panicked)
80102661:	8b 0d 58 2b 11 80    	mov    0x80112b58,%ecx
80102667:	85 c9                	test   %ecx,%ecx
80102669:	0f 84 a7 00 00 00    	je     80102716 <consoleintr+0xef6>
8010266f:	fa                   	cli
    for (;;)
80102670:	eb fe                	jmp    80102670 <consoleintr+0xe50>
80102672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102678:	b8 e4 00 00 00       	mov    $0xe4,%eax
8010267d:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < min_int(old_len, 80); i++)
8010267f:	83 c3 01             	add    $0x1,%ebx
80102682:	e8 f9 e7 ff ff       	call   80100e80 <consputc.part.0>
80102687:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010268a:	39 c3                	cmp    %eax,%ebx
8010268c:	0f 8c dc fd ff ff    	jl     8010246e <consoleintr+0xc4e>
80102692:	89 fa                	mov    %edi,%edx
80102694:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80102697:	8b 7d c8             	mov    -0x38(%ebp),%edi
8010269a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
          int new_len = (int)input.real_end - (int)input.w;
8010269d:	29 ce                	sub    %ecx,%esi
          if (new_len < 0)
8010269f:	b8 00 00 00 00       	mov    $0x0,%eax
801026a4:	89 7d cc             	mov    %edi,-0x34(%ebp)
801026a7:	0f 48 f0             	cmovs  %eax,%esi
801026aa:	89 d7                	mov    %edx,%edi
          for (int i = 0; i < new_len; i++)
801026ac:	31 db                	xor    %ebx,%ebx
801026ae:	39 de                	cmp    %ebx,%esi
801026b0:	0f 84 85 01 00 00    	je     8010283b <consoleintr+0x101b>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801026b6:	a1 24 28 11 80       	mov    0x80112824,%eax
801026bb:	01 d8                	add    %ebx,%eax
801026bd:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
801026c0:	83 3d 58 2b 11 80 00 	cmpl   $0x0,0x80112b58
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801026c7:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
801026ce:	0f 84 58 01 00 00    	je     8010282c <consoleintr+0x100c>
801026d4:	fa                   	cli
    for (;;)
801026d5:	eb fe                	jmp    801026d5 <consoleintr+0xeb5>
801026d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026de:	00 
801026df:	90                   	nop
801026e0:	31 d2                	xor    %edx,%edx
801026e2:	b8 20 00 00 00       	mov    $0x20,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
801026e7:	83 c3 01             	add    $0x1,%ebx
801026ea:	e8 91 e7 ff ff       	call   80100e80 <consputc.part.0>
801026ef:	39 fb                	cmp    %edi,%ebx
801026f1:	0f 8c 31 fd ff ff    	jl     80102428 <consoleintr+0xc08>
801026f7:	8b 55 cc             	mov    -0x34(%ebp),%edx
801026fa:	89 f3                	mov    %esi,%ebx
801026fc:	89 fe                	mov    %edi,%esi
801026fe:	8b 7d c4             	mov    -0x3c(%ebp),%edi
80102701:	89 7d cc             	mov    %edi,-0x34(%ebp)
80102704:	89 d7                	mov    %edx,%edi
  if (panicked)
80102706:	83 3d 58 2b 11 80 00 	cmpl   $0x0,0x80112b58
8010270d:	0f 84 81 00 00 00    	je     80102794 <consoleintr+0xf74>
80102713:	fa                   	cli
    for (;;)
80102714:	eb fe                	jmp    80102714 <consoleintr+0xef4>
80102716:	b8 e4 00 00 00       	mov    $0xe4,%eax
8010271b:	31 d2                	xor    %edx,%edx
            for (uint k = input.e; k < input.real_end; k++)
8010271d:	83 c3 01             	add    $0x1,%ebx
80102720:	e8 5b e7 ff ff       	call   80100e80 <consputc.part.0>
80102725:	a1 2c 28 11 80       	mov    0x8011282c,%eax
8010272a:	39 c3                	cmp    %eax,%ebx
8010272c:	0f 82 2f ff ff ff    	jb     80102661 <consoleintr+0xe41>
          if (c == '\n' || input.real_end == input.r + INPUT_BUF)
80102732:	8b 35 20 28 11 80    	mov    0x80112820,%esi
80102738:	8d 96 80 00 00 00    	lea    0x80(%esi),%edx
8010273e:	39 c2                	cmp    %eax,%edx
80102740:	0f 85 fa f0 ff ff    	jne    80101840 <consoleintr+0x20>
            input.e = input.real_end;
80102746:	a3 28 28 11 80       	mov    %eax,0x80112828
            input.w = input.e;
8010274b:	a1 28 28 11 80       	mov    0x80112828,%eax
            wakeup(&input.r);
80102750:	83 ec 0c             	sub    $0xc,%esp
            input.w = input.e;
80102753:	a3 24 28 11 80       	mov    %eax,0x80112824
            wakeup(&input.r);
80102758:	68 20 28 11 80       	push   $0x80112820
8010275d:	e8 de 38 00 00       	call   80106040 <wakeup>
80102762:	83 c4 10             	add    $0x10,%esp
80102765:	e9 d6 f0 ff ff       	jmp    80101840 <consoleintr+0x20>
8010276a:	31 d2                	xor    %edx,%edx
8010276c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102771:	e8 0a e7 ff ff       	call   80100e80 <consputc.part.0>
80102776:	eb d3                	jmp    8010274b <consoleintr+0xf2b>
80102778:	31 d2                	xor    %edx,%edx
8010277a:	b8 e4 00 00 00       	mov    $0xe4,%eax
  for (int i = 0; i < back; i++)
8010277f:	83 c3 01             	add    $0x1,%ebx
80102782:	e8 f9 e6 ff ff       	call   80100e80 <consputc.part.0>
80102787:	39 de                	cmp    %ebx,%esi
80102789:	0f 85 13 fe ff ff    	jne    801025a2 <consoleintr+0xd82>
8010278f:	e9 ac f0 ff ff       	jmp    80101840 <consoleintr+0x20>
80102794:	31 d2                	xor    %edx,%edx
80102796:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < min_int(old_len, 80); i++)
8010279b:	83 c3 01             	add    $0x1,%ebx
8010279e:	e8 dd e6 ff ff       	call   80100e80 <consputc.part.0>
801027a3:	39 f3                	cmp    %esi,%ebx
801027a5:	0f 8c 5b ff ff ff    	jl     80102706 <consoleintr+0xee6>
801027ab:	89 fa                	mov    %edi,%edx
801027ad:	8b 7d cc             	mov    -0x34(%ebp),%edi
          int new_len = (int)input.real_end - (int)input.w;
801027b0:	8b 75 c8             	mov    -0x38(%ebp),%esi
          if (new_len < 0)
801027b3:	b8 00 00 00 00       	mov    $0x0,%eax
801027b8:	89 7d cc             	mov    %edi,-0x34(%ebp)
801027bb:	89 d7                	mov    %edx,%edi
          int new_len = (int)input.real_end - (int)input.w;
801027bd:	29 d6                	sub    %edx,%esi
          if (new_len < 0)
801027bf:	0f 48 f0             	cmovs  %eax,%esi
          for (int i = 0; i < new_len; i++)
801027c2:	31 db                	xor    %ebx,%ebx
801027c4:	39 de                	cmp    %ebx,%esi
801027c6:	74 29                	je     801027f1 <consoleintr+0xfd1>
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801027c8:	a1 24 28 11 80       	mov    0x80112824,%eax
801027cd:	01 d8                	add    %ebx,%eax
801027cf:	83 e0 7f             	and    $0x7f,%eax
  if (panicked)
801027d2:	83 3d 58 2b 11 80 00 	cmpl   $0x0,0x80112b58
            consputc(input.buf[(input.w + i) % INPUT_BUF], 0);
801027d9:	0f be 80 a0 27 11 80 	movsbl -0x7feed860(%eax),%eax
  if (panicked)
801027e0:	74 03                	je     801027e5 <consoleintr+0xfc5>
801027e2:	fa                   	cli
    for (;;)
801027e3:	eb fe                	jmp    801027e3 <consoleintr+0xfc3>
801027e5:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
801027e7:	83 c3 01             	add    $0x1,%ebx
801027ea:	e8 91 e6 ff ff       	call   80100e80 <consputc.part.0>
801027ef:	eb d3                	jmp    801027c4 <consoleintr+0xfa4>
          int new_cursor_off = (int)input.e - (int)input.w;
801027f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
801027f4:	89 fa                	mov    %edi,%edx
801027f6:	8b 7d cc             	mov    -0x34(%ebp),%edi
801027f9:	29 d0                	sub    %edx,%eax
          if (new_cursor_off < 0)
801027fb:	ba 00 00 00 00       	mov    $0x0,%edx
80102800:	0f 48 c2             	cmovs  %edx,%eax
          for (int i = 0; i < moves_left; i++)
80102803:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
80102805:	29 c6                	sub    %eax,%esi
          for (int i = 0; i < moves_left; i++)
80102807:	39 f3                	cmp    %esi,%ebx
80102809:	0f 8d 31 f0 ff ff    	jge    80101840 <consoleintr+0x20>
  if (panicked)
8010280f:	83 3d 58 2b 11 80 00 	cmpl   $0x0,0x80112b58
80102816:	74 03                	je     8010281b <consoleintr+0xffb>
80102818:	fa                   	cli
    for (;;)
80102819:	eb fe                	jmp    80102819 <consoleintr+0xff9>
8010281b:	31 d2                	xor    %edx,%edx
8010281d:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
80102822:	83 c3 01             	add    $0x1,%ebx
80102825:	e8 56 e6 ff ff       	call   80100e80 <consputc.part.0>
8010282a:	eb db                	jmp    80102807 <consoleintr+0xfe7>
8010282c:	31 d2                	xor    %edx,%edx
          for (int i = 0; i < new_len; i++)
8010282e:	83 c3 01             	add    $0x1,%ebx
80102831:	e8 4a e6 ff ff       	call   80100e80 <consputc.part.0>
80102836:	e9 73 fe ff ff       	jmp    801026ae <consoleintr+0xe8e>
          int new_cursor_off = (int)input.e - (int)input.w;
8010283b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010283e:	89 fa                	mov    %edi,%edx
          if (new_cursor_off < 0)
80102840:	b8 00 00 00 00       	mov    $0x0,%eax
          int new_cursor_off = (int)input.e - (int)input.w;
80102845:	8b 7d cc             	mov    -0x34(%ebp),%edi
80102848:	29 ca                	sub    %ecx,%edx
          if (new_cursor_off < 0)
8010284a:	0f 48 d0             	cmovs  %eax,%edx
          for (int i = 0; i < moves_left; i++)
8010284d:	31 db                	xor    %ebx,%ebx
          int moves_left = new_len - new_cursor_off;
8010284f:	29 d6                	sub    %edx,%esi
          for (int i = 0; i < moves_left; i++)
80102851:	39 f3                	cmp    %esi,%ebx
80102853:	0f 8d e7 ef ff ff    	jge    80101840 <consoleintr+0x20>
  if (panicked)
80102859:	83 3d 58 2b 11 80 00 	cmpl   $0x0,0x80112b58
80102860:	74 03                	je     80102865 <consoleintr+0x1045>
80102862:	fa                   	cli
    for (;;)
80102863:	eb fe                	jmp    80102863 <consoleintr+0x1043>
80102865:	31 d2                	xor    %edx,%edx
80102867:	b8 e4 00 00 00       	mov    $0xe4,%eax
          for (int i = 0; i < moves_left; i++)
8010286c:	83 c3 01             	add    $0x1,%ebx
8010286f:	e8 0c e6 ff ff       	call   80100e80 <consputc.part.0>
80102874:	eb db                	jmp    80102851 <consoleintr+0x1031>
80102876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010287d:	00 
8010287e:	66 90                	xchg   %ax,%ax

80102880 <consoleinit>:

void consoleinit(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 10             	sub    $0x10,%esp
  input.is_tab_mode = 0;
80102886:	c7 05 bc 2a 11 80 00 	movl   $0x0,0x80112abc
8010288d:	00 00 00 
  initlock(&cons.lock, "console");
80102890:	68 b1 a3 10 80       	push   $0x8010a3b1
80102895:	68 e0 2a 11 80       	push   $0x80112ae0
8010289a:	e8 61 3f 00 00       	call   80106800 <initlock>
  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;
  ioapicenable(IRQ_KBD, 0);
8010289f:	58                   	pop    %eax
801028a0:	5a                   	pop    %edx
801028a1:	6a 00                	push   $0x0
801028a3:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801028a5:	c7 05 4c 35 11 80 80 	movl   $0x80101480,0x8011354c
801028ac:	14 10 80 
  devsw[CONSOLE].read = consoleread;
801028af:	c7 05 48 35 11 80 40 	movl   $0x80100c40,0x80113548
801028b6:	0c 10 80 
  cons.locking = 1;
801028b9:	c7 05 54 2b 11 80 01 	movl   $0x1,0x80112b54
801028c0:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801028c3:	e8 a8 1a 00 00       	call   80104370 <ioapicenable>
  input.sel_a = input.sel_b = -1;
  input.clip_len = 0;
  input.has_enter = 0;
}
801028c8:	83 c4 10             	add    $0x10,%esp
  input.sel_a = input.sel_b = -1;
801028cb:	c7 05 38 2a 11 80 ff 	movl   $0xffffffff,0x80112a38
801028d2:	ff ff ff 
801028d5:	c7 05 34 2a 11 80 ff 	movl   $0xffffffff,0x80112a34
801028dc:	ff ff ff 
  input.clip_len = 0;
801028df:	c7 05 c0 2a 11 80 00 	movl   $0x0,0x80112ac0
801028e6:	00 00 00 
  input.has_enter = 0;
801028e9:	c7 05 d4 2a 11 80 00 	movl   $0x0,0x80112ad4
801028f0:	00 00 00 
}
801028f3:	c9                   	leave
801028f4:	c3                   	ret
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	57                   	push   %edi
80102904:	56                   	push   %esi
80102905:	53                   	push   %ebx
80102906:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010290c:	e8 8f 2f 00 00       	call   801058a0 <myproc>
80102911:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80102917:	e8 44 23 00 00       	call   80104c60 <begin_op>

  if((ip = namei(path)) == 0){
8010291c:	83 ec 0c             	sub    $0xc,%esp
8010291f:	ff 75 08             	push   0x8(%ebp)
80102922:	e8 59 16 00 00       	call   80103f80 <namei>
80102927:	83 c4 10             	add    $0x10,%esp
8010292a:	85 c0                	test   %eax,%eax
8010292c:	0f 84 30 03 00 00    	je     80102c62 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80102932:	83 ec 0c             	sub    $0xc,%esp
80102935:	89 c7                	mov    %eax,%edi
80102937:	50                   	push   %eax
80102938:	e8 d3 0c 00 00       	call   80103610 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010293d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80102943:	6a 34                	push   $0x34
80102945:	6a 00                	push   $0x0
80102947:	50                   	push   %eax
80102948:	57                   	push   %edi
80102949:	e8 12 10 00 00       	call   80103960 <readi>
8010294e:	83 c4 20             	add    $0x20,%esp
80102951:	83 f8 34             	cmp    $0x34,%eax
80102954:	0f 85 01 01 00 00    	jne    80102a5b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
8010295a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80102961:	45 4c 46 
80102964:	0f 85 f1 00 00 00    	jne    80102a5b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
8010296a:	e8 61 76 00 00       	call   80109fd0 <setupkvm>
8010296f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80102975:	85 c0                	test   %eax,%eax
80102977:	0f 84 de 00 00 00    	je     80102a5b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010297d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80102984:	00 
80102985:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
8010298b:	0f 84 a1 02 00 00    	je     80102c32 <exec+0x332>
  sz = 0;
80102991:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80102998:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010299b:	31 db                	xor    %ebx,%ebx
8010299d:	e9 8c 00 00 00       	jmp    80102a2e <exec+0x12e>
801029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
801029a8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801029af:	75 6c                	jne    80102a1d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
801029b1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801029b7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801029bd:	0f 82 87 00 00 00    	jb     80102a4a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
801029c3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801029c9:	72 7f                	jb     80102a4a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801029cb:	83 ec 04             	sub    $0x4,%esp
801029ce:	50                   	push   %eax
801029cf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
801029d5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801029db:	e8 20 74 00 00       	call   80109e00 <allocuvm>
801029e0:	83 c4 10             	add    $0x10,%esp
801029e3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801029e9:	85 c0                	test   %eax,%eax
801029eb:	74 5d                	je     80102a4a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
801029ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801029f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801029f8:	75 50                	jne    80102a4a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801029fa:	83 ec 0c             	sub    $0xc,%esp
801029fd:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80102a03:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80102a09:	57                   	push   %edi
80102a0a:	50                   	push   %eax
80102a0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102a11:	e8 1a 73 00 00       	call   80109d30 <loaduvm>
80102a16:	83 c4 20             	add    $0x20,%esp
80102a19:	85 c0                	test   %eax,%eax
80102a1b:	78 2d                	js     80102a4a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102a1d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80102a24:	83 c3 01             	add    $0x1,%ebx
80102a27:	83 c6 20             	add    $0x20,%esi
80102a2a:	39 d8                	cmp    %ebx,%eax
80102a2c:	7e 52                	jle    80102a80 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80102a2e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80102a34:	6a 20                	push   $0x20
80102a36:	56                   	push   %esi
80102a37:	50                   	push   %eax
80102a38:	57                   	push   %edi
80102a39:	e8 22 0f 00 00       	call   80103960 <readi>
80102a3e:	83 c4 10             	add    $0x10,%esp
80102a41:	83 f8 20             	cmp    $0x20,%eax
80102a44:	0f 84 5e ff ff ff    	je     801029a8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80102a4a:	83 ec 0c             	sub    $0xc,%esp
80102a4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102a53:	e8 f8 74 00 00       	call   80109f50 <freevm>
  if(ip){
80102a58:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80102a5b:	83 ec 0c             	sub    $0xc,%esp
80102a5e:	57                   	push   %edi
80102a5f:	e8 6c 0e 00 00       	call   801038d0 <iunlockput>
    end_op();
80102a64:	e8 67 22 00 00       	call   80104cd0 <end_op>
80102a69:	83 c4 10             	add    $0x10,%esp
    return -1;
80102a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80102a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a74:	5b                   	pop    %ebx
80102a75:	5e                   	pop    %esi
80102a76:	5f                   	pop    %edi
80102a77:	5d                   	pop    %ebp
80102a78:	c3                   	ret
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80102a80:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80102a86:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80102a8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102a92:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80102a98:	83 ec 0c             	sub    $0xc,%esp
80102a9b:	57                   	push   %edi
80102a9c:	e8 2f 0e 00 00       	call   801038d0 <iunlockput>
  end_op();
80102aa1:	e8 2a 22 00 00       	call   80104cd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80102aa6:	83 c4 0c             	add    $0xc,%esp
80102aa9:	53                   	push   %ebx
80102aaa:	56                   	push   %esi
80102aab:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80102ab1:	56                   	push   %esi
80102ab2:	e8 49 73 00 00       	call   80109e00 <allocuvm>
80102ab7:	83 c4 10             	add    $0x10,%esp
80102aba:	89 c7                	mov    %eax,%edi
80102abc:	85 c0                	test   %eax,%eax
80102abe:	0f 84 86 00 00 00    	je     80102b4a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102ac4:	83 ec 08             	sub    $0x8,%esp
80102ac7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80102acd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102acf:	50                   	push   %eax
80102ad0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80102ad1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80102ad3:	e8 98 75 00 00       	call   8010a070 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80102ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
80102adb:	83 c4 10             	add    $0x10,%esp
80102ade:	8b 10                	mov    (%eax),%edx
80102ae0:	85 d2                	test   %edx,%edx
80102ae2:	0f 84 56 01 00 00    	je     80102c3e <exec+0x33e>
80102ae8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80102aee:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102af1:	eb 23                	jmp    80102b16 <exec+0x216>
80102af3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102af8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80102afb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80102b02:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80102b08:	8b 14 87             	mov    (%edi,%eax,4),%edx
80102b0b:	85 d2                	test   %edx,%edx
80102b0d:	74 51                	je     80102b60 <exec+0x260>
    if(argc >= MAXARG)
80102b0f:	83 f8 20             	cmp    $0x20,%eax
80102b12:	74 36                	je     80102b4a <exec+0x24a>
80102b14:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102b16:	83 ec 0c             	sub    $0xc,%esp
80102b19:	52                   	push   %edx
80102b1a:	e8 81 46 00 00       	call   801071a0 <strlen>
80102b1f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102b21:	58                   	pop    %eax
80102b22:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80102b25:	83 eb 01             	sub    $0x1,%ebx
80102b28:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80102b2b:	e8 70 46 00 00       	call   801071a0 <strlen>
80102b30:	83 c0 01             	add    $0x1,%eax
80102b33:	50                   	push   %eax
80102b34:	ff 34 b7             	push   (%edi,%esi,4)
80102b37:	53                   	push   %ebx
80102b38:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102b3e:	e8 fd 76 00 00       	call   8010a240 <copyout>
80102b43:	83 c4 20             	add    $0x20,%esp
80102b46:	85 c0                	test   %eax,%eax
80102b48:	79 ae                	jns    80102af8 <exec+0x1f8>
    freevm(pgdir);
80102b4a:	83 ec 0c             	sub    $0xc,%esp
80102b4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102b53:	e8 f8 73 00 00       	call   80109f50 <freevm>
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	e9 0c ff ff ff       	jmp    80102a6c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102b60:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80102b67:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80102b6d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80102b73:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80102b76:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80102b79:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80102b80:	00 00 00 00 
  ustack[1] = argc;
80102b84:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80102b8a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80102b91:	ff ff ff 
  ustack[1] = argc;
80102b94:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102b9a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80102b9c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80102b9e:	29 d0                	sub    %edx,%eax
80102ba0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80102ba6:	56                   	push   %esi
80102ba7:	51                   	push   %ecx
80102ba8:	53                   	push   %ebx
80102ba9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80102baf:	e8 8c 76 00 00       	call   8010a240 <copyout>
80102bb4:	83 c4 10             	add    $0x10,%esp
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	78 8f                	js     80102b4a <exec+0x24a>
  for(last=s=path; *s; s++)
80102bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbe:	8b 55 08             	mov    0x8(%ebp),%edx
80102bc1:	0f b6 00             	movzbl (%eax),%eax
80102bc4:	84 c0                	test   %al,%al
80102bc6:	74 17                	je     80102bdf <exec+0x2df>
80102bc8:	89 d1                	mov    %edx,%ecx
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80102bd0:	83 c1 01             	add    $0x1,%ecx
80102bd3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80102bd5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80102bd8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80102bdb:	84 c0                	test   %al,%al
80102bdd:	75 f1                	jne    80102bd0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80102bdf:	83 ec 04             	sub    $0x4,%esp
80102be2:	6a 10                	push   $0x10
80102be4:	52                   	push   %edx
80102be5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80102beb:	8d 46 6c             	lea    0x6c(%esi),%eax
80102bee:	50                   	push   %eax
80102bef:	e8 6c 45 00 00       	call   80107160 <safestrcpy>
  curproc->pgdir = pgdir;
80102bf4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80102bfa:	89 f0                	mov    %esi,%eax
80102bfc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80102bff:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80102c01:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80102c04:	89 c1                	mov    %eax,%ecx
80102c06:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80102c0c:	8b 40 18             	mov    0x18(%eax),%eax
80102c0f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80102c12:	8b 41 18             	mov    0x18(%ecx),%eax
80102c15:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80102c18:	89 0c 24             	mov    %ecx,(%esp)
80102c1b:	e8 80 6f 00 00       	call   80109ba0 <switchuvm>
  freevm(oldpgdir);
80102c20:	89 34 24             	mov    %esi,(%esp)
80102c23:	e8 28 73 00 00       	call   80109f50 <freevm>
  return 0;
80102c28:	83 c4 10             	add    $0x10,%esp
80102c2b:	31 c0                	xor    %eax,%eax
80102c2d:	e9 3f fe ff ff       	jmp    80102a71 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80102c32:	bb 00 20 00 00       	mov    $0x2000,%ebx
80102c37:	31 f6                	xor    %esi,%esi
80102c39:	e9 5a fe ff ff       	jmp    80102a98 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80102c3e:	be 10 00 00 00       	mov    $0x10,%esi
80102c43:	ba 04 00 00 00       	mov    $0x4,%edx
80102c48:	b8 03 00 00 00       	mov    $0x3,%eax
80102c4d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80102c54:	00 00 00 
80102c57:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80102c5d:	e9 17 ff ff ff       	jmp    80102b79 <exec+0x279>
    end_op();
80102c62:	e8 69 20 00 00       	call   80104cd0 <end_op>
    cprintf("exec: fail\n");
80102c67:	83 ec 0c             	sub    $0xc,%esp
80102c6a:	68 b9 a3 10 80       	push   $0x8010a3b9
80102c6f:	e8 9c e9 ff ff       	call   80101610 <cprintf>
    return -1;
80102c74:	83 c4 10             	add    $0x10,%esp
80102c77:	e9 f0 fd ff ff       	jmp    80102a6c <exec+0x16c>
80102c7c:	66 90                	xchg   %ax,%ax
80102c7e:	66 90                	xchg   %ax,%ax

80102c80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80102c86:	68 c5 a3 10 80       	push   $0x8010a3c5
80102c8b:	68 60 2b 11 80       	push   $0x80112b60
80102c90:	e8 6b 3b 00 00       	call   80106800 <initlock>
}
80102c95:	83 c4 10             	add    $0x10,%esp
80102c98:	c9                   	leave
80102c99:	c3                   	ret
80102c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ca0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102ca4:	bb d4 2b 11 80       	mov    $0x80112bd4,%ebx
{
80102ca9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80102cac:	68 60 2b 11 80       	push   $0x80112b60
80102cb1:	e8 5a 3d 00 00       	call   80106a10 <acquire>
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	eb 10                	jmp    80102ccb <filealloc+0x2b>
80102cbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80102cc0:	83 c3 18             	add    $0x18,%ebx
80102cc3:	81 fb 34 35 11 80    	cmp    $0x80113534,%ebx
80102cc9:	74 25                	je     80102cf0 <filealloc+0x50>
    if(f->ref == 0){
80102ccb:	8b 43 04             	mov    0x4(%ebx),%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	75 ee                	jne    80102cc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80102cd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80102cdc:	68 60 2b 11 80       	push   $0x80112b60
80102ce1:	e8 ca 3c 00 00       	call   801069b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80102ce6:	89 d8                	mov    %ebx,%eax
      return f;
80102ce8:	83 c4 10             	add    $0x10,%esp
}
80102ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cee:	c9                   	leave
80102cef:	c3                   	ret
  release(&ftable.lock);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80102cf3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80102cf5:	68 60 2b 11 80       	push   $0x80112b60
80102cfa:	e8 b1 3c 00 00       	call   801069b0 <release>
}
80102cff:	89 d8                	mov    %ebx,%eax
  return 0;
80102d01:	83 c4 10             	add    $0x10,%esp
}
80102d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d07:	c9                   	leave
80102d08:	c3                   	ret
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 10             	sub    $0x10,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80102d1a:	68 60 2b 11 80       	push   $0x80112b60
80102d1f:	e8 ec 3c 00 00       	call   80106a10 <acquire>
  if(f->ref < 1)
80102d24:	8b 43 04             	mov    0x4(%ebx),%eax
80102d27:	83 c4 10             	add    $0x10,%esp
80102d2a:	85 c0                	test   %eax,%eax
80102d2c:	7e 1a                	jle    80102d48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80102d2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80102d31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80102d34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80102d37:	68 60 2b 11 80       	push   $0x80112b60
80102d3c:	e8 6f 3c 00 00       	call   801069b0 <release>
  return f;
}
80102d41:	89 d8                	mov    %ebx,%eax
80102d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d46:	c9                   	leave
80102d47:	c3                   	ret
    panic("filedup");
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 cc a3 10 80       	push   $0x8010a3cc
80102d50:	e8 ab e0 ff ff       	call   80100e00 <panic>
80102d55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d5c:	00 
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi

80102d60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	57                   	push   %edi
80102d64:	56                   	push   %esi
80102d65:	53                   	push   %ebx
80102d66:	83 ec 28             	sub    $0x28,%esp
80102d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80102d6c:	68 60 2b 11 80       	push   $0x80112b60
80102d71:	e8 9a 3c 00 00       	call   80106a10 <acquire>
  if(f->ref < 1)
80102d76:	8b 53 04             	mov    0x4(%ebx),%edx
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	85 d2                	test   %edx,%edx
80102d7e:	0f 8e a5 00 00 00    	jle    80102e29 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80102d84:	83 ea 01             	sub    $0x1,%edx
80102d87:	89 53 04             	mov    %edx,0x4(%ebx)
80102d8a:	75 44                	jne    80102dd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80102d8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80102d90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80102d93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80102d95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80102d9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80102d9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80102da1:	8b 43 10             	mov    0x10(%ebx),%eax
80102da4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80102da7:	68 60 2b 11 80       	push   $0x80112b60
80102dac:	e8 ff 3b 00 00       	call   801069b0 <release>

  if(ff.type == FD_PIPE)
80102db1:	83 c4 10             	add    $0x10,%esp
80102db4:	83 ff 01             	cmp    $0x1,%edi
80102db7:	74 57                	je     80102e10 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80102db9:	83 ff 02             	cmp    $0x2,%edi
80102dbc:	74 2a                	je     80102de8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80102dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc1:	5b                   	pop    %ebx
80102dc2:	5e                   	pop    %esi
80102dc3:	5f                   	pop    %edi
80102dc4:	5d                   	pop    %ebp
80102dc5:	c3                   	ret
80102dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dcd:	00 
80102dce:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80102dd0:	c7 45 08 60 2b 11 80 	movl   $0x80112b60,0x8(%ebp)
}
80102dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dda:	5b                   	pop    %ebx
80102ddb:	5e                   	pop    %esi
80102ddc:	5f                   	pop    %edi
80102ddd:	5d                   	pop    %ebp
    release(&ftable.lock);
80102dde:	e9 cd 3b 00 00       	jmp    801069b0 <release>
80102de3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80102de8:	e8 73 1e 00 00       	call   80104c60 <begin_op>
    iput(ff.ip);
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	ff 75 e0             	push   -0x20(%ebp)
80102df3:	e8 58 09 00 00       	call   80103750 <iput>
    end_op();
80102df8:	83 c4 10             	add    $0x10,%esp
}
80102dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dfe:	5b                   	pop    %ebx
80102dff:	5e                   	pop    %esi
80102e00:	5f                   	pop    %edi
80102e01:	5d                   	pop    %ebp
    end_op();
80102e02:	e9 c9 1e 00 00       	jmp    80104cd0 <end_op>
80102e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e0e:	00 
80102e0f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80102e10:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80102e14:	83 ec 08             	sub    $0x8,%esp
80102e17:	53                   	push   %ebx
80102e18:	56                   	push   %esi
80102e19:	e8 12 26 00 00       	call   80105430 <pipeclose>
80102e1e:	83 c4 10             	add    $0x10,%esp
}
80102e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e24:	5b                   	pop    %ebx
80102e25:	5e                   	pop    %esi
80102e26:	5f                   	pop    %edi
80102e27:	5d                   	pop    %ebp
80102e28:	c3                   	ret
    panic("fileclose");
80102e29:	83 ec 0c             	sub    $0xc,%esp
80102e2c:	68 d4 a3 10 80       	push   $0x8010a3d4
80102e31:	e8 ca df ff ff       	call   80100e00 <panic>
80102e36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e3d:	00 
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
80102e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80102e4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80102e4d:	75 31                	jne    80102e80 <filestat+0x40>
    ilock(f->ip);
80102e4f:	83 ec 0c             	sub    $0xc,%esp
80102e52:	ff 73 10             	push   0x10(%ebx)
80102e55:	e8 b6 07 00 00       	call   80103610 <ilock>
    stati(f->ip, st);
80102e5a:	58                   	pop    %eax
80102e5b:	5a                   	pop    %edx
80102e5c:	ff 75 0c             	push   0xc(%ebp)
80102e5f:	ff 73 10             	push   0x10(%ebx)
80102e62:	e8 b9 0a 00 00       	call   80103920 <stati>
    iunlock(f->ip);
80102e67:	59                   	pop    %ecx
80102e68:	ff 73 10             	push   0x10(%ebx)
80102e6b:	e8 90 08 00 00       	call   80103700 <iunlock>
    return 0;
  }
  return -1;
}
80102e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80102e73:	83 c4 10             	add    $0x10,%esp
80102e76:	31 c0                	xor    %eax,%eax
}
80102e78:	c9                   	leave
80102e79:	c3                   	ret
80102e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80102e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e88:	c9                   	leave
80102e89:	c3                   	ret
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	57                   	push   %edi
80102e94:	56                   	push   %esi
80102e95:	53                   	push   %ebx
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80102ea2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80102ea6:	74 60                	je     80102f08 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80102ea8:	8b 03                	mov    (%ebx),%eax
80102eaa:	83 f8 01             	cmp    $0x1,%eax
80102ead:	74 41                	je     80102ef0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102eaf:	83 f8 02             	cmp    $0x2,%eax
80102eb2:	75 5b                	jne    80102f0f <fileread+0x7f>
    ilock(f->ip);
80102eb4:	83 ec 0c             	sub    $0xc,%esp
80102eb7:	ff 73 10             	push   0x10(%ebx)
80102eba:	e8 51 07 00 00       	call   80103610 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80102ebf:	57                   	push   %edi
80102ec0:	ff 73 14             	push   0x14(%ebx)
80102ec3:	56                   	push   %esi
80102ec4:	ff 73 10             	push   0x10(%ebx)
80102ec7:	e8 94 0a 00 00       	call   80103960 <readi>
80102ecc:	83 c4 20             	add    $0x20,%esp
80102ecf:	89 c6                	mov    %eax,%esi
80102ed1:	85 c0                	test   %eax,%eax
80102ed3:	7e 03                	jle    80102ed8 <fileread+0x48>
      f->off += r;
80102ed5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80102ed8:	83 ec 0c             	sub    $0xc,%esp
80102edb:	ff 73 10             	push   0x10(%ebx)
80102ede:	e8 1d 08 00 00       	call   80103700 <iunlock>
    return r;
80102ee3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80102ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ee9:	89 f0                	mov    %esi,%eax
80102eeb:	5b                   	pop    %ebx
80102eec:	5e                   	pop    %esi
80102eed:	5f                   	pop    %edi
80102eee:	5d                   	pop    %ebp
80102eef:	c3                   	ret
    return piperead(f->pipe, addr, n);
80102ef0:	8b 43 0c             	mov    0xc(%ebx),%eax
80102ef3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80102ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ef9:	5b                   	pop    %ebx
80102efa:	5e                   	pop    %esi
80102efb:	5f                   	pop    %edi
80102efc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80102efd:	e9 ee 26 00 00       	jmp    801055f0 <piperead>
80102f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80102f08:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102f0d:	eb d7                	jmp    80102ee6 <fileread+0x56>
  panic("fileread");
80102f0f:	83 ec 0c             	sub    $0xc,%esp
80102f12:	68 de a3 10 80       	push   $0x8010a3de
80102f17:	e8 e4 de ff ff       	call   80100e00 <panic>
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f20 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	57                   	push   %edi
80102f24:	56                   	push   %esi
80102f25:	53                   	push   %ebx
80102f26:	83 ec 1c             	sub    $0x1c,%esp
80102f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f32:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80102f35:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80102f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80102f3c:	0f 84 bb 00 00 00    	je     80102ffd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80102f42:	8b 03                	mov    (%ebx),%eax
80102f44:	83 f8 01             	cmp    $0x1,%eax
80102f47:	0f 84 bf 00 00 00    	je     8010300c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80102f4d:	83 f8 02             	cmp    $0x2,%eax
80102f50:	0f 85 c8 00 00 00    	jne    8010301e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80102f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80102f59:	31 f6                	xor    %esi,%esi
    while(i < n){
80102f5b:	85 c0                	test   %eax,%eax
80102f5d:	7f 30                	jg     80102f8f <filewrite+0x6f>
80102f5f:	e9 94 00 00 00       	jmp    80102ff8 <filewrite+0xd8>
80102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80102f68:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80102f6b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
80102f6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102f71:	ff 73 10             	push   0x10(%ebx)
80102f74:	e8 87 07 00 00       	call   80103700 <iunlock>
      end_op();
80102f79:	e8 52 1d 00 00       	call   80104cd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80102f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	39 c7                	cmp    %eax,%edi
80102f86:	75 5c                	jne    80102fe4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80102f88:	01 fe                	add    %edi,%esi
    while(i < n){
80102f8a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102f8d:	7e 69                	jle    80102ff8 <filewrite+0xd8>
      int n1 = n - i;
80102f8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80102f92:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80102f97:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80102f99:	39 c7                	cmp    %eax,%edi
80102f9b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
80102f9e:	e8 bd 1c 00 00       	call   80104c60 <begin_op>
      ilock(f->ip);
80102fa3:	83 ec 0c             	sub    $0xc,%esp
80102fa6:	ff 73 10             	push   0x10(%ebx)
80102fa9:	e8 62 06 00 00       	call   80103610 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80102fae:	57                   	push   %edi
80102faf:	ff 73 14             	push   0x14(%ebx)
80102fb2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102fb5:	01 f0                	add    %esi,%eax
80102fb7:	50                   	push   %eax
80102fb8:	ff 73 10             	push   0x10(%ebx)
80102fbb:	e8 b0 0a 00 00       	call   80103a70 <writei>
80102fc0:	83 c4 20             	add    $0x20,%esp
80102fc3:	85 c0                	test   %eax,%eax
80102fc5:	7f a1                	jg     80102f68 <filewrite+0x48>
80102fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80102fca:	83 ec 0c             	sub    $0xc,%esp
80102fcd:	ff 73 10             	push   0x10(%ebx)
80102fd0:	e8 2b 07 00 00       	call   80103700 <iunlock>
      end_op();
80102fd5:	e8 f6 1c 00 00       	call   80104cd0 <end_op>
      if(r < 0)
80102fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102fdd:	83 c4 10             	add    $0x10,%esp
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	75 14                	jne    80102ff8 <filewrite+0xd8>
        panic("short filewrite");
80102fe4:	83 ec 0c             	sub    $0xc,%esp
80102fe7:	68 e7 a3 10 80       	push   $0x8010a3e7
80102fec:	e8 0f de ff ff       	call   80100e00 <panic>
80102ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80102ff8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80102ffb:	74 05                	je     80103002 <filewrite+0xe2>
80102ffd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80103002:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103005:	89 f0                	mov    %esi,%eax
80103007:	5b                   	pop    %ebx
80103008:	5e                   	pop    %esi
80103009:	5f                   	pop    %edi
8010300a:	5d                   	pop    %ebp
8010300b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010300c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010300f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80103012:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103015:	5b                   	pop    %ebx
80103016:	5e                   	pop    %esi
80103017:	5f                   	pop    %edi
80103018:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80103019:	e9 b2 24 00 00       	jmp    801054d0 <pipewrite>
  panic("filewrite");
8010301e:	83 ec 0c             	sub    $0xc,%esp
80103021:	68 ed a3 10 80       	push   $0x8010a3ed
80103026:	e8 d5 dd ff ff       	call   80100e00 <panic>
8010302b:	66 90                	xchg   %ax,%ax
8010302d:	66 90                	xchg   %ax,%ax
8010302f:	90                   	nop

80103030 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	53                   	push   %ebx
80103036:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80103039:	8b 0d b4 5e 11 80    	mov    0x80115eb4,%ecx
{
8010303f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80103042:	85 c9                	test   %ecx,%ecx
80103044:	0f 84 8f 00 00 00    	je     801030d9 <balloc+0xa9>
8010304a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010304c:	89 f8                	mov    %edi,%eax
8010304e:	83 ec 08             	sub    $0x8,%esp
80103051:	89 fe                	mov    %edi,%esi
80103053:	c1 f8 0c             	sar    $0xc,%eax
80103056:	03 05 cc 5e 11 80    	add    0x80115ecc,%eax
8010305c:	50                   	push   %eax
8010305d:	ff 75 dc             	push   -0x24(%ebp)
80103060:	e8 6b d0 ff ff       	call   801000d0 <bread>
80103065:	83 c4 10             	add    $0x10,%esp
80103068:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010306b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010306e:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80103073:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103076:	31 c0                	xor    %eax,%eax
80103078:	eb 35                	jmp    801030af <balloc+0x7f>
8010307a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80103080:	89 c1                	mov    %eax,%ecx
80103082:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80103087:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010308a:	83 e1 07             	and    $0x7,%ecx
8010308d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010308f:	89 c1                	mov    %eax,%ecx
80103091:	c1 f9 03             	sar    $0x3,%ecx
80103094:	0f b6 bc 0f 9c 00 00 	movzbl 0x9c(%edi,%ecx,1),%edi
8010309b:	00 
8010309c:	89 fa                	mov    %edi,%edx
8010309e:	85 df                	test   %ebx,%edi
801030a0:	74 4e                	je     801030f0 <balloc+0xc0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801030a2:	83 c0 01             	add    $0x1,%eax
801030a5:	83 c6 01             	add    $0x1,%esi
801030a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801030ad:	74 07                	je     801030b6 <balloc+0x86>
801030af:	8b 55 e0             	mov    -0x20(%ebp),%edx
801030b2:	39 d6                	cmp    %edx,%esi
801030b4:	72 ca                	jb     80103080 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801030b6:	8b 7d d8             	mov    -0x28(%ebp),%edi
801030b9:	83 ec 0c             	sub    $0xc,%esp
801030bc:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801030bf:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801030c5:	e8 46 d1 ff ff       	call   80100210 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801030ca:	83 c4 10             	add    $0x10,%esp
801030cd:	3b 3d b4 5e 11 80    	cmp    0x80115eb4,%edi
801030d3:	0f 82 73 ff ff ff    	jb     8010304c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801030d9:	83 ec 0c             	sub    $0xc,%esp
801030dc:	68 f7 a3 10 80       	push   $0x8010a3f7
801030e1:	e8 1a dd ff ff       	call   80100e00 <panic>
801030e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801030ed:	00 
801030ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801030f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801030f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801030f6:	09 da                	or     %ebx,%edx
801030f8:	88 94 0f 9c 00 00 00 	mov    %dl,0x9c(%edi,%ecx,1)
        log_write(bp);
801030ff:	57                   	push   %edi
80103100:	e8 3b 1d 00 00       	call   80104e40 <log_write>
        brelse(bp);
80103105:	89 3c 24             	mov    %edi,(%esp)
80103108:	e8 03 d1 ff ff       	call   80100210 <brelse>
  bp = bread(dev, bno);
8010310d:	58                   	pop    %eax
8010310e:	5a                   	pop    %edx
8010310f:	56                   	push   %esi
80103110:	ff 75 dc             	push   -0x24(%ebp)
80103113:	e8 b8 cf ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80103118:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
8010311b:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010311d:	8d 80 9c 00 00 00    	lea    0x9c(%eax),%eax
80103123:	68 00 02 00 00       	push   $0x200
80103128:	6a 00                	push   $0x0
8010312a:	50                   	push   %eax
8010312b:	e8 80 3e 00 00       	call   80106fb0 <memset>
  log_write(bp);
80103130:	89 1c 24             	mov    %ebx,(%esp)
80103133:	e8 08 1d 00 00       	call   80104e40 <log_write>
  brelse(bp);
80103138:	89 1c 24             	mov    %ebx,(%esp)
8010313b:	e8 d0 d0 ff ff       	call   80100210 <brelse>
}
80103140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103143:	89 f0                	mov    %esi,%eax
80103145:	5b                   	pop    %ebx
80103146:	5e                   	pop    %esi
80103147:	5f                   	pop    %edi
80103148:	5d                   	pop    %ebp
80103149:	c3                   	ret
8010314a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103150 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80103154:	31 ff                	xor    %edi,%edi
{
80103156:	56                   	push   %esi
80103157:	89 c6                	mov    %eax,%esi
80103159:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010315a:	bb 14 36 11 80       	mov    $0x80113614,%ebx
{
8010315f:	83 ec 28             	sub    $0x28,%esp
80103162:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80103165:	68 a0 35 11 80       	push   $0x801135a0
8010316a:	e8 a1 38 00 00       	call   80106a10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010316f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80103172:	83 c4 10             	add    $0x10,%esp
80103175:	eb 1b                	jmp    80103192 <iget+0x42>
80103177:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010317e:	00 
8010317f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80103180:	39 33                	cmp    %esi,(%ebx)
80103182:	74 6c                	je     801031f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80103184:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
8010318a:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
80103190:	74 26                	je     801031b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80103192:	8b 43 08             	mov    0x8(%ebx),%eax
80103195:	85 c0                	test   %eax,%eax
80103197:	7f e7                	jg     80103180 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80103199:	85 ff                	test   %edi,%edi
8010319b:	75 e7                	jne    80103184 <iget+0x34>
8010319d:	85 c0                	test   %eax,%eax
8010319f:	75 76                	jne    80103217 <iget+0xc7>
      empty = ip;
801031a1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801031a3:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
801031a9:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
801031af:	75 e1                	jne    80103192 <iget+0x42>
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801031b8:	85 ff                	test   %edi,%edi
801031ba:	74 79                	je     80103235 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801031bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801031bf:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801031c1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801031c4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801031cb:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
801031d2:	00 00 00 
  release(&icache.lock);
801031d5:	68 a0 35 11 80       	push   $0x801135a0
801031da:	e8 d1 37 00 00       	call   801069b0 <release>

  return ip;
801031df:	83 c4 10             	add    $0x10,%esp
}
801031e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031e5:	89 f8                	mov    %edi,%eax
801031e7:	5b                   	pop    %ebx
801031e8:	5e                   	pop    %esi
801031e9:	5f                   	pop    %edi
801031ea:	5d                   	pop    %ebp
801031eb:	c3                   	ret
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801031f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801031f3:	75 8f                	jne    80103184 <iget+0x34>
      ip->ref++;
801031f5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801031f8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801031fb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801031fd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80103200:	68 a0 35 11 80       	push   $0x801135a0
80103205:	e8 a6 37 00 00       	call   801069b0 <release>
      return ip;
8010320a:	83 c4 10             	add    $0x10,%esp
}
8010320d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103210:	89 f8                	mov    %edi,%eax
80103212:	5b                   	pop    %ebx
80103213:	5e                   	pop    %esi
80103214:	5f                   	pop    %edi
80103215:	5d                   	pop    %ebp
80103216:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80103217:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
8010321d:	81 fb b4 5e 11 80    	cmp    $0x80115eb4,%ebx
80103223:	74 10                	je     80103235 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80103225:	8b 43 08             	mov    0x8(%ebx),%eax
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 8f 50 ff ff ff    	jg     80103180 <iget+0x30>
80103230:	e9 68 ff ff ff       	jmp    8010319d <iget+0x4d>
    panic("iget: no inodes");
80103235:	83 ec 0c             	sub    $0xc,%esp
80103238:	68 0d a4 10 80       	push   $0x8010a40d
8010323d:	e8 be db ff ff       	call   80100e00 <panic>
80103242:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103249:	00 
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103250 <bfree>:
{
80103250:	55                   	push   %ebp
80103251:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80103253:	89 d0                	mov    %edx,%eax
80103255:	c1 e8 0c             	shr    $0xc,%eax
{
80103258:	89 e5                	mov    %esp,%ebp
8010325a:	56                   	push   %esi
8010325b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010325c:	03 05 cc 5e 11 80    	add    0x80115ecc,%eax
{
80103262:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80103264:	83 ec 08             	sub    $0x8,%esp
80103267:	50                   	push   %eax
80103268:	51                   	push   %ecx
80103269:	e8 62 ce ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010326e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80103270:	c1 fb 03             	sar    $0x3,%ebx
80103273:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80103276:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80103278:	83 e1 07             	and    $0x7,%ecx
8010327b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80103280:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80103286:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80103288:	0f b6 8c 1e 9c 00 00 	movzbl 0x9c(%esi,%ebx,1),%ecx
8010328f:	00 
80103290:	85 c1                	test   %eax,%ecx
80103292:	74 26                	je     801032ba <bfree+0x6a>
  bp->data[bi/8] &= ~m;
80103294:	f7 d0                	not    %eax
  log_write(bp);
80103296:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80103299:	21 c8                	and    %ecx,%eax
8010329b:	88 84 1e 9c 00 00 00 	mov    %al,0x9c(%esi,%ebx,1)
  log_write(bp);
801032a2:	56                   	push   %esi
801032a3:	e8 98 1b 00 00       	call   80104e40 <log_write>
  brelse(bp);
801032a8:	89 34 24             	mov    %esi,(%esp)
801032ab:	e8 60 cf ff ff       	call   80100210 <brelse>
}
801032b0:	83 c4 10             	add    $0x10,%esp
801032b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032b6:	5b                   	pop    %ebx
801032b7:	5e                   	pop    %esi
801032b8:	5d                   	pop    %ebp
801032b9:	c3                   	ret
    panic("freeing free block");
801032ba:	83 ec 0c             	sub    $0xc,%esp
801032bd:	68 1d a4 10 80       	push   $0x8010a41d
801032c2:	e8 39 db ff ff       	call   80100e00 <panic>
801032c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ce:	00 
801032cf:	90                   	nop

801032d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	89 c6                	mov    %eax,%esi
801032d7:	53                   	push   %ebx
801032d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801032db:	83 fa 0b             	cmp    $0xb,%edx
801032de:	0f 86 8c 00 00 00    	jbe    80103370 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801032e4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801032e7:	83 fb 7f             	cmp    $0x7f,%ebx
801032ea:	0f 87 a2 00 00 00    	ja     80103392 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801032f0:	8b 80 cc 00 00 00    	mov    0xcc(%eax),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 5e                	je     80103358 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801032fa:	83 ec 08             	sub    $0x8,%esp
801032fd:	50                   	push   %eax
801032fe:	ff 36                	push   (%esi)
80103300:	e8 cb cd ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80103305:	83 c4 10             	add    $0x10,%esp
80103308:	8d 9c 98 9c 00 00 00 	lea    0x9c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010330f:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
80103311:	8b 3b                	mov    (%ebx),%edi
80103313:	85 ff                	test   %edi,%edi
80103315:	74 19                	je     80103330 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80103317:	83 ec 0c             	sub    $0xc,%esp
8010331a:	52                   	push   %edx
8010331b:	e8 f0 ce ff ff       	call   80100210 <brelse>
80103320:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80103323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103326:	89 f8                	mov    %edi,%eax
80103328:	5b                   	pop    %ebx
80103329:	5e                   	pop    %esi
8010332a:	5f                   	pop    %edi
8010332b:	5d                   	pop    %ebp
8010332c:	c3                   	ret
8010332d:	8d 76 00             	lea    0x0(%esi),%esi
80103330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80103333:	8b 06                	mov    (%esi),%eax
80103335:	e8 f6 fc ff ff       	call   80103030 <balloc>
      log_write(bp);
8010333a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010333d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80103340:	89 03                	mov    %eax,(%ebx)
80103342:	89 c7                	mov    %eax,%edi
      log_write(bp);
80103344:	52                   	push   %edx
80103345:	e8 f6 1a 00 00       	call   80104e40 <log_write>
8010334a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010334d:	83 c4 10             	add    $0x10,%esp
80103350:	eb c5                	jmp    80103317 <bmap+0x47>
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80103358:	8b 06                	mov    (%esi),%eax
8010335a:	e8 d1 fc ff ff       	call   80103030 <balloc>
8010335f:	89 86 cc 00 00 00    	mov    %eax,0xcc(%esi)
80103365:	eb 93                	jmp    801032fa <bmap+0x2a>
80103367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010336e:	00 
8010336f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80103370:	8d 5a 24             	lea    0x24(%edx),%ebx
80103373:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80103377:	85 ff                	test   %edi,%edi
80103379:	75 a8                	jne    80103323 <bmap+0x53>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010337b:	8b 00                	mov    (%eax),%eax
8010337d:	e8 ae fc ff ff       	call   80103030 <balloc>
80103382:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80103386:	89 c7                	mov    %eax,%edi
}
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338b:	5b                   	pop    %ebx
8010338c:	89 f8                	mov    %edi,%eax
8010338e:	5e                   	pop    %esi
8010338f:	5f                   	pop    %edi
80103390:	5d                   	pop    %ebp
80103391:	c3                   	ret
  panic("bmap: out of range");
80103392:	83 ec 0c             	sub    $0xc,%esp
80103395:	68 30 a4 10 80       	push   $0x8010a430
8010339a:	e8 61 da ff ff       	call   80100e00 <panic>
8010339f:	90                   	nop

801033a0 <readsb>:
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	56                   	push   %esi
801033a4:	53                   	push   %ebx
801033a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801033a8:	83 ec 08             	sub    $0x8,%esp
801033ab:	6a 01                	push   $0x1
801033ad:	ff 75 08             	push   0x8(%ebp)
801033b0:	e8 1b cd ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801033b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801033b8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801033ba:	8d 80 9c 00 00 00    	lea    0x9c(%eax),%eax
801033c0:	6a 1c                	push   $0x1c
801033c2:	50                   	push   %eax
801033c3:	56                   	push   %esi
801033c4:	e8 77 3c 00 00       	call   80107040 <memmove>
  brelse(bp);
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033d2:	5b                   	pop    %ebx
801033d3:	5e                   	pop    %esi
801033d4:	5d                   	pop    %ebp
  brelse(bp);
801033d5:	e9 36 ce ff ff       	jmp    80100210 <brelse>
801033da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033e0 <iinit>:
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	53                   	push   %ebx
801033e4:	bb 20 36 11 80       	mov    $0x80113620,%ebx
801033e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801033ec:	68 43 a4 10 80       	push   $0x8010a443
801033f1:	68 a0 35 11 80       	push   $0x801135a0
801033f6:	e8 05 34 00 00       	call   80106800 <initlock>
  for(i = 0; i < NINODE; i++) {
801033fb:	83 c4 10             	add    $0x10,%esp
801033fe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80103400:	83 ec 08             	sub    $0x8,%esp
80103403:	68 4a a4 10 80       	push   $0x8010a44a
80103408:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80103409:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010340f:	e8 dc 2f 00 00       	call   801063f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	81 fb c0 5e 11 80    	cmp    $0x80115ec0,%ebx
8010341d:	75 e1                	jne    80103400 <iinit+0x20>
  bp = bread(dev, 1);
8010341f:	83 ec 08             	sub    $0x8,%esp
80103422:	6a 01                	push   $0x1
80103424:	ff 75 08             	push   0x8(%ebp)
80103427:	e8 a4 cc ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010342c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010342f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80103431:	8d 80 9c 00 00 00    	lea    0x9c(%eax),%eax
80103437:	6a 1c                	push   $0x1c
80103439:	50                   	push   %eax
8010343a:	68 b4 5e 11 80       	push   $0x80115eb4
8010343f:	e8 fc 3b 00 00       	call   80107040 <memmove>
  brelse(bp);
80103444:	89 1c 24             	mov    %ebx,(%esp)
80103447:	e8 c4 cd ff ff       	call   80100210 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010344c:	ff 35 cc 5e 11 80    	push   0x80115ecc
80103452:	ff 35 c8 5e 11 80    	push   0x80115ec8
80103458:	ff 35 c4 5e 11 80    	push   0x80115ec4
8010345e:	ff 35 c0 5e 11 80    	push   0x80115ec0
80103464:	ff 35 bc 5e 11 80    	push   0x80115ebc
8010346a:	ff 35 b8 5e 11 80    	push   0x80115eb8
80103470:	ff 35 b4 5e 11 80    	push   0x80115eb4
80103476:	68 54 a9 10 80       	push   $0x8010a954
8010347b:	e8 90 e1 ff ff       	call   80101610 <cprintf>
}
80103480:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103483:	83 c4 30             	add    $0x30,%esp
80103486:	c9                   	leave
80103487:	c3                   	ret
80103488:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010348f:	00 

80103490 <ialloc>:
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 1c             	sub    $0x1c,%esp
80103499:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010349c:	83 3d bc 5e 11 80 01 	cmpl   $0x1,0x80115ebc
{
801034a3:	8b 75 08             	mov    0x8(%ebp),%esi
801034a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801034a9:	0f 86 94 00 00 00    	jbe    80103543 <ialloc+0xb3>
801034af:	bf 01 00 00 00       	mov    $0x1,%edi
801034b4:	eb 21                	jmp    801034d7 <ialloc+0x47>
801034b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034bd:	00 
801034be:	66 90                	xchg   %ax,%ax
    brelse(bp);
801034c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801034c3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801034c6:	53                   	push   %ebx
801034c7:	e8 44 cd ff ff       	call   80100210 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801034cc:	83 c4 10             	add    $0x10,%esp
801034cf:	3b 3d bc 5e 11 80    	cmp    0x80115ebc,%edi
801034d5:	73 6c                	jae    80103543 <ialloc+0xb3>
    bp = bread(dev, IBLOCK(inum, sb));
801034d7:	89 f8                	mov    %edi,%eax
801034d9:	83 ec 08             	sub    $0x8,%esp
801034dc:	c1 e8 03             	shr    $0x3,%eax
801034df:	03 05 c8 5e 11 80    	add    0x80115ec8,%eax
801034e5:	50                   	push   %eax
801034e6:	56                   	push   %esi
801034e7:	e8 e4 cb ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801034ec:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801034ef:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801034f1:	89 f8                	mov    %edi,%eax
801034f3:	83 e0 07             	and    $0x7,%eax
801034f6:	c1 e0 06             	shl    $0x6,%eax
801034f9:	8d 8c 03 9c 00 00 00 	lea    0x9c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80103500:	66 83 39 00          	cmpw   $0x0,(%ecx)
80103504:	75 ba                	jne    801034c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80103506:	83 ec 04             	sub    $0x4,%esp
80103509:	6a 40                	push   $0x40
8010350b:	6a 00                	push   $0x0
8010350d:	51                   	push   %ecx
8010350e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103511:	e8 9a 3a 00 00       	call   80106fb0 <memset>
      dip->type = type;
80103516:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010351a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010351d:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80103520:	89 1c 24             	mov    %ebx,(%esp)
80103523:	e8 18 19 00 00       	call   80104e40 <log_write>
      brelse(bp);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 e0 cc ff ff       	call   80100210 <brelse>
      return iget(dev, inum);
80103530:	83 c4 10             	add    $0x10,%esp
}
80103533:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80103536:	89 fa                	mov    %edi,%edx
}
80103538:	5b                   	pop    %ebx
      return iget(dev, inum);
80103539:	89 f0                	mov    %esi,%eax
}
8010353b:	5e                   	pop    %esi
8010353c:	5f                   	pop    %edi
8010353d:	5d                   	pop    %ebp
      return iget(dev, inum);
8010353e:	e9 0d fc ff ff       	jmp    80103150 <iget>
  panic("ialloc: no inodes");
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	68 50 a4 10 80       	push   $0x8010a450
8010354b:	e8 b0 d8 ff ff       	call   80100e00 <panic>

80103550 <iupdate>:
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80103558:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010355b:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80103561:	83 ec 08             	sub    $0x8,%esp
80103564:	c1 e8 03             	shr    $0x3,%eax
80103567:	03 05 c8 5e 11 80    	add    0x80115ec8,%eax
8010356d:	50                   	push   %eax
8010356e:	ff b3 64 ff ff ff    	push   -0x9c(%ebx)
80103574:	e8 57 cb ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80103579:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010357d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80103580:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80103582:	8b 83 68 ff ff ff    	mov    -0x98(%ebx),%eax
80103588:	83 e0 07             	and    $0x7,%eax
8010358b:	c1 e0 06             	shl    $0x6,%eax
8010358e:	8d 84 06 9c 00 00 00 	lea    0x9c(%esi,%eax,1),%eax
  dip->type = ip->type;
80103595:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80103598:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010359c:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
8010359f:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801035a3:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801035a7:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801035ab:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801035af:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801035b3:	8b 53 fc             	mov    -0x4(%ebx),%edx
801035b6:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801035b9:	6a 34                	push   $0x34
801035bb:	53                   	push   %ebx
801035bc:	50                   	push   %eax
801035bd:	e8 7e 3a 00 00       	call   80107040 <memmove>
  log_write(bp);
801035c2:	89 34 24             	mov    %esi,(%esp)
801035c5:	e8 76 18 00 00       	call   80104e40 <log_write>
  brelse(bp);
801035ca:	83 c4 10             	add    $0x10,%esp
801035cd:	89 75 08             	mov    %esi,0x8(%ebp)
}
801035d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d3:	5b                   	pop    %ebx
801035d4:	5e                   	pop    %esi
801035d5:	5d                   	pop    %ebp
  brelse(bp);
801035d6:	e9 35 cc ff ff       	jmp    80100210 <brelse>
801035db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801035e0 <idup>:
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	53                   	push   %ebx
801035e4:	83 ec 10             	sub    $0x10,%esp
801035e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801035ea:	68 a0 35 11 80       	push   $0x801135a0
801035ef:	e8 1c 34 00 00       	call   80106a10 <acquire>
  ip->ref++;
801035f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801035f8:	c7 04 24 a0 35 11 80 	movl   $0x801135a0,(%esp)
801035ff:	e8 ac 33 00 00       	call   801069b0 <release>
}
80103604:	89 d8                	mov    %ebx,%eax
80103606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103609:	c9                   	leave
8010360a:	c3                   	ret
8010360b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103610 <ilock>:
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	56                   	push   %esi
80103614:	53                   	push   %ebx
80103615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80103618:	85 db                	test   %ebx,%ebx
8010361a:	0f 84 d2 00 00 00    	je     801036f2 <ilock+0xe2>
80103620:	8b 53 08             	mov    0x8(%ebx),%edx
80103623:	85 d2                	test   %edx,%edx
80103625:	0f 8e c7 00 00 00    	jle    801036f2 <ilock+0xe2>
  acquiresleep(&ip->lock);
8010362b:	83 ec 0c             	sub    $0xc,%esp
8010362e:	8d 43 0c             	lea    0xc(%ebx),%eax
80103631:	50                   	push   %eax
80103632:	e8 f9 2d 00 00       	call   80106430 <acquiresleep>
  if(ip->valid == 0){
80103637:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	85 c0                	test   %eax,%eax
80103642:	74 0c                	je     80103650 <ilock+0x40>
}
80103644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103647:	5b                   	pop    %ebx
80103648:	5e                   	pop    %esi
80103649:	5d                   	pop    %ebp
8010364a:	c3                   	ret
8010364b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80103650:	8b 43 04             	mov    0x4(%ebx),%eax
80103653:	83 ec 08             	sub    $0x8,%esp
80103656:	c1 e8 03             	shr    $0x3,%eax
80103659:	03 05 c8 5e 11 80    	add    0x80115ec8,%eax
8010365f:	50                   	push   %eax
80103660:	ff 33                	push   (%ebx)
80103662:	e8 69 ca ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80103667:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010366a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010366c:	8b 43 04             	mov    0x4(%ebx),%eax
8010366f:	83 e0 07             	and    $0x7,%eax
80103672:	c1 e0 06             	shl    $0x6,%eax
80103675:	8d 84 06 9c 00 00 00 	lea    0x9c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010367c:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010367f:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80103682:	66 89 93 90 00 00 00 	mov    %dx,0x90(%ebx)
    ip->major = dip->major;
80103689:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
8010368d:	66 89 93 92 00 00 00 	mov    %dx,0x92(%ebx)
    ip->minor = dip->minor;
80103694:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80103698:	66 89 93 94 00 00 00 	mov    %dx,0x94(%ebx)
    ip->nlink = dip->nlink;
8010369f:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801036a3:	66 89 93 96 00 00 00 	mov    %dx,0x96(%ebx)
    ip->size = dip->size;
801036aa:	8b 50 fc             	mov    -0x4(%eax),%edx
801036ad:	89 93 98 00 00 00    	mov    %edx,0x98(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801036b3:	6a 34                	push   $0x34
801036b5:	50                   	push   %eax
801036b6:	8d 83 9c 00 00 00    	lea    0x9c(%ebx),%eax
801036bc:	50                   	push   %eax
801036bd:	e8 7e 39 00 00       	call   80107040 <memmove>
    brelse(bp);
801036c2:	89 34 24             	mov    %esi,(%esp)
801036c5:	e8 46 cb ff ff       	call   80100210 <brelse>
    if(ip->type == 0)
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	66 83 bb 90 00 00 00 	cmpw   $0x0,0x90(%ebx)
801036d4:	00 
    ip->valid = 1;
801036d5:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
801036dc:	00 00 00 
    if(ip->type == 0)
801036df:	0f 85 5f ff ff ff    	jne    80103644 <ilock+0x34>
      panic("ilock: no type");
801036e5:	83 ec 0c             	sub    $0xc,%esp
801036e8:	68 68 a4 10 80       	push   $0x8010a468
801036ed:	e8 0e d7 ff ff       	call   80100e00 <panic>
    panic("ilock");
801036f2:	83 ec 0c             	sub    $0xc,%esp
801036f5:	68 62 a4 10 80       	push   $0x8010a462
801036fa:	e8 01 d7 ff ff       	call   80100e00 <panic>
801036ff:	90                   	nop

80103700 <iunlock>:
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103708:	85 db                	test   %ebx,%ebx
8010370a:	74 28                	je     80103734 <iunlock+0x34>
8010370c:	83 ec 0c             	sub    $0xc,%esp
8010370f:	8d 73 0c             	lea    0xc(%ebx),%esi
80103712:	56                   	push   %esi
80103713:	e8 e8 2d 00 00       	call   80106500 <holdingsleep>
80103718:	83 c4 10             	add    $0x10,%esp
8010371b:	85 c0                	test   %eax,%eax
8010371d:	74 15                	je     80103734 <iunlock+0x34>
8010371f:	8b 43 08             	mov    0x8(%ebx),%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	7e 0e                	jle    80103734 <iunlock+0x34>
  releasesleep(&ip->lock);
80103726:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103729:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010372c:	5b                   	pop    %ebx
8010372d:	5e                   	pop    %esi
8010372e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010372f:	e9 5c 2d 00 00       	jmp    80106490 <releasesleep>
    panic("iunlock");
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	68 77 a4 10 80       	push   $0x8010a477
8010373c:	e8 bf d6 ff ff       	call   80100e00 <panic>
80103741:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103748:	00 
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103750 <iput>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 28             	sub    $0x28,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010375c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010375f:	57                   	push   %edi
80103760:	e8 cb 2c 00 00       	call   80106430 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80103765:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
8010376b:	83 c4 10             	add    $0x10,%esp
8010376e:	85 d2                	test   %edx,%edx
80103770:	74 0a                	je     8010377c <iput+0x2c>
80103772:	66 83 bb 96 00 00 00 	cmpw   $0x0,0x96(%ebx)
80103779:	00 
8010377a:	74 34                	je     801037b0 <iput+0x60>
  releasesleep(&ip->lock);
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	57                   	push   %edi
80103780:	e8 0b 2d 00 00       	call   80106490 <releasesleep>
  acquire(&icache.lock);
80103785:	c7 04 24 a0 35 11 80 	movl   $0x801135a0,(%esp)
8010378c:	e8 7f 32 00 00       	call   80106a10 <acquire>
  ip->ref--;
80103791:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	c7 45 08 a0 35 11 80 	movl   $0x801135a0,0x8(%ebp)
}
8010379f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5f                   	pop    %edi
801037a5:	5d                   	pop    %ebp
  release(&icache.lock);
801037a6:	e9 05 32 00 00       	jmp    801069b0 <release>
801037ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	68 a0 35 11 80       	push   $0x801135a0
801037b8:	e8 53 32 00 00       	call   80106a10 <acquire>
    int r = ip->ref;
801037bd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801037c0:	c7 04 24 a0 35 11 80 	movl   $0x801135a0,(%esp)
801037c7:	e8 e4 31 00 00       	call   801069b0 <release>
    if(r == 1){
801037cc:	83 c4 10             	add    $0x10,%esp
801037cf:	83 fe 01             	cmp    $0x1,%esi
801037d2:	75 a8                	jne    8010377c <iput+0x2c>
801037d4:	8d 8b cc 00 00 00    	lea    0xcc(%ebx),%ecx
801037da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801037dd:	8d b3 9c 00 00 00    	lea    0x9c(%ebx),%esi
801037e3:	89 df                	mov    %ebx,%edi
801037e5:	89 cb                	mov    %ecx,%ebx
801037e7:	eb 0e                	jmp    801037f7 <iput+0xa7>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801037f0:	83 c6 04             	add    $0x4,%esi
801037f3:	39 de                	cmp    %ebx,%esi
801037f5:	74 19                	je     80103810 <iput+0xc0>
    if(ip->addrs[i]){
801037f7:	8b 16                	mov    (%esi),%edx
801037f9:	85 d2                	test   %edx,%edx
801037fb:	74 f3                	je     801037f0 <iput+0xa0>
      bfree(ip->dev, ip->addrs[i]);
801037fd:	8b 07                	mov    (%edi),%eax
801037ff:	e8 4c fa ff ff       	call   80103250 <bfree>
      ip->addrs[i] = 0;
80103804:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010380a:	eb e4                	jmp    801037f0 <iput+0xa0>
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80103810:	89 fb                	mov    %edi,%ebx
80103812:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103815:	8b 83 cc 00 00 00    	mov    0xcc(%ebx),%eax
8010381b:	85 c0                	test   %eax,%eax
8010381d:	75 36                	jne    80103855 <iput+0x105>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010381f:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103826:	00 00 00 
  iupdate(ip);
80103829:	83 ec 0c             	sub    $0xc,%esp
8010382c:	53                   	push   %ebx
8010382d:	e8 1e fd ff ff       	call   80103550 <iupdate>
      ip->type = 0;
80103832:	31 c0                	xor    %eax,%eax
80103834:	66 89 83 90 00 00 00 	mov    %ax,0x90(%ebx)
      iupdate(ip);
8010383b:	89 1c 24             	mov    %ebx,(%esp)
8010383e:	e8 0d fd ff ff       	call   80103550 <iupdate>
      ip->valid = 0;
80103843:	83 c4 10             	add    $0x10,%esp
80103846:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010384d:	00 00 00 
80103850:	e9 27 ff ff ff       	jmp    8010377c <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80103855:	83 ec 08             	sub    $0x8,%esp
80103858:	50                   	push   %eax
80103859:	ff 33                	push   (%ebx)
8010385b:	e8 70 c8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80103860:	83 c4 10             	add    $0x10,%esp
80103863:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80103866:	8d 88 9c 02 00 00    	lea    0x29c(%eax),%ecx
8010386c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010386f:	8d b0 9c 00 00 00    	lea    0x9c(%eax),%esi
80103875:	89 cf                	mov    %ecx,%edi
80103877:	eb 0e                	jmp    80103887 <iput+0x137>
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103880:	83 c6 04             	add    $0x4,%esi
80103883:	39 fe                	cmp    %edi,%esi
80103885:	74 0f                	je     80103896 <iput+0x146>
      if(a[j])
80103887:	8b 16                	mov    (%esi),%edx
80103889:	85 d2                	test   %edx,%edx
8010388b:	74 f3                	je     80103880 <iput+0x130>
        bfree(ip->dev, a[j]);
8010388d:	8b 03                	mov    (%ebx),%eax
8010388f:	e8 bc f9 ff ff       	call   80103250 <bfree>
80103894:	eb ea                	jmp    80103880 <iput+0x130>
    brelse(bp);
80103896:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103899:	83 ec 0c             	sub    $0xc,%esp
8010389c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010389f:	50                   	push   %eax
801038a0:	e8 6b c9 ff ff       	call   80100210 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801038a5:	8b 93 cc 00 00 00    	mov    0xcc(%ebx),%edx
801038ab:	8b 03                	mov    (%ebx),%eax
801038ad:	e8 9e f9 ff ff       	call   80103250 <bfree>
    ip->addrs[NDIRECT] = 0;
801038b2:	83 c4 10             	add    $0x10,%esp
801038b5:	c7 83 cc 00 00 00 00 	movl   $0x0,0xcc(%ebx)
801038bc:	00 00 00 
801038bf:	e9 5b ff ff ff       	jmp    8010381f <iput+0xcf>
801038c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038cb:	00 
801038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038d0 <iunlockput>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	56                   	push   %esi
801038d4:	53                   	push   %ebx
801038d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801038d8:	85 db                	test   %ebx,%ebx
801038da:	74 34                	je     80103910 <iunlockput+0x40>
801038dc:	83 ec 0c             	sub    $0xc,%esp
801038df:	8d 73 0c             	lea    0xc(%ebx),%esi
801038e2:	56                   	push   %esi
801038e3:	e8 18 2c 00 00       	call   80106500 <holdingsleep>
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	85 c0                	test   %eax,%eax
801038ed:	74 21                	je     80103910 <iunlockput+0x40>
801038ef:	8b 43 08             	mov    0x8(%ebx),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	7e 1a                	jle    80103910 <iunlockput+0x40>
  releasesleep(&ip->lock);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	56                   	push   %esi
801038fa:	e8 91 2b 00 00       	call   80106490 <releasesleep>
  iput(ip);
801038ff:	83 c4 10             	add    $0x10,%esp
80103902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103905:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103908:	5b                   	pop    %ebx
80103909:	5e                   	pop    %esi
8010390a:	5d                   	pop    %ebp
  iput(ip);
8010390b:	e9 40 fe ff ff       	jmp    80103750 <iput>
    panic("iunlock");
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	68 77 a4 10 80       	push   $0x8010a477
80103918:	e8 e3 d4 ff ff       	call   80100e00 <panic>
8010391d:	8d 76 00             	lea    0x0(%esi),%esi

80103920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	8b 55 08             	mov    0x8(%ebp),%edx
80103926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80103929:	8b 0a                	mov    (%edx),%ecx
8010392b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010392e:	8b 4a 04             	mov    0x4(%edx),%ecx
80103931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80103934:	0f b7 8a 90 00 00 00 	movzwl 0x90(%edx),%ecx
8010393b:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010393e:	0f b7 8a 96 00 00 00 	movzwl 0x96(%edx),%ecx
80103945:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80103949:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010394f:	89 50 10             	mov    %edx,0x10(%eax)
}
80103952:	5d                   	pop    %ebp
80103953:	c3                   	ret
80103954:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010395b:	00 
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103960 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	83 ec 1c             	sub    $0x1c,%esp
80103969:	8b 75 08             	mov    0x8(%ebp),%esi
8010396c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010396f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
80103972:	66 83 be 90 00 00 00 	cmpw   $0x3,0x90(%esi)
80103979:	03 
{
8010397a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010397d:	89 75 d8             	mov    %esi,-0x28(%ebp)
80103980:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80103983:	0f 84 af 00 00 00    	je     80103a38 <readi+0xd8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80103989:	8b 75 d8             	mov    -0x28(%ebp),%esi
8010398c:	8b 96 98 00 00 00    	mov    0x98(%esi),%edx
80103992:	39 fa                	cmp    %edi,%edx
80103994:	0f 82 c2 00 00 00    	jb     80103a5c <readi+0xfc>
8010399a:	89 f9                	mov    %edi,%ecx
8010399c:	31 db                	xor    %ebx,%ebx
8010399e:	01 c1                	add    %eax,%ecx
801039a0:	0f 92 c3             	setb   %bl
801039a3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801039a6:	0f 82 b0 00 00 00    	jb     80103a5c <readi+0xfc>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801039ac:	89 d3                	mov    %edx,%ebx
801039ae:	29 fb                	sub    %edi,%ebx
801039b0:	39 ca                	cmp    %ecx,%edx
801039b2:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801039b5:	85 c0                	test   %eax,%eax
801039b7:	74 70                	je     80103a29 <readi+0xc9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801039b9:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801039bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039bf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801039c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801039c3:	89 fa                	mov    %edi,%edx
801039c5:	c1 ea 09             	shr    $0x9,%edx
801039c8:	89 d8                	mov    %ebx,%eax
801039ca:	e8 01 f9 ff ff       	call   801032d0 <bmap>
801039cf:	83 ec 08             	sub    $0x8,%esp
801039d2:	50                   	push   %eax
801039d3:	ff 33                	push   (%ebx)
801039d5:	e8 f6 c6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801039da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801039dd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801039e2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801039e4:	89 f8                	mov    %edi,%eax
801039e6:	25 ff 01 00 00       	and    $0x1ff,%eax
801039eb:	29 f3                	sub    %esi,%ebx
801039ed:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801039ef:	8d 84 02 9c 00 00 00 	lea    0x9c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801039f6:	39 d9                	cmp    %ebx,%ecx
801039f8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801039fb:	83 c4 0c             	add    $0xc,%esp
801039fe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801039ff:	01 de                	add    %ebx,%esi
80103a01:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80103a03:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103a06:	50                   	push   %eax
80103a07:	ff 75 e0             	push   -0x20(%ebp)
80103a0a:	e8 31 36 00 00       	call   80107040 <memmove>
    brelse(bp);
80103a0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103a12:	89 14 24             	mov    %edx,(%esp)
80103a15:	e8 f6 c7 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80103a1a:	01 5d e0             	add    %ebx,-0x20(%ebp)
80103a1d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	39 de                	cmp    %ebx,%esi
80103a25:	72 99                	jb     801039c0 <readi+0x60>
80103a27:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80103a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2c:	5b                   	pop    %ebx
80103a2d:	5e                   	pop    %esi
80103a2e:	5f                   	pop    %edi
80103a2f:	5d                   	pop    %ebp
80103a30:	c3                   	ret
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80103a38:	0f bf 96 92 00 00 00 	movswl 0x92(%esi),%edx
80103a3f:	66 83 fa 09          	cmp    $0x9,%dx
80103a43:	77 17                	ja     80103a5c <readi+0xfc>
80103a45:	8b 14 d5 40 35 11 80 	mov    -0x7feecac0(,%edx,8),%edx
80103a4c:	85 d2                	test   %edx,%edx
80103a4e:	74 0c                	je     80103a5c <readi+0xfc>
    return devsw[ip->major].read(ip, dst, n);
80103a50:	89 45 10             	mov    %eax,0x10(%ebp)
}
80103a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a56:	5b                   	pop    %ebx
80103a57:	5e                   	pop    %esi
80103a58:	5f                   	pop    %edi
80103a59:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80103a5a:	ff e2                	jmp    *%edx
      return -1;
80103a5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a61:	eb c6                	jmp    80103a29 <readi+0xc9>
80103a63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a6a:	00 
80103a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 1c             	sub    $0x1c,%esp
80103a79:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103a7f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80103a82:	66 83 b8 90 00 00 00 	cmpw   $0x3,0x90(%eax)
80103a89:	03 
{
80103a8a:	89 7d dc             	mov    %edi,-0x24(%ebp)
80103a8d:	89 75 e0             	mov    %esi,-0x20(%ebp)
80103a90:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80103a93:	0f 84 c7 00 00 00    	je     80103b60 <writei+0xf0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80103a99:	39 b8 98 00 00 00    	cmp    %edi,0x98(%eax)
80103a9f:	0f 82 f7 00 00 00    	jb     80103b9c <writei+0x12c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80103aa5:	8b 75 e0             	mov    -0x20(%ebp),%esi
80103aa8:	89 f2                	mov    %esi,%edx
80103aaa:	01 fa                	add    %edi,%edx
80103aac:	0f 82 ea 00 00 00    	jb     80103b9c <writei+0x12c>
80103ab2:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80103ab8:	0f 87 de 00 00 00    	ja     80103b9c <writei+0x12c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103abe:	85 f6                	test   %esi,%esi
80103ac0:	0f 84 85 00 00 00    	je     80103b4b <writei+0xdb>
80103ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80103acd:	89 45 d8             	mov    %eax,-0x28(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103ad0:	8b 75 d8             	mov    -0x28(%ebp),%esi
80103ad3:	89 fa                	mov    %edi,%edx
80103ad5:	c1 ea 09             	shr    $0x9,%edx
80103ad8:	89 f0                	mov    %esi,%eax
80103ada:	e8 f1 f7 ff ff       	call   801032d0 <bmap>
80103adf:	83 ec 08             	sub    $0x8,%esp
80103ae2:	50                   	push   %eax
80103ae3:	ff 36                	push   (%esi)
80103ae5:	e8 e6 c5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80103aea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103aed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103af0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80103af5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80103af7:	89 f8                	mov    %edi,%eax
80103af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80103afe:	29 d3                	sub    %edx,%ebx
80103b00:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80103b02:	8d 84 06 9c 00 00 00 	lea    0x9c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80103b09:	39 d9                	cmp    %ebx,%ecx
80103b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80103b0e:	83 c4 0c             	add    $0xc,%esp
80103b11:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103b12:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80103b14:	ff 75 dc             	push   -0x24(%ebp)
80103b17:	50                   	push   %eax
80103b18:	e8 23 35 00 00       	call   80107040 <memmove>
    log_write(bp);
80103b1d:	89 34 24             	mov    %esi,(%esp)
80103b20:	e8 1b 13 00 00       	call   80104e40 <log_write>
    brelse(bp);
80103b25:	89 34 24             	mov    %esi,(%esp)
80103b28:	e8 e3 c6 ff ff       	call   80100210 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80103b2d:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80103b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b33:	83 c4 10             	add    $0x10,%esp
80103b36:	01 5d dc             	add    %ebx,-0x24(%ebp)
80103b39:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103b3c:	39 d8                	cmp    %ebx,%eax
80103b3e:	72 90                	jb     80103ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80103b40:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103b43:	39 b8 98 00 00 00    	cmp    %edi,0x98(%eax)
80103b49:	72 3d                	jb     80103b88 <writei+0x118>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80103b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80103b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b51:	5b                   	pop    %ebx
80103b52:	5e                   	pop    %esi
80103b53:	5f                   	pop    %edi
80103b54:	5d                   	pop    %ebp
80103b55:	c3                   	ret
80103b56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b5d:	00 
80103b5e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80103b60:	0f bf 80 92 00 00 00 	movswl 0x92(%eax),%eax
80103b67:	66 83 f8 09          	cmp    $0x9,%ax
80103b6b:	77 2f                	ja     80103b9c <writei+0x12c>
80103b6d:	8b 04 c5 44 35 11 80 	mov    -0x7feecabc(,%eax,8),%eax
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 24                	je     80103b9c <writei+0x12c>
    return devsw[ip->major].write(ip, src, n);
80103b78:	89 75 10             	mov    %esi,0x10(%ebp)
}
80103b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b7e:	5b                   	pop    %ebx
80103b7f:	5e                   	pop    %esi
80103b80:	5f                   	pop    %edi
80103b81:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80103b82:	ff e0                	jmp    *%eax
80103b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80103b88:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80103b8b:	89 b8 98 00 00 00    	mov    %edi,0x98(%eax)
    iupdate(ip);
80103b91:	50                   	push   %eax
80103b92:	e8 b9 f9 ff ff       	call   80103550 <iupdate>
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	eb af                	jmp    80103b4b <writei+0xdb>
      return -1;
80103b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ba1:	eb ab                	jmp    80103b4e <writei+0xde>
80103ba3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103baa:	00 
80103bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80103bb6:	6a 0e                	push   $0xe
80103bb8:	ff 75 0c             	push   0xc(%ebp)
80103bbb:	ff 75 08             	push   0x8(%ebp)
80103bbe:	e8 ed 34 00 00       	call   801070b0 <strncmp>
}
80103bc3:	c9                   	leave
80103bc4:	c3                   	ret
80103bc5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bcc:	00 
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 1c             	sub    $0x1c,%esp
80103bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80103bdc:	66 83 bb 90 00 00 00 	cmpw   $0x1,0x90(%ebx)
80103be3:	01 
80103be4:	0f 85 92 00 00 00    	jne    80103c7c <dirlookup+0xac>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80103bea:	8b 93 98 00 00 00    	mov    0x98(%ebx),%edx
80103bf0:	31 ff                	xor    %edi,%edi
80103bf2:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103bf5:	85 d2                	test   %edx,%edx
80103bf7:	74 43                	je     80103c3c <dirlookup+0x6c>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103c00:	6a 10                	push   $0x10
80103c02:	57                   	push   %edi
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	e8 56 fd ff ff       	call   80103960 <readi>
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	83 f8 10             	cmp    $0x10,%eax
80103c10:	75 5d                	jne    80103c6f <dirlookup+0x9f>
      panic("dirlookup read");
    if(de.inum == 0)
80103c12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80103c17:	74 18                	je     80103c31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80103c19:	83 ec 04             	sub    $0x4,%esp
80103c1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80103c1f:	6a 0e                	push   $0xe
80103c21:	50                   	push   %eax
80103c22:	ff 75 0c             	push   0xc(%ebp)
80103c25:	e8 86 34 00 00       	call   801070b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80103c2a:	83 c4 10             	add    $0x10,%esp
80103c2d:	85 c0                	test   %eax,%eax
80103c2f:	74 1f                	je     80103c50 <dirlookup+0x80>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103c31:	83 c7 10             	add    $0x10,%edi
80103c34:	3b bb 98 00 00 00    	cmp    0x98(%ebx),%edi
80103c3a:	72 c4                	jb     80103c00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80103c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c3f:	31 c0                	xor    %eax,%eax
}
80103c41:	5b                   	pop    %ebx
80103c42:	5e                   	pop    %esi
80103c43:	5f                   	pop    %edi
80103c44:	5d                   	pop    %ebp
80103c45:	c3                   	ret
80103c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4d:	00 
80103c4e:	66 90                	xchg   %ax,%ax
      if(poff)
80103c50:	8b 45 10             	mov    0x10(%ebp),%eax
80103c53:	85 c0                	test   %eax,%eax
80103c55:	74 05                	je     80103c5c <dirlookup+0x8c>
        *poff = off;
80103c57:	8b 45 10             	mov    0x10(%ebp),%eax
80103c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80103c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80103c60:	8b 03                	mov    (%ebx),%eax
80103c62:	e8 e9 f4 ff ff       	call   80103150 <iget>
}
80103c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c6a:	5b                   	pop    %ebx
80103c6b:	5e                   	pop    %esi
80103c6c:	5f                   	pop    %edi
80103c6d:	5d                   	pop    %ebp
80103c6e:	c3                   	ret
      panic("dirlookup read");
80103c6f:	83 ec 0c             	sub    $0xc,%esp
80103c72:	68 91 a4 10 80       	push   $0x8010a491
80103c77:	e8 84 d1 ff ff       	call   80100e00 <panic>
    panic("dirlookup not DIR");
80103c7c:	83 ec 0c             	sub    $0xc,%esp
80103c7f:	68 7f a4 10 80       	push   $0x8010a47f
80103c84:	e8 77 d1 ff ff       	call   80100e00 <panic>
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	89 c3                	mov    %eax,%ebx
80103c98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80103c9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80103c9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80103ca1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80103ca4:	0f 84 ae 01 00 00    	je     80103e58 <namex+0x1c8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80103caa:	e8 f1 1b 00 00       	call   801058a0 <myproc>
  acquire(&icache.lock);
80103caf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80103cb2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80103cb5:	68 a0 35 11 80       	push   $0x801135a0
80103cba:	e8 51 2d 00 00       	call   80106a10 <acquire>
  ip->ref++;
80103cbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80103cc3:	c7 04 24 a0 35 11 80 	movl   $0x801135a0,(%esp)
80103cca:	e8 e1 2c 00 00       	call   801069b0 <release>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	eb 07                	jmp    80103cdb <namex+0x4b>
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80103cdb:	0f b6 03             	movzbl (%ebx),%eax
80103cde:	3c 2f                	cmp    $0x2f,%al
80103ce0:	74 f6                	je     80103cd8 <namex+0x48>
  if(*path == 0)
80103ce2:	84 c0                	test   %al,%al
80103ce4:	0f 84 16 01 00 00    	je     80103e00 <namex+0x170>
  while(*path != '/' && *path != 0)
80103cea:	0f b6 03             	movzbl (%ebx),%eax
80103ced:	84 c0                	test   %al,%al
80103cef:	0f 84 20 01 00 00    	je     80103e15 <namex+0x185>
80103cf5:	89 df                	mov    %ebx,%edi
80103cf7:	3c 2f                	cmp    $0x2f,%al
80103cf9:	0f 84 16 01 00 00    	je     80103e15 <namex+0x185>
80103cff:	90                   	nop
80103d00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80103d04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80103d07:	3c 2f                	cmp    $0x2f,%al
80103d09:	74 04                	je     80103d0f <namex+0x7f>
80103d0b:	84 c0                	test   %al,%al
80103d0d:	75 f1                	jne    80103d00 <namex+0x70>
  len = path - s;
80103d0f:	89 f8                	mov    %edi,%eax
80103d11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80103d13:	83 f8 0d             	cmp    $0xd,%eax
80103d16:	0f 8e b4 00 00 00    	jle    80103dd0 <namex+0x140>
    memmove(name, s, DIRSIZ);
80103d1c:	83 ec 04             	sub    $0x4,%esp
80103d1f:	6a 0e                	push   $0xe
80103d21:	53                   	push   %ebx
80103d22:	89 fb                	mov    %edi,%ebx
80103d24:	ff 75 e4             	push   -0x1c(%ebp)
80103d27:	e8 14 33 00 00       	call   80107040 <memmove>
80103d2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103d2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80103d32:	75 0c                	jne    80103d40 <namex+0xb0>
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80103d38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80103d3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80103d3e:	74 f8                	je     80103d38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	56                   	push   %esi
80103d44:	e8 c7 f8 ff ff       	call   80103610 <ilock>
    if(ip->type != T_DIR){
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	66 83 be 90 00 00 00 	cmpw   $0x1,0x90(%esi)
80103d53:	01 
80103d54:	0f 85 c4 00 00 00    	jne    80103e1e <namex+0x18e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80103d5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103d5d:	85 c0                	test   %eax,%eax
80103d5f:	74 09                	je     80103d6a <namex+0xda>
80103d61:	80 3b 00             	cmpb   $0x0,(%ebx)
80103d64:	0f 84 04 01 00 00    	je     80103e6e <namex+0x1de>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80103d6a:	83 ec 04             	sub    $0x4,%esp
80103d6d:	6a 00                	push   $0x0
80103d6f:	ff 75 e4             	push   -0x1c(%ebp)
80103d72:	56                   	push   %esi
80103d73:	e8 58 fe ff ff       	call   80103bd0 <dirlookup>
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	89 c7                	mov    %eax,%edi
80103d7d:	85 c0                	test   %eax,%eax
80103d7f:	0f 84 99 00 00 00    	je     80103e1e <namex+0x18e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103d85:	83 ec 0c             	sub    $0xc,%esp
80103d88:	8d 4e 0c             	lea    0xc(%esi),%ecx
80103d8b:	51                   	push   %ecx
80103d8c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103d8f:	e8 6c 27 00 00       	call   80106500 <holdingsleep>
80103d94:	83 c4 10             	add    $0x10,%esp
80103d97:	85 c0                	test   %eax,%eax
80103d99:	0f 84 0f 01 00 00    	je     80103eae <namex+0x21e>
80103d9f:	8b 56 08             	mov    0x8(%esi),%edx
80103da2:	85 d2                	test   %edx,%edx
80103da4:	0f 8e 04 01 00 00    	jle    80103eae <namex+0x21e>
  releasesleep(&ip->lock);
80103daa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103dad:	83 ec 0c             	sub    $0xc,%esp
80103db0:	51                   	push   %ecx
80103db1:	e8 da 26 00 00       	call   80106490 <releasesleep>
  iput(ip);
80103db6:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80103db9:	89 fe                	mov    %edi,%esi
  iput(ip);
80103dbb:	e8 90 f9 ff ff       	call   80103750 <iput>
80103dc0:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80103dc3:	e9 13 ff ff ff       	jmp    80103cdb <namex+0x4b>
80103dc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dcf:	00 
    name[len] = 0;
80103dd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dd3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80103dd6:	83 ec 04             	sub    $0x4,%esp
80103dd9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103ddc:	50                   	push   %eax
80103ddd:	53                   	push   %ebx
    name[len] = 0;
80103dde:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80103de0:	ff 75 e4             	push   -0x1c(%ebp)
80103de3:	e8 58 32 00 00       	call   80107040 <memmove>
    name[len] = 0;
80103de8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103deb:	83 c4 10             	add    $0x10,%esp
80103dee:	c6 01 00             	movb   $0x0,(%ecx)
80103df1:	e9 39 ff ff ff       	jmp    80103d2f <namex+0x9f>
80103df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dfd:	00 
80103dfe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80103e00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103e03:	85 c0                	test   %eax,%eax
80103e05:	0f 85 93 00 00 00    	jne    80103e9e <namex+0x20e>
    iput(ip);
    return 0;
  }
  return ip;
}
80103e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e0e:	89 f0                	mov    %esi,%eax
80103e10:	5b                   	pop    %ebx
80103e11:	5e                   	pop    %esi
80103e12:	5f                   	pop    %edi
80103e13:	5d                   	pop    %ebp
80103e14:	c3                   	ret
  while(*path != '/' && *path != 0)
80103e15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e18:	89 df                	mov    %ebx,%edi
80103e1a:	31 c0                	xor    %eax,%eax
80103e1c:	eb b8                	jmp    80103dd6 <namex+0x146>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103e1e:	83 ec 0c             	sub    $0xc,%esp
80103e21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103e24:	53                   	push   %ebx
80103e25:	e8 d6 26 00 00       	call   80106500 <holdingsleep>
80103e2a:	83 c4 10             	add    $0x10,%esp
80103e2d:	85 c0                	test   %eax,%eax
80103e2f:	74 7d                	je     80103eae <namex+0x21e>
80103e31:	8b 4e 08             	mov    0x8(%esi),%ecx
80103e34:	85 c9                	test   %ecx,%ecx
80103e36:	7e 76                	jle    80103eae <namex+0x21e>
  releasesleep(&ip->lock);
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	53                   	push   %ebx
80103e3c:	e8 4f 26 00 00       	call   80106490 <releasesleep>
  iput(ip);
80103e41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80103e44:	31 f6                	xor    %esi,%esi
  iput(ip);
80103e46:	e8 05 f9 ff ff       	call   80103750 <iput>
      return 0;
80103e4b:	83 c4 10             	add    $0x10,%esp
}
80103e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e51:	89 f0                	mov    %esi,%eax
80103e53:	5b                   	pop    %ebx
80103e54:	5e                   	pop    %esi
80103e55:	5f                   	pop    %edi
80103e56:	5d                   	pop    %ebp
80103e57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80103e58:	ba 01 00 00 00       	mov    $0x1,%edx
80103e5d:	b8 01 00 00 00       	mov    $0x1,%eax
80103e62:	e8 e9 f2 ff ff       	call   80103150 <iget>
80103e67:	89 c6                	mov    %eax,%esi
80103e69:	e9 6d fe ff ff       	jmp    80103cdb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80103e6e:	83 ec 0c             	sub    $0xc,%esp
80103e71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103e74:	53                   	push   %ebx
80103e75:	e8 86 26 00 00       	call   80106500 <holdingsleep>
80103e7a:	83 c4 10             	add    $0x10,%esp
80103e7d:	85 c0                	test   %eax,%eax
80103e7f:	74 2d                	je     80103eae <namex+0x21e>
80103e81:	8b 7e 08             	mov    0x8(%esi),%edi
80103e84:	85 ff                	test   %edi,%edi
80103e86:	7e 26                	jle    80103eae <namex+0x21e>
  releasesleep(&ip->lock);
80103e88:	83 ec 0c             	sub    $0xc,%esp
80103e8b:	53                   	push   %ebx
80103e8c:	e8 ff 25 00 00       	call   80106490 <releasesleep>
}
80103e91:	83 c4 10             	add    $0x10,%esp
}
80103e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e97:	89 f0                	mov    %esi,%eax
80103e99:	5b                   	pop    %ebx
80103e9a:	5e                   	pop    %esi
80103e9b:	5f                   	pop    %edi
80103e9c:	5d                   	pop    %ebp
80103e9d:	c3                   	ret
    iput(ip);
80103e9e:	83 ec 0c             	sub    $0xc,%esp
80103ea1:	56                   	push   %esi
      return 0;
80103ea2:	31 f6                	xor    %esi,%esi
    iput(ip);
80103ea4:	e8 a7 f8 ff ff       	call   80103750 <iput>
    return 0;
80103ea9:	83 c4 10             	add    $0x10,%esp
80103eac:	eb a0                	jmp    80103e4e <namex+0x1be>
    panic("iunlock");
80103eae:	83 ec 0c             	sub    $0xc,%esp
80103eb1:	68 77 a4 10 80       	push   $0x8010a477
80103eb6:	e8 45 cf ff ff       	call   80100e00 <panic>
80103ebb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ec0 <dirlink>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 20             	sub    $0x20,%esp
80103ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80103ecc:	6a 00                	push   $0x0
80103ece:	ff 75 0c             	push   0xc(%ebp)
80103ed1:	53                   	push   %ebx
80103ed2:	e8 f9 fc ff ff       	call   80103bd0 <dirlookup>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	75 72                	jne    80103f50 <dirlink+0x90>
  for(off = 0; off < dp->size; off += sizeof(de)){
80103ede:	8b bb 98 00 00 00    	mov    0x98(%ebx),%edi
80103ee4:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103ee7:	85 ff                	test   %edi,%edi
80103ee9:	74 31                	je     80103f1c <dirlink+0x5c>
80103eeb:	31 ff                	xor    %edi,%edi
80103eed:	8d 75 d8             	lea    -0x28(%ebp),%esi
80103ef0:	eb 11                	jmp    80103f03 <dirlink+0x43>
80103ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ef8:	83 c7 10             	add    $0x10,%edi
80103efb:	3b bb 98 00 00 00    	cmp    0x98(%ebx),%edi
80103f01:	73 19                	jae    80103f1c <dirlink+0x5c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103f03:	6a 10                	push   $0x10
80103f05:	57                   	push   %edi
80103f06:	56                   	push   %esi
80103f07:	53                   	push   %ebx
80103f08:	e8 53 fa ff ff       	call   80103960 <readi>
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	83 f8 10             	cmp    $0x10,%eax
80103f13:	75 4e                	jne    80103f63 <dirlink+0xa3>
    if(de.inum == 0)
80103f15:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80103f1a:	75 dc                	jne    80103ef8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80103f1c:	83 ec 04             	sub    $0x4,%esp
80103f1f:	8d 45 da             	lea    -0x26(%ebp),%eax
80103f22:	6a 0e                	push   $0xe
80103f24:	ff 75 0c             	push   0xc(%ebp)
80103f27:	50                   	push   %eax
80103f28:	e8 d3 31 00 00       	call   80107100 <strncpy>
  de.inum = inum;
80103f2d:	8b 45 10             	mov    0x10(%ebp),%eax
80103f30:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80103f34:	6a 10                	push   $0x10
80103f36:	57                   	push   %edi
80103f37:	56                   	push   %esi
80103f38:	53                   	push   %ebx
80103f39:	e8 32 fb ff ff       	call   80103a70 <writei>
80103f3e:	83 c4 20             	add    $0x20,%esp
80103f41:	83 f8 10             	cmp    $0x10,%eax
80103f44:	75 2a                	jne    80103f70 <dirlink+0xb0>
  return 0;
80103f46:	31 c0                	xor    %eax,%eax
}
80103f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f4b:	5b                   	pop    %ebx
80103f4c:	5e                   	pop    %esi
80103f4d:	5f                   	pop    %edi
80103f4e:	5d                   	pop    %ebp
80103f4f:	c3                   	ret
    iput(ip);
80103f50:	83 ec 0c             	sub    $0xc,%esp
80103f53:	50                   	push   %eax
80103f54:	e8 f7 f7 ff ff       	call   80103750 <iput>
    return -1;
80103f59:	83 c4 10             	add    $0x10,%esp
80103f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f61:	eb e5                	jmp    80103f48 <dirlink+0x88>
      panic("dirlink read");
80103f63:	83 ec 0c             	sub    $0xc,%esp
80103f66:	68 a0 a4 10 80       	push   $0x8010a4a0
80103f6b:	e8 90 ce ff ff       	call   80100e00 <panic>
    panic("dirlink");
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	68 d5 a7 10 80       	push   $0x8010a7d5
80103f78:	e8 83 ce ff ff       	call   80100e00 <panic>
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi

80103f80 <namei>:

struct inode*
namei(char *path)
{
80103f80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80103f81:	31 d2                	xor    %edx,%edx
{
80103f83:	89 e5                	mov    %esp,%ebp
80103f85:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80103f88:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80103f8e:	e8 fd fc ff ff       	call   80103c90 <namex>
}
80103f93:	c9                   	leave
80103f94:	c3                   	ret
80103f95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f9c:	00 
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi

80103fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80103fa0:	55                   	push   %ebp
  return namex(path, 1, name);
80103fa1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103fa6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80103fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103fae:	5d                   	pop    %ebp
  return namex(path, 1, name);
80103faf:	e9 dc fc ff ff       	jmp    80103c90 <namex>
80103fb4:	66 90                	xchg   %ax,%ax
80103fb6:	66 90                	xchg   %ax,%ax
80103fb8:	66 90                	xchg   %ax,%ax
80103fba:	66 90                	xchg   %ax,%ax
80103fbc:	66 90                	xchg   %ax,%ax
80103fbe:	66 90                	xchg   %ax,%ax

80103fc0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80103fc9:	85 c0                	test   %eax,%eax
80103fcb:	0f 84 b7 00 00 00    	je     80104088 <idestart+0xc8>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80103fd1:	8b 70 08             	mov    0x8(%eax),%esi
80103fd4:	89 c3                	mov    %eax,%ebx
80103fd6:	81 fe cf 07 00 00    	cmp    $0x7cf,%esi
80103fdc:	0f 87 99 00 00 00    	ja     8010407b <idestart+0xbb>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fe2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80103fe7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fee:	00 
80103fef:	90                   	nop
80103ff0:	89 ca                	mov    %ecx,%edx
80103ff2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80103ff3:	83 e0 c0             	and    $0xffffffc0,%eax
80103ff6:	3c 40                	cmp    $0x40,%al
80103ff8:	75 f6                	jne    80103ff0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ffa:	31 ff                	xor    %edi,%edi
80103ffc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80104001:	89 f8                	mov    %edi,%eax
80104003:	ee                   	out    %al,(%dx)
80104004:	b8 01 00 00 00       	mov    $0x1,%eax
80104009:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010400e:	ee                   	out    %al,(%dx)
8010400f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80104014:	89 f0                	mov    %esi,%eax
80104016:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80104017:	89 f0                	mov    %esi,%eax
80104019:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010401e:	c1 f8 08             	sar    $0x8,%eax
80104021:	ee                   	out    %al,(%dx)
80104022:	ba f5 01 00 00       	mov    $0x1f5,%edx
80104027:	89 f8                	mov    %edi,%eax
80104029:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010402a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010402e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80104033:	c1 e0 04             	shl    $0x4,%eax
80104036:	83 e0 10             	and    $0x10,%eax
80104039:	83 c8 e0             	or     $0xffffffe0,%eax
8010403c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010403d:	f6 03 04             	testb  $0x4,(%ebx)
80104040:	75 16                	jne    80104058 <idestart+0x98>
80104042:	b8 20 00 00 00       	mov    $0x20,%eax
80104047:	89 ca                	mov    %ecx,%edx
80104049:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010404a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010404d:	5b                   	pop    %ebx
8010404e:	5e                   	pop    %esi
8010404f:	5f                   	pop    %edi
80104050:	5d                   	pop    %ebp
80104051:	c3                   	ret
80104052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104058:	b8 30 00 00 00       	mov    $0x30,%eax
8010405d:	89 ca                	mov    %ecx,%edx
8010405f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80104060:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80104065:	8d b3 9c 00 00 00    	lea    0x9c(%ebx),%esi
8010406b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80104070:	fc                   	cld
80104071:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80104073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104076:	5b                   	pop    %ebx
80104077:	5e                   	pop    %esi
80104078:	5f                   	pop    %edi
80104079:	5d                   	pop    %ebp
8010407a:	c3                   	ret
    panic("incorrect blockno");
8010407b:	83 ec 0c             	sub    $0xc,%esp
8010407e:	68 b6 a4 10 80       	push   $0x8010a4b6
80104083:	e8 78 cd ff ff       	call   80100e00 <panic>
    panic("idestart");
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 ad a4 10 80       	push   $0x8010a4ad
80104090:	e8 6b cd ff ff       	call   80100e00 <panic>
80104095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010409c:	00 
8010409d:	8d 76 00             	lea    0x0(%esi),%esi

801040a0 <ideinit>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801040a6:	68 c8 a4 10 80       	push   $0x8010a4c8
801040ab:	68 00 5f 11 80       	push   $0x80115f00
801040b0:	e8 4b 27 00 00       	call   80106800 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801040b5:	58                   	pop    %eax
801040b6:	a1 44 61 11 80       	mov    0x80116144,%eax
801040bb:	5a                   	pop    %edx
801040bc:	83 e8 01             	sub    $0x1,%eax
801040bf:	50                   	push   %eax
801040c0:	6a 0e                	push   $0xe
801040c2:	e8 a9 02 00 00       	call   80104370 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801040c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801040ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801040cf:	90                   	nop
801040d0:	89 ca                	mov    %ecx,%edx
801040d2:	ec                   	in     (%dx),%al
801040d3:	83 e0 c0             	and    $0xffffffc0,%eax
801040d6:	3c 40                	cmp    $0x40,%al
801040d8:	75 f6                	jne    801040d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801040da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801040df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801040e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801040e5:	89 ca                	mov    %ecx,%edx
801040e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801040e8:	84 c0                	test   %al,%al
801040ea:	75 1e                	jne    8010410a <ideinit+0x6a>
801040ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801040f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801040f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040fd:	00 
801040fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80104100:	83 e9 01             	sub    $0x1,%ecx
80104103:	74 0f                	je     80104114 <ideinit+0x74>
80104105:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80104106:	84 c0                	test   %al,%al
80104108:	74 f6                	je     80104100 <ideinit+0x60>
      havedisk1 = 1;
8010410a:	c7 05 e0 5e 11 80 01 	movl   $0x1,0x80115ee0
80104111:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104114:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80104119:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010411e:	ee                   	out    %al,(%dx)
}
8010411f:	c9                   	leave
80104120:	c3                   	ret
80104121:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104128:	00 
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104130 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	57                   	push   %edi
80104134:	56                   	push   %esi
80104135:	53                   	push   %ebx
80104136:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80104139:	68 00 5f 11 80       	push   $0x80115f00
8010413e:	e8 cd 28 00 00       	call   80106a10 <acquire>

  if((b = idequeue) == 0){
80104143:	8b 1d e4 5e 11 80    	mov    0x80115ee4,%ebx
80104149:	83 c4 10             	add    $0x10,%esp
8010414c:	85 db                	test   %ebx,%ebx
8010414e:	74 66                	je     801041b6 <ideintr+0x86>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80104150:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
80104156:	a3 e4 5e 11 80       	mov    %eax,0x80115ee4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010415b:	8b 33                	mov    (%ebx),%esi
8010415d:	f7 c6 04 00 00 00    	test   $0x4,%esi
80104163:	75 2f                	jne    80104194 <ideintr+0x64>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104165:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104170:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80104171:	89 c1                	mov    %eax,%ecx
80104173:	83 e1 c0             	and    $0xffffffc0,%ecx
80104176:	80 f9 40             	cmp    $0x40,%cl
80104179:	75 f5                	jne    80104170 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010417b:	a8 21                	test   $0x21,%al
8010417d:	75 15                	jne    80104194 <ideintr+0x64>
    insl(0x1f0, b->data, BSIZE/4);
8010417f:	8d bb 9c 00 00 00    	lea    0x9c(%ebx),%edi
  asm volatile("cld; rep insl" :
80104185:	b9 80 00 00 00       	mov    $0x80,%ecx
8010418a:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010418f:	fc                   	cld
80104190:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80104192:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80104194:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80104197:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
8010419a:	83 ce 02             	or     $0x2,%esi
8010419d:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010419f:	53                   	push   %ebx
801041a0:	e8 9b 1e 00 00       	call   80106040 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801041a5:	a1 e4 5e 11 80       	mov    0x80115ee4,%eax
801041aa:	83 c4 10             	add    $0x10,%esp
801041ad:	85 c0                	test   %eax,%eax
801041af:	74 05                	je     801041b6 <ideintr+0x86>
    idestart(idequeue);
801041b1:	e8 0a fe ff ff       	call   80103fc0 <idestart>
    release(&idelock);
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	68 00 5f 11 80       	push   $0x80115f00
801041be:	e8 ed 27 00 00       	call   801069b0 <release>

  release(&idelock);
}
801041c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c6:	5b                   	pop    %ebx
801041c7:	5e                   	pop    %esi
801041c8:	5f                   	pop    %edi
801041c9:	5d                   	pop    %ebp
801041ca:	c3                   	ret
801041cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801041d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
801041d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801041da:	8d 43 0c             	lea    0xc(%ebx),%eax
801041dd:	50                   	push   %eax
801041de:	e8 1d 23 00 00       	call   80106500 <holdingsleep>
801041e3:	83 c4 10             	add    $0x10,%esp
801041e6:	85 c0                	test   %eax,%eax
801041e8:	0f 84 d3 00 00 00    	je     801042c1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801041ee:	8b 03                	mov    (%ebx),%eax
801041f0:	83 e0 06             	and    $0x6,%eax
801041f3:	83 f8 02             	cmp    $0x2,%eax
801041f6:	0f 84 b8 00 00 00    	je     801042b4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801041fc:	8b 53 04             	mov    0x4(%ebx),%edx
801041ff:	85 d2                	test   %edx,%edx
80104201:	74 0d                	je     80104210 <iderw+0x40>
80104203:	a1 e0 5e 11 80       	mov    0x80115ee0,%eax
80104208:	85 c0                	test   %eax,%eax
8010420a:	0f 84 97 00 00 00    	je     801042a7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 00 5f 11 80       	push   $0x80115f00
80104218:	e8 f3 27 00 00       	call   80106a10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010421d:	a1 e4 5e 11 80       	mov    0x80115ee4,%eax
80104222:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80104225:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
8010422c:	00 00 00 
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010422f:	85 c0                	test   %eax,%eax
80104231:	74 6d                	je     801042a0 <iderw+0xd0>
80104233:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104238:	89 c2                	mov    %eax,%edx
8010423a:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104240:	85 c0                	test   %eax,%eax
80104242:	75 f4                	jne    80104238 <iderw+0x68>
80104244:	81 c2 98 00 00 00    	add    $0x98,%edx
    ;
  *pp = b;
8010424a:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010424c:	39 1d e4 5e 11 80    	cmp    %ebx,0x80115ee4
80104252:	74 3c                	je     80104290 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80104254:	8b 03                	mov    (%ebx),%eax
80104256:	83 e0 06             	and    $0x6,%eax
80104259:	83 f8 02             	cmp    $0x2,%eax
8010425c:	74 1d                	je     8010427b <iderw+0xab>
8010425e:	66 90                	xchg   %ax,%ax
    sleep(b, &idelock);
80104260:	83 ec 08             	sub    $0x8,%esp
80104263:	68 00 5f 11 80       	push   $0x80115f00
80104268:	53                   	push   %ebx
80104269:	e8 12 1d 00 00       	call   80105f80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010426e:	8b 03                	mov    (%ebx),%eax
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	83 e0 06             	and    $0x6,%eax
80104276:	83 f8 02             	cmp    $0x2,%eax
80104279:	75 e5                	jne    80104260 <iderw+0x90>
  }


  release(&idelock);
8010427b:	c7 45 08 00 5f 11 80 	movl   $0x80115f00,0x8(%ebp)
}
80104282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104285:	c9                   	leave
  release(&idelock);
80104286:	e9 25 27 00 00       	jmp    801069b0 <release>
8010428b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80104290:	89 d8                	mov    %ebx,%eax
80104292:	e8 29 fd ff ff       	call   80103fc0 <idestart>
80104297:	eb bb                	jmp    80104254 <iderw+0x84>
80104299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801042a0:	ba e4 5e 11 80       	mov    $0x80115ee4,%edx
801042a5:	eb a3                	jmp    8010424a <iderw+0x7a>
    panic("iderw: ide disk 1 not present");
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	68 f7 a4 10 80       	push   $0x8010a4f7
801042af:	e8 4c cb ff ff       	call   80100e00 <panic>
    panic("iderw: nothing to do");
801042b4:	83 ec 0c             	sub    $0xc,%esp
801042b7:	68 e2 a4 10 80       	push   $0x8010a4e2
801042bc:	e8 3f cb ff ff       	call   80100e00 <panic>
    panic("iderw: buf not locked");
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	68 cc a4 10 80       	push   $0x8010a4cc
801042c9:	e8 32 cb ff ff       	call   80100e00 <panic>
801042ce:	66 90                	xchg   %ax,%ax

801042d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	56                   	push   %esi
801042d4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801042d5:	c7 05 74 5f 11 80 00 	movl   $0xfec00000,0x80115f74
801042dc:	00 c0 fe 
  ioapic->reg = reg;
801042df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801042e6:	00 00 00 
  return ioapic->data;
801042e9:	8b 15 74 5f 11 80    	mov    0x80115f74,%edx
801042ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801042f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801042f8:	8b 1d 74 5f 11 80    	mov    0x80115f74,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801042fe:	0f b6 15 40 61 11 80 	movzbl 0x80116140,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80104305:	c1 ee 10             	shr    $0x10,%esi
80104308:	89 f0                	mov    %esi,%eax
8010430a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010430d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80104310:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80104313:	39 c2                	cmp    %eax,%edx
80104315:	74 16                	je     8010432d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80104317:	83 ec 0c             	sub    $0xc,%esp
8010431a:	68 a8 a9 10 80       	push   $0x8010a9a8
8010431f:	e8 ec d2 ff ff       	call   80101610 <cprintf>
  ioapic->reg = reg;
80104324:	8b 1d 74 5f 11 80    	mov    0x80115f74,%ebx
8010432a:	83 c4 10             	add    $0x10,%esp
{
8010432d:	ba 10 00 00 00       	mov    $0x10,%edx
80104332:	31 c0                	xor    %eax,%eax
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80104338:	89 13                	mov    %edx,(%ebx)
8010433a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010433d:	8b 1d 74 5f 11 80    	mov    0x80115f74,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80104343:	83 c0 01             	add    $0x1,%eax
80104346:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010434c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010434f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80104352:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80104355:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80104357:	8b 1d 74 5f 11 80    	mov    0x80115f74,%ebx
8010435d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80104364:	39 c6                	cmp    %eax,%esi
80104366:	7d d0                	jge    80104338 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80104368:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010436b:	5b                   	pop    %ebx
8010436c:	5e                   	pop    %esi
8010436d:	5d                   	pop    %ebp
8010436e:	c3                   	ret
8010436f:	90                   	nop

80104370 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80104370:	55                   	push   %ebp
  ioapic->reg = reg;
80104371:	8b 0d 74 5f 11 80    	mov    0x80115f74,%ecx
{
80104377:	89 e5                	mov    %esp,%ebp
80104379:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010437c:	8d 50 20             	lea    0x20(%eax),%edx
8010437f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80104383:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104385:	8b 0d 74 5f 11 80    	mov    0x80115f74,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010438b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010438e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80104391:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80104394:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80104396:	a1 74 5f 11 80       	mov    0x80115f74,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010439b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010439e:	89 50 10             	mov    %edx,0x10(%eax)
}
801043a1:	5d                   	pop    %ebp
801043a2:	c3                   	ret
801043a3:	66 90                	xchg   %ax,%ax
801043a5:	66 90                	xchg   %ax,%ax
801043a7:	66 90                	xchg   %ax,%ax
801043a9:	66 90                	xchg   %ax,%ax
801043ab:	66 90                	xchg   %ax,%ax
801043ad:	66 90                	xchg   %ax,%ax
801043af:	90                   	nop

801043b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 04             	sub    $0x4,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801043ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801043c0:	75 76                	jne    80104438 <kfree+0x88>
801043c2:	81 fb f0 a1 11 80    	cmp    $0x8011a1f0,%ebx
801043c8:	72 6e                	jb     80104438 <kfree+0x88>
801043ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801043d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801043d5:	77 61                	ja     80104438 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801043d7:	83 ec 04             	sub    $0x4,%esp
801043da:	68 00 10 00 00       	push   $0x1000
801043df:	6a 01                	push   $0x1
801043e1:	53                   	push   %ebx
801043e2:	e8 c9 2b 00 00       	call   80106fb0 <memset>

  if(kmem.use_lock)
801043e7:	8b 15 f4 5f 11 80    	mov    0x80115ff4,%edx
801043ed:	83 c4 10             	add    $0x10,%esp
801043f0:	85 d2                	test   %edx,%edx
801043f2:	75 1c                	jne    80104410 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801043f4:	a1 f8 5f 11 80       	mov    0x80115ff8,%eax
801043f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801043fb:	a1 f4 5f 11 80       	mov    0x80115ff4,%eax
  kmem.freelist = r;
80104400:	89 1d f8 5f 11 80    	mov    %ebx,0x80115ff8
  if(kmem.use_lock)
80104406:	85 c0                	test   %eax,%eax
80104408:	75 1e                	jne    80104428 <kfree+0x78>
    release(&kmem.lock);
}
8010440a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440d:	c9                   	leave
8010440e:	c3                   	ret
8010440f:	90                   	nop
    acquire(&kmem.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 80 5f 11 80       	push   $0x80115f80
80104418:	e8 f3 25 00 00       	call   80106a10 <acquire>
8010441d:	83 c4 10             	add    $0x10,%esp
80104420:	eb d2                	jmp    801043f4 <kfree+0x44>
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80104428:	c7 45 08 80 5f 11 80 	movl   $0x80115f80,0x8(%ebp)
}
8010442f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104432:	c9                   	leave
    release(&kmem.lock);
80104433:	e9 78 25 00 00       	jmp    801069b0 <release>
    panic("kfree");
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 15 a5 10 80       	push   $0x8010a515
80104440:	e8 bb c9 ff ff       	call   80100e00 <panic>
80104445:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010444c:	00 
8010444d:	8d 76 00             	lea    0x0(%esi),%esi

80104450 <freerange>:
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	56                   	push   %esi
80104454:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80104455:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104458:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010445b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104461:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104467:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010446d:	39 de                	cmp    %ebx,%esi
8010446f:	72 23                	jb     80104494 <freerange+0x44>
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104481:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80104487:	50                   	push   %eax
80104488:	e8 23 ff ff ff       	call   801043b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	39 de                	cmp    %ebx,%esi
80104492:	73 e4                	jae    80104478 <freerange+0x28>
}
80104494:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104497:	5b                   	pop    %ebx
80104498:	5e                   	pop    %esi
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret
8010449b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044a0 <kinit2>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801044a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801044ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801044b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801044b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801044bd:	39 de                	cmp    %ebx,%esi
801044bf:	72 23                	jb     801044e4 <kinit2+0x44>
801044c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801044d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801044d7:	50                   	push   %eax
801044d8:	e8 d3 fe ff ff       	call   801043b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801044dd:	83 c4 10             	add    $0x10,%esp
801044e0:	39 de                	cmp    %ebx,%esi
801044e2:	73 e4                	jae    801044c8 <kinit2+0x28>
  kmem.use_lock = 1;
801044e4:	c7 05 f4 5f 11 80 01 	movl   $0x1,0x80115ff4
801044eb:	00 00 00 
}
801044ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044f1:	5b                   	pop    %ebx
801044f2:	5e                   	pop    %esi
801044f3:	5d                   	pop    %ebp
801044f4:	c3                   	ret
801044f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044fc:	00 
801044fd:	8d 76 00             	lea    0x0(%esi),%esi

80104500 <kinit1>:
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80104508:	83 ec 08             	sub    $0x8,%esp
8010450b:	68 1b a5 10 80       	push   $0x8010a51b
80104510:	68 80 5f 11 80       	push   $0x80115f80
80104515:	e8 e6 22 00 00       	call   80106800 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010451a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010451d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80104520:	c7 05 f4 5f 11 80 00 	movl   $0x0,0x80115ff4
80104527:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010452a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80104530:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104536:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010453c:	39 de                	cmp    %ebx,%esi
8010453e:	72 1c                	jb     8010455c <kinit1+0x5c>
    kfree(p);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104549:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010454f:	50                   	push   %eax
80104550:	e8 5b fe ff ff       	call   801043b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80104555:	83 c4 10             	add    $0x10,%esp
80104558:	39 de                	cmp    %ebx,%esi
8010455a:	73 e4                	jae    80104540 <kinit1+0x40>
}
8010455c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010455f:	5b                   	pop    %ebx
80104560:	5e                   	pop    %esi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret
80104563:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010456a:	00 
8010456b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104570 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	53                   	push   %ebx
80104574:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80104577:	a1 f4 5f 11 80       	mov    0x80115ff4,%eax
8010457c:	85 c0                	test   %eax,%eax
8010457e:	75 20                	jne    801045a0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80104580:	8b 1d f8 5f 11 80    	mov    0x80115ff8,%ebx
  if(r)
80104586:	85 db                	test   %ebx,%ebx
80104588:	74 07                	je     80104591 <kalloc+0x21>
    kmem.freelist = r->next;
8010458a:	8b 03                	mov    (%ebx),%eax
8010458c:	a3 f8 5f 11 80       	mov    %eax,0x80115ff8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80104591:	89 d8                	mov    %ebx,%eax
80104593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104596:	c9                   	leave
80104597:	c3                   	ret
80104598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010459f:	00 
    acquire(&kmem.lock);
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	68 80 5f 11 80       	push   $0x80115f80
801045a8:	e8 63 24 00 00       	call   80106a10 <acquire>
  r = kmem.freelist;
801045ad:	8b 1d f8 5f 11 80    	mov    0x80115ff8,%ebx
  if(kmem.use_lock)
801045b3:	a1 f4 5f 11 80       	mov    0x80115ff4,%eax
  if(r)
801045b8:	83 c4 10             	add    $0x10,%esp
801045bb:	85 db                	test   %ebx,%ebx
801045bd:	74 08                	je     801045c7 <kalloc+0x57>
    kmem.freelist = r->next;
801045bf:	8b 13                	mov    (%ebx),%edx
801045c1:	89 15 f8 5f 11 80    	mov    %edx,0x80115ff8
  if(kmem.use_lock)
801045c7:	85 c0                	test   %eax,%eax
801045c9:	74 c6                	je     80104591 <kalloc+0x21>
    release(&kmem.lock);
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	68 80 5f 11 80       	push   $0x80115f80
801045d3:	e8 d8 23 00 00       	call   801069b0 <release>
}
801045d8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801045da:	83 c4 10             	add    $0x10,%esp
}
801045dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e0:	c9                   	leave
801045e1:	c3                   	ret
801045e2:	66 90                	xchg   %ax,%ax
801045e4:	66 90                	xchg   %ax,%ax
801045e6:	66 90                	xchg   %ax,%ax
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801045f0:	ba 64 00 00 00       	mov    $0x64,%edx
801045f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801045f6:	a8 01                	test   $0x1,%al
801045f8:	0f 84 c2 00 00 00    	je     801046c0 <kbdgetc+0xd0>
{
801045fe:	55                   	push   %ebp
801045ff:	ba 60 00 00 00       	mov    $0x60,%edx
80104604:	89 e5                	mov    %esp,%ebp
80104606:	53                   	push   %ebx
80104607:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80104608:	8b 1d fc 5f 11 80    	mov    0x80115ffc,%ebx
  data = inb(KBDATAP);
8010460e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80104611:	3c e0                	cmp    $0xe0,%al
80104613:	74 5b                	je     80104670 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80104615:	89 da                	mov    %ebx,%edx
80104617:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010461a:	84 c0                	test   %al,%al
8010461c:	78 62                	js     80104680 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010461e:	85 d2                	test   %edx,%edx
80104620:	74 09                	je     8010462b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80104622:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80104625:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80104628:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010462b:	0f b6 91 60 ad 10 80 	movzbl -0x7fef52a0(%ecx),%edx
  shift ^= togglecode[data];
80104632:	0f b6 81 60 ac 10 80 	movzbl -0x7fef53a0(%ecx),%eax
  shift |= shiftcode[data];
80104639:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010463b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010463d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010463f:	89 15 fc 5f 11 80    	mov    %edx,0x80115ffc
  c = charcode[shift & (CTL | SHIFT)][data];
80104645:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80104648:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010464b:	8b 04 85 40 ac 10 80 	mov    -0x7fef53c0(,%eax,4),%eax
80104652:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80104656:	74 0b                	je     80104663 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80104658:	8d 50 9f             	lea    -0x61(%eax),%edx
8010465b:	83 fa 19             	cmp    $0x19,%edx
8010465e:	77 48                	ja     801046a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80104660:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80104663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104666:	c9                   	leave
80104667:	c3                   	ret
80104668:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010466f:	00 
    shift |= E0ESC;
80104670:	83 cb 40             	or     $0x40,%ebx
    return 0;
80104673:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80104675:	89 1d fc 5f 11 80    	mov    %ebx,0x80115ffc
}
8010467b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010467e:	c9                   	leave
8010467f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80104680:	83 e0 7f             	and    $0x7f,%eax
80104683:	85 d2                	test   %edx,%edx
80104685:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80104688:	0f b6 81 60 ad 10 80 	movzbl -0x7fef52a0(%ecx),%eax
8010468f:	83 c8 40             	or     $0x40,%eax
80104692:	0f b6 c0             	movzbl %al,%eax
80104695:	f7 d0                	not    %eax
80104697:	21 d8                	and    %ebx,%eax
80104699:	a3 fc 5f 11 80       	mov    %eax,0x80115ffc
    return 0;
8010469e:	31 c0                	xor    %eax,%eax
801046a0:	eb d9                	jmp    8010467b <kbdgetc+0x8b>
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801046a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801046ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801046ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b1:	c9                   	leave
      c += 'a' - 'A';
801046b2:	83 f9 1a             	cmp    $0x1a,%ecx
801046b5:	0f 42 c2             	cmovb  %edx,%eax
}
801046b8:	c3                   	ret
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801046c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046c5:	c3                   	ret
801046c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046cd:	00 
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <kbdintr>:

void
kbdintr(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801046d6:	68 f0 45 10 80       	push   $0x801045f0
801046db:	e8 40 d1 ff ff       	call   80101820 <consoleintr>
}
801046e0:	83 c4 10             	add    $0x10,%esp
801046e3:	c9                   	leave
801046e4:	c3                   	ret
801046e5:	66 90                	xchg   %ax,%ax
801046e7:	66 90                	xchg   %ax,%ax
801046e9:	66 90                	xchg   %ax,%ax
801046eb:	66 90                	xchg   %ax,%ax
801046ed:	66 90                	xchg   %ax,%ax
801046ef:	90                   	nop

801046f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801046f0:	a1 00 60 11 80       	mov    0x80116000,%eax
801046f5:	85 c0                	test   %eax,%eax
801046f7:	0f 84 c3 00 00 00    	je     801047c0 <lapicinit+0xd0>
  lapic[index] = value;
801046fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80104704:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010470a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80104711:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104714:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104717:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010471e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80104721:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104724:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010472b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010472e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104731:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80104738:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010473b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010473e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80104745:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80104748:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010474b:	8b 50 30             	mov    0x30(%eax),%edx
8010474e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80104754:	75 72                	jne    801047c8 <lapicinit+0xd8>
  lapic[index] = value;
80104756:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010475d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104760:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104763:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010476a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010476d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104770:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80104777:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010477a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010477d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104784:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104787:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010478a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80104791:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104794:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80104797:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010479e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801047a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801047ae:	80 e6 10             	and    $0x10,%dh
801047b1:	75 f5                	jne    801047a8 <lapicinit+0xb8>
  lapic[index] = value;
801047b3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801047ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801047bd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801047c0:	c3                   	ret
801047c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801047c8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801047cf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801047d2:	8b 50 20             	mov    0x20(%eax),%edx
}
801047d5:	e9 7c ff ff ff       	jmp    80104756 <lapicinit+0x66>
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801047e0:	a1 00 60 11 80       	mov    0x80116000,%eax
801047e5:	85 c0                	test   %eax,%eax
801047e7:	74 07                	je     801047f0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801047e9:	8b 40 20             	mov    0x20(%eax),%eax
801047ec:	c1 e8 18             	shr    $0x18,%eax
801047ef:	c3                   	ret
    return 0;
801047f0:	31 c0                	xor    %eax,%eax
}
801047f2:	c3                   	ret
801047f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047fa:	00 
801047fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104800 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80104800:	a1 00 60 11 80       	mov    0x80116000,%eax
80104805:	85 c0                	test   %eax,%eax
80104807:	74 0d                	je     80104816 <lapiceoi+0x16>
  lapic[index] = value;
80104809:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104810:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104813:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80104816:	c3                   	ret
80104817:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010481e:	00 
8010481f:	90                   	nop

80104820 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80104820:	c3                   	ret
80104821:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104828:	00 
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80104830:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104831:	b8 0f 00 00 00       	mov    $0xf,%eax
80104836:	ba 70 00 00 00       	mov    $0x70,%edx
8010483b:	89 e5                	mov    %esp,%ebp
8010483d:	53                   	push   %ebx
8010483e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104841:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104844:	ee                   	out    %al,(%dx)
80104845:	b8 0a 00 00 00       	mov    $0xa,%eax
8010484a:	ba 71 00 00 00       	mov    $0x71,%edx
8010484f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80104850:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80104852:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80104855:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010485b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010485d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80104860:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80104862:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80104865:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80104868:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010486e:	a1 00 60 11 80       	mov    0x80116000,%eax
80104873:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80104879:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010487c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80104883:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104886:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104889:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80104890:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80104893:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80104896:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010489c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010489f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801048a5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801048a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801048ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801048b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801048b7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801048ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048bd:	c9                   	leave
801048be:	c3                   	ret
801048bf:	90                   	nop

801048c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801048c0:	55                   	push   %ebp
801048c1:	b8 0b 00 00 00       	mov    $0xb,%eax
801048c6:	ba 70 00 00 00       	mov    $0x70,%edx
801048cb:	89 e5                	mov    %esp,%ebp
801048cd:	57                   	push   %edi
801048ce:	56                   	push   %esi
801048cf:	53                   	push   %ebx
801048d0:	83 ec 4c             	sub    $0x4c,%esp
801048d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801048d4:	ba 71 00 00 00       	mov    $0x71,%edx
801048d9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801048da:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801048dd:	bf 70 00 00 00       	mov    $0x70,%edi
801048e2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801048e5:	8d 76 00             	lea    0x0(%esi),%esi
801048e8:	31 c0                	xor    %eax,%eax
801048ea:	89 fa                	mov    %edi,%edx
801048ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801048ed:	b9 71 00 00 00       	mov    $0x71,%ecx
801048f2:	89 ca                	mov    %ecx,%edx
801048f4:	ec                   	in     (%dx),%al
801048f5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801048f8:	89 fa                	mov    %edi,%edx
801048fa:	b8 02 00 00 00       	mov    $0x2,%eax
801048ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104900:	89 ca                	mov    %ecx,%edx
80104902:	ec                   	in     (%dx),%al
80104903:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104906:	89 fa                	mov    %edi,%edx
80104908:	b8 04 00 00 00       	mov    $0x4,%eax
8010490d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010490e:	89 ca                	mov    %ecx,%edx
80104910:	ec                   	in     (%dx),%al
80104911:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104914:	89 fa                	mov    %edi,%edx
80104916:	b8 07 00 00 00       	mov    $0x7,%eax
8010491b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010491c:	89 ca                	mov    %ecx,%edx
8010491e:	ec                   	in     (%dx),%al
8010491f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104922:	89 fa                	mov    %edi,%edx
80104924:	b8 08 00 00 00       	mov    $0x8,%eax
80104929:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010492a:	89 ca                	mov    %ecx,%edx
8010492c:	ec                   	in     (%dx),%al
8010492d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010492f:	89 fa                	mov    %edi,%edx
80104931:	b8 09 00 00 00       	mov    $0x9,%eax
80104936:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104937:	89 ca                	mov    %ecx,%edx
80104939:	ec                   	in     (%dx),%al
8010493a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010493d:	89 fa                	mov    %edi,%edx
8010493f:	b8 0a 00 00 00       	mov    $0xa,%eax
80104944:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104945:	89 ca                	mov    %ecx,%edx
80104947:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80104948:	84 c0                	test   %al,%al
8010494a:	78 9c                	js     801048e8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010494c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80104950:	89 f2                	mov    %esi,%edx
80104952:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80104955:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104958:	89 fa                	mov    %edi,%edx
8010495a:	89 45 b8             	mov    %eax,-0x48(%ebp)
8010495d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80104961:	89 75 c8             	mov    %esi,-0x38(%ebp)
80104964:	89 45 bc             	mov    %eax,-0x44(%ebp)
80104967:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010496b:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010496e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80104972:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80104975:	31 c0                	xor    %eax,%eax
80104977:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104978:	89 ca                	mov    %ecx,%edx
8010497a:	ec                   	in     (%dx),%al
8010497b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010497e:	89 fa                	mov    %edi,%edx
80104980:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104983:	b8 02 00 00 00       	mov    $0x2,%eax
80104988:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80104989:	89 ca                	mov    %ecx,%edx
8010498b:	ec                   	in     (%dx),%al
8010498c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010498f:	89 fa                	mov    %edi,%edx
80104991:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104994:	b8 04 00 00 00       	mov    $0x4,%eax
80104999:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010499a:	89 ca                	mov    %ecx,%edx
8010499c:	ec                   	in     (%dx),%al
8010499d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801049a0:	89 fa                	mov    %edi,%edx
801049a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
801049a5:	b8 07 00 00 00       	mov    $0x7,%eax
801049aa:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801049ab:	89 ca                	mov    %ecx,%edx
801049ad:	ec                   	in     (%dx),%al
801049ae:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801049b1:	89 fa                	mov    %edi,%edx
801049b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801049b6:	b8 08 00 00 00       	mov    $0x8,%eax
801049bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801049bc:	89 ca                	mov    %ecx,%edx
801049be:	ec                   	in     (%dx),%al
801049bf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801049c2:	89 fa                	mov    %edi,%edx
801049c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049c7:	b8 09 00 00 00       	mov    $0x9,%eax
801049cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801049cd:	89 ca                	mov    %ecx,%edx
801049cf:	ec                   	in     (%dx),%al
801049d0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801049d3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801049d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801049d9:	8d 45 d0             	lea    -0x30(%ebp),%eax
801049dc:	6a 18                	push   $0x18
801049de:	50                   	push   %eax
801049df:	8d 45 b8             	lea    -0x48(%ebp),%eax
801049e2:	50                   	push   %eax
801049e3:	e8 08 26 00 00       	call   80106ff0 <memcmp>
801049e8:	83 c4 10             	add    $0x10,%esp
801049eb:	85 c0                	test   %eax,%eax
801049ed:	0f 85 f5 fe ff ff    	jne    801048e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801049f3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049fa:	89 f0                	mov    %esi,%eax
801049fc:	84 c0                	test   %al,%al
801049fe:	75 78                	jne    80104a78 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80104a00:	8b 45 b8             	mov    -0x48(%ebp),%eax
80104a03:	89 c2                	mov    %eax,%edx
80104a05:	83 e0 0f             	and    $0xf,%eax
80104a08:	c1 ea 04             	shr    $0x4,%edx
80104a0b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a0e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a11:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80104a14:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104a17:	89 c2                	mov    %eax,%edx
80104a19:	83 e0 0f             	and    $0xf,%eax
80104a1c:	c1 ea 04             	shr    $0x4,%edx
80104a1f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a22:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a25:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80104a28:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104a2b:	89 c2                	mov    %eax,%edx
80104a2d:	83 e0 0f             	and    $0xf,%eax
80104a30:	c1 ea 04             	shr    $0x4,%edx
80104a33:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a36:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a39:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80104a3c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104a3f:	89 c2                	mov    %eax,%edx
80104a41:	83 e0 0f             	and    $0xf,%eax
80104a44:	c1 ea 04             	shr    $0x4,%edx
80104a47:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a4a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a4d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80104a50:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104a53:	89 c2                	mov    %eax,%edx
80104a55:	83 e0 0f             	and    $0xf,%eax
80104a58:	c1 ea 04             	shr    $0x4,%edx
80104a5b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a5e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a61:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80104a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104a67:	89 c2                	mov    %eax,%edx
80104a69:	83 e0 0f             	and    $0xf,%eax
80104a6c:	c1 ea 04             	shr    $0x4,%edx
80104a6f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80104a72:	8d 04 50             	lea    (%eax,%edx,2),%eax
80104a75:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80104a78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80104a7b:	89 03                	mov    %eax,(%ebx)
80104a7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80104a80:	89 43 04             	mov    %eax,0x4(%ebx)
80104a83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104a86:	89 43 08             	mov    %eax,0x8(%ebx)
80104a89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104a8c:	89 43 0c             	mov    %eax,0xc(%ebx)
80104a8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104a92:	89 43 10             	mov    %eax,0x10(%ebx)
80104a95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104a98:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80104a9b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80104aa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5f                   	pop    %edi
80104aa8:	5d                   	pop    %ebp
80104aa9:	c3                   	ret
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80104ab0:	8b 0d a8 60 11 80    	mov    0x801160a8,%ecx
80104ab6:	85 c9                	test   %ecx,%ecx
80104ab8:	0f 8e 92 00 00 00    	jle    80104b50 <install_trans+0xa0>
{
80104abe:	55                   	push   %ebp
80104abf:	89 e5                	mov    %esp,%ebp
80104ac1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80104ac2:	31 ff                	xor    %edi,%edi
{
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	83 ec 0c             	sub    $0xc,%esp
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80104ad0:	a1 94 60 11 80       	mov    0x80116094,%eax
80104ad5:	83 ec 08             	sub    $0x8,%esp
80104ad8:	01 f8                	add    %edi,%eax
80104ada:	83 c0 01             	add    $0x1,%eax
80104add:	50                   	push   %eax
80104ade:	ff 35 a4 60 11 80    	push   0x801160a4
80104ae4:	e8 e7 b5 ff ff       	call   801000d0 <bread>
80104ae9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104aeb:	58                   	pop    %eax
80104aec:	5a                   	pop    %edx
80104aed:	ff 34 bd ac 60 11 80 	push   -0x7fee9f54(,%edi,4)
80104af4:	ff 35 a4 60 11 80    	push   0x801160a4
  for (tail = 0; tail < log.lh.n; tail++) {
80104afa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104afd:	e8 ce b5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104b02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80104b05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80104b07:	8d 86 9c 00 00 00    	lea    0x9c(%esi),%eax
80104b0d:	68 00 02 00 00       	push   $0x200
80104b12:	50                   	push   %eax
80104b13:	8d 83 9c 00 00 00    	lea    0x9c(%ebx),%eax
80104b19:	50                   	push   %eax
80104b1a:	e8 21 25 00 00       	call   80107040 <memmove>
    bwrite(dbuf);  // write dst to disk
80104b1f:	89 1c 24             	mov    %ebx,(%esp)
80104b22:	e8 a9 b6 ff ff       	call   801001d0 <bwrite>
    brelse(lbuf);
80104b27:	89 34 24             	mov    %esi,(%esp)
80104b2a:	e8 e1 b6 ff ff       	call   80100210 <brelse>
    brelse(dbuf);
80104b2f:	89 1c 24             	mov    %ebx,(%esp)
80104b32:	e8 d9 b6 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104b37:	83 c4 10             	add    $0x10,%esp
80104b3a:	39 3d a8 60 11 80    	cmp    %edi,0x801160a8
80104b40:	7f 8e                	jg     80104ad0 <install_trans+0x20>
  }
}
80104b42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b45:	5b                   	pop    %ebx
80104b46:	5e                   	pop    %esi
80104b47:	5f                   	pop    %edi
80104b48:	5d                   	pop    %ebp
80104b49:	c3                   	ret
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b50:	c3                   	ret
80104b51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b58:	00 
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80104b67:	ff 35 94 60 11 80    	push   0x80116094
80104b6d:	ff 35 a4 60 11 80    	push   0x801160a4
80104b73:	e8 58 b5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80104b78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80104b7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80104b7d:	a1 a8 60 11 80       	mov    0x801160a8,%eax
80104b82:	89 83 9c 00 00 00    	mov    %eax,0x9c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80104b88:	85 c0                	test   %eax,%eax
80104b8a:	7e 19                	jle    80104ba5 <write_head+0x45>
80104b8c:	31 d2                	xor    %edx,%edx
80104b8e:	66 90                	xchg   %ax,%ax
    hb->block[i] = log.lh.block[i];
80104b90:	8b 0c 95 ac 60 11 80 	mov    -0x7fee9f54(,%edx,4),%ecx
80104b97:	89 8c 93 a0 00 00 00 	mov    %ecx,0xa0(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80104b9e:	83 c2 01             	add    $0x1,%edx
80104ba1:	39 d0                	cmp    %edx,%eax
80104ba3:	75 eb                	jne    80104b90 <write_head+0x30>
  }
  bwrite(buf);
80104ba5:	83 ec 0c             	sub    $0xc,%esp
80104ba8:	53                   	push   %ebx
80104ba9:	e8 22 b6 ff ff       	call   801001d0 <bwrite>
  brelse(buf);
80104bae:	89 1c 24             	mov    %ebx,(%esp)
80104bb1:	e8 5a b6 ff ff       	call   80100210 <brelse>
}
80104bb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb9:	83 c4 10             	add    $0x10,%esp
80104bbc:	c9                   	leave
80104bbd:	c3                   	ret
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <initlog>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 2c             	sub    $0x2c,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80104bca:	68 20 a5 10 80       	push   $0x8010a520
80104bcf:	68 20 60 11 80       	push   $0x80116020
80104bd4:	e8 27 1c 00 00       	call   80106800 <initlock>
  readsb(dev, &sb);
80104bd9:	58                   	pop    %eax
80104bda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104bdd:	5a                   	pop    %edx
80104bde:	50                   	push   %eax
80104bdf:	53                   	push   %ebx
80104be0:	e8 bb e7 ff ff       	call   801033a0 <readsb>
  log.start = sb.logstart;
80104be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80104be8:	59                   	pop    %ecx
  log.dev = dev;
80104be9:	89 1d a4 60 11 80    	mov    %ebx,0x801160a4
  log.size = sb.nlog;
80104bef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80104bf2:	a3 94 60 11 80       	mov    %eax,0x80116094
  log.size = sb.nlog;
80104bf7:	89 15 98 60 11 80    	mov    %edx,0x80116098
  struct buf *buf = bread(log.dev, log.start);
80104bfd:	5a                   	pop    %edx
80104bfe:	50                   	push   %eax
80104bff:	53                   	push   %ebx
80104c00:	e8 cb b4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80104c05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80104c08:	8b 98 9c 00 00 00    	mov    0x9c(%eax),%ebx
80104c0e:	89 1d a8 60 11 80    	mov    %ebx,0x801160a8
  for (i = 0; i < log.lh.n; i++) {
80104c14:	85 db                	test   %ebx,%ebx
80104c16:	7e 1d                	jle    80104c35 <initlog+0x75>
80104c18:	31 d2                	xor    %edx,%edx
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80104c20:	8b 8c 90 a0 00 00 00 	mov    0xa0(%eax,%edx,4),%ecx
80104c27:	89 0c 95 ac 60 11 80 	mov    %ecx,-0x7fee9f54(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80104c2e:	83 c2 01             	add    $0x1,%edx
80104c31:	39 d3                	cmp    %edx,%ebx
80104c33:	75 eb                	jne    80104c20 <initlog+0x60>
  brelse(buf);
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	50                   	push   %eax
80104c39:	e8 d2 b5 ff ff       	call   80100210 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80104c3e:	e8 6d fe ff ff       	call   80104ab0 <install_trans>
  log.lh.n = 0;
80104c43:	c7 05 a8 60 11 80 00 	movl   $0x0,0x801160a8
80104c4a:	00 00 00 
  write_head(); // clear the log
80104c4d:	e8 0e ff ff ff       	call   80104b60 <write_head>
}
80104c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c55:	83 c4 10             	add    $0x10,%esp
80104c58:	c9                   	leave
80104c59:	c3                   	ret
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80104c66:	68 20 60 11 80       	push   $0x80116020
80104c6b:	e8 a0 1d 00 00       	call   80106a10 <acquire>
80104c70:	83 c4 10             	add    $0x10,%esp
80104c73:	eb 18                	jmp    80104c8d <begin_op+0x2d>
80104c75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80104c78:	83 ec 08             	sub    $0x8,%esp
80104c7b:	68 20 60 11 80       	push   $0x80116020
80104c80:	68 20 60 11 80       	push   $0x80116020
80104c85:	e8 f6 12 00 00       	call   80105f80 <sleep>
80104c8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80104c8d:	a1 a0 60 11 80       	mov    0x801160a0,%eax
80104c92:	85 c0                	test   %eax,%eax
80104c94:	75 e2                	jne    80104c78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80104c96:	a1 9c 60 11 80       	mov    0x8011609c,%eax
80104c9b:	8b 15 a8 60 11 80    	mov    0x801160a8,%edx
80104ca1:	83 c0 01             	add    $0x1,%eax
80104ca4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80104ca7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80104caa:	83 fa 1e             	cmp    $0x1e,%edx
80104cad:	7f c9                	jg     80104c78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80104caf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80104cb2:	a3 9c 60 11 80       	mov    %eax,0x8011609c
      release(&log.lock);
80104cb7:	68 20 60 11 80       	push   $0x80116020
80104cbc:	e8 ef 1c 00 00       	call   801069b0 <release>
      break;
    }
  }
}
80104cc1:	83 c4 10             	add    $0x10,%esp
80104cc4:	c9                   	leave
80104cc5:	c3                   	ret
80104cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ccd:	00 
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80104cd9:	68 20 60 11 80       	push   $0x80116020
80104cde:	e8 2d 1d 00 00       	call   80106a10 <acquire>
  log.outstanding -= 1;
80104ce3:	a1 9c 60 11 80       	mov    0x8011609c,%eax
  if(log.committing)
80104ce8:	8b 35 a0 60 11 80    	mov    0x801160a0,%esi
80104cee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80104cf1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104cf4:	89 1d 9c 60 11 80    	mov    %ebx,0x8011609c
  if(log.committing)
80104cfa:	85 f6                	test   %esi,%esi
80104cfc:	0f 85 22 01 00 00    	jne    80104e24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80104d02:	85 db                	test   %ebx,%ebx
80104d04:	0f 85 f6 00 00 00    	jne    80104e00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80104d0a:	c7 05 a0 60 11 80 01 	movl   $0x1,0x801160a0
80104d11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	68 20 60 11 80       	push   $0x80116020
80104d1c:	e8 8f 1c 00 00       	call   801069b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80104d21:	8b 0d a8 60 11 80    	mov    0x801160a8,%ecx
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c9                	test   %ecx,%ecx
80104d2c:	7f 42                	jg     80104d70 <end_op+0xa0>
    acquire(&log.lock);
80104d2e:	83 ec 0c             	sub    $0xc,%esp
80104d31:	68 20 60 11 80       	push   $0x80116020
80104d36:	e8 d5 1c 00 00       	call   80106a10 <acquire>
    log.committing = 0;
80104d3b:	c7 05 a0 60 11 80 00 	movl   $0x0,0x801160a0
80104d42:	00 00 00 
    wakeup(&log);
80104d45:	c7 04 24 20 60 11 80 	movl   $0x80116020,(%esp)
80104d4c:	e8 ef 12 00 00       	call   80106040 <wakeup>
    release(&log.lock);
80104d51:	c7 04 24 20 60 11 80 	movl   $0x80116020,(%esp)
80104d58:	e8 53 1c 00 00       	call   801069b0 <release>
80104d5d:	83 c4 10             	add    $0x10,%esp
}
80104d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d63:	5b                   	pop    %ebx
80104d64:	5e                   	pop    %esi
80104d65:	5f                   	pop    %edi
80104d66:	5d                   	pop    %ebp
80104d67:	c3                   	ret
80104d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d6f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80104d70:	a1 94 60 11 80       	mov    0x80116094,%eax
80104d75:	83 ec 08             	sub    $0x8,%esp
80104d78:	01 d8                	add    %ebx,%eax
80104d7a:	83 c0 01             	add    $0x1,%eax
80104d7d:	50                   	push   %eax
80104d7e:	ff 35 a4 60 11 80    	push   0x801160a4
80104d84:	e8 47 b3 ff ff       	call   801000d0 <bread>
80104d89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104d8b:	58                   	pop    %eax
80104d8c:	5a                   	pop    %edx
80104d8d:	ff 34 9d ac 60 11 80 	push   -0x7fee9f54(,%ebx,4)
80104d94:	ff 35 a4 60 11 80    	push   0x801160a4
  for (tail = 0; tail < log.lh.n; tail++) {
80104d9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104d9d:	e8 2e b3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80104da2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80104da5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80104da7:	8d 80 9c 00 00 00    	lea    0x9c(%eax),%eax
80104dad:	68 00 02 00 00       	push   $0x200
80104db2:	50                   	push   %eax
80104db3:	8d 86 9c 00 00 00    	lea    0x9c(%esi),%eax
80104db9:	50                   	push   %eax
80104dba:	e8 81 22 00 00       	call   80107040 <memmove>
    bwrite(to);  // write the log
80104dbf:	89 34 24             	mov    %esi,(%esp)
80104dc2:	e8 09 b4 ff ff       	call   801001d0 <bwrite>
    brelse(from);
80104dc7:	89 3c 24             	mov    %edi,(%esp)
80104dca:	e8 41 b4 ff ff       	call   80100210 <brelse>
    brelse(to);
80104dcf:	89 34 24             	mov    %esi,(%esp)
80104dd2:	e8 39 b4 ff ff       	call   80100210 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	3b 1d a8 60 11 80    	cmp    0x801160a8,%ebx
80104de0:	7c 8e                	jl     80104d70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80104de2:	e8 79 fd ff ff       	call   80104b60 <write_head>
    install_trans(); // Now install writes to home locations
80104de7:	e8 c4 fc ff ff       	call   80104ab0 <install_trans>
    log.lh.n = 0;
80104dec:	c7 05 a8 60 11 80 00 	movl   $0x0,0x801160a8
80104df3:	00 00 00 
    write_head();    // Erase the transaction from the log
80104df6:	e8 65 fd ff ff       	call   80104b60 <write_head>
80104dfb:	e9 2e ff ff ff       	jmp    80104d2e <end_op+0x5e>
    wakeup(&log);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	68 20 60 11 80       	push   $0x80116020
80104e08:	e8 33 12 00 00       	call   80106040 <wakeup>
  release(&log.lock);
80104e0d:	c7 04 24 20 60 11 80 	movl   $0x80116020,(%esp)
80104e14:	e8 97 1b 00 00       	call   801069b0 <release>
80104e19:	83 c4 10             	add    $0x10,%esp
}
80104e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5f                   	pop    %edi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret
    panic("log.committing");
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	68 24 a5 10 80       	push   $0x8010a524
80104e2c:	e8 cf bf ff ff       	call   80100e00 <panic>
80104e31:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e38:	00 
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104e47:	8b 15 a8 60 11 80    	mov    0x801160a8,%edx
{
80104e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80104e50:	83 fa 1d             	cmp    $0x1d,%edx
80104e53:	7f 7d                	jg     80104ed2 <log_write+0x92>
80104e55:	a1 98 60 11 80       	mov    0x80116098,%eax
80104e5a:	83 e8 01             	sub    $0x1,%eax
80104e5d:	39 c2                	cmp    %eax,%edx
80104e5f:	7d 71                	jge    80104ed2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80104e61:	a1 9c 60 11 80       	mov    0x8011609c,%eax
80104e66:	85 c0                	test   %eax,%eax
80104e68:	7e 75                	jle    80104edf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	68 20 60 11 80       	push   $0x80116020
80104e72:	e8 99 1b 00 00       	call   80106a10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104e77:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80104e7a:	83 c4 10             	add    $0x10,%esp
80104e7d:	31 c0                	xor    %eax,%eax
80104e7f:	8b 15 a8 60 11 80    	mov    0x801160a8,%edx
80104e85:	85 d2                	test   %edx,%edx
80104e87:	7f 0e                	jg     80104e97 <log_write+0x57>
80104e89:	eb 15                	jmp    80104ea0 <log_write+0x60>
80104e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e90:	83 c0 01             	add    $0x1,%eax
80104e93:	39 c2                	cmp    %eax,%edx
80104e95:	74 29                	je     80104ec0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80104e97:	39 0c 85 ac 60 11 80 	cmp    %ecx,-0x7fee9f54(,%eax,4)
80104e9e:	75 f0                	jne    80104e90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80104ea0:	89 0c 85 ac 60 11 80 	mov    %ecx,-0x7fee9f54(,%eax,4)
  if (i == log.lh.n)
80104ea7:	39 c2                	cmp    %eax,%edx
80104ea9:	74 1c                	je     80104ec7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80104eab:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80104eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80104eb1:	c7 45 08 20 60 11 80 	movl   $0x80116020,0x8(%ebp)
}
80104eb8:	c9                   	leave
  release(&log.lock);
80104eb9:	e9 f2 1a 00 00       	jmp    801069b0 <release>
80104ebe:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80104ec0:	89 0c 95 ac 60 11 80 	mov    %ecx,-0x7fee9f54(,%edx,4)
    log.lh.n++;
80104ec7:	83 c2 01             	add    $0x1,%edx
80104eca:	89 15 a8 60 11 80    	mov    %edx,0x801160a8
80104ed0:	eb d9                	jmp    80104eab <log_write+0x6b>
    panic("too big a transaction");
80104ed2:	83 ec 0c             	sub    $0xc,%esp
80104ed5:	68 33 a5 10 80       	push   $0x8010a533
80104eda:	e8 21 bf ff ff       	call   80100e00 <panic>
    panic("log_write outside of trans");
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	68 49 a5 10 80       	push   $0x8010a549
80104ee7:	e8 14 bf ff ff       	call   80100e00 <panic>
80104eec:	66 90                	xchg   %ax,%ax
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80104ef7:	e8 84 09 00 00       	call   80105880 <cpuid>
80104efc:	89 c3                	mov    %eax,%ebx
80104efe:	e8 7d 09 00 00       	call   80105880 <cpuid>
80104f03:	83 ec 04             	sub    $0x4,%esp
80104f06:	53                   	push   %ebx
80104f07:	50                   	push   %eax
80104f08:	68 64 a5 10 80       	push   $0x8010a564
80104f0d:	e8 fe c6 ff ff       	call   80101610 <cprintf>
  idtinit();       // load idt register
80104f12:	e8 79 3b 00 00       	call   80108a90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80104f17:	e8 04 09 00 00       	call   80105820 <mycpu>
80104f1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f1e:	b8 01 00 00 00       	mov    $0x1,%eax
80104f23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80104f2a:	e8 31 0c 00 00       	call   80105b60 <scheduler>
80104f2f:	90                   	nop

80104f30 <mpenter>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80104f36:	e8 55 4c 00 00       	call   80109b90 <switchkvm>
  seginit();
80104f3b:	e8 c0 4b 00 00       	call   80109b00 <seginit>
  lapicinit();
80104f40:	e8 ab f7 ff ff       	call   801046f0 <lapicinit>
  mpmain();
80104f45:	e8 a6 ff ff ff       	call   80104ef0 <mpmain>
80104f4a:	66 90                	xchg   %ax,%ax
80104f4c:	66 90                	xchg   %ax,%ax
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <main>:
{
80104f50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80104f54:	83 e4 f0             	and    $0xfffffff0,%esp
80104f57:	ff 71 fc             	push   -0x4(%ecx)
80104f5a:	55                   	push   %ebp
80104f5b:	89 e5                	mov    %esp,%ebp
80104f5d:	53                   	push   %ebx
80104f5e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80104f5f:	83 ec 08             	sub    $0x8,%esp
80104f62:	68 00 00 40 80       	push   $0x80400000
80104f67:	68 f0 a1 11 80       	push   $0x8011a1f0
80104f6c:	e8 8f f5 ff ff       	call   80104500 <kinit1>
  kvmalloc();      // kernel page table
80104f71:	e8 da 50 00 00       	call   8010a050 <kvmalloc>
  mpinit();        // detect other processors
80104f76:	e8 95 01 00 00       	call   80105110 <mpinit>
  lapicinit();     // interrupt controller
80104f7b:	e8 70 f7 ff ff       	call   801046f0 <lapicinit>
  seginit();       // segment descriptors
80104f80:	e8 7b 4b 00 00       	call   80109b00 <seginit>
  picinit();       // disable pic
80104f85:	e8 96 03 00 00       	call   80105320 <picinit>
  ioapicinit();    // another interrupt controller
80104f8a:	e8 41 f3 ff ff       	call   801042d0 <ioapicinit>
  consoleinit();   // console hardware
80104f8f:	e8 ec d8 ff ff       	call   80102880 <consoleinit>
  uartinit();      // serial port
80104f94:	e8 d7 3d 00 00       	call   80108d70 <uartinit>
  pinit();         // process table
80104f99:	e8 62 08 00 00       	call   80105800 <pinit>
  tvinit();        // trap vectors
80104f9e:	e8 6d 3a 00 00       	call   80108a10 <tvinit>
  binit();         // buffer cache
80104fa3:	e8 98 b0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80104fa8:	e8 d3 dc ff ff       	call   80102c80 <fileinit>
  ideinit();       // disk 
80104fad:	e8 ee f0 ff ff       	call   801040a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80104fb2:	83 c4 0c             	add    $0xc,%esp
80104fb5:	68 8a 00 00 00       	push   $0x8a
80104fba:	68 8c d4 10 80       	push   $0x8010d48c
80104fbf:	68 00 70 00 80       	push   $0x80007000
80104fc4:	e8 77 20 00 00       	call   80107040 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	69 05 44 61 11 80 b0 	imul   $0xb0,0x80116144,%eax
80104fd3:	00 00 00 
80104fd6:	05 60 61 11 80       	add    $0x80116160,%eax
80104fdb:	3d 60 61 11 80       	cmp    $0x80116160,%eax
80104fe0:	76 7e                	jbe    80105060 <main+0x110>
80104fe2:	bb 60 61 11 80       	mov    $0x80116160,%ebx
80104fe7:	eb 20                	jmp    80105009 <main+0xb9>
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff0:	69 05 44 61 11 80 b0 	imul   $0xb0,0x80116144,%eax
80104ff7:	00 00 00 
80104ffa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80105000:	05 60 61 11 80       	add    $0x80116160,%eax
80105005:	39 c3                	cmp    %eax,%ebx
80105007:	73 57                	jae    80105060 <main+0x110>
    if(c == mycpu())  // We've started already.
80105009:	e8 12 08 00 00       	call   80105820 <mycpu>
8010500e:	39 c3                	cmp    %eax,%ebx
80105010:	74 de                	je     80104ff0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80105012:	e8 59 f5 ff ff       	call   80104570 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80105017:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010501a:	c7 05 f8 6f 00 80 30 	movl   $0x80104f30,0x80006ff8
80105021:	4f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80105024:	c7 05 f4 6f 00 80 00 	movl   $0x10c000,0x80006ff4
8010502b:	c0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010502e:	05 00 10 00 00       	add    $0x1000,%eax
80105033:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80105038:	0f b6 03             	movzbl (%ebx),%eax
8010503b:	68 00 70 00 00       	push   $0x7000
80105040:	50                   	push   %eax
80105041:	e8 ea f7 ff ff       	call   80104830 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80105046:	83 c4 10             	add    $0x10,%esp
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105050:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80105056:	85 c0                	test   %eax,%eax
80105058:	74 f6                	je     80105050 <main+0x100>
8010505a:	eb 94                	jmp    80104ff0 <main+0xa0>
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80105060:	83 ec 08             	sub    $0x8,%esp
80105063:	68 00 00 00 8e       	push   $0x8e000000
80105068:	68 00 00 40 80       	push   $0x80400000
8010506d:	e8 2e f4 ff ff       	call   801044a0 <kinit2>
  cpt_init();      //initialize the Central Page Table after the allocator is ready
80105072:	e8 69 b5 ff ff       	call   801005e0 <cpt_init>
  userinit();      // first user process
80105077:	e8 54 08 00 00       	call   801058d0 <userinit>
  mpmain();        // finish this processor's setup
8010507c:	e8 6f fe ff ff       	call   80104ef0 <mpmain>
80105081:	66 90                	xchg   %ax,%ax
80105083:	66 90                	xchg   %ax,%ax
80105085:	66 90                	xchg   %ax,%ax
80105087:	66 90                	xchg   %ax,%ax
80105089:	66 90                	xchg   %ax,%ax
8010508b:	66 90                	xchg   %ax,%ax
8010508d:	66 90                	xchg   %ax,%ax
8010508f:	90                   	nop

80105090 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80105095:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010509b:	53                   	push   %ebx
  e = addr+len;
8010509c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010509f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801050a2:	39 de                	cmp    %ebx,%esi
801050a4:	72 10                	jb     801050b6 <mpsearch1+0x26>
801050a6:	eb 50                	jmp    801050f8 <mpsearch1+0x68>
801050a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050af:	00 
801050b0:	89 fe                	mov    %edi,%esi
801050b2:	39 df                	cmp    %ebx,%edi
801050b4:	73 42                	jae    801050f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801050b6:	83 ec 04             	sub    $0x4,%esp
801050b9:	8d 7e 10             	lea    0x10(%esi),%edi
801050bc:	6a 04                	push   $0x4
801050be:	68 78 a5 10 80       	push   $0x8010a578
801050c3:	56                   	push   %esi
801050c4:	e8 27 1f 00 00       	call   80106ff0 <memcmp>
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	85 c0                	test   %eax,%eax
801050ce:	75 e0                	jne    801050b0 <mpsearch1+0x20>
801050d0:	89 f2                	mov    %esi,%edx
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801050d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801050db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801050de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801050e0:	39 fa                	cmp    %edi,%edx
801050e2:	75 f4                	jne    801050d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801050e4:	84 c0                	test   %al,%al
801050e6:	75 c8                	jne    801050b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801050e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050eb:	89 f0                	mov    %esi,%eax
801050ed:	5b                   	pop    %ebx
801050ee:	5e                   	pop    %esi
801050ef:	5f                   	pop    %edi
801050f0:	5d                   	pop    %ebp
801050f1:	c3                   	ret
801050f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801050fb:	31 f6                	xor    %esi,%esi
}
801050fd:	5b                   	pop    %ebx
801050fe:	89 f0                	mov    %esi,%eax
80105100:	5e                   	pop    %esi
80105101:	5f                   	pop    %edi
80105102:	5d                   	pop    %ebp
80105103:	c3                   	ret
80105104:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010510b:	00 
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	53                   	push   %ebx
80105116:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80105119:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80105120:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80105127:	c1 e0 08             	shl    $0x8,%eax
8010512a:	09 d0                	or     %edx,%eax
8010512c:	c1 e0 04             	shl    $0x4,%eax
8010512f:	75 1b                	jne    8010514c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80105131:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80105138:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010513f:	c1 e0 08             	shl    $0x8,%eax
80105142:	09 d0                	or     %edx,%eax
80105144:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80105147:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010514c:	ba 00 04 00 00       	mov    $0x400,%edx
80105151:	e8 3a ff ff ff       	call   80105090 <mpsearch1>
80105156:	89 c3                	mov    %eax,%ebx
80105158:	85 c0                	test   %eax,%eax
8010515a:	0f 84 58 01 00 00    	je     801052b8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80105160:	8b 73 04             	mov    0x4(%ebx),%esi
80105163:	85 f6                	test   %esi,%esi
80105165:	0f 84 3d 01 00 00    	je     801052a8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010516b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010516e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80105177:	6a 04                	push   $0x4
80105179:	68 7d a5 10 80       	push   $0x8010a57d
8010517e:	50                   	push   %eax
8010517f:	e8 6c 1e 00 00       	call   80106ff0 <memcmp>
80105184:	83 c4 10             	add    $0x10,%esp
80105187:	85 c0                	test   %eax,%eax
80105189:	0f 85 19 01 00 00    	jne    801052a8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010518f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80105196:	3c 01                	cmp    $0x1,%al
80105198:	74 08                	je     801051a2 <mpinit+0x92>
8010519a:	3c 04                	cmp    $0x4,%al
8010519c:	0f 85 06 01 00 00    	jne    801052a8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801051a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801051a9:	66 85 d2             	test   %dx,%dx
801051ac:	74 22                	je     801051d0 <mpinit+0xc0>
801051ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801051b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801051b3:	31 d2                	xor    %edx,%edx
801051b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801051b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801051bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801051c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801051c4:	39 f8                	cmp    %edi,%eax
801051c6:	75 f0                	jne    801051b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801051c8:	84 d2                	test   %dl,%dl
801051ca:	0f 85 d8 00 00 00    	jne    801052a8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801051d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801051d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801051d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801051dc:	a3 00 60 11 80       	mov    %eax,0x80116000
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801051e1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801051e8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801051ee:	01 d7                	add    %edx,%edi
801051f0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801051f2:	bf 01 00 00 00       	mov    $0x1,%edi
801051f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051fe:	00 
801051ff:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80105200:	39 d0                	cmp    %edx,%eax
80105202:	73 19                	jae    8010521d <mpinit+0x10d>
    switch(*p){
80105204:	0f b6 08             	movzbl (%eax),%ecx
80105207:	80 f9 02             	cmp    $0x2,%cl
8010520a:	0f 84 80 00 00 00    	je     80105290 <mpinit+0x180>
80105210:	77 6e                	ja     80105280 <mpinit+0x170>
80105212:	84 c9                	test   %cl,%cl
80105214:	74 3a                	je     80105250 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80105216:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80105219:	39 d0                	cmp    %edx,%eax
8010521b:	72 e7                	jb     80105204 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010521d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105220:	85 ff                	test   %edi,%edi
80105222:	0f 84 dd 00 00 00    	je     80105305 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80105228:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010522c:	74 15                	je     80105243 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010522e:	b8 70 00 00 00       	mov    $0x70,%eax
80105233:	ba 22 00 00 00       	mov    $0x22,%edx
80105238:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105239:	ba 23 00 00 00       	mov    $0x23,%edx
8010523e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010523f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105242:	ee                   	out    %al,(%dx)
  }
}
80105243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105246:	5b                   	pop    %ebx
80105247:	5e                   	pop    %esi
80105248:	5f                   	pop    %edi
80105249:	5d                   	pop    %ebp
8010524a:	c3                   	ret
8010524b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80105250:	8b 0d 44 61 11 80    	mov    0x80116144,%ecx
80105256:	83 f9 07             	cmp    $0x7,%ecx
80105259:	7f 19                	jg     80105274 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010525b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80105261:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80105265:	83 c1 01             	add    $0x1,%ecx
80105268:	89 0d 44 61 11 80    	mov    %ecx,0x80116144
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010526e:	88 9e 60 61 11 80    	mov    %bl,-0x7fee9ea0(%esi)
      p += sizeof(struct mpproc);
80105274:	83 c0 14             	add    $0x14,%eax
      continue;
80105277:	eb 87                	jmp    80105200 <mpinit+0xf0>
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80105280:	83 e9 03             	sub    $0x3,%ecx
80105283:	80 f9 01             	cmp    $0x1,%cl
80105286:	76 8e                	jbe    80105216 <mpinit+0x106>
80105288:	31 ff                	xor    %edi,%edi
8010528a:	e9 71 ff ff ff       	jmp    80105200 <mpinit+0xf0>
8010528f:	90                   	nop
      ioapicid = ioapic->apicno;
80105290:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80105294:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80105297:	88 0d 40 61 11 80    	mov    %cl,0x80116140
      continue;
8010529d:	e9 5e ff ff ff       	jmp    80105200 <mpinit+0xf0>
801052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	68 82 a5 10 80       	push   $0x8010a582
801052b0:	e8 4b bb ff ff       	call   80100e00 <panic>
801052b5:	8d 76 00             	lea    0x0(%esi),%esi
{
801052b8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801052bd:	eb 0b                	jmp    801052ca <mpinit+0x1ba>
801052bf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801052c0:	89 f3                	mov    %esi,%ebx
801052c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801052c8:	74 de                	je     801052a8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801052ca:	83 ec 04             	sub    $0x4,%esp
801052cd:	8d 73 10             	lea    0x10(%ebx),%esi
801052d0:	6a 04                	push   $0x4
801052d2:	68 78 a5 10 80       	push   $0x8010a578
801052d7:	53                   	push   %ebx
801052d8:	e8 13 1d 00 00       	call   80106ff0 <memcmp>
801052dd:	83 c4 10             	add    $0x10,%esp
801052e0:	85 c0                	test   %eax,%eax
801052e2:	75 dc                	jne    801052c0 <mpinit+0x1b0>
801052e4:	89 da                	mov    %ebx,%edx
801052e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052ed:	00 
801052ee:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801052f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801052f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801052f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801052f8:	39 d6                	cmp    %edx,%esi
801052fa:	75 f4                	jne    801052f0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801052fc:	84 c0                	test   %al,%al
801052fe:	75 c0                	jne    801052c0 <mpinit+0x1b0>
80105300:	e9 5b fe ff ff       	jmp    80105160 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80105305:	83 ec 0c             	sub    $0xc,%esp
80105308:	68 dc a9 10 80       	push   $0x8010a9dc
8010530d:	e8 ee ba ff ff       	call   80100e00 <panic>
80105312:	66 90                	xchg   %ax,%ax
80105314:	66 90                	xchg   %ax,%ax
80105316:	66 90                	xchg   %ax,%ax
80105318:	66 90                	xchg   %ax,%ax
8010531a:	66 90                	xchg   %ax,%ax
8010531c:	66 90                	xchg   %ax,%ax
8010531e:	66 90                	xchg   %ax,%ax

80105320 <picinit>:
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	ba 21 00 00 00       	mov    $0x21,%edx
8010532a:	ee                   	out    %al,(%dx)
8010532b:	ba a1 00 00 00       	mov    $0xa1,%edx
80105330:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80105331:	c3                   	ret
80105332:	66 90                	xchg   %ax,%ax
80105334:	66 90                	xchg   %ax,%ax
80105336:	66 90                	xchg   %ax,%ax
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	56                   	push   %esi
80105345:	53                   	push   %ebx
80105346:	83 ec 0c             	sub    $0xc,%esp
80105349:	8b 75 08             	mov    0x8(%ebp),%esi
8010534c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010534f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80105355:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010535b:	e8 40 d9 ff ff       	call   80102ca0 <filealloc>
80105360:	89 06                	mov    %eax,(%esi)
80105362:	85 c0                	test   %eax,%eax
80105364:	0f 84 a5 00 00 00    	je     8010540f <pipealloc+0xcf>
8010536a:	e8 31 d9 ff ff       	call   80102ca0 <filealloc>
8010536f:	89 07                	mov    %eax,(%edi)
80105371:	85 c0                	test   %eax,%eax
80105373:	0f 84 84 00 00 00    	je     801053fd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80105379:	e8 f2 f1 ff ff       	call   80104570 <kalloc>
8010537e:	89 c3                	mov    %eax,%ebx
80105380:	85 c0                	test   %eax,%eax
80105382:	0f 84 a0 00 00 00    	je     80105428 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80105388:	c7 80 7c 02 00 00 01 	movl   $0x1,0x27c(%eax)
8010538f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80105392:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80105395:	c7 80 80 02 00 00 01 	movl   $0x1,0x280(%eax)
8010539c:	00 00 00 
  p->nwrite = 0;
8010539f:	c7 80 78 02 00 00 00 	movl   $0x0,0x278(%eax)
801053a6:	00 00 00 
  p->nread = 0;
801053a9:	c7 80 74 02 00 00 00 	movl   $0x0,0x274(%eax)
801053b0:	00 00 00 
  initlock(&p->lock, "pipe");
801053b3:	68 9a a5 10 80       	push   $0x8010a59a
801053b8:	50                   	push   %eax
801053b9:	e8 42 14 00 00       	call   80106800 <initlock>
  (*f0)->type = FD_PIPE;
801053be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801053c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801053c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801053c9:	8b 06                	mov    (%esi),%eax
801053cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801053cf:	8b 06                	mov    (%esi),%eax
801053d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801053d5:	8b 06                	mov    (%esi),%eax
801053d7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801053da:	8b 07                	mov    (%edi),%eax
801053dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801053e2:	8b 07                	mov    (%edi),%eax
801053e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801053e8:	8b 07                	mov    (%edi),%eax
801053ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801053ee:	8b 07                	mov    (%edi),%eax
801053f0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801053f3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801053f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f8:	5b                   	pop    %ebx
801053f9:	5e                   	pop    %esi
801053fa:	5f                   	pop    %edi
801053fb:	5d                   	pop    %ebp
801053fc:	c3                   	ret
  if(*f0)
801053fd:	8b 06                	mov    (%esi),%eax
801053ff:	85 c0                	test   %eax,%eax
80105401:	74 1e                	je     80105421 <pipealloc+0xe1>
    fileclose(*f0);
80105403:	83 ec 0c             	sub    $0xc,%esp
80105406:	50                   	push   %eax
80105407:	e8 54 d9 ff ff       	call   80102d60 <fileclose>
8010540c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010540f:	8b 07                	mov    (%edi),%eax
80105411:	85 c0                	test   %eax,%eax
80105413:	74 0c                	je     80105421 <pipealloc+0xe1>
    fileclose(*f1);
80105415:	83 ec 0c             	sub    $0xc,%esp
80105418:	50                   	push   %eax
80105419:	e8 42 d9 ff ff       	call   80102d60 <fileclose>
8010541e:	83 c4 10             	add    $0x10,%esp
  return -1;
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb cd                	jmp    801053f5 <pipealloc+0xb5>
  if(*f0)
80105428:	8b 06                	mov    (%esi),%eax
8010542a:	85 c0                	test   %eax,%eax
8010542c:	75 d5                	jne    80105403 <pipealloc+0xc3>
8010542e:	eb df                	jmp    8010540f <pipealloc+0xcf>

80105430 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	53                   	push   %ebx
80105435:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105438:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010543b:	83 ec 0c             	sub    $0xc,%esp
8010543e:	53                   	push   %ebx
8010543f:	e8 cc 15 00 00       	call   80106a10 <acquire>
  if(writable){
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 f6                	test   %esi,%esi
80105449:	74 65                	je     801054b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	8d 83 74 02 00 00    	lea    0x274(%ebx),%eax
    p->writeopen = 0;
80105454:	c7 83 80 02 00 00 00 	movl   $0x0,0x280(%ebx)
8010545b:	00 00 00 
    wakeup(&p->nread);
8010545e:	50                   	push   %eax
8010545f:	e8 dc 0b 00 00       	call   80106040 <wakeup>
80105464:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80105467:	8b 93 7c 02 00 00    	mov    0x27c(%ebx),%edx
8010546d:	85 d2                	test   %edx,%edx
8010546f:	75 0a                	jne    8010547b <pipeclose+0x4b>
80105471:	8b 83 80 02 00 00    	mov    0x280(%ebx),%eax
80105477:	85 c0                	test   %eax,%eax
80105479:	74 15                	je     80105490 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010547b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010547e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105481:	5b                   	pop    %ebx
80105482:	5e                   	pop    %esi
80105483:	5d                   	pop    %ebp
    release(&p->lock);
80105484:	e9 27 15 00 00       	jmp    801069b0 <release>
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	53                   	push   %ebx
80105494:	e8 17 15 00 00       	call   801069b0 <release>
    kfree((char*)p);
80105499:	83 c4 10             	add    $0x10,%esp
8010549c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010549f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a2:	5b                   	pop    %ebx
801054a3:	5e                   	pop    %esi
801054a4:	5d                   	pop    %ebp
    kfree((char*)p);
801054a5:	e9 06 ef ff ff       	jmp    801043b0 <kfree>
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	8d 83 78 02 00 00    	lea    0x278(%ebx),%eax
    p->readopen = 0;
801054b9:	c7 83 7c 02 00 00 00 	movl   $0x0,0x27c(%ebx)
801054c0:	00 00 00 
    wakeup(&p->nwrite);
801054c3:	50                   	push   %eax
801054c4:	e8 77 0b 00 00       	call   80106040 <wakeup>
801054c9:	83 c4 10             	add    $0x10,%esp
801054cc:	eb 99                	jmp    80105467 <pipeclose+0x37>
801054ce:	66 90                	xchg   %ax,%ax

801054d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	57                   	push   %edi
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
801054d6:	83 ec 28             	sub    $0x28,%esp
801054d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801054dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801054df:	53                   	push   %ebx
801054e0:	e8 2b 15 00 00       	call   80106a10 <acquire>
  for(i = 0; i < n; i++){
801054e5:	83 c4 10             	add    $0x10,%esp
801054e8:	85 ff                	test   %edi,%edi
801054ea:	0f 8e ce 00 00 00    	jle    801055be <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801054f0:	8b 83 78 02 00 00    	mov    0x278(%ebx),%eax
801054f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801054f9:	89 7d 10             	mov    %edi,0x10(%ebp)
801054fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801054ff:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80105502:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80105505:	8d b3 74 02 00 00    	lea    0x274(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010550b:	8b 83 74 02 00 00    	mov    0x274(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80105511:	8d bb 78 02 00 00    	lea    0x278(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80105517:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010551d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80105520:	0f 85 b6 00 00 00    	jne    801055dc <pipewrite+0x10c>
80105526:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80105529:	eb 3b                	jmp    80105566 <pipewrite+0x96>
8010552b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80105530:	e8 6b 03 00 00       	call   801058a0 <myproc>
80105535:	8b 48 24             	mov    0x24(%eax),%ecx
80105538:	85 c9                	test   %ecx,%ecx
8010553a:	75 34                	jne    80105570 <pipewrite+0xa0>
      wakeup(&p->nread);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	56                   	push   %esi
80105540:	e8 fb 0a 00 00       	call   80106040 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80105545:	58                   	pop    %eax
80105546:	5a                   	pop    %edx
80105547:	53                   	push   %ebx
80105548:	57                   	push   %edi
80105549:	e8 32 0a 00 00       	call   80105f80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010554e:	8b 83 74 02 00 00    	mov    0x274(%ebx),%eax
80105554:	8b 93 78 02 00 00    	mov    0x278(%ebx),%edx
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	05 00 02 00 00       	add    $0x200,%eax
80105562:	39 c2                	cmp    %eax,%edx
80105564:	75 2a                	jne    80105590 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80105566:	8b 83 7c 02 00 00    	mov    0x27c(%ebx),%eax
8010556c:	85 c0                	test   %eax,%eax
8010556e:	75 c0                	jne    80105530 <pipewrite+0x60>
        release(&p->lock);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	53                   	push   %ebx
80105574:	e8 37 14 00 00       	call   801069b0 <release>
        return -1;
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80105581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105584:	5b                   	pop    %ebx
80105585:	5e                   	pop    %esi
80105586:	5f                   	pop    %edi
80105587:	5d                   	pop    %ebp
80105588:	c3                   	ret
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80105593:	8d 42 01             	lea    0x1(%edx),%eax
80105596:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010559c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010559f:	89 83 78 02 00 00    	mov    %eax,0x278(%ebx)
801055a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801055a8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801055ac:	88 44 13 74          	mov    %al,0x74(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801055b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055b3:	39 c1                	cmp    %eax,%ecx
801055b5:	0f 85 50 ff ff ff    	jne    8010550b <pipewrite+0x3b>
801055bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801055be:	83 ec 0c             	sub    $0xc,%esp
801055c1:	8d 83 74 02 00 00    	lea    0x274(%ebx),%eax
801055c7:	50                   	push   %eax
801055c8:	e8 73 0a 00 00       	call   80106040 <wakeup>
  release(&p->lock);
801055cd:	89 1c 24             	mov    %ebx,(%esp)
801055d0:	e8 db 13 00 00       	call   801069b0 <release>
  return n;
801055d5:	83 c4 10             	add    $0x10,%esp
801055d8:	89 f8                	mov    %edi,%eax
801055da:	eb a5                	jmp    80105581 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801055dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801055df:	eb b2                	jmp    80105593 <pipewrite+0xc3>
801055e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055e8:	00 
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
801055f5:	53                   	push   %ebx
801055f6:	83 ec 18             	sub    $0x18,%esp
801055f9:	8b 75 08             	mov    0x8(%ebp),%esi
801055fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801055ff:	56                   	push   %esi
80105600:	8d 9e 74 02 00 00    	lea    0x274(%esi),%ebx
80105606:	e8 05 14 00 00       	call   80106a10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010560b:	8b 86 74 02 00 00    	mov    0x274(%esi),%eax
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	3b 86 78 02 00 00    	cmp    0x278(%esi),%eax
8010561a:	74 2f                	je     8010564b <piperead+0x5b>
8010561c:	eb 37                	jmp    80105655 <piperead+0x65>
8010561e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80105620:	e8 7b 02 00 00       	call   801058a0 <myproc>
80105625:	8b 40 24             	mov    0x24(%eax),%eax
80105628:	85 c0                	test   %eax,%eax
8010562a:	0f 85 80 00 00 00    	jne    801056b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
80105635:	e8 46 09 00 00       	call   80105f80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010563a:	8b 86 74 02 00 00    	mov    0x274(%esi),%eax
80105640:	83 c4 10             	add    $0x10,%esp
80105643:	3b 86 78 02 00 00    	cmp    0x278(%esi),%eax
80105649:	75 0a                	jne    80105655 <piperead+0x65>
8010564b:	8b 96 80 02 00 00    	mov    0x280(%esi),%edx
80105651:	85 d2                	test   %edx,%edx
80105653:	75 cb                	jne    80105620 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80105655:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105658:	31 db                	xor    %ebx,%ebx
8010565a:	85 c9                	test   %ecx,%ecx
8010565c:	7f 26                	jg     80105684 <piperead+0x94>
8010565e:	eb 2c                	jmp    8010568c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80105660:	8d 48 01             	lea    0x1(%eax),%ecx
80105663:	25 ff 01 00 00       	and    $0x1ff,%eax
80105668:	89 8e 74 02 00 00    	mov    %ecx,0x274(%esi)
8010566e:	0f b6 44 06 74       	movzbl 0x74(%esi,%eax,1),%eax
80105673:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80105676:	83 c3 01             	add    $0x1,%ebx
80105679:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010567c:	74 0e                	je     8010568c <piperead+0x9c>
8010567e:	8b 86 74 02 00 00    	mov    0x274(%esi),%eax
    if(p->nread == p->nwrite)
80105684:	3b 86 78 02 00 00    	cmp    0x278(%esi),%eax
8010568a:	75 d4                	jne    80105660 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	8d 86 78 02 00 00    	lea    0x278(%esi),%eax
80105695:	50                   	push   %eax
80105696:	e8 a5 09 00 00       	call   80106040 <wakeup>
  release(&p->lock);
8010569b:	89 34 24             	mov    %esi,(%esp)
8010569e:	e8 0d 13 00 00       	call   801069b0 <release>
  return i;
801056a3:	83 c4 10             	add    $0x10,%esp
}
801056a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a9:	89 d8                	mov    %ebx,%eax
801056ab:	5b                   	pop    %ebx
801056ac:	5e                   	pop    %esi
801056ad:	5f                   	pop    %edi
801056ae:	5d                   	pop    %ebp
801056af:	c3                   	ret
      release(&p->lock);
801056b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801056b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801056b8:	56                   	push   %esi
801056b9:	e8 f2 12 00 00       	call   801069b0 <release>
      return -1;
801056be:	83 c4 10             	add    $0x10,%esp
}
801056c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056c4:	89 d8                	mov    %ebx,%eax
801056c6:	5b                   	pop    %ebx
801056c7:	5e                   	pop    %esi
801056c8:	5f                   	pop    %edi
801056c9:	5d                   	pop    %ebp
801056ca:	c3                   	ret
801056cb:	66 90                	xchg   %ax,%ax
801056cd:	66 90                	xchg   %ax,%ax
801056cf:	90                   	nop

801056d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056d4:	bb 54 67 11 80       	mov    $0x80116754,%ebx
{
801056d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801056dc:	68 e0 66 11 80       	push   $0x801166e0
801056e1:	e8 2a 13 00 00       	call   80106a10 <acquire>
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	eb 14                	jmp    801056ff <allocproc+0x2f>
801056eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056f0:	83 eb 80             	sub    $0xffffff80,%ebx
801056f3:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
801056f9:	0f 84 81 00 00 00    	je     80105780 <allocproc+0xb0>
    if(p->state == UNUSED)
801056ff:	8b 43 0c             	mov    0xc(%ebx),%eax
80105702:	85 c0                	test   %eax,%eax
80105704:	75 ea                	jne    801056f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80105706:	a1 04 d0 10 80       	mov    0x8010d004,%eax

  release(&ptable.lock);
8010570b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010570e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80105715:	89 43 10             	mov    %eax,0x10(%ebx)
80105718:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010571b:	68 e0 66 11 80       	push   $0x801166e0
  p->pid = nextpid++;
80105720:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
  release(&ptable.lock);
80105726:	e8 85 12 00 00       	call   801069b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010572b:	e8 40 ee ff ff       	call   80104570 <kalloc>
80105730:	83 c4 10             	add    $0x10,%esp
80105733:	89 43 08             	mov    %eax,0x8(%ebx)
80105736:	85 c0                	test   %eax,%eax
80105738:	74 5f                	je     80105799 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010573a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80105740:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80105743:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80105748:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010574b:	c7 40 14 ff 89 10 80 	movl   $0x801089ff,0x14(%eax)
  p->context = (struct context*)sp;
80105752:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80105755:	6a 14                	push   $0x14
80105757:	6a 00                	push   $0x0
80105759:	50                   	push   %eax
8010575a:	e8 51 18 00 00       	call   80106fb0 <memset>
  p->context->eip = (uint)forkret;
8010575f:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->priority = PRIO_DEFAULT;

  return p;
80105762:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80105765:	c7 40 10 b0 57 10 80 	movl   $0x801057b0,0x10(%eax)
}
8010576c:	89 d8                	mov    %ebx,%eax
  p->priority = PRIO_DEFAULT;
8010576e:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
}
80105775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105778:	c9                   	leave
80105779:	c3                   	ret
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105780:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80105783:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80105785:	68 e0 66 11 80       	push   $0x801166e0
8010578a:	e8 21 12 00 00       	call   801069b0 <release>
  return 0;
8010578f:	83 c4 10             	add    $0x10,%esp
}
80105792:	89 d8                	mov    %ebx,%eax
80105794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105797:	c9                   	leave
80105798:	c3                   	ret
    p->state = UNUSED;
80105799:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801057a0:	31 db                	xor    %ebx,%ebx
801057a2:	eb ee                	jmp    80105792 <allocproc+0xc2>
801057a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ab:	00 
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801057b6:	68 e0 66 11 80       	push   $0x801166e0
801057bb:	e8 f0 11 00 00       	call   801069b0 <release>

  if (first) {
801057c0:	a1 00 d0 10 80       	mov    0x8010d000,%eax
801057c5:	83 c4 10             	add    $0x10,%esp
801057c8:	85 c0                	test   %eax,%eax
801057ca:	75 04                	jne    801057d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801057cc:	c9                   	leave
801057cd:	c3                   	ret
801057ce:	66 90                	xchg   %ax,%ax
    first = 0;
801057d0:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
801057d7:	00 00 00 
    iinit(ROOTDEV);
801057da:	83 ec 0c             	sub    $0xc,%esp
801057dd:	6a 01                	push   $0x1
801057df:	e8 fc db ff ff       	call   801033e0 <iinit>
    initlog(ROOTDEV);
801057e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057eb:	e8 d0 f3 ff ff       	call   80104bc0 <initlog>
}
801057f0:	83 c4 10             	add    $0x10,%esp
801057f3:	c9                   	leave
801057f4:	c3                   	ret
801057f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057fc:	00 
801057fd:	8d 76 00             	lea    0x0(%esi),%esi

80105800 <pinit>:
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80105806:	68 9f a5 10 80       	push   $0x8010a59f
8010580b:	68 e0 66 11 80       	push   $0x801166e0
80105810:	e8 eb 0f 00 00       	call   80106800 <initlock>
}
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	c9                   	leave
80105819:	c3                   	ret
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105820 <mycpu>:
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105825:	9c                   	pushf
80105826:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105827:	f6 c4 02             	test   $0x2,%ah
8010582a:	75 46                	jne    80105872 <mycpu+0x52>
  apicid = lapicid();
8010582c:	e8 af ef ff ff       	call   801047e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80105831:	8b 35 44 61 11 80    	mov    0x80116144,%esi
80105837:	85 f6                	test   %esi,%esi
80105839:	7e 2a                	jle    80105865 <mycpu+0x45>
8010583b:	31 d2                	xor    %edx,%edx
8010583d:	eb 08                	jmp    80105847 <mycpu+0x27>
8010583f:	90                   	nop
80105840:	83 c2 01             	add    $0x1,%edx
80105843:	39 f2                	cmp    %esi,%edx
80105845:	74 1e                	je     80105865 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80105847:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010584d:	0f b6 99 60 61 11 80 	movzbl -0x7fee9ea0(%ecx),%ebx
80105854:	39 c3                	cmp    %eax,%ebx
80105856:	75 e8                	jne    80105840 <mycpu+0x20>
}
80105858:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010585b:	8d 81 60 61 11 80    	lea    -0x7fee9ea0(%ecx),%eax
}
80105861:	5b                   	pop    %ebx
80105862:	5e                   	pop    %esi
80105863:	5d                   	pop    %ebp
80105864:	c3                   	ret
  panic("unknown apicid\n");
80105865:	83 ec 0c             	sub    $0xc,%esp
80105868:	68 a6 a5 10 80       	push   $0x8010a5a6
8010586d:	e8 8e b5 ff ff       	call   80100e00 <panic>
    panic("mycpu called with interrupts enabled\n");
80105872:	83 ec 0c             	sub    $0xc,%esp
80105875:	68 fc a9 10 80       	push   $0x8010a9fc
8010587a:	e8 81 b5 ff ff       	call   80100e00 <panic>
8010587f:	90                   	nop

80105880 <cpuid>:
cpuid() {
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80105886:	e8 95 ff ff ff       	call   80105820 <mycpu>
}
8010588b:	c9                   	leave
  return mycpu()-cpus;
8010588c:	2d 60 61 11 80       	sub    $0x80116160,%eax
80105891:	c1 f8 04             	sar    $0x4,%eax
80105894:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010589a:	c3                   	ret
8010589b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801058a0 <myproc>:
myproc(void) {
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801058a7:	e8 14 10 00 00       	call   801068c0 <pushcli>
  c = mycpu();
801058ac:	e8 6f ff ff ff       	call   80105820 <mycpu>
  p = c->proc;
801058b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801058b7:	e8 54 10 00 00       	call   80106910 <popcli>
}
801058bc:	89 d8                	mov    %ebx,%eax
801058be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c1:	c9                   	leave
801058c2:	c3                   	ret
801058c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ca:	00 
801058cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801058d0 <userinit>:
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801058d7:	e8 f4 fd ff ff       	call   801056d0 <allocproc>
801058dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801058de:	a3 54 87 11 80       	mov    %eax,0x80118754
  if((p->pgdir = setupkvm()) == 0)
801058e3:	e8 e8 46 00 00       	call   80109fd0 <setupkvm>
801058e8:	89 43 04             	mov    %eax,0x4(%ebx)
801058eb:	85 c0                	test   %eax,%eax
801058ed:	0f 84 bd 00 00 00    	je     801059b0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801058f3:	83 ec 04             	sub    $0x4,%esp
801058f6:	68 2c 00 00 00       	push   $0x2c
801058fb:	68 60 d4 10 80       	push   $0x8010d460
80105900:	50                   	push   %eax
80105901:	e8 aa 43 00 00       	call   80109cb0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80105906:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80105909:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010590f:	6a 4c                	push   $0x4c
80105911:	6a 00                	push   $0x0
80105913:	ff 73 18             	push   0x18(%ebx)
80105916:	e8 95 16 00 00       	call   80106fb0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010591b:	8b 43 18             	mov    0x18(%ebx),%eax
8010591e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80105923:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80105926:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010592b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010592f:	8b 43 18             	mov    0x18(%ebx),%eax
80105932:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80105936:	8b 43 18             	mov    0x18(%ebx),%eax
80105939:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010593d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80105941:	8b 43 18             	mov    0x18(%ebx),%eax
80105944:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80105948:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010594c:	8b 43 18             	mov    0x18(%ebx),%eax
8010594f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80105956:	8b 43 18             	mov    0x18(%ebx),%eax
80105959:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80105960:	8b 43 18             	mov    0x18(%ebx),%eax
80105963:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010596a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010596d:	6a 10                	push   $0x10
8010596f:	68 cf a5 10 80       	push   $0x8010a5cf
80105974:	50                   	push   %eax
80105975:	e8 e6 17 00 00       	call   80107160 <safestrcpy>
  p->cwd = namei("/");
8010597a:	c7 04 24 d8 a5 10 80 	movl   $0x8010a5d8,(%esp)
80105981:	e8 fa e5 ff ff       	call   80103f80 <namei>
80105986:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80105989:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105990:	e8 7b 10 00 00       	call   80106a10 <acquire>
  p->state = RUNNABLE;
80105995:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010599c:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
801059a3:	e8 08 10 00 00       	call   801069b0 <release>
}
801059a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ab:	83 c4 10             	add    $0x10,%esp
801059ae:	c9                   	leave
801059af:	c3                   	ret
    panic("userinit: out of memory?");
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	68 b6 a5 10 80       	push   $0x8010a5b6
801059b8:	e8 43 b4 ff ff       	call   80100e00 <panic>
801059bd:	8d 76 00             	lea    0x0(%esi),%esi

801059c0 <growproc>:
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	56                   	push   %esi
801059c4:	53                   	push   %ebx
801059c5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801059c8:	e8 f3 0e 00 00       	call   801068c0 <pushcli>
  c = mycpu();
801059cd:	e8 4e fe ff ff       	call   80105820 <mycpu>
  p = c->proc;
801059d2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801059d8:	e8 33 0f 00 00       	call   80106910 <popcli>
  sz = curproc->sz;
801059dd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801059df:	85 f6                	test   %esi,%esi
801059e1:	7f 1d                	jg     80105a00 <growproc+0x40>
  } else if(n < 0){
801059e3:	75 3b                	jne    80105a20 <growproc+0x60>
  switchuvm(curproc);
801059e5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801059e8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801059ea:	53                   	push   %ebx
801059eb:	e8 b0 41 00 00       	call   80109ba0 <switchuvm>
  return 0;
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	31 c0                	xor    %eax,%eax
}
801059f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059f8:	5b                   	pop    %ebx
801059f9:	5e                   	pop    %esi
801059fa:	5d                   	pop    %ebp
801059fb:	c3                   	ret
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105a00:	83 ec 04             	sub    $0x4,%esp
80105a03:	01 c6                	add    %eax,%esi
80105a05:	56                   	push   %esi
80105a06:	50                   	push   %eax
80105a07:	ff 73 04             	push   0x4(%ebx)
80105a0a:	e8 f1 43 00 00       	call   80109e00 <allocuvm>
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	85 c0                	test   %eax,%eax
80105a14:	75 cf                	jne    801059e5 <growproc+0x25>
      return -1;
80105a16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1b:	eb d8                	jmp    801059f5 <growproc+0x35>
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105a20:	83 ec 04             	sub    $0x4,%esp
80105a23:	01 c6                	add    %eax,%esi
80105a25:	56                   	push   %esi
80105a26:	50                   	push   %eax
80105a27:	ff 73 04             	push   0x4(%ebx)
80105a2a:	e8 f1 44 00 00       	call   80109f20 <deallocuvm>
80105a2f:	83 c4 10             	add    $0x10,%esp
80105a32:	85 c0                	test   %eax,%eax
80105a34:	75 af                	jne    801059e5 <growproc+0x25>
80105a36:	eb de                	jmp    80105a16 <growproc+0x56>
80105a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a3f:	00 

80105a40 <fork>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
80105a46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80105a49:	e8 72 0e 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105a4e:	e8 cd fd ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105a53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105a59:	e8 b2 0e 00 00       	call   80106910 <popcli>
  if((np = allocproc()) == 0){
80105a5e:	e8 6d fc ff ff       	call   801056d0 <allocproc>
80105a63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105a66:	85 c0                	test   %eax,%eax
80105a68:	0f 84 e6 00 00 00    	je     80105b54 <fork+0x114>
80105a6e:	89 c7                	mov    %eax,%edi
  np->priority = curproc->priority;
80105a70:	8b 43 7c             	mov    0x7c(%ebx),%eax
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80105a73:	83 ec 08             	sub    $0x8,%esp
  np->priority = curproc->priority;
80105a76:	89 47 7c             	mov    %eax,0x7c(%edi)
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80105a79:	ff 33                	push   (%ebx)
80105a7b:	ff 73 04             	push   0x4(%ebx)
80105a7e:	e8 3d 46 00 00       	call   8010a0c0 <copyuvm>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	89 47 04             	mov    %eax,0x4(%edi)
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	0f 84 a4 00 00 00    	je     80105b35 <fork+0xf5>
  np->sz = curproc->sz;
80105a91:	8b 03                	mov    (%ebx),%eax
80105a93:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a96:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80105a98:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80105a9b:	89 c8                	mov    %ecx,%eax
80105a9d:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80105aa0:	b9 13 00 00 00       	mov    $0x13,%ecx
80105aa5:	8b 73 18             	mov    0x18(%ebx),%esi
80105aa8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80105aaa:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80105aac:	8b 40 18             	mov    0x18(%eax),%eax
80105aaf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80105ab6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abd:	00 
80105abe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80105ac0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	74 13                	je     80105adb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105ac8:	83 ec 0c             	sub    $0xc,%esp
80105acb:	50                   	push   %eax
80105acc:	e8 3f d2 ff ff       	call   80102d10 <filedup>
80105ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105ad4:	83 c4 10             	add    $0x10,%esp
80105ad7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80105adb:	83 c6 01             	add    $0x1,%esi
80105ade:	83 fe 10             	cmp    $0x10,%esi
80105ae1:	75 dd                	jne    80105ac0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80105ae3:	83 ec 0c             	sub    $0xc,%esp
80105ae6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105ae9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80105aec:	e8 ef da ff ff       	call   801035e0 <idup>
80105af1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105af4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105af7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105afa:	8d 47 6c             	lea    0x6c(%edi),%eax
80105afd:	6a 10                	push   $0x10
80105aff:	53                   	push   %ebx
80105b00:	50                   	push   %eax
80105b01:	e8 5a 16 00 00       	call   80107160 <safestrcpy>
  pid = np->pid;
80105b06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80105b09:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105b10:	e8 fb 0e 00 00       	call   80106a10 <acquire>
  np->state = RUNNABLE;
80105b15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80105b1c:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105b23:	e8 88 0e 00 00       	call   801069b0 <release>
  return pid;
80105b28:	83 c4 10             	add    $0x10,%esp
}
80105b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2e:	89 d8                	mov    %ebx,%eax
80105b30:	5b                   	pop    %ebx
80105b31:	5e                   	pop    %esi
80105b32:	5f                   	pop    %edi
80105b33:	5d                   	pop    %ebp
80105b34:	c3                   	ret
    kfree(np->kstack);
80105b35:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	ff 73 08             	push   0x8(%ebx)
80105b3e:	e8 6d e8 ff ff       	call   801043b0 <kfree>
    np->kstack = 0;
80105b43:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80105b4a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80105b4d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105b54:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b59:	eb d0                	jmp    80105b2b <fork+0xeb>
80105b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105b60 <scheduler>:
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80105b69:	e8 b2 fc ff ff       	call   80105820 <mycpu>
  c->proc = 0;
80105b6e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80105b75:	00 00 00 
  struct cpu *c = mycpu();
80105b78:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80105b7a:	8d 70 04             	lea    0x4(%eax),%esi
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80105b80:	fb                   	sti
    acquire(&ptable.lock);
80105b81:	83 ec 0c             	sub    $0xc,%esp
    struct proc *highp = 0;    // Highest-priority process to run (lower number = higher priority)
80105b84:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80105b86:	68 e0 66 11 80       	push   $0x801166e0
80105b8b:	e8 80 0e 00 00       	call   80106a10 <acquire>
80105b90:	83 c4 10             	add    $0x10,%esp
    int bestprio = 0x7fffffff; // Track the smallest priority value seen
80105b93:	b9 ff ff ff 7f       	mov    $0x7fffffff,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b98:	b8 54 67 11 80       	mov    $0x80116754,%eax
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80105ba0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80105ba4:	75 0b                	jne    80105bb1 <scheduler+0x51>
      if(p->priority < bestprio){
80105ba6:	8b 50 7c             	mov    0x7c(%eax),%edx
80105ba9:	39 d1                	cmp    %edx,%ecx
80105bab:	7e 04                	jle    80105bb1 <scheduler+0x51>
        bestprio = p->priority;
80105bad:	89 d1                	mov    %edx,%ecx
        highp = p;
80105baf:	89 c7                	mov    %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105bb1:	83 e8 80             	sub    $0xffffff80,%eax
80105bb4:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80105bb9:	75 e5                	jne    80105ba0 <scheduler+0x40>
    if(highp){
80105bbb:	85 ff                	test   %edi,%edi
80105bbd:	74 33                	je     80105bf2 <scheduler+0x92>
      switchuvm(highp);
80105bbf:	83 ec 0c             	sub    $0xc,%esp
      c->proc = highp;
80105bc2:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(highp);
80105bc8:	57                   	push   %edi
80105bc9:	e8 d2 3f 00 00       	call   80109ba0 <switchuvm>
      highp->state = RUNNING;
80105bce:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), highp->context);
80105bd5:	58                   	pop    %eax
80105bd6:	5a                   	pop    %edx
80105bd7:	ff 77 1c             	push   0x1c(%edi)
80105bda:	56                   	push   %esi
80105bdb:	e8 db 15 00 00       	call   801071bb <swtch>
      switchkvm();
80105be0:	e8 ab 3f 00 00       	call   80109b90 <switchkvm>
      c->proc = 0;
80105be5:	83 c4 10             	add    $0x10,%esp
80105be8:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80105bef:	00 00 00 
    release(&ptable.lock);
80105bf2:	83 ec 0c             	sub    $0xc,%esp
80105bf5:	68 e0 66 11 80       	push   $0x801166e0
80105bfa:	e8 b1 0d 00 00       	call   801069b0 <release>
  for(;;){
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	e9 79 ff ff ff       	jmp    80105b80 <scheduler+0x20>
80105c07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c0e:	00 
80105c0f:	90                   	nop

80105c10 <sched>:
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	56                   	push   %esi
80105c14:	53                   	push   %ebx
  pushcli();
80105c15:	e8 a6 0c 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105c1a:	e8 01 fc ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105c1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105c25:	e8 e6 0c 00 00       	call   80106910 <popcli>
  if(!holding(&ptable.lock))
80105c2a:	83 ec 0c             	sub    $0xc,%esp
80105c2d:	68 e0 66 11 80       	push   $0x801166e0
80105c32:	e8 39 0d 00 00       	call   80106970 <holding>
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	85 c0                	test   %eax,%eax
80105c3c:	74 4f                	je     80105c8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80105c3e:	e8 dd fb ff ff       	call   80105820 <mycpu>
80105c43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80105c4a:	75 68                	jne    80105cb4 <sched+0xa4>
  if(p->state == RUNNING)
80105c4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105c50:	74 55                	je     80105ca7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105c52:	9c                   	pushf
80105c53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105c54:	f6 c4 02             	test   $0x2,%ah
80105c57:	75 41                	jne    80105c9a <sched+0x8a>
  intena = mycpu()->intena;
80105c59:	e8 c2 fb ff ff       	call   80105820 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80105c5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80105c61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80105c67:	e8 b4 fb ff ff       	call   80105820 <mycpu>
80105c6c:	83 ec 08             	sub    $0x8,%esp
80105c6f:	ff 70 04             	push   0x4(%eax)
80105c72:	53                   	push   %ebx
80105c73:	e8 43 15 00 00       	call   801071bb <swtch>
  mycpu()->intena = intena;
80105c78:	e8 a3 fb ff ff       	call   80105820 <mycpu>
}
80105c7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80105c80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80105c86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c89:	5b                   	pop    %ebx
80105c8a:	5e                   	pop    %esi
80105c8b:	5d                   	pop    %ebp
80105c8c:	c3                   	ret
    panic("sched ptable.lock");
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 da a5 10 80       	push   $0x8010a5da
80105c95:	e8 66 b1 ff ff       	call   80100e00 <panic>
    panic("sched interruptible");
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	68 06 a6 10 80       	push   $0x8010a606
80105ca2:	e8 59 b1 ff ff       	call   80100e00 <panic>
    panic("sched running");
80105ca7:	83 ec 0c             	sub    $0xc,%esp
80105caa:	68 f8 a5 10 80       	push   $0x8010a5f8
80105caf:	e8 4c b1 ff ff       	call   80100e00 <panic>
    panic("sched locks");
80105cb4:	83 ec 0c             	sub    $0xc,%esp
80105cb7:	68 ec a5 10 80       	push   $0x8010a5ec
80105cbc:	e8 3f b1 ff ff       	call   80100e00 <panic>
80105cc1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cc8:	00 
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <exit>:
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
80105cd5:	53                   	push   %ebx
80105cd6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80105cd9:	e8 c2 fb ff ff       	call   801058a0 <myproc>
  if(curproc == initproc)
80105cde:	39 05 54 87 11 80    	cmp    %eax,0x80118754
80105ce4:	0f 84 fd 00 00 00    	je     80105de7 <exit+0x117>
80105cea:	89 c3                	mov    %eax,%ebx
80105cec:	8d 70 28             	lea    0x28(%eax),%esi
80105cef:	8d 78 68             	lea    0x68(%eax),%edi
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80105cf8:	8b 06                	mov    (%esi),%eax
80105cfa:	85 c0                	test   %eax,%eax
80105cfc:	74 12                	je     80105d10 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80105cfe:	83 ec 0c             	sub    $0xc,%esp
80105d01:	50                   	push   %eax
80105d02:	e8 59 d0 ff ff       	call   80102d60 <fileclose>
      curproc->ofile[fd] = 0;
80105d07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80105d0d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80105d10:	83 c6 04             	add    $0x4,%esi
80105d13:	39 f7                	cmp    %esi,%edi
80105d15:	75 e1                	jne    80105cf8 <exit+0x28>
  begin_op();
80105d17:	e8 44 ef ff ff       	call   80104c60 <begin_op>
  iput(curproc->cwd);
80105d1c:	83 ec 0c             	sub    $0xc,%esp
80105d1f:	ff 73 68             	push   0x68(%ebx)
80105d22:	e8 29 da ff ff       	call   80103750 <iput>
  end_op();
80105d27:	e8 a4 ef ff ff       	call   80104cd0 <end_op>
  curproc->cwd = 0;
80105d2c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  cpt_invalidate_pid(curproc->pid);
80105d33:	58                   	pop    %eax
80105d34:	ff 73 10             	push   0x10(%ebx)
80105d37:	e8 04 aa ff ff       	call   80100740 <cpt_invalidate_pid>
  acquire(&ptable.lock);
80105d3c:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105d43:	e8 c8 0c 00 00       	call   80106a10 <acquire>
  wakeup1(curproc->parent);
80105d48:	8b 53 14             	mov    0x14(%ebx),%edx
80105d4b:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105d4e:	b8 54 67 11 80       	mov    $0x80116754,%eax
80105d53:	eb 0d                	jmp    80105d62 <exit+0x92>
80105d55:	8d 76 00             	lea    0x0(%esi),%esi
80105d58:	83 e8 80             	sub    $0xffffff80,%eax
80105d5b:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80105d60:	74 1c                	je     80105d7e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80105d62:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105d66:	75 f0                	jne    80105d58 <exit+0x88>
80105d68:	3b 50 20             	cmp    0x20(%eax),%edx
80105d6b:	75 eb                	jne    80105d58 <exit+0x88>
      p->state = RUNNABLE;
80105d6d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105d74:	83 e8 80             	sub    $0xffffff80,%eax
80105d77:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80105d7c:	75 e4                	jne    80105d62 <exit+0x92>
      p->parent = initproc;
80105d7e:	8b 0d 54 87 11 80    	mov    0x80118754,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d84:	ba 54 67 11 80       	mov    $0x80116754,%edx
80105d89:	eb 10                	jmp    80105d9b <exit+0xcb>
80105d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d90:	83 ea 80             	sub    $0xffffff80,%edx
80105d93:	81 fa 54 87 11 80    	cmp    $0x80118754,%edx
80105d99:	74 33                	je     80105dce <exit+0xfe>
    if(p->parent == curproc){
80105d9b:	39 5a 14             	cmp    %ebx,0x14(%edx)
80105d9e:	75 f0                	jne    80105d90 <exit+0xc0>
      if(p->state == ZOMBIE)
80105da0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80105da4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80105da7:	75 e7                	jne    80105d90 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105da9:	b8 54 67 11 80       	mov    $0x80116754,%eax
80105dae:	eb 0a                	jmp    80105dba <exit+0xea>
80105db0:	83 e8 80             	sub    $0xffffff80,%eax
80105db3:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80105db8:	74 d6                	je     80105d90 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80105dba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105dbe:	75 f0                	jne    80105db0 <exit+0xe0>
80105dc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80105dc3:	75 eb                	jne    80105db0 <exit+0xe0>
      p->state = RUNNABLE;
80105dc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80105dcc:	eb e2                	jmp    80105db0 <exit+0xe0>
  curproc->state = ZOMBIE;
80105dce:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80105dd5:	e8 36 fe ff ff       	call   80105c10 <sched>
  panic("zombie exit");
80105dda:	83 ec 0c             	sub    $0xc,%esp
80105ddd:	68 27 a6 10 80       	push   $0x8010a627
80105de2:	e8 19 b0 ff ff       	call   80100e00 <panic>
    panic("init exiting");
80105de7:	83 ec 0c             	sub    $0xc,%esp
80105dea:	68 1a a6 10 80       	push   $0x8010a61a
80105def:	e8 0c b0 ff ff       	call   80100e00 <panic>
80105df4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dfb:	00 
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <wait>:
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	56                   	push   %esi
80105e04:	53                   	push   %ebx
  pushcli();
80105e05:	e8 b6 0a 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105e0a:	e8 11 fa ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105e0f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105e15:	e8 f6 0a 00 00       	call   80106910 <popcli>
  acquire(&ptable.lock);
80105e1a:	83 ec 0c             	sub    $0xc,%esp
80105e1d:	68 e0 66 11 80       	push   $0x801166e0
80105e22:	e8 e9 0b 00 00       	call   80106a10 <acquire>
80105e27:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80105e2a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e2c:	bb 54 67 11 80       	mov    $0x80116754,%ebx
80105e31:	eb 10                	jmp    80105e43 <wait+0x43>
80105e33:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e38:	83 eb 80             	sub    $0xffffff80,%ebx
80105e3b:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
80105e41:	74 1b                	je     80105e5e <wait+0x5e>
      if(p->parent != curproc)
80105e43:	39 73 14             	cmp    %esi,0x14(%ebx)
80105e46:	75 f0                	jne    80105e38 <wait+0x38>
      if(p->state == ZOMBIE){
80105e48:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105e4c:	74 62                	je     80105eb0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e4e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80105e51:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e56:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
80105e5c:	75 e5                	jne    80105e43 <wait+0x43>
    if(!havekids || curproc->killed){
80105e5e:	85 c0                	test   %eax,%eax
80105e60:	0f 84 a0 00 00 00    	je     80105f06 <wait+0x106>
80105e66:	8b 46 24             	mov    0x24(%esi),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	0f 85 95 00 00 00    	jne    80105f06 <wait+0x106>
  pushcli();
80105e71:	e8 4a 0a 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105e76:	e8 a5 f9 ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105e7b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105e81:	e8 8a 0a 00 00       	call   80106910 <popcli>
  if(p == 0)
80105e86:	85 db                	test   %ebx,%ebx
80105e88:	0f 84 8f 00 00 00    	je     80105f1d <wait+0x11d>
  p->chan = chan;
80105e8e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105e91:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105e98:	e8 73 fd ff ff       	call   80105c10 <sched>
  p->chan = 0;
80105e9d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80105ea4:	eb 84                	jmp    80105e2a <wait+0x2a>
80105ea6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ead:	00 
80105eae:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80105eb3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80105eb6:	ff 73 08             	push   0x8(%ebx)
80105eb9:	e8 f2 e4 ff ff       	call   801043b0 <kfree>
        p->kstack = 0;
80105ebe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80105ec5:	5a                   	pop    %edx
80105ec6:	ff 73 04             	push   0x4(%ebx)
80105ec9:	e8 82 40 00 00       	call   80109f50 <freevm>
        p->pid = 0;
80105ece:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80105ed5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80105edc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105ee0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80105ee7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80105eee:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105ef5:	e8 b6 0a 00 00       	call   801069b0 <release>
        return pid;
80105efa:	83 c4 10             	add    $0x10,%esp
}
80105efd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f00:	89 f0                	mov    %esi,%eax
80105f02:	5b                   	pop    %ebx
80105f03:	5e                   	pop    %esi
80105f04:	5d                   	pop    %ebp
80105f05:	c3                   	ret
      release(&ptable.lock);
80105f06:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105f09:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80105f0e:	68 e0 66 11 80       	push   $0x801166e0
80105f13:	e8 98 0a 00 00       	call   801069b0 <release>
      return -1;
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	eb e0                	jmp    80105efd <wait+0xfd>
    panic("sleep");
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	68 33 a6 10 80       	push   $0x8010a633
80105f25:	e8 d6 ae ff ff       	call   80100e00 <panic>
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f30 <yield>:
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	53                   	push   %ebx
80105f34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105f37:	68 e0 66 11 80       	push   $0x801166e0
80105f3c:	e8 cf 0a 00 00       	call   80106a10 <acquire>
  pushcli();
80105f41:	e8 7a 09 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105f46:	e8 d5 f8 ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105f4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105f51:	e8 ba 09 00 00       	call   80106910 <popcli>
  myproc()->state = RUNNABLE;
80105f56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80105f5d:	e8 ae fc ff ff       	call   80105c10 <sched>
  release(&ptable.lock);
80105f62:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105f69:	e8 42 0a 00 00       	call   801069b0 <release>
}
80105f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	c9                   	leave
80105f75:	c3                   	ret
80105f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f7d:	00 
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <sleep>:
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	57                   	push   %edi
80105f84:	56                   	push   %esi
80105f85:	53                   	push   %ebx
80105f86:	83 ec 0c             	sub    $0xc,%esp
80105f89:	8b 7d 08             	mov    0x8(%ebp),%edi
80105f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80105f8f:	e8 2c 09 00 00       	call   801068c0 <pushcli>
  c = mycpu();
80105f94:	e8 87 f8 ff ff       	call   80105820 <mycpu>
  p = c->proc;
80105f99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105f9f:	e8 6c 09 00 00       	call   80106910 <popcli>
  if(p == 0)
80105fa4:	85 db                	test   %ebx,%ebx
80105fa6:	0f 84 87 00 00 00    	je     80106033 <sleep+0xb3>
  if(lk == 0)
80105fac:	85 f6                	test   %esi,%esi
80105fae:	74 76                	je     80106026 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80105fb0:	81 fe e0 66 11 80    	cmp    $0x801166e0,%esi
80105fb6:	74 50                	je     80106008 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	68 e0 66 11 80       	push   $0x801166e0
80105fc0:	e8 4b 0a 00 00       	call   80106a10 <acquire>
    release(lk);
80105fc5:	89 34 24             	mov    %esi,(%esp)
80105fc8:	e8 e3 09 00 00       	call   801069b0 <release>
  p->chan = chan;
80105fcd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80105fd0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105fd7:	e8 34 fc ff ff       	call   80105c10 <sched>
  p->chan = 0;
80105fdc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80105fe3:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
80105fea:	e8 c1 09 00 00       	call   801069b0 <release>
    acquire(lk);
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff8:	5b                   	pop    %ebx
80105ff9:	5e                   	pop    %esi
80105ffa:	5f                   	pop    %edi
80105ffb:	5d                   	pop    %ebp
    acquire(lk);
80105ffc:	e9 0f 0a 00 00       	jmp    80106a10 <acquire>
80106001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80106008:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010600b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80106012:	e8 f9 fb ff ff       	call   80105c10 <sched>
  p->chan = 0;
80106017:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010601e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106021:	5b                   	pop    %ebx
80106022:	5e                   	pop    %esi
80106023:	5f                   	pop    %edi
80106024:	5d                   	pop    %ebp
80106025:	c3                   	ret
    panic("sleep without lk");
80106026:	83 ec 0c             	sub    $0xc,%esp
80106029:	68 39 a6 10 80       	push   $0x8010a639
8010602e:	e8 cd ad ff ff       	call   80100e00 <panic>
    panic("sleep");
80106033:	83 ec 0c             	sub    $0xc,%esp
80106036:	68 33 a6 10 80       	push   $0x8010a633
8010603b:	e8 c0 ad ff ff       	call   80100e00 <panic>

80106040 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	53                   	push   %ebx
80106044:	83 ec 10             	sub    $0x10,%esp
80106047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010604a:	68 e0 66 11 80       	push   $0x801166e0
8010604f:	e8 bc 09 00 00       	call   80106a10 <acquire>
80106054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80106057:	b8 54 67 11 80       	mov    $0x80116754,%eax
8010605c:	eb 0c                	jmp    8010606a <wakeup+0x2a>
8010605e:	66 90                	xchg   %ax,%ax
80106060:	83 e8 80             	sub    $0xffffff80,%eax
80106063:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80106068:	74 1c                	je     80106086 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010606a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010606e:	75 f0                	jne    80106060 <wakeup+0x20>
80106070:	3b 58 20             	cmp    0x20(%eax),%ebx
80106073:	75 eb                	jne    80106060 <wakeup+0x20>
      p->state = RUNNABLE;
80106075:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010607c:	83 e8 80             	sub    $0xffffff80,%eax
8010607f:	3d 54 87 11 80       	cmp    $0x80118754,%eax
80106084:	75 e4                	jne    8010606a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80106086:	c7 45 08 e0 66 11 80 	movl   $0x801166e0,0x8(%ebp)
}
8010608d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106090:	c9                   	leave
  release(&ptable.lock);
80106091:	e9 1a 09 00 00       	jmp    801069b0 <release>
80106096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010609d:	00 
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	53                   	push   %ebx
801060a4:	83 ec 10             	sub    $0x10,%esp
801060a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801060aa:	68 e0 66 11 80       	push   $0x801166e0
801060af:	e8 5c 09 00 00       	call   80106a10 <acquire>
801060b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801060b7:	b8 54 67 11 80       	mov    $0x80116754,%eax
801060bc:	eb 0c                	jmp    801060ca <kill+0x2a>
801060be:	66 90                	xchg   %ax,%ax
801060c0:	83 e8 80             	sub    $0xffffff80,%eax
801060c3:	3d 54 87 11 80       	cmp    $0x80118754,%eax
801060c8:	74 36                	je     80106100 <kill+0x60>
    if(p->pid == pid){
801060ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801060cd:	75 f1                	jne    801060c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801060cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801060d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801060da:	75 07                	jne    801060e3 <kill+0x43>
        p->state = RUNNABLE;
801060dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801060e3:	83 ec 0c             	sub    $0xc,%esp
801060e6:	68 e0 66 11 80       	push   $0x801166e0
801060eb:	e8 c0 08 00 00       	call   801069b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801060f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801060f3:	83 c4 10             	add    $0x10,%esp
801060f6:	31 c0                	xor    %eax,%eax
}
801060f8:	c9                   	leave
801060f9:	c3                   	ret
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	68 e0 66 11 80       	push   $0x801166e0
80106108:	e8 a3 08 00 00       	call   801069b0 <release>
}
8010610d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106118:	c9                   	leave
80106119:	c3                   	ret
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106120 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	57                   	push   %edi
80106124:	56                   	push   %esi
80106125:	8d 75 e8             	lea    -0x18(%ebp),%esi
80106128:	53                   	push   %ebx
80106129:	bb c0 67 11 80       	mov    $0x801167c0,%ebx
8010612e:	83 ec 3c             	sub    $0x3c,%esp
80106131:	eb 24                	jmp    80106157 <procdump+0x37>
80106133:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80106138:	83 ec 0c             	sub    $0xc,%esp
8010613b:	68 d7 a8 10 80       	push   $0x8010a8d7
80106140:	e8 cb b4 ff ff       	call   80101610 <cprintf>
80106145:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80106148:	83 eb 80             	sub    $0xffffff80,%ebx
8010614b:	81 fb c0 87 11 80    	cmp    $0x801187c0,%ebx
80106151:	0f 84 81 00 00 00    	je     801061d8 <procdump+0xb8>
    if(p->state == UNUSED)
80106157:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010615a:	85 c0                	test   %eax,%eax
8010615c:	74 ea                	je     80106148 <procdump+0x28>
      state = "???";
8010615e:	ba 4a a6 10 80       	mov    $0x8010a64a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80106163:	83 f8 05             	cmp    $0x5,%eax
80106166:	77 11                	ja     80106179 <procdump+0x59>
80106168:	8b 14 85 60 ae 10 80 	mov    -0x7fef51a0(,%eax,4),%edx
      state = "???";
8010616f:	b8 4a a6 10 80       	mov    $0x8010a64a,%eax
80106174:	85 d2                	test   %edx,%edx
80106176:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80106179:	53                   	push   %ebx
8010617a:	52                   	push   %edx
8010617b:	ff 73 a4             	push   -0x5c(%ebx)
8010617e:	68 4e a6 10 80       	push   $0x8010a64e
80106183:	e8 88 b4 ff ff       	call   80101610 <cprintf>
    if(p->state == SLEEPING){
80106188:	83 c4 10             	add    $0x10,%esp
8010618b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010618f:	75 a7                	jne    80106138 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80106191:	83 ec 08             	sub    $0x8,%esp
80106194:	8d 45 c0             	lea    -0x40(%ebp),%eax
80106197:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010619a:	50                   	push   %eax
8010619b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010619e:	8b 40 0c             	mov    0xc(%eax),%eax
801061a1:	83 c0 08             	add    $0x8,%eax
801061a4:	50                   	push   %eax
801061a5:	e8 96 06 00 00       	call   80106840 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801061aa:	83 c4 10             	add    $0x10,%esp
801061ad:	8d 76 00             	lea    0x0(%esi),%esi
801061b0:	8b 17                	mov    (%edi),%edx
801061b2:	85 d2                	test   %edx,%edx
801061b4:	74 82                	je     80106138 <procdump+0x18>
        cprintf(" %p", pc[i]);
801061b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801061b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801061bc:	52                   	push   %edx
801061bd:	68 8a a3 10 80       	push   $0x8010a38a
801061c2:	e8 49 b4 ff ff       	call   80101610 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	39 f7                	cmp    %esi,%edi
801061cc:	75 e2                	jne    801061b0 <procdump+0x90>
801061ce:	e9 65 ff ff ff       	jmp    80106138 <procdump+0x18>
801061d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801061d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061db:	5b                   	pop    %ebx
801061dc:	5e                   	pop    %esi
801061dd:	5f                   	pop    %edi
801061de:	5d                   	pop    %ebp
801061df:	c3                   	ret

801061e0 <process_family>:

int
process_family(int pid)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
  struct proc *p, *target=0, *parent =0;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801061e5:	be 54 67 11 80       	mov    $0x80116754,%esi
{
801061ea:	53                   	push   %ebx
801061eb:	83 ec 18             	sub    $0x18,%esp
801061ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801061f1:	68 e0 66 11 80       	push   $0x801166e0
801061f6:	e8 15 08 00 00       	call   80106a10 <acquire>
801061fb:	83 c4 10             	add    $0x10,%esp
801061fe:	eb 0f                	jmp    8010620f <process_family+0x2f>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80106200:	83 ee 80             	sub    $0xffffff80,%esi
80106203:	81 fe 54 87 11 80    	cmp    $0x80118754,%esi
80106209:	0f 84 46 01 00 00    	je     80106355 <process_family+0x175>
    if (p->state != UNUSED && p->pid == pid) {
8010620f:	8b 46 0c             	mov    0xc(%esi),%eax
80106212:	85 c0                	test   %eax,%eax
80106214:	74 ea                	je     80106200 <process_family+0x20>
80106216:	8b 46 10             	mov    0x10(%esi),%eax
80106219:	39 d8                	cmp    %ebx,%eax
8010621b:	75 e3                	jne    80106200 <process_family+0x20>
      target = p;
      parent = p->parent;   // safe while ptable.lock is held
8010621d:	8b 7e 14             	mov    0x14(%esi),%edi
  if (target == 0) {
    release(&ptable.lock);
    return -1;              // pid not found
  }

  cprintf("My id: %d, My parent id: %d\n",target->pid, parent ? parent->pid : -1);
80106220:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106225:	85 ff                	test   %edi,%edi
80106227:	74 03                	je     8010622c <process_family+0x4c>
80106229:	8b 57 10             	mov    0x10(%edi),%edx
8010622c:	83 ec 04             	sub    $0x4,%esp
8010622f:	52                   	push   %edx
80106230:	50                   	push   %eax
80106231:	68 57 a6 10 80       	push   $0x8010a657
80106236:	e8 d5 b3 ff ff       	call   80101610 <cprintf>

  cprintf("Children of process %d:\n", target->pid);
8010623b:	5b                   	pop    %ebx
8010623c:	58                   	pop    %eax
8010623d:	ff 76 10             	push   0x10(%esi)
80106240:	68 74 a6 10 80       	push   $0x8010a674
  int have_child = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80106245:	bb 54 67 11 80       	mov    $0x80116754,%ebx
  cprintf("Children of process %d:\n", target->pid);
8010624a:	e8 c1 b3 ff ff       	call   80101610 <cprintf>
8010624f:	83 c4 10             	add    $0x10,%esp
  int have_child = 0;
80106252:	31 c0                	xor    %eax,%eax
80106254:	eb 15                	jmp    8010626b <process_family+0x8b>
80106256:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010625d:	00 
8010625e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80106260:	83 eb 80             	sub    $0xffffff80,%ebx
80106263:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
80106269:	74 35                	je     801062a0 <process_family+0xc0>
    if (p->state != UNUSED && p->parent == target) {
8010626b:	8b 4b 0c             	mov    0xc(%ebx),%ecx
8010626e:	85 c9                	test   %ecx,%ecx
80106270:	74 ee                	je     80106260 <process_family+0x80>
80106272:	39 73 14             	cmp    %esi,0x14(%ebx)
80106275:	75 e9                	jne    80106260 <process_family+0x80>
      cprintf("Child pid: %d\n", p->pid);
80106277:	83 ec 08             	sub    $0x8,%esp
8010627a:	ff 73 10             	push   0x10(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010627d:	83 eb 80             	sub    $0xffffff80,%ebx
      cprintf("Child pid: %d\n", p->pid);
80106280:	68 8d a6 10 80       	push   $0x8010a68d
80106285:	e8 86 b3 ff ff       	call   80101610 <cprintf>
8010628a:	83 c4 10             	add    $0x10,%esp
      have_child = 1;
8010628d:	b8 01 00 00 00       	mov    $0x1,%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80106292:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
80106298:	75 d1                	jne    8010626b <process_family+0x8b>
8010629a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }
  if (!have_child)
801062a0:	85 c0                	test   %eax,%eax
801062a2:	0f 84 98 00 00 00    	je     80106340 <process_family+0x160>
    cprintf("No children.\n");

  cprintf("Siblings of process %d:\n", target->pid);
801062a8:	83 ec 08             	sub    $0x8,%esp
801062ab:	ff 76 10             	push   0x10(%esi)
  int have_sib = 0;
  if (parent) {
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801062ae:	bb 54 67 11 80       	mov    $0x80116754,%ebx
  cprintf("Siblings of process %d:\n", target->pid);
801062b3:	68 aa a6 10 80       	push   $0x8010a6aa
801062b8:	e8 53 b3 ff ff       	call   80101610 <cprintf>
  if (parent) {
801062bd:	83 c4 10             	add    $0x10,%esp
  int have_sib = 0;
801062c0:	31 c0                	xor    %eax,%eax
  if (parent) {
801062c2:	85 ff                	test   %edi,%edi
801062c4:	75 15                	jne    801062db <process_family+0xfb>
801062c6:	eb 66                	jmp    8010632e <process_family+0x14e>
801062c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062cf:	00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801062d0:	83 eb 80             	sub    $0xffffff80,%ebx
801062d3:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
801062d9:	74 35                	je     80106310 <process_family+0x130>
      if (p->state != UNUSED && p->parent == parent && p != target) {
801062db:	8b 53 0c             	mov    0xc(%ebx),%edx
801062de:	85 d2                	test   %edx,%edx
801062e0:	74 ee                	je     801062d0 <process_family+0xf0>
801062e2:	39 7b 14             	cmp    %edi,0x14(%ebx)
801062e5:	75 e9                	jne    801062d0 <process_family+0xf0>
801062e7:	39 de                	cmp    %ebx,%esi
801062e9:	74 e5                	je     801062d0 <process_family+0xf0>
        cprintf("Sibling pid: %d\n", p->pid);
801062eb:	83 ec 08             	sub    $0x8,%esp
801062ee:	ff 73 10             	push   0x10(%ebx)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801062f1:	83 eb 80             	sub    $0xffffff80,%ebx
        cprintf("Sibling pid: %d\n", p->pid);
801062f4:	68 d1 a6 10 80       	push   $0x8010a6d1
801062f9:	e8 12 b3 ff ff       	call   80101610 <cprintf>
801062fe:	83 c4 10             	add    $0x10,%esp
        have_sib = 1;
80106301:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80106306:	81 fb 54 87 11 80    	cmp    $0x80118754,%ebx
8010630c:	75 cd                	jne    801062db <process_family+0xfb>
8010630e:	66 90                	xchg   %ax,%ax
      }
    }
  }
  if (!have_sib)
80106310:	85 c0                	test   %eax,%eax
80106312:	74 1a                	je     8010632e <process_family+0x14e>
    cprintf("No siblings.\n");

  release(&ptable.lock);
80106314:	83 ec 0c             	sub    $0xc,%esp
80106317:	68 e0 66 11 80       	push   $0x801166e0
8010631c:	e8 8f 06 00 00       	call   801069b0 <release>
  return 0;
80106321:	83 c4 10             	add    $0x10,%esp
}
80106324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106327:	31 c0                	xor    %eax,%eax
}
80106329:	5b                   	pop    %ebx
8010632a:	5e                   	pop    %esi
8010632b:	5f                   	pop    %edi
8010632c:	5d                   	pop    %ebp
8010632d:	c3                   	ret
    cprintf("No siblings.\n");
8010632e:	83 ec 0c             	sub    $0xc,%esp
80106331:	68 c3 a6 10 80       	push   $0x8010a6c3
80106336:	e8 d5 b2 ff ff       	call   80101610 <cprintf>
8010633b:	83 c4 10             	add    $0x10,%esp
8010633e:	eb d4                	jmp    80106314 <process_family+0x134>
    cprintf("No children.\n");
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	68 9c a6 10 80       	push   $0x8010a69c
80106348:	e8 c3 b2 ff ff       	call   80101610 <cprintf>
8010634d:	83 c4 10             	add    $0x10,%esp
80106350:	e9 53 ff ff ff       	jmp    801062a8 <process_family+0xc8>
    release(&ptable.lock);
80106355:	83 ec 0c             	sub    $0xc,%esp
80106358:	68 e0 66 11 80       	push   $0x801166e0
8010635d:	e8 4e 06 00 00       	call   801069b0 <release>
    return -1;              // pid not found
80106362:	83 c4 10             	add    $0x10,%esp
}
80106365:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;              // pid not found
80106368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010636d:	5b                   	pop    %ebx
8010636e:	5e                   	pop    %esi
8010636f:	5f                   	pop    %edi
80106370:	5d                   	pop    %ebp
80106371:	c3                   	ret
80106372:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106379:	00 
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106380 <set_priority>:

int
set_priority(int pid, int new_priority)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	56                   	push   %esi
80106384:	53                   	push   %ebx
80106385:	8b 75 0c             	mov    0xc(%ebp),%esi
80106388:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old = -1;

  if(new_priority > PRIO_MIN || new_priority < PRIO_MAX)
8010638b:	83 fe 02             	cmp    $0x2,%esi
8010638e:	77 57                	ja     801063e7 <set_priority+0x67>
    return -1;

  acquire(&ptable.lock);
80106390:	83 ec 0c             	sub    $0xc,%esp
80106393:	68 e0 66 11 80       	push   $0x801166e0
80106398:	e8 73 06 00 00       	call   80106a10 <acquire>
8010639d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801063a0:	b8 54 67 11 80       	mov    $0x80116754,%eax
801063a5:	eb 13                	jmp    801063ba <set_priority+0x3a>
801063a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ae:	00 
801063af:	90                   	nop
801063b0:	83 e8 80             	sub    $0xffffff80,%eax
801063b3:	3d 54 87 11 80       	cmp    $0x80118754,%eax
801063b8:	74 26                	je     801063e0 <set_priority+0x60>
    if(p->pid == pid){
801063ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801063bd:	75 f1                	jne    801063b0 <set_priority+0x30>
      old = p->priority;
801063bf:	8b 58 7c             	mov    0x7c(%eax),%ebx
      p->priority = new_priority;
801063c2:	89 70 7c             	mov    %esi,0x7c(%eax)
      break;
    }
  }

  release(&ptable.lock);
801063c5:	83 ec 0c             	sub    $0xc,%esp
801063c8:	68 e0 66 11 80       	push   $0x801166e0
801063cd:	e8 de 05 00 00       	call   801069b0 <release>
  return old;
801063d2:	83 c4 10             	add    $0x10,%esp
}
801063d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063d8:	89 d8                	mov    %ebx,%eax
801063da:	5b                   	pop    %ebx
801063db:	5e                   	pop    %esi
801063dc:	5d                   	pop    %ebp
801063dd:	c3                   	ret
801063de:	66 90                	xchg   %ax,%ax
  int old = -1;
801063e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063e5:	eb de                	jmp    801063c5 <set_priority+0x45>
    return -1;
801063e7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063ec:	eb e7                	jmp    801063d5 <set_priority+0x55>
801063ee:	66 90                	xchg   %ax,%ax

801063f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	53                   	push   %ebx
801063f4:	83 ec 0c             	sub    $0xc,%esp
801063f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801063fa:	68 0c a7 10 80       	push   $0x8010a70c
801063ff:	8d 43 04             	lea    0x4(%ebx),%eax
80106402:	50                   	push   %eax
80106403:	e8 f8 03 00 00       	call   80106800 <initlock>
  lk->name = name;
80106408:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010640b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80106411:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80106414:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  lk->name = name;
8010641b:	89 43 78             	mov    %eax,0x78(%ebx)
}
8010641e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106421:	c9                   	leave
80106422:	c3                   	ret
80106423:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010642a:	00 
8010642b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106430 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	56                   	push   %esi
80106434:	53                   	push   %ebx
80106435:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80106438:	8d 73 04             	lea    0x4(%ebx),%esi
8010643b:	83 ec 0c             	sub    $0xc,%esp
8010643e:	56                   	push   %esi
8010643f:	e8 cc 05 00 00       	call   80106a10 <acquire>
  while (lk->locked) {
80106444:	8b 13                	mov    (%ebx),%edx
80106446:	83 c4 10             	add    $0x10,%esp
80106449:	85 d2                	test   %edx,%edx
8010644b:	74 16                	je     80106463 <acquiresleep+0x33>
8010644d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80106450:	83 ec 08             	sub    $0x8,%esp
80106453:	56                   	push   %esi
80106454:	53                   	push   %ebx
80106455:	e8 26 fb ff ff       	call   80105f80 <sleep>
  while (lk->locked) {
8010645a:	8b 03                	mov    (%ebx),%eax
8010645c:	83 c4 10             	add    $0x10,%esp
8010645f:	85 c0                	test   %eax,%eax
80106461:	75 ed                	jne    80106450 <acquiresleep+0x20>
  }
  lk->locked = 1;
80106463:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80106469:	e8 32 f4 ff ff       	call   801058a0 <myproc>
8010646e:	8b 40 10             	mov    0x10(%eax),%eax
80106471:	89 43 7c             	mov    %eax,0x7c(%ebx)
  release(&lk->lk);
80106474:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106477:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010647a:	5b                   	pop    %ebx
8010647b:	5e                   	pop    %esi
8010647c:	5d                   	pop    %ebp
  release(&lk->lk);
8010647d:	e9 2e 05 00 00       	jmp    801069b0 <release>
80106482:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106489:	00 
8010648a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106490 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
80106496:	83 ec 18             	sub    $0x18,%esp
80106499:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010649c:	8d 73 04             	lea    0x4(%ebx),%esi
8010649f:	56                   	push   %esi
801064a0:	e8 6b 05 00 00       	call   80106a10 <acquire>

  if(lk->locked == 0)
801064a5:	8b 03                	mov    (%ebx),%eax
801064a7:	83 c4 10             	add    $0x10,%esp
801064aa:	85 c0                	test   %eax,%eax
801064ac:	74 35                	je     801064e3 <releasesleep+0x53>
    panic("releasesleep: lock is not held");

  if(lk->pid != myproc()->pid)
801064ae:	8b 7b 7c             	mov    0x7c(%ebx),%edi
801064b1:	e8 ea f3 ff ff       	call   801058a0 <myproc>
801064b6:	3b 78 10             	cmp    0x10(%eax),%edi
801064b9:	75 35                	jne    801064f0 <releasesleep+0x60>
    panic("releasesleep: not owner");

  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
801064bb:	83 ec 0c             	sub    $0xc,%esp
  lk->locked = 0;
801064be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801064c4:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  wakeup(lk);
801064cb:	53                   	push   %ebx
801064cc:	e8 6f fb ff ff       	call   80106040 <wakeup>

  release(&lk->lk);
801064d1:	83 c4 10             	add    $0x10,%esp
801064d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801064d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064da:	5b                   	pop    %ebx
801064db:	5e                   	pop    %esi
801064dc:	5f                   	pop    %edi
801064dd:	5d                   	pop    %ebp
  release(&lk->lk);
801064de:	e9 cd 04 00 00       	jmp    801069b0 <release>
    panic("releasesleep: lock is not held");
801064e3:	83 ec 0c             	sub    $0xc,%esp
801064e6:	68 24 aa 10 80       	push   $0x8010aa24
801064eb:	e8 10 a9 ff ff       	call   80100e00 <panic>
    panic("releasesleep: not owner");
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	68 17 a7 10 80       	push   $0x8010a717
801064f8:	e8 03 a9 ff ff       	call   80100e00 <panic>
801064fd:	8d 76 00             	lea    0x0(%esi),%esi

80106500 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	57                   	push   %edi
80106504:	31 ff                	xor    %edi,%edi
80106506:	56                   	push   %esi
80106507:	53                   	push   %ebx
80106508:	83 ec 18             	sub    $0x18,%esp
8010650b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010650e:	8d 73 04             	lea    0x4(%ebx),%esi
80106511:	56                   	push   %esi
80106512:	e8 f9 04 00 00       	call   80106a10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80106517:	8b 03                	mov    (%ebx),%eax
80106519:	83 c4 10             	add    $0x10,%esp
8010651c:	85 c0                	test   %eax,%eax
8010651e:	75 18                	jne    80106538 <holdingsleep+0x38>
  release(&lk->lk);
80106520:	83 ec 0c             	sub    $0xc,%esp
80106523:	56                   	push   %esi
80106524:	e8 87 04 00 00       	call   801069b0 <release>
  return r;
}
80106529:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652c:	89 f8                	mov    %edi,%eax
8010652e:	5b                   	pop    %ebx
8010652f:	5e                   	pop    %esi
80106530:	5f                   	pop    %edi
80106531:	5d                   	pop    %ebp
80106532:	c3                   	ret
80106533:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80106538:	8b 5b 7c             	mov    0x7c(%ebx),%ebx
8010653b:	e8 60 f3 ff ff       	call   801058a0 <myproc>
80106540:	39 58 10             	cmp    %ebx,0x10(%eax)
80106543:	0f 94 c0             	sete   %al
80106546:	0f b6 c0             	movzbl %al,%eax
80106549:	89 c7                	mov    %eax,%edi
8010654b:	eb d3                	jmp    80106520 <holdingsleep+0x20>
8010654d:	8d 76 00             	lea    0x0(%esi),%esi

80106550 <sys_sleeplock_hold>:
static struct sleeplock testlk;
static int testlk_inited = 0;

int
sys_sleeplock_hold(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 08             	sub    $0x8,%esp
  if(!testlk_inited){
80106556:	8b 0d 60 87 11 80    	mov    0x80118760,%ecx
8010655c:	85 c9                	test   %ecx,%ecx
8010655e:	74 70                	je     801065d0 <sys_sleeplock_hold+0x80>
  acquire(&lk->lk);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	68 84 87 11 80       	push   $0x80118784
80106568:	e8 a3 04 00 00       	call   80106a10 <acquire>
  while (lk->locked) {
8010656d:	8b 15 80 87 11 80    	mov    0x80118780,%edx
80106573:	83 c4 10             	add    $0x10,%esp
80106576:	85 d2                	test   %edx,%edx
80106578:	74 24                	je     8010659e <sys_sleeplock_hold+0x4e>
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80106580:	83 ec 08             	sub    $0x8,%esp
80106583:	68 84 87 11 80       	push   $0x80118784
80106588:	68 80 87 11 80       	push   $0x80118780
8010658d:	e8 ee f9 ff ff       	call   80105f80 <sleep>
  while (lk->locked) {
80106592:	a1 80 87 11 80       	mov    0x80118780,%eax
80106597:	83 c4 10             	add    $0x10,%esp
8010659a:	85 c0                	test   %eax,%eax
8010659c:	75 e2                	jne    80106580 <sys_sleeplock_hold+0x30>
  lk->locked = 1;
8010659e:	c7 05 80 87 11 80 01 	movl   $0x1,0x80118780
801065a5:	00 00 00 
  lk->pid = myproc()->pid;
801065a8:	e8 f3 f2 ff ff       	call   801058a0 <myproc>
  release(&lk->lk);
801065ad:	83 ec 0c             	sub    $0xc,%esp
  lk->pid = myproc()->pid;
801065b0:	8b 40 10             	mov    0x10(%eax),%eax
  release(&lk->lk);
801065b3:	68 84 87 11 80       	push   $0x80118784
  lk->pid = myproc()->pid;
801065b8:	a3 fc 87 11 80       	mov    %eax,0x801187fc
  release(&lk->lk);
801065bd:	e8 ee 03 00 00       	call   801069b0 <release>
    initsleeplock(&testlk, "testlk");
    testlk_inited = 1;
  }
  acquiresleep(&testlk);
  return 0;
}
801065c2:	31 c0                	xor    %eax,%eax
801065c4:	c9                   	leave
801065c5:	c3                   	ret
801065c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065cd:	00 
801065ce:	66 90                	xchg   %ax,%ax
  initlock(&lk->lk, "sleep lock");
801065d0:	83 ec 08             	sub    $0x8,%esp
801065d3:	68 0c a7 10 80       	push   $0x8010a70c
801065d8:	68 84 87 11 80       	push   $0x80118784
801065dd:	e8 1e 02 00 00       	call   80106800 <initlock>
    testlk_inited = 1;
801065e2:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
801065e5:	c7 05 f8 87 11 80 2f 	movl   $0x8010a72f,0x801187f8
801065ec:	a7 10 80 
  lk->locked = 0;
801065ef:	c7 05 80 87 11 80 00 	movl   $0x0,0x80118780
801065f6:	00 00 00 
  lk->pid = 0;
801065f9:	c7 05 fc 87 11 80 00 	movl   $0x0,0x801187fc
80106600:	00 00 00 
    testlk_inited = 1;
80106603:	c7 05 60 87 11 80 01 	movl   $0x1,0x80118760
8010660a:	00 00 00 
8010660d:	e9 4e ff ff ff       	jmp    80106560 <sys_sleeplock_hold+0x10>
80106612:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106619:	00 
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106620 <sys_sleeplock_drop>:

int
sys_sleeplock_drop(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	83 ec 08             	sub    $0x8,%esp
  if(!testlk_inited){
80106626:	a1 60 87 11 80       	mov    0x80118760,%eax
8010662b:	85 c0                	test   %eax,%eax
8010662d:	74 11                	je     80106640 <sys_sleeplock_drop+0x20>
    initsleeplock(&testlk, "testlk");
    testlk_inited = 1;
  }
  releasesleep(&testlk);
8010662f:	83 ec 0c             	sub    $0xc,%esp
80106632:	68 80 87 11 80       	push   $0x80118780
80106637:	e8 54 fe ff ff       	call   80106490 <releasesleep>
  return 0;
}
8010663c:	31 c0                	xor    %eax,%eax
8010663e:	c9                   	leave
8010663f:	c3                   	ret
  initlock(&lk->lk, "sleep lock");
80106640:	83 ec 08             	sub    $0x8,%esp
80106643:	68 0c a7 10 80       	push   $0x8010a70c
80106648:	68 84 87 11 80       	push   $0x80118784
8010664d:	e8 ae 01 00 00       	call   80106800 <initlock>
    testlk_inited = 1;
80106652:	83 c4 10             	add    $0x10,%esp
  lk->name = name;
80106655:	c7 05 f8 87 11 80 2f 	movl   $0x8010a72f,0x801187f8
8010665c:	a7 10 80 
  lk->locked = 0;
8010665f:	c7 05 80 87 11 80 00 	movl   $0x0,0x80118780
80106666:	00 00 00 
  lk->pid = 0;
80106669:	c7 05 fc 87 11 80 00 	movl   $0x0,0x801187fc
80106670:	00 00 00 
    testlk_inited = 1;
80106673:	c7 05 60 87 11 80 01 	movl   $0x1,0x80118760
8010667a:	00 00 00 
8010667d:	eb b0                	jmp    8010662f <sys_sleeplock_drop+0xf>
8010667f:	90                   	nop

80106680 <init_plock>:
// One global lock instance (lab says one global lock is enough).
struct plock plock_global;

void
init_plock(struct plock *pl)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	53                   	push   %ebx
80106684:	83 ec 0c             	sub    $0xc,%esp
80106687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&pl->lk, "plock");
8010668a:	68 36 a7 10 80       	push   $0x8010a736
8010668f:	53                   	push   %ebx
80106690:	e8 6b 01 00 00       	call   80106800 <initlock>
  pl->locked = 0;
80106695:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  pl->owner = 0;
  pl->head = 0;
}
8010669c:	83 c4 10             	add    $0x10,%esp
  pl->owner = 0;
8010669f:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
  pl->head = 0;
801066a6:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
801066ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801066b0:	c9                   	leave
801066b1:	c3                   	ret
801066b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801066b9:	00 
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066c0 <plock_acquire>:
// Acquire with a given priority.
// If busy, enqueue current process + sleep.
// When it wakes, it must already "own" the lock (handoff).
void
plock_acquire(struct plock *pl, int priority)
{
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	57                   	push   %edi
801066c4:	56                   	push   %esi
801066c5:	53                   	push   %ebx
801066c6:	83 ec 0c             	sub    $0xc,%esp
801066c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801066cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct proc *cur = myproc();
801066cf:	e8 cc f1 ff ff       	call   801058a0 <myproc>

  acquire(&pl->lk);
801066d4:	83 ec 0c             	sub    $0xc,%esp
801066d7:	53                   	push   %ebx
  struct proc *cur = myproc();
801066d8:	89 c6                	mov    %eax,%esi
  acquire(&pl->lk);
801066da:	e8 31 03 00 00       	call   80106a10 <acquire>

  // If free, take it immediately.
  if(pl->locked == 0){
801066df:	8b 43 74             	mov    0x74(%ebx),%eax
801066e2:	83 c4 10             	add    $0x10,%esp
801066e5:	85 c0                	test   %eax,%eax
801066e7:	74 3f                	je     80106728 <plock_acquire+0x68>
    release(&pl->lk);
    return;
  }

  // Lock is busy => create a wait-node for this process.
  struct plock_node *n = (struct plock_node*)kalloc();
801066e9:	e8 82 de ff ff       	call   80104570 <kalloc>
  if(n == 0){
801066ee:	85 c0                	test   %eax,%eax
801066f0:	74 4f                	je     80106741 <plock_acquire+0x81>
    // Out of memory; simplest policy: release and panic.
    release(&pl->lk);
    panic("plock_acquire: kalloc failed");
  }

  n->p = cur;
801066f2:	89 30                	mov    %esi,(%eax)
  n->priority = priority;
801066f4:	89 78 04             	mov    %edi,0x4(%eax)
  n->next = pl->head;
801066f7:	8b 53 7c             	mov    0x7c(%ebx),%edx
801066fa:	89 50 08             	mov    %edx,0x8(%eax)
  pl->head = n;
801066fd:	89 43 7c             	mov    %eax,0x7c(%ebx)
  // sleep(chan, &pl->lk) will:
  //  - atomically release pl->lk
  //  - put process to sleep
  //  - re-acquire pl->lk when it wakes
  for(;;){
    sleep(cur, &pl->lk);
80106700:	83 ec 08             	sub    $0x8,%esp
80106703:	53                   	push   %ebx
80106704:	56                   	push   %esi
80106705:	e8 76 f8 ff ff       	call   80105f80 <sleep>

    // We only proceed when lock has been handed off to us.
    if(pl->owner == cur)
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	39 73 78             	cmp    %esi,0x78(%ebx)
80106710:	75 ee                	jne    80106700 <plock_acquire+0x40>
      break;
  }

  // At this point, we own the lock (handoff complete).
  release(&pl->lk);
80106712:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106718:	5b                   	pop    %ebx
80106719:	5e                   	pop    %esi
8010671a:	5f                   	pop    %edi
8010671b:	5d                   	pop    %ebp
  release(&pl->lk);
8010671c:	e9 8f 02 00 00       	jmp    801069b0 <release>
80106721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pl->locked = 1;
80106728:	c7 43 74 01 00 00 00 	movl   $0x1,0x74(%ebx)
    pl->owner = cur;
8010672f:	89 73 78             	mov    %esi,0x78(%ebx)
  release(&pl->lk);
80106732:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106738:	5b                   	pop    %ebx
80106739:	5e                   	pop    %esi
8010673a:	5f                   	pop    %edi
8010673b:	5d                   	pop    %ebp
  release(&pl->lk);
8010673c:	e9 6f 02 00 00       	jmp    801069b0 <release>
    release(&pl->lk);
80106741:	83 ec 0c             	sub    $0xc,%esp
80106744:	53                   	push   %ebx
80106745:	e8 66 02 00 00       	call   801069b0 <release>
    panic("plock_acquire: kalloc failed");
8010674a:	c7 04 24 3c a7 10 80 	movl   $0x8010a73c,(%esp)
80106751:	e8 aa a6 ff ff       	call   80100e00 <panic>
80106756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010675d:	00 
8010675e:	66 90                	xchg   %ax,%ax

80106760 <release_plock>:

void
release_plock(struct plock *pl)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	31 ff                	xor    %edi,%edi
80106766:	56                   	push   %esi
80106767:	53                   	push   %ebx
80106768:	83 ec 18             	sub    $0x18,%esp
8010676b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&pl->lk);
8010676e:	56                   	push   %esi
8010676f:	e8 9c 02 00 00       	call   80106a10 <acquire>

  // If no one is waiting, unlock fully.
  if(pl->head == 0){
80106774:	8b 5e 7c             	mov    0x7c(%esi),%ebx
80106777:	83 c4 10             	add    $0x10,%esp
8010677a:	31 c9                	xor    %ecx,%ecx
8010677c:	89 d8                	mov    %ebx,%eax
8010677e:	85 db                	test   %ebx,%ebx
80106780:	75 08                	jne    8010678a <release_plock+0x2a>
80106782:	eb 64                	jmp    801067e8 <release_plock+0x88>
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cur->priority > best->priority){
      best = cur;
      best_prev = prev;
    }
    prev = cur;
    cur = cur->next;
80106788:	89 d0                	mov    %edx,%eax
    if(cur->priority > best->priority){
8010678a:	8b 53 04             	mov    0x4(%ebx),%edx
8010678d:	39 50 04             	cmp    %edx,0x4(%eax)
80106790:	7e 04                	jle    80106796 <release_plock+0x36>
      best_prev = prev;
80106792:	89 cf                	mov    %ecx,%edi
      best = cur;
80106794:	89 c3                	mov    %eax,%ebx
    cur = cur->next;
80106796:	8b 50 08             	mov    0x8(%eax),%edx
  while(cur != 0){
80106799:	89 c1                	mov    %eax,%ecx
8010679b:	85 d2                	test   %edx,%edx
8010679d:	75 e9                	jne    80106788 <release_plock+0x28>
  }

  // Remove best from the list.
  if(best_prev == 0){
    // best is head
    pl->head = best->next;
8010679f:	8b 43 08             	mov    0x8(%ebx),%eax
  if(best_prev == 0){
801067a2:	85 ff                	test   %edi,%edi
801067a4:	74 3a                	je     801067e0 <release_plock+0x80>
  } else {
    best_prev->next = best->next;
801067a6:	89 47 08             	mov    %eax,0x8(%edi)
  }

  // Direct handoff: keep locked=1, just change owner to selected process.
  pl->locked = 1;
801067a9:	c7 46 74 01 00 00 00 	movl   $0x1,0x74(%esi)
  pl->owner = best->p;
801067b0:	8b 03                	mov    (%ebx),%eax

  // Wake only the selected process (not everyone).
  wakeup(best->p);
801067b2:	83 ec 0c             	sub    $0xc,%esp
  pl->owner = best->p;
801067b5:	89 46 78             	mov    %eax,0x78(%esi)
  wakeup(best->p);
801067b8:	50                   	push   %eax
801067b9:	e8 82 f8 ff ff       	call   80106040 <wakeup>

  // Free the node memory (no longer needed).
  kfree((char*)best);
801067be:	89 1c 24             	mov    %ebx,(%esp)
801067c1:	e8 ea db ff ff       	call   801043b0 <kfree>

  release(&pl->lk);
801067c6:	83 c4 10             	add    $0x10,%esp
801067c9:	89 75 08             	mov    %esi,0x8(%ebp)
}
801067cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067cf:	5b                   	pop    %ebx
801067d0:	5e                   	pop    %esi
801067d1:	5f                   	pop    %edi
801067d2:	5d                   	pop    %ebp
  release(&pl->lk);
801067d3:	e9 d8 01 00 00       	jmp    801069b0 <release>
801067d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801067df:	00 
    pl->head = best->next;
801067e0:	89 46 7c             	mov    %eax,0x7c(%esi)
801067e3:	eb c4                	jmp    801067a9 <release_plock+0x49>
801067e5:	8d 76 00             	lea    0x0(%esi),%esi
    pl->locked = 0;
801067e8:	c7 46 74 00 00 00 00 	movl   $0x0,0x74(%esi)
    pl->owner = 0;
801067ef:	c7 46 78 00 00 00 00 	movl   $0x0,0x78(%esi)
    release(&pl->lk);
801067f6:	eb d1                	jmp    801067c9 <release_plock+0x69>
801067f8:	66 90                	xchg   %ax,%ax
801067fa:	66 90                	xchg   %ax,%ax
801067fc:	66 90                	xchg   %ax,%ax
801067fe:	66 90                	xchg   %ax,%ax

80106800 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106806:	8d 41 34             	lea    0x34(%ecx),%eax
80106809:	8d 51 54             	lea    0x54(%ecx),%edx
8010680c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    
  for(int i = 0; i < NCPU; i++) {
    lk->count_acq[i] = 0;
80106810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(int i = 0; i < NCPU; i++) {
80106816:	83 c0 04             	add    $0x4,%eax
    lk->spins_total[i] = 0;
80106819:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(int i = 0; i < NCPU; i++) {
80106820:	39 d0                	cmp    %edx,%eax
80106822:	75 ec                	jne    80106810 <initlock+0x10>
  }

  lk->name = name;
80106824:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80106827:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  lk->cpu = 0;
8010682d:	c7 41 08 00 00 00 00 	movl   $0x0,0x8(%ecx)
  lk->name = name;
80106834:	89 41 04             	mov    %eax,0x4(%ecx)
}
80106837:	5d                   	pop    %ebp
80106838:	c3                   	ret
80106839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106840 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106840:	55                   	push   %ebp
80106841:	89 e5                	mov    %esp,%ebp
80106843:	53                   	push   %ebx
80106844:	8b 45 08             	mov    0x8(%ebp),%eax
80106847:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010684a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010684d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80106852:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80106857:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010685c:	76 10                	jbe    8010686e <getcallerpcs+0x2e>
8010685e:	eb 28                	jmp    80106888 <getcallerpcs+0x48>
80106860:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80106866:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010686c:	77 1a                	ja     80106888 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010686e:	8b 5a 04             	mov    0x4(%edx),%ebx
80106871:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80106874:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80106877:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80106879:	83 f8 0a             	cmp    $0xa,%eax
8010687c:	75 e2                	jne    80106860 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010687e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106881:	c9                   	leave
80106882:	c3                   	ret
80106883:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80106888:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010688b:	83 c1 28             	add    $0x28,%ecx
8010688e:	89 ca                	mov    %ecx,%edx
80106890:	29 c2                	sub    %eax,%edx
80106892:	83 e2 04             	and    $0x4,%edx
80106895:	74 11                	je     801068a8 <getcallerpcs+0x68>
    pcs[i] = 0;
80106897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010689d:	83 c0 04             	add    $0x4,%eax
801068a0:	39 c1                	cmp    %eax,%ecx
801068a2:	74 da                	je     8010687e <getcallerpcs+0x3e>
801068a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801068a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801068ae:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801068b1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801068b8:	39 c1                	cmp    %eax,%ecx
801068ba:	75 ec                	jne    801068a8 <getcallerpcs+0x68>
801068bc:	eb c0                	jmp    8010687e <getcallerpcs+0x3e>
801068be:	66 90                	xchg   %ax,%ax

801068c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	53                   	push   %ebx
801068c4:	83 ec 04             	sub    $0x4,%esp
801068c7:	9c                   	pushf
801068c8:	5b                   	pop    %ebx
  asm volatile("cli");
801068c9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801068ca:	e8 51 ef ff ff       	call   80105820 <mycpu>
801068cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801068d5:	85 c0                	test   %eax,%eax
801068d7:	74 17                	je     801068f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801068d9:	e8 42 ef ff ff       	call   80105820 <mycpu>
801068de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801068e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801068e8:	c9                   	leave
801068e9:	c3                   	ret
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801068f0:	e8 2b ef ff ff       	call   80105820 <mycpu>
801068f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801068fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80106901:	eb d6                	jmp    801068d9 <pushcli+0x19>
80106903:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010690a:	00 
8010690b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106910 <popcli>:

void
popcli(void)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106916:	9c                   	pushf
80106917:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80106918:	f6 c4 02             	test   $0x2,%ah
8010691b:	75 35                	jne    80106952 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010691d:	e8 fe ee ff ff       	call   80105820 <mycpu>
80106922:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80106929:	78 34                	js     8010695f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010692b:	e8 f0 ee ff ff       	call   80105820 <mycpu>
80106930:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80106936:	85 d2                	test   %edx,%edx
80106938:	74 06                	je     80106940 <popcli+0x30>
    sti();
}
8010693a:	c9                   	leave
8010693b:	c3                   	ret
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80106940:	e8 db ee ff ff       	call   80105820 <mycpu>
80106945:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010694b:	85 c0                	test   %eax,%eax
8010694d:	74 eb                	je     8010693a <popcli+0x2a>
  asm volatile("sti");
8010694f:	fb                   	sti
}
80106950:	c9                   	leave
80106951:	c3                   	ret
    panic("popcli - interruptible");
80106952:	83 ec 0c             	sub    $0xc,%esp
80106955:	68 59 a7 10 80       	push   $0x8010a759
8010695a:	e8 a1 a4 ff ff       	call   80100e00 <panic>
    panic("popcli");
8010695f:	83 ec 0c             	sub    $0xc,%esp
80106962:	68 70 a7 10 80       	push   $0x8010a770
80106967:	e8 94 a4 ff ff       	call   80100e00 <panic>
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106970 <holding>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	56                   	push   %esi
80106974:	53                   	push   %ebx
80106975:	8b 75 08             	mov    0x8(%ebp),%esi
80106978:	31 db                	xor    %ebx,%ebx
  pushcli();
8010697a:	e8 41 ff ff ff       	call   801068c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010697f:	8b 06                	mov    (%esi),%eax
80106981:	85 c0                	test   %eax,%eax
80106983:	75 0b                	jne    80106990 <holding+0x20>
  popcli();
80106985:	e8 86 ff ff ff       	call   80106910 <popcli>
}
8010698a:	89 d8                	mov    %ebx,%eax
8010698c:	5b                   	pop    %ebx
8010698d:	5e                   	pop    %esi
8010698e:	5d                   	pop    %ebp
8010698f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80106990:	8b 5e 08             	mov    0x8(%esi),%ebx
80106993:	e8 88 ee ff ff       	call   80105820 <mycpu>
80106998:	39 c3                	cmp    %eax,%ebx
8010699a:	0f 94 c3             	sete   %bl
  popcli();
8010699d:	e8 6e ff ff ff       	call   80106910 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801069a2:	0f b6 db             	movzbl %bl,%ebx
}
801069a5:	89 d8                	mov    %ebx,%eax
801069a7:	5b                   	pop    %ebx
801069a8:	5e                   	pop    %esi
801069a9:	5d                   	pop    %ebp
801069aa:	c3                   	ret
801069ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801069b0 <release>:
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	56                   	push   %esi
801069b4:	53                   	push   %ebx
801069b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801069b8:	e8 03 ff ff ff       	call   801068c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801069bd:	8b 03                	mov    (%ebx),%eax
801069bf:	85 c0                	test   %eax,%eax
801069c1:	75 15                	jne    801069d8 <release+0x28>
  popcli();
801069c3:	e8 48 ff ff ff       	call   80106910 <popcli>
    panic("release");
801069c8:	83 ec 0c             	sub    $0xc,%esp
801069cb:	68 77 a7 10 80       	push   $0x8010a777
801069d0:	e8 2b a4 ff ff       	call   80100e00 <panic>
801069d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801069d8:	8b 73 08             	mov    0x8(%ebx),%esi
801069db:	e8 40 ee ff ff       	call   80105820 <mycpu>
801069e0:	39 c6                	cmp    %eax,%esi
801069e2:	75 df                	jne    801069c3 <release+0x13>
  popcli();
801069e4:	e8 27 ff ff ff       	call   80106910 <popcli>
  lk->pcs[0] = 0;
801069e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801069f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801069f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801069fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80106a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a05:	5b                   	pop    %ebx
80106a06:	5e                   	pop    %esi
80106a07:	5d                   	pop    %ebp
  popcli();
80106a08:	e9 03 ff ff ff       	jmp    80106910 <popcli>
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi

80106a10 <acquire>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	56                   	push   %esi
80106a14:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80106a15:	e8 a6 fe ff ff       	call   801068c0 <pushcli>
  if(holding(lk))
80106a1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106a1d:	e8 9e fe ff ff       	call   801068c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80106a22:	8b 03                	mov    (%ebx),%eax
80106a24:	85 c0                	test   %eax,%eax
80106a26:	0f 85 d4 00 00 00    	jne    80106b00 <acquire+0xf0>
  popcli();
80106a2c:	e8 df fe ff ff       	call   80106910 <popcli>
  while(xchg(&lk->locked, 1) != 0) {
80106a31:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80106a34:	b8 01 00 00 00       	mov    $0x1,%eax
80106a39:	f0 87 02             	lock xchg %eax,(%edx)
80106a3c:	89 c3                	mov    %eax,%ebx
80106a3e:	85 c0                	test   %eax,%eax
80106a40:	74 1d                	je     80106a5f <acquire+0x4f>
80106a42:	31 db                	xor    %ebx,%ebx
80106a44:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a50:	8b 55 08             	mov    0x8(%ebp),%edx
    spins++; 
80106a53:	83 c3 01             	add    $0x1,%ebx
80106a56:	89 c8                	mov    %ecx,%eax
80106a58:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0) {
80106a5b:	85 c0                	test   %eax,%eax
80106a5d:	75 f1                	jne    80106a50 <acquire+0x40>
  __sync_synchronize();
80106a5f:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80106a64:	8b 75 08             	mov    0x8(%ebp),%esi
80106a67:	e8 b4 ed ff ff       	call   80105820 <mycpu>
  for(i = 0; i < 10; i++){
80106a6c:	31 c9                	xor    %ecx,%ecx
  lk->cpu = mycpu();
80106a6e:	89 46 08             	mov    %eax,0x8(%esi)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106a71:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
  getcallerpcs(&lk, lk->pcs);
80106a77:	8b 75 08             	mov    0x8(%ebp),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106a7a:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80106a7f:	77 3f                	ja     80106ac0 <acquire+0xb0>
  ebp = (uint*)v - 2;
80106a81:	89 ea                	mov    %ebp,%edx
80106a83:	eb 10                	jmp    80106a95 <acquire+0x85>
80106a85:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106a88:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106a8e:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
80106a93:	77 2b                	ja     80106ac0 <acquire+0xb0>
    pcs[i] = ebp[1];     // saved %eip
80106a95:	8b 42 04             	mov    0x4(%edx),%eax
80106a98:	89 44 8e 0c          	mov    %eax,0xc(%esi,%ecx,4)
  for(i = 0; i < 10; i++){
80106a9c:	83 c1 01             	add    $0x1,%ecx
    ebp = (uint*)ebp[0]; // saved %ebp
80106a9f:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80106aa1:	83 f9 0a             	cmp    $0xa,%ecx
80106aa4:	75 e2                	jne    80106a88 <acquire+0x78>
  int id = cpuid(); 
80106aa6:	e8 d5 ed ff ff       	call   80105880 <cpuid>
  lk->count_acq[id]++;
80106aab:	8b 55 08             	mov    0x8(%ebp),%edx
80106aae:	8d 04 82             	lea    (%edx,%eax,4),%eax
80106ab1:	83 40 34 01          	addl   $0x1,0x34(%eax)
  lk->spins_total[id] += spins;
80106ab5:	01 58 54             	add    %ebx,0x54(%eax)
}
80106ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106abb:	5b                   	pop    %ebx
80106abc:	5e                   	pop    %esi
80106abd:	5d                   	pop    %ebp
80106abe:	c3                   	ret
80106abf:	90                   	nop
80106ac0:	8d 44 8e 0c          	lea    0xc(%esi,%ecx,4),%eax
80106ac4:	83 c6 34             	add    $0x34,%esi
80106ac7:	89 f2                	mov    %esi,%edx
80106ac9:	29 c2                	sub    %eax,%edx
80106acb:	83 e2 04             	and    $0x4,%edx
80106ace:	74 10                	je     80106ae0 <acquire+0xd0>
    pcs[i] = 0;
80106ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106ad6:	83 c0 04             	add    $0x4,%eax
80106ad9:	39 f0                	cmp    %esi,%eax
80106adb:	74 c9                	je     80106aa6 <acquire+0x96>
80106add:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80106ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80106ae6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80106ae9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80106af0:	39 f0                	cmp    %esi,%eax
80106af2:	75 ec                	jne    80106ae0 <acquire+0xd0>
80106af4:	eb b0                	jmp    80106aa6 <acquire+0x96>
80106af6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106afd:	00 
80106afe:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80106b00:	8b 5b 08             	mov    0x8(%ebx),%ebx
80106b03:	e8 18 ed ff ff       	call   80105820 <mycpu>
80106b08:	39 c3                	cmp    %eax,%ebx
80106b0a:	0f 85 1c ff ff ff    	jne    80106a2c <acquire+0x1c>
  popcli();
80106b10:	e8 fb fd ff ff       	call   80106910 <popcli>
    panic("acquire");
80106b15:	83 ec 0c             	sub    $0xc,%esp
80106b18:	68 7f a7 10 80       	push   $0x8010a77f
80106b1d:	e8 de a2 ff ff       	call   80100e00 <panic>
80106b22:	66 90                	xchg   %ax,%ax
80106b24:	66 90                	xchg   %ax,%ax
80106b26:	66 90                	xchg   %ax,%ax
80106b28:	66 90                	xchg   %ax,%ax
80106b2a:	66 90                	xchg   %ax,%ax
80106b2c:	66 90                	xchg   %ax,%ax
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <rwlock_init>:
#include "rwlock.h"


void
rwlock_init(struct rwlock *rw, char *name)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	53                   	push   %ebx
80106b34:	83 ec 0c             	sub    $0xc,%esp
80106b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&rw->lk, "rwlock");
80106b3a:	68 8c a7 10 80       	push   $0x8010a78c
80106b3f:	53                   	push   %ebx
80106b40:	e8 bb fc ff ff       	call   80106800 <initlock>
  rw->num_of_readers = 0;
  rw->writer = 0;
  rw->num_of_waiting_writers = 0;
  rw->name = name;
80106b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  rw->wpid = 0;
}
80106b48:	83 c4 10             	add    $0x10,%esp
  rw->num_of_readers = 0;
80106b4b:	c7 43 74 00 00 00 00 	movl   $0x0,0x74(%ebx)
  rw->writer = 0;
80106b52:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
  rw->num_of_waiting_writers = 0;
80106b59:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  rw->name = name;
80106b60:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  rw->wpid = 0;
80106b66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80106b6d:	00 00 00 
}
80106b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b73:	c9                   	leave
80106b74:	c3                   	ret
80106b75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b7c:	00 
80106b7d:	8d 76 00             	lea    0x0(%esi),%esi

80106b80 <rwlock_acquire_read>:

void
rwlock_acquire_read(struct rwlock *rw)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	53                   	push   %ebx
80106b84:	83 ec 10             	sub    $0x10,%esp
80106b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&rw->lk);
80106b8a:	53                   	push   %ebx
80106b8b:	e8 80 fe ff ff       	call   80106a10 <acquire>

  // If a writer is active OR writers are waiting (writer preference),
  // num_of_readers must sleep.
  while(rw->writer || rw->num_of_waiting_writers > 0){
80106b90:	83 c4 10             	add    $0x10,%esp
80106b93:	eb 10                	jmp    80106ba5 <rwlock_acquire_read+0x25>
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(rw, &rw->lk);
80106b98:	83 ec 08             	sub    $0x8,%esp
80106b9b:	53                   	push   %ebx
80106b9c:	53                   	push   %ebx
80106b9d:	e8 de f3 ff ff       	call   80105f80 <sleep>
80106ba2:	83 c4 10             	add    $0x10,%esp
  while(rw->writer || rw->num_of_waiting_writers > 0){
80106ba5:	8b 53 78             	mov    0x78(%ebx),%edx
80106ba8:	85 d2                	test   %edx,%edx
80106baa:	75 ec                	jne    80106b98 <rwlock_acquire_read+0x18>
80106bac:	8b 43 7c             	mov    0x7c(%ebx),%eax
80106baf:	85 c0                	test   %eax,%eax
80106bb1:	7f e5                	jg     80106b98 <rwlock_acquire_read+0x18>
  }

  rw->num_of_readers++;
80106bb3:	83 43 74 01          	addl   $0x1,0x74(%ebx)
  release(&rw->lk);
80106bb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106bbd:	c9                   	leave
  release(&rw->lk);
80106bbe:	e9 ed fd ff ff       	jmp    801069b0 <release>
80106bc3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bca:	00 
80106bcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106bd0 <rwlock_release_read>:

void
rwlock_release_read(struct rwlock *rw)
{
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	53                   	push   %ebx
80106bd4:	83 ec 10             	sub    $0x10,%esp
80106bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&rw->lk);
80106bda:	53                   	push   %ebx
80106bdb:	e8 30 fe ff ff       	call   80106a10 <acquire>

  if(rw->num_of_readers < 1)
80106be0:	8b 43 74             	mov    0x74(%ebx),%eax
80106be3:	83 c4 10             	add    $0x10,%esp
80106be6:	85 c0                	test   %eax,%eax
80106be8:	7e 2e                	jle    80106c18 <rwlock_release_read+0x48>
    panic("rwlock_release_read: num_of_readers underflow");

  rw->num_of_readers--;
80106bea:	83 e8 01             	sub    $0x1,%eax
80106bed:	89 43 74             	mov    %eax,0x74(%ebx)

  // If this was the last reader, wake up waiting writer.
  if(rw->num_of_readers == 0)
80106bf0:	74 0e                	je     80106c00 <rwlock_release_read+0x30>
    wakeup(rw);

  release(&rw->lk);
80106bf2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106bf8:	c9                   	leave
  release(&rw->lk);
80106bf9:	e9 b2 fd ff ff       	jmp    801069b0 <release>
80106bfe:	66 90                	xchg   %ax,%ax
    wakeup(rw);
80106c00:	83 ec 0c             	sub    $0xc,%esp
80106c03:	53                   	push   %ebx
80106c04:	e8 37 f4 ff ff       	call   80106040 <wakeup>
80106c09:	83 c4 10             	add    $0x10,%esp
  release(&rw->lk);
80106c0c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c12:	c9                   	leave
  release(&rw->lk);
80106c13:	e9 98 fd ff ff       	jmp    801069b0 <release>
    panic("rwlock_release_read: num_of_readers underflow");
80106c18:	83 ec 0c             	sub    $0xc,%esp
80106c1b:	68 44 aa 10 80       	push   $0x8010aa44
80106c20:	e8 db a1 ff ff       	call   80100e00 <panic>
80106c25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c2c:	00 
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi

80106c30 <rwlock_acquire_write>:

void
rwlock_acquire_write(struct rwlock *rw)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	53                   	push   %ebx
80106c34:	83 ec 10             	sub    $0x10,%esp
80106c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&rw->lk);
80106c3a:	53                   	push   %ebx
80106c3b:	e8 d0 fd ff ff       	call   80106a10 <acquire>

  rw->num_of_waiting_writers++;
80106c40:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)

  // Writer needs exclusive access: no writer and no num_of_readers.
  while(rw->writer || rw->num_of_readers > 0){
80106c44:	83 c4 10             	add    $0x10,%esp
80106c47:	eb 14                	jmp    80106c5d <rwlock_acquire_write+0x2d>
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(rw, &rw->lk);
80106c50:	83 ec 08             	sub    $0x8,%esp
80106c53:	53                   	push   %ebx
80106c54:	53                   	push   %ebx
80106c55:	e8 26 f3 ff ff       	call   80105f80 <sleep>
80106c5a:	83 c4 10             	add    $0x10,%esp
  while(rw->writer || rw->num_of_readers > 0){
80106c5d:	8b 53 78             	mov    0x78(%ebx),%edx
80106c60:	85 d2                	test   %edx,%edx
80106c62:	75 ec                	jne    80106c50 <rwlock_acquire_write+0x20>
80106c64:	8b 43 74             	mov    0x74(%ebx),%eax
80106c67:	85 c0                	test   %eax,%eax
80106c69:	7f e5                	jg     80106c50 <rwlock_acquire_write+0x20>
  }

  rw->num_of_waiting_writers--;
80106c6b:	83 6b 7c 01          	subl   $0x1,0x7c(%ebx)
  rw->writer = 1;
80106c6f:	c7 43 78 01 00 00 00 	movl   $0x1,0x78(%ebx)
  rw->wpid = myproc()->pid;
80106c76:	e8 25 ec ff ff       	call   801058a0 <myproc>
80106c7b:	8b 40 10             	mov    0x10(%eax),%eax
80106c7e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)

  release(&rw->lk);
80106c84:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106c8a:	c9                   	leave
  release(&rw->lk);
80106c8b:	e9 20 fd ff ff       	jmp    801069b0 <release>

80106c90 <rwlock_release_write>:

void
rwlock_release_write(struct rwlock *rw)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	56                   	push   %esi
80106c94:	53                   	push   %ebx
80106c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&rw->lk);
80106c98:	83 ec 0c             	sub    $0xc,%esp
80106c9b:	53                   	push   %ebx
80106c9c:	e8 6f fd ff ff       	call   80106a10 <acquire>

  if(rw->writer == 0)
80106ca1:	8b 43 78             	mov    0x78(%ebx),%eax
80106ca4:	83 c4 10             	add    $0x10,%esp
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	74 3b                	je     80106ce6 <rwlock_release_write+0x56>
    panic("rwlock_release_write: no writer");

  if(rw->wpid != myproc()->pid)
80106cab:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80106cb1:	e8 ea eb ff ff       	call   801058a0 <myproc>
80106cb6:	3b 70 10             	cmp    0x10(%eax),%esi
80106cb9:	75 38                	jne    80106cf3 <rwlock_release_write+0x63>

  rw->writer = 0;
  rw->wpid = 0;

  // Wake everyone; num_of_readers/writers will re-check conditions.
  wakeup(rw);
80106cbb:	83 ec 0c             	sub    $0xc,%esp
  rw->writer = 0;
80106cbe:	c7 43 78 00 00 00 00 	movl   $0x0,0x78(%ebx)
  rw->wpid = 0;
80106cc5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80106ccc:	00 00 00 
  wakeup(rw);
80106ccf:	53                   	push   %ebx
80106cd0:	e8 6b f3 ff ff       	call   80106040 <wakeup>

  release(&rw->lk);
80106cd5:	83 c4 10             	add    $0x10,%esp
80106cd8:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106cde:	5b                   	pop    %ebx
80106cdf:	5e                   	pop    %esi
80106ce0:	5d                   	pop    %ebp
  release(&rw->lk);
80106ce1:	e9 ca fc ff ff       	jmp    801069b0 <release>
    panic("rwlock_release_write: no writer");
80106ce6:	83 ec 0c             	sub    $0xc,%esp
80106ce9:	68 74 aa 10 80       	push   $0x8010aa74
80106cee:	e8 0d a1 ff ff       	call   80100e00 <panic>
    panic("rwlock_release_write: not owner");
80106cf3:	83 ec 0c             	sub    $0xc,%esp
80106cf6:	68 94 aa 10 80       	push   $0x8010aa94
80106cfb:	e8 00 a1 ff ff       	call   80100e00 <panic>

80106d00 <sys_rwlock_rlock>:
  }
}

int
sys_rwlock_rlock(void)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	83 ec 08             	sub    $0x8,%esp
  if(!u_rw_inited){
80106d06:	8b 0d 80 88 11 80    	mov    0x80118880,%ecx
80106d0c:	85 c9                	test   %ecx,%ecx
80106d0e:	74 60                	je     80106d70 <sys_rwlock_rlock+0x70>
  acquire(&rw->lk);
80106d10:	83 ec 0c             	sub    $0xc,%esp
80106d13:	68 a0 88 11 80       	push   $0x801188a0
80106d18:	e8 f3 fc ff ff       	call   80106a10 <acquire>
  while(rw->writer || rw->num_of_waiting_writers > 0){
80106d1d:	83 c4 10             	add    $0x10,%esp
80106d20:	eb 1b                	jmp    80106d3d <sys_rwlock_rlock+0x3d>
80106d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(rw, &rw->lk);
80106d28:	83 ec 08             	sub    $0x8,%esp
80106d2b:	68 a0 88 11 80       	push   $0x801188a0
80106d30:	68 a0 88 11 80       	push   $0x801188a0
80106d35:	e8 46 f2 ff ff       	call   80105f80 <sleep>
80106d3a:	83 c4 10             	add    $0x10,%esp
  while(rw->writer || rw->num_of_waiting_writers > 0){
80106d3d:	8b 15 18 89 11 80    	mov    0x80118918,%edx
80106d43:	85 d2                	test   %edx,%edx
80106d45:	75 e1                	jne    80106d28 <sys_rwlock_rlock+0x28>
80106d47:	a1 1c 89 11 80       	mov    0x8011891c,%eax
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	7f d8                	jg     80106d28 <sys_rwlock_rlock+0x28>
  release(&rw->lk);
80106d50:	83 ec 0c             	sub    $0xc,%esp
  rw->num_of_readers++;
80106d53:	83 05 14 89 11 80 01 	addl   $0x1,0x80118914
  release(&rw->lk);
80106d5a:	68 a0 88 11 80       	push   $0x801188a0
80106d5f:	e8 4c fc ff ff       	call   801069b0 <release>
  rw_init_once();
  rwlock_acquire_read(&u_rw);
  return 0;
}
80106d64:	31 c0                	xor    %eax,%eax
80106d66:	c9                   	leave
80106d67:	c3                   	ret
80106d68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d6f:	00 
  initlock(&rw->lk, "rwlock");
80106d70:	83 ec 08             	sub    $0x8,%esp
80106d73:	68 8c a7 10 80       	push   $0x8010a78c
80106d78:	68 a0 88 11 80       	push   $0x801188a0
80106d7d:	e8 7e fa ff ff       	call   80106800 <initlock>
}
80106d82:	83 c4 10             	add    $0x10,%esp
  rw->num_of_readers = 0;
80106d85:	c7 05 14 89 11 80 00 	movl   $0x0,0x80118914
80106d8c:	00 00 00 
  rw->writer = 0;
80106d8f:	c7 05 18 89 11 80 00 	movl   $0x0,0x80118918
80106d96:	00 00 00 
  rw->num_of_waiting_writers = 0;
80106d99:	c7 05 1c 89 11 80 00 	movl   $0x0,0x8011891c
80106da0:	00 00 00 
  rw->name = name;
80106da3:	c7 05 20 89 11 80 87 	movl   $0x8010a787,0x80118920
80106daa:	a7 10 80 
  rw->wpid = 0;
80106dad:	c7 05 24 89 11 80 00 	movl   $0x0,0x80118924
80106db4:	00 00 00 
    u_rw_inited = 1;
80106db7:	c7 05 80 88 11 80 01 	movl   $0x1,0x80118880
80106dbe:	00 00 00 
}
80106dc1:	e9 4a ff ff ff       	jmp    80106d10 <sys_rwlock_rlock+0x10>
80106dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dcd:	00 
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <sys_rwlock_runlock>:

int
sys_rwlock_runlock(void)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	83 ec 08             	sub    $0x8,%esp
  if(!u_rw_inited){
80106dd6:	a1 80 88 11 80       	mov    0x80118880,%eax
80106ddb:	85 c0                	test   %eax,%eax
80106ddd:	74 41                	je     80106e20 <sys_rwlock_runlock+0x50>
  acquire(&rw->lk);
80106ddf:	83 ec 0c             	sub    $0xc,%esp
80106de2:	68 a0 88 11 80       	push   $0x801188a0
80106de7:	e8 24 fc ff ff       	call   80106a10 <acquire>
  if(rw->num_of_readers < 1)
80106dec:	a1 14 89 11 80       	mov    0x80118914,%eax
80106df1:	83 c4 10             	add    $0x10,%esp
80106df4:	85 c0                	test   %eax,%eax
80106df6:	0f 8e 99 00 00 00    	jle    80106e95 <sys_rwlock_runlock+0xc5>
  rw->num_of_readers--;
80106dfc:	83 e8 01             	sub    $0x1,%eax
80106dff:	a3 14 89 11 80       	mov    %eax,0x80118914
  if(rw->num_of_readers == 0)
80106e04:	74 7a                	je     80106e80 <sys_rwlock_runlock+0xb0>
  release(&rw->lk);
80106e06:	83 ec 0c             	sub    $0xc,%esp
80106e09:	68 a0 88 11 80       	push   $0x801188a0
80106e0e:	e8 9d fb ff ff       	call   801069b0 <release>
  rw_init_once();
  rwlock_release_read(&u_rw);
  return 0;
}
80106e13:	31 c0                	xor    %eax,%eax
80106e15:	c9                   	leave
80106e16:	c3                   	ret
80106e17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e1e:	00 
80106e1f:	90                   	nop
  initlock(&rw->lk, "rwlock");
80106e20:	83 ec 08             	sub    $0x8,%esp
80106e23:	68 8c a7 10 80       	push   $0x8010a78c
80106e28:	68 a0 88 11 80       	push   $0x801188a0
80106e2d:	e8 ce f9 ff ff       	call   80106800 <initlock>
}
80106e32:	83 c4 10             	add    $0x10,%esp
  rw->num_of_readers = 0;
80106e35:	c7 05 14 89 11 80 00 	movl   $0x0,0x80118914
80106e3c:	00 00 00 
  rw->writer = 0;
80106e3f:	c7 05 18 89 11 80 00 	movl   $0x0,0x80118918
80106e46:	00 00 00 
  rw->num_of_waiting_writers = 0;
80106e49:	c7 05 1c 89 11 80 00 	movl   $0x0,0x8011891c
80106e50:	00 00 00 
  rw->name = name;
80106e53:	c7 05 20 89 11 80 87 	movl   $0x8010a787,0x80118920
80106e5a:	a7 10 80 
  rw->wpid = 0;
80106e5d:	c7 05 24 89 11 80 00 	movl   $0x0,0x80118924
80106e64:	00 00 00 
    u_rw_inited = 1;
80106e67:	c7 05 80 88 11 80 01 	movl   $0x1,0x80118880
80106e6e:	00 00 00 
}
80106e71:	e9 69 ff ff ff       	jmp    80106ddf <sys_rwlock_runlock+0xf>
80106e76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e7d:	00 
80106e7e:	66 90                	xchg   %ax,%ax
    wakeup(rw);
80106e80:	83 ec 0c             	sub    $0xc,%esp
80106e83:	68 a0 88 11 80       	push   $0x801188a0
80106e88:	e8 b3 f1 ff ff       	call   80106040 <wakeup>
80106e8d:	83 c4 10             	add    $0x10,%esp
80106e90:	e9 71 ff ff ff       	jmp    80106e06 <sys_rwlock_runlock+0x36>
    panic("rwlock_release_read: num_of_readers underflow");
80106e95:	83 ec 0c             	sub    $0xc,%esp
80106e98:	68 44 aa 10 80       	push   $0x8010aa44
80106e9d:	e8 5e 9f ff ff       	call   80100e00 <panic>
80106ea2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ea9:	00 
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106eb0 <sys_rwlock_wlock>:

int
sys_rwlock_wlock(void)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	83 ec 08             	sub    $0x8,%esp
  if(!u_rw_inited){
80106eb6:	a1 80 88 11 80       	mov    0x80118880,%eax
80106ebb:	85 c0                	test   %eax,%eax
80106ebd:	74 11                	je     80106ed0 <sys_rwlock_wlock+0x20>
  rw_init_once();
  rwlock_acquire_write(&u_rw);
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 a0 88 11 80       	push   $0x801188a0
80106ec7:	e8 64 fd ff ff       	call   80106c30 <rwlock_acquire_write>
  return 0;
}
80106ecc:	31 c0                	xor    %eax,%eax
80106ece:	c9                   	leave
80106ecf:	c3                   	ret
  initlock(&rw->lk, "rwlock");
80106ed0:	83 ec 08             	sub    $0x8,%esp
80106ed3:	68 8c a7 10 80       	push   $0x8010a78c
80106ed8:	68 a0 88 11 80       	push   $0x801188a0
80106edd:	e8 1e f9 ff ff       	call   80106800 <initlock>
}
80106ee2:	83 c4 10             	add    $0x10,%esp
  rw->num_of_readers = 0;
80106ee5:	c7 05 14 89 11 80 00 	movl   $0x0,0x80118914
80106eec:	00 00 00 
  rw->writer = 0;
80106eef:	c7 05 18 89 11 80 00 	movl   $0x0,0x80118918
80106ef6:	00 00 00 
  rw->num_of_waiting_writers = 0;
80106ef9:	c7 05 1c 89 11 80 00 	movl   $0x0,0x8011891c
80106f00:	00 00 00 
  rw->name = name;
80106f03:	c7 05 20 89 11 80 87 	movl   $0x8010a787,0x80118920
80106f0a:	a7 10 80 
  rw->wpid = 0;
80106f0d:	c7 05 24 89 11 80 00 	movl   $0x0,0x80118924
80106f14:	00 00 00 
    u_rw_inited = 1;
80106f17:	c7 05 80 88 11 80 01 	movl   $0x1,0x80118880
80106f1e:	00 00 00 
}
80106f21:	eb 9c                	jmp    80106ebf <sys_rwlock_wlock+0xf>
80106f23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f2a:	00 
80106f2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106f30 <sys_rwlock_wunlock>:

int
sys_rwlock_wunlock(void)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	83 ec 08             	sub    $0x8,%esp
  if(!u_rw_inited){
80106f36:	a1 80 88 11 80       	mov    0x80118880,%eax
80106f3b:	85 c0                	test   %eax,%eax
80106f3d:	74 11                	je     80106f50 <sys_rwlock_wunlock+0x20>
  rw_init_once();
  rwlock_release_write(&u_rw);
80106f3f:	83 ec 0c             	sub    $0xc,%esp
80106f42:	68 a0 88 11 80       	push   $0x801188a0
80106f47:	e8 44 fd ff ff       	call   80106c90 <rwlock_release_write>
  return 0;
}
80106f4c:	31 c0                	xor    %eax,%eax
80106f4e:	c9                   	leave
80106f4f:	c3                   	ret
  initlock(&rw->lk, "rwlock");
80106f50:	83 ec 08             	sub    $0x8,%esp
80106f53:	68 8c a7 10 80       	push   $0x8010a78c
80106f58:	68 a0 88 11 80       	push   $0x801188a0
80106f5d:	e8 9e f8 ff ff       	call   80106800 <initlock>
}
80106f62:	83 c4 10             	add    $0x10,%esp
  rw->num_of_readers = 0;
80106f65:	c7 05 14 89 11 80 00 	movl   $0x0,0x80118914
80106f6c:	00 00 00 
  rw->writer = 0;
80106f6f:	c7 05 18 89 11 80 00 	movl   $0x0,0x80118918
80106f76:	00 00 00 
  rw->num_of_waiting_writers = 0;
80106f79:	c7 05 1c 89 11 80 00 	movl   $0x0,0x8011891c
80106f80:	00 00 00 
  rw->name = name;
80106f83:	c7 05 20 89 11 80 87 	movl   $0x8010a787,0x80118920
80106f8a:	a7 10 80 
  rw->wpid = 0;
80106f8d:	c7 05 24 89 11 80 00 	movl   $0x0,0x80118924
80106f94:	00 00 00 
    u_rw_inited = 1;
80106f97:	c7 05 80 88 11 80 01 	movl   $0x1,0x80118880
80106f9e:	00 00 00 
}
80106fa1:	eb 9c                	jmp    80106f3f <sys_rwlock_wunlock+0xf>
80106fa3:	66 90                	xchg   %ax,%ax
80106fa5:	66 90                	xchg   %ax,%ax
80106fa7:	66 90                	xchg   %ax,%ax
80106fa9:	66 90                	xchg   %ax,%ax
80106fab:	66 90                	xchg   %ax,%ax
80106fad:	66 90                	xchg   %ax,%ax
80106faf:	90                   	nop

80106fb0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80106fba:	89 d0                	mov    %edx,%eax
80106fbc:	09 c8                	or     %ecx,%eax
80106fbe:	a8 03                	test   $0x3,%al
80106fc0:	75 1e                	jne    80106fe0 <memset+0x30>
    c &= 0xFF;
80106fc2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106fc6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80106fc9:	89 d7                	mov    %edx,%edi
80106fcb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80106fd1:	fc                   	cld
80106fd2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80106fd4:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106fd7:	89 d0                	mov    %edx,%eax
80106fd9:	c9                   	leave
80106fda:	c3                   	ret
80106fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80106fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fe3:	89 d7                	mov    %edx,%edi
80106fe5:	fc                   	cld
80106fe6:	f3 aa                	rep stos %al,%es:(%edi)
80106fe8:	8b 7d fc             	mov    -0x4(%ebp),%edi
80106feb:	89 d0                	mov    %edx,%eax
80106fed:	c9                   	leave
80106fee:	c3                   	ret
80106fef:	90                   	nop

80106ff0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	56                   	push   %esi
80106ff4:	8b 75 10             	mov    0x10(%ebp),%esi
80106ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80106ffa:	53                   	push   %ebx
80106ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106ffe:	85 f6                	test   %esi,%esi
80107000:	74 2e                	je     80107030 <memcmp+0x40>
80107002:	01 c6                	add    %eax,%esi
80107004:	eb 14                	jmp    8010701a <memcmp+0x2a>
80107006:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700d:	00 
8010700e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80107010:	83 c0 01             	add    $0x1,%eax
80107013:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80107016:	39 f0                	cmp    %esi,%eax
80107018:	74 16                	je     80107030 <memcmp+0x40>
    if(*s1 != *s2)
8010701a:	0f b6 08             	movzbl (%eax),%ecx
8010701d:	0f b6 1a             	movzbl (%edx),%ebx
80107020:	38 d9                	cmp    %bl,%cl
80107022:	74 ec                	je     80107010 <memcmp+0x20>
      return *s1 - *s2;
80107024:	0f b6 c1             	movzbl %cl,%eax
80107027:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80107029:	5b                   	pop    %ebx
8010702a:	5e                   	pop    %esi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	5b                   	pop    %ebx
  return 0;
80107031:	31 c0                	xor    %eax,%eax
}
80107033:	5e                   	pop    %esi
80107034:	5d                   	pop    %ebp
80107035:	c3                   	ret
80107036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703d:	00 
8010703e:	66 90                	xchg   %ax,%ax

80107040 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	8b 55 08             	mov    0x8(%ebp),%edx
80107047:	8b 45 10             	mov    0x10(%ebp),%eax
8010704a:	56                   	push   %esi
8010704b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010704e:	39 d6                	cmp    %edx,%esi
80107050:	73 26                	jae    80107078 <memmove+0x38>
80107052:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80107055:	39 ca                	cmp    %ecx,%edx
80107057:	73 1f                	jae    80107078 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80107059:	85 c0                	test   %eax,%eax
8010705b:	74 0f                	je     8010706c <memmove+0x2c>
8010705d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80107060:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80107064:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80107067:	83 e8 01             	sub    $0x1,%eax
8010706a:	73 f4                	jae    80107060 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010706c:	5e                   	pop    %esi
8010706d:	89 d0                	mov    %edx,%eax
8010706f:	5f                   	pop    %edi
80107070:	5d                   	pop    %ebp
80107071:	c3                   	ret
80107072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80107078:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010707b:	89 d7                	mov    %edx,%edi
8010707d:	85 c0                	test   %eax,%eax
8010707f:	74 eb                	je     8010706c <memmove+0x2c>
80107081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80107088:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80107089:	39 ce                	cmp    %ecx,%esi
8010708b:	75 fb                	jne    80107088 <memmove+0x48>
}
8010708d:	5e                   	pop    %esi
8010708e:	89 d0                	mov    %edx,%eax
80107090:	5f                   	pop    %edi
80107091:	5d                   	pop    %ebp
80107092:	c3                   	ret
80107093:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010709a:	00 
8010709b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801070a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801070a0:	eb 9e                	jmp    80107040 <memmove>
801070a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070a9:	00 
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	53                   	push   %ebx
801070b4:	8b 55 10             	mov    0x10(%ebp),%edx
801070b7:	8b 45 08             	mov    0x8(%ebp),%eax
801070ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
801070bd:	85 d2                	test   %edx,%edx
801070bf:	75 16                	jne    801070d7 <strncmp+0x27>
801070c1:	eb 2d                	jmp    801070f0 <strncmp+0x40>
801070c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801070c8:	3a 19                	cmp    (%ecx),%bl
801070ca:	75 12                	jne    801070de <strncmp+0x2e>
    n--, p++, q++;
801070cc:	83 c0 01             	add    $0x1,%eax
801070cf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801070d2:	83 ea 01             	sub    $0x1,%edx
801070d5:	74 19                	je     801070f0 <strncmp+0x40>
801070d7:	0f b6 18             	movzbl (%eax),%ebx
801070da:	84 db                	test   %bl,%bl
801070dc:	75 ea                	jne    801070c8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801070de:	0f b6 00             	movzbl (%eax),%eax
801070e1:	0f b6 11             	movzbl (%ecx),%edx
}
801070e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801070e7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801070e8:	29 d0                	sub    %edx,%eax
}
801070ea:	c3                   	ret
801070eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801070f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	c9                   	leave
801070f6:	c3                   	ret
801070f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070fe:	00 
801070ff:	90                   	nop

80107100 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	8b 75 08             	mov    0x8(%ebp),%esi
80107108:	53                   	push   %ebx
80107109:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010710c:	89 f0                	mov    %esi,%eax
8010710e:	eb 15                	jmp    80107125 <strncpy+0x25>
80107110:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80107114:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107117:	83 c0 01             	add    $0x1,%eax
8010711a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010711e:	88 48 ff             	mov    %cl,-0x1(%eax)
80107121:	84 c9                	test   %cl,%cl
80107123:	74 13                	je     80107138 <strncpy+0x38>
80107125:	89 d3                	mov    %edx,%ebx
80107127:	83 ea 01             	sub    $0x1,%edx
8010712a:	85 db                	test   %ebx,%ebx
8010712c:	7f e2                	jg     80107110 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010712e:	5b                   	pop    %ebx
8010712f:	89 f0                	mov    %esi,%eax
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
80107134:	c3                   	ret
80107135:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80107138:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010713b:	83 e9 01             	sub    $0x1,%ecx
8010713e:	85 d2                	test   %edx,%edx
80107140:	74 ec                	je     8010712e <strncpy+0x2e>
80107142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80107148:	83 c0 01             	add    $0x1,%eax
8010714b:	89 ca                	mov    %ecx,%edx
8010714d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80107151:	29 c2                	sub    %eax,%edx
80107153:	85 d2                	test   %edx,%edx
80107155:	7f f1                	jg     80107148 <strncpy+0x48>
}
80107157:	5b                   	pop    %ebx
80107158:	89 f0                	mov    %esi,%eax
8010715a:	5e                   	pop    %esi
8010715b:	5f                   	pop    %edi
8010715c:	5d                   	pop    %ebp
8010715d:	c3                   	ret
8010715e:	66 90                	xchg   %ax,%ax

80107160 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	56                   	push   %esi
80107164:	8b 55 10             	mov    0x10(%ebp),%edx
80107167:	8b 75 08             	mov    0x8(%ebp),%esi
8010716a:	53                   	push   %ebx
8010716b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010716e:	85 d2                	test   %edx,%edx
80107170:	7e 25                	jle    80107197 <safestrcpy+0x37>
80107172:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80107176:	89 f2                	mov    %esi,%edx
80107178:	eb 16                	jmp    80107190 <safestrcpy+0x30>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80107180:	0f b6 08             	movzbl (%eax),%ecx
80107183:	83 c0 01             	add    $0x1,%eax
80107186:	83 c2 01             	add    $0x1,%edx
80107189:	88 4a ff             	mov    %cl,-0x1(%edx)
8010718c:	84 c9                	test   %cl,%cl
8010718e:	74 04                	je     80107194 <safestrcpy+0x34>
80107190:	39 d8                	cmp    %ebx,%eax
80107192:	75 ec                	jne    80107180 <safestrcpy+0x20>
    ;
  *s = 0;
80107194:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80107197:	89 f0                	mov    %esi,%eax
80107199:	5b                   	pop    %ebx
8010719a:	5e                   	pop    %esi
8010719b:	5d                   	pop    %ebp
8010719c:	c3                   	ret
8010719d:	8d 76 00             	lea    0x0(%esi),%esi

801071a0 <strlen>:

int
strlen(const char *s)
{
801071a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801071a1:	31 c0                	xor    %eax,%eax
{
801071a3:	89 e5                	mov    %esp,%ebp
801071a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801071a8:	80 3a 00             	cmpb   $0x0,(%edx)
801071ab:	74 0c                	je     801071b9 <strlen+0x19>
801071ad:	8d 76 00             	lea    0x0(%esi),%esi
801071b0:	83 c0 01             	add    $0x1,%eax
801071b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801071b7:	75 f7                	jne    801071b0 <strlen+0x10>
    ;
  return n;
}
801071b9:	5d                   	pop    %ebp
801071ba:	c3                   	ret

801071bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801071bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801071bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801071c3:	55                   	push   %ebp
  pushl %ebx
801071c4:	53                   	push   %ebx
  pushl %esi
801071c5:	56                   	push   %esi
  pushl %edi
801071c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801071c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801071c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801071cb:	5f                   	pop    %edi
  popl %esi
801071cc:	5e                   	pop    %esi
  popl %ebx
801071cd:	5b                   	pop    %ebx
  popl %ebp
801071ce:	5d                   	pop    %ebp
  ret
801071cf:	c3                   	ret

801071d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	53                   	push   %ebx
801071d4:	83 ec 04             	sub    $0x4,%esp
801071d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801071da:	e8 c1 e6 ff ff       	call   801058a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801071df:	8b 00                	mov    (%eax),%eax
801071e1:	39 c3                	cmp    %eax,%ebx
801071e3:	73 1b                	jae    80107200 <fetchint+0x30>
801071e5:	8d 53 04             	lea    0x4(%ebx),%edx
801071e8:	39 d0                	cmp    %edx,%eax
801071ea:	72 14                	jb     80107200 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801071ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801071ef:	8b 13                	mov    (%ebx),%edx
801071f1:	89 10                	mov    %edx,(%eax)
  return 0;
801071f3:	31 c0                	xor    %eax,%eax
}
801071f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801071f8:	c9                   	leave
801071f9:	c3                   	ret
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80107200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107205:	eb ee                	jmp    801071f5 <fetchint+0x25>
80107207:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010720e:	00 
8010720f:	90                   	nop

80107210 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	53                   	push   %ebx
80107214:	83 ec 04             	sub    $0x4,%esp
80107217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010721a:	e8 81 e6 ff ff       	call   801058a0 <myproc>

  if(addr >= curproc->sz)
8010721f:	3b 18                	cmp    (%eax),%ebx
80107221:	73 2d                	jae    80107250 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80107223:	8b 55 0c             	mov    0xc(%ebp),%edx
80107226:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80107228:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010722a:	39 d3                	cmp    %edx,%ebx
8010722c:	73 22                	jae    80107250 <fetchstr+0x40>
8010722e:	89 d8                	mov    %ebx,%eax
80107230:	eb 0d                	jmp    8010723f <fetchstr+0x2f>
80107232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107238:	83 c0 01             	add    $0x1,%eax
8010723b:	39 d0                	cmp    %edx,%eax
8010723d:	73 11                	jae    80107250 <fetchstr+0x40>
    if(*s == 0)
8010723f:	80 38 00             	cmpb   $0x0,(%eax)
80107242:	75 f4                	jne    80107238 <fetchstr+0x28>
      return s - *pp;
80107244:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80107246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107249:	c9                   	leave
8010724a:	c3                   	ret
8010724b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80107250:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80107253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107258:	c9                   	leave
80107259:	c3                   	ret
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107260 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	56                   	push   %esi
80107264:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80107265:	e8 36 e6 ff ff       	call   801058a0 <myproc>
8010726a:	8b 55 08             	mov    0x8(%ebp),%edx
8010726d:	8b 40 18             	mov    0x18(%eax),%eax
80107270:	8b 40 44             	mov    0x44(%eax),%eax
80107273:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80107276:	e8 25 e6 ff ff       	call   801058a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010727b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010727e:	8b 00                	mov    (%eax),%eax
80107280:	39 c6                	cmp    %eax,%esi
80107282:	73 1c                	jae    801072a0 <argint+0x40>
80107284:	8d 53 08             	lea    0x8(%ebx),%edx
80107287:	39 d0                	cmp    %edx,%eax
80107289:	72 15                	jb     801072a0 <argint+0x40>
  *ip = *(int*)(addr);
8010728b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010728e:	8b 53 04             	mov    0x4(%ebx),%edx
80107291:	89 10                	mov    %edx,(%eax)
  return 0;
80107293:	31 c0                	xor    %eax,%eax
}
80107295:	5b                   	pop    %ebx
80107296:	5e                   	pop    %esi
80107297:	5d                   	pop    %ebp
80107298:	c3                   	ret
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801072a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801072a5:	eb ee                	jmp    80107295 <argint+0x35>
801072a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072ae:	00 
801072af:	90                   	nop

801072b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
801072b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801072b9:	e8 e2 e5 ff ff       	call   801058a0 <myproc>
801072be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801072c0:	e8 db e5 ff ff       	call   801058a0 <myproc>
801072c5:	8b 55 08             	mov    0x8(%ebp),%edx
801072c8:	8b 40 18             	mov    0x18(%eax),%eax
801072cb:	8b 40 44             	mov    0x44(%eax),%eax
801072ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801072d1:	e8 ca e5 ff ff       	call   801058a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801072d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801072d9:	8b 00                	mov    (%eax),%eax
801072db:	39 c7                	cmp    %eax,%edi
801072dd:	73 31                	jae    80107310 <argptr+0x60>
801072df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801072e2:	39 c8                	cmp    %ecx,%eax
801072e4:	72 2a                	jb     80107310 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801072e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801072e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801072ec:	85 d2                	test   %edx,%edx
801072ee:	78 20                	js     80107310 <argptr+0x60>
801072f0:	8b 16                	mov    (%esi),%edx
801072f2:	39 d0                	cmp    %edx,%eax
801072f4:	73 1a                	jae    80107310 <argptr+0x60>
801072f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801072f9:	01 c3                	add    %eax,%ebx
801072fb:	39 da                	cmp    %ebx,%edx
801072fd:	72 11                	jb     80107310 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801072ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80107302:	89 02                	mov    %eax,(%edx)
  return 0;
80107304:	31 c0                	xor    %eax,%eax
}
80107306:	83 c4 0c             	add    $0xc,%esp
80107309:	5b                   	pop    %ebx
8010730a:	5e                   	pop    %esi
8010730b:	5f                   	pop    %edi
8010730c:	5d                   	pop    %ebp
8010730d:	c3                   	ret
8010730e:	66 90                	xchg   %ax,%ax
    return -1;
80107310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107315:	eb ef                	jmp    80107306 <argptr+0x56>
80107317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731e:	00 
8010731f:	90                   	nop

80107320 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	56                   	push   %esi
80107324:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80107325:	e8 76 e5 ff ff       	call   801058a0 <myproc>
8010732a:	8b 55 08             	mov    0x8(%ebp),%edx
8010732d:	8b 40 18             	mov    0x18(%eax),%eax
80107330:	8b 40 44             	mov    0x44(%eax),%eax
80107333:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80107336:	e8 65 e5 ff ff       	call   801058a0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010733b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010733e:	8b 00                	mov    (%eax),%eax
80107340:	39 c6                	cmp    %eax,%esi
80107342:	73 44                	jae    80107388 <argstr+0x68>
80107344:	8d 53 08             	lea    0x8(%ebx),%edx
80107347:	39 d0                	cmp    %edx,%eax
80107349:	72 3d                	jb     80107388 <argstr+0x68>
  *ip = *(int*)(addr);
8010734b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010734e:	e8 4d e5 ff ff       	call   801058a0 <myproc>
  if(addr >= curproc->sz)
80107353:	3b 18                	cmp    (%eax),%ebx
80107355:	73 31                	jae    80107388 <argstr+0x68>
  *pp = (char*)addr;
80107357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010735c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010735e:	39 d3                	cmp    %edx,%ebx
80107360:	73 26                	jae    80107388 <argstr+0x68>
80107362:	89 d8                	mov    %ebx,%eax
80107364:	eb 11                	jmp    80107377 <argstr+0x57>
80107366:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010736d:	00 
8010736e:	66 90                	xchg   %ax,%ax
80107370:	83 c0 01             	add    $0x1,%eax
80107373:	39 d0                	cmp    %edx,%eax
80107375:	73 11                	jae    80107388 <argstr+0x68>
    if(*s == 0)
80107377:	80 38 00             	cmpb   $0x0,(%eax)
8010737a:	75 f4                	jne    80107370 <argstr+0x50>
      return s - *pp;
8010737c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010737e:	5b                   	pop    %ebx
8010737f:	5e                   	pop    %esi
80107380:	5d                   	pop    %ebp
80107381:	c3                   	ret
80107382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107388:	5b                   	pop    %ebx
    return -1;
80107389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010738e:	5e                   	pop    %esi
8010738f:	5d                   	pop    %ebp
80107390:	c3                   	ret
80107391:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107398:	00 
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073a0 <syscall>:

};

void
syscall(void)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	53                   	push   %ebx
801073a4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801073a7:	e8 f4 e4 ff ff       	call   801058a0 <myproc>
801073ac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801073ae:	8b 40 18             	mov    0x18(%eax),%eax
801073b1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801073b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801073b7:	83 fa 27             	cmp    $0x27,%edx
801073ba:	77 24                	ja     801073e0 <syscall+0x40>
801073bc:	8b 14 85 80 ae 10 80 	mov    -0x7fef5180(,%eax,4),%edx
801073c3:	85 d2                	test   %edx,%edx
801073c5:	74 19                	je     801073e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801073c7:	ff d2                	call   *%edx
801073c9:	89 c2                	mov    %eax,%edx
801073cb:	8b 43 18             	mov    0x18(%ebx),%eax
801073ce:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801073d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073d4:	c9                   	leave
801073d5:	c3                   	ret
801073d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801073dd:	00 
801073de:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801073e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801073e1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801073e4:	50                   	push   %eax
801073e5:	ff 73 10             	push   0x10(%ebx)
801073e8:	68 93 a7 10 80       	push   $0x8010a793
801073ed:	e8 1e a2 ff ff       	call   80101610 <cprintf>
    curproc->tf->eax = -1;
801073f2:	8b 43 18             	mov    0x18(%ebx),%eax
801073f5:	83 c4 10             	add    $0x10,%esp
801073f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801073ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107402:	c9                   	leave
80107403:	c3                   	ret
80107404:	66 90                	xchg   %ax,%ax
80107406:	66 90                	xchg   %ax,%ax
80107408:	66 90                	xchg   %ax,%ax
8010740a:	66 90                	xchg   %ax,%ax
8010740c:	66 90                	xchg   %ax,%ax
8010740e:	66 90                	xchg   %ax,%ax

80107410 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107415:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80107418:	53                   	push   %ebx
80107419:	83 ec 34             	sub    $0x34,%esp
8010741c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010741f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107422:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80107425:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80107428:	57                   	push   %edi
80107429:	50                   	push   %eax
8010742a:	e8 71 cb ff ff       	call   80103fa0 <nameiparent>
8010742f:	83 c4 10             	add    $0x10,%esp
80107432:	85 c0                	test   %eax,%eax
80107434:	74 5e                	je     80107494 <create+0x84>
    return 0;
  ilock(dp);
80107436:	83 ec 0c             	sub    $0xc,%esp
80107439:	89 c3                	mov    %eax,%ebx
8010743b:	50                   	push   %eax
8010743c:	e8 cf c1 ff ff       	call   80103610 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80107441:	83 c4 0c             	add    $0xc,%esp
80107444:	6a 00                	push   $0x0
80107446:	57                   	push   %edi
80107447:	53                   	push   %ebx
80107448:	e8 83 c7 ff ff       	call   80103bd0 <dirlookup>
8010744d:	83 c4 10             	add    $0x10,%esp
80107450:	89 c6                	mov    %eax,%esi
80107452:	85 c0                	test   %eax,%eax
80107454:	74 4a                	je     801074a0 <create+0x90>
    iunlockput(dp);
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	53                   	push   %ebx
8010745a:	e8 71 c4 ff ff       	call   801038d0 <iunlockput>
    ilock(ip);
8010745f:	89 34 24             	mov    %esi,(%esp)
80107462:	e8 a9 c1 ff ff       	call   80103610 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80107467:	83 c4 10             	add    $0x10,%esp
8010746a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010746f:	75 17                	jne    80107488 <create+0x78>
80107471:	66 83 be 90 00 00 00 	cmpw   $0x2,0x90(%esi)
80107478:	02 
80107479:	75 0d                	jne    80107488 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010747b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010747e:	89 f0                	mov    %esi,%eax
80107480:	5b                   	pop    %ebx
80107481:	5e                   	pop    %esi
80107482:	5f                   	pop    %edi
80107483:	5d                   	pop    %ebp
80107484:	c3                   	ret
80107485:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80107488:	83 ec 0c             	sub    $0xc,%esp
8010748b:	56                   	push   %esi
8010748c:	e8 3f c4 ff ff       	call   801038d0 <iunlockput>
    return 0;
80107491:	83 c4 10             	add    $0x10,%esp
}
80107494:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107497:	31 f6                	xor    %esi,%esi
}
80107499:	5b                   	pop    %ebx
8010749a:	89 f0                	mov    %esi,%eax
8010749c:	5e                   	pop    %esi
8010749d:	5f                   	pop    %edi
8010749e:	5d                   	pop    %ebp
8010749f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
801074a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801074a4:	83 ec 08             	sub    $0x8,%esp
801074a7:	50                   	push   %eax
801074a8:	ff 33                	push   (%ebx)
801074aa:	e8 e1 bf ff ff       	call   80103490 <ialloc>
801074af:	83 c4 10             	add    $0x10,%esp
801074b2:	89 c6                	mov    %eax,%esi
801074b4:	85 c0                	test   %eax,%eax
801074b6:	0f 84 c7 00 00 00    	je     80107583 <create+0x173>
  ilock(ip);
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	50                   	push   %eax
801074c0:	e8 4b c1 ff ff       	call   80103610 <ilock>
  ip->major = major;
801074c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801074c9:	66 89 86 92 00 00 00 	mov    %ax,0x92(%esi)
  ip->minor = minor;
801074d0:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801074d4:	66 89 86 94 00 00 00 	mov    %ax,0x94(%esi)
  ip->nlink = 1;
801074db:	b8 01 00 00 00       	mov    $0x1,%eax
801074e0:	66 89 86 96 00 00 00 	mov    %ax,0x96(%esi)
  iupdate(ip);
801074e7:	89 34 24             	mov    %esi,(%esp)
801074ea:	e8 61 c0 ff ff       	call   80103550 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801074ef:	83 c4 10             	add    $0x10,%esp
801074f2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801074f7:	74 2f                	je     80107528 <create+0x118>
  if(dirlink(dp, name, ip->inum) < 0)
801074f9:	83 ec 04             	sub    $0x4,%esp
801074fc:	ff 76 04             	push   0x4(%esi)
801074ff:	57                   	push   %edi
80107500:	53                   	push   %ebx
80107501:	e8 ba c9 ff ff       	call   80103ec0 <dirlink>
80107506:	83 c4 10             	add    $0x10,%esp
80107509:	85 c0                	test   %eax,%eax
8010750b:	78 69                	js     80107576 <create+0x166>
  iunlockput(dp);
8010750d:	83 ec 0c             	sub    $0xc,%esp
80107510:	53                   	push   %ebx
80107511:	e8 ba c3 ff ff       	call   801038d0 <iunlockput>
  return ip;
80107516:	83 c4 10             	add    $0x10,%esp
}
80107519:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010751c:	89 f0                	mov    %esi,%eax
8010751e:	5b                   	pop    %ebx
8010751f:	5e                   	pop    %esi
80107520:	5f                   	pop    %edi
80107521:	5d                   	pop    %ebp
80107522:	c3                   	ret
80107523:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    iupdate(dp);
80107528:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
8010752b:	66 83 83 96 00 00 00 	addw   $0x1,0x96(%ebx)
80107532:	01 
    iupdate(dp);
80107533:	53                   	push   %ebx
80107534:	e8 17 c0 ff ff       	call   80103550 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107539:	83 c4 0c             	add    $0xc,%esp
8010753c:	ff 76 04             	push   0x4(%esi)
8010753f:	68 cb a7 10 80       	push   $0x8010a7cb
80107544:	56                   	push   %esi
80107545:	e8 76 c9 ff ff       	call   80103ec0 <dirlink>
8010754a:	83 c4 10             	add    $0x10,%esp
8010754d:	85 c0                	test   %eax,%eax
8010754f:	78 18                	js     80107569 <create+0x159>
80107551:	83 ec 04             	sub    $0x4,%esp
80107554:	ff 73 04             	push   0x4(%ebx)
80107557:	68 ca a7 10 80       	push   $0x8010a7ca
8010755c:	56                   	push   %esi
8010755d:	e8 5e c9 ff ff       	call   80103ec0 <dirlink>
80107562:	83 c4 10             	add    $0x10,%esp
80107565:	85 c0                	test   %eax,%eax
80107567:	79 90                	jns    801074f9 <create+0xe9>
      panic("create dots");
80107569:	83 ec 0c             	sub    $0xc,%esp
8010756c:	68 be a7 10 80       	push   $0x8010a7be
80107571:	e8 8a 98 ff ff       	call   80100e00 <panic>
    panic("create: dirlink");
80107576:	83 ec 0c             	sub    $0xc,%esp
80107579:	68 cd a7 10 80       	push   $0x8010a7cd
8010757e:	e8 7d 98 ff ff       	call   80100e00 <panic>
    panic("create: ialloc");
80107583:	83 ec 0c             	sub    $0xc,%esp
80107586:	68 af a7 10 80       	push   $0x8010a7af
8010758b:	e8 70 98 ff ff       	call   80100e00 <panic>

80107590 <sys_dup>:
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	56                   	push   %esi
80107594:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80107595:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107598:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010759b:	50                   	push   %eax
8010759c:	6a 00                	push   $0x0
8010759e:	e8 bd fc ff ff       	call   80107260 <argint>
801075a3:	83 c4 10             	add    $0x10,%esp
801075a6:	85 c0                	test   %eax,%eax
801075a8:	78 36                	js     801075e0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801075aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801075ae:	77 30                	ja     801075e0 <sys_dup+0x50>
801075b0:	e8 eb e2 ff ff       	call   801058a0 <myproc>
801075b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801075b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801075bc:	85 f6                	test   %esi,%esi
801075be:	74 20                	je     801075e0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801075c0:	e8 db e2 ff ff       	call   801058a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801075c5:	31 db                	xor    %ebx,%ebx
801075c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ce:	00 
801075cf:	90                   	nop
    if(curproc->ofile[fd] == 0){
801075d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801075d4:	85 d2                	test   %edx,%edx
801075d6:	74 18                	je     801075f0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801075d8:	83 c3 01             	add    $0x1,%ebx
801075db:	83 fb 10             	cmp    $0x10,%ebx
801075de:	75 f0                	jne    801075d0 <sys_dup+0x40>
}
801075e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801075e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801075e8:	89 d8                	mov    %ebx,%eax
801075ea:	5b                   	pop    %ebx
801075eb:	5e                   	pop    %esi
801075ec:	5d                   	pop    %ebp
801075ed:	c3                   	ret
801075ee:	66 90                	xchg   %ax,%ax
  filedup(f);
801075f0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801075f3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801075f7:	56                   	push   %esi
801075f8:	e8 13 b7 ff ff       	call   80102d10 <filedup>
  return fd;
801075fd:	83 c4 10             	add    $0x10,%esp
}
80107600:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107603:	89 d8                	mov    %ebx,%eax
80107605:	5b                   	pop    %ebx
80107606:	5e                   	pop    %esi
80107607:	5d                   	pop    %ebp
80107608:	c3                   	ret
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107610 <sys_read>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	56                   	push   %esi
80107614:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80107615:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80107618:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010761b:	53                   	push   %ebx
8010761c:	6a 00                	push   $0x0
8010761e:	e8 3d fc ff ff       	call   80107260 <argint>
80107623:	83 c4 10             	add    $0x10,%esp
80107626:	85 c0                	test   %eax,%eax
80107628:	78 5e                	js     80107688 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010762a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010762e:	77 58                	ja     80107688 <sys_read+0x78>
80107630:	e8 6b e2 ff ff       	call   801058a0 <myproc>
80107635:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107638:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010763c:	85 f6                	test   %esi,%esi
8010763e:	74 48                	je     80107688 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107640:	83 ec 08             	sub    $0x8,%esp
80107643:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107646:	50                   	push   %eax
80107647:	6a 02                	push   $0x2
80107649:	e8 12 fc ff ff       	call   80107260 <argint>
8010764e:	83 c4 10             	add    $0x10,%esp
80107651:	85 c0                	test   %eax,%eax
80107653:	78 33                	js     80107688 <sys_read+0x78>
80107655:	83 ec 04             	sub    $0x4,%esp
80107658:	ff 75 f0             	push   -0x10(%ebp)
8010765b:	53                   	push   %ebx
8010765c:	6a 01                	push   $0x1
8010765e:	e8 4d fc ff ff       	call   801072b0 <argptr>
80107663:	83 c4 10             	add    $0x10,%esp
80107666:	85 c0                	test   %eax,%eax
80107668:	78 1e                	js     80107688 <sys_read+0x78>
  return fileread(f, p, n);
8010766a:	83 ec 04             	sub    $0x4,%esp
8010766d:	ff 75 f0             	push   -0x10(%ebp)
80107670:	ff 75 f4             	push   -0xc(%ebp)
80107673:	56                   	push   %esi
80107674:	e8 17 b8 ff ff       	call   80102e90 <fileread>
80107679:	83 c4 10             	add    $0x10,%esp
}
8010767c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010767f:	5b                   	pop    %ebx
80107680:	5e                   	pop    %esi
80107681:	5d                   	pop    %ebp
80107682:	c3                   	ret
80107683:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80107688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010768d:	eb ed                	jmp    8010767c <sys_read+0x6c>
8010768f:	90                   	nop

80107690 <sys_write>:
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	56                   	push   %esi
80107694:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80107695:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80107698:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010769b:	53                   	push   %ebx
8010769c:	6a 00                	push   $0x0
8010769e:	e8 bd fb ff ff       	call   80107260 <argint>
801076a3:	83 c4 10             	add    $0x10,%esp
801076a6:	85 c0                	test   %eax,%eax
801076a8:	78 5e                	js     80107708 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801076aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801076ae:	77 58                	ja     80107708 <sys_write+0x78>
801076b0:	e8 eb e1 ff ff       	call   801058a0 <myproc>
801076b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801076bc:	85 f6                	test   %esi,%esi
801076be:	74 48                	je     80107708 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801076c0:	83 ec 08             	sub    $0x8,%esp
801076c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801076c6:	50                   	push   %eax
801076c7:	6a 02                	push   $0x2
801076c9:	e8 92 fb ff ff       	call   80107260 <argint>
801076ce:	83 c4 10             	add    $0x10,%esp
801076d1:	85 c0                	test   %eax,%eax
801076d3:	78 33                	js     80107708 <sys_write+0x78>
801076d5:	83 ec 04             	sub    $0x4,%esp
801076d8:	ff 75 f0             	push   -0x10(%ebp)
801076db:	53                   	push   %ebx
801076dc:	6a 01                	push   $0x1
801076de:	e8 cd fb ff ff       	call   801072b0 <argptr>
801076e3:	83 c4 10             	add    $0x10,%esp
801076e6:	85 c0                	test   %eax,%eax
801076e8:	78 1e                	js     80107708 <sys_write+0x78>
  return filewrite(f, p, n);
801076ea:	83 ec 04             	sub    $0x4,%esp
801076ed:	ff 75 f0             	push   -0x10(%ebp)
801076f0:	ff 75 f4             	push   -0xc(%ebp)
801076f3:	56                   	push   %esi
801076f4:	e8 27 b8 ff ff       	call   80102f20 <filewrite>
801076f9:	83 c4 10             	add    $0x10,%esp
}
801076fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076ff:	5b                   	pop    %ebx
80107700:	5e                   	pop    %esi
80107701:	5d                   	pop    %ebp
80107702:	c3                   	ret
80107703:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80107708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010770d:	eb ed                	jmp    801076fc <sys_write+0x6c>
8010770f:	90                   	nop

80107710 <sys_close>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	56                   	push   %esi
80107714:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80107715:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107718:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010771b:	50                   	push   %eax
8010771c:	6a 00                	push   $0x0
8010771e:	e8 3d fb ff ff       	call   80107260 <argint>
80107723:	83 c4 10             	add    $0x10,%esp
80107726:	85 c0                	test   %eax,%eax
80107728:	78 3e                	js     80107768 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010772a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010772e:	77 38                	ja     80107768 <sys_close+0x58>
80107730:	e8 6b e1 ff ff       	call   801058a0 <myproc>
80107735:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107738:	8d 5a 08             	lea    0x8(%edx),%ebx
8010773b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010773f:	85 f6                	test   %esi,%esi
80107741:	74 25                	je     80107768 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80107743:	e8 58 e1 ff ff       	call   801058a0 <myproc>
  fileclose(f);
80107748:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010774b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80107752:	00 
  fileclose(f);
80107753:	56                   	push   %esi
80107754:	e8 07 b6 ff ff       	call   80102d60 <fileclose>
  return 0;
80107759:	83 c4 10             	add    $0x10,%esp
8010775c:	31 c0                	xor    %eax,%eax
}
8010775e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107761:	5b                   	pop    %ebx
80107762:	5e                   	pop    %esi
80107763:	5d                   	pop    %ebp
80107764:	c3                   	ret
80107765:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107768:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010776d:	eb ef                	jmp    8010775e <sys_close+0x4e>
8010776f:	90                   	nop

80107770 <sys_fstat>:
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	56                   	push   %esi
80107774:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80107775:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80107778:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010777b:	53                   	push   %ebx
8010777c:	6a 00                	push   $0x0
8010777e:	e8 dd fa ff ff       	call   80107260 <argint>
80107783:	83 c4 10             	add    $0x10,%esp
80107786:	85 c0                	test   %eax,%eax
80107788:	78 46                	js     801077d0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010778a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010778e:	77 40                	ja     801077d0 <sys_fstat+0x60>
80107790:	e8 0b e1 ff ff       	call   801058a0 <myproc>
80107795:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107798:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010779c:	85 f6                	test   %esi,%esi
8010779e:	74 30                	je     801077d0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801077a0:	83 ec 04             	sub    $0x4,%esp
801077a3:	6a 14                	push   $0x14
801077a5:	53                   	push   %ebx
801077a6:	6a 01                	push   $0x1
801077a8:	e8 03 fb ff ff       	call   801072b0 <argptr>
801077ad:	83 c4 10             	add    $0x10,%esp
801077b0:	85 c0                	test   %eax,%eax
801077b2:	78 1c                	js     801077d0 <sys_fstat+0x60>
  return filestat(f, st);
801077b4:	83 ec 08             	sub    $0x8,%esp
801077b7:	ff 75 f4             	push   -0xc(%ebp)
801077ba:	56                   	push   %esi
801077bb:	e8 80 b6 ff ff       	call   80102e40 <filestat>
801077c0:	83 c4 10             	add    $0x10,%esp
}
801077c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077c6:	5b                   	pop    %ebx
801077c7:	5e                   	pop    %esi
801077c8:	5d                   	pop    %ebp
801077c9:	c3                   	ret
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801077d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077d5:	eb ec                	jmp    801077c3 <sys_fstat+0x53>
801077d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801077de:	00 
801077df:	90                   	nop

801077e0 <sys_link>:
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801077e5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801077e8:	53                   	push   %ebx
801077e9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801077ec:	50                   	push   %eax
801077ed:	6a 00                	push   $0x0
801077ef:	e8 2c fb ff ff       	call   80107320 <argstr>
801077f4:	83 c4 10             	add    $0x10,%esp
801077f7:	85 c0                	test   %eax,%eax
801077f9:	0f 88 06 01 00 00    	js     80107905 <sys_link+0x125>
801077ff:	83 ec 08             	sub    $0x8,%esp
80107802:	8d 45 d0             	lea    -0x30(%ebp),%eax
80107805:	50                   	push   %eax
80107806:	6a 01                	push   $0x1
80107808:	e8 13 fb ff ff       	call   80107320 <argstr>
8010780d:	83 c4 10             	add    $0x10,%esp
80107810:	85 c0                	test   %eax,%eax
80107812:	0f 88 ed 00 00 00    	js     80107905 <sys_link+0x125>
  begin_op();
80107818:	e8 43 d4 ff ff       	call   80104c60 <begin_op>
  if((ip = namei(old)) == 0){
8010781d:	83 ec 0c             	sub    $0xc,%esp
80107820:	ff 75 d4             	push   -0x2c(%ebp)
80107823:	e8 58 c7 ff ff       	call   80103f80 <namei>
80107828:	83 c4 10             	add    $0x10,%esp
8010782b:	89 c3                	mov    %eax,%ebx
8010782d:	85 c0                	test   %eax,%eax
8010782f:	0f 84 ea 00 00 00    	je     8010791f <sys_link+0x13f>
  ilock(ip);
80107835:	83 ec 0c             	sub    $0xc,%esp
80107838:	50                   	push   %eax
80107839:	e8 d2 bd ff ff       	call   80103610 <ilock>
  if(ip->type == T_DIR){
8010783e:	83 c4 10             	add    $0x10,%esp
80107841:	66 83 bb 90 00 00 00 	cmpw   $0x1,0x90(%ebx)
80107848:	01 
80107849:	0f 84 bd 00 00 00    	je     8010790c <sys_link+0x12c>
  iupdate(ip);
8010784f:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80107852:	66 83 83 96 00 00 00 	addw   $0x1,0x96(%ebx)
80107859:	01 
  if((dp = nameiparent(new, name)) == 0)
8010785a:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010785d:	53                   	push   %ebx
8010785e:	e8 ed bc ff ff       	call   80103550 <iupdate>
  iunlock(ip);
80107863:	89 1c 24             	mov    %ebx,(%esp)
80107866:	e8 95 be ff ff       	call   80103700 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010786b:	58                   	pop    %eax
8010786c:	5a                   	pop    %edx
8010786d:	57                   	push   %edi
8010786e:	ff 75 d0             	push   -0x30(%ebp)
80107871:	e8 2a c7 ff ff       	call   80103fa0 <nameiparent>
80107876:	83 c4 10             	add    $0x10,%esp
80107879:	89 c6                	mov    %eax,%esi
8010787b:	85 c0                	test   %eax,%eax
8010787d:	74 5d                	je     801078dc <sys_link+0xfc>
  ilock(dp);
8010787f:	83 ec 0c             	sub    $0xc,%esp
80107882:	50                   	push   %eax
80107883:	e8 88 bd ff ff       	call   80103610 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107888:	8b 03                	mov    (%ebx),%eax
8010788a:	83 c4 10             	add    $0x10,%esp
8010788d:	39 06                	cmp    %eax,(%esi)
8010788f:	75 3f                	jne    801078d0 <sys_link+0xf0>
80107891:	83 ec 04             	sub    $0x4,%esp
80107894:	ff 73 04             	push   0x4(%ebx)
80107897:	57                   	push   %edi
80107898:	56                   	push   %esi
80107899:	e8 22 c6 ff ff       	call   80103ec0 <dirlink>
8010789e:	83 c4 10             	add    $0x10,%esp
801078a1:	85 c0                	test   %eax,%eax
801078a3:	78 2b                	js     801078d0 <sys_link+0xf0>
  iunlockput(dp);
801078a5:	83 ec 0c             	sub    $0xc,%esp
801078a8:	56                   	push   %esi
801078a9:	e8 22 c0 ff ff       	call   801038d0 <iunlockput>
  iput(ip);
801078ae:	89 1c 24             	mov    %ebx,(%esp)
801078b1:	e8 9a be ff ff       	call   80103750 <iput>
  end_op();
801078b6:	e8 15 d4 ff ff       	call   80104cd0 <end_op>
  return 0;
801078bb:	83 c4 10             	add    $0x10,%esp
801078be:	31 c0                	xor    %eax,%eax
}
801078c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c3:	5b                   	pop    %ebx
801078c4:	5e                   	pop    %esi
801078c5:	5f                   	pop    %edi
801078c6:	5d                   	pop    %ebp
801078c7:	c3                   	ret
801078c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801078cf:	00 
    iunlockput(dp);
801078d0:	83 ec 0c             	sub    $0xc,%esp
801078d3:	56                   	push   %esi
801078d4:	e8 f7 bf ff ff       	call   801038d0 <iunlockput>
    goto bad;
801078d9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801078dc:	83 ec 0c             	sub    $0xc,%esp
801078df:	53                   	push   %ebx
801078e0:	e8 2b bd ff ff       	call   80103610 <ilock>
  ip->nlink--;
801078e5:	66 83 ab 96 00 00 00 	subw   $0x1,0x96(%ebx)
801078ec:	01 
  iupdate(ip);
801078ed:	89 1c 24             	mov    %ebx,(%esp)
801078f0:	e8 5b bc ff ff       	call   80103550 <iupdate>
  iunlockput(ip);
801078f5:	89 1c 24             	mov    %ebx,(%esp)
801078f8:	e8 d3 bf ff ff       	call   801038d0 <iunlockput>
  end_op();
801078fd:	e8 ce d3 ff ff       	call   80104cd0 <end_op>
  return -1;
80107902:	83 c4 10             	add    $0x10,%esp
    return -1;
80107905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010790a:	eb b4                	jmp    801078c0 <sys_link+0xe0>
    iunlockput(ip);
8010790c:	83 ec 0c             	sub    $0xc,%esp
8010790f:	53                   	push   %ebx
80107910:	e8 bb bf ff ff       	call   801038d0 <iunlockput>
    end_op();
80107915:	e8 b6 d3 ff ff       	call   80104cd0 <end_op>
    return -1;
8010791a:	83 c4 10             	add    $0x10,%esp
8010791d:	eb e6                	jmp    80107905 <sys_link+0x125>
    end_op();
8010791f:	e8 ac d3 ff ff       	call   80104cd0 <end_op>
    return -1;
80107924:	eb df                	jmp    80107905 <sys_link+0x125>
80107926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010792d:	00 
8010792e:	66 90                	xchg   %ax,%ax

80107930 <sys_unlink>:
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80107935:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80107938:	53                   	push   %ebx
80107939:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010793c:	50                   	push   %eax
8010793d:	6a 00                	push   $0x0
8010793f:	e8 dc f9 ff ff       	call   80107320 <argstr>
80107944:	83 c4 10             	add    $0x10,%esp
80107947:	85 c0                	test   %eax,%eax
80107949:	0f 88 6c 01 00 00    	js     80107abb <sys_unlink+0x18b>
  begin_op();
8010794f:	e8 0c d3 ff ff       	call   80104c60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80107954:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80107957:	83 ec 08             	sub    $0x8,%esp
8010795a:	53                   	push   %ebx
8010795b:	ff 75 c0             	push   -0x40(%ebp)
8010795e:	e8 3d c6 ff ff       	call   80103fa0 <nameiparent>
80107963:	83 c4 10             	add    $0x10,%esp
80107966:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107969:	85 c0                	test   %eax,%eax
8010796b:	0f 84 73 01 00 00    	je     80107ae4 <sys_unlink+0x1b4>
  ilock(dp);
80107971:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80107974:	83 ec 0c             	sub    $0xc,%esp
80107977:	57                   	push   %edi
80107978:	e8 93 bc ff ff       	call   80103610 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010797d:	58                   	pop    %eax
8010797e:	5a                   	pop    %edx
8010797f:	68 cb a7 10 80       	push   $0x8010a7cb
80107984:	53                   	push   %ebx
80107985:	e8 26 c2 ff ff       	call   80103bb0 <namecmp>
8010798a:	83 c4 10             	add    $0x10,%esp
8010798d:	85 c0                	test   %eax,%eax
8010798f:	0f 84 13 01 00 00    	je     80107aa8 <sys_unlink+0x178>
80107995:	83 ec 08             	sub    $0x8,%esp
80107998:	68 ca a7 10 80       	push   $0x8010a7ca
8010799d:	53                   	push   %ebx
8010799e:	e8 0d c2 ff ff       	call   80103bb0 <namecmp>
801079a3:	83 c4 10             	add    $0x10,%esp
801079a6:	85 c0                	test   %eax,%eax
801079a8:	0f 84 fa 00 00 00    	je     80107aa8 <sys_unlink+0x178>
  if((ip = dirlookup(dp, name, &off)) == 0)
801079ae:	83 ec 04             	sub    $0x4,%esp
801079b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801079b4:	50                   	push   %eax
801079b5:	53                   	push   %ebx
801079b6:	57                   	push   %edi
801079b7:	e8 14 c2 ff ff       	call   80103bd0 <dirlookup>
801079bc:	83 c4 10             	add    $0x10,%esp
801079bf:	89 c3                	mov    %eax,%ebx
801079c1:	85 c0                	test   %eax,%eax
801079c3:	0f 84 df 00 00 00    	je     80107aa8 <sys_unlink+0x178>
  ilock(ip);
801079c9:	83 ec 0c             	sub    $0xc,%esp
801079cc:	50                   	push   %eax
801079cd:	e8 3e bc ff ff       	call   80103610 <ilock>
  if(ip->nlink < 1)
801079d2:	83 c4 10             	add    $0x10,%esp
801079d5:	66 83 bb 96 00 00 00 	cmpw   $0x0,0x96(%ebx)
801079dc:	00 
801079dd:	0f 8e 22 01 00 00    	jle    80107b05 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
801079e3:	66 83 bb 90 00 00 00 	cmpw   $0x1,0x90(%ebx)
801079ea:	01 
801079eb:	8d 7d d8             	lea    -0x28(%ebp),%edi
801079ee:	74 70                	je     80107a60 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
801079f0:	83 ec 04             	sub    $0x4,%esp
801079f3:	6a 10                	push   $0x10
801079f5:	6a 00                	push   $0x0
801079f7:	57                   	push   %edi
801079f8:	e8 b3 f5 ff ff       	call   80106fb0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801079fd:	6a 10                	push   $0x10
801079ff:	ff 75 c4             	push   -0x3c(%ebp)
80107a02:	57                   	push   %edi
80107a03:	ff 75 b4             	push   -0x4c(%ebp)
80107a06:	e8 65 c0 ff ff       	call   80103a70 <writei>
80107a0b:	83 c4 20             	add    $0x20,%esp
80107a0e:	83 f8 10             	cmp    $0x10,%eax
80107a11:	0f 85 e1 00 00 00    	jne    80107af8 <sys_unlink+0x1c8>
  if(ip->type == T_DIR){
80107a17:	66 83 bb 90 00 00 00 	cmpw   $0x1,0x90(%ebx)
80107a1e:	01 
80107a1f:	0f 84 a3 00 00 00    	je     80107ac8 <sys_unlink+0x198>
  iunlockput(dp);
80107a25:	83 ec 0c             	sub    $0xc,%esp
80107a28:	ff 75 b4             	push   -0x4c(%ebp)
80107a2b:	e8 a0 be ff ff       	call   801038d0 <iunlockput>
  ip->nlink--;
80107a30:	66 83 ab 96 00 00 00 	subw   $0x1,0x96(%ebx)
80107a37:	01 
  iupdate(ip);
80107a38:	89 1c 24             	mov    %ebx,(%esp)
80107a3b:	e8 10 bb ff ff       	call   80103550 <iupdate>
  iunlockput(ip);
80107a40:	89 1c 24             	mov    %ebx,(%esp)
80107a43:	e8 88 be ff ff       	call   801038d0 <iunlockput>
  end_op();
80107a48:	e8 83 d2 ff ff       	call   80104cd0 <end_op>
  return 0;
80107a4d:	83 c4 10             	add    $0x10,%esp
80107a50:	31 c0                	xor    %eax,%eax
}
80107a52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a55:	5b                   	pop    %ebx
80107a56:	5e                   	pop    %esi
80107a57:	5f                   	pop    %edi
80107a58:	5d                   	pop    %ebp
80107a59:	c3                   	ret
80107a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107a60:	83 bb 98 00 00 00 20 	cmpl   $0x20,0x98(%ebx)
80107a67:	76 87                	jbe    801079f0 <sys_unlink+0xc0>
80107a69:	be 20 00 00 00       	mov    $0x20,%esi
80107a6e:	eb 0f                	jmp    80107a7f <sys_unlink+0x14f>
80107a70:	83 c6 10             	add    $0x10,%esi
80107a73:	3b b3 98 00 00 00    	cmp    0x98(%ebx),%esi
80107a79:	0f 83 71 ff ff ff    	jae    801079f0 <sys_unlink+0xc0>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107a7f:	6a 10                	push   $0x10
80107a81:	56                   	push   %esi
80107a82:	57                   	push   %edi
80107a83:	53                   	push   %ebx
80107a84:	e8 d7 be ff ff       	call   80103960 <readi>
80107a89:	83 c4 10             	add    $0x10,%esp
80107a8c:	83 f8 10             	cmp    $0x10,%eax
80107a8f:	75 5a                	jne    80107aeb <sys_unlink+0x1bb>
    if(de.inum != 0)
80107a91:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80107a96:	74 d8                	je     80107a70 <sys_unlink+0x140>
    iunlockput(ip);
80107a98:	83 ec 0c             	sub    $0xc,%esp
80107a9b:	53                   	push   %ebx
80107a9c:	e8 2f be ff ff       	call   801038d0 <iunlockput>
    goto bad;
80107aa1:	83 c4 10             	add    $0x10,%esp
80107aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80107aa8:	83 ec 0c             	sub    $0xc,%esp
80107aab:	ff 75 b4             	push   -0x4c(%ebp)
80107aae:	e8 1d be ff ff       	call   801038d0 <iunlockput>
  end_op();
80107ab3:	e8 18 d2 ff ff       	call   80104cd0 <end_op>
  return -1;
80107ab8:	83 c4 10             	add    $0x10,%esp
    return -1;
80107abb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ac0:	eb 90                	jmp    80107a52 <sys_unlink+0x122>
80107ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80107ac8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80107acb:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80107ace:	66 83 a8 96 00 00 00 	subw   $0x1,0x96(%eax)
80107ad5:	01 
    iupdate(dp);
80107ad6:	50                   	push   %eax
80107ad7:	e8 74 ba ff ff       	call   80103550 <iupdate>
80107adc:	83 c4 10             	add    $0x10,%esp
80107adf:	e9 41 ff ff ff       	jmp    80107a25 <sys_unlink+0xf5>
    end_op();
80107ae4:	e8 e7 d1 ff ff       	call   80104cd0 <end_op>
    return -1;
80107ae9:	eb d0                	jmp    80107abb <sys_unlink+0x18b>
      panic("isdirempty: readi");
80107aeb:	83 ec 0c             	sub    $0xc,%esp
80107aee:	68 ef a7 10 80       	push   $0x8010a7ef
80107af3:	e8 08 93 ff ff       	call   80100e00 <panic>
    panic("unlink: writei");
80107af8:	83 ec 0c             	sub    $0xc,%esp
80107afb:	68 01 a8 10 80       	push   $0x8010a801
80107b00:	e8 fb 92 ff ff       	call   80100e00 <panic>
    panic("unlink: nlink < 1");
80107b05:	83 ec 0c             	sub    $0xc,%esp
80107b08:	68 dd a7 10 80       	push   $0x8010a7dd
80107b0d:	e8 ee 92 ff ff       	call   80100e00 <panic>
80107b12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107b19:	00 
80107b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b20 <sys_open>:

int
sys_open(void)
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107b25:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80107b28:	53                   	push   %ebx
80107b29:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107b2c:	50                   	push   %eax
80107b2d:	6a 00                	push   $0x0
80107b2f:	e8 ec f7 ff ff       	call   80107320 <argstr>
80107b34:	83 c4 10             	add    $0x10,%esp
80107b37:	85 c0                	test   %eax,%eax
80107b39:	0f 88 9e 00 00 00    	js     80107bdd <sys_open+0xbd>
80107b3f:	83 ec 08             	sub    $0x8,%esp
80107b42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107b45:	50                   	push   %eax
80107b46:	6a 01                	push   $0x1
80107b48:	e8 13 f7 ff ff       	call   80107260 <argint>
80107b4d:	83 c4 10             	add    $0x10,%esp
80107b50:	85 c0                	test   %eax,%eax
80107b52:	0f 88 85 00 00 00    	js     80107bdd <sys_open+0xbd>
    return -1;

  begin_op();
80107b58:	e8 03 d1 ff ff       	call   80104c60 <begin_op>

  if(omode & O_CREATE){
80107b5d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80107b61:	0f 85 81 00 00 00    	jne    80107be8 <sys_open+0xc8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80107b67:	83 ec 0c             	sub    $0xc,%esp
80107b6a:	ff 75 e0             	push   -0x20(%ebp)
80107b6d:	e8 0e c4 ff ff       	call   80103f80 <namei>
80107b72:	83 c4 10             	add    $0x10,%esp
80107b75:	89 c6                	mov    %eax,%esi
80107b77:	85 c0                	test   %eax,%eax
80107b79:	0f 84 86 00 00 00    	je     80107c05 <sys_open+0xe5>
      end_op();
      return -1;
    }
    ilock(ip);
80107b7f:	83 ec 0c             	sub    $0xc,%esp
80107b82:	50                   	push   %eax
80107b83:	e8 88 ba ff ff       	call   80103610 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80107b88:	83 c4 10             	add    $0x10,%esp
80107b8b:	66 83 be 90 00 00 00 	cmpw   $0x1,0x90(%esi)
80107b92:	01 
80107b93:	0f 84 bf 00 00 00    	je     80107c58 <sys_open+0x138>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107b99:	e8 02 b1 ff ff       	call   80102ca0 <filealloc>
80107b9e:	89 c7                	mov    %eax,%edi
80107ba0:	85 c0                	test   %eax,%eax
80107ba2:	74 28                	je     80107bcc <sys_open+0xac>
  struct proc *curproc = myproc();
80107ba4:	e8 f7 dc ff ff       	call   801058a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80107ba9:	31 db                	xor    %ebx,%ebx
80107bab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107bb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80107bb4:	85 d2                	test   %edx,%edx
80107bb6:	74 58                	je     80107c10 <sys_open+0xf0>
  for(fd = 0; fd < NOFILE; fd++){
80107bb8:	83 c3 01             	add    $0x1,%ebx
80107bbb:	83 fb 10             	cmp    $0x10,%ebx
80107bbe:	75 f0                	jne    80107bb0 <sys_open+0x90>
    if(f)
      fileclose(f);
80107bc0:	83 ec 0c             	sub    $0xc,%esp
80107bc3:	57                   	push   %edi
80107bc4:	e8 97 b1 ff ff       	call   80102d60 <fileclose>
80107bc9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107bcc:	83 ec 0c             	sub    $0xc,%esp
80107bcf:	56                   	push   %esi
80107bd0:	e8 fb bc ff ff       	call   801038d0 <iunlockput>
    end_op();
80107bd5:	e8 f6 d0 ff ff       	call   80104cd0 <end_op>
    return -1;
80107bda:	83 c4 10             	add    $0x10,%esp
    return -1;
80107bdd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107be2:	eb 65                	jmp    80107c49 <sys_open+0x129>
80107be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80107be8:	83 ec 0c             	sub    $0xc,%esp
80107beb:	31 c9                	xor    %ecx,%ecx
80107bed:	ba 02 00 00 00       	mov    $0x2,%edx
80107bf2:	6a 00                	push   $0x0
80107bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bf7:	e8 14 f8 ff ff       	call   80107410 <create>
    if(ip == 0){
80107bfc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80107bff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80107c01:	85 c0                	test   %eax,%eax
80107c03:	75 94                	jne    80107b99 <sys_open+0x79>
      end_op();
80107c05:	e8 c6 d0 ff ff       	call   80104cd0 <end_op>
      return -1;
80107c0a:	eb d1                	jmp    80107bdd <sys_open+0xbd>
80107c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80107c10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80107c13:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80107c17:	56                   	push   %esi
80107c18:	e8 e3 ba ff ff       	call   80103700 <iunlock>
  end_op();
80107c1d:	e8 ae d0 ff ff       	call   80104cd0 <end_op>

  f->type = FD_INODE;
80107c22:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80107c28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107c2b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80107c2e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80107c31:	89 d0                	mov    %edx,%eax
  f->off = 0;
80107c33:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80107c3a:	f7 d0                	not    %eax
80107c3c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107c3f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80107c42:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107c45:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80107c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c4c:	89 d8                	mov    %ebx,%eax
80107c4e:	5b                   	pop    %ebx
80107c4f:	5e                   	pop    %esi
80107c50:	5f                   	pop    %edi
80107c51:	5d                   	pop    %ebp
80107c52:	c3                   	ret
80107c53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80107c58:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107c5b:	85 c9                	test   %ecx,%ecx
80107c5d:	0f 84 36 ff ff ff    	je     80107b99 <sys_open+0x79>
80107c63:	e9 64 ff ff ff       	jmp    80107bcc <sys_open+0xac>
80107c68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c6f:	00 

80107c70 <sys_mkdir>:

int
sys_mkdir(void)
{
80107c70:	55                   	push   %ebp
80107c71:	89 e5                	mov    %esp,%ebp
80107c73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107c76:	e8 e5 cf ff ff       	call   80104c60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107c7b:	83 ec 08             	sub    $0x8,%esp
80107c7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107c81:	50                   	push   %eax
80107c82:	6a 00                	push   $0x0
80107c84:	e8 97 f6 ff ff       	call   80107320 <argstr>
80107c89:	83 c4 10             	add    $0x10,%esp
80107c8c:	85 c0                	test   %eax,%eax
80107c8e:	78 30                	js     80107cc0 <sys_mkdir+0x50>
80107c90:	83 ec 0c             	sub    $0xc,%esp
80107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c96:	31 c9                	xor    %ecx,%ecx
80107c98:	ba 01 00 00 00       	mov    $0x1,%edx
80107c9d:	6a 00                	push   $0x0
80107c9f:	e8 6c f7 ff ff       	call   80107410 <create>
80107ca4:	83 c4 10             	add    $0x10,%esp
80107ca7:	85 c0                	test   %eax,%eax
80107ca9:	74 15                	je     80107cc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80107cab:	83 ec 0c             	sub    $0xc,%esp
80107cae:	50                   	push   %eax
80107caf:	e8 1c bc ff ff       	call   801038d0 <iunlockput>
  end_op();
80107cb4:	e8 17 d0 ff ff       	call   80104cd0 <end_op>
  return 0;
80107cb9:	83 c4 10             	add    $0x10,%esp
80107cbc:	31 c0                	xor    %eax,%eax
}
80107cbe:	c9                   	leave
80107cbf:	c3                   	ret
    end_op();
80107cc0:	e8 0b d0 ff ff       	call   80104cd0 <end_op>
    return -1;
80107cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107cca:	c9                   	leave
80107ccb:	c3                   	ret
80107ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107cd0 <sys_mknod>:

int
sys_mknod(void)
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80107cd6:	e8 85 cf ff ff       	call   80104c60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80107cdb:	83 ec 08             	sub    $0x8,%esp
80107cde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107ce1:	50                   	push   %eax
80107ce2:	6a 00                	push   $0x0
80107ce4:	e8 37 f6 ff ff       	call   80107320 <argstr>
80107ce9:	83 c4 10             	add    $0x10,%esp
80107cec:	85 c0                	test   %eax,%eax
80107cee:	78 60                	js     80107d50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80107cf0:	83 ec 08             	sub    $0x8,%esp
80107cf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107cf6:	50                   	push   %eax
80107cf7:	6a 01                	push   $0x1
80107cf9:	e8 62 f5 ff ff       	call   80107260 <argint>
  if((argstr(0, &path)) < 0 ||
80107cfe:	83 c4 10             	add    $0x10,%esp
80107d01:	85 c0                	test   %eax,%eax
80107d03:	78 4b                	js     80107d50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80107d05:	83 ec 08             	sub    $0x8,%esp
80107d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d0b:	50                   	push   %eax
80107d0c:	6a 02                	push   $0x2
80107d0e:	e8 4d f5 ff ff       	call   80107260 <argint>
     argint(1, &major) < 0 ||
80107d13:	83 c4 10             	add    $0x10,%esp
80107d16:	85 c0                	test   %eax,%eax
80107d18:	78 36                	js     80107d50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80107d1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80107d1e:	83 ec 0c             	sub    $0xc,%esp
80107d21:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80107d25:	ba 03 00 00 00       	mov    $0x3,%edx
80107d2a:	50                   	push   %eax
80107d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d2e:	e8 dd f6 ff ff       	call   80107410 <create>
     argint(2, &minor) < 0 ||
80107d33:	83 c4 10             	add    $0x10,%esp
80107d36:	85 c0                	test   %eax,%eax
80107d38:	74 16                	je     80107d50 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80107d3a:	83 ec 0c             	sub    $0xc,%esp
80107d3d:	50                   	push   %eax
80107d3e:	e8 8d bb ff ff       	call   801038d0 <iunlockput>
  end_op();
80107d43:	e8 88 cf ff ff       	call   80104cd0 <end_op>
  return 0;
80107d48:	83 c4 10             	add    $0x10,%esp
80107d4b:	31 c0                	xor    %eax,%eax
}
80107d4d:	c9                   	leave
80107d4e:	c3                   	ret
80107d4f:	90                   	nop
    end_op();
80107d50:	e8 7b cf ff ff       	call   80104cd0 <end_op>
    return -1;
80107d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d5a:	c9                   	leave
80107d5b:	c3                   	ret
80107d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d60 <sys_chdir>:

int
sys_chdir(void)
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	56                   	push   %esi
80107d64:	53                   	push   %ebx
80107d65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80107d68:	e8 33 db ff ff       	call   801058a0 <myproc>
80107d6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80107d6f:	e8 ec ce ff ff       	call   80104c60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107d74:	83 ec 08             	sub    $0x8,%esp
80107d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d7a:	50                   	push   %eax
80107d7b:	6a 00                	push   $0x0
80107d7d:	e8 9e f5 ff ff       	call   80107320 <argstr>
80107d82:	83 c4 10             	add    $0x10,%esp
80107d85:	85 c0                	test   %eax,%eax
80107d87:	78 77                	js     80107e00 <sys_chdir+0xa0>
80107d89:	83 ec 0c             	sub    $0xc,%esp
80107d8c:	ff 75 f4             	push   -0xc(%ebp)
80107d8f:	e8 ec c1 ff ff       	call   80103f80 <namei>
80107d94:	83 c4 10             	add    $0x10,%esp
80107d97:	89 c3                	mov    %eax,%ebx
80107d99:	85 c0                	test   %eax,%eax
80107d9b:	74 63                	je     80107e00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80107d9d:	83 ec 0c             	sub    $0xc,%esp
80107da0:	50                   	push   %eax
80107da1:	e8 6a b8 ff ff       	call   80103610 <ilock>
  if(ip->type != T_DIR){
80107da6:	83 c4 10             	add    $0x10,%esp
80107da9:	66 83 bb 90 00 00 00 	cmpw   $0x1,0x90(%ebx)
80107db0:	01 
80107db1:	75 2d                	jne    80107de0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80107db3:	83 ec 0c             	sub    $0xc,%esp
80107db6:	53                   	push   %ebx
80107db7:	e8 44 b9 ff ff       	call   80103700 <iunlock>
  iput(curproc->cwd);
80107dbc:	58                   	pop    %eax
80107dbd:	ff 76 68             	push   0x68(%esi)
80107dc0:	e8 8b b9 ff ff       	call   80103750 <iput>
  end_op();
80107dc5:	e8 06 cf ff ff       	call   80104cd0 <end_op>
  curproc->cwd = ip;
80107dca:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80107dcd:	83 c4 10             	add    $0x10,%esp
80107dd0:	31 c0                	xor    %eax,%eax
}
80107dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107dd5:	5b                   	pop    %ebx
80107dd6:	5e                   	pop    %esi
80107dd7:	5d                   	pop    %ebp
80107dd8:	c3                   	ret
80107dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80107de0:	83 ec 0c             	sub    $0xc,%esp
80107de3:	53                   	push   %ebx
80107de4:	e8 e7 ba ff ff       	call   801038d0 <iunlockput>
    end_op();
80107de9:	e8 e2 ce ff ff       	call   80104cd0 <end_op>
    return -1;
80107dee:	83 c4 10             	add    $0x10,%esp
    return -1;
80107df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107df6:	eb da                	jmp    80107dd2 <sys_chdir+0x72>
80107df8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107dff:	00 
    end_op();
80107e00:	e8 cb ce ff ff       	call   80104cd0 <end_op>
    return -1;
80107e05:	eb ea                	jmp    80107df1 <sys_chdir+0x91>
80107e07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107e0e:	00 
80107e0f:	90                   	nop

80107e10 <sys_exec>:

int
sys_exec(void)
{
80107e10:	55                   	push   %ebp
80107e11:	89 e5                	mov    %esp,%ebp
80107e13:	57                   	push   %edi
80107e14:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107e15:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80107e1b:	53                   	push   %ebx
80107e1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107e22:	50                   	push   %eax
80107e23:	6a 00                	push   $0x0
80107e25:	e8 f6 f4 ff ff       	call   80107320 <argstr>
80107e2a:	83 c4 10             	add    $0x10,%esp
80107e2d:	85 c0                	test   %eax,%eax
80107e2f:	0f 88 87 00 00 00    	js     80107ebc <sys_exec+0xac>
80107e35:	83 ec 08             	sub    $0x8,%esp
80107e38:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80107e3e:	50                   	push   %eax
80107e3f:	6a 01                	push   $0x1
80107e41:	e8 1a f4 ff ff       	call   80107260 <argint>
80107e46:	83 c4 10             	add    $0x10,%esp
80107e49:	85 c0                	test   %eax,%eax
80107e4b:	78 6f                	js     80107ebc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80107e4d:	83 ec 04             	sub    $0x4,%esp
80107e50:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80107e56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80107e58:	68 80 00 00 00       	push   $0x80
80107e5d:	6a 00                	push   $0x0
80107e5f:	56                   	push   %esi
80107e60:	e8 4b f1 ff ff       	call   80106fb0 <memset>
80107e65:	83 c4 10             	add    $0x10,%esp
80107e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107e6f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107e70:	83 ec 08             	sub    $0x8,%esp
80107e73:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80107e79:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80107e80:	50                   	push   %eax
80107e81:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80107e87:	01 f8                	add    %edi,%eax
80107e89:	50                   	push   %eax
80107e8a:	e8 41 f3 ff ff       	call   801071d0 <fetchint>
80107e8f:	83 c4 10             	add    $0x10,%esp
80107e92:	85 c0                	test   %eax,%eax
80107e94:	78 26                	js     80107ebc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80107e96:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80107e9c:	85 c0                	test   %eax,%eax
80107e9e:	74 30                	je     80107ed0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107ea0:	83 ec 08             	sub    $0x8,%esp
80107ea3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80107ea6:	52                   	push   %edx
80107ea7:	50                   	push   %eax
80107ea8:	e8 63 f3 ff ff       	call   80107210 <fetchstr>
80107ead:	83 c4 10             	add    $0x10,%esp
80107eb0:	85 c0                	test   %eax,%eax
80107eb2:	78 08                	js     80107ebc <sys_exec+0xac>
  for(i=0;; i++){
80107eb4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80107eb7:	83 fb 20             	cmp    $0x20,%ebx
80107eba:	75 b4                	jne    80107e70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80107ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80107ebf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ec4:	5b                   	pop    %ebx
80107ec5:	5e                   	pop    %esi
80107ec6:	5f                   	pop    %edi
80107ec7:	5d                   	pop    %ebp
80107ec8:	c3                   	ret
80107ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80107ed0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80107ed7:	00 00 00 00 
  return exec(path, argv);
80107edb:	83 ec 08             	sub    $0x8,%esp
80107ede:	56                   	push   %esi
80107edf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80107ee5:	e8 16 aa ff ff       	call   80102900 <exec>
80107eea:	83 c4 10             	add    $0x10,%esp
}
80107eed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ef0:	5b                   	pop    %ebx
80107ef1:	5e                   	pop    %esi
80107ef2:	5f                   	pop    %edi
80107ef3:	5d                   	pop    %ebp
80107ef4:	c3                   	ret
80107ef5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107efc:	00 
80107efd:	8d 76 00             	lea    0x0(%esi),%esi

80107f00 <sys_pipe>:

int
sys_pipe(void)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	57                   	push   %edi
80107f04:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107f05:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80107f08:	53                   	push   %ebx
80107f09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107f0c:	6a 08                	push   $0x8
80107f0e:	50                   	push   %eax
80107f0f:	6a 00                	push   $0x0
80107f11:	e8 9a f3 ff ff       	call   801072b0 <argptr>
80107f16:	83 c4 10             	add    $0x10,%esp
80107f19:	85 c0                	test   %eax,%eax
80107f1b:	0f 88 8b 00 00 00    	js     80107fac <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80107f21:	83 ec 08             	sub    $0x8,%esp
80107f24:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107f27:	50                   	push   %eax
80107f28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107f2b:	50                   	push   %eax
80107f2c:	e8 0f d4 ff ff       	call   80105340 <pipealloc>
80107f31:	83 c4 10             	add    $0x10,%esp
80107f34:	85 c0                	test   %eax,%eax
80107f36:	78 74                	js     80107fac <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107f38:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80107f3b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80107f3d:	e8 5e d9 ff ff       	call   801058a0 <myproc>
    if(curproc->ofile[fd] == 0){
80107f42:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107f46:	85 f6                	test   %esi,%esi
80107f48:	74 16                	je     80107f60 <sys_pipe+0x60>
80107f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80107f50:	83 c3 01             	add    $0x1,%ebx
80107f53:	83 fb 10             	cmp    $0x10,%ebx
80107f56:	74 3d                	je     80107f95 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80107f58:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80107f5c:	85 f6                	test   %esi,%esi
80107f5e:	75 f0                	jne    80107f50 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80107f60:	8d 73 08             	lea    0x8(%ebx),%esi
80107f63:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107f67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80107f6a:	e8 31 d9 ff ff       	call   801058a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80107f6f:	31 d2                	xor    %edx,%edx
80107f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80107f78:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80107f7c:	85 c9                	test   %ecx,%ecx
80107f7e:	74 38                	je     80107fb8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80107f80:	83 c2 01             	add    $0x1,%edx
80107f83:	83 fa 10             	cmp    $0x10,%edx
80107f86:	75 f0                	jne    80107f78 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80107f88:	e8 13 d9 ff ff       	call   801058a0 <myproc>
80107f8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80107f94:	00 
    fileclose(rf);
80107f95:	83 ec 0c             	sub    $0xc,%esp
80107f98:	ff 75 e0             	push   -0x20(%ebp)
80107f9b:	e8 c0 ad ff ff       	call   80102d60 <fileclose>
    fileclose(wf);
80107fa0:	58                   	pop    %eax
80107fa1:	ff 75 e4             	push   -0x1c(%ebp)
80107fa4:	e8 b7 ad ff ff       	call   80102d60 <fileclose>
    return -1;
80107fa9:	83 c4 10             	add    $0x10,%esp
    return -1;
80107fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fb1:	eb 16                	jmp    80107fc9 <sys_pipe+0xc9>
80107fb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80107fb8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80107fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107fbf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80107fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107fc4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80107fc7:	31 c0                	xor    %eax,%eax
}
80107fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fcc:	5b                   	pop    %ebx
80107fcd:	5e                   	pop    %esi
80107fce:	5f                   	pop    %edi
80107fcf:	5d                   	pop    %ebp
80107fd0:	c3                   	ret
80107fd1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107fd8:	00 
80107fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fe0 <sys_make_duplicate_file>:

int
sys_make_duplicate_file(void)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
  char *org;
  char newname[MAXPATH];
  struct inode *orgi, *newi;

  if(argstr(0, &org) < 0)
80107fe5:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
{
80107feb:	53                   	push   %ebx
80107fec:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  if(argstr(0, &org) < 0)
80107ff2:	50                   	push   %eax
80107ff3:	6a 00                	push   $0x0
80107ff5:	e8 26 f3 ff ff       	call   80107320 <argstr>
80107ffa:	83 c4 10             	add    $0x10,%esp
80107ffd:	85 c0                	test   %eax,%eax
80107fff:	0f 88 6d 01 00 00    	js     80108172 <sys_make_duplicate_file+0x192>
    return -1;

  int olen = strlen(org);
80108005:	83 ec 0c             	sub    $0xc,%esp
80108008:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
8010800e:	e8 8d f1 ff ff       	call   801071a0 <strlen>
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80108013:	83 c4 10             	add    $0x10,%esp
  int olen = strlen(org);
80108016:	89 c3                	mov    %eax,%ebx
  if(olen + 6 >= MAXPATH)          /* room for "_copy" */
80108018:	83 f8 79             	cmp    $0x79,%eax
8010801b:	0f 8f 51 01 00 00    	jg     80108172 <sys_make_duplicate_file+0x192>
    return -1;
  safestrcpy(newname, org, MAXPATH);
80108021:	83 ec 04             	sub    $0x4,%esp
80108024:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010802a:	68 80 00 00 00       	push   $0x80
  memmove(newname + olen, "_copy", 6);
8010802f:	01 f3                	add    %esi,%ebx
  safestrcpy(newname, org, MAXPATH);
80108031:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
80108037:	56                   	push   %esi
80108038:	e8 23 f1 ff ff       	call   80107160 <safestrcpy>
  memmove(newname + olen, "_copy", 6);
8010803d:	83 c4 0c             	add    $0xc,%esp
80108040:	6a 06                	push   $0x6
80108042:	68 10 a8 10 80       	push   $0x8010a810
80108047:	53                   	push   %ebx
80108048:	e8 f3 ef ff ff       	call   80107040 <memmove>

  begin_op();
8010804d:	e8 0e cc ff ff       	call   80104c60 <begin_op>

  if(namei(newname) != 0){          // no locks needed for pure existence test
80108052:	89 34 24             	mov    %esi,(%esp)
80108055:	e8 26 bf ff ff       	call   80103f80 <namei>
8010805a:	83 c4 10             	add    $0x10,%esp
8010805d:	85 c0                	test   %eax,%eax
8010805f:	0f 85 60 01 00 00    	jne    801081c5 <sys_make_duplicate_file+0x1e5>
    end_op();
    return -1;
  }

  orgi = namei(org);
80108065:	83 ec 0c             	sub    $0xc,%esp
80108068:	ff b5 64 ff ff ff    	push   -0x9c(%ebp)
8010806e:	e8 0d bf ff ff       	call   80103f80 <namei>
  if(!orgi){
80108073:	83 c4 10             	add    $0x10,%esp
  orgi = namei(org);
80108076:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
8010807c:	89 c3                	mov    %eax,%ebx
  if(!orgi){
8010807e:	85 c0                	test   %eax,%eax
80108080:	0f 84 3f 01 00 00    	je     801081c5 <sys_make_duplicate_file+0x1e5>
    end_op();
    return -1;
  }

  ilock(orgi);
80108086:	83 ec 0c             	sub    $0xc,%esp
80108089:	50                   	push   %eax
8010808a:	e8 81 b5 ff ff       	call   80103610 <ilock>
  if(orgi->type != T_FILE){
8010808f:	83 c4 10             	add    $0x10,%esp
80108092:	66 83 bb 90 00 00 00 	cmpw   $0x2,0x90(%ebx)
80108099:	02 
8010809a:	0f 85 4b 01 00 00    	jne    801081eb <sys_make_duplicate_file+0x20b>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = namei(newname);
801080a0:	83 ec 0c             	sub    $0xc,%esp
801080a3:	56                   	push   %esi
801080a4:	e8 d7 be ff ff       	call   80103f80 <namei>
  if(newi){
801080a9:	83 c4 10             	add    $0x10,%esp
801080ac:	85 c0                	test   %eax,%eax
801080ae:	0f 85 18 01 00 00    	jne    801081cc <sys_make_duplicate_file+0x1ec>
    iunlockput(orgi);
    end_op();
    return -1;
  }

  newi = create(newname, T_FILE, 0, 0);
801080b4:	83 ec 0c             	sub    $0xc,%esp
801080b7:	31 c9                	xor    %ecx,%ecx
801080b9:	ba 02 00 00 00       	mov    $0x2,%edx
801080be:	89 f0                	mov    %esi,%eax
801080c0:	6a 00                	push   $0x0
801080c2:	e8 49 f3 ff ff       	call   80107410 <create>
  if(!newi){
801080c7:	83 c4 10             	add    $0x10,%esp
  newi = create(newname, T_FILE, 0, 0);
801080ca:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  if(!newi){
801080d0:	85 c0                	test   %eax,%eax
801080d2:	0f 84 2e 01 00 00    	je     80108206 <sys_make_duplicate_file+0x226>
    iput(orgi);
    end_op();
    return -1;
  }

  uint total = orgi->size;
801080d8:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
801080de:	8b b0 98 00 00 00    	mov    0x98(%eax),%esi
  char *kbuf = kalloc();
801080e4:	e8 87 c4 ff ff       	call   80104570 <kalloc>
801080e9:	89 c3                	mov    %eax,%ebx
  if(!kbuf){
801080eb:	85 c0                	test   %eax,%eax
801080ed:	0f 84 37 01 00 00    	je     8010822a <sys_make_duplicate_file+0x24a>
    iput(orgi);
    end_op();
    return -1;
  }

  uint done = 0;
801080f3:	31 ff                	xor    %edi,%edi
  while(done < total){
801080f5:	85 f6                	test   %esi,%esi
801080f7:	75 22                	jne    8010811b <sys_make_duplicate_file+0x13b>
801080f9:	e9 82 00 00 00       	jmp    80108180 <sys_make_duplicate_file+0x1a0>
801080fe:	66 90                	xchg   %ax,%ax
    if(chunk > BSIZE) chunk = BSIZE;

    int got = readi(orgi, kbuf, done, chunk);
    if(got < 0) goto err;

    int put = writei(newi, kbuf, done, got);
80108100:	50                   	push   %eax
80108101:	57                   	push   %edi
80108102:	53                   	push   %ebx
80108103:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80108109:	e8 62 b9 ff ff       	call   80103a70 <writei>
    if(put < 0) goto err;
8010810e:	83 c4 10             	add    $0x10,%esp
80108111:	85 c0                	test   %eax,%eax
80108113:	78 29                	js     8010813e <sys_make_duplicate_file+0x15e>

    done += put;
80108115:	01 c7                	add    %eax,%edi
  while(done < total){
80108117:	39 f7                	cmp    %esi,%edi
80108119:	73 65                	jae    80108180 <sys_make_duplicate_file+0x1a0>
    uint chunk = total - done;
8010811b:	89 f0                	mov    %esi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
8010811d:	b9 00 02 00 00       	mov    $0x200,%ecx
    uint chunk = total - done;
80108122:	29 f8                	sub    %edi,%eax
    if(chunk > BSIZE) chunk = BSIZE;
80108124:	39 c8                	cmp    %ecx,%eax
80108126:	0f 47 c1             	cmova  %ecx,%eax
    int got = readi(orgi, kbuf, done, chunk);
80108129:	50                   	push   %eax
8010812a:	57                   	push   %edi
8010812b:	53                   	push   %ebx
8010812c:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
80108132:	e8 29 b8 ff ff       	call   80103960 <readi>
    if(got < 0) goto err;
80108137:	83 c4 10             	add    $0x10,%esp
8010813a:	85 c0                	test   %eax,%eax
8010813c:	79 c2                	jns    80108100 <sys_make_duplicate_file+0x120>
  kfree(kbuf);
  end_op();
  return 0;

err:
  iunlockput(newi);
8010813e:	83 ec 0c             	sub    $0xc,%esp
80108141:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80108147:	e8 84 b7 ff ff       	call   801038d0 <iunlockput>
  iunlock(orgi);
8010814c:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
80108152:	89 34 24             	mov    %esi,(%esp)
80108155:	e8 a6 b5 ff ff       	call   80103700 <iunlock>
  iput(orgi);
8010815a:	89 34 24             	mov    %esi,(%esp)
8010815d:	e8 ee b5 ff ff       	call   80103750 <iput>
  kfree(kbuf);
80108162:	89 1c 24             	mov    %ebx,(%esp)
80108165:	e8 46 c2 ff ff       	call   801043b0 <kfree>
  end_op();
8010816a:	e8 61 cb ff ff       	call   80104cd0 <end_op>
  return -1;
8010816f:	83 c4 10             	add    $0x10,%esp
}
80108172:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80108175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010817a:	5b                   	pop    %ebx
8010817b:	5e                   	pop    %esi
8010817c:	5f                   	pop    %edi
8010817d:	5d                   	pop    %ebp
8010817e:	c3                   	ret
8010817f:	90                   	nop
  newi->size = total;
80108180:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  iupdate(newi);
80108186:	83 ec 0c             	sub    $0xc,%esp
  newi->size = total;
80108189:	89 b0 98 00 00 00    	mov    %esi,0x98(%eax)
  iupdate(newi);
8010818f:	89 c6                	mov    %eax,%esi
80108191:	50                   	push   %eax
80108192:	e8 b9 b3 ff ff       	call   80103550 <iupdate>
  iunlock(newi);
80108197:	89 34 24             	mov    %esi,(%esp)
8010819a:	e8 61 b5 ff ff       	call   80103700 <iunlock>
  iunlock(orgi);
8010819f:	58                   	pop    %eax
801081a0:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801081a6:	e8 55 b5 ff ff       	call   80103700 <iunlock>
  kfree(kbuf);
801081ab:	89 1c 24             	mov    %ebx,(%esp)
801081ae:	e8 fd c1 ff ff       	call   801043b0 <kfree>
  end_op();
801081b3:	e8 18 cb ff ff       	call   80104cd0 <end_op>
  return 0;
801081b8:	83 c4 10             	add    $0x10,%esp
}
801081bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801081be:	31 c0                	xor    %eax,%eax
}
801081c0:	5b                   	pop    %ebx
801081c1:	5e                   	pop    %esi
801081c2:	5f                   	pop    %edi
801081c3:	5d                   	pop    %ebp
801081c4:	c3                   	ret
    end_op();
801081c5:	e8 06 cb ff ff       	call   80104cd0 <end_op>
    return -1;
801081ca:	eb a6                	jmp    80108172 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
801081cc:	83 ec 0c             	sub    $0xc,%esp
801081cf:	50                   	push   %eax
801081d0:	e8 fb b6 ff ff       	call   801038d0 <iunlockput>
    iunlockput(orgi);
801081d5:	5a                   	pop    %edx
801081d6:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801081dc:	e8 ef b6 ff ff       	call   801038d0 <iunlockput>
    end_op();
801081e1:	e8 ea ca ff ff       	call   80104cd0 <end_op>
    return -1;
801081e6:	83 c4 10             	add    $0x10,%esp
801081e9:	eb 87                	jmp    80108172 <sys_make_duplicate_file+0x192>
    iunlockput(orgi);
801081eb:	83 ec 0c             	sub    $0xc,%esp
801081ee:	ff b5 54 ff ff ff    	push   -0xac(%ebp)
801081f4:	e8 d7 b6 ff ff       	call   801038d0 <iunlockput>
    end_op();
801081f9:	e8 d2 ca ff ff       	call   80104cd0 <end_op>
    return -1;
801081fe:	83 c4 10             	add    $0x10,%esp
80108201:	e9 6c ff ff ff       	jmp    80108172 <sys_make_duplicate_file+0x192>
    iunlock(orgi);
80108206:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
8010820c:	83 ec 0c             	sub    $0xc,%esp
8010820f:	56                   	push   %esi
    iunlock(orgi);
80108210:	e8 eb b4 ff ff       	call   80103700 <iunlock>
    iput(orgi);
80108215:	89 34 24             	mov    %esi,(%esp)
80108218:	e8 33 b5 ff ff       	call   80103750 <iput>
    end_op();
8010821d:	e8 ae ca ff ff       	call   80104cd0 <end_op>
    return -1;
80108222:	83 c4 10             	add    $0x10,%esp
80108225:	e9 48 ff ff ff       	jmp    80108172 <sys_make_duplicate_file+0x192>
    iunlockput(newi);
8010822a:	83 ec 0c             	sub    $0xc,%esp
8010822d:	ff b5 50 ff ff ff    	push   -0xb0(%ebp)
80108233:	e8 98 b6 ff ff       	call   801038d0 <iunlockput>
    iunlock(orgi);
80108238:	8b b5 54 ff ff ff    	mov    -0xac(%ebp),%esi
8010823e:	89 34 24             	mov    %esi,(%esp)
80108241:	eb cd                	jmp    80108210 <sys_make_duplicate_file+0x230>
80108243:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010824a:	00 
8010824b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80108250 <sys_grep_syscall>:
    }

    return 0;
}

int sys_grep_syscall(void){
80108250:	55                   	push   %ebp
80108251:	89 e5                	mov    %esp,%ebp
80108253:	57                   	push   %edi
80108254:	56                   	push   %esi
    char *keyword, *filename;
    char *ubuf;
    int bufsz;

    if(argstr(0, &keyword) < 0)
80108255:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_grep_syscall(void){
80108258:	53                   	push   %ebx
80108259:	83 ec 44             	sub    $0x44,%esp
    if(argstr(0, &keyword) < 0)
8010825c:	50                   	push   %eax
8010825d:	6a 00                	push   $0x0
8010825f:	e8 bc f0 ff ff       	call   80107320 <argstr>
80108264:	83 c4 10             	add    $0x10,%esp
80108267:	85 c0                	test   %eax,%eax
80108269:	0f 88 a6 02 00 00    	js     80108515 <sys_grep_syscall+0x2c5>
        return -1;
    if((1, &filename) < 0)
        return -1;
    if(argint(3, &bufsz) < 0 || bufsz <= 1)
8010826f:	83 ec 08             	sub    $0x8,%esp
80108272:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80108275:	50                   	push   %eax
80108276:	6a 03                	push   $0x3
80108278:	e8 e3 ef ff ff       	call   80107260 <argint>
8010827d:	83 c4 10             	add    $0x10,%esp
80108280:	85 c0                	test   %eax,%eax
80108282:	0f 88 8d 02 00 00    	js     80108515 <sys_grep_syscall+0x2c5>
80108288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010828b:	83 f8 01             	cmp    $0x1,%eax
8010828e:	0f 8e 81 02 00 00    	jle    80108515 <sys_grep_syscall+0x2c5>
        return -1;
    if(argptr(2, &ubuf, bufsz) < 0)
80108294:	83 ec 04             	sub    $0x4,%esp
80108297:	50                   	push   %eax
80108298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010829b:	50                   	push   %eax
8010829c:	6a 02                	push   $0x2
8010829e:	e8 0d f0 ff ff       	call   801072b0 <argptr>
801082a3:	83 c4 10             	add    $0x10,%esp
801082a6:	85 c0                	test   %eax,%eax
801082a8:	0f 88 67 02 00 00    	js     80108515 <sys_grep_syscall+0x2c5>
        return -1;

    struct inode *ip = namei(filename);
801082ae:	83 ec 0c             	sub    $0xc,%esp
801082b1:	6a 00                	push   $0x0
801082b3:	e8 c8 bc ff ff       	call   80103f80 <namei>
    if(!ip)
801082b8:	83 c4 10             	add    $0x10,%esp
    struct inode *ip = namei(filename);
801082bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
801082be:	89 c3                	mov    %eax,%ebx
    if(!ip)
801082c0:	85 c0                	test   %eax,%eax
801082c2:	0f 84 4d 02 00 00    	je     80108515 <sys_grep_syscall+0x2c5>
        return -1;

    ilock(ip);
801082c8:	83 ec 0c             	sub    $0xc,%esp
801082cb:	50                   	push   %eax
801082cc:	e8 3f b3 ff ff       	call   80103610 <ilock>
    if(ip->type != T_FILE && ip->type != T_DEV){
801082d1:	0f b7 83 90 00 00 00 	movzwl 0x90(%ebx),%eax
801082d8:	83 c4 10             	add    $0x10,%esp
801082db:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
801082df:	83 e8 02             	sub    $0x2,%eax
801082e2:	66 83 f8 01          	cmp    $0x1,%ax
801082e6:	0f 87 1b 02 00 00    	ja     80108507 <sys_grep_syscall+0x2b7>
        iunlockput(ip);
        return -1;
    }

    char *buf = kalloc();
801082ec:	e8 7f c2 ff ff       	call   80104570 <kalloc>
801082f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(!buf){
801082f4:	85 c0                	test   %eax,%eax
801082f6:	0f 84 0b 02 00 00    	je     80108507 <sys_grep_syscall+0x2b7>
        iunlockput(ip);
        return -1;
    }

    char *line = kalloc();
801082fc:	e8 6f c2 ff ff       	call   80104570 <kalloc>
80108301:	89 c7                	mov    %eax,%edi
    if(!line){
80108303:	85 c0                	test   %eax,%eax
80108305:	0f 84 14 02 00 00    	je     8010851f <sys_grep_syscall+0x2cf>
        return -1;
    }

    int offset = 0;
    int res = -1;
    int line_len = 0;
8010830b:	31 f6                	xor    %esi,%esi
    int offset = 0;
8010830d:	31 db                	xor    %ebx,%ebx

    while(1){
        int n = readi(ip, buf, offset, CHUNK);
8010830f:	68 00 02 00 00       	push   $0x200
80108314:	53                   	push   %ebx
80108315:	ff 75 cc             	push   -0x34(%ebp)
80108318:	ff 75 c8             	push   -0x38(%ebp)
8010831b:	e8 40 b6 ff ff       	call   80103960 <readi>
        if(n < 0)
80108320:	83 c4 10             	add    $0x10,%esp
80108323:	85 c0                	test   %eax,%eax
80108325:	0f 88 b8 00 00 00    	js     801083e3 <sys_grep_syscall+0x193>
            break;

        if(n == 0){
8010832b:	0f 84 6a 01 00 00    	je     8010849b <sys_grep_syscall+0x24b>
            }

            break;
        }

        for(int i = 0; i < n; i++){
80108331:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80108334:	31 d2                	xor    %edx,%edx
80108336:	eb 1f                	jmp    80108357 <sys_grep_syscall+0x107>
80108338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010833f:	00 
                }

                line_len = 0;
            }
            
            else if(line_len < PGSIZE - 1){
80108340:	81 fe fe 0f 00 00    	cmp    $0xffe,%esi
80108346:	0f 8e f9 00 00 00    	jle    80108445 <sys_grep_syscall+0x1f5>
        for(int i = 0; i < n; i++){
8010834c:	83 c2 01             	add    $0x1,%edx
8010834f:	39 d0                	cmp    %edx,%eax
80108351:	0f 8e ff 00 00 00    	jle    80108456 <sys_grep_syscall+0x206>
            char c = buf[i];
80108357:	8b 5d cc             	mov    -0x34(%ebp),%ebx
8010835a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
            if(c == '\n'){
8010835e:	80 f9 0a             	cmp    $0xa,%cl
80108361:	75 dd                	jne    80108340 <sys_grep_syscall+0xf0>
                if(line_has_keyword(line, line_len, keyword)){
80108363:	8b 5d dc             	mov    -0x24(%ebp),%ebx
    if(!key[0])
80108366:	0f b6 0b             	movzbl (%ebx),%ecx
80108369:	88 4d d4             	mov    %cl,-0x2c(%ebp)
8010836c:	84 c9                	test   %cl,%cl
8010836e:	74 44                	je     801083b4 <sys_grep_syscall+0x164>
    for (int i = 0; i < n; i++){
80108370:	85 f6                	test   %esi,%esi
80108372:	0f 8e b8 00 00 00    	jle    80108430 <sys_grep_syscall+0x1e0>
80108378:	89 d9                	mov    %ebx,%ecx
8010837a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010837d:	89 45 c0             	mov    %eax,-0x40(%ebp)
80108380:	29 f1                	sub    %esi,%ecx
80108382:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80108385:	89 d9                	mov    %ebx,%ecx
80108387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010838e:	00 
8010838f:	90                   	nop
80108390:	89 d8                	mov    %ebx,%eax
        while(i+j < n && key[j] && line[i+j] == key[j])
80108392:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
80108396:	29 c8                	sub    %ecx,%eax
80108398:	39 c6                	cmp    %eax,%esi
8010839a:	0f 8e 7c 00 00 00    	jle    8010841c <sys_grep_syscall+0x1cc>
801083a0:	3a 14 07             	cmp    (%edi,%eax,1),%dl
801083a3:	75 77                	jne    8010841c <sys_grep_syscall+0x1cc>
801083a5:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
801083a8:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
801083ac:	39 c6                	cmp    %eax,%esi
801083ae:	74 68                	je     80108418 <sys_grep_syscall+0x1c8>
801083b0:	84 d2                	test   %dl,%dl
801083b2:	75 ec                	jne    801083a0 <sys_grep_syscall+0x150>
                    int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
801083b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
801083ba:	39 f3                	cmp    %esi,%ebx
801083bc:	0f 4f de             	cmovg  %esi,%ebx
                    if(copyout(myproc()->pgdir, (uint)ubuf, line, copylen) >= 0){
801083bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801083c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801083c5:	e8 d6 d4 ff ff       	call   801058a0 <myproc>
801083ca:	53                   	push   %ebx
801083cb:	57                   	push   %edi
801083cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801083cf:	52                   	push   %edx
801083d0:	ff 70 04             	push   0x4(%eax)
801083d3:	e8 68 1e 00 00       	call   8010a240 <copyout>
801083d8:	83 c4 10             	add    $0x10,%esp
801083db:	85 c0                	test   %eax,%eax
801083dd:	0f 89 89 00 00 00    	jns    8010846c <sys_grep_syscall+0x21c>
    int res = -1;
801083e3:	be ff ff ff ff       	mov    $0xffffffff,%esi
        }

        offset += n;
    }

    kfree(buf);
801083e8:	83 ec 0c             	sub    $0xc,%esp
801083eb:	ff 75 cc             	push   -0x34(%ebp)
801083ee:	e8 bd bf ff ff       	call   801043b0 <kfree>
    kfree(line);
801083f3:	89 3c 24             	mov    %edi,(%esp)
801083f6:	e8 b5 bf ff ff       	call   801043b0 <kfree>
    iunlockput(ip);
801083fb:	58                   	pop    %eax
801083fc:	ff 75 c8             	push   -0x38(%ebp)
801083ff:	e8 cc b4 ff ff       	call   801038d0 <iunlockput>

    return res;
80108404:	83 c4 10             	add    $0x10,%esp
80108407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010840a:	89 f0                	mov    %esi,%eax
8010840c:	5b                   	pop    %ebx
8010840d:	5e                   	pop    %esi
8010840e:	5f                   	pop    %edi
8010840f:	5d                   	pop    %ebp
80108410:	c3                   	ret
80108411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(key[j] == 0)
80108418:	84 d2                	test   %dl,%dl
8010841a:	74 98                	je     801083b4 <sys_grep_syscall+0x164>
    for (int i = 0; i < n; i++){
8010841c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010841f:	83 e9 01             	sub    $0x1,%ecx
80108422:	39 c1                	cmp    %eax,%ecx
80108424:	0f 85 66 ff ff ff    	jne    80108390 <sys_grep_syscall+0x140>
8010842a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010842d:	8b 45 c0             	mov    -0x40(%ebp),%eax
        for(int i = 0; i < n; i++){
80108430:	83 c2 01             	add    $0x1,%edx
80108433:	39 d0                	cmp    %edx,%eax
80108435:	7e 58                	jle    8010848f <sys_grep_syscall+0x23f>
            char c = buf[i];
80108437:	8b 75 cc             	mov    -0x34(%ebp),%esi
8010843a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
            if(c == '\n'){
8010843e:	80 f9 0a             	cmp    $0xa,%cl
80108441:	74 1d                	je     80108460 <sys_grep_syscall+0x210>
                line_len = 0;
80108443:	31 f6                	xor    %esi,%esi
        for(int i = 0; i < n; i++){
80108445:	83 c2 01             	add    $0x1,%edx
                line[line_len++] = c;
80108448:	88 0c 37             	mov    %cl,(%edi,%esi,1)
8010844b:	83 c6 01             	add    $0x1,%esi
        for(int i = 0; i < n; i++){
8010844e:	39 d0                	cmp    %edx,%eax
80108450:	0f 8f 01 ff ff ff    	jg     80108357 <sys_grep_syscall+0x107>
80108456:	8b 5d bc             	mov    -0x44(%ebp),%ebx
        offset += n;
80108459:	01 c3                	add    %eax,%ebx
    while(1){
8010845b:	e9 af fe ff ff       	jmp    8010830f <sys_grep_syscall+0xbf>
    if(!key[0])
80108460:	80 3b 00             	cmpb   $0x0,(%ebx)
80108463:	75 cb                	jne    80108430 <sys_grep_syscall+0x1e0>
                line_len = 0;
80108465:	31 f6                	xor    %esi,%esi
80108467:	e9 48 ff ff ff       	jmp    801083b4 <sys_grep_syscall+0x164>
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
8010846c:	03 5d e0             	add    -0x20(%ebp),%ebx
                        char z = 0;
8010846f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
                        copyout(myproc()->pgdir, (uint)(ubuf + copylen), &z, 1);
80108473:	e8 28 d4 ff ff       	call   801058a0 <myproc>
80108478:	8d 55 db             	lea    -0x25(%ebp),%edx
8010847b:	6a 01                	push   $0x1
8010847d:	52                   	push   %edx
8010847e:	53                   	push   %ebx
8010847f:	ff 70 04             	push   0x4(%eax)
80108482:	e8 b9 1d 00 00       	call   8010a240 <copyout>
                        res = line_len;
80108487:	83 c4 10             	add    $0x10,%esp
8010848a:	e9 59 ff ff ff       	jmp    801083e8 <sys_grep_syscall+0x198>
                line_len = 0;
8010848f:	8b 5d bc             	mov    -0x44(%ebp),%ebx
80108492:	31 f6                	xor    %esi,%esi
        offset += n;
80108494:	01 c3                	add    %eax,%ebx
    while(1){
80108496:	e9 74 fe ff ff       	jmp    8010830f <sys_grep_syscall+0xbf>
            if(line_len > 0 && line_has_keyword(line, line_len, keyword)){
8010849b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010849e:	85 f6                	test   %esi,%esi
801084a0:	0f 8e 3d ff ff ff    	jle    801083e3 <sys_grep_syscall+0x193>
801084a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801084a9:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
801084ac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    if(!key[0])
801084af:	0f b6 00             	movzbl (%eax),%eax
801084b2:	88 45 d0             	mov    %al,-0x30(%ebp)
801084b5:	84 c0                	test   %al,%al
801084b7:	74 28                	je     801084e1 <sys_grep_syscall+0x291>
        while(i+j < n && key[j] && line[i+j] == key[j])
801084b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801084bc:	39 c6                	cmp    %eax,%esi
801084be:	7e 37                	jle    801084f7 <sys_grep_syscall+0x2a7>
801084c0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
801084c3:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
801084c7:	01 f8                	add    %edi,%eax
801084c9:	83 c1 01             	add    $0x1,%ecx
801084cc:	38 10                	cmp    %dl,(%eax)
801084ce:	75 27                	jne    801084f7 <sys_grep_syscall+0x2a7>
801084d0:	83 c0 01             	add    $0x1,%eax
        if(key[j] == 0)
801084d3:	0f b6 11             	movzbl (%ecx),%edx
        while(i+j < n && key[j] && line[i+j] == key[j])
801084d6:	83 c1 01             	add    $0x1,%ecx
801084d9:	39 d8                	cmp    %ebx,%eax
801084db:	74 16                	je     801084f3 <sys_grep_syscall+0x2a3>
801084dd:	84 d2                	test   %dl,%dl
801084df:	75 eb                	jne    801084cc <sys_grep_syscall+0x27c>
                int copylen = (line_len < bufsz - 1) ? line_len : (bufsz - 1);
801084e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801084e4:	83 e8 01             	sub    $0x1,%eax
801084e7:	39 f0                	cmp    %esi,%eax
801084e9:	0f 4f c6             	cmovg  %esi,%eax
801084ec:	89 c3                	mov    %eax,%ebx
801084ee:	e9 cc fe ff ff       	jmp    801083bf <sys_grep_syscall+0x16f>
        if(key[j] == 0)
801084f3:	84 d2                	test   %dl,%dl
801084f5:	74 ea                	je     801084e1 <sys_grep_syscall+0x291>
    for (int i = 0; i < n; i++){
801084f7:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
801084fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801084fe:	39 c6                	cmp    %eax,%esi
80108500:	75 b7                	jne    801084b9 <sys_grep_syscall+0x269>
80108502:	e9 dc fe ff ff       	jmp    801083e3 <sys_grep_syscall+0x193>
        iunlockput(ip);
80108507:	83 ec 0c             	sub    $0xc,%esp
8010850a:	ff 75 c8             	push   -0x38(%ebp)
8010850d:	e8 be b3 ff ff       	call   801038d0 <iunlockput>
        return -1;
80108512:	83 c4 10             	add    $0x10,%esp
        return -1;
80108515:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010851a:	e9 e8 fe ff ff       	jmp    80108407 <sys_grep_syscall+0x1b7>
        kfree(buf);
8010851f:	83 ec 0c             	sub    $0xc,%esp
80108522:	ff 75 cc             	push   -0x34(%ebp)
80108525:	e8 86 be ff ff       	call   801043b0 <kfree>
        iunlockput(ip);
8010852a:	5a                   	pop    %edx
8010852b:	ff 75 c8             	push   -0x38(%ebp)
8010852e:	e8 9d b3 ff ff       	call   801038d0 <iunlockput>
        return -1;
80108533:	83 c4 10             	add    $0x10,%esp
80108536:	eb dd                	jmp    80108515 <sys_grep_syscall+0x2c5>
80108538:	66 90                	xchg   %ax,%ax
8010853a:	66 90                	xchg   %ax,%ax
8010853c:	66 90                	xchg   %ax,%ax
8010853e:	66 90                	xchg   %ax,%ax

80108540 <sys_fork>:


int
sys_fork(void)
{
  return fork();
80108540:	e9 fb d4 ff ff       	jmp    80105a40 <fork>
80108545:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010854c:	00 
8010854d:	8d 76 00             	lea    0x0(%esi),%esi

80108550 <sys_exit>:
}

int
sys_exit(void)
{
80108550:	55                   	push   %ebp
80108551:	89 e5                	mov    %esp,%ebp
80108553:	83 ec 08             	sub    $0x8,%esp
  exit();
80108556:	e8 75 d7 ff ff       	call   80105cd0 <exit>
  return 0;  // not reached
}
8010855b:	31 c0                	xor    %eax,%eax
8010855d:	c9                   	leave
8010855e:	c3                   	ret
8010855f:	90                   	nop

80108560 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80108560:	e9 9b d8 ff ff       	jmp    80105e00 <wait>
80108565:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010856c:	00 
8010856d:	8d 76 00             	lea    0x0(%esi),%esi

80108570 <sys_kill>:
}

int
sys_kill(void)
{
80108570:	55                   	push   %ebp
80108571:	89 e5                	mov    %esp,%ebp
80108573:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80108576:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108579:	50                   	push   %eax
8010857a:	6a 00                	push   $0x0
8010857c:	e8 df ec ff ff       	call   80107260 <argint>
80108581:	83 c4 10             	add    $0x10,%esp
80108584:	85 c0                	test   %eax,%eax
80108586:	78 18                	js     801085a0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80108588:	83 ec 0c             	sub    $0xc,%esp
8010858b:	ff 75 f4             	push   -0xc(%ebp)
8010858e:	e8 0d db ff ff       	call   801060a0 <kill>
80108593:	83 c4 10             	add    $0x10,%esp
}
80108596:	c9                   	leave
80108597:	c3                   	ret
80108598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010859f:	00 
801085a0:	c9                   	leave
    return -1;
801085a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801085a6:	c3                   	ret
801085a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801085ae:	00 
801085af:	90                   	nop

801085b0 <sys_getpid>:

int
sys_getpid(void)
{
801085b0:	55                   	push   %ebp
801085b1:	89 e5                	mov    %esp,%ebp
801085b3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801085b6:	e8 e5 d2 ff ff       	call   801058a0 <myproc>
801085bb:	8b 40 10             	mov    0x10(%eax),%eax
}
801085be:	c9                   	leave
801085bf:	c3                   	ret

801085c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801085c0:	55                   	push   %ebp
801085c1:	89 e5                	mov    %esp,%ebp
801085c3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801085c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801085c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801085ca:	50                   	push   %eax
801085cb:	6a 00                	push   $0x0
801085cd:	e8 8e ec ff ff       	call   80107260 <argint>
801085d2:	83 c4 10             	add    $0x10,%esp
801085d5:	85 c0                	test   %eax,%eax
801085d7:	78 27                	js     80108600 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801085d9:	e8 c2 d2 ff ff       	call   801058a0 <myproc>
  if(growproc(n) < 0)
801085de:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801085e1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801085e3:	ff 75 f4             	push   -0xc(%ebp)
801085e6:	e8 d5 d3 ff ff       	call   801059c0 <growproc>
801085eb:	83 c4 10             	add    $0x10,%esp
801085ee:	85 c0                	test   %eax,%eax
801085f0:	78 0e                	js     80108600 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801085f2:	89 d8                	mov    %ebx,%eax
801085f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085f7:	c9                   	leave
801085f8:	c3                   	ret
801085f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80108600:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80108605:	eb eb                	jmp    801085f2 <sys_sbrk+0x32>
80108607:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010860e:	00 
8010860f:	90                   	nop

80108610 <sys_sleep>:

int
sys_sleep(void)
{
80108610:	55                   	push   %ebp
80108611:	89 e5                	mov    %esp,%ebp
80108613:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80108614:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80108617:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010861a:	50                   	push   %eax
8010861b:	6a 00                	push   $0x0
8010861d:	e8 3e ec ff ff       	call   80107260 <argint>
80108622:	83 c4 10             	add    $0x10,%esp
80108625:	85 c0                	test   %eax,%eax
80108627:	78 64                	js     8010868d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80108629:	83 ec 0c             	sub    $0xc,%esp
8010862c:	68 60 89 11 80       	push   $0x80118960
80108631:	e8 da e3 ff ff       	call   80106a10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80108636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80108639:	8b 1d 40 89 11 80    	mov    0x80118940,%ebx
  while(ticks - ticks0 < n){
8010863f:	83 c4 10             	add    $0x10,%esp
80108642:	85 d2                	test   %edx,%edx
80108644:	75 2b                	jne    80108671 <sys_sleep+0x61>
80108646:	eb 58                	jmp    801086a0 <sys_sleep+0x90>
80108648:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010864f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80108650:	83 ec 08             	sub    $0x8,%esp
80108653:	68 60 89 11 80       	push   $0x80118960
80108658:	68 40 89 11 80       	push   $0x80118940
8010865d:	e8 1e d9 ff ff       	call   80105f80 <sleep>
  while(ticks - ticks0 < n){
80108662:	a1 40 89 11 80       	mov    0x80118940,%eax
80108667:	83 c4 10             	add    $0x10,%esp
8010866a:	29 d8                	sub    %ebx,%eax
8010866c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010866f:	73 2f                	jae    801086a0 <sys_sleep+0x90>
    if(myproc()->killed){
80108671:	e8 2a d2 ff ff       	call   801058a0 <myproc>
80108676:	8b 40 24             	mov    0x24(%eax),%eax
80108679:	85 c0                	test   %eax,%eax
8010867b:	74 d3                	je     80108650 <sys_sleep+0x40>
      release(&tickslock);
8010867d:	83 ec 0c             	sub    $0xc,%esp
80108680:	68 60 89 11 80       	push   $0x80118960
80108685:	e8 26 e3 ff ff       	call   801069b0 <release>
      return -1;
8010868a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010868d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80108690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108695:	c9                   	leave
80108696:	c3                   	ret
80108697:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010869e:	00 
8010869f:	90                   	nop
  release(&tickslock);
801086a0:	83 ec 0c             	sub    $0xc,%esp
801086a3:	68 60 89 11 80       	push   $0x80118960
801086a8:	e8 03 e3 ff ff       	call   801069b0 <release>
}
801086ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801086b0:	83 c4 10             	add    $0x10,%esp
801086b3:	31 c0                	xor    %eax,%eax
}
801086b5:	c9                   	leave
801086b6:	c3                   	ret
801086b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801086be:	00 
801086bf:	90                   	nop

801086c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	53                   	push   %ebx
801086c4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801086c7:	68 60 89 11 80       	push   $0x80118960
801086cc:	e8 3f e3 ff ff       	call   80106a10 <acquire>
  xticks = ticks;
801086d1:	8b 1d 40 89 11 80    	mov    0x80118940,%ebx
  release(&tickslock);
801086d7:	c7 04 24 60 89 11 80 	movl   $0x80118960,(%esp)
801086de:	e8 cd e2 ff ff       	call   801069b0 <release>
  return xticks;
}
801086e3:	89 d8                	mov    %ebx,%eax
801086e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801086e8:	c9                   	leave
801086e9:	c3                   	ret
801086ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801086f0 <sys_show_process_family>:

int
sys_show_process_family(void)
{
801086f0:	55                   	push   %ebp
801086f1:	89 e5                	mov    %esp,%ebp
801086f3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if (argint(0, &pid) < 0) 
801086f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801086f9:	50                   	push   %eax
801086fa:	6a 00                	push   $0x0
801086fc:	e8 5f eb ff ff       	call   80107260 <argint>
80108701:	83 c4 10             	add    $0x10,%esp
80108704:	85 c0                	test   %eax,%eax
80108706:	78 18                	js     80108720 <sys_show_process_family+0x30>
    {
      return -1;
    }
  return process_family(pid);
80108708:	83 ec 0c             	sub    $0xc,%esp
8010870b:	ff 75 f4             	push   -0xc(%ebp)
8010870e:	e8 cd da ff ff       	call   801061e0 <process_family>
80108713:	83 c4 10             	add    $0x10,%esp
}
80108716:	c9                   	leave
80108717:	c3                   	ret
80108718:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010871f:	00 
80108720:	c9                   	leave
      return -1;
80108721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108726:	c3                   	ret
80108727:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010872e:	00 
8010872f:	90                   	nop

80108730 <sys_simple_arithmetic>:

int
sys_simple_arithmetic(void)
{
80108730:	55                   	push   %ebp
80108731:	89 e5                	mov    %esp,%ebp
80108733:	53                   	push   %ebx
80108734:	83 ec 04             	sub    $0x4,%esp
  struct proc *p = myproc();
80108737:	e8 64 d1 ff ff       	call   801058a0 <myproc>
  int a = p->tf->ebx; 
8010873c:	8b 40 18             	mov    0x18(%eax),%eax
8010873f:	8b 50 10             	mov    0x10(%eax),%edx
  int b = p->tf->ecx;
80108742:	8b 48 18             	mov    0x18(%eax),%ecx

  int sum = a + b;
  int diff = a - b;
80108745:	89 d0                	mov    %edx,%eax
  int sum = a + b;
80108747:	8d 1c 0a             	lea    (%edx,%ecx,1),%ebx
  int diff = a - b;
8010874a:	29 c8                	sub    %ecx,%eax
  int res = sum * diff;
8010874c:	0f af d8             	imul   %eax,%ebx

  cprintf("simple_arith: a=%d b=%d -> (%d+%d)*(%d-%d) = %d\n",a, b, a, b, a, b, res);
8010874f:	53                   	push   %ebx
80108750:	51                   	push   %ecx
80108751:	52                   	push   %edx
80108752:	51                   	push   %ecx
80108753:	52                   	push   %edx
80108754:	51                   	push   %ecx
80108755:	52                   	push   %edx
80108756:	68 b4 aa 10 80       	push   $0x8010aab4
8010875b:	e8 b0 8e ff ff       	call   80101610 <cprintf>

  return res;
}
80108760:	89 d8                	mov    %ebx,%eax
80108762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108765:	c9                   	leave
80108766:	c3                   	ret
80108767:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010876e:	00 
8010876f:	90                   	nop

80108770 <sys_set_priority_syscall>:

int
sys_set_priority_syscall(void)
{
80108770:	55                   	push   %ebp
80108771:	89 e5                	mov    %esp,%ebp
80108773:	83 ec 20             	sub    $0x20,%esp
  int pid, prio;
  if(argint(0, &pid)  < 0) return -1;
80108776:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108779:	50                   	push   %eax
8010877a:	6a 00                	push   $0x0
8010877c:	e8 df ea ff ff       	call   80107260 <argint>
80108781:	83 c4 10             	add    $0x10,%esp
80108784:	85 c0                	test   %eax,%eax
80108786:	78 28                	js     801087b0 <sys_set_priority_syscall+0x40>
  if(argint(1, &prio) < 0) return -1;
80108788:	83 ec 08             	sub    $0x8,%esp
8010878b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010878e:	50                   	push   %eax
8010878f:	6a 01                	push   $0x1
80108791:	e8 ca ea ff ff       	call   80107260 <argint>
80108796:	83 c4 10             	add    $0x10,%esp
80108799:	85 c0                	test   %eax,%eax
8010879b:	78 13                	js     801087b0 <sys_set_priority_syscall+0x40>
  return set_priority(pid, prio);
8010879d:	83 ec 08             	sub    $0x8,%esp
801087a0:	ff 75 f4             	push   -0xc(%ebp)
801087a3:	ff 75 f0             	push   -0x10(%ebp)
801087a6:	e8 d5 db ff ff       	call   80106380 <set_priority>
801087ab:	83 c4 10             	add    $0x10,%esp
}
801087ae:	c9                   	leave
801087af:	c3                   	ret
801087b0:	c9                   	leave
  if(argint(0, &pid)  < 0) return -1;
801087b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801087b6:	c3                   	ret
801087b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801087be:	00 
801087bf:	90                   	nop

801087c0 <sys_acquire_plock_sys>:

int
sys_acquire_plock_sys(void)
{
801087c0:	55                   	push   %ebp
801087c1:	89 e5                	mov    %esp,%ebp
801087c3:	83 ec 20             	sub    $0x20,%esp
  int pr;
  if(argint(0, &pr) < 0)
801087c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801087c9:	50                   	push   %eax
801087ca:	6a 00                	push   $0x0
801087cc:	e8 8f ea ff ff       	call   80107260 <argint>
801087d1:	83 c4 10             	add    $0x10,%esp
801087d4:	85 c0                	test   %eax,%eax
801087d6:	78 18                	js     801087f0 <sys_acquire_plock_sys+0x30>
    return -1;
  plock_acquire(&plock_global, pr);
801087d8:	83 ec 08             	sub    $0x8,%esp
801087db:	ff 75 f4             	push   -0xc(%ebp)
801087de:	68 00 88 11 80       	push   $0x80118800
801087e3:	e8 d8 de ff ff       	call   801066c0 <plock_acquire>
  return 0;
801087e8:	83 c4 10             	add    $0x10,%esp
801087eb:	31 c0                	xor    %eax,%eax
}
801087ed:	c9                   	leave
801087ee:	c3                   	ret
801087ef:	90                   	nop
801087f0:	c9                   	leave
    return -1;
801087f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801087f6:	c3                   	ret
801087f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801087fe:	00 
801087ff:	90                   	nop

80108800 <sys_release_plock_sys>:

int
sys_release_plock_sys(void)
{
80108800:	55                   	push   %ebp
80108801:	89 e5                	mov    %esp,%ebp
80108803:	83 ec 14             	sub    $0x14,%esp
  release_plock(&plock_global);
80108806:	68 00 88 11 80       	push   $0x80118800
8010880b:	e8 50 df ff ff       	call   80106760 <release_plock>
  return 0;
}
80108810:	31 c0                	xor    %eax,%eax
80108812:	c9                   	leave
80108813:	c3                   	ret
80108814:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010881b:	00 
8010881c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108820 <sys_getlockstat>:

extern struct spinlock tickslock;

int
sys_getlockstat(void)
{
80108820:	55                   	push   %ebp
80108821:	89 e5                	mov    %esp,%ebp
80108823:	56                   	push   %esi
80108824:	53                   	push   %ebx
  uint *score_ptr;
  if(argptr(0, (char**)&score_ptr, NCPU * sizeof(uint)) < 0)
80108825:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80108828:	83 ec 14             	sub    $0x14,%esp
  if(argptr(0, (char**)&score_ptr, NCPU * sizeof(uint)) < 0)
8010882b:	6a 20                	push   $0x20
8010882d:	50                   	push   %eax
8010882e:	6a 00                	push   $0x0
80108830:	e8 7b ea ff ff       	call   801072b0 <argptr>
80108835:	83 c4 10             	add    $0x10,%esp
80108838:	85 c0                	test   %eax,%eax
8010883a:	78 32                	js     8010886e <sys_getlockstat+0x4e>
8010883c:	31 c9                	xor    %ecx,%ecx
8010883e:	66 90                	xchg   %ax,%ax
    return -1;

  for(int i = 0; i < NCPU; i++){
    if(tickslock.count_acq[i] == 0)
      score_ptr[i] = 0;
80108840:	8b 75 f4             	mov    -0xc(%ebp),%esi
    if(tickslock.count_acq[i] == 0)
80108843:	8b 99 94 89 11 80    	mov    -0x7fee766c(%ecx),%ebx
      score_ptr[i] = 0;
80108849:	01 ce                	add    %ecx,%esi
    if(tickslock.count_acq[i] == 0)
8010884b:	85 db                	test   %ebx,%ebx
8010884d:	74 0c                	je     8010885b <sys_getlockstat+0x3b>
    else

      score_ptr[i] = tickslock.spins_total[i] / tickslock.count_acq[i];
8010884f:	8b 81 b4 89 11 80    	mov    -0x7fee764c(%ecx),%eax
80108855:	31 d2                	xor    %edx,%edx
80108857:	f7 f3                	div    %ebx
80108859:	89 c3                	mov    %eax,%ebx
  for(int i = 0; i < NCPU; i++){
8010885b:	83 c1 04             	add    $0x4,%ecx
      score_ptr[i] = 0;
8010885e:	89 1e                	mov    %ebx,(%esi)
  for(int i = 0; i < NCPU; i++){
80108860:	83 f9 20             	cmp    $0x20,%ecx
80108863:	75 db                	jne    80108840 <sys_getlockstat+0x20>
  }
  return 0;
80108865:	31 c0                	xor    %eax,%eax
}
80108867:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010886a:	5b                   	pop    %ebx
8010886b:	5e                   	pop    %esi
8010886c:	5d                   	pop    %ebp
8010886d:	c3                   	ret
    return -1;
8010886e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108873:	eb f2                	jmp    80108867 <sys_getlockstat+0x47>
80108875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010887c:	00 
8010887d:	8d 76 00             	lea    0x0(%esi),%esi

80108880 <sys_vread>:

int
sys_vread(void)
{
80108880:	55                   	push   %ebp
80108881:	89 e5                	mov    %esp,%ebp
80108883:	53                   	push   %ebx
  int addr, value;
  if(argint(0, &addr) < 0)
80108884:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80108887:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &addr) < 0)
8010888a:	50                   	push   %eax
8010888b:	6a 00                	push   $0x0
8010888d:	e8 ce e9 ff ff       	call   80107260 <argint>
80108892:	83 c4 10             	add    $0x10,%esp
80108895:	85 c0                	test   %eax,%eax
80108897:	78 27                	js     801088c0 <sys_vread+0x40>
    return -1;
  if(cpt_read_int(myproc(), (uint)addr, &value) < 0)
80108899:	8b 5d f0             	mov    -0x10(%ebp),%ebx
8010889c:	e8 ff cf ff ff       	call   801058a0 <myproc>
801088a1:	83 ec 04             	sub    $0x4,%esp
801088a4:	8d 55 f4             	lea    -0xc(%ebp),%edx
801088a7:	52                   	push   %edx
801088a8:	53                   	push   %ebx
801088a9:	50                   	push   %eax
801088aa:	e8 91 7f ff ff       	call   80100840 <cpt_read_int>
801088af:	83 c4 10             	add    $0x10,%esp
801088b2:	85 c0                	test   %eax,%eax
801088b4:	78 0a                	js     801088c0 <sys_vread+0x40>
    return -1;
  return value;
801088b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801088b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801088bc:	c9                   	leave
801088bd:	c3                   	ret
801088be:	66 90                	xchg   %ax,%ax
    return -1;
801088c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088c5:	eb f2                	jmp    801088b9 <sys_vread+0x39>
801088c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801088ce:	00 
801088cf:	90                   	nop

801088d0 <sys_vwrite>:

int
sys_vwrite(void)
{
801088d0:	55                   	push   %ebp
801088d1:	89 e5                	mov    %esp,%ebp
801088d3:	56                   	push   %esi
801088d4:	53                   	push   %ebx
  int addr, value;
  if(argint(0, &addr) < 0) return -1;
801088d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
801088d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &addr) < 0) return -1;
801088db:	50                   	push   %eax
801088dc:	6a 00                	push   $0x0
801088de:	e8 7d e9 ff ff       	call   80107260 <argint>
801088e3:	83 c4 10             	add    $0x10,%esp
801088e6:	85 c0                	test   %eax,%eax
801088e8:	78 3e                	js     80108928 <sys_vwrite+0x58>
  if(argint(1, &value) < 0) return -1;
801088ea:	83 ec 08             	sub    $0x8,%esp
801088ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801088f0:	50                   	push   %eax
801088f1:	6a 01                	push   $0x1
801088f3:	e8 68 e9 ff ff       	call   80107260 <argint>
801088f8:	83 c4 10             	add    $0x10,%esp
801088fb:	85 c0                	test   %eax,%eax
801088fd:	78 29                	js     80108928 <sys_vwrite+0x58>
  if(cpt_write_int(myproc(), (uint)addr, value) < 0)
801088ff:	8b 75 f4             	mov    -0xc(%ebp),%esi
80108902:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80108905:	e8 96 cf ff ff       	call   801058a0 <myproc>
8010890a:	83 ec 04             	sub    $0x4,%esp
8010890d:	56                   	push   %esi
8010890e:	53                   	push   %ebx
8010890f:	50                   	push   %eax
80108910:	e8 bb 7f ff ff       	call   801008d0 <cpt_write_int>
80108915:	83 c4 10             	add    $0x10,%esp
80108918:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;
  return 0;
}
8010891b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010891e:	5b                   	pop    %ebx
8010891f:	5e                   	pop    %esi
80108920:	5d                   	pop    %ebp
80108921:	c3                   	ret
80108922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(argint(0, &addr) < 0) return -1;
80108928:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010892d:	eb ec                	jmp    8010891b <sys_vwrite+0x4b>
8010892f:	90                   	nop

80108930 <sys_cptsetpolicy>:

int
sys_cptsetpolicy(void)
{
80108930:	55                   	push   %ebp
80108931:	89 e5                	mov    %esp,%ebp
80108933:	83 ec 20             	sub    $0x20,%esp
  int pol;
  if(argint(0, &pol) < 0)
80108936:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108939:	50                   	push   %eax
8010893a:	6a 00                	push   $0x0
8010893c:	e8 1f e9 ff ff       	call   80107260 <argint>
80108941:	83 c4 10             	add    $0x10,%esp
80108944:	85 c0                	test   %eax,%eax
80108946:	78 18                	js     80108960 <sys_cptsetpolicy+0x30>
    return -1;
  cpt_set_policy(pol);
80108948:	83 ec 0c             	sub    $0xc,%esp
8010894b:	ff 75 f4             	push   -0xc(%ebp)
8010894e:	e8 6d 80 ff ff       	call   801009c0 <cpt_set_policy>
  return 0;
80108953:	83 c4 10             	add    $0x10,%esp
80108956:	31 c0                	xor    %eax,%eax
}
80108958:	c9                   	leave
80108959:	c3                   	ret
8010895a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108960:	c9                   	leave
    return -1;
80108961:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108966:	c3                   	ret
80108967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010896e:	00 
8010896f:	90                   	nop

80108970 <sys_cptresetstats>:

int
sys_cptresetstats(void)
{
80108970:	55                   	push   %ebp
80108971:	89 e5                	mov    %esp,%ebp
80108973:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc();
80108976:	e8 25 cf ff ff       	call   801058a0 <myproc>
  cpt_reset_stats(p->pid);
8010897b:	83 ec 0c             	sub    $0xc,%esp
8010897e:	ff 70 10             	push   0x10(%eax)
80108981:	e8 8a 80 ff ff       	call   80100a10 <cpt_reset_stats>
  return 0;
}
80108986:	31 c0                	xor    %eax,%eax
80108988:	c9                   	leave
80108989:	c3                   	ret
8010898a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108990 <sys_cptgetstats>:

int
sys_cptgetstats(void)
{
80108990:	55                   	push   %ebp
80108991:	89 e5                	mov    %esp,%ebp
80108993:	56                   	push   %esi
80108994:	53                   	push   %ebx
  struct cpt_stats *u;
  if(argptr(0, (void*)&u, sizeof(*u)) < 0)
80108995:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80108998:	83 ec 24             	sub    $0x24,%esp
  if(argptr(0, (void*)&u, sizeof(*u)) < 0)
8010899b:	6a 14                	push   $0x14
8010899d:	50                   	push   %eax
8010899e:	6a 00                	push   $0x0
801089a0:	e8 0b e9 ff ff       	call   801072b0 <argptr>
801089a5:	83 c4 10             	add    $0x10,%esp
801089a8:	85 c0                	test   %eax,%eax
801089aa:	78 34                	js     801089e0 <sys_cptgetstats+0x50>
    return -1;

  struct cpt_stats ks;
  cpt_get_stats(&ks);
801089ac:	83 ec 0c             	sub    $0xc,%esp
801089af:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
801089b2:	53                   	push   %ebx
801089b3:	e8 18 81 ff ff       	call   80100ad0 <cpt_get_stats>
  if(copyout(myproc()->pgdir, (uint)u, (char*)&ks, sizeof(ks)) < 0)
801089b8:	8b 75 e0             	mov    -0x20(%ebp),%esi
801089bb:	e8 e0 ce ff ff       	call   801058a0 <myproc>
801089c0:	6a 14                	push   $0x14
801089c2:	53                   	push   %ebx
801089c3:	56                   	push   %esi
801089c4:	ff 70 04             	push   0x4(%eax)
801089c7:	e8 74 18 00 00       	call   8010a240 <copyout>
801089cc:	83 c4 20             	add    $0x20,%esp
801089cf:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;

  return 0;
801089d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801089d5:	5b                   	pop    %ebx
801089d6:	5e                   	pop    %esi
801089d7:	5d                   	pop    %ebp
801089d8:	c3                   	ret
801089d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801089e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801089e5:	eb eb                	jmp    801089d2 <sys_cptgetstats+0x42>

801089e7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801089e7:	1e                   	push   %ds
  pushl %es
801089e8:	06                   	push   %es
  pushl %fs
801089e9:	0f a0                	push   %fs
  pushl %gs
801089eb:	0f a8                	push   %gs
  pushal
801089ed:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801089ee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801089f2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801089f4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801089f6:	54                   	push   %esp
  call trap
801089f7:	e8 c4 00 00 00       	call   80108ac0 <trap>
  addl $4, %esp
801089fc:	83 c4 04             	add    $0x4,%esp

801089ff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801089ff:	61                   	popa
  popl %gs
80108a00:	0f a9                	pop    %gs
  popl %fs
80108a02:	0f a1                	pop    %fs
  popl %es
80108a04:	07                   	pop    %es
  popl %ds
80108a05:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108a06:	83 c4 08             	add    $0x8,%esp
  iret
80108a09:	cf                   	iret
80108a0a:	66 90                	xchg   %ax,%ax
80108a0c:	66 90                	xchg   %ax,%ax
80108a0e:	66 90                	xchg   %ax,%ax

80108a10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80108a10:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80108a11:	31 c0                	xor    %eax,%eax
{
80108a13:	89 e5                	mov    %esp,%ebp
80108a15:	83 ec 08             	sub    $0x8,%esp
80108a18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108a1f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80108a20:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80108a27:	c7 04 c5 e2 89 11 80 	movl   $0x8e000008,-0x7fee761e(,%eax,8)
80108a2e:	08 00 00 8e 
80108a32:	66 89 14 c5 e0 89 11 	mov    %dx,-0x7fee7620(,%eax,8)
80108a39:	80 
80108a3a:	c1 ea 10             	shr    $0x10,%edx
80108a3d:	66 89 14 c5 e6 89 11 	mov    %dx,-0x7fee761a(,%eax,8)
80108a44:	80 
  for(i = 0; i < 256; i++)
80108a45:	83 c0 01             	add    $0x1,%eax
80108a48:	3d 00 01 00 00       	cmp    $0x100,%eax
80108a4d:	75 d1                	jne    80108a20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80108a4f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80108a52:	a1 08 d1 10 80       	mov    0x8010d108,%eax
80108a57:	c7 05 e2 8b 11 80 08 	movl   $0xef000008,0x80118be2
80108a5e:	00 00 ef 
  initlock(&tickslock, "time");
80108a61:	68 16 a8 10 80       	push   $0x8010a816
80108a66:	68 60 89 11 80       	push   $0x80118960
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80108a6b:	66 a3 e0 8b 11 80    	mov    %ax,0x80118be0
80108a71:	c1 e8 10             	shr    $0x10,%eax
80108a74:	66 a3 e6 8b 11 80    	mov    %ax,0x80118be6
  initlock(&tickslock, "time");
80108a7a:	e8 81 dd ff ff       	call   80106800 <initlock>
}
80108a7f:	83 c4 10             	add    $0x10,%esp
80108a82:	c9                   	leave
80108a83:	c3                   	ret
80108a84:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108a8b:	00 
80108a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108a90 <idtinit>:

void
idtinit(void)
{
80108a90:	55                   	push   %ebp
  pd[0] = size-1;
80108a91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80108a96:	89 e5                	mov    %esp,%ebp
80108a98:	83 ec 10             	sub    $0x10,%esp
80108a9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108a9f:	b8 e0 89 11 80       	mov    $0x801189e0,%eax
80108aa4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108aa8:	c1 e8 10             	shr    $0x10,%eax
80108aab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80108aaf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108ab2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80108ab5:	c9                   	leave
80108ab6:	c3                   	ret
80108ab7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108abe:	00 
80108abf:	90                   	nop

80108ac0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80108ac0:	55                   	push   %ebp
80108ac1:	89 e5                	mov    %esp,%ebp
80108ac3:	57                   	push   %edi
80108ac4:	56                   	push   %esi
80108ac5:	53                   	push   %ebx
80108ac6:	83 ec 1c             	sub    $0x1c,%esp
80108ac9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80108acc:	8b 43 30             	mov    0x30(%ebx),%eax
80108acf:	83 f8 40             	cmp    $0x40,%eax
80108ad2:	0f 84 58 01 00 00    	je     80108c30 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80108ad8:	83 e8 20             	sub    $0x20,%eax
80108adb:	83 f8 1f             	cmp    $0x1f,%eax
80108ade:	0f 87 7c 00 00 00    	ja     80108b60 <trap+0xa0>
80108ae4:	ff 24 85 24 af 10 80 	jmp    *-0x7fef50dc(,%eax,4)
80108aeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108af0:	e8 3b b6 ff ff       	call   80104130 <ideintr>
    lapiceoi();
80108af5:	e8 06 bd ff ff       	call   80104800 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108afa:	e8 a1 cd ff ff       	call   801058a0 <myproc>
80108aff:	85 c0                	test   %eax,%eax
80108b01:	74 1a                	je     80108b1d <trap+0x5d>
80108b03:	e8 98 cd ff ff       	call   801058a0 <myproc>
80108b08:	8b 50 24             	mov    0x24(%eax),%edx
80108b0b:	85 d2                	test   %edx,%edx
80108b0d:	74 0e                	je     80108b1d <trap+0x5d>
80108b0f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80108b13:	f7 d0                	not    %eax
80108b15:	a8 03                	test   $0x3,%al
80108b17:	0f 84 db 01 00 00    	je     80108cf8 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80108b1d:	e8 7e cd ff ff       	call   801058a0 <myproc>
80108b22:	85 c0                	test   %eax,%eax
80108b24:	74 0f                	je     80108b35 <trap+0x75>
80108b26:	e8 75 cd ff ff       	call   801058a0 <myproc>
80108b2b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80108b2f:	0f 84 ab 00 00 00    	je     80108be0 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108b35:	e8 66 cd ff ff       	call   801058a0 <myproc>
80108b3a:	85 c0                	test   %eax,%eax
80108b3c:	74 1a                	je     80108b58 <trap+0x98>
80108b3e:	e8 5d cd ff ff       	call   801058a0 <myproc>
80108b43:	8b 40 24             	mov    0x24(%eax),%eax
80108b46:	85 c0                	test   %eax,%eax
80108b48:	74 0e                	je     80108b58 <trap+0x98>
80108b4a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80108b4e:	f7 d0                	not    %eax
80108b50:	a8 03                	test   $0x3,%al
80108b52:	0f 84 05 01 00 00    	je     80108c5d <trap+0x19d>
    exit();
}
80108b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b5b:	5b                   	pop    %ebx
80108b5c:	5e                   	pop    %esi
80108b5d:	5f                   	pop    %edi
80108b5e:	5d                   	pop    %ebp
80108b5f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80108b60:	e8 3b cd ff ff       	call   801058a0 <myproc>
80108b65:	8b 7b 38             	mov    0x38(%ebx),%edi
80108b68:	85 c0                	test   %eax,%eax
80108b6a:	0f 84 a2 01 00 00    	je     80108d12 <trap+0x252>
80108b70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80108b74:	0f 84 98 01 00 00    	je     80108d12 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108b7a:	0f 20 d1             	mov    %cr2,%ecx
80108b7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108b80:	e8 fb cc ff ff       	call   80105880 <cpuid>
80108b85:	8b 73 30             	mov    0x30(%ebx),%esi
80108b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108b8b:	8b 43 34             	mov    0x34(%ebx),%eax
80108b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80108b91:	e8 0a cd ff ff       	call   801058a0 <myproc>
80108b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b99:	e8 02 cd ff ff       	call   801058a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108b9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80108ba1:	51                   	push   %ecx
80108ba2:	57                   	push   %edi
80108ba3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80108ba6:	52                   	push   %edx
80108ba7:	ff 75 e4             	push   -0x1c(%ebp)
80108baa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80108bab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80108bae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108bb1:	56                   	push   %esi
80108bb2:	ff 70 10             	push   0x10(%eax)
80108bb5:	68 40 ab 10 80       	push   $0x8010ab40
80108bba:	e8 51 8a ff ff       	call   80101610 <cprintf>
    myproc()->killed = 1;
80108bbf:	83 c4 20             	add    $0x20,%esp
80108bc2:	e8 d9 cc ff ff       	call   801058a0 <myproc>
80108bc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108bce:	e8 cd cc ff ff       	call   801058a0 <myproc>
80108bd3:	85 c0                	test   %eax,%eax
80108bd5:	0f 85 28 ff ff ff    	jne    80108b03 <trap+0x43>
80108bdb:	e9 3d ff ff ff       	jmp    80108b1d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80108be0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80108be4:	0f 85 4b ff ff ff    	jne    80108b35 <trap+0x75>
    yield();
80108bea:	e8 41 d3 ff ff       	call   80105f30 <yield>
80108bef:	e9 41 ff ff ff       	jmp    80108b35 <trap+0x75>
80108bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108bf8:	8b 7b 38             	mov    0x38(%ebx),%edi
80108bfb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80108bff:	e8 7c cc ff ff       	call   80105880 <cpuid>
80108c04:	57                   	push   %edi
80108c05:	56                   	push   %esi
80108c06:	50                   	push   %eax
80108c07:	68 e8 aa 10 80       	push   $0x8010aae8
80108c0c:	e8 ff 89 ff ff       	call   80101610 <cprintf>
    lapiceoi();
80108c11:	e8 ea bb ff ff       	call   80104800 <lapiceoi>
    break;
80108c16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108c19:	e8 82 cc ff ff       	call   801058a0 <myproc>
80108c1e:	85 c0                	test   %eax,%eax
80108c20:	0f 85 dd fe ff ff    	jne    80108b03 <trap+0x43>
80108c26:	e9 f2 fe ff ff       	jmp    80108b1d <trap+0x5d>
80108c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80108c30:	e8 6b cc ff ff       	call   801058a0 <myproc>
80108c35:	8b 70 24             	mov    0x24(%eax),%esi
80108c38:	85 f6                	test   %esi,%esi
80108c3a:	0f 85 c8 00 00 00    	jne    80108d08 <trap+0x248>
    myproc()->tf = tf;
80108c40:	e8 5b cc ff ff       	call   801058a0 <myproc>
80108c45:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80108c48:	e8 53 e7 ff ff       	call   801073a0 <syscall>
    if(myproc()->killed)
80108c4d:	e8 4e cc ff ff       	call   801058a0 <myproc>
80108c52:	8b 48 24             	mov    0x24(%eax),%ecx
80108c55:	85 c9                	test   %ecx,%ecx
80108c57:	0f 84 fb fe ff ff    	je     80108b58 <trap+0x98>
}
80108c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c60:	5b                   	pop    %ebx
80108c61:	5e                   	pop    %esi
80108c62:	5f                   	pop    %edi
80108c63:	5d                   	pop    %ebp
      exit();
80108c64:	e9 67 d0 ff ff       	jmp    80105cd0 <exit>
80108c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80108c70:	e8 4b 02 00 00       	call   80108ec0 <uartintr>
    lapiceoi();
80108c75:	e8 86 bb ff ff       	call   80104800 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108c7a:	e8 21 cc ff ff       	call   801058a0 <myproc>
80108c7f:	85 c0                	test   %eax,%eax
80108c81:	0f 85 7c fe ff ff    	jne    80108b03 <trap+0x43>
80108c87:	e9 91 fe ff ff       	jmp    80108b1d <trap+0x5d>
80108c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80108c90:	e8 3b ba ff ff       	call   801046d0 <kbdintr>
    lapiceoi();
80108c95:	e8 66 bb ff ff       	call   80104800 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80108c9a:	e8 01 cc ff ff       	call   801058a0 <myproc>
80108c9f:	85 c0                	test   %eax,%eax
80108ca1:	0f 85 5c fe ff ff    	jne    80108b03 <trap+0x43>
80108ca7:	e9 71 fe ff ff       	jmp    80108b1d <trap+0x5d>
80108cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80108cb0:	e8 cb cb ff ff       	call   80105880 <cpuid>
80108cb5:	85 c0                	test   %eax,%eax
80108cb7:	0f 85 38 fe ff ff    	jne    80108af5 <trap+0x35>
      acquire(&tickslock);
80108cbd:	83 ec 0c             	sub    $0xc,%esp
80108cc0:	68 60 89 11 80       	push   $0x80118960
80108cc5:	e8 46 dd ff ff       	call   80106a10 <acquire>
      ticks++;
80108cca:	83 05 40 89 11 80 01 	addl   $0x1,0x80118940
      wakeup(&ticks);
80108cd1:	c7 04 24 40 89 11 80 	movl   $0x80118940,(%esp)
80108cd8:	e8 63 d3 ff ff       	call   80106040 <wakeup>
      release(&tickslock);
80108cdd:	c7 04 24 60 89 11 80 	movl   $0x80118960,(%esp)
80108ce4:	e8 c7 dc ff ff       	call   801069b0 <release>
80108ce9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80108cec:	e9 04 fe ff ff       	jmp    80108af5 <trap+0x35>
80108cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80108cf8:	e8 d3 cf ff ff       	call   80105cd0 <exit>
80108cfd:	e9 1b fe ff ff       	jmp    80108b1d <trap+0x5d>
80108d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80108d08:	e8 c3 cf ff ff       	call   80105cd0 <exit>
80108d0d:	e9 2e ff ff ff       	jmp    80108c40 <trap+0x180>
80108d12:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108d15:	e8 66 cb ff ff       	call   80105880 <cpuid>
80108d1a:	83 ec 0c             	sub    $0xc,%esp
80108d1d:	56                   	push   %esi
80108d1e:	57                   	push   %edi
80108d1f:	50                   	push   %eax
80108d20:	ff 73 30             	push   0x30(%ebx)
80108d23:	68 0c ab 10 80       	push   $0x8010ab0c
80108d28:	e8 e3 88 ff ff       	call   80101610 <cprintf>
      panic("trap");
80108d2d:	83 c4 14             	add    $0x14,%esp
80108d30:	68 1b a8 10 80       	push   $0x8010a81b
80108d35:	e8 c6 80 ff ff       	call   80100e00 <panic>
80108d3a:	66 90                	xchg   %ax,%ax
80108d3c:	66 90                	xchg   %ax,%ax
80108d3e:	66 90                	xchg   %ax,%ax

80108d40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80108d40:	a1 e0 91 11 80       	mov    0x801191e0,%eax
80108d45:	85 c0                	test   %eax,%eax
80108d47:	74 17                	je     80108d60 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108d49:	ba fd 03 00 00       	mov    $0x3fd,%edx
80108d4e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80108d4f:	a8 01                	test   $0x1,%al
80108d51:	74 0d                	je     80108d60 <uartgetc+0x20>
80108d53:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108d58:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80108d59:	0f b6 c0             	movzbl %al,%eax
80108d5c:	c3                   	ret
80108d5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80108d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108d65:	c3                   	ret
80108d66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108d6d:	00 
80108d6e:	66 90                	xchg   %ax,%ax

80108d70 <uartinit>:
{
80108d70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108d71:	31 c9                	xor    %ecx,%ecx
80108d73:	89 c8                	mov    %ecx,%eax
80108d75:	89 e5                	mov    %esp,%ebp
80108d77:	57                   	push   %edi
80108d78:	bf fa 03 00 00       	mov    $0x3fa,%edi
80108d7d:	56                   	push   %esi
80108d7e:	89 fa                	mov    %edi,%edx
80108d80:	53                   	push   %ebx
80108d81:	83 ec 1c             	sub    $0x1c,%esp
80108d84:	ee                   	out    %al,(%dx)
80108d85:	be fb 03 00 00       	mov    $0x3fb,%esi
80108d8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80108d8f:	89 f2                	mov    %esi,%edx
80108d91:	ee                   	out    %al,(%dx)
80108d92:	b8 0c 00 00 00       	mov    $0xc,%eax
80108d97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108d9c:	ee                   	out    %al,(%dx)
80108d9d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80108da2:	89 c8                	mov    %ecx,%eax
80108da4:	89 da                	mov    %ebx,%edx
80108da6:	ee                   	out    %al,(%dx)
80108da7:	b8 03 00 00 00       	mov    $0x3,%eax
80108dac:	89 f2                	mov    %esi,%edx
80108dae:	ee                   	out    %al,(%dx)
80108daf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80108db4:	89 c8                	mov    %ecx,%eax
80108db6:	ee                   	out    %al,(%dx)
80108db7:	b8 01 00 00 00       	mov    $0x1,%eax
80108dbc:	89 da                	mov    %ebx,%edx
80108dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108dbf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80108dc4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80108dc5:	3c ff                	cmp    $0xff,%al
80108dc7:	0f 84 7c 00 00 00    	je     80108e49 <uartinit+0xd9>
  uart = 1;
80108dcd:	c7 05 e0 91 11 80 01 	movl   $0x1,0x801191e0
80108dd4:	00 00 00 
80108dd7:	89 fa                	mov    %edi,%edx
80108dd9:	ec                   	in     (%dx),%al
80108dda:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108ddf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80108de0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80108de3:	bf 20 a8 10 80       	mov    $0x8010a820,%edi
80108de8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80108ded:	6a 00                	push   $0x0
80108def:	6a 04                	push   $0x4
80108df1:	e8 7a b5 ff ff       	call   80104370 <ioapicenable>
80108df6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80108df9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80108dfd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80108e00:	a1 e0 91 11 80       	mov    0x801191e0,%eax
80108e05:	85 c0                	test   %eax,%eax
80108e07:	74 32                	je     80108e3b <uartinit+0xcb>
80108e09:	89 f2                	mov    %esi,%edx
80108e0b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108e0c:	a8 20                	test   $0x20,%al
80108e0e:	75 21                	jne    80108e31 <uartinit+0xc1>
80108e10:	bb 80 00 00 00       	mov    $0x80,%ebx
80108e15:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80108e18:	83 ec 0c             	sub    $0xc,%esp
80108e1b:	6a 0a                	push   $0xa
80108e1d:	e8 fe b9 ff ff       	call   80104820 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108e22:	83 c4 10             	add    $0x10,%esp
80108e25:	83 eb 01             	sub    $0x1,%ebx
80108e28:	74 07                	je     80108e31 <uartinit+0xc1>
80108e2a:	89 f2                	mov    %esi,%edx
80108e2c:	ec                   	in     (%dx),%al
80108e2d:	a8 20                	test   $0x20,%al
80108e2f:	74 e7                	je     80108e18 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108e31:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108e36:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80108e3a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80108e3b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80108e3f:	83 c7 01             	add    $0x1,%edi
80108e42:	88 45 e7             	mov    %al,-0x19(%ebp)
80108e45:	84 c0                	test   %al,%al
80108e47:	75 b7                	jne    80108e00 <uartinit+0x90>
}
80108e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e4c:	5b                   	pop    %ebx
80108e4d:	5e                   	pop    %esi
80108e4e:	5f                   	pop    %edi
80108e4f:	5d                   	pop    %ebp
80108e50:	c3                   	ret
80108e51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80108e58:	00 
80108e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108e60 <uartputc>:
  if(!uart)
80108e60:	a1 e0 91 11 80       	mov    0x801191e0,%eax
80108e65:	85 c0                	test   %eax,%eax
80108e67:	74 4f                	je     80108eb8 <uartputc+0x58>
{
80108e69:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108e6a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80108e6f:	89 e5                	mov    %esp,%ebp
80108e71:	56                   	push   %esi
80108e72:	53                   	push   %ebx
80108e73:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108e74:	a8 20                	test   $0x20,%al
80108e76:	75 29                	jne    80108ea1 <uartputc+0x41>
80108e78:	bb 80 00 00 00       	mov    $0x80,%ebx
80108e7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80108e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80108e88:	83 ec 0c             	sub    $0xc,%esp
80108e8b:	6a 0a                	push   $0xa
80108e8d:	e8 8e b9 ff ff       	call   80104820 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108e92:	83 c4 10             	add    $0x10,%esp
80108e95:	83 eb 01             	sub    $0x1,%ebx
80108e98:	74 07                	je     80108ea1 <uartputc+0x41>
80108e9a:	89 f2                	mov    %esi,%edx
80108e9c:	ec                   	in     (%dx),%al
80108e9d:	a8 20                	test   $0x20,%al
80108e9f:	74 e7                	je     80108e88 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80108ea4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80108ea9:	ee                   	out    %al,(%dx)
}
80108eaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108ead:	5b                   	pop    %ebx
80108eae:	5e                   	pop    %esi
80108eaf:	5d                   	pop    %ebp
80108eb0:	c3                   	ret
80108eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108eb8:	c3                   	ret
80108eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108ec0 <uartintr>:

void
uartintr(void)
{
80108ec0:	55                   	push   %ebp
80108ec1:	89 e5                	mov    %esp,%ebp
80108ec3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80108ec6:	68 40 8d 10 80       	push   $0x80108d40
80108ecb:	e8 50 89 ff ff       	call   80101820 <consoleintr>
}
80108ed0:	83 c4 10             	add    $0x10,%esp
80108ed3:	c9                   	leave
80108ed4:	c3                   	ret

80108ed5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108ed5:	6a 00                	push   $0x0
  pushl $0
80108ed7:	6a 00                	push   $0x0
  jmp alltraps
80108ed9:	e9 09 fb ff ff       	jmp    801089e7 <alltraps>

80108ede <vector1>:
.globl vector1
vector1:
  pushl $0
80108ede:	6a 00                	push   $0x0
  pushl $1
80108ee0:	6a 01                	push   $0x1
  jmp alltraps
80108ee2:	e9 00 fb ff ff       	jmp    801089e7 <alltraps>

80108ee7 <vector2>:
.globl vector2
vector2:
  pushl $0
80108ee7:	6a 00                	push   $0x0
  pushl $2
80108ee9:	6a 02                	push   $0x2
  jmp alltraps
80108eeb:	e9 f7 fa ff ff       	jmp    801089e7 <alltraps>

80108ef0 <vector3>:
.globl vector3
vector3:
  pushl $0
80108ef0:	6a 00                	push   $0x0
  pushl $3
80108ef2:	6a 03                	push   $0x3
  jmp alltraps
80108ef4:	e9 ee fa ff ff       	jmp    801089e7 <alltraps>

80108ef9 <vector4>:
.globl vector4
vector4:
  pushl $0
80108ef9:	6a 00                	push   $0x0
  pushl $4
80108efb:	6a 04                	push   $0x4
  jmp alltraps
80108efd:	e9 e5 fa ff ff       	jmp    801089e7 <alltraps>

80108f02 <vector5>:
.globl vector5
vector5:
  pushl $0
80108f02:	6a 00                	push   $0x0
  pushl $5
80108f04:	6a 05                	push   $0x5
  jmp alltraps
80108f06:	e9 dc fa ff ff       	jmp    801089e7 <alltraps>

80108f0b <vector6>:
.globl vector6
vector6:
  pushl $0
80108f0b:	6a 00                	push   $0x0
  pushl $6
80108f0d:	6a 06                	push   $0x6
  jmp alltraps
80108f0f:	e9 d3 fa ff ff       	jmp    801089e7 <alltraps>

80108f14 <vector7>:
.globl vector7
vector7:
  pushl $0
80108f14:	6a 00                	push   $0x0
  pushl $7
80108f16:	6a 07                	push   $0x7
  jmp alltraps
80108f18:	e9 ca fa ff ff       	jmp    801089e7 <alltraps>

80108f1d <vector8>:
.globl vector8
vector8:
  pushl $8
80108f1d:	6a 08                	push   $0x8
  jmp alltraps
80108f1f:	e9 c3 fa ff ff       	jmp    801089e7 <alltraps>

80108f24 <vector9>:
.globl vector9
vector9:
  pushl $0
80108f24:	6a 00                	push   $0x0
  pushl $9
80108f26:	6a 09                	push   $0x9
  jmp alltraps
80108f28:	e9 ba fa ff ff       	jmp    801089e7 <alltraps>

80108f2d <vector10>:
.globl vector10
vector10:
  pushl $10
80108f2d:	6a 0a                	push   $0xa
  jmp alltraps
80108f2f:	e9 b3 fa ff ff       	jmp    801089e7 <alltraps>

80108f34 <vector11>:
.globl vector11
vector11:
  pushl $11
80108f34:	6a 0b                	push   $0xb
  jmp alltraps
80108f36:	e9 ac fa ff ff       	jmp    801089e7 <alltraps>

80108f3b <vector12>:
.globl vector12
vector12:
  pushl $12
80108f3b:	6a 0c                	push   $0xc
  jmp alltraps
80108f3d:	e9 a5 fa ff ff       	jmp    801089e7 <alltraps>

80108f42 <vector13>:
.globl vector13
vector13:
  pushl $13
80108f42:	6a 0d                	push   $0xd
  jmp alltraps
80108f44:	e9 9e fa ff ff       	jmp    801089e7 <alltraps>

80108f49 <vector14>:
.globl vector14
vector14:
  pushl $14
80108f49:	6a 0e                	push   $0xe
  jmp alltraps
80108f4b:	e9 97 fa ff ff       	jmp    801089e7 <alltraps>

80108f50 <vector15>:
.globl vector15
vector15:
  pushl $0
80108f50:	6a 00                	push   $0x0
  pushl $15
80108f52:	6a 0f                	push   $0xf
  jmp alltraps
80108f54:	e9 8e fa ff ff       	jmp    801089e7 <alltraps>

80108f59 <vector16>:
.globl vector16
vector16:
  pushl $0
80108f59:	6a 00                	push   $0x0
  pushl $16
80108f5b:	6a 10                	push   $0x10
  jmp alltraps
80108f5d:	e9 85 fa ff ff       	jmp    801089e7 <alltraps>

80108f62 <vector17>:
.globl vector17
vector17:
  pushl $17
80108f62:	6a 11                	push   $0x11
  jmp alltraps
80108f64:	e9 7e fa ff ff       	jmp    801089e7 <alltraps>

80108f69 <vector18>:
.globl vector18
vector18:
  pushl $0
80108f69:	6a 00                	push   $0x0
  pushl $18
80108f6b:	6a 12                	push   $0x12
  jmp alltraps
80108f6d:	e9 75 fa ff ff       	jmp    801089e7 <alltraps>

80108f72 <vector19>:
.globl vector19
vector19:
  pushl $0
80108f72:	6a 00                	push   $0x0
  pushl $19
80108f74:	6a 13                	push   $0x13
  jmp alltraps
80108f76:	e9 6c fa ff ff       	jmp    801089e7 <alltraps>

80108f7b <vector20>:
.globl vector20
vector20:
  pushl $0
80108f7b:	6a 00                	push   $0x0
  pushl $20
80108f7d:	6a 14                	push   $0x14
  jmp alltraps
80108f7f:	e9 63 fa ff ff       	jmp    801089e7 <alltraps>

80108f84 <vector21>:
.globl vector21
vector21:
  pushl $0
80108f84:	6a 00                	push   $0x0
  pushl $21
80108f86:	6a 15                	push   $0x15
  jmp alltraps
80108f88:	e9 5a fa ff ff       	jmp    801089e7 <alltraps>

80108f8d <vector22>:
.globl vector22
vector22:
  pushl $0
80108f8d:	6a 00                	push   $0x0
  pushl $22
80108f8f:	6a 16                	push   $0x16
  jmp alltraps
80108f91:	e9 51 fa ff ff       	jmp    801089e7 <alltraps>

80108f96 <vector23>:
.globl vector23
vector23:
  pushl $0
80108f96:	6a 00                	push   $0x0
  pushl $23
80108f98:	6a 17                	push   $0x17
  jmp alltraps
80108f9a:	e9 48 fa ff ff       	jmp    801089e7 <alltraps>

80108f9f <vector24>:
.globl vector24
vector24:
  pushl $0
80108f9f:	6a 00                	push   $0x0
  pushl $24
80108fa1:	6a 18                	push   $0x18
  jmp alltraps
80108fa3:	e9 3f fa ff ff       	jmp    801089e7 <alltraps>

80108fa8 <vector25>:
.globl vector25
vector25:
  pushl $0
80108fa8:	6a 00                	push   $0x0
  pushl $25
80108faa:	6a 19                	push   $0x19
  jmp alltraps
80108fac:	e9 36 fa ff ff       	jmp    801089e7 <alltraps>

80108fb1 <vector26>:
.globl vector26
vector26:
  pushl $0
80108fb1:	6a 00                	push   $0x0
  pushl $26
80108fb3:	6a 1a                	push   $0x1a
  jmp alltraps
80108fb5:	e9 2d fa ff ff       	jmp    801089e7 <alltraps>

80108fba <vector27>:
.globl vector27
vector27:
  pushl $0
80108fba:	6a 00                	push   $0x0
  pushl $27
80108fbc:	6a 1b                	push   $0x1b
  jmp alltraps
80108fbe:	e9 24 fa ff ff       	jmp    801089e7 <alltraps>

80108fc3 <vector28>:
.globl vector28
vector28:
  pushl $0
80108fc3:	6a 00                	push   $0x0
  pushl $28
80108fc5:	6a 1c                	push   $0x1c
  jmp alltraps
80108fc7:	e9 1b fa ff ff       	jmp    801089e7 <alltraps>

80108fcc <vector29>:
.globl vector29
vector29:
  pushl $0
80108fcc:	6a 00                	push   $0x0
  pushl $29
80108fce:	6a 1d                	push   $0x1d
  jmp alltraps
80108fd0:	e9 12 fa ff ff       	jmp    801089e7 <alltraps>

80108fd5 <vector30>:
.globl vector30
vector30:
  pushl $0
80108fd5:	6a 00                	push   $0x0
  pushl $30
80108fd7:	6a 1e                	push   $0x1e
  jmp alltraps
80108fd9:	e9 09 fa ff ff       	jmp    801089e7 <alltraps>

80108fde <vector31>:
.globl vector31
vector31:
  pushl $0
80108fde:	6a 00                	push   $0x0
  pushl $31
80108fe0:	6a 1f                	push   $0x1f
  jmp alltraps
80108fe2:	e9 00 fa ff ff       	jmp    801089e7 <alltraps>

80108fe7 <vector32>:
.globl vector32
vector32:
  pushl $0
80108fe7:	6a 00                	push   $0x0
  pushl $32
80108fe9:	6a 20                	push   $0x20
  jmp alltraps
80108feb:	e9 f7 f9 ff ff       	jmp    801089e7 <alltraps>

80108ff0 <vector33>:
.globl vector33
vector33:
  pushl $0
80108ff0:	6a 00                	push   $0x0
  pushl $33
80108ff2:	6a 21                	push   $0x21
  jmp alltraps
80108ff4:	e9 ee f9 ff ff       	jmp    801089e7 <alltraps>

80108ff9 <vector34>:
.globl vector34
vector34:
  pushl $0
80108ff9:	6a 00                	push   $0x0
  pushl $34
80108ffb:	6a 22                	push   $0x22
  jmp alltraps
80108ffd:	e9 e5 f9 ff ff       	jmp    801089e7 <alltraps>

80109002 <vector35>:
.globl vector35
vector35:
  pushl $0
80109002:	6a 00                	push   $0x0
  pushl $35
80109004:	6a 23                	push   $0x23
  jmp alltraps
80109006:	e9 dc f9 ff ff       	jmp    801089e7 <alltraps>

8010900b <vector36>:
.globl vector36
vector36:
  pushl $0
8010900b:	6a 00                	push   $0x0
  pushl $36
8010900d:	6a 24                	push   $0x24
  jmp alltraps
8010900f:	e9 d3 f9 ff ff       	jmp    801089e7 <alltraps>

80109014 <vector37>:
.globl vector37
vector37:
  pushl $0
80109014:	6a 00                	push   $0x0
  pushl $37
80109016:	6a 25                	push   $0x25
  jmp alltraps
80109018:	e9 ca f9 ff ff       	jmp    801089e7 <alltraps>

8010901d <vector38>:
.globl vector38
vector38:
  pushl $0
8010901d:	6a 00                	push   $0x0
  pushl $38
8010901f:	6a 26                	push   $0x26
  jmp alltraps
80109021:	e9 c1 f9 ff ff       	jmp    801089e7 <alltraps>

80109026 <vector39>:
.globl vector39
vector39:
  pushl $0
80109026:	6a 00                	push   $0x0
  pushl $39
80109028:	6a 27                	push   $0x27
  jmp alltraps
8010902a:	e9 b8 f9 ff ff       	jmp    801089e7 <alltraps>

8010902f <vector40>:
.globl vector40
vector40:
  pushl $0
8010902f:	6a 00                	push   $0x0
  pushl $40
80109031:	6a 28                	push   $0x28
  jmp alltraps
80109033:	e9 af f9 ff ff       	jmp    801089e7 <alltraps>

80109038 <vector41>:
.globl vector41
vector41:
  pushl $0
80109038:	6a 00                	push   $0x0
  pushl $41
8010903a:	6a 29                	push   $0x29
  jmp alltraps
8010903c:	e9 a6 f9 ff ff       	jmp    801089e7 <alltraps>

80109041 <vector42>:
.globl vector42
vector42:
  pushl $0
80109041:	6a 00                	push   $0x0
  pushl $42
80109043:	6a 2a                	push   $0x2a
  jmp alltraps
80109045:	e9 9d f9 ff ff       	jmp    801089e7 <alltraps>

8010904a <vector43>:
.globl vector43
vector43:
  pushl $0
8010904a:	6a 00                	push   $0x0
  pushl $43
8010904c:	6a 2b                	push   $0x2b
  jmp alltraps
8010904e:	e9 94 f9 ff ff       	jmp    801089e7 <alltraps>

80109053 <vector44>:
.globl vector44
vector44:
  pushl $0
80109053:	6a 00                	push   $0x0
  pushl $44
80109055:	6a 2c                	push   $0x2c
  jmp alltraps
80109057:	e9 8b f9 ff ff       	jmp    801089e7 <alltraps>

8010905c <vector45>:
.globl vector45
vector45:
  pushl $0
8010905c:	6a 00                	push   $0x0
  pushl $45
8010905e:	6a 2d                	push   $0x2d
  jmp alltraps
80109060:	e9 82 f9 ff ff       	jmp    801089e7 <alltraps>

80109065 <vector46>:
.globl vector46
vector46:
  pushl $0
80109065:	6a 00                	push   $0x0
  pushl $46
80109067:	6a 2e                	push   $0x2e
  jmp alltraps
80109069:	e9 79 f9 ff ff       	jmp    801089e7 <alltraps>

8010906e <vector47>:
.globl vector47
vector47:
  pushl $0
8010906e:	6a 00                	push   $0x0
  pushl $47
80109070:	6a 2f                	push   $0x2f
  jmp alltraps
80109072:	e9 70 f9 ff ff       	jmp    801089e7 <alltraps>

80109077 <vector48>:
.globl vector48
vector48:
  pushl $0
80109077:	6a 00                	push   $0x0
  pushl $48
80109079:	6a 30                	push   $0x30
  jmp alltraps
8010907b:	e9 67 f9 ff ff       	jmp    801089e7 <alltraps>

80109080 <vector49>:
.globl vector49
vector49:
  pushl $0
80109080:	6a 00                	push   $0x0
  pushl $49
80109082:	6a 31                	push   $0x31
  jmp alltraps
80109084:	e9 5e f9 ff ff       	jmp    801089e7 <alltraps>

80109089 <vector50>:
.globl vector50
vector50:
  pushl $0
80109089:	6a 00                	push   $0x0
  pushl $50
8010908b:	6a 32                	push   $0x32
  jmp alltraps
8010908d:	e9 55 f9 ff ff       	jmp    801089e7 <alltraps>

80109092 <vector51>:
.globl vector51
vector51:
  pushl $0
80109092:	6a 00                	push   $0x0
  pushl $51
80109094:	6a 33                	push   $0x33
  jmp alltraps
80109096:	e9 4c f9 ff ff       	jmp    801089e7 <alltraps>

8010909b <vector52>:
.globl vector52
vector52:
  pushl $0
8010909b:	6a 00                	push   $0x0
  pushl $52
8010909d:	6a 34                	push   $0x34
  jmp alltraps
8010909f:	e9 43 f9 ff ff       	jmp    801089e7 <alltraps>

801090a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801090a4:	6a 00                	push   $0x0
  pushl $53
801090a6:	6a 35                	push   $0x35
  jmp alltraps
801090a8:	e9 3a f9 ff ff       	jmp    801089e7 <alltraps>

801090ad <vector54>:
.globl vector54
vector54:
  pushl $0
801090ad:	6a 00                	push   $0x0
  pushl $54
801090af:	6a 36                	push   $0x36
  jmp alltraps
801090b1:	e9 31 f9 ff ff       	jmp    801089e7 <alltraps>

801090b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801090b6:	6a 00                	push   $0x0
  pushl $55
801090b8:	6a 37                	push   $0x37
  jmp alltraps
801090ba:	e9 28 f9 ff ff       	jmp    801089e7 <alltraps>

801090bf <vector56>:
.globl vector56
vector56:
  pushl $0
801090bf:	6a 00                	push   $0x0
  pushl $56
801090c1:	6a 38                	push   $0x38
  jmp alltraps
801090c3:	e9 1f f9 ff ff       	jmp    801089e7 <alltraps>

801090c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801090c8:	6a 00                	push   $0x0
  pushl $57
801090ca:	6a 39                	push   $0x39
  jmp alltraps
801090cc:	e9 16 f9 ff ff       	jmp    801089e7 <alltraps>

801090d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801090d1:	6a 00                	push   $0x0
  pushl $58
801090d3:	6a 3a                	push   $0x3a
  jmp alltraps
801090d5:	e9 0d f9 ff ff       	jmp    801089e7 <alltraps>

801090da <vector59>:
.globl vector59
vector59:
  pushl $0
801090da:	6a 00                	push   $0x0
  pushl $59
801090dc:	6a 3b                	push   $0x3b
  jmp alltraps
801090de:	e9 04 f9 ff ff       	jmp    801089e7 <alltraps>

801090e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801090e3:	6a 00                	push   $0x0
  pushl $60
801090e5:	6a 3c                	push   $0x3c
  jmp alltraps
801090e7:	e9 fb f8 ff ff       	jmp    801089e7 <alltraps>

801090ec <vector61>:
.globl vector61
vector61:
  pushl $0
801090ec:	6a 00                	push   $0x0
  pushl $61
801090ee:	6a 3d                	push   $0x3d
  jmp alltraps
801090f0:	e9 f2 f8 ff ff       	jmp    801089e7 <alltraps>

801090f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801090f5:	6a 00                	push   $0x0
  pushl $62
801090f7:	6a 3e                	push   $0x3e
  jmp alltraps
801090f9:	e9 e9 f8 ff ff       	jmp    801089e7 <alltraps>

801090fe <vector63>:
.globl vector63
vector63:
  pushl $0
801090fe:	6a 00                	push   $0x0
  pushl $63
80109100:	6a 3f                	push   $0x3f
  jmp alltraps
80109102:	e9 e0 f8 ff ff       	jmp    801089e7 <alltraps>

80109107 <vector64>:
.globl vector64
vector64:
  pushl $0
80109107:	6a 00                	push   $0x0
  pushl $64
80109109:	6a 40                	push   $0x40
  jmp alltraps
8010910b:	e9 d7 f8 ff ff       	jmp    801089e7 <alltraps>

80109110 <vector65>:
.globl vector65
vector65:
  pushl $0
80109110:	6a 00                	push   $0x0
  pushl $65
80109112:	6a 41                	push   $0x41
  jmp alltraps
80109114:	e9 ce f8 ff ff       	jmp    801089e7 <alltraps>

80109119 <vector66>:
.globl vector66
vector66:
  pushl $0
80109119:	6a 00                	push   $0x0
  pushl $66
8010911b:	6a 42                	push   $0x42
  jmp alltraps
8010911d:	e9 c5 f8 ff ff       	jmp    801089e7 <alltraps>

80109122 <vector67>:
.globl vector67
vector67:
  pushl $0
80109122:	6a 00                	push   $0x0
  pushl $67
80109124:	6a 43                	push   $0x43
  jmp alltraps
80109126:	e9 bc f8 ff ff       	jmp    801089e7 <alltraps>

8010912b <vector68>:
.globl vector68
vector68:
  pushl $0
8010912b:	6a 00                	push   $0x0
  pushl $68
8010912d:	6a 44                	push   $0x44
  jmp alltraps
8010912f:	e9 b3 f8 ff ff       	jmp    801089e7 <alltraps>

80109134 <vector69>:
.globl vector69
vector69:
  pushl $0
80109134:	6a 00                	push   $0x0
  pushl $69
80109136:	6a 45                	push   $0x45
  jmp alltraps
80109138:	e9 aa f8 ff ff       	jmp    801089e7 <alltraps>

8010913d <vector70>:
.globl vector70
vector70:
  pushl $0
8010913d:	6a 00                	push   $0x0
  pushl $70
8010913f:	6a 46                	push   $0x46
  jmp alltraps
80109141:	e9 a1 f8 ff ff       	jmp    801089e7 <alltraps>

80109146 <vector71>:
.globl vector71
vector71:
  pushl $0
80109146:	6a 00                	push   $0x0
  pushl $71
80109148:	6a 47                	push   $0x47
  jmp alltraps
8010914a:	e9 98 f8 ff ff       	jmp    801089e7 <alltraps>

8010914f <vector72>:
.globl vector72
vector72:
  pushl $0
8010914f:	6a 00                	push   $0x0
  pushl $72
80109151:	6a 48                	push   $0x48
  jmp alltraps
80109153:	e9 8f f8 ff ff       	jmp    801089e7 <alltraps>

80109158 <vector73>:
.globl vector73
vector73:
  pushl $0
80109158:	6a 00                	push   $0x0
  pushl $73
8010915a:	6a 49                	push   $0x49
  jmp alltraps
8010915c:	e9 86 f8 ff ff       	jmp    801089e7 <alltraps>

80109161 <vector74>:
.globl vector74
vector74:
  pushl $0
80109161:	6a 00                	push   $0x0
  pushl $74
80109163:	6a 4a                	push   $0x4a
  jmp alltraps
80109165:	e9 7d f8 ff ff       	jmp    801089e7 <alltraps>

8010916a <vector75>:
.globl vector75
vector75:
  pushl $0
8010916a:	6a 00                	push   $0x0
  pushl $75
8010916c:	6a 4b                	push   $0x4b
  jmp alltraps
8010916e:	e9 74 f8 ff ff       	jmp    801089e7 <alltraps>

80109173 <vector76>:
.globl vector76
vector76:
  pushl $0
80109173:	6a 00                	push   $0x0
  pushl $76
80109175:	6a 4c                	push   $0x4c
  jmp alltraps
80109177:	e9 6b f8 ff ff       	jmp    801089e7 <alltraps>

8010917c <vector77>:
.globl vector77
vector77:
  pushl $0
8010917c:	6a 00                	push   $0x0
  pushl $77
8010917e:	6a 4d                	push   $0x4d
  jmp alltraps
80109180:	e9 62 f8 ff ff       	jmp    801089e7 <alltraps>

80109185 <vector78>:
.globl vector78
vector78:
  pushl $0
80109185:	6a 00                	push   $0x0
  pushl $78
80109187:	6a 4e                	push   $0x4e
  jmp alltraps
80109189:	e9 59 f8 ff ff       	jmp    801089e7 <alltraps>

8010918e <vector79>:
.globl vector79
vector79:
  pushl $0
8010918e:	6a 00                	push   $0x0
  pushl $79
80109190:	6a 4f                	push   $0x4f
  jmp alltraps
80109192:	e9 50 f8 ff ff       	jmp    801089e7 <alltraps>

80109197 <vector80>:
.globl vector80
vector80:
  pushl $0
80109197:	6a 00                	push   $0x0
  pushl $80
80109199:	6a 50                	push   $0x50
  jmp alltraps
8010919b:	e9 47 f8 ff ff       	jmp    801089e7 <alltraps>

801091a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801091a0:	6a 00                	push   $0x0
  pushl $81
801091a2:	6a 51                	push   $0x51
  jmp alltraps
801091a4:	e9 3e f8 ff ff       	jmp    801089e7 <alltraps>

801091a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801091a9:	6a 00                	push   $0x0
  pushl $82
801091ab:	6a 52                	push   $0x52
  jmp alltraps
801091ad:	e9 35 f8 ff ff       	jmp    801089e7 <alltraps>

801091b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801091b2:	6a 00                	push   $0x0
  pushl $83
801091b4:	6a 53                	push   $0x53
  jmp alltraps
801091b6:	e9 2c f8 ff ff       	jmp    801089e7 <alltraps>

801091bb <vector84>:
.globl vector84
vector84:
  pushl $0
801091bb:	6a 00                	push   $0x0
  pushl $84
801091bd:	6a 54                	push   $0x54
  jmp alltraps
801091bf:	e9 23 f8 ff ff       	jmp    801089e7 <alltraps>

801091c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801091c4:	6a 00                	push   $0x0
  pushl $85
801091c6:	6a 55                	push   $0x55
  jmp alltraps
801091c8:	e9 1a f8 ff ff       	jmp    801089e7 <alltraps>

801091cd <vector86>:
.globl vector86
vector86:
  pushl $0
801091cd:	6a 00                	push   $0x0
  pushl $86
801091cf:	6a 56                	push   $0x56
  jmp alltraps
801091d1:	e9 11 f8 ff ff       	jmp    801089e7 <alltraps>

801091d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801091d6:	6a 00                	push   $0x0
  pushl $87
801091d8:	6a 57                	push   $0x57
  jmp alltraps
801091da:	e9 08 f8 ff ff       	jmp    801089e7 <alltraps>

801091df <vector88>:
.globl vector88
vector88:
  pushl $0
801091df:	6a 00                	push   $0x0
  pushl $88
801091e1:	6a 58                	push   $0x58
  jmp alltraps
801091e3:	e9 ff f7 ff ff       	jmp    801089e7 <alltraps>

801091e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801091e8:	6a 00                	push   $0x0
  pushl $89
801091ea:	6a 59                	push   $0x59
  jmp alltraps
801091ec:	e9 f6 f7 ff ff       	jmp    801089e7 <alltraps>

801091f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801091f1:	6a 00                	push   $0x0
  pushl $90
801091f3:	6a 5a                	push   $0x5a
  jmp alltraps
801091f5:	e9 ed f7 ff ff       	jmp    801089e7 <alltraps>

801091fa <vector91>:
.globl vector91
vector91:
  pushl $0
801091fa:	6a 00                	push   $0x0
  pushl $91
801091fc:	6a 5b                	push   $0x5b
  jmp alltraps
801091fe:	e9 e4 f7 ff ff       	jmp    801089e7 <alltraps>

80109203 <vector92>:
.globl vector92
vector92:
  pushl $0
80109203:	6a 00                	push   $0x0
  pushl $92
80109205:	6a 5c                	push   $0x5c
  jmp alltraps
80109207:	e9 db f7 ff ff       	jmp    801089e7 <alltraps>

8010920c <vector93>:
.globl vector93
vector93:
  pushl $0
8010920c:	6a 00                	push   $0x0
  pushl $93
8010920e:	6a 5d                	push   $0x5d
  jmp alltraps
80109210:	e9 d2 f7 ff ff       	jmp    801089e7 <alltraps>

80109215 <vector94>:
.globl vector94
vector94:
  pushl $0
80109215:	6a 00                	push   $0x0
  pushl $94
80109217:	6a 5e                	push   $0x5e
  jmp alltraps
80109219:	e9 c9 f7 ff ff       	jmp    801089e7 <alltraps>

8010921e <vector95>:
.globl vector95
vector95:
  pushl $0
8010921e:	6a 00                	push   $0x0
  pushl $95
80109220:	6a 5f                	push   $0x5f
  jmp alltraps
80109222:	e9 c0 f7 ff ff       	jmp    801089e7 <alltraps>

80109227 <vector96>:
.globl vector96
vector96:
  pushl $0
80109227:	6a 00                	push   $0x0
  pushl $96
80109229:	6a 60                	push   $0x60
  jmp alltraps
8010922b:	e9 b7 f7 ff ff       	jmp    801089e7 <alltraps>

80109230 <vector97>:
.globl vector97
vector97:
  pushl $0
80109230:	6a 00                	push   $0x0
  pushl $97
80109232:	6a 61                	push   $0x61
  jmp alltraps
80109234:	e9 ae f7 ff ff       	jmp    801089e7 <alltraps>

80109239 <vector98>:
.globl vector98
vector98:
  pushl $0
80109239:	6a 00                	push   $0x0
  pushl $98
8010923b:	6a 62                	push   $0x62
  jmp alltraps
8010923d:	e9 a5 f7 ff ff       	jmp    801089e7 <alltraps>

80109242 <vector99>:
.globl vector99
vector99:
  pushl $0
80109242:	6a 00                	push   $0x0
  pushl $99
80109244:	6a 63                	push   $0x63
  jmp alltraps
80109246:	e9 9c f7 ff ff       	jmp    801089e7 <alltraps>

8010924b <vector100>:
.globl vector100
vector100:
  pushl $0
8010924b:	6a 00                	push   $0x0
  pushl $100
8010924d:	6a 64                	push   $0x64
  jmp alltraps
8010924f:	e9 93 f7 ff ff       	jmp    801089e7 <alltraps>

80109254 <vector101>:
.globl vector101
vector101:
  pushl $0
80109254:	6a 00                	push   $0x0
  pushl $101
80109256:	6a 65                	push   $0x65
  jmp alltraps
80109258:	e9 8a f7 ff ff       	jmp    801089e7 <alltraps>

8010925d <vector102>:
.globl vector102
vector102:
  pushl $0
8010925d:	6a 00                	push   $0x0
  pushl $102
8010925f:	6a 66                	push   $0x66
  jmp alltraps
80109261:	e9 81 f7 ff ff       	jmp    801089e7 <alltraps>

80109266 <vector103>:
.globl vector103
vector103:
  pushl $0
80109266:	6a 00                	push   $0x0
  pushl $103
80109268:	6a 67                	push   $0x67
  jmp alltraps
8010926a:	e9 78 f7 ff ff       	jmp    801089e7 <alltraps>

8010926f <vector104>:
.globl vector104
vector104:
  pushl $0
8010926f:	6a 00                	push   $0x0
  pushl $104
80109271:	6a 68                	push   $0x68
  jmp alltraps
80109273:	e9 6f f7 ff ff       	jmp    801089e7 <alltraps>

80109278 <vector105>:
.globl vector105
vector105:
  pushl $0
80109278:	6a 00                	push   $0x0
  pushl $105
8010927a:	6a 69                	push   $0x69
  jmp alltraps
8010927c:	e9 66 f7 ff ff       	jmp    801089e7 <alltraps>

80109281 <vector106>:
.globl vector106
vector106:
  pushl $0
80109281:	6a 00                	push   $0x0
  pushl $106
80109283:	6a 6a                	push   $0x6a
  jmp alltraps
80109285:	e9 5d f7 ff ff       	jmp    801089e7 <alltraps>

8010928a <vector107>:
.globl vector107
vector107:
  pushl $0
8010928a:	6a 00                	push   $0x0
  pushl $107
8010928c:	6a 6b                	push   $0x6b
  jmp alltraps
8010928e:	e9 54 f7 ff ff       	jmp    801089e7 <alltraps>

80109293 <vector108>:
.globl vector108
vector108:
  pushl $0
80109293:	6a 00                	push   $0x0
  pushl $108
80109295:	6a 6c                	push   $0x6c
  jmp alltraps
80109297:	e9 4b f7 ff ff       	jmp    801089e7 <alltraps>

8010929c <vector109>:
.globl vector109
vector109:
  pushl $0
8010929c:	6a 00                	push   $0x0
  pushl $109
8010929e:	6a 6d                	push   $0x6d
  jmp alltraps
801092a0:	e9 42 f7 ff ff       	jmp    801089e7 <alltraps>

801092a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801092a5:	6a 00                	push   $0x0
  pushl $110
801092a7:	6a 6e                	push   $0x6e
  jmp alltraps
801092a9:	e9 39 f7 ff ff       	jmp    801089e7 <alltraps>

801092ae <vector111>:
.globl vector111
vector111:
  pushl $0
801092ae:	6a 00                	push   $0x0
  pushl $111
801092b0:	6a 6f                	push   $0x6f
  jmp alltraps
801092b2:	e9 30 f7 ff ff       	jmp    801089e7 <alltraps>

801092b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801092b7:	6a 00                	push   $0x0
  pushl $112
801092b9:	6a 70                	push   $0x70
  jmp alltraps
801092bb:	e9 27 f7 ff ff       	jmp    801089e7 <alltraps>

801092c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801092c0:	6a 00                	push   $0x0
  pushl $113
801092c2:	6a 71                	push   $0x71
  jmp alltraps
801092c4:	e9 1e f7 ff ff       	jmp    801089e7 <alltraps>

801092c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801092c9:	6a 00                	push   $0x0
  pushl $114
801092cb:	6a 72                	push   $0x72
  jmp alltraps
801092cd:	e9 15 f7 ff ff       	jmp    801089e7 <alltraps>

801092d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801092d2:	6a 00                	push   $0x0
  pushl $115
801092d4:	6a 73                	push   $0x73
  jmp alltraps
801092d6:	e9 0c f7 ff ff       	jmp    801089e7 <alltraps>

801092db <vector116>:
.globl vector116
vector116:
  pushl $0
801092db:	6a 00                	push   $0x0
  pushl $116
801092dd:	6a 74                	push   $0x74
  jmp alltraps
801092df:	e9 03 f7 ff ff       	jmp    801089e7 <alltraps>

801092e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801092e4:	6a 00                	push   $0x0
  pushl $117
801092e6:	6a 75                	push   $0x75
  jmp alltraps
801092e8:	e9 fa f6 ff ff       	jmp    801089e7 <alltraps>

801092ed <vector118>:
.globl vector118
vector118:
  pushl $0
801092ed:	6a 00                	push   $0x0
  pushl $118
801092ef:	6a 76                	push   $0x76
  jmp alltraps
801092f1:	e9 f1 f6 ff ff       	jmp    801089e7 <alltraps>

801092f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801092f6:	6a 00                	push   $0x0
  pushl $119
801092f8:	6a 77                	push   $0x77
  jmp alltraps
801092fa:	e9 e8 f6 ff ff       	jmp    801089e7 <alltraps>

801092ff <vector120>:
.globl vector120
vector120:
  pushl $0
801092ff:	6a 00                	push   $0x0
  pushl $120
80109301:	6a 78                	push   $0x78
  jmp alltraps
80109303:	e9 df f6 ff ff       	jmp    801089e7 <alltraps>

80109308 <vector121>:
.globl vector121
vector121:
  pushl $0
80109308:	6a 00                	push   $0x0
  pushl $121
8010930a:	6a 79                	push   $0x79
  jmp alltraps
8010930c:	e9 d6 f6 ff ff       	jmp    801089e7 <alltraps>

80109311 <vector122>:
.globl vector122
vector122:
  pushl $0
80109311:	6a 00                	push   $0x0
  pushl $122
80109313:	6a 7a                	push   $0x7a
  jmp alltraps
80109315:	e9 cd f6 ff ff       	jmp    801089e7 <alltraps>

8010931a <vector123>:
.globl vector123
vector123:
  pushl $0
8010931a:	6a 00                	push   $0x0
  pushl $123
8010931c:	6a 7b                	push   $0x7b
  jmp alltraps
8010931e:	e9 c4 f6 ff ff       	jmp    801089e7 <alltraps>

80109323 <vector124>:
.globl vector124
vector124:
  pushl $0
80109323:	6a 00                	push   $0x0
  pushl $124
80109325:	6a 7c                	push   $0x7c
  jmp alltraps
80109327:	e9 bb f6 ff ff       	jmp    801089e7 <alltraps>

8010932c <vector125>:
.globl vector125
vector125:
  pushl $0
8010932c:	6a 00                	push   $0x0
  pushl $125
8010932e:	6a 7d                	push   $0x7d
  jmp alltraps
80109330:	e9 b2 f6 ff ff       	jmp    801089e7 <alltraps>

80109335 <vector126>:
.globl vector126
vector126:
  pushl $0
80109335:	6a 00                	push   $0x0
  pushl $126
80109337:	6a 7e                	push   $0x7e
  jmp alltraps
80109339:	e9 a9 f6 ff ff       	jmp    801089e7 <alltraps>

8010933e <vector127>:
.globl vector127
vector127:
  pushl $0
8010933e:	6a 00                	push   $0x0
  pushl $127
80109340:	6a 7f                	push   $0x7f
  jmp alltraps
80109342:	e9 a0 f6 ff ff       	jmp    801089e7 <alltraps>

80109347 <vector128>:
.globl vector128
vector128:
  pushl $0
80109347:	6a 00                	push   $0x0
  pushl $128
80109349:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010934e:	e9 94 f6 ff ff       	jmp    801089e7 <alltraps>

80109353 <vector129>:
.globl vector129
vector129:
  pushl $0
80109353:	6a 00                	push   $0x0
  pushl $129
80109355:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010935a:	e9 88 f6 ff ff       	jmp    801089e7 <alltraps>

8010935f <vector130>:
.globl vector130
vector130:
  pushl $0
8010935f:	6a 00                	push   $0x0
  pushl $130
80109361:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80109366:	e9 7c f6 ff ff       	jmp    801089e7 <alltraps>

8010936b <vector131>:
.globl vector131
vector131:
  pushl $0
8010936b:	6a 00                	push   $0x0
  pushl $131
8010936d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80109372:	e9 70 f6 ff ff       	jmp    801089e7 <alltraps>

80109377 <vector132>:
.globl vector132
vector132:
  pushl $0
80109377:	6a 00                	push   $0x0
  pushl $132
80109379:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010937e:	e9 64 f6 ff ff       	jmp    801089e7 <alltraps>

80109383 <vector133>:
.globl vector133
vector133:
  pushl $0
80109383:	6a 00                	push   $0x0
  pushl $133
80109385:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010938a:	e9 58 f6 ff ff       	jmp    801089e7 <alltraps>

8010938f <vector134>:
.globl vector134
vector134:
  pushl $0
8010938f:	6a 00                	push   $0x0
  pushl $134
80109391:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80109396:	e9 4c f6 ff ff       	jmp    801089e7 <alltraps>

8010939b <vector135>:
.globl vector135
vector135:
  pushl $0
8010939b:	6a 00                	push   $0x0
  pushl $135
8010939d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801093a2:	e9 40 f6 ff ff       	jmp    801089e7 <alltraps>

801093a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801093a7:	6a 00                	push   $0x0
  pushl $136
801093a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801093ae:	e9 34 f6 ff ff       	jmp    801089e7 <alltraps>

801093b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801093b3:	6a 00                	push   $0x0
  pushl $137
801093b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801093ba:	e9 28 f6 ff ff       	jmp    801089e7 <alltraps>

801093bf <vector138>:
.globl vector138
vector138:
  pushl $0
801093bf:	6a 00                	push   $0x0
  pushl $138
801093c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801093c6:	e9 1c f6 ff ff       	jmp    801089e7 <alltraps>

801093cb <vector139>:
.globl vector139
vector139:
  pushl $0
801093cb:	6a 00                	push   $0x0
  pushl $139
801093cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801093d2:	e9 10 f6 ff ff       	jmp    801089e7 <alltraps>

801093d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801093d7:	6a 00                	push   $0x0
  pushl $140
801093d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801093de:	e9 04 f6 ff ff       	jmp    801089e7 <alltraps>

801093e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801093e3:	6a 00                	push   $0x0
  pushl $141
801093e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801093ea:	e9 f8 f5 ff ff       	jmp    801089e7 <alltraps>

801093ef <vector142>:
.globl vector142
vector142:
  pushl $0
801093ef:	6a 00                	push   $0x0
  pushl $142
801093f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801093f6:	e9 ec f5 ff ff       	jmp    801089e7 <alltraps>

801093fb <vector143>:
.globl vector143
vector143:
  pushl $0
801093fb:	6a 00                	push   $0x0
  pushl $143
801093fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80109402:	e9 e0 f5 ff ff       	jmp    801089e7 <alltraps>

80109407 <vector144>:
.globl vector144
vector144:
  pushl $0
80109407:	6a 00                	push   $0x0
  pushl $144
80109409:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010940e:	e9 d4 f5 ff ff       	jmp    801089e7 <alltraps>

80109413 <vector145>:
.globl vector145
vector145:
  pushl $0
80109413:	6a 00                	push   $0x0
  pushl $145
80109415:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010941a:	e9 c8 f5 ff ff       	jmp    801089e7 <alltraps>

8010941f <vector146>:
.globl vector146
vector146:
  pushl $0
8010941f:	6a 00                	push   $0x0
  pushl $146
80109421:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80109426:	e9 bc f5 ff ff       	jmp    801089e7 <alltraps>

8010942b <vector147>:
.globl vector147
vector147:
  pushl $0
8010942b:	6a 00                	push   $0x0
  pushl $147
8010942d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80109432:	e9 b0 f5 ff ff       	jmp    801089e7 <alltraps>

80109437 <vector148>:
.globl vector148
vector148:
  pushl $0
80109437:	6a 00                	push   $0x0
  pushl $148
80109439:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010943e:	e9 a4 f5 ff ff       	jmp    801089e7 <alltraps>

80109443 <vector149>:
.globl vector149
vector149:
  pushl $0
80109443:	6a 00                	push   $0x0
  pushl $149
80109445:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010944a:	e9 98 f5 ff ff       	jmp    801089e7 <alltraps>

8010944f <vector150>:
.globl vector150
vector150:
  pushl $0
8010944f:	6a 00                	push   $0x0
  pushl $150
80109451:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80109456:	e9 8c f5 ff ff       	jmp    801089e7 <alltraps>

8010945b <vector151>:
.globl vector151
vector151:
  pushl $0
8010945b:	6a 00                	push   $0x0
  pushl $151
8010945d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80109462:	e9 80 f5 ff ff       	jmp    801089e7 <alltraps>

80109467 <vector152>:
.globl vector152
vector152:
  pushl $0
80109467:	6a 00                	push   $0x0
  pushl $152
80109469:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010946e:	e9 74 f5 ff ff       	jmp    801089e7 <alltraps>

80109473 <vector153>:
.globl vector153
vector153:
  pushl $0
80109473:	6a 00                	push   $0x0
  pushl $153
80109475:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010947a:	e9 68 f5 ff ff       	jmp    801089e7 <alltraps>

8010947f <vector154>:
.globl vector154
vector154:
  pushl $0
8010947f:	6a 00                	push   $0x0
  pushl $154
80109481:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80109486:	e9 5c f5 ff ff       	jmp    801089e7 <alltraps>

8010948b <vector155>:
.globl vector155
vector155:
  pushl $0
8010948b:	6a 00                	push   $0x0
  pushl $155
8010948d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80109492:	e9 50 f5 ff ff       	jmp    801089e7 <alltraps>

80109497 <vector156>:
.globl vector156
vector156:
  pushl $0
80109497:	6a 00                	push   $0x0
  pushl $156
80109499:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010949e:	e9 44 f5 ff ff       	jmp    801089e7 <alltraps>

801094a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801094a3:	6a 00                	push   $0x0
  pushl $157
801094a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801094aa:	e9 38 f5 ff ff       	jmp    801089e7 <alltraps>

801094af <vector158>:
.globl vector158
vector158:
  pushl $0
801094af:	6a 00                	push   $0x0
  pushl $158
801094b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801094b6:	e9 2c f5 ff ff       	jmp    801089e7 <alltraps>

801094bb <vector159>:
.globl vector159
vector159:
  pushl $0
801094bb:	6a 00                	push   $0x0
  pushl $159
801094bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801094c2:	e9 20 f5 ff ff       	jmp    801089e7 <alltraps>

801094c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801094c7:	6a 00                	push   $0x0
  pushl $160
801094c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801094ce:	e9 14 f5 ff ff       	jmp    801089e7 <alltraps>

801094d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801094d3:	6a 00                	push   $0x0
  pushl $161
801094d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801094da:	e9 08 f5 ff ff       	jmp    801089e7 <alltraps>

801094df <vector162>:
.globl vector162
vector162:
  pushl $0
801094df:	6a 00                	push   $0x0
  pushl $162
801094e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801094e6:	e9 fc f4 ff ff       	jmp    801089e7 <alltraps>

801094eb <vector163>:
.globl vector163
vector163:
  pushl $0
801094eb:	6a 00                	push   $0x0
  pushl $163
801094ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801094f2:	e9 f0 f4 ff ff       	jmp    801089e7 <alltraps>

801094f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801094f7:	6a 00                	push   $0x0
  pushl $164
801094f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801094fe:	e9 e4 f4 ff ff       	jmp    801089e7 <alltraps>

80109503 <vector165>:
.globl vector165
vector165:
  pushl $0
80109503:	6a 00                	push   $0x0
  pushl $165
80109505:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010950a:	e9 d8 f4 ff ff       	jmp    801089e7 <alltraps>

8010950f <vector166>:
.globl vector166
vector166:
  pushl $0
8010950f:	6a 00                	push   $0x0
  pushl $166
80109511:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80109516:	e9 cc f4 ff ff       	jmp    801089e7 <alltraps>

8010951b <vector167>:
.globl vector167
vector167:
  pushl $0
8010951b:	6a 00                	push   $0x0
  pushl $167
8010951d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80109522:	e9 c0 f4 ff ff       	jmp    801089e7 <alltraps>

80109527 <vector168>:
.globl vector168
vector168:
  pushl $0
80109527:	6a 00                	push   $0x0
  pushl $168
80109529:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010952e:	e9 b4 f4 ff ff       	jmp    801089e7 <alltraps>

80109533 <vector169>:
.globl vector169
vector169:
  pushl $0
80109533:	6a 00                	push   $0x0
  pushl $169
80109535:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010953a:	e9 a8 f4 ff ff       	jmp    801089e7 <alltraps>

8010953f <vector170>:
.globl vector170
vector170:
  pushl $0
8010953f:	6a 00                	push   $0x0
  pushl $170
80109541:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80109546:	e9 9c f4 ff ff       	jmp    801089e7 <alltraps>

8010954b <vector171>:
.globl vector171
vector171:
  pushl $0
8010954b:	6a 00                	push   $0x0
  pushl $171
8010954d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80109552:	e9 90 f4 ff ff       	jmp    801089e7 <alltraps>

80109557 <vector172>:
.globl vector172
vector172:
  pushl $0
80109557:	6a 00                	push   $0x0
  pushl $172
80109559:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010955e:	e9 84 f4 ff ff       	jmp    801089e7 <alltraps>

80109563 <vector173>:
.globl vector173
vector173:
  pushl $0
80109563:	6a 00                	push   $0x0
  pushl $173
80109565:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010956a:	e9 78 f4 ff ff       	jmp    801089e7 <alltraps>

8010956f <vector174>:
.globl vector174
vector174:
  pushl $0
8010956f:	6a 00                	push   $0x0
  pushl $174
80109571:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80109576:	e9 6c f4 ff ff       	jmp    801089e7 <alltraps>

8010957b <vector175>:
.globl vector175
vector175:
  pushl $0
8010957b:	6a 00                	push   $0x0
  pushl $175
8010957d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80109582:	e9 60 f4 ff ff       	jmp    801089e7 <alltraps>

80109587 <vector176>:
.globl vector176
vector176:
  pushl $0
80109587:	6a 00                	push   $0x0
  pushl $176
80109589:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010958e:	e9 54 f4 ff ff       	jmp    801089e7 <alltraps>

80109593 <vector177>:
.globl vector177
vector177:
  pushl $0
80109593:	6a 00                	push   $0x0
  pushl $177
80109595:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010959a:	e9 48 f4 ff ff       	jmp    801089e7 <alltraps>

8010959f <vector178>:
.globl vector178
vector178:
  pushl $0
8010959f:	6a 00                	push   $0x0
  pushl $178
801095a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801095a6:	e9 3c f4 ff ff       	jmp    801089e7 <alltraps>

801095ab <vector179>:
.globl vector179
vector179:
  pushl $0
801095ab:	6a 00                	push   $0x0
  pushl $179
801095ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801095b2:	e9 30 f4 ff ff       	jmp    801089e7 <alltraps>

801095b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801095b7:	6a 00                	push   $0x0
  pushl $180
801095b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801095be:	e9 24 f4 ff ff       	jmp    801089e7 <alltraps>

801095c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801095c3:	6a 00                	push   $0x0
  pushl $181
801095c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801095ca:	e9 18 f4 ff ff       	jmp    801089e7 <alltraps>

801095cf <vector182>:
.globl vector182
vector182:
  pushl $0
801095cf:	6a 00                	push   $0x0
  pushl $182
801095d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801095d6:	e9 0c f4 ff ff       	jmp    801089e7 <alltraps>

801095db <vector183>:
.globl vector183
vector183:
  pushl $0
801095db:	6a 00                	push   $0x0
  pushl $183
801095dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801095e2:	e9 00 f4 ff ff       	jmp    801089e7 <alltraps>

801095e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801095e7:	6a 00                	push   $0x0
  pushl $184
801095e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801095ee:	e9 f4 f3 ff ff       	jmp    801089e7 <alltraps>

801095f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801095f3:	6a 00                	push   $0x0
  pushl $185
801095f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801095fa:	e9 e8 f3 ff ff       	jmp    801089e7 <alltraps>

801095ff <vector186>:
.globl vector186
vector186:
  pushl $0
801095ff:	6a 00                	push   $0x0
  pushl $186
80109601:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80109606:	e9 dc f3 ff ff       	jmp    801089e7 <alltraps>

8010960b <vector187>:
.globl vector187
vector187:
  pushl $0
8010960b:	6a 00                	push   $0x0
  pushl $187
8010960d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80109612:	e9 d0 f3 ff ff       	jmp    801089e7 <alltraps>

80109617 <vector188>:
.globl vector188
vector188:
  pushl $0
80109617:	6a 00                	push   $0x0
  pushl $188
80109619:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010961e:	e9 c4 f3 ff ff       	jmp    801089e7 <alltraps>

80109623 <vector189>:
.globl vector189
vector189:
  pushl $0
80109623:	6a 00                	push   $0x0
  pushl $189
80109625:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010962a:	e9 b8 f3 ff ff       	jmp    801089e7 <alltraps>

8010962f <vector190>:
.globl vector190
vector190:
  pushl $0
8010962f:	6a 00                	push   $0x0
  pushl $190
80109631:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80109636:	e9 ac f3 ff ff       	jmp    801089e7 <alltraps>

8010963b <vector191>:
.globl vector191
vector191:
  pushl $0
8010963b:	6a 00                	push   $0x0
  pushl $191
8010963d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80109642:	e9 a0 f3 ff ff       	jmp    801089e7 <alltraps>

80109647 <vector192>:
.globl vector192
vector192:
  pushl $0
80109647:	6a 00                	push   $0x0
  pushl $192
80109649:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010964e:	e9 94 f3 ff ff       	jmp    801089e7 <alltraps>

80109653 <vector193>:
.globl vector193
vector193:
  pushl $0
80109653:	6a 00                	push   $0x0
  pushl $193
80109655:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010965a:	e9 88 f3 ff ff       	jmp    801089e7 <alltraps>

8010965f <vector194>:
.globl vector194
vector194:
  pushl $0
8010965f:	6a 00                	push   $0x0
  pushl $194
80109661:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80109666:	e9 7c f3 ff ff       	jmp    801089e7 <alltraps>

8010966b <vector195>:
.globl vector195
vector195:
  pushl $0
8010966b:	6a 00                	push   $0x0
  pushl $195
8010966d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80109672:	e9 70 f3 ff ff       	jmp    801089e7 <alltraps>

80109677 <vector196>:
.globl vector196
vector196:
  pushl $0
80109677:	6a 00                	push   $0x0
  pushl $196
80109679:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010967e:	e9 64 f3 ff ff       	jmp    801089e7 <alltraps>

80109683 <vector197>:
.globl vector197
vector197:
  pushl $0
80109683:	6a 00                	push   $0x0
  pushl $197
80109685:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010968a:	e9 58 f3 ff ff       	jmp    801089e7 <alltraps>

8010968f <vector198>:
.globl vector198
vector198:
  pushl $0
8010968f:	6a 00                	push   $0x0
  pushl $198
80109691:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80109696:	e9 4c f3 ff ff       	jmp    801089e7 <alltraps>

8010969b <vector199>:
.globl vector199
vector199:
  pushl $0
8010969b:	6a 00                	push   $0x0
  pushl $199
8010969d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801096a2:	e9 40 f3 ff ff       	jmp    801089e7 <alltraps>

801096a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801096a7:	6a 00                	push   $0x0
  pushl $200
801096a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801096ae:	e9 34 f3 ff ff       	jmp    801089e7 <alltraps>

801096b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801096b3:	6a 00                	push   $0x0
  pushl $201
801096b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801096ba:	e9 28 f3 ff ff       	jmp    801089e7 <alltraps>

801096bf <vector202>:
.globl vector202
vector202:
  pushl $0
801096bf:	6a 00                	push   $0x0
  pushl $202
801096c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801096c6:	e9 1c f3 ff ff       	jmp    801089e7 <alltraps>

801096cb <vector203>:
.globl vector203
vector203:
  pushl $0
801096cb:	6a 00                	push   $0x0
  pushl $203
801096cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801096d2:	e9 10 f3 ff ff       	jmp    801089e7 <alltraps>

801096d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801096d7:	6a 00                	push   $0x0
  pushl $204
801096d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801096de:	e9 04 f3 ff ff       	jmp    801089e7 <alltraps>

801096e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801096e3:	6a 00                	push   $0x0
  pushl $205
801096e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801096ea:	e9 f8 f2 ff ff       	jmp    801089e7 <alltraps>

801096ef <vector206>:
.globl vector206
vector206:
  pushl $0
801096ef:	6a 00                	push   $0x0
  pushl $206
801096f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801096f6:	e9 ec f2 ff ff       	jmp    801089e7 <alltraps>

801096fb <vector207>:
.globl vector207
vector207:
  pushl $0
801096fb:	6a 00                	push   $0x0
  pushl $207
801096fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109702:	e9 e0 f2 ff ff       	jmp    801089e7 <alltraps>

80109707 <vector208>:
.globl vector208
vector208:
  pushl $0
80109707:	6a 00                	push   $0x0
  pushl $208
80109709:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010970e:	e9 d4 f2 ff ff       	jmp    801089e7 <alltraps>

80109713 <vector209>:
.globl vector209
vector209:
  pushl $0
80109713:	6a 00                	push   $0x0
  pushl $209
80109715:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010971a:	e9 c8 f2 ff ff       	jmp    801089e7 <alltraps>

8010971f <vector210>:
.globl vector210
vector210:
  pushl $0
8010971f:	6a 00                	push   $0x0
  pushl $210
80109721:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80109726:	e9 bc f2 ff ff       	jmp    801089e7 <alltraps>

8010972b <vector211>:
.globl vector211
vector211:
  pushl $0
8010972b:	6a 00                	push   $0x0
  pushl $211
8010972d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80109732:	e9 b0 f2 ff ff       	jmp    801089e7 <alltraps>

80109737 <vector212>:
.globl vector212
vector212:
  pushl $0
80109737:	6a 00                	push   $0x0
  pushl $212
80109739:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010973e:	e9 a4 f2 ff ff       	jmp    801089e7 <alltraps>

80109743 <vector213>:
.globl vector213
vector213:
  pushl $0
80109743:	6a 00                	push   $0x0
  pushl $213
80109745:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010974a:	e9 98 f2 ff ff       	jmp    801089e7 <alltraps>

8010974f <vector214>:
.globl vector214
vector214:
  pushl $0
8010974f:	6a 00                	push   $0x0
  pushl $214
80109751:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80109756:	e9 8c f2 ff ff       	jmp    801089e7 <alltraps>

8010975b <vector215>:
.globl vector215
vector215:
  pushl $0
8010975b:	6a 00                	push   $0x0
  pushl $215
8010975d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80109762:	e9 80 f2 ff ff       	jmp    801089e7 <alltraps>

80109767 <vector216>:
.globl vector216
vector216:
  pushl $0
80109767:	6a 00                	push   $0x0
  pushl $216
80109769:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010976e:	e9 74 f2 ff ff       	jmp    801089e7 <alltraps>

80109773 <vector217>:
.globl vector217
vector217:
  pushl $0
80109773:	6a 00                	push   $0x0
  pushl $217
80109775:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010977a:	e9 68 f2 ff ff       	jmp    801089e7 <alltraps>

8010977f <vector218>:
.globl vector218
vector218:
  pushl $0
8010977f:	6a 00                	push   $0x0
  pushl $218
80109781:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80109786:	e9 5c f2 ff ff       	jmp    801089e7 <alltraps>

8010978b <vector219>:
.globl vector219
vector219:
  pushl $0
8010978b:	6a 00                	push   $0x0
  pushl $219
8010978d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80109792:	e9 50 f2 ff ff       	jmp    801089e7 <alltraps>

80109797 <vector220>:
.globl vector220
vector220:
  pushl $0
80109797:	6a 00                	push   $0x0
  pushl $220
80109799:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010979e:	e9 44 f2 ff ff       	jmp    801089e7 <alltraps>

801097a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801097a3:	6a 00                	push   $0x0
  pushl $221
801097a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801097aa:	e9 38 f2 ff ff       	jmp    801089e7 <alltraps>

801097af <vector222>:
.globl vector222
vector222:
  pushl $0
801097af:	6a 00                	push   $0x0
  pushl $222
801097b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801097b6:	e9 2c f2 ff ff       	jmp    801089e7 <alltraps>

801097bb <vector223>:
.globl vector223
vector223:
  pushl $0
801097bb:	6a 00                	push   $0x0
  pushl $223
801097bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801097c2:	e9 20 f2 ff ff       	jmp    801089e7 <alltraps>

801097c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801097c7:	6a 00                	push   $0x0
  pushl $224
801097c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801097ce:	e9 14 f2 ff ff       	jmp    801089e7 <alltraps>

801097d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801097d3:	6a 00                	push   $0x0
  pushl $225
801097d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801097da:	e9 08 f2 ff ff       	jmp    801089e7 <alltraps>

801097df <vector226>:
.globl vector226
vector226:
  pushl $0
801097df:	6a 00                	push   $0x0
  pushl $226
801097e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801097e6:	e9 fc f1 ff ff       	jmp    801089e7 <alltraps>

801097eb <vector227>:
.globl vector227
vector227:
  pushl $0
801097eb:	6a 00                	push   $0x0
  pushl $227
801097ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801097f2:	e9 f0 f1 ff ff       	jmp    801089e7 <alltraps>

801097f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801097f7:	6a 00                	push   $0x0
  pushl $228
801097f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801097fe:	e9 e4 f1 ff ff       	jmp    801089e7 <alltraps>

80109803 <vector229>:
.globl vector229
vector229:
  pushl $0
80109803:	6a 00                	push   $0x0
  pushl $229
80109805:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010980a:	e9 d8 f1 ff ff       	jmp    801089e7 <alltraps>

8010980f <vector230>:
.globl vector230
vector230:
  pushl $0
8010980f:	6a 00                	push   $0x0
  pushl $230
80109811:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109816:	e9 cc f1 ff ff       	jmp    801089e7 <alltraps>

8010981b <vector231>:
.globl vector231
vector231:
  pushl $0
8010981b:	6a 00                	push   $0x0
  pushl $231
8010981d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109822:	e9 c0 f1 ff ff       	jmp    801089e7 <alltraps>

80109827 <vector232>:
.globl vector232
vector232:
  pushl $0
80109827:	6a 00                	push   $0x0
  pushl $232
80109829:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010982e:	e9 b4 f1 ff ff       	jmp    801089e7 <alltraps>

80109833 <vector233>:
.globl vector233
vector233:
  pushl $0
80109833:	6a 00                	push   $0x0
  pushl $233
80109835:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010983a:	e9 a8 f1 ff ff       	jmp    801089e7 <alltraps>

8010983f <vector234>:
.globl vector234
vector234:
  pushl $0
8010983f:	6a 00                	push   $0x0
  pushl $234
80109841:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109846:	e9 9c f1 ff ff       	jmp    801089e7 <alltraps>

8010984b <vector235>:
.globl vector235
vector235:
  pushl $0
8010984b:	6a 00                	push   $0x0
  pushl $235
8010984d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109852:	e9 90 f1 ff ff       	jmp    801089e7 <alltraps>

80109857 <vector236>:
.globl vector236
vector236:
  pushl $0
80109857:	6a 00                	push   $0x0
  pushl $236
80109859:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010985e:	e9 84 f1 ff ff       	jmp    801089e7 <alltraps>

80109863 <vector237>:
.globl vector237
vector237:
  pushl $0
80109863:	6a 00                	push   $0x0
  pushl $237
80109865:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010986a:	e9 78 f1 ff ff       	jmp    801089e7 <alltraps>

8010986f <vector238>:
.globl vector238
vector238:
  pushl $0
8010986f:	6a 00                	push   $0x0
  pushl $238
80109871:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109876:	e9 6c f1 ff ff       	jmp    801089e7 <alltraps>

8010987b <vector239>:
.globl vector239
vector239:
  pushl $0
8010987b:	6a 00                	push   $0x0
  pushl $239
8010987d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109882:	e9 60 f1 ff ff       	jmp    801089e7 <alltraps>

80109887 <vector240>:
.globl vector240
vector240:
  pushl $0
80109887:	6a 00                	push   $0x0
  pushl $240
80109889:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010988e:	e9 54 f1 ff ff       	jmp    801089e7 <alltraps>

80109893 <vector241>:
.globl vector241
vector241:
  pushl $0
80109893:	6a 00                	push   $0x0
  pushl $241
80109895:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010989a:	e9 48 f1 ff ff       	jmp    801089e7 <alltraps>

8010989f <vector242>:
.globl vector242
vector242:
  pushl $0
8010989f:	6a 00                	push   $0x0
  pushl $242
801098a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801098a6:	e9 3c f1 ff ff       	jmp    801089e7 <alltraps>

801098ab <vector243>:
.globl vector243
vector243:
  pushl $0
801098ab:	6a 00                	push   $0x0
  pushl $243
801098ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801098b2:	e9 30 f1 ff ff       	jmp    801089e7 <alltraps>

801098b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801098b7:	6a 00                	push   $0x0
  pushl $244
801098b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801098be:	e9 24 f1 ff ff       	jmp    801089e7 <alltraps>

801098c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801098c3:	6a 00                	push   $0x0
  pushl $245
801098c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801098ca:	e9 18 f1 ff ff       	jmp    801089e7 <alltraps>

801098cf <vector246>:
.globl vector246
vector246:
  pushl $0
801098cf:	6a 00                	push   $0x0
  pushl $246
801098d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801098d6:	e9 0c f1 ff ff       	jmp    801089e7 <alltraps>

801098db <vector247>:
.globl vector247
vector247:
  pushl $0
801098db:	6a 00                	push   $0x0
  pushl $247
801098dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801098e2:	e9 00 f1 ff ff       	jmp    801089e7 <alltraps>

801098e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801098e7:	6a 00                	push   $0x0
  pushl $248
801098e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801098ee:	e9 f4 f0 ff ff       	jmp    801089e7 <alltraps>

801098f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801098f3:	6a 00                	push   $0x0
  pushl $249
801098f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801098fa:	e9 e8 f0 ff ff       	jmp    801089e7 <alltraps>

801098ff <vector250>:
.globl vector250
vector250:
  pushl $0
801098ff:	6a 00                	push   $0x0
  pushl $250
80109901:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109906:	e9 dc f0 ff ff       	jmp    801089e7 <alltraps>

8010990b <vector251>:
.globl vector251
vector251:
  pushl $0
8010990b:	6a 00                	push   $0x0
  pushl $251
8010990d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109912:	e9 d0 f0 ff ff       	jmp    801089e7 <alltraps>

80109917 <vector252>:
.globl vector252
vector252:
  pushl $0
80109917:	6a 00                	push   $0x0
  pushl $252
80109919:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010991e:	e9 c4 f0 ff ff       	jmp    801089e7 <alltraps>

80109923 <vector253>:
.globl vector253
vector253:
  pushl $0
80109923:	6a 00                	push   $0x0
  pushl $253
80109925:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010992a:	e9 b8 f0 ff ff       	jmp    801089e7 <alltraps>

8010992f <vector254>:
.globl vector254
vector254:
  pushl $0
8010992f:	6a 00                	push   $0x0
  pushl $254
80109931:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109936:	e9 ac f0 ff ff       	jmp    801089e7 <alltraps>

8010993b <vector255>:
.globl vector255
vector255:
  pushl $0
8010993b:	6a 00                	push   $0x0
  pushl $255
8010993d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109942:	e9 a0 f0 ff ff       	jmp    801089e7 <alltraps>
80109947:	66 90                	xchg   %ax,%ax
80109949:	66 90                	xchg   %ax,%ax
8010994b:	66 90                	xchg   %ax,%ax
8010994d:	66 90                	xchg   %ax,%ax
8010994f:	90                   	nop

80109950 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80109950:	55                   	push   %ebp
80109951:	89 e5                	mov    %esp,%ebp
80109953:	57                   	push   %edi
80109954:	56                   	push   %esi
80109955:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80109956:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010995c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80109962:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80109965:	39 d3                	cmp    %edx,%ebx
80109967:	73 56                	jae    801099bf <deallocuvm.part.0+0x6f>
80109969:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010996c:	89 c6                	mov    %eax,%esi
8010996e:	89 d7                	mov    %edx,%edi
80109970:	eb 12                	jmp    80109984 <deallocuvm.part.0+0x34>
80109972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80109978:	83 c2 01             	add    $0x1,%edx
8010997b:	89 d3                	mov    %edx,%ebx
8010997d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80109980:	39 fb                	cmp    %edi,%ebx
80109982:	73 38                	jae    801099bc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80109984:	89 da                	mov    %ebx,%edx
80109986:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80109989:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010998c:	a8 01                	test   $0x1,%al
8010998e:	74 e8                	je     80109978 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80109990:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109992:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109997:	c1 e9 0a             	shr    $0xa,%ecx
8010999a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801099a0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801099a7:	85 c0                	test   %eax,%eax
801099a9:	74 cd                	je     80109978 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801099ab:	8b 10                	mov    (%eax),%edx
801099ad:	f6 c2 01             	test   $0x1,%dl
801099b0:	75 1e                	jne    801099d0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801099b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801099b8:	39 fb                	cmp    %edi,%ebx
801099ba:	72 c8                	jb     80109984 <deallocuvm.part.0+0x34>
801099bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801099bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801099c2:	89 c8                	mov    %ecx,%eax
801099c4:	5b                   	pop    %ebx
801099c5:	5e                   	pop    %esi
801099c6:	5f                   	pop    %edi
801099c7:	5d                   	pop    %ebp
801099c8:	c3                   	ret
801099c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801099d0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801099d6:	74 26                	je     801099fe <deallocuvm.part.0+0xae>
      kfree(v);
801099d8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801099db:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801099e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801099e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801099ea:	52                   	push   %edx
801099eb:	e8 c0 a9 ff ff       	call   801043b0 <kfree>
      *pte = 0;
801099f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
801099f3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801099f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801099fc:	eb 82                	jmp    80109980 <deallocuvm.part.0+0x30>
        panic("kfree");
801099fe:	83 ec 0c             	sub    $0xc,%esp
80109a01:	68 15 a5 10 80       	push   $0x8010a515
80109a06:	e8 f5 73 ff ff       	call   80100e00 <panic>
80109a0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80109a10 <mappages>:
{
80109a10:	55                   	push   %ebp
80109a11:	89 e5                	mov    %esp,%ebp
80109a13:	57                   	push   %edi
80109a14:	56                   	push   %esi
80109a15:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80109a16:	89 d3                	mov    %edx,%ebx
80109a18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80109a1e:	83 ec 1c             	sub    $0x1c,%esp
80109a21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109a24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80109a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80109a30:	8b 45 08             	mov    0x8(%ebp),%eax
80109a33:	29 d8                	sub    %ebx,%eax
80109a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109a38:	eb 3f                	jmp    80109a79 <mappages+0x69>
80109a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80109a40:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80109a47:	c1 ea 0a             	shr    $0xa,%edx
80109a4a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80109a50:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109a57:	85 c0                	test   %eax,%eax
80109a59:	74 75                	je     80109ad0 <mappages+0xc0>
    if(*pte & PTE_P)
80109a5b:	f6 00 01             	testb  $0x1,(%eax)
80109a5e:	0f 85 86 00 00 00    	jne    80109aea <mappages+0xda>
    *pte = pa | perm | PTE_P;
80109a64:	0b 75 0c             	or     0xc(%ebp),%esi
80109a67:	83 ce 01             	or     $0x1,%esi
80109a6a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80109a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109a6f:	39 c3                	cmp    %eax,%ebx
80109a71:	74 6d                	je     80109ae0 <mappages+0xd0>
    a += PGSIZE;
80109a73:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80109a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80109a7c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80109a7f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80109a82:	89 d8                	mov    %ebx,%eax
80109a84:	c1 e8 16             	shr    $0x16,%eax
80109a87:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80109a8a:	8b 07                	mov    (%edi),%eax
80109a8c:	a8 01                	test   $0x1,%al
80109a8e:	75 b0                	jne    80109a40 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109a90:	e8 db aa ff ff       	call   80104570 <kalloc>
80109a95:	85 c0                	test   %eax,%eax
80109a97:	74 37                	je     80109ad0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80109a99:	83 ec 04             	sub    $0x4,%esp
80109a9c:	68 00 10 00 00       	push   $0x1000
80109aa1:	6a 00                	push   $0x0
80109aa3:	50                   	push   %eax
80109aa4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80109aa7:	e8 04 d5 ff ff       	call   80106fb0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80109aac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80109aaf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80109ab2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80109ab8:	83 c8 07             	or     $0x7,%eax
80109abb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80109abd:	89 d8                	mov    %ebx,%eax
80109abf:	c1 e8 0a             	shr    $0xa,%eax
80109ac2:	25 fc 0f 00 00       	and    $0xffc,%eax
80109ac7:	01 d0                	add    %edx,%eax
80109ac9:	eb 90                	jmp    80109a5b <mappages+0x4b>
80109acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80109ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80109ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109ad8:	5b                   	pop    %ebx
80109ad9:	5e                   	pop    %esi
80109ada:	5f                   	pop    %edi
80109adb:	5d                   	pop    %ebp
80109adc:	c3                   	ret
80109add:	8d 76 00             	lea    0x0(%esi),%esi
80109ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80109ae3:	31 c0                	xor    %eax,%eax
}
80109ae5:	5b                   	pop    %ebx
80109ae6:	5e                   	pop    %esi
80109ae7:	5f                   	pop    %edi
80109ae8:	5d                   	pop    %ebp
80109ae9:	c3                   	ret
      panic("remap");
80109aea:	83 ec 0c             	sub    $0xc,%esp
80109aed:	68 28 a8 10 80       	push   $0x8010a828
80109af2:	e8 09 73 ff ff       	call   80100e00 <panic>
80109af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109afe:	00 
80109aff:	90                   	nop

80109b00 <seginit>:
{
80109b00:	55                   	push   %ebp
80109b01:	89 e5                	mov    %esp,%ebp
80109b03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80109b06:	e8 75 bd ff ff       	call   80105880 <cpuid>
  pd[0] = size-1;
80109b0b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80109b10:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80109b16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80109b1a:	c7 80 d8 61 11 80 ff 	movl   $0xffff,-0x7fee9e28(%eax)
80109b21:	ff 00 00 
80109b24:	c7 80 dc 61 11 80 00 	movl   $0xcf9a00,-0x7fee9e24(%eax)
80109b2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109b2e:	c7 80 e0 61 11 80 ff 	movl   $0xffff,-0x7fee9e20(%eax)
80109b35:	ff 00 00 
80109b38:	c7 80 e4 61 11 80 00 	movl   $0xcf9200,-0x7fee9e1c(%eax)
80109b3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109b42:	c7 80 e8 61 11 80 ff 	movl   $0xffff,-0x7fee9e18(%eax)
80109b49:	ff 00 00 
80109b4c:	c7 80 ec 61 11 80 00 	movl   $0xcffa00,-0x7fee9e14(%eax)
80109b53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80109b56:	c7 80 f0 61 11 80 ff 	movl   $0xffff,-0x7fee9e10(%eax)
80109b5d:	ff 00 00 
80109b60:	c7 80 f4 61 11 80 00 	movl   $0xcff200,-0x7fee9e0c(%eax)
80109b67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80109b6a:	05 d0 61 11 80       	add    $0x801161d0,%eax
  pd[1] = (uint)p;
80109b6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80109b73:	c1 e8 10             	shr    $0x10,%eax
80109b76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80109b7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80109b7d:	0f 01 10             	lgdtl  (%eax)
}
80109b80:	c9                   	leave
80109b81:	c3                   	ret
80109b82:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109b89:	00 
80109b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109b90 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80109b90:	a1 e4 91 11 80       	mov    0x801191e4,%eax
80109b95:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109b9a:	0f 22 d8             	mov    %eax,%cr3
}
80109b9d:	c3                   	ret
80109b9e:	66 90                	xchg   %ax,%ax

80109ba0 <switchuvm>:
{
80109ba0:	55                   	push   %ebp
80109ba1:	89 e5                	mov    %esp,%ebp
80109ba3:	57                   	push   %edi
80109ba4:	56                   	push   %esi
80109ba5:	53                   	push   %ebx
80109ba6:	83 ec 1c             	sub    $0x1c,%esp
80109ba9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80109bac:	85 f6                	test   %esi,%esi
80109bae:	0f 84 cb 00 00 00    	je     80109c7f <switchuvm+0xdf>
  if(p->kstack == 0)
80109bb4:	8b 46 08             	mov    0x8(%esi),%eax
80109bb7:	85 c0                	test   %eax,%eax
80109bb9:	0f 84 da 00 00 00    	je     80109c99 <switchuvm+0xf9>
  if(p->pgdir == 0)
80109bbf:	8b 46 04             	mov    0x4(%esi),%eax
80109bc2:	85 c0                	test   %eax,%eax
80109bc4:	0f 84 c2 00 00 00    	je     80109c8c <switchuvm+0xec>
  pushcli();
80109bca:	e8 f1 cc ff ff       	call   801068c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80109bcf:	e8 4c bc ff ff       	call   80105820 <mycpu>
80109bd4:	89 c3                	mov    %eax,%ebx
80109bd6:	e8 45 bc ff ff       	call   80105820 <mycpu>
80109bdb:	89 c7                	mov    %eax,%edi
80109bdd:	e8 3e bc ff ff       	call   80105820 <mycpu>
80109be2:	83 c7 08             	add    $0x8,%edi
80109be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109be8:	e8 33 bc ff ff       	call   80105820 <mycpu>
80109bed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80109bf0:	ba 67 00 00 00       	mov    $0x67,%edx
80109bf5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80109bfc:	83 c0 08             	add    $0x8,%eax
80109bff:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80109c06:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80109c0b:	83 c1 08             	add    $0x8,%ecx
80109c0e:	c1 e8 18             	shr    $0x18,%eax
80109c11:	c1 e9 10             	shr    $0x10,%ecx
80109c14:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80109c1a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80109c20:	b9 99 40 00 00       	mov    $0x4099,%ecx
80109c25:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80109c2c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80109c31:	e8 ea bb ff ff       	call   80105820 <mycpu>
80109c36:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80109c3d:	e8 de bb ff ff       	call   80105820 <mycpu>
80109c42:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80109c46:	8b 5e 08             	mov    0x8(%esi),%ebx
80109c49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80109c4f:	e8 cc bb ff ff       	call   80105820 <mycpu>
80109c54:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80109c57:	e8 c4 bb ff ff       	call   80105820 <mycpu>
80109c5c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80109c60:	b8 28 00 00 00       	mov    $0x28,%eax
80109c65:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80109c68:	8b 46 04             	mov    0x4(%esi),%eax
80109c6b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109c70:	0f 22 d8             	mov    %eax,%cr3
}
80109c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109c76:	5b                   	pop    %ebx
80109c77:	5e                   	pop    %esi
80109c78:	5f                   	pop    %edi
80109c79:	5d                   	pop    %ebp
  popcli();
80109c7a:	e9 91 cc ff ff       	jmp    80106910 <popcli>
    panic("switchuvm: no process");
80109c7f:	83 ec 0c             	sub    $0xc,%esp
80109c82:	68 2e a8 10 80       	push   $0x8010a82e
80109c87:	e8 74 71 ff ff       	call   80100e00 <panic>
    panic("switchuvm: no pgdir");
80109c8c:	83 ec 0c             	sub    $0xc,%esp
80109c8f:	68 59 a8 10 80       	push   $0x8010a859
80109c94:	e8 67 71 ff ff       	call   80100e00 <panic>
    panic("switchuvm: no kstack");
80109c99:	83 ec 0c             	sub    $0xc,%esp
80109c9c:	68 44 a8 10 80       	push   $0x8010a844
80109ca1:	e8 5a 71 ff ff       	call   80100e00 <panic>
80109ca6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109cad:	00 
80109cae:	66 90                	xchg   %ax,%ax

80109cb0 <inituvm>:
{
80109cb0:	55                   	push   %ebp
80109cb1:	89 e5                	mov    %esp,%ebp
80109cb3:	57                   	push   %edi
80109cb4:	56                   	push   %esi
80109cb5:	53                   	push   %ebx
80109cb6:	83 ec 1c             	sub    $0x1c,%esp
80109cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80109cbc:	8b 75 10             	mov    0x10(%ebp),%esi
80109cbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80109cc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80109cc5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80109ccb:	77 49                	ja     80109d16 <inituvm+0x66>
  mem = kalloc();
80109ccd:	e8 9e a8 ff ff       	call   80104570 <kalloc>
  memset(mem, 0, PGSIZE);
80109cd2:	83 ec 04             	sub    $0x4,%esp
80109cd5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80109cda:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80109cdc:	6a 00                	push   $0x0
80109cde:	50                   	push   %eax
80109cdf:	e8 cc d2 ff ff       	call   80106fb0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80109ce4:	58                   	pop    %eax
80109ce5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80109ceb:	5a                   	pop    %edx
80109cec:	6a 06                	push   $0x6
80109cee:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109cf3:	31 d2                	xor    %edx,%edx
80109cf5:	50                   	push   %eax
80109cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80109cf9:	e8 12 fd ff ff       	call   80109a10 <mappages>
  memmove(mem, init, sz);
80109cfe:	83 c4 10             	add    $0x10,%esp
80109d01:	89 75 10             	mov    %esi,0x10(%ebp)
80109d04:	89 7d 0c             	mov    %edi,0xc(%ebp)
80109d07:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80109d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109d0d:	5b                   	pop    %ebx
80109d0e:	5e                   	pop    %esi
80109d0f:	5f                   	pop    %edi
80109d10:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80109d11:	e9 2a d3 ff ff       	jmp    80107040 <memmove>
    panic("inituvm: more than a page");
80109d16:	83 ec 0c             	sub    $0xc,%esp
80109d19:	68 6d a8 10 80       	push   $0x8010a86d
80109d1e:	e8 dd 70 ff ff       	call   80100e00 <panic>
80109d23:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109d2a:	00 
80109d2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80109d30 <loaduvm>:
{
80109d30:	55                   	push   %ebp
80109d31:	89 e5                	mov    %esp,%ebp
80109d33:	57                   	push   %edi
80109d34:	56                   	push   %esi
80109d35:	53                   	push   %ebx
80109d36:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80109d39:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80109d3c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80109d3f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80109d45:	0f 85 a2 00 00 00    	jne    80109ded <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80109d4b:	85 ff                	test   %edi,%edi
80109d4d:	74 7d                	je     80109dcc <loaduvm+0x9c>
80109d4f:	90                   	nop
  pde = &pgdir[PDX(va)];
80109d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80109d53:	8b 55 08             	mov    0x8(%ebp),%edx
80109d56:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80109d58:	89 c1                	mov    %eax,%ecx
80109d5a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80109d5d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80109d60:	f6 c1 01             	test   $0x1,%cl
80109d63:	75 13                	jne    80109d78 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80109d65:	83 ec 0c             	sub    $0xc,%esp
80109d68:	68 87 a8 10 80       	push   $0x8010a887
80109d6d:	e8 8e 70 ff ff       	call   80100e00 <panic>
80109d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80109d78:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80109d7b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80109d81:	25 fc 0f 00 00       	and    $0xffc,%eax
80109d86:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109d8d:	85 c9                	test   %ecx,%ecx
80109d8f:	74 d4                	je     80109d65 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80109d91:	89 fb                	mov    %edi,%ebx
80109d93:	b8 00 10 00 00       	mov    $0x1000,%eax
80109d98:	29 f3                	sub    %esi,%ebx
80109d9a:	39 c3                	cmp    %eax,%ebx
80109d9c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80109d9f:	53                   	push   %ebx
80109da0:	8b 45 14             	mov    0x14(%ebp),%eax
80109da3:	01 f0                	add    %esi,%eax
80109da5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80109da6:	8b 01                	mov    (%ecx),%eax
80109da8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80109dad:	05 00 00 00 80       	add    $0x80000000,%eax
80109db2:	50                   	push   %eax
80109db3:	ff 75 10             	push   0x10(%ebp)
80109db6:	e8 a5 9b ff ff       	call   80103960 <readi>
80109dbb:	83 c4 10             	add    $0x10,%esp
80109dbe:	39 d8                	cmp    %ebx,%eax
80109dc0:	75 1e                	jne    80109de0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80109dc2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80109dc8:	39 fe                	cmp    %edi,%esi
80109dca:	72 84                	jb     80109d50 <loaduvm+0x20>
}
80109dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80109dcf:	31 c0                	xor    %eax,%eax
}
80109dd1:	5b                   	pop    %ebx
80109dd2:	5e                   	pop    %esi
80109dd3:	5f                   	pop    %edi
80109dd4:	5d                   	pop    %ebp
80109dd5:	c3                   	ret
80109dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109ddd:	00 
80109dde:	66 90                	xchg   %ax,%ax
80109de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80109de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109de8:	5b                   	pop    %ebx
80109de9:	5e                   	pop    %esi
80109dea:	5f                   	pop    %edi
80109deb:	5d                   	pop    %ebp
80109dec:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80109ded:	83 ec 0c             	sub    $0xc,%esp
80109df0:	68 84 ab 10 80       	push   $0x8010ab84
80109df5:	e8 06 70 ff ff       	call   80100e00 <panic>
80109dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80109e00 <allocuvm>:
{
80109e00:	55                   	push   %ebp
80109e01:	89 e5                	mov    %esp,%ebp
80109e03:	57                   	push   %edi
80109e04:	56                   	push   %esi
80109e05:	53                   	push   %ebx
80109e06:	83 ec 1c             	sub    $0x1c,%esp
80109e09:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80109e0c:	85 f6                	test   %esi,%esi
80109e0e:	0f 88 98 00 00 00    	js     80109eac <allocuvm+0xac>
80109e14:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80109e16:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109e19:	0f 82 a1 00 00 00    	jb     80109ec0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80109e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109e22:	05 ff 0f 00 00       	add    $0xfff,%eax
80109e27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e2c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80109e2e:	39 f0                	cmp    %esi,%eax
80109e30:	0f 83 8d 00 00 00    	jae    80109ec3 <allocuvm+0xc3>
80109e36:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80109e39:	eb 44                	jmp    80109e7f <allocuvm+0x7f>
80109e3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80109e40:	83 ec 04             	sub    $0x4,%esp
80109e43:	68 00 10 00 00       	push   $0x1000
80109e48:	6a 00                	push   $0x0
80109e4a:	50                   	push   %eax
80109e4b:	e8 60 d1 ff ff       	call   80106fb0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80109e50:	58                   	pop    %eax
80109e51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80109e57:	5a                   	pop    %edx
80109e58:	6a 06                	push   $0x6
80109e5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109e5f:	89 fa                	mov    %edi,%edx
80109e61:	50                   	push   %eax
80109e62:	8b 45 08             	mov    0x8(%ebp),%eax
80109e65:	e8 a6 fb ff ff       	call   80109a10 <mappages>
80109e6a:	83 c4 10             	add    $0x10,%esp
80109e6d:	85 c0                	test   %eax,%eax
80109e6f:	78 5f                	js     80109ed0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80109e71:	81 c7 00 10 00 00    	add    $0x1000,%edi
80109e77:	39 f7                	cmp    %esi,%edi
80109e79:	0f 83 89 00 00 00    	jae    80109f08 <allocuvm+0x108>
    mem = kalloc();
80109e7f:	e8 ec a6 ff ff       	call   80104570 <kalloc>
80109e84:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80109e86:	85 c0                	test   %eax,%eax
80109e88:	75 b6                	jne    80109e40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80109e8a:	83 ec 0c             	sub    $0xc,%esp
80109e8d:	68 a5 a8 10 80       	push   $0x8010a8a5
80109e92:	e8 79 77 ff ff       	call   80101610 <cprintf>
  if(newsz >= oldsz)
80109e97:	83 c4 10             	add    $0x10,%esp
80109e9a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109e9d:	74 0d                	je     80109eac <allocuvm+0xac>
80109e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80109ea5:	89 f2                	mov    %esi,%edx
80109ea7:	e8 a4 fa ff ff       	call   80109950 <deallocuvm.part.0>
    return 0;
80109eac:	31 d2                	xor    %edx,%edx
}
80109eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109eb1:	89 d0                	mov    %edx,%eax
80109eb3:	5b                   	pop    %ebx
80109eb4:	5e                   	pop    %esi
80109eb5:	5f                   	pop    %edi
80109eb6:	5d                   	pop    %ebp
80109eb7:	c3                   	ret
80109eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109ebf:	00 
    return oldsz;
80109ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80109ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109ec6:	89 d0                	mov    %edx,%eax
80109ec8:	5b                   	pop    %ebx
80109ec9:	5e                   	pop    %esi
80109eca:	5f                   	pop    %edi
80109ecb:	5d                   	pop    %ebp
80109ecc:	c3                   	ret
80109ecd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80109ed0:	83 ec 0c             	sub    $0xc,%esp
80109ed3:	68 bd a8 10 80       	push   $0x8010a8bd
80109ed8:	e8 33 77 ff ff       	call   80101610 <cprintf>
  if(newsz >= oldsz)
80109edd:	83 c4 10             	add    $0x10,%esp
80109ee0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80109ee3:	74 0d                	je     80109ef2 <allocuvm+0xf2>
80109ee5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80109ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80109eeb:	89 f2                	mov    %esi,%edx
80109eed:	e8 5e fa ff ff       	call   80109950 <deallocuvm.part.0>
      kfree(mem);
80109ef2:	83 ec 0c             	sub    $0xc,%esp
80109ef5:	53                   	push   %ebx
80109ef6:	e8 b5 a4 ff ff       	call   801043b0 <kfree>
      return 0;
80109efb:	83 c4 10             	add    $0x10,%esp
    return 0;
80109efe:	31 d2                	xor    %edx,%edx
80109f00:	eb ac                	jmp    80109eae <allocuvm+0xae>
80109f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80109f08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80109f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109f0e:	5b                   	pop    %ebx
80109f0f:	5e                   	pop    %esi
80109f10:	89 d0                	mov    %edx,%eax
80109f12:	5f                   	pop    %edi
80109f13:	5d                   	pop    %ebp
80109f14:	c3                   	ret
80109f15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109f1c:	00 
80109f1d:	8d 76 00             	lea    0x0(%esi),%esi

80109f20 <deallocuvm>:
{
80109f20:	55                   	push   %ebp
80109f21:	89 e5                	mov    %esp,%ebp
80109f23:	8b 55 0c             	mov    0xc(%ebp),%edx
80109f26:	8b 4d 10             	mov    0x10(%ebp),%ecx
80109f29:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80109f2c:	39 d1                	cmp    %edx,%ecx
80109f2e:	73 10                	jae    80109f40 <deallocuvm+0x20>
}
80109f30:	5d                   	pop    %ebp
80109f31:	e9 1a fa ff ff       	jmp    80109950 <deallocuvm.part.0>
80109f36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109f3d:	00 
80109f3e:	66 90                	xchg   %ax,%ax
80109f40:	89 d0                	mov    %edx,%eax
80109f42:	5d                   	pop    %ebp
80109f43:	c3                   	ret
80109f44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109f4b:	00 
80109f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80109f50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109f50:	55                   	push   %ebp
80109f51:	89 e5                	mov    %esp,%ebp
80109f53:	57                   	push   %edi
80109f54:	56                   	push   %esi
80109f55:	53                   	push   %ebx
80109f56:	83 ec 0c             	sub    $0xc,%esp
80109f59:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80109f5c:	85 f6                	test   %esi,%esi
80109f5e:	74 59                	je     80109fb9 <freevm+0x69>
  if(newsz >= oldsz)
80109f60:	31 c9                	xor    %ecx,%ecx
80109f62:	ba 00 00 00 80       	mov    $0x80000000,%edx
80109f67:	89 f0                	mov    %esi,%eax
80109f69:	89 f3                	mov    %esi,%ebx
80109f6b:	e8 e0 f9 ff ff       	call   80109950 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109f70:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80109f76:	eb 0f                	jmp    80109f87 <freevm+0x37>
80109f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109f7f:	00 
80109f80:	83 c3 04             	add    $0x4,%ebx
80109f83:	39 fb                	cmp    %edi,%ebx
80109f85:	74 23                	je     80109faa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80109f87:	8b 03                	mov    (%ebx),%eax
80109f89:	a8 01                	test   $0x1,%al
80109f8b:	74 f3                	je     80109f80 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80109f8d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80109f92:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109f95:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80109f98:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80109f9d:	50                   	push   %eax
80109f9e:	e8 0d a4 ff ff       	call   801043b0 <kfree>
80109fa3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109fa6:	39 fb                	cmp    %edi,%ebx
80109fa8:	75 dd                	jne    80109f87 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80109faa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80109fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109fb0:	5b                   	pop    %ebx
80109fb1:	5e                   	pop    %esi
80109fb2:	5f                   	pop    %edi
80109fb3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80109fb4:	e9 f7 a3 ff ff       	jmp    801043b0 <kfree>
    panic("freevm: no pgdir");
80109fb9:	83 ec 0c             	sub    $0xc,%esp
80109fbc:	68 d9 a8 10 80       	push   $0x8010a8d9
80109fc1:	e8 3a 6e ff ff       	call   80100e00 <panic>
80109fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80109fcd:	00 
80109fce:	66 90                	xchg   %ax,%ax

80109fd0 <setupkvm>:
{
80109fd0:	55                   	push   %ebp
80109fd1:	89 e5                	mov    %esp,%ebp
80109fd3:	56                   	push   %esi
80109fd4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80109fd5:	e8 96 a5 ff ff       	call   80104570 <kalloc>
80109fda:	85 c0                	test   %eax,%eax
80109fdc:	74 5e                	je     8010a03c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80109fde:	83 ec 04             	sub    $0x4,%esp
80109fe1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109fe3:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
80109fe8:	68 00 10 00 00       	push   $0x1000
80109fed:	6a 00                	push   $0x0
80109fef:	50                   	push   %eax
80109ff0:	e8 bb cf ff ff       	call   80106fb0 <memset>
80109ff5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80109ff8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80109ffb:	83 ec 08             	sub    $0x8,%esp
80109ffe:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010a001:	8b 13                	mov    (%ebx),%edx
8010a003:	ff 73 0c             	push   0xc(%ebx)
8010a006:	50                   	push   %eax
8010a007:	29 c1                	sub    %eax,%ecx
8010a009:	89 f0                	mov    %esi,%eax
8010a00b:	e8 00 fa ff ff       	call   80109a10 <mappages>
8010a010:	83 c4 10             	add    $0x10,%esp
8010a013:	85 c0                	test   %eax,%eax
8010a015:	78 19                	js     8010a030 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010a017:	83 c3 10             	add    $0x10,%ebx
8010a01a:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
8010a020:	75 d6                	jne    80109ff8 <setupkvm+0x28>
}
8010a022:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010a025:	89 f0                	mov    %esi,%eax
8010a027:	5b                   	pop    %ebx
8010a028:	5e                   	pop    %esi
8010a029:	5d                   	pop    %ebp
8010a02a:	c3                   	ret
8010a02b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
8010a030:	83 ec 0c             	sub    $0xc,%esp
8010a033:	56                   	push   %esi
8010a034:	e8 17 ff ff ff       	call   80109f50 <freevm>
      return 0;
8010a039:	83 c4 10             	add    $0x10,%esp
}
8010a03c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010a03f:	31 f6                	xor    %esi,%esi
}
8010a041:	89 f0                	mov    %esi,%eax
8010a043:	5b                   	pop    %ebx
8010a044:	5e                   	pop    %esi
8010a045:	5d                   	pop    %ebp
8010a046:	c3                   	ret
8010a047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010a04e:	00 
8010a04f:	90                   	nop

8010a050 <kvmalloc>:
{
8010a050:	55                   	push   %ebp
8010a051:	89 e5                	mov    %esp,%ebp
8010a053:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010a056:	e8 75 ff ff ff       	call   80109fd0 <setupkvm>
8010a05b:	a3 e4 91 11 80       	mov    %eax,0x801191e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010a060:	05 00 00 00 80       	add    $0x80000000,%eax
8010a065:	0f 22 d8             	mov    %eax,%cr3
}
8010a068:	c9                   	leave
8010a069:	c3                   	ret
8010a06a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

8010a070 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010a070:	55                   	push   %ebp
8010a071:	89 e5                	mov    %esp,%ebp
8010a073:	83 ec 08             	sub    $0x8,%esp
8010a076:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
8010a079:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010a07c:	89 c1                	mov    %eax,%ecx
8010a07e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010a081:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
8010a084:	f6 c2 01             	test   $0x1,%dl
8010a087:	75 17                	jne    8010a0a0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010a089:	83 ec 0c             	sub    $0xc,%esp
8010a08c:	68 ea a8 10 80       	push   $0x8010a8ea
8010a091:	e8 6a 6d ff ff       	call   80100e00 <panic>
8010a096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010a09d:	00 
8010a09e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
8010a0a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010a0a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
8010a0a9:	25 fc 0f 00 00       	and    $0xffc,%eax
8010a0ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
8010a0b5:	85 c0                	test   %eax,%eax
8010a0b7:	74 d0                	je     8010a089 <clearpteu+0x19>
  *pte &= ~PTE_U;
8010a0b9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010a0bc:	c9                   	leave
8010a0bd:	c3                   	ret
8010a0be:	66 90                	xchg   %ax,%ax

8010a0c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010a0c0:	55                   	push   %ebp
8010a0c1:	89 e5                	mov    %esp,%ebp
8010a0c3:	57                   	push   %edi
8010a0c4:	56                   	push   %esi
8010a0c5:	53                   	push   %ebx
8010a0c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010a0c9:	e8 02 ff ff ff       	call   80109fd0 <setupkvm>
8010a0ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010a0d1:	85 c0                	test   %eax,%eax
8010a0d3:	0f 84 e9 00 00 00    	je     8010a1c2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010a0d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010a0dc:	85 c9                	test   %ecx,%ecx
8010a0de:	0f 84 b2 00 00 00    	je     8010a196 <copyuvm+0xd6>
8010a0e4:	31 f6                	xor    %esi,%esi
8010a0e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010a0ed:	00 
8010a0ee:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
8010a0f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
8010a0f3:	89 f0                	mov    %esi,%eax
8010a0f5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
8010a0f8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010a0fb:	a8 01                	test   $0x1,%al
8010a0fd:	75 11                	jne    8010a110 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010a0ff:	83 ec 0c             	sub    $0xc,%esp
8010a102:	68 f4 a8 10 80       	push   $0x8010a8f4
8010a107:	e8 f4 6c ff ff       	call   80100e00 <panic>
8010a10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
8010a110:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010a112:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010a117:	c1 ea 0a             	shr    $0xa,%edx
8010a11a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
8010a120:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010a127:	85 c0                	test   %eax,%eax
8010a129:	74 d4                	je     8010a0ff <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010a12b:	8b 00                	mov    (%eax),%eax
8010a12d:	a8 01                	test   $0x1,%al
8010a12f:	0f 84 9f 00 00 00    	je     8010a1d4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010a135:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010a137:	25 ff 0f 00 00       	and    $0xfff,%eax
8010a13c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010a13f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010a145:	e8 26 a4 ff ff       	call   80104570 <kalloc>
8010a14a:	89 c3                	mov    %eax,%ebx
8010a14c:	85 c0                	test   %eax,%eax
8010a14e:	74 64                	je     8010a1b4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010a150:	83 ec 04             	sub    $0x4,%esp
8010a153:	81 c7 00 00 00 80    	add    $0x80000000,%edi
8010a159:	68 00 10 00 00       	push   $0x1000
8010a15e:	57                   	push   %edi
8010a15f:	50                   	push   %eax
8010a160:	e8 db ce ff ff       	call   80107040 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010a165:	58                   	pop    %eax
8010a166:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010a16c:	5a                   	pop    %edx
8010a16d:	ff 75 e4             	push   -0x1c(%ebp)
8010a170:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010a175:	89 f2                	mov    %esi,%edx
8010a177:	50                   	push   %eax
8010a178:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a17b:	e8 90 f8 ff ff       	call   80109a10 <mappages>
8010a180:	83 c4 10             	add    $0x10,%esp
8010a183:	85 c0                	test   %eax,%eax
8010a185:	78 21                	js     8010a1a8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010a187:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010a18d:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010a190:	0f 82 5a ff ff ff    	jb     8010a0f0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
8010a196:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a199:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010a19c:	5b                   	pop    %ebx
8010a19d:	5e                   	pop    %esi
8010a19e:	5f                   	pop    %edi
8010a19f:	5d                   	pop    %ebp
8010a1a0:	c3                   	ret
8010a1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
8010a1a8:	83 ec 0c             	sub    $0xc,%esp
8010a1ab:	53                   	push   %ebx
8010a1ac:	e8 ff a1 ff ff       	call   801043b0 <kfree>
      goto bad;
8010a1b1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
8010a1b4:	83 ec 0c             	sub    $0xc,%esp
8010a1b7:	ff 75 e0             	push   -0x20(%ebp)
8010a1ba:	e8 91 fd ff ff       	call   80109f50 <freevm>
  return 0;
8010a1bf:	83 c4 10             	add    $0x10,%esp
    return 0;
8010a1c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010a1c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010a1cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010a1cf:	5b                   	pop    %ebx
8010a1d0:	5e                   	pop    %esi
8010a1d1:	5f                   	pop    %edi
8010a1d2:	5d                   	pop    %ebp
8010a1d3:	c3                   	ret
      panic("copyuvm: page not present");
8010a1d4:	83 ec 0c             	sub    $0xc,%esp
8010a1d7:	68 0e a9 10 80       	push   $0x8010a90e
8010a1dc:	e8 1f 6c ff ff       	call   80100e00 <panic>
8010a1e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010a1e8:	00 
8010a1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

8010a1f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010a1f0:	55                   	push   %ebp
8010a1f1:	89 e5                	mov    %esp,%ebp
8010a1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
8010a1f6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010a1f9:	89 c1                	mov    %eax,%ecx
8010a1fb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010a1fe:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
8010a201:	f6 c2 01             	test   $0x1,%dl
8010a204:	0f 84 f8 00 00 00    	je     8010a302 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010a20a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010a20d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
8010a213:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
8010a214:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
8010a219:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010a220:	89 d0                	mov    %edx,%eax
8010a222:	f7 d2                	not    %edx
8010a224:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a229:	05 00 00 00 80       	add    $0x80000000,%eax
8010a22e:	83 e2 05             	and    $0x5,%edx
8010a231:	ba 00 00 00 00       	mov    $0x0,%edx
8010a236:	0f 45 c2             	cmovne %edx,%eax
}
8010a239:	c3                   	ret
8010a23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

8010a240 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a240:	55                   	push   %ebp
8010a241:	89 e5                	mov    %esp,%ebp
8010a243:	57                   	push   %edi
8010a244:	56                   	push   %esi
8010a245:	53                   	push   %ebx
8010a246:	83 ec 0c             	sub    $0xc,%esp
8010a249:	8b 75 14             	mov    0x14(%ebp),%esi
8010a24c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a24f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a252:	85 f6                	test   %esi,%esi
8010a254:	75 51                	jne    8010a2a7 <copyout+0x67>
8010a256:	e9 9d 00 00 00       	jmp    8010a2f8 <copyout+0xb8>
8010a25b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
8010a260:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010a266:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010a26c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
8010a272:	74 74                	je     8010a2e8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
8010a274:	89 fb                	mov    %edi,%ebx
8010a276:	29 c3                	sub    %eax,%ebx
8010a278:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010a27e:	39 f3                	cmp    %esi,%ebx
8010a280:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010a283:	29 f8                	sub    %edi,%eax
8010a285:	83 ec 04             	sub    $0x4,%esp
8010a288:	01 c1                	add    %eax,%ecx
8010a28a:	53                   	push   %ebx
8010a28b:	52                   	push   %edx
8010a28c:	89 55 10             	mov    %edx,0x10(%ebp)
8010a28f:	51                   	push   %ecx
8010a290:	e8 ab cd ff ff       	call   80107040 <memmove>
    len -= n;
    buf += n;
8010a295:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
8010a298:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010a29e:	83 c4 10             	add    $0x10,%esp
    buf += n;
8010a2a1:	01 da                	add    %ebx,%edx
  while(len > 0){
8010a2a3:	29 de                	sub    %ebx,%esi
8010a2a5:	74 51                	je     8010a2f8 <copyout+0xb8>
  if(*pde & PTE_P){
8010a2a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010a2aa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010a2ac:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010a2ae:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010a2b1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
8010a2b7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010a2ba:	f6 c1 01             	test   $0x1,%cl
8010a2bd:	0f 84 46 00 00 00    	je     8010a309 <copyout.cold>
  return &pgtab[PTX(va)];
8010a2c3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010a2c5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010a2cb:	c1 eb 0c             	shr    $0xc,%ebx
8010a2ce:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
8010a2d4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010a2db:	89 d9                	mov    %ebx,%ecx
8010a2dd:	f7 d1                	not    %ecx
8010a2df:	83 e1 05             	and    $0x5,%ecx
8010a2e2:	0f 84 78 ff ff ff    	je     8010a260 <copyout+0x20>
  }
  return 0;
}
8010a2e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010a2eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010a2f0:	5b                   	pop    %ebx
8010a2f1:	5e                   	pop    %esi
8010a2f2:	5f                   	pop    %edi
8010a2f3:	5d                   	pop    %ebp
8010a2f4:	c3                   	ret
8010a2f5:	8d 76 00             	lea    0x0(%esi),%esi
8010a2f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010a2fb:	31 c0                	xor    %eax,%eax
}
8010a2fd:	5b                   	pop    %ebx
8010a2fe:	5e                   	pop    %esi
8010a2ff:	5f                   	pop    %edi
8010a300:	5d                   	pop    %ebp
8010a301:	c3                   	ret

8010a302 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010a302:	a1 00 00 00 00       	mov    0x0,%eax
8010a307:	0f 0b                	ud2

8010a309 <copyout.cold>:
8010a309:	a1 00 00 00 00       	mov    0x0,%eax
8010a30e:	0f 0b                	ud2
